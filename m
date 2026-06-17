Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32633B4EB3;
	Wed, 17 Jun 2026 06:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781679478; cv=fail; b=FxD7DW+l/ToPrKpq1MnqALuzYXjmNXj15MqNGpiZyqLwvdZO9WGmv1RJPepZLooKZiU3deD75amwu5MvPUmdz6uv+egZLpuaEFqGQhJb1Yoj8ej4LB9Z1axZk0Vt9vTm2Sj4ZgA9QUV1ZlrwZKWv5QK8fIo0Awssq3+RBXlvfQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781679478; c=relaxed/simple;
	bh=DoFywhfcq3sDS1X3arDL6buiFzJQISbLxCu4ELVN4c0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tp7o89/WnuQtvYvorj4I/dfQks8QJpdwWFDtzayuIVDlzvX2bP/zBRvmS/QqB9GfrzpvjAb1kgNMTfe4JUWufqiI3M1wlJeFKAwqibhtuRCwTv4Eyz0SF045f+sLmiAub2209TnUMP/un1lvCexHj1yios5Irdd2NvFQ3o9t8sM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=CmEcbQFN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=jP+Q12en; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CmEcbQFN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jP+Q12en"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781679476; x=1813215476;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DoFywhfcq3sDS1X3arDL6buiFzJQISbLxCu4ELVN4c0=;
  b=CmEcbQFND5u5hkn83Xsjq6PMnQ9xJB4+OPhK4IInRdSfJjf9FLouH8+U
   +K8qfJYuqEfiV7xD7xXda/HLcoJck6eUnIqkUU/WRuGYVAvNoFzsrWLL2
   L8n2RZZ2RpXyNWr50VLBp7psaFppgcs8e9IhoUG5oYF3hvEvxFDZ1m6dL
   kOUbShIwd60huE0aVJEH+7Gq2xc4a6TzcqIvI5D9EScie8JKXBSpm0fYJ
   ByK3UwIOBKNmmB4UdJyL5TyvIDbMhSK0s5U/cJb53E2vbLIJDT1KFRseF
   RfyMU3ehP94ct1Bx9UNW2SmIzIqDHc/4zTjZDqm/043WqDccZNET9fz2P
   g==;
X-CSE-ConnectionGUID: xf+PikPjRlSYEobIeRUY1g==
X-CSE-MsgGUID: JEYyTq73Tjax+2mDqApVFw==
X-IronPort-AV: E=Sophos;i="6.24,209,1774281600"; 
   d="scan'208";a="148341172"
Received: from mail-westus2azon11010011.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jun 2026 14:57:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xv1ZufT/XzjJbyKSISxLoM5gXJPOwe/kDJRArYJYTex5qin78/tnJ/H4CzKOFjBTNCz2qygZTKBjfeTSH7kjvlXHHlrLtX+FxG+kGPgnywVlgokLDYMaCV7dq9bsPDR73SfVW1Adt9yv7v50qLIq1c6cYCbwI5KKNVFae2wgxETHqBudkeGKMI6eFodMilLwqr2+pArJ7KznePxR6J4twY8lmT34ZRkn0mZbSiRsWuTyukdUvEgJFkZjmTQ/qqOktKq6jEUAzdE5uYBwDOuBiDs5IP4qG7+bX1Pv2IthhUXQDHwV/pyn62C/82ew/8std653GmDKlUU9rDlrWbGwpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gw74ceLvFV//gdp+ZEgBImgC6FIBiexoRdHeVQJlMg8=;
 b=TifRGpAEpFngyM0ejcEVSNSEIBPUjRrZt0wHHlsL8m3FnCyAau8WeTEmNlgUykXBf3yAPVHM9Snhr1p2fRYQP8XNJLo/1QWNPuqr+s1cAqjbiiMKGP5ZwUr756BYBiv52WiNGdjgnOoFn0urkEFxmjfvl/yCWUdU5JrY7XuG23z/C/TqIaQ5q/hCB4S6XyOmCzWYcb2P0xZlxaf4wUf+jNv/lVnv0jBzpwDeLhgR3Vvd7cZwlbFkGsSIB7HkXyePA6/mX0trbyBSzT93tHOQ3u0JqXqWeB8Vsvm/2lV2qcMv1blQtzxZH/k0X5pvMSOIJATOD5JN5jBqYSzKF8kwwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gw74ceLvFV//gdp+ZEgBImgC6FIBiexoRdHeVQJlMg8=;
 b=jP+Q12enQm0JSkgGNRyYioLRTfPFfl4KV8JpNIsNWwyIVvWIhZiUs1K/VisXbSpl5YBeWrKTea6h0v7L8RKl+bdOfy1XpOrhrPBz9DYKR9ZVC82foq58mvGEeC+UjCbGV0LDVi7MjVwWacHP/G5s1cbUAupGo06QCIGUCSFFUjc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by CH2PR04MB6822.namprd04.prod.outlook.com
 (2603:10b6:610:99::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 06:57:47 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%6]) with mapi id 15.21.0113.015; Wed, 17 Jun 2026
 06:57:47 +0000
