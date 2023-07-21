Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790B5C001DE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjGUJrW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbjGUJrM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:47:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7628F2D4A
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:47:11 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMVl8004926;
        Fri, 21 Jul 2023 09:47:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=By86vlQ/X4kg1XvfAL8vVwvDmHQQ5vV/ZDYs0A1YsnE=;
 b=S72EBufJzujJiZE5i4buHFCwT+Z4XU+da5xp5RmlrsDLkc7D/Np9FnUtsWdM8dLrOn1S
 h2Pyi2v0OzCrx0ZZX+vPqZpFHIEhFAXREt1NQdPfZkpK7rleK9o9Vllo6XGb/SalVp1G
 AWtDd1sRg8Nlad6+Ct1chbJdsX/K5KWvyUyYKtBYwAgVBkPs3d83Ni9DwORE1qu5jhlq
 HYfY4UwrM5hhzvhxRsG0xKCek6vDWW2IJVTl1aRdRmtpp63hh9M0miOwUBfSJh26LtPr
 H9IvdwwV4gmAwM6reJ0a/LTolNXX292iB0C2lzEryfl2Qteo9IJBmbp99HVqtY2aqFbA IA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8abn13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:47:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L9fVQB038185;
        Fri, 21 Jul 2023 09:47:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw9sr0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:47:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyXp1dlJWw06BjYEywWamvaqmfbxvsvb2G64XtkalFm2a/n+sQM/8fH/E6KRG1hPJjK+2+PqxyvNpwrny0YaadXKWoNvmxviudZ89aepchFBcMIdhHZW4rASPlhW9bnAKyZs0G2nYS1XmrWaNhiiXqoPIRraBFPiI9lqprL9HMX/ERqWsM/cqc50U1KuF8YUntcmBB7sTXX+KeEy9Qsy6O7NVdR65FDPzBc00C7M3HTsnEnrfbYlelNTctam+F4V2WW8JwItiwzD56XNS9jFs5eMEukJavxAA/dIQsa3RPKyIXgRq7Uk5x3ilp7gnicy8BWsVKn+ym7mvsU8kOSoeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=By86vlQ/X4kg1XvfAL8vVwvDmHQQ5vV/ZDYs0A1YsnE=;
 b=mNLmYMC7DWzeya70qlcsx1rM9ccrxYcEWt2DHRGdbztSIY6xm2f7W/972Rqhny9H9uKBvPdHDQoW57Tgp+qgRM8UGeiHWpEWD8yveCu/PIlnVoVs8W4mBSZgNIPRpaTnf6Mfid0Oua6X6kocOt88sNjWiIcVKaUPLvwN2MOTvPRN7lfCGcqvtFaFhetRBmzgNupNPFdMoPafxENaDT74pCiygurqIMepFbAtlu9gjjFsqNjHkipSCUCV44EsDlEoIQM81i2Fwi/GDUb2PyFpD1WWq0E8N84i8X4yXblTpM/mfvk8XnNYnz27TcktvyIaZCYc6/gedwYNdo+H5Ad37g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=By86vlQ/X4kg1XvfAL8vVwvDmHQQ5vV/ZDYs0A1YsnE=;
 b=DcZDuvxO0MVPjFBFM3OUa4XRs6imA/CtOE19+SuMYsxdz8y6PEpTxh7AHkV4CaQcwUgadDYDreo8+qH9FmXMWUS9pGM1G7cWQ8ti34arQOYU8+MyBfbpvXH5/mLFASiyPA65gb1hn7JQ/a6recj+QmHJZ6uYBDrGLMgRCINAcUQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH7PR10MB6602.namprd10.prod.outlook.com (2603:10b6:510:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Fri, 21 Jul
 2023 09:47:06 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:47:06 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 11/23] metadump: Define metadump ops for v2 format
