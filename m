Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E74F9C8;
	Wed, 27 Mar 2024 00:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498384; cv=fail; b=Xy0/Bc0XNLOXYjE+m+FBhTSBc5Ycx7x+G6oba9Fbs9qhj0SX3NTTaheYSCyEqZjGksxBK/wByYHn7oOrYvDPiLc87FRjX2nsAI5VSqebdJ7RxxSt5gdRrXv2R9/Wqv4DOcqu5vRSTbmkilm0DM11loY4AxbQXL5febBl2qNYZ9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498384; c=relaxed/simple;
	bh=VLqJMxv+spxylycCs8wDlJLJK0PgGu8TTIGckSHed/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mvXj5IqcJcl+GILldqCS+XHtDfHmo8TPk4BLH0WIJ3rvE3LufSB7KdYs8l9HO/OImBsFrnhJ31fDh1ZSxYEoD5CM4nja5mCAtmCM9BfyGEEb934KdaC6BJXtk0hwSOuE2LyluudK/d7T7JF64SfPv78ikm94IsmYzLg0BWirVxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cfw+G/9U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VVtv0Pve; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cfw+G/9U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VVtv0Pve"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLjlAZ019151;
	Wed, 27 Mar 2024 00:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=zg+iYY15lMbTJ3Ozfjfo4AD+6sMrod1KsW+LC8LaH5s=;
 b=Cfw+G/9UjebqC7itLTvYZdCgUcTtmZa3HPAL/VrdhCcMyqznxDE6+fwxalpQgBzf8D2v
 +VY661zKkQbRvqW8CNCqVknjjSJ9DTZE08iemnfFe1ELuyhbMlEH65urAyIGnT0tkueT
 mENqT75qNBlJVxs17XGGlNPRL/mrutKDnbhLloOhyWxVGwAdGJaiNzO5KvgWaxzJ8Cd2
 9L9cN68VUKzPKdsDMkGCtaAgXDaECXtB9a4K6yHulSG800i7qRlaNT0kOoWwKwnFr1FF
 KVZXVEPVXMt8iNEV41LRKp1aOUbweXIBRcqIGciXdv+wV2RERvqDXvTNpKV8tNO04sF5 JA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybp8af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R02Rfd020876;
	Wed, 27 Mar 2024 00:13:00 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1ac2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAjj2ivQeuDDUO4ze7i1XD4sg8EwVVD0gsrsQPSFZ1uDQ+Fj798zKl4qkVoNijtwTYtxBiccA7MD4gjZV6aynAt1TfD5QLIeCD/b8OsMNogiAhaG/D3AyykHdS254YS2+ydyNiKmNvQpwYrgkqlCop4RhKIKtCzahHt3dSeJfVXP61Ffp/hba0Wf+SBXD6HZb9oQIlbjcoWFkKDhS4aVgrZQh2dfM9su10bNeLE3ePfzaVUe6YypvvhVXGHR/ZRf2Ei9J13FVQWOns1m6dORYrK2+ZEXRRtSZcgbW80QDv4RyW9VBNnPowcZh/qn1DY3U15CfvcNoJ/KtqieAkWb4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zg+iYY15lMbTJ3Ozfjfo4AD+6sMrod1KsW+LC8LaH5s=;
 b=jGXim/Ab4OuynPqBWCHGMWyDWKeDnOSzCAW4yG5gX7bcbvmzMuOH0TvwLbJe1AcjCIzQaa+tagSpWF55b66zG/yiziLCtHrIGb7Hvbgow4bwR/K8KzwbfMUuozZy+UGdwq2Rh6iKob2EhSBFlU4Y9j4gIPICu17exZqv4bgr8Lf1I3Xnz+hznVPpta80rvZn4O22LdA8klLdBVxopqIVr+zTmtq8yAwLo+voHr5dxJ3kXPphy/JLRKYR+gH6o0Fi+rddJdPC7n90XqLeZuJgzeif5UzWPyhjj0XxNxIWp2bJIr7Jg7eg9L6trQOIyBLwh8ed9LoT+zssYgHwcY5ydA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zg+iYY15lMbTJ3Ozfjfo4AD+6sMrod1KsW+LC8LaH5s=;
 b=VVtv0PveMwnY0IO+ph8igYqlrBE/JVXzZcUGdQG7lVH7c6iGamJZIybMLc2uomlVWJPBEBaDB+5RGD+v+jZ/AwTYLmHS0C0qa8eHBcig/whKC6u5SH99twSZVdaijZPwRhqPYmAfl4eG5fAxOzBBSHQkyIxSmvUxTSyN+PUuECE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB7533.namprd10.prod.outlook.com (2603:10b6:610:183::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 00:12:58 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:12:58 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 07/24] xfs: transfer recovered intent item ownership in ->iop_recover
