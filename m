Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F41E541;
	Wed, 27 Mar 2024 00:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498376; cv=fail; b=ezzBB4l1MhUPjFh/qKjsEFs8pTxuFs5RqHMDXqkgQx0avos7q2x3fkDmHQ31MDKtli4RNE/VlkfhZMhZvN55zM6N6zDONn/9F9DjXdrq07ZJsEnHjKiGCLzvULODi8hZ1cQIAFJCUqEh0+kjQLd0vm90oYAuxajEEiaTFJz4CDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498376; c=relaxed/simple;
	bh=UTKCA+hqoLNbHHHT4DkJvMLVTrzhNwweJIWiXl8dQMw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=frj/AMZNDVAWXtetD6UguCgPB3OtsRWSvjK691/Icc9HfODUpVMDPvUcJ/xmrBLDKgwHcg84VlknYV227TL484tzVKp8sU45fLfIEZ1C4KyQYCQLMGZ0qMlANNjYnkJtHk9jGJxBsaLvTerzAGZcgD8NIrIB6WsMHH5por6bgNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KScMtij8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TJ3I0SlE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KScMtij8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TJ3I0SlE"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLht8M009776;
	Wed, 27 Mar 2024 00:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=G6xt4v0+UBF2hVICHAk0LsKGuZGF7Mi+1z+Kgjp+XqQ=;
 b=KScMtij84mfm/eX0O0BiZK3+INompwQAQO0cuMlbIiOtW3YSA4y/85LlvxL4yYG9NdRO
 KbSQU0QK0UJ7W0za/3Rbiwb+vC2n6L6noH1oY+BndwJdR8tj40wguqEqyMnB5q/tyz0H
 GxfnLDoPyuULuSt0ViCT8lXqPy+kZYdJasjpfufqKXfoGjRO1USeftNme9OD+4D0HFss
 uCc0oZJ98w0XSMjHAJ9EMkHG8NdRjnMORjbRBd0kSeJC4I9DI/H5clesMPRPlIJCy949
 PLQtBf/bgnn4W487wvM6sxaGWPyZUpjIQaF6uj1FQA6BWWShm1tSa8rXQDFIColwkyJN gQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2f6h57g0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R04A77004783;
	Wed, 27 Mar 2024 00:12:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh80hqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0lkSYGss4fGODMCXGh3hP58a/GO3Qvoquw1S9lkinjqTGeDi8l3u8CpOh+fnPp8tpsOv3HjhGGBQQj6et8kyUB5cQTTK6lcMdNkSvnfmmOHddMPUH8QrKe0gqz5GU/yXpgV78Rkv5Oq/XDJ9nMUPMwbf17qQ2Od3AmhaZgQ4Okt+6QWWU5rf8jYT4NF4QlPZehdjNBOZb6qiOE+YdgSsLost2qpYzB0t2CLLtlUF2YFCxWabCp37ldoOW9Q+T7r4C7nsFnmd79oBeehm1cfLDttUiPAJmGn7jCvoLrjwnANZh+Gu476qKdZjnBH7OACl/DewQTz2193W6rgpvQ3uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6xt4v0+UBF2hVICHAk0LsKGuZGF7Mi+1z+Kgjp+XqQ=;
 b=b/2qUMBXE8a6ddjbHMgE7u54k1UO/+TzIuca/S2hCVUZkpzdeeKT4mX6bzkwVQoe7jvr5YUpvWzZS/KofZV+IKyQofDeMDKQd8XZ1iKIgTTLT6Ni60JB4YvxX1H/wjn20rspleZu55b/vIcdV4fke9ejZ9RGHMI86h1i2Lhci2WE2MzsFOZOYSNQesrXWhcEsVk77JRdvp1d8eSwsbWWOEClkwwH1Gb3fTJlK7FaM7EjQ4s9EnFWl+Lfv11e6yCPCuodfFtAnp2QdEhDUotPw9+SB8a+5bE3McfX7tR16OIsyRNa6Hob3JsHSUlSDCR6pxSJq48YICLwVofpoeZrBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6xt4v0+UBF2hVICHAk0LsKGuZGF7Mi+1z+Kgjp+XqQ=;
 b=TJ3I0SlEMjjpt++6gADLCTDHuNwUxyn8E/RsZ3fCE3SUTAgXpOvrcvnhQy4FSBV+iY/OwveBwyrBQgoR8BwcATF84QdNzpt/uNqFMRny7d9o4DfKClDJt3rRjF+g1yIbBSqqz7HNXF+4Tr1+8eC8H8ergsd9neMrX4DH8jsXyW4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6226.namprd10.prod.outlook.com (2603:10b6:510:1f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:12:50 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:12:50 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 04/24] xfs: don't leak recovered attri intent items
