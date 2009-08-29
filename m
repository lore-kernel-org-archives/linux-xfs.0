Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7TMDnoI246278 for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 17:13:59 -0500
Received: from mailsrv5.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FCDE40D3B1
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 15:14:34 -0700 (PDT)
Received: from mailsrv5.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id DnmvmLAySi67FGSS for
	<xfs@oss.sgi.com>; Sat, 29 Aug 2009 15:14:34 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv5.zmi.at (Postfix) with ESMTP id C15F66A1
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 00:14:28 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 503D040015E
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 00:14:28 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs data loss
Date: Sun, 30 Aug 2009 00:14:13 +0200
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A981133.6060009@sandeen.net>
	<B9A7B002C7FAFC469D4229539E909760308DA65407@DU-EXC-MAIL.empa.emp-eaw.ch>
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308DA65407@DU-EXC-MAIL.empa.emp-eaw.ch>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908300014.13845@zmi.at>
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

On Samstag 29 August 2009 Passerone, Daniele wrote:
> But apart from that, it is not as easy to backup 20 TB, so we decided
> to set it as data storage leaving the responsibilty of the backup to
> our users. I do not consider it completely absurd.

Right, if you communicated this to users it's OK.

But really, don't create any RAID with more than 8 data disks. 
Performance doesn't increase above that, and the chance that a single 
disk dies is already 8x as high as with a single disk.

I wish you luck with your recovery, but please try to split your 20 
disks, make it 2x9 disks with a RAID-5, better RAID-6, and connect those 
two via RAID-0. So you get a RAID-50 or RAID-60. Take the remaining 2 
drives as hot spare. This will protect you at least from drive failures, 
and speeds up recreating the RAID when a disk dies.
Try to connect the disks which are in a single RAID-5/6 via the same 
controllers, so if a controller dies it's only one RAID-5/6 part that 
dies, which will help to make it possible to repair.

mfg zmi
-- 
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
