Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19744248BA;
	Tue, 13 Oct 2026 09:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884470; cv=fail; b=UFQ2EtTZk6spfKwuj88nqXhj1aENb7K10wQnqSZrofRi/0gmX3EECRBS+LQr0nameZoKlEdPEF8enjDM+i47fMxfBt+AY73vz0h4tcXeGLX4SCrR1CNh8RqYFKxsPE0dhq2Ru1uQNZDZrTED+068vDAWlf9sSkOuYSJz+Y7wKjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884470; c=relaxed/simple;
	bh=E6NyunGdp+JmM5+9G+WKCdOoys9lyiMVhDOYbrosLl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rl28Rpe+WcdDBffpFa3DGb/+aB9vJ6/VMX2l6ivIjCJCQQl7WG1ONaVeODrBYuYuCD0pHnn0Zw+TbFFeVprDRmzuPguPbN8HgcETZzAYsVTDwUaRrxJ9Nxtw2XRcToqEvQ1I9TsBV4mm8e38TlbeCST5REYf8wwaH682n41N5Ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EFs9mhxx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OT/YST9B; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EFs9mhxx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OT/YST9B"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BvV53110102;
	Tue, 13 Oct 2026 09:41:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=N8BnqocoPPpmRYVigoeQop5V91JAdz9mqyX6FDNedj0=; b=
	EFs9mhxxEhMrZbbK+jGbOAFHAsIJPGNMBDVe0jAFjSU5yYKfrMvC4uak1r+eOX9j
	16n2WEHZBLV34QPQZ4sAmdj1lMIcxSzmx0WYjDqfy7vsBIPr/dOxvi6AIzBzl2Ly
	aJs1wrIlOs4ys9zbGEwo79KXSJRx5YTEIV14yhmJ8fp5RXMOEV46WMlWg1n0il7T
	eVC6OClvS9XFcB016MUHkBU630IhJvO9zRywpu6O6dCaYRVJ5n0ef2B1ygJ+ncAQ
	+Bf5Q+baApHx7xfnObQIiVR0lCZeDzXQbT/4h0dpVrKpwrdOxXZMfwdkyf4+BloT
	vcmp0ei6ORZnldqql1F7WQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7ddgkrf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:41:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9ag6w016108;
	Tue, 13 Oct 2026 09:41:04 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012033.outbound.protection.outlook.com [40.107.200.33])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp18jt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:41:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mfBPdWUlrHmv/5ynv7LvtxVhebnRocXCgE8LKPTwlRmub1KTqC1HHjWuWVj3O1eLSFDqiVaV/rcu+gJu2xTABmxnS3QzRPGawSYui+CtHy5/kUTP/4xiUvrJnykij26JVRTsy71UkntHkj5p5Fx0BCA8vYBSG8fQrw6gWTM1ZFrx8IVfIIRa5TrnkWCm7294/yZQ9ccSM5+l/uQhzA0P/j69VA+N/t5b5aCkC7/H3dfShNA9ZboqWW0LtJOPP4LLjhPEd0bLpAmOEYbgHx4vA7rEBfkFhcRKZyaVTSGRBZQWQbSPUKVDwizq3qsrFxX7K0mdi9va1fwP/tkUdq1tpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8BnqocoPPpmRYVigoeQop5V91JAdz9mqyX6FDNedj0=;
 b=IktOXa1WeIqFn9Ge2soBCcLShPTPWP+OKDI7yCTHKqiL1qDlyn/RPoRFOaTwGKwM8aJZXq9X1mGTYv67NWpuSQgkYLevPByAJChTN64RIK79pSXtkRH4BTuUNdOhlMsFXSUzNCsvM8J0V+C3ElHMCxCAnKgGAEWjyLwy6ZSQXJlWn44TuvwvYNvqbv4qcdr7wicCvkFNA61/lYPOBGSwvmk6TuAc+1XLz7qLtPlKTU4tckSBHH6mFOZWeY36sbb97R0uPUtsxiLBJLWMYcYsL4f/VQzW1fJlK6IAvZBy0m+ev91h1qTmG7KNM2d1/oseFN49cbn5OIFvkZRvT0xTsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8BnqocoPPpmRYVigoeQop5V91JAdz9mqyX6FDNedj0=;
 b=OT/YST9BMWUUmaUWxJNBeqQStMJgWbxXSBQUJ/N5N7/Dh2fkQ3UKcixuh/d+L9J2nD6tnrF0hdx0w4D/0WYV24gxGnQCDETI9eDMmN9zsEXNWUBt35lgZGeudSydnqv8bAwzPzPz00UvtiWUbDBaB1x5POjgtWoQUKJwdwVwkmg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:41:02 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:41:01 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 13/19] xfs: fix intermittent hang during quotacheck
