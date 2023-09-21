Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B43BE7D0A9
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 20:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjIUUVl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjIUUVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 16:21:19 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5125AABE;
        Thu, 21 Sep 2023 10:29:30 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-4122436627eso7353941cf.3;
        Thu, 21 Sep 2023 10:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695317360; x=1695922160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+mmJBeIQyh9AKpgzVKPX/9HHjXQslKOl8+/2xlNOGo=;
        b=jrYYoNVtgvBsMD2gblosKO5BMvgvNkU7dfxuiPH+f6nUB3vtyGS9bEkvW78wFp1Wg7
         hKbWrSSpP7mw8O/8j69Np+hd3I42LObX8s5w3WFG2e37SO39IMjbdXoxg2Y59bYp5Mnm
         zeUnZ13FVUGAri27/Iyj/tw+nssh6Uow6+dqs623L/64vxx1QVvkQyQXErXIotZFHbEp
         dOHJu3HjbrfNJfzxcD5IAWQSRuBIoTdxChjB/9sblwQbfKkwz4ByInEiDAiFzw2pp8My
         cWEapkpDoe5QfxyRngJ2L1jvsaM7Qoc2TaOvaC4DykiW6Azzd5eAtoXtoMuhGZ8t9zO3
         uFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695317360; x=1695922160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x+mmJBeIQyh9AKpgzVKPX/9HHjXQslKOl8+/2xlNOGo=;
        b=Lr95pIYZRawn5kbnaAyOwteJnxwcuq5w4foD8JVh8YZyhqdYP193WMlHQI/5pHktFT
         /pK2b7VKUXxNM4DBanafp6B0XlO+ohhBlkqZUjNQypbE9Ih8gvuHmyX8xJ8jrDwMY/lL
         xF+vgvFjv3xF4RwDyBje50KOE1oWTiwSDU/4vCjRYZ1EjbEqeUJFIgqqFG6GnKnt1XsB
         UKinnCK2LhZsDfpKxZ683c7sJ/QAV8wsdfGbX/U/aw1lFWIg7QJQleg7dUar0yBfQvhN
         CHeZde/VMQ6doM4X3MPHTfZE712N0Npq+EJiNJZxj3Kna1dRV2/kLJq783pcvs6DKydZ
         m1Cg==
X-Gm-Message-State: AOJu0YzcSERR0WYY8pVKxLxtjFrHE4dqdgjzTzN6CagtSgc5zxuHxBqh
        bapYEoNcqRcTpSujtNhJ1ru1QmmXvuveVGxM/kHRTP0o
X-Google-Smtp-Source: AGHT+IFtABX3Om1wb9WP85gdR2M47/OyoEW5EDdezUm63jPLi8WfleL4sUaVZ/UA5IaHjqjagOHzZ4FlRI3ofkLd18s=
X-Received: by 2002:a05:6102:9c1:b0:44d:4f8f:d8e5 with SMTP id
 g1-20020a05610209c100b0044d4f8fd8e5mr6217017vsi.20.1695306563230; Thu, 21 Sep
 2023 07:29:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230920130355.62763-1-amir73il@gmail.com> <20230920151403.gsh5gphvlilhp6sv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxhxsg2AwttYPfhSLQQNbFxo2pmyNUMTC8QpxNw6L_afpw@mail.gmail.com>
 <20230921062645.lhryfrod7ggdxfuh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxjNy6tD87dsGKAOwu6VpkoH3+kgzOEw=KQOzDF1WhhN=A@mail.gmail.com> <20230921142426.p5g7yqf2gunemnd6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20230921142426.p5g7yqf2gunemnd6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 21 Sep 2023 17:29:12 +0300
Message-ID: <CAOQ4uxiEvwqCkgaCuSZnziePwWU1E3X1xLa7RX4GfkzgN9LWAQ@mail.gmail.com>
Subject: Re: [PATCH] overlay: add test for rename of lower symlink with
 NOATIME attr
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2023 at 5:24=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Thu, Sep 21, 2023 at 11:00:37AM +0300, Amir Goldstein wrote:
> > On Thu, Sep 21, 2023 at 9:26=E2=80=AFAM Zorro Lang <zlang@redhat.com> w=
rote:
> > >
> > > On Wed, Sep 20, 2023 at 06:34:21PM +0300, Amir Goldstein wrote:
> > > > On Wed, Sep 20, 2023 at 6:14=E2=80=AFPM Zorro Lang <zlang@redhat.co=
m> wrote:
> > > > >
> > > > > On Wed, Sep 20, 2023 at 04:03:55PM +0300, Amir Goldstein wrote:
> > > > > > A test for a regression from v5.15 reported by Ruiwen Zhao:
> > > > > > https://lore.kernel.org/linux-unionfs/CAKd=3Dy5Hpg7J2gxrFT02F94=
o=3DFM9QvGp=3DkcH1Grctx8HzFYvpiA@mail.gmail.com/
> > >
> > > Could you give one more sentence to tell what kind of regression
> > > does this case test for? Not only a link address.
> > >
> > > > > >
> > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > ---
> > > > > >
> > > > > > Zorro,
> > > > > >
> > > > > > This is a test for a regression in kernel v5.15.
> > > > > > The fix was merged for 6.6-rc2 and has been picked for
> > > > > > the upcoming LTS releases 5.15, 6.1, 6.5.
> > > > > >
> > > > > > The reproducer only manifests the bug in fs that inherit noatim=
e flag,
> > > > > > namely ext4, btrfs, ... but not xfs.
> >
> > FYI, I made a mistake in the statement above.
> > xfs does support inherit of noatime flag, but
> > it does not inherit noatime for *symlinks*.
> >
> > I added the _require_chattr_inherit helper that you suggested
> > in v2, but it only checks for inherit of noatime flag (the 2nd _notrun)=
.
> > I did not add a helper for _require_chattr_inherit_symlink
> > because it was too specific and so I left the 3rd _notrun
> > open coded in the test in v2.
>
> OK, if xfs thinks it's an expected behavior which won't be changed :)
>

I find it quite strange that symlink and special inodes inherit those
attributes, but then the attributes cannot be queried and not changed
on those inodes.
It seems to me like all the fs expect xfs have it wrong, but I don't think
that is likely to change.

Thanks,
Amir.
