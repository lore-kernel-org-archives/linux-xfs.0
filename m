Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4953C6FA8B
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Sep 2022 06:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238535AbiIFGh7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Sep 2022 02:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238536AbiIFGh6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Sep 2022 02:37:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC99A70E63;
        Mon,  5 Sep 2022 23:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yz1groZiQ8kjjeKmvdd6+3CCz4QHr1M3PU+Sq/EGT5I=; b=g0lvSrRuEPdbtKutLHr0dYl28F
        jHL8qXWrjbzihVvmA3F7HVDsCF22xmQpMxhj8k4OZ1zAAk+8dx9ZXj9uaMBRiWfQifPpH8ho+CW1A
        O5Oo0EmadRFkzpIJHTDc4jmdcwkt+BvCHL3SBqNGL7IUqpoPNRun0rf+a9oEQ5XtOwI8btB98YOwO
        YJUhfVBC8HbI3+biJgCBTfuPYoyZ/QqKAaMtTTxPgybbpmsn7FP9uW7Hmeh2w5phQ63/f13P/zRTP
        8TZi141F5pw+lYCZa8JcV/xMZwXahgQdgQPrdsGpNPGzXZQJqgXFLr/NawXbFx26/5+2gxXZU1DaV
        A/G17Abw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVSDQ-00AT55-C5; Tue, 06 Sep 2022 06:37:44 +0000
Date:   Mon, 5 Sep 2022 23:37:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>, Jan Kara <jack@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] mm/gup: introduce pin_user_page()
Message-ID: <YxbquGs0QN3BRw4I@infradead.org>
References: <20220831041843.973026-1-jhubbard@nvidia.com>
 <20220831041843.973026-3-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831041843.973026-3-jhubbard@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

No need to export this, it really is an internal helper for
the iov_iter code.
