Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAB1286D6F;
	Fri, 11 Jul 2025 10:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752231235; cv=fail; b=GNviRoGFIqkwT20A8H7O3P5C4FotUv5nQ+vHSbd87QjNqjrMJxFvFcH1xqBHJD4ut8jO5yAFWYKqmEUZA4XgwL5Py5r/4yrOPUScSBYy075AOTe+9TSNEgbhv4YdVctfHasvQ5b0qbyhMA9rHOtE6fd4biWqDOInVlNYCaiqA5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752231235; c=relaxed/simple;
	bh=yycJVmr3c9FKOajDmjF1GfgbbwvmTHlyf5Hyec/q/UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DGYJnXNRh26DQy96RUiB/f0TxEee+sL2GstToSgXbfOArDE1gT1WxAEXLgD/J0E3PQgrMdDS9Yr+adxUiu3C5BHHI40WrX5ULg+Nq61CMGdd8vd/+r9kAB/cNGr5yn2qELKMFgXMM6tzfh9w95cVNK9XlUMYcE48Kg5SVAjyFOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hyV4YbVP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PycW5QGq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hyV4YbVP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PycW5QGq"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAMO79009941;
	Fri, 11 Jul 2025 10:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SDbJJ2oBHJmZKCK3Yk7trq0/6fF3jz7a8JrFVoc1zB8=; b=
	hyV4YbVPwKtQprZA6uhOrmiY7cc9OzYNnG9khLKgAk49hQq1Xmck6wYDl6msHq7s
	LLUxEU4XQPsVS6eSAw9uyK1S7LRFKTh46/GuIz94ZODzYWEu52aDEepGfLJOP9EU
	5joEncIT5/jIJTrAR9O8VFXr9YkITBZiJukRzeZfFe1PzH4EkVl/Cfg+uFFbmlzb
	rTGstNnJq7ZZr79xdItqe7yzRwr9pYuMoRzxk+5Z5nW+esEvOpTjhjl3lnMr4yJD
	EZtMrwkVYu5GjXPIiAe/UkVg1LjVeAgJ1Ilb7zRAthyhAd2zMXINqdtf8YyYIaKN
	pI+KYGdcS7V2+VK+mFhf0Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47u0svr1nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56B8U2Qi040676;
	Fri, 11 Jul 2025 10:53:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdndv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zM6YoUimFWHhsLEUut0QScf5kn8z7U5pDvAokNUHf4K1RjOoyu4Ll3sPIKwDkt+XzgYppYe5ttxMPqMWGasEc7kPXLQIOCsLA7cfWtPXD+7masclGSljS6eKCV9XrhP+7m0L8YZgQEqG06aqVMkAMt74mAfFGfWjxiWZkdxI9p0iQTfsi3JNsFscHMz76E4cTceGYXL4ggEMtlOAK6aVeHaHHJejbr/1+xsvAxnrGZzqEj5d+kRK0yUhw2/HQbv+aLWX0wB6YPF+Uz9CSxVyd5dDjiltyCFXgdppKObbh3asbI59o9Hp/Zm1VJFgYhiuQFOucjSXvZIwIbfK29Cjgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDbJJ2oBHJmZKCK3Yk7trq0/6fF3jz7a8JrFVoc1zB8=;
 b=tbpZr9HLkLG/mEZ5dYm16raX2HvFhxG3YzqZ55wklyRUkooEVP3KCcQtv9V+ufMURX3aYVusaBm5D3ZSRYuWiZETwZlLXepd+0gD+hQnz/+RcsXKDgunDNpPpNPBkVZcJCDvuDte6vb/meeF1InkGW6t9FL/fDCTF0XIzbZOe6X/XZ2+wPa8ypnSRP67y4hNzoOezhNBHWaNMMFtwH1qFMEM+3h2kkS7b5mE+DBkYHNP6hEq6M0Rjohabe5YEZ+Fu7HkWxdiKIkX8mjyjfkaV7bVLuFWDJVme6HsW2Mlx7YLPcnTDHJFm7USwosG9v0p0M3LpzqJdhfhqGHby21VZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDbJJ2oBHJmZKCK3Yk7trq0/6fF3jz7a8JrFVoc1zB8=;
 b=PycW5QGqMlSkHrWsQYjIjioKGPGewwqiCoQywaW87/bHd1SAGAMMSPX2PQ3iKzrkPNCxn1OTCctMVctq9jTEnE843VyRWkH7rAJ1xMRm7B8YaEE4zKPcy0GU1v5kaxrZJ/DDr735hMBNki5Su9mOHBKN2eepbyokO9vrloc+IlE=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF079E800A3.namprd10.prod.outlook.com (2603:10b6:518:1::786) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Fri, 11 Jul
 2025 10:53:06 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 10:53:06 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, dlemoal@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v7 1/6] ilog2: add max_pow_of_two_factor()
