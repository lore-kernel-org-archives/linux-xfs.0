Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCED7995A
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658299; cv=fail; b=WWDS5cPkFZGDkCCYgHw1ZfQTFfvNQ7L1EWuLzpVoNMDtUV2+/0Sat4JAkm92U5io78TlDX2dZqdVOXMD2d1rwUWU7qWdOspwZ558zwmR85ZnLDGMyq3n2KBYovrR/cwzH+J5vRFs+si0hS0Lje1jeoRcRZ4a2InVhKn2j7npYxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658299; c=relaxed/simple;
	bh=XOfbk8qGFuFL0GcUI5J89/40P/g1UrwlDY+n5vdHYIM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EBcH/Pxk/S0NAXs1MsCcciVqcbtMG/AaAFGTJeFI1/vp9V2FnAzGqNwrlF50auXmRLoFb+snaLoYUkJ/hK51o/Px3P6gYq2WUJYif30ZbwwCGrHWaVUr5Q9IenDFAeM5v+48vV38x54NGL9xxUQJkf7Ji2VD+ncW/2/P+tgduR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TSU1rcPt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DQLcSbow; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TSU1rcPt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DQLcSbow"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxPUN022669
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=QyCIJIbHJ97JEBUXH58a1kTVRpj1f5cqYQJ+rTYfLME=;
 b=TSU1rcPtun7OzX1dR+ZeQ+IHGzLkQPnhF+zPfqbhRnhx6BLapNcS7hQgaRyH3YxjWtO6
 kB5jMYmXl8EeXr2HDfDmHcL6UjglTvn2djwTinjcxgZatVgp9mpia30MPFjXBZzkfPTc
 MdXmZPdIXIhrOjJG7dookRkpPYI1pMbRhb3E6g1m6PKyOKrLRLoJ4PgsM7eKU3+dlJNH
 NUpOF6LQ6QFXnevUS+Ojodyt8xT78IbWOaAFyNOtokJSYR/6R/MbYST4hJ/f1JlEIGf5
 uwZV7ji/O+xB/QLjUQWrYuF1zrQ18KlefYglloPmLV8RfAkZ7IA71jpW+j/auxDE/DP+ rg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrm40eee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UM5M2Y007770
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9eh1tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArxS9NQi3ikLoGOYtVK4/R+ZgjmuRVzGd97xS7rPG2rPoJoczOy78mDIWUn32a+naO3oc5o1xtvAtAiedTFZOrLbMKAoK6wgvGJWbp/tYrzzVHrsbiqdRHF9a/WlmarcEtN7VrOwNKO4DLCTecJ9c8/6WH0FX/V12SinHXCWP8+ALqCPRLRsZOcedZezrhiyV8i/z/VrjEczyhIJg3SDVC80vR4onL0EXRAK4m4lM616ERdZ/v0Ibj4P55T8Wq8cjU9nVllenJpb3PoGkeQCWenFXsRf1e++UGYX/I9TLgqGlbC8IK/2qRdT7Vzst/XhvL8C/k22NEJ7vQ+CzO1tyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QyCIJIbHJ97JEBUXH58a1kTVRpj1f5cqYQJ+rTYfLME=;
 b=Rn1xbPyl2c3tdQvB+B7Ju0nFkOAOw9jPwqdNcVDcytJyiB3a0WAsm2EY/NHsIwERtfZPLTqUSjoRtBtinV/bpBBOVlXvW4whG6EcOT64umWe7pdgCP5bcvrjN9K1EHgKyirNW3FhVnjt6GU+1IM56+owU7YdD4k3PTPRJECJx5r0DKhoe0QXex5Q7V2zzfL5PAIhUPUJYM1aY0LGgjQCeQQh3mxp8mWuonTVGubOk/JCMxueDbbOjOPxMripWtY+Wl5VRQIwaoNLws2VfrkMz9OS9Uqe4N3kz1wB+6NZk1osJdFCym17ucIAUYdvmJjXjuTDyqCYg7bsIlvVcYaewg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyCIJIbHJ97JEBUXH58a1kTVRpj1f5cqYQJ+rTYfLME=;
 b=DQLcSbowKzEHNeBh+7zYdKcVYzHBLd+ho0V5zc0eBqab/iqXe5UXNKrd/QzqP/MR5B8sg2H/nAI6RSsSGvx54cyvYuBIA9/Zxj78WEcE6UWEepHI07D+yMei+prT4hRh0RyG92xBqnle4mEG/7RIF/3ZhWtHXPaFs/pDLEY0stI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BL3PR10MB6092.namprd10.prod.outlook.com (2603:10b6:208:3b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 23:44:54 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:54 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 16/21] xfs: inode recovery does not validate the recovered inode
