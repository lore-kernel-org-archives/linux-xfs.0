Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186E7C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 22:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiFVWRh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 18:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345378AbiFVWRh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 18:17:37 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14053EBBD;
        Wed, 22 Jun 2022 15:17:35 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id k127so12109313pfd.10;
        Wed, 22 Jun 2022 15:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wv+3ejE3XLnLczXlwBxdBb+mIIWKlS4zkTl1YG7+A2Y=;
        b=LsoKNDO1aZGa4gpiXQlvzCkucjAkkEPxqABVydcFx31NODvoVC51lmkoasPp1m8nS0
         MqqzgIycIweAiiSkA27Gm1kkrHFXKdw/0gEOew76uF5Mjixv0c+SJxmVIXei3PJsnQU3
         IFQFSDCuoCvT9lxs2oqIsNCbDezCLWJlNsdDLTRvC9YFIJaAAtisI/cYnn0Zs1seOHe9
         /1ChWt+k8OvO3B8+DzNgTg2eyU81lP6fNbmg8ogXA+UC5g3Qfah3LmWN4qNqr0FmsoMc
         ZnZ4LoXa0i7Hw7nXixzPUGr+tWWUCEvWfzO1y4Vr7HOKWjPaZq2roKw19T2KtpinN2iQ
         tg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wv+3ejE3XLnLczXlwBxdBb+mIIWKlS4zkTl1YG7+A2Y=;
        b=dC11OGqpvdhKIUWFEyOW61eJctYxDKpHXZmWLN6RLUx2SDngFeqt+Ieu1f/sd8DqDy
         X/LlrYDXl72GAtmE0Sn0KbYph3RqosumFtwvoTJT/RcJNVD0CjzPFR0RCYvhUtZ9VcnX
         RzdEgnMm4GY7Y0Kr6Sy/+RZRfiFJLY4c3ObcwcmaiHDufLEzjrX1Z10fCqbt5II/y/fI
         cRFMfSpw3fwxgkKUAnzSsEeIkCWaIfFjQwwBlSUNELo80zpATd+GuSZ5NCBYzX+hVAJ2
         9e6E2FdIRR5NvS3jzvHeH/9bis32UuUfYC3n4Afu53/WHoq4oYTGUoJLvdnWa8a0xcZy
         EJ5g==
X-Gm-Message-State: AJIora8ECQNlZwkIdIHbGyQCjRIBl7Yq9FoiQZdWz3F0qM3J0Nn+7d4H
        5KbJkk0iY5dPZVJDgIU2ChsBg5wJBhyNdA==
X-Google-Smtp-Source: AGRyM1vPtLj6GdsATpVbY0gDLRI/FrNNRrB6PeHI1qIPKrHS8Sa9Ak9l6TlNmz7AHwlt6Yt4WmkhdA==
X-Received: by 2002:a63:b948:0:b0:40c:830b:338f with SMTP id v8-20020a63b948000000b0040c830b338fmr4802415pgo.50.1655936255453;
        Wed, 22 Jun 2022 15:17:35 -0700 (PDT)
Received: from google.com ([2620:0:1001:7810:1c61:ca22:3ef4:fce9])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902c3c400b0016a5384071bsm777905plj.1.2022.06.22.15.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 15:17:34 -0700 (PDT)
Date:   Wed, 22 Jun 2022 15:17:32 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 5.10 CANDIDATE 11/11] xfs: use setattr_copy to set vfs
 inode attributes
Message-ID: <YrOU/FPCEWkozAQI@google.com>
References: <20220617100641.1653164-1-amir73il@gmail.com>
 <20220617100641.1653164-12-amir73il@gmail.com>
 <YrNGJXYi2jQtPxs0@magnolia>
 <CAOQ4uxgXobea42K=WVyOhxxq+S=TA3RvLbxypKO02D9TZEgioA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgXobea42K=WVyOhxxq+S=TA3RvLbxypKO02D9TZEgioA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 09:36:53PM +0300, Amir Goldstein wrote:
> On Wed, Jun 22, 2022 at 7:41 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Fri, Jun 17, 2022 at 01:06:41PM +0300, Amir Goldstein wrote:
> > > From: "Darrick J. Wong" <djwong@kernel.org>
> > >
> > > commit e014f37db1a2d109afa750042ac4d69cf3e3d88e upstream.
> > >
> > > [remove userns argument of setattr_copy() for backport]
> > >
> > > Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
> > > revocation isn't consistent with btrfs[1] or ext4.  Those two
> > > filesystems use the VFS function setattr_copy to convey certain
> > > attributes from struct iattr into the VFS inode structure.
> > >
> > > Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
> > > decide if it should clear setgid and setuid on a file attribute update.
> > > This is a second symptom of the problem that Filipe noticed.
> > >
> > > XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
> > > xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
> > > /not/ a simple copy function; it contains additional logic to clear the
> > > setgid bit when setting the mode, and XFS' version no longer matches.
> > >
> > > The VFS implements its own setuid/setgid stripping logic, which
> > > establishes consistent behavior.  It's a tad unfortunate that it's
> > > scattered across notify_change, should_remove_suid, and setattr_copy but
> > > XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
> > > functions and get rid of the old functions.
> > >
> > > [1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
> > > [2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/
> > >
> > > Fixes: 7fa294c8991c ("userns: Allow chown and setgid preservation")
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Christian Brauner <brauner@kernel.org>
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > Same question as I posted to Leah's series -- have all the necessary VFS
> > fixes and whatnot been backported to 5.10?  Such that all the new sgid
> > inheritance tests actually pass with this patch applied? :)
> 
> The only patch I backorted to 5.10 is:
> xfs: fix up non-directory creation in SGID directories
> 
> I will check which SGID tests ran on my series.
> 
> Personally, I would rather defer THIS patch to a later post to stable
> (Leah's patch as well) until we have a better understanding of the state
> of SGID issues.
> 
> Thanks,
> Amir.

On the latest version of the SGID tests, I see failures of
generic/68[3-7] and xfs/019 on both the baseline and backports branch.
generic/673 fails on most configs for the baseline but seems to be fixed
in the backports branch. Regardless, I am fine dropping this patch for
this round.

Best,
Leah
