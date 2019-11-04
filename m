Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7726ACA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E592067D
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:56:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kka/Og11"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfKDU4I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:56:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41528 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbfKDU4I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:56:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4Kstgh152998;
        Mon, 4 Nov 2019 20:55:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8hjmMf64sSvFbPYKUumMOWPzHsqWm765EQCdteJswvM=;
 b=Kka/Og11S7bJS6Z6ypiOBLzjiLAE6oYcthF16+TdRQ6xdqxxcUck7HmEBvoQv/gk7PEJ
 FepxuMskpJDIVaCV/ryAvgv4ntdMR6AhlexV4YmAhoRYTFfdEeAERFW2dtLrpfwqT3j4
 v3whX77KvVmyAB7hgQn8Vm7gqIbjzf9o//bvUXVHuZz8/cVqedoqTKd30I2Mt5hNrJGu
 +becxLloPFH/IkLVR/QjSYaQb3+OKdLxx8wqebXsIzv1veNXUblQ58vmqGWKCfBf0kxh
 Xr1hiZ/ci1sPhYWF8+sLgpZYTAM7KwLABWR7EG0u96jzOvnnBRHCDZ8A/4ef7fXKTuoU AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w117tt310-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:55:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KmQHM189682;
        Mon, 4 Nov 2019 20:55:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w1kxdy1vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:55:38 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4KtaMn016796;
        Mon, 4 Nov 2019 20:55:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:55:36 -0800
Date:   Mon, 4 Nov 2019 12:55:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v9 17/17] xfs: fold xfs_mount-alloc() into
 xfs_init_fs_context()
Message-ID: <20191104205535.GK4153244@magnolia>
References: <157286480109.18393.6285224459642752559.stgit@fedora-28>
 <157286496581.18393.3802665855647124772.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157286496581.18393.3802665855647124772.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040201
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040202
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 06:56:05PM +0800, Ian Kent wrote:
> After switching to use the mount-api the only remaining caller of
> xfs_mount_alloc() is xfs_init_fs_context(), so fold xfs_mount_alloc()
> into it.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |   49 +++++++++++++++++++------------------------------
>  1 file changed, 19 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e156fd59d592..c14f285f3256 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1096,35 +1096,6 @@ static const struct super_operations xfs_super_operations = {
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  };
>  
> -static struct xfs_mount *
> -xfs_mount_alloc(void)
> -{
> -	struct xfs_mount	*mp;
> -
> -	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
> -	if (!mp)
> -		return NULL;
> -
> -	spin_lock_init(&mp->m_sb_lock);
> -	spin_lock_init(&mp->m_agirotor_lock);
> -	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
> -	spin_lock_init(&mp->m_perag_lock);
> -	mutex_init(&mp->m_growlock);
> -	atomic_set(&mp->m_active_trans, 0);
> -	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
> -	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
> -	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
> -	mp->m_kobj.kobject.kset = xfs_kset;
> -	/*
> -	 * We don't create the finobt per-ag space reservation until after log
> -	 * recovery, so we must set this to true so that an ifree transaction
> -	 * started during log recovery will not depend on space reservations
> -	 * for finobt expansion.
> -	 */
> -	mp->m_finobt_nores = true;
> -	return mp;
> -}
> -
>  static int
>  suffix_kstrtoint(
>  	const char	*s,
> @@ -1763,10 +1734,28 @@ static int xfs_init_fs_context(
>  {
>  	struct xfs_mount	*mp;
>  
> -	mp = xfs_mount_alloc();
> +	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
>  	if (!mp)
>  		return -ENOMEM;
>  
> +	spin_lock_init(&mp->m_sb_lock);
> +	spin_lock_init(&mp->m_agirotor_lock);
> +	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
> +	spin_lock_init(&mp->m_perag_lock);
> +	mutex_init(&mp->m_growlock);
> +	atomic_set(&mp->m_active_trans, 0);
> +	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
> +	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
> +	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
> +	mp->m_kobj.kobject.kset = xfs_kset;
> +	/*
> +	 * We don't create the finobt per-ag space reservation until after log
> +	 * recovery, so we must set this to true so that an ifree transaction
> +	 * started during log recovery will not depend on space reservations
> +	 * for finobt expansion.
> +	 */
> +	mp->m_finobt_nores = true;
> +
>  	/*
>  	 * These can be overridden by the mount option parsing.
>  	 */
> 
