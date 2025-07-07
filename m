Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AC029CB49;
	Mon,  7 Jul 2025 13:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751893942; cv=fail; b=sp6MMkLI5Z3EP9EagOHCDSn7EBuGJVZPEav0ZfC9IwevxJhkZryBEsQ2x/iw8gxPk574j4njwMHUxQj6bpzRI9/0ih47Y3uirygwywKr0onKGycdE/Ut1CSbDBHdvUXT/uU5qIU4OZrPQ8BXCjmpGzNfuLaAUQCgCHK+iVC7Fis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751893942; c=relaxed/simple;
	bh=tcLWCfs89bCzvYXOAyVjUgoY95qZz1dx3L2AZw5GIaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Py57dxeylrrR2fkRkZBgX9hJ/4eB36EmUxrkVNwMLjOdTTyXR0f4c1Im1ULV/Vw7d+YG7vmmmb7I1pt1NM4471G9ajPRy+OVvewiTqcJZ33pGRTCeFHlXYd9u05z9J4OWjKxonT1/GOhz7D6dChoR1qG5IxuCEfUzAOZm17Dhlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dr49QvzA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H6TUhFS0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dr49QvzA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H6TUhFS0"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 567BM34E029671;
	Mon, 7 Jul 2025 13:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ptkAd46WirjWb6XSxLbiMWAeWwEcLepBp3PFpTTVNvI=; b=
	dr49QvzAI6ehOfQMa9rs32UprhtL1zQg+qIA53HAkRwJ19bN2FcHku8SHA/enzqZ
	oH/gQKr0NAWKgrfmr3hvKW/J1YMISPJ2vccUpl6gDIn/IbeG9OBzCxvbu7u/3tJc
	IHuW9t46qzjmdBU/IglQTTlioab31qR086cwXyVFB6MfrQgdliRnjwLI8TlBZ0Ez
	Vwdxi8GwEedx8PFjqKqqqqCnouNNcYJn3hwwmaXWEG6B2aVbcP2Bb5mtb3mkgFbn
	mHB1FlBz0ZKTsyKio6LklwKu9AbWF+Cg9SeOZE4Og/I+UjKP/AAl0IE89hyJzVEI
	HR7xZSZrEA3mBJHvBkuuyQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47rd9yr5v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:12:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 567CUxB1027228;
	Mon, 7 Jul 2025 13:12:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptg875yv-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:12:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b+dYTqu9dNQy5EUlLTPHwHR/a0vW5Asx87bGuaAovKaLg/37K8dNXRc6DniXiTQqOVzg/MWb7cU0pEFfEZ2OcQXvF4T9N+hQEimOeCZpPIs++aRhOJMFgTcXYdKAijUzMKkGDfPaemmi1c4wQZ2MkYzbyA6JiDXo6DcHDXQgKIEjdU8u2sFWP4k0A3HohiWwzS+sDuEi1mryyGoLYuGTof6UGVmDT4KMno3kdK4YH2KepV6EcgE05Rm4aGqnXc22axvkWZhvxbuZKZBtI+JL3AxUJSbF8xLeIrQ9GmD82OhWCOu4sPRxjRAMRH5Qp991p33I58jDiO8Roxsh1d5cTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptkAd46WirjWb6XSxLbiMWAeWwEcLepBp3PFpTTVNvI=;
 b=QIzoNGgQ3wtQChqsMaPO0RBx9aBUI5jl22rD/1is7Td8iY2hlguJhR4UtqDxiFgUnGnb01p1TGoZUVw4lhs7/P78miQRsNwmbMtUpfSZrZ0Gq6YyGJQVoe13XqdLoIEpA/93MyYaiR7YKPwaoKYcSY6BRFJJtviDN2GQjwsXNj7oSSZFDvrU1aVzey87EpRyhaOS31mChS1knWYaiAaHZKS6DAsbASnfU0VqxrmDZVYAqAMvjpnDDwTevEVe3VMb7XQsm49Pl++wsvdilm2TS9MmoqRp+ButqgDMT60+mOiEu0xnPgoDaP93iPFRBcTEBd9DrgQDMHr97Bl/vzoKsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptkAd46WirjWb6XSxLbiMWAeWwEcLepBp3PFpTTVNvI=;
 b=H6TUhFS09hUfZ870iHEjC12Kf801c/gpd4UMcjdUKSSIrw31r9rrvfDc7xxe9gyuore9zkfPXk8XZnmBPBm/ov6xv1cksL4wvpGroZZXl7w5exhvYrAB3RURmtZFCCvdwOdNM1ZlOdPLEhb9NFtC/xGnTU5mSYbDXd/L1khPGVw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by LV8PR10MB7776.namprd10.prod.outlook.com (2603:10b6:408:1e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Mon, 7 Jul
 2025 13:12:01 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 13:12:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 6/6] block: use chunk_sectors when evaluating stacked atomic write limits
