Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A899DC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Dec 2022 18:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiLSSSc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 13:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLSSSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 13:18:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BCA273A
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 10:18:30 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJHxU6t013077
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=m2ytEoUphH3IE6ExaH7f/evukJB13/uJs6npREvrGuI=;
 b=t5rMflOPioqm+eCwTIh8QhpWudjG9ibeuwzv8AZ50fnrMYbsgljsc8uXBzHxc6sogKLF
 dX2oYtYMvFZfKciwe++VOWkMmQxYTrQohcppFkbXP+XWhW1Hu169mmyuP4EffB1jgaNH
 afrv5yVte7E8qJyuLnk0oR7IOgIoOi5HxnQO29IQ2i8IRBuBtlvvHkkMKUVyHe+MsJWi
 g/8VwT6M0L6ejVOSFIzvgS3oRVzgrh9gdLjCnS4PzXhD+ymHbiNrqgAonSq7UeFp+qSR
 Yo40Vatf7GuhDh/rfsWXpcNzMu6kdQBUefLGFppiq6xm9ZSBKSrP/u0Z5SSvMynMXabV 4g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tm3hty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJHt9fH009732
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh47a6jh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liXI2GIdCNz37HDgn+QYkUcHlwd0A5ZDPM/xIqkkLdEDOm3nBTyMKOvioHMDkgP9hZlerkRvCJGh5bAEQ3WAC8TXSaCnI85iSjwVQ+GSuHHzvNCX+05gm4o+SP7rC4BC70lR5nYR2pssGrsfPrVlfj5nKf3JOQPmuXL9XDkS8+3ADGNAQY6BCGfayQiHBiqh5RYFkY8W8auzvTQ1b1iLXZinyx8YZibi6vD5aq26vVBojtzsY6ToJxggmS7QZEp9ZSyPKw9kwEm+lUpGtQV4DOhC/AX74u04KdAG6wEbJDd5f7uHjoqaUifPEgKdATNJfTMg/w84h+wv6DZgc9fvgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2ytEoUphH3IE6ExaH7f/evukJB13/uJs6npREvrGuI=;
 b=Jx5ofbGo9HNRnouFeNh7FlDFlgdj1VuCWHCqLdtCqwBP5SNkm72jECKNyA7Uc5D+IvtpyN3rricRrmN4R7UfaJsrlNCiED+lu1xk95I8pzhhVx4Y6LICCX1fYOUmPdm/AGVPs2P9X/V4HMGA/Ee+y6+VWCFcfioe08qHg2AhLlBax5xwGaGF2Rj5BfV5RdIwlkEWXTiAqGGaks5N7eXJ48Nlw10CuGXhenni8x3hpAHzyDhncdPP3JJqLXF6XndentK67qE2WfQ0Cg+dy0wE1hbqQ7AUs77Q9ELM0P0n1cWFXoE2cuS+MwNsRJWIV5xWRK/Fx3cc1z7rc9UKW0LW5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2ytEoUphH3IE6ExaH7f/evukJB13/uJs6npREvrGuI=;
 b=slABMZPKErRvoivy7ZhZXnD0j1rOSGKZJW0e0D1BA+EKfgQAlWhJCSJqOEt/d4ZRmu0669FZzGU4xRoGCdasXKSQsGoy4RqMCs3rs0ctUzljYcGpvNLeGh4J6f/+bAG7CDPibzRFRIrrkjVsa1OJ/20GRaRf3r7sgjQTJzoKwvc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB4858.namprd10.prod.outlook.com (2603:10b6:610:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 18:18:27 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 18:18:27 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/2] get UUID of mounted filesystems
