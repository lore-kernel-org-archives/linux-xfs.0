Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D08C46467
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbiK2VNY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236900AbiK2VMu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:12:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D7723E84
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:12:48 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATInY7n013730
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=Fchxbvvo1pLD+XXvCbpQbU/iYDZu8TeTCfvp4B9WnZl+OcSyd073z1f7P3lIb0FJ5QYD
 Y+Z7M+Tzzi0nQed49hkv36PDKGnMYbJ2DTZozLn1p4p26ycbI2UqqTK0Ikc1o+fn7pR+
 qeX7zqiqa0h6oNgNKhzBSbJ8f9sohNAVmVDvi5ikYy2VKcMPW0lUmsmdFpxoyTml80qo
 +tXganhcxR6n69Rg4x9bmaDDB0CS3SOH1KxoWLp3ReJTCwMIOzBMpcIqbylQ3NVvrCW8
 VFLxrLqIUd6Hj1U2ly+n6AFlFP983ti8UCsqKExURsCgwIBPewpgClrU149EtB0MuA5c Mg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt889r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKQP9w027961
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m4a2hj0us-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKvKoPBvOqNUclniWQlkXCpYUUMjGjK+kbCgH/qDOFi103ubvAj4+71xgngO1xP5pIohFcgdlXVqvbbr/ubAhHsHXs7g0IsZ70q2uXoWpR5CIWj7lVDoN5/cfGULlZ8ldkSE8tVHe/6IHQWWABkfK3KWMhRw0y3+wXtZE7UjmdDJ1F788D1yD9Oi9q0zon9ZBNQ6SQUohQaqKxLf3yqfXDR+S9hGEmaKD0AnnGMz4yuqi5U946LNomTB0i98/gKyPT6Pgiu7JsYXveVxlrgHwWKvumHM8PRStDHlTDR6jXr5AmcoBBRUX+clfJNlKpWezJvma8ivo9HCUfabGmEx1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=dyeaJskoCE2SsAKfcAhLVbWugS7TpnGncP+xZ69nD0RuVGaJoRbdwtlUTxl7iv99V+t4k09y6ojzv1i0E3bNRL7JeogRW5ksBJ9kWNfA+1cAmepg0ivU/4nM7r8mk2uDPPZ/dgJUztirzsYVynu6cVyA/hrv1vxxFPK/FZVDeAnQaUJmGxJf6ayhiRHpWU1gygrUye8ZSu3OJrpukED9tPCfR6BkgbIWER/F1W2J9j7tgxxluMxEDgweGqpt/HGLtjzmNe9RDGAGwlIuSJU4IpgVsBYZ8Lt9JnDlNejzpiBiFKQln+z7x9T2z7d9esw3HFFmu+Vu9lhcyvnPCoM6cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+Mj2o48KZIU06tjOsGJKlU3MX9+qMBJYtvtML+DC1k=;
 b=XtPf9+ouR9UJuM/5TbnnF2xDro6aHitda0oLmXrizToicYAL5eyMUXVGAwyQnY/xXJR+ZTE9/VWqiM1fqiOGV6sQoukmzJ+ZEmJNjhm5DqLFZ3quM246n0U1zS7vycPFriV0m0sfxywiAfmDz8JEjxtx+vuYijO2DuLr1cJoL7o=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4259.namprd10.prod.outlook.com (2603:10b6:a03:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:12:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:12:45 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 01/27] xfs: Add new name to attri/d
