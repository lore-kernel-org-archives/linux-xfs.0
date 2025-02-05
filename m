Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2102213240;
	Wed,  5 Feb 2025 03:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724898; cv=fail; b=m/iPi73OzxbR0ZydAhHSWY2s4asfss7zNwOG/rVHzOT36vZVVnsfax94phJhOiSgdY8ZRrYBM62UP4VwTNf1x1EnpO2NTTSIZsKRGWjfLLuya2gEvN9p+1tDBBO+pwJ5WIDLJATd4kGzQOPJO7oLFnN14fXQu02iddZ38AQM+20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724898; c=relaxed/simple;
	bh=gJA5VHy59uOeUgR2OGUnkf069gyrh3LMetUvanb5Guo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EJhknbpJqdRlKU6GXSjg8fCpp4Bbl2YeD1RPH27IeaOmnb9S9X+hFo9oi5DASkfvCc9auzkWqxa7xIgcVuYt+DRKZL0YQsacPCCRhtakM1Bgkz0O1FjRI3wjOtZr1Fk4jVPldgku1T8MPljq7UpxaPI5EeA44+Ryk+6NF4o3yXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ppt0bjEP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fHH2Iv8b; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ppt0bjEP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fHH2Iv8b"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBtKT009531;
	Wed, 5 Feb 2025 03:08:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=l7W/0IN3iK2j7fexhJa6kZcXY5ohSdhHNjOLB69n72g=; b=
	Ppt0bjEPG44WU5iAmkFK2xLltJqcyo0tQOLbpPyovAWpiXVnPHCAu2YZygstkkDN
	M+Ej9XUFM+jrL10Q6tvlUFklGLJkstLJRirBRqfJukBwK0qhXp1AEaJDtYfcEkoW
	i+u6gaCaFyDqlu2jQBp9KL18wcExk8IxnKRoxnwQ7NlGh5NNr787UQUwGjbW6/wb
	Qd9dfTBy13PZUSjiFrHXHg481xtdAKakhQv2X2Cb+Far1R95OU821XUz0Ua3Opom
	QG5MMvcZ6VEP+0Weo2Qn7wvyo5M5Gbm8caJZTVWNF3GUk4I+eyKlAINuSz5a5YwG
	FsXuXDKbkviepiqkXwbXow==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfcgxbrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51512sax037814;
	Wed, 5 Feb 2025 03:08:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KpxGLCsRSGlnKPgMfAB8+uhHeHoTT98sP4BUotjHCn4hmdydHiQlQFFL+TjSsO0igEILLy54lZHGMxlYUTBF1mdKkuOITHmfNg8LJhzWumg1i3ZA4LBP4hTeqBtIIFiBqO7165j/EU8bL+YerX+l3EwrDya9Yei0CFOWVNWNnIaB2h9hBD8eY/IlXL/de47hh0SuUZLYORviSYxG/9xFZ08CyJOCWUP5gALkn6l6AdlNfz9j/TsTI9Hub5nKCSWy9K7we8QBcT9/4WcTecatMftaBWTWSQdmPEIBZuPRryRB57YtpcaiAsvnSMfWMXe2GPPGusDMNgt19rDgEwhDCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l7W/0IN3iK2j7fexhJa6kZcXY5ohSdhHNjOLB69n72g=;
 b=anszNenOoE4G0bciXqSy4xhIoObDDoTAwwq4mXCKDUpLAuWi1or2fTPPCIp0QgNOi531Z6gbo/Hiy6VAdOqNGgPvuKH7HZJ8Io2UTOthaAButZVmBd5vXSOTSVOFAS1H6rzBc3RKHst1aj5bTyMDjErj90sjcGDQqwX1VbUsqbm8K795J9m3g6F/mcAOpc51otTN6gT94kzmiyA3zqCdLi8vSBqvYtxzyK0/w/4qwI/YXxP7vu6MvxXhUXZ9V7cPPdoYbMBOWB8XAxj/1ZHgNg7Fmy7G2CZIjdfy6i8and/Ka1eXGuzdORBeRuBplhvrjQz6Borp1/8qT4eMD3Xu0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7W/0IN3iK2j7fexhJa6kZcXY5ohSdhHNjOLB69n72g=;
 b=fHH2Iv8bYvxLw67eZP01i7XiG+Cd5yu3W15bl68yprdMJYE/MqVtYJ9wK3TPK07DX4X1z5CWhLqEwD3Wh6J86OQ/MSnndivt9zBjsOOzdcFjJJGOaTpTprmcTUxOgy4RVrp7m/IrORd+oRBJyEsyGP/X2FR5vTZbal1oClnRTFg=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:07:47 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:47 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 07/24] xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