Date: Tue, 30 Jan 2024 15:44:14 -0800
Message-Id: <20240130234419.45896-17-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0009.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::26) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BL3PR10MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: 5812f084-8275-4439-9a7b-08dc21ed756f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pJLfZx6+9aNE1nR/bqxGv7B+7waGhXzgIr/nbsberHgEKCeZbyWku4cYqg3xzaZZ68KeWEHG4e611QuKMaJavT0RHKPqSNmvxnc7AMsMgw+5gTCmghyRBcTAtZi1LaE9hbS93JSf+ezzXxbPZNUIxNl6pQ9MoPBwqTazCvorIyjRIxJ2W3ByxHjTuPeLT1Ks9YrnPiKsd9XpkdpOZwwJEfS/KOpXcZLxfzfkqwnAo/9BXwd9jaaY7OGm9C5CYPv8SL+JRtT3FgEG7WgjJJuVPOCtVs4T7N+fdkPDmWiCxuR+wle7svtuZ34F+JrZQisP4AbPDRm4J6h9DecTeWehIvhec3OkRRuwDGyEhMfDH8V3/GIV8wO6DZs8tYOasaVQYFN2sjAGjSmIVoI4zSaaBJxON8F6mbgrXvORxJzGdpfKTOhCt5YXk2W7q9MsGFlL6Ua89xp2fPOgyt1V1Jvp8qEFPqL5vR3ZQPAowy/kTtOiE9NPiaSF5Yqevqh0wxxl0H7S/Y78sUAm9Za8yDyDrICIPGA8qdiJAmMMkKkpExcoDXltWa+AaFgP8wFqGHNA
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(41300700001)(8936002)(36756003)(86362001)(66476007)(38100700002)(478600001)(2616005)(83380400001)(1076003)(6512007)(66556008)(66946007)(6486002)(15650500001)(316002)(6916009)(6666004)(6506007)(8676002)(5660300002)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?l780Tn5ifv31h6aHRQCGKBRIfTfXWdq0FpB0nEOtaq64/QSd1RfPbmOuNJMq?=
 =?us-ascii?Q?A3eX+t6uFLjXEqU+yZR1idkU/xWwZWldDWRVps22Syk7c14lovwke3jw6yHq?=
 =?us-ascii?Q?Hd6vgDmnLnp+NW0X80eXEvQcw1XIdCUlNHxIFZT+HdO17Jj6hW5QPR3skDc9?=
 =?us-ascii?Q?1t5B9JxAb5qswWvtVgxnt6wvTod/+R4yE1e/ZZvLTRJfBpVQOWsx206QG3nW?=
 =?us-ascii?Q?hNAqWKwaaiDl+5tFWHZ5SGdKHKbZ54PcUGCa/Ct+Pyp0lw0Iq+TCXdr6CEUa?=
 =?us-ascii?Q?PHpMKG6LP2HtLHVbaV+6SjJIFSjtg0m3SOtiHiQJyzmFV9MWomLkK9BEM/6H?=
 =?us-ascii?Q?D3edFuinCF6AzfYBBBzEyMLY8xLOn+tEfmLz3UUrf5W/cfOyMshblV7Qt8hj?=
 =?us-ascii?Q?cdRRhVQFyA8lAnbeytPZa7rsaVFFWSi5Am4NSft2C7ZHI8mUxO8apJiCzTCs?=
 =?us-ascii?Q?EgHFhIyjHnYh+Fo5cYUQiGhJJXyKR/QDWrQeF1zR07puESlX6gp5t7V0ZzH3?=
 =?us-ascii?Q?mRAIQj1IyytYefH1i5vKYFUvARchCWjYr9CJKXoHRquNN7SKoxRonOHSFG+W?=
 =?us-ascii?Q?9BRDFka+p5YmFbZZZn9JbKXsP8xyz02EaiVp5vIVqaXfiN6xXX6J00/abeZS?=
 =?us-ascii?Q?v/S6ndYqxTWA2NJdO0IzpftdmOjbD+FD5iAz6UTSEBM/C5nPQ9ood4QUUopp?=
 =?us-ascii?Q?QowBM6anmAx1dRo2GujjVJZIHRSuRU0Isf1gcYXcpCcqO3UfZR+aob95IxWv?=
 =?us-ascii?Q?a+B6Eas8sgqG1bib1XfN8qn6lWA6g6G8fHlqY1U6IkuUh9J9eqdUWx9zlsTK?=
 =?us-ascii?Q?MJ7klc8NHdExwYafE/+JDbhA2+8iLV/s+tXHlonnMTJCfRbrhz0yuQkqB953?=
 =?us-ascii?Q?sFsFidNywgBX4PWU2JEYH4zzLx/jrNIK+NRmV5WT3Osy7wsdAhs/C70BXgBN?=
 =?us-ascii?Q?1lrR7k6KraMsdWEc4XBY7kayA19T0wSqo96/OrPpBrElXBiozmolTsZb4IH0?=
 =?us-ascii?Q?4BSbCcSM8e4jRcwuyop13nnwvj01OA5r9xxZ8l7NC7GpSD7x+s4WGV1r0MzP?=
 =?us-ascii?Q?h0E502w4EYKWrF/ZM2OlwX+AuoQkwNBxVtguWhp8Oeb4o4YQ0VtMP1THRDXD?=
 =?us-ascii?Q?NjecPYtid9wHpIZirTxeVvDI8elu2R89Lj/G53iBBdRbxk6i2GtpacHZ0J49?=
 =?us-ascii?Q?MiJJ9sPAnSddMKNeyjKaOkYWS6eAiI0zV/prinYOTvelMRtin3xenE8egYRC?=
 =?us-ascii?Q?i4RbYyW+F1CWlB/xWwH2b3ROjDdho2UFSPdgqRWkhxPiEm29vp5Kwm0xCMmY?=
 =?us-ascii?Q?e+tV+qIiw6LimpapbshKsClXIoxBjUYCjx+0LIQQpAC3escIYmKal0sm7mBZ?=
 =?us-ascii?Q?w05tAk9eiTu1ghoECNx3jqpxly19RUOw93Luuv+4rkaaz5Ru1CPrsdf9qAti?=
 =?us-ascii?Q?2mhRY4l8tkVS2ODKKBXLkYtqXYvFrhnR0LEXQMRs6hVWsJ79WHo8u342aGU4?=
 =?us-ascii?Q?YmxBobcAvMglUzgVkEuAo9YUkMB0mTkcbRpODwg4s1GjOJSrWVMoW4SNeTB/?=
 =?us-ascii?Q?yQoPDXpfEsrqnfOyyhuX6184n2JB2aQ+Ro2AzkQR8BziPd7nUyz/vaIoRDZH?=
 =?us-ascii?Q?qf+w5sC+iiGmTUqewtXWosCyUFssbYhXjYUOShBxoYZmz2MfEjDbAPKJGOXI?=
 =?us-ascii?Q?Q+ctHA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	XBzEwGbLEBGtBNMwxyUYgldsAJWwyCNUBJZLk+72vGnoHdXq4nUkthXkgSlE0teGqAmszMRrNeAwWGBGKC4VcrssnNVA3binB/xK64lWAWru//u+GCK8KVQpeqtjkpAMRinarAmkH6Ih6cCiVKzJ15ve5TGDZWh5354ioH5qFBqK0jzzVtvq9J69aWaiTJadKXE73PGdpfTDoRaEDIHdbVhiuazKBqgC8bksaCj6sY2QRMCpO3oD6vwX+Gdlwa6gDnzeXvuuni7+Q4saUGdxxwe8VTqNdHQdfIbUUFRIKNhtQib/T8TzFWT5vGKI2acaR9pwaeLd782N3YZmfUrMtDNXKSLcq5BL9dTbh2c25I4BH8S1PZrS/yRv2LltKcaCUDjOq+bT+21f/4eDGb2FcfvrxkfEHY7AuOjlaGA4YZha9ITgd6gWhgUPO5x1EFszVyKiM7WeER6t22ysU6UYyD5wbHR9KlfyBXQOvzUfMBVK1CoMt24PW66iaNSR4dJF1HNyh1p30YLJR95bt0jt5xCfjWqDQgIOvUxIJSmuRvHv2uZVYy0pjA1fWRlIyRA/0xsw9cAThj69hv9eeiveEBY9N/6bOd2pZz3CYCAj+lw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5812f084-8275-4439-9a7b-08dc21ed756f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:54.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuhK4M7L6Va0HfLNAAwr3pYp/XiidYxvWOIrZ6fcnB33PnU3tCh+QOuyhHDL04hnY9pTV6gsL5/iQIoZ4s3aqBY8iM8R4i1C9XQOitaurbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-GUID: 1OavTny5snKnOZ4b5BDCAQ31nBxEjISD
