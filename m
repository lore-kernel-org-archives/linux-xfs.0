Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DAFC6FA89
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Sep 2022 06:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbiIFGgY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Sep 2022 02:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238420AbiIFGgX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Sep 2022 02:36:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569494622B;
        Mon,  5 Sep 2022 23:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kFNZmmVwOhX3BjOPJ3tln3iTlg4hrSY3aWoS1Dwfdhg=; b=yGw6sWaI79F1sxKkVQaLBqfkMn
        ciPMa49hRCEsXC2e6QaC54/IVuW1x7URn7p9FAd8AYvAjhg/l+1gdoUkyxzOIxNQSBREX9xh7Ddi7
        q2c0xDaqVAW+qvoITRmcqt4ZgncEoEdCsyZ+if/g0K63wSpNDe759gtusSOfiypyV3ckYrrwNjqKy
        fw+hMWUso0tMaAGn4D5npZ88RTr1mhqS1sde0A6s/XS2WYHo+CKamVL67MufxQdIBBU7Cql8EAIJ8
        2S3PpJWk6hCoYJk1DgBfZbJROPvkE3hHk70QgGadjMpxViBoTBeQ/LLfjrtGr9lkOg7brY3tIdMCT
        o3mXVCUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVSBm-00AS9k-Lz; Tue, 06 Sep 2022 06:36:02 +0000
Date:   Mon, 5 Sep 2022 23:36:02 -0700
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
Subject: Re: [PATCH v2 0/7] convert most filesystems to pin_user_pages_fast()
Message-ID: <YxbqUvDJ/rJsLMPZ@infradead.org>
References: <20220831041843.973026-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831041843.973026-1-jhubbard@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 09:18:36PM -0700, John Hubbard wrote:
> The conversion is temporarily guarded by
> CONFIG_BLK_USE_PIN_USER_PAGES_FOR_DIO. In the future (not part of this
> series), when we are certain that all filesystems have converted their
> Direct IO paths to FOLL_PIN, then we can do the final step, which is to
> get rid of CONFIG_BLK_USE_PIN_USER_PAGES_FOR_DIO and search-and-replace
> the dio_w_*() functions with their final names (see bvec.h changes).

What is the the point of these wrappers?  We should be able to
convert one caller at a time in an entirely safe way.
