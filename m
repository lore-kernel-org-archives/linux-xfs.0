Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7HLB1fY093557 for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 16:11:18 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 066743D8D0D
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 14:11:11 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id hqacrP7H4WNxRpve for
	<xfs@oss.sgi.com>; Mon, 17 Aug 2009 14:11:11 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id E44635380
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 23:11:08 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 3AD20400166
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 23:11:08 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: disk performance strange/low
Date: Mon, 17 Aug 2009 23:11:07 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908172311.07660@zmi.at>
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

I've got an Areca RAID Controller with 5x 1TB disks, and in the last 
time I often found it to be strange. Now I investigated, and found this. 
>From another server I NFS mount a share, and make
dd if=/dev/sda of=/server/share/test.dd bs=1024k
so that should do big sequential writes. But the performance goes up and 
down, like you see in this output from "iostat -kx 5 555". You see write 
KB/s is 5824, 23207, 87283, 704, 40187. Up and down all the time. Could 
that be solved by the patch you discussed last time, or is there 
something else?

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-
sz avgqu-sz   await  svctm  %util
sdb               0,00   401,20    1,20   77,09     4,78  5824,00   
148,91   152,25 2595,77  12,76  99,92

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,00    0,00   34,77   67,03    2,20    7,21
sdb               0,00  1094,40    2,20  245,80     8,80 23207,20   
187,23   153,64   43,24   4,03 100,00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,00    0,00   41,08   56,83    0,30   15,65
sdb               0,00   295,20    6,40  791,20    25,60 87283,40   
218,93   119,19  259,89   1,21  96,56

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,00    0,00   61,45   55,92    0,50    4,62
sdb               0,00     3,60    0,00    4,60     0,00   704,80   
306,43   140,01 2979,30 217,39 100,00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,00    0,00   21,12   75,50    0,10   10,06
sdb               0,00  1252,80    0,20  270,00     0,80 40187,20   
297,47   151,38 1160,49   3,70  99,84


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
