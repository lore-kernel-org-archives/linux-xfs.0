Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 51D227F37
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 07:40:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DC6B7AC004
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 05:40:04 -0800 (PST)
Received: from torroja.dmt.upm.es (torroja.dmt.upm.es [138.4.116.3]) by
	cuda.sgi.com with ESMTP id zyVleYbCsgivJVgl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jan 2014 05:40:02 -0800 (PST)
Received: from [138.4.116.65] (islero.dmt.upm.es [138.4.116.65])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by torroja.dmt.upm.es (Postfix) with ESMTPS id 367A63401F5
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 14:40:00 +0100 (CET)
Message-ID: <1391002795.2573.79.camel@islero.dmt.upm.es>
Subject: Not being able to recover a RAID 5 20 Tb partition, help needed
From: "Juan A. Sillero" <sillero@torroja.dmt.upm.es>
Date: Wed, 29 Jan 2014 14:39:55 +0100
Mime-Version: 1.0
Reply-To: sillero@torroja.dmt.upm.es
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

We are a pioneering group in turbulence at the Polytechnic University of
Madrid (torroja.dmt.upm.es), running simulations in supercomputing
centers all around the world and hosting massive data in our data center
that are publicly accessible.

Apparently we have lost one of our partitions of 20 Tb because of a
under-voltage error of a power source plus a disk failure and we are
trying to fix it, but it does not look good so far.

The system is setup as follow:
        XFS 6.1
        Raid 5 (12 x 2 disks of 2 Tb each)
        Double disk controller managed by devmapper.

What we know at this point is the next:

1) The topology of the disk is lost: the main-boot-record and the GPT
are corrupted. 
2) After running the testdisk utility we find 9 partitions instead of 1.
3) With gdisk we have tried to create a new main-boot-record and GPT,
but it has not worked. 
4) We know that the blocksize is 4096 bytes, and the current capacity of
the raid is under 20 Tb, so we suspect that even if the disk-manager
says that the RAID is ok, it has not reconstructed the RAID after the
disk failing.

We are stuck right now at this point, and help would be really
appreciated in order to bring up the partition. We will be pleased to
acknowledge the group in the upcoming publications.

Thanks again, Juan A. Sillero 




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
