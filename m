Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ACC79950
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658295; cv=fail; b=rGC56vYeS2pArPV0hL5q3H6G3yzxWgznD7c4khlXMaWCkLh4Is3e4vD54rWRPfiDRzAZ8yHhpugjfNFyixRLwZqRJXahoa/985qpoU22+GeQsMycPWX7W1Fa5laprwynQKpS4e+E8vTacNEfFe+DTYUcmo+HtoI293P+rDKutJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658295; c=relaxed/simple;
	bh=aLjFHEdhfDp1snEEA6bJMvlFHVX2iUg1BibARViqJ0c=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S6S6wrMHRsF++Et7AJgjP3Y1Tm17NGpjdNeeSJ5xFUTGDeiAY+Mrv6Oj4yLfMEh0JoshMxAS6Qm4GJLOnpgz3wbX9crHLkTjCJSz8La+319/CkzXyaIC0ZXkTYFEo8M4U4oGTT3vdmBr2ZxFfkzRNo/6BAw5Zzkau1nwnjN429g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O5BkLkt/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JooBJUkt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O5BkLkt/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JooBJUkt"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxSTG025981
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=0KKVZ1caTeQqLNoRwTQXdwZybi+h6QhSESfBwIlbIfw=;
 b=O5BkLkt/af2m7dXjOL8FvZb1+lvUhc67uccE5VP2RIRSRKEmf7UuPcK0ijz/0TVHQpC2
 BnaHnCC9Xzg4w6WNBr8VmrJPT8CPFN90zCCEj1hDFuvSuHfdD6gevbvCwMUOuHO5GQBD
 L7xT8lwObgXPnRpNVDDAcyaURsET5bz8Hu/Fjc8sVa+MEoqnvzuiELuqbbNwDeul05Xv
 6h6w7zo0xGESdunPfhJOnRwI2tPsPhhOHq+6rczixTDF9s2Gkwgu8KBrM/DYKQdE3tIm
 1XWAUFAHsUdjPZObIb4wCQP5V295qnatL5QVPPjaDJUuivOIq1QUI55n5G8pjigshMd5 jA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrrcghm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UMtP9X014473
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr98011v-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YobGAv1kwCqVp8iw5wpdAQvqWJZFR65HY5lhKeEYcVFhkJPdrrHYhs8HW3oy5EBXtdJ9MpWiTrfOrvoKL4QL1RyzNjVJ0nUK/brlzk3fyeaC4T2FcQOgIsQT2dq2vJBRhTnjVHyq4j+8VubAlSNwvTrkEC6KgFxuXwjr0BxWotRk7L+9hLp8yoW/i3AdUg5v2c25u/kI11+JWvY4JVZP6oSIKRNoX9bfOW2vjp1LS1Vhx4OV7KL/dyzv9E7jFYUz2J2D+nqtyfOxZgdS6A8YUTz4bIQyk69JQhsDyfHDnwcoJM4F1E+hToeHgFd4sM0CQwmbqi4y9jrdjqcIJXuYTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KKVZ1caTeQqLNoRwTQXdwZybi+h6QhSESfBwIlbIfw=;
 b=YXq2ZUW1XpDCbx+7bAq4TEW+xI3WZaRNYmtL4v3uc+YqyTUw5uNgzX9dwCxjHkB1Rw4sA9Suf9kWc2Hm3+tU17wm+kV5r0T0zXMN+kfkL5s2g52IUgkGm3SB/vPp3sXzUkc1SXXi+87tXHnuFpz05YwPVVQSLyaC7FhupKcqjCtEMiWd8/nmesqDLK5oPA3lPSLG9MVvS4LhfnFymQvr8WIl/y5idsi6mhzfmsxBuyH1yF74u9xYKGbPhPpJqH1ctA9OjINI18NjdVzivNG98oRlktud0sMbmGu53o108rPW6/gREsYlAqaIB8Xz+bXny4rIR5Du6UNb/plBX+8CpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KKVZ1caTeQqLNoRwTQXdwZybi+h6QhSESfBwIlbIfw=;
 b=JooBJUkthr0tokASB7zJjDxuFaPMlXdC47mC8IKUUxHAEKAmGxwiOMTRQ0lsGlIm9vTEQiiPYrwTTE5q+aoaI9nVYbK5/zjc+T9udo7guzUijDDWB+dTMMm8iv7N6KckO8HD4XR2771mm73araIHcMrItvWGARLs85TsCVXGCdc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BL3PR10MB6092.namprd10.prod.outlook.com (2603:10b6:208:3b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 23:44:50 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:50 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 14/21] xfs: fix internal error from AGFL exhaustion
