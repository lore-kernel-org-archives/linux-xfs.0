Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297B0C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 07:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiD1HFm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 03:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiD1HFl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 03:05:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803B87C162
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 00:02:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23S3l9Bo011324;
        Thu, 28 Apr 2022 07:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rbXKq6NmKs81J9vLh6c/DjYUuHOCu9JipFltt7TsaNI=;
 b=jCksjVyTDJxfadi1DjOO3kG6EW60RV2TOt2uk6W87lFT+akUdwqZVSnJFzG8mqB4MNS1
 AHrBbIFQ6/gxmsEUJgLemVlGUXWL4zzjQTgEXDipTmGhUKPmEIfJO5zGUr3a5EJhDOlu
 yFl24N42mNn0vC0cReeEznl6rSX1JryRP3B+1haelgiqd3AyM0pX5ovpG1+NqaXRgkQ9
 4SR6YaMAzLG8g0dScxuuoqoA6VkhMFtJipGalXwh7DOaUjP/YdE6Awbx/jETay887MOv
 AUcEBfvESC+U0c2davdoZAq2YdCfhyG2bdnZnJIyHheajQ/xj69/EOguJeb1EapK59P9 Gg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4k5vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 07:02:24 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23S70C2R019539;
        Thu, 28 Apr 2022 07:02:23 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w62x7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 07:02:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HibrhZON/lLF9+CCzER41K3uKiuHNb1sc8xWgws7ZQQLQZXIg9pyqWylslwrh9eNt0sk5UGaAMG4HcVd4LsX5mGg4fH9Libdf1sisnLe7bB+Dxx3Qx6SFtp6KBLvlIshn7GXUWfxUo6gjTgbN2ac5370IkIaUkHUu03Rpn7ATb5uQ6ah7YYtCRSUGSdgkxWOhupFUP7MnSHMPHKZ4r/XhUzCHY8YtOBeEXrU218DvC4P1a5iG4kau1Ko5bhmsLQAQGxle2cDGGRcfslQroDN6u5yOVbX9wk+Q87bDEaN8E9EP8CUoBLKOWFyUAJjHgcoK6vzUsWSWUPrps8WP5Gnrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbXKq6NmKs81J9vLh6c/DjYUuHOCu9JipFltt7TsaNI=;
 b=VsB4irko4pu6tBQv/q0FoApWL7mJp7o4VHwFKtbL8BMe1x42po4hbqa0yXRM6q0c3jYcs+D3VyJFx7egqwuEcPchHOutGKFIlJv4NSYZX9iiLU1aqM3YT9+t3QvKmdeoTIDoCLmJBoWZphAEN2VjagySsnLXSQTj0Ng+8Pm2cwrzxVWiCzMjDFGonYsclh12l/yF1hrQPnyz9xFnO09WKh5zrDUPGcxucE5ONV7/TiDeCo0QnBYDFHnRanLV+V1Twu/X3iltYd+ULsM/P20j9chBOEoppRZege1+VRNOblCSOfj+awtQ6ZC4W8xNiX53DmA7kZvaXEpk0eYvHz3KnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbXKq6NmKs81J9vLh6c/DjYUuHOCu9JipFltt7TsaNI=;
 b=qW/qB2bhAq3EjdQZ9QAgeLj8CgzSLRPffCxnLf4cYLpCUi7slNi12G4FByV4uU+ywthzm4IxEIddGgaZuXH5+XG90A/94HHTje1O5m0z8TZvIcAzUfibSBW4xmXMAJSmQjpRTkrJKKRx09agA4UXn3rk4Ok49j6FLXD/YN/UqBM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5534.namprd10.prod.outlook.com (2603:10b6:a03:3fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 28 Apr
 2022 07:02:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 07:02:20 +0000
Message-ID: <e2f4ecdf730bda05f4b6dfc04945f206ddc3f450.camel@oracle.com>
Subject: Re: [PATCH 16/16] xfs: ATTR_REPLACE algorithm with LARP enabled
 needs rework
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 28 Apr 2022 00:02:17 -0700
In-Reply-To: <20220414094434.2508781-17-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-17-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0110.namprd05.prod.outlook.com
 (2603:10b6:a03:334::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f2d0de7-f879-42dc-53b8-08da28e509e2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5534:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5534277FE160AA6B9267392095FD9@SJ0PR10MB5534.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iTM+uZBlQEzll8viLpZ/s13RU+XSl400rBtJY89GszBlFmC3pAGBilK+Zr+mqbD1Hgibq/0MZ17HwRHR/VcZEfFxCRu4n9L5pbYVTP/GlEO9072DfRsA5k3ZTelqXzxff8pBgh7a04a9b7rssYZwj5gOfmNWqMFGRFlcVdS3zreo1H5s85+kIkawm0905ydw3bgMzuVakjkBdNb3aOWYxarykoP2onLtzC8KVIHOBIiEG0jXcMUK6FjYcATGqM8bl9orw/Sks74OzqARYyPCCWaKyMJtJXuoVNSJtNNsa+4Zc70HKGNwsFsAQQWTaTKlJjWNH8vFmmb4NCRYeIM5aTFkFaBLR2IsYlefQvpNI7QTF1drbqatm1sHdiltsdona8l5PM0qZ9BYwKV56Q5N7q6emwMYku8ixjuaKuadWICbxig44vyuIljb5IwOsclwhdK+hVd2L/nWOuSe+ZfcFGh1GoEmUP64vSq4u3SFA0jyuZ+duLOC+Puw5F9Mc8H0wnH39ZT+9QqKtNhrGCOJoh2r0p/iK6Adbpaw+iAhjp8zWTBwIyAVzcgoBdCVQO7eWx+CRx/vHMqp4EpLcRt6L+3/HsZ7XXq8odxl0NIyGLQfzJAW5Bqwo4LNYW6dVaRhas0sWNnwuQ3nWqAf2lt45z9dXptSkyjmVRgll8oxufmdoYf5X9sVv7NUpqG8Tc4eiwhMLFKbOoTmyk9eSZ1czAh0xh9A6o3XxbiwZqv00HA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(36756003)(6506007)(52116002)(66476007)(8676002)(66946007)(66556008)(2906002)(83380400001)(186003)(26005)(2616005)(6512007)(86362001)(30864003)(316002)(38100700002)(38350700002)(8936002)(6486002)(508600001)(5660300002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0FVczZxQktYWGpNblk0YWk1OVphVFM4SE9sR2luNDJvY1JNTG1KcWtuNFp1?=
 =?utf-8?B?cnBGK25DdzZDRVEzU2g3RUtRYUgvblhhVitCTm93cXhYY3BYd1FPNGFuLzhR?=
 =?utf-8?B?c1N0STJYSEpBVGdJSDliYXl3bXgvOVpOdytHUmczd2t5ZG1meDM4QWZVYjcw?=
 =?utf-8?B?eGlybjJvY1ZqSWo4eTBHZkxKanQ4azcxN1ZITXZvbC9RTG8xejQ1MkRLVTdL?=
 =?utf-8?B?NVZXUGJOaVhWdmZWK0xEYjJwSC9ma3VrY0lPemlqbVJSWGl3Z3pYTllRdkc0?=
 =?utf-8?B?ZkF5bC9HUFlubkw0cjdwNjQvSEVqYlloL2drS3AyVmg4TTliNHA3dkNTOUtm?=
 =?utf-8?B?czRSTzVUbldVZ2U2V1FNOXFscVllbm9OdjhiQys0S3JuUkY5NEhPRnNqbThD?=
 =?utf-8?B?Q0RnRG9XdWhDN1QzWTdzamN6bk5DOGRqTTZxR0EzSnFlNmEzakJwMXJRaG9m?=
 =?utf-8?B?S2Y4TUpzZktVZGlIWmgrd0diQzNuWGxTRmw3US8wZE5xdW1xWkV5ZXdVcmZl?=
 =?utf-8?B?bVRndVgzZktISDZ6cXhSVGkxMjBPVzd3bHBydEZkTUhmRitNYmhNNUlDb28v?=
 =?utf-8?B?QTJjZUdjMWRDZk5sTkVLazJQUklrSll2a2tqSUxJOERYT3pORmEwVWE4MDRD?=
 =?utf-8?B?WU9aZWl3VFBSaEF5enFvRjdwNml6SzlHUkFQNmNQckJmRW0xVmI1R01ldi9R?=
 =?utf-8?B?cmEvSFB3LzhJbE5wV0FkdG5nVytZN0FzemhnOE9MeWJYc0VkemRIbHEvUEx6?=
 =?utf-8?B?blh0R1R6SGhDNXVLbHZuQ3N6MmJqK2lZS2h6cGRkVFh5VkMxNTQ5bTNpclNE?=
 =?utf-8?B?Z0pyYWluSk11clgxanIxTTQ3bk5lNkMwaWFCTS9HVmxtcXhoWEZGT3hPdjU4?=
 =?utf-8?B?OGw4clFIT2ZESXcvKyt5UWJSQ3F1WVc1MUJWNDNPL004UFRGc0VDQkI1Y0U3?=
 =?utf-8?B?Ymt0NFZaajI5cTdHUTVjYVZjU0JJdWk3c0JhemhRbHY2SFk1L2NmcUNoS1Vm?=
 =?utf-8?B?VEtxVzY1S2lweWt4SlVyeHZZRTdCRUFyaUtmZERIbVI4OW5LeVhCMDdKYXZv?=
 =?utf-8?B?VW5nOGg4cW1DaHIxL2RSbmE1SW43ZW1paThnOGZFTjgxbUxTNmNSUzhrd2VP?=
 =?utf-8?B?RmFoRTJtNXpIZEh0NlZrTW1UKyt2b3p1REM3aCtGZ0x3cmxwMDJzYm43aEx5?=
 =?utf-8?B?bkJDNGhjUm1WclBleCs4UDkyaEU0UXBTRVV1aXJ4Vk9iZWthYkRvL2ptYmJ4?=
 =?utf-8?B?NG5SMENXZkVQM0tqOW9Vc2pqdUVnYjJCVHlrR1lRa21la0hOVTRCQThwN2FF?=
 =?utf-8?B?Wjlkc0NLenh2WG5uYjRjZzZVeloxVjdqZFpHeGRsOWpLcGF5MUpOeTk1Q0Jh?=
 =?utf-8?B?d0RhOGJFODI2UmxKZnRjNkRGaisxeGdSb2V1Sk5NWEZvSFhRSkZKY1FlblNO?=
 =?utf-8?B?Z3JHYjRTalduSnJWeUJDNUt2TU84TEp6QkpDVlh5eFhLV3k5OUgrelp1SHRj?=
 =?utf-8?B?TmxyZmRjT1VVNmxPWmM4WUkyZGN2NDJUNWNrVkxxeCtiQUl2RHE0U202dVQv?=
 =?utf-8?B?eVhjUVZQdFFCZXVxdTJCR3JFZ1VpZmNGMHdDNEZId1NwUVRoeFlSQkhocTNx?=
 =?utf-8?B?cWZpNjFkMUZjQktXYTQxWmlYbW9wMzVadzc1TVpqUnFvenRKcFJKSUdZSERU?=
 =?utf-8?B?VmJNZ2t4TjJ1S08zZktYcXRZbVgxRnZvcU11ekRoTnJiSFN0Z3AwMDNRVlhn?=
 =?utf-8?B?L3krSUY4b21jUk02ZCs2RUI3N0JhY3lKMno3S0huMytJVVRzaTc4dFllMW1G?=
 =?utf-8?B?L2F3ellVK0NEZjFGRGtzTmYxdGZJTXhpd0p4cDZLSVVZNTJRLzZTQThGTmQ0?=
 =?utf-8?B?bUNsVWc4NjcrMlpEYjVVUGVPYUIwYy9VQk5sWktGaVNGZzdyUVZDN1lETFZw?=
 =?utf-8?B?b3FUVTh5VVY0RHhVeVJDc1VrcmlSSHVCVEZUV0FWNnhqaHlWbGplZmp3OW83?=
 =?utf-8?B?ZDBFZS90RU9Nd0FTbUR5ZGlqMWdFcmsxaVRBNGY2WkhaMlh1U0taQnZxSE1K?=
 =?utf-8?B?QnhMckxqUW5JcjJsQ2ZMUzd1d1B5RE9LODRFYi85Y0ZqQk1pTDArU2xUNTBw?=
 =?utf-8?B?ZVQzOXZpZ0ZqMURHY3ZZVE1VZzNDcVZ2MTB6aC9RQUVFNnVSYlZHMlZGemlj?=
 =?utf-8?B?ZUR2dzIxd2hRbzROc0pXbWRYWHk2L3FkM2hCQWRCeWxBaUNyMG5KcHc3RGNY?=
 =?utf-8?B?Wm4vZWhYNjlyR0JVYVdVZElhY1kxb3JuakcwaEVZYTVhaXVRMVR0SE1Tekg1?=
 =?utf-8?B?dnJzbEpkUTZncHF1SUNpd05oZENiOUk5Wnd6dHhTMmZZNDdXOUdFV3BDTkVh?=
 =?utf-8?Q?QoQRoRoRgfvQw/ws=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f2d0de7-f879-42dc-53b8-08da28e509e2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 07:02:20.7764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IGZD3MGNfyFCY38Ky4V1losczFx//uuHRIrbJ2xWZgWL87Ls+RHm0pXF5/fb0wTjNddpCf/J3TQVIX7cAPuM9gpaP+OBKgAcambIFFgYv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5534
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-27_04:2022-04-27,2022-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280042
X-Proofpoint-GUID: QsG_JWxDXNbnIkLwIkPMu_f6e-EMQXps
X-Proofpoint-ORIG-GUID: QsG_JWxDXNbnIkLwIkPMu_f6e-EMQXps
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We can't use the same algorithm for replacing an existing attribute
> when logging attributes. The existing algorithm is essentially:
> 
> 1. create new attr w/ INCOMPLETE
> 2. atomically flip INCOMPLETE flags between old + new attribute
> 3. remove old attr which is marked w/ INCOMPLETE
> 
> This algorithm guarantees that we see either the old or new
> attribute, and if we fail after the atomic flag flip, we don't have
> to recover the removal of the old attr because we never see
> INCOMPLETE attributes in lookups.
> 
> For logged attributes, however, this does not work. The logged
> attribute intents do not track the work that has been done as the
> transaction rolls, and hence the only recovery mechanism we have is
> "run the replace operation from scratch".
> 
> This is further exacerbated by the attempt to avoid needing the
> INCOMPLETE flag to create an atomic swap. This means we can create
> a second active attribute of the same name before we remove the
> original. If we fail at any point after the create but before the
> removal has completed, we end up with duplicate attributes in
> the attr btree and recovery only tries to replace one of them.
> 
> There are several other failure modes where we can leave partially
> allocated remote attributes that expose stale data, partially free
> remote attributes that enable UAF based stale data exposure, etc.
> 
> TO fix this, we need a different algorithm for replace operations
> when LARP is enabled. Luckily, it's not that complex if we take the
> right first step. That is, the first thing we log is the attri
> intent with the new name/value pair and mark the old attr as
> INCOMPLETE in the same transaction.
> 
> From there, we then remove the old attr and keep relogging the
> new name/value in the intent, such that we always know that we have
> to create the new attr in recovery. Once the old attr is removed,
> we then run a normal ATTR_CREATE operation relogging the intent as
> we go. If the new attr is local, then it gets created in a single
> atomic transaction that also logs the final intent done. If the new
> attr is remote, the we set INCOMPLETE on the new attr while we
> allocate and set the remote value, and then we clear the INCOMPLETE
> flag at in the last transaction taht logs the final intent done.
> 
> If we fail at any point in this algorithm, log recovery will always
> see the same state on disk: the new name/value in the intent, and
> either an INCOMPLETE attr or no attr in the attr btree. If we find
> an INCOMPLETE attr, we run the full replace starting with removing
> the INCOMPLETE attr. If we don't find it, then we simply create the
> new attr.
> 
> Notably, recovery of a failed create that has an INCOMPLETE flag set
> is now the same - we start with the lookup of the INCOMPLETE attr,
> and if that exists then we do the full replace recovery process,
> otherwise we just create the new attr.
> 
> Hence changing the way we do the replace operation when LARP is
> enabled allows us to use the same log recovery algorithm for both
> the ATTR_CREATE and ATTR_REPLACE operations. This is also the same
> algorithm we use for runtime ATTR_REPLACE operations (except for the
> step setting up the initial conditions).
> 
> The result is that:
> 
> - ATTR_CREATE uses the same algorithm regardless of whether LARP is
>   enabled or not
> - ATTR_REPLACE with larp=0 is identical to the old algorithm
> - ATTR_REPLACE with larp=1 runs an unmodified attr removal algorithm
>   from the larp=0 code and then runs the unmodified ATTR_CREATE
>   code.
> - log recovery when larp=1 runs the same ATTR_REPLACE algorithm as
>   it uses at runtime.
> 
> Because the state machine is now quite clean, changing the algorithm
> is really just a case of changing the initial state and how the
> states link together for the ATTR_REPLACE case. Hence it's not a
> huge amoutn of code for what is a fairly substantial rework
> of the attr logging and recovery algorithm....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Ok, I think I was able to follow most of this through.  I think it
looks mostly good, I did catch one buggly down below....

> ---
>  fs/xfs/libxfs/xfs_attr.c       | 137 ++++++++++++++-----------------
> --
>  fs/xfs/libxfs/xfs_attr.h       | 101 +++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  22 ++++--
>  fs/xfs/libxfs/xfs_da_btree.h   |   1 +
>  fs/xfs/libxfs/xfs_defer.c      |   2 +
>  fs/xfs/libxfs/xfs_log_format.h |   7 +-
>  fs/xfs/xfs_acl.c               |   2 +-
>  fs/xfs/xfs_attr_item.c         |  27 ++++++-
>  fs/xfs/xfs_ioctl.c             |   2 +-
>  fs/xfs/xfs_trace.h             |  10 +--
>  fs/xfs/xfs_xattr.c             |   2 +-
>  11 files changed, 197 insertions(+), 116 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 772506d44bfa..173144769ddc 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -260,19 +260,6 @@ xfs_attr_try_sf_addname(
>  	return error;
>  }
>  
> -/*
> - * Check to see if the attr should be upgraded from non-existent or
> shortform to
> - * single-leaf-block attribute list.
> - */
> -static inline bool
> -xfs_attr_is_shortform(
> -	struct xfs_inode    *ip)
> -{
> -	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
> -	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> -		ip->i_afp->if_nextents == 0);
> -}
> -
>  static int
>  xfs_attr_sf_addname(
>  	struct xfs_attr_item		*attr)
> @@ -309,20 +296,29 @@ xfs_attr_sf_addname(
>  }
>  
>  /*
> - * When we bump the state to REPLACE, we may actually need to skip
> over the
> - * state. When LARP mode is enabled, we don't need to run the atomic
> flags flip,
> - * so we skip straight over the REPLACE state and go on to
> REMOVE_OLD.
> + * Handle the state change on completion of a multi-state attr
> operation.
> + *
> + * If the XFS_DA_OP_RENAME flag is set, this means the operation was
> the first
> + * modification in a attr replace operation and we still have to do
> the second
> + * state, indicated by @replace_state.
> + *
> + * We consume the XFS_DA_OP_RENAME flag so that when we are called
> again on
> + * completion of the second half of the attr replace operation we
> correctly
> + * signal that it is done.
>   */
> -static void
> -xfs_attr_dela_state_set_replace(
> +static enum xfs_delattr_state
> +xfs_attr_complete_op(
>  	struct xfs_attr_item	*attr,
> -	enum xfs_delattr_state	replace)
> +	enum xfs_delattr_state	replace_state)
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
> +	bool			do_replace = args->op_flags &
> XFS_DA_OP_RENAME;
>  
> -	attr->xattri_dela_state = replace;
> -	if (xfs_has_larp(args->dp->i_mount))
> -		attr->xattri_dela_state++;
> +	args->attr_flags &= ~XATTR_REPLACE;
> +	args->op_flags &= ~XFS_DA_OP_RENAME;
> +	if (do_replace)
> +		return replace_state;
> +	return XFS_DAS_DONE;
>  }
>  
>  static int
> @@ -364,10 +360,9 @@ xfs_attr_leaf_addname(
>  	 */
>  	if (args->rmtblkno)
>  		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
> -	else if (args->op_flags & XFS_DA_OP_RENAME)
> -		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_LEAF_REPLACE);
>  	else
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +							XFS_DAS_LEAF_RE
> PLACE);
>  out:
>  	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state,
> args->dp);
>  	return error;
> @@ -409,10 +404,9 @@ xfs_attr_node_addname(
>  
>  	if (args->rmtblkno)
>  		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
> -	else if (args->op_flags & XFS_DA_OP_RENAME)
> -		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_NODE_REPLACE);
>  	else
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +							XFS_DAS_NODE_RE
> PLACE);
>  out:
>  	trace_xfs_attr_node_addname_return(attr->xattri_dela_state,
> args->dp);
>  	return error;
> @@ -442,18 +436,15 @@ xfs_attr_rmtval_alloc(
>  	if (error)
>  		return error;
>  
> -	/* If this is not a rename, clear the incomplete flag and we're
> done. */
> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> +	attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +						++attr-
> >xattri_dela_state);
> +	/*
> +	 * If we are not doing a rename, we've finished the operation
> but still
> +	 * have to clear the incomplete flag protecting the new attr
> from
> +	 * exposing partially initialised state if we crash during
> creation.
> +	 */
> +	if (attr->xattri_dela_state == XFS_DAS_DONE)
>  		error = xfs_attr3_leaf_clearflag(args);
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> -	} else {
> -		/*
> -		 * We are running a REPLACE operation, so we need to
> bump the
> -		 * state to the step in that operation.
> -		 */
> -		attr->xattri_dela_state++;
> -		xfs_attr_dela_state_set_replace(attr, attr-
> >xattri_dela_state);
> -	}
>  out:
>  	trace_xfs_attr_rmtval_alloc(attr->xattri_dela_state, args->dp);
>  	return error;
> @@ -578,11 +569,15 @@ xfs_attr_set_iter(
>  		return xfs_attr_node_addname(attr);
>  
>  	case XFS_DAS_SF_REMOVE:
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> -		return xfs_attr_sf_removename(args);
> +		error = xfs_attr_sf_removename(args);
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +						xfs_attr_init_add_state
> (args));
> +		break;
>  	case XFS_DAS_LEAF_REMOVE:
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> -		return xfs_attr_leaf_removename(args);
> +		error = xfs_attr_leaf_removename(args);
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +						xfs_attr_init_add_state
> (args));
> +		break;
>  	case XFS_DAS_NODE_REMOVE:
>  		error = xfs_attr_node_removename_setup(attr);
>  		if (error)
> @@ -678,12 +673,14 @@ xfs_attr_set_iter(
>  
>  	case XFS_DAS_LEAF_REMOVE_ATTR:
>  		error = xfs_attr_leaf_remove_attr(attr);
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +						xfs_attr_init_add_state
> (args));
>  		break;
>  
>  	case XFS_DAS_NODE_REMOVE_ATTR:
>  		error = xfs_attr_node_remove_attr(attr);
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +						xfs_attr_init_add_state
> (args));
>  		break;
>  	default:
>  		ASSERT(0);
> @@ -753,14 +750,9 @@ xfs_attr_defer_add(
>  	if (error)
>  		return error;
>  
> -	if (xfs_attr_is_shortform(args->dp))
> -		new->xattri_dela_state = XFS_DAS_SF_ADD;
> -	else if (xfs_attr_is_leaf(args->dp))
> -		new->xattri_dela_state = XFS_DAS_LEAF_ADD;
> -	else
> -		new->xattri_dela_state = XFS_DAS_NODE_ADD;
> -
> +	new->xattri_dela_state = xfs_attr_init_add_state(args);
>  	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> +	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
>  
>  	return 0;
>  }
> @@ -773,18 +765,13 @@ xfs_attr_defer_replace(
>  	struct xfs_attr_item	*new;
>  	int			error = 0;
>  
> -	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REPLACE,
> &new);
>  	if (error)
>  		return error;
>  
> -	if (xfs_attr_is_shortform(args->dp))
> -		new->xattri_dela_state = XFS_DAS_SF_ADD;
> -	else if (xfs_attr_is_leaf(args->dp))
> -		new->xattri_dela_state = XFS_DAS_LEAF_ADD;
> -	else
> -		new->xattri_dela_state = XFS_DAS_NODE_ADD;
> -
> +	new->xattri_dela_state = xfs_attr_init_replace_state(args);
>  	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> +	trace_xfs_attr_defer_replace(new->xattri_dela_state, args->dp);
>  
>  	return 0;
>  }
> @@ -802,14 +789,9 @@ xfs_attr_defer_remove(
>  	if (error)
>  		return error;
>  
> -	if (xfs_attr_is_shortform(args->dp))
> -		new->xattri_dela_state = XFS_DAS_SF_REMOVE;
> -	else if (xfs_attr_is_leaf(args->dp))
> -		new->xattri_dela_state = XFS_DAS_LEAF_REMOVE;
> -	else
> -		new->xattri_dela_state = XFS_DAS_NODE_REMOVE;
> -
> +	new->xattri_dela_state = xfs_attr_init_remove_state(args);
>  	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
> +	trace_xfs_attr_defer_remove(new->xattri_dela_state, args->dp);
>  
>  	return 0;
>  }
> @@ -1032,6 +1014,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  		 * not being around.
>  		 */
>  		args->attr_flags &= ~XATTR_REPLACE;
> +		args->op_flags &= ~XFS_DA_OP_RENAME;
>  	}
>  
>  	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
> @@ -1122,16 +1105,14 @@ xfs_attr_leaf_try_add(
>  			goto out_brelse;
>  
>  		trace_xfs_attr_leaf_replace(args);
> -
> -		/* save the attribute state for later removal*/
> -		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic
> rename */
> -		xfs_attr_save_rmt_blk(args);
> +		ASSERT(args->op_flags & XFS_DA_OP_RENAME);
>  
>  		/*
> -		 * clear the remote attr state now that it is saved so
> that the
> -		 * values reflect the state of the attribute we are
> about to
> +		 * Save the existing remote attr state so that the
> current
> +		 * values reflect the state of the new attribute we are
> about to
>  		 * add, not the attribute we just found and will remove
> later.
>  		 */
> +		xfs_attr_save_rmt_blk(args);
>  		args->rmtblkno = 0;
>  		args->rmtblkcnt = 0;
>  		args->rmtvaluelen = 0;
> @@ -1293,16 +1274,14 @@ xfs_attr_node_addname_find_attr(
>  			goto error;
>  
>  		trace_xfs_attr_node_replace(args);
> -
> -		/* save the attribute state for later removal*/
> -		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic
> rename op */
> -		xfs_attr_save_rmt_blk(args);
> +		ASSERT(args->op_flags & XFS_DA_OP_RENAME);
>  
>  		/*
> -		 * clear the remote attr state now that it is saved so
> that the
> -		 * values reflect the state of the attribute we are
> about to
> +		 * Save the existing remote attr state so that the
> current
> +		 * values reflect the state of the new attribute we are
> about to
>  		 * add, not the attribute we just found and will remove
> later.
>  		 */
> +		xfs_attr_save_rmt_blk(args);
>  		args->rmtblkno = 0;
>  		args->rmtblkcnt = 0;
>  		args->rmtvaluelen = 0;
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index cac7dfcf2dbe..49c89c49e7eb 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -444,18 +444,23 @@ struct xfs_attr_list_context {
>   */
>  enum xfs_delattr_state {
>  	XFS_DAS_UNINIT		= 0,	/* No state has been set yet
> */
> -	XFS_DAS_SF_ADD,			/* Initial shortform set iter
> state */
> -	XFS_DAS_LEAF_ADD,		/* Initial leaf form set iter state
> */
> -	XFS_DAS_NODE_ADD,		/* Initial node form set iter state
> */
> -	XFS_DAS_RMTBLK,			/* Removing remote blks */
> -	XFS_DAS_RM_NAME,		/* Remove attr name */
> -	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree
> */
> -
> -	XFS_DAS_SF_REMOVE,		/* Initial shortform set iter
> state */
> -	XFS_DAS_LEAF_REMOVE,		/* Initial leaf form set iter
> state */
> -	XFS_DAS_NODE_REMOVE,		/* Initial node form set iter
> state */
> -
> -	/* Leaf state set/replace sequence */
> +
> +	/*
> +	 * Initial sequence states. The replace setup code relies on
> the
> +	 * ADD and REMOVE states for a specific format to be sequential
> so
> +	 * that we can transform the initial operation to be performed
> +	 * according to the xfs_has_larp() state easily.
> +	 */
> +	XFS_DAS_SF_ADD,			/* Initial sf add state */
> +	XFS_DAS_SF_REMOVE,		/* Initial sf replace/remove
> state */
> +
> +	XFS_DAS_LEAF_ADD,		/* Initial leaf add state */
> +	XFS_DAS_LEAF_REMOVE,		/* Initial leaf
> replace/remove state */
> +
> +	XFS_DAS_NODE_ADD,		/* Initial node add state */
> +	XFS_DAS_NODE_REMOVE,		/* Initial node
> replace/remove state */
> +
> +	/* Leaf state set/replace/remove sequence */
>  	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a
> leaf */
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a
> leaf */
> @@ -463,7 +468,7 @@ enum xfs_delattr_state {
>  	XFS_DAS_LEAF_REMOVE_RMT,	/* A rename is removing remote blocks
> */
>  	XFS_DAS_LEAF_REMOVE_ATTR,	/* Remove the old attr from a leaf */
>  
> -	/* Node state set/replace sequence, must match leaf state above
> */
> +	/* Node state sequence, must match leaf state above */
>  	XFS_DAS_NODE_SET_RMT,		/* set a remote xattr from a
> node */
>  	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a
> node */
> @@ -477,11 +482,11 @@ enum xfs_delattr_state {
>  #define XFS_DAS_STRINGS	\
>  	{ XFS_DAS_UNINIT,		"XFS_DAS_UNINIT" }, \
>  	{ XFS_DAS_SF_ADD,		"XFS_DAS_SF_ADD" }, \
> +	{ XFS_DAS_SF_REMOVE,		"XFS_DAS_SF_REMOVE" }, \
>  	{ XFS_DAS_LEAF_ADD,		"XFS_DAS_LEAF_ADD" }, \
> +	{ XFS_DAS_LEAF_REMOVE,		"XFS_DAS_LEAF_REMOVE" }, \
>  	{ XFS_DAS_NODE_ADD,		"XFS_DAS_NODE_ADD" }, \
> -	{ XFS_DAS_RMTBLK,		"XFS_DAS_RMTBLK" }, \
> -	{ XFS_DAS_RM_NAME,		"XFS_DAS_RM_NAME" }, \
> -	{ XFS_DAS_RM_SHRINK,		"XFS_DAS_RM_SHRINK" }, \
> +	{ XFS_DAS_NODE_REMOVE,		"XFS_DAS_NODE_REMOVE" }, \
>  	{ XFS_DAS_LEAF_SET_RMT,		"XFS_DAS_LEAF_SET_RMT" }, \
>  	{ XFS_DAS_LEAF_ALLOC_RMT,	"XFS_DAS_LEAF_ALLOC_RMT" }, \
>  	{ XFS_DAS_LEAF_REPLACE,		"XFS_DAS_LEAF_REPLACE" }, \
> @@ -525,8 +530,7 @@ struct xfs_attr_item {
>  	enum xfs_delattr_state		xattri_dela_state;
>  
>  	/*
> -	 * Indicates if the attr operation is a set or a remove
> -	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
> +	 * Attr operation being performed - XFS_ATTR_OP_FLAGS_*
>  	 */
>  	unsigned int			xattri_op_flags;
>  
> @@ -568,4 +572,65 @@ void xfs_attri_destroy_cache(void);
>  int __init xfs_attrd_init_cache(void);
>  void xfs_attrd_destroy_cache(void);
>  
> +/*
> + * Check to see if the attr should be upgraded from non-existent or
> shortform to
> + * single-leaf-block attribute list.
> + */
> +static inline bool
> +xfs_attr_is_shortform(
> +	struct xfs_inode    *ip)
> +{
> +	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
> +	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> +		ip->i_afp->if_nextents == 0);
> +}
> +
> +static inline enum xfs_delattr_state
> +xfs_attr_init_add_state(struct xfs_da_args *args)
> +{
> +	/*
> +	 * On a pure remove, we can remove the attr fork so when we are
> +	 * called to set the add state after the remove to set up the
> next
> +	 * replace state, we can hit this case here. However, we will
> not see
> +	 * an empty fork on logged replace operation, so if there is no
> attr
> +	 * fork then we are done here.
> +	 *
> +	 * XXX: The replace state changeover needs a bit of rework to
> +	 * avoid this quirk.
> +	 */
> +	if (!args->dp->i_afp)
> +		return XFS_DAS_DONE;
> +	if (xfs_attr_is_shortform(args->dp))
> +		return XFS_DAS_SF_ADD;
> +	if (xfs_attr_is_leaf(args->dp))
> +		return XFS_DAS_LEAF_ADD;
> +	return XFS_DAS_NODE_ADD;
> +}
> +
> +static inline enum xfs_delattr_state
> +xfs_attr_init_remove_state(struct xfs_da_args *args)
> +{
> +	if (xfs_attr_is_shortform(args->dp))
> +		return XFS_DAS_SF_REMOVE;
> +	if (xfs_attr_is_leaf(args->dp))
> +		return XFS_DAS_LEAF_REMOVE;
> +	return XFS_DAS_NODE_REMOVE;
> +}
> +
> +/*
> + * If we are logging the attributes, then we have to start with
> removal of the
> + * old attribute so that there is always consistent state that we
> can recover
> + * from if the system goes down part way through. We always log the
> new attr
> + * value, so even when we remove the attr first we still have the
> information in
> + * the log to finish the replace operation atomically.
> + */
> +static inline enum xfs_delattr_state
> +xfs_attr_init_replace_state(struct xfs_da_args *args)
> +{
> +	args->op_flags |= XFS_DA_OP_RENAME;
> +	if (xfs_has_larp(args->dp->i_mount))
> +		return xfs_attr_init_remove_state(args);
> +	return xfs_attr_init_add_state(args);
> +}
> +
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c
> b/fs/xfs/libxfs/xfs_attr_leaf.c
> index e90bfd9d7551..ff5ed9319270 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -446,6 +446,14 @@ xfs_attr3_leaf_read(
>   * Namespace helper routines
>  
> *====================================================================
> ====*/
>  
> +/*
> + * If we are in log recovery, then we want the lookup to ignore the
> INCOMPLETE
> + * flag on disk - if there's an incomplete attr then recovery needs
> to tear it
> + * down. If there's no incomplete attr, then recovery needs to tear
> that attr
> + * down to replace it with the attr that has been logged. In this
> case, the
> + * INCOMPLETE flag will not be set in attr->attr_filter, but rather
> + * XFS_DA_OP_RECOVERY will be set in args->op_flags.
> + */
>  static bool
>  xfs_attr_match(
>  	struct xfs_da_args	*args,
> @@ -453,14 +461,18 @@ xfs_attr_match(
>  	unsigned char		*name,
>  	int			flags)
>  {
> +
>  	if (args->namelen != namelen)
>  		return false;
>  	if (memcmp(args->name, name, namelen) != 0)
>  		return false;
> -	/*
> -	 * If we are looking for incomplete entries, show only those,
> else only
> -	 * show complete entries.
> -	 */
> +
> +	/* Recovery ignores the INCOMPLETE flag. */
> +	if ((args->op_flags & XFS_DA_OP_RECOVERY) &&
> +	    args->attr_filter == (flags & XFS_ATTR_NSP_ONDISK_MASK))
> +		return true;
> +
> +	/* All remaining matches need to be filtered by INCOMPLETE
> state. */
>  	if (args->attr_filter !=
>  	    (flags & (XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE)))
>  		return false;
> @@ -819,7 +831,7 @@ xfs_attr_sf_removename(
>  	totsize -= size;
>  	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp)
> &&
>  	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
> -	    !(args->op_flags & XFS_DA_OP_ADDNAME)) {
> +	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_RENAME)))
> {
>  		xfs_attr_fork_remove(dp, args->trans);
>  	} else {
>  		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h
> b/fs/xfs/libxfs/xfs_da_btree.h
> index deb368d041e3..ca207d11bf66 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -90,6 +90,7 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else
> die */
>  #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if
> found */
>  #define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode
> timestamps */
> +#define XFS_DA_OP_RECOVERY	(1u << 6) /* running a recovery
> operation */
>  
>  #define XFS_DA_OP_FLAGS \
>  	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index cac921ac18a8..991dee79c29c 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -23,6 +23,8 @@
>  #include "xfs_bmap.h"
>  #include "xfs_alloc.h"
>  #include "xfs_buf.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  
>  static struct kmem_cache	*xfs_defer_pending_cache;
> diff --git a/fs/xfs/libxfs/xfs_log_format.h
> b/fs/xfs/libxfs/xfs_log_format.h
> index a27492e99673..e430f294c747 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -906,9 +906,10 @@ struct xfs_icreate_log {
>   * Flags for deferred attribute operations.
>   * Upper bits are flags, lower byte is type code
>   */
> -#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute
> */
> -#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
> -#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
> +#define XFS_ATTR_OP_FLAGS_SET		(1u << 0) /* Set the
> attribute */
> +#define XFS_ATTR_OP_FLAGS_REMOVE	(1u << 1) /* Remove the
> attribute */
> +#define XFS_ATTR_OP_FLAGS_REPLACE	(1u << 2) /* Replace the
> attribute */
> +#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	  /* Flags type mask
> */
>  
>  /*
>   * This is the structure used to lay out an attr log item in the
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 5c52ee869272..df3059490af9 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -10,12 +10,12 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> -#include "xfs_attr.h"
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
>  #include "xfs_acl.h"
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
> +#include "xfs_attr.h"
>  #include "xfs_trans.h"
>  
>  #include <linux/posix_acl_xattr.h>
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 39af681897a2..a46379a9e9df 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -490,9 +490,14 @@ xfs_attri_validate(
>  	if (attrp->__pad != 0)
>  		return false;
>  
> -	/* alfi_op_flags should be either a set or remove */
> -	if (op != XFS_ATTR_OP_FLAGS_SET && op !=
> XFS_ATTR_OP_FLAGS_REMOVE)
> +	switch (op) {
> +	case XFS_ATTR_OP_FLAGS_SET:
> +	case XFS_ATTR_OP_FLAGS_REMOVE:
> +	case XFS_ATTR_OP_FLAGS_REPLACE:
> +		break;
> +	default:
>  		return false;
> +	}
>  
>  	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
>  		return false;
> @@ -553,11 +558,27 @@ xfs_attri_item_recover(
>  	args->namelen = attrp->alfi_name_len;
>  	args->hashval = xfs_da_hashname(args->name, args->namelen);
>  	args->attr_filter = attrp->alfi_attr_flags;
> +	args->op_flags = XFS_DA_OP_RECOVERY;
>  
> -	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
> +	switch (attr->xattri_op_flags) {
> +	case XFS_ATTR_OP_FLAGS_SET:
> +	case XFS_ATTR_OP_FLAGS_REPLACE:
>  		args->value = attrip->attri_value;
>  		args->valuelen = attrp->alfi_value_len;
>  		args->total = xfs_attr_calc_size(args, &local);
> +		if (xfs_inode_hasattr(args->dp))
I ran into a test failure and tracked it down to the above line.  I
suspect because xfs_inode_hasattr only checks to see if the inode has
an attr fork, it doesnt actually check to see if it has the attr we're
replacing.  So we fall into the replace code path where it should have
been the set code path.  If I replace it with the below line, the
failure is resolved:

	if (attr->xattri_op_flags == XFS_ATTR_OP_FLAGS_REPLACE)

I only encountered this bug after running with parent pointers though
which generates a lot more activity, but I figure it's not a bad idea
to catch things early.  There's one more test failure it's picking up,
though I havnt figured out the cause just yet.

The rest looks good though, I see the below lines address the issue of
the states needing to be initialized in the replay paths, so that
addresses the concerns in patches 4 and 13.  Thanks for all the larp
improvements!

Allison

> +			attr->xattri_dela_state =
> xfs_attr_init_replace_state(args);
> +		else
> +			attr->xattri_dela_state =
> xfs_attr_init_add_state(args);
> +		break;
> +	case XFS_ATTR_OP_FLAGS_REMOVE:
> +		if (!xfs_inode_hasattr(args->dp))
> +			goto out;
> +		attr->xattri_dela_state =
> xfs_attr_init_remove_state(args);
> +		break;
> +	default:
> +		error = -EFSCORRUPTED;
> +		goto out;
>  	}
>  
>  	xfs_init_attr_trans(args, &tres, &total);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index e9eadc7337ce..64254895d083 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -15,7 +15,6 @@
>  #include "xfs_iwalk.h"
>  #include "xfs_itable.h"
>  #include "xfs_error.h"
> -#include "xfs_attr.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
>  #include "xfs_fsops.h"
> @@ -37,6 +36,7 @@
>  #include "xfs_ioctl.h"
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
> +#include "xfs_attr.h"
>  
>  #include <linux/mount.h>
>  #include <linux/namei.h>
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index c85bab6215e1..8783aeb096c4 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4100,13 +4100,10 @@ DEFINE_ICLOG_EVENT(xlog_iclog_write);
>  
>  TRACE_DEFINE_ENUM(XFS_DAS_UNINIT);
>  TRACE_DEFINE_ENUM(XFS_DAS_SF_ADD);
> -TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ADD);
> -TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
> -TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
> -TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
> -TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
>  TRACE_DEFINE_ENUM(XFS_DAS_SF_REMOVE);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ADD);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
> @@ -4142,6 +4139,9 @@ DECLARE_EVENT_CLASS(xfs_das_state_class,
>  DEFINE_EVENT(xfs_das_state_class, name, \
>  	TP_PROTO(int das, struct xfs_inode *ip), \
>  	TP_ARGS(das, ip))
> +DEFINE_DAS_STATE_EVENT(xfs_attr_defer_add);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_defer_replace);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_defer_remove);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 0d050f8829ef..6935edcaa112 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -12,9 +12,9 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> -#include "xfs_attr.h"
>  #include "xfs_acl.h"
>  #include "xfs_da_btree.h"
> +#include "xfs_attr.h"
>  
>  #include <linux/posix_acl_xattr.h>
>  

