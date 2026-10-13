Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1313F4125;
	Tue, 13 Oct 2026 08:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879394; cv=fail; b=J9dmvLblpyW3qDBX8MAuHwufNJErHIQgWVZeFZbGiP7iF3AQpYXy3YKkz8EyvONj43EvDonGU6Fr+lfzSfxy2wl49ba/ayTms8RZiMRPWk0xNhrWOeYSWOg6QPRmt9Zms8X/dWPIfuOQk3PWWhS1klJGNhGkb822q6N9pueMOXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879394; c=relaxed/simple;
	bh=/ABxByly2xahCvxnnNK5zTV/rUW/CU2fb118Q//KZfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qkT8CQUMnZDDnNF0LI7iL8cmtk2rFe/Ct8I6NOZJJFnboj5Yw3koUeli5ptVAbWqz2mze+q9q3kE6feZtP7Lu/mrkoHxkqDy+GbJEpwNbL3PqBpjNlMn01TvKhc5MVhfEhVQsya6V5WSXFERDHcZO1sZtjMLT1GOsuRUrHT4yik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LUEbkBGn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qFqql5v9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LUEbkBGn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qFqql5v9"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CSOZ4061657;
	Tue, 13 Oct 2026 08:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1Z4IUJsZqIou8LEfjiV+wwFxe0ODmmEk4MjnBWvadgw=; b=
	LUEbkBGn7NHaN9/21hUVq1bb7i435/F8MX/8DDsaxyMVQls9KbpBzI382T0L63Mg
	bmM6pA+w+VqzUdaRNAh8jiRGH4J9CdVBYQjwH0dCFEo9P99iHnMDsKCZ2+W8b24z
	BnK2KIyF6Se0Mrt6tuwkTGgwQjw2r+ASa+4PhKvHoEsZxKu+PeLKcVBw+a5pBHqA
	/nfls0FisIuhpkbG2n6TlGGstoWaH4Xovrjs/07ajc8KdqRp7EbDNrfBZl85QGMp
	9G0dAho2bRw4GIwrQzVua2PZnfGoL/15Kgr3OpDAm9w8FzJfwTUHjCwB0ds7zfpG
	s4qZqLgW/mpEhDSvc019mQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkkvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:16:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86gvv033459;
	Tue, 13 Oct 2026 08:16:27 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011064.outbound.protection.outlook.com [52.101.62.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btnxt7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:16:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=th7frKrMwljAo2rUbCHRkbjAEf4WP9xaaN0pMVxxDkrPsV1PHujWEWXfC6VhorYw7ycVboyAcvl9D1iVbJplfdX8nTsmqCe4bdKjSqxF8BGXMIUU/lZqF42x9xWiKr8GeiR+dVHMFyf/v76rvAWbHattKli4q1vNOT28eSu/YyTkbq3YKqg2L8QgFUiXjI3bmLG0xu7Lcm+bHt7zo1php0ZbHqIsOZ2AhFoBUFQ7IDlWoX41kCHooAd3Irl4HMbydZwgO/P+Dz/vWIHsKY1zP4Qxp5zfgxYsJgYp4BC8kFAnwLuexFhoa23LtuUYt8xTxYrAi+gzOGGEl2QqEC1Jxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Z4IUJsZqIou8LEfjiV+wwFxe0ODmmEk4MjnBWvadgw=;
 b=iR5/qqTjSpjj0Y3AsRsMp4acggq37BHX9oHcSw3GH/minzqwEAp04DGNqzK6D/SjDGhWi2eV2haUhYpuXLpydrvMWmF3wuu2tvUAzRAlqERCJsF8B++ITJ71YcM13rJnBHFiH7+GDH4grwXIpvOdbNKwolv2b8lU54xRY+o2M2aIslEyKL47WeIkcNJtGz+eUbRqKwk5QV0c6a+95NKi3ieZrMcb0f7DNZZujd+FI0ds1r1Q427df6BDiDe7xUtkTcqz+4ZtsnRiarpHoTY2aaib+iNNN/F/enZpxhXovPw5B/DA6/kirdG1LgafACcnN+Vl0DiNHHXIaJwCxUkkZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Z4IUJsZqIou8LEfjiV+wwFxe0ODmmEk4MjnBWvadgw=;
 b=qFqql5v95IAtA/xtwJwtfC4x+YHaMi2CsCbgcPvDAHRu0DSqT78AWgJWg7vX+YWHNuU6ajxYV1V+ygthJ97X50V0nvntA+ZaP7Iyx1dBBE8AlQ8AuoTfz4d2CmRrBMyyOOB8VvHkW6f9cjAwjKuiZqmrxeV25e8/q+N17nE3oC8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 PH7PR10MB6507.namprd10.prod.outlook.com (2603:10b6:510:202::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.10; Tue, 13 Oct
 2026 08:16:23 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:16:23 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 16/19] xfs: catch stale AGF/AGF metadata
Date: Tue, 13 Oct 2026 13:45:00 +0530
Message-ID: <bf150c7e5c060160c6c1f08eaf00f3c47f411ac0.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0017.APCP153.PROD.OUTLOOK.COM (2603:1096::27) To
 DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|PH7PR10MB6507:EE_
X-MS-Office365-Filtering-Correlation-Id: 03ea67d3-82cb-434a-0a90-08df290244da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|1800799024|23010399003|366016|6133799003|18002099003|22082099003|10067099003|4143699003|261009223027099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	78KBB91MQIlOsIl0S4GTi7pKE4AYODa/p/Zd4+t9ZXlCoGnv5brqs40qu9scWUgebaWMjHe1A45EmMPg8qoCY5ad87DLpkvUdtC7HRtKtmJ7fq9n5M+WChHzf1qwz76DZP8KwZDvCIkGYaFyRioZ3mGB2RgIhcR8lcbeiD6CruHih5tg8bMAiO8hFsH0O2ZigE9Fl8+KjIlKlVz+13C4GU1eONsQrsnyD0ghblv51mtb918Ms7f2Vz2Z+FQlKUZyw1Veh2cuGdDU3GvFiUpu5dU6T01mpm7q6mXmbmdsqfR1W7A9woWUrfgpPFepPlzxByGiJRJ/DubagJq3CxBr75B2Q9TqZTkG8S0lwxwClJa6Whc/u8D0VvyVn0WUAIW4Gq2bNiFWtMJx7gsX9RRvPTbyed7Vyk1GlQ4Y1EBWGTkbBoQwIS0vSJ1fvTcv5GKu76Cr6PzwG+Zi/mIum+RBNvBo6T0rFuTTc5auu0AWYzi2Bsmu/U0PDGVNnzsJnOCGysMVTrQWRzHF1IvMcm02rvlouzFJt1hER3X/p6UFOhWs+JuUw087LrZgBu5zt6opGGWLDOoPl2ojhIpk9BpJTW6txktXcinhHWy683UeOlVHcGXUtsm5q87Vwu16ivhqqYu1TVRetn/X0NAW2ucGd3RQWVLckVVhTOaIeiSWCZQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(10067099003)(4143699003)(261009223027099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B2JWRcuID+Y5rZwzoywKeBM6yC+sJpDSIrh2gz+8Uha6+PGK8AqrhOiQwW3u?=
 =?us-ascii?Q?ncJ8LSGwaEIdPmy+8SOdJ/IbEewx/g1xWwK5MCQd2I5iHegTmhVk7L1XGNsO?=
 =?us-ascii?Q?EWmdhGTc61AzEUP1OSznMuEjCtHg7X8bIc4HcC6PS4bqS/dclWh6YzZg60e/?=
 =?us-ascii?Q?BbwxFzN1BSPh2bAe91aCIWymcoRinN1lZI24fSJM8EsTJUGufvywkYD4KHtP?=
 =?us-ascii?Q?H19yoz4pfQyIRqRvAlC5pXSQxDOlsse597TFJyJw0uEtgOtXu9ry7iK6+TRD?=
 =?us-ascii?Q?4o5JBVKZwQpoe58D2c1y6Av0t1DtlQipGtC5XIaAs8vpsy3vad3m0fhNeCuf?=
 =?us-ascii?Q?AwNWIAjL6UpkWaPFK+dSbnxKLPym9+3rPGpaD0C0govqqt/4HD5wZkV5nttW?=
 =?us-ascii?Q?fAh4AMaq8Yb3TIMsf8OZkuFi4IP86GPCRx6Swg/36wamXqPnSt1EjpHa6A0X?=
 =?us-ascii?Q?Uit9R3YVjMbAMuuTN1OSDPB8QUDBAvknW/eMJcfbKVhEOFyf/YJjs3woaGgS?=
 =?us-ascii?Q?3HAWq7s8G3syHKARX5gENFTmmuUGwWyboFP6joQtW/Ww3+Ek+xusYNQnxJs4?=
 =?us-ascii?Q?gTdr7xBj+6BFDGr/zi3ttPO4GxH+mUCP1tYH2zj+s7fKTYgxIxu4BDEmkuoo?=
 =?us-ascii?Q?HgHK/j7Uecn6BrGsz0KENGDX6yJ+5R2v+3we+nghAmRwB5GLlszrMNtXP0zL?=
 =?us-ascii?Q?yWR8feBjkNGTBIAyCN6Oqm0MBa9l37KDJNz28g3CvApjXuYZz8/bMJCU9ozW?=
 =?us-ascii?Q?vzpKN78ZySFaYoHMj9iJbbpV598xYKp86+hYWKJd6B5w/o+B1YbEUkYG9jys?=
 =?us-ascii?Q?4OTdB8sJpkpKepMIzimC8oxdlIC1mQB56lcft8pmPuKJD89srQ5C64t/b3a1?=
 =?us-ascii?Q?SsuktJvOInikctOHfIRXuDu7+b7Ud6AtC5InzY7eVXsIs+8ewYXMfRJ2PUbx?=
 =?us-ascii?Q?Xy4H/yEJMoRLWJgy6ZiNCgjc+K+2YZHzLaYxhObApYTOrQrcZaTACN07UeI6?=
 =?us-ascii?Q?5/xAUBt+F+csxhNi8PhHCCKry70l3KZYdliq5Wr713E2eq9ocZD6kG9rKnv+?=
 =?us-ascii?Q?aBC6252giDIx54l27dZfl4Qy1w+R2cLl697TVOdpizhjHOXUUQbPm/fuA4JE?=
 =?us-ascii?Q?+M4Ci8ViA4PO3+GMA7+9g51IEPJnYPLf7yIJIBx9Z+4HetTw35iQnF3k/2wS?=
 =?us-ascii?Q?+EgmeUbnxHdhqeBcVBzjMZWOzKpE7Yt5zyy5yrGR8jm3HZ+ll+z3ky83rU5i?=
 =?us-ascii?Q?Exv04Yg5sz1GXkRDeISR1WfuPhm2MClyOAhI/+geuh5WsF4v6ZMcRJw8mpXz?=
 =?us-ascii?Q?mywIqZ0tad8LwZR+NFkBoirtoArkIC5iaQByJRyiR8VD4QO70C0RjTSEpsVQ?=
 =?us-ascii?Q?OmBL2gGb/vRRXzoigFPAsQ8upbI1HR3eWnTbD1JhW5955UdzjOlDNM4ANz6o?=
 =?us-ascii?Q?nvcbFTgNaapG1D4Cy8u54X0vPqfAU2/ebUUkQBsfZa2HTcmMMCch85re5Bk3?=
 =?us-ascii?Q?JdSw+aSJmBfjyfWR8toyFwslUUiziK/rf+t9mLJ1bw3boSMGy+WC04/B+HQ6?=
 =?us-ascii?Q?Oy9PHL0+gVfHaFsyz1U9FcTdXLxPacdt+pSuNFrruFaYq1mcH8QlBTJQ98K7?=
 =?us-ascii?Q?Ypt6yYz0iWGMUH7b4EozKCAbjAg1ta7WaRGxMKRoV/CUfIClCJuGoaOwu1vb?=
 =?us-ascii?Q?mxcS1fQGYkizS8nZEr0ZLOMltmZTPEDZpqHplPgC2VTmsip+zhCnoYvG0POg?=
 =?us-ascii?Q?iuaAvx4YnV2MQ6Lkxzxe9DhWOfpKXSienuqk/JsTfc5pvmxbXmoPI61U9eZE?=
X-MS-Exchange-AntiSpam-MessageData-1: DrDLr+CHf9mLhmnX9+Lbnex3LcWfNr2K9Lg=
X-Exchange-RoutingPolicyChecked:
	oHcjeQSoxCqPSFlHbmrPvjDZkd6XjgkQ2dqjQKOxHH99wrMR2ySBRn8lmYIF2moxlgUzcLHUmpJgZ/gf+75SrcmDUj8gNTxE6PnJ6JT61mF451CP+fGFKqGEZvHQrVra0/9Cy7jxdeOFlhb+zJS1PZJMzYD3vdahVbNjxN26qLGZ1mQg8mKKjyiJ0zFNyuDM/GWdiJqgjy4pZVBL0r2swj2G7cnyewNt3fldTeJ+8Q/18yNboYjg6HGNHHXqvRhBafbtHa/T804Jt12tOrJqgXnlH+1cxjCIFFYAcXdyvoBBpq8Y+UPx1azRF5iv2tBqaNnFbSCrp9yWlb6MLBRA/g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i/mxW1VeV5h7SPORctNxtlIB24/h+xQu2gq0QyUDwZPaBt5bq8CCdVmV/Tp/P5AkychY/p0GfFv0tM93+uh+RJlCt0Mhev+5VfaKUO8XGJBRHgQX9sfBkJ2efKNVcKlnMlzh+RhgIlqwL7evrT2kIkEHBkhfzvAPvQm3dsjK6jIxUmUAvXQc4J6EuPaxmxQyg85KX5D+eQ9nPtiZtgxYO2hpEWzekaZpSgWgYc3jlzoW/WKcT8LN3k7lqPXcdDw2I5CUZ518frXtd6ECbec8keV9Om9WiACGoINdGS7keIuTRWDUipWDsOE4ZJ85hYnaNyw1N/Yj5ThQBH4QT9oG8XOVS/oc3woWYHO4SNF8rE37NB4xJXUnJ0cozQO1ImusYd6zAoyq7xg6gSkHAInaTxubcO90acVJ1SUKeQH/mG4/A1exahiCZJDglrg0P3f+U+m4VXjTuQiDHk+o9wqFFuHZftf09qQgRpRUuyh4nxkbfLVmQ+HzQXE3KFLl/q3qCK2Yz/1Z1AxGBc8k6qEbxfFhjGknx9zCZh0y8UMDiFqAdO0vMdM6wkfOtOlCpjwxaBUi/YcR1fYJIgogAWKA3Oea2eo8orjmQbLRsefzWoQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ea67d3-82cb-434a-0a90-08df290244da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:16:23.3452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xy0mPcgBzlMiJZ0uJqAggxc9zpq10/Y0NhffWgxTeW5D3+Qf6B2pyKki0toHniYDhP6qn6rDDThUf2eIJhCbjuUOq7tepxihLpVX4Vx4WZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acde8dc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=pCazNFhamJdtUKLgDfYA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-GUID: Hk-oR1fOpyWsyyfhprDHROf3q2-O6tst
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXx+NxmsA//TmZ
 aCdx6hWhCtgzi1TMwwFZy/7E3s8EhTkzOM7tUBjdliiJ9B/NS/wwu0Ub9Pi8B1ZUKm1nlMGQtrs
 na48HKqWd0XQFDvD0L3r3yEPHXAv2fz+FQdED5Qt7z3shNQ4n1q2viYeYnsA04hF5vWdvfwmz/g
 6WFxzUq+MKnBEFGPN71VF/3sbsk/LwVgH0ZW0qOrAxaCzpjGy/rxND6/8sbEvOmwf4M+0UeL4zn
 yBZ5xPGQPJ7eUiCnn+1ss4QxbMsKnvuLVkdI4Q+oSQ+284q7FsG1LURlMSQHkT930L8bGCcUlXf
 I5aJUW0kCSsivp/eQQap2McbADraggdbc3zMI1qqN2utAYb/2szlYN75S5jYpJsvsX1Nh2Bvlh+
 2913pNwEK06oiQhx/jPWMYFF9KqdREE43fysoEiwaZm4ZZwKL2WDu7Aw0BzbuOEopJ1El22ti8A
 05KF7xUpsJXvIOIvnGIJH8CGVUE3wGsEa2ybCf3Q=
X-Proofpoint-ORIG-GUID: Hk-oR1fOpyWsyyfhprDHROf3q2-O6tst
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX25m33lrLfZ5u
 vIvFkb9cazz3DycSY7Op6qVy0fk0cX2im/obyivs82ngAFbefTXc8MQk5gkfQEPx0PAm0N6SWqN
 I/EVAuiYAx2Sq8BR2qg1yuSbg8aDwk00Q6uCEHu+4GNWgioyxbKA

From: Dave Chinner <dchinner@redhat.com>

There is a race condition that can trigger in dmflakey fstests that
can result in asserts in xfs_ialloc_read_agi() and
xfs_alloc_read_agf() firing. The asserts look like this:

 XFS: Assertion failed: pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks), file: fs/xfs/libxfs/xfs_alloc.c, line: 3440
.....
 Call Trace:
  <TASK>
  xfs_alloc_read_agf+0x2ad/0x3a0
  xfs_alloc_fix_freelist+0x280/0x720
  xfs_alloc_vextent_prepare_ag+0x42/0x120
  xfs_alloc_vextent_iterate_ags+0x67/0x260
  xfs_alloc_vextent_start_ag+0xe4/0x1c0
  xfs_bmapi_allocate+0x6fe/0xc90
  xfs_bmapi_convert_delalloc+0x338/0x560
  xfs_map_blocks+0x354/0x580
  iomap_writepages+0x52b/0xa70
  xfs_vm_writepages+0xd7/0x100
  do_writepages+0xe1/0x2c0
  __writeback_single_inode+0x44/0x340
  writeback_sb_inodes+0x2d0/0x570
  __writeback_inodes_wb+0x9c/0xf0
  wb_writeback+0x139/0x2d0
  wb_workfn+0x23e/0x4c0
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30

I've seen the AGI variant from scrub running on the filesysetm
after unmount failed due to systemd interference:

 XFS: Assertion failed: pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) || xfs_is_shutdown(pag->pag_mount), file: fs/xfs/libxfs/xfs_ialloc.c, line: 2804
