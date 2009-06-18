Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5IF3bAn018664 for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 10:03:38 -0500
Received: from mail.laber.fasel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AC4F306D60
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 08:04:02 -0700 (PDT)
Received: from mail.laber.fasel.org (mail.laber.fasel.org [212.7.178.68]) by
	cuda.sgi.com with ESMTP id xKuA13dXyS0l0aTy for
	<xfs@oss.sgi.com>; Thu, 18 Jun 2009 08:04:02 -0700 (PDT)
Received: from mail.laber.fasel.org (localhost [127.0.0.1])
	by mail.laber.fasel.org (Postfix/wolfram.schlich.biz) with ESMTP id
	3CBB56000AA
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 17:04:01 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.laber.fasel.org (Postfix/wolfram.schlich.biz) with ESMTP id
	310F2600050
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 17:04:01 +0200 (CEST)
Received: from mail.laber.fasel.org ([127.0.0.1])
	by localhost (mail.laber.fasel.org [127.0.0.1]) (amavisd-new,
	port 10026) with ESMTP id z1MQCTzo5EhC for <xfs@oss.sgi.com>;
	Thu, 18 Jun 2009 17:04:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.laber.fasel.org (Postfix/wolfram.schlich.biz) with ESMTP id
	0F20D6000AA
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 17:04:00 +0200 (CEST)
Received: from mail.bla.fasel.org (mail.bla.fasel.org
	[IPv6:2001:4b88:1066:32::35])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mail.bla.fasel.org",
	Issuer "ca.bla.fasel.org" (verified OK))
	by mail.laber.fasel.org (Postfix/wolfram.schlich.biz) with ESMTPS id
	953CC6000AA
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 17:03:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.bla.fasel.org (Postfix) with ESMTP id 4BFE1407B12
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 17:03:58 +0200 (CEST)
Received: from mail.bla.fasel.org (localhost [127.0.0.1])
	by mail.bla.fasel.org (Postfix) with ESMTP id E5C13408CA5
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 17:03:57 +0200 (CEST)
Date: Thu, 18 Jun 2009 17:03:57 +0200
From: Wolfram Schlich <lists@wolfram.schlich.org>
Subject: Re: xfs_trans_read_buf error / xfs_force_shutdown with LVM
	snapshot and Xen kernel 2.6.18
Message-ID: <20090618150357.GE16867@bla.fasel.org>
References: <20090618065621.GD16867@bla.fasel.org>
	<4A3A47AC.6070406@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A3A47AC.6070406@sandeen.net>
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
To: xfs@oss.sgi.com

* Eric Sandeen <sandeen@sandeen.net> [2009-06-18 16:09]:
> Wolfram Schlich wrote:
> > Hi!
> > 
> > I'm currently using LVM snapshots to create full system backups
> > of a bunch of Xen-based virtual machines (so-called domUs).
> > Those domUs all run Xen kernel 2.6.18 from the Xen 3.2.0 release
> > (32bit domU on 32bit dom0, I can post the .config if needed).
> > All domUs are using XFS on their LVM logical volumes.
> > The backup of all mounted snapshot volumes is made using
> > rsnapshot/rsync. This has been running smoothly for some
> > weeks now on 5 domUs.
> > 
> > Yesterday this happened during the backup on 1 domU:
> > --8<--
> > kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block 0x604d68       ("xfs_trans_read_buf") error 5 buf count 4096
> [...]
> > [...many more of such messages...]
> 
> Well these are all I/O errors happening -to- xfs, so xfs is unlikely to
> be at fault here.  Any block layer messages before that?

Unfortunately not a single one :(

> > Is it possible that the LVM snapshot (that should be using
> > xfs_freeze/xfs_unfreeze) has created an inconsistent/damaged
> > snapshot that was kept from being repaired through norecovery?
> > Any other ideas?
> 
> If it was a proper snapshot norecovery shouldn't matter, as the fs
> should be clean already (well, hopefully, 2.6.18 was a long time ago;
> this is true today, anyway)

Ok.

> I suppose it's possible that the snapshot was not consistent, and you're
> hitting problems there, but things like:
> 
> > kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block
> 0xdd0       ("xfs_trans_read_buf") error 5 buf count 8192
> 
> looks like a failure to read a perfectly normal block, not out of bounds
> or anything, so I'd most likely point to problems outside xfs.

I've now traced it back to LVM. It seems that the LVM snapshot
volume we were backing up at that time ran out of space and thus
was automatically removed (thus, the block device which the XFS
was on vanished).

Stupid LVM does not log ANYTHING when it just deletes a snapshot
running out of space :( I've now activated dmeventd which *does*
log such events *sigh*

Thanks!
-- 
Regards,
Wolfram Schlich <wschlich@gentoo.org>
Gentoo Linux * http://dev.gentoo.org/~wschlich/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
