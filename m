Return-Path: <SRS0=2Dxs=CH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28207C43461
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Aug 2020 06:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F108C21527
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Aug 2020 06:48:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YEK8/5Op"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgH2Gsx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Aug 2020 02:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgH2Gsw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Aug 2020 02:48:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB17C061236;
        Fri, 28 Aug 2020 23:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mkp4zEKeYotqWDLoI1xLlqrVzDDIPwtK9tCd9RMvqwA=; b=YEK8/5OpOssnGRjAU21oyyIRb/
        KwYmcDsXBAVmy+0+/4ZceUU69BVoGzBieenle8+sc7WB9mZ67r2gSYK59pq9LRXG2zPbt40DUMJTc
        t7IngTdYEZ+Lc63SWJIyUYzRO9lDJscB6miz5DqW1Wyzue2BRX4C2sHpqFhPZb++ranP5PKOqmNKo
        DQovnjh09342yT8kjsYAeRXBQoQk+XK8iyo98t3cyVy8vrojS0dAarlO9r1lOWaVsGhWM+ry5GX6l
        oF8asjD/s/4afSJ3K5nGcVDg7Kw2UoBqlSv4wad2RFnvAZYaNzGCCjImG9w+FvNc7RWxLorUgtbl8
        ftv0KjvA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBufS-0007xL-RU; Sat, 29 Aug 2020 06:48:50 +0000
Date:   Sat, 29 Aug 2020 07:48:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: disable dmlogwrites tests on XFS
Message-ID: <20200829064850.GC29069@infradead.org>
References: <20200827145329.435398-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827145329.435398-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 10:53:29AM -0400, Brian Foster wrote:
> Several generic fstests use dm-log-writes to test the filesystem for
> consistency at various crash recovery points. dm-log-writes and the
> associated replay mechanism rely on discard to clear stale blocks
> when moving to various points in time of the fs. If the storage
> doesn't provide discard zeroing or the discard requests exceed the
> hardcoded maximum (128MB) of the fallback solution to physically
> write zeroes, stale blocks are left around in the target fs. This
> causes issues on XFS if recovery observes metadata from a future
> version of an fs that has been replayed to an older point in time.
> This corrupts the filesystem and leads to spurious test failures
> that are nontrivial to diagnose.
> 
> Disable the generic dmlogwrites tests on XFS for the time being.
> This is intended to be a temporary change until a solution is found
> that allows these tests to predictably clear stale data while still
> allowing them to run in a reasonable amount of time.

As said in the other discussion I don't think this is correct.  The
intent of the tests is to ensure the data can't be read.  You just
happen to trigger over that with XFS, but it also means that tests
don't work correctly on other file systems in that configuration.

