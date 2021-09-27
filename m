Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736BCC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE7B60EBB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhI0U2M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 16:28:12 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39464 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236986AbhI0U2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 16:28:12 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RJH6Fs021960;
        Mon, 27 Sep 2021 20:26:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=pyiWhT1VbDNzG+CZ9Y9XOV6cXGyCr5sE3A/K9a21rK4=;
 b=hZ1lij9RPIAKw6rcHberZu8dvr0CJGrN2r34bwMqIJLeYScefBmUFEmd2Om1Wm7bhRuK
 SzbBo1rkKRLQgNW+quAC0+1sntQFLNCHefVXMmpl4LLwug4punqVe9r6xmRBqTQlvwwQ
 919IJA9TskV8bRGUj/OVyV9kUAaIcBLy4/OOdj0fE9YA71H6X+nqSYLcFFlQFMZxEGdL
 q1MQI+Obld5M5468IDTwpDpae7Hms7Va/k/AEe/GUm+Sq6wGhgRAGd4QHH8WQHvtrYuF
 U/Z/u4E6eXidGy6pMf350LTRilNAr1wXZ/mJRLL8mzLnhwA4fbqRbvGL6r3wQQnHU5EL +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbejec2yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 20:26:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18RKQJc4071451;
        Mon, 27 Sep 2021 20:26:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3020.oracle.com with ESMTP id 3badhrk1nu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 20:26:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhR3gNbDRpYsvVks37pdUtrWi6dgoMmH18K+HuXUz2UpLK+ualf1FJOC4BFkq1SKq+2SLvJqBBa12TEkkz4p7FYQXuBlLP8ADM8GgDI7vWH6QR7K0ZgV694ZrTi8zOSPKbpLHpTVp8MkliwCJqR3IcPn7g41LsdY6o7teeYXBjr80P8GlgZtuENrwKaGOFM51XfUcVmkxWFKaZp2C1m91Qavu7ChtDTNY+HqoeJidkpEzvFA+SI5KtbKpIao85gccNAins7TVeU2thp2+a/JrQqre3MSLKOiT+GPqZXukxn+UsvwuCRZfIMfyTR8a4L5DqeT7AP2BOULApGKBwYVBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pyiWhT1VbDNzG+CZ9Y9XOV6cXGyCr5sE3A/K9a21rK4=;
 b=SRb4+j+KgPdGj/LFS94xGtI4RzX3PHzsDdEskmWOv0IQ0cUMOk3xIQiobNwOzWVbj+GNyiHXo0PgIrpPEgh3r2gJvRfINAoDj2Y3X7BDpnZ0uLCJKhVqlnopiyj5Qqo3wOAKgbpddVi7xQ46dKhegwy52wStgGB2JIQvUayhMzXzW62tncK5HmVLfkXCCvV2GlpXXBXeFhy9tEDZdRVuTFN/2BosoVcIFHigl51RkMo4FgivkBx6vZaqQyRBlpUUzff/iKmcbw0dc3t7HY48+Dc4FEG1FK1ZbQ0ICKn5rKMU1FqbO4bYinkpQTYxn7o0tA+QuHI5VmhUDvL8hRHbrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyiWhT1VbDNzG+CZ9Y9XOV6cXGyCr5sE3A/K9a21rK4=;
 b=V7+mnfbXzWEZRLV3mmoeLs9UGAW/prCRKrA7pO2mK2O+dWUp9EihkHOhhxmkecldIrFqt5MTMzFys0KQ3vtYDmEjKwHGxeT4lgSXnbZNFGGxHj8kYBddIAjVX+XrwufZsBHhyJZGn4b4BuUvAe9au5eJSf0yZoB4HCaRX/7QsFI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4387.namprd10.prod.outlook.com (2603:10b6:a03:211::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 20:26:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd%6]) with mapi id 15.20.4544.022; Mon, 27 Sep 2021
 20:26:29 +0000
