Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE50C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3101C61A02
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237573AbhCXSYp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237354AbhCXSY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 14:24:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E48C061763;
        Wed, 24 Mar 2021 11:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dfq4VGLxllMuYHNcHXZBosJEZZF6lJ6E2wYPqamZhN4=; b=k/Mey51R9MPhChTa0xsD0w0Q0K
        BALlF5ewCUBm2bgr4GXlAaOdQ7Rlhz7MJcprBNVEqcen6YW8hcXbG/MBbqcYIdIOCrmUtfPUe++dh
        lYg2VWZ/j6QlWOZu3JjQUcNewtohtxsplpMkYDZPMv6eWm94tdg2c4RSfuVH6yxY7bThq8qYGaLK7
        kN2fDmn9fQIax5nzuUevbh5ex+zWTT1iK9LxEWl7UMCWyac45BuQcHna9jF96FC9lJ/1ZD03VdDV7
        sldUB3cMgnbe/Q1zwxYEPVzLFejsXJh8yQnRgPw7iB8iJdn9xmlxaoPMzfG4MvaGTYENhwV+lE5lN
        23B5gMhQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lP89b-00Bgo6-Os; Wed, 24 Mar 2021 18:23:24 +0000
Date:   Wed, 24 Mar 2021 18:22:51 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, hch@infradead.org
Subject: Re: [PATCH v1.1 3/3] common/populate: change how we describe cached
 populated images
Message-ID: <20210324182251.GA2785913@infradead.org>
References: <161647318241.3429609.1862044070327396092.stgit@magnolia>
 <161647319905.3429609.14862078528489327236.stgit@magnolia>
 <20210324181748.GK1670408@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324181748.GK1670408@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 11:17:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The device name of a secondary storage device isn't all that important,
> but the size is.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
