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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2191FC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF0D423884
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbhAVDQT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 22:16:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51416 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbhAVDQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 22:16:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M3BK8x079772;
        Fri, 22 Jan 2021 03:15:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=95zgjDE1jUCEHVCDaG8gEUxSta7CbgDDjPizO0fk6uU=;
 b=PaCC1BVgMULUFW8pdQuZHlhNjCNn+T+2tfzblp+jbhor5G7yKzwb5QMR0U86KMRcR6zm
 U7hV2DZ66tDVzW0P9T7JxSSvKrlHknfYuYjSlqU/atAINUo7WqdKu81BRUmyxK/nMnpv
 qiUHan5Jmi2bIC7FewbLeF+pzgNYw0ozEbwLDms4LIWwvzmDgFKNM/ZUocCZhB7XtZ4o
 BzYScWxmT/84n0k2bkS+DF37gXoPcaoMAuAJxA0TIs8BXWTX87D0/HFCwhxfWAIT2Ycw
 CCF4kT9bzvocZtyEqdRt4c3LiBdQMTFgYdmI/X9Ij0LPF6cQ3hydMFs3Ff8q4YiHBNB4 uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3668qn26ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:15:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M3AmMY056121;
        Fri, 22 Jan 2021 03:13:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by aserp3030.oracle.com with ESMTP id 3668qy3swg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:13:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZkzSTFs/JSGuFud26SHYIz8ssOr0k+vUFxNyhfhIDGsfXuCs8c4oUYc6OZQKf01GgG9zMccl3AURTX/odtYDTsR+NyC+LzrrvUWOcSy1YMt6tLALZvtIs0WReQYcYyW3sEt+2CZgcltZ80hRT9sgaIZz9WDQZ4nxpg9WVB4+m0xet4bzD1VHP9nCb+kfROO5zlCTtbO9X5CVpdV89ov74H9bneUiP2kM6BTSOZoBd4FIuzwK4K0ajIM6nlpR8Curqky07ORFr72iS2jr1J4Zt8/6NG0UOaWKdcSQxJ7/7POBD1S1Y7xPL5fcnsXVbJ1nQdB98aGkUOEdYXn7QUtKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95zgjDE1jUCEHVCDaG8gEUxSta7CbgDDjPizO0fk6uU=;
 b=oEJO+cMujtS7QJlgAg/GqIKy3vfImWJYphfIXYyaif2cv1Qowtde0ikESfwEG5kb887A++C3wbpPYRFoiTMQ8XmD1naFC+yjAIcxPj/8P2aelXu4ODarcc+nuX8krSXkgqKowEtneaINYTDc+qut3JDFz8kDGIs/7+hpnz7edgtYx1udf3XA2kCwotIaziuZP4a/WArl448NA3EgO3wMOVMH3m03Fdgf30qz48+Lge0Xl9WBbeyD8Rg4z3ciMTAvVWeD0fG3EH1jm3wfHOi7tsAPffBZF8BwlXwlrMDJXxrry5QUyaGkDwqSrHANtbXnAz+0LrctQupfYXaFht9sIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95zgjDE1jUCEHVCDaG8gEUxSta7CbgDDjPizO0fk6uU=;
 b=S8hWWMvTEkU8BbvbLYupinfPhJ3xwTEzoGDUUrMZf5PmDmp6b1uWSr2sYd4aRM0TY2e0g28F4jIy85hk1ZWK48BWQJgB3yzl3Cmfp49dPYFZEBOLK72Bx0HKDahCTIjDAzXsMxi6SdkN1oChL5eqGEIOAlOxM/HTW9FtyLIsBYM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3045.namprd10.prod.outlook.com (2603:10b6:a03:86::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 22 Jan
 2021 03:13:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09%6]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 03:13:29 +0000
Subject: Re: [PATCH v2 9/9] xfs: cover the log on freeze instead of cleaning
 it
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210121154526.1852176-1-bfoster@redhat.com>
 <20210121154526.1852176-10-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a9b7a717-31de-a3d2-c629-65a900c204ae@oracle.com>
