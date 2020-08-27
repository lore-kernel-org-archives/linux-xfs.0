Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABC1C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CA462177B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UVH8mafW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgH0IMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgH0IMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 04:12:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D13C061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 01:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8jLepO7pL1uvTELl7s9wgNm9cpRrRga8Z7FlxW+Ag38=; b=UVH8mafWWuecaXPtW2guyjFR05
        mfqhiZ7Gb8JxlzyRXhQHJ1f93tc3M8jJi0K2hOSOfnIOGpqKom72NcaF91lZPjOSYiSr4bQGQdhFq
        o5EvNiiHhh1VCK2XF5tV3YFG5xDF8Oxp6qn+yNi/ssWg6h5vokkLczwRFQG80I67g5Khc9aKNf+6t
        bj69hKbJ9HpK1qB6tNHg1QuP/aCXg2+/qJbOA8vwMdKzsywhN/pfQu52cf2n3tv8rHA4O6WoUylVp
        XwjrOKfIx4M5iUa3pW3X0dBcg7NjFRUucQgoNKwluKploTslyzbuOZXL5gnxoVWGx/rnO1G22uTBj
        vVNdLXyQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBD0p-0002HM-KQ; Thu, 27 Aug 2020 08:11:59 +0000
Date:   Thu, 27 Aug 2020 09:11:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix boundary test in xfs_attr_shortform_verify
Message-ID: <20200827081159.GB7605@infradead.org>
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
 <20200825224144.GS12131@dread.disaster.area>
 <2210dced-9196-b42e-9205-4b9da3832553@sandeen.net>
 <20200826151300.GM6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826151300.GM6096@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 08:13:00AM -0700, Darrick J. Wong wrote:
> > ditto for degree of commenting on magical -1's; on the one hand it's a
> > common usage.  On the other hand, we often get it wrong so a comment
> > probably would help.
> > 
> > > Did you audit the code for other occurrences of this same problem?
> 
> TBH I think this ought to be fixed by changing the declaration of
> xfs_attr_sf_entry.nameval to "uint8_t nameval[]" and using more modern
> fugly macros like struct_sizeof() to calculate the entry sizes without
> us all having to remember to subtract one from the struct size.

Agreed that we absoutely need to do that.  It might be worth to
have the "simple" fix as a backportable small patch first, though.
