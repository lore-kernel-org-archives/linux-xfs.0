Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Jul 2006 13:55:51 -0700 (PDT)
Received: from talk.nabble.com (www.nabble.com [72.21.53.35])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6SKtZDW021555
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 13:55:35 -0700
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1G6YGg-0000xD-1I
	for xfs@oss.sgi.com; Fri, 28 Jul 2006 12:45:06 -0700
Message-ID: <5545990.post@talk.nabble.com>
Date: Fri, 28 Jul 2006 12:45:06 -0700 (PDT)
From: calembour <mrcekets@gmail.com>
Subject: write back cache and barriers
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi,
I don't have a deep knowledge about filesystems and I've few experiences
with 
raid configuration, so I need someone who can answer some questions about 
write back cache and barriers.

I have two sata hd (sda, sdb) configured in bios-raid 0 and relative device 
created by dmraid on boot (nvidia_ihfaaicb).

(1) what should I do to know if the write back cache is enabled or not ?
(2) if the write cache is enabled on both sda and sdb this mean that is
enabled 
also on the raid device (/dev/mapper/nvidia_ihfaaicb) ?
(3) how should I do to enable/disable the write cache on the raid device ?

If I try mounting a xfs filesystem I get a message like "barriers are not 
supported by this device" but if I mount a ext3 or a reiserfs filesystem 
respectively with options barrier=1 and barrier=flush they don't complain.
If I mount the reiserfs I explicity get a message like "using barriers".
So who tells the truth ?? 

(4) is there a way to know if the raid device supports barrier or not ?
(5) is there a (not dangerous) test I can do to figure out if barriers are 
really enabled and used with ext3 and reiserfs filesystems ?

Thanks for reading the message
Marco
-- 
View this message in context: http://www.nabble.com/write-back-cache-and-barriers-tf2017234.html#a5545990
Sent from the Xfs - General forum at Nabble.com.
