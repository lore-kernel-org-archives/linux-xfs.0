Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F65C742A7
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCHWiv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjCHWiq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C1A5ADC6
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:44 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JxfJK001618
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=vY2b0PAVZqhDeM2fqCeNFFN29eS0+5CCp5vgTqu9cUE=;
 b=YX5RL8pzuL6mBmY1gAWhNFIHf9v3ioMI8CR2Bzj53SpxoxQESCvDJop3QUgnuAK18TR8
 kHmYsZ24rjqJR2CD410HkWQe1v4DgCEE7Ng6EmNOT7zcpCv7zYRKEKR9vk/srOC1unvI
 9yyIW8FcFaX9kx7uP0eBnueXVFuY1Ueu3xGY99xm1nPMPBhLFaMO7QXDgH6WCvVV17At
 kAiqjVCgQGyknSqH0wuHA3bkqA9pDj5pZtFovgoZg/KjFP5AH9NkEcrJCr6kROv0EvyW
 Ryak5bgKK1n7JlA3nsmyKMSrxhYC8v01gSXo0E5he78SHVjxkq6FgOwtK0StGuRnWWHW gQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wsd2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MZ0Jl007322
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:42 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4gd1wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0ll/EyAcIaVKYa1YLnuWbEM39Gj/I6tdc8Z2bXzDqtIIFFYG4rTYo8c0VI/ioBFgZPaWutNdqDphYcuPsWVPtFQEUrOUtk2UVOjAfC+c4jqmrV3Qmy54gqZExFGa11+wJ49ebDGzGmZk6Z9lsOm/4UCUb/+XMrgMLWe20XenfGhgtpoRAExICYYmPaoOGvxbkG43clF+pvwI0KUYxFMSR8BWZYfy338l9PJ0lsq7tSrV2IR4wsuh3Q+12gfHbupw1OFNuOOzWIPRK8VhaU1ccOJwACnG85qgNp8n5ukSc7T6QWGwEQlCK6l8aQCIOresgiGQ/fXX4IbZw/HUg6XqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vY2b0PAVZqhDeM2fqCeNFFN29eS0+5CCp5vgTqu9cUE=;
 b=L4aFqvfpHpBKuqtKdJ3/cAzK4NsIadjAwvtjh79B/RVVKZ3Wq+DZK6p4L8pANEazaXGEK6K0oylbOPXMR5fnYPBqWCnkV4zaO4v8d6n/5DlZ+gd81vBxbzKF97beoFPPJZ9ji1HwIncx6ZCCuwr3nLNNRaw+Xcuzrvngolq97IqQ3pYVV8/vcqXWhSMkt6ddCZOh+GbZtNnxBRvnXwffGs2zL1stMQm4BbPsJNz2nGv5mDKWT7RXy1kj2q+EH2UpDvJK42RZrRGCcvkGa/bfO4nixlTpc2zuwXX4NlHhTeK+wCAmSJ7lOzh2qKD2NylVWyjKiaGnoxxZ1tRDmLPr/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vY2b0PAVZqhDeM2fqCeNFFN29eS0+5CCp5vgTqu9cUE=;
 b=PGuZblayFDjGZoWY7DsDNxyslX2upg5VCioRJlPiZ9M88TY6rRnfFN8P1Bl6OS4qxNvf6oGhqZx638Ll7I/sUAw6TnAxP2XJfaN82lMW+TvYX/+8drF06tLSC/EwesKrUC1zREPfYoZZDyM2JpmJE5TGeXQW2AK36fiAd3+s56A=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 22:38:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:40 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 24/32] xfs: Filter XFS_ATTR_PARENT for getfattr
