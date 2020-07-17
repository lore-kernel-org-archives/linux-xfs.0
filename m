Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4773C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 12:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9552B206BE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 12:25:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z7w6tsRM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgGQMZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jul 2020 08:25:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33985 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726056AbgGQMZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jul 2020 08:25:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594988750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m905tr0jT0SQJnZ13QRtEQcAWg005jJcsg9gqBROWf8=;
        b=Z7w6tsRMexIQqRTS9sDKpKq3UiVPro5fCaOXbn/G2iDRp58CT88FmDUbcojry5Wf809IpR
        TibTuU1ueJUNBh2FEGLnvvISXsc06PicmOBbG/19LbKVekdhg/p1R3PZzSOT4V/Wf/cqmx
        mQFghh3GtRvkb+GqpiPGQRf+UG4Dy10=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-1gIn7vI9P0-oPVoifY6Ggw-1; Fri, 17 Jul 2020 08:25:48 -0400
X-MC-Unique: 1gIn7vI9P0-oPVoifY6Ggw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2AA0100CCC2;
        Fri, 17 Jul 2020 12:25:47 +0000 (UTC)
Received: from bfoster (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45FFC10013C4;
        Fri, 17 Jul 2020 12:25:47 +0000 (UTC)
Date:   Fri, 17 Jul 2020 08:25:45 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: replace ialloc space res macro with inline
 helper
Message-ID: <20200717122545.GB58041@bfoster>
References: <20200715193310.22002-1-bfoster@redhat.com>
 <20200716121849.36661-1-bfoster@redhat.com>
 <20200716220156.GL2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716220156.GL2005@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 17, 2020 at 08:01:56AM +1000, Dave Chinner wrote:
> On Thu, Jul 16, 2020 at 08:18:49AM -0400, Brian Foster wrote:
> > Rewrite the macro as a static inline helper to clean up the logic
> > and have one less macro.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_trans_space.h | 24 ++++++++++++++++--------
> >  fs/xfs/xfs_inode.c              |  4 ++--
> >  fs/xfs/xfs_symlink.c            |  2 +-
> >  3 files changed, 19 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> > index c6df01a2a158..d08dfc8795c3 100644
> > --- a/fs/xfs/libxfs/xfs_trans_space.h
> > +++ b/fs/xfs/libxfs/xfs_trans_space.h
> > @@ -55,10 +55,18 @@
> >  	 XFS_DIRENTER_MAX_SPLIT(mp,nl))
> >  #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
> >  	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
> > -#define	XFS_IALLOC_SPACE_RES(mp)	\
> > -	(M_IGEO(mp)->ialloc_blks + \
> > -	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
> > -	  (M_IGEO(mp)->inobt_maxlevels - 1)))
> > +
> > +static inline int
> > +xfs_ialloc_space_res(
> > +	struct xfs_mount	*mp)
> > +{
> > +	int			res = M_IGEO(mp)->ialloc_blks;
> > +
> > +	res += M_IGEO(mp)->inobt_maxlevels - 1;
> > +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > +		res += M_IGEO(mp)->inobt_maxlevels - 1;
> > +	return res;
> > +}
> 
> This misses the point I made. i.e. that the space reservation is
> constant and never changes, yet we calculate it -twice- per inode
> create. That means we can be calculating it hundreds of thousands of
> times a second instead of just reading a variable that is likely hot
> in cache.
> 

Partly.. I mentioned in my earlier reply that the geometry structure
doesn't seem like the right place to stuff transaction reservation
related values. An alternative I mentioned would be a new (or update to
the existing) structure that similarly precalculates log reservations,
but I wasn't going to go do that without some discussion/feedback on the
approach. Replacing the macro seemed broadly acceptable, so I sent that
patch as an incremental improvement and to keep the bug fix isolated.

Also, while stuffing a new value in a pre-existing structure might lend
itself to a one-off patch, I'm not sure that creating a new data
structure does lest it fail to justify the existence of the structure
itself. Therefore, it might be better to create a small series to
convert over several values to start such a structure and perhaps do the
rest over time to reduce the churn..

> IOWs, if we are going to improve this code, it should to be moved to
> a pre-calculated, read-only, per-mount variable so the repeated
> calculation goes away entirely.
> 

I figured replacing the macro was an incremental improvement independent
from how precalculated transaction block reservations might be
structured. TBH, I don't mind the macros as much as others seem to, so
feel free to defer or discard this patch altogether..

> Then the macro/function goes away entirely an is replaced simply
> by mp->m_ialloc_space_res or M_IGEO(mp)->alloc_space_res....
> 

Feel free to comment on my feedback on this in the previous reply..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

