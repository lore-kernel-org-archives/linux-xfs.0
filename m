Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113A83C068;
	Thu,  8 Feb 2024 23:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434469; cv=fail; b=KQpC5r6z9kpApPW4nGk/H13zFHsl7IjzBDiUmSAoS7to05ISvyaZl33qQJrJ5PRNT2iEQ6MczoDjSPZTh85lrqbm53aXyXtA8sTOWrKZ3YYXsV/OlekyArcem10QMgcNrlMEkKHnbQDarChNeLklaE7lojDaCDtvEkZudvSp0Bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434469; c=relaxed/simple;
	bh=Gg4caNcJv0qE4O9Mu6oNNv0DhL9+vNfsm/TbSpmeGjw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HFSO9bZP/HZ6SFpiOyHq17YsgtP0gUFkqDFmDnfvCrbBt9bo5RH4tKxggmg/weICeb6mwX3bC1G9zf9AFMmyQGBGzetHEWwcS0hS6CPn6lXHxpF7+l7K0ETNRWC0MK5AAcseXx9qMFC/fTlyixYLMaLKL4otKYzJrfeOpHIjt7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GDi0Rdj4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iwFkzhUO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GDi0Rdj4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iwFkzhUO"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LT2to017688;
	Thu, 8 Feb 2024 23:21:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=bDFpmbyM/fDY+3NNG/ge8q2bwzw6jf6PItCVF0l6Hoc=;
 b=GDi0Rdj4TdtE4p180j+KT2i/mKJiyTTkic6m/XP96bimnUYPm4F3bq/n7cvvxV2XjN/C
 15D7M/aQuH1APXUdsdlOSnZwIss9vzIz5PAtceGxhcJceggHXHn1W3qkZWYX/BkN6XQ8
 +w4uNiW3rZvj6gYGmH8xnsFpdrJcS7ZnsLOk13Ggwti8xkG3crn2xxtfRSYGHknsGxt4
 ZpKDXe3rk4OHIBbcQnyD3yaU5wbah2X4/WyF3rXFuvdgNISxIT/dJRv88VUWg7DAtd7d
 Y954XX62cgNoMC+sd8Dq2Fd+nEDh4ZKdDf4alG4y/sjZPxMyhcKhqZt/sfK8mBca6Uq9 oA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c32x7de-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418M5cfE007131;
	Thu, 8 Feb 2024 23:21:06 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxbtg5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=meq/kRdBOzLgxZCJLapTefaSjq+xaMv/wN1QAU1YE5mZL21+4maxUyTRq8P4tDq9SLBCIRhkM6zCSLrc8EYMD+eFhyDTcGZiQIRSwLlM3Ls4ecb29h0FDCiF7Qk6z8kWhM+gINameT2RguHE1Cf9umJnPFheJZ3wxgwqsbRZBhpay0OUIDB7wh+6KBFTLSNcfBfi+ZfndayKgGhiUe4xJwgm5SruEWdKFe64Ipph7uxhO4ybe986Y8Ekd6pi/tFnGtwnNr6ISUI6DovIDZ+m6CmMGRX5Z+Mpm0RJ7CB2rIhF3nQ7hpcwAsQVWdYOZBBQU/PaCsL4b2IKXrHJ9+KEpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bDFpmbyM/fDY+3NNG/ge8q2bwzw6jf6PItCVF0l6Hoc=;
 b=KFFkg5neF1/sAKQblAQRYr7Q+j01z1IEVVQO4xrNNWaO3Vducj6ndSVBrHGbfX31UHWFa86CUKJzLReMqfLn5OyAAi+mWLxwmE+USoKnSrzuf5HvhZSqwiyuQCZBD5hab+pVEjFpU95XbcAezKT/PF/FxPqs6hp+oXXa61yYUIrT4IMnuhjLnicNyxCUrhzvhXX8vpzbvWbF2TtaYWxazryaBN+GjiIXjuy1vZtL8EPxAr2kA6Pk0u8B58bsMXysTzQbM4t6PgYRZiMRSsLHMTVQE7HLWEUs8jFILeC8grtAgax/MSHtfpGnodGme0d+gUQ4AJRG9Bdw9OntKIvJgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDFpmbyM/fDY+3NNG/ge8q2bwzw6jf6PItCVF0l6Hoc=;
 b=iwFkzhUOChU6CSKjH6GZGt7C5pB0odmla4V+bXk7LMK80LXn1XLMk4AnwXNm9dYUX4iUieQ0S2dDWYjA8ebSJifBBmJLC4KtAIKuCKurMHOsOD8mti8cvVwoAdgdCBhitOMtBfMCSmddsj4zMfIBAUQN9fPJPaK8ofrVghmTf/c=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Thu, 8 Feb
 2024 23:21:04 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:04 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 04/21] xfs: prevent rt growfs when quota is enabled
