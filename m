Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDCBAD4B;
	Tue, 20 May 2025 01:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747704859; cv=fail; b=LA8VYjAxEXhaP3yI0MXfc9h/qHNmzx5G2T4Stf/0Vd2iRI+6Zx1tqPdIkVhdpX1I+F8Exrjdl3jY1smo77fZ6MYAGLkjyFu08H9vk2vt8fxhrkWLICenQMJR4fdQWGCorfmoNEkmFQ3zpwvZG1XaNP8Pv655zsUqcBnvKOza11A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747704859; c=relaxed/simple;
	bh=tB6OyZnNQ65oavMxjRGF2SNzI+9FplYBwmr5vE0EyEk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MtwW2eei12r8hMZZ9LJK4YDpPKDyyHdmhnYP5Gn5JDJJBG/SXzBH72aCnubrz1/TIfHH4vj8F3hADtO1Saq+qdRm63bxkk8dAK+V6UwUNzqw7kZVVBJ+j7mxHvQkeDMM8A0d1XueA1oe4W52ID2Gy/swxNMJbpz+I4/AeVftdCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W0xjlI9w; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n4qQ+GjN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W0xjlI9w";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n4qQ+GjN"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K1NZKf002010;
	Tue, 20 May 2025 01:34:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VoKuCsoRA/MOgx00tX+a0xxh6wLQu21PQdYwo2fafLQ=; b=
	W0xjlI9wHqAGBT3Zm4vB5dk1ONhY6wR9TMvl4j3SyMahlmcCeNAXf4y6qjwg+w9X
	m4T+daOjlrMzvOQkRGYZ2FKcxAvyiC5XnGkdZ47plCbUjrJOTj13hkHaVqmwoGhQ
	q0xn5TX6LT7wezsJW+ceu9v8AkA23Z6mu9tKFoRHPAcV+5EHD87dSQsKhfCrAGnO
	1kFzxW7myUbfevsk8Jge+q3QlM0Ndq6UhyQLYv32FjdBgEEiLc6b4AVuTmxdlWPw
	5SZrpx4tQMh60iASlNMngWA3/tQbTT9C4OAq0iwdVXAbDl2Z1Px/KbtVUqcWHkrp
	jR3ZOBFpztioEVHq1W7Trw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46rdtj852c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54JNloAc037258;
	Tue, 20 May 2025 01:34:11 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17010022.outbound.protection.outlook.com [40.93.12.22])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw84met-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cf8hxmyFAw0jlh+lcuch6cWt40itLTCFLZVHKcywpP/2XUGqBTmq0eZtvSzyrjDKLOeqejHSFwj9HzCOY3+QSAhJUdYEUvMso4EZwKs+T/MGzQQb+zkC9y1Dl2XchenJc2BzzNs3RHs4XMlbPlBVKaKOWetmvuZemAXYxdm0+PCtGAk0kqGg3AG+PrGz6SnFsSya36aDRD014Kxn1diy74m+CM4DsGYBEm3o68Ny+iUfsaJj+LN3t/3GB7CTU0q77wI7DuZq9HLZQnRVN9PtroEDPXqmFwuG7c8c/sZN7mQ+4Ry9PidT78BtpGb0dLS/QuB7eDeSnvYt/fZrJ6YXqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VoKuCsoRA/MOgx00tX+a0xxh6wLQu21PQdYwo2fafLQ=;
 b=rVFEXvqxkiVgVvFuC+6ry6WSnkw5gs1ETEBTDMJtBgp7VSW2Tca0CNLr7J8pFfj7MR7/I1WwqGapD0H4xMqsHGzG5OFQlksB3XzM7skwbG2mpqyDe3rnfFwgPSiH6fOfO+1DJV6WfYCC9A2DtnjmsemUrQQw9nH/z8zxhadweiWc4269A4BZIc5+We8Lzw95wwjaDhCCkm3EkPRAUwode7IFJbfEsMFpUugkxGfFWa0+2gz766h4o3b8xVgrYkZHGcNg0aydg3gbR5/hO0bK/sx6ZJldy6fQlJUcuzMKPnRycFDuI27m6KfUwzo2umXqn4UoncDyyLa+PWPxG752nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoKuCsoRA/MOgx00tX+a0xxh6wLQu21PQdYwo2fafLQ=;
 b=n4qQ+GjN5U7tPCMOUV/4OwdRr9eCsy+8KnfcAailnvTryFJ65Mxup79hKHAuorYZGYRcw7J9CvlcjSJH5gY0cf+zresY4NJVHThpYGgEtnGdhMpdMZ/Jp+RfveDLEVhD3P5kaxC+HF9RNVJcHCl1aS6eB4MqoD0FtV8vj+lQxfY=
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
Subject: [PATCH v2 2/6] generic/765: adjust various things
Date: Mon, 19 May 2025 18:33:56 -0700
Message-Id: <20250520013400.36830-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250520013400.36830-1-catherine.hoang@oracle.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:510:23d::9) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: 7576173b-a5c9-4a8c-2af2-08dd973e690e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8g0Azw21xGu3ngfsLUKh0/ioH9zGxBVRq/vF2KKzS4jDb17pdvBoT+wW0u7R?=
 =?us-ascii?Q?Qa/NDgyox4TL8kXuMy0jiOAh4cwt45gadeogRSDp4J22Dt2X4c3N0z43NChL?=
 =?us-ascii?Q?0fy3855ckwZLhzPYOy9mVvo4q3IB/I7imE5nSpPKY5eGWGm0z24VlwqXKfe+?=
 =?us-ascii?Q?7QrUULNt1Tm0U2/ASa3mJv4yHKdUqsJL4EmYKoa7nuzx940naORqiBlXXsPC?=
 =?us-ascii?Q?ZBqkn2oq9peR02q1cFespvelxcPZX5A6PMV5fVLO5fQDlYzkRZ0f0QP8swnM?=
 =?us-ascii?Q?m7wkQHiRO0EAwvPU42DMwdbEWEWbbQKyKkcYrB7zK6IeZLYKvpdWyv9pHocl?=
 =?us-ascii?Q?JqJDqNT44Qze3L9R3Irx9Y5v/IMUHZsvLWqwskBAGXTpNSgy5u+vlMPVVWkS?=
 =?us-ascii?Q?5eLfaR+kZv6+xxrqZm5GNg40C+/GvX6hDQpWKLCO7ejNEnBT1kzx3l540u1T?=
 =?us-ascii?Q?PY2gc069blICAi7c0osWSGOcSF/8HOibZ565CzJZ8eGYY5+yfFZ5OX7Q88KB?=
 =?us-ascii?Q?SXa7jDw962sx24tTDamP/NCmhfZU/vReaQoiz5LreE6UT0swEEyK+w6LQ0+R?=
 =?us-ascii?Q?WMC5zzA6XIePjgeKQr3zYyt26Z6vHBCPjO43fZr7iGjUZs/DnIkqpwoAYXn5?=
 =?us-ascii?Q?XxZWsR/fQi2WvKyLrIValLFjVaVTkgvPButQtZVqiacyRl9ibeGKAVb8wRBd?=
 =?us-ascii?Q?kmPjq7XEHG5cQJufrAKOKN3zD5c0M0Xtqnn/UDP/8jnHdN49NIb5YPWrGUfS?=
 =?us-ascii?Q?qu7idBgBjaYVBHnAb7qk/LgV3AiAha30wsyX7f+HXb4P0li6FSj2NwRtjL/K?=
 =?us-ascii?Q?iMbikG5MnAK7BHTWjZIcjnitTxQe78IMlt1UbrToYpDDV1jxkIz0PmnPE5wj?=
 =?us-ascii?Q?jbEqc05QGWtOPgHVwQaJFnR9m1x7UMcKE6eycWPTFaqt5tjaqAki1J4AKvyt?=
 =?us-ascii?Q?skFOD26jKz+7Q92qN7YL3FZH/M8tEkV/+p9AFGAuXvPCQNEfO/A2wQ4owiQp?=
 =?us-ascii?Q?EPVQQrgniFjfN60CB39k3j5HXvVuYp54FhlXZRZpOOlmJK1+8DO3nC0Z/iSj?=
 =?us-ascii?Q?UsZ1VfWDJ8zqJPqT1/MO099INO4sF+QOFaZOuL4rA6RYdcFbJpv3KMqK3Ji9?=
 =?us-ascii?Q?SLWjVuruGBe7390rczQVLJqTWH31PjmXXUcDh2P3R9pWrpenOXu2Qoc5eBd6?=
 =?us-ascii?Q?RWuBe3oNxlVw9ebqLN9H4g8XnSfS++H2EnPBYm35XVb29OvxHqTQWSp7U+iX?=
 =?us-ascii?Q?f4ctbsY6R7PmgJ8ylCemKRtdvrR4sLA1IbZGAgxybItbqEuTVNuqiyZaFIhT?=
 =?us-ascii?Q?aVYMnktvERftJxX0io5CxlLUpTFRigD5prKP7DhfBxJYJ8iJjlkXIYYOKbv0?=
 =?us-ascii?Q?miKbhEYz622WePLnZY3sVdwEy/c3b179fMOORarARKjnHPOzDHG+AdipTBNW?=
 =?us-ascii?Q?eJNMcpK+QvI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xNt0PiCkILpxD6Td9/NVh8N0wDEWQppQSqEyx/I0NljawXIHSaxW1AGNsa/D?=
 =?us-ascii?Q?q2V5S62Ksddn1lSmqN0JnzpO3LcwU7rjKcypYNmnnBExIQNqH2BAjxt2lh2e?=
 =?us-ascii?Q?AXy6C2GAHXWR9yM7JPdduB4Rrx+grFmzrNsHjoUuFU7on50R/CdHPaisHQ7l?=
 =?us-ascii?Q?dUh44W3wnC+c04v+UtOObIPIZYK78/51C6F5MVAhmz1Y1gPEl/5OgcbSdb5n?=
 =?us-ascii?Q?qw1OT6gr/M4ODxHJ/VV1JSfCyrmhDm+dVE0kiWmIhYEuFDsVSP4vuk3GlPz2?=
 =?us-ascii?Q?Gvwa88eGbqPXMmFbq0KYQpOqOLGBzd0FoAsxKfl54tIK1jFQXEPNJGIW2kXg?=
 =?us-ascii?Q?diji989ZFaIgxX6GFhiEvFGWvbuxuw7Aj9v2Q10BlL7znet9Z1RMLh7J7B37?=
 =?us-ascii?Q?k1NKTtDprVc39BVZlOZuzoBGDCQ+Qd2PgsgY6lEq8C/bz/h/tPxtzbrwa63Y?=
 =?us-ascii?Q?KsHsq7vGEtgOHJ7FhKuUvwrQ6uhE6hLcRmxmTggWPeQARLbEy2FYDtJMZseg?=
 =?us-ascii?Q?IDc1MZHRmOT1tunb5aoLsA7PBGtzaznzEgZsP2r2b3IF5ORkk9DTE6+vBO1V?=
 =?us-ascii?Q?7zQXkj/RgB89L+np2f2y83DoZTNH8+ar8blctJHMBXIabWd3IjbzHykeDPcW?=
 =?us-ascii?Q?bm8q7DdbmFNV+IUCchm3VpPKfNTItAJa3wXwK49ODNACBkw3UjSCFNmg04qx?=
 =?us-ascii?Q?7sLdpmVN/05TMAm7iL2bkr2po7iuBIyrDBSTpwFbvkcZBCcN/VBCarOQySJz?=
 =?us-ascii?Q?JsK+B0tgPrGxSQXdFmSvCtkUI+OBmpA3O9WoHKG4XycxZbQ89h+ANdfqg4jf?=
 =?us-ascii?Q?ToY/YoCBkPbcnQGR+0dm5iTPsRC9nKtI0Kq2jnsFPVIhfru7hMmBAcpfNAeW?=
 =?us-ascii?Q?etBH07IpXz3P+4RMB0l229fmQMnUC4dHQzuIBQP4xNKWk92F+LZn1R6/RmkH?=
 =?us-ascii?Q?jdnVHWuo4gq45yV29gK7VnwB/Yy8kTEiwFRscq0Ks2Zl1aHDMnKqFUdR2PRm?=
 =?us-ascii?Q?MhGQYY7lsJrKCjhOLy/2GG9XJDwYob3FVrN68iaAIxqP6PanDsdRVLvpXURz?=
 =?us-ascii?Q?YOpRsnVnmJFBv2E8pNl2yRM+ay0eCRXDvPRkSDpl39HJNWD6n9XT6LLbsmEq?=
 =?us-ascii?Q?gzw3gwrCbUQtKR5NoASRBa5QxV+Xi9387vQuDQYueAkZsSwfaw8XSjqzFThW?=
 =?us-ascii?Q?cfCkWz7bqL9N6CJFPRMmFqrpFEcUSwR8+wqFJuNeorPhNrLiuVY7CZELjTIq?=
 =?us-ascii?Q?XcW76qlpdjnyMlmbIZJOGj2ydTJ+E5c47mXA6WbVfrIMwxFh4h5QWza3ZtIp?=
 =?us-ascii?Q?JCq+RGFXeBJUhVpGeQpRWhkCUAsNo7ubyPGsCzGsXgjtSXj4WjIjLnHGg+hi?=
 =?us-ascii?Q?jKYjo47S7IDvJYNYPvBxoCUe18HAcP4nxsUI3HH0c6az39wDHuSzPw1LvZ1v?=
 =?us-ascii?Q?bJDaqHcWO0jcu7MhstKn8SrDWqlIoX4MiKWNq+uTG5p9TcLK7Bxx5kynN4Cn?=
 =?us-ascii?Q?jNEpg7kcekVHc5aTdC69QT7J7Q1Av5cY5SfZwsnNJBSxX/1JQPS03B0mha2v?=
 =?us-ascii?Q?894disKucBDy8OU5pTCmK1A1UnUV3KflXPhHnRsPL/pGGHADnurT690i1oNh?=
 =?us-ascii?Q?POQGZbEAdbVYq/30VL1nBg/bCUkhRuRawei9KWDrtDS605mLcp7RSZMO1c5/?=
 =?us-ascii?Q?+EWMaQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n3uP8HTmnpEThxCb11tmswqgx61/3uL7knRYKn4AZRg2K02xsJHEhZ/HcYd/pBKisueXlwdSVx840gnkCvV35uc0a/IesGqG6TSO5guTEaLPhg1nCvBJuktS6X9qQuZu4NKy+OWAKU7Yb5cpkjnN9wsjelg+UqyGmPxs2iJNpvn7ig/pzwQBWJLIS4TgtKU7qWa3R6ER9uY+q60sOqClJKOPgWhXLUWUIWbo5e/WDiOhwSKPmfFnyih7nsaZXBZQZem1NMGr4nkC1rcAwE2rjdq1t0ejQUsaTk/PLI3X5nefpgsfTVLJ/Nnf+XToU7IVr2QsOO90aib2PHj7fotbQtRz+yPgWXRQLjquJ+qsa/QpAxyQJdcoRoF7PjU8lgYF0Yd8kyoiM1Z7/GpN8OYZFz10VOZDanUA28lZLWutZzoex0VYHP3LySPjNtGCwi93iDY+Cs8p3n+VTwGBocr0Ygdnn2KgAhGhtA+0/ah7ZItgdrDpovU6eTXi4ESiee5SpBqkbrdbBqK47a4M9Zh0C4kHzaw2b42TtyLX0vsNKQATEtYK2T0yQD4Tt/FdIqy2Mkb1GU3yoyoPzkJQ0P7Z8Tj4HSXs0FF3MZtYyu2bxNg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7576173b-a5c9-4a8c-2af2-08dd973e690e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 01:34:06.6390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwhohSFvksgandWGdzMpvNUH+Udg4krsPngeO1iU1GIwiJvDiTUnHxVLFw+9wqYe/+EeFkTy7tPuwchpGkpX6gUdIHROq7cnEjl3FfvkceM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_01,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505200012
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDAxMSBTYWx0ZWRfXwAge1jchRwg5 KqDyDywemdtKsp6r6jb8XCx9dv2tTDPPBmsLR1DywoSq5b/cVAUSyWEOYqOKopgl0swi2YhVsrJ WrWfTvTx+bYIt1YReo0ClxhOLaKxvFMHKr5iFqmOgjOuT06jSd7JJFK97FmTHtyabsB1ezX5oEL
 5qmXoQH8Ez355qZgiH6FlfTzjRDw2wcRwpd/6SlOidIlMvtMQG01+9uZYKr5pHOi2rkgc24M0o8 u4tKLeY9IrRco40P0p56cxi73gHvWo+avAYtxd6/mZsLCdw32vj1RdD5X8SViiAodBTyPn5uS2j zFlKElodHSZ54AxIVAAd32VDUtJ+4PIDUP4kZ4DhCh0b5Yqp+PIxTw95AiACKOd7OQo5Kvb/95l
 BkFpqCccw2W2s9UxYNU7Hufl/yaMvzpiX7ih5DQto2qBS22Hy23la1DAvw1gApzpXQdCMlxI
