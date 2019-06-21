Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfFUQ2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 12:28:50 -0400
Subject: Re: [PATCH 4/4] xfs/119: fix MKFS_OPTIONS exporting
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
 <156089204777.345809.18314859473454869520.stgit@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <f39344a5-c0ee-f660-ac9d-c431ce3c4b0f@oracle.com>
Date: Fri, 21 Jun 2019 09:28:45 -0700
MIME-Version: 1.0
In-Reply-To: <156089204777.345809.18314859473454869520.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On 6/18/19 2:07 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This test originally exported its own MKFS_OPTIONS to force the tested
> filesystem config to the mkfs defaults + test-specific log size options.
> This overrides whatever the test runner might have set in MKFS_OPTIONS.
> 
> In commit 2fd273886b525 ("xfs: refactor minimum log size formatting
> code") we fail to export our test-specific MKFS_OPTIONS before
> calculating the minimum log size, which leads to the wrong min log size
> being calculated once we fixed the helper to be smarter about mkfs options.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks ok to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   tests/xfs/119 |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/119 b/tests/xfs/119
> index 8825a5c3..f245a0a6 100755
> --- a/tests/xfs/119
> +++ b/tests/xfs/119
> @@ -38,7 +38,8 @@ _require_scratch
>   # this may hang
>   sync
>   
> -logblks=$(_scratch_find_xfs_min_logblocks -l version=2,su=64k)
> +export MKFS_OPTIONS="-l version=2,su=64k"
> +logblks=$(_scratch_find_xfs_min_logblocks)
>   export MKFS_OPTIONS="-l version=2,size=${logblks}b,su=64k"
>   export MOUNT_OPTIONS="-o logbsize=64k"
>   _scratch_mkfs_xfs >/dev/null
> 
