Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC083C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbiK2VOB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237077AbiK2VNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2975C2613F
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:19 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIhcnN012293
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=J5FdZj4Biz1xWcNTbTdtiWr2UYLY4UHblpzP6WHyIRk=;
 b=TcxISOP3qR6IjI8s/3MWk5L3DolceZtI+/XRBoPSB1CJ/SMEFOMFpOQ5Y9KllA2YKJ0+
 uFt62YmD3umZG8vxaZcXhyHttRwAM0j+a9bnXhpPUFqF4hzDs8b2L43IEDLzauEzr6AJ
 NV75+0VWaGEklTpSbmoSK6ekdWHY3H7MZTEulabLeA96dWsgh5fuU0St4zF0yejf63cb
 5p7/lx0INCqq8vKXJjco6yhHO0L2lQjzBEaaa9EgJGjNkNqkKtne41EljDU7Va1D7HQC
 DrrKh/HkrMHQuP83RwTm73Sz3rt9E0k9JdLgOTsV4HhErxN9x4YNky58sYyqnj/E7WNA fg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m4aemeewr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKUnBY027897
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m4a2hj1g8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFgZOHOlFIn0nHBL0DvjQdCLZLvdllhwnWhiStrlXIYNVALjtiqgHEMhPUsrRJJlnFpwqVa0IYZK0msXP/Ykg/yeD3AYdLZEbWbo9SjLLtIAqoBqnpw3oQumKr+Chh1/VL7eXUXchINHpBqyWlGaf8v9JrHGvWRK8bFYs25rGY9RmKlaBi/qzvOMZs2h7leHIBOkft63zDApAskINGsx8COjTrz0WXUAh/z0w0ouSuswfki5JfAtya4CPKoiScQ5SAHiRjXCT2NC2fBUU6fm1wDM7gGnpiBAS38cajdnzrJjBHaf3BsqP2xr2kaVccj3HNW+D89yA8EUHeNwpbJzaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5FdZj4Biz1xWcNTbTdtiWr2UYLY4UHblpzP6WHyIRk=;
 b=iokdczK21ZmPWlJaBGmL2sv46CnfvV7IFIQbBQVc2nhhJQ9Ml9bJi+wHuY4CdZ4FJAdyIms92Yw4I4d7iRECUKWNW3zsmZsFkQ44H1ka1oHnbNPZgIxtSw6s6LWD8TOEN/LGnJhtZAzYM9ok3IncftQ435kZdI73f6OAu6XoMrbpa/t07R9eehHsP0ZUtcSEBjciDpiubEi4y+oq/1I8CBCTnoGTI01QHuV4r36u+AQgr62C1gFirAD8WnbRTraffVhmwWlqwM38iu+Sn7un42SiUYssbTAp5kEaHp9JJnOfTBnnGwMRXTTeY6YQw8xjdgKG1NpxnoDnPKCk0ekv0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5FdZj4Biz1xWcNTbTdtiWr2UYLY4UHblpzP6WHyIRk=;
 b=PKJoTRpktnq+X8R3DN9ItiSA1myUMQDCIKX/7aoDCywvZDW0Zj0BL54pUJG2j5gUCEcBFMzQsfHQOJWfExS86K5MDjmoi7451W5cJuRYt/iszG6+T4V7m57BbDb1FsGHhFbPKjFC5y2H+RtN5XE7QPl5sFAaUy/biirtF2KTsUw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:13:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:10 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 16/27] xfs: add parent attributes to link
