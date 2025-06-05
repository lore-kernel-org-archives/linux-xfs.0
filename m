Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12EA136E;
	Thu,  5 Jun 2025 04:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749096102; cv=fail; b=iiZq0fmBTD+Fri4oTkJdD3b/1qnGLpLvj4HySXTLihnZPaaJbmjHcqWm1ofruGoqB1LnTlygWo8ljkpXTwr/0KZWMK94ywT7MzOkYFyvqt7bR6YXHC/BOAbTG8JHlji9zNusbSUUgNYW9YT9xYz9t7DQETICvLVeLfB+nZ642gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749096102; c=relaxed/simple;
	bh=+4y8N8O23ybZJMYVuydf96QDiX3KzENn6QUCungJTLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kvXVaVfEOR/OoUdLFHnUWRPzexSslgCsam7KhSYMtbHxKfUP+03GjG1uclAm4gBGx5a+lCVAttjl3JxaxsnrX/LfXKoizGf+nRPt3AkuUbbEFjbZFJnz6ijbJqS83fPChtS2dmbrBOsBLyZJkYJ9041EAQHPfInIm9H3ZRXfXfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g4yHbs2T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nsCT65OX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g4yHbs2T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nsCT65OX"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5550feMa008581;
	Thu, 5 Jun 2025 04:01:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iicUiyTPTMwHo//DOScMZOfh9vSeF0bYfdtp2qgAC+U=; b=
	g4yHbs2THjY9tKHN4AEzP9k+alcASmlVF/pw4WgMwTF0bKesAsWSJY+m5CjwNVdr
	19QxhNFcKppD40Ge5mTY4s+PK9Anu0CcZt95ZJmOg8nEJ6yuxaw7sxNdELesAdwB
	LNadtUUQO4R4Cg9bceV6gQzuey+JJoEGjGsVMpEXtSFIbLI4tP4xrSlU3v5mSSIi
	GFPi8b7B5p7Kj6O5x7mQXYcgkp5PGkD53VTOFqMkD5HgTuWZ3EI7jit0+Qk4dBjB
	U8CnfWLTi4dekLfCw24jPGLiIGQAYGx9uhhJYACjIkJIE2iF590LAwz+aQW5cgbu
	9uhLJMIQ8YQH1x2e61fH9g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8dwc5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 04:01:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5551C5Ip038485;
	Thu, 5 Jun 2025 04:01:29 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2048.outbound.protection.outlook.com [40.107.101.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7bke7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 04:01:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e6OQsEe4g3MdS0ntLmPCk7l17ikjWW2TtyVekoWdW0xNzootNmKW1SfMcvoRAa9hSVVc/fxdK41cb1WGKawD2V1w/STDAfkCfg/Si7wUJyKtMewCnlEcGGTPa9rOqSyp++BoQeNCdbBVi0UqQhEilfLx3xxNfRh+vrC9H5rOwoLUpFXxgNb81SXDO4p6siOvZNkoRbLw3y1OK8LiZgdYvJcebiMEATHqE25TyI/TyZT2UzTZLx2D3slpFtQetLko/4HEpJNZNTQUHN3iwRHiOZpRSYuzhnIQAjK1iDgC7ns/5RnvMYNgKsD+38mtW0/p0lmOjT40RxfxFRziO5Yt3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iicUiyTPTMwHo//DOScMZOfh9vSeF0bYfdtp2qgAC+U=;
 b=oG2yZTRfhCPuDQNDon5bwdy9nk9OhoAx/hlYYENNXm2okKl8mjB3oXDT6KLiaFIgQ/1Eh1OH7aH8VRatjigtGDcB2XiHmpmr/9TZR20hwwlAiuOONLFt7NMKci4EVZSyb3e9h3Q1nnJHs/SiZLO+BJ4pPGEjM84tlnF97FI6LQOw2xIdMOrXHYSshYVFV92go98QRDFLPuNRwgjw7UvZJq1pYG3EFShfCfo9U3I/FajXgkfOXFvDfo7MDQ5OhAVVXpvEzj8ajtc0FsVDKCruIlTq4WleWmvWa5ice7KARij96oW2l/3hg3FqGxbvdSSdSqJak5HGnaItGF9MeSrC1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iicUiyTPTMwHo//DOScMZOfh9vSeF0bYfdtp2qgAC+U=;
 b=nsCT65OXnA/KEZdOE+zZl/56nh3K2DJkV/9yLKULe1Zp8rvGS2pSVSzST3asuceBpUr7eH4biTNR1aAwCe+wyWYls2xVI+HQ/Mtv0NITJHutXjzsS6wfKvO935DY7DO1jLRPweI0/dVHZQUmhOH197q+LwgTFFH/uvvM8WBuZ6A=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 04:01:26 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 04:01:26 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v3 1/3] common/atomicwrites: add helper for multi block atomic writes