Date: Tue,  4 Feb 2025 19:07:15 -0800
Message-Id: <20250205030732.29546-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:a03:333::16) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 40b84111-b53f-445c-baf4-08dd45924451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u46/lUSeBeVAaT/AgXn3QaEquFu+XJLqx05dYNmmzIDI1A6w+KogchNLZs3l?=
 =?us-ascii?Q?1osWN7pctL4znKQgZKsPRX7HgiDxKOzk2AgoHgRUHgTX+6sewtHgj5h1ZSYS?=
 =?us-ascii?Q?Fm1XzfCIWBFWkOResmhIMACzISje3O0nNokumKkocPNTSX4zM8J3PDdvZ314?=
 =?us-ascii?Q?1GRRSouku8Yu1sZBQ0Yy96Ab+LFHWvxrUjJzrRaOXRWH3rE/Yn1ZMKJep07f?=
 =?us-ascii?Q?txqi+C0kVGM0CzgcNx3ckQGl5aCakzG/uaf93Gr7mmxzYQV+n8vxkbrmOGU6?=
 =?us-ascii?Q?xyvjU1ZhlzX7OinFGgKHNMX9C7DxywFSCy9pPPK7t/unlqSJ0Aq/9UyxlI5E?=
 =?us-ascii?Q?kUO9UEV6Tcha1uxUpQoMpBXWEZl5ratsIE+GLc2no/C3pHfMhaHtnj/szzt3?=
 =?us-ascii?Q?9gLvcN8kjxbe6Egj+5hZECFWe4s6QfkpR41IvYVLgWqIb6BW+B/X6Wt6aykb?=
 =?us-ascii?Q?NW4tTj5C5DaT9TNovdVpdQjVoWZwLCUpaJ+/pXWSfgzenBHmoxmGxZvzuqWG?=
 =?us-ascii?Q?ftbrds9midZ49fQ2Mu8hPGqT7pzQRjH22hC9DaL6DsVB48ki4w4XdQiH+Kns?=
 =?us-ascii?Q?qXpTnYHr/ISUVx8ZgY+/SMVAYofwdIorrF2ofwuTZ1paPkVOr4JKhqYKhMfl?=
 =?us-ascii?Q?824wMAiJgUwA3T4KvZTMAHpr1bGmMVxKCCH28uAf4GY8oEM45dBigW7/Bpzq?=
 =?us-ascii?Q?ubIjdEipDpe6dgCAQN9LWMOKkM4oC4+JdkP14aA0kkmEc6V0ZUGC2rsxGKxl?=
 =?us-ascii?Q?zjaaiecZuuMpPYQcrJAmYnzgdTcOnd+oaejJKAiQyMKnTGkmf8g7HwgIC4CH?=
 =?us-ascii?Q?OH74goqfy5IcKih6cawWQOiey6FoODJxtEF2cqXeY6R/xlF0wc1np/gVECKD?=
 =?us-ascii?Q?NxIWcvujLOcLKkjqRtoGG0DQOAxc2wZjBREp2w/JVGACTjkmzqiNIT9fIig/?=
 =?us-ascii?Q?/S2GybKFDrxN3WHDRMzJtxf9brkuDtDjty1MP/3CUaQH5OLgfKQNCEBQ55jb?=
 =?us-ascii?Q?SQ1g9LMjdA9Igy6yatiFk35vB8OelZX8VZJkpKQ5IK+MRl+JOS9eocfJFs0V?=
 =?us-ascii?Q?UpjE8GXIoZ/1Yz65RmX50elDUCwtL4i8fKe74NshR2scrtS55qWt9wKcx2od?=
 =?us-ascii?Q?6ktPOxZHNAyHVLI8V7DOmTF4z1yftIc6DQdgyvzbDFMAwr0DZ/uOxKpdIgec?=
 =?us-ascii?Q?7XdyQ4u5Dn09ihWNLUoru4yW9DWurZ+raNxsuEX7X46FfdmRIBLQxjq3UcMs?=
 =?us-ascii?Q?3UTSrEC7PAKrJxuSa5L1JMkTrACubnb3u9oA5WpIsu44xC5+M7p2HDlSCVSy?=
 =?us-ascii?Q?ymeYBL5EbvKGrMAkIZJ9Ne6kA/+icGWJy3ecbYmmvh+DHNMmsiYigTtR8IJY?=
 =?us-ascii?Q?ISKfefv5Q6vTZvywtB6g6diWj8uW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OQPXPV5F+LP9SbSLJcI2Rvk0VJG6ECnnaXBiopQJjMBJoTDi+2Kj0WNygpNx?=
 =?us-ascii?Q?S01tcimINNmElvjfx52fOPLRI9SNazKZMDh0NJxnsTmgFJHMSfY0AocSdZci?=
 =?us-ascii?Q?lnCsKzp4mni5SyYNUQ00GuA2Yz4+tSLBnI9Aqn9klbxXU5srRYXkWl2THVrI?=
 =?us-ascii?Q?+/g/3vOhbclG2UOSKnf0GOPXxbvLekt3gCsB4lCOZvlq6QSidLHlfiZRZukf?=
 =?us-ascii?Q?gMfeV+vRnR7w+fl4zB3ySUYag010sk5UbzmoH2M99ZWovzVmt/iA10ndGih1?=
 =?us-ascii?Q?qZTP0a//EQhWr0I6w2HB56E8eUNT6c4oOOf7eRStoYMv/GN2wGhWjpcich1Z?=
 =?us-ascii?Q?VZ2xGFpDNde1m4L3VcW6n6h8tyFYslSQW6tnUZtYjKXquUN934ztyJYF7nFK?=
 =?us-ascii?Q?EoyvEogAWIFLSDUnlsOH5JaX7aHD1tBIgBZtFHyMCZgTGF4NBG5Ugu+Cr6zb?=
 =?us-ascii?Q?ZBVqFTRu84Kp/eFsD8lW+qwQf+NjrYSjAt9uWud5LdBz05LrXVrksR3U7F+e?=
 =?us-ascii?Q?w5nYpt4fpT494VsCvCtyFUThx/o5wyhRf1dq729uFKGGKHhPW1QA90W7r/5u?=
 =?us-ascii?Q?b/K2+HNfNM4rPQJBtpd0bYOGlponIO2eFi085wDuiQxZ9cd9ZJdH4ApaJ6oM?=
 =?us-ascii?Q?RYSrFAfUFAlTNd2S+60UaBNDGUk/RMyZO9tcLgO0wpzEY74PBAVYg6mDBaxp?=
 =?us-ascii?Q?rJfI+c61bCBlXt+Dgx1JCjngSoXK7UsDTrMvGH186c0mmpcW7nQ4297AiO3m?=
 =?us-ascii?Q?FDe4vBGf5Z1jYPZfUGaybUVp/VjIwiMfq1eb1S5+/jANjqjZcOgYC8tIDIWp?=
 =?us-ascii?Q?b1csIqSLNgiWHb4e9VS2FxJ0dd6iqaj+GQDc613kklH+i3wEa/+u49mJgdBI?=
 =?us-ascii?Q?ru4KhoGhoc88VDmdpTrDLkhEn68yLy1eCJKWu4ZHn9agA7ZrPwwoGxRgQ6Zq?=
 =?us-ascii?Q?8nDIbOjttsZlhPUTP246sMyvELzUlNWxTbcRiw3DQI1R6qHH1CF4PEfAyrFQ?=
 =?us-ascii?Q?TaXPzoIAzQN4ElYFTOe0O+AkChPBfe+o508S7QIB/n6fbvkPDg6HUOR/wX5X?=
 =?us-ascii?Q?vOWG/7VEwhzM5RoJNKxRm9DochLLi6oK5ahIbM8g71Hi+nDorTPl9g6Qm/7E?=
 =?us-ascii?Q?unFkN1exqbmGbIudnGniX2zXsKorvOB1BhqWFv6CgG2ZkN5wbFD6gXJFhCqs?=
 =?us-ascii?Q?JeGGxk7sP9gRQRuLvNkpuHLIxBZS8aV2hy3G8co/+nbdcSt3lVOOo8WsV89R?=
 =?us-ascii?Q?nYhvIuTXkhWLuKnM+M6PhSQ5HWy+727lxAuCOpFE0fltVGF+lrIm+QvIAA1F?=
 =?us-ascii?Q?gCvAYeh2545kwbM33rsh05ybvPAY4pXaH9VbNg5pFRq6f0+bhOZKoYFhcfoV?=
 =?us-ascii?Q?OabC3BipaBnptVIwJxY6hYdWdFHPnimhzkcG1R4F4pcFkrLruqpGx87ahmJY?=
 =?us-ascii?Q?VZKGDOPlaMvRvWXQV0c3sQEHxVIsNI1A6Lf6c13iaykZCHPcv5mXatZ55OSk?=
 =?us-ascii?Q?0X2Dah3HsWHkUBwAJA83rvOY1RaPtRdY6wAl+2rkqUbzHR0wRm6WN76W41OJ?=
 =?us-ascii?Q?wTKrDIGIuxKaBOU09P0ksYpB3FBYARdwewy+HkvfLaEYR+A4fEaHnVmoV/5M?=
 =?us-ascii?Q?j076o63NeLm26WuVTRu7p0DMF5Rl3UkMBUrUfNUaJOS16TxTTr0RJgBd5kFB?=
 =?us-ascii?Q?wGld2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rFI1qVx602zFTVL8BL5CX4DhSV8lWVRE0/Uthoi3QAqOCAx4VRGopcFMTwC2QW02ZI3j81CCxoktRdxTDHYL1hukQLmg0tJ5tQHWpliy77Vw8qUH+cU0k4Kd4SdzXS7QjHxvdzmw0SfjOKWJXu61dHuznNU69WCv0enBtUa8c8zxvpNWmvnXSvYyw+h9HuSO/RCshI7z1Xv3wwK3avYS5nAkr+Kl0osJWQrwkrsc2Ak+JGFovanERwCUXkQwXqad3UeppCy/4tsewlvVPLlG3TC8Doo+N47fr0TNmXGpfGgtubhHHgk6rvm9uT8mBOUqaIopH6QaH0UjWpWoaLl40C0o8Ehkcyq0nHH9a46mJ1OCo4zLc20TKWmH9VKNDbvSL+N+bJuTIBWybgv+wQ3ri+Es3J4p1l2TZzQoOGkWRud6KuqLYjc6kraYRmgzL1Ev5j9oOvsPmIpefDCxBLDGxaSANUudkmI3d/xW54M1ijF7yUXKvZ6TbbHWTJG4EWGTP7XYVoXTAay0aszbeFJDSHOFpdfshoZRVxFlef+jeTjYx5u23l75zp5zjt8WyhjNuDytmFRCPhLZLhned+R7AoJxOHty+pAXLYxYu18GauM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b84111-b53f-445c-baf4-08dd45924451
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:47.1769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JdObBLcfOQilR/hn/rwAssu6+dSggUsPPQiuud2MtkvgdS9125q4RM+7wuNG9HHv9Amb2wLiUj6QM5X78ZNuQypcmWBebG5/AsZwmXr/4E4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: z_dqMEDScGUagYHd6LSfulv8rnBcb1O6
X-Proofpoint-ORIG-GUID: z_dqMEDScGUagYHd6LSfulv8rnBcb1O6

