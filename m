Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10319C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiKGJDk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiKGJDi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802AD120B3
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:37 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7903g9023373
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=acbjfF5lLh4Gil/z1wg3K0sLLs9EzUUYHdbdaKRxaj0=;
 b=osE0bWgck7ME5YVjjWVULYLXV6w7zzK2PmVeci4FdxniZ7heO1LtUTnIDQ91t/cc0keF
 Myjt9pdVpPp1steT/MZn72dBEdo1RLBLskey2W1zp8muulDCZzHCqMD3UbQIY8x1jE/+
 96MbHr5Fr4Pmh+GShtOL90qxBQJu2LPEfyGyoL+k0FER/sotUUTdbX2YWvlIleJmTwKy
 2JpuBqkanQNX1BXxTs8IeLqhekgTmO3oTmrs9zD7ySH2DLd2bhhB8Q68EOv76H+wYlw+
 ydYwqaVEQ/Agy3MaJGmbqgaFZu77ii4EjwG0ccFHPSgD82IWabgp/ddHRdGeB/cEzOSK xA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngrek5fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77JXoA025146
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqek6ua-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiFj/tKwVTbN7lnUFoUjJLxb2Oxp1KvbymWKfua5aoqbCMM3HdKtbxfX76EMz86hZv1QR8HpuMtb3kA34Hk/2Gr72hg3TCy+/6xvWStHfCbT0+sA/veXFyk9brYvB7hgAJCjbEFzxkCEB71Cj3kb8sXXHWumtim2M28URwQ8GBEr8YoUG0ADS4EFvnAFXoVDMX6VRBpvtsUU++n7C0Mc7CymmCoCaOU8RROrCd1fHI3OCqt7V6OkRfnUqlzgS/hHtCpaoSUUwnK3NGEpeWaaQAPT41maUn+o0bmfVJ8xOmIWzCIJPoLd8YiXU6qyj2nZI6hzkgKFheGkWRGbLVobmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acbjfF5lLh4Gil/z1wg3K0sLLs9EzUUYHdbdaKRxaj0=;
 b=gtEOBzgMlImwMTep0Rrs+HJp1dg4rsqXro/nrIdHd5HbmouCmSH61Jto8ECZqiGEpnN5hdqu9NFcFajyHcJTRoeW5cMMgR3LFFGHF7f6+dXwOgCzuv01x/5CeI0f9bhe4n4/AEuNlfiPLmC6nEOhFScacj0yN4GCkthnhYIxOUQT94R+UphGo2c3FIASfa4erBHgZBN+1EHQvHTJgHt0uAiY+CI9/Yqx3KjTDB6mM1bIFXuQyQ821/NVydT7RyUknEsS5LzDiecsAW9yC/IfcRZd/yA5X6rV6zdmq7M0GrrKVk6/TIjHEhr+ky7Oc790mgBLXTUf7s0yQVDKS7HONg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acbjfF5lLh4Gil/z1wg3K0sLLs9EzUUYHdbdaKRxaj0=;
 b=QLoa0vDzwbI7hXUPfT6ff4OXhpXpTURRFEKHsNWLGGiEx2EqluRjftuuKeB5Qsapf1zfynW3AqeZIUu/lKD9U1gmwYHx2umkZ7UmZWmt8roSU7fVtGIAWWPjEPkHILIFRfTzmhTxqfKVSNnNLpwMX849zfmmWNex8XGPGFrCTL4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW4PR10MB6346.namprd10.prod.outlook.com (2603:10b6:303:1ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 09:03:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:29 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 23/26] xfs: Filter XFS_ATTR_PARENT for getfattr
