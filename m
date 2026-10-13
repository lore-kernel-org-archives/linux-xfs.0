Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38865395AE4;
	Tue, 13 Oct 2026 08:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879216; cv=fail; b=RehFcSnK7CJDTYt7yScv3E48SZe1PO2d9wT4xIGodokNZzX2odhPhD8o80IP+3NDn2Rq6rP3/3+o8Fasc7gHG3kza0IbtBwscF+1ZcplE+ZzLgSfepSa7pSESk6lwl9tWwR5pcrmNEKTyvh2nhGG1KSx3U0eTaJWTaZI/O+QDJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879216; c=relaxed/simple;
	bh=CfBNZe18GdSgjGzpV5R1FibdKxD9l8H50rJKm0H0Haw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LeJ6YvpxK12+AKn50rCrOmnvgeGuyv/Mb/7WPFPWkjqGfZlTqhDjz71JPsYSQscllt2C5fLNo5M8orw4Q4xqBRls/TgN/HHFuW+T1I3CJDTdo0dVKsCnLLpYbtNluRAvNyEaqR05Q34C41lCvJvKNQcf6FThGJlNCWDf5g6j01w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YuiqGIyP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NJ6ym1yi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YuiqGIyP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NJ6ym1yi"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CQkr3031808;
	Tue, 13 Oct 2026 08:13:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yO5dSRia7ZIqOUr1xuYwO+SDzxrJoGmINuUcQVUjGMA=; b=
	YuiqGIyPGTD8umkMGILrMkod4fej+fdhfAYCr+tC1UoVME3airX0Aef4gj9ZGUR/
	BQ5vPNbXbs9MxoO3/mwBKwcnOZ6j0ZR/KEOyEmO+5YsduAnw7RaHna0WIktvjjYN
	wWPEAZpFa++Ya/w5C/gQvNRZa9zTVEKpb3vIjw5Hs0A7jET8YzgzjK2OeQ7WjOw5
	5rMJ88R00vbwNHaseiQGm+W22COzU0qDfW815KyBZn+4pnFbBph/gTRAjs0Gdtr/
	KWjrAoEeUrxtyTTOvdc9VusMEvqryO3yNsYxnlGdffSCUqmxj76h1InpNNPRkzQE
	mNDOqX09VMkq/CPHGrPgNA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbjuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:13:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86hBJ033533;
	Tue, 13 Oct 2026 08:13:29 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010064.outbound.protection.outlook.com [52.101.201.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btnxq77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:13:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xoE1Qn01GAKAyngAtuSuzdUFKOiO/Txo15bvTv9P2kjDazPElU20In8jG1iKxE/cOTBBoeIY5ORcbl1tx+1VkxmMXPjekdLKHIjb41qg8IfLOd8MzgWcwrv4aJOFOgICDFmjE4IdWrNPFLsBE3jH36Gyfs1WmJEZ8yGyThUa75+zcWQLAr80wqsHfxG000TdLKRRfq8i2TgiYy7BHYvita7xOMc5afwcPLGI0Yehp1YVPYVPAX9S4Rv1wG8yS9xECmXUoXyuupkxcRVz2FeqBcM1aVna9hrsgcxdxXFjz29uA8VySxg9BHhtq+DKJ2riVNRyVyc3WjeLpVRg/rdQOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yO5dSRia7ZIqOUr1xuYwO+SDzxrJoGmINuUcQVUjGMA=;
 b=IHjdJB8u2Fd5IqdMmpPcUQWnQ88ll7b+xmkefSTI+X2QV1boynhbdpNhUrAJKnPpmbBqnYgFFRQkzgetKlV2Cu+c7uf4y0lV9QxTF52bgGeKj2c1//Ow2bXcha8/jWhJi2/BJ56S/GVjSH3v7dNmZc8+wPhyyTNoYhkWvR8a+g8oVcuwZJZVhJRiisNfSFK1kBmwMqMgQ4X19hl17UYAYEFcpwah62IjSB57ruRtO8J9uBsKFVfxV9JrZ62APkv+M676uLqeZ0DlIr9EtnZnf6KHQ+pkenjqFyq6cw3WwavS5nAB27MM2O2vt53IG5O7ZwXFoqkCdAyufxLh1OfZ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yO5dSRia7ZIqOUr1xuYwO+SDzxrJoGmINuUcQVUjGMA=;
 b=NJ6ym1yiRn0sCp0L/z9bvW/8hGlTbSLXT9llPOghQtJt6cT5xmDhqKnl1a18fyaVwAzoDM56ojIkTDwrkqe9qGVt4I3+4ZDevhGRes8n0PdWySGpKR972VjtKVkg5r0zXrhacdKD4bT81R10Wvhd/aegTtKYQtBqzfcil20/qo8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:13:25 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:13:24 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 v2 0/5] Backport of XFS umount hang fixes
