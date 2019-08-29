Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641B2C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D4B523404
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pi8TFWoU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfH2Hqw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 03:46:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46484 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbfH2Hqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 03:46:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NcoMTcOZokk4JJYm8CW8Q44DC9nfYwLrfi+pxEgGbW4=; b=pi8TFWoUSOfUGrbbGwMIRYtiH
        +uamfAroMd+M2VuqOFQtOIYnYu4klH5vUwz92Cg/SQB+e4Wmrq9bmDAHMFbUH0V6S/YsvH+/F7vyV
        0OSazkMtaQXX34puGf3vWXSapb/KVeMvAwIjXNH0ZMFHuIlBNfTVCtG/psgelrV13bkb/ykpD5bNQ
        Qr1yV6YB8ZacKUQOIEDINlQbBSQfXPd0cqPRwUe98JJ7hrvx50IknUWzcOjzmAq1FYGuYtP26gu81
        JnO4/rI5s5+M+zvF4nTbOC79RRBubB9SrwHTPUzmDoFqr4Z5r1pc7zeDtdKtMOZboWOt1NYvPSrAM
        0/AqbzCvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3F8u-0000no-5g; Thu, 29 Aug 2019 07:46:52 +0000
Date:   Thu, 29 Aug 2019 00:46:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: move remote attr retrieval into
 xfs_attr3_leaf_getvalue
Message-ID: <20190829074652.GB18966@infradead.org>
References: <20190828042350.6062-1-david@fromorbit.com>
 <20190828042350.6062-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828042350.6062-3-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 28, 2019 at 02:23:49PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because we repeat exactly the same code to get the remote attribute
> value after both calls to xfs_attr3_leaf_getvalue() if it's a remote
> attr. Just do it in xfs_attr3_leaf_getvalue() so the callers don't
> have to care about it.

It also refactors xfs_attr3_leaf_getvalue to be more readable first.
Which confused the heck out of me when reading the code.  I'd prefer
that to be split into a prep patch, but on its own both changes look
good to me, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
