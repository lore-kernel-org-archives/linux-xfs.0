Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737203998B4;
	Tue, 13 Oct 2026 09:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884281; cv=fail; b=lYofkplsMPzNQtEkOle9SuJBfxGCdrbA4IxmfDknzwvUbQqm36mnOzL/s60CdIG2b5h6Ryn8DMCH2w5M4lJDoD4MhO9WsoPEcgqAQV6LSyAFtcKPAvHBHeJJ07aCO6iPX+g+BdE24nSv3mRM/c/paJMP7hlDyL2u8YZUI+NfOjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884281; c=relaxed/simple;
	bh=FaewRyVnXSyVG1oKO9KzDBWG0lW4Yths0ieVEJ8Meb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZFOoX405cNButevBsmlb9tJ5UwVrdx4g4X7hl3+w9AQ43SxZylQH3wfhRfyy8uo7M2Rsh1vBaX3rATPA9/tD4pJSrnJesoeOsHIUyM58v64O7bT+qWFxDIMwOO5Pm6DrdRhtgSZbQarZKMMV5c7IGIio4i1DPl7Y64EiXyfzXgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lpWCxRkB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C30/wvRa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lpWCxRkB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C30/wvRa"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CQrA3031808;
	Tue, 13 Oct 2026 09:37:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VO5Lz4gbmnW+lT5rMNOymNH+y9757l4tdzf+y2AZ/ts=; b=
	lpWCxRkB3TWZlPsYaxN72HFbmR5MBYsVlVcpJCYUqcoaCtQDMFwqkH82EkK1TcgV
	TQ8r4Yzwr3tRR8YH1PHXMccal69rxlO9syDjuw5Udb99gfSDwyA6Uwn8uA2ZN3/M
	Fjj3ZulC1inBRdH6y3devh4kiau+0z608GEjQwpm3PM4QiPIVCJaaWLP7q9DWTqn
	VkKa3TKQbXnjMVeLKB4przfXZUfhdqyofonwduY+Za/jKZJtO/ysDO3DBTn6/Mdk
	SoRJWKMNQDbb+oZ9Da8a4ScA+yFFRGmiv/DBH/0RcGs43+ZTbDJylxRUxLFLj5d1
	1blpPoa+AXmHDOO36O+PKA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbp91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:37:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aJZi026185;
	Tue, 13 Oct 2026 09:37:53 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011034.outbound.protection.outlook.com [52.101.62.34])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9259w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:37:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=caZmYYE2A6B7wo//HyiHn1E3vODLXdhb2VmI8ZmSpXWPjcDdPiBTUZAqMjynNuvs4FM2TCqg+3fbAw61XQBAvpPgVu1aD7yLhvdrQ1qYXVYo0oN8mTN0X4bw1HJ0XCkz7gSpIhe6VmWTaY4dWVmEjfyMHtxbqoLg3DcSPTm8Jvp3PbyX6SDDcW7lbpR2wMBPuuRiwhtsfWfLt5a9WU8wf4uRCaTK1j1ObkgL5c72BoOOBgMCgt6/OJDB4Dsi/CxWPAX/RK+JvuVMXpDYb3rJK5mkaYJa3/3oxb2AUzsG4ovuZWQOTXxo4LzCDvl8+BDNl9FCKeXR1JR3tBGysNLuaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VO5Lz4gbmnW+lT5rMNOymNH+y9757l4tdzf+y2AZ/ts=;
 b=POq5DB0O2AwPtSzraYvoPg6V5LOucpdQm8gG/KdpI3gQ9xy0HA5/xQAXatVhLsYpxkOGF+38pJIiYmnNV5nxeelwtH03CbJuU60MYs5UXmcoPs7/iNf2Teo2zRdq1w4+ecJbkQWbDq7lCpI/+HVHUFeYHLwgrbCddhKsxrx/LioWPVt07YuMu7wXL2DKVXX4GznEr/G4EMTkQPo4OcBCiMu4c4oK60d3atLcKV/LUt1n9gRgyrYNgqmbvpEzfKEY4wH2PrSHOY9+4i8/CA4ytwxFdlKdII8mX2MlbH02zylkoUinpizlLSC/Jmw+hhel8UGPscz8xsUUNpmG7WfuUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VO5Lz4gbmnW+lT5rMNOymNH+y9757l4tdzf+y2AZ/ts=;
 b=C30/wvRaWkIp0ID1Hve0bc80zlY2zeZg4oYgxpCBRw4+vOXTfX3jce57060UgHTA/rnqeZkjreyx4e0wCT/NRDQHQF1fZudEjdohGNh4Btvvk5Et0TZvBpHPPSh6dsE9ww6GtDsBrnV8YlXQr0inoj01TYH93idrbdwWZ/o8CYc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:37:49 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:37:49 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.12 v2 3/6] xfs: avoid dquot buffer pin deadlock