Date:   Fri, 21 Jul 2023 15:15:21 +0530
Message-Id: <20230721094533.1351868-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0178.apcprd04.prod.outlook.com
 (2603:1096:4:14::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f7be2da-9806-49e3-75d7-08db89cf71bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Hzvt7Wod6SzV5KbiY29DnfvHQdWhbL9RTWiI3JkzRAj35Yki+IX4oVVQV4s0GgVhUlpFNEsNn4fPnOitSpEZ3aFz8jptWGzLl6cVPBcU6uH1qAvMSoqFw54ryk0tutcCKVu7glZd7s4cGWZqPIzmc6h5BhyCzjPirvRxnHhaIZPYa9Nt27Jc8r5p/uyzDL3C5Fri3ilQyRbU/M5kVVu3qe3MUOzdIF7OdF4zBX00TbyEn4k7Yv5agVATDDjI5Mak0BfbSul8rTdhWSR/YS/cM05X91kcZZ+Qu4teut5yUvsdsToJVs338jN7/hCBGPh92rWqjK8Lvl0DOLeYEY9BudVb26YA0e8KjNBCaubYLrSvpHSdNs7UvZKDdPpBTDefcCrrC6yRJTCYNSRPKFvRUzcuueDCw9keGf+pK7Z0YpEF1f1qLx4+3SUgv9kXjsLwPMWZ7C7BvvPpj6JLXwaiMxd3PFwUtTmFe61+3RTpDuEBx41XuHuYJHZ9hbTfhqFiQxN4q3Tg85HgvVkSNGRZ9D9T7sguksZUNGRb+OhXeUPbKR/lGNIrkgwXhETfPob
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199021)(2906002)(83380400001)(2616005)(36756003)(86362001)(38100700002)(1076003)(4326008)(6916009)(316002)(66946007)(66476007)(66556008)(26005)(186003)(41300700001)(6506007)(478600001)(6666004)(6486002)(6512007)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bT8QcudpK6+UukuDK+K5/G7hReYKTL4VRbjwfFTvsD80Ld88ZULsOKkXslX8?=
 =?us-ascii?Q?1DndpFUBvtkETxWWlgXa0La2aWOzOGl+TUnreUi7/018PfioUlSB/g2rZ4tb?=
 =?us-ascii?Q?oQDcVo9w3FUFd6ZA4yNUxjUBHeK18OKHMa2XwXHcWeU/7Ctvl9IKADrtyduh?=
 =?us-ascii?Q?P/pKub0HuYvYSUKqVA1pEFy3A6EtYkLK0+PHMQCi3d62Co9fVBX+DIW8ZsTP?=
 =?us-ascii?Q?AuWQnUrf/zqgcq/w3BwhJ+IkmAU1jU1+Lv5LyNIuLchmz6x7ZJBPwDuxauj2?=
 =?us-ascii?Q?GcL0XiZIFV2blD0RoVsWzBXMoym9MYkFEr9PklNTA5JpSgVuRBzaDHfXyc0H?=
 =?us-ascii?Q?RHVYIiahjiY6pxriVFvDLsJ01I59jtV3xF4biGmMco3AYonGcHoI+RZO8+6l?=
 =?us-ascii?Q?b+gvSf8INtLLOuF5qHHvekscwU8Gzi1JSbxpw17vll7r8O5zitjXARwm0TLY?=
 =?us-ascii?Q?Q3Ma28DCPoVGr9juey0LsaAU2LsKymas+UKcZwGcZ33ZgTYlQZRWn1bjx+K2?=
 =?us-ascii?Q?nEHXp5rJJXCkxO2v5217nI2W/fqm4NlW3+BX/lhf0SC9zCK/mj4abF3LgVGp?=
 =?us-ascii?Q?pyAIwMT5GseOwG/+RJ7BFpe2CkfnqC9F3NwSYAd7XGXsiVvSuBuLTTHZ2eTi?=
 =?us-ascii?Q?W1p3mmztR/I6XOj3AKIy9ZS7CvbLQCD1p47h86h7vLiUscVaZ5ftIaw+ItIG?=
 =?us-ascii?Q?NXloJg4X45MfHj1f55chuZhcfAwFhPJv7EpDBgPUlOVKWpaYiPAyNoYzf9bL?=
 =?us-ascii?Q?PRjcMnPD8y1e3bzRb05m7QSFKDdTBdOyRnd5MDD1rIafTqT/UqU62NkN74s7?=
 =?us-ascii?Q?KCVBYKgMpeqpE0SCXNXmT1+2vFVo18tJWr4eOEdLx/8fOBk8j4VP3F492H4T?=
 =?us-ascii?Q?01tEd9RmMScFt3a3/ClkX+RvC3cuWEwr1Z323+JDHo3TQKfIf3JgjdUq7iQL?=
 =?us-ascii?Q?DiJHFmGjbI7IPrzwuz+hGcUoqsW8trM9AmE+FEm3+h7c6LuVSRUy5jtwaEGw?=
 =?us-ascii?Q?UQcaLW7BFOHRi//nF5PkeaFbPjwz75sU/+Yoht7g0kyH+eeJFsdQVKUNPFZd?=
 =?us-ascii?Q?s+3U9KXbvnsIEdxIDhsoav4S5WYfiVDN9C9su9BOrw0rp+32NpOHreg6q0Kf?=
 =?us-ascii?Q?Zy7y7JZ74WsfgZHwzNGJ5G1WL8pqqUzFFBrd+9LdXlkPu1lPntuAntjSawxq?=
 =?us-ascii?Q?nttzZZYBQStXosC33qCQK/s/MZogawluwgXEgAqhyUaMTznNpdWKPypgKh9T?=
 =?us-ascii?Q?NIfwoajMNAp72RBykJb3DaL8BcQkJe2ZBCVh2E2/jiq7HxCCVEuEAoWxCojI?=
 =?us-ascii?Q?+gIj8w1KbClgJVJqqc+z3DdpE82zRfwkjEV+wWz0jkY696isvYTJAp/AK6HX?=
 =?us-ascii?Q?qqXTgVqcVOirCho06wqWaW6uaA/mBVCfvH+1ekVWtG2P6JqgzIVoJCN5bqVJ?=
 =?us-ascii?Q?P1F5mjpAFHUTUSvB2u5MYRWGjyLzBPvd1PkJTbiSVaLL0JGraHXjuhod3yU4?=
 =?us-ascii?Q?MlLnyzVc5ldEmilnW7nCux/p6LI84SHQ2GxjZ7eOCnkuaploA+ZyvjZWixqK?=
 =?us-ascii?Q?mD5RhKymXA2dQfJQQknLmHmRGsGLv/W1YoZ1L+xw8l+ZPhhTie2i4fnlerwB?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 90xLnCqP5/kr4DBtiZ5uW6cZmFLKNo80aWV0EGeoIlIydPp6GWq8VVeRBH9pHWWORGvEpuLsUJHhWI2M2S4BnIuyYvytRRGuDx9LvYfboLwRUo5IPDsYx07zlPd8Gwqa538CfHLH8zQ8JC1T3KsYgBiWcZ94Aod46uyYgrUUVCJTREWzwaS0HOZPOEz5zTVcXeWqgnMEuh3dHWDHLjXjh1rSirsulZNlGczNEF/UHnLVDz260Sj/jI/PksQ5AcuN4FfNbmhfzPI6s609jQUgN87l0U2X1K6b6L9tjEkrbHcNQ/2V4GBiqsOs7Lj6w89w1GR/0rwHzKTQt6baU4XCZ2lG/vu4B8FemAGSc0WJj1CzixBgW0a3tGG2TSqGbptq2huK8i9w+hjYzJKYzb2k3wYgBsiZSpVEYKgEAVhPSip3xbllRkPt4YP6U29OHW5omPRM/8IAZlXBLVYMUIFEhLSVC21lqWlglLDbDPdvAvyj7aC+eRpJWFKJlA7VNK384sNMSdQUoMS5dGYcqZjS/z0o3hAiXMkKPCekSRGPr5EhUQH1UVEBq87MkobZHNuja0oBnDcdbwZyezJC0gUDeNRJnKCi9xt3vK4xaS1t8LKZUw1t2HIT2W3nhod9OVukWQgPI03CrZLUB6X9Pvbnnbfk/GEltJawgd0e8R4p5YdGIbEOmwa32A9BzT3TggwD93SKXGb8o2Dh4/1XYzNZhtmycjNkSSMcu3TeabmcigxIQvym4o2Li6Yx/NwLDv9ON/dtxiFMoGnUmvidQJqz3tbFfIJz/gR6CgorblxsGI0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7be2da-9806-49e3-75d7-08db89cf71bd
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:47:06.3291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrJZihxc4CiwxG/yvujmguT8H5kFD33ECSkQQor1peSmON8nDp3c6pgiF93X9oVK5CRiVvof3euIwbKEvDMS3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307210087
X-Proofpoint-GUID: F-acLtlBqaDv8nDRw2EovlvxP2eVbWdi
X-Proofpoint-ORIG-GUID: F-acLtlBqaDv8nDRw2EovlvxP2eVbWdi
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds functionality to dump metadata from an XFS filesystem in
newly introduced v2 format.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 3 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 7f4f0f07..9b4ed70d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3056,6 +3056,70 @@ static struct metadump_ops metadump1_ops = {
 	.release	= release_metadump_v1,
 };
 
