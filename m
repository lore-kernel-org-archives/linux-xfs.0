Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30155 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752601AbdF2Q1L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 12:27:11 -0400
Date: Thu, 29 Jun 2017 09:27:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_spaceman: close open file for error case in
 openfile()
Message-ID: <20170629162704.GD5874@birch.djwong.org>
References: <20170629162530.6023-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629162530.6023-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Thu, Jun 29, 2017 at 11:25:30AM -0500, Bill O'Donnell wrote:
> openfile() fails to close the open file in one error case.
> Add close(fd) to correct the condition.
> 
> Detected by CoverityScan, CID#1413770 (RESOURCE_LEAK)
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  spaceman/file.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/spaceman/file.c b/spaceman/file.c
> index 4ab30900..4c13b4a8 100644
> --- a/spaceman/file.c
> +++ b/spaceman/file.c
> @@ -79,6 +79,7 @@ openfile(
>  		if (!fsp) {
>  			fprintf(stderr, _("%s: cannot find mount point."),
>  				path);
> +			close(fd);
>  			return -1;
>  		}
>  		memcpy(fs_path, fsp, sizeof(struct fs_path));
> -- 
> 2.13.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
