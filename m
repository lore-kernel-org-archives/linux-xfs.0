Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2AA0E7F80
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 09:24:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF6D7304070
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 07:24:30 -0800 (PST)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id M78eRMccxIVA2eRJ for
	<xfs@oss.sgi.com>; Wed, 29 Jan 2014 07:24:29 -0800 (PST)
Subject: Re: Not being able to recover a RAID 5 20 Tb partition, help needed
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <1391002795.2573.79.camel@islero.dmt.upm.es>
References: <1391002795.2573.79.camel@islero.dmt.upm.es>
Date: Wed, 29 Jan 2014 15:24:28 +0000
Message-Id: <1391009068.4294.83.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: sillero@torroja.dmt.upm.es
Cc: xfs@oss.sgi.com


On Wed, 2014-01-29 at 14:39 +0100, Juan A. Sillero wrote:
> Hello,
> 
> We are a pioneering group in turbulence at the Polytechnic University of
> Madrid (torroja.dmt.upm.es), running simulations in supercomputing
> centers all around the world and hosting massive data in our data center
> that are publicly accessible.
> 
> Apparently we have lost one of our partitions of 20 Tb because of a
> under-voltage error of a power source plus a disk failure and we are
> trying to fix it, but it does not look good so far.
> 
> The system is setup as follow:
>         XFS 6.1
>         Raid 5 (12 x 2 disks of 2 Tb each)
>         Double disk controller managed by devmapper.
> 
> What we know at this point is the next:
> 
> 1) The topology of the disk is lost: the main-boot-record and the GPT
> are corrupted. 


Are you sure the array had a main-boot-record and GPT ? What makes you
think they are corrupted ?

> 2) After running the testdisk utility we find 9 partitions instead of 1.

There is a good chance that the discovered partitions are backup XFS
superblocks; their location and content may allow you to figure out the
array topology.


> 3) With gdisk we have tried to create a new main-boot-record and GPT,
> but it has not worked. 

This was a bad idea. Do you have a copy of the original data for these
sectors ?

> 4) We know that the blocksize is 4096 bytes, and the current capacity of
> the raid is under 20 Tb, so we suspect that even if the disk-manager
> says that the RAID is ok, it has not reconstructed the RAID after the
> disk failing.
> 
> We are stuck right now at this point, and help would be really
> appreciated in order to bring up the partition. We will be pleased to
> acknowledge the group in the upcoming publications.
> 
> Thanks again, Juan A. Sillero 

> 
-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
