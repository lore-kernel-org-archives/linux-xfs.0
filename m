Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6C1378823;
	Tue, 13 Oct 2026 08:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879199; cv=fail; b=VdHz+6NkvbY4QfU+HsC0pZ3ZfPcD3ZeMT6lBk/HgFJzoQW49coK5f1ZJRNfjQW5Seilpv5m78ctBvFn35oChKcLhnGrlMlr6nQTOvUBaMKMUhsP6B9jNCNoD0xdQJUoItdbdxtRmzIQ63oNK4+VAISl8r2VTkXROAbG5855232Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879199; c=relaxed/simple;
	bh=klLlUzVl2OHvSOmofLGI4scAZQjq5sr/6cj4SRTAobo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BEETkT7OoWsU1PzVDQhx5hFg86kGhTZFyKqlo/G8KCNcksD/DAcH49J5zT5DjDrn5m+ilK0SlGcOOiLBpXFNKG3352X3WBNodtXtN2AVdQQHaYgYJcTt90iEO50V0BbSLXnM27+yUcw1/3RuynlplVG4tStMv1LvcFzstp2V438=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F1mJbFif; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zu9riRNb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F1mJbFif";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zu9riRNb"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2C50G3201017;
	Tue, 13 Oct 2026 08:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wKI7UGzTfIfw02bKeXN5sUCA9m0Nk35g8/30Fb6mEAw=; b=
	F1mJbFif8p4jlfl29Ho9JAk4cqtM75x9Tklmp0L6HFiyKIs8HtNP8NRyN2dKJIdQ
	wmrXHXoeh3MtEarbEU4BtLFYgI3r/fmoYZQRR+gNvPNofjjJCVW9VViTvqQ3TJIR
	3lztOwf18u+yi/AbMSHtC4S6DL0iJjg0MXDmEq2SnaHYnUPtx+K9vekin/q1KN5h
	Wd/DQoz1fv5mEHDfe3/2hAhXWklEg4R+BDRNNM28oeYbXickL9uKviqj+/zeA6oi
	LMT61cu6hVqVQekJY+nOtOpEBPoTdIuI1AbzcjuHIKGZXGigXVSC25g9Cp/lXCE7
	uBko3YtteF2alemM91lifA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demkkb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:13:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86hqp033543;
	Tue, 13 Oct 2026 08:13:13 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013015.outbound.protection.outlook.com [40.107.201.15])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btnxq0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:13:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xnvuIBl0xS3f4bygq06/QGRSDT4DQRw4eDZoRy+JX37yaq4KlHRCpFaqSbcmBXa028sNW2w9LfIC3iZaX9FvvzVUoxIWJ5Rbt/HNXS1WgCoyTEWUqCMwhPugJapdWkAuCNRuaSfg5kWEdUnX8w84slqphUhoPjXSvajFDCcWRb9DfWtJfvOJU1/Or1zwZ6DObkbbPd3qN3H8AmrWvWKCj1Nh3Vj8GYSaw/Uy46BKGWnGpSHZtodSE2oE3av8+hfpqTHa3/kYp8e18ruGr8gnAloCWUtmvaZ6f+8VJIu5qhO7JcmyTxVrrjHJ5aWEKiVJgT3M7a1scNDWw/tViXei4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKI7UGzTfIfw02bKeXN5sUCA9m0Nk35g8/30Fb6mEAw=;
 b=KxKBa8XsI7LLOrp64QSsOl+F2IzE/cSEm4GGH1LkvaILI7HuYglyzuo3mS4sU44W9WyZkk0eIsUVngDWkx59k+tOyxe/0UcpLavM2/EPLwZcHZ0j26Oz8DqthRrcgl7F8PJ/Jiq7kfhjdBdeDclWN3kfi8olrTymVnOfZJ3r6Q/4TtPOGXHSw8JA/sXnL4c+Vdb+ma91K70Dt8Y2FN2n61dp8uZCPmGKGuINVsJIJr4aLb8yX9Mqhq91CP29Msv0MBjSTIxf5Xpyi1C9uccr9rCy/cO6X1vErRR5UuD9Yix4NBNtdhiPzGJcoe3jaNf1RaK1neltphyIK9uTiMI2Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKI7UGzTfIfw02bKeXN5sUCA9m0Nk35g8/30Fb6mEAw=;
 b=zu9riRNb8CNWW1tQ5OfWo9fgCQR9DBOYux6KBhf2Pz5/ta2KfcB7I3MMjJRGYg3SaYeFa8x0+QBxMyF/S0XkANvw0HZs8eus1UKKWiKEE4+j4+PXlfKSzJsqKYEM54nIe9Ct1QZ5pd/wkKpYgZA8+xX77uejv/t40r+9zw07kjg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS2PR10MB729975.namprd10.prod.outlook.com (2603:10b6:8:409::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 08:13:10 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:13:10 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 v2 4/6] xfs: rearrange code in xfs_buf_item.c
