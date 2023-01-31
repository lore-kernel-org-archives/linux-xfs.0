Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B335C636CC
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Jan 2023 19:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjAaT2O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Jan 2023 14:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjAaT2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2023 14:28:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F792CA3C
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2023 11:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5D7CB81D3E
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2023 19:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7361EC433EF;
        Tue, 31 Jan 2023 19:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675193289;
        bh=QFC5KceuPEILmVfXD8S77RXj/BHMLCliSBaCmcgZrac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDUdQRxHu3lRy4sMjZzWqn+bfCcbCfjYqFlZ9es2J57O98eSjhjg4jojZONgf/LxB
         rAd5qvnoi8OxOlzJ77TeJ2meafTI3/76OGpXsgimHGN3d0B5248mOzb8C7AdicjHuV
         zySbZPfoGgYH720qTIbKxXR+84yvm3xI7K6UU0B2n1smz3/0maxvqWgbD8KT9Pb/nK
         uhbO+lHIyrqP2cBu78nOL8mupfvvIdFprs1e5Bf+oAOeAvEYnzvc4KmV/zqXMWDO8z
         5r6JzYEJDNCFjtvh9x11qspIn8yLKC5fuEnCRWl5aMaLFylDoEUZk6/C6hq5h0DfSc
         szzVIaarYMkWg==
Date:   Tue, 31 Jan 2023 11:28:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Donald Douwsma <ddouwsma@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: allow setting full range of panic tags
Message-ID: <Y9lryDchO2EWw4Nj@magnolia>
References: <20230126052910.588098-1-ddouwsma@redhat.com>
 <Y9P7X6GnLA/iJuIa@magnolia>
 <25c4d75a-ef1a-c8a5-6c9c-0549ebd0edc2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25c4d75a-ef1a-c8a5-6c9c-0549ebd0edc2@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 30, 2023 at 04:20:00PM -0600, Eric Sandeen wrote:
> On 1/27/23 10:27 AM, Darrick J. Wong wrote:
> > On Thu, Jan 26, 2023 at 04:29:10PM +1100, Donald Douwsma wrote:
> >> xfs will not allow combining other panic masks with
> >> XFS_PTAG_VERIFIER_ERROR.
> >>
> >>  sysctl fs.xfs.panic_mask=511
> >>  sysctl: setting key "fs.xfs.panic_mask": Invalid argument
> >>  fs.xfs.panic_mask = 511
> >>
> >> Update to the maximum value that can be set to allow the full range of
> >> masks.
> >>
> >> Fixes: d519da41e2b7 ("xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask")
> 
> whoops :)
> 
> I wonder ...
> 
> >> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> 
> ...
> 
> > The ptag values are a bitmask, not a continuous integer range, so the
> > name should have "MASK" in it, e.g.
> > 
> > #define			XFS_PTAG_MASK	(XFS_PTAG_IFLUSH | \
> > 					 XFS_PTAG_LOGRES | \
> > 					...
> > 
> > and follow the customary style where the macro definition lines are
> > indented from the name.
> > 
> > Otherwise this looks fine.
> > 
> > --D
> > 
> >> +#define		XFS_MAX_PTAG ( \
> >> +			XFS_PTAG_IFLUSH | \
> >> +			XFS_PTAG_LOGRES | \
> >> +			XFS_PTAG_AILDELETE | \
> >> +			XFS_PTAG_ERROR_REPORT | \
> >> +			XFS_PTAG_SHUTDOWN_CORRUPT | \
> >> +			XFS_PTAG_SHUTDOWN_IOERROR | \
> >> +			XFS_PTAG_SHUTDOWN_LOGERROR | \
> >> +			XFS_PTAG_FSBLOCK_ZERO | \
> >> +			XFS_PTAG_VERIFIER_ERROR)
> >> +
> 
> ...
> 
> >> +	.panic_mask	= {	0,		0,		XFS_MAX_PTAG},
> >>  	.error_level	= {	0,		3,		11	},
> >>  	.syncd_timer	= {	1*100,		30*100,		7200*100},
> >>  	.stats_clear	= {	0,		0,		1	},
> 
> Do we really gain anything by carefully crafting the max bit that can be set here?
> Nothing stops someone from forgetting to update XFS_MAX_PTAG (or whatever it
> may be named) in the future,

That's true, but every other _ALL and _MASK define in the xfs codebase
also have that problem.  *Most* of the time people remember to update
it.

> and I think nothing bad happens if you try to turn
> on a PTAG that doesn't exist. Should we just set it to LONG_MAX and be done with
> it?

That would break the existing input validation:

# echo 1023 > /proc/sys/fs/xfs/panic_mask
-bash: echo: write error: Invalid argument

--D

> (I guess it's maybe nice to tell the user that they're out of range, but it is
> a debug knob after all. Just a thought, I'm ot super picky about this.)
> -Eric
