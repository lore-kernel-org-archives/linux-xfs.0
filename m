Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB62C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C17235F8
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgLGOQ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgLGOQ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:16:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD55C0613D0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Dec 2020 06:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WmXCOapI+ML3w8abDXX/MOpn7oelcZxK5m9dhur3qmU=; b=m5zyyKLOPcyGCHdGt7pTWzqsdm
        u+Fs4ChuLDmZqEXEtE6MrlcEOAl4nMuQISfCv2s0b6Cbu6RTuI9hc9UYrpDniwNlloF7FdVpWUMeQ
        Cn1fJVWJz/GNQF4qHecaLTfbjqLR3sKNjrGHV8sFhEpeWyL9T/jxKkYx+ZXD533wh1RS41K6t2qs0
        55PqE8+tYMKuSjesLDNf/2jrhStBm+CHHi2bDV5ry4+AYXnLvSrZ+qn6GrVL0EOM7Ofkgi0HqC2ZI
        4VuIm5PWQsrCl6R43Eh9OLYrYgLauKBXerNb//ArUMUahf2JLVwQlTOpJHxjFJmVIvxgEn2N5V/VE
        F2Sg5Hjw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmHIn-0002Pu-Gw; Mon, 07 Dec 2020 14:15:45 +0000
Date:   Mon, 7 Dec 2020 14:15:45 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: refactor data device extent validation
Message-ID: <20201207141545.GA8637@infradead.org>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
 <160729625702.1608297.4480089333393399990.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729625702.1608297.4480089333393399990.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:10:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor all the open-coded validation of non-static data device extents
> into a single helper.

looks good, but I think a little convenience wrapper that takes a
xfs_bmbt_irec * would also be really helpful.
