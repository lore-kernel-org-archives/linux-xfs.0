Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933219AbeF1VMJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 17:12:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5SLC91H182826
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:12:09 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2jum0abync-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:12:09 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5SLC5aD025199
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:12:05 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5SLC5CG021944
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:12:05 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 02/21] xfs: add helper to decide if an inode has allocated
 cow blocks
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986822251.3155.14348466047540978889.stgit@magnolia>
Message-ID: <fa81b552-6c3b-165b-2eac-5898e6366782@oracle.com>
Date: Thu, 28 Jun 2018 14:12:03 -0700
MIME-Version: 1.0
In-Reply-To: <152986822251.3155.14348466047540978889.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 06/24/2018 12:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a helper to decide if an inode has real or unwritten extents in the
> CoW fork.  The upcoming repair freeze functionality will have to know if
> it's safe to iput an inode -- if the inode has incore any state that
> would require a transaction to unwind during iput, we'll have to defer
> the iput.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_inode.c |   19 +++++++++++++++++++
>   fs/xfs/xfs_inode.h |    1 +
>   2 files changed, 20 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7a96c4e0ab5c..e6859dfc29af 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3689,3 +3689,22 @@ xfs_iflush_int(
>   corrupt_out:
>   	return -EFSCORRUPTED;
>   }
> +
> +/* Decide if there are real or unwritten extents in the CoW fork. */
> +bool
> +xfs_inode_has_cow_blocks(
> +	struct xfs_inode		*ip)
> +{
> +	struct xfs_iext_cursor		icur;
> +	struct xfs_bmbt_irec		irec;
> +	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> +
> +	if (!ifp)
> +		return false;
> +
> +	for_each_xfs_iext(ifp, &icur, &irec) {
> +		if (!isnullstartblock(irec.br_startblock))
> +			return true;
> +	}
> +	return false;
> +}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 2ed63a49e890..735d0788bfdb 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -503,5 +503,6 @@ extern struct kmem_zone	*xfs_inode_zone;
>   #define XFS_DEFAULT_COWEXTSZ_HINT 32
>   
>   bool xfs_inode_verify_forks(struct xfs_inode *ip);
> +bool xfs_inode_has_cow_blocks(struct xfs_inode *ip);
>   
>   #endif	/* __XFS_INODE_H__ */
> 

Ok, this one looks pretty straight forward.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=gITPMUadlG9a62qcCKtadzb41y_zIzqRNXMCANKITeM&s=hmiK2_87KL5oO6gl-LQ00avYqc5HcijzCgyErYAM1Cc&e=
> 
