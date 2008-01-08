Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jan 2008 06:07:05 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m08E6v4M006674
	for <xfs@oss.sgi.com>; Tue, 8 Jan 2008 06:07:00 -0800
Received: from smtp-out5.blueyonder.co.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D829C25FA2
	for <xfs@oss.sgi.com>; Tue,  8 Jan 2008 06:07:10 -0800 (PST)
Received: from smtp-out5.blueyonder.co.uk (smtp-out5.blueyonder.co.uk [195.188.213.8]) by cuda.sgi.com with ESMTP id 4ScVJI4l1BrngISM for <xfs@oss.sgi.com>; Tue, 08 Jan 2008 06:07:10 -0800 (PST)
Received: from [172.23.170.139] (helo=anti-virus01-10)
	by smtp-out5.blueyonder.co.uk with smtp (Exim 4.52)
	id 1JCEx0-0002W0-Vl
	for xfs@oss.sgi.com; Tue, 08 Jan 2008 13:57:07 +0000
Received: from [195.188.53.233] (helo=webmail.blueyonder.co.uk)
	by asmtp-out3.blueyonder.co.uk with esmtp (Exim 4.52)
	id 1JCEx0-0001h6-Il
	for xfs@oss.sgi.com; Tue, 08 Jan 2008 13:57:06 +0000
Message-ID: <59227.82.45.191.179.1199800626.SVkUQ21ZSE16Sg==.squirrel@82.45.191.179>
Date: Tue, 8 Jan 2008 13:57:06 -0000 (GMT)
Subject: xfs creation options - raid
From: carpcatcher@blueyonder.co.uk
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello, been reading documents but still not sure what are best option to
use when creating xfs on my raid system. Raid card details below.


I have 2 raid 1 arrays which will have xfs partitions:

Array 1 55gb with 1 40gb xfs partition for /home
Array set as stripe 64kb block 512 bytes


Array 2 645gb 1 xfs partition using all space for file storage
Array set as stripe 128kb block 512 bytes


I have been looking at docs and come with following to create FS on 645gb
xfs partition.

mkfs.xfs -f -d  agcount=42 -l size=64m /dev/sde5


The default agcount= was 32 but am not 100% sure how to work this out for
correct number?


I would mount with following options:

mount -o logbufs=8,noatime,nodiratime


The other setting am not sure how to get right is this bit from docs: "XFS
allows you to select the stripe unit for a RAID device or stripe volume."


Now i know i need to set  -d su= -d sw=  but best to work this out for my
arrays?


The 645gb array/partition will be used for files 3mb to 250mb with most
being about 20/30mb


Raid is Areca 1210 raid controller:

Adapter Architecture


	ARC-1210 uses IntelR IOP332 I/O processor. ARC-1220/1230/1260 uses IntelR
IOP333 I/O processor
  		PCI-Express X8 bus
  		256MB on-board DDR333 SDRAM with ECC protection(4/8-port)
  		One SODIMM socket with default 256MB of DDR333 SDRAM with ECC
protection, Upgrade to 1GB. An ECC or non-ECC SDRAM module using X8 or
X16 chip organization (12/16/24-port)
  		Write-through or write-back cache
