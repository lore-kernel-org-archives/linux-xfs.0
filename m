Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751199AbdJ3FAK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Oct 2017 01:00:10 -0400
Date: Mon, 30 Oct 2017 13:00:08 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 10/6] common/xfs: remove inode-paths cruft
Message-ID: <20171030050007.GC17339@eguan.usersys.redhat.com>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
 <20171027202550.GL5486@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027202550.GL5486@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Oct 27, 2017 at 01:25:50PM -0700, Darrick J. Wong wrote:
> Remove the inode-paths check from _check_xfs_test_fs because we don't
> support inode paths, xfsprogs doesn't have a xfs_{check,repair}_ipaths
> tool, and it's broken anyway because we ignore _check_xfs_filesystem
> (which tells whether or not the filesystem is even still mounted).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/xfs |    7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 5643adf..79efb78 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -471,13 +471,6 @@ _check_xfs_test_fs()
>  		TEST_RT="$TEST_RTDEV"
>  
>  	_check_xfs_filesystem $TEST_DEV $TEST_LOG $TEST_RT
> -
> -	# check for ipath consistency
> -	if $XFS_GROWFS_PROG -n $TEST_DIR | grep -q 'inode-paths=1'; then
> -		# errors go to stderr
> -		xfs_check_ipaths $TEST_DIR >/dev/null
> -		xfs_repair_ipaths -n $TEST_DIR >/dev/null
> -	fi

I added a "return $?" here to report _check_xfs_filesystem result to the
caller, otherwise test was reported as a PASS even _check_xfs_filesystem
found something and printed out the error messages.

Thanks,
Eryu

>  }
>  
>  _require_xfs_test_rmapbt()
