Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41898 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfFQQTj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jun 2019 12:19:39 -0400
Subject: Re: [PATCH 4/9] libxfs: link to the scrub ioctl from xfsctl.3
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993576618.2343530.17591105410246159765.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <52da2929-8ab7-7109-b16f-208fc676220d@sandeen.net>
Date: Mon, 17 Jun 2019 11:19:37 -0500
MIME-Version: 1.0
In-Reply-To: <155993576618.2343530.17591105410246159765.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/7/19 2:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Link to the scrub ioctl documentation from xfsctl.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Seems like every reference to another man page should also be
explicitly in the SEE ALSO section, no?

(there must be a man page best practices manual somewhere, to be
sure i'm not just making stuff up?)

> ---
>  man/man3/xfsctl.3 |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> index 94a6ad4b..cdf0fcfc 100644
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -411,6 +411,12 @@ See
>  .BR ioctl_xfs_fsbulkstat (2)
>  for more information.
>  
> +.TP
> +.B XFS_IOC_SCRUB_METADATA
> +See
> +.BR ioctl_xfs_scrub_metadata (2)
> +for more information.
> +
>  .PP
>  .nf
>  .B XFS_IOC_THAW
> 
