Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7076CFBF3;
	Wed, 27 Mar 2024 00:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498408; cv=fail; b=OyKpxBzpnYU6Layvx4bSiwsXVBAFpIrh30Ro3rOVa+ElEYTUeCcqi3kSiXsheUqok/B64UfVHc7PKDTrFlAAMBVLLN4sD5MPJ4jnqW7OnN1pg0EV1vkXQSLBQSdhpfhY+1YQas6SnYlUnkZZ8jBXFWkERYMajBcRFCzxt9bX0qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498408; c=relaxed/simple;
	bh=lwpe8rMi1U5ngmv665dQqwyoB7t2vsJoWILq8UFgfz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aUd4VOx4+x6rIP7BuzrWsXv2QNgyhXRaG0NZRgcpSF7V6hB55mXyJKjp0rBwVjUZQVGkEwb0LwQtqo+pvetqc6VzdIVkFidSwVu+nciwqytE4kWDRHv/7WTHsVEG23cb+/j6euUNXQIwmi63RgT0+veLK6qVSCAnDocI+f/LE2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IexYdLC7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J91PtL3X; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IexYdLC7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J91PtL3X"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLjlFW019156;
	Wed, 27 Mar 2024 00:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=XS4o86qzlPRD4mzntIZ4BMkltkMmydbNfJOcQnkOoho=;
 b=IexYdLC7hMshmj9vDlFAdJSBvd2PHS29ahfLM3VoJVejA8WsuRHCHAs8Y05D0DJqnWpq
 j6tqmrddClG4SDLi/TtDcbH9PZKevGf2uDwe+H1zZFQ78gVtahWdSaN2E1ibsPky+CL0
 IBACIGoRgwuq1gMfmn0tWd05Qbk6gUQBxHwoDPxiuAYP7dCjevfyMFFcWvOzjqncIN2o
 4fJ205GpKReaa9CeN/NPpvsOWS/RRbZkzauRPhnpyX2j/thJ7NDki7fiM/bfQdmE97ea
 PsadhiIJG3uf9YdjCBBtT/+d+tal76PB4waar3egL9n6S6eL1zlCHYlAPbsvBnVr7mfQ /g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybp8au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R05MAo020824;
	Wed, 27 Mar 2024 00:13:23 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1akw-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhGizZRN99hL4TCHxs6MQC7/SJPM/KucQpfFuYkmWWpvI6GBAZ4zRhvEKZzolFsJK3dzwf1LzIQ9cE6FN7tXuCXlTYrN8mIs32GO7waWAPLZSdf/aED3iA+7dhUU8UNaa/j0hfull0rjcgSNHt2/1rKAoXZad545u3wl58yPs75B6ot/UorsmYFu2s/RptXmrdDAigCZffSW+75fc4h6OudXin72KruDq0yYae/TV2snj6IZv+XPEiJwIEgwb+LK1ZRyH+Zl82/IE1YiZEknGr7z4bxZ/loetKMIKivsNsqk2QcsQByWgJSThvhnY/3TTcCR9tZw5SlJoBw+eqL1/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XS4o86qzlPRD4mzntIZ4BMkltkMmydbNfJOcQnkOoho=;
 b=Yb94Ex3SJE7sMFl6eEq5IE5unP7brTA90FbDGlZS28Hbq0ZtcqX7S3d7nU6GpJQlG3XIMMQbDoGfTg0EDRjIgqGwC13b03cSWVyJr5aua+npNwvk8W+8enmIQk0anbyh/G9O96vGvPmGO/MsF8iB8Lyvb/jGImGS2qQHkZxTHf2IX0tTNerVqj5M+TB+seXtjfk0+IMAeQwKEvTPdnWL8Kj4NYZNpiTrTI0kO5ElUnlovKO0U1jTQkbaKUd1WULM0G0jdbK5WkBAuOtUJcztQRiZ+zQN2hMCAVFS3jSa2HhVjOr+OEvVGAbMsPxmeG9CABNX1GpTzMiOb1jt1M8Jiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XS4o86qzlPRD4mzntIZ4BMkltkMmydbNfJOcQnkOoho=;
 b=J91PtL3X3yMdvyknQUE1Y3XJOuQkwMFdx0NQmhN7xZ8uvZSJ1UnbrtyGHxXg8uaFGPps3U63dPgJNFnTgyjKTbDWmgqoOaMQEQ0eWcuuKybWJ9zhFC6hjGvgJcQ/RNB0Moal4823zbgATtVUIACz/hvsw1uEEY+nNHYdksZ/6l8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:21 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:21 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 19/24] xfs: add lock protection when remove perag from radix tree
