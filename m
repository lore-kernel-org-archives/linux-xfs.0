Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B6A4C388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B273A20809
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:33:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IsLNNPBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgKJSdp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJSdp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:33:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AFBC0613D1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 10:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ED5cHhw8docYWnozG+yimCe7WZcIRnIMwVE7jdas8mQ=; b=IsLNNPBWp58URIRlliAAxe7NOy
        yXv5FueWVJx8cs/1FKm+qv1yD2Oh2oht8CMa5kzyyrifYNJ4Z1f2kB3dnfnFBRopBDVjjEOJjHcDl
        S356B0VwfkbevzXmwqua622U+rWm7ZvVsC2Sl03cb/02Z1Tirl6G2d37YgBiVM0K4Dhm1YQ8JkEGA
        sh2TFD1nsw4Ds7rfut4q3WO9raj88Y/w0G8tAdM+2bCCNmcx1/a7UxeN3Rvg5iHKGCKwYcPZmpVxV
        hSblVqCa0xNK7yVrhfQoCFgVNsdmeiuXqUH9ZeIkYWvjxAYjQjZPPBjkD8/d7m0nvkh06Z9KUfjnu
        5y6oxt3w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcYSd-0002Sx-BL; Tue, 10 Nov 2020 18:33:43 +0000
Date:   Tue, 10 Nov 2020 18:33:43 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: fix flags argument to rmap lookup when
 converting shared file rmaps
Message-ID: <20201110183343.GA9418@infradead.org>
References: <160494582942.772693.12774142799511044233.stgit@magnolia>
 <160494583579.772693.11055963967780181272.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160494583579.772693.11055963967780181272.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 09, 2020 at 10:17:15AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Pass the same oldext argument (which contains the existing rmapping's
> unwritten state) to xfs_rmap_lookup_le_range at the start of
> xfs_rmap_convert_shared.  At this point in the code, flags is zero,
> which means that we perform lookups using the wrong key.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
