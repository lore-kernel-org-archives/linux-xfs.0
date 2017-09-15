Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38172 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751698AbdIOC5B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Sep 2017 22:57:01 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsdump: master updated to ce8b006
Message-ID: <32b02ec1-de5d-f268-e726-376678c15e17@sandeen.net>
Date: Thu, 14 Sep 2017 21:57:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Felix Janda <felix.janda@posteo.de>, Khem Raj <raj.khem@gmail.com>

Hi folks,

The xfsdump repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated.

This is comprised solely of fixes for building against musl
libc; if all is well I'll tag this and push it out as 3.1.8.
If those using musl could report success or failure I'd appreciate it.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

ce8b006 common/main.c: Include <locale.h>

New Commits:

Felix Janda (8):
      [663f517] invutil/invidx: include <fcntl.h> for O_CREAT
      [b848d35] dump/content.c: Include <linux/limits.h> for XATTR_LIST_MAX
      [a03055f] common/main.c: Replace nonstandard SIGCLD by SIGCHLD
      [7a0a8e7] librmt/rmtopen: Prefer <signal.h> over <sys/signal.h>
      [cb66b83] dump/var.c: Include <limits.h> for PATH_MAX
      [dd47bfa] cleanup: Kill __[u]int*_t types
      [55b0f0e] common/types.h: explicitly define NBBY (bits per byte)
      [ce8b006] common/main.c: Include <locale.h>


Code Diffstat:

 common/content_inode.h | 4 ++--
 common/hsmapi.c        | 2 +-
 common/main.c          | 3 ++-
 common/types.h         | 4 ++++
 doc/xfsdump.html       | 8 ++++----
 dump/content.c         | 1 +
 dump/var.c             | 1 +
 inventory/inv_oref.h   | 2 +-
 inventory/inv_priv.h   | 4 ++--
 inventory/inventory.h  | 2 +-
 invutil/invidx.c       | 1 +
 librmt/rmtopen.c       | 2 +-
 12 files changed, 21 insertions(+), 13 deletions(-)
