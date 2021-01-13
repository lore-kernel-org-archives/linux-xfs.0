Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BC6C433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA5CC23433
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbhAMOgN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 09:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbhAMOgM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 09:36:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278D7C0617A5
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 06:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gRyFqEzQu6of/giNn4cpOIYEw09CuUt4J+6A7JEVjv4=; b=R1Hlf+xT6dS2lda5dgK1iUXxxn
        4lDYTZ6Jj7IYDrCFnVChKaBFf5XJj58llbEHyfWloFuuoRyPVt6ef/q4+WqTAm0vyq2iASKaFkqU1
        L1OaUWjp+/hxVDm8Hz/mO1Bnlshfp3cr0LbJpjxsgnp6JBs36DzQt9r0SYJKYpw2YlGVrY4z4D4Gn
        42JfNJhgiE8gHkCuPfJGa5CeuQLV9KP4ZCqMMEUcZoMV4+9WJt3PMz0vY8CXW1Ua3+AKV4uyaVfuM
        shKl6s18Lq6/OKswIkaG+Eyh0HhKtYjUjvpalFxBWVuEMB1H5NPoM8/Nr6JGoSJ3IkZfajfAUzwI6
        6tYGqwbg==;
Received: from [2001:4bb8:19b:e528:d345:8855:f08f:87f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhE4-006Mal-Ky; Wed, 13 Jan 2021 14:34:25 +0000
Date:   Wed, 13 Jan 2021 15:34:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: hide most of the incore inode walk interface
Message-ID: <X/8E6jcpKD6TzUO7@infradead.org>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040736028.1582114.17043927663737160536.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040736028.1582114.17043927663737160536.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 03:22:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Hide the incore inode walk interface because callers outside of the
> icache code don't need to know about iter_flags and radix tags and other
> implementation details of the incore inode cache.

This looks correct, but I'm still rather lukewarm on all the extra code
just to hide a single flags argument.
