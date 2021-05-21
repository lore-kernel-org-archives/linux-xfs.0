Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DD6C43461
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A2A600CC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhEUIDw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 04:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbhEUICe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 May 2021 04:02:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D35C061763;
        Fri, 21 May 2021 01:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LT+5J1wFRqedsA0Tkz3HjzOATPNMH0pDYxa+nH0Uz7E=; b=VBzgqwoaPn3CYfhkmgYfXp9ima
        IJJsL3ViTBqW5f6IYM6Ov4okY7zQCfrYpOUAGvcYlstsUcsyp09csbZOQ5gcAVOKNiZsrGum7hVvy
        XhUr40rXBIwGQQQ3hxxur0iI85cB5mxg7aoTb4nb/K21bxgyKSb8WXyv17B8v0MM0ruqaf7U60MrM
        h5wmVDnN3Aixp4s9ig+lhWqFkbmi7lIgY24RFaY0R71218wcaH5u3WfnUih15c9aC9xoZ2XLkvyYv
        YqsOcjFWDs+q23QTo0U0naSeUNfbto1lhYGRfEnGUNn5qdCnH3h0d1uEu6FDXQrZzpg4hK6Es9199
        ZcYuejug==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lk03w-00GlXn-L8; Fri, 21 May 2021 07:59:25 +0000
Date:   Fri, 21 May 2021 08:59:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/6] xfs/117: fix fragility in this fuzz test
Message-ID: <YKdoVF/fjUbFng7O@infradead.org>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
 <162146861868.2500122.10790450415786633712.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162146861868.2500122.10790450415786633712.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 04:56:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This fuzz test has some fragility problems -- it doesn't do anything to
> guarantee that the inodes that it checks for EFSCORRUPTED are the same
> ones that it fuzzed, and it doesn't explicitly try to avoid victimizing
> inodes in the same chunk as the root directory.  As a result, this test
> fails annoyingly frequently.
> 
> Fix both of these problems and get rid of the confusingly named TESTDIR
> variable.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
