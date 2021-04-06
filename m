Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19849C433ED
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 20:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C88EC613CF
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 20:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242670AbhDFUIG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 16:08:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55662 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237478AbhDFUIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 16:08:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136K4KfV112335;
        Tue, 6 Apr 2021 20:07:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/A2NLXsH+RbM1awDJlmHFXJZhVWL/WaZcKTHPMMlJAA=;
 b=HO6tiitoLx5ZV/oHtsX3NKAOAKXVS42neVI5Sf7d/cXTV2B1IAePCXUGaYuqkDVNVDjS
 O8Hr75jtwtgsO/Q2C3mUnI3mYbh5o+BKJcWDL7owcdqku64nYpsrF6w6LPFCTIPVSifa
 Kh3nRqPwZm9TUp/ocnoBUxx/UwQXEZuVTYDzQKKBVBRp7VcctVCMXIMHiJNEbXomrIwU
 uVXH3FEZTwxutWbY81bKkuhEzovtl07tLUvb6skOqvLcmZDjNDrj7s0SiY+RnTq9wNdK
 8wMgwArG1p7TzI6FMMDOlQyIXzfQOgoKWaemqjlWtWSZr8ufMmciAMlfGmLo41qvMouq Yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37rvag8d15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 20:07:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136K12f9149221;
        Tue, 6 Apr 2021 20:07:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3020.oracle.com with ESMTP id 37rvaxn7ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 20:07:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONjX0inix9LylNg0nSn4136H8bQbGPs+9cJGMCz+QOS10h9rXxU+IlHnId2c7TVI/S1CiS+OTMCx8v/0MordnWF/Xxi5OiOURcqJsNCq+a992jMkomoGT/h68GG8mIrGfFbV3bBycY94MnyO2PGX8VKs20595768ItN3LAdf00Qm5KWQ4uObjHV3v/9hwvJqsC7e2LXi/hvEXhNjfb+34lTg0W1WUmkqaAVXI/nmbbGvwBuKs+nR2YvZBjRROUySlrseROdyXxtzy2+O4dU2gmPcj69gomb8DC4hI2Bw0hdoh+okeezzF0fe9cXC6HoVxoQMFNF24hz9zaTBug1XUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/A2NLXsH+RbM1awDJlmHFXJZhVWL/WaZcKTHPMMlJAA=;
 b=Czs53tYTVPSLLk5pg6dpBuFU8MRqyOH8ZikUUx1rUrVAWYB5CN5c71pvG65Ct5wdv2cM9JpnWODx/H1yvtYGDMOYtuvq9prgLv5XI+bDA9x08cfif+6zTpGtfKVVHU3TrfV6xEhySbmFnnyopgamEMMC9e2vbcLyu25/Ki7rwBR3XyqOWSOX3iwzHv26AV8jhuu+01tHBgU066t5/RP6wIvqTknYCY2UjDVb8kBEnz3TYrbPl62W/46nFuOVYLM4Pu7nateiMO7oeOH4UU0+aCX6QaAPMhU7cY9E+8XyVxkX2q+WIQ/aBhWf5b6qm+LPBwYomNtbafM9fARRAIr1Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/A2NLXsH+RbM1awDJlmHFXJZhVWL/WaZcKTHPMMlJAA=;
 b=D2GiX/f3D9ZQ9iRpO3XnkME7QYlxa1IEbq4yAmQ5dOVSS/2+l54OCqtWuaiFdqPAhHBI09X8DCrd7EBhSn3p7nNnj+2IlQ8Fb1QEwWgWOFV67CMEwPJ1M5Wzx+fFRenjIOgTxjuRzHzV/7v1akXUllvlPmKKCoSegKye84em3Ag=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4051.namprd10.prod.outlook.com (2603:10b6:a03:1b1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Tue, 6 Apr
 2021 20:07:53 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4020.016; Tue, 6 Apr 2021
 20:07:53 +0000
Subject: Re: [PATCH 3/4] xfs: default attr fork size does not handle device
 inodes
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210406115923.1738753-1-david@fromorbit.com>
 <20210406115923.1738753-4-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a46f7ab0-7875-7ee5-5709-237446780e52@oracle.com>
Date:   Tue, 6 Apr 2021 13:07:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210406115923.1738753-4-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0172.namprd05.prod.outlook.com
 (2603:10b6:a03:339::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0172.namprd05.prod.outlook.com (2603:10b6:a03:339::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Tue, 6 Apr 2021 20:07:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 600ad941-cfc7-45e9-ea84-08d8f937a97e
X-MS-TrafficTypeDiagnostic: BY5PR10MB4051:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4051358024F57B60D1A7F4D095769@BY5PR10MB4051.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:285;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ulqcpX1OAVtIXy9lkQ+ZlqW8epdpve7RkneoA6hY9aVtVjRx5Fia+AYpP79E9hZtZgHtioJSmO/KINMhGAVTkFAp0ZlXZIPRvLdsaLvuvrF9PaxbsMOof+s7UHp0vi4XApKrw9fU0k4TLnqkZYW/Ah5y33OU1mKwmGtKd2TsrrskKhKLU/fDQjv0sj+ABDTyD3r2mhnGxk2jPGyKON4aJW9HzVFgHGBm54dhYMfi1elqg6GeurdMKdhr4ITSWlneraACCrCVEJ08KkaQDebPNJhMce3aYwlJ6RPZ7hshBDbnv9jWPIiQG4VX+IyMvz3sskyixZ8zjkCRf6wDK5vgOzSfBvYBdckCf+DN/4m2JT8kQWy9x+K9m8chd+EzQk8/Dl4goTKSqxkeRoX/7XXBZRdE1l1tLZMRDbqYGvh/YlTufvb3awHuAuj8DMFi4s+Qt/GvWCyNTfkD9tYGoV3lLzUMCPs1baFX2EcIWDFhYCVPbNWjckk/FFa+HkIjP/f569Gwia26ATP2WjD1Dg2mALhteYOzwA6mwp2NzVtkC3UD5stAIgm/b4y1hg6J+chg4J6ggd14QPsYDUEJ77hc5noKHkji90JgC1SQAUtQDTrB6wliPFeVKRVfaPw0Ri8ZZteNhA/lvW+GvT3/ZJ9WIwsDBQ1EUIeQYGt0Mssy4KH0OyF2hXGqIXto/Haz3ZnlXbSDBP+Nf/ZK5/he8SOsRDC4ZXKun+5X7WGGh5BrjTppAkCFsqBLhK8hkicC0mR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(136003)(396003)(376002)(53546011)(6486002)(31696002)(66476007)(66946007)(66556008)(5660300002)(31686004)(38350700001)(8936002)(478600001)(52116002)(36756003)(8676002)(83380400001)(38100700001)(16576012)(316002)(2616005)(2906002)(956004)(86362001)(16526019)(186003)(26005)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SVFrSFR4NU52SEZXd21YS0pTbFRNNEV1ZWdQdmFvcG1XdEdwQXpaS0VIdXN2?=
 =?utf-8?B?YWdWWXRnVUlFU0M0S1BITlN1RHptM1BlM2xVaWtPRkxFU0dEeHpTdHhaU2hE?=
 =?utf-8?B?UUszOGNDZEFTRkpFR2JGWXIrV2U2UUpDQ1lSdTY4RnVVOXljY3B3dWhEalQz?=
 =?utf-8?B?bXB4TzdXTHhvZGhOY0N4Q0VQY09FcGNvUk5WZFZrNHl5WWlvellRK2RtcFZy?=
 =?utf-8?B?bGx1cE9rWXY5SlVwTzY5RERZbFJoSkhpMXJpWEtkMHVJTloxT2pOcjFEamE2?=
 =?utf-8?B?RmpDRmptNTNpVTZHMjZtN1BOa3FuSU5Fb21ZWlVrVnY2aTB6dS9wNmE3aFFm?=
 =?utf-8?B?UFRLNDdYRWtpQkdpZkhUVjBPYkxEV1VTMWFlTmEvNkxZM0ZNRHErV3diekNr?=
 =?utf-8?B?WWx0OFliNC9yUis4VlE1RGRlZHlNTGwwY2ZIUVhhcmRtazAwQkVJbWJ5WDN5?=
 =?utf-8?B?U0hZaklJYnRZMHZTMzIzNnA3U1N5ZkozeTU0SktuWXhiVXBIRzU3MHQvWWRF?=
 =?utf-8?B?UjA4YndtMkwrNTQ4R2liVXlxcmZMTytUTGF2Smk1dXFVei9nczlsM2JybXhm?=
 =?utf-8?B?VHNxZmFJWjVmcTlvbGdoOTBFUVcwbUJWNGg4ZGlIMmUyWE9KSHlSWkh2U2FS?=
 =?utf-8?B?RXVBYjI2OWFTRm1lWHJlVFZESUFxQzRSdnFOUUpEVXd6K0dpQ0xvTHpRV2xh?=
 =?utf-8?B?K3RTUGlmKzI0bjg4RDduRTFUcFVPNGdMRzlDUjlyMkEydUJUZGoyNjdneCtp?=
 =?utf-8?B?akVXNmoxd045WUxBdEovZWwrNFBKK1NxaThLNGl3NmluWjhjeHo5ckxiUTNh?=
 =?utf-8?B?NGUyejBKMWtZRUMwUU1MZi9NMlhkTlJkRmJjbURIOGJXTit5V2JBSUtUYzBK?=
 =?utf-8?B?MjJKcUl1VU5GVWl3MkVGSEFodlBtNmovSExRMWF0WnhmaUU4Q3E5SktRYmEz?=
 =?utf-8?B?bXlaOVhkbzVxa2ZBcHRVamR3ZDJMVmRiOEUvdHAwSzgxQkZqdTdiQWhDSUF0?=
 =?utf-8?B?d3I1N3h4bEpZZkQ2R3hzdThMclk5eUJjY0t0RTN6dnZRdDZLblV5QURuUjFW?=
 =?utf-8?B?U2krenpLaTVzcmZJNktDSDBTV000WERqczkvNkdFWENBWVNGUDI5cGw3Zmhj?=
 =?utf-8?B?Vmlud1NndENwS0VOODZObFBzQUV2Z0ZyckRjQitkYlRTTUtpL0xncVIzRVZW?=
 =?utf-8?B?M2RjYTlSNFlGbUo4SWxHWGJxWk9QempFb0VVN3VHbFVBdG1DRThNU0hLTklo?=
 =?utf-8?B?RC9RZ1FEWGZiR25Hd1ZPTWR4N1ZYTzBoRGJrQUZxSjhzZEVkMDVaWkxSc0Vh?=
 =?utf-8?B?L1Vud21JNzBXMkRZcElia0xOcFJVVTRLZmkxajU4U1pncjFZMStBQS9LUERh?=
 =?utf-8?B?RGEyblo3eHNUdVgzb3ZyckE1eXE0N1o1eHllcVdqMXZENDlJMGpBMGFBWkVZ?=
 =?utf-8?B?ZWRpV3dtWHFDNmpwNWhZMGdDN1JNTHZDb1hjd0tJV0hPWDB5c3JKZSswcFRQ?=
 =?utf-8?B?c21xcXA1OFh5bnRmQ0RjaVp2VFlGNkdiWjZsc0o5amM2dUlZQUF3Qmp1d1Bs?=
 =?utf-8?B?eklYckFLSjNtakZUZGM1S3QrWFRhQjM0VFhnUnFja1NNWmlrcWIrK1ZYR1Qx?=
 =?utf-8?B?MXZ5cGFvNTdtV1lHWG9GaXdac1p2WDRsUG9KVS9zcVdXVkZjOE1FSnNURHBZ?=
 =?utf-8?B?cHg4eW9BUzJwWEtXWjhDL29mKy85TEE0c3k4ZVRzU3R2UU9SNkNSWGs0amht?=
 =?utf-8?Q?C4KX/j+wcUhU9TD1SXxLmx9vqtNI0YstBjpgYSt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 600ad941-cfc7-45e9-ea84-08d8f937a97e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 20:07:53.6165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ZiBrgEIDxHPQLFDfoBu2HDGwqLs0V9uuQpG9xbOZXWYAXrMfQeBfoqh3vliqtJp6J0JTCDkPOM/5j8/IzQ9Qjlwd7/L2GZY5zxPTuQUTeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4051
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104060136
X-Proofpoint-GUID: GeYgtnQEe35oxrd4BpW6TBbH_vXG1m6B
X-Proofpoint-ORIG-GUID: GeYgtnQEe35oxrd4BpW6TBbH_vXG1m6B
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104060136
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/6/21 4:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Device inodes have a non-default data fork size of 8 bytes
> as checked/enforced by xfs_repair. xfs_default_attroffset() doesn't
> handle this, so lets do a minor refactor so it does.
> 
> Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Looks fine
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_bmap.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5574d345d066..414882ebcc8e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -195,6 +195,9 @@ xfs_default_attroffset(
>   	struct xfs_mount	*mp = ip->i_mount;
>   	uint			offset;
>   
> +	if (ip->i_df.if_format == XFS_DINODE_FMT_DEV)
> +		return roundup(sizeof(xfs_dev_t), 8);
> +
>   	if (mp->m_sb.sb_inodesize == 256)
>   		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
>   	else
> @@ -1036,16 +1039,18 @@ xfs_bmap_set_attrforkoff(
>   	int			size,
>   	int			*version)
>   {
> +	int			default_size = xfs_default_attroffset(ip) >> 3;
> +
>   	switch (ip->i_df.if_format) {
>   	case XFS_DINODE_FMT_DEV:
> -		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
> +		ip->i_d.di_forkoff = default_size;
>   		break;
>   	case XFS_DINODE_FMT_LOCAL:
>   	case XFS_DINODE_FMT_EXTENTS:
>   	case XFS_DINODE_FMT_BTREE:
>   		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
>   		if (!ip->i_d.di_forkoff)
> -			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> +			ip->i_d.di_forkoff = default_size;
>   		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
>   			*version = 2;
>   		break;
> 
