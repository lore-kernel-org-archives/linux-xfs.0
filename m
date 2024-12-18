Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923B77080B
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488088; cv=fail; b=btQcJufXtOJc/EPUOv4yClM0HW9SwW28gYXGpB+O/gPrF4mHa9Xojj+qAWOgvoyiPl2Ad2kgcI3uwpm/QsT/hoSwUb8IoIKfOvsz2fMkXiq2ZJfqgb3XrQML19WFwo6oqKsGSDVIhLeyK4rwKdJUhQhdDla7WLZ3v8AWvNTpS+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488088; c=relaxed/simple;
	bh=sqtIIKavIi7m4F0o4lde2qHXmd6XAisBPTYgw0yAUuw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FWc1zL9A1mBZ+BAmwFsI6t3qmkNc6PiOGS5zCLc9jvJA5RDVUuJvpkQTETSdIElCqnub9fJEvZBUOI5kUL99PV32jSJk0xeM1EeDOGZywiu733lvfyDVKp+IwEWiHCRRs6kn8/8qAiJ6ny5YKOBT1BXxCjpQOf2MUtCuapXcFDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AJQIF+dT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=plrWI/2e; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AJQIF+dT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="plrWI/2e"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2Btqf029108
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=2FVMfHGjaKf9iGKh3bOxlFU9UAkPOxsA8/T9if9UP7Y=; b=
	AJQIF+dTRA+EHrQ0v/g05HwCryZyMmVdNHXbPHfIb7WECJrgp79+7TSvevJ4XHPp
	lsBNT4iyBmX4C4oztTNdYxXp5O4L11uFk3sLj4TDtlzGCbh0j2H+62GrT7t9lLbt
	I1L4yVCYfzMmTpFnNMErIhMxB2NDbKtmx0kkD4BpjxBVZOg3ZhkdFveu0pn+0Ptv
	GN/EfuyCm9N5eECNdvnFf9HIwsbD9keL2YcYabJmj+NNuAUFazUPeTNcnxWFsYbB
	NFK+8W2jbUPYNk65lvIYvZMP1fx/iIP1O+3NzMD6WbR/XdhH2Q2pdMzmXCLAod+O
	yFnrh64VQoNtSxGw24kr/g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h1w9ff86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI1TX1R032572
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fffbh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rhe+9C7PYhT21Ohugpic6PI20ZdBwZerln4IITnISJfo46OxfnS9r7Zrxym7wZZnmQRKy07z4q8NVJwaZ47QTXNXydyu6oQDFoX0CqIlibHy1fSpoi44PYh0oYjCEj3YTR/bMS+A6I8OoCn/9YvBLxeIa4GfJ1qUGY4Ffl5egypX5obKbLI6yOx4e+Wpz2a/i/Vo07HgJZZy5niOU3MmeGTehsgB30jFOQ5+qy9SaJpOKWKDXZQfqD3K2PqT0PMzjc9F96BvvXoTBuH3h/IB+bmJFLSa21Mlmbn7t/6od23CNodl7s7rW9XvzUtEi3xtCXpYNwG03ViJMXABRtctZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2FVMfHGjaKf9iGKh3bOxlFU9UAkPOxsA8/T9if9UP7Y=;
 b=bocihWSUGRq005qhQlLBvVu8X1ggm3p2tpUqHqxvlBsAihQVcEbOLrtIJYzZb0F8vXeZM6XAIx5kc+cLHAyoGkQxtsKNumFvWEP06LzQ/qjr/aJKIS0m8I9n16pGTapWF73/kt8APwZFLSFkDYSIxSi9JQG+8ZweO/PwWl/H/s+YukK8lUYJFqXe/2rQ4KMMn7UxS0f9Oubyj8jk699KiSnB9o+/VkP1e6Kx4BkaGIUZJU/h27o+4uBstRZAaHZDGhHp3TMdoksN7Vc91MNl3/yNrKffY0/tNTL5YfdMTR6xi8ugQptB6LAwxZBiCyxmvr6WATjGpUmkgetH1az2vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2FVMfHGjaKf9iGKh3bOxlFU9UAkPOxsA8/T9if9UP7Y=;
 b=plrWI/2euTcjWkO8OXojzmvfeDOFSA9fa5gDnLaoIoh3/0wwcg6EzG6oLWjGAcaXnusSDWWkqcCYXA4ea1BR9i9dzvxGJqc3yvkd4kCseBjMzyejTCKhVoLmNtNP5MTlZxGmLTKs4KPVuy6alYGZP+tNTOY1YCHipdJzdGJ8zeM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7577.namprd10.prod.outlook.com (2603:10b6:208:483::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Wed, 18 Dec
 2024 02:14:42 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:42 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 16/18] xfs: Fix missing interval for missing_owner in xfs fsmap
