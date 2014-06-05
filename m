Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 262BE7F3F
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 18:56:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CFFAA304053
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 16:56:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	55xj0FGa8dsQiKbM for <xfs@oss.sgi.com>;
	Thu, 05 Jun 2014 16:56:37 -0700 (PDT)
Date: Fri, 6 Jun 2014 09:56:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_mdrestore: initialize sb prior to xfs_sb_from_disk()
Message-ID: <20140605235633.GC4453@dastard>
References: <5390F89C.2050305@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5390F89C.2050305@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jun 05, 2014 at 06:09:16PM -0500, Eric Sandeen wrote:
> If we xfs_mdrestore an image from a non-crc filesystem, lo
> and behold the restored image has gained a CRC:
> 
> # db/xfs_metadump.sh -o /dev/sdc1 - | xfs_mdrestore - test.img
> # xfs_db -c "sb 0" -c "p crc" /dev/sdc1
> crc = 0 (correct)
> # xfs_db -c "sb 0" -c "p crc" test.img
> crc = 0xb6f8d6a0 (correct)
> 
> Obviously it can't really be correct :)
> 
> The problem is, xfs_sb_from_disk doesn't fill in the sb_crc
> field.
> 
> An earlier commit:
> 
>   47de6e1 repair: ensure that unused superblock fields are zeroed
> 
> fixed this same sort of problem for xfs_repair.  Do the same
> for mdrestore.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Patch looks fine, but lets answer the question below before pushing
this...

> ---
> 
> But ... should we maybe just do this once and for all in
> xfs_sb_from_disk?  I'm not sure leaving it up to every
> caller is a good idea, unless somebody ahs a reason to
> pre-populate some fields - I can't imagine why that would
> be, though...

We don't ever read in the CRC field into the in-memory structures
because it has no meaning in memory. Simiarly, we don't ever write
the CRC field from the in-core structure because we always
re-calculate it in the IO path if CRCs are configured. That is
consistent behaviour across the entire code-base.

The superblock is a special case because of the way it is written.
In kernel, we only write *specific* fields based on the field
bitmask passed to xfs_mod_sb(), and we never set the CRC field bit
in the kernel. Hence we never write that field to the superblock
except when growing the filesystem and are initialising new
secondary superblocks (where the in memory value is zero, anyway).

Essentially, what userspace doing is the same:

	libxfs_sb_to_disk(buf, sbp, XFS_SB_ALL_BITS)

which is telling the code to write the sb_crc field from the
in-memory superblock buffer. So, either we need to zero the
sbp->sb_crc field before it gets written, or we need to mask out
the XFS_SB_CRC bit from the writable flags.

IMO, the former is the correct thing to do we have to ensure that
fields that are not read from disk appear in memory as zero. That
way no matter how the superblock is written it will have the correct
zero values for anything that was not specifically initialised....

Perhaps we should move the memset() to within xfs_sb_from_disk()
to make this explicit?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
