Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 26DB77CAE
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 00:42:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ED5B58F8039
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 22:42:03 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 6t64fbettUzq4cmr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 22:42:01 -0700 (PDT)
Date: Wed, 1 Jun 2016 22:41:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS_IOC_FSEMAP (old XFS_IOC_FIEMAPFS)
Message-ID: <20160602054151.GE5053@birch.djwong.org>
References: <20160601123650.GC7967@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160601123650.GC7967@redhat.com>
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
To: xfs@oss.sgi.com, cmaiolino@redhat.com, Dave Chinner <david@fromorbit.com>

On Wed, Jun 01, 2016 at 02:36:50PM +0200, Carlos Maiolino wrote:
> Howdy folks,
> 
> I've talked to Dave about moving forward XFS_IOC_FIEMAPFS ioctl, and
> consequently their users, such as xfs_spaceman tool.
> 
> For now, I'm porting the old stuff to the current code, doing code cleanups,
> etc.
> 
> If someone wants to take a look, I've made the patches available here:
> 
> https://github.com/cmaiolino/linux/tree/fsemap
> 
> For now, I just did the port forward of the patches, but still need to clean up
> a few stuff, and also port forward xfs_spaceman.
> 
> As per Dave suggestion (as you can see in $SUBJ), the ioctl has been renamed to
> XFS_IOC_FSEMAP.

I was planning to push the GETFSMAPX ioctl that we talked about at LSF
as part of the reverse mapping patchset:

https://lwn.net/Articles/685978/

Patches here:

https://github.com/djwong/linux/commit/fa063533cffa4627f423ba952422796da9364cfc
https://github.com/djwong/xfsprogs/commit/21502ebb972f03319940fe8bb1a1e6fcb181ed3f
https://github.com/djwong/xfsprogs/commit/8347e762e3b94dc14f40754a4db952acdadfb080
https://github.com/djwong/man-pages/commit/822729ce87cb389f5d980d88187d86745e41ecd5

GETFSMAPX reports device id and owner id, which (AFAICT) FSEMAP
doesn't.  I think the btrfs folks are interested in using the
(possibly obsolete) mappings for duperemove enhancements, and from the
brief look I took at spaceman, it could use this interface for its
reporting.  xfs_scrub could (possibly) use it to figure out which
parts of the disk to scrub.

I think it'd be pretty simple to bring spaceman up to date with
current xfsprogs and teach it to use GETFSMAPX.  I also think there
could be a (stupider) GETFSMAPX implementation for non-rmapbt
filesystems that only reports free space extents that are in the
bnobt.

--D

> 
> -- 
> Carlos
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
