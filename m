Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2641E15749C;
	Wed, 18 Dec 2024 19:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549474; cv=fail; b=ouDZUNNHcVuHOZEPFs4X79EbINCBPTBY1Sew+oklwhC/akqpg2GEJFE1f384O5NkLtajQpApO8KRd37KGNWaeDOPL7efoOVVyFmpAog8Vufu/QYZOgYrj6n+VFykuGqDRCLy33P1pPKVrNqUK4XmQUVSrOuknNmwD6l8nMeZiYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549474; c=relaxed/simple;
	bh=xKi9EZDiY5rNk6BwV0uT5e+uX1J/F58aYIL20AV36dA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L54uZjaDde6BiNmCWexELxq9kI13gjf04vMjCNDVHYYgJGDgrx8uh1OI0NdJQY7je11/u00mwPibygWRUp7+tD7gWLUzURFBp0iG7k4EJNP2CX42Thojnp00971NIpwUqflb/6c6xUbwDAO9Mm5sMG2/yZRK5FPxRiypKBBCt+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GtWyyHls; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J1zJD/bK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GtWyyHls";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J1zJD/bK"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQc0N029546;
	Wed, 18 Dec 2024 19:17:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=RHqdy2+NcoKuM3ni/P7CAysszxfZSmvt9EYE/btj2cM=; b=
	GtWyyHlsCde4Y1sDQBfkjf3B+vGvi3bm6nbCIlOGIRYFwc/B2bMosGBuXT1jZySQ
	XI2smVseddqrLGwwNYXUhITsknet4EAmdJvIbMp6BvXUhROWa9HZbZD3q0U38tay
	hpQiaW1dpTOUeQcnb8hITp1v8FDL2+urSf+T5lznkVLf7OamyK+Od0lMDObDqNLq
	FatyTvOAeva68UhY+Qi8qimlHUqavwtbBmHO1sTWARMyd5QM6OgI8r/UAXXryB+6
	CEv9sEZ268NMDSJ883fXenWBqqOf79pfwGdiOXDeLdEekEBZLCttNj4l+tWFB1Lu
	vCkrh61rP7Si87YPIFOoVg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0t2hcre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIILuG2006563;
	Wed, 18 Dec 2024 19:17:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fb4ma7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xbGTha2UO6SEfhsKQwma4Uu/ebYJ+ogbWm6AqtPBf4m7AyYtacCPyJpYdfhLgUk1kvwXtSKL3y495K3VStgZFqfxG38maVHmmNpaBH3i33VV8l6n94ZoLH+zxi9yeXVIRZa5ZZ7N2AKT/J3F2yys0Oo4bY+VypeQMeTeruSC6HlCyxRCfiG8baKU3HVF1w2FQql8WePvZmI/22xHPHZnXjU7v++lYPzLKnsIanfo7hBM70Rhbn5YMn9MJcrLkiz7PiSiftd+jKRRMfHsnFfHM4aNECPZVDToukJmCiGdoIGaF8+ix5uR6G8XVRwKA3K/3D87sO9BX/z+Wd97ZOdTTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHqdy2+NcoKuM3ni/P7CAysszxfZSmvt9EYE/btj2cM=;
 b=wuq/ypLzAQZnjMXfWgd/0+6IFWCXEdUrnAFUumWlH5TW9Nqd2S53KoUu1VDGWxbbpJP+Hjj1WtMztpHRuXXeOlfBRHwJ/Qbqm4Ncknr+sQQKcvmNn5v4qfpTQJE2mdcYFcnx1jIj8dG7lmOSSWZtaI4tUzozxF9jSajazDtVO0YqJ0wBoI+vxHvTkaLvS5FQjFXtAeEcsflIthS3OE85/KcjQG13fehFkmhh42ruaEWd1vtkt6nToGkDsikp3qmsmyzsE9I2OPxSTVou6IpVyLwVe/jRE944LVkLEMeA8fZyBPCKevAqYApXY71jc/zlLD+sUUniHBBbbgMRooEVkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHqdy2+NcoKuM3ni/P7CAysszxfZSmvt9EYE/btj2cM=;
 b=J1zJD/bKAUj/JOVu82RBGGRNjYRwypDdozKLx0j6GzdUWo5YeEfA8LYlXCiomMuq05+t91MpaDJeSvjE9QMm928+Bu9A0IK0Ni4hfmYnUI0yw93w+kh1ADC7RdVKJAgRrHSSwmwVCq/eip8B0WUKlclU1to8EF2+z3JhgQgQdvs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:48 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:48 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 12/17] xfs: attr forks require attr, not attr2
