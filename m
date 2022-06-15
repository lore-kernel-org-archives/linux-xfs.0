Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDCFCCA480
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 13:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347378AbiFONMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 09:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiFONMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 09:12:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B528A24581;
        Wed, 15 Jun 2022 06:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FHOVdTg6NKnoEjJkArBOs1GnjsYN72M8SV5hUzpqtrM=; b=2XD3XMBMNnkMfNTbWofuI16L1y
        ibePJHi5dvh74MnJpzG/u7S4aY3orURjcbZttxdDGEus2CPnup5s5KOGh1tezdDut2pv1x+NGhPuQ
        X+3q7hkUy7zDSvVK2F4TppQrdIPlffoCN0T5tf11PK7u3/D8dclNIN8z91X7ihwHu8RuY3cc7wDnT
        d43ZIT49HPtGxdcjxsIboQvMIdqXM3LrRBtzzeyXMjMyX991d/c4srAjBj5WAi/1DhB92Ucde0Xdx
        naUR1vNfJj/V/p7q3PNpvUcCQ6o6WE2NrGm2l1MnAHXJhZcTWN19ICW2w0WfNwRcn01j35hhvNYIv
        H6BuzbSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1SoW-00EdqR-Tk; Wed, 15 Jun 2022 13:12:04 +0000
Date:   Wed, 15 Jun 2022 06:12:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-api@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH v2 1/7] statx: add I/O alignment information
Message-ID: <YqnapOLvHDmX/3py@infradead.org>
References: <20220518235011.153058-1-ebiggers@kernel.org>
 <20220518235011.153058-2-ebiggers@kernel.org>
 <YobNXbYnhBiqniTH@magnolia>
 <20220520032739.GB1098723@dread.disaster.area>
 <YqgbuDbdH2OLcbC7@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqgbuDbdH2OLcbC7@sol.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 13, 2022 at 10:25:12PM -0700, Eric Biggers wrote:
> While working on the man-pages update, I'm having second thoughts about the
> stx_offset_align_optimal field.  Does any filesystem other than XFS actually
> want stx_offset_align_optimal, when st[x]_blksize already exists?  Many network
> filesystems, as well as tmpfs when hugepages are enabled, already report large
> (megabytes) sizes in st[x]_blksize.  And all documentation I looked at (man
> pages for Linux, POSIX, FreeBSD, NetBSD, macOS) documents st_blksize as
> something like "the preferred blocksize for efficient I/O".  It's never
> documented as being limited to PAGE_SIZE, which makes sense because it's not.

Yes.  While st_blksize is utterly misnamed, it has always aways been
the optimal I/O size.

> Perhaps for now we should just add STATX_DIOALIGN instead of STATX_IOALIGN,
> leaving out the stx_offset_align_optimal field?  What do people think?

Yes, this sounds like a good plan.
