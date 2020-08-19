Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77903C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 05:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42A822078D
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 05:04:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IeGIAeaw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725280AbgHSFEu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 01:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSFEs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Aug 2020 01:04:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F151C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 22:04:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mw10so557788pjb.2
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 22:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4SVG4EgwyM2hfZJ1WrqUkoAxrTcU1BbPJ9mkzLUs4eA=;
        b=IeGIAeawBm6u9yVln0Qxx7UgwHsCIVTeul8bOmacds9RVkdLj54rrKWREPuuqo2yKt
         b9nHybBPLpug3FMOisYRMSMrLHq4WjlpGwkFQ+1UvOOfBABAnUB8gmtIG01f4akWTeko
         bMLFMicwfGnDfC+ionJduKu4xl0uUn3RWSPsJ/OSdC3IO5irBhqZrfX3fpObE7CPq3kK
         0+i9udDx5svHejCsdDY0jALJ13+QvGrxgK7rgVk/HtT7rSQ+hwDyb6zZPPfv13M7Dqjf
         vkuB1clg/sU5NX8bJRiIb2Lted3QQKN+waPOAGgY/15DmGVHT0xnGZUafPgvgkeYMYEU
         9jRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4SVG4EgwyM2hfZJ1WrqUkoAxrTcU1BbPJ9mkzLUs4eA=;
        b=sa3VAnQMbV5dl28PV5HRolwjV0psdFjBXp8nM5YqmJRpJXn/d965/oCo7oSTGWsI3p
         9sL3CNLta4WWa01bd1kpAOrmuq1YtVFc+NL5HL09dCC7yxPdZpghOzmYUhYUfy47Qput
         VktfMLOA6hl/1A7rex1LrH5eJPVcXscQYaGH7R/p3oXhxo9zwck7ukKOi7G/eup67KxZ
         a77NJDhS5tX3e8El95tOlexEHqKetNzDpLizaWVzrMeif9o8cAHjJ0cPvjOLNhKPiDdV
         5hMSWwx87NZIpHEtkbpCToIILOkknRZsHsX7l5d4T2nwhL7aaDhhZcB1zgsHclbjnKnq
         sQ/w==
X-Gm-Message-State: AOAM530P9lWyCQ7zPYBlCq6ZKZolBhdk6xzUcjTNTLTuC/WFuX101dvb
        r54I7gfZ5OgvcgZ+iPtof2E=
X-Google-Smtp-Source: ABdhPJzmRALrAolGBWHq3C8NDY/lqhv9NUAGBaThpGvb1nr/f0NKfkjF68zVPH5QM8R31KTcLZTPyA==
X-Received: by 2002:a17:902:123:: with SMTP id 32mr16869827plb.143.1597813487824;
        Tue, 18 Aug 2020 22:04:47 -0700 (PDT)
Received: from garuda.localnet ([122.171.187.105])
        by smtp.gmail.com with ESMTPSA id e22sm22555963pgi.62.2020.08.18.22.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 22:04:47 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V2 08/10] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Wed, 19 Aug 2020 10:34:44 +0530
Message-ID: <2988707.YraNpUvebN@garuda>
In-Reply-To: <20200818220307.GA6096@magnolia>
References: <20200814080833.84760-1-chandanrlinux@gmail.com> <20200814080833.84760-9-chandanrlinux@gmail.com> <20200818220307.GA6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 19 August 2020 3:33:07 AM IST Darrick J. Wong wrote:
> On Fri, Aug 14, 2020 at 01:38:31PM +0530, Chandan Babu R wrote:
> > Moving an extent to data fork can cause a sub-interval of an existing
> > extent to be unmapped. This will increase extent count by 1. Mapping in
> > the new extent can increase the extent count by 1 again i.e.
> >  | Old extent | New extent | Old extent |
> > Hence number of extents increases by 2.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.h | 10 +++++++++-
> >  fs/xfs/xfs_reflink.c           |  6 ++++++
> >  2 files changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 63f83a13e0a8..d750bdff17c9 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -76,7 +76,15 @@ struct xfs_ifork {
> >   * increase by 1.
> >   */
> >  #define XFS_IEXT_INSERT_HOLE_CNT 1
> > -
> > +/*
> > + * Moving an extent to data fork can cause a sub-interval of an
> > + * existing extent to be unmapped. This will increase extent count by
> > + * 1. Mapping in the new extent can increase the extent count by 1
> > + * again i.e.
> > + * | Old extent | New extent | Old extent |
> 
> This comment is a little oddly formatted, mostly because my brain
> thought that the line starting with "1. Mapping" was a numbered bullet
> list.  If you reflow the comment further outward, you can get it to look
> like this:
> 
> /*
>  * Moving an extent to data fork can cause a sub-interval of an existing
>  * extent to be unmapped, increasing extent count by 1. Mapping in the
>  * new extent can also increase the extent count by 1:
>  * | Old extent | New extent | Old extent |
>  * Hence number of extents increases by 2.
>  */
> #define XFS_IEXT_REFLINK_END_COW_CNT 2
>

Sure. I will fix up all the comments in the patchset to extend upto 80
columns.

-- 
chandan



