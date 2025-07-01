Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A67C271A94
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 11:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751368157; cv=fail; b=OHsycndqI6aDB2Ct8lrXPshxxruXBDkRnbQRBXlM4LcETX8/JB5DcEq2cR+2keoB5khOZ1Z5aks17TakIOZpO7Ocw58NQgoQB1vYTWe099vTc3gbG8SY7/pQ07bMc5v6MFJJhHmicJY+EHgUnySMXLMdBWnKYWW+IHZRZRGqPYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751368157; c=relaxed/simple;
	bh=I37mYUVaXv9uaYIKIivYJaHwfO+WbXAPfrElx6REpnk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iSeHPZLgkMn7z4Qgx9pHc+qwC2+l1KvXQoKx6AAlg6FCbTjZqgqf8r4lfSQBuhY+L0+RX5kx8asYos7K+1Xvwm/vm+tcRQTHqazf3oMetHJMqc5nN0P1J29P6jX89180cs5xep8IzQQiW1A7AktYp1tVNeig5eyMMu+mhYU8OZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fOzFL0Ap; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FeRDvdMs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fOzFL0Ap";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FeRDvdMs"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5611Ndbx006788;
	Tue, 1 Jul 2025 11:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PMEuwtmNinQUICr8dceSDwR4i0ByTkm42jQ1xWh5mEg=; b=
	fOzFL0ApzBlViAQNFPKJi5FqZdOQ0jrYWFTSJUYoxeHaVgzxJSVIX4PS7J1cVePj
	/RZoUiwCMRuntMMdNIFOEej2LXekFpGVq0acNM6biJoO9fUpXLoKzD53X2kvBm/Q
	7MdAFLmrglefWGnRAIfVDqY8+zhXLekV05/ppbCL0VpJJtDQsAvTt4I1dod8j6nC
	gdaNL8LiLkdDyJWUkTsP50qdeAZCZYEktjADCjet4zbhBh7+KS72KZj8Xr/Hncgp
	FAsl22NzoLkECV6Ycal0kc9epa6q1T9vv01k5LavKedYQH93pbdgjRdL9i5jS11i
	0dZ2au9qzGNPG1R+LO4YHg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47jum7uu0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 11:09:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5619XiHp011487;
	Tue, 1 Jul 2025 11:09:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6u9c072-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 11:09:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HUM40KGoJkcaKmyUWRvi8hvGEMvRCFMpclXp6Pa6svRmu5bPucdzeA7QVMaMRa3azunLHklF6lNvlsxKeZ9u1QuJf0ojX6o0SrHdYS8UXvjV92XodZPlz2YUsb5/rKXJGzoersiL9+5R66M9sASynwh0JI71Lupr5IHee5mscSQZtaPinacsFAorBWyud+lWxeHg6RuvrxtJOmhcsSo6QaKl1WltkFzgbB7RHTLorIfobbpFUPlZYQ4E3zRVjoaTOE+oYsMHnv9tVU98pwtmZ5q4Xs86+64ttz7KmSK+H7zgo/xz/tjaFb7Zr4SSdE0eGDcMRUFkW/TvTUdMGikXSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMEuwtmNinQUICr8dceSDwR4i0ByTkm42jQ1xWh5mEg=;
 b=jJvwWWugjp9w8UTnEs+9J2Vgx3kNHFjwHoXZQkTkv9ntTJG6gkGBQpQ158+6nUXm2ch9YZQK9gt7Ifo37uLtJ5cja/M7G6W6Ipk+/UNzCmXriVzSfkjUq4KC4q0ygIU502qXXszf5IeyEZjJJTMkgJF5t8PEb0PfyJyS8feiKRMHqL4KuXql6n9qoxkyVYdFYr1HNgkwH5iuFVENgdXWQytJcYnp7nKWxy7qO5M6xXn/tm0bhGzyemTI1ub02NyoXkzMg4gRco1zYpJyAFOnd3FKW8hFYH7epFw5XtBiopxyV7t2Bo4YYDpWOXaN47uYBpxnmoteE+cxgcjiAKC+Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMEuwtmNinQUICr8dceSDwR4i0ByTkm42jQ1xWh5mEg=;
 b=FeRDvdMsm4jr5emYhEGEo4SxLueWPakdrWH/Vk/oW4ksfdKSxZqR5KerpNOfUW1hqC3wktkp/gm73jFBQ+gN3m4GUinqu+/2KCqKmG6Qv1vmZyuRJ96u95LHPRmoFYPqTbLyK3X+RWcAi2TRdDQ4F64qA3anpLgWm8vk8xTYVCI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS7PR10MB4990.namprd10.prod.outlook.com (2603:10b6:5:3a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.32; Tue, 1 Jul
 2025 11:09:07 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 11:09:06 +0000
Message-ID: <d97a3fd5-5697-40e1-ad39-e377b2ea489c@oracle.com>
Date: Tue, 1 Jul 2025 12:09:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] xfs: remove the bt_bdev_file buftarg field
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250701104125.1681798-1-hch@lst.de>
 <20250701104125.1681798-7-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250701104125.1681798-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0192.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS7PR10MB4990:EE_
