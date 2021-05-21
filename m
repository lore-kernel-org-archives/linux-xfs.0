Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB013C43600
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A858661363
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhEUIDx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 04:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhEUICe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 May 2021 04:02:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F68C061574;
        Fri, 21 May 2021 01:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nyKN/cXpXjdARgsRG1XBUh+GOmLDG7sTRODDt8GRxN8=; b=Xvq/41298l4s78PhLQp5bA1tQk
        OaaV8bkW+Ii9GGlJLTDCbpRTJggTnqImMfUnXbSpBy8/sxU0cFONobCVr9bOq5oHlzataaLYSaPMk
        vyd+xGq3WS92MIdJn9++8gYzvO17bwL+80NexREnACzrolnOPTkk5MzuiKgO91KgawphE7FpFBoIA
        ozvnBIXHz6DW8jvXGuw81Jqx3Yhn/qsGAz/+JOGoyJaurdwsZlpNuFbVC+ZYeLqgiF8B8p2eJf+sn
        in0xYZvNsyJM1pqjMp9lOEoG9sPAPdz7fzkqkQ66R+Wt8Zr8ciWHOsl2F9mjgPhXBqjVXu1zhg1/p
        /CobdRfQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljzwC-00GlNH-AT; Fri, 21 May 2021 07:52:00 +0000
Date:   Fri, 21 May 2021 08:51:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/6] common/xfs: refactor commands to select a particular
 xfs backing device
Message-ID: <YKdmdB8NIlpGXw3T@infradead.org>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
 <162146860674.2500122.8733670522999610459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162146860674.2500122.8733670522999610459.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 04:56:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor all the places where we try to force new file data allocations
> to a specific xfs backing device so that we don't end up open-coding the
> same xfs_io command lines over and over.

Eventually this might need generalization for other file systems for the
generic tests, but for now this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
