Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703CAC2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48656206D4
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:58:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MW7hJv9R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgA2R6p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 12:58:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56882 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgA2R6p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:58:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00THcnFg094535;
        Wed, 29 Jan 2020 17:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=2cAKfdmTMQSWaiwEv8y3Yy5pzaote4X8MIuxDQ+y2pk=;
 b=MW7hJv9RjqZnkxfAIaTdpZ8pQYn2FPTUQHIpyov54xmTsKLqIOwPjHHNgOYj4bQUTKdz
 +AdAHFcidofRzSy3SlQPWXDe8xfDU8HarLo1TiOk4rI7+SG2RtP4fAuaI1er5xQG7AKS
 o/HyjIGNSPhdd99whCxtxSjoDUCRhFnKY5DL+AcAuZe9tdk85vWXyFsOqEE1JJ/kEE5F
 NzRK3wXEUQbFJ+NV4QLsbcDOGBcHPh/R7uPRMCcPunZt/3nbpoyqgvnR31uNBpYcy/RV
 uIrJZQJwktc6lGt4oCFczri1zvOsZdeEm5J9J8Y0iE2EzaB4cGMdLpMBFir+TzBgnZaN Cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xrdmqq77b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 17:58:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00THcvGl112108;
        Wed, 29 Jan 2020 17:56:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xuemugvxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 17:56:40 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00THueeq006818;
        Wed, 29 Jan 2020 17:56:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jan 2020 09:56:39 -0800
Date:   Wed, 29 Jan 2020 09:56:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: don't take addresses of packed xfs_rmap_key
Message-ID: <20200129175638.GU3447196@magnolia>
References: <65e48930-96ae-7307-ba65-6b7528bb2fb5@redhat.com>
 <89743aba-ca7f-340c-c813-b8d73cb25cd7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89743aba-ca7f-340c-c813-b8d73cb25cd7@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001290145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001290145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 11:45:05AM -0600, Eric Sandeen wrote:
> gcc now warns about taking an address of a packed structure member.
> 
> This happens here because of how be32_add_cpu() works; just open-code
> the modification using a temporary variable instead.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index fc78efa52c94..ad5ead62c992 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -182,12 +182,14 @@ xfs_rmapbt_init_high_key_from_rec(
>  	union xfs_btree_rec	*rec)
>  {
>  	uint64_t		off;
> +	xfs_agblock_t		start;
>  	int			adj;
>  
>  	adj = be32_to_cpu(rec->rmap.rm_blockcount) - 1;
>  
>  	key->rmap.rm_startblock = rec->rmap.rm_startblock;

I was gonna say to kill this statement since you set it again two lines
later, but then spotted a bug two lines down...

> -	be32_add_cpu(&key->rmap.rm_startblock, adj);
> +	start = be32_to_cpu(rec->rmap.rm_startblock) - adj;
> +	rec->rmap.rm_startblock = cpu_to_be32(start);

...this should be setting key->rmap.rm_startblock.

--D

>  	key->rmap.rm_owner = rec->rmap.rm_owner;
>  	key->rmap.rm_offset = rec->rmap.rm_offset;
>  	if (XFS_RMAP_NON_INODE_OWNER(be64_to_cpu(rec->rmap.rm_owner)) ||
> 
> 
