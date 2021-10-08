Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F47C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Oct 2021 17:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2707460F41
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Oct 2021 17:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbhJHRv1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Oct 2021 13:51:27 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56606 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231217AbhJHRv0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Oct 2021 13:51:26 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198Hcg4b026095;
        Fri, 8 Oct 2021 17:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=73Ws2x11RbX6ErhlV47VsRdVCDjzp6M1TXue87e2U6Y=;
 b=DdYHyWkDPCDyMrmfIpByCfar5kpyfWY06V8zHDLrE4m1iIau47muVDy7mRBI/6+XzWFC
 aEqD7ZtOkLwH2XGdy+Nx3qxc4R+C7NrhOnf2wZmhdZaxysmHAyANxj+Mvc5SVJfFMdCK
 7h9F3y3mb/skOwSo8DwbHIJM8ouH+vyA/mPKcFMqXIgVKnbuPIqLCshpQtstQ81txTeb
 HTkF6HTpl70dc+h3FiEFhvvPle6ZhWkUEzEHvMAckFj5ZvmN7uA6fXTGvKJ6+lp0opwZ
 7UauwnEov6ZfTcwQPJ1lodjAWjqt0O9cLFouedfZLhPjKGo3IvdDH1QjcRL1ByJ3AI/U NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bjrbu8xvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 17:49:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 198Hio1Y052092;
        Fri, 8 Oct 2021 17:49:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3bf0sc4ac2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 17:49:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAVUeTsGf4FkcVqUHj245grgbL741dU9y8Xm1BvOAlpV7hY28uEjp/ZHBhFVbg7q/4WmLxWCjrKf2wZE/F3bhVcpjLQl9msMfO4HA2j+xWs5PES7aiqVVb1B26V/mZKTeBl46xnN0UBY3fy2ErcvEF6aMJWAE0GdJXdUSJ1zpO/YNRIYZiSYshMu4pWtUMNHYbV16whTn6jsHtZuKFuFGbeWf6tmsE1lJva3cTlnpxrhL5M3RSRscwCaaTwYeWz7BqFoPbBR+JpVTQVovMPJeHxaSNlAUJHIa9vW1DjqbR/pmc0duJ/fLiZG0su2klD7qKM6LPldpCKRFTy7TsR4ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73Ws2x11RbX6ErhlV47VsRdVCDjzp6M1TXue87e2U6Y=;
 b=AsgETzR0qfp0vZnFuzg0RXVhaiuUK132keBYf1XlbDMDR7pw+9zkoWxj4mSwZtNczW9V9YOr9exrlRYXbQxVgRJgw1RdF6KnqeuOgIXvyVOlPGh29wnLIY9R33WhU18GP5Zv6o2IH50Pg2Si9DlEjSNq2xGYB2jiz7nCSp1j3aCZcssVAUOi3wjGjryQVoxjH5J2Z6EumkSUmAKSGRRUBbgiauIITnv8D74QQrq1SuVYOmfHOGGNr/4i7n68p2uZy5rIbBBcVF1EHMAUkyFzB1YWm0tPxolh/kopFF9oZUN76W4Nii9SQ6BQgJ1YiJJYGJfydzv6I0mow8ndr3GrNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73Ws2x11RbX6ErhlV47VsRdVCDjzp6M1TXue87e2U6Y=;
 b=XUpH+o+amFTKxjMg65+sshHz4KjAAf6ZibirbwmKBWV8ieoNWtK1bilEyVDio0egqKnK2SancJplhp7nRpe3nwlEQgAXbfQvJjCAPmtily316eSVOxZi3r4H6DmqEFFd7U5xmklafIyftYMrjtQ9ieWW6sg2ouGgTr9U6mjjQHE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH2PR10MB4120.namprd10.prod.outlook.com (2603:10b6:610:7d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 17:49:27 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::f08b:b088:a90d:1ff4]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::f08b:b088:a90d:1ff4%9]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 17:49:27 +0000
Subject: Re: [PATCH v2 4/4] common/log: Fix *_dump_log routines for ext4
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20211007002641.714906-1-catherine.hoang@oracle.com>
 <20211007002641.714906-5-catherine.hoang@oracle.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <9046a560-e064-b009-6867-b9e65d7296c7@oracle.com>
