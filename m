Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E20C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66C9264E4F
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhBIJem (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhBIJcd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:32:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6382C061786
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gJxJ7AXYDMMn2ktc7td9ED6dI1WgxEzwL15K5M3fWy0=; b=Tkqv7ZNsQLKpw3e7222T7in3dr
        TFL0ETbnvBuTovsnjNlEB95/ofAUwbSafQFBO1oBVQe7QIG8H9yEQM9ej/c7ulWJ2GnMq54G4fmo9
        mzsKww9rKlWhVt2Ki46pa2GL145Dx/usf6Aus8ZsS/UjkwdmLPqNT1242ywPM+k1Ro7QFXeuoHTPz
        Jhlt843CMDI38u5msyn53Qctd23v0gqKfwp+4P7n7PSLVuSLLxBULgi9W142EPyUUzEXv/2QZtYRB
        j2+spsqa5X2mgGfjCbBzQmzUeC81MjrOROCuQ2bdnIe4EwxPGGZO8S7I8gHoYltGB27pWFl9hJHlP
        p4zj/v0A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9PN6-007Eoj-IV; Tue, 09 Feb 2021 09:31:49 +0000
Date:   Tue, 9 Feb 2021 09:31:48 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        chandanrlinux@gmail.com, Chaitanya.Kulkarni@wdc.com
Subject: Re: [PATCH 6/6] xfs_scrub: fix weirdness in directory name check code
Message-ID: <20210209093148.GR1718132@infradead.org>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
 <161284390991.3058224.12921304382202456726.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284390991.3058224.12921304382202456726.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:11:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Remove the redundant second check of fd and ISDIR in check_inode_names,
> and rework the comment to describe why we can't run phase 5 if we found
> other corruptions in the filesystem.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
