Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48764 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbfGEQXD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 12:23:03 -0400
Subject: Re: [PATCH 4/9] man: link to the SCRUB_METADATA ioctl manpage from
 xfsctl.3
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
 <156104947386.1174403.3374265373047115552.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a5d1227c-146a-105d-c7c6-c8265d4bd290@sandeen.net>
Date: Fri, 5 Jul 2019 11:23:02 -0500
MIME-Version: 1.0
In-Reply-To: <156104947386.1174403.3374265373047115552.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/20/19 11:51 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Link to the scrub ioctl documentation from xfsctl.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man3/xfsctl.3 |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> 
> diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> index 94a6ad4b..78fad975 100644
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
> @@ -436,6 +442,7 @@ as they are not of general use to applications.
>  .BR ioctl_xfs_fsgetxattr (2),
>  .BR ioctl_xfs_fsop_geometry (2),
>  .BR ioctl_xfs_fsbulkstat (2),
> +.BR ioctl_xfs_scrub_metadata (2),
>  .BR fstatfs (2),
>  .BR statfs (2),
>  .BR xfs (5),
> 
