Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483FCC53210
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Jan 2023 17:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbjAHReC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Jan 2023 12:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbjAHReB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2023 12:34:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6294D2DB;
        Sun,  8 Jan 2023 09:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hLUnkQfAl0/5a2V4ayJItYShl0I22znsu2etI5nVPPM=; b=dyf4DSCEq5iRs/ISpquu60FPIz
        gs5ld07NzxVe/m7F5fb9zyJP7dmSRc+cIcWHfgB+3P0x4mgAf0BwtgTMdEHfyntSoiraSt2N2Z+EW
        1mHWFUKbfgsKt9U2cQ9UWSlcmaAekJTVoerJM7WzkUT0KdOqvpJrZGa6UK/DM/Wr/AmOtZ6JLBkf0
        F5Tw9IYxpIgsmZJ9tDPBUWmOPrHfdY+JGTk1sN5i5pRGSd/yUFQ8LRhI1tSC9WTzpsYWKqHM8BbHy
        cDBilSwIOqr99nD4V7T9Pomli8yQHDrw+KUlJj17yij/YtS+7TTXMiRKyGDR8Otc8VRukZkA4rA4m
        ZKWf9faA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pEZYT-00Edyn-2J; Sun, 08 Jan 2023 17:33:57 +0000
Date:   Sun, 8 Jan 2023 09:33:57 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [PATCH v5 9/9] xfs: Make xfs_iomap_folio_ops static
Message-ID: <Y7r+hX18BLvd+fp/@infradead.org>
References: <20221231150919.659533-1-agruenba@redhat.com>
 <20221231150919.659533-10-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221231150919.659533-10-agruenba@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 31, 2022 at 04:09:19PM +0100, Andreas Gruenbacher wrote:
> Variable xfs_iomap_folio_ops isn't used outside xfs_iomap.c, so it
> should be static.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