Date: Tue, 13 Oct 2026 15:07:26 +0530
Message-ID: <074aaf75e1bd6db1b3641899308e97c80b54421b.1791883280.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883280.git.siddh.raman.pant@oracle.com>
References: <cover.1791883280.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0199.apcprd04.prod.outlook.com
 (2603:1096:4:187::13) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 38d4c692-b8a8-45cb-9718-08df290da56b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|260925021311599003|260925022911599003|260925021911599003|10067099003|3023799007|261009223027099003|5023799004|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	AabymRq9cSwMad9QT8eehJHuvlqPp+Qe5IlBoeA5TcWQWhsEAh/x8O8I1TWMYebOC+alwnY4JpptRXJRavMbuefGCHxA0hzL+E1LoI4jDsBh73v8a2EUQj7ZSX+4asSZIch723ANiRoX03NJqKTuNhLX6X+kE1OhpGLVdMoykcKseZbrmSmXPTSqhv16c6xIj+OZFDR1TJa17IpHMdBRyslFcz3VB/pDcUHkR8A23Ex/2t5roE4Kod6bpGSjpIwm4fKnbdQ+FgD053o8yaUjsHPvznN9R/JMwivp5/0E6PXFVH3GsTDUscz3pkLa64njDSJl88wimj38Zd22byPSKvvpIcLKg8jtdE5ZuCf8EdLV5wzQuji9A/AEZh6qvsg5kNI6WopRFWhcVkH2qCAXbCsokRF37GEv9L23QwPQLH06b97I37ODoUy1aWKlowmetjIgEbNGEjmZtYyv9n2eEWQ7Hfed+AzkeheQA3zv9EAKnn6LsklqoqAvCpr6VPoHXKmEJkXUeu2ILkHh+aOvnXpG6L5E3yg7v6hDezL+CtMX+7ZGmb4SXa1OQQwUG4sEgFqYOXmVUV2yqKz7IRnPDtw7G2glSRh5bE64gMlDAToFXEjz/JaRhoXAun1Zyb7te/Oux6FEdLcRwSQNbrTHmbY/EfIy0FLr4FH+JIiO7EQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(260925021311599003)(260925022911599003)(260925021911599003)(10067099003)(3023799007)(261009223027099003)(5023799004)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qngSoEXB0rGeWyzI2wmDWOQrxVNtz/jgm3owQ18d3LyJw3SlVdJ3ekCNKNvW?=
 =?us-ascii?Q?zCivp+TveqHLUwWmUGni/ZWIpzDB7G0kI661RM2gV7f1fAGRmxp9TUQAkNVc?=
 =?us-ascii?Q?Ynt18BBedUlrGdKUEpaEUTIKYUJh16dELwtno6qVZs5ZVHtCp3CbkfJWuslw?=
 =?us-ascii?Q?OQ370MCNVePKtBV2fC1OvVP69ILVgl1B4EXK59FrxKNVnZv4l+3dk2Jn98ek?=
 =?us-ascii?Q?kztQU3FSU8MdRkuhzIbOwcF4OkqjXFN8YXGCKHQzMKWiB0cQsoGA8YTk3OvO?=
 =?us-ascii?Q?D1BAMJgxyBXYTNhY31pFuiixngN1OF7xqQu3aRy+bCCCh/UmTU61GEun+yyu?=
 =?us-ascii?Q?8asTWlXl6xaVu5wFfY4kDaOFXEX2/k0iPd8G6lp8HjZ6mc0rtX662P6ppIJu?=
 =?us-ascii?Q?5LLG/Lu7/bDPutv86qnD5B9IKjXhRU+gH5nRZT06zXc0LZDtQMBsr2csb6/u?=
 =?us-ascii?Q?m/7nz8JYJ5nc0dHJmVi2k4AW7HIKjVrH/CwSXq79bUNUhDUddLPJVtIwWx9C?=
 =?us-ascii?Q?UQX1Sd1RK7nKhuXv9iqS5MSAPWHeFCvALEF66/9zPm67+E9zbfwW2TrlQOdW?=
 =?us-ascii?Q?0HzhfjWm5TbQMbhXPxCb/iQsQ4khbHB6D7ZsntD8n5FmlLNK4Txw91JkllK+?=
 =?us-ascii?Q?w+K6jQu+uSASkCfHHu+kCZqch/EU6+828iM8KNd3y1NyOM19VcLyfV7M5IEi?=
 =?us-ascii?Q?wDsyVXpaMHxdLgIq3/RtiJLq8tOvrQjKvk+itOrkRbm6ohHr/YtRYJm4JEpj?=
 =?us-ascii?Q?a7BAKz5nQ3x5Mr8Wbm6lylZQhXRBs0WwwTrrI5ldQnK3ygltd63QG93UiwS8?=
 =?us-ascii?Q?GKDTrbSt9Gz3E05jkFd1myoXgRyLcf6a31PAEr9uFs5LXd1aCd175VUOLWld?=
 =?us-ascii?Q?e5tKxMISS2bnY6MG47uVWMHifP+xajoS3xrvwfqDprrIZYroANRpGvbM4XZX?=
 =?us-ascii?Q?PGs+pgVmNXDDItIX/GAYMJXd/L651cMHYikSbbR9Pn81d/cnwIyI1N77LYY+?=
 =?us-ascii?Q?eQKSBmmoIneqXvIEt7ggQ+3iBIkYAfaK+tRBdnTkOXvNzc5NKJqesyFy14k/?=
 =?us-ascii?Q?yhqgVNty4CYD7oUoQVVZKhU3GZXVNE4lAbJOdRXzH4wRPV2EfFVNMRHDDcSZ?=
 =?us-ascii?Q?mTe2TY5M8wfHSuSGFYggK+w5TjOG+nbTnfbQGMtk3khjEr3wNqst3mBi2GKd?=
 =?us-ascii?Q?uqjLuMsrksD0bA5RX9/KwRlDHFmHmxiORJW+rDiTVpNHPYETsJASwKiD93A8?=
 =?us-ascii?Q?Kw0rtWmeM2DwNyulImpV7LL27b/JwvbLPLf6f0aBPy8X5dL5AQ9P3qK8fY8F?=
 =?us-ascii?Q?88UnrCTOdOWmW7QXI7Xcp9tk8UN9gqAsy/qM0F+IhIJU5EK3oiZhQwD/rGh9?=
 =?us-ascii?Q?D2BeyJAoWfr7knJ+HfcY4HmajIQRMhRgrk/CkLRCI44Wg+NRoHLA31g+fmDK?=
 =?us-ascii?Q?18o3rlcvnHdN1eYWGyYHmbceHnWqUQtiSM2Y4139afgYKoJYMu7ICQdsfJbD?=
 =?us-ascii?Q?QYia9Z1EMv6/8ICeb+h0BgY63EWUFboOaVdtfxOf3FYRaJHha3+WlHiqfn6W?=
 =?us-ascii?Q?bEg4FlQ0a1e0nCj+lxTS1P9mYdzDutCUey3dGwuQTYRPARntYVgnEMuCnM2Y?=
 =?us-ascii?Q?RvC2ZGUtre15hjVwwzW+3ph6ne0mEUZU7i8N4JC95XdytKlz4nFcsfAD01JT?=
 =?us-ascii?Q?tb5+odEvTXHzJ7CXbCjZtefO5RU4q/EjY0u1p9Kcp3sjPMl+SO/tB1sso/m1?=
 =?us-ascii?Q?xyd6ZGz1i23aRUCGAkFJLxZhKK/0O92dHAWEn7JQFNII+cvyooxbylgU6FGn?=