.....
 Call Trace:
  <TASK>
  xfs_ialloc_read_agi+0xee/0x150
  xchk_perag_drain_and_lock+0x7d/0x240
  xchk_ag_init+0x34/0x90
  xchk_inode_xref+0x7b/0x220
  xchk_inode+0x14d/0x180
  xfs_scrub_metadata+0x2e2/0x510
  xfs_ioc_scrub_metadata+0x62/0xb0
  xfs_file_ioctl+0x446/0xbf0
  __se_sys_ioctl+0x6f/0xc0
  __x64_sys_ioctl+0x1d/0x30
  x64_sys_call+0x1879/0x2ee0
  do_syscall_64+0x68/0x130
  ? exc_page_fault+0x62/0xc0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Essentially, it is the same problem. When _flakey_drop_and_remount()
loads the drop-writes table, it makes all writes silently fail. Writes
are reported to the fs as completed successfully, but they are not
issued to the backing store. The filesystem sees the successful
write completion and marks the metadata buffer clean and removes it
from the AIL.

If this happens at the same time as memory pressure is occuring,
the now-clean AGF and/or AGI buffers can be reclaimed from memory.

Shortly afterwards, but before _flakey_drop_and_remount() runs
unmount, background writeback is kicked and it tries to allocate
blocks for the dirty pages in memory. This then tries to access the
AGF buffer we just turfed out of memory. It's not found, so it gets
read in from disk.