Date: Tue, 30 Jan 2024 15:44:12 -0800
Message-Id: <20240130234419.45896-15-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:a03:331::15) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BL3PR10MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c435a35-40a8-4f39-7971-08dc21ed7319
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	PFW4wEWdGAsK+2iMKpoj9K+NReZ7Ih/fpOPuOqHn09jyPV01nEpZHcPjDPE1WXunFpRmKcfmaVT8hN1nbWl8KR33MLI0eB+s4N2XIR2UbVDhKB3xbnLvDWbGoNSgej2FD9md3bCOeWpwDYctIhJgjDbtajgVFlve8mixVFTpDiW9MW7rZER6qz9KxlQ/eTMF0W6et1xbBSPrLHd4U1vrCz66vEGYPlNqxBUYn3HpYn6cwywXwY/OrYd89TjeWziXXHTwYFlVRHsn5igGtUIr47G9Pvf4/feBL/cBCKujktwKPH8lbzx6u39NMRK3Nwukl/k6CDZkhVC3wLHHOMtCpTQgDbBVX4htrHrBfBBKDvBcmeGNnJ8BDMwn9+s/SGBNwwthvYuDCZgiCHlYwXwtNsC7WfHOnCmfPQ//oC+zpm9CACJPfoqMDMQR7P7b8PjvShcD0uRkPx2PTXNrSUA0BIIPwHXWdY+5R6hrJJ+ElIyXYGV4462NPLYGUyWcnt2gA2dvjzqrvTav39tNLtl5lcVBTowz8+qwaiqF9B2JAJVPBXPtASvQgkd51vNuPv47
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(41300700001)(8936002)(36756003)(86362001)(66476007)(38100700002)(478600001)(2616005)(83380400001)(1076003)(6512007)(66556008)(66946007)(6486002)(316002)(6916009)(6666004)(6506007)(8676002)(5660300002)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?JUhWH9JsdTpuWt2bf3Az1a5JMv6zga909wdhskIO/t0XYi00O+KNX71SnP7D?=
 =?us-ascii?Q?xB7VdxIKYRdpbQZXqN56L5A3e8qHo2PNeAPJNvQxdDEmDptn+88V7iBLHqxS?=
 =?us-ascii?Q?wmhsv674XP4kDRUNSCy/onwqWem3u/Q5FDDGgZt9DfMZU+8SQgJL5ArPIps2?=
 =?us-ascii?Q?bBuy8oS+oC+ExwShNSPLyxKPmRWyVMpG4qW6xqtr7kfD5GFn3S/ecAU00KD7?=
 =?us-ascii?Q?XEDrvn3MJVWkYrXNnS6BoM/i8jqL/nVdQBnsMBVZCkRS9396rVtUolSrNosf?=
 =?us-ascii?Q?ubFWGx8xXVE1x+zrJOycApnXwU9jjjsa4QttTPCZjdp5DA2w/gr/OAwG+UMW?=
 =?us-ascii?Q?BtxkBab6ZXv8Ojx+/t4+IFkIMHiA/V5m7/AAoY9Xjv3CdX9xskgs7yxr4C8E?=
 =?us-ascii?Q?iN3fmxvqJgDaKFyP2dIShHDoqjO0a+RknFPj4ESk4DlkZhd+VrLQtdtiCIZm?=
 =?us-ascii?Q?SiLENHmKvGrxp9ls50CxgRe/uxRBdon23baAxTRUztJQzIbA3YPGUiBOy532?=
 =?us-ascii?Q?F8tiIjW1+mMQjQoMBsg3NLyvj/RiqhBcUMHUkIrGP7y+emWuDbJsVAHt8of9?=
 =?us-ascii?Q?3RwS3IZ+GlUdXV85D10Qp7O12lTOIZz5r2HKwXqaN4ABzyl4dNeWcclQQ++b?=
 =?us-ascii?Q?Gt7xjBXCGiLXiO7+djE9C2mIodIoc/ssvbNn4PxvdeqA5e4c/FsrwkFaJUzS?=
 =?us-ascii?Q?oaVNljcRH/4w4wXOagiv6x1fLSn8+FvMUH9hP84DqQedY4mAxpS4pE+SZXUJ?=
 =?us-ascii?Q?popAHkiUnPOrFXiI1t3vlbf8utqs50N7/6LfxYFX0BX+rQ7lfsWnkyndM9al?=
 =?us-ascii?Q?+MbtFclhu9azpcPguw/DEVOsrevyW7+h6Wxgj8EfQV5Lp1m8nzorZBDOJL/E?=
 =?us-ascii?Q?z2dpdYercCQTLDc3RPnn/dYO1Cc45/jUO9B1NfRs9x01aaJwWP/54WehfHS7?=
 =?us-ascii?Q?Tiv3rqndLNTnSngIwxOtor8bzkuSCzaXDB65xeJR3qsicR+GkY1EPxZb8VxM?=
 =?us-ascii?Q?O/GK/C3bka3UwGqoIAUvmlNDQUYOhIcnZpi9qpKqCLKnm1jx5IpC2D+LS8rJ?=
 =?us-ascii?Q?fU0FB+ysAr1u5nW5dd9vaJ+XYY9XiHpGIZAEZCkU4l4a90fJ04X7Bth6EmeX?=
 =?us-ascii?Q?6tE9zjX18Ngog5TSowiIG1C7OUGuGbqaw3LFSuVX6FdNMl32i/mkOQ45eUKO?=
 =?us-ascii?Q?4chz2kN5Bry0SDbZzwyUuPBe/8bx4YFZM/1nSKs0gT3dZkwKJsmdzR70X+Jo?=
 =?us-ascii?Q?SW7CyJUQ9nCdZ888xVckEdxa8vIgVY+xmwZX3Owg6sVTR8+Xo0vKyhm4ydfI?=
 =?us-ascii?Q?M0FENpOxBbnu+4+72aH5/UhfleK4NXRfKgU7ARu2BkqC7o+9b7TPoKS88Nf7?=
 =?us-ascii?Q?zerIQpOgXxhbPnPIhPLP6IYEK6XoVYePYbZ96gDAkS8VsVUjumBaIRjKeZRo?=
 =?us-ascii?Q?bEJ9LITGIYb920VrTr1YhhNVSXOToFlwXDkHJFQWoLPR82dSfBrxEicrn5/k?=
 =?us-ascii?Q?PML3P35hZuWvQZrh4FnWN+MP7hPThMLBXA+B0aiQu6MUrrUYr/F2y9cbCwdt?=
 =?us-ascii?Q?QCiXe43LNqWubWay1An0bJNziHjsKBN4cBZOYtO3ETgQ42iRpQ/hfUKVEwPq?=
 =?us-ascii?Q?botY7sm8flw+zSo3aLy1JhUvc+NQuneXDtrePEuD5PiwLFAbdxNa7Mo2tq5/?=
 =?us-ascii?Q?iq02jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	y3i+e0ZbMIW2teizDIi5PhQrMQnGQxTLLIPFsIY5L9TetBN+xLCCTFx+UUuQByFloIDc41zJwBQNGCeNlxoKpGqMab8mf9D0V8/X9ZlcVeNMROtFKMQq0GNPwEvyyX3sIEe/7v9B+4Kx0+lUp8IZnk0K+f7T0L5bCiL1YBr5ntR8+Mie8+NNpIcX6n9uhKMEoeev+mGgEt+VvJLChWp72R4ET1NoPFD1h3XmBqGgASEKLldVzM2qYSHhYEjjpLjfBy9SMl4chRf8V691sa97QuRJDNXAoC4ui79Q8hJCFZRemOGuQupqQxQgbm/cfAdHW5KPbng0ISGtLGke1sHfpgYkufbf6zawZUz7rbn5prtFBUVFSE8vgRbT80/3oKDKoOZmVF4apIgO2ejyjsqL7WRuBIyEzpqoqGPATpsEAQNJtpQ2gvD4Zdtt7QIZRHTjcQbRPe21xrj05ujDnc2BdkPESBQ0g6WQ/RoN8/shodZkYabLnJFovGP6cAy9Rv0j38/+lMVeN+mvy75El1BwaeuBfB+dkE1hZFIwuUH0MV2GAPqYRDiO5pO6cM7rMgPjpf/jtDNqf8oOrTIQhPjNNNhD8i1tjlwXyIy1SZzJHlQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c435a35-40a8-4f39-7971-08dc21ed7319
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:50.3397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyEVgyiL/HZjUWnjEaBRRsPrrXBlF0qUxbo8+qyhGyyYFO+6T+2T8Q/ohHsqL6whv3Nsap+KZMJoifmXYAPQFA40FERoRCqlpF56b4FrUrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: _JbcxZK0cXxndlFUI9Ymetg1eIEpFAPw
X-Proofpoint-GUID: _JbcxZK0cXxndlFUI9Ymetg1eIEpFAPw