Date: Tue, 26 Mar 2024 17:12:16 -0700
Message-Id: <20240327001233.51675-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::30) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB7533:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	V67g3fqH1PdTUO21l9w6IlZZoGrxoFT93e/MDU5JWHvg9T9DfsPIJqaN0v8KQbUK7/1droRda0a66G1Rxua+kLDVZAAV5+S+9497htqjIC+X/ospBRwZJIzmlBTUlw7YO6ARjvNZenogw5tV9YyW+0BXeXLlmMdnEGopDu46mr4WYth+iXPRHdfdqTYtehk9nQDFXKyH0zQ4jl/6ImHVturmR1OZgFX2piSLtJd2iHQ8xAYJvFTv1Rn3xsZ3JV38Vx/KxR/R+KoN2+74xNETD9C/nTMgY97zcLu+sWQebNDqVeASN2qB1ON8xjSXCQhbJ7RpLqClpd7hJJosJ39PE+hog0OGb42hIy7NjxxrLqQ5Ks8YI1yfYHeaEH5lh/6ri2VDZ0gormsP8RHjUzW82NWar759w0UXJ004PQo2NPMCG8OauCR93CHsWuoMXExj57UMIXj+TBavuAtiW1wW5KlzyN/l7FpOlsK/+w5awkgt3brvCOwKhbNkyUwb4LCS3VLOmvU87kq+lNdUJLzjQcPtSSFrs33pjbFJtUGZti0La1Srd2PQ/HxD+22Hj6rnwyF2ygDbHCkeNxpbBMirFoZ8RCbUch/fm/aUfU2CMh2a0vZArZCysQeB/SAKtZ5XSeNchPlZWDuvavLqffyVVT4yGGO+caKRVDTl97N4c4U=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?KGTfl67kPe/ZPi2mgyBjrxMU9hw2df+VVYnXcUpUktjX5hnTfBBd1SHJH6ee?=
 =?us-ascii?Q?jkec9fJ7hk7MpVBB9ZNXUsRiCFM9pZzWRaqAkTsbSjPhy1S7uy9QDDtwuQkQ?=
 =?us-ascii?Q?Xvr01/lThJm+t15c+/vLPEtANcLrYhPgAnlvN+ivDyiF/va69XcQyqUQuVjK?=
 =?us-ascii?Q?2I+pXwp4uMBmHzTwPBHs/PsDJrKzqHIPlEBtTK1cqhAGiKbDsadpP2LrHP0A?=
 =?us-ascii?Q?ISa7NX5O+rNYAKJobHEnPngjcPEVWsSenSX4BOlZP+X/xE9LBMkl6SKi1x2w?=
 =?us-ascii?Q?FzgMcDRFjptMJYIhZ5fR3guBn+C/ifLDMMlPxhEJt0uTeQvQ+vLv2Kcicxjr?=
 =?us-ascii?Q?FRJXSqjee1L7yOA8fX/oqPs1Cr60gzHqt+iFMlFT9HRbDfyHDpRoQrNwcjMK?=
 =?us-ascii?Q?VZXACPHDd8SpxbTjIophbmNFbijsOTfHrudEQJwP6v3RdqWFeKCHv3M7rnuy?=
 =?us-ascii?Q?Fc++hV/ZV/lP4m3DjDGll/YVVEmjaADRCgvIiuHKRoxiDc7W/cf/aKecsQDL?=
 =?us-ascii?Q?zBtoEucNHP32FD8q+UiKdXJYdpqZEakaf9mOvB7rHlVnI592Zf1lPYB/toQB?=
 =?us-ascii?Q?dLQeDOvyn5puwzETZfViKJlDdOw/hiSlnreyaRGOhIcM5cudXZJTsI+hAbCk?=
 =?us-ascii?Q?Bs7SnecfaHnTN4AbhcV8AoUEUA9KiYgXSVi/3jEDfC0o1zupv0cOK2CaGxSv?=
 =?us-ascii?Q?yVP/PPPw2SFKjieTaQfarI05Y5neLMfsfs2hUzIgmejyn+cTc0nRCzEh5cx6?=
 =?us-ascii?Q?EAe+RhlPNske6qVcyglJv+9+/+RFpVvO7B4GEqy3UXKOAGtLh+++yPdO3fHg?=
 =?us-ascii?Q?siJ64iE3tGoH0xmopnnKmCG4+FcVAGGGS3r8nlWY1bXsN7IBEUYKAI8pvlas?=
 =?us-ascii?Q?b1yFzDcUnZSUCSGZ4hceONBB33Je6T1iUnMmKPwwhDiAo1mG5XNBS+rWAj/T?=
 =?us-ascii?Q?LwhP6qOGFU1hlk/QHLwTqnlVDgHzeaoTAbPLA60RA2pDcYBdrFxyCyNUzald?=
 =?us-ascii?Q?N++SNKXDlaOt74pK1YlpzOJJAIKP8nrY8Lw0PKXRFlIqhdtuwlSfi9wo80Lt?=
 =?us-ascii?Q?VinRonlKE3lYBIAzOBdaM3dY5qnIwW/6SNJdxH6ROqLs/hOQ6XBg21uXwGoy?=
 =?us-ascii?Q?NM0NV0nMPg3lhFs0X+k4WqK2oBTsXzpcF1K65Q1Y8P/XcEfe9Bhp5ToikT2d?=
 =?us-ascii?Q?ZqCSrzTE+h+40GKVsvZf6f0Ltuf5h3DtGZBVTb/Y3T/L6J/8jHIKYX8WbwnP?=
 =?us-ascii?Q?+ZyFLPS7llOzRo4x+gYLTEFw6PqM/bQWFGnSdslVuveYsdaaDnKStAXu6pUG?=
 =?us-ascii?Q?mrJQxsG2+WA0R4zqruz47yjpZxuM3I6xVmCKk1ATYzlAKa3P6H/k2OOy6gdF?=
 =?us-ascii?Q?Rt6TdoYXcmMvrNkvxLKqr+ZfYkVegBkJD2IrVCh5il+e0oz+z4VBJyfVZzeL?=
 =?us-ascii?Q?18hTKLvkdOGAC5oelLbxP/JFM48B0Hs9eZXoyxMqizx40VT1NG8pzRJvO7/i?=
 =?us-ascii?Q?2j4ioufccoKQuAVO7QAtRGWKK69TsliB7dMsDbKxw4WOe7Z9vtxZX7YZssA1?=
 =?us-ascii?Q?pfvisBCOCGoWicQ1tF2SjJbIM5vlvKKA9sNpSagl0tAP/xmmluAWpS6C09mS?=
 =?us-ascii?Q?BLwd82rwUs6kJ1WEzQVLGaO0NxfIWqLJ6VedaONxAJKG9W4kuMry773kjGG3?=
 =?us-ascii?Q?W7+Iuw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	d2MHOPpJb+sfC7SW4nPxFdCJftZD13n3nwpaYJoLcGQKN0gqFKTo2EYk3x87dHnKl46HbNMedljJYo8OByNY1bPEUjG6tjTtbhCFbQ4ZZ5hjCphd0stoGwOYTzwbIQjSbybJFiR8VBsLM+CGwJAoDoZy59rfiOt017hNQndI3IGTpJ5xWTNlb9JEbAKHpPnomzMFIyj0ou+wuENlOZN402oOUZGhBy2yp+j7k+ku7x3gc5AERgkvpNYlVpUta6Uqd3kWoRqVuUFCX+u8J6tq7YHHXbSEhvN9xNqFT4hGmUYlYNQawYayt+W+SXgDgLEsSwNeWttmihdFaavng5VXX5+0qA/Jmd1kksixjpq6YDOsf80fiqYNgUlQico3sBl3WIIs+wGkXmIVwQZuMFVO5117zOdn3Vfdf1TScYkJjTcXiR2t5MXMN89pnwKugqhrufmVU1GWS6tHx8gqIOV6trZVEp0jke2rnGiZsa0XS9oP4kC4Dvz9glH90X56puIpMfVIwXgGJLRnKx9LF/0mR0dt4V/3wkCXwrq0dJPXvAZh3IoSHdzuBpRVdXY4rkX3+DWd58richJ6wYHUkbdLg8MdlPTYJApRu/M8V5dOppE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca87cc2-f65d-4aeb-2b32-08dc4df2a81a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:12:57.9341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQUaelrqMxPsnKxHUX7at1tMBvp5Kee3UM4msxNYeyEWs9msdogfBr+riBDvLdRoDQm/oPqtYpFx2KeYye08XNqGUydWScUWAcgF7pqbxpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7533
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270000
X-Proofpoint-GUID: 90BBcDveVNcjDYLK6RYF5pldZME583z3
X-Proofpoint-ORIG-GUID: 90BBcDveVNcjDYLK6RYF5pldZME583z3

