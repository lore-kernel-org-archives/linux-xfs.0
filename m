Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43295EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 22:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjFOWV0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 18:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjFOWV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 18:21:26 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F71BA
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 15:21:25 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b3c1730fc9so872825ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 15:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686867684; x=1689459684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hSrjDVNTeX1cM3oKeVpUSssXo1BdghsXsn//uV5uaSE=;
        b=udOcOfdYH3WvIANuQ5oBRyqPGl9clnu3hFENNEBTFzmRPmFqcW+BkEcjOIisYc7uNT
         RTzrfprb1WIN8Nuu9ETcBDhjcPO2MERmWb+YsZ+dPASjhIF+N8nXM/cxwFbmDGyWNRdq
         tuCYbKdl51nsTnmZGTKPkdt+mTzcVXUxg7P3zn7V1HrkTq/sQmIvOykX4HXVvMlemHgJ
         Diq11TYiNWCvimorhj36LXXQsQlbGf9b9msTDmFGdnBotfdUrD/jFlgbGpyAxofTdwy0
         rW6dHLi8QFju+dzG3ZRDkxWE1R3YyKtIKPe4OjI6MIgZ6inhpRjYtn790rhePtaSWP0E
         YTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686867684; x=1689459684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSrjDVNTeX1cM3oKeVpUSssXo1BdghsXsn//uV5uaSE=;
        b=L/o46fFG02mIvTCZqZM88oMhfWFQGq3zFgKbTdrDQV84bbl81jYhlPxdx1slz6eeTi
         358PDZVpcQxdLepvGMOWTGWLt6Vd1gp/3fAhQMehxV106ydCybXJRH/33aXGKnBBHHa2
         N9SPUPky67d2LN5KEdsw5zysFO3X+ATjnbQH1H/0+u6vwqLQZWj4ws9Bds1BAHvLcf1j
         oqDgSIKMAPjaG9KxxTMK3Jqxjg9JhmdRuFF33vXUPkGU2k/39+RgIKU9UnieoSwgQ9j3
         OnJpYmt3wwfoKyt2TKy7LqADcJBMwk2NaeU/k/vti0AOEzkJKVtvQ8bN41pUORZEdUHW
         GdlA==
X-Gm-Message-State: AC+VfDzqEBzgzLdic8bFY1wzGdEac0y/6t0b1kSGrgWgGJjEDn/mna/9
        Fo3IOf/xSP6WyJL9TV/SUkuDkg==
X-Google-Smtp-Source: ACHHUZ4L/Jnuw003TClQbOR/CfS1SzINEcDqnkaLFCjC6ej7JGVgNTUla3BvJyOl9TVV98mb4DrrkQ==
X-Received: by 2002:a17:902:e847:b0:1af:a2a4:837f with SMTP id t7-20020a170902e84700b001afa2a4837fmr313410plg.26.1686867684528;
        Thu, 15 Jun 2023 15:21:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id z10-20020a170903018a00b001b1f991a4d0sm14556434plg.108.2023.06.15.15.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 15:21:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q9vLF-00CEfg-1g;
        Fri, 16 Jun 2023 08:21:21 +1000
Date:   Fri, 16 Jun 2023 08:21:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        wen.gang.wang@oracle.com
Subject: Re: [PATCH 2/3] xfs: allow extent free intents to be retried
Message-ID: <ZIuO4UcDpoHAnTWR@dread.disaster.area>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-3-david@fromorbit.com>
 <20230615033837.GM11441@frogsfrogsfrogs>
 <ZIqMIgyHBmZu4jxb@dread.disaster.area>
 <20230615144150.GO11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615144150.GO11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 07:41:50AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 15, 2023 at 01:57:22PM +1000, Dave Chinner wrote:
> > On Wed, Jun 14, 2023 at 08:38:37PM -0700, Darrick J. Wong wrote:
> > > On Thu, Jun 15, 2023 at 11:42:00AM +1000, Dave Chinner wrote:
> > > > +/*
> > > > + * Fill the EFD with all extents from the EFI when we need to roll the
> > > > + * transaction and continue with a new EFI.
> > > > + */
> > > > +static void
> > > > +xfs_efd_from_efi(
> > > > +	struct xfs_efd_log_item	*efdp)
> > > > +{
> > > > +	struct xfs_efi_log_item *efip = efdp->efd_efip;
> > > > +	uint                    i;
> > > > +
> > > > +	ASSERT(efip->efi_format.efi_nextents > 0);
> > > > +
> > > > +	if (efdp->efd_next_extent == efip->efi_format.efi_nextents)
> > > > +		return;
> > > > +
> > > > +	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> > > > +	       efdp->efd_format.efd_extents[i] =
> > > > +		       efip->efi_format.efi_extents[i];
> > > > +	}
> > > > +	efdp->efd_next_extent = efip->efi_format.efi_nextents;
> > > 
> > > Odd question -- if we managed to free half the extents mentioned in an
> > > EFI before hitting -EAGAIN, then efdp->efd_next_extent should already be
> > > half of efip->efi_format.efi_nextents, right?
> > 
> > Yes, on success we normally update the EFD with the extent we just
> > completed and move the EFI/EFD cursors forwards.
> > 
> > > I suppose it's duplicative (or maybe just careful) to recopy the entire
> > > thing... but maybe that doesn't even really matter since no modern xlog
> > > code actually pays attention to what's in the EFD aside from the ID
> > > number.
> > 
> > *nod*
> > 
> > On second thoughts, now that you've questioned this behaviour, I
> > need to go back and check my assumptions about what the intent
> > creation is doing vs the current EFI vs the XEFI we are processing.
> > The new EFI we log shouldn't have the extents we've completed in it,
> > just the ones we haven't run, and I need to make sure that is
> > actually what is happening here.
> 
> That shouldn't be happening -- each of the xfs_free_extent_later calls
> below adds new incore EFIs to an xfs_defer_pending.dfp_work list and
> each xfs_defer_pending itself gets added to xfs_trans.t_dfops.  The
> defer_capture_and_commit function will turn the xfs_defer_pending into a
> new EFI log item with the queued dfp_work items attached.

Yup, I came to that conclusion when I went back over it again last
night. I added a few comments to the function about the methods
we might make to optimise it (i.e. only fill out from
efdp->efd_next_extent to efip->efi_format.efi_nextents) but also the
assumptions they rely on (xefis are always ordered in the same order
the efi extents are ordered) and the landmines that changing xefi
order processing might leave. Hence it's best just to copy the
entire EFI into the EFD and avoid all the possible silent corruption
problems that out-of-order xefi processing might cause...

> IOWs, as long as you don't call xfs_free_extent_later on any of the
> xefi_startblock/blockcount pairs where xfs_trans_free_extent returned 0,
> your assumptions are correct.
> 
> The code presented in this patch is correct.

Thanks for the double-check, I'll get the updated patches out in a
short while...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
