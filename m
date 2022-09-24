Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13B8C07E9D
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Sep 2022 12:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiIXMqi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Sep 2022 08:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIXMqh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Sep 2022 08:46:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A39E13F16
        for <linux-xfs@vger.kernel.org>; Sat, 24 Sep 2022 05:46:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OCh5RV000690;
        Sat, 24 Sep 2022 12:46:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=BJzmN3N4eqQZi5XiWqD8v9EM4JtGHpBgtch5Gm5PtRE=;
 b=XbaqtHffFwZVPJqO6+ahTp5xWPbYPQJVpurH2KtiTx7l/0CxG5WGrF2I6q2shTX1V3Aj
 ERqXE/vLprJ/fgPw/AVqwSt+T9HaSXWV0neVoSW6pnx6JdVD7aWyTNYQi9QkX+y7vf7b
 r7rr28Mc1lC192zOiGycCvH6Pmwg+QA2A222QrpA2wEHSvFMNMY4azz7BAeNmoa84AE2
 Y3xeNlYbN6fLqWuV7Gj2EJTmTdU5g/eoTNdcsgFExMG4uUXMJO3WIKA4r7rV7nwnUXqA
 /ts5McKhL/MwSm6GmuUg25ipSsHT932D1wQDFBK/uvvGQ8ka8O3/ni4MXvmHSAsZPSci aQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrw8gvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:46:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28OCfAPZ021076;
        Sat, 24 Sep 2022 12:46:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1gpsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:46:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5j35s0CkeN0fmLeCNd6Bu8ECJU08dgkO+kn8Gh0NayZOI8a2WhKwX7jeXbkyoX0oCCQp8G2q4jgU/j+PYb7IXfvkxwmrIYj1V68l9PXwnO5F1UzbeQPOSxmhp9S7tqiP46ippATmiUj9omJHZos0EihOR2dBLBMg1EhsMqv70KDIOrmRkcVezYLjO1SY7IcwDlQbSDCczwGJdDNFAWUR8sIlw2gkgucQomXwQ/H+WNHRzhDepusCQfGtVtk/kfL46Jlqo3YFPf2jvRaldhwf3TJhYk+I2C1jkqMREFEHKSIKvmFIFIJ2mlMNWnxDMSiSUccPEEvsunIfa40WXSOqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJzmN3N4eqQZi5XiWqD8v9EM4JtGHpBgtch5Gm5PtRE=;
 b=EnTogh9s5TYuKVVn1Mj6wlSC0+rC7uCck0epOQQ6uWGySxj5h8wmicv2X6v9VLDZQQRClvGEfN1OeTcoVSnsDeU6478GK5rKlaLkLxGi1CvkKuNmUBoarL2C8hUqQjodSlPafS3DV4hqFOOPMZeSgBm9kTF+61bo7sSmerj4/RlEo424bQlBUwHy0LoAI/tanq6vNlImieT53BDOVipSMK6Fju62K/sk270ujn7MeA8H2XoC7FzFXG/xAJZfvatQ10eZWFApFEHJ44Dvomx0VQwWmgQIkUMEn1noKYJLN0AjICMGBbm3Y9LRNVQps+3DVxnFbvVFWZrhLxySRgkiTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJzmN3N4eqQZi5XiWqD8v9EM4JtGHpBgtch5Gm5PtRE=;
 b=XiSk005pVdJcr6h7PR/Oeo5yZnJeKulqkLYNfBpWTJFNtoIeHX7QN4vroGA1jKWrIDTrFnE8rBuy/dLblYlG5548H/urI3Qqf2vUqSCkNXKVkWuvomrQPXMD9lPmd9e3XeD6CgHZ/432ETje2QEGr+/Ijmvu1/AXu23WfPtNAxc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BL3PR10MB6235.namprd10.prod.outlook.com (2603:10b6:208:38e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Sat, 24 Sep
 2022 12:46:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:46:28 +0000
References: <20220923072149.928439-1-chandan.babu@oracle.com>
 <Yy3XoX9I+9haKG2V@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 0/2] xfs stable candidate patches for 5.4.y
