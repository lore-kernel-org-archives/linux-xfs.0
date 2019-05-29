Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39086 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfE2DAN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 23:00:13 -0400
Date: Tue, 28 May 2019 20:00:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 0/5] fstests: copy_file_range() tests
Message-ID: <20190529030001.GC5244@magnolia>
References: <20190526084535.999-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190526084535.999-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, May 26, 2019 at 11:45:30AM +0300, Amir Goldstein wrote:
> Eryu,
> 
> This is a re-work of Dave Chinner's copy_file_range() tests which
> I used to verify the kernel fixes of the syscall [1].
> 
> I split out the single bounds test by Dave to 4 tests.
> immutable and swap file copy have specific requiremenet which many
> filesystems do not meet (e.g. cifs,nfs,ceph,overlayfs), so those
> test cases were split to individual test to allow better bounds test
> converage for all filesystems.
> 
> The 3 first tests fix bugs in the interface, so they are appropriate
> for merge IMO. The last test (cross-device copy) tests a new
> functionality, so you may want to wait with merge till after the work
> is merged upstream.

The tests mostly look ok to me...

> NOTE that the bounds check test depend on changes that have been merged
> to xfsprogs v4.20. Without those changes the test will hang!

Is that the requirement for opening pipes in nonblocking mode?

If so... that ought to be a separate test (or at least a separate part
of the test) that can be skipped if we detect an old xfs_io.

> I used an artificial requirement _require_xfs_io_command "chmod" to
> skip the test with old xfs_io. I welcome suggestions for better way to
> handle this issue.

Grepping manpages? :D

--D

> 
> Thanks,
> Amir.
> 
> Changes from v1:
> - Remove patch to test EINVAL behavior instead of short copy
> - Remove 'chmod -r' permission drop test case
> - Split out test for swap/immutable file copy
> - Split of cross-device copy test
> 
> [1] https://lore.kernel.org/linux-fsdevel/20190526061100.21761-1-amir73il@gmail.com/
> 
> Amir Goldstein (5):
>   generic: create copy_range group
>   generic: copy_file_range immutable file test
>   generic: copy_file_range swapfile test
>   generic: copy_file_range bounds test
>   generic: cross-device copy_file_range test
> 
>  tests/generic/434     |   2 +
>  tests/generic/988     |  59 ++++++++++++++++++++
>  tests/generic/988.out |   5 ++
>  tests/generic/989     |  56 +++++++++++++++++++
>  tests/generic/989.out |   4 ++
>  tests/generic/990     | 123 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/990.out |  37 +++++++++++++
>  tests/generic/991     |  56 +++++++++++++++++++
>  tests/generic/991.out |   4 ++
>  tests/generic/group   |  14 +++--
>  10 files changed, 355 insertions(+), 5 deletions(-)
>  create mode 100755 tests/generic/988
>  create mode 100644 tests/generic/988.out
>  create mode 100755 tests/generic/989
>  create mode 100644 tests/generic/989.out
>  create mode 100755 tests/generic/990
>  create mode 100644 tests/generic/990.out
>  create mode 100755 tests/generic/991
>  create mode 100644 tests/generic/991.out
> 
> -- 
> 2.17.1
> 