Subject: Re: [PATCH 2/2] xfs: port the defer ops capture and continue to
 resource capture
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <163192863018.417887.1729794799105892028.stgit@magnolia>
 <163192864113.417887.5635394728171508101.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6343598d-294c-5c4e-8f14-39f058794233@oracle.com>
Date:   Mon, 27 Sep 2021 13:26:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <163192864113.417887.5635394728171508101.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0047.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR13CA0047.namprd13.prod.outlook.com (2603:10b6:a03:2c2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Mon, 27 Sep 2021 20:26:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba2f0d2b-5cb0-4ee3-99e4-08d981f516c0
X-MS-TrafficTypeDiagnostic: BY5PR10MB4387:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4387154D3381E665631A026A95A79@BY5PR10MB4387.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gkaZFjDvjfQZuZqjCr5TqyGnJk+7fJCu3izgwM8XiXpshXvi5cOZORUYJuvJ35fVv4dnmUy/rs+3BxfY09raYUAcNytW4ttLr1fkjw+KQwJ53/vatx+eek8WlHW17Kw0ZsajtxIA9IBHSAcAYHdnU87KwAQG+n0XN3rK1a24Uh9TZZwNm9JV25vEp86c19sVFcz2qiL/2l0xzW/E7gmxqLTZLFdWSWNopCqkbQ05Jrks4ErzwBicorIoA6NegZ9Ahkd+V/09wwIofkOM7h2wpkWxGBe6SoctIRl0BV8lsd2ugwLCXcQr56tjzU83GMc2touTgW3d3+heHSGWwJ7X0DubeYe6Hesfs2DphDlcOB0GW53TbHCIgyTgPzaRkhXMgaMksY4VxkmBpDDEsG6oyqKxmH2UXY0bywo9LYjCaMz+ckuJc+R/J8zFi3oE27X4NJlwYRNLV4POvL4TxE10Ke+myB0TRYZs7d7PdhIgcy9iocI8cK+qO0HQlCwK5gNWPtzYOY5bAqoB5Y0ncvJktya+Eb8BCmodwsdpXSJWPhyBqN7Dk+aZxVhlzJC2DHlDHKeXnwcGK6Z6lB+KRS804DbNEg8kuwJ/0awoiokRc9ImalIV8Nxfa4yHk0Ae739qtS7lnq0GVpuL85cxz3XlGP2A82LIF/eVj7rapl2E1308KdG/cDj4ckAQNJOMV7uN8AaP+SRoARc6iApLK7EuXoqqGiTYqnqobi2uStIbcA3aTsoRlBWNvHN/fLdNhk4nyhfGcZaO4OqjMaybgBOa0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(53546011)(38100700002)(38350700002)(52116002)(66476007)(66946007)(66556008)(508600001)(4326008)(26005)(2616005)(6916009)(31686004)(6486002)(30864003)(186003)(36756003)(86362001)(956004)(31696002)(316002)(16576012)(83380400001)(8676002)(5660300002)(8936002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjAwSWE2Tk1Vbzl3SlVrcnZUS3V0dExYakpPYVJzVWRXTHN3SkR2RmNJNDMv?=
 =?utf-8?B?bkRkNEJXU3E0ODNKNGNLYXA2WGhjVHlmNHVnYjBjVXdHSjNCK2QvS1dwbXdG?=
 =?utf-8?B?SHgzcUh5RG5rS3o0V0Q1SEE4UDJiUHNpZ29YN1pTNkhVRGpSTVlqWGo0QitH?=
 =?utf-8?B?VUZVZDNXR1h2cFRyVzEzUUlaeWl3cnkwSzlqQlBYd0RUdTk4aVczNUw0c04r?=
 =?utf-8?B?K1BUbXdrMWNvVlVNSktBSWNic2RleS9oQVh2bjRVNFNTdnZWdlJ0MlNoTDAr?=
 =?utf-8?B?Zkd3TmVHL0tEcndOWG1kN0Y2YWFPeWQxdTZnL1UyNXY4dml1akh5ZmRJR1hS?=
 =?utf-8?B?QmxmZjVtRmNCY2liRmJYYzlQRnA4UitKNzYwYkdqeXdRWEVneFF5L3p4T21E?=
 =?utf-8?B?RHNsMkZ3UTBiaWJleGNRcXFTcENqYVFudjdkS2VGeG1Da0lKTkRyYWFDbkNm?=
 =?utf-8?B?ajZJK2l6R0NKdUhWNU9yM3M5NTRXYkRUVzNtUjdwb3lTYjlUVlBldFd6SjVs?=
 =?utf-8?B?YlIySzA5OGVCdGE4RWdaNWVpeERzVGhLb29yaUZMRE9NeVJIY0psVkFNSkRm?=
 =?utf-8?B?eGRNYjdSL0R0ZDU0amhZR3EyMHRRYXNpMDlpc2oza0ZFZ2poZHp1Ny9wN3M1?=
 =?utf-8?B?ajBndkYzR0J0dFVNYXB2UUNRUDJtcUxKMThRTXc5aFB2bWdGOElZWDFvMUY2?=
 =?utf-8?B?aUFITUlnOWxDMHA4R1VrK2VYNmpqNlBVVFJENldvZkNReWpaeklnR2lZV2Ns?=
 =?utf-8?B?OTczSmFUQ1YwWjJyKzNFL08xaWhnaEVTRXdvSzhuUmJORHBWT055NEhraTh5?=
 =?utf-8?B?eUQydjRVSi9OTks4TFhPcVF5T00xTFNjKytUNEg5OS9ZZUFQblY4bUVKS3lP?=
 =?utf-8?B?cEt2RTVSVGVVVlpkV0Y5dnJpWitkYTloalAvTWQxdTV5c1E5ajNVd1lZVWRO?=
 =?utf-8?B?K0NUdisrRGlnVW9sWjMySXI4YUZLZFlNQWl2ZGRxaHkxSDVJa1Qzbk4zUTRs?=
 =?utf-8?B?ODEyNHArOXdhclhDbCtpM2JqaEFsdGVXWTVIL3lIVnZjU2RYQy9Mdm5LczFS?=
 =?utf-8?B?czVQQjB5VDYrZ01RZXJWRkZDbkdJKzVvK0RsbXdEd3VMOUwxWG85cW8vQUdU?=
 =?utf-8?B?RTZJMUFQczA0VWdnRndEWkg3K0NydTl0Mm96NTVTekFiU1VPYjFRMkJFYU9T?=
 =?utf-8?B?d056N1BJZm1EQWtoMmtjUEZWRm1jVkZadFdaNTNKcGxKY0NwNS81NXFHV0g5?=
 =?utf-8?B?NnJ5dVJhQURxUm5uMlJsd29XQ1Y5aFNqQ2dNUnI3RTNsMFVDVEUxRHpxcnZQ?=
 =?utf-8?B?OXpyZFNtMDRnaEE2VHkyZGhWeGowaVUxVkxBekpzMHFCbzNvWTVqeFhRY015?=
 =?utf-8?B?RnZwVm0vS2Y2azZmU0IzTk1FdExoVTBKazZEWXgxamxCc1VzZm1XenZTZkRJ?=
 =?utf-8?B?NzZIZlFUSldQQzByVHBrNW85MnZTam1kYnNvYWFzMlhEQlJUVkk5d09nR3lq?=
 =?utf-8?B?alFnMExGZzI2Vndtbk9Ub1hOWlFIU0d6WkdSNHQ4WC82anZMYnJMRHhCeEQz?=
 =?utf-8?B?VXZETllzSkcxejkzU01RQzNOaVBlU3pCWVhOeVZpaGNlTzZvaWZKYlVhMVky?=
 =?utf-8?B?cEErZGRDdXhNVHkwaHRNWWRvaE1tcllqTGVYVnZCVFlEdFlNd1psTDVZZmQ0?=
 =?utf-8?B?QlI5NVd4aXlKMVJMR1Q0T21IVDliN05iVS95WVkvYmtKRGxFazdjODBUeXoy?=
 =?utf-8?Q?QzuKO9EVURjIfHuG+tzu//oKfwmk8hT6PIGFvme?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2f0d2b-5cb0-4ee3-99e4-08d981f516c0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 20:26:29.9532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n676GhANta0UZm+KYbxeUxKnFpB9ZyA8VJ/4QdKJ77O5Yv9gO8kHkaNqZX8E6y94ii7qlmP5hZHp8MdW3Us6wXdLknAITUjeQBasQ2p+Vl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4387
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270137
X-Proofpoint-GUID: sZbJWE9TLbo_wPwb3L6z2H37_DlkBc4U
X-Proofpoint-ORIG-GUID: sZbJWE9TLbo_wPwb3L6z2H37_DlkBc4U
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/17/21 6:30 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When log recovery tries to recover a transaction that had log intent
> items attached to it, it has to save certain parts of the transaction
> state (reservation, dfops chain, inodes with no automatic unlock) so
> that it can finish single-stepping the recovered transactions before
> finishing the chains.
> 
> This is done with the xfs_defer_ops_capture and xfs_defer_ops_continue
> functions.  Right now they open-code this functionality, so let's port
> this to the formalized resource capture structure that we introduced in
> the previous patch.  This enables us to hold up to two inodes and two
> buffers during log recovery, the same way we do for regular runtime.
> 
> With this patch applied, we'll be ready to support atomic extent swap
> which holds two inodes; and logged xattrs which holds one inode and one
> xattr leaf buffer.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Ok, I think this is a cleaner way to address to issues for both features
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_defer.c  |   86 +++++++++++++++++++++++++++++++++-----------
>   fs/xfs/libxfs/xfs_defer.h  |   14 +++----
>   fs/xfs/xfs_bmap_item.c     |    2 +
>   fs/xfs/xfs_extfree_item.c  |    2 +
>   fs/xfs/xfs_log_recover.c   |   12 ++----
>   fs/xfs/xfs_refcount_item.c |    2 +
>   fs/xfs/xfs_rmap_item.c     |    2 +
>   7 files changed, 79 insertions(+), 41 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 7c6490f3e537..136a367d7b16 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -650,10 +650,11 @@ xfs_defer_move(
>    */
>   static struct xfs_defer_capture *
>   xfs_defer_ops_capture(
> -	struct xfs_trans		*tp,
> -	struct xfs_inode		*capture_ip)
> +	struct xfs_trans		*tp)
>   {
>   	struct xfs_defer_capture	*dfc;
> +	unsigned short			i;
> +	int				error;
>   
>   	if (list_empty(&tp->t_dfops))
>   		return NULL;
> @@ -677,27 +678,48 @@ xfs_defer_ops_capture(
>   	/* Preserve the log reservation size. */
>   	dfc->dfc_logres = tp->t_log_res;
>   
> +	error = xfs_defer_save_resources(&dfc->dfc_held, tp);
> +	if (error) {
> +		/*
> +		 * Resource capture should never fail, but if it does, we
> +		 * still have to shut down the log and release things
> +		 * properly.
> +		 */
> +		xfs_force_shutdown(tp->t_mountp, SHUTDOWN_CORRUPT_INCORE);
> +	}
> +
>   	/*
> -	 * Grab an extra reference to this inode and attach it to the capture
> -	 * structure.
> +	 * Grab extra references to the inodes and buffers because callers are
> +	 * expected to release their held references after we commit the
> +	 * transaction.
>   	 */
> -	if (capture_ip) {
> -		ihold(VFS_I(capture_ip));
> -		dfc->dfc_capture_ip = capture_ip;
> +	for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
> +		ASSERT(xfs_isilocked(dfc->dfc_held.dr_ip[i], XFS_ILOCK_EXCL));
> +		ihold(VFS_I(dfc->dfc_held.dr_ip[i]));
>   	}
>   
> +	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
> +		xfs_buf_hold(dfc->dfc_held.dr_bp[i]);
> +
>   	return dfc;
>   }
>   
>   /* Release all resources that we used to capture deferred ops. */
>   void
> -xfs_defer_ops_release(
> +xfs_defer_ops_capture_free(
>   	struct xfs_mount		*mp,
>   	struct xfs_defer_capture	*dfc)
>   {
> +	unsigned short			i;
> +
>   	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
> -	if (dfc->dfc_capture_ip)
> -		xfs_irele(dfc->dfc_capture_ip);
> +
> +	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
> +		xfs_buf_relse(dfc->dfc_held.dr_bp[i]);
> +
> +	for (i = 0; i < dfc->dfc_held.dr_inos; i++)
> +		xfs_irele(dfc->dfc_held.dr_ip[i]);
> +
>   	kmem_free(dfc);
>   }
>   
> @@ -712,24 +734,21 @@ xfs_defer_ops_release(
>   int
>   xfs_defer_ops_capture_and_commit(
>   	struct xfs_trans		*tp,
> -	struct xfs_inode		*capture_ip,
>   	struct list_head		*capture_list)
>   {
>   	struct xfs_mount		*mp = tp->t_mountp;
>   	struct xfs_defer_capture	*dfc;
>   	int				error;
>   
> -	ASSERT(!capture_ip || xfs_isilocked(capture_ip, XFS_ILOCK_EXCL));
> -
>   	/* If we don't capture anything, commit transaction and exit. */
> -	dfc = xfs_defer_ops_capture(tp, capture_ip);
> +	dfc = xfs_defer_ops_capture(tp);
>   	if (!dfc)
>   		return xfs_trans_commit(tp);
>   
>   	/* Commit the transaction and add the capture structure to the list. */
>   	error = xfs_trans_commit(tp);
>   	if (error) {
> -		xfs_defer_ops_release(mp, dfc);
> +		xfs_defer_ops_capture_free(mp, dfc);
>   		return error;
>   	}
>   
> @@ -747,17 +766,19 @@ void
>   xfs_defer_ops_continue(
>   	struct xfs_defer_capture	*dfc,
>   	struct xfs_trans		*tp,
> -	struct xfs_inode		**captured_ipp)
> +	struct xfs_defer_resources	*dres)
>   {
>   	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>   	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
>   
>   	/* Lock and join the captured inode to the new transaction. */
> -	if (dfc->dfc_capture_ip) {
> -		xfs_ilock(dfc->dfc_capture_ip, XFS_ILOCK_EXCL);
> -		xfs_trans_ijoin(tp, dfc->dfc_capture_ip, 0);
> -	}
> -	*captured_ipp = dfc->dfc_capture_ip;
> +	if (dfc->dfc_held.dr_inos == 2)
> +		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
> +				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
> +	else if (dfc->dfc_held.dr_inos == 1)
> +		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
> +	xfs_defer_restore_resources(tp, &dfc->dfc_held);
> +	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
>   
>   	/* Move captured dfops chain and state to the transaction. */
>   	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
> @@ -765,3 +786,26 @@ xfs_defer_ops_continue(
>   
>   	kmem_free(dfc);
>   }
> +
> +/* Release the resources captured and continued during recovery. */
> +void
> +xfs_defer_resources_rele(
> +	struct xfs_defer_resources	*dres)
> +{
> +	unsigned short			i;
> +
> +	for (i = 0; i < dres->dr_inos; i++) {
> +		xfs_iunlock(dres->dr_ip[i], XFS_ILOCK_EXCL);
> +		xfs_irele(dres->dr_ip[i]);
> +		dres->dr_ip[i] = NULL;
> +	}
> +
> +	for (i = 0; i < dres->dr_bufs; i++) {
> +		xfs_buf_relse(dres->dr_bp[i]);
> +		dres->dr_bp[i] = NULL;
> +	}
> +
> +	dres->dr_inos = 0;
> +	dres->dr_bufs = 0;
> +	dres->dr_ordered = 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index e095abb96f1a..7952695c7c41 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -107,11 +107,7 @@ struct xfs_defer_capture {
>   	/* Log reservation saved from the transaction. */
>   	unsigned int		dfc_logres;
>   
> -	/*
> -	 * An inode reference that must be maintained to complete the deferred
> -	 * work.
> -	 */
> -	struct xfs_inode	*dfc_capture_ip;
> +	struct xfs_defer_resources dfc_held;
>   };
>   
>   /*
> @@ -119,9 +115,11 @@ struct xfs_defer_capture {
>    * This doesn't normally happen except log recovery.
>    */
>   int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
> -		struct xfs_inode *capture_ip, struct list_head *capture_list);
> +		struct list_head *capture_list);
>   void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
> -		struct xfs_inode **captured_ipp);
> -void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
> +		struct xfs_defer_resources *dres);
> +void xfs_defer_ops_capture_free(struct xfs_mount *mp,
> +		struct xfs_defer_capture *d);
> +void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
>   
>   #endif /* __XFS_DEFER_H__ */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 03159970133f..e66c85a75104 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -532,7 +532,7 @@ xfs_bui_item_recover(
>   	 * Commit transaction, which frees the transaction and saves the inode
>   	 * for later replay activities.
>   	 */
> -	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
> +	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
>   	if (error)
>   		goto err_unlock;
>   
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 3f8a0713573a..8f12931b0cbb 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -637,7 +637,7 @@ xfs_efi_item_recover(
>   
>   	}
>   
> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> +	return xfs_defer_ops_capture_and_commit(tp, capture_list);
>   
>   abort_error:
>   	xfs_trans_cancel(tp);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 10562ecbd9ea..53366cc0bc9e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2466,11 +2466,11 @@ xlog_finish_defer_ops(
>   {
>   	struct xfs_defer_capture *dfc, *next;
>   	struct xfs_trans	*tp;
> -	struct xfs_inode	*ip;
>   	int			error = 0;
>   
>   	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
>   		struct xfs_trans_res	resv;
> +		struct xfs_defer_resources dres;
>   
>   		/*
>   		 * Create a new transaction reservation from the captured
> @@ -2494,13 +2494,9 @@ xlog_finish_defer_ops(
>   		 * from recovering a single intent item.
>   		 */
>   		list_del_init(&dfc->dfc_list);
> -		xfs_defer_ops_continue(dfc, tp, &ip);
> -
> +		xfs_defer_ops_continue(dfc, tp, &dres);
>   		error = xfs_trans_commit(tp);
> -		if (ip) {
> -			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -			xfs_irele(ip);
> -		}
> +		xfs_defer_resources_rele(&dres);
>   		if (error)
>   			return error;
>   	}
> @@ -2520,7 +2516,7 @@ xlog_abort_defer_ops(
>   
>   	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
>   		list_del_init(&dfc->dfc_list);
> -		xfs_defer_ops_release(mp, dfc);
> +		xfs_defer_ops_capture_free(mp, dfc);
>   	}
>   }
>   /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 46904b793bd4..61bbbe816b5e 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -557,7 +557,7 @@ xfs_cui_item_recover(
>   	}
>   
>   	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> +	return xfs_defer_ops_capture_and_commit(tp, capture_list);
>   
>   abort_error:
>   	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 5f0695980467..181cd24d2ba9 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -587,7 +587,7 @@ xfs_rui_item_recover(
>   	}
>   
>   	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> +	return xfs_defer_ops_capture_and_commit(tp, capture_list);
>   
>   abort_error:
>   	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> 