Date: Tue, 17 Dec 2024 18:14:09 -0800
Message-Id: <20241218021411.42144-17-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0181.namprd05.prod.outlook.com
 (2603:10b6:a03:330::6) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7577:EE_
X-MS-Office365-Filtering-Correlation-Id: 49686fa4-b68d-4a5a-3bd4-08dd1f09bbe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V5MKodUPJtBUnkeXd48j64K66PLwro4kifeCaC1nYLR9q+kq4UshZFPnzyAc?=
 =?us-ascii?Q?lMgddAZygkegw8fNl8rWQ/D2q0aoU6yGVUGCnBAIXPeIJ5ybgLLrG8kI3KuT?=
 =?us-ascii?Q?Q5SXGvmpvN8gUohXQgAZVvM3g9E6xkod466wc2n+GZs93u6qQO1vqlWVMHtr?=
 =?us-ascii?Q?rfXztyraa6gLRwuXrUs/msfLhP1LWBUVxo6O20d2mKftCToSY2QhIv98RSJ4?=
 =?us-ascii?Q?JNsfnoqbupBTKCVs/idGWCJ88/revU9L+eNFwjVJ/bzve+ZH41/m1yPddKMK?=
 =?us-ascii?Q?eTj6pN4NXt9prL8Pn/iFQTj4DasPzqrS3u7rmh7+9L61OxzMB6wsLXq0WT5P?=
 =?us-ascii?Q?dfdtG0enNG+EjK/eG8Jo5xvE/XnGjU6sT8MKZKi9g52tLEb4/Px5XMldWY2X?=
 =?us-ascii?Q?9rxDFPOQ1zwfXW8RScYZfprv08FOOzcouWjM62dXa718wS2eTndqJQZMIXY2?=
 =?us-ascii?Q?zFoa4u6ejbsn496Myf/WrlqfFQL7jxTvUwzDauKqlLbe5pBiGQhwd7VzvzxI?=
 =?us-ascii?Q?y4zqZki+MFKfqfADyPstKfV+SFYNgKEfZ6laQu60nQ5cRUC1OYNfRZBkcH1X?=
 =?us-ascii?Q?RO0RkR/fYH8/JQxyWKfuAtncKaMKcE5g/ynBlOXSqrJioSEAxdTIv3bgH8iT?=
 =?us-ascii?Q?z5vEtVdHrVnZ6UjLp05I9o5VbocN+Soysr2Qt3KmswvAczzgzJYe8m/mjuOc?=
 =?us-ascii?Q?JE4IRVaYQHy/FDEG2y1QtO7/AhQ/G47+liw3QXLICY1lRIvjRFjzQuCeJvCE?=
 =?us-ascii?Q?yrqr7ZYRPgb17tD6Z0/Au16dBXBzv6B8Ws84uS3uopyhPf1667FI1JyGSBEk?=
 =?us-ascii?Q?MfOcF6nq96Qq7Wb5IxCmu1Yg3Y5V3JhPWFZnVeFIJzGieX61gIwdjqb88/hS?=
 =?us-ascii?Q?hdxTwyVg4ITPCjw2fbfLcnCIusktuPW073hVy2eEzqPZzZjCD1qad5URugW3?=
 =?us-ascii?Q?75SbblTAWw+ctP1kNw4lYKsqLOVEWL7IgBDnS49OT6Rel26CXSlUodivYmQN?=
 =?us-ascii?Q?Wc8l1J7XDcZbLkIIMT/havmq3+MdfVvg8pcJAh4Fs7kV7CDwU9OR7oUzQYkK?=
 =?us-ascii?Q?E4uYu026c20Uwriop5gPg1JmXUZPwdrm2T2UJkB0DpHX+fQ8ClgA37NU00QP?=
 =?us-ascii?Q?stDGP/pM7XoVzhGx/bf31hqpldGh67RbMLmBliD/Nxvsbk6xrw3YzuJVB+fp?=
 =?us-ascii?Q?5D4kB74mC+RDWb8NMutijcmOyRcu8sZfyBeCi+pYIM85349HIkjfPgexW0OS?=
 =?us-ascii?Q?dUMKOYkGJ/07rU3fCb+FauD12NDQDOg6/P0ZobaHUhfujKkBhKYGsx4Pj3pm?=
 =?us-ascii?Q?8n/2Iyp+L4m7HjgCmPzUFZX56ij13WxMsk43CX2vSttotcCkkpOcDKbmrdz5?=
 =?us-ascii?Q?20jGO8MgCsDO7AajVx22/fkoJu81?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nzhSiOPBc/FCxiATnwalQ1VErlcRHZuV7266F/LZb/Ps8gyybxZyF2opho0O?=
 =?us-ascii?Q?D9O5bufxFO9sGm4d8spe7NNoVdoXMWsn9XFgMabwk8CjNXApGfVXDh/Z5Phn?=
 =?us-ascii?Q?nStgCz34z9UtXjnSK+QNSB2+rt034QyY4lHOcWthRBjhCwYbfqptEX070YLd?=
 =?us-ascii?Q?AwTgSr6ndJemw6mQuzgEGTeIBLAjhfjkHOM+YhCNnh2xzyVVNnUtmTobd3mS?=
 =?us-ascii?Q?ARcxPvj37JOLeXWZwMgHLHaBIViqQHH5/FAu/6YZPDEktn4AjNRlrTQMNttx?=
 =?us-ascii?Q?eTfMBZrwnJmbuGDfoahuEj0m9YGjZUFTFsgAVCkx9HRfAg9oqCXak0/mYsai?=
 =?us-ascii?Q?xAAesXLixBOkJpfl+e0hfwVMPT2CkaC57b/Re+c+j/jywxvo8zoYFfEE/pj9?=
 =?us-ascii?Q?b3mCfV7Y4m8PIEWuXFDNA9ZbjjxOPzSq10jnZlsU6M5xaqDCu386iFjpensA?=
 =?us-ascii?Q?ttnOm2qW4Cxutf6Riw1EMXQIHKXGY1dFB8vINWzxhdrfWH0r9II+AXIJPCkD?=
 =?us-ascii?Q?V+ii+E1MJVwAWtzrxlWgYZy9UGsLR1/KF6vDiue0srC17QiVkEB0cQPQjkSh?=
 =?us-ascii?Q?V4aB1cO22oKN8SoEv0cCAkUFsJL83xHY7jhdjh6yvRZtmTCSvAdYhexAJ/Gf?=
 =?us-ascii?Q?S3yPawHHsfiev6GQrB2YtK73mGN05S7cOE7s+Gd3NzxfFEiNBfuD9axopcpt?=
 =?us-ascii?Q?JgTnnwK4aGU4pPXek6nTN5dlOOk9c7spyPFKfmxZEm4uANKgvCS+c8C/H7RI?=
 =?us-ascii?Q?tpbrNbCLqSz1X0aV7UTo0f7MpANnCxIjUKA5jXr/oYZM7UNu6dHlQ7wK3pQ7?=
 =?us-ascii?Q?TP2NgGjiKjhYu7rzOKLrZaya8wk8PACfLY0Fkn/Js9z+ik4zWfgtfIesrhjA?=
 =?us-ascii?Q?D/2/+Sjfkw01HaZQEk1kslfGp14wOjymw891BzUUKNtcYsps3lSL+GyFezH5?=
 =?us-ascii?Q?xQu3dMbJ1gYHXIagjb+hTAkL/blEpWE90q72mtdIYRi60PedmbGAycCdLy/I?=
 =?us-ascii?Q?5OU/a44Z1sdvdZGQxpEScoCRoaBfY0VO5M9Iww9SskR8Z+glBPozK0ug7YCj?=
 =?us-ascii?Q?4xz+iYTG1XWKRez70gTMobFb5yF2I4vls/xsovgfsgfSbLFLnLPOk/7lXWRZ?=
 =?us-ascii?Q?+x6XVYwVDyw6YE4pBVm1xzhkAUnjoz0MJ4hixpGcEZtQ8KWKdKD0GCF1/vYS?=
 =?us-ascii?Q?NDMEFe70gWkGLD+ApDtZMM63+7/JSNtwGlOkZKSYSp+Hqhvl4d7rRTpbuVhG?=
 =?us-ascii?Q?Y7xsreWNvxbA/WknWSnGkg16hopDRAAniCdazOKKPYe9VgUW6WUKdCYvhPwh?=
 =?us-ascii?Q?HSuju+hTlGFQSK/IO2wA5RTYvwF1PSSpXPIcR5WQNdKdFgFBzrkFYxIxvo18?=
 =?us-ascii?Q?+YCjTPI6eTbw2FDPVBeTMZ+OsCWm2BgZ2oYJon1AS1NfjiUFa+x5fMVddim+?=
 =?us-ascii?Q?+SPW4Li1N6OtgZ2cWymsPR+ks4XwK6SRlXWX2suZnPX+p4C9DK/4cfRt6N/6?=
 =?us-ascii?Q?KDSiSaUbg3+MJF3dCJOO6aWW1xFkY+imxytVp0S1HkO6QeOLKpojTb+VOPAl?=
 =?us-ascii?Q?fqcuUaDNHsYtEn6hO03NfTkZMADxp5fKXDZUbO+FbUyPHaZ6coIjFeq94YAW?=
 =?us-ascii?Q?hnTjAg61S71xGRu9kFxsWiy5O8jSB731Sx+kBV66cb8vp4UvoBzBpyICgrjg?=
 =?us-ascii?Q?HEdIEg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hk3qsBX6LryDOaRlZF11qDwtk/r2bhb3Xq5+0Ri3gSwBKY1tyKUuN7mgSi9iBIXZe2igA+MPyTUNjlqH8Qc34dZtJFUhueU579KsrUSJeQpqlkeK2JaU+PlOm2JU6MQ6SAW4pXjLpb2CO6ur8w/BQqaYMrKVYW8+drjbWT2qt9kjfa6E2gZ08OrZaO+i5AMgPz19TDBiLha9yu+TIgL0FbSDXFfF7MzEC5AqrEQi7mTrT80oocRC3M8x0MsWyZVIVFv3dVXHEw6EtAkwpdbS5IYg4g+5lcd7mfy5krfEq0gwLZskSP3I7eFycYx/adNBfrK2R8srXyERMytqtmRAmqUcDdfK7Pm0UmImxOQX6yd60uEfdKn1F1N6U/2u0XSJRwilgERVXuKCtc6rs5M/4Q4aEHnvVA+mj9npDXYELbOIb7R4sTjMtI1z96JbQL56nUSUSV1YtJQ3KRe2nENUJN15MCkE5+9bo7L8VQMYQOxua1j8m3ORL+odpplp8laJ1qZcl4z0lTx36CjL4MOEUiSaozv5qRdlLw5hpEXWTtH+5Yq8V6Nd4Z+q4LWyLKBx/dxmygUXNLiLr7GDuCzhrR6cTPiIjNRdJWmnNU97Zow=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49686fa4-b68d-4a5a-3bd4-08dd1f09bbe9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:42.5727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2GwIYn5HJvfHFJgOj4812oSkpR/JE0db7ObueVmSZMOOveOiXIRALRxcbwNOPuiaMRzwEalkfl7179WZXruBqguE8Wrkxaeqlyfug+PswEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-GUID: 2q08U3ScIqoBh2KT5fNyMmn5ZXeMvluN
