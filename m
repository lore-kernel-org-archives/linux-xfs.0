Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03D3C761A6
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83E262070B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q12+Apy7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgBQNdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:33:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46086 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgBQNdP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:33:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ds9xQ8Ur+VRiyFLCHd5aDwMoHqCw+yV3Hc7SDOJmdfI=; b=q12+Apy7K5fd3UBGd56LWq6Cj7
        0BZimJh0cLpQWNDvZn9iA5Rzg0l3eLZxWP6ZLu1gb8gkvjDQxT2gdeINEzwRe0ftRRK5+4Q+y5n+i
        MQCiTpYdwe9uFPUpiRzZdEWSlNB2oBNJgSMC7A8COvNN4cyNAPMxPnQda71PMLQ66BFTj3jiUvrDc
        /M3PL4lJOKZToII9ixNvR+URrAfg1RBt3NchbjdZ7GysyG0y4cYJ9ystm+eQltWRY3/7WbGHjBj0w
        aQxmUoRZoVoRIfkkmFMNlQVceExE7Pc2QKyQAVFf7lbcxZKFr6kcyA6QuKi7CwY0Z0DfhOobPCg9e
        zhtstIEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gWQ-0000Pt-KP; Mon, 17 Feb 2020 13:33:14 +0000
Date:   Mon, 17 Feb 2020 05:33:14 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: fix iclog release error check race with shutdown
Message-ID: <20200217133314.GA31012@infradead.org>
References: <20200214181528.24046-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214181528.24046-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 14, 2020 at 01:15:28PM -0500, Brian Foster wrote:
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
> Reported-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f6006d94a581..f38fc492a14d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -611,6 +611,10 @@ xfs_log_release_iclog(
>  	}
>  
>  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> +		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> +			spin_unlock(&log->l_icloglock);
> +			return -EIO;
> +		}

So the check just above also shuts the file system down.  Any reason to
do that in one case and not the other?
