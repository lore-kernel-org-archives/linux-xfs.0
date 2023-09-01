Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0310FCA0FE1
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Sep 2023 01:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbjIABHI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Aug 2023 21:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbjIABHD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2023 21:07:03 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CECFE67
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 18:07:00 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-7926b7f8636so35857839f.1
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 18:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693530419; x=1694135219; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4dMw9JlURCC3zxrfj1qF1BkslT+GPRDGh6sImS/gJ88=;
        b=VOTN10AsM9NA6+aJSYJKaOvjHE+8L4n31f1WDc94IMdQiWZ1Ezzca8Gnv/rY00xPKT
         sgvukhP9KfPtsE2TmC7FC89SXj2bJF7qgi+sGPkXU9YdlbXH9r2k9f2ZRRaVHG6pyJVK
         f66/mU12RjRl2OfbqO09b4m3HI2n5o3RVfec6kvagsTzJT4DFWKB1v/n6DIE8GSiKD9d
         8QqoGMtXQa5/nGO0ceITDXl1tQN1b7TIESA+hQ88ivyAc+FhSYiwuJ0hQ2mHK90CwhT6
         YEXwlm9YS+TkMbLG12yRfCN3yBcIPr/JUkBRvH7CVqQlbD6zoUvB5+cic/CXtg6TVJ5H
         D+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693530419; x=1694135219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4dMw9JlURCC3zxrfj1qF1BkslT+GPRDGh6sImS/gJ88=;
        b=Z/jZfUTENaDOWGU8mXohiCcXbthn5lXmwyK0tRfPgtUKb+XrjNWdb8Z2074mA0LcLp
         TElX0VLUKeBgLOr39xtuqxBgo50nAQbLq6At1ifn6Y49TsxHbtD6MSoeKPd8joRHk8oY
         k5b8zl+951W8QhYlt7Ac03Fheje29ftSdyd0MnAmLCfraC7RkPUabr1edWMEBE64FcTL
         BVPZEg2GHr3helf0D3ThZgl1qH9+KYXo+VEQ83Wu35CAc/DsZEvRgIIayy82C7FTGrnu
         iu7aC9vqPbw40L4PsHqf6ZxTUa+9HfMZIMx34DHoiJqIKdInNiQioEgF6CZ0kbZrs7VA
         MZ+A==
X-Gm-Message-State: AOJu0Yz7NOnjKX7fFMPbFOfn7HVzpRKfFNEt4aAFbVDIfUbnxcHow6hF
        5rXZUdWrmOsqLVCWAIftPIZh7oR/WGwY/Vap5uHfQ46T
X-Google-Smtp-Source: AGHT+IEDAXeZG4AY3N4X3o3i/yHBhP5HgoP/MEjY9qXu7Rlgsf8gQQ35I7wnD+v2OWjq+iAk8U+gJxAA99uT8nrPyJg=
X-Received: by 2002:a6b:1494:0:b0:783:42bc:cc5f with SMTP id
 142-20020a6b1494000000b0078342bccc5fmr3992588iou.8.1693530419535; Thu, 31 Aug
 2023 18:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
 <20221129213436.GG3600936@dread.disaster.area> <CAB-bdyQw7hRpRPn9JTnpyJt1sA9vPDTVsUTmrhke-EMmGfaHBA@mail.gmail.com>
 <ZOl2IHacyqSUFgfi@dread.disaster.area> <CAB-bdyRTKNQeukwjuB=fCT91BDO5uTJzA_Y7msOdEPBDAURbzg@mail.gmail.com>
 <ZOvx2Xg31EbJXPgr@dread.disaster.area>
In-Reply-To: <ZOvx2Xg31EbJXPgr@dread.disaster.area>
From:   Shawn <neutronsharc@gmail.com>
Date:   Thu, 31 Aug 2023 18:06:23 -0700
Message-ID: <CAB-bdyQG0gDBJDt5cHHsi7avUazDtL5RO8G6UwQZj5Rw7k-CXQ@mail.gmail.com>
Subject: Re: Do I have to fsync after aio_write finishes (with fallocate
 preallocation) ?
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,
If ext size hint is not set at all,  what's the default extent size
alignment if the FS doesn't do striping (which is my case)?


On Sun, Aug 27, 2023 at 6:01=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Sat, Aug 26, 2023 at 06:09:13PM -0700, Shawn wrote:
> > xfs_io shows "extsize" as 0.   The data bsize is always 4096.  What's
> > the implication of a 0 extsize?
> >
> > $ sudo xfs_io -c 'stat' /mnt/S48BNW0K700192T/
> > fd.path =3D "/mnt/S48BNW0K700192T/"
> > fd.flags =3D non-sync,non-direct,read-write
> > stat.ino =3D 64
> > stat.type =3D directory
> > stat.size =3D 81
> > stat.blocks =3D 0
> > fsxattr.xflags =3D 0x0 [--------------]
> > fsxattr.projid =3D 0
> > fsxattr.extsize =3D 0    <=3D=3D=3D=3D  0
> > fsxattr.nextents =3D 0
> > fsxattr.naextents =3D 0
> > dioattr.mem =3D 0x200
> > dioattr.miniosz =3D 512
> > dioattr.maxiosz =3D 2147483136
>
> THere are no xflags set, meaning the XFS_DIFLAG_EXTSZINHERIT is not
> set on the directory so nothing will inherit the extsize from the
> directory at creation time. An extsize of zero is the default "don't
> do any non-default extent size alignment" (i.e. align to stripe
> parameters if the filesystem has them set, but nothing else.)
>
> If this is the root directory of a mounted filesystem, it means the
> extent size hint was not set by mkfs, and it hasn't been set
> manually via xfs_io after mount, either.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
