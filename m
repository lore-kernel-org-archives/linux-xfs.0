Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78626C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 23:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349187AbiEPX4W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 19:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350574AbiEPX4K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 19:56:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073131DA70
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 16:56:07 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKisei009878;
        Mon, 16 May 2022 23:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uiOn/GHrCv+gCiGmeMVQ/+hx2zzg3r9povpYIQbcdN8=;
 b=cIRKnB8xbKP9WFmutx9xcr2uV+CbGvLDR+nSZSrrQczN+vvDf1hsjn4Q+DwI+GOOrVHK
 Csx32gR7LkC/UaQL+x3GEHMyCsedxA+TZ4ihBEaKQ+yId1xEnjzX1HLv/lMyF6/TgHVG
 w9meAMF00eCXv3B+fc+8AC6lLfWuTOU5UXRmQakVURYGdTxFgUW3npTXP4pGB9VTcdTm
 QEMihgY/gS7WBbWPRjr9UcbUwmOnfZe7QD3Abg3L7elZqiSf70a+zNoRbcd02h3Im1Nr
 5T+zqEcUCivIzf+yhYnYDcPR1RGTBwob/RXZXV9dmWBZByNQpYpQDNCYaJlq3noUmvb4 Xg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310msvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 23:56:03 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24GNdiOi039562;
        Mon, 16 May 2022 23:56:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v2f9h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 23:56:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSrb2h73sQMiAQrxzw/WR4+S4OdSZHkhh9QGfbtOk2vVFc2ihKD7DnQNyutUml1Lb/d+xGKfRP3oKpihnXXh7DS3Tdv8izYrSfZmt1iokddNTpJJpvFysIU0UlmXOQNfmXSsKBsRJUY6/wkoUyfox0muOj70Ee71QcYqhqz8OxhRXjkBF4IUgWuqQ/FEgc23DnjRBBx3xwJ17s3lubWc3osTX42f8a7XUA138/Lew+kpWudVZwHQs8ARRbYoEeCrmXayubkw2Jwh6B0lhwsYvfyrXxGdnlmZR6fspyKb8OLz1S+uRdE2M5CAQWmqP4MoR+jKzbje4BvzP3V4/rk0/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uiOn/GHrCv+gCiGmeMVQ/+hx2zzg3r9povpYIQbcdN8=;
 b=Jr6gGP78Dg4Aer+uB/WX2OuTrwzgtRSougy7ePCASAbox9f4/agy7RqWRdYdlvzP7uBfdF7sNNuPQvMNvVJjDyjp4KToNrlRvCF87N1C56GhYBGQ3y4ejyyJRXVFlY5JrglhM6xxJCEaRwI3MkJVu2lJmqZ98Kc8WK0FUQch0/0hDSZUwpG47qPLSMfaDfP4vYAhJfGtPA2Taz5WX47y0JsylhQ41w71nUSoI2oYj+kjJbRxpE6fOn2Kxg20hwYXFH3y9zjd+HpKDXqoch1JqUC97XqFrBxK5zCRDpuTt7nTW3U4p43PKzGgfedQvv4LPy4H6rz7kijbFb4Bb3moJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uiOn/GHrCv+gCiGmeMVQ/+hx2zzg3r9povpYIQbcdN8=;
 b=ubPclEZW8vvxqKZ34kK/mhjeK4yp10XSPLMeGWO+6l9KFvqwrE8/Q3wuDcXOfHZ1JAHiVvzFRzHFf4lMH5jG80l55rjQ/vMRVCF6JDb/jbHvwMKdFyfSt68m5zQ8VavT/R1mnd46qgRf2MYXF0Kh/z4zlxr4uUqQh5q0uIIIPKE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB5758.namprd10.prod.outlook.com (2603:10b6:806:23f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 16 May
 2022 23:56:01 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:56:01 +0000
Message-ID: <721193bd107a74c913a169a10824e5611c2b7044.camel@oracle.com>
Subject: Re: [PATCH 1/4] xfs: don't leak da state when freeing the attr
 intent item
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 16 May 2022 16:55:58 -0700
In-Reply-To: <165267191771.625255.3595054157709968327.stgit@magnolia>
References: <165267191199.625255.12173648515376165187.stgit@magnolia>
         <165267191771.625255.3595054157709968327.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:a03:255::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8d3ef39-3be1-45d4-96c2-08da3797a0e3
X-MS-TrafficTypeDiagnostic: SA1PR10MB5758:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB57588DB142B74C3470405E9F95CF9@SA1PR10MB5758.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vw8bbA1gdA+yN0rr2bQMuoMgWzBAMIh2tpvcWGa5UgXv+6hKBv2oRuK2VK2VZ16p1InAh74o6m+LyMlQ4eJ9zMRUyNg9wUjRsIVlJZ5mYKB5gWxrKYo0+jtEGswt/a6sA/tein9f4xnb/JzS1htr/OPkWoGvGXaGxUvjz2iemMsmz7uRVEE6T6Fp99avrfJ3PNpwlStRKM+TJaLqd0rB388CaYOflo77RzYmyZala0AiDAbeIfI4HNxHo8ZY6Qlju21ffA3cXogZIlpER8lIMO1yMHyRnpYvZTMMtWCIbJIqD4couoKIs1Hxs33Sk1DTJemqxwr4ZNAgp5iec5YlSfrakF2SOgZfOX3slXi/VuTKR13LUfYzTRAcha4q7PTyCgQiNGBPwJMlBoWRlB9M/d15JNinFYnQB21Vjrou7Sh5sS4hJS+ggtz+C+Immz4ltwDicQOh1aE8ojyU89ZycarYvRDR961P9x0+cyLdoI1HaYyAq06ald4ETfrNDCm+ybYm9FYAxk+hVwxzNst+ElEEdRodYagZ6bbFTAJqSuyvWd6I/NnXApDe6HY1zdQHs2K9KTINV/rZ9WBB0ELeTje4x+YzYxcEZUdlyq6HDsS5/s9RTBqdb0WhHO3IuDXQ2OrEbKuf7MP78E4sFTUedaEkuaYfOngFt3FjnzI9xJE53965VR3I8WZPHQK40Y3ReGafmfUE4UHvzyaNrSHmXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(38100700002)(6916009)(2616005)(86362001)(38350700002)(83380400001)(508600001)(6512007)(4326008)(26005)(6506007)(6666004)(2906002)(8936002)(36756003)(66476007)(8676002)(66946007)(66556008)(6486002)(52116002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVIrSmMyZDBRdTMzeXVWZDBXUE9acE53TTlHeXJXdzdMOWtvQ3ZldERUL1JN?=
 =?utf-8?B?WlMvdURyb3JiMHdJTStkOGZ4S0ZFeE0za0xvbTZxMkJNbmpmam1RUWVoaDFS?=
 =?utf-8?B?TW52UWNJWDJMQStiTVBDV21ZR2l2RG1xR0ZDbjVKSUY0QVhUS0NDNFA1SkZ0?=
 =?utf-8?B?Y1B4UzVsemxwcVA2VlM1VHEwUXhSdm1SMnVMbUdkbS8rTkUzc0FicFdGZnR1?=
 =?utf-8?B?bjNXQW1ncnlFNVJ3L1VDTjhEdTlkV25PWjd5dnA2YklTWFJ4WXV2bGVhQmox?=
 =?utf-8?B?blM4RTBaNWIrYkdNUVQweGdzSUtxOHVWQ2plakkvWThWMHJ2aEMrbUZXNEZJ?=
 =?utf-8?B?eWdVeEZidzQrY2lTSHMwR1VJd0JFN2VuM0dLRXRwNDZmVlJ5Zy9tL1hVR0Za?=
 =?utf-8?B?bEFrcnZuQUdwaHFuNTZON2d2TVpIbVJIRUNBSFErQnhKUXZUdEorSnFoVVlt?=
 =?utf-8?B?UlUrY2oxemFVcnJpMDZCNHN6YmJPNmw2ZlRPeGhodkkyQmZ2Qkx6TkVRR1R3?=
 =?utf-8?B?Q1NDZ2xrUDNWRnRqa3ZuZjNFNHlnYmNJTnhhdFpsZ0d6R1d2Y25MMGs4UGNa?=
 =?utf-8?B?OUptMGIzZnpWTE90dk5qWERhVjI5NnY2a2tPNXZkTWpXZjNDZWpSa0tUNzhs?=
 =?utf-8?B?RmQrSTRZRHdQRVVXa042TzhPVUZYc3FPN3RnK1FFcEFtbUtqZU1JWWs1UUt4?=
 =?utf-8?B?TnFWdlRTdisyUStEVWNpK0dIOFNrZG8rWDNRMFpzcnVrUmRLcDdDUTJEeWIz?=
 =?utf-8?B?WTVvdklRdGx5L2Fubk01eU5oQmRjTU8zMEIwMkkwWFFDYk05aU5zclRhcmhx?=
 =?utf-8?B?enY5eWpzTzIyOE1lYVY2WHVKU09NM2Z5Z3lVMm9xSGJ0VU91THc0ZmhZV0hI?=
 =?utf-8?B?Sk4wTW9QWW9OUGttUEJlOFFSdkhiM200WkZwdWFta2FMVGY4c3ZCQkFpTjRo?=
 =?utf-8?B?cEgvYlFQZDBQV1NDWUdFOTYwQkcrN2drRUZUekF4ek0xamFGVkVOWC95MDlF?=
 =?utf-8?B?N1VUSHZVQlRqSjFJVndkUUVLRHBodlJqYjM2VDVjc3M5YklnVWNsMk5qdXIy?=
 =?utf-8?B?eG5aMmhGUGNpUDlZNis3L3NsVEpWNFJHTTlQLytWYTlYQ01rbk9oaFFhK1lY?=
 =?utf-8?B?YnVKYStCN1RDeWlyR0NybHZyYW03MTlaaFk4c1BQZXp4VXBBYi92cUxtbFd6?=
 =?utf-8?B?Vmd1bjF0aFk0RTlZOU1Fd3p0Ym5aRGJEaUY5OE1tUU5sTkdRa3ZYRnM1eVN0?=
 =?utf-8?B?QXV0T3hoZ0Z0RGY3dFM4V2dXQXhBTWkvcXI0MytQR0JWNmRZa1RPRWJjUGhY?=
 =?utf-8?B?elc5UjBCYW5EV2Q2b1JYY3N6emUxcXlxOGRvT2w2U1FCMTl1OW05aWdUenV5?=
 =?utf-8?B?bitFOWtqaTh0MkJSWks5UWttNjVlK2hyWE4xb2JEc1F4bUN5c0FDT2EyYUgw?=
 =?utf-8?B?OThzR014cWNNMElLcjMrNFRKazg3cSt6ZkRnVnVJWkdvSjJ3NUQvN05Ddm5H?=
 =?utf-8?B?VGVnclhTb1pkWk9NYjlQWnJPaDVXL2M2N3NLYTRIdDBqTXJoUDB1VmhoWExE?=
 =?utf-8?B?eW5PbENkZEczN0xPZDk1b0JjTGJBQXZVWXNYQU02R0RTelViRWhPeWd1MlUy?=
 =?utf-8?B?R254TW50TURJdzVQZ2VDS001b1IxdjB5WjhsdHdUZVA5cGRsVnVKZ2xTaXV4?=
 =?utf-8?B?anZwT21hV1hNaXZSUEJSUkFxbFpzcTZZZHJsTzVOM29PR0RmQzVoQjE5U2lT?=
 =?utf-8?B?MVJhYmM4MUhIdzh6dzVnUnBRR0xpMGs1bDhDb29JdlY4ZzdMY3V1YzhUYWVD?=
 =?utf-8?B?b293V0xoVHlaWGliM1FHTlNQWk5uc3c2c2o2cnpLTHF4QUM5YkgxN1ZHb1U3?=
 =?utf-8?B?UzFpNEREeVlvSUY2Z1RsUmw1N2toZVdEN21VUFRhalBNOGVaVjlSWnJOTmdl?=
 =?utf-8?B?bGhGK3M4amU1dlBJSmlNZDNXS3lpYmI3c2dPZm1jaHQwQk5oWDI4U29xV1gy?=
 =?utf-8?B?a3VKbzhXcC9Gb1N5NGw0U1ZwVDVHOWVEcm5GYUZidE9CMVc0TWsvMGJBYnEw?=
 =?utf-8?B?UktaRklMU0pvTXpwQjNiM0RIanJhMHNyNUJTQlhjajZJNXJSQmg1dXFwQ2RM?=
 =?utf-8?B?TFNCclVLbWk1WGcxUE1pMnVnLzMzbmprWnNnR3VxRXdUU0VxdDNQSC9rcU5R?=
 =?utf-8?B?dHRHai9HMVFDUmRqWGJUM1JncUhsTHRMWWZ1QmVlUWlxeVlvamI3Q2Jrenor?=
 =?utf-8?B?dFFVZzJtT1diWkI5OFRCQjZTb0tab2Nxd3o1VXk4MjBoVC9pQzhGVUZwaFJj?=
 =?utf-8?B?dXU3cGRubmJmTWVKOHBPelE3SzE5b2pxQTNqZkZOeTdyaEZuTUVjRzBEVmNM?=
 =?utf-8?Q?ZvJhSL0JaQU1GGRI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d3ef39-3be1-45d4-96c2-08da3797a0e3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:56:00.8813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4V585LlJ20t7UqzrrinhIVQjqKfQmXLFJABQA2hG40ZcFo56BQbfBahO1GnDrpRiSU8Ht8jXti39wpVz2ZNMKQ4TmevynoJM7YrwsCdyxlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5758
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_16:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160131
X-Proofpoint-ORIG-GUID: 7G5QuuqqpO62h9PvTvZCPgUNqfozXitE
X-Proofpoint-GUID: 7G5QuuqqpO62h9PvTvZCPgUNqfozXitE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 2022-05-15 at 20:31 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> kmemleak reported that we lost an xfs_da_state while removing xattrs
> in
> generic/020:
> 
> unreferenced object 0xffff88801c0e4b40 (size 480):
>   comm "attr", pid 30515, jiffies 4294931061 (age 5.960s)
>   hex dump (first 32 bytes):
>     78 bc 65 07 00 c9 ff ff 00 30 60 1c 80 88 ff ff  x.e......0`.....
>     02 00 00 00 00 00 00 00 80 18 83 4e 80 88 ff ff  ...........N....
>   backtrace:
>     [<ffffffffa023ef4a>] xfs_da_state_alloc+0x1a/0x30 [xfs]
>     [<ffffffffa021b6f3>] xfs_attr_node_hasname+0x23/0x90 [xfs]
>     [<ffffffffa021c6f1>] xfs_attr_set_iter+0x441/0xa30 [xfs]
>     [<ffffffffa02b5104>] xfs_xattri_finish_update+0x44/0x80 [xfs]
>     [<ffffffffa02b515e>] xfs_attr_finish_item+0x1e/0x40 [xfs]
>     [<ffffffffa0244744>] xfs_defer_finish_noroll+0x184/0x740 [xfs]
>     [<ffffffffa02a6473>] __xfs_trans_commit+0x153/0x3e0 [xfs]
>     [<ffffffffa021d149>] xfs_attr_set+0x469/0x7e0 [xfs]
>     [<ffffffffa02a78d9>] xfs_xattr_set+0x89/0xd0 [xfs]
>     [<ffffffff812e6512>] __vfs_removexattr+0x52/0x70
>     [<ffffffff812e6a08>] __vfs_removexattr_locked+0xb8/0x150
>     [<ffffffff812e6af6>] vfs_removexattr+0x56/0x100
>     [<ffffffff812e6bf8>] removexattr+0x58/0x90
>     [<ffffffff812e6cce>] path_removexattr+0x9e/0xc0
>     [<ffffffff812e6d44>] __x64_sys_lremovexattr+0x14/0x20
>     [<ffffffff81786b35>] do_syscall_64+0x35/0x80
> 
> I think this is a consequence of xfs_attr_node_removename_setup
> attaching a new da(btree) state to xfs_attr_item and never freeing
> it.
> I /think/ it's the case that the remove paths could detach the da
> state
> earlier in the remove state machine since nothing else accesses the
> state.  However, let's future-proof the new xattr code by adding a
> catch-all when we free the xfs_attr_item to make sure we never leak
> the
> da state.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, I think it makes sense.
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c |   22 ++++++++++++++--------
>  fs/xfs/xfs_attr_item.c   |   15 ++++++++++++---
>  2 files changed, 26 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 14ae0826bc15..2da24954b2d7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -604,26 +604,29 @@ int xfs_attr_node_removename_setup(
>  	struct xfs_attr_item		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
> -	struct xfs_da_state		**state = &attr-
> >xattri_da_state;
> +	struct xfs_da_state		*state;
>  	int				error;
>  
> -	error = xfs_attr_node_hasname(args, state);
> +	error = xfs_attr_node_hasname(args, &attr->xattri_da_state);
>  	if (error != -EEXIST)
>  		goto out;
>  	error = 0;
>  
> -	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp !=
> NULL);
> -	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
> +	state = attr->xattri_da_state;
> +	ASSERT(state->path.blk[state->path.active - 1].bp != NULL);
> +	ASSERT(state->path.blk[state->path.active - 1].magic ==
>  		XFS_ATTR_LEAF_MAGIC);
>  
> -	error = xfs_attr_leaf_mark_incomplete(args, *state);
> +	error = xfs_attr_leaf_mark_incomplete(args, state);
>  	if (error)
>  		goto out;
>  	if (args->rmtblkno > 0)
>  		error = xfs_attr_rmtval_invalidate(args);
>  out:
> -	if (error)
> -		xfs_da_state_free(*state);
> +	if (error) {
> +		xfs_da_state_free(state);
> +		attr->xattri_da_state = NULL;
> +	}
>  
>  	return error;
>  }
> @@ -1456,8 +1459,10 @@ xfs_attr_node_addname_find_attr(
>  
>  	return 0;
>  error:
> -	if (attr->xattri_da_state)
> +	if (attr->xattri_da_state) {
>  		xfs_da_state_free(attr->xattri_da_state);
> +		attr->xattri_da_state = NULL;
> +	}
>  	return error;
>  }
>  
> @@ -1511,6 +1516,7 @@ xfs_attr_node_try_addname(
>  
>  out:
>  	xfs_da_state_free(state);
> +	attr->xattri_da_state = NULL;
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index e8ac88d9fd14..687cf517841a 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -396,6 +396,15 @@ xfs_attr_create_intent(
>  	return &attrip->attri_item;
>  }
>  
> +static inline void
> +xfs_attr_free_item(
> +	struct xfs_attr_item		*attr)
> +{
> +	if (attr->xattri_da_state)
> +		xfs_da_state_free(attr->xattri_da_state);
> +	kmem_free(attr);
> +}
> +
>  /* Process an attr. */
>  STATIC int
>  xfs_attr_finish_item(
> @@ -420,7 +429,7 @@ xfs_attr_finish_item(
>  
>  	error = xfs_xattri_finish_update(attr, done_item);
>  	if (error != -EAGAIN)
> -		kmem_free(attr);
> +		xfs_attr_free_item(attr);
>  
>  	return error;
>  }
> @@ -441,7 +450,7 @@ xfs_attr_cancel_item(
>  	struct xfs_attr_item		*attr;
>  
>  	attr = container_of(item, struct xfs_attr_item, xattri_list);
> -	kmem_free(attr);
> +	xfs_attr_free_item(attr);
>  }
>  
>  STATIC xfs_lsn_t
> @@ -613,7 +622,7 @@ xfs_attri_item_recover(
>  	xfs_irele(ip);
>  out:
>  	if (ret != -EAGAIN)
> -		kmem_free(attr);
> +		xfs_attr_free_item(attr);
>  	return error;
>  }
>  
> 