Date: Tue, 13 Oct 2026 13:42:44 +0530
Message-ID: <7edc2c06152b380bbead59ae0e4cb9df416057e5.1791877865.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877865.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877865.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0015.APCP153.PROD.OUTLOOK.COM (2603:1096::25) To
 DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS2PR10MB729975:EE_
X-MS-Office365-Filtering-Correlation-Id: f6307713-fce6-45c1-0584-08df2901d1c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10070799003|6133799003|10067099003|18002099003|22082099003|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	y0NNJnYkuQCSlM5seraSAagKB1Hq6/NxVuSRwH+fYKp2Y1SmhpMbDXBHiEkV1rBF2pShhzpjQYBJoBij7OfldoDncjKefjSV8hHtoaSqku/rM7D5oZpxr57DxSAWMfVq7m3mWPO3w43pYcDVwZSF1Hz0gVtErUTEpV41nsCBWv6zmB/Opy73PXpQHHMOFZZP/alkwYpyQJpngQfbekuz3aUpTYlbh88hUOmzWuY2p0hQFN0oUTKLTqi0UBCvSE2VO77cdYMr09urnBBMrfWRwu1rT3VVzVSwtITjFq4mNgWAd7CuyXejfk6YK0UImEQ6Vbjsg3poS9KuHERcxZq5RCJcCdwZtuna6+DpUV1dK93iojX9zbyY38wyyd9e8wJK1GKKvXhkPdgWZx3ORiy6JQe7Z9JLQN9ZWBQB4zaidRv3BjclCSIgv/WHpWZYqpi3AgiCX3bRjMMvxH+S9dQIXXEp11Y0jFIl4CBkMLAU10hK8Ht1l9nhSL1cZaFkCRuMbWMUPp+dKF/2F+CVCtCPADWv/fBg5vSNoGFRP1vUZt5V+Syo4AZ57sEneRm5tayCJliSC8FQTMegJegdeTYJbPFN1ffjzjxpzHg5RxTO/Z1gyW5Eqk25J5+Xbu8sGgpYyePPw5nMIxp6WdavYHD9Qgl/PjJU3w18R+LFoLgpWD4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10070799003)(6133799003)(10067099003)(18002099003)(22082099003)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lXemfpDd+EaOmxHvFilHOwIFi98sL7v2tqx9k3uziT1g7f4pvTDQVIi/MIx3?=
 =?us-ascii?Q?dcsuUA245kgynDcOjaRTtLjLjrJ6S7FA7bpNyWCRugrBDkIxzffrykCPzZRq?=
 =?us-ascii?Q?3A+DjLb6bYN6tbNEBRFYbB74nOTq7D8nm7uz8W2DZ4VrQk+Z/KiMjeLW1TD+?=
 =?us-ascii?Q?Upw4oNZgjjXKYIqze8XYbUJv2hP1lINVDVqLq/h9M/D+56yrgJI1YZv7uWcl?=
 =?us-ascii?Q?O8fpochHGWPJYbASS3pKeZRyW0s3QqzYzoU/ROQEsJmsb6b7pDdH8lZ/dNGo?=
 =?us-ascii?Q?jjOSIqdXfdffZnsBQTzJxVjr9Nkai3q6lLw83Bud+3wYXf8yfx99kxpYnQny?=
 =?us-ascii?Q?4yhAQVL/OqvXjbunW4dPbogPx+8Bg3M/ZvMIIgG/bPGCoSjQYjQKjOX3RYEt?=
 =?us-ascii?Q?Vxim7690tiTAKzSgo2auHvFS7RsmgBi0eh06j0KQDgkMibVjLXRKkXpuIv+i?=
 =?us-ascii?Q?9fZO2It9VMaqC/vb029Lub6dGDdintAAvgyOEaXFIbqGi6Z8gIQ+x6/r6w26?=
 =?us-ascii?Q?45iaztj6h5ZoYK+f8NxZFD1IntZ0er0bk7TNuO1EifxuNkwDqkjCqEKdDzNe?=
 =?us-ascii?Q?NoLOvBD1gQAp6jPTovhyNrHM7RiVmIK6JCWZBWnc1UV2JZI6w2DPzH65w91Q?=
 =?us-ascii?Q?BPpR72eOdAeSbnDU/uSZgwWp9KwRBiNUOKGCsNoa9B2L3QH4j9JQtPiFMIJM?=
 =?us-ascii?Q?i2Lz4P0vSq9MUB3SGmElhr04cZ6PhVJ2uEfsXdiPH6THKir+wQ3pXGfQW/6n?=
 =?us-ascii?Q?db+7DSZXWXxrmM8aDn9lWpzR37nJ9bNfQ7tejmqh8Yix0/4JntF3jI5AoAFH?=
 =?us-ascii?Q?kyVwEQFxJhK6EHSU3xIJf6JtJhMewt8j+ztaZXQawT2YgGY2IbNa99qn/F93?=
 =?us-ascii?Q?hI0gthoUkHSnz4VwGFWzTou8WHeXv6ZbBqVpgAUPODrNXsarnNA4mQ8n0r5D?=
 =?us-ascii?Q?8xSCs2iC81bnT7rI8nPIBcQjMU6Cg78Ei4djgnRsNa74+Gkqmu1PG3L/TNnr?=
 =?us-ascii?Q?zVRIlpLawMb3MyT7QOtqmuirmO5Cf8RKVyU+ZU28xRE5VJMsYj4zn+5J3FGZ?=
 =?us-ascii?Q?uU7RuBkb9hX9npI40x+HqHk59l0RoNhS95tc7XHjaPQUQh2WrV37ZSt6gq6z?=
 =?us-ascii?Q?5pqRZl+HRNlHLLJ1FPG1TPdd9fOqtdj7I2Xyu8mCMClqNq64P33yvImb8ZKL?=
 =?us-ascii?Q?mcrGvlxNDbVqO4tpPDS6wwpUdE/J6ny5p2iS2Pf/pdhyxWQ6wjK7YJyXoGxL?=
 =?us-ascii?Q?pGVOh1cIz9o6GseDSEJq5K11B+3+JwRONjCMywLjiiR5pfl6nKLpMAqUUtMC?=
 =?us-ascii?Q?ijjcC2j4Xt/M3G4WvC30MolCr9/b3ypycdyHAPDGGpiRXNvmxUIw1WUDMGAq?=
 =?us-ascii?Q?enYtyLOlNZ51QHn2AGsYi6XfjV+vxKhlSgph4Yxe1OjVydcjTtfvo3hehtWA?=
 =?us-ascii?Q?k0wj8WEbodAaZDrNk5lG5naGhtcpHEdtOZfwGouXQGNyesrOIX792V7SrF8/?=
 =?us-ascii?Q?u5GPzP7G2RO1upGr1o0Oj8MPbe8SAiCvy2G165vI3SsvzJXXC8Zl4aHi7lt/?=
 =?us-ascii?Q?aPVn236+jBIkhbHgThb6B8TzUT0SOCIyXcUYnJVvbyY9yYlKUXVeu5LRyTWz?=
 =?us-ascii?Q?I0JQznQqf8AE4EPmqYxqU/XZr8+QaxiSXMt8xgIcQAisy8SA0/ic+iEzPiSw?=
 =?us-ascii?Q?fnG8UdzPsNvI/KF9rh25E6VCgqucGAYZO1+O/5mHD5nWGSI3PnZ0+IA2qm5K?=
 =?us-ascii?Q?jIZ+7lEs2qX9bEyhonOgNwnQKdtP6M4VJpWf2nIg4QKiRY2G8XI4g/U0w5FW?=
