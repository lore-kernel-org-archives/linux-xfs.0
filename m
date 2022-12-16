Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23835C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Dec 2022 08:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiLPIWK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Dec 2022 03:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLPIWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Dec 2022 03:22:08 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BDD120A0;
        Fri, 16 Dec 2022 00:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lii3xy4O7bUjw9nZv4RVN82j4ze+kjU9vl2nFYJaAFc=; b=C9CREsrUs2SQFjXVVTfe2VeCVx
        E480RJdQRJTLfLCV1VRuY5SHGnCQAN58RQnZxzg6m0QRoR9EZOARCtGkCh3N9l3KOEop/eaqWPdfY
        p4e5Exp+hCKGKdU2ZugFErAfhFkI0auDQkESDlwmV1U0Ez/nqS9FHYjb+FQinWi6d5/vpCXtGQOJs
        zm17bYOw853qvvtJUcRkDfOlMcF2PNJWHMpFAOXB25gPZ8e9PlUfUrZJcdA6pCP/DsmaBP4cFMS2C
        cSdTX1s8dHdSe8jAKqxf505rU1dzYMRJ25XuVrlq+XVEBwJDj1vwX1qMkq2w8m1T6b6RwUEwT5Ziy
        p5IXwC4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p65yi-00DZou-HN; Fri, 16 Dec 2022 08:22:00 +0000
Date:   Fri, 16 Dec 2022 00:22:00 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] iomap: Move page_done callback under the folio lock
Message-ID: <Y5wqqNHf6lo9oAYd@infradead.org>
References: <Y5l9zhhyOE+RNVgO@infradead.org>
 <20221214102409.1857526-1-agruenba@redhat.com>
 <CAHc6FU7pgH+nLS_0WFx8aFBenKtNy0z6DBiyAUSdjix0t57t5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU7pgH+nLS_0WFx8aFBenKtNy0z6DBiyAUSdjix0t57t5g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 15, 2022 at 09:13:50PM +0100, Andreas Gruenbacher wrote:
> This is still screwed up. We really need to unlock the page before
> calling into __mark_inode_dirty() and ending the transaction. The
> current page_done() hook would force us to then re-lock the page just
> so that the caller can unlock it again. This just doesn't make sense,
> particularly since the page_prepare and page_done hooks only exist to
> allow gfs2 to do data journaling via iomap. I'll follow up with a more
> useful approach ...

Yes.  And it would make sense to include the gfs2 patches.