Date:   Wed,  8 Mar 2023 15:37:46 -0700
Message-Id: <20230308223754.1455051-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0008.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: 035ebee8-f78a-4b01-c9b1-08db2025dd8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XpeSRCZGRP6glnV8JxipDugNG/S1ZcW6kEuOgcwfdoi6B7LlGm7Ak6BOBw6PsgAhfS5mFCrM7z6mqchwEk3ce54uafBqfDsHH8N6i9gUpCuNOPRQ29+lCOHyQJXXACwHi6/m7Kwdg+niZsijIwzV0GfY/Nrme42p1gqjEnuqbjdr07tLEEIudLvFYBqMi1LHMZNAzeMZulrx9GxsgSZgG6HJauA7o8Ln8VcYXxox6y6a7Y/0Rf+L9Ipci0fQsYmbB931uxAInnrEiI23Vj3mVF6hrOAqdGhQhRDFlzR+ggqcxzb/FQQE4X3kK+/NABwm54yGWNMBLVTs+uPa428YAVgf7U8Sd/qZ30QtWfm+tiKIdycs+avi0mmrm0pIks1RF8oYUShRGDPmPG07g0vqRlfJmalg4mRJHtYN7gyVC9iPUaiieGPShwCDBQbejH/VTFllQbqCIHZK3ya2w2ONwrbAbk+Q1hbgFcEQNd8IO3fd+DVHQjL7myVV5LH/Nwk6WLEiepfs61ZJqhQv9QZg2Ii7oTNU0KmIZrNOhCmDPgukvgKLLV8zSsAosHrHXrfq6LQ8MO8uGE9GnVHbxjvLLEHFnXpu/Qnl4dT7WUE1L+v22llZrYqeAyNAAH8hwlBn3bRaFCvvjsCIW5QW/CN21w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(5660300002)(8936002)(8676002)(66946007)(66556008)(86362001)(66476007)(36756003)(478600001)(316002)(41300700001)(6486002)(6916009)(2906002)(186003)(38100700002)(6512007)(26005)(9686003)(6506007)(1076003)(2616005)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ATEZSeMJHzBOPppXaZKT6PhUT93vd+wfuKNEzgzwblE/rQI9FkmUGtUfv1ZT?=
 =?us-ascii?Q?rddbDSxUtSwWjTu9BHKilBIhh0gtz5yKA9jBpGOzZoSG9CB+vaOfScu7qqI4?=
 =?us-ascii?Q?E1H1Nle4I2Qy+EaCR6kZqrwzpZ0QtBufqFhcldxkkxLLALmIO9SUWTt+Qf3P?=
 =?us-ascii?Q?UJOINsqtm468F5JMCa50D/BgVqmgj/8ZTwGGJExQl6Lemiz1SS9CZiOMUIma?=
 =?us-ascii?Q?EUtNzXbkyCRfvytPKGd3vaFzOFi+7GGXMnE402AIHb+0nnS4FXJLW6CSRlxn?=
 =?us-ascii?Q?hFXXV/ZCMoJS4jh8Sskn8PHDkUdEAp/ok7jnQIILJt/WYwGe3+G9eGi2ViHg?=
 =?us-ascii?Q?HpvvVHrvU0cdg82PbK+bKK6ANLhtFhFE9jPZqwmYvDadES6PNrxunm3tmR8U?=
 =?us-ascii?Q?k2aixYGknM4Zc15fT8deQHx7pf2myIgQJ2zr/pP1wpmqbNrBoLma4jeFM6WO?=
 =?us-ascii?Q?E8XyIQ2vr5Z6dGqPxO42QYulFnPH0kjEzi3J66ej183k+AhOwixDNIPqq1hO?=
 =?us-ascii?Q?bRVKjfMAuzMGc28H6piZWQTVeqSa9B2c9sENIq8fjsCyab1vAY6M80Zq4T4/?=
 =?us-ascii?Q?kmYMkCo+VzDt1kLcclRyDzR4CTGGyYnB0xvDAuJh5OaBmDOGD0AyljtwPCaM?=
 =?us-ascii?Q?S6rLHKjwMW2ycSRB7Tbar7Ryxs7qJugpN1q2jMkuVoJrojRy+gOKR18wUpMk?=
 =?us-ascii?Q?5h3Y37NeGXcoIQNbPPxE3DsphGFeEtqmK1CXFo+DX8DwpUf2NNkesZh3VQEo?=
 =?us-ascii?Q?dFfmVCv6X4BSYZMPr7YI0XOMApT+x5Azr1ILfbDDkyVf6o9c/j+ILIHdEmEX?=
 =?us-ascii?Q?bG9oMv6mn6Zuc1dNv8oAccxlNt6iKRMfVQTX4lF9U71COZYAp5PUyGhqO63L?=
 =?us-ascii?Q?JG6EZceh1YTYVfX75jYCGLCi/7WbKKOZa4eHcbwzAAfQZgJMAodJioIzGQRi?=
 =?us-ascii?Q?Okek85GN9KLmlCzygO1heDvTQ+hRqv7SmydVgwXmbCeNAL9bBbvubu/qGc5e?=
 =?us-ascii?Q?ObbwwqjQyXfiiBtNcbkcbJBqy/QnttbyFTxCahLdU5mxVYX8BASNfusC2tx4?=
 =?us-ascii?Q?/vHQZoN+V0LXmzXIg9SwfPWShq8iDLAh7RmuXWonkYhiBVh3MYXB9X9X2p0F?=
 =?us-ascii?Q?p8V7cd/JWJpXjsXHg1MOpFecIEUQqb7nk1UiFEw57f9y6vzXjKT4TgSmrVAB?=
 =?us-ascii?Q?GMu2rnlkw3l7rT2yWNsx0Ta7xlnd5Ewwq3hFYkih8HNhMw/BN1amb02rFf8K?=
 =?us-ascii?Q?/subzZMsF8asIp/EKkDmrLg+EZR6iv3dQZC/qxm6+RBtoaIk/8oFidG27rpR?=
 =?us-ascii?Q?/or+3zY7hfaNqcKInoDvm2iM4HG3NsmS+/jYKeurMLZhddEP3nTB47CjAJI+?=
 =?us-ascii?Q?LjCxB99/dliJQUaN3k7qH7hejPuveSd/UDSTbYE6nVUo7KsplhhjdPi1s6D3?=
 =?us-ascii?Q?16NwrvZv1YVJANbq/9UNm4SrE/ndllxqzYkJ/TMtZp8LYt4WDB1AJAce1+B7?=
 =?us-ascii?Q?FXTNe/l4sR/ugCPEQZvChvfFy1fltIcCCyWFyMHpO9gLjYthoP8T6vc42W0g?=
 =?us-ascii?Q?EzHtyXw/Ho6s4weWrLdEFZ2nD2DWa6GE+rf3zMJMy2E3bRr5iQn8kMDPai1Q?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: g/VEj6NJ8fXwwXwbsFFMI1Xovl1tTTU8iuC3kdy/3TuM99t+uVj0S18qdXSVCDGiDSA9UxN/LCmtPb3YyxLwvuUNJHK5KV5dLK5FP1emDfN8DTUBCQGZ3t4Jyns1Tz3mv5+6kYzXKsa8+vx12QJCdMUldujLHS3I1ZrkSy8+cJ4MnjWn1kw5m5L35jCZJ4lpQFhC/a7kC0HgjLRIZy07bgvrCvFyjMMgIZWh7SzXyrlvX3FoaCaE+mrk8Y04CUN+dnQ82OSLoUtF/eZ/X8S0FeCQBzv14iGarirTrgZxGVjQCTnqzBqNzoLOiA1Zt9/fHw16LDEU2wpJ2Xr1Zf6JSaQNnRBkziGiVU83gET7tnL1DnOCOyWhQlmbVNbakuZxFuGu+DY2Ye2vL1wPKz9S7BMbKNjSqfIONCtbwqEJJObUR3BLAmmyXm6fJ/caqZqUyGXrErg3VF2ZgSzCVtmUGvrXCdcZNuCwdXtARz2fB17PznwtW7731Gc7wSfYphsf8oUzax4lNUo19aPBPszYTdEgoWNNa0u+WK20xQ/zkJ1SDy7FDGbfMOFwdbEoOZkBkZfsFk4V5N7X9BKGEVQcmvT0ZYMK8RSVJwWzLLkXKQZWvAlAVj8F3X3v7wTBCjdVvweVwctymNbB62kVzPa/2vBHaYj2K79blSpn5tEBld2URzXex0TNSIQlnD4H7mcy6C+JKLvC7RtHi8jL3Q2NUZFY7yhhCyuYUyPxsfyQ04wKVTNiAqOC/EqpMc/50O//0mweGNMmwATzHnoISIJk/A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 035ebee8-f78a-4b01-c9b1-08db2025dd8f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:40.7696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GClMuK1e/aQr+ZT6pbEbgsGTlVaUdChxlvXBPMDUIvIlirMFs4/KVLNeawGWylG3BxjVtC5q7GSPvL4T90tKMCFwwrS7gxjICPNGZPVQk20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: szQIOuGevCnVBNChuTcwYQZYB4q2IOHb
X-Proofpoint-ORIG-GUID: szQIOuGevCnVBNChuTcwYQZYB4q2IOHb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers returned to the get_fattr tool cause errors since
the tool cannot parse parent pointers.  Fix this by filtering parent
parent pointers from xfs_xattr_put_listent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 8224aed5f938..14a324bbcf59 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -234,6 +234,9 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	if (flags & XFS_ATTR_PARENT)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&
-- 
2.25.1

