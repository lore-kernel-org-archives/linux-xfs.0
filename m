Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753312AbcKEFW6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 5 Nov 2016 01:22:58 -0400
Date: Sat, 5 Nov 2016 13:22:56 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 39/39] xfs_scrub: create online filesystem scrub program
Message-ID: <20161105052256.GB27776@eguan.usersys.redhat.com>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
 <147830572454.4165.18074642184555452652.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830572454.4165.18074642184555452652.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:28:44PM -0700, Darrick J. Wong wrote:
> Create a filesystem scrubbing tool that walks the directory tree,
> queries every file's extents, extended attributes, and stat data.  For
> generic (non-XFS) filesystems this depends on the kernel to do nearly
> all the validation.  Optionally, we can (try to) read all the file
> data.
> 
> For XFS, we perform sequential scans of each AG's metadata, inodes,
> extent maps, and file data.  Being XFS specific, we can work with
> the in-kernel scrubbers to perform much stronger
> metadata checking and cross-referencing.  We can also take advantage
> of newer ioctls such as GETFSMAP to perform faster read verification.
> 
> In the future we will be able to take advantage of (still unwritten)
> features such as parent directory pointers to fully validate all
> metadata.  However, this tool /should/ work for most non-XFS
> filesystems such as ext4 and btrfs.
> 
> Note also that the scrub tool can shut down the filesystem if errors
> are found.  This is not a default option since scrubbing is very
> immature at this time.  It can also ask the XFS driver in the kernel
> to optimize or repair metadata, though this may not be successful.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
[snip]
> --- /dev/null
> +++ b/scrub/scrub.c
> @@ -0,0 +1,1009 @@
> +/*
> + * Copyright (C) 2016 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#include "libxfs.h"
> +#include <stdio.h>
> +#include <mntent.h>
> +#include <unistd.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/time.h>
> +#include <sys/resource.h>
> +#include <sys/statvfs.h>
> +#include <sys/vfs.h>
> +#include <fcntl.h>
> +#include <dirent.h>
> +#include "disk.h"
> +#include "scrub.h"
> +#include "../../repair/threads.h"

I have trouble compiling the djwong-devel branch, it failed to find
"../../repair/threads.h", seems it should be "../repair/threads.h" here.

Thanks,
Eryu
