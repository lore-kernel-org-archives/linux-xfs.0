Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C026FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 733B864EB9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBIJUw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhBIJQY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:16:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1693C061788
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LUaBSs0Krz4zTy59jKUuPtQR4MXLd4zHjihTWau1f6I=; b=dRf+xLD7p5VVA/PsVcvKruvqKY
        p8ZDgxR4TmhG1qk0zukQJHQkB3nrsJnRB9E37lodQ+MAHzQrX+KFBz7R0g4mzN2MrSTG+Fq3pjJoG
        AFaLYS/5MxZcZyWOy6wgEqH8YWvcw0M6EYItkxDvGN/0VqlIkG+S53yQtk8oFsmGaa1qlkDk3uelV
        KlMv2/0dMyKCXNQnPp8sUmxUEeuPYjlnNyejBe12tORsOuYhzDOK62qiZazZB10zY/++iHpGKadGd
        vyNTTohVQYSYQcMR1DmrQNyDj/F1esMZSZ0v1soEnFhgqUisOFAsPB/5lUBhmuRFBOvHR9bHc49pt
        raqank7A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9P7O-007DZo-O8; Tue, 09 Feb 2021 09:15:35 +0000
Date:   Tue, 9 Feb 2021 09:15:34 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 08/10] xfs_repair: allow setting the needsrepair flag
Message-ID: <20210209091534.GH1718132@infradead.org>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284384955.3057868.8076509276356847362.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284384955.3057868.8076509276356847362.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
> program start and (presumably) clear it by the end of the run.  This
> code isn't terribly useful to users; it's mainly here so that fstests
> can exercise the functionality.

What does the quietly above mean?

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
