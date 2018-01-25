Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751081AbeAYIR4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jan 2018 03:17:56 -0500
Date: Thu, 25 Jan 2018 16:17:53 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/5] xfs/24[356]: checking cow fork bmap requires
 CONFIG_XFS_DEBUG=y
Message-ID: <20180125081753.GH18267@eguan.usersys.redhat.com>
References: <151683799705.17051.9987269343206294671.stgit@magnolia>
 <151683802170.17051.13989603221322920472.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151683802170.17051.13989603221322920472.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jan 24, 2018 at 03:53:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> These tests requires XFS debugging functionality, so test for that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/243 |    2 ++
>  tests/xfs/245 |    2 ++
>  tests/xfs/246 |    2 ++
>  3 files changed, 6 insertions(+)
> 
> 
> diff --git a/tests/xfs/243 b/tests/xfs/243
> index 0bb69c4..1e6ab5a 100755
> --- a/tests/xfs/243
> +++ b/tests/xfs/243
> @@ -49,10 +49,12 @@ _cleanup()
>  . ./common/rc
>  . ./common/filter
>  . ./common/reflink
> +. ./common/xfs

This file should be included already by common/rc based on $FSTYP, no
need to source it again in test. I'd remove it from all three tests on
commit.

Thanks,
Eryu
