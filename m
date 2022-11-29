Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C59C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbiK2VNl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237053AbiK2VNF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466C82DA84
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:01 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATKee5l026323
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=UFagZ+2Kia1cel9kvRtFpI+dtHYnQsmBti2V80+1+XI=;
 b=Iyr+xbyYlL/aW0ihCcbpHKHoZ5m+bKUz+i6l4Xzp2eNdUmmx/9M1hr6ZalxFTwYLRC+/
 pSYHARoZp7y4PlpL2avQHqkpLs+tVDzsDvXNcZSXmLpJ9j5PQF/9OuXHqALgJJnAvQGe
 OZjeG96ko5ujuJz5fIV3sqiJOj+VHxSUsU1XF/xE4u1Rw4cbRUkWNhAs5MTe2bNHcIk4
 MYTLw6KajRhdcOEwXjWCLcC1alqya1t/YhavD0ms/jrITWaoNJh+6SYgooEBGNxPJy7B
 llvCP7atyGVfXivaQqxu3nclX3h4kdBEy4LFoKb1fGyZZ/LwtzBGHnAdRHIdY+AXqj+c pg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m397fg5g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKTJAw027964
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3987w8nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCfbcGcodWHXBVY7R9KRwNiBxuc250fQQQLuD5D9iUWWMKAteHdNKOkTU9QTGa0JSMbbOF547K1REHtTzc1F51RkFLe4G3GVX5VA7dGcMIF0SSmW/SYEeeTKsI6yBDDl2H3ymRnF7TqfFUxJyXNfY2pEPJMgwX05oOnhhR21sSrYpbzJ58b5XzDO38EPzbjuS2iho8b6Zfr5IAMg/tWerrIRlRoP16CVQ1lWfc29aQagDbjDqdIFVPC3PdYspaVvVsTHOwoaSZG97XSRg7xq82V48tsZGPg8LuKzi65WgcKSoMmROeqn3T+xii7MGjdRFZoL5ww7tobz5oBwFqzihA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFagZ+2Kia1cel9kvRtFpI+dtHYnQsmBti2V80+1+XI=;
 b=A3fktPqklRwyLx/XToJx3DOUNDkRaqxQU8LRQo3j4JuQEw+9O/gLS7BtRrQ1uYDU5rNwg5LNIINo3bGi5tC32r8VUEmDZ268YB0BKB+xHSn/LccwFitEWRsjKeXM9lefoLngJlxY7y1L3U90hH39qSNYEEX7+pAXq8WYktqPsPPFLTlJMVEKNXKYuYMzpC+EwsKculo3R8EkZxDn0zhj+jjmVh2Qya4N+3q8kMObPTmxVx0czSLqOVhU8AF1Mlajvas8pIFXzxp84Q6z3IhmDQMGn8v8tvCpadeO7RNjmra7J2SSyJbLnKyZpRp7Ppvj5xafkk7v6tOYUlgTMdGqJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFagZ+2Kia1cel9kvRtFpI+dtHYnQsmBti2V80+1+XI=;
 b=Clalc1Ozjw1/JEvu/mMVjDPSPNrGzR0xY34/iFDP8eVuovoycGUqlIM3YD4jal6mPyfw637DosEEB4cZ0k55HeEYBc6QGHtC4WPzjecImRDBcIdr/4R1y0+fb/4Nsc+Bry/tZY2vDVHC/YNuXquRt4Wbzp7/xjQ2xpAN65rXdEM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB6205.namprd10.prod.outlook.com (2603:10b6:8:88::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 21:12:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:12:51 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 04/27] xfs: Hold inode locks in xfs_ialloc
