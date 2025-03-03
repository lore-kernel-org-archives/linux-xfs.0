Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5E113FEE
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 13:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741007234; cv=fail; b=vDySL/o4RnKwQA6JAzvGyweTVIKtLPbtH2h32IvMQl+8r964VKxMFNqWoeGgkXi/EBnYl+JODsn7TS4ertVwDhi5b4etIkgW3aq0qs9xq+3owM84FXWOHfgyBncBgePaGeGiWfaElsrJmPXFgiz5mUi0RBbZKQ9IZLaz4a5FNiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741007234; c=relaxed/simple;
	bh=tvwsaNhSxuhl5RslgWouKGcKu7ClYDnHZMafKTPSftg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kcJqy/PA6yi4KtCoPvVZd8VWVTUqz8u5NR7OKgWkDB7XJdheOKOpgkYv3o9GQFABBCgfp6v8ft1dp4iuocJ09o5FPTDXM3lzE2fyB9TUzWo2Fq+K7Lmmvay1S1hkyY7CDjs6k2el6Xks5vvp4bye0Cqm8iZg1quPZcrKUjjv/6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PD19HkAT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T9c6sKCk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PD19HkAT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T9c6sKCk"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5237teHW029949;
	Mon, 3 Mar 2025 13:07:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=tZw/KC4T01MdKzserbyVPi02CEJGYvj4ZyTmKEf7CW0=; b=
	PD19HkAT8UtEvh6RfU7AoXxFzwboM0ccG2micbPn9C5kZ+efkUqh34yO3npdslD7
	gS+jSUoWE4co6qwNe+vAgjDH8hJyVAZIJpAX0QO3MEMgTlbH4I10WiQ4wTPdNEob
	pVNRoX6u2JVL2NQpnFTab3cD3Uwevv2NPTPY91K8YP3SprEiRK0q0UR6PHmaq0zG
	lEul/z3hPZxg33cCfY0FoVlAEmOf4ReRoIWvMGSpxUcnoC4DWg+39v0OYoDRS1EO
	rui46FtK24OU0509DBm3cQlwQbvW93TYnNMGi/4BmbtWy88qmyHY8lh9OcfPJrPK
	5ZDG+AcMUtwILixEC9rPaQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u86jmbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Mar 2025 13:07:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 523Bu0Vc003232;
	Mon, 3 Mar 2025 13:07:08 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rp7fc83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Mar 2025 13:07:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PCEsf37Vetrtq38FeIeW0esBQ+1fxSgV5zkFb/AnmHR4zqY95bXuCj+j96RwsT92wWjaOLlhrapQ3s923rAPSOJd87vGje/3DRBW+8KrwKLCEjvNtIMu1KOQx5nidq1GLKweklZnxCheKSE2R9JHKzDrwQLbtbxmDJA2VDRQFqGR2y9evyYipmXpyqXCkfryyrrjovhvjv1JTrtwJG5NT2iGPYNF6tEBUyLH1eDCYaFeWOukW3Neqnvam12rlpDdwZSOGJBdAF6M5U0ZQaO1Rj/7yto+UdY2Badh//qKh/nyIhbcNIVUiBMbyttpzSsvGlUkLWvw889GEFCIduzJWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZw/KC4T01MdKzserbyVPi02CEJGYvj4ZyTmKEf7CW0=;
 b=vEQvfbSdsLOX9lFqr44Lez5uo0q7NbZxCADTioviGRKnFbKWxrdXVygNaGkvCd50NljNlqpWx3xcYVSxozL83xW4LKhySPomP6Px636MluH7hvMam0J9sfl+J+wdcxCdsx+KFQdhfemdMG118QuWyeDWmiU3Q2/nji5xuTktNImf8mfyfFUmksLYYiVjpeEFtk2vUOL6qdjZjX1QNoK9QEmfBE5yC5r0+jFmh1K+jXW6FcDi02/ViFFjF0Ofsi/zQHW3YACcfB5/y3rMnbob11lZGocm73HezH7RaT9TdHwA3GCeKbuhrK9NI91AHjXIzT/cFOTEih1qu5gTvTTp+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZw/KC4T01MdKzserbyVPi02CEJGYvj4ZyTmKEf7CW0=;
 b=T9c6sKCkPf1wNbMn7fxJ8eQulCmDZUTlIKhd+1fCWk10qporeCCIQpHXqhKMRdet5DwMjKtUXqUyztJsTIHUSbN5UxwCULlybG5A2E2XfPK/5lCX4IJZLfGO8uCvhhrbLn/LGjqAmVTA4Esla91nwxdbXMCj6GwPGOoCZDqQJQc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4880.namprd10.prod.outlook.com (2603:10b6:5:3ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Mon, 3 Mar
 2025 13:07:06 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8489.028; Mon, 3 Mar 2025
 13:07:06 +0000
Message-ID: <d01de90f-eecd-4dcb-b1e1-e778bf9fc833@oracle.com>
Date: Mon, 3 Mar 2025 13:07:02 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iomap: make buffered writes work with RWF_DONTCACHE
To: Jens Axboe <axboe@kernel.dk>, cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
References: <20250204184047.356762-1-axboe@kernel.dk>
 <20250204184047.356762-2-axboe@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250204184047.356762-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0012.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4880:EE_
X-MS-Office365-Filtering-Correlation-Id: 27829020-c427-4c38-b40f-08dd5a544c0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VXIyZ0lUbnF3anpGK0RiS2ZFeUEwL0tHV3dPTXhiY2EydEJvTDQvZmdCbjBx?=
 =?utf-8?B?MUJZYTFGV3daY3ZEMHlNbE1memZwS0JtZWxJK1ZZNHZsTUZIZ2dvdy9BZnNm?=
 =?utf-8?B?T0VEVEtjQ2pFSGR3VmtHbkx1cXdZNmxldUpldVVPWXBUR3dGanpMRjdtMTEz?=
 =?utf-8?B?b0RPc1JhR0M2Z1JsTXc3ajQwaXA2Y2FGWWtpL2ZTSmI2dzNnYnhlRkp1NzVa?=
 =?utf-8?B?dnBBSm1waTBUZUJnd1FnbUcrSFhMZHdqSmxNUjZLRjZGZG1VTWZDMUNrWGFB?=
 =?utf-8?B?YlcwZlhTZzFjOGcwL3dFMHRLZ2tXZHhvZ2hLT3Zlb3RITVVXbkpLSHk1U1Jm?=
 =?utf-8?B?YVc0VXRLWGpSTEJtaS9zZW4yMEJSaVBlVitmL0RFV2tNeHpneCtaTXYwUHBM?=
 =?utf-8?B?ZWpzNEJnZElHTE1JcFpmWEdSb3lEMnZSYmNma3EwUVNCYWVxM3l6NmtEamhO?=
 =?utf-8?B?cFZ6dWsrUlp6N21XdXVla3RLS1p4RzhIejJGaEsxMkpKc0xqek5EOUc0Sisv?=
 =?utf-8?B?Y2loUUNlaHlQaVhOVXpZRnpGNjFoNGNZNUsxV0JCMCtOaDhJOThKUjQrSWkx?=
 =?utf-8?B?RTlISzNncDVRUmZzcXBoUVhmK1FxeUxWM3dEKzNBUjVnU2JUM1BkM1JVZFAz?=
 =?utf-8?B?elVVRitBK3BySGZhNmtFenVOYjZHbUttMWVjMHNUQWJvb3lsVkpNY1Y4Vzd6?=
 =?utf-8?B?aWJaQnpoRjNwVWErZC8ySU8rbXR1SnBUMDVFdzVodGp1K0lUN3hnSUJkUFB1?=
 =?utf-8?B?WmNLa1Y4dXA4K0tCejRoOXZ0U1Q5MWdmOThHV0VPaHh4enZqb3FDeW9kK0Z5?=
 =?utf-8?B?cWphZU5EV25tajBlT1NBaTg0T3A5M2NENjJkSERLb3JWeEN4cHpwMTZHRzdw?=
 =?utf-8?B?ZE1Wc3pHSzJYczlsamx0dXRrdGoxQzBxT0R2dXVXWkxNSlBTY2l2dTdSTjkx?=
 =?utf-8?B?ZW5HZ04zbmtuSTFUY2x6bEpWUjBqaEM5VDVxSDJoaENkU29FY1I3MStsTEZn?=
 =?utf-8?B?Ky9lT2xGMUpxM0F0aW8wcGU0OERDL3NnclQ2TGtPdWVNWW1WWkJDQ0NHRnBw?=
 =?utf-8?B?K2lwODVqOXA4eElhRDN2Q1h5b2tJNk5sbjF2Ry80UE1kQ2ZJaHVVRExpbDFO?=
 =?utf-8?B?TUtYb0gyWUIrR2F2VWt6WmhmcGhhQTNkWnpSZE9SU0QzV09NWDhMMldVQlRG?=
 =?utf-8?B?UTNNS01VTVV2eG1ob3NmVmxpSThyczl2UWFUSjFpUUE2VmNlTnNua3N4WWNI?=
 =?utf-8?B?VWpiNzZ3cGFXT3d1ZGF6WjJ6dUQ2RnN2RnFBSjhyeWF3NHV2NzZpbmI1OW5m?=
 =?utf-8?B?NHBxcmI5eFpRbjNTWGpoUmE5TFBSUkY3c0ZvTlAyYWRDSld3a3lhN21RRE9G?=
 =?utf-8?B?Qm0rNEpBK2ZuNzlWZXdNV29kazN5TTBVZVdBTVJNQnhiY2dweEY4bEFTckli?=
 =?utf-8?B?ekt2Z2JPTStaeDV4MGl0d2hVeGQ4SGtrQlNXYnBxV09wZDVJQjNqYUIwS3hD?=
 =?utf-8?B?S3dYaXNWdWwxWGY2NGhmY0J6bXM5dlBxOWV4c3lzaEFOZ1gvMTUrNHN1cVhH?=
 =?utf-8?B?L1NjS2tLQ1lLdEExeTJ0TFVnNDJ3cml6UnlxeERaNEc2Y0Q1U3dSMzQrSlVE?=
 =?utf-8?B?eUd3U3d1MDN6SlJtWDlrd0JzSmdxNFUxVG8wbHZBQTV3TTdoSzdxZGNZQ0Z6?=
 =?utf-8?B?aFFzRTZqVXhwejhTaTRCUno1cEw2UFY4N1pmUklNdDV6aFhBYXpaaFhsVWpN?=
 =?utf-8?B?eGV4Z1FXRmo3MGNDeVBXNi9Tc0ExWHdJdy83UDFGdG9uZ2ttWUxSejlIUkEx?=
 =?utf-8?B?MzNBS1BZL05TVFpvczFnQm5ZM1pmTlFabTFlcSthSWtEWmwrbkRSQnM1dWZv?=
 =?utf-8?Q?ImvIHtqE2QUms?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVprckdaa1M4VUg1WnVWajFoRXMvRkk3ZTVwbDUya2JwcmQ3UHE4S3gweThl?=
 =?utf-8?B?WWZDNWlOWkRqMjhSQWZVLysrRGo0ZmdWWjI1VE4xYlU0TEtxKzVIR3lBb1Ju?=
 =?utf-8?B?SFJtQnZPRU1iaFVUSjdzeGhKTGZ3SUQrWkhHNmlETmFCbE5MNXovcU5hSWtV?=
 =?utf-8?B?emg0bVdzL09yejBiYmo4ZTVEUEp0SUt6Q243elhVSVBOYnlPMzZGWUhLT0NW?=
 =?utf-8?B?Y096RVowaSt4YnRSYi93cXJLdlA3dHgrZ2ZUQVRBQ2lmNnRsV3Zza1NhcnJG?=
 =?utf-8?B?Qk1ZNnFINEVyZ2FSSlc1eEJnbVRLSnlQTS9vanRMSWxNdzlwTjhUeXF3T0N3?=
 =?utf-8?B?dm5pRHdNbjlvMU04dkdHak41TnFQZEtNUkxDYWVQSGE3QjE2M1BDbjlGV0tG?=
 =?utf-8?B?c0MvTkpnM0JoR3NZZ0RSWDc0cHFzbllKZ3hONFNiZFlXTXdtN1N0dy9Vclgy?=
 =?utf-8?B?MlpFV1RsUWFTQzd4ZnlvSXBoM1VCSUM2WnB2S0FnTFlFekp0N050NUYzVDd6?=
 =?utf-8?B?TVgzWi9nVEc5a3pnL2NnMXI2R3plZWFYcFo0SWtEV0FGbExHTEo3ZFhzd2xz?=
 =?utf-8?B?VlBaVjI4dVdNdXp2VHdzUGJGa3VpbXRkamdJdS9VaCtNWmk1UDBaQ0VZK0Rn?=
 =?utf-8?B?dW5TV1BsT2tLbHdsYVh6OXFFWVg3dFRrYUhYWUlRd1ZHakVyMDNJMHNwMHFk?=
 =?utf-8?B?dGhGalJCY1ZSOWFtYTJpOWZtZDlPQWlMaTh6UUowZFdJNThEUEFJNEpaYlFm?=
 =?utf-8?B?RFVzY2RZcDZrN0lNV0NWUjFGRWtOa3ViUDNMdUpQRzJKS0lXOGdkQ3JDM2Yr?=
 =?utf-8?B?MDVlM2tOL3VBY3JmdmM5ZEEram9hVFlUMk5DM3RFVlRLTmpSSm44b2I4R1p6?=
 =?utf-8?B?UFZmRWhJUEQ4NUJ6NGFYN2luUDRvdE5HTEM4dG5uRDc1MEU0b2Ewa2hQSXdC?=
 =?utf-8?B?YzQ0Mko4ZGkvSDB0QVFaVnRhSEhra2lJMHJFWDBJNDVXSkhucWUvMHYwemht?=
 =?utf-8?B?U3hsa0o2VDRrTUtZNXpBL0R3QUVta3RuVUpZRnJKSDVwditTdUIwdUQzd3M4?=
 =?utf-8?B?T0U4V1IzK2taNDFLM1p6R2pHb2Roczk1c1pmK3REemQxdEphTTJCMEYva2J2?=
 =?utf-8?B?SWk0STVaMG41WGM1WEtxNjJabjUrS2U5QzIrbGxkTHZnb3NSM2JyVlE1NWl3?=
 =?utf-8?B?b0R4c0RkZjlwVW1XU3lVZFB6dUdOOTVjamlLNEZzVFQ5aWE4ZlFuclhUcTVs?=
 =?utf-8?B?MDBoNHBKYWdiOWNTdS9SMVNtbHJFZC92YitrOGovUkRVK2IyMlhCRmdFclpB?=
 =?utf-8?B?Z1Z1L2tLenRuK3hhS0creTc3OTBLczk2WUFHZG4yRnFQOElCci91SHlGMjJ5?=
 =?utf-8?B?QWQ1RkU1aVdJVndiMXNYZHpYaTNJbHR1TXV0Tm9JY0hxcVREZEFWYkdEK0kr?=
 =?utf-8?B?bUd6Wk9DUWd4aVMzUWNCR0ZaYVZla21vUWRUOS90SVgzOFVlRGdGNVdUQmt5?=
 =?utf-8?B?d3U4WXFMeEFXOXRNZU50a1hRNWFaQkh5YmJQaTZ0L2dIc0NXWkRiS3A3U1VO?=
 =?utf-8?B?bUxqYzQvcTNkNlljS2wweDhraFZMRnp2WlBhT1ZRZWlOSnVwOEV1L1p5UEVh?=
 =?utf-8?B?K0pndk9ydm5FOU1Uc0wwZThta3N5NE5UQjJ1cWQyeUJkN1NyaUxhZnJROFNI?=
 =?utf-8?B?K05OekNqNytrM0JSaVZvd0g5K3JNeVRaK1Y4MWVNUVZGWlhGUFZHMU9ibEg3?=
 =?utf-8?B?Nk5kdmE5OXZ4bi9FSWJyNkk5R0RpeW1SanZSazVHVG12a2VzL0srU3ZnNVR2?=
 =?utf-8?B?cW5yN2VkRzEyUDVpTWpYN0pmVWJNdVl2NE5ONXo5UkpvNUdIcS9ycHVDVmNY?=
 =?utf-8?B?NzJmUnZzMnFYTUtnSWUxZ25tNnRRS012VVV5YlVZRDBIOTlvWU93bnF6VFUy?=
 =?utf-8?B?dm04ZitwVThkNW1tM2VRMisrRjFMTzFqNXgzL3AvNnhHUjRiQ2t0ZXdwNHJz?=
 =?utf-8?B?UisvNUVHNUFoWnpuaWE5TUxwQ1JOWnlCT0FVaDJ3WWpWQkZxOEZyanAzd3JJ?=
 =?utf-8?B?VXBkWXppZ1F2M216TGwwcWJCQTVOWlZFdmh4dGYzVlVTaUU0a0JkVW9HZnYv?=
 =?utf-8?Q?9UCPHIQmDMNNIfFOFAw1BmgIb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K8juizr+Vi2cIT++TvR37UXIOi59hx/X8h8gJ1hi4y3IxL6ahE0kzoqyLifS4rd8X4hC+TDKRZXDdZA+6p8/f/cJOMUXv/IstqTm6Pa4LDku2I5Un6asLewWV3kBFEZIhIalnTJ29/nMTiHfZteT7lbkfQaFCXV+X2IpV5IrzCUO17tk8AZntS4v/n2E/9AV4ZbJBitG8+UNNZ+sj3/Z89wYRxaREIZTXB2n/VpvaDPEGPmQq427ydZEu8torqNCE2rru5NBSOCAs0FvWJ4a4B9ZOe3BQ2VdZ6mnMQrmQ5wMMkJgBr96gsKweOLvh3m0Z80Mfkw8oBZPFlOJpw92ef+U7meabTC3h+E1aqv5OcfxnfEs2VrLvSHd6Sq8gdK1FlZttJR6FUjn6OFyDIVSXQ09UROGsZ586Jv6bXf+vtrfmFMnwEkajKbnWEplfiqnp4TWpagx3MtKjLpseum2V2/uZnNW2nKOP9Hh2CR9uSqVlJJ5vB+KRPOfANIi3eiJhKzftW45ExpJETLIXvoICEX3oJxhhF+5B6HT2ruJ0wnWVmWgWykwe2g+Tmgh/dq9n83e6vYG9VnIGIlko9uBYMFUvtRk0Qfgjo+dIm/+q9c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27829020-c427-4c38-b40f-08dd5a544c0a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 13:07:05.9208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tMgiN/bAAITAsx7Zod7IA+GMC593tUWiel3ga5AA+jgA9mUsSMQsJlnkYnLEJHYTcIlWTel0mCKW0lrhlKKGyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4880
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-03_07,2025-03-03_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503030100
X-Proofpoint-ORIG-GUID: 6Ar9w-0EDK0mRp0qV00igiufLwGO7OkE
X-Proofpoint-GUID: 6Ar9w-0EDK0mRp0qV00igiufLwGO7OkE

On 04/02/2025 18:39, Jens Axboe wrote:
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -183,6 +183,7 @@ struct iomap_folio_ops {
>   #define IOMAP_DAX		0
>   #endif /* CONFIG_FS_DAX */
>   #define IOMAP_ATOMIC		(1 << 9)
> +#define IOMAP_DONTCACHE		(1 << 10)

JFYI, IOMAP_FLAGS_STRINGS might need to be updated for this, but not 
adding it may be intentional. I did not see anyone mention this in the 
reviews.

Thanks,
John
