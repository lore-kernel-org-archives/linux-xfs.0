Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F4047208F;
	Tue, 13 Oct 2026 09:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884392; cv=fail; b=lcmma8y8H5egZAGLdgpgbBhsobuPciRK4L+dP8hwKjiUuA1pFxEEcop3y/7bqTrUuwiS5/GcNBbIw1GFFuxC2ZsxZHQE7t07Vu9iEwyUG4Ioiur1gT29qwuqw58waM7eHuXujiNhEgfK3FzPu4P7g+sMdpN5MJImkRCvN/sm3yc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884392; c=relaxed/simple;
	bh=m5eagEnd00jy8jEkZ3AalH9G/9jw/5zIh3fvT7O0x38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uR1y2retnG1JcXKDEsDsxQiV1x1kRwTNA6oQj/4KPd4MzA5p8I2E0IA5esaATll956pI51/MFAqJVPSxtkxB1JkNsB77tRpyUia72LgprgPj6y5DT7NE+cQ9IbB9/Srwyl04iDuWM9oBUOpa+UzIq24HcFbFSWxj2nraRkRZrGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CIi+TlgJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d22ibw6d; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CIi+TlgJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d22ibw6d"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bsx24060585;
	Tue, 13 Oct 2026 09:39:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tWDd8T1qZifevOSFed+/zh0aAfHicccWWZZo+aELTq0=; b=
	CIi+TlgJE2HZd/urBUtjFhY10ywbblPFBHGDnM/oVdw5SBZCDyrRXJlduVmrtPcd
	/tZ4/9lMJVuUH7y+mnWIOk3HFjPgmFCt0jRmmMvzFR5a7aMfjhJQxooVX/BF7ony
	zUfREgxvKrr7DElQRFFsLhbPPFnei6b7aPaEciYZTL++uUqAyW/zNYmvaGriiWgF
	DbAhQJGVCqY5wEM/VIEJqw0JQ2Ez3HPml41VveOW1DKlEF0wZVb8BQiuA8FTQi5d
	xl9938UEjQYJUebwTaMB0xaySkmVJlG/edbVHpOZImNz86i4j4qRfmX1IXqNPxpX
	WZbh3yQHFZvGB/5NvsZ0Kw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkq80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:39:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTv9010880;
	Tue, 13 Oct 2026 09:39:47 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011008.outbound.protection.outlook.com [52.101.57.8])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d577-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:39:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=biLF93j121zc0PZoRpdJNxj/uItOoTkAjUCJ6wYB8kEj6715qrmzeQkIzDqF9IC5QIIAUNDJD5AF7qBTSkZuIVovfdIGWEE9MqthsqEfuA6sWMqxBRq4ZpVD6onRu8GEXVla2X4Gck6YEl5cgIUwa8/jNPUNTwtKiQOF5riYPXdR1vl8TX5N+5qBGV1mn6Fj5k063R8dT/Aivumv0NnzVHMITJOqTlMyR2+hH5444epkdKjFfA0ilqU/tR3j2eLRTrotYLuJKwcFinBYNWQwGUVwuLE+1kdBSjrRrtKK5EXFA62TbaGg2A8PHfd8aqbpC6QOtNtq9kdAgBZZVVMXzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWDd8T1qZifevOSFed+/zh0aAfHicccWWZZo+aELTq0=;
 b=HQSGn5BxENM7S3JAm/aVvUwAigInez2UKVek+Vzpe59zsjzfQG3YjrcPC1lT+az0gyMG+p59+PzdgGi6gDQGW9qWlk9hVCWnScJpOc9Vt+m++VVWa+2hxE5RlNNt1a4d+5QRfVJlMwc3ofrHX80XgXMivlESMguVCnAO1+XvWO98qAxHsqnrsqy8NHWLp6v3751iBaaVyQXeNKrZAdk282VcUz3zljyXnzRd27UIuY5LT80opPI9Z1/m7r1/3WUc2ttV/MwYmnwk94dyBjiD6GxlWD5lqNph1ny0JyHTVkr05sJ4XPvpM7yA+tHKcBi/eYBVGCkmM+ilUZj2wEOm6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWDd8T1qZifevOSFed+/zh0aAfHicccWWZZo+aELTq0=;
 b=d22ibw6dXa0SMZCpbmrrzX3YnIczYdwU5q0ZDbq2B7tNgbNkAs8hR9pt91e+m9jTWb5c2R7A4QQBJKLE1uE/8nMBLdNXhhSMQF+RHlTEYlF0GD8WQUU4h5Ktgj/t74AJKue9+TxwgfQDBK969JQ+7ZKbuTz4alENA5qxfQHOeNY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.14; Tue, 13 Oct
 2026 09:39:43 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:39:43 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.15 v2 8/9] xfs: factor out stale buffer item completion
