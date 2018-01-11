Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753660AbeAKICx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 03:02:53 -0500
Date: Thu, 11 Jan 2018 16:02:42 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v4 0/4] test for XFS umount hang caused by the pending
 dquota log item in AIL
Message-ID: <20180111080242.GI5123@eguan.usersys.redhat.com>
References: <20180111064933.12088-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180111064933.12088-1-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

On Thu, Jan 11, 2018 at 02:49:29PM +0800, Hou Tao wrote:
> Hi,
> 
> This is the v4 patchset for testing the XFS umount hang problem caused by
> the pending dquota log item in AIL. The problem had been fixed by commit
> 373b058 ("xfs: Properly retry failed dquot items in case of error during
> buffer writeback"). The changes for v4 are appended in the commit log
> of each patches.
> 
> Comments and questions are welcome.

The patches all look good, thanks a lot for the revision!

> 
> Regards,
> Tao
> 
> Hou Tao (4):
>   dmflakey: support multiple dm targets for a dm-flakey device
>   dmflakey: support error_writes feature for dm-flakey
>   xfs: test for umount hang caused by the pending dquota log item in AIL
>   common/rc: factor out _scratch_xfs_[get|set]_sb_field

I switched the order of the last two patches, i.e. refactor
_scratch_xfs_[get|set]_sb_field first then use the new helper in the new
test in the end, so we don't add new test then update it again in the
same patch set.

Thanks,
Eryu

> 
>  common/dmflakey   |  31 +++++++++-
>  common/fuzzy      |  33 -----------
>  common/xfs        |  47 +++++++++++++++
>  tests/xfs/007     |   6 +-
>  tests/xfs/098     |   4 +-
>  tests/xfs/186     |   3 +-
>  tests/xfs/199     |  13 ++--
>  tests/xfs/307     |  11 +---
>  tests/xfs/308     |  11 +---
>  tests/xfs/339     |   6 +-
>  tests/xfs/340     |   2 +-
>  tests/xfs/999     | 174 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |   2 +
>  tests/xfs/group   |   1 +
>  14 files changed, 269 insertions(+), 75 deletions(-)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
