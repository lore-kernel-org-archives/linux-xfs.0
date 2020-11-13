Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8412C388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 05:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F74120B80
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 05:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6S6k+vS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgKMFLN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 00:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgKMFLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 00:11:12 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE362C0613D1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 21:11:12 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id a18so6643750pfl.3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 21:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wLpIfp4PAh/DQQiDFSxanr0FT6rvuEuuUJ5YfIVwHbg=;
        b=l6S6k+vSczYxmdfqO+SwU0IONMAjJK5SW9bfD8D0OohDO7+9VrIqhtoNUhJVJjOMgp
         O1tT1mapFpbJwjEYGWGtuWQbE2mPDNbS3TkdObzCSpyS01+eZD1vwjEDcjlv8vRPjQFQ
         LuedytzC3+CvfHBr199ExAFw8bupxARpWGBASgYs8AmNgAZ11THKSueY9McOghTKsNqg
         8Xahy6Zn1UUjeOKDQxVcFBMjkbTrd3qXlhZ8hScyKGzQn7JpLxV97fiwX0xqwuB+maLR
         qq14454853cKZWKEflx9Vl0kbseS+v9RVKSYf10ybnklMdRoU0vM8Or+ruKDPdkpPBy2
         yLiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wLpIfp4PAh/DQQiDFSxanr0FT6rvuEuuUJ5YfIVwHbg=;
        b=cK/LxkzIBuYeEnKSHrfZBXBE9hOXe9ZT/JCnL7MK1ZGwwpfynVTjJf63BatFJH0fgp
         xL2YWUym9OZa09TWP21Exi8f3m310HzRgeLXcgTkezAo+wXku2zSP1jibF3nBQIGE+VP
         fuPdK2FbHY42R+a0KjS3xMdkuJKsMehv6CSYhpZ9eH/h0c2c3cVYqmSgnXu4Xa+CIjol
         uKUbHpWT92WhtXo/ygSICANLfVWyKGIThjmO2B2rt1toTGd5B6myR8Hp8QybyA9bqC8Z
         gAj464RUEZA/m8BV9T1blRYd+7kFGqqQH2dBNq9GXbsbo2osWMZkeOCOEIz6+C2RlIm5
         4BSQ==
X-Gm-Message-State: AOAM530yeeNTGTsjLgRMUQwiISbkFpB6brJVTdsuv/RbnInxkHziJijD
        V1tRP9b27nT45EJKd51qD7DgtfdJMx4=
X-Google-Smtp-Source: ABdhPJxoepVsXOipGI3mr7RSCeQ4skkuPSYeRf1QaKN90Ju3kbaMcGXhi9yk3E5JCV8nZbnIFwaS6w==
X-Received: by 2002:aa7:82d0:0:b029:18b:d594:9dc5 with SMTP id f16-20020aa782d00000b029018bd5949dc5mr463365pfn.63.1605244272080;
        Thu, 12 Nov 2020 21:11:12 -0800 (PST)
Received: from garuda.localnet ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id s15sm12865pfd.33.2020.11.12.21.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 21:11:11 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/4] xfs: fix brainos in the refcount scrubber's rmap fragment processor
Date:   Fri, 13 Nov 2020 10:41:08 +0530
Message-ID: <15587351.igeZXGC4du@garuda>
In-Reply-To: <20201112160526.GS9695@magnolia>
References: <160494585293.772802.13326482733013279072.stgit@magnolia> <3965877.p3O8HGrD7x@garuda> <20201112160526.GS9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday 12 November 2020 9:35:26 PM IST Darrick J. Wong wrote:
> On Thu, Nov 12, 2020 at 06:21:52PM +0530, Chandan Babu R wrote:
> > On Monday 9 November 2020 11:47:39 PM IST Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Fix some serious WTF in the reference count scrubber's rmap fragment
> > > processing.  The code comment says that this loop is supposed to move
> > > all fragment records starting at or before bno onto the worklist, but
> > > there's no obvious reason why nr (the number of items added) should
> > > increment starting from 1, and breaking the loop when we've added the
> > > target number seems dubious since we could have more rmap fragments that
> > > should have been added to the worklist.
> > > 
> > > This seems to manifest in xfs/411 when adding one to the refcount field.
> > > 
> > > Fixes: dbde19da9637 ("xfs: cross-reference the rmapbt data with the refcountbt")
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/scrub/refcount.c |    8 +++-----
> > >  1 file changed, 3 insertions(+), 5 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> > > index beaeb6fa3119..dd672e6bbc75 100644
> > > --- a/fs/xfs/scrub/refcount.c
> > > +++ b/fs/xfs/scrub/refcount.c
> > > @@ -170,7 +170,6 @@ xchk_refcountbt_process_rmap_fragments(
> > >  	 */
> > >  	INIT_LIST_HEAD(&worklist);
> > >  	rbno = NULLAGBLOCK;
> > > -	nr = 1;
> > >  
> > >  	/* Make sure the fragments actually /are/ in agbno order. */
> > >  	bno = 0;
> > > @@ -184,15 +183,14 @@ xchk_refcountbt_process_rmap_fragments(
> > >  	 * Find all the rmaps that start at or before the refc extent,
> > >  	 * and put them on the worklist.
> > >  	 */
> > > +	nr = 0;
> > >  	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
> > > -		if (frag->rm.rm_startblock > refchk->bno)
> > > -			goto done;
> > > +		if (frag->rm.rm_startblock > refchk->bno || nr > target_nr)
> > > +			break;
> > 
> > In the case of fuzzed refcnt value of 1, The condition "nr > target_nr" causes
> > "nr != target_nr" condition (appearing after the loop) to evaluate to true
> > (since atleast two rmap entries would be present for the refcount extent)
> > which in turn causes xchk_refcountbt_xref_rmap() to flag the data structure as
> > corrupt. Please let me know if my understanding of the code flow is correct?
> 
> Right.
>
Ok. In that case the code change in this patch is handling the erroneous
scenario correctly.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> --D
> 
> > >  		bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
> > >  		if (bno < rbno)
> > >  			rbno = bno;
> > >  		list_move_tail(&frag->list, &worklist);
> > > -		if (nr == target_nr)
> > > -			break;
> > >  		nr++;
> > >  	}
> > >  
> > > 
> > > 
> > 
> > 
> 


-- 
chandan