Date:   Tue, 29 Nov 2022 14:12:31 -0700
Message-Id: <20221129211242.2689855-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0167.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: c4fcca8b-fd21-4524-d0e0-08dad24e849f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LKDC8wznvq9Dlbl27GNVqov6tbEo6YstleTVbhzRvnTp0gUh5NmA73t5ZjaawV7zM4iPK3sx82RsH+sth0BvthSDlbpfkh6QeCAIa4VXqaMFMrX/DrCSyiI/8/7C+wFZNt6+5xNfqZKb9t5cV94TlMrtVV0asHFh1hK6Ry5Q6pAogB8fFkwaINSxWhYSeiotelD+CYOk6yQNapVeAn7YNRdeiq6VUwAGi1AR0I480NLinniBM6Vup8j9WElzmQarqm91LQGgSM4GUaxoZ7Du7bmktR7r10Yh7Hp1t3RuiLcf1QL0LPes/xdTNuIAD/cPz4CA8nSR9PZ4k/aZ07Vq0KnQAhFcUhK1Vc2YPueB+pq3S5ecvz+8n7piWs8DLw3mpihWqDfiuJ/Ybe1ovqMgXc/SuOrBlKxfRelXhvwf4xhRH1q4RZMJTWQg0szAFwQ2ZZ58XeHH1LQtc+3mzGsWt6YXCkH2KSQ9Y+YjL5OmE1OzljEdjzHSsC49bNb0BTd0nItWHBHwu9y+Zni5gYq9BKxD9CMLvNFL2GH75JVVQRHxonFXgp8ZPX5p6qikpEAAdSGMSr0lGQ6r/J/txncEF//Z/JC5FlJbMmBIxyY8Qjn1G+MWv4s7WJfN1BBZvUH/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(8676002)(2906002)(36756003)(86362001)(66556008)(5660300002)(41300700001)(8936002)(6506007)(66476007)(6666004)(83380400001)(6512007)(26005)(1076003)(9686003)(186003)(2616005)(316002)(6916009)(66946007)(6486002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ikBOIwgRbR5gZy4xGpLK2FlO/ifSZUUcBSrTczi05G4FcExcf7NGm5q3Q2aW?=
 =?us-ascii?Q?c3sxgU5scattfmtA9riDbCvA1dFWmRomSWECXgqawFE7oQGHPCp7GSubl3AU?=
 =?us-ascii?Q?qLVnHwsoCuxv58jL0PH7DsRLWrh+xn9twNeYnagwvOoxOiZq3okOBxPMhgAY?=
 =?us-ascii?Q?WMg9d36LbaMERA3bj0O3Qk0Jyo51uvp5FKUlRu1Un4q/ks8/aAsCd2QqnN6p?=
 =?us-ascii?Q?0Lljc3UJQZ0dt5QAGSXz65z11CAaaXdilqF3H//VoeZk5fFsouWoz5ZVHDS9?=
 =?us-ascii?Q?dNKnJA67o1bqrNEcN45F5gqItstmiVlktwLxmDzEP+qsSLnJIhKCzQ38ig0U?=
 =?us-ascii?Q?NJuV9nDD4e9fSPAPUkkZAVIQ6TMBtqin+SGJWYLa9089/4E6TXRhKU8isQbq?=
 =?us-ascii?Q?S3WywMuKRQi8LgilAia81vWQee/cWBBJIjX/iz/Q197nBZ0FU/aLgWV0vIn2?=
 =?us-ascii?Q?FzodX3eSLbac+Ce47U7BDBCgF4pCK8Am5pDUPzsnpdmvaUIXKq47tNz/D5Cj?=
 =?us-ascii?Q?tlhkFLZwQYJWt02IJNvLCzwp9aEU+UxR/egH3uoUFAwMr3VIqXrV5XePtcpT?=
 =?us-ascii?Q?l1dHLxzHeHoUjfiUsswnZfY+JRBMAbA3rYr0txEENrlsiuphRD27Fb75YSOk?=
 =?us-ascii?Q?KQ+IC8TybNY2zmVRZvidNkwPy8wuZ5Q/f+paAs0ZGGsPRVsQp7YvipAqC0Yn?=
 =?us-ascii?Q?Idi4iUFQ+RTTRxaRRI5K2uHRmM78lulvoljF8B4vFg/K25MbGS1ajqPZLRZ1?=
 =?us-ascii?Q?ZO3Vyo8hPbuI8O+kbYay9xh0vNsFxSjwB+ZzAjHjQvA92uTiy5/WhbBCnLEe?=
 =?us-ascii?Q?yLLN9b9oFA6OkFmvgyKy32YaadzITk31rHihdnOAtFgbK/j+f04BkRXqT84W?=
 =?us-ascii?Q?m4usxEuNv15cB/ijKIici9YipDpgmC8d6WthJxLWbLgp4+iU6B3gVz2Bs3SO?=
 =?us-ascii?Q?kjFbt/kQg49ie6cnGc2RwWPaoWM+/xAs6HuRQEbfHb0RrZjnFo+au3xXmeCq?=
 =?us-ascii?Q?tc2wOs2ZbjJvPorlyF7YyUlg4lOf6fBdKWGXKaEy6ozh1UcY3wfCPUf+AH++?=
 =?us-ascii?Q?gN7n0kvQNIMPoJkwFMJW1NwVNJ2lL0AxRSyg25AqltMv2GQTY9SaJN78KFZ5?=
 =?us-ascii?Q?Y+lyxdbXgS74U/MyRVCd0kMD01N1y5ipQC6yCKlDCRomS1LiQ772hkhr8bCK?=
 =?us-ascii?Q?f3wzGI+BDSx34PuiSAIKIo3sBpi+XFurKwUIbOAKmawod9mdlqLpr888Mn3z?=
 =?us-ascii?Q?HB4JPHiAJcAvRJsGLk2RpM/mQY9d5bSENnOzxJwh6qsz/fpErp3xDsSRzOql?=
 =?us-ascii?Q?tZzMFhPFzTMf/i285Uoi9ToIAuM5XZv9JyUJC037a2Dq2PkqfERse9MH921S?=
 =?us-ascii?Q?p9PKBV5ie7PSc69J8hyj6Qdr/XZAFYj6pbpGIU0xfzufGrm4AEBpCgMfVDCK?=
 =?us-ascii?Q?GyytM9fNBeTrFl8N7TSX8ljMbyg4momERiDPRWtcKlM4BaKMQOELtCApUK7H?=
 =?us-ascii?Q?WMTH7xAHoXNF3CnTswfM8bLr+miv3wX5ynBsoBV3X/USGNWRntX/V+CAr4HT?=
 =?us-ascii?Q?u/0f/+aSPbaZwctsvR6EnQ/nz8GYNI9qo1JoedrdGGBRvLWN34x0QHqzQmdh?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KZee2ELBt9ppkowQkzHCli01qIxx8rBhzErmVXd4sDGVmYHFNcEey+pzY+ChFVsKOrz+Ca829QhICoNW2GH/HetuKb4JAANw6nSBdyHCuN1youZh9JCO17Mu5M3sXMBrGIHtZwVR8lhQhpFIZo/KaJN0ccE58spli6KxDr3BCeaeYqtzBnS7BHvohR3+PmkgUh9PR4SN3p/uO6N6N1RZxhpFDxr+pCpUOocomUkGsMYR4kqXd+w1jS8OXBPsgAGaKlVXrraMLRELNgq4k3UdGmgb2DHgbXYYWnMm43l6SswyDT+Q/G2O4YxHZ/UH/YkTCJu/p00KnYbBW6FEujc03aRB2vKTbS+fRAvD4NXbmvbxbTXjIVub5yc0JEDfmf1eh4QG1VHAZFjDcsz12IiYQGXQRQVqytc+rqAvCwEwIxgwWsYWaQucqRngwr592Dj1b1GkMoZrYL0UhuB51pGm+Q29Ju9zzwtDLmiRsxPdbhfggT6rUlfQqS9ZsENHuyinusL9dqWkCb83M24WvnUrVb057xuXzqDPbp9EKhBqIltdZFEGpj7fyZZ3aqfwGiv0o2BRZvZMRW1fXy04R66DwbusyR9JAU+hZgmGDi/hAdWCzzSqOjlViyUrV5nNZ/HmWMkzuLCCzR6Z/dcCLo2RFzmnlQ8EoNykTcR05QOyh5q7Nqey0mRZfyOcRbfsH59wiRRMWqTRfQj8ovWKS8GaNyfik6XiTEQL1vr7bNV/5diULy7YclWWQSC1uhRuQToFgeInYdtbkW0QmXCHCDCNrw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4fcca8b-fd21-4524-d0e0-08dad24e849f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:10.1788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4lioAuJrNHW9YjiIgAutdMkMl5yQCNpibqHLoluiUxLyVqFYn8VwhNFnEU5ypOcfcddnoeNgPKBjZ5uj3WxWiSZYLdBOU18PzKFh6nMaWqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: v3JDI3rgD7NDFWxqC-khOjXu5n_ls0AW
X-Proofpoint-GUID: v3JDI3rgD7NDFWxqC-khOjXu5n_ls0AW
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
index 27b9b2a3d8ff..86930ee335ff 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1248,16 +1248,32 @@ xfs_create_tmpfile(
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
 
@@ -1274,11 +1290,17 @@ xfs_link(
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
@@ -1311,7 +1333,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks, NULL);
+				   resblks, &diroffset);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -1319,6 +1341,19 @@ xfs_link(
 
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
@@ -1336,6 +1371,9 @@ xfs_link(
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

