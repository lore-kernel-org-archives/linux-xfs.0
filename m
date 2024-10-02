Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B18E1D1E6A
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890914; cv=fail; b=cNgRzvqmgVYGKO/gWfQGdUQeHV1FxAawSMWn13TNoeOrlpS1nP57ZBTB6Ahv7lYd1z10tJXxl7ViWBNNgrUXfLgF/F2IOhhvfg8C8pMhNzyaIfBBLwZxeCxD7CDh2NzncKGPk4oFWgUok9uzO3qfEU/W+YU+HqeoipOcmRDoNx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890914; c=relaxed/simple;
	bh=ikiGPzyv3cbFoMlSM9kaj25Yx8WNQmDcKZY5vp2Fw28=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pWaO9ewiaBClWRvoHN7P00/b1CbHDY9UQiSM0rfT4OiWUyFn6tji7VbIeLRJdWskrwqnhqg5FkEd8x2uNToZYYx7JhPYxVYks1+aTOBpOazCN+QX2PX982rPM3QBgSdypAK+LDQSYwdMfQ3CjKbI2KcNviGydJqWqLYxlupiOXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a33xtTf+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HnEu7eKH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a33xtTf+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HnEu7eKH"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492Hfblb025084
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=kOxBTx7oZBdqH/0gdm/PfoegPpR0p8bAeh8gliR9s10=; b=
	a33xtTf+TnzTsU6kpRi9PHQYpNWeENW7gs9rzMGILN1tdvjRkX9CQcMaOuj5LZ/5
	EzvFAnStZp5GzULnQCNjqXFPqtL57v0XhhBkbBjw/y3n5DEeMjmC/4n9cTsZTRP1
	ul7RZy+xEZb8zxHnrtmOeDSwvR4TRLmxBG79b4N7AgOaQSnITRJ84o1pX6dndUCd
	Px7QwdCKKk8qPEjz+DM+yds1uEVBTtQdWzt+34mURXKi10l8iPLm47h+6NAFsHiz
	ZJ/duQA36LXY9I9LuE9sOmF8auyfHII755ZP29FdIXyNgoGnHLfsgvBzQX6qHDxM
	DnnyN27iWb7bsdQ8mTnSEA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9p9t3ej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492HUb1K017337
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:50 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x88951u5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oaqifazSrqscp8XmcN+qTvLICeVq4IEyKLU82KgVjzXfm6fn4mL1h+OV/n2MTfQgFFoMBL5fkgPxM+K1dGzrxq+nH0xNDuzjDokYwlUKnJzKF9zmvWQb9iMCkdZUi4zBVIjR9cOc4dvzr7Ds3nSXnK8MaO6E9vZGZriQbH/8LcseNC+R8Gfz3yChPzqrdmTt6iaOKnkq3sdkp77Bf0brW7DlJEFMqtyr6yjKPnNZZqUhEVFMToyFcYABTsDuQKeo1iiuzuazLy/1FBSVgUR2rofLa/agejpldDK9E47j0atzF18kMSIjPIyjts2Fl00OBqLdZOpECFNUEWP0xh/aMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOxBTx7oZBdqH/0gdm/PfoegPpR0p8bAeh8gliR9s10=;
 b=DxL7zSJ1AT6+qJyQlA5vnmZxZvcoR4fOc/3LtvmXm/4f0CdQafCDeHLBDiQbnSZf2htXYszk94Wvf9b8Jq/Qioz+S8IUDUKesF/06MiwgWs85vOGIqY8Ryl+mWdlTQe91Wfr3G41gpnM4lQjk6m62XiIaS5gds0cgfZhzPv32X74hCS8lq1QnISaTueoQKa4rfZSU2nzjcVhbjYtQdwXv9p2p6JCVCJy0+UVfYxQjd+qmLgHO+uu+hJFB7I1Qp1sAx0POxaInu6tFRxyrwA7m3fyZGDYLJPg3pt7cpkb+COSmTLaWXNo+I1N2Wx9DSkILMPFreYrk/QunlhU20m7zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOxBTx7oZBdqH/0gdm/PfoegPpR0p8bAeh8gliR9s10=;
 b=HnEu7eKH+i+WSo3JM4C/KaibtRIPo43SBgdlV6M4L82zyBzy10Pxnqio2bWFYgQGJFrGHcT+P1SzKV4xNcQb8FTQRbXKKdr2L8b2TT+417TXiWWZOyQSS8YnVL/BNMa9tVJ+sejEQvD/GtLZz4ihH6ukHCycifuosb58J4vfqis=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:48 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:48 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 20/21] xfs: restrict when we try to align cow fork delalloc to cowextsz hints