X-MS-Exchange-AntiSpam-MessageData-1: +Xdv22XofVXDVN1gZaAnpYEob9W7nq/bDlA=
X-Exchange-RoutingPolicyChecked:
	om1R8LG5d0XBe8I2VXT5RAPbNvuTjZu0P1VS6s0srU3/G/9kKzGzex+SbP/8l3zXekfD7diy014Ikft184GPi+6tn8GNB2aBDK2tN1kGQ4xbG2chgNtSjwl3vjY8LOxDnUwGYiILRnjtbKgheWQAyxhemnbBaq4BziLXcqC/MRySxAJdMDjZcC53HyTefN1+rDvtFHhAnOP9j3sRu5L/O8VUqlbE2UirwkvrxLnouZ2NAIyderVHWpADoPWFkLrUd+jlLgcd+xj+WnirafG1lQiSQABircCIssgiHdsOTAh/gLhcpqzZMa/a6JmE/CKqutLjfF5FXl5zSqsnPrztJw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8OuJkrgwUkcDP0Ye/yRDGCPXOQhoTUDkV14E8fllc04h+ZDWPoMV1hUVDAHVH1y/LlyRNue6zNmlspFuRbJaifLh+KpbfQzdLlMup+8RMg1VZe84y5fPDuxFuSM032CMH7Ugw0k5aFCRFr3jCkD+v1HI9UIY7WWo1/SQtXwnb9nWhRx0fBVjUqmjEMd4Bjpf/VdL3+Mu2j9qmtdr37+/iiED2LhKNrjECDHlaKCdPEhKj9irf5jVzHUMZIvy2DumOrB/P3elewMhn3LtX11LlldhYVcB7jEX6RVkbR1y3KyjWQ5py1oVuIITVpEd8kMdNlJ/Itro7otyzc/o+EG3gCYIhjQsv0ZSnOCI+f7VB0qc9WHDPMem/bNLyQY+xdyNEGT9q+WzDlbEm7+mi32MiTRi919t/PSsscd3OtRC8yeLQxUW3zWd80SRxy4sUqHpr/JU+qXDNEbVBrjEqsoyNLQg/C/dIQWCoih+nMrNjXoQQ2hVU2F6YCG+hwKcwZmPo0Cm4F9aPu/6oA4A2mZwfdiYiWkz7QU4nEbqcQ0JCZBHypL+90+aXftHFeJ6UVLDDd10SKN2aBIl+OEWwmK6C8wb1Ffr+prxISoH5CDnJ/A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38d4c692-b8a8-45cb-9718-08df290da56b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:37:49.8070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fOQQfSYEOFC9x+tqtJjzpvncyaTQptOWZ5JGVFWduqjtb3sjSKocG9i7BBmXmfUylicCwdPjO6x5GErXiXIHp+XfGGTt78VvWypGD2dpqXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX3d0T3diaVhC4
 LxZFJEQBPIoMzzd/ltNnjD5t910s/hJfV1NjXpq0IDH6JHePpoNy5i44DyyFYyu27IzHA+RjIuo
 sFEBUOCGmGqV7uZlqrNNvInNd5hH5d0vnUAANRmkc0/N84jGrSaKnapWXI+c6Wz3YVqMahGF14a
 ojTrgsO/LTnpHTfCEZMwJ6XDaAstyJ5VzeVDqqNRiPkGzzbo6v5PyLXxbRKhpF7/AeQwpQi4T/7
 Stk1/v0t5jcSfZhIiI1UqXaOWYk/3gsqBKQBbZbQEUrsKuwrfI0u6ZM2vFttvSQ2uLhp0Q1QPdb
 vFoHRRWppR1pZUKkf9c0sZ/mvcguyoUs9MyoTYYeeO69tj0OsvGb5rAajR58tr0StBT6Q1jFYJH
 AfHXRg3WY1X+vv4FO2Cmur6nzTqX+zQSawg8jqyLOQRJ3PrbBu3a1zVUyfDIxABNHqbnNeVQ84G
 CJG6FcPxZu3EXzJl7pQ==
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acdfbf2 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=s_x9I6ZcpGuAll3zZK4A:9
X-Proofpoint-ORIG-GUID: YH6svK54FyO3gzR5pmRmUMfN5YUH1aXM
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX/ZdqyIMX8zi3
 zHfs1ziIFzi1gYYArEcniujq8o+IpuGpEDPxzGCgHWa9KIyHvOj4AY/nCGhpZmlXMweXLtg6PuR
 arWVd0l3+XRqVcToHpcMx0fzTANvDVIoiwVqvE40bUgXVnchLswa
