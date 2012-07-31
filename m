Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6VHRKqB202624 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 12:27:21 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 71iwUSN1fvTvyked
	for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 10:27:20 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id DBB0D6C19D
	for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 12:27:19 -0500 (CDT)
Message-ID: <50181578.1090104@hardwarefreak.com>
Date: Tue, 31 Jul 2012 12:27:20 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_growfs / planned resize / performance impact
References: <5017E426.2040709@profihost.ag>
In-Reply-To: <5017E426.2040709@profihost.ag>
Reply-To: stan@hardwarefreak.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 7/31/2012 8:56 AM, Stefan Priebe - Profihost AG wrote:
> Hello list,
> 
> i'm planning to create a couple of VMs with just 30GB of space while
> using xfs as the main filesystem.
> 
> Now i alreay know that some of the VMs will grow up to 250GB while
> resizing the block device and using xfs_growfs.

If you already know they *will* need 250GB, make them 250GB now.  This
is common sense.

> Should i take care of that and format these disks with special parameters?

Take care of what?  Preemptively avoid what?

> I've discovered that a 500GB volume has agcount=4 and 64000 blocks of
> internal log - while a 300GB volume resized to 500GB has agcount 7 ad
> only 40960 blocks of internal log.

4 AGs is the default when an XFS is created unless the device is over
4TB.  When you grow XFS, new AGs must be created in the new space.  This
is because once an AG is "laid down" it doesn't move and its size never
changes.  Any time you grow and XFS you get more AGs.  This is by design.

> Is it a problem if this grow will happen in small portions (30GB => 50GB
> => 75GB => 100GB => ... 300GB)?

It 'could' be a problem.  But there's no way for us to know that
without, drum roll please, you guessed it-- knowing your workload and
the characteristics of the underlying storage.

Wild ass guess?  These are virtual machines with relatively tiny
storage.  Performance isn't critical or you'd not attempt this in the
first place.  So, I'd guess no, it won't be a problem.

If on the other hand you need high performance to these filesystems,
then you need to provide details of the storage device and the workloads
and we'll discuss it further.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
