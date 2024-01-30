Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ACC762D6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658281; cv=fail; b=NEHJwhNwf9Jy64xe0mtqDOXSOyVwr6uoqJjDU1ExPBP+S2hXRM0MG8YiG7zEFeNSPmd8h6LdRxd5FPeQpje7nTiZZKocZJUqR5bvPI7JVCCyLfN5K8sCY8shfQTALuDqC7At6OErCfknuE4A2zaomLEVEmo6iS0Uo3fnk7xCz0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658281; c=relaxed/simple;
	bh=eewdmrWtAg5TmPJgfEXbBidlK+HhDAzwFomIK7rVKtY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qlLsl/RdmMJhA0UbR8oypKPWw8pQD7ncir8dLc6evw+UL1+KNJhA4Q0jlnQWzTppxbgdqB2IzfRguqCFAQ4J3P1JC5xnntYsc+jpvaHCWJJcsMhBx4dGo39jrXSrPWUd0zgMdDWexPzAmwCVPz8KZ3HCngze2tTCUJBesyayDFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PKQhzY90; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IcEC39cb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PKQhzY90";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IcEC39cb"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxP9f023766
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=uv9qbbhytKoXIro/SeVixN45gQ8NSEid7dbusNjE0lA=;
 b=PKQhzY903z/M/4zaQ5cCvyvNgKAQmh520KRzAa3OHQ3U5GWcfGSjBNh8N6G80j4pSKiy
 Tr/4MA4Tgr/mHuAdUjErHN4M+tB8vNmW0QkjksNlJWmLTBNN8Adgz9dbzYustZM8zoQA
 0w60mfWIraIexfT698AYDZ3lRcG5QVKm3+vueBOJJC52KAIfs46AI2r79tkzXQ3T6UpG
 X2m8EaJqrGRNDXE8uaOoTd86VPjfP7PsqXR+4gcS9Y6PyyqjLyJ0w2i5ZDKTHHPz2YQQ
 5D4t5XcIgu5Iv8iG03Bn9F1mR+Y/G+id7NhSqbNAaGwlMEGsQt4qZzF+vT2reUoUwY05 bg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvre2gjjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UM7lKi014564
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:39 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9800uu-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WY47AEN7Oqiyf+3KfWbS6KxFvQktD6lS3orPdJmqYyzVOfUkHKCcpsiG0UfFdYszzbg3uaQNamuo1VBafO0nWbXOWJVR/UvG7lnBMeEQPXqgkuxcV3ocSBy6GzZZcjwlHSpsERrlOzKn0Rbw3hxZFuCGbFKmV1+EF4MPd5LqNK2KeYr/l3nIvoBZ/b1CdG3ny4FLImmjmvFfJ8u21dARVHKXwJZXrpH4YGydIru4ZNujhYS008VBEz/amRVpAZNE2+xz001XkTSkanDR5RlAguMaFNlAZvC6X0+5lnK7f43zGjPi1q4jfGkNdM1L0ED8tIGzngsKeFm8LuCQqNcAJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uv9qbbhytKoXIro/SeVixN45gQ8NSEid7dbusNjE0lA=;
 b=MLIwk7AZ3vBoiTSmRWU2LUODntN8cXW492AxNH7WqvtYoffbI23THsnxT6zoJICUTHIn9Aozedt3xzJGJQBzUEAfjrHWdnhcx3GWxntBaa0k9QoKFRm2Otdg0Ska+S324mLXmaScIBQvPpf8fJEzztO4jWpPf/Rgh4dO1uxp98CI4S74KyaC0jgx/E0QvGV5B8KNRN8r0NgkyY621LratZ2O6mUC88W6uxSLQmV8cTQGnLUYteF2Gmex4qL9bZzoUFmxM5CdDdZQCpmGTSZKZF+ZB0NbxOd1s969Wah7lyF9wdDTIaqm0SI1SrbgpvOM59oMltzfTxWt40VfWd2GwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uv9qbbhytKoXIro/SeVixN45gQ8NSEid7dbusNjE0lA=;
 b=IcEC39cbimKl2xqVbS/H7w5saAgCUOrnRoWodRzFCFMwbk1n9KyR14k52M7NVnrdh3XNWnh7TuAqAlqALQwcpGWeNQTdOFT2R1CkvQpMwit3403y8o/QL0RhHSckCaLJNVhdaVy/g7Uuh4QpgPI3LCDZI04i9yaC/D6+gpm1xx4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:36 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:36 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 07/21] xfs: introduce protection for drop nlink
