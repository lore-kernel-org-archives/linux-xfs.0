Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABF415749C;
	Wed, 18 Dec 2024 19:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549458; cv=fail; b=Q8uRCO8LxZSX0urJP+Ql5hta7nfr+Ih2Zj60lOsoEhzpIHRXxc4m017jmI5AzaF53q8kO3zw6rjysOMqRWWFeOLt6EVfL0tjQt8vybgKPy+UC1exUxkGLVt5J2n95dZS7mHXF/BziUXZJFuZMSrfI6XHu760iiTNU5ODXx/P2m0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549458; c=relaxed/simple;
	bh=7HxoKly9m+RoU18pugAA9ipH7pPZdKfSO610fB05fXs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hGk/5gArFIUSGIh6lGTAzXuDleBwIE3lgnwwxJYwCNxdq1+BDj/bIc69p3G7G+EaAp47Sv12ABuRiyqDdG2h44Yzu5zE3yupj6Ly69ZvqmFVASU6TzGJJX50b2jsdYiBGYhSMu0YDp1fcWicq+WdQ1JiNA8Dwb5v6pmGkyHcSgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MRFCbgAm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XXDUWLrM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MRFCbgAm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XXDUWLrM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQcm6024342;
	Wed, 18 Dec 2024 19:17:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=BgtgrnmHINNT6JEU8rfpoYiqQW8BCuWzaV//sNWSHhs=; b=
	MRFCbgAmnlwNwSgFKJNHIzAcjwtebyDtARiJ6vKp2XDyuhcD+NXJFALYNjbf2lTz
	AkWHxeru8anXDKWB/w7uJSvfS9UY5xN18sQ3DY3cui4RIps6lHT/ocx4zzTk5wBz
	yVupG+KTv4NucA39fm/sQ3smnWIk/y64yNJRr38JIFbWdEGIDTpRq3DZ2mkeNzId
	+Eoh/wD8JFLbwUwPlDnapSsBQA3UcRmnZAoPzkYrmbG7GLnpzoDTaig0oAtHNPNo
	rOiIzkPhdHLflMgaCAdOXyanZbhTPDSV/McDdvYzJgIhyccEpSojcmx0x3c0XAU5
	b/piWNZO1QIRs8h5N+z0tg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h22csek7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIIBlko035464;
	Wed, 18 Dec 2024 19:17:34 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fa8g1f-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DSyr6kV8Dno8IsA1Spt+44UROiKxwAWkWrD+6VeRxBkYSHc7QvAHi42zPUNQAmaEekEjfnwBV+iTy1vDFlH9fdK8ZPmB/eR1H9ZO9iOshFpCn3fZh4JYFY5RlM9+1FgwL9y32Rk+mya0Jj2GrM7UZ//QPEtzpvqpXPi89wc+RHr+4yX5eaLqvcYoEXhJRfazIOzQyBuW8TZFFaMOhKROi2yod7ikTFjthgLbrfiMy7CBiXnriODJ/eomTH3QQQI9bkv1jZ7ycNyj9NkNLxMTJa9OQD/4s/mZVRAEqSpae2VqVMj+A0ExVSYFlCe7bU6dIKRoHfNTWHRJr/40DOs9Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgtgrnmHINNT6JEU8rfpoYiqQW8BCuWzaV//sNWSHhs=;
 b=i1mrOK0OnH3CTJWhfmfEmNqnF+jo2MCATM4sw6XqSE+kjtoDCkYFXbyHb2hqs1Dl01zLXcPMA3gCAxOh+6+7lDqAwzNL56uSLOOi2xoEkvLaMSDz3CvCnbunt0zrM0JtpKytXtnx35Imv2xMNTOQFnc36UoTjSI0aMZBlx/a+KfAfD+hmT9RTPqC2e4t2H9hkmr20UV9OlrfcgL3Ioe/zi2lALsZYKWpP/zBS9RU+RPLAxoy8IE9X7zkn+jcSY1ZiRktdwOofdkUUCPQz5qhrhj+i7GmiraZF2u1xlXFQKtv0nEtPCgEk1CB/mYG/zn493tP3HWxcHTvNAAykZclmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgtgrnmHINNT6JEU8rfpoYiqQW8BCuWzaV//sNWSHhs=;
 b=XXDUWLrMr+06CFW3HULHjyvKsrxRmqOOl5KzGk1Ewzh7bHi4rbYYSpNoLAm5W00JNVKuOrNZyccih73/Jfaw2ld57wYAoN/5ymphLks2YzE+hNAtqBjiLcqSXC3VHQrlxUnqlFTuUP8pbnVzkm7F+jJsCEEnRqUhb7txibd/Sps=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO1PR10MB4481.namprd10.prod.outlook.com (2603:10b6:303:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Wed, 18 Dec
 2024 19:17:29 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:29 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 01/17] xfs: fix the contact address for the sysfs ABI documentation
