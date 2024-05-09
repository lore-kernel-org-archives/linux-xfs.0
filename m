Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6425B12DD9A
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 10:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715251291; cv=fail; b=ineSQ4PC0XpjlwZtGQL6jNBDIS8AYlZ6n1FtG02QJ3gg4H1toygPhyGI3YUnWkl2SEQgIKnc90I7ZhVJPiZ20ewfjjKt/vL6IxCiLJZyMWvs4J+TknEAzTlf9bgQZpDCThhbAnWStyLwoGNv2uYfMmPl8kL6ZKLPI/F10t2xqfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715251291; c=relaxed/simple;
	bh=vZ9EqOj9TKPWn3jZmNhs6KQWluuIX1EJsUwKoO5BbXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q5XHaO8vlDumZsuV2zJY0N+4QYNjNxkZjSY7i2+lwr2vqK09B7yAe2NI6IpBEZgYyVL0oHfKOX622uhxnrdCQ3USY0+327jLPBxfszzJGEo+Ykkgolg0zwCXTmnemQTq5POI8a2tuuFka4LyPIad0HHqzPnQ9toNzBY477fWqzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eanrVWDe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LtUCWV5t; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eanrVWDe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LtUCWV5t"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 449A3Acf017106;
	Thu, 9 May 2024 10:41:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=f/yeuP5OutsqwIejzPiPez7+Ib4LLuDqFyHgzNbEVmM=;
 b=eanrVWDexnSzlGp9BQnUEkmO8GRRT8HbcO///jkof26oxj6qdTcdSjkIHU9ILAXFNrWZ
 IOFxKyxWiSHNmKj4QHHnPkKXWzrgx95olkDVnowmZZlbI1egTvLG6dfGeqCXRqWStQyK
 i3mxDqPCqMiKVShR9VYLpG1T87Ax/oGGbYFu8OopRGnvGW6i5J/NWUABcE/3AFiQnk1h
 ON3slN89fmn0ayywDHdIhdINdZ+B5XWFYC3rmM0Un8T7sSr8pLRVE11GogPMIduDRhAo
 A8dksU1iHXyuS8r6BEeoPP/JbmrQoBZjXp3r6q6RJvhk0I0QsOFSFFsHi7In/2K/lSAx qg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y0usv03vp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 10:41:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 449ATbDm020142;
	Thu, 9 May 2024 10:41:20 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfnbxhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 10:41:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Br9OEZRuqt9Gcq3sehyWSumnXgrbu8gHtr94t9tbXAdrjRkwyHCzkESP/KooUciT2Y9Vrm2i3ixdhkKeUyyFEEhygZQzluMf3jbmoYyOYHQqsrAIjaniyYZM5ZfjTirq1ckIQjldxxGYM/xn8E/jusVLBDckwFGyW2Oyhz//Ji/Luk/M15hWhVTuYZqJLDbM5NM5NIPD+R8TaJniZkb3g44Ey5Dr3UzoRhGgYoZh48k+GwOtL5A+tvhjOVa0D8jT3s6Ci9jHh+E6uIVI61V/GerxIidwJunwDKyZlCg9QHJRM8QHlm2Qab57t7U50Ibpi0CYxOS8Vbbh6RCC/51N2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/yeuP5OutsqwIejzPiPez7+Ib4LLuDqFyHgzNbEVmM=;
 b=R8V6E0+M+ZzeK1pGUDNrDwqodK1upSmGYs1ut+ucupDAn7OiRm/9z9uznFAQFU4JimfgN0+7XEtzCiQy5XfirQQG6J3id6KYHpEV9KTOjl2pmfUZ8u1TSIWD3cZNVn7gJyCQo32TIj9T3YKZg/nZMvHiLj/Vs0nhSzRTOYIU6fYPeWibLTBYuky82MfXiTHk+V/hQIgzNPEn4lhFEnqniidseqVJsZXc98FJb8OTbf81xq7Fk1v5dUFIz0FYYtS9S4Gspfczn/EZk1PLeoFPdBforfe7tHQdSH61CGHmwW3u0sMY/DSvZk+Ap7wWegGhnodEvT+4ObmoIBPvr94xhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/yeuP5OutsqwIejzPiPez7+Ib4LLuDqFyHgzNbEVmM=;
 b=LtUCWV5t9DVhQxp1RiZwc9+NwIkcL4g5fFk/EMZm1TTQ/bXXy9jC3/m6tfDumO4E1Vc+4U8ar806OSJtOn4DikSUDYXefgT6aV8qeQ0i7fowb8hZU+hjVRb9tTk6sMWKO2MerNU4aJcXOG6mBw29L18N+86u3DnsZ7PTtWqFAbg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7337.namprd10.prod.outlook.com (2603:10b6:930:7b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Thu, 9 May
 2024 10:41:19 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.047; Thu, 9 May 2024
 10:41:19 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/2] xfs: Fix xfs_prepare_shift() range for RT
