Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02969C4BA1E
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 18:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD45A24653
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 18:06:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mue2lI1i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgBZSGP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 13:06:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38956 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbgBZSGP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 13:06:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QI3X5Z041381;
        Wed, 26 Feb 2020 18:06:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=q1aR8e2FUNG5DxAtQxOYOFLGk6LMBQRqFeM1P69fmQU=;
 b=Mue2lI1iGperRVWlZcTXolFlT8zMqar5xZo78h1A4nIL8wPXbNnKBx4pMbCfP2MhQr0H
 YozwH6j80ug1TkGqm8sSEeDWzaRWADDDr+Yzm7Z4d9SJzzmevKsSjkK1aLfI5cffr4ix
 nmcR6lt2AIStU2rCdLtUe6iCJJYxd8GULS9+1Qdoa2uGrOKGVYLWOYtQ2WtsspZCwh1i
 JLfF5ccUTE9TkM84X/3KaVokcBzn+qdAkK0YHy8hQg2RhTkMPUVtgWwFBidJWiY5Qi/5
 wn6tBABR8OgEMsAQR5EcvIPLzE48rTp/Tpfk2KQ0Ujiu4VVO9eLiXdGbJo1guMv0MGM/ 5A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ydcsnde1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 18:06:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QI2iXr042365;
        Wed, 26 Feb 2020 18:06:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ydcsabs1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 18:06:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01QI69ke014100;
        Wed, 26 Feb 2020 18:06:09 GMT
Received: from localhost (/10.159.139.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 10:06:09 -0800
Date:   Wed, 26 Feb 2020 10:06:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 V3] xfs: don't take addresses of packed xfs_rmap_key
 member
Message-ID: <20200226180608.GI8045@magnolia>
References: <65e48930-96ae-7307-ba65-6b7528bb2fb5@redhat.com>
 <89743aba-ca7f-340c-c813-b8d73cb25cd7@redhat.com>
 <b44b9c6e-4c40-2670-8c38-874a79e0d066@redhat.com>
 <06b937e3-afaf-41c0-3477-a4b1a88fee48@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06b937e3-afaf-41c0-3477-a4b1a88fee48@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 12:35:21PM -0600, Eric Sandeen wrote:
> gcc now warns about taking an address of a packed structure member.
> 
> This happens here because of how be32_add_cpu() works; just open-code
> the modification instead.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> V2: fix key-> vs rec-> derp derp thinko
> V3: drop local temp variable, add comment
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index fc78efa52c94..c6f6a7ec6121 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -187,7 +187,9 @@ xfs_rmapbt_init_high_key_from_rec(
>  	adj = be32_to_cpu(rec->rmap.rm_blockcount) - 1;
>  
>  	key->rmap.rm_startblock = rec->rmap.rm_startblock;
> -	be32_add_cpu(&key->rmap.rm_startblock, adj);
> +	/* do this manually to avoid gcc warning about alignment */
> +	key->rmap.rm_startblock =
> +		cpu_to_be32(be32_to_cpu(key->rmap.rm_startblock) - adj);

<blink>

This should be getting the value from rec->rmap, not key->rmap.

This should be adding adj, not subtracting it, since that's what the
original code did.

And finally, there's no need to set the value twice.

--D

>  	key->rmap.rm_owner = rec->rmap.rm_owner;
>  	key->rmap.rm_offset = rec->rmap.rm_offset;
>  	if (XFS_RMAP_NON_INODE_OWNER(be64_to_cpu(rec->rmap.rm_owner)) ||
> 
> 
