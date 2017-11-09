Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753490AbdKIIyL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 03:54:11 -0500
Date: Thu, 9 Nov 2017 16:54:06 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 0/4] test for XFS umount hang caused by the pending
 dquota log item in AIL
Message-ID: <20171109085406.GU17339@eguan.usersys.redhat.com>
References: <20171109073252.36001-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171109073252.36001-1-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

On Thu, Nov 09, 2017 at 03:32:48PM +0800, Hou Tao wrote:
> Hi,
> 
> This is the v3 patchset for testing the XFS umount hang problem caused by
> the pending dquota log item in AIL. The problem has not been fixed in
> XFS yet, and Carlos Maiolino is working on it [1].
> 
> The bug that the test case can not reproduced on a 15GB scratch device
> has been fixed, and many thanks to Eryu Guan. I had tested it on 4.14-rc8,
> and the problem can be reproduced reliably now.
> 
> Comments and questions are welcome.

I finally could reproduce the hang, thanks a lot!

But I won't merge the test until the fix is upstream, otherwise it would
interrupt all test runs on XFS.

And I have some nitpicks on individual patches :)

Thanks,
Eryu

> 
> Regards,
> Tao
> 
> ---
> Changes since v2:
> 
> v3:
> * dmflakey: support error_writes feature for dm-flakey
> 	* check the availability of error_writes by trial instead of version number
> 
> * xfs: test for umount hang caused by the pending dquota log item in AIL
> 	* calculate log_ofs correctly by using convert cmd in xfs_db
> 
> * common/rc: factor out _scratch_xfs_[get|set]_sb_field
> 	* reimplement _scratch_xfs_[get|set]_sb_field based on
> 	  _scratch_xfs_[get|set]_metadata_field.
> 
> v2:
> 	* http://www.spinics.net/lists/fstests/msg07792.html
> 
> v1:
> 	* https://www.spinics.net/lists/fstests/msg07622.html
> 
> [1]: https://www.spinics.net/lists/linux-xfs/msg11614.html
> 
> Hou Tao (4):
>   dmflakey: support multiple dm targets for a dm-flakey device
>   dmflakey: support error_writes feature for dm-flakey
>   xfs: test for umount hang caused by the pending dquota log item in AIL
>   common/rc: factor out _scratch_xfs_[get|set]_sb_field
> 
>  common/dmflakey   |  29 +++++++++-
>  common/fuzzy      |  33 -----------
>  common/xfs        |  47 ++++++++++++++++
>  tests/xfs/007     |   6 +-
>  tests/xfs/098     |   4 +-
>  tests/xfs/186     |   3 +-
>  tests/xfs/199     |  13 ++---
>  tests/xfs/307     |  11 +---
>  tests/xfs/308     |  11 +---
>  tests/xfs/339     |   6 +-
>  tests/xfs/340     |   2 +-
>  tests/xfs/999     | 163 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |   2 +
>  tests/xfs/group   |   1 +
>  14 files changed, 257 insertions(+), 74 deletions(-)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
