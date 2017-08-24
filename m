Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751124AbdHXJDh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 05:03:37 -0400
Date: Thu, 24 Aug 2017 17:03:35 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 5/5] xfs: test fuzzing every field of a dquot
Message-ID: <20170824090335.GM31418@eguan.usersys.redhat.com>
References: <150067465981.30639.14801416171688538711.stgit@magnolia>
 <150067469875.30639.1164952553984333812.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150067469875.30639.1164952553984333812.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Jul 21, 2017 at 03:04:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> See what happens when we fuzz every field of a quota information structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

These tests all failed in the same way like:

    +scrub didn't fail with diskdq.magic = zeroes.
    +scrub didn't fail with diskdq.magic = ones.
    +scrub didn't fail with diskdq.magic = firstbit.
    +scrub didn't fail with diskdq.magic = middlebit.
    ...

with 4.13-rc5 kernel and xfsprogs for-next branch. I assume that's
something need to be fixed in the kernel?

...

> diff --git a/tests/xfs/1382 b/tests/xfs/1382
> new file mode 100755
> index 0000000..fd7e50d
> --- /dev/null
> +++ b/tests/xfs/1382
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# FS QA Test No. 1380
                    ^^^^ I changed it to 1382 then renumbered.

Thanks,
Eryu
