Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:50333 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbdIODcO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2017 23:32:14 -0400
Received: by mail-pg0-f50.google.com with SMTP id p5so792046pgn.7
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2017 20:32:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <32b02ec1-de5d-f268-e726-376678c15e17@sandeen.net>
References: <32b02ec1-de5d-f268-e726-376678c15e17@sandeen.net>
From: Khem Raj <raj.khem@gmail.com>
Date: Thu, 14 Sep 2017 20:31:43 -0700
Message-ID: <CAMKF1spg5jrxPnm8_wwsW=pj90pVjsFxsthfiV3FaJfK+z62FQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] xfsdump: master updated to ce8b006
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Felix Janda <felix.janda@posteo.de>

On Thu, Sep 14, 2017 at 7:57 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Hi folks,
>
> The xfsdump repository at:
>
>         git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git
>
> has just been updated.
>
> This is comprised solely of fixes for building against musl
> libc; if all is well I'll tag this and push it out as 3.1.8.
> If those using musl could report success or failure I'd appreciate it.
>

Just tried. we still need

https://patchwork.kernel.org/patch/9946149/

to get musl builds going.

> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
>
> The new head of the master branch is commit:
>
> ce8b006 common/main.c: Include <locale.h>
>
> New Commits:
>
> Felix Janda (8):
>       [663f517] invutil/invidx: include <fcntl.h> for O_CREAT
>       [b848d35] dump/content.c: Include <linux/limits.h> for XATTR_LIST_MAX
>       [a03055f] common/main.c: Replace nonstandard SIGCLD by SIGCHLD
>       [7a0a8e7] librmt/rmtopen: Prefer <signal.h> over <sys/signal.h>
>       [cb66b83] dump/var.c: Include <limits.h> for PATH_MAX
>       [dd47bfa] cleanup: Kill __[u]int*_t types
>       [55b0f0e] common/types.h: explicitly define NBBY (bits per byte)
>       [ce8b006] common/main.c: Include <locale.h>
>
>
> Code Diffstat:
>
>  common/content_inode.h | 4 ++--
>  common/hsmapi.c        | 2 +-
>  common/main.c          | 3 ++-
>  common/types.h         | 4 ++++
>  doc/xfsdump.html       | 8 ++++----
>  dump/content.c         | 1 +
>  dump/var.c             | 1 +
>  inventory/inv_oref.h   | 2 +-
>  inventory/inv_priv.h   | 4 ++--
>  inventory/inventory.h  | 2 +-
>  invutil/invidx.c       | 1 +
>  librmt/rmtopen.c       | 2 +-
>  12 files changed, 21 insertions(+), 13 deletions(-)
