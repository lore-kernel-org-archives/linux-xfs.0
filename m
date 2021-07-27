Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F6DC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C49C60FE3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhG0XaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 19:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232745AbhG0XaX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 19:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7557760FEA;
        Tue, 27 Jul 2021 23:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428622;
        bh=q0rhdKjrAw4nN1jSemYuppa8kFVy+QtmJsPFOj99QcE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ANG7g03xEcA5bA1NsActEYvDYv73tyi+BAqom5+UqDBB+t2YJR7FFMLeAwY71OaLt
         LQaqY2MPYDpdfcO2wbTr7k6eAGbe1e7G6IcYNj1S4q6WcDHgyknUGnkjv1pw3HkXpM
         pyFaSTCJWswZVYStyUymZg8MzBF85X9ODIPYEZjuK2eqxUChHRtfeLX6ki5LhnnyuR
         hvwOfEdd8MXaID2Z7lt1W0pNjPDdne+3ELOrSLj1Zi1JxrYU9UGwuMOW6WyuXhUBty
         xZC6xItIQDW92q9TDu/ogEpSUxfsIncMt4Y0YTpghqEO1qdMs/8ldl+E/dtAdzBDaZ
         zNQgQdcI/4PiA==
Date:   Tue, 27 Jul 2021 16:30:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 04/16] xfs: Return from xfs_attr_set_iter if there
 are no more rmtblks to process
Message-ID: <20210727233022.GZ559212@magnolia>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727062053.11129-5-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 11:20:41PM -0700, Allison Henderson wrote:
> During an attr rename operation, blocks are saved for later removal
> as rmtblkno2. The rmtblkno is used in the case of needing to alloc
> more blocks if not enough were available.  However, in the case
> that neither rmtblkno or rmtblkno2 are set, we can return as soon
> as xfs_attr_node_addname completes, rather than rolling the transaction
> with an -EAGAIN return.  This extra loop does not hurt anything right
> now, but it will be a problem later when we get into log items because
> we end up with an empty log transaction.  So, add a simple check to
> cut out the unneeded iteration.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d9d7d51..5040fc1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -409,6 +409,13 @@ xfs_attr_set_iter(
>  			if (error)
>  				return error;
>  
> +			/*
> +			 * If addname was successful, and we dont need to alloc
> +			 * or remove anymore blks, we're done.
> +			 */
> +			if (!args->rmtblkno && !args->rmtblkno2)
> +				return 0;
> +
>  			dac->dela_state = XFS_DAS_FOUND_NBLK;
>  		}
>  		return -EAGAIN;
> -- 
> 2.7.4
> 
