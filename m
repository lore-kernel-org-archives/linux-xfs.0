Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F49C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 673A32065F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:39:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JCozgstx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGOSju (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGOSjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:39:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12F5C061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 11:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YR3BUSULDItZr4v9QdCxDRqrMN4S8ZzCySPQdnizbNE=; b=JCozgstxFuQnWnHj0qiPAqyAyF
        qolUTiJD0YSprJ5EWTpaTyS8F58v82d3fx/jOdCvUrLZrFE7gqcancv9mFDVYtT1GCaxo1nEKzVQ/
        iHzjEGTJuaiRq+FVwR7+LhZzmqtgtNCRkfIWua41XFJ3n6Uth34rJ0ZCXv1UAVZaI1fJ6hfYeuGlr
        Vr9McGdKSfKmpTi+OlVBCFXe1xTktmEn2Krhny/bjSQjCFnV2kayhzplP7ZOx7SbJYfeuSqA1HeSP
        Bi6sCNeRlHTHSjV+zRhs7SbrU/BZenREQsAbDwxNGrzAdTDbL8oMMuSop/VQifhgohdowFutGnaAo
        oQFDlkXQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvmJo-00064I-7V; Wed, 15 Jul 2020 18:39:48 +0000
Date:   Wed, 15 Jul 2020 19:39:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: split the incore dquot type into a separate
 field
Message-ID: <20200715183948.GA23249@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469032038.2914673.4780928031076025099.stgit@magnolia>
 <20200714075756.GB19883@infradead.org>
 <20200714180502.GB7606@magnolia>
 <20200715174340.GB11239@infradead.org>
 <20200715183838.GD3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715183838.GD3151642@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:38:38AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 15, 2020 at 06:43:40PM +0100, Christoph Hellwig wrote:
> > On Tue, Jul 14, 2020 at 11:05:02AM -0700, Darrick J. Wong wrote:
> > > On Tue, Jul 14, 2020 at 08:57:56AM +0100, Christoph Hellwig wrote:
> > > > On Mon, Jul 13, 2020 at 06:32:00PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > Create a new type (xfs_dqtype_t) to represent the type of an incore
> > > > > dquot.  Break the type field out from the dq_flags field of the incore
> > > > > dquot.
> > > > 
> > > > I don't understand why we need separate in-core vs on-disk values for
> > > > the type.  Why not something like this on top of the whole series:
> > > 
> > > I want to keep the ondisk d_type values separate from the incore q_type
> > > values because they don't describe exactly the same concepts:
> > > 
> > > First, the incore qtype has a NONE value that we can pass to the dquot
> > > core verifier when we don't actually know if this is a user, group, or
> > > project dquot.  This should never end up on disk.
> > 
> > Which we can trivially verify.  Or just get rid of NONE, which actually
> > cleans things up a fair bit (patch on top of my previous one below)
> 
> Ok, I'll get rid of that usage.
> 
> > > Second, xfs_dqtype_t is a (barely concealed) enumeration type for quota
> > > callers to tell us that they want to perform an action on behalf of
> > > user, group, or project quotas.  The incore q_flags and the ondisk
> > > d_type contain internal state that should not be exposed to quota
> > > callers.
> > 
> > I don't think that is an argument, as we do the same elsewhere.
> > 
> > > 
> > > I feel a need to reiterate that I'm about to start adding more flags to
> > > d_type (for y2038+ time support), for which it will be very important to
> > > keep d_type and q_{type,flags} separate.
> > 
> > Why?  We'll just OR the bigtime flag in before writing to disk.
> 
> Ugh, fine, I'll rework the whole series yet again, since it doesn't look
> like anyone else is going to have the time to review a 27 patch cleanup
> series.

Let's just get your series in and I'll send an incremental patch
after the bigtime series..
