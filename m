Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA0CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 09:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiFHJFK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbiFHJCR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 05:02:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320581C4B3A;
        Wed,  8 Jun 2022 01:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QT2oIDeJNUc2ojFPGUttSkHbitBmnZ3eylc7PwUBiqw=; b=DQgbhPr3EtdPNe47+1otY6YBJ2
        glTpzusE/3PlFzZ0wogFOE34/jPjI4HFO5cnQgwwiMpFqBKOgjoXbP0RT1mVZp5o1dzq7DSdipebx
        mskJ4CjHJTxc92puWMRmsM7z6maVcYgq9KpF2GPfD5Kat/I2wduKTfHirJfv5i2KIHVA5JzPDIiI2
        lCeBxQ/yPJDj6/LduSFmHxWv1e4YF2Pj2LlDRD0cYcFb6hHpjmH59it0vinWU2nedskYtbfvk4NqO
        0o2MsEcFJ/qxp8wnZyw+NP5jNLRSGYQd3a/fAKXnbGlN6e5TJxP9CWfFegbEyAGvjblO83DMFzvRY
        7Jw3MvhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyqus-00Bu45-Rw; Wed, 08 Jun 2022 08:19:50 +0000
Date:   Wed, 8 Jun 2022 01:19:50 -0700
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
Subject: Re: [PATCH 10/20] btrfs: Convert btrfs_migratepage to migrate_folio
Message-ID: <YqBbpob9igYBSWGr@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-11-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606204050.2625949-11-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 09:40:40PM +0100, Matthew Wilcox (Oracle) wrote:
> Use filemap_migrate_folio() to do the bulk of the work, and then copy
> the ordered flag across if needed.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