Date: Tue, 26 Mar 2024 17:12:13 -0700
Message-Id: <20240327001233.51675-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6226:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Rymzw9U+VcmsflmbnWACG02CdLTL8oWPl1pR/lwdgygq+epSFMWq53DT1l4qQUst+W1lKB9meXGYsu74vwvI7hYPvkkb6hai9ucfCbHilhziT69zp5s+AjaoetfZ0Y97Vz8fWKapQYZ0DHbJX8wi7CRR4AGE9PGDwM2j03Ab8/MURBdr1KjAaJmzxKiIywfG+Z0xyE5L8PFdRSx7H2MqF+1mxBatmllipsq0ufx4DR1hAdEJfqvYk7rGl4asQOm2J5mZUxqE834vWrr0zFHvgwdufKSbbSP3kbYQ5SxSSAO4yLcOiLomMwTgEhTNHQ+bqHvRojr2+ZG3555BQGweFin4BZp9p9t6a/UenJInXReo59BrVJctkXezGHzBX+ofV23hOogLheT8+Znfk9pClPue7mwZHU+TQrixNiu2yv8FUvkuAvQz78763e+QzQ+sq7FVzywUgbIEwAB9D0JtGVZorojD9RCyAwkkRoRLvl4F40VA65mQXClOUH5HxMgrHUm+fUJAWhI2gDGL0Q3Q4r/p0bmYRyxMYO3Max6oa18sWrHnw43PpZ0yYotvDRzQjC/KBXHa7wYNfqeKHy3QGDGZmsC9vSaAWdHtbdqTkqMwJiS0j5k3FeDvdlZX+zSrZ1YxggGCdLJB00z7j5c5RlI8A53/rZQu9er42J2vlZo=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?wo2gTZ37eqVeCl4xxypkd/3AQNcj8zMqtk7WFZdgS3j6zjC4KkdOIXn3L/Vi?=
 =?us-ascii?Q?CewJPvOt/E8g+79qZ9qgu5f2ntEUD6MlHTHUn8qzG8CuYL9vzVwxxOk/7r5L?=
 =?us-ascii?Q?8PSTqs7l8kz6jCxtefdQFMty3BDG02ROoHamwbcs3UP21F+JFMIV27glGiuH?=
 =?us-ascii?Q?iuS4CeeZ3pkBur2JJId8EVM5S/Ty99uS9BBtt8x3vPMGTVf2IPxLt99sFGbe?=
 =?us-ascii?Q?XDNZbGhE287ST9ynx5XEoVKc47wXczQ8XnKvs/RA0QPttVaGJE34bxpXLLX+?=
 =?us-ascii?Q?lV0HYmFv1YG87CyRao4h3j0JJ5gXwAUWJUYgFkPIgkqlrbHjZH9s+WGJAGD5?=
 =?us-ascii?Q?jZxTPD5+GPiaNkEizRdPNQE5eSpEX7h1mfOFrnP1CLKqiuIG5sD+1p2kFKaY?=
 =?us-ascii?Q?GpEq7OLoqBqNeuSiQNe/6KUk6w25nkL90WOY64MT/Y8FqUeCjU4BPOAvYFRU?=
 =?us-ascii?Q?P8OtbUgDEo+MliTY802FtNikbV2h/3WhVI03lXmp0iGDgpVq+WA+ZKsk1E5h?=
 =?us-ascii?Q?FQoYGE7rc1Dm5Du8QItunDDiHBDPySxpflhQnrg51h9OpMTC/sP4lwq654yc?=
 =?us-ascii?Q?nnIfHzs1A8HvnkzJoPPkxurygFMeZE2LEs2it6GZ0xKLxM5LFVGru0wRHaHW?=
 =?us-ascii?Q?sggQ+ro0WeGYPMVQF29Sf7gT+T8M+CF9+aM4618IIi7CgS2N49f77DHY4/2h?=
 =?us-ascii?Q?YXnCSmpOYgpuMD5BLdW9jt6kgSEup5tx1079ja7SZmfezadnCGh+Bp2Saddf?=
 =?us-ascii?Q?8s+M4reEAXAlL8tUuvnY7LW4+Fn0jhsrefbYQo475KWRk1jB+Kg8obaCK+MN?=
 =?us-ascii?Q?Bf0Z7pfkKJHUfWzlwffYs4olVD2hosdOGHa07vwNuKRIg97KizzMNp1HfuVm?=
 =?us-ascii?Q?kw6GRC6T1hQp6rOwojNaYOFRDA4NawSv71cwdqrgfn7d/py8n5QFyQUjtgNw?=
 =?us-ascii?Q?hnuac66PdPpu4GZ2t+oOFv+VNmFfzBbVRbov6Fy4L29DWs9tiWXj6g9i4HO7?=
 =?us-ascii?Q?gdEIHbpBFSbIw4deFXoIhSqd/VlkWgoQrgKrZKVWSePqqY5duEzx6vIWwjR+?=
 =?us-ascii?Q?rQIO1ZYM0+y7pBjcO2Zc+7iE/p4zzev4K3wQJRL8HzMp/u3sSeqe0mL1omse?=
 =?us-ascii?Q?WGi8rjn1B60qfHfwNe9h3BeumMVaQcBXFAV0yLAhPo+UE/FpxU3F759tF7DI?=
 =?us-ascii?Q?yVV+qDVe7KD6EW6Xl/gqC3dnYfAERcE/oU9Tax4z5TjsDO/uDtXC8hrdgfqC?=
 =?us-ascii?Q?Co586MbAFNXFRAQ7Jw8igNrLkSVWrhwu56eoll64IsS6/bmO4e6Rw85xDGD7?=
 =?us-ascii?Q?1Yy6G3R3qo8O8oOW/DxGewM0ZNVnEeLeWEs5FuBGBLR3nKOOdpC2bwbKfHlr?=
 =?us-ascii?Q?81b1bAxBhbkm42pbMQP2MKqghE7aysNsCQITk3oB9qUToaIMVayMVxJ0hrTO?=
 =?us-ascii?Q?YIgdxkUrbXkwOFQtdd+SVSRwIp1e6hYNJMLgJjiLXQS5D2IojLac692A27Q+?=
 =?us-ascii?Q?WPHEOEW1egXPxYAU7Z9JaYoxdlOar2ds8ArRvUeFqR4rdT+u2U3eLxOVLBQc?=
 =?us-ascii?Q?fgnKaoyt2Bk1XQ0vskHH7+Ai5NWN9r8BGa29lZn814wgRA6C9IHGvZ89A38p?=
 =?us-ascii?Q?fWjTdRpWilrDAIyurVohzm03Kz/uPL0FmBFdd+KbZTUvuzzJlca+YGKCJVWC?=
 =?us-ascii?Q?pv2buQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	SNu7H8b+F8LIKVvRp1qL95RQMBV9xUIuY/Xgv884oXale/1/MT2JF1wCZiD7k5OKrFMOR38f0fx8Kl/idW9IN3TuMpeNPVpwpolDhvTwixYHFnlyJhNt6MWd5e73HMdl61aoT2IDw3/8LGq5BO1B+e6jNl6dY60Kao6sBsqfEo871e1kaqyGU0oDFw0GRCR0KaD9w3po6vxZkSFIeVsKqnj6mbLvtPg0uUcl0exhf3OsXNTIWGR0t2BLdghHTEHeuCyqCDZrxk6X7OKbiaoDJFZ96PRZBV4t6FaLl2IA38R0UFV0Xf1z+zK0B4lwbsCnJ30XoMDe+fVPMVEyvSeo0MEFrvzX0xQ1qpbsUCeMcUrLZ3+R4fQn9idI+7q4sfxK51QfstAlMKMrpvdea+0tVovLeLEKxa7GvsRDG0A5j7CoVtCOXGWRzKes9RqtOd3/MJyeJkdvXSzSg2c3U32Ep3HmoOyldORkM3VUdGKhXzc3Gf2FH2l2bLS43qZ5tzNJkAJUYVi1YM79W8J2q7cIUmJS9lESnjBzzFaYONOTc0YTgDmhh+uPdYER+ZQkDHkhiX6xBS5BWs6Uc5Djt0eli6skCaQQXCSuZCmHDY2HvwY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba23b338-e69f-44f0-97b7-08dc4df2a3e5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:12:50.8729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ZCkanX4VWQfYOUjXFjEEb4qEjtxra6u5sl4VeaBkwKZTTGMvHQlFQzzk0htVUfauXhBp2NQUanN2QLM5nxZJXTneWXT6Cx1T7lQ7eM9+ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6226
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-GUID: d144vslgxEHLLaJD0HnPcOjhwTvoHH7j
X-Proofpoint-ORIG-GUID: d144vslgxEHLLaJD0HnPcOjhwTvoHH7j

