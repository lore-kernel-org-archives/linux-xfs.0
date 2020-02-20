Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350D1C11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C6D2071E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GsRTo8qf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgBTPn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 10:43:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54454 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgBTPn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 10:43:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/advIwUjnJ9l7oZgWN1ZzLzIaqEqXfDAezW/gvUtb8s=; b=GsRTo8qfY+9F8+PdCS7Vjb5/T+
        REAWybNzkUyGNKmTcKj1FeE3wkObKZyzRSKMj4FJjSAQ0YdWukz+bh96GMvQtmrbIwRYxHZpvFSjG
        pOos7oFHILxdvpGT6moaO6TfB1kOpYz+1EyiNjQ0fRvjWt+afojcgBAROq43o8KEEIZbpmisXEZNn
        19A4NNlIHZBhN9gTq0YWwBPQ1LSMpn92haU7u5odZDRyblV4PHobg04HaGrwUHmFIbykbe2H+jZ37
        QlPN2razdePWLqfPLQQCBY7G5++qixTwl9JdTmY8bQNJOEY8puFC1gcc3kVhnJuWAbLkY54+xjqMx
        U0/c3Y1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4nyv-0003I4-OT; Thu, 20 Feb 2020 15:43:17 +0000
Date:   Thu, 20 Feb 2020 07:43:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200220154317.GB6870@infradead.org>
References: <20200218175425.20598-1-bfoster@redhat.com>
 <20200218215243.GS10776@dread.disaster.area>
 <20200219131232.GA24157@bfoster>
 <20200219215141.GP9506@magnolia>
 <20200220124144.GA48977@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220124144.GA48977@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 07:41:44AM -0500, Brian Foster wrote:
> I wasn't planning on a v3. The discussion to this point has been
> centered around the xfs_force_shutdown() call in the associated function
> (which is orthogonal to the bug). v1 is technically correct, but
> Christoph suggested to restore historical behavior wrt to the shutdown
> call. v2 does that, but is a bit superfluous in that the iclog error
> state with the lock held implies shutdown has already occurred. This is
> harmless (unless we're worried about shutdown performance or
> something..), but I think Dave indicated he preferred v1 based on that
> reasoning.
> 
> Functionally I don't think it matters either way and at this point I
> have no preference between v1 or v2. They fix the same problem. Do note
> that v2 does have the Fixed: tag I missed with v1 (as well as a R-b)...

I'm fine with v1 after all this discussion, and volunteer to clean up
all the ioerr handling for the log code after this fix goes in.

That being said as noted in one of my replies I think we also need to
add the same check in the other caller of __xlog_state_release_iclog.
