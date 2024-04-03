Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C3317C98
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 16:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712161921; cv=fail; b=frCwK04HoXwG3Oo7a9sPeLBot2Y2rW/dNIAhVGxf0q3IfugD1FK8YG87yW5zmbVK5gsyqydpwsUWcwddPxRdEr5N3yk3I+PsQ6yC0T8QJhLdfP+HSumytxwiSFPUFw+8TyaIc7Si1s2y37or9L3x6u+mWVoAPcsVpj3CfgTYf6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712161921; c=relaxed/simple;
	bh=zTI/w6cB23jCXX78hA1gEbP7j6S8MqruS91fP93T3Qo=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OipGPXeBAx/sn1/XdDhDVK59K4kYW5p8c6xlrO1GX6qfm+wXs7dR5OhzXlpRlnyO5jTzPCdaSfIjfffcAV2wOtuDYCDzAqiNqJwhTEyx9Gb/z+XTop+qSB07h4zN04otS+nypsZIvSgcDUr3z8eycSi+Xg4kmHHaclh6IuYgEbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a6Hf/pqK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TVo9VYUs; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a6Hf/pqK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TVo9VYUs"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 433GO3Mf014579;
	Wed, 3 Apr 2024 16:31:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=kLkBMbivGvOEoFi0K0JyjRRiLp0tAM+6BmccvP0DH7A=;
 b=a6Hf/pqK2hUWz1YOk/jZa5ceTmussCiz/nqyFNb05O/IOrXcfGBzsDGkmO1TzUK2SVqV
 rsFAnis/fAVym7HDEqpvJaSWLVn6S9Fc69xywg2iZuRK5ATDp+cL71SBIvZi/qEMWrOA
 wW9gtM+2P6GDbeAd8ONuU1CZwINPqxbJGdUNSSMwHoMkW1LmiFAaIyfV83W/P5e4mxDs
 1tshonAnItv2uGvUenDJL0vrGOglczNNJxkiMVYajaXb0s3kcEQddqeT4uknEQoEajhL
 vV3yRvxuLw5x8f7vzV/t9rFOilpGJkziuRWyEy6cTkFMbylIdfDiFYDMm9WGFWlItN2s aQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x7tb9wnvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Apr 2024 16:31:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 433FZ485009875;
	Wed, 3 Apr 2024 16:31:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x6968us1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Apr 2024 16:31:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZvB7Spe2mAZgE1+5GNZ6vZLPzj2Ay687r+E/StAxnXERdeAdnXRrT3AAdIIYRYM6mb/+IYs0KrfOWw450reI2YROAoNwS+CUswlrAsAGbETmxlXmWbe7k4uUkR52S61Ou0WztHxiHU4PHWVFPbgwgtbPzB9kn0XxlYZM3wl/dVK+xE+4F3CevEKDqbz/yO2XyA4x8k+ZXn7g8uRnzZdzfoAQTxC5EIPhsurUbvkzbCP5G7bTRc6nxPiNg+ksaCuc9uiF3MyjJ+0LUcQu916ausRLvWVbWNusbIeZ5EwTOuBvCV/ecgfangV0/Dr1hiCZBkUwGBT8C0ehI17vY613Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLkBMbivGvOEoFi0K0JyjRRiLp0tAM+6BmccvP0DH7A=;
 b=EI9CH1BFJrsY17CS6SPAldxA6HV6mv3Y1DRAmQJk18Pkiz8VoOaFoDDQ33xYuhrCq7X0meifHAtv8//khK3/hw5rsW1AjJLYI6Eplg11YnYNY8WX9no4JC1oLzO+UHRAHephCo9wAvrIn3tMjTM26VM19BpIYNln+cKbU9etQn+NoDKnar0mGSm64L9buD3GCZUR5v2leUTKcgnl5TecUqwPy4G2gXYvoo6atPLTJrykl63515LbebdWs9FO6siRrGIBix1/oH5OK4M/jaZ/kh2/NqquCF1ve0Adt1yPJOW5bfrL/I4J0J0CaFVw2c/QaqtMrAFgZHAQSxcJybowYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLkBMbivGvOEoFi0K0JyjRRiLp0tAM+6BmccvP0DH7A=;
 b=TVo9VYUsBLUKyHETS8oS/Em2ROeKej0KWUrkjn2PbIKlsC/LF39iBoqTfJH1RcS0zrN85BekL6Axuln/PSuYyrW6zCt2V9rdGLv/qV+m8eS6BleI60wf66bds+znEUHO+dE3MB9pv7AMrv97wItogSAF7rPOIlH8BX8VZmOFJ0M=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6638.namprd10.prod.outlook.com (2603:10b6:806:2b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 3 Apr
 2024 16:31:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Wed, 3 Apr 2024
 16:31:53 +0000
Message-ID: <c515119e-5f0e-41ba-8bde-ae9f6283b3d8@oracle.com>
Date: Wed, 3 Apr 2024 17:31:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] xfs: only allow minlen allocations when near ENOSPC
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20240402233006.1210262-1-david@fromorbit.com>
 <20240402233006.1210262-2-david@fromorbit.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240402233006.1210262-2-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0098.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::39) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6638:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Cmfz1LSPDtINLFasDBYGG8K4TWnWQw9A+t2apBhTe608oZ1UG4W5r9/Yj37P/1oKE6XYQG1nQPmzIKdEPgDYD2xcpPjHCZIig+VJqJvtxDJ++vtMVr67INpV44GFEBFiKO+XciDMywaaaP5fugzfgSzn4OvjA3Elwy2OKJGW+AUPEjAJPWtPdGg0xdFO79lMgDfkD7lz5J8xxs632DAUqH8/thZMxE2r870ed/CkgwNSI7xJk0FkkFO16APZoHMoUx8MhMVLX6ezxW9S2s+NaJExxxeHn10OckINgbMqhPZL2dFpt/tBnVyggLYvQA8O4ArHUdHNKMYBSGI2Ld8z8qI3ix8LWq4JjZ4tgKfXY36J2n5/Fp60LqKIVy5eGlyT2O+j4zuP9BsGvxtXknKlKga1wDsizWiQaREhh3MHDKoAjjkDeMDHW2yGKAkv9mgfQoqkbK30aA3qxFU7NQdzJNqNzG/SmKJfKD09CoGS4+qst8JmSiuP1/DfUXQeDCQuYZzqd7mol3hW9+AinttPOFUSEQkZSl6S9ww0L8+UdcOy/UKsbBMGb5zIw/c+ZL59alHc+k5OyybDY4n+ox2nqL2nTR0STenbQCm37cJlEBl3cXTHnyes9ItITqDwRGwA
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NUgyVlNVWXprZlM0bVhoWHZwRFNVRzQrUDlDSnl0K29JdmJxM1piKysyazRQ?=
 =?utf-8?B?N1dXb0ZpSjBQN1BIZXdrUm12cmVxS09XeWxwU3BwU3V6cHNEcStFcnRYTGZR?=
 =?utf-8?B?dW5XYjFneFdHbnh2TG1rcTdKcXk3cm5FZzA5WVJWaEE4d0s2OGdCWkw2K1BN?=
 =?utf-8?B?bHhoUVJyamZVQVRkbFgrSUtTZlVyeSs3d0pLeUhEb2ppUWxQSEM4RklSUFRE?=
 =?utf-8?B?S2sxNGwxa1hqT2JyYk1ITHZoREI5QVQ4NUIyem5hNUxRWTZjNzRFSWlYdGo3?=
 =?utf-8?B?a09mcDJZOElCZnk2eVlhWG0wbUpnNXhIRFVjVmthRHQvcVMrRG05b3hIR0c5?=
 =?utf-8?B?YVdJU0dvVURwbklIOGIvaUhKd0QvOTdBblc5OUJxTGJrSXlzOTdodzQ1S1B4?=
 =?utf-8?B?YytGZlV3b0w1MkJvTzl2S0ZhZ0tyVlFITGtGZkhqS3U5NmkwRDdoQnZObGhV?=
 =?utf-8?B?VFdEcGVKdmNMdkVhME14dzNrUnNJdDRkZ1BuZHdobHVrYWFyNnh1VmJzcXBo?=
 =?utf-8?B?V0lVR3RLc1FCREFSTTdjYXJuNEFQY1JtMzlGSlFmUmR1UCtLSS9aTERaMC9C?=
 =?utf-8?B?NC9rMzRUMElmODZONVdVYkU2VmpXbHI3T1EzeDdseTVrL1pHcXk1SzZLbmVs?=
 =?utf-8?B?TTRGbHB2U2s4U0dhV1hOZzJhdGNCdkx4RGFjdGI2YkdtdDBkVytLRU9FRWY2?=
 =?utf-8?B?b1E1SEVWbnhGMDdQWFB4Zmt2SzJXU2ZESXIyWi9vRDdxUWllcXZjZ0tKR3l2?=
 =?utf-8?B?aXpVRHhkVGxYOWUvNkF3OE1sT0gzZHFOc05yYm9aNitqZmVGcWFaNjZEMkc1?=
 =?utf-8?B?YnhnYTJBSmdGajZQdjV3Z2hKbVNwYWlpNE9tQ2lFcjlQdFBvWCsvUytDS1lG?=
 =?utf-8?B?QmdDeFJjNEtmbGZTKzZ2UkpaTlpMRk9YZGY3Y0pIS1ZEOTdRbHFtOTFQTTI3?=
 =?utf-8?B?K1RibDZoVkhmV1BNYWQ0K3VtUUVPN1o1NjJodllWaE44S3FKYzNSRFU4K1Y4?=
 =?utf-8?B?TnZJSEVESUxFSjh3cjhwV0RjbytQcXFubEkzOHdQVVlXb3NZazdBeU1LTE82?=
 =?utf-8?B?NkxndTZIZGMvWXBrdUphdUFHYjZ4dzJ3SE15K21OSEZSQWZmK1UxbUVvUUdV?=
 =?utf-8?B?WmJZWjlGT3VDZEpxRzAwbGV5NDQvZUM2bi9KdU5FRVBycUFNRGVLS1pPS054?=
 =?utf-8?B?T2tKQ0RveGEreFVvL1h0Ni9sNDlGY1RCTHlpekhvaUprV0o2Z09RbzZvQmY1?=
 =?utf-8?B?MVYzcmM2NDRuTkhhbTljUVltMnVScHlKUTBUYm4vN21aYjVUTFZJaUI5UVBm?=
 =?utf-8?B?aFArQjgyd2VkMk81S0R4bVhFbGNxaUp4dWVURlVxTFFGZnMrcE9TTWNrK25B?=
 =?utf-8?B?cGRzaTNLc3BCNkhBNVB1RUdZRExrRkVOWWZZekpsMmQweFE1ZzNQUUEvUVVm?=
 =?utf-8?B?dEhjZTBUUk5nK005M20waVlFUnUxU09CemROek5ocC9iMzZOZVRDVFdFK2ZL?=
 =?utf-8?B?YnAvOU9iTVR1ZjdsS0FDaU51b1dJWmpIZGpRaUFXS3F5em85NWQzV0xRQU0w?=
 =?utf-8?B?V3ZVNWFrZDVKbEtScGs2aW1Ic2ZyRGxFYURqcEdQMldLS1N4dzQvMzk4eE40?=
 =?utf-8?B?TDl0c245allkc3RJOVUyT2d1VmhubEIzWVgrM0JKWlVPL29POTFYSlNoc3dG?=
 =?utf-8?B?NFIxRkpueGNNN0xEN29DUmZWc1VTNStlNDlUR3ZxTTNRbjlIeTZJOTROc3dx?=
 =?utf-8?B?bzZzVTYzS1pVQnVBbTQwVnAzb09wYlFsRkxkZ2JlMlpYMFZCYzhFZVNSS2RQ?=
 =?utf-8?B?YWpkdkxmNDBmNnYzWXhHYnVmYjJtS3JwVkg3dGt1cUh3R2pwK295dkJtTHVs?=
 =?utf-8?B?cUo1UnFrczJmMnB0N2ErckFGV2pTK2RrVkYvK055MFV1bVFCSHdWZUJoKzZ6?=
 =?utf-8?B?ZVVFZ2l5YThrSllBNmVrTmxhbGZPbVRNV1o5TmZTVVdKakNFSG5FTEYxVW9B?=
 =?utf-8?B?RGRHWkRLd2xKN2FHc3pmMHdJMG80MjFvL1hRcXFVMzY4cVByeHNjbFZNaDRG?=
 =?utf-8?B?WnorWjBzdnE3WjFKenJGRWhtVTBTcGk1TzRlWmh2enMydDVVWkEySDJXaWE0?=
 =?utf-8?Q?VkNkiQMiqjEijOpqXtFC3A4lc?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	mHRh21AcrluC47MJj0COUkq98dOGglb7FMPAYpZ2kBL8Zxl+ohe0go+reizgetPXGufDrzQmpwXO3q3s3tj3ZuyjErwOBkA6u3IAp3ouMSpn7dXfgnGeBDLjeIPz0hWXciCRxAyZC7H+m1m8KXpNQX82aunzdC/QkAZZcpBjqzmhr9j3lquCTpX+hqV5hvYwDejUiWeodRTKy1J89N0nXes6GC3KsPThBwpvwkYd725hvD10FF0yjyOgYs2bzluzvXQVF0AN6I3p6Ml6EcoA8o1F7B3pcgeM3JSeT+d6IEbEyiXx5lOy3KUhw+87jlcA8BlW4a10OSlEQiF4/9zAHg+gosusRNbmbcbppYBN1QT1q7AEcY1JmAOYmMAQrjszuAJKVTC5SPUE2KnH4YdqzYBphAJL2JEztvK3sYXahNR5CVy4B/Nly4VAc9kp30qwno0ltAcPstoWRL9gJrCBUgCtHRlOpe1vRc+88GdeWue/0QgtO1OBJkWHJxC4lm2Uv2F1WjLmmHBJfcXPgWRNs3DtoQHaRLXRyvLRLHqsJHJDcznd6OdcfQQuX91axJgXr4Ao0qLmuUcmd/RL92fX71d6g9EurIarT3metY2Z8wI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf10e31-77e6-4e42-bfeb-08dc53fb91da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 16:31:53.0895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2iJiOCrB7gy84kbYTTDNq6yhcmU9WvmTxwABRURUlyPTczMCFbfkt/GrhJddzQDVtcBaCkBCsD48hbvmZtJjiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6638
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-03_16,2024-04-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404030112
X-Proofpoint-GUID: GUTheJ1fA9sP_YoKBIkpMeerG47H4ASr
X-Proofpoint-ORIG-GUID: GUTheJ1fA9sP_YoKBIkpMeerG47H4ASr

