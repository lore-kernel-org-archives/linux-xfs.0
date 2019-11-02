Return-Path: <SRS0=21/y=Y2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA75CA9EC7
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 16:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D673C2084D
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 16:19:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i08NGhLW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKBQT0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 Nov 2019 12:19:26 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36662 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfKBQT0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Nov 2019 12:19:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=axOMtE0mQLJpfvRxu6Ouxf84Ys9Xu2ght80TH8shUxU=; b=i08NGhLWmhPSQZ1iSNVJBbYKk
        Th5pz2KIQjw7kL0wYWwrXGxJLt8xLlYukqgyJSeZ2nBMqJTlXaC5VGa4K0dH4GJ08LjDf1hpW3MVz
        b65+u571WjD/6pFF27YYbQ9p9uID9msyhsLZv8NKv7hUb6CBXDtYn72MjMYKGodpXIpFD6gP5mex1
        8lE6vck1XPhMGoqJuxxZAQ0THDUKFP1BIE4nOgC5AMIcBT3PiSmulpdmgfbABnmezAjCuw+CNiQCI
        Xt+OxP5rLGuS6O0zdCw3+JhU+R+gVu0IrmkVleyEUri4qmOOgyACRulHRS4PwDOL2Uz4XPdt4HyDK
        JOaIgDE0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQw7a-0007vR-4J; Sat, 02 Nov 2019 16:19:26 +0000
Date:   Sat, 2 Nov 2019 09:19:26 -0700
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
Subject: Re: [PATCH v8 15/16] xfs: move xfs_fc_get_tree() above
 xfs_fc_reconfigure()
Message-ID: <20191102161926.GC23954@infradead.org>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259468201.28278.11198315382109394618.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259468201.28278.11198315382109394618.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:51:22PM +0800, Ian Kent wrote:
> Grouping the options parsing and mount handling functions above the
> struct fs_context_operations but below the struct super_operations
> should improve (some) the grouping of the super operations while also
> improving the grouping of the options parsing and mount handling code.
> 
> Now move xfs_fc_get_tree() and friends, also take the oppertunity to
> change STATIC to static for the xfs_fs_put_super() function.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