Date: Tue, 26 Mar 2024 17:12:28 -0700
Message-Id: <20240327001233.51675-20-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0016.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::29) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	gXrJZ2eYrm9icQ3VDwPb9XRTuOz2A0dFjjaWutBx2CLEvloE0af04Bwv09U1LLv/dOm5sK51T8IBOr+US0+GRhkUelwkxx+lT38F4dQ1Ab0XoNIQr3fnY8VFVq/g74K69g/BD6DBSCuPruZQmbMVa3sDDNGRNeP0zlbK1KTYB92CtlSxNdosVZl/heHLh1dJcYlNJP4GtQoiFc7bq1/sJVzDuvyGoLQ3Ua9lBiFv7xzrFfGZPu7LLh97bwdSNQx78uu7xPqlhtVs33LlrerDxA2HjxOuHUQPrSWdgEIg4IfriPmZVlPMkKjkeShyVcC/gPb28MCSMvFClUbCS5Bw0alpNWzDAEhBbJPWIiof+rPzImd4UAO2By7RNzoEKqMIKR3OXmXmhP1sLrwagxY12AxKvC9HWRsB99t9tQyf+26pIbIdg1lE7OsZdHPcNr8E55Ri9IAnexjGgll1yxjTntO/fJOIyjP1/mYILedpazRdyFBBb58kZJFBkwImg01KKjlqFlfjWDA2u9HU5vGQJ9DfvlNpc0wrn4NeE548CSkkWjdSbdsjq0+p6K5MYSteSyDB/5PF95bxAdtyy9UUOF+Hym/J+FhB7QL4sosdzakhLg0ms43SXbA6QekCBdCoBBOOC6sq22k89+1o6LM3AZ7DvEyVlFxQ/rasQW+5a6k=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?nAvGbknPz92v/cnrwa/4XDIbh9MSm9tEdX5UWz1yCMor1HnhWHm9AClkkMFE?=
 =?us-ascii?Q?zCjO+ng+bE/OHP5skKp9TaLO6WYwTHzgYuYPXMTtJpo7UpdE1YZDce/iDU/X?=
 =?us-ascii?Q?RP57NYpiDEXqgkKOf58eDvIK9qOW4XWH/i+fiKh2b/a6jft+uEVyp5GdFKQl?=
 =?us-ascii?Q?Hkpc+ufY2TPg0bMmkQhNYelB1SNVWNiajCKwKaaFvbspSubyststPJUtL7Wc?=
 =?us-ascii?Q?EGyqvNew2usSmAq+DWbDZHRnUakVWBAl6YSv70Kt3xglmwvCSJi+NxBlMEXC?=
 =?us-ascii?Q?asbBvf5sUPdNtOr7p/8MREzuRlPLjezIKYeUeZ8dTYP1g3ckzRZj+i72bHBH?=
 =?us-ascii?Q?BrEgWSYX/Smaid4JdwHOHt5Tl5eu6miBlIaL7k/FiHZ+X5sIF/RSEwN6cg5X?=
 =?us-ascii?Q?JV4UZ9iQwBCG3iPduXL6r+m4FBj+0b03JMrdBuQEDef040lBb/frthXfGGa1?=
 =?us-ascii?Q?h//reAG5hsLI2iDUBHu8pN6o7uPxyf5f/5H0nFHA4iIVVbtA4L3DHzWKpyge?=
 =?us-ascii?Q?zp4+bMJ4mmx9J3q9jNHADlm69q+PN/l34VZwFQMBaU54YEuopUhmu/WNcZGa?=
 =?us-ascii?Q?n92VNCUmc5xysA6lho3UqRai0Woy71o5F4A3or16FsCpe6eEyTCHWLqNJ8NK?=
 =?us-ascii?Q?wHZdi0OSEbD3/nqBkoV7OgnTtXNkMiWIoKsP6L5UnAeKgbZLc5UB8d6nKQ24?=
 =?us-ascii?Q?ytq/mHs3BledJSEJ03xA3NZLfCCLCGdso+rbbngjKK5BCee737utN3HaMQrV?=
 =?us-ascii?Q?CQSfr9xQ0o9lCUEHvvLBnDlZdAasZA1JU6yF1vSeD3ADkI9g56pSZf6jp6Zu?=
 =?us-ascii?Q?WGxU9Wdl39IpEvuPX7lbiF4ae/U7ZtIvyGvYra56Gpyl/zj6MtyH44dn3im1?=
 =?us-ascii?Q?Qa/6ijnOElfe1GId4PZ7KdoV+xuKUrJyj1Lpq9zR2k5r6YNQLtTOxLVVpUut?=
 =?us-ascii?Q?za8iSlTPFsBacpZ+KDgnls5EZ2CiEaDpFvXaf912m18KwaAQoqbWfhGbKlix?=
 =?us-ascii?Q?qmht3JmTKSkzLdwTTQ0tg8N/iK24OjdcQzHztUrIKxMiN9ixqbzNM+RgCv+E?=
 =?us-ascii?Q?bi3Py9hiQEgtfmA+jutDKE54AxTPHosJiyTgVVIhHVrgP/+AkY+Ti4fQCpl5?=
 =?us-ascii?Q?B+cfdaEzmqxytx6PX+pbGEJHK7NkxoyskPNs5Uwn2X8n02Jk/MYKXp09vcIY?=
 =?us-ascii?Q?n2kKvbAP/fAKTl/7urrOSfS/lwP9pl7BxNjO/qiVp/tikaLqaTCxIox3/B0W?=
 =?us-ascii?Q?ocTvBMT4fquqt2dKlHmfPC4pgbT0f6Y8cbftwnceFTXzBzgSv5MzpQn/+HBF?=
 =?us-ascii?Q?S7aDdreip1lXe8cOqO7t394BIay9P+z9EIcEUHtCqRI98+XUiKP8K0zzjIeW?=
 =?us-ascii?Q?9OKLv0UmTV10LPRQUVyiLWrvl0JigIP6fN7PIvFWNixbMP8NhObpWcUuoJIl?=
 =?us-ascii?Q?CY42wXxNlzR8urbLHWxX0psFhAmHkrxe6DMak1htJUxY5LmWtEHNrpnue55t?=
 =?us-ascii?Q?SSMwlGtavoSft/TGp7nDyxi3q91XMNO3IakuDq38Xq8ggLs3s9byPTOmGuju?=
 =?us-ascii?Q?3AS88neeb693z7FCzcgDP50wxTE5Py/GSc/BU/jo65Nd0dtk/BnWMA4icMaX?=
 =?us-ascii?Q?vJNzL1ogOPlNNzoawB5wo7CxEbqrj1efegvKWIqTcP5lhTQ0skNzHyxgjtfp?=
 =?us-ascii?Q?v0feTg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	uu/m7yVVFB+aDJEUN5zuToSPLtWleb11B4KPMBe37rCd4/rSol+0F7dx0s71DOZaKqZrQm4X29C/dBZOL+SwDwZ4PpNZjYlLBVEp9j7gENh32lKNrg02kPFNVQ7pTZwTxdh2ztMgvqqdaQB7GAjWQFPN2atHztodRH5AA7CHRJ32NrUdRWp7HaFTULDKFfdqVDr7kltSA1KbzBl6hh4D2ubaLpIY2O9I91+f/U2VYPp9hqnW/TeEtatkCTGrV+fbqBsjdCAozSg3UIFCkcV//q2PQpQE4RhOMUhgmZUChS2mOf9APPJt9HUFGqVqtBrG/2vFyr6I4fUKTlUreJhDDVv4a//wM5Nkw8/cP1nm643w/cz/Obr0GT4WkRlxGFBkJxENkGgIscdlufUWa4Te5b/c79xJfp+ICt2jGR6ZcI4QfFSd6Dkqz0WqIn8vW3rvb44WJTPbOKPCCvdPHDRDIrZJzDI0eXUQVv9AihGm5SnGU22tETpSfCN6m9s4JNeAwLhcNg6atbMv1zQngh30+o9ydyE5NkjpJ73H4uKgJ1oa2j/DBKpkZ3h5FKn1ariUIECzCu63+4W1Ezrjvfz/3cnmHEaqegaLDhsLTlAjfls=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dbe6052-e2df-46d1-7c12-08dc4df2b644
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:21.6414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZGQUNog0xbR6KRPEnNYTrsdEjCmROQ5hnkTBbp6qh9ImnR559xbfor9Rcns8OX8IhKv/Np9Dh7PjzFlCnwGmCmX++VXSPfyF13DVez5l9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270000
X-Proofpoint-GUID: UT8lPYixtyhDkkh38IpQPpyFP7hZjkAJ
X-Proofpoint-ORIG-GUID: UT8lPYixtyhDkkh38IpQPpyFP7hZjkAJ

