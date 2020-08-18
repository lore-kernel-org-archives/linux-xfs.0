Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003BDC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 12:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BABE220706
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 12:54:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LvCrqDUX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgHRMyM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgHRMyL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 08:54:11 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E76DC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 05:54:10 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g19so21004876ioh.8
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 05:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x47s96B48Zd3DIYIzL98/zYSlqxgWd2UjaPAVK7AxEc=;
        b=LvCrqDUXwBDRzAEK3tA/1WzBxCz/6cSoU9FDdg/CHoQ4l97o0Lm2anTlQJ3NwT3+Hp
         P38iSOehxj8ShaRdTkkCD3oak+SeEEQtJ2ifZ8tu2/WQgOhNYVKUjmwJHR912UFyDHcd
         39M4oaqA5yvZqJAw+RcbvgON3MhMzw2+y8iuaw2jIKENPoalns29MFZgqvU6ZYAUBOjc
         PYL+ZAeZPCv54I2X3uDD+txFEZiDWbFO7mU+AXYheu+EQBx8CMnS48DM6H7H/CgjAv69
         R+vlz4SsHGlXiB2/++WV9621QsfkogaVLii0s1qsmIRkWypEtuE5YAbj9EsT5kSNNwP+
         TBvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x47s96B48Zd3DIYIzL98/zYSlqxgWd2UjaPAVK7AxEc=;
        b=ZaeRQC4r90/l/vFH5NAZuYFMPYA326z68vNQDv32wUJ8jgXtPNTZ3C5Nh/sfql25Qf
         UO4Hp5gGQyUKexE5UK+HBFlSNCK1GohSaRyf+MMidAJillpiirqHFIaEu3L5mhxM78TI
         Mh116KPccCtlYlagGkgVpVy/F5EGTCe4SgJaslZ1ayckMA5+zaoQ51+CuFtmv+XCeWjV
         iSNSA7d51wCo0jUZRZSkrqwTZYehqNoaetVbwXTJ8umjP+1VlLwyElrsBRydP6xnvvkV
         Py+85tYiXjCSr6hXWB5Q9g98Uy6ts2VvcCdE31yVoajllO+W3If3X2Vyqm+ZsEGmzgmQ
         bwiA==
X-Gm-Message-State: AOAM533BljabHOig4lPAzEmAIOT3xCuekS/hNffz2F9ezFEHMvpyVg4S
        D3/By1wLJ93qU6KYE8P4oi4p7h3bGOZ83JBegJg=
X-Google-Smtp-Source: ABdhPJySFAsrtdSEzU07BEKcOBEylM42XnNQV/nFFLxL6+9uEdbqJ2IbE7QPBKDVBrrtc61gAAzVCQW7D+W0k0iK6dk=
X-Received: by 2002:a6b:5d0a:: with SMTP id r10mr16252015iob.186.1597755249146;
 Tue, 18 Aug 2020 05:54:09 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770505894.3956827.5973810026298120596.stgit@magnolia> <CAOQ4uxj=K5TCTZoKxd9G4F0cTRYeE73-6iQgmp+3pR3QJKYdvg@mail.gmail.com>
In-Reply-To: <CAOQ4uxj=K5TCTZoKxd9G4F0cTRYeE73-6iQgmp+3pR3QJKYdvg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 15:53:57 +0300
Message-ID: <CAOQ4uxgiVdzVNo00-mzDjRn4x3+40dXWGx78n-KucrOBxMcREA@mail.gmail.com>
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038 problem
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 3:00 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> > nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> > time epoch).  This enables us to handle dates up to 2486, which solves
> > the y2038 problem.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> ...
>
> > diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> > index 9f036053fdb7..b354825f4e51 100644
> > --- a/fs/xfs/scrub/inode.c
> > +++ b/fs/xfs/scrub/inode.c
> > @@ -190,6 +190,11 @@ xchk_inode_flags2(
> >         if ((flags2 & XFS_DIFLAG2_DAX) && (flags2 & XFS_DIFLAG2_REFLINK))
> >                 goto bad;
> >
> > +       /* the incore bigtime iflag always follows the feature flag */
> > +       if (!!xfs_sb_version_hasbigtime(&mp->m_sb) ^
> > +           !!(flags2 & XFS_DIFLAG2_BIGTIME))
> > +               goto bad;
> > +
>
> Seems like flags2 are not the incore iflags and that the dinode iflags
> can very well
> have no bigtime on fs with bigtime support:
>
> xchk_dinode(...
> ...
>                 flags2 = be64_to_cpu(dip->di_flags2);
>
> What am I missing?
>

Another question. Do we need to worry about xfs_reinit_inode()?
It seems not because incore inode should already have the correct bigtime
flag. Right? But by same logic, xfs_ifree() should already have the correct
bigtime flag as well, so we don't need to set the flag, maybe assert the flag?

Thanks,
Amir.