This is all fine, except for the fact that the last writeback of the
AGF did not actually reach disk. The AGF on disk is stale compared
to the in-memory state held by the perag, and so they don't match
and the assert fires.

Then other operations on that inode hang because the task was killed
whilst holding inode locks. e.g:

 Workqueue: xfs-conv/dm-12 xfs_end_io
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_preempt_disabled+0x15/0x30
  rwsem_down_write_slowpath+0x31a/0x5f0
  down_write+0x43/0x60
  xfs_ilock+0x1a8/0x210
  xfs_trans_alloc_inode+0x9c/0x240
  xfs_iomap_write_unwritten+0xe3/0x300
  xfs_end_ioend+0x90/0x130
  xfs_end_io+0xce/0x100
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>

and it's all down hill from there.

Memory pressure is one way to trigger this, another is to run "echo
3 > /proc/sys/vm/drop_caches" randomly while tests are running.

Regardless of how it is triggered, this effectively takes down the
system once umount hangs because it's holding a sb->s_umount lock
exclusive and now every sync(1) call gets stuck on it.

Fix this by replacing the asserts with a corruption detection check
and a shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit db6a2274162de615ff74b927d38942fe3134d298)

6.12:

Fixed conflict due to the following missing commit:
	e9c4d8bfb26c ("xfs: factor out a generic xfs_group structure")

