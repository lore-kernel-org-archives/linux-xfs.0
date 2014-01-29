Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A1F27F60
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 08:00:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D1A3AC005
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 06:00:57 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id oYfXWqgmmhpNRtpE for <xfs@oss.sgi.com>;
	Wed, 29 Jan 2014 06:00:56 -0800 (PST)
Message-ID: <52E90998.5050805@sandeen.net>
Date: Wed, 29 Jan 2014 08:00:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Not being able to recover a RAID 5 20 Tb partition, help needed
References: <1391002795.2573.79.camel@islero.dmt.upm.es>
In-Reply-To: <1391002795.2573.79.camel@islero.dmt.upm.es>
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
To: sillero@torroja.dmt.upm.es, xfs@oss.sgi.com

On 1/29/14, 7:39 AM, Juan A. Sillero wrote:
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

You lost only 1 disk?

So what exactly happened - what have you encountered, and what have
you done to try to fix it so far?

General rule - do NOT run xfs_repair in modification mode (i.e.
defaults, without "-n") or any other writes to the storage 
until you know the storage is properly re-assembled.

> The system is setup as follow:
>         XFS 6.1

Is this some variant of RHEL6.1?  XFS doesn't have version numbers
like that.  (Probably not IRIX 6.1?) :)

>         Raid 5 (12 x 2 disks of 2 Tb each)
>         Double disk controller managed by devmapper.
> 
> What we know at this point is the next:
> 
> 1) The topology of the disk is lost: the main-boot-record and the GPT
> are corrupted. 

Which makes me think that the raid is possibly not in good shape.

> 2) After running the testdisk utility we find 9 partitions instead of 1.
> 3) With gdisk we have tried to create a new main-boot-record and GPT,
> but it has not worked. 

Darn, so it sounds like you've already written to the storage.

> 4) We know that the blocksize is 4096 bytes, and the current capacity of
> the raid is under 20 Tb, so we suspect that even if the disk-manager
> says that the RAID is ok, it has not reconstructed the RAID after the
> disk failing.

I think you are right.

> We are stuck right now at this point, and help would be really
> appreciated in order to bring up the partition. We will be pleased to
> acknowledge the group in the upcoming publications.

Unfortunately it doesn't sound like an XFS problem at this point,
but rather a storage problem.  It's probably worth reaching out to
the device mapper people first, perhaps they can help make sure
the raid is properly reassembled.  Then we can see about picking up
the XFS pieces if any are left.

-Eric

> Thanks again, Juan A. Sillero 
> 
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
