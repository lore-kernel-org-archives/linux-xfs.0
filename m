Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 612F5C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1143564D9D
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhA1Jsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbhA1JrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:47:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356E6C061574
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QEpuRjb1CWsNg1SqJjPRIDqST6rmlost8hcngs6NqSM=; b=kPUcmGhEeY0SFlCj8Gs2XoaqIQ
        OTVo2L8FBLnjpOTySf1MJsg9k220rYz7qIgrmEcmPksa7gKadgEmSViWypcd/fU6wvP3noLhElGWq
        r9tmxl6+nbnNOCq6732abh55qbnVm9re1JI3ipji9PCaz5EvOrgK8C6p6gbLfmi/dvbpYT3AAtbA+
        CIYAxPHkMSbOaqQJHkp2UuiQHv/HtB2xafsAj+NEAPMXspHa9QGyoPAlYnaN3e31NtgZ2Uj3NPymZ
        44nHkHe5E/nfYHuy/9Heijs2ljALBNzoNC/fiy1aN/VJ2Rr1OQJrYA0kBh61RMJf/aPmnxJcc3Uzm
        RkjvjvQQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l53si-008HXK-E5; Thu, 28 Jan 2021 09:46:28 +0000
Date:   Thu, 28 Jan 2021 09:46:28 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 03/13] xfs: remove xfs_trans_unreserve_quota_nblks
 completely
Message-ID: <20210128094628.GA1973802@infradead.org>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181368129.1523592.7737855214929870215.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181368129.1523592.7737855214929870215.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:01:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_trans_cancel will release all the quota resources that were reserved
> on behalf of the transaction, so get rid of the explicit unreserve step.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
