Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B338935957;
	Mon,  7 Jul 2025 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751894239; cv=fail; b=cYcSI3KO+11y5rA+7B4kChepjEnujysm6h0dU6YqxYjybKvpT5aPy1AIBVfQy5NH0se++E02Sa83G22aQYt1ux/AaK/RHrknuvZEG//3pPm7PfJIJorZNQerhnj6ityW1CvqqBW2VsXDhT3QjUr822zHx/gorrXO+rxEkT0YJoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751894239; c=relaxed/simple;
	bh=7J/GoWqcB8TqZvIOQE+957r+CgM9SgAtc6HDwHHiiX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EbFvKrDNUCnFKYeLRajAfWYoHDRWRyiFfzxHX93ESmH17KbXJYmmph4X0unrYWO/xOsZBIGeFaogHW90apdlKBmpA/58Di23PXs7UjAr5v+Is5NjFrbpWi0Hd9u7JB2HNS6gdYB94Q9//QJrxvBASf/e/MNM5kMaSptCIkld+gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TFfRniWe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VWNPnyxz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TFfRniWe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VWNPnyxz"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 567Bitl3032552;
	Mon, 7 Jul 2025 13:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Wg6Wmg1XTAk+HcRE1yWIyDmWORwOgQZYLZm04nEWdBI=; b=
	TFfRniWeZknsVk6lyrTnQQYmM4og0XlPA22HMwKrUthv/m4hUSTQnJaKuB2TnECE
	pjIeKL89NXHnduXec0XTaoyRYOZyhGJjJbSuMdyJLWBTLOs10xnl6txAb38F1xuG
	eZT1oW9e1WCo6L5SfU/gEPHrQCv2aWFGoyt32kw5F/I9a9MvvN6+xnB61Mcjfdgx
	QJnuz/HKli+JTPzI/PWRiA5RMIQOqNQu6ZfYFZRdTPFAqWWeyX79VmrikNmAnWEv
	p2tb7n0gbN/CnzV0oau3FCxbbfciMe6reXMQbAOYurZ/WI9rAcxcPSlR/NtxOvgy
	0PGZYM4jLLVRFTZYSfDzfA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47rdm3r5ep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:11:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 567CUxAq027228;
	Mon, 7 Jul 2025 13:11:57 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011021.outbound.protection.outlook.com [52.101.62.21])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptg875uu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:11:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eo9Zzq2VnoWbMx6JpossdBFOARkii+oiVwb/vBdw0XdLUF8oZevAUop/LyjyO6aTETgxHNh00XPiK0CzMwi1eBi9/SX0aBRjLjIEM8OHmbKdEDz4whURlb64c+206TzdUmq4DDwkJ7xJWSlt9MZ0WuFEQ7UaSvXffGxZelbxjxCj8NqSJXkibCDTKmkU9l2GAYuri6cAqISnDTdqEZWZKxdwMLw5l/xzLtgWso7FSVRfm+6FFu40azjidPYPYR1PiI2Rzntw8H3wvg33v0TXOrl8yhmefEoo6+j9moPbj5u6S5ytkDLp5/+Jd6NomQkNk1GMC7RyxnWWnUEtnORBRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wg6Wmg1XTAk+HcRE1yWIyDmWORwOgQZYLZm04nEWdBI=;
 b=R8oIckPwrjJz17QV544bvMf+B7VXZDqWC45NMPDe0oa13TU2EprMViUOasiwKZOXGbFoWOOylVxPRljyQuUYnLRaOzMFU0irmQtGAAiluuoifFE1xesUnnDTiRixNhLQ5TZFNSCbz9cP47fOxZrLkKI6EIBJUK/VoU7x/uHcs1zAEyjCQP0KXlKg32LU08+R1b9Ko5WK6weAinIBUwi7fJZfFXUJB2Us9oRV8+7LNXbM9zAExnXG5AwZ2czq3Q95fhV8L5vXAlqlVMvDOQ5JzpgTZcaHezl+y2uUhz822Vu6OQ1WB8DkjqOF1ch7DLDEUg1Y0/cNTAiufWwg/X5oDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wg6Wmg1XTAk+HcRE1yWIyDmWORwOgQZYLZm04nEWdBI=;
 b=VWNPnyxz7vkpAdUBRRx/y00Mscu+pkUx4yV0B1/e0IBo5Errvud/dacJf1P40448kYEUN+7kSTyCL70/6M3QnguVXpc9oKXXGMGV2JR4JG57jVTvEwF2hFCdv9Sacd+y+BxJjw+IQBnPDa7M81aunijNCTageoihdNBOZcX72yM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM6PR10MB4201.namprd10.prod.outlook.com (2603:10b6:5:216::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Mon, 7 Jul
 2025 13:11:55 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 13:11:54 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 3/6] md/raid0: set chunk_sectors limit
