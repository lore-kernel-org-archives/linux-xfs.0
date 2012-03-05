Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q25MSCkg023332 for <xfs@oss.sgi.com>; Mon, 5 Mar 2012 16:28:12 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZzyPFAqHsUgvmkNF for <xfs@oss.sgi.com>;
	Mon, 05 Mar 2012 14:28:10 -0800 (PST)
Date: Tue, 6 Mar 2012 09:28:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: failed to set versionnum in AG 1
Message-ID: <20120305222807.GE3592@dastard>
References: <alpine.LRH.2.02.1203041803340.8964@mail.vlasiu.net>
	<20120305011032.GL5091@dastard>
	<alpine.LRH.2.02.1203050912001.10815@mail.vlasiu.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1203050912001.10815@mail.vlasiu.net>
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
To: Gabriel VLASIU <gabriel@vlasiu.net>
Cc: xfs@oss.sgi.com

On Mon, Mar 05, 2012 at 09:31:38AM +0200, Gabriel VLASIU wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi Dave!
> 
> On Mon, 5 Mar 2012, Dave Chinner wrote:
> 
> > > # xfs_db -x /dev/sdh1
> > > xfs_db> version
> > > versionnum [0xb4b4+0x8] = V4,ATTR,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2
> > 
> > it already has the attr2 feature bit set.
> Yes, it has. But another (old) partition does not have ATTR2 enabled. And 
> the error is the same when I try to set ATTR2. And the funny thing is, 
> after that, version report ATTR2 as set.

That's because the error you are getting is for setting the value
into secondary superblocks, but the primary superblock has had the
value set correctly.

> All my partitions have been created on RHEL5 (some are even older). On a 
> new partition (created on RHEL6) I can set ATTR2 over and over again 
> without any error reported. Should I backup everything, reformat all 
> partitions and restore everything?

No, most definitely not. There's nothing wrong with your
filesystems.

> > > xfs_db> version attr2
> > > writing all SBs
> > > Superblock has mismatched features2 fields, skipping modification
> > > failed to set versionnum in AG 1

That's a secondary superblock it failed on - the kernel never reads
or writes the secondary superblocks (execpt during a grow operation)
and repair will fix any mismatches if the primary gets trashed so
the error is pretty much irrelevant...

> > > versionnum [0xb4b4+0x8] = V4,ATTR,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2
> > 
> > What version of xfs_db are you using?
> 3.1.1 and 3.1.7

So you're using the versions that detect inconsistencies correctly,
and also write everythign consistently. So it's a problem from an
old mkfs binary (2.9.x or 3.0.x) or caused by something you've done
poking around with xfs_db.

> > automatically when it gets used because on recent kernels it is the
> > default mount option. If you have an older kernel and need to turn
> > attr2 on, then simply add the "attr2" field to the mount options on
> > the filesystem. Once xfs_info reports attr=2 for the filesytem, you
> > can remove the attr2 mount option...
> Thank you, but I know that. In fact it was the first thing I tried: can 
> the filesystem be be mounted if I add attr2 is in fstab. And I was able to 
> do so. Still, ATTR2 was not reported for the partition I was talking 
> above (without ATTR2 reported by version).

You didn't say that. Go back and read what I said, though:

"Once xfs_info reports attr=2 for the filesytem, you
can remove the attr2 mount option..."

The attr2 feature bit will only get set when the attr2 format
is first used, so if you're workload isn't causing attr2 format
inodes to be created, the feature bit will not get set. Hence you
need to leave the mount option set until xfs_info (which reads the
superblock feature bits) reports it being set.

> But that's not the point. I see an error message here "Superblock has 
> >>mismatched<< features2 fields". And another one ">>failed<< to set 
> versionnum in AG 1".

Yes, I know, but that's a secondary issue because you should not
*ever* need to use xfs_db to set the attr2 feature field, not to
mention that the primary superblock already has the correct bits set
and the secondaries are not actually required at runtime.

IOWs, if you have to resort to using xfs_db to set a feature bit,
you are doing something wrong. xfs_admin and/or mount options give
you control over all feature bits that are safe for user
modification...

> Still, xfs_repair does not see anything wrong with the filesystem. So 
> who's wrong? xfs_repair or xfs_db?

There's nothing wrong with either of them, likewise there is nothing
really wrong with your filesystem.

> An most important: it's possible in the future to loose some data?

No.

So, if you want to make everything absolutely consistent with xfs_db
(seeing as something is inconsistenti as a result of either the age
of the filesystems or the poking you've done) then you need to copy
the sb_features2 field to sb_bad_features2 field in every secondary
superblock. i.e. something like:

xfs_db -c "sb 0" -c "print features2" <dev>
<value>

for i in `seq 1 1 <number of ags in fs>`; do
	xfs_db -x -c "sb $i" -c "write features2 <value>" \
			     -c "write bad_features2 <value>" <dev>
done

And that will set all the features2 and bad_features2 fields to the
same value as in the primary superblock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