Date: Wed, 18 Dec 2024 11:17:09 -0800
Message-Id: <20241218191725.63098-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::17) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO1PR10MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fa14327-6ee1-4751-7dfa-08dd1f989d23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?54qIPaW0qv5acWjC2zwhaYfmDV0YUe3o6nIWxocITLq/a8X6sQKM17tv+94w?=
 =?us-ascii?Q?1rN/zcrIj/uHCLEsGBRLFkMfGRmYDUNqdgqMwz4qkl+r5koyPyVeEoHHUUrP?=
 =?us-ascii?Q?OD6fTpcgQ7+/+HO3rsW5MDSpb7KTDD9RNhZ5MEpDJItC82D0rtcseTOZaE+f?=
 =?us-ascii?Q?bxcTHucudKngUvTIPSmLjfEdRvlQdUlTNt9VqsIAtq7tzjtLoAz0BJ/v7xbI?=
 =?us-ascii?Q?CCRkqauA2ZaWnvM7AoHhwqs8pJHvv4FizU6z3i+VORKX/eNZyGE2ptX9++da?=
 =?us-ascii?Q?fZ8+oVCAgfb8quhAqEcHFmKwbyqqlVgNG7E6QrpudyAGofnnXN8wcY5xHhI8?=
 =?us-ascii?Q?pkYu12WiV6AVFSnugtcyewj+bGlfdM6WPAtuKH9aXYUi3grbW8SqSK2CQ4Qc?=
 =?us-ascii?Q?tCl09ITjnp9UJwQjTSA/NG7Zyh7PrxvgKX9NtFXOYK1RWd59UhMxTfeTqLLa?=
 =?us-ascii?Q?g1T8WePP7D//UuLhEXQ92FDJQGa1PTQFd4nu1Ns65A7Me5SwjoEIe4pAkCt1?=
 =?us-ascii?Q?QDYX+nNm6Jn0tiIFdBLdHJ5PXEkw15SVsXht0WTjeUWdRU24IS9EvPYHeNN7?=
 =?us-ascii?Q?zLaPLJv3q1RXcYsl2c4AdrNTzLn5NCBAar8R9JiwwHbNOQQ5DekhpmsE+gld?=
 =?us-ascii?Q?cbwjDuTE0oHQOmB18jakyUy0xKOu4foCZAF+UNOBUOqqFx7gr875s8RvEz7J?=
 =?us-ascii?Q?P05ghm94yOvxwbIP6vMySeQdzVML2nhjufMxydf3f5WGopOInB3+4UNvpHhc?=
 =?us-ascii?Q?N80L7FpDmIiVNdTtzhd5VwRDLBSvpaMJQqAZOFuLV9Np6oioHnLQ4u2zIJ17?=
 =?us-ascii?Q?TThbcmF7YLbM+I+BJO8oLUn1xjoOAtZ7bM75xbtxJapVnM0c0VQ2SzJ4uzuk?=
 =?us-ascii?Q?92hEUeAxvPSZCtHQ7kpzsO4uXwtC33iLNVTMwcYkzBI7uDLzw2XhE1IKIYR9?=
 =?us-ascii?Q?LN0espX6fn3xdtuzfcgTem4KuMPH405ZGvcslwUthl/i3xntxrw9+FJdKJpW?=
 =?us-ascii?Q?iNqGd5pZP2Pl6pLdRGPp2xjCkn1U6e8UPnSklRWpMEtQOrsnaHOf3Ij0pKme?=
 =?us-ascii?Q?aqEjt2fN4nBE67dZBiXepqOLugCGyJyYGVo8fCa07sExvBOPS1Py9ieL7EjO?=
 =?us-ascii?Q?n96UVMnNHYUnJMncjBOF7xGMRB+QTHINbDI0JpdahlBg5IEW2P7uKBtSAgpG?=
 =?us-ascii?Q?krVu803rtNagy92jK+JGGD+PT3xLzoODSa4QZyeyymGlgpXqWAs3kFJHr0B8?=
 =?us-ascii?Q?dtpDmZ1UsH7z0nIy6LvFCkh59eca+ILdE9RdGGFqGQ58CTHtfOaYzghOPNjL?=
 =?us-ascii?Q?2PA3aQq0tTUW7Ao8iLXuH1WwqdUcpB2n4wlyWNhoMW8g2vh9fdP9wUexNrO7?=
 =?us-ascii?Q?OcyNx8uo7+dEen3e7mqsIssXJtKY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D6V+h0Ps7A8y1rQff5UpRThRvsxA9EV8sUpjXrKflWu1Wb/ZubYUP1hibsyo?=
 =?us-ascii?Q?nB1l/Ehb2GDtYYx0X4ilhs51O9jNWzlOkEZQKcOv+Bz1pv3xdJtHNtPlqt0Q?=
 =?us-ascii?Q?slBSIeBcFDqXDyZhicTcJM8zl566XAOltjxbi+GfF3L2XLz8VbTrGyBA9sH4?=
 =?us-ascii?Q?dctX2SrrfJ7mPOi24ylGLBsGHPZcTMhkTvLk2RwKMM5Wsubn1/+/It9A80SH?=
 =?us-ascii?Q?kVaWzY1fc1lXv0sTyy+2P8MyYWSIVuOXEhVapzgglA3SaWe8DNWcxpCsDUh3?=
 =?us-ascii?Q?QX/04vBiVkO6cnI+PUcuje+xHU8IRrR4aPb4pjh25TC0BFTtib8XNJyBcEfl?=
 =?us-ascii?Q?v1xOih4sWaNDvrE2Kz1idzgbUNKaJq8BztB84JmI5VwRjckmRqXcuSJRhmOD?=
 =?us-ascii?Q?f6J3nMBF9Ft05G6qgruQRcYyuw+kUzeJ3q6R/dMhs6ANuOJdwiQqGTS4SFKL?=
 =?us-ascii?Q?kZ1q4orkkJdenZrxcbQ3rsfDXjd11oHJ4iDV9+eUwj+xxP9c13REb1vCoYpN?=
 =?us-ascii?Q?obFfifhmmyuCjriApYA1pCpzOPJ3X9I1tVvxZV/+LidI62xgXGT0cQXk6/A9?=
 =?us-ascii?Q?51Sn7wpNMjimognCtu4ZMoW2pKwyCUaXHaEjz+vUjOa3XEIm5+w6EH7LBNUr?=
 =?us-ascii?Q?G5SHgiG/iS6z6ygUTGy3pzJavCXXepuM7CwJE9eI2FrhFeY84UYYokJBqXKg?=
 =?us-ascii?Q?DW90APLAiTwKV2bG/qCuwRimGo7JWcdQAeEnjKgVzJG/CswR9Njh5rYKgEax?=
 =?us-ascii?Q?kzXLWLQRtWxX4o98ao0U9WaeqjWChOJQcb2OeByeeV10gQUeIl5t329tgCjE?=
 =?us-ascii?Q?8aa6GIrJV+RHoL+Po8CV6nVAOpo19xKa2tDgTXPgqlS0iO+ci+/oz9XALF0x?=
 =?us-ascii?Q?a8NlGQvIRIXkfzYGpvKVZ5SbrSF1CPesIlYHXOOEZuoS2HaocedhXXpEU3dc?=
 =?us-ascii?Q?H7nAIwL2aBua4lmCQYoChhEQCMlNush7n7QC+iROsEMAp8eAE4tCkzj7QZlD?=
 =?us-ascii?Q?RAc6UwobkNS6sm7t5SD1dalL+cjmKhdL5isJe5z/9+I3paMlV175UYnUXJhc?=
 =?us-ascii?Q?8UBcTSpWlhuhvsNqgTlwFjFd8Y/K+q66c+PvoZSnMDEplEQhB4FkU0V/OTEm?=
 =?us-ascii?Q?tPYAdnr57qxpDKRyFJRQ2FOOT5EaQPBKnqr/quCAfK84O0ZJN852JsH9qtOm?=
 =?us-ascii?Q?VghNc0/WKI6yjwpz0tJW8VZAZlfxxqMXmSgCmD5Z023jatFdHLiT74isNC3O?=
 =?us-ascii?Q?PnQtGIcdjhl73swLE5HL7h+x4P+QeL/VrlKFKqMoBv7bnbEtIOWEHmxz0PRf?=
 =?us-ascii?Q?tKJSZCAQt+C3jqhKIosPCFgWbgW27jL5E+CZlmDdiApi0Ic98lL3gJynZzdB?=
 =?us-ascii?Q?L6jPDZfKzsHpWGD01DC911v4n3O4NNgMSleCLgpboX7xhrDsqnpL/rJZPBah?=
 =?us-ascii?Q?nX8ZpGNd46oURYK0Mmb5NkJC7z6Mgdr2b/7w6TnDN1YkjJgQsTejgkaIGY/J?=
 =?us-ascii?Q?dh8D5gYYvDy6hCbW62xb58fgKlWOyK4xmRC2R6rJKHsYamJ3l8pdJT3amEQt?=
 =?us-ascii?Q?k1/Msie8GA+9TdzonKB85rtVCousImeGsli3yPqF1/RGJp5fMQtBV3MazhcM?=
 =?us-ascii?Q?jM0GgASOL4oS6miEqkY9UMAE+U5UcYuztoM+10rntXIZKxo3DrBNUuae9ovS?=
 =?us-ascii?Q?WbVI5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	awhuVrGySZnAeYf0ral7/PHj1hb+onJXVK60lyiCpJTG9d4Tz5eUDr25sA08s5mZhqGoI4Djh1ceNTWtPkFbQPBYyqGZj+Q3Jj2y1qde8YqxSHJ/DyQtZcGxidPQeW+cet7/4ukq/HzYuxCIV1+64awY1zwyd2NrwxutaV9LuYSbbZgte8GdeX8QBl8/Rkr0rtSF/tTeYX2LeX1T3mqRGnwh3vwNDupKHhe5e8KL2dN+W2RK/RnH7/ycEnqcKV3g/C4hx5z1rcLA84odRkxNHDFfxXjSKHmcaIkZ2Q7Tv6a/CgHOxRMGw8bspkAZkaeXuMl8cbfEIvuNARfyJHRdTZgE/7dexEVAwkwABPhuNuJBR9MD21beMCB5xlrybnaRl7AsJmmi/i2QhZ2H0wtqE9ermdpoLfGgj/Fxopyco0ijj4ctOb4OBin1cwegRA9RAC+t5fV/+a0EtORasRqxDIj1YiCN3ZgPpVKxly0wDvwqcqtLJeC7NGavYzmV9SccnFE11KZHPtFAEk/Qz4eG4c8e0mkJ+WmgrwmadizL9ncoxunvW0mUqp9X+Cw0zbC1qC6ND1OVZ3Oen7UlJhv5EXfzGLDV7iYPqxeYTmzpHZs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fa14327-6ee1-4751-7dfa-08dd1f989d23
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:29.0791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: neyg1SXbsTeucNpnCMNm/I+6/OOd3fk7iN7c83vxPRGvmJsPknEXaIm9vHFmljpIHmkL4lKMn6CNQCxrymfCvK8uJL2kK/85mqSzbdMeDEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180149
X-Proofpoint-GUID: hx1XCtAMEBcg9ZYh8crWXaWH7qn7rtHz
X-Proofpoint-ORIG-GUID: hx1XCtAMEBcg9ZYh8crWXaWH7qn7rtHz