On 03/04/2024 00:28, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we are near ENOSPC and don't have enough free
> space for an args->maxlen allocation, xfs_alloc_space_available()
> will trim args->maxlen to equal the available space. However, this
> function has only checked that there is enough contiguous free space
> for an aligned args->minlen allocation to succeed. Hence there is no
> guarantee that an args->maxlen allocation will succeed, nor that the
> available space will allow for correct alignment of an args->maxlen
> allocation.
> 
> Further, by trimming args->maxlen arbitrarily, it breaks an
> assumption made in xfs_alloc_fix_len() that if the caller wants
> aligned allocation, then args->maxlen will be set to an aligned
> value. It then skips the tail alignment and so we end up with
> extents that aren't aligned to extent size hint boundaries as we
> approach ENOSPC.
> 
> To avoid this problem, don't reduce args->maxlen by some random,
> arbitrary amount. If args->maxlen is too large for the available
> space, reduce the allocation to a minlen allocation as we know we
> have contiguous free space available for this to succeed and always
> be correctly aligned.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This change seems to cause or at least expose a problem for me - I say 
that because it is the only difference to what I already had from 
https://lore.kernel.org/linux-xfs/ZeeaKrmVEkcXYjbK@dread.disaster.area/T/#me7abe09fe85292ca880f169a4af651eac5ed1424 
and the xfs_alloc_fix_len() fix.

