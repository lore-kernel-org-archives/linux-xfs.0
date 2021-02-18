Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDDE9C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 16:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B67E64EB2
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 16:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhBRQlB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:41:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233351AbhBRNBG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 08:01:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613653172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zTEqcmBOsJlVNrnKMrglFUiDStSJag8A89d8vl90yiM=;
        b=dElfA7MlEeWAkujFQXbEvRD+iQ1d6ZzMYXPzdav/hIhA2E6FHA9sVZSu1Qm+5cYTkLHpJm
        35y5uwg45rmMlgncVwZinHi+d6uIvNxUe3WsQXntxh9s6UPlKtnk7BDI23qHmXu76QQuwz
        A/lQO15H/lizZ/RhpjdIqQKC0/sdi9w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-5-gc0GEHN8Ki4nzJi5vwKA-1; Thu, 18 Feb 2021 07:59:30 -0500
X-MC-Unique: 5-gc0GEHN8Ki4nzJi5vwKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 760A984E240;
        Thu, 18 Feb 2021 12:59:29 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DEEF32BFE9;
        Thu, 18 Feb 2021 12:59:28 +0000 (UTC)
Date:   Thu, 18 Feb 2021 07:59:27 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_repair: set NEEDSREPAIR the first time we write
 to a filesystem
Message-ID: <20210218125927.GA685651@bfoster>
References: <161319520460.422860.10568013013578673175.stgit@magnolia>
 <161319521070.422860.2540813932323979688.stgit@magnolia>
 <20210216115534.GB534175@bfoster>
 <20210218044522.GR7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218044522.GR7193@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 17, 2021 at 08:45:22PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 16, 2021 at 06:55:34AM -0500, Brian Foster wrote:
