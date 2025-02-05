Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82DE213220;
	Wed,  5 Feb 2025 03:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724867; cv=fail; b=YvUkBfpj42TlVWmZtzHrE1VizUyB/NjqkoEbTBLHI6id8PBm1GwFgM5TmwKWzI0uM3p8slVFlcOnH6r7YhfJD0TCh2/NL/WqKLeol303Wwo48YAyW/78Rh/CwKHkh4sNXHqOv7ER2Uk18OIMgAI/amWnWJHx9jNqYFWzL9rTXd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724867; c=relaxed/simple;
	bh=DHrYUsUyDEsYflBeVcNq6x9NW0vLcQO1GhVzg/8zopw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GYLVF5vJhikZbvAZr5vKJ3yZH+L1Du78N85/wUS70SMUvhmSD4nROJ8zq6r1L7cXTg2pJFNr5ExctrIm1ecxqt8aU8x5X3PUs8qdyZDbR590mm/WJP7e7S1IxEcVUrlXtJZW8E0gDmzxHBEsHNoCtH0y4kMIeKcLRCUPjCb0Kpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XLJOwh48; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ANm2tds7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XLJOwh48";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ANm2tds7"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBqJ7008092;
	Wed, 5 Feb 2025 03:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=BCfe4jt2E/Lo/0OHRCAz3H2OMsnMHpiz7b0GWpY+9hM=; b=
	XLJOwh485SxH/+d3CTyQS513trIHb/vhQwFbqUX5G0EDPNa2lkaFXGTJEU1o+st/
	+RfeAwddUIRDQ813owYXbnwZEV0p3f9QDSauM83Q0ClKM5TbDpo6Jl0HFkimS/XM
	4uF6xLysBuePR+CfDb0B44ICcIsVAet4Kwk+0Hr9ayeouzv015H/wCLU/zPb24YS
	T+xtE8jhgGpWaCmWzAfIeL/ga0lApwwjBT0GYQ1X86a/eHWZK1i/kMG2aP0m5heM
	z8KJhIEWsp6JhaAaUtpCMzzmNNtH8dflQLh1OlL9N/3QbyRrjC0jP6exR5CE06AI
	aHEEz5e561swOS3dn8DCLg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hh73nyk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:07:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51513Ywr037839;
	Wed, 5 Feb 2025 03:07:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:07:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PKN8ituUEUIiFXYjHftjS13J9TCKZ66N0ISjDKPnzJ8oZwwKZ36Xh7MMkIoYm5OcKRz4sjHbXvkChuiDobRwNASCPrhCAArJ86nTK37OT93huQhmnUde6mZ0wVAfnxEHbH9FZrAyZFED0H54Es5uAbMmxq/EA0Fwncqx0SzdvSCYyADiWFQeZfTozLuagc0DV0rH1llCXz4t0GggJcmXJSSXWcPNmBav+X9abs8WulEUMGo9Uwhtw9x0lszsQBfOZX1h1igCH2FVXNM+e9xhiAXx4Gcl3K/2KNAplw/ryObnpcTJVFFem3A5b3QMrJAbzUwa54V3McGgxXp2nF1aZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCfe4jt2E/Lo/0OHRCAz3H2OMsnMHpiz7b0GWpY+9hM=;
 b=YyOb4/DpvbwhZhyOWErJU4sTWh3Ez+szRoegHvCqmN/t+9htezXotIfniSS7YhG9lQfx0vojMFXt+Lss9UwQ8rt17h46sfPbyqGeOhXar4mwoBKG+tSo3/yAYqTK17gVCIFz4W2vdAr2kYFejRzmwU1/ftJdjgVO6S9+qulskTvJH06DIN8Jmpo03pFE89G4UedNg80nSO4H8iYgzf1/8pE/bB3WstWFWsMzK5BpEoewo9nDYl22VDBBcjiKLK2vK2slPUxRam9LIyIRzsE+qqPokqBGLdzH+U8JXz+2Teg7g1T3s7BnwGnaXDlVbVyvCBB/q6YTIHXU/cn9YlFajA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCfe4jt2E/Lo/0OHRCAz3H2OMsnMHpiz7b0GWpY+9hM=;
 b=ANm2tds7yPbD4XVqrn0BxKs9J5VHlwF1XSRpatDMC6DrM5ZdaUrLKraLum80KepSBG+bxtw7vixjJJVmY7hMf60m96Sn5SO9eUbkklBLRsUGBpjD5OhqCV4xHNtP12U9/rtYgrn3C9kjg3/I2YiidkTxeUqlTyYDTgqs3C3CQBc=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by PH8PR10MB6477.namprd10.prod.outlook.com (2603:10b6:510:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Wed, 5 Feb
 2025 03:07:41 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:41 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 03/24] xfs: fix a sloppy memory handling bug in xfs_iroot_realloc
