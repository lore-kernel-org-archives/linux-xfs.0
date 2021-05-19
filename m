Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F27FC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 13:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D589D60FE7
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 13:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346799AbhESNYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 09:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238874AbhESNYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 09:24:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802E4C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 06:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=U31y/Ss/gUspq4fwMMSQLZaEZBCGpIJwMSnLV3ZqjAY=; b=Fr5oKNCBLAEhV2XsTyYH/5uyU5
        kgdarfJnQ0ZjAMCv8YsCAYKJkR51uFAdT6q9QpanTVSd4XQiLXD/BHSpb6hMelTC/EPYPsn+SWQd+
        4c2kxWrAx1SXS4dB8/9a0uqy0RklhRFwkSpzdHNKzuQUCNH+oqCgHCBI8kyZmlCaiLCTpw9VLKAML
        OwZ1z3vbelgXkBTtR46Xws+3zZTDT8+RqSFysEFy8uk0S6bEYHh0LwAdOSNY+3AFDSJ6mDl0Ta4Rk
        dWpaqWZqu2zIGqsYOpftC//AfAgauMY3hACDxO7AGMzZPl+Rl187eofg5Awpo+xU8efkjCTvaF0y9
        +47x121g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljM9e-00EyAh-0P; Wed, 19 May 2021 13:22:41 +0000
Date:   Wed, 19 May 2021 14:22:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: restore old ioctl definitions
Message-ID: <YKURFaeoEXG0CFCw@infradead.org>
References: <162086768823.3685697.11936501771461638870.stgit@magnolia>
 <162086769988.3685697.8916977231906580597.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162086769988.3685697.8916977231906580597.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 06:01:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> These ioctl definitions in xfs_fs.h are part of the userspace ABI and
> were mistakenly removed during the 5.13 merge window.
> 
> Fixes: 9fefd5db08ce ("xfs: convert to fileattr")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