X-Proofpoint-ORIG-GUID: cU7seuSRiV3D72XAXOb1GOk70zjnQHw7
X-Authority-Analysis: v=2.4 cv=D+VHKuRj c=1 sm=1 tr=0 ts=682bdc14 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=ZHJybXuDlUOdVKnBWFoA:9 cc=ntf awl=host:13186
X-Proofpoint-GUID: cU7seuSRiV3D72XAXOb1GOk70zjnQHw7

From: "Darrick J. Wong" <djwong@kernel.org>

Fix some bugs when detecting the atomic write geometry, record what
atomic write geometry we're testing each time through the loop, and
create a group for atomic writes tests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 common/rc           |  4 ++--
 doc/group-names.txt |  1 +
 tests/generic/765   | 25 ++++++++++++++++++++++++-
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index 0ac90d3e..261fa72a 100644
--- a/common/rc
+++ b/common/rc
@@ -5442,13 +5442,13 @@ _get_atomic_write_unit_min()
 _get_atomic_write_unit_max()
 {
 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep atomic_write_unit_max | grep -o '[0-9]\+'
+        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
 }
 
 _get_atomic_write_segments_max()
 {
 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep atomic_write_segments_max | grep -o '[0-9]\+'
+        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
 }
 
 _require_scratch_write_atomic()
