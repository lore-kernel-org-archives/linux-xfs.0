Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7TJ2Lh7238080 for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 14:02:33 -0500
Received: from mailsrv5.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 280F515830D5
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 12:02:38 -0700 (PDT)
Received: from mailsrv5.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 1YAaOeUDhnWi36QE for
	<xfs@oss.sgi.com>; Sat, 29 Aug 2009 12:02:38 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv5.zmi.at (Postfix) with ESMTP id 357E63D1
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 21:02:35 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 916D740015E
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 21:02:34 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: zero size file after power failure with kernel 2.6.30.5
Date: Sat, 29 Aug 2009 21:02:21 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908292102.21710@zmi.at>
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

I have /home mounted like this:
/dev/sda3 on /disks/work1 type xfs 
(rw,noatime,logbufs=8,logbsize=256k,attr2,barrier,largeio,swalloc)

Hardware: onboard SATA with a single WD VelociRaptor drive.

My power supply melted and so I had a power fail and a sudden death 
crash.
( So please remember: even when you have a UPS, your power can fail ! )

After replacing the part, I had almost no isse with my KDE desktop. In 
earlier XFS releases, I constantly lost several config files all 
truncated to 0 length or at some point only contained NULLs on such 
occasions. So the situation improved a lot.

But almost is not good enough: Exactly my kmail config file was 0 sized 
- obviously: at least when I started kmail, it started fresh without any 
accounts or config, but once I exited kmail the config was created with 
the default values and about 12KB size, while my config has >200KB.

Shouldn't it be that this doesn't happen anymore? I'd love to be in a 
position where I really can rely on a crash not trashing any of my files 
anymore. I used to have reiserfs previously, and never, not a single 
time despite many crashes, did I have such an issue. I'd really be 
pleased so see such stability in XFS. I'm using barriers - what else 
must I do?

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
