Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38113 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755380AbeE1N4N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 May 2018 09:56:13 -0400
Received: by mail-wr0-f193.google.com with SMTP id 94-v6so20436479wrf.5
        for <linux-xfs@vger.kernel.org>; Mon, 28 May 2018 06:56:12 -0700 (PDT)
Date: Mon, 28 May 2018 15:56:08 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/7] xfs_repair: fix integer handling issues
Message-ID: <20180528135608.lkysdibdrzhewlom@odin.usersys.redhat.com>
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728630312.22515.18006873991572258759.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152728630312.22515.18006873991572258759.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, May 25, 2018 at 03:11:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we shift sb_logblocks to the right we need to ensure that we have
Unless I'm missing something, it should be "to the left"?

Otherwise:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> enough storage space to shift correctly.  Cast logblocks to a 64-bit
> type so that we don't screw up the check.

> 
> Coverity-id: 1435810
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/sb.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/repair/sb.c b/repair/sb.c
> index ef44e39c..543200f7 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -313,7 +313,8 @@ verify_sb_loginfo(
>  	if (xfs_sb_version_hascrc(sb) &&
>  	    (sb->sb_logblocks == 0 ||
>  	     sb->sb_logblocks > XFS_MAX_LOG_BLOCKS ||
> -	     (sb->sb_logblocks << sb->sb_blocklog) > XFS_MAX_LOG_BYTES))
> +	     ((unsigned long long)sb->sb_logblocks << sb->sb_blocklog) >
> +	     XFS_MAX_LOG_BYTES))
>  		return false;
>  
>  	if (sb->sb_logsunit > 1 && sb->sb_logsunit % sb->sb_blocksize)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
