Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E08C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Dec 2021 07:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351702AbhLXHFL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241206AbhLXHFJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Dec 2021 02:05:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB33C061401
        for <linux-xfs@vger.kernel.org>; Thu, 23 Dec 2021 23:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Yx1DqXlm6p5B4WN8+OtzvA3j4R
        6/Q8dDenSvJcIAjYJbez0/L5b23l4nqioCRU5FxuaxZe6x9/dyMEAsM5/pes3USFKsxHVoU3U3WY0
        2L0Te/YMy2xGvgbU4xHEyXSAILKqtTK1FoCSkyCYkb+frszEJRqGJt8vZgf6Xdq7HKNxj4zs98iHb
        nqneNrlju1D7sTetFozzh5W9+BTo6/rrCy1EyYFoeOJ77+mZqTKUOaWA3pE/mcN94z0dWFEe0gUeS
        p8d6GbcQGqAzOBjFRjw0StifNpdGPgHyT3hC7XP/9J5eSJ2g8WNxe0JdkULnjOUhvy+DZuOlXtmjf
        Hg3ZtH0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0edX-00DpV6-RH; Fri, 24 Dec 2021 07:05:07 +0000
Date:   Thu, 23 Dec 2021 23:05:07 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 4/3] mkfs: document sample configuration file location
Message-ID: <YcVxIxAtWoNzP0mK@infradead.org>
References: <20211218001616.GB27676@magnolia>
 <20211218002305.GV27664@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211218002305.GV27664@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