Date:   Mon,  7 Nov 2022 02:01:53 -0700
Message-Id: <20221107090156.299319-24-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0029.namprd21.prod.outlook.com
 (2603:10b6:a03:114::39) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|MW4PR10MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: be56a27c-92d5-4ea9-75df-08dac09eeff2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aw143ao+K5UaFoIpbl4QmPSwFYYBnT47Zm+umWZ1Dq7X3x3PDZMoQ4xtgosp2t1Ol3YwUU/ZDoqS+HJWCxchBEqVdGrjB17vxc3Odz0xrQGj7dbL3/d0ipzxW35tMM3mxlv9gVvW0MtPOcUtexhR6ZBpa/j8GnYcXXUS64rKYKIK4uOoS5XnJ2rn27HBSwcHVAno+c++R1m2sOqx186UZ1H74harwReYZe3NswWmnFKSV0+IDT3unJbsSY3/M2xgdTWN41ea9vWCoUUpR/qkM6kn7WMSzAxlmnV807V6YTKuUthxPWjfLqqOTttsVY9dRPLyuI6qquuFgyGoTs4cd7ttAp86V1/eBhuxWXF3OY5UXcbljXWkzfCVFbcAfyiD8c0Hn+yyv4rVEue6Av/TVPMX4yGTXmQvYiAQCyKN93thJv5L1mEt2ZsGWtMVVKrlxCVgV1UXjfa5tDtsySU+jR5PYVNzAysJCdl4p3VSOlEkIQpU9SAzGlLnA+h40E5LabedRz6KBtaexEhgi+UXaniJF8p0d8K97CvfB4BMGg7u8MQ0Cb0ponVbztKQDC/2fxXV6lV1zk3lvZse+emwXFuJ/xDhP56kohJA+Q11Md0PYrBxL0fDF29OQN7MfxGkiFe+fu/O/C8jcA8nwvVcoAhQwG39D9D6LHARrANubyUYsXqHrVmDXLdE63eU/fS3KKFFVfWaLROeDgNUP8UARw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(38100700002)(6506007)(36756003)(478600001)(316002)(66946007)(66556008)(8676002)(41300700001)(6916009)(8936002)(1076003)(5660300002)(4744005)(6486002)(2906002)(86362001)(66476007)(2616005)(6666004)(9686003)(6512007)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qvsXgcGTB/s5EvZeS9J7gksdeoQwT1B9iWYpuQZP77oUlbtd7gfn1lzvZt5x?=
 =?us-ascii?Q?WyMQQijNqN6EVLMVXdUl9qPhGc7O7bh42eRrqBnwvygMt9Ml66t/oJ2Cxvyr?=
 =?us-ascii?Q?NwcGjwU5bZRHQhxspaYygjkyiiE96tYWCGq5nXKnwBSMQpGUquaB2WAB9hcP?=
 =?us-ascii?Q?+iBJl0H1rsIJwcjswekmJvKEGWuhmO/RjiYOCo8yBk+OheuVlVQfOKwlfWy3?=
 =?us-ascii?Q?ElewCo/7UBZUl3jr3QM0Q9/JIyefu+TLpHPzQ1oybCfOxQj4Ggyr965S9yNJ?=
 =?us-ascii?Q?BQNsdq8cwUPFullAnCq5LleGo4TcyQ9+I8m1tpgd7is1eQWmR5CMlvsNi147?=
 =?us-ascii?Q?0NtqLkCofo4oMXVXMgdEsO1GOg1DHhqc/WqQII3DrUgusmN0Gf1YjEI7iEXc?=
 =?us-ascii?Q?nhsqs7uVeLd84euE89453gC1qeh+Z2T3Ex+xulyaODkkBR8id3zRjfGGy+pI?=
 =?us-ascii?Q?RN0DVkDuYYpfTtBn1N1VgL5PoinUckHMmn3qh0QR12F3dBG8kuRsTqlmkEZg?=
 =?us-ascii?Q?11rKa/XjVaevLd1k78+3moC+HHKiZD+jHZyvT0W5Bp6ylMQOcju5QiKBol0k?=
 =?us-ascii?Q?c9jZePwnhpdT/1p41GcsNraMV6MqBNIvB2tL3xXzGKByq0lHoBmw2accVjd1?=
 =?us-ascii?Q?QhZMoATJttE5SJ9AVv4idX9QpZtYSlFEY/qh1MyFMqHGIqpZtlTdgwoH0yha?=
 =?us-ascii?Q?2Pu3hg3Khh3GPy0dMRpwASXOh73t6jkDCnc1k6D4A6zSxpqq7Su9agZE6UNj?=
 =?us-ascii?Q?0gk/eQEGwi5hlB6YCke0eLPfee+AxQO7pjDYfHIBIKX5P2fCHTs79ZmZW5FM?=
 =?us-ascii?Q?EwiL0QjIIRJeVRruThqot5FcRXLJTZx/t2Swa2jybIU4nmxKwSOcCiGkTPXW?=
 =?us-ascii?Q?/GzPkzIWj37VoFVB/8OWSRTA1tZEtq+XVKftXQxsrj6G8z16/+MaMEep+NnT?=
 =?us-ascii?Q?V/FSnWu+gWHuxfTTW/xwZxNYA47GQVCjndvkrVsDZyperZkdZW0S+rSU3FPm?=
 =?us-ascii?Q?PLupt9Dzlfl481gi1wmBmS+h6r2nV1vDCle2TPJ7LMJTRd4jcLdKUXE4n6Y6?=
 =?us-ascii?Q?K8e38+t7MvE+MpmN2HaGUeSFmO4lyvpKjsabeQLL82CfChhAHN/2Nu3RW8MA?=
 =?us-ascii?Q?tpirfTCPiYwK53xHHRypAT2bwp9EQ6SnjJpk9S0JxPLN3TgxXGeDXtrLmBMm?=
 =?us-ascii?Q?5LBIQQKq6lnBNKP2jP31q8SQbq/2lT4vnrWL5R5Kvs0DyFfbD+ILyCpVGVlN?=
 =?us-ascii?Q?miJmURJCPcReCsnP3sMI++u4K9iQieTBlT5I1KsydJvm+RZZ0X9HrC0cYhsR?=
 =?us-ascii?Q?d7HSGMFlm7Ul3WqX+F3Paeuc3JvrsJTUJk1fw+RGL2F432CbTunf2/duyO81?=
 =?us-ascii?Q?Byoa0kBXnm7KfzkQ3rI/TESMN6G+vnVS4FVfRANYI6BN+t0mKMFWLjFO7nuD?=
 =?us-ascii?Q?ts1LQnq2yQZ8zWE6ghdJEGqtU2XM9s76xvKlQZiYdIm9ukx5kNiOLnPT+W32?=
 =?us-ascii?Q?pt/HluAMiZGVuWVrTCZ3vOhkTl4Jd9c5H/zqKrI5mlGgeIJ2Tl8s4EgyAkXK?=
 =?us-ascii?Q?QZ7vVA+4GXuLiboUzn/XGejfUr3mm691Bf+N4AseVbpTVff2F5PJaVoKN+GN?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be56a27c-92d5-4ea9-75df-08dac09eeff2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:29.0294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQp4yrNQnIMfqKLYEKnLotJBa6jApJa4nhwC6P8sFvBgVhPVMLqGiSzLC8v2RJcEX2BVEDy01iRSHdijNK9CSJsbjS7bb/wTla5YSvGXktg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070077
X-Proofpoint-ORIG-GUID: CvWpCmY6i0akv96fz9qbKSYnbCEb2Px5
X-Proofpoint-GUID: CvWpCmY6i0akv96fz9qbKSYnbCEb2Px5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers returned to the get_fattr tool cause errors since
the tool cannot parse parent pointers.  Fix this by filtering parent
parent pointers from xfs_xattr_put_listent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index d9067c5f6bd6..5b57f6348d63 100644
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

