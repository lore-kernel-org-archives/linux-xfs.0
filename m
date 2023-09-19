Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B89CD342E
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Sep 2023 03:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjISD1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 23:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjISD1T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2023 23:27:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019D010F
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 20:27:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCDAC433C7;
        Tue, 19 Sep 2023 03:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695094033;
        bh=eCodThKduEvq7tx8zbwc3z9b3B1F0+PgRKN99KUEh5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lv5lm32brZuSn+LBqCYaBDMPy9zIkybHV7vhEhiboWDXRzXBGfVNfA4o55LjpAudh
         fo1HIFHG08ZEOW76sdgN0S2TV5ztP47bBpeQd0A9XxZ6s4w5aPAdQMwUlo9WQVsUTW
         Ry5X5Dp60uO+Ky/yP9N81IWxEYjn9kFtdAkGBGZCCqM5SjnujI9YjTK+Kr5W9Cm1Q2
         Disx4MA/QNUs6jRHGYtKQn7wySXojmiPC1fTnh3r3NLNnKJAz6wFP7tj17Q8+pPFAJ
         J8foD89dpVyG4he+x1wUGWlXIerulz278jQcAxtbrFFB8VLTG8fFpjyIizc3sJWknz
         8x53V4NM0g7gQ==
Date:   Mon, 18 Sep 2023 20:27:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: Update agsize description in the man page
Message-ID: <20230919032713.GD348018@frogsfrogsfrogs>
References: <20230918142604.390357-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918142604.390357-1-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2023 at 04:26:04PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> agsize value accept different suffixes, including filesystem blocks, so,
> replace "expressed in bytes" by "expressed as a multiple of filesystem
> blocks".
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  man/man8/mkfs.xfs.8.in | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index 08bb92f65..96c07fc71 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -352,12 +352,11 @@ This is an alternative to using the
>  .B agcount
>  suboption. The
>  .I value
> -is the desired size of the allocation group expressed in bytes
> -(usually using the
> +is the desired size of the allocation group expressed as a multiple of the
> +filesystem block size (usually using the
>  .BR m " or " g
>  suffixes).
> -This value must be a multiple of the filesystem block size, and
> -must be at least 16MiB, and no more than 1TiB, and may
> +It must be at least 16MiB, and no more than 1TiB, and may
>  be automatically adjusted to properly align with the stripe geometry.
>  The
>  .B agcount
> -- 
> 2.39.2
> 
