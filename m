Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0801D79AD
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657151; cv=fail; b=a7lcJgdNDDnyLS7m3N9MkTTJKolvUN6daSUhCefWmPpKaSCGycMl/pnKtPL9SqHmqNaIMMz2OBta9/LFlJ/FUmjZksuttfF66aDOdCxkMavJIVwFIKdGAkld5TLXJJkUNLlGhnoSivFzrQKiqfuj+L9Bf5wtoiEHZRQOGbAd2AE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657151; c=relaxed/simple;
	bh=pTvhCsPdBqd+3suk9JeashoDNVt3VxpLxDmgHu61NwA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BNQzZVgT6sTBCc+L+bSTE2VpRhhpDnYojXcEzNpImWR2j9MJkjOkDjCE0BMWd3oijdTYmsBB1DWY6b8vVF8NxK482gRqvcxtJlRT9F3gISFOkWYyanDZ1030Ky3SinuClYu46jgB5MfWsI9yGFFaIqsW+CVb5YeiwleYndEGCfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bTrq2Z/F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nxDsttIt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bTrq2Z/F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nxDsttIt"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KY4t5012800
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=evKcOv+6Qp/Niv2wKcPN4j9qJ3CTnZ+LcLZCqWEjlk4=; b=
	bTrq2Z/F85MrxD9238/E2KA1f6YvOaGzPnQOqO3V7fHAucunebc2D92IURfOM1M1
	/1WiOn2zYi9kupegn4KnRn08LMiDmf7nQMDedmlOWw9uUpWrt1R2k/lbsiobTJO+
	/c3DAZoiqnGjWnngwhw/wCVRZPsYtm8SyE8hOT9DPSz6DeNmBGfuUfebl8eMvNzB
	Tpxos3fxShgtAAdMLp2uauNmmtPxSbSOSo6H/YoF6iaVDdusEFw3XmMh6Xm7TklX
	AX4L8JO67Qjq15Fu0ff2MRCHdEJpDFlYNWKTSKpsfyuK1WnbnsfO+w6eEtAYySBo
	Asjqdb26SLhTnd2y6mh4hQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkajc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486K1VjF018007
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyhf42q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KjMteMv8FRM1G+lfnBeOkzJqO21AoFWpNfGj5tDbQGzyp5sppnK+SsBREFF1C6qkD/AsJNjo69RTla/wcKxDBNpaumJL6UBBLb5zMffuaA6Qb/wcy1woRtWnr6hnYrD1qsJW4r3sbrCxDq0FTy7Q32lGcReF2//8v5FGdFXOGKsxCbGU7ASk2w0pThI7oqzhZ03Za9xkR+IScDzV54mZ6dvtGoh7HO8SrXdb/BTr1894xSw4+PygmAUr+lki3otyfJ0kK3Zhvmtr5i5Lyh5AYzl2CJhrV1OSRXgiNwypRdST2qVAt8xxheWGW5CmMOARXX8OL8MIeZ5YAA52MCH0UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evKcOv+6Qp/Niv2wKcPN4j9qJ3CTnZ+LcLZCqWEjlk4=;
 b=TwWjUle2v7K6A76NSG08sytkRJkiEV2MO6vxVdjQqBaIxICVk5t7Mk6LJH4ypNTmGjWRug65oY5flm0CiBGydDJ7Tj+thcTkMgqKUdC8D/337/149fIX8jMTkQpuFz7/VoshXSGAxL1fopx2u8/zX8K9gCFAWlAKNkwb9zSZfrfoS0aCb4HBoIUIc5LFr07NqE0Sm8EJo9ol7YMck2RtMSzer8I8DuFz9fhgkTqrlhlPHpFzEjSHyEkRMtgYq5aKf2Hh8gxVtzgVCF5xeZvx99TA8uq7mqB14S0SpAd8rXHq3HDHGBI0RqpONkosK2vqAB46zcByfcmg9u5EeirRHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evKcOv+6Qp/Niv2wKcPN4j9qJ3CTnZ+LcLZCqWEjlk4=;
 b=nxDsttIt8/ODs6ubS/2oTagRNDO8cenOd3VWlTTtP1QE+7TBtgbf1PUBECr8w33TF+kd1VoHcLAkj7AdBrxxn0Kc0RcUV3ETn8zjlvBmqOwIMXPQyC4IZDD0NiOqSSIE5JCJ3gsersNZD3+en6z1u3VydFaycBAdXlZQ57VqsJc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:24 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 22/22] xfs: allow unlinked symlinks and dirs with zero size
