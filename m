Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A73DEB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 22:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbjF2Wee (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 18:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbjF2WeP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 18:34:15 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E919B3A8F
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 15:33:49 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id 006d021491bc7-56368c40e8eso795388eaf.0
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 15:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688078029; x=1690670029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CYG1Usij2GneckIcTFPitCB8yB57x3UC7Dpje0dt3FQ=;
        b=bN6nbUSpixsIQoloijtE6EiIdiDv0Pu/wHj+rJX6+HeW6e5tlTT9sR04Mx2QCUsFc4
         Lhk9nlK3nIgC/5w0Of/QPAATSNavt4eJwaDIpmNdvFwWY9xdq9TKc7ryY8kLsIIyO6qe
         5yQEPEnqt9K862h/V4FGV28nDUfeL7hQZEvRc92cjOHH/XtXe7fL8u58nb8leWEGbdyY
         MAcRCmWomspnki4d3yE+bTk4lr5kvmz/bvH5ljvZlf5FcUpMWi62DhGbi4Lok3a6Urdt
         JanOm3UZ0riEIeJYjfQTk3OX3gnBpoEfA9lo9/i6UrdHrf8U1eoTl3ws51gFXIvb42HP
         cJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688078029; x=1690670029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CYG1Usij2GneckIcTFPitCB8yB57x3UC7Dpje0dt3FQ=;
        b=cSpSmF0/a+LK/RQFH6mBvvpmNUgdUVsIZFLTz6SJ+ZPZFd2vY9GiFpvrZ42mupnb5i
         SRe7RT0Qq4Jrg0qlS+Medw5/PiajwfXuPDkdaScvCvW8DGKMM4lnRQsUHj2CNO7D0TKx
         UkQPpy3ZIEFv0PgzYR0tEOStpaJbyx+lOGq+QsmJiSkhF83VhhySngYTiPJRLphDFgN7
         0Xl+BGBaSEgdKYVY2H8UeOQaLrSHtLtMs0fUBlihtR775Wnt8+hFIxGK87B15tdPteR6
         OEEFdwjrSjK5c+JtlP+ryzyn9a/InsRgziydy8FXM75QOvWINM5Kx1VC6TxCKOv5bPrQ
         GQEw==
X-Gm-Message-State: AC+VfDyQZYNPBNFf9SDs3WUggZ/9KHLsLfSKr1Kt0M8tUDdCWvvOrh8D
        JWuhEPzEbmgZP19nMeu6plmtprSND7rg0NmCWC8=
X-Google-Smtp-Source: ACHHUZ6C++Waa/jjzHVDR1Xyn+UBcrDZByG7O7YyajG9PqVOQf0IU2T5650/KIayyjvtNm/ZTyn6Lg==
X-Received: by 2002:a05:6808:8c5:b0:3a1:acef:7e2c with SMTP id k5-20020a05680808c500b003a1acef7e2cmr541565oij.58.1688078029195;
        Thu, 29 Jun 2023 15:33:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id j17-20020aa79291000000b00640f588b36dsm8810961pfa.8.2023.06.29.15.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jun 2023 15:33:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qF0Cw-000CKG-0q;
        Fri, 30 Jun 2023 08:33:46 +1000
Date:   Fri, 30 Jun 2023 08:33:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8 V2] xfs: AGF length has never been bounds checked
Message-ID: <ZJ4GyoNQRozhsGhI@dread.disaster.area>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-8-david@fromorbit.com>
 <20230628175211.GX11441@frogsfrogsfrogs>
 <ZJzn1QMNdCAXx4Il@dread.disaster.area>
 <20230629163535.GG11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230629163535.GG11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 29, 2023 at 09:35:35AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 29, 2023 at 12:09:25PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The AGF verifier does not check that the AGF length field is within
> > known good bounds. This has never been checked by runtime kernel
> > code (i.e. the lack of verification goes back to 1993) yet we assume
> > in many places that it is correct and verify other metdata against
> > it.
> > 
> > Add length verification to the AGF verifier. The length of the AGF
> > must be equal to the size of the AG specified in the superblock,
> > unless it is the last AG in the filesystem. In that case, it must be
> > less than or equal to sb->sb_agblocks and greater than
> > XFS_MIN_AG_BLOCKS, which is the smallest AG a growfs operation will
> > allow to exist.
> > 
> > This requires a bit of rework of the verifier function. We want to
> > verify metadata before we use it to verify other metadata. Hence
> > we need to verify the AGF sequence numbers before using them to
> > verify the length of the AGF. Then we can verify the AGF length
> > before we verify AGFL fields. Then we can verifier other fields that
> > are bounds limited by the AGF length.
> > 
> > And, finally, by calculating agf_length only once into a local
> > variable, we can collapse repeated "if (xfs_has_foo() &&"
> > conditionaly checks into single checks. This makes the code much
> > easier to follow as all the checks for a given feature are obviously
> > in the same place.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Still looks good to me.  New question: Do we need to validate agi_length
> in the AGI verifier too?

I'm on the fence about that after the audit I did. It's only used
for bounds checking in one place in xfs_ialloc_ag_alloc() when
trying to do exact inode chunk allocation (for sequential inode
chunk layout). If it's not correct it doesn't matter (too small will
skip exact allocation, too large means exact allocation at EOAG will
fail) as we fall back to an "anywhere near target" allocation that
doesn't care about agi_length.

Hence the agi_length being wrong isn't going to cause fatal errors
at the moment, so it wasn't anywhere near as urgent to "fix" because
the code isn't actually broken right now...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