X-Proofpoint-ORIG-GUID: 1OavTny5snKnOZ4b5BDCAQ31nBxEjISD

From: Dave Chinner <dchinner@redhat.com>

commit 038ca189c0d2c1570b4d922f25b524007c85cf94 upstream.

Discovered when trying to track down a weird recovery corruption
issue that wasn't detected at recovery time.

The specific corruption was a zero extent count field when big
extent counts are in use, and it turns out the dinode verifier
doesn't detect that specific corruption case, either. So fix it too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 +++
 fs/xfs/xfs_inode_item_recover.c | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a35781577cad..0f970a0b3382 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -508,6 +508,9 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
+	if (nextents + naextents == 0 && nblocks != 0)
+		return __this_address;
+
 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
 		return __this_address;
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index e6609067ef26..144198a6b270 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -286,6 +286,7 @@ xlog_recover_inode_commit_pass2(
 	struct xfs_log_dinode		*ldip;
 	uint				isize;
 	int				need_free = 0;
+	xfs_failaddr_t			fa;
 
 	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
 		in_f = item->ri_buf[0].i_addr;
@@ -530,8 +531,19 @@ xlog_recover_inode_commit_pass2(
 	    (dip->di_mode != 0))
 		error = xfs_recover_inode_owner_change(mp, dip, in_f,
 						       buffer_list);
-	/* re-generate the checksum. */
+	/* re-generate the checksum and validate the recovered inode. */
 	xfs_dinode_calc_crc(log->l_mp, dip);
+	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
+	if (fa) {
+		XFS_CORRUPTION_ERROR(
+			"Bad dinode after recovery",
+				XFS_ERRLEVEL_LOW, mp, dip, sizeof(*dip));
+		xfs_alert(mp,
+			"Metadata corruption detected at %pS, inode 0x%llx",
+			fa, in_f->ilf_ino);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
 
 	ASSERT(bp->b_mount == mp);
 	bp->b_flags |= _XBF_LOGRECOVERY;
-- 
2.39.3

