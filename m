Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6868C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 18:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjKHSVH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 13:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjKHSVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 13:21:07 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD211FF5
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 10:21:04 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 920C168AA6; Wed,  8 Nov 2023 19:21:01 +0100 (CET)
Date:   Wed, 8 Nov 2023 19:21:01 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] repair: fix process_rt_rec_dups
Message-ID: <20231108182101.GA17121@lst.de>
References: <20231108175320.500847-1-hch@lst.de> <20231108180827.GW1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108180827.GW1205143@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 10:08:27AM -0800, Darrick J. Wong wrote:
> On Wed, Nov 08, 2023 at 06:53:20PM +0100, Christoph Hellwig wrote:
> > search_rt_dup_extent takes a xfs_rtblock_t, not an RT extent number.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> > 
> > What scares me about this is that no test seems to hit this and report
> > false duplicates.  I'll need to see if I can come up with an
> > artifical reproducers of some kind.
> 
> I think you've misread the code -- phase 4 builds the rt_dup tree by
> walks all the rtextents, and adding the duplicates:

Hmm.

So yes, add_rt_dup_extent seems to be called on an actual rtext, but
scan_bmapbt calls search_rt_dup_extent with what is clearly
a fsbno_t.   So something is fishy here for sure..

> So I think the reason why you've never seen false duplicates is that the
> rt_dup tree intervals measure rt extents, not rt blocks.  The units
> conversion in process_rt_rec_dups is correct.

Note that I don't see error with the patch either, so either way the
coverage isn't good enough..

