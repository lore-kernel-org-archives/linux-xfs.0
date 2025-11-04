Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCC728BAAC;
	Tue,  4 Nov 2025 10:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762250931; cv=fail; b=i6UiS74eAaDJrc70TciamHoucbmTexMCK2DTV3LomK+ljjg3EOW0rLefuqe4I9np9Zqm47iatTV0aaLKr9nsWCZd0T+VXUwYJiLI3Je9j/8JSwmgn/GPpIxl0TLbvO8t7lkCYjhBs1t9lWWLtPS90IbCxSA3wJVx5oDgOH0vCnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762250931; c=relaxed/simple;
	bh=0jzpCv9HU/GVEFjinntRQV91YMu33yvwXjZMFW5MO80=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sKzPfmOvTwGrXxWQDnuGs/+9YxeYWBp4MAnMO/gK9mYO770sMU/HdfEFmDbPLV6z5SUPF6iIeoSXtuEloiev6J4f4IooN+bZXLJ3c8Lw74hcCxsSSxsSnjER5ubp9uXznFc1doU9u63HonKSD/omXGqqVUbnQzCdRU3IzuaBZKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CFn0aKgP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HWvOltJA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CFn0aKgP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HWvOltJA"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A49tEwT010132;
	Tue, 4 Nov 2025 10:08:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kKkJgM6m4lUx4Uxg6KQ+axZqc2TgTQnK5N3Nm+ejFEc=; b=
	CFn0aKgPkEmW9TR6X5QbdsMVCSyNj8H2s+2G0DJ/+0bgn+oLha0MMP8PVMJ+2DXn
	ydfUS/X9RMU70rXrZjuQzh38nVI09k0FVcIj+BrXqshCxP42/JQFbabuHg575Xv6
	WRMv+qItx5tQIJ3aHSxvcJSiaD1upp3VBh5djmnZ1UO4yxgP2Gd/RRCWBIPXCI9A
	kdRAwxJiqkanEViGN3Q3ZSNk6Ki7pBrt3ISMYUNKaYSt/63aOQgXfEmWd4rWpFMX
	/6pvNlHNPGZJztRsiuSThJVl5hTjpN4eIy98gSrBcpNpg64MIORCAynJXAB1juTP
	xQFoESBf2Hpz+j5+WSQfHA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7f9er1pv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 10:08:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A483MpT015032;
	Tue, 4 Nov 2025 10:08:40 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010066.outbound.protection.outlook.com [52.101.201.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n94vb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 10:08:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aC+COSqd9H3pNDrC3hI6i0QVy1gswENr2tOFztTL+aoqH6khSgLMZfZl0Srls4qJmmuojRP1PVgytGDR4T4/RsL5kFI2uKRHKEvNxSAdCvASuz0ob71VBHq4hQFh+A4UqVkhW+MgYcj5ZPC6d9uy9sMQ5Yrnwv2Voljy2OrDlcEYjgOEzsKFx4neF8OhTuEv/Y3JzjwkzLl9MB9PhSyOv1AI8aHD94ozOsUXeVxBP6ABmoZx0blHkyy2siwhK5FCe2LEkQZ+QUxhayoNnksTOKKTKEySgGHeUvHdT+5bl8JmGmnv4u+c7JA7z51DLjs+sCJFuGurAUDX0bXWnaTNLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKkJgM6m4lUx4Uxg6KQ+axZqc2TgTQnK5N3Nm+ejFEc=;
 b=dTJMnVsFL1NlM+hU/tFXo0loocy8iA4YjS2d48ZP7qcKtiOkN3rMH2/iR13l8B6Zu6J3f9NpbAbLljVv1/C4l6hmqODMnvK3jqixHTItXfyd0xG79SML/Xg2UrL6elRMShUChytVj1Zzis4F1Ma/qQHdmZQC0pnKJ/3W29LXJVWA05hFmzKF88t2lG37OfelyqUpgFnRAupvzyxkT0EuatwbaVirzG4APHxyVEN1eyG6EOvvN52d/at6kr9osa/aKaX/jHiPSk0cA1zvH1WBA50LxkMvATtFlHqZD52a8F+fknrcMg+JWInuvor3x4ADytwpdOnJGYy3zw/2MAQJIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKkJgM6m4lUx4Uxg6KQ+axZqc2TgTQnK5N3Nm+ejFEc=;
 b=HWvOltJAd8hBRwxhbfuJYMiNzF+EED9AubtYF6wuGNTh4HGEGBa8GHlg0N2TiCJAJMLv7a8AkfUy4Zl/V6PtnwOP/Oc2xx0jd69hpt1eXQFOLOZOTe7siJhmws0M0cESx9/pC/v3SRsHug2E6a6TJNhTavwbd7/T2xTS86RHYNM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS7PR10MB5104.namprd10.prod.outlook.com (2603:10b6:5:3a1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 4 Nov
 2025 10:08:12 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 10:08:12 +0000
Message-ID: <cb1f1963-8ca4-460f-b620-6026a26ce9eb@oracle.com>
Date: Tue, 4 Nov 2025 10:08:10 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: fix delalloc write failures in software-provided
 atomic writes
To: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zorro Lang <zlang@redhat.com>,
        fstests@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-xfs@vger.kernel.org
References: <20251103174024.GB196370@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251103174024.GB196370@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0051.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::15) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS7PR10MB5104:EE_
X-MS-Office365-Filtering-Correlation-Id: 71630038-b6b5-48dc-7a23-08de1b8a101b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3BMakllVmRVc1l1b0hyM1JlMlFBSm9SVVV6QXBUOWgzQTV0cUkrNzBHbitj?=
 =?utf-8?B?Mkp2M0NYRmtJTFlycmxnMy82RWN6dWxLeXhka09GeWF5a1BDZGYvRmxjTTZu?=
 =?utf-8?B?cnovS1V4M2MrQjZMNGFJdmtINmtoM1ZuRHB5a0QrQUcyMjlyOWtHUGNSQ1dG?=
 =?utf-8?B?MUJUWUo0bDRXNnY0WFZmNGFyUVN2a1RpeVoreitrSGl2K1NIZUFBSjh3MGU1?=
 =?utf-8?B?Y3p1cVc1L3hGZ012UHNneW9hTjh2MXA1UFR4STluMmRTS0VXSU1vZXRnUUpt?=
 =?utf-8?B?RWVMQWREMURvdC9QL3ArTll5cWZybk9pWXlHVUg2bW1CUm1ORjM4alkyUDEx?=
 =?utf-8?B?V2ZjWFQ5eWpoOGh3c3lmS09tTHFJMUFLT2p0bDNhSTFmZUVWYW01MFhQbnJZ?=
 =?utf-8?B?R1YzTERQTGJDUjdqZWxtY1BMNFM4NlRXWXlGYWNXYU12OXlHUXFZL29peFVF?=
 =?utf-8?B?NDlZWjJZdlBKaWJtdU5CWGUrbjZac1BzTXJ4MG4ySHR6K0R2RytLZkxuNzFB?=
 =?utf-8?B?UXlwZlZSNExwYlZwRTZCek80N2ZFQUNibWg5ZVJObHR4SXErc1RacGhUMjZ6?=
 =?utf-8?B?YS9hS0NwZ1NyVzhQbjZrTlhJcDE3NmN2WGR5b2dKdW5pcnlCMXVhektzU3Zt?=
 =?utf-8?B?S0cvREdwSmFRVndEbHJJV203VTNIQ29PV1AwWlRjTFhsOFNvVEJnTCtrbFY2?=
 =?utf-8?B?QStDL1VHeXUyTXVhVmROdkp5ejU0RUJPTWFyMXZMMFJCTk1SU0FFcnNEM2Va?=
 =?utf-8?B?QzlFWVA2YmpKNlJhYkNLeEFJRExodHJJWm9hUFM2V3ExbGF6alR3dmRJRkxX?=
 =?utf-8?B?aFhURVQyTVRHNmZQNTl5ZEVBcjJrRW1ONjJZR2N3ZXMxYnlJb0JRbmRzLzNy?=
 =?utf-8?B?R0ZYSWYrWUhoS3M2VHhLd2x5ejhxcy9SMFlVakUxNXJxVjAyZTFBU28wL2xj?=
 =?utf-8?B?dTROVHptSmdJcHdGV3B1cnllZzNVZEl0R0kyZGtIUzdNNHM3bDlJOXl5OGFn?=
 =?utf-8?B?aTVMTmJYckJvWGZQQnlSZlVjTlZ4OHhTTngxTHVCMmRHWEtyYVYvenlGNzdy?=
 =?utf-8?B?TGh5NEdmcEJoeTdxWUJBUW1lRmNiYVVOVjhCdjIzZlFwVEtpeml6ZUk4bG1l?=
 =?utf-8?B?VWdOQ0VNOHp4eXNtOFBQazNXbmdVLzFveXJ1bGVIT1I4QjNoekV2UFZuZHZR?=
 =?utf-8?B?cVhzMDdraG1LQVdTeVdEUS9ObGlBYmJsUDFvWHJ5NkRyUDdoVUpFcGZoc1Nx?=
 =?utf-8?B?TXMwbENXUmp4VHBRK1hWdzFWdHZLN1NGSG5hWnBFd0s2VUw0aEpEdzM4TW94?=
 =?utf-8?B?QXp6YUZSWW5sSVFqNWNhU255cUlqZFJqMU1ReG5lQVI4SnBlNFZhQ0ZwQ0Fy?=
 =?utf-8?B?Sk05bWhOM3NsNjZ3WFgvNmpnZzVOT20yMEl3emdoamJTMDBRN1YzSUxYdkZR?=
 =?utf-8?B?UkJBTTVWWVYxOEFxREt5aVRiaUcrOFltMDM2UmNsbVMxZWZWcTVab01Iay80?=
 =?utf-8?B?VWZ5LzUzYmhxY015ZDU2YWxIQ0kyQlpzbnB4UHc3eDRhNlNuMWZGMlVNVjZj?=
 =?utf-8?B?ZGtQM3Q0YlZPRngrUUtmNDVETkJxZkxRNVd0NHI0MEkrMzBaeVJnRVp1bTJN?=
 =?utf-8?B?S3Nzb0hIWDRyTmVZR3VMU3VKU3dRLzFCeTltUE5zaCtLenI2cGdRSXZzS2Z5?=
 =?utf-8?B?VUk2ZVdkaURyM0NaL3hWemNGWGx0VEhSeW5tYXRGQ1p4blFmMzV2SUMreXd2?=
 =?utf-8?B?U3htbFBMTjF6ajRFWVNIMTVqRVh3TDlCeXdmQnFVcVErNCtEZDVzRFZwb2I4?=
 =?utf-8?B?akRXaWcxUi83WjJVbml4V1h6bjZyclNzYndwUjlibUhFSlJSZUdQMDhRK1A3?=
 =?utf-8?B?NFVjM3NxZDY1Skt0V2NQelBvRUdNQm1xUzJPRlI1bjlFNVBqcVkreUJzM0N3?=
 =?utf-8?Q?xmPu0QSk1mL1TxrfgNrftDPylnKdi4y0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b09KVXl0Q3ppUkpZdW0rNkxpRC9abEs2VDBnbG8wTHRQSnVhSnJURkhoZTNo?=
 =?utf-8?B?VENvK0FtVGZQQjRhTTFZR1R2MVhQTkczQndHa2RNUE9pTGU0K1h4eWtKM1NQ?=
 =?utf-8?B?ZTlPR0RhYnV1Q2UrNExuME96MGJlVzRmRWcxbklFSjB5clFSV25OQmdxUEFH?=
 =?utf-8?B?ZlFUSDZ5NE1PZCtiU3RRQnZhTFVwZDdUU2FIYkJRVWtDYm9ZRnNqbEFhb3ZM?=
 =?utf-8?B?RFNoeEtMcThuRHk3L1NlbWN0c29WTW04OHFLamduWkY5R2hNcTFUVWd1azBV?=
 =?utf-8?B?djFwNUNJbEU2eFpjbndMV1RGejBNNzY2NTE0WkMrWmtSYVUzVTR2aVpvSjN6?=
 =?utf-8?B?OS8yeFRJSTZWV1AyS2VhVU9DNG80Ylh1OHY4MG1HeUVBZWxkdStXMGhJZGpH?=
 =?utf-8?B?TkYydGRtUUEwSEtyMHFiVU16QllTRmtuUUF5cklZM2Izdk9pY3FmdksvMjl1?=
 =?utf-8?B?RThOdlhPT2Fxb25SMGtCSnZmVzQxR2U0SHdzZVhNczhRMUNXRFdKRndlWCt5?=
 =?utf-8?B?dGZLYmVUNjVMS1g2bnpWWEt0c1hXTHVxdWg1dDlXYVNteFFocS9JZnFiSnhB?=
 =?utf-8?B?VUNYTkY0NHBrdWx6UGJzRHpGS0V0TnkydHlEWFRXQURRZXZsQzdsSXN3TnB0?=
 =?utf-8?B?M3FOMHhrTkN5MVdZc2VKMGp2TlQ3WklFRFJETk9oTUtOVWExUTVsblNmME16?=
 =?utf-8?B?cUl0SGZDcVh1eTAzQ0VFR0p6SHZpZ1Erc01ZU2xqUm92VmpFM1llUytmcG93?=
 =?utf-8?B?UmVLYnlQTXhxa3hWRnRzYWwxVnUyNUw0NnZtSUFGZ3p0dVJNT3NOaUxZdDJj?=
 =?utf-8?B?ZGRINWxZUU9UdTNPRHVwQXEwck96S25ZTXZpSDdkdVVZUlJiZWJlcXVoMkJ6?=
 =?utf-8?B?OVdHaExUSWxMV1lKU090Wk1EaUNON3BmUE1sekd2aWFMNHlvZk5yQnJqOHRj?=
 =?utf-8?B?YkRxK3FlNzJkS3dUbUZmazVWeS9xcXQ5SzZCZmZPSXZOcExGSzJ5bGlXejl0?=
 =?utf-8?B?cUk3UUIydlRBUmtNVDJab1ErOFpyU2pzL1Y1dGFadkp6bTVEVitVQTVVcjla?=
 =?utf-8?B?THdoT2szbHNCUnY0ZEVlZWdrbFlzV25SVDJ3K3lmbS9NMGtpTkdCL2dFbHZW?=
 =?utf-8?B?RGhNSkpyczF6U2VpRmljVkZQSmllYjM4ZHQrWGhucHBlYnJhWDFvWkV2SjBD?=
 =?utf-8?B?U21HWFNDaG5USmJQOUM4elNoN0NUQ2gwR1FPL0J2aTFBMVFzTkJTdlU1UXNM?=
 =?utf-8?B?b2xQUzQzcHA3VGt0QTlIRUx2YVd0Y25jbEk1NkQxUkg4Q2k0eis0MUk2YndL?=
 =?utf-8?B?Y21BMzZNQlJ1OGpxY2c1WFNEQWVtL2ZsQi9tbnFTSXpFSGJyUW1kSE1EMy9l?=
 =?utf-8?B?TThFbE9KM3hBM0Y5blc3d1RJMGVySFZ5WG4zanhzdVI1WUlyTkIzdkZaam14?=
 =?utf-8?B?dzdqaWdhWGdiQkVUeDVUbThLalhBSkQydjk2TFVCWWdPTnpOREhKR3RONkVy?=
 =?utf-8?B?dUh0UUxwYlVOVmVUcVRKT2lVcGhqWHgwRlhPakxOdjVySzFwYnJ1d1VFSGRW?=
 =?utf-8?B?aWl2cDEwR1F3Qk8xU1lIdUJIUlJacXJzYTlJQmhkV0ZGditsNE9IOEFmUUlN?=
 =?utf-8?B?MGZjdlQ5dXc2bTI2WXhhcjVtTXN1cXNNSE5KcDJ2MElnNnV5ZXhQc0xNeENx?=
 =?utf-8?B?NGtpZzFYalZJdUZBVUhaZnFUSk5kOEVibHU3TW9KanNlWmF2cldjLytCTHVh?=
 =?utf-8?B?cGxPSEFITlk4ekJRaEoyd013d2laWkJsbHFZa0pkdytVOUVoWU1ucm5zODFR?=
 =?utf-8?B?TlBIWVlyYzlkVTZaZ2ZYR2xPOUw1bmROZ1g4WGhzeEIxdHpwTFd3R1RabFFu?=
 =?utf-8?B?aWVOeUROYVJBMlZzS21sNXpJS3lWZmdraVJQSWpjVzBXOE5UV1BBdm1kT01P?=
 =?utf-8?B?bVdIcVlNRFlzZHFnV0dqancwSGFXOWw4VEJzeXJrMk9DWUQ3bEFjTlBmei94?=
 =?utf-8?B?Y2h2V1lWbGQ0Z1Q5S1k4N3RUblVVMmpaYlg0N3ZKQkcyYUI0bnRoVDcreG91?=
 =?utf-8?B?eTRiQmd2b2pnZThKYVRKc2Q5NkJKaExpMUdLTnZUc1VpOE02RHF0bmpvV0Rs?=
 =?utf-8?Q?F/9sWcr2DZgqNgmAxIxbmocKm?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7XoNuMCE8/AekST4uN7eg1J+m3MplBFjVaiG97uy2aq5hjs92ys4O9QmZE1reqfWoqnfuBuPaibwgzSUfl3rZt0Sigsc371kxTuca9Pvbb5/WygDCW4R7uZ245CfqStFJucngD6Es9dl3FUORICFuAQe9H/YGSGroETzd7GhUemt2zgYwOXdQEHAs79tCry6thvnfK461u7Vajk3rr9eN2ps0IicATnF3SMwqrafZ0paB98OydA3nTfpBec38sVBCBbaMrVnJqZdj5aXgpqkV5iAM/D8gsd7Uc6kYpHiKuPwAHFTt93xaC7QOYC2GrLeVW0Tfwa2H6yIUIwwjDu2uKtrS7JWxaYgwqSoecJRS3OOvwxNj189GJ30uU+syf+XPrDB5s3JMYUxPVrM+PXyt1OYF3xVXetNbZcKKsziHh5jEfa4YDGG4NJhfJtlfSV/wVYbZfZbQtwPDF/18y2WK0CzbVpslrpvXnDsXBeauJdzyW6X4+csBGMm/wuP+ruWRffMFGPFvaVLIFPw7tGBciIjjvME0UEkuQqv0MPufsYRAwvKs8v1XbnvzxGX7payiKVuoz82GL2fpkfBItYtWS8wHE9Uixf5VqEgXtz1KRg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71630038-b6b5-48dc-7a23-08de1b8a101b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 10:08:12.3892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qQc7Oys/a/CY2oIO4ViCpRUVG8UsCuGIGtDx2IFQ/QK8c0GTR5bqhUtuwSjY6PRXRG4ORM5rBWe77CFIq4b7eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5104
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_06,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511040083
X-Proofpoint-GUID: 9CGXBmiNUBDYUxJZXylUsqktCGBL8k5c
X-Proofpoint-ORIG-GUID: 9CGXBmiNUBDYUxJZXylUsqktCGBL8k5c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA0MDA3OSBTYWx0ZWRfX00w5JwwGguSM
 UbRLaNm9Zp2MTBlYO3xDEr5oN3VZ1+3fwppDMMjr+0i+u0xg0MbFTplycNgF/kAHIUxV5b86TXo
 WxLJGbSoMvb5HagLMEKyBFt1ucDlERWYL8p9zp2IXr5uuiBJqpj2hg2PNbifk6KEfc3QWFGl7MS
 Z3H54+RfyZbHnd7OyiafzuqjtAvbLPVE2HQIbRHo6/X7XHSmoOJnfHcwdYL64MqKZnmXvqCPLJD
 hJ9XVgTkYeoZ3gZWndterv2vntAyCuqPld1sh7lV6ImSFS08YXJ7vitBM+3gdntOeifHo6Rme3D
 oa+HEL/BqwXFud4tNFYrcSZUc58dRnDmgHEj7uZnPOsb1kA1Xhq+AAlr/gaDEDvS8znwMvC7Z9y
 qbLJmTNroDO38LogN1Bo99Egdsbuzw==
X-Authority-Analysis: v=2.4 cv=Os5CCi/t c=1 sm=1 tr=0 ts=6909d0a9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=I_7oYbkV-FiYGLY8p5cA:9 a=QEXdDO2ut3YA:10

On 03/11/2025 17:40, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> With the 20 Oct 2025 release of fstests, generic/521 fails for me on
> regular (aka non-block-atomic-writes) storage:
> 
> QA output created by 521
> dowrite: write: Input/output error
> LOG DUMP (8553 total operations):
> 1(  1 mod 256): SKIPPED (no operation)
> 2(  2 mod 256): WRITE    0x7e000 thru 0x8dfff	(0x10000 bytes) HOLE
> 3(  3 mod 256): READ     0x69000 thru 0x79fff	(0x11000 bytes)
> 4(  4 mod 256): FALLOC   0x53c38 thru 0x5e853	(0xac1b bytes) INTERIOR
> 5(  5 mod 256): COPY 0x55000 thru 0x59fff	(0x5000 bytes) to 0x25000 thru 0x29fff
> 6(  6 mod 256): WRITE    0x74000 thru 0x88fff	(0x15000 bytes)
> 7(  7 mod 256): ZERO     0xedb1 thru 0x11693	(0x28e3 bytes)
> 
> with a warning in dmesg from iomap about XFS trying to give it a
> delalloc mapping for a directio write.  Fix the software atomic write
> iomap_begin code to convert the reservation into a written mapping.
> This doesn't fix the data corruption problems reported by generic/760,
> but it's a start.
> 
> Cc: <stable@vger.kernel.org> # v6.16
> Fixes: bd1d2c21d5d249 ("xfs: add xfs_atomic_write_cow_iomap_begin()")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   fs/xfs/xfs_iomap.c |   21 +++++++++++++++++++--
>   1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index d3f6e3e42a1191..e1da06b157cf94 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1130,7 +1130,7 @@ xfs_atomic_write_cow_iomap_begin(
>   		return -EAGAIN;
>   
>   	trace_xfs_iomap_atomic_write_cow(ip, offset, length);
> -
> +retry:
>   	xfs_ilock(ip, XFS_ILOCK_EXCL);
>   
>   	if (!ip->i_cowfp) {
> @@ -1141,6 +1141,8 @@ xfs_atomic_write_cow_iomap_begin(
>   	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
>   		cmap.br_startoff = end_fsb;
>   	if (cmap.br_startoff <= offset_fsb) {
> +		if (isnullstartblock(cmap.br_startblock))

This following comment is unrelated to this patch and is only relevant 
to pre-existing code:

isnullstartblock() seems to be a check specific to delayed allocation, 
so I don't why "null" is used in the name, and not "delalloc" or 
something else more specific.

I guess that there is some history here (behind the naming).

> +			goto convert;
>   		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
>   		goto found;
>   	}
> @@ -1169,8 +1171,10 @@ xfs_atomic_write_cow_iomap_begin(
>   	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
>   		cmap.br_startoff = end_fsb;
>   	if (cmap.br_startoff <= offset_fsb) {
> -		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
>   		xfs_trans_cancel(tp);
> +		if (isnullstartblock(cmap.br_startblock))
> +			goto convert;
> +		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
>   		goto found;
>   	}
>   
> @@ -1210,6 +1214,19 @@ xfs_atomic_write_cow_iomap_begin(
>   	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>   	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
>   
> +convert:

minor comment:

could convert_delay be a better name, like used in 
xfs_buffered_write_iomap_begin()?

> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	error = xfs_bmapi_convert_delalloc(ip, XFS_COW_FORK, offset, iomap,
> +			NULL);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Try the lookup again, because the delalloc conversion might have
> +	 * turned the COW mapping into unwritten, but we need it to be in
> +	 * written state.
> +	 */
> +	goto retry;
>   out_unlock:
>   	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>   	return error;