From: Omar Sandoval <osandov@fb.com>

commit f63a5b3769ad7659da4c0420751d78958ab97675 upstream.

We've been seeing XFS errors like the following:

XFS: Internal error i != 1 at line 3526 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x1ec/0x280
...
Call Trace:
 xfs_corruption_error+0x94/0xa0
 xfs_btree_insert+0x221/0x280
 xfs_alloc_fixup_trees+0x104/0x3e0
 xfs_alloc_ag_vextent_size+0x667/0x820
 xfs_alloc_fix_freelist+0x5d9/0x750
 xfs_free_extent_fix_freelist+0x65/0xa0
 __xfs_free_extent+0x57/0x180
...

This is the XFS_IS_CORRUPT() check in xfs_btree_insert() when
xfs_btree_insrec() fails.

After converting this into a panic and dissecting the core dump, I found
that xfs_btree_insrec() is failing because it's trying to split a leaf
node in the cntbt when the AG free list is empty. In particular, it's
failing to get a block from the AGFL _while trying to refill the AGFL_.

If a single operation splits every level of the bnobt and the cntbt (and
the rmapbt if it is enabled) at once, the free list will be empty. Then,
when the next operation tries to refill the free list, it allocates
space. If the allocation does not use a full extent, it will need to
insert records for the remaining space in the bnobt and cntbt. And if
those new records go in full leaves, the leaves (and potentially more
nodes up to the old root) need to be split.

