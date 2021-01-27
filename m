Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5735CC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 07:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 132482064B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 07:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhA0HXk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 02:23:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50548 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317231AbhA0Akr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 19:40:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R0JqNc002484;
        Wed, 27 Jan 2021 00:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dfGLiRs1bBoBZR0PLfrxdUQM0kiq5dwIuKlrYwDnjZY=;
 b=mlFgXfYvpYhw8ZfPvRweXQY8TSDGluIxMP5qtKyLtBFwIY1yAtCBBjguYpsjxA07WAUc
 9lZw/YlDCAeU43XCD4zGZ0i3B4UbXWGtPqD26lYdbCY0schmHCxL9gKN9Mw+un1kvWcu
 NQh8chBBS0JKff3+yd7Ju2mOB746RLqvCEDzrqGDex+AtDDTrAo9dWTuwFaMRvDaejtM
 DlxK8GnZhFy2WBBxrAYy/qEKRwzxOJK4lyeHZ2Tu5w/Hjrxlc5fDpKiBouCgXyS3UCJi
 Ki6t94GnI/Fnr26oCQsTZrOiR34uCEsEsE0hBXKRmVaNQImzg1UHhtwYvOB2N3R+dx3a zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 368b7qvpnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 00:39:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R0L5lm059861;
        Wed, 27 Jan 2021 00:39:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3030.oracle.com with ESMTP id 368wcnksp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 00:39:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEeO/4mli91E7yNqMG3ZRJFoyCmfsSlogfSKoFPN/4elP2FokfGV+moo8nUaRvv/5FRNaMRcC1oC6RNulCMw5b7uKiXsp82NK+zIpQrSFYeisn7dJ40txDcIWLeGjz9+jLR4snUE7qZEhc36nR5e8GxRbBuauevRTUh43JUEx9EJmk5pS20SHZWef5Basq8luRsbdJIhmOuNuf+upnBIIBiKWJH28BIILuz0V3WmHLcUFHn/01PjhKmVhxfW4rY178ViT6dNew5G6e8t78Qk5yWinZzVdOl0kNDBCEXzOZINZ8+Fy/Jyg2F9BrLOOtbgT3lVVtcSRt6Z1FR6WzZ8Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfGLiRs1bBoBZR0PLfrxdUQM0kiq5dwIuKlrYwDnjZY=;
 b=P3hRXNWH9nwmLHxE2uJv+k8saP8WDyqiDM/SRm9nAixDmxMphGOIQZKWJi5BJHnXmLQJoZ1G/JhXzE3bNMO7+33rwwqphZCf0vQWoYzWI+NsK+kS4Qr64h30TfX6mtg/+HDalgghCjSNsiqeYOEUpvckBt9cwYj2FGgwO9FpvXMzbPRrCPJwKSGZZH9Fe1xqo0LfijGlU+fuzQ/3BJ0UT8fd7w4Jivfw+I/sphlfu7T16A42cX1xSM70buaiN1t5P74TVmn1e0M2MVKc1XeYpOi5tGVuus59opd6BYIRX+4Fhtu81BK32foLZ80G9pNaJ4T1s7b+m/LSGVObxY22dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfGLiRs1bBoBZR0PLfrxdUQM0kiq5dwIuKlrYwDnjZY=;
 b=dlOyqLsvk6/oWsFF80KfQxnTZ3yasarECrJNwlRFk6DYp8xIZe4PG40SjhymU7SkwuRMLx7QPSMk+Xy9BVqZZQDkUqF09PsDcmD+A3mmbNCPH6qlUU5p5YpDZNOVJh7s3apZ59QjpwMuMZPR8anNw5DJxoPo+po5h2nhix48AvU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3921.namprd10.prod.outlook.com (2603:10b6:a03:1ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 00:39:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 00:39:21 +0000
Subject: Re: [PATCH V15 06/16] xfs: Check for extent overflow when renaming
 dir entries
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, hch@lst.de,
        "Darrick J . Wong" <darrick.wong@oracle.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
 <20210126063232.3648053-7-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <b15f5a64-9afb-920b-9b05-3fa9d9f041f0@oracle.com>
Date:   Tue, 26 Jan 2021 17:39:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210126063232.3648053-7-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.89.149]
X-ClientProxiedBy: BY5PR20CA0006.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.223] (67.1.89.149) by BY5PR20CA0006.namprd20.prod.outlook.com (2603:10b6:a03:1f4::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 00:39:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1363f8e4-352f-4860-e732-08d8c25bfc85
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3921911D4B598318DDE970BC95BB9@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /4FH7H4sBylXA/VRzq1oX55OvX0FyCACsFB/wZNBACPS+hVxiOn50LLSXZFWAeVObcqbAjVihw+Gfnt4D/ZsiXYLYvLLFTFDQ73TOBhSZMiPcNdauAGoVqh6sdvHBM4eNpfxi/vNqh9rBTmmslv9Ig6EyNoA1h4d4Wl3v/cvrY6rG1G77FcRgJpkXEKFg3JWhuiU7UMN5XkpOZSMY/ZOf7MDPNzXOl1xbOTa1bOzYoVvfyWhDDpbLdYhqRASRGlFVw4+oc29JK53DlCTdIj3DJERAn6yWXy2C+4IdI87dtqI9jTlg8vgRawzJZEsYkREPMcO47uE0j7LwmUdffaFi4ZobkaqCbPdppMfvuww1n7craHeicK8opJdx7jmpeFUV4dDbX6ZOLmEgUJU4BpMtwkNQ6erUq6pDar/qadn5NGpzY1PLYoyb5YQaCMVwfPLoLXvJO8YWTjAtp888LeG3/yCO7exV/gdav4u5Qq2mx0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(8936002)(36756003)(316002)(44832011)(16576012)(66556008)(66946007)(66476007)(86362001)(8676002)(2906002)(478600001)(5660300002)(31686004)(6486002)(4326008)(956004)(26005)(16526019)(186003)(53546011)(2616005)(83380400001)(52116002)(107886003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LSK1ldcC0YOrVcg/C5MwWI3HBUiXch61Y7tPPesY302qzZpUT1atGcPj/j/A1vrEkb4flt1UTiMT6pFsLzytf1+c/z+c+rKMe5EqNASWTvzX4Ax1mx6qdNxb4kRBSQM0TqbBgE7q9GhBoIRztg5sNh9lzbKlHch9rs6oHlMGJ8KYVL8rJcDQ/KqZO9Sdj0eY6xmWJu1Xt1B7zpEEK9X/u4medPoxGzSjBWZ+UX3CqmcCtu9FJy4dCmLEtnGomc304se6vYX4CtifK/4aUfrp0lyLiBMx+6S+J3lnaCBepShWgyY4O9PAS5lrBYWR/+oAjZuIcSbgORjEymIQdgFVp/Ar3PWYt06g0BAlHUjnB6zSEtj2pURb+sf33buw1bUiKkH3MZD3D2r7F+eslTW97xYgTtcY/O95CL1cArF7MvZWMPyx41jEnvk7ODJ8P4AkkRmzYh/l7MGLp/BFcXEzcjd0SUPIPWm5BK8C/epn00PUsrFYJ//GDtkx2G6p9iWyq79qprr1wz63XpBbRZSpX9NhyMlWoFIPRNDU2l9Omrvyhs+IVQaVLnZDVBKdTfLZOUJFU6t7Bwzikacsm4Xfjhc1nTQIGbPhI5IGpxEaS/AgZhFQDl6+74z9/dlcvqfCS6Nd44l6rjT6yL6i/1M1KM3i+e8llPGcQHmErQw42cGZPXfliew1hEHNmb4QguGHTiCM52smXW+Gg6oXzhBblAVC6hTFkeSJU0Zn9LrZjL0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1363f8e4-352f-4860-e732-08d8c25bfc85
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 00:39:20.8755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Pn77P3hhiXqxjWdoCV/mpBtBZHt4wBinQzwDdcnBOgpPB1Sb7M2JwAZvtiONq4QwxnJWFp6zX+U6FEfcFaHhWoKsQ0H0M5pmmKFvCy73IA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270000
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/25/21 11:32 PM, Chandan Babu R wrote:
> A rename operation is essentially a directory entry remove operation
> from the perspective of parent directory (i.e. src_dp) of rename's
> source. Hence the only place where we check for extent count overflow
> for src_dp is in xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real()
> returns -ENOSPC when it detects a possible extent count overflow and in
> response, the higher layers of directory handling code do the following:
> 1. Data/Free blocks: XFS lets these blocks linger until a future remove
>     operation removes them.
> 2. Dabtree blocks: XFS swaps the blocks with the last block in the Leaf
>     space and unmaps the last block.
> 
> For target_dp, there are two cases depending on whether the destination
> directory entry exists or not.
> 
> When destination directory entry does not exist (i.e. target_ip ==
> NULL), extent count overflow check is performed only when transaction
> has a non-zero sized space reservation associated with it.  With a
> zero-sized space reservation, XFS allows a rename operation to continue
> only when the directory has sufficient free space in its data/leaf/free
> space blocks to hold the new entry.
> 
> When destination directory entry exists (i.e. target_ip != NULL), all
> we need to do is change the inode number associated with the already
> existing entry. Hence there is no need to perform an extent count
> overflow check.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>


Ok, thanks for all the explaining!
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_bmap.c |  3 +++
>   fs/xfs/xfs_inode.c       | 44 +++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6c8f17a0e247..8ebe5f13279c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5160,6 +5160,9 @@ xfs_bmap_del_extent_real(
>   		 * until a future remove operation. Dabtree blocks would be
>   		 * swapped with the last block in the leaf space and then the
>   		 * new last block will be unmapped.
> +		 *
> +		 * The above logic also applies to the source directory entry of
> +		 * a rename operation.
>   		 */
>   		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
>   		if (error) {
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4cc787cc4eee..f0a6d528cbc4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3116,6 +3116,35 @@ xfs_rename(
>   	/*
>   	 * Check for expected errors before we dirty the transaction
>   	 * so we can return an error without a transaction abort.
> +	 *
> +	 * Extent count overflow check:
> +	 *
> +	 * From the perspective of src_dp, a rename operation is essentially a
> +	 * directory entry remove operation. Hence the only place where we check
> +	 * for extent count overflow for src_dp is in
> +	 * xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real() returns
> +	 * -ENOSPC when it detects a possible extent count overflow and in
> +	 * response, the higher layers of directory handling code do the
> +	 * following:
> +	 * 1. Data/Free blocks: XFS lets these blocks linger until a
> +	 *    future remove operation removes them.
> +	 * 2. Dabtree blocks: XFS swaps the blocks with the last block in the
> +	 *    Leaf space and unmaps the last block.
> +	 *
> +	 * For target_dp, there are two cases depending on whether the
> +	 * destination directory entry exists or not.
> +	 *
> +	 * When destination directory entry does not exist (i.e. target_ip ==
> +	 * NULL), extent count overflow check is performed only when transaction
> +	 * has a non-zero sized space reservation associated with it.  With a
> +	 * zero-sized space reservation, XFS allows a rename operation to
> +	 * continue only when the directory has sufficient free space in its
> +	 * data/leaf/free space blocks to hold the new entry.
> +	 *
> +	 * When destination directory entry exists (i.e. target_ip != NULL), all
> +	 * we need to do is change the inode number associated with the already
> +	 * existing entry. Hence there is no need to perform an extent count
> +	 * overflow check.
>   	 */
>   	if (target_ip == NULL) {
>   		/*
> @@ -3126,6 +3155,12 @@ xfs_rename(
>   			error = xfs_dir_canenter(tp, target_dp, target_name);
>   			if (error)
>   				goto out_trans_cancel;
> +		} else {
> +			error = xfs_iext_count_may_overflow(target_dp,
> +					XFS_DATA_FORK,
> +					XFS_IEXT_DIR_MANIP_CNT(mp));
> +			if (error)
> +				goto out_trans_cancel;
>   		}
>   	} else {
>   		/*
> @@ -3283,9 +3318,16 @@ xfs_rename(
>   	if (wip) {
>   		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
>   					spaceres);
> -	} else
> +	} else {
> +		/*
> +		 * NOTE: We don't need to check for extent count overflow here
> +		 * because the dir remove name code will leave the dir block in
> +		 * place if the extent count would overflow.
> +		 */
>   		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
>   					   spaceres);
> +	}
> +
>   	if (error)
>   		goto out_trans_cancel;
>   
> 
