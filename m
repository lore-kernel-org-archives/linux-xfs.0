Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D86F9C8;
	Wed, 27 Mar 2024 00:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498387; cv=fail; b=gy/LxwUJ4skem5HIMruJ1MVcSlfOZjgIxLWvoyszUSuqXBDJz802dMHEnCnOkAGP/r/YA1kHIlE+6g/DY/oe7kv8Hi0FQLYymOv/NGEvBNG24iukcKVWJnfJH/+ovxMlYV5jCfL9bvojyrByskaMXarrrnmxg/B0kNqMOqaMaYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498387; c=relaxed/simple;
	bh=hsBufX/JvofxonXaenjW/x16ElGY+007ixr8k/ukHt4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aeWflqYVgcsI8c2jC7pbK3HtTBHOWKabCa63t3xIJNrUCz8j0gUFnol7hTD1+KS1jw50OYI5VOygDxDneaHNE7ccVY/4WsnE/YEy5YVDIAo2zxpqirttOFQnyVZvHl1sn4tFDFgd3c2s3VPz0WfHDSHwlysmE/JJNaxmyanSpnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MuPxeFKY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E+mNKq+z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MuPxeFKY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E+mNKq+z"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLilFt026106;
	Wed, 27 Mar 2024 00:13:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=29qRJIMYDBxGaDnYuXz3EkjdAwdDIsOtdboR5xQDEFY=;
 b=MuPxeFKYGg1UBa4U5Us8Y9ce/0z5UtsO7cL7iomD3CYe3nAqmT3K9sNkLt3N2s6XvuVC
 W7dYwr9V0K0PzFgT866b9wE2jI4VbAwfYd1PN/nTc+3W9PHgYhQmCl8Htm8NAKyE2spm
 9zgrCYIv0oVqs7UZVYSAyRhLaokXm/iJEpAuqMO8c8uRpdYoIEz4HZ9rn2CCN/fItTzw
 DnDYOUZV2Z2vDEBpPXKbuWcKMD+8c0d3yHySHrln8CI5hh8F5ttTvM4Oj4os6AI0sy5S
 QZSfZ3I8DDg3prRfvvynCEGd6mDccC10yvCFBAU295qRRcEQjDlwwLL/a4WrOODSi+2t Vg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gvscu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:04 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R03cjE019720;
	Wed, 27 Mar 2024 00:13:04 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh7r7cd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsEaqQ7owJa61kczlbjHGdvOckHPiTcaizlcG4HJ3F1TZOTuB5jrz+ymBt0OZmym/EO/d4ud4Vyt503mtY7eC4qy8utEg2F0e6OqftaXMKVNQv0VIvbaNR/TyVMrxvf0YT+w/tt2mQKO3/NmXhfzNB6wh/XYRu86+NlcJ2VUlmQaTwDa7O+repXbvsOW8UeOUyKySe/dCtEb5g/UDvSEbD8gsu4f12R2A1faykglftFJKjcFO8b/BRBze1ytY1vxRScrx5xQtVD4A01RtrZ3cLIKfooAHSvKQzTZHp97xRZ3pb8PvWGdWXW1v4LPDdgCcYWMazM6Uyi7PuOm4lrTSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29qRJIMYDBxGaDnYuXz3EkjdAwdDIsOtdboR5xQDEFY=;
 b=jeSQAWDqsd/IyhW7XGFDtxJ53xpXlfZmaTt+YhSoc48OfyHOjdTJv0vuv2goF9+sMyXzfntv07MugDWeXD66cBq2iZHWv3c3Vbf17IQxHrP1nC5tG0JZVaLqhL00eKXM1GJp97vXlaTf4wa1/NHVEOTVi2KtwfxGg8PBQghr6OsIvzKlgzHTveeG9hiaGiXGokvURMMZQDxq39zFIgZzk1PsJczMqtaBsTvVgqje2CbwV9xhGzNDw9dZNtPrGjponKDA0Tnd+4JNtK9eZHR7K82n1A6zERM4D8gsCgb+sjVeM0cphERp3VbPPy5Cayl25JO3GScWIKfYXacRMd7gtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29qRJIMYDBxGaDnYuXz3EkjdAwdDIsOtdboR5xQDEFY=;
 b=E+mNKq+z0naA/T0CzK9qCqK4NtJGuKuJC3Q8wkMvojDZp2YFe5iWSHkZ/pzgK3SQ6thHWO4eas/2BbOMm9N7xqjHaOuW6lH7KmYFenhCVrW2+HHWgWTZgTnjVCa/OF+A3qV2YTdLKnfImQOAFMa6U3N7c7EWxCOuFb8I329JKrE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:02 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:02 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 09/24] xfs: fix 32-bit truncation in xfs_compute_rextslog
