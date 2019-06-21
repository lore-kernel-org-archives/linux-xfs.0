Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41972 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfFUJUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 05:20:02 -0400
Date: Fri, 21 Jun 2019 17:19:55 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 4/4] xfs/119: fix MKFS_OPTIONS exporting
Message-ID: <20190621091955.GJ15846@desktop>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
 <156089204777.345809.18314859473454869520.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156089204777.345809.18314859473454869520.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jun 18, 2019 at 02:07:27PM -0700, Darrick J. Wong wrote:
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

I'll apply this one along with patch 2/4, once that one is updated.

Thanks,
Eryu

> ---
>  tests/xfs/119 |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/119 b/tests/xfs/119
> index 8825a5c3..f245a0a6 100755
> --- a/tests/xfs/119
> +++ b/tests/xfs/119
> @@ -38,7 +38,8 @@ _require_scratch
>  # this may hang
>  sync
>  
> -logblks=$(_scratch_find_xfs_min_logblocks -l version=2,su=64k)
> +export MKFS_OPTIONS="-l version=2,su=64k"
> +logblks=$(_scratch_find_xfs_min_logblocks)
>  export MKFS_OPTIONS="-l version=2,size=${logblks}b,su=64k"
>  export MOUNT_OPTIONS="-o logbsize=64k"
>  _scratch_mkfs_xfs >/dev/null
> 
