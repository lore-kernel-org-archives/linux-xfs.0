Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A63C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3ED2610FC
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbhI0UkM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 16:40:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42478 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235925AbhI0UkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 16:40:11 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RKGopZ032582;
        Mon, 27 Sep 2021 20:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bg1bNqBuPezwaDTvYOP3n54w/WGz1khjuAsp7BTtYRc=;
 b=nNwNi0GENxjae9fIKVx8tR7+4AnegZxdyIHjZJy7q9iluSwmS/OevWEdJLSYbIbeP1OU
 y4R7JEOlJxzf5sbmbSbK4qURM2HZ+uPxjJJw8R5+nV/0EhbQ69hLu/Gj83Pmw65qmqT+
 HfOmwqHGgDOKEXqwem+C2KAyw5NMUHDf3jPwOU6vk+n62M06rqBcPrWCQmhvM3v6BpsV
 fuTWkcvHcY3PUqIFfnO9mCRv+YWrXwI/AlKhmfutfLPlsEsFs7feX7hggCyjWrjOieAr
 SdQdmEQ1Mj/yU0J/CxeFpP13vyqVwBW9g8V7B/9ibzhCxZfxCTLMhHG2GijZRllYrWJg 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbh6nj5kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 20:38:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18RKV8CI188849;
        Mon, 27 Sep 2021 20:38:30 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by aserp3020.oracle.com with ESMTP id 3b9x50ysc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 20:38:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwClHsphm+qj4QPS7h7dC166oa/yDrRZZTOwcwXhKu+l+kTp2oYuOq7VVcLiqYjtmJ//3o74mtS3OYC+wH/SJv+xciU+xR+BIAzmhKlaiQmui49Y06GDciWVSIxUjASvZSHM3rdtIVeZLT/U2Xx5pgS9FkmgBW/tKvevk0N3X1ICu2YTx4l8Dq3CGdPvvsC6WHHz4DV7uC0+34uRNHgRZByMCsthbzMdidZf/JORsYWF08aKjcK2TjQjRS4ST/YSC+iykKtYS/sXi+4Fn+ZVhjZdnypB2HeAdoBw9FNtiK30B77vIVqHxNzPXR1UWbVWp9/CLcLiaG54dXcxu1ctiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bg1bNqBuPezwaDTvYOP3n54w/WGz1khjuAsp7BTtYRc=;
 b=dQxzfv3dFHTWSrtqAiXmpVheF3UGf96pdnzIVLJdGSoELBolC5Uv93oUEhGa61d47qHq7VUbW+bn3VcoO6gCT3f23TaLmhbGjKhJPHUGpcFfbGBAQqh371QGbATXIuvG+hWsAzLdh9tlcfsMxjQ9FYi3c22Nd2bDcKVY3/JYJxpQq4OMTjQ0eTtb4M1gwiXoF4jmsFS4DdVGQ2WlzLIMuLCXhUZttgqj9XaKFP5EPCcQhj341dEKicAT1uaVuTE/CaQgiCKT+TTAJKTBX+VXGter5ubkrM+T2NFKWJ7S+6cjWOWhqiHrHVtBQRNKVFLHD1REhFtsny4gj0/yDJ6l8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bg1bNqBuPezwaDTvYOP3n54w/WGz1khjuAsp7BTtYRc=;
 b=gmRETdZhnLrpYK6CJ6Ia3z+nGdt2bRNuKDSo3tPDbYmeqM09AAC82aqt9Bu3vLQmGzI4s/4wG9qHV2t63lHA8+JQ+fwH+gaiko2wWBojcTo6t2OlvS4ckJRMBjUC8pCTvQIr2WdQEAWrjLgoGA0yJCPU4gPJ7RZvsfQLxnn1gwU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2872.namprd10.prod.outlook.com (2603:10b6:a03:89::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 20:38:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd%6]) with mapi id 15.20.4544.022; Mon, 27 Sep 2021
 20:38:28 +0000
Subject: Re: [PATCH 1/2] xfs: formalize the process of holding onto resources
 across a defer roll
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <163192863018.417887.1729794799105892028.stgit@magnolia>
 <163192863566.417887.12509295398707646105.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <600c5658-930e-a3c0-77ad-0e03dfba158b@oracle.com>
