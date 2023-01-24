Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552FCC54EED
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbjAXBg6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjAXBgz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:55 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09611ABD9
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:51 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04YfL021740
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=WYKMuhe4vP7BDr+mkp//BTZ8PM6zP7jTWKoGz8CxKas=;
 b=k+/fpWkm8vDE5xvsZ5t85ZOdEWwRiHDW2QLnjeiBtdUG5fQxBvUmHh2WlQNMFoi6ZWyL
 N4Wu6h5gD2t0/ZFJmsDHTLS2DM4AQ1ztWWI4AgZnQ3eG8j4o5Ra/2Tn6uEyMxR2I5Sff
 sYkecttadJjoS6v7736QsNJDiWCy163jeJ2Rpg24kndXFavq+9VW6BrAx2/GTiRo2oo5
 7hm/ruGo3FObMgiSSqDVsQ+FWBYquGrRBO7ECepbxNs8j2m0QKH4Zw1a2fIFwJayFbMe
 WW69+NaW8AFBPAUmwDzpJGM5/K4wP1vGKLmrPxUPs7b1R1D1lDWgpydRZ3fqiv0ynQ4z 1Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n883c4afs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNYBNN001108
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gakvrn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kA53EQCFq6eVsJApcnBEdLHk+snkD5WuhGGCI9CKbmZsBI4CyI5tRhWTG9jgMkHPuCnoiirQZNt0QDOxgcJtqMKSaqQDgHKn+ppYLw1COxLFr42l8lf5M9J67IjDkrb+ePYHpRep7Zm81H+Mzon5qCUUIxBPL21kRs9XWRSGw7NWeyKPuIJGPzg02VAMnsdAK6ybSLNP9rxhdv8/HZgWXMcPhGyFi6bmA+FFKoEhxWtcVpS9Y4w5V0G9Dvf87YxiSwsBhlelABCODsplc6ZuyucXgnukp/PTyzBJwZCvf7S73oGFN1M4TFejEXBQ8xaa0QBqmbmHdJcecJYHcZEEIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WYKMuhe4vP7BDr+mkp//BTZ8PM6zP7jTWKoGz8CxKas=;
 b=WqoSythuI8CUklFhHfju9XsiC16iWbPGe5Bcgw2Sh3PPMaTPTJXb48j7wWLbeVDcjBSii4bw1QnVL+lnlXoEBwAdgoxeM4UiYyf65lRDdbHNMhR+AT7v1nW9uVNLPKJ/JbFs6AUFksSzd62ubr0XVy2JGxiLccf6/p92cpjObsd25Kl7cbxFz1kgeeQZgzD+M3yQ+iGQ2s332Mj2vivcY5XVBiqa5PVgCHnOXSk5oOFS9S2ZV6lMgF3xp9kpCZK1TA0lVwkbrWVoa2JMiNvTVbnsrOVTdTMHAmG+f5MrABEzDUrA6qSF37xm1Vmxj4LKLAXDJX9N+Ds96zM0MrQ27w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYKMuhe4vP7BDr+mkp//BTZ8PM6zP7jTWKoGz8CxKas=;
 b=EmuuiTzotxKlIDg263vjcFaKghj3O7gOeQY2PCAnPOHKYsvpikjlqdYSl0pPbv1ExflIGaUp9D7uJAfdhRcf3CJ7tVe//wpn1Nw6KBUlTtP9vdKexfbJsE/5+Top3cwQmaLVurwaSXKXpnza40dFgo8cwqrw+ZKAUyRSCgBnZ9Y=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:48 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 16/27] xfs: add parent attributes to link
