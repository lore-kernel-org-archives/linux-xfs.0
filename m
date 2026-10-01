Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C870948095F;
	Thu,  1 Oct 2026 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790866373; cv=fail; b=ush1g3JvTxu0pCEOEpXh4LW2sjx3wCNNn6cX6DL9iY1Po7+KMD1aNPpcwNZXCFy6U6myw+ND0gnEAQulz7Tz4VZKFp30tZQ5uHiD1V75eow6ZmOBXCK+dasa6Q1fpxgvtvLWPxq2XkoRidWowHIuLetMSZwVQofE7fFARgkQKJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790866373; c=relaxed/simple;
	bh=37n/4xrnhH72WshUg6WC0WtUDzs/+l1cEclPL0/58lY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=I67VoLn/r1aVFJtCk6AQ+zSXjdVtOQSEvv0zZdMPQCOKBxNi9i5wjYVb+rvFUwwrc2cbsq2VPHdnfO4TQCYICW7dH7DzhYrCLrrFL/nRgrptfRzPYza0DRTS+BBglja5XQ1fM3Zrg0uYpFY/sZWoJeWSOv3TMmwT/qdkjzY6qwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RSACyF5U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C7zX4rZ1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RSACyF5U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C7zX4rZ1"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691DMjv51410840;
	Thu, 1 Oct 2026 14:52:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=K6MgnJOFDUAtHp8R
	0K1xMjqUM5WJfCdS9rE3sNp8M5E=; b=RSACyF5Ukk7wQGpFTcKVSQRrCjqQg8ob
	LsYMOeKxXBA/2TI1XbWz/6sgkgKjSySvIQ+5+2DnvNkof2gYxZRWIys4+Lf34UgG
	Qws/7yMc+plI0Zb2wM8gprAZAQjmMh9Kr4nxXPlzyZtn+i5baT+hAbP4NkhX6vOo
	1Pr7R3Ki7y1ACatRpDpgnzGxQIjEase6AWrHp4J2XUOroFZRj53KTHm0eNUW94E6
	PD5d2tzeq8jH8dhX4nMrDov3ud5oxxm4Xce+V7lJ7u01X5zjpO0bXCa1E/LSMp5U
	ZT7mvVDFTmQViglkQxDgM1VdBluqxihWMdGGwEJhfhuObM++CP5T9w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4y9h61n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Oct 2026 14:52:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 691EnpY4017265;
	Thu, 1 Oct 2026 14:52:44 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012065.outbound.protection.outlook.com [40.93.195.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gey0qe-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 01 Oct 2026 14:52:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K4DqjYVf/1tQjOUQ/WS21kIfUiBprol5H/vpkVCyDvaFw22+wh2+m42Cby6T6Dvvrp/0N5DBjMbl8/djnOwhd0lLf2Kn0q0C4r3ErK3YPldBMpqT/2Tntpk3EAEv9/iZDIR0aF9Mc+g+PVqhSb5BWzIYvrUJvxs98OnoilcA2LYhCMQWTdniGcwA6Ie0fCfX9jHMOhNp237+3VLZOebkXVbbO17CU//aEf4epclnszhB3z1grbM5vIXeYHtqlpYdpfuS1UHcH1ZVWnjRN5UvfYKxgWSob2CGut4ZzCwHz+5Ku6czhBH1EMA6PDgkiYCIZlyd8VgxlQawgHXkG1vVQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6MgnJOFDUAtHp8R0K1xMjqUM5WJfCdS9rE3sNp8M5E=;
 b=id6T2HDxM/zrMcEvzcLXoC0bBfHHeE8xIvM/MNNTS9eXRBv1Z283GFHM7AmlAx2NqduWZix+m+dfj2dJemEguoN1/DhmhsWD1Fd+vwSvAo1I2jvXdHcs9Y6C0Ol12aOearZyQ2jUEmSn8G9eUx447VgIpqll4SboRKXoGXMbj526KGlHFqDZFnlM/AEpn/Znknuo7yN1iHaFMS6Yty7XMyT+dxEzAOnWmd0VzGQrti/fV3EroNfXTviapazzCWTScAqWAvZvU7cQegQbduJ/v5JFG6v7QVarJWYqmiYiNCzqbyMWnGr0y753iJVq5p8J265+76vfg8gLtol3hd6icA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6MgnJOFDUAtHp8R0K1xMjqUM5WJfCdS9rE3sNp8M5E=;
 b=C7zX4rZ113U9MKhkJc75pLmZ9KPlcNu8AgR2QUWqDwvoP0IdDBFtXs8etc5c5yqeRsnASH905S3TrTAjA12SKTCD/GucuPgay/B5SPNJJP06sLeIQHtCuISK2T0LNSf73GuTk4BiyByqGiUGUDqTetk/r/M+2zPPp5uFWIElMzo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4118.namprd10.prod.outlook.com (2603:10b6:610:a4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.12; Thu, 1 Oct 2026 14:52:40 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0472.015; Thu, 1 Oct 2026
 14:52:40 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dchinner@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
Date: Thu,  1 Oct 2026 20:21:53 +0530
Message-ID: <20261001145153.308087-1-siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::9) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4118:EE_
X-MS-Office365-Filtering-Correlation-Id: f185996a-5a96-4ee8-fee1-08df1fcb8e5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	At8vxZGIs7kC1Rm41ZTq3kSwgvBPVzuEft5tYl8J1P4dNUYzTnHbhOmZQ9XAdMfwPr0chkzaDvft3Sf0kNaLYV26OOFyNVARnIRvyixq2MCdOPkvam7T5vAp2eg0gq6X8j4//W+YFO2LUWy2xqj4GN6qZ+lOTTAuS6GlYHKNvy3J6M7o3Au05PXbdXbu2P3d8SqI95UPKOOCFXFz8NeCDbQU21WbqwwBl/ewhr/YtHc//k0x6kHf/yCHu06yY/lAtyZq8hNRfXB1mGB6eZV4H8jIeu2/i4eUz/dGW2S+LYkWO3aq+4pYKSknDyCZeripFswkEbi0L2aNl+NuXV1BoAZ9tuhZuHQ4BYeTBp/AM3DhHWh9NTYDxcTL0tGu66GOXEmJmLsGP/CXqABhCvQ5DSDReOFM03pUqZ7B+OI2R6VVTOEcoeq28H+W3mgi1MN9/FNtro93qHKX2WnvF2g/DE7lg28Cg9eH5flAAAsieDtLco/ivGpm1bfRTtkMllMtiaLBG5/1urZmdMa1L0FKp/XMi8eqLSTjFz3jGBPlyXzbTIm+tzamoRuDZi/X+CWQ9i73oFF3C4OE+eAndgL5oZ9mHwBiN/mG/cMoq4D/quiWRd9fFf6W6HFd8c2ffI3Uu70fyPCs0D+zNvtj2UHfztcatnrE7y8YD6TPcOGsn08=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q/5x8yqdxyKnhaEgy5GGwK4j09Bz/i9sGsPjPKFoonhWCsM1m0g71S/oL3Qy?=
 =?us-ascii?Q?nYR1OqobmfYNjbsw9fKYYTTKMGhC/VkHogGFcx7edmHj+BxgHpgFZZKDR1d3?=
 =?us-ascii?Q?aW9QIW/NyX32Kra6bICXrc/cDc86sPxO+uLUE+TOSUcmKdEKAgGWa954c9j0?=
 =?us-ascii?Q?/DtJbs458TUZPS/XyVnZVyMF94uCWashVDOelc+NpXug7W0kh31pd38ARR4L?=
 =?us-ascii?Q?BgbZrQ3a/CcUDTT6R3nVbU8rLYXmN59i1sIUhmpZ8EQxaNIuPXZabVHu9j75?=
 =?us-ascii?Q?rmZV3FS1zGfKV820CPknqclvJ6K/LImpqqcenv4yUQXguIxqmbN3MIracfzf?=
 =?us-ascii?Q?EyLB7VeR6fGVG4dfGasZjTSDgO9jGt7N8WhDMKTutbt2mvZaZI54jMygTd7b?=
 =?us-ascii?Q?ODyQAejmY6b76xw+2/KueZDQhrHiGvrgi62pupwIdM+OS2Qu8fxOTzcEBQW4?=
 =?us-ascii?Q?HqHwD+J61kxxO8geGJ9inN0lUFGoYEhYP+6g08DwE4SJbrDRSn4mmy3bSKpQ?=
 =?us-ascii?Q?EBXNLi3QGn7VPNZTynN77TfTTwIqL7yN+yk+N1nCAdY8V6AuBudrupooCFMf?=
 =?us-ascii?Q?1yKY99JNUbsaRUtC8dBuq3e31kBr+dv+VFUpGZ0d0g869Y2h+TSEG1ndRNrV?=
 =?us-ascii?Q?w56L7BsS7lXvGL1o1GWDl19xC9lZ3JToqUFxzGMAMR2gsFIpFBkhpmm+X4qY?=
 =?us-ascii?Q?FZqYn3H4bBX93adEAtXdNHd6sRbQmtvkD8iFGGrV36202/C0Jp7J0DneCpYf?=
 =?us-ascii?Q?hEhvFGASbEF46XieqT9uQ69VKPM0RzCBLxpy0J5JS5wQ3Shj4KiGgBWvQROA?=
 =?us-ascii?Q?IAFQMqqtAiaGnBPozPKgBbkWtPS4Tu7UpnZWOptMPaeH8feawGjRGY5zlQxI?=
 =?us-ascii?Q?i0IrBesCtFrF3rGHs56kAs6O9WCumcsbc+decMRgtDgliPp/mbnwz9u5ZGvT?=
 =?us-ascii?Q?dpLt2Sk7KnXET5DLVcg7bzDkV/HSLOKuW286W0nxsnezQ59UxbUAJA+69Jnn?=
 =?us-ascii?Q?KcABa21p6kaq9+Pv68GQG/kPFb0OTs37BY4l+uoILl/KnlQQw2vbht7Bl0mR?=
 =?us-ascii?Q?rmZi5iSBITlCKJ5bdlyWFWtvs5jLXXrAAsSClQ6AkzkrQWWRs2JwC+ILITJC?=
 =?us-ascii?Q?lq58LHZmffAlHrqUxfPvv4ycU0vNWM3VSTQU9jJNjjA22+Yn3go88t+Xw+or?=
 =?us-ascii?Q?DmnfMTIr1vA5wo5U66wBE3IyyRZ97T85Yc631etD9y1Zx99uuGj91fnLnp4P?=
 =?us-ascii?Q?xQSNBH7wNXmbjBxU2eGdNmUJwVmzwDEBv4RVsVgPK8cmFPK29T4Z3nvGQT86?=
 =?us-ascii?Q?a/csy0dlrVYBB6FynSQPrIPUKwIPUl2o+cyuElPItZVk+AV+Z7xPys4IQ/Ek?=
 =?us-ascii?Q?75xD9KwNSwUTmIfrOWZcBZvNOXdZRQihOzI4XD0HUcGyFnzqSCq8rW737XPi?=
 =?us-ascii?Q?xhGp70OGObR+8Q/H62vq7bh11wx0NsrW4JT6yDiB88gPxEoHiKMI+z5sRVsb?=
 =?us-ascii?Q?vIBlALubtr/Rfc5FbsX/E1YmGGWXQ79NkSmqkDzBS0NLiqm0U0vCohZXn2ig?=
 =?us-ascii?Q?iou8vl8YyXLjRKGv08ou+mmuLVl5tZVBep71ZSP7wfm2IMpeOjLsDKQElmfh?=
 =?us-ascii?Q?hKuTdmgC1pcEXi9dWjeK+0+gsFsHc03umN8pOEbzadwsNrwl+HI6YvJ4bjCF?=
 =?us-ascii?Q?8my24Qzhg1MorczXZVK3OGi4nglVk1NlyrTU1l1tt36hUTeSbF2iSCKUDYKs?=
 =?us-ascii?Q?ItlSIDKjTWMbqCo8YXqbylJwAIyZ9i7/OiINVjz9ZHkQZ6IMhbejsSOM5tHP?=
X-MS-Exchange-AntiSpam-MessageData-1: 6zcsjSsweVtRZYyNplfkoUikJqEQdwTWxkU=
X-Exchange-RoutingPolicyChecked:
	ChdlBynckqg1UOZokQ3B3MLuAMHZQDUopvSY9X15uniH5a9CmHHaHKi1qCuSmZ6ce+LIcXhtcuyuKabVwM4xfkCUrq1HHmXLovJV4KcoWf1G4BuMDnqJMebDDgOWBf9br4mRpnz0G2NCmtzzlhB1oHodwo9DkTFeeZ9Rj493+1fNHRTXbpXb/NgdqawNc3IDmKY5hRh7Jt6GNRsEkdjdA1uWGxxgfjNYyjbBUYu3/KBfI87M5bUrxhETk0GEsLvU8sw+oatd0ghZN9vzMdugY7kU8xFWwdc391PsU3pKyfc1JQemI5xlIT1S4fmN2DKDYJg5mJsiNxuUs1gYWd5anQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sYl9zjVE5T91Ofa9qC5GEfkSxUEgT0U5RStwvyrr0+X6L2MAev4XDFxyUWOaq+3lMrXCgrr7EvoC36bhMvhtuT7Q6lmkNB6fQygZRv4JP/dHFgde2y0plkqLoMpOFsTMTKRAgJx8wAIe+4Laz1jZOL73V2+9CnMBokJhWH5u5eeFsKdyqGXEHGc0rDTWv6k3w9c+9eze5sNwmByzqQXrMhjaBKqJWIauZTfDW/2rT2VDPHn//r7cH4eyK3HAuMv1Gv+NKpql5UxsEBB4LEFM43xqe49u8Bl/eonThVl0bH3hKkyoEtzxzChct9bM2ZxESaRiyQXj/h4p0DJ+Jl3OwKeJS50DagNoJnv+lmgMyTTXyIYqeEyLAuKxnLxIp01zjSsHD0TGJZjpuYqqTMWFOLkYrXbJLAdWRa3TaKWkiV+GyfSq740FzxP9oNoCjp3uK0I4SAkhYlGJi3lJ+JqnEq5vNOsXDyHUcCs9bs2Q0IBCIJcMfmP2ELMgozll9HqAC0PVOzmKlQ813l1yGcleLKooxinsql2d0qWBv8wBIZD6ybt6dtr0XNOrA0bkSto6omwqtHHuPNJKHcPZG5i8ytYkbbYvQspinQKMFOHAxv8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f185996a-5a96-4ee8-fee1-08df1fcb8e5d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 14:52:03.8621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OKihn8J2v3ph18kqBX8LujpquUjVOuH6D3u+nuv5Xl3ABQqKBplhFVYoFDCUCwMFUb20MRvRdIiKieAHFBqhtBx/3K/OtyO9t5SLQEmTOIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4118
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610010059
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA1OSBTYWx0ZWRfX+ZQEnfbeR797
 XasXqPVCeHG7DMggI4ic9MN+ZoYpXQsizlZtbrcUenJ+75AzhpNFFsNTYRYsweXLzRwLQW8jITz
 g5wpR1ISEaD2pEGR3VqtFDydtUo7RQ4FnSR7zmK0JAYvgfCkCKUMdr8Bx0OMreRbdktzqUx2HXq
 IiyWYWiLO9QCSgLNi4f4hQQ9rqpaR4uB21Z5p7/PmTwQDeNDopyKq8quDN+VUn+urWGlArEBCcZ
 9jPV52/2KSgapTLD+rqLrm7AHxBJ5KHH72IU6Si8caeUsWxFTgFy783P7Jh4bJOmyKbfVPAsN6H
 c73l3mRk7SMIIIGdpMZQW0VA4xY7iNEgONSrPemvbRp+ZtFHFDRQ8MYRH1c28JC1bD5BLL70ZrR
 //yFEqCjpqVO4/fnp4ztGNKfnEvBSrDD6PJtUttx1s0uQ+4Cmjq8zmlINGt0B3Z0ur868odPy4A
 pAjLX8tklk3MvLRQg6Q==
X-Proofpoint-GUID: O4C8WyiL3XomX5mKtZYWE9KawYYR25BD
X-Proofpoint-ORIG-GUID: O4C8WyiL3XomX5mKtZYWE9KawYYR25BD
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA1OSBTYWx0ZWRfX/ImwsDcMPVi8
 RpxSxeLjqQryNb8TD93FMvgZ6yT1w3CObgEw09Vp5GfjFpdDUfNIAR00j++qZXLYuj6cpEPjs/v
 5j4rnQwq3nhD7j1K6o5EsJ4IGdFmnw/1I/BI6E3aTDXOWGyukgwt
X-Authority-Analysis: v=2.4 cv=IuyL47/g c=1 sm=1 tr=0 ts=6abe73bd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=aV9P-uB20TjLUuXUIe0A:9

Probably an (harmless) error in copy-paste.

Fixes: db6a2274162d ("xfs: catch stale AGF/AGF metadata")
Cc: stable@vger.kernel.org
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
Put in stables <= 6.12 after the backport series lands.

 fs/xfs/libxfs/xfs_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f762dcce8d13..0ffa82400007 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3461,7 +3461,6 @@ xfs_alloc_read_agf(
 	if (!xfs_is_shutdown(pag_mount(pag))) {
 		bool	ok = true;
 
-		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
 		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
 		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
 		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
-- 
2.53.0