X-Proofpoint-GUID: YH6svK54FyO3gzR5pmRmUMfN5YUH1aXM

From: Dave Chinner <dchinner@redhat.com>

On shutdown when quotas are enabled, the shutdown can deadlock
trying to unpin the dquot buffer buf_log_item like so:

[ 3319.483590] task:kworker/20:0H   state:D stack:14360 pid:1962230 tgid:1962230 ppid:2      task_flags:0x4208060 flags:0x00004000
[ 3319.493966] Workqueue: xfs-log/dm-6 xlog_ioend_work
[ 3319.498458] Call Trace:
[ 3319.500800]  <TASK>
[ 3319.502809]  __schedule+0x699/0xb70
[ 3319.512672]  schedule+0x64/0xd0
[ 3319.515573]  schedule_timeout+0x30/0xf0
[ 3319.528125]  __down_common+0xc3/0x200
[ 3319.531488]  __down+0x1d/0x30
[ 3319.534186]  down+0x48/0x50
[ 3319.540501]  xfs_buf_lock+0x3d/0xe0
[ 3319.543609]  xfs_buf_item_unpin+0x85/0x1b0
[ 3319.547248]  xlog_cil_committed+0x289/0x570
[ 3319.571411]  xlog_cil_process_committed+0x6d/0x90
[ 3319.575590]  xlog_state_shutdown_callbacks+0x52/0x110
[ 3319.580017]  xlog_force_shutdown+0x169/0x1a0
[ 3319.583780]  xlog_ioend_work+0x7c/0xb0
[ 3319.587049]  process_scheduled_works+0x1d6/0x400
[ 3319.591127]  worker_thread+0x202/0x2e0
[ 3319.594452]  kthread+0x20c/0x240