From: Christoph Hellwig <hch@lst.de>

commit b1c649da15c2e4c86344c8e5af69c8afa215efec upstream.

[backport: dependency of a5f7334 and b3f4e84]

xfs_attr_leaf_try_add is only called by xfs_attr_leaf_addname, and
merging the two will simplify a following error handling fix.

To facilitate this move the remote block state save/restore helpers up in
the file so that they don't need forward declarations now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 176 ++++++++++++++++-----------------------
 1 file changed, 74 insertions(+), 102 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 33edf047e0ad..f94c083e5c35 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -50,7 +50,6 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
-STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -401,6 +400,33 @@ xfs_attr_sf_addname(
 	return error;
 }
 
+/* Save the current remote block info and clear the current pointers. */
+static void
+xfs_attr_save_rmt_blk(
+	struct xfs_da_args	*args)
+{
+	args->blkno2 = args->blkno;
+	args->index2 = args->index;
+	args->rmtblkno2 = args->rmtblkno;
+	args->rmtblkcnt2 = args->rmtblkcnt;
+	args->rmtvaluelen2 = args->rmtvaluelen;
+	args->rmtblkno = 0;
+	args->rmtblkcnt = 0;
+	args->rmtvaluelen = 0;
+}
+
+/* Set stored info about a remote block */
+static void
+xfs_attr_restore_rmt_blk(
+	struct xfs_da_args	*args)
+{
+	args->blkno = args->blkno2;
+	args->index = args->index2;
+	args->rmtblkno = args->rmtblkno2;
+	args->rmtblkcnt = args->rmtblkcnt2;
+	args->rmtvaluelen = args->rmtvaluelen2;
+}
+
 /*
  * Handle the state change on completion of a multi-state attr operation.
  *
@@ -428,49 +454,77 @@ xfs_attr_complete_op(
 	return XFS_DAS_DONE;
 }
 
+/*
+ * Try to add an attribute to an inode in leaf form.
+ */
 static int
 xfs_attr_leaf_addname(
 	struct xfs_attr_intent	*attr)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
