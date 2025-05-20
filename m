Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA07E253F35;
	Tue, 20 May 2025 01:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747704859; cv=fail; b=W9myb1xXrfJro7gvAq9SBpyRVdzh9tlZS8uhCJql+JpMp+q22S1RL9xmwRzj0JyVW0WcxPcqYS4uKDL1e/+Lnn91TygmFK/1tmqLQNoNd8+pnvLwEKNuqWy3P3p2jV21EdJTgRJU7Ed+7WVcAe3ceGeLTmBmeCP+vF9H5uwlsK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747704859; c=relaxed/simple;
	bh=276FXKd64Cbt/+oxqNuK65fEeT9iQg/HqSGiahN9VQM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kqUF0E5r95LDfQNwxgaf5db4gBl5Pn07O6CWCGZsJWaJkuBPUbwRHiuJnLQcK88nGt6dWFPbt4I7QrXLQf1YMzoHvieaHQzZxoTaWgoHziSeYayfkwAU/9XNcHoiu7FTGOlTQTZEZknXzk2qagQaDQS3jvT7otUoVvVmYscd7gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I3W5G679; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XQ31QkLE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I3W5G679";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XQ31QkLE"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K1MrqR029505;
	Tue, 20 May 2025 01:34:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Fud6mHHaSz/R+joTTPFSG6K5XVK1PZWiYx/y3xnFp84=; b=
	I3W5G6792UbXX2Ze6iCxZQHyoxwtqZ5SLSOqv2P6PuaecPvEiWvLyQiVAdfJsvHl
	6zdOFHB18dxm0vLsIAqo3or8BBSh/XpCaIVQsgAyAaYp9+WCtVt4TSe9GIrGrWHd
	MSmf/4WTcF8De5VIPGptyFywP4MMh9/oe+R58Lr04PTJIdvEXMow3GccQdVcZZc6
	/KmcTZHpt0j9TA/zaFuOVvykQVUrDEFdeWDstK2Vi/me5N0sE1zvIgqwJVOY+l5V
	nvIa1WL+IQJqecqDHK1HGlc8PxTy264l5RByMSIhbh185UVkbcbxNFhygZRNxJwA
	X4F/OtXGqH9bxZhU2/Riyg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46pjge4b6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54JNloAb037258;
	Tue, 20 May 2025 01:34:11 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17010022.outbound.protection.outlook.com [40.93.12.22])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw84met-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ookUbkoQD07YPLfdBYi2SU3pYvB0ty+ejz6JMPGj9DiuS03hAYO15u28IkYA1QdiEjhoIFgzvBeR0jdn5MlLaRx1sUhfe8DyprY726omonZB+Tw0HVxBJuDSHi3RukVQJLVnwLpVMjUfgPzhJmeES2YtbMmPEWcHJfQrwPlOkgMwr+5A4gjTBFB9GZ1hXn2830VfiTFTUb7etSFw0MppUze1iuaTNmWELQC80aPoBzyPzrpGGnsf1JBe1bBgtyGiGvLfFQmYlKgBBw4Cgcck29KrNiYIfPrVP+QaNaRWf78UEbU92T/j0cnU6y5Rw3HouHu9mw7n8xPa47Hx9Y+iwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fud6mHHaSz/R+joTTPFSG6K5XVK1PZWiYx/y3xnFp84=;
 b=Yib5wfLsrN1Xpzfe0BMucRc/jGHupDJzhyLWp3dGIUqDr0kW5NrygUk2mmqAxDCG9dgjETlY2R6K/7D+L4o1BHq2SFYy/Lb8LR3cy1/qGNXpF2iclfPElNDUQSxlbHXUFvK0AwK8SSUVwfy3oVis7HOoN60ms5KziHB21cDKCBwKb32l0/FvBs2HGvw/exb5JsczCJ8ee1UAuMUYJ3heAFq69Ryh+4i1SoTxf2LWO0rKQAeCq9NYyrlb+0oMXZUENqzX5xf8NmC5G25z1OMsVnT1IHwLrw6yYZ+wnniAoPr7+cVoM2tIP5hDVFrT0pqEevNgLeO95hm3lZjEAyjlbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fud6mHHaSz/R+joTTPFSG6K5XVK1PZWiYx/y3xnFp84=;
 b=XQ31QkLEYEgfI09H2RDovv3FapOqRQEvLXvSI1HFTpmh72qK7SBgZ+5m723cuBt806mpEk/2m1MQLbgQMJ45Nys1276k+IzMgkfuvg+MUQuxdnshRDoBXqPFea4FNomiS7VClxHSxB3PDqd8MjAJJ0OrSzHUDAUpYTiLUra5l7Q=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB6639.namprd10.prod.outlook.com (2603:10b6:806:2b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Tue, 20 May
 2025 01:34:09 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 01:34:09 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: [PATCH v2 1/6] generic/765: fix a few issues
Date: Mon, 19 May 2025 18:33:55 -0700
Message-Id: <20250520013400.36830-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250520013400.36830-1-catherine.hoang@oracle.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0017.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::13) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: cc8922a5-0759-494d-9db3-08dd973e67e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KGu4niGhdgpaO68xKEhyAq96sFaIpVGhUBrMAQRFuf6cNzb8s8Ml2lBwE0m5?=
 =?us-ascii?Q?Mk+qA/wa0RDGOJQGExtn+gq+G4os4aulPnodwWD/w2oV214zz/eYw3MTsOIH?=
 =?us-ascii?Q?A+LMxNEzFPQsmsPc3gF95XlbPembi+WZJ+rgCnSqJj5ydCxArYVWpiQQ9NmD?=
 =?us-ascii?Q?4SLnuYAhUnsCWSYFpimdzsjFvWcqEG4uXTXhUk3778c8DZJoa/9AI85d+Z4M?=
 =?us-ascii?Q?UXqq4zh3w81EC4L54KJLajeGn9jewehliknU9ul/o0+nJTsDzC/KQJp4EJwh?=
 =?us-ascii?Q?/93ZeOwLUI8+ec8GYT5v1Y4tQyinyn1W4Abj4h+xr2KkUN8N9NVGNPUZRYTx?=
 =?us-ascii?Q?7ZcNx+qkL40nU+zv7rRpLNW4ZZbVEBKny8YI9ASNSP4xEeydi2V5ZBHSfp8K?=
 =?us-ascii?Q?QYYOclz4LP2HhiGH+h/tIqmcCox0znU0vsjVm6fWvAV+lpNkA1WUGJ3qwFDi?=
 =?us-ascii?Q?Ro+GXLN5812yQP04Tm9LBEUYV1aMGaGtWA/5asLLTSxvdjwxEzhWxS6OqMsz?=
 =?us-ascii?Q?jXsg9njAEYRjdyBghaYXASq5MizZTHU9nmZ4dM+gnqoSiIp0EwIndTRbrs0e?=
 =?us-ascii?Q?kR6PXEkyXhX5kqCqRJCRswtwtL2TGMDM2f9nNCGaEU2PxGs/q+jZPO4IWSCo?=
 =?us-ascii?Q?p07b9fNH41CiN4RLWYV2IhAZA6B8cOvJScfX11Xfk+RrfD48Ve99SqJ4qodD?=
 =?us-ascii?Q?qrhBn3gPZEJ9ojeaFOfhQbljkjByyF6aGPt/T0el7CKxkpGxoM4x9x2mnjr2?=
 =?us-ascii?Q?ghQ/Jb2hzN2jN4WU9B/EBGt9+aqakBBm5uCseri6jINEG1UHLmPBqSMoiQxn?=
 =?us-ascii?Q?9vOAqAzwIvG5N4MyA6+UiEhr2uldOsJjR691BXXdNEQJM5wh935jO22V2rg5?=
 =?us-ascii?Q?zkWk8i0pHqcdH3XK1+DePTtmsu+3xUpas/RhaIZNDOm3L9AtHG6jpxTN8q2e?=
 =?us-ascii?Q?nVtwBRD+Q97adiOVF9N2rVCCarAELiSuFS6K5nSe2O10FTYnJTaN6cXTwAmo?=
 =?us-ascii?Q?DU8R7RYRExa3eqWwRUGNrGDgaZ4190qSN6PEeOXFfk+HLwWxYMAoA+BHEw4A?=
 =?us-ascii?Q?77Pq3xamS+t9Np8fWbDYT2pWYk2zvKeI46rQNff50pOLqhO9DXf1DJlFQHZN?=
 =?us-ascii?Q?t8ZtwXaKTVy9JhkoOjq3ZK8DDiWnN2eTuEq2nwtYDfXlhBf+qDR2MAqhiIKV?=
 =?us-ascii?Q?o0vYnxAGYF/yY50vvdoCESI7lO9JuAmu3Km+K4tk/wR9QuSy4CyXOt6qKGdV?=
 =?us-ascii?Q?SCChxTZk/nFz1IDUMRfHKqhNx3j9errLvpfq6J5mcVrvb+KlxCYBlF3NvTdl?=
 =?us-ascii?Q?C9sO+Zt7/GL3YiLNbnu9LLBGgpVrr/pqA3XOVgB4yq5i/a0w7zetYWr7VgdL?=
 =?us-ascii?Q?Xdgg19yD1KGx9GMlg0QwFD4QNr1s0uQ1JIsP0aqfELpLkfagWkvgk/qIL40U?=
 =?us-ascii?Q?2uUP9McIWtA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R1hnhcCqJs9Lz/3l5+i+0aqYeQyLY4vNTmpeNc2COGvqgqjxPNeoOvajAUoq?=
 =?us-ascii?Q?AObmZ+WQVt7oeBYgO0QZ0f8queQeS5Z3I/kVRKOEJq21J85swHyAwE5ibkKf?=
 =?us-ascii?Q?tHdxA0478H1lgaUfrPwsWf1bqmSA+wmcWXJV6RD39hnNxzg9/nSJk+xEbU2W?=
 =?us-ascii?Q?ZG56GM194mX2tkNVmFxTB3HNzBlbkATBs4l+LwLRUEmV4rUEK80dDQrFdFnO?=
 =?us-ascii?Q?R8bQRa1hBYoSrk0ckMxi5g+7oseGhpXtl8KlcotqdljUUx8G2rC+eRE0O2Ak?=
 =?us-ascii?Q?mYFrgBrlWRW/lYJ3ZDqzG4I20M1JMJmcKnnwMGQ630EXipjrhKZo1aMiamSR?=
 =?us-ascii?Q?qTnA5OJp/aDKvYq/ZcL0J5oz2dtP3k0RCDuLfLN+hLqDz5CmPwinCm9uwI85?=
 =?us-ascii?Q?dn0GVFN4odjk/dxVmNaqwfT6yEcV1Mz8K+s7aSubvgZ3twMphzqmggO1OTYm?=
 =?us-ascii?Q?ETsv3LF9+ZFNP71dJr1NtbzT2ettjA+WcIMcgD25pzDVEAbTVjzJ5Vrmpn/4?=
 =?us-ascii?Q?4fs7BDdh0Y8S8JhpknmWtcBIqtznbzE+J2s3LmyhYQ4F6bpYOt59H9pMeD7C?=
 =?us-ascii?Q?qhHgKGBO9PxiWz16Kr/r8cWyLPEYxMEjXDvMFkatlP3dPbSnKwypDnX7xgwh?=
 =?us-ascii?Q?M+EMtu1XqsjbzlLEPGmKox8NOwQo4nOnTSNKscPMXv6NJu4aeFTIFMqAVE17?=
 =?us-ascii?Q?FadJA+H6opqz0e9E0yHYuKo15TVJwOrGbaboOHpOO6sIMXwMJ2qdGCSBD6WA?=
 =?us-ascii?Q?tBqiKpl+N9oXjLwwcRkmzLVDildI8EZgRDXMXIt2mk3NVKLF8U+ezM4yeFH+?=
 =?us-ascii?Q?s/z/IU8a5pN/u4NFjbpg5Cfu790KLIR/T93gSmSxBLWPficobcDQV+whDfXi?=
 =?us-ascii?Q?S/qajVEuZb+XPR01f202rJk4TNqote3K5efIH9lcK5cNoNJ8VImoHoLNNwbv?=
 =?us-ascii?Q?Bwiln8HOfDXzi+vTYyuNa7JTg8semb+/FxySDeFfBSg9K2Bl0S/z8oiVhEn5?=
 =?us-ascii?Q?bCLHE71utVurXXdYqL2GzQ4BTp6vak1MfSyDuJd6NtZR7vBga1+uvOifr7eK?=
 =?us-ascii?Q?VpOgIpFhyScCUkSVbY7uuZ+IAn+lnQxc2eWeDdIpg9KfEheKM7gKkvZBR2eM?=
 =?us-ascii?Q?UMkSyX3JTQsEV6r4oPem1bkrxfqhe5CXkstBfcHLKsXRi9L330iYfmyxLvD9?=
 =?us-ascii?Q?m9qBSOr+K7VEz0fSsoYwApYmts9mBfLEuAyjUvWrJWs++wl5f+r41dOw4pI6?=
 =?us-ascii?Q?pFUZcMT3bxr103hLwGlBuVhrn+d3kDu3TE9rPihEXR2TBBzEL13f5pGqfMPL?=
 =?us-ascii?Q?8I3jcLLcreIN/yLmqRWL23Z9Xq6Q25n5Nb9HZlo2AVEwo2sVPWOJshKms4gW?=
 =?us-ascii?Q?4DKx+17GIhhoj4nWHWsRnSlU50UgfCsAiRyskTE7tyMSj/82NH8Qir5OzFNd?=
 =?us-ascii?Q?bwphrX8GMQW5NNyKVSg8gmzqvjHMBM8hUOoUEMTnpMyAtjhI++we5e+N6ucV?=
 =?us-ascii?Q?k6j7FdtIo/fBM5aaRakXM8sZ/NjQohFTXDxj/YJsC89cbjklbUFCF4dM0WrB?=
 =?us-ascii?Q?RvT6Bcgi2EuqOEMyD8ikk0EMO0+625npqejJJy5kf8m2H0qhz5gd3ZBDzly9?=
 =?us-ascii?Q?yvn/iKnnjU1WILakolMWtbEqsqa/kkOlyjm0/RV/7xhBMlbZ+GOO+tfD2FOP?=
 =?us-ascii?Q?UUBJfg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fsu8R29arTgY+QLHkGFgw4OhfK6DB21+NEEhaBOB9qpbxrYvNx/KI//ouNL61idzrmxSZvCgZOfpKTsOLyXAJGfom51R5hblvTLc7Ny6Fg00AgmUMwnaDAKiXlkzv/IvpWu4FlyNxMucz8phC/pDvSQJUYckOYf0o5y1s6r2v2B7eKaVsG534m/+szBPNb/hwAYqLMuC3cYhvFKJ1AVqdoGqZx+INTjRwj3kSKwgjrPBR+VG24mcYrTI/kPquHVRh4MHKZlK8jBbNb6pxz3YGK3TytbJEGnS1vC5X8xfi0DvlklHcTSm+hFMZxXPRa2mwmTJlJ59GMs7u9vpLHp/sfXudvnoZfPEXu+uwIoVmz841498vC0HFkasqDGg013TGsZuhE1abKSiI92YdYVZozf1h9jNv/JRVzpGjshZBdN32gre48qrN40JxArxWxDWl2Lw3BpMay4rEejui40EUBxYd+2EyU9TeBwsAryrG9KhQVESMm1WD6EZVh/AdOmcerLC4xLLJgh6vH3UVxuyw3CEQMglrEXaSEYFTWAPZyFG8fxFxbZKxvfRuj/Xbp0D0Q2WQJ5HT5n2qTGVLK0bEpjhnlD97y93vp9o8Hw3X9c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8922a5-0759-494d-9db3-08dd973e67e9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 01:34:04.5468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4zINTm0UqQNGQMY8WrhScRJka5o5doTysHrxSNSCH/hsTzhK37LxjmrDIp/ala/mqz/Yiq6Cq7BbJdCvNjqmTBfUVOvOcC3Yrk1355j1Xc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_01,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505200012
