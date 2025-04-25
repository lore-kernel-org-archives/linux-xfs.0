Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4075248879
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745591076; cv=fail; b=sdBvUvTEfqHQ0UYgsCISR2vLIynA/wFITNIvkYpyns9RZmGK3tQDysgRYwPe+amTKqJe7f3ERLuAlqY6OdALa3tdBndmbWzr5IKfUQoJU39kFNX3cxvoBFRy++WNTirv5Sf6wJYuUQOpWZWmcli3KYUG2p4CzganwfKeYTrLfF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745591076; c=relaxed/simple;
	bh=5JK8Js1pHpQXaXaI6zTS0tGInyEqNTZhivn3PWnT8vk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S5bkd6pJIQRiJQqZXYEM/wCy1HyRc0WsrhOO06dsZ9DUcapT5ArCC799KtDWXLyLzAn7JFOxF38wz5MXEeg8MyKNcSBjdZ0snK0uYmVrKnJwVK1aqMGpuNrq6YwBTdNMlr1/HdNuVdI9Yfri3NF8TXIfcEM9YQjwreFgC8tTc/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eKY79DcG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EPvdvzxC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eKY79DcG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EPvdvzxC"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53PEG7w4022724;
	Fri, 25 Apr 2025 14:24:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=R7lX5xwUccpF5EPeXmr4KiHQt9gDpLakSzuk9L1rlRM=; b=
	eKY79DcGInYavJn53wr5y2SIzaa1wc3nw6QkE7hOMCsEOJjT8uF0pNtK8LUrNttd
	Ll46khCaISIgLaswMt/JaF2nLAo98O74io49XFfCu+7pMjikKfBimBN6VHDm1BBp
	50XEwPerL9Keub2XjycXUBWfc6sGTyJcH2sCKzNy00OPRcuoY0skG19TMOgFIfNM
	cmk9PSoxNHNgEHccQQBOJOJ62xAI8uBhAlPSeAAP5eD091hiezjm5K7tkAHIG2SL
	TLW4ISGYQXB6nN1qxH/A+m7Hq/gI5cso6FUuda7bzqwHLwoVCPHEXI/w3PApT5Ou
	GPz2pSGvD7BKqgus5WNyxg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 468bs182nq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 14:24:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53PDOkdO013866;
	Fri, 25 Apr 2025 14:24:30 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazlp17010004.outbound.protection.outlook.com [40.93.11.4])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 466jxrq101-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 14:24:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZexL2CH5755KrpJgWpOyxQhN3pNC4Hs1bVuwkrtYVB6+Ejh7Z+amAkfdbBKftjvCj3MNiw0XOOpnZt6c0WbykQRLH4Jln0cFKJuv5c0XXtu4Uu9gni3ArT1/Vy3y76J1b1TWRyPeiT3WNOQVOVUJP5adgsWUk0EPkk4MR9so6J06bG1EG9dPreF/NhlLFcPsOykYm2jACgtBsPz5jvDa3vFmJzxh0lC7BC0a71j39JwkoFDPAzHsxy6uzkLB5uGekBIJAue+cHnAGM1a9PABThqZKiMHqZPNA9NYXfqNKLahC2X/suFXlCRMkumUba/Ng23gHXq35x7rwNSdf4umNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7lX5xwUccpF5EPeXmr4KiHQt9gDpLakSzuk9L1rlRM=;
 b=qSNkeDojERUzWJM3Q6VX2x1PXlM+qEfgCjOPKmtYS0Tk7AlFJrPXQUSsozcFqNSNcFiVe2Ha2rFypQ4HJM2XIXy2R0H46wVJYbZGIFBHwq8BPfJ3QDsLSBQkKujAU6bED7Eh8wkkmzcRNJqD89hwPlRGErulJmLcSof50ESLy555fiLUfqTBIW0W1z1Xgi8Uv6vK+5qRx7W0dfSDraObLH1cmnNrb1t1+QjMfpxrYghCoDUzlL+exLM4lnCF3iwQvJmzTA6G85uRiX07qnBvR1/AGdOzNtfv80oHtNTdL5c2uOST9kIEwMBP+w7CMMT1/c1sKbrIV++yB4985SUiAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7lX5xwUccpF5EPeXmr4KiHQt9gDpLakSzuk9L1rlRM=;
 b=EPvdvzxC0pMAAbnVvfq1Cqo5LWAezEM38XgNLd9k0FS0V6reLnvF7boYgkemvhTjKf/1bOtUGugl5pyaIEGfzW85YV4jhOIs9vwit8FCwhnWt521HWO0te2JLG2NHtvOG2NyPmCXx0554LswDs1pFAk5rlDQrH7my2O17oY6b8c=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5087.namprd10.prod.outlook.com (2603:10b6:5:3b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.26; Fri, 25 Apr
 2025 14:24:27 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 14:24:27 +0000
Message-ID: <20b76444-4693-40a5-93ae-a353d5f96c95@oracle.com>
Date: Fri, 25 Apr 2025 15:24:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] xfs_io: redefine what statx -m all does
To: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
 <174553149374.1175632.14342104810810203344.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <174553149374.1175632.14342104810810203344.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0155.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5087:EE_