Date: Tue,  4 Feb 2025 19:07:11 -0800
Message-Id: <20250205030732.29546-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:a03:333::21) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|PH8PR10MB6477:EE_
X-MS-Office365-Filtering-Correlation-Id: 128b42d4-1af4-4403-9022-08dd459240c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XZ/8n3JMmCg2oNQYR6miSm5e2e/mVwSZZSkgHdSLQoE9UxIb+H70s5Yj47wB?=
 =?us-ascii?Q?OzcWOaXbj9IvE5NTGARRYUeROXOb/34S0rGwaRsl/R1hfiKcgQFE7GcGqaKQ?=
 =?us-ascii?Q?IPI4R49P/qLGnoSmSVuY3nLyEtrzUsKy/qHeUt9nJJp3bmKZBiMVd7pjZG6I?=
 =?us-ascii?Q?lS/yUGxuMbKSVYbjptkeuO6gL5EZc/P/+w0eX5yLvd/ExQjgkQL8iV4hXzno?=
 =?us-ascii?Q?IFKR4Ok9ORd/8E4vYyRyaDDzDAQnk+KKH90KM1yATixf2VlLAZJ+SzkzhigN?=
 =?us-ascii?Q?lcV0W3gtGcSgzs1GfZPT8kc6HjR2yAnXSSoNuNricodUkAvDn2uEF80qBTcm?=
 =?us-ascii?Q?IX+ZlYpgFBoKmyNKRV6mhtPpsHHMzoVeJyDitiTI01/EyQ42sdzxj9DJOKnc?=
 =?us-ascii?Q?kVHQWDD2Czt+z/uBS3Rp7VCDVJcBq9H2B/KRCp1zlRgP+KczrpfKcPG1r1kh?=
 =?us-ascii?Q?8hjPYEYtjz1ticG3Tkfh8qAYTGumDwCY8AD6etCS0VpZXV3bz6cjDSS5xO7o?=
 =?us-ascii?Q?AaJdbKul+SMJ/qmXhy11qTyCdkPL4Ng5P1sEAra6DgWev7TI/WLFC+IHL3Ao?=
 =?us-ascii?Q?+ZJ2nmwGxQMjAZoHrM9rB9i8ii4k/c+E2ej0P61Dq7KCglv9QiQ4Lxt8FwmB?=
 =?us-ascii?Q?92C0QQGxHC3XuNtSqMBctmO05GOa8xZySNXPcSrcuUZqRAABUKpio3vkfb5I?=
 =?us-ascii?Q?fpeqjLrQsBEk9NhZ6jrGSAm3myIH/0x4bSkUZA0Xuur2Ohrc2mtlefOilLgg?=
 =?us-ascii?Q?SsKEc9YP0sd9Jqm8VFC+PTwK8RiIB2klk3l5IjQmnBEn7f7+SLIoy+N1I9TA?=
 =?us-ascii?Q?WPRRFwGLGzJokCaIeEy3DngOowdSvKIQ9at8CvHL8f4F5jsn6N+AMLKXU4Qz?=
 =?us-ascii?Q?fMwKJomr8mQV5bAjFqXXWlchm7FRo08CV4TzN+FSi9IH2y5LiDwvQLpiRcSi?=
 =?us-ascii?Q?oUX6yVV5ALHUjVkUBWdHi61Im7Oi7f8fgpzZnxNDr2hdgZhlH630SR1y3JeK?=
 =?us-ascii?Q?h3dId4DaWXcV/vKtq8zBGZQ989Gh9gBhT96rfD455kvnK5ugKBOW89kqou3R?=
 =?us-ascii?Q?1cUj5dCZTQ1D9NYtMImpdycxhimkWQNBYOCIUSwq28IGUvdokI4u8WDnE+/0?=
 =?us-ascii?Q?a9GbG6z5GdBQ+gwsJPcwdJ4Wvm19uuS6BgZzMl5YT4Iv1i4mLUNQWQCumOGq?=
 =?us-ascii?Q?bKNvxu7i64xmFDecjRSfhsvXa7PrR+334B6gU2xyYKHXpgoqyrFOHydOJ+xZ?=
 =?us-ascii?Q?IdYTxfDM5VTxqCrlp8+SCEXVC7Em4RPNXzT1guu17mgVIGgC6xNjDact8pcx?=
 =?us-ascii?Q?cs+1K7gsY5SwijQOBQucQ5IF7C4zucM0hCaJjncDhB4dNpRQvv+rieVUZGMZ?=
 =?us-ascii?Q?t9QabGI7JI5g76N66VyCE9LxV2Vt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F6DHYj+nxr2gl6/U7oE8fp291zy0beQEGImHDalUEauyoi7fIaBQmcGamrB3?=
 =?us-ascii?Q?HI9urCA4QrM9soI6H945qp98hCRQIPYemjWeVvUUNWFMZh7TgPXhZX1Nb78A?=
 =?us-ascii?Q?9Epj7XM7Bse4rDjDrknC7W/CksolItfVrqdJMWDzXHytSQGrks3cmS+YT24P?=
 =?us-ascii?Q?0Mayn1KaPBpq8AJUM1spooU38HANvQ5oOH0u31CVUZfnY8/sjihdnvdCP7Kv?=
 =?us-ascii?Q?8JDrIwuvr9k5qORkfHhMRZTmU07TERsBEoeg22vHrKh3YTE5YCW9Pa0D/YnJ?=
 =?us-ascii?Q?VBnTlEgzyzaynUEN/pvEh9u5gZQg2oBfFnqLZwP92jMhVnPou5fBwLx8c+pO?=
 =?us-ascii?Q?130k8GpWO2zEiB6CUujcSiLOQag/ioUZneCjD0FvlQEEYchCCfva69rjQ5rk?=
 =?us-ascii?Q?ISAZDjYRZRlaLW6roOOecF/Tj1SIn7SJwp42Q72UNmdn21BUivo3yflzSZNf?=
 =?us-ascii?Q?82Sse4fi4sR2fqqE0gbCmJDSP5yCHIcYOniCE2kj7XWHzyz2szrvIwVtUgPj?=
 =?us-ascii?Q?Kfvn3C8UxJEe9VxhVkoV9mwKiuLTFlDezFv/v5Bb9b142TTX6v1+910/svPb?=
 =?us-ascii?Q?Ym6Crdu/j00q4qJRqN6R5TU231xVWDIRIHXTfIZNNdOA18tqPnWyQd6hB9wH?=
 =?us-ascii?Q?EFSrRF5SF+1DVJuLazUq1/UKbop5x3ZITp8xtv0g4DhnHbkXcD92zxffy3HJ?=
 =?us-ascii?Q?WPyFgKCxRJ8APnJLnnAZ8IoSmPmK4HnBqWq1lon9K8WxG/apladA8S38AHSf?=
 =?us-ascii?Q?oY0N3viDgPeqRg248dsuoEh4p0Nz9x6orqsE3OrZBC15ZmaNxviqnO1ph1qw?=
 =?us-ascii?Q?QlLC9UAmpR8fE3c3u9vOW/NDi+dKAkAIqYCbQGAwv0NgcbYpEZUk2mSDq48Z?=
 =?us-ascii?Q?PIELQdVoQo/a7C/GCXN0whpgzmnDK8SUHtaWZ38XFQ6IUUVpVw+ybw9deBbk?=
 =?us-ascii?Q?iLGrm5QISLdOPQHSHlOBqkmJA1kkGRaDIvAZ4zFNTG3068LfOxvRfh1NIGkF?=
 =?us-ascii?Q?yyeKNsvdKgz5LFkCHScN2+RxbsD36NKnfgCzu6tKQATV0MOC7yh8NbYouchS?=
 =?us-ascii?Q?qdZZNvfeWDuR6AP0JETph706FvwaJcZ5/j7TFvB7OhzvUl91urs0jsuGFfkM?=
 =?us-ascii?Q?iahfx5Ikfzq/XrVGy8wXR3GPBiRyYyqs+QqVj2nG67y8aANNI+/2ZXcydhXx?=
 =?us-ascii?Q?gCx8pmpCefBhS/01kHrSfnzWynz6GZJkVhMrgOEYf2JnKRuXzmKRrS/zW4em?=
 =?us-ascii?Q?lgkvj4xtQuJTnr/V7aMTz0wc0ET+2TqxnhHze5RnnoGBFSjqXTNaI1jV/WjM?=
 =?us-ascii?Q?qHYdlYYZxthwCyWBfyoyZiDdPl0ctQ9nyQ5OETBI7nz9qvIbSvZeaxIUOFec?=
 =?us-ascii?Q?9dd295Yz8UkEBfG29rGYInuHXXMRgLEy71qhLiDRGIxIx8iwY2QITaa1/nbL?=
 =?us-ascii?Q?u5yA5FpsnMC3EHrtHIfgMQF4E0Qdpln6LCBkKA5K4M4NtMn49PzI6OUjfKn7?=
 =?us-ascii?Q?h8CaLBXsWzf2YNCC8YWj2o6w42tGTxBOdKrHxY+ObBVD3VP+n++nbg/Nbkns?=
 =?us-ascii?Q?Drj7ASrHl+H4RSpPXx9nUh0vO05jtrskwJx4hGDGCMOgp0eizdD+MOTQhG4X?=
 =?us-ascii?Q?VndV6bfL+JwDRwvQYVv0ujVpqG9fD3YnqbjD7nT20DftkiusbfL7hrjjQ7Bx?=
 =?us-ascii?Q?OH3Rog=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HTuMyDt9G03a5uU1vgxhmSzN5eLuxQChdMja4g5OqlounINEh1oykTukQQzJLfzmAKiNQ0ub4FZZX5eVtGzp/Twm6pKyr2pXxf9iYWIfD+owIROh0T44WefCqULFKmqv+WL/sTLv4+paz0gcdignqGWgDSFUZSM0FbdjwrZ0d3KcP5woTfsWzoTMg+Oh92NLpCK4JcY+0pe4IO9br8WGyAtbSKOViezl0inw/t1FVB/4wmRrra3QzYpciLbKnCgiN5cu2qMgvoF6Zn8L/5DphPDP0AQZG7Hq2zyJUwrYZahYjcW4D827GJ7HS/mVpg/bYsyDZWRhfJMhDe//RUUbPyRCS9MZg0s7FXNhf2BuS/iLD0IAbEr8P64grOR1XNGLkUH6oUtXQMq5JUy8iwbDKJFt95ej6tBIbQzNx6bAhew3F/kDgWQPVqVnir2/s2eOrcmuS8oi1hEOKI5bApqBTNbc+EALBVgLbNx83/8vrEZM/erEenrsUGiUW+yB6c6lXbY/yIarfMy8nYLwX/L4MKFhyvpJnNvdENClrrI7ZGXEwJJx+9gpI7sLpgbXOet04TuYarLHw/Mbz6cCgYUP6oAM7E+t589qU2y2yYPZNcw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 128b42d4-1af4-4403-9022-08dd459240c7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:41.2469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DSkxRpMkTMCZDu+elHiGtHOmJRXcQR/Fi9atenQJto4cZ6torB8xQdR16PhOHoVlAdXJSpw8co0n2d4W2d6Dowjw/V/7NxdMaTY1DIOFXt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6477
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050019
X-Proofpoint-ORIG-GUID: lhTcU-J4VXl7HJcu96W6Wk2k25GYBbEw
X-Proofpoint-GUID: lhTcU-J4VXl7HJcu96W6Wk2k25GYBbEw

