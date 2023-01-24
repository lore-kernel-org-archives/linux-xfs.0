Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F949C05027
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjAXBg7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbjAXBg4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:56 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54871A483
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:55 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04HJj016587
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=UojYfovIOMxEVbXz2q9zgrlM284fM2bX8USyuISAM6c=;
 b=BHdFxDujyKvNUj+KGxLhfMhKlD1q5fDvXNV8fV2VMre5dU1/AFUwxrHVKw2o0DtUJx1l
 su0zJTNvfyi22klFHdNrHm6qZXEXed1VZJwATg7dj62g7Zi4lDcrtCtdoMdpCMgLzgW3
 Ma1++mi265nBf+q+VbleLO4NSyt/9i7z9+dXHGIfCEwDynZyyo9IgFg9m82SDmFdoovN
 pxq2ZrIprI9VCoj71kN2Ljd5vmt9A1X64tCl0qA/GgmUoQ1qX7V2rbDsz607w6Fbq4mg
 FoCVv6uyC4tY3aPh2AmfJjqBxhRtakZcT0D+aSR18A5fN4spmESj58AHtXeDlpbztra4 ow== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nt4a3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNPUWI001439
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gakvta-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvwvSMz6I+X+WLP7ySLrxd52ohALUavIQSddLUjHke9DWB3ymZaEF31PAxalc1lpz+52/8S5h2yky/D/HVC1UyGIQ9wQkktDskoP3bzC0dTGo2AEq8bkkSg6o1dN6tsJsPvoeRdFHo4tN0iY1iQ2sVC6FcKUU3/cOjh/RBTEnYxG+FL1d/3XropyzheYb43wo4pc57d5scSTcId68CVF1+BIi+jHkgXgXvUSpJwmE5rxGB1dAPievEy7uwBf0F64eymJhLwQUPpBJGR9fa0+zmgs+TKEX2ePzlvhn520r44Oaczjagot/oLsjL3n0Jj7Vr3HpXtREiD6sZIivSVu1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UojYfovIOMxEVbXz2q9zgrlM284fM2bX8USyuISAM6c=;
 b=S/FnEr4DJW/1XqJCyo9cNCtv2pHdQeZxPdnym5Y1ePmpNJYbNMmtjwD/pCwIOCEhCXd6EoIfjhNPLrUH9Up1m6mRVo65jxow7WmJbPSuNY625W4zYvDO4zwLox8rhfV/VwfVFWanIsj9nk+kKNzJOdsGrZixXx1jmed18ELQQeBwDmdpIxRRgeVlsnfSEMp928N3v3EuH5NplmXw/5zM11FYGsi8vOtcikcmxYwAlwy0D8PIXQA6T2bIBnq+b4m84NwMtyumhYzqNMfkG8DJ+M+2eV2lFbNujnHerAOhpGVH+GzDhZBwRImYIWVtxIMT5XeILCgoqn9268Ct6BKXOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UojYfovIOMxEVbXz2q9zgrlM284fM2bX8USyuISAM6c=;
 b=qiEsNT7Lg9XOC4DZHRCoin54YJUdnD5nS5otRUh0+PaupTgMmRuediCLZG6B7kf97/VSRfxWV+YZDNMh3yGxZSjudQIERFp4+zOBzGvnqriQKeyCW3oGlDd9pO/zXd8tKFOuM7UGqYJ+Kce8xeJxPkawYf8JgFOD1oh4eVnVWgI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:53 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:53 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 19/27] xfs: Indent xfs_rename
