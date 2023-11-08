Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7674FC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 08:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbjKHIdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 03:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjKHIdO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 03:33:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D284F10F9
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 00:33:09 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8860Jg020343;
        Wed, 8 Nov 2023 08:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=ozQE5Cjvj3bpjf1TZyTerGHJxSpTGznuDGTULaYTD5U=;
 b=Ae/YJAeSYGdRp5mkZNKCChBBuIf/HdX6W6I8AWMvyi5MwBTHDINX/hYfN3GIYGW/gmQh
 YoyDv/7PidPZNtLOh4j7c4XmnI2qewzG6UsKr3C2AVIRxWMK2S/GYEd27rt+s+pphiGT
 +tJMq38/xukOhwdIakC3mtghFaI+73etwON1JyVItndMYbP2Dw5PBIBqK1lVql5xkMe2
 FbtMhz6cVGhLvZmlJ6IlujFEtqGKHmPD8xJKR0Q4XPo6kqZl0wX65b5g9fUyhj4+t/Ve
 RU5knLt+yYMskTFpUug4VW+LeHO0I8DnUmxgEbmuq4XcTrfvgYyGrL3KZnlVl9Nv1KsQ yA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w220y75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Nov 2023 08:33:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A888bT9003884;
        Wed, 8 Nov 2023 08:33:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1wd0hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Nov 2023 08:33:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evEcb8ad/AfUqPQ3/UaHuePqX7nesbEjCpFXpZqxOxQNAeNOodd5ANOlGibAlgbiK87XeIvrQR95aJTgqQ8FCEsa35cNt+8d9NglQW6ZmOIvLlY610x7cXGo8j9XSoHMOFSvyAS8XDGDIKrkua2iu4Yya+kth8K4xiuwcvSBmpoqxMGKCEGikDrJO6WiOZPOuA7GqFkvMEKfT4CdZe6mGSR7adOrtpZg4IAH0mniDhXsdhdaVx07BTMhbUm3NCXthYoPqlA4rM0Vn3clGs5o9GByPK8g3pTqAXkZHxhYltQfgGVhAvUUaQQ0t4eX59F7O+B2684i12WoYJDCeDFEbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozQE5Cjvj3bpjf1TZyTerGHJxSpTGznuDGTULaYTD5U=;
 b=Erau7qNE8Iyp6+qnUhzghHCryXcsEZQG8xEKCybQnsn64l1ifvJGONyRddzO+A6FRyYzYtwPAhRdxpRv6bCLAwQ1B0UTYIrGMMw7HgUMf3VUOknsc6whNkqmqs5r2Y9y8rKqOA1idwBecTTMZtfZSPWninTPEswBx7uRYITbV6NohBb2Y7JthGVT6U+PRpT/lzTT1Cy9230M3Fa+lp7U5CVf084AWbEfDcTv6dad1mSCbgwDYr1klYA34UYSvea/rvEQo55VeyMeNLEcMAkE1lRfcj2XwE+pVmfV8tuyQfPeShxflrhmMbeKX/HgFvNA2vv4grMBSx95V/Pyuh6PFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozQE5Cjvj3bpjf1TZyTerGHJxSpTGznuDGTULaYTD5U=;
 b=i+T4jaEa5/dBndAuXp6f7HseDSKWOqwqYlIjwSolsb6O3OWO8Jwr5OxBR1Ttu8AB1tmWPkoCMbyxtQhXNZe7uV9lkF+gQ9XcGhxRPgLw97T8y6q7mthgvfuOEyUWDdOUJo/SKEo0Yc4ErusWe2tQi6beMUI0TRVQwqA2WT8n2Hc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by DM4PR10MB6088.namprd10.prod.outlook.com (2603:10b6:8:8a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.33; Wed, 8 Nov 2023 08:33:02 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Wed, 8 Nov 2023
 08:33:02 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 2/2] metadump.asciidoc: Add description for metadump v2 ondisk format