Date: Tue, 26 Mar 2024 17:12:18 -0700
Message-Id: <20240327001233.51675-10-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:180::48) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	+n7D+u6S6TmFn0Zmklr05MGD6wbdljYvuxXJat1OTJ6Aafw1zmySuq9qulzSFfjUX1AeFro1tEa+IdSnN4HEccmgMAn4wcZNJ8NNKm5Go0+EVUytfIvg7lgMDdLR7CMNJHIUaNf9HQ0vePNlmmUpCRQBj44f4+aYmqeVZhoyd1TflMI62WSYxiYYOFNkX3St21DbDOSwgIC9pdAy0B8jZ4iTlhDQrPPC6WoywA/klzvgf9XWtbKnHjMuq70pRxF9ivtCBL6OimQDhDu+ICfCMh/1pZYarzOiyVfZRbPKWy4XC6cKEW0F7FUlg/JWrcsLotzzgE/8jYU/8mQvGrk1IltqDW6ywLW3T3IPF+T8zIEdALZbSTJ+zHktfGoihiZ7NIvjhEnoy8PAq6sjRhknoXNLZFfJcpv4iXjVlKYpWv0ArV79Ky5kBCMGl5D/8ade1AM3on3wNoVHxR96nw4ECHnPLpQcBK+JMBbbEjD6R8vz596pJ+SZ8nx05sLsqnNcdRMZrSwFUDNnGT27JAcoFlFtRqxa3NRx2KOQ/A3I/Axplt9H1pcNu/6RiW2kroFfrUIRR+oPf5ONULM7qOrqwICWZeH8IJCB7kuL3HcceLln5g1GzqJCcBw3yQZGI+BOYo1k2deVLFH/2pl7DXDAhELZscyb26gZ3aj/QGIqWrA=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?yR5ISrGyyBiCvwub/D7sLVOZf9aVYbI4hAD+MD4ZM1X5haM8vSTrDUvwGPZo?=
 =?us-ascii?Q?Ajvgb4MMDB3Ug+uMAKin7m0jXMoclwQ5ihOTEY7bYOkQ4eNj2dnmmsboI8nX?=
 =?us-ascii?Q?2oEJseKVcyLX2pqHVLXkA8cxIdJA/acRw+MKhmMRDDQ5nmlOv49IK5iYz7fC?=
 =?us-ascii?Q?Z+Op/kXc+FSAx2Ynd6BKQIcJY3lN1BpohL6M0YmeUBNmiEOvLR4FkAaKhYkB?=
 =?us-ascii?Q?SZ1wB9+ltAz/SSAKHcv8u8WbvjTFtmR3aLjyIGK5XeenXWEQa9rElQcNMCzw?=
 =?us-ascii?Q?Zs0hTSlpymqGz1zuq5AsnM7RSFTR6wSAavhpDtHyLzdSdg8M2pEA6eoYjTl6?=
 =?us-ascii?Q?n5HvoiEuGeQr/IPCS54z/ixtILSFmmWKpnaZjomeyYLpkR8WHwGcIKLnE1cO?=
 =?us-ascii?Q?uPlUdu5C2zLndcAlHA6ouNgGDH2mgWeZIoNlro0vIdAvPOQfvDwo5MJj5u0G?=
 =?us-ascii?Q?dJcf16MSClmrPz2KPzusyqjNDmpMheV4OA2gQSmugzo+dNR1QvkVpFhNRJ+/?=
 =?us-ascii?Q?igwhu+OH56BSonG9opkwu/zBvCtc5Kid1Q5MSdnJWGMP7sHchiqsInWX2o1P?=
 =?us-ascii?Q?NLCQokH4YGuU9clRPokokJL8mrA70p8fkqcVzwb0wxqtxfPIh1chvL0WkAmt?=
 =?us-ascii?Q?9wI6wmuhpmeUcKdSYZXqtvxDOwItN9AmKFtVnNBkeP0n5NSTF6VmdAXD1nYd?=
 =?us-ascii?Q?3lNpgYnVN06VwK/BxZVlwzXoJUix3/mtVgBarxLnqnVFvuU5bNEM186IuCAD?=
 =?us-ascii?Q?O+4xWq/AdfdNJMlS/QxO1ptjqM//m3EeqPUQClQJSO1ZD4o++qRxth1ireO1?=
 =?us-ascii?Q?UDOo5V08Qhhb04kSB1lK4i5xTjA/FO9kp6TqNpBC4PyDx4kL5jdtg3F9qRY6?=
 =?us-ascii?Q?9Q0eEtRxi9rTMRpSBwtkc4zYKVm5R/ysrwYVhqi4C/AeOXGIw5akdTmTXThC?=
 =?us-ascii?Q?bIvkhs1SFZb2bDoZPbDTpPYXJ6nS7zxxK3dGCA8/AjscakZVq0wofuKaO2SQ?=
 =?us-ascii?Q?fQ9ideH9QK7IB5UZDuZOpBNSJ3m6rUM2lR+Uhv5DyfAFbNj1y3xnt/6C7KaN?=
 =?us-ascii?Q?v2zWhTxarsR2rD0Rugbz+PPDeevGj8gG7DRjH4QmDbipaDGQ3sXFWq+ZvVwH?=
 =?us-ascii?Q?NvPOI0PDZ9uNQlGU87e0biIxm6rvj/Y1rpRX6Wf7Lvcw+PCLH56EiWelfsCC?=
 =?us-ascii?Q?RksBGi2Q9uYqxly3k/3zi6Yfu0Rvg6iiVTr89XE8MaS85ZQd+7RmL1M/yoG9?=
 =?us-ascii?Q?TZ6dg8+V/kjnqrY410ZSuENSoRd+z3NzjX8G6qcE/TFYcBWHfG/DcNjKrXyt?=
 =?us-ascii?Q?AYWYgd4BZLE0dljP87JJDKTWJzUaxi2+a8Jq49mUOWVzERPByNKm2vGffHu2?=
 =?us-ascii?Q?xN4IsEsFj5Qf58xFrN9Q4scUp5S/4pDTIyrIrjkYH4v8DvztQ4efk/SDOpYA?=
 =?us-ascii?Q?mhGKFLritO25QGPUXHz7SuymWjjpQgLrrHB762WV4jsrlMQyMnyK9ORh7CLS?=
 =?us-ascii?Q?gp2KxCpW28xq6pC3UyAoCYxZCB45e6B91e9uQYcOtFJno6DNhBKhgx/q7SH7?=
 =?us-ascii?Q?KQB6DxuWv5GYWTaUtHbZKMIC88mc8sxtHeC3ZDhbg6W6Q1cTJw+/fPmKYoa8?=
 =?us-ascii?Q?DpUzQxq+TVBe5+UGLU1dVtqd1V8XVEo09rLpt7TiXEUSG3hIzdYEYu0EEYhl?=
 =?us-ascii?Q?jaEMEA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	M/NIN86s6SWB5dh2sZefUcvcdiR34wBrNPZptRflgoIFSbxRXjlNrWlXXVkyT8OU/zdE5JILQBbjEkqbnZDeNdqJOZeLBNCpZxCVJboGcrm+gcRhseDwdc1FCVkPstFF8up3f3N9edWO9Su4TMztKVTPydYoAadw/rGn1mPt/IqganCt5JcWKv9TJpyEKUUhTxQ9uSpXLILCdcADe28mHWkyCYB7OTzkqNv2lYPK1w7IzmvR1ScczeXLmiWrpzyyhgIKayWR1TSqVstdYTOYdMUwt9tsdzmK+Bl5DoifI85s9Rah+gJkH0a4aylSHlP5GzuwVMwdq8SdKTLFwhMUv/u/h95NMjXc6rkrzdYWyiRWKHlTmePkyasQ4jBWIyry43yHv5yAG5slrR1YTSnYABAIP+jtF7E9at9Yxt1OQDBclDnO/IRMhBPXhcEiqr7BMfqL/oMdnZuWbWhJV/h+CzUImqT6WUiFGOO1CMVULkWTudUNOrZJOSdwZ+cQihgRAa4KraSmK/sEhZYVwp9KBXe4RinMbpTLSGuuGYXGGkIxs5U8Oo+VmJRhQT4gD2h5Oetgql6SSfLsojDuP8gHBIcArVvBKI5N1SbGHqiFr1c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff09d4e-4184-4caf-1d4c-08dc4df2aa63
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:02.0381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b88+faft0AF8sNdQJ7oX+CID+aEFpTdEi+8xOR29rm3B2mMsw3jbd5OyDXbxkqAxrlpNox6wsrthQrQzIIiPplI3oc5/o4CP0pyFCJDn8hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-GUID: Kqx9YnY2rMoXo1Dhi25RZiXqrmMSeUlA
X-Proofpoint-ORIG-GUID: Kqx9YnY2rMoXo1Dhi25RZiXqrmMSeUlA

From: "Darrick J. Wong" <djwong@kernel.org>

commit cf8f0e6c1429be7652869059ea44696b72d5b726 upstream.

It's quite reasonable that some customer somewhere will want to
configure a realtime volume with more than 2^32 extents.  If they try to
do this, the highbit32() call will truncate the upper bits of the
xfs_rtbxlen_t and produce the wrong value for rextslog.  This in turn
causes the rsumlevels to be wrong, which results in a realtime summary
file that is the wrong length.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 37b425ea3fed..8db1243beacc 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1133,13 +1133,15 @@ xfs_rtalloc_extent_is_free(
 
 /*
  * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The use of highbit32 on a 64-bit quantity is a historic artifact that
- * prohibits correct use of rt volumes with more than 2^32 extents.
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
  */
 uint8_t
 xfs_compute_rextslog(
 	xfs_rtbxlen_t		rtextents)
 {
-	return rtextents ? xfs_highbit32(rtextents) : 0;
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
 }
 
-- 
2.39.3