Date: Fri, 11 Jul 2025 10:52:53 +0000
Message-ID: <20250711105258.3135198-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711105258.3135198-1-john.g.garry@oracle.com>
References: <20250711105258.3135198-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0120.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::35) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF079E800A3:EE_
X-MS-Office365-Filtering-Correlation-Id: f8afcf8e-01f8-4fa2-3976-08ddc0691dab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vMlQxlys9sxBuGVRlexQ3AqUxto1ot55q+Xou2VaIKNjU8JNyWLnK5hLdsGn?=
 =?us-ascii?Q?mX67UYkRtBSJaANtICLnft/NwC7RVfQQy5UL04c+iw/BgIVTRt7NtVP7t3E+?=
 =?us-ascii?Q?pz7daH6bgNz+dAmq2hQ6/NoInNzvGg/gyJOf5aexfQmdgsN/ZAxOrfs6po1a?=
 =?us-ascii?Q?1UwZU7qR5bbICy3bdqAQbgRsekcMAtyeJhnkhEC/oq5ZrzXTu/Dk5VkplBHK?=
 =?us-ascii?Q?/jKIrzfMCTxSlyH0wHUoM1pzYwZ49mNpKaY6AUv/AyZlxZ8BgifhwizQm2GE?=
 =?us-ascii?Q?8i5PUPqcwEg5XVh7tSyOmwxqHp0rtYbwJlbD7A66MK4dR1IFiFllWmHXVjeI?=
 =?us-ascii?Q?qoaDZx2/w6Hsn1F+JEvFW7M39YKmXTiP88PRputuZkL4D6lv2QigsbFVcCBE?=
 =?us-ascii?Q?YAhQIDQ/kepvMwD2Eb5JQBo90wJIEM4gG3oFtWLH2MfzwtzeajUooTVa5g/d?=
 =?us-ascii?Q?YkLEC26Iai/B3ihgPIpGNFMqKY8z5xd2AceZr1N2dNOGJ0JigUcG0xzR5hdz?=
 =?us-ascii?Q?usM3xf2k6XkVrW/dr1j4X+n4WUWITbzSdXZfMrxJ/VOlTHD47NE+0/HAEoBe?=
 =?us-ascii?Q?uU4i1KfoAPCzQ7jw6R/oIczBy61t043ioZGL6iZB+QolWcdIx4tgEplNbmyf?=
 =?us-ascii?Q?O62KePCVlULSi0Jxd1Pjw0irlsiNm/v+kZ0I3XcCy7G/I8atemaX8B6hrV/O?=
 =?us-ascii?Q?++t05xumvNhv0yf6td7NHSoFNCdeUcYtbFmTWPPk0mIkH0YEWeLt9cSL0EjC?=
 =?us-ascii?Q?zXqGfpYgzZXi3WzZqau5ZZSbgj5jkd6LMEdMhRLRoU7n4B81d6Yd+aluqXtb?=
 =?us-ascii?Q?sCFPiyq4gipng8BTYxHHs9r//BWE0jDjqwLP/UYjyxDTO7Q8TrUuQEQZgNd8?=
 =?us-ascii?Q?ffE9NXZmyZzEYvtMXPSFWb3H9JeVqM/unCcexSVgc3J49ImIjo6u2N0epmBK?=
 =?us-ascii?Q?CfU9aHsDmqLilCsihSHy6M3Fz4dYTwhFFf+ftydRH5D0FY5cJF0HQCzkxew4?=
 =?us-ascii?Q?P+VY9UU/zlVRkgh3cFRDC9F1V+6NOnJfVrEZzXk/4qUPbuMQ8Pik9766u+JS?=
 =?us-ascii?Q?OsLWXBr9GE8+oGTrm6xrDOGEuHV2hUYai/hJODrdqUuQS6U8Y+3ywFlooBE7?=
 =?us-ascii?Q?6ceJfOqOywTAA9SjX9c6bxbWBpSWvKMg3mS3ZXani4E4kjvrNS6U69i5inUb?=
 =?us-ascii?Q?aiDCDwp3/vVFEGnTdfPNPlkUZT+IBz9CRv/cn9PThtzbQFowtpbmMmyJXXJf?=
 =?us-ascii?Q?1Ol7ZSBetxTXOxKXDQymScBex4ejivemCvCL/aFc6TRxDecUPXfBx6StelQD?=
 =?us-ascii?Q?EMpPOnwdOzyKI3CAUDwN08EYeuATLmc2UnlBEiC3cWIxmk9g4tlhb3gg9ViI?=
 =?us-ascii?Q?BzyI26/J/2VJzAkdHTm1gX8Wd4myaoNLOp+PqRhKJER3KCPi/hV5L4I+k46I?=
 =?us-ascii?Q?V5hJn6E+cqo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?drW7dw2s4nAc/Tu69q3WYfVhahbI7+wMK10LOWD0X1x6HsnYE0jgFEl0Prxq?=
 =?us-ascii?Q?k0XeW+Bixk8Ntx+pSKgdS74BnQMV6oMZopsqMADvvkq853KJ1yra49ovA+tL?=
 =?us-ascii?Q?ConFXIXIyKwpRHX4qA/c4plbJUORsr9azbHCuAT+8QtUSu/fHzITeNDXV+AX?=
 =?us-ascii?Q?RlhrNTrxMz8tjxzLjYDPTgkB4J85z7WH2daA1oIvlpf/ohnR3bK/7iqPupQE?=
 =?us-ascii?Q?0exv4Y4jLHvzc1T9pmbMdVqj1kDKvoH0ZlFoPcnCqK7/aCRKcg8ybWMDek4F?=
 =?us-ascii?Q?Vn8CJUi5j70r/0WZfqzw+DOVJ159bxB6wqGQogyswTnsGTTlzFyfhWyyjLCm?=
 =?us-ascii?Q?eSXpyAb1ziqTH5mYWzImAamiJH8Yzkb37MXSIwPnP4RoiGDaaizu7+GaTakj?=
 =?us-ascii?Q?68v0aP+iE+x1IdwwQ+ksrg8G6MNWAoEnzpgAvo4ndfpmT784DOO//Ve5aoBg?=
 =?us-ascii?Q?ZfI5t2JpaGRgTAOU90jxWjyhKDV1Yh7dnnjRnc/9I+YpOv7pMc8E/HvYmE9O?=
 =?us-ascii?Q?fZ9ASEbENqqaXBEg0UH2C9HimO5G8foSWFGgURZMCOVeVE8fNWeI5nAder1l?=
 =?us-ascii?Q?hgi66jKFpqUCPaJgEJRpsPukE5JviXieskTHBDaw61wqBpL1kuTnMyXotS3W?=
 =?us-ascii?Q?tQsk+s/IoGr4fDBGqH3/MLexg7V6oxl3eG94PPeEVa8XD0B+ce/QSnAgiaJK?=
 =?us-ascii?Q?YKCht9G8BxeC3Lb4/2j5bZIQkZV9K8t571Y233Fm8+2UMkmwdslSPYGantIr?=
 =?us-ascii?Q?RS7/5QKiJg8bZJodA7KIzbLVwQvbu8ofXP4s2+fc2scppBKiE4KImZDl69Yg?=
 =?us-ascii?Q?SonI2kcrZQOlqKRWm4CSmBFU044Q5HddyEhrxJXp3xsFdQE/AbzvpDk0yC32?=
 =?us-ascii?Q?G4sDeUSEvYm1pdLbklqghYLFW0RHxvxMG655iDgJoBiwZDc3i4lQd8in50tt?=
 =?us-ascii?Q?7aVGlNLQRXd2dQlHLhuNnMj7LvlFy4xDAl1ogAtH/McvlUuHehqadQ8Ita2V?=
 =?us-ascii?Q?L5V1XjbJ92v/rUyHXgghhIAELy54eYrr3dK20W7AQMs3EXZ+DBy6X7G+8ErI?=
 =?us-ascii?Q?VANf6yTyrojwmach2ogz2TeVD+PyRDl9iVNEc+UkgKsbYqOBHhy3BNWKkFka?=
 =?us-ascii?Q?Fnt8RhLyujtAgdqx0tKQFtm3BbLmrC1ixzim6DPWW7QjqDVrLqW8smUDmmtt?=
 =?us-ascii?Q?u7isQr2cJrWQCf1LNpMd1wiheEWyKXQfTdHUBYXCvpWddLVxLmJBozhTOX2+?=
 =?us-ascii?Q?cHmCbHERo5wfW/jJcB0cLvUOtkCrptC2ya6KI30338oblNgtX3utEG1e4mem?=
 =?us-ascii?Q?45BV11xiMpJSO4PcMR2tzERtVM0uBjdRvduk97xM4fZ68ifM9wdu7Wi1S3nc?=
 =?us-ascii?Q?52slesKd4fYX4zNwcmNEWrHvK1qnepMjELZh/V10E6Y0x3jkVGTbbiRqi/pR?=
 =?us-ascii?Q?FZzAGwWqG69vndGOZv7ETgKBbC2vm7UO2EcpogZy3EK3nwH4I7+W+frbs1C2?=
 =?us-ascii?Q?idH2znAec5B1YugACp8+eNQsDJAGRzzmXpN8xsyvBQI2e+BaAVkU2SseqmBj?=
 =?us-ascii?Q?njZWrdw1P92X8fRJhwInpjhv2K/oCabVew/EnYUsGgJwDIK7MWq9fLtxPLHI?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hQr07J2JEgIP1lOQI43RTEXmkL/9Ksv2q27nLA3R7xehEjZWPsKHsEZcrviNdYnn5s0mKm5u1taQ8HyFt8anUEM7t/hhbB/rohzHNLzCL1IjbFPqFEBMCVeCgsoarObljPAS/iBQTs2KgvJA5kqDdxn7YCXEkd6fAOe3khxnq4SqCQ4cmHec+rW2CzMP1FVIgAWsiiBQ9z9pLlW3we/hN5u3y7ZsSVG4Vhn6oRjk3c5Urr9U6GJLMh/SSNDliL7svrVUne2eLwwUoM8a1G/JfZLZfcSbJBKQsZRHXdzym0ZLCq6cM7rZrai3lgIxYObKWcEKbXAm2u+qJtfVhOkbjr70vgmKSxcjKPhRpd4RdckhIIhnB8QU0scCwuuwpTP1oLsfoMxCV62vyyw+/IalvJSiyqn87dTKZLUt2FJho6BDK0uQp33rqeJ47TrW7yxQZKlTER9AzuvSXQ37+m2shSzXMDteo9h2QdfRK2EK/paEmZ9YfLWRYcmjANy/uX5l0q8P5tQR+sqAG4Gq0EoVfGeEkseVJiyzRJmI4gL9UFOUyQ/QOaFvLXvjiqX9700fAluIm++KQigKIa+Ey6lShI9LR5MMWL8UdBZ3APb6fx0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8afcf8e-01f8-4fa2-3976-08ddc0691dab
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 10:53:06.1024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hB8AupykgIk+VdN8lC6Fq4u8CqsaWAGIj+PlPgDEBVLj50Ctq+vOMMbKuH7hK1E6Db0VM5Z6ENmBwQFzl222nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF079E800A3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA3NiBTYWx0ZWRfX1GbOYoMgnvS0 +MOflUsp6ekv+opBEniFGJHGer81Y9j6+cAz2X+M7RaIMAmmBOC1IJyS3WIlRywmtdTkVPx/lqF 78bh/tdUvwn8NoRG/3EwtbY7fr0bU7a1cZn5dzITEWbf3LdG7cCD87BLkB8GGPayC4Gnx1qKxQ/
 1UabYZBs/894gSlJz2MEH5VNfRFV3hgVJWfJHvXkjwkxewcTicz3FhyAdAsHDXxqoQyoXWd1PyH lSTaWNB0RBa9uuKuhexhPNzeswY7YsVfZ/qyxcI2jofaoleuMN9Kt8y5xCOIQ72W9v6OwiAXWNx IdbRil6kfFeh5VzPj4x05dlRUU/Zy4HE+igKVkCoBqZ6juZMZBioVUhWcCvtF0W3wDCB6tByDA5
 +p39jmHMBItVHj0ZoRDSU+bUbX8yQPN6zysQfIGTr7Oyibp4CRbdg+I/JlkYUljZIGxKLmOf
