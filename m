Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29502C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Apr 2021 16:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00DC4613B1
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Apr 2021 16:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhDMQyN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 12:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbhDMQyM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Apr 2021 12:54:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5437C061574;
        Tue, 13 Apr 2021 09:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=R2gmFdFspE+tF0exraA8LE3+lMa5ZYBq+Y6lFDBpWJk=; b=BeKxJ/3HQ3Iwt6gpSmW4wfxwRA
        g2hm1E3fLyZhQkV+C/W4Ymq6QmoN0ab+XNeBS2iCUtvec8H9PU0fY8Xg20xgfgR+Z1s7DEF/oitkm
        cv8gy2B0CRzsSqqRVZSqJPuE60FaYwLoh5xYTQvfAlIhORLlXUohfH53aw5bgxQlw3vPl5Ziusnaz
        33Z31gOjkz1biB3DpKU03+iGYiDwX8jRxfkZks7KF1bgyF+5E8/1IP59t+wPz9lwwXrGZtGLUg1J1
        f1SXuD8mh8SuStEmVKRLUZvXllCF5xD4D4jWCYSH/8tsfnCWX9fVvqpyLkitFIU0f8JkxXSLbPM6o
        GHpbYXXA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWMHp-0060VT-Uq; Tue, 13 Apr 2021 16:53:21 +0000
Date:   Tue, 13 Apr 2021 17:53:13 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4][next] xfs: Replace one-element arrays with
 flexible-array members
Message-ID: <20210413165313.GA1430582@infradead.org>
References: <20210412135611.GA183224@embeddedor>
 <20210412152906.GA1075717@infradead.org>
 <20210412154808.GA1670408@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412154808.GA1670408@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 12, 2021 at 08:48:08AM -0700, Darrick J. Wong wrote:
> A couple of revisions ago I specifically asked Gustavo to create these
> 'silly' sizeof helpers to clean up...
> 
> > > -					(sizeof(struct xfs_efd_log_item) +
> > > -					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
> > > -					sizeof(struct xfs_extent)),
> > > -					0, 0, NULL);
> > > +					 struct_size((struct xfs_efd_log_item *)0,
> > > +					 efd_format.efd_extents,
> > > +					 XFS_EFD_MAX_FAST_EXTENTS),
> 
> ...these even uglier multiline statements.  I was also going to ask for
> these kmem cache users to get cleaned up.  I'd much rather look at:
> 
> 	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
> 				sizeof_xfs_efi(XFS_EFI_MAX_FAST_EXTENTS), 0);
> 	if (!xfs_efi_zone)
> 		goto the_drop_zone;
> 
> even if it means another static inline.

Which doesn't really work with struct_size or rather leads to a mess
like the above as struct_size really wants a variable and not just a
type.  Making it really nasty for both allocations and creating slab
caches.  I tried to find a workaround for that, but that makes the
compiler unhappy based its inlining heuristics.

Anyway, a lot of the helpers are pretty silly as they duplicate stuff
without cleaning up the underlying mess.  I tried to sort much of this
out here, still WIP:

http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-array-size