Date: Tue, 13 Oct 2026 13:43:15 +0530
Message-ID: <cover.1791877865.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
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
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: fdafa6a1-3b79-4970-caa6-08df2901da3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|56012099006|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4e3t/ncjtEHqTaKl4gWNPi8NToTJ7/xlfor0cTTGZNwCDpRz+zWh96yow63EWxSMr4vaC8GQDvuIR+djbV7M05K0MGyvuTqPrkeV+LkyTW4Y94ruWNDYrSMH8pyY0hrVr8X7foXX7UX2vkFZm8v4RMs5T93NEBPn3vmVLKOba6coEHqPhHRCTBNNwtVKEKIiyjAwm97/T5L+3FKf6zCdqKk+CGJxkKa/acugXuOZz7ch5F3/kVcqnFBS0Vh9XBo3FxDR+5pSZCAwbBtb9IQsZHjSD0pUemuiqxU59dhA/z7x31/mvDp4Pfw6aGo3mkwa+sow+CTbaZoi+B3hdFsYglJ2WADjY+uprOnsgh1RIsJ7MIrK5r7kVKIP5674o5VIRcbzDLfmokTg2Av5ZBgnYtBvVYQX60AHN+ZwiU5QiN9sEn0aOzT2Xnj9W6S7RwYRqPJ+5pJSNph7OoWkA/hVctB98EWo6vAV/ZN66liDELfY3fipZ/AeN6dpLaz2K0zzx+u1LhameFE0wWiylxMUE2bOTW92C3XvVZxPCFYkIwQNmEMprfLF+nlXXmnhwduJcql3k+wDSowbMdChD1Ozw4TN8eWF1JU1tspqNeBOGEawYzY4WqxVKszDenSPO7Gu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vuSz697au62/TBxqux45NfbEyJPnjV14rkjouZyShmp3eer7WDV9nl1uApB6?=
 =?us-ascii?Q?k2PekgrsvWT0O/ZyNLVFOgN8pOPBrYS5BnvU3HCPCSmV6TXqY2e8THQV/Qqf?=
 =?us-ascii?Q?zvu1pwtJDVPc7deVup+VxWuPrkuPtsxvorFjQo5sTOMmxaGTbNSKzgLeQouM?=
 =?us-ascii?Q?hfcTlOeNeb0NtkkCOm/dvnT1yUMgmSkVo49x8tTBRUlBrDO5MUz7xO0bG+g2?=
 =?us-ascii?Q?b2W4QvbfRUCDRItMG8yzTr4QPQ5Ecmm6M95INdxCwLg7EZlzU8T3EV7qdQQc?=
 =?us-ascii?Q?nzkLno3aQTTySNUOshGcSASSUfvrsA1bjwq1xlQg1FQcQLcx/zr7ueVy0qIU?=
 =?us-ascii?Q?o0EQXDG9YGzjxebvTF2YhAsQINnHhxATf93prstf/uDgG3n/pluvBzHL14uh?=
 =?us-ascii?Q?7BP1E47evx8O4H852G5axUg4dLk8VyOG4Cl3jowg5fuBeVBQ4yvQ1pMVMP7V?=
 =?us-ascii?Q?Q0g6vG/t64/VeiTvXH1/FOK5iK2lHYd/mcbtZUeBgwZJwCKMjINqU713jP1n?=
 =?us-ascii?Q?7V8YrohgyCHNBamsbqT3C0SfMQHNI3B8RZcKKe4khhr4JZP7qV9Jn//2FcQN?=
 =?us-ascii?Q?ps0eVZhY9hMwazij2gVmayfRCWDqvTtyHiajmb7eQIu1aX/YxXClL4eIqyo1?=
 =?us-ascii?Q?AuHLN4JAC4QUYuF8uwsACaHyj9GTNRxHA/eY6kSElTAmdn0XB7me6eJUHWsi?=
 =?us-ascii?Q?k0P3S2kL4WOjfEBFPteOb66IEkDuxb31qYw9kPhKwejWf+ys/diEoZdC+pAU?=
 =?us-ascii?Q?qbw6JFlsOovGsqm8A9tmhquKQ+xiTDr3GOPRt68P5kEVYkEZ9BrcwcNKn9lx?=
 =?us-ascii?Q?kaVC4dN4gYAkO9+4i6Z+KjEWR5QMua8SumALe5KUb059iLMpDbeJY9aiS+ky?=
 =?us-ascii?Q?OCpscaVQ96ECI+dXz2lfMR55nxFcZzNPXY/iXtEe9NInoZ2UeFQB56UGxB6G?=
 =?us-ascii?Q?p46dyVrOtyzd5FYCCVv7fJaS+qgAmmYBsYr/aciBZ5adhJ31TLG01j0yCzRI?=
 =?us-ascii?Q?46LJDNlkQpFQ6wE+pddTD0XsOngDaFu70TNJDz2BQcB+nZnQITKqEB5InVra?=
 =?us-ascii?Q?MLllUaCnkN4Mt0x3N49gzhisooHC4HozkOMbDf4VymDUc6CzZSYPjn9vpD7c?=
 =?us-ascii?Q?yNoMyNBBmDE93wSSlGfJV9KTaRUWtVAwlIXpfWpKjpQx7akgec8RfYIxz3l7?=
 =?us-ascii?Q?wtPSDdInnGuXs9wRSl5mQGZP5/TaKuPD5HHC9wTiNPaZmNTPVLbHvJ/iKnz8?=
 =?us-ascii?Q?bSmbyxmxNwWnujCoAUmomqeUahLhWi1WfnTTPxxtlEtRSCrzT0wksS9Qw/iq?=
 =?us-ascii?Q?gZfme3hWEC8OcITQ2gDYbpU6d/HeIptXBjxPJlJOXnsmF35U9wm6S8kwhyqd?=
 =?us-ascii?Q?Btf1qQSeR8Q5CMxTYRc04xhJQbOZpE7EwfB9BektV8Jq1aP4VymiAIkNILN+?=
 =?us-ascii?Q?CiV0xbD8UEKCvUgR6zs/x/ABsvQnVKx21kKrSOL/uvDSkNdTiq41ZFSoOdlY?=
 =?us-ascii?Q?VM0VyRnl2aLlyIt9wg4bDw8sNOUIqOdtXHhpld65FWxuuEjunWH8nsZ/MK9d?=
 =?us-ascii?Q?4/T3a7+l9T6gFHT9R7DfJsrn2Jyve/QwlwldKplLjbPjcjgp+7HnEt7VHtEB?=
 =?us-ascii?Q?04raG5tWJ1+r5fSl5x3Rx1+jlf8Sv4iA7pbxwUlN8Aen9hEVL/EbEgzaBaIt?=
 =?us-ascii?Q?4kQCWZUPnqHcBaaixXgxmNxJL8Wv5GbLi5rOOjFuFt/k3xuUHvuv+jofGNXr?=
 =?us-ascii?Q?Ai6Kb8Ijr9uGEONaztLyJvzcGdEYjj0XFWpNfQFobwehHbockoIUIh8ARBQN?=
