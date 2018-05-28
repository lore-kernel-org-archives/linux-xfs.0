Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53936 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbeE1DwX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 May 2018 23:52:23 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 1/7] xfs_repair: fix integer handling issues
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728630312.22515.18006873991572258759.stgit@magnolia>
Message-ID: <ff9edd9a-e8a9-72f1-d616-3794365cfc8e@oracle.com>
Date: Sun, 27 May 2018 20:52:05 -0700
MIME-Version: 1.0
In-Reply-To: <152728630312.22515.18006873991572258759.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Looks ok to me.
Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 05/25/2018 03:11 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we shift sb_logblocks to the right we need to ensure that we have
> enough storage space to shift correctly.  Cast logblocks to a 64-bit
> type so that we don't screw up the check.
> 
> Coverity-id: 1435810
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   repair/sb.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/repair/sb.c b/repair/sb.c
> index ef44e39c..543200f7 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -313,7 +313,8 @@ verify_sb_loginfo(
>   	if (xfs_sb_version_hascrc(sb) &&
>   	    (sb->sb_logblocks == 0 ||
>   	     sb->sb_logblocks > XFS_MAX_LOG_BLOCKS ||
> -	     (sb->sb_logblocks << sb->sb_blocklog) > XFS_MAX_LOG_BYTES))
> +	     ((unsigned long long)sb->sb_logblocks << sb->sb_blocklog) >
> +	     XFS_MAX_LOG_BYTES))
>   		return false;
>   
>   	if (sb->sb_logsunit > 1 && sb->sb_logsunit % sb->sb_blocksize)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=VfFiG-M8c2_2RI75jbfn7wWPm8FSu5Sdve4CVE9qM28&s=KCxhdbGZuRnZDLgbz2McNDDVl_f6-6DFW-Qj_vqgDKk&e=
> 
