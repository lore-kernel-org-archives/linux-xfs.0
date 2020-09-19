Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30614C43464
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 05:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E91F620866
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 05:49:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LVOYwrK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgISFtc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 01:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISFtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 01:49:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03124C0613CE
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 22:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PU2pmD8nndFOoi4LEG4aci5reFEJkA46r2JOEyugwdc=; b=LVOYwrK68xKbjySfWIw0WW9vpE
        nbpRiEHcyx0dPWVsIJn+B1zOMVry6+d/EY0moDJ4H53MOQPF4k+5HkoWULF3R55iPwrOku3QNrMG3
        m/QjgmpDq8qqE4CBwgK6WSbbXKUVvFNZwG92D6FSiSlmcQbEY7v60XIeqb3ELlKyrFQ5pc1aid2g2
        faVmZmKMvqCjSiB0XOZ2aBjDAZpRQwK9Ayo5cZPu34cYfGenJz2Ht8c1ocr0Vz0fh/bwz7iIxQo/S
        Mp0SljnRzUtn2YNWKWrRIeQUc+SUhmWGqwClo4H0YnH+qLrDr59niJfQWQa5six8QHEtOfS5qolJu
        uD6O+8gA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJVkY-0001Zm-9j; Sat, 19 Sep 2020 05:49:30 +0000
Date:   Sat, 19 Sep 2020 06:49:30 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/2] xfs: don't release log intent items when recovery
 fails
Message-ID: <20200919054930.GO30063@infradead.org>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <20200918021702.GV7955@magnolia>
 <20200918021940.GW7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918021940.GW7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 07:19:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Nowadays, log recovery will call ->release on the recovered intent items
> if recovery fails.  Therefore, it's redundant to release them from
> inside the ->recover functions when they're about to return an error.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: fix subject line
> v2: log recovery frees unfinished intent items on failure, so remove
> release calls

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I'm actually pretty sure I have the same patch lingering in one my
unfinished branches somewhere..