X-MS-Office365-Filtering-Correlation-Id: c75a2492-d84b-4928-c6fa-08dd8404e2ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V3VRRDUwUzVFbFpaMW85K1l4RXcyM2RpdUVvdkQvSzd6b2hWSDJPNzd1WnBx?=
 =?utf-8?B?RG5GMEpqZmtYYmtPeTdnWFNQMkl4eEE5Y0F5cndyaHllM1JYZEw1RkVER3hZ?=
 =?utf-8?B?K0pxb014R2JBMUJhb0hEUnJyY1ZGa1ZrZWY5WHg2N3paUzJDQW5tQXRlSC9o?=
 =?utf-8?B?ZXBzQUhXb2gwdU1nSVptWDBIa3c0VlkvMGI3c1h3ZjJsMHFLN0huZmZ1dlJ2?=
 =?utf-8?B?eWlndGJNWk54bkt0ZTlZcm52b0w3dWExYWR3MHl4a29TL2xmMWZJRFRnTllR?=
 =?utf-8?B?UXJ0Nm1lUTM4MDhwNEcwdnkzdHBNNDZjd2t0dTZhQ2R6RFZZcFpXdHB5TkRH?=
 =?utf-8?B?TEpkU0VzdldQNXdSNzNLQTRrZ3ZYdTQycTFqSUZvTmJCbzlnWkRBU0lsVkN1?=
 =?utf-8?B?NmtGclhtRWRmOU5wNTBLa1dEcm5Vd3A4azlGNDV3WmRSVGNKQi9LVjBFUlZ1?=
 =?utf-8?B?Y1MzUmd5dXlCN1NCdEpvRHVHc0k4M2tVM1RLdW91ckpYZm9DbzYvUmFJdHdv?=
 =?utf-8?B?WnpQaU1kVVg2T3NMT0pObnV1R1NiUjJJS1Bnem52WFY2YjRuRE8wUkJvYTVq?=
 =?utf-8?B?UDJRYWt0ZklzeEtTK1dpMGJDa0FpM1F0aDM1TEpXT3UxeC9PdUJTRmJQb3ZO?=
 =?utf-8?B?VW5WN2MvUWhjd2VkVW1KNVJNbVkxN2NYYTk4UVJwb014TExoYUpuaElmQzZi?=
 =?utf-8?B?NDFuRi9pb3g2cFVFMnNaeG95amNqdUNNNXBIeXduSkU0eUNycmhoc3gxVC9m?=
 =?utf-8?B?ZUlYVHU0RE1kSGR1TE9KTm5vNFBwTm8yT01sc04vUnVWenlxa0hGTlNwMDhI?=
 =?utf-8?B?N3orWVJvVWJ4NXdjNDZGVFJ5S2xMclNFZ3A2RTByTEp4TUg5VGRWV3h2amlu?=
 =?utf-8?B?RGNuUTBCTEdvaUNqck01ZlRzaWVRRTQ3YlUzS1F5MmZrVmI0dkgvR0JLS0JP?=
 =?utf-8?B?N002SnpXcjRyT0JtclBjblRMN3lQQ0pLTUZkZUpWalhLQjdDRWtickkvY3Ir?=
 =?utf-8?B?bmZvVVpDeVJlV21xYkFqdHhZcGZOeHh4czlIL1F2WHF0N3ZhN21VMHgyajV3?=
 =?utf-8?B?eFJEamozL2ovcWZKbDQzWk03RElPNE9ZUlVsYk56RkxoNUtiS2pYVTNKbTgr?=
 =?utf-8?B?ajQ1RXRTeXlPSU5lRFJlL2J2M3k0ZmVyLzJmVzdPYmFTbXdjREIxY1hIbjFp?=
 =?utf-8?B?ODJ2bnkwKzRpOFRnd0ZjM0s5OFJScVBYVnNFanBRTTNlVW51LzZXZVp5b2ZG?=
 =?utf-8?B?c3I5WVZoU0dvczdtTGNxejRJUDQvejNteVZ2VjN0WGFUWmNVVXpmUjR6b3FG?=
 =?utf-8?B?RGJXZFk4NlFOOWlmek53b3FZVUErNGVRTGZweERRRHdVMzFuTzZVTnc4ZmRE?=
 =?utf-8?B?RE5ibythamVNVjlPY3BVdnJEVWhja3N3OXFqZ0I3M3EzL0JrbHVQKzdOMjJE?=
 =?utf-8?B?eTRxVzNKNGVIWURqUU5ocGVFNlpqUTZ0VEtmRDltVkE0YWN5dTlOZnUrcTRU?=
 =?utf-8?B?cmVPcnhFblQwMFFZZCt4YlhuWmkrNE9lb1dzY3MrdEFJNjF1UFJhRXo0ZTg4?=
 =?utf-8?B?WTlPZ0phNE1QVDJMaDc1YnVsaFRRdHdMcWlVTHVXdDBranJxNDlIMXUwS1Zi?=
 =?utf-8?B?MjdtL3IzMGtENmFYamtTeEVTUGQ5Wi9KbFVsRndwY1E2R293OVQyN2h1bHhR?=
 =?utf-8?B?YkhDUHduUmw2dUwvNVVHaXVnYUFnYnFWNWxLTHNRYWx2eWk2ZTIrc3V0b0I3?=
 =?utf-8?B?TTREL0lDZW4zVmJzR2JxZ1MxckNoR0FuYkhLNG9zNUtDdG9qT1BJNEdpTm9V?=
 =?utf-8?B?NkgwM3RpK05ueHB2SGNvVzVoRmV2ZlVPakFTVEd3c0RFVmpQakREZzZyeHFZ?=
 =?utf-8?B?YmRPQ3lFSTRpN1MzZmg3R2VWNDR4cWdkWUN0RTU2NFhvLzBSRkZPVklBYzRq?=
 =?utf-8?Q?cIOvnfF9Sm4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2REM0xPdVZwOTdMc0FWTGV1UGliRFV3VFpwc3U2bUN2Yy9aZzdSZjFzQWVZ?=
 =?utf-8?B?WThLeDlBQ0Rpb1VnaUVPamJoS0hiVktsa1F6NXdVcGJWUGZqVlQvYUdFc3Bi?=
 =?utf-8?B?WGcvNm81R0syMHdhZHJkbUJrMzFwTzUxOUkrSmU4b3MrYWx6SEFhYmoyVGd5?=
 =?utf-8?B?bHVabDA2Y0xEVjBhbFJCZERzbVVDdjhJUGF0TWFRRGFmbmNCOFlwY3AxNklB?=
 =?utf-8?B?dldJQll1OXNFVXViK0ZLQ1pkS3Q2VTd3Qm91ekxobEU0T0ZaMjNjMHNYcHkw?=
 =?utf-8?B?ZitEdHY5SzE4QlFuL2E1Vjl6VDYzZVdQOGV2R005ZndyWVE5SVo1RmZOY1Y2?=
 =?utf-8?B?NnY5Z3JscTAyZ1VGalhXQXlpSTM4bm55Ni9GQnc3UVFQaStEV01HL3ZjbTEw?=
 =?utf-8?B?U2dZMzBZcGFjMmFFaHJEUTFIaVhMRlhkQ25XYnN0Q2hVSlpyMWdqaWZQTmV3?=
 =?utf-8?B?NzVRQlhOTXFnK3pyWmo2TU4vdFJwRjRGek4zZXROT2RqdHFma1ZlN1RrVElN?=
 =?utf-8?B?SXZsWndNMnplNmU5b2Z5R0FCZ2UzRXBQaWFPdFU5UERHdlpIY2pqYnhXdXA5?=
 =?utf-8?B?UUQ5Yk1yQ01zTG1KUnRMaXJCVDJ2THBub2lvOE10L3FjdFdLeFVTRWxSQ1Bp?=
 =?utf-8?B?VlZNRG9yYzc0M2JKaFJTcWl3M1BJTjhVdDhlQXlJMG1acEpyRGJOYWJWL0Vy?=
 =?utf-8?B?a2ZvczBwbnlBQ2VCbFowNlVHVFZWK3dmZC9xc3BkbkxvZUVjK1ZxcWZXMVJa?=
 =?utf-8?B?U2dyQ01IdGU0M09EYkhIWEEvWm5Sem1BelhwT0VjcWIxZW9NNDJ1OXVXdXpS?=
 =?utf-8?B?Szd3dHVWcXM3YVg5MERsbE1tY2RzM1FZQXV6c3pvZHc1eXNBaDk3QWZRdHYz?=
 =?utf-8?B?bGhLbjJPLzFLQmJmRmxoaERNWGRTdnFQdHpPZVNtVFZEazRnalRlazR1SkV4?=
 =?utf-8?B?bHR1U2hNb0hhSklmYWZubU1RZzRnOW1hM215T01TU29Kb0UxSXYvL2QvSlJX?=
 =?utf-8?B?OGVPeWF5Vml6OUR4N01VVUpyd1VNU1BDZjBzSDBmZG1uekZZT2ppdk5sK0pi?=
 =?utf-8?B?aGNHWUh0NjI3MkV0bW5WUmlXTlRCWUNYVDJwb3V1cXFFT0luekhjeHY3azl5?=
 =?utf-8?B?NnZQT1dkNFZHK3ltUi9xR0lycWp6QlptbEw4NjZ1WkZIbUVsZ25QT25STUZ3?=
 =?utf-8?B?Z1oyWjdWUlF6b2txZkN3TTF2bERZRTI1SWRPZXg1VWtUWndGTWFxQ0hoS2ZW?=
 =?utf-8?B?N0ErTlBUTUFxOGUrMnMrNU9zL3BZSTNIMXpGWWdDOUkwVlVlZncyeFZndnNH?=
 =?utf-8?B?dEhVYjdwNC9iNi9sSEpVQVljb3V0QUlEcVc1eTZIUXFuUlIvNkd5MmdLcW1Q?=
 =?utf-8?B?d3BrUU1kMG0zRVVLVDhvNjlWVTdyek9EMkd1Z1V2SGxxOG82M28xeS9iYXk4?=
 =?utf-8?B?TWMrTXc3ZXFHT1FSS2g2YkI4bm50TW8xWjhVeGFTS0F6S3dTb0d4K1REVU14?=
 =?utf-8?B?Y3k4RllsK1NaYlpuSTYxMHU5U29KbXp6M0ExTUJuNXQ3V3h5dXI0a3ArcENO?=
 =?utf-8?B?VlVnK2crNEFCWEU4Tk04UWwxY21BdDVXaXBNanVhcXhhZk9GQlp4VkxJSXpS?=
 =?utf-8?B?NDd5WmdBWWU0RXdPd3dmbTlNRzlWb0tOQmRxamRaRC9pRlRkSFJ6VzEvcWlv?=
 =?utf-8?B?azVnWXpnTE5EcXloK1JKRmRQZ3JaVW5QWTNLNmp0SFhHdzdPTjYzeWE2cGNZ?=
 =?utf-8?B?bmpLS1RIa0l6VW42cEtqZXNZVzdpMnpnY0hZMEVjMVdFalIzY0JMcmppam1T?=
 =?utf-8?B?KzM3dEdlS2h6SXJLREduU3JTc0kxNE1WRk1zOHhVdVNVVVpPSGwyVndkOUUx?=
 =?utf-8?B?VzV3ZkpaSm5JdDNsM09XWTJucURJemVOeEhVczR0dDcrczdML0lFNVRvVmkr?=
 =?utf-8?B?aThmbG9SR2MzemFmaE0zK1hBb2IxbGRtTnUveEdjWEJXUmQ4N1lmbkJLR0tM?=
 =?utf-8?B?VkloYVlOYUJzKzRJazBuTU8xSGZmKzM0YmwzVkZ2b2ZWcEdpdE1ZSGV0VHJo?=
 =?utf-8?B?bHQyN2lzVzVsa0NMWk81UHVTd1FrazdWYTNSOThBQUxvbUpHRERVWmRBK3VB?=
 =?utf-8?Q?2fovtBL74pzP0IE2Q8i/OrVbM?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i13cmL3S8+RQBBGHGcMXLpTdd4A/qsj/9h4hsM2ROFpxzpfUJigFHJx7hGpvKYRnFvhZl9a4rurJ3HPrBn2W1QZzqeWLEWgw6dPinwIH9kexKkK5TI6lzW0DZRjoCknxrGL6AGY6WSVvXEQknOppFd1QClJ6vHC0ah2Hvep8Se+cRHsTF+lKk4FInfT2GlLhXvbWbGoSurSAINalbZQPpa6bD8uw50JlzNnnPhD9OkjJAKMLK18js6SvWX4ibJYblGaYpfF42ygDj+DWWIBx9iN20zFWlWVEGRSKfz5x8Khedx1CmFCXnYCV5xvOViWKTQ4FilJ0mt35gSCgu7mgn/Qh5rtXVN9RUUMej58sSqDyBqB4UKTVVJPIub+OclxE6n+8QPkhjnQMzSepcdaaOz/Uz8wDjOisV4GnVm+/LnoY2qR0iNxj+9o3UUK0YCa0rtWNj1cSoWyafIUS7gbWKjU+Zp8Yzh6YvV0qyxAtk9BwVTF0IW/TeOM8c2hZy3FAfQga3eoa2QvZjKcUGjhAqJoEAX3PCCTGsCwdwmoZ9zVWl2mkj0wnfJ9Yg7RobVNH7yXrBrz4i7kMBf2WOvqKYl8GPFCMZiYDmWReYdTWLZo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c75a2492-d84b-4928-c6fa-08dd8404e2ba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 14:24:27.7632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TETU2CylgJK+nSvYSVf7SXn84S20E043/EWuJv9I23TnDDpXifgIgGzv8NfBzdOfVFDPdxktC6Ews87gXa3bHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-25_04,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504250102
