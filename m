Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD85C001B0
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jul 2023 00:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjGRA6r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jul 2023 20:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjGRA6q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2023 20:58:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A193AA6
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 17:58:44 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HKOjhf007278
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=a7xEQzSMDG6tvA+XIiwQqjq0199r+J21f8NxY0PaYtg=;
 b=frMJoxanFRCAJyTrlcxnGAPQx9EkQLAI+Q2q3/8JnjMIaCEiOh9SSlfIzEk5E1gdDEMs
 /UvP3isd6Po4eE4hxIgesGROHB64y6kzzRZBwOiSkJXXUyJZg9oWYSBM91xBZpbCPup9
 92i7LACob3MV2qucPq0sHWe3Kr8YLBDZh9Hqhw9csbdCxRnUtLBVMlQTJ0w6Ec20CmgJ
 eNdJUEbSCzKD1MzxdYq2jRB6JBlaymjFPAVS41Qp1HF+kCPFYjoULla7fV+rVpUjE80Z
 Iq/5Bs4JSvdC877NxQcgEFMfXELFoxwRhjrMnG2I6tm56GEtjboYNA3/4+yXGjCA3yah nQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run89uyt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36I0bMTD007772
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw45kjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4jkY1HCeHhNCbnHtZQAvup/68vUHtTEvbbIm+4DKf5VbRG1iiF26U+IejpM29TAff3Cv2G86UU0vEwKDXG5e/9wHkyno+rr8CVW9Fbgu7hKyOUHUzm295LgRA/kg77lzEt6zaeaJ6I5KxxM007axw7cq9KahHsJp3WBonyeuGHdRAfWMvif3Qi1g0RZehYRS8wcsaNKi5IkIKsIoqaI6XNR17veT6/UzkRTK/vDgV4MIh8qv5sB+CAVkVfeY6T+E3Td/8IgGeS1AbVIRyFrJiNHfd3wWsi2ZFQg+5A1s7PmKXdj44IJIw3SOgSFRO2Y2WMQsAmbe7AMcSupjO8lsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7xEQzSMDG6tvA+XIiwQqjq0199r+J21f8NxY0PaYtg=;
 b=eCrGwv7LFPyABX4h76RG62D3qW+NpXxp00pUKW90eeS80aC7yev3veVlRMw6hBrV7VqeudLq9Fd2iz7MDvpVNm3p8/mKf5YTpoXqI8ikF5J4P9T13V6YgH7qLz3K01uCI+JaGdMehAbtKlEpzjSVfPDhO0yl6mTZawCHYb3hIq8nLoFbqyjcYKVjhdM1Ab8QamrYLvKxjNhb+uCAboKK7e9Mp8jbhYqXUKNoIIXtmc1nzTFwIB6Y9TVlc3IOCHviNIJaWK+Q9O/I5dztIBzptRgcrxkvqTexfadzRlKN+OblOGkPXYIk8+Ernf98kEExa3s5c+oVqJ49frb6gDHd5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7xEQzSMDG6tvA+XIiwQqjq0199r+J21f8NxY0PaYtg=;
 b=jDNslXynDc4hTx17bykTgK5We34+mDSMOvQ8zmgDfgnMdFDaIArceSP0Xux5OJ7C2ZUBhgBiKKMvgNTKVMoI3/CAfBPonvhOJTeskaWeNoDKvKjXkJUnZJQmdRXd5PnUCe5KUlpVFdLTQBOJsLmIevPw3UQGJDQwPSXKaqEyJe8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY5PR10MB6012.namprd10.prod.outlook.com (2603:10b6:930:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Tue, 18 Jul
 2023 00:58:40 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::c1df:c537:ecc:4a6b]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::c1df:c537:ecc:4a6b%4]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 00:58:40 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 2/2] xfs_db: add a directory copy command
Date:   Mon, 17 Jul 2023 17:58:33 -0700
Message-Id: <20230718005833.97091-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230718005833.97091-1-catherine.hoang@oracle.com>
References: <20230718005833.97091-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0154.namprd03.prod.outlook.com
 (2603:10b6:a03:338::9) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CY5PR10MB6012:EE_