X-Authority-Analysis: v=2.4 cv=RamQC0tv c=1 sm=1 tr=0 ts=682bdc13 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=jxo5mUw8ZoZ15m-23zMA:9 a=U1FKsahkfWQA:10 cc=ntf awl=host:13186
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDAxMSBTYWx0ZWRfXzJ+cSk7Fbkil npQ0GKPIvgAz5zpOMj0YyZk8MhDrq1TfZZrVvtUUbuoO6x9UbyGh2rJI6wdncOwzTKDhozNtC6D YTRnRp1LXg5QifxfiM1Y9gb7aX+uBrdfn4ElEfhhaN8BXK2lUivcJLzdPbK+oTqua+Z2HVNJh6t
 x9qRZJNoyHtQJZbvQN70ydvfayBBVhkyS46eqh/xTaOPAH1xgbTZfS82OVsyEsSNwZkkmRLfSga 54gZun28JiO5wSgpzUR9teR5j19Cs5xd9b3XWFnOXqwJJY6LXH/Bi50ya9um/u1q1vsukDHv4/5 stlDmPZGImOR/O87dg43WgFFwo/oBo4iAogQSNYYiVYv9v4Dfy5uNUTTKy7ptTJVsnNBwWq/Qiy
 KngBQBJTgHu262mizsM3J+8Xn8gg9M5xjX/LDfpZjWKYFqAMbVKY3v6CQ7AkdT65nYnBOi7g
