Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213EBC4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD7E0235FC
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:17:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WLuKzYJY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIWHRv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgIWHRv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 03:17:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1F7C061755
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 00:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0bxXwOObVN7iGMyW/iYzHFnlUspTl6yHHfiJEqbYDqQ=; b=WLuKzYJYrlrL/olHgq5q/hxJON
        mKALirCOgzke3lTo1xWSF9OWdblZDOhJFu5qfausM0DmmGRBO5bP/2Kpj26DIQGobRQ9NiV7LVlwe
        6IrTSqOCFe2QUcGR1KCOdnu5XPWJR7Ez067OvOeX+cWnXKiMPPuPNlvUXPFGf/IandABu3aVGk9mx
        VWo9a/7s73ZCn759olU+GljfeT3A7aPudWG5lxFNfaHkNt4z1t3DcQm0xwUg8pabDhHFJXHqsNqva
        PRo+WUu2T4DUeDMO3RcKW2QW9ZhDErWZjKPsrkSWNF7KBsR6qq8FE1K03I4AyX94CCfYkUR1GOZA5
        HnnPzr3g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKz2D-00087b-Dm; Wed, 23 Sep 2020 07:17:49 +0000
Date:   Wed, 23 Sep 2020 08:17:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v2 2/3] xfs: clean up xfs_bui_item_recover
 iget/trans_alloc/ilock ordering
Message-ID: <20200923071749.GB29203@infradead.org>
References: <160031336397.3624582.9639363323333392474.stgit@magnolia>
 <160031337657.3624582.4680281255744277782.stgit@magnolia>
 <20200917070802.GW7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917070802.GW7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 12:08:02AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In most places in XFS, we have a specific order in which we gather
> resources: grab the inode, allocate a transaction, then lock the inode.
> xfs_bui_item_recover doesn't do it in that order, so fix it to be more
> consistent.  This also makes the error bailout code a bit less weird.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
