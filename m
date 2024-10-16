Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A344A0C;
	Wed, 16 Oct 2024 00:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037513; cv=fail; b=t30SEbxWXUlDK21L7gvOAp0aUs4OrHQcSV2Dsg7iZ26nN3cBrqXyfWpTh1dulO+9ML7Yyd+QbcDrhRK7fRldJyG0R6EnzUwrg89ZT6JMlGxzQrfIeEkt0FIqwu9fdmRgSESG3Wnhxr2/KNj815RGjKB4R/yiwPaM27p2FLgk7og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037513; c=relaxed/simple;
	bh=kKVIWG0p5QgolIty6snB1psL8oE8cwVDu9CfFy1FJYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=vBjQyI1V6GQwqMMRVu+tHMZCpQWFxsRBMbF14vNliNQ6NRLhts+LP3Jm8AH/nQsnByfad0fuXaVPq3191Tw3qDgqAjWFD3spe0JgI1+6du+W71KReCNyrJWCyNW7jQW2MsKSFUvPsgBTTcWbF5d/eqRW2R21ZIV+Wogqc5C+h/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mPuTobEh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N2ZXogkP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mPuTobEh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N2ZXogkP"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHthik024661;
	Wed, 16 Oct 2024 00:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=aTP9xYoMQ1jWUeM+IytL6txn5gwzIQnsk+HG7tNwKbE=; b=
	mPuTobEheCqHQpL4Df7ohXLjkBJBfH9qCGIXpfn0IYHg0kwU0IJhI9y3oJY311w4
	HTrPrIG1wO75X0nenUBV+lcesCr3NxEl+BA/8k2DjvO/duR3GOLxeuZw2fwS7QEt
	8ZHL2cqKTBu/L9dy85MBNcS4ZrM3d7/RkxSDAzhxaYLyKWLRb9wWfppdnN6bzqgr
	aRSSZAXRkQlY5jsmV4wbkdYkMJ5UBJJyCXwUPppLgpjTJzluvm16r312xQtYFRfY
	EEW6m78aiMXvkvMCWxe3619A4csiZ9COgxvpv6yxLxVHy+GddNCWaWkqjWzHUsTP
	XEiygaclfK8t6nMPW1Wpsg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h5cjtm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLXJGL036084;
	Wed, 16 Oct 2024 00:11:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjegwtd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qTfwnC0lF0yzkgPr1Lzw18s1Fb8k8AyxEhv1p8fpb/zrrjxJUNNcEAUaJlboK5YYqYnWlLGYQRlux/L+LFzm95Y2IuFa8p/s9HxSEbC9xO81FRAYmHnGvKC8uwcnrul3TudOubiVkkh7CiuATxua20J566y7gPvNLh0WOZe8n2o2th/5oey5zNa+SnhZ20nLM6ZuyKGAoBrS/dCQkHdiId+9kotsq4xi9cixe/gl4fDlgLZ1wk6Sb4tFFNW8lQN2OkgGHojEF+JMW/9bmO0vYmRMA/g900+o3IHx0rCT3UYRAHTdszJg1m1IMJOuDWFiCUFUTZMAi30Gfla/zW2Urw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTP9xYoMQ1jWUeM+IytL6txn5gwzIQnsk+HG7tNwKbE=;
 b=F+8cnxv52ca4NSYm4WOOW+y1cZ+oTjuDWoiQ+2T5VQpBAgA9Sq/fEEH1Q3dX9Pxqft6/q//AFHXrFsdJSNKeo9SdJJJzu4B5YSzAqadEsGNdHkeg5Gdnb4zNT8zdoO33t5bQCe9Vj4mfiBXfM38pAtPftqrPGp39dmS1tI4b9h5ya/Gw3xD9Pzw2sMDavBMs1lxtsmcJOATNUW9maeMSokPtM9KnSAy1ZKPoIhuikgeP1uvm5D3ORbAL+/7EeIsc+vA9cCq54V55nlv57IV7d9M0OYcTsqr1SkuMT46f08qvbQO7QvxJX8DVlsqqyOzKCnpkZ328r/bCUmkWB6rJLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTP9xYoMQ1jWUeM+IytL6txn5gwzIQnsk+HG7tNwKbE=;
 b=N2ZXogkPiOPwdaLL7bZ02Fpf3SJlNX+5ME3HqbWgemK0YNQkymX+kqwhCUBUt19AGMHddn+T1BOly7kB/+1Of6ZT6KRdzw2W5DRA98EqgjMKBXI6AjLkUu/jc4ZJ0UNyYulSBvxuKXvRjdpEp8qcXqP22SEMwl3vi9H1oJV/S9g=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:11:47 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:47 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 09/21] xfs: enforce one namespace per attribute