X-MS-Office365-Filtering-Correlation-Id: c2c1220b-21a6-4dcf-ad23-08db872a204f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0DMYKZM0V/zwxMN4VRfMbRNJ+uwlX/dMKfJrHLcTkOcru2/3t88QW0/RxZM/SRwuDsllaGoYaim3dDE7COtczbfd/CLXAB9iaPL/aj8n0YLO55IJiR/QQDuTv/f2s101kwXe3p/5Qixqn8yg42nD9fMY/hL40DQhvH8Z/xTF5q1DnD0KH+X1rQFUE8pKQx82xEHQQ+jnalmrxliCyIAbJC+amog+kkr3JX5gZ0ydLyo3Zob8QxLYSuMbJPD/eeODKB6MwRWobd9gDYrYpOE3xQzokFhrdiziIbVcRFQHSlM4V10uqo3O5AJkvbnfmgYljcCaH5yGFSLtdZYy+KkJb1eO6unK1SKI+g9BujxY4yaYDLw359yGIXLcCl0XZPUoXVmWGT53oC5SNWlwihlHrQDboZhgeqLZBUsCluvZCREF9j1BG7Wh1w2GTnzo4X0ZDRYvTWxWYX7j34Zi8sq7IxIoVhA5WxDF2PBOivaBaSa/ucbnWtHkhlI1G/uPkUZGlnQN6qPiz4ilEhY4DuXIqmABsdqlVrdm/qdmXAKUC6usQu8MAkY49ydBZ6+EqtId
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199021)(2616005)(316002)(6506007)(1076003)(6512007)(83380400001)(186003)(41300700001)(6486002)(478600001)(6666004)(6916009)(44832011)(66946007)(66476007)(66556008)(38100700002)(5660300002)(8936002)(86362001)(8676002)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9RiR9yXU4t9TYK+76hvnGtz8khGInk05Gfv6NWZHkdvEQ9Ambgq+kRPMEn7R?=
 =?us-ascii?Q?OVJcsG9m2KT9vXokgAtvo+3Cs2D5nk5BrJoWZeDQxiLLu2sWQwkxOLDmTXOM?=
 =?us-ascii?Q?RMnpXH1ACeTajOTdk499ic3SFnOnCr+4HAZnxT4eUsXIvqZWw8z8n/H8MCAL?=
 =?us-ascii?Q?Owoig7EuyrtNk0VaFgcm+1ilXOU7yGz5TPlblXNYPg7btntMTJn9rcZK27c5?=
 =?us-ascii?Q?9FxQG6amy1eI/0c/iuUPg/uc2memtVSCUWo7p46J6jkYX+IGP/kUyLyi8uEJ?=
 =?us-ascii?Q?jUdL5pXSgZHgp130riKySVMjYONoUaCcPBHicxpAP2NuTv5LEfZGbBbF5bP7?=
 =?us-ascii?Q?RlxTLr8iCrTgA8/9TnDvENAXV3Y6Lu9pFLC5gVpCe/vL2SNSSu5sDFLBLjWJ?=
 =?us-ascii?Q?lUtivo8NujwNUdLDc6JMGbGjCzUElsoEzx/ga3aQo6YZUqklcMa+LZg9As04?=
 =?us-ascii?Q?eUc7NpClGSOyEZkGzywVOctAfVSDHBjmW7VJvhUzXyjUVw9facx9Dn2tD98g?=
 =?us-ascii?Q?wdx2HbMGMH+4RRGI2RSBczVAyNTEi7WzN+oey8YACL3W0McL43/MoWJtwp4U?=
 =?us-ascii?Q?SK9hn8pivq6u5tSi32c9cCEAj05RBDpH3ZzgHGElSODpHpV9j6HhJ5Zy8nrC?=
 =?us-ascii?Q?RF7csXDU6zGTB25Ij5n+KRpN2I2JFfNEYlyw7Zl99dUMZs44ZeE0u9C4BzaH?=
 =?us-ascii?Q?UkSf3WrXce7OvtYTqnVE6pbLtuMYXbC8viFEUr9bxDCSBwoxjN517tUYqRES?=
 =?us-ascii?Q?AZNvg+MmyTDb2teS/SLJVxQ/ylEpr2oqYh38GATgqV8oKwPHczWI5p4yVwRD?=
 =?us-ascii?Q?ZbRV++VrqImOx/OIcAOYTIOgzWsuTx8Gti3H6mITsquENfjU/NypvBAPAx8F?=
 =?us-ascii?Q?kR39OqeHrDuaMQ1dbYtn9KdmcglNbM1egxFY3mkIIk1NoLcIdPscmQGZ8PkR?=
 =?us-ascii?Q?kF2JmmdhFTFoPRtJ35ZsZF2L6h0p6DZAihJ1gIPDvyGx8T3uQEkp1aBEKnFG?=
 =?us-ascii?Q?pFLtw1fiJPihzWhAdx5XhdVNPrC/lEqZsHsSzoYB9X6B0LB5eGHHEMg4mENq?=
 =?us-ascii?Q?JJUV/6tQ7L8H6bw1ULNjxPB1MtINKSqGGA9w2YxxyzZsBEDoyg44D5qzdD+Y?=
 =?us-ascii?Q?QPb16p9eS7tQdWOis1onzBsQdPRwxcoIqEUKRUfGAJAqT/DNWclf/nTng/6P?=
 =?us-ascii?Q?GYgo1BMtHfbk7n2aKqQOar7Gl9jlA6dPVOhfG/eGpo64R/wRKz6XbYY417eQ?=
 =?us-ascii?Q?yNuawvRm5UxoRAbfQL/WTMwcKDEX17nrHKmm8fKdvsdg0xElasgS1pZr/XC7?=
 =?us-ascii?Q?xFkZ1WEQC9qrsnmShcUc81FtVP6htZvMSKdpqTFXLjKJxFPQgMRcu4t4AYWj?=
 =?us-ascii?Q?GlTT3RVURyY3fvmnWFesMVfZ1H4y/ZKFEAa27wWc50vMmgjkzh1EsT6CBrLg?=
 =?us-ascii?Q?jOo+Gf52lp1fA914mIRqA5ZZHIvXjux1dg1DPVYTOhqe/vO/8Q5C4W2JBfri?=
 =?us-ascii?Q?mWq5MBYO9iQrwsRlZTraAjCkeJ5pNN1qo3DodCbYvHryBSqoWksGJVUjr4Rj?=
 =?us-ascii?Q?owBCHxND2ba/eEJF0o3HrXxdmRj1G5DumByzcN4cfxhjeB0v073DAn0tcN7s?=
 =?us-ascii?Q?8xhn0Bnn1Ezvr1YHMT1eJ7eEhDjdRxdRgNLtrHHlyejDVqNnX7oRiXB66uiL?=
 =?us-ascii?Q?+swZhA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: sEsvf+hLGtYmqaB/gfdp3ZOEvUJ54m4tLTYPg5A8vKMTSLbu2D0r1RfTo5xA3HbAlrv0TOw2aA5QbWZ5GyIfNcI7phYuSGzEMdS3y5+KxrlCwAg8f0UEwXO+P3BVNAB/ElgjeNpYhn6ZhTbU1i0fFzp/p/ZTZnqiNjSB773AQ168MQkb93md+mdqmr+QUzdz5++WOyvdNV+oM9gjSH8ijA/tIHbdP7CigVPNN1yC14sHvQVz7WNejEqOT0v8skTft4KDDnXiClqpuiZU1VKFoCApJScS0cNWwoAJd4xB+1Z3o4omnDXpPLEhFwOdUJ2kFjzapGKO9vslGHaiWNhCO9ZfljIpZaRHbYuPjKfnWz2vLncC6EAlP5JyZtAHJ1W10+fU1ZPZzU6tnahvcq3jKPyzngHtHiyIO/fKT1oKVOxRM+FJeeYNBRT1ayTS11/22dI5KIWyU2sJ1sTL7CjPVCLzYVGTI+t8Ggffm6aFiuZx3Etu+fRiMT2XmlK4ZC2XLVrZTIHEMFalB0NAaJtdz5aUtEvNoDpYTi7j6ylooUtFomIBlPxCp1C2oarMyRnFgHKy7EXMoVqG28+ZIhRli+478/4HFUu1BOKv+wDvPNVCuScQfd6l8AXB34LGfa+VyfCxd4+DLfDmC/rvvsYiTnHW+rQRVGJk4oN+kI7Rzlmo017kcwkhlYOwkRznbEvHeO9kpLSiLW/JgHVjiWlmg1veK9lB8Lh6JxtZ3O6NRWb6zptlvZtUkaRtEi79yNSVLfv/MAohTmjWI3O0n81RTw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c1220b-21a6-4dcf-ad23-08db872a204f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 00:58:40.5007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SsZZ9ax9ODJZbAdIojWkvzb0e1hBNHIVLHR4VrZL/Qjuy+9dIyfE5+0BnXv2TQKy8WOzLbk7vZ7zgNlqdcjx9TTGuwUFh6QH+drLFBXVLjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_15,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307180007
