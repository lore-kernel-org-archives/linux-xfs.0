Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DBDC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D890564EB3
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhBRSo5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:44:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35536 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbhBRQqk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:46:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUQZo041132
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zayGktjTziCYHsvpZ7Y70sIEhUGWYy6e4ZjjVOk6Ba0=;
 b=i8Dd0toUXjLOuh+ykiuQljUKWGyVXhbfqQg9Pof2OHu88M4OKVktmL4F3exvmPA5tVDG
 syxxkqwqJC/tYnKtUL/9AAJFnalaRTA7j+zqmG7hsP9HvXJQKtlFr2y4q+zCilcb1+/+
 eQxMht394m9IxnvCGwn5Wa2S4u0ZPiG6jg/dKi3xI2+MJSbB8qEXnx3XcTNck+NMIz7x
 /CnBVNB0OuehAWIfOmIXXhCJ+1F/sHUGTlR/k9hF9LTQoBGLRHVicOkqp6DdV15FEBWy
 ENl/YQk0wWGwA9WnCoYT3NXEygfLqGMvTSYQkuAbcymaniHNtQBXEnGVc6i+VJGpYY4q dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUHT7067740
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 36prp1rjuh-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YU3mBWEX2vsHRxuqC2K5kobgD6GFzVPvCa9zf8oDRaa/MihSwfwPjHrWisbsq7+olP+9Fn2XXOUUXNNDlztGugQmGbMjqJL4/co4WRpmJjV8OlyXssGzYQyOz3DZlJapuXBWe0Lx7rRNS/kCx5TW34vs8pptMju8U2G6JmviRh6JIPb+zPRoaePWF35v7h5QLEKKEcDSUn4xa4mz2kpdsZvouFh7E+Vg9wuue9gX+akCEL7HjmWdjUEXjF6bV0ubTuIS+ZXsTCyzpa9TJcpG/Q7LG/gspAdWJl2IjQhwmWeXqnt+MSP9aCzSxduWAPd/C8kqVzXDeATDYAazwcp4+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zayGktjTziCYHsvpZ7Y70sIEhUGWYy6e4ZjjVOk6Ba0=;
 b=Zi8qjMr+O2QgKuyCOaXWnOVlHRbIOs7x9oOhqIeGGMDYnWozxRwaGKb9MkcdRMan79iHOiqubDgR7RNC9es5tc5yGH80o4m0E2O06hEfpZRLNWs0sp2hBbO0LLsK/G5ik7dn2CHdS94QAZscFa68OY+3slzR2wA/R6OhJdrHEDQ7RV3x0/3WzUcsOECfcZuHJ64DgLViTn9/tptL6KeV5xJhuDzmG3SpKqyjLe5lyPMdhP/7bnJLNrjzJy2XawMRcEiCyd9Ajv7z+ZpAY+NJBotEC+bjWgTqLJWHP4K5THEsg4BApvzh9mLXzD502mOsAxxyardpA2smCSSTIKy6/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zayGktjTziCYHsvpZ7Y70sIEhUGWYy6e4ZjjVOk6Ba0=;
 b=TRVuksIIAWoX9cHB5KTuBirrmjCMmig5WQsSLKqhEwKSuRtrxL1Nc/JEEui/hsefY6hDzbUA+epl1WsG6s6erISJaqmMc7lGDIdA7hMFYz4djfGGqCDYMdUiDZsK7jVj7dHRRF2lutbsgakPZIsx0M55YuEs2hX77dTb6c5/5yo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3461.namprd10.prod.outlook.com (2603:10b6:a03:11e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 18 Feb
 2021 16:45:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 04/37] xfsprogs: Check for extent overflow when punching a hole
