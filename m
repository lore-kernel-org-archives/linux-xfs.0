Return-Path: <SRS0=aFxQ=X2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB91ECDFB6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 06:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F31842133F
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 06:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GA6x6xFZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfJAGgf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Oct 2019 02:36:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39050 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbfJAGgf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Oct 2019 02:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6dYEgZI/V+gQqQAHBMBmmAxghvx0M09exrZW5rkgHls=; b=GA6x6xFZKltL59bQlwJRjIhlv
        ZFMLX0MSyFR+DOPjXDv/NbTedg31u88gdvtW8isS+A6WLDJj9rX8doQ+CcAZolgn3kdJEktCxWwFQ
        u8SY3gbFaE3C27cxiGX2EKqicOt0utynjhE2d38S/Rwzb03kNsyBZY2xj1qwOvVkAzOHnzICUDJUH
        qqBiV11tC9R0meyNOHuT8NPzaI6371G1sPRXawAllx1yLxINudODG/56LJ1D4FueKhTyvdXBJ5VZB
        2eV6Ly26++DTSkeQJeDv1ECcbVyTF6GJ5uUQq7mBqpOYfjSJL2yR70BPViMgx8cBH8W6HMgzf+z8d
        8OPMOL6LA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iFBly-0002gV-L4; Tue, 01 Oct 2019 06:36:34 +0000
Date:   Mon, 30 Sep 2019 23:36:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 01/11] xfs: track active state of allocation btree
 cursors
Message-ID: <20191001063634.GA4990@infradead.org>
References: <20190927171802.45582-1-bfoster@redhat.com>
 <20190927171802.45582-2-bfoster@redhat.com>
 <20190930081138.GA2999@infradead.org>
 <20190930121701.GA57295@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930121701.GA57295@bfoster>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 30, 2019 at 08:17:01AM -0400, Brian Foster wrote:
> The active flag was in the allocation cursor originally and was moved to
> the private portion of the btree cursor simply because IIRC that's where
> you suggested to put it.

My memory starts fading, but IIRC you had a separate containing
structure and I asked to move it into xfs_btree_cur itself.

> FWIW, that seems like the appropriate place to
> me because 1.) as of right now I don't have any other use case in mind
> outside of allocbt cursors 2.) flag state is similarly managed in the
> allocation btree helpers and 3.) the flag is not necessarily used as a
> generic btree cursor state (it is more accurately a superset of the
> generic btree state where the allocation algorithm can also make higher
> level changes). The latter bit is why it was originally put in the
> allocation tracking structure, FWIW.

Ok, sounds fine with me for now.  I just feels like doing it in the
generic code would actually be simpler than updating all the wrappers.