Date: Mon,  7 Jul 2025 13:11:32 +0000
Message-ID: <20250707131135.1572830-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250707131135.1572830-1-john.g.garry@oracle.com>
References: <20250707131135.1572830-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM6PR10MB4201:EE_
X-MS-Office365-Filtering-Correlation-Id: 219f7f58-3202-4b08-c05c-08ddbd57d84e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bGs0o8xwwCZFWnCcZI8mxKCFJEkVT3i4BYmaDBItpnY7sprxiW9iPz1Foxe2?=
 =?us-ascii?Q?Gd3E7eawEwXVEEKGaXcQRMbOsDVUVscgIht/OlyOnz0DkLikviWKdupim/77?=
 =?us-ascii?Q?AUtzeu+XClDtwYiDwSl5nkWWuj0oi0AnpFCyeLm87IrS4ZO5bLBeS37JJTIK?=
 =?us-ascii?Q?iWtfqWdTgzJ7Doj/nvN5URZtNvn8YBK4em4ZrT16rEGVuf2lVgQ+zrWJvdDE?=
 =?us-ascii?Q?2nmjQfrOCGLdftzZzsc6nzEEg2Xo10J+Q5tvTM+aYIWFiTaNFGRIcSPIEI74?=
 =?us-ascii?Q?HqHtZygRBtawcsY43ohlz3oyJ9d7E4z8aws+sqghiT64lNZiXwjlcGS/yCJc?=
 =?us-ascii?Q?LHPOQ141RuNgdQkAIrtqQ0RRo1mLzYqhWSjjiyRKAdVoXYVTFny0/1QyKD4z?=
 =?us-ascii?Q?IX9OBKtVvfemJMTf0P+mq9+Urio0/+w+YQR5l+kdX3uKfZZ9G7zGwdals6Dh?=
 =?us-ascii?Q?STjypi0VJ8tL+A6dS8l0Nzg+M0yYq3iSiHy6onWJispfgyvoFzsHd7/rBWhK?=
 =?us-ascii?Q?1/3tMbPi8pqJlPUXeBhtfDe6LMQxbAAXjAj5KkmG7OuN2T8mmj2xZsUPL8Km?=
 =?us-ascii?Q?NKpMHBvfzVOWWJPFUKjVAeJ2xnCUjHssGR2aAFyW//HRSYmkGl+YtGxOImOI?=
 =?us-ascii?Q?48uKr5h8qkwwXwjFHsR3elQHaFcJh4pSXQj10wuYxJkFg0wAHbxNcAKriZHO?=
 =?us-ascii?Q?H4Z9N/BhWCvmnb2oEunYJEH02Ao9H1fMnTETXsOp3jP8tFJVg0bFo9HLuHW0?=
 =?us-ascii?Q?5kYG7213eSt6mXp1h0LJUp2v4cvGIt1lwtEhsqnOxlcK1b/KoY2e9WVnO7Vm?=
 =?us-ascii?Q?qzPdHRkY108Fqibzg0aw7hmtwChC/RfoRtLl6hg19XXiWcmZSvWH0dHh28ZA?=
 =?us-ascii?Q?be+csZg8zUu5+p/cCHbq6lz0c71Jply8UI5xTixnf1TEsmclK991Jo+f70RO?=
 =?us-ascii?Q?GNVN0T2bvri9aowwj8yw4VjxW7v7TEhttxwJukSX3IjVEjB7qCXmGZ8jbIo9?=
 =?us-ascii?Q?RuSHqo7lI4KykLDaP51kYHbO7FgFcefkzOCOiJX9UKDlRQvZuovX8EtzMQ6S?=
 =?us-ascii?Q?h+QKQUXEvzG/Rksu9nkmahMJZoJyCw4lLxc6kOvIR6gL8FSxdflHEuttiT//?=
 =?us-ascii?Q?nEf2hdL4wplkzBPQtETzOUZrh79SMgnfVRBKHPUuC5K31HkS6wEoUduib5t2?=
 =?us-ascii?Q?aPBWQx6nFF0rZCQHWWMyr8f1XM6Yg7ifjyZq4vlEF52EU70z3loNANQNFd2w?=
 =?us-ascii?Q?hGlJiaqn/FcHQtDlnLBN+qzByu7FuTXzA7ravXCDJnK6QqnleuOd3DYKKueF?=
 =?us-ascii?Q?JGt7UiY6+5RC0CLx6SafzVTGQqQmZfj6b25tgwEo81BAe0+J5eXfpz7MXH8b?=
 =?us-ascii?Q?sMqh4vN29AGZhODxR3z+icG7a30FHOdJz0viLJ3sK90sDZE2527boRVH/BwA?=
 =?us-ascii?Q?L+EeQSbxINk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1xGZkhnFONTKYqrLUP+3czLTSwl37AjIvWFi8IbEAqNknUNI/qcMsiE4BXlJ?=
 =?us-ascii?Q?tMbvdEVt3p8HwQ1gMjO7p45ydFQab+dQ4Of62TvhlD5t8LaszhCMIXQZcLw1?=
 =?us-ascii?Q?yny+7iYLd1oNTtW4Lie6PQKFohtymP50zsyEK5giuHx6F6hFY9sc30PCU7Us?=
 =?us-ascii?Q?oUHtir1gsclp6EZkBRlW1xzDQlA6+Dh5HZcTIbG/fFFR5qMOIUq8FnnNVSEe?=
 =?us-ascii?Q?cTOi7x1U2qkgXSSfiPYedWnqB61i7Nd/KNsKk9t1EABc7R8kexF7tNpuY43i?=
 =?us-ascii?Q?n77Oc+38hSuVSWbpc2z4STt5Lc/zlzKWB/Hs9KUSquCBOzq4ey5xVn7ae1sT?=
 =?us-ascii?Q?VQA1lV2P+Es2HVWOnx6QicW/CaeA1gorc0XzWGIZ+3pYtcpomRxM0C2hr6F2?=
 =?us-ascii?Q?UVB3Iz6Zay5/m4wDJH/1bCQrL485m75t68KXcj1xlTSVZ9MT70+Md29wpoSz?=
 =?us-ascii?Q?O9SIemOSa9xSaXywp5265ERlrsBLRUZM7LQtDNr1Vz8GjYnBghnWqQO0UN/J?=
 =?us-ascii?Q?M9uYTfnClhVw2N7MfJ2W5WnfNJwLWPdwCsKP52rPBx95NisvyNHGmMDJiXXv?=
 =?us-ascii?Q?BSleuvT7Y0d7dwpFx9Ja4jDT2UPS5PVjQR8JDh7nXWTJHzvm2c1E33Ngm77p?=
 =?us-ascii?Q?vE9JoZSNEj+D4JkdHYURM641JxMkU2FNFnr/mClFPkSUUAoUaB6693SdtRt5?=
 =?us-ascii?Q?hjrMRSLUkl6sii2vs5b/6vDVM1IeSS1ioTk0lC89veG4iV4Vsem/g3EXHioW?=
 =?us-ascii?Q?mhY5gLMY8xgRyYTndd4jvicx6+rFx6XTvwxybNdIB6W5MQ1Yq+G20R6egoBs?=
 =?us-ascii?Q?G5b+9DM70uPo7W0eNE3DVgZVhSdMT8AQGJXsDIRRjZ7lyrli9Qgdv4NGrd6A?=
 =?us-ascii?Q?h1WMrqlPoqOfT3DUaG0NUJSHmm1OezCQo2l7DCk7592+ahgPwDOaJhAdf/tR?=
 =?us-ascii?Q?IfJqBRFyc89UfqO6IzzmzObnREIfBzgliZZf9d9SxmgkTMn6GmpKYX9jje4S?=
 =?us-ascii?Q?qvWMlvimsnmexGDuqnCFrkGVqipYD3M8ABKwRPJkVI6HRQdS+NbWvikJ+3e+?=
 =?us-ascii?Q?96EyQt8RTt0ITVGxJ9eq6/dNc1XMN3trNXR11r5+G06SlFb8n5KsOoie0ClS?=
 =?us-ascii?Q?b3xgv5wSbh7bTYRGjpSdZq0Z3S6wjVdBXvidQJ9uktTF4IxqIjwC3RlHMzqa?=
 =?us-ascii?Q?r/PA/XYV9tIoHT2g4uvZtQsTalnx0wXVQBgUMv4K43dgnCukN4hb2gMYbyFS?=
 =?us-ascii?Q?MHjiQk1kAPZkuw2WyppEVlywAwps+conJ5+CyfenK/VuMAemGn8rSWCUB/8x?=
 =?us-ascii?Q?uVmo0JVTAgOjiruDjPj+odqOSUDhZGhKmTdOiKN7IqhIOUjNJRAr9ctbw/zp?=
 =?us-ascii?Q?i9W2l0jG2kq/FP8cH0fPyMwLVEhv8pIXml+/MHm7X8454ZOwyjb/NHJnOAqG?=
 =?us-ascii?Q?9TvmvNNPLq/x4RRQZ+/3cTz7GcJ4mXSE9h4moLhdVt0k8Q5ri82NyvgtbywC?=
 =?us-ascii?Q?5OSCAifbZkQO5aK2CAp0VvukaWoy9Q+g1CkAGiI48zlp6L8cYJq18iQ4eAVs?=
 =?us-ascii?Q?d+tP2vzGRP8r0m+RTAbnmtUYjtqo8LOYhRhjTyV16rfOSf6FsvE/WkxnXQO5?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IKEDvItHeg15nHwfIZCmGxvgJKS7my5P1heIvDX7txEWGw6gibCPlkF+1y8Su1aRHmVCrULcXxFPM2EYzvXO8q1vPPyllU6Zu9aN1sbMoB1higK+7dGwc7Enjebsgt6XUt0faBFswpFSCfxi1CkEeKTpzGa0rx02tSpA6aoaecRpGWUes7+Zwgidx9zHttbLnvCrP3gfXueaXdKZDTPvwmc4SV+MWNO8WL02f3eedVv3VO5DbuMNKUbRUsr5VDYnHLpG8yPnofjVcKDcv4PVIcx/W7jE8gb2qcmPzZeqbi7ZbQMBMKZtaXVlar4oul6NCYMiuv45gPOz/VmiuhoL7CAxZeuS3HsNEIQMuFzqWtfi4LZRi4Su70sQvFVHghg2h9GDqXf4yIGgaQEA/gmjVPmK1lu+pJCsBb/NR3zHLxQt8scrWGtItXznHtV3LwDZnymAURzDpG3taBI2YPrzAuPLPET+XZqeJCCmJSVQ837LJjcFOUrBLVzvdh8A3sit4o3qKuobfQCT1yTYj8ou0/gAI26FOuKX1jhn0jGPPIx4cv9TntdvMDSi4yttm0cUIC3ylt+pNxhydOXgebjWMt+Gmg3uRkuJG1lu2gOuNpk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 219f7f58-3202-4b08-c05c-08ddbd57d84e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 13:11:54.7323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TUXnYWunmqLmQ0cSrsQbSQQBA7B9WtvZPY7o/natz+2FY/D4Ua3xY+gymCXNJlMaMChigyr5zF0J9BcAeZS4ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-07_03,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507070077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA3MDA3NyBTYWx0ZWRfX5t4bAaMj3O42 DeTLLrEICw+6Aur9j1yey/ahDa/t3GZXUbhAAv9BemLsjSgq6kx0D4MTL+dfsspGWR5ImsuomxF ViEhXcFZIUmelarbXdVchpGMW3i6MuvuI4bDFd0sUkVjuR6J44ou5oCLYnZrSDEcN7VQM2ZV7h+
 KcNccquwPQD07wFkvnMGaXWg72K6pS3SgdFFS9zbILB+GGkCh3EO/43W00LtKcjShoxBg32DNFe ExiYTIq6ETwrHfUILIpEUlnmaLDdhgf4IY9TyPPmAw9WKrNPW6vvicV+CKQgCnL28284OdoWQPZ WKpwJmf+J0isauEVUDhsXi4hYPnP/L+NhI3RjLBcti2Jadan9wWRk1eynpllqa3FjSZm+mZT1v+
 vbJyDskm4vmpoLG1f8Y2G+vL9s6H+BUGpE3whvTKM926UCBMw7gN8BFWs5ekXNgg+ttoftar
X-Proofpoint-ORIG-GUID: LymSMN6qZK5to7wz3QdRECJTnjXBbId8
X-Proofpoint-GUID: LymSMN6qZK5to7wz3QdRECJTnjXBbId8
X-Authority-Analysis: v=2.4 cv=CacI5Krl c=1 sm=1 tr=0 ts=686bc79f b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=oeePQw0IGsqOEWDZT9MA:9 cc=ntf awl=host:12057

Currently we use min io size as the chunk size when deciding on the
atomic write size limits - see blk_stack_atomic_writes_head().

The limit min_io size is not a reliable value to store the chunk size, as
this may be mutated by the block stacking code. Such an example would be
for the min io size less than the physical block size, and the min io size
is raised to the physical block size - see blk_stack_limits().

The block stacking limits will rely on chunk_sectors in future,
so set this value (to the chunk size).

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d8f639f4ae12..cbe2a9054cb9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
-- 
2.43.5

