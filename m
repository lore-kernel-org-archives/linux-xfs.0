Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE023F65F7;
	Tue, 13 Oct 2026 09:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884289; cv=fail; b=i11VwBHdmYEk0XXgDMn5bhpVCItTjx/gkDjOMGPyPwh7xL9EDqoacbHpJzw+Aa0HsbWhdaK1J8CXCTARXPTtcU11u4USUPLAXThnajgP+OYmNOzdJLB+Ax5+d4jlVM0yMMz1P+GKBQRt3RvenZAgL1jF2mEqazxSAHW5Jon6f6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884289; c=relaxed/simple;
	bh=N4sFKjJTzF/ujxtaq5jV7HhgtObxGRY+UETOir7W8gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l2BDnsvfJnWzvj5ZA7UxYV+MmBGDOshuanhVixbqVBtmdQZYDI8WGdKRTQJf1b8A9LxzA7B04zkeK4PgCVIMurF8Qb7jfiWAd3nwvhAXwgrm2Y71WSoq9jGcg/h2FqYIKmu3D8e/9/m44N/Pqoq1Ha+0d3jO4exZUBGOhQbGhiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nVs2sKPT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=F7IVu22p; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nVs2sKPT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="F7IVu22p"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bpso3197994;
	Tue, 13 Oct 2026 09:38:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=i66nFE/3stomT3hiXygtbbWR/swB2TUQrDP+noR5ZhI=; b=
	nVs2sKPT8NrdVLZynZJXLSdNnCEdkMHX9VVmejSVWHA4vRbD49Zpy8/hDH3BTzii
	CXdIjfXLaXwBa83/02gBi8IgIzohNrPlAMSfiEaV4UN5lIFl5DLkwfcI+1RE4jPk
	RGk+VtQKYLCE9I9M+VWdMp+WT5xkRurbepCEg5hJ6PY+yXd+QtEf4FezKBjlnHLz
	VR2unBjikewNiCyfzdl61Htv3t+ewa8vTwewzeHpy0uX/H3HBe1jzXJjvxQ/c69n
	TEf0fFozAqZ9e1Mgez/U6yxz5UA2lnIXjfUqpfomcXsnd6dAZ7C72yJtxmvfUgVG
	R5gr0BO/E9ciVwABvHJzXg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dcsbqk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aKwn026366;
	Tue, 13 Oct 2026 09:38:01 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013013.outbound.protection.outlook.com [40.93.201.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt925em-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tG4t32ZIelybq8kvl/bDowZ4OXxieU1fwhXYASAK01ntKruq3pug0W10refS3B2TTy39orW3CjfrgA+Ctcg9rR7fUJcfuN9uzZryFU2H7b1Px95hA3ze4fh1hGiB+0L5YgE+GTIgjt9L5O/FYwm6gdhFcEnSGdKxKUWZ5/1J4Pld89HLS5aakOvy2KRrWeUKOo7QKHlrOgkQ46GsY3GQVaUQYT5hDSS80RY8Wib8NmvDLU0zcU7277mA5NWgtF/Hjz3c7aMGuHQx/xZ1wjGVyl7i3GRNJ0CoT7ny20xhPL85bFrqvi3MsGCsojjdGP9WqjtHeNoKPW7P3aeLitaRhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i66nFE/3stomT3hiXygtbbWR/swB2TUQrDP+noR5ZhI=;
 b=chLxtZ6o9/xw8DKpxDIIwGCTxYKR8akLp0X5HitaSgsZQmimnJpBwShiAoNxP72//BESXbvp5/LoDpSBmci5EQqZw9e+d/fMKSQo+Ud+RgQlnt5pDZE9gIrCcSmBCbdRKPuv2CGHZDqhfCBnb1T89nQ2oK7LY8lWbXZNlabHQYHkgOHXgx9vGlSN3ZxZD0tS8ukz9g5cdKTs7ckVUPlE1slWSszj00KPARIjjl49c5OnbfZ6p74kHXJMO0c/ONTigQRumZ1xf7LymDbifsYTK6Zf/pLva9oC2GFB1KI46u7UQTfeztumAKYeo0nDXkwIMcPyKTrLAMxJpqa8poiIpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i66nFE/3stomT3hiXygtbbWR/swB2TUQrDP+noR5ZhI=;
 b=F7IVu22pbDbtXw+BGQW04kqnP3muXOLYv7Gr51APyd1JCSCmnFG/SR/15GdTdc+vgqUpcwg/Jr4SLgc6XoR1HVeiKhiI29DnjHxnHRRI9dyeGx05pqdjQRlZ8Tr4l/vE+2bjRQQRmLof03fHEXtugjcFJcdiVSVCfQt/SciTegE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:37:59 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:37:59 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.12 v2 5/6] xfs: factor out stale buffer item completion
