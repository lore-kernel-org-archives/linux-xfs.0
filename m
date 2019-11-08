Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F110C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 581FA2178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="scQakHNm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfKHHdG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:33:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55538 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfKHHdG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:33:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l7sxeY5cZCnIac1J0YgEDHruv9HSCSEVGADOcEdhJPI=; b=scQakHNmaJjT8C3yoYkHZlQBg
        sLynklp7+lrzQPYyv5LoSY9b6wFJbss5Ac0IAEe8vPiZirn3w7iyHLmyNrKKN8nE5JqEgtkWrVEwX
        HLHtFw57EI3bwL3CViNCzL+b6JAmI/+0uJ/1UpqkA/CQFDraLPIkrnARJDsO8fchZE65UJSZRzrqc
        X5wRB73owm3WlL7jm3vH0UJGO+OuCXrHlo8fHxiWPRjWQHmunGkwEEjwmnxInu8zpTwUfjffpXe8x
        S3HbKba/B1Kw4zb6WZSSaOum0gZeOlkpxT0KlA8JmIZic0LrPkOYknGkiALkeMQiVsiUCWxLdh7ih
        Jf5vfn82g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSylW-0000iF-As; Fri, 08 Nov 2019 07:33:06 +0000
Date:   Thu, 7 Nov 2019 23:33:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
Message-ID: <20191108073306.GA2539@infradead.org>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
 <157319670439.834585.6578359830660435523.stgit@magnolia>
 <20191108071441.GB31526@infradead.org>
 <20191108072951.GP6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108072951.GP6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 11:29:51PM -0800, Darrick J. Wong wrote:
> That said, "Is this cursor pointing to the last block on $level?" only
> makes sense if you've already performed a lookup (or seek) operation.
> If you've done that, you've already checked the block, right?  So I
> think we could just get rid of the _check_block call on the grounds that
> we already did that as part of the lookup (or turn it into an ASSERT),
> and then this becomes a short enough function to try to make it a four
> line static inline predicate.
> 
> Same result, but slightly better encapsulation.
> 
> (Yeah yeah, it's C, we're all one big happy family of bits...)

Sounds ok.