Date: Wed,  4 Jun 2025 21:01:20 -0700
Message-Id: <20250605040122.63131-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250605040122.63131-1-catherine.hoang@oracle.com>
References: <20250605040122.63131-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::20) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 57c8d89e-ae57-4098-22be-08dda3e5a4ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|10070799003|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B0Yz/j78lSDZh8b3teb2EX5YNtmsDJPQce+OhUjYQkamo4pawRVmKfEAmKEM?=
 =?us-ascii?Q?RhzYN2oxvrDU7sPWfthczCkqzEZVLEDONG19vusQDkyUGSnEKd8uGgZGWPtP?=
 =?us-ascii?Q?mwheKZ3DaIQnQ5FVU0YmdMI0hGvwHQ7ovY/ddC+NqQMEunym0JN1m9qB/Xj+?=
 =?us-ascii?Q?uEltD59f6Ss3/O23ob9ScQOqQQkpLXJEOASwjG6qGTZ/sh6KuM/YiETqMpcm?=
 =?us-ascii?Q?WAnt1cwBoZqTO9QyBuMYkB34bi6Sfom8TV8Ds/glIxfqrDln0mh+knyXd2bq?=
 =?us-ascii?Q?H7V8XRp4yJv7iRa5fNKYduiIldgl9rwbmhLsvJqnVl0XdY5N7hKi+gU/Z+J2?=
 =?us-ascii?Q?3YXJfAZF/GzHWBCiDklx8TNc4wvmmRef6DG1Q2OEhq+vEpGB4hcjPpYkkXCr?=
 =?us-ascii?Q?ZHH1hmk1CBLVs716PmnNPV13xh6lAiBWvIWI+DUIvnlE2DSx4O5XKZ2seDqy?=
 =?us-ascii?Q?eDxVNLoIk0wS+hq1p7L79+/Dni+snv6OF0hT80/sd9hnl/gnj8SZ5IvbXwpi?=
 =?us-ascii?Q?NwcN+YcZ1O4OWLgislNqFDKpc+k+lZqmuJz7BebBKRpx1ZpgS+/iT08ivlMT?=
 =?us-ascii?Q?j5qAGuBcDKHYNPC3vUnDwqhd3YDPtpMbT21TEtuR38TZt12bDGBNgtcbJDNO?=
 =?us-ascii?Q?U9Dy7lrk+NsH1IdrFqk9c4IxnHFi5J3GncvA6qDWKM0M2QPGaX+giujDqni5?=
 =?us-ascii?Q?Faqr9s9X/Ih4EiBSFnvYRRzynnw44d9SggH/c/IPmvANaFmREi6jlVW+PvVs?=
 =?us-ascii?Q?EVNp/gKWn0PjEfvGMop7X0UBc4Iz9oL5gPsHdoYM3l7qfe/qSgvsEfm74K7T?=
 =?us-ascii?Q?f1Zx81dTWApRqhMNxRYKAogLQQfX1I2cdSrL1AnCTtj2LWzPm+8z6NsJOA7B?=
 =?us-ascii?Q?eW3AGZQN4k9VwVCRBb4AKK3mjbQCAhpy4acQECDjQIQf4egP6Jr8h+uV96Jj?=
 =?us-ascii?Q?iqkSrg9yz0in5dsdtJYSBdXMqEOiMpbdtnMF+gFPeet9C/mw3kxpgpf44rfW?=
 =?us-ascii?Q?ARcyhfIaSs5FZ+sjPNHh/LEodydJH7gpOLJqerila8Yl84QaCTB2XcUKjbyt?=
 =?us-ascii?Q?iTz1yxzNH1YHER83jdACiB1beLgPpX++Nd1296LyTEXlieAXprhz1k9BexKC?=
 =?us-ascii?Q?B+IcJQyxGq0DEXpbTDW1iZpZYzgBKQuBKjjM7OTEBY09jcG4/7HavROvqSWv?=
 =?us-ascii?Q?L5pmcIdjmJ4zQ9zKNMS4Xbe5KaaRKJwV/TNc17I47VCSTxmbhrhYYcSpmMkI?=
 =?us-ascii?Q?crm7ZwesWxHj+FCwr1f3DA7+vVGH4SbtjtQ8xiB6iMtMm5LnPsHp6MgBY3U1?=
 =?us-ascii?Q?5cnZHkZcgBFJqiqh+lVqvpctNrz711U28NKjKmhIFNOJsoPlcOlhSmjK5V2E?=
 =?us-ascii?Q?6tbPgSpPHX1nclPcZCXqeqopnIFkkbqv33jQtm+u8Xc7Y49V4fSSe25GAnQa?=
 =?us-ascii?Q?1y+iLa5tLOU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hvYrY3O8pbDXjdF3hPTAPlbiyfc5oUgfBQnbkAewsz/jjPy76/vlb5RtKL+r?=
 =?us-ascii?Q?lUSGrEuOcM+ddln2peHsjaadSS2tNAYVazilBtuIOMNca3PxvFfheq7H1kL0?=
 =?us-ascii?Q?BSyrvcwV6eMFBnWh4hApmUeHdeARqqHYg3+oqiZzJKp3FKUBqQU1Qlb97iTO?=
 =?us-ascii?Q?p1PrXrb4cPPVHVLG/MeEXpgE5kXn0KKcVI64dF87gGjjzQhCzrFrEFzvI94Z?=
 =?us-ascii?Q?+7ywlUM/FAKG8TtpWe/2v9qqo3cdTFAm8LAhEVpO2vCwdz4qR8MPyuiCfxMZ?=
 =?us-ascii?Q?SKrfeMDr3KKrju71qC2xuJCkS6ILOv+SDaLdW8jX+04e6MmpaoJh7sainFnR?=
 =?us-ascii?Q?FmW86eoQsY5yTaQUUsGiTuKkIv+UxBXRt9H1dx1rkCzDhxXMIc0bGmCenMw0?=
 =?us-ascii?Q?59QUxCWr8aFQRDIz5rkzMrP0+ImOP9gVyrbe0kPgLVtZNyrabK+TN49yG9DR?=
 =?us-ascii?Q?ljeviYMxlODwOZBjhYpCW0ntybpVkTFZptkMnoI2R7c0I2d7rK0ZdsE4tuV6?=
 =?us-ascii?Q?s0ZQbDvZ4MclmGcjRBasbF/eAA9b4+diVwgHFyxXB2/QD2ifr24HWut6uyxj?=
 =?us-ascii?Q?BwNuZygy6No67/X6FY1wMWWo2p8mpeP6cDhV57RjPSh6R1HLbA8j5baOJcz5?=
 =?us-ascii?Q?9wPMlqb+HZdzRdM23LKRufTwV4pGpaajM0tml+Nx0hjI6ej17Eq2wF5cEikf?=
 =?us-ascii?Q?Kv/SlgdKEQaIdpbMl2atVIZiklN34xJ0+kRAOnQb+lt4EgVaHpDoxGirmD9C?=
 =?us-ascii?Q?VfdE8ei+RL4hRMpTst8zZEBGJbTD8DG/JmfyxSAotOXJWeyJ93JuE+xQ0HkV?=
 =?us-ascii?Q?FW4ZuB5yqCOy3FxCoQ09d5vy7TGCdU9eY+nmPDXtv/6LkgqIMKzC5B794zzp?=
 =?us-ascii?Q?HOTV/ejaideh09SE05OsPQccSoXZSxtYQXZUv6Jdk/qe0zfSWOPjBQnU5e8N?=
 =?us-ascii?Q?cOVLXDVBzyOHK8++tl0aU6Q5evD3n9WgtN8LyLMP16u3CDK48qwUckcI30/7?=
 =?us-ascii?Q?HEZ1y6QnkNVFYXF3iV+3Eb8W32U9AVr55YKxUiPZPsakw8ry6aB/y5k7UYr3?=
 =?us-ascii?Q?7gl2SsuLGlPOyQaZ3XGWAofdqf5b8XVEhtUuCqQmDz948w39sSOrPAqQa3lS?=
 =?us-ascii?Q?9RvJyqEMEovp1Advif7W/ykhpXWV8RBOV7KpD5eXnroQUavcZc2klo7ECX0J?=
 =?us-ascii?Q?eomwIIU3uNT9g8Qf4HySR7VpTVfIj3NQT8C1PPjxtzGBmTsVzpdqDP5uYXjQ?=
 =?us-ascii?Q?ueKzl+vJTzBlrqVRkmFfENPlB8SKgrHTiz8qGt1gFHIEIIWKu4MTRsbjS5/W?=
 =?us-ascii?Q?6BqrDEipcaXfvI4kQsrE/uJTQ6BEOgQ7cYm8EUgFqxaYhrepvgW+aJKkxlbh?=
 =?us-ascii?Q?LkYBfmaiZGyB3cwr/mcLxPZctfu460wWp7C1ZGJDaa/W+oyj4IeOjgmPigby?=
 =?us-ascii?Q?u6DCdTxjw8CsPZxrxGf8dxet8mgG24j+S0TLSE4OY00R1MNbhEzeo+aJdKOZ?=
 =?us-ascii?Q?B9RofgeMSSUz8auU6CKjAb4pQTqsuVzHXyibb2Sfiqmz4MbK2bFAzcgIZvce?=
 =?us-ascii?Q?MGojvwI+pi5wxKle+hVG9jR25EUJtd4jWsb1u3e4Oq8bNplaIqWr6XjS0OFg?=
 =?us-ascii?Q?ryIIHYNTxD5oK8FonXNKyYdoJxcoHnTPqH1SSF1QNVFNrNfnoplRK28K5vCo?=
 =?us-ascii?Q?LgvG8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FDhKs1Nowu2HDYEpHYTgLgvB7PCyKUsCqDnuS/yiNsKfkHMK821cXypAsr/piKS0r9Q2tE8W0bu1zNatOIca8cJ7HBcMNHj0/d6mP7jfjdYyPF1B4G7kVqhnvoT+01UztWDx0X+oMu82q9mkkDdvMaaVyZWbnzg6IIAm9641p2N3Bwi3kznWxbDTwoK66IOCyJ6la+XhXvYsfCeh/WLFC6VT6Srup3igETZoaJHHS7q7gJOS6vi3QGINi6+O+YCz4KLLWniGg79MjUI2SyrqoxZFqGO2ETPUdhTJJOG1eA8HupuTwM1v5fRYxe3TA9rrmespORlmqgbayRXBpuaOc5CSGwZGY0fzVtU6qf549l+i8ZR42Hu+Df/VYa4+Z1TTpk4YItTw9V5rpRsJMTi1cP7xJI10xSHsNhe4otwXsL/FLTvH/hzVZ0f7pBVdBXbopRNrRy0Zfdy6kziUWTuhUB4G9lLU06Q1ugwlHZ4a6sthDZmOJDH4KRlekDJD3kYv+Yz7Bb2uoHLzxlmicJamX+UlUIVLni5OJhomfQet1wxBIM+RMrcEiRfJ/z+pKxSJGkrHeH6hrS2GHBZa1o+TKF6XlMaVbqqvGS9mk0TEu4g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57c8d89e-ae57-4098-22be-08dda3e5a4ab
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 04:01:26.4992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N3uCOTp9nNvIG+E74X5XLubrcZykrL++D/WhSIhYh9LDJkYD7H9kXKIunk3wCDwKCe+OYekUx8lGB6UlGO7CFUn2/NdFVSd6muVEFj00Ewg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_01,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050031
X-Authority-Analysis: v=2.4 cv=Va/3PEp9 c=1 sm=1 tr=0 ts=6841169a cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=L8bW6fCH-4Fpt9E7LqYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDAzMSBTYWx0ZWRfX925huPRfksYz S+RvT9+7qixwgIf3szX9DvIXGNvIOhw1zRkPgwwYecBUh2ggWfEeWCto+8GH/yT+sKTCBnFYIa3 wUzXkMQWvI+GKj8dXsonSO+VJ8jKjM6Uq9F1vMtpx/64bqYtxTwCyc/XEKQUFoBUXCPlNh74f8O
 ATxIJ32610GbxRUICmmNpfOTac2KAYWg5SIKToE7I3YR04lSvVFtA+eg6pXuXc6WvMTC7mj1cD8 ZFvoWd26KOEz5l4OHL8csm3YWr8t9bc9VxPPSKIJfhxMkEH99QsKUcz7SMMQhFg46ZTtArtvk+u qQVeRkhaW9epi3WNKDF21NuLfoeFU6H1kMUnqbPuDUWGcyNTiS0Ua6fNQWVdQThW9TzrsF/bOAq
 VPsfWTEzOojixUK00jVhQ2dxX4+B9XU6WIe0a44nc5gaZijjQMPXe6Tx3RFcfhP3c19ixKJT
