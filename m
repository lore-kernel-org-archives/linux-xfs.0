Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E0613DBBE
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 23:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731973986; cv=fail; b=k5XHdVqu2BOQfsXQKQ6iETWX9JW7Emdetg7Sghkt0A7zQMZoZ0ByNngssZ4ihDNRib8blTEgNqj5DotarvOE3yqz/42xgSZbSykJXuJK8DNsou8YHV/mtocq5B0u5qHvBH5PCvNPKoI/jsDQTIA32GhYcm41TyhVuClCNFd+FdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731973986; c=relaxed/simple;
	bh=vemO+i6ofMqiKqFCiZRWnahki7MIp4kk7nb/I+P5y2M=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=IfvDDrU6/AwB3kav5k0iSC36iNZVaEhpB1QD+ZLs6KojRMzSooirNxrFp7QLcRC7N/t4i2eAC3o//5upvUYi2JrhTZt2Zr93pr4lYHEvWSUhaT9hzaI/oW4FZJFgOkEf7yh9quWYQlsuypaflgzJo5AVL3xMHPWh3rhStiQ9IQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y81O2m4i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eqzzsQEC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y81O2m4i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eqzzsQEC"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AINMgrL012490
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 23:53:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=SzkvgsMS/gT0u3ED
	wZkHXYvSAA6QDALpLTiuzcBlSOQ=; b=Y81O2m4iIjG4w2uJfFg5RhWFIC5XvW6O
	tbO6htWbsqGbw0PyKg3iWTXJx9gWqvh1cTw79O65FgHnaLkN6+IrVwP1YEu9hx9T
	jmQXkraMoDrVoh31YdUpToRTKfuiN5YmQLZhx2re8eLfWMFZ/0uLBuOydI9pyHLE
	TKgWNzz4mn9pxAmn4zFpU5WVxOVaKvqCDAMfccljPfPvJrmE1Ro+7jh8nYyUoJUS
	HDr0UPMMhC/AoyIRyx18eQ5e5L+EORgbxpy/HQdDKYn0MofaSCvPIJ9+YFYsOx21
	rMRzC54U7mmn/snGiOAFnGMENe6DevPbFFTPtkT0APtpZ1hIa9eDJw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xhyybwen-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 23:53:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AINcFZI037148
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 23:53:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu7ts0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 23:53:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aSibY321mbu+okeYm0vxZIjHnWpeHwebLtXHI5sYqRTwedrfPTitIhm247R0H95+0ODrnOrVWVg3J5G7sIWDEy5zXLt7UpAj//G5aK1F/G/xG/9QAeNc0vX/8gBuyebOcfd0IQX9Z0MkuO83DWhq6ONYBR6oOMdW13sEZeOe0UYyo9jA8xQK9znCygolf9mGJk3dHLXX3aO8LRmlcrL07yLJ84Dd147WEkIcW1lTVaMbgKXpzEgBCBfaEQYJASyzUf6ux5I8d179H4mLuJno9d+M+5bawMKfiMBX054zsBXgPwgGl3ukIvGQ5MD2Xac9/jcBTQ82py20RdPIV59Kzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzkvgsMS/gT0u3EDwZkHXYvSAA6QDALpLTiuzcBlSOQ=;
 b=kmmDEdqVwG1MBiMdwWOqORjHwPcAfk+PLhR+gsHGI+1Ter0ztHQFcBiQjW4c2KT70V0rPkdmVvOm3hgPypSS9nz+x8A7tnhrVwRgGYpUCadqZvjp8AaadNNPKH9sEieT6veLVgbDylj9cdiZsIORHeoDGIw9cLAx8zAnzJ9ZbvjWFJuXGA1wPH2IWf6PlYX5F58hoW2sRPjzpUuMqf06S0VH42fSKrkQKCfHJRhUehocB7LXqjJUyXRRtL0bmqgweJ/ZNvCZAXm2AgyMZ0eFR/aDwM7m5NYy0tBVO+ZaxluddWbpcKjeeHuX3Ay/9j7mX7sZV70LXN+ZnDJZguD+Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzkvgsMS/gT0u3EDwZkHXYvSAA6QDALpLTiuzcBlSOQ=;
 b=eqzzsQECs01xlPYm1fP14Lo5JiaAsyXEejFHsUnZffwWJ8P4tju1jiCTDZQP8aivlXvKi8RephXr17G9/ueoAz1fL9c+Iwe19SZl+mG2PKaOHcBhWx4k6JVvsi5zDLlwtHGGch4CvX6UlG6HpvUtbaHVrWQkNowakHGs9Tn6yvw=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by DS7PR10MB5136.namprd10.prod.outlook.com (2603:10b6:5:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Mon, 18 Nov
 2024 23:52:57 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%4]) with mapi id 15.20.8158.023; Mon, 18 Nov 2024
 23:52:57 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs_io: add support for atomic write statx fields