X-MS-Exchange-AntiSpam-MessageData-1: yyzp+Z4FvIOlBWroqKmOYHehIgcmJ1rd0Ao=
X-Exchange-RoutingPolicyChecked:
	GiPUEWwTTLtC3abbcm87rtJ13vdrvrAnLTJ0ttgHyVZtTUjZNDXXz6szz1SOxCerXZGMzg6uzAEgGwkP8ySkshiiYXv3wLeC1zEb40xkxyjdIU2WX/5yBqTc8CKSvY2vs5UyDlOo2L7f9PCVoej04F5GKXbitotWHQvssFiNmI+1K4UorX2/oOKh0owK/fcrc+ONE7yhre7hOVRrdl85K1dOueJAEpGl3eMOtibxRl7XynahIUXUatYQpaISd3crOcc2187JIqxZaruBDq+W6YOb0SGLjsSdhdjdyMUBM5Pqpqg8EOFgCJZz1PDFhvlxDEcLF+yWcD2uYUhIu2Obiw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DxHL37dMbrYwaRJjoQyIcqKL6slRyV2vfMcfblqDTKOUkTILW26AcIWbT40ls7vQz8wSk4mPS8Cb4KeUZF3Vb2OOogDz8+4FJKzHGxXSNA9whyIAPnkISc0qMnoVMGJQq7yVn+u1xBqA+Zh7iwmLygKCG0vlAGyQrX9WPIUgvcry3Q8aHgI5H7TOGrKWSzX4pZ8DGXSd0nw694Fy4h4LGbJOpJXR/g3GQgFg0KN8tv9X1Y9ub546h+hRR3DSUdEhkTeWjDDK4PCtLFlb17o1+gzJb7ptfaHgCApxrLoWKKfpCY5nU6fhni9rHRs8d2S3R4ha2SAGZgk/JeTPf9ovz4SyfZ9AWsrrjGg4VEQYtoNZveOGUy38U6EZK9SqSFEKmtED5NgudQIrbsc5JZV0fXNvn7K9lbvTNIP+5+fV5Q47yTvBQsj6PpWDHBHZ31u6XeqQ9ZhXexTSkWzdDMhUDcbvX0vCYcctcsUwmUCZkHuPDeqjdDMdKNChCJc35/h6DF9/oxB8yR8kRjHJTW5F39qa23DYPuk3Z01BjTW9/kWmFePLjB3fEhLOfDcfXN6tLcI/HGCKw8f+x7FPjTqSnThs4PnICL8rqsJstmxkT88=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6307713-fce6-45c1-0584-08df2901d1c2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:13:10.4149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K3ZWAGCBJhFFIGozvB1rbPf65zjIZCuvHr/ZsR7fPbR9hqYXx0hNbdv0weGB4vX3LyYmDTEbMoDPQaZdBykFLuAXQhLAClYEaSlcL8wNP30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR10MB729975
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acde819 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-GUID: QZVaZBDc_x5ItdDmeK0kWnOnZDYZ0AQN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX97ssQTNAeiMB
 a2pGCA6WP3KupClYx2hmJlDpBA45jZQAjgqnlr5yCEPvMxXrNtPpiqvfxBk1LzDBEWijyhfo50M
 /E/EPinCp4Zq8UZOBc2d5EFiTICveH60h02KoRLBaa0SeZ1LqmzV
