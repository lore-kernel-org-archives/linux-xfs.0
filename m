Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA86C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 11:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6444B6198B
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 11:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhCVLyS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 07:54:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229614AbhCVLyE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 07:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616414044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sju53puBCe70+I/zyChx6NtZudz4CS3JJNKwJND9zKM=;
        b=DYEduYJxOS5TjLVm8rrc8SzRoKrFUl0oErJaSlboEnJAe6yVGBDLdIqtrhWWjIG/6Fj8Rp
        WC1ck5waJsX1ARtRdQuqUzVC+PzzazYQ6Gg0Nrtn7yrJilyQ+FHwLvOOx4bRv5bxmWdfvk
        q+/p/2udEBZuPXCN5/mHi8dhD5pylkQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-_H_mAhptMxis7WWtlpIwXA-1; Mon, 22 Mar 2021 07:54:01 -0400
X-MC-Unique: _H_mAhptMxis7WWtlpIwXA-1
Received: by mail-pl1-f197.google.com with SMTP id b9so18462407plh.9
        for <linux-xfs@vger.kernel.org>; Mon, 22 Mar 2021 04:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sju53puBCe70+I/zyChx6NtZudz4CS3JJNKwJND9zKM=;
        b=PkxvMSAhAWMP7HBiQq+CjmcrIoEWHhKxVDfjGzC+kJUbe71OjlkgdKI2gn5cSA14ar
         fqWa60H8fxaL8wmWhFhW1XstIrUU1kxv6RFj3fpmzsoRgMeRC1sKNrQ6FfrCPv47maZc
         hgghUhPF/5mC7/dgSfqDfI5b+S6ZivyK4jlHR9PoN5F6CYZDY0ZQlnprDAIMu9HaNxq7
         o66K4Jo6xz+orSKhPMnO2xkEcgZ294wd+5FyOpOvgYRz/maCBkKmz4L0roAYDAJWs/af
         FRmBQuuF5RYjBXTLxo9+zzpf67OTciXbadBdLw4N36YYcRkVBMM+cYlqdAzWMh77/4nv
         TmdQ==
X-Gm-Message-State: AOAM533WxfJkUkIHa3Z/GMm722Ya2ryJ5BIbNWKH39eZOTQN/iME75tv
        1Yx+B7pVBrdGi6cZQ3ByI6VqjKs2ErDa9OXP/jCE4WJck+GghOzwKkT4HLOscCI8cnC39GzbPto
        qBSlXDQwkOqRF8QTnvm6i
X-Received: by 2002:a63:fa05:: with SMTP id y5mr22255587pgh.154.1616414040899;
        Mon, 22 Mar 2021 04:54:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvgVqjug9U/yo4VN8FQL+8DmID2Ur0s/MkYGNcDynRauY9tPgPLIx1bcIwiadwu2RQ7Lxecg==
X-Received: by 2002:a63:fa05:: with SMTP id y5mr22255569pgh.154.1616414040543;
        Mon, 22 Mar 2021 04:54:00 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c25sm13033949pfo.101.2021.03.22.04.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 04:54:00 -0700 (PDT)
Date:   Mon, 22 Mar 2021 19:53:49 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v8 2/5] xfs: hoist out xfs_resizefs_init_new_ags()
Message-ID: <20210322115349.GA2000812@xiangao.remote.csb>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-3-hsiangkao@redhat.com>
 <YFh/R/XMvCXnA3Q9@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFh/R/XMvCXnA3Q9@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 07:28:07AM -0400, Brian Foster wrote:
> On Fri, Mar 05, 2021 at 10:57:00AM +0800, Gao Xiang wrote:
> > Move out related logic for initializing new added AGs to a new helper
> > in preparation for shrinking. No logic changes.
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/xfs_fsops.c | 107 +++++++++++++++++++++++++++------------------
> >  1 file changed, 64 insertions(+), 43 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 9f9ba8bd0213..fc9e799b2ae3 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -20,6 +20,64 @@
> >  #include "xfs_ag.h"
> >  #include "xfs_ag_resv.h"
> >  
> > +/*
> > + * Write new AG headers to disk. Non-transactional, but need to be
> > + * written and completed prior to the growfs transaction being logged.
> > + * To do this, we use a delayed write buffer list and wait for
> > + * submission and IO completion of the list as a whole. This allows the
> > + * IO subsystem to merge all the AG headers in a single AG into a single
> > + * IO and hide most of the latency of the IO from us.
> > + *
> > + * This also means that if we get an error whilst building the buffer
> > + * list to write, we can cancel the entire list without having written
> > + * anything.
> > + */
> > +static int
> > +xfs_resizefs_init_new_ags(
> > +	struct xfs_trans	*tp,
> > +	struct aghdr_init_data	*id,
> > +	xfs_agnumber_t		oagcount,
> > +	xfs_agnumber_t		nagcount,
> > +	xfs_rfsblock_t		delta,
> > +	bool			*lastag_resetagres)
> 
> Nit: I'd just call this lastag_extended or something that otherwise
> indicates what this function reports (as opposed to trying to tell the
> caller what to do).

ok, if other people don't oppose of it.

> 
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + delta;
> > +	int			error;
> > +
> > +	*lastag_resetagres = false;
> > +
> > +	INIT_LIST_HEAD(&id->buffer_list);
> > +	for (id->agno = nagcount - 1;
> > +	     id->agno >= oagcount;
> > +	     id->agno--, delta -= id->agsize) {
> > +
> > +		if (id->agno == nagcount - 1)
> > +			id->agsize = nb - (id->agno *
> > +					(xfs_rfsblock_t)mp->m_sb.sb_agblocks);
> > +		else
> > +			id->agsize = mp->m_sb.sb_agblocks;
> > +
> > +		error = xfs_ag_init_headers(mp, id);
> > +		if (error) {
> > +			xfs_buf_delwri_cancel(&id->buffer_list);
> > +			return error;
> > +		}
> > +	}
> > +
> > +	error = xfs_buf_delwri_submit(&id->buffer_list);
> > +	if (error)
> > +		return error;
> > +
> > +	xfs_trans_agblocks_delta(tp, id->nfree);
> > +
> > +	if (delta) {
> > +		*lastag_resetagres = true;
> > +		error = xfs_ag_extend_space(mp, tp, id, delta);
> > +	}
> > +	return error;
> > +}
> > +
> >  /*
> >   * growfs operations
> >   */
> ...
> > @@ -123,9 +145,8 @@ xfs_growfs_data_private(
> >  	 */
> >  	if (nagcount > oagcount)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > -	if (nb > mp->m_sb.sb_dblocks)
> > -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
> > -				 nb - mp->m_sb.sb_dblocks);
> > +	if (delta > 0)
> > +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
> 
> Hm.. isn't delta still unsigned as of this patch?

Not sure if some difference exists, I could update it as "if (delta)",
therefore it seems [PATCH v8 4/5] won't modify this anymore.

Thanks,
Gao Xiang

> 
> Brian
> 
> >  	if (id.nfree)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> >  
> > @@ -152,7 +173,7 @@ xfs_growfs_data_private(
> >  	 * If we expanded the last AG, free the per-AG reservation
> >  	 * so we can reinitialize it with the new size.
> >  	 */
> > -	if (delta) {
> > +	if (lastag_resetagres) {
> >  		struct xfs_perag	*pag;
> >  
> >  		pag = xfs_perag_get(mp, id.agno);
> > -- 
> > 2.27.0
> > 
> 

