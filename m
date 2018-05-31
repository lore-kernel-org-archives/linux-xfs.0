Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:51406 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932450AbeEaA0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 20:26:48 -0400
Received: by mail-wm0-f42.google.com with SMTP id r15-v6so23141202wmc.1
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 17:26:47 -0700 (PDT)
MIME-Version: 1.0
From: Ilya Pronin <ipronin@twitter.com>
Date: Wed, 30 May 2018 17:26:46 -0700
Message-ID: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
Subject: Reading/changing projid of a symlink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

I am trying to recursively check/change projid on a directory that
contains symlinks among other files. The way I do it is like this
(attributes reading part as an example, modulo error handling):

oflags = O_NOFOLLOW | O_RDONLY;
if (S_ISDIR(stat->st_mode))
        oflags |= O_DIRECTORY;
if (S_ISLNK(stat->st_mode))
        oflags |= O_PATH;
fd = open(path, oflags, 0);
xfsctl(NULL, fd, XFS_IOC_FSGETXATTR, &attr);

The xfsctl() call fails with EBADF. Apparently this is because
xfsctl() is implemented as ioctl(), at least on Linux, which doesn't
work with file descriptors obtained with O_PATH. Is there any way to
manipulate projid on symlinks?

Thanks!

-- 
Ilya Pronin
