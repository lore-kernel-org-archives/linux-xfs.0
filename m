Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4840CC46467
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237092AbiK2VOC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236877AbiK2VNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A199770DE1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:20 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIkjpU005619
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=H3b8ZQhjDsQS/OiU2IYq+79S7oUoBWJn26hBtJprubE=;
 b=kY91SRq0REBifLAPVj2mnv6pwHxRz+4PhbL3n22raL7pq7DaHadNo8BgWR8xuCHYJJII
 A+8UXh3wiRG1hM+9TW5O6wNoGbYlmIsrNX5YV+2v8WjWLdXLmRrg2SZ4XHLs2iqqtjsT
 3ftJMBHZDdBeom9xwJmx3M6knA4HDUf+2HeGVX8fx9E5zP4PGNAsmBO1r51MEZEgi/lD
 GkeSpqxkeYYZDC+R4sQ523mYyhS64Zoiem8sH0Py7vGSye577d4XMtJmugQbsMHjJEjH
 2qdK25Ru0JlmNjM/lL01DJk5hGv4t678Y3ajxl89Yz7sDW8BfZl5iWZsogy9KW1UYPSi nw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39k2r9fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKFuwj019254
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398e6hg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8cVGLcuM2KvHEW0OkpnwYENB/eXJb9/ecfQVfVEqYC2bAu69ISTkqg6izA1s+KB7cLRtCq4jLDRCyYxiEy8FV0ZDLLY5yQ3xG10qEwCrTbIUzaa+S+qJ8McG6tYTwhdQ9OGyCte05iCyZLTdlEqH2PAfUZ1sBzmd25wVTZYoitdx/lt8CJ6j+/Bwq/MaAPPd+1VP8uHQQUwvQ0Z9jcBgML/hjBUNdYlc0iSHYEtgysu7vbAuTXEvAtaVKvaNRLRBMPgHGklNq4dO0ihgl36oYgluwlnUFg0z4glfIFc8ZMQjGjmuoEyPsZHeozlRdG5UKrRhFNbkIXCuGVhsE9fWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3b8ZQhjDsQS/OiU2IYq+79S7oUoBWJn26hBtJprubE=;
 b=JHWjoG38ew1p2ccBRCyPQE46Xwpny09tJavqDoMXX+5C9JrhfoJn+b88vkp+7EMkNFL3zfWmtmwpEjY8JMtIdB6SAueqVPjTgvwy8F6wLRBdB2eOm4sR2yM14sNggonyGzsRc9W2YXRjyN0JJK4E1ETvaWHYC6SqyRZ/pgKnaXJlTPboLf+CxErtQx/Xc85De98nKPbOKOWTDfocIOUA86IuCLgF6x/uOjLbIz1XggDWK0RdNdJMAmMJSFxmzN6eXkIdhPk/L5QdlNkTOvv4LFnVJpZXkSRghEUJEpnIT32DfKS8LcFL/AtRBfaqSIUUTcMFsB1XltU7ShD3ovrwVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3b8ZQhjDsQS/OiU2IYq+79S7oUoBWJn26hBtJprubE=;
 b=D+OKkwzyM56uksVLSdz4r2eG4qB2hWUZYANMU4IgkE+kQSo4pkSk/r+eec5+jkY1UmuuM2g+NiqKnhAFkZYI6DChaSa7COn+BYU2qcP9vUvrxIV/1Lw9kSp0P6mraSqkjUq3E1FhOcjJ18U4oczPAAwKNhlz0tmjIQopgmbbUOk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:13:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:05 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 13/27] xfs: Add xfs_verify_pptr