diff --git a/doc/group-names.txt b/doc/group-names.txt
index f510bb82..1b38f73b 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -12,6 +12,7 @@ acl			Access Control Lists
 admin			xfs_admin functionality
 aio			general libaio async io tests
 atime			file access time
+atomicwrites		RWF_ATOMIC testing
 attr			extended attributes
 attr2			xfs v2 extended aributes
 balance			btrfs tree rebalance
diff --git a/tests/generic/765 b/tests/generic/765
index 8695a306..84381730 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -7,7 +7,7 @@
 # Validate atomic write support
 #
 . ./common/preamble
-_begin_fstest auto quick rw
+_begin_fstest auto quick rw atomicwrites
 
 _require_scratch_write_atomic
 _require_xfs_io_command pwrite -A
@@ -34,6 +34,10 @@ get_supported_bsize()
         _notrun "$FSTYP does not support atomic writes"
         ;;
     esac
+
+    echo "fs config ------------" >> $seqres.full
+    echo "min_bsize $min_bsize" >> $seqres.full
+    echo "max_bsize $max_bsize" >> $seqres.full
 }
 
 get_mkfs_opts()
@@ -70,6 +74,11 @@ test_atomic_writes()
     file_max_write=$(_get_atomic_write_unit_max $testfile)
     file_max_segments=$(_get_atomic_write_segments_max $testfile)
 
