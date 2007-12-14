Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Dec 2007 09:38:41 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBEHcahJ018815
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 09:38:38 -0800
Received: from out3.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE204114901F
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 09:38:48 -0800 (PST)
Received: from out3.smtp.messagingengine.com (out3.smtp.messagingengine.com [66.111.4.27]) by cuda.sgi.com with ESMTP id 3w5m4Q66SRc2u0ow for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 09:38:48 -0800 (PST)
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id 4694D7B6F2
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:38:47 -0500 (EST)
Message-Id: <1197653927.3841.1226620089@webmail.messagingengine.com>
From: "Alex Madarasz" <List.XFS@madalexlists.nospammail.net>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Subject: Fedora 8.0.1 XFS Tune on HW RAID for Max Write Throughput?
Date: Fri, 14 Dec 2007 12:38:47 -0500
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


We're building a new Fedora 8.0.1 Linux system to stream data from a
250Msps ADC to disk, and want to start tuning the system configuration
for maximum XFS write performance.  To date, without any significant
effort at tuning our Fedora 7 dev system, we're seeing 250MBps write
with 8-bit samples and ~ 300MBps write with 16-bit samples. We want to
push the tuning as far as we can go with this architecture before we
start looking at other hardware options.  Looking at various other
tuning pages on the Web finds few that are interested in maxing out
sequential writes to very large arrays while using SAS HW RAID with big
fast SAS drives too.


HW: HP ML350 G5
 - 2 x Dual-Core Intel 5160 Xeon (3GHz, 1333 FSB) CPUs
 - 8GB dual-interleaved memory
 - HP Smart Array E200i (cciss) embedded PCI-E RAID ctrlr
   - 128MB cache
   - 2 x WD RE2 500GB 7200RPM SATA drives
   - HW RAID 1
   - ext3 root LVM and Linux system partitions
 - HP Smart Array P400 (cciss) PCI-E x8 RAID ctrlr
   - 512MB cache
   - 8 x HP/Seagate 300GB 15000RPM SAS drives
   - HW RAID 0 logical disk
   - Dedicated xfs data partition
 - 250Msps ADC on 64-bit/100MHz PCI-X


XFS Tuning Options?

- HW RAID0:
  - Array/logical disk HW RAID stripe size?
  - Cache enabled (some reports that cache s/b turned off?)?
  - xfs mkfs / mount options?

- External Log?
  - How big a partition on the E200i?
  - mkfs / mount options?

...?

Thanks for any tips,

-- 
Alex
