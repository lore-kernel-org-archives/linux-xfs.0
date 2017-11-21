Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:40119 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbdKUPtN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Nov 2017 10:49:13 -0500
Received: by mail-wm0-f50.google.com with SMTP id b189so4323473wmd.5
        for <linux-xfs@vger.kernel.org>; Tue, 21 Nov 2017 07:49:12 -0800 (PST)
Date: Tue, 21 Nov 2017 16:49:09 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v3 0/4] test for XFS umount hang caused by the pending
 dquota log item in AIL
Message-ID: <20171121154909.2acusmt3nfdonttw@odin.localdomain>
References: <20171109073252.36001-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171109073252.36001-1-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

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
> 

Thanks, I'm testing my patch against this test, it might take a few more time to
properly work on that patch, but with the test it is better.

I didn't review the test yet, but I tried it once, and at least the result is
what I expected, I'll get some time to review it.

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

-- 
Carlos
