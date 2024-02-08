Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42F454BFB;
	Thu,  8 Feb 2024 23:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434502; cv=fail; b=K9bjL1wYjhrBIvWB8JBSXZCav9G3S10c/VzAkJMVuADdeC37YjJbOawFx97Ypcxzq/wgVBqbWPQK+y8EN01P5thzs0KreYvjSpS2ulym0jpFx9Pwj71v0iQOmOJLVwzYqM0x09ibWlZ5PrwDslO5ruo8s34jz0hrNXIvgwOy5Ko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434502; c=relaxed/simple;
	bh=9a9RgjHD/TuMFkBvCm/6QpuVhk4kdWKmwWBD7ZY9TiY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a5MtZwJ7x0xl37zqwPHCsnp+sV6Diic4VSOPSpf3lbbRTUaDZs52qsMBXnfH20Wb3pGh/95zIhonWetHi4fIKkXetpg7uzjEeR0R4xVYG2pNfI2/Ut4HBluviBXlKK3uauq6daNvTYNuTJ5RW3oCEWVWRVsF35SmFYbvIRpJVKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KNzPqjvc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y9bbeZVA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KNzPqjvc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y9bbeZVA"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LT1s0019836;
	Thu, 8 Feb 2024 23:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=kSJGlmPtzLppA/FEOKBDkbjVzs5x0DNZEJOGNabExAI=;
 b=KNzPqjvcNPfBngljjULjAUanHKPh8iCqaUyPyjUS7efekDeJLyskd3eXwFIdmgiRAPlf
 qHp6/teDUlGzAstIziZEGQ+7BgKTJryO710MJBcvX3blRBSJCyn5X8ragREA5aFLeh1O
 63zpcVVcl09u1Q5KuGtcZVCd7rT+hkvigXrqLTMoTOZMukyaRTLs4D9hMLlKbnE6LDSx
 pQnxDuX8rBSxpLEiQsxYAmElpWyCCIdyPPz99Ajic9b6Iddf4lyAItryDP30JbjaJMpQ
 5tZ7NIcCC/AJzQfGa+Y3675pESG312XbMmVQJQ0LArv0CU0rq8lHmLhT5Mrbf4l/OuUO Jg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1bwewx4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:39 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418LckCW039623;
	Thu, 8 Feb 2024 23:21:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxb4y95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwurZcqWPxLhANQ/hcKANKn8Vyg+MGTLFzkmERNRVrK4+vOn9Z54TtMLGBNsT7wEmx5b1REPdWYFed6gxrzANoqaFThbPpL4g7n89nIAaMYg3I5RE+mfwyJ8KDC7CBCelGsyhwv2m7oKYi7wkycxc2MTjxULCdTa4V1veZ/1r2sOS3jOzFqxImX3sa0RvP/KtSen+BGEpuLTyCa/6I5FhkG/dcTfRh9kbGQt0bLhPfLeoMzq/i36pUHl0wABDetDPBZggIYECppoEHEWzn86/T71p6Cxmh6S/FOybnf//mwS+UmCnFwNMeG6MUVUAgMyWewF4xI8sKq9jOf74gRqLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kSJGlmPtzLppA/FEOKBDkbjVzs5x0DNZEJOGNabExAI=;
 b=WP2Wp4u9dCEwFav/Nnuc3lgCb7ny7cDG2q+B0Hm0M7ldSgX6sYqrhqOHL3BWvuPaQXdU2Yp2P03ANm+W1gENEQ7L5gfYcbDohh5WeHc96VMCtc6RuMUvumlSwEWVD7cAof3Vb0EPEABVQjtmimN7gChIL67tgOKEHe0kdVE+Ks7Zh+MwNe0Ijh538pPSdQ1JMb+sOxfBr+MKJPYmNvw+0uU9bFt9S+HsuBgMGjDFzOPyjnCktvKfBXKOxepvb3kLFnwZpvO3Ylzb3AV7qMiyoQtBz3zcIKMx021uZj5pxtmUG+MSgU5KG3Ch3FUcgNwyK/84+UaOlt9TFRddNZuYBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSJGlmPtzLppA/FEOKBDkbjVzs5x0DNZEJOGNabExAI=;
 b=y9bbeZVA/FdIHPYRxusvb73+UU7LPXQb9E+Ze8a38CbCxx7C7pgPCmKxvBX2shzc+ocJZpqLs786KDuAFLuid2uHDMKVK7LIIOazK4iQNXSTM/zh1p5mKCOAdCyItSh1mE5fAv/NrBZRHUm2EVbsDRDxYWhlaz+Z6V2mLMV2qk0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:36 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:36 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 19/21] xfs: dquot recovery does not validate the recovered dquot
