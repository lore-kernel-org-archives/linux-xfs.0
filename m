Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B589C636CC
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBMEHZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBMEHY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:07:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93B3EC58
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:07:21 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iPAJ012119;
        Mon, 13 Feb 2023 04:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0zBZ6uOY6n7+yAPcdjOtUIqvNSNqoH3VZIRIGBp137Q=;
 b=npBbvTnotjOZ2c0VBW5a9VviMTV/sr1pRGb6xfLaRWsEzffVRUmqp4JkoeVf+LESZoMB
 mbWO/Q0kIYcP3EX/ntB3b0A1jw0WCoacBpb+eCLF1Nf2eSaa5WLTW3+dPf7J+HNFldYV
 2b86R+RujvXsRApQOH3wQ10710YKKQ2Xtym7sk6oq2tiOBDlArzeiE/m2fiyV92sVHWt
 b3RM/gVTnjPM0wHu6SwcKyr7xYIxfNJsH85tX8UU4RgRd0798dknDRCDp58/CHWxUQdU
 u+xtOeMf13ppIrfQCXjIj8Ng8hR62nEsbWaaZCgsE3QtYRkN3Q+eX84Txj1Fz8EZ4TfT hg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1t39v6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:17 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D38RIB028887;
        Mon, 13 Feb 2023 04:07:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3aaag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V39Oqxt9iPKW0D3re/t0BAmU8vXA2XQpwEvv0eLrmOc1KcG1gHeXljc3qsQ8pI6+AtKA+zdoc1mE7qJFlJIdahyPPQ/UyKUCWvDObwtLjgiJZNoXpix8UBk2Os2qkxnCCQZCElNzwIXL0gO343ccTD394WTivo8xRlWc4zcH6jPsacwdAvcven0RopYQojdWkoDviyQwoiMQoDwqfucpSTYv/9ZU81y/sEL0dVivEtKEIxBrYbpCl9V/nHKbpb1KotG5iitftRyqZMBSeLMRXxATchwipbZ2w/E1OGqYq1WrTkHTUZsCJlF/YEm6vMI2uPROIvIPYko24/XF6Wiq5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zBZ6uOY6n7+yAPcdjOtUIqvNSNqoH3VZIRIGBp137Q=;
 b=UiBWJG+FWDkQIgBpmAT9hQHaIR003KQvFG1z61B9Wz+LL2Lcn+527XyIZDEludO0mU1uK7wYh0AkethYi9qbTlOj+RyTj/hTg6i1XNwRi72M7I+5owau6Q3I9WBsAcDPuVedokQnH6nnfBGLqzWMQkNOl5mrj3xR7dJ8dUWTAaRucZ19ZaLbRXBk6/vV5Us0Ge5VNQTVLsdgaHvteUnQBDRmgjCMEABQbBPKFsxnMyegVTL6PM9EatDzBw61DEiIZst5xBa9DhlgwddoUW+JzZKt93UBOH7sYcTmVG1hHHC2dZEybE0sryjtXq0Dbr1FQdNWgsi7moFw1FF74j5Fpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zBZ6uOY6n7+yAPcdjOtUIqvNSNqoH3VZIRIGBp137Q=;
 b=nyoih0H8G8P7v0cmgLhrYOT8dj2jm4siEG8ABP0/d4VZLOgvDIFtjnLxQ5KbnMkN1VFd8BkzONCvi5Qnrw+PXxiqnxek0yGAA18Ix5bkXDRqVrg37yNheNNtbT6OxwKlNiZmgPN0qkhS+LBN9o7AzNL8DCx6CqC4eujU9eoz5Ao=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:07:14 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:07:13 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 18/25] xfs: periodically relog deferred intent items
