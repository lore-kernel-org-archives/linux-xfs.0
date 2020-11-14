Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9099EC5519F
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DAB422254
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tdi15oSp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgKNKkT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 05:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgKNKkT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 05:40:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A53AC0613D1
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 02:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9M9KgHFpkMcdW8DYXvv0IsJC7tOAh/cE6LgGsEIg480=; b=tdi15oSpz29s0VXRYeQn4exVga
        3/GIXiFTrZbXbH2nynZnrOqR7w93PYOOv/JAEclWxK8akHYhsPOESkR+blVvQC9zYpqCO64Aju8M7
        YAn6PqFF8xgocJkYYhS4CS64Yd3G5cY1hmGoIHQ48IPHK5PFWszDB5z3T0rR+QIXU2Oc6IkeD20l0
        vpD4jlqKL3lxMSvN+pnSjKIgaXp1BqMomES7883xz82Vmde3E9e9Ts6PvFQzaXmpWcAtJdIC+Togx
        iyeOoHq3uTztomFU0gtE8pqKO1NVnc2fkk8Rl8B0KBxnOQE0thxCnLyu5BLSgjhE/jljSg78MbnRr
        21JRo9+g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdsyf-00031L-OG; Sat, 14 Nov 2020 10:40:17 +0000
Date:   Sat, 14 Nov 2020 10:40:17 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/4] xfs: strengthen rmap record flags checking
Message-ID: <20201114104017.GB11074@infradead.org>
References: <160494585293.772802.13326482733013279072.stgit@magnolia>
 <160494587178.772802.7759758846362664950.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160494587178.772802.7759758846362664950.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 09, 2020 at 10:17:51AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We always know the correct state of the rmap record flags (attr, bmbt,
> unwritten) so check them by direct comparison.
> 
> Fixes: d852657ccfc0 ("xfs: cross-reference reverse-mapping btree")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
