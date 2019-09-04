Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A26C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15CD22339D
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dtSZOQTp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfIDGoV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:44:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48234 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfIDGoV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aOq9cPvEcY4zGxiqWkNJs1vAnuz4vu81lxxkYo+Qrek=; b=dtSZOQTp4loGzCugukl9IfKzE
        GDeq2B88TistYUbuLcgWtmQmUASGAvBxCct2BSZZFv8nq6wquxzc24CKyyiZY84rRiwkSvgic/PiS
        bs2dAf0c6WRi1T3eLBrwl2P/NxjpbacFE1UzrZ2q+ItPXzgEel+NzATVCbW9uv38nmGnpH0hdRhEd
        I7V8GOw9AM/jzMjktAJQmpoI4pReBYkIVswBonQp9GKPhD/s4YLseaAGv0tptyfUFVAftKcrAcXcX
        L6CJMRz63/yc0NEu46N71/kdZ+szBBKEXa5RqWEk1m+P+86Nn7zTW79St7oH3ZMCuqBCkJyfZ2xsr
        ymnsccY3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5P1g-0002xI-Ut; Wed, 04 Sep 2019 06:44:20 +0000
Date:   Tue, 3 Sep 2019 23:44:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: push iclog state cleaning into
 xlog_state_clean_log
Message-ID: <20190904064420.GB3960@infradead.org>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904042451.9314-7-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 04, 2019 at 02:24:50PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xlog_state_clean_log() is only called from one place, and it occurs
> when an iclog is transitioning back to ACTIVE. Prior to calling
> xlog_state_clean_log, the iclog we are processing has a hard coded
> state check to DIRTY so that xlog_state_clean_log() processes it
> correctly. We also have a hard coded wakeup after
> xlog_state_clean_log() to enfore log force waiters on that iclog
> are woken correctly.
> 
> Both of these things are operations required to finish processing an
> iclog and return it to the ACTIVE state again, so they make little
> sense to be separated from the rest of the clean state transition
> code.
> 
> Hence push these things inside xlog_state_clean_log(), document the
> behaviour and rename it xlog_state_clean_iclog() to indicate that
> it's being driven by an iclog state change and does the iclog state
> change work itself.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