Date: Mon, 18 Nov 2024 15:52:55 -0800
Message-Id: <20241118235255.23133-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0173.namprd03.prod.outlook.com
 (2603:10b6:a03:338::28) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|DS7PR10MB5136:EE_
X-MS-Office365-Filtering-Correlation-Id: 934b7030-108b-497d-1c13-08dd082c2031
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l7x1MLTUa7emif4svm7bf6e7Akv+j+zSDcGKCzQffz502tRH1Wmsr84Ibnu7?=
 =?us-ascii?Q?vIf2KtYUlYV7eXvfmy8Wc5WDRZaGQxlirQBoqN/8natcvxNmi3FEMl1Av2Z7?=
 =?us-ascii?Q?Afi8q1mKlV77K1ODgslqwhsqSwEpOL93FQCPh7W4047aZccuRyjl0peeZYe/?=
 =?us-ascii?Q?ZrhbMo7QFNDhra2y5t3K4RkOv6j0vetwPkN7env+dHaI4YzDPhX45CcHKJBl?=
 =?us-ascii?Q?FCrdRAjTJHO39u3s6UVWlwagkOuXj4DNk1FlHloKM0YXzE1rFLHlY58cRopK?=
 =?us-ascii?Q?zF0PcARDf++Umeh6mASxkUSKXd1GnvqurdCstaQTF6GHW5gBSKUH5q3qGmVa?=
 =?us-ascii?Q?q1Z9EgkJsL7DafL4ABdZtqAEwP7XXvydU0oMPvyyEcDmXnnu7TxEwwl9FDj5?=
 =?us-ascii?Q?qb7SRSfblYc2DfLPhII4JUj8z4neYJF8Cf0vqE6eK/+3cO1sLRNr06WNSC4q?=
 =?us-ascii?Q?Q21PPPL0J5TJ3eqgpS2pGIH3yeZ98AezfDuBIOatK26/uVkHT85cLQyGAUJy?=
 =?us-ascii?Q?W+6JWstD8p2HnM8QxrJ18BxClfJMyeK1rCJqpMBdSUCx67uXZq3GnQYy2pdW?=
 =?us-ascii?Q?y2KgPkkvW/1fmFsyDFO1vLWdQer7TPzbLKO0RwTUw21Vu/yNXsqf1+FqxEg7?=
 =?us-ascii?Q?YJh1v72hsPBOnYtloGRbrrI69OZxVhC6I/IpewDsHG4T7W0nHm7O1GA0mupu?=
 =?us-ascii?Q?2nTwIPPH4dpws6wagqKQryf2JKlaSzFh1MREIg7/QJd+wfUCi11grWueqhkM?=
 =?us-ascii?Q?NwY7DcgPU2up4uDyy7SO6VPgQaWSFOx8ul096ZVz+sVzbC1ld3veyQpLkFzL?=
 =?us-ascii?Q?DzzIoQp6IcVXGx8GAXkDGY3OIJgW8lutOkrNuhR+YyCoRrAakIETdiRRiDJZ?=
 =?us-ascii?Q?uP7kUjunXIy8Ph7tJtpyB8EhbsOlWu5rUm0CN/95yPRKwTFqzw+3W+5tEOA3?=
 =?us-ascii?Q?H0fzjNlyYNaeQjrlM9pUKp7unIr5q71jHxupjqpfGzOHSuu9RJKXNEmuFxdX?=
 =?us-ascii?Q?aDDzEoOLH8/f31nJ51d+smJJih8i/otRdmLogDB1s1HbCWO5tvDsiMh+wIlQ?=
 =?us-ascii?Q?nagPFfsoqHQq6kIWsHxvQiz/brw7sypj06tMHR7qxVcDv5DubNGbp2d73R0W?=
 =?us-ascii?Q?3TjGJL/OrvNI39l8irZxMr7tROfs8orhCJ4191tKdnVIO562RViBxWybZM1A?=
 =?us-ascii?Q?qDXmq2rPXQjDOlgsimQuYUlEsNCO7r005j0TWCjFCu5LFIOZdmJlFay1gM2u?=
 =?us-ascii?Q?PPpDlAaPeHagsDE92NNy/f0eiNy+surnb1GGvHUM9aRP5kd4l+6UbkgyLyUO?=
 =?us-ascii?Q?9Rne4jnAZGU6uad2WtbOfAD/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c052aOX+WWMelmvJDafUvb0S1iLlX9oplXgWbjnffLICe0OaeUQ4Wu/YpRVO?=
 =?us-ascii?Q?S9sdxOMyjiP/QdUmX5hyroHphHQl5W271Do5lqWu0pwYS9v45dei9+PeC+Mn?=
 =?us-ascii?Q?wt52gxekMLe3SQfxFd1Sgf5e6RxokfN04wAEGSEaUT1EnmkRuZDd/reBkO1s?=
 =?us-ascii?Q?d3PrwMZ8g2+uxbI1hemve2FHEAXkn6LVB3sg9RYBXWLDQHgEhnER6wAdAYIw?=
 =?us-ascii?Q?lwUN/M8lmad5GaPvAchWWhugnqfXk0DFe05odmx+FHuBdgOWgDVsqcK7RNud?=
 =?us-ascii?Q?n/6fMk94fYlTpZUPHWz1vVByywSaN6hcfy/+UMhfYGR+DSyFV6EhrcfWFPXU?=
 =?us-ascii?Q?We265laKgWcjuQqQXsWRSbyHmqr4HbcU5aXzsG8IynpV7iRvHAbnf4utncWC?=
 =?us-ascii?Q?nXI7zunUifGIHxQRQijEU6T4DDSTMHK+wmEHYZvQaLRi+gRwrcLO0qUbbrki?=
 =?us-ascii?Q?oi2mW+miRSZWeqxRBCLAFa7tmuSeMUQcGDgmY4BYUa5iEaR4TV8ylbMeq1zA?=
 =?us-ascii?Q?X3V1kGkr3MSGhtSmhO7r/LvlspF9hWWxenz7Pr+VMhL3QdqxujU3cppKT6dy?=
 =?us-ascii?Q?qA+A8IZwUl8FBGsmJ+OSuX1SG94GjSOEo9bIzMhWOZc4M9olysIR5UfCqNSc?=
 =?us-ascii?Q?KGnnadUTGG2uVh1LRKISYzRuWGgmUuxpD7VmEkO4d5dgeEnTS0jfgBS9IDsN?=
 =?us-ascii?Q?seLkVKMB9k1CJ9z4IMnV9y6pZJOPC5j+WJTTnKQJj2nkjkZuOJjWY/r8GtY0?=
 =?us-ascii?Q?qyaeR/25a8JAWTizS43D6xsqTLSdc+qt+WAReGwwGOhvn9cScnW8ogj9KayI?=
 =?us-ascii?Q?tSPDtLsBgOexZnliMDq41iN+GPV/JbgKePMdd550YGuT4Jhf972+/h/d+Q73?=
 =?us-ascii?Q?EtlW6hpshQ9TwCzQsTe/AsvFR7+HeqO4upMGyPOwkRFAAF0JPL5rNeXxg4tp?=
 =?us-ascii?Q?9gFEyCkGvxlWB8FVnmuwvl2uk6cVMkrLbHJa85qF1clr45qxGMCY+ETg8axa?=
 =?us-ascii?Q?1Zm9eR+OzglEm3gbN5RuHKK7m90mtG1qacxz0v8i/apDktKoEZHhryq/Y19L?=
 =?us-ascii?Q?j5B099xQiiR+Ff58H29vkQltTHc4ghxxc3sy1coiHOE6yXeYpru3NadlwxhT?=
 =?us-ascii?Q?6OWq64MpKvoH0TkMzj8pdiA7eBB9kmxALKoH99kvS9mhvDPny1mnkjqavtvL?=
 =?us-ascii?Q?5UYMHzIeKG+sXgDxrLOwz1oWaCHfDyrq0/I7mXRBKlFGOOHzjx3gPXqGoWDh?=
 =?us-ascii?Q?8EcZOXj0VJhf/05lcdBgAc2enru/LYV3t/vwCMe1wS9QXb7E3A38+gwjTlMY?=
 =?us-ascii?Q?HPGAjhKG9AxLmFhFIljsMGI+MasSi+tqNrNmLuQdFWZUCBmb+8HauRFhHLDi?=
 =?us-ascii?Q?+5TtNw/aainP5JYsWQ5/WGql4o1CQNZbBfC0FHAOlDs9ElzFTewNWgof9DaB?=
 =?us-ascii?Q?ZBQDnM6w8mjOOGxFGT0MLJFUy6ulo+Us7UfjeX49bmJa4/hs6oXIFLhkArtv?=
 =?us-ascii?Q?qq/ffoCxogKPru5pKcrmgqURM9pCuoWfIs8Wor7wusdt4xuqcMt2of2MtDVA?=
 =?us-ascii?Q?X682CKyM//EYq3Fbg1v+qdYP/C0xCpfBDCf0sGbHG+xQg4E9aQ37CprAFqfS?=
 =?us-ascii?Q?+QBjq8BDXimX9Cr6dXL0ZHeJN64+Il++lMnLRJfpNymjOUCiTyDsxEEjr+uN?=
 =?us-ascii?Q?vM5/uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U6nHaW7+8iSi74FTqCf9S8AGWW3yLe5yejWlvKFWo3fjPUwvmkiGnwIQEIYiHp+zPfMwIuw4cR7ZTOf7om5LqrhmSESuAKLM2y/gmZELk2LkOQyfe3SNN/HL7VsSxVUBXpF/Fzu440IIg+5q1KvuHppfXpEHrg8WxuRSkypF705AgrRhOz6kMuS0WfsoykcvCrApN6KYfWgP6o0jG+3tyKhMQSiMbDTnlTWO7ziu95pWcF3P1w2Ep998Xkst9UJMnOU/6HA3O549rd5VQ4mmRP8tpvI+ZqmZroDZALRtFNArcd/X8dZ5BbsOJmaAnEZutV1vg2SoeFJmsdMOUORTPGJ7Tg2V0Qej5RMnSHX2p5rkCKY9hUPD6kaS0aJdvmSXU66To38ABRAyfflmVatQnKZM1wP8wbKMCdfp+RSYLt1GcJEu4/tIhcOUgZHJLvVQ4QVXnxQyybSBnaisvOCpxyiBLkw86pjwYXT8V2mJ5le/JXWzEiF7AkyuVQfySSPzt2NihU/CZgi/gzHbGeahdviwDUegpv1PXJHiS42SEv9CilV5wvkRtoFsFjakzrdAFREXDkzD8M0KoNLM1gqaTQM5OC+u6cVuk1kv3RBsa4w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 934b7030-108b-497d-1c13-08dd082c2031
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 23:52:56.9679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jfpp8vjq+ePxlY+cC1TuVod34jYeKxNhZdnx1CFNyU4GAivVk0OW7a/n0YHAYUF8pjG2fPuSQJVhL2IRu9//g9xTlhh0hbzKuRv++2t3F+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-18_17,2024-11-18_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411180195
X-Proofpoint-ORIG-GUID: EwydCXQlgYq4Q2yqSSO_prX4ls2jkLB8
X-Proofpoint-GUID: EwydCXQlgYq4Q2yqSSO_prX4ls2jkLB8

