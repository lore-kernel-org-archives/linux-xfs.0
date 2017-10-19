Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38595 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753733AbdJSSNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 14:13:06 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9JID570014110
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2017 18:13:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9JID5X1006085
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2017 18:13:05 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9JID54v004440
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2017 18:13:05 GMT
Date: Thu, 19 Oct 2017 11:13:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/17] Add the extra space requirements for parent
 pointer attributes when calculating the minimum log size during mkfs
Message-ID: <20171019181303.GA4755@magnolia>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <1508367333-3237-12-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508367333-3237-12-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 18, 2017 at 03:55:27PM -0700, Allison Henderson wrote:
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_log_rlimit.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index c105979..beec9bf 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -39,6 +39,40 @@ xfs_log_calc_max_attrsetm_res(
>  {
>  	int			size;
>  	int			nblks;
> +	struct xfs_trans_resv   *resp = M_RES(mp);
> +
> +	/* Calculate extra space needed for parent pointer attributes */
> +	if (!xfs_sb_version_hasparent(&mp->m_sb)) {

Aren't we supposed to be enlarging tr_log{res,count} if hasparent is true?

> +
> +		/* rename can add/remove/modify 2 parent attributes */
> +		resp->tr_rename.tr_logres +=
> +			2 * max(resp->tr_attrsetm.tr_logres,
> +				resp->tr_attrrm.tr_logres);
> +		resp->tr_rename.tr_logcount +=
> +			2 * max(resp->tr_attrsetm.tr_logcount,
> +				resp->tr_attrrm.tr_logcount);
> +
> +		/* create will add 1 parent attribute */
> +		resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
> +		resp->tr_create.tr_logcount += resp->tr_attrsetm.tr_logcount;
> +
> +		/* mkdir will add 1 parent attribute */
> +		resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
> +		resp->tr_mkdir.tr_logcount += resp->tr_attrsetm.tr_logcount;
> +
> +		/* link will add 1 parent attribute */
> +		resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
> +		resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
> +
> +		/* symlink will add 1 parent attribute */
> +		resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
> +		resp->tr_symlink.tr_logcount += resp->tr_attrsetm.tr_logcount;
> +
> +		/* remove will remove 1 parent attribute */
> +		resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
> +		resp->tr_remove.tr_logcount = resp->tr_attrrm.tr_logcount;

+= ?

--D

> +	}
> +
>  
>  	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
>  	       MAXNAMELEN - 1;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
