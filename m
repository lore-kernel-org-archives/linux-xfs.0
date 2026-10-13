Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D6B3C0613;
	Tue, 13 Oct 2026 08:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879375; cv=fail; b=ZdH3vOtrPoxp5EsUqMX5FRJoGiO+XISSWriUhkvJI5WwP1Y47+6ErE6FskTGUMsLxGk/VHfoZ7lJjrUOniZpubapkSXeqdgQoRMOfPvLsi64q2rUKKdTMwjfLt0yhwRJ+yozySi+QQ3SOzq5VH3Dj2NyzsusI+WWvQ6vG8yHsBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879375; c=relaxed/simple;
	bh=emW44mA64NMaqCYDzQ5QAos4YIRnffdly9YBdTsf2zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lv1jMSyrNyJYFVsTKbP7AqwgaWXf+UmNggEPcs5hxWleGM09KUf/LAQj8mGxWPrI0eW3mvnESamgHdi5bNLRThhqL6GAuViK8TDqEKmzYloZfwdVkML3Ehd8ASC5jSiNjgvh8e8cVZkIHTGeoUHDPLTND230wx7ntDv3cCaRi5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fw/8q3kW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UYj2HJev; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fw/8q3kW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UYj2HJev"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2D1jg4063533;
	Tue, 13 Oct 2026 08:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CFftGCHDvDnERBZoHEXtjsYPNy8xUirCR0ggbbh47y8=; b=
	fw/8q3kWQYpkqyrgxiwPjgj6SlIhep6q2my+s+MGdvS46Hv8X9S327+Bqxm7r3aN
	br/panilKiL12MgW3WsnhCIG/pT4vTJjtfMqNbQS2KvZEvX5qhrJfd9wjgQnZiem
	EZA2zqPyh7OKh5btVQMT5DYpSXjIn9CHS42eHxGMkCu9Rw3dehveKzGYdLRsv3to
	G7bhVW/v6AKWqTyaMYApXJbuTO/io4RGWHYVcFdNbEIeNa7WkpW58uN1NzYz1wuV
	ePPh89MlGLe5Ao3WwwXxRjmEodK94o1GCf/KJqFDI9KpTrSfE/pLs36n+kOHvzU5
	DBqWEbZIgiUc2SqZM7e2+Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkkv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:16:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86mnX035078;
	Tue, 13 Oct 2026 08:16:06 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012052.outbound.protection.outlook.com [40.93.195.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp7e40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:16:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xK/hL6TgnV/oahfk/g/gbN9zqb4WATOyaW4jZsvYGFo4AZEAWF/+YYOPvDGTkj1n0gRPQ90uZ18yx7JgV7WzhmNYystn/TbhC2xIFVLm4GKtcnNmlM0eU96ClbclvDwj7oQfSVZO3Hd8S8yxvUY+q6eouiGa9joUu+pSQtxrZNnX5MUoMl/zEeSkTg2A9+2mUS6gdTXKnyiRUSpwGMmjrQQYCx9m1cWha+K4JN044JO/foFG3OSz7C4n7ghvyWS4dwR5tArnlOpmyzOq0khmumPdpB7vboHoUgcju1ZA56BhpdRxn7x+8FyhWRdwS7ESpy2C6+gUzamHOPZ6gqswKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFftGCHDvDnERBZoHEXtjsYPNy8xUirCR0ggbbh47y8=;
 b=BfTBTwNwRIu77ia9DyX3SiDPSB8Tg3xs/j3ojmhYAW+ZN89PKAZArudC7o1du7VCxYJeHR1ZINPxT4DR5LYvt1bh5OMl/4iJvQCSnoeBwWkcU19DFMhv0bmU0nC7hOCqHpDKd8b3yZFLNTXDNxeykPMdgi2UU5OIyHEwpz0JRNzG5Gyz8Hq/PgUrZfa2Al2RAmp1+2Hsq4DWcJqiT08hUpmc4rP7d1d6Tb1apLtHDhim4EtHCbrE6TTMIb8qBefqUI6QCfDFtv+NmjrnhrBZ+qdqQEHyKrtiw8SKX8GGnAqysYd89wkGvM9I4WHVcaJmgcCrCSXgqg/Jt4EgLgy4IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFftGCHDvDnERBZoHEXtjsYPNy8xUirCR0ggbbh47y8=;
 b=UYj2HJevAV+RTSmSA+e3LFZ2SA/0Z14dkZSc4xIelz7437RrXSsVuYsaLrWh0/CA9Y9NCNJP29DeBbhq13b9sNGqpoShhzQommqgiUHdGMz09ERkUOniLJQqsEQQuUPT1nX/8m2hiSHAABXXtr+GsN2hWsiO+HjudIPNjPjxrt8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:16:00 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:16:00 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 11/19] xfs: remove xfs_buf_t typedef
