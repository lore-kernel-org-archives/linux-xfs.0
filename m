Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66BE6C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A9C20663
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731663AbhAZXD7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:03:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405133AbhAZUEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 15:04:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611691397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KqzGpEUr8gJAav/Ql+BjKq5wmHzcI7+gUEQcf1zfI1c=;
        b=CWEFijPY76mmR5hgNOgB7ahBeWyWKS4EmTD73L0YHsxKhwty0E/atkhrIEZKSs7IGTjhDn
        FH6DZO9rpbrfE2TBMAZHhgffjQ6ArOrfZRuf3masDyEquAQgI/nHhiZsI7Z98nzD8q2Tkx
        DPtyWQritXnt/Lot12xV3Mh2aDWy35A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-4ghpHKpTO5SNxlAYaVrtlw-1; Tue, 26 Jan 2021 15:03:13 -0500
X-MC-Unique: 4ghpHKpTO5SNxlAYaVrtlw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5F4857086;
        Tue, 26 Jan 2021 20:03:11 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 293EF60C47;
        Tue, 26 Jan 2021 20:03:11 +0000 (UTC)
Date:   Tue, 26 Jan 2021 15:03:09 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 02/11] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <20210126200309.GA2515451@bfoster>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142793080.2171939.11486862758521454210.stgit@magnolia>
 <20210125181406.GH2047559@bfoster>
 <20210125195446.GD7698@magnolia>
 <20210126131451.GA2158252@bfoster>
 <20210126183452.GZ7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126183452.GZ7698@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 26, 2021 at 10:34:52AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 26, 2021 at 08:14:51AM -0500, Brian Foster wrote:
> > On Mon, Jan 25, 2021 at 11:54:46AM -0800, Darrick J. Wong wrote:
> > > On Mon, Jan 25, 2021 at 01:14:06PM -0500, Brian Foster wrote:
> > > > On Sat, Jan 23, 2021 at 10:52:10AM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Don't stall the cowblocks scan on a locked inode if we possibly can.
> > > > > We'd much rather the background scanner keep moving.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > > ---
> > > > >  fs/xfs/xfs_icache.c |   21 ++++++++++++++++++---
> > > > >  1 file changed, 18 insertions(+), 3 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > > index c71eb15e3835..89f9e692fde7 100644
> > > > > --- a/fs/xfs/xfs_icache.c
> > > > > +++ b/fs/xfs/xfs_icache.c
> > > > > @@ -1605,17 +1605,31 @@ xfs_inode_free_cowblocks(
> > > > >  	void			*args)
> > > > >  {
> > > > >  	struct xfs_eofblocks	*eofb = args;
> > > > > +	bool			wait;
> > > > >  	int			ret = 0;
> > > > >  
> > > > > +	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
> > > > > +
> > > > >  	if (!xfs_prep_free_cowblocks(ip))
> > > > >  		return 0;
> > > > >  
> > > > >  	if (!xfs_inode_matches_eofb(ip, eofb))
> > > > >  		return 0;
> > > > >  
> > > > > -	/* Free the CoW blocks */
> > > > > -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> > > > > -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> > > > > +	/*
> > > > > +	 * If the caller is waiting, return -EAGAIN to keep the background
> > > > > +	 * scanner moving and revisit the inode in a subsequent pass.
> > > > > +	 */
> > > > > +	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> > > > > +		if (wait)
> > > > > +			return -EAGAIN;
> > > > > +		return 0;
> > > > > +	}
> > > > > +	if (!xfs_ilock_nowait(ip, XFS_MMAPLOCK_EXCL)) {
> > > > > +		if (wait)
> > > > > +			ret = -EAGAIN;
> > > > > +		goto out_iolock;
> > > > > +	}
> > > > 
> > > > Hmm.. I'd be a little concerned over this allowing a scan to repeat
> > > > indefinitely with a competing workload because a restart doesn't carry
> > > > over any state from the previous scan. I suppose the
> > > > xfs_prep_free_cowblocks() checks make that slightly less likely on a
> > > > given file, but I more wonder about a scenario with a large set of
> > > > inodes in a particular AG with a sufficient amount of concurrent
> > > > activity. All it takes is one trylock failure per scan to have to start
> > > > the whole thing over again... hm?
> > > 
> > > I'm not quite sure what to do here -- xfs_inode_free_eofblocks already
> > > has the ability to return EAGAIN, which (I think) means that it's
> > > already possible for the low-quota scan to stall indefinitely if the
> > > scan can't lock the inode.
> > > 
> > 
> > Indeed, that is true.
> > 
> > > I think we already had a stall limiting factor here in that all the
> > > other threads in the system that hit EDQUOT will drop their IOLOCKs to
> > > scan the fs, which means that while they loop around the scanner they
> > > can only be releasing quota and driving us towards having fewer inodes
> > > with the same dquots and either blockgc tag set.
> > > 
> > 
> > Yeah, that makes sense for the current use case. There's a broader
> > sequence involved there that provides some throttling and serialization,
> > along with the fact that the workload is imminently driving into
> > -ENOSPC.
> > 
> > I think what had me a little concerned upon seeing this is whether the
> > scanning mechanism is currently suitable for the broader usage
> > introduced in this series. We've had related issues in the past with
> > concurrent sync eofblocks scans and iolock (see [1], for example).
> > Having made it through the rest of the series however, it looks like all
> > of the new scan invocations are async, so perhaps this is not really an
> > immediate problem.
> > 
> > I think it would be nice if we could somehow assert that the task that
> > invokes a sync scan doesn't hold an iolock, but I'm not sure there's a
> > clean way to do that. We'd probably have to define the interface to
> > require an inode just for that purpose. It may not be worth that
> > weirdness, and I suppose if code is tested it should be pretty obvious
> > that such a scan will never complete..
> 
> Well... in theory it would be possible to deal with stalls (A->A
> livelock or otherwise) if we had that IWALK_NORETRY flag I was talking
> about that would cause xfs_iwalk to exit with EAGAIN instead of
> restarting the scan at inode 0.  The caller could detect that a
> synchronous scan didn't complete, and then decide if it wants to call
> back to try again.
> 
> But, that might be a lot of extra code to deal with a requirement that
> xfs_blockgc_free_* callers cannot hold an iolock or an mmaplock.  Maybe
> that's the simpler course of action?
> 

Yeah, I think we should require that callers drop all such locks before
invoking a sync scan, since that may livelock against the lock held by
the current task (or cause similar weirdness against concurrent sync
scans, as the code prior to the commit below[1] had demonstrated).  The
async scans used throughout this series seem reasonable to me..

Brian

> --D
> 
> > Brian
> > 
> > [1] c3155097ad89 ("xfs: sync eofblocks scans under iolock are livelock prone")
> > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > >  
> > > > >  	/*
> > > > >  	 * Check again, nobody else should be able to dirty blocks or change
> > > > > @@ -1625,6 +1639,7 @@ xfs_inode_free_cowblocks(
> > > > >  		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
> > > > >  
> > > > >  	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> > > > > +out_iolock:
> > > > >  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> > > > >  
> > > > >  	return ret;
> > > > > 
> > > > 
> > > 
> > 
> 