From: Long Li <leo.lilong@huawei.com>

commit 07afd3173d0c6d24a47441839a835955ec6cf0d4 upstream.

Take mp->m_perag_lock for deletions from the perag radix tree in
xfs_initialize_perag to prevent racing with tagging operations.
Lookups are fine - they are RCU protected so already deal with the
tree changing shape underneath the lookup - but tagging operations
require the tree to be stable while the tags are propagated back up
to the root.

Right now there's nothing stopping radix tree tagging from operating
while a growfs operation is progress and adding/removing new entries
into the radix tree.

Hence we can have traversals that require a stable tree occurring at
the same time we are removing unused entries from the radix tree which
causes the shape of the tree to change.

Likely this hasn't caused a problem in the past because we are only
doing append addition and removal so the active AG part of the tree
is not changing shape, but that doesn't mean it is safe. Just making
the radix tree modifications serialise against each other is obviously
correct.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index f9f4d694640d..cc10a3ca052f 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -424,13 +424,17 @@ xfs_initialize_perag(
 
 out_remove_pag:
 	xfs_defer_drain_free(&pag->pag_intents_drain);
+	spin_lock(&mp->m_perag_lock);
 	radix_tree_delete(&mp->m_perag_tree, index);
+	spin_unlock(&mp->m_perag_lock);
 out_free_pag:
 	kmem_free(pag);
 out_unwind_new_pags:
 	/* unwind any prior newly initialized pags */
 	for (index = first_initialised; index < agcount; index++) {
+		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		spin_unlock(&mp->m_perag_lock);
 		if (!pag)
 			break;
 		xfs_buf_hash_destroy(pag);
-- 
2.39.3

