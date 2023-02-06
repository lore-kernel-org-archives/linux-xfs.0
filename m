Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60D8C61DA4
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Feb 2023 23:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjBFX0a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Feb 2023 18:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBFX03 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2023 18:26:29 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FB624484
        for <linux-xfs@vger.kernel.org>; Mon,  6 Feb 2023 15:26:29 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id bd15so9554508pfb.8
        for <linux-xfs@vger.kernel.org>; Mon, 06 Feb 2023 15:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OakCQbhnKis/7zF7b4S90Hj5VG1MpzO/0R+UDRPdyls=;
        b=PUqkKM/dhRKzVOdGCVMMr4qltiTWa19RY4EdJgYxbGEq2X+B3irv8FjcyWBwtgDi1c
         mG17d36G1NLyTrRIkaPd6zuGh33uN0BixdGPx3q3An6qXKvqM2XGOkrZPyDxEJy4CS6H
         pXfn8VK0AlXgm5yaRz+NZJ66eFBHaHJH4+EqTGh9pqHsAVGW1xR9K4ndEcW2NsxLVfSo
         UKseXilrF6lnKheJdTr940DuJYXXahMB4SCfNWpvHWZMJxGSpY4Ovzn+PqmCetoKqMGb
         kvr6kyDNzvupo+Wbq/tGrxOMLxu8H4cufzJr5ykM9zVMdOyo3Aonf64m1sP2jm15Sbub
         dc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OakCQbhnKis/7zF7b4S90Hj5VG1MpzO/0R+UDRPdyls=;
        b=wgBlHScuiqTW6ps1k7m+N9JGqDcxR0aEiQORyVehLTR5Pn6fQLKANPTGjYd/zf5BfY
         7puBMrRSkOUFAU2WqKtpeIyFgFXwL/kQaxekn3lwlAYRjVeEhZtUvxrrA3NFuSXufKf2
         5Bl04ksmhyveHpHxNJ8aBfotuPjl3niACbvNwk6EkMzgyAtC2X4Gzvs/EHwg0OydqVfw
         v+jPwZNtgYmF7lseZ59HEzigUNp1fZc/iHWGf04FEsW7Zo9GR/nRRgoxupQlD1DnrXQp
         2Z7SmOGRLXR+O6g/Gm0D9cWA2iEvB+5ksU8Wv09DS3dJRRqG8y1b6EWKAgclrT9roUR8
         Swkg==
X-Gm-Message-State: AO0yUKUoxThxwZQUY0T6fX1d2psbfxx/d6M+u88wJlCIaofIsAA9Cs/y
        JBuGQmFCGh/WIbTUcyVs840ZiBIwdl+3rbqV
X-Google-Smtp-Source: AK7set/5zkDNWVo/LDnVnDcySmvm+a8u96LMtg0KA/HvWUAlIArtsqNJqPmT+d58e+N+gs/AgmEKqg==
X-Received: by 2002:a62:1c42:0:b0:593:b0f7:8734 with SMTP id c63-20020a621c42000000b00593b0f78734mr1111598pfc.20.1675725988527;
        Mon, 06 Feb 2023 15:26:28 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id y22-20020a056a001c9600b00580978caca7sm7614227pfw.45.2023.02.06.15.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 15:26:28 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pPAsT-00CEEG-4N; Tue, 07 Feb 2023 10:26:25 +1100
Date:   Tue, 7 Feb 2023 10:26:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 42/42] xfs: refactor the filestreams allocator pick
 functions
Message-ID: <20230206232625.GB360264@dread.disaster.area>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-43-david@fromorbit.com>
 <Y9r/ELba/fu2dFuG@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9r/ELba/fu2dFuG@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 01, 2023 at 04:08:48PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 19, 2023 at 09:45:05AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that the filestreams allocator is largely rewritten,
> > restructure the main entry point and pick function to seperate out
> > the different operations cleanly. The MRU lookup function should not
> > handle the start AG selection on MRU lookup failure, and nor should
> > the pick function handle building the association that is inserted
> > into the MRU.
> > 
> > This leaves the filestreams allocator fairly clean and easy to
> > understand, returning to the caller with an active perag reference
> > and a target block to allocate at.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_filestream.c | 247 +++++++++++++++++++++-------------------
> >  fs/xfs/xfs_trace.h      |   9 +-
> >  2 files changed, 132 insertions(+), 124 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> > index 523a3b8b5754..0a1d316ebdba 100644
> > --- a/fs/xfs/xfs_filestream.c
> > +++ b/fs/xfs/xfs_filestream.c
> > @@ -48,19 +48,19 @@ xfs_fstrm_free_func(
> >  }
> >  
> >  /*
> > - * Scan the AGs starting at startag looking for an AG that isn't in use and has
> > - * at least minlen blocks free.
> > + * Scan the AGs starting at start_agno looking for an AG that isn't in use and
> > + * has at least minlen blocks free. If no AG is found to match the allocation
> > + * requirements, pick the AG with the most free space in it.
> >   */
> >  static int
> >  xfs_filestream_pick_ag(
> >  	struct xfs_alloc_arg	*args,
> > -	struct xfs_inode	*ip,
> > +	xfs_ino_t		pino,
> >  	xfs_agnumber_t		start_agno,
> >  	int			flags,
> >  	xfs_extlen_t		*longest)
> >  {
> > -	struct xfs_mount	*mp = ip->i_mount;
> > -	struct xfs_fstrm_item	*item;
> > +	struct xfs_mount	*mp = args->mp;
> >  	struct xfs_perag	*pag;
> >  	struct xfs_perag	*max_pag = NULL;
> >  	xfs_extlen_t		minlen = *longest;
> > @@ -68,8 +68,6 @@ xfs_filestream_pick_ag(
> >  	xfs_agnumber_t		agno;
> >  	int			err, trylock;
> 
> Who consumes trylock?  Is this supposed to get passed through to
> xfs_bmap_longest_free_extent, or is the goal here merely to run the
> for_each_perag_wrap loop twice before going for the most free or any old
> perag?

It was originally used in this loop for directing the AGF locking,
but it looks like I removed all the cases where we we directly read
and lock AGFs in this loop. Hence it's now only used to run the loop
a second time. I'll change it to a boolean flag instead.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