Date: Thu,  9 May 2024 10:40:57 +0000
Message-Id: <20240509104057.1197846-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240509104057.1197846-1-john.g.garry@oracle.com>
References: <20240509104057.1197846-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0277.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: af8f4148-5e69-48fd-a916-08dc70148fa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?Zw71ioiwNp5ACXSHU7PHeqE7XZseYXjo8s68W/OI4Q0vhxufQABDalPdN/8P?=
 =?us-ascii?Q?XORjKne60dvuP2e3GDqheNparqBZtN7EydSL9nvZ1oBK7IePSmIttElG/8au?=
 =?us-ascii?Q?9velKXcc68fZ4k7hWCKCuAUp4iBV9ng9xtvKFWbm4oDV88oM9XMx12fxBAmb?=
 =?us-ascii?Q?qOXVrHOgTV1ZXxcQy2NZB/Z8iI5T2RgZSNGr8TIRMvmPktJ1bdd6FxvMi+EH?=
 =?us-ascii?Q?P6/mx2is2wnb5SYYspqiEs9W1pph+U5FMaknNfdCSTIWeCQ4VnJYuY2h/If6?=
 =?us-ascii?Q?dZkbD9+plUwRWh+rNDzKcHR/c+n7zl6j0sRO9LRKbrZOsBAie6zCEr4VspRw?=
 =?us-ascii?Q?D2tTJyLbg1PcDBfp8nSIjgXrnh0mZqcizeGJQtKLnO3sEGyqpzG/Z0rs04k8?=
 =?us-ascii?Q?HgVss/eFKUP8gHisQBnrclWWtzPDD2K058U03dnNyZd5mxSDi7E0zUSKdI7U?=
 =?us-ascii?Q?Rsqj3CXYT6oIu3iu0xAD5mERadKRLrSj2gPktxpAHeVIhtOvd97ECMypcdcc?=
 =?us-ascii?Q?ntvAyWADotXTKQW6FWQmR5BsHctud09Xw2smPn77lIWN9gwsoNWxTE3ggdBC?=
 =?us-ascii?Q?mtqSNb9Tog0gIg62DbiokYwYOhpKHioVYpkGVyKPF+uaJOcIQloOQrSyBs5F?=
 =?us-ascii?Q?AF6wRl7Wvb6VsRPAutgkgJMpcY74m5BeiZLmX6ovmlhrKkkXvo/2AhMijIjW?=
 =?us-ascii?Q?9/S3c2IN70ikBOE1j5Cvt8eFJrbb/9v6vOCpBrAEgWCdNlFJINtqrC0p2+xK?=
 =?us-ascii?Q?1zHoqa9ZXBWomu9jwAXF8QS7/rqXuf0DI9F/cjETCP0w/wF/MHPjB/H9OijC?=
 =?us-ascii?Q?EOi+pASjBurwkjxPAEK9fX/REEnkiKnlsRZoOYf9QuPq7EVDpnDeQnMW62tu?=
 =?us-ascii?Q?z65OYpik8zkEMtQD/Ixu+jm9orm14PGeOepJms3T+q/uQrdnuY+oSqCgbnk/?=
 =?us-ascii?Q?Xf19Pd5CHCl36KWYVpIwPe/BpExRzMxmSE9b0DHbP9fGZOqK0zFhQmJvedcf?=
 =?us-ascii?Q?65UIcvEjSuM9sgU7KPhhg/CK6m1cQicNikn5ytmQC9WzVRs+ZuY4qPIhU8Iv?=
 =?us-ascii?Q?+G73qSCUAfX4XaLexwbQ2y3lo2k014+0eMtXToXLhNzquFijcGf+rfkyrqnj?=
 =?us-ascii?Q?TAnSRvalCR2d9nHpKGq5MuptE0/pgDY8VprCEHVPlA/Xhvh1bb5DtlQBNSQK?=
 =?us-ascii?Q?Skb1HCdkVM98xccBpcZOnIrvpW92G3iAgQak95c1cWPK3L103oUhmgnsJm1r?=
 =?us-ascii?Q?bMW0kqdMvTRT1J3R0PJWOQ8bIArf9IhEjP0DClHXAA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Akh9oRm6s81dy6rRiE/vepbgCv/8CerTKVs0zkaynLiG5S2eX6PKTanB3bkz?=
 =?us-ascii?Q?aF69ASXMFMGni2RSyNl5eB42T9x0JDpVY9ToZEv5E0FBQZgZfJO149+yiTcY?=
 =?us-ascii?Q?R02uLavtwWBHRtc1wkmVt823TbS35M+U/pOZvv0aNtjWDuE03GlNm5n9bG05?=
 =?us-ascii?Q?oFqRer/5vzBcLrG/D2S4Qw29ua4LTA68bWjFm/KCDLTuIvxTBDdzJjdHKUlx?=
 =?us-ascii?Q?KAsFZYXJ2/mwOVokYTDrriOIwmd7OqpzxuyOBxbqNDHnGyQOe3u4krO79OMX?=
 =?us-ascii?Q?Cz8DVbxKS0cUC3zchvWn/2wK5onbPLwMXMaeuLrzkL94GbRvJx/15z/xX01V?=
 =?us-ascii?Q?Vg72j+2oex5iJUjzq3mtCKr9eNUekd9gy65Daz5/yddG1lzRp2cUkEe1Hrqv?=
 =?us-ascii?Q?S7ypy8T8vZGz/KaJKRMB4TAyV0Y185O0d1MRNdIdJb82cgzB8JP9HoawH/gT?=
 =?us-ascii?Q?MFbI+OXNkQJorRxG6b1BuMgdts2nPlh6UIxWHtgf9j8zTG6Kfc5s5XLrM4GG?=
 =?us-ascii?Q?Kvv4MffEJewC1HRHHIG5o92Nt/b7/Ghh8Phf922r0KA8asIB5/TPwxFA1wGE?=
 =?us-ascii?Q?jBLjSLiffr6I70y/quUxAQmSLnSIq4qedfEFbVhGP6b74Wgleafr+Us2Mjkp?=
 =?us-ascii?Q?JRsF6Pnk2hJ1WJo6xmLjokDu7h5YVZJ+6SxcY2sIEUyjf9pEMx3XgnAEVu+w?=
 =?us-ascii?Q?VzqhbCzguGV7btxO0vSnM9OoHepZTavwRL/co6aoog1x79Dpa5G8lzVRlIrs?=
 =?us-ascii?Q?PIGE/SwyNsFy6oLauSME0ozRoPyfDZqsqRNKV/pC7N7D+l26DBaHki76nmV3?=
 =?us-ascii?Q?AcWzjOnfCtsw0MkjG6gbhzoF092LL/cEEO1cX3eC6JjOOLlQJXJqksgu8OlX?=
 =?us-ascii?Q?2UHa1m9M/seXPjapr1Kt2aMZQ7MudEKqGMrCyvxgDEY7YjbwRx21wqFc8QJo?=
 =?us-ascii?Q?DgqqeTLvd4yW3HYklQSxg3UHWa/m6bdk9w9si4QIa8JMON6eF6nS1CWxjAoX?=
 =?us-ascii?Q?ax19eiVe+Vigbc5dF27aeR+z3gfrkIJqWseSPr73K5E4ywg4/lb5NnZsvQIY?=
 =?us-ascii?Q?2H8BeubzCo+4eAIeb+rKiGgglV4tGSmaF3D3Z47Q8OnB6lwkExliZdID9ZES?=
 =?us-ascii?Q?ifXR3gCTz4e5ZRrQuKJ6aN4YLiowh7DxEEi+wzEy75Z9toZSWkAHXHoXJBKe?=
 =?us-ascii?Q?RVFzm3dGsJQyjgJN4v0sWHa4ziUujZ0qfLdW67X+UZoqXVwxFXrVhyS3nCXc?=
 =?us-ascii?Q?6bSufR5+yvJsgOm0rTWnXHI6BiKf9LROzcrVSgAoa3nIuUSrKatYiQBjYbAK?=
 =?us-ascii?Q?EbuwglluVUsCWovapSqqW/z5jsVsbZef0MVLO7JWNu8DZxdpMuJxfmtf8vaD?=
 =?us-ascii?Q?aVUCoQYnYDINvaq+C/2wZirA1TwPH03EqPh+N3ntM5OwcH4eb5y05tHy6WGc?=
 =?us-ascii?Q?wu7YU8JbCBIbFbzhDML2FzadFwkTp84PW1k8eeONSthJgwd1lHk4m5v2JXTP?=
 =?us-ascii?Q?teiVGkYeycfUAkfOsJhH07cbrS/VhiczW0YO5eehnuDbGTIIhTaA/5kLFBsE?=
 =?us-ascii?Q?eFE9/RLbUt8jlnY7ErxoMj8uBASnU2AUSq9Gi6wZ6j/2bja6GskRAitSsQIP?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	lxAu5ONJLqJwtDvdIuzHIBS+8B0/R2tQJIFZKYU3QdimrqbP6C+QAZR6KAShSzuYqRzDwtLrsad0h30z8jEQ5e6klFK74vbs48oFMV5DfaXc6FkNm1pwQsB5iAisqw5xR/4JqFUTw/tE5FjhQ5K2HPf71aD0j+JnuL9N4L94fKAq3G8RirgVqjQQy6oNAQAhw4iWCRiWHhw85GdYmsBLU6uUi5sb5FRWI5mbADU1qj1Ewmi5o/CnRdQfv6Qt6Sm2IZTfUr3sL1JoR+BwbOv2m1lQt5m/moOGzMLv6iS6zEqzAl8lUXIpJ0jRjFg6io/PlRY/KhSKUvEzyidCPOhJyOZZI8yRsvfszBH5CVPSM4zezFCSLeZzMkxoJewYK3uVTMU57ff0Qe8674yhAskzqk2eH9M/kE4l8S7mZWAzqdjgDChptHQ/EZO0VhTf6ZjB/Wdl69RhTHI75sdPKYuV0jnrsZOO3Xa+loNwFlfjWXVSvOLKBqGf9E7B4a9TxE2XY7W3iclJ9qgxmdZezw+9MUR+U+eUCdTYXEx2s4lCv9FZmC5pM9OYPjV8OY4W+bS0oDmpDf4HVwh6BmF7Vi4CpdrwI8SmVhytVdkNNwDPmPI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af8f4148-5e69-48fd-a916-08dc70148fa9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 10:41:19.2957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxjysqKljlpaUw6yHo0z47YUIFitVnyaKPjcdij26POg6g5u1x6NA+HGm/nNE/EmcFs30G/pCEKNbnkWbzHm/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-09_06,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405090069
