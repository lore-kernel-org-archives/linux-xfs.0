Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Jul 2008 12:28:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6PJSkpc017441
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 12:28:46 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D115432FC05
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 12:29:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id QUwhRtre2XXzrU4S for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 12:29:56 -0700 (PDT)
Message-ID: <488A29B0.9090804@sandeen.net>
Date: Fri, 25 Jul 2008 14:29:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Help with XFS...
References: <d4c731da0807251224m2632838bme52760a8a29c8871@mail.gmail.com>
In-Reply-To: <d4c731da0807251224m2632838bme52760a8a29c8871@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bernard Li <bernard@vanhpc.org>, xfs-oss <xfs@oss.sgi.com>

Bernard Li wrote:
> Hi Eric:

You should just send this to the list (cc'd), many more eyes will see it
and might have better suggestions.

In general though if the log won't replay on mount, xfs_repair -L is the
thing.

since you're on devicemapper, you probably got burned by the lack of
barriers / ordered write support in dm, and that led to your
unreplayable log corruption when you lost power.

Going forward, I'd suggest that a UPS would be a good investment.

-Eric

> Sorry for writing you directly, but I figure you're probably the best
> person I could ask, regarding this issue.  So if you have some time, I
> would appreciate some feedback from you, thanks!
> 
> So we had a power outage and upon bringing up a file server, we can no
> longer mount a XFS partition:
> 
> mount: Structure needs cleaning
> 
> and we got the following in /var/log/messages:
> 
> Jul 25 11:48:52 vus-sxmail-v032 kernel: XFS mounting filesystem dm-7
> Jul 25 11:48:52 vus-sxmail-v032 kernel: Starting XFS recovery on
> filesystem: dm-7 (logdev: internal)
> Jul 25 11:48:52 vus-sxmail-v032 kernel: Filesystem "dm-7": XFS
> internal error xlog_valid_rec_header(1) at line 3449 of file
> fs/xfs/xfs_log_recover.c.  Caller 0xf8e833bb
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e80dcd>]
> xlog_valid_rec_header+0xcd/0xd9 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e833bb>]
> xlog_do_recovery_pass+0x21f/0x79d [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e833bb>]
> xlog_do_recovery_pass+0x21f/0x79d [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c012682d>]
> autoremove_wake_function+0xd/0x2d
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c0279d18>] schedule+0x4c2/0x538
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e8396d>]
> xlog_do_log_recovery+0x34/0x94 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e839df>]
> xlog_do_recover+0x12/0xf3 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e83b35>]
> xlog_recover+0x75/0x84 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e7e165>]
> xfs_log_mount+0x96/0xce [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e8559e>]
> xfs_mountfs+0x87f/0xaf9 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e93dc1>]
> xfs_setsize_buftarg_flags+0x2a/0x89 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e9417b>]
> xfs_buf_rele+0x21/0x5f [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e84af6>]
> xfs_readsb+0x17c/0x198 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e8b811>]
> xfs_mount+0x2e1/0x357 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e8b530>] xfs_mount+0x0/0x357 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e9a3df>] vfs_mount+0x17/0x1a [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e9a2bb>]
> xfs_fs_fill_super+0x68/0x175 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c01abdee>] snprintf+0x1c/0x1f
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c017c607>] disk_name+0x1f/0x60
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c015567e>] get_sb_bdev+0xc6/0x10e
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c013bcf1>] __alloc_pages+0x57/0x297
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e99753>]
> xfs_fs_get_sb+0xe/0x11 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<f8e9a253>]
> xfs_fs_fill_super+0x0/0x175 [xfs]
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c0155483>] do_kern_mount+0x8f/0x13d
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c0166a24>] do_mount+0x5fa/0x648
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c0165e2c>] mntput_no_expire+0x11/0x62
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c015c6b5>] link_path_walk+0xaf/0xb9
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c01626f1>] dput+0x22/0x113
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c0165e2c>] mntput_no_expire+0x11/0x62
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c01420d1>]
> __handle_mm_fault+0x7dd/0x7f3
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c013ba6c>]
> get_page_from_freelist+0x6f/0x29d
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c027b7fb>] do_page_fault+0x16c/0x51e
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c0165a75>]
> copy_mount_options+0x26/0x109
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c0166ad6>] sys_mount+0x64/0x97
> Jul 25 11:48:52 vus-sxmail-v032 kernel:  [<c010299b>]
> sysenter_past_esp+0x54/0x79
> Jul 25 11:48:52 vus-sxmail-v032 kernel: XFS: log mount/recovery
> failed: error 117
> Jul 25 11:48:52 vus-sxmail-v032 kernel: XFS: log mount failed
> 
> I think we have two options with xfs_repair:
> 
> 1) Run it with -L and zero the log
> 2) Run it without -L and try to replay the log
> 
> Any insight?  We are running 2.6.16.54-0.2.5-default kernel.
> 
> I guess it might be a good idea to run xfs_dump on the filesystem to
> try to salvage whatever we have before we try xfs_repair...
> 
> Thanks a lot in advance,
> 
> Bernard
> 