From: "Darrick J. Wong" <djwong@kernel.org>

commit deb4cd8ba87f17b12c72b3827820d9c703e9fd95 upstream.

Now that we pass the xfs_defer_pending object into the intent item
recovery functions, we know exactly when ownership of the sole refcount
passes from the recovery context to the intent done item.  At that
point, we need to null out dfp_intent so that the recovery mechanism
won't release it.  This should fix the UAF problem reported by Long Li.

Note that we still want to recreate the full deferred work state.  That
will be addressed in the next patches.

Fixes: 2e76f188fd90 ("xfs: cancel intents immediately if process_intents fails")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |  2 ++
 fs/xfs/xfs_attr_item.c          |  1 +
 fs/xfs/xfs_bmap_item.c          |  2 ++
 fs/xfs/xfs_extfree_item.c       |  2 ++
 fs/xfs/xfs_log_recover.c        | 19 ++++++++++++-------
 fs/xfs/xfs_refcount_item.c      |  1 +
 fs/xfs/xfs_rmap_item.c          |  2 ++
 7 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 271a4ce7375c..13583df9f239 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -155,5 +155,7 @@ xlog_recover_resv(const struct xfs_trans_res *r)
 
 void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
 		xfs_lsn_t lsn, unsigned int dfp_type);
+void xlog_recover_transfer_intent(struct xfs_trans *tp,
+		struct xfs_defer_pending *dfp);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 6119a7a480a0..82775e9537df 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -632,6 +632,7 @@ xfs_attri_item_recover(
 
 	args->trans = tp;
 	done_item = xfs_trans_get_attrd(tp, attrip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 3ef55de370b5..b6d63b8bdad5 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -524,6 +524,8 @@ xfs_bui_item_recover(
 		goto err_rele;
 
 	budp = xfs_trans_get_bud(tp, buip);
+	xlog_recover_transfer_intent(tp, dfp);
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a8245c5ffe49..c9908fb33765 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -689,7 +689,9 @@ xfs_efi_item_recover(
 	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
 	if (error)
 		return error;
+
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		struct xfs_extent_free_item	fake = {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ff768217f2c7..cc14cd1c2282 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2590,13 +2590,6 @@ xlog_recover_process_intents(
 			break;
 		}
 
-		/*
-		 * XXX: @lip could have been freed, so detach the log item from
-		 * the pending item before freeing the pending item.  This does
-		 * not fix the existing UAF bug that occurs if ->iop_recover
-		 * fails after creating the intent done item.
-		 */
-		dfp->dfp_intent = NULL;
 		xfs_defer_cancel_recovery(log->l_mp, dfp);
 	}
 	if (error)
@@ -2630,6 +2623,18 @@ xlog_recover_cancel_intents(
 	}
 }
 
+/*
+ * Transfer ownership of the recovered log intent item to the recovery
+ * transaction.
+ */
+void
+xlog_recover_transfer_intent(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	dfp->dfp_intent = NULL;
+}
+
 /*
  * This routine performs a transaction to null out a bad inode pointer
  * in an agi unlinked inode hash bucket.
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 3456201aa3e6..f1b259223802 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -523,6 +523,7 @@ xfs_cui_item_recover(
 		return error;
 
 	cudp = xfs_trans_get_cud(tp, cuip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
 		struct xfs_refcount_intent	fake = { };
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index dfd5a3e4b1fb..5e8a02d2b045 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -537,7 +537,9 @@ xfs_rui_item_recover(
 			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
+
 	rudp = xfs_trans_get_rud(tp, ruip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
 		struct xfs_rmap_intent	fake = { };
-- 
2.39.3