Date: Mon,  7 Jul 2025 13:11:35 +0000
Message-ID: <20250707131135.1572830-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250707131135.1572830-1-john.g.garry@oracle.com>
References: <20250707131135.1572830-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0113.namprd07.prod.outlook.com
 (2603:10b6:510:4::28) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|LV8PR10MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fbd8bd5-beeb-4ce2-3592-08ddbd57dc52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VZT586c+kIoXcEdyabvJguRla0jrwuZtmv2+GAwCxk7NCRHA2/QwntRMKGE1?=
 =?us-ascii?Q?bTDxc4TeL/+qyWWC3AvTYhutrHjhJl9i8RdHvQKmmbVuxxPViJ9JMUqP/3YU?=
 =?us-ascii?Q?qe6IfhV61vyfBH8mvUnmZgPZ5WM5nrizfGzxtt9g+ihGtHw2BtZL5UIrbIMJ?=
 =?us-ascii?Q?Jo+snpw2LE/pAAY8ADFiv/kU8j3iyaBzuB5GcNrxzExsze7ifYnFZUUUJAto?=
 =?us-ascii?Q?ieNM/K5Qk5QG+Pxd2+Nx8KriS75tCOLvB3j1JJVUotcLR0uWdUSlx2iLYrri?=
 =?us-ascii?Q?v5/vc3TdVw6HPS3BWusqIuT7ZkCZzTfTyhbEKYNsL5SJidjF30S0yQnETKzb?=
 =?us-ascii?Q?Kd2vY4jCDE529NIh5PAbeeXEomO3w4GQ93jGksxZJDYlDu48LEcNXB5WHK3d?=
 =?us-ascii?Q?dqrNRC6qCaJjcExKJQI15jeSSG9NM/z43fpTWTgFhtcQJl0XxorXUfiQKl4b?=
 =?us-ascii?Q?s8XYojwZHBQAZr83IiifQmY3ukdaGh079Y7FTh34SK6jaS7/CbXRVkOoG/Cv?=
 =?us-ascii?Q?5NvqGqib46latDe6D8X2Tuz745WNThum0tV9ALV3oBGPVomV0PI4xwUaA9Dt?=
 =?us-ascii?Q?/jwD9fbg0s+6UtxYFNggcNMFGGnNQJOVcd7lfcvaSJB9iSCuTAEBbHXLuyK4?=
 =?us-ascii?Q?aLrjmMAEYSYFIpSbHsMivFZpRbst+XU2rY7Tfp2dTmSiUxmpJNQDInuI8sAK?=
 =?us-ascii?Q?ymjsc9yLzfU4MpDYa19Kucl/Fz4P4fzthOIeQNecXknrq6LLo9xg0E2l/Q/U?=
 =?us-ascii?Q?bmewokjTvWHMAae2Q6o3rTwtKJhW0JXnLIMepq+6MgnEf6mi/QQJYnkkkCh6?=
 =?us-ascii?Q?ctmYNhS1obo5rlSgViNUwxXxhkW8/v77zlRxIR9yoxFWRdXO1CseoNn5Q/mX?=
 =?us-ascii?Q?vS55e6Fc7eykHEKAWMYPt7YvIbHTWbaD6FyLZtgZ/uKwcfCdBbnZmmotbE5S?=
 =?us-ascii?Q?e8UxcIQ+hxG4Zny0TJzQtM46XNGLgIVQPEUDcUKWoa0qE4DfPQAYgkcC5Ati?=
 =?us-ascii?Q?zJDlQvd8pFwHyE+EL2/EbOInXBzTnzzRs/pv9UrfWmCLg6Zcst6gQXbq34Ci?=
 =?us-ascii?Q?YpEiXwWOqyAe0XC/vMJSezhw/v7ku0rEmyA4ZYV4NJqU43Jz7sgiARrrHpoh?=
 =?us-ascii?Q?5/YokRtzNuicw3a17vNUx2kJzCNbN2YA50AiMtrxjp0O7sAkasrsgHWym2ne?=
 =?us-ascii?Q?mlbsevTVn6X+bMFjBIC9Jj18vmGmOgGeqb4RmTHvIGQgA5PB68UAbi1kCM08?=
 =?us-ascii?Q?B2dE7ceMZ0qs3xWy/4qnWRIojmeFaZqYkWzy0TezncypPsgCiv73XpYReRzp?=
 =?us-ascii?Q?VGJ58b1M9jirig0HYRSDHmIjhppZRi7LgClsmp4K/NR1xK9yEMs+3pef/wMR?=
 =?us-ascii?Q?YI7+zUIWTeKZi0xHJyRjULSLIX+2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6fNtpnvoAHALETTM82eWPS5l9Vvx151q4khX5Ugx5XcTbn1rSUjwK4OEcnNK?=
 =?us-ascii?Q?UFUQdyAU6zpchEyRnZMaB3smiPdLG+aEJauBspsHxRCWH/4+5AZ4xf7wGSb6?=
 =?us-ascii?Q?ULEkMojww83bnbmu2HLuhsNxjTW9GCnCApC9fbdXgnJo1zUBQ5Db4y3CjNBD?=
 =?us-ascii?Q?INEUQCXVKbBHsltYewnafAgUidSqkQeBt1cWp6HuJ48OVZ9VGM+WKy8y5kXk?=
 =?us-ascii?Q?JV24hXZJlbqLU8mvOQnXfFTFuTkH8KkuAbm0DduBt841NyO7QOfC9uS9z3CQ?=
 =?us-ascii?Q?B6JFseHOQ3IaQXfk/WzKSyvkEgrd7LHeScWNXJNF0B0pZIscqdv6HGMiVbdU?=
 =?us-ascii?Q?SqbqI40Qr/Nv3OW8DxExDQlPmbeHpr4TCx8ZLN64hzwomybH64NhsXqtGGHt?=
 =?us-ascii?Q?P2FxoJY+ZJ6KThPgmbpqJSyE4TlASd5xGa5xgxZyRyI95PkdBYOOnMlQlzn0?=
 =?us-ascii?Q?XvbqbUrfmBF+KNjKKRF+3k7XcqyjenYLgC/mzjM730xRzA+DvJ1vV8uEnnM5?=
 =?us-ascii?Q?K+HROu4zZ/Bp7Y3MxCzk/IZFmPcZN6fpBJHaLUgYVbmvY1gDGexSiTiXrUnq?=
 =?us-ascii?Q?ZwlSKvRr+IuQsHAVnU6dRPPRKUlSRUcvIHAPCjQzN2HfHJOT6GbTgB1J9L8n?=
 =?us-ascii?Q?2z0r6DL5deS4sc3edG+yw92oJhWf+EOzwVJg1IMyrXj4XK78Br9SxQTVzJ30?=
 =?us-ascii?Q?yLfBq3QdjwvYkOKkOVE4lIm+YOHGBWqhtiHVaCBKWRDLYTaGbc0ajd7XQZ/g?=
 =?us-ascii?Q?97VrB50Hji/j8yj5rt1M/tX7OJtdL15tUXCRSZqbTNgur9ejPq5rW0tJUyiT?=
 =?us-ascii?Q?fksoXzq6KXsEUpMOlRIt9TcPs5kKTvfzJtZmGRCk+SzIPiwkBZESS10V5GZn?=
 =?us-ascii?Q?tW/ZDAT6GaLUuRLfqWft/UGU+r3Vkg0PjZfPAmQmXeOmfZEH8paq2WitCc5y?=
 =?us-ascii?Q?pfBtACM31N6dKt0y5L5oANoFm7rmhFkzxKs10EsIqVBguepSkZ9mckJEHX/u?=
 =?us-ascii?Q?G353uGG8cEahPh/U6U3XOc8frPTZDpNjvztS1F4qrGQ82iy4XPCFmmgS6PdH?=
 =?us-ascii?Q?UOWOgixUd3W6+GHip9GiBA5K4oB0RE0VutVDmwLa2F27/WzQh/L/4/j5udIL?=
 =?us-ascii?Q?XoZ+Dm6UtBG3UOsWdRSDcV+Me9KNScQAOfSr8s5M3VzE6+o81pUTCaPSfM8q?=
 =?us-ascii?Q?3FMQ/Hr6gfUGi8pjFx7xx5EEXgkaX8rscpHpPv2wpBqbTO2yFMt8MMeRw36+?=
 =?us-ascii?Q?yOor9wBFdCNp6dFHIma/nzUkAcjBxWHOzdVYIV8Ti6VxpPohn9d60iSHMZEh?=
 =?us-ascii?Q?wCXLslakmxiG9lojLsxwKU1m0N0aolpu440+YVpjodTi6Vi1iOLEVEg+fVm9?=
 =?us-ascii?Q?emc4MCoMOtcHWST634bo/QDCj8PnFAq7qIu2OBZcWSJ/s9/cSL0i+6U4JRjd?=
 =?us-ascii?Q?BX+SfCDkikVj9fGs1Lhuz0xVekdgKKUx4ZjZIkDhajT21zf2soyKPbGB5T/2?=
 =?us-ascii?Q?4ODCVeV7UyVJ1uzvo3A6g5orSpO/QHnaPGNPZp3MHJVBnpZIl9WrmDY2e23D?=
 =?us-ascii?Q?mAfJ4AJfIJ4i5QNyJUnYpJGmGO0C8pPJXY2Xv8bUxg+P1CL54zNAsOw4mzah?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BpBnkq1mY6Tjbs2N02TUcH3nbRflMjZQRKd10lg3UZDM+SrzGRwGahPr45gArcbqnSFNrx6NkcPXkvg+nNya61L+Ut6asU3eGuQe1pXhf7di2J+wU7e657bsEos9vS8LngYAyqarAVr3BP2+a+aa597QboF3dprVtM0wh7q6n1f2tHl0S3s2+0gKIZUseWc1e69v1B+P1REo1w9ipdkpqPNChWi3HroHXv2b0HubuUPeTzlFDhdljGw67SUJcGuejCcfWH4o/BjrvX9H4YlRWxx4Bfe7kPEXzIFlXdK0EMe9WUL2+vPN64b8YVGmd3aWNPkc1n3NkhS1xGuBTV58ObBlnH0jNNilq44RwGETBnVGQyIxj8WakADw30cndGIWERFaCU8/ccTc5cipOZOk5iXfWHnpGLBE7rzmCO+RWlgMfWPTOkay9bouKogFrBLPysMSVAI1pudNUI2cFy2F0e0gXKUim2+Mx7bHpW6y+R6/TNwb1YlRocno/f9X/ysIgmyKThOqAhpPi8PEH4ipu+GvbO0WQDV7aFto30SZm14qVILUJUiv3Rns2jWogLarrVo10LLmLzHR1CjLyoaM9W1aHq7LTfC4I9o5Nm3PhVI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbd8bd5-beeb-4ce2-3592-08ddbd57dc52
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 13:12:01.4466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Up7pTfSdVEyqpBMgzBwsmmYzWJAn55iGXHU/0Su3qLio1PeZo6mYwhOL65LX0BwL4rfx2adAanSpmHi4uo327g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-07_03,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507070077
X-Proofpoint-ORIG-GUID: u1dsshYQPoMPhnxxFhMnFRH9Emb8WXYK
X-Proofpoint-GUID: u1dsshYQPoMPhnxxFhMnFRH9Emb8WXYK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA3MDA3NyBTYWx0ZWRfX/5IiEkFLl+aq oxfq5vlAuQFIPZjv95RY2bpCTczAp+CNzp3PR4XgPrSx5vyIGnd2k/4vglTczJrnRri7XjKnw31 eGI4tMx1pePiKvmjTbkPf2UCQuJdsSNZnUUvK5m00N8NcYYXf3tD36YRP+bVEdxwOdQfXUSOyEr
 cDrXXP85oxPjKJeeft0PHGiLY/SXFHGsSA5z0f1M+iQoJbDjysDgNzFqBBTWVuVvxnU2vIQyRXt zVOlnFo7gaaqrOpQdSzgWv3o3royHy5XPutXpheAAGdhSWtu2yjhqHte+LIq6TZMR/9IJmNke5u 134FyA4cSxaJMo23cavfHZstyaAIKuSwK4yz/fY9XKbdeAkbnE+IwwpZfKwnKYRtnekGFvNJmwD
 msclSuWzLbtEMbrtwbOa/9i88YRvkwoppPrTETBv++6oD4BTWv4CLUf8IYch4/MAMnBPFEOq
