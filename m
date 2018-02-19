Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59020 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932180AbeBSWyB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Feb 2018 17:54:01 -0500
Subject: Re: Debian packaging updates
References: <CAFMei7PKv0hQnpwKA+qkkjMa9rqXdq8JfBdUjHkgXT1R9nd=GQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1d732605-bcc9-c1f3-2d7c-1a5449317831@sandeen.net>
Date: Mon, 19 Feb 2018 16:53:59 -0600
MIME-Version: 1.0
In-Reply-To: <CAFMei7PKv0hQnpwKA+qkkjMa9rqXdq8JfBdUjHkgXT1R9nd=GQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nathan Scott <nathans@redhat.com>, "Sandeen, Eric" <sandeen@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>



On 2/19/18 3:56 AM, Nathan Scott wrote:
> Hi Eric, Darrick, all,
> 
> Some Debian packaging updates for xfsprogs, hopefully in time for
> 4.15.0 still.  Enjoy!

Plenty of time :)

Can you fix up the other error in this line as well?

-_("Lazy superblock counted always enabled for CRC enabled filesytems\n"));
+_("Lazy superblock counted always enabled for CRC enabled filesystems\n"));
                          ^

Looks fine to me otherwise, insofar as I understand debian packaging
(which is to say, not at all) ;)

Thanks,
-Eric

> Changes committed to https://github.com/natoscott/xfsprogs master
> 
> Nathan Scott (4):
>       Several updates to use more modern Debian packaging
>       Update .gitignore list for generated scrub cron file
>       Add xfs_scrub_fail systemd service file docs entry
>       Fix grammar and spelling in strings and man pages
> 
>  .gitignore                       |    1 +
>  Makefile                         |    4 +++-
>  debian/changelog                 |   10 ++++++++++
>  debian/compat                    |    2 +-
>  debian/control                   |    2 +-
>  debian/rules                     |    8 ++++++--
>  debian/source/format             |    1 +
>  io/mmap.c                        |    2 +-
>  io/prealloc.c                    |    2 +-
>  man/man8/xfs_io.8                |    2 +-
>  man/man8/xfs_quota.8             |    4 ++--
>  mkfs/xfs_mkfs.c                  |   12 ++++++------
>  scrub/xfs_scrub_fail@.service.in |    1 +
>  13 files changed, 35 insertions(+), 16 deletions(-)
> 
> 
> commit e9a183018503fc1a08d6c84307089ae9cb67ac6c
> Author: Nathan Scott <nathans@debian.org>
> Date:   Mon Feb 19 20:46:41 2018 +1100
> 
>     Fix grammar and spelling in strings and man pages
> 
>     Signed-off-by: Nathan Scott <nathans@debian.org>
> 
> commit b43b9d237b40905dcd8175d090c4c34413175d73
> Author: Nathan Scott <nathans@debian.org>
> Date:   Mon Feb 19 20:42:14 2018 +1100
> 
>     Add xfs_scrub_fail systemd service file docs entry
> 
>     Signed-off-by: Nathan Scott <nathans@debian.org>
> 
> commit 579435f65985bd93d1e42d7710432531ce9d17c8
> Author: Nathan Scott <nathans@debian.org>
> Date:   Mon Feb 19 20:40:50 2018 +1100
> 
>     Update .gitignore list for generated scrub cron file
> 
>     Signed-off-by: Nathan Scott <nathans@debian.org>
> 
> commit 02ccd5edb4437fdd0f2a6e64a7f0bfa3072fcbb5
> Author: Nathan Scott <nathans@debian.org>
> Date:   Mon Feb 19 20:39:51 2018 +1100
> 
>     Several updates to use more modern Debian packaging
> 
>     Switch to Debian packaging features available in more
>     recent years to resolve some long-standing issues.
> 
>     In particular, using the quilt format gives non-native
>     package builds finally, while keeping the ability for
>     developers to do upstream deb builds.  Also split the
>     binary-arch and binary-indep debian/rules targets as
>     is now mandated, and update to latest standard version.
>     Mark a bunch of long-resolved bugs as fixed in the deb
>     changelog so they are automatically closed by the next
>     update.
> 
>     Signed-off-by: Nathan Scott <nathans@debian.org>
> 
> 
> cheers.
> 
> --
> Nathan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