Date:   Mon, 23 Jan 2023 18:36:12 -0700
Message-Id: <20230124013620.1089319-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0147.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: c905d523-3f47-436a-98be-08dafdab787d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p6JDxGUdGSiNCXS934DmX0zu36dxBP5tKaWnz/LmhqY3UWckdPDueHMcYG9AXTdQA/4SlAiXo3BjADbCxDjAHtZXllNubAiU0ZTOzkRstoMTwLJnyBRn+PzsJhVB5bJ6VVrHPCy62DKVJOJFftgqcKI4n7lS3GHK3aoxV6db8/2CwbtgUW0XuNdqY16GhRHxUMMXyU6Q5W3Sf49vHi02LBsM1glJTPpNQ5u53eDUEIc9a5zHbr/1Lt2xHua12EQrB+Pwb+j8TlKt/j2gDanHW2A6xcZlsPS3u8LtO6JaKpt0LDyJqI170T5ENAkZZhpsCRmWcZkHXLLGqATOh3MM0VL8HfoEVQGQbuCGTN07+o9wK76EES29m4mp85ym4X9HItR2oPzHC6mBuHFdn0Bs0cKZqm3fPc90/07K8NgbwL6v/4yQJN91DzXGgCfFketK7bWmMGUsi6MbShsdEkFvF3PgCi4iO+CWw9rw7CRU7uW6tappOxoJ5ar5S1jBzq+SkgKJw1Ig99EGjOx9BefGT52+tIjiCKiz2YmdQuX1gmbarZzs2V7dLbQnUQ3Qtu1E/3pXQ3XbW3Ly0AByzvw77o221xJ7wbMkziItVWEB5f5nMMf11dntGDxVRXHZhY5z/w3l1LGvQhWrgka4JYgEqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GQoq+HvQDg86uu0F0UZCrjQvrsiNuI/mN4uibtuZjuS9wmz9JBubFofvvc4i?=
 =?us-ascii?Q?aBpuJRsjqOzybx1YypaXFCqNVDLVE4cnlnyyb5hTDAkWm/4+SJspNkN+skZq?=
 =?us-ascii?Q?93sMBEdNUFHftwdoy4RLLgr6n6AKI/ApTjxt4mnLM9sV+/jhObufWjR3OPdQ?=
 =?us-ascii?Q?p/sdg2ebBnj9Zmv5/OJtVX4sZlmqjzA0ga9MgvwsfUVRON7K3JlYymLdYpb0?=
 =?us-ascii?Q?vj6HYAqV9m+L7NThCiHogdWFW1q4g9C924s3UXrH7Su1rrROu6I7oRYtnVnr?=
 =?us-ascii?Q?sPoAK+4DmfTH4y//TEIMDKjzZwTHd31JuaV7RVuDe+QioOsvKvSmxqu44gPl?=
 =?us-ascii?Q?5uvM/3vwcdM+VKTlDzh1NF+OHI6+iEzAWv6fZxG2k62HctzP91rrnIFNmrVY?=
 =?us-ascii?Q?Xs+f4DxdRwKGS5gJ+TkdVM/BHse1He81Yi6CMbdXyN8ipILqF/Nv3svAASPY?=
 =?us-ascii?Q?fn5gMq2IPnU67BICkLQ+vLh1+kA2AiDEqIDaGyn7Y5KIknAZDW3LqKCa0fTT?=
 =?us-ascii?Q?6WNvJYBnZNKbaAzYraBa3qukPC70dcu53KGEDGreiinppy5ZMjVm3KK/C012?=
 =?us-ascii?Q?JbHdfA6Oc9WNHiRQgdyPwf82cAX9z1LIC8rBBScEpDCCxDtyaJJWyD7m2L+y?=
 =?us-ascii?Q?h0soAqXHSSQb5p5EqvVmCuQypTYkzsnAWjgeosR2NmsdMJEqKcTppgRszKrk?=
 =?us-ascii?Q?MbmVszUxIMJnM8FRaKycGYfyXf/qiVS3XszVWoDvD33o5qWu0y3Ej89lk5oX?=
 =?us-ascii?Q?x053Vce4sDwHDXevTkOOFUvJVODaPb5xaVvFtqm1LuXiNQPZWO/UrpJKRruG?=
 =?us-ascii?Q?lVn1bVyGIpEk2Tov2r/YOHH1VXbTpmtyavc6hS8nRs4EMOYu5+SZTwSnuLNg?=
 =?us-ascii?Q?isc8oxUXVDR618uVf65wXIo8FyB96D+h9yv7Fm6WlvN4G1Yutd9FrhVyTC81?=
 =?us-ascii?Q?ENuyrApDf4yeiO5lI0fcvpcQRHX9v3zuoVrZmF+1EMw6p00KL9xfD7pN+gIx?=
 =?us-ascii?Q?p8VpOs66erb06c0VQSt7oPTrW+WhHX0tDGtf3CLmTTpBDxZKvyYLy0oVGnSq?=
 =?us-ascii?Q?pJDnO+D5QRTPVLhSgszhGgrxGgWKboIjVkxlFMC0jrtpTRKAxaKYwcpvc6Ts?=
 =?us-ascii?Q?Gqj5PotebcoxqqD+5BJlFDXYHznwmg6xFqzasrDmhhSIOwpAmGcKbMQDOJ6H?=
 =?us-ascii?Q?RD7FoYb4x8pegVi4vv87NzVRgHKZlEmIdon/FRSsf0UResZnQqi7cSrd+//l?=
 =?us-ascii?Q?FPl4L4Bwr3c8VrKyLOi8GtvLbXyCuc4hpW1/+FFoNGJOAcc9Cn8EBOfiEJ2l?=
 =?us-ascii?Q?VC/DldPqhEmKCk7e5kRJZ4mSrC7TJiJcnWAKxDt+2WpNIGKEk8LuSxD8V6sT?=
 =?us-ascii?Q?tOxvUwY6zmazuLQ47BBsUI0M3Pzziq2vktL1qnWRQ/LwpFr8lVA0bkiKY5y2?=
 =?us-ascii?Q?DxpGtgC1yX9NcU8aDi/+LWsxqS5oYwq71a7H9G7O+o0u+rLYJdwANU+8QkaC?=
 =?us-ascii?Q?AhMVkE6u4I8k6+fVKKDmjguj1lcpyeO708HX6q2xfPwA7s/xuElm/ZWJpf9s?=
 =?us-ascii?Q?xBlAKbMy3jd3qc2dHpbmVnkNHL8XEovVDTZbHGVjS0dmi0XS/fwBvGEAz5zy?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DWQ1kPCuryFwf15PPe+aIwt06hkUX1+xx9AbBfMf+jWpHuuDjoPLg2V03lFZk38tpkoW5DjutNuhcLmvljDW8CwVtMsFEmztP5Yhnw88r21JucqvEvaDDvKxrCK5GHAMGJRtlb0K/52HtHR1ls+TzcQl9vm4GmU8EtQUvwlmcsKD+rGD2FqHIMNaVoLfQz7CbOnI7GX8vaQG9P2FS6WEL026z2OqBux4LTN+R9bzXYYYEdq4ZOgjPyi3OyaeXtuE91qJzWl4JceZ8Bxkla7VfW5NXGp4+G2xg0sQ53g6yEHLimHa3+u0PtnkS/y/tC1K0Q7tSsnaaXki6D8OeayQ7BoKf2uAhV0fYW5wm+2ReqfUzGDGMrCKo8Lk+O7Boc7OTViSYl22LErHrjV0PkGBaQaKqB9uBN5Uas58O48PnFLxSh0vqS+NhtJhFjBamaO7dZW/XhSEIsg0k2KhfGeR/fWBZvtrTQyNKUrLbjwuhsHAs+/+wRLgNi80GoYXExYKbYM4goXogZoe7EL9J80CQe6hsuHLGtGc3UTbeJUdtWR/pokYEYRU90qA/U2fVMihaI5JZqA1fM5bNV+l/7NrStltWGJaqQrCd3OIw8WlfN6wLPWrLqzrsklewhcKjXgnoKtRKGPyqDkMllGZBVIWcoHgzU94anltMyuhV4yfIZYki4zaCHkn7qWaBAObHE8ZWkZ5fS3UYn59AmLwmafIJHfrMJ1mnTN8JHXZkiSYgUPj9pKOYODlTp5PNA0G0R2/npHmYsYATMLQm7nfMclBRg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c905d523-3f47-436a-98be-08dafdab787d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:53.0640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m6KaAjEIte6+HCQycmTDkHR1E+qyLK0edBDkJXx/eLu9WA9GSiI/xI6d0ZpfgXEGGUH7fLN2aYL5h78SMWKwMUyla/tp1vdhzTlNB9amT9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-ORIG-GUID: L_ht6_PA1WMAKWIRPSeOGV5boy3CUYaZ
