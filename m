Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:44619 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751909AbeBALbh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 06:31:37 -0500
MIME-Version: 1.0
In-Reply-To: <1517480584-4588-1-git-send-email-geert@linux-m68k.org>
References: <1517480584-4588-1-git-send-email-geert@linux-m68k.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 1 Feb 2018 12:31:36 +0100
Message-ID: <CAK8P3a1N-Yh65y6bEb+d7DwVOqB8ee=T1gM1cc7k6=cg1c3Jtw@mail.gmail.com>
Subject: Re: [PATCH] xfs: Add missing braces around xfs_scrub_agfl_info initializer
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Feb 1, 2018 at 11:23 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> With gcc-4.1.2:
>
>     fs/xfs/scrub/agheader.c: In function =E2=80=98xfs_scrub_agfl=E2=80=99=
:
>     fs/xfs/scrub/agheader.c:770: warning: missing braces around initializ=
er
>     fs/xfs/scrub/agheader.c:770: warning: (near initialization for =E2=80=
=98sai.oinfo=E2=80=99)
>
> The first member of struct xfs_scrub_agfl_info is no longer an integral
> type, but a struct.  Add the missing curly braces to fix this.

I suspect gcc-4.5 is affected as well, but not 4.6+

> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -767,7 +767,7 @@ int
>  xfs_scrub_agfl(
>         struct xfs_scrub_context        *sc)
>  {
> -       struct xfs_scrub_agfl_info      sai =3D { 0 };
> +       struct xfs_scrub_agfl_info      sai =3D { { 0 } };
>         struct xfs_agf                  *agf;

Looks ok to me, but

        struct xfs_scrub_agfl_info      sai =3D { };

might be slightly better in case the first member changes again.

     Arnd
