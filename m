Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1600BCA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBC262064A
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:28:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EujtrDln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503162AbfJXP25 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:28:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503043AbfJXP25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 11:28:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OFCFPb024261;
        Thu, 24 Oct 2019 15:28:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5911OJAosLQHcu/MVvmyIHNjqGKju5JZDHZhaouOVi8=;
 b=EujtrDlniXR33Fo43yhwoqsbaY01z0Lg1eC8CSvN+nPPEVF9IKF5E6PwLOiLFS4xyxJ1
 ol7zJ+SGmHwfsCEjZIC7N5G8NuFQ6is9KV3oOwZFomCZlxz2yuiJEYPImPDsGAByq/bY
 yr+T2r7qLsUhWlYsOnreL9KekSLdfmfZzHdyMNPsXs4UDC9lsEVTKKfhMtJ9ThrvKGjg
 S4R7GsXgkrz32IqUuoDNHZP/JGoP/ljnpIIEDMnKns5N2IV/6axIcGS/LFhwvCSbjOPs
 s/zYath6R7JTiz29TTAUbcGg4pcpdI5cejxECTqAh66RC2CXlD5OI2socvOuQENzv9K0 QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vqteq4dr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:28:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OF4gLU156989;
        Thu, 24 Oct 2019 15:28:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vu0fpgp86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:28:38 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9OFSaNB014706;
        Thu, 24 Oct 2019 15:28:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 08:28:35 -0700
Date:   Thu, 24 Oct 2019 08:28:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 08/17] xfs: merge freeing of mp names and mp
Message-ID: <20191024152834.GR913374@magnolia>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190347727.27074.15948763811572596699.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190347727.27074.15948763811572596699.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=951
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:17PM +0800, Ian Kent wrote:
> In all cases when struct xfs_mount (mp) fields m_rtname and m_logname
> are freed mp is also freed, so merge these into a single function
> xfs_mount_free().
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |   26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 0596d491dbbe..297e6c98742e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -446,6 +446,15 @@ xfs_mount_alloc(
>  	return mp;
>  }
>  
> +static void
> +xfs_mount_free(
> +	struct xfs_mount	*mp)
> +{
> +	kfree(mp->m_rtname);
> +	kfree(mp->m_logname);
> +	kmem_free(mp);
> +}
> +
>  struct proc_xfs_info {
>  	uint64_t	flag;
>  	char		*str;
> @@ -1058,14 +1067,6 @@ xfs_fs_drop_inode(
>  	return generic_drop_inode(inode) || (ip->i_flags & XFS_IDONTCACHE);
>  }
>  
> -STATIC void
> -xfs_free_names(
> -	struct xfs_mount	*mp)
> -{
> -	kfree(mp->m_rtname);
> -	kfree(mp->m_logname);
> -}
> -
>  STATIC int
>  xfs_fs_sync_fs(
>  	struct super_block	*sb,
> @@ -1238,8 +1239,7 @@ xfs_test_remount_options(
>  
>  	tmp_mp->m_super = sb;
>  	error = xfs_parseargs(tmp_mp, options);
> -	xfs_free_names(tmp_mp);
> -	kmem_free(tmp_mp);
> +	xfs_mount_free(tmp_mp);
>  
>  	return error;
>  }
> @@ -1747,8 +1747,7 @@ xfs_fs_fill_super(
>  	xfs_close_devices(mp);
>   out_free_names:
>  	sb->s_fs_info = NULL;
> -	xfs_free_names(mp);
> -	kmem_free(mp);
> +	xfs_mount_free(mp);
>   out:
>  	return error;
>  
> @@ -1779,8 +1778,7 @@ xfs_fs_put_super(
>  	xfs_close_devices(mp);
>  
>  	sb->s_fs_info = NULL;
> -	xfs_free_names(mp);
> -	kmem_free(mp);
> +	xfs_mount_free(mp);
>  }
>  
>  STATIC struct dentry *
> 
