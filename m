Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EC5C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 16:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CEAB64E35
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 16:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhBIQgz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:36:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232793AbhBIQgp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 11:36:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAEFE64EC5;
        Tue,  9 Feb 2021 16:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612888565;
        bh=GdrLfZk7b5XbCaLYAhFgQY/+AvE32TemwuHC6XsKC/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=msMcLGgzr/z4Wn9AOk3rpB5aZoQNzjVP7y9li2+oyVL29tT1PG7IlwZ3qluTYL4GG
         nFUfyQb1osFOo96DEwM9a/4fjiZ3W1idX/7lFwAAuOO0zHU4tWYek7Zp8Hb7ofFLzv
         4puKgwA5Qz9TM2iJjNrGKx/J3RmGB5fNEAmSsAsrezE2YZbyYJBcX0tEvIUkJEIet9
         gc8NRjDyUa0DSptV3IVNhKz6VRKpt0IyoTsG+XrFFMhDsA6Iveyp+F8HFM32ESzi6j
         Fr9JHLiaHw0hJBeCWnJvTFrYgQ6S0khMuzIHa8viiD+MoT0B82fkeeJX7S2Y4fV04N
         tmbjedWERHtlA==
Date:   Tue, 9 Feb 2021 08:36:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH] _scratch_mkfs_geom(): Filter out 'k' suffix from fs
 block size
Message-ID: <20210209163605.GD7190@magnolia>
References: <20210209161252.17901-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209161252.17901-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 09:42:52PM +0530, Chandan Babu R wrote:
> If the original value of $MKFS_OPTIONS contained a block size value having 'k'
> as a suffix (e.g. -b size=4k), then the newly constructed value of
> $MKFS_OPTIONS will have 'k' suffixed to the value of $blocksize.  $blocksize
> itself is specified in units of bytes. Hence having 'k' suffixed to this value
> will result in an incorrect block size.
> 
> This commit fixes the bug by conditionally filtering out the 'k' suffix from
> block size option present in the original value of $MKFS_OPTIONS.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  common/rc | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index 649b1cfd..0ec7fe1a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1062,7 +1062,7 @@ _scratch_mkfs_geom()
>      case $FSTYP in
>      xfs)
>  	if echo "$MKFS_OPTIONS" | egrep -q "b?size="; then
> -		MKFS_OPTIONS=$(echo "$MKFS_OPTIONS" | sed -r "s/(b?size=)[0-9]+/\1$blocksize/")
> +		MKFS_OPTIONS=$(echo "$MKFS_OPTIONS" | sed -r "s/(b?size=)[0-9]+k?/\1$blocksize/")

At first I wondered about the other suffixes but then realized that 's'
doesn't actually work, so...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	else
>  		MKFS_OPTIONS+=" -b size=$blocksize"
>  	fi
> -- 
> 2.29.2
> 
