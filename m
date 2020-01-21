Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162B4C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 19:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D669721835
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 19:45:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dJ2/nqDs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgAUTpx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 14:45:53 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39102 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgAUTpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 14:45:53 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LJcrkU052001;
        Tue, 21 Jan 2020 19:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=e+uM/WtV1tlUrk2dihHhrJMKhRLBZLopMCPC4rFDWOs=;
 b=dJ2/nqDsQtLnlWREQaQxNU6xoC1iroJWgZJ9Yc7wBY9r/y/ZqSyyL8Wu/ThFd+uhVbrH
 ULmomW+4ePsb2njdOr/R9HrOUmevTQZj33GbQ53QYRAx/tkA4Nb7anHkogI2OOGG/SCb
 f5sZtueFuJwEg0kCkZ7ImjWWhwx1ef4oXAnzBDqSsRTF7IK2nfILHpNxHq+iW8gymz20
 iQnNJmjQuVoIa99rAHoSE6/KL2jpCRAaOSakDvtFU+y4UqTGRErWsejkVQ8j21tMinVl
 VPFznGf969elfRA/6zr43IyOq2xTh3F652yUq/eTiRKllnrIvkL9zlUZVEa7grESpgwP hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xktnr77xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 19:45:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LJdfwx087233;
        Tue, 21 Jan 2020 19:45:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xnsa99fyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 19:45:48 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LJjmQp016375;
        Tue, 21 Jan 2020 19:45:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 11:45:47 -0800
Date:   Tue, 21 Jan 2020 11:45:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 28/29] xfs: remove XFS_DA_OP_INCOMPLETE
Message-ID: <20200121194545.GD8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-29-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-29-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:50AM +0100, Christoph Hellwig wrote:
> Now that we use the on-disk flags field also for the interface to the
> lower level attr routines we can use the XFS_ATTR_INCOMPLETE definition
> from the on-disk format directly instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

FWIW I think this looks right but I'll wait for you to confirm which
flagset go in which fields in the da_args structure.

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      |  2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c | 15 ++++++---------
>  fs/xfs/libxfs/xfs_types.h     |  4 +---
>  3 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2b9c0aa5af4a..20f791ea0aa3 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -894,7 +894,7 @@ xfs_attr_node_addname(
>  		 * The INCOMPLETE flag means that we will find the "old"
>  		 * attr, not the "new" one.
>  		 */
> -		args->op_flags |= XFS_DA_OP_INCOMPLETE;
> +		args->attr_namespace |= XFS_ATTR_INCOMPLETE;
>  		state = xfs_da_state_alloc();
>  		state->args = args;
>  		state->mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 9081ba7af90a..fae322105457 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -456,7 +456,12 @@ xfs_attr_match(
>  		return false;
>  	if (memcmp(args->name, name, namelen) != 0)
>  		return false;
> -	if (args->attr_namespace != (flags & XFS_ATTR_NSP_ONDISK_MASK))
> +	/*
> +	 * If we are looking for incomplete entries, show only those, else only
> +	 * show complete entries.
> +	 */
> +	if (args->attr_namespace !=
> +	    (flags & (XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE)))
>  		return false;
>  	return true;
>  }
> @@ -2387,14 +2392,6 @@ xfs_attr3_leaf_lookup_int(
>  /*
>   * GROT: Add code to remove incomplete entries.
>   */
> -		/*
> -		 * If we are looking for INCOMPLETE entries, show only those.
> -		 * If we are looking for complete entries, show only those.
> -		 */
> -		if (!!(args->op_flags & XFS_DA_OP_INCOMPLETE) !=
> -		    !!(entry->flags & XFS_ATTR_INCOMPLETE)) {
> -			continue;
> -		}
>  		if (entry->flags & XFS_ATTR_LOCAL) {
>  			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
>  			if (!xfs_attr_match(args, name_loc->namelen,
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 1bf84488d34c..1aec335dac92 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -225,7 +225,6 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
>  #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
>  #define XFS_DA_OP_NOTIME	0x0020	/* don't update inode timestamps */
> -#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
>  
>  #define XFS_DA_OP_FLAGS \
>  	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
> @@ -233,8 +232,7 @@ typedef struct xfs_da_args {
>  	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
>  	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
>  	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> -	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
> -	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
> +	{ XFS_DA_OP_NOTIME,	"NOTIME" }
>  
>  /*
>   * Type verifier functions
> -- 
> 2.24.1
> 
