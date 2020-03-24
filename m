Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA66C41621
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 08:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C1852080C
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 08:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZkOOnLvU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgCXImR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 04:42:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33348 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgCXImQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 04:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r6FZdiW1nXAfAR9bfkBEhnVzsxdcB9pB9cgxJ6snAXo=; b=ZkOOnLvUp1MTm5GGrTcFrn0dAj
        rV6Rgym/gg7LGKOIoiL1cMD2jOXI1wx0vw0NoHBgRyYWykqBw2XCmaLS0sdU6970GL3ktdJqPtT7Q
        FmDhhHAgOdwP9VaQVr186hCLPX+nD5aftI7LOKJNKeOQ1KBx85/fPbdvxLOgwAMZfOMKmxJCUF+3l
        gto+ZmVhMcGcxRrhjHEohglOdORszwHZlotO7JpP4Wyf18m3cnX6q4rvQVCYegh4HGnMzVumUGDwL
        rsFyg7O+yKfty40tiOjNtd6ZEI7WUUsiCrDjZ+ZpzYGEMAesS2ud6MqaG/5eBk1XgEmVkNZ2wspzy
        weYkskIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGf8a-0003dv-Ku; Tue, 24 Mar 2020 08:42:16 +0000
Date:   Tue, 24 Mar 2020 01:42:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] mkfs: use cvtnum from libfrog
Message-ID: <20200324084216.GC32036@infradead.org>
References: <20200324001928.17894-1-david@fromorbit.com>
 <20200324001928.17894-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324001928.17894-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 11:19:24AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Move the checks for zero block/sector size to the libfrog code
> and return -1LL as an invalid value instead. Catch the invalid
> value in mkfs and error out there instead of inside cvtnum.
> 
> Also rename the libfrog block/sector size variables so they don't
> shadow the mkfs global variables of the same name and mark the
> string being passed in as a const.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

I'd have split this into one patch for the cvtnum cleanups, and one
for the mkfs conversion.

But otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
