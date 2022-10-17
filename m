Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D0EC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Oct 2022 08:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiJQIdX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Oct 2022 04:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiJQIdE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2022 04:33:04 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCF54054F
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 01:33:02 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id a6so13052634ljq.5
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 01:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=azrjkTSUa/x73/5WnmuPzRdP/HPez6bDQxOpksGkhRA=;
        b=a/oDAz3xURgSlah+zDO2fzFzfvSFrEjmCsQ5CtmV5wpy8/L51Q77OK5k7mJq+LosYE
         RDJCxvRoEXZS65qMQOnrKu6I9wkhUaPEiyHo/NWSrMkHLiva7vvcuRRaZ3Z2Q44s3sfl
         EvRB3rWoOYqNbHfiOiSOLVn/sZa+2u6b7EbV7urnZXdD3prc0O/Ddpp0UNb8jMFdVh7H
         mNPXpUp5rjHVCeF1JbMiorLWQ+P8IWxh+Ro0RWHT2VHqIjGWHAQ/gveZL6ep25X6ZAnZ
         NBOvAMgMz/qIgTYTo0t2OtD4TIYyFuNUdp8KuqNGvdQuayInWZbNLoBWdlSiwE/zSHUc
         HgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=azrjkTSUa/x73/5WnmuPzRdP/HPez6bDQxOpksGkhRA=;
        b=6Usw5y9yTEfdj6QEtHgmCgUwKEC6vLn3PD5zjyJq348TAItExMhCDjtSP23SzGe6ot
         PHOSG/7GCP75VNkaqY+N9376kceIyZD6Nr/v7CVf2n4PT/V1V2/UYMTMIGXMzBgnylOm
         JQODMZ66emtLUhjdBFHLP1PgEaBi2S6BVUALpAdzLoMW6Rmx9C4eCVML6y2n/1TU4MpX
         KRn/HYh1a5scLRM7KRLBOyrWHEyh0/Mh8CGcvfGzuYkjB+htHAQlM6M5R6sWE4lyW293
         2FQMZceI+OJP+a4lU83VzdeR3258o6xFQP5aVS89tfWsQ4SFLmqGXAhvuGXYToXVsWZP
         16mQ==
X-Gm-Message-State: ACrzQf3d1Vvmy3feZnkzXRuvr/lrkIIH5bkECS6FZv5QGLl6UtnktYqj
        O2oyImf7bnjR62zbZboIOK0m/CsA5FpaDPD5H+OGVA==
X-Google-Smtp-Source: AMsMyM5v5LDC0BBL5gYqehs/SqfSDyUe3Uxe1Ev3owdj68C4Qz8wqJvfTKXOJXJGGPXuN1JCNY46IEZom7aRnXaTplE=
X-Received: by 2002:a2e:978e:0:b0:26e:8ad6:6d5b with SMTP id
 y14-20020a2e978e000000b0026e8ad66d5bmr3880239lji.363.1665995580212; Mon, 17
 Oct 2022 01:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221014084837.1787196-1-hrkanabar@gmail.com> <20221014084837.1787196-6-hrkanabar@gmail.com>
 <Y0mD0LcNvu+QTlQ9@magnolia>
In-Reply-To: <Y0mD0LcNvu+QTlQ9@magnolia>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 17 Oct 2022 10:32:48 +0200
Message-ID: <CACT4Y+aNuRX52u5j1vKpJKru-riSktugDMtDKchR0NLCuvXOQg@mail.gmail.com>
Subject: Re: [PATCH RFC 5/7] fs/xfs: support `DISABLE_FS_CSUM_VERIFICATION`
 config option
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Hrutvik Kanabar <hrkanabar@gmail.com>,
        Hrutvik Kanabar <hrutvik@google.com>,
        Marco Elver <elver@google.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        kasan-dev@googlegroups.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 14 Oct 2022 at 17:44, Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Oct 14, 2022 at 08:48:35AM +0000, Hrutvik Kanabar wrote:
> > From: Hrutvik Kanabar <hrutvik@google.com>
> >
> > When `DISABLE_FS_CSUM_VERIFICATION` is enabled, return truthy value for
> > `xfs_verify_cksum`, which is the key function implementing checksum
> > verification for XFS.
> >
> > Signed-off-by: Hrutvik Kanabar <hrutvik@google.com>
>
> NAK, we're not going to break XFS for the sake of automated fuzz tools.

Hi Darrick,

What do you mean by "break"? If this config is not enabled the
behavior is not affected as far as I see.

> You'll have to adapt your fuzzing tools to rewrite the block header
> checksums, like the existing xfs fuzz testing framework does.  See
> the xfs_db 'fuzz -d' command and the relevant fstests.
>
> --D
>
> > ---
> >  fs/xfs/libxfs/xfs_cksum.h | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_cksum.h b/fs/xfs/libxfs/xfs_cksum.h
> > index 999a290cfd72..ba55b1afa382 100644
> > --- a/fs/xfs/libxfs/xfs_cksum.h
> > +++ b/fs/xfs/libxfs/xfs_cksum.h
> > @@ -76,7 +76,10 @@ xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
> >  {
> >       uint32_t crc = xfs_start_cksum_safe(buffer, length, cksum_offset);
> >
> > -     return *(__le32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
> > +     if (IS_ENABLED(CONFIG_DISABLE_FS_CSUM_VERIFICATION))
> > +             return 1;
> > +     else
> > +             return *(__le32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
> >  }
> >
> >  #endif /* _XFS_CKSUM_H */
> > --
> > 2.38.0.413.g74048e4d9e-goog
> >
>
> --
> You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/kasan-dev/Y0mD0LcNvu%2BQTlQ9%40magnolia.
