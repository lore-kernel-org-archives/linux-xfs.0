Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DCFEB64DD
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Jun 2023 17:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjFYRiq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Jun 2023 13:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjFYRio (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Jun 2023 13:38:44 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208C719F
        for <linux-xfs@vger.kernel.org>; Sun, 25 Jun 2023 10:38:43 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-635783b8b80so13754266d6.1
        for <linux-xfs@vger.kernel.org>; Sun, 25 Jun 2023 10:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687714723; x=1690306723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RrA1jj0sbuS7qnDi1/w+/r07BoPDDnF9j6v+8W3e2So=;
        b=Erb2gR7thcdNLtG13m4xEQsPkt/NkeSH8BEI9aFw/X6ig6ppwvAC99+KZPwQcw3p//
         31xm9sako+oktqJZxPQDqBt1wWT8i6J3tNSR4VqOeAeXS21/ksZyXLzFEeidWe71jozC
         cVPC/N1F0lSrE5eP89m/DGqOOcgmL5qfPLcqDoS2W5xI5jhvFAix7P5Yux94fMpvjfqn
         4AmSRruKCgTYtD3728z+YrypIiqQcMOW+5VkAT3QxkfbvCZmJ+EukglnT5RBKPLJSZwq
         UCDWY/N9cI5pXQi9E7Y72azExLG3vCK8lf2BGiN2vlGfnNPtS49wNNB0cDUTrCeZLLx3
         690A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687714723; x=1690306723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RrA1jj0sbuS7qnDi1/w+/r07BoPDDnF9j6v+8W3e2So=;
        b=bbIna9bP2mvepk41c4onAac9FkQ62t7Vq8e5lriO4I9W54za1uOqIFmqYwgCR3WCxJ
         1+BjejeuqH+btVnM3g4ey6FiBQiTIgaqeMdfS3Gs5JK1KLDZZp9wZ7r4JsXkJ4XkmRKy
         wvLbAwT5D5uO9v6qgBq1QVSPo8nZHjF+chaZgW5g06B5utNZevSq+A844tSaNKlYoSqD
         B7lkOGYACpNo+ILfLah29/58MnD6WPxlE7g90bf5KUX/5Y3WlAi7ETlFfkhbJHiJmDf9
         ZqaLn5zw4RnRStFbm1JAN7H8XaB8oi3qNHVtbVELeTdhphdOXGWiQauwGoyswWN8+VAx
         kMNQ==
X-Gm-Message-State: AC+VfDx1vMBhZtfMkWjQDHDMaOWHD1d578CKI2pn5MPsDltSy21eZfmR
        J8ZpNq4eP/K7PQmv6RtEv2Az2Mr0ncrzba9sHWjH0pup6CA=
X-Google-Smtp-Source: ACHHUZ5GxXmT1mmLt0+/GpZE2jZ3+WPIqiId8yxhJQcNdev78flYD6VikF/CMGNsyjX3X8o0q/3obo/YHheaUq+zMx0=
X-Received: by 2002:a05:6214:501b:b0:62f:ec06:6c93 with SMTP id
 jo27-20020a056214501b00b0062fec066c93mr22998489qvb.51.1687714722899; Sun, 25
 Jun 2023 10:38:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAEBim7C575WhuWGO7_VJ62+6s2g4XFFgoF6=SrGX30nBYcD12Q@mail.gmail.com>
 <3def220e-bc7b-ceb2-f875-cffe3af8471b@sandeen.net> <CAEBim7DSUKg6TGZ_DKZ1rhbEHpfLN0aBDkc57gkgUgtnnc7xNQ@mail.gmail.com>
 <de3023eb-4481-ae72-183b-2d91f3c25212@sandeen.net> <CAEBim7BZsCYxjucpN5R8HpP+BpFezSzZ1QiA1COqU3-MZ18eXQ@mail.gmail.com>
 <99544e27-0871-6d0e-0576-5f28bc736978@sandeen.net>
In-Reply-To: <99544e27-0871-6d0e-0576-5f28bc736978@sandeen.net>
From:   Fernando CMK <ferna.cmk@gmail.com>
Date:   Sun, 25 Jun 2023 14:38:31 -0300
Message-ID: <CAEBim7B1C3P=zzyBvNhis7=HmTb_NZrmKG8cie=F+qVVYENisg@mail.gmail.com>
Subject: Re: xfs_rapair fails with err 117. Can I fix the fs or recover
 individual files somehow?
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ok, I'll try it on a new copy. BTW, are you sure it's "swidth"?

It's complaining as follows:

Metadata corruption detected at 0x5627b63fec08, xfs_sb block 0x98580000/0x1=
000
field swidth not found

Thanks for your help.



On Sat, Jun 24, 2023 at 10:48=E2=80=AFPM Eric Sandeen <sandeen@sandeen.net>=
 wrote:
>
> On 6/24/23 1:25 PM, Fernando CMK wrote:
> >> It seems that the only problem w/ the filesystem detected by repair is=
 a
> >> ridiculously large stripe width, and that's found on every superblock.
> > If that's the issue, is there a way to set the correct stripe width?
> > Also... the md array involved has 3 disks, if that's of any help.
> >
>
> Yes, you can rewrite each superblock (all 42) with xfs_db in -x mode.
>
> I would suggest trying it on a fresh copy of the image file in case
> something goes wrong.
>
> for S in `seq 0 41`; do
>   xfs_db -x -c "sb $S" -c "write swidth 256" <image_file>
> done
>
> or something similar
>
> I'm really baffled about how your filesystem possibly got into this
> shape, though.