X-Proofpoint-GUID: j-i2JI0xOuLCYJxt9MhHmOHC6iGnUBB5
X-Proofpoint-ORIG-GUID: j-i2JI0xOuLCYJxt9MhHmOHC6iGnUBB5
X-Authority-Analysis: v=2.4 cv=PpyTbxM3 c=1 sm=1 tr=0 ts=6870ed34 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=9wh2qRDMZpkBaRsaGB4A:9

Relocate the function max_pow_of_two_factor() to common ilog2.h from the
xfs code, as it will be used elsewhere.

Also simplify the function, as advised by Mikulas Patocka.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_mount.c   |  5 -----
 include/linux/log2.h | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 29276fe60df9c..6c669ae082d4d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -672,11 +672,6 @@ static inline xfs_extlen_t xfs_calc_atomic_write_max(struct xfs_mount *mp)
 	return rounddown_pow_of_two(XFS_B_TO_FSB(mp, MAX_RW_COUNT));
 }
 
-static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
-{
-	return 1 << (ffs(nr) - 1);
-}
-
 /*
  * If the data device advertises atomic write support, limit the size of data
  * device atomic writes to the greatest power-of-two factor of the AG size so
diff --git a/include/linux/log2.h b/include/linux/log2.h
index 1366cb688a6d9..2eac3fc9303d6 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -255,4 +255,18 @@ int __bits_per(unsigned long n)
 	) :					\
 	__bits_per(n)				\
 )
+
+/**
+ * max_pow_of_two_factor - return highest power-of-2 factor
+ * @n: parameter
+ *
+ * find highest power-of-2 which is evenly divisible into n.
+ * 0 is returned for n == 0 or 1.
+ */
+static inline __attribute__((const))
+unsigned int max_pow_of_two_factor(unsigned int n)
+{
+	return n & -n;
+}
+
 #endif /* _LINUX_LOG2_H */
-- 
2.43.5

