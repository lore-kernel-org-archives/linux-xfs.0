Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3972A299952;
	Mon,  7 Jul 2025 13:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751893942; cv=fail; b=uExRwLdgW9kbudldPj3UfS/wTTNsby2ujt7lqVrrCYB05sAjUAC6L9FVdfrd5M22oWWYKwENx6mNl0F4qiUamkpN0489KK2Tz5c2e9p6JEvKjyGjvKQWS1QUvyOlDbtZjxGPbrZhhFVdXRFMR06sJ/RtzqTPGn1oicOsXItQjeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751893942; c=relaxed/simple;
	bh=XeXM6krCUwTjUL2/IP1cbYje7Na8woqQgPDRoQjtPF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RapVusYrQH1r+YEVHMh7jP7pu4o6WuZv+c0oy4gWJK37KtULBc0/YVAdBkOZytAqi6FzmyazS9sPQIWCpH26himdTwBAaYZYLphqtLMy6Racr6lQbw4alonVaazlzc2s5LxR+yl1SDG0N1s8yVT6zMVNb4S68IZ/d4+yTE33Pvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OrJ4Xm+D; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=auzQctRU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OrJ4Xm+D";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="auzQctRU"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 567CqmK2008891;
	Mon, 7 Jul 2025 13:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Vja5hkj0qDRQ20ea1RE5uMgdUV4Eiaq3BIBUT4gZnfM=; b=
	OrJ4Xm+DHz/NeosN9q2fsSnbTdxAWOy0leZI9T+GwEJfNnN5btMdPxpc3+YQbbu/
	M2A76U35qwqSB5XmpK5st7VzlNh0gkVdWANzU9VUIp/Okp/OGPVPKZ7FYbjCTEHk
	QVBGgukR+n6XoeSQRRlBjiMRYAzIdIHcu6kNYuRAfg0JOkOzeNSWYXwgKCQRoq+4
	SONihSmz5abcSirGxpWIqPRqINLb8TUfAm8Drxx92dWoUK+N7HvSgZlSWPM3ei4O
	cARuudwP/A+HFe0Zqn1Nfv2bU2Zxpg0p0yKKa9hGbkxn1muZ00s+UynSae9Fdm76
	DC6CZtv82ui25avPwDzzVw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47rem4r1g6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:12:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 567CUxB0027228;
	Mon, 7 Jul 2025 13:12:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptg875yv-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:12:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJG1BXt6vBlTuBFcOkUCvdN5x/WkbntHgJFueuIB0C82rJ0jiEyBLy02Z8qd9zmypw10WTjVkM/E+CizFfMIhNP9Pf6zVlDcaAMazyeZ6SkD5TIuEkI5yaXHUlKBQrMHSKtV6KSv6AHksboKaeg1G/7G+Et+nBp4w1T7zmyssPrN1hNcHBCkeud5opcjxDsw3cu5iZbRjr+2+l1w06pI5P4w3x6hRXvZDFOcF71g//q2gY7Zlc8OM+EyrwwPrKL5JeHpGisrzL48I5Vy9ZgsKoKFzSiFFLCOrQpiHExz782Ku9OHBGsCkdVQ0PTVsZBj+WFXz9ZXncqQ1N1aXSOIIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vja5hkj0qDRQ20ea1RE5uMgdUV4Eiaq3BIBUT4gZnfM=;
 b=F9lTvUrNdAaepuuCxu0CV0lRLp0bb/EyfszNs8hVy7bVbNcVre7kl6OC3h/Ecz2+1v6Ek9z678KWhOYooYL0rTOcae7D8/W/+4rwbTPEritelX7Q80F+44bx/qjWjkOqUZ9B4UvgCXtFc9gwul1CHNKvOWv1VIT9MKpC1rli7fDFnI24Jj65Bl0PmJuPGYT/aey4dmDqCpHfbMgxRwJ3O6Ayd8dNm+v/nQgbVRXLgfN3k8WH653l2mp5rtvdrXpRrJb2iYuMHaqT00XOpYDP3JGfAtgMB5/BaGo5CjWrftHcLlS8/oNyXoZzxwzsvivDPF2iA/3dO5xRb5aY6d/0Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vja5hkj0qDRQ20ea1RE5uMgdUV4Eiaq3BIBUT4gZnfM=;
 b=auzQctRUjJOuL5qilGpUdGEBvFt3PaFbUm1SHtAy1HNeWKRsKHHJTbk8oMWPTvnyMdAHiTkCDVLw+YHMqH9sTDd0+/hXrUmx004qTHqpdNFchAwhTEb/kUxXmK+8JaFIXQZBOo5lRzjo1KzIroFhj7KXenfB+QYLun1G+Jp5lSk=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by LV8PR10MB7776.namprd10.prod.outlook.com (2603:10b6:408:1e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Mon, 7 Jul
 2025 13:11:59 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 13:11:59 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 5/6] dm-stripe: limit chunk_sectors to the stripe size