X-Proofpoint-ORIG-GUID: QZVaZBDc_x5ItdDmeK0kWnOnZDYZ0AQN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX4enESGnLSxMX
 pZ4e5uonnbz5UgiyyX8RQH6bgoLXoQDU3yyh4mzOQPGyasj8279tDLALk4t7dbyZV8aBcZsJ0Xa
 hvGdEZGDHR7UWgYLnYzh//LwUxg66sHWtcNlbdCtyf/8TM1vz7gzO5Emut+ExOc0swxWnExX7AP
 RiiJmypoQ1DYMItYDr7wLBC8Rmhtyyi+WWdBNS1vXAzv6o4nO+iSWp06y9+Td2MK3ImmOEEK/Bx
 iRxOPQ7hGRN2ouzyn995p/ML3MbISejEG9uJxtETl9UQyxTlB/PVFyfVgHFSxdgMOZ9qOlD38XY
 8PcBfh7ynjAvyyuuIj1JTAMLJx9m2ETt6tG5mwO/MlHcAi9RCzNbq4Qw8Ij9iRNSbWYWlYVZDun
 aLMOyDk6oMVnyHfq8rqLdrkKsGuwliLUjY5c+1T2CI6QNKLsl0ybxThDYh6MlyxwXnHcP2HGNpu
 SzjDMbh6KiMXlnTlszFUYQIjab+IV6vfiVRzfJXM=