Add support for the new atomic_write_unit_min, atomic_write_unit_max, and
atomic_write_segments_max fields in statx for xfs_io. In order to support builds
against old kernel headers, define our own internal statx structs. If the
system's struct statx does not have the required atomic write fields, override
the struct definitions with the internal definitions in statx.h.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 configure.ac          |  1 +
 include/builddefs.in  |  4 ++++
 io/stat.c             |  7 +++++++
 io/statx.h            | 23 ++++++++++++++++++++++-
 m4/package_libcdev.m4 | 20 ++++++++++++++++++++
 5 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 33b01399..0b1ef3c3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -146,6 +146,7 @@ AC_HAVE_COPY_FILE_RANGE
 AC_NEED_INTERNAL_FSXATTR
 AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
 AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
+AC_NEED_INTERNAL_STATX
 AC_HAVE_GETFSMAP
 AC_HAVE_MAP_SYNC
 AC_HAVE_DEVMAPPER
diff --git a/include/builddefs.in b/include/builddefs.in
index 1647d2cd..cbc9ab0c 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -96,6 +96,7 @@ HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
 NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
+NEED_INTERNAL_STATX = @need_internal_statx@
 HAVE_GETFSMAP = @have_getfsmap@
 HAVE_MAP_SYNC = @have_map_sync@
 HAVE_DEVMAPPER = @have_devmapper@
