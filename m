Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE113C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbjFFJ3c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbjFFJ3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:29:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FBEE62
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:29:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566ZxSQ003789;
        Tue, 6 Jun 2023 09:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=gWIEyQi3Ld9suOZUcyl9idVEUtlapqFb8UjjxZqPeBY=;
 b=E/m8o5ExUQQsLhndfpn0szkGEnzFq+ImadpleY+FAAvU+dhfcD0hTqAfPlFEyZOck6Pv
 DlsWMZXHAxcQTUx0HaaHhYzu4J3hRNtoRNyMPXIH5G62ulRpHnmuJ3R9hVSsQOzyJBn3
 M+F6NSugTKiW4pqSx96O//FbMmySOZjpOMN1IxFVQXPpctNns0SQ6IvuiBbByEXXR62t
 WVefVm6MVqKLmJBsOk0RCHYyPPotb25GHeqcS9I8owbq3XSwtPXwRadKOePukNq/cAnP
 Oulqzi8h5324v60J17s6oWUWIu5c5/xvNvjt4EW/y1uB/oF7dKMy1jzVaJPbreXPIM64 AQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx5emtrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3568cJIg010417;
        Tue, 6 Jun 2023 09:29:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tqcnwwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5r20UhX8BJB64uVbwxPF8JtZDmVa/B7FpHfADV5W3UZwh4dYWgZRf9wL6ofsulakfHqF8EyVZ8umJ0pjxyO8Yntcupsfx+lPvqq3oW1r/WHcgl9V6s2afona6wlYW7HU6RLhmnBUpsoHUayHkWYOyakw3e0iF0dAQOSALZUjWCIhvyoasBoIzKYdpLPe4G7u13FKJY+pn171zibcdQZ6CRnuS/qAedFnyHKEGutZfKVj2vIKec3EiUDR93rzl4XYc6CasxILmiZuGqJMk85jVxziNWtMW4a1XblJAzNH69ZGIn2EAPzTyl0FvQ7sLhaBhYNQ+4w6VGqdautOKE9Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWIEyQi3Ld9suOZUcyl9idVEUtlapqFb8UjjxZqPeBY=;
 b=FbyKe71+YwL76HBFpjQ2XIyqhYPI5EOU0kxhaV9X6AJEYAnl4UKcTTs73+88/S4i0JZQVXx7eJycwt9nIPTfGW7rzWhgERxP4ayh+Z88KuF1Ritzg4U9l4z7MsvEGfGZpi9NZC39Z8PZFZrJQn3UFGXNj6GjjrZ50PPQRlSpGgCwag87ICXp96nUGgCn18yhjcSWvVMdjWrUFuc97Wp3uYmk4AUT8D6HJqI4v8yFLUvL6crzdgjzK2C2Cr7zIFbBPxa1bi5+CrrHGg1S721rsfWWZfFSfpc+u9sUTLsGjGe5Cz9uAl8KdKqHF6K7sEOuUQCDzst1mpElxtba3oHF4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWIEyQi3Ld9suOZUcyl9idVEUtlapqFb8UjjxZqPeBY=;
 b=0D6cgzUXeWiHh1KfDiVbVz+hLvI1oeAwbyF9k/YiDZp+4IXCq49g/4hmQ1k8sQziI6e8g2p8Y5V2hi7EaZTMv7bmy5VH2qUmV8CNNk7koVbw7KMp/DSTbQU7NM9glQNUCZoBrUeCVEiU9J0lZ61d17VLS7ffW1AVdZgw9UI41Bk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:29:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:29:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 07/23] metadump: Introduce struct metadump_ops
