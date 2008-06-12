Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 15:26:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5CMQGbl031300
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 15:26:17 -0700
Received: from smtp-vbr13.xs4all.nl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD1892247B4
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 15:27:11 -0700 (PDT)
Received: from smtp-vbr13.xs4all.nl (smtp-vbr13.xs4all.nl [194.109.24.33]) by cuda.sgi.com with ESMTP id catjtT6wkQ6RhTkS for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 15:27:11 -0700 (PDT)
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
From: Miquel van Smoorenburg <mikevs@xs4all.net>
In-Reply-To: <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com>
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de>
	 <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Jun 2008 00:27:09 +0200
Message-Id: <1213309629.29745.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: lists@ku-gbr.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, mikevs@xs4all.net

On Thu, 2008-06-12 at 16:33 +0200, Oliver Pinter wrote:
> add CC's
> 
> On 6/12/08, lists@ku-gbr.de <lists@ku-gbr.de> wrote:
> > Hi!
> >
> > Today morning my server at home bailed out two times (reboot between):

> > Jun 12 07:23:40 zappa
> > Jun 12 07:23:40 zappa xfs_force_shutdown(sda7,0x8) called from line
> > 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff802f4d8a
> > Jun 12 07:23:40 zappa Filesystem "sda7": Corruption of in-memory data
> > detected.  Shutting down filesystem: sda7
> > Jun 12 07:23:40 zappa Please umount the filesystem, and rectify the
> > problem(s)

Hmm, interesting. I'm seeing the same thing on one of my servers since I
upgraded from 2.6.ancient (14 or so) to 2.6.25, while XFS otherwise has
been very stable for me over the years:

Linux transit5.news.xs4all.nl 2.6.25.6 #1 SMP Wed Jun 11 10:59:10 CEST
2008 x86_64 GNU/Linux

Filesystem "sda4": XFS internal error xfs_trans_cancel at line 1163 of
file fs/xfs/xfs_trans.c.  Caller 0xffffffff880f1315
Pid: 3402, comm: diablo Not tainted 2.6.25.6 #1

Call Trace:
 [<ffffffff880f1315>] :xfs:xfs_create+0x1e5/0x520
 [<ffffffff880ea4a6>] :xfs:xfs_trans_cancel+0x126/0x150
 [<ffffffff880f1315>] :xfs:xfs_create+0x1e5/0x520
 [<ffffffff880fcb79>] :xfs:xfs_vn_mknod+0x1d9/0x320
 [<ffffffff8028811c>] vfs_create+0xac/0xf0
 [<ffffffff8028b6bd>] open_namei+0x61d/0x6c0
 [<ffffffff802448c0>] autoremove_wake_function+0x0/0x30
 [<ffffffff8027da0c>] do_filp_open+0x1c/0x50
 [<ffffffff8027d6e9>] get_unused_fd_flags+0x79/0x120
 [<ffffffff8027da9a>] do_sys_open+0x5a/0xf0
 [<ffffffff8020b2bb>] system_call_after_swapgs+0x7b/0x80

xfs_force_shutdown(sda4,0x8) called from line 1164 of file
fs/xfs/xfs_trans.c.  Return address = 0xffffffff880ea4bf
Filesystem "sda4": Corruption of in-memory data detected.  Shutting down
filesystem: sda4
Please umount the filesystem, and rectify the problem(s)

After a reboot, xfs_repair didn't find anything wrong with the fs. It
has happened 3 times over the last few days already.

FS is on a local SCSI raid (dpt_i2o), not SATA.

Mike.