Date: Tue, 13 Oct 2026 15:09:42 +0530
Message-ID: <5e28d1eaba426503307b4908d3c3f7110c8feb43.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN2PR01CA0121.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::6) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: d25eaba1-e977-4a08-4e5b-08df290e17c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|260925021911599003|260925021311599003|260925022911599003|10067099003|261009223027099003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	dywGcl66EACv7U/z7aF6HcC/cDWTkwa2p1pyRtXfYkQZwDb2Sj+J8oVKrJAVy74oN0bELNILaBG7HZqI2n6telBs3HjbOQ6MiAkVUjJcZWmhXi4ZhNTYPmk0tY3N1mOIEZOqIaWfX1m0WXEZa82RmbYI5KPE7ZPBZgJGO9RUzo8D2ApnULyhI2mc/K27c36ZQOpghVBN88EWmCU7yforUGQ2nx3blnJ0KTB5eVNsbOot0ir8n7rfF13mkEV6V5bFKCk3+jZNV3rgdAzRMoW/BIHCCcEvy8KCJcOY+FWdE8UkCUSdKE3jghZxeYvWb81ClMDwXFT75g04Ft33aRj+IyjBJpWdVSjhzbphMgQi8yalBxLvypPaf2sdxh6Io9Y52+uEMz4beiVMa3x+J9kFtMHN+TW6/+NHxKt0D4BNDPFoLQHz1KxsZQ8mouSPwPJfH+kV76O3dQOfl6Ub8+060rEHhMU6LL0PkYQVXJkMKkZ8vPO3oxWXumonlrC8AcjsBjYWI5TV/RVP85+ycot8/DYK8mFOwXcK4bZG63T9979dVygc0MQmGQNUvEM36k1EEzJ1d4RJXsOVQFV9vIAwx/Iabt5Fr9nEsdBNO+JN04IRj9nA56KExfiBWY92gUPlg7fddZKu3rmd9Sydl9R3mVWw9vKUrhamzkNY+KuGFjg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(260925021911599003)(260925021311599003)(260925022911599003)(10067099003)(261009223027099003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jwBYeIdq5cm1idDCjo8BOrCbHOz3xYmL69iG+/aTt4IanQLN7C/BTL4wF4Ia?=
 =?us-ascii?Q?C48f+XegyHN5i9JPoxatRps9POaKv1Wf6lmy2qPBocRiA0LwMS26TLc6NwIi?=
 =?us-ascii?Q?RHtzClY8vfn5rMSBc8aGAfTmogrwSVd6zdIu51RQ+EGcn7igMTjsCO0QjBoC?=
 =?us-ascii?Q?q+fywS/biGkSRYXlLMx0KHdpac7Jbwpv+aPB9LGHJrWQHfz3X/aISlo/CuKP?=
 =?us-ascii?Q?eXdk0NWnuX52y6Hz5A8p0oYglIUFqKsN2Vio9A3e82GMHuuWcNOihts9UQAf?=
 =?us-ascii?Q?i5Trivif50W5OHeekwlUdpl82mfitbGsGaLbOfDSaVHz1fdIjnrRSmJ18EVz?=
 =?us-ascii?Q?A+AWwRleRqU+CLEAmZ8tUJLpPF+MH0JoAabwe2JleuIQGpfwIpYdiK/4IkI9?=
 =?us-ascii?Q?sdwZO58fLsXislncOTlwr9Os+Inmd2LKlA8M4bwfFoaBzwSC/WVsnKfTws+4?=
 =?us-ascii?Q?ODbvSTbhzp2UO8+vsgpYkTWYsIQ38wb5W8DlGHOxfqV+ylMQmmQ7fVM4Waci?=
 =?us-ascii?Q?DJF2qub1skgAmIWFmFWGJ3itAAjVdHTx+NpoW3qYrIXtzsRB0C/wVjJFSecq?=
 =?us-ascii?Q?Kj4me7E/M9IfXuWvIbBe0AFHCZzBuX4j+2O0fU9ThigwM8kSV4AQ4Lo7rgBb?=
 =?us-ascii?Q?y+L/34qNvPzgbxsjG4Hu3euOdY4kWkIMB95l3+cD7e2SNla8KDZdNKI7Z0Eo?=
 =?us-ascii?Q?ASw4lshndVI2arE1lL+9Eb9jbSH+fAkBzwLKi13RMrAM8hcDlXFXSFjvycFN?=
 =?us-ascii?Q?8CTXrGw9DQuP7X18JIstojxP9lxAYH3GhhrCpx+uDFkgU1NtXCgJ0451/Zst?=
 =?us-ascii?Q?5E5tYD8QVxTKlQA85Zpdu70ZhEAOhJW0VNw1Z27L0bPaJBQf9QG9lAjZ+IoL?=
 =?us-ascii?Q?3g+n5Awposmu54RYXRB20Iib0SqTBLsTjSYhCUzbYqnZijb1/zc4qE9xVJS1?=
 =?us-ascii?Q?QJWclWDQMLP2TXFsGfhKXA+/DhKuvMIxvuTx/ajdlt857CyiOl8qAS/gN3LA?=
 =?us-ascii?Q?CbKDeaukNB7Ww+TU9Va4FymckyXDwwinp2QhLr4vzYB43+XpbdAyZzvwo+vz?=
 =?us-ascii?Q?rQxzUruaRDDpXRRiPvweNs75ssCfiUj2kTZVNIDQBEe2bT11s+tbi5Pw5lzi?=
 =?us-ascii?Q?sC6k6ZoxZVRZyptTeh5Mt0tTLfrznv+DIKkknAIvxPvqLzPq3YUvqoLTeHBs?=
 =?us-ascii?Q?l/ergPi2UK4TwWXPiC6uHudLrjtJrx2m92hbpgt4IEIABl9/ret3na9S7gxk?=
 =?us-ascii?Q?wXdM3TLEy1xONOPQGISTZqEW6Uikv1Wb7NnT3vqZD/ARIJA+UDcmWNVw1yvF?=
 =?us-ascii?Q?vGyFzD+gQ2/EgeW7MaY4jLLyFm+947tsd7dZLtZcwuWYicOTgoDeosjQHgad?=
 =?us-ascii?Q?2m0Rd55yA1tHggK4gbWAWQrnnWlCs0oPrY04c6D16G43bT2f4PqUmpPOG6Al?=
 =?us-ascii?Q?ACaYB22ikNtQgZRsG+eOzavJomaVwntdwZJH0kU0GcovvANRfApbKycHzqXg?=
 =?us-ascii?Q?19fH6uRrfwUVOjU0x7LLMvD6/w/lhzeKjiVHO2MgNfkUeMwexm+b5SgMBlea?=
 =?us-ascii?Q?WNwZxQsKYrpVSDYMNqF8VfxpD/tsKEWrro4BfVa4eht5pfG+eZTOrn7K/p3D?=
 =?us-ascii?Q?o3VpWk+wbNeukieu/fRMLfsuj4w1vYw7CtLoF/YW4ciADt98iG81Svrv5F5T?=
 =?us-ascii?Q?nSib268hpy6L9iBvQM5YQXMqV9gjyfeYlo2po4T5QB3vq8Yv20aahPpLa3k3?=
 =?us-ascii?Q?M8BAk+M2hkVv/xce5T6ALoysquU7Vvq0PoDkbynXKbAWRx9hqfaUQGIa6Bi+?=
X-MS-Exchange-AntiSpam-MessageData-1: 3BE3hJ3uhI1zfGnYCLZ/DZDu3qwAN3Yq+BQ=
X-Exchange-RoutingPolicyChecked:
	cjxosBJodckdBWows9BRZfX/yfd6I1r9Bs1GmV1dHFIBmWZZt4dWgX95WmZcKUz7eqoCcSkN2zMcxioxW1fv3Vgm9RW1/DcfCMfvfRDdhYm1oh37JkK5WYUM3XRy1s1nmIpHQtLh28VC4VU7gMHnvmSt/7nT24iAKtpX8V1+bDvHqYO/3pRJd4BQonDVPxPAnL30uKl0Q1GVVnz/QdewbXMOUyL/8O1qVMfQaHLkkDaelq4Wof31H3kYRWYzWP8FMJhRhbZjrAGHX0iU+PMLG+S9Lb6j7LndzR31OqO38uUvxYFqkMSG8C/4yjjupm8ITUcy1EgxM8bUifHW5h22Pw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dnfw/DqP/udTMWWdaLYEqRlQovcN9cMVeMh1tAeAtDVTAjJp6Zf/go8yxgU5nV8ibpHIPdhyGLzuPrqVKRePwDG/nVVWqsjhTWCfQu6J83JQMZbGcR7Rk356wWMM+D0ch0r+7TnCuLvcv8cwYLnMYVnmHy6dnePDe7q6q45D+oCTDuhP01dH+DxqZb8dpEmFZUdGyKxStXUsaBkxsHNs5K1lrcIzypQsFH0IiiEPh3KckWXWF3faGdgwhGfyCTTyTKlSsH1mKlkpWJvLMGf8JWGzsHBV6IRTinPf/X0HMIQ0+34hxS6PagoT0rHpTT3b3t3M60M008uckgAeIsNqIvUZU/0vJhEkPQW7NcgUWqQERsOGb1H7tQh9T12PPqYRFFKHPd8oKuQ39WAzn2Mpey1NLEy/LVzqXU3n17nVUHm2vzTNhptSXVq/eQq9lkKkzEBX3vX2pP4vW9vtcj0aq9+QlTiur9nSiN968Ssg4uwZP70+0J3jYffU+tWFhnI6DNC2QHUVV/087uxfF5BUhKLt4JhKuvYJEGry8tVsAsCbGTrxVg0ZAipScqbqw9ZUBmhtaUbPd8XTECFNIFELqy7+1Je1YSEKIF6SDbFv3J8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d25eaba1-e977-4a08-4e5b-08df290e17c7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:41:01.8561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QKd2H601+1PIyUKjZ5jqtFXNbl7Wy3w3M6zm22csMk9tgUZ7J8E2o2JUrmD9CSQed6eZJUEa2a5etAhHu1SP+pBdoJc1/qM9dt4q0ekXNa4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=EeZd0/mC c=1 sm=1 tr=0 ts=6acdfcb0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=85p-hYGmfu7TsMeR7eEA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13537
X-Proofpoint-ORIG-GUID: 4UfKFXrGw89lHloXUUC7R5Lh-qGgRL1M
X-Proofpoint-GUID: 4UfKFXrGw89lHloXUUC7R5Lh-qGgRL1M
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX5uM6JbfDuho2
 vsMnixQR6CPe+k8m0oc8yCuNIasMZv2KwU7fj26Wdir+yDt6Db4NNLVj0AorVqkVZ6vXycocm7h
 apVDn2KtXhvLW94NHH/dBZ/iy0rQsEreDxm1HvMwDrwmpjpZFH67
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXzZzLaM9z6Pxk
 Plpm0LKHeEGFSjn5g2QBDgQPjO3LJvQktVxxX9afXYwpSsHBwuBBhXdgnNhXfRwZ3glTON4bfHu
 mcWNoUtTZffXNq7VHQONZ+BE1n2q5kAQEJfry1/HSaq3yh2H2qCeubfLLSbiX2BS1/dadGm1oeh
 kep4pJDgPG+SdLKvAqA1Lb2hjSx8G/WqQ4R8PJrlZrflFRQvNh2U2sVc1kh4zAmiFqZsz9dD/U/
 XwJgnMUZXy9q9No6VXeKUSRvnfgAsSP7ovYup6R7P5KC6XKDg9Rj/2ORYDLWbmndlPpi22sE4bB
 P5MhQtuMm8jvzn9oF4Z5SHQCmzmUT7HAA1CLTKKvjXisbHmrvbJe83Hk/2TwQmSDMXjqE24Wqg9
 4cr20zr0PjL0QdcoOhdJE/AoIS0AKf3LPM04EtbiEMBnFbWnAuJvpV5f/+TAs8E751aktnaXrZn
 TWh4P5dKJbDHHuTVh2NIcVPiQCiYVqmmwmawgGSY=

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit f0c2d7d2abca24d19831c99edea458704fac8087 ]

