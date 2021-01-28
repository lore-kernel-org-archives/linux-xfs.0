Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EFCC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE92E64D9D
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhA1Juu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbhA1Juk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:50:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89336C061573
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RHSrtYHA2ssEZDXRdVMdtneTzZqLJFLJy9jKgRaGLfM=; b=SzfWP+XmLpDO9huCEeL3ivXVsc
        PkPWrryceFuWxaRcAwBd6iW8Y9iBFPMEAYrhf2mYm58D7szOn9AFYDW0WPFvQIRJNtIXTADlxGwpj
        W6wVOOUj45l36vWpqYd/XSCG/27VMzIQaQjzxI7yHQDcJfxxHueNlRBbj7I91XrsMiRn2AElDAJ8l
        Oc36IyKTF0VVxqGaAJTrh69010uE9eAjFAkpzn3jRFKEbvpci3sy5lxnJwcAGRlzReI+iNWt0aSBA
        QYazkIKHC3qnL5ILA61TXJye07msNBwaBaEqshPZJx458le4j6LKJMvjUXiUiJY/fCU6g+FjI+mKx
        0RQDouFQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l53w2-008Hje-Ut; Thu, 28 Jan 2021 09:49:55 +0000
Date:   Thu, 28 Jan 2021 09:49:54 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 06/13] xfs: reserve data and rt quota at the same time
Message-ID: <20210128094954.GB1973802@infradead.org>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181369834.1523592.7003018155732921879.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181369834.1523592.7003018155732921879.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:01:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Modify xfs_trans_reserve_quota_nblks so that we can reserve data and
> realtime blocks from the dquot at the same time.  This change has the
> theoretical side effect that for allocations to realtime files we will
> reserve from the dquot both the number of rtblocks being allocated and
> the number of bmbt blocks that might be needed to add the mapping.
> However, since the mount code disables quota if it finds a realtime
> device, this should not result in any behavior changes.
> 
> This also replaces the flags argument with a force? boolean since we
> don't need to distinguish between data and rt quota reservations any
> more, and the only other flag being passed in was FORCE_RES.

It a removes the entirely unused nino flag, which caused quite some
confusion to me when reading this patch, so please document that.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