Date:   Thu, 21 Jan 2021 20:13:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210121154526.1852176-10-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.214.41]
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.214.41) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 03:13:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38081e2a-a0fd-48f5-b9bc-08d8be83b125
X-MS-TrafficTypeDiagnostic: BYAPR10MB3045:
X-Microsoft-Antispam-PRVS: <BYAPR10MB304540FEB1C7E1BB8140461A95A00@BYAPR10MB3045.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:411;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tftr03/KprASnnNVeCrff17R7fAbjvnw3/d173fzTElLU+n4m8bCUQNz5TsPYy1pe+wqxMBxMOcBCbbMf0Emy3AKAhQXdhzO8L5JRFPAfdoybYblQboYrT/tWXq3Cw9pA9DxHMAnW+ZX54IpQJr7iWB/Zqmk/rC/l6sDtbKrugV4VQFynNfRGmTmEub+5spBdAOvLPxxsL+3m+o/WsiQj+aZB4+COur0J7MvbjYJFRgnP4kgOUXeVpJqQJPBY7HvDLSLPIouoxNAqldkiwHKnv0FlgUzEKgR5j3uiZACA4H2uhH0PkTXWS3TO2lpCbpyFVwfxAS3FsbQUY9Lal0CNi1m13gQg/VZ7Dd1Klc89kO3oC445Iwza5Xqp/KxhYyxCJrK8fE47RMUH15Tnif3bDiVhbdLRugv7cOGZWsEW5CIds8sw7d1ST0YR9u72fUqfnRO9dvA3DDUYdkX9fkrLgoPZyzon67bsBrVzJKVNps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(346002)(39860400002)(136003)(66946007)(83380400001)(44832011)(5660300002)(66476007)(66556008)(52116002)(2906002)(31686004)(8936002)(316002)(16576012)(36756003)(2616005)(26005)(508600001)(53546011)(16526019)(956004)(6486002)(186003)(86362001)(8676002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T1A3cDJZUEFRd3hUVGlwbDgxbkM0MERTajdpdGIxNGJBbnV5UlFmR2lsZW91?=
 =?utf-8?B?TlVNWTJEb1ZEb1I1STJiakUybXpxOFZ3N0t5OE5ta2dCVkZ5eVZyNUFUUkxo?=
 =?utf-8?B?K0IzWlFNcWZNdWQ2SGFIdXFDbWFERTJUUzZhU2p5OTVRQjdOenUyNmorQXVN?=
 =?utf-8?B?UHhKZ2JKRVhYYkQ2TVRaZW5pZ1hvbkgvWWRkdG5pOW9mR2VyTEtXS2NUNko5?=
 =?utf-8?B?Um5oMnVJM1loa3g1N3N1a1MvYkdqb3RVSkpXbk5YRW51cjdkb3pnSDAwRExB?=
 =?utf-8?B?cmRWMHUrbkR3Zm96U0V4cTlTVjJxR2llT3JnSDZ2dVhocHltZDRaWUMwZE50?=
 =?utf-8?B?MW1hMTFHQVRZWTZuNmdsSHBDdUxZdWsxb1B6WEpWZExIUVNGemtIMTFIMzI1?=
 =?utf-8?B?YWZDYVdZOHpJaHZISDhSN2hPNDJQSTJlSjdOVll1KytaWjJ5dmxFVEl6M1Q3?=
 =?utf-8?B?ZjFuU1h5ZmZLa1ZpTTdpSzgvVXFJZkdVWkVEVGNGdG4yaGJnNFc2MzFJdGRZ?=
 =?utf-8?B?SGFlQTB1WU80QVM4S0JHY1AybWs3dEw0Nm5qSC9iODJVK1VjY21GVmcrSW9q?=
 =?utf-8?B?NTdMclhnS1VJNHpRcWgzTE1LeW1PRWZWbkFKeTBTdTk5QUpoT3B6R1Fqb20v?=
 =?utf-8?B?MC9DL1NGbVY1Zmo4cWRuTWk4WlJTakJPQmduZ3oxbnUwRzhpc291SjdpSitH?=
 =?utf-8?B?cWMzV2RBNzNlMWl3QkhlWWtEWllGalVlRjdxYndDMjZVRHdlTE5LSWh5SzBX?=
 =?utf-8?B?aWl0ekh5SmI5NDZUczRxeVVmU0V1aTdsUzhKb2VNbzJTREhSWnpaYmEwODZB?=
 =?utf-8?B?Nk1Xc1NXWWx2UmRrM1pJZEhpRCtEQVN1Uk5XTWYyREhZYVBDKzFpOVQ0MEtQ?=
 =?utf-8?B?Y1hNWE5jZlFRVXJQQm82dUxSQUpQRFBPclhJcGNxck8zNzQwMWpJOVFrdldl?=
 =?utf-8?B?ZGIxVkVFU3BIMEgxTkRCMG5wbzY5ekRTUjZZTlRYNFhYQnEzcFZ3cUhOUlBM?=
 =?utf-8?B?N0JPSzVXMjM5OEUxSTNacUxNYm52OEJzUVVLRUI5d3RNWThMa3FoUnRBbHpD?=
 =?utf-8?B?Y0swd2xmZVdnL2thb1kzeFUyYlZMNEZjdkhtWCsrdlBlemY0b0dqNkdRSmRB?=
 =?utf-8?B?U3d2YnNKU1U3UUJncWtpTld0SjZhcWpKQVhSZWV2TVFEc0FnMG1FVG9UMVZ3?=
 =?utf-8?B?M1dyTHR3cG9DcUdweUdDM01iN2kwdkcvLzluOS95b3VNR2NVZm1ZWUVlTmZS?=
 =?utf-8?B?TzF4bmZaY3ZyV2ZXeFUwY3JoZi9ZV29ISDlrOWwzZENxZ0lDQ3F5ZjV2bE5B?=
 =?utf-8?Q?HXPXolGPSlOlI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38081e2a-a0fd-48f5-b9bc-08d8be83b125
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 03:13:29.5754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2DhZhzM40ycSo51vKHmj2K11dRVNlggauMd/DPN9bmQvHFJZjrWyNBbiyEZS9P01rPeoLaM4FC6/bs2K0aDS9FNiptk6Hz0ExwoggQOwRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3045
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220015
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220015
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/21 8:45 AM, Brian Foster wrote:
> Filesystem freeze cleans the log and immediately redirties it so log
> recovery runs if a crash occurs after the filesystem is frozen. Now
> that log quiesce covers the log, there is no need to clean the log and
> redirty it to trigger log recovery because covering has the same
> effect. Update xfs_fs_freeze() to quiesce (and thus cover) the log.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_super.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index aedf622d221b..aed74a3fc787 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -889,8 +889,7 @@ xfs_fs_freeze(
>   	flags = memalloc_nofs_save();
>   	xfs_stop_block_reaping(mp);
>   	xfs_save_resvblks(mp);
> -	xfs_log_clean(mp);
> -	ret = xfs_sync_sb(mp, true);
> +	ret = xfs_log_quiesce(mp);
>   	memalloc_nofs_restore(flags);
>   	return ret;
>   }
> 