Date:   Tue, 29 Nov 2022 14:12:16 -0700
Message-Id: <20221129211242.2689855-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:a03:254::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: 76b3a6b2-9a91-46d1-4b96-08dad24e75b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dMBHc5zaEE0lllkDdJns56wGMWGOQx76RAYP4UkZ06+gFv2JOt4lwcbU/0H6ePuPYFZ0BFKc2WrCebfXryFYsrCya9kD0CfEEwy72MgK4rAHT3rgOZHkslbRnUeanZu2XFcP6MTQ4bjtojwZFUZYQWyqu3/B1JZ2Nejs1np8/kJlKVwKwic6I0zoolB5WL87ISmABfmrd7VK5lM/3fgtb7GXk+h3ECwcup/HU6bCNCT6TOh914ebK4eBUydTbXzOpVSnnVTywzmBKK9RRmhaYkeUWWRpOp0VIv9sRZwOPFvE1k42IP/Pn6bli+ouNFF8PV+Ade0bOtTB1eqCkgnFXWow8FXAVJ042R7m9rJVqgIawLsk6YH2h2LrNMhdnfpFvUoyQ8ZsbqRTmacuRzaFJBuPTt5QN5CObzA9ZTaFzwSVyQE9cbjrs2LZMlh0oj7+l1S7eUdddaZkAIfRHjZngpEvqv9GGC4nOZC0kdzt2wRLJMgHgKPhpvtcX675RLYABYkdsxZ+SdQYukXd9950hFvUf2YaH5XODhZiUD60BYj2TpKtVcqvcyk/W2DjY5o+CTgCByIH6a3rYDqmQF3G9S7AlY1f6sijOD278Sm39MSRexbWngLW4vTQhz4RXtOX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(8936002)(5660300002)(8676002)(36756003)(186003)(66556008)(41300700001)(66476007)(6506007)(6916009)(316002)(38100700002)(83380400001)(2616005)(6666004)(6486002)(26005)(86362001)(6512007)(478600001)(66946007)(9686003)(1076003)(2906002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KsdkwMM6PiKM4Ay4GFE5AE4UjQDK/I8h5W03wIIIVE1NBEPywVBRX90hwlU7?=
 =?us-ascii?Q?Q+ZIV3sOaw7RE8iBd0hXxPqTQD5Bln66scs3HDsdoioIP3C36vv2TsRjvbXS?=
 =?us-ascii?Q?tr0tWk6h9TANts/3Ii8A4pTQmaQ3/dffMyGF6FsUhQ+j2bdo96dRC7GMCLR3?=
 =?us-ascii?Q?DZbmEZDs5fpRMfFFq3LEp1STt066DXdIwunCyhBMxGTLBTGnSt4jXk4ifalp?=
 =?us-ascii?Q?2O1JougFfdvSKSZY+0/dul9Qf7lHacK2o3EUoohdAsT+FTygB52M8vfePekp?=
 =?us-ascii?Q?MWv+KX0U8zr5ZbcvSgZkKMEBurv/oosow3Ks6qRHNZG8BIQFjmnfl9Gx4pdI?=
 =?us-ascii?Q?1WK6xc/L8DaxhtipjZAius3/F+0tfXBWPwF1EgWqD7ef5oCE2tMYtuymqIP+?=
 =?us-ascii?Q?cAXOe06MyR/lFjiOZhc8gCBaQ/EDUCFI8Vb/JjQFHKtJh/1H1jkmHPXrNUYE?=
 =?us-ascii?Q?wqa6v09St6cRH5ocvY03P5WHaqhLxOlmm3tkfRZfVjB7fbc+1hMcSDfGFGUh?=
 =?us-ascii?Q?EHM3LA8lUeG7mNdtA3OniibwrHSegAXpm6b01zOoDGIkJ5MVIZXCp3FhuWYw?=
 =?us-ascii?Q?/pRnnZBqWfiSl4yEjUbUDSklXlpxr83A9IEzVRO8oE5FND273KX9hXTuLRgu?=
 =?us-ascii?Q?bsi0XJlAEi1L1kMGkwSgcDItWDaeURmVmDdRld04JEVzzFFPQ/q4HcL0xKvX?=
 =?us-ascii?Q?whzOyKWA++5GdjMmW4vGqyi1Q3S+bNgsa5/KVfxb7kY9Rr9k7LTutk2xMigj?=
 =?us-ascii?Q?SYWgwsBYkT2vl4S+1oTE1umQb5jNnI6u+C2DqB5c+cuO/8tzP0ykG3C1zw/5?=
 =?us-ascii?Q?9/7Z5YWOLOefPgGgB8Ni9+W3TeDYnq3waVOLoVrl2lnZzXFQdm51pV3VEfcr?=
 =?us-ascii?Q?lxDTZXj+PoUEYp7KvnBhoFZ20Jgq3ro5aGZpYexeFmnu7BGagZCOrjUnLXQK?=
 =?us-ascii?Q?cMZqJjaC2m1f+ixTcePe7IHwMCMZmec2+lgFoq308cq88xxT4PS2jpTLp1bS?=
 =?us-ascii?Q?XurpLY7M60adAswS9YdGIOIJFShX6SDCZ9877FoP6R2SKDKh13blc5hrPZpa?=
 =?us-ascii?Q?g5+cqOLfQy3P2FXu5AY4tYcIUziJI14ZuSw083nufSQcj0LJi5mPrTH91nmB?=
 =?us-ascii?Q?mQhWNGDCkJ5okhujjMA0Uch54MnJ1JreHY1W1poATaMugDICeqcyBQYuHRZy?=
 =?us-ascii?Q?2ire+bSBx3yLFiPrxRPXSG8sjguEIYwpbLR7jxI/9HmbZqgy2apepqdEZf30?=
 =?us-ascii?Q?jSXW3P1zYYBxrj3qOxyrcC4mzOfXWwAeJ/0EXOkSx77avOM8eXMgXAlmp3Hr?=
 =?us-ascii?Q?SonrI2EFRJ+jB/BHJubUstUKLChoI6TXQov/geVlbKM7shBEOQXsF107HQ9m?=
 =?us-ascii?Q?rJVX3xGZHsfz8WAmU92BEsA3LlgeaMRfcw0F3eW0skGRkHuxSrHuszYO+VF9?=
 =?us-ascii?Q?jGcKKpq6p2abWugJxJBk1tppQs1MpsJ21lrXHg7a5aFQis+35lNmwnsN6g4O?=
 =?us-ascii?Q?aCkaUS0GsY02pPlKNA8HGqhgBEfqbuRGoUPF3Usb5LKaQZXTyszXcJu3b4Kg?=
 =?us-ascii?Q?wwNZJJlaEOjkKt+X2UJ7hDF1uEPtX3hvdv4AO7JGDu8BweVhVUB2xGpdjyiK?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: A9JLkWWFtM0HiMFu6NHwVnu9Z/1M0POKh2viPUV70hkNEMzH/saYeb2PTqbkRCIgVHMCkAvmBYCi9ALFRYAjmfzntkWfk3UW72CqxMsIzZmVSuFywTZUWD1Da3MgCwQEeP4GgGNsqpZwSdv94pyFjQUrrxcgZE1NyZd/UKJT1V909iNg/I2XxBHbeOkmoPnmgvxAkCGEf+sx8cvK8+hCMHKtvamjwIRKlGcOE450dGCzjkgcLhVVOve9mIOiXNlauObW7k6F9r//sas4kcEQ8DE2AcgF7tCWlUQLLj2gOE5o0ay7NwbLydKYCtvtBC5Q7a8KSv3QnyPFjFdBaMxr1AxJrFxt6Uh2TVp1mBmBMY7Y/WKlhG1exKUdUeGOLc3kNP5C4WLvBS600J+PUGZWYM8raB5KnIe3Vi53Xg95E+qGdEfzZYOgS0gXpuMpk6Pb5Xwx5McD4lYpkJ5HmHsPK+FSMamb4JVKuvzquyccWkv1C0F/ZxrEqIUGfCGhiOv5/n5F70o+458mliDlwg3tW/7ghKddpDaPLWS5tysRmAtQuumk9RkxkuNwH+9AFqqr3SG7nuMyPhUI4Ad5bEyb01pCiw1PIUleF3tN9p+2aHgKVrScir2jiW34CKp8qrqcc/Zmg4pZCe0H0gZV+Jm/KizH8USZ9/oPsR/2cCdBlF9EIogAycKh+rl9xMYSJkQm1ZTFOKSPaW73g8hP96bNvLJ0liIXBd/9/KIRVi/J+y8zEaaHqvdPYltAVSa0L01BMD7moESXtG25Wne+xIJlrA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b3a6b2-9a91-46d1-4b96-08dad24e75b6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:12:45.2209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmrI3v25s+1ayfU/gg7wJqXerRLsE4mvVAaF5m1kfMIqM7Lcr5gbhydHe8098sOB5TVEOiWJrbLRj+xNEqqzItiF534T4uQZ2F24sn+9quc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4259
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290124
X-Proofpoint-ORIG-GUID: 5qxz6junbGQu5P3IIpoyHmJz7p5DDv5h
X-Proofpoint-GUID: 5qxz6junbGQu5P3IIpoyHmJz7p5DDv5h
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  12 ++-
 fs/xfs/libxfs/xfs_attr.h       |   4 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   2 +
 fs/xfs/libxfs/xfs_log_format.h |   6 +-
 fs/xfs/xfs_attr_item.c         | 135 +++++++++++++++++++++++++++------
 fs/xfs/xfs_attr_item.h         |   1 +
 6 files changed, 133 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..b1dbed7655e8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -423,6 +423,12 @@ xfs_attr_complete_op(
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	if (do_replace) {
 		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+		if (args->new_namelen > 0) {
+			args->name = args->new_name;
+			args->namelen = args->new_namelen;
+			args->hashval = xfs_da_hashname(args->name,
+							args->namelen);
+		}
 		return replace_state;
 	}
 	return XFS_DAS_DONE;
@@ -922,9 +928,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
+		  XFS_ATTRI_OP_FLAGS_NVREPLACE;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..3e81f3f48560 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..a4b29827603f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	int		namelen;	/* length of string (maybe no NULL) */
+	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index f13e0809dc63..ae9c99762a24 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
+#define XLOG_REG_TYPE_ATTR_NNAME	31
+#define XLOG_REG_TYPE_MAX		31
 
 
 /*
@@ -957,6 +958,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -974,7 +976,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_nname_len;	/* attr new name length */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2788a6f2edcd..95e9ecbb4a67 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -75,6 +75,8 @@ static inline struct xfs_attri_log_nameval *
 xfs_attri_log_nameval_alloc(
 	const void			*name,
 	unsigned int			name_len,
+	const void			*nname,
+	unsigned int			nname_len,
 	const void			*value,
 	unsigned int			value_len)
 {
@@ -85,15 +87,25 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + nname_len + value_len);
 
 	nv->name.i_addr = nv + 1;
 	nv->name.i_len = name_len;
 	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
 	memcpy(nv->name.i_addr, name, name_len);
 
+	if (nname_len) {
+		nv->nname.i_addr = nv->name.i_addr + name_len;
+		nv->nname.i_len = nname_len;
+		memcpy(nv->nname.i_addr, nname, nname_len);
+	} else {
+		nv->nname.i_addr = NULL;
+		nv->nname.i_len = 0;
+	}
+	nv->nname.i_type = XLOG_REG_TYPE_ATTR_NNAME;
+
 	if (value_len) {
-		nv->value.i_addr = nv->name.i_addr + name_len;
+		nv->value.i_addr = nv->name.i_addr + nname_len + name_len;
 		nv->value.i_len = value_len;
 		memcpy(nv->value.i_addr, value, value_len);
 	} else {
@@ -147,11 +159,15 @@ xfs_attri_item_size(
 	*nbytes += sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(nv->name.i_len);
 
-	if (!nv->value.i_len)
-		return;
+	if (nv->nname.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->nname.i_len);
+	}
 
-	*nvecs += 1;
-	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	if (nv->value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	}
 }
 
 /*
@@ -181,6 +197,9 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->nname.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
@@ -188,6 +207,10 @@ xfs_attri_item_format(
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_from_iovec(lv, &vecp, &nv->name);
+
+	if (nv->nname.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->nname);
+
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
 }
@@ -374,6 +397,7 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -415,7 +439,8 @@ xfs_attr_create_intent(
 		 * deferred work state structure.
 		 */
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+				args->namelen, args->new_name,
+				args->new_namelen, args->value, args->valuelen);
 	}
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
@@ -503,7 +528,8 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
-	if (attrp->__pad != 0)
+	if (attrp->alfi_op_flags != XFS_ATTRI_OP_FLAGS_NVREPLACE &&
+	    attrp->alfi_nname_len != 0)
 		return false;
 
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
@@ -517,6 +543,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		break;
 	default:
 		return false;