Date:   Thu, 18 Feb 2021 09:44:39 -0700
Message-Id: <20210218164512.4659-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc8b06ea-74d7-44f0-1511-08d8d42c9ad2
X-MS-TrafficTypeDiagnostic: BYAPR10MB3461:
X-Microsoft-Antispam-PRVS: <BYAPR10MB34612537DF23CDD4CC0932B895859@BYAPR10MB3461.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:364;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Gi/IMPu7Zhm2v1399yskOAEh+X0fo8JEGxFQTGqjoAp4v8LLtH6ERS6iiLaqtggOqUuqhEoY8sV26FKccbDYdUfrl25k1w0z06HiWiUvqgOxzZFTx3R8GomDL9ZKQ7GQcMzrjVj2g2sg8x0PwMYC7lsxFbxTS9AcvuVYxpPeZPZim8RPKiuxQbTCiTyMhDGFJrUMOuBbuzzE3A9uDVDwwiyQ2zWyHAwbDzYvJBJNN/1xl7PvByuOK4QER5/CHkcpgOiauV9UO9X06GcYXAgC/Yxl5bV42tMcrg1YFk8xDqLQb5kM6OGKGgnbuzMlanKjplIk3FHyGSz1VwicXcjH5YKSuPbt/x7h0qg4Sk/f/YcAOaFfmzwQ7yNDKc28DavjPd2T+4hs1c84Mlk8fMSzVjyDiIPFtXTD2NSXH6hNx+pDAIW95sMWsAEdQ3o8u6ocQR9TjQ9jzFrrKqBDvNVVFMX0jlT8123O3BOpDnKyMkkpQHAzGHxLWGOy+kBdMERiadyH4Iwa9LgsHRH1eDbqWzQQuqajBWn7Wx71gS998DyJfR1+yW5s0D/bF2qa1gAADG0Gx3u+b3UsAbQL+Gurg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(136003)(39860400002)(8936002)(66476007)(1076003)(69590400012)(66556008)(2906002)(86362001)(316002)(26005)(6486002)(52116002)(16526019)(8676002)(6512007)(186003)(36756003)(5660300002)(956004)(2616005)(6916009)(66946007)(44832011)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?srQVRVHWuF4Pkix251d++/3lsgGeUtkCPO5E5AwTsouc5B9NeMF+RtXQVzZ8?=
 =?us-ascii?Q?+vlqCYQYoXwQ5c3HHYJ4YWChq7rGLIUGSeHIYenXSK7f0ezpnb0HZv0Cruxp?=
 =?us-ascii?Q?gLxBP+OV9Var0ebgmXoE0J4XEwNpJJTU5aEf2Dy25frB1QeySkJA70IikDKM?=
 =?us-ascii?Q?YAjTUlArXBenxQNNOUmK8q0MSakC+Kb8oeennrmNXq8IuBN6A+zDIpTwN5YZ?=
 =?us-ascii?Q?MhJ1HYr52bRRWXVuHiU4vHPH82W1QSzFitOr1CLQqCXm4c5yo+v4TjLHF/Rf?=
 =?us-ascii?Q?nrjvqSwLPdDfaMNIBFFqhfLelcpzbN81TiUDrtuTBczSUwateEP4564YHcYv?=
 =?us-ascii?Q?WODto4glyzHdx+LeJrXtVlLogATuUybuKkDIxEOQxLqr2WqxxfCa1r4gPJQ3?=
 =?us-ascii?Q?wQ93JxyYQ/yi2BvYxEEfdMrbnb628mRogOXHnNCzjZGEVZbELr+yt2qKdfbb?=
 =?us-ascii?Q?2X5qTz3jtZSQpQfMpsT1P20eHCRRIa73GPJWlIrUmVbscjEls1zmuTQjQDPv?=
 =?us-ascii?Q?PrBNKqNxwd7/mVzlUsqFfx0CQc7asnBalofftFZh7S3fhaJVdgljPXNYycwO?=
 =?us-ascii?Q?R5st0b48j7b56rngLGBu+P6VzYS+NF+0gnMdlK6j11mjuO16fVBrcrRA/NDY?=
 =?us-ascii?Q?7qnm/wlIVkeN6OpMNW8my827UzNURkpWptxuBkrqIglchrmfR3ArAFphncch?=
 =?us-ascii?Q?V4ACm7004RFkjsqhhOL80NHHlxoktvlWjRCHa4D+3Fqg9kbc7iQgxp9qDik6?=
 =?us-ascii?Q?HhZp+NETu5iprbKK824saINjA7ueeBsPbdl0ibOpmpMDgzcpBa1nR+JyN/sK?=
 =?us-ascii?Q?c9MXbiDKHv/sDblcMoBbWsB/Jf6duk9sZRJk4LEnFWw8JsJWY9DoxHkPrsB2?=
 =?us-ascii?Q?Kf4U1JT3FFjCV6r5hTLYWGwX4+6+mjc1Ngcp6G83QSGzCSFa0ab2Q20JrgpM?=
 =?us-ascii?Q?1fRzlhuSvv2UcvTNmC6FMUUiZSZjLqQV3iN/w6oBPOn2ZWRZRqLiLtXCJ7kE?=
 =?us-ascii?Q?NVeMFafv/RKjuSGgXKaeRQ8TiSxnOvt3IINr36XvuJZLokLRuGdpkaxXz9tJ?=
 =?us-ascii?Q?EJxFlga0nkmaE+ikF+aBkzPzGcDVTdOHZNgac3JT2zNEs13hH+GCPrNJNE5d?=
 =?us-ascii?Q?bc9EEatCw6HU2ytmD/AMZdaN09lc3pku+YFOwA+B6mAFATeWH0zYGAk7ZETk?=
 =?us-ascii?Q?zdl8dcb44xYHub/VPpbzi0C0cym9AIeAq8tiYxkQM+8r+Bl9quecIWDJvSDS?=
 =?us-ascii?Q?ZzOONUrHrrx+IZ+q8SXol2veKsUWWPy4s4bbELGOlD/DXq+UUAVWVaJ0BZup?=
 =?us-ascii?Q?nIdLKQtIjeRW0aZNDitYjdG/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8b06ea-74d7-44f0-1511-08d8d42c9ad2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:31.5636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C6Fv/8V5I5LUdwVyEs5n+2oLvttdC1szHvcYZ4GrD852rFsf8U3TPl514WZ0FXD23WbDP2B7IAXf44MzytRFj+nzryP3kAeFrpOcs/GrBDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3461
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: 85ef08b5a667615bc7be5058259753dc42a7adcd

The extent mapping the file offset at which a hole has to be
inserted will be split into two extents causing extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 7fc2b12..bcac769 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -41,6 +41,13 @@ struct xfs_ifork {
 #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
 
 /*
+ * Punching out an extent from the middle of an existing extent can cause the
+ * extent count to increase by 1.
+ * i.e. | Old extent | Hole | Old extent |
+ */
+#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