X-Proofpoint-GUID: A5CWn7hPEh0b4k3RfftishuNIO4ABqSy
X-Proofpoint-ORIG-GUID: A5CWn7hPEh0b4k3RfftishuNIO4ABqSy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI1MDEwMiBTYWx0ZWRfX2P5ABrwB+hh7 CxhymljXFYdXqtP+Ciqvgs3NF9Isi9+3zxy9/1a+IhjdNoNaZFeNqFDlIkQq8K31yT1ahR7HRf+ r83g2SUsVrhHaYNgthP4tf+vUDheeh+v6XL5aDe66EuzPBq3lissXToXu0k62UbepF3XHj9+o9e
 sM4dC/F+9H74CnwwJGDW43nxn+7JevmjD72A8jIWX8o/yPyB6IWW7QO7Ha6RaqD8hSNjtxgdSMk YWqAb9IDQUAPCpy1Z6VjaCuZq8aEoOBI8rODiPIPWbUnuMh965vQhfiLeNp1whJI0//ml9Sbkz2 jj7pIgijFZSck7kMy2L9BmkJT1TdeHGB7xgsQfEG62da7vFcTjPXW/HtzObAX4bm/TKUwB3fGmd +mwA8EUr

On 24/04/2025 22:53, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As of kernel commit 581701b7efd60b ("uapi: deprecate STATX_ALL"),
> STATX_ALL is deprecated and has been withdrawn from the kernel codebase.
> The symbol still exists for userspace to avoid compilation breakage, but
> we're all suppose to stop using it.
> 
> Therefore, redefine statx -m all to set all the bits except for the
> reserved bit since it's pretty silly that "all" doesn't actually get you
> all the fields.
> 
> Update the STATX_ALL definition in io/statx.h so people stop using it.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

FWIW:
Reviewed-by: John Garry <john.g.garry@oracle.com>