Date:   Wed,  8 Nov 2023 14:02:28 +0530
Message-Id: <20231108083228.1278837-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231108083228.1278837-1-chandan.babu@oracle.com>
References: <20231108083228.1278837-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ba6bb39-13d1-4946-9873-08dbe0355258
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcJQ2LIkiF2xE26xv+Y6Zbvvsb5fZQdOg2ByBZMbI6j0WIeIM4bO6EroxMeh2B2QBsDpLf7Mt5YzR9lhwG6ZWAE6SQJ9HXaLpcZdTRoUEJFJJRpFdg4o7oKx/6f//SIChGJ/L0NtkW+Ni+GwREgWQ7yhWJeU2jydQOQOc0/ibPcMpjnjix8USN3d1eGzivnApEaIZ7Ra35io4oMftscpYqLKlMIhG2KHvjqUEsPY/mEAg0dQ4NV1cJ3mqB18DEAQWZNrF1BKUhlnqiLIwI6yBF1AGCtrkQSdQXxfIsPLqN5VdgZi9zXMh/CFke1cqrjPI0GBKYz3sOWJz9NOr4eMQpEhfJpbCHLimyR/lj6camqadssNuT1gk0SwxYMgMl6LmpCSenlb+ax5Zf/5mkODxfdrPSPGwrDJzpqn8XqKIUTVbr1GyE5pAu8DdepFCZdYk5EAxxBiqUn5WUQjpc1tMvOnYmeVE9JHM1c1/8aKuABHsbpSyn1UiqrBKkO5ojgFGJ/arjbM774PBc3Aejrm75rGcGA8lR8JfFDoBJj16vJlpbi0J3glJWR6sj+iRnH3GStqOCgZQE8cKXeinhRnm1S1R192eyrzBhBqUZsCSex3hE7P7Jb3VKKm68+CpQOb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(376002)(346002)(136003)(39860400002)(230273577357003)(230922051799003)(230173577357003)(186009)(451199024)(64100799003)(1800799009)(5660300002)(6512007)(41300700001)(6666004)(8676002)(4326008)(8936002)(2906002)(83380400001)(38100700002)(6916009)(6506007)(26005)(478600001)(316002)(6486002)(66556008)(66476007)(66946007)(66899024)(2616005)(1076003)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PJbqOsJhdj+lV+xrjn/h5bWJOHb1YLuqqzux4C/Uzk4kMmDHS+KdkO1+h0vf?=
 =?us-ascii?Q?uOVc3uhENXWRc2J7epk5ByzTyUsEqslm3aLZHNXyCHdtD9LTZ7qcSYEaA1g+?=
 =?us-ascii?Q?8cs2ki9QdO22F2MWpsiJn8/y5HnZ8IyiDG2QY5y9un5uzoz0rJJZXyx/C+FF?=
 =?us-ascii?Q?ZV1GUv4MMHNwQXdXMtzjFQLsiWN7vkOmZSRA0+HhmoXYwRZ1Q3yw3sv4Ef2d?=
 =?us-ascii?Q?hKM+jy0giFesh+qAfahT0uUNA3UtAxZ0aEFLAmqlKw9wOjvrrCBaJwzWhQYW?=
 =?us-ascii?Q?gYZ9nTUoZCBMzO6iT35c2o5EOEJUjKDZXuFXwfC/sjfooh2Bsi88mrMzJLxv?=
 =?us-ascii?Q?6AHCvEoBNhUwPoUrKXwKd1C+RznaL7h7o/d/qJh4K0fg2bRJpOAtLrPUykYw?=
 =?us-ascii?Q?1CWrzmqSGr790Gl8rUo8omslfDnTfO04f1S2SwnkPT5HEfnc+TdjaENNEHm6?=
 =?us-ascii?Q?QqnIydalqk3l8zb4QkQkvdKkshMPj+bB1oPNvEmpydPY5fFB3a0ojtmTElkC?=
 =?us-ascii?Q?mjCTLLS0jfYMeHKJHvYdmXyZePSabtiIx7rnvP6BLlZnDObOZIxhUJOSrjs6?=
 =?us-ascii?Q?kiZ+guYVqhGlNnod7aW5LJUTr+ytLXjt0fXnWAUGFPPj1aaXCfYK0YN64qRS?=
 =?us-ascii?Q?7m74QO05CBCm9tWyjbdgPSWcgJ18Pv7hYEiPS8/C9v6FFYk+eRfWyTsSbyMF?=
 =?us-ascii?Q?xvLVS8yJByFBZbGbWOCZnIekaxM0sd3EcHf3HnYwgq9RDJMqZJEPz3ihnYC7?=
 =?us-ascii?Q?YnLsLWLJSIaFJ4xX7e0o4pMccsh3Uwy10I7GT7kOL1jaY04/9LcPJlqRawlr?=
 =?us-ascii?Q?iMkkbJ1TKOS0UqflQ+Z8UXAqPlRcRLNPFijksjKhyuK7+A+ln6VsIg+NaOia?=
 =?us-ascii?Q?saPsDfZ3zoQ6Rea09THIRmg2yy1KWZonfkFSWUkRxHB1H8lK5Os52Oh1Dpox?=
 =?us-ascii?Q?1/v/YG5hJWbjdTxI2e1sPjKJba/VuZP950J+7MjbvB6NIlML+n+1rDqdMD0A?=
 =?us-ascii?Q?dSrHE4tKFRLLDs8AbIb2E0/4pLcdOip+PJSA5Rw/bniNUs2uhmWOq3z352eV?=
 =?us-ascii?Q?Ym1//gxiyrPtQJ60O/kdrFiOmIWjCu1YIQuWnNatPV5NP/rY7olg2Lt3Mcvt?=
 =?us-ascii?Q?Ey1ttx4KE1B9sCkv/rdtm1SqFzwT0zMKkXjP5Ti7EdTtULFcVKvIDXsjFpOa?=
 =?us-ascii?Q?N6wd65+GFE3VKty89zNuQV47/3xO6lvAIeHtBQnqzmkLksZd7hgLdY63AGcA?=
 =?us-ascii?Q?8MsybKMCN/hsKNGDb6Nn4bKruhSgTBsy93/QKw+idryxzUj8SnECQAgb0YHv?=
 =?us-ascii?Q?fW4U3wK1kYvZLy1nr4tHvIr3PonjzZH3ed5ExbHvQcOlf5o1YYNv1FRtY4D4?=
 =?us-ascii?Q?63SDHA2QPF+4s7EoCLUWHIcG/tNMduT+Fg5ZI4S1m3jQ19bCljUSCv0NegDg?=
 =?us-ascii?Q?pRrCXzcc06fNlpqxk36RmqfOJnmkhjsLRifX+MKrtyMxzhYxEy2T2R3SHf5R?=
 =?us-ascii?Q?C1F5h488LeQCSwC9eA6Uoy6/haCVEIN7Js1MQp2ueheftzju+GHGbUVEZaBa?=
 =?us-ascii?Q?Df4cRPXDjImOXZOtnR7KnoX9TpMn5KnW6rT8YSzL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eHqC9BhW9sQvTQdWk26ubiiR7gAEnp280sGoaof8hRbN+wYvYIpWsaqcH3GwXGNU1/PYmz8SxnFrkw+fS5Mmy9yZfRJZdEnqs07vTOieYL/tcbr2D6jgW2JRlBSv6dQuIT3+NXxUic9zEf03HJe8/YprU+KOt3DPSVVaO/JFX7YyCNKtm2z94M4urwZvKF1MI2wsiWpxMUdzSVBgefwelPxkcXya+qNtDqBVsXt1Xifjo13fMBXcztCykKM47zXvGVmghtJ/0xikEvKZPR8GOgejxQHeYdSRR/26U7tmn+KXORZmexCiU3EBoups3LUWWndA+JMpMyt2D1rloCgIj3rpR6CtAGg9b14aSie783fHDq/HzM/rUY4HK0HjAQWRiq0DWLq1P33eoC1N0BPSR78IjUrpofLFtdR6/UTAXp+MWtdcPJENPIuA+Sh1AKz9HWlfecwvHFJBvaUivllrY4bTDRLbBalv1oRTLGkW0CyzPPK86OHJOwpI1TOgcYylEK/TCER5euynNA3ahDNCmIdd8/B4KAwci/PXv/2CrmGIbCkHisKZEDDJYAuRC9P1WZBaYqkWR9E12NqifrSJBxFO3he3e5Z0UlnAYxD0icOQpmOe6tVeedk4uQK/b4Z/Izk4auq2gnHh1S6sf4W3FbtXzm/RZgwlkzy6qeDziE3QQwkatkK6BZfZrmsg9UT9AFnr80d5PoPoA8I3tA6ajr3qiLW7D9jMxB7mAcmr9FMD68JbJKYmV5+0uNba02d64qqO2h3MlnX8ulKJQA/68mXnNsvnhI6r6UgbIZwaBSo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba6bb39-13d1-4946-9873-08dbe0355258
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 08:33:02.4468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9AYkrwnL8T3b7j0FSRErsjZcMpBmKJ34irgbmXVGMc/QFq7YOSUFVZp0CNMEz1JAqk+XR2EOZR4I6EdUTGktHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6088
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_01,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311080070
X-Proofpoint-GUID: tbip8KCWBYAoj8Vp_r9zAAxUezrHCTpL
X-Proofpoint-ORIG-GUID: tbip8KCWBYAoj8Vp_r9zAAxUezrHCTpL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Metadump v2 is the new metadata dump format introduced in upstream
xfsprogs. This commit describes V2 format's ondisk structure.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 .../metadump.asciidoc                         | 75 ++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/design/XFS_Filesystem_Structure/metadump.asciidoc b/design/XFS_Filesystem_Structure/metadump.asciidoc
index 2f35b7e..7ce993c 100644
--- a/design/XFS_Filesystem_Structure/metadump.asciidoc
+++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
@@ -13,7 +13,11 @@ must be the superblock from AG 0.  If the metadump has more blocks than
 can be pointed to by the +xfs_metablock.mb_daddr+ area, the sequence
 of +xfs_metablock+ followed by metadata blocks is repeated.
 
