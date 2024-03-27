Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA5415E9B;
	Wed, 27 Mar 2024 00:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498394; cv=fail; b=fSxIqIqFYPK4MakPAFpYTRLpzXYYHd3Uom1fl2ckhF1PQOzpGVUYRi52oN9nHzYuXa5Zbv+/IvTwgIkgYmrM7ErOHDCrtLANigS8VYxA/c4WPXiImA5flCwcVrWaX8nkuQI/DvHDp9xC0ZPQ6FeDlfIPtXCqX41Uhy0+X+BHBdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498394; c=relaxed/simple;
	bh=oGhuoMep5aUfdRAKP+b/XkFZaj8YFVR6Vf2PTH8Wi00=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SBuOklqPc9mMZC1+6V3rTDm7SlsiaNQKgWLElIZu2qa/mzvUTzIpCrr9+xC70/gfi6s2opewH+secaDOP2Ar8d5G9MXIIeoe4LMJChzFDHJRiSIR9bh3hx08Xo/NgbORMHSTLaBDwUvgkzJXURpkF+yr0hrAGd6BgXUxzIYp3XQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ltLivQis; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Zdr27Nnc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ltLivQis";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Zdr27Nnc"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLkgbs021513;
	Wed, 27 Mar 2024 00:13:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=vqi9SAHOyEwUrtGeoHzO75yh4+qyeNGLpEPP0LmIp3M=;
 b=ltLivQisylgLFEmZHVcYjzPP9EMMKVrRPE5rpfjL4rxJJkp+zCXYYBctUne+ZlVC6/QD
 IBondcV0vUjMySdxlH791cW/XMzN78hg6QuFGrVtThEKJK+4GX/MifPuPTe2zjbUTft5
 LCVKoc7U4paibM8ldCtOPay3RihtJu4qOhQCUj/PEftNxHqEHN0heFEhqPsdl/zPFf54
 GpWpdyUk2ViARBlgHNYq8symosdqsziIOJJ5QkfrUXvSc/nbCetZdJKpVo9bWOAmqB6U
 Cdobd5xpgt0auyHeTUoEW0SEcwDVYZKhfTkkm3otrR2DQ014an5UCYS87+l/WbN6sJxM cQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2ecbx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R010AK020682;
	Wed, 27 Mar 2024 00:13:11 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1agv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJfSnLvszhyhkzWb6warw+p4gXIvbdIREz8si4PK6hZjgNo6TKngBQs7VQWnV/1NUXph4pUo04Ambl2CXedXo1a6iYnvpbsHSuxZfU3Z8U6onGzLlcdGhEY9IOM1Z4w8+ifOmKv1l4QSLwSYps1PztwAJx0Xltsl6bSETRHTj5+IxN8mtmR3oxG09pNAHPyKrMqDAyy2kMRJ1l0amdOPR9gIzteSWGAbF0tY5R5gc+ogyrM0fL03Wrxb1V4quMMaieHpJNmmFV7HQ0/t6yotUrmOfn+y4MwPYepNsIeqPYgJi+a5Nn6u7vzK47Sf3IeoKsmjN+NVGzK27yXJUHHMXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqi9SAHOyEwUrtGeoHzO75yh4+qyeNGLpEPP0LmIp3M=;
 b=l/ec8eT0EGx0Qi0Wst/FtH1dr0O38nd+YtAv08gpuXsWlyZ5GbbGZXaymd/PW7wqjweLYM3IYE33GcAey33Pbvh8p2GXTXOOyLAeY/DQV/kWxcwGZEKz6DfUztjzSsTt7zrtHW6BnzQdPnIn+J3wAm3/TGkBGBh8xykj3CsTgL5wW8SMld85AvoYwUhDvETQUooiTo7pxAuhRQubCCj4I/rsuME2mWvdue8lR/+HHqiLrqQPyvEM6R26p/AYcYCPe92ZutVYNKpfGEp9jqNl8xdv3xRJy7rY7eeqn7zTSQ4gZ/VkhKYRwnm0HmvBgZYJMN561735sBTjQh2jnZI3rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vqi9SAHOyEwUrtGeoHzO75yh4+qyeNGLpEPP0LmIp3M=;
 b=Zdr27Nnc1HOFHwve8riHJ9hZjikAI3IpKu8z2PWSUtW1B78W+coOrapnuvQiflmB45j1JSnBMXNYVbibnhpgJBxuMZt8lEg0zrtrng8eTOfjxLyHcMvuYBvUP1EGaLbRxnHeidYMmmGOgmrdgapcr+OI9P8zYYfQqsazXCcWh3o=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:09 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:09 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 13/24] xfs: recompute growfsrtfree transaction reservation while growing rt volume
