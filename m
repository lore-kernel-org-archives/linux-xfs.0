Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98ACFC3F2CE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 02:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C59220838
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 02:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nzeZ/1BA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgCEC3H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 21:29:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35584 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgCEC3G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 21:29:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0252N70D022284;
        Thu, 5 Mar 2020 02:29:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MVIzCF32u0dYxW6s0FCeLhzL3FrvUdggN0kcuwkUNMc=;
 b=nzeZ/1BAh9P9AYbNFbYo11skRQZs/hOEV7RcZOGXKusdiuWsG1rl0eodSayTG7UCy9HU
 2xQT/Dzx9wTGc8j2tPNoN/C9+4pi2aJh5ymdhabs4XEkq0flUCudDRvKM1aoDsvucOL1
 6qkOeoz9pxLHmbMUNG7ytXen3kUkJoygsNK+hrOxAH3gwUBuT3NWGl8Y61mlNrOQsgHk
 d1HvaKWreTQ4WMHB379yI7clr5sWfo2qaWuVJZg6wbE/QBse4eCIeBYIPLN4I8deJwjZ
 PbN58v0gZinXQKRFKsSlo5VO0zttyiEYWPrWmAs2K5TyRuyY0OjCH5rdC9791TBtyeOF FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yghn3e3tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 02:29:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0252MZZ0157808;
        Thu, 5 Mar 2020 02:29:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2yg1p95k7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 02:29:04 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0252T3BE008641;
        Thu, 5 Mar 2020 02:29:03 GMT
Received: from localhost (/10.159.138.101)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Mar 2020 02:29:02 +0000
Date:   Wed, 4 Mar 2020 18:29:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: introduce new private btree cursor names
Message-ID: <20200305022901.GP8045@magnolia>
References: <20200305014537.11236-1-david@fromorbit.com>
 <20200305014537.11236-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305014537.11236-2-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003050010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003050010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 12:45:31PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Just the defines of the new names - the conversion will be in
> scripted commits after this.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_btree.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 3eff7c321d43..bd5a2bfca64e 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -224,6 +224,8 @@ typedef struct xfs_btree_cur
>  #define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
>  		} b;
>  	}		bc_private;	/* per-btree type data */
> +#define bc_ag	bc_private.a
> +#define bc_bt	bc_private.b

Hm. I get that the historical meaning of "b" was for "bmbt", but it's
not a great descriptor since the fields in bc_private.b are really for
inode-rooted btrees, of which the bmbt is currently the only user.  If
we ever get around to adding the realtime rmapbt, then "bc_bt" is going
to seem a bit anachronistic.

bc_ino, perhaps?

--D

>  } xfs_btree_cur_t;
>  
>  /* cursor flags */
> -- 
> 2.24.0.rc0
> 
