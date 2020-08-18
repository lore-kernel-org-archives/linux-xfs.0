Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5A6C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A7DF20825
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZuPW0j9n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgHRO6Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgHRO6X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:58:23 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655FFC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:58:23 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b17so21425773ion.7
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GEhDqQqk8RsNoRnokG/XmGGvTc3I1uK6OVDTHVi7QsA=;
        b=ZuPW0j9nLK0kNiHBUrj3Nyh/13slz6g8XBRXd9ta71ojhPcsLy6CIzAyp9ZIYVtA+y
         AlGOxluGRO2HdPORXeQeOm/znnrY58eNg3mzPZfROGFGDPBq6+3PXmJ9By/c4lIXCstt
         jVsM6BENRSB0GdmLouRwaaspCsY2U7J70w+YT2zxpAd+q66LlkrLugtFLjgI3QRr/Mc8
         e45GlUM6hqQUaZax9YObRfo/40uoou1T82Zah1RyNUSFO8lU6Ru4K8rs7c6tk56mSmKj
         hKCtCHe5G8GEGJFEUt617eRodwq/PsIr9GTSpNKfqR/elTDkg+dMu595CnsYgbhX0FwM
         XQHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GEhDqQqk8RsNoRnokG/XmGGvTc3I1uK6OVDTHVi7QsA=;
        b=HVovBIaIJt//QHS1qli3cFhyFZ44xlCh0VOhCj/gjZ+D0Kg2RQQV+2WdWWv31R11eM
         UIp9bWGoHrBodqnQA+ZSPuDrayktBwBy6FelBrf8E+P0mo36Gw1lHJzH7W/x3IO/ewUr
         QhmJXcTaQjh81wP++WrWBcAVa/W7mU2cW+m7eFEuMPtwaNoKTzeAjoTRsC3365qpOBP3
         rRHYQSKwTRWlNh6YolNuMbaf4g8RvhQjo4irOYvMT3W8oKGcwGC64tB9Cocphh0/Y/C4
         20Bu7Yla0UPcjqenYJTlMdiu5Ne1VVMKrz6hcShu8oad9eeH6fAZoPk5U3DdsCOEunwt
         rKug==
X-Gm-Message-State: AOAM53337TrsH6ZzLU54kZ91+uFkk5SXGQpZyKCOyhvoasWwUet8Kd8u
        b02nGAIUE8CgfKIPINtVQwcwL6I24Xayzm1zqFA=
X-Google-Smtp-Source: ABdhPJyg+vP1gcFKETOyA+8k/paUVRib2LX/ZeXR+/eyOy9/1AV58nbdDliLu/Of2kjuztCzr5jLgR5TAGY/RKEvmM8=
X-Received: by 2002:a05:6602:1d6:: with SMTP id w22mr16438278iot.64.1597762702741;
 Tue, 18 Aug 2020 07:58:22 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770524187.3958786.13522554876108493954.stgit@magnolia>
In-Reply-To: <159770524187.3958786.13522554876108493954.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:58:11 +0300
Message-ID: <CAOQ4uxiw7oPFwy2J-hGAoN6qTu_Hnx9E2vy2qBO9x5M-oaT5AQ@mail.gmail.com>
Subject: Re: [PATCH 17/18] xfs_repair: support bigtime
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Check the bigtime iflag in relation to the fs feature set.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

and some questions below...

> ---
>  repair/dinode.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
>
> diff --git a/repair/dinode.c b/repair/dinode.c
> index ad2f672d8703..3507cd06075d 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2173,7 +2173,8 @@ check_nsec(
>         union xfs_timestamp     *t,
>         int                     *dirty)
>  {
> -       if ((dip->di_flags2 & be64_to_cpu(XFS_DIFLAG2_BIGTIME)) ||
> +       if ((dip->di_version >= 3 &&

It seems a bit strange that di_version check was added by this commit.

> +            (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME))) ||
>             be32_to_cpu(t->t_nsec) < NSEC_PER_SEC)
>                 return;
>
> @@ -2601,6 +2602,16 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>                         flags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
>                 }
>
> +               if ((flags2 & XFS_DIFLAG2_BIGTIME) &&
> +                   !xfs_sb_version_hasbigtime(&mp->m_sb)) {
> +                       if (!uncertain) {
> +                               do_warn(
> +       _("inode %" PRIu64 " is marked bigtime but file system does not support large timestamps\n"),
> +                                       lino);
> +                       }
> +                       flags2 &= ~XFS_DIFLAG2_BIGTIME;

Should we maybe also reset the timestamps to epoc in this case?

Thanks,
Amir.
