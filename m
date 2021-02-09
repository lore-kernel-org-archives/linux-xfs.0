Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CFBC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12D3D64EBA
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhBIJRi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhBIJOe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:14:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9869BC0617A7
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v37Eh/hUdy7p0aAfBkj6MrfTDHhQ8zXmk8o/sETvHMk=; b=UdROyrdM6gGfvhGc0dTEHJJxVV
        i7ZDmAaU0tpvnCpho4WaU7sCmnxFBTl1KsLvG4WI2/Gta2hVZSOQG5KOu5Aa4Nga02B0Kh/WiL9Na
        2zl91zi7dMPAy3P5MqjWEhNKkQkjanufgkAmJFLD17t1WjqC/9Og4m7JeSpPj2p8cz1wWhCZzRhAD
        PfHxq4YgPmX3Ben3nWRo3j2NrapWRZBnx+aYIHfdCuC6FG07crdJ8GtcXJAHzWQwCW+6eLxLiNh3x
        Qepq4Qk+s6vWhR9z6n2naX03JN1XPQ8veuOSIE23whFyEiGwRy+T6cyUk1mlHDncpT8OaPy2X1PG4
        7UPHXZ5g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9P5U-007DPp-Gb; Tue, 09 Feb 2021 09:13:36 +0000
Date:   Tue, 9 Feb 2021 09:13:36 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 07/10] xfs_repair: set NEEDSREPAIR when we deliberately
 corrupt directories
Message-ID: <20210209091336.GG1718132@infradead.org>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284384405.3057868.8114203697655713495.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284384405.3057868.8114203697655713495.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a few places in xfs_repair's directory checking code where we
> deliberately corrupt a directory entry as a sentinel to trigger a
> correction in later repair phase.  In the mean time, the filesystem is
> inconsistent, so set the needsrepair flag to force a re-run of repair if
> the system goes down.

I guess this is an improvement over what we have no, but I suspect an
in-core side band way to notify the later phases would be much better
than these corrupt sentinel values..
