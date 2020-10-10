Return-Path: <SRS0=54mU=DR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E80C433E7
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 04:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 325F221789
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 04:07:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GzvYqqFk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgJJEG7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 10 Oct 2020 00:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgJJEAf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Oct 2020 00:00:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF2FC0613CF
        for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2020 21:00:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y14so8507436pfp.13
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 21:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ZTH5rU00lTB6Ri60wl8Xkjo8tuJsg++/usZJk1lkzw=;
        b=GzvYqqFkfZXdCY0bqaYdxNr+4/LkSQ0vEJRZsq69/LOnsebXT2akWEQCbwtUE2IV+2
         4iSkDr3MBZL+yDih3/pdwbHK/LG5pUOYikph7n1dnCAp12U6ZHIH0ppT1QBUom8I7LoX
         +d+ArDek+UtcJ+vkkDb27cITHa97YfYoUGo8D1lrKBIHLttakyBZ5AnzZE4JtRvnuptk
         LP+KWTC+aVQbkdXbBnrmtX2324pZWLsyDGTXPNgaqGepoGDTaJEOcl7SpTe93DQXrPiF
         HprNDmHhOkezSFnk3fBsrxZI9d4a1eSy8mvbCHnoSCNoj12qRb5SRi8HIGnHtdhHCGQj
         E1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ZTH5rU00lTB6Ri60wl8Xkjo8tuJsg++/usZJk1lkzw=;
        b=JyFzaZmKdtdinRza+8ZtyvnjbTaSWhcht3Xl/r6dKLVB0jaevy/QxGdcXGNizrUgHi
         Ya6qO4GXI3L44jufjzH42ODSK+siRzgTVgWtl+06ctnvt3r+sGgR8qj+h06bpTo1ynTF
         4UP+ifUEpA0/63KNWU/5O6ZcDKnB4EOY4Bgwfs7vbghc+a8HaxVn4MxeUfZOHunGQY9h
         DVaS/ACOmTte5J6n3+6qitHlm4K/LphkncS+jYO9A7ktR2nKqaHWaB1qC4AXdur6c3L8
         eqj3SYSeKgQ/Ahbc3QGdBSLbymwtuBNvmBHb1q+alv7Hx+e7XuMMdhpZq7lly4x3CibX
         DnlQ==
X-Gm-Message-State: AOAM530+3xRCHK4d7zmb02NIfH7xLmCYotNWJwN98ojRZDNKb49yZdii
        VaiJcEd2fpgUKNEQY9w1Zw1nkPpSXuU=
X-Google-Smtp-Source: ABdhPJzMwOpDa3hGRYvPDuwjaCY2gDkYc+llmqQgS5+LttKzMSV0Ac0SkdNP3TrMXoftd/jXaNh2LQ==
X-Received: by 2002:a65:538e:: with SMTP id x14mr5701512pgq.136.1602302434498;
        Fri, 09 Oct 2020 21:00:34 -0700 (PDT)
Received: from garuda.localnet ([122.167.149.224])
        by smtp.gmail.com with ESMTPSA id n24sm14373862pjq.14.2020.10.09.21.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 21:00:33 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH v2.2 2/3] xfs: make xfs_growfs_rt update secondary superblocks
Date:   Sat, 10 Oct 2020 09:30:31 +0530
Message-ID: <4017285.U2OhlY94U5@garuda>
In-Reply-To: <20201009152126.GS6540@magnolia>
References: <160216932411.313389.9231180037053830573.stgit@magnolia> <2785429.vsROyPpyBe@garuda> <20201009152126.GS6540@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 9 October 2020 8:51:26 PM IST Darrick J. Wong wrote:
> On Fri, Oct 09, 2020 at 03:21:38PM +0530, Chandan Babu R wrote:
> > On Friday 9 October 2020 3:49:05 AM IST Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > When we call growfs on the data device, we update the secondary
> > > superblocks to reflect the updated filesystem geometry.  We need to do
> > > this for growfs on the realtime volume too, because a future xfs_repair
> > > run could try to fix the filesystem using a backup superblock.
> > > 
> > > This was observed by the online superblock scrubbers while running
> > > xfs/233.  One can also trigger this by growing an rt volume, cycling the
> > > mount, and creating new rt files.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v2.2: don't update on error, don't fail to free memory on error
> > > ---
> > >  fs/xfs/xfs_rtalloc.c |    8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > > index 1c3969807fb9..f9119ba3e9d0 100644
> > > --- a/fs/xfs/xfs_rtalloc.c
> > > +++ b/fs/xfs/xfs_rtalloc.c
> > > @@ -18,7 +18,7 @@
> > >  #include "xfs_trans_space.h"
> > >  #include "xfs_icache.h"
> > >  #include "xfs_rtalloc.h"
> > > -
> > > +#include "xfs_sb.h"
> > >  
> > >  /*
> > >   * Read and return the summary information for a given extent size,
> > > @@ -1102,7 +1102,13 @@ xfs_growfs_rt(
> > >  		if (error)
> > >  			break;
> > >  	}
> > > +	if (error)
> > > +		goto out_free;
> > >  
> > > +	/* Update secondary superblocks now the physical grow has completed */
> > > +	error = xfs_update_secondary_sbs(mp);
> > > +
> > > +out_free:
> > >  	/*
> > >  	 * Free the fake mp structure.
> > >  	 */
> > > 
> > 
> > How about ...
> > 
> > if (!error) {
> > 	/* Update secondary superblocks now the physical grow has completed */
> > 	error = xfs_update_secondary_sbs(mp);
> > }
> > 
> > /*
> >  * Free the fake mp structure.
> >  */
> > ...
> > ... 
> > 
> > With the above construct we can get rid of the goto label.
> 
> I'd rather not start doing that, because (a) we generally don't do that
> in xfs and (b) in a cycle or two I'm going to add more in-memory state
> changes between the secondary super update and freeing the fake mp, and
> I'd prefer to start all that by having the error case jump to out_free.
>

Ok.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan



