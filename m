Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33010 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbeHLKad (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Aug 2018 06:30:33 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7C7npTk051236
        for <linux-xfs@vger.kernel.org>; Sun, 12 Aug 2018 07:53:24 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2ksnacsk7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 12 Aug 2018 07:53:24 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7C7rO2q012740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 12 Aug 2018 07:53:24 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7C7rNcd031609
        for <linux-xfs@vger.kernel.org>; Sun, 12 Aug 2018 07:53:23 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 1/6] xfs: recalculate summary counters at mount time if
 icount is bad
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
 <153400170370.27471.3984686896617555055.stgit@magnolia>
Message-ID: <bcc59ede-916b-fb03-d5bc-f059f332cba5@oracle.com>
Date: Sun, 12 Aug 2018 00:53:22 -0700
MIME-Version: 1.0
In-Reply-To: <153400170370.27471.3984686896617555055.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 08/11/2018 08:35 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since the sb write verifier trips on bad icounts, we should also force a
> mount time recalculation of the summary counters if the icount is bad.
> This helps us avoid blowing up at freeze/unmount time when the bad
> counter gets written back out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_mount.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 99db27d6ac8a..02d15098dbee 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -637,6 +637,7 @@ xfs_check_summary_counts(
>   	 */
>   	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
>   	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
> +	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
>   	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
>   		mp->m_flags |= XFS_MOUNT_BAD_SUMMARY;
>   
> 
Ok, looks good

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