@@ -526,9 +553,14 @@ xfs_attri_validate(
 		return false;
 
 	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
+	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
 	    (attrp->alfi_name_len == 0))
 		return false;
 
+	if (op == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    attrp->alfi_value_len != 0)
+		return false;
+
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
@@ -589,6 +621,8 @@ xfs_attri_item_recover(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->nname.i_addr;
+	args->new_namelen = nv->nname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
@@ -599,6 +633,7 @@ xfs_attri_item_recover(
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -688,6 +723,7 @@ xfs_attri_item_relog(
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -710,48 +746,102 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	const void			*attr_nname = NULL;
+	int				op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[i].i_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	attri_formatp = item->ri_buf[i].i_addr;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		if (item->ri_total != 4) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	i++;
 	/* Validate the attr name */
-	if (item->ri_buf[1].i_len !=
+	if (item->ri_buf[i].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	i++;
+	if (attri_formatp->alfi_nname_len) {
+		/* Validate the attr nname */
+		if (item->ri_buf[i].i_len !=
+		    xlog_calc_iovec_len(attri_formatp->alfi_nname_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+
+		attr_nname = item->ri_buf[i].i_addr;
+		if (!xfs_attr_namecheck(attr_nname,
+				attri_formatp->alfi_nname_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+		i++;
+	}
+
+
 	/* Validate the attr value, if present */
 	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					item->ri_buf[0].i_addr,
-					item->ri_buf[0].i_len);
+					attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
 	}
 
 	/*
@@ -760,7 +850,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
+			attri_formatp->alfi_name_len, attr_nname,
+			attri_formatp->alfi_nname_len, attr_value,
 			attri_formatp->alfi_value_len);
 
 	attrip = xfs_attri_init(mp, nv);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 3280a7930287..24d4968dd6cc 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,6 +13,7 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
+	struct xfs_log_iovec	nname;
 	struct xfs_log_iovec	value;
 	refcount_t		refcount;
 
-- 
2.25.1