6.6:

Fixed conflict due to the following missing commit:
	e45ea3645178 ("xfs: split the agf_roots and agf_levels arrays")

5.15:

Fixed conflict due to the following missing commits:
	6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
	[Continuous range: a95fee40e3d4^..08d3e84feeb8]
	08d3e84feeb8 ("xfs: pass perag to xfs_alloc_read_agf()")
	76b47e528e3a ("xfs: kill xfs_alloc_pagf_init()")
	99b13c7f0bd3 ("xfs: pass perag to xfs_ialloc_read_agi()")
	a95fee40e3d4 ("xfs: kill xfs_ialloc_pagi_init()")

5.10:

Fixed conflicts due to the following missing commits:

fs/xfs/libxfs/xfs_alloc.c, fs/xfs/libxfs/xfs_ialloc.c:
        75c8c50fa16a ("xfs: replace XFS_FORCED_SHUTDOWN with xfs_is_shutdown")

fs/xfs/libxfs/xfs_ialloc.c:
        9bbafc71919a ("xfs: move xfs_perag_get/put to xfs_ag.[ch]")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 45 +++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_ialloc.c | 34 +++++++++++++++++++++++-----
 2 files changed, 64 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7cb9f064ac64..896cf97fa4a0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_log.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
@@ -3017,18 +3018,42 @@ xfs_alloc_read_agf(
 		pag->pagf_init = 1;
 		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
 	}