X-MS-Office365-Filtering-Correlation-Id: 78de101f-0228-4be0-7e83-08ddb88fb1eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0p0cXdxbVZhbnhDa21mRjdVK3N0MXZoVElhUTJEZXdPbmZLd3lqUHJScGhx?=
 =?utf-8?B?OWhEUFNEMTFJSEJkWjJZSXhsQ1pSYjNNZnp4dzdDem85SUhZeldyMUJ5Q2RQ?=
 =?utf-8?B?ZklDOS9NSDZxUXA0d3RDbHl3VlVDbmtGMWFnMVRHSHBQQTRoMXhvSXVETCtt?=
 =?utf-8?B?MjR1c3h4dDNEK3kweXhkQ2JSN3BVekFpaVBaN043SFdMVXVqMTYvRkRIMng3?=
 =?utf-8?B?M0FCTzhkZnRFM29DS2lmOENCcy9tTWg5UjRuZTJmVzFwbEY0cStaejV4SWZG?=
 =?utf-8?B?Y3FkWW9ienA3djR6M1RId2RhbzZCVXk3cDRBbC8ycm9scy9kY1lDR1dOZWhD?=
 =?utf-8?B?THZGVCt2NHd6NEtKU0IwQVlBdUo0Sk9YYW1XamNUL1RXRlg3Q0xBTk5vcDZz?=
 =?utf-8?B?VnVxMFNGN0xOTXN4VEd3dHAxWmx6S2ErY3VDK050RXdJZTBRUjN5ZmMwcWZn?=
 =?utf-8?B?SU9PcGhBOThoaDlUZEpaVEltdXNIU2w2VGJ3UzN5VzNXKzZTTjRMU3U1cDhl?=
 =?utf-8?B?MjQvbEVybkE0YVRucStlUUNHVHpHV1JYNjRORjVYcXR4OGJ1UHZHeDBDOG9k?=
 =?utf-8?B?UnorL0hwR3hpaWdWbi9vcEpuVCtkeTlVTi9UVmphamoyRmc5OFN1TThOczVN?=
 =?utf-8?B?Z1FTTDQrL3gzTDJ6a2RLa3FqZ2VZQXMyRW8ybXNiQUp5dWMzSDZjNXJjMHlq?=
 =?utf-8?B?TTNWcURRVFVhSE1DdmZoTXBIc1dsYzlOYWF1TGZmRjN5R29hL1ZUcUl2RGJa?=
 =?utf-8?B?NS9YN0lzOXBzdHphamRQQUhKelBCcEJmTE1tVmQ3eXA4VHJlRlZCMFMvZFAx?=
 =?utf-8?B?TkIxRS9pSk5TbithY0hVa1RFWWVxSGIrOWZ3MmlxR2hiUUk0WjBvcHhCMXZS?=
 =?utf-8?B?UTVxRXFkNGV4cVppWHN4TytISkdEQmpSOUYrcytBYmJ5dWRjRW1ObmNpdTc4?=
 =?utf-8?B?RGFJNTlRZnpyazVJMENyeXpQWWlMbUtHb2NWenp2ejhzRGVTQ2d3WnhmaXNF?=
 =?utf-8?B?OWUwTXRIMHdvYlYrMWVxQzFaWm1TN05PRjVzbnorMy9rN3hRejBKMGxEa1gy?=
 =?utf-8?B?ZmxuTk9GandQaUs1cFdaayswSUlsUlBsaEFJWllqU3M2Y3ZDOHN2YUlacDJk?=
 =?utf-8?B?ejJFTnZzM1huL2tmRGY3R0s0QSs1ZCtYZnB2SENIOTlpdUdXZEs5L1pUQU5v?=
 =?utf-8?B?Z1pCQ3RhVG1PSndPUWFuemJHYmwxVlB4bkl1Wk1mRThqQndLQU9EMkpJaHMr?=
 =?utf-8?B?d2UvbElnOUlRckFzRDhyRkhJWjFZcmRjanVIalpXdFIxT0kwZDg0c3Z1bzhZ?=
 =?utf-8?B?by9wd1dnSG5SVDd6a1pkM1NyV0JxTXpEZDFsOHNWZHROajJLNXNsdHUrM0p5?=
 =?utf-8?B?NFR4L3hpNS9KUjJBRUVsZzd4OEIxVFJGM1QyMTdlazlaemE5QlZlOGUrTkNz?=
 =?utf-8?B?eEJPQnBBOGFnSzYrUnA3TS9lOWJkU0hsM0RxR2V6YTdRNUJaQjlCRTJpWmdY?=
 =?utf-8?B?WFlBamtKZGllMFFsUzRUaThQUGJyYUpYZmVqUWFCeWFndTBQR2lRQlM2QllB?=
 =?utf-8?B?Q2NoNnpwVzFSNWdkSVl3dG0xSjFsc0QvLzNxN2hzWTFncVAzc2V2QjY2dkoz?=
 =?utf-8?B?dUhmWHgxWTgxaVZDU3dlTU5EZDJLenNMT25vRzIweUVLMG5TSElOSDUrdHov?=
 =?utf-8?B?T0Uvakw2eTVKNEtFb0V5RHRnZWV0dG1jTUhaS2FzaWpxQ3FUSG5TWUZkTGMy?=
 =?utf-8?B?VmJzY3d2MnVQbXdwLzR4U0p6NlhiN1RpcnVDVWJORW0zczhuMmhzTFZVamJS?=
 =?utf-8?B?ZTZzdi9kYmdzVVVLbmZIYWVyajR5SE4vNlBMZzBUMGhJeWZ2UTdBZWRsK3B1?=
 =?utf-8?B?b09KcSt0Rlo1ejNKTjE1b2xUaGVudUFrZEZqQkY1amFRWU5jLy9QSUJwR0x2?=
 =?utf-8?Q?+2xXCixfKfc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkhJcHd6WWdpT2VWWkZuRUZyTkR0Nndic1FndHZMRzRJb2M0N2FrVVBWSng4?=
 =?utf-8?B?ZHdXRW9NSzRCaXpWb0Y5cG5NT0k5ZmlQNHZnRFg1MUVhamRXNXdOM25TZG5a?=
 =?utf-8?B?MUJueDN4NUhXN2x0OW9FQ1hCSHpFL3NSL2xjWnNvRnB3RVVucWUyK0EzeGtz?=
 =?utf-8?B?ME1WRnFjZDZNb0gzd2FWTlJtb0F3NHV5NDhWMWZWUnVrNW5BT29jbXdVaWky?=
 =?utf-8?B?V2xvaWJXSkZXSlYyblFnaUFtbzFQNnJ1dnJwNFdaUFc1aGNUNWpxZ2pDM0xO?=
 =?utf-8?B?clJjVWpOYnk1TW4yc2thNDVGT3Y2VWdkUHMwQlk5bjlNSE94Nkc4MjNPaXVu?=
 =?utf-8?B?akl4bHROVUFNUmV1enEwM0pldmplK3dPNXhJZFg3RTVGSC9pdWdRUEw0Nk45?=
 =?utf-8?B?WHVjdHFVRXYwNDlLZXF4QVZnWVBJdmpjajZpNDNoelV0WlJrWnd4MWR0aCtD?=
 =?utf-8?B?ZVRXSUZWbGVnbnlBVEZrWExGVW1VVWVoZ1VpUHpMTmJCU3dIdUp2cS9XeWhq?=
 =?utf-8?B?U3ByWTY4Mm50SVpCQjBuOTRxdDRoTEF2QUoyNkZJcmtvRGNWdmw1UXgzMWdE?=
 =?utf-8?B?YTl4Vys2bjlPajdpR2FWZVJ2MEVaNmtPZDVwVlM4N2Z0UEc4aEhCbDc5b1o3?=
 =?utf-8?B?bExZcnVlb2YxLzZUT1hNSFNWRHcycTdiU1h5YzVWSXUvRXBCd0I3ajEwTjcr?=
 =?utf-8?B?Q3JmZFpuWTczOVRBVURrMS84SVIvaGJlNEgzaHdWYVppWG5wdjdFb01tMStz?=
 =?utf-8?B?Rmc2Q2xDY3VRV3IxbDloVlgybWwrVHR6MWtjZVFOMHkyRFJjcFEzdkNhMHJ3?=
 =?utf-8?B?bmJDWStQZEZ6Rzg4Y3V2bHJiM1ZVbmNrWElBN1BkM3ZjQlV2SjMxQTFVNkZ1?=
 =?utf-8?B?ZmlUaDlHbEs1WE12Q3NML052aEtlUjNaRXdxK1UxUUZHNnZ1enJvNkp4NGdu?=
 =?utf-8?B?ZGJ5TmxyaE8rUHZ4NkFYc0lha3c3ODdQVzEyWW5QZHd5NGdIMmVDeUtsQzQx?=
 =?utf-8?B?YzEvSWhURmFSeUVPdFRrZU1MY2MxRWU5WGNMQ3VyQU5VOExtZy9lczZyYVEx?=
 =?utf-8?B?SUFQdkU3YmVvWFdhZ3hTTDV2ekk4V0NtQ0dsaEpOWUs4YWxmYVB5bXZOTFgv?=
 =?utf-8?B?WjZPTHplVTU1ZEwrc3VyZDFyZWdvZnVCMFZmREJ0S0ZLWlN3WDNWNDYxYSt4?=
 =?utf-8?B?eFNRUWxNQy9IWTcwbmw5bUxMeHVVVmd2clJUOFJ1aDdoVkNFdjV3U1R1N2xw?=
 =?utf-8?B?U2xFSUJwTzFCOW54UUJIMHJuSlBENXdkZVpXbHhYTmVNNDhRVWVnMjZDT2ZS?=
 =?utf-8?B?WVNqVFFoT0RQY0lYQlVEbnFGcVkzVXZSRVVIZGp6RDZsZVVueW1wZ0lpd0R2?=
 =?utf-8?B?WW5iVFFXR3VQUEtYZ0Q0SVhWaEhZRk92bTBhNkV2TGtlMGl6OWkwb3NPVDN0?=
 =?utf-8?B?d1RybzZ4UStrL0FuY05ZeE1sWUVLV3lJYVJRTktpV2JZV1JnZW1IVWpjWmd4?=
 =?utf-8?B?THBMZTlwcE0rS0krSC9OdlVGdjI0bnVSL3FsOGpPaXd0QVVCV3VLZHBQODZj?=
 =?utf-8?B?Tm42RHp4VXpkR1RBVU1uS1F5enAvbzhNVUVrNURLZGJRK3pad0xuMVdoT3Vx?=
 =?utf-8?B?QVB5a1prOHV0NmdITVd1NFZDbzVTelZLajIrS3dEVmhXdjNrMHpWcXpKS2Ju?=
 =?utf-8?B?QnJ2bWJWeGJXSzEwVzdyMk1ub2hhckl1OGFscGhCNExPd3d5SEg0ejl1UTJj?=
 =?utf-8?B?QVZhbWpSQUFreDJUdmNJUU5BMTA2RStGanErdTRrb2NMSkYzMWJHZi9QZjl2?=
 =?utf-8?B?djUrTWRXOXNXZ1lVN1MxZTRSZGNyQlRQWU13TDhmOFQ0VVplVkI0djhSNW5a?=
 =?utf-8?B?QW1tMXlYa1FVWE91VVI4dlpxSlFTRE4xYXlrSnJ1Rk1aRzZLeTZCNWxNdkc5?=
 =?utf-8?B?djhiY1BIRkNUVlR4OCtOZHYrcUQ2bUhUcmdiWWNJZnZVN3hnQ0FkcU1MYnl1?=
 =?utf-8?B?bUhRTkdYWEcvRk9relBGRHJJcjlRc1NaSVNYVlhjYUxzVWREaUJwRXFCemNu?=
 =?utf-8?B?a0JjNGRIL2o1dzBKcDk0TGxCdExNTllidlB3dE15czJudElnRUxRV25idHNn?=
 =?utf-8?B?dk5iQk04UW1oQURCNkVCZEpJM1BZalNGY0s4SmVTSCtYcENqaFBwQ2VrWFhv?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F+3WfwSdxr/dgATwejPHQk2NFkRFirilZULep8Q5T52fIRjiwAoMa3ilLkw2miqYy/xfZHLhGOwUJ/p3fysS6w3vGN9rGg2VMipKt/VPwUvNclWRR8kRSE05QX2ySv+bXwSzLNEF2DDuBonJR1ctza5OcQU7ETdjOhlIOYmuDskTkFrt8PzmvN7PW3IP0sN8NaBltIIjSmRiMS5guWwEeZb7Nl7HQuu77RuJMBDHC4YA6i1fWH+xyiIiaTEwLDA4fRXvaSJsfwgjFvsmrbrK/lfZvZ3Fc29rSndZIDY8kH2Tz2EJublgWI4fermL4PMkHyeD1PIp6f7fm2O3SubQgvy1uWR+ObVx2ZACkVWamEUGiFmAZlg8I8+mWK91SIi+rpD1X2TgHTqgw3aQj2v9bZlZ3SYUh90eo8JV+JxlH1+kbvYnVG9qWjkDDPTikuV8x7HMAUTuvzsRCoI8FK/fTMDOl7WVKcIUt1QIo+TtG/qrjAzftenJWMThi1KysY8iNkAPVqQ5XoR7OiOh2xFz71UYsWUEbxRAapXHC+h5h+2M9wePDcNroCU069D7XTUeq7w0JbwRORprGZNQ/byuQn+qMtzB68xsFvaQTyvfgIg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78de101f-0228-4be0-7e83-08ddb88fb1eb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 11:09:06.3282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ioQLcdUq9/C5Hf9FEziN69EFpqwZmAiduMya5Y5BR9UD/G9KRgL7LRNhqZxT7Lo1wuQyTrW/C4XwOPBpF4339A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4990
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507010068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDA2OCBTYWx0ZWRfX26CocXrrWiqe +Yhxvo/OOTxweTGeYBIJHQevU2QDqfT8qNpBxn9GBymWthbMsNG4WZRcPL8T7S+Vqn1Yk8moJS/ UOvGCI58VigNrwakT/Zkei3rLPx2SvJ6pj9dWXxxmK/bgUHcPspavFHiXMVY2MJbBTLfMmbeMbU
 sg65EwLjt68l7CyP9JGWq73lmQMXvMtRo168Z2OBF4AGyqGlqYmTziKXF3EtOMb0GlhLWffK7xV ayHJDzoTAXShbC0bHOJfgSoi3ol4ntkx11nTOgQsEecXCvXYT1GIDCrzQo1MWbTQJZ6fUYmgvJ6 kPkrzzu4Wb8pulxfPZRMrw+HZ5GghFnXRsTxIwnt3ToPOU+oAgvkmwRcbWkksU5jGT7hr3FPx/m
 14jd45IMMdJhzAI/FuQLkZlUTRdIU6uL+C6yEcgmTvrGjnVDqwzyG1auzoj8KZiCkQ569dVE
