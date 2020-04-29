Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E375DC83003
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 11:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDAC22173E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 11:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SMGhxTpI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgD2LiQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 07:38:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60505 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726556AbgD2LiP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 07:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588160293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n1CHYZzGSOIw1LCeTul+IvXfp0docen1MnDIirSQlW0=;
        b=SMGhxTpIulgAUnhy8prWnc6uqO9w5GvyGEyXrU+r4eUuPa4heOaLGeU341nFuMm11BAMER
        Pck5gOzx4qxJXho+8JQnWmAYBVSykzxO+jyXA8pUTiYbfgg5yTZIDTFuVJf+rMnXet4BBa
        0mhE3Lu0Dj24HCGfDxuw0cTtIu2yXqg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-C0pDxgeuPSaCTxr9Dkanpw-1; Wed, 29 Apr 2020 07:38:09 -0400
X-MC-Unique: C0pDxgeuPSaCTxr9Dkanpw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 570BC804A43;
        Wed, 29 Apr 2020 11:38:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C206F5D71E;
        Wed, 29 Apr 2020 11:38:05 +0000 (UTC)
Date:   Wed, 29 Apr 2020 07:38:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: teach deferred op freezer to freeze and thaw
 inodes
Message-ID: <20200429113803.GA33986@bfoster>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752130655.2142108.9338576917893374360.stgit@magnolia>
 <20200425190137.GA16009@infradead.org>
 <20200427113752.GE4577@bfoster>
 <20200428221747.GH6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428221747.GH6742@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 28, 2020 at 03:17:47PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 27, 2020 at 07:37:52AM -0400, Brian Foster wrote:
> > On Sat, Apr 25, 2020 at 12:01:37PM -0700, Christoph Hellwig wrote:
> > > On Tue, Apr 21, 2020 at 07:08:26PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Make it so that the deferred operations freezer can save inode numbers
> > > > when we freeze the dfops chain, and turn them into pointers to incore
> > > > inodes when we thaw the dfops chain to finish them.  Next, add dfops
> > > > item freeze and thaw functions to the BUI/BUD items so that they can
> > > > take advantage of this new feature.  This fixes a UAF bug in the
> > > > deferred bunmapi code because xfs_bui_recover can schedule another BUI
> > > > to continue unmapping but drops the inode pointer immediately
> > > > afterwards.
> > > 
> > > I'm only looking over this the first time, but why can't we just keep
> > > inode reference around during reocvery instead of this fairly
> > > complicated scheme to save the ino and then look it up again?
> > > 
> > 
> > I'm also a little confused about the use after free in the first place.
> > Doesn't xfs_bui_recover() look up the inode itself, or is the issue that
> > xfs_bui_recover() is fine but we might get into
> > xfs_bmap_update_finish_item() sometime later on the same inode without
> > any reference?
> 
> The second.  In practice it doesn't seem to trigger on the existing
> code, but the combination of atomic extent swap + fsstress + shutdown
> testing was enough to push it over the edge once due to reclaim.
> 
> > If the latter, similarly to Christoph I wonder if we
> > really could/should grab a reference on the inode for the intent itself,
> > even though that might not be necessary outside of recovery.
> 
> Outside of recovery we don't have the UAF problem because there's always
> something (usually the VFS dentry cache, but sometimes an explicit iget)
> that hold a reference to the inode for the duration of the transaction
> and dfops processing.
> 

Right, that's what I figured.

> One could just hang on to all incore inodes until the end of recovery
> like Christoph says, but the downside of doing it that way is that now
> we require enough memory to maintain all that incore state vs. only
> needing enough for the incore inodes involved in a particular dfops
> chain.  That isn't a huge deal now, but I was looking ahead to atomic
> extent swaps.
> 

What I was thinking above was tying the reference to the lifetime of the
intents associated with the inode, not necessarily the full lifetime of
recovery. It's not immediately clear to me if that indirectly leads to a
similar chain of in-core inodes due to unusual ordering of dfops chains
during recovery; ISTM that would mean a deviation from the typical
runtime dfops ordering, but perhaps I'm missing something...

That aside, based on your description above it seems we currently rely
on this icache retention behavior for recovery anyways, otherwise we'd
hit this use after free and probably have user reports. That suggests to
me that holding a reference is a logical next step, at least as a bug
fix patch to provide a more practical solution for stable/distro
kernels. For example, if we just associated an iget()/iput() with the
assignment of the xfs_bmap_intent->bi_owner field (and the eventual free
of the intent structure), would that technically solve the inode use
after free problem?

BTW, I also wonder about the viability of changing ->bi_owner to an
xfs_ino_t instead of a direct pointer, but that might be more
involved than just adding a reference to the existing scheme...

Brian

> (And, yeah, I should put that series on the list now...)
> 
> > Either way, more details about the problem being fixed in the commit log
> > would be helpful.
> 
> <nod>
> 
> --D
> 
> > Brian
> > 
> 

