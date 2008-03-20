Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 01:25:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K8PosV008974
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 01:25:51 -0700
Received: from knox.decisionsoft.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DBBE6C506E
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 01:26:22 -0700 (PDT)
Received: from knox.decisionsoft.com (knox-be.decisionsoft.com [87.194.172.100]) by cuda.sgi.com with ESMTP id UTEcMgNb3XXiM9fW for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 01:26:22 -0700 (PDT)
Date: Thu, 20 Mar 2008 08:25:46 +0000 (GMT)
From: Stuart Rowan <strr@decisionsoft.com>
Subject: XFS internal error xfs_itobp at line 360 of file fs/xfs/xfs_inode.c.
 (was Re: 2.6.24.3 nfs server on xfs keeps producing nfsd: non-standard errno:
 -117)
In-Reply-To: <47E1B939.3060008@sgi.com>
Message-ID: <alpine.DEB.1.00.0803200812450.4712@tugela.dsl.local>
References: <47DEFE5E.4030703@decisionsoft.co.uk> <47DF0C9D.1010602@sgi.com> <47DFC880.6040403@decisionsoft.co.uk> <47E1B939.3060008@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: strr-debian@decisionsoft.co.uk, xfs@oss.sgi.com



On Thu, 20 Mar 2008, Timothy Shimmin wrote:

