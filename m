Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n139Nq09050424 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 03:23:53 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF37418AD04A
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 01:23:10 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id ZiAHKSefcFIlDZNW for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 01:23:10 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 4761D3CB8
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 10:22:39 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id EA2F540016F
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 10:22:38 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_force_shutdown after Raid crash
Date: Tue, 3 Feb 2009 10:22:38 +0100
References: <498376CF.8020806@renderforce.de> <200902030222.47644@zmi.at>
	<4987B673.8030406@sandeen.net>
In-Reply-To: <4987B673.8030406@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902031022.38583@zmi.at>
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

On Dienstag 03 Februar 2009 Eric Sandeen wrote:
> you'd need to read the docs for your controller, to find out how to
> tell if it has a writeback cache enabled, and whether it is
> batter-backed or not.

Sorry I didn't write that. Yes it's writeback (can be switched off) and 
it's battery backed. Is there no danger then? Because in the mail from 
Chris, he wrote he got problems because there was "with a write back 
cache enabled on the controller / disks but without barriers". And I 
thought the (not supported/used) barriers could be a problem.

I've re-read the FAQ now. It says it's recommended to turn off barrier 
writes if you have battery-backed writeback, and I guess I'll do that. 
So I misunderstood Chris.
But what about the hard disk cache - should that be disabled? I think in 
case of a power failure, they just loose their cache contents, right? So 
the battery-backed controller cache only helps himself, the disks will 
just throw away up to the 32MB cache they have?

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
