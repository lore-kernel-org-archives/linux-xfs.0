Return-Path: <SRS0=cXLJ=75=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA46C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 17:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59B4A20707
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 17:26:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hmhpkq9p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgFPR0l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Jun 2020 13:26:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33564 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727819AbgFPR0l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jun 2020 13:26:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592328399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Y53GRFBq5VJe2oMe48Ik2UiQmCPxtWevpCTRkVrZ0E=;
        b=Hmhpkq9pByiAXZbOedhOu0DPPry+isAmRB4SSPx2K5WPIS5zdc5QS8M3R9+CZcORQPT+Y2
        PKaaADJ6QMBZ9hTMoBQm90RrLVq++Dv0gGFs0zy4O9JBl6K5AzbhkQ5lfV2wAWNbpcPYQx
        c2xpfZBpY6jndvlnk8mslWQUEP8vSJY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-1QYCnDyzNCCgIRt9FEJEfQ-1; Tue, 16 Jun 2020 13:26:37 -0400
X-MC-Unique: 1QYCnDyzNCCgIRt9FEJEfQ-1
Received: by mail-pj1-f69.google.com with SMTP id nh9so2742368pjb.6
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2020 10:26:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4Y53GRFBq5VJe2oMe48Ik2UiQmCPxtWevpCTRkVrZ0E=;
        b=jLRdN2ThzWmq5TzpjpaD0v1cZNI4yy8O+4tkj0Cr5XsfLN4IPFws/ZaIjovGG8YAPP
         tbsFhfupBgDKwQSijAH7tXWGBrgnTbGgIPq+8QKZ6uJFg/9jvc9AYabam4dcfud+//D7
         d+VUZ6WYwzvrmq9xVmA02sSGx/LVyebvkkt+ZW8o+1/x0chP6AdWGsQEdf5DTldtC30L
         66ZVJP/EvJkJgoE1Pt6LZdYfdlqGFk3+rOflLDijbXQbJaTJ2Ynwmvu6DfQew3rze2DN
         kwjAIdhA9YXCMZ4DRmcIM2YwwIxr8eYouO5S9JHaBmEY+d6aRYuSaxwCfuZujOULg8Ju
         HLZg==
X-Gm-Message-State: AOAM531lA6NoDyirm+oY/HBcfLFn/wpC6WHGuX+jaVokKMq7Zt2JKOjy
        mp7Ifu/u9UTIQ0NjsZjdGnKZqAtQ1yx8GNKxbzsB89FFE2tBmj2DyMU5n36Dq1vVH51X5L54lnv
        Jpyed1LlWvjqlH9rpJeC9
X-Received: by 2002:a17:902:7c16:: with SMTP id x22mr2970500pll.66.1592328396875;
        Tue, 16 Jun 2020 10:26:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ50ZM2xSQ5E40C/J0X129Mk04vbum7GRRJjLiqSqU8aWz2w/Fk988vB38U2E36TiaH6LnKQ==
X-Received: by 2002:a17:902:7c16:: with SMTP id x22mr2970472pll.66.1592328396573;
        Tue, 16 Jun 2020 10:26:36 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x11sm18191417pfq.169.2020.06.16.10.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 10:26:36 -0700 (PDT)
Date:   Wed, 17 Jun 2020 01:26:25 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH v3] xfs_repair: fix rebuilding btree block less than
 minrecs
Message-ID: <20200616172625.GA7818@xiangao.remote.csb>
References: <20200610035842.22785-1-hsiangkao@redhat.com>
 <20200610052624.7425-1-hsiangkao@redhat.com>
 <20200616161143.GM11245@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616161143.GM11245@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Tue, Jun 16, 2020 at 09:11:43AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 10, 2020 at 01:26:24PM +0800, Gao Xiang wrote:
