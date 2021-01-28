Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED78C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5584D64DD6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhA1Jw7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbhA1Jwd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:52:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C2EC061574
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dYG2QPeWc+UxJuKs1luElEVEqBcMRvrSwJ7MYVoMb8o=; b=ZkgSmmzEacF3OxnEgJnDASwuiY
        wbuu5W5273ykfEhrZYDpFkG1HrZ6O4yp6bhDApl+JyceKI/jkls9k7bLOjeO43+gn6JFzJLQZvGjb
        NJUlRZjb3g4zcQNNeYvpg7pHpyRsT4vLpjoJDHgrg3F0dt8nfdPc1rlj+LT3Aajboo8m8ZoFAH4Hh
        e5Vn6W2nuigHBcEAU/YXJ+iKTsHuL8x+wqlGiGImJxTqU7T2GmxeL8NVoBHOWEnLJI1e/f6jC4FHO
        kkWYBIrzOUJI/GlizzDJjlJfz+e1H7ZYfIFRWN6DWgpdw9K61vMMArJLjwtM+SYsuf+6BVoGPWuXl
        HVQCM53g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l53xr-008Htl-U4; Thu, 28 Jan 2021 09:51:48 +0000
Date:   Thu, 28 Jan 2021 09:51:47 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 08/13] xfs: allow reservation of rtblocks with
 xfs_trans_alloc_inode
Message-ID: <20210128095147.GD1973802@infradead.org>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181370983.1523592.13034713028988213055.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181370983.1523592.13034713028988213055.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:01:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make it so that we can reserve rt blocks with the xfs_trans_alloc_inode
> wrapper function, then convert a few more callsites.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