Date: Tue, 13 Oct 2026 15:07:28 +0530
Message-ID: <6e5d8c0bb75cfa49044d7d5c5535c40e27cf7da2.1791883280.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883280.git.siddh.raman.pant@oracle.com>
References: <cover.1791883280.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0125.apcprd02.prod.outlook.com
 (2603:1096:4:188::13) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 09a60c09-c4aa-406b-e7b1-08df290daab9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	/Ne2b3qLNlPh6l2FJEWWnaIgFYqvTz0EbG2vTOegUIpKsWfAG1gAkbxYcOLSy+FfODjaFQS14iE4toPjLTcQxSIC7qnM2rpxY5s96u+6N2mjvgJVUflKhwJFRPOGnwNAdpy66opecA308y0jhFZvM0ewak204gJF5oiSH5JriryD4DbF0MksWU1aIcby9bQeKsIht6gdYvZjZ/frx7sRLfFEPLC7A1Xg6RFuZ02c8wXo9FMhDWNxE5NWxk5zTxZx3Ya+rI0uiCbR6QXb/dq4U3p92fvIlsIInO3/LJONt4SskJWzQYJQsdAvyzUfq8ZSPY0kd0rlKlq0yeTtx2+X7oSXPyXwtpz1L3FPVZQW0Yj6+5RaEQdhi+3oe41bfNQ8FhpnPsH/IjR651e92JR+vRd/XfFnDnF4AdIoY0H42VzSc2rhohc5rJtdKcdhloIFOA9TRQVLK4iYLP6lG+zBwXR6XoLeqeGFdPxPyR/mn5MwpYTniDZKUR5qCiAHZapV28cOj3SkOX5AXqw7TbBZDi+2eOA74t0Pkh8ZLkCMTr37w0Y4vJUjvAwm9RWi3UCuPp4TTakdmCOEjtL8eZAGbcICcVHFKRsw4GAudB919tqm1fYgoPiU7Fgqcw6vD+jSv3Jtz6M4/LnJpQphExah0aIYOc6HlXcDMTx4YDc5i1s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hiZQgGDwNwAUZt+NDgrNn3zFTTJWTrCyU+7csDD9QQJcBfGQEc9D19T3yhMS?=
 =?us-ascii?Q?O8uttrsXFPTykBQHKoelNUxBrCH+kxdZn0aWwy/gtEFI7Os4yYc66b/oEWDI?=
 =?us-ascii?Q?ZTiXfsMfsCHWrow+nho1fE2DRgAqWihBCEBVMcZHWlvCTNiKWvlCIEqnAz/u?=
 =?us-ascii?Q?qA5KCSYtN/0yho7HlWNO9T+rsmB09y9UK+JSY/3FML4uM+E1OH6aG/4PnSre?=
 =?us-ascii?Q?57gseZYKPwIrLH9IQ+XNr8y3Y5TunCp5xHpU38i1VZTaV/NCzTC7lrrWpibm?=
 =?us-ascii?Q?kFR9t3vc+5SGnr9geAg2EYMSWLQVzlL3Vnr9AqEyrMHe0cR4pD39D6CMRdHL?=
 =?us-ascii?Q?xV8JS3iym/rYMBLWrrtDM+jcUHR910esZZ8Ngld5bmLi3DeDGb20Uj9WQuWe?=
 =?us-ascii?Q?k1AFVokacVfrvItxgAsDSNqtEyJp7HSXsiqojgDWiAGQpVcP8FlZQl6QkLbJ?=
 =?us-ascii?Q?Z9/zjycmuZnhCxv1nW+X6qd05kU9z3UuJbcISOUuNNbv3Zp4B0/TP1n3hfEy?=
 =?us-ascii?Q?nnuTrUZJWjqn5H3HNIqKapxZrkojbmH0xKrrnEVDaAok14fmYZk0PAnXlIpz?=
 =?us-ascii?Q?9lJzmHn7QRuYTmSDIhWBYZGhdfovT5Kcl1MLpT/uc4vdUuXGslqvvULumW9A?=
 =?us-ascii?Q?INlRZmj5g5QpraPVM+KdPyf+STgckKASUI3YTy88Uaesi0ADdVkCpldM0mqn?=
 =?us-ascii?Q?RX1Gj4w2haLRZPmg6xPqMBpGxB8H/1jQZsXbySieujOEVxJiLAJGrniuUnvX?=
 =?us-ascii?Q?33R6lzKjhyttcNrkhcS4FMMApNTQbHLerCb5sZ+7KbI3iUI1OnoK1LvSU1TL?=
 =?us-ascii?Q?yEnuONof/TaV9GToDA/e232J1ull00V5BFjlu5LUmzQWVLm/TJ/Y/vcnT0ew?=
 =?us-ascii?Q?c8/67Ii3aUHSDr/NyvZIzABTBOnFfJzFTrkuuHQEqJ2EcAAzzlUsRP0X9cDV?=
 =?us-ascii?Q?bekgcCCbmeZZFcKZV7DYzJeOd0CaxY15pHrPMEnNlW/ysk3pOTM15vwdhYfR?=
 =?us-ascii?Q?Cv1oKai9OEOx6m7RZGMvTYIIzPu52snGmock+6Yzi4v0OFeS15PAZPGKqrMl?=
 =?us-ascii?Q?D1beYFEnL93+qJEbTaMNAzByKi9smwuYadlBGeyzHLfc7QQ2upDxFickFiIh?=
 =?us-ascii?Q?YlcQMEieZOfYBONFHt9GC9YaDHo4yTHIzAMukssmXcMwWf3e4EsCa1UjiGTx?=
 =?us-ascii?Q?U/7sRnfA0tCkPgxHibRa7P1TW3SE487Yf+iHFKiq2LK+3PEX3lnjTp86LFje?=
 =?us-ascii?Q?wL3G3wmmND0pAVHFDGQ8jGP/l9jrQS5tym+Zxohn7wjXAW+V1WBR7Rr0FbWX?=
 =?us-ascii?Q?q5sL2YwvkwUenFVRJ22GG3Mah75nSPPgpWpM4xtv4QFrgZW6olG5a2y4H1pW?=
 =?us-ascii?Q?bcfj1lvH9b1ef5iEijMIhsthd40J44kSzvEyK2WxAWKWAGkbhDcYGN0r6SRY?=
 =?us-ascii?Q?TXmzYcB5HBF23ftqJQbyfNLk2TIRwC7V+XCvsOuB/XQ4rvDthVRyjF8Shpmu?=
 =?us-ascii?Q?aEeBFv5tLgDz9KuJRuig3Z4jytOgV7s47Jx2MnqBcUfofrCRu+zS+dtsjumx?=
 =?us-ascii?Q?ipk5rwV4dEUpBml6IHeKUTvukwBuIGCTb8AbpAW/qWGPLOTwqNJANBkNv7sl?=
 =?us-ascii?Q?xfzj5p90it90gIPLR0Mnc9bihSSjab7HA5/1+UiWv+oKogVv8o5HMk4mdX58?=
 =?us-ascii?Q?hcR24Jm2lvtuA1QvsLmXWSCQQhL26LNawIpXD47FT3IDO0jb36ESjj9iUSmZ?=
 =?us-ascii?Q?9DLDufnYqFYYq1NfPSFLKcuzCgOq6JyXwRKOcMT2bJefX/n+KzujeOCk9fA4?=
