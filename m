Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C582C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 16:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D47E6103E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 16:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhHLQYr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 12:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhHLQYr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 12:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E15460C40;
        Thu, 12 Aug 2021 16:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628785462;
        bh=ziJdWLY7JBRB2cFTQgfmW52rdriYu899vnnxzsGHvEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nxztz2ci00dgxDrV3RkJga/jfFQ33gCNrSgAuYnICbOx8cn/hsedCWeS9ihqMZP4r
         anLnf1q3gKz/A/DRaWAyjO/4xXXZaAnRbOItQaZQqQtiGRQPOJB5i1yBias4sHswa+
         PX7B7M/tayd9iXwi1Cc0CNLbN9Il0rPWqF8JMHyCiLZW44EgvnftT3WdVOIy/Z09cO
         oak1UQ7ibqB+QlStHBB9F92rVwUMaHc5gYXDsWpGoIYT8TS8RHd5t4csdsJ1QJIzwH
         v2wEXQXm9NkScV9kaeEsZ0qmGNwvTI5XAzdqvorTY/3EnM3OOF0TXQ9iIO18airwPe
         NRx74ETSqUbUg==
Date:   Thu, 12 Aug 2021 09:24:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix off-by-one error when the last rt extent is
 in use
Message-ID: <20210812162421.GO3601443@magnolia>
References: <162872991654.1220643.136984377220187940.stgit@magnolia>
 <162872992772.1220643.10308054638747493338.stgit@magnolia>
 <YRTdpEM4/pjeODwG@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRTdpEM4/pjeODwG@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 09:36:52AM +0100, Christoph Hellwig wrote:
> On Wed, Aug 11, 2021 at 05:58:47PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The fsmap implementation for realtime devices uses the gap between
> > info->next_daddr and a free rtextent reported by xfs_rtalloc_query_range
> > to feed userspace fsmap records with an "unknown" owner.  We use this
> > trick to report to userspace when the last rtextent in the filesystem is
> > in use by synthesizing a null rmap record starting at the next block
> > after the query range.
> > 
> > Unfortunately, there's a minor accounting bug in the way that we
> > construct the null rmap record.  Originally, ahigh.ar_startext contains
> > the last rtextent for which the user wants records.  It's entirely
> > possible that number is beyond the end of the rt volume, so the location
> > synthesized rmap record /must/ be constrained to the minimum of the high
> > key and the number of extents in the rt volume.
> 
> Looks good, although the change is a little hard to follow due to the
> big amount of cleanups vs the tiny actual bug fix.

I'll clean that up a bit before I commit this to the -merge branch.

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