Date: Tue, 26 Mar 2024 17:12:22 -0700
Message-Id: <20240327001233.51675-14-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:a03:180::18) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	ej70H+mNBDEsBsqEveDmScew8MZPDoO9tX/X0Hc+mwZ0V2dOCW6L0EjZb0vB4BSMUuiKDngts36ulHG/fyJ3gGak8J2Q/8GTb3ioqa415zk7+RICGXREqbf4WQrsjGsvW2B9Qsfo9YwxkCT6/z8au33lr63IIa7jhUJG8BtMhoBqU1SLDmSwLL7Pu426059+ar6zQyEy1TipC6fQ8EEa1LSvJqi9FtAvEY8qj/G9yVvUwgo6rDG7WEmUPeGLEZ29uPWVndu0jWMq8I1prfojkyU+lSKVvaE6t80cy/O1xdkZ2Bke40h3GRqpMWmsuy4+g8B+T4t2j5tOS58PD6LfuP1LpcNO3HehY94XC19w6eVtwLSeJvvNVsbUvIJypSr9fcK4lVpe+8kOyUSYF4Zw/+PoRwhuQ0gMHu1qTF0OokJ6F3X+CDw5oo+8UC4KP5vJ2aOLVVrKj3RGAN1Uo8dzuwH0/bM/sp+HYsp5glnErkUY/z8nVHFE3cm6O05FV/wHbaUbmzo3WBHKRHLZzrGJkypCXADBWNPkbR0XnmcPSBIH580YZnDX6mf3ZITXUj/WC9XmPvfeiNQk61HNmyuSekvFIoFqZCuK4awMk5+yrqzpXooNuNYruRELyvlsWqsJjfu9cCMR+T4iVxVbxh5+mEQLQWGiK+4Xe3vZnPEWEVc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?7AajrLDOnNMw8YTHBT3iPqHBrolN8G9X4jJfaqF+WIlspPCnDEyVXR5yBpu4?=
 =?us-ascii?Q?h5nkYwtXWfuCJ54aVJTQrmt13RqdnEdtYh64lFQ+077jFOlrJy/1TU7kQejK?=
 =?us-ascii?Q?J4wsOLfIYnn1JtR9cr3wCtQnfvoXixVbrz8MRqlUSPDEiKqS8pf8sXF7IcRP?=
 =?us-ascii?Q?/bc5OrW4GwwFhNhs7cqIJnIWiZt4UWQgaYCwPFizgiCdHzgSCx96hgie6yja?=
 =?us-ascii?Q?u0GfsJg5aplc4BCCMFEsbqaCLxxFvWk6hDdn9vWM0iSMADS7bCTsi+RYuC+/?=
 =?us-ascii?Q?XTgxUXLbGRo/eNyC89nGNu++v17vnpX8AfK5pR5Fc/8yspKK8PBFP9uzga0T?=
 =?us-ascii?Q?8LMeTX83uZb13/GEMKKeXfU8d6wtO1822KiMt2qmViCQBsufwKhcZWYjO/1S?=
 =?us-ascii?Q?w8Hn1UKpwM3lLQtXRRfl3EaVM8FYUNy5LpC9od3ETA/H/lBHHm/3cQ7vHttQ?=
 =?us-ascii?Q?VmXVyiscNz5We5PMiHpnfRIIj8hDi52XOBKTZKdv1n6ahcOmJQzONYo+eP0W?=
 =?us-ascii?Q?Py2tnyXu1AeSk4GaLfwq86K3pAut4/IAZ53pt6nYnYqXy5jelN/k8ZxFlBOt?=
 =?us-ascii?Q?8sEnIOrGv37M79+d9Td+D7yuzm86eS0KoEp3st7vN9yciLfG9eUbPYJk6rUi?=
 =?us-ascii?Q?jaig8Qn2wxq6qQTfzcYM0iNELE1bXIqGLBykVxHoYisnUUAexD2D6NI5c2kJ?=
 =?us-ascii?Q?F88Wf2SaAhn4myNZM1de2s8QWt+P1C8giyfsKY9pSEZiry4wXREdb1ox2Kmj?=
 =?us-ascii?Q?PKidOhT5ogNzKcSwdpH9v932X+zWrSBI39/7o9yfKYK6JKuBPjgRlFK4+Ol/?=
 =?us-ascii?Q?y17p0zslaILNwt/WGPFAYonvLqpSLkJLVvK8Pd1y5i8Cyvm2E6CdW+0xNv+7?=
 =?us-ascii?Q?kdTxvnKsa0w5Yv/VF4oXoPN+g3R1B78zbURWE0x8kRSazWTq8s6t1hEB0FhN?=
 =?us-ascii?Q?jCz5f4Oi7w56f0EkWabNXhxEnA6vBub8EfVA9OKjw5GF09soCqVz90oeVqSD?=
 =?us-ascii?Q?fYcYWuDeNkiQY97xghq24PYeQds3dDILsI+Tf+AaTSgpGj0gEW2DBQZzb71F?=
 =?us-ascii?Q?6vOFgBaVrzjB8/V+E7P3Sgg56hSXZ0tf3ndl9KgJh0H4JcneF3wq/qPJ2H8Z?=
 =?us-ascii?Q?sE638TDdqRSXZ0mL+iYfQlUSD61Z5L6bhyBCDQkzi5mRU3qMzyYVnUG2aIos?=
 =?us-ascii?Q?8spppif5nwJJ1Z8dtXyc/4XPq8a8BWcKyL1Qi+lQknoqRmG7/0mNvcjA6cXQ?=
 =?us-ascii?Q?h8SeYmq+VnJ+yUT43gxhx69FbfvllRzVnlGNGa/EnLmqDp7GFCmqp3UJI42o?=
 =?us-ascii?Q?aoEdS6EUvhdDZgBP2Mb9lMQoHyPHqr8RB1eYGl7G/8+Dx84WHZjifwXVBVPS?=
 =?us-ascii?Q?QyCLrTddwWK6A3DsQckPQ4OxH9Fipm1z1fg+r6AoIfjgE8hCxx7fNUcnKnLw?=
 =?us-ascii?Q?hxcV9WcwkDAbLbyW65/nUXtJWxOtr5+8YfUoH6jm3PUMHoUXboj8u8CK5V5N?=
 =?us-ascii?Q?R2LWCE7HsVPuKXf2qNJSEyRgKdUfYOqu+NX9PicZJlwQkScfaOnLh28xvJXr?=
 =?us-ascii?Q?FBtTdmwzMTSFJ1MyOo2uOnSpoBHbzGgJjbLJGNlqlwpxQAsFiMZ0SDiaTcGH?=
 =?us-ascii?Q?sfGl9lpP9AdxMW1sEMMW2edsH3tGwMis3Cw4gh55LlwS89OGZTAaQ5CNXoI8?=
 =?us-ascii?Q?r9gdBg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	kwjjYZEfqbtNGS22tKoB5QBT1+E255x8vAYlAv1sF+Ua0F50LPvtE4ylOIATIlahUUwYLxmrkHRo2yEacItEKQ+WvHq8TmqVdjU6s2vB8iHF63udbREZ4ItJjPm2oWWNRG1fRnBZB2WvgixCmewcwvDkyW3WJOliyp4K7Jcjl4ttzOv/TZEP6wqeE8xmqk/ZV/haN0A9T9wejFTDTGRDmySQD3NS8Qoij73waPQD9fYw/b+OAwrc+zbgxETfP7Elb6V2QBInqfj2DJlA8xYEfNlXRuGL4QogUPYTYqRaEfh2nfutOi9gNwUkmYHsUBHjPX6knu2ID3uQzhGaP4Grh8keCkMss/+utCE8AY1lV/uJi04Y+MmkqL4woqg+yZwm+sN9ovO0Z8dNMdK10J+f656bwoP2qtplliI4SUj3kKzjgY3yAVkniS1z2WwjnQxRVakCP4m4nozNy5+mVV4SQ6a8LAM4voRjER+fAstRKsz2rNX53M+DTyMWXdz4apu7DAASyStw5/O/DZZPQh5z/eWGbVnwqlorzrTAtWTgTd0bhF2F2lsOP6YfYICVahYzgREa51+G/irV0SK/x2NwtOIzY+L3zvD/tBpOf3FD7lk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4292157c-5928-4b97-8c5d-08dc4df2af30
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:09.8231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pJ9XpKRFS4IywhuPvhtQVdn2ojIsJuMfpLHJPO4OH4U5MyG25Gd50Vfuz3VPuEVz90aRJjQfaOCtUBcny8g3JIuObIy/se/5S96R2dTB9Ec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270000
X-Proofpoint-GUID: 18TMvx-D-O11vBVkPR-BtX7_ljeWyunI
X-Proofpoint-ORIG-GUID: 18TMvx-D-O11vBVkPR-BtX7_ljeWyunI

