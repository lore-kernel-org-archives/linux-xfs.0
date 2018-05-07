Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45220 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752081AbeEGQ7z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 12:59:55 -0400
Date: Mon, 7 May 2018 09:59:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: check and repair quota metadata
Message-ID: <20180507165936.GA26569@magnolia>
References: <9e494d70-53bd-db81-c118-73ef7eaad667@redhat.com>
 <20180507163242.GZ26569@magnolia>
 <bee0bca3-fb1c-13a0-0dfb-ba1cd66662be@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bee0bca3-fb1c-13a0-0dfb-ba1cd66662be@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, May 07, 2018 at 11:44:00AM -0500, Eric Sandeen wrote:
> On 5/7/18 11:32 AM, Darrick J. Wong wrote:
> 
> >> diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
> >> index bb1b13a9..067475e2 100644
> >> --- a/libxfs/xfs_quota_defs.h
> >> +++ b/libxfs/xfs_quota_defs.h
> >> @@ -30,6 +30,8 @@
> >>  typedef uint64_t	xfs_qcnt_t;
> >>  typedef uint16_t	xfs_qwarncnt_t;
> >>  
> >> +#define XFS_DQUOT_CLUSTER_SIZE_FSB (xfs_filblks_t)1
> > 
> > Requires a kernel patch, right? :)
> 
> oh derp, I'll move that elsewhere, maybe the non-priv userspace
> libxfs header, I'll see.

<shrug> Seems like a trivial mod...

> 
> >> diff --git a/repair/incore.h b/repair/incore.h
> >> index fd66084f..78a0ed30 100644
> >> --- a/repair/incore.h
> >> +++ b/repair/incore.h
> >> @@ -222,13 +222,16 @@ int		count_bcnt_extents(xfs_agnumber_t);
> >>  #define XR_INO_RTDATA	2		/* realtime file */
> >>  #define XR_INO_RTBITMAP	3		/* realtime bitmap inode */
> >>  #define XR_INO_RTSUM	4		/* realtime summary inode */
> >> -#define XR_INO_DATA	5		/* regular file */
> >> -#define XR_INO_SYMLINK	6		/* symlink */
> >> -#define XR_INO_CHRDEV	7		/* character device */
> >> -#define XR_INO_BLKDEV	8		/* block device */
> >> -#define XR_INO_SOCK	9		/* socket */
> >> -#define XR_INO_FIFO	10		/* fifo */
> >> -#define XR_INO_MOUNTPOINT 11		/* mountpoint */
> >> +#define XR_INO_UQUOTA	5		/* user quota inode */
> >> +#define XR_INO_GQUOTA	6		/* group quota inode */
> >> +#define XR_INO_PQUOTA	7		/* project quota inode */
> > 
> > /me wonders, is there an advantage/requirement to insert the three quota
> > inode types in the middle of the range instead of tacking them on the
> > end?
> > 
> > Anyway the rest mostly looks ok to me.
> 
> Probably not, I was grouping the internal special inodes together IIRC, but
> happy just move them to the end if that's preferable.

Ok.  I wasn't sure if there was some hidden ordering requirement buried
in here, but at a first glance I didn't see a reason to renumber the
whole list.

--D

> -Eric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
