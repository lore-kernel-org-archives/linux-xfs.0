Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7923C3C068;
	Thu,  8 Feb 2024 23:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434486; cv=fail; b=onsJj6a058rDE4qrR7gBPwGbvrx54A0p6o9xpBLiFTpAL9kPIeMuqz01dUsmkjPuhwtlvW3WdnVAHDpos140R30/W5OW7Kw3d4+qpG3WUPRiImuxGI0gO9nXwo7aVpdG0h70+g8V5VHdF/EfBxsu4eO7L3FYvUHkoutLzjrCDLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434486; c=relaxed/simple;
	bh=hXAU27nIXQeYdRDiVKxM/R2F8gLfAqGz30lYcZYRa+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=laVVRKRH0PpHXSUT7NYBvxe/KY+UDiTFQ8ItMnxZaU/dMpvbTvYoQlx7h4Yiz0ma5yR7XpaN35XKTdbgBQtE5s5As+Owv5HpYAaBk9/X4PdB81MZwM4nhISp5byLV61JwCc/AtNu8BqxaRnJ4GuM2sWMHU8hSZQTFqcaeDgOeuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZA9Rf4bp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lo8DWEVi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZA9Rf4bp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lo8DWEVi"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LSiAW015651;
	Thu, 8 Feb 2024 23:21:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=vBLjlRyyC6YIuB44P+i1rWyaViPzrcwyGO5G8E/4JHY=;
 b=ZA9Rf4bpnMYI5OFwnHNr1r6VPrVZxcAvC6c/HbBru0pBWRIPoLfvcOfV0v4u6PRQlF/i
 4B3gE57e8qpQO9dU4VEUYkVU2HUlgDhw7U4O8WDQwlxHo2enyaybcvVu2SQHoLxfz4PY
 d920TTaiDG/YlaC5ehfcgsz8tbdX5Rwa6RK+9cj4ZUU8D2rc83g0TqNdLK6syTChF3yU
 dKJ5hn5YY8I5vqY+81uVlsx8zq+3h1p3pqn8mUgR8WVUjPFWwRTRSoyVHg2zD4u/tjxr
 vFTZCYg0zzFTr5Uj6vHuZ1KJAflw8QQzRJQHrSsmjffIXSr5bsrF7kO8+/sFiHkode3g AQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dhdp8yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:22 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418MfUtg007263;
	Thu, 8 Feb 2024 23:21:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxbtgbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6trTQ3a95eYhEAmEhc2qC+Q6a/EupFYAz1V/rCXQ/f11idG250GqYBAGTms3Q7LIyyHK/Jyv3P1nXK2NoHXk1ElYxxNyDBnlS0WAMMvvJEBuscDShV50pcFIde17RWslFrhHGtHyMdwYhnHRDk44ZE6EF9yeIXAT758sQxNeZLs2IxbuOJ6xhgqByGS04nPkMYHkQx/ocvxMLprbWbun12dEqtZkh1hQ3ckYwvNXw78C7TDifSpisOoGyDdTxDq28D+pNk2oHEO66Y6IapArNzu+9FGY6ClqtTeiHsePOodvpj62sM8qNs4Iidj6KORd10PwJUI3efiz0pUeUFlqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBLjlRyyC6YIuB44P+i1rWyaViPzrcwyGO5G8E/4JHY=;
 b=ix3hatX2h15vEvk98BPZSVhkfQO6oBnBH8lTZ4EsUhgMjsc9aGLkecwkCh+WpXHa0q2OZamHGEcv5x61DHTyX1PVxv2LGjkDIlmGDqKAwMj9TNrOgPN+Vih7Geo8ROFAnVcGNJcihhWPL89oRRIMryBBX+wMfugCUOXq9trdyDjPpuca/Tz1a70DcN7gH6QQJN81yIDn0PdhXncWFEZfyPHMiVbrG7xvGPdTm7xnC5+TbQkJs7Szpl7lb2vEh2vUCNYzULydVN1VowfszghDC7/64W/I0819y9HWxBN6+FVCN9zRngIXQTgrk3Rf95K/ZCf2mVBLOPv/aKzv1BgN6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBLjlRyyC6YIuB44P+i1rWyaViPzrcwyGO5G8E/4JHY=;
 b=lo8DWEViEAik55HHgOOqTKiHftFuR+8Ef44LLhHcJa2nxjSVgIneisVC4GPOB+xwFxhTIY3EhiCW1scZeFGY2XD0gcuBsKhex4dUt3xG9uzcccycpNn+AA3OfUu9HAkxGeCA2do0ZCr6nzxgPND5Jqrq0aLRsGz3shXjhN5CuAs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:19 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:19 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 11/21] xfs: factor out xfs_defer_pending_abort