From: Dave Chinner <dchinner@redhat.com>

The code to initialise, release and free items is all the way down
the bottom of the file. Upcoming fixes need to these functions
earlier in the file, so move them to the top.

There is one code change in this move - the parameter to
xfs_buf_item_relse() is changed from the xfs_buf to the
xfs_buf_log_item - the thing that the function is releasing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit d2fe5c4c8d25999862d615f616aea7befdd62799)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 116 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf_item.h |   1 -
 2 files changed, 58 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index b746a1a0f8dd..042282a08216 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -32,6 +32,61 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
+static void
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->__bli_format;
+		return;
+	}
+
+	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
+				GFP_KERNEL | __GFP_NOFAIL);
+}
+
+static void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->__bli_format) {
+		kfree(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
+
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kvfree(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_cache, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+	ASSERT(atomic_read(&bip->bli_refcount) == 0);
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -563,7 +618,7 @@ xfs_buf_item_unpin(
 			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
+			xfs_buf_item_relse(bip);
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
@@ -673,7 +728,7 @@ xfs_buf_item_put(
 	 */
 	if (aborted)
 		xfs_trans_ail_delete(lip, 0);
-	xfs_buf_item_relse(bip->bli_buf);
+	xfs_buf_item_relse(bip);
 	return true;
 }
 
@@ -824,33 +879,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC void
-xfs_buf_item_get_format(
-	struct xfs_buf_log_item	*bip,
-	int			count)
-{
-	ASSERT(bip->bli_formats == NULL);
-	bip->bli_format_count = count;
-
-	if (count == 1) {
-		bip->bli_formats = &bip->__bli_format;
-		return;
-	}
-
-	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
-				GFP_KERNEL | __GFP_NOFAIL);
-}
-
-STATIC void
-xfs_buf_item_free_format(
-	struct xfs_buf_log_item	*bip)
-{
-	if (bip->bli_formats != &bip->__bli_format) {
-		kfree(bip->bli_formats);
-		bip->bli_formats = NULL;
-	}
-}
-
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -1072,34 +1100,6 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kvfree(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_cache, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	if (atomic_read(&bip->bli_refcount))
-		return;
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
@@ -1119,5 +1119,5 @@ xfs_buf_item_done(
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+	xfs_buf_item_relse(bp->b_log_item);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 7ddda0aa9dac..8a8a46e698be 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,7 +49,6 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-- 
2.53.0