> > In production, we found that sometimes xfs_repair phase 5
> > rebuilds freespace node block with pointers less than minrecs
> > and if we trigger xfs_repair again it would report such
> > the following message:
> > 
> > bad btree nrecs (39, min=40, max=80) in btbno block 0/7882
> > 
> > The background is that xfs_repair starts to rebuild AGFL
> > after the freespace btree is settled in phase 5 so we may
> > need to leave necessary room in advance for each btree
> > leaves in order to avoid freespace btree split and then
> > result in AGFL rebuild fails. The old mathematics uses
> > ceil(num_extents / maxrecs) to decide the number of node
> > blocks. That would be fine without leaving extra space
> > since minrecs = maxrecs / 2 but if some slack was decreased
> > from maxrecs, the result would be larger than what is
> > expected and cause num_recs_pb less than minrecs, i.e:
> > 
> > num_extents = 79, adj_maxrecs = 80 - 2 (slack) = 78
> > 
> > so we'd get
> > 
> > num_blocks = ceil(79 / 78) = 2,
> > num_recs_pb = 79 / 2 = 39, which is less than
> > minrecs = 80 / 2 = 40
> > 
> > OTOH, btree bulk loading code behaves in a different way.
> > As in xfs_btree_bload_level_geometry it wrote
> > 
> > num_blocks = floor(num_extents / maxrecs)
> > 
> > which will never go below minrecs. And when it goes above
> > maxrecs, just increment num_blocks and recalculate so we
> > can get the reasonable results.
> > 
> > Later, btree bulk loader will replace the current repair code.
> > But we may still want to look for a backportable solution
> > for stable versions. Hence, keep the same logic to avoid
> > the freespace as well as rmap btree minrecs underflow for now.
> > 
> > Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> > Cc: Dave Chinner <dchinner@redhat.com>
> > Cc: Eric Sandeen <sandeen@sandeen.net>
> > Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > changes since v2:
> >  still some minor styling fix (ASSERT, args)..
> > 
> > changes since v1:
> >  - fix indentation, typedefs, etc code styling problem
> >    pointed out by Darrick;
> > 
> >  - adapt init_rmapbt_cursor to the new algorithm since
> >    it's similar pointed out by Darrick; thus the function
> >    name remains the origin compute_level_geometry...
> >    and hence, adjust the subject a bit as well.
> > 
> >  repair/phase5.c | 152 ++++++++++++++++++++----------------------------
> >  1 file changed, 63 insertions(+), 89 deletions(-)
> > 
> > diff --git a/repair/phase5.c b/repair/phase5.c
> > index abae8a08..d30d32b2 100644
> > --- a/repair/phase5.c
> > +++ b/repair/phase5.c
> > @@ -348,11 +348,32 @@ finish_cursor(bt_status_t *curs)
> >   * failure at runtime. Hence leave a couple of records slack space in
> >   * each block to allow immediate modification of the tree without
> >   * requiring splits to be done.
> > - *
> > - * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
> >   */
> > -#define XR_ALLOC_BLOCK_MAXRECS(mp, level) \
> > -	(libxfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
> > +static void
> > +compute_level_geometry(
> > +	struct xfs_mount	*mp,
> > +	struct bt_stat_level	*lptr,
> > +	uint64_t		nr_this_level,
> 
> Probably didn't need a u64 here, but <shrug> that's probably just my
> kernel-coloured glasses. :)

Yeah, I personally tend to use kernel type u64 in my own projects, but I'm not
sure what's preferred here...

> 
> > +	int			slack,
> > +	bool			leaf)
> > +{
> > +	unsigned int		maxrecs = mp->m_alloc_mxr[!leaf];
> > +	unsigned int		desired_npb;
> > +
> > +	desired_npb = max(mp->m_alloc_mnr[!leaf], maxrecs - slack);
> > +	lptr->num_recs_tot = nr_this_level;
> > +	lptr->num_blocks = max(1ULL, nr_this_level / desired_npb);
> > +
> > +	lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
> > +	lptr->modulo = nr_this_level % lptr->num_blocks;
> > +	if (lptr->num_recs_pb > maxrecs ||
> > +	    (lptr->num_recs_pb == maxrecs && lptr->modulo)) {
> > +		lptr->num_blocks++;
> > +
> > +		lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
> > +		lptr->modulo = nr_this_level % lptr->num_blocks;
> > +	}
> 
> Seems to be more or less the same solution that I (half unknowingly)
> coded into the btree bulkload geometry calculator, so:
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks for the review... And I checked all xfs-repair related fstests
and it seems no noticable strange...

> 
> (Still working on adapting the new phase5 code to try to fill the AGFL
> as part of rebuilding the free space btrees, fwiw.)

Good news... although I still have limited knowledge to the whole XFS
(now stuggling in reading XFS logging system...)

Thanks,
Gao Xiang

> 
> --D
> 

