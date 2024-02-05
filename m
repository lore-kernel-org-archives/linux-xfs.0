Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4364D117
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171646; cv=fail; b=OnxUR0jzw7X8VX/1vJ2s2Autr6nlDaVpqffexM2XzX4UhVVUgL9mixCddhzMiAfcFBPuLjaH85T+9LqN3kwOGsW3Ely9dOfQPxfmGFNf2dYB/TotxvO7rHapNGurwkwLDjoYptthtrEbqf+/PAhEtEjbatfA0QYG0gleFR3+wSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171646; c=relaxed/simple;
	bh=ptQUU1riNYeaZ6ra63JPwMP6vbPi8VoDd9PokttUThs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AlTRE1qbsNgDh1MLZuggAfvcJmWMfOFS6ftb7vRYV2OQk7hwi64tzeos8anvKGXOg6ii+nYc587lD1J9bAES2rHJWCtKNSvREaPHdTXWdzNfc20WxbDPgsm1yrdNimfgYTVY4R3Tb1yX1LlIMUOM6H7LDWiWIBXslGvGuZWbiCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jFWF0TMz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b4prWRZS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jFWF0TMz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b4prWRZS"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LDx4F017389
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=Rpp41uyfpYqkyVkZRwrxUVLNdfIlk2H6xU10UsUHj90=;
 b=jFWF0TMzk1s2E9rSAVcjihDysAWiK5sWbieFyUATbNbNuynm2GH5YQRbFq773GXqNB8t
 TIYTj2H5o3z6Yge7VQ7i/VUfrkYQCw3MRg4tHzK2H1xc6QLaZ24z68sIHEiY+Ldyu6EJ
 CBbXjp8nIxKXPOqqQxFiaa4FNMV6lq34R2KkuoSSMwE1iBliqZZHZFznVoVbYkXb3I2v
 gzKTXnfXXFNAM8g7kPkD4oUDg3MMk4HwLPpnbrE/exD+MtcebqkWi/guQ5kzFR86c2bA
 ckZ9YdcNHmH7Crm+WShIIWQJsT8nYkXIdzYmjhSF9gzyzpwk87rMZgong46KnbDZuJRm 6Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dhdda6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415LbwVG007131
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6k5rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ej8qT4AzlCYfk3okZmMUP50YqOWvUnlJ4Ppk9cpVYF0GOMZa6pPpGoRYbBmc+jBQzRMBjhVpk0KPsptr9C8Soni5c7HI55DRPv7suTgh8SGMRKA7S4hsDIYaEto8+/X+x+r7/iNYcFp1NJJWffk9TKvMZqsecWefy3uXzI5YXes7RKppFsXj4eORvoOvwYE9M+EsqpxrZ8EoTcFM7CXvsRsSIqP9eriY32/3eoLhlfmWRd5VsvaPc/CvACTL10HZfvg/Irk0GYBRQccW6IU90V9bTebPxaVDQtljoM+GwwxahNQO6MCnxoLAGi8MrVjUZbvDsdkXy/5jHsKyOUsy4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rpp41uyfpYqkyVkZRwrxUVLNdfIlk2H6xU10UsUHj90=;
 b=RNzLh3QXlABSYkWMO6F5erMAGNEn+Fns30rcz3RuMh9qvLB+2ZkUiWhqAopKMNQWwb8s4G1ejVU+DO9RQXBMtlVx0a5/0r08GD2GZC1KwWCvQhajeAzqwa6oT1gn8r3gqA9eeytfsy06+UP1YGPvjmuq3tKPp32MwpVgUcw1fIZhM7/wZgxISXWmsJXQdEL+vqmR7ULbQIbLHMzL7imudCkNkFnTajLRo5saGf7haUFGP3dvSj1Mhzm7G8/ERg0U1aq3zg5zlXFYncfLuFjp0DgZE+447Qb2R4cgLyp//qPptkqe2EUNSWrc4IPBVRwFUt9qdhaBtY0uAH13WAJIKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rpp41uyfpYqkyVkZRwrxUVLNdfIlk2H6xU10UsUHj90=;
 b=b4prWRZS9y2MAUU9aU/cl0wUCTTzmhqAqOo3pTJr1K4nMP3XduZeZ5rgRdicjNVygmwUN3A/xSDqccvZm09fhEeU/MCnYx819AWxIBP80fKMe7qzgQ0NmkIJ9wKBWrmPfz3ZX5+jsEtKdvbkgIXIsqje23LsMYW4btFLjsnPFhg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:40 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:40 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 11/21] xfs: factor out xfs_defer_pending_abort
