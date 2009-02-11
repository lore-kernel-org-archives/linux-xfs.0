Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BCBWk8127140 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 06:11:34 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EF7319176F7
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 04:10:55 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id g9K2dL86gMBF4AWu for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2009 04:10:55 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 41E613F0B
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 13:10:54 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 37928400160
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 13:10:54 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: why does mkfs.xfs complain here?
Date: Wed, 11 Feb 2009 13:10:53 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902111310.53762@zmi.at>
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

# mkfs.xfs -f -L ws1phptmp -b size=4096 -d su=65536,sw=4,agcount=4 -i attr=2 -l lazy-count=1,su=65536 /dev/sdf1
log stripe unit specified, using v2 logs
Allocation group size (65262) is not a multiple of the stripe unit (16)

Why is above error generated at all? Shouldn't mkfs.xfs handle that 
situation and change agsize automatically? If I then do:

# mkfs.xfs -f -L ws1phptmp -b size=4096 -d su=64k,sw=4,agsize=65262b -i attr=2 -l lazy-count=1,su=65536 /dev/sdf1
log stripe unit specified, using v2 logs
agsize rounded to 65264, swidth = 64
meta-data=/dev/sdf1              isize=256    agcount=4, agsize=65264 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=261048, imaxpct=25
         =                       sunit=16     swidth=64 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

So no problem using agsize instead agcount, where agcount complained
about group size = 65262, which I then used without problem?

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
