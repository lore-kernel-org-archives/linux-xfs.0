Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4B5C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 04:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbiDLEsE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiDLEsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 00:48:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11D514082
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 21:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=R1uvb5lQWmu8/yp2YoKSwjpuw1ukZ6GfbtdN5TjnBks=; b=nu0K3xKrVo+ZQycn+cx5zcw+KJ
        f5hCQ1DXeVh+y2i5sQSX5CdTe0QfN18Ne36sgPzOTRPxh/P3qzAuhManYJRR+RtR2tBMWqQvZHITE
        PhF4/SurXAZmmYbSutI0IEFkxdCukWQly9ThKdV/9bVsDKu88HqxmKunJpqR3sasA8BxnPyH4rXu1
        fyhVuU+pFzJkJ2moGab5jw+QzblsbDCinKgx8oPI3VVHyXary39qfvN/7NrwNm4Ho4M+lFN3hv7aJ
        D08+bMjkgOx3+XsxfwmxbsoP+H3Tzkue8n1vuwaLcoIld/Sdt55P3CPc0Fz8npDCIr1IeUd8WtRfw
        52EZSW9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ne8PR-00Bejc-Jq; Tue, 12 Apr 2022 04:45:45 +0000
Date:   Mon, 11 Apr 2022 21:45:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use generic_file_open()
Message-ID: <YlUD+UYrmaD3ba+8@infradead.org>
References: <20220409155220.2573777-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409155220.2573777-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 09, 2022 at 04:52:20PM +0100, Matthew Wilcox (Oracle) wrote:
> Remove the open-coded check of O_LARGEFILE.  This changes the errno
> to be the same as other filesystems; it was changed generically in
> 2.6.24 but that fix skipped XFS.

Probably because XFS still was a mess with a bunch of layers then..

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