X-Proofpoint-GUID: L_ht6_PA1WMAKWIRPSeOGV5boy3CUYaZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Indent variables and parameters in xfs_rename in preparation for
parent pointer modifications.  White space only, no functional
changes.  This will make reviewing new code easier on reviewers.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f593f0c9227c..f07720ffe977 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2898,26 +2898,27 @@ xfs_rename_alloc_whiteout(
  */
 int
 xfs_rename(
-	struct user_namespace	*mnt_userns,
-	struct xfs_inode	*src_dp,
-	struct xfs_name		*src_name,
-	struct xfs_inode	*src_ip,
-	struct xfs_inode	*target_dp,
-	struct xfs_name		*target_name,
-	struct xfs_inode	*target_ip,
-	unsigned int		flags)
-{
-	struct xfs_mount	*mp = src_dp->i_mount;
-	struct xfs_trans	*tp;
-	struct xfs_inode	*wip = NULL;		/* whiteout inode */
-	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	int			i;
-	int			num_inodes = __XFS_SORT_INODES;
-	bool			new_parent = (src_dp != target_dp);
-	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
-	int			spaceres;
-	bool			retried = false;
-	int			error, nospace_error = 0;
+	struct user_namespace		*mnt_userns,
+	struct xfs_inode		*src_dp,
+	struct xfs_name			*src_name,
+	struct xfs_inode		*src_ip,
+	struct xfs_inode		*target_dp,
+	struct xfs_name			*target_name,
+	struct xfs_inode		*target_ip,
+	unsigned int			flags)
+{
+	struct xfs_mount		*mp = src_dp->i_mount;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*wip = NULL;	/* whiteout inode */
+	struct xfs_inode		*inodes[__XFS_SORT_INODES];
+	int				i;
+	int				num_inodes = __XFS_SORT_INODES;
+	bool				new_parent = (src_dp != target_dp);
+	bool				src_is_directory =
+						S_ISDIR(VFS_I(src_ip)->i_mode);
+	int				spaceres;
+	bool				retried = false;
+	int				error, nospace_error = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
-- 
2.25.1

