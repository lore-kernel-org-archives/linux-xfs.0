Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CA5C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 17:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC11364E05
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 17:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhA1Rbb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 12:31:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233197AbhA1R3K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 12:29:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EDEC61481;
        Thu, 28 Jan 2021 17:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611854909;
        bh=ZN8d+9yMh98r7+e7L9NB/1Ul78CdAiPyN3+PbXhbsAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J+kW6TH60EdENSZSiTlqnCdkGSAXE4RXe2IGeNNK7XLOMd8DbvNMDqngj/A7gpV0C
         GNnE7iYpkjZd8EL+khm3CU/rqUgI3PXKRQxqNoe07ZP/eV0In/Bm4WGWsYIRye8caU
         eiMikskr6hjnnKKekr25EyuU1f29wY+YRNyN/+JXHqmpTd/kFLJsd1eTMMIJbVuXrK
         RnilADhKu2Lpd/zqPUY8/DhWs5zQwA1WvFCtTYXhyOm6NEUWSd/1K91ZvcU1TNjCg2
         hjWeJwo/V8MH4nJjVnSnVaGCKYxA+iOxJeCmxqrUIigOWot4TwNkSFg+JABCI/IF51
         nOvlWd61Nqgjg==
Date:   Thu, 28 Jan 2021 09:28:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_logprint: decode superblock updates correctly
Message-ID: <20210128172828.GP7698@magnolia>
References: <20210128073708.25572-1-ddouwsma@redhat.com>
 <20210128073708.25572-3-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128073708.25572-3-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 06:37:08PM +1100, Donald Douwsma wrote:
> Back when the way superblocks are logged changed, logprint wasnt
> updated updated. Currently logprint displays incorrect accounting

Double 'updated'.

> information.
> 
>  SUPER BLOCK Buffer:
>  icount: 6360863066640355328  ifree: 262144  fdblks: 0  frext: 0
> 
>  $ printf "0x%x\n" 6360863066640355328
>  0x5846534200001000
> 
> Part of this decodes as 'XFSB', the xfs superblock magic number and not
> the free space accounting.
> 
> Fix this by looking at the entire superblock buffer and using the format
> structure as is done for the other allocation group headers.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  logprint/log_misc.c      | 22 +++++++++-------------
>  logprint/log_print_all.c | 23 ++++++++++-------------
>  2 files changed, 19 insertions(+), 26 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index d44e9ff7..929842d0 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -243,25 +243,21 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>  	xlog_print_op_header(head, *i, ptr);
>  	if (super_block) {
>  		printf(_("SUPER BLOCK Buffer: "));
> -		if (be32_to_cpu(head->oh_len) < 4*8) {
> +		if (be32_to_cpu(head->oh_len) < sizeof(struct xfs_sb)) {
>  			printf(_("Out of space\n"));
>  		} else {
> -			__be64		 a, b;
> +			struct xfs_sb *sb, sb_s;
>  
>  			printf("\n");
> -			/*
> -			 * memmove because *ptr may not be 8-byte aligned
> -			 */
> -			memmove(&a, *ptr, sizeof(__be64));
> -			memmove(&b, *ptr+8, sizeof(__be64));
> +			/* memmove because *ptr may not be 8-byte aligned */
> +			sb = &sb_s;
> +			memmove(sb, *ptr, sizeof(struct xfs_sb));
>  			printf(_("icount: %llu  ifree: %llu  "),
> -			       (unsigned long long) be64_to_cpu(a),
> -			       (unsigned long long) be64_to_cpu(b));
> -			memmove(&a, *ptr+16, sizeof(__be64));
> -			memmove(&b, *ptr+24, sizeof(__be64));
> +				be64_to_cpu(sb->sb_icount),
> +				be64_to_cpu(sb->sb_ifree) );

Extra space at the end ..................................^

>  			printf(_("fdblks: %llu  frext: %llu\n"),
> -			       (unsigned long long) be64_to_cpu(a),
> -			       (unsigned long long) be64_to_cpu(b));
> +				be64_to_cpu(sb->sb_fdblocks),
> +				be64_to_cpu(sb->sb_frextents));
>  		}
>  		super_block = 0;
>  	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index 2b9e810d..8ff87068 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -91,22 +91,19 @@ xlog_recover_print_buffer(
>  		len = item->ri_buf[i].i_len;
>  		i++;
>  		if (blkno == 0) { /* super block */
> -			printf(_("	SUPER Block Buffer:\n"));
> +                        struct xfs_sb *sb = (struct xfs_sb *)p;
> +			printf(_("	Super Block Buffer: (XFSB)\n"));
>  			if (!print_buffer)
>  				continue;
> -		       printf(_("              icount:%llu ifree:%llu  "),
> -			       (unsigned long long)
> -				       be64_to_cpu(*(__be64 *)(p)),
> -			       (unsigned long long)
> -				       be64_to_cpu(*(__be64 *)(p+8)));
> -		       printf(_("fdblks:%llu  frext:%llu\n"),
> -			       (unsigned long long)
> -				       be64_to_cpu(*(__be64 *)(p+16)),
> -			       (unsigned long long)
> -				       be64_to_cpu(*(__be64 *)(p+24)));
> +			printf(_("		icount:%llu  ifree:%llu  "),
> +					be64_to_cpu(sb->sb_icount),
> +					be64_to_cpu(sb->sb_ifree));
> +			printf(_("fdblks:%llu  frext:%llu\n"),
> +					be64_to_cpu(sb->sb_fdblocks),
> +					be64_to_cpu(sb->sb_frextents));
>  			printf(_("		sunit:%u  swidth:%u\n"),
> -			       be32_to_cpu(*(__be32 *)(p+56)),
> -			       be32_to_cpu(*(__be32 *)(p+60)));
> +			       be32_to_cpu(sb->sb_unit),
> +			       be32_to_cpu(sb->sb_width));

/me wonders if these nearly identical decoder routines ought to be
refactored into a common helper?

Also, what happens if logprint encounters a log from before whenever we
changed superblock encoding in the log?  When was that, anyway?

--D

>  		} else if (be32_to_cpu(*(__be32 *)p) == XFS_AGI_MAGIC) {
>  			int bucket, buckets;
>  			agi = (xfs_agi_t *)p;
> -- 
> 2.27.0
> 