Date: Tue, 15 Oct 2024 17:11:14 -0700
Message-Id: <20241016001126.3256-10-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0187.namprd05.prod.outlook.com
 (2603:10b6:a03:330::12) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 870a758f-c243-4835-f7e0-08dced772015
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D1jbpWnUEUxnHlC+fQoXmyNHpeYjoiJWf3pyiityaZVlW0dt6cmdrEn3m2uA?=
 =?us-ascii?Q?Yjj6eNtaQQWP75oGpruioEFrdZ19ZeBHZqYlsCX7kRkpM279IyPayeCfdpJF?=
 =?us-ascii?Q?6z5R7xJ/HgS/7aBFSAOnZTrsoJq8iqreaYgF/GASBARZKnX9gHJVVKZCrXAl?=
 =?us-ascii?Q?nqud3ctQMPFI+s9qYC5WWAEDZmMSPWPzLGHAXzYk7BiyhkRFB0Y01JMIOHv9?=
 =?us-ascii?Q?ALjuw4yPXJO+tl6HslUAcZ6wAbJC2Ura4XQ7nOJD+WsfVsoXHZ6G1zJkVblm?=
 =?us-ascii?Q?FuJcj0+7aqFDup8F5jMR59FsZtTeLX+mLVM/EFoGHzkcl6jJgyECWHN34Gfu?=
 =?us-ascii?Q?xu1kbPoVf5QXkAGVJJr+u8BrPvHgkVxm7cc7OMVzqOCZKhxwE2Ztw/3cCXJ5?=
 =?us-ascii?Q?DWKvESdBWnmHCp1MWRR+6gnhLkb4mIDS3fThib7Y9VHG6JqkU4H0cPV/c226?=
 =?us-ascii?Q?p2GqQxM4vSEf0YM033TnWPUYE+rUK0/XRyDsDV88CxboJIRbTKFyu4IsZu8d?=
 =?us-ascii?Q?ue/x5IRestIIZsigDjpIgcNUhKXpYhgLNLvTSbUbZyUeDncSZC4j9MiEPUTC?=
 =?us-ascii?Q?lYAw/Xu7/ODG6Pzr1LEgzYiE3i+1D24d4oQqFOrLST1n65TvwYABV7Cy2tFI?=
 =?us-ascii?Q?8CTrMNMBvvf6zZfQllIziX25PYZnkgkNA7YaxfOihWOSCVhQt6vmLXjLib2K?=
 =?us-ascii?Q?tA8WCpRvUmZijDJxLGAwEBviTQsf9MoCmJ/2EqlnzQE5NYBpWTMRsqAooz1S?=
 =?us-ascii?Q?BEORK5gxyxFjSlOQkJJNuWy/dIjZXJBaGtA6eEPKdCBse+0glEAnWeh35lP1?=
 =?us-ascii?Q?y3KHUGoLYKQ7li+Fcs7Q8sgEeicx5OM63ecN+NkJ3CuKYcC/OrcUxgfUqG/X?=
 =?us-ascii?Q?TVwDSJCfd7IYxPjZOuY5zkvu/kMwBYu0F4dC7MFTq2Q6gTWJD84EGU88TgBs?=
 =?us-ascii?Q?c284DUsKLvagHgfqOfAh5HhbCPQgIN9PO/JXqbYiUn4gHAVNQNAHKBuyRlDC?=
 =?us-ascii?Q?IdLR2LILp9AAw8thgciXpeYhSkOfUTl8yX2xDBkEnbBdlbw3kFytn44m9XEo?=
 =?us-ascii?Q?7Tb13uK39Bv7/dZ6l9V1m5+zSDPF6tzh7gfzhFZlfwpLeNh0Q8pMnBtg7CCu?=
 =?us-ascii?Q?ag2oedrIeZm5wR/fKqYAyo25xB2JW8qNqv55ZC3wfNUzC37W+YhkouZyW1U4?=
 =?us-ascii?Q?gqJHH/dmqtE2Y0lI6Jt1Smukipx04npbi5ZPMhAlkzlj2lnPeEHN+CfX3826?=
 =?us-ascii?Q?sv4vu4yOOyy+UPhKIuBaGluJx96ZvkFyA7oSasriWA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NyvpN6rNbXPZxnupAJvxBSo7HTDnU1SKUQ9G64mC0Fiy51nuPXo7ddAQbeH4?=
 =?us-ascii?Q?rTLIfc6aby9zfcbwhk3PCZZ+kcqSza5pRLVQf9tOfwW4TTNrXnmshh2k8IMt?=
 =?us-ascii?Q?GbUsDcrBgGGcIU6r0VuBebwBVpcXLHdggqGwjr91iouR61UnWI4RlliHJQPk?=
 =?us-ascii?Q?yMfIY/zFAMuM7Mlyr/MhXxn/Eq8uzCTDVg5VklzMIDmGoSeMl8F6E4+GsUz7?=
 =?us-ascii?Q?n2c6sfg9IQ7w+VNTAnTi3klP98eOt3+Co2BWSXQZAwjcE/oXCkuE5vK3cPW5?=
 =?us-ascii?Q?4Upy7nBIg3gROYhwzVaVCqxUkRBNA9iPsdgEz3ApMb+mX1soNvPD5d0JXSdc?=
 =?us-ascii?Q?KfJdtXlOGcESvSMM2lrlezuoaZMACB2YoCAJXN9Oiy+B+7wFlFY2okm/BkAm?=
 =?us-ascii?Q?QpMyvzQuTm7A4ry1m7QBigfB7uRl/U3D8rCIfzX7nrTuSQSDyR4m3cQ5H6Y7?=
 =?us-ascii?Q?x21yhwdNad7l7gKK2BKb7qMy4tnpcovGOvrvjSr7Bo6jGlR8a+G/7wqkw00D?=
 =?us-ascii?Q?YTobfj33cq4EJWdJ6yTSl6hHPs0Q7EtmsqtN7gpCEULbjAaEQetYd6erf9y2?=
 =?us-ascii?Q?6vMeyx2+BMBPkUIB2zk1j0OTTVqtts4trWZDyG4vgXH63IJivA8+V0txJMGI?=
 =?us-ascii?Q?foHVRCqdOuzxuf2lzdgf3Uwr7rrt0hui/hKjnULN3bLMVeUFMB6OXPdO/Q8Y?=
 =?us-ascii?Q?1239zgo/z3xq4tvrK4vafSrD10euwAYPHyomIWiF2wnm78NrBVDyDd/X/0ei?=
 =?us-ascii?Q?Z54DLc2/3cI3wbnZ/XnXiNNe/6nhX54Px8fYuRVHrotA1MObpQ4AvpZPMUJK?=
 =?us-ascii?Q?TMsl7rREtnEqJwY35Xm6yOpN8mA1CvBsI1OCKKBej5PzGl85vBvZGDGB76Hk?=
 =?us-ascii?Q?OjaC3U5IkryuzrOKyqTTo90ryzIi+LC/tHtK16bB4ioVeAzMhBgs2squSIsD?=
 =?us-ascii?Q?7kGM2vNVFSHGwSFgf/vHskqvlNzgou/Ulcux1yuYWJVMaNv3pm5Cuqq8J2c5?=
 =?us-ascii?Q?cEV8Jk2xMePNIs1QPr5Wu3jNiy8Hs5cz7qXBD5wiUkfvBWQry5xFnp5DH0oO?=
 =?us-ascii?Q?drA4RgmWtDQVLHS2mW2oc0J7/lvVz9ZqwXJhq7ABwzX/DXmAOs1y8d0PVG8K?=
 =?us-ascii?Q?glphSk2bp7t6e2UaGqJ8aH9pTkK/W1xFWbIuLKCvUBhMT5O3QLwWxdQP8K5O?=
 =?us-ascii?Q?7R2hgEJRYncfeuBy5sN7XSzcKzOpdFrVK30i56vS0F8/1tsr4WAsfHK+rJGp?=
 =?us-ascii?Q?Ka13ZU/v96+AcoHT32JUuc+XAYUIbTnrSv1zl87XWCd8ZJxvifRBXH1okgCA?=
 =?us-ascii?Q?F7y569wDk84v48tjg33nst6juqoWefdHQbeLI+64Of5F0YH08wBqPll+OuBF?=
 =?us-ascii?Q?ventEeWbAc+y+PHmhVWSuk/0j2iFS6UhhtdRnqzsl4KJrz7gbQ8Z6Xcndka/?=
 =?us-ascii?Q?gPV/+uctcw1NAOuR9AKk3fysbh+cPT4z9j6/+r2FaJv0T4yNJoOKMLU/+6JR?=
 =?us-ascii?Q?WmV8d7PWGIpaykZgDCwtOirfWONG2aa8Fr24l88aiesY6vkwfJ4J25EQ0cW/?=
 =?us-ascii?Q?kUK39P05JmI/5yXXLN6a4anV2A5Zpfb6UD31Wqexq+3g2irj3sa03kTnP4d5?=
 =?us-ascii?Q?8O0dhciIKI7P1brjlRlW8HkCNLEZz8zllsj8alWk1YEisWbOYJEKjaUh+oZ0?=
 =?us-ascii?Q?t/u1JQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kVK+HONwle8FCbaNG71JW813EWlrMQsI/z39dxM4Kn1xAvk6e8FNgyOmadO8YbYRYPFV2Hdwr5khuM5rglD+5038thBmPHYUQ/0nC8j50vivDyh7oW6GH7uZ/9P0GEoyYGm1o7hgnCnx7IBnNmmwbmPHPzp9SlkPSsIkufBH9sY0hKxBtyMqE4RQXL6mtqSDDXruYIuVSMTOLazn1ETVMDEGQASRX/EByDhrFJeqjE5CuDgrPIjz52jjuZAzWLiPaTU7VqqF5vcE1/r/RUJtJZoOaBG8LFvtDNw41txLezbMVZqu1ZXAvcFKcjtgsWA8/cUsqvLIk+Jza8ALooG8GSrrlrl8jzmBNChQW/yrm5gYUlSnQDcq6WlHN7tWWLT3NpnPUvjZanFD5vp48srPIkFN3Z4VHwDeyWQOZkdO9b/P4yCODvpPtU1U5rrq9S9FGFEwLbX5c0D9fqAZkt/SAMh0lvjsO4ipbno7+lvVcsBBgb9rYjihFzFuqMJ+mbfqEBznQC+F5v1hyiiwBv1X6qGV7vJLFc6lC+C7caVscoSMCVrxEGIfd3IoMEeGmy4C4teKgyOPY2pJO/70Cq/9PIl3r/mnVTj4WyGO4QqJ7JM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 870a758f-c243-4835-f7e0-08dced772015
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:47.6659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rejgugnYHCdvz5YoSzd7ifzsXBOKcrnJjVGOS8daLGblqINtfSgwI0JogACl50a8Q/reJ4EDX/qv5Gqnz0e1pEaeU4V5XCdrKpVg3aFn7R4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-ORIG-GUID: v4R17CFdqHcVMoFXDWgkciQIX-5-WUTh
X-Proofpoint-GUID: v4R17CFdqHcVMoFXDWgkciQIX-5-WUTh

