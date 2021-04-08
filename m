Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4B5C433ED
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 12:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B8EE61175
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 12:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhDHMUO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 08:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhDHMUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Apr 2021 08:20:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF053C061760
        for <linux-xfs@vger.kernel.org>; Thu,  8 Apr 2021 05:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qYxFe/hVRct+xePBS3fro/ZWRJRcn6wil8848yJ4xHA=; b=e3MNM/ZoZnsdxpLfR3fngmIezv
        uQrBfJ5hZi7Uug0ayfMvGgcWEY5++rq0BTh1Osmki1lU+0FiWZU/QQr0tCFcIsiX6QeYrRRK+rchN
        YJ1bdfQkjgQkmpBnOf8PqvVbiIVf9pGKfa+Gds+mRMNSfUj3yQGybw6EpwjudJ5wliWNVOJyVG/hp
        0zDKClvCqBg71Qp/3rw9O9JoFD2dHElU1IIfPQH+yO2YvbGyh3hQn/2Ka/+yENJKP5zKTxcsdpHvW
        wkrF5n2xnpRHqh5ZcqEC5bds3AlGzLEwOZ9N5zwWWVrS2HZlkI1c6O0QJiHZdTSPo1cRrAVs0pzML
        MpWQOq4g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lUTdF-00G9OJ-3N; Thu, 08 Apr 2021 12:19:40 +0000
Date:   Thu, 8 Apr 2021 13:19:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: get rid of the ip parameter to xchk_setup_*
Message-ID: <20210408121933.GB3848544@infradead.org>
References: <20210408010114.GT3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408010114.GT3957620@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 07, 2021 at 06:01:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that the scrub context stores a pointer to the file that was used to
> invoke the scrub call, the struct xfs_inode pointer that we passed to
> all the setup functions is no longer necessary.  This is only ever used
> if the caller wants us to scrub the metadata of the open file.

Even before we had the xfs_inode in struct xfs_scrub, so why detour
through struct file?