Date:   Tue,  6 Jun 2023 14:57:50 +0530
Message-Id: <20230606092806.1604491-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0290.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c8::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b58cd0f-454a-498a-ce4d-08db66707c4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zlZn41GqLTL7PH1Raq9i+8XGN+CqCjxv89arm1T5i5rYosGObli66Z84wqgX+lA+kcdHgU48yJd8m3E57vDF8iegQtsFEK5BlOeiXI0M2uIhRdzJTP0OirFCUoLAcKMDmbW5ejgNyCQM7aoj3s4zH/Gt/t82B2CvUvEZTBU/jZ1gL5YFiW3LhsLzFLRUa6R74GEbo/3hFOyaTjOZzA1z+7J6dYfYcpf9cIcQD4KyKpsnwSMv/4pNfmTdhrnFokDtcZWZO7o748yCZ2bra/9Om7rHmaFv5oGXsLz5Qop9xM92zjhskdMB7LX0ya3b9S1cy2qvkK6zbSNvXAkyVas98y901g4WfUE7hfmKmX1o8orcC7BhgBet8D49fTvdZGQB6u9tIsQEyx3vllYtyOVZ0dYO21c8n1cCCtoOIe8Qbe4+SG2jftagZZCEfMvkT50wbjGqB7O4DQIRGOufq9Qf3IdpqWhYrd9lKV9CedI2ycgSv/3tLKjW/HeNzexJ4IJfcNXzxfDCvtLvxGLEiTf2z8l6yV18jYGmBCWUVMSpZ0jEMUeYq259SM8io8H99bPz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lhzgM/lAlpYVTAwG8vYAm9H0/wVhNOC3qP2wx/rofJ4C3eQ/ZhbAic29NqVD?=
 =?us-ascii?Q?Pg8sw2x5Q6QHMYYNE2dUbj+YQ5XZZCAd6Z9x2cJqz9vkko5P0weD0knkYPio?=
 =?us-ascii?Q?wMOrk4GGML2fAdIYx2riwNhIWGjqCqNY699OxdVupZg7pB7eHboM5fwm97Az?=
 =?us-ascii?Q?RPBRXNJtdDRnx27G36aqwzsjNcmaO9bYg3qII6V6KCJgCmitntAD+CoJxkBM?=
 =?us-ascii?Q?ePmQkLOhsxcLMGWk3IsWgn0RG9QrLuIyFbF22vvIskxL8b7fm+sFKx4jJCIo?=
 =?us-ascii?Q?mi1RWitsLKYDUjzfoevNB6y10hDTujo+Tu+d0ezHNYy1h81U2N2Gib5n7Siw?=
 =?us-ascii?Q?uf+L0ysoUDkydI7nKxVZs+rtn81HN9omMlkvcvwMU5XR7D0Y1q53SYyMRmNT?=
 =?us-ascii?Q?+1e/M1H6vtu0EZ3q5R+FIXZWvUZ0dBlsh9l0q4SbyY7H8K2PTeH5JJ8w8oSr?=
 =?us-ascii?Q?ltb0HxcXUFZgh4Lh4CI/p1XOXHGeX6kp1MF301HygS5gyZWegrmMrbP+EJD6?=
 =?us-ascii?Q?MacyoOLepNSGrb9xApx0uX2zLkjJoxJ0JeTQOExj20ZSPboau7DAge4Z71Bz?=
 =?us-ascii?Q?EFpGq5ZNIJmgqx0QbHkL2RcUkAeaLI9nl0VF26L3kG31m08RCl4TkQlFpF1o?=
 =?us-ascii?Q?8ufZW+xCT3vEJsWur/SAsIJUj4Z9fxjRTDfK3HsWv5HOJNBS7i8m4rsREOBB?=
 =?us-ascii?Q?V0vbRIgPg6pxlV3GkoMnDmmoiyMCemneThFvqo7sFFU8lxVgAaXMdharKR/O?=
 =?us-ascii?Q?bnvkzVvNKfB+XtPyO175oD35uNx08w6FWKn3NmCCdd4rxUX0IUx/spRpMhMe?=
 =?us-ascii?Q?P4+5sA6E5zSkruLkgExbBZjHZOZhb301voV4Cy82OFmXNIbgedqv8cxAQufq?=
 =?us-ascii?Q?VZRmJQqOWmRsmE1rYKXhWA/hsK+4bWPgef+0z9DTfco6RqxFvJtzJtd8+NP7?=
 =?us-ascii?Q?2ZAfBPZAh9AN/V+/BAbjPxwGZmcE4rsq+e85hYn3sucrBSxPbOiZCqWd47iz?=
 =?us-ascii?Q?m8Us/pgX3yFhRwc8lp9h8YNrLuRNCoD2io+KS1S7ID36Fr0LmqzAAC694SKJ?=
 =?us-ascii?Q?4ggx5xJ11XcUs3gl8sMzXAscAEfeQIfd/fkIgmFy/ir+a+3Dn87veIGWsxI4?=
 =?us-ascii?Q?QZ1Uu6m2ZL6o56TM7xrTfUVbZZJ9u8ARx6+rBWuMQkni9iBxlLnvRXqRv32s?=
 =?us-ascii?Q?xJx9i5zkWMQpleY90598NEMrXcvrzEx6f4x4d+XLBLzrQW3WHuwPNBxjq8N5?=
 =?us-ascii?Q?ar4eLhlVfcUXsO/IJR0xkEcIl8e+g8A3ARGK0dU9WXbvslR+7RVzqLaB9HjD?=
 =?us-ascii?Q?FAIaQSyOx0YfKk6OFAUD/Z7RP/p8N7BozvUC6GccWTAnhLx+SE0pNr9dWsiq?=
 =?us-ascii?Q?57jIqTqudQI3l5UIa0zi3MVisjnm1uc5agfhKYVpkawUyG664hjZrW2AkLWX?=
 =?us-ascii?Q?DAmD//qkJCh9jluZS4p3yAzTqdgymDlhyBlWdA44CKOKEgv+U3AsjZadZdvw?=
 =?us-ascii?Q?8JYMfnwI3ZAn8H6Gpom9tJG51qi3co4lh1LtyLWoENY2LXKzzzTn8eOmKAVh?=
 =?us-ascii?Q?Nom6ArJGMTWbT8ndiUZ0b6FZpf5zmyNVeK7rI1L/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XSzklMI1VNl40MVDM7jXHHPUB5dXqIyef1PN7jlcGMZPojPAUPzgIOzFE+CbkEhnPDyyTTB/jqWdIQgqY9bJEaGPSmnI+2GlSZRPrg7jLtKRX0Z1DEr/jScFht0alvXpV1w2mBAk4EfVu9QV5DAk9tGHApy7/ujqofcAea6Yi7wPx5ZD0DC8ud4x5RzTSMyiY06yjAVs2++UxCK1hNMZd2EPxPuoML7TWwW3Y7cu+R4hnKZBcU2VnCHUAHuZs1AkLcFTuvigi8ukMx8LOcJnPkSIOqEh5wJqyAlv69pw4cdIzQcaWC3SFJMurQAMOuQbCPQdBnzacvWPLA4aOEbHYkJjTr17zUWCcz8t5bJMewHi1FW7NOuSjZZiThUttL+qearLCmN5GXB2+ymdUf8idN0n7URrKweWxjJja88rcPHPoZtxynnL1Iu+q2LgkdD/TDDvewHDbR9pi1j7d2NYhC+Oog7oSsHBFzE13u/lG3GwUHXB9RjN1vkDYX5dshd6U57eNKxMzDWV6wpIyS+PMGuO3NCmP//qaidxr2UUKTaBAEnb+yiC5dC+riLUWush3C/kBTRhGssVI4lJHL0OZJ0izujVvAKIGjqGTDcC4TbEAMrKG6BqOgqXvSF6GAMSL+16HSMyPYohRgC45MfQ921rHedffgiTPjH1bZoU1R6OuGmeeycsbdIxkDh1iV99ZSjKbgiYsuh4keS5KMBFg1kR09pFfxcTtWgJlerM8hxCvW1Faqor+IcDk+Gr5NG4S9quj15K8nS/+v4+1zzhr4yA8OqOiGx5Aiz7DoMj9e0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b58cd0f-454a-498a-ce4d-08db66707c4d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:29:11.2772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /CJmsetWe9VP1hiANOcTN0r3zxQQMb47WsdBMfuz1gVy7Vd+yqSAlcxcpa9kK/r8irMBgZerS0P/Xx04ypiK4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: ClkKyU89mhv7AATie1HnbKLvnLLlLFWU
