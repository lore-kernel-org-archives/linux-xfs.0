Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3EFCD98E9
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 03:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345034AbjJKDTM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 23:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344969AbjJKDTL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2023 23:19:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E864F92
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2023 20:19:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5971FC433C8;
        Wed, 11 Oct 2023 03:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696994348;
        bh=Kb2JHzlzl5FfsYaSgSAxUDUj44BcxpRhMaaJ6Tt9wF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GZ6dri7p+wIgYcOjmnzJlNuCoQoKuWUAwzHN4SCaGUGM//h9klGKn/nJR9IWN8cuB
         UEvSqedJ+9bPSuLuVrQraRUP8rtrBrH+MEErqbB6jcQk3pFJBX0ckgYJU1RY8HRQ+Q
         yv7Mz88JDsNV0jorMk1JQHT4xtVHIinilrneumk6OggFEHNhNz9xsxuXjweP6VNRqS
         NVSUgJ9C6TNjeLp2DdA6U2jG5RpefS80uls6VDz387j4M/2U/jhMtRwDg54iMujWMa
         eYK9VbL3SEYEVqSKC6L0Zd3ALSYiZfvxkQVYcENS7sGgL7u45M9pwM7eo3VcWiBWqc
         JyDDcwLpO4mkA==
Date:   Tue, 10 Oct 2023 20:19:06 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 09/28] fsverity: pass log_blocksize to
 end_enable_verity()
Message-ID: <20231011031906.GD1185@sol.localdomain>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-10-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006184922.252188-10-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 08:49:03PM +0200, Andrey Albershteyn wrote:
> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index 252b2668894c..cac012d4c86a 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -51,6 +51,7 @@ struct fsverity_operations {
>  	 * @desc: the verity descriptor to write, or NULL on failure
>  	 * @desc_size: size of verity descriptor, or 0 on failure
>  	 * @merkle_tree_size: total bytes the Merkle tree took up
> +	 * @log_blocksize: log size of the Merkle tree block
>  	 *
>  	 * If desc == NULL, then enabling verity failed and the filesystem only
>  	 * must do any necessary cleanups.  Else, it must also store the given
> @@ -65,7 +66,8 @@ struct fsverity_operations {
>  	 * Return: 0 on success, -errno on failure
>  	 */
>  	int (*end_enable_verity)(struct file *filp, const void *desc,
> -				 size_t desc_size, u64 merkle_tree_size);
> +				 size_t desc_size, u64 merkle_tree_size,
> +				 u8 log_blocksize);

Maybe just pass the block_size itself instead of log2(block_size)?

- Eric