X-Proofpoint-ORIG-GUID: TtesnB1pT4EiLchK6mRTQYOKGBVI-4qT
X-Proofpoint-GUID: TtesnB1pT4EiLchK6mRTQYOKGBVI-4qT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add support for a command to recursively copy files from a block device to
the native filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 db/Makefile       |   2 +-
 db/command.c      |   1 +
 db/command.h      |   1 +
 db/copyout.c      | 320 ++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   7 +
 5 files changed, 330 insertions(+), 1 deletion(-)
 create mode 100644 db/copyout.c

diff --git a/db/Makefile b/db/Makefile
index 07f0b41f..0009bedc 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -14,7 +14,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	io.h logformat.h malloc.h metadump.h namei.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h
-CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c \
+CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c copyout.c info.c \
 	timelimit.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
diff --git a/db/command.c b/db/command.c
index 02f778b9..abe4db3f 100644
--- a/db/command.c
+++ b/db/command.c
@@ -116,6 +116,7 @@ init_commands(void)
 	btheight_init();
 	check_init();
 	convert_init();
+	copyout_init();
 	crc_init();
 	debug_init();
 	echo_init();
diff --git a/db/command.h b/db/command.h
index 498983ff..206f72ff 100644
--- a/db/command.h
+++ b/db/command.h
@@ -34,3 +34,4 @@ extern void		info_init(void);
 extern void		btheight_init(void);
 extern void		timelimit_init(void);
 extern void		namei_init(void);
