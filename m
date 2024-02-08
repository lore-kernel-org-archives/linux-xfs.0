Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A773C068;
	Thu,  8 Feb 2024 23:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434474; cv=fail; b=f52e6GD/fTpvSSb97qk/uWbYZ6m4NzkoPi4xXuTazFwPt74jEzUxvO2z56S46630N5HDCAtQmxv13vexYi/nhSPED2MsCRiVoIv3M8kVOXYTnIolteMiS8GDcxz9mdviI+MwosqZRAG3lLyuR1XPYHJFLhwWhzNhyR1wfjM0L74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434474; c=relaxed/simple;
	bh=xs9+zLqWo/95oYgPyKpReMiDfOGGf3O3i+DH41L8EpI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xw3Myr6+FuRErU7MsCXTEasZ8tCeVbGe9Akt0OsULu69E4gSaW7jBqbUBn/TPdtU0Z3P0JX+eXB9QWL9TM6CLVCptm8uZ4zsk3ilma2feKQ/Irfz3HpyemCMwaWnaiTuT3LNuPmSMTtp5K2HXo11vsxJBoIMJKmHT+EaaiCKehE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KBcI5e/4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MLEVqizv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KBcI5e/4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MLEVqizv"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LTCbU017961;
	Thu, 8 Feb 2024 23:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=MhvDB08ulB+N6iq9vQfHQoJng++1/E3Nm6u+mGPSKOI=;
 b=KBcI5e/4hQb/A+5V96cAweDcXUBHkoTwcz7C4Fyki2SZM48bCTQ2ySMtZEgNJR1kNkLv
 wSs6Wm0hGkz1NM6/I63/kQYBiwS04yLn+KVI4JwCyhJNAS5jHfCHX9MFPaiQpElqAmrr
 m+qV0TiikU2QZlATV3LQngp0SwozK0Rh5yMK+yljr1a64Tx5//ckjjuffJTFLUM6BJY7
 8zfvWdwDb++J4KAhTwBWtOc2C2gHzAAZ0wQc2hdA316QON+5576VLb9Au+Qm/22a9JCV
 O2rP9YMHvYJxpPsdxanzbaSUz6ZWvXRMcRxGviBwsN7iadKKpFX+uT5HfPBGhfCabNJG rg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c32x7dh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418LUfr6038517;
	Thu, 8 Feb 2024 23:21:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxbd1ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uhtd8eU2bs6uVSAZY75PmZxlKd5dyoA6HXetWx3EebhljPKKs+lJvqsxypkjlyUNfcClCubgKFcEiBqUxoVRv5wHowi9XS6S+c9ALfsvOg5ofGiIr7speB8g8OvpMslPhOIJwkuJE+kRcWGjzNfG5nu/+X4jY1eFdVHAwBP1iGjRbUy0i8IWrC9NO7jOO54WWe58FDc+LPJpJkmZHjSuXJfQQF4Zz4IxLnXXq4vCzfrE7XVZChNMFb/WV96PT4++lozH+i4LDnutHTPgdnotJ35bUsYG5ywKGkKJeiWzuBb1iu4ns1WbpOBVaHYY8sDAQ7Z/K/7b91LmD+PeW1sThA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhvDB08ulB+N6iq9vQfHQoJng++1/E3Nm6u+mGPSKOI=;
 b=WNFgwYfP3g/ODkiECytaQROz/qb2G+QgbQViI6XFic2EK2qgexCaq0Cl0OlQ+bRMm7PLzCtSHg7xEYquv8UeTTnbeigjm2FkisRHa3LpEE1Ipb2+yCe7vaeIf4uy/CKXUov4pOqopi8Wf+2mdxbOM04/TXySMt+Z2QmFdq2tW7gLUu3WSNPAURkHMPGB/b5Np5Ia+DHmBl5deTTfdcjGQ3/iPfmaD86TkXyGKlqqWgXbALz3Bjucsnmcz07h1sYRwYVkJZIX5TgLWBUoT9iVRKcTYy3WAuKGcuOa7xZnr8fP2CLO1Lri2c2aalW7b9y43Ax8ekmHGP7PqhNZ8X/uTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhvDB08ulB+N6iq9vQfHQoJng++1/E3Nm6u+mGPSKOI=;
 b=MLEVqizvGcy3uFpcaTFTEtxBCDLsJUrSDgbVnHqiAZUg5VyBZ036dhXYWtAwcAr7T1uodawz/gjjFoI8DrYWgU2tzxyTszcAv/FwzoJV+XZV39SG3JjlCHu4Q8lQfGu4SiS55dy56ysrFqo38mvqZcIC92jbfEnpdfCqQ28vc9E=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4487.namprd10.prod.outlook.com (2603:10b6:510:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.39; Thu, 8 Feb
 2024 23:21:09 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:08 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 06/21] xfs: fix units conversion error in xfs_bmap_del_extent_delay
