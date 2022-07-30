Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A12D8C00144
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Jul 2022 01:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiG3B0H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiG3B0H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jul 2022 21:26:07 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FF13DBD1
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jul 2022 18:26:03 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id z23so11195458eju.8
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jul 2022 18:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=TgkAREkNEkt3PPO17ooBYWWBbO9jUQiMqB8oiwn4MEk=;
        b=Y6dkh8cndQL1jle6UCK4NxJGQevdrMl7VN2scyRRIUk3f0GWDo4VvQTRz9gS/GHMv/
         g38BRPd44IEQ9pdfvF0Gn8pL2xHIOXH/+etAtuQa/hrTapbjsDxuxzOM+cB18wRxyFLA
         udJFQ0dZsBaNHW4cDRdYqxZIyXzq4mMI54WWPXHJnJPFQvLQfsStlu9zSdEoSkkQ4FRv
         S1+AFm7W8tbcQ8fbHmjcGngicA08+6Hj3CNbG7MRNTphhdmYtUHaIXIsNThB/L88DBUX
         lI8Hg8Na4dKfsUAHT6lO60jLHJJZNdh2IpqkDISZ5FwP6l5zDtSkGRRd3bLEXixtrQe6
         nYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=TgkAREkNEkt3PPO17ooBYWWBbO9jUQiMqB8oiwn4MEk=;
        b=mzqcx1puc1DjqaMPS+PDbpgILIiZD0ymahP++007q3XOhtdzwdw2ub+LJn1bB2oB4s
         FWKp81wvP7BLyk7CNoBMldm9NVYt/VLtbhmUCrtgbJUwIhBpK//hzk9PIM46bYIUfH3o
         Y9ZtVKaU2vaJ12BvuewJZ1RVTc5sgPMPSkIy18HZhtVhJQ8GJgNFWtpEI4EzxlYnzO7h
         tge0LhaAteKHNkYSPNYgctwrBVLZO+wE5JnHixlwJ5Jju2Wzsg7VVLJ54hZ26TM0g9Ec
         MM4QWow2Q8IZfRZAVMxOejtzajlrTCc9rvhJPMrnfMV02yhJ7lnGqpfBnSILoxBcwGMC
         zlEA==
X-Gm-Message-State: AJIora9uDsQ3J8vV9UDfLtbVxC9GWTRD79mFSrk3f47xmNQ9gjX333Hc
        glKx/3Vzph+3dsDSXjSmH1PfPMzavxU0KRNPohqdSVZjdDw=
X-Google-Smtp-Source: AGRyM1teMJAmFiAuG64dkpiw9pZFqU/smqPuiu8DmKQczglcElswicwmbDfPj9ULiPMBws7YiRovssB+oexodmJ21Mk=
X-Received: by 2002:a17:906:ef8b:b0:72b:58da:b115 with SMTP id
 ze11-20020a170906ef8b00b0072b58dab115mr4568078ejb.417.1659144362156; Fri, 29
 Jul 2022 18:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220729075746.1918783-1-zhangshida@kylinos.cn> <YuQATS8/CujZV3lh@magnolia>
In-Reply-To: <YuQATS8/CujZV3lh@magnolia>
From:   Stephen Zhang <starzhangzsd@gmail.com>
Date:   Sat, 30 Jul 2022 09:25:25 +0800
Message-ID: <CANubcdVqkeyG5AP56AQ+x3QayRmLZ=zULShhxha-a4N16gPKYg@mail.gmail.com>
Subject: Re: [PATCH] libfrog: fix the if condition in xfrog_bulk_req_v1_setup
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@redhat.com, hch@lst.de, zhangshida@kylinos.cn,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2022=E5=B9=B47=E6=9C=8829=E6=
=97=A5=E5=91=A8=E4=BA=94 23:44=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Jul 29, 2022 at 03:57:46PM +0800, Stephen Zhang wrote:
> > when scanning all inodes in each ag, hdr->ino serves as a iterator to
> > specify the ino to start scanning with.
> >
> > After hdr->ino-- , we can get the last ino returned from the previous
> > iteration.
> >
> > But there are cases that hdr->ino-- is pointless, that is,the case when
> > starting to scan inodes in each ag.
> >
> > Hence the condition should be cvt_ino_to_agno(xfd, hdr->ino) =3D=3D0, w=
hich
> > represents the start of scan in each ag,
>
> Er, cvt_ino_to_agno extracts the AG number from an inumber;
> cvt_ino_to_agino extracts the inumber within an AG.  Given your
> description of the problem (not wanting hdr->ino to go backwards in the
> inumber space when it's already at the start of an AG), I think you want
> the latter here?
>
> > instead of hdr->ino =3D=3D0, which represents the start of scan in ag 0=
 only.
> >
> > Signed-off-by: Stephen Zhang <zhangshida@kylinos.cn>
> > ---
> >  libfrog/bulkstat.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> > index 195f6ea0..77a385bb 100644
> > --- a/libfrog/bulkstat.c
> > +++ b/libfrog/bulkstat.c
> > @@ -172,7 +172,7 @@ xfrog_bulk_req_v1_setup(
> >       if (!buf)
> >               return -errno;
> >
> > -     if (hdr->ino)
> > +     if (cvt_ino_to_agno(xfd, hdr->ino))
>
> ...because I think this change means that we go backwards for any inode
> in AG 0, and we do not go backwards for any other AG.
>
> --D
>
> >               hdr->ino--;
> >       bulkreq->lastip =3D (__u64 *)&hdr->ino,
> >       bulkreq->icount =3D hdr->icount,
> > --
> > 2.25.1
> >

Yeah, i mean the latter. Sorry for the mistake.
Hence the patch will be like:
=3D=3D=3D=3D=3D
@@ -172,7 +172,7 @@ xfrog_bulk_req_v1_setup(
        if (!buf)
                return -errno;

-       if (hdr->ino)
+       if (cvt_ino_to_agino(xfd, hdr->ino))
                hdr->ino--;
        bulkreq->lastip =3D (__u64 *)&hdr->ino,
        bulkreq->icount =3D hdr->icount,
=3D=3D=3D=3D
Should i resend the patch later, or do you have any other idea about
this change?

Thanks,

Stephen.
