Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D721C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DAC72083E
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A+7nZKyl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgHaQCS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbgHaQCR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:02:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B01C061573;
        Mon, 31 Aug 2020 09:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xtgQiaVfLrNa6pIN7//ng3IJa0ey16fqpPx1VNHaTLg=; b=A+7nZKylxHICUQOVRfVIIa/IPZ
        GvNVFFm4zgxFzgdcXSqMV5+U50Qt+1plUAaKe43CCzQ7wMiV/3ks2vIXFnUqjw0A4avvO56aRD4j3
        Yvfb40N34EiBbRvOvEfHW38aOv8g18TfnH1dXbsX+4WSg73Dy3n+ZOKhPkMZeaRgYTae8WTOAoJQa
        JbKnc+CjJqQyLVF8mLjHjwJgC/M8ow2eu0DyYm23nJjBD4T32DT5FYilL7jsWVqPykhFkbWmeAzDB
        1fB/mb4fvPxFJgdEVXDZjkni7V20uJjE/eiF4741w36snuhznVfjFebW6k8jPcr7/ro2QHqCf0sV6
        5ptaKLeA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCmG6-0001pb-Ty; Mon, 31 Aug 2020 16:02:14 +0000
Date:   Mon, 31 Aug 2020 17:02:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: disable dmlogwrites tests on XFS
Message-ID: <20200831160214.GA6740@infradead.org>
References: <20200827145329.435398-1-bfoster@redhat.com>
 <20200829064850.GC29069@infradead.org>
 <20200831133732.GB2667@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831133732.GB2667@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 09:37:32AM -0400, Brian Foster wrote:
> Yes, but the goal of this patch is not to completely fix the dmlogwrites
> infrastructure and set of tests. The goal is to disable a subset of
> tests that are known to produce spurious corruptions on XFS until that
> issue can be addressed, so it doesn't result in continued bug reports in
> the meantime. I don't run these tests routinely on other fs', so it's
> not really my place to decide that the tradeoff between this problem and
> the ability of the test to reproduce legitimate bugs justifies disabling
> the test on those configs.

So my problem is that XFS here is the messenger - this could screw up
every other file system just as much.  So if we just want to disable
the tests for now we should do it for all file systems, not just for
the one that found the problem with the test.