X-MS-Exchange-AntiSpam-MessageData-1: newPOCVFme178eJoPdaMhrDnY545JxUkUeg=
X-Exchange-RoutingPolicyChecked:
	chxCAPCVmZfWKnqlaS1WaaxXViUA6s81eMFRURqMG5LgGj7HZwqxTwufAKpOBWu1vD85CLS3QicvaXz/83lChCx1swhe2snUSow/czhB3iY59tPsem8Se8Ead0JpNtQN36X/4zbfI3KGtWb/35YQ45XPOTvmiED9R7c+J7huFGJsnetzWM+h3CH6EcDF+v9lIruhl0Qf5Jfh6oV9zNYnh4hdg6IxqMV1Pcp1VtqwJFVLOcuXr2AfEucJclWrgUF+DQ+j+mPzIE4TeLfVUbShYbFbZ14KuWkO1SXGmDLidUiyoyIGNNi30f/kXegjQBt6uqrgAEbR1HNl252+mLM6sA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sZSEJNWQXyxU92Jgnii8ndrBZ7UhgmQ+PgtbVSO0QmAp4ujP3IJJuBuSD2Sg4QEoMR05Ghkb/WPy5tr2sRKCVPT4nXfLhlw1EpfO7fUGtyA2cuaG0FNHU8UI85sIQbI4WIDVegbDMl9UayBIiYvl7gi+HjXQ94yHM25R0SV6f7wYQZ7zlMxMxQDnhbnvSeQUAq0eD+/kpYhCMTS/28fI9xTzkT6i6W5t5tO809S15KR2OHhM2M0GcECsfVMIxwcZNBWkTWUDJOwB9S/p/SMmcc2onfFYdcHtyKVlTBYH/qoBNPl3C3HFrexhOoQ3DYvvdeeFhIu0fVUjNB2gcrG/ywUFhEg7HYW8hMyv52vU8pVoeG3sE935/+8NG+zNeTZPqy52wOzcj32kG0PaMYYdVmLAVybGtlTKlSq+SasTAb74Jhz2j+b2AF4BHCHbPi02c2cbNc8dLa1T4h7XNGBhX+TBrEJQw7vc8jDxwkKPZGXKQ5+ptkUgJKGRXNYh6Ra4tdQYVGSs+Wzxgo/++oemSWT/fH62FiX/CFif4vnISFiN6i/yirE84N6p27e1rUOjPDESRqDgTAEf1DeyQq5/kiq/euSA9oatO3B3XPyU4Vs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdafa6a1-3b79-4970-caa6-08df2901da3f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:13:24.6064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SeASMPF/mb/i+n0Q1ATkaRS1XdLmbruUVM5BaMhXytfcBXgopoZKguXxgGJX4WP3o4rV5dyXq5zqb+Zm+UoG3Etsr+52/vLnLOnrc8wTris=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX7aC2G2Ebjo+n
 22Ohe0QSBWf+17N834B/ZlqqLlE8WgB/kzPkqBoG7L3hpCacqGH6xpjGQ1ILSMa9yfv4AZweJFW
 PVga1QCb7m7DQxE2kFbpPX70gBFK+bcpytYSF00VVTM3Jbe9AbvlAZfIkyLeNd8SNEH95AqRRoL
 EEEljk5cjdd/6ua6jk5Cf+ev4VaN2lRsPH5u14fYj+a3F4hOi2pfQaUCl3mFlHb8g33QF/2H+0Q
 J/UvxIg4RfUEtsNowK9ERBS1OqLPh0sL1vBQLJMa4eCbeWXvZmUSC2ABMVirv2upg8lleTutvcC
 My46kEej7fsQ5IECNZJpXXx6ZRMw5ow2rlIWhdIDk9DXNTnr3rvOl3wj6hmlokcIj1URg5LOdRE
 E1w8Is2c6cwBzlZQ+lhactobH/de1HECsCpxKcl6v/wHFDd6K1oJzeerjKKgGucXSstnwKgYAYt
 yJZa47N0z62CjzmQ+37xdoTkkocvht8WdVh8bUro=
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acde82b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
 a=3OcxSVRvUSqaRT7DloUA:9 a=biEYGPWJfzWAr4FL6Ov7:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13537
