Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8D1C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A32E20738
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389671AbhAKRjt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389660AbhAKRjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 12:39:49 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57169C061786
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nmsFRMZwLGi59AUhu24+LcY7yDrLm1K3T4CmyqfHsOQ=; b=DPEopZB02LywaaLCGsKbSeYcri
        cI2mu+g5/2puSVRIY+xZJ0l7tx4+4fwOFLLFyCfgj6zcZN89NPmtQgi01BMEiL3a8bGb0gqsN2+Cg
        VCvpE2cCAlPvPjqVoOYq4u5+4hLj6kSrA1hJaY7Uqm/s+9/FWxwYTmNYqgjg2uESGsVM/zL5rV//A
        exzTUWIaxc+HWapnLWncPktAuiZRk9FhAU0HlO2s2fuuNtWzvi5xehgJezs6F7d/gbrFNTdqeSjiC
        C4qyDGle0g7borPEieIVaGq6NRgavabkyNclcSzvG5V9tKxioHAqD1yG+zj2es0KQF762ua+kZl9f
        o5G1R82A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kz19X-003ZVL-T5; Mon, 11 Jan 2021 17:38:56 +0000
Date:   Mon, 11 Jan 2021 17:38:51 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: sync lazy sb accounting on quiesce of read-only
 mounts
Message-ID: <20210111173851.GD848188@infradead.org>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:41:19PM -0500, Brian Foster wrote:
> Update xfs_log_sbcount() to use the same logic
> xfs_log_unmount_write() uses to determine when to write an unmount
> record.

But it isn't the same old logic - a shutdown check is added as well.