The CIL push has seen the deadlock, so it has aborted the push and
is running CIL checkpoint completion to abort all the items in the
checkpoint. This calls ->iop_unpin(remove = true) to clean up the
log items in the checkpoint.

When a buffer log item is unpined like this, it needs to lock the
buffer to run io completion to correctly fail the buffer and run all
the required completions to fail attached log items as well. In this
case, the attempt to lock the buffer on unpin is hanging because the
buffer is already locked.

I suspected a leaked XFS_BLI_HOLD state because of XFS_BLI_STALE
handling changes I was testing, so I went looking for
pin events on HOLD buffers and unpin events on locked buffer. That
isolated this one buffer with these two events:

xfs_buf_item_pin:     dev 251:6 daddr 0xa910 bbcount 0x2 hold 2 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags HOLD|DIRTY|LOGGED liflags DIRTY
....
xfs_buf_item_unpin:   dev 251:6 daddr 0xa910 bbcount 0x2 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY liflags ABORTED

Firstly, bbcount = 0x2, which means it is not a single sector
structure. That rules out every xfs_trans_bhold() case except one:
dquot buffers.

Then hung task dumping gave this trace:

[ 3197.312078] task:fsync-tester    state:D stack:12080 pid:2051125 tgid:2051125 ppid:1643233 task_flags:0x400000 flags:0x00004002
[ 3197.323007] Call Trace:
[ 3197.325581]  <TASK>
[ 3197.327727]  __schedule+0x699/0xb70
[ 3197.334582]  schedule+0x64/0xd0
[ 3197.337672]  schedule_timeout+0x30/0xf0
[ 3197.350139]  wait_for_completion+0xbd/0x180
[ 3197.354235]  __flush_workqueue+0xef/0x4e0
[ 3197.362229]  xlog_cil_force_seq+0xa0/0x300
[ 3197.374447]  xfs_log_force+0x77/0x230
[ 3197.378015]  xfs_qm_dqunpin_wait+0x49/0xf0
[ 3197.382010]  xfs_qm_dqflush+0x55/0x460
[ 3197.385663]  xfs_qm_dquot_isolate+0x29e/0x4d0
[ 3197.389977]  __list_lru_walk_one+0x141/0x220
[ 3197.398867]  list_lru_walk_one+0x10/0x20
[ 3197.402713]  xfs_qm_shrink_scan+0x6a/0x100
[ 3197.406699]  do_shrink_slab+0x18a/0x350
[ 3197.410512]  shrink_slab+0xf7/0x430
[ 3197.413967]  drop_slab+0x97/0xf0
[ 3197.417121]  drop_caches_sysctl_handler+0x59/0xc0
[ 3197.421654]  proc_sys_call_handler+0x18b/0x280
[ 3197.426050]  proc_sys_write+0x13/0x20
[ 3197.429750]  vfs_write+0x2b8/0x3e0
[ 3197.438532]  ksys_write+0x7e/0xf0
[ 3197.441742]  __x64_sys_write+0x1b/0x30
[ 3197.445363]  x64_sys_call+0x2c72/0x2f60
[ 3197.449044]  do_syscall_64+0x6c/0x140
[ 3197.456341]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Yup, another test run by check-parallel is running drop_caches
concurrently and the dquot shrinker for the hung filesystem is
running. That's trying to flush a dirty dquot from reclaim context,
and it waiting on a log force to complete. xfs_qm_dqflush is called
with the dquot buffer held locked, and so we've called
xfs_log_force() with that buffer locked.

