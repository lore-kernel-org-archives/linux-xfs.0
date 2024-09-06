Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339DA1D79BB
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657122; cv=fail; b=XKF99+ZYN5xUFAFukQmM91NQzTn4sbNBqpHhcbrj4+rGzfRP4sN2v25jVTEoSDHKWOVWVZtHPgypJct6AiGppDDOqSsfp6Fdf9iuBRSJUuBQiclw/ovinZYkur3uu8DMQLDj2+ouwVRv9M5FDrCA2MSyPUvKWBKqvb0lCETGKfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657122; c=relaxed/simple;
	bh=jLmafBpi7O5EXAWPspNMqPsJ6hlU6OP+qeezPN0mwPo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g8xJqMCUUFHBMk27SreQiAnYNEBNR1HwGU+4cp4V8dTfvTCf9pHRTpxdorrbfrlElqzM8ZC7Izn6im23tFPQ3pgV8wxc+pV0M3xYCBJI1AUG73WkuaykkGNSAE46Pe9U8eO70s6rkIJextKZnB5s3Jberwb7N6dMLSDASV5ISwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dDDJk5I0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qYUDe3t3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dDDJk5I0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qYUDe3t3"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXWIr011342
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=PNkjkwkY6oPvrfr/q5f8WlFIn3CkAlLQ/6Hu83Tf/3o=; b=
	dDDJk5I0qka3anw+wbzO3Gbz9d++8xD0AZOQp8U4Iq6Dqu93NRDWSi3xj+utiISv
	70QiDY3y+FJoVOGOrJqEmEZiENaZnn+IgxCG+MIqfVx2M4DqttwEt6DezC/eMD/N
	zEfCdWifaCIRvia/3SoRojjLZ0U+8WpwZFSnh6QWsFx0OzU3l6W0J63nbOVw86GH
	bbYFPl6t68LMsaPEP+Dt50NpHxOqlvBAlKftiXOytrEcCy4/dW6amEHmDbQNxsYC
	ZFs8jacfuUqiQ3FvaMsYZ/N+4Nxl0BHNTUi5m+m99sOSPUZSKfethZOFOHwtu8ZX
	hYK31BRcbUl+0hSRIPt2wQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkajb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486K64cZ016219
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyjeyxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8/EQ3LV2Q4AdUeDd1+NF1vDzGo6A+0BmH7LUro6btpGQcyd8uLjVwe2TvIUBci8hZqcV9FLk43d1FWkErmPMg30cKM0Cfnl9NnQm7Y7zwLExzsVo27Sj9fcvkkdqL7GPGG53VjiiXlqKb+xHPnoV/e+omtkUyNhGzZRgXNsWfbsmeJckBpHgSyFW8hQEnrPUR2eW93+pNjAJ65F6seZLDXQ4ATZZE+T4EcWa2WiKza9tgTZNvbT1s2P3sk2wIJUunNHKDKFFSAp4dI16cotvGYNWNNUjbHNu5d+qG0xgvEAEAkQ4uram/uyX1hrgyOiN0qE9tfK9fJpAT0KqPovjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PNkjkwkY6oPvrfr/q5f8WlFIn3CkAlLQ/6Hu83Tf/3o=;
 b=QmvYDog/S9UPJeXHVno6UAlVBmKgZY+VCXrJx7kmCX6sI98R/nuTvBl5v9R0ZZqSATNQ/z4rZA5eCxdNkcUDH/ocoAwqSBIZQBbY1zmPhu0RIrZD8FTVg+xQt9DPQRuN+FaSs40O89LkjEpxNaToNEWfyE1ou9fYMvJYT5JopzT+Ys5SQD/OfS9l6YBW7tyqXq5QmNTE8Q1CsWsj+p12Wk8/MxvVPlDvmO0EAwunu2M3FDZ4gHb5pRW2bdja4dTYsd5FdJenJNjNwN4nfmF30Pu7giuMPW51m5/7Y2hNV0tBt3LvGoId7QMy6+rDLGOmvkIPxp7uJv0OQNGwlfbtYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNkjkwkY6oPvrfr/q5f8WlFIn3CkAlLQ/6Hu83Tf/3o=;
 b=qYUDe3t3alnzQeVcqxMlF6iuQsr523uZApkOlBEJohBBuSzWqrOS3NQMjrtKSkdiXiT1xj89a+jEKhMFIJsovJvMkY3055a0H4QcHZ5rNAILR6EqPuLfduqXyqRgmNJrGv8omNLxqGHfELNBmpIDJkT4z6D2xGaEFdOAPpVGXUQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6765.namprd10.prod.outlook.com (2603:10b6:8:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:11:58 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:11:58 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 08/22] xfs: check shortform attr entry flags specifically
