Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 16:27:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2HNR3FU018931
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 16:27:05 -0700
Received: from knox.decisionsoft.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4DA9FBDC69
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 16:27:32 -0700 (PDT)
Received: from knox.decisionsoft.com (knox-be.decisionsoft.com [87.194.172.100]) by cuda.sgi.com with ESMTP id 0pAG2h5kKM1IpH3t for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 16:27:32 -0700 (PDT)
Received: from kennet.dsl.local ([10.0.0.11])
	by knox.decisionsoft.com with esmtp (Exim 4.63)
	(envelope-from <strr-debian@decisionsoft.co.uk>)
	id 1JbOjn-0003yq-NW
	for xfs@oss.sgi.com; Mon, 17 Mar 2008 23:27:27 +0000
Message-ID: <47DEFE5E.4030703@decisionsoft.co.uk>
Date: Mon, 17 Mar 2008 23:27:26 +0000
From: Stuart Rowan <strr-debian@decisionsoft.co.uk>
Reply-To: strr-debian@decisionsoft.co.uk
MIME-Version: 1.0
Subject: 2.6.24.3 nfs server on xfs keeps producing nfsd: non-standard errno:
 -117
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

Firstly thanks for the great filesystem and apologies if this ends up being 
NFS rather than XFS being weird! I'm not subscribed so please do keep me CC'd.

I have *millions* of lines of (>200k per minute according to syslog):
nfsd: non-standard errno: -117
being sent out of dmesg

Now errno 117 is
#define EUCLEAN         117     /* Structure needs cleaning */
which seems to be only used from a quick grep by XFS and JFFS and smbfs.


My nfs server export two locations
/home
/home/archive
both of these are XFS partitions, hence my suspicion that the -117 is 
coming from XFS.

xfs_repair -n says the filesystems are clean
xfs_repair has been run multiple times to completion on the filesystems, 
all is fine.

The XFS partitions are lvm volumes as follows
data/home 900G
data/archive 400G
The volume group, data, is sda3
sda3 is a 6 drive 3ware 9550SXU-8LP RAID10 array

The NFS server is currently in use (indeed the message only starts once 
clients connect) and works absolutely fine.

How do I find out what (if anything) is wrong with my filesystem / 
appropriately silence this message?

Many thanks,
Stu.