X-Proofpoint-ORIG-GUID: HdUun1YOwdGONonXWdSTkPWn41072O6s
X-Proofpoint-GUID: HdUun1YOwdGONonXWdSTkPWn41072O6s

Add a helper to check that we can perform multi block atomic writes.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/atomicwrites | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/common/atomicwrites b/common/atomicwrites
index 391bb6f6..88f49a1a 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -24,6 +24,27 @@ _get_atomic_write_segments_max()
         grep -w atomic_write_segments_max | grep -o '[0-9]\+'
 }
 
+_require_scratch_write_atomic_multi_fsblock()
+{
+    _require_scratch
+
+    _scratch_mkfs > /dev/null 2>&1 || \
+        _notrun "cannot format scratch device for atomic write checks"
+    _try_scratch_mount || \
+        _notrun "cannot mount scratch device for atomic write checks"
+
+    local testfile=$SCRATCH_MNT/testfile
+    touch $testfile
+
+    local bsize=$(_get_file_block_size $SCRATCH_MNT)
+    local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+
+    _scratch_unmount
+
+    test $awu_max_fs -ge $((bsize * 2)) || \
+        _notrun "multi-block atomic writes not supported by this filesystem"
+}
+
 _require_scratch_write_atomic()
 {
 	_require_scratch
-- 
2.34.1

