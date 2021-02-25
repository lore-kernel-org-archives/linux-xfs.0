Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633B9C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 19:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1982764F18
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 19:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhBYTB3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbhBYTAv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 14:00:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E796BC061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 11:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=QhGQxL1qqO6qUmmkG2092mEuXx
        J3XZ7SckCFWmVDdR284u6QEq8WBRqX+ceZ4X+x5vdVh/WVLZBnBPT0ZK3BPez7XRua9BQhGhtDpzg
        waKU5Q07zr2nXlRuPrbPSp6pbaC/mI7cidVzkbyF4rOpw0gMkzzeIJwlIg1G0ef3xm8/YAGqPQ9HU
        J7eDrNGzwZj3/xrrtxioRzTK3vw4DZ1R1/6E35tuzg4UVzQVyzs7zm2xyVs8m3YOvZBRUcwwXQBe6
        BsDUB/HKc9ya+DZ+chv0eizvPBPOOeP5AMzUnAhgTtrnBFSF7yuEv8/PE03f16eOm8XUSX6mZCJFB
        JaCa5pwQ==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFLrG-00B3HN-M3; Thu, 25 Feb 2021 18:59:34 +0000
Date:   Thu, 25 Feb 2021 19:57:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] man: document XFS_XFLAG_APPEND behavior for directories
Message-ID: <YDfzEOqCTXa04n1a@infradead.org>
References: <20210224222913.GF7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224222913.GF7272@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
