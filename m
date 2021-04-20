Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BBEC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 16:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C064E613CD
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 16:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhDTQX0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 12:23:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232174AbhDTQX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 12:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618935774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Ixv/8Zy/OmKtNfgkhWCSVuxjHsRhrWJnyARd9Tafqw=;
        b=Uul8JKQLLLk8Ky2BhMNlgjprQ6LeT6u43ewTq9Gg59DzJnusY7o29YNaBqS2qTUKTJ4KZK
        XHgjWQ4d7dScM11N5Tpyw5oQXo7KSN1m+d5hhcma0uv/2hOV5bENv6ob8UZoki0m+cCVEs
        O6K9Ii7f+7+zEnybNsbM4ixa5NpuWhs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-nSl1xQsbNUGYH0LDc2ohlA-1; Tue, 20 Apr 2021 12:22:52 -0400
X-MC-Unique: nSl1xQsbNUGYH0LDc2ohlA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10B488189C6;
        Tue, 20 Apr 2021 16:22:51 +0000 (UTC)
Received: from bfoster (ovpn-112-38.rdu2.redhat.com [10.10.112.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A813E5D9CA;
        Tue, 20 Apr 2021 16:22:50 +0000 (UTC)
Date:   Tue, 20 Apr 2021 12:22:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is
 active
Message-ID: <YH7/2P4SHHAJjaar@bfoster>
References: <20210412133059.1186634-1-bfoster@redhat.com>
 <20210412133059.1186634-2-bfoster@redhat.com>
 <20210414004950.GW3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414004950.GW3957620@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 05:49:50PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 12, 2021 at 09:30:58AM -0400, Brian Foster wrote:
> > perag reservation is enabled at mount time on a per AG basis. The
> > upcoming in-core allocation btree accounting mechanism needs to know
> > when reservation is enabled and that all perag AGF contexts are
> > initialized. As a preparation step, set a flag in the mount
> > structure and unconditionally initialize the pagf on all mounts
> > where at least one reservation is active.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag_resv.c | 24 ++++++++++++++----------
> >  fs/xfs/xfs_mount.h          |  1 +
> >  2 files changed, 15 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> > index 6c5f8d10589c..9b2fc4abad2c 100644
> > --- a/fs/xfs/libxfs/xfs_ag_resv.c
> > +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> > @@ -254,6 +254,7 @@ xfs_ag_resv_init(
> >  	xfs_extlen_t			ask;
> >  	xfs_extlen_t			used;
> >  	int				error = 0;
> > +	bool				has_resv = false;
> >  
> >  	/* Create the metadata reservation. */
> >  	if (pag->pag_meta_resv.ar_asked == 0) {
> > @@ -291,6 +292,8 @@ xfs_ag_resv_init(
> >  			if (error)
> >  				goto out;
> >  		}
> > +		if (ask)
> > +			has_resv = true;
> >  	}
> >  
> >  	/* Create the RMAPBT metadata reservation */
> > @@ -304,18 +307,19 @@ xfs_ag_resv_init(
> >  		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_RMAPBT, ask, used);
> >  		if (error)
> >  			goto out;
> > +		if (ask)
> > +			has_resv = true;
> >  	}
> >  
> > -#ifdef DEBUG
> > -	/* need to read in the AGF for the ASSERT below to work */
> > -	error = xfs_alloc_pagf_init(pag->pag_mount, tp, pag->pag_agno, 0);
> > -	if (error)
> > -		return error;
> > -
> > -	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> > -	       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> > -	       pag->pagf_freeblks + pag->pagf_flcount);
> > -#endif
> > +	if (has_resv) {
> > +		mp->m_has_agresv = true;
> 
> If the metadata reservation succeeds but the rmapbt reservation fails
> with ENOSPC, won't we fail to set m_has_agresv true here?  We don't fail
> the entire mount if ENOSPC happens, which means that there's a slight
> chance of doing the wrong thing here if all the AGs are (somehow) like
> that.
> 

Yes it looks like we would skip setting the mount flag (and initializing
the pagf). I suppose we should probably just lift the out label up
before this whole branch.

Brian

> --D
> 
> > +		error = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, 0);
> > +		if (error)
> > +			return error;
> > +		ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> > +		       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> > +		       pag->pagf_freeblks + pag->pagf_flcount);
> > +	}
> >  out:
> >  	return error;
> >  }
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 81829d19596e..8847ffd29777 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -139,6 +139,7 @@ typedef struct xfs_mount {
> >  	bool			m_fail_unmount;
> >  	bool			m_finobt_nores; /* no per-AG finobt resv. */
> >  	bool			m_update_sb;	/* sb needs update in mount */
> > +	bool			m_has_agresv;	/* perag reservations active */
> >  
> >  	/*
> >  	 * Bitsets of per-fs metadata that have been checked and/or are sick.
> > -- 
> > 2.26.3
> > 
> 