@@ -130,6 +131,9 @@ endif
 ifeq ($(NEED_INTERNAL_FSCRYPT_POLICY_V2),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSCRYPT_POLICY_V2
 endif
+ifeq ($(NEED_INTERNAL_STATX),yes)
+PCFLAGS+= -DOVERRIDE_SYSTEM_STATX
+endif
 ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
diff --git a/io/stat.c b/io/stat.c
index 0f5618f6..7d1c1c93 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -6,6 +6,10 @@
  * Portions of statx support written by David Howells (dhowells@redhat.com)
  */
 
+#ifdef OVERRIDE_SYSTEM_STATX
+#define statx sys_statx
+#endif
+
 #include "command.h"
 #include "input.h"
 #include "init.h"
@@ -347,6 +351,9 @@ dump_raw_statx(struct statx *stx)
 	printf("stat.rdev_minor = %u\n", stx->stx_rdev_minor);
 	printf("stat.dev_major = %u\n", stx->stx_dev_major);
 	printf("stat.dev_minor = %u\n", stx->stx_dev_minor);
+	printf("stat.atomic_write_unit_min = %lld\n", (long long)stx->stx_atomic_write_unit_min);
+	printf("stat.atomic_write_unit_max = %lld\n", (long long)stx->stx_atomic_write_unit_max);
+	printf("stat.atomic_write_segments_max = %lld\n", (long long)stx->stx_atomic_write_segments_max);
 	return 0;
 }
 
