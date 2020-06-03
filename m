Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C935C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D874720734
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bPoQscla"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgFCAtb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 20:49:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51641 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726112AbgFCAtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 20:49:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591145369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ju8bvglXO4kKD0PJAXwt5wrckQPdPGfmxUSJ9uBGmYg=;
        b=bPoQsclasS4seHgfoSVUXz+7WFlw7VpDEOY6HRB1uAzN8LtYGh0RGYJpri83wi2fzMC6MZ
        pTzVbAeYDyrOQJixsxU9D1zZlCwK38FjkJcr5TJnCvS1df6L7wj53YHgPmPRxxXI2jOTBp
        BqMxaqFqqQ7rmzs0Q4OD0aM2eqcUqNc=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-K8uuFqSYN6mNrR6q-dZmQg-1; Tue, 02 Jun 2020 20:49:27 -0400
X-MC-Unique: K8uuFqSYN6mNrR6q-dZmQg-1
Received: by mail-pg1-f199.google.com with SMTP id x132so743704pgx.22
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jun 2020 17:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ju8bvglXO4kKD0PJAXwt5wrckQPdPGfmxUSJ9uBGmYg=;
        b=JPEUvGUOPWwmJtpYXIJo1tMykrwjCAF/GauDSCka9VoQN0hIch0y1NYK8T3PnE/wAk
         XsXuvUQyFkr/KkFvpFEaGC8LqSRmcWgzAy1r9pUCvY2r/J9AfK7KeB5KGtCLgOWQQeDY
         WKRayz5Tli9lF8G/rSlITn1entDNxywcTi/3GQoDTj+SueD23CvJeLUPHTWMQTNdqIYh
         ii7mgibdf/xzBolN97UjAe/g/RRGsNA7pzQYGg3kup3TqcFgWFk51NNQSuPTCyDkTAHh
         /gC2ps2SXzW7uFLj5VmoidN3yE8tJnpmv4DkySKLbxl4hYIJhdBPW+o3KGXc/gKHAQoB
         w6vg==
X-Gm-Message-State: AOAM531fsTEbMeLESS/Oj5eYPZYvVqtB473/w/CbcdwwtHFX9vGPdvQV
        khdhsUL7sFgy6oZb07ih952WvNikQDphd0fFBfgx6sf/HuPrn3pCg6HH3hlWZK+IFPCmo4KGHeA
        rqiIvsNvUgLsx5QRRJwnw
X-Received: by 2002:a62:25c2:: with SMTP id l185mr10489294pfl.58.1591145366566;
        Tue, 02 Jun 2020 17:49:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz05SwY3/9H8CcsiJ7cmsXUKu/aqltKiP6rnzM22tpDQPCnMGcngrWEK1Z/m3B3JEMMgaZ4Gg==
X-Received: by 2002:a62:25c2:: with SMTP id l185mr10489271pfl.58.1591145366290;
        Tue, 02 Jun 2020 17:49:26 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l14sm216562pjh.50.2020.06.02.17.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 17:49:25 -0700 (PDT)
Date:   Wed, 3 Jun 2020 08:49:16 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200603004916.GA16546@xiangao.remote.csb>
References: <20200602145238.1512-1-hsiangkao@redhat.com>
 <20200603002222.GU8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603002222.GU8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Tue, Jun 02, 2020 at 05:22:22PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 02, 2020 at 10:52:38PM +0800, Gao Xiang wrote:
> > Sometimes no need to play with perag_tree since for many
> > cases perag can also be accessed by agbp reliably.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > Not sure addressing all the cases, but seems mostly.
> > Kindly correct me if something wrong somewhere...
> > 
> >  fs/xfs/libxfs/xfs_ag.c             |  4 ++--
> >  fs/xfs/libxfs/xfs_alloc.c          | 22 ++++++-----------
> >  fs/xfs/libxfs/xfs_alloc_btree.c    | 10 ++++----
> >  fs/xfs/libxfs/xfs_ialloc.c         | 28 ++++++----------------
> >  fs/xfs/libxfs/xfs_refcount_btree.c |  5 ++--
> >  fs/xfs/libxfs/xfs_rmap_btree.c     |  5 ++--
> >  fs/xfs/xfs_inode.c                 | 38 +++++++++---------------------
> >  7 files changed, 35 insertions(+), 77 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index 9d84007a5c65..8cf73fe4338e 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -563,7 +563,8 @@ xfs_ag_get_geometry(
> >  	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
> >  	if (error)
> >  		goto out_agi;
> > -	pag = xfs_perag_get(mp, agno);
> > +
> > +	pag = agi_bp->b_pag;
> >  
> >  	/* Fill out form. */
> >  	memset(ageo, 0, sizeof(*ageo));
> > @@ -583,7 +584,6 @@ xfs_ag_get_geometry(
> >  	xfs_ag_geom_health(pag, ageo);
> >  
> >  	/* Release resources. */
> > -	xfs_perag_put(pag);
> 
> Looks like a reaosnable pattern throughout the codebase.  Did fstests
> cough up any new errors?

Actually I add more extra ASSERTs (to check pag_agno vs agno) around
all the cases (many of them aren't shown in this patch), and have been
running fstests and fsstress with ASSERT version for a while. It seems
no visible crash. But I'm not sure how many exist failures are (at least
no panic yells out)...

> 
> >  	xfs_buf_relse(agf_bp);

...

> > -		xfs_perag_put(pag);
> > -	return error;
> > +	/* Point the head of the list to the next unlinked inode. */
> > +	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
> > +			next_agino);
> 
> Why not cut out the agno argument here too?  Surely you could obtain it
> from agibp->b_pag->pag_agno.  Ditto for xfs_iunlink_map_prev.

Okay, thanks for pointing out... I think there are many indirect
potential cleanups indeed.... Will fix the above cases in the
next version...

Thanks,
Gao Xiang

> 
> --D
> 
> >  }
> >  
> >  /*
> > -- 
> > 2.18.1
> > 
> 

