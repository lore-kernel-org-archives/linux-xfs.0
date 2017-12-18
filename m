Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752841AbdLROrf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Dec 2017 09:47:35 -0500
Date: Mon, 18 Dec 2017 08:47:32 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] tests/xfs/040: document purpose
Message-ID: <20171218144732.GA11237@redhat.com>
References: <20171215204118.17740-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171215204118.17740-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Dec 15, 2017 at 12:41:18PM -0800, Luis R. Rodriguez wrote:
> Getting xfs/040 to "pass" takes a bit of effort, however the effort
> to require updating xfsprogs is purely an xfsprogs maintainer task
> only. There no functional gain by users of xfs or a QA team to get
> this test to pass. This is not trivial from the current description
> so document this.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

Looks good...

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  tests/xfs/040 | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tests/xfs/040 b/tests/xfs/040
> index fadb888cbfaf..a0abc42f3720 100755
> --- a/tests/xfs/040
> +++ b/tests/xfs/040
> @@ -3,6 +3,11 @@
>  #
>  # compare-libxfs test
>  #
> +# The purpose of this test is only to nag the maintainer of xfsprogs to try to
> +# keep xfsprogs's libxfs files in sync with the latest kernel's libxfs. There
> +# is no functional need for anyone to actually run this test to confirm
> +# proper XFS functionalilty, this is an xfsprogs maintainer test.
> +#
>  #-----------------------------------------------------------------------
>  # Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
>  #
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