From: "Darrick J. Wong" <djwong@kernel.org>

commit ea0b3e814741fb64e7785b564ea619578058e0b0 upstream.

[backport: fix conflicts due to various xattr refactoring]

Create a standardized helper function to enforce one namespace bit per
extended attribute, and refactor all the open-coded hweight logic.  This
function is not a static inline to avoid porting hassles in userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      | 11 +++++++++++
 fs/xfs/libxfs/xfs_attr.h      |  4 +++-
 fs/xfs/libxfs/xfs_attr_leaf.c |  6 +++++-
 fs/xfs/scrub/attr.c           | 12 +++++-------
 fs/xfs/xfs_attr_item.c        | 10 ++++++++--
 fs/xfs/xfs_attr_list.c        | 11 +++++++----
 6 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 32d350e97e0f..33edf047e0ad 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1565,12 +1565,23 @@ xfs_attr_node_get(
 	return error;
 }
 
+/* Enforce that there is at most one namespace bit per attr. */
+inline bool xfs_attr_check_namespace(unsigned int attr_flags)
+{
+	return hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) < 2;
+}
+
 /* Returns true if the attribute entry name is valid. */
 bool
 xfs_attr_namecheck(
+	unsigned int	attr_flags,
 	const void	*name,
 	size_t		length)
 {
+	/* Only one namespace bit allowed. */
+	if (!xfs_attr_check_namespace(attr_flags))
+		return false;
+
 	/*
 	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
 	 * out, so use >= for the length check.
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..c877f05e3cd1 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -547,7 +547,9 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_check_namespace(unsigned int attr_flags);
+bool xfs_attr_namecheck(unsigned int attr_flags, const void *name,
+		size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2580ae47209a..51ff44068675 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -984,6 +984,10 @@ xfs_attr_shortform_to_leaf(
 		nargs.hashval = xfs_da_hashname(sfe->nameval,
 						sfe->namelen);
 		nargs.attr_filter = sfe->flags & XFS_ATTR_NSP_ONDISK_MASK;
+		if (!xfs_attr_check_namespace(sfe->flags)) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
 		error = xfs_attr3_leaf_add(bp, &nargs);
@@ -1105,7 +1109,7 @@ xfs_attr_shortform_verify(
 		 * one namespace flag per xattr, so we can just count the
 		 * bits (i.e. hweight) here.
 		 */
-		if (hweight8(sfep->flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
+		if (!xfs_attr_check_namespace(sfep->flags))
 			return __this_address;
 
 		sfep = next_sfep;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 419968d5f5cb..7cb0af5e34b1 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -193,14 +193,8 @@ xchk_xattr_listent(
 		return;
 	}
 
-	/* Only one namespace bit allowed. */
-	if (hweight32(flags & XFS_ATTR_NSP_ONDISK_MASK) > 1) {
-		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
-		goto fail_xref;
-	}
-
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(flags, name, namelen)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		goto fail_xref;
 	}
@@ -501,6 +495,10 @@ xchk_xattr_rec(
 		xchk_da_set_corrupt(ds, level);
 		return 0;
 	}
+	if (!xfs_attr_check_namespace(ent->flags)) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
 
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = (struct xfs_attr_leaf_name_local *)
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 141631b0d64c..df86c9c09720 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -522,6 +522,10 @@ xfs_attri_validate(
 	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
 		return false;
 
+	if (!xfs_attr_check_namespace(attrp->alfi_attr_filter &
+				      XFS_ATTR_NSP_ONDISK_MASK))
+		return false;
+
 	/* alfi_op_flags should be either a set or remove */
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
@@ -572,7 +576,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(attrp->alfi_attr_filter, nv->name.i_addr,
+				nv->name.i_len))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -772,7 +777,8 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(attri_formatp->alfi_attr_filter, attr_name,
+				attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e44..9ee1d7d2ba76 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -82,7 +82,8 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
+					   !xfs_attr_namecheck(sfe->flags,
+							       sfe->nameval,
 							       sfe->namelen)))
 				return -EFSCORRUPTED;
 			context->put_listent(context,
@@ -120,7 +121,8 @@ xfs_attr_shortform_list(
 	for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 		if (unlikely(
 		    ((char *)sfe < (char *)sf) ||
-		    ((char *)sfe >= ((char *)sf + dp->i_af.if_bytes)))) {
+		    ((char *)sfe >= ((char *)sf + dp->i_af.if_bytes)) ||
+		    !xfs_attr_check_namespace(sfe->flags))) {
 			XFS_CORRUPTION_ERROR("xfs_attr_shortform_list",
 					     XFS_ERRLEVEL_LOW,
 					     context->dp->i_mount, sfe,
@@ -174,7 +176,7 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
+				   !xfs_attr_namecheck(sbp->flags, sbp->name,
 						       sbp->namelen))) {
 			error = -EFSCORRUPTED;
 			goto out;
@@ -465,7 +467,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(entry->flags, name,
+						       namelen)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-- 
2.39.3

