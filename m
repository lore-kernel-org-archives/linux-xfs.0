Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438ABC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 209DB21702
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:47:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c4jm/DFr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgGUAru (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:47:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57990 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGUAru (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:47:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0i1qU052300;
        Tue, 21 Jul 2020 00:47:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uQr6t4iTTYfQgsi6QkX3sG0RZQ8fMoJNlKMnCI2NcBE=;
 b=c4jm/DFr6ghXqBfJMRIuR8CoGwK9p2QJwAIJi0zdt7vMNYSy7kI3qa69s/MPPf8tHLzJ
 6esPsohGYRDjJvcZpcMAc/KLsy1G8SwUDNVzvDlb/51LqXJLakPD3AFi8mbtxgM/lRZ8
 yftE1ReFRT8FZQDuhOqwQDtzGvhGiYoJ+Gklfr815eAcXywqnQ9RjxRtq9HTplWKPlPp
 nImReKGTyM8OuKdSlvIWBW3VenAO0EqsOiPm/dsAV1u3Ub5PJ57RG6L0jeAcAiogdoKp
 EJtxG5Qq8UUqZrhOcBLLdXjCoJlMYMJjG5W8qWt3p/QRZGZxvhbJTBHN0Ums+lR8rz3B hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32bs1ma0fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 00:47:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0gxlA069136;
        Tue, 21 Jul 2020 00:47:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32dnmq8v68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 00:47:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L0ljZS026444;
        Tue, 21 Jul 2020 00:47:45 GMT
Received: from localhost (/10.159.141.124)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 00:47:45 +0000
Date:   Mon, 20 Jul 2020 17:47:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] repair: remove custom dir2 sf fork verifier from
 phase6
Message-ID: <20200721004744.GW3151642@magnolia>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715140836.10197-5-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=1 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 10:08:36AM -0400, Brian Foster wrote:
> The custom verifier exists to catch the case of repair setting a
> dummy parent value of zero on directory inodes and temporarily
> replace it with a valid inode number so the rest of the directory
> verification can proceed. The custom verifier is no longer needed
> now that the rootino is used as a dummy value for invalid on-disk
> parent values.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

More or less the same code that's in my tree...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  repair/phase6.c | 56 ++-----------------------------------------------
>  1 file changed, 2 insertions(+), 54 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index beceea9a..43bcea50 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -26,58 +26,6 @@ static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
>  						1,
>  						XFS_DIR3_FT_DIR};
>  
> -/*
> - * When we're checking directory inodes, we're allowed to set a directory's
> - * dotdot entry to zero to signal that the parent needs to be reconnected
> - * during phase 6.  If we're handling a shortform directory the ifork
> - * verifiers will fail, so temporarily patch out this canary so that we can
> - * verify the rest of the fork and move on to fixing the dir.
> - */
> -static xfs_failaddr_t
> -phase6_verify_dir(
> -	struct xfs_inode		*ip)
> -{
> -	struct xfs_mount		*mp = ip->i_mount;
> -	struct xfs_ifork		*ifp;
> -	struct xfs_dir2_sf_hdr		*sfp;
> -	xfs_failaddr_t			fa;
> -	xfs_ino_t			old_parent;
> -	bool				parent_bypass = false;
> -	int				size;
> -
> -	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> -	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
> -	size = ifp->if_bytes;
> -
> -	/*
> -	 * If this is a shortform directory, phase4 may have set the parent
> -	 * inode to zero to indicate that it must be fixed.  Temporarily
> -	 * set a valid parent so that the directory verifier will pass.
> -	 */
> -	if (size > offsetof(struct xfs_dir2_sf_hdr, parent) &&
> -	    size >= xfs_dir2_sf_hdr_size(sfp->i8count)) {
> -		old_parent = libxfs_dir2_sf_get_parent_ino(sfp);
> -		if (old_parent == 0) {
> -			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
> -			parent_bypass = true;
> -		}
> -	}
> -
> -	fa = libxfs_default_ifork_ops.verify_dir(ip);
> -
> -	/* Put it back. */
> -	if (parent_bypass)
> -		libxfs_dir2_sf_put_parent_ino(sfp, old_parent);
> -
> -	return fa;
> -}
> -
> -static struct xfs_ifork_ops phase6_ifork_ops = {
> -	.verify_attr	= xfs_attr_shortform_verify,
> -	.verify_dir	= phase6_verify_dir,
> -	.verify_symlink	= xfs_symlink_shortform_verify,
> -};
> -
>  /*
>   * Data structures used to keep track of directories where the ".."
>   * entries are updated. These must be rebuilt after the initial pass
> @@ -1104,7 +1052,7 @@ mv_orphanage(
>  					(unsigned long long)ino, ++incr);
>  
>  	/* Orphans may not have a proper parent, so use custom ops here */
> -	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &phase6_ifork_ops);
> +	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &xfs_default_ifork_ops);
>  	if (err)
>  		do_error(_("%d - couldn't iget disconnected inode\n"), err);
>  
> @@ -2875,7 +2823,7 @@ process_dir_inode(
>  
>  	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
>  
> -	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &phase6_ifork_ops);
> +	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
>  	if (error) {
>  		if (!no_modify)
>  			do_error(
> -- 
> 2.21.3
> 