With forcealign extsize=64KB, when I write to the end of a file I get 2x 
new extents, both of which are not a multiple of 64KB in size. Note that 
I am including 
https://lore.kernel.org/linux-xfs/20240304130428.13026-7-john.g.garry@oracle.com/, 
but I don't think it makes a difference.

Before:
  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
    0: [0..383]:        73216..73599      0 (73216..73599)     384
    1: [384..511]:      70528..70655      0 (70528..70655)     128

After:
  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
    0: [0..383]:        73216..73599      0 (73216..73599)     384
    1: [384..511]:      70528..70655      0 (70528..70655)     128
    2: [512..751]:      30336..30575      0 (30336..30575)     240
    3: [752..767]:      48256..48271      0 (48256..48271)      16

> ---
>   fs/xfs/libxfs/xfs_alloc.c | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 9da52e92172a..215265e0f68f 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2411,14 +2411,23 @@ xfs_alloc_space_available(
>   	if (available < (int)max(args->total, alloc_len))
>   		return false;
>   
> +	if (flags & XFS_ALLOC_FLAG_CHECK)
> +		return true;
> +
>   	/*
> -	 * Clamp maxlen to the amount of free space available for the actual
> -	 * extent allocation.
> +	 * If we can't do a maxlen allocation, then we must reduce the size of
> +	 * the allocation to match the available free space. We know how big
> +	 * the largest contiguous free space we can allocate is, so that's our
> +	 * upper bound. However, we don't exaclty know what alignment/siz > +	 * constraints have been placed on the allocation, so we can't
> +	 * arbitrarily select some new max size. Hence make this a minlen
> +	 * allocation as we know that will definitely succeed and match the
> +	 * callers alignment constraints.
>   	 */
> -	if (available < (int)args->maxlen && !(flags & XFS_ALLOC_FLAG_CHECK)) {
> -		args->maxlen = available;
> +	alloc_len = args->maxlen + (args->alignment - 1) + args->minalignslop;

I added some kernel logs to assist debugging, and if I am reading them 
correctly, for ext #2 allocation we had at this point:

longest = 46, alloc_len = 47, args->minlen=30, maxlen=32, alignslop=0 
available=392; longest < alloc_len, so we set args->maxlen = 
args->minlen (= 30)

For ext3:
longest = 32, alloc_len = 17, args->minlen=2, args->maxlen=2, 
alignslop=0, available=362; longest > alloc_len, so do nothing

> +	if (longest < alloc_len) {
> +		args->maxlen = args->minlen;
>   		ASSERT(args->maxlen > 0);
> -		ASSERT(args->maxlen >= args->minlen);
>   	}
>   
>   	return true;