Date:   Mon, 13 Feb 2023 09:34:38 +0530
Message-Id: <20230213040445.192946-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0003.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 3da945cc-155b-4259-cfdb-08db0d77c983
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LusEPWysLd+rQdWw6jDWbwVhD1ShxFmkROuSsWpJxMKS+jE9LBJWcph4TCI1tHGIhbEkd2OXEAyZBoGSxSrDclHWZoQPAUw5GKcDL0yBF4mHMRfLnJUtG5yFOPFV5hRSi/4kF15cZLrIuUue/T99KNJ6FuD14qStElhM7ORGxE9UxZonfZ5FYSAqAXVxP4T0yI1HvjixsEL2KQ1EHA/pkujq9n8lw3P00Z1wh7HGuKfWbmjrTRss1jXZ9w78M7SHHx52YguYg/G/BHZqmnO8hWrhvHBrE8FkO09bQAPOaxkEbhyf9D8SY84YIZ5yoqjAYAzs5rzFPdkciYy284AKEuAJ472BuGXKGaq3Nobt6JroCUixAJaxyGrspqfyH5eQoNTR9jizMoT7jVYLYOC6wCmyqBQ8AIHpEu1HDH1XQHlVIQAkA5Liq+OZNNJslbHLfVzJfqJq41rQDoX9J4myrgSBsBfk9yWhFWV/rQ9UY/3D7SNivNz66rF+ZMuQxK1IscdS4mszn6mYBEpxyeVOICFNhmBAxS+J74uOyG6ap+0WHODVDZC2IlcWOtj937fQA7odVbefR+UVAF6aa53SX7d0v8rS808sog4nbUAce+ArtWDggaYEO4HzAVwEaMpMHd5AJuCQguWJNrxoyuphyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(30864003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u9GvW0bI2MEW0uqqS1Sur+yW96qUWU6UcqsY3/Zt+4AQC7qlc6gilOs3ZVmR?=
 =?us-ascii?Q?abThpmv98ZBLLTbuvsn466qDDZxD+A9LzPJyI5F2ULsfKz7xAKnT4vcah21E?=
 =?us-ascii?Q?39k04y+keCq1toma96OZVz/3MPEhgagh0E0gTSk4ZrudqBSCH4slS5jf9BIS?=
 =?us-ascii?Q?5Y/eIFKJnISUaJPr+TaCyb6aY7jwKcoBLhq29vMymdD1YPOhrKflXZ0siGUs?=
 =?us-ascii?Q?B/f06kW4Saz4mZ5THj1fwJLzyKhB+hOBBoEtr5R5xAQpaUT4al7G0v8mrua6?=
 =?us-ascii?Q?jgpwY9kftuHWTb3Fq/TCUXexiznerwujuQdOCSKICYPZDn00rzQBCdlJDsyM?=
 =?us-ascii?Q?u+cbPd4J2cU2Fs1x7CDJVNqbJplbmYkvAQAYqo1e3VGKPzQHK8J9cmZOCSxm?=
 =?us-ascii?Q?QbFILzQL1v1s4rWdpWIQkaYLbvXfvWU4RDJmFLdYH9hTrvWDk0jdw3yP4fI2?=
 =?us-ascii?Q?p3ETlIW3iYCvIZjtX9nxmFn2ZpzIIn65lMlAxTn9WlIApdmAKxP8VnDCO4NE?=
 =?us-ascii?Q?5KbV98cSARMx5+BFmJ+vNJkA8/6gB6+nbs/g1XOCdzWoT2BQuBAde93eJz9I?=
 =?us-ascii?Q?F9GqHyBRoPPuZDPdEC+Kfk6aM45cN4o0N//2cNRQQwl1s04zMA0udNRiHoly?=
 =?us-ascii?Q?syes2nn93QCuVpJcU7KP584PE9aiQzFH57BOl4+sHEj53LCCnp1llQCXR39U?=
 =?us-ascii?Q?86ecEM+KBG0amVg98Ik8Z5I6S0/Wk6VkYwnTSyA24vhM2Xsua4sUYzpLPAiP?=
 =?us-ascii?Q?XxXVFYan7eTxQC9QnLyhyldpjOc/6XOibZn0FMAoKfwYFVcEbqsDa3breHJ9?=
 =?us-ascii?Q?ePI82jtisdBpPF4Wje4uvHK06TT+HaATitmfoStx1gopBuLUlv9cf+2BR2N+?=
 =?us-ascii?Q?8FXwmUZ+gr1SeTzfwDLNI2DKtaG5zci0Gp5w3+aV+vYvq+mJOt8aXw6ZHCCk?=
 =?us-ascii?Q?kh25ZOzOEhoUIJZhyJ03CrK+107CYGEcuehK00SxAk1RcnEaqfgdZvuUFHLM?=
 =?us-ascii?Q?GEyV6Mx5k4My/PDx8XhM33h5K8lK5y8u0sM4CxsMEeKNr0JzliNy4pOC3bZ9?=
 =?us-ascii?Q?/NYMONcXN42axJ6vcS22ZTHZPGlOaWBrDtSgDIKnyOyJPJ5iPd4wnQyBSsQs?=
 =?us-ascii?Q?25eXfYxXfilpAH/5DXcCx6LomT1k/RLAkRzWChW+FppVbZckhi6LMu25BeXr?=
 =?us-ascii?Q?WZj7sk4Eou32chxGWeS7vip1pJTvQNVMtmT4oT4VCBQ59jkQnXlYsxYCz6+q?=
 =?us-ascii?Q?bQAb+rVJHwt7krKfnJCShPGdkwuufznOCg17GETqpHirRnHm+LTcuoe//BFj?=
 =?us-ascii?Q?rxEdo6rkUVKRtKTSWbx58rRynZv6nuB9bjB1MfGlLof6dmMfrQHhAwmMCC/C?=
 =?us-ascii?Q?tY3gaB8rKY11ZcdyPfiRBvqVyuisIbpJHHnWVdYL5Rur2s8vT1xDdaTeTOvc?=
 =?us-ascii?Q?tdla5Bk5SUXL4AJkQkK7W5c0Acn92Ac3jXvDFrf+XB9xkvTquKXkvpfK/A9X?=
 =?us-ascii?Q?dMpMpPWaAx/8ev09JuL4MLr+z2hSfDfU9pjvKrVU/r+kyrL1pbrZTShIaEQe?=
 =?us-ascii?Q?evYV3NTsCutHfeSAds/wX8aGVcEybCko08iSDXFwufgwfoi/+qkFZyNOZYWg?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ll0QmXbgMU5PhkFQDcJIS6JzJr6nMPknM8CCrtPSDSVyONP71K9SV68Nz38HnZQOPCD4OxVNX9okGge2/FsRhb3BFXEriLIJFULZd8nn8eo1G8jp0HDI+e2+OYL36LWL1/8AW4swiEuWXHc+SYutneXdB3JxFK4qG1arU170yMbJqpcNQm5Y04SRoFyEbSIiSYKWhc3gxD/zUe8iCQ1dRhFKhJY4CnhjPkriY0iyf2GR3HIdB8FORT0X4gtXWZwFBZo/Au0LzcKMjZlyE/q3QmI82J73oTRFKTtw/3mtxyi5w8QHBgTbzxUzop0fKT8X3A04ZsvzU8hAeetsTeSvnNmQCK9qopr6naklZhArNftiiYScvV44KBzePbZyBija9I1QLpxhlcWebh1tJ1L2w6vBT3s8mbq1V4NSip9jmPnxExQ/NSkPCdpq64z43A2oH4312K6t9+tEWVTlOjSuTilEzBzI53K4mTtq5xTwZy/DXdV30zrD8hKuFbjUnrUBuY/yVJx7mZCiXFAW0KbG2vAEJ0wBqyUt0uwIngTe0uDPFMy1OEMcwRVSYCN/qYp+6OELCVuaVC7poXw7nJ9H6UMNT5Ndnzc2gTrHyKUKjDiyxsliTUOGPJfbMXSPANtL0L1oMoRnb6BOsuAhVNAuczRLOKEWkFQebEEzTcInKJnUtxIU7Y4wkIeLXDMoLsIa3vHF0pa4lNHjz9DEtozTLhFnVlGK3S5dP3esnHEXovaXpN2C7SrUusAoaHdoYh7Gscz3uPGfENWKS7LRW9x7a3q1ZYJssPxYnY1mYzmbuRmYkmOusZOjK/0zPRWHiYRK
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da945cc-155b-4259-cfdb-08db0d77c983
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:07:13.8997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D8QLgNDy9xL5lvuuSqnc3cEHDCkmD767xWpVZW9cxq3JvUYrAbbza7ufcPnEr7/aSqil0XLQWjplamQ4YOxFLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130036
X-Proofpoint-GUID: VMXpaXPdtg1tEQTNH51JB6Z7pfh_35U5
X-Proofpoint-ORIG-GUID: VMXpaXPdtg1tEQTNH51JB6Z7pfh_35U5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4e919af7827a6adfc28e82cd6c4ffcfcc3dd6118 upstream.

[ Modify xfs_{bmap|extfree|refcount|rmap}_item.c to fix merge conflicts ]

There's a subtle design flaw in the deferred log item code that can lead
to pinning the log tail.  Taking up the defer ops chain examples from
the previous commit, we can get trapped in sequences like this:

Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
chain will look like the following if the transaction rolls succeed:

t1: D0(t0), D1(t0), D2(t0), D3(t0)
t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
t3: d5(t1), D1(t0), D2(t0), D3(t0)
...
t9: d9(t7), D3(t0)
t10: D3(t0)
t11: d10(t10), d11(t10)
t12: d11(t10)

In transaction 9, we finish d9 and try to roll to t10 while holding onto
an intent item for D3 that we logged in t0.

The previous commit changed the order in which we place new defer ops in
the defer ops processing chain to reduce the maximum chain length.  Now
make xfs_defer_finish_noroll capable of relogging the entire chain
periodically so that we can always move the log tail forward.  Most
chains will never get relogged, except for operations that generate very
long chains (large extents containing many blocks with different sharing
levels) or are on filesystems with small logs and a lot of ongoing
metadata updates.

Callers are now required to ensure that the transaction reservation is
large enough to handle logging done items and new intent items for the
maximum possible chain length.  Most callers are careful to keep the
chain lengths low, so the overhead should be minimal.

The decision to relog an intent item is made based on whether the intent
was logged in a previous checkpoint, since there's no point in relogging
an intent into the same checkpoint.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  |  42 +++++++++++++++
 fs/xfs/xfs_bmap_item.c     |  83 +++++++++++++++++++----------
 fs/xfs/xfs_extfree_item.c  | 104 +++++++++++++++++++++++--------------
 fs/xfs/xfs_refcount_item.c |  95 +++++++++++++++++++++------------
 fs/xfs/xfs_rmap_item.c     |  93 +++++++++++++++++++++------------
 fs/xfs/xfs_stats.c         |   4 ++
 fs/xfs/xfs_stats.h         |   1 +
 fs/xfs/xfs_trace.h         |   1 +
 fs/xfs/xfs_trans.h         |  10 ++++
 9 files changed, 300 insertions(+), 133 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index c817b8924f9a..b0b382323413 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -17,6 +17,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_log.h"
 
 /*
  * Deferred Operations in XFS
@@ -361,6 +362,42 @@ xfs_defer_cancel_list(
 	}
 }
 
+/*
+ * Prevent a log intent item from pinning the tail of the log by logging a
+ * done item to release the intent item; and then log a new intent item.
+ * The caller should provide a fresh transaction and roll it after we're done.
+ */
+static int
+xfs_defer_relog(
+	struct xfs_trans		**tpp,
+	struct list_head		*dfops)
+{
+	struct xfs_defer_pending	*dfp;
+
+	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	list_for_each_entry(dfp, dfops, dfp_list) {
+		/*
+		 * If the log intent item for this deferred op is not a part of
+		 * the current log checkpoint, relog the intent item to keep
+		 * the log tail moving forward.  We're ok with this being racy
+		 * because an incorrect decision means we'll be a little slower
+		 * at pushing the tail.
+		 */
+		if (dfp->dfp_intent == NULL ||
+		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
+			continue;
+
+		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
+		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
+		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
+	}
+
+	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
+		return xfs_defer_trans_roll(tpp);
+	return 0;
+}
+
 /*
  * Log an intent-done item for the first pending intent, and finish the work
  * items.
@@ -447,6 +484,11 @@ xfs_defer_finish_noroll(
 		if (error)
 			goto out_shutdown;
 
+		/* Possibly relog intent items to keep the log moving. */
+		error = xfs_defer_relog(tp, &dop_pending);
+		if (error)
+			goto out_shutdown;
+
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
 		error = xfs_defer_finish_one(*tp, dfp);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 888449ac8b75..7b0c4d9679d9 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -125,34 +125,6 @@ xfs_bui_item_release(
 	xfs_bui_release(BUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_bui_item_ops = {
-	.iop_size	= xfs_bui_item_size,
-	.iop_format	= xfs_bui_item_format,
-	.iop_unpin	= xfs_bui_item_unpin,
-	.iop_release	= xfs_bui_item_release,
-};
-
-/*
- * Allocate and initialize an bui item with the given number of extents.
- */
-struct xfs_bui_log_item *
-xfs_bui_init(
-	struct xfs_mount		*mp)
-
-{
-	struct xfs_bui_log_item		*buip;
-
-	buip = kmem_zone_zalloc(xfs_bui_zone, 0);
-
-	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
-	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
-	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
-	atomic_set(&buip->bui_next_extent, 0);
-	atomic_set(&buip->bui_refcount, 2);
-
-	return buip;
-}
-
 static inline struct xfs_bud_log_item *BUD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_bud_log_item, bud_item);
@@ -548,3 +520,58 @@ xfs_bui_recover(
 	xfs_irele(ip);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_bui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_bud_log_item		*budp;
+	struct xfs_bui_log_item		*buip;
+	struct xfs_map_extent		*extp;
+	unsigned int			count;
+
+	count = BUI_ITEM(intent)->bui_format.bui_nextents;
+	extp = BUI_ITEM(intent)->bui_format.bui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	budp = xfs_trans_get_bud(tp, BUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
+
+	buip = xfs_bui_init(tp->t_mountp);
+	memcpy(buip->bui_format.bui_extents, extp, count * sizeof(*extp));
+	atomic_set(&buip->bui_next_extent, count);
+	xfs_trans_add_item(tp, &buip->bui_item);
+	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
+	return &buip->bui_item;
+}
+
+static const struct xfs_item_ops xfs_bui_item_ops = {
+	.iop_size	= xfs_bui_item_size,
+	.iop_format	= xfs_bui_item_format,
+	.iop_unpin	= xfs_bui_item_unpin,
+	.iop_release	= xfs_bui_item_release,
+	.iop_relog	= xfs_bui_item_relog,
+};
+
+/*
+ * Allocate and initialize an bui item with the given number of extents.
+ */
+struct xfs_bui_log_item *
+xfs_bui_init(
+	struct xfs_mount		*mp)
+
+{
+	struct xfs_bui_log_item		*buip;
+
+	buip = kmem_zone_zalloc(xfs_bui_zone, 0);
+
+	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
+	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
+	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
+	atomic_set(&buip->bui_next_extent, 0);
+	atomic_set(&buip->bui_refcount, 2);
+
+	return buip;
+}
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 0333b20afafd..de3cdce892fd 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -139,44 +139,6 @@ xfs_efi_item_release(
 	xfs_efi_release(EFI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_efi_item_ops = {
-	.iop_size	= xfs_efi_item_size,
-	.iop_format	= xfs_efi_item_format,
-	.iop_unpin	= xfs_efi_item_unpin,
-	.iop_release	= xfs_efi_item_release,
-};
-
-
-/*
- * Allocate and initialize an efi item with the given number of extents.
- */
-struct xfs_efi_log_item *
-xfs_efi_init(
-	struct xfs_mount	*mp,
-	uint			nextents)
-
-{
-	struct xfs_efi_log_item	*efip;
-	uint			size;
-
-	ASSERT(nextents > 0);
-	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(struct xfs_efi_log_item) +
-			((nextents - 1) * sizeof(xfs_extent_t)));
-		efip = kmem_zalloc(size, 0);
-	} else {
-		efip = kmem_zone_zalloc(xfs_efi_zone, 0);
-	}
-
-	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
-	efip->efi_format.efi_nextents = nextents;
-	efip->efi_format.efi_id = (uintptr_t)(void *)efip;
-	atomic_set(&efip->efi_next_extent, 0);
-	atomic_set(&efip->efi_refcount, 2);
-
-	return efip;
-}
-
 /*
  * Copy an EFI format buffer from the given buf, and into the destination
  * EFI format structure.
@@ -645,3 +607,69 @@ xfs_efi_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_efi_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_efd_log_item		*efdp;
+	struct xfs_efi_log_item		*efip;
+	struct xfs_extent		*extp;
+	unsigned int			count;
+
+	count = EFI_ITEM(intent)->efi_format.efi_nextents;
+	extp = EFI_ITEM(intent)->efi_format.efi_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	efdp = xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
+	efdp->efd_next_extent = count;
+	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
+	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
+
+	efip = xfs_efi_init(tp->t_mountp, count);
+	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
+	atomic_set(&efip->efi_next_extent, count);
+	xfs_trans_add_item(tp, &efip->efi_item);
+	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
+	return &efip->efi_item;
+}
+
+static const struct xfs_item_ops xfs_efi_item_ops = {
+	.iop_size	= xfs_efi_item_size,
+	.iop_format	= xfs_efi_item_format,
+	.iop_unpin	= xfs_efi_item_unpin,
+	.iop_release	= xfs_efi_item_release,
+	.iop_relog	= xfs_efi_item_relog,
+};
+
+/*
+ * Allocate and initialize an efi item with the given number of extents.
+ */
+struct xfs_efi_log_item *
+xfs_efi_init(
+	struct xfs_mount	*mp,
+	uint			nextents)
+
+{
+	struct xfs_efi_log_item	*efip;
+	uint			size;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
+		size = (uint)(sizeof(struct xfs_efi_log_item) +
+			((nextents - 1) * sizeof(xfs_extent_t)));
+		efip = kmem_zalloc(size, 0);
+	} else {
+		efip = kmem_zone_zalloc(xfs_efi_zone, 0);
+	}
+
+	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
+	efip->efi_format.efi_nextents = nextents;
+	efip->efi_format.efi_id = (uintptr_t)(void *)efip;
+	atomic_set(&efip->efi_next_extent, 0);
+	atomic_set(&efip->efi_refcount, 2);
+
+	return efip;
+}
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 98f67dd64ce8..fa1018a6e677 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -123,40 +123,6 @@ xfs_cui_item_release(
 	xfs_cui_release(CUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_cui_item_ops = {
-	.iop_size	= xfs_cui_item_size,
-	.iop_format	= xfs_cui_item_format,
-	.iop_unpin	= xfs_cui_item_unpin,
-	.iop_release	= xfs_cui_item_release,
-};
-
-/*
- * Allocate and initialize an cui item with the given number of extents.
- */
-struct xfs_cui_log_item *
-xfs_cui_init(
-	struct xfs_mount		*mp,
-	uint				nextents)
-
-{
-	struct xfs_cui_log_item		*cuip;
-
-	ASSERT(nextents > 0);
-	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
-		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
-				0);
-	else
-		cuip = kmem_zone_zalloc(xfs_cui_zone, 0);
-
-	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
-	cuip->cui_format.cui_nextents = nextents;
-	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
-	atomic_set(&cuip->cui_next_extent, 0);
-	atomic_set(&cuip->cui_refcount, 2);
-
-	return cuip;
-}
-
 static inline struct xfs_cud_log_item *CUD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_cud_log_item, cud_item);
@@ -576,3 +542,64 @@ xfs_cui_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_cui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_cud_log_item		*cudp;
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_phys_extent		*extp;
+	unsigned int			count;
+
+	count = CUI_ITEM(intent)->cui_format.cui_nextents;
+	extp = CUI_ITEM(intent)->cui_format.cui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	cudp = xfs_trans_get_cud(tp, CUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
+
+	cuip = xfs_cui_init(tp->t_mountp, count);
+	memcpy(cuip->cui_format.cui_extents, extp, count * sizeof(*extp));
+	atomic_set(&cuip->cui_next_extent, count);
+	xfs_trans_add_item(tp, &cuip->cui_item);
+	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
+	return &cuip->cui_item;
+}
+
+static const struct xfs_item_ops xfs_cui_item_ops = {
+	.iop_size	= xfs_cui_item_size,
+	.iop_format	= xfs_cui_item_format,
+	.iop_unpin	= xfs_cui_item_unpin,
+	.iop_release	= xfs_cui_item_release,
+	.iop_relog	= xfs_cui_item_relog,
+};
+
+/*
+ * Allocate and initialize an cui item with the given number of extents.
+ */
+struct xfs_cui_log_item *
+xfs_cui_init(
+	struct xfs_mount		*mp,
+	uint				nextents)
+
+{
+	struct xfs_cui_log_item		*cuip;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
+		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
+				0);
+	else
+		cuip = kmem_zone_zalloc(xfs_cui_zone, 0);
+
+	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
+	cuip->cui_format.cui_nextents = nextents;
+	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
+	atomic_set(&cuip->cui_next_extent, 0);
+	atomic_set(&cuip->cui_refcount, 2);
+
+	return cuip;
+}
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 32f580fa1877..ba1dbb6c4063 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -122,39 +122,6 @@ xfs_rui_item_release(
 	xfs_rui_release(RUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_rui_item_ops = {
-	.iop_size	= xfs_rui_item_size,
-	.iop_format	= xfs_rui_item_format,
-	.iop_unpin	= xfs_rui_item_unpin,
-	.iop_release	= xfs_rui_item_release,
-};
-
-/*
- * Allocate and initialize an rui item with the given number of extents.
- */
-struct xfs_rui_log_item *
-xfs_rui_init(
-	struct xfs_mount		*mp,
-	uint				nextents)
-
-{
-	struct xfs_rui_log_item		*ruip;
-
-	ASSERT(nextents > 0);
-	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
-		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
-	else
-		ruip = kmem_zone_zalloc(xfs_rui_zone, 0);
-
-	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
-	ruip->rui_format.rui_nextents = nextents;
-	ruip->rui_format.rui_id = (uintptr_t)(void *)ruip;
-	atomic_set(&ruip->rui_next_extent, 0);
-	atomic_set(&ruip->rui_refcount, 2);
-
-	return ruip;
-}
-
 /*
  * Copy an RUI format buffer from the given buf, and into the destination
  * RUI format structure.  The RUI/RUD items were designed not to need any
@@ -600,3 +567,63 @@ xfs_rui_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_rui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_rud_log_item		*rudp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_map_extent		*extp;
+	unsigned int			count;
+
+	count = RUI_ITEM(intent)->rui_format.rui_nextents;
+	extp = RUI_ITEM(intent)->rui_format.rui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	rudp = xfs_trans_get_rud(tp, RUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
+
+	ruip = xfs_rui_init(tp->t_mountp, count);
+	memcpy(ruip->rui_format.rui_extents, extp, count * sizeof(*extp));
+	atomic_set(&ruip->rui_next_extent, count);
+	xfs_trans_add_item(tp, &ruip->rui_item);
+	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
+	return &ruip->rui_item;
+}
+
+static const struct xfs_item_ops xfs_rui_item_ops = {
+	.iop_size	= xfs_rui_item_size,
+	.iop_format	= xfs_rui_item_format,
+	.iop_unpin	= xfs_rui_item_unpin,
+	.iop_release	= xfs_rui_item_release,
+	.iop_relog	= xfs_rui_item_relog,
+};
+
+/*
+ * Allocate and initialize an rui item with the given number of extents.
+ */
+struct xfs_rui_log_item *
+xfs_rui_init(
+	struct xfs_mount		*mp,
+	uint				nextents)
+
+{
+	struct xfs_rui_log_item		*ruip;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
+		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
+	else
+		ruip = kmem_zone_zalloc(xfs_rui_zone, 0);
+
+	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
+	ruip->rui_format.rui_nextents = nextents;
+	ruip->rui_format.rui_id = (uintptr_t)(void *)ruip;
+	atomic_set(&ruip->rui_next_extent, 0);
+	atomic_set(&ruip->rui_refcount, 2);
+
+	return ruip;
+}
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index f70f1255220b..20e0534a772c 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -23,6 +23,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	uint64_t	xs_xstrat_bytes = 0;
 	uint64_t	xs_write_bytes = 0;
 	uint64_t	xs_read_bytes = 0;
+	uint64_t	defer_relog = 0;
 
 	static const struct xstats_entry {
 		char	*desc;
@@ -70,10 +71,13 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		xs_xstrat_bytes += per_cpu_ptr(stats, i)->s.xs_xstrat_bytes;
 		xs_write_bytes += per_cpu_ptr(stats, i)->s.xs_write_bytes;
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
+		defer_relog += per_cpu_ptr(stats, i)->s.defer_relog;
 	}
 
 	len += scnprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
 			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
+	len += scnprintf(buf + len, PATH_MAX-len, "defer_relog %llu\n",
+			defer_relog);
 	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
 #if defined(DEBUG)
 		1);
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 34d704f703d2..43ffba74f045 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -137,6 +137,7 @@ struct __xfsstats {
 	uint64_t		xs_xstrat_bytes;
 	uint64_t		xs_write_bytes;
 	uint64_t		xs_read_bytes;
+	uint64_t		defer_relog;
 };
 
 #define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f94908125e8f..4b5818395406 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2418,6 +2418,7 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_create_intent);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_cancel_list);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_relog_intent);
 
 #define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 64d7f171ebd3..941647027f00 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -77,6 +77,8 @@ struct xfs_item_ops {
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
+	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
+			struct xfs_trans *tp);
 };
 
 /*
@@ -244,4 +246,12 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
 
 extern kmem_zone_t	*xfs_trans_zone;
 
+static inline struct xfs_log_item *
+xfs_trans_item_relog(
+	struct xfs_log_item	*lip,
+	struct xfs_trans	*tp)
+{
+	return lip->li_ops->iop_relog(lip, tp);
+}
+
 #endif	/* __XFS_TRANS_H__ */
-- 
2.35.1