+
 #ifdef DEBUG
-	else if (!XFS_FORCED_SHUTDOWN(mp)) {
-		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
-		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
-		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
-		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_CNTi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
+	/*
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
+	 */
+	if (!XFS_FORCED_SHUTDOWN(mp)) {
+		bool	ok = true;
+
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
+		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
+		ok &= pag->pagf_longest == be32_to_cpu(agf->agf_longest);
+		ok &= pag->pagf_levels[XFS_BTNUM_BNOi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
+		ok &= pag->pagf_levels[XFS_BTNUM_CNTi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+
+		if (XFS_IS_CORRUPT(mp, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
+			xfs_trans_brelse(tp, *bpp);
+			*bpp = NULL;
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			return -EFSCORRUPTED;
+		}
 	}
-#endif
+#endif /* DEBUG */
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 8fcb5c6810e9..3f0cfb50f61e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_rmap.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2034,7 +2035,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		/* 
+		/*
 		 * Change the inode free counts and log the ag/sb changes.
 		 */
 		be32_add_cpu(&agi->agi_freecount, 1);
@@ -2657,12 +2658,35 @@ xfs_ialloc_read_agi(
 		pag->pagi_init = 1;
 	}
 
+#ifdef DEBUG
 	/*
-	 * It's possible for these to be out of sync if
-	 * we are in the middle of a forced shutdown.
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
 	 */
-	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		XFS_FORCED_SHUTDOWN(mp));
+	if (!XFS_FORCED_SHUTDOWN(mp)) {
+		bool	ok = true;
+
+		ok &= pag->pagi_freecount == be32_to_cpu(agi->agi_freecount);
+		ok &= pag->pagi_count == be32_to_cpu(agi->agi_count);
+
+		if (XFS_IS_CORRUPT(mp, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			xfs_trans_brelse(tp, *bpp);
+			*bpp = NULL;
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			return -EFSCORRUPTED;
+		}
+	}
+#endif /* DEBUG */
+
 	return 0;
 }
 
-- 
2.53.0

