Return-Path: <SRS0=aFxQ=X2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 151E0C352AA
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 10:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA20621920
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 10:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbfJAKaT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Oct 2019 06:30:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730455AbfJAKaT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Oct 2019 06:30:19 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0DDA8300CB28;
        Tue,  1 Oct 2019 10:30:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABAD060C5D;
        Tue,  1 Oct 2019 10:30:18 +0000 (UTC)
Date:   Tue, 1 Oct 2019 06:30:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 01/11] xfs: track active state of allocation btree
 cursors
Message-ID: <20191001103016.GA61457@bfoster>
References: <20190927171802.45582-1-bfoster@redhat.com>
 <20190927171802.45582-2-bfoster@redhat.com>
 <20190930081138.GA2999@infradead.org>
 <20190930121701.GA57295@bfoster>
 <20191001063634.GA4990@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001063634.GA4990@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 01 Oct 2019 10:30:19 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 30, 2019 at 11:36:34PM -0700, Christoph Hellwig wrote:
> On Mon, Sep 30, 2019 at 08:17:01AM -0400, Brian Foster wrote:
> > The active flag was in the allocation cursor originally and was moved to
> > the private portion of the btree cursor simply because IIRC that's where
> > you suggested to put it.
> 
> My memory starts fading, but IIRC you had a separate containing
> structure and I asked to move it into xfs_btree_cur itself.
> 

Right, that's the "allocation cursor" structure. I'd eventually like to
fold that into or with the existing allocation arg structure, but that's
something for after the other allocation modes are converted.

Anyways.. this was all buried in a single patch as well that makes it
harder to dig out. For reference, the original feedback was here:

https://marc.info/?l=linux-xfs&m=155750947225047&w=2

> > FWIW, that seems like the appropriate place to
> > me because 1.) as of right now I don't have any other use case in mind
> > outside of allocbt cursors 2.) flag state is similarly managed in the
> > allocation btree helpers and 3.) the flag is not necessarily used as a
> > generic btree cursor state (it is more accurately a superset of the
> > generic btree state where the allocation algorithm can also make higher
> > level changes). The latter bit is why it was originally put in the
> > allocation tracking structure, FWIW.
> 
> Ok, sounds fine with me for now.  I just feels like doing it in the
> generic code would actually be simpler than updating all the wrappers.

Ok. It's not quite as simple due to the semantics described above. I'm
not totally convinced the generic "active" state would exactly match the
semantics used by the block allocation code. I'd hate to bury it in
there as is and have it end up being a landmine or wart if it is not
ever reused outside of extent allocation (or replaced with something
cleaner, ideally).

Brian
