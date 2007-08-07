Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 07:27:43 -0700 (PDT)
Received: from m01.elite.ru (m01.elite.ru [89.108.83.249])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l77ERZbm006911
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 07:27:37 -0700
Received: from ethaniel (195.225.129.41 [195.225.129.41])
	by m01.elite.ru (ISMS) with ESMTP id 51E52116A8
	for <xfs@oss.sgi.com>; Tue,  7 Aug 2007 18:10:15 +0400 (MSD)
Date: Tue, 7 Aug 2007 18:10:22 +0400
From: Arkadiy Kulev <eth@ethaniel.com>
Reply-To: Arkadiy Kulev <eth@ethaniel.com>
Message-ID: <337047880.20070807181022@ethaniel.com>
Subject: many subdirectories, slow search.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello xfs,

  I have a external SATA storage, that is connected to my server via
  SCSI HBA. The server is a 32 bit core2duo with 1gb RAM.

  The server is used for storing millions of images that are accessed
  randomly (around 50-100 queries per second, total of 2-3 megabytes
  per second).

  I started noticing, that images are being accessed slowly (high
  lag of 5-10 seconds). Even when I connect via ssh and do "ls /data1"
  for instance (/data1 is my 2 terabyte xfs partition) it gives me a
  result only after a few seconds, even though the root folder is not
  big.

  I suppose that I am storing images incorrectly - placing images from
  the same group (album) to different folders:

  albums/00/00/1130000-h200.jpg
  ....
  albums/45/87/2334587-h200.jpg
  albums/45/87/2334587-10x10.jpg
  ....
  albums/99/99/5679999-h200.jpg
  (album subtree depends on the last 4 digits of photo id)

  I am asking for your advice as gurus. Is it better to place all
  images that are accessed from the same webpage (ordered access in
  other terms) in the same folder? Or it doesn't matter?

  Maybe there is some way of better storing of images?

  Switching to SCSI disks is not an option. Any ideas?
  Maybe I tuned ocfs2 wrong?

meta-data=/dev/sdb1              isize=256    agcount=32, agsize=15258737 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=488279584, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0


  

-- 
Best regards,
 Arkadiy                          mailto:eth@ethaniel.com
