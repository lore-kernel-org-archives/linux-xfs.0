Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60386C35DF5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 13:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37ACB20658
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 13:27:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQLlPo17"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgBYN1R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 08:27:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24772 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729065AbgBYN1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 08:27:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582637235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pRgyTbLAswUduEPxgf8yYOwwO4oNfT1IDsLbItgYZIE=;
        b=fQLlPo17FKFRK8SW0Ms7cvU6ZF6qhjAz7gCc0I0654p1bEZ4oabxVNQAEfL8aipqRA7uvF
        VjEdCY/6WCVE2Yu+9aFAY5OsB8fzFKoi+5cgtIjDq6eqeGLSPZEg0+E0HvSzK3iQK7WslJ
        DLDs+Bqbx9wZ9DBqRNnk6QW1wNocNZM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-yiON3rzqMDawlbYxWNEX4g-1; Tue, 25 Feb 2020 08:27:13 -0500
X-MC-Unique: yiON3rzqMDawlbYxWNEX4g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7796800D55;
        Tue, 25 Feb 2020 13:27:12 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BBF76031E;
        Tue, 25 Feb 2020 13:27:12 +0000 (UTC)
Date:   Tue, 25 Feb 2020 08:27:10 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 12/19] xfs: Add helper function xfs_attr_rmtval_unmap
Message-ID: <20200225132710.GC21304@bfoster>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-13-allison.henderson@oracle.com>
 <20200224134022.GF15761@bfoster>
 <f8aec2fb-09ef-f636-913c-41b8a5474a9b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8aec2fb-09ef-f636-913c-41b8a5474a9b@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 02:44:14PM -0700, Allison Collins wrote:
> 
> 
> On 2/24/20 6:40 AM, Brian Foster wrote:
> > On Sat, Feb 22, 2020 at 07:06:04PM -0700, Allison Collins wrote:
> > > This function is similar to xfs_attr_rmtval_remove, but adapted to return EAGAIN for
> > > new transactions. We will use this later when we introduce delayed attributes
> > > 
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr_remote.c | 28 ++++++++++++++++++++++++++++
> > >   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
> > >   2 files changed, 29 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > > index 3de2eec..da40f85 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > > @@ -711,3 +711,31 @@ xfs_attr_rmtval_remove(
> > >   	}
> > >   	return 0;
> > >   }
> > > +
> > > +/*
> > > + * Remove the value associated with an attribute by deleting the out-of-line
> > > + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> > > + * transaction and recall the function
> > > + */
> > > +int
> > > +xfs_attr_rmtval_unmap(
> > > +	struct xfs_da_args	*args)
> > > +{
> > > +	int	error, done;
> > > +
> > > +	/*
> > > +	 * Unmap value blocks for this attr.  This is similar to
> > > +	 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
> > > +	 * for new transactions
> > > +	 */
> > > +	error = xfs_bunmapi(args->trans, args->dp,
> > > +		    args->rmtblkno, args->rmtblkcnt,
> > > +		    XFS_BMAPI_ATTRFORK, 1, &done);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	if (!done)
> > > +		return -EAGAIN;
> > > +
> > > +	return 0;
> > > +}
> > 
> > Hmm.. any reason this isn't a refactor of the existing remove function?
> > Just skipping to the end of the series, I see we leave the reference to
> > xfs_attr_rmtval_remove() (which no longer exists and so is not very
> > useful) in this comment as well as a stale function declaration in
> > xfs_attr_remote.h.
> > 
> > I haven't grokked how this is used yet, but it seems like it would be
> > more appropriate to lift out the transaction handling from the original
> > function as we have throughout the rest of the code. That could also
> > mean creating a temporary wrapper (i.e., rmtval_remove() calls
> > rmtval_unmap()) for the loop/transaction code that could be removed
> > later if it ends up unused. Either way is much easier to follow than
> > creating a (currently unused) replacement..
> Yes, this came up in one of the other reviews.  I thought about it, but then
> decided against it.  xfs_attr_rmtval_remove disappears across patches 13 and
> 14.  The use of xfs_attr_rmtval_remove is replaced with
> xfs_attr_rmtval_unmap when we finally yank out all the transaction code.
> The reason I dont want to do it all at once is because that would mean
> patches 12, 13, 14 and 19 would lump together to make the swap instantaneous
> in once patch.
> 

Hmm.. I don't think we're talking about the same thing. If
xfs_attr_rmtval_remove() was broken down into two functions such that
one of the two looks exactly like the _unmap() variant, can't we just
remove the other half when it becomes unused and allow the _remove()
variant to exist with the implementation of _unmap() proposed here? This
seems fairly mechanical to me..

> I've been getting feedback that the set is really complicated, so I've been
> trying to find a way to organize it to help make it easier to review.  So I
> thought isolating 13 and 14 to just the state machine would help.  Thus I
> decided to keep patch 12 separate to take as much craziness out of 13 and 14
> as possible.  Patches 12 and 19 seem like otherwise easy things for people
> to look at.  Let me know your thoughts on this. :-)
> 

I think doing as much refactoring of existing code as early as possible
will go a long way towards simplifying the complexity around the
introduction of the state bits.

Brian

> You are right about the stale comment though, I missed it while going back
> over the commentary at the top.  Will fix.
> 
> Allison
> 
> > 
> > Brian
> > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> > > index eff5f95..e06299a 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.h
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> > > @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > >   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
> > >   		xfs_buf_flags_t incore_flags);
> > >   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> > > +int xfs_attr_rmtval_unmap(struct xfs_da_args *args);
> > >   #endif /* __XFS_ATTR_REMOTE_H__ */
> > > -- 
> > > 2.7.4
> > > 
> > 
> 

