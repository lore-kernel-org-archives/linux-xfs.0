Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 12:04:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OJ3uaG029322
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 12:03:57 -0700
Received: from postal1.et.byu.edu (postal1.et.byu.edu [128.187.48.11])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 379AB4D25F0
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 12:03:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by postal1.et.byu.edu (Postfix) with ESMTP id 4BFB951C4A
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 13:03:07 -0600 (MDT)
Received: from postal1.et.byu.edu ([127.0.0.1])
	by localhost (postal1.et.byu.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 30592-07 for <xfs@oss.sgi.com>;
	Tue, 24 Oct 2006 13:03:06 -0600 (MDT)
Received: from lewis.et.byu.edu (lewis.et.byu.edu [10.5.113.201])
	by postal1.et.byu.edu (Postfix) with ESMTP id C354851C15
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 13:03:06 -0600 (MDT)
Date: Tue, 24 Oct 2006 13:03:06 -0600 (MDT)
From: David Dougall <davidd@et.byu.edu>
Subject: Re: kernel panic after upgrading to 2.6
In-Reply-To: <Pine.LNX.4.58.0610241113090.8370@lewis.et.byu.edu>
Message-ID: <Pine.LNX.4.58.0610241302190.8370@lewis.et.byu.edu>
References: <Pine.LNX.4.58.0610240938400.8370@lewis.et.byu.edu>
 <453E494F.8080808@sandeen.net> <Pine.LNX.4.58.0610241113090.8370@lewis.et.byu.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Here is another kernel panic this morning on another server.  I can't even
tell if they are related at all.
--David Dougall



Oct 24 12:00:51 nfs08 kernel: Filesystem "dm-0": XFS internal error
xfs_trans_ca
ncel at line 1138 of file fs/xfs/xfs_trans.c.  Caller 0xc026030c
Oct 24 12:00:51 nfs08 kernel:  [<c026edb4>] xfs_trans_cancel+0xf1/0x112
Oct 24 12:00:51 nfs08 kernel:  [<c026030c>]
xfs_iomap_write_allocate+0x417/0x56b
Oct 24 12:00:51 nfs08 kernel:  [<c026030c>]
xfs_iomap_write_allocate+0x417/0x56b
Oct 24 12:00:51 nfs08 kernel:  [<c025eac6>] xfs_iomap+0x616/0x835
Oct 24 12:00:51 nfs08 kernel:  [<c027c028>] xfs_map_blocks+0x39/0x50
Oct 24 12:00:51 nfs08 kernel:  [<c027ce92>]
xfs_page_state_convert+0x5ed/0xee1
Oct 24 12:00:51 nfs08 kernel:  [<c0118463>] __do_softirq+0x3e/0x86
Oct 24 12:00:51 nfs08 kernel:  [<c027d88a>] xfs_vm_writepage+0x57/0xdd
Oct 24 12:00:51 nfs08 kernel:  [<c027d833>] xfs_vm_writepage+0x0/0xdd
Oct 24 12:00:51 nfs08 kernel:  [<c0167e92>] mpage_writepages+0x212/0x3c1
Oct 24 12:00:51 nfs08 kernel:  [<c034cf60>] dst_output+0x0/0x7
Oct 24 12:00:51 nfs08 kernel:  [<c027d833>] xfs_vm_writepage+0x0/0xdd
Oct 24 12:00:51 nfs08 kernel:  [<c013469f>] do_writepages+0x23/0x3b
Oct 24 12:00:51 nfs08 kernel:  [<c012f2b6>]
__filemap_fdatawrite_range+0x66/0x72
Oct 24 12:00:51 nfs08 kernel:  [<c01300a6>] filemap_fdatawrite+0x23/0x27
Oct 24 12:00:51 nfs08 kernel:  [<c01f9143>] nfsd_sync+0x3e/0x96
Oct 24 12:00:51 nfs08 kernel:  [<c01f9d66>] nfsd_open+0x117/0x15d
Oct 24 12:00:51 nfs08 kernel:  [<c01f9efb>] nfsd_commit+0x80/0xb7
Oct 24 12:00:51 nfs08 kernel:  [<c0201abd>]
nfs3svc_decode_commitargs+0x0/0xc1
Oct 24 12:00:51 nfs08 kernel:  [<c02003f4>] nfsd3_proc_commit+0xde/0xf7
Oct 24 12:00:51 nfs08 kernel:  [<c0201abd>]
nfs3svc_decode_commitargs+0x0/0xc1
Oct 24 12:00:51 nfs08 kernel:  [<c01f66db>] nfsd_dispatch+0x76/0x1b7
Oct 24 12:00:51 nfs08 kernel:  [<c0384447>] svc_process+0x3d5/0x68e
Oct 24 12:00:51 nfs08 kernel:  [<c0385864>] svc_recv+0x22b/0x47f
Oct 24 12:00:51 nfs08 kernel:  [<c01f6996>] nfsd+0x17a/0x304
Oct 24 12:00:51 nfs08 kernel:  [<c0102c02>] work_resched+0x5/0x16
Oct 24 12:00:51 nfs08 kernel:  [<c01f681c>] nfsd+0x0/0x304
Oct 24 12:00:51 nfs08 kernel:  [<c0101005>] kernel_thread_helper+0x5/0xb
Oct 24 12:00:51 nfs08 kernel: xfs_force_shutdown(dm-0,0x8) called from
line 1139
 of file fs/xfs/xfs_trans.c.  Return address = 0xc02854d0
Oct 24 12:00:51 nfs08 kernel: Filesystem "dm-0": Corruption of in-memory
data de
tected.  Shutting down filesystem: dm-0
Oct 24 12:00:51 nfs08 kernel: Please umount the filesystem, and rectify
the prob
lem(s)
Oct 24 12:00:52 nfs08 kernel: BUG: unable to handle kernel NULL pointer
derefere
nce at virtual address 0000030c
Oct 24 12:00:52 nfs08 kernel:  printing eip:
Oct 24 12:01:55 nfs08 kernel: c026e723
Oct 24 12:03:49 nfs08 syslogd 1.4.1#18: restart.


On Tue, 24 Oct 2006, David Dougall wrote:

> I actually did see that bug report.  That is why I have tried upgrading
> now a few times.  I have run xfs_repair on all of my file systems since
> upgrading this past time and I still get kernel panics.  I already have
> 2.8.10 as far as I can tell.  2.8.10-1 on debian.
> --David Dougall
>
>
> On Tue, 24 Oct 2006, Eric Sandeen wrote:
>
> > David Dougall wrote:
> > > I am running kernel 2.6.18 after trying 2.6.17.6 and 2.6.17.13 with
> > > similar results.  I continue to have nfs servers kernel panic on a very
> > > regular basis, every few days.  Sometimes I need to do an xfs_repair to
> > > get the filesystem to remount.  I got the following kernel panic message
> > > from the syslog this time:
> > > Message from syslogd@nfs09 at Tue Oct 24 09:35:14 2006 ...
> > > nfs09 kernel: Oops: 0000 [#1]
> >
> > If you ran 2.6.17 < 2.6.17.7, there was a bug:
> >
> > http://oss.sgi.com/projects/xfs/faq.html#dir2
> >
> > I would suggest getting xfsprogs v. 2.8.10 or newer, as referenced in
> > the faq, repair your filesystem, and see if the problem is resolved.
> >
> > -Eric
> >
> >
> >
>
