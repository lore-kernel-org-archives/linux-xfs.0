Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284C6C25B6F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 16:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343829AbjJXQZn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 12:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343850AbjJXQZm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 12:25:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F02118
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 09:25:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78387C433C8;
        Tue, 24 Oct 2023 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698164739;
        bh=NK2Gl1/Y+7I4bxvao1w4hDW6pbEbGgTFz9UWw6icm1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t3mZT77pQPqXF8PhcFr2mohfAnRySp9EoMWSbY4ob7Y+PJXOirEsX76LOjcTBCJtR
         ERDWPW539AXL8AymmAsKZlbyylXpMPS94yL7+TEpGH2vhkmCxlgvJibefO3W6zxLsh
         JglMXkhprZaqDQ6S4eX24qOXEUvFinyJLkorEdEhayzSxV3FdgoyBsFIK790yEI6oc
         sLwwKu7Byn7v7/5+XzC9CqPerbMwS6vrAZ6J2xdsuxbbNVq2d4BbPNhf+kwgBHS7BN
         s2pnHV6wVbFMq2rXshZqbo36iCrJGZ55Wz9l22SWm0AqtEU1BgqjbSKhCY//nhcAFC
         cPXPc6ff9MV3g==
Date:   Tue, 24 Oct 2023 09:25:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        john.g.garry@oracle.com
Subject: Re: [PATCH 3/9] xfs: select the AG with the largest contiguous space
Message-ID: <20231024162538.GB3195650@frogsfrogsfrogs>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-4-david@fromorbit.com>
 <ZR6F6oFbgOgjeWuT@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR6F6oFbgOgjeWuT@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 05, 2023 at 02:46:18AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 04, 2023 at 11:19:37AM +1100, Dave Chinner wrote:
> > +	if (max_blen > *blen) {
> > +		if (max_blen_agno != startag) {
> > +			ap->blkno = XFS_AGB_TO_FSB(mp, max_blen_agno, 0);
> > +			ap->aeof = false;
> > +		}
> > +		*blen = max_blen;
> > +	}
> 
> A comment explaining that we at least want the longest freespace
> if no perfect match is available here would be useful to future
> readers.

With Christoph's request for an extra comment added,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
