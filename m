Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55260 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753787AbeEWD7C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 23:59:02 -0400
Subject: Re: [PATCH v2 5/9] xfs_spaceman: print a nicer message when the file
 path isn't on an xfs
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401956294.13048.1815463748899965760.stgit@magnolia>
 <20180523033117.GJ14384@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <cabdf0a3-b3db-8c13-3724-a048b8936664@oracle.com>
Date: Tue, 22 May 2018 20:58:46 -0700
MIME-Version: 1.0
In-Reply-To: <20180523033117.GJ14384@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Ok, looks good.  Thx!

Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 05/22/2018 08:31 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the file path passed in is not something on an xfs filesystem, print
> a nice message about that instead of yelling about ioctls.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   spaceman/file.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/spaceman/file.c b/spaceman/file.c
> index 4c13b4a8..23f8be1c 100644
> --- a/spaceman/file.c
> +++ b/spaceman/file.c
> @@ -69,7 +69,12 @@ openfile(
>   	}
>   
>   	if (ioctl(fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
> -		perror("XFS_IOC_FSGEOMETRY");
> +		if (errno == ENOTTY)
> +			fprintf(stderr,
> +_("%s: Not on a mounted XFS filesystem.\n"),
> +					path);
> +		else
> +			perror("XFS_IOC_FSGEOMETRY");
>   		close(fd);
>   		return -1;
>   	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=c2CCB3K_iIfSsLpTfhw0rxFL87ZYlPnPvGWzEfJ_t2E&s=KTX7FsHojy6HKAINeB5zGTNlqQlJ037Cw09OFK9tBhY&e=
> 
