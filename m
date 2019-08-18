Return-Path: <SRS0=cq6/=WO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D1FC3A589
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 08:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CA3220B7C
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 08:39:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uQpjyXdj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfHRIjk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Aug 2019 04:39:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59058 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfHRIjk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Aug 2019 04:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=A8d2I2K56+XviRcc09JFeUkjqbtGOWdxc/knibMVkIU=; b=uQpjyXdjSpz/Hwt2agEx42kAf
        g+mz/QcKcO6V1V4Xtq3cYXDNbU+ahexhe6g4YACs/+mbI1t36oXkGrXyP5sfu8d401R4N0lbT7mZ3
        imAzQ31GommzEmy+3D/q7XEthqyrOBZv/QZxlltY/D60997ot3RhVFCaXTqpDos9//n8D5KLAubry
        mTO/hAB+WtGqCNfdFaXxeRoIUC3/3JrLsSWAMwxYDxy0R8PHGtlvKuxwedTsclaxY7pbRm5nBkN/J
        x5vdCXJ0L5ycFl9dJ1RbbfRUB7sbiD2Mh9Q8WnyTvIQvtA/EwNYHv3+l0uiJs0B6j91pFSdNlsOuB
        tTlE+niug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hzGiv-0003cZ-6g; Sun, 18 Aug 2019 08:39:37 +0000
Date:   Sun, 18 Aug 2019 01:39:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     hch@infradead.org, akpm@linux-foundation.org, tytso@mit.edu,
        viro@zeniv.linux.org.uk, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] vfs: don't allow writes to swap files
Message-ID: <20190818083937.GC13583@infradead.org>
References: <156588514105.111054.13645634739408399209.stgit@magnolia>
 <156588515613.111054.13578448017133006248.stgit@magnolia>
 <20190816161948.GJ15186@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816161948.GJ15186@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 09:19:49AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't let userspace write to an active swap file because the kernel
> effectively has a long term lease on the storage and things could get
> seriously corrupted if we let this happen.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
