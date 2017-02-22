Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:43639 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932451AbdBVOTF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Feb 2017 09:19:05 -0500
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
Date: Wed, 22 Feb 2017 15:19:01 +0100
Message-ID: <1515530.QCkvOjz404@libor-nb>
In-Reply-To: <30c5d3eb-5f62-5488-aff7-6b1544f1c29a@sandeen.net>
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com> <3412655.IXdA3WXzce@libor-nb> <30c5d3eb-5f62-5488-aff7-6b1544f1c29a@sandeen.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On středa 22. února 2017 7:45:38 CET Eric Sandeen wrote:
> On 2/22/17 5:42 AM, Libor Klepáč wrote:
> > Hi,
> > it happened again on one machine vps3 from last mail, which had clean xfs_repair run
> > It's running kernel 4.9.0-0.bpo.1-amd64 (so it's 4.9.2) since 6. Feb. It was upgraded from 4.8.15.
> > 
> > Error was
> > Feb 22 11:04:21 vps3 kernel: [1316281.466922] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xe8/0x100 [xfs], xfs_attr3_leaf block 0xa000718
> > Feb 22 11:04:21 vps3 kernel: [1316281.468665] XFS (dm-2): Unmount and run xfs_repair
> > Feb 22 11:04:21 vps3 kernel: [1316281.469440] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
> > Feb 22 11:04:21 vps3 kernel: [1316281.470212] ffffa06e686ac000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> > Feb 22 11:04:21 vps3 kernel: [1316281.470964] ffffa06e686ac010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> > Feb 22 11:04:21 vps3 kernel: [1316281.471691] ffffa06e686ac020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Feb 22 11:04:21 vps3 kernel: [1316281.472431] ffffa06e686ac030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Feb 22 11:04:21 vps3 kernel: [1316281.473129] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 1322 of file /home/zumbi/linux-4.9.2/fs/xfs/xfs_buf.c.  Return address = 0xffffffffc05e0dc4
> > Feb 22 11:04:21 vps3 kernel: [1316281.473685] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
> > Feb 22 11:04:21 vps3 kernel: [1316281.474402] XFS (dm-2): Please umount the filesystem and rectify the problem(s)
> 
> Ok, and what happened to this machine in the meantime?
> I don't understand why this has been showing up for you; it'd be
> nice to know if anything "interesting" happened prior to this -
> any other shutdown and log replay, for example?  Or what
> is the workload that's leading to this, if you can tell?

Machine was running all the time, only rebooted for kernel upgrade (cleanly) to 4.9.2 on 6 Feb. 

It's a web hosting (apache + php + mysql) vps. All data are on XFS partition, meaning web site data, mysql databases, apache access/error logs.
Group quota is enabled, it's used for web site data, not for mysql or apache logs.

Server is not overloaded, serving just few sites.
But before this problem, it received around 10 thousand hits on one website, webshop created with Prestashop.
Load spiked to 100.
But no other error message than reported one appeared in kernel logs.

> 
> If you run repair and it tells you which inode it is, go find
> that inode and see if there is anything "interesting" about its
> lifetime or attribute use, perhaps?

Ok, will do

> 
> > After reboot, there was once this:
> > Feb 22 11:46:41 vps3 kernel: [ 2440.571092] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0xa000718
> > Feb 22 11:46:41 vps3 kernel: [ 2440.571160] XFS (dm-2): Unmount and run xfs_repair
> > Feb 22 11:46:41 vps3 kernel: [ 2440.571177] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
> > Feb 22 11:46:41 vps3 kernel: [ 2440.571198] ffff8c46fdbe5000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> > Feb 22 11:46:41 vps3 kernel: [ 2440.571225] ffff8c46fdbe5010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> > Feb 22 11:46:41 vps3 kernel: [ 2440.571252] ffff8c46fdbe5020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Feb 22 11:46:41 vps3 kernel: [ 2440.571278] ffff8c46fdbe5030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Feb 22 11:46:41 vps3 kernel: [ 2440.571313] XFS (dm-2): metadata I/O error: block 0xa000718 ("xfs_trans_read_buf_map") error 117 numblks 8
> > 
> > We will run repair tomorrow. Is it worth upgrading xfsprogs from 4.9.0 to 4.10.0-rc1 before repair?
> 
> Should be no need, though always happy to have testing.  :)
> 

Ok, i will prepare package for server

Libor