diff --git a/io/statx.h b/io/statx.h
index c6625ac4..d151f732 100644
--- a/io/statx.h
+++ b/io/statx.h
@@ -61,6 +61,7 @@ struct statx_timestamp {
 	__s32	tv_nsec;
 	__s32	__reserved;
 };
+#endif
 
 /*
  * Structures for the extended file attribute retrieval system call
@@ -99,6 +100,8 @@ struct statx_timestamp {
  * will have values installed for compatibility purposes so that stat() and
  * co. can be emulated in userspace.
  */
+#if !defined STATX_TYPE || defined OVERRIDE_SYSTEM_STATX
+#undef statx
 struct statx {
 	/* 0x00 */
 	__u32	stx_mask;	/* What results were written [uncond] */
@@ -126,10 +129,23 @@ struct statx {
 	__u32	stx_dev_major;	/* ID of device containing file [uncond] */
 	__u32	stx_dev_minor;
 	/* 0x90 */
-	__u64	__spare2[14];	/* Spare space for future expansion */
+	__u64	stx_mnt_id;
+	__u32	stx_dio_mem_align;	/* Memory buffer alignment for direct I/O */
+	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
+	/* 0xa0 */
+	__u64	stx_subvol;	/* Subvolume identifier */
+	__u32	stx_atomic_write_unit_min;	/* Min atomic write unit in bytes */
+	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
+	/* 0xb0 */
+	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
+	__u32   __spare1[1];
+	/* 0xb8 */
+	__u64	__spare3[9];	/* Spare space for future expansion */
 	/* 0x100 */
 };
+#endif
 
+#ifndef STATX_TYPE
 /*
  * Flags to be stx_mask
  *
@@ -174,4 +190,9 @@ struct statx {
 #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
 
 #endif /* STATX_TYPE */
+
+#ifndef STATX_WRITE_ATOMIC
+#define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
+#endif
+
 #endif /* XFS_IO_STATX_H */
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 6de8b33e..bc8a49a9 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -98,6 +98,26 @@ AC_DEFUN([AC_NEED_INTERNAL_FSCRYPT_POLICY_V2],
     AC_SUBST(need_internal_fscrypt_policy_v2)
   ])
 
+#
+# Check if we need to override the system struct statx with
+# the internal definition.  This /only/ happens if the system
+# actually defines struct statx /and/ the system definition
+# is missing certain fields.
+#
+AC_DEFUN([AC_NEED_INTERNAL_STATX],
+  [ AC_CHECK_TYPE(struct statx,
+      [
+        AC_CHECK_MEMBER(struct statx.stx_atomic_write_unit_min,
+          ,
+          need_internal_statx=yes,
+          [#include <linux/stat.h>]
+        )
+      ],,
+      [#include <linux/stat.h>]
+    )
+    AC_SUBST(need_internal_statx)
+  ])
+
 #
 # Check if we have a FS_IOC_GETFSMAP ioctl (Linux)
 #
-- 
2.34.1