Date:   Mon, 19 Dec 2022 10:18:22 -0800
Message-Id: <20221219181824.25157-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0082.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB4858:EE_
X-MS-Office365-Filtering-Correlation-Id: f477ce3d-5823-4739-02a0-08dae1ed6c90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEuEmjCXT5z2Y/y1Nm/N/biNblRP5gLEalk1tT/VhZUXZDXy4jm5ZC4T2ry25+ovdT6fwrovLov9GqKSG0ZcndKrNNBpLYA5jrwH9rdG17oEOZuEobelZMbXq2OLqXmI4U7BIzLxFTJFfmSGAVPOg13n0ZbQDnr65QcQi3ctee7WrgpuxHMtJTG5hE3teSUr5wUkO15JmcWqlFoQmu+6ClBjGHjkWZJ96OklziUAgnV8E0cfut9aAetQpjlwo70xry4/8nhL8OSDgFMeH35FI/Bxr4qlRuyp9FXA+53S0JF26CnCCa0j3YrwUiR9reAQK3D6tSEFHLiK/y3wPXcgm7yq9ZzWCrEYhksc630bXbIMn/PayAGRK1+UpA2P9fZb1qe9TmMeIiXBgWmYOkIaaSagDIdPVULS5JK7zbSeTGDxWXzqYsS4eP6iki2zr9d9Lol5C+fFMfnixChCC5Wo40zLE3ixFkGtupknrAKU2TWRYeCJU4knf1AaKm+RcPH1PJqOhhCJeX1EPqBRg20FfZ3FOfwLp6TDzyJ6mBSLP+B3wWp4MR0lPHNz0n2jgE2/PpC+5Av+QiMU8WW289+p9Jsh0gB1tszHi3gkb7lb3URmo0AfIP9RKvJ9Is2Z3W2zrFn3nYKt3hcm0Kuxq21/vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199015)(6506007)(6486002)(478600001)(36756003)(6512007)(186003)(2906002)(41300700001)(66476007)(66946007)(1076003)(66556008)(8676002)(4744005)(83380400001)(5660300002)(8936002)(316002)(6916009)(44832011)(38100700002)(86362001)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wJGgzoV7VIBFwQcGwpJc+GxHKtbAtz5WLeXMaqC2/M45le7CcF+hAMNOJt3l?=
 =?us-ascii?Q?uhCmKSZbOgv2RzhLB58SOlQem967uqqPaRuKqzlaWJEXOXh0AJoVOCQbkofy?=
 =?us-ascii?Q?EcFESj/rDyE/yVrqbs0CoOAkl5dMV/x82Mp1Dj40hOrZAxRMJWhDvHXqkGZL?=
 =?us-ascii?Q?aU0O+2xBTvGjPITvaQCny1DE1VXE9vOf2kc8Gd0Y16YNBVRtBIS4Rmw7wstc?=
 =?us-ascii?Q?MifXC90i1B0oV0SqwOG1/7svJOTisRtYP3keMnVaR6+Ti2rjsQhvG2tXQn90?=
 =?us-ascii?Q?c5kdAsrJXtJnkEjeTG/gEP+gwM+HXZZKZAKsTBqNdzGl1yi57tc1skCcALGy?=
 =?us-ascii?Q?y5ckFqiGKq/IZS84kLJGZScBG5AAJBKY/GiLKgCJZ2Ww7VbbA1/aRVYgkljP?=
 =?us-ascii?Q?suOjOYJUyOF19MfeflNS/MBaho/F6XPuD12IIpwJUuBiuiyfU5cNEKazHTDn?=
 =?us-ascii?Q?LJ1hJ0VU25psBGN71qRODHV6Wm5OuTJNtpAbuGif/LLS2h2V5M/3HtNA+mdt?=
 =?us-ascii?Q?reYj3annPmQ0GV426EeQW4tRll3kCiHiTmC4BvuAdE+gPDCEPMVnk0bPEp/U?=
 =?us-ascii?Q?Fn6i30p2K4qfDj8iyedoptNwkgrGPkuLSFZ82ltDUWiKYecICTZfgh1FHZEe?=
 =?us-ascii?Q?2pAd1VuSw2YKNDUrI3LHHZnM8yE4cngBhhps54u2/74Ll/5LeVGl0dlGuBgy?=
 =?us-ascii?Q?Fn4NuRFZlwpVjBCO77PZkjEwR39QOOzAmem54MLLMm9+gCvM56y0s+ju5RBQ?=
 =?us-ascii?Q?UBZZ4v2DixG/RjL5+FBwFraSt70ANY7+6uvGwr4x/O54rjgY7t/PTW3XiovS?=
 =?us-ascii?Q?sY8Bz+hNmPSIfJwlyx9066c7wLiyE2koWuhzp3keowj8OnK8ghcJVEReGdFy?=
 =?us-ascii?Q?59WbWrhnO8bkXqqGiA930MK4z8L8NNB5UWEhkp3MK4BKS3vKozvHqJwp+Boo?=
 =?us-ascii?Q?PlZgHjcF88wcfxbiDsgClVOfgIoFDKS5hZ4w3OHYPO3z5DsDpT47fwZOT6n8?=
 =?us-ascii?Q?7aLAVUwJakyEeihRE5eCp45RNZsVkLceI3cuCo4B14CKnle6/jfUp06chO9P?=
 =?us-ascii?Q?2anYDWdYIcKdl/dEjZ4ohRFMu0hlW7dnBONmiQQCE+PrOLJ5uKo4QOfQM8Bb?=
 =?us-ascii?Q?zBr5D3c0uOOJlGvR5vF0OIBtI2B2Tc1+oYEF6uhKpjHbP9SwJuYuk7WdTNni?=
 =?us-ascii?Q?rvKFzAUFufoYn6QcytzrCdOhWtUUKZQfAz1Lqwogc0ebcScnCXudwp3JW3iT?=
 =?us-ascii?Q?VypTDrOXzBq5EOkqyVjAoh57v+BWTEYuUOCTqneTFqwzJfEEob+S8Fr/mHsq?=
 =?us-ascii?Q?TGWCUNspq6nBLCFQIgEGDQTEVWTwnKichQiJjbPYpfgpiVvDzaiZA1KhpcBd?=
 =?us-ascii?Q?NKPSfuU9Xh7ietxyjHZSxTPq1a/+CkvEIHYFFwKaiOe5jopyVWyryBPgJ9WK?=
 =?us-ascii?Q?9+OLMuhXmfHOwBqxdbmfgUiIeuOsh0l23+zv9zMXWGBgHuwz7pWNfatnvBu9?=
 =?us-ascii?Q?FuTWeFgT1F/o3Ppk45XhOnhikdAIVoErtpIHOTncfijRh3HR0kH35pxMw2hE?=
 =?us-ascii?Q?T3FfEmewXxTNgTwdOfFUfsT18TxpqxsJ6bdGxT0ZA6p6+7zTW5LC/1p2Gsjy?=
 =?us-ascii?Q?jEAJSetzVI73GRRIVMuxu2fKWoc0edk5NZOC/4GUDsLSXcyjh/jrKBr/g3XD?=
 =?us-ascii?Q?mbU8Wg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f477ce3d-5823-4739-02a0-08dae1ed6c90
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 18:18:27.2472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oegJEKN+gkXdohcKQ788B8QESC0Z+BIh2j73sZudltnDHVnkqANRLjuEuKtbjwrPojkUbIowxxVvpEUjaenpbPmkzC8JGzXwgnpdryfVRkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4858
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=721 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212190163
X-Proofpoint-GUID: EBWDZfUZ0K7ECfua3-eqg1ieYfdThcFy
X-Proofpoint-ORIG-GUID: EBWDZfUZ0K7ECfua3-eqg1ieYfdThcFy
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series adds a new fsuuid command and adapts xfs_admin to call xfs_io
when a filesystem is mounted. This is a precursor to enabling xfs_admin to
set the UUID of a mounted filesystem.

v1->v2:
- Add fsuuid command to xfs_io man page
- xfs_admin returns error if both online and offline options are specified
- Update xfs_admin man page

Comments and feedback appreciated!

Catherine

Catherine Hoang (2):
  xfs_io: add fsuuid command
  xfs_admin: get UUID of mounted filesystem

 db/xfs_admin.sh      | 27 ++++++++++++++++++++----
 io/Makefile          |  6 +++---
 io/fsuuid.c          | 49 ++++++++++++++++++++++++++++++++++++++++++++
 io/init.c            |  1 +
 io/io.h              |  1 +
 man/man8/xfs_admin.8 |  4 ++++
 man/man8/xfs_io.8    |  3 +++
 7 files changed, 84 insertions(+), 7 deletions(-)
 create mode 100644 io/fsuuid.c

-- 
2.25.1

