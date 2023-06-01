Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4ABC77B7A
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 08:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjFAILL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 04:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjFAILL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 04:11:11 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5159F;
        Thu,  1 Jun 2023 01:11:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7D53867373; Thu,  1 Jun 2023 10:11:06 +0200 (CEST)
Date:   Thu, 1 Jun 2023 10:11:05 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] block: refactor bd_may_claim
Message-ID: <20230601081105.GA31903@lst.de>
References: <20230518042323.663189-1-hch@lst.de> <20230518042323.663189-3-hch@lst.de> <20230530114148.zobtxdurit24pqev@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530114148.zobtxdurit24pqev@quack3>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 30, 2023 at 01:41:48PM +0200, Jan Kara wrote:
> > +	if (bdev->bd_holder) {
> > +		/*
> > +		 * The same holder can always re-claim.
> > +		 */
> > +		if (bdev->bd_holder == holder)
> > +			return true;
> > +		return false;
> 
> With this simple condition I'd just do:
> 		/* The same holder can always re-claim. */
> 		return bdev->bd_holder == holder;

As of this patch this makes sense, and I did in fact did it that
way first.  But once we start checking the holder ops we need
the eplcicit conditional, so I decided to start out with this more
verbose option to avoid churn later.