Date: Mon,  7 Jul 2025 13:11:34 +0000
Message-ID: <20250707131135.1572830-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250707131135.1572830-1-john.g.garry@oracle.com>
References: <20250707131135.1572830-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0035.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::22) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|LV8PR10MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: b9784cb0-8c31-4f12-bc55-08ddbd57db00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?key1MrYU3uuWoXx7ESeaTny+d6rTWXuHPV8zYHfofyZT+Sz7i6QM5OV8w17T?=
 =?us-ascii?Q?05iJe/tGCZ7ZQJSz80IOmunewykhWPFCspnN89HscqtP+BAVhASXfSwb3m1S?=
 =?us-ascii?Q?mtBfChvJCfCLHsUeKJt7mFoQfXg/OEf6n7LhzRovh4YTVEGdxxuqRs+9hKt/?=
 =?us-ascii?Q?oweYfacvw8WrSqis84oOjDqdZ2K0/F7jMwoQYLQxdCsnzBr/yZTeIBMrYyFP?=
 =?us-ascii?Q?vvDuMtzaMnmrAsjRZnsHPdAAxZ0LSX9DV5eVQngdIZQKQjdKj8wRp2BWO3gk?=
 =?us-ascii?Q?0EOxCpuP7+GSfnAjvmfOnpEcGakzLoruF9W9XBUr+EitdigILJnbpiIcLLT7?=
 =?us-ascii?Q?wBU0ASjvPt3duKoCbzjqL9Hg+FX2lDXfv/JYYMAz3GVM6uV4HwA0QTq3VnJD?=
 =?us-ascii?Q?mSOe0aYQMkDgs9rfRH9UDCgQr2/qEuNO/UrVMu96//+zlj4XUpm485VAiBas?=
 =?us-ascii?Q?SKcGGgWfy1iMHhQZgg9QQIVaO5AFDO3ASV+zf6KdqFk4rG7/wfkviuifI7hJ?=
 =?us-ascii?Q?jJwj3L5hfGu9OPEoXrfvHLID+8PmmjTA70PKNdFbrEsFJtAIvAfI0lJCMMi6?=
 =?us-ascii?Q?Tv+nTQWVcpmyrTnsV5Gg61ixFmlAQr04mbObR+aaBDdwLWGpv6WrtZRi4V1A?=
 =?us-ascii?Q?APiI2h1ERON4LU3EzUcwsIvue0Y3HDs67RSmPlosAhm1ck3P6nDy70t0EzpZ?=
 =?us-ascii?Q?4e+QRziLT6c6iESob05fZjQcD7SmrUxfQBxg7eOtxawZR5mZIK9k83AZUkHw?=
 =?us-ascii?Q?FlhE6o/2FTOvslC+X0EPx0gIq4/FoFukAPB4+H8wgbmOTI2mVcc1cSzgrhW7?=
 =?us-ascii?Q?DAHbJBxlYqm9coVZgMCuKb9LsuJoCem9ZsuMAZdnDF9rvopH+1FZFpRdjeK0?=
 =?us-ascii?Q?sNHJbW/qZVF2lcpu6XK2DucncMeqCMjP3KwgrBEjvwhgY9Po1DYFyVIc7+87?=
 =?us-ascii?Q?yx4p0tGRKwN8E64gZSa0xIvwYG2aVhRi++0zcO0m6fJjsTIblhLxjqbncgRA?=
 =?us-ascii?Q?VnxiKTMGWtXK102nbgXg01h6mWFIpFyjE08zmf7Uk6kbUDA1we9bLzuHXEcs?=
 =?us-ascii?Q?8KqbluhJDgRjHkMrWNyNMpVABebhMh/AREQSdiqvTK+5eSgOfgXriLYOPmNJ?=
 =?us-ascii?Q?nvPu0tMb/CRXzagxm7apAKCNomw3pcKEcn+tf0ucW6nuQHCnS/JBCTwxc6YL?=
 =?us-ascii?Q?EjkSgfqYk/36c5lw36iTzsKEvPT7KA/ZRDlFSyneKxwqv59KVi1hQDCQeKhb?=
 =?us-ascii?Q?n0GdycyHJVYfTEd3YeF/hszoVpc3cfAJvYjFjWdf/yDtAT1y+XY7hb+ZD3jq?=
 =?us-ascii?Q?7harncazY6zI/7vDCb06YrT4l9EGaDFMj+RKBZ/xi+RUVzXu8v+ZHz97VorS?=
 =?us-ascii?Q?4aQJ5XY9VMDXuqU2p9j0/aWYt4b5EzQ8dwfJsF9KJNFZwM2BTn3M6t96qaGo?=
 =?us-ascii?Q?5Fa1IkuGFLc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VGWHhxCgLFPqAv1U3seQ1+snPl/faVSM7Jp9a/5qsA2yZEN88jemlqYqSi0j?=
 =?us-ascii?Q?sw9QOvQwwjZ5PulVBEgHPAzMQ9MQNAU7xGk9zo0VifKj9RaKMcons/Mj4O9v?=
 =?us-ascii?Q?E/mMS5dGjvgpageWSPBXmGfbJBK9Mj0Gc7y9aL+sP3iIJ2om91tkaukF+fhh?=
 =?us-ascii?Q?LXehuLi9dIIEaKsv4P2arI5mRXgwrBTcrLTyfEvLVpOtDtbT0XquJxbo+BrE?=
 =?us-ascii?Q?6yWDOCW3woG+YM9TPn90m8nFXtk2TRVDCyzso5f1rWb36IiEZBqx6TK1nu5B?=
 =?us-ascii?Q?qf3iVNa/aUUn6tTWyr/sQcI+ttA/9czw2Ou6FkbSYbQ+4cqDsxmCiz+KnP1Z?=
 =?us-ascii?Q?cK9FKkZFoY12zU0N6NoOxssAlCu9690VP82y0X7llyqx7HXw4d/6Zjo7el45?=
 =?us-ascii?Q?m6DtZu2/Mffx2sLejgO/RsPs0n9DZifgKAvZCLnjvChk3G2Xmlk8D6tVzFTJ?=
 =?us-ascii?Q?2oknoAK1XGJxGyZLrt+QiScyg/xGK0MGDXdVbTxx7rPj5gOOJ2oTDnDviSav?=
 =?us-ascii?Q?Wj2ISncnGMb7AavUlFcyDGsaWlHLsOm9B1kvokwDbPgBAlyX7e1tzO/L5fQv?=
 =?us-ascii?Q?sz8qTSM5ZOW7ue4p0Xua4I5XfGlRRDKN4id12l+cso/48r2d4+coAEjlRTLg?=
 =?us-ascii?Q?pfJp/ZZQS/oo15UmZrZA8dXV7sw5lsX2LPY0c1cfACHw35zj16d/iQinPSxm?=
 =?us-ascii?Q?jsXQq+RmkvOu+dpQuDC325t4KYpUw5ynJmIwLMKzFk98l1dTmwzlJRpUiXRO?=
 =?us-ascii?Q?GyswHhC0k680aK0oRZVDL1z0LYC+8q0N5uIjpVuuwrXEA6bWMe8iUjsEMvwm?=
 =?us-ascii?Q?riLlQkEf7kVCJLBpx7H4rXpg4Davt3feRm/BGiuYkAOXw8AoONassbL2ohVq?=
 =?us-ascii?Q?luKCnh6ARLmlYj7sLykpGRdBkM6SR5AISCF76DDIFtOTkKzBwwR87mrlDw+Y?=
 =?us-ascii?Q?G/85lwonbAdPzBbFFlc1FxHE36h5H/R12RoV9q/3N/FEZWnjDy/yhX5msv0i?=
 =?us-ascii?Q?lTw5GfXwk8y0U9G63wQA4QmNxABHSwUIa0xdCIKoKU6w/Xd7R1ZjtY7/QDy3?=
 =?us-ascii?Q?tfhmGkcKvehB8o+MI0cy6RQTCl2ozAX6Zt2bg63cNPhSB6TLTtQZHI3wNMyA?=
 =?us-ascii?Q?KT02NGKxJNNn1CWOS/jFQC8NullNt6ay0/eatkt7Sclcid+uIOL/0E4nVJB0?=
 =?us-ascii?Q?nJhvC7RJ8Q5GFhjfpRG6xIqRekNXGyyE6xW4i32zHs9CoWtZF/8rofPf/LVC?=
 =?us-ascii?Q?BqxZ+pV8LajKqgJIYWmjoAhhsp8WIc1XfF+Lct8ROy0oGwze9FJ2E/dPTzGz?=
 =?us-ascii?Q?jYC4bPier3c9r/OW2FzktHwe7LTZxb+KJ6cOHjolP13Y6G3rBefQwbFNDWXo?=
 =?us-ascii?Q?z9h7KX4GN8kOTtbbNSXL7CUibxi8oYz39LrU9sPWku+aB4sjHLLVwLVG9LEW?=
 =?us-ascii?Q?swjPaz54bq6mkxM0T43UBcekkKuqUiDPgKkcp51nAuyP64nYzgMQGLNOCl6s?=
 =?us-ascii?Q?E6daIxTlC7qfN2kwsQiUcDkMTMQPQTOgLIL/JjqIzXAs1moCtQsQk8uS0gec?=
 =?us-ascii?Q?DscEXcZ955kVQ7bF9kYtpeCOae48VGCWqZXaWbT6GSQzytKKFD++Rhhg9uUf?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9UiuQ4Incizk0Boog9wpjcB8pYf6WNWGjjnVhzC22nTzj9M+Sw14WCZjE4btiwOo6sO9xr69tRnTldA/TUh5m60Z/IFkj5uMuW7Dx14p7UVq4cI2R5th4ASPO1UaiiCG4pgJUvsK2Mni/N1XJRGMEzrnnDXrcX4Fa04dnU+zmS4JIOFrwHpoNyLbdQknELtpa3KjfbqsN3wfXYMu+zADq54BHFGAAVsO+Ta5tBPBNs3yEi3tBX3Buqz2Sek25I/XBOogRenKu9zIniWMNM2d4HEE83rFhAn7ztxxkQToVoIJROPes5FWHAogGahWFji5SWuRvwkUgiVemFNsH5cI/WB2I6ob8Skv2+PZeyyan/ZLZogDy9E6CbfkEbN6SDtDHg0IqFFXKUOAfdhXOoF+kSSc8T7CksQgoGDugGRxoDFzebhX9CHp9yQqrw/jx8XncCoUZjJwfgDr0uv2VmeL7U6RHVHHfRanMCv/FOi1mj3h6HSuDqlmWA0R4jvT2oGIORU9/4YKLXgiAdm1IUMq5pAQQLDCxwtzV2lkB9nLnrMIpDKtoZzFvo+Ju+vyIuV6jVYxQY4+t1KSwEreC1PGUeJYqCzdCLEZn2a82sc7QYY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9784cb0-8c31-4f12-bc55-08ddbd57db00
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 13:11:59.2475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1FZWgPryjagsuAIRo0Ba9rv52PJF88cuTql11BBqb8wUP3D/jctPcHsNzm2Q1Kwuxgyt3eCePTg/c02M/Fnsog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-07_03,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507070077
X-Proofpoint-ORIG-GUID: o-VzLmvzq0Fv99xV_zBL55eKjcxAWXQ7
X-Proofpoint-GUID: o-VzLmvzq0Fv99xV_zBL55eKjcxAWXQ7
X-Authority-Analysis: v=2.4 cv=GvtC+l1C c=1 sm=1 tr=0 ts=686bc7a3 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=RkmrOqiwSQOQut1nclgA:9 cc=ntf awl=host:12057
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA3MDA3NyBTYWx0ZWRfX7cBZxK4fHcjD VmTDdhQH6pOj6tG8PLx+jWuSMxACVHeIisLUe7LOkUiVaW4uZetI81O4Sg/JsiQi7jV6yJQJ5oh X6DbNBg6UjK2NYKTLzdpzQGd1aeZsY5f0ybLo9z6HMmxDcjIdzWD7dCm7Tyj0wBEyvivTsnBRYm
 IXVe8KK8ssf5MFa+UgE6jqp3jyDGl9Vu+bPxZ7E7LDFNUY/AATa0elvRoacfkEdr72cAvOBd/Cq j/TFWBk5kTy98Cs+sVk8HYgOomrqLXIkr8oPoH62NTqfeBZnIB4A1r6+EAWsE2KXSnzIxsgeavn vxWsUP+Lf0QqoCXOYgFdCP4Lrp79FVWhtreJpiRZzm2Lbn2eGsPKT+NjzYBdho0Xb00Bb5zkB8k
 ayVtCh7/CIFMcuNth39hzkU042ue9Omr8XNFFQPy7+hU9dJ5e6FSRffiI4cvEXG1KEfaIMlF

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Setting chunk_sectors limit in this way overrides the stacked limit
already calculated based on the bottom device limits. This is ok, as
when any bios are sent to the bottom devices, the block layer will still
respect the bottom device chunk_sectors.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-stripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a7dc04bd55e5..5bbbdf8fc1bd 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -458,6 +458,7 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
+	limits->chunk_sectors = sc->chunk_size;
 	limits->io_min = chunk_size;
 	limits->io_opt = chunk_size * sc->stripes;
 }
-- 
2.43.5