X-Authority-Analysis: v=2.4 cv=Rc+QC0tv c=1 sm=1 tr=0 ts=686bc7a4 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=K8uGWW0dPpHSTKdZE74A:9 cc=ntf awl=host:12057

The atomic write unit max value is limited by any stacked device stripe
size.

It is required that the atomic write unit is a power-of-2 factor of the
stripe size.

Currently we use io_min limit to hold the stripe size, and check for a
io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.

Nilay reports that this causes a problem when the physical block size is
greater than SECTOR_SIZE [0].

Furthermore, io_min may be mutated when stacking devices, and this makes
it a poor candidate to hold the stripe size. Such an example (of when
io_min may change) would be when the io_min is less than the physical
block size.

Use chunk_sectors to hold the stripe size, which is more appropriate.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 58 ++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 761c6ccf5af7..3259cfac5d0d 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -597,41 +597,52 @@ static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
 	return true;
 }
 
-
-/* Check stacking of first bottom device */
-static bool blk_stack_atomic_writes_head(struct queue_limits *t,
-				struct queue_limits *b)
+static void blk_stack_atomic_writes_chunk_sectors(struct queue_limits *t)
 {
-	if (b->atomic_write_hw_boundary &&
-	    !blk_stack_atomic_writes_boundary_head(t, b))
-		return false;
+	unsigned int chunk_sectors = t->chunk_sectors, chunk_bytes;
 
-	if (t->io_min <= SECTOR_SIZE) {
-		/* No chunk sectors, so use bottom device values directly */
-		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
-		t->atomic_write_hw_max = b->atomic_write_hw_max;
-		return true;
-	}
+	if (!chunk_sectors)
+		return;
+
+	/*
+	 * If chunk sectors is so large that its value in bytes overflows
+	 * UINT_MAX, then just shift it down so it definitely will fit.
+	 * We don't support atomic writes of such a large size anyway.
+	 */
+	if ((unsigned long)chunk_sectors << SECTOR_SHIFT > UINT_MAX)
+		chunk_bytes = chunk_sectors;
+	else
+		chunk_bytes = chunk_sectors << SECTOR_SHIFT;
 
 	/*
 	 * Find values for limits which work for chunk size.
 	 * b->atomic_write_hw_unit_{min, max} may not be aligned with chunk
-	 * size (t->io_min), as chunk size is not restricted to a power-of-2.
+	 * size, as the chunk size is not restricted to a power-of-2.
 	 * So we need to find highest power-of-2 which works for the chunk
 	 * size.
-	 * As an example scenario, we could have b->unit_max = 16K and
-	 * t->io_min = 24K. For this case, reduce t->unit_max to a value
-	 * aligned with both limits, i.e. 8K in this example.
+	 * As an example scenario, we could have t->unit_max = 16K and
+	 * t->chunk_sectors = 24KB. For this case, reduce t->unit_max to a
+	 * value aligned with both limits, i.e. 8K in this example.
 	 */
-	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-	while (t->io_min % t->atomic_write_hw_unit_max)
-		t->atomic_write_hw_unit_max /= 2;
+	t->atomic_write_hw_unit_max = min(t->atomic_write_hw_unit_max,
+					max_pow_of_two_factor(chunk_bytes));
 
-	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
+	t->atomic_write_hw_unit_min = min(t->atomic_write_hw_unit_min,
 					  t->atomic_write_hw_unit_max);
-	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
+	t->atomic_write_hw_max = min(t->atomic_write_hw_max, chunk_bytes);
+}
 
+/* Check stacking of first bottom device */
+static bool blk_stack_atomic_writes_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (b->atomic_write_hw_boundary &&
+	    !blk_stack_atomic_writes_boundary_head(t, b))
+		return false;
+
+	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+	t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
+	t->atomic_write_hw_max = b->atomic_write_hw_max;
 	return true;
 }
 
@@ -659,6 +670,7 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 
 	if (!blk_stack_atomic_writes_head(t, b))
 		goto unsupported;
+	blk_stack_atomic_writes_chunk_sectors(t);
 	return;
 
 unsupported:
-- 
2.43.5