Date: Tue, 13 Oct 2026 15:08:59 +0530
Message-ID: <9d2a6e2bcc831963a988e0bff9b73d9b2c96901e.1791883296.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883295.git.siddh.raman.pant@oracle.com>
References: <cover.1791883295.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN3PR01CA0145.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::23) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: acbada9d-a305-4f89-017c-08df290de8ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|23010399003|376014|22082099003|18002099003|261009223027099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	quE+ZGXbqzw4YADJ/T6N+787Xt8zqm1yMk8liU5FWXoMfwAI/fvR7zgefiG3f1hE7C1jjy3ql3zQBNB9WUFyZy82hIt6zoDjrAHeFzce3oen31kmFCuQnzslBfduAlsRsDB1P1hrShtAsweXL4Ydf3BAuuYg0WpgdCttSo7vxnB+3RvqvlSWpJQQy3IaBNRTXGfSH/E7bZCrPfoN99Z4daKou4glpd2vsELuwmuzh58HhHzdJYyAjPRTOJAiObSLM6hNDMkux53QVv3B7UcN6kh7vYGzqgDAFL3yV/f/OO0PAki+5E36uSmMYS3O6Hcd4nDkN1pyplLX26CURMowyS/euJd0U9/KtMzFloEjRRjIbcfPT9r6dWohRqwsVIxKpM53d9JbqJLZlNqeLzHVXijYW4MsaeIhrAv3EhcaJk9FbV3I7+aLNHZM2Xgvfqh+TMPl/x78mK1FLPVAnDJJplVHxpbG/dUXOeIkAkY18uLb1w1mEQCfVP8iKEpgT6Z/qGqTsKK2FLcBuREVO19tmcI+gD3a6kfiE0b1y7ifZCOry+YUs24gFSga6vLmzdHn3BX1eWpAP3tsN2Nu0WurIuHcO7wPgAzobnGrm5yGKbc8t9zxwVsdQSMfCrLfHbqpqo6915T7qQmTrXYg3yGg0wLiedAfgtKihQ9vNGB6nGM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(23010399003)(376014)(22082099003)(18002099003)(261009223027099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fr+S2dottE6Ue+9CU9JcDKKQ1AUWkbCfTRWUh8jWRflhkWA/9s3ejBrtO/hq?=
 =?us-ascii?Q?43eA3EI/dd0nhTyp6l7L1XbG7eYb/EgZFmOfBnKnShowcwd3owDPa1iCHpgg?=
 =?us-ascii?Q?Xo5lJZE8q79v0gQbdhMqrXf6pa1uU6Hr3mdTgZDxuJW1uAnYUamiELo9DG1v?=
 =?us-ascii?Q?TqxzA6ttkWr6enintbBlGB6dfkgo5jTOJuwiby7HXm19slZxdvXpig39MXv1?=
 =?us-ascii?Q?2BtoI2JtfVrgNQ+01hEPIHDki72qZ4RbLx5pjnHsB4zW/MkLdnYYaQ9g1iPn?=
 =?us-ascii?Q?8ucgHpewSq12I2cd4oQecdhQwaICrMD/5hskTMsMAHVx1eBeeG8EQwE6wJIX?=
 =?us-ascii?Q?lKDRAFFZq6FquGWKeZ6Et4MQErRMb9Wi0dqQ0M49q5YQipE79rOjaUzdkTFT?=
 =?us-ascii?Q?u2Z+xFUTC8A/Hj3+DVj76e9NhLtbAw9DPqcAw0AUAovLSvbY46hdkuJq3OQo?=
 =?us-ascii?Q?lDDtCK0cxSST2IsK2gr2Os5SNPu+ezVUcXhU7D2ugTb9BPRHVXaQNb8Kwy90?=
 =?us-ascii?Q?SJtcH0tTN+5txRntqxl+aMNOXmh/51klw6hz3cTyxLvISOoDRp/+m0YpBBFY?=
 =?us-ascii?Q?rLgWJd0h0N3+yp5b2GnkGyzex7jxCmZaF9RNx7K8lph0xhf0muBgcdnpJ8ng?=
 =?us-ascii?Q?z/Tk6D5OQEK+l3+MfxxAS8++4KdcLEs9yhFWZySgt7oqijRt9ofIqnZRPkSk?=
 =?us-ascii?Q?qCrX2i+MZSs+UjA1CTyUPGLEIUP/C9ukrwrnGcu6ylWlil5iMZaUPBtru3Rg?=
 =?us-ascii?Q?lcObmKBRhKqTgWbPinQo6aYt0WO9qCrTR8Xs76kTj7kNzID7mYXVHRooilYc?=
 =?us-ascii?Q?3m7ul6fRh8gWRK9g7V6ziyUwPTRJn3rolU8c0aE1YwgBLlWpudMKTs7haaQ0?=
 =?us-ascii?Q?Cd5r4b2+vH0098+sLc+IO5UwJikOnJaNPsGH8R8T4EH/WPMt8dqRNkHAYVOK?=
 =?us-ascii?Q?xlsBYfxDT7MmlX8oMqw+x5n3TbiG6XrJR7h1/KzQQoC4HrneMQOy0XA8aWeZ?=
 =?us-ascii?Q?Vbtqged1jmWrnEXM8MQAOx7nrYTc3uE6Ple/60yHAuRspsVGMSuK5wdfbndu?=
 =?us-ascii?Q?EgI3S9hvUSNNJ9OmmW4z5xeg/hzOv2+BpIJbG0SMdXFLKt3b0ALxj8f8cgF1?=
 =?us-ascii?Q?x8CCeaZ0SmHtUc9P8Um9RIas8ybdG5y7WbMXj6efX6qrEMsKN6msZ+g7HPOB?=
 =?us-ascii?Q?+2FTNRPi2U5w378Z7Hr/ZqG0pzzAD9iK9HLHOiTiJXW5SdIhwZFDsJCpj9A7?=
 =?us-ascii?Q?wPKlxOVcEBayx4WWdMPmzuTyJOwdatsgdnLU6jfm669JRk5lJY6BATq8XuKZ?=
 =?us-ascii?Q?/jXpUsPSX3L8BMLAs5g8/I7PvoVwSujVuNVm1XnML5XuJpoHTl32ZVW97pN1?=
 =?us-ascii?Q?UZ2Gwct7DPdPsUq4VJIk/WzzxqaTx+8OuCjQF+Z1dtYJ9/LpPRlOGC5R8vFB?=
 =?us-ascii?Q?4aH1KMUPwww3y+9N38hWyOmJMnarfen0iiC60oGODdNKfxHTywg8cVOiud5B?=
 =?us-ascii?Q?TunY/NyMQ9aH8WHmCOqotUc0cNuybu3Q4+Hpp5fEZfMGmNMHhjOroUw55+O7?=
 =?us-ascii?Q?L1RYBLlZhZ3i5MR0RXxDLltFW9tfvPT70TyfnytaLSfG+co3QAsPjSnQMYK4?=
 =?us-ascii?Q?onx97bDyc7ujzWAJO7vwDRkHcJeR7bqoGYovZ8AqmupNjrMQuzTibqK9a2VL?=
 =?us-ascii?Q?OX+1RASYeKmNeo3CVua+ea4p0Ncp4xivs9sJJsbwIodNnxxHLRVKEwRi7rYq?=
 =?us-ascii?Q?TvzyihYbPDs4gW9Url50B7LzLQ1vCkL9nNXu97oTOWAPNfaZmxdW8ICh+IzX?=
X-MS-Exchange-AntiSpam-MessageData-1: V+h97kIiT3L8OFR0/ebcLf2FT6RQ/pSKA1o=
X-Exchange-RoutingPolicyChecked:
	0GppB3M5cVqbAJAryTehXKOJkIZmB9WKqdvycN3X7sz/pTGtmO8t9OxD8UGDUWKONyTeIYdaurc/kHnWczNStJPD8wXatJw96JmPE8i7uvsQUSVbyfEWVVIzvsK2G7YAVBXkwsAZFjDLdml0BJSa9jTxDAxxUKoCYVYLhmxNbEJtSxpjl5EVmZeCNPKy4V77hqQTmoN71sd4MyZKAjtU3Dyh5LGTHN3eEnqe5+qtQFilwpKAqntGDC/LhgRzrg2I8ajlPZpkq6D7h6/d9+svbherS8On+PnjkE20dtrGNCoX2XivxebHAMflPoF12Q2bp9fz2X5FXnCJWhWFUcD9PA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/+eXWpi+UXef6C7IK4Rm2ln5mAnZm81ud5Bs2C3GlSwDDIrFSv8awYk4rCs4yPyt2X6pc+1GHVWO4v3TJ41N1bzbt/kRxNUJz4MbLheZJiucrPiyLKuHj2Nu43LynsV8M2cdvs6ib4g7waomM2WR6lORcapYMEiN0T2e9u+fYWnMa1IswrbtEkzXztrchPnnRf6Glc9U1FepNGZmzzUpCwiVz6zBuHiat3uQf7kARMfsK0WHRI+YOqzK+rFGqtCgU6H0kD+7qup/vPRwbMbiOQSpAnaZqX+MhJv2I/oZDMaOdqrDV/jji55papnQ2+34KySI10So9QU7yJsOKU0MTkhO69lN0fyq+NcuMooezPH9nDnA/i+k41tKRrS4GqaQwSl15deHb8FLYYKFPMFr0DHBgKsppF0uiohNvqB8kmikzW2/KAnSX1kFA1g3iGPUoDdOtCJPkMgDhlblJyivXxaFkJmZ0zRBo+s3e2ww/EYR4EzGkh8GW3kXDpwu0fQxKNLeuvFJmSQ4L9FqDgOAW6lKGuXPItJ5yQemKItaid3W4MTRDYqAw06CZJc6uAKk9FIQBVRHgWCrjM+GhFa+6CSqyVlP5jBJB+Y6GOYGHCY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acbada9d-a305-4f89-017c-08df290de8ce
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:39:43.0585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ltDk+Qe0XQElKadnrN15iyDtcWq993Q4Otdl73fsUBJnJKeHFeZgOrZzM+Ey3UgaJrdNqhani3ICdAOIdWxhH6joXvDqf7rA30yEf9L25PY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acdfc63 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=HRhzHcoIBzGTXiVGymcA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: a3Qkpt913IYlk67Dt1ytZjhZ3MyiS6zJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXxNkk/5mL/itW
 uQY7zPKOAYKcPBLSocgKJDHLYqPKOoQG+gERCHwb+neCJgjK2EybBO14mvkB+gLVYa1nRK+WaS7
 qeueGAtQoDNS3tdq/vxpJPCiR0GMGmPJlrXrZUYg9AGrIPEceUIAODnWMDQsmcy2mXRszChHY+N
 GSAhorD0tXQzD++vBuXpSNIB/k6u0ruhRxS7WZBvEFePxXvU8d7w9IE/6PAGY4FdO0wDYoYuUZ0
 zAZ0gvlANsmqBks0AfwxdGTXt1jShs1Rh9PLm7WG7KqaL1pGI+zTlnIIAlwtrLdeHXYAD2ZyhHS
 a8jTdf+DsqFCH0bsEW/FldrJcT0i83w40QCWbjALCmP7snAWWfwPXbU3MfPCyERNOcBH+7MSrsj
 850yi18I1TahjL5Mxu0R1fpIqH/AuqAMNr2mMNCoVErB6OJ7LR3hW3F/6kMQzCO58PjdwaJPMK+
 hzsz0aIVX1Q2ezEmFMA==
X-Proofpoint-ORIG-GUID: a3Qkpt913IYlk67Dt1ytZjhZ3MyiS6zJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX3EHkvDL/tKze
 qjW/iugIbWB15kuKsQ/xiPqwcDRG7NAMilVKWwLUq38aNMuTU389xjT1c7aPRz3udACOszIR60a
 ggx3D0YzR8qIWj1nmHj/A4FGKoUND2xuuyDGpo9Fzjvjkw5jXlVq

From: Dave Chinner <dchinner@redhat.com>

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 816c330b605c3f4813c0dc0ab5af5cce17ff06b3)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index ebcaccc4ad66..9c3918a63a23 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -540,6 +540,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -589,13 +625,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -606,22 +635,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0

