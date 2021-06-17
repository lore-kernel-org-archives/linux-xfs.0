Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C80AC48BE5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DACEE61209
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhFQINZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhFQINZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 04:13:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A21FC061574
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 01:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FsfzYc0I8pATjostZ3IZsMegUXDHfzsXhGAMsKbrz/M=; b=KfpOn1W5jr8c38ZP2lxEk+Lbtv
        wrBt1uWzzKaIC35KcbfSw7N2YZQ6RcEtFoA2qpWo9/Xs0emlUBx9X3G0HHrLZdKiYHgM+46eLOPLn
        1+NZLXhq6+erpgz15lP4evQvajZFoDAp+XcJafx7lkuINlbcgXc8w05E3vBKYNDsK3kGtd2FhHIvt
        H19MT/0VAnlaG2Lzl2wl/gL7yqNL9vdO5nqWBJv2HC9wrTuXDYoZMQIhF8rSB/K6XLkM9lp4cRurA
        Fgn8kxaVqL6/GZfNJ9p26eAny3HE+0rQuUos394qJTnGPhWo4swgmlk5iYIrycFestQFzvwFIE8nc
        cfLZLa7w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltn7D-008uJ0-2j; Thu, 17 Jun 2021 08:11:09 +0000
Date:   Thu, 17 Jun 2021 09:11:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: print name of function causing fs shutdown
 instead of hex pointer
Message-ID: <YMsDmxk6nKehJP0q@infradead.org>
References: <162388772484.3427063.6225456710511333443.stgit@locust>
 <162388773604.3427063.17701184250204042441.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162388773604.3427063.17701184250204042441.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 04:55:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In xfs_do_force_shutdown, print the symbolic name of the function that
> called us to shut down the filesystem instead of a raw hex pointer.
> This makes debugging a lot easier:
> 
> XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> 	fs/xfs/xfs_log.c. Return address = ffffffffa038bc38
> 
> becomes:
> 
> XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> 	fs/xfs/xfs_log.c. Return address = xfs_trans_mod_sb+0x25

Symbolic names looks very useful here.  But can we take a step back
to make this whole printk much more useful, something like:

XFS (sda): Forced shutdown (log I/O error) at fs/xfs/xfs_trans.c:385 (xfs_trans_mod_sb+0x25).

That is print the reason as a string, and mke the whole thing less
verbose and more readable.
