Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752560AbdBAWUA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Feb 2017 17:20:00 -0500
From: Richard Weinberger <richard@nod.at>
Subject: xfsprogs build broken on armv7l
Message-ID: <8cbc97e0-de81-658c-d6b6-b7d65b9f83c6@nod.at>
Date: Wed, 1 Feb 2017 23:19:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gwendal@chromium.org
Cc: "vapier@gentoo.org" <vapier@gentoo.org>, hch@lst.de, Eric Sandeen <sandeen@sandeen.net>, David Oberhollenzer <goliath@sigma-star.at>, David Gstir <david@sigma-star.at>

Hi!

On my armv7 box, current xfsprogs fail to build:
    [TEST]    CRC32
In file included from crc32.c:37:0:
../include/xfs.h:53:12: error: size of array ‘xfs_assert_largefile’ is too large

First bad commit is:
commit 0a71e38396304b4d1215ba0b51cd6ce8e33eb40d
Author: Gwendal Grignou <gwendal@chromium.org>
Date:   Thu Jan 12 14:12:29 2017 -0600

    build: Allow compiling xfsprogs in a cross compile environment

    Without this patch, we are using the same compiler and options for the host
    compiler (BUILD_CC) and the target compiler (CC), and we would get error
    messages at compilation:
    x86_64-pc-linux-gnu-gcc -O2 -O2 -pipe -march=armv7-a -mtune=cortex-a15 ...
    x86_64-pc-linux-gnu-gcc.real: error: unrecognized command line option
    '-mfpu=neon'
    '-mfloat-abi=hard'
    '-clang-syntax'
    '-mfpu=neon'
    '-mfloat-abi=hard'
    '-clang-syntax'

    Add BUILD_CC and BUILD_CFLAGS as precious variables to allow setting it up
    from the ebuild.

    Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
    Reviewed-by: Mike Frysinger <vapier@gentoo.org>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Thanks,
//richard