Date: Thu,  8 Feb 2024 15:20:37 -0800
Message-Id: <20240208232054.15778-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0100.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::41) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: deeffdb3-2a3e-4370-f54a-08dc28fc9f09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	d+Ac6/+roh294j72soya02L67lxeNhQcnEhiA1rqu4EyOJoroBh0hsY1ZNaCSOsgnxDRB0M6MzkAiNpGBdyXS6OU2EeMll7XJQqBLkLF76kx9TkPVwq1ix5vsTZCy3fgjBzz1QP5FRzRIhDtwljacCYDJA4osocTAa+1q+EqFLOZVNW6mbqJfPsJ62ZH93ujQL0K+dRwbPpy6E9Gxz/82UPwWV4Se2c7GVZUJq6zwXEd/J3NzEFG/Bo5bed1nOvgmu7JJIyCsnIWPHCIH3fGSZ6mD2GrRLnKxD5B5H/pnoQDlTDdos2Sd2Hdg7cfKt5KMwP6X8SZry5dc7kExiUKg4oUkpuUNgIOtPp6IGjYHASVhsVn0qJbHlhvBlHk+/Kx4VhtLvg7tfcyHpNduL1v5f84ksc0/eN6y6bOdy3QjP5IQdq5AmL9k3AOdiJaZ76b6IcWqosSSQUpjXVfh+4eoDuhP9jGLsN07k0cg2YXVpNG8bkveHz3PhOw+hwGVhLX4U4+53ZoSZ7o0ypYkWGTE24JWt/UJWIXxrMIG/HPOWtcHpPfVWT666H46U3qZP2v
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(376002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(6506007)(4326008)(450100002)(86362001)(15650500001)(44832011)(8936002)(6486002)(36756003)(5660300002)(478600001)(2616005)(6512007)(1076003)(6916009)(66946007)(316002)(66556008)(66476007)(6666004)(8676002)(83380400001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?C+115+vFHksydatYGjeCK9gTu5rN/J125E4zqsbjSoU/AorP28SEikRTEK2l?=
 =?us-ascii?Q?mCnDvsuOJ+ejOptSdKQ0oN6Vg6bij1TLywM/R4rm4q2MZzOT3MIpz2lZwxB1?=
 =?us-ascii?Q?Y7KMqxbIeOXdlx5tQuwPj2k2/6VpJ8DDa5Tl89cqz3S+l+WyAlYhLEQz9lPP?=
 =?us-ascii?Q?LB40DxTNPiXXk3Xf4w2lBDG+6Z8rMDhBcYHH2vGI2Rqu8fJaxHM59bYmdldt?=
 =?us-ascii?Q?rs7vHnxyOkDCP2jp8AW8iE3g7An2Rf5wPIzv/PPgZZn3FYreUMxJ8fN3TBor?=
 =?us-ascii?Q?9I6MYcGS9OY0TW0F1sv1/uq9Kh/VCdUmsdS2oOjdfQKGNnH7WnzIDhaKDOBU?=
 =?us-ascii?Q?wq8XmT0yRZ1eh7uEepgZNeTWERlFy2MI82RIWel1irKxvyJV/ZP8d/h4GPhO?=
 =?us-ascii?Q?va/VAvRHkZ49HsD2vxHTkcGG/n6ABtr1mZi3lehZmhSK3OzofOAVIAU9NLru?=
 =?us-ascii?Q?+2qea148JYfY1MAzIihBxvimVeKOnnBWVm4HNEVCdSys0UA/q7GcBL4q2E6r?=
 =?us-ascii?Q?yVUaKrCZW4ZTeN1vpQcZMnvrFSJxZ2qBM1LpHl0tamVAGUQDfMZZ2jA40S4Z?=
 =?us-ascii?Q?6/V6fnlo0j/r7dywBuo8/ygAJJSjHVLzRkDkdTtrW5NPJp0fxA6Wy41YeyuL?=
 =?us-ascii?Q?B7EGOBXTLW/P+jdDhDIrm7SRksTJyFPeChqCSA/G1jLdrQxYmBpR+wE8/LZ3?=
 =?us-ascii?Q?pCLo/dtGNPLviYpUbwdvvJZxcshZqUvp+xM4xfIermCgG2g8bPXr919+IVMv?=
 =?us-ascii?Q?2aujsp5iukOdl4d657eeYCe7/5DjLrCzZ0bI68ZGTVYYNd7H3SBNLTuvKOOL?=
 =?us-ascii?Q?Qk4LNJ9E6eNC1jms3UzQeRavynoigxjN3vtVmZg4LSqpaal3JuYOLZ5Iye9K?=
 =?us-ascii?Q?+llg6IXcjhG+zrGVpkZepvBmEiMmRZIEdQctKat277MlT736hgibkTHityCH?=
 =?us-ascii?Q?sm7bRm1GD7DplJl83VLrpdmPG4vdZLMI3dBELsbZrng5eQoPrmuQPUrnRkC4?=
 =?us-ascii?Q?oWzLGbw6s6RlcZxfKXDRZmJ4PWnh2zI5ZTMITFtPOtjONfrGAJFhyCoaqD76?=
 =?us-ascii?Q?zho69HWQfh2WBvju6crWOTDkq24Oir4+xepnDmyzdiZAPxz9QXENNqLeW6i/?=
 =?us-ascii?Q?k/77SAUF5+RpV8QFs2YHkLBDs62zYBe1IAhi/1wD95Ep7psaH9jjWvPphu3I?=
 =?us-ascii?Q?SYwS8975/UtlboItJi5YFtYsO0wmiBWFIm0CloCsTv8wayOsSyJcsX+M7eUO?=
 =?us-ascii?Q?LBLPP5Qs0TeR26618HRNGaWzAErc8WPHYU1Oa4MiissNgxL1E4MEJT32xqAS?=
 =?us-ascii?Q?M2vwCOpvtfcbGK6OqO/IeBzpwOEbFrEzvQMpKRx6/t3cd7Ha/+uAdSEmHcNY?=
 =?us-ascii?Q?cfG4OUQy5k1HFRkrCv+cZYOMEih1BnRS1BCyo1pIiWcwiyfXN908f30lLlYw?=
 =?us-ascii?Q?8v4PPtISJ8LX4lQgFXkYxb9iE/x5ulJiCrc7ktOYWEex5nn+IwGA14ZwjO5v?=
 =?us-ascii?Q?BBTCuUSvcaJYq160gAY4Nk4YBIx3aeM91R/9OXkpAGnRif1ev/QaceW3+lWf?=
 =?us-ascii?Q?e+o8PYTSW1hD8r4nxoe2LID5eQg13mO5bkxSvMzuTIjcQ9AGJST6ePEm5HqB?=
 =?us-ascii?Q?2fTt1+utimIfMpmw2jj9b+dTB6/EGM0ODmuu5T1OkdR983ekssMNi7mEuZV2?=
 =?us-ascii?Q?NLsd8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	rZOfYn+sPG2irr8+0mbHShfZJU06T145OERHw95h0fTAlhflBjVkm0bBrxiIVjfgroL8DSugbt/1cjlHToqxKGMhasflIEtNuuyXZD34EMoZCofbT7LgBcovNvwgWfd08YxQQ13LGjjvtWZ49WzXbdZlZqVwrHjvKmGuMyJV+diwAaY5/gd1EElnfebImMDoCJpX/xyYAmf3je1U4Ky9ctNQFxJ5t5YGrLdjZ2/94bbG7r67DSbvJv7nExZseSA23A8L+o0g4JezzW2DZLLjgu2RXOSYA6hDOTmUGz8/ZKnAW7oZQIzeS9Q6V64cXpqGD6VNS8EIie3un7KXiyHfChTfMmBxtJxN11BXZxaQz6MCyHPNGhgjMWBJIG/JnUEc7nEPJCnjsRMmNRRxfyWBkC5zBUTy45AoDUQlrG/1RM0EcdBpjsOFGVOSMN0acyf8Oiif0jvHNSFa3bXIBvJmg3tJSXZvmBpNsVllOzbqb5/AGOk7iCAQhkDy9Gg4L90S1TMta7OWxpL/gfTfxrslkVEao4RCOyIWnF3qsNnYTHsYKmg1NmG43HPiDo+AtadQ/TnRawveV3NDcWbiy1zqH0t/6WiMK/whbj88BYXz/0E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deeffdb3-2a3e-4370-f54a-08dc28fc9f09
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:04.5623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CkDkRmmww8ANDuQxW49+iiEGEaqzDFMOLc5/iDmq2ZnzNHw1E447agYTyC+5VVGGrCqmEtCFMtYReKWYQxls8vNgHxDv1jcq38gAHD/JF8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080132
X-Proofpoint-GUID: 4AmmSeDa-0u3ak0xIMeKiwojoQ6G1lPb
X-Proofpoint-ORIG-GUID: 4AmmSeDa-0u3ak0xIMeKiwojoQ6G1lPb

From: "Darrick J. Wong" <djwong@kernel.org>

commit b73494fa9a304ab95b59f07845e8d7d36e4d23e0 upstream.

Quotas aren't (yet) supported with realtime, so we shouldn't allow
userspace to set up a realtime section when quotas are enabled, even if
they attached one via mount options.  IOWS, you shouldn't be able to do:

# mkfs.xfs -f /dev/sda
# mount /dev/sda /mnt -o rtdev=/dev/sdb,usrquota
# xfs_growfs -r /mnt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16534e9873f6..31fd65b3aaa9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -954,7 +954,7 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
+	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
-- 
2.39.3