+    echo "test $bsize --------------" >> $seqres.full
+    echo "file awu_min $file_min_write" >> $seqres.full
+    echo "file awu_max $file_max_write" >> $seqres.full
+    echo "file awu_segments $file_max_segments" >> $seqres.full
+
     # Check that atomic min/max = FS block size
     test $file_min_write -eq $bsize || \
         echo "atomic write min $file_min_write, should be fs block size $bsize"
@@ -145,6 +154,15 @@ test_atomic_write_bounds()
     testfile=$SCRATCH_MNT/testfile
     touch $testfile
 
+    file_min_write=$(_get_atomic_write_unit_min $testfile)
+    file_max_write=$(_get_atomic_write_unit_max $testfile)
+    file_max_segments=$(_get_atomic_write_segments_max $testfile)
+
+    echo "test awb $bsize --------------" >> $seqres.full
+    echo "file awu_min $file_min_write" >> $seqres.full
+    echo "file awu_max $file_max_write" >> $seqres.full
+    echo "file awu_segments $file_max_segments" >> $seqres.full
+
     $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
         echo "atomic write should fail when bsize is out of bounds"
 
@@ -157,6 +175,11 @@ sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_un
 bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
 bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
 
+echo "sysfs awu_min $sys_min_write" >> $seqres.full
+echo "sysfs awu_min $sys_max_write" >> $seqres.full
+echo "bdev awu_min $bdev_min_write" >> $seqres.full
+echo "bdev awu_min $bdev_max_write" >> $seqres.full
+
 # Test that statx atomic values are the same as sysfs values
 if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
     echo "bdev min write != sys min write"
-- 
2.34.1

