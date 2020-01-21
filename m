Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E620BC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B897B21734
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dTLmCzgT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAUS5a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:57:30 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgAUS5a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:57:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LImShR009116;
        Tue, 21 Jan 2020 18:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=OyCZobim6klaEsG+THzBMUDEW99inOmQYnhE9yACsZ4=;
 b=dTLmCzgTVL+GHkm0Hlr4/R0Vtw5eMXu648aE/gPuMTGc6V/277lJs3UjcZA73hbqXAJs
 KUod9CrOqW1mmN387lJA117uCs7V673z0ZHr49JHudnoz5NGbo7xru268qZCpt+uY/2b
 pFxOdmj/LUF6rwncxlplCQWzHzLlqW7+ZTJYncTumCAyAPsn0Xtlv2yp20lwzsKcoBR6
 TVBAI7m3nttsXrplOLO+Tilq6b/3z/87eHkl3fuHFV8rKx2lvYyK/xtHVJCpeiuOozv8
 pQhZjeSLFU+V7mn2+Xo9pVb+zORwzSc1UwKJau94HUuTicJJRpvkptb8q9Fq4GjtuNev tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xktnr6ybv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:57:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LImH4k029477;
        Tue, 21 Jan 2020 18:57:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xnpfpjqmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:57:25 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LIvOmR008976;
        Tue, 21 Jan 2020 18:57:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:57:24 -0800
Date:   Tue, 21 Jan 2020 10:57:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 26/29] xfs: clean up the ATTR_REPLACE checks
Message-ID: <20200121185723.GA8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-27-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-27-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=886
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=952 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:48AM +0100, Christoph Hellwig wrote:
> Remove superflous braces, elses after return statements and use a goto
> label to merge common error handling.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fce4fd4a3370..3b29cdeecb64 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -419,9 +419,9 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	trace_xfs_attr_sf_addname(args);
>  
>  	retval = xfs_attr_shortform_lookup(args);
> -	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
>  		return retval;
> -	} else if (retval == -EEXIST) {
> +	if (retval == -EEXIST) {
>  		if (args->flags & ATTR_CREATE)
>  			return retval;
>  		retval = xfs_attr_shortform_remove(args);
> @@ -485,14 +485,11 @@ xfs_attr_leaf_addname(
>  	 * the given flags produce an error or call for an atomic rename.
>  	 */
>  	retval = xfs_attr3_leaf_lookup_int(bp, args);
> -	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> -		xfs_trans_brelse(args->trans, bp);
> -		return retval;
> -	} else if (retval == -EEXIST) {
> -		if (args->flags & ATTR_CREATE) {	/* pure create op */
> -			xfs_trans_brelse(args->trans, bp);
> -			return retval;
> -		}
> +	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
> +		goto out_brelse;
> +	if (retval == -EEXIST) {
> +		if (args->flags & ATTR_CREATE)	/* pure create op */
> +			goto out_brelse;
>  
>  		trace_xfs_attr_leaf_replace(args);
>  
> @@ -633,6 +630,9 @@ xfs_attr_leaf_addname(
>  		error = xfs_attr3_leaf_clearflag(args);
>  	}
>  	return error;
> +out_brelse:
> +	xfs_trans_brelse(args->trans, bp);
> +	return retval;
>  }
>  
>  /*
> @@ -759,9 +759,9 @@ xfs_attr_node_addname(
>  		goto out;
>  	blk = &state->path.blk[ state->path.active-1 ];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
>  		goto out;
> -	} else if (retval == -EEXIST) {
> +	if (retval == -EEXIST) {
>  		if (args->flags & ATTR_CREATE)
>  			goto out;
>  
> -- 
> 2.24.1
> 
