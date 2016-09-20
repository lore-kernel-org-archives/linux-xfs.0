Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751643AbcITQ2b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Sep 2016 12:28:31 -0400
Date: Wed, 21 Sep 2016 00:28:29 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs_copy: Fix meta UUID handling on multiple copies
Message-ID: <20160920162829.GP12847@dhcp12-143.nay.redhat.com>
References: <510aeea2-6f26-aeee-d899-57e55049958d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510aeea2-6f26-aeee-d899-57e55049958d@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 20, 2016 at 10:50:39AM -0500, Eric Sandeen wrote:
> Zorro reported that when making multiple copies of a V5
> filesystem with xfs_copy while generating new UUIDs, all
> but the first copy were corrupt.
> 
> Upon inspection, the corruption was related to incorrect UUIDs;
> the original UUID, as stamped into every metadata structure,
> was not preserved in the sb_meta_uuid field of the superblock
> on any but the first copy.
> 
> This happened because sb_update_uuid was using the UUID present in
> the ag_hdr structure as the unchanging meta-uuid which is to match
> existing structures, but it also /updates/ that UUID with the
> new identifying UUID present in tcarg.  So the newly-generated
> UUIDs moved transitively from tcarg->uuid to ag_hdr->xfs_sb->sb_uuid
> to ag_hdr->xfs_sb->sb_meta_uuid each time the function got called.
> 
> Fix this by looking instead to the unchanging, original UUID
> present in the xfs_sb_t we are given, which reflects the original
> filesystem's metadata UUID, and copy /that/ UUID into each target
> filesystem's meta_uuid field.
> 
> Most of this patch is changing comments and re-ordering tests
> to match; the functional change is to simply use the *sb rather
> than the *ag_hdr to identify the proper metadata UUID.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

I can't reproduce that bug again after merge this patch. V4 and V5
XFS all test passed, different block size test passed too.

I didn't do regression test for this patch.

Thanks,
Zorro

> 
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 3c8998c..d8edfdd 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -494,27 +494,29 @@ write_wbuf(void)
>  
>  void
>  sb_update_uuid(
> -	xfs_sb_t	*sb,
> -	ag_header_t	*ag_hdr,
> -	thread_args	*tcarg)
> +	xfs_sb_t	*sb,		/* Original fs superblock */
> +	ag_header_t	*ag_hdr,	/* AG hdr to update for this copy */
> +	thread_args	*tcarg)		/* Args for this thread, with UUID */
>  {
>  	/*
>  	 * If this filesystem has CRCs, the original UUID is stamped into
> -	 * all metadata.  If we are changing the UUID in the copy, we need
> -	 * to copy the original UUID into the meta_uuid slot and set the
> -	 * set the incompat flag if that hasn't already been done.
> +	 * all metadata.  If we don't have an existing meta_uuid field in the
> +	 * the original filesystem and we are changing the UUID in this copy,
> +	 * we must copy the original sb_uuid to the sb_meta_uuid slot and set
> +	 * the incompat flag for the feature on this copy.
>  	 */
> -	if (!uuid_equal(&tcarg->uuid, &ag_hdr->xfs_sb->sb_uuid) &&
> -	    xfs_sb_version_hascrc(sb) && !xfs_sb_version_hasmetauuid(sb)) {
> +	if (xfs_sb_version_hascrc(sb) && !xfs_sb_version_hasmetauuid(sb) &&
> +	    !uuid_equal(&tcarg->uuid, &sb->sb_uuid)) {
>  		__be32 feat;
>  
>  		feat = be32_to_cpu(ag_hdr->xfs_sb->sb_features_incompat);
>  		feat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
>  		ag_hdr->xfs_sb->sb_features_incompat = cpu_to_be32(feat);
>  		platform_uuid_copy(&ag_hdr->xfs_sb->sb_meta_uuid,
> -				   &ag_hdr->xfs_sb->sb_uuid);
> +				   &sb->sb_uuid);
>  	}
>  
> +	/* Copy the (possibly new) fs-identifier UUID into sb_uuid */
>  	platform_uuid_copy(&ag_hdr->xfs_sb->sb_uuid, &tcarg->uuid);
>  
>  	/* We may have changed the UUID, so update the superblock CRC */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