Date:   Sat, 24 Sep 2022 18:13:32 +0530
In-reply-to: <Yy3XoX9I+9haKG2V@magnolia>
Message-ID: <875yhd0wkh.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0065.jpnprd01.prod.outlook.com
 (2603:1096:403:a::35) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BL3PR10MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a26a41d-a2ad-4918-f765-08da9e2acc72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFapZJLJ7Amv3I+CQVkLPuB6pvhREcMBio7A6lCWsh/bqq2IJhFhx+PZmBzXWM23G/czX2/SOaxVwR9gTXTvRjeSptSmaf6Oz1RWhfLszaWvOBslZkq6DF6H5NS8HxKC3A1C2PO2MEpqIg3ovnwgvkE3TlQOcckFsfYGSL8xLjzFkMct+UXdFemVT9eyAeEZ6eJ7NiOBfsOAZfohpjWpzko5AjWhNPZb8SjVMo2rGhvdRUSoerdYiVRR+AC5XfEpUiPLGpT+fO4RGzlJWjZpxUH45xGiwjKy2mzAFFY4cOoqiSngnaOY0egsOuFlUK/BFGynKqdPhbrOfFkzkcC7g++fMod90P+lnc1aMj8AvT3R8ZT5DZg9KVQnq8do8y247bM90k2ewwsjWleuuiKp4sO1+VrNcgEe+lj+lAczQjFpszxZ8cFdqqAwmpS6EmHFb0qD6rdNLI83ggGMXCKkJseUzUxANN/T55zi3c19RKBGQi6Fn+yfAmFIyTxnZQ+ddOg3FJ+oz7J/kZP8EwPUQ1x1DTmfKuopOcJe0Zu//KwnJP+w9DoL0/1iqEtZhpYsVJ9v2G7OLVeiMeY2+Pp2yaDGVpzjbtk/H0Jt8SbKdXU++z6X8nZvo7J/ilLjhNpRZrfM8yQCX8VWfODiAdURdGBAjCehbUku8ZBSJ7S5m0rL/IrFxqOOKbUZ2EppVAutxmHJ+kAi06joNAQNd+Y0dpoPvdR9YP6Eh+w1px4ogFw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199015)(6666004)(83380400001)(38100700002)(186003)(2906002)(5660300002)(8936002)(6512007)(6506007)(41300700001)(26005)(53546011)(33716001)(4744005)(66946007)(66556008)(8676002)(66476007)(6486002)(4326008)(478600001)(316002)(9686003)(86362001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mlL1UEEtEMA1xPz5JDmzRAt8KFesgOvzz2CzlNHo4DS2tF1M0tpNQCXydITD?=
 =?us-ascii?Q?0juIrwGUim9Vaz7lt7h/lCmnW1tX7714NBRUTfvX2OZkLc6qvPoeGCwH7CC9?=
 =?us-ascii?Q?3NuzUhkKohM3i1QZC99dpQ0B8CW7pO61kyAQJN0ua0y1HOQl/EzZ7tilLK2h?=
 =?us-ascii?Q?BMLXKOFyE77kEumtiqw1af8IdumNKjo9B3lDII5gcY5eJR19QV2w6cpV2Rq/?=
 =?us-ascii?Q?rl1+5UnUHrQYfvAMQ2Jwi4FbTA8l2mFQDnNLsLf0v56A6ag6CoIIJb4XIM3B?=
 =?us-ascii?Q?ExZIstY2ennAYCfJKAafr1GjPAY2zrWoytiGLKXDoemZL3ZzmBC7XYRS0gEo?=
 =?us-ascii?Q?WWf2mtETdtCMBn2SHKQjH/HPqlWfCOd6MkfSFw3LFJuo5WsJ6X/ymCFD7g38?=
 =?us-ascii?Q?6ph+VjQIZKJ3ImqMVGgeEJORPpZnSMSdStuoY6b3K100AfYV5yf7x4a+Y58U?=
 =?us-ascii?Q?Y+Wj8aWXfj4wirAgmyh7OtYAeW55R0kMzhFl76UnR8kDlkoddYTJ4zq8iyTE?=
 =?us-ascii?Q?l+T61l1GOXRrKauWS0hj/oXOsJhwVIaC8/ZsDCB+bin5U+878U6b9EJv/etI?=
 =?us-ascii?Q?GwscfBYHgCegwg/VmpyN3fyza25q2Qi+EFPl/z4i5YXfSaJjo5cmB93CJWxQ?=
 =?us-ascii?Q?7Asjn5uwnqXAB4DKpaTrKDK1+qR79JqhlIEQ/SXuO71vOn/5pLv7NLIFneAA?=
 =?us-ascii?Q?5hiwZFH3gUb5X45wfDq12/o8700etEg+diA8/KCojoK0KN79Y1N5IDFIghVv?=
 =?us-ascii?Q?lq3Pt90QdPaxWBCNP/WiITI5XnEqHd3c58BXP/2DyWl+duJbzPg9Ids9Dt61?=
 =?us-ascii?Q?16iiap1RNfCX8bVWrVhtHHwcsi0iBU9gIDeAbY9y7FdyjP+/I3bCdwGyLteb?=
 =?us-ascii?Q?BetI5Da8UXoqm1Fi0wu3DJJZAxRBHZJxl1Upz8BnWPtYj2kNls6WbQC1s7Az?=
 =?us-ascii?Q?isg8M3QwmPdCt1VDbbWAL1u91kHU2ANHPVQxhND8yyxSFJ/fx1Xiym3FM0oG?=
 =?us-ascii?Q?oiP+s46f2/LvUU884E90ajV6jE9xbLMkcDzk8t8DfUATR1x2ayyPQ3d1FFql?=
 =?us-ascii?Q?9E99vRh9Iz5BUA0D5aBZNc6HUWJE968rChwj+MNwSoEASmSUhRJJptzzdQme?=
 =?us-ascii?Q?zqdUI1oELkunv6b3Oc1kGK8o/eWfGNiLpbHZaXnQQfpgEldS+8Es3ib+JEDH?=
 =?us-ascii?Q?vWeKUzucXXoblb7qN/WcnumaEMWybsg8s9sTAnftXNvxjFXUT0smEdE0jsgf?=
 =?us-ascii?Q?7SN80EXqvTzjRMov7OSctGVJavsH37eUqTg0NoRLvBKVem9bD3C6Ku0QQ0cV?=
 =?us-ascii?Q?8BBVDLNAMtpda6ETgaWVT2AVXKiF3wEchBG+lOhzf1PHGb7tYyM/u0z5xwx2?=
 =?us-ascii?Q?vH/fb9oEKuFZj5d+SwgZxRQCqH7MX92PnLXVN4ZbtIFuVDy1HX8x+qestIdo?=
 =?us-ascii?Q?KowKsF57qSIDt0OYn0/iHWGSZxiHtW5dTGL+JCFAAa97KJrw1BhJ4DA/WeHx?=
 =?us-ascii?Q?oJTuSCJ/rNU9TjcN+8YRnI7QYJWS/RLVfwaJPpzqVA12+azQ1RuBAI6SL+z+?=
 =?us-ascii?Q?j2Up7m+2m4y0PGY3OSxYSr81y3uGpRzDn0HszOYe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a26a41d-a2ad-4918-f765-08da9e2acc72
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:46:28.3810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sV9qB1/Uf937DUKSJymmV3L6fbvfjDix1DYGcSF40lzYEhSiufY7cnqth5e+bjB+VexHa8hkliWSXsiFuY87Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240096
X-Proofpoint-ORIG-GUID: f3nPrEe9atEuWLr0cWDHBPJztqDO433X
X-Proofpoint-GUID: f3nPrEe9atEuWLr0cWDHBPJztqDO433X
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 23, 2022 at 08:58:25 AM -0700, Darrick J. Wong wrote:
> On Fri, Sep 23, 2022 at 12:51:47PM +0530, Chandan Babu R wrote:
>> Hi Darrick,
>> 
>> Two of the commits backported from v5.5
>> (https://lore.kernel.org/linux-xfs/YywzGEFApUMalXNn@kroah.com/T/#t)
>> introduced regressions of their own. Hence this patchset includes two
>> backported commits to fix those regressions.
>> 
>> The first patch i.e. "xfs: fix an ABBA deadlock in xfs_rename" fixes a
>> regression that was introduced by "xfs: Fix deadlock between AGI and
>> AGF when target_ip exists in xfs_rename()".
>> 
>> The second patch i.e. "xfs: fix use-after-free when aborting corrupt
>> attr inactivation" fixes a regression that was introduced by "xfs: fix
>> use-after-free when aborting corrupt attr inactivation".
>
> Looks good to me, thanks for fishing out these two extra fixes.
> Acked-by: Darrick J. Wong <djwong@kernel.org>
>

Thanks for ack-ing the patchset. Btw, these two fixes were identified by Greg.

-- 
chandan
