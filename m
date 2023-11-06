Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C82ADC0018A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbjKFNXg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjKFNXf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:23:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9622ED8
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:23:32 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1x8X006671;
        Mon, 6 Nov 2023 13:23:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=G0W2kGhgHyoeP9h2IX178fsFuOU3Fg6i54C8wrUZOrQ=;
 b=t86akfJC2ct4ZZyN4uROGceKrwtS5nMWsMAvxd50RpF6Lnad/mBZFs0wNcrnTGenU7t8
 fS9W0U9B/0BYzWWIJtDS1yJJYMI9dDS29CDsSWldCFUrVoqDwrjJtAhw80SjeqwOPz0I
 JMTCdDnG+z2Bhn0hbpr4tA4KDQv6jUXjrFtLNyi9b79hRJV53HFfaJQTJwATjoYxvHzb
 kht/OKYcT1LcGDebUKnwlvw16D08nyqjHX0MSsyMbYMvrFpxQgwsPDS1rNBtmv7sbA6l
 VKI8+drbRtwPPrbQDGhaq0S0w4OeQzeT6kebCmtkjON+Ux5jVhzzNgyvllnQkn1e+5lD OQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cvcb1xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:23:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Cfp8i030550;
        Mon, 6 Nov 2023 13:23:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4ub5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:23:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSZDD/TkT/4MklIfX79BdmfTs/MxL8KN85UcW/RVMnCx7p9Jd3PxsANUvu6Slx3RztvE4whnBBTN1lhWJm+wJEF/HQVTiP8ZS7fN8GnO0hM4HIMGbMB1fF8qqPNJO//AIvxliH3iN86fgrvyFIk/7aCdoqZkoOeGiLZ7AQa97IjKHtkCqM1V7y+HnBj8gd1pWmbv55xD38MBqnV1+mGvmRJNQwnVn05AFgPsSp18K3vlDUobaeIdy+KUZvntm91KA4Kovof0t4iWKbQIKFPGMOXDX7Q1BAt3v2u80Qax6xM9Loelmz62CHN9ap4XHzM7Gcrd5vbJlbPbGUJmnDEPlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0W2kGhgHyoeP9h2IX178fsFuOU3Fg6i54C8wrUZOrQ=;
 b=BsvObqTE3DdiRWmg5FAlfo5NS7zzs2CwRtaQYdcz7Lwr0Ai0sYExul4Ha+KNfRMxTnHQjJMsEQyteMCLxYpX7zqV7ic4g+B2fyC2XEjj0gIdqTu0ismD0d6zo4GbFGlyCwrDvoLCoAvQ9VpHgTAu3uOKIDvQoM3TPEC84RhvSfBbaYk3JFi1HRdebOCC4bS06/swrLHsWfJ7xeNq4XhaRCQh+y/cfSEVzGcRgC+TaswrTt4PR7QmGXJW6rvGWGSAh9KbD6tw/ewYGMTOW9WXIc3M23+jA0tlzoTASdAR2/4xlUSEnTgpS2z2NhMq36UYa/D8FPpw2Xt++abL1hCJaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0W2kGhgHyoeP9h2IX178fsFuOU3Fg6i54C8wrUZOrQ=;
 b=mHVCBvYOVJ8GoinieF1d0crH8ZDtOzAW561CWaKIt1Q4LUtgBLkc1xLqG28zD5FfYKizTqxRGxuYA+bAbpb0QDBxFuwRA5qU8l/xNX+zPhYP59pzNe7/GNRp/JGqL/1ZflqeEHaFU1pAAx/3FeXSglYXq+LqfzLO8MZNqMq/6ss=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by DM4PR10MB6158.namprd10.prod.outlook.com (2603:10b6:8:b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:22:26 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:22:26 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V1 2/2] metadump.asciidoc: Add description for metadump v2 ondisk format
