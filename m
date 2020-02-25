Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02BD9C35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCE2E20658
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:41:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FjA/IL3l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgBYRlJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:41:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43872 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730389AbgBYRlJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:41:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Hc8sq2F4MTtpSaWFdlDQKN7IwbUzOZIkayNMYmKNzbU=; b=FjA/IL3l5Y8jFSVAMMzdUmpiQL
        h8V5dBIl92rttXW3ZOvTliH1P7DquoM/FFDYKpZD8UgWm0XRm8h+QkWE0V71sbYZGRgQkHqM5n0EI
        /sGGJQ2kzyzxnLuAyNkxMmJ31zn5ZNvNn1M15JG5p1a/cvBtF4qyoDRJXpM68EzX20qQpf0PqBEtS
        3FDiqxs2bjgboyWFJEcXyrCHii30UqsMtbgnSzQDgi/6iPfBeIRndrEF85Qkv2olDI7QqXuB6vbkO
        RPBFhqz2kBiadkAnCMLWUw04/jRvzJgrJSVVlM6aN8DvICkrysN9H7eTSU5kLFOjjBzN4C9S621ZN
        tijwY6Vg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eCi-0003Zh-FJ; Tue, 25 Feb 2020 17:41:08 +0000
Date:   Tue, 25 Feb 2020 09:41:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] libxfs: clean up libxfs_destroy
Message-ID: <20200225174108.GF20570@infradead.org>
References: <158258947401.451256.14269201133311837600.stgit@magnolia>
 <158258948621.451256.5275982330161893261.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258948621.451256.5275982330161893261.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:11:26PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It's weird that libxfs_init opens the three devices passed in via the
> libxfs_xinit structure but libxfs_destroy doesn't actually close them.
> Fix this inconsistency and remove all the open-coded device closing.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
