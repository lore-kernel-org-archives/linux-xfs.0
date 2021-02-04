Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B14C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 12:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D65F64F58
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 12:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbhBDMew (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 07:34:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235988AbhBDMev (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 07:34:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612442004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q/4eRWT7hyu/cQLMisFp54EZXrx/F+CDzqcdabD7NDQ=;
        b=RGlI+LLTUdRhd8eF7RBRbzww8g8VAhuZYNN08LzViWVozgnxy9H+vfhjoWVbp/HIPiFH5p
        E1f8zJKZ5nxDGJRRMUDXHTw9Strywqpg/syepIW6iJCoyXGvWXZplF6ZjrTclq9OkTUvTd
        Zspx3H40uF3GxTLX/WD1JJk7Ba9xtRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-uDKtHzNHNjSi3CKZGiya_Q-1; Thu, 04 Feb 2021 07:33:23 -0500
X-MC-Unique: uDKtHzNHNjSi3CKZGiya_Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0055B107ACE3;
        Thu,  4 Feb 2021 12:33:22 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FB975D6D7;
        Thu,  4 Feb 2021 12:33:18 +0000 (UTC)
Date:   Thu, 4 Feb 2021 07:33:16 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 6/7] xfs: support shrinking unused space in the last AG
Message-ID: <20210204123316.GB3716033@bfoster>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-7-hsiangkao@redhat.com>
 <20210203142337.GB3647012@bfoster>
 <20210203145146.GA935062@xiangao.remote.csb>
 <20210203180126.GH3647012@bfoster>
 <20210204091835.GA149518@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204091835.GA149518@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 04, 2021 at 05:18:35PM +0800, Gao Xiang wrote:
> On Wed, Feb 03, 2021 at 01:01:26PM -0500, Brian Foster wrote:
> > On Wed, Feb 03, 2021 at 10:51:46PM +0800, Gao Xiang wrote:
> 
> ...
> 
> > > > 
> > > > >  
> > > > > -	/* If there are new blocks in the old last AG, extend it. */
> > > > > +	/* If there are some blocks in the last AG, resize it. */
> > > > >  	if (delta) {
> > > > 
> > > > This patch added a (nb == mp->m_sb.sb_dblocks) shortcut check at the top
> > > > of the function. Should we ever get to this point with delta == 0? (If
> > > > not, maybe convert it to an assert just to be safe.)
> > > 
> > > delta would be changed after xfs_resizefs_init_new_ags() (the original
> > > growfs design is that, I don't want to touch the original logic). that
> > > is why `delta' reflects the last AG delta now...
> > > 
> > 
> > Oh, I see. Hmm... that's a bit obfuscated and easy to miss. Perhaps the
> > new helper should also include the extend_space() call below to do all
> > of the AG updates in one place. It's not clear to me if we need to keep
> > the growfs perag reservation code where it is. If so, the new helper
> > could take a boolean pointer (instead of delta) that it can set to true
> > if it had to extend the size of the old last AG because the perag res
> > bits don't actually use the delta value. IOW, I think this hunk could
> > look something like the following:
> > 
> > 	bool	resetagres = false;
> > 
> > 	if (extend)
> > 		error = xfs_resizefs_init_new_ags(..., delta, &resetagres);
> > 	else
> > 		error = xfs_ag_shrink_space(... -delta);
> > 	...
> > 
> > 	if (resetagres) {
> > 		<do perag res fixups>
> > 	}
> > 	...
> > 
> > Hm?
> 
> Not quite sure got your point since xfs_resizefs_init_new_ags() is not
> part of the transaction (and no need to). If you mean that the current
> codebase needs some refactor to make the whole growfs operation as a
> new helper, I could do in the next version, but one thing out there is
> there are too many local variables, if we introduce some new helper,
> a new struct argument might be needed.
> 

That seems fine either way. I think it's just a matter of passing the
transaction to the function or not. I've appended a diff based on the
previous refactoring patch to demonstrate what I mean (compile tested
only).

> And I have no idea why growfs perag reservation stays at the end of
> the function. My own understanding is that if growfs perag reservation
> here is somewhat racy since no AGI/AGF lock protection it seems.
> 

Ok. It's probably best to leave it alone until we figure that out and
then address it in a separate patch, if desired.

Brian

--- 8< ---

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6c4ab5e31054..707c9379d6c1 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -34,19 +34,20 @@
  */
 static int
 xfs_resizefs_init_new_ags(
-	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
 	struct aghdr_init_data	*id,
 	xfs_agnumber_t		oagcount,
 	xfs_agnumber_t		nagcount,
-	xfs_rfsblock_t		*delta)
+	xfs_rfsblock_t		delta)
 {
-	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + delta;
 	int			error;
 
 	INIT_LIST_HEAD(&id->buffer_list);
 	for (id->agno = nagcount - 1;
 	     id->agno >= oagcount;
-	     id->agno--, *delta -= id->agsize) {
+	     id->agno--, delta -= id->agsize) {
 
 		if (id->agno == nagcount - 1)
 			id->agsize = nb - (id->agno *
@@ -60,7 +61,16 @@ xfs_resizefs_init_new_ags(
 			return error;
 		}
 	}
-	return xfs_buf_delwri_submit(&id->buffer_list);
+
+	error = xfs_buf_delwri_submit(&id->buffer_list);
+	if (error)
+		return error;
+
+	xfs_trans_agblocks_delta(tp, id->nfree);
+
+	if (delta)
+		error = xfs_ag_extend_space(mp, tp, id, delta);
+	return error;
 }
 
 /*
@@ -117,19 +127,10 @@ xfs_growfs_data_private(
 	if (error)
 		return error;
 
-	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
+	error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount, delta);
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_trans_agblocks_delta(tp, id.nfree);
-
-	/* If there are new blocks in the old last AG, extend it. */
-	if (delta) {
-		error = xfs_ag_extend_space(mp, tp, &id, delta);
-		if (error)
-			goto out_trans_cancel;
-	}
-
 	/*
 	 * Update changed superblock fields transactionally. These are not
 	 * seen by the rest of the world until the transaction commit applies

