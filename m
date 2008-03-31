Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Mar 2008 17:52:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2V0qNwZ032309
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2008 17:52:25 -0700
Message-ID: <47F035E3.1030004@sgi.com>
Date: Mon, 31 Mar 2008 11:52:51 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] fix attr fit checking for filesystems which have
 lost their attr2
References: <47EDCBF9.4070102@sandeen.net>
In-Reply-To: <47EDCBF9.4070102@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Hi Eric,

Eric Sandeen wrote:
> Regarding the F8 corruption...  I have a pretty narrow testcase
> now, and it turns out this was a bit of a perfect storm.
> 
> First, F8 shipped 2.6.23 which had the problem with sb_features2
> padding out on 64-bit boxes, but this was ok because userspace
> and kernelspace both did this, and it was properly mounting &
> running as attr2.
> 
> However, hch came along in 2.6.24 and did some endian annotation 
> for the superblock and in the process:
>> A new helper xfs_sb_from_disk handles the other (read)
>> direction and doesn't need the slightly hacky table-driven approach
>> because we only ever read the full sb from disk.
> 
> However, this resulted in kernelspace behaving differently,
> and now *missing* the attr2 flag in sb_features2, (actually
> sb_bad_features2) so we mounted as if we had attr1.  Which 
> is really supposed to be ok, IIRC, 

Yes, I remember Nathan saying that too ;-)

> except in 
> xfs_attr_shortform_bytesfit we return the default
> fork offset value from the superblock, even if di_forkoff
> is *already* set.  In the error case I had, di_forkoff was set
> to 15 (from previously being attr2...) but we returned 14
> (the mp default) and I think this is where things started
> going wrong; I think this caused us to write an attr on top
> of the extent data.
> 
> My understanding of this is that if di_forkoff is non-zero,
> we should always be using it for space calculations, regardless
> of whether we are mounted with attr2 or not...
> 
That was my understanding as well.
I'll have a look at the code soon and see if I can
see any problems with the change and the consistency
of it all.

Thanks a bunch,
Tim.

> and with that, how's this look, to be honest I haven't run it
> through QA yet...
> 
> I'm not certain if xfs_bmap_compute_maxlevels() may lead
> to similar problems....
> 
> ------------------
> 
> always use di_forkoff for when checking for attr space
> 
> In the case where we mount a filesystem which was previously
> using the attr2 format as attr1, returning the default
> mp->m_attroffset instead of the per-inode di_forkoff for
> inline attribute fit calculations may result in corruption,
> if the existing "attr2" formatted attribute is already taking
> more space than the default.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> 
> Index: linux-2.6-git/fs/xfs/xfs_attr_leaf.c
> ===================================================================
> --- linux-2.6-git.orig/fs/xfs/xfs_attr_leaf.c
> +++ linux-2.6-git/fs/xfs/xfs_attr_leaf.c
> @@ -166,7 +166,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
>  
>  	if (!(mp->m_flags & XFS_MOUNT_ATTR2)) {
>  		if (bytes <= XFS_IFORK_ASIZE(dp))
> -			return mp->m_attroffset >> 3;
> +			return dp->i_d.di_forkoff;
>  		return 0;
>  	}
> 