+extern void		copyout_init(void);
diff --git a/db/copyout.c b/db/copyout.c
new file mode 100644
index 00000000..288e40d5
--- /dev/null
+++ b/db/copyout.c
@@ -0,0 +1,320 @@
+#include "libxfs.h"
+#include "command.h"
+#include "output.h"
+#include "init.h"
+#include "io.h"
+#include "type.h"
+#include "faddr.h"
+#include "fprint.h"
+#include "field.h"
+#include "inode.h"
+#include "namei.h"
+
+static int do_copyout(char *name, char *fullpath);
+
+static void process_dirent(
+	struct xfs_mount	*mp,
+	xfs_dir2_dataptr_t	off,
+	char			*name,
+	ssize_t			namelen,
+	xfs_ino_t		ino,
+	uint8_t			dtype,
+	void			*priv)
+{
+	char			buf[namelen+1];
+
+	/* Ignore . and .. entries */
+	if (!strncmp(name, ".", 1) || !strncmp(name, "..", 2))
+		return;
+
+	/* Make sure name is null terminated */
+	strncpy(buf, name, namelen);
+	buf[namelen] = '\0';
+
+	set_cur_inode(ino);
+	do_copyout(buf, priv);
+}
+
+static int
+copyout_file(
+	struct xfs_inode	*ip,
+	char			*fullpath)
+{
+	int			error;
+	xfs_fileoff_t		off = 0;
+	struct xfs_bmbt_irec	map;
+	struct xfs_buf		*bp = NULL;
+	xfs_fileoff_t		filelen = XFS_B_TO_FSB(mp, ip->i_disk_size);
+	int			fd;
+	xfs_fsize_t		readct;
+	ssize_t			writect;
+	xfs_filblks_t		maplen;
+	int			nmap = 1;
+	xfs_fileoff_t		writeoff = 0;
+
+	fd = open(fullpath, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, S_IRWXU);
+	if (fd == -1) {
+		dbprintf("can't open '%s': %s\n", fullpath, strerror(errno));
+		return 0;
+	}
+
+	while (off < filelen)
+	{
+		/* Read up to 1MB at a time. */
+		maplen = min(filelen - off, XFS_B_TO_FSBT(mp, 1048576));
+		error = -libxfs_bmapi_read(ip, off, maplen, &map, &nmap, 0);
+		if (error) {
+			dbprintf("unable to read %s mapping at file block 0x%llx: %s\n",
+					fullpath, off, strerror(error));
+			break;
+		}
+
+		if (map.br_startblock == HOLESTARTBLOCK) {
+			off += map.br_blockcount;
+			continue;
+		}
+
+		error = -libxfs_buf_read_uncached(mp->m_dev,
+				XFS_FSB_TO_DADDR(mp, map.br_startblock),
+				XFS_FSB_TO_BB(mp, map.br_blockcount),
+				0, &bp, NULL);
+		if (error) {
+			dbprintf("unable to read %s at dblock 0x%llx: %s\n",
+					fullpath, (unsigned long long)off, strerror(error));
+			break;
+		}
+
+		readct = min(XFS_FSB_TO_B(mp, map.br_blockcount),
+				ip->i_disk_size-XFS_FSB_TO_B(mp, off));
+		for (writeoff = 0; writeoff < readct; writeoff += writect) {
+			writect = pwrite(fd, bp->b_addr + writeoff, readct - writeoff,
+					XFS_FSB_TO_B(mp, map.br_startoff) + writeoff);
+			if (writect <= 0) {
+				dbprintf("pwrite to %s failed: %s", fullpath, strerror(error));
+				break;
+			}
+		}
+
+		off += map.br_blockcount;
+		libxfs_buf_relse(bp);
+		bp = NULL;
+	}
+
+	if (bp)
+		libxfs_buf_relse(bp);
+
+	fsync(fd);
+	error = close(fd);
+	if (error)
+		dbprintf("can't close '%s': %s", fullpath, strerror(error));
+
+	return 0;
+}
+
+static int
+copyout_link(
+	struct xfs_inode	*ip,
+	char			*fullpath)
+{
+	int			error;
+	xfs_fileoff_t		off = 0;
+	struct xfs_buf		*bp = NULL;
+	char			*target;
+	char			*ptr;
+	xfs_fsize_t		bytes = ip->i_disk_size;
+	xfs_bmbt_irec_t		mval[XFS_SYMLINK_MAPS];
+	int			nmap = XFS_SYMLINK_MAPS;
+	int			fs_blocks;
+	int			n;
+	int			writect;
+
+	target = malloc(bytes + 1);
+	target[bytes] = 0;
+	ptr = target;
+
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		strcpy(target, ip->i_df.if_u1.if_data);
+	} else {
+		fs_blocks = libxfs_symlink_blocks(mp, XFS_SYMLINK_MAXLEN);
+		error = -libxfs_bmapi_read(ip, 0, fs_blocks, mval, &nmap, 0);
+		if (error) {
+			dbprintf("unable to read %s mapping at file block 0x%llx: %s\n",
+					fullpath, 0, strerror(error));
+			goto rele;
+		}
+
+		for (n = 0; n < nmap; n++) {
+			if (mval[n].br_startblock == HOLESTARTBLOCK)
+				continue;
+
+			error = -libxfs_buf_read_uncached(mp->m_dev,
+				XFS_FSB_TO_DADDR(mp, mval[n].br_startblock),
+				XFS_FSB_TO_BB(mp, mval[n].br_blockcount),
+				0, &bp, NULL);
+			if (error) {
+				dbprintf("unable to read %s at dblock 0x%llx: %s\n",
+						fullpath, (unsigned long long)off, strerror(error));
+				goto rele;
+			}
+
+			writect = min(bytes, XFS_SYMLINK_BUF_SPACE(mp,
+					 XFS_FSB_TO_B(mp, mval[n].br_blockcount)));
+
+			memcpy(ptr, bp->b_addr + sizeof(struct xfs_dsymlink_hdr), writect);
+			ptr += writect;
+
+			libxfs_buf_relse(bp);
+			bp = NULL;
+		}
+	}
+
+	if (symlink(target, fullpath) == -1) {
+		dbprintf("failed to create symlink %s -> %s: %s", target,
+				fullpath, strerror(errno));
+		goto rele;
+	}
+
+rele:
+	free(target);
+	if (bp)
+		libxfs_buf_relse(bp);
+
+	return 0;
+}
+
+static int
+do_copyout(
+	char			*name,
+	char			*destdir)
+{
+	struct xfs_inode	*ip;
+	int			error = 0;
+	char			*fullpath;
+	int			pathlen;
+
+	if (iocur_top->typ != &typtab[TYP_INODE])
+		return ENOENT;
+
+	error = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip);
+	if (error)
+		return error;
+
+	pathlen = strlen(destdir) + strlen(name) + 2;
+	fullpath = malloc(pathlen);
+	if (snprintf(fullpath, pathlen, "%s/%s", destdir, name) != pathlen - 1) {
+		dbprintf("snprintf failed %s/%s", destdir, name);
+		goto rele;
+	}
+
+	switch (VFS_I(ip)->i_mode & S_IFMT) {
+		case S_IFDIR:
+			if (strcmp(name, "/") && mkdir(fullpath, S_IRWXU) == -1) {
+				dbprintf("failed to create dir %s: %s\n", fullpath, strerror(error));
+				goto rele;
+			}
+			error = listdir(ip, process_dirent, fullpath);
+			if (error)
+				goto rele;
+			break;
+		case S_IFLNK:
+			error = copyout_link(ip, fullpath);
+			if (error)
+				goto rele;
+			break;
+		case S_IFREG:
+			error = copyout_file(ip, fullpath);
+			if (error)
+				goto rele;
+			break;
+		case S_IFIFO:
+		case S_IFCHR:
+		case S_IFBLK:
+		case S_IFSOCK:
+			error = mknod(fullpath, VFS_I(ip)->i_mode,
+					IRIX_DEV_TO_KDEVT(VFS_I(ip)->i_rdev));
+			if (error)
+				goto rele;
+			break;
+		default:
+			break;
+	}
+
+rele:
+	free(fullpath);
+	libxfs_irele(ip);
+	return error;
+}
+
+static void
+copyout_help(void)
+{
+	dbprintf(_(
+"\n"
+" Copy files from the given directory paths to a specified location\n"
+" on the native filesystem.\n"
+	));
+}
+
+static int
+copyout_f(
+	int		argc,
+	char		**argv)
+{
+	int		c;
+	int		error = 0;
+	char		*destdir;
+	struct stat	st;
+
+	while ((c = getopt(argc, argv, "")) != -1) {
+		switch (c) {
+		default:
+			copyout_help();
+			return 0;
+		}
+	}
+
+	destdir = argv[argc-1];
+
+	if (stat(destdir, &st) == -1) {
+		dbprintf("can't stat %s: %s\n", destdir, strerror(error));
+		return 0;
+	}
+
+	if (!S_ISDIR(st.st_mode)) {
+		dbprintf("%s is not a directory\n", destdir);
+		return 0;
+	}
+
+	for (c = optind; c < argc - 1; c++) {
+		error = path_walk(argv[c]);
+		if (error)
+			goto err;
+
+		error = do_copyout(argv[c], destdir);
+		if (error)
+			goto err;
+	}
+
+err:
+	if (error)
+		exitcode = 1;
+
+	return 0;
+}
+
+static struct cmdinfo copyout_cmd = {
+	.name		= "copyout",
+	.cfunc		= copyout_f,
+	.argmin		= 2,
+	.argmax		= -1,
+	.canpush	= 0,
+	.args		= "[sources...] dest",
+	.help		= copyout_help,
+};
+
+void
+copyout_init(void)
+{
+	copyout_cmd.oneline = _("copy out files to the native file system");
+	add_command(&copyout_cmd);
+}
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 1a2bb7e9..bca2b0bc 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -579,6 +579,13 @@ print the current debug option bits. These are for the use of the implementor.
 .BI "dquot [" \-g | \-p | \-u ] " id"
 Set current address to a group, project or user quota block for the given ID. Defaults to user quota.
 .TP
+.BI "copyout [" directories ] " destination"
+Recursively copy one or more
+.IR directories
+from an XFS filesystem to the named
+.IR destination ,
+which should be an existing directory on the native file system.
+.TP
 .BI "echo [" arg "] ..."
 Echo the arguments to the output.
 .TP
-- 
2.34.1

