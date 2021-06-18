Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B921BC49EA6
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 907A9610CD
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhFROT0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 10:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbhFROTZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 10:19:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEF4C061767
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 07:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bS/I+N1kndJYEhrpPFTi0L+fIeXlCXO0e5YwlCG18lQ=; b=coIk4eEW9Ui6RRCg0q4l0hOs+Q
        6lccWXjD7g5isuX+nUCAhYHWdsXzl9fPIBtv8e5ltxAvUGKE+4lkb/bk76YWrYfC8fFvAsCi9b9cx
        K7TOpIQDOmV/+3YLQ9eK1gg6JL5YKPlDgOQFzz2ddfexG78Ovy0mcfjAiHB3hWSStcSHXu59l3H65
        KWK6NNqOnIoGUTLTxppsjaekpUEQcqft4221ESn5SHR8yQgZF9Zwu4K6BuKfpaZNhMS9FsAp1mi5g
        3w4XaTcpG0JQP6La1f0786X/iDZqV9Q5znAPzwLav6q4hMw1MakDN6Zk50qjrg//kDnWtEX53tvUf
        ucybTGTA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luFIm-00ALeN-II; Fri, 18 Jun 2021 14:17:04 +0000
Date:   Fri, 18 Jun 2021 15:16:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move xlog_commit_record to xfs_log_cil.c
Message-ID: <YMyq2Cruq/ow9ZTu@infradead.org>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617082617.971602-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 06:26:12PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is only used by the CIL checkpoints, and is the counterpart to
> start record formatting and writing that is already local to
> xfs_log_cil.c.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
