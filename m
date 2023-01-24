Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBC4C05027
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjAXBhP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjAXBhO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:37:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B921A941
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:37:13 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04tAn020240
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=zo42y7z36eXl40JdZeGr0jdxB/kPz4swBfoLgWC5vF7eJOJNuEIBqUBUh72UdpIAt4Ah
 aL0Wo+4gsdJgjvn1TEVG0oHlKD5ejwRtnoqZYMfjVd7BE/EHEfAxBuKivYNGn14R1TaK
 rX9vb4erpmoF/sixX1VfXj198DdEOquZCBeNsbD2FhIOcvYeJ3d9LlFFD43/4qJdfkT5
 K9q9sK8oVVKPd6ELA/73e2P98aAgY4XU01VlrI7oxMiSir4FZDVJI5eXMVQa42OEUZY5
 lP6jFNJ1P7XGCcZzP5U7//KGf02NZN0uxN+P7cnAUw7Q+VQJjEZrVaG7DWL+1SAOVkWb +A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybcbje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNVFTc023319
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:11 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4m6h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PW9tD814aOlaHELGQoGGmxKZpHqYKZ65pxtsUe3++CCU5PbUInOAToIGfkpPmj2vq5hyZ0vPLPY36LKItx0ngsWTFiDIIX0SONlZPxVbV7MAL1VS6Z8OBCb46KYgbLJWOOrgv9yBBcDe7R2LH837sQOhX6YAFB7zi4O97yEoWe5nYLe4SuEBVQDSGUK54nPwMeN6X42dE582Q5YsfBNIs0WXDnSqPsCeVLOOn1GnpjJWAuEkFiLqe0V8PONjAvmxIfbJixe6nSo6jj+P6QFIoGMtGRCX74Sox+NP9ol19Mf/Zc0ZdeDIEh3OxaBxpucYt7gfZFOBW0IlmmAy50PDLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=MQwXNFxCyIM8UwHBnfOMXgX0jT9XSt00NV7L9ECJBGi0inODBzaWucTlUkWpO8kt4twDH7ICdkE8ikf4Al2Lit2dJjryODy86LH7Eh1MFqeBkEtYZV5BCVqbUEghueH3Aj1w+4m70x7dhpphrl/5reFY90z4bPIYOqTdnUVbWFY4h1y2HTb+yw+vk1Qj8JIpp1rp/h43+mgtN4AVc6ZViUT7zBSxqz0McSYtFe6NV+zSMgH7SkP+/KLZz7uJuHk3Wrrr4u9CVTHPpdUpM1MIt3Z9tvag+JaV9s5EaSXayaNbrIf459wEV/Nf6xus4DDqOXO+gs9wtdovzI9e7Q02cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=r0ZdbdJJWUcUIjWRJD2L2/LXV5S1A80lAxnArKUGErBfUNdduM/wJAi/jewPg/JdQl2aqH5xkWJKmhsJhsAyY3YZInaKhtxApkR8FJOPneGQCMF62hybKTlcYiHfPOh+YZ4Ydb9hZPEgM6VU0c87IhIWbbsI9ec7zJS3hcm4nlc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:37:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:37:09 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 26/27] xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
Date:   Mon, 23 Jan 2023 18:36:19 -0700
Message-Id: <20230124013620.1089319-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0068.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: a0824eed-06fc-4d4f-61ef-08dafdab8252
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RFatrxAu9UzNKR1QSDUtoN2VDTUobpQRvoMEAyV9za7WIn89yK5t+VGZDDTyAf4CxDw+Y2lZQWsjGW/Ylc+YBpNKL3l3gLXjgtRKqaEBA0UKs42RO2T7WAPjPzUX/JxLDzTX35Ll7xI+MmH22fCfzFwvLQ2fMnY6dORS/E/C7wfQoKTX/rdLqehGv2fYtI+cJKBeXpKSGEsB7UY3cNrTEPxBvlj8oPjhSnFeJQbmiSMBgceJB6n+A2+jJOvNhXn/Ydxd1jb2mSIi8+wLr8dkiG5U53JAE1Ta6a6T8mh3w+DA7GOWop2MljB/KnwIncAPmvb2ytLWA1VfvyYhQh5CoS7e0sbYH1hmJjypFYTdBM5D0rlbXZ+9bEi4mO3gNi4nKjUSsPMspZQGkNgEurS1y2rwSKzuY8PLEJ2KMbEtwAQeKdBhLbYgslqP7Q4jU1t87lke6ShB9oHQ4ikV+/wZhnTKecRYsrsJCFMyi/RedjStQD9LFn1BBFVc9FRKMorjU8TQ/voWQnnKd4G8xj40VixOcbRFM98Ypz2xljr0vMOWFtVvoVsVW0YLSBD+4Ydt4VnAlc9U0NAmz36EmQEJseSznNkOgbSOH6ogYx4tOgeqCbulrx5AndP3mq7mdWZBc1gIERS8Of9vN/4pVntrOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uAOhfnbzVNJQ1DyEBxlPoiM80/7WxkHOMPFTuX2/vmBd0+VwlBeHh3KtyiC+?=
 =?us-ascii?Q?7Fxru4YanLMAVeKrJnOTtDVqLi2DWRj2mX8x3btOz2iVVf12n37IoEAJ/BOR?=
 =?us-ascii?Q?bUkEvA9o44gLWdjK7pXvg33RH9QAZzAbhqCc00E0Am7KbyyL1X15STskSCK5?=
 =?us-ascii?Q?OjottT22vggJJhpJtqyzevHHXVoiiyW2vEgSxt3WUMjTIOo4tCqJMcIFNAjo?=
 =?us-ascii?Q?MpkRpqVkKOxFEghNT0+kA507C7mL1yxnI6wV9OcGy3JmLTjFVdTxtZ9rzjd0?=
 =?us-ascii?Q?84BIekZZfHEEZ9VRgHaiPmWILluV+xNNt+XdcTa06sQ4cz+ZXH0o1OafPv8l?=
 =?us-ascii?Q?JDClxQXYXmfVs8gmm1jbPCG2pq3qmbTqomCnDV474v6eKkDeYmHsG89AGS1S?=
 =?us-ascii?Q?kqrT8TivcC+rS4pMKUA7tBCcd6QV14ybYQsMa7YEm0t1Jxye97x7Sh6/HA54?=
 =?us-ascii?Q?BL1amwr5TiJAVOcaoS1jas+CaAGcmYMGqeHah07Cr8S81S4pAiC9uTY3RKVr?=
 =?us-ascii?Q?krZLp1YSpC2l+RmTMuWSV4S4P+Y4ySi1NtWI76LNnczENXVb0+rCIZBNiIUf?=
 =?us-ascii?Q?Pdb5tsbGj9BIn5zMvFh+8yvUoTRUdO0cNB5QKJoGqAM870c+P4aG4M+G/cVi?=
 =?us-ascii?Q?TYT1siPjLlGTF+w43A119jJsD+cggezzSjYA9I4NiwX7n8gPIcZQCEZ6gDW8?=
 =?us-ascii?Q?EMG9WBmblkdWXBE5Ed2i2Vy27IyezJklBezYjZdFNgrg01DoQlW6P3aaPXA6?=
 =?us-ascii?Q?vHgdlGILHACQi65AXByS5b6/O9GwyXmhrCOuaakZwp/35ceJ7JEoNorYEsOe?=
 =?us-ascii?Q?tODo68ShVEZKGmIfoieG9c4ybo+PAD2qPqTjJUcEpwLqOTFYxOzj/qRydb4i?=
 =?us-ascii?Q?64ZKzhdlH8cZXy5/nLc69i+K3TvytygXXKvvKHWOkd8uVYO9+dj/RE0zpsp+?=
 =?us-ascii?Q?ns+4N7cPIpENh6AeJqz5ReGwIb1uBNF1WqWhntGuMYAoqLWUcZaq1dB2fJyZ?=
 =?us-ascii?Q?89edsf66Gj6B3BjDFApXxvnJcHURhLTHHAWrHJT0LA7hCG506dwZ3/UObKXB?=
 =?us-ascii?Q?1i/kcjNRqilb4kt1NfJ9Vj0mUvv734xGWmQQXu8tOvemtkI37bnuvzLwM5Qg?=
 =?us-ascii?Q?YSrjbkjvY3JdZbHDDazrTIwWrPYXU/LawwWau+wmM27o+QNyp7rErurUeQ7C?=
 =?us-ascii?Q?TTWOKdf5ou+x4YEitGfwvQKgPXK/1sDeJDdJBEECPEowwEzV//3zHNSmS2/e?=
 =?us-ascii?Q?H2XnHYV2+Kd/bIbDMy638b1VSDIA4WwpqU4E3D2QTinWP3Vc5rkaJUUWhgJg?=
 =?us-ascii?Q?k1EPtbE3wqbXud/KpWOqb+6wmL1Mjj52YqfpH7gFdIrdNgh1PWQxjSgdyXc5?=
 =?us-ascii?Q?JHeIEBX1rvmgRNKz3k2ijQQd7ZrWFU8Tj3BbSCFh/AIHRR+AKc4ci29gGFZQ?=
 =?us-ascii?Q?mGcCs22lbOJi+9va1ClDsNtKlAB0dZnc31VqP1R4s/9BfbqTGlCcuf4SKRJn?=
 =?us-ascii?Q?MX+67Ku9SUsgHEU5IZClaU7PhhNf0LFCUHYUoOf78sUxDcgGaNmqXY1qzKac?=
 =?us-ascii?Q?sfSV15MjuzZBcPEpjnzX3f4H/vnu5OOMm8UXLpClYNjIZX0xIAlBfL1NvWzg?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: h8i8MYxGul3LkuacIFQ6wKxz51A82InErfXLlPJy36GSPsSNIlp40JP/vx/oyBuGEMElTHVm28oDlayZO5QLUDVkkBdo7tgapxp6ax6FgjqNOacoT5TKHP95CJXA9eu4Q8Gb6td2z1nLrXOz1DRYMRkgMdGQJ4Cujo+4KhLX5RThi1nF3xTTmMdGi+nbfuZUfr4xVWe1HiFb6svJLsLdscOGgXFuCfz9oBiAFEt1YtQCkwbKpc1olZyhgBWwM9meQWWKsCLfL+t1ydCwAfitQdmFYtnNfTFRsIPZF2SE2LkCoUHXtsNeRWS6TJq3qWZBWjDaHBFFIIZDsUrCArSintNAhU//43q3QYvM/tbJCc8qFGtzLyGOi/4kaZrMj9qG8XkJ5QBM/7JXhpGNWfijdLv+l8SD7pcjb/F7bksebMZrEaYhLXH5UNJPZ2n8vOqF3FKwdc2dnlLKHkLeA9eniPIe4BSBxKJW7eG7AjrkZiVybl91ak90FwiqwZNcWM4+L7K12YnDVpxxkTifv1vPJp1UqvU8RtCt5SD0+aIfboK55r+8cRvkFJBXwG0AHOPpel4B7B+IJClk6dQAh3e96ApAoJr9AfxBUDo/PrD34fCFr/fzFU720IwhVA6xPty9E1exn7cu85g9llBpt9EjK3/4ylgObe0QcdXSV/9mEg0G8s1dHoz3ZXLQkLTH0ci7uBkRZtMAZZ1rLzOg0yLlaeBKEOlrKn+0ILs0xKyZOkjSckJQDTAjU1T6QUvAWttMOMuc6H8UNdgLUnO0ZmZsmw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0824eed-06fc-4d4f-61ef-08dafdab8252
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:37:09.5580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4cBzEVSgpSDrob/d2WEoOGszAyNTD9wI2Tn16jJLoKSHsbLC5iAPELKilpw5dTRGQ5iAMMP/LJr/P8PxBpkpmLNs9SrSJsJKRYvVDFOHbcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240010
X-Proofpoint-GUID: AFVQ5y0g8GodgTX-oPsqUsoJ5wZT9kPA
X-Proofpoint-ORIG-GUID: AFVQ5y0g8GodgTX-oPsqUsoJ5wZT9kPA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Dave and I were discussing some recent test regressions as a result of
me turning on nrext64=1 on realtime filesystems, when we noticed that
the minimum log size of a 32M filesystem jumped from 954 blocks to 4287
blocks.

