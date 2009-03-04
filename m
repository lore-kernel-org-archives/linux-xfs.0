Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n242hP6E047366 for <xfs@oss.sgi.com>; Tue, 3 Mar 2009 20:43:27 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A97321680F0
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2009 18:42:55 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id Dlqc7wRH8wQ7FFFq for
	<xfs@oss.sgi.com>; Tue, 03 Mar 2009 18:42:55 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id AF73B43AD
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2009 03:42:53 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id EF6ED400161
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2009 03:42:53 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS and XEN
Date: Wed, 4 Mar 2009 03:42:53 +0100
References: <200902170959.55077@zmi.at> <200902241604.29566@zmi.at>
	<20090224163823.GA19811@infradead.org>
In-Reply-To: <20090224163823.GA19811@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903040342.53587@zmi.at>
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

I just got this info at XEN:
> LVM does not honor write-barriers.

Then I searched and found a thread were Eric also talked:
http://lkml.org/lkml/2008/5/16/390
http://hightechsorcery.com/2008/06/linux-write-barriers-write-caching-
lvm-and-filesystems

If I understand correctly, turning off disk cache write cache should be 
enough to be save, even when using LVM. Is it really XEN that messed the 
disk, or something else? Could the Areca controller driver do something 
wrong? I'd really love to get a stable and data-secure system, as you 
might understand.

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
