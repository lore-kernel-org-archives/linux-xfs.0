Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55908 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754340AbeFLOgM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jun 2018 10:36:12 -0400
Received: by mail-wm0-f65.google.com with SMTP id v16-v6so21066223wmh.5
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jun 2018 07:36:11 -0700 (PDT)
Date: Tue, 12 Jun 2018 16:36:08 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Reading/changing projid of a symlink
Message-ID: <20180612143608.ok3jqtl3l34vdlpy@odin.usersys.redhat.com>
References: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Pronin <ipronin@twitter.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 30, 2018 at 05:26:46PM -0700, Ilya Pronin wrote:
> Hello,
> 
> I am trying to recursively check/change projid on a directory that
> contains symlinks among other files. The way I do it is like this
> (attributes reading part as an example, modulo error handling):
> 
> oflags = O_NOFOLLOW | O_RDONLY;
> if (S_ISDIR(stat->st_mode))
>         oflags |= O_DIRECTORY;
> if (S_ISLNK(stat->st_mode))
>         oflags |= O_PATH;
> fd = open(path, oflags, 0);
> xfsctl(NULL, fd, XFS_IOC_FSGETXATTR, &attr);
> 
> The xfsctl() call fails with EBADF. Apparently this is because
> xfsctl() is implemented as ioctl(), at least on Linux, which doesn't
> work with file descriptors obtained with O_PATH. Is there any way to
> manipulate projid on symlinks?
> 

Not sure if somebody already replied you, I couldn't find anything in my mbox,
but you can't.

Out of curiosity, why would you do that though?


> Thanks!
> 
> -- 
> Ilya Pronin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