+	struct xfs_buf		*bp;
 	int			error;
 
 	ASSERT(xfs_attr_is_leaf(args->dp));
 
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	if (error)
+		return error;
+
 	/*
-	 * Use the leaf buffer we may already hold locked as a result of
-	 * a sf-to-leaf conversion.
+	 * Look up the xattr name to set the insertion point for the new xattr.
 	 */
-	error = xfs_attr_leaf_try_add(args);
-
-	if (error == -ENOSPC) {
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
-			return error;
+	error = xfs_attr3_leaf_lookup_int(bp, args);
+	switch (error) {
+	case -ENOATTR:
+		if (args->op_flags & XFS_DA_OP_REPLACE)
+			goto out_brelse;
+		break;
+	case -EEXIST:
+		if (!(args->op_flags & XFS_DA_OP_REPLACE))
+			goto out_brelse;
 
+		trace_xfs_attr_leaf_replace(args);
 		/*
-		 * We're not in leaf format anymore, so roll the transaction and
-		 * retry the add to the newly allocated node block.
+		 * Save the existing remote attr state so that the current
+		 * values reflect the state of the new attribute we are about to
+		 * add, not the attribute we just found and will remove later.
 		 */
-		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
-		goto out;
+		xfs_attr_save_rmt_blk(args);
+		break;
+	case 0:
+		break;
+	default:
+		goto out_brelse;
 	}
-	if (error)
-		return error;
 
 	/*
 	 * We need to commit and roll if we need to allocate remote xattr blocks
 	 * or perform more xattr manipulations. Otherwise there is nothing more
 	 * to do and we can return success.
 	 */
-	if (args->rmtblkno)
+	error = xfs_attr3_leaf_add(bp, args);
+	if (error) {
+		if (error != -ENOSPC)
+			return error;
+		error = xfs_attr3_leaf_to_node(args);
+		if (error)
+			return error;
+
+		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
+	} else if (args->rmtblkno) {
 		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
-	else
-		attr->xattri_dela_state = xfs_attr_complete_op(attr,
-							XFS_DAS_LEAF_REPLACE);
-out:
+	} else {
+		attr->xattri_dela_state =
+			xfs_attr_complete_op(attr, XFS_DAS_LEAF_REPLACE);
+	}
+
 	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
 	return error;
+
+out_brelse:
+	xfs_trans_brelse(args->trans, bp);
+	return error;
 }
 
 /*
@@ -1164,88 +1218,6 @@ xfs_attr_shortform_addname(
  * External routines when attribute list is one block
  *========================================================================*/
 