Date: Thu,  8 Feb 2024 15:20:44 -0800
Message-Id: <20240208232054.15778-12-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::15) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aeff7d1-280a-4aca-be8b-08dc28fca7ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Qiwd5WjQprki1UMkNheFWskaAjVwftmTbtkr3yguGUAVJDS8VS73+Z0rPB3c1FfwhgeWFCmv8CP/nKsBLR9mxO8B0cI9TpkrjMUH6cfJeeolztnYLSHe2TbC7IlYbhSuqwIcZE2JAlVy3IFOA9LyoMuGtOpshKTZAsmBHq1L3pL9/BjoPMZBtkD5BDjCsDv4kcsXXmLVGEZo5D22h0KpJ4KGYR3TNT03bnJtwyJt0b8g6/t6wG0hVD6ByGCwDRZyh5qVuaeX3bCqwLy3whdIA0qUlauskSCNi/qCOcVdXYYxioT7YkidOsqk1esF1KtUVJjIkS/nwUxllzRcpphJPcMtl9xSbKI9m8WanF8y+j17ESbqYgSWksFBRvSbvq7tdxx6FXSZQwYlisrDAVKE9SSrGp5r1iWiaWZPehXIcxBsZS5QRVGfOnMz7I66RAZTXdKbaLqpM92ixQJa//0fG3mYSkEyeer653XpJiZmTSL9yqBrXujPkOfQ5j57ve2nf1rwVamr9DG4bAFGzXw1M4Xfyh3YiFD3vSkM7NJUl1CsXQO0tH0eA0W9wz69McWk
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?YHNbREppSXqGvPmnUTtpaHRiA0ExTqtlgZqOcjfUuM0j6bTgwxgYggeDrZ7W?=
 =?us-ascii?Q?lStQ+UKr2e+2Reun4l6FBJ6IS5bln5zIaZCyuIH9wxZAmQea0dMSO9cv+LWu?=
 =?us-ascii?Q?XQfBOAaMYDVaBshi/xjbXHStePiEJuD6wwd0kmzha/6DamyYnScNFdIrEdgi?=
 =?us-ascii?Q?GmB5tAC6MMjjUQO/xEkRHsU9urAQE47+ko8u78Q9UOsV+6EL/0iUH9/c5oWL?=
 =?us-ascii?Q?LCH/6c3AkFoWXBvEvc1JR8juSeDHckxhggJNB/NQ+KrFTgWRWgXSQwqMKCYc?=
 =?us-ascii?Q?KqVbFOBgpej146wBAMPM3dpqGND578+xUdEkxAjif6eOXjsVVJWK9MU0lFRI?=
 =?us-ascii?Q?Dl9tqMXumE4Kj2h6CEuDFJA0WiCTlvCjRP0H8CAg1bbJilePJCnz/7iSvPCt?=
 =?us-ascii?Q?eZz/0dnB/erLsLhBVT6C5SYtWfWUd/0Ul3CrM9fz4boo3bAidvRHsfAgMx2S?=
 =?us-ascii?Q?KbMQkUC4lbjLUZ7B2voET045OAxEW9GdnSP/M6BPJs53XBpCzaGHbzvCio9U?=
 =?us-ascii?Q?NBuAUZsiRD3Pc6QQ2y2hnCfrdKpJS8j8cN1rY5Fcn02bef6xGk6lQusiADct?=
 =?us-ascii?Q?9JEki9CUGgDpKZcOIIt8FihjMmaKaDNZDMusMDRU8pZO3mGvO2zYMuPNQ4te?=
 =?us-ascii?Q?ClEVoyINI7LLy7wIc21Qz60mMm5ofJry1HpWzAKjuqBteIu1IBtTXAlfZqH6?=
 =?us-ascii?Q?BNc7iApf9Hga87Nwt/YTxpEAcJhd+IPO1iVdWuWbKEE6RP5sI891bc63ItkW?=
 =?us-ascii?Q?vPuh8qhEBgRXJLovn59oVwgAh3AVlnmrMpk938v8trh8zVYDXdcFV9J6xpXx?=
 =?us-ascii?Q?5RQIco4tAn9f1w5mrlZEIwc6Rj+hgYb+gQfTK+Vmop1evwmH20fg6GsfkE92?=
 =?us-ascii?Q?WlYsIcDkVg7wXG8Zbd0l6GHink9v2xp4I8o0AgmZ4XMJ290stoOyS3voDrFP?=
 =?us-ascii?Q?8+L++/qrSOxh6KrDISpE4znrWriIpM5OegYwgjk/X+yvJdduRCzHnHxXdi+v?=
 =?us-ascii?Q?u40wfGs97E7M/bBQ9bPHsGd1hM8ebAMdoCgqGLM4Gs5ZlNyoClUd/+tb162y?=
 =?us-ascii?Q?0OXB0lxRm3Xx4zDt0pBwU27aiRQo9WWUcxY9YDrb35RRWJOQV0Mo1kvVCxbg?=
 =?us-ascii?Q?CuNe+y+QG3PRBdJK+/hYLcEwX80V6DDxjVyYOYTrYfFmBYeINSBB4Mu9v3Di?=
 =?us-ascii?Q?ZSJxZZsuiT64btSPTTY/5e99+w1bZLqnQ4gJWD5U+YIN8MP0hs+SAS39WJzj?=
 =?us-ascii?Q?BWek2s+4ICYKoZmjNzjsNTeJOQVAQzLpJ5b5du5FXV9nlWBqEKzZ95lz4dnZ?=
 =?us-ascii?Q?eXT+Cg1mVvS0PW5D8b7xoy0bc78hpRpvkQcTCPqYGmbprMOplVaIVAU5q7oj?=
 =?us-ascii?Q?MxY86i5/qCkzwUTyxtAR61IYdIy53q6ByVVSjXcup2fWQ4J05PX2PTl3tm1L?=
 =?us-ascii?Q?HrtDLPCqrapibxYkCNmdCf8di0CoMliH+L1axU7B/1xYEt3dZfiByGYMA6cC?=
 =?us-ascii?Q?tVivrHNpsHJICt7F4sBT6cWRKLwSQOarWGumfbwL5AODbWPdfCSqKwfCsog4?=
 =?us-ascii?Q?zGaNlN2JTgCKNcdtNsSZEYrVDumeA/ja8IowpPi+fZ/hFnA5dIehbk5YB23z?=
 =?us-ascii?Q?AVrFZdlL+Gmfj6BwZrvPnuIFRLZDC/3MBpGsV1SWi/yBtgFjXwhclaGUuHGH?=
 =?us-ascii?Q?xuqIbg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	3hOE1SMXx+XwS5OPtrEyNyZsJyxfo1lZOPQcDxU9qVNN1v1xHfNLk6eLK4Nnp/He+KJ6ZQpL8vuB7zoPrD6EO2g9Xx/VTd0eBOdkx+wcXw6zytwmqgjcV7c29isQ3TA+UHxno5HY5gd92XaOIihRxzTLM9TN77YNgmCG3ux9R9SDvmLPtiCgNfd/iDJobFZSo//WWBjFD13UH6bgTMztfOmAoMQ23/q3NLaMhBtU9EQMuMZXAfF+x4JPsVimu8+qphf5xsPxPTQr5jnWxjPr/BSnnDhJPEQ4GZUlaWUq29xdn0crde+Wl7BcKTFOAJT+nQ/W9lobgazQWbjhwL+wweHqrt3OFJMLBMmQeshl7+Ca+iLvnJOFf4TYzaI11XHR2+UmpRKoju7Nt7oUrHnnNczSBl2wRxYXgfqdetj8NcdA3YBzSSrvcHU/wZRaJZWjKuu1or/MCKSHSSsXACE8MsfTr5i03ai4PyFrAM4sVfLN16thHf5mUU+4PMqFJ+N5Okv1iXyG8dnx7blxP+zoqtb4WpmTLSgLryKIaIoDybTb30olA5OhqInwI0Ojoz1ZD+cpM+8brLvdqmPpF4ro/Gg/JS3UI6xSxxjMKy0R7j8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aeff7d1-280a-4aca-be8b-08dc28fca7ad
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:19.1276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TGEamXF27GSn/mkbXV6KKlHTs4iyeFyXUIEL5Ifl9UUcjCo+2nf2TgO/3+CBCgEMZvR9ZFwGVcfRchD1Ux8E1PIZ4AjPR2W9R4GC6kyXovY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080132
X-Proofpoint-GUID: FNq8SRvHVftwOhZw1TqjoF_xRMSCdzUG
X-Proofpoint-ORIG-GUID: FNq8SRvHVftwOhZw1TqjoF_xRMSCdzUG

From: Long Li <leo.lilong@huawei.com>

commit 2a5db859c6825b5d50377dda9c3cc729c20cad43 upstream.

Factor out xfs_defer_pending_abort() from xfs_defer_trans_abort(), which
not use transaction parameter, so it can be used after the transaction
life cycle.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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