From: Christoph Hellwig <hch@lst.de>

commit 9ff4490e2ab364ec433f15668ef3f5edfb53feca upstream.

oss.sgi.com is long dead, refer to the current linux-xfs list instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-xfs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
index f704925f6fe9..82d8e2f79834 100644
--- a/Documentation/ABI/testing/sysfs-fs-xfs
+++ b/Documentation/ABI/testing/sysfs-fs-xfs
@@ -1,7 +1,7 @@
 What:		/sys/fs/xfs/<disk>/log/log_head_lsn
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The log sequence number (LSN) of the current head of the
 		log. The LSN is exported in "cycle:basic block" format.
@@ -10,7 +10,7 @@ Users:		xfstests
 What:		/sys/fs/xfs/<disk>/log/log_tail_lsn
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The log sequence number (LSN) of the current tail of the
 		log. The LSN is exported in "cycle:basic block" format.
@@ -18,7 +18,7 @@ Description:
 What:		/sys/fs/xfs/<disk>/log/reserve_grant_head
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The current state of the log reserve grant head. It
 		represents the total log reservation of all currently
@@ -29,7 +29,7 @@ Users:		xfstests
 What:		/sys/fs/xfs/<disk>/log/write_grant_head
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The current state of the log write grant head. It
 		represents the total log reservation of all currently
-- 
2.39.3