Date: Thu,  8 Feb 2024 15:20:52 -0800
Message-Id: <20240208232054.15778-20-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0010.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: fa544dc7-6b5a-4499-27bc-08dc28fcb1c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jUzPD/xcUbjaG3JBEVMSIzwrd7PcNHEqBHhXYaw4RxyAFxy7pLH/YmtE5z32LO7CZ97EbKsDRJ10mlj79gE8dW99LFSdBo8yWVaKMpwrG8cSgXz7YTEse3q6MlT3/xIo8akwW70VtwVI9I449PcFrwHzZlpx2drmMg734Z/KTTnmoh0feMJ1Ns6HIQ4aEg9Hn6ca0Zwvk42HK5ACZT8lYbGfb0o9JRp2YCj8xg731Sj63w8qzW65/FYR7C7cKXpcGWzjiGsGk7JzWRZ+uH1bNwiKCg9uny6WNzSQCOpMB0cFnjxAP1U0P4kG/CjtI7DVz+7tEt6huzqtpT28idRdTlkRX9YHf0ZLUtTsCw9cttDEa3neE7rKhTlqCn6Wl99j+Wkmzi+iAWvKEU7C7hofNM/W4Innehis44YYgjzyAOn7sGUu5H8Ij2cEPsz1LkLCPYnWp5zpXmSwHJGIXyxMGn64IJPJ+cARcPjM1LZ9eHROO1dTVvnodJ9uSR9x8OrwzYxe0o65MGOkS1OYGgXgOcxXCiR7YJydTruh/ucSSMHTNwSl+2jipTPTxru5GxIS
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(15650500001)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?pX8oKsTl0GqEti1clvY0beqI6MaSsOE2TpLeeyjhE7pLkDIwMIhBs686imno?=
 =?us-ascii?Q?2cE3s1xhrs5gBPrFK2t9+RPHilcJoUw/3yUOYmVIh4K8JDnQdEld+gPtbixZ?=
 =?us-ascii?Q?ZehncF8CDuM5qgW3I6l8sD4WuBXEShu+ejbmUU/AK8dym0pHvMWw2/0YcnLH?=
 =?us-ascii?Q?FZh33uVB7Bx7c+/7CPgrsh0iXfHJ0GehBF2yDeuw8Mq2gnJzcid9Kq7p9txc?=
 =?us-ascii?Q?ImsL0M5rO6MBejJFzqAJU0f/ZP0owG8bWgJ6t+3GY8z36NMtyIeUmdOr63zw?=
 =?us-ascii?Q?1mlDbKUZgP8T9b5vS0QST75a+okGKbJdYcnOlE+Fj5wtXX8S4lAIQYudhf7a?=
 =?us-ascii?Q?a2YNBdKd/3yU88mg8PpdDJOsIR6ZDfSje6h5XFEQnMBwBn402kPT6Hk5nlbP?=
 =?us-ascii?Q?3uiu2kgrYhT2f96m5uuz4BFYiVrUp0Y5t0Bu+c6H6rtdk61irUBOgpPNQQrA?=
 =?us-ascii?Q?Vpd+IpFmP1W1OuvfGhXaBs77yY74amzytexEJddAk2WSvZw9tHbMnAXv+D+k?=
 =?us-ascii?Q?8h8GyP56p+2ObkobA3nZbyu3d8Bv1heXNRDfWS6JdWDTaMSVX/BMdkWqcZSa?=
 =?us-ascii?Q?QoCh0bZkVu+UmkP3yakjGL3K2nOn1d9tXNjwisLbcLLih0TN9ZPx6trXNDo4?=
 =?us-ascii?Q?L5+It2LPFnIOUhLD+dSVsyf25UEVW+Gz4+i7m7/Hlwbd+4RTpnSGBAsLcEwr?=
 =?us-ascii?Q?tGoPHcZve8qDp0UYBDJSAyVqH2oVZraMS4xBvLwiP7xqw4sATq9+D0qsaoBU?=
 =?us-ascii?Q?r3iiHasz4k9/qR0kWBpD2kUiShQnYzTnK14gBoAWsCbUoeIIAgAU5LIqjkUX?=
 =?us-ascii?Q?aDX+jz/HG0ajoA6FTbZt7wd9hZy7g9ncKcjRqglw/gLjrS8t4/rJg9JSf/id?=
 =?us-ascii?Q?ynen++VQTcuWfTrVvwtfdct59ZEIbeVXV3cIUsyQ8W/N8vtC3blnBqY3Axn3?=
 =?us-ascii?Q?z9Ml/8Ld6uMa9P/Y4YTaBEao3iGvUGK2iG2P2YLBXQpcnU9lwGUGrFXogRGT?=
 =?us-ascii?Q?NFehtv5NUFQkg/4U0SoJZ9Kc6BKxp/fk4jYt/iRYTfrunnK1m1W0s+Bw/Dt1?=
 =?us-ascii?Q?vF+/QeuNBv+geSXvf5rY8b1JKudlqYIYqFqm1TWQSTUnI2YUYQj914YHcMCX?=
 =?us-ascii?Q?EX8/5y9+7mEFdaEjYr9A727Rk2A9aGdjqyxB4We2pIyKR0OwdFjJ9Hd+qKbo?=
 =?us-ascii?Q?PXvBH8Lx/hxz63to21JMo99yHVN29d9zSz+22STaG84vmz++pxjU33xoeNJP?=
 =?us-ascii?Q?SJMHnWpyoKfhan32ymEHE3uHZuKtOMTDgNDvLMvpuLBviwVVWKIefkBJtGU5?=
 =?us-ascii?Q?Yg5AyIKEuaDXC12IhgX+1TAkMTVlfFlODVwYBo0Kv8zC8wa75Uiv8VohDah4?=
 =?us-ascii?Q?f/LkFpCiZZYT5UqNYnlawqOGXU8YBOtZAQjUNIu60R1BPuw1UssUHCs2rdL0?=
 =?us-ascii?Q?qHJO71/97ltLolfMPqTwxsJ174zYwaKq317mdhTBix6Mj9ccmXCE1CaLkG1G?=
 =?us-ascii?Q?Al3n6ksNm7YEyDOWdLEFy3ppPNwsevzJtFlkh5XBt+vxc5gGjGybshGCW9J9?=
 =?us-ascii?Q?c/nSCbmcz7jMuF8ukdaaSWhiJtCBLgFufK5lPx6StNjqVlHyH/uhgIbOY9KN?=
 =?us-ascii?Q?uJOMgO/qE4zUh1+zm6wWcUjPFNYwcQ5Xl7YzH/ZvyQtg47vJOAtFcGcW/I4j?=
 =?us-ascii?Q?NGyX5w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	rsM4qVFwA/QdaN1rf8yKxiRSdIwjFJL+KmV9Uv2IuUznf5sGuprzBLhVrs1S8Yk70ssauTrsvvhtBi6ep49UPIhvv+D8QyogxK691MdcksLQMgUE4c+pGyKJznWz161qLMerOCSbQrFGUr0l67IQrYg+TMIwwFT3ZTp1xvxgaUdZEpErq0wEGaOCQnv67EKqMRsvng/1J0c1uqa8ISTbETiTQ+dJc369SD+1A+050ngzFVGDUO3rXM4mXyL0/m5P7RbcL3bwYpY33KsTkfNDCNnSPpo7Gq4SWaZ9bnfA1YCTMANu/sxwwwN2QTXGK07egapz6QwFKpb/Ko++jPgAbLsNeHZMkAbg5vwNXxQuEklY/WI7EnDsqrC7O94ltzj7xztu7j0TNABXGPy/Nahdgg70NqA5kydYWtto6Z1bcU7o+iUsJma11VA0HyUBbf8YYyZh8/SarfnZp6Rp3eNH+PB+RComOtMeUUMBCgp2+lkG8547D9nljzzJdKyUqoCHqBgAWPziK2GfpEjaIZDB8Y3cHJchQtr0MhBSlRLz3tAAcgdqvM0N1Of01z3ZtBZRwlimjyYL79l8KHDGKifZ69i1XwXb50sXQ7LZ7IwbzmY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa544dc7-6b5a-4499-27bc-08dc28fcb1c7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:36.0541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ls76CgiiTW7xVU/NEyW8XcsJt0cJFFW3xk6zwNPVyfDI6YS0CM+wT0QDjxxvUFyQ11820i0VJa7VEhVLxMAmYQ9uMAWSdvWCSp+9NVrDYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-ORIG-GUID: Ug44flwPCnpf5nD0epFu6HCl0cN5CLvV
