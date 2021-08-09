Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9144C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 17:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDC69601FD
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 17:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhHIRZE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 13:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233819AbhHIRZE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Aug 2021 13:25:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1A1861058;
        Mon,  9 Aug 2021 17:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628529883;
        bh=mIqqdZ+gFu28zevTWFk8XiuUw1/RN1AX3p1/Of6ckf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hHPSV3Zea/y1AcuUHMRQs1Krkkpo2oDPVYyPOmp8h27Vda1l8S/KgaGWPVnoG7beH
         uXFtKo9qMQID3Sx/ende2gbsO7qaJ+32m7Ocv4rSnUUCKrvwu52NQuEAHu8Wp/MtnJ
         utkGRgiQDcy5vRu/TAvPQ+EJIKpSx63P2Tomkv08HsUCHg2yRWhNLI0OVD+zULseR3
         8RSKOUB5DnBgQMkZ+h5/UfOskHiA1mMN66yrC8IFwkife1zP/FIPyMb1aIZEgWBGZE
         XMo+bkTavevN8Z+2pD27iwNkNzo0a7yI7y7nWF7Aw9O4k1xfY+kgVKdv6Nrw/Rz9TW
         3GybjIYk8+euA==
Date:   Mon, 9 Aug 2021 10:24:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 04/16] xfs: Return from xfs_attr_set_iter if there
 are no more rmtblks to process
Message-ID: <20210809172443.GF3601443@magnolia>
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

Hmm.  I applied this patch and saw a regression in xfs/125:

--- /tmp/fstests/tests/xfs/125.out      2021-05-13 11:47:55.824859905 -0700
+++ /var/tmp/fstests/xfs/125.out.bad    2021-08-09 09:50:23.839261469 -0700
@@ -11,3 +11,5 @@
 + chattr -R -i
 + modify xattr (2)
 + check fs (2)
+xfs_repair should not fail
+(see /var/tmp/fstests/xfs/125.full for details)

Which turned out to be repair tripping over an INCOMPLETE xattr key
after the fs unmounts cleanly in "+ modify xattr (2)".

--D

> +
>  			dac->dela_state = XFS_DAS_FOUND_NBLK;
>  		}
>  		return -EAGAIN;
> -- 
> 2.7.4
> 
