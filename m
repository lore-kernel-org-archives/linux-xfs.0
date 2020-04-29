Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B928C83004
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 11:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 159D12087E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 11:52:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NcbxL1NY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD2LwO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 07:52:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35839 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726558AbgD2LwO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 07:52:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588161132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fWco3kRn+p45Bd0dagNOxtV/Tvaml3Fo1MT7kyXnwDI=;
        b=NcbxL1NYdFSLwj5CNx2wsP0bYrG8qEydj26Ok84/wNB0so2On2A3vs6qUK3objKDlToOkW
        MlARcHzsL83X+9TMIMIo9IlNw49MdCo/57i2Ms4WuJRPCXit0rT6YhWinNv0KZeA/tbWsi
        HkCtHLRvhEVWvldaOx4vkuW/4Ny+LOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-SFMPUl08PWeBj4eT3YomJA-1; Wed, 29 Apr 2020 07:52:08 -0400
X-MC-Unique: SFMPUl08PWeBj4eT3YomJA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0B1818A0760;
        Wed, 29 Apr 2020 11:52:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D78760BF4;
        Wed, 29 Apr 2020 11:52:07 +0000 (UTC)
Date:   Wed, 29 Apr 2020 07:52:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/19] xfs: refactor log recovery
Message-ID: <20200429115205.GB33986@bfoster>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <20200422161854.GB37352@bfoster>
 <20200428061208.GA18850@infradead.org>
 <20200428124342.GA10106@bfoster>
 <20200428223422.GL6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428223422.GL6742@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 28, 2020 at 03:34:22PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 28, 2020 at 08:43:42AM -0400, Brian Foster wrote:
> > On Mon, Apr 27, 2020 at 11:12:08PM -0700, Christoph Hellwig wrote:
> > > On Wed, Apr 22, 2020 at 12:18:54PM -0400, Brian Foster wrote:
> > > > - Transaction reorder
> > > > 
> > > > Virtualizing the transaction reorder across all several files/types
> > > > strikes me as overkill for several reasons. From a code standpoint,
> > > > we've created a new type enumeration and a couple fields (enum type and
> > > > a function) in a generic structure to essentially abstract out the
> > > > buffer handling into a function. The latter checks another couple of blf
> > > > flags, which appears to be the only real "type specific" logic in the
> > > > whole sequence. From a complexity standpoint, the reorder operation is a
> > > > fairly low level and internal recovery operation. We have this huge
> > > > comment just to explain exactly what's happening and why certain items
> > > > have to be ordered as such, or some treated like others, etc. TBH it's
> > > > not terribly clear even with that documentation, so I don't know that
> > > > splitting the associated mapping logic off into separate files is
> > > > helpful.
> > > 
> > > I actually very much like idea of moving any knowledge of the individual
> > > item types out of xfs_log_recovery.c.  In reply to the patch I've
> > > suggsted an idea how to kill the knowledge for all but the buffer and
> > > icreate items, which should make this a little more sensible.
> > > 
> > 
> > I mentioned to Darrick the other day briefly on IRC that I don't
> > fundamentally object to splitting up xfs_log_recover.c. I just think
> > this mechanical split out of the existing code includes too much of the
> > implementation details of recovery and perhaps abstracts a bit too much.
> > I find the general idea much more acceptable with preliminary cleanups
> > and a more simple interface.
> 
> It's cleaned up considerably with hch's cleanup patches 1-5 of 2. ;)
> 
> > > I actually think we should go further in one aspect - instead of having
> > > the item type to ops mapping in a single function in xfs_log_recovery.c
> > > we should have a table that the items can just add themselves to.
> > > 
> > 
> > That sounds reasonable, but that's more about abstraction mechanism than
> > defining the interface. I was more focused on simplifying the latter in
> > my previous comments.
> 
> <nod>
> 
> > > > - Readahead
> > > > 
> > > > We end up with readahead callouts for only the types that translate to
> > > > buffers (so buffers, inode, dquots), and then those callouts do some
> > > > type specific mapping (that is duplicated within the specific type
> > > > handers) and issue a readahead (which is duplicated across each ra_pass2
> > > > call). I wonder if this would be better abstracted by a ->bmap() like
> > > > call that simply maps the item to a [block,length] and returns a
> > > > non-zero length if the core recovery code should invoke readahead (after
> > > > checking for cancellation). It looks like the underlying implementation
> > > > of those bmap calls could be further factored into helpers that
> > > > translate from the raw record data into the type specific format
> > > > structures, and that could reduce duplication between the readahead
> > > > calls and the pass2 calls in a couple cases. (The more I think about,
> > > > the more I think we should introduce those kind of cleanups before
> > > > getting into the need for function pointers.)
> > > 
> > > That sounds more complicated what we have right now, and even more so
> > > with my little xlog_buf_readahead helper.  Yes, the methods will all
> > > just call xlog_buf_readahead, but they are trivial two-liners that are
> > > easy to understand.  Much easier than a complicated calling convention
> > > to pass the blkno, len and buf ops back.
> > > 
> > 
> > Ok. The above was just an idea to simplify things vs. duplicating
> > readahead code and recovery logic N times. I haven't seen your
> > idea/code, but if that problem is addressed with a helper vs. a
> > different interface then that seems just as reasonable to me.
> > 
> > > > - Recovery (pass1/pass2)
> > > > 
> > > > The core recovery bits seem more reasonable to factor out in general.
> > > > That said, we only have two pass1 callbacks (buffers and quotaoff). The
> > > > buffer callback does cancellation management and the quotaoff sets some
> > > > flags, so I wonder why those couldn't just remain as direct function
> > > > calls (even if we move the functions out of xfs_log_recover.c). There
> > > > are more callbacks for pass2 so the function pointers make a bit more
> > > > sense there, but at the same time it looks like the various intents are
> > > > further abstracted behind a single "intent type" pass2 call (which has a
> > > > hardcoded XLOG_REORDER_INODE_LIST reorder value and is about as clear as
> > > > mud in that context, getting to my earlier point).
> > > 
> > > Again I actually like the callouts, mostly because they make it pretty
> > > clear what is going on.  I also really like the fact that the recovery
> > > code is close to the code actually writing the log items.
> 
> Looking back at that, I realize that (provided nobody minds having
> function dispatch structures that are sort of sparse) there's no reason
> why we need to have separate xlog_recover_intent_type and
> xlog_recover_item_type structures.
> 

The sparseness doesn't bother me provided the underlying interfaces are
simple/generic enough to understand from the structure definition and
are broadly (if not universally) used. I'm still not convinced the
transaction reorder thing should be distributed at all, but I'll wait to
see what the next iteration looks like.

> > I find both the runtime logging and recovery code to be complex enough
> > individually that I prefer not to stuff them together, but there is
> > already precedent with dfops and such so that's not the biggest deal to
> > me if the interface is simplified (and hopefully amount of code
> > reduced).
> 
> I combined them largely on the observation that with the exception of
> buffers, log item recovery code is generally short and not worth
> creating even more files.  224 is enough.
> 

I like Christoph's idea of selectively separating out the particularly
large (i.e. buffers) bits.

Brian

> --D
> 
> > Brian
> > 
> 