Date: Tue, 13 Oct 2026 13:44:55 +0530
Message-ID: <0ce792de233a915ba9154d8b67ea9c29ac55da62.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0052.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::21)
 To DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bd848bb-9ba9-4e9b-1aaa-08df29023749
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|260925021311599003|260925022911599003|260925021911599003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	4/XKASSrc4CB4HHRZCeVvXhyBlqDV1KRwYxknGd7J0m3sO5jis9QiGlkGSiZIJeGTumyQ0e2V927/aWmFMPdai3rU4RyQKYBTWkbMoaVwEdiuy3wca00rmm+dgu1PXC9UDPQx5VLgTKaIX71JJHsM2V1VaNDoq8mjeSXFZO3FIdj+ocUabSM0QbCcsAMI8Yp/QmEBzjl4kkAEdbX5js+lAckUHuvQMqGiE0PuHyvpCz5KtuTr2gCrTLbar7lhILPyM+NM2zyy+62jOBJ+k55J3S0SPHW0fcBme3Wd9MOQEzKaRKQT9TkyFPCo0n1noMkuSIkGQvB/CD2LvPH4pLkHF/Ax7SKdDBfxuknmwB4aOAo18WsGf13zAizGYnkCwOOvXqCfm4jRKXmuGzueTW78FfECET9gobs817A1NhJcAB7hfuacNzr88iOhN/oiJVBk+jsJInL/A8ePNmorIBxKblZx2KEmIkMGD4d6uE7WEw8q+uMLpBJNRLeM0iUghb3IVS4locoGn1gYvsplBLbCMZhb84gJut9lu3Fgucuvkm9VB9pOSWuwN4tq5l2sLwFwY9N8uFczl/e+TmxnMnBwp67z2AXLkbJrrxtQPM2RLO49Ez09UkY/R07iYKnhQ9smg440L613qrWlCHfcxsnAMvZzRNax4r5eB3Noa+uK2M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(260925021311599003)(260925022911599003)(260925021911599003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MXZm4urHfuYgIGYLbxOKvTIRXMNwZTk2u0C3eeDCWncjSxIoqVYDa3SitgRl?=
 =?us-ascii?Q?jKMtcayblEBKOrHm0A94jUnNS2U7JuarXiy+Xs3HvU/NIhvGNnJt4dMJB6sc?=
 =?us-ascii?Q?hH/xvWmAciA9czWgIHY2jSH2/tDbRRhMQR0PdBs2BZV6ommDubKwLMDAfA5f?=
 =?us-ascii?Q?/QL7EjYIVtA9KcjD4EiwWOMH9Ry95+bWo/ZwucGXSpqwGPKDvHoKAttaJU91?=
 =?us-ascii?Q?lJ267t/CVNQ7BrlCX3ew9U/zHXJjCWo0ZhzrvxD1VuQPNUn5IADPpF2dkxq2?=
 =?us-ascii?Q?fgaC7VhpLyj2QFkuiP7W91gn/CqWWqaGfmOo5GxtD0HrkW/dAIDQXSrpT/xd?=
 =?us-ascii?Q?pyRBerrDcS6YP7F0R0tmFb+rK+J+4YOJTqTX61vOgaHbbO5axOD823OQf33W?=
 =?us-ascii?Q?BufIt0hiomGYSj5IYr7MAzNr60YzpNqg5JyzLGDpacvrEbc68vpUMmxSTj0w?=
 =?us-ascii?Q?19/LqL0pjCuNeCwQIh0LtUe44US3kBFAGEBfIdzgSpx5K3WDvEgcsQiXQzVd?=
 =?us-ascii?Q?pvZQAb4LEcznM1Xzj0xoDMhglARTr5rbVkF6Gq2TTEK1A0crhDNnJjhYQQPi?=
 =?us-ascii?Q?cKLtC+XzJiLcTynioYGmypBwDfhRmq4lENQd/PvpMfQ9hg6IkO/kVNTQGnvC?=
 =?us-ascii?Q?BRsPVgZtlm/8ZleR7cdr/4mAdMbSshRRsd2pB5XdsTnsrLYAxnipqv1GAhCv?=
 =?us-ascii?Q?LW871N9JwyN852ruNwDD7iQL+h7B2qJnHR4BLFv1GzfmieeFMw0naB0eNkEI?=
 =?us-ascii?Q?38xroDZbW7OgxkFg/iqIzRhWqL3ZavbN17i1YtKt7EGKxA0PN2tqUckeGzAp?=
 =?us-ascii?Q?Okn92ygOKPvT8w/fL+lPKRnpBbf0w+vPDXlI894zMQuLju+fi/3IdY8fVN3A?=
 =?us-ascii?Q?WR6OrNQ94rDaHl3Zt0ic/NPIY3/3HfGMW3nSWoRRuNoQKO9Dp0tV4lqhVYAX?=
 =?us-ascii?Q?tmcCP8uyjeJJHldOEgCHkR8gT46Iw5XXhPhtW9yokezRkn6Y21h8ir6Tg0jc?=
 =?us-ascii?Q?RhKa7L+BM6hTkXtfCZpCYcmzouVCWhgaXPo3BqaC/5LooE0Z25louQgnzPgZ?=
 =?us-ascii?Q?IXeUY2G+Pj/S8rCubi8iFs1C5oRKHwPw6bqAkceOKLhILooJ8yr5BepJfsBE?=
 =?us-ascii?Q?LfRkOUf1bZ5Jp8lDCBMq9AAhWOCXgGUCknMMCGsB+k5rpZmsLx314wqibPKZ?=
 =?us-ascii?Q?ro1KuxNP5DuqNb/KG2lpGYkCaVuqqGJrYtWKs4g66aKhuQJXySfZvr0WqbkU?=
 =?us-ascii?Q?WTKA1oSzXkgJHpvxySg3P4dMV182Fi+Bcwlrb6IJOkTDkBKYpBkUtqaKfimy?=
 =?us-ascii?Q?ecEhrqZAOKTaZlUi3v5oERx0i8vNTmcUbGDRZ03VQInRn/sE7T8uDCSoCpeG?=
 =?us-ascii?Q?qAx5cRiXdIiHhQcn1SQeoUpthlygjSNQIMeqR9Ej2eKz/f4ujcQCG+4cNWTN?=
 =?us-ascii?Q?/Hb5657Dmy1FmQqs9zH7Cim+tTqcz+fz2l3GD4lNeYvU+EgZ2WHW+dVyIrNJ?=
 =?us-ascii?Q?C2cam7izpiTBCiGTarXm/OkqyzUMBZ63XipvpmV1d8GyWrQLnnEOvOPF3N0u?=
 =?us-ascii?Q?B9tyRz8W9svoFu3zT8+hhUE1f2R1C9tMnnU85hkgbsfdbbcJ9ODzIhil1S/M?=
 =?us-ascii?Q?+E6QINexF1bnOMbhXAy2YyJWGe2zIJzAsvNk7KispscLjkft7isdLXV6erSD?=
 =?us-ascii?Q?Q6ZOY5Xb+ZH5OB29QOOeHvOpj3Fr03BF5R++WeTTBNnVjFDl+MqwsEoWrXCn?=
 =?us-ascii?Q?ryrb24W11V2Mn63IZO/VFVzzINpoOo/LXtLsrLp7iRlvUHWq/Ph+A41F+RlT?=
X-MS-Exchange-AntiSpam-MessageData-1: Lf1tUOrsBp5x+8cAKq70C/8sR2Kmy0m9UM8=
X-Exchange-RoutingPolicyChecked:
	fva987s8wluIp+1lyFNe2SkDyoUtoEBYjNToGr5/DrA1LB+m/3Y84LDb9NC+DjEspZOIYMxlo9ziJuTmNn4GJqDyCmvW7SX1Qzkp30Uql+HKmoRfXG1m/sYdX/V5Iv6Wnp8yYRt/uWDcQepNPFEJB1fA0PlH+4sBWNEaZyNHb7CYDuW/dH/tqisnuxOz40/Gq2fu3rHCamKLpDB9iQqpw9Iy+teENa6RiilWBm8ekfpqlDozRUW+65M16LbCg223+ZkJXJp0tmuau0t/TANhSt0WJkeKC9nlY701lXgEqHg6Aj/XHx+2eo1qSdcdK3yXjcwNCSAT8HMK9O7jkEwwCQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MRi9A1P0U33E0bGNPDOYLr9FKhkRRg01ZfziXoY7zPX0hGON1316sKzgnza25+jqTANbNZo2nhjG6kr+KIF9KpPEhzTeeuXtpRAOn6E8pieqXX6rmO0zx4y9C4wpcwb8ViW7JVjBwaNByOxIKwS0Y8+wcp1PoRugMrib9iMIhCXZkLUnI2gfpLl/LiRi9jjrlsO6KCtQhY4SeiuZuHOoEA8lNdkMBPaldbWe6foR5kuLy7XVJRNElCbboyrQ3ScqoRnosV8ZvRKmCdsWGvZO3GC/bfKjZt7XCg+phrw/V1Fu67bO+Zl4iEc6j3Jdya7npQ5Ilc3K7aeizAUByec6fGAP98VB6JOQPOgeNovljYVk2r3OrOcyOJV4V7f4erjbfPu9+LQPumFPHa+X00EGtys3POmUqdg1CFiMCn8opBratDn1HfE6CV92+zFyXoX84hCoVTJ379m5Fgkwsl3YVy/Y7Muv7xk9z/MDQYjgdkx6phBd2Tq+7mTxCH9pfoXCwzUuCWQkPxm7B+tZXIeP3vpSPCt4xl02tbRF/fzpSyIMZRWd8pvX5AZo+V05gkAROpgzKXfZPAFrdd1BHL5qBust8RKI+gJ+bdI/G7cEiKk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bd848bb-9ba9-4e9b-1aaa-08df29023749
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:16:00.7364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qQ7A2YuI7csNEthHSExDIfszc7glXqrHzzD/UfFKqrgWHzXmc8bOiHT+lzRyjiJO+jQiRVbfNTjRtlsNrbSGn99EPQe2vwV9EE+O2FVKgQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acde8c8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=rWiefVkh0gDNh2EwC_cA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-GUID: PTdk0pjyUw9f4gf2t0Owq5sQQekcvSWt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX6Rdyh4rJDo6u
 dcNxOb/wkaLnkklGRcM/zE3LjnVlNGakuQYH1SpU9QzRmYJyX4b5+b4oVHxaa1IYPDT7lGjgjxE
 Epzd/SRniytRchtz/AKUjB1fix5t6Km4i5DdPnfn2FCheIRz5jq9J2+njLb5QsJwA1yjfwqNuhJ
 PYOFXiJeIEmsaf4CHZTFfMvRCR/KDkipn9b4a39n9z4yoq2ywPDR92GKlrQfROU8hT9LnSMK4UD
 sWITPKM4T+fBtUGevocYsFgANgZos1UkbrxwhNLv32XG0971qg/bk8ktTcxNvATyBBkb1Lf4b4c
 HlJ+y9Y+O292iNhn5qjcv9RkCJXKpqGK7fT6htXKlIvRMfy64VIfM+4CXGRuir9gXnCZHTTHbIZ
 4ghd4iEktu+crsJwl+iYjcoKs/hMwpSO7FE/bWvFGaxDfDzWLHfuFoHlRle8NMrxtqSVRd3zC9Z
 yBss26t0CXGb0Kkc38TUMOU49ATScfDMNVSFD/KM=
X-Proofpoint-ORIG-GUID: PTdk0pjyUw9f4gf2t0Owq5sQQekcvSWt
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX9QLc8P97eyN7
 NGAmGfyogiBO3nTM6z5220TxqwmEoI3eVuds5R431muKp/si+S0avAPvl5TSpvIl6wGWbtaquds
 EpHXPeEDaQaEOOXOCabvqn5FOPX0NTC/3QLs7jPDHlx1zigFMFlr

From: Dave Chinner <dchinner@redhat.com>

Prepare for kernel xfs_buf  alignment by getting rid of the
xfs_buf_t typedef from userspace.

[darrick: This patch is a port of a userspace patch removing the
xfs_buf_t typedef in preparation to make the userspace xfs_buf code
behave more like its kernel counterpart.]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
(cherry picked from commit e82226138b20d4f638426413e83c6b5db532c6a2)
Stable-dep-of: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")

5.10:

2 extra conversions in fs/xfs/xfs_inode.c due to missing:
	1abcf261016e ("xfs: move on-disk inode allocation out of xfs_ialloc()")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c    | 16 ++++++++--------
 fs/xfs/libxfs/xfs_bmap.c     |  6 +++---
 fs/xfs/libxfs/xfs_btree.c    | 10 +++++-----
 fs/xfs/libxfs/xfs_ialloc.c   |  4 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c | 22 +++++++++++-----------
 fs/xfs/xfs_buf.c             | 24 ++++++++++++------------
 fs/xfs/xfs_buf.h             | 14 +++++++-------
 fs/xfs/xfs_buf_item.c        |  4 ++--
 fs/xfs/xfs_fsops.c           |  2 +-
 fs/xfs/xfs_inode.c           |  4 ++--
 fs/xfs/xfs_log_recover.c     |  8 ++++----
 fs/xfs/xfs_rtalloc.c         | 20 ++++++++++----------
 fs/xfs/xfs_rtalloc.h         |  4 ++--
 fs/xfs/xfs_symlink.c         |  4 ++--
 fs/xfs/xfs_trans.c           |  2 +-
 fs/xfs/xfs_trans_buf.c       | 16 ++++++++--------
 16 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 15640015be9d..7cb9f064ac64 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -690,9 +690,9 @@ xfs_alloc_read_agfl(
 	xfs_mount_t	*mp,		/* mount point structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_buf_t	**bpp)		/* buffer for the ag free block array */
+	struct xfs_buf	**bpp)		/* buffer for the ag free block array */
 {
-	xfs_buf_t	*bp;		/* return value */
+	struct xfs_buf	*bp;		/* return value */
 	int		error;
 
 	ASSERT(agno != NULLAGNUMBER);
@@ -2647,12 +2647,12 @@ xfs_alloc_fix_freelist(
 int				/* error */
 xfs_alloc_get_freelist(
 	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*agbp,	/* buffer containing the agf structure */
+	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
 	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
 	int		btreeblk) /* destination is a AGF btree */
 {
 	struct xfs_agf	*agf = agbp->b_addr;
-	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
+	struct xfs_buf	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
 	__be32		*agfl_bno;
 	int		error;
@@ -2711,7 +2711,7 @@ xfs_alloc_get_freelist(
 void
 xfs_alloc_log_agf(
 	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*bp,	/* buffer for a.g. freelist header */
+	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
 	int		fields)	/* mask of fields to be logged (XFS_AGF_...) */
 {
 	int	first;		/* first byte offset */
@@ -2757,7 +2757,7 @@ xfs_alloc_pagf_init(
 	xfs_agnumber_t		agno,	/* allocation group number */
 	int			flags)	/* XFS_ALLOC_FLAGS_... */
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;
 
 	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
@@ -2772,8 +2772,8 @@ xfs_alloc_pagf_init(
 int					/* error */
 xfs_alloc_put_freelist(
 	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_buf_t		*agbp,	/* buffer for a.g. freelist header */
-	xfs_buf_t		*agflbp,/* buffer for a.g. free block array */
+	struct xfs_buf		*agbp,	/* buffer for a.g. freelist header */
+	struct xfs_buf		*agflbp,/* buffer for a.g. free block array */
 	xfs_agblock_t		bno,	/* block being freed */
 	int			btreeblk) /* block came from a AGF btree */
 {
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index de9c27ef68d8..5483572512ed 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -321,7 +321,7 @@ xfs_bmap_check_leaf_extents(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
-	xfs_buf_t		*bp;	/* buffer for "block" */
+	struct xfs_buf		*bp;	/* buffer for "block" */
 	int			error;	/* error return value */
 	xfs_extnum_t		i=0, j;	/* index into the extents list */
 	int			level;	/* btree level, for checking */
@@ -592,7 +592,7 @@ xfs_bmap_btree_to_extents(
 	struct xfs_btree_block	*rblock = ifp->if_broot;
 	struct xfs_btree_block	*cblock;/* child btree block */
 	xfs_fsblock_t		cbno;	/* child block number */
-	xfs_buf_t		*cbp;	/* child block's buffer */
+	struct xfs_buf		*cbp;	/* child block's buffer */
 	int			error;	/* error return value */
 	__be64			*pp;	/* ptr to block address */
 	struct xfs_owner_info	oinfo;
@@ -830,7 +830,7 @@ xfs_bmap_local_to_extents(
 	int		flags;		/* logging flags returned */
 	struct xfs_ifork *ifp;		/* inode fork pointer */
 	xfs_alloc_arg_t	args;		/* allocation arguments */
-	xfs_buf_t	*bp;		/* buffer for extent block */
+	struct xfs_buf	*bp;		/* buffer for extent block */
 	struct xfs_bmbt_irec rec;
 	struct xfs_iext_cursor icur;
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 0926363179a7..aaa59daa77d0 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -394,7 +394,7 @@ xfs_btree_dup_cursor(
 	xfs_btree_cur_t	*cur,		/* input cursor */
 	xfs_btree_cur_t	**ncur)		/* output cursor */
 {
-	xfs_buf_t	*bp;		/* btree block's buffer pointer */
+	struct xfs_buf	*bp;		/* btree block's buffer pointer */
 	int		error;		/* error return value */
 	int		i;		/* level number of btree block */
 	xfs_mount_t	*mp;		/* mount structure for filesystem */
@@ -698,7 +698,7 @@ xfs_btree_firstrec(
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
 
 	/*
 	 * Get the block pointer for this level.
@@ -728,7 +728,7 @@ xfs_btree_lastrec(
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
 
 	/*
 	 * Get the block pointer for this level.
@@ -990,7 +990,7 @@ STATIC void
 xfs_btree_setbuf(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			lev,	/* level in btree */
-	xfs_buf_t		*bp)	/* new buffer to set */
+	struct xfs_buf		*bp)	/* new buffer to set */
 {
 	struct xfs_btree_block	*b;	/* btree block */
 
@@ -1633,7 +1633,7 @@ xfs_btree_decrement(
 	int			*stat)		/* success/failure */
 {
 	struct xfs_btree_block	*block;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;		/* error return value */
 	int			lev;
 	union xfs_btree_ptr	ptr;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7e8ba9698aba..8fcb5c6810e9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2454,7 +2454,7 @@ xfs_imap(
 void
 xfs_ialloc_log_agi(
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_buf_t	*bp,		/* allocation group header buffer */
+	struct xfs_buf	*bp,		/* allocation group header buffer */
 	int		fields)		/* bitmask of fields to log */
 {
 	int			first;		/* first byte number */
@@ -2675,7 +2675,7 @@ xfs_ialloc_pagi_init(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_agnumber_t	agno)		/* allocation group number */
 {
-	xfs_buf_t	*bp = NULL;
+	struct xfs_buf	*bp = NULL;
 	int		error;
 
 	error = xfs_ialloc_read_agi(mp, tp, agno, &bp);
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 6c1aba16113c..fe3a49575ff3 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -56,9 +56,9 @@ xfs_rtbuf_get(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	block,		/* block number in bitmap or summary */
 	int		issum,		/* is summary not bitmap */
-	xfs_buf_t	**bpp)		/* output: buffer for the block */
+	struct xfs_buf	**bpp)		/* output: buffer for the block */
 {
-	xfs_buf_t	*bp;		/* block buffer, result */
+	struct xfs_buf	*bp;		/* block buffer, result */
 	xfs_inode_t	*ip;		/* bitmap or summary inode */
 	xfs_bmbt_irec_t	map;
 	int		nmap = 1;
@@ -101,7 +101,7 @@ xfs_rtfind_back(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	firstbit;	/* first useful bit in the word */
@@ -276,7 +276,7 @@ xfs_rtfind_forw(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	i;		/* current bit number rel. to start */
@@ -447,11 +447,11 @@ xfs_rtmodify_summary_int(
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
-	xfs_buf_t	*bp;		/* buffer for the summary block */
+	struct xfs_buf	*bp;		/* buffer for the summary block */
 	int		error;		/* error value */
 	xfs_fsblock_t	sb;		/* summary fsblock */
 	int		so;		/* index into the summary file */
@@ -517,7 +517,7 @@ xfs_rtmodify_summary(
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
@@ -539,7 +539,7 @@ xfs_rtmodify_range(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtword_t	*first;		/* first used word in the buffer */
@@ -690,7 +690,7 @@ xfs_rtfree_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to free */
 	xfs_extlen_t	len,		/* length to free */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the freed extent */
@@ -773,7 +773,7 @@ xfs_rtcheck_range(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	i;		/* current bit number rel. to start */
@@ -969,7 +969,7 @@ xfs_rtfree_extent(
 	int		error;		/* error value */
 	xfs_mount_t	*mp;		/* file system mount structure */
 	xfs_fsblock_t	sb;		/* summary file block number */
-	xfs_buf_t	*sumbp = NULL;	/* summary file block buffer */
+	struct xfs_buf	*sumbp = NULL;	/* summary file block buffer */
 
 	mp = tp->t_mountp;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 118819030dbb..78f6f5bce3e0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -278,7 +278,7 @@ _xfs_buf_alloc(
  */
 STATIC int
 _xfs_buf_get_pages(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	int			page_count)
 {
 	/* Make sure that we have a page list */
@@ -302,7 +302,7 @@ _xfs_buf_get_pages(
  */
 STATIC void
 _xfs_buf_free_pages(
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	if (bp->b_pages != bp->b_page_array) {
 		kmem_free(bp->b_pages);
@@ -319,7 +319,7 @@ _xfs_buf_free_pages(
  */
 static void
 xfs_buf_free(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	trace_xfs_buf_free(bp, _RET_IP_);
 
@@ -352,7 +352,7 @@ xfs_buf_free(
  */
 STATIC int
 xfs_buf_allocate_memory(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	uint			flags)
 {
 	size_t			size;
@@ -463,7 +463,7 @@ xfs_buf_allocate_memory(
  */
 STATIC int
 _xfs_buf_map_pages(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	uint			flags)
 {
 	ASSERT(bp->b_flags & _XBF_PAGES);
@@ -590,7 +590,7 @@ xfs_buf_find(
 	struct xfs_buf		**found_bp)
 {
 	struct xfs_perag	*pag;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
 	xfs_daddr_t		eofs;
 	int			i;
@@ -762,7 +762,7 @@ xfs_buf_get_map(
 
 int
 _xfs_buf_read(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	xfs_buf_flags_t		flags)
 {
 	ASSERT(!(flags & XBF_WRITE));
@@ -1005,7 +1005,7 @@ xfs_buf_get_uncached(
  */
 void
 xfs_buf_hold(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	trace_xfs_buf_hold(bp, _RET_IP_);
 	atomic_inc(&bp->b_hold);
@@ -1017,7 +1017,7 @@ xfs_buf_hold(
  */
 void
 xfs_buf_rele(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_perag	*pag = bp->b_pag;
 	bool			release;
@@ -1161,7 +1161,7 @@ xfs_buf_unlock(
 
 STATIC void
 xfs_buf_wait_unpin(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	DECLARE_WAITQUEUE	(wait, current);
 
@@ -1373,7 +1373,7 @@ xfs_buf_ioend_work(
 	struct work_struct	*work)
 {
 	struct xfs_buf		*bp =
-		container_of(work, xfs_buf_t, b_ioend_work);
+		container_of(work, struct xfs_buf, b_ioend_work);
 
 	xfs_buf_ioend(bp);
 }
@@ -1388,7 +1388,7 @@ xfs_buf_ioend_async(
 
 void
 __xfs_buf_ioerror(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	int			error,
 	xfs_failaddr_t		failaddr)
 {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index bfd2907e7bc4..5d91a31298a4 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -124,7 +124,7 @@ struct xfs_buf_ops {
 	xfs_failaddr_t (*verify_struct)(struct xfs_buf *bp);
 };
 
-typedef struct xfs_buf {
+struct xfs_buf {
 	/*
 	 * first cacheline holds all the fields needed for an uncontended cache
 	 * hit to be fully processed. The semaphore straddles the cacheline
@@ -190,7 +190,7 @@ typedef struct xfs_buf {
 	int			b_last_error;
 
 	const struct xfs_buf_ops	*b_ops;
-} xfs_buf_t;
+};
 
 /* Finding and Reading Buffers */
 struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
@@ -253,16 +253,16 @@ int _xfs_buf_read(struct xfs_buf *bp, xfs_buf_flags_t flags);
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
-extern void xfs_buf_rele(xfs_buf_t *);
+extern void xfs_buf_rele(struct xfs_buf *);
 
 /* Locking and Unlocking Buffers */
-extern int xfs_buf_trylock(xfs_buf_t *);
-extern void xfs_buf_lock(xfs_buf_t *);
-extern void xfs_buf_unlock(xfs_buf_t *);
+extern int xfs_buf_trylock(struct xfs_buf *);
+extern void xfs_buf_lock(struct xfs_buf *);
+extern void xfs_buf_unlock(struct xfs_buf *);
 #define xfs_buf_islocked(bp) \
 	((bp)->b_sema.count <= 0)
 
-static inline void xfs_buf_relse(xfs_buf_t *bp)
+static inline void xfs_buf_relse(struct xfs_buf *bp)
 {
 	xfs_buf_unlock(bp);
 	xfs_buf_rele(bp);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 132acdf0aac0..7794bd956861 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -403,7 +403,7 @@ xfs_buf_item_unpin(
 	int			remove)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
-	xfs_buf_t		*bp = bip->bli_buf;
+	struct xfs_buf		*bp = bip->bli_buf;
 	int			stale = bip->bli_flags & XFS_BLI_STALE;
 	int			freed;
 
@@ -931,7 +931,7 @@ xfs_buf_item_free(
  */
 void
 xfs_buf_item_relse(
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 775f833146e3..cb3d54893fbe 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -28,7 +28,7 @@ xfs_growfs_data_private(
 	xfs_mount_t		*mp,		/* mount point for filesystem */
 	xfs_growfs_data_t	*in)		/* growfs data input struct */
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2de204f46216..5c04c61964ce 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -799,7 +799,7 @@ xfs_ialloc(
 	xfs_nlink_t	nlink,
 	dev_t		rdev,
 	prid_t		prid,
-	xfs_buf_t	**ialloc_context,
+	struct xfs_buf	**ialloc_context,
 	xfs_inode_t	**ipp)
 {
 	struct inode	*dir = pip ? VFS_I(pip) : NULL;
@@ -956,7 +956,7 @@ xfs_dir_ialloc(
 {
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
-	xfs_buf_t	*ialloc_context = NULL;
+	struct xfs_buf	*ialloc_context = NULL;
 	int		code;
 	void		*dqinfo;
 	uint		tflags;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 46b1213e8ff3..7cb7a0aa6c9a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2633,7 +2633,7 @@ xlog_recover_clear_agi_bucket(
 {
 	xfs_trans_t	*tp;
 	xfs_agi_t	*agi;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agibp;
 	int		offset;
 	int		error;
 
@@ -2751,7 +2751,7 @@ xlog_recover_process_iunlinks(
 	xfs_mount_t	*mp;
 	xfs_agnumber_t	agno;
 	xfs_agi_t	*agi;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agibp;
 	xfs_agino_t	agino;
 	int		bucket;
 	int		error;
@@ -3502,8 +3502,8 @@ xlog_recover_check_summary(
 	struct xlog	*log)
 {
 	xfs_mount_t	*mp;
-	xfs_buf_t	*agfbp;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agfbp;
+	struct xfs_buf	*agibp;
 	xfs_agnumber_t	agno;
 	uint64_t	freeblks;
 	uint64_t	itotal;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 915bc2950d4a..d9ed4210fc98 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -32,7 +32,7 @@ xfs_rtget_summary(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
@@ -50,7 +50,7 @@ xfs_rtany_summary(
 	int		low,		/* low log2 extent size */
 	int		high,		/* high log2 extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	int		*stat)		/* out: any good extents here? */
 {
@@ -104,7 +104,7 @@ xfs_rtcopy_summary(
 	xfs_trans_t	*tp)		/* transaction pointer */
 {
 	xfs_rtblock_t	bbno;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* summary buffer */
+	struct xfs_buf	*bp;		/* summary buffer */
 	int		error;		/* error return value */
 	int		log;		/* summary level number (log length) */
 	xfs_suminfo_t	sum;		/* summary data */
@@ -144,7 +144,7 @@ xfs_rtallocate_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* start block to allocate */
 	xfs_extlen_t	len,		/* length to allocate */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the allocated extent */
@@ -226,7 +226,7 @@ xfs_rtallocate_extent_block(
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
 	xfs_rtblock_t	*nextp,		/* out: next block to try */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -345,7 +345,7 @@ xfs_rtallocate_extent_exact(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -424,7 +424,7 @@ xfs_rtallocate_extent_near(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -626,7 +626,7 @@ xfs_rtallocate_extent_size(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -900,7 +900,7 @@ xfs_growfs_rt(
 	xfs_growfs_rt_t	*in)		/* growfs rt input struct */
 {
 	xfs_rtblock_t	bmbno;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* temporary buffer */
+	struct xfs_buf	*bp;		/* temporary buffer */
 	int		error;		/* error return value */
 	xfs_mount_t	*nmp;		/* new (fake) mount structure */
 	xfs_rfsblock_t	nrblocks;	/* new number of realtime blocks */
@@ -1154,7 +1154,7 @@ xfs_rtallocate_extent(
 	int		error;		/* error value */
 	xfs_rtblock_t	r;		/* result allocated block */
 	xfs_fsblock_t	sb;		/* summary file block number */
-	xfs_buf_t	*sumbp;		/* summary file block buffer */
+	struct xfs_buf	*sumbp;		/* summary file block buffer */
 
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 93e77b221355..ed885620589c 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -115,10 +115,10 @@ int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		       xfs_rtblock_t start, xfs_extlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
 			     int log, xfs_rtblock_t bbno, int delta,
-			     xfs_buf_t **rbpp, xfs_fsblock_t *rsb,
+			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
 			     xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, xfs_buf_t **rbpp,
+			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
 			 xfs_fsblock_t *rsb);
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_extlen_t len,
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8d3abf06c54f..c835827ae389 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -154,7 +154,7 @@ xfs_symlink(
 	const char		*cur_chunk;
 	int			byte_cnt;
 	int			n;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -366,7 +366,7 @@ STATIC int
 xfs_inactive_symlink_rmt(
 	struct xfs_inode *ip)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		done;
 	int		error;
 	int		i;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 4e1400ea6a99..5cd296a75fbd 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -460,7 +460,7 @@ xfs_trans_apply_sb_deltas(
 	xfs_trans_t	*tp)
 {
 	xfs_dsb_t	*sbp;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		whole = 0;
 
 	bp = xfs_trans_getsb(tp);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 42d63b830cb9..9aced0a00003 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -121,7 +121,7 @@ xfs_trans_get_buf_map(
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_log_item	*bip;
 	int			error;
 
@@ -401,7 +401,7 @@ xfs_trans_brelse(
 void
 xfs_trans_bhold(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -422,7 +422,7 @@ xfs_trans_bhold(
 void
 xfs_trans_bhold_release(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -538,7 +538,7 @@ xfs_trans_log_buf(
 void
 xfs_trans_binval(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	int			i;
@@ -593,7 +593,7 @@ xfs_trans_binval(
 void
 xfs_trans_inode_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -618,7 +618,7 @@ xfs_trans_inode_buf(
 void
 xfs_trans_stale_inode_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -643,7 +643,7 @@ xfs_trans_stale_inode_buf(
 void
 xfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -737,7 +737,7 @@ xfs_trans_buf_copy_type(
 void
 xfs_trans_dquot_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	uint			type)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
-- 
2.53.0

