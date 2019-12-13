Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72499C34963
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4469246EF
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dU4KKNRM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfLMLTP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 06:19:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36040 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725937AbfLMLTP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 06:19:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576235954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=syPhU4daWU01aUsvzjRxN4P4o3uULHYvBBBSPw1TwQM=;
        b=dU4KKNRMzXJ03B2PykGmfDTLRXFMbE+2mwnEQ0jepwpy1g5YQ5LFPzqgGxLBaQQ8w+kMuX
        JZ7ZCrAJ2miZhoeCmAERv6IPcjV8+si6ePBklW/EbsycQds82THKlmtzBXHKlYMDgE/ccs
        5e7xRa+KJtB0CifalaqvpB4bTlmpQQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-kxaL5AGCN1ekzRPCvCRbXA-1; Fri, 13 Dec 2019 06:19:10 -0500
X-MC-Unique: kxaL5AGCN1ekzRPCvCRbXA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 994EA107AD40;
        Fri, 13 Dec 2019 11:19:09 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E969D5C241;
        Fri, 13 Dec 2019 11:19:08 +0000 (UTC)
Date:   Fri, 13 Dec 2019 06:19:08 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 6/6] xfs_repair: check plausibility of root dir pointer
 before trashing it\
Message-ID: <20191213111908.GA43131@bfoster>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
 <157547910268.974712.78208912903649937.stgit@magnolia>
 <20191205143858.GF48368@bfoster>
 <20191212224618.GE99875@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212224618.GE99875@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 12, 2019 at 02:46:18PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 05, 2019 at 09:38:58AM -0500, Brian Foster wrote:
> > On Wed, Dec 04, 2019 at 09:05:02AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > If sb_rootino doesn't point to where we think mkfs should have allocated
> > > the root directory, check to see if the alleged root directory actually
> > > looks like a root directory.  If so, we'll let it live because someone
> > > could have changed sunit since formatting time, and that changes the
> > > root directory inode estimate.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  repair/xfs_repair.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 45 insertions(+)
> > > 
> > > 
> > > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > > index abd568c9..b0407f4b 100644
> > > --- a/repair/xfs_repair.c
> > > +++ b/repair/xfs_repair.c
> > > @@ -426,6 +426,37 @@ _("would reset superblock %s inode pointer to %"PRIu64"\n"),
> > >  	*ino = expected_ino;
> > >  }
> > >  
> > > +/* Does the root directory inode look like a plausible root directory? */
> > > +static bool
> > > +has_plausible_rootdir(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	struct xfs_inode	*ip;
> > > +	xfs_ino_t		ino;
> > > +	int			error;
> > > +	bool			ret = false;
> > > +
> > > +	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip,
> > > +			&xfs_default_ifork_ops);
> > > +	if (error)
> > > +		goto out;
> > > +	if (!S_ISDIR(VFS_I(ip)->i_mode))
> > > +		goto out_rele;
> > > +
> > > +	error = -libxfs_dir_lookup(NULL, ip, &xfs_name_dotdot, &ino, NULL);
> > > +	if (error)
> > > +		goto out_rele;
> > > +
> > > +	/* The root directory '..' entry points to the directory. */
> > > +	if (ino == mp->m_sb.sb_rootino)
> > > +		ret = true;
> > > +
> > > +out_rele:
> > > +	libxfs_irele(ip);
> > > +out:
> > > +	return ret;
> > > +}
> > > +
> > >  /*
> > >   * Make sure that the first 3 inodes in the filesystem are the root directory,
> > >   * the realtime bitmap, and the realtime summary, in that order.
> > > @@ -436,6 +467,20 @@ calc_mkfs(
> > >  {
> > >  	xfs_ino_t		rootino = libxfs_ialloc_calc_rootino(mp, -1);
> > >  
> > > +	/*
> > > +	 * If the root inode isn't where we think it is, check its plausibility
> > > +	 * as a root directory.  It's possible that somebody changed sunit
> > > +	 * since the filesystem was created, which can change the value of the
> > > +	 * above computation.  Don't blow up the root directory if this is the
> > > +	 * case.
> > > +	 */
> > > +	if (mp->m_sb.sb_rootino != rootino && has_plausible_rootdir(mp)) {
> > > +		do_warn(
> > > +_("sb root inode value %" PRIu64 " inconsistent with alignment (expected %"PRIu64")\n"),
> > > +			mp->m_sb.sb_rootino, rootino);
> > > +		rootino = mp->m_sb.sb_rootino;
> > > +	}
> > > +
> > 
> > A slightly unfortunate side effect of this is that there's seemingly no
> > straightforward way for a user to "clear" this state/warning. We've
> > solved the major problem by allowing repair to handle this condition,
> > but AFAICT this warning will persist unless the stripe unit is changed
> > back to its original value.
> 
> Heh, I apparently never replied to this. :(
> 
> > IOW, what if this problem exists simply because a user made a mistake
> > and wants to undo it? It's probably easy enough for us to say "use
> > whatever you did at mkfs time," but what if that's unknown or was set
> > automatically? I feel like that is the type of thing that in practice
> > could result in unnecessary bugs or error reports unless the tool can
> > make a better suggestion to the end user. For example, could we check
> > the geometry on secondary supers (if they exist) against the current
> > rootino and use that as a secondary form of verification and/or suggest
> > the user reset to that geometry (if desired)?
> 
> That sounds reasonable.
> 
> > OTOH, I guess we'd have to consider what happens if the filesystem was
> > grown in that scenario too..  :/
> 
> I think it would be fine, so long as we're careful with the if-then
> chain.  Specifically:
> 
> a. If we dislike the rootino that we compute with the ondisk sunit value,
> and...
> 
> b. The thing sb_rootino points to actually does look like the root
> directory, and...
> 
> c. One of the secondary supers has an sunit value that gives us a
> rootino calculation that matches the sb_rootino that we just checked
> out...
> 
> ...then we'll propose correcting the primary sb_unit to the value we
> found in (c).
> 

Yeah, that makes sense. My broader concern was addressing the situation
where we aren't lucky enough to glean original alignment from the fs.
Perhaps we could 1.) update the warning message to unconditionally
recommend an alignment and 2.) if nothing is gleaned from secondary
supers (and all your above conditions apply), calculate and recommend
the max alignment that accommodates the root inode chunk..? It might not
be the original value, but at least guides the user to a solution to
quiet the warning..

Brian

> > 
> > (Actually on a quick test, it looks like growfs updates every super,
> > even preexisting..).
> 
> I'll throw that onto the V3 series.
> 
> --D
> 
> > 
> > Brian
> > 
> > >  	ensure_fixed_ino(&mp->m_sb.sb_rootino, rootino,
> > >  			_("root"));
> > >  	ensure_fixed_ino(&mp->m_sb.sb_rbmino, rootino + 1,
> > > 
> > 
> 

