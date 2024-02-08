Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047DD54BFB;
	Thu,  8 Feb 2024 23:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434499; cv=fail; b=osNlZi4hak0F2sOsTz21ZSSwRWuRmba5mpiQL+V/CzXpzWzpCd0cygT3RC8YTjB1/m7YW2Tb5qJJtez4hNfCfLpyVpl6gSHUcd/RixP+awTWaWrKV2RxZfqDLd6vLwGfw7dKUR18w1pRhKSrCV9q2s4ptH2VO20EeLv1EjbaTmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434499; c=relaxed/simple;
	bh=/sdoiw8ss+92rdDcT4N5lH4/iYrZwGd7ZI0gBBHyj60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OSJNvHBvCBUHq7vWhP426ld6doCBkxS7jqvR3gTui5FBuQS++BZ85oQXUwt7bqJAiwvnOk11DkWvtzumGaAwBq0BCoSNQN86hkLTf7H7/Xk71e449zaxMTf4NiMw5NF6ft90zn0w7XTWW2lfVkx+RQf9TizUonTXutm1KjGSTYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q+r1lF6t; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v1CTJP8A; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q+r1lF6t";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v1CTJP8A"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LSxbK019784;
	Thu, 8 Feb 2024 23:21:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=71Ehvk+Bh43YCEt3IE4DM9i41YWgUkBWM1nnRZGPqX4=;
 b=Q+r1lF6tJWbfODWDUEVP2jUZwXS6fhyeT4Y2Nlwqhn7PcRKr9s0sCpZxC16MDWF8WthC
 bWSBTCoqv4yZK4HXz81w+1Jp/pjDeQINaTH0V/gtrWWWjbrwAyiZKD/fdRHmrZ3TWRZt
 Jc2irEjbrFXvwv69MCd74UsjWn2SiWZG+j3utLJObwrneNpn/4QH/B+kzpoR3bXdDeuF
 40GsWhlaEhbJR/NM39Hmyh1GALpu1JhriVrcWfmxFPAmfyGeSDWYZGaNIeF8lwkEPejC
 Va/QEhNOVct+43tzm78GMNbB1GIxorLrhQwiDa7E+VnBFwcl5xxrlxo1s3pA0oMWqK+4 JQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1bwewx4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418LQMjT019694;
	Thu, 8 Feb 2024 23:21:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxhq5ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PASxN8d4FnDzNOVasASPbcQ7S8Rx2VwsL8iKoxy9zaBzSL8UWpBr5YsMjW6KhrF1wG+xt6oZPqFA9+iF+OZx619GHjckGay0Cjh51GnO6RSftfRVXRgSgHb7qroQYyh9sPo/zSVNHNyZt7XU0OJdUYb13typqTsv0dESUTeaIW98nHJ/XrPjG/mMuCSZSS4rIMsuM8ew4SrT1TTct2jm/nKpKQK+kVnE03ke+n8IOBtPxZ/l+JRuGc2gK2BsUdAFfBg0in1rBwpmu5As3qAtfR1OmMkta0KXHWDozi97NqlTf8gHpY5tzNs8CLJd2g2W/kMrBkcXQkPHopehIczx0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71Ehvk+Bh43YCEt3IE4DM9i41YWgUkBWM1nnRZGPqX4=;
 b=IQf1ZEK8LIcLt2zhmmtDErTvdCwjnMODN0635irqT1lZz53o9twsoewywSJ+8DK/TdA7RKx660ofelQxBUGVB1B/g56ZHZaL/fUfFv9ZWdr/80qyGyCgTdJYbs6MWpxf6QJCbp3w+Sq9eyLeK7rHrnNomi0FYpcZmJU8QCLQqPJNwoMjXkeP3Q/Kn45umkNHbts6VJI0Jcz8ZaGf668MofEDMuCiuleNTHyTUPlhlgFkHbcq/yYlFLnm7E7xGqoUd1Q6q9uZUfwM7AyDF31FZSxHhJtsizvzfzOiqn90T9+gJlLnhld3Z2i6YSz08ZqybZA9eEq22ssLy7vpFm/pdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71Ehvk+Bh43YCEt3IE4DM9i41YWgUkBWM1nnRZGPqX4=;
 b=v1CTJP8AVcCcE3YeQXFGOVgVspFCM00nKrrDC7ZFOfYmN70yLaM3NVGxiH9KDTcuC72z1QweTMiJk6G7lcGXuD0nWrvkD8i1o9Zcxsb3/txDkidHxH2gz1DaMGgHVmmydMwx8HcogGZXGcU7a5Jau3cRe50irbvIdZoHcp2J2nA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:34 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:34 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 18/21] xfs: clean up dqblk extraction
