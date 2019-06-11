Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59788 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390856AbfFKDTH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 23:19:07 -0400
Date: Mon, 10 Jun 2019 20:18:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] generic/553: fix test description
Message-ID: <20190611031858.GG1688126@magnolia>
References: <20190610194545.8146-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610194545.8146-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 10:45:45PM +0300, Amir Goldstein wrote:
> The test only checks copy to immutable file
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  tests/generic/553 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/553 b/tests/generic/553
> index efe25d84..117c0ad5 100755
> --- a/tests/generic/553
> +++ b/tests/generic/553
> @@ -4,7 +4,7 @@
>  #
>  # FS QA Test No. 553
>  #
> -# Check that we cannot copy_file_range() to/from an immutable file
> +# Check that we cannot copy_file_range() to an immutable file
>  #
>  seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
> -- 
> 2.17.1
> 
