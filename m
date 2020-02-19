Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8037AC34022
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 21:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 450472465D
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 21:21:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HjLqiStv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgBSVV2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 16:21:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43372 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgBSVV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 16:21:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JnqM+ZPE7uR/lo/BO9czkfVkyqqTIxUDl4AMPftO+wM=; b=HjLqiStvJghxbJ+D0wc/HQwd9d
        eEUF7MXqDwEggJIqWSQXnpEgl//DkWEmO7SdiIF1McECFzAWEAHnCmpvXXHzvJFbx3/WndxtgnZ5h
        1DXkXXPWzSDLYef4IX8WS6ie8jWFqyEjUHPgJYCDvTNwEkow004wG8cB2lB5ycs18biP2QsZo4goY
        trDAmpR2E7xW1s3V3nVzMONQzLb40ku/HwznWAhLMMxFHDNQXa07EWYIZQF8DLS6+JggPZUXx6j9q
        LbvDZt1KG/RAvZ1O/NIK62IOwQf5Ly91jwLr8aaMImZgXksfGvJg6sjizw/KUcPzupN8++xGdi0jf
        FehDa/Yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4Wme-0000DM-6Z; Wed, 19 Feb 2020 21:21:28 +0000
Date:   Wed, 19 Feb 2020 13:21:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200219212128.GA634@infradead.org>
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

Btw, from code inspection I think we also need the same check after
taking the lock in xlog_state_release_iclog.