Date: Wed,  2 Oct 2024 10:41:07 -0700
Message-Id: <20241002174108.64615-21-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0056.namprd17.prod.outlook.com
 (2603:10b6:a03:167::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: a830e704-c963-4de2-e066-08dce3097dba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9s8O0R7A4douykJImVUtiUbKCM45+0I9dsma5tZM9DnNV6g62oRx1CRI1Ajy?=
 =?us-ascii?Q?1HU82d26R9Fbky8iI9hgcm97TITybLzr9NHqoWkfYTNTj1LCLQVUfl1At/pi?=
 =?us-ascii?Q?dbOVvTVl4DhcMHpQ+X6YrElpufxN+kGZakFA/AhGbwMn6GaCF+5iJGpa+Eq8?=
 =?us-ascii?Q?KViGgD13p+qvRFPecw5r+TnWvs4rMY22QMXs+dNhB6AK63e4xSfcoDHVI3aJ?=
 =?us-ascii?Q?84VnUadpUa3b60gIPmXS11W3Cy15Q3W0sacevmoHTYLsIOkJBzHrw6dnWv9N?=
 =?us-ascii?Q?rUsDjF2669TrxEAhrPWNDGF5B41f8Oc0O0Ec1jCGhKZJpWNMNadhsniShaew?=
 =?us-ascii?Q?gpB7fbaqZqOvomlh2DbFBCKcnz4jZ0YDOlfG54keLeha3ZVNkNJiqnN3mECx?=
 =?us-ascii?Q?tK9l3seUw+XTW33KiagFr6HwgWwcJrjhHxiZw1wmXtfm4RwW/SkUTrDeKD71?=
 =?us-ascii?Q?ICtIIJmSrVIxUWUL8W8YYzYU6rLN5p4kr2vSv6pkQGHsZCsbd324UEJrNey6?=
 =?us-ascii?Q?FcZKLFQSROtlXKl5CLxzbFMciIamaUbJDzHtLBJ41eHIp+MY1IsRBt1UKTfM?=
 =?us-ascii?Q?7kUCyaCH2z0hqkOzy4tB8Ripfe9ujXqaIjdA3mcwpTIGmmX0ks1mWG7hB5Fm?=
 =?us-ascii?Q?8gCye/3sTO3F01dvwgRd7+jVM7HLbfk1RRCm3dIuRKpMujYFZsaaXxkWgD51?=
 =?us-ascii?Q?nosQMAP/GvPCVvgUdaTYrMba+R634NaMA7LhHavdo/2DGMnpooDtNPWK2LMM?=
 =?us-ascii?Q?a1MqyJ1ruJT64xypsgY56YziwdT7L33GFG5uzFL4ORDlHP/8yG0IewGv0rcc?=
 =?us-ascii?Q?H79UEYCFZTffd0PrZoyDPweOPRKsNJxpQ439tKXHIPgWLH+oM4UWn1iETVcZ?=
 =?us-ascii?Q?YfClPGq9tYEVt6pPGnAsRN5Fa6SK1XOi8GChLrloCSWXiYlbyLOyS8i8+jGa?=
 =?us-ascii?Q?I9N1K4unTVcNsnKpvv8icMd6FTFqbGIip8V380RK5CidAaWhjAkGwUYKPmKE?=
 =?us-ascii?Q?Y4cAdV971aL2uwsSZjMCA1KLh8LLTWM8xffxgZmg/w+dRymCCngKIMo0Hb1L?=
 =?us-ascii?Q?ishOa46evZkd6t25EKO1kNRHE0ULwIS10l/lOnrDtBmcDRmQ3xzuH0a8ys3a?=
 =?us-ascii?Q?v5e1gYDaEwcql6o24GX2F5pKUDLPIV4B8cNe9K2bkjmSZMIBT02DPVaRQfC2?=
 =?us-ascii?Q?w4DjqLPdo2wOLVeh99JEbT8q+PxZ282rrCIZlUCWjtqyEfqOs9c8cZku05DT?=
 =?us-ascii?Q?B8yX0zZO2oAhnILcMI2CJB/Imm/ePY3DrYAbgaLOnA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+WG9NoIC+k8HsZncJKgi8I3tPbZIICQRvg+VtACFtyj7hXPeeE5qn4VvdmsK?=
 =?us-ascii?Q?pfoVCv5cNhzAcWDE1EzdXjCpcGWJ2dG1mCrpQK83PJKDdRLZQS3po3OJWIFd?=
 =?us-ascii?Q?BcyUcPM4vFNbP6wwSaM1UMG8xhWaHIC67hmIv2bmbw+1LVp2ATBogZ4OIrF1?=
 =?us-ascii?Q?1kerwjltTvHWkwdVFbR1Rk8LVXuEzrSo4/wFmJZgE0AaWYLOtZ+nEcp/ILgc?=
 =?us-ascii?Q?6sTFRLkyj+Y/9scswYAHlPwxJgFJV8lkqEe4RjKJO9X/b86L5ZGULuDn3wYq?=
 =?us-ascii?Q?sRPd6KarusSoRVjJ2DQoHobKgVdbOlyMVFB6v/rtdRk2bfihUEPgqi6TR8kv?=
 =?us-ascii?Q?BfdwWXHQLh0cuOzp6hyF6GJOVNYDcYqPYN5WAlsIc/llbUecfht6/GGOApjf?=
 =?us-ascii?Q?tSaJrLTWoQg5Bbw+uqblZoPHEt3QMkSg5t4srVfPg1Dlml2UStpKF0tkaV94?=
 =?us-ascii?Q?12LqD5Yfq3z4bAyGJFT8YVpgjZsIC6sYTIzrsWEdemlBVqRFusbTNb3Zi/e9?=
 =?us-ascii?Q?qOmQ1Na52n8A2yfwCcK9teWKXlzf59KZF5qSs1+8S7N93cUc3O0LyoP6kpSa?=
 =?us-ascii?Q?iv/c1yOAQFv3ZQuUpgg2IdOMrr/xGLg9Q4rHZN201IqVClpdJn0y5c4dEAul?=
 =?us-ascii?Q?0W9h14HIuCCNdGxeUTwVPfMYBLJPkUOexwl1No7wwZ7Tc+e4f7ORhTH8nMQa?=
 =?us-ascii?Q?ci0tRKtkOsMQPo6AVKWp9Dw7fvZO29s4ydT3L/9v58FFZLacnQypU6oq/ngz?=
 =?us-ascii?Q?nkRsVhS787ebZT0V56ZaMXf8Gdr3EUufNuX5YQtsa8AejAdxX7d2T9quxrOU?=
 =?us-ascii?Q?EvOrDGLUMchEMJ21P7VA7QZr1LLCBBi8S3JKebpEy3gTnqqdjfyhweqlLWKm?=
 =?us-ascii?Q?1lnTQFcKJLL1YXjzVs3CIr7AV+Cf8T9UEA1rkjecx6FhPX77yywlqKMLSiJx?=
 =?us-ascii?Q?zQziwqoAdYuCeAvoIT34h2738jppoUhcB9x0mlb959pJQKEPT71QqeiybQN9?=
 =?us-ascii?Q?At2kZ0SBo4CQorN7kpCrRnQPPFfnomR7MsKOrVff6e7t27n/kL0+BnecSIJQ?=
 =?us-ascii?Q?gqa2c1OQ/pGeqOT3LLKnPwpYBDwiR57Njz5soDOFRvsNKpWJZTjFiKMAa4Hq?=
 =?us-ascii?Q?zTCFL8lPAKGcRksLoIQzQpaB6eHLl3gVWaq005q1ZcL3jmz5Sa+ql+14EYo8?=
 =?us-ascii?Q?A4OGRrpmecFt07yFKcY0DmmCw4qcgwbA1gr3qW9mEw23ynbrsST9B9JEEple?=
 =?us-ascii?Q?sZCPBxehoRNpvw43sUwWHhvT54GXd8vL1KwHIAVhaPSnnKlgDmq2xVRr+hl6?=
 =?us-ascii?Q?4BOhnnjbZOw+zuHiyTCK70rrY+rhVkot8KWnqK5Mi9zpnEFjg1ZBPoGZF74Y?=
 =?us-ascii?Q?SmHGgxiKMM6IPvC7qvYYcdTDKlnqQkMMIG6TkaMHKyY6MoPEdSR5fy9ZXLPh?=
 =?us-ascii?Q?xJtQH6MdPyzxLZBjd9MJfQYeTHdnQSGCaV8o8lG6A0uAnmJ54A9AoleC2JB5?=
 =?us-ascii?Q?/SNF1e+V2l4oOelJUbJ3rn12H6kpdiGE3cq4W3+yC1dAhEY34bdr2c6prDMZ?=
 =?us-ascii?Q?FYmyFW9gfiDc3ebf2eXefqZqzG95ZLE5APWhCRj62XOPhoaJRPtqoNvaJDpV?=
 =?us-ascii?Q?Lghn3r66PM2RKv9KeqiiwOg6RlR2a1kSDtvnt/rxi8O+wH8RpwuIfj5XVGj/?=
 =?us-ascii?Q?4jEBKg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XOFDhO+mtGgObNHAIGY3veHzQYbLbFyMJGIrYG5J0Uvml+1IAShppS8r6wccm0MGRgC8pndy67Qlj0yGQgXxtxkcdnacOHawwnDyG93L1RIBT7EKGGBallV8R2jMh7sVRwSABf6tQMfckpfbrEaVjkUWXHb0hEgQ1agAeSYssB4hBhq+CrMb3ytFpcWMbyNCmhbdau+Kw6AVVPSwywjgSlh8HEZBeAnlT30qJmrHUD1OZVGuWrDSV/LaH+677XiEnfNfkPN+2G9q+90xa+FGPoA/84kO7/SGv8l1smDI8NojrAkfR6PfU4+GASHrgjXkMJyT9/I9gRl0BWH51MYaMXRBM1H2er0pdmK6+hmfVueBAcoTutCl1VRl/XRTLTic7YEBuKbNA7cjLNgMexXtotlki593yAU6MkqtLaOeWnJiie4LNMPwkLEFgL9aEUjuZjjsnZu4ewNEBkntZyHmb4qG0fiLSeoEA9vwz53QudNV2YTWrnTx0FSlqyx1uLOH25gGAAnDuJhjRE3s3mRVMNsi1+TCwutkeu9NKCyWMoStbjgYg0flxcNDjP8YC6ubzC3iuvnkBEih2e3yuQLrWdlLeYffOiu8frX09HztT/E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a830e704-c963-4de2-e066-08dce3097dba
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:48.4549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xuP0twWUJeqXAzJJygc8Td8r7z4aqnm+xaqLgLBdIJiPRF7FE2wab0yySWyG+lkg//hU7gaUA8GhirJC6kJ5mYmEXrdpi2L+RogXcifqlWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-ORIG-GUID: _hEu-PtCjQe3x9ZIsScK568WRuQi1WZ4
X-Proofpoint-GUID: _hEu-PtCjQe3x9ZIsScK568WRuQi1WZ4

From: "Darrick J. Wong" <djwong@kernel.org>

commit 288e1f693f04e66be99f27e7cbe4a45936a66745 upstream.

xfs/205 produces the following failure when always_cow is enabled:

  --- a/tests/xfs/205.out	2024-02-28 16:20:24.437887970 -0800
  +++ b/tests/xfs/205.out.bad	2024-06-03 21:13:40.584000000 -0700
  @@ -1,4 +1,5 @@
   QA output created by 205
   *** one file
  +   !!! disk full (expected)
   *** one file, a few bytes at a time
   *** done

This is the result of overly aggressive attempts to align cow fork
delalloc reservations to the CoW extent size hint.  Looking at the trace
data, we're trying to append a single fsblock to the "fred" file.
Trying to create a speculative post-eof reservation fails because
there's not enough space.

We then set @prealloc_blocks to zero and try again, but the cowextsz
alignment code triggers, which expands our request for a 1-fsblock
reservation into a 39-block reservation.  There's not enough space for
that, so the whole write fails with ENOSPC even though there's
sufficient space in the filesystem to allocate the single block that we
need to land the write.

There are two things wrong here -- first, we shouldn't be attempting
speculative preallocations beyond what was requested when we're low on
space.  Second, if we've already computed a posteof preallocation, we
shouldn't bother trying to align that to the cowextsize hint.

Fix both of these problems by adding a flag that only enables the
expansion of the delalloc reservation to the cowextsize if we're doing a
non-extending write, and only if we're not doing an ENOSPC retry.  This
requires us to move the ENOSPC retry logic to xfs_bmapi_reserve_delalloc.

I probably should have caught this six years ago when 6ca30729c206d was
being reviewed, but oh well.  Update the comments to reflect what the
code does now.

Fixes: 6ca30729c206d ("xfs: bmap code cleanup")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 31 +++++++++++++++++++++++++++----
 fs/xfs/xfs_iomap.c       | 34 ++++++++++++----------------------
 2 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 05e36a745920..e6ea35098e07 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3974,20 +3974,32 @@ xfs_bmapi_reserve_delalloc(
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
 	int			error;
-	xfs_fileoff_t		aoff = off;
+	xfs_fileoff_t		aoff;
+	bool			use_cowextszhint =
+					whichfork == XFS_COW_FORK && !prealloc;
 
+retry:
 	/*
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
+	aoff = off;
 	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
 		prealloc = alen - len;
 
-	/* Figure out the extent size, adjust alen */
-	if (whichfork == XFS_COW_FORK) {
+	/*
+	 * If we're targetting the COW fork but aren't creating a speculative
+	 * posteof preallocation, try to expand the reservation to align with
+	 * the COW extent size hint if there's sufficient free space.
+	 *
+	 * Unlike the data fork, the CoW cancellation functions will free all
+	 * the reservations at inactivation, so we don't require that every
+	 * delalloc reservation have a dirty pagecache.
+	 */
+	if (use_cowextszhint) {
 		struct xfs_bmbt_irec	prev;
 		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
 
@@ -4006,7 +4018,7 @@ xfs_bmapi_reserve_delalloc(
 	 */
 	error = xfs_quota_reserve_blkres(ip, alen);
 	if (error)
-		return error;
+		goto out;
 
 	/*
 	 * Split changing sb for alen and indlen since they could be coming
@@ -4051,6 +4063,17 @@ xfs_bmapi_reserve_delalloc(
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);
+out:
+	if (error == -ENOSPC || error == -EDQUOT) {
+		trace_xfs_delalloc_enospc(ip, off, len);
+
+		if (prealloc || use_cowextszhint) {
+			/* retry without any preallocation */
+			use_cowextszhint = false;
+			prealloc = 0;
+			goto retry;
+		}
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1a150ecbd2b7..9ce2f48b4ebc 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1127,33 +1127,23 @@ xfs_buffered_write_iomap_begin(
 		}
 	}
 
-retry:
-	error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
-			end_fsb - offset_fsb, prealloc_blocks,
-			allocfork == XFS_DATA_FORK ? &imap : &cmap,
-			allocfork == XFS_DATA_FORK ? &icur : &ccur,
-			allocfork == XFS_DATA_FORK ? eof : cow_eof);
-	switch (error) {
-	case 0:
-		break;
-	case -ENOSPC:
-	case -EDQUOT:
-		/* retry without any preallocation */
-		trace_xfs_delalloc_enospc(ip, offset, count);
-		if (prealloc_blocks) {
-			prealloc_blocks = 0;
-			goto retry;
-		}
-		fallthrough;
-	default:
-		goto out_unlock;
-	}
-
 	if (allocfork == XFS_COW_FORK) {
+		error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
+				end_fsb - offset_fsb, prealloc_blocks, &cmap,
+				&ccur, cow_eof);
+		if (error)
+			goto out_unlock;
+
 		trace_xfs_iomap_alloc(ip, offset, count, allocfork, &cmap);
 		goto found_cow;
 	}
 
+	error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
+			end_fsb - offset_fsb, prealloc_blocks, &imap, &icur,
+			eof);
+	if (error)
+		goto out_unlock;
+
 	/*
 	 * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we punch
 	 * them out if the write happens to fail.
-- 
2.39.3