Now the log force is waiting for a workqueue flush to complete, and
that workqueue flush is waiting of CIL checkpoint processing to
finish.

The CIL checkpoint processing is aborting all the log items it has,
and that requires locking aborted buffers to cancel them.

Now, normally this isn't a problem if we are issuing a log force
to unpin an object, because the ->iop_unpin() method wakes pin
waiters first. That results in the pin waiter finishing off whatever
it was doing, dropping the lock and then xfs_buf_item_unpin() can
lock the buffer and fail it.

However, xfs_qm_dqflush() is waiting on the -dquot- unpin event, not
the dquot buffer unpin event, and so it never gets woken and so does
not drop the buffer lock.

Inodes do not have this problem, as they can only be written from
one spot (->iop_push) whilst dquots can be written from multiple
places (memory reclaim, ->iop_push, xfs_dq_dqpurge, and quotacheck).

The reason that the dquot buffer has an attached buffer log item is
that it has been recently allocated. Initialisation of the dquot
buffer logs the buffer directly, thereby pinning it in memory. We
then modify the dquot in a separate operation, and have memory
reclaim racing with a shutdown and we trigger this deadlock.

check-parallel reproduces this reliably on 1kB FSB filesystems with
quota enabled because it does all of these things concurrently
without having to explicitly write tests to exercise these corner
case conditions.

xfs_qm_dquot_logitem_push() doesn't have this deadlock because it
checks if the dquot is pinned before locking the dquot buffer and
skipping it if it is pinned. This means the xfs_qm_dqunpin_wait()
log force in xfs_qm_dqflush() never triggers and we unlock the
buffer safely allowing a concurrent shutdown to fail the buffer
appropriately.

xfs_qm_dqpurge() could have this problem as it is called from
quotacheck and we might have allocated dquot buffers when recording
the quota updates. This can be fixed by calling
xfs_qm_dqunpin_wait() before we lock the dquot buffer. Because we
hold the dquot locked, nothing will be able to add to the pin count
between the unpin_wait and the dqflush callout, so this now makes
xfs_qm_dqpurge() safe against this race.

xfs_qm_dquot_isolate() can also be fixed this same way but, quite
frankly, we shouldn't be doing IO in memory reclaim context. If the
dquot is pinned or dirty, simply rotate it and let memory reclaim
come back to it later, same as we do for inodes.

This then gets rid of the nasty issue in xfs_qm_flush_one() where
quotacheck writeback races with memory reclaim flushing the dquots.
We can lift xfs_qm_dqunpin_wait() up into this code, then get rid of
the "can't get the dqflush lock" buffer write to cycle the dqlfush
lock and enable it to be flushed again.  checking if the dquot is
pinned and returning -EAGAIN so that the dquot walk will revisit the
dquot again later.

Finally, with xfs_qm_dqunpin_wait() lifted into all the callers,
we can remove it from the xfs_qm_dqflush() code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit d62016b1a2df24c8608fe83cd3ae8090412881b3)

6.12:

Fix conflicts due to following missing commits:

fs/xfs/xfs_buf.c:
	eb43b0b5cab8 ("xfs: simplify xfs_buf_delwri_pushbuf")

fs/xfs/xfs_qm.c:
	da0c02516c50 ("mm/list_lru: simplify the list_lru walk callback function")
	fb56fdf8b9a2 ("mm/list_lru: split the lock to per-cgroup scope")

We delete the code so we don't really need to add them.

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf.c   | 55 -----------------------------
 fs/xfs/xfs_buf.h   |  1 -
 fs/xfs/xfs_dquot.c |  4 +--
 fs/xfs/xfs_qm.c    | 87 ++++++++++------------------------------------
 fs/xfs/xfs_trace.h |  1 -
 5 files changed, 20 insertions(+), 128 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1f6b2888bd41..52e3535411b2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2389,61 +2389,6 @@ xfs_buf_delwri_submit(
 	return error;
 }
 
