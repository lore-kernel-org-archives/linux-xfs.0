Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C163C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 19:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbjKJTnS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 14:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346539AbjKJTnD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 14:43:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061D48683
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 11:40:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98408C433CA;
        Fri, 10 Nov 2023 19:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699645222;
        bh=3s3L2VGBspPZwwO1YCNa0F30ZjWpx6Yl/CJJvj2L9d0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iDj4OY1eC/iW8kbZGRllSroabQGmzMO9qI3dwvWhxXxBPfIx0gXJatA593ffQcNYL
         zbgjjGRZ1/rMg27rYWzDVwMDKdVQ/MU2+aRn5rczr+KP7mtMFiHJztV4ACxxjq8tYQ
         9cyNWnjYfr3kT7ILsEt79G3dugel3EeGWFB+HmcJdJszzCasnWajDV0FS6p5a2dEte
         HD1mIFkPOmqO7KhV0DrDsZmDG2y/5WJDpqaN+OCbBzt1+71huDjG8bLvPriAb9Iuth
         tGAFGGQ/yKlRsxfolcbrljceuddzCKmHrBJkxuNOkXT1imjc8UW8vGcg9EtYMDffM6
         SDnHiO3EZZbog==
Date:   Fri, 10 Nov 2023 11:40:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: notify user when cache flush starts
Message-ID: <20231110194022.GM1205143@frogsfrogsfrogs>
References: <3ca21cbc-fbe2-4c43-b8af-50bc7467b9cd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ca21cbc-fbe2-4c43-b8af-50bc7467b9cd@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2023 at 12:22:30PM -0600, Eric Sandeen wrote:
> We recently had the opportunity to run xfs_repair on a system
> with 2T of memory and over a billion inodes. After phase 7
> had completed, xfs_repair appeared to have hung for over an
> hour as the massive cache was written back.
> 
> In the long run it might be nice to see if we can add progress
> reporting to the cache flush if it's sufficiently large, but
> for now at least let the user know what's going on.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index ff29bea9..5597b9ba 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1388,6 +1388,7 @@
>  	 * verifiers are run (where we discover the max metadata LSN), reformat
>  	 * the log if necessary and unmount.
>  	 */
> +	do_log(_("Flushing cache...\n"));

Does this new message affect the golden output of any fstests?

Also, while this /does/ flush the libxfs b(uffer)cache, I worry that
the phrasing will lead people into thinking that *disk* caches are being
flushed.  That doesn't happen until libxfs_close_devices.  I suggest:

"Writing dirty buffers..." ?

--D

>  	libxfs_bcache_flush();
>  	format_log_max_lsn(mp);
> 
> 