> > On Fri, Feb 12, 2021 at 09:46:50PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Add a hook to the buffer cache so that xfs_repair can intercept the
> > > first write to a V5 filesystem to set the NEEDSREPAIR flag.  In the
> > > event that xfs_repair dirties the filesystem and goes down, this ensures
> > > that the sysadmin will have to re-start repair before mounting.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  include/xfs_mount.h |    4 ++
> > >  libxfs/rdwr.c       |    4 ++
> > >  repair/xfs_repair.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 103 insertions(+)
> > > 
> > > 
> > ...
> > > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > > index 90d1a95a..12e319ae 100644
> > > --- a/repair/xfs_repair.c
> > > +++ b/repair/xfs_repair.c
...
> > > @@ -751,6 +753,95 @@ clear_needsrepair(
> > >  		libxfs_buf_relse(bp);
> > >  }
> > >  
> > > +static void
> > > +update_sb_crc_only(
> > > +	struct xfs_buf		*bp)
> > > +{
> > > +	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
> > > +}
> > > +
> > > +/* Forcibly write the primary superblock with the NEEDSREPAIR flag set. */
> > > +static void
> > > +force_needsrepair(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	struct xfs_buf_ops	fake_ops;
> > > +	struct xfs_buf		*bp;
> > > +	int			error;
> > > +
> > > +	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
> > > +	    xfs_sb_version_needsrepair(&mp->m_sb))
> > > +		return;
> > > +
> > > +	bp = libxfs_getsb(mp);
> > > +	if (!bp || bp->b_error) {
> > > +		do_log(
> > > +	_("couldn't get superblock to set needsrepair, err=%d\n"),
> > > +				bp ? bp->b_error : ENOMEM);
> > > +		return;
> > > +	} else {
> > > +		/*
> > > +		 * It's possible that we need to set NEEDSREPAIR before we've
> > > +		 * had a chance to fix the summary counters in the primary sb.
> > > +		 * With the exception of those counters, phase 1 already
> > > +		 * ensured that the geometry makes sense.
> > > +		 *
> > > +		 * Bad summary counters in the primary super can cause the
> > > +		 * write verifier to fail, so substitute a dummy that only sets
> > > +		 * the CRC.  In the event of a crash, NEEDSREPAIR will prevent
> > > +		 * the kernel from mounting our potentially damaged filesystem
> > > +		 * until repair is run again, so it's ok to bypass the usual
> > > +		 * verification in this one case.
> > > +		 */
> > > +		fake_ops = xfs_sb_buf_ops; /* struct copy */
> > > +		fake_ops.verify_write = update_sb_crc_only;
> > > +
> > > +		mp->m_sb.sb_features_incompat |=
> > > +				XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > > +		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > > +
> > > +		/* Force the primary super to disk immediately. */
> > > +		bp->b_ops = &fake_ops;
> > > +		error = -libxfs_bwrite(bp);
> > 
> > This looks like it calls back into the writeback hook before it's been
> > cleared.
> 
> Yes, it does...
> 
> > I'm guessing the xfs_sb_version_needsrepair() check above cuts
> > off any recursion issues,
> 
> ...but as soon as we end up in the writeback hook, the b_ops and
> XFS_SB_DADDR checks cause the hook to return without doing anything.
> 
> > but it might be cleaner to clear the callback pointer first.
> 
> We need to block all other writers until /after/ we've written the
> primary super, which means that we can't clear the callback until some
> time after the bwrite.
> 

Ok, care to document how this is intended to work with a comment?

Brian

> > 
> > > +		bp->b_ops = &xfs_sb_buf_ops;
> > > +		if (error)
> > > +			do_log(_("couldn't force needsrepair, err=%d\n"), error);
> > > +	}
> > > +	if (bp)
> > > +		libxfs_buf_relse(bp);
> > 
> > Doesn't appear we can get here with bp == NULL. Otherwise the rest looks
> > reasonable to me.
> 
> Yep, will fix.
> 
> --D
> 
> > Brian
> > 
> > > +}
> > > +
> > > +/* Intercept the first write to the filesystem so we can set NEEDSREPAIR. */
> > > +static void
> > > +repair_capture_writeback(
> > > +	struct xfs_buf		*bp)
> > > +{
> > > +	struct xfs_mount	*mp = bp->b_mount;
> > > +	static pthread_mutex_t	wb_mutex = PTHREAD_MUTEX_INITIALIZER;
> > > +
> > > +	/* Higher level code modifying a superblock must set NEEDSREPAIR. */
> > > +	if (bp->b_ops == &xfs_sb_buf_ops || bp->b_bn == XFS_SB_DADDR)
> > > +		return;
> > > +
> > > +	pthread_mutex_lock(&wb_mutex);
> > > +
> > > +	/*
> > > +	 * If someone else already dropped the hook, then needsrepair has
> > > +	 * already been set on the filesystem and we can unlock.
> > > +	 */
> > > +	if (mp->m_buf_writeback_fn != repair_capture_writeback)
> > > +		goto unlock;
> > > +
> > > +	/*
> > > +	 * If we get here, the buffer being written is not a superblock, and
> > > +	 * needsrepair needs to be set.
> > > +	 */
> > > +	force_needsrepair(mp);
> > > +	mp->m_buf_writeback_fn = NULL;
> > > +unlock:
> > > +	pthread_mutex_unlock(&wb_mutex);
> > > +}
> > > +
> > >  int
> > >  main(int argc, char **argv)
> > >  {
> > > @@ -847,6 +938,10 @@ main(int argc, char **argv)
> > >  	if (verbose > 2)
> > >  		mp->m_flags |= LIBXFS_MOUNT_WANT_CORRUPTED;
> > >  
> > > +	/* Capture the first writeback so that we can set needsrepair. */
> > > +	if (xfs_sb_version_hascrc(&mp->m_sb))
> > > +		mp->m_buf_writeback_fn = repair_capture_writeback;
> > > +
> > >  	/*
> > >  	 * set XFS-independent status vars from the mount/sb structure
> > >  	 */
> > > 
> > 
> 

