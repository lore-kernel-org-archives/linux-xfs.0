Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A1DC433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9C6820665
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKENr0Tl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgIAJpl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIAJpl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 05:45:41 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE286C061244
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 02:45:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u20so498516pfn.0
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 02:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qFSEzOaGGZ2npzhK8sTRa9Oo46h+0LOIwDTybTkjqxM=;
        b=FKENr0TlBerdDokkWyFeA+6M1ToOgz5icoIr0NXAFMGPCK233dkqCwXw/m2MMwCN4j
         6M9bbFbRUSTt59cw62UEcz2ICmZtnOrAaPOAd8RU0rJ4mD6Lb1j8LCNrdhzrknOOAn+a
         Aav+0lBSVMYw05I0wzV1DSlQoNabGRirulss4SleWsvZZ2DotZvCtJRH32+MiNNVSiwa
         /7SvBNabp1LDmGbfxbYf29XGWdmWhCOt3+s3cJ7fIQqO6dtiYsIVMf+IiOJBbabYA5LK
         MddaaX3wfliVGaGlsmfMj57rVKpIzQYr0pf+X2pZLaQH++wmvaE01UEvPVrpFnDD6ysF
         ZvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qFSEzOaGGZ2npzhK8sTRa9Oo46h+0LOIwDTybTkjqxM=;
        b=YcuU33Q7prZw3GgLqVMVlZrYwbwekl+3Or27/pngA9oHIdsXmGBPeWLoT/D/PKv/Hj
         dFpCBp1ZFR6k65GYi6RL2Nvmx9eF6OPRAneJawDsc67CjgUBiEvCkl1RXbkv9D2bV8YA
         kdwUjKKg06hFcKoduXfCLu/VAX+mQSyfmect533Xfnro6QrAigMdYWCZnfAJ1YcxRA5C
         ZTmBFsg8noE3Se5Zkr4ihGVcI1p2Ut57qmtnL4k23Unx7JbFi/k3hzLFTqrrc/TTMv37
         y5CTRXxgWoPYVOjlpX+yHsCGyki+tne1iL2vakyaWn74IxjNo77ArSgM9m6hnMLrsGwR
         YMhQ==
X-Gm-Message-State: AOAM532s//q0xBlKxp/kSHsPpfr8oFIuDXcGkdxdqnPlfnXun49w9XtA
        RrXokPiCwzw+Ssuu06m5fHQ=
X-Google-Smtp-Source: ABdhPJz8gpRcD3uG819oOjUUcNz3yMOxmgz2MeAFcY1FmSZ5gcGFNSZmr+bdMygv0PeP+gteepy4Qw==
X-Received: by 2002:a62:486:: with SMTP id 128mr1046347pfe.163.1598953539346;
        Tue, 01 Sep 2020 02:45:39 -0700 (PDT)
Received: from garuda.localnet ([122.171.183.205])
        by smtp.gmail.com with ESMTPSA id e142sm1265546pfh.108.2020.09.01.02.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 02:45:38 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 09/10] xfs: Check for extent overflow when remapping an extent
Date:   Tue, 01 Sep 2020 15:15:09 +0530
Message-ID: <1966526.POamv2Wr1p@garuda>
In-Reply-To: <20200831162335.GJ6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com> <20200820054349.5525-10-chandanrlinux@gmail.com> <20200831162335.GJ6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 31 August 2020 9:53:35 PM IST Darrick J. Wong wrote:
> On Thu, Aug 20, 2020 at 11:13:48AM +0530, Chandan Babu R wrote:
> > Remapping an extent involves unmapping the existing extent and mapping
> > in the new extent. When unmapping, an extent containing the entire unmap
> > range can be split into two extents,
> > i.e. | Old extent | hole | Old extent |
> > Hence extent count increases by 1.
> > 
> > Mapping in the new extent into the destination file can increase the
> > extent count by 1.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.h | 14 ++++++++++++++
> >  fs/xfs/xfs_reflink.c           |  5 +++++
> >  2 files changed, 19 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 850d53162545..d1c675cf803a 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -86,6 +86,20 @@ struct xfs_ifork {
> >   * Hence number of extents increases by 2.
> >   */
> >  #define XFS_IEXT_REFLINK_END_COW_CNT	(2)
> > +/*
> 
> It's usually considered good style to put a blank line between the
> previous definition and the new comment.
>

Ok. I will fix that.

> With that fixed,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 

-- 
chandan



