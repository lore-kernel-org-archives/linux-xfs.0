Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587521862C;
	Wed, 27 Mar 2024 00:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498412; cv=fail; b=EibleH1QP7XXtDYg8csvYNdzn5uG/BcdETSnuerEWkIjs1NYTaH32mB7N2sevEETHkBCeKbK8/R1BiowAUh8V/3zy2VHybwhDoanQUVIgX2OhDHHwuqXH2OiPC0yrI9IfjBFSIbWjIQwvR9fgDklHTsWAfj+x7+RQHEUYH3PD5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498412; c=relaxed/simple;
	bh=ZB7qmNHpM2d03f4PdkrfVw7MMqvcWLEObr2pVYN9tEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G9XRPy5bluhZkFvd/TrF0IDJJqMbEbmk8/ibJQJ4b3hLuIxOrMi1vbCCMwHdZvbI8EWhaTklRd+i883oGOmyoJmnDXzie/zpsXbBNjLFd/BXTMtH9RL5cft9QizLnTK0D56dKc5yflpK5k49kaNKNJBZz5td7cCiYkcM5A1q14E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DFCtQBFQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MAwmJV3z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DFCtQBFQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MAwmJV3z"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLi0x2016402;
	Wed, 27 Mar 2024 00:13:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=oUIOBPXVpYmMiyAjrGQYd8msJuP/7MfVTju1/Np5+UA=;
 b=DFCtQBFQ2uKum9y7Kanjs40ggXeq3h0uAQw5LJn+p2CFqymRQA27RSNvhH0uh8FKkNCJ
 KEukZL+sy/nFfGggN2DlQTMDOVCA3vwZeo4lprRrxsxg/8SAzUWF7hxzVVBTxJeLWy0L
 qrz4Bwdk7YhWcpXLciL0pXHk6CtoomU4ZU2P3BcRIrbWbGgcGAAlD3rxGzOXqAYsI1as
 7eDt/SXoXh3kkJ2JD7FAW6lfxiaRsoKc3X7lpJ5C3sodBZzi0fvZhB3YARInATmczyIm
 U1vk4NcHx7EW7NbnCRHek3OR4gNErR0oODSQwVxahj0VKJ+UyjOgNOFVAbSPTAtl/yeX ug== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1q4dxc0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R03jNq012586;
	Wed, 27 Mar 2024 00:13:28 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1rqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsgyUAtOkPW15/xO23Hf6oScUpQgQSwswfl1e+wxZ4YjRnOHfjhzosveyQbteWLp0cuM0rwmyvmx+wkqaPrUV22Hkta+VyH2LQAJ0YuxB/rUr+0tXfW5j64kpDbwEXGAPsYJx6g7k/92s7cZEftgjmZbHGKE2ye2DP3qM0wl9tNICBuoTdSKQQk3HxfaVGGiJJQR/PM6kw5s3bEV4Eyv5b4CoQSeTi4plkZS0kO+hPff41TNYFne6pnte64o/DWvf75xI85iOd1IxLLy24W0CinLJAcUsQEu2+fuRyc0WfxUGLWKozZwKZpBEdBTLaWPi8ofoKJ5UGEBGdIOn5OGpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oUIOBPXVpYmMiyAjrGQYd8msJuP/7MfVTju1/Np5+UA=;
 b=cvqh/b1gVsN4SAyKAIPtSDe3BwQiebgoMEGezAwMKAGfaaLdtZnGoNENq7sghG5i2Hll8PHolGv38UXzyj2up2WGV9CSZfW2LhPmaqcnD59s4HnNad6zwjBU2FDxmzLAgMRN5NjFWcFIuWSf+/itdx5ospQ4FMyYM3+6Eg6Gw6Mxw80pruyjUwXIcTuMsdVkzbPc+lXTaJDZMqqRisUYo3S+e1oTue/wPj/WfBWGkyg8rXJtdEZlWqiLtXHRVyiNjpLjLcfR5p1dOyteu8eEtZH/lLyKrM3ump6D9Q+Xof0ugaXfgMA0UT24G5ggUWhhxmaaiJAvaOsJN6j4FS1MPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUIOBPXVpYmMiyAjrGQYd8msJuP/7MfVTju1/Np5+UA=;
 b=MAwmJV3z92qaQtzeMcA6qradXcO2NW6iBw/P4nk0sF2ncNmMDEtc2GawFpHucl2VSHsBBsfahYRe/hLVZCImZpeG6vOsXoiqaPevdAqMH3HSmGPNfDa+EYcjZ0m7QXnfERh3ppHRGLATcVS5RWbyYeEJhT1fXHA209TrrXflMUY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:27 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:27 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 22/24] xfs: update dir3 leaf block metadata after swap