X-Proofpoint-ORIG-GUID: 2q08U3ScIqoBh2KT5fNyMmn5ZXeMvluN

From: Zizhi Wo <wozizhi@huawei.com>

commit ca6448aed4f10ad88eba79055f181eb9a589a7b3 upstream.

In the fsmap query of xfs, there is an interval missing problem:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
 EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
   0: 253:16 [0..7]:               static fs metadata                  0  (0..7)                    8
   1: 253:16 [8..23]:              per-AG metadata                     0  (8..23)                  16
   2: 253:16 [24..39]:             inode btree                         0  (24..39)                 16
   3: 253:16 [40..47]:             per-AG metadata                     0  (40..47)                  8
   4: 253:16 [48..55]:             refcount btree                      0  (48..55)                  8
   5: 253:16 [56..103]:            per-AG metadata                     0  (56..103)                48
   6: 253:16 [104..127]:           free space                          0  (104..127)               24
   ......

BUG:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
[root@fedora ~]#
Normally, we should be able to get [104, 107), but we got nothing.

The problem is caused by shifting. The query for the problem-triggered
scenario is for the missing_owner interval (e.g. freespace in rmapbt/
unknown space in bnobt), which is obtained by subtraction (gap). For this
scenario, the interval is obtained by info->last. However, rec_daddr is
calculated based on the start_block recorded in key[1], which is converted
by calling XFS_BB_TO_FSBT. Then if rec_daddr does not exceed
info->next_daddr, which means keys[1].fmr_physical >> (mp)->m_blkbb_log
<= info->next_daddr, no records will be displayed. In the above example,
104 >> (mp)->m_blkbb_log = 12 and 107 >> (mp)->m_blkbb_log = 12, so the two
are reduced to 0 and the gap is ignored:

 before calculate ----------------> after shifting
 104(st)  107(ed)		      12(st/ed)
  |---------|				  |
  sector size			      block size