X-Proofpoint-ORIG-GUID: Kanr7Z7RFr0kGn3lZjIbbBrhMWThSPjI
X-Proofpoint-GUID: Kanr7Z7RFr0kGn3lZjIbbBrhMWThSPjI

From: "Darrick J. Wong" <djwong@kernel.org>

Fix a few bugs in the single block atomic writes test, such as not requiring
directio, using the page size for the ext4 max bsize, and making sure we check
the max atomic write size.

Cc: ritesh.list@gmail.com
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc         | 2 +-
 tests/generic/765 | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index 657772e7..0ac90d3e 100644
--- a/common/rc
+++ b/common/rc
@@ -2989,7 +2989,7 @@ _require_xfs_io_command()
 		fi
 		if [ "$param" == "-A" ]; then
 			opts+=" -d"
-			pwrite_opts+="-D -V 1 -b 4k"
+			pwrite_opts+="-V 1 -b 4k"
 		fi
 		testio=`$XFS_IO_PROG -f $opts -c \
 		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
diff --git a/tests/generic/765 b/tests/generic/765
index 9bab3b8a..8695a306 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -28,7 +28,7 @@ get_supported_bsize()
         ;;
     "ext4")
         min_bsize=1024
-        max_bsize=4096
+        max_bsize=$(_get_page_size)
         ;;
     *)
         _notrun "$FSTYP does not support atomic writes"
@@ -73,7 +73,7 @@ test_atomic_writes()
     # Check that atomic min/max = FS block size
     test $file_min_write -eq $bsize || \
         echo "atomic write min $file_min_write, should be fs block size $bsize"
-    test $file_min_write -eq $bsize || \
+    test $file_max_write -eq $bsize || \
         echo "atomic write max $file_max_write, should be fs block size $bsize"
     test $file_max_segments -eq 1 || \
         echo "atomic write max segments $file_max_segments, should be 1"
-- 
2.34.1

