Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2BCC43460
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50AE0613AC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbhEUIMX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 04:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236509AbhEUIME (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 May 2021 04:12:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8CBC06138D;
        Fri, 21 May 2021 01:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fZ/jWIKSEWtntePVFs21EayQKXnDoRn/Q+qYoZzou6w=; b=Hp92nLU3bDSS8fBVjy2ydqiICn
        Jhmvrv3MgvApmG79rCemNwAmR5Is1XdNcdxpQgI0JD577qgWl03gr7bIB6zye5aK09F7H+gMSyvzW
        bOyYoJYGCSFdJNwm2xEMwr8csAFBmwvfKiGWjcBhTQE4K9DLVszC+0HHD37ZkwTVVuYZfhh7/q+Hr
        dF/k/JPsKLTuAE0hk58ecXUOOCqIg57pi2dLhrf1p7+a1NAsp1s634hjlD5W3zI0f3TNggxmO9hlN
        lb2OqSZ8xxRNzhU81C25XBX3bR+SiXT1fJw/+mfiRIf2dJ3HadXFuP737HgioBjukpj2iWY1NqYuJ
        IIVG74FQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lk0Cc-00Glo4-9L; Fri, 21 May 2021 08:08:27 +0000
Date:   Fri, 21 May 2021 09:08:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 6/6] aio-dio-append-write-fallocate-race: fix directio
 buffer alignment bugs
Message-ID: <YKdqbnIto8nDsQ07@infradead.org>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
 <162146863667.2500122.9363433713420860828.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162146863667.2500122.9363433713420860828.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 04:57:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This program fails on filesystems where the stat() block size isn't a
> strict power of two because it foolishly feeds that to posix_memalign to
> allocate an aligned memory buffer for directio.  posix_memalign requires
> the alignment value to be a power of two, so generic/586 fails.
> 
> The system page size generally works well for directio buffers, so use
> that instead.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
