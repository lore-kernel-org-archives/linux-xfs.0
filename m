Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9TLjtTh118645 for <xfs@oss.sgi.com>; Thu, 29 Oct 2009 16:45:57 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B186C8419F
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2009 14:46:03 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id FHv0ipEdBxiUEGbd for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2009 14:46:03 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id AAC96C0273B
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2009 22:46:00 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 731F740016F
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2009 22:46:00 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: problem growing disk with xfs_growfs 2.9.4
Date: Thu, 29 Oct 2009 22:45:59 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910292245.59794@zmi.at>
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
To: XFS List <xfs@oss.sgi.com>

# xfs_growfs -V
xfs_growfs version 2.9.4
# xfs_growfs /disks/db/
meta-data=/dev/xvdb1             isize=256    agcount=4, agsize=2621104 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=10484412, imaxpct=25
         =                       sunit=16     swidth=64 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=5120, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 10484412 to 577742125596490953
inode max percent changed from 25 to 2
log blocks changed from 5120 to 0
realtime blocks changed from 0 to -579257957264110720
realtime extent size changed from 1 to -134945223

I was very scared then, but obviously nothing happened. I had forgotten 
to resize the partition before calling growfs, just wanted to report in case 
that is still a bug. I resized the partition and used v3.0.3, works perfectly.
I made a metadump of that partition in case this is interesting.

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