Date: Mon,  5 Feb 2024 14:20:01 -0800
Message-Id: <20240205222011.95476-12-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::6) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 370f3c86-1470-40b3-9d43-08dc2698af84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	SnFNb0JcJWQGyA4nDGv1pa8rgXq4M5FkvETwQD2EdY0eE03xYYsQuHE86sqfhtjGDNy1b4WxLfBjnzP/UHkO8b7mdSFI3mNCzdylISGT+NL4O7LsCFomxTfh4txXGF0/T1ne3I4/UzHHcDvhOGpJ3HykeDd72YstmI3ek490VOo4+R3LR10g/EsCkV1s9e7/seRxXhgkq5LPUZ/afnH03uPpMctgIqfs9JPCbLx6LX/DFhVm/9OvyrQItUmM3JHDbfeXqUAGvutsMX0lvWkrU1Hrc5usKQvUgJ3rSM+tQdcSri5lVcOu8/7cmgIXB8w14cU5iTOgM3vdFt0wPBWJUr3nRWE2eXyBqaykGs8NIgU+CoNVEjpRY7nBYQ1hBlLpcToKxVdoztLvbFO8QsSWoecFBrf73vftLty6BR7Mfc1XitQNpVNHmSTFxKiVCb07stbLjXp+zjkYOBQRPeJR/KQi4RQSoh6VioRfjKENIU3JPF3rsgxuq7B0KqIdqGKRDhhY+Bf3hIYW7Ruav0CK0OeHTdpmEtKT86cXAtbz8lci9B4QQLtTUeG6tKqHCIWz
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?M0W2bnjpbfDfEioUbr+8nKGdTdZDmyYfKputOO9JYOl3dJbSePAUUXNaGi75?=
 =?us-ascii?Q?niCh2W/rhhdIjJTiALCvE2ahnEtr5UoGRw82F6h1F7Y+4hyJcdRtJ6S+1Ccx?=
 =?us-ascii?Q?9kefe+PuGBz+jNevlDrWadNomKCsEgYvuZ28B1JGYO5Saary1nxV4CVKL4eo?=
 =?us-ascii?Q?SXV1LkiGeSlxmxBXs8ijM+uFO0SHPZVC3FKVP7ceJWwoIKn6KhXAbe26Ydcq?=
 =?us-ascii?Q?UvqA7o5gURsWlogEAB/Hn3Gpads8NK7pgJV6bXQp/sZbf79rKDldUXyasCy2?=
 =?us-ascii?Q?OvaEnhxgKuZQhGE7Q1y0bwkv96qiStVoSrURErTEXXvhBdUHYZCVTgt47zbn?=
 =?us-ascii?Q?B5EmXJ0qKQn2xBOVCR7fvI79K5tYJ7lGJTwU07hvfHb602CwCGIe/2cwMwDf?=
 =?us-ascii?Q?iOD9RouDgEpZ/agTrBDF6whUpP2e46ln96EVBzyEuV/HuX0naFBNiXFQZyuE?=
 =?us-ascii?Q?jGZ7dS7UaGKfvgBGBjFN8jJTkfH2EuMymfAXoYivJ2VPXnCHXeQmqxOJjNep?=
 =?us-ascii?Q?H+6BvEhEGExPVzMzjceZoC0tUGvKY/fHJcqR7VvsNcubJalL/4E6DuTDqtJD?=
 =?us-ascii?Q?keA9VdeQ4bkKYCAKF8DYX6CC+7pnD2m6l1vBH5nGnUmviXmY421rbf7CytsZ?=
 =?us-ascii?Q?wtxAG1bLOVxw5gr5garmslbIjXsH0W3QFKDT3ehTs3qdqZ+u6WkSBSHqtxfK?=
 =?us-ascii?Q?XHRmeJilfnYerxndwnZFXh96Zh6jVpJv7ETvMo+G3RQXJ8YaTOlFxJPw4S5K?=
 =?us-ascii?Q?AqOyT/H64ZL8x7KucIpUk7t3j6NIq93PtdVKwcr5NBiSyj96E6VCJgcRPtDS?=
 =?us-ascii?Q?24HH7PN2KiJ7hybPZbHJ1giqp2Zb45X8HMb5dopuLw1N7wdiLsT84yxtGej3?=
 =?us-ascii?Q?JzMVYOhz3pq41UPLq7p0rR4K3ffpjPUcrqjsdK06OB/fqBvUYAX4wRelv34U?=
 =?us-ascii?Q?VM3sZCg3uOw5uF4FJPTV+y0u355wCAwNe8r/EsUy6u1lzfElG233xua1L2jT?=
 =?us-ascii?Q?/Ols1hM/wv2QrKJbAbpGh8PXzOJYL8d4RZqEx6JnAenJIAu0fQMx0NevpCLV?=
 =?us-ascii?Q?GXOrW5GzFxP61pXe5sbj9nhOSx3o7jArrkB2jsj99cUrxRXu3IxJhE4ldT/o?=
 =?us-ascii?Q?6nunD9kCBgXGpv6P9tyFIR2sG1gJ09ht4kOLDXp1LhEVQTplZEWYKkHrHT6e?=
 =?us-ascii?Q?9Kc2G2faJrwyFOBwVQyjGd2hT6bQfXIddRSod49B0jvqkG100RXqlLpPT/N3?=
 =?us-ascii?Q?f54iHKHFNKCItTZGj5AazYq80bpEcJ5N9kWXE1bBYlWIhOIyaLQ+VZrJWfma?=
 =?us-ascii?Q?q2Z+4c+jTZbXdZTHRCghRhgp13+MKyCPTgq/J0m+k8IMMRqKgL+ClY2kfimZ?=
 =?us-ascii?Q?o10TleeqGDT8YHTB4LTGknOO0B8W/zf/8RXnnryq/3IrQkFE5neKllNpZYT0?=
 =?us-ascii?Q?V3rfnzqAKg/F7doZKbhKKq/HzQrUizHQ+tRVkWvDffzIm6TZpjvpvbEjo3Cd?=
 =?us-ascii?Q?yxXnHuUe9PNRC6yipY/9eo2VP3+CKza96/KCOdgXb8wJvAnMC8aFIKySxHFr?=
 =?us-ascii?Q?JvWKr1m68uNkdLA2NoiO2bvNHcNrvbvqnX3/WRk6DjiTxkRJdz1FDNkkHN0b?=
 =?us-ascii?Q?WEpICjtTEG9J4MKz9QuHjzUgga6OcaOuhI4qyM4MdhS2LzCdeUeBc7Gfu3sr?=
 =?us-ascii?Q?GZ2sJg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	BOGu7mHfW1bx5PZ95L6C/72uea5BEGJyyE0Ne1R56Llksqp5LggAmkIYh3geQme8N1xn5Rj2m78DXnrKIxbTmByo6jZhfA33CmD7dD2sOd5woyqI3d9g9FpZvkROpPoYTFYR4DLbgimfbrVndlnauyqBts8hAnocFZJd4Mwighs3POlscJ3c+2i6W0CzUPwuMqm0Zw6AChBAVvy08ntD6SDreMj4HQyFo3JJpjXc1uCGBKz2IokIWrLt+1qdHSLqt9CepvyyUGeGMBrO+s2MbUmvgf5H3bkAr3OKo45W+9U6STfG01qmT8mDZXSo9OUaabz/rqvE05j8qLaMnsPWNHRyEBp2mtg3p6yzXOQ2Rh9JrOIqbfYJtF5Q8YkqJxC6D1xMAxuMR0g6Tz8Yp7C04IgIfjAXNv81Kh10dAWxBkzplB5MKQDZwXxHc/vEaywag3nkXRaYqbkzJMqhOspfuASovN+Mg8Gm/EjeVf2Z+IHvGe4fkWcA5UcvWfdSqRe0iox4EvYw6Dg6wwHvgq14GxdAAR3g9CzhEYknpBF8VrTalAmeHB9o2zMFZAr/+3ZGvRFlYHuKWVFRWpvnX0X1Xw34Yrr/HC4hkOoqke8zfDg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 370f3c86-1470-40b3-9d43-08dc2698af84
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:40.3043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04p8kgFLfak2tK7a4Y+atuxvVhimblbHyY2+rG3pCoz9fDrBzta9tYW/V5TtZMxIF5b4pbg6rFMfINmtz8SrcFw8+bdadv4K521OhC+NW3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-GUID: n1Q472M6lcayAsI0WT2XZyLUK8WTnhfh
X-Proofpoint-ORIG-GUID: n1Q472M6lcayAsI0WT2XZyLUK8WTnhfh

