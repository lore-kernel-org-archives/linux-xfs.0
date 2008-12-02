Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2K2SYo015280 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 14:02:29 -0600
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 831F91658AC1
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 12:02:26 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id wmowfBLIrHDVcXty
	for <xfs@oss.sgi.com>; Tue, 02 Dec 2008 12:02:26 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id E4F051C00EF63
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 21:02:25 +0100 (CET)
Date: Tue, 2 Dec 2008 21:02:25 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: Disk full during delayed allocation
Message-ID: <alpine.LNX.1.10.0812022055550.14216@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Hi,


on space-constrained filesystems, I noticed that extracting lots of 
files [about 10k] bumps the Used count up quickly leading to a disk full 
unless the extraction process (rpm here) is halted, synced, and then 
continued. I believe this is fully within XFS's standard behavior, but I 
would like to learn more how exactly this can happen. My guess is that 
this is due to the "dynamic journal/log" size XFS employs - on a 
filesystem just mkfs'ed, about 4256KB (for a volume of 128MB) are used, 
compared to e.g. reiser3 where the full 32MB for the journal are used 
(according to df) right from the start.
Is this so?

# df; killall -CONT rpm; sleep 1; killall -STOP rpm; df; sync; df;
Filesystem           1K-blocks      Used Available Use% Mounted on
/lo/src.fs               93504     29396     64108  32% /usr/src
/lo/src.fs               93504     49072     44432  53% /usr/src
/lo/src.fs               93504     35632     57872  39% /usr/src

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
