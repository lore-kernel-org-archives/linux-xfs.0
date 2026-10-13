Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210D14AF9D1;
	Tue, 13 Oct 2026 08:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879377; cv=fail; b=snH9wZ7Q8jXwJniVwSK9T7M6CQAnHg4BbLmcE3fSTsAoEJie3X3Y3kHMYUcQSIoIXNvsL+TqI6Wzw4s4BEDJVNgw71HosKHh7Wkb7jre+w0yllpGkj9DsWVTZBZHCwXiql5X9LfXILVr7N0XxFpJRK4q8HWihyAGG7NXxdxvS8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879377; c=relaxed/simple;
	bh=E6NyunGdp+JmM5+9G+WKCdOoys9lyiMVhDOYbrosLl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MG0vsEv3BUzK4VHJH493kyPG3gCVF3L3G9UcP9Vk99n/cJbDa8PjnJBj5R1+OozrozGlupXIjgCgP8PS9NEwv0PoOoj1dMaiJ//R6cQoSPmb6E28L0bCV1ueRjYfIphhX00w7oV7W7s+PpT9Fv9eGqv+8X87rrC6g7sqssJTBF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j1SuQZ/l; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eXxhKep5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j1SuQZ/l";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eXxhKep5"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2ur8b4134675;
	Tue, 13 Oct 2026 08:16:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=N8BnqocoPPpmRYVigoeQop5V91JAdz9mqyX6FDNedj0=; b=
	j1SuQZ/lPzMeyQ9DNaPl8g/Q1QQY5Y6MuAKQIFwm+l0yzqNvUiPjZ7tkSjJBvzoV
	WoGqc5BREW1eevksVwpuFypVmxlmDwHXtAB6eYBwt40EsjdLVRTjnQvBb0gO3x3m
	8Cc6L1bMxbB0ENupSfMK/gAlsF+sG541Q2LTiuIajz8f9EhFYVuchtQLJkoBmNkt
	rfEATEC0tDnwFQdx/W4vlN0Lu3VETc1A/1nPvjpsJ+/plgcD6i01zizloW3ul/QK
	LBtMf+sJgJFoUNyUfsZSCFJgVky+e9DgqupuYcVwSjiM1VrizWV5jt/pSKVDXdJS
	ieupcbVSHNsygsebvFkgFg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkkv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:16:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86RoI002124;
	Tue, 13 Oct 2026 08:16:11 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012067.outbound.protection.outlook.com [40.93.195.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt8ys9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:16:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o0mE//DlUhzhUpRj+cbghSvNKjfAYAmXgeikWFlctdJhAcuxXDhI3YlMDA8HnpZ0dkP9jq8KJpJsfVh8E0EFc8JlVpx7aD6xVClranrAW5dPA6NYmj+YEpk4yPyje5tIY8cA5r1vAL32qre1Hl3HAWDCGEAur/1Fu7igFVeBBHe7RX7VxhLBL3pKC1CqklaJFMiRU0xLGRrV4jrcNTJd5lxZGNv8p9msDH8d/LUpX7sQ2sUd4BVR1ylPWtTNCrQAWhc7lXeQ97cqLERI6Rwu9dpFQTE0hDnzXXWNkbw4r5Eyf/Ljgv4Eg8mefymw3TF9Whxlh9097/LkqI8Z0FxuUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8BnqocoPPpmRYVigoeQop5V91JAdz9mqyX6FDNedj0=;
 b=v3jcAj1VP6oyOLRBIx01uVoMr9HrUcQztZKJUE6rZsvVCyCt+spY9WB+cE0pFjNp7or4knxN52z8NmDFV5WyC7d+0K3VLVEW16eAE7BgZ3pMWcaY1fTpcC7kQa05Kzq8RRqbY4vG0MQrwIy02dampi4cQgc4qMIhv6ub7tQEAyWbZE3UL6xdw0R8dN7COgRfWi0eEiFztHwKgR8mxKGOCM2enkC9xZA3FsPZp+7BLMolDheoPmnx9fpx4KDPAOCqTZdnqIUP20iKdmQkGP0E/GNVrtZmCsPT2nULpZHqTSGPlxLPtSJAO8M0tLTxVJN4hmmVAe7ruDg0fdpeXHfPgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8BnqocoPPpmRYVigoeQop5V91JAdz9mqyX6FDNedj0=;
 b=eXxhKep5wTj/OJcPJl+FvcAiScSYd7gt2iHpt9w7//+2U/05DF+L2CXWXbINW9Z7jf74vDxXjuwzGOdBaa6YIqngfV+cgtkN+LUmr8kyIbT85jH7TStFkir3hLH95zPCiXLah5WVy2uPTnY2WVfofxo/RPzYG8/LJeMufiXllwU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:16:09 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:16:09 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 13/19] xfs: fix intermittent hang during quotacheck
Date: Tue, 13 Oct 2026 13:44:57 +0530
Message-ID: <5e28d1eaba426503307b4908d3c3f7110c8feb43.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0005.APCP153.PROD.OUTLOOK.COM (2603:1096::15) To
 DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c905e90-1ff2-431b-1305-08df29023caa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|260925021311599003|260925022911599003|260925021911599003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	y8vlq/oQt+TF3wQhCT0wkVNBHqBbjep123yDsAyK8TTJTqdwLuyu2MBh1WXfKRcYjIOMTNZlIKCVqOI3TNZyVcejiczqkWiIzGFO7OeME6rV3lRSJRa6JJAEjkYUomydjOxFHDiUt7qviYfS+ozXz1GDPHOeLkTi8Fwk3RSmbrU/uBa9CLHzUynEuQWAlCj4I5vgd289CSxFBmjAOPpb39fh6RhZSB3aAt29/CRJ2yz+hreTnPDI+Jak0YnFzkQIXJfhYR2tb6Cys57T2+MjYmZ/IResnsP/7IngYZp+sSqFHsjpiiKkq+gdLEUTH/bHykDSEytwjS45PYHj2y6HOeydcNHwbtkg19utkhghtHPS8JW8oWZqcYdtvzcNKLWJnhY705hwBtVbZLjNcYm3XhEL2u4Y6vkm2Ynjpg1aEtwHoXvM/sZatp70Ds0erVNbHDgQofhfglG6Xr/R36qsqKu4kseI54MCzLCFlA344aXeRIGNqtVi7dK9DJgv87JeFuJ6zpdqM5m+Iq0T3rWGffzHGoogFi0o4NOfYj09KcouD8fwOzbTe1kuW5uckAMCdQTvwpKsqn9YH15PkxBtP4EYR7nU8MdF+cmzUf1O6j9wev71OTTQcM+t0lBnYXgNHLP0r+s0Mr28TfYwPMLLgndvU+82h7bOg0uZwtRj7fU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(260925021311599003)(260925022911599003)(260925021911599003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rdf0vgqkjvFSsPx0knsOSdBO1RsH/oCRNuJDGkvyUxeNKAT5qN3zNSPqWeI5?=
 =?us-ascii?Q?KijVYhi78XuOhpwnQbuRfdGRRLcZ7/gz36VZY7NMsvVz8qW5xkNpyI72q8Nz?=
 =?us-ascii?Q?pZq77Rn8DJ4bs7l5YmIT6TdPYPj1C9uW5OT7LH4Js8wH+i+uW3vD95fk8qbh?=
 =?us-ascii?Q?xV6WhRW8PqjAjcVIlzL111/NkPr9Nitn1T3M2rAf83JTF0CpqRW97Lymzxmk?=
 =?us-ascii?Q?syfMq6Jj08juMJja9Ul/7IdLy+y8BwCsK51wtibe+hYk/E1O5/bBXqiks4lQ?=
 =?us-ascii?Q?cO47VLgXFiQK8gmtBfEdgmzmPBV22JZP2f8dfZJvFPQ9Rgim4gN9yOZqxqDk?=
 =?us-ascii?Q?PmZlK4PJ0Pi5GVMkrsT3KRNsNCiyleeTPjEGn5wuB7WFxIO95jC9VaFdAbW6?=
 =?us-ascii?Q?0MxvySjSPO/0eVMJK4u7As7e//OEnA1HPuEhB5R6hK73wNohM9XZXBKiVTPY?=
 =?us-ascii?Q?VW8xC4iu6VfijqsRXMnlAjDkNlEzVAOJZgeV8F2g6YZhLg76/VR2I8y8XMDM?=
 =?us-ascii?Q?6eQqLrD4icpIA9oon0GI8QHtIaHIcxZSka1m+/88yoYwLt3ivcSDy0DEqUCK?=
 =?us-ascii?Q?bVV+p+jyLheY8KRwLx8U2SMwbGI9G1YZE08v96f9WaVlj9Fboc6uix+6hIYq?=
 =?us-ascii?Q?B45k381HZK6EVV7HTRMLZXgTcEETIrjm6VtmNPRHCSllIj+YhrAU+h7My0s4?=
 =?us-ascii?Q?59L9Y+4iwuouNhRxWu0JZdVjpQD2r5QekuNWwesfBuXcZi8AjGqRXfsWgtwU?=
 =?us-ascii?Q?P0NSEUG5edowblxL/755fwxaaXiv7Jkglescafi0qv8z56PgtTUKga6Xgbew?=
 =?us-ascii?Q?n++5NA4W7pb2Ie6712+5xU0sOj5ZLq6hrr8JOK32/nmatTY+02VJUNm5wOZG?=
 =?us-ascii?Q?upxi0bjA+p897lX7BWcYQ4hn18W7QEPEl69a8KcUIRDqBC0O6qCsbQjusm2N?=
 =?us-ascii?Q?wQJ2RF8VBVHx8fxa1V54k0PWiGvV3eY95Ccz1lgQUWMnMrxlkBYxrSYIdEPS?=
 =?us-ascii?Q?HPiLPdgi6CcmK6Ucda9L2Gp5Pz2arWcAGSfV0+/XU4Eg8iIT7nB7xy0562px?=
 =?us-ascii?Q?W8W4l/W+nqj3KKm3RrA72ZU4/ENHaJgcl6luGV5qM526nqjWKIEPLhf08oMS?=
 =?us-ascii?Q?0i89EJkmEOmSOXMIRPmXwFmFqPpHlELXpRHEu/s/ZEi2lOkst3i5VNqwNpet?=
 =?us-ascii?Q?ziqrxYDopgClkwCUkTJoeUeHiuwuj2K2oPsZfyiFDSH2kcnb2vbCwf76TaM2?=
 =?us-ascii?Q?kpYIL6ui0jep1BJAzN8uWEWZY4lTCstFN1L28rB+/OhuOWGPO3Qcexky6XwZ?=
 =?us-ascii?Q?EWN1YgMuzqPsJoix43qYA3pRP98cmwHP6UGQKoRFlLd3Dx/TG+tr7Ygxc0bH?=
 =?us-ascii?Q?BvNlnHpZ1ePJKIv2b82dhFC7SS7T+AXocwLrHIbcGTlnFwHEtdvVkgJe0fzR?=
 =?us-ascii?Q?Wm7enDjrqM510wWEfDNw2ijQIihTqHNNWZPlebfkmlbs57GOAhoYBMrWaUL2?=
 =?us-ascii?Q?Mw4lFXtUhu+grsqCfRsXv5RyJbzJ2VeiD2tjakYtcU72H3VC4eeIANlnYWzz?=
 =?us-ascii?Q?Zb2GocVIN2rP6KRUhMOH6Xy5/XJIcv/cvqvUWnacgITNr12PgPHHrbQBgk0t?=
 =?us-ascii?Q?Gr+76GuCo2odtkIYMgkAmZUWmKReAUnX8dB6RGcdEV7XBuZYc0kyRa/sgpiX?=
 =?us-ascii?Q?b4ZjBavxrHU62BrMX0u4AgaQl3Br88AE1/4Nm0FBA+3yTBTt2Kn2mPOo5iKU?=
 =?us-ascii?Q?6x43zEb0nWe+wCkGQn4iT40hGseXy/FFCwL7QSgcML6mLXni/EJ2P+9j/MiM?=
X-MS-Exchange-AntiSpam-MessageData-1: 5eD8kq93RSxYFS8Fdk4wBJR54jsH2I43ECo=
X-Exchange-RoutingPolicyChecked:
	TLpnrYlu2LYNJWS5+NcQoeZWX9eMBjJXtZZbclTOQ3Pmg7PD7FTWDo6e9uAbdlwbEVJCfChnuiMWVsULMyaCAoIAchpnkuPyDBuji4FmFXEg+lO2JJuwLInuajxoltDJZ7S445x+eNIe4HsQ3BPLqJDSbY0JmnQF4dL08lDuovO4hun8bIWCDw1uDC743wG1xi3j4yBd/jxUKjINykcK8wL9WYFtnZBCopLO5jG9HFUgqiyGHAYGsrC1Gii4X2C/wCK5yNDLVB9iVBEr42uRV7BVGaBJXU6K4efoweaF9iLInPL2qtJgXtZulRNHlNhcW9ZxmfmSGlRg37dTOP7+uA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/HsC47meQVkr4mQ5XfAytEik5nwbfAwI+PNhuebuBgbKGPZKUeVePOMFzTUYwysk6yhH0Ye1sz3mavj1L8sI1PrVswzFcTf+/ySstHRacqhYehG7PDNjn9Y0xNXRb1sDvbSPcWMWWLwNyAQk+Zg7V37PCiimguAOmJXjpEKO0BWOYDnXK3wlBuUrscF/vAWKOQogTd4qYACV6HuPSqBNCtFp8coOCUYCsvl3kgwoqlWjoHl349brR2/zclUnW7tWQNSW8KScoOtnXATsvVP0TL+HF4R2w8k2/Y3J0M7FYddZHgrRibkg1GjD/GYpiJ+TZQg1f13+omwwIGBSOdWBkg0NCwP4TlFKKvUOYj9aTjcGGYnjIIH2AQ68acpesxd+LlvIZEsKHz6sMPtPPAkctXZngEsFaje/f/4HS2M6ZEQdbHsA57mp2+iSbo63lqkjKjTh1J7SFnP/yzGtN4H4p0Be/unATxj/jFFM93QpOuXEtS6sx8G62s363MaKa/umezkHJ6QKlr4x3NGUjyXgH9lufWM33w0tzPmNkHlC5cVhVLuDTUlqZMjBAmxsnznANVmMMNLYvPkMUQO566BqTQD2OjEflCjMOntfQxvL1sQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c905e90-1ff2-431b-1305-08df29023caa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:16:09.5320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUuAZ4yS9VoHeq1L18v9K4QyrnEu3K2ita0qNtBFdOjRnAqlpVy7eXkbfOH7Nsa9P7484IlsRlKNOg8KqGR0yYq/NAWQdKESYCHIo4WmMQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acde8cc cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=85p-hYGmfu7TsMeR7eEA:9
X-Proofpoint-GUID: qp8XsZkjgMRA9RwYo7W310GdNFk90gpD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX+HXuyguSfwny
 heKL8gVGv7M4O56alETZy0FP0EaomIZMg93TBWeiHZAoSOaPvPyEVkmLq8umtKoKSJAM4y4Eb4k
 +4+FDck38aN4+G49BkQ7MZhUuHkSdhA8ShHr4qZr0DSacbn5Pjw3akKsWJOhs02XzCA/672Cm+t
 4ZOjevzfK5pqieFHrfUu9IszAIkznzaR29LhKZoEqaDe3ma6rky9nsOxZs8eQOKs2JgXAAnUrKr
 32ZDZUFwwuyZoX2iOL0UHe9n6mHU14NMro6RU1HRPyeRh6J48mfxvPR61kP2cmtZiz2PGoAokf4
 bcF57efL6GOhAfE/AZyXLHzisdkqP4eNhxbUbQTtev5KMxsoicc+CVDKyAII9YlZSrytVMlDV8v
 7772blMyAt4uvIR/vp2WKX7MvMbXnoqMKsD6kWSWa8FlPiEtnqSUnBRameleY+azZttfrZ1IWlB
 wOc4l/BqQb6YUsyTmbg==
X-Proofpoint-ORIG-GUID: qp8XsZkjgMRA9RwYo7W310GdNFk90gpD
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX/Q8dhJTqLwOB
 AhOBgZNohfFsT67OwdpBEY/TL2KNtDkLJ5oK23CYKfillNoAmqksk6e7PDuEJhFg+Z08FRg8wgf
 fr/vu1pq3lkNXPaO9ao2tMJxsE8vDE+1LHFAHs24dPbH5rwHdi+6

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit f0c2d7d2abca24d19831c99edea458704fac8087 ]

Every now and then, I see the following hang during mount time
quotacheck when running fstests.  Turning on KASAN seems to make it
happen somewhat more frequently.  I've edited the backtrace for brevity.

XFS (sdd): Quotacheck needed: Please wait.
XFS: Assertion failed: bp->b_flags & _XBF_DELWRI_Q, file: fs/xfs/xfs_buf.c, line: 2411
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1831409 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
CPU: 0 PID: 1831409 Comm: mount Tainted: G        W         5.19.0-rc6-xfsx #rc6 09911566947b9f737b036b4af85e399e4b9aef64
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:assfail+0x46/0x4a [xfs]
Code: a0 8f 41 a0 e8 45 fe ff ff 8a 1d 2c 36 10 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 c0 f0 4f a0 e8 10 f0 02 e1 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
RSP: 0018:ffffc900078c7b30 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880099ac000 RCX: 000000007fffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa0418fa0
RBP: ffff8880197bc1c0 R08: 0000000000000000 R09: 000000000000000a
R10: 000000000000000a R11: f000000000000000 R12: ffffc900078c7d20
R13: 00000000fffffff5 R14: ffffc900078c7d20 R15: 0000000000000000
FS:  00007f0449903800(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005610ada631f0 CR3: 0000000014dd8002 CR4: 00000000001706f0
Call Trace:
 <TASK>
 xfs_buf_delwri_pushbuf+0x150/0x160 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_flush_one+0xd6/0x130 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_dquot_walk.isra.0+0x109/0x1e0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_quotacheck+0x319/0x490 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_mount_quotas+0x65/0x2c0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_mountfs+0x6b5/0xab0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_fs_fill_super+0x781/0x990 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 get_tree_bdev+0x175/0x280
 vfs_get_tree+0x1a/0x80
 path_mount+0x6f5/0xaa0
 __x64_sys_mount+0x103/0x140
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

I /think/ this can happen if xfs_qm_flush_one is racing with
xfs_qm_dquot_isolate (i.e. dquot reclaim) when the second function has
taken the dquot flush lock but xfs_qm_dqflush hasn't yet locked the
dquot buffer, let alone queued it to the delwri list.  In this case,
flush_one will fail to get the dquot flush lock, but it can lock the
incore buffer, but xfs_buf_delwri_pushbuf will then trip over this
ASSERT, which checks that the buffer isn't on a delwri list.  The hang
results because the _delwri_submit_buffers ignores non DELWRI_Q buffers,
which means that xfs_buf_iowait waits forever for an IO that has not yet
been scheduled.

AFAICT, a reasonable solution here is to detect a dquot buffer that is
not on a DELWRI list, drop it, and return -EAGAIN to try the flush
again.  It's not /that/ big of a deal if quotacheck writes the dquot
buffer repeatedly before we even set QUOTA_CHKD.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
(cherry picked from commit 8d0baec78e8a7abe03b449820507c9777dae7f7b)
Stable-dep-of: d62016b1a2df ("xfs: avoid dquot buffer pin deadlock")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_qm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3c17e0c0f816..907819e7873e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1245,6 +1245,13 @@ xfs_qm_flush_one(
 			error = -EINVAL;
 			goto out_unlock;
 		}
+
+		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
+			error = -EAGAIN;
+			xfs_buf_relse(bp);
+			goto out_unlock;
+		}
+
 		xfs_buf_unlock(bp);
 
 		xfs_buf_delwri_pushbuf(bp, buffer_list);
-- 
2.53.0