Date: Wed, 18 Dec 2024 11:17:20 -0800
Message-Id: <20241218191725.63098-13-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::30) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: cbf235d6-41a4-464c-8e42-08dd1f98a8e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oOltLw33xDPH8rzttr56lRm45CRzRwuUTsHzzLFJSW6M+9V+/gNuj3vL3soq?=
 =?us-ascii?Q?C1N06MPU3tXP3aPEDLo594zfmO21OYLKwy57cf2ShgDdmm2vj6q8dHamcqf9?=
 =?us-ascii?Q?nvTE3JNp6re3ru79DLGd1lXTx96+ftH+17yI3lmr2ErpJajo7VnOTvaJzu4k?=
 =?us-ascii?Q?K9jUpxoGKNHRvdZ1hWY35Ef2lWpf0ra1IA2tsoCa7gEpoD6yWGoGSlqD61GH?=
 =?us-ascii?Q?gc2bOrpSPFvOzmIqqzMS+shovOLcOKtHc30239wqKoVMz4rb/heWEgSEYZU4?=
 =?us-ascii?Q?QYbqQZljNJ2tVKgC8RUhTMI/pOwSooJBv6ySOpn4RX+005kdbRNezUQRLbFm?=
 =?us-ascii?Q?67U+pPud6hMBF2pkoNOmhaqEbwUXDQBY9GNZrHK6RS6e6Bmds3kXUfUBL9Vh?=
 =?us-ascii?Q?cNjc50hINcm7W4uZpeK9D6yI/QmfTcoCnSahQhNXOy1vCKYTFrtB2d09+PGy?=
 =?us-ascii?Q?AfZZ2jNi2fGM8D/1i8aIcpUITADPxlRkubAMgFcBGHUAq6cdz+ZlFNPe5UBF?=
 =?us-ascii?Q?QcZtBjNmnRPIdF1RBwjkNjkjOMFRsAuYdv+rcADBmgFKHspHXe96E0STaz0r?=
 =?us-ascii?Q?g7L2Veh2XOK1Si0Tcem/tzGUWklg68HVOM+3ddSK5rXfPIgezgGli4C2LkjH?=
 =?us-ascii?Q?dBJWskVg/uPsy1dGLomQO/JDyEX954lwzSIRrUq+MXlnkXpWY/q1aNFxG9Z9?=
 =?us-ascii?Q?XFRMK8MR6JUHqRBIputoQeOYWyoFsn6tDfVT7yMoamoumSZTRme7FUJE5lNN?=
 =?us-ascii?Q?W1cXRUP0F5mFkTY5iiSEEB46zJ21fsVOr6RN2cCbGASXph/A5SPCFRY1MSYy?=
 =?us-ascii?Q?Umh06gkq0Tccb0CGCSvmcZ/3lI27Y5bh1Uis4iqot1dDesHMsJeyqAfpxwDT?=
 =?us-ascii?Q?uMPupi3YabuGbxWSPFBG7FgJcmQTzRXql0zQnYBvLZVGkGY+n1WkEA6ERw5h?=
 =?us-ascii?Q?9i0wSLjEEwGQtr9t+uBa5FEhOrhBw/x/5ZWeysRx2AqmARd/mobmk/o7XSO0?=
 =?us-ascii?Q?B2SOsdGRd5eKmfg3xUOoMfwBFxS5mQeb0KT2uDpFacgKI/ZK9i9JabjBf3hz?=
 =?us-ascii?Q?GUXLLh8rtz2xZCqrEwNtdK13qIHH5dJYKLKCBlv7N/SU9hj/hW1i545qvA58?=
 =?us-ascii?Q?42w732wBmSJy152fckwbvQm+RpgDFaCUtAw46Qk0zRIi0mqr/T+biBp6+8VN?=
 =?us-ascii?Q?jjK4FP/3/EHIJXroNIDlChZ/qYz1Y3J0+Dho8FiFUpAKPwZKTsObogr959IQ?=
 =?us-ascii?Q?kPjc80ap82i8cUC6S9sigcwsQbh2Hyfm6r5UG2m7CehALwB2XNpsIz8Epj85?=
 =?us-ascii?Q?TIQ21lPlmgMuBsVqCwMTckXm9MZ5wFvGIFElbBr+6b/l6etmCgiw8OH5quhx?=
 =?us-ascii?Q?QX4tj/6NhVk3nbJri+zw11DLRIz9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ma93wejw4jIvq3K5BkAR4DZqEicSgXqtflHLWuyn7x70Yfft6Vkt2k2FV12E?=
 =?us-ascii?Q?A0xnS3YCN8msoVLqGB8THLa/5tlYKe1XJCHKJeDmU5HzoPWizDm4RBOCyK2R?=
 =?us-ascii?Q?h2mDheI5TFKX5mBY3oFz7cuRUC38Nkr+qCMBaY1XIe9TRsLFp2A9wfR3o2Gx?=
 =?us-ascii?Q?sw2RXVbnS49ws3CS6unfRMEUt/HLtIuUCNgX9ZnFJnM8FSBsYLnIjyy7uWhQ?=
 =?us-ascii?Q?yqR3NekzBEPBWeyFltHAax6bfbfiPR/0aeaOlKRf4V/xIZnm4POpfzVEfmpY?=
 =?us-ascii?Q?RZ0ZDD9bXxh8Isd2eO6FncqO997iYdvgtcsc56YgSd1ofafcY1uklLEShphD?=
 =?us-ascii?Q?pCLZwbqXn+fl2GyUw/5iw2uOgR5KInyjgrUAjS1utMuxjLA6WivzLAk+5h4A?=
 =?us-ascii?Q?9/4BZpgyRmRAVnsZ0Duu840+siFFhQeGWo0Y+unkpdwDVr+Vqts3f2r5zpWS?=
 =?us-ascii?Q?gNy/3cajYhphh1+s8wdKWYtnSrgvVwm9ALV52kpAJUkrPvW07B+pNC62bKZx?=
 =?us-ascii?Q?X05OC14FWNJaY6EuTO7MLcaXM/gjOVglgLBoaCEHnW/Ypw2Ovy6eIhRiXBrz?=
 =?us-ascii?Q?+Kk3+3qIF5VfDhT0Smr2Bvyt1p/kwDU4Q8mf9uvlVb/Jf7+NroHh7GuTrlQH?=
 =?us-ascii?Q?AIl+enGDLBduZYVu+WP83SyuKjcPFf0jvtuF7Pc/2gFQsRW3MmqAc41Eh8XH?=
 =?us-ascii?Q?mR7KXWESGZAABlQnn55d7wmkgU9+ouhtRY3p77JJO9ygN6OkYOgvnwByMPfJ?=
 =?us-ascii?Q?YcJYwliaBwfybZ4QiYtFknVdjKixBUucQwlrWkNxYF1fb1s4W7FXUiIbS2Sj?=
 =?us-ascii?Q?4XOF015Dfpuwlqsjcs1cWba87RdQI99dlEqA2JPBhn27PhyfwpMf+8FMEZkD?=
 =?us-ascii?Q?2POoyiqYNkaF3r6UmmRhx+hc1jXz86FRDf2ozDvSxJDJ/NubPe5rPD12aGIY?=
 =?us-ascii?Q?Nvm5GfhViLQIJvvecS011pXnRwIl45NLKuOW5o5B47UX/4Fv9h300zbuz1E/?=
 =?us-ascii?Q?BYsr5SOQj9uMQE3Bc6hmQm73im3Ch0ynPyH47LU5dqrNgXqM6KF3/j1F2d9+?=
 =?us-ascii?Q?FPTsNz+Nt58FFAlIz6MpmOLm8USTrdvuk+gAFh4+E7JJcu5ycdLLVMoKKH7J?=
 =?us-ascii?Q?JruvN97QH2i9oAFNF3UrWl8SYj1mk0IQ4gpEvxFdV7K6WdtM92WqNQZiLN4Q?=
 =?us-ascii?Q?QS3Sb0tHpC7Y+neUTD4T2ktX0BDygWamotw1qwkMP9rp6QeQhO4fHWiVaq1w?=
 =?us-ascii?Q?ky0MDajilLc+JIJ1veHjeufZi5FcAfYlGFb1KXi/XEKaC9R7O8ma2hGZTcl9?=
 =?us-ascii?Q?A6kOXftpXcl3ItFttJpVXOt7UNpzJz20p2XIiW+C6A7D2eQD8nluoRE8yvh3?=
 =?us-ascii?Q?o+8CZ7tzlPmpialm/izwOhXGrNAe/FpLFYNRCS64WsAxM54g3k9Ug3KgDmWe?=
 =?us-ascii?Q?XS6vNP6Lk5UTw1O1KOkdbyHY2+9H3kMUAs6JccFPB0upN8q5FH3Msrk31JQ9?=
 =?us-ascii?Q?zTDon7BJ6wgSQ9OG/rb07tegnwjKQd6YmJcY1QuZCtb4QTHswUf/wVRVxerh?=
 =?us-ascii?Q?2gpt2MwpIWF6cqZcihctANItbOoF/aOOnmDupMwbyj5hpogCjUDFDo5j52bl?=
 =?us-ascii?Q?sBJe6D8KSEntavrsNiEhUTw77/qCrOO7VHZhQZJLiSsdvuWT38QgnCL0PhfZ?=
 =?us-ascii?Q?b3xVig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iVUaQxGMitVwRvfeyPqiC7NelJkV3JBFnTMA3hW+/2Zgm0Vawrsl9bRBpAoXGBDbqQa+a6fnMURMhe/ldh125nNk2vsRcN66r0JjmewOaZfefGgsSrLVFhs4WkQwU75oVS1ir7ZWggMhRnAstww3kSWt3Ehcjj0zDHmrbz9RfZPWhZ4jbOkq9pYuXueW3qckrSm4Vg8HG4978qf/wiS1xcf/EOfhgJ4V8OqBGm5U5llG1PaW1xRfOEGeZTSN2cffhmT0xeO6hWAxmD1MvJ32U6EagZtQz3KfCjjQbUvVZwuoagl5GX2B07Au7arY0Pv2EITxIWGFF+CtveQSmxDr/hGpQDOGCm+zkUDWDJv1MDL2KibKaM9nE0MwrgNq0kN3IStyXeKrP14CDYiLW+G9AZXrAUnw8zJhqr7Ydb4IyTzVhth4ADtGXt8LVXVu6JlhjoLjIaKXA5R2mOWTvaNbDBKQzo1cdEaQN3OQmwgIj99yN3YxKM6f+tMJ9Y9H5ojFV1Tq7wO3ChOYVqBAeKOARCHT0Kf/tSsFcN9rE8PV5b2+lmoVip9Ussg5uWY7YvQsAVDXU3LeJdu6XjUisAIl7AJYxl54XwBdGilwv6pbPjk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf235d6-41a4-464c-8e42-08dd1f98a8e5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:48.7092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4BVJCdJjfOfowpNaWySq86aXM1TzYQ7SIst3pEXeaBVf24279RNGkNk5xp32EPOmFqGndj5UoU95GQTcbUvb4UxthQdZKDJBzEJ4o3DdGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180149
