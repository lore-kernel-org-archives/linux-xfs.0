Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750958AbcL1Iek (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Dec 2016 03:34:40 -0500
Date: Wed, 28 Dec 2016 16:34:20 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2] xfs_io: implement 'utimes' command
Message-ID: <20161228083420.GZ1859@eguan.usersys.redhat.com>
References: <1482202286-8390-1-git-send-email-deepa.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482202286-8390-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: linux-xfs@vger.kernel.org, arnd@arndb.de, y2038@lists.linaro.org

On Mon, Dec 19, 2016 at 06:51:26PM -0800, Deepa Dinamani wrote:
> Add the utimes command to provide a way to utilize
> the futimens C library call. This is the
> interface to the utimensat system call, which updates
> the mtime and atime of a file.
> 
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> ---
> Changes since v1:
> * changed error return values
> * removed redundant roff formatting directive
> * removed unneeded argument count check
> 
>  include/input.h   |  1 +
>  io/Makefile       |  2 +-
>  io/init.c         |  1 +
>  io/io.h           |  1 +
>  io/utimes.c       | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  libxcmd/input.c   | 22 +++++++++++++++
>  man/man8/xfs_io.8 | 11 ++++++++
>  7 files changed, 118 insertions(+), 1 deletion(-)
>  create mode 100755 io/utimes.c
>  mode change 100644 => 100755 libxcmd/input.c

Just one nit, I think c files should not have "x" in file modes.

Thanks,
Eryu