Fix it by accounting for the additional splits that may be required to
refill the free list in the calculation for the minimum free list size.

P.S. As far as I can tell, this bug has existed for a long time -- maybe
back to xfs-history commit afdf80ae7405 ("Add XFS_AG_MAXLEVELS macros
...") in April 1994! It requires a very unlucky sequence of events, and
in fact we didn't hit it until a particular sparse mmap workload updated
from 5.12 to 5.19. But this bug existed in 5.12, so it must've been
exposed by some other change in allocation or writeback patterns. It's
also much less likely to be hit with the rmapbt enabled, since that
increases the minimum free list size and is unlikely to split at the
same time as the bnobt and cntbt.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3069194527dd..100ab5931b31 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2275,16 +2275,37 @@ xfs_alloc_min_freelist(
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
 
+	/*
+	 * For a btree shorter than the maximum height, the worst case is that
+	 * every level gets split and a new level is added, then while inserting
+	 * another entry to refill the AGFL, every level under the old root gets
+	 * split again. This is:
+	 *
+	 *   (full height split reservation) + (AGFL refill split height)
+	 * = (current height + 1) + (current height - 1)
+	 * = (new height) + (new height - 2)
+	 * = 2 * new height - 2
+	 *
+	 * For a btree of maximum height, the worst case is that every level
+	 * under the root gets split, then while inserting another entry to
+	 * refill the AGFL, every level under the root gets split again. This is
+	 * also:
+	 *
+	 *   2 * (current height - 1)
+	 * = 2 * (new height - 1)
+	 * = 2 * new height - 2
+	 */
+
 	/* space needed by-bno freespace btree */
 	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
-				       mp->m_alloc_maxlevels);
+				       mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed by-size freespace btree */
 	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
-				       mp->m_alloc_maxlevels);
+				       mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed reverse mapping used space btree */
 	if (xfs_has_rmapbt(mp))
 		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
-						mp->m_rmap_maxlevels);
+						mp->m_rmap_maxlevels) * 2 - 2;
 
 	return min_free;
 }
-- 
2.39.3

