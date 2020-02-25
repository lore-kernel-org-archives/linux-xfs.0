Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB656C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E7F2082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RRS6w6xD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbgBYRvI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:51:08 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730236AbgBYRvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:51:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EffO75tm6LHgjuYvSCTRccfwUZzAJi9greSOZoAjdYA=; b=RRS6w6xDwS0qDNV4v2ZiuIIVW/
        W2t01Zuj/3dAaLKxnuV68JWVHVuTF5C+UuC1AlvjYjJZCVZxrPoQRjhxHozBPBd0vZu3gXP7+hZnF
        vFiz1JQ1OIzcPc9Sf9h4Q5j9tMyBwRs8GIuuh/Em52vFJKPws6YUB25S5K9dAOkSw8s4gv7ojghBa
        mZp3oZ/x/QRkTn5lW3CeCJyWghhZ2aO+ETtQk6fHb72KSePe4MFAnTTtTwzRVKGVUYnQixjQywLsv
        aLDJYsTA8z79+z0n5Y/hPwKJo4watTBQjjdN530MGK/ZJ9r4v+T/LMlI6LOGPzOSSiTsWHm/YGfAR
        84vZ/B8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eMN-0000wh-7v; Tue, 25 Feb 2020 17:51:07 +0000
Date:   Tue, 25 Feb 2020 09:51:07 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/25] libxfs: remove unused flags parameter to
 libxfs_buf_mark_dirty
Message-ID: <20200225175107.GR20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258960303.451378.10926259135197727277.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258960303.451378.10926259135197727277.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:13:23PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Nobody uses the flags parameter, so get rid of it.

Looks good, but wouldn't it make sense to fold this into the previous
patch instead of modifying all callers twice?

Reviewed-by: Christoph Hellwig <hch@lst.de>
