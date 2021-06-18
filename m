Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D32C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E98D613ED
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhFRNtd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbhFRNtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 09:49:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9BCC061574;
        Fri, 18 Jun 2021 06:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lj5PTg0GsLkU5Wu2Amxu+zuiAqxtHs5LPvKCKNYwLtA=; b=VK5fVdr/0vJiRU55xExlz7w2xO
        ZfVWp/bVsadseqA08ebqn/saO+P6tseb4W8tFXbAUZMLxWXBrCHFYFHFwGCS2fwdUj3vLR+2SJCGF
        H0Ey63ReA3RsBdP9++hxs6/4tAyyqCPFdrqqQL7uSezYx6V0qdmKOrvIB7im9nQ7YY5TWyWHFk+mY
        enuJwXxqvgpVF1tBm6JBGXRF/7n4EfWnBcl6zRfren9DVIZvHvtObcLGBMVjgL7JIJJ1oN2sIvpmD
        1b6BzFnCO3azlCCzNcgEoNpmCrDx2nARUdP0Q5xn7A7HUnNA+PH8B7XlNSvBrHQ9ChfPKRp3nTeum
        kVSt0YlQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luEoS-00AJlf-9U; Fri, 18 Jun 2021 13:45:51 +0000
Date:   Fri, 18 Jun 2021 14:45:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, guaneryu@gmail.com,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Subject: Re: [PATCH 07/13] fstests: automatically generate group files
Message-ID: <YMyjgGEuLLcid9i+@infradead.org>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370437774.3800603.15907676407985880109.stgit@locust>
 <YMmpDGT9b4dBdSh2@infradead.org>
 <20210617001320.GK158209@locust>
 <YMsAEQsNhI1Y5JR8@infradead.org>
 <20210617171500.GC158186@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617171500.GC158186@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 10:15:00AM -0700, Darrick J. Wong wrote:
> I suppose I could make the '-g' switch call 'make group.list', though
> that's just going to increase the amount of noise for anyone like me who
> runs fstests with a mostly readonly rootfs.

Just stick to the original version and see if anyone screams loud
enough.  Of course the best long-term plan would be to not even generate
group files by just calculate the list in-memory.
