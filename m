Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572A1C64EC7
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 13:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCANmL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Mar 2023 08:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjCANmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2023 08:42:06 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86A33E09A
        for <linux-xfs@vger.kernel.org>; Wed,  1 Mar 2023 05:42:05 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id q2so4719306qki.3
        for <linux-xfs@vger.kernel.org>; Wed, 01 Mar 2023 05:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFV62NWjjWwjMm2q/DaDrlaQMlESvcOEXD9T0dqXrDk=;
        b=iZ+sGSRLvMUVfQUGFCSRCwPgM6A1hC+Un0Qjcmbon+kRLWIi+0ScNhG5sqiej0fyva
         lk660MrfUYMAu7u+9eYnk2YTzW5sMJgaJKYtbUobN5z6aqQWAUHVNWo4ZnnAZrSXtMKQ
         AKiIIO/JUfXnIuE6p1aKjLxdMiMElm0fcZP5XF4B0GlS5WF09FD4noUHnRHbd/eui8mZ
         zEhj8YwHdzjK/gxZvhOnQiVcq9RVUgtP+QVr9FKPBm3H4uM/WvFTjmXaIJIWRADpLSmD
         zDLgmHweg6Fl/S1P3QQ3KlD1D6dE41f3iW1v/G2T74H8ebdN8DxJNU28VadWWYlD9m3k
         A+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AFV62NWjjWwjMm2q/DaDrlaQMlESvcOEXD9T0dqXrDk=;
        b=E72v1I2pZ6NEn7ME2/Hen2srFEnDbHUiDE1BU5LK4aGM7pSWwdV3qVGdyj/HgMk9iW
         7YJ5u89IK1kEUDBKQc8fBDOAM6pblcd5rCHrVMPtSNVHoUUderz2NJbaTRpO+TD+ME24
         43idA+esk3xFxEwqW2qZPikWjHg4xkX5DZuj7w7tL8YeHHLFEiIG/iuYaW4k5grWMFH2
         do2yf7zIFdp7cFUQDShtxPzXD/zL25tQZWZzZP+owfk7bAB13xCUGT1uRXNhTjNBdqAk
         xmDz5YRD9pBtAyU4fla+SJlX6XtozbMi+5HK1x+FkyUj5MA3OOeuJIQjvVjEqvEdvk8p
         xC6g==
X-Gm-Message-State: AO0yUKUMyrth5nwSrk8nMg/kJx6wUFTZsy6IWLpjMj4YXA22YB+UgDLW
        2XUTe0FyYaFnTCno32xuTUNOpopYOEvNpYz9ni6xGQAmEC8=
X-Google-Smtp-Source: AK7set+d6UHnLQ+LqT7rqfHxfKG7/yWRhUSZUhI4WO+p3EDiA18GBHdDwYPeKDAuh2RuN8IZt/WuK4X07Ovyhs3O/cY=
X-Received: by 2002:a37:43d5:0:b0:742:6fd3:f662 with SMTP id
 q204-20020a3743d5000000b007426fd3f662mr1255862qka.11.1677678124508; Wed, 01
 Mar 2023 05:42:04 -0800 (PST)
MIME-Version: 1.0
References: <20230301001706.1315973-1-david@fromorbit.com> <Y/6ghfyWXLuCefkn@magnolia>
 <20230301010417.GE360264@dread.disaster.area>