Date: Tue, 26 Mar 2024 17:12:31 -0700
Message-Id: <20240327001233.51675-23-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0190.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::15) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	B3l+1i3NzP88NCirNToaWjMADpfQ/P6/T782aP2wEJbdLECJgorWU67PUr8PoXKodxRz54e+bbw67fczZ2hROzES/kVoOKTqQ4dwM2LLn/+NqygiK2mJLJto0FwTU66SsDwZBmH/jLzHoi/q2RfajLZkI6Jx21E8RunBRcNYRz00m56q+qhEdIZuVlj7nsdvR4/ZQ9aba+Xy7D8zUJBqHmV6twzcJIMKhEnhT+UPmjClk7AAa9iyMOzALF6QlOHS0gRnpLkBqMw0eK8L4im7BsJy+Uqo972mhy6UFAHzzs33ANaEDjKcFGkOajUmKihgo2Lb7wyi+PheX8zBhQA4o/qWa8r8Xfd6TRoqruGaJS7AT5kAftuIV/QRI/1QM4Laz6bCCyrOrL/B30mGwYsXAW9o/0lwpo2MNqT0DrfZsufwrEN5mMOLygC8L8y2NnN2a7iIPB2Up840SsIUmg5+pxvJUrwAlnJlH3IzNSaOUlGzBQD7eCy2M16zGm4sqpKpUyIWanbH5yU0pfksYRVw/xKMERXgsGX0y26wnYPSG1iXQtOuDFtB8YLfiRv6YhRCfAWognI/oUkFaFjOLhsKvNow6ofl6F/gYYkbHSKAP17+9OWvo1bOzYA3tiRbtFYDwCg2msLBfO9GDq045HJy3YCgkKn9Eb0YtmrfdXrvGu0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?LjWfx0EG3zxcRZj1RDnIYQJKjIjwsZxvm8tXYpuNxzhBrwBVP1fNTaW3avxu?=
 =?us-ascii?Q?VocnDi7uEBiR8Eo6sY7V+gJbR+6PURGaetMshNYtIeMaRWI8Fv8yR8Q9JLqp?=
 =?us-ascii?Q?LhqW0AINM2Mr+9q15DRPkg7kItqbno3LlUqxld+pZCvavJPCepwmSfrkzNIg?=
 =?us-ascii?Q?LkLLWK3mdfiNMnGk0rTcO1G6QwMzJrgjuqVF6sKarudoWqSDXbnNSTUeM1G0?=
 =?us-ascii?Q?SN7XAJOYCPiKKmSrqx+8vNSCzLAfWAaaXgWayvF9fbSbAoASHUskA8b+ZdXv?=
 =?us-ascii?Q?2VStd88ZF5KRgnA5aRyLuGCMDdlnVpO7KqI0ENQycsRl5vJGS+VOvH8qqety?=
 =?us-ascii?Q?ckutWLqBHcAShnzww59Nq+OTlTc2uyKxrSjyICeJbhpILervC2eU8pqWPpcd?=
 =?us-ascii?Q?NGXOJzPabYZevJX2jJpH3EvEEanJmVYlJ+GMpvTYT1HlXT6Y4JBXOilA7aiA?=
 =?us-ascii?Q?Q32E7Za+0da57qncKsobKklnX89p5tynR5TUO04+07QVr+we8niiz0K71cBL?=
 =?us-ascii?Q?395/CnoPLKxWm/CmLCR29ki3nC0YbhxghD9gusfVNz7RXHT5GZJK5uxjuXHR?=
 =?us-ascii?Q?575SI4gZLNECbqgdZLZFaHHn1UgoBG/+uY4aSgOgbV29DNsLY6AuRdDeEBgW?=
 =?us-ascii?Q?ekRVlQv0ygd/sagnhXjP0k4IXIuWRXEiNghqkfbSO+benlob94i62pcNLjup?=
 =?us-ascii?Q?cwAqApr3PBcs7eagdNM5afhvT0FnWEBI5msqHZZY6vtZAgEH+2zzvFKgjbDj?=
 =?us-ascii?Q?M72sGLJO8A5q5ss7qQ9C7e0ai0dEEhC1BgDfL9/ECADZ80M9mzGy114e/Xmw?=
 =?us-ascii?Q?omXgf0nzXxpabLF790mjl7KNgzJBw7pLCUbrwo3SQRqhZAki8QAIL7q2d8nk?=
 =?us-ascii?Q?mcOqQPOg7FBUOeDusdAD2xZL2hoHSlOYumFQbTBXGOtXjKPTDYPuRHRBZHwv?=
 =?us-ascii?Q?ULMaf4MKUUEy1dm8MCzu7YOILRE3QOR4ZAl9rC5JjQWxXE6qOhDHBm/a/Yuw?=
 =?us-ascii?Q?SKWc4FbDYWHSYUNtKdfMJKF8dAovz6V+3eIEpzV9WPeYqb/OjJzy/i1qRUO6?=
 =?us-ascii?Q?XBNGjMCP8+qdbme95pZdnhySms9PKXzb1rQm0qo53GnG8ie6/KYrdqj9aww0?=
 =?us-ascii?Q?eCgPW1XSIbyc5DSDgTAdeJ9OXXiBWK44Y5lIR8J9q0pK05DB7PAkGh6aOx0C?=
 =?us-ascii?Q?ypuC9qll1735vBLVL2Fp3ri3KnW3c1gSgrAWx//KmRVe1WvGf2+JH7s0+lwU?=
 =?us-ascii?Q?SkEsBfuYWS6Knb72Mvjl2TupTUGSxn/A2epNnpOfCPF1WArJVDf+oDRrwRaj?=
 =?us-ascii?Q?G9xJVx/1omn8L/qfhW5cT56muEizgDwTtC1fF7g3sXNy1ii2fg6WWAPCGC/p?=
 =?us-ascii?Q?mUd1hCZD7rMxxsjmGwU7JxFzmoQJrqJzBPt/ZGn2+p/puwEdAmZhT8GzvGHD?=
 =?us-ascii?Q?WdMYlQrE648SmqsTaT3+33B0XbeXsPzp7n7GQjMZfbESjyOm+CzXrWM4v9R2?=
 =?us-ascii?Q?e3GkJoTzM/3UA4OzeQnklA4/TxJ/RgWORjAngw5ofsvwHqGI3ySea1QvcT0o?=
 =?us-ascii?Q?/79J6vo0MPhEuR1Muy4Pz2jo1lpDqcV0fKFCMyg2GYIIL23R/lZvww+F8yCP?=
 =?us-ascii?Q?McDoisBQbM7xb/SV9Yza59yI5HnwPcPiKRdUVI1dXrsfZzWhwjKG/7Xx8JSP?=
 =?us-ascii?Q?PD1F/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	pcdIUOEkP9emdAk62lvPb/YD+G5SOCnA3G4W0X3TdlJ2dRDz803mwBAlfxAXt3R1R0jHAqlpq57cEkHKSjKuFYwiLSuVcseBQNAdlM3iUBzkQqLrc6m5YFsUdSkYfpw9puymNmEViNn6P9bz6KWLX3EEjmFSF/1M/KhSDK1csd+RmSrJ51zhNLM8JIETfh9oyq7S7lCOJfg3femQtCML3to22cV+l/MfuIqmPVoX6EnmSDEZsQu1TcHJU3hYDDegY/Nc9b8I+bKHtNGraAIjs3LeMwg/i27u6RKoKrNAz9gbjMmHbfdSPKlqJKN/MMHAYh6rRsI/S4KSoyLmGteoYR0UcR8cVebC3NOp/qh67QVIphEth7BRqMyn44m4wHhONHoeNi7jks0uUKIQSyEXznVDpYSPp63grSzUESkBNYm0X7ucbPL2NbwSXHRu9tKUtDBVgzBX3Z9LXdA2u8SZ3btMcN4Pn9qr8jXdz7Wok0o2qd/LF97uzu0kw5zrwOwEakSuhlYV1gMUE4nQG0xpD/2hKuUXcFuDZMzIC1JnsjRBIWJy86aOEn4oyXmDV9NZgDluRDsFSDOcbeWvj11N+hUHvKF3FP8u/2GIthW3v5c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5321339-0004-43c9-a164-08dc4df2b98f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:27.1889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/Q63JX+aN6r6lcwYQ8eXu563l4YMn9yM5cNMMcpODbWyq8Vo5hc2zcGQZyLk6yEbJZA+D6UWslR2YSbq/3EhY5tq4Vflg/x1V11F4Hh7hc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-ORIG-GUID: GIsycQ1vWkvP0qBekVrS_8QJCZcmFmes