X-MS-Exchange-AntiSpam-MessageData-1: QXeJ4gKtH8lJRege+I63hUxzoPDyiLaIJpQ=
X-Exchange-RoutingPolicyChecked:
	4omV5F28vQASseaSXW1jaxkt6yJffyWmyWoazwGoZb229RhxNFwV78YAWmQYlyznNxokq8KRF960l4jdlTSOn7QLBrg7g1bWCSgAP5Ih+IXxvAsuW6tO5AYx3di8AVg9Kt/K2LtS8FZBFLyOb7Egd3Wut4obeQQq7paF60wp/ZTAiyOG/m06MhcKomufOn3YLpAInfXUYHLNAMhDD/7ZJUXl9g9GrfKQCL/NVezWd5TarX387h2YD4x03HyMMCIbfQ8z3RbVSkSrS0M5J9l9wJcabD10mOw1SqmoEuVWoXizmRQXlotnQt8KRsZFVvQQ52L+75qcGzYojYJn1aKg/A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H9jTB2B42HgJwmweeOVLJYHg+yNSpyZ5Yb2uqlc47jT3agFVI8dInVziSeFhbORQgILC/AMl26ykSrEQogMIsf7n0x7LSmMzVV6zWPVGr4YMeSbCwSlkr9S2cGCB3k4423eEn5pYY/FuV0H/YTv+Znq9GXMMvvOCUabJ+PP0WfniLz+2LmVcFDtgdHss1TyZEfpLKBY8/9L3Jh9yLUQYOrYiDCTUApf3H4LTJr14qm8vzQzTXaRJhfqmnzSHK4g11q1PNuk+zHTw2H1tIUF07BBybcB0y3NVhoVHi1FG1lI/4WzTwccW7z/LF9OiRhimh/zC+54sBxMdRvGcTLb9oDYdnaJf5qStsTMc2UJ6ZQg06Tk2tczo0AdysQY337uGDYwTzCeNpiOvHUBGLC7p8AAEppXdX2Q7kakqN6/88v1eDB+pshxpGtClmB4wCnmBAI44JtoTdsupflAh7bn7ekZ7XeCVazmntacuH4GuLxvL11ZzNitSLSHkGoR4/tbHzHBTJa6rNMmEQqnR/Twogqt8wiT2BYYztmWBR2C6xIBR50wnnqsQtAQsUFOyhn/5OoakA9lPwG72LTf1YIyKVtywWZM1YgGUJi97nXVbkp4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a60c09-c4aa-406b-e7b1-08df290daab9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:37:58.9116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W5t36MFExQfJYpig+6UQn8z9X13IAj9GwO39GHgC/hkS5KcZVS5G7J/R21h8GfdbHjc2R8ZxNNXLjinkaDseBCsaOj35lrkFMV3tC+G9zmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX0do+tMfii3T1
 lPLwols8vE5Z5FgKL0beXjBbMmuqlWGqO9zc+LBmDRCH97hS7urzdNhfYEE0EZkWVN7HVDuI/Fq
 xwu5PpeTjjnnuouk8viczyo4vzPTSZF75mDngfLl2kvTXH4WwGZx
