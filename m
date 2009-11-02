Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2LwO1V096646 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 15:58:24 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 782441BA48A7
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 13:58:37 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id bGYD32ew7SzFJEht for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2009 13:58:37 -0800 (PST)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id DB4E4C02700
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 22:58:35 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id A100040016F
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 22:58:35 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS and DPX files
Date: Mon, 2 Nov 2009 22:58:35 +0100
References: <4AEC2CF4.8040703@aol.com> <200911021205.28006@zmi.at>
	<20091102185249.0da8e388@harpe.intellique.com>
In-Reply-To: <20091102185249.0da8e388@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911022258.35164@zmi.at>
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

On Montag 02 November 2009 Emmanuel Florac wrote:
> The 3Ware is so slow it's almost unusable without write cache. I bet
> he already uses it anyway.

Don't mix up the controller write cache vs. disk write cache. The 
controller write cache should be on whenever you have a BBM installed, 
because this brings real performance, while the disk write cache should 
always be off in a production environment, because you will loose data 
on power fail, which nobody can recognize (the controller believes the 
sectors to be written already...)

Hence my suggestion for turning on the disk write cache just to see if 
it makes a difference.

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
