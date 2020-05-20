Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EFFC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 17:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10162075F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 17:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gQv+isrt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgETRhO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 13:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgETRhO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 13:37:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A59C061A0E
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 10:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oxFwJ4j+23thUy9SP+GIxgOXuoq8iZuqMYv2wBGwWFY=; b=gQv+isrtBMEiEYgFx1IFOSRjyZ
        Q6BRcv1shZ8LsKvhmzWQINgeZ7+A7vdksGKjKtpMzwDhpk37i+UhHhgVe5fAoAIUbhypDJan3DQXC
        NMxPZ9iPcedtnjbwsTCgGOoH6BkGSoAsLiRgJ0ynhKA2Y0yqXygNb/bfqC/eQNVK1cr58lfNo9b7a
        2GDh2+XWZ2/JslAAS/Kudx2uRlVfaQSYCKs/PY6bBhw3RQiN8QuesqruT4IR2OTz0J8kKX69JxnVZ
        3u5w6cqrIeUpMXf3snaQDjeCry3hhr8y458nbzovtrU7hjr06zH/ufiVtazMKMqg339oXyXpaiez6
        2JHBKePw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbSeX-0003Vk-Hi; Wed, 20 May 2020 17:37:13 +0000
Date:   Wed, 20 May 2020 10:37:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: replace libreadline with libedit
Message-ID: <20200520173713.GC1713@infradead.org>
References: <158984953155.623441.15225705949586714685.stgit@magnolia>
 <158984955088.623441.1505969186471077833.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158984955088.623441.1505969186471077833.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 05:52:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that upstream has dropped libreadline support entirely, switch the
> debian package over to libedit.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Do we need to resync with the real Debian packaging?  That has switched
over quite a while ago.
