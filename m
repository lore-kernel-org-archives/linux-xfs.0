Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DC1C46CA1
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Sep 2023 07:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbjIRHrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 03:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240540AbjIRHrS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2023 03:47:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22018E50
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 00:45:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFD3C433CC;
        Mon, 18 Sep 2023 07:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695023150;
        bh=NGGk6RPf7XNGTfpEfbR18KDxnr0Q7rQ4pV8bXiAR6gU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JPHFF/nJsnEb1O9nBywAnrDtCgvSp5TE8pOwYYk9Zkp0r5DGkNECcmHBRch5uJwWS
         YAyQ7CKDCmujFEn821kxhFgz5JRvdyFW1Dm6l8Ho7ru8ytppgmOUhR2eCN37Hjw15K
         TPE8ZyxKQL0ZqwU7pSMAhkdLc5MXUjw6dx7b6JV0LXeIBIsXYHqhLxeBAenh4W68Z+
         leYOLsOMMaDr6ekRP6NlJ3G/07qjdqDjsN0xkh9R+hHHn/HmikWKLNOQChvqm+u6ho
         6Kb4GBoyLI2zprsbNP3IfBgqqc81u2OkaHe49lJcBgEIqjhII/hVIgojMtlJPgrotR
         6u/c13f/pWKFw==
Date:   Mon, 18 Sep 2023 09:45:46 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] mkfs: Improve warning when AG size is a multiple of
 stripe width
Message-ID: <20230918074546.azrdygv573zwft6h@andromeda>
References: <20230915102246.108709-1-cem@kernel.org>
 <mtbSIYoGwjT2MYWwM01Zl5LxyDKWgnnoTe4CzvkGa62mRSUoXEc2A3WNEzKAyPYkh0RZ-lFhMinqEmO9uaz4rg==@protonmail.internalid>
 <ZQeDQW7a7eBt3vGp@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQeDQW7a7eBt3vGp@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2023 at 08:52:49AM +1000, Dave Chinner wrote:
> On Fri, Sep 15, 2023 at 12:22:46PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cmaiolino@redhat.com>
> >
> > The current output message prints out a suggestion of an AG size to be
> > used in lieu of the user-defined one.
> > The problem is this suggestion is printed in filesystem blocks, without
> > specifying the suffix to be used.
> >
> > This patch tries to make user's life easier by outputing the option as
> > it should be used by the mkfs, so users can just copy/paste it.
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> I'm fine with this but, as I said in my previous comment, a man page
> update for agsize is also needed. Something like this:

Thanks, yes I am planning for the manpage update, I just wanted to send the
message fix first before going into the discussion of the manpage, I'll try to
prepare a patch for it today.

> 
> 	agsize=value
> 		This is an alternative to using the agcount
> 		suboption. The value is the desired size of the
> -		allocation group expressed in bytes (usually using
> -		the m or g suffixes).  This value must be a multiple
> -		of the filesystem block size, and must be at  least
> +		allocation group expressed as a multiple of the
> +		filesystem block size.  It must be at  least
> 		16MiB, and no more than 1TiB, and may be
> 		automatically adjusted to properly align with the
> 		stripe geometry.  The agcount and agsize suboptions
> 		are mutually exclusive.

Thanks for the suggestion.

Carlos

> 
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