Date: Wed, 17 Jun 2026 15:57:41 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Eric Sandeen <sandeen@sandeen.net>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: mkfs.xfs "concurrency" change concerns
Message-ID: <ajJE7uG-FPWnOAH6@shinmob>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
 <ajAJ6lXJWcko4epj@infradead.org>
 <20260615154048.GW6095@frogsfrogsfrogs>
 <ajDeAYs79j4enacm@infradead.org>
 <ajH4WwBqd_uyqQNj@shinmob>
 <ajI9U04nCpf3u3l9@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajI9U04nCpf3u3l9@infradead.org>
X-ClientProxiedBy: TY4P286CA0089.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:369::11) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|CH2PR04MB6822:EE_
X-MS-Office365-Filtering-Correlation-Id: 94ea3e54-5480-4317-4cf1-08decc3dbd23
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|23010399003|376014|1800799024|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4YZfXzlkBTUs1o5y/Ba/4JsUN0I6Le7mR7Cad8noZnEHcW+PIvilshPvpsUzUUGdUVkc7cpsxDBzJtjZ6s9PfZUzEyoG+cUakPMM5HEgVdm2M4Vs3h0JgBUgUFeZWNl/MbEeP3f0UnF1EZ/SQZgassD5GkSmujdaU+sIubuFjY7hO8KNSkkUDh8uCWZ+gohoiTeZtIiOb2HivAF6vWiIFUrBChhe+Q3NQpvGBnLd5LeflNnxsxoKfQFvafY3nYiUkjsmKxzdax+V1/RqGvzgQyzNYFVUKk/t39VvIDHeqaLxgZyyr0CoTW6GK3ZscGEIOID6DYZrQG6BUc+hTWiCXlV72IyFbfjf5N/YCPy7ZjTzDXCKoggICbwuyS6T5LJNnk9yOiolv9PRBs+wDV6J1o/GH1UysY0yGr1g3R/MO8HfESj82huUjcsF2jBoneIe8zxIOaQzh8j7gj1syWLYhgSHUXlxQKRW/1iO74PcKZTtYpJD3ufSmIheCLN0XIz5UGIPdyEU857SZFk/4kgif0ysVW0I0ltJG3s0uw8ELHZ9j6R278QIxArxhw9oO2tgMNtWL5cz4d+KMU5cgQVP0/1hRuTr2BQyyOpUf3DKys3FkzTEiiLVvF3yXmFUMxd5aO6KzCfsO9d6AuXTDBsE/Zrg1DC5uncAe3RXsc7ev5iRY5GLmYxNWocJhuvAKoVI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(23010399003)(376014)(1800799024)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iJJmVCDgJdQUy2bWi11XsGX7xFmJhW2jNM/zsJ60fxg7GNi0QBIBCS3rVQ2T?=
 =?us-ascii?Q?wiF4N9WssgwUWZfO3RNjA1aIYdfO1yDpXVSNygC4zUnEMibgS05EO8dqFNbx?=
 =?us-ascii?Q?EMC12Uhzd+Elgi/RJcKGVSX7y1oweHkCz9dzSM/BpIOE+A4fG3NhSn6KpO74?=
 =?us-ascii?Q?vR6Ozzqxc8yF1I/O1Y48q1AA8pwSWSBzwFVTA9xEpNEv/Oiz+EytxHUi5JvO?=
 =?us-ascii?Q?J3O1613erVuUPiufqop2OaTydI4OSDxduKB+AeFTyeRzejOfxuXNSupZuthF?=
 =?us-ascii?Q?s3GPi5YfZrNVZGFicuH11Cih/eixvhd0/E8yrEqS9uODZioBfVT/ELZp/ocz?=
 =?us-ascii?Q?sVm+bNFR8AJv5B3+jd3QquuxK1TuGmCI+BUPS4/+sNVuk46PXyMRHM5Xh/1B?=
 =?us-ascii?Q?cR4z9OS+T4+1pRZO+YifM6MddrcuJTPr6SiH03HSxvtCZj0usQtCjLW/plEC?=
 =?us-ascii?Q?EYbrjtHcIaRn74G9fQ05dEiLlY9EPP6iZMgT3u/qiS8WwApvSqeLvtD6QkDm?=
 =?us-ascii?Q?jikEvZTnl+NyhbpGs79xghfGxcrDiNVejf558O2bEaRdONhYf7vnq7hr0dZc?=
 =?us-ascii?Q?8K92auJxzNm6wdj1Sx35qimWfNQwBKmocpwhYuDtNaUlY3QNj3FnTEFnQMLy?=
 =?us-ascii?Q?8QrDHGnya3AslIvvgCihYXQMG0pgxaQmfoL3OdoZlL1Ukvt2Adobs26Xfjox?=
 =?us-ascii?Q?jz3U/Xo+FtLQSGfFLi+rI9sGvLE6dCr2RWLEa+WiVNVVQGAbwQxSzDeywV3e?=
 =?us-ascii?Q?NP+ZbMnwhe6FbWN1xSufUqzYk/TSOa+tgVT0AvVjFY5rrlgiVyeEgVpTtMsj?=
 =?us-ascii?Q?a9BwGldceex4xGHu2PN2WNxEDq60BtMbnxYVaTlTjIAqn+MExGnxGe9zp68S?=
 =?us-ascii?Q?7HG0qX6bmQxXhsfaxruWsVvvXSXLfWhWxUV0oBpdFy/wOVLMRqD4r2wtKCtP?=
 =?us-ascii?Q?q7uLlunQFHG3QVu4TO5yk/WexKWS+HabuZldxQ47zhDTsYYQRN0L1hYRac4Z?=
 =?us-ascii?Q?NAEqTYGb4Y7gHiMbmDra6TzIKW2aCJmkM8UQDOVjYsG6W+I6HJ59W952TRqD?=
 =?us-ascii?Q?5Wg4k41EvIcHWk1sXiTD2bgOzAufdAm6wpvqLCsQ9XAYLs+XcWYFjY8EzBcX?=
 =?us-ascii?Q?7JgPD82zRsH1syCYwwBC5LlEEAB2Yk5zR0bk0Ub4zJdGzLjKOBax/Frsoskn?=
 =?us-ascii?Q?NxwWghtjIATV7EpZy3SNYUXFYwHxAWRjoirPcsEhvbiDpcAWu/1CKZZz9v9S?=
 =?us-ascii?Q?TpKhBF1VA1qFZnt0PNbS2LeE/EbQKIDperda5/gHtDI5a7MvY7n70lu8r6qd?=
 =?us-ascii?Q?7VgI9OQLKJ4XOjT2JsDdq4sRqz/PGaGgaq2zAAoserJgnDPddC6KXm6pb2Sq?=
 =?us-ascii?Q?CXNpY3GwAn2Ofq5EINNZninRdek+pXT1GytIhhjF0IGDDSVB7BDBwOgdm6bd?=
 =?us-ascii?Q?VdD1VvDWZeb2ylVsYcCeynX8vifLwkFrBzUSwMsq4EtvWbiP1XOXAp0QFHbf?=
 =?us-ascii?Q?aLS2FVhocTKpdGeedEiOQ7UWwYCL5QBq2x+U48GoZcJv3PNoBZH+J4nu1g2Y?=
 =?us-ascii?Q?r8vlT745Pt73PR+4uMWva/07cdpxFyR8LJoZdrolDXcAD0kzYNu2U3ffRVVC?=
 =?us-ascii?Q?xtaH7BU/0Nv1+1f6lEMorp+LYkPzDq194GFqhCQqfvrCsjSxwzJ+LqJzW5yk?=
 =?us-ascii?Q?+FWD6SKo9ChSvETlhTXnatjpBeMYFu/IDHfUnCetdxyX5pdRMgAugK39vFn0?=
 =?us-ascii?Q?x3gVAwKN37dozdKjI2rbiG0X0FK6tJk=3D?=
