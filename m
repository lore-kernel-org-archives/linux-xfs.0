Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F9FC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C3C061A12
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbhCXStL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237391AbhCXSsh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:48:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DF8A61A12;
        Wed, 24 Mar 2021 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616611717;
        bh=PlFbIe5dTJty9NLZOt7tGWpV/U6xUD+9j6gX9cuoU9k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sy67eVt3J4RmyowOnSWDVgfwg8l9wI/pxBvrzWeneJNvE8c5Iq1CysaWnSwyvJWIp
         hbuobeYu1ZcIqZEEtywyLXjmuf8yF14qKlPpRCmRGS3MI+5WJ0ERZyn7oU30tUmfiY
         ZN+WX6QKVLg53rBzVfHU1SNCqeM0UNd7UL7SyUBfOTet9xyD8NiS8tsQKLhYNpH++j
         hwaoqedbVfWwbLkMTti00p1SaE7xtFH4icIGEpLGKPhBlpupyDw7+273dtEs/h/HwS
         nJbrQTGVHA/znzf/tau0I3t9kZmjKRT/GSM6FZxbuhukX2kEwgagfgwPgIFvSpyAur
         ftsnisd5ZgpnQ==
Date:   Wed, 24 Mar 2021 11:48:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     lukas@herbolt.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs-docs question
Message-ID: <20210324184835.GU22100@magnolia>
References: <481e3f11dda1f44efe5c93c24a3a70d9@herbolt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <481e3f11dda1f44efe5c93c24a3a70d9@herbolt.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 09:34:58AM +0100, lukas@herbolt.com wrote:
> Hi,
> I came across chapter in XFS documentation "12.4.1 xfs_db AGI Example"
> quoting bellow:
> ---
> recs[1-85] = [startino,freecount,free]1:[96,0,0] 2:[160,0,0] 3:[224,0,0]
> 4:[288,0,0]
>                                       5:[352,0,0] 6:[416,0,0] 7:[480,0,0]
> 8:[544,0,0]
>                                       9:[608,0,0] 10:[672,0,0] 11:[736,0,0]
> 12:[800,0,0]
>                                       ...
>                                       85:[5792,9,0xff80000000000000]
> 
> Most of the inode chunks on this filesystem are totally full, since the free
> value is zero.
> This means that we ought to expect inode 160 to be linked somewhere in the
> directory structure.
> However, notice that 0xff80000000000000 in record 85 — this means that we
> would expect inode 5856
> to be free. Moving on to the free inode B+tree, we see that this is indeed
> the case:
> ---
> 
> As there are 9 inodes free in the last chunk of 64 inodes it gives me first
> free inode 5847 (5792+55),
> on the other hand inode 5856 is also free as it's last inode in the chunk.
> 
> My question is do I understand correctly that the first free inode in that
> AG is 5847?

Oops, yes, you are correct.  The first free inode is 5847, not 5856 as
stated in 12.4.1.

> Thanks, bellow possible patch.

It looks reasonable, but the patch needs to have a Signed-off-by tag
with your name and email (per kernel patch submission rules[1]) before
I can proceed with review.

[1] https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin

> ---
> diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> index 992615d..cdc8545 100644
> --- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> +++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> @@ -1099,7 +1099,7 @@ recs[1-85] = [startino,freecount,free]
>  Most of the inode chunks on this filesystem are totally full, since the
> +free+
>  value is zero.  This means that we ought to expect inode 160 to be linked
>  somewhere in the directory structure.  However, notice that
> 0xff80000000000000

This patch seems to have been line wrapped.  Would you mind resending it
with the DCO tag I mentioned above, and without wrapping?  Or as a text
attachment if that's the only option?

--D

> -in record 85 -- this means that we would expect inode 5856 to be free.
>  Moving
> +in record 85 -- this means that we would expect inode 5847 to be free.
>  Moving
>  on to the free inode B+tree, we see that this is indeed the case:
> ---
> 
> -- 
> Lukas Herbolt
