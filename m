Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C776C4360C
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50AD621855
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:58:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UqwhLcA3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfI3H6z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 03:58:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43694 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfI3H6z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 03:58:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5gfMdWiII58/wkR9Ms8lC6eXfuAt0MuHhcofvORyCYE=; b=UqwhLcA3bkcmXLp/v7WdiBlQu
        PZhrJm35Y2x65wcq2xeb63M630vSOpgcUcy4pOju3oeOudKoC2pCF4ri0sr80OsBufrOOw5x5u2KA
        cEpS8TQDnG7TtZ3/SETUyloKTfvORpWHywdv85v3s5ZOLSjZqfgJmwB8FY3SM6lyidOk+lpFqjRLC
        D1pV1En7SWaqixOY9yizy/FJsO7wxCEapEz61tpc0yHNMLi0QBggwQtM5B3n+x4rpeg1uyl9/S4Cy
        VxgAGgEColwbyLHT8hgyvtvv8gsOrqsgZYE4S+iYtA1Z5XTqmTs6vtVWdgKpHqR2hXuNM+WV1vkIT
        1BnH++czA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqa6-0004Mw-1b; Mon, 30 Sep 2019 07:58:54 +0000
Date:   Mon, 30 Sep 2019 00:58:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: calculate iext tree geometry in btheight
 command
Message-ID: <20190930075854.GK27886@infradead.org>
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765991.303060.7541074919992777157.stgit@magnolia>
 <20190926214102.GK16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926214102.GK16973@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 27, 2019 at 07:41:02AM +1000, Dave Chinner wrote:
> > +static int iext_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
> > +{
> > +	blocklen -= 2 * sizeof(void *);
> > +
> > +	return blocklen / sizeof(struct xfs_bmbt_rec);
> > +}
> 
> This isn't correct for the iext nodes. They hold 16 key/ptr pairs,
> not 15.
> 
> I suspect you should be lifting the iext btree format definitions
> like this one:

Is the command supposed to deal with the on-disk or in-memory nodes?
The ones your quote are the in-memory btrees, but the file seems
(the way I read it, the documentation seems to be lacking) with the
on-disk btrees.

