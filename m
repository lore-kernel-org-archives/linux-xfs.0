Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DD3C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8BB12073A
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:58:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FUZD01r4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgGUO64 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728342AbgGUO64 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 10:58:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CEDC061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 07:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wE6H6Qo0Za4LJISgUhVJoXCbhsGfc9eZLlJMtE68Cc8=; b=FUZD01r4f0js7ErG3ubLAOT7Cx
        Ko6XHI8d/X6TSdgd47spXyOyvQT/kv65ui7+o13NTe0X/EHD+BHYKxazJyUiRF8myIp62kgNyomg5
        hp/ffIq3Lyjgh8DFoFUuRFf5+vDody+fgklTzsSf19tzoCP9bjptFu09YbnINV8PZrUxkUXqzR2yX
        R/CREJZXWXNh+FevhPd/noNMJCy0cz0XjT/T/TXDVEOgVJF98dWJ9zbMIlqWsSMMs3jEesEb7WBGg
        ybCwsacYtnCHQAwX9cNnZd4tSBccLPKB8O5hH4IbNyv7hQdK7T528CQi0gd6yBFiGtJrYMCT/yilL
        dO3Gkr6w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxtjJ-0001uc-QT; Tue, 21 Jul 2020 14:58:53 +0000
Date:   Tue, 21 Jul 2020 15:58:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 10/11] xfs: improve ondisk dquot flags checking
Message-ID: <20200721145853.GJ6208@infradead.org>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488198306.3813063.16348101518917273554.stgit@magnolia>
 <20200717011255.GM3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717011255.GM3151642@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 16, 2020 at 06:12:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create an XFS_DQTYPE_ANY mask for ondisk dquots flags, and use that to
> ensure that we never accept any garbage flags when we're loading dquots.
> While we're at it, restructure the quota type flag checking to use the
> proper masking.
> 
> Note that I plan to add y2038 support soon, which will require a new
> xfs_dqtype_t flag for extended timestamp support, hence all the work to
> make the type masking work correctly.

I'd have delayed this until we actually add a the bigtime flag.  But
I don't want you to respin once again, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
