Return-Path: <SRS0=21/y=Y2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DDBCA9EC7
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 16:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59C1F21855
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 16:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q7aNG4b6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfKBQTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 Nov 2019 12:19:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36680 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfKBQTi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Nov 2019 12:19:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kiAR8Q6MVw18/jKmd9xK/6Gs47q1UHHT2SPWd/M+sbY=; b=q7aNG4b62TN/mcsUy7ResbMaH
        0bW1cGmhyn+0wlqjlIXCleowBbVgTUEQzMo0LJP9DFpkIEfhOp+ZFti5X68DZxevlhlGB762G/GZb
        /GDAccBHihg9rD72iXRSPvO8crt3FMrlNQfMj20EoS09y80KCdTsqlJiWrU2nNFbXrjEC4MNSo9+4
        MtkWphwcLDMfBXjcw9mP3EtdUAaPrM3CfrpbvFoW8x6vy/mEOCo3WxS0wR4bli3CuS4liHRHsF9M3
        rUTld/N2gi6RaErWh9v6QX4BOXoQMF6xoWMErCVhUvjSP9T51wiwFrOK7fBjBqtQz2w5Sn9lTEKJ/
        2ZVh7RMjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQw7m-0007wD-KW; Sat, 02 Nov 2019 16:19:38 +0000
Date:   Sat, 2 Nov 2019 09:19:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v8 16/16] xfs: move xfs_fc_parse_param() above
 xfs_fc_get_tree()
Message-ID: <20191102161938.GD23954@infradead.org>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259468795.28278.16467063707250965967.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259468795.28278.16467063707250965967.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:51:27PM +0800, Ian Kent wrote:
> Grouping the options parsing and mount handling functions above the
> struct fs_context_operations but below the struct super_operations
> should improve (some) the grouping of the super operations while also
> improving the grouping of the options parsing and mount handling code.
> 
> Lastly move xfs_fc_parse_param() and related functions down to above
> xfs_fc_get_tree() and it's related functions.
> 
> But leave the options enum, struct fs_parameter_spec and the struct
> fs_parameter_description declarations at the top since that's the
> logical place for them.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
