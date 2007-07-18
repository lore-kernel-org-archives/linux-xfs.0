Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 05:03:41 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IC3bbm030248
	for <linux-xfs@oss.sgi.com>; Wed, 18 Jul 2007 05:03:38 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1IB8Fo-0000Vu-TG
	for linux-xfs@oss.sgi.com; Wed, 18 Jul 2007 05:03:40 -0700
Message-ID: <11667329.post@talk.nabble.com>
Date: Wed, 18 Jul 2007 05:03:40 -0700 (PDT)
From: amilrego <victor.amil@gmail.com>
Subject: XFS log warning "Writing back config space on device"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hello.
I have formated one 300 GB partition in Linux OS, and then i worked whitout
problems.
But, If I do a "dmesg" there is a warning error (i don´t know if is really a
problem or maybe could cause problems in future):

SCSI device sdb: drive cache: write back
 sdb: sdb1
 ---

XFS mounting filesystem sdb1
Ending clean XFS mount for filesystem: sdb1
PM: Writing back config space on device 0000:05:02.0 at offset b (was
165314e4, writing 12bc103c)
PM: Writing back config space on device 0000:05:02.0 at offset 3 (was 0,
writing 4010)
PM: Writing back config space on device 0000:05:02.0 at offset 2 (was
2000000, writing 2000003)
PM: Writing back config space on device 0000:05:02.0 at offset 1 (was
2b00000, writing 2b00106)
PM: Writing back config space on device 0000:05:02.0 at offset 0 (was
165314e4, writing 169614e4)

This partition allways was dismounted correctly, and there is low
fragmentation.
I really don´t know if in the future I could have problems. Maybe there are
any way to solve this warnings.

Thanks!!
Víctor Amil 

-- 
View this message in context: http://www.nabble.com/XFS-log-warning-%22Writing-back-config-space-on-device%22-tf4102828.html#a11667329
Sent from the linux-xfs mailing list archive at Nabble.com.
