Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BE7C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 22:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiAaWGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 17:06:07 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59062 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231175AbiAaWGG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 17:06:06 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VJ2aZk008741;
        Mon, 31 Jan 2022 22:06:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Vgge3AVSomCN5KV8ZSD7zX9tpaWY28KGE/6dUf9Hp3g=;
 b=Onnfo3JwUIlgaLlqmr/dT+OZzuboycZWUwjCIb8fkaYls5HkhuPCH4OIEacKOJlLg766
 ABpY9ZKPtv4U4plmF3+QkfsDqeMXoVuIhc9wV1roo40fNE9WsSVdea8TdeZtMeJHYWT9
 2Zsebw5z+77SHZCy0yyqeJsgDAD/eKu9swgXRQK7Lw7JvXLpZ1fCDpIZT1C1yfc3UCH4
 IlLKALgyPF87Ub+c25jeR0mTkTvdiPaZOXCUzYFyFj9JeEA7YPukLGOrRw0OvYEgnBVr
 OvrFuCXEf6/XNT6PC8V4UzY/etthCIZK6fa4zc1y5YBgXf0hsqu80kTbo+l/8sxulot8 tQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxnk2gcw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 22:05:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20VLpcph049335;
        Mon, 31 Jan 2022 22:05:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by aserp3030.oracle.com with ESMTP id 3dvume90yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 22:05:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YD3pbq9U5MbgQqQXuTmCME1IAh4PKKSTsoVRyVRInSa8ZqEpGa5W6EYdblp4d6ktsli4qvkWOws4wMYdkeRRah8pMeZKOmEGMN1bD4hsgLd4QeB8w+1Vh8iALZpoc2MPUa/XMDCoYohTb/JS2kYSdr5wSAEWqxJkWR7wk3YvtxWmOk22a/4Ym3+aFLPhMDOMfVessI27gCx+HzhtiJUhB1esDNlSpSfo1RdNh5G26AB4TuIeQtJhXrq903Luz7ycWmm4vP2g4dfJ35KlQfKidGRbZ2f44bQTNN6BYtuaf2uzsi9vo62Ohz8FoHZEG2DMQsCmWv3+kd/Low5AkKu5kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vgge3AVSomCN5KV8ZSD7zX9tpaWY28KGE/6dUf9Hp3g=;
 b=K2AZyyhYbUeIVMXqe0H4IJhtSuQTxdomMyDbHBa9G+PfAscTeHz9C3SsSv7YvrM591uWl8aYlSPD/Xr7IIFhYmBn8Qh7I7gdhBv08kM3dLQxAmh9El4fCztlsUKCUWtwuHq2WgNutY9//fCInHhe0vGnRNTdqc6FPL9ziVNs0vy5DP58WYskjtILyC8H1s9M6iJuAFTTWsZnXabQ6+1a65/sRgol7xpUiX0nshNmhRtXm/CfTj130I6fiWVMiJrZgXwHygEjtMg1/ELpL/e5KdsSt6+fJmcC1SEP6QS79s1EFgjfvmovX+RJy54fKz34zjFjnRSyDF1/JHYOyQcwpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vgge3AVSomCN5KV8ZSD7zX9tpaWY28KGE/6dUf9Hp3g=;
 b=M+uQb3B+S7mWHSPOg45f2+tZI0iDVG6joxUGktVDOjDP+WQCxQjkW3fzaW+L4JCT6KgAu57Re6MY73Ih5h2x/Bh8BdYQ+4V3zRj6S3ZH50IMUKoJP7WBqL6O/IX/YggsLA41aYqlwW667n28P4t7spzgb0+s333y1JYsCtV33ek=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA2PR10MB4411.namprd10.prod.outlook.com (2603:10b6:806:116::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 22:05:56 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 22:05:56 +0000
Message-ID: <5efd09a9fb43f40b6c91cbb9c1eb7d93e441f195.camel@oracle.com>
Subject: Re: [PATCH 1/1] xfs: reject crazy array sizes being fed to
 XFS_IOC_GETBMAP*
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 31 Jan 2022 15:04:23 -0700
In-Reply-To: <164316352054.2600306.4346155831671217356.stgit@magnolia>
References: <164316351504.2600306.5900193386929839795.stgit@magnolia>
         <164316352054.2600306.4346155831671217356.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0035.namprd08.prod.outlook.com
 (2603:10b6:a03:100::48) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 919343aa-f359-4502-575f-08d9e505db3c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4411:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB44110356C5507DA3488044D995259@SA2PR10MB4411.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wnaXgc0Caog+dYY8GajfF7qW1URUpCzqGvTawWQf7RUZNoa1T2dRQLZ9Ta/XQOJJKMXhgJANpT6WYdxCsQym1ZrI6F+QRig592OAPigChbBtZr7xxJ1BHhxHQxj7ebVN1YLGbE050W8s/ryG5twWk9OtatXVIrGdmG1aoHzDuhFNqb1mi601/F6MsnA7HwH2t683I/5vDHOXKufQBX7AdjU6Hc2dru65Ric5Hl5v/R+xOMEcAfiQv3X/qdB6tuQNQQByWMcPiMNiWIpVLum8llnCZysyaKvNPgphgpMkecgSLy+FspDqraH2jKw7j4dhv/+KF4lLpw1qnxhq2I0GEP58A4FUPqvXeoNJXK8sQ8wTdWWB3XtWdq8IQBKlmOops0VbEDYDeVlSszFDDAJu8gvOg3J6KXspm2/9bwVEUjKFvE1gsoM6qo25L7c8eIRGNkVI8iD1/vB5Vu0z9+sIGdTndX30L8OLsByGRYSyolmeUaYA3zioGcqBMEiAmcdqT1hy11Js5/dVlhLbmUnh6GgMsFvncUiL31CP7WBSVFujRhBzKBe/SDrsUd2bGZkMMaAPZDjuRcSjimSIMotTijiP6MaHwTP1/s7BDzDu6dghh4HI3b+r7CIXDN1j68esf4BXjb9jlwKiKy4UmuJw+sL3SSsW0MEL8fVbXZanOA/GR9MlnkOfsFFsuVsMR3KlgekjAxNPq/r7iE+uoPXr8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(83380400001)(6916009)(316002)(186003)(26005)(2906002)(2616005)(86362001)(38100700002)(38350700002)(508600001)(4326008)(6512007)(5660300002)(52116002)(6506007)(8676002)(6666004)(66556008)(66946007)(66476007)(8936002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MU9GUlZ3VTdhSzhWZ25kSSsxMmhaS1owRWUvKy93Z0RaSitRMDFaSGdncWhS?=
 =?utf-8?B?eXpnYm5MWG5HZUcvN2h0dFBtQ3k4ZDRqd0dYUm5NTlZoTHFqbEJVdjhGaWtk?=
 =?utf-8?B?NHFXTkpFRnNhaysxVlY5R3dpVjVwOWM5ZDViQ1NBaExqQkZZNHRzSGhzQWJV?=
 =?utf-8?B?SnJrVHBTZTRZdEl3STdsc0VZSzAzdmVaNVI3ZmlMVFRySDhtb0VXc0ZrRE9K?=
 =?utf-8?B?SkdVL0VKWHBaWXpCQXVCalNRZjIxNkQyRUk4cEZFYkdkeGk2M0hhVG01QUNY?=
 =?utf-8?B?Uko2QXE4UXVQNCtISXpVQTYyY09mSDFLOWtXN1gwbTFMdHh0RXc4OVMxU0R3?=
 =?utf-8?B?Z1laUC9FM1k4cVNiTTNDRDRzbFpMY3lNQlpnVXpLd2dNWDFXbXZBMDNnYkhQ?=
 =?utf-8?B?eG0vekpCdDJMczNYejVZQnNkbkxDQ0d3S3dtZkRmdHczVDJlb0JqTG8yaHlH?=
 =?utf-8?B?YW1BdFdSNDZPcnh5YWZsSjRyUU5YNng1aWRkT2N3Q3FPSmlDUzF5MmUxT2p2?=
 =?utf-8?B?ZmtOVEhnNGxud3RRcmQ3bmRBdTI4U1Uvc0MxVGFsc0VnbFVpL2U5bWVWYTJP?=
 =?utf-8?B?K3VVU293Mm03Qi9DVGpHdjVlaEtlYXVJQmRGZlBUYTUvcXBPMHMwUVFHZDJk?=
 =?utf-8?B?SnRHMUZDODF1cCtHalJvcHkvcC9FYnlqRU81b0JKTHUyOUx0WFdOQzBEMSs5?=
 =?utf-8?B?Nk10b3drcVpwMTQwd3JlaXVlQlZnQXJFdWZDbW9DL3F5ck16V29CNlBvNG1j?=
 =?utf-8?B?U3BxeU9KbGxmWWRJNVpZeUxWTUttM0l5S2V4a0RONFN3OXJoOU5GcFQxZGdn?=
 =?utf-8?B?ZFZSNVY1ZGt3QkJrUjRCOCtHaUZSc05lLzRieWlNZ2lRTGc3TnpCc1F6QnBB?=
 =?utf-8?B?VTRGTDBBMHpmSUVHRjdoaXdjWTlBUkl2SlNKZjVaS1YvZnhFd09zU01xbXVT?=
 =?utf-8?B?N0xhSWpXc0ZwL2RYa2ZmUWZFQWY4VnVsdk1ud2NkZ3cwQWhUYTlCRWo5SndW?=
 =?utf-8?B?S3MydmFsSEdscUpDa2JlNDV0WlNTWTBUL09xZ0U2QzFZNkdMdkFJOEp0Qzlp?=
 =?utf-8?B?UzZ2dnpQYkZBNkpEK2RxbkU3emNDNXhWdUM4NDlVSDF6WEFsbVRDNHM1NlIw?=
 =?utf-8?B?aGxiclhvMEtHT1dlZDE3ZzV4Qm8yTE5VdXdlRVltQjE2Ukw3eEd0TmVHTVgw?=
 =?utf-8?B?Slk3VG9jcXI0ZzgzcmJSNHZWZ2pCaHJYc2dBZXNaSU80dDdqaG4zY3grVDdl?=
 =?utf-8?B?M3lSeExWSDRqU09uRi9hTCtHK1FlWEVxdEFFSTNGbzdEd08xSEIxRkJ6RVJx?=
 =?utf-8?B?R3VXbjAvc2xFc1Jtd0pHcXE5V283aTh4Z084THk3cDZaYW56STl4OXJhN1pu?=
 =?utf-8?B?OUxEaytETjI2NUlxdEhhTFZKZzI5TkwxTjI1TXNRMTRqdnJxc1VxL1VMckFU?=
 =?utf-8?B?QjlRRXRlYmtaNGwzL05UYUpydGJ3bTNneTdKbmdhL1RPR28zNE9NRUtuZG9m?=
 =?utf-8?B?REtSS3Y3UzFXenZrVEZZT21ua3RQOFBXSlpRTThsYitJZko0cFFYUngwdC9v?=
 =?utf-8?B?SUhIU2tSOEdQVUpvb1ltcklPZnJtTloxUzNkREtTaVlvQlRoT2R0bDdYNnhT?=
 =?utf-8?B?Ny9qTFQvYkZYWTRYc0NpcTYzMHZ6Um82WU1UUnNkaWN6MEdPTkt0bmwwNXBF?=
 =?utf-8?B?UVR4U3puWUwySVI1V2J1UVlSMzhLdHRlMmx3bmwzWmw3bVdIVjloaUFmU0VZ?=
 =?utf-8?B?dGZwblZMcTh5dW93UlhKWjJOeldSVXRxd05KR0xkSEVicmd3UXJGck9ZOWVj?=
 =?utf-8?B?MGVqdkc3Unc0eDVsWHBRWkZJai9ySWVYMk9PNnVhQVNKOFNKQkN1c29ZeUpr?=
 =?utf-8?B?clhycFlwWmM2TUxFRjV4bXpJK0hMQ09tOHdtMzlRUmw1MDFZUXQraUtxYjZy?=
 =?utf-8?B?MXlJZ29OcVJPVTYyM2RjMkg4TVdvQzlBTE02L3JKYXFRM3lwSGh5TUNJWFgr?=
 =?utf-8?B?MmpnanVsc09waUNLcUhkNWsvb1daZVpvMmNIcDBDNU82b1lrVGhTVlVCdVhr?=
 =?utf-8?B?OGJKZy83VGRxTXllNmgvMUtEVGRiTERKOHl0cWkzQUliOHhpS3ZsZDZ1UmVl?=
 =?utf-8?B?Z3J1NHBMUGdYcUh3cFpIWk12Z2pWS3llZmZIZHBOYUJqNVg4cHFOY09mbWFj?=
 =?utf-8?B?OW1BK1VNR01nejZKalBXWHFrV0JKVlJXcnROK0l5c2lQMERNSCtqMWhjN1Jz?=
 =?utf-8?B?cVF0VEx5ejcrRVF6eXI3ZURiNnVnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 919343aa-f359-4502-575f-08d9e505db3c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 22:05:56.7598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +q3DGA4JnaOtAylHxsmmYyzApt4od9Vx6lqAJIkDDGE4Ah9TnvbN6/Du370SoIaBecGZ/XVA4fwhSGMizEHoP9prUC8U6y1U1uam/uYnGCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4411
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10244 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201310139
X-Proofpoint-GUID: 0bs4XWWlbjaK5koXVmUSzzKC8xNkJ0K4
X-Proofpoint-ORIG-GUID: 0bs4XWWlbjaK5koXVmUSzzKC8xNkJ0K4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-01-25 at 18:18 -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Syzbot tripped over the following complaint from the kernel:
> 
> WARNING: CPU: 2 PID: 15402 at mm/util.c:597 kvmalloc_node+0x11e/0x125
> mm/util.c:597
> 
> While trying to run XFS_IOC_GETBMAP against the following structure:
> 
> struct getbmap fubar = {
> 	.bmv_count	= 0x22dae649,
> };
> 
> Obviously, this is a crazy huge value since the next thing that the
> ioctl would do is allocate 37GB of memory.  This is enough to make
> kvmalloc mad, but isn't large enough to trip the validation
> functions.
> In other words, I'm fussing with checks that were **already
> sufficient**
> because that's easier than dealing with 644 internal bug
> reports.  Yes,
> that's right, six hundred and forty-four.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
This fix looks fine to me.  Lets get it through.  Thanks!
Reviewed-By: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 03a6198c97f6..2515fe8299e1 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1464,7 +1464,7 @@ xfs_ioc_getbmap(
>  
>  	if (bmx.bmv_count < 2)
>  		return -EINVAL;
> -	if (bmx.bmv_count > ULONG_MAX / recsize)
> +	if (bmx.bmv_count >= INT_MAX / recsize)
>  		return -ENOMEM;
>  
>  	buf = kvcalloc(bmx.bmv_count, sizeof(*buf), GFP_KERNEL);
> 