Resolve this issue by introducing the "end_daddr" field in
xfs_getfsmap_info. This records |key[1].fmr_physical + key[1].length| at
the granularity of sector. If the current query is the last, the rec_daddr
is end_daddr to prevent missing interval problems caused by shifting. We
only need to focus on the last query, because xfs disks are internally
aligned with disk blocksize that are powers of two and minimum 512, so
there is no problem with shifting in previous queries.

After applying this patch, the above problem have been solved:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
 EXT: DEV    BLOCK-RANGE      OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
   0: 253:16 [104..106]:      free space                        0  (104..106)           3

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: limit the range of end_addr correctly]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_fsmap.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 7754d51e1c27..560e61283c22 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -162,6 +162,7 @@ struct xfs_getfsmap_info {
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	/* daddr of low fsmap key when we're using the rtbitmap */
 	xfs_daddr_t		low_daddr;
+	xfs_daddr_t		end_daddr;	/* daddr of high fsmap key */
 	u64			missing_owner;	/* owner of holes */
 	u32			dev;		/* device id */
 	/*
@@ -182,6 +183,7 @@ struct xfs_getfsmap_dev {
 	int			(*fn)(struct xfs_trans *tp,
 				      const struct xfs_fsmap *keys,
 				      struct xfs_getfsmap_info *info);
+	sector_t		nr_sectors;
 };
 
 /* Compare two getfsmap device handlers. */
@@ -294,6 +296,18 @@ xfs_getfsmap_helper(
 		return 0;
 	}
 
+	/*
+	 * For an info->last query, we're looking for a gap between the last
+	 * mapping emitted and the high key specified by userspace.  If the
+	 * user's query spans less than 1 fsblock, then info->high and
+	 * info->low will have the same rm_startblock, which causes rec_daddr
+	 * and next_daddr to be the same.  Therefore, use the end_daddr that
+	 * we calculated from userspace's high key to synthesize the record.
+	 * Note that if the btree query found a mapping, there won't be a gap.
+	 */
+	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL)
+		rec_daddr = info->end_daddr;
+
 	/* Are we just counting mappings? */
 	if (info->head->fmh_count == 0) {
 		if (info->head->fmh_entries == UINT_MAX)
@@ -907,17 +921,21 @@ xfs_getfsmap(
 
 	/* Set up our device handlers. */
 	memset(handlers, 0, sizeof(handlers));
+	handlers[0].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
 	if (use_rmap)
 		handlers[0].fn = xfs_getfsmap_datadev_rmapbt;
 	else
 		handlers[0].fn = xfs_getfsmap_datadev_bnobt;
 	if (mp->m_logdev_targp != mp->m_ddev_targp) {
+		handlers[1].nr_sectors = XFS_FSB_TO_BB(mp,
+						       mp->m_sb.sb_logblocks);
 		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
 		handlers[1].fn = xfs_getfsmap_logdev;
 	}
 #ifdef CONFIG_XFS_RT
 	if (mp->m_rtdev_targp) {
+		handlers[2].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
 		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
 		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
 	}
@@ -949,6 +967,7 @@ xfs_getfsmap(
 
 	info.next_daddr = head->fmh_keys[0].fmr_physical +
 			  head->fmh_keys[0].fmr_length;
+	info.end_daddr = XFS_BUF_DADDR_NULL;
 	info.fsmap_recs = fsmap_recs;
 	info.head = head;
 
@@ -969,8 +988,11 @@ xfs_getfsmap(
 		 * low key, zero out the low key so that we get
 		 * everything from the beginning.
 		 */
-		if (handlers[i].dev == head->fmh_keys[1].fmr_device)
+		if (handlers[i].dev == head->fmh_keys[1].fmr_device) {
 			dkeys[1] = head->fmh_keys[1];
+			info.end_daddr = min(handlers[i].nr_sectors - 1,
+					     dkeys[1].fmr_physical);
+		}
 		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
 			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
 
-- 
2.39.3

