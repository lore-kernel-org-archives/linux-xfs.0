Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6DExDnC055195 for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 09:59:13 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1A4D135A8A2
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 07:59:51 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id inOqeoSrgmenwX24 for
	<xfs@oss.sgi.com>; Mon, 13 Jul 2009 07:59:51 -0700 (PDT)
Message-ID: <4A5B4BE4.9010702@sandeen.net>
Date: Mon, 13 Jul 2009 09:59:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO error
References: <5770aa2a0907122312n18db5784x8b5c8f6743c75136@mail.gmail.com>
In-Reply-To: <5770aa2a0907122312n18db5784x8b5c8f6743c75136@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lance Reed <lreed@brightcove.com>
Cc: syseng <syseng@brightcove.com>, xfs@oss.sgi.com

Lance Reed wrote:
> Hello,
> 
> We currently have a problem with a running XFS file system.
> 
> Specifically the XFS internal error XFS_WANT_CORRUPTED_GOTO errors showed up.
> 
> The Filesystem is 4.6 TB (LVM) and was originally created and mounted
> on a 32 bit Linux system.
> Do to problems with earlier versions of XFS, the HEAD node was
> upgraded to a 64 bit system with the following attributes:
> 
> CentOS release 5.3 (Final)
> 2.6.18-128.1.10.el5   x86_64

Unfortunately this is pretty old xfs code.

> XFS:
> xfsdump-2.2.46-1.el5.centos
> xfsprogs-2.9.4-1.el5.centos
> kmod-xfs-0.4-2
> lvm2-2.02.40-6.el5

well, that is pretty old xfs code ;)  xfsprogs isn't too bad.  it'd be
trivial to grab a newer xfsprogs src.rpm from fedora & rebuild it.

...

> I am posting to see if there is any updated info on the process to
> recover form the XFS_WANT_CORRUPTED_GOT.

First I would suggest xfs_repair.

> Similar posts seem to indicate that there is a possibility that every
> file can wind up in lost+found if not careful when running a
> xfs_repair.  I would like to confirm if there are any XFS prog updates
> or changes that might work better with the kernel version etc we are
> running.  This system is in use but is also a testing ground for a
> production system so any updates on version issues etc. would be
> greatly appreciated.
> 
> We have the following error in logs.
> 
> Jul 11 04:01:36 qanfs2 kernel: svc: unknown version (0 for prog 100003 nfsd)
> Jul 11 04:04:12 qanfs2 kernel: XFS internal error
> XFS_WANT_CORRUPTED_GOTO at line 872 of file
> /home/buildsvn/rpmbuild/BUILD/xf
> s-kmod-0.4/_kmod_build_/xfs_ialloc.c.  Caller 0xffffffff88503944

...

> 
> The closest post I could find on the problem was:
> http://www.opensubscriber.com/message/xfs@oss.sgi.com/8729803.html
> 
> I don't think I am hitting the  directory corruption in Linux 2.6.17
> since the kernel version is 2.6.18-128.1.10.el5, but maybe there is
> something else?

that should have been fixed by .18 IIRC

> The course of action I plan to take with confirmation is from the above post:
> 
>>>> To be on the safe side, either make an entire copy of your drive to
>>>> another device, or run "xfs_metadump -o /dev/sda1" to capture
>>>> a metadata (no file data) of your filesystem.
>>>>
>>>> Then run xfs_repair (mount/unmount maybe required if the log is dirty).
> 
> I can't make a copy of the data since it is 4+TB.   Can someone give
> me an idea on the size of the file output from the xfs_metadump
> command?

it will be much much smaller.

To test what repair would do, try this.

Unmount the filesystem.
# xfs_metadump -o /dev/blah filesystem.metadump
# xfs_mdrestore filesytem.metadump filesystem.img
# xfs_repair filesystem.img
# mount -o loop filesystem.img /some/where

see how it goes, both during repair, and what you see on the resulting
filesystem (it'll be metadata only, any files you read from that image
will be full of 0s)

> Also, If everything does wind up in lost+found after running
> xfs_repair, is there an efficient way to put the files back in there
> correct locations if the Filesystem can repaired?

Well, try the metadump trick first to see, we can worry about that later.

> We did have a split brain problem earlier in the week with heartbeat,
> however, mounting of the disk after restart did not show any problems
> at the time.

well if 2 nodes mounted the same fs, it could certainly cause problems.  :)

-Eric

> Thanks very much in advance for any assistance to correct this problem.
> 
> Thanks,
> 
> Lance

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
