Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Oct 2008 07:09:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m92E98Nx030168
	for <xfs@oss.sgi.com>; Thu, 2 Oct 2008 07:09:09 -0700
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 4BC0C135CDB5
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2008 07:10:45 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com with SMTP id AQ2QhQSIdeD0xCmx for <xfs@oss.sgi.com>; Thu, 02 Oct 2008 07:10:45 -0700 (PDT)
From: "Tom" <T-o-m@gmx.net>
Subject: Which XFS-options for best performance in my case?
Date: Thu, 2 Oct 2008 17:10:33 +0300
Message-ID: <001d01c92498$a4bd7b40$ee3871c0$@net>
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello dear list members,

 

I am setting up a fileserver with the following specs:

 

.         Hardware RAID 6 (3Ware 9650SE-12, 8-lane-PCIe) with a stripe size
of 64kB, write cache enabled

.         12 Harddisks, 1 Terrabyte and 32MB cache each, 7200 RPM

.         Motherboard: ASUS P5BV-E/4L

.         CPU: Intel Core2Quad 2,4 GHz (Q6600)

.         RAM: 2x2 GB DDRII ECC 800MHz

.         OS: Linux openSUSE 11 - 64 Bit

.         Kernel: 2.6.25.16-0.1-default

.         Filesystem of relevant data partition: XFS

.         Size of relevant data partition: 9 Terrabyte

.         The data hosted on this partition is going to be served via 4
1-Gigabit-Network-cards to Windows Vista-64-SP1 clients via Samba 3.2.3-0.1

 

After having fine tuned the RAID-controller and the kernel settings, I am
reaching the following results: Read 465 MB/s; Write 296 MB/s, which I
benchmarked with "sync; bonnie++ -u 0 -r 4096 -b -d
/name_of_the_mounted_partition". These figures are not all to good.

 

I had formatted the partition with the openSUSE installation tool ("YAST").
This uses:

-          Block size in bytes:                         auto

-          Inode size:                                         auto

-          Percentage of inode space:       auto

-          Inode aligned:                                 auto

.. and mounts the partition in the fstab with "defaults, 1, 2"

 

Question:

 

Are there any settings/options/tweaks with which I can increase the
XFS-filesystem's performance?

 

The server is connected to a UPS-battery (Uninterruptible power supply). The
RAID controller has a own battery pack attached, which keeps any cached
writings in the controller's memory, should the system hang or the power be
disconnected for any reason (but this battery only lasts for a couple of
hours).

 

Above everything else stands SECURITY. I can't afford to lose/corrupt any
data on this server. So please tell me if one of the proposed tweaks should
be risky, or what the risks are.

 

Thank you for any piece of advice/information!

 

Best regards

Tom



[[HTML alternate version deleted]]
