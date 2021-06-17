Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFC9C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 07:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF1716101A
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 07:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhFQH67 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 03:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhFQH6z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 03:58:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701B5C061574;
        Thu, 17 Jun 2021 00:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LWx+DPDGY1K+Q0QEXsh2daJdFlaWsWR3pVR94c0rObo=; b=pTrSo4WCFq+fie+r1rE0MnsJd9
        4Q5Yr2k6N284i9etNBS1a2kZFaK3MYyzIbwy5utdfcOyF6g3LkhNz5Eln8c66jyAE3uehMBuHYwyC
        fe06CsPfmOgjSAFC3c2hUfMC6SYc/oPmB3tHCjhge3iXFm0sgJeNoGf+f6GNpdivIIpXqulrENXl6
        uv3MzxTd84ZEACu6QWyKbQfYYix6zqQrJpWs8J6yHbny9Bw7FoADp8Ci/3rXIQzpECVeEaSjUNfJ1
        bxjLmdTZYMPndU6Bo4Bq5XzNs03JMu1FLemneDqWKINjQIayOpzDcCeBKToz13CC1lzppzLHHNGVB
        wB4iMJHw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltmsb-008tLO-9h; Thu, 17 Jun 2021 07:56:10 +0000
Date:   Thu, 17 Jun 2021 08:56:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, guaneryu@gmail.com,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Subject: Re: [PATCH 07/13] fstests: automatically generate group files
Message-ID: <YMsAEQsNhI1Y5JR8@infradead.org>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370437774.3800603.15907676407985880109.stgit@locust>
 <YMmpDGT9b4dBdSh2@infradead.org>
 <20210617001320.GK158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617001320.GK158209@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 05:13:20PM -0700, Darrick J. Wong wrote:
> <shrug> What's wrong with requiring everyone to run 'make' when they
> change something in fstests?  I suspect most people already do that as
> muscle memory for most every other code project on the planet, or as
> part of `make install' prior to starting it fstests.

I know I keep forgetting it and I know a few other people that do as
well.
