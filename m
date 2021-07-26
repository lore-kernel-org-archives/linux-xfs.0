Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A889C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8876460F44
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbhGZQ2h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 12:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243465AbhGZQ17 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 12:27:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E49E960F44;
        Mon, 26 Jul 2021 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627319308;
        bh=U0DYVQba8m26zqgBmoaH6I6tpYtnXeEJjBWHK6VHXYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iaX3JQwHOJ9RccebjIztaUZq5RigapioqJrxzu7z5lTyF6r6Pv8eD7lY3P5vIPtvA
         KLGNI4ZEvKHhsjtHGZJHMmRrf71OqYLtisq6gP/SNHpGMbttBdbnofYkQXEo1ROdXd
         dP8jPbb5FBg90yD7+5vV7PDVg8XsMYGaqjeYQLsSLdA+Xfk39bV2Ne8BF0pnluUZDZ
         mTG6EiSpfSoYXxsg6X06yo2UjcCdmjL1mxdfspGtjVT42olZJ4rYhSj4uGDInfz3nf
         0aeRh0FsIQTHwUqw1eSsk8CVq3yscTfeyGiNM2dSj4417x+Ozjc+XQn7LEQG5wjnxa
         dYtXmNpfZYU+A==
Date:   Mon, 26 Jul 2021 10:08:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/530: Do not pass block size argument to
 _scratch_mkfs
Message-ID: <20210726170827.GU559212@magnolia>
References: <20210726064313.19153-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726064313.19153-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 12:13:11PM +0530, Chandan Babu R wrote:
> _scratch_do_mkfs constructs a mkfs command line by concatenating the values of
> 1. $mkfs_cmd
> 2. $MKFS_OPTIONS
> 3. $extra_mkfs_options
> 
> The block size argument passed by xfs/530 to _scratch_mkfs() will cause
> mkfs.xfs to fail if $MKFS_OPTIONS also has a block size specified. In such a
> case, _scratch_do_mkfs() will construct and invoke an mkfs command line
> without including the value of $MKFS_OPTIONS.
> 
> To prevent such silent failures, this commit removes the block size option
> that was being explicitly passed to _scratch_mkfs().

Yes, that makes sense.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/530 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/530 b/tests/xfs/530
> index 4d168ac5..16dc426c 100755
> --- a/tests/xfs/530
> +++ b/tests/xfs/530
> @@ -60,7 +60,7 @@ echo "Format and mount rt volume"
>  
>  export USE_EXTERNAL=yes
>  export SCRATCH_RTDEV=$rtdev
> -_scratch_mkfs -d size=$((1024 * 1024 * 1024)) -b size=${dbsize} \
> +_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
>  	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
>  _try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
>  
> -- 
> 2.30.2
> 