-/* Save the current remote block info and clear the current pointers. */
-static void
-xfs_attr_save_rmt_blk(
-	struct xfs_da_args	*args)
-{
-	args->blkno2 = args->blkno;
-	args->index2 = args->index;
-	args->rmtblkno2 = args->rmtblkno;
-	args->rmtblkcnt2 = args->rmtblkcnt;
-	args->rmtvaluelen2 = args->rmtvaluelen;
-	args->rmtblkno = 0;
-	args->rmtblkcnt = 0;
-	args->rmtvaluelen = 0;
-}
-
-/* Set stored info about a remote block */
-static void
-xfs_attr_restore_rmt_blk(
-	struct xfs_da_args	*args)
-{
-	args->blkno = args->blkno2;
-	args->index = args->index2;
-	args->rmtblkno = args->rmtblkno2;
-	args->rmtblkcnt = args->rmtblkcnt2;
-	args->rmtvaluelen = args->rmtvaluelen2;
-}
-
-/*
- * Tries to add an attribute to an inode in leaf form
- *
- * This function is meant to execute as part of a delayed operation and leaves
- * the transaction handling to the caller.  On success the attribute is added
- * and the inode and transaction are left dirty.  If there is not enough space,
- * the attr data is converted to node format and -ENOSPC is returned. Caller is
- * responsible for handling the dirty inode and transaction or adding the attr
- * in node format.
- */
-STATIC int
-xfs_attr_leaf_try_add(
-	struct xfs_da_args	*args)
-{
-	struct xfs_buf		*bp;
-	int			error;
-
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
-	if (error)
-		return error;
-
-	/*
-	 * Look up the xattr name to set the insertion point for the new xattr.
-	 */
-	error = xfs_attr3_leaf_lookup_int(bp, args);
-	switch (error) {
-	case -ENOATTR:
-		if (args->op_flags & XFS_DA_OP_REPLACE)
-			goto out_brelse;
-		break;
-	case -EEXIST:
-		if (!(args->op_flags & XFS_DA_OP_REPLACE))
-			goto out_brelse;
-
-		trace_xfs_attr_leaf_replace(args);
-		/*
-		 * Save the existing remote attr state so that the current
-		 * values reflect the state of the new attribute we are about to
-		 * add, not the attribute we just found and will remove later.
-		 */
-		xfs_attr_save_rmt_blk(args);
-		break;
-	case 0:
-		break;
-	default:
-		goto out_brelse;
-	}
-
-	return xfs_attr3_leaf_add(bp, args);
-
-out_brelse:
-	xfs_trans_brelse(args->trans, bp);
-	return error;
-}
-
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
-- 
2.39.3

