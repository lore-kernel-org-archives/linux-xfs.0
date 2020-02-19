Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD83C34047
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 15:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11EB024670
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 15:01:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FbVPGaVt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBSPBE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 10:01:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51596 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgBSPBE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 10:01:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dQq5UdvWp+QdydyVJRmEnvUTQNEYvIRUriwjl717Wo4=; b=FbVPGaVtVufC1cWxht/uSdu9LM
        u4inzXpj28Km884GMUnmZBZO/CLojvZi7gibEIxqwy5P16gRi74kIpFFlM3LmNzkK2VjQeGLm1PIN
        Ast9YJe2181MgGTKVtU4ay5LehVsSUfjLEqKWgKXAy8nNlOwI8zWX80DwX6CuU/UuAiBX+eo4CCHP
        Y81PP5VVxaEj/8tazt0cFvBWDXBOs9Ln2s3muutl3kguvTUKQ6dd4LkeHCQybnqB9Utkcyr9mBpK4
        yVPx2Lypjcjd5xEPJl6EzkzejWufd+ETMbK3W9ivGAB1WoW5AaZ+vd3KfWIaBSoF1nkRoP3ugUxQh
        XhutwZkQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4QqV-0003kJ-Mw; Wed, 19 Feb 2020 15:01:03 +0000
Date:   Wed, 19 Feb 2020 07:01:03 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     John Hubbard <jhubbard@nvidia.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 07/19] mm: Put readahead pages in cache earlier
Message-ID: <20200219150103.GQ24185@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
 <20200217184613.19668-12-willy@infradead.org>
 <e3671faa-dfb3-ceba-3120-a445b2982a95@nvidia.com>
 <20200219144117.GP24185@bombadil.infradead.org>
 <20200219145246.GA29869@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219145246.GA29869@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 06:52:46AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2020 at 06:41:17AM -0800, Matthew Wilcox wrote:
> > #define readahead_for_each(rac, page)                                   \
> >         while ((page = readahead_page(rac)))
> > 
> > No more readahead_next() to forget to add to filesystems which don't use
> > the readahead_for_each() iterator.  Ahem.
> 
> And then kill readahead_for_each and open code the above to make it
> even more obvious?

Makes sense.