Date: Thu,  8 Feb 2024 15:20:39 -0800
Message-Id: <20240208232054.15778-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0068.namprd11.prod.outlook.com
 (2603:10b6:a03:80::45) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4487:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c93461f-54f5-441a-b9da-08dc28fca17b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	7BwJE+QLZpMkbmgg8iN653ZOIuz6+bPqG012QGmdzX94nAPbBPIeHFT79vDLON9QSkzBs5R+y6dcBc7fDtTofbaIWdfbAwFfgPIFHfnGLS/IVlNia5H5C/GDAjH6l4bsiRs9uA1A/5/cnQKaj0r5xlJiovvNnMEIIN0WtuGo2rDc23NffaJqLgNzKbcFA9MbIh3+Upni1l4vJA3buwcjy3hlfuPdNEtya5H5ic1n2V9XJ6y5zyGH/y1dD+i/GcqvI1K8nS5dowNgxl0mR2Fwe/Cni41Ejn1ziPqxO0org444DN+wxv+47oxZ0t6ptUjGM3PSUSoQ1UEAXsOjhefwR33mXoGEWE5dEeXRT2jdsiwAqill/VCqTj2yR1s9Pzj3w8pQRJ2TvpRkOJYT2PwTenWfyNnIk3LhDP9ooHmBWf4Bqgkcbe2E/FcwafWc6PgJ4BWzo5FaMKyozfqZWvenc2Hz5P+7zEt+okgraxe00wY68/hWIxlcRs2KS5JNgDIXhrjkH4AAXiKvmvWYSzaTS+64Bv0I4biqGBus/2WH4I3MZQXJRysLWCE6ln2mdW1W
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(346002)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(6486002)(6506007)(41300700001)(36756003)(66946007)(66476007)(6916009)(66556008)(450100002)(6666004)(316002)(478600001)(4326008)(6512007)(8936002)(8676002)(2616005)(38100700002)(1076003)(86362001)(83380400001)(44832011)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?frY3KXT5pPPCrD1GNdNUqz3i6OjXwkN7J/pUrAh3/n8UCWA1YftTnsOmAAM/?=
 =?us-ascii?Q?n/0vS75nnA0Msx9VMlqpBjAlohtoaHZN+keq1mmKkoisUCQlVHUuzNhnX7xG?=
 =?us-ascii?Q?VOMT4WSZSmHT6VAHiC319Fn8uHsvDqYe8enW//8DIIJf9Iy+eCHrmt0QAP9c?=
 =?us-ascii?Q?S2ikOflKmlH82mLJCk1oS9VY8vMoObuJc6cxcsstwf7LGLayBr5YFoK+HFWQ?=
 =?us-ascii?Q?WsyLY4+oIaIivx+WFtoW2bU5jxzWmOKqT0xTZx7jR2S86mmSvgwyTWCxHcQa?=
 =?us-ascii?Q?apE/DGXDdERj+r+1PpdqG99iK8vTIjv6NARDuNakY0SyM7wRi1kNiqUYRvkC?=
 =?us-ascii?Q?cTbP/rd62hlcPK9GJEJv9+HI/1f7v2mvxm7fDhWIeiN1SwtF3Pop9v1C1Az/?=
 =?us-ascii?Q?ZCX+afd50MaaS+Rw19kHOEjK4wZwfUmfRsjdOeLPMy5fJ7odY183OkqMROSJ?=
 =?us-ascii?Q?YIRFzENRT1gzLS8MVGnnU3cqX18zj03Kq2uxNhpGpvMeWl9FVQWpAIcMf7+f?=
 =?us-ascii?Q?7hWtkai9Md/d7lV9dwDN5yd+xmRVzo5eUObQa7ZYdSe62A3OmuuzEpPCvU0g?=
 =?us-ascii?Q?hYuV+ZaJpoNyA/sV1R59TAlzcFM+1hVrvR2wWWNXRTAHbCdt7bXfs1UvbOiU?=
 =?us-ascii?Q?EMe6DoXllg86tMd8mk4DyMNUMIYe9rRXD/T5+jilJbHiB9wowQm+t1fyyz6y?=
 =?us-ascii?Q?PPJh7R8uAJX2gGOfRj9yOgJSq1V252EpXWJgOY+ov0RUX1Cm6SEfZs++G3+k?=
 =?us-ascii?Q?bKbQqog2po15HlRkKbGV6aJK7MoGvz89Tbn3X4BOcPxXnYeWDqT4m/KcItdH?=
 =?us-ascii?Q?8qL2hD8spb6ZebTyf8kS2898YetC3PvhvFszscJQhpj+ZuCln1RW7RVG/xvQ?=
 =?us-ascii?Q?F4eeTka+fkG5K7b0iWkRegcUMpu6KH9JZuqQTJto29d9mbU7FeDuil+rq7ue?=
 =?us-ascii?Q?wJIjEr2LJriaqSPV8lCLriTpkBBts5ydg7JbfcTKKr7D7kO5qMMWRFXReqlq?=
 =?us-ascii?Q?CRR8dLQXDifyl+9fHKW7CAk/7pJpLi2l9TyaTCRiXYNLE8De/YYQMCssZ/rs?=
 =?us-ascii?Q?I1SS0r+rtNo95gKGtpuBCMryt5aRsngfk4hWF/KSrt20whRJHE8ZvU5h+4mu?=
 =?us-ascii?Q?dgRhjMSVh9yCa4XV1SSkwP9Ae4ItrYpUmf645qSTGvm1ngTNb7NFQL/ewgN8?=
 =?us-ascii?Q?txwz1Z7JhpgO5ceB/2Xoo5hxPEJMOWrT8SYESkpJyVKF7nHDHwsCKseuL1hJ?=
 =?us-ascii?Q?rLtmGHBxZztj4M91Jar/fBlx/sXXNHQp3Ih0FtMFna3d5YUYpuJ0S+632TAR?=
 =?us-ascii?Q?gL6Q/YBn2gUnC4EVsEHtxLhwAp3i2yop6rES4eD5dwCxYhFPEfkp8q6OQN0X?=
 =?us-ascii?Q?S+ykbHjPsZ0k3/uO6GB1H4mSQYzwET+rzKBEZUdFFOnGinz8s15hr0LA126U?=
 =?us-ascii?Q?SuKYRVrW9sQyq4WiUw8wKiXjPtJgo2YJqOrFugEirRgrwwhKkCtMbuiVHiB2?=
 =?us-ascii?Q?seRozjlEWor/pej9Uuq8A/iZQ5yNG97MCpYexCHdj6/e/y6FsOI7D9/LE3Q5?=
 =?us-ascii?Q?GdWQYTyMHRR/2qFHk5YQVs2rb5lsPM6R0XWw6ETwd82nm9lneJF0bJ20tuDP?=
 =?us-ascii?Q?kpc7T4rSgb46jjOQsaN0pAep9VV00F/d7OvaPEt3tM5QNn5yCHdouGpRFQ1m?=
 =?us-ascii?Q?70XGow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	BMbyTwyzJi0uYlRHWpmAGk2SRRfeRKy3uIWUcYD52dnAS+VSgqMxjMLOa9XcI6MSz7hZiZxmuaL4uXkI1UsMJ/h5lLmxQXgq1tRq1Z6e2+FsHXmMFXAwMfnndp+YSGIPfudomkmv/QBrDOEp1pMkLKid3l6HkvN2ty6d3vKGbLJIiqOF0bqWp4Dnl9mWVHfkxPbqKI6VyTWRgzccL9PwxUou9UttwoTsyiS6dYv5ucOCVKZPpyhc8ns2ZDQxdJ9Ko0+rWgj/CU+nqHVQ/lsdOh41iJSamcDw1pQglSetSveBTn6q7OQU5Ah9SXAxQBaE62I2uZ1T0+Zl16kRThmJ72ND7beu2RUKHf3EocAs8RXUD5go1shHmw9OJfR54k+pICrpmRd6Ecb669+pY9Tp6r/vorOqCPjS/cRvODRmZjV+695Z3pJ4gZpgXWj2VYip/JdY9ZJoI8UkSNUID8dWRaThYxjiHm0JvIEPojSapn2+rxnbWblTn7I2nzEp3I8/mqpwBlHufpTRbYchWGLAMnOiEPdrpHO7gWbsASix4HjusqJTLcEgWPnIGYgQP8V5QojdfHug9axrllgNGXWuJnOz0lX8xWqVVNpKO9mCXBA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c93461f-54f5-441a-b9da-08dc28fca17b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:08.6999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ytg4UmTX6Yqc5wHqoQ5W0GF5EYaMsDg3QIuSA5bwPwrippyv/CY7VgdjldC7gDAO9IIkmVjOdGta0iwSEoVMtq+bVajJuxgLBSNzplSuMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4487
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080132
X-Proofpoint-GUID: HvonhY-g9QIgjxkxhprEO6EKtYvapfDV
X-Proofpoint-ORIG-GUID: HvonhY-g9QIgjxkxhprEO6EKtYvapfDV

From: "Darrick J. Wong" <djwong@kernel.org>

commit ddd98076d5c075c8a6c49d9e6e8ee12844137f23 upstream.

The unit conversions in this function do not make sense.  First we
convert a block count to bytes, then divide that bytes value by
rextsize, which is in blocks, to get an rt extent count.  You can't
divide bytes by blocks to get a (possibly multiblock) extent value.

Fortunately nobody uses delalloc on the rt volume so this hasn't
mattered.

Fixes: fa5c836ca8eb5 ("xfs: refactor xfs_bunmapi_cow")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 26bfa34b4bbf..617cc7e78e38 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4827,7 +4827,7 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got_endoff >= del_endoff);
 
 	if (isrt) {
-		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
+		uint64_t	rtexts = del->br_blockcount;
 
 		do_div(rtexts, mp->m_sb.sb_rextsize);
 		xfs_mod_frextents(mp, rtexts);
-- 
2.39.3