> Stuart Rowan wrote:
>> Timothy Shimmin wrote, on 18/03/08 00:28:
>>> Hi Stuart,
>>> 
>>> Stuart Rowan wrote:
>>>> 
>>>> I have *millions* of lines of (>200k per minute according to syslog):
>>>> nfsd: non-standard errno: -117
>>>> being sent out of dmesg
>>>> 
>>>> Now errno 117 is
>>>> #define EUCLEAN         117     /* Structure needs cleaning */
>>>> 
>>> In XFS we mapped EFSCORRUPTED to EUCLEAN as EFSCORRUPTED
>>> didn't exist on Linux.
>>> However, normally if this error is encountered in XFS then
>>> we output an appropriate msg to the syslog.
>>> Our default error level is 3 and most reports are rated at 1
>>> so should show up I would have thought.
>>> 
>>> --Tim
>>> 
>>>> 
>>>> xfs_repair -n says the filesystems are clean
>>>> xfs_repair has been run multiple times to completion on the filesystems, 
>>>> all is fine.
>>>> 
>>>> The NFS server is currently in use (indeed the message only starts once 
>>>> clients connect) and works absolutely fine.
>>>> 
>>>> How do I find out what (if anything) is wrong with my filesystem / 
>>>> appropriately silence this message?
>>>> 
>>> 
>> I briefly changed the sysctl fs.xfs.error_level to 6 and then back to 3
>> 
> Good idea (I was thinking about that :-).
>
> Somehow, your subject line referring to 2.6.24 didn't stick in
> my brain (that's pretty old).
> So I was looking at recent code which I can't see has this error
> case from xfs_itobp() (it is now in xfs_imap_to_bp()).
>
Pretty old for you, latest released Linux kernel to me :-P

> Looking at old code, I see 2 EFSCORRUPTED paths with the following
> one triggering at XFS_ERRLEVEL_HIGH (and presumably why you didn't
> see it until now) ...
>
> montep    |1.198|                            |  /*
> montep    |1.198|                            |   * Validate the magic number 
> and version of every inode in the buffer
> montep    |1.198|                            |   * (if DEBUG kernel) or the 
> first inode in the buffer, otherwise.
> montep    |1.198|                            |   */
> nathans   |1.303|2.4.x-xfs:slinx:74929a      |#ifdef DEBUG
> montep    |1.198|                            |  ni = BBTOB(imap.im_len) >> 
> mp->m_sb.sb_inodelog;
> montep    |1.198|                            |#else
> montep    |1.198|                            |  ni = 1;
> montep    |1.198|                            |#endif
> montep    |1.198|                            |  for (i = 0; i < ni; i++) {
> doucette  |1.245|irix6.5f:irix:09146b        |          int 
> di_ok;
> doucette  |1.245|irix6.5f:irix:09146b        |          xfs_dinode_t    *dip;
> doucette  |1.245|irix6.5f:irix:09146b        |
> lord      |1.292|2.4.0-test1-xfs:slinx:65571a|          dip = (xfs_dinode_t 
> *)xfs_buf_offset(bp,
> montep    |1.198|                            | 
> (i << mp->m_sb.sb_inodelog));
> dxm       |1.285|2.4.0-test1-xfs:slinx:62350a|          di_ok = 
> INT_GET(dip->di_core.di_magic, ARCH_CONVERT) == XFS_DINODE_MAGIC &&
> dxm       |1.285|2.4.0-test1-xfs:slinx:62350a| 
> XFS_DINODE_GOOD_VERSION(INT_GET(dip->di_core.di_version, ARCH_CONVERT));
> overby    |1.362|2.4.x-xfs:slinx:136445a     |          if 
> (unlikely(XFS_TEST_ERROR(!di_ok, mp, XFS_ERRTAG_ITOBP_INOTOBP,
> overby    |1.362|2.4.x-xfs:slinx:136445a     | 
> XFS_RANDOM_ITOBP_INOTOBP))) {
> montep    |1.198|                            |#ifdef DEBUG
> nathans   |1.337|2.4.x-xfs:slinx:119399a     |                  prdev("bad 
> inode magic/vsn daddr 0x%llx #%d (magic=%x)",
> nathans   |1.337|2.4.x-xfs:slinx:119399a     | 
> mp->m_dev, (unsigned long long)imap.im_blkno, i,
> nathans   |1.303|2.4.x-xfs:slinx:74929a      | 
> INT_GET(dip->di_core.di_magic, ARCH_CONVERT));
> montep    |1.198|                            |#endif
> lord      |1.376|2.4.x-xfs:slinx:150747a     | 
> XFS_CORRUPTION_ERROR("xfs_itobp", XFS_ERRLEVEL_HIGH,
> overby    |1.362|2.4.x-xfs:slinx:136445a     | 
> mp, dip);
> montep    |1.198|                            | 
> xfs_trans_brelse(tp, bp);
> sup       |1.216|                            |                  return 
> XFS_ERROR(EFSCORRUPTED);
> montep    |1.198|                            |          }
> ajs       |1.143|                            |  }
>
> So the first inode in the buffer has the wrong magic# or version#.
> I'm surprised that this wasn't picked up by repair or check.
>
> --Tim
>
I have some more information! The server, evenlode, was previously serving 
NFS exports of ext3 filesystems. Last week we rsycned the data to the new 
server running XFS.

Eventually I spotted the high error rate was linked to the volume of NFS 
read calls (200k / minute). A quick tcpdump gave me a couple of likely 
looking hosts. I logged into one (bonny) and found gnome-panel using 100% 
CPU. I killed that and these messages have now reduced to a handful an 
hour. That gnome-panel will have had the NFS server and underlying NFS 
backing filesystem (ext3-> XFS) changed underneath it.

So my questions ...

Is it possible that the errors are related to duff request data being sent 
by the NFS clients because they are still referencing e.g. inodes as they 
were when the NFS server was ext3 backed?

Is it also possible that things like the rather high request rate 
(200k/sec) although that's reduced now, made a race in e.g. the XFS code 
triggerable?

As you say, it's rather suprising that this sort of issue is not being 
caught by xfs_repair (-n) and that's what leads me to suspect something 
else at play ...

Cheers,
Stu.

>> It gives the following message and backtrace
>> 
>>> Mar 18 13:35:15 evenlode kernel: nfsd: non-standard errno: -117
>>> Mar 18 13:35:15 evenlode kernel: 0x0: 00 00 00 00 00 00 00 00 00 00 00 00 
>>> 00 00 00 00 Mar 18 13:35:15 evenlode kernel: Filesystem "dm-0": XFS 
>>> internal error xfs_itobp at line 360 of file fs/xfs/xfs_inode.c.  Caller 
>>> 0xffffffff8821224d
>>> Mar 18 13:35:15 evenlode kernel: Pid: 2791, comm: nfsd Not tainted 
>>> 2.6.24.3-generic #1
>>> Mar 18 13:35:15 evenlode kernel: Mar 18 13:35:15 evenlode kernel: Call 
>>> Trace:
>>> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8821224d>] 
>>> :xfs:xfs_iread+0x71/0x1e8
>>> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8820f784>] 
>>> :xfs:xfs_itobp+0x141/0x17b
>>> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8821224d>] 
>>> :xfs:xfs_iread+0x71/0x1e8
>>> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8821224d>] 
>>> :xfs:xfs_iread+0x71/0x1e8
>>> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8820d7c9>] 
>>> :xfs:xfs_iget_core+0x352/0x63a
>>> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8029095f>] 
>>> alloc_inode+0x152/0x1c2
>>> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8820db4c>] 
>>> :xfs:xfs_iget+0x9b/0x13f
>>> Mar 18 13:35:15 evenlode kernel:  [<ffffffff882243d1>] 
>>> :xfs:xfs_vget+0x4d/0xbb
>> 
>> 
>> Does that help?
>> 
>> Thanks,
>> Stu.
>
>
>
