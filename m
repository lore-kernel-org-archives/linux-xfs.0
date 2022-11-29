Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D358C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbiK2VON (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237119AbiK2VNu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:50 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F0F70477
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:24 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIrTAm012335
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=acbjfF5lLh4Gil/z1wg3K0sLLs9EzUUYHdbdaKRxaj0=;
 b=HAC23C8UT/zd6o2euQnFiM913VqbaIn195m4Rflw1RqSvWESfWvO0XdArGsSkby/nXs7
 3xHTmGEUo8DWKCTg0Bqj1hlqj+WHrSPg9AN1kuc+3uidnqK0ol+Ugm00PwX0m7IHKGOB
 8e6djVjTcnyqd4hLI2l3Kh1/9qtbBe2NsaZTWDoHdij95UUFdHhmvnxsi0Vx/rm6hp7M
 3sPmHRZsk0jugOoYU0gfLilJ9Ts8M4+EJXRN2wi4852calp4FalgBOT1jq4kiUTNhUsm
 MZnh8ssrCaOYTg5lAk8OxthNK/WbyNWfX2BIe1s5+GBIJcoTb7NsNeosbHPGEkjuk4lT pA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m4aemeex8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKdXXS027922
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3987w9cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfUUfaryAKsOAYmO8HOBd9hOUEG0Anzt6+LcESEVctcBwKJ7nbdoMpYxa8FPIq5mAEdpxrGTjH5Wl29NOgaJqWheWFFbam9iPs31VAjN7c4pMxDn9q4DR2NIfdbdCnPP4ipQdeO09CYRGFNQeV5ve9hWL3Zfk4BNayk9iCVk5CqO9xENahytnGGY6zs3WX2a1UQz3BjDBWty5oo9gKmgt8Qd0r99BpC+62VEGbVgJO7bjJknyAaDhec8i4WV6eDBfNmtD1iTA3mdhJ+XCcAtOQBWlFCpoiIY7K66gUmnfqx8OcuHhjqfvICg8+iCEXcLl/07Wlr6Jl0TTB9SvUP40Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acbjfF5lLh4Gil/z1wg3K0sLLs9EzUUYHdbdaKRxaj0=;
 b=Vo5ursgYLS9YQxukVs+sdl7kzcGbYSh6iilLa0cC/WON0XEVQacgBMtaqfw9cWNKuTYm/UvrunyxnuI9E13JNWjdQ/SErT8au9xSwPNvoeus2Ojf1mEwxNjPg8jtjM/cAYUWPv4zft8l6rZkB9V8VYAaxjKWleXeaKAzx1cRLgiKnwmEtZVwFHw/f5uqf76Dd82diNgUoM86bw0J25XBhJ3985tOpRjIV5ES/S2TQG01zmfe1HaYTaSzwGn8epbz0SKo4Kt7VNvTzyT85GHGfX8gocbnaFyCGnc4BWs56WDBbP4u1sVSA2iARZgZkh3OVFebDY24RuNpyiKwHo4YhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acbjfF5lLh4Gil/z1wg3K0sLLs9EzUUYHdbdaKRxaj0=;
 b=iW1W+amqBOYpB1kItD2wWLHQ2ZtzkKZBQ1LI2eSJTNdTADJM6Cd0yX+lUZDUYVmYmDbFS4UjNmsSSQyGAMxVK9Hz429L7FmWONgRLGWepox4h/Yb1yvQqGJZZfbDjKSdiMdM/ssStCBXy2Cv7b6659HEoK74qISoGxXlNiMxKas=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB6205.namprd10.prod.outlook.com (2603:10b6:8:88::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 21:13:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:21 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 24/27] xfs: Filter XFS_ATTR_PARENT for getfattr
Date:   Tue, 29 Nov 2022 14:12:39 -0700
Message-Id: <20221129211242.2689855-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0226.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DM4PR10MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fd32ae7-41f7-4807-ce08-08dad24e8b9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RE9aR/fF3SbxSsxPxWawaUY51iLtKATEAlGI17G4K79oYDU4f2yoEjkVol7Y0FLtGhTzNRkE5UjDhysyAjardRu7sebtK0MT9L5a17FRw+FGhmHHaJlvXoCZSY2j4/34UwnpeGXUrktLcohcPqpzBW/Tgx47Y6xpGbDWFKp/KurERIduOcA1mOu4IFBz6C/9JvaODaZJutF+3pJnnV/37s73cb/3clH9pnOwaIdse90tuTcCjm/86uf+fpljUZ2vhwIhDZnJLI/q8zQGMZikAR0R7kLHPxqHvFDLYisg13w0hKU0ZK6rc/21PoIfI7TW9y2DUGAkL6J2KP+CdPCVvlGSJAvghRKxzCkNqIZKH52ppMbslqYS8mwwBaI8iCzquTvcgMcWKgy4xgokJjZWETrcHjA02TTQPE5ftuKtbkemSMB2A9YfdMK8hvSiCQTq58V6kwS+V9r19rEsUJrSuRGeTkyGkvUuOrqN/4e1UP4VWWUylw/cT/PCnTfwabb3NCicqZelrQFthHUlRqwc1rak45Yw9BJN2WfXEo/5MaujAA6w8BsCetm0VRYQWlEXuSUtksafufATRh9nuHtNqQS3mwv2gLq1xo3PU5goKSWURz1ZK9mE09LC/ytMBGEi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(316002)(36756003)(6486002)(6916009)(1076003)(2616005)(186003)(2906002)(41300700001)(66556008)(66946007)(8676002)(66476007)(86362001)(4744005)(8936002)(38100700002)(6512007)(5660300002)(9686003)(26005)(6666004)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eK9EFSQoQze18PFeu4iUpq7dIh5jV/LzXkCp9ep2Umun8S5AeYcUUJ4kDDPr?=
 =?us-ascii?Q?krepdHHpYSBgCV9mUJ4X3gJ1T3HO/kGTBOaqv3GNvLts0L8ZOUQUVWLVld4s?=
 =?us-ascii?Q?rihIw7+xVXEzYFPLKnmZHnfG4GvfW2w/ESnSYMmND+WwgHDrmGt+dG3Z7rqZ?=
 =?us-ascii?Q?OkCEsOgwUq4/63D7j7eFM6gJ0UAiNuRJJmZEl/XIlmnxING5dAooCNP5pyKt?=
 =?us-ascii?Q?sL4Jl92qXrwVY536T6ZcOXGI0nfVaQjedoVe+Vuk1Wp+2IsveXTQUh5khHpK?=
 =?us-ascii?Q?KQz5ZiDTugu71xlr7iNGEoLC/gTRKw4sDl7kDg2BNNGRWIN5c1ItnP23/yFY?=
 =?us-ascii?Q?1+BlvNi8BxXRwCMbd0qa+BKMaKTlItYRJttox/fhW8VWMH125Kau/iWWLaQ4?=
 =?us-ascii?Q?MHf69GlpZZ2rZPXQTomxNTRDFUpP4Gc4mK5tS4KhM9yXBlTpTs30sOnHHY8E?=
 =?us-ascii?Q?N5VNWpkuec0C4ZTylvC4EmyIcZHxSAHlnlu/s4b6njEc3d8iAH8oyMDmcvcc?=
 =?us-ascii?Q?oB0L0voB1JXAzOfREBFaW23kYHplt67yo7KZKGF/Z1bhzVFxgQ0vCQaQx4C+?=
 =?us-ascii?Q?7KWFCPwHN38b13qo8awIupyPL90tS8aDCmfq690T4hNUW7HPGThhcbgZDowP?=
 =?us-ascii?Q?Gc40sla6nYzQ4IW+8GpOICc9qoiBWeSsjS+dGFvR/hUbf7TMrQ0zv2Zo10l8?=
 =?us-ascii?Q?YN7Gl2lba9KKmIhQV1GLumiBEjvMc26tlfw7BYPcCm2eZfoRYy6NgwrF0TMD?=
 =?us-ascii?Q?/4fIEYApIW0XUUbEoEeEza4QwIUxgW6awbHYzo/CaBrjmeVvZHyNoab8USW/?=
 =?us-ascii?Q?jnGbohblZCADruD7wIrro3/8U99tnLYI8B1LHDT2hdzF1vZQE5wjq1dqdDTY?=
 =?us-ascii?Q?77EOLknCPxfKcnz3UGgvAndVDTPEEYpLy32xWs6xypP2c0e57xPSK9EfpLBx?=
 =?us-ascii?Q?xb6QQliUzpaRLXbbaBGKEEKCwPohXWt0duGoZdm5ln9M+gB+DhXnbT0DDuUh?=
 =?us-ascii?Q?y8mAk4564CFNKu6lAtCUo2RP1DaOT+5JRUzN/mc+4Ety8+AZPwRquPzxlcHL?=
 =?us-ascii?Q?w02hYGJ63qKfz+YkFTZEjPZAFKVBc6kqWKeVsaSPddwlydgJo4THStTjGxGw?=
 =?us-ascii?Q?ufN1NzlSwADaYnsE+MaSdtXTA6gzYltwy8z8TA+iADS8xHgp5kmkB5mrysei?=
 =?us-ascii?Q?1PeBdGUwJjcv0qsMbguQuhThKnb13vhp3xMikH3M4Zova3BG5xnsJU2bBT+j?=
 =?us-ascii?Q?Ii7J5zMhwe77gE2l44IotTdM+PmrCnTBXNvBXOpBSpPydxoAlQd2O8NAxZxg?=
 =?us-ascii?Q?I119O/FfhT9jsl9hUdm0PuHbECz7Ep9liMorxNrASN40xJkEvXS/Z7gSUEsP?=
 =?us-ascii?Q?vu1ArO0j/ZkCaGZYmnpBiftEAmydSDBAcqnXfccgOEkuejn6n0H3+usmbEE7?=
 =?us-ascii?Q?L0F/BRCN88El195FBKC7ENla6CumNue9lHwvwGjrQbRB+uGLzdvbGsHRQIYY?=
 =?us-ascii?Q?EYBYSQmkFPA6+g/U4BcxJiWsNa/E1eI0leWQLuGqdHEn3YHd6L5Ngcpu28FT?=
 =?us-ascii?Q?fprMfLtNI5EiRsubL/tJdhtzsom1PfjXCwtEykkGjDaDuLH2SLZLcagbeiL7?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lQ4BsnTWsKToUIxBiBjMiYdq4Z+0lYSxFmU4kp1CPDCl6zxlm3WjBor+Fn9kxXpj4oJPGo7R/YZrZH67SJ3M85vbpsV4A6nRqg+avure4B2qFDjs8zDwud1uDjZbxAfwdjHB0FZUPMy5gqUHgfu1DJ+UFZDYVvzxrVeb1SupQG1cA4UK/zdF+sSLupCGyeIsNXFNwzuELFTjQ/YuI0e8AKD0GvlsKrhSyRF5hxvmGGzJRoediFl3rAYiME3LvzzuEX0+WzDjO8XoUOSggydIG86KvfQQnjGEH0sVpwOg/sNjho0gf3Z78bvS/XNGrcXcjsLs++3V8mMxBnPPikEnoDou0DNqvrxShda4jHIygPG0Y4Cb4Xj5/Vl6e0r8uGtnbhYec4Bjdp0e6LCqPWZ6rECFCfHj5PeD/dkSOAEGfXNyFQdqFdPBdkGm1DiiGeY4rZd6ptQr7dEMOjV4vi9aEwnfNZ7sUQqikWCZQoKu/MjPLHEEojE0zYUedSyuucd9CKojGO+Jk7Np/3CKCrTC5rmNnir9WQqDL/Ej9fPJVsDLCr5ccV1unI31ZG8RSzbyTbbVYhHQMPSdzRFZthsEpKH+MvV3f5uIivAY+CO1r4+JtGEOk1UxnOwq2+NEarwno1GnkFRUeQ7lwoTLDmSbbBk1N+S3/GmhZCoUfUSKiYAdR4VtBpy/7eGouH4wBy6j7rwNneco6d7AxC6uVMJoae5WnkIqBZu+O8WasaKxJ8ZRDBIOVLNM+YjhicvssF24etVyXZ0Zt1mAgYcPvkAFMA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fd32ae7-41f7-4807-ce08-08dad24e8b9e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:21.9163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lm7nKMb+aHgixE/zr+bKvf2h9eX4CdznKArwkB28P/losRzFAQxw/ICh39t9K0IzrzP+JqF+QoE/lrbs3BWwlz4HRP+H1oXqHkQWDnN42Gc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: xonBO79naxsvXOA0wP1eMpInqhVLXaz3
X-Proofpoint-GUID: xonBO79naxsvXOA0wP1eMpInqhVLXaz3
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