Date: Thu,  8 Feb 2024 15:20:51 -0800
Message-Id: <20240208232054.15778-19-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0080.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::21) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: b86ed9cd-8123-451c-5766-08dc28fcb0b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	3MnRhSRH/JuS4MWx9GgPRb6usFHnvFp1gLEBsIs3KypfJGBj8vKuRJpYXbyW/kd3XUxefnOypfvECqRyXI/v7EkfyO/t69wqBwNPqf0B3GWdBpLsC05IjUatPRY4xL/YFMiBKoaWpEoc7kaNsVuCuVb9G+NUsD7wmHN3DvvRciW11VPFIMKqjl9ESxR2IOIsVD9SGoFKmuywVHgOKXJdCUeSgBksTuvTveTvh3aqcrvgX4CU2vXUcYCUV0sJFwXD45DoJi1CtV/jKWuETV80+ctMUq/Ij0zdAHZUaWowTgTOML+1zgLvmxoHCvJv6G7MQQGTfZ2rbVZSN48841CkGDmZO+fbpDJrOdMvkL+pJOUb1WZEImmx+yS3b2AeMcCQxPyYJsrS3Qzu1wyKpdIXgSEklZ3/BcERkXjmB+Q6tbLgzcE7LivFbeKvkxdVZ62SdifcA7oca+bHbhp7SBeQdRdo76A851lw++ZdwqA2Ka3lrUUOmZuK8GpRNr6NzCPpBwaK9qLlhQtcaNa6O4yGsuru3qm63QVwY/oS1JlTYqhV4E632jDAujvisiy6Ubus
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Bg3ePNB/+6hzti4sLrb/deWxsl67/Phih/ONt6iqaeSPVaT3/isd+D/G+59d?=
 =?us-ascii?Q?ACkpTRVpI1NgVgKyARW9tyZyFNNRBjrgixgknUo7fTh1DrEuFwA7Wp/pMnZZ?=
 =?us-ascii?Q?jl+e4wi8Ryt9AMpu8gNjWMTVW99K3XWpbtCDfxUxeofKuJQ4iH4jY+m2p02y?=
 =?us-ascii?Q?Bk02KQy241EtB7gNC1edD3eB6zXzaq6JuuQZ5P9jA0RItuFD2aDfGDVNPcq+?=
 =?us-ascii?Q?egs23ZNEPBVq9kH/1Nl9TAp1NnCfTjSQve4iHwjIsKGyZzEiaAfFqekEU+00?=
 =?us-ascii?Q?SZxlEiPuOt9VaICeomS8e76CLqj5+eYBIDOWTqMX8NPl3UsRyy+2HZpY8Mox?=
 =?us-ascii?Q?SkzODYyT/nRXT8dogAVwkTJSfjTtCbmygHnt44paXJduaaBWb+3YEaysY8p2?=
 =?us-ascii?Q?knX5tkK0AS1FsiW3Ik6gSkQcKDPZE1wicoM4NUr49Ifida8u4ln4p1E7LcJH?=
 =?us-ascii?Q?8sl14N/5/agX0fDfuV+MVU15V/O2v7JSWCv0vubDFaYW9irFKcCQXMEKnydM?=
 =?us-ascii?Q?ZMei63r8LihRsa5+YdFmsZ61Rsy7lwxt7dSmOxD2HTyouEzpEpcpXAeiGa7M?=
 =?us-ascii?Q?pDQMxLO+0GplSEhh458J63TkbeNHNOUGDARjQ+6J3nU8u6Mj1RnhWtN7w46j?=
 =?us-ascii?Q?B2+FJFr32egpQBnjAcdlLSJ6tB9oNU/cgwHqUpO0NWibkjsLkphWI+Iv7DMo?=
 =?us-ascii?Q?Cdg6JYYoXjEKoIqg+9xFbdVEYVNu8KMvKG7m6Q6XONAJyTqGCL4HMeS14+7b?=
 =?us-ascii?Q?KXxc/vH2l8rAv8FLgaUNWYPCmBJIRl3ojlLi6Vb3zIGe7ymYtQcerUE5AzPL?=
 =?us-ascii?Q?x90HJ8xHLbk1vmkn26XYA5WtaP2/81lb725RsdNgt6CwTm99Ig6w+HCOF7B2?=
 =?us-ascii?Q?q/i5uVLmdXGorfNMQKTXhcqLx09/PY4lm3N5hdO/EyMU4L1Y8AgcWlz9FrWz?=
 =?us-ascii?Q?raETWDW4uM3jKnQ9ME54/4dgrWdYH6+33c5kRIuTu67tjSOerQz6yt2ZGRaQ?=
 =?us-ascii?Q?vyaXuPkQhFPU1bZzBBlJ9oUYejzs4U4jwq+ogrIA0fmJ/DIhAj6LHF7fZWES?=
 =?us-ascii?Q?uE6q8qPccaQU5NKIwjqg7tuepeuBjyDDki/fjfeLsilTBDFhft1/a8P2/UVx?=
 =?us-ascii?Q?71dGcCC74FAdUTaKPsQEZACuVaWGsEOTM2m53v3LqaNpaJmJfPv5AYT7tIlG?=
 =?us-ascii?Q?DVOEpHK1+PAifo4cWG9uhJjRurabT/eZQP/7qdQ5nKGhJ6vhmWLyaXGW9Mzl?=
 =?us-ascii?Q?l77eBRk2ZJ84HaSKxumcByH8hnAOWjTTKpYmUNb8luGC28RG9/ZE/kOKxvis?=
 =?us-ascii?Q?Fyo5Lo4jQGlPydHrAWKZjt6F1ckEJdQzLQ31QJq6LBSZ3rTTUc6Ftmx9k777?=
 =?us-ascii?Q?OGY31cLleuqJnXEmlz/TniZTKEJjC3JBn4LIBMY3I8y6f6HLO2KoNCzYdV8q?=
 =?us-ascii?Q?Skyew6zX8uXVRlB+zOZcVSZquqwcLb/NJ4D4x5Lk7pcLogl+XlP8Mtw+bRV2?=
 =?us-ascii?Q?VrebcwuKmR4AQWl9Ic3CUTcdvYcAjGpNoLsd7vWivjMQNSNhGaNIn2HnMLG+?=
 =?us-ascii?Q?Ct6norbp7HGJnVt4ZO6YRzEr6h503U9HdsYfD8KXCQ3YHahiVJ9MF0A63iYV?=
 =?us-ascii?Q?6cZvUzOFlHi+6A1bY0JcwkBecg0VvTrTbYuL9C3odZplTBBRxrX90/8P3LjA?=
 =?us-ascii?Q?MN6NuA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	pnO/4UWblHwDYnaLvQwMSWjJXOvqoYr1rX/vajwDR8I66FW5XfxKC7nyNMqBvP/eY7p33FQ5IKew7dW0lZM/QOGDOHuqHLJlromDUeOn6mVfT3RrE1fLcGph+WKyBBbgshhPMJQo3kii2vjg7kNu4Zw1hMqgAHSD1M/Pkr5QXmZXKaKynzGeV6kw9iZZvbBSXqWxPBsaU25D7RYxJakoNwfuvzhVuwdRBiu3G+0XJXf5qWk+zEl0cc46AL4abXveXnQBnUcdzVtYXIBIXZZ1hQ8fLNAN5UiS+MhaS/8YWZsZtzpFJZznV0ev95NclHN9PyUEmPj79TZ93aJSVNdhhTprE5eXJKDkcfHLl6oYx7tX+SbX/vYiXT9Q5VFtdVCdEvKjxXQisxN+B3zld7GdtmD8m7wlMNW3fyko88q88vo5sWis2pOxmwwcehPb8LRki474mTH5nTrpGZUOvLt478V8HoVvFK2BdVHGwh7M9K0kwR9/KFxhZNAUiF8/VvuGHX7jWeRrY42ux/fOpAJw6TFMRCZdSYNUrE2tTKxmi42g5/BB6Uj15vAdSLhkc6QEvZUZbllHuakElsEs9QHv0J1+9QUu0n3qP58VCiTFBCI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b86ed9cd-8123-451c-5766-08dc28fcb0b3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:34.2256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3wdlabD3QntBLPSOSvH1UR0BzKcq5xwynrXB9eZH+uhbSqH6HVZwM3tal/7VeAdTricVLDDPNIpa+DswlrEWorJzquMwWS4sAo1F2a09gM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-ORIG-GUID: S9CZXWshwf48oHatwI58Ed4X4BQlY5yD
