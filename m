Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52836 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753847AbeEWDr0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 23:47:26 -0400
Subject: Re: [PATCH v2 01/11] xfs_repair: examine all remote attribute blocks
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401959780.13319.9582448473529615015.stgit@magnolia>
 <20180523031513.GG14384@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <beb30217-1aa7-015c-2774-bb3a23ddf074@oracle.com>
Date: Tue, 22 May 2018 20:47:09 -0700
MIME-Version: 1.0
In-Reply-To: <20180523031513.GG14384@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Alrighty, looks ok.  Thx!

Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 05/22/2018 08:15 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Examine all remote xattr values of a file, not just the XFS_ATTR_ROOT
> values.  This enables us to detect and zap corrupt user xattrs, as
> tested by xfs/404.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   repair/attr_repair.c |    6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 8b1b8a75..67bb41ec 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -537,9 +537,6 @@ process_leaf_attr_remote(
>   		return -1;
>   	}
>   
> -	if (!(entry->flags & XFS_ATTR_ROOT))
> -		goto out;
> -
>   	value = malloc(be32_to_cpu(remotep->valuelen));
>   	if (value == NULL) {
>   		do_warn(
> @@ -555,7 +552,8 @@ process_leaf_attr_remote(
>   			i, ino);
>   		goto bad_free_out;
>   	}
> -	if (valuecheck(mp, (char *)&remotep->name[0], value, remotep->namelen,
> +	if ((entry->flags & XFS_ATTR_ROOT) &&
> +	    valuecheck(mp, (char *)&remotep->name[0], value, remotep->namelen,
>   				be32_to_cpu(remotep->valuelen))) {
>   		do_warn(
>   	_("remote attribute value check failed for entry %d, inode %" PRIu64 "\n"),
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=Vc_K6AveietpcEeQdJ30FwiEHLOuaBg_hGM_aW3IuTM&s=0ZEyUF20gQ7jZ-6j_k9Nsrddrvue9p8Wr6Xo9hwqMZE&e=
> 
