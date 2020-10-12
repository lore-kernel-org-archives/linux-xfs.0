Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543A9C433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 06:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3A472087D
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 06:59:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i32hKwTC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgJLG7n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 02:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgJLG7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 02:59:43 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2F1C0613CE
        for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2020 23:59:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k8so12669411pfk.2
        for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2020 23:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FGWAmAc7ERKxTvCdIN/xdexYiUyPP56tsL13RmuciOg=;
        b=i32hKwTCb+hg2iNZxz4sHHjfJJrx5uKp/jNu/W06XC80LAssi8IrQCiHAElhxtVE/d
         X3Rt16XEP1eZ8ldy36xYcZqkEVRrvmOvzB90aTJnb7KPDkFfzUfWS5igRR9AI++79Bqa
         0NY3L8HYagJhtX4H0x9y5+1uZiUKl/h+IhXfAxRFlieNW/J4E7vjfx9WBpjUT4ItZeXz
         yIX0okLK6oFqfr8nyygcZkw7iKy7OCb5Ku7f2fj7hT+wq/1njdsshXh+ahubUDYftzFd
         4TCcpy8sPzFUzemfIaX4aKFGXWqvlDgJuSLHzcUnH6lC9Sej2/Mq+/if2Z+j5Qmag9RP
         rwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FGWAmAc7ERKxTvCdIN/xdexYiUyPP56tsL13RmuciOg=;
        b=ZLggxI5YrlqMd4BNfxnUbb/PW24QjRPoN8oOvOvwZC9ay9hLByP7GsOzk4ozddHZ7N
         jyxPtAThWqBX2LDnQ+FkG1B/N8o2EG5EJTTvtm4IhutCs2aA3wGlvDXNjYJ0aDCIHRWg
         D+9tEaFzocfzfatYkCR8E6AGexME2ovUaqQIl0j+f+ytgUFz/ixXK0EDkKFD8Q41yntv
         IZU9tTv8gnH+vGEL4JmRkEgPYBWO5YBAqkF+OnlHmskFFEhUobX+4LcQ6xieUMEcGo4M
         VRyuxGgFrt6dN7aO61yfjiyP/RBCiPVPsEpAHaXd3NvT3VbGwz2B2dkQU9GyeShcakHy
         WdZQ==
X-Gm-Message-State: AOAM533DI1fsquPmeKSxazj3LFX1r5C8JiWmitokA4kkiu+0c31Hhaoa
        MPPke++QYdQLmZu31RUUJ81TwqREcLM=
X-Google-Smtp-Source: ABdhPJzfoBCabvGOkOtgkZS+49fldQiGTi1VtRdYlm/rfCkXDtYLDea9CVoJykYe7m6pesa3UDPGWQ==
X-Received: by 2002:a17:90a:fe13:: with SMTP id ck19mr18570893pjb.207.1602485982556;
        Sun, 11 Oct 2020 23:59:42 -0700 (PDT)