In-Reply-To: <20230301010417.GE360264@dread.disaster.area>
From:   =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date:   Wed, 1 Mar 2023 14:41:53 +0100
Message-ID: <CAHpGcMKA7Qy+DA0-JVU=YyOSQi4eeGN8GGFCo_edCVVBNV_v+g@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix off-by-one-block in xfs_discard_folio()
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Am Mi., 1. M=C3=A4rz 2023 um 02:07 Uhr schrieb Dave Chinner <david@fromorbi=
t.com>:
> On Tue, Feb 28, 2023 at 04:47:01PM -0800, Darrick J. Wong wrote:
> > On Wed, Mar 01, 2023 at 11:17:06AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > The recent writeback corruption fixes changed the code in
> > > xfs_discard_folio() to calculate a byte range to for punching
> > > delalloc extents. A mistake was made in using round_up(pos) for the
> > > end offset, because when pos points at the first byte of a block, it
> > > does not get rounded up to point to the end byte of the block. hence
> > > the punch range is short, and this leads to unexpected behaviour in
> > > certain cases in xfs_bmap_punch_delalloc_range.
> > >
> > > e.g. pos =3D 0 means we call xfs_bmap_punch_delalloc_range(0,0), so
> > > there is no previous extent and it rounds up the punch to the end of
> > > the delalloc extent it found at offset 0, not the end of the range
> > > given to xfs_bmap_punch_delalloc_range().
> > >
> > > Fix this by handling the zero block offset case correctly.
> > >
> > > Fixes: 7348b322332d ("xfs: xfs_bmap_punch_delalloc_range() should tak=
e a byte range")
> > > Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> > > Found-by: Brian Foster <bfoster@redhat.com>
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_aops.c | 14 ++++++++++++--
> > >  1 file changed, 12 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > > index 41734202796f..429f63cfd7d4 100644
> > > --- a/fs/xfs/xfs_aops.c
> > > +++ b/fs/xfs/xfs_aops.c
> > > @@ -466,6 +466,7 @@ xfs_discard_folio(
> > >  {
> > >     struct xfs_inode        *ip =3D XFS_I(folio->mapping->host);
> > >     struct xfs_mount        *mp =3D ip->i_mount;
> > > +   xfs_off_t               end_off;
> > >     int                     error;
> > >
> > >     if (xfs_is_shutdown(mp))
> > > @@ -475,8 +476,17 @@ xfs_discard_folio(
> > >             "page discard on page "PTR_FMT", inode 0x%llx, pos %llu."=
,
> > >                     folio, ip->i_ino, pos);
> > >
> > > -   error =3D xfs_bmap_punch_delalloc_range(ip, pos,
> > > -                   round_up(pos, folio_size(folio)));
> > > +   /*
> > > +    * Need to be careful with the case where the pos passed in point=
s to
> > > +    * the first byte of the folio - rounding up won't change the val=
ue,
> > > +    * but in all cases here we need to end offset to point to the st=
art
> > > +    * of the next folio.
> > > +    */
> > > +   if (pos =3D=3D folio_pos(folio))
> > > +           end_off =3D pos + folio_size(folio);
> > > +   else
> > > +           end_off =3D round_up(pos, folio_size(folio));
> >
> > Can this construct be simplified to:
> >
> >       end_off =3D round_up(pos + 1, folio_size(folio));
>
> I thought about that first, but I really, really dislike sprinkling
> magic "+ 1" corrections into the code to address non-obvious
> unexplained off-by-one problems.
>
>
> > If pos is the first byte of the folio, it'll round end_off to the start
> > of the next folio.  If pos is (somehow) the last byte of the folio, the
> > first argument to round_up is already the first byte of the next folio,
> > and rounding won't change it.
>
> Yup, and that's exactly the problem I had with doing this - it
> relies on the implicit behaviour that by moving last byte of a block
> to the first byte of the next block, round_up() won't change the end
> offset.  i.e. the correct functioning of the code is just as
> non-obvious with a magic "+ 1" as the incorrect functioning was
> without it.

Hmm. On the other hand, it's not immediately obvious that the if
statement only does an addition with rounding; it might as well do
something more complex. Darrick's version avoids making things more
complicated than they need to be.

Other ways of doing the same thing would be:

end_off =3D round_down(pos, folio_size(folio)) + folio_size(folio);
end_off =3D folio_pos(folio) + folio_size(folio);

> Look at it this way: I didn't realise it was wrong when I wrote the
> code, and I couldn't find the bug round_up() introduced when reading
> the code even after the problem had been bisected to this exact
> change. The code I wrote is bad, and adding a magic "+ 1" to fix the
> bug doesn't make the code any better.
>
> Given this is a slow path, so I see no point in optimising the code
> for efficiency. IMO, clarity of the logic and calculation being made
> is far more important - obviously correct logic is better than
> relying on the effect of a magic "+ 1" on some other function to
> acheive the same thing....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

Cheers,
Andreas
