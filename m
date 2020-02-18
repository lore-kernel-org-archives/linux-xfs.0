Return-Path: <SRS0=Vmdp=4G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C8BC34031
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 21:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDBD42070B
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 21:01:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cAV210/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgBRVBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 16:01:00 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46402 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgBRVBA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 16:01:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vfcACA12k8kSB5vbO64+BOisPA60UchzMzgMeAxFjn0=; b=cAV210/g0U3eT5pfC5VlLXL8TQ
        1CP+V9NzMeLcP/2u7dN9RNZaSHg1UavQESl464Eu4EZ8U1bEXzAFh1fB6ggIzReD3tUU51LCcI5ub
        nBQz3r+LoffDyhG7OW9oSu/2mNzk3FtGqi9wYmd+Sf2KsIn3BuevTnffEIvlf+IkGGl0VoX6kYiza
        jtImjkb47ufNfSJejeOsGhq5WqFln97Eq5efgPNogIvxiZrrMTj+5LHX+wicxo6zyrU89A8y3iEVA
        K8+BagSDOCl9tILh6qyZiDsscLpYTh4uPvdAvs8Sv5gky8tuwzcCh4L+tLmHWbtNRNW0k+on9mGPW
        oVPya9eg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j49zH-0007Pu-Fn; Tue, 18 Feb 2020 21:00:59 +0000
Date:   Tue, 18 Feb 2020 13:00:59 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200218210059.GA28343@infradead.org>
References: <20200218175425.20598-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218175425.20598-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 12:54:25PM -0500, Brian Foster wrote:
> Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
> l_icloglock held"), xlog_state_release_iclog() always performed a
> locked check of the iclog error state before proceeding into the
> sync state processing code. As of this commit, part of
> xlog_state_release_iclog() was open-coded into
> xfs_log_release_iclog() and as a result the locked error state check
> was lost.
> 
> The lockless check still exists, but this doesn't account for the
> possibility of a race with a shutdown being performed by another
> task causing the iclog state to change while the original task waits
> on ->l_icloglock. This has reproduced very rarely via generic/475
> and manifests as an assert failure in __xlog_state_release_iclog()
> due to an unexpected iclog state.
> 
> Restore the locked error state check in xlog_state_release_iclog()
> to ensure that an iclog state update via shutdown doesn't race with
> the iclog release state processing code.
> 
> Fixes: df732b29c807 ("xfs: call xlog_state_release_iclog with l_icloglock held")
> Reported-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