X-Proofpoint-GUID: Ug44flwPCnpf5nD0epFu6HCl0cN5CLvV

From: "Darrick J. Wong" <djwong@kernel.org>

commit 9c235dfc3d3f901fe22acb20f2ab37ff39f2ce02 upstream.

When we're recovering ondisk quota records from the log, we need to
validate the recovered buffer contents before writing them to disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_dquot_item_recover.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index db2cb5e4197b..2c2720ce6923 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -19,6 +19,7 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_error.h"
 
 STATIC void
 xlog_recover_dquot_ra_pass2(
@@ -152,6 +153,19 @@ xlog_recover_dquot_commit_pass2(
 				 XFS_DQUOT_CRC_OFF);
 	}
 
+	/* Validate the recovered dquot. */
+	fa = xfs_dqblk_verify(log->l_mp, dqb, dq_f->qlf_id);
+	if (fa) {
+		XFS_CORRUPTION_ERROR("Bad dquot after recovery",
+				XFS_ERRLEVEL_LOW, mp, dqb,
+				sizeof(struct xfs_dqblk));
+		xfs_alert(mp,
+ "Metadata corruption detected at %pS, dquot 0x%x",
+				fa, dq_f->qlf_id);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
 	ASSERT(dq_f->qlf_size == 2);
 	ASSERT(bp->b_mount == mp);
 	bp->b_flags |= _XBF_LOGRECOVERY;
-- 
2.39.3

