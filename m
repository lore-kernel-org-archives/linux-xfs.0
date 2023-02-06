Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCB9C05027
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Feb 2023 23:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjBFXT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Feb 2023 18:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjBFXTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2023 18:19:52 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58B92410D
        for <linux-xfs@vger.kernel.org>; Mon,  6 Feb 2023 15:19:51 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id bx22so10264224pjb.3
        for <linux-xfs@vger.kernel.org>; Mon, 06 Feb 2023 15:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2aNoOUOkwPG19ep1kqJOR1So9oRWC/IgBXPMNg3jVIY=;
        b=YOs3fV/qoNnTlSY0BBi8Rzm5fWgecTPInY89kfpU6IaVhGCcMNfh+sTP+UNmxiytjG
         khxsCfQnTYbvKAmGhNn8KMhFzxQ++kadvkH94HnnP4dYpF6Vy/XKv1csgwxDO+OYgvBZ
         89tkhKjHFvTe4sQO+pFqJDoGbXl0xHj1urMryPwlnXbNuOOo8yqtY99C2nk48+toCOuC
         QUio2LRHpYWpsLwDjgtYFLJxEMyYUw9pLY7z0ctUa0HNJJvgIeSOdkQ7gSumLEcEkeI0
         TJgbi6UFja9J42hUGjMZJJNN09Zegc3EXtta7ObsWCqWsnby83+Bv3VtNMy9dmxPI9ME
         Vdfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2aNoOUOkwPG19ep1kqJOR1So9oRWC/IgBXPMNg3jVIY=;
        b=jYGcG5ha2Ck5FZSYnfhv4ISNOXcBtawyXf1iWYBQajvnJzHTcCYw/ezvLD0Oh4DE/R
         Kh7zQ4uQe3bGCm849mZ1S9ZMsPhhAf4F8WG3cPRAPSzCzI6/tkJE+2PQu0ZpS36ea74J
         O8G84HZtY5D7un/AgM3bpTpDRqLzoTFSIyl9D3A5S2JwzBxKrLFBxPd6sn3cBlyBdBFg
         j2gwTsd/VStNN4+30Hvab6q6ZYE5zKshOe6HwFYbADrQ2OFurPeK2+1xuDrLTP2qIMLJ
         Ib/Zf0yZJ1w5ZZHRKG61kLDKspOu89CQj/d4kkLVg23notaAGASyaOgmXDD6/MdzLNnn
         4cVQ==
X-Gm-Message-State: AO0yUKUtjRWXx3GwuWkz42IUsN3TI+J13I6bTnvQXygX0rlIrGp2BROa
        Y1pAUX+TK5f1oz1ogKrSkUAKrz0+AjFvS5D/
X-Google-Smtp-Source: AK7set/Z19Tf8JOgEsAw0gzJ9olEmy+Qqp0HQ8HWB+bTtGFCWd61e9UfNGEW2d5TGPsuouGTd5BYfg==
X-Received: by 2002:a17:902:db11:b0:199:2e77:fe5a with SMTP id m17-20020a170902db1100b001992e77fe5amr324940plx.61.1675725591296;
        Mon, 06 Feb 2023 15:19:51 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id d7-20020a170902b70700b001869b988d93sm7450209pls.187.2023.02.06.15.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 15:19:50 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pPAm4-00CE03-Ck; Tue, 07 Feb 2023 10:19:48 +1100
Date:   Tue, 7 Feb 2023 10:19:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/42] xfs: convert trim to use for_each_perag_range
Message-ID: <20230206231948.GZ360264@dread.disaster.area>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-30-david@fromorbit.com>
 <Y9ryg5lY702fdLXL@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9ryg5lY702fdLXL@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 01, 2023 at 03:15:15PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 19, 2023 at 09:44:52AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To convert it to using active perag references and hence make it
> > shrink safe.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_discard.c | 50 ++++++++++++++++++++------------------------
> >  1 file changed, 23 insertions(+), 27 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> > index bfc829c07f03..afc4c78b9eed 100644
> > --- a/fs/xfs/xfs_discard.c
> > +++ b/fs/xfs/xfs_discard.c
> > @@ -21,23 +21,20 @@
> >  
> >  STATIC int
> >  xfs_trim_extents(
> > -	struct xfs_mount	*mp,
> > -	xfs_agnumber_t		agno,
> > +	struct xfs_perag	*pag,
> >  	xfs_daddr_t		start,
> >  	xfs_daddr_t		end,
> >  	xfs_daddr_t		minlen,
> >  	uint64_t		*blocks_trimmed)
> >  {
> > +	struct xfs_mount	*mp = pag->pag_mount;
> >  	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
> >  	struct xfs_btree_cur	*cur;
> >  	struct xfs_buf		*agbp;
> >  	struct xfs_agf		*agf;
> > -	struct xfs_perag	*pag;
> >  	int			error;
> >  	int			i;
> >  
> > -	pag = xfs_perag_get(mp, agno);
> > -
> >  	/*
> >  	 * Force out the log.  This means any transactions that might have freed
> 
> This is a tangent, but one thing I've wondered is if it's really
> necessary to force the log for *every* AG that we want to trim?  Even if
> we've just come from trimming the previous AG?

I suspect the thought behind this is that TRIM operations can be
really slow, so there can be a big build-up of new busy extents as a
large fragmented AG is trimmed.

I don't think it really matters at this point - if you are running a
multi-AG trim range, a few extra log forces is the least of your
performance worries. If someone reports it as a perf problem, let's
look at it then....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