From: "Darrick J. Wong" <djwong@kernel.org>

commit 578bd4ce7100ae34f98c6b0147fe75cfa0dadbac upstream.

While playing with growfs to create a 20TB realtime section on a
filesystem that didn't previously have an rt section, I noticed that
growfs would occasionally shut down the log due to a transaction
reservation overflow.

xfs_calc_growrtfree_reservation uses the current size of the realtime
summary file (m_rsumsize) to compute the transaction reservation for a
growrtfree transaction.  The reservations are computed at mount time,
which means that m_rsumsize is zero when growfs starts "freeing" the new
realtime extents into the rt volume.  As a result, the transaction is
undersized and fails.

Fix this by recomputing the transaction reservations every time we
change m_rsumsize.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e5d6031d47bb..4bec890d93d2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1070,6 +1070,9 @@ xfs_growfs_rt(
 			nsbp->sb_rbmblocks;
 		nrsumblocks = XFS_B_TO_FSB(mp, nrsumsize);
 		nmp->m_rsumsize = nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
+		/* recompute growfsrt reservation from new rsumsize */
+		xfs_trans_resv_calc(nmp, &nmp->m_resv);
+
 		/*
 		 * Start a transaction, get the log reservation.
 		 */
@@ -1153,6 +1156,8 @@ xfs_growfs_rt(
 		 */
 		mp->m_rsumlevels = nrsumlevels;
 		mp->m_rsumsize = nrsumsize;
+		/* recompute growfsrt reservation from new rsumsize */
+		xfs_trans_resv_calc(mp, &mp->m_resv);
 
 		error = xfs_trans_commit(tp);
 		if (error)
-- 
2.39.3

