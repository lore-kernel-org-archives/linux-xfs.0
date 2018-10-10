Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38386 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbeJJQ7Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 12:59:25 -0400
Received: by mail-lj1-f195.google.com with SMTP id v7-v6so4260265ljg.5
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 02:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20181004205749.2042-1-stefanrin@gmail.com> <20181004205749.2042-2-stefanrin@gmail.com>
 <CAAxjCEw0prn7P3dn-OuuxbmMTgzs2HydpZsgkwH8RVBkedQXOA@mail.gmail.com>
 <20181005204057.GB19324@magnolia> <CAAxjCEzGykBJLp7mssn7f3MJoS3nx6DmsXSuiNn+T7qGSYPk4w@mail.gmail.com>
 <CAAxjCEx1LemxZPSE5h2ZreNmfOuh09FQBJ=ZoPXJLr=2PTW=SA@mail.gmail.com>
In-Reply-To: <CAAxjCEx1LemxZPSE5h2ZreNmfOuh09FQBJ=ZoPXJLr=2PTW=SA@mail.gmail.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Wed, 10 Oct 2018 11:37:51 +0200
Message-ID: <CAAxjCExnpwZXN3wR_hrj8mSd5if3Otba1jaS=FV5U9zn2zcDmA@mail.gmail.com>
Subject: Re: [PATCH 1/1] xfs_metadump: Zap more stale data
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Sun, Oct 7, 2018 at 1:57 PM Stefan Ring <stefanrin@gmail.com> wrote:
>
> On Sun, Oct 7, 2018 at 11:43 AM Stefan Ring <stefanrin@gmail.com> wrote:
> >
> > Interestingly my file system has dirblklog =3D 0. I guess I'll have to
> > start creating some toy file system images for experimentation.
>
> Ok, I've found out how to create one with dirblklog > 0, but the
> default seems to be, and have been for a very long time, zero
> (directory blocks are the same size as file system blocks). I'm afraid
> of uncovering all kinds of nastiness going this untrodden path=E2=80=A6

I think I'm fine now. I'll post an updated patch soon.
