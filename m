Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 04:39:42 -0700 (PDT)
Received: from donner.stsci.edu (donner.stsci.edu [130.167.251.65])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FBdZ6p001711
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 04:39:38 -0700
Message-ID: <45F92D8C.3090708@stsci.edu>
Date: Thu, 15 Mar 2007 07:27:08 -0400
From: Thomas Walker <walker@stsci.edu>
MIME-Version: 1.0
Subject: Should xfs_repair take this long?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

 
   I am trying to restore a corrupt xfs partition.  It is 6TB total, it 
is an LVM of two 3TB fiber channel SAN volumes.  The host is running 
RHEL4, 2.6.9-42.0.2.ELsmp, and the version of xfsprogs is 
xfsprogs-2.6.13-2.  The host has four threaded AMD Opterons, 4GB of RAM 
and 2GB of swap located on an internal SCSI disk.  It is unclear how the 
xfs partition was damaged, but it reports a bad superblock and will not 
mount.  I am running this command;

xfs_repair -o assume_xfs /dev/mapper/vg0-hladata3

   This command has been running for two days now.  There is cpu 
activity and i/o activity on the physical SAN.  There is some swapping 
but not an unusual amount and swapon -s shows only a small amount in 
use.  I have seen information implying xfs_repair needs a large amount 
of memory to work well, otherwise it will take a long time.  My question 
is, giving my setup, is there an estimate of how long I should wait 
before expecting a result?  Should I add swap space?  Is there anything 
else I should do?

    thanks in advance for any help.

    Thomas Walker