X-Proofpoint-ORIG-GUID: 1hYSZjOYGwA0mDBLveUgFA2IYrcsLifl
X-Proofpoint-GUID: 1hYSZjOYGwA0mDBLveUgFA2IYrcsLifl

The RT extent range must be considered in the xfs_flush_unmap_range() call
to stabilize the boundary.

This code change is originally from Dave Chinner.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5d4aac50cbf5..52d7ee5bbb72 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -888,7 +888,7 @@ xfs_prepare_shift(
 	struct xfs_inode	*ip,
 	loff_t			offset)
 {
-	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		rounding;
 	int			error;
 
 	/*
@@ -906,11 +906,13 @@ xfs_prepare_shift(
 	 * with the full range of the operation. If we don't, a COW writeback
 	 * completion could race with an insert, front merge with the start
 	 * extent (after split) during the shift and corrupt the file. Start
-	 * with the block just prior to the start to stabilize the boundary.
+	 * with the allocation unit just prior to the start to stabilize the
+	 * boundary.
 	 */
-	offset = round_down(offset, mp->m_sb.sb_blocksize);
+	rounding = xfs_inode_alloc_unitsize(ip);
+	offset = rounddown(offset, rounding);
 	if (offset)
-		offset -= mp->m_sb.sb_blocksize;
+		offset -= rounding;
 
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
-- 
2.31.1

