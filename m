Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75065C41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 09:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DB8120853
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 09:21:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ffK+bx+k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgJFJVa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFJVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 05:21:30 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D148C061755
        for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2020 02:21:30 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bb1so924038plb.2
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2020 02:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XTDO6CnEkPdKtZ6CGXgI79glzvT2m80ekw2sM7FY4ZA=;
        b=ffK+bx+kCYIFDI2+SbuofnNfgcy/C7ViWXpe8Zoozl7OzSLWSWtY5rT11gAtA+b6Uk
         S+wmDmk5F8C3svEypYZ/YFllfndc7G6U29sq1QeHESGR9lcMUIFxjkFVc8b2S283dGWf
         I/wyHb8jSnT9M056PMM9K9GL0EWGeb7qlGm2+bF0hurs/uVbGkH8F1reZSO2f4pM7Go+
         uHX+acRDO+dbpBtczqBxReHubL5VmcsDPHbp7b82BboR+RAuKPQbzdYsY+Cp5kTwkvjU
         5osi68Ncx3SBMke0dvBPYx3mW9VrktUereQwBiLsDNzjoPPjnGsSVlzE/5UNIhV9WROQ
         J/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XTDO6CnEkPdKtZ6CGXgI79glzvT2m80ekw2sM7FY4ZA=;
        b=tyzyBjn89xMsKdVlAjUcDPMEhXgm4/2ZFE5DwCpHuoaltLrTMbmyK79eXqpR94iNla
         prhZWdb4dDnCpUkZmcUkvgg41Up+uu6jk2VoBGaH/8VSbMfrGcY97iZk6YePcaH4SUuN
         6CHsnUJXQQIUPa15DXo0nC6Z8gYmHzOemsJf1cZ7hPOUqj3wIzBMKzgoBNwGVXrnV98y
         wn3jk5Ysj2ZGxljrWg6Zdm1zgkHm8zHaC4VSLj//BvahRNqdn0jGL5iFUy+GTkyjJLEa
         ykeafCX5vHZ/LgJYGoUCuz3K2AA7gNlvE3hRS3HfSQaFemLSWBYWxVwaHJKMH3qJ2Mwl
         fOKw==
X-Gm-Message-State: AOAM532Ew2/Z2swHV2/tApTf9mMw22Gi0TXzRxyAEc7iRADYDyo5TwNF
        O8ssw+13UlORgF5IXyqLITk6sET/zJM=
X-Google-Smtp-Source: ABdhPJxh0ePdSpNG8MoCtlNRi2Yq875fho2Y8t0p/KBO728dVK2u/qRKvJnPGZIQiM0C6S3s8NiPgA==
X-Received: by 2002:a17:902:424:b029:d2:8cdd:dc00 with SMTP id 33-20020a1709020424b02900d28cdddc00mr2477616ple.7.1601976089972;
        Tue, 06 Oct 2020 02:21:29 -0700 (PDT)
Received: from garuda.localnet ([122.167.153.52])
        by smtp.gmail.com with ESMTPSA id d145sm2978053pfd.136.2020.10.06.02.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 02:21:29 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 11/12] xfs: Set tp->t_firstblock only once during a transaction's lifetime
Date:   Tue, 06 Oct 2020 10:47:44 +0530
Message-ID: <10831280.vcUPTnr8uI@garuda>
In-Reply-To: <20201006042629.GQ49547@magnolia>
References: <20201003055633.9379-1-chandanrlinux@gmail.com> <20201003055633.9379-12-chandanrlinux@gmail.com> <20201006042629.GQ49547@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 6 October 2020 9:56:29 AM IST Darrick J. Wong wrote:
> On Sat, Oct 03, 2020 at 11:26:32AM +0530, Chandan Babu R wrote:
> > tp->t_firstblock is supposed to hold the first fs block allocated by the
> > transaction. There are two cases in the current code base where
> > tp->t_firstblock is assigned a value unconditionally. This commit makes
> > sure that we assign to tp->t_firstblock only if its current value is
> > NULLFSBLOCK.
> 
> Do we hit this currently?  This seems like a regression fix, since I'm
> guessing you hit this fairly soon after adding the next patch and
> twisting the "shatter everything" debug knob it establishes?  And if
> you can hit it there, you could hit this on a severely fragmented fs?

I came across this when I was trying to understand the code flow w.r.t
xfs_bmap_btalloc() => xfs_alloc_vextent() => etc. I noticed that if a
transaction does the following,

1. Satisfy the first allocation request from AG X.
2. Satisfy the second allocation request from AG X+1, since say the second
   allocation request was for a larger minlen value.

... A new space allocation request with minlen equal to what was issued in
step 1 could fail (even though AG X could still have minlen free space)
because step 2 ended up updating tp->t_firstblock to a block from AG X+1 and
hence AG X could never be scanned for free blocks even though the transaction
holds a lock on the corresponding AGF.

This behaviour is most likely true when the "alloc minlen" debug knob
(introduced in the next patch) is enabled. However I didn't execute any
workload on a severly fragmented fs to actually see this behaviour on a
mounted filesystem.

> 
> --D
> 
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 51c2d2690f05..5156cbd476f2 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -724,7 +724,8 @@ xfs_bmap_extents_to_btree(
> >  	 */
> >  	ASSERT(tp->t_firstblock == NULLFSBLOCK ||
> >  	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
> > -	tp->t_firstblock = args.fsbno;
> > +	if (tp->t_firstblock == NULLFSBLOCK)
> > +		tp->t_firstblock = args.fsbno;
> >  	cur->bc_ino.allocated++;
> >  	ip->i_d.di_nblocks++;
> >  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
> > @@ -875,7 +876,8 @@ xfs_bmap_local_to_extents(
> >  	/* Can't fail, the space was reserved. */
> >  	ASSERT(args.fsbno != NULLFSBLOCK);
> >  	ASSERT(args.len == 1);
> > -	tp->t_firstblock = args.fsbno;
> > +	if (tp->t_firstblock == NULLFSBLOCK)
> > +		tp->t_firstblock = args.fsbno;
> >  	error = xfs_trans_get_buf(tp, args.mp->m_ddev_targp,
> >  			XFS_FSB_TO_DADDR(args.mp, args.fsbno),
> >  			args.mp->m_bsize, 0, &bp);
> 


-- 
chandan