Date: Fri,  6 Sep 2024 14:11:36 -0700
Message-Id: <20240906211136.70391-23-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: 7af1ed50-b8f1-418f-3bd4-08dcceb89ad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8kiuhPjeKvcGVSs2GMOhS8TqEExvIMeXG78YhkWZQs+TQ1UbNh7TsdCPuT6N?=
 =?us-ascii?Q?RODT4fYZn7t0m1Rph6yQxCEzI8/YaDT2IBAJ3Aj8dnrlnX29PjR58HZMBHOr?=
 =?us-ascii?Q?uI3HIhhoeagTC27A7joEj2LYcCgESTHvVqvOoD7Y98mXCiz+PMlAMgYnVFEl?=
 =?us-ascii?Q?H0BE363XwDUKQOR+RoZC/UwEddJAWAHp2n3wuMVCRMm+gfb8la3IOEkUiczS?=
 =?us-ascii?Q?oR9Syo0I3eCDmUO5R6L94UwaVFdEd3PrnnjGvzHv1MrVWNee5ymSRpd38vb2?=
 =?us-ascii?Q?7Zot5QtbDYPcdROCTWBEYqbYBjxMrsn/dSx2oY17CcjkDSfAZqmDiQmDqZyc?=
 =?us-ascii?Q?ooyjUHYM26PZccXxALQ3//j79zs1LVHeUDSuc7uBTNsd2nTDKpcwtWn5gY9H?=
 =?us-ascii?Q?z+K3fPOqbaJV3d7YbQUAR2c4q5F00ZBzYD+ciV3iwxFuKmeiSvsmzDkrkjmR?=
 =?us-ascii?Q?42PlvmsH210erIrhyuKmTE0KVp0Dv3g0Gp3TG0ipcRRQG5Hdr9Yqh8l/LcLL?=
 =?us-ascii?Q?jU7S7KFFqrSrjFem2Zcw27OC6aza3NsFhtZ7RLsMLSYLUXL95QjLgtXMozO4?=
 =?us-ascii?Q?3jp8md6ohwKkb3oFbCl8sdrHUc7rahLTvM5RZYX7sEjocsRVWI1sZM+9LGco?=
 =?us-ascii?Q?shsvyGsJgodR3JntOoogOqMl+VQ9WxylWb2vy6vzukTEqmemtxAWR4tbNnRU?=
 =?us-ascii?Q?xYlDAvVLJTmpipaUcIhdzNxEIFypqlR0FYzPg+c/F3kr/hcLQ24oScNgdHr7?=
 =?us-ascii?Q?59kLYUhA7ZJ7TNOa5i7SgBJ0njfWEUZHiLl/eYMkcUE6P9/LlCuoFNIyapn/?=
 =?us-ascii?Q?IfOjmqP8fSM0U72e1vC/92MWPdZAqaUD7dR7mdMzVvduWnHskrvlLNhjYWRI?=
 =?us-ascii?Q?3fw7dAcN/wQfg4Zi95INr8flWpqXv3YbmViAshvGZzFgBSiPjkj2/1Addl9f?=
 =?us-ascii?Q?OENnmCDWQAjwRvGefDxs/p8P5zcKsRo8I5Tsmp5azZ03B1dFyQdO+aKG0s6A?=
 =?us-ascii?Q?Jso13y9aD8GUvayWDZCWW/yjfzJXX1/PGoyOfNWm0yiuL/NvmDV8Db3u1rGM?=
 =?us-ascii?Q?AxkPKwKrNkCG5y2g62OFUKwlYZVBn6AeAnyO22iV/CGJrfLQr5PW1nH4LU86?=
 =?us-ascii?Q?W7u6b5S+3WTF/17vkxGoChMgDcALszRlwZw1HbwCajqQq7ReOdjaQD4u6mUB?=
 =?us-ascii?Q?+KJPsYGzv/4qoIeWflEiudMLfX1P9k5h6rZai1/g/md6ajUhMz1uXKS7t8ZQ?=
 =?us-ascii?Q?Igle7S7YqrtQznm+19n1dlPYNqtLudG5q+AJ4Vahxtegq2mZswItBjgjAOZD?=
 =?us-ascii?Q?jCQA0BIvksVZUibbabGHILGcFy1Qe5VKkKv0+EBUi5n6Kw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iKA7bufyRUy7dkV230A0wh7JIv4S+wwp9HDACmQ//A4fZc06AF0DAMmM6+z6?=
 =?us-ascii?Q?qMM69xTAnihvjNW94koUbYvkFy0bRATQfJfJlFMtJ1bzSv8vHaMi6i1rLeqM?=
 =?us-ascii?Q?16xamFD3nGNdXNgc9nR9ln1LLtIP6s3e25SpgocBNW19Vf0m4GM1b09MxwK8?=
 =?us-ascii?Q?+wvaVGQ2a/fpPNTIwaG6r8eEoFi6PjLe+BrRY/PysZqZDtJc1rkwCoHo7tBb?=
 =?us-ascii?Q?mNR7sGQvAA+nqA+AwjcW3oG5Vm65REjiK5OX+gtbwot+zZj2UfkM+M9Zn2Fl?=
 =?us-ascii?Q?7mR4VMWapkQKrmY2ihYcXHhvUDar9sEw892HEBuNQGgTjDJqx0+r2sGdGkOB?=
 =?us-ascii?Q?YNe1Fd0f/PWa2pe+DjC/ceh7rhn85rHxESq82/SzdIZx9PQnfRlHyICb4XgD?=
 =?us-ascii?Q?LslKVzYGAAXM7jeazlsoi5hhgDRwLbfg0gIa3k6APPdp4I0YBwYeueaIY+eq?=
 =?us-ascii?Q?EQiVma9hLQN5uwX2U725DVldbSfywG5rQdS2fRkVvvAlsXaOYbI6mrLGZdnQ?=
 =?us-ascii?Q?/uz7PqpWjvBetF23z3iChdpR9AF3uIbAAQpCkwECRg3UKcqqZ2b1qJUKj354?=
 =?us-ascii?Q?fwhK8HelWsdjaKlF9Uo/hqlRdI1lcOQP/xyuqW4S3QYCoX/fzz8A+HHf/bYq?=
 =?us-ascii?Q?LYQ70ZK7hJ1xDmZPZvQh2lDMxCp2iyjihMF3pLPZ+I/jpyIBKgQZeHHaTCCQ?=
 =?us-ascii?Q?wIbR29OAQQouGPU2FCaJwlTuTrJ/jp1SphXL1YDk+YD6QbWZduRpVH7+FZnj?=
 =?us-ascii?Q?/m3kDir/ZwT1y/d/4q2eMwgz61uAs6TBlHpbBXp65XzzEPOdrtmU6M5anzwh?=
 =?us-ascii?Q?k+dbki1j/5Kf7xohSjXhzOiQEGPLFK0cHUC0rO6Q5vA/nbOn2U4fXyIQn1jm?=
 =?us-ascii?Q?vnIfX414TqV20cJTaJhH2S6WFDB9oqsIcej5iT87mp8q/9cxzD3w7tD3DcWQ?=
 =?us-ascii?Q?/mRPHgiQVS1r6cHnjCE3OxrZMMIBfk2BPHqA5Ku1VJMpNs4EBPKGBgBsV0VQ?=
 =?us-ascii?Q?mY5cnrymVFss0FlQ/LF9TCPoKxPSjvXsBO/jP5zhi1QmCtQCMIlQ2SZxLUgq?=
 =?us-ascii?Q?mERsLgI/Ey15b9hE6jNP7FrjXAJ2OvVwdyD0jfN+gphXRCYKGAyg3HY5zjCv?=
 =?us-ascii?Q?H4MOtls4ZboCiNuNys0b8q15MH3KvdBfwyx/Io/qeDbqCuMUTQT+BTzgN/Qw?=
 =?us-ascii?Q?2T27YdXyzy7/6PcyUQA3mdLSzSTZ+LAIxVrTstJis3/xywv7JywHdrmYQ1MG?=
 =?us-ascii?Q?rBVF9h9P+S4rLrnhqm6DHoornyyyunXqY2ANeT/nmhz1H0I21xtRUApXtpEm?=
 =?us-ascii?Q?okWSmc9b+g2xUGGfwZezMqE7MpaEGAaH1DL9cusuwQaxBOEjSRHUkBwLO/06?=
 =?us-ascii?Q?T7SSBRrtLu2cZ0IW1MeeHp8z8AJmThCe37Ck8BfBDyukIhCFzdbZZrdeku3v?=
 =?us-ascii?Q?Ab9oBRDMBm5if0CFyF5apC/AvlvSR0ovb9KfBeOde8NS0PTTPktgtt4uWnm8?=
 =?us-ascii?Q?ixftY973Sxgq1r5MrDhTJl8hJkQ4j4VMQIpAKfVl4nG83h7AnzbiiQDc8uCy?=
 =?us-ascii?Q?+4IaTPXjw1TK8kIA4AFhDvxOgrtpv4YSPeqKCQ+30MRZKYcJEODj7UEjQRE2?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KY0PQD3AWRxFNIkioyyCJ5XPRq+gYHg3xiLNOUQkyWm+awlr/jigeAg6JsZJeldztAlus4S2vq+vVecnTlY/XoXx2koAaI35cIwuvRPb7xOxxViEQ5mwwBJiH7+eV+1ALnfWx1RstpbVsJHvDVodt7oMUChaOilbh+8xRP7saObm/9Za44f/7ff/f0KUtWbSYJWQ4zDo+2A7pzOTp0WlkV1tmNZanHdEeUbJUtZgZ16ser+VLSyLhUumO3CY1crp1WtYMXK3upRNp8C04Dk/yxMA8gKF35AmTJgRc22VR7HIbIP4JXhhmGv1lsRTmrxSg3cLiVO9r16jM0SJwv7tl3xHpkrkySS3Uqq12UCbJGhOVLFb55KbQuGY3FL1HrTMftmAQpP5MuOyiund9679LmvOc6VRGLHaP4yjOl5SStOmyaQiMyK2KU7rmSdebW+FF76LZORYgD64wrqg01KFDGaVjNGhfsozxL1Ge/H3L877zm7UwiJZAwxRX3K4Jv9eQYy+w9A4cb/AaB2uNvKN2wk7Lmdoeh+gUXyI/gcZjUayown/VVpJjvL0OXO/hJ1t70rVU8K1L2sjqQLi4uYdZqSlrADPinb6n4GkCjiSmJE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af1ed50-b8f1-418f-3bd4-08dcceb89ad2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:24.7719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7Qfx7cOupSHluHyFLoXQQ6sYR9TzjO8LKFsW96/oZlsDVPb9aYYgwqhGUXR2kTZwkf4BJhQEugqxDteejEg8c9ks0KsiVcxmOcJH0PSEKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060157
