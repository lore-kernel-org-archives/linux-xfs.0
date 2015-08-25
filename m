Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C606D7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 18:04:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0DEC30404E
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 16:04:09 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4q4o5OHiTgutzBDf for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 16:04:07 -0700 (PDT)
Date: Wed, 26 Aug 2015 09:03:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Cant mount xfs lvm. Experimental Features?
Message-ID: <20150825230353.GK714@dastard>
References: <8a6d5afa8829aec73d911f35815d7b92@zbfmail.de>
	<20150825115412.GI714@dastard>
	<5ab00519660fd5ed1b3d347658dba1f2@zbfmail.de>
	<55DCB158.20505@sandeen.net>
	<fe88fd1604660f15cea80477b3855e77@zbfmail.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <fe88fd1604660f15cea80477b3855e77@zbfmail.de>
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
To: weber@zbfmail.de
Cc: Xfs <xfs@oss.sgi.com>

On Wed, Aug 26, 2015 at 12:53:51AM +0200, Marko Weber|8000 wrote:
[....]
> i rebootet the machine and created a new logical volume.
> i formatted the lv with mkfs.xfs
> i tried to mount it on the new kernel:
> 
> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Version 5
> superblock detected. This kernel has EXPERIMENTAL support enabled!
> Aug 26 00:47:17 backupserver kernel: Use of these features in this
> kernel is at your own risk!
> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Superblock has
> unknown read-only compatible features (0x1) enabled.
> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): Attempted to mount
> read-only compatible filesystem read-write.
> Aug 26 00:47:17 backupserver kernel: Filesystem can only be safely
> mounted read only.
> Aug 26 00:47:17 backupserver kernel: XFS (dm-2): SB validate failed
> with error 22.
> 
> 
> this happens with the newly created logical volume.
> 
> the other 2 lvm partitions with xfs are fine.
> 
> any idea?

Clearly you have a kernel too old to read the on-disk format that
mkfs.xfs has written - as I pointed out originally.

Would you please tell us what the versions of the kernels
you are using, as well as the mkfs.xfs version?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
