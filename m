Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36907C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 14:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243963AbiDZOzW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 10:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244221AbiDZOzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 10:55:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976B95F8EA
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 07:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01A4ECE1F25
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 14:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCEDC385A0;
        Tue, 26 Apr 2022 14:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650984730;
        bh=t4++QJvJi8UhNLgMc/4xWDaeQrTmC/0o5fsH2ip/3Po=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=exy5jDAE6WZYzqpemRXECejTfDvdRnDKZJAA0s4990YgNgAtFdIORh7W1/mtEwhyO
         6Juve7avp6x9mFvlAjrY6GdPknpmK0OVedg+Gr68MqkxjBaE/57DwRsaXQ0v4T98Ih
         AaQTYXIuj6Sk1vdAleh0rwsuXAgfg/cZMvOdNIpLestuRkZ4buQ0onhZqJOPayBOYQ
         SBT9aovjgY8fRsWylMF93+roTQeC4UxSLG1gnbYfPR+4cU+DKjXS3n+uXUqKN0B5qk
         YIi/rTUSJUGCDvoHs0Db3LZ3fFOzDOs24qQecDrGrxoa9ft6NQdBZ9RS3L3zhGjDn2
         LVoEGKe4qQ4BA==
Date:   Tue, 26 Apr 2022 07:52:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: stop artificially limiting the length of bunmap
 calls
Message-ID: <20220426145209.GU17025@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997687142.383881.7160925177236303538.stgit@magnolia>
 <Ymf3wqypgyjXDLN2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymf3wqypgyjXDLN2@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 06:46:42AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 14, 2022 at 03:54:31PM -0700, Darrick J. Wong wrote:
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index 327ba25e9e17..a07ebaecba73 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -960,6 +960,7 @@ xfs_refcount_adjust_extents(
> >  			 * Either cover the hole (increment) or
> >  			 * delete the range (decrement).
> >  			 */
> > +			cur->bc_ag.refc.nr_ops++;
> >  			if (tmp.rc_refcount) {
> >  				error = xfs_refcount_insert(cur, &tmp,
> >  						&found_tmp);
> > @@ -970,7 +971,6 @@ xfs_refcount_adjust_extents(
> >  					error = -EFSCORRUPTED;
> >  					goto out_error;
> >  				}
> > -				cur->bc_ag.refc.nr_ops++;
> 
> How do these changes fit into the rest of the patch?

Long ago before we used deferred ops to update the refcount btree, we
would restrict the number of blocks that could be bunmapped in order to
avoid overflowing the transaction reservation while doing refcount
updates for an unmapped extent.

Later on, I added deferred refcount updates so at least the refcountbt
updates went in their own transaction, which meant that if we started
running out of space because the unmapped extent had many many different
refcount records, we could at least return EAGAIN to get a clean
transaction to continue.  I needed a way to guess when we were getting
close to the reservation limit, so I added this nr_ops counter to track
the number of record updates.  Granted, 32 bytes per refcountbt record
update is quite an overestimate, since the records are contiguous in a
btree leaf block.

In the past, the deferred ops code had a defect where it didn't maintain
correct ordering of deferred ops when one dfops' ->finish_item function
queued even more dfops to the transaction, which is what happens when a
refcount update queues EFIs for blocks that are no longer referenced.
This resulted in enormous chains of defer ops, so I left the bunmap
piece in to throttle the chain lengths.

Now we've fixed the deferred ops code to maintain correct dfops order
between existing ops and newly queued ones, so the chaining problem went
away, and we can get rid of the bunmap throttle.  However, as part of
doing that, it's necessary to track the number of EFIs logged to the
transaction as well, which is what the above code change fixes.

Granted, Dave has also commented that EFIs use a bit more than 32 bytes,
so I think it would be warranted to capture the above comment and the
xfs_refcount.c changes in a separate patch now.

--D
