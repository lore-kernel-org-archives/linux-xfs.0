Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD82EC05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBIICi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBIICg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DDF2DE75
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:35 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197Pvjp011833
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=9VypDKPA2rlmjm6ThcApsxm6VyfB8HElvx9QBsMNLyw=;
 b=sQ32bgwbS4lQ5r9LEFVTlvA2bb2Qz1WIM07nQ8kBHMjIScEzL3D3e9WUb4MWqlkH9y5c
 ElgxCP6aq+B4/HgrwEy8N/t7zMksfIDTU6qLI5q4RU2YYLEarupSqvjhhO9u+cb2Wgqh
 dkNQC0YjqlVP8twJrxGjSmZqos2rczNXHw7NROGmOIiTRsymlQWcv7Pzwk5OOEQgy5Gj
 WcrEmZKUHGzQ45QgDXZujyAE4/L15qwDrT2/yXBvKDw/ws+IERnF09j4B4sxdNTNxfzX
 b0x1bVWR/Bb1qfcaZxlgeX/bdewCPfiPhm3e28Ech/LL1u7q846zB+P4OH5K2o+zkLQK HQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1a76u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196t43f031609
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3njrbcxv8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYxfkMomWloIG0LxSzrQOYtufbazQthyULjln2HrwUOc3qr8HdFg/1rP1DFj1Lb7SAt/tAZaUG8lFYt7AgPyWJ5gAYv4da5O+TzarZD2E+ODX9bNpTO5cDWFlFHpoBHh1CfIF1iHqf6NOGD1XnyIGjy66oPNYS3dm2NqOTbdcHXXFADUWnbxzeTKjvKh5jRQLukJNNqZfSJLVP2C2H37FbWckpmEhLC6Iv3Lx7BfODZjHF6fdHXi8cUzj80gdLlAIp+utVGW99bNQch6jlfTMTql17jkbjW5pievEXA1sZj4RvdDQCvE4hboXOzo+5UHGxYjR8hpqktm7EG0ylybRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VypDKPA2rlmjm6ThcApsxm6VyfB8HElvx9QBsMNLyw=;
 b=ErMfX0jMA7RMryVF7UQPMZhnSbek7h1+IXVgtC58jOAjtHUdsJKtoWSytPkre+24G/BtZmBY70fOvCTlj5ztpngsCFF4UOzAD7PNu/GC9ExxCCcCkdLEzLrMCr38EDrKzrWei+GDmmA2WiXDyrko0QIA28tZeEQzEhaNHIFtzx5359AHyf625owr46Pwbi5wDL36974lSYBW7l+WjOZnvt6+CpeW3iHZ0RMPUMLb9TWg0kvWkDXmt8xUeRg0RxJQRCL54tkOXfpR1xYUtEGx8AKzvuCcxi4ToKFv6xiPnQarVuycFBg++Ll/9uQnMiDMAZykF2Z57fCl7z23hJZxhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VypDKPA2rlmjm6ThcApsxm6VyfB8HElvx9QBsMNLyw=;
 b=GEH2EqNsmN94tyRvIJp/T63mHZetQQ1Umgs5EJs4fCtj2qGd5kE+rTJoOLFQlcygCb/MCmGVqhkkJd8tz64UsqYIbrAACr6GSFkFuo+jCG0M8N+7esIpB18WMGGbAZ97kj4JEYfocfKqN84A4uY9JD6OhD/lSvNJnYdoorxLNLM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:32 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 24/28] xfs: Filter XFS_ATTR_PARENT for getfattr
