Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB609C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F080206DC
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:55:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XW7lfS9S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgIQHz4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgIQHzy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:55:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA5BC06174A;
        Thu, 17 Sep 2020 00:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lvy1PYVCionASrNiB6YyDhjIXDJTO0gXIeIzrlBQY6A=; b=XW7lfS9S0ey/WFKLZ0COdlcgj8
        98g0MWRx+AbK3sxWjrnGfL5cMqGUn8qY3Z87oYW73Fcn64qKHEK4QktZ1m8m2q91pf+udPKWsgTyL
        oaAfSgkVtnpwNq1ciSSi2W8aS5wEughPjtm6SJu+FiABFnDDf2WQhxBSS7G4P9dO6ecXwOk6AWoUQ
        1H64s+nNyn/pwYHtB5Fxqhd5q4MIep4HDExJUrMsWpRfOlxQ1zUC6K9Zpjl5T1AxAXLuCrb5v9ms4
        CcxD32HOvWcjHLUzqEBP3IsejXruDuoE0yNoVnjDG+644twrV8pCnFSJfGgQulxNncl1DJVmKqOgK
        ybkMLWgA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIolj-0007LB-DF; Thu, 17 Sep 2020 07:55:51 +0000
Date:   Thu, 17 Sep 2020 08:55:51 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 10/24] xfs: add a _require_xfs_copy helper
Message-ID: <20200917075551.GJ26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013423963.2923511.3348023490177095472.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013423963.2923511.3348023490177095472.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:43:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a _require helper so that tests can ensure that they're running in
> the correct environment for xfs_copy to work (no external devices).

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