X-Proofpoint-GUID: zzBQGJjnNU-WnxSunKGYt5PPURoC_cN7
X-Proofpoint-ORIG-GUID: zzBQGJjnNU-WnxSunKGYt5PPURoC_cN7

From: "Darrick J. Wong" <djwong@kernel.org>

commit 1ec9307fc066dd8a140d5430f8a7576aa9d78cd3 upstream.

For a very very long time, inode inactivation has set the inode size to
zero before unmapping the extents associated with the data fork.
Unfortunately, commit 3c6f46eacd876 changed the inode verifier to
prohibit zero-length symlinks and directories.  If an inode happens to
get logged in this state and the system crashes before freeing the
inode, log recovery will also fail on the broken inode.

Therefore, allow zero-size symlinks and directories as long as the link
count is zero; nobody will be able to open these files by handle so
there isn't any risk of data exposure.

Fixes: 3c6f46eacd876 ("xfs: sanity check directory inode di_size")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 51fdd29c4ddc..423d39b6b917 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -371,10 +371,13 @@ xfs_dinode_verify_fork(
 		/*
 		 * A directory small enough to fit in the inode must be stored
 		 * in local format.  The directory sf <-> extents conversion
-		 * code updates the directory size accordingly.
+		 * code updates the directory size accordingly.  Directories
+		 * being truncated have zero size and are not subject to this
+		 * check.
 		 */
 		if (S_ISDIR(mode)) {
-			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			if (dip->di_size &&
+			    be64_to_cpu(dip->di_size) <= fork_size &&
 			    fork_format != XFS_DINODE_FMT_LOCAL)
 				return __this_address;
 		}
@@ -512,9 +515,19 @@ xfs_dinode_verify(
 	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
 		return __this_address;
 
-	/* No zero-length symlinks/dirs. */
-	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
-		return __this_address;
+	/*
+	 * No zero-length symlinks/dirs unless they're unlinked and hence being
+	 * inactivated.
+	 */
+	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0) {
+		if (dip->di_version > 1) {
+			if (dip->di_nlink)
+				return __this_address;
+		} else {
+			if (dip->di_onlink)
+				return __this_address;
+		}
+	}
 
 	fa = xfs_dinode_verify_nrext64(mp, dip);
 	if (fa)
-- 
2.39.3

