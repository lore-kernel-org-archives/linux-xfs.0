Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC14C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 07:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B9A861185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 07:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhIPHUt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 03:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbhIPHUs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 03:20:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48B2C061574
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 00:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=W4NKuufPM1MQX6Bnpn7OgEueOhxhM+sJJMhwez4W47k=; b=jqW2rA4RE0r4ulRfLT9///+8i2
        BXAISGhiLZuPSVTa5IsMl/x1Bupw74XZxZ021lVgdEl9ZXYczdCRDWCioz6GgFb6efwMN1x+lsS3c
        8rtMRrrJ6y59en3QTXW9G9TZyAM/QqDqxwlnpudAMGX3umFBxwaAIUReZgOt9fUl9Xk74h7VEEwCQ
        Auvns9YIJeCezjwVyxb4DssMMd1JOJdqpvTPmTozhbx7MNJ35dJ3zEGUEoOtXRQAyXyzHUfigcXDG
        voWsQ2uIeKz0J/NLowYqD5dMv/rYc9T6mbgSVLomSboTaxDka72mIiOLk3vqOVQO84VlCbxys5Uy8
        1W1qXSgw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQlez-00GPXj-7P; Thu, 16 Sep 2021 07:18:26 +0000
Date:   Thu, 16 Sep 2021 08:18:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 61/61] mkfs: warn about V4 deprecation when creating new
 V4 filesystems
Message-ID: <YULvufnBE3VRfZu8@infradead.org>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174752777.350433.15312061958254066456.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163174752777.350433.15312061958254066456.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 15, 2021 at 04:12:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The V4 filesystem format is deprecated in the upstream Linux kernel.  In
> September 2025 it will be turned off by default in the kernel and five
> years after that, support will be removed entirely.  Warn people
> formatting new filesystems with the old format, particularly since V4 is
> not the default.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good,

(assuming you're already dealing with the xfstests fallout)
