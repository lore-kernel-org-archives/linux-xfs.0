Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9E6C636CD
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Feb 2023 13:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjBJNmB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Feb 2023 08:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjBJNmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Feb 2023 08:42:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F71241FB
        for <linux-xfs@vger.kernel.org>; Fri, 10 Feb 2023 05:41:58 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AAo8Yo003528;
        Fri, 10 Feb 2023 13:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=bsuwjPzMjxhKuhbUUk/tpiwR1X/0GhRYaHXNAaHtGvc=;
 b=QCnl/B8h4KJ8f8AX00a66/MG12ahGYx1Bi9d4kkf7X1gW2l5ck58CoWO8EA/qSbeq7+N
 lkuvm7u9jwl5uPdJ60/3FVf02YDVANWhiKfApzaz3OEgrC5vdKJ2gbuyTGP2tP570gOw
 Bloa0GYK6O3tro0kakg6gyEzbarrmXdlivIapz8GDH+6yykrg0L3A0CblHJ365nsb0XO
 jXnud9bdARyHIDCc5dB0tSz8fApsEmKTGy8YlP5v1fm9qk3VY533yDiIPtgevtyfO3Kz
 wl+ZFgf7q4RQdCdYyzMyzbbtijls27IB6vo7sFhyN21ktK2vUl/Kmj5tKVPJb3MT7wNg uQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwud7d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 13:41:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31ADfbBB013716;
        Fri, 10 Feb 2023 13:41:53 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdta91m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 13:41:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8BO5iQamSfbYp/jLkkSXjh5LIozYf2xqnrGCLgWxNDhxgKHKJMfuWYQ1L/r87XFNaXFtBXClkEXMzr1RC/uOnjtQsmNNiwJj2RxFXdNC/Js37gJUP51UyaEE4ppU0cSubGnbhBTFgOmFbX1ByNKGw+Lo/U1b6f3dvzsYC8SpjCFqV8k5MQOqyo6ynKbO/vqc+dNTYEpHKIdWc+23HPIW6Wuesf/ewSPvDW5qR69wcm9KJovs/RCxfkY3+jyOyQQdRPTgkGbtw3anKCekQcDOIT67dxQ7yRp8wYLxZxqC+DNSwmC8DZ6Nr7PN85JXmk7LsbsMyEK9olbTiumEaJJCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bsuwjPzMjxhKuhbUUk/tpiwR1X/0GhRYaHXNAaHtGvc=;
 b=h3KCtjwM2igtLVZ1Cx0B0ZDjflnRYM2DYpRA7cwZkHcGdV5cWUxRqTHtMBO+nJQmYeBUPoLUjXliGnmmc3jL2VRkCjXBkx4ECRxdWlDRbUkcwp5NdauVT9oeOQ+5PViH1NvrqQ0pHvIFn+O19hg2OhwgznM9OYLbWMvl29gB2l+2BfsvlQjNyzDJWDQIu5wflhxjepzDY0XtK7QLXBrYR/OxLpcsEqqpvJ6hAgnIq6YlnNVIVXCCobtQ3ulfJ4gv2TKebx6WD4X1fwt3sPojw81DLH0pxh0kf9TOT16yIhtjXejqzDped4PqJsMPiTr6R/k0+qwajSVSjEiZ7NPJiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsuwjPzMjxhKuhbUUk/tpiwR1X/0GhRYaHXNAaHtGvc=;
 b=Mih/8rjedRviafENgXG9XxtAEwFtmgOIJcrFGxkK0G+frhrwsg5jKV7+J3EyPRUXZE54W0VcxcDoxoc/WfnZurbnQ5qw+TFsyN5vEYf5HxLEC6vDe+CqK90PwTHiGvSBjPO1xNFa+emyF00GMnwar3B3YJ/OwQPFp3yzOCEyhWc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CY5PR10MB5939.namprd10.prod.outlook.com (2603:10b6:930:e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 13:41:51 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6086.015; Fri, 10 Feb 2023
 13:41:51 +0000
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
 <CAOQ4uxgmHzWcxBDrzRb19ByCnNoayhha_MZ_eYN0YMC=RGTeMw@mail.gmail.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>, linux-xfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE 00/10] more xfs fixes for 5.15