Digging through xfs_log_calc_max_attrsetm_res, Dave noticed that @size
contains the maximum estimated amount of space needed for a local format
xattr, in bytes, but we feed this quantity to XFS_NEXTENTADD_SPACE_RES,
which requires units of blocks.  This has resulted in an overestimation
of the minimum log size over the years.

We should nominally correct this, but there's a backwards compatibility
problem -- if we enable it now, the minimum log size will decrease.  If
a corrected mkfs formats a filesystem with this new smaller log size, a
user will encounter mount failures on an uncorrected kernel due to the
larger minimum log size computations there.

However, the large extent counters feature is still EXPERIMENTAL, so we
can gate the correction on that feature (or any features that get added
after that) being enabled.  Any filesystem with nrext64 or any of the
as-yet-undefined feature bits turned on will be rejected by old
uncorrected kernels, so this should be safe even in the upgrade case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 9975b93a7412..e5c606fb7a6a 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -16,6 +16,39 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trace.h"
 
+/*
+ * Decide if the filesystem has the parent pointer feature or any feature
+ * added after that.
+ */
+static inline bool
+xfs_has_parent_or_newer_feature(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_is_v5(&mp->m_sb))
+		return false;
+
+	if (xfs_sb_has_compat_feature(&mp->m_sb, ~0))
+		return true;
+
+	if (xfs_sb_has_ro_compat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_RO_COMPAT_FINOBT |
+				 XFS_SB_FEAT_RO_COMPAT_RMAPBT |
+				 XFS_SB_FEAT_RO_COMPAT_REFLINK |
+				 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)))
+		return true;
+
+	if (xfs_sb_has_incompat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_INCOMPAT_FTYPE |
+				 XFS_SB_FEAT_INCOMPAT_SPINODES |
+				 XFS_SB_FEAT_INCOMPAT_META_UUID |
+				 XFS_SB_FEAT_INCOMPAT_BIGTIME |
+				 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+				 XFS_SB_FEAT_INCOMPAT_NREXT64)))
+		return true;
+
+	return false;
+}
+
 /*
  * Calculate the maximum length in bytes that would be required for a local
  * attribute value as large attributes out of line are not logged.
@@ -31,6 +64,16 @@ xfs_log_calc_max_attrsetm_res(
 	       MAXNAMELEN - 1;
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	nblks += XFS_B_TO_FSB(mp, size);
+
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * corrects a unit conversion error in the xattr transaction
+	 * reservation code that resulted in oversized minimum log size
+	 * computations.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp))
+		size = XFS_B_TO_FSB(mp, size);
+
 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
 
 	return  M_RES(mp)->tr_attrsetm.tr_logres +
-- 
2.25.1