From: "Darrick J. Wong" <djwong@kernel.org>

commit 07bcbdf020c9fd3c14bec51c50225a2a02707b94 upstream.

If recovery finds an xattr log intent item calling for the removal of an
attribute and the file doesn't even have an attr fork, we know that the
removal is trivially complete.  However, we can't just exit the recovery
function without doing something about the recovered log intent item --
it's still on the AIL, and not logging an attrd item means it stays
there forever.

This has likely not been seen in practice because few people use LARP
and the runtime code won't log the attri for a no-attrfork removexattr
operation.  But let's fix this anyway.

Also we shouldn't really be testing the attr fork presence until we've
taken the ILOCK, though this doesn't matter much in recovery, which is
single threaded.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 36fe2abb16e6..11e88a76a33c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -329,6 +329,13 @@ xfs_xattri_finish_update(
 		goto out;
 	}
 
+	/* If an attr removal is trivially complete, we're done. */
+	if (attr->xattri_op_flags == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    !xfs_inode_hasattr(args->dp)) {
+		error = 0;
+		goto out;
+	}
+
 	error = xfs_attr_set_iter(attr);
 	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
 		error = -EAGAIN;
@@ -608,8 +615,6 @@ xfs_attri_item_recover(
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
-		if (!xfs_inode_hasattr(args->dp))
-			goto out;
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:
-- 
2.39.3