Date:   Fri, 8 Oct 2021 10:49:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211007002641.714906-5-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0300.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::35) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR03CA0300.namprd03.prod.outlook.com (2603:10b6:a03:39e::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 17:49:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3d6ec2e-00a8-4411-9b37-08d98a83f8a5
X-MS-TrafficTypeDiagnostic: CH2PR10MB4120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR10MB412021BD1CC7AC7B63BCE15795B29@CH2PR10MB4120.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XQrKERfFhaoTmobvWsd/XbnhKZ4aSxzB6BignhgmJdKp88y0oi9UlRMfQrsDvkqwF+bUkoSnxd+rR3VE6/QiJFRpUi4pCmGLtULUcJwQae7SKDb+Tvv8MJ1fcB/k6gN0l8jnvTIr1nx0SfelXKrRbERs3rwKZ5QktmBRqsvxqp11tLroZCBGrlGQyzbKexGwrMjDAh095T13pMjLSE37qQdUFYjrf8itAx/x3jhESFvUoz95caH+Ps3f8lmdROur1cZg1JshCJQPXlhq3ixzCq77KgyCdpWilxDRDsk/A+QuijynVsJ/KZZATXaRt+tNWVOW/xrFkHVuI7UKUfeFm7Oo7q08IXLImc3En54nmVRZTvSL40hfz283FAVK2T1ohKUJ5yF4xWmT6DZ7gGEITJvBV/JopMWpFz0emjR88bc3EdYOmfWh18KSUS/XHG4u8rchxm5V5GDHLrvPUlgHyGXpzDI/qVmmcC/7CDEqEKKb220+o+nWpf0RasSe04MMV6+bwPnfoPpNDwBxwya8aejYVo6muLssS/NxUCe+eJnEMk9lebfKxfMnC/CfzFeFMjwqL4RCfz6pxkyoIfEOdbj+VXJ1sf8LbsFovlrkvpP4NlPajVgfNCzA1FNY0ahux7NbeWvm7jtllAzVZ4yybuZ+ci+hgAP0filpQnwpCUq9KqBqj+BkRRr3B0OKnaq8vACNJFoeTkZgwrSGj1ehpZnMxNU36Imgd+8QdO4mzidwYhN6nDeJVfAAmJVAfYEa8PiCaN/FAFFskX2k1QcUvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(83380400001)(5660300002)(2616005)(66946007)(956004)(66556008)(66476007)(36756003)(86362001)(6486002)(186003)(44832011)(31686004)(2906002)(38100700002)(316002)(4744005)(8936002)(38350700002)(6666004)(16576012)(8676002)(508600001)(31696002)(450100002)(52116002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGRsaEhLUDlyQ1JCSXllcy9KUGxnckdmZ3M4UXgvblpXd3duT1Nrc3ZlYUFn?=
 =?utf-8?B?c0k1M0FHSTBwQmc1bytvTVBVVDhJRkwzVUFQdlUxVTVvUkp1cTNsMFM3WlIy?=
 =?utf-8?B?YWpJSkVUTndGVkd2WlBsMmJWVm9Yb1NzY3ZlS3BMa01pSG5RMTIxeGUvOXpU?=
 =?utf-8?B?TjBNbjhjQVJ1T1p3VTZIekFZQWVrNGNFVVhEQkNsZVZaOVBvc2tXVUg1ekxH?=
 =?utf-8?B?bGxKNzNqNExRRFRnNm9zanMyK1RwVEkrUEFoSEtpY0xCOVJGTkVtOG0wbXJC?=
 =?utf-8?B?cWxRWk9hU3ROcXBlVldiWkhlQzZWYktObGphbnBJQWx4K0FFRlpFeWl5UlJr?=
 =?utf-8?B?cDU2R2t4dngveE5YbHhud1ZXaHlJNFh5WUZPMWFmV2pzYm5pWk9RRm5YYlhQ?=
 =?utf-8?B?aU80azNkcFFjeXpKM3V1MGxGVWRQYmFmYW9UT3JpTExxNFRGTmVmU05BcHBl?=
 =?utf-8?B?Q2kvNWRweStpNm5Fak0wcjczekZVbW8yQU1kNlkwTDBXcWVIUEI5aFhRT253?=
 =?utf-8?B?aENvNjRnRTJtZWxvTFAzdU9wNHk5VllLTXlQajJuR0NtOTBXNWZRNDRRWEJ0?=
 =?utf-8?B?RjVJUm95UkxJU25oaEZTU3RNWHhMaEliYTNWR2JQc0xxcWVsUTJHQSs2ampI?=
 =?utf-8?B?eUQxUGkvYkZmTGpQWDRUL3NFeXRaYXMvQ1FKZDNWc0s5QW5VZWJQeEtqbjJt?=
 =?utf-8?B?UmlGaHBTRzhRTGdIVTNwSERqR0JiM2xiSG43aVl1R3NRakhCRFBIcXRwUWo0?=
 =?utf-8?B?dXlvRUNUdnNLeC82djBrdFlpaVY3YUNVOFdQUGZkaEVVMzhXVjVKSFhudkxN?=
 =?utf-8?B?YmpaVzloVFBjOGp5ZXc0ZDMvVVdlN1BVUkpXNFhhVGRFRm9yVytheTVzQnc1?=
 =?utf-8?B?V01HNUNKQjlKMjExUVliTWlMenJyMXp4blJWT2FFKzFzR0szTEtnTGZXTC9p?=
 =?utf-8?B?emZwb05zTWtkUVpZNnU5OVR6SXcrK2RxZ041OThyMEQ1YU5uQzdQRlRILzFl?=
 =?utf-8?B?SUZCMGRocG10QlIrMFB0QVBXckppT2dvMVBOblVYRWxEc1FPd1FJTFNPMVht?=
 =?utf-8?B?SzB2b0xNTmdjZ0hTekVGT3lJcXEzVVg5THk0TEpwWUtjTUZlcTVRUjNweDhS?=
 =?utf-8?B?WTRiaTJxSU90b2wrM2w4Tis2YzNMT3N1OFQveEFBQlNIMjg1UGNBbWxuVDJx?=
 =?utf-8?B?OWhJaEVPRFdxejVkWlFYS29HNXlsWnBkajFDclJlZDBObjJxY2VOeURJaEtR?=
 =?utf-8?B?aFdKMVJ2dUtwTkRhVEpTUTVVUXVCK2NtS2J4c0QyS1gxbXNyOHlkbHcxYisr?=
 =?utf-8?B?M1NwZEFuN09tQ3RVV1haQnl4V0J0cno1NENLclZLbkN2ZjdqWk9oaXI0bmQ2?=
 =?utf-8?B?WTRWckU0N1Z0NlBLakcxSStDOHVuWUpsQ0huSER1cVhHTEhhUGhIcjgrTHlj?=
 =?utf-8?B?YWpuek1ySjVHQTJHVi9sbWh5MTdFVDkwb2IyMWV1ejdLenpGSlVoaUNqMTJ0?=
 =?utf-8?B?aHp0ZkJSNCtxN0Z6L3ZFRFMvaFJOMlJiTnFJL3JEYTcybVJnNXI5dHZmMkwz?=
 =?utf-8?B?SlFCcFBaTnFSeDgvWU9tRHN5NGZpZnVIN2JoOG1pcEhHSFE5ZnRWdWZWU0JN?=
 =?utf-8?B?ZlFMRDJSdjVEVkt4Zm43SnV4YjE1ZU9Ud0RzWUFXL29rV3k2MS9jejNUSVcz?=
 =?utf-8?B?aDFPUnZDY2FncXk2OS9mKzhPL1RFclh1ektldmNEQWRHTmZCMDdmRW95Q3Nx?=
 =?utf-8?Q?lEclr26okQsjO+4PEkM/43Ty3mnpQienYTLUDa7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3d6ec2e-00a8-4411-9b37-08d98a83f8a5
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 17:49:27.1207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zOwjnhRrz1bCQ43heD/UjwtZotMHCbUBFMkji76n9sV6LItNFT6WejnvGSo5B9y04NI9/tVUpy8v4nTzmT9LKzCwhD4MQ1cpoFcgSYC04w8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4120
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10131 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110080099
X-Proofpoint-GUID: 0McpATCfNVi_qtovY1II-i745ha4aV7N
X-Proofpoint-ORIG-GUID: 0McpATCfNVi_qtovY1II-i745ha4aV7N
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/6/21 5:26 PM, Catherine Hoang wrote:
> dumpe2fs -h displays the superblock contents, not the journal contents.
> Use the logdump utility to dump the contents of the journal.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Looks good to me.  Thanks for the fix
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/log | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/common/log b/common/log
> index 0a9aaa7f..154f3959 100644
> --- a/common/log
> +++ b/common/log
> @@ -229,7 +229,7 @@ _scratch_dump_log()
>   		$DUMP_F2FS_PROG $SCRATCH_DEV
>   		;;
>   	ext4)
> -		$DUMPE2FS_PROG -h $SCRATCH_DEV
> +		$DEBUGFS_PROG -R "logdump -a" $SCRATCH_DEV
>   		;;
>   	*)
>   		;;
> @@ -246,7 +246,7 @@ _test_dump_log()
>   		$DUMP_F2FS_PROG $TEST_DEV
>   		;;
>   	ext4)
> -		$DUMPE2FS_PROG -h $TEST_DEV
> +		$DEBUGFS_PROG -R "logdump -a" $TEST_DEV
>   		;;
>   	*)
>   		;;
> 
