Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D01C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 05:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F2F164E4B
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 05:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBRF0i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 00:26:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47055 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229460AbhBRF0i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 00:26:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613625908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x+E69rx/n2OFb3b6xEpgcYXJIaBvDll8aEYK9e121z0=;
        b=J/I3aUFkAqM+pLdjOPwenyf7GZ4cMyKb5HJQfCO1qcFjzdMolxYd7vcIaord9I9q7mrd9G
        0hoj4mW/52r1J6XoxyWRfRO7Fg9gc+X7xTmtcy0fxqZDJIAmwkhoiPjpUG4k2J+K4lbBAk
        X1+UriLr7UVmY5jH+QNaEi7abPLPbJs=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246--H5flThmOO6I1ict8NP7xw-1; Thu, 18 Feb 2021 00:25:06 -0500
X-MC-Unique: -H5flThmOO6I1ict8NP7xw-1
Received: by mail-pf1-f197.google.com with SMTP id 137so694040pfw.4
        for <linux-xfs@vger.kernel.org>; Wed, 17 Feb 2021 21:25:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x+E69rx/n2OFb3b6xEpgcYXJIaBvDll8aEYK9e121z0=;
        b=XHOpuYPycqh1VG2h+VGYoOWayMKR6zaIaxhA7NCsHUW+yTUQzG/3low9BwqjkQsmaU
         E4IWazbxcnf+ad5P0pRBSHMIWW9PVdZ4+sA+ZvoyC1TMbDxk8LMaTf48/rklzCevRMd/
         C9fNvytV/5AkdCPpSG0NGAKr92ghNjPsf5NuIrjtqOXk4txDLEjZrBVVtB5iyUjDgNpM
         cb8xmTWcNWiK0BBs6PPG2IqZ/nlPIhZ1ZZf7DU/BrTsgcCm8H0Qc5CNJuafusKi4rFJJ
         9YLApueBXtAvnKf9CepiXXSSkHRq5FXOM6WMFLhbRvpmcjtAkUnD/mC9vB411D9TjgT3
         CbhQ==
X-Gm-Message-State: AOAM533g5MzeIqL9CbYnZCkqo1lMRHrtwv9Q6gxn9rmfbZQobdjEa3kT
        JBM8AAW3VsQBgS8ydntS/ICh9PlEX1ubBb+XwG7e8pMjzbLpL5fzc1q3q+MhAbCX33me1Mggmw+
        VAWy6w/1BzjeIKYtS9J5q
X-Received: by 2002:a17:902:e8c4:b029:e2:b7d3:4fd7 with SMTP id v4-20020a170902e8c4b02900e2b7d34fd7mr2414158plg.73.1613625905158;
        Wed, 17 Feb 2021 21:25:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxWpxrJoKYRGbSsarcyMP8yGlXmQ8CLV2/aHsWrzQVBpAFwZ9JXG4flKyPMoaXYbsQ0EpWaIw==
X-Received: by 2002:a17:902:e8c4:b029:e2:b7d3:4fd7 with SMTP id v4-20020a170902e8c4b02900e2b7d34fd7mr2414142plg.73.1613625904890;
        Wed, 17 Feb 2021 21:25:04 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z125sm4793856pgz.45.2021.02.17.21.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 21:25:04 -0800 (PST)
Date:   Thu, 18 Feb 2021 13:24:54 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 3/3] mkfs: make use of xfs_validate_stripe_geometry()
Message-ID: <20210218052454.GA161514@xiangao.remote.csb>
References: <20201013040627.13932-1-hsiangkao@redhat.com>
 <20201013040627.13932-4-hsiangkao@redhat.com>
 <320d0635-2fbf-dd44-9f39-eaea48272bc7@sandeen.net>
 <20210218024159.GA145146@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210218024159.GA145146@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 10:41:59AM +0800, Gao Xiang wrote:
> Hi Eric,
> 
> On Mon, Feb 15, 2021 at 07:04:25PM -0600, Eric Sandeen wrote:
> > On 10/12/20 11:06 PM, Gao Xiang wrote:
> > > Check stripe numbers in calc_stripe_factors() by using
> > > xfs_validate_stripe_geometry().
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > 
> > Hm, unless I have made a mistake, this seems to allow an invalid
> > stripe specification.
> > 
> > Without this patch, this fails:
> > 
> > # mkfs/mkfs.xfs -f -d su=4097,sw=1 /dev/loop0
> > data su must be a multiple of the sector size (512)
> > 
> > With the patch:
> > 
> > # mkfs/mkfs.xfs -f -d su=4097,sw=1 /dev/loop0
> > meta-data=/dev/loop0             isize=512    agcount=8, agsize=32768 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> >          =                       reflink=1    bigtime=0
> > data     =                       bsize=4096   blocks=262144, imaxpct=25
> >          =                       sunit=1      swidth=1 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=2560, version=2
> >          =                       sectsz=512   sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > Discarding blocks...Done.
> > 
> > When you are back from holiday, can you check? No big rush.
> 
> I'm back from holiday today. I think the problem is in
> "if (dsu || dsw) {" it turns into "dsunit  = (int)BTOBBT(dsu);" anyway,
> and then if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit),
> 					     BBTOB(dswidth), cfg->sectorsize, false))
> 
> so dsu isn't checked with sectorsize in advance before it turns into BB.
> 
> the fix seems simple though,
> 1) turn dsunit and dswidth into bytes rather than BB, but I have no idea the range of
>    these 2 varibles, since I saw "if (big_dswidth > INT_MAX) {" but the big_dswidth
>    was also in BB as well, if we turn these into bytes, and such range cannot be
>    guarunteed...
> 2) recover the previous code snippet and check dsu in advance:
> 		if (dsu % cfg->sectorsize) {
> 			fprintf(stderr,
> _("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
> 			usage();
> 		}
> 
> btw, do we have some range test about these variables? I could rearrange the code
> snippet, but I'm not sure if it could introduce some new potential regression as well...
> 
> Thanks,
> Gao Xiang

Or how about applying the following incremental patch, although the maximum dswidth
would be smaller I think, but considering libxfs_validate_stripe_geometry() accepts
dswidth in 64-bit bytes as well. I think that would be fine. Does that make sense?

I've confirmed "# mkfs/mkfs.xfs -f -d su=4097,sw=1 /dev/loop0" now report:
stripe unit (4097) must be a multiple of the sector size (512)

and xfs/191-input-validation passes now...

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f152d5c7..80405790 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2361,20 +2361,24 @@ _("both data su and data sw options must be specified\n"));
 			usage();
 		}
 
-		dsunit  = (int)BTOBBT(dsu);
-		big_dswidth = (long long int)dsunit * dsw;
+		big_dswidth = (long long int)dsu * dsw;
 		if (big_dswidth > INT_MAX) {
 			fprintf(stderr,
 _("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
 				big_dswidth, dsunit);
 			usage();
 		}
-		dswidth = big_dswidth;
-	}
 
-	if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit), BBTOB(dswidth),
-					     cfg->sectorsize, false))
+		if (!libxfs_validate_stripe_geometry(NULL, dsu, big_dswidth,
+						     cfg->sectorsize, false))
+			usage();
+
+		dsunit = BTOBBT(dsu);
+		dswidth = BTOBBT(big_dswidth);
+	} else if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit),
+			BBTOB(dswidth), cfg->sectorsize, false)) {
 		usage();
+	}
 
 	/* If sunit & swidth were manually specified as 0, same as noalign */
 	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
-- 
2.27.0