X-Exchange-RoutingPolicyChecked:
	GAqmZQwa/HfQ4N70W9+aDfp3j+9flasmq/8ZY/uOx6KljYjOCmvDp1ayNuxulW2u8vTrNJBCiyhSiz6m8ywtJoC48IvYcFxUPUR9tCvYhyvyCRn7Q2xCJJMfez17vJ3f/p8NhvHHhpFVRbe5sxbR22+JeNEtGGFeFUyHVPrGOwVrV6X/R7wVbClRVL2PZkBB7VLVq+RByqJ5qKwxKboIBVA11ehR/SwUdVkuJUWfeL1FiSP/mpdzOU56eLdHR5cvwoRmxa7htbA4c2/GXxMNpVE6mBxVVxPJtIVzHnY+qm+7uW67y/rCJIUBxRmmcaJR1yab1KvfVSJqzoH2vc1UmQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aNCIRBMG+lnYsSEQgR7TMN8H2zEwVqTwydQ7DRO9KhebLM15hSxRG55hLv666vzHoKeMI2eWmWn0CTZiKHlHd/EHPfKKXQFa21D6y+Pv6RJtJ14/BNgwqZLO1HWt97m3gbJi4Vsc0vRGaMUWJidDqK8xF6Jdt5MLfG7BKglxKOl6Rqo8/sCgkCewfZR1LWYtgyiB2O08U3fLUvOp5+l6nVbBYBlBls5WHTtV8mAgH1WgKeVGWKHi2pY/RQLSmB5v5id/C8W5tS1XWqRrXiUghpMtLrBX908OuVwejHKYBew7Q4yk85RVeHHVXBlxhcYffrQ/MmjASr+eNLKqfq+Pb12HV4DXQrQtShQ30Ifpq8M2RRWLFKqVcZ9neOrc7+yDCkwRBsa8+9zoO4+TtOIxjIrr74PktmlSZ3YX5VM8iRPQxFpIhDVicXJ9c2zltfT+C/OCGQtqzLGmajvNO31XZolKq0pHR7LQiPgDNrqOZ6lTztjVp9aVC+RYjVtZdnleyu77HUuTRkhB0BYgki3f2upGll+minJSq+ZelECjBXxSN/H/kEOHwJM5ezKSxpdhIib5hiKjdRxne8hQnvq8lAM4uj0X5MEQIzdCA54ydhfGyRCzVefIN5s7tYpvj+/p
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ea3e54-5480-4317-4cf1-08decc3dbd23
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 06:57:47.3383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZsTO08VcHtDmGQfBrXrFDEnfXCpl2op5K+YQOgw4ARKAkZPxUGTIYCKTfFh69hShR1Zje+RZe0wLA/OlmvlT5UGqeYLgwnoXovDAtPFft4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6822

