Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37517C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DE6A20728
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:37:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lhckLfl6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgDYRhR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 13:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYRhR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 13:37:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B934C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 10:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gwPXSi3y3WY4Hgmnl8wZ8L8hPkygqrPFwsx7LV/xzBM=; b=lhckLfl6Y8fzgFln8KrvbevH8L
        gpwFqXi2LqDoe5KwC1hA0M13NH/WLqnbU9OLIC1wx6A9sgb7j6ETUxHHmygda/CsS/gD1Ddg/pbtj
        r3iUMRoHbQek7kpXSPpN60GLxjeyqsrYBKYvZVDGurT7exdZiOxdFYpUNpwxVckjimKPjr0UIoWZz
        2VbRDfYmrfb+vSNA5kCaVLHTKiyHL0TuW90SxfXFYgKRuXaDfAIwJ4FWLbnks1Ne79MTi5B6v7aIM
        YZ3CLh0wi3uvxHEXhw/xbUKABSHGeoc35SKOpV2aVcfTa+aZy2zd54JVwWk3tiqzOxMgnPl8X418R
        0dveHkDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSOjt-00040h-9J; Sat, 25 Apr 2020 17:37:17 +0000
Date:   Sat, 25 Apr 2020 10:37:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 09/13] xfs: clean up AIL log item removal functions
Message-ID: <20200425173717.GG30534@infradead.org>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-10-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-10-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:25PM -0400, Brian Foster wrote:
> Make the following changes to clean up both of these functions:
> 
> - Most callers of xfs_trans_ail_delete() acquire the AIL lock just
>   before the call. Update _delete() to acquire the lock and open
>   code the couple of callers that make additional checks under AIL
>   lock.
> - Drop the unnecessary ailp parameter from _delete().
> - Drop the unused shutdown parameter from _remove() and open code
>   the implementation.
> 
> In summary, this leaves a _delete() variant that expects an AIL
> resident item and a _remove() helper that checks the AIL bit. Audit
> the existing callsites for use of the appropriate function and
> update as necessary.

Wouldn't it make sense to split this into separate patches for the
items above?  I have a bit of a hard time verifying this patch, even
if the goal sounds just right.

