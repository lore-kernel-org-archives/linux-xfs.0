Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10718 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751076AbdLMXvR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:51:17 -0500
Date: Thu, 14 Dec 2017 10:44:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 8/8] xfs/068: fix clonerange problems in file/dir
 count output
Message-ID: <20171213234404.GF5858@dastard>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314505158.18893.11894289091110903029.stgit@magnolia>
 <20171213232805.GI6896@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213232805.GI6896@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Dec 13, 2017 at 03:28:05PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In this test we use a fixed sequence of operations in fsstress to create
> some number of files and dirs and then exercise xfsdump/xfsrestore on
> them.  Since clonerange/deduperange are not supported on all xfs
> configurations, detect if they're in fsstress and disable them so that
> we always execute exactly the same sequence of operations no matter how
> the filesystem is configured.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/068 |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tests/xfs/068 b/tests/xfs/068
> index 7151e28..f95a539 100755
> --- a/tests/xfs/068
> +++ b/tests/xfs/068
> @@ -43,6 +43,14 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
>  _supported_fs xfs
>  _supported_os Linux
>  
> +# Remove fsstress commands that aren't supported on all xfs configs
> +if $FSSTRESS_PROG | grep -q clonerange; then
> +	FSSTRESS_AVOID="-f clonerange=0 $FSSTRESS_AVOID"
> +fi
> +if $FSSTRESS_PROG | grep -q deduperange; then
> +	FSSTRESS_AVOID="-f deduperange=0 $FSSTRESS_AVOID"
> +fi
> +

I'd put this inside _create_dumpdir_stress_num as it's supposed to
DTRT for the dump/restore that follows. Otherwise looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