X-Proofpoint-GUID: Vg7Y6yzekWoHqQRbsMsb08RIVQEasKsA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX3PFdQ+3Ih+hg
 x1NfpV/0/INTgTygHFH0/ckI0P9ZRNdfr0EHEkIXD9K6QvDK48NUBk7u2hZKa0BkleoHcb3B+KQ
 y4xQLdIHzrVQ7LAVgdg91cs7H9F0WCp9DYjJoebayGFkL2mD/p+GWoSqLB0wSOzmCE+3w69e+7d
 qEnGY5DcSeDA9+rfIH5ZntgsDwA6jKC43tQcpcotZz6/148Jhx/A4kbm3mVyrc0DELUA2GvobQO
 ZIx8pdMX9KHk6JMwYU5z4blDRMMgTh2zWke+XDy8TxutoRNU6geyagHn7QDiUgnKLX0+cHhffML
 9COmNd0sbz9s7cw1aByOVPNwSDZeVWM+iI5XtlTuifXZNR4PCVE95ORByYwZ3ZYeSiH1T/0Xaol
 QbVbYxlbAmA9/312jiC2c5rA7r/Xjcjfm7EA7UbJsD282gvSfUWPyHuGD+yABhEubXF+72UeS6m
 C/mc266J164MKG4Sc8w==
X-Proofpoint-ORIG-GUID: Vg7Y6yzekWoHqQRbsMsb08RIVQEasKsA
X-Authority-Analysis: v=2.4 cv=EdZd0/mC c=1 sm=1 tr=0 ts=6acdfbfb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=HRhzHcoIBzGTXiVGymcA:9

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
index 042282a08216..9e6a68367ca9 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -539,6 +539,42 @@ xfs_buf_item_pin(
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
@@ -588,13 +624,6 @@ xfs_buf_item_unpin(
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
@@ -605,22 +634,7 @@ xfs_buf_item_unpin(
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