X-Proofpoint-ORIG-GUID: 8wQuQXhsNVSYiQy6FbB0JDM-0NfSO167
X-Proofpoint-GUID: 8wQuQXhsNVSYiQy6FbB0JDM-0NfSO167

From: "Darrick J. Wong" <djwong@kernel.org>

commit 73c34b0b85d46bf9c2c0b367aeaffa1e2481b136 upstream.

It turns out that I misunderstood the difference between the attr and
attr2 feature bits.  "attr" means that at some point an attr fork was
created somewhere in the filesystem.  "attr2" means that inodes have
variable-sized forks, but says nothing about whether or not there
actually /are/ attr forks in the system.

If we have an attr fork, we only need to check that attr is set.

Fixes: 99d9d8d05da26 ("xfs: scrub inode block mappings")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 75588915572e..9dfa310df311 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -857,7 +857,13 @@ xchk_bmap(
 		}
 		break;
 	case XFS_ATTR_FORK:
-		if (!xfs_has_attr(mp) && !xfs_has_attr2(mp))
+		/*
+		 * "attr" means that an attr fork was created at some point in
+		 * the life of this filesystem.  "attr2" means that inodes have
+		 * variable-sized data/attr fork areas.  Hence we only check
+		 * attr here.
+		 */
+		if (!xfs_has_attr(mp))
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		break;
 	default:
-- 
2.39.3

