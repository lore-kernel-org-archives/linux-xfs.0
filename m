Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BENLXB133490 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 08:23:22 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C46C31919522
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 06:22:44 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id 6qDLVqVpMLeZ4eXh for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2009 06:22:44 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 38A733F20
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:22:12 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 43B5B400160
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:22:12 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: xfs preallocation timeout
Date: Wed, 11 Feb 2009 15:22:11 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902111522.11987@zmi.at>
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

Does /proc/sys/vm/dirty_expire_centisecs influence the maximum time XFS 
takes before the "in-memory but not on disk" preallocation actually 
starts writing to disk? If not, which parameter does influence how long 
files are grouped together in memory before writing them really to disk? 
The longer the better for performance, but more risk for data loss of 
course. 

I ask this because I want to know when copying files over the net to an 
XFS drive, how I can prevent fragmentation to occur. Example: If a 
packet of 1024 Bytes arrives every 1/100th second, it needs 0.64s to get 
64KB of data, 1.28s to get 128KB. If the prealloc timeout is one second, 
it's effectively not used in this case. So if you got a server where you 
know files arrive at a certain speed, fine tuning this prealloc timeout 
could help prevent fragmentation.

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
