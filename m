Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD92C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 21:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJNVom (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 17:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiJNVok (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 17:44:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BA2F23
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 14:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93E2861CA5
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 21:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A81C433C1;
        Fri, 14 Oct 2022 21:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665783876;
        bh=1dTkl3osXxNtLe3XjQj69c3HlyjWV6593bA2sZQA3oU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RrdJC1GX8RtFX7ripdcO59dQDY/CpsVXwQ1qldAM4565M6FqoMD5UWdlQKZp5XlYN
         RhKFU8cnXLV0KQsznT6ogRhWCRAt4sPygW/tSpIhmqJ0xUQerPpOEQle/Cbb/fpfDo
         L4stuGlz4uEliMv1F5qj+Xaoor65REvxY8vMhlIBn3iaVJCDoLIcCOGaxS3JqdCyf7
         mR0pGa1Cq8+HZV0UxLhBdKu9NPa2dYjmmn27F26SO6DpCvF1oAd177JW56VWtidD7c
         3DPL0/NUNQQ0afcGLxnNyIYeB/g0PYvyGRov6Ukq3DSggjKlmMOfLdcz3K9n5PfauP
         h3ORQAuUKlQ4g==
Date:   Fri, 14 Oct 2022 14:44:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: don't return -EFSCORRUPTED from repair when
 resources cannot be grabbed
Message-ID: <Y0nYRDC7TWN7+uGg@magnolia>
References: <166473479505.1083393.7049311366138032768.stgit@magnolia>
 <166473479567.1083393.7668585289114718845.stgit@magnolia>
 <20221013224911.GH3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013224911.GH3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 14, 2022 at 09:49:11AM +1100, Dave Chinner wrote:
> On Sun, Oct 02, 2022 at 11:19:55AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If we tried to repair something but the repair failed with -EDEADLOCK or
> > -EAGAIN, that means that the repair function couldn't grab some resource
> 
> Nothing should fail with EAGAIN by this point?

Right.

> > it needed and wants us to try again.  If we try again (with TRY_HARDER)
> > but still can't do it, exit back to userspace, since xfs_scrub_metadata
> > requires xrep_attempt to return -EAGAIN.
> 
> -EDEADLOCK, not -EAGAIN?

That part of the message confused me too.

How about this revision?

"If we tried to repair something but the repair failed with -EDEADLOCK,
that means that the repair function couldn't grab some resource it
needed and wants us to try again.  If we try again (with TRY_HARDER) but
still can't get all the resources we need, the repair fails and errors
remain on the filesystem.

"Right now, repair returns the -EDEADLOCK to the caller, which passes it
up to userspace without copying the xfs_scrub_metadata structure back to
userspace.  This is very confusing for userspace since xfs_scrub merely
reports "Resource deadlock would occur" and gives no indication that
there are uncorrected errors on the filesystem.  Hence we want to return
0 here so that the ioctl code copies the CORRUPTION flag back to
userspace."

Clearer, I hope?

--D

> 
> Confused.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
