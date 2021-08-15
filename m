Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C543FC4338F
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96D346120F
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhHOPd4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 11:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhHOPd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Aug 2021 11:33:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06553C061764
        for <linux-xfs@vger.kernel.org>; Sun, 15 Aug 2021 08:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=etePLKBNH5kVPpe0yZH9eRz2fnMUb+Bq3ZikOmYQNEY=; b=vSRY6bvwNMbOHy8x5r0dEerAlt
        mj2A0t6pvWrH+nm19sZuS17uJ4rSWml4QUT50SMgrbFIt2J20NIi7gP9VyxAN0fr+pmP2TBKh0zud
        zqU6MsN6yXFWrnIrs6nO54qmRKn82i5fetohTyBlP7TjuqgNqkTZy1I41xNLXBgUBJhkMf1T9Gnz1
        bQukcbiV1lGwfWWIxfI2QI/bU/7zJMqb33XoFlFTqvQWJaom5bTw3un1nqinDDjwPaSQVnaG9WjGG
        nlHyCVjbAvK25i74/7hb75LcijgnSeeD9RoYrYEIG2n3/wTZQQKyeran52YYfc8WL1fVWQiqOkp80
        +geuEILw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFI8T-000O6x-RE; Sun, 15 Aug 2021 15:33:19 +0000
Date:   Sun, 15 Aug 2021 16:33:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: constify btree function parameters that are
 not modified
Message-ID: <YRkzvc7qBOWaqabm@infradead.org>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
 <162881113855.1695493.8066313723197135778.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162881113855.1695493.8066313723197135778.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 04:32:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Constify the rest of the btree functions that take structure and union
> pointers and are not supposed to modify them.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
