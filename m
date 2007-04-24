Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 10:03:31 -0700 (PDT)
Received: from fall-lakeland.atl.sa.earthlink.net (fall-lakeland.atl.sa.earthlink.net [207.69.195.103])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3OH3QfB028594
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 10:03:28 -0700
Received: from pop-satin.atl.sa.earthlink.net ([207.69.195.63])
	by fall-lakeland.atl.sa.earthlink.net with esmtp (Exim 4.34)
	id 1HgOEH-0005Y0-5U
	for xfs@oss.sgi.com; Tue, 24 Apr 2007 12:51:01 -0400
Received: from user-11fb6mm.dsl.mindspring.com ([66.245.154.214] helo=[192.168.0.10])
	by pop-satin.atl.sa.earthlink.net with esmtp (Exim 3.36 #1)
	id 1HgOEF-0006ft-00
	for xfs@oss.sgi.com; Tue, 24 Apr 2007 12:50:59 -0400
Subject: system freeze with xfs
From: Jurgen Schulz <jmschulz@earthlink.net>
Content-Type: text/plain
Date: Tue, 24 Apr 2007 09:50:57 -0700
Message-Id: <1177433458.3360.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

When I create an xfs filesystem and run
'stress' (http://weather.ou.edu/~apw/projects/stress/stress.html) I can
induce a system freeze (hang, no panic). There are no issues if I create
a jfs filesystem (on the same disk) or run 'stress' on a different disk
(ext3)

I'd like to know how I could go about debugging this, otherwise I will
have to switch filesystem types.


Details:
% stress -d 2 --hdd-noclean --hdd-bytes 3G --verbose

Fedora Core 5 
2.6.20-1.2312.fc5 #1 Tue Apr 10 15:09:44 EDT 2007 i686 athlon i386
GNU/Linux

# /sbin/mkfs.xfs -f  /dev/VolTest/test 
meta-data=/dev/VolTest/test      isize=256    agcount=16, agsize=198656
blks
         =                       sectsz=512  
data     =                       bsize=4096   blocks=3178496, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=2560, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

# /sbin/hdparm /dev/hdk 

/dev/hdk:
 multcount    = 16 (on)
 IO_support   =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 25228/16/63, sectors = 25429824, start = 0