X-Proofpoint-GUID: ClkKyU89mhv7AATie1HnbKLvnLLlLFWU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We will need two sets of functions to implement two versions of metadump. This
commit adds the definition for 'struct metadump_ops' to hold pointers to
version specific metadump functions.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/db/metadump.c b/db/metadump.c
index 91150664..266d3413 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -40,6 +40,30 @@ static const cmdinfo_t	metadump_cmd =
 		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
 		N_("dump metadata to a file"), metadump_help };
 
+struct metadump_ops {
+	/*
+	 * Initialize Metadump. This may perform actions such as
+	 * 1. Allocating memory for structures required for dumping the
+	 *    metadata.
+	 * 2. Writing a header to the beginning of the metadump file.
+	 */
+	int (*init)(void);
+	/*
+	 * Write metadata to the metadump file along with the required ancillary
+	 * data.
+	 */
+	int (*write)(enum typnm type, char *data, xfs_daddr_t off,
+		int len);
+	/*
+	 * Flush any in-memory remanents of metadata to the metadump file.
+	 */
+	int (*end_write)(void);
+	/*
+	 * Free resources allocated during metadump process.
+	 */
+	void (*release)(void);
+};
+
 static struct metadump {
 	int			version;
 	bool			show_progress;
@@ -54,6 +78,7 @@ static struct metadump {
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
 	FILE			*outf;
+	struct metadump_ops	*mdops;
 	/* header + index + buffers */
 	struct xfs_metablock	*metablock;
 	__be64			*block_index;
-- 
2.39.1