Date:   Mon, 27 Sep 2021 13:38:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <163192863566.417887.12509295398707646105.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0166.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR13CA0166.namprd13.prod.outlook.com (2603:10b6:a03:2c7::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Mon, 27 Sep 2021 20:38:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07c6c113-64bc-427c-3ecc-08d981f6c33c
X-MS-TrafficTypeDiagnostic: BYAPR10MB2872:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2872E8867FA62A605A0E058095A79@BYAPR10MB2872.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d1FluIo3L93rrSJYwp+jdrBQ6vnG9Jv3tipaMSbaVRC7gLORhObDWWbbIzFbO8CkRlKH//hHC51/+2MAzB/5J8Je3bKWmCfcWmqaXFHo318rkdWIQJJ+dNn5yivulcXUQd2nNK52y5B22SO7vPm2wTZjRqnvNO7e0T88//GXrgH6we8Z3UGis/OzMXY2Rn+PQCFJGp8UoAOlTXyf3+PP2HxAp6cShrNCR0LTL8lRySKTijhQ/JJREyEgNu0TQ0tXvW9CONJd7jJA4xIaS17JkpfezqJRyOfjS4KJ+LDqK2lnRXMr+E2LZjmh2MbieFZMCqNXrE0tzXOLgLuTHaUrFkEQtpbEqkNEd/AtOsp9M0dakqJ6HjFsOIoMm61kemiN0Qkt4YFQkQq5ex7ilU3V8PVvb7TnxT7jUf6VhtjY2h4QNmcrE9GoxKsJBetL82KT+3WvG5s1inYm3R6nRNXxgoWwChUMLWCTFQc6IvsoQjUb6V7hxuxrIXaLHXqg8tbQ5RkkKYdQyZrJfN0sYCj7pTbSY+RRvJk14GA3OUikqcgMJcJdiK9x58ILryJAvxWK3Ykl+goIG4VOrUAcYh00XM7jr5WlgltRxF0ycWcrt2vKFDuXBfm3JhkDd7fPplBMBgrXBkv6aw29B/pQW8Jc+8+wTCRVYlKVg8WxMRIGH2rR2LqGYQbhxr4UZ3hG8swLntUebgxqKdENdNCD58euSmfLb9yeQ4a2ZmPjXFpkot9F+ebdQ8DpNM5513CHw5RnZsP9vSHFF1rKZeuzMZwuNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(86362001)(38100700002)(44832011)(38350700002)(508600001)(8936002)(31686004)(4326008)(31696002)(66476007)(8676002)(83380400001)(6486002)(53546011)(16576012)(52116002)(2616005)(956004)(36756003)(26005)(186003)(5660300002)(2906002)(66946007)(66556008)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHpDOCtXcGNubVhvRXJKekpETGdGMDNLcmRlajh0Q0luekZZMHlpTnVTRHhI?=
 =?utf-8?B?MmkrcG1ZQmlkd1ZwM1hlYllPbGdvczgxem5xeWVqM0gyK25GUS9UcU9oZTla?=
 =?utf-8?B?ODQ3c05pcEw2M3JIWGcrWlZDN2FvQzd6S0Z0OEJSb2tacDh6dmVObEZlYWtP?=
 =?utf-8?B?VlZESDBheTRRdDhZaG11cjZweUFOVVQzaEY1RS9YUVpJYzNYYzdnV3BlSzY1?=
 =?utf-8?B?OFFCd2lmNEVjdXFTQ2syc0FaWGUxVHhGei9YRjM1dmY5dDAvNDhNTEFZbnVE?=
 =?utf-8?B?TGYvWlVaUXdLRzFFbitvU2dTaXAwT3NLSVlqRWExcjV1R3pGbDQrcmRuVzhn?=
 =?utf-8?B?ZTZsMHJibEdLeDVZTTNQeGs1RWhzMkZaZTg4d0dsVGM1bmlmVWFXd0VrS1R1?=
 =?utf-8?B?QXNuazBGR0IwZGt0N1U4TVVDRkFQeUVSaXZRODVpWW5Lb1l4R2QvSjFaU3k1?=
 =?utf-8?B?ZjR4THZOZGJGWVZtMlVhdDBYR1R6STBXbWdKc2FRL1ByMWpOYi8rZ3ZZWllw?=
 =?utf-8?B?NDJXQmgrU1J4c1B2eGxiNzkzZHFtWmhDWDRSMUdwSFZBVDlMdFRZQVlIejFt?=
 =?utf-8?B?b3dtSEhnQzFXd3hkSFdmM0VDMXc0cmNHckpOaWRWYnBkTHNMM1J2SmhhNHFq?=
 =?utf-8?B?cHBKeExmb3FBVG5OamFhVjdQUnNoMW5hcTh1QlFFZUNpd0k2bS9UUkZ0bGRM?=
 =?utf-8?B?TU51RkpYVlNwTHI3by91T0dQUlBLK29NakZvcGpvVndSeER4U2h0Q1o1Mmtp?=
 =?utf-8?B?aWJhRjVqdTNxTThvbnpPckZoQnp0N3l6b0pIanhyd0RIMmc1NzNBdDRjMUtP?=
 =?utf-8?B?L2xoMk82emxxaXFyYUwxOG5ZQVNaNmNSdnVmLzZMMWUweW9RMUdGV3kyU3pC?=
 =?utf-8?B?SFc1ZitrM2VHbzUwS01YclRraDNkSE5PUHhpaldURnBETU1lbkEvc0JSbVA5?=
 =?utf-8?B?UnQwQi9keUlMR2FQZjVaU08zUzZUQXFlczBXcGVkMGJFcitTWmR6LzhnRS9s?=
 =?utf-8?B?S1pQUkl2NHJjMWVzVWdEV3lTWXl5bWdiOVd1TGxyemxBYkhVSW5GL3FzUFVW?=
 =?utf-8?B?K1hLUzVHbFdnMGcxd3lKRTF1ZVhzcnNSbmRJZGFjcDJ3ZXM3RHhEZ3UzTEQ3?=
 =?utf-8?B?UERGZ3VKZXU2MStHdzdYdkdKLysveGJEOHhKUS9DRU5SY3pId3BIQ3o0cVFz?=
 =?utf-8?B?SUZCLzU3OE1BU3JzUWdVVVNpcXdjbE1lUVlMZ0RzUHl5bkcreDZxbG4xY05k?=
 =?utf-8?B?Y2NSYTVFeGQxR0JlaDNtMDl2Z0ZzaGhxRjdnRlZ1WmNBWlpmYjRYWitvWG1N?=
 =?utf-8?B?M3B6b2lNd01JckYvMy9BSHJJWHNIMGhybXVZRVorRGpEallDalZRRk1lNWY3?=
 =?utf-8?B?aUhnWjdFbXlrTUZneDByVTUvYjlTenROM0V0TFZLSm5vMmRCdXJLdHV6R2RC?=
 =?utf-8?B?RnJPY2NtTXZlZCtrS29TQVF2WmFvenR2R0s0S0JmM09nNnFDZUI1cHUxcGQ2?=
 =?utf-8?B?TXp5RnFGWGQ2YzlLdFFRa2hLSWZHZlN2T0xCdXh3TlQrUEJFNnk3cHJqRHlk?=
 =?utf-8?B?N1NGeEZMTG52bHFzU0ZzRVBRRXlkak5qd2RXTHlMKy9acVI0V1NaVnQwWlp3?=
 =?utf-8?B?MnFVMDh5TE5STnZDdVRqeXNISHlReHdBc3p2SFJkOGF3KzZyazAzc0dSN1Ns?=
 =?utf-8?B?Q3hTYXRMNEQzcFVNN1BEWWw0aEVNeFV5NlVqQmx6dXdpS1dNUlQvZWZxZnBi?=
 =?utf-8?Q?+jqtZMyVu7EzScj/CLX1LbgVqUP5CSyS1dEvnNn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c6c113-64bc-427c-3ecc-08d981f6c33c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 20:38:28.8313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btmg9SujM458wCScFu4EPaJA4FBQetKWGBvkwllgUY1HIFsoAhagZkZps07/oUkzR1CasWC861gvIGMe8sMFPuEDIXt6OpdybsaimF1A5aA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2872
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109270138
X-Proofpoint-ORIG-GUID: suLY7wgXvZaoqyieDAulhoL9SUX3Cd6K
X-Proofpoint-GUID: suLY7wgXvZaoqyieDAulhoL9SUX3Cd6K
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/17/21 6:30 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Transaction users are allowed to flag up to two buffers and two inodes
> for ownership preservation across a deferred transaction roll.  Hoist
> the variables and code responsible for this out of xfs_defer_trans_roll
> so that we can use it for the defer capture mechanism.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_defer.c |   85 +++++++++++++++++++++++++++++----------------
>   fs/xfs/libxfs/xfs_defer.h |   24 +++++++++++++
>   fs/xfs/xfs_trans.h        |    6 ---
>   3 files changed, 78 insertions(+), 37 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index eff4a127188e..7c6490f3e537 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -232,23 +232,20 @@ xfs_defer_trans_abort(
>   	}
>   }
>   
> -/* Roll a transaction so we can do some deferred op processing. */
> -STATIC int
> -xfs_defer_trans_roll(
> -	struct xfs_trans		**tpp)
> +/*
> + * Capture resources that the caller said not to release ("held") when the
> + * transaction commits.  Caller is responsible for zero-initializing @dres.
> + */
> +static int
> +xfs_defer_save_resources(
> +	struct xfs_defer_resources	*dres,
> +	struct xfs_trans		*tp)
>   {
> -	struct xfs_trans		*tp = *tpp;
>   	struct xfs_buf_log_item		*bli;
>   	struct xfs_inode_log_item	*ili;
>   	struct xfs_log_item		*lip;
> -	struct xfs_buf			*bplist[XFS_DEFER_OPS_NR_BUFS];
> -	struct xfs_inode		*iplist[XFS_DEFER_OPS_NR_INODES];
> -	unsigned int			ordered = 0; /* bitmap */
> -	int				bpcount = 0, ipcount = 0;
> -	int				i;
> -	int				error;
>   
> -	BUILD_BUG_ON(NBBY * sizeof(ordered) < XFS_DEFER_OPS_NR_BUFS);
> +	BUILD_BUG_ON(NBBY * sizeof(dres->dr_ordered) < XFS_DEFER_OPS_NR_BUFS);
>   
>   	list_for_each_entry(lip, &tp->t_items, li_trans) {
>   		switch (lip->li_type) {
> @@ -256,28 +253,29 @@ xfs_defer_trans_roll(
>   			bli = container_of(lip, struct xfs_buf_log_item,
>   					   bli_item);
>   			if (bli->bli_flags & XFS_BLI_HOLD) {
> -				if (bpcount >= XFS_DEFER_OPS_NR_BUFS) {
> +				if (dres->dr_bufs >= XFS_DEFER_OPS_NR_BUFS) {
>   					ASSERT(0);
>   					return -EFSCORRUPTED;
>   				}
>   				if (bli->bli_flags & XFS_BLI_ORDERED)
> -					ordered |= (1U << bpcount);
> +					dres->dr_ordered |=
> +							(1U << dres->dr_bufs);
>   				else
>   					xfs_trans_dirty_buf(tp, bli->bli_buf);
> -				bplist[bpcount++] = bli->bli_buf;
> +				dres->dr_bp[dres->dr_bufs++] = bli->bli_buf;
>   			}
>   			break;
>   		case XFS_LI_INODE:
>   			ili = container_of(lip, struct xfs_inode_log_item,
>   					   ili_item);
>   			if (ili->ili_lock_flags == 0) {
> -				if (ipcount >= XFS_DEFER_OPS_NR_INODES) {
> +				if (dres->dr_inos >= XFS_DEFER_OPS_NR_INODES) {
>   					ASSERT(0);
>   					return -EFSCORRUPTED;
>   				}
>   				xfs_trans_log_inode(tp, ili->ili_inode,
>   						    XFS_ILOG_CORE);
> -				iplist[ipcount++] = ili->ili_inode;
> +				dres->dr_ip[dres->dr_inos++] = ili->ili_inode;
>   			}
>   			break;
>   		default:
> @@ -285,7 +283,43 @@ xfs_defer_trans_roll(
>   		}
>   	}
>   
> -	trace_xfs_defer_trans_roll(tp, _RET_IP_);
> +	return 0;
> +}
> +
> +/* Attach the held resources to the transaction. */
> +static void
> +xfs_defer_restore_resources(
> +	struct xfs_trans		*tp,
> +	struct xfs_defer_resources	*dres)
> +{
> +	unsigned short			i;
> +
> +	/* Rejoin the joined inodes. */
> +	for (i = 0; i < dres->dr_inos; i++)
> +		xfs_trans_ijoin(tp, dres->dr_ip[i], 0);
> +
> +	/* Rejoin the buffers and dirty them so the log moves forward. */
> +	for (i = 0; i < dres->dr_bufs; i++) {
> +		xfs_trans_bjoin(tp, dres->dr_bp[i]);
> +		if (dres->dr_ordered & (1U << i))
> +			xfs_trans_ordered_buf(tp, dres->dr_bp[i]);
> +		xfs_trans_bhold(tp, dres->dr_bp[i]);
> +	}
> +}
> +
> +/* Roll a transaction so we can do some deferred op processing. */
> +STATIC int
> +xfs_defer_trans_roll(
> +	struct xfs_trans		**tpp)
> +{
> +	struct xfs_defer_resources	dres = { };
> +	int				error;
> +
> +	error = xfs_defer_save_resources(&dres, *tpp);
> +	if (error)
> +		return error;
> +
> +	trace_xfs_defer_trans_roll(*tpp, _RET_IP_);
>   
>   	/*
>   	 * Roll the transaction.  Rolling always given a new transaction (even
> @@ -295,22 +329,11 @@ xfs_defer_trans_roll(
>   	 * happened.
>   	 */
>   	error = xfs_trans_roll(tpp);
> -	tp = *tpp;
>   
> -	/* Rejoin the joined inodes. */
> -	for (i = 0; i < ipcount; i++)
> -		xfs_trans_ijoin(tp, iplist[i], 0);
> -
> -	/* Rejoin the buffers and dirty them so the log moves forward. */
> -	for (i = 0; i < bpcount; i++) {
> -		xfs_trans_bjoin(tp, bplist[i]);
> -		if (ordered & (1U << i))
> -			xfs_trans_ordered_buf(tp, bplist[i]);
> -		xfs_trans_bhold(tp, bplist[i]);
> -	}
> +	xfs_defer_restore_resources(*tpp, &dres);
>   
>   	if (error)
> -		trace_xfs_defer_trans_roll_error(tp, error);
> +		trace_xfs_defer_trans_roll_error(*tpp, error);
>   	return error;
>   }
>   
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 05472f71fffe..e095abb96f1a 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -64,6 +64,30 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
>   extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
>   extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
>   
> +/*
> + * Deferred operation item relogging limits.
> + */
> +#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
> +#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
> +
> +/* Resources that must be held across a transaction roll. */
> +struct xfs_defer_resources {
> +	/* held buffers */
> +	struct xfs_buf		*dr_bp[XFS_DEFER_OPS_NR_BUFS];
> +
> +	/* inodes with no unlock flags */
> +	struct xfs_inode	*dr_ip[XFS_DEFER_OPS_NR_INODES];
> +
> +	/* number of held buffers */
> +	unsigned short		dr_bufs;
> +
> +	/* bitmap of ordered buffers */
> +	unsigned short		dr_ordered;
> +
> +	/* number of held inodes */
> +	unsigned short		dr_inos;
> +};
> +
>   /*
>    * This structure enables a dfops user to detach the chain of deferred
>    * operations from a transaction so that they can be continued later.
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 50da47f23a07..3d2e89c4d446 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -112,12 +112,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>   #define XFS_ITEM_LOCKED		2
>   #define XFS_ITEM_FLUSHING	3
>   
> -/*
> - * Deferred operation item relogging limits.
> - */
> -#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
> -#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
> -
>   /*
>    * This is the structure maintained for every active transaction.
>    */
> 