X-Authority-Analysis: v=2.4 cv=MvBS63ae c=1 sm=1 tr=0 ts=6863c1d6 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=Jmadrumml_yOqVL8EMAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: z9hDWbcYgAppSp1O1PvSXu46BWOqfUlg
X-Proofpoint-GUID: z9hDWbcYgAppSp1O1PvSXu46BWOqfUlg

On 01/07/2025 11:40, Christoph Hellwig wrote:
> And use bt_file for both bdev and shmem backed buftargs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

looks ok, so FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   fs/xfs/xfs_buf.c | 4 ++--
>   fs/xfs/xfs_buf.h | 1 -
>   2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 661f6c70e9d0..b73da43f489c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1683,7 +1683,7 @@ xfs_free_buftarg(
>   	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
>   	/* the main block device is closed by kill_block_super */
>   	if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
> -		bdev_fput(btp->bt_bdev_file);
> +		bdev_fput(btp->bt_file);
>   	kfree(btp);
>   }
>   
> @@ -1802,7 +1802,7 @@ xfs_alloc_buftarg(
>   	btp = kzalloc(sizeof(*btp), GFP_KERNEL | __GFP_NOFAIL);
>   
>   	btp->bt_mount = mp;
> -	btp->bt_bdev_file = bdev_file;
> +	btp->bt_file = bdev_file;
>   	btp->bt_bdev = file_bdev(bdev_file);
>   	btp->bt_dev = btp->bt_bdev->bd_dev;
>   	btp->bt_daxdev = fs_dax_get_by_bdev(btp->bt_bdev, &btp->bt_dax_part_off,
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 7987a6d64874..b269e115d9ac 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -94,7 +94,6 @@ void xfs_buf_cache_destroy(struct xfs_buf_cache *bch);
>    */
>   struct xfs_buftarg {
>   	dev_t			bt_dev;
> -	struct file		*bt_bdev_file;
>   	struct block_device	*bt_bdev;
>   	struct dax_device	*bt_daxdev;
>   	struct file		*bt_file;