X-Proofpoint-GUID: S9CZXWshwf48oHatwI58Ed4X4BQlY5yD

From: "Darrick J. Wong" <djwong@kernel.org>

commit ed17f7da5f0c8b65b7b5f7c98beb0aadbc0546ee upstream.

Since the introduction of xfs_dqblk in V5, xfs really ought to find the
dqblk pointer from the dquot buffer, then compute the xfs_disk_dquot
pointer from the dqblk pointer.  Fix the open-coded xfs_buf_offset calls
and do the type checking in the correct order.

Note that this has made no practical difference since the start of the
xfs_disk_dquot is coincident with the start of the xfs_dqblk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_dquot.c              | 5 +++--
 fs/xfs/xfs_dquot_item_recover.c | 7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ac6ba646624d..a013b87ab8d5 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -562,7 +562,8 @@ xfs_dquot_from_disk(
 	struct xfs_dquot	*dqp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
+	struct xfs_dqblk	*dqb = xfs_buf_offset(bp, dqp->q_bufoffset);
+	struct xfs_disk_dquot	*ddqp = &dqb->dd_diskdq;
 
 	/*
 	 * Ensure that we got the type and ID we were looking for.
@@ -1250,7 +1251,7 @@ xfs_qm_dqflush(
 	}
 
 	/* Flush the incore dquot to the ondisk buffer. */
-	dqblk = bp->b_addr + dqp->q_bufoffset;
+	dqblk = xfs_buf_offset(bp, dqp->q_bufoffset);
 	xfs_dquot_to_disk(&dqblk->dd_diskdq, dqp);
 
 	/*
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 8966ba842395..db2cb5e4197b 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -65,6 +65,7 @@ xlog_recover_dquot_commit_pass2(
 {
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
+	struct xfs_dqblk		*dqb;
 	struct xfs_disk_dquot		*ddq, *recddq;
 	struct xfs_dq_logformat		*dq_f;
 	xfs_failaddr_t			fa;
@@ -130,14 +131,14 @@ xlog_recover_dquot_commit_pass2(
 		return error;
 
 	ASSERT(bp);
-	ddq = xfs_buf_offset(bp, dq_f->qlf_boffset);
+	dqb = xfs_buf_offset(bp, dq_f->qlf_boffset);
+	ddq = &dqb->dd_diskdq;
 
 	/*
 	 * If the dquot has an LSN in it, recover the dquot only if it's less
 	 * than the lsn of the transaction we are replaying.
 	 */
 	if (xfs_has_crc(mp)) {
-		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
 		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
 
 		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
@@ -147,7 +148,7 @@ xlog_recover_dquot_commit_pass2(
 
 	memcpy(ddq, recddq, item->ri_buf[1].i_len);
 	if (xfs_has_crc(mp)) {
-		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
+		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
 
-- 
2.39.3