+static int
+init_metadump_v2(void)
+{
+	struct xfs_metadump_header xmh = {0};
+	uint32_t compat_flags = 0;
+
+	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
+	xmh.xmh_version = cpu_to_be32(2);
+
+	if (metadump.obfuscate)
+		compat_flags |= XFS_MD2_INCOMPAT_OBFUSCATED;
+	if (!metadump.zero_stale_data)
+		compat_flags |= XFS_MD2_INCOMPAT_FULLBLOCKS;
+	if (metadump.dirty_log)
+		compat_flags |= XFS_MD2_INCOMPAT_DIRTYLOG;
+
+	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
+
+	if (fwrite(&xmh, sizeof(xmh), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int
+write_metadump_v2(
+	enum typnm	type,
+	const char	*data,
+	xfs_daddr_t	off,
+	int		len)
+{
+	struct xfs_meta_extent	xme;
+	uint64_t		addr;
+
+	addr = off;
+	if (type == TYP_LOG &&
+	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+		addr |= XME_ADDR_LOG_DEVICE;
+	else
+		addr |= XME_ADDR_DATA_DEVICE;
+
+	xme.xme_addr = cpu_to_be64(addr);
+	xme.xme_len = cpu_to_be32(len);
+
+	if (fwrite(&xme, sizeof(xme), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	if (fwrite(data, len << BBSHIFT, 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static struct metadump_ops metadump2_ops = {
+	.init	= init_metadump_v2,
+	.write	= write_metadump_v2,
+};
+
 static int
 metadump_f(
 	int 		argc,
@@ -3192,7 +3256,10 @@ metadump_f(
 		}
 	}
 
-	metadump.mdops = &metadump1_ops;
+	if (metadump.version == 1)
+		metadump.mdops = &metadump1_ops;
+	else
+		metadump.mdops = &metadump2_ops;
 
 	ret = metadump.mdops->init();
 	if (ret)
@@ -3216,7 +3283,7 @@ metadump_f(
 		exitcode = !copy_log();
 
 	/* write the remaining index */
-	if (!exitcode)
+	if (!exitcode && metadump.mdops->finish_dump)
 		exitcode = metadump.mdops->finish_dump() < 0;
 
 	if (metadump.progress_since_warning)
@@ -3236,7 +3303,8 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	metadump.mdops->release();
+	if (metadump.mdops->release)
+		metadump.mdops->release();
 
 out:
 	return 0;
-- 
2.39.1

