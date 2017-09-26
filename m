Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934183AbdIZKuT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Sep 2017 06:50:19 -0400
Date: Tue, 26 Sep 2017 18:50:16 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 2/3] xfs/realtime: Default rtinherit=1, add
 _require_no_rtinherit function
Message-ID: <20170926105016.GK8034@eguan.usersys.redhat.com>
References: <20170925195625.756877-1-rwareing@fb.com>
 <20170925195625.756877-2-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170925195625.756877-2-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Mon, Sep 25, 2017 at 12:56:24PM -0700, Richard Wareing wrote:
> To better exercise the data path code of realtime subvolumes, we will
> set rtinherit=1 during mkfs calls.  For tests which this is not desired
> we introduce a _require_no_rtinherit function to opt out of this
> behavior.
> 
> Signed-off-by: Richard Wareing <rwareing@fb.com>
> ---
> Changes since v1:
> * None
> 
>  common/rc         | 24 +++++++++++++++++++++++-
>  tests/generic/250 |  1 +
>  tests/generic/252 |  1 +
>  tests/generic/427 |  1 +
>  tests/generic/441 |  1 +
>  tests/xfs/019     |  1 +
>  tests/xfs/031     |  1 +
>  tests/xfs/170     |  1 +
>  tests/xfs/187     |  1 +
>  9 files changed, 31 insertions(+), 1 deletion(-)

I don't think we need an extra RT_INHERT flag, this is just one of the
normal test configurations and can be easily tested by setting correct
MKFS_OPTIONS, e.g.

MKFS_OPTIONS="-d rtinherit=1" ./check ...

Then we can check if MKFS_OPTIONS has rtinherit defined in
_require_no_rtinherit(), e.g.

_require_no_rtinherit()
{
	echo "$MKFS_OPTIONS" | egrep -q "rtinherit([^=]|=1)" && \
		_notrun "<notrun message here>"
}

Unfortunately, mkfs.xfs doesn't print rtinherit status at mkfs time,
otherwise we could check mkfs.xfs output directly.

And xfs/019 xfs/031 passed even with "-d rtinherit=1", and xfs/187
already _notrun with proper message, so seems they don't need
_require_no_rtinherit rule.

generic/427 fails because xfs_io prints out its write log, after
redirecting stdout of xfs_io to /dev/null, generic/427 passed for me
too, the xfs_io write is meant to write a special pattern to the disk
anyway.

For other tests that do need _require_no_rtinherit, a comment to explain
why this rule is needed would be good.

Thanks,
Eryu
