Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BEDC433E9
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEB6064DCF
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhBLWgQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 17:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbhBLWda (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Feb 2021 17:33:30 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F55BC06178B
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 14:31:42 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id v10so840771qtq.7
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 14:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cIiBuQsAe5atE0+VVPrV72uCmkJa3tjhFIyAfdgST8Q=;
        b=hreATBE2beMlDkON5Xz5itTkavGvlHUSnGfTP0UtYNWBcn0CA4RDuj2Az7Z3Xyklbz
         gYJNefuV4q94RH+wb1d6AsHPmCqDOItFpKE8yVqOkzSUqn7RBfXa7d+XXteou3rvXDuK
         k4J+TK/6J6bToeTt+nrx7ID/qUHoMdBRsj6k0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cIiBuQsAe5atE0+VVPrV72uCmkJa3tjhFIyAfdgST8Q=;
        b=r4Aw6uoUjyfEykZrktGX8yjGYJSXrNu7t3B46I/IyTrjivCJ3Ris+x/iUXt52GXfSj
         jXiKn3Vi8THBI2tp6vAiWkd3ZwGn2zy+SRvB9dn+qky61+6Y/JlV5QRp7TmSvSqHpr/9
         f/GJrGob8XPKDUdh7POsbQ20TyJkTGcqFxLdxO8O5NxYbNTFO2zQ17VUKeiDlRlONbfg
         R9MksVgrdx3Nwv86eF3rj+X4epY1m9FMRJYW2VwSh/eU1iWBg1wVSMHtbuB4U16PL4eM
         l7AgFIzI77HjKmXYtPv/gaFJXKuGh63t1DUXpOJRbk5b7CRkcRVBSrcUfcEMwPQ9yZ6y
         xl3w==
X-Gm-Message-State: AOAM530geRFvyllYcLQ2Z6B9gOPxWDj9a2BMyJzfEW0YEk0NKi89lund
        GBrPGReI/oGL5Mf+LNGxp51qPMrN/pqnephvNJnhRA==
X-Google-Smtp-Source: ABdhPJwHZT2GQySusMmVF+qp+fprlTFmxXLisTvAG/DfROF0QZ4mZWC8fqIWhHqIaShC2SznRTKXlEG5gwYtAT5JyN8=
X-Received: by 2002:ac8:5985:: with SMTP id e5mr4769445qte.160.1613169101113;
 Fri, 12 Feb 2021 14:31:41 -0800 (PST)
MIME-Version: 1.0
References: <20210212204849.1556406-1-mmayer@broadcom.com> <CAGt4E5tbyHpDEPtEGK8SYoB4w4srAfHpiBADkR+PpkQyguiLPg@mail.gmail.com>
 <36f95877-ad2d-a392-cacd-0a128d08fb44@sandeen.net> <CAGt4E5uA6futY0+AySLJTHsmoUp7OceNca=7ReXAg-o8mw0=7Q@mail.gmail.com>
 <20210212222105.GO7193@magnolia>
In-Reply-To: <20210212222105.GO7193@magnolia>
From:   Markus Mayer <mmayer@broadcom.com>
Date:   Fri, 12 Feb 2021 14:31:30 -0800
Message-ID: <CAGt4E5s+VFdOYRvQOwCe0ZNJtcJA5obEQYtFsGquggOZBXsh-A@mail.gmail.com>
Subject: Re: [PATCH] include/buildrules: substitute ".o" for ".lo" only at the
 very end
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Linux XFS <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 12 Feb 2021 at 14:21, Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Feb 12, 2021 at 01:55:06PM -0800, Markus Mayer wrote:
> > On Fri, 12 Feb 2021 at 13:29, Eric Sandeen <sandeen@sandeen.net> wrote:
> > >
> > > On 2/12/21 2:51 PM, Markus Mayer wrote:
> > > >> To prevent issues when the ".o" extension appears in a directory path,
> > > >> ensure that the ".o" -> ".lo" substitution is only performed for the
> > > >> final file extension.
> > > >
> > > > If the subject should be "[PATCH] xfsprogs: ...", please let me know.
> > >
> > > Nah, that's fine, I noticed it.
> > >
> > > So did you have a path component that had ".o" in it that got substituted?
> > > Is that what the bugfix is?
> >
> > Yes and yes.
> >
> > Specifically, I was asked to name the build directory in our build
> > system "workspace.o" (or something else ending in .o) because that
> > causes the automated backup to skip backing up temporary build
>
> Does the backup not know about the NODUMP flag, aka chattr +d ?

I don't know. I'll follow up with the team that handles the
infrastructure. I believe there's some file access over NFS involved
here, and I am not sure if the NODUMP flag would be available via NFS.

Regards,
-Markus
