Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32CE4C48BE8
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 05:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 135E9613BF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 05:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhFPFpA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 01:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhFPFpA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 01:45:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB711C061574;
        Tue, 15 Jun 2021 22:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wYkM6rH3qRqRxcjZFfiVwXNUG3bNYIAmpRs2850u8aM=; b=m8Hrx0t8b1Q4IKtubJr8ll9/4F
        h+tjbBirtPKIEo/S3xC7fFD/k6UZjd6EFA7THrzI9ms5RRoA2PpJVo7xy6fc0Gtz4T8eTRMGV1FjY
        sIYKwoOuO+sQcht+WV/f8eEUby+dT75AdX+4um0uOpjunEHX3LcOfIVIDsNZjt3NGoqHDVkPefiZ0
        kTiea8d+tVKe1ekO+1BKK6I0MTpYd/vNFcgNfgdR9OJbWxxh1Q+N4bPOJe1s8qfnJsjXsSlNYbxc/
        2su57lkGHAnNYb2ZxoAx+laPj1rL6+KlFUkaP5gUJDq4M3WN+h2Kmb8WXXGAOdwpwP4Boih/9jBE/
        JJwrPcyQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltOJv-007eP8-Hl; Wed, 16 Jun 2021 05:42:37 +0000
Date:   Wed, 16 Jun 2021 06:42:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Subject: Re: [PATCH 03/13] fstests: refactor test boilerplate code
Message-ID: <YMmPS4c8HhzjlOrT@infradead.org>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370435585.3800603.509157515145342966.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162370435585.3800603.509157515145342966.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 01:59:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create two new helper functions to deal with boilerplate test code:
> 
> A helper function to set the seq and seqnum variables.  We will expand
> on this in the next patch so that fstests can autogenerate group files
> from now on.
> 
> A helper function to register cleanup code that will run if the test
> exits or trips over a standard range of signals.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Nice!

Reviewed-by: Christoph Hellwig <hch@lst.de>
