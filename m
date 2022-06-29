Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3595C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 20:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiF2U0i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 16:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiF2U0h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 16:26:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F2A39BAF
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 13:26:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81970616B2
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 20:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D860CC341C8;
        Wed, 29 Jun 2022 20:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656534395;
        bh=k/WumRjeWkuppyxnKZBbZg+7PdqyLiE7IG2hUEB/ilk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MpA1BskJn5s4MBiNWUFY/HwcYEoIEtpVWUEyGqj3GtptwRaxfnMm73QKsU7AQfIWg
         GQEdtquxEOtJAc0M+M9e9hUYKehA6Bj5QfTdyC4XXMw6zT8lbO9c8fcnqoVPf24aYg
         pxVIPeEaaT46k0HfH6VbFvd4ffUsYyaL9F6xUbTybmEZ2akyq6HdUVKl4UPuAWG0Dv
         5jAUw9Ul1vDhOw4fySgAlqoHKj1/7KfcF2Rq1AwlDAOruH8r13vtBFLxQ7D/dQvDnh
         1NCxMXpXiybTRucx00d9KZ4RrFSJ9WOrmqfhItbWpUDs5sjl/bK56KPbeETuNedhvP
         7yOTAMO/wtfUA==
Date:   Wed, 29 Jun 2022 13:26:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/14] xfs: perag conversions for 5.20
Message-ID: <Yry1ez1e4a11l3Yk@magnolia>
References: <20220627001832.215779-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627001832.215779-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 10:18:18AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> This is the set of per-ag conversions that I'm proposing for the
> 5.20 cycle. It is the initial subset of changes that were listed in
> the larger "upcoming perag changes for shrink" patchset here:
> 
> https://lore.kernel.org/linux-xfs/20220611012659.3418072-1-david@fromorbit.com/
> 
> This series drives the perag down into the AGI, AGF and AGFL access
> routines and unifies the perag structure initialisation with the
> high level AG header read functions. This largely replaces the
> xfs_mount/agno pair that is passed to all these functions with a
> perag, and in most places we already have a perag ready to pass in.
> There are a few places where perags need to be grabbed before
> reading the AG header buffers - some of these will need to be driven
> to higher layers to ensure we can run operations on AGs without
> getting stuck part way through waiting on a perag reference.
> 
> The latter section of this patchset moves some of the AG geometry
> information from the xfs_mount to the xfs_perag, and starts
> converting code that requires geometry validation to use a perag
> instead of a mount and having to extract the AGNO from the object
> location. This also allows us to store the AG size in the perag and
> then we can stop having to compare the agno against sb_agcount to
> determine if the AG is the last AG and so has a runt size.  This
> greatly simplifies some of the type validity checking we do and
> substantially reduces the CPU overhead of type validity checking. It
> also cuts over 1.2kB out of the binary size.
> 
> This runs through fstests cleanly - I don't expect there to be
> hidden surprises in it so I think these patches are good to go
> for the 5.20 cycle.
> 
> Comments and thoughts welcome....

The entire series LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> -Dave.
> 
> 
