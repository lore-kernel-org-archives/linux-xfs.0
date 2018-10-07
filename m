Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43570 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbeJGTEX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Oct 2018 15:04:23 -0400
Received: by mail-lj1-f193.google.com with SMTP id r8-v6so15332582ljc.10
        for <linux-xfs@vger.kernel.org>; Sun, 07 Oct 2018 04:57:20 -0700 (PDT)
MIME-Version: 1.0
References: <20181004205749.2042-1-stefanrin@gmail.com> <20181004205749.2042-2-stefanrin@gmail.com>
 <CAAxjCEw0prn7P3dn-OuuxbmMTgzs2HydpZsgkwH8RVBkedQXOA@mail.gmail.com>
 <20181005204057.GB19324@magnolia> <CAAxjCEzGykBJLp7mssn7f3MJoS3nx6DmsXSuiNn+T7qGSYPk4w@mail.gmail.com>
In-Reply-To: <CAAxjCEzGykBJLp7mssn7f3MJoS3nx6DmsXSuiNn+T7qGSYPk4w@mail.gmail.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Sun, 7 Oct 2018 13:57:10 +0200
Message-ID: <CAAxjCEx1LemxZPSE5h2ZreNmfOuh09FQBJ=ZoPXJLr=2PTW=SA@mail.gmail.com>
Subject: Re: [PATCH 1/1] xfs_metadump: Zap more stale data
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Sun, Oct 7, 2018 at 11:43 AM Stefan Ring <stefanrin@gmail.com> wrote:
>
> Interestingly my file system has dirblklog =3D 0. I guess I'll have to
> start creating some toy file system images for experimentation.

Ok, I've found out how to create one with dirblklog > 0, but the
default seems to be, and have been for a very long time, zero
(directory blocks are the same size as file system blocks). I'm afraid
of uncovering all kinds of nastiness going this untrodden path=E2=80=A6