From: "Darrick J. Wong" <djwong@kernel.org>

commit de55149b6639e903c4d06eb0474ab2c05060e61d upstream.

While refactoring code, I noticed that when xfs_iroot_realloc tries to
shrink a bmbt root block, it allocates a smaller new block and then
copies "records" and pointers to the new block.  However, bmbt root
blocks cannot ever be leaves, which means that it's not technically
correct to copy records.  We /should/ be copying keys.

Note that this has never resulted in actual memory corruption because
sizeof(bmbt_rec) == (sizeof(bmbt_key) + sizeof(bmbt_ptr)).  However,
this will no longer be true when we start adding realtime rmap stuff,
so fix this now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 5a2e7ddfa76d..25b86ffc2ce3 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -449,15 +449,15 @@ xfs_iroot_realloc(
 	}
 
 	/*
-	 * Only copy the records and pointers if there are any.
+	 * Only copy the keys and pointers if there are any.
 	 */
 	if (new_max > 0) {
 		/*
-		 * First copy the records.
+		 * First copy the keys.
 		 */
-		op = (char *)XFS_BMBT_REC_ADDR(mp, ifp->if_broot, 1);
-		np = (char *)XFS_BMBT_REC_ADDR(mp, new_broot, 1);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_rec_t));
+		op = (char *)XFS_BMBT_KEY_ADDR(mp, ifp->if_broot, 1);
+		np = (char *)XFS_BMBT_KEY_ADDR(mp, new_broot, 1);
+		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_key_t));
 
 		/*
 		 * Then copy the pointers.
-- 
2.39.3