X-Proofpoint-GUID: GIsycQ1vWkvP0qBekVrS_8QJCZcmFmes

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

commit 5759aa4f956034b289b0ae2c99daddfc775442e1 upstream.

xfs_da3_swap_lastblock() copy the last block content to the dead block,
but do not update the metadata in it. We need update some metadata
for some kinds of type block, such as dir3 leafn block records its
blkno, we shall update it to the dead block blkno. Otherwise,
before write the xfs_buf to disk, the verify_write() will fail in
blk_hdr->blkno != xfs_buf->b_bn, then xfs will be shutdown.

We will get this warning:

  XFS (dm-0): Metadata corruption detected at xfs_dir3_leaf_verify+0xa8/0xe0 [xfs], xfs_dir3_leafn block 0x178
  XFS (dm-0): Unmount and run xfs_repair
  XFS (dm-0): First 128 bytes of corrupted metadata buffer:
  00000000e80f1917: 00 80 00 0b 00 80 00 07 3d ff 00 00 00 00 00 00  ........=.......
  000000009604c005: 00 00 00 00 00 00 01 a0 00 00 00 00 00 00 00 00  ................
  000000006b6fb2bf: e4 44 e3 97 b5 64 44 41 8b 84 60 0e 50 43 d9 bf  .D...dDA..`.PC..
  00000000678978a2: 00 00 00 00 00 00 00 83 01 73 00 93 00 00 00 00  .........s......
  00000000b28b247c: 99 29 1d 38 00 00 00 00 99 29 1d 40 00 00 00 00  .).8.....).@....
  000000002b2a662c: 99 29 1d 48 00 00 00 00 99 49 11 00 00 00 00 00  .).H.....I......
  00000000ea2ffbb8: 99 49 11 08 00 00 45 25 99 49 11 10 00 00 48 fe  .I....E%.I....H.
  0000000069e86440: 99 49 11 18 00 00 4c 6b 99 49 11 20 00 00 4d 97  .I....Lk.I. ..M.
  XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 1423 of file fs/xfs/xfs_buf.c.  Return address = 00000000c0ff63c1
  XFS (dm-0): Corruption of in-memory data detected.  Shutting down filesystem
  XFS (dm-0): Please umount the filesystem and rectify the problem(s)

>From the log above, we know xfs_buf->b_no is 0x178, but the block's hdr record
its blkno is 0x1a0.

Fixes: 24df33b45ecf ("xfs: add CRC checking to dir2 leaf blocks")
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_btree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e576560b46e9..282c7cf032f4 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2316,10 +2316,17 @@ xfs_da3_swap_lastblock(
 		return error;
 	/*
 	 * Copy the last block into the dead buffer and log it.
+	 * On CRC-enabled file systems, also update the stamped in blkno.
 	 */
 	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
+	if (xfs_has_crc(mp)) {
+		struct xfs_da3_blkinfo *da3 = dead_buf->b_addr;
+
+		da3->blkno = cpu_to_be64(xfs_buf_daddr(dead_buf));
+	}
 	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
+
 	/*
 	 * Get values from the moved block.
 	 */
-- 
2.39.3

