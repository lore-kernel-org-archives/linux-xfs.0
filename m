Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EE3C48BE8
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 05:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69C2E61164
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 05:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhFPFnK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 01:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhFPFnJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 01:43:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70770C061574;
        Tue, 15 Jun 2021 22:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bseBn9CqdtcTTrvqum8ibLkUH1Bgc42XZsp11fTKNO4=; b=Slvuf04tdTMqm94PJ8JJYQ4isA
        Q6QOHauYGUbhqXET7F5vhV7RAHIehElwfWpsZfUSFrKkRyaUfgBrbY8To28VlXWN0Wex/cNkvC7/W
        K6zktViwJ8BcI0TyC82a2fBcDzUtyVX6Sb8RVs04KlMsftahtf3F6VBdSRlc78stH0rw6atUMs2sj
        XoGrPGtLlQJlUqJRVq/TtngxEHMdsF0X0ZD0E60RA2aEXRve5d7Y8LEk7wm4tzu+0h/Ob4r1GMakJ
        99bbeD47yohWzqw7Jmm/UvU62bI4SVHRnTgkHvj1yB9hoKwo2NHXoR9Kp6cPNPXmw6rXBczqIEcQ1
        fr+rqr4w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltOIB-007eGO-Hm; Wed, 16 Jun 2021 05:40:50 +0000
Date:   Wed, 16 Jun 2021 06:40:47 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Subject: Re: [PATCH 01/13] fstests: fix group check in new script
Message-ID: <YMmO32T/h1oBGOX0@infradead.org>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370434486.3800603.7731814883918606071.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162370434486.3800603.7731814883918606071.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 01:59:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the tests/*/group files, group names are found in the Nth columns of
> the file, where N > 1.  The grep expression to warn about unknown groups
> is not correct (since it currently checks column 1), so fix this.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
