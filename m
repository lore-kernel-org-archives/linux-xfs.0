Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE582C1975A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 18:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4B7D20714
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 18:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SmWPXSRi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgCQSg5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 14:36:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45758 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQSg5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 14:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ogVbmjJetm22B1ys5az+3f+zUHNo8cEwhBSB3FJi2zc=; b=SmWPXSRiE3ksIkwpQyeijNb8WQ
        HA5BNKVkhDEWThMDVyX98aC0IWr9sB2VgB2nVTwWXkdXTGsLoZpw8xBBteXWeHpAGOWnnoatDM49R
        z8/Qn8/AAtlLcRuXA7p4Zr/nPi/Okcys5lUT4ul7MlSsUeN/N3oGB6oTcoGhmcjCXCdcvW/3klDJ2
        0HN6y9aZCAaoR4jwUWkkwWdEcP2zUANRoF2QWyuP26m9KkYXX/eqTzaFcnhB+hfiQWGrjxeJnXNf9
        Z3J4nBENrWPc4TdRDyqHOLTZZWq2M6VBz+QdejzkJz+d8/qagk4M/qzgL0+osJ4AXZmogJbFL6K+M
        GJ8b8FVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEH5E-0001GL-SH; Tue, 17 Mar 2020 18:36:56 +0000
Date:   Tue, 17 Mar 2020 11:36:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: factor out quotaoff intent AIL removal and
 memory free
Message-ID: <20200317183656.GC23580@infradead.org>
References: <20200316170032.19552-1-bfoster@redhat.com>
 <20200316170032.19552-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316170032.19552-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 01:00:31PM -0400, Brian Foster wrote:
> AIL removal of the quotaoff start intent and free of both intents is
> hardcoded to the ->iop_committed() handler of the end intent. Factor
> out the start intent handling code so it can be used in a future
> patch to properly handle quotaoff errors. Use xfs_trans_ail_remove()
> instead of the _delete() variant to acquire the AIL lock and also
> handle cases where an intent might not reside in the AIL at the
> time of a failure.

xfs_trans_ail_delete alsmost seems nicer here rather than duplicating
the most be in ail except for abort/shutdown.  But either way it looks
correct, so if you prefer it this way:

Reviewed-by: Christoph Hellwig <hch@lst.de>
