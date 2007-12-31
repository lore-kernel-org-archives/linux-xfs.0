Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Dec 2007 08:26:05 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBVGQ0UJ009940
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 08:26:01 -0800
Received: from pan.gwi.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBB94121FDE4
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 08:26:15 -0800 (PST)
Received: from pan.gwi.net (pan.gwi.net [207.5.128.165]) by cuda.sgi.com with ESMTP id 6kIRp3CBaedjcxwC for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 08:26:15 -0800 (PST)
Received: from strange.home.langhorst.com (bb-66-55-211-238.gwi.net [66.55.211.238])
	by pan.gwi.net (8.13.1/8.13.1) with ESMTP id lBVGQD6p037192
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 11:26:14 -0500 (EST)
	(envelope-from brad@langhorst.com)
Received: from up.home.langhorst.com ([192.168.10.13])
	by strange.home.langhorst.com with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <brad@langhorst.com>)
	id 1J9NSv-00084V-KJ
	for xfs@oss.sgi.com; Mon, 31 Dec 2007 11:26:13 -0500
Subject: raid 10 su, sw settings
From: Brad Langhorst <brad@langhorst.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 30 Dec 2007 19:00:39 -0500
Message-Id: <1199059239.13944.65.camel@up>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have this system
 - 3ware 9650 controller
 - 4 disk raid 10
 - 64k stripe size
 - this is a vmware host, so lots of r/w on a few big files.

I'm not entirely satisfied with its performance.

Typical blocks/sec from iostat during large file movements is about
100M/s read and 80M/s write.

When I set this up, I did not fully understand all the details... so I
want to check a few things.

 - is the partition aligned correctly? i fear not...
        /dev/sda1   *           1          24      192748+  83  Linux
        /dev/sda2              25       19449   156031312+  83  Linux
        
        Is this where I'm losing performance?
 
 - What should the sunit and swidth settings be during mount?
        I guess with raid 10 the width is 2 so...
        sunit = 128 (64k/512) and swidth = 256 (2*64k/512)
        
        Or maybe I should use width 1 ?
        ﻿
        Remounting (mount -o remount) with these options does not lead
        to a noticeable change in performance. Must I recreate the fs or
        unmount and remount?

Here's the output of xfsinfo in case it's relevant.

xfs_info  /
meta-data=/dev/sda2              isize=256    agcount=16, agsize=2437989
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=39007824,
imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=19046, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0
