Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jan 2008 12:27:51 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m07KRjlO029509
	for <linux-xfs@oss.sgi.com>; Mon, 7 Jan 2008 12:27:47 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1CAB4F1CB5
	for <linux-xfs@oss.sgi.com>; Mon,  7 Jan 2008 12:28:01 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.181]) by cuda.sgi.com with ESMTP id kGitqY8lvbGDZehx for <linux-xfs@oss.sgi.com>; Mon, 07 Jan 2008 12:28:01 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so13565651waf.18
        for <linux-xfs@oss.sgi.com>; Mon, 07 Jan 2008 12:28:00 -0800 (PST)
Message-ID: <5d96567b0801071227i509402ccuce044106cc8959af@mail.gmail.com>
Date: Mon, 7 Jan 2008 22:27:59 +0200
From: Raz <raziebe@gmail.com>
Subject: mount option swalloc
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Does it work ?
I have created several 100MBytes files over raid5 and they don't seem
to be starting at modulo (swidth ) = 0.
conf: sunit=1M ,  raid5 with 4 sata disks.  swidth=3MB.

meta-data=/dev/md1               isize=256    agcount=32, agsize=5687296 blks
         =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=181989888, imaxpct=25
         =                       sunit=256    swidth=768 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks
realtime =none                   extsz=3145728 blocks=0, rtextents=0

I am using 2.6.17 vanilla kernel .

thank you
-- 
Raz
