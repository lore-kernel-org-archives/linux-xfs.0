Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38498 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750880AbdJPHlP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 03:41:15 -0400
MIME-Version: 1.0
In-Reply-To: <20171013120603.4135344-1-arnd@arndb.de>
References: <20171013120603.4135344-1-arnd@arndb.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 16 Oct 2017 09:41:13 +0200
Message-ID: <CAMuHMdVT=r7vA+rtp1ROhzcHK-JtAK8JS1-QOf-+tK5BWT26Kw@mail.gmail.com>
Subject: Re: [PATCH] xfs: move two more RT specific functions into CONFIG_XFS_RT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, Dave Chinner <dchinner@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Oct 13, 2017 at 2:05 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The last cleanup introduced two harmless warnings:
>
> fs/xfs/xfs_fsmap.c:480:1: warning: '__xfs_getfsmap_rtdev' defined but not used
> fs/xfs/xfs_fsmap.c:372:1: warning: 'xfs_getfsmap_rtdev_rtbitmap_helper' defined but not used
>
> This moves those two functions as well.
>
> Fixes: bb9c2e543325 ("xfs: move more RT specific code under CONFIG_XFS_RT")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