Received: from garuda.localnet ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id u27sm18213491pgm.60.2020.10.11.23.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 23:59:41 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: fix fallocate functions when rtextsize is larger than 1
Date:   Mon, 12 Oct 2020 11:58:36 +0530
Message-ID: <1606131.uXlqak7CaF@garuda>
In-Reply-To: <160235127396.1384192.5095447151831725417.stgit@magnolia>
References: <160235126125.1384192.1096112127332769120.stgit@magnolia> <160235127396.1384192.5095447151831725417.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 10 October 2020 11:04:34 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit fe341eb151ec, I forgot that xfs_free_file_space isn't strictly
> a "remove mapped blocks" function.  It is actually a function to zero
> file space by punching out the middle and writing zeroes to the
> unaligned ends of the specified range.  Therefore, putting a rtextsize
> alignment check in that function is wrong because that breaks unaligned
> ZERO_RANGE on the realtime volume.
> 
> Furthermore, xfs_file_fallocate already has alignment checks for the
> functions require the file range to be aligned to the size of a
> fundamental allocation unit (which is 1 FSB on the data volume and 1 rt
> extent on the realtime volume).  Create a new helper to return the
> desired allocation unit size, fix the fallocate frontend to use it,
> fix free_file_space to delete the correct range, and remove a now
> redundant check from insert_file_space.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Fixes: fe341eb151ec ("xfs: ensure that fpunch, fcollapse, and finsert operations are aligned to rt extent size")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |   17 ++++-------------
>  fs/xfs/xfs_file.c      |   10 ++++------
>  fs/xfs/xfs_inode.c     |   13 +++++++++++++
>  fs/xfs/xfs_inode.h     |    1 +
>  4 files changed, 22 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f2a8a0e75e1f..52cddcfee8a1 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -947,11 +947,10 @@ xfs_free_file_space(
>  	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
>  
>  	/* We can only free complete realtime extents. */
> -	if (XFS_IS_REALTIME_INODE(ip)) {
> -		xfs_extlen_t	extsz = xfs_get_extsz_hint(ip);
> -
> -		if ((startoffset_fsb | endoffset_fsb) & (extsz - 1))
> -			return -EINVAL;
> +	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 0) {
> +		startoffset_fsb = round_up(startoffset_fsb,
> +					   mp->m_sb.sb_rextsize);
> +		endoffset_fsb = round_down(endoffset_fsb, mp->m_sb.sb_rextsize);
>  	}
>  
>  	/*
> @@ -1147,14 +1146,6 @@ xfs_insert_file_space(
>  
>  	trace_xfs_insert_file_space(ip);
>  
> -	/* We can only insert complete realtime extents. */
> -	if (XFS_IS_REALTIME_INODE(ip)) {
> -		xfs_extlen_t	extsz = xfs_get_extsz_hint(ip);
> -
> -		if ((stop_fsb | shift_fsb) & (extsz - 1))
> -			return -EINVAL;
> -	}
> -
>  	error = xfs_bmap_can_insert_extents(ip, stop_fsb, shift_fsb);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 3d1b95124744..e9b4b1dada75 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -803,6 +803,8 @@ xfs_file_fallocate(
>  	enum xfs_prealloc_flags	flags = 0;
>  	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  	loff_t			new_size = 0;
> +	unsigned int		blksize = xfs_inode_alloc_blocksize(ip);
> +	unsigned int		blkmask = blksize - 1;
>  	bool			do_file_insert = false;
>  
>  	if (!S_ISREG(inode->i_mode))
> @@ -850,9 +852,7 @@ xfs_file_fallocate(
>  		if (error)
>  			goto out_unlock;
>  	} else if (mode & FALLOC_FL_COLLAPSE_RANGE) {
> -		unsigned int blksize_mask = i_blocksize(inode) - 1;
> -
> -		if (offset & blksize_mask || len & blksize_mask) {
> +		if ((offset | len) & blkmask) {
>  			error = -EINVAL;
>  			goto out_unlock;
>  		}
> @@ -872,10 +872,9 @@ xfs_file_fallocate(
>  		if (error)
>  			goto out_unlock;
>  	} else if (mode & FALLOC_FL_INSERT_RANGE) {
> -		unsigned int	blksize_mask = i_blocksize(inode) - 1;
>  		loff_t		isize = i_size_read(inode);
>  
> -		if (offset & blksize_mask || len & blksize_mask) {
> +		if ((offset | len) & blkmask) {
>  			error = -EINVAL;
>  			goto out_unlock;
>  		}
> @@ -917,7 +916,6 @@ xfs_file_fallocate(
>  			 *   2.) If prealloc returns ENOSPC, the file range is
>  			 *       still zero-valued by virtue of the hole punch.
>  			 */
> -			unsigned int blksize = i_blocksize(inode);
>  
>  			trace_xfs_zero_file_space(ip);
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2bfbcf28b1bd..20bb5fae0d00 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3813,3 +3813,16 @@ xfs_iunlock2_io_mmap(
>  	if (!same_inode)
>  		inode_unlock(VFS_I(ip1));
>  }
> +
> +/* Returns the size of fundamental allocation unit for a file, in bytes. */
> +unsigned int
> +xfs_inode_alloc_blocksize(
> +	struct xfs_inode	*ip)
> +{
> +	unsigned int		blocks = 1;
> +
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		blocks = ip->i_mount->m_sb.sb_rextsize;
> +
> +	return XFS_FSB_TO_B(ip->i_mount, blocks);
> +}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 751a3d1d7d84..270b35d9dcb0 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -475,5 +475,6 @@ void xfs_end_io(struct work_struct *work);
>  
>  int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
>  void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> +unsigned int xfs_inode_alloc_blocksize(struct xfs_inode *ip);
>  
>  #endif	/* __XFS_INODE_H__ */
> 
> 


-- 
chandan



