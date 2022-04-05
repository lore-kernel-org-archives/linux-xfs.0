Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0464C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 02:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1850696AbiDFCzo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453370AbiDEP41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 11:56:27 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A74139AF3
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 08:00:31 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0FD2968AFE; Tue,  5 Apr 2022 17:00:27 +0200 (CEST)
Date:   Tue, 5 Apr 2022 17:00:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove a superflous hash lookup when
 inserting new buffers
Message-ID: <20220405150027.GB15992@lst.de>
References: <20220403120119.235457-1-hch@lst.de> <20220403120119.235457-4-hch@lst.de> <20220403230452.GP1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403230452.GP1544202@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 04, 2022 at 09:04:52AM +1000, Dave Chinner wrote:
> On Sun, Apr 03, 2022 at 02:01:17PM +0200, Christoph Hellwig wrote:
> > xfs_buf_get_map has a bit of a strange structure where the xfs_buf_find
> > helper is called twice before we actually insert a new buffer on a cache
> > miss.  Given that the rhashtable has an interface to insert a new entry
> > and return the found one on a conflict we can easily get rid of the
> > double lookup by using that.
> 
> We can do that without completely rewriting this code.

We could.  And I had something similar earlier.  But I actually thing
the structure of the code after this patch makes much more sense.  All
the logic for the fast path buffer lookup is clearly layed out in one
function, which then just calls a helper to perform the lookup.
The new scheme also is slightly less code overall.  Even more so once
the lockless lookup comes into play which requires different locking
and refcount increments.

> The return cases of this function end up being a bit of a mess. We can return:
> 
>  - error = 0 and a locked buffer in *bpp
>  - error = -EEXIST and an unlocked buffer in *bpp
>  - error != 0 and a modified *bpp pointer
>  - error != 0 and an unmodified *bpp pointer

The last two are the same  - the *bpp pointer simply is not valid on a
"real" error return.  So the return really is a tristate, similar
to many other places in xfs.
