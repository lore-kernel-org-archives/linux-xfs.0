Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCDFC77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 19:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243881AbjD0TBS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 15:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244173AbjD0TBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 15:01:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F324421E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 12:01:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ABB563EB3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E49C433EF;
        Thu, 27 Apr 2023 19:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682622076;
        bh=nguMZqmcGxuGen1DaLq8o6SwTmuTrP4Qa7P/5Nd0SOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aWn88rm7Jnv2FbutABriwCto9TeCU5JCb/9RHhUQqA75Jp/KsWNR/CMT0GfVm86PF
         LR9eowRZVsGKOx6Fw4aVXXXs5NbBJTeGIceZICg0Hxj40hRcu2WYkV4sMMszQb0jjU
         RSRwo5VncvQWteAgI0LTxQLfJbNrQkOtuWOlXo+JzjClTsxF9VgME6It0qUgMbooUL
         GiGo8tQ8TUzmZwjLwqBpXmlJGK2Xn4BxfKGVYcCZl2rd+wYknu4rCUY40vlO/jnQ8Z
         zf1wzO+VE6jpkG+gNh3bosyrQQrPfNYmHOkDR0NkLv4svgFQ93HZtO9Al+hSo7C8g5
         tPGwjyH+7s2iQ==
Date:   Thu, 27 Apr 2023 12:01:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: drop EXPERIMENTAL tag for large extent counts
Message-ID: <20230427190115.GB59213@frogsfrogsfrogs>
References: <20230420151000.GH360889@frogsfrogsfrogs>
 <20230420232426.GA3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420232426.GA3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 09:24:26AM +1000, Dave Chinner wrote:
> On Thu, Apr 20, 2023 at 08:10:00AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This feature has been baking in upstream for ~10mo with no bug reports.
> > It seems to work fine here, let's get rid of the scary warnings?
> 
> Are you proposing this for the 6.4 cycle (next weeks merge window)
> or for the cycle after this?  I don't see an issue with removing the
> experimental tag, but I do think it's a bit late for this cycle....

Doh, I totally forgot to reply to this.  I /was/ actually targetting
6.4, but I don't have any particular problem if this slips to 6.5.

--D

> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_super.c |    4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 4d2e87462ac4..dc13ff4ea25e 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1683,10 +1683,6 @@ xfs_fs_fill_super(
> >  		goto out_filestream_unmount;
> >  	}
> >  
> > -	if (xfs_has_large_extent_counts(mp))
> > -		xfs_warn(mp,
> > -	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
> > -
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