On Jun 16, 2026 / 23:23, Christoph Hellwig wrote:
> On Wed, Jun 17, 2026 at 10:43:10AM +0900, Shin'ichiro Kawasaki wrote:
> > Just FYI, here's my command line logs. nullb0 and nullb1 are 8GiB memory backed
> > null_blk devices. I also tried each of "-d concurrency=0", "-l concurrency=0"
> > and "-r concurrency=0" seperately, and observed the same failures. I used the
> > kernel at xfs/for-next on Jun/12 and fstests tag v2026.05.17. The fstests
> > alraday has the commit by Lukas ffc8bad17e5b ("xfs/21{6,7} Use default -l
> > concurrency=0 on mkfs.xfs that supports it").
> 
> Both xfs/078 and xfs/216 don't actually use MKFS_OPTIONS :(
> 
> Can you try the quick hack patch below:
> 
> diff --git a/tests/xfs/078 b/tests/xfs/078
> index 6057aeea1..c477f6cfb 100755
> --- a/tests/xfs/078
> +++ b/tests/xfs/078
> @@ -57,7 +57,7 @@ _grow_loop()
>  	$XFS_IO_PROG -f -c "truncate $original" $LOOP_IMG
>  	loop_dev=`_create_loop_device $LOOP_IMG $bsize`
>  
> -	dparam=""
> +	dparam="-d concurrency=0 -l concurrency=0 -r concurrency=0"
>  	if [ -n "$agsize" ]; then
>  		dparam="-d agsize=$agsize"
>  	fi
> diff --git a/tests/xfs/216 b/tests/xfs/216
> index 1749647c1..ded3d30af 100755
> --- a/tests/xfs/216
> +++ b/tests/xfs/216
> @@ -22,11 +22,7 @@ _cleanup()
>  
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
> -if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> -	loop_mkfs_opts="-l concurrency=0"
> -else
> -	loop_mkfs_opts=""
> -fi
> +loop_mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
>  _scratch_mount
>  
>  _require_loop

Thanks. With the patch above, the failures disappeared!

$ cat ./local.config
export TEST_DIR=/var/kts/test
export TEST_DEV="/dev/nullb0"
export KEEP_DMESG=yes
export FSTYP=xfs
export MKFS_OPTIONS=""
export SCRATCH_MNT=/var/kts/scratch
export SCRATCH_DEV="/dev/nullb1"
export FSX_AVOID=-a
$ sudo mkfs.xfs -f /dev/nullb0
meta-data=/dev/nullb0            isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0
$ sudo ./check xfs/078 xfs/216
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 redsun71q 7.1.0-rc4-kts-xfs-g804826eac53+ #1 SMP PREEMPT_DYNAMIC Mon Jun 15 09:31:13 JST 2026
MKFS_OPTIONS  -- -f /dev/nullb1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/nullb1 /var/kts/scratch

xfs/078      13s ...  13s
xfs/216      8s ...  7s
Ran: xfs/078 xfs/216
Passed all 2 tests

