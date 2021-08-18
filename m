Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1828C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 02:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC98C60F11
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 02:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbhHRC4e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 22:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231449AbhHRC4e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 22:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C86260EB5;
        Wed, 18 Aug 2021 02:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629255360;
        bh=Olac6sVvAkXfTC3ENdBilfDP1Nsk7Ui6AOFWdceCt+0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jCoaybuJibx+6Oz9GG3lzlJuuXxnLDk21nQ0em6dmKkrQLm4E/gifWwztiyJMikkv
         yjEO2EYfbjBDCC/evCOqO5J4vVIYbQd+iD2bAV5F4bqzqokXQNFGaHkIXK06WK6rjZ
         /ewj/dOjLcz6gF5Pw96l1/f5IIWLuqfFDzo63K1geh+Aygw5J+RHL66mq1cict/hLQ
         D0MSgQeQTYYES9gyTlAIL5fNpmkRoyrUpuU5kRVoIC8IcBy4n4Y0CPHzQdQAcX54Q4
         NORFAv6BGp9A7rKNtUUs8pZT7faY+r69MbbXnq01G4fA1lxgAA9FCBIXInrAKqjyAg
         I1ANzLaIVyScg==
Date:   Tue, 17 Aug 2021 19:56:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/16] xfs: rename xfs_has_attr()
Message-ID: <20210818025600.GG12640@magnolia>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-3-david@fromorbit.com>
 <YRTV1pa3dQaKLwBi@infradead.org>
 <20210818005608.GM3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818005608.GM3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 18, 2021 at 10:56:08AM +1000, Dave Chinner wrote:
> On Thu, Aug 12, 2021 at 09:03:34AM +0100, Christoph Hellwig wrote:
> > On Tue, Aug 10, 2021 at 03:24:37PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > xfs_has_attr() is poorly named. It has global scope as it is defined
> > > in a header file, but it has no namespace scope that tells us what
> > > it is checking has attributes. It's not even clear what "has_attr"
> > > means, because what it is actually doing is an attribute fork lookup
> > > to see if the attribute exists.
> > > 
> > > Upcoming patches use this "xfs_has_<foo>" namespace for global
> > > filesystem features, which conflicts with this function.
> > > 
> > > Rename xfs_has_attr() to xfs_attr_lookup() and make it a static
> > > function, freeing up the "xfs_has_" namespace for global scope
> > > usage.
> > 
> > Why not kill this function entirely as I suggested last time?
> 
> Because I think it's the wrong cleanup to apply to xfs_attr_set().
> xfs_attr_set() needs to be split into two - a set() function and a
> remove() function to get rid of all the conditional "if
> (arg->value)" logic in it that separates set from remove. Most
> of the code in the function is under such if/else clauses, and the
> set() code is much more complex than the remove() case. Folding the
> attr lookup into the xfs_attr_set() doesn't do anything to address
> this high level badness, and to split it appropriately we need to
> keep the common attr lookup code in it's own function.
> 
> I updated the patch to has a single xfs_attr_lookup() call instead
> of one per branch, but I don't think removing the helper is the
> right way to go here...

I prefer we leave the xattr code alone (renaming things to avoid name
conflicts is ok) and concentrated on helping Allison land xattr logging.
Once that's done, xfs_attr_set and xfs_attr_remove become trivial
frontends to a deferred operation.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