From: Long Li <leo.lilong@huawei.com>

commit 2a5db859c6825b5d50377dda9c3cc729c20cad43 upstream.

Factor out xfs_defer_pending_abort() from xfs_defer_trans_abort(), which
not use transaction parameter, so it can be used after the transaction
life cycle.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index bcfb6a4203cd..88388e12f8e7 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -245,21 +245,18 @@ xfs_defer_create_intents(
 	return ret;
 }
 
-/* Abort all the intents that were committed. */
 STATIC void
-xfs_defer_trans_abort(
-	struct xfs_trans		*tp,
-	struct list_head		*dop_pending)
+xfs_defer_pending_abort(
+	struct xfs_mount		*mp,
+	struct list_head		*dop_list)
 {
 	struct xfs_defer_pending	*dfp;
 	const struct xfs_defer_op_type	*ops;
 
-	trace_xfs_defer_trans_abort(tp, _RET_IP_);
-
 	/* Abort intent items that don't have a done item. */
-	list_for_each_entry(dfp, dop_pending, dfp_list) {
+	list_for_each_entry(dfp, dop_list, dfp_list) {
 		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
+		trace_xfs_defer_pending_abort(mp, dfp);
 		if (dfp->dfp_intent && !dfp->dfp_done) {
 			ops->abort_intent(dfp->dfp_intent);
 			dfp->dfp_intent = NULL;
@@ -267,6 +264,16 @@ xfs_defer_trans_abort(
 	}
 }
 
+/* Abort all the intents that were committed. */
+STATIC void
+xfs_defer_trans_abort(
+	struct xfs_trans		*tp,
+	struct list_head		*dop_pending)
+{
+	trace_xfs_defer_trans_abort(tp, _RET_IP_);
+	xfs_defer_pending_abort(tp->t_mountp, dop_pending);
+}
+
 /*
  * Capture resources that the caller said not to release ("held") when the
  * transaction commits.  Caller is responsible for zero-initializing @dres.
-- 
2.39.3

