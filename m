Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE064C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 07:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A22ED61185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 07:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbhIPH0h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 03:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbhIPH0g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 03:26:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A61C061574
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 00:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pHxGu9m3fgT37JANRWaQpgSwFOf32H7DeSxjDJ/hfC4=; b=ZAU70IyGcKZQv/yetGUrQjrYZL
        r466UTGHdvQeDqnmlcE0XOBxMf6HU0IdUvEJFoLth+dQ0mC/ZAyDKWmUn1RWsexUVYRgGsXEqGTqH
        7BzwOrYzhc9zn4VrNJMNTf2ykXQgqhbf/nAist6VAgeug3aduuRwY9zPTi/C8S14PiMOyWOrnD+yA
        jV1ZquzFF8dVXI6s+5kc4MBae7vFhn5ZuX96oRXicZxv5DzorV8JCjZYMuNVr0zzjG7/YQht76N+0
        fp+/b2MybIIGeEeToUi8GHGs+LwicbPyH80tJi4tyEQtZ34FNqLs8qYfWxB9FcOPAf/uEggFTt2xr
        drdA2XPg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQlki-00GPkr-6j; Thu, 16 Sep 2021 07:24:24 +0000
Date:   Thu, 16 Sep 2021 08:24:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/61] mkfs: move mkfs/proto.c declarations to
 mkfs/proto.h
Message-ID: <YULxHC8859w3ktZi@infradead.org>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174720034.350433.11964220787370567480.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163174720034.350433.11964220787370567480.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +extern char *setup_proto (char *fname);
> +extern void parse_proto (xfs_mount_t *mp, struct fsxattr *fsx, char **pp);
> +extern void res_failed (int err);

It might be worth to drop the externs, the spaces before the opening
braces and the xfs_mount_t typedef usage while you're at it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