Date:   Fri, 10 Feb 2023 18:41:04 +0530
In-reply-to: <CAOQ4uxgmHzWcxBDrzRb19ByCnNoayhha_MZ_eYN0YMC=RGTeMw@mail.gmail.com>
Message-ID: <874jrtzlgp.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0018.apcprd03.prod.outlook.com
 (2603:1096:404:14::30) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CY5PR10MB5939:EE_
X-MS-Office365-Filtering-Correlation-Id: ec5021a9-f204-47f9-90d7-08db0b6c909a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XWm+ELv1CJbNdB03iLqsUBXnt7c+O31TTayvkvTB0uZOqA9fGv3WDtq53Jx7v/iSkIxLwezD67hqrN2I49Z9BXD/gU0PEQGRRU8cNo4bXg02PpEJuSoZeTL5jHpsgAD0S9DSoCS0k6pCuBK0fyznNtLb9rpVvccV8/x4L0Bd6G/xbiu3qBXUV3kFaTCpPwRGX22m1rEEGYnouwAhl/3rxhP3YgRMhsYA6ZWG6nwJp+8xjKhO28EQd0wxSUvJh5QEBJTOv2rDHFgNGfInJ4izAPS6QuwKe1lLXkYepXI4vc5EtUJVO++3V9QIF/fAc99SHhrZ29dedoGg6aTtnWFCZ2wynH0uhrY7AZ5PklGEf4ZDwg56UKj6Sv56qjGmuBGC8XgVIvRjv4czyNhbS3wwSsrf2xqRCYiyicqg+OgVR94kA6yehjDntNVGYx1Uz+qw4kyI6FmMCrSd1t+XdUtB2h5O7l/EaxT67TjB95uPLWnZgnDWcjeTdiLJ9K8V9x95HDZ7V1mbGPZeEKKsMaCZtDqy9RqRJMJJLv2/hGlXwOzdwAjAT2jvL8yHhBT5zlLbsSGFs6vsHLMAil6F5oxTtEgjIJ4nLu4e686PRWIEdyxOtIEAmoL9s+3mjVLdqSBdDdPsvmbG4Ptdg+5YzGlxsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(376002)(136003)(366004)(396003)(346002)(451199018)(54906003)(86362001)(66946007)(4326008)(6486002)(41300700001)(6916009)(8676002)(33716001)(66556008)(83380400001)(6666004)(478600001)(66476007)(316002)(2906002)(38100700002)(53546011)(6512007)(9686003)(26005)(186003)(8936002)(6506007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i7ybM2QAIksjwlG/8FLr8A648KtiftgGIZSfDPcWPG1OteUiO6L9hvLsLV1O?=
 =?us-ascii?Q?u5KPIWCanyQh2IkSgHvLCt88muTUo5cHRf1kQGPCx4JBaIjJBgyE4B9+eyjl?=
 =?us-ascii?Q?jfyWqUV9Is1fhNa5h8dCPU2WiVaPMlUQCvfJ++AeaXV2DD+HELAHApu1F4TU?=
 =?us-ascii?Q?rxtshHe9fvwwWG+09CtOYdyc6ePMfK9hSQcRsYLw/6hqtG7hrSTRMRaCyPuC?=
 =?us-ascii?Q?Zx8IdD0AruR3PL+tEn6gqzKrk4C5EVyChSVLyDu6vSWqp/ShQIMhIKLw0Iwh?=
 =?us-ascii?Q?5UnQ9qbaYlPlII3sCuHO30fu+uZMey5QqB1UneAHdB7LYg2x2jDFDRaWe1zy?=
 =?us-ascii?Q?fLI89V/AIMoVddg7j22j8i+j5lHfM9BnSLI7CITJaoqLV+SHdt7QssYZJVEy?=
 =?us-ascii?Q?qtwt2SeeU2fmqTFj0u9jhcz+V33+v9V0aQigsA0NFaMeqA6GAjk05aIXob8w?=
 =?us-ascii?Q?jMwNSKqQ61j2C+6bHzB+hPwh2esGcM+sTW9c70ZHswY2yPnbvkq7tYcy6Bry?=
 =?us-ascii?Q?lHLRb/MgdqBsYws+BLtoyahFGouuTJEdllIDLTEx9gU/luS2fA8rxQjhoYl6?=
 =?us-ascii?Q?eOX9XTe3aL8C5Z3HUM1r7mt0vWyss0Qq7RNE2GSBX1dJJQKIMvV0qz4OF/EM?=
 =?us-ascii?Q?4OMmmrTEB/DnQzSd5CNYOWFko/m7C7kYapcifVCksLKnquz1Y7iAA9+jENkP?=
 =?us-ascii?Q?GDPRsSn05YLbpHINJLM14wMRSxyvbz/xdB/cVFeeisaD1nzRbJg2a0Zl2yPR?=
 =?us-ascii?Q?kGcEQX0IDLBT+ZY9SiX09I7Y6QNEL0qZfW5McHyRZVQV38MI5TyaLfoN4ozm?=
 =?us-ascii?Q?/esNqK7g/sM7XgFZehQjgCMIXc5UQgIYTBYBqZg2mcLyPnVk1uGWx/TgW5S7?=
 =?us-ascii?Q?RZjEt5/rSLMaHY1apaBi/Lh9VRQ0fs5qinya6fW9SMBCEjSxXOFmazQ2tl87?=
 =?us-ascii?Q?rejbQFC9wewh7jDxXvFvRnPxdr1QMFbIonq4E6Omg3dsIz9RBcljVOGGynQz?=
 =?us-ascii?Q?I6BdZ0Aca96d9KiiYRGkm1jfvdceT7eZAvTebZW6t0hicfLE9T9NyiDCIuuH?=
 =?us-ascii?Q?nrjA6LgZ/NkxudevZ6wKy6yw0dM8s1OrWhjxfJ08LIwbv/cq4de2Y0Fipejg?=
 =?us-ascii?Q?twJGGrd6YV+yJBQUkO9aD/3NmgO+QF+RScOdtVju2IZZeefGTNHm1anTbr3n?=
 =?us-ascii?Q?YuKS123mBF5vkQPoi0tZUD68k3erSIyxKWdn9HtCNpbiWrBZEEB56PDIqN9J?=
 =?us-ascii?Q?xZP5Wpr+nSF0uCj2YfFJKT2VZOytNm0khdFih9to8agjhy29rduhSjxBUr9p?=
 =?us-ascii?Q?ZZFTjH0ZRlHQyIQ8Rx/rnWvWoEjbSXTYPWTZ4Ii1F4sjhaAJORGrXXLZi5aY?=
 =?us-ascii?Q?4iQY2Y/38SWf3BNYLQd3o7gjygwF5NgGOyuDx7/p6WrerRzcJW2cPe4myGBH?=
 =?us-ascii?Q?DGcL8G2RM40lhfd9xAo+EiPdicF2HMbhM7SjficXo5XPKTtcuOSKJDBNVJ3U?=
 =?us-ascii?Q?YUnyyPdt8fmp2S8Q2tdHP2WNFV65PnZwh7nNHjCMO2XkDMWuWhdX8Cm4Ez2l?=
 =?us-ascii?Q?tempdAgYyh5glX1Iiu5xqBMrwtmZHXiePHmm1A1VHslaIFyiu+PJyvzx9QIn?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bVURRj0GlR/k37UhZyJT6P5KkjX1EctTI+WeA9Q00JWp8cL7xfpOYb5h2PJC8SB6f4x06UZh+quxwh5dLg1tDpaHM0k2jpu8fhk+SOC9cq7qf2ZrU8hBDEiiHHQNIHcNS+c45QjMO5+ciEHgNI5zSwzscT/lezoR2DN6KHRdGhzGYMXFuxvM9alqstbEG2wIjtie48LO/IxsyRyIpeBNVGqF2H4F9zR/bChIrYLu5Atf3o8et19miOdPqeOERIqXFjEo3iRFep8kxUYLP2QjgTombxQx939DdhsD90yErxQzrZ+ZvC0IDGzdmiExh0Ik6enphlaGlBz+3d35/jdCofUoABZre1kUluX27X50XhPTwR7ZuF+Vsc+v2oMK5u0KXvnuWWUwthTJ5FlbwU/KU1g4NoyXJBsoZmU0eF/gsj8HxlW5BH1YPnmGrymDXhpU/fiKkt1b4h+IwOp6vn/bUU52WNxATcE1v9bDhyjRLc+cN+dX7o6I578fuksTo/+1xf/jKAp6u0CClrC8o5c4h06UJsFFgKgaZEdd8grVUzWi/UHpubRCD66GU2wUTV2a601Mdm+X6M2ktMAt0BK/9VlXlWDmo/UhM8gbictfy/5jtIkAywUKkHQOktw4rpCdmslWMbWdKPPdFyxoZMx1EK5fPHfW7Hmgx1h0brx+4wu9Q+cea6LxYVbTM4hs08rYtQoeoICuI5ktR5qLSWpWHz9IxjHdqXj/9IfqlMbwN5bjIKQCss6N9WwGFwcVAbMTrt4IcTyhf/4q+ldp4Q1qsS1ETcnV2zltCPm1FIhRf8vmZW+54t4MAwDFVnZtzY2S
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec5021a9-f204-47f9-90d7-08db0b6c909a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:41:51.5041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkB1MXBWxZQ7Zz+m6EFkFFpGzFtHats+I0KEVP+y2gW5HhgRMDny3ZGnZMKA//Nr3Qe2fOCFc5uSH/2rTlP8+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5939
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_08,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100112
X-Proofpoint-GUID: YEYHsshgRhuu5FwXc1po7iiCde6rKwlA
X-Proofpoint-ORIG-GUID: YEYHsshgRhuu5FwXc1po7iiCde6rKwlA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 08, 2023 at 09:02:58 PM +0200, Amir Goldstein wrote:
> On Wed, Feb 8, 2023 at 7:52 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
>>
>> Hello again,
>>
>> Here is the next batch of backports for 5.15.y. Testing included
>> 25 runs of auto group on 12 xfs configs. No regressions were seen.
>> I checked xfs/538 was run without issue as this test was mentioned
>> in 56486f307100. Also, from 86d40f1e49e9, I ran ran xfs/117 with
>> XFS compiled as a module and TEST_FS_MODULE_REOLOAD set, but I was
>> unable to reproduce the issue.
>
> Did you find any tests that started to pass or whose failure rate reduced?
>
> There are very few Fixes: annotations in these commits so it is hard for
> me to assess if any of them are relevant/important/worth the effort/risk
> to backport to 5.10.
>
> Unless I know of reproducible bugs in 5.10, I don't think I will invest
> in backporting this series to 5.10.
> Chandan, if you find any of these fixes relevant and important for 5.4
> let me know and I will make the effort to consider them for 5.10.

Amir, Please find my observations listed below,

Patch 1: Intent whiteouts was designed to overcome performance problems with
delayed attributes feature. Hence this patch will not be needed for v5.4-LTS.

Patch 2: This patch won't be needed since this memory leak is prevalent mostly
when intent whiteouts are being used.

Patch 3: IMHO this fix does not need to be back-ported since ondisk btree
cycles are close to impossible to occur during regular operation of an XFS
filesystem.

Patch 4: This patch won't be needed since xfs_mount->m_features isn't present
in v5.4 xfsprogs.

Patch 5: I am not sure about this one. May be mkfs.xfs has always created V5
filesystems with the required V4 feature flags set and probably fuzzing is the
only way we could modify a V5 filesystem to have some of the required V4
feature flags disabled.
I don't think this patch needs to be backported if my assumptions are true.

Patch 6: This patch does not need to be backported since this fixes a
performance regression introduced by the third patch.

Patch 7: I will want to backport this patch since it will prevent
recovery-loop test execution from stalling.

Patch 8: I think backporting XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag to
5.4-LTS will be helpful since xfs/538 has revealed some important bugs. Patch
8 needs to backported after backporting patches relevant to
XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT.

Patch 9: I think this patch needs to be backported to prevent kmemleak
warnings.

Patch 10: I would backport this patch since this can prevent kmemleak warnings
from showing up (even though the bug was detected after the third patch was
applied).

But maybe you could wait until I come across these patches when working on
backporting commits from v5.11 and newer versions of the kernel. I will share
the list of candidate patches with you. Once we agree upon the list of
patches, you could then backport them to v5.10-LTS.

-- 
chandan