Date: Tue, 30 Jan 2024 15:44:05 -0800
Message-Id: <20240130234419.45896-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0236.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d03c5db-8745-421d-d5d6-08dc21ed6afd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	1IqYsJN2g5PNOznDr2E1bxbCvYTgE9hQdTN6SXRAbtTARHEAR9QQPMjsgHAC2OxSZflM5W/FdJs3uXvaVNg+zNKi1JztxtdvLoQXKOic68Yk7zoBrmJzdWivnp9wHuCkmpj3GO0YTETdqSeVIOI9JCsM1c9B/GC0mgzDlTAw50PI9jynqKXAf9Q+H/EgbDPbWrGFwO4nGFu6cOaXNpqsMvPfaK2TtHaSzVi2BYMpjZI0Fa3jVNSsLdx28K4HSY1PbdoWL0+EIQuvhDVcs3ET3LVT2aYvAdGEmLravlujgS8FZsYx+scU2JE1nkLXAnHNJJQBc4DcahUTi6Nzml0SrpQkpF6TizUgWMWnpN/4WAkO8zLWvgFwk3XOCuvZCV5e+RDVaUGHnmPv2NXc1QzU2ukjnCzsrqkIm/edx1uxgpnclWyF2kBv6Z0pf32qc8/o4iSj5DTNAN82zEmTCVRHyjfnGk/gKu90SuHYtGJyCIdDVchgqDCqUgZMrkt0AdFjGGKOOG6QOmr39yipKc9CLAtp5u6sXthrwIy49IIoZmii9oiuE2my2+83/oyQ+98r
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(4744005)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?MuW8Xlj8osigl4Nd83xXiSetYrrYKqIxQhHvPsd1KJWn19LqkVBC6JzNFl9D?=
 =?us-ascii?Q?HU/B0EAST6rYe/n+yy7x7JxAHzQ6QztUNkxXZRNqldyM7wS/uVKQRPqZalPz?=
 =?us-ascii?Q?RDy0qIPVMTH9UssfiZvitveSB5GQPfnoY9mvmUKJdq7lu8NPuCZFZxLUNpBw?=
 =?us-ascii?Q?OyT7+WahZp3s8uTA88vAV89eejBOMX+2SZNwTCB4CyrUDfrNSh7HquErwbCJ?=
 =?us-ascii?Q?JW3XWgt19CVKvVbaN5ZkGOR7HwOoI/53etsF69rmYDcWDvoT7VVz4i1gJ24n?=
 =?us-ascii?Q?sMZKCxZvRuzwjeTCGc3Cg+tXy2NS8WcnmY3fVtC5NXp+Nsvkt9Oof945O3Ba?=
 =?us-ascii?Q?UobQKcgxfaUlwQdEJhx4PqyBlFxWrWZPjY8INEiuJzIYAvEsv8b6gInxlDcR?=
 =?us-ascii?Q?DeiRx2Ej1uFAIzLTM0p2f/QrIOvwle0EeDgr2RUV7mUw7MmoR3udxyBnuRRU?=
 =?us-ascii?Q?vrokBVoZBWalPgO2xmhMLb6HHDr0/6AFdjHsUk9Kx66rra9CM7QAqwqTNfTH?=
 =?us-ascii?Q?tlaoIe82WRJXT8AiYHVOw5UIcLVHcFbfAACDqyE7hdHnwaibnFwz9WP8j+e9?=
 =?us-ascii?Q?P2j0jK+wyxNctZKiHxll9too8h/xCrIodFRoW4gQyRhSfhrXZN05pb0jUzVF?=
 =?us-ascii?Q?YLuJArlayDJzQS4gzr32sQGkYAzVXgFobzQVYLXovF03nX/SPkIF3ddMSmZ4?=
 =?us-ascii?Q?pVFx6F0Y1po9YhW1YWnXvxk/bGXHQtDCjZ673RWNVAtZD9XfYMIoyXGNH40n?=
 =?us-ascii?Q?7CyHS/HNKCD2zqk29h1e7R70t+/EuVPK0wAXJE39fFVz90s8S4/iI9zMLdXq?=
 =?us-ascii?Q?nEFUi9JbJ8LjNwwHK61bkVT13xWDs++ncKCZve5ug4HqST2Crq7r1fk1611s?=
 =?us-ascii?Q?KJybdgAiC8SAHdEebtuz41NwlhOxWqKZGObnpCVBZv1EQOS4PVqKuv9rp0/k?=
 =?us-ascii?Q?7Cqt4PKIr62P6+/y9Rhr9cSqEqXN921aPdsCQakMpKYTrhCQQCZE1iUgHYsd?=
 =?us-ascii?Q?2n3TGbEbOW4pSrSpuqQwf5f0xr9XOknMjmx9zFP4nOAMdtwxNDgVEep1m4/U?=
 =?us-ascii?Q?XB4p++wScWWXQ/iLOpXYn705hhQcSkKOCk5KVNybraLfZAl3Dj9/BhoEHf2y?=
 =?us-ascii?Q?auLDKXBbaFINhiQU9ccLmNORCkIov+rI1DmbJSU8wisZodioQ6H+tTJ/R2JJ?=
 =?us-ascii?Q?75n9RcvFzQuJ4N5Jp5BBNKWaUdxwfyqLbyfoXIpkgTYOb/9tGtye0ukFHqqR?=
 =?us-ascii?Q?ymZvffz/t33sHs49dTq8cnLH0YbM1Xnc1s2OPuLuNAyqsiU4/b6YR878HWDF?=
 =?us-ascii?Q?yKu8EhS8svzs+MGZimANuij3az5DCel2XYd9H2eNAqkp9swPRkEixjfJuxnl?=
 =?us-ascii?Q?0wPsyG8RH62nExHBHVxo60rjJJuxoYAHjk2HDpb8MAOZEVTQg1fYYAeIfWAr?=
 =?us-ascii?Q?LQT7z5ovyc9lz2Oryhzcv3LEQ4gdgvvdHnPLfZb9mMLy8Mx5DwP2DfJ3WpLG?=
 =?us-ascii?Q?DnOLCCTFlOZvIA969a4JRwnW1KIx9CCHB9T8I7tbgMMAFfpaNsBl4RqWTlaE?=
 =?us-ascii?Q?iBY1Qq5h3gSb0emuAfVwOZ15Gwh70tp677sCe9pT8pwXTGbYil42+gAmeQiu?=
 =?us-ascii?Q?RlIReqeuaJevpuOkZglbxYUNdxerAK7qveWJzy80xam56SceyUEmS1KR/GPI?=
 =?us-ascii?Q?CjrcmA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	bSJbBJCw3m3mkNvp/SA6C0L2Cn5/J/3AFi9p02E4a5+3ucItKEXnp+HbHqLiQk+B+SnhLAOYxkK0khzc9JsnjKNwXwT219mzBHX7XRrmXLOu2rIi9ht+wwKDoWWEonX+pAZGYs8xeIvp6HVC4//t+Xow0nYQ+zQ17V5IPuV/YXz1y1yiHY7X3JQI55bN6w/oZ9/KPwwDP4ROtyT8pqdxBDApHs6QmIJbF84WnVSatPk94gArvE4cab0tCGuoqgm+4mfz5C+05Dv75mhMmRHTVc5vaZsSuGjZyOQVhU/uJ8W/NRimDEvLwr6a9n+qsOnuE4fInwW86xZxjkZQPP8BrteFsRfoyjbln4FYvOs4divq6HgjQGfWXrN+lV3o0lf3Oz+Jr3YQPDLWc8n33op1dUx/fQi5e9QaY1ABaLAICkJWrUQ3ebZJTqEPI3PbiP9oQ8asQ/oDEw4hnjK187itkG4/jI7UA8PB7uai7qG7TX47ddD/tAVIUVJyDTpeHZjK7dVdIxBOerDbg6ZGzoSkzpW1xKpiUyM76KAshXQimHOb1MDVYXBYOdcNKspy2MGmJRgXQJLB1kRxtbW44OB51F4c4/G46T0kbISNKNHl5xE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d03c5db-8745-421d-d5d6-08dc21ed6afd
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:36.6811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rwn3RKKNZr7ywRA17CUSviNIVr6HUCJI5FhpaOCidntHLJZQFq7dOQcvV9h8gb5cGApPZPGfMS/oTjlqhIK2K8xxo0j7Y68D0wvHg5zoRmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-GUID: oVduVAKQLbHDHGKks8PM2ahupTSQC1Qk
X-Proofpoint-ORIG-GUID: oVduVAKQLbHDHGKks8PM2ahupTSQC1Qk

From: Cheng Lin <cheng.lin130@zte.com.cn>

commit 2b99e410b28f5a75ae417e6389e767c7745d6fce upstream.

When abnormal drop_nlink are detected on the inode,
return error, to avoid corruption propagation.

Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4d55f58d99b7..fb85c5c81745 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -918,6 +918,13 @@ xfs_droplink(
 	xfs_trans_t *tp,
 	xfs_inode_t *ip)
 {
+	if (VFS_I(ip)->i_nlink == 0) {
+		xfs_alert(ip->i_mount,
+			  "%s: Attempt to drop inode (%llu) with nlink zero.",
+			  __func__, ip->i_ino);
+		return -EFSCORRUPTED;
+	}
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
 	drop_nlink(VFS_I(ip));
-- 
2.39.3

