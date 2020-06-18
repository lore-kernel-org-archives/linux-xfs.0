Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC60C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78F50206F7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qiNoE2iI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgFRPP1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgFRPP0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 11:15:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC1EC06174E;
        Thu, 18 Jun 2020 08:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n8qAE/9OJYUwhkI+Do5ZBeUDfEICMR5Rjwmh0CJKCEA=; b=qiNoE2iIfqYP4rmNZpU13B0y9D
        ID5Ch0yfDNkuKTSbH6hzAPr/x/jilvymIiAI4bMGuyW5MGHE6WVZMwrnWoi2iDyusOCY1qY4sk9MW
        Rd09iBOzQbHIQRZrJVWPkLtuc4fV3Hvx2G4kY9Jykaz9Y6qxvI8nKpmc6zaIrdvKj4MTNQF3iJsWg
        VpjS0cqNxgiF/FFGJYOLsLKI666E/Ky1kFjiaa2lm4Z9galoPyzwyvXZTX1WFMC4IfZ+Z/WJ2LJUO
        aeOHcuooba4gL6p430vN8hSi8pD6JU7e71XQ+zV52elZOi8cKnc5Qk+837T4G9K3He2ZAWYpARo3C
        wytD2d1A==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jlwGB-0004VM-R6; Thu, 18 Jun 2020 15:15:23 +0000
Date:   Thu, 18 Jun 2020 08:15:23 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bob Peterson <rpeterso@redhat.com>
Subject: Re: [PATCH] iomap: Make sure iomap_end is called after iomap_begin
Message-ID: <20200618151523.GQ8681@bombadil.infradead.org>
References: <20200615160244.741244-1-agruenba@redhat.com>
 <20200618013901.GR11245@magnolia>
 <20200618123227.GO8681@bombadil.infradead.org>
 <CAHc6FU5x8+54zX5NWEDdsf5HV5qXLnjS1SM+oYmX1yMrh_mDfA@mail.gmail.com>
 <20200618135639.GA15658@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618135639.GA15658@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 06:56:39AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 18, 2020 at 02:37:37PM +0200, Andreas Gruenbacher wrote:
> > On Thu, Jun 18, 2020 at 2:32 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > On Wed, Jun 17, 2020 at 06:39:01PM -0700, Darrick J. Wong wrote:
> > > > > -   if (WARN_ON(iomap.offset > pos))
> > > > > -           return -EIO;
> > > > > -   if (WARN_ON(iomap.length == 0))
> > > > > -           return -EIO;
> > > > > +   if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0)) {
> > > >
> > > > Why combine these WARN_ON?  Before, you could distinguish between your
> > > > iomap_begin method returning zero length vs. bad offset.
> > >
> > > Does it matter?  They're both the same problem -- the filesystem has
> > > returned an invalid iomap.  I'd go further and combine the two:
> > >
> > >         if (WARN_ON(iomap.offset > pos || iomap.length == 0)) {
> > >
> > > that'll save a few bytes of .text
> > 
> > That would be fine by me as well. Christoph may have wanted separate
> > warnings for a particular reason though.
> 
> Yes.  The line number in the WARN_ON will tell you which condition
> you if they are separate, which is really useful to diagnose what is
> going on.

Thinking about it, wouldn't the second test be better replaced with:

	if (WARN_ON(iomap.offset + iomap.length <= pos))

in case the filesystem returns an extent which finishes before pos?
This would be a superset of the test for length being 0.