Date:   Tue, 29 Nov 2022 14:12:19 -0700
Message-Id: <20221129211242.2689855-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DM4PR10MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f401c21-cec0-44d1-f178-08dad24e7935
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRvdN6rez0/mQ13TDc20pl8KpoIiXkuT/VE9Z5AZ7o+qSYKBK9xCgSEQhd+ckvIbDhUu0SKBW2t5QYwtP4Ye3uKn1f6vkHgvbbFNgov72aFKErSw1ySOkWqqLeumoSVpgIWo2m1XJkwsIuzhhJTmId0rHOe1Faqpxkg1QBUA1pNgL45123WeBYgHahW2CZbFRZA4jeRiLqJs+RgF7TVR51M802jWLNTPvlHGZXrC+nTNJB8jpOw7hqT4tRbFgoJeVtzRP0EDXhOy3UX0v8GEEpfBgV4dZfB3uoQZzr+2Fj5WXoudJSM9KpykqTTTWWmz7mzJchCoQQh5EykitQDqnivajdHeaha2zEGSm4/fkPT7tEMXD53ds7j9Pho30VbC6+emXgx1xnOAObXnrstfPy5XlktVQGPlaHId/e3Hv7wDhPt+Hz4ZXEOvqX8SjpxlnpdgqGq+wV+KmOO3qOG8gPwRhXesQGaUFNU2y7Wkkt5nqn+gexr6T7cYkwYu2b9RkRfwcwRiwPbgN5kDM6KG20c7AmtbVeRDhUkQbUJFKLnwIjuUpjrrgRavzBtb3OULuJCRr0dhfhvK9JQTPt89QanUTRO8/qKY8a/yqeP5cKayIbuMvChA7G25l/SvMikw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(316002)(36756003)(83380400001)(6486002)(6916009)(1076003)(2616005)(186003)(2906002)(41300700001)(66556008)(66946007)(8676002)(66476007)(86362001)(8936002)(38100700002)(6512007)(5660300002)(9686003)(26005)(6666004)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2oMA4D/z67EiICpO7WStpPVOsD9CxwidoIYnf+eDBNb5OvU4yTznBmh2nu46?=
 =?us-ascii?Q?36yddYJcubfk8VE8XMSknkZP8XKBZBFrEzf+9BFM7iqiWVxZZegk19UBdKeP?=
 =?us-ascii?Q?U7rL/H7Mil6Vkh24L+5PZ5knixePL1A2A5E9+wjT8BYoY2XNOrPh8u0FkKbP?=
 =?us-ascii?Q?/i4PtYll6NHrwElm1c58CTGT3yJvz3Xl+qbXK4Ni/sY7VF3vW7TS+WxLH/2m?=
 =?us-ascii?Q?l+YEIFtuP+Z+N6zMiDYWcriD7eh1dOT3pezxOvcdnTmCqwfbjvZeZ9En1u7i?=
 =?us-ascii?Q?BdOQ/awfmaj4pTAA2DayaGnQGoNXe4900p/fuKk6b08Dg2/+mzA9xPSyY5TE?=
 =?us-ascii?Q?lF2cOGGysywEzgfavQgMn/NvQQf0DgkG9H0UUcf5CP4QUrBdtJWgeCvacKIO?=
 =?us-ascii?Q?MKYhMBU7/K5zMJN6CA5Hfi4rRhT24/0d0BvWWdPbz15To9rh6bn86NwutV0t?=
 =?us-ascii?Q?1SZW5upCH13gtnx4slkIwALOGIEDcBrO+qxaF+gIcoTZhJ427uHAtF6Qp/D+?=
 =?us-ascii?Q?KKP2NG3mjtktD5w16Mw2X/FOOLUeYjg+HQlQmp346WVzO2onZSpDCRgHLNLK?=
 =?us-ascii?Q?bsGRaw6Tos4zX8/iAnxJShW/ugmK6CJOdd6Ckgyy7qWBCRoHIMAVUJN4WmC4?=
 =?us-ascii?Q?jY9ThulIovsCNbANFWbP/n3JhJB80yB8fcj3S8kI/dkNrTvNcgZZik79E5pV?=
 =?us-ascii?Q?zrRpDu2TlQeKsBqD9sfkFqbgkOpMmE0MVeW3VbyUdlG0Qo5R+lrrz+IFWQIy?=
 =?us-ascii?Q?SKJc/91txkqp6M0kpvsj4ECQOQ1NVHZTBYWwiumEoFuDGlSo127EgZfAOW7y?=
 =?us-ascii?Q?V9ABfYQ4SxhKdb/zxYPgVwt4Jip91pgL8RdJ2CmJtW/Yn0zAH72yEhqBgXEz?=
 =?us-ascii?Q?KrDncKlok430Krbjt6kaTQRoz78wyePDAFI9WJXq1mx+nAN22UqpPv20oYdF?=
 =?us-ascii?Q?2O5mMiPAbND2deEJXM8ziYDUlENY5ve304R7YQ9ur7ApI4bRyyD12MTLf1b6?=
 =?us-ascii?Q?DDm4OEHcUS+w150mNCFlhdOl2uv17iBOKAE6czPtnz3VdXCvxMZUl8wjdop5?=
 =?us-ascii?Q?rBUoUsI2y5+CwS2rPFbN1Crxz+r8Txn0DF7Ev4btQAQrG9N/G7ZdTTF5uZKY?=
 =?us-ascii?Q?R3RTIam4n9jgEI82DZPDjFGCAIHp0LTpsIDMllMMTx5zhys/vYmyw0kVXrG7?=
 =?us-ascii?Q?XLqUCGfrUSsJvb17aBuUqNXK7hjuvm2PooC9AEpeH+Mg/0+rAX5Z0ynbLZzT?=
 =?us-ascii?Q?s5uhmP7/dzMf/twyttwX+L83IOSUT0JoKq78LgN/ASGdk6/0Z4FR9q3l/Dgi?=
 =?us-ascii?Q?GjgAc4B50jvhQxLYsfEcubvulgZhUDV97tMdLpkY0sb/f0FWMNED8aPVRxsl?=
 =?us-ascii?Q?urriQYyOoPqt60T3oPKS7SUGJPLAPdCJMlSQyMMoPxSMgA2wmO0fSGikCUoS?=
 =?us-ascii?Q?mUrDQ4tM7VQzFqfEeyHy+gWjO6qiQRUol8YrUPs1b/lLj7pcGWdQOpdAD/k3?=
 =?us-ascii?Q?iFHsGlq8Qt5SZNCK1X2aBQom8VOpZ2Ppcty/Fa89C8t7kSpZSHNxyk4IoPmr?=
 =?us-ascii?Q?DoMATXetTIcvepATXFlSMXjrqri/PPUDPrwnYc9srb1drh4XgwGEBjF2Y2rn?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TmezbIHL70Irm/MHn1IBDkl8V2XCPhcgNckCLgMokWUtpLe066Q9EzWYjyJ5uoRqOSZEw3beLWXT7Wm88lWZdVLWPrGBXAmprmSwUOkFRuiMwFEg56YrHm96of3gvwVOgUJi4PXm5lBye8eOrMHJtLjwaK6YBfBJL3f4AN5KgV5msupOP2UEzw1STkshtaYXF8jRetE1oLkMm4ISUO4JfynrGtVrAeLmVwvlquildQzH2nftc3hJW1EpwbjkahToduOLzs1Lso0zfiT/+h+mR92n/WnvrZJHNm9Zi643/A7idwaYZ6e5UZNqArZ8NZI62ZYpnOQPdgViEb5btKQv58Q/NtNHTX47KIxhXB1OimabjAU2rPMbnlSRc9mSr0hjdr+BJrhzQL4gmFQpGqo2TN6ReKwlaRKZT3MNy8uw4eD7hlnJD2mV5H1eL7NplI3mfIdp9v5bI3a4b/U6IThNLb02i7mnybkAWPEMxvmf6rOWVA3TX2d/m+jNvXnwaluuKB/iy43yl9+cGT1hL0wUIWsaWdUi3dfkYSKVD0k7J5F0qhOMQf3pCZyHOYkRIVdU36INRsrqPczPQwAsTZIrC1RoiGDS50U5DKu14Ta0iwVlOTNYB9NdCOeBA5hzLsTQ4NWmIi+UAUACyAomt6X4XuUVAJ+SnPFNCMXjKIEBCDKJpdFC4F2BfUq7+bGXmglLy0sCPSAcHowHbA+NaK7TQLiUTMiNYhZZJOaNHb8c1SIrCbMHwgzWufbDMQ/somEqBe/ypC6XwAI19OTrlDNBUQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f401c21-cec0-44d1-f178-08dad24e7935
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:12:51.0612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tpqGIwu/NxW8FUixpsA3xT4CfH5EjKFdjF+5jqy83D8HoFD1++spgMonDPFxvcWmRv5OhRKEouNyxzOeyMlaVjAGUFf0hMVqLaviyP1FkDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: 0-vLHNzentorhlzmMTfrcUCpzML9WZKQ
X-Proofpoint-GUID: 0-vLHNzentorhlzmMTfrcUCpzML9WZKQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_ialloc to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c   | 6 +++++-
 fs/xfs/xfs_qm.c      | 4 +++-
 fs/xfs/xfs_symlink.c | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 27532053a67b..68254fc54fc8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -774,6 +774,8 @@ xfs_inode_inherit_flags2(
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
  */
 int
 xfs_init_new_inode(
@@ -899,7 +901,7 @@ xfs_init_new_inode(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1076,6 +1078,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1172,6 +1175,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 18bb4ec4d7c9..96e7b4959721 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -818,8 +818,10 @@ xfs_qm_qino_alloc(
 		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
-	if (need_alloc)
+	if (need_alloc) {
 		xfs_finish_inode_setup(*ipp);
+		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8389f3ef88ef..d8e120913036 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -337,6 +337,7 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -358,6 +359,8 @@ xfs_symlink(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.25.1