Date:   Tue, 29 Nov 2022 14:12:28 -0700
Message-Id: <20221129211242.2689855-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0219.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: ea9ba6f8-5a50-4280-9a3e-08dad24e8187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1zy3mb0ocTHDmeWqZvqbBo5/6T94K+oFkKn2BWL8YtEzfeQfLnA8helDg6tt5gNt2m6v9xfIIVBkn+gucvPcv2q0YIVqWJbSSa1bbQEmOGwl77Ni3hl+AzvRF4mjt7sdX70mTX+NVVJ4HcQL8+sNL1hTillRT3QT9GVdZUyK7OdM6OP7gO9JZlWdd8UdJHUxkStMhK7PS5EKwTuk8ijMd9v1wci3TaXBtmLLtPCt7QS/LvRbcGbnoPk2eEemHGy0yUD2yfVNneD1tgxd5BMfDNWsRAjKU932K0IKP/EIQkizaCPYchhj2gjSvYxOKpLAF/YYk+fMI+a6U0OubXoDoHqUgaYT5PehCS2sULsSk8+Ck1WXSZy6K0q/Z8pDNfhyLhUgOhbkpGWoBrOOzUc1tcPYnFNS8zAySwtheR5V8VpKeQiRZpdQzr1xtmr7P3FOTTfHkKYtmIuSdrSo2Qv2JYjYR1PXvt2lVNladO9Pyo88yAxzpQqlctXDR6MV30K5DnwcmTpRA7PCmthWT5kN/lb4eWKncezQNWMuqaUqWFjExhfj9vKVFv7Jton4OVSltEc5HKsNOUekn7rvteKW3z2KL2iy2l/bXM+Yc8zjn157qdCiDvq4J59W3AmkGRCE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(8676002)(2906002)(36756003)(86362001)(66556008)(5660300002)(41300700001)(8936002)(6506007)(66476007)(6666004)(83380400001)(6512007)(26005)(1076003)(9686003)(186003)(2616005)(316002)(6916009)(66946007)(6486002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1xfcT1WUYFXt3AZA6sBBpJh9OsKMhP/jCzFFVInuL5DaQr9jrH6RNnHrMfM1?=
 =?us-ascii?Q?qNT7TOg+QzXIxGn3cC31OpK4PicnULq90leX3ahZca4aFRxzb/SHEQZZerIl?=
 =?us-ascii?Q?uHUbQVTS/di4LrPMhXr7ZBQghTXTj6r0YGm5Seyysu4Jau006VgHAyAxzxLb?=
 =?us-ascii?Q?W5FAqsTmw52VAZj+JP+sjeiDufSF9uvspP6ecoGWQOk25Th0jSdQ5OD07Ui9?=
 =?us-ascii?Q?jZ3rkculI1u0NqgC7zsg29r/I3EL60ynoYOm0jRx/TjaqOS5PuWprhjdquPW?=
 =?us-ascii?Q?TkW65ro3WVWkjqTc5F6I2CmWPfML6WDp0EbgGkmOhIrGG0QsmPVLKVYf/Ile?=
 =?us-ascii?Q?z+kZBTJvlAYoNnYTWS3yljTx4B2ICuMihKV/UmBqvIm3rj+dlrwvXXJhn/E3?=
 =?us-ascii?Q?/HHsQd2HYUX3uJvleHPyqflTsDH0xkJ8tLgsB+7SHgagF09gUYYdOZ4aTNIh?=
 =?us-ascii?Q?hCsmvhC+KiMECVp45yukEvMuctB5cPo+zqK+g4XZxIrsh8sGIL6FR5DPOSpj?=
 =?us-ascii?Q?VsZukNUKM3dNdLP7daaLb95+5zgEcsv8uXopapxN0upeRBclrRWCQi+wYqab?=
 =?us-ascii?Q?Zxc4MHcbSMx4ceQydYRBdYKxwYkJYwi6HY421RCSuq0GkZQIKoeN4W6rbAbC?=
 =?us-ascii?Q?5m/xXthGvGMo60RSnQmM0W5rAFk4BjkBAlOdrNd1Bmi46SJnsqzC3QqPotTU?=
 =?us-ascii?Q?xEGucK773DYEWcQOFsTtj67f7f1++3yPEwcE39IZF5t/LuNLBk1ThNlGAItw?=
 =?us-ascii?Q?uzUzF1EcwmVyUQ+Ew1Bm/ItcyBfsfmvOYJCRdmzABPn1qdPB4XUgEMPRxPeQ?=
 =?us-ascii?Q?lM6Bj2dyir6e5c6Tcpe2viwfAqBBFGk3gBmh4Q0EYW4dentor5Z5zzGWcz1v?=
 =?us-ascii?Q?I2QKeJnCRiflFRNCPZY2ZZV3XGkTSLmY3DghqcGEEDKSY66de64QYR0X310p?=
 =?us-ascii?Q?k7E40xC8TXFSfZ3yr/gQBy3y07k1koww4XX+9edv3avr5B29VYg+FgU0v4sN?=
 =?us-ascii?Q?m24dwqO1RjGs/3a6dG7O1BccM9YjPJk2E17w2ynevsJHly6OGUaxeFRNtBuq?=
 =?us-ascii?Q?bjoqkWr4v/4JwHb8hwoqrKuaA+gEq3bFoHm6GRiWcN38RAFjlJY0nvuYC41+?=
 =?us-ascii?Q?6/ZInO3b9oyku3CQP90S1BOv6Fpfrsxvveck+IEslJcA5l7wJkI5ezbldvSq?=
 =?us-ascii?Q?jNhErLb7T2vHBQuukSSXU26l5bw0QusLZM256t7MoCZgrjqYbAPwa/T5EjPU?=
 =?us-ascii?Q?lgXQuKH38afLZQlAzm8MkGUgX/cuF4Zw7qlFcg8byqi0Q4pt+b3t/sqbSmAQ?=
 =?us-ascii?Q?vrBQkjq3Sw1veJDez2TX8tvCxRHuUVRNfi3I9RNONtmSJoBSNfSGEPPUUdyG?=
 =?us-ascii?Q?ye+Sp07UX0MW1+JrQNCh9UJkg2v5N4nN7ePC8rXZZthPoveq6mo7AjH4Ww3s?=
 =?us-ascii?Q?uFU6ixm0frg+6i+D15kmHAHXyg7bHqSyq7zkml4nfQDQ7AClgonQDFApEPuY?=
 =?us-ascii?Q?y8cfKnzqRAW/Q5usvh5DmFhj0D6uL4r3HLcNGWZBk1ChVIEyT9TZVC94uAVN?=
 =?us-ascii?Q?FaRICXz9E7cYdzJjiNseiaZIYxYRan/JAGALZiB58kwXCskm2hUELlfTFkt1?=
 =?us-ascii?Q?lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ANI65qJmc/Va3sZ3foVU3k7J8Rj0euoCxxBddsCtWKUR108/VVauEZAHKeDTFuhwhUXUkOB5aOQWto5d+MDYzemLT0KYOxWzRHKyE0reb9V6IXdI6xB5HbRVJDEDEZoJjVVuhhDxUCD64VQTVk8fN7lhfS/lCOHllRTW2WfmFSn1I11bR9F/IYebObh2JZUP3nO6iY5eOanB5AqvqrI1nAARQed36olTBHfxzN0dEk27K1hQC9zobm7sriopzk9pAW7w78cgI9PM6H2JHOZ0ackvDcs1FjVvigMI9LZqHov/cxYWRr3kugAQdE70xJUWfOE9ccV3k2XqBGAt1PwPhYL8jSKOl3BFHGpwOgVSB90mIaYcd3iAf0s2uZyUDlVxGaV5+AeRMX3PPqHyIR7Q7MiUIT/PBmykcEMPDqdHFhMrxzGP0xLb3UJF68p1EpbA4z2HSrHE7g/1JAejXnfv67TwR4UwxrsvvrTbzOpW72HTK1pNWu6twbbp9L7AR2DxENnZlu2goEKCWJyH2bHtMYVemXj4am9Ze3Dgt9or2Wl7iM+ywzPoRB6ZVV3ImBvG/XvDZtOuZcQ8rqmBIo1feNngm6NlC+99b2e2rrlI2BqKq1mrSzJXUJ7MHRo6K7w2P7Z++d25tsY5+HPFejq6+iJoJE3TdE8SgHbl7btQPlV3mcIpvhyB/DYixlbcz2rzCH8anC28kpTyQso+6tY74jg3Ulh7/I/LuqgNDXNdTASvZkuWWOs2N4wsIOmmPhP0vsXO1DTsgtR3wAV9Da6x1g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9ba6f8-5a50-4280-9a3e-08dad24e8187
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:04.9869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N4a/jSzSXLaSQGxUtf/UuxTvFuI6z2/bI08oL59ITY5sIpcCN9HV8KTRib3lDICjAzzchiHnWnEohTiLqn33euSObd1x/f+SASHmEMPnK/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-GUID: B6LN8_b_HttMF055Z4sY99jPLDuHpW0u
X-Proofpoint-ORIG-GUID: B6LN8_b_HttMF055Z4sY99jPLDuHpW0u
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      | 47 ++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_attr.h      |  3 ++-
 fs/xfs/libxfs/xfs_da_format.h |  8 ++++++
 fs/xfs/scrub/attr.c           |  2 +-
 fs/xfs/xfs_attr_item.c        | 11 +++++---
 fs/xfs/xfs_attr_list.c        | 17 +++++++++----
 6 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 101823772bf9..711022742e34 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1577,9 +1577,33 @@ xfs_attr_node_get(
 	return error;
 }
 
-/* Returns true if the attribute entry name is valid. */
-bool
-xfs_attr_namecheck(
+/*
+ * Verify parent pointer attribute is valid.
+ * Return true on success or false on failure
+ */
+STATIC bool
+xfs_verify_pptr(
+	struct xfs_mount			*mp,
+	const struct xfs_parent_name_rec	*rec)
+{
+	xfs_ino_t				p_ino;
+	xfs_dir2_dataptr_t			p_diroffset;
+
+	p_ino = be64_to_cpu(rec->p_ino);
+	p_diroffset = be32_to_cpu(rec->p_diroffset);
+
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return false;
+
+	return true;
+}
+
+/* Returns true if the string attribute entry name is valid. */
+static bool
+xfs_str_attr_namecheck(
 	const void	*name,
 	size_t		length)
 {
@@ -1594,6 +1618,23 @@ xfs_attr_namecheck(
 	return !memchr(name, 0, length);
 }
 
+/* Returns true if the attribute entry name is valid. */
+bool
+xfs_attr_namecheck(
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	int			flags)
+{
+	if (flags & XFS_ATTR_PARENT) {
+		if (length != sizeof(struct xfs_parent_name_rec))
+			return false;
+		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
+	}
+
+	return xfs_str_attr_namecheck(name, length);
+}
+
 int __init
 xfs_attr_intent_init_cache(void)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3e81f3f48560..b79dae788cfb 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -547,7 +547,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+			int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index b02b67f1999e..75b13807145d 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -731,6 +731,14 @@ xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 	return &((char *)leafp)[be16_to_cpu(entries[idx].nameidx)];
 }
 
+static inline int
+xfs_attr3_leaf_flags(xfs_attr_leafblock_t *leafp, int idx)
+{
+	struct xfs_attr_leaf_entry *entries = xfs_attr3_leaf_entryp(leafp);
+
+	return entries[idx].flags;
+}
+
 static inline xfs_attr_leaf_name_remote_t *
 xfs_attr3_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 31529b9bf389..eed743adb0cc 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -129,7 +129,7 @@ xchk_xattr_listent(
 	}
 
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		return;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 95e9ecbb4a67..da807f286a09 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -593,7 +593,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -804,7 +805,8 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+				attri_formatp->alfi_attr_filter)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
@@ -822,8 +824,9 @@ xlog_recover_attri_commit_pass2(
 		}
 
 		attr_nname = item->ri_buf[i].i_addr;
-		if (!xfs_attr_namecheck(attr_nname,
-				attri_formatp->alfi_nname_len)) {
+		if (!xfs_attr_namecheck(mp, attr_nname,
+				attri_formatp->alfi_nname_len,
+				attri_formatp->alfi_attr_filter)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
 					item->ri_buf[i].i_len);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e44..a51f7f13a352 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -58,9 +58,13 @@ xfs_attr_shortform_list(
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_mount		*mp;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
+	ASSERT(context != NULL);
+	ASSERT(dp != NULL);
+	mp = dp->i_mount;
 	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
@@ -82,8 +86,9 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
-							       sfe->namelen)))
+					   !xfs_attr_namecheck(mp, sfe->nameval,
+							       sfe->namelen,
+							       sfe->flags)))
 				return -EFSCORRUPTED;
 			context->put_listent(context,
 					     sfe->flags,
@@ -174,8 +179,9 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
-						       sbp->namelen))) {
+				   !xfs_attr_namecheck(mp, sbp->name,
+						       sbp->namelen,
+						       sbp->flags))) {
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -465,7 +471,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(mp, name, namelen,
+						       entry->flags)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-- 
2.25.1