Date:   Thu,  9 Feb 2023 01:01:42 -0700
Message-Id: <20230209080146.378973-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0090.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: c97c2a66-8642-4821-2449-08db0a73ff53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: elPmD1JhzOfphkd7TJ8cnnkeElUJxsGQ4a1MAbyL8WaB/XgFPd8xJCePRDuxaiLejf5JBf/+9fYqlAiHaqoSTSXcFkWbTbrq+AfNhSjlrrv4yONa0IBDTt7abzomqakcxDAgV0vDygUdE6nv8TW4us/0kdWVXBDiZqnTdH6GKytIkbdVvRNGYb5kbzb8omwf8h9r/2pLyd8dNLVWgo9h/6zdYxM1MSc7Abwwi1eDgQqPrgfbWZ1GvCiHEKRmQ5RobWnUJEctUGUUX3GpZxj59/L9dxZyzmOXo7Vrcy1N1sduLKWlD1RhrVuZG6Nd3EqCPxOLNrGPh9HuQQQ5urrYp8ftE8VUe9fte0Co+GYgFAYwqwcs791EdxN2sf05oQLjxf/zZtbdtJJ6QZllbIc2PvkzDhgsCYmvT4Fp/lESRZkf3UTwiLmz/3VDx/R3X6pN7cAyAb8zppMrLdU1bQr0PDeVHH24F+wLbWOpVYZJr1xwE61r/BKTAKO6l++LM8abdM/qUFzkf1kKn57mq/fyoHsF9r+bPmMsvn40V7VHpAsstBbAdO0DDSDDC8hWKyu2wkArUkMG1Q0h1/TCCr1LnogLhLP1rjjnk9kxkPgMawzOq3STlWGh+mn7RVl4GOVl5aKO9no4Hu6GEE/4laIBQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ff5CBKPea4WzpVcX0/45P72govJZUcx2bX9blnOlcidLXnLzkD+/KXd182K?=
 =?us-ascii?Q?auYo9qNx3oHiHzG0mGIBaqT7+PdemsHkTK30geDTHy/83kf5X1DXz5/OLQgb?=
 =?us-ascii?Q?JgP4JwzaqVAcL9VhY4SyqEz5AB7ps2tbZwGnbm7j+awjGhuPyXbi7Bi1xmZJ?=
 =?us-ascii?Q?pKQ/0z7dpJI7LAXjD5hS4XdAjtJfvVbsgZxeVTN7EogfHiUtve+c6V6sPYPN?=
 =?us-ascii?Q?m4pbZt2vd+WF8PVhC3mpKz/cLh/LpNpyCouCMQABVPcb5bEtyvSXUWv6K82M?=
 =?us-ascii?Q?U4LEVh1wu+dIyhvHabt5TywzHuizT08xgGr9yrVDuLwUoU41MeAnz6YnjL30?=
 =?us-ascii?Q?6wF3COoqWG6053QorIMUXoJo5oYLkOvBEnaFvo5xA3ErBFIjJK/DIzAH9jWx?=
 =?us-ascii?Q?9sdDS/YCcpa8wqUhfoB7b74Y8XklXzulVSO9EmCz/d8HTBtCD5NeN9zKCSCz?=
 =?us-ascii?Q?Z9SVNB1lqD33vZIFfBMcZ/37Nup1R9EqJmoY8gpgfsZsMw5oNaB/dIpGfqWM?=
 =?us-ascii?Q?vtqM3L0gPR2zMlwy9ZI0cEQsMoJOjXvZ02SJ/1zX1FF2xExGAav19dAWlEs3?=
 =?us-ascii?Q?L+P5rSBRt3EDAtp1J2dKS4JmVyi8N5AxuuYhsQUJCus1g4IyCT7vrfre3h3B?=
 =?us-ascii?Q?yVw4rW6Y6Cxuac4fh9VOF2L3HRkhQaR0VVZ7+Kl1zs+FUCrj5La3vjoEbcj3?=
 =?us-ascii?Q?8IwzYuygZcKjCRJZeAP3Y5mgmOH3kQAsdKHV9ECoprHbb9pJCkGrprOnro2B?=
 =?us-ascii?Q?ss1SeAjTl5LtTWbsl5Lu/cD4NBW9vPFTJQLuuvACbXx1ZM0MFHiV/H+NSzmy?=
 =?us-ascii?Q?bf4BPRkMLEOQLl5torjvrzt44dNUcrYoiU4jdmBHSBW5F2NChfjqm/eJDOzh?=
 =?us-ascii?Q?pSrcFBeYo6EQFnhn+eK1bwqZo6d0YtcUY8+iyi4NCzXRtjDZ7Sa11MpnYOr6?=
 =?us-ascii?Q?l59oIlTKp37TWycAI0uXXoSAv4YCSZK/9YbnwR9384ijRr+ay/XRwYa5vq7c?=
 =?us-ascii?Q?rxLEhvK7eTbcJYKLtW9jvqRLjIkHs1wWO4E+QisKWeWVZTJH5rczsDVv6lY0?=
 =?us-ascii?Q?tWZjoK++5fm8yj2+gh7hZTfwl4o/RT5Is4Sw6Lk6iqOMa18efwqUpbrSze5Y?=
 =?us-ascii?Q?G2lN4YuKKTldjytdkDNnnbVVGznOIXEsUnSTAFwg7SSdohb56SQBx8cqHJdL?=
 =?us-ascii?Q?+7Gwe2XnyfkQt17WJK1WrPSlaXnIa1uhvrQtT+YSe2RaS4qW+b+wuFcrlIPI?=
 =?us-ascii?Q?j+/rDaJRAuxGzrzJQeSxhFQ055X14+MK8oVoNzxKOBZWzcbu8ShZZ/OLcsB1?=
 =?us-ascii?Q?quqNuF3JoTWVnJ0pOGDFz79QsYPFKLJ1qslglFY1bhcwIgj0s3OYT5WshZWP?=
 =?us-ascii?Q?sz8vvrVc63QcBeoS8S5W0da1Fg9IIUJIXBJDh+jizwiwMwx1vcGoNoYnkY/W?=
 =?us-ascii?Q?OKfBr6hNULVdi7faTe22O2CHL3TMoprAbfPEXWxGlcv3r966b49XlCqBPtv1?=
 =?us-ascii?Q?9eHtOZBMfVan4+LAKrZ5xQXuYCLCN7WNb0I4U0VqPK5Y9Wn2HISS6tPqh1fS?=
 =?us-ascii?Q?5wEC90udNEErKFIU3UDqQ4IHwZ24ZhFLiGD07MQg0fhu/XE4njNzriiapLvf?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /7EeopYshQqy56VOfEQtzL1O2XKZGY0q2BAyeQF9QqYAS+IcIVriglV1h6HN+t/Pngmf28LeSf0MnSYPKAn2SGZPH8AmCvqIEycDzr7T1Hmv4ViFA8EEnmA5UFr0srBbUZFNwgQz9sUwTR+MejTC90Vk6qrzAEvXeJtCGZY8963jwQOw0ATYW7JK4S2gj4otUffPlW3LLnI1VxceHPPHzU5W7elNlGYXhNwJrbXCkdbJeQJ2xp8WSmezMLkYacHg5pjq/zTzgOVzqwBn3SkFbuyMmCsvpzfXXbyXoB4Zx87WJnFVuVxwu30mFXHe23Ztt9JXzsn3Egz8Wyt+uWzmagNLNQ87jT0P1kKZnXQbdvH2RS95+TS47Vn+xOzf9e+7OS8GxlWfYkFJQPl1QgiZhHEbueusOKXVfNp/OXCchT+wq9AeNcsMDePSFhCkT+pGcqYuJEUB9uCVDVmPKu+FzoIJBAtZPC9JaVPfCTsnTO3TVtaebn4iR5z/lhX/T94wLBbViDDYUwABa9IFVmMzTbkY93LpSgGTKBFVmweLDd3wIoGlBrEWz33byDmyDicvkMv9v37z+3R+G5jrexIFEMEbicF4F9hfu8+uOA9OfCY7I34FF0HCyW0RmzIehhJKn+RM23lZELayMEj+0isjXRLp7/uLKnzCRfKhW+4H65Z9usEcN8VwZhGDtkyoxTcJdP0xLhdtMSj6fuD7smzfb5t0/Q/X6bT6dgBiUSeUdspDqDArI1E/PJFJ/XlDkRlj
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c97c2a66-8642-4821-2449-08db0a73ff53
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:32.6255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V0VeI71/hoP9raSDuRYV/k5FZDXs++XoTxpw0Meue6ayX732I4SWP7b7DyA6k2YFCPctfSm8ZFVek3yH23ToJWsZUbneVR75eme/lnruYII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090075
X-Proofpoint-GUID: rs3mr_JlklINtoYDDvCwMin6boPAIdsE
X-Proofpoint-ORIG-GUID: rs3mr_JlklINtoYDDvCwMin6boPAIdsE
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
index c1f4bfd71e73..ab5c7bdae457 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -232,6 +232,9 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	if (flags & XFS_ATTR_PARENT)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&
-- 
2.25.1

