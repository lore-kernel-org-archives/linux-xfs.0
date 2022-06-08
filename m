Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D9DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 09:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiFHJFM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiFHJCf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 05:02:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79D2986C4;
        Wed,  8 Jun 2022 01:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=L1AvlWFHwiBlKlQQzU0xpyS1S48Sf4mV1g7YW62sB5o=; b=c8LIJtZY/Ea9Zj7ABHzI+bMXvA
        OURxjVH1jqQKjooyu90JyWo9Lei4eHfWj74y8qzcjeGS15+HT4UyZsLxxjz7Yl1Q73yWI3sS+l4ik
        sBIbOTs2vjWkv587GvrtnDe5+9gkgDAeLXwsxlGBXINihXqcmKzGQXi5mWdvAHa418P8Ia4x2E4gB
        nu8+7+M3O7aQUiy5LHqW0BG2L704jiNW3H6eiQnf6+Hue4sZDXUBr+i4eZgEU86kQivSxLwVKkp+W
        r6ZINI+yw8BsPr7FM2C9csARaKi3DWDVSMEi/cm4BvcRh7BZIPxuIbWJXaaVzzd2yEIC92+/LIJDR
        HFBmQzvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyqt9-00Bt6z-2A; Wed, 08 Jun 2022 08:18:03 +0000
Date:   Wed, 8 Jun 2022 01:18:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 08/20] mm/migrate: Convert migrate_page() to
 migrate_folio()
Message-ID: <YqBbO+yLvK2vCnk5@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-9-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606204050.2625949-9-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 09:40:38PM +0100, Matthew Wilcox (Oracle) wrote:
> Convert all callers to pass a folio.  Most have the folio
> already available.  Switch all users from aops->migratepage to
> aops->migrate_folio.  Also turn the documentation into kerneldoc.

Reviewed-by: Christoph Hellwig <hch@lst.de>
