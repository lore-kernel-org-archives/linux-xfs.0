Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8842C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBDA661A1C
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbhCXRc1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236580AbhCXRcQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 13:32:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B04CC619DC;
        Wed, 24 Mar 2021 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616607135;
        bh=spiRFMrNpYMGjabHtyRjDieA0cgJjJyQmGc06zWsgS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mrGc8wR1tPs+j1CLqr8IOL6sHeYi6PD6NPSdYj+KcDi/7AJ/WPwKRvW9sz5bRATJd
         NJTh/KfNeiAp01VESFMeZMK4n7yY8hYUHJqYeURjpGea8lW1mKMYKnvRuBzP+9PSMx
         u5AlognC0nBNo8+g4MpjFbbU6Ap+NxezQdcVvV1zmZrJMbuyuV87UROm1Rbab+ze5z
         U+f1mYgkjNnwmYVj2/I75HPghgOQR0josxvetDrRuvxaF5dj+kRKdEJL/UeTf6oZ1Q
         Ixo2m97rQc2Hvee1qxoskK4hTsmedkmFeyp1/wqfkTF3+lEb2p08WycglO6/IjEPRs
         tkSgqKr1MSqyA==
Date:   Wed, 24 Mar 2021 10:32:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [WIP] [RFC PATCH] xfs_growfs: allow shrinking unused space in
 the last AG
Message-ID: <20210324173215.GU22100@magnolia>
References: <20201028114010.545331-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028114010.545331-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 07:40:10PM +0800, Gao Xiang wrote:
> This allows shrinking operation can pass into kernel.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> preliminary version.

...which is going to need a manpage update:

"-d | -D size

"Specifies that the data section of the filesystem should be resized. If
the -D size option is given, the data section is changed to that size,
otherwise the data section is grown to the largest size possible with
the -d option. The size is expressed in filesystem blocks.  A filesystem
with only 1 AG cannot be shrunk further, and a filesystem cannot be
shrunk to the point where it would only have 1 AG."

--D

> 
>  growfs/xfs_growfs.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index a68b515d..d45ba703 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -246,12 +246,11 @@ main(int argc, char **argv)
>  			error = 1;
>  		}
>  
> -		if (!error && dsize < geo.datablocks) {
> -			fprintf(stderr, _("data size %lld too small,"
> -				" old size is %lld\n"),
> +		if (!error && dsize < geo.datablocks)
> +			fprintf(stderr,
> +_("[EXPERIMENTAL] try to shrink unused space %lld, old size is %lld\n"),
>  				(long long)dsize, (long long)geo.datablocks);
> -			error = 1;
> -		} else if (!error &&
> +		if (!error &&
>  			   dsize == geo.datablocks && maxpct == geo.imaxpct) {
>  			if (dflag)
>  				fprintf(stderr, _(
> -- 
> 2.18.1
> 