Every now and then, I see the following hang during mount time
quotacheck when running fstests.  Turning on KASAN seems to make it
happen somewhat more frequently.  I've edited the backtrace for brevity.

XFS (sdd): Quotacheck needed: Please wait.
XFS: Assertion failed: bp->b_flags & _XBF_DELWRI_Q, file: fs/xfs/xfs_buf.c, line: 2411
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1831409 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
CPU: 0 PID: 1831409 Comm: mount Tainted: G        W         5.19.0-rc6-xfsx #rc6 09911566947b9f737b036b4af85e399e4b9aef64
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:assfail+0x46/0x4a [xfs]
Code: a0 8f 41 a0 e8 45 fe ff ff 8a 1d 2c 36 10 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 c0 f0 4f a0 e8 10 f0 02 e1 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
RSP: 0018:ffffc900078c7b30 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880099ac000 RCX: 000000007fffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa0418fa0
RBP: ffff8880197bc1c0 R08: 0000000000000000 R09: 000000000000000a
R10: 000000000000000a R11: f000000000000000 R12: ffffc900078c7d20
R13: 00000000fffffff5 R14: ffffc900078c7d20 R15: 0000000000000000
FS:  00007f0449903800(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005610ada631f0 CR3: 0000000014dd8002 CR4: 00000000001706f0
Call Trace:
 <TASK>
 xfs_buf_delwri_pushbuf+0x150/0x160 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_flush_one+0xd6/0x130 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_dquot_walk.isra.0+0x109/0x1e0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_quotacheck+0x319/0x490 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_mount_quotas+0x65/0x2c0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_mountfs+0x6b5/0xab0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_fs_fill_super+0x781/0x990 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 get_tree_bdev+0x175/0x280
 vfs_get_tree+0x1a/0x80
 path_mount+0x6f5/0xaa0
 __x64_sys_mount+0x103/0x140
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

I /think/ this can happen if xfs_qm_flush_one is racing with
xfs_qm_dquot_isolate (i.e. dquot reclaim) when the second function has
taken the dquot flush lock but xfs_qm_dqflush hasn't yet locked the
dquot buffer, let alone queued it to the delwri list.  In this case,
flush_one will fail to get the dquot flush lock, but it can lock the
incore buffer, but xfs_buf_delwri_pushbuf will then trip over this
ASSERT, which checks that the buffer isn't on a delwri list.  The hang
results because the _delwri_submit_buffers ignores non DELWRI_Q buffers,
which means that xfs_buf_iowait waits forever for an IO that has not yet
been scheduled.

AFAICT, a reasonable solution here is to detect a dquot buffer that is
not on a DELWRI list, drop it, and return -EAGAIN to try the flush
again.  It's not /that/ big of a deal if quotacheck writes the dquot
buffer repeatedly before we even set QUOTA_CHKD.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
(cherry picked from commit 8d0baec78e8a7abe03b449820507c9777dae7f7b)
Stable-dep-of: d62016b1a2df ("xfs: avoid dquot buffer pin deadlock")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_qm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3c17e0c0f816..907819e7873e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1245,6 +1245,13 @@ xfs_qm_flush_one(
 			error = -EINVAL;
 			goto out_unlock;
 		}
+
+		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
+			error = -EAGAIN;
+			xfs_buf_relse(bp);
+			goto out_unlock;
+		}
+
 		xfs_buf_unlock(bp);
 
 		xfs_buf_delwri_pushbuf(bp, buffer_list);
-- 
2.53.0

