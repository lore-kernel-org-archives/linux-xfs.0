Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B82C07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 06:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 995F161431
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 06:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhGIGZB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 02:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhGIGZB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 02:25:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A65C0613DD;
        Thu,  8 Jul 2021 23:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uTGgPITzChB0wNVzc3OQpiEHWjv7UFuQ2IuSyNOmjqs=; b=gqlAsUWxWDNUnn8ap1FNqindHP
        afUpcrC9pm/5rZOgIJdMHdytHJM3j0wnm/p8AabuDiGdiVnskUPf/yaq6tNbBI8+rhyBNnqp6gtGQ
        tShU5QPE+6EySyA8bq+SlUv0XOpz5c42MMW7tzFzr982DrsVh33m9v+kzKURNtTwf/g5uu/YPffEj
        x9SZysHnIW0aobcfe0NXXCaxWoIiZUaZ8PKKfDsz1cb3E/+yIZLbduGhhCQlsuzUbzm1R6Dm/g4uK
        3uy3x8JBOMjcEPEEAjTY9ZDUb7LLfuPi8ML+tGpnBfDL8HH+FE7r6U2mFlQHQwI8xFnps7MkxPByf
        Wrnhx1cQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1jtH-00EDVO-A2; Fri, 09 Jul 2021 06:21:42 +0000
Date:   Fri, 9 Jul 2021 07:21:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: [PATCH v3 2/3] iomap: Don't create iomap_page objects for inline
 files
Message-ID: <YOfq7+tS/7xEQora@infradead.org>
References: <20210707115524.2242151-1-agruenba@redhat.com>
 <20210707115524.2242151-3-agruenba@redhat.com>
 <YOW6Hz0/FgQkQDgm@casper.infradead.org>
 <20210709042737.GT11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709042737.GT11588@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 08, 2021 at 09:27:37PM -0700, Darrick J. Wong wrote:
> I was under the impression that for blksize<pagesize filesystems, the
> page always had to have an iop attached.

Currently it does.  But I've talked since day one of the !bufferhead
iomap code that we should eventually lift that.