-.Metadata Dump Format
+Two metadump file formats are supported: +V1+ and +V2+. In addition to
+the features supported by the +V1+ format, the +V2+ format supports
+capturing data from an external log device.
+
+== Metadata Dump v1 Format
 
 [source, c]
 ----
@@ -62,6 +66,75 @@ An array of disk addresses.  Each of the +mb_count+ blocks (of size +(1
 << mb_blocklog+) following the +xfs_metablock+ should be written back to
 the address pointed to by the corresponding +mb_daddr+ entry.
 
+== Metadata Dump v2 Format
+
+A Metadump Dump in the V2 format begins with a header represented by
++struct xfs_metadump_header+.
+[source, c]
+----
+struct xfs_metadump_header {
+        __be32          xmh_magic;
+        __be32          xmh_version;
+        __be32          xmh_compat_flags;
+        __be32          xmh_incompat_flags;
+        __be64          xmh_reserved;
+} __packed;
+----
+*xmh_magic*::
+The magic number, ``XMD2'' (0x584D4432)
+
+*xmh_version*::
+The version number, i.e. 2.
+
+*xmh_compat flags*::
+Compat flags describing a metadata dump.
+
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_MD2_COMPAT_OBFUSCATED+ |
+Directory entry and extended attribute names have been obscured and
+extended attribute values are zeroed to protect privacy.
+
+| +XFS_MD2_COMPAT_FULLBLOCKS+ |
+Full metadata blocks have been dumped.  Without this flag, unused areas
+of metadata blocks are zeroed.
+
+| +XFS_MD2_COMPAT_DIRTYLOG+ |
+Log was dirty.
+
+| +XFS_MD2_COMPAT_EXTERNALLOG+ |
+Metadata dump contains contents from an external log.
+|=====
+
+*xmh_incompat_flags*::
+Incompat flags describing a metadata dump. At present, this field must
+be set to zero.
+
+*xmh_reserved*::
+Reserved. Should be zero.
+
+The header is followed by an alternating sequence of +struct
+xfs_meta_extent+ and the contents from the corresponding variable
+length extent.
+
+[source, c]
+----
+struct xfs_meta_extent {
+        __be64 xme_addr;
+        __be32 xme_len;
+} __packed;
+----
+*xme_addr*::
+
+The lower 54 bits are used to store the disk address of a metadata dump
+extent.  The next 2 bits are used for indicating the device.
+. 00 - Data device
+. 01 - External log
+
+*xme_len*::
+Length of the metadata dump extent in units of 512 byte blocks.
+
 == Dump Obfuscation
 
 Unless explicitly disabled, the +xfs_metadump+ tool obfuscates empty block
-- 
2.39.1