X-Proofpoint-ORIG-GUID: yKkt739iA0QkTbpMRXlz7g6A08XqPA7z
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX4jy5sCpR/LgD
 NsxYKYuhnt2/Ph6NmMEZb834wAJ9IiskS573yOc7gPAMOYuABGEa5jNfPHTnSyiD0mqBiexHQpb
 RfqJeqhOp48Or45Y7JE5+HcTNhaa0cuocTwgC+8JO/Yp7DCYI2ao
X-Proofpoint-GUID: yKkt739iA0QkTbpMRXlz7g6A08XqPA7z
Message-ID: <20261013081315.-OIvJFq_AJDCPs1WZGZQE80QM5jHd-_nKuWG-imDe8Y@z>

Backport of this series:
https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

I have added information in commit message upon conflict resolutions.

v2: Address Sasha's comments to v1 in the below mail:
https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/

xfstests_xfs testing results:
	Generic:
		Ran: 001 to 771 (672 tests; gaps)

		Failures before changes:
			Count: 7
			IDs: 363, 365, 633, 645, 696, 697, 753

		Failures after changes:
			Count: 7
			IDs: 363, 365, 633, 645, 696, 697, 753

		No new success or failure after changes.

	XFS:
		Ran: 001 to 789 (311 tests; gaps)

		Failures before changes:
			Count: 1
			IDs: 300

		Failures after changes:
			Count: 1
			IDs: 300

		No new success or failure after changes.

Thanks,
Siddh

Dave Chinner (5):
  xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
  xfs: catch stale AGF/AGF metadata
  xfs: rearrange code in xfs_buf_item.c
  xfs: factor out stale buffer item completion
  xfs: fix unmount hang with unflushable inodes stuck in the AIL

 fs/xfs/libxfs/xfs_alloc.c  |  46 ++++--
 fs/xfs/libxfs/xfs_ialloc.c |  32 +++-
 fs/xfs/xfs_buf_item.c      | 299 ++++++++++++++++++++++---------------
 fs/xfs/xfs_buf_item.h      |   3 +-
 fs/xfs/xfs_icache.c        |   8 +
 fs/xfs/xfs_inode.c         |   2 +-
 6 files changed, 256 insertions(+), 134 deletions(-)

-- 
2.53.0