Date:   Mon, 23 Jan 2023 18:36:09 -0700
Message-Id: <20230124013620.1089319-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 008364a1-b111-4b09-d8d2-08dafdab75c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMDDuzYnYisrsxsS513eGdLs8NLrktYtzEKb+gI1wAXOiv8wN59/z0qust+jSGUMycOCAvuQg+8czFYcVjxIcc8CA3/f9STcR6N3sWhcfYXrRpjrGuJMtTKpAlWfSNDPLAOROooZ6u2Gjwk9pQ3n+lWKae9qG88EyEeQ7Z1VLLwJXfJpvqGHc0W4izx1t5DrnWd28kYEwXrw0+ASwRU8WKyLiBP9eK3sezQ6ca4pq27wymviBgMRZYDDuZt+e8F5GwX/QKRVRMrBHiLiodwm1TJMQsU/G6PhV2YTTOxRjujCNIe0b/kyR/X5wPoAjKqLHdnkKW4FWoX7ingB3wyFCahghO+4JsIsImlnOU36iiHqg2GlgkuCT7yOZwwN00uyK9ft3Yiep3vy+2oFZyi10GRXWPZ5F23loKm/0Uod4usGl+uco4x7YPLTYZqI1ILw9pK8+E7JAp5Vmzdev5WCIqOqFqPHbmREfzxDglwlAuY4ojBBQGqKHf+ugeqr4yIBsT5nR/BIILPt7W6zccq+jFFEXTx4GG7e66/IPJRfhAQokbo/hrRVokQLB19gMvt0FR84gUfsXmzxyPYDllA/CnA3o9utiKP80K6WmEvtrlj4Ev80/76G25qucqIGBqkcrSpK687r6rSb00uCrsYgMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hPM2mRkVcleFSkzT1Mf88kca0cE/uuwk1rBknISjL6GiZDkz4kkSAZKbuNJC?=
 =?us-ascii?Q?rBJ9BI/dGfwH4Y0YTS8OZ8ZMrkGeIo31PgVKNXWZuPTyTpRmuHJCMSi+9l+p?=
 =?us-ascii?Q?FclumqR20/bQz/qe6pePocd+xEny82K67vingEtYOtWQEsr+becCvi3PgBti?=
 =?us-ascii?Q?xwUzSOdFCeuoTHR7oUtAALSZ1eEwzmexu23C4BMMbzylIE0K8xpdFCbeJXWp?=
 =?us-ascii?Q?9oy6SmeyQcXw172Q9heLhx1Rdskr+8oEIiNMi1LpzlFjfK8RwTnrW1Q6AVAs?=
 =?us-ascii?Q?6q5n78tQRkQl6PQ3fk33BdSy5DIweLIfsER/wD8QyZ/5sLPaN7kGckMnNgjs?=
 =?us-ascii?Q?XrBjk3lvSQ6cC+bNXTYCc5GlV295ZqDKMe18L9qyZU/WOEDuO/6WwlxHCW98?=
 =?us-ascii?Q?QN99N+zo1JdqrMJ0KbxpOhBWe2B8zeearFDfiCPAhsbtKF4joUbuUJPSzycV?=
 =?us-ascii?Q?0CAKSbs75bC7IxqhZix/KbSMHMoumwxoi/6raKb8QlIw0IbzG/qlayOSx9PO?=
 =?us-ascii?Q?cB+oxPAxoGXtYqpDtWts/XWVJnDiAg2R+/10rqMdd4fCKLg1xJVf25CBmsWO?=
 =?us-ascii?Q?ZViLDjtaHg7CuW+h7uaKCwEf20w+hJb49HuetQ57jZBR/BwqhO3uWVWf7Z8r?=
 =?us-ascii?Q?ZrvOpZ82LzUeTObJGwwrgy6nQmWZl9vp/NCczqN8DuUiwsOLfm/8425c/McZ?=
 =?us-ascii?Q?6K/ze70JzYkgE4tkyw3ZsFbf7rfrJKaeSNWzwiICuBf4L02Wt2gw+vc29zvd?=
 =?us-ascii?Q?yNtQc7C1FffvFNy82JezQBuT7Nt45xUZXKlkhlvy1Uif14tdCKMVWgRJCduh?=
 =?us-ascii?Q?hp91hK0nU4NFyuLFkXpBTeLSg3uQRNmsZ5OJ2Ft2ihqAASb8/+S6f1K92Egj?=
 =?us-ascii?Q?EuV4+BPSCdu5CUnpMsDFus4sxdQ9mX0tXt3Erf+OSmpUfQhqexWsT9B1EcOi?=
 =?us-ascii?Q?PyWx4sqA0/wbF9wjtf17XsdCJfhqDovcysVgtXZ7yrEviAv9MTqcz8T/s689?=
 =?us-ascii?Q?veWOeLImfTx62mLXsEm6XMStE6hoOWeUEHkbKq6qWKwaLtsqim276PboX5yg?=
 =?us-ascii?Q?muUETyfyon5nZ3vHvSdTbYsPNgF7VJgavbIRkkZ3IxSKYiHd+KViQuD3frDG?=
 =?us-ascii?Q?nemalLw/REIBNpuluq6fNZ3kY36UyHfG/x5IgzdRUMNQTbpflXp3GQrHKxl4?=
 =?us-ascii?Q?QeVlbPiQ6gjjlfktL9BuvowiQAq62IlEtnPOg/iG5DGU6AUYEwxaSgMX56Rr?=
 =?us-ascii?Q?Hz96xV/a9QucSAozLzRV7ubdckZwLFWxCl1qNZlP+87GnEqDuC8BeSd2DwOu?=
 =?us-ascii?Q?Ojtgg0aryXGnZRU/B0Zx/y8Bg9dYVkbkhS4973eYw4vWc70TBr4gEYk6oTQb?=
 =?us-ascii?Q?nVhJk+w2UO4qE2crq7O0WnzL6By5iyuUfle4PKPRILr7KVkoSCDjRRGSqyYO?=
 =?us-ascii?Q?dCIMRA5DyenOJInU8On4RQh9UAyXjmgB5uGZFz6M1/KLnsAJcZTu9cHNsJM2?=
 =?us-ascii?Q?fDNii237D79+zq5HwKB2cL9Ll6Y4+j+Ckrwd0PsA5gCuCpL4Pff3Vw63ytwL?=
 =?us-ascii?Q?jgQJ0tYlu080Xw9UAH7lFjUtrNRaS8wQepCY1Iac8epKjgLAhU6eeSTtJFa+?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Qb/2Qo8TraLC+tdo8rb2SRshImRZvmwJAImoNOdldYxezhUKIgg3HTuJw8OERyF/M4+SbLxkkoHRjIWiS1gwI4FdniKRKbvpurzo+pQUZWcWjHEl5Qk5Cyf9WpKK7lsa4UOzY+vSPWgGWr1x8GpspcezeB9G45sUmYGVaDy8gkaiCNCXNMSArTKXOu0KVKyvN3VQWZpsfTd8J/SgVXzRcruu8YD7dflbuhlyU4qwDyQZoG8sO1p/4OcaptgkWHT9g8bp7h2iCK19KUyihM2qQ9swto6jEM2g+sz2ApyJ82lUUoIbOTOHqmWwzSWncsHHlV2tl2cgV2xWQ50FR02DGI2vwWZwJ8cpy1bMd38Gt7g2iMZnfq3nX7DRZUBe42z3WqzcLwJnYz0ZJTuPVv/iSRJ6xA1WjMV15OGkzkAwp4loFO4TFpneb2rJprlDBedy1M0TKLuIsFUal4YScNpcHR+wpyAMkE7Dg8GGKQApAIm/cJgH8ody90918BFUIoUgwEqWMAcbVvLxq/DgbfwWm1F5pG6kqJfbmCBV7dEYHfmXr13VFTbQXb4dymmLp1ab+bGMn6xS0rLOtRE1g5F9Hg41YC1BekApZbvsy0JxiT1OBukUA8S4XZg7llghzdbXwkiGfy1lwU1WM33rH9RUzgipBBQ4/zlj6sUTYiCTuTwJZGL0wZlTbBTISRd+pQ/13g5MCDv1QWglrNOa2lCIde0VWm9rTcuyy6MPOzTxdDSdDDgBbprmhp2FkKTJpI2W6LYzKUsCmnp5KqHmrLK8+Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 008364a1-b111-4b09-d8d2-08dafdab75c7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:48.5175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ff2dWCT9ouuaUEuNLzL9ZeEX6XZtC90qCv7MYcGFlmtyuVYDhpt6qPXzuobkkm7sWFZtrD+7ZxjR3z0L22dkVQdgygh2Qo4U3BSvx/ncQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-ORIG-GUID: Yn0wK0t_XDCxFtqOqYVPM9llLqPvXmkR
X-Proofpoint-GUID: Yn0wK0t_XDCxFtqOqYVPM9llLqPvXmkR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_inode.c              | 52 ++++++++++++++++++++++++++++-----
 2 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 87b31c69a773..f72207923ec2 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -84,8 +84,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_MKDIR_SPACE_RES(mp,nl)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9e195d0e6abc..ccc61cf0f9c6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1249,16 +1249,32 @@ xfs_create_tmpfile(
 	return error;
 }
 
+static unsigned int
+xfs_link_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
+	struct xfs_mount	*mp = tdp->i_mount;
+	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1275,11 +1291,17 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto std_return;
+	}
+
+	resblks = xfs_link_space_res(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
 			&tp, &nospace_error);
 	if (error)
-		goto std_return;
+		goto drop_incompat;
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1312,7 +1334,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks, NULL);
+				   resblks, &diroffset);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -1320,6 +1342,19 @@ xfs_link(
 
 	xfs_bumplink(tp, sip);
 
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, tdp, target_name,
+					     diroffset, sip);
+		if (error)
+			goto error_return;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -1337,6 +1372,9 @@ xfs_link(
 	xfs_trans_cancel(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
-- 
2.25.1