Date: Fri,  6 Sep 2024 14:11:22 -0700
Message-Id: <20240906211136.70391-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0113.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::28) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: c9b96877-21a8-4ab7-3754-08dcceb88af9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LOHRn7gPDrf4JzcQ4rTmC0TI1TFSlcnp3HQCvYQLSwEeQIEvQOxhlkBvBIlX?=
 =?us-ascii?Q?LzPmngyCZqqNNRr6YQWBaDEkEo4g0fbmcxWUzWenf++3N9GDS9T8liwT5FVR?=
 =?us-ascii?Q?VQkEySnJntq4ReUkSEpG3StZuvMlnPl7D6ERpTJ6ZXRqHBIVtILxNQjnisAj?=
 =?us-ascii?Q?/wmcdhwTUWsiEUFk/8yIykSL0OaUxddqYaKw0Bt/uad+i0y3HzJ9ofIMvyU8?=
 =?us-ascii?Q?GVONNWVeTGGusV515OkUSB0JLTbVEw7SdYcWhTPAdefCpy46NerSvTMqasSF?=
 =?us-ascii?Q?9WnlfFjZlJYJuRfjZGa2vhuCRlQ8ERb/n24oi7+9hEJBLAhtTT20tdZowRLy?=
 =?us-ascii?Q?xNlNsJdTswmOgxTATa4Vn6t60vu1586C5YKMMB+u3Gv+hteT2Y+jnOlc/c5s?=
 =?us-ascii?Q?icjzn1UoIPvBKOnhsPEr65T7jJLvc+d/OBe7rEpY+sU7oSd4olP1XgrYzipt?=
 =?us-ascii?Q?zXu25f6Qxm8O2a452pciGhU1Uco2IcxKqv43o6eGP4UhDVRsbYAOEMzhhO6n?=
 =?us-ascii?Q?LK1W6XiO8UwUY1cf9SrnUil7a4cpdTv2v3iZXjlaAAj0p31YxFUi7C7ynTWc?=
 =?us-ascii?Q?wbrWT1bQErMQilzEk1gqUITByNmXyKbPWvzDLjf82EzJpuQ2FiIuD3yeXgyy?=
 =?us-ascii?Q?fEJzlZLHW35UDQMoTEY1QsR2iIVCdn03q9a8BH38YZjc+ZTwLrU+XW/LJyZC?=
 =?us-ascii?Q?JBoeT6+YfOr0Oo6A+K4OxYd8OS1HGw02v02Np+Xw4NdRJcZl7OBq9/9VmaAW?=
 =?us-ascii?Q?ltXFaw9Cc415s6LhxZNthCq4QkrS4kxJHpxbHC7cjO+QQb1aj/z4MndzUiZU?=
 =?us-ascii?Q?vUM31qHO/GfxVt4ko+CAE0rTwOM3ZFtxDervoefq7YgfWH8h5jwfrUhr8B0c?=
 =?us-ascii?Q?DBUUrWo+xU/ZOz+tstwxXJ4yH525nF3/A718gniehfS8fhDwhMCllawrefk3?=
 =?us-ascii?Q?we2s8Y9SbgUbtk2mAxJGBg0m1RK8PLotE1qTHkVOalUzieSDez9eJiRCWnY7?=
 =?us-ascii?Q?5Np15Co99PMsWvyp32hhjocmb52zMwZZlujNz1fC2drA50ITG5JqlQviF7dn?=
 =?us-ascii?Q?Z7FOP/nhK6pP2J9dQ0jJ0owVua1tPVnuKcktIFvaF+orZYAL1Ctf5ROSjCBY?=
 =?us-ascii?Q?O29gwzWNa6ffsKUDEvDNS7wGIQ0FcBq20d0e7XPJV3yryEXKZTcPESiwPFOG?=
 =?us-ascii?Q?yPGpo89PN+CBACmVKKH4w9lX7AePDQO2AEozoF+CBN5Bit1Mt4ZHmcS62A2b?=
 =?us-ascii?Q?b4U3QU9Uj5Nl3ennh2CfHzbot8Um+FMBugZ1FYGDMSfQpYTY3v7U1S8jl7Yh?=
 =?us-ascii?Q?8CYrGGbucntJCIv4bBZA6lFxRewMaWBcIa05t6WBF9nw2A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C//138tySDaKtNWGtnWHaBFYVLN7MyRyJZs4Lz/yigfbpyhknvT812poZLmw?=
 =?us-ascii?Q?YwAvVudg4pDBAz8HXHfStKQuN+LKE/Gc4kEbb176iM8H3hrL6RF7bAxHcpia?=
 =?us-ascii?Q?a7Oo14KImx5Vi66XugKgj08ksIODrzAI4nYft5sJ4KYJ4K8QQwOwlf+vuWRr?=
 =?us-ascii?Q?595ipoHBVXB8oKGwQ5IFBlKwK8nHQxTGm8N7+/Bao4vBMSQF95R9nr4QtaTW?=
 =?us-ascii?Q?rFxcPqQzgekGox1u1n2q7VUVmJihfaq/E8P8fhyGaRxpahShZPFYeakvlu3q?=
 =?us-ascii?Q?k6hcDdEZqnQzZG96r5ySJlzcYeTX9BoxK/FRZi9COkf+zHS3m+Cv/IXwlQeu?=
 =?us-ascii?Q?uBrdkj3pBt/CKQNUNAmrHdcDyrMJsGRosNcaOMNqkaiSWsRayeTacUPIVwo9?=
 =?us-ascii?Q?VwqFe74oxRrBacDBOa+gCWy6H5u6qu5ve3/m16coE7ycKqurWHrfPyLslF65?=
 =?us-ascii?Q?xugYC12L8GnWmzi+LCTPIZfgtWsg+vzQg8ateF9jqEUCnIHvmbacJE6AikLA?=
 =?us-ascii?Q?viyXLkacCRz1I7JSfr2CY52EOwyhTUfpO9AITJGxi96z02HaNDNbXUFQeprW?=
 =?us-ascii?Q?e7GTf+UzYiaPeGthMImroCFDTK+3JJlsWOawJScLVj2rGj80FFYv7oBXjqgb?=
 =?us-ascii?Q?KyJwkjLheJ+l5XGIx1z5Pr6NKtIwweCBIqJMUOIubdvOX7wL6Q4kgi0O3kVb?=
 =?us-ascii?Q?FDClUjdcjrBao5ZiFqEwdVxFpxkoCeZOWXJc8dgnkVE89wh4Kz5pOB3H40h8?=
 =?us-ascii?Q?tG1tALS0gXM2qMWuQIrZ83AZrFV4JvnAnwFHZBRtL31Y8jJOg1TUCqMK3tpj?=
 =?us-ascii?Q?VwCGN+tQo2Tftt5UVX+8/vvXCViIVryzrTZKwGpRfHNmb8T7v4rkYvOJ1+Iq?=
 =?us-ascii?Q?Xg+J/Cio5yEoPuh0Hlerv2Fa1d+S54eUG5i0Gub5XRAmZCu7V2LiSUaD7oS2?=
 =?us-ascii?Q?Oxq7nk1bopwXIVEufOW75wviZf4VSwizKCR2F1hb2R5mqAFeOxPs/WMKP5Qh?=
 =?us-ascii?Q?t8SfoBY9qnUskgDl5BZRY9XATXOxTTd6Zz7IqCGShoczJuRdJX3r8BhX2rav?=
 =?us-ascii?Q?e9MkMoE5QYsNtvKXChF6WrfPUKt8HcV9atSccIglYNuxKLB2lWYEp6prv+9i?=
 =?us-ascii?Q?wt0pS49Utpim40uiqCLjlhelDHYFRUOFYPovpO0itcibtpy7KB4WwxUy2D5e?=
 =?us-ascii?Q?CmTs1hLUQvDm9orDsqVVXvl/TybgH0St3Z6alq3r8tmY07OEzgRkt+FWZyiQ?=
 =?us-ascii?Q?heM3rg03ctBI9YFb1HCYIFKDcqRyvM2soi3q24pjoO9Z4Uet96m4BykCn//m?=
 =?us-ascii?Q?e6rlqOSB3vMw8eWopcYCWMp56A+QyAo/K7z9R24yxBIZ6uidMcdhd7j1tMSt?=
 =?us-ascii?Q?4BeNqSWT9mi+HHiqUhbbYqJVGDYxIBXkCGrPyWvr8Izaqc1axrjWXgBtgdPy?=
 =?us-ascii?Q?ICynVSGyWsfc1ioZ9+VRxQr3LaJCZCVVoQuqjCOZb+rmUUje89k9YTROZ7vF?=
 =?us-ascii?Q?ZX6RDdpDZ+86P/1dJIDMPWtGM8+4IcX8gRaG2uTt1++QFimhiWhaUsjqst0P?=
 =?us-ascii?Q?1PhEOdjuGqMx72s8j/OLOLGZN7FViNYAuPFMs9ngIKZf9WdsU8zSVhLojK+Q?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	784gLYCmlq9xx9eAQSWkFGzuQFSP2Vqj/wYPq2i75Z+5gmQRHW/Qw4lgBPnygR63fAfiojjwaN+Xg9tB9lEpDdEt/h3G80SnjcPSqwq1CR8x8PfsjX88ZzEhqfwanh1tjCDOF8w4Us/LOjEYL4MrdooEfNDH/9emFn7MnVtrYah1hDAVq9G8sSSdycfv3MZ3HO6L9lBEfqXzlFbCZj/PKNgs06k8YvtVqXL+Oe0CsHT908x2rbgZiuPi2sb7yqWJiml0cpgSadUuJWq2c78CwPYpEc3KUI8RJiPRLRu79jySvhtiVrAaH6bEvzIeDGGAYdB8ljFCjnuW4PiwS9kI9PSRr9p8FuqjrZ/YIcAodUOXQVSXhs8vLJ66oxG64WYukzxtq6Ftl21QoDYVfV4Kf6O2C2T49ue99dtZlFFXJ1V2HPkYAQIeJmpyjE+MpiI2b1+5GnK6ZlxqOsSP6dFYzi4u/tKdTh7b6SqESW/JuconYzJe0llIAupPazF+onprklLmWbVwOl8VMyHE4edxeuza3M9gDM3zwZKYWXDviL6A2cTIBIqx85Rr0CL/w6u7aoxqZ+j6W2QBxDPd1YXa1D/jiRmo9VXKP1OcRDdP9V8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b96877-21a8-4ab7-3754-08dcceb88af9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:11:58.1698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BItxP7WT1GhNYpmWp8CJ4Zstywc8zHd1nC5wcHudl71zgWVL79IjIDS/aZe6ou9uMGyKt+4HpqNT54aVL8tRzJL2D9ZkhjZ1cYgM82wWpdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-GUID: nS7YAL46KxmKazJ_Lh7tOpAbE5MiBjOD
X-Proofpoint-ORIG-GUID: nS7YAL46KxmKazJ_Lh7tOpAbE5MiBjOD

From: "Darrick J. Wong" <djwong@kernel.org>

commit 309dc9cbbb4379241bcc9b5a6a42c04279a0e5a7 upstream.

While reviewing flag checking in the attr scrub functions, we noticed
that the shortform attr scanner didn't catch entries that have the LOCAL
or INCOMPLETE bits set.  Neither of these flags can ever be set on a
shortform attr, so we need to check this narrower set of valid flags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/attr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 990f4bf1c197..419968d5f5cb 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -566,6 +566,15 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		/*
+		 * Shortform entries do not set LOCAL or INCOMPLETE, so the
+		 * only valid flag bits here are for namespaces.
+		 */
+		if (sfe->flags & ~XFS_ATTR_NSP_ONDISK_MASK) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)sfe - (char *)sf,
 				sizeof(struct xfs_attr_sf_entry))) {
-- 
2.39.3

