Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58CCC43334
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 04:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiFBEYj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 00:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiFBEYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 00:24:39 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DA523354F;
        Wed,  1 Jun 2022 21:24:38 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id k12so2649696qtx.13;
        Wed, 01 Jun 2022 21:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9sB7QrgajZiaf0sht2T6Uy1M0zWQ2agmzlX2Tp1zpps=;
        b=gkd87100n1xCdPVW5UFE6T4MdvZyQbr91J0sd/FZ3sJfOc7tczIYrs0LgohpfBY16D
         bDTS4WeBSXiBcgYu3ZhQdlEmCo+uVrnu09p3MoscX3VfxBaF9VIuY2kM1D80hKGYfWLZ
         wa+0frYjdmhvXdFLvNGRODdbv5Vko3yhzJG1M1/GBTvfONrXfYhK1ScBbwQq6U48rj/s
         wxX82yYlOt/CYKFnaQnRYDX04Q+YJ4uI4WBI0dRu2Fn6OHVbUk4CvMMK5weGVnwOBu7O
         ow7iJsXS5F3Y4bWYAA3U2I0VYX0jOcGQYwOcEmFzd2ClZuOIJDWdRabL6ipb05BKsC+Y
         gsYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9sB7QrgajZiaf0sht2T6Uy1M0zWQ2agmzlX2Tp1zpps=;
        b=YBC1cTAAY5JSsS+0Typ+O22fJ7SsBLh32IVb/I6ESu20z6XuvLQDXWvJiiuYSPzZGp
         hU+NVAarh8scBFNAgSR0Lq68EyGR3fkhRPMR9QYjnK38OZSToVpiRvt3laK4iJ9Wklcy
         /cAejJkX/xehe/KPauMbqQOnqcJeSN/LCAUU3BQCkZdv9xzc0V1uncc+A32ok/L6BvB8
         yunP32OoEr8CsmdS+ar2mHJ9hNh5Qp3xWPNN9fAuGdwIP+TQm0VJ7U/bqh+hXbXravBv
         M4r290txK+aMb2kOLGl74iema7LAhg84xsdXBlS0fKW+jmAne8pz55RtkkTXLabBO4Qm
         qCxw==
X-Gm-Message-State: AOAM530gN2tsFTzWIi0+OhTkam9pKEBnBucHL2kbD75yz62DBLCYwAeH
        2Cow6p8VklZMYRWK2/6iYk7BraLRSqrg914GfGI=
X-Google-Smtp-Source: ABdhPJzmnOTiqDvbToW+BKAZdpU7EW6XmB6pICmTlbYjTtyOcKOMHwExgKEqmvgZCEcu11nStJhsukDJjtnDZ9kU7/0=
X-Received: by 2002:a05:622a:1a95:b0:301:da99:5a0c with SMTP id
 s21-20020a05622a1a9500b00301da995a0cmr2392234qtc.424.1654143877425; Wed, 01
 Jun 2022 21:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220601104547.260949-1-amir73il@gmail.com> <20220601104547.260949-8-amir73il@gmail.com>
 <20220602003804.GJ227878@dread.disaster.area>
In-Reply-To: <20220602003804.GJ227878@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 2 Jun 2022 07:24:26 +0300
Message-ID: <CAOQ4uxg8Y_7mkf+ieWBAuspCDG+H5Ci2P7xMudxF49nV5M0czg@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 7/8] xfs: consider shutdown in bmapbt
 cursor delete assert
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 2, 2022 at 3:38 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Jun 01, 2022 at 01:45:46PM +0300, Amir Goldstein wrote:
> > From: Brian Foster <bfoster@redhat.com>
> >
> > commit 1cd738b13ae9b29e03d6149f0246c61f76e81fcf upstream.
> >
> > The assert in xfs_btree_del_cursor() checks that the bmapbt block
> > allocation field has been handled correctly before the cursor is
> > freed. This field is used for accurate calculation of indirect block
> > reservation requirements (for delayed allocations), for example.
> > generic/019 reproduces a scenario where this assert fails because
> > the filesystem has shutdown while in the middle of a bmbt record
> > insertion. This occurs after a bmbt block has been allocated via the
> > cursor but before the higher level bmap function (i.e.
> > xfs_bmap_add_extent_hole_real()) completes and resets the field.
> >
> > Update the assert to accommodate the transient state if the
> > filesystem has shutdown. While here, clean up the indentation and
> > comments in the function.
> >
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.c | 33 ++++++++++++---------------------
> >  1 file changed, 12 insertions(+), 21 deletions(-)
>
> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=56486f307100e8fc66efa2ebd8a71941fa10bf6f
>

Warm from the over :)

I will need more time to verify that this new fix is not breaking LTS
but I don't think that it should be blocking taking the old 5.12 fix now.
Right?

Thanks,
Amir.
