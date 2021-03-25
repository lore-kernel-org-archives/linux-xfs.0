Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722D2C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 17:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D70561A2D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 17:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCYRvB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 13:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhCYRuz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 13:50:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C96A861A2C;
        Thu, 25 Mar 2021 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616694654;
        bh=tMUbvMGW4GFm3c9SJSicGeAiTQfATDqUMe5Oxp3eGtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NZUpc6nVPWD96OrB6bSrgiIVm0dRzct/fywwo5bN50DqnFajzTcqboq1TzKRCHXGN
         NXTLAipNta2jNdn78SnNx12eHHA+nkkVHKvHxPO+nIvP8wJd/wKZx/oAQZEUzhq6pE
         UpEuiLp6mH6t5Xl2pvkgPqP1KCveTkEwXXhBlE/kwcSqxubQYtSJy5wrxyDDE57iun
         S+grxZblLbp6k42+5eGzzvIj5Mh/VWkW2/C8QKkfwWdipx4Li3ATpanNKkg6cDjfJd
         hjodECNNUzTXQym5L+hwNXwc7ZMHmaoyD8hFHT5VU4byqkpcU6Qyx0wIsLgfHLTxx8
         rUSDoIrJXnqcw==
Date:   Thu, 25 Mar 2021 10:50:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] common/xfs: support realtime devices with
 _scratch_xfs_admin
Message-ID: <20210325175054.GJ4090233@magnolia>
References: <161647323173.3431002.17140233881930299974.stgit@magnolia>
 <161647323723.3431002.10715201555327186329.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161647323723.3431002.10715201555327186329.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 09:20:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach _scratch_xfs_admin to support passing the realtime device to
> xfs_admin so that we can actually test xfs_admin functionality with
> those setups.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/xfs |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 69f76d6e..9cb373ba 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -269,9 +269,15 @@ _test_xfs_db()
>  _scratch_xfs_admin()
>  {
>  	local options=("$SCRATCH_DEV")
> +	local rtopts=()

NAK, this name is inconsistent with the rest of the function and stupid
bash will just create the rt_opts array in the global namespace with no
complaints whatsoever.

--D

>  	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
>  		options+=("$SCRATCH_LOGDEV")
> -	$XFS_ADMIN_PROG "$@" "${options[@]}"
> +	if [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ]; then
> +		$XFS_ADMIN_PROG --help 2>&1 | grep -q 'rtdev' || \
> +			_notrun 'xfs_admin does not support rt devices'
> +		rt_opts+=(-r "$SCRATCH_RTDEV")
> +	fi
> +	$XFS_ADMIN_PROG "${rt_opts[@]}" "$@" "${options[@]}"
>  }
>  
>  _scratch_xfs_logprint()
> 