-/*
- * Push a single buffer on a delwri queue.
- *
- * The purpose of this function is to submit a single buffer of a delwri queue
- * and return with the buffer still on the original queue. The waiting delwri
- * buffer submission infrastructure guarantees transfer of the delwri queue
- * buffer reference to a temporary wait list. We reuse this infrastructure to
- * transfer the buffer back to the original queue.
- *
- * Note the buffer transitions from the queued state, to the submitted and wait
- * listed state and back to the queued state during this call. The buffer
- * locking and queue management logic between _delwri_pushbuf() and
- * _delwri_queue() guarantee that the buffer cannot be queued to another list
- * before returning.
- */
-int
-xfs_buf_delwri_pushbuf(
-	struct xfs_buf		*bp,
-	struct list_head	*buffer_list)
-{
-	LIST_HEAD		(submit_list);
-	int			error;
-
-	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-
-	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
-
-	/*
-	 * Isolate the buffer to a new local list so we can submit it for I/O
-	 * independently from the rest of the original list.
-	 */
-	xfs_buf_lock(bp);
-	list_move(&bp->b_list, &submit_list);
-	xfs_buf_unlock(bp);
-
-	/*
-	 * Delwri submission clears the DELWRI_Q buffer flag and returns with
-	 * the buffer on the wait list with the original reference. Rather than
-	 * bounce the buffer from a local wait list back to the original list
-	 * after I/O completion, reuse the original list as the wait list.
-	 */
-	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
-
-	/*
-	 * The buffer is now locked, under I/O and wait listed on the original
-	 * delwri queue. Wait for I/O completion, restore the DELWRI_Q flag and
-	 * return with the buffer unlocked and on the original queue.
-	 */
-	error = xfs_buf_iowait(bp);
-	bp->b_flags |= _XBF_DELWRI_Q;
-	xfs_buf_unlock(bp);
-
-	return error;
-}
-
 void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 {
 	/*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 209a389f2abc..3fd9bc72f8b6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -334,7 +334,6 @@ extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
 void xfs_buf_delwri_queue_here(struct xfs_buf *bp, struct list_head *bl);
 extern int xfs_buf_delwri_submit(struct list_head *);
 extern int xfs_buf_delwri_submit_nowait(struct list_head *);
-extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
 
 static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
 {
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 511e7b0d5871..1dd4dde91736 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1405,11 +1405,9 @@ xfs_qm_dqflush(
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	ASSERT(!completion_done(&dqp->q_flush));
+	ASSERT(atomic_read(&dqp->q_pincount) == 0);
 
 	trace_xfs_dqflush(dqp);
-
-	xfs_qm_dqunpin_wait(dqp);
-
 	fa = xfs_qm_dqflush_check(dqp);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 36ed81eb0d6d..43775ad8ce78 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -132,6 +132,7 @@ xfs_qm_dqpurge(
 
 	dqp->q_flags |= XFS_DQFLAG_FREEING;
 
+	xfs_qm_dqunpin_wait(dqp);
 	xfs_dqflock(dqp);
 
 	/*
@@ -430,6 +431,7 @@ xfs_qm_dquot_isolate(
 	struct xfs_dquot	*dqp = container_of(item,
 						struct xfs_dquot, q_lru);
 	struct xfs_qm_isolate	*isol = arg;
+	enum lru_status		ret = LRU_SKIP;
 
 	if (!xfs_dqlock_nowait(dqp))
 		goto out_miss_busy;
@@ -442,6 +444,16 @@ xfs_qm_dquot_isolate(
 	if (dqp->q_flags & XFS_DQFLAG_FREEING)
 		goto out_miss_unlock;
 
+	/*
+	 * If the dquot is pinned or dirty, rotate it to the end of the LRU to
+	 * give some time for it to be cleaned before we try to isolate it
+	 * again.
+	 */
+	ret = LRU_ROTATE;
+	if (XFS_DQ_IS_DIRTY(dqp) || atomic_read(&dqp->q_pincount) > 0) {
+		goto out_miss_unlock;
+	}
+
 	/*
 	 * This dquot has acquired a reference in the meantime remove it from
 	 * the freelist and try again.
@@ -457,41 +469,14 @@ xfs_qm_dquot_isolate(
 	}
 
 	/*
-	 * If the dquot is dirty, flush it. If it's already being flushed, just
-	 * skip it so there is time for the IO to complete before we try to
-	 * reclaim it again on the next LRU pass.
+	 * The dquot may still be under IO, in which case the flush lock will be
+	 * held. If we can't get the flush lock now, just skip over the dquot as
+	 * if it was dirty.
 	 */
 	if (!xfs_dqflock_nowait(dqp))
 		goto out_miss_unlock;
 
-	if (XFS_DQ_IS_DIRTY(dqp)) {
-		struct xfs_buf	*bp = NULL;
-		int		error;
-
-		trace_xfs_dqreclaim_dirty(dqp);
-
-		/* we have to drop the LRU lock to flush the dquot */
-		spin_unlock(lru_lock);
-
-		error = xfs_dquot_use_attached_buf(dqp, &bp);
-		if (!bp || error == -EAGAIN) {
-			xfs_dqfunlock(dqp);
-			goto out_unlock_dirty;
-		}
-
-		/*
-		 * dqflush completes dqflock on error, and the delwri ioend
-		 * does it on success.
-		 */
-		error = xfs_qm_dqflush(dqp, bp);
-		if (error)
-			goto out_unlock_dirty;
-
-		xfs_buf_delwri_queue(bp, &isol->buffers);
-		xfs_buf_relse(bp);
-		goto out_unlock_dirty;
-	}
-
+	ASSERT(!XFS_DQ_IS_DIRTY(dqp));
 	xfs_dquot_detach_buf(dqp);
 	xfs_dqfunlock(dqp);
 
@@ -513,14 +498,7 @@ xfs_qm_dquot_isolate(
 out_miss_busy:
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
-	return LRU_SKIP;
-
-out_unlock_dirty:
-	trace_xfs_dqreclaim_busy(dqp);
-	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
-	xfs_dqunlock(dqp);
-	spin_lock(lru_lock);
-	return LRU_RETRY;
+	return ret;
 }
 
 static unsigned long
@@ -1275,7 +1253,6 @@ xfs_qm_flush_one(
 	struct xfs_dquot	*dqp,
 	void			*data)
 {
-	struct xfs_mount	*mp = dqp->q_mount;
 	struct list_head	*buffer_list = data;
 	struct xfs_buf		*bp = NULL;
 	int			error = 0;
@@ -1286,34 +1263,8 @@ xfs_qm_flush_one(
 	if (!XFS_DQ_IS_DIRTY(dqp))
 		goto out_unlock;
 
-	/*
-	 * The only way the dquot is already flush locked by the time quotacheck
-	 * gets here is if reclaim flushed it before the dqadjust walk dirtied
-	 * it for the final time. Quotacheck collects all dquot bufs in the
-	 * local delwri queue before dquots are dirtied, so reclaim can't have
-	 * possibly queued it for I/O. The only way out is to push the buffer to
-	 * cycle the flush lock.
-	 */
-	if (!xfs_dqflock_nowait(dqp)) {
-		/* buf is pinned in-core by delwri list */
-		error = xfs_buf_incore(mp->m_ddev_targp, dqp->q_blkno,
-				mp->m_quotainfo->qi_dqchunklen, 0, &bp);
-		if (error)
-			goto out_unlock;
-
-		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
-			error = -EAGAIN;
-			xfs_buf_relse(bp);
-			goto out_unlock;
-		}
-		xfs_buf_unlock(bp);
-
-		xfs_buf_delwri_pushbuf(bp, buffer_list);
-		xfs_buf_rele(bp);
-
-		error = -EAGAIN;
-		goto out_unlock;
-	}
+	xfs_qm_dqunpin_wait(dqp);
+	xfs_dqflock(dqp);
 
 	error = xfs_dquot_use_attached_buf(dqp, &bp);
 	if (error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a53a57b4e365..526920b41766 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -493,7 +493,6 @@ DEFINE_BUF_EVENT(xfs_buf_iowait_done);
 DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
 DEFINE_BUF_EVENT(xfs_buf_delwri_queued);
 DEFINE_BUF_EVENT(xfs_buf_delwri_split);
-DEFINE_BUF_EVENT(xfs_buf_delwri_pushbuf);
 DEFINE_BUF_EVENT(xfs_buf_get_uncached);
 DEFINE_BUF_EVENT(xfs_buf_item_relse);
 DEFINE_BUF_EVENT(xfs_buf_iodone_async);
-- 
2.53.0