Date:   Mon,  6 Nov 2023 18:51:58 +0530
Message-Id: <20231106132158.183376-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106132158.183376-1-chandan.babu@oracle.com>
References: <20231106132158.183376-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0013.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::25) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6158:EE_
X-MS-Office365-Filtering-Correlation-Id: 18c1e9a7-d803-4c3d-9448-08dbdecb6aff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /oEovcfB7zyio5JdKmLCa8T9ViL7fyLSALHaJYeFCe8R7d+Rv5BJMxjcTiaNF7ExYxl0r6xstTxD2miPBrsYbBuUgR8JCCWgPbmFv5/BOP9ay4ofx38Nlqt47zOaCLTKxqT1WSCFzXK0j7q+U5I/SUpMlaougDeXdlyndBfSzflMYTKdzIyzQabnSNsFl3ku+i1lMZ2RR/jZx59puY+WANeaYa0BqYpSQRRt3uoNXndEkCXajwViQH1fkmXKlvvAqjBgnQ5Neuzsmz1MmT6+ECQKHdi5HVErPCvUYM8v4W6Cks9d3Xm8tUOpr4aYcyD0eJ17yqvbAG5GTZKQpRi/NZwPWdIrt2oJjL/y+XWrtPtXl9uvQSAbU+X79jJHNLA7ewcuHbw/AFM7Ija2iHW0wIDp77YIpaLcuJ4tTM70NiYuCVsohRAJeV1iaoQEiem42NLjAWLS1/1MMh+SEFVnGEJZKWQU2/FIudrYYE/tLFZ8FY86u9CvIKrqF9EaQ+QkmB/W+tIAGmZOdE7KiKQsDlJ+nUdw62BVOU5zXYw0obwxNzpAEgUz2WWIQjxmegoZ1FFYYtDsxPGrikOwMEkpukZINyZIFTdzslD8IV/EEeX4KojLSd5g1ivAvWwaHjH8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(376002)(366004)(346002)(39860400002)(230173577357003)(230922051799003)(230273577357003)(1800799009)(64100799003)(186009)(451199024)(66899024)(38100700002)(5660300002)(41300700001)(2906002)(86362001)(36756003)(478600001)(83380400001)(6512007)(66946007)(26005)(2616005)(1076003)(316002)(6916009)(66476007)(66556008)(6486002)(6666004)(6506007)(8936002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HqdlHqZL/bTRWsguwr9vk0Np0CWo/pG/a3DpjUAoCefpYU+pteZHaQ5Nm3pH?=
 =?us-ascii?Q?paLZlzoTIIWkOuWnaVPwnSXs7HcLK2/yTsO9SNka3wwwWFauOlkhHVY4JQBz?=
 =?us-ascii?Q?Pb+q1psc3J4wc3UlOOZvaGV0/SZ/Kja59sD9HI9gsfDQ3V68uY+xKwIRtBSJ?=
 =?us-ascii?Q?E2EPfw0Z5SwYe5BOZ16RrM/42bRnjls0lr/tQm3LDold7FCaN4gv2CpXLvYJ?=
 =?us-ascii?Q?fyfH62GqtAGPtYgmNMMvpJt+YWQB/rw0pm7vC/3WbUbyb8ImGqtXNWyx26b/?=
 =?us-ascii?Q?KST1Ktbty8Ktip+G+mlk/DeFbcNJ7m2lGMXLfX/n88hI1UX+24P9ZVUojHnZ?=
 =?us-ascii?Q?0HnFG9c1oZSM449cVBW+i0c2cawT1G0ApsqXmyR5280U8tr2w8fV8u3arXqD?=
 =?us-ascii?Q?yUYvE3/fp7n4910Mxe05S36NH4f6fM3QzFSRnYPgYcSWmZuum1PFgNxt3zjh?=
 =?us-ascii?Q?Xvtw51ykmTYIIvtRS8wPtwoHS09XQPmvvIFMnD0TqD9CvTQWobvCJ85J4VeL?=
 =?us-ascii?Q?7J3vnvcHxjItVcm43GhhxG2XSayUGLo+qN0wtrH6zP7K9I2kzCcJLdTRXe7K?=
 =?us-ascii?Q?TFr6vqtZIKOdHr1PwoouCKpAQLBVdV8A7OS7CGoazwBAdmBcFAGG/+x79U7k?=
 =?us-ascii?Q?Opuj67AMOZB3KbddzCPGPHSI2OqhcdQqqUNd8zweaiYoEJFFCx2YQeH5YKqI?=
 =?us-ascii?Q?uusUqXy2nmNgVJZnRlWpc9MxtCpzkCZXrodwV32Kx1UPTQ0pwMmgVzR5/9xJ?=
 =?us-ascii?Q?PCWAV2P6yZynHo1mD3Wm72kokcrVjMKsF4CNypjqWp0dgR3BFcLwLjN87rN7?=
 =?us-ascii?Q?dTSMGiBAFMoQZJUz2esOdcn6O27SJxupkTewY2EMg6kuoDgDeIX0CUixujV7?=
 =?us-ascii?Q?fPY/BI1LWTb1UTKsFnK0md9VLgRTLZ9iQQWNRs+KcpS3F2cSnQFpijoMVy/H?=
 =?us-ascii?Q?0/afVt3GNcmEp6UVS+6rardEdmsA4KLzzCSfL17GRjHisvkE5Fno1b9cWKNb?=
 =?us-ascii?Q?PRlSoitT3VWUW3g4Rxi0nOK0BExvmyA0I50zT4symQbwW2UIZEYQbdbc6Tt+?=
 =?us-ascii?Q?fGozWmFyaz+FURoftsYp59CrjhEIiCqTDaM2d+C6bf+uCqzTBcEefu+0fdM8?=
 =?us-ascii?Q?0u8Q7DvQMFOAfPCFcUJW9/QzbXBpTuk/LOSa5H0nqJppk8frDhNBWVNecX2V?=
 =?us-ascii?Q?Vk7PMXi9J7i30kdhORARbjUTStao0xnYElf8WFt7giypOyUfdqXqdTxvcjN3?=
 =?us-ascii?Q?UjMCWAXFvhW/UPGwYvdmlP1iaDE/COLH+V3rzcsNfdWIS+tp7rKLwPdvXjBo?=
 =?us-ascii?Q?vd1BfJa6+v+zZoVFD8uxKBF7ZlJGYDAs6JoNqWx9pzMXbvwDP3fPg4m1y6tI?=
 =?us-ascii?Q?M6D1LGYle0P83FdWo/svmXIXxUWCk5XpJElqwX2nlRTdIfKhDNG2zC/fhXI0?=
 =?us-ascii?Q?ccMbYdMGU11fS/4bOtpgRnqji1H8QhU+Zk7GPQF06c+RU9GN15+QrUorYiRq?=
 =?us-ascii?Q?0P4ewwO3RypVkAd60apIjJcCoPxtz/XhAfkXiIaR4B09201S4hEbvcnah4Yf?=
 =?us-ascii?Q?Lov7niGOSaQv6apOEBIKv6RqjSIf9nWdiC4Oe5GQ1nhS7/gUnhBgI8dg4rUN?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Y3CElWPgxa03fUyJUp7Ib2mEkUDN0TbhgIwOtHoVN1TeiYBZd9PIFL+D9dDZI7uVIIpeTMmUyz4cSOeOAGQNHsWwyfrWnIQr2dOOiF3VEg2SeLQL1OQ+T5zdh3flLQIt7lfiE0o3lBKWjFkas7Sr+nreySW0QMFntBj+XTct8XDbp3rqKyrghfImZwmysGZU5iwUo0tQtOcpQhgSBK8d+aW+MJqyK2hbVHnisK77WYLzpolGjNuXZd2Ox/YgULZyvt5CoqM9GXKnO5ub8Crih5W8ZerAkfMQ7r/fx9ZT6JgzWJUohZqtjtVBXy7Vq9Z2wIPDFRO/opL2sruZlg35KF1mJdjxQiFrgEZN7EPtEa0HBxl+C7b12qM+UbBJJcA3K1+8C/cnM4fxq5yLviG9egFo5YO+3OjoVFNRhBO/3W1lQTOXjyCo+on5OBSh19Hz0VJYueivPsDNsYJWWHEwf/xvnoKK1YkP2JcJ2w6mFDaS/jsTNokpbICbQvMjAo7zxRggXVcQJX826VpSbDUvsKKeZrB3BZL+YhrYFwuVVj0ZXeQiu6LJRB9hUUoDQ1lrRqAmrDB2jXn9HUeWPXJ2PSaH/TJ2ojnLWZkYSwLx+677y1cPhN8sqyDJzDcjeV0db3rd4MPSoCKBRmaARwpkn7u67g6pyngqnPsSudRSuMmfjJ3RbqDQsXywYzWmpCjUiNUIceF5n7CCN65RMHtO2fB2yGlX87TDJoQGDnuWKc/fzCmHblFWo1dHcPepNMUc4R7ZsT4xIdGhtwXU+L5L9LJaEyY6jmqSfR4Ew5LbD1s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c1e9a7-d803-4c3d-9448-08dbdecb6aff
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:22:26.0266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIZ55EWvbjnZD9DfFZZHageNvn6GoVPVb9Dzreox/kx9qrBlDjBRGNn4z5oM7UPbovm8ymvQ2lJxI0Ak73TX+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060108
X-Proofpoint-GUID: _lSt8hoa4z5QW0nhOwj6nvjnyHy7ohd0
X-Proofpoint-ORIG-GUID: _lSt8hoa4z5QW0nhOwj6nvjnyHy7ohd0
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
index 2f35b7e..782f194 100644
--- a/design/XFS_Filesystem_Structure/metadump.asciidoc
+++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
@@ -13,7 +13,11 @@ must be the superblock from AG 0.  If the metadump has more blocks than
 can be pointed to by the +xfs_metablock.mb_daddr+ area, the sequence
 of +xfs_metablock+ followed by metadata blocks is repeated.
 
-.Metadata Dump Format
+Two metadump file formats are supported: +V1+ and +V2+. In addition to
+the features supported by the +V1+ format, the +V2+ format supports
+dumping data from an external log device.
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
+	__be32          xmh_incompat_flags;
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
+Full blocks have been dumped.
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
+	__be64 xme_addr;
+        __be32 xme_len;
+} __packed;
+----
+*xme_addr*::
+
+
+The lowest 54 bits are used to store 512 byte disk addresses of a
+metadata extent . The next 2 bits are used for indicating the device.
+. 00 - Data device
+. 01 - External log
+
+*xme_len*::
+Length of the Metadata in units of 512 byte blocks.
+
 == Dump Obfuscation
 
 Unless explicitly disabled, the +xfs_metadump+ tool obfuscates empty block
-- 
2.39.1

