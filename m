Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C999412C526
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712070695; cv=fail; b=JTITkaOcw9xjp8zNyyB9LHBaNzDob6fseWRfqjpnt3dLh82BG37xgVYMpbNmqTZ/10t4uxQx11sSUm2Z42ro/hIUE877R4rAIvjw0uXDcYpN3Vu8aGawDmZxTnuPR3QnaeMBHokuaV4sFv11Jzb3Tn4/UkA20LRpjmhQ6PPfphE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712070695; c=relaxed/simple;
	bh=s+DiM317lgXcA/q2AL4hxDlMzu2vRaqiNh0L2Z24/9k=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VA1HRm07LrvOKJOJ/j6eitSC396SmKXmFHElcwvmSeLRXVTY1qbguTLCJCtcibdISH1J3eecw/z/CkGxsyLVv8K3z5Y2DywG15SPXaLpGFiUavteTezFI8YPZEa7ToxP4pKp7HF2plKJDGLKrqfIAW32uRVeyocFiCbibLJ/oUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GelzJpBH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lpwZTjrC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GelzJpBH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lpwZTjrC"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4327iuTx006048;
	Tue, 2 Apr 2024 15:11:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=/A/t2eQsLEQEbHdm5eTbPI9SpX2vqPYWKMJOyptb4ZI=;
 b=GelzJpBHRNuovAB0NAWed+LSWvMH7U09/3a9VUgP6lyviG6nKAFMsKnRe59KK2DfxbVm
 5xIpPkG6aRMfF8qQI29YCUDf+xOumWjgvXAqrUAyrV+ppYetOn+jyJWESjLY8sce4FTt
 EIVuFF3xDtU1SDHBK+TWZTY0nZcEw9zeKvCNF4cDXI9UttpALu2Rg4pWI096usyEHLJR
 2oCE3Nt4FHiLQFVElqZguaNekyZE2qENouD+aA6+uGtxu4oYFsnj1DHgaU5c9e72rGBD
 fVcJi7yU7B8PcNu82c63P23hRvlaJ+Or7qkLXfHt4HjcNi3RfHVXek6fpDpVHay/NpB6 pw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x69ncmyvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Apr 2024 15:11:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 432ER2gA001305;
	Tue, 2 Apr 2024 15:11:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x696d75ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Apr 2024 15:11:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9NA1tG1gJ6c3bBMmzFaXB0W03lK08M6fbAj/vmcg3IT3nf8IHCRR0Wj8Tsddl79oB1H5p3sp6jOY1nLeEFyNcTETrDrPRjLZHHfQsxbo6PH6n5CgeFeXEQ8f4Z8B+4G/cHft1JSRggZV4i8AsOLotsqxMIsMh7M446YzQzJYAo3CM4AMnnobY0dakPoBa0nvD/vLVodyklU3Bn15SlfXDjMZs/qLhBpaCWq7g+bKq2uYQw/V268f2CoUniY8LqkswiEt20RQl/SmafIF9K1ZtQ+wLAgocEAsOkFR2IOsDecO8Nz1T1wBOI3j29svMZZOvvqh8N7hB4NFPcN0K2UGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/A/t2eQsLEQEbHdm5eTbPI9SpX2vqPYWKMJOyptb4ZI=;
 b=gQdYnpEZ7++HaJgBS+YiwG/dpTaKu6c0OxN+OjJ9WvZxyF+RSFXFMWq/ukZ2c78NQefxeOESjFEqj2MCfBFvAhFSJX6MlD0uzQDc4DffskN8iCaf5TklMg8ndC0JCsve8FZ8Yg+p1TpFEa0fJxNF/dP0rQ6hTYDo9QtCcwM5Q+LKwyJiB+FAlUyXuBUqVuTy+MQlKWT5awDJJle7yXjr3c5OHau+qiPVUECKFTrpoJVC6V6q3p+A27TkQDJIH70yBgs1qIFWLMokieNK76c9D5QiarTR0NZQvtle/1Y1Cz8EVobZ7/sArMKYzXF/BlxMTWxcrfE1nGXCxBWVCCV0Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/A/t2eQsLEQEbHdm5eTbPI9SpX2vqPYWKMJOyptb4ZI=;
 b=lpwZTjrC6p+or+A6CB0YUpUWLJHmsHnY2MclJsuoZn58nWpdT9MH+U35v3dlKqEcEsm4/xrwhoSweWME1CTiUrPgEgxeUiozJEGg/3qwvhDZw8DJZhGGAQAGa6a+l/P+Yd3Pb82mo8enT6xl9hwfZLF5D/appBRi0Hn/b2af2Xo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7978.namprd10.prod.outlook.com (2603:10b6:8:1aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 2 Apr
 2024 15:11:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Tue, 2 Apr 2024
 15:11:23 +0000
Message-ID: <fd9f99a3-35ef-477e-ad64-08f71223d36b@oracle.com>
Date: Tue, 2 Apr 2024 16:11:20 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] xfs: simplify extent allocation alignment
From: John Garry <john.g.garry@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
 <20240306053048.1656747-2-david@fromorbit.com>
 <9f511c42-c269-4a19-b1a5-21fe904bcdfb@oracle.com>
 <ZfpnfXBU9a6RkR50@dread.disaster.area>
 <9cc5d4da-c1cd-41d3-95d9-0373990c2007@oracle.com>
 <ZgueamvcnndUUwYd@dread.disaster.area>
 <11ba4fca-2c89-406a-83e3-cb8d20f72044@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <11ba4fca-2c89-406a-83e3-cb8d20f72044@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0210.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7978:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	91RjA5tVN07i2e0IEb04nDhhrqUr83nl4EHPJcwcL/MasgGG4W2vaUQbSf1tchA/5Y5i262yQ1v5LHplqqdT4Y2WwQH3uHGJ3ke9wKipZJl0RAUglDXCb8EzT3YRw27W0ub/VXrsN5bMWrRhkZutA6xXBosOlFWzMtAJllIbk5VteNxpveodzVya0j4aKhf2Rhzcvz9JuBMP5VNJnwTh4YE5Q94ATRMpAClBo+oSovoqAHv5pSxSB5GbtSD1eZ0Ip0yYZtYoKeTV7osJm72N2Mt50W4SoL5mQoVnH/CzqNBIpbUiW1H9S5BhFMZ8TLL3bbCt6vwvxQHjo8tgpJzbvBO46NS+rThEZpfFmPMiwpW9sPXmSuXyzOr5h7GEHxrSrDvSkzdV47Aa7u5ObHlFqsvDfsd7W8XPpAbYCK3ZZfj1n4kpc1kP47z3vX5RflzJLwvWHJdsoIY7gn3w+MFByJQ80crtDvQaSMWOFfvkjW0/oxGCQfso9eNlGU6xV+Dhey6WjodwLWvmNVRmKLOMM7CE/YmoFijlSR+qTC4SvQEOT9YhJDwHwlpo2UOlHYzLypVNxs07wgrV9KP4szm1n7mtytK9Jgyh3s1U9uDtomD9DtTTIcMKaG/dhQP7nsx9TiLOXUN13lGrFwOEXk8PDd8iufJ9AEqnB4x5j4RBYts=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RG14ZitjR0xaN1llMlY2Y1lUeU14NWRscVowOHdHUzJEUXRoWG9MRnRhQ3ZR?=
 =?utf-8?B?UlpIZmZVcEt2NFEvN3p0eE1TQldrNVdMMGhOYzBXWUsvK3ozWDBqYThuSDNO?=
 =?utf-8?B?QTVJdzFrYWVBdjdBVTRoMUFabXhyRWRXVHVaYjl0TnJVQTV3WmhKMzg4QlBN?=
 =?utf-8?B?U1J4QjlCSUhPS3NtOTFyUGFHMlRxTTdSRG9PbmhJMkFTZldQZmxZK3pWQ2cy?=
 =?utf-8?B?bGIwL3VGM2UvYkFFT3g4ME03Qy9HYU56T29HVzdnK2ZnUmdhVkN1akJnbWpp?=
 =?utf-8?B?b3ZLdE5nWDIycVdjSG9xaHFRNEhLU2tjNXlEN29pcERuZExBR1pxNys2MjJw?=
 =?utf-8?B?WDh2RUwwbWlxUmdBRWZpZElUckU5UExmaHRUL0lGTVQ3dkVvd3ZrUjl5eXBn?=
 =?utf-8?B?akdkRTJBSEJwRXMwZGhxMERDbVNaU0F0Nnp0SktkYXdlU1lPR3FOVU5BMGRE?=
 =?utf-8?B?U0laNzNpYllzRldZMEs3MGdSd0tYMFVqSUZKb0o1cEtkeWR5WGlYWGlxbkZw?=
 =?utf-8?B?NTZPcEdxd1NRUHpva05mVFpheTI4RWNlUmw5ckF3WG5uaVRjOEZYSk04MWlK?=
 =?utf-8?B?VXErVVluWjBwMHRuRGdSWlpZTDhlWFgxTUhDTlhoZlFqKzR6djVHWlp6VElH?=
 =?utf-8?B?Z3RNQ3hDbFQreVdFRDYvVmErbnhnTHVxMjNlZUhORG1POWJoaittUFREdFpW?=
 =?utf-8?B?VTNKUDJ4TDNqZTE0UDNHZExrMFNmdklKcitzK0xqZ1FhTkRweERZWmR0SnVh?=
 =?utf-8?B?b0tnTm5QUG4rWmh3TVY1amtqNGhZR09uTndYOEdxZzVEaFl0K3RQK1JyQVNl?=
 =?utf-8?B?VVp6UHBGZ0JvSnBTbzFZbXloVmZCQ29FckJmQ2U1bnRIQktXRi9WSnFZKzlk?=
 =?utf-8?B?U3BXdWZFWHpnT00ySVpUMzVxOTRiemRxSkFYUFRHSTVaTW43clhZd1AycXFx?=
 =?utf-8?B?cVRVazlSSGc5NXR1VmppeksyYWU1VHJiNktEUGFCdkNmc0JTS3hMUFBsSXhR?=
 =?utf-8?B?bWp4YjdLVGExQ3Z0anZRc1IwdTY0VzdtSVM0bVMzWDRBQ1NmNjV5emlSWTF2?=
 =?utf-8?B?VThNS25OdmxwZFpqYmN5TDlrWmlMcjgxdTgyVzZGOEFldXpaZy9Fc2kySXJF?=
 =?utf-8?B?SE05K3dPRm51QlZ6OXpRbGdPZk4xOXB2MjlvVjV3SEdGdmFrUDhPdVFMN2t3?=
 =?utf-8?B?ZUcwbVFZT0dWU0dGYkxjdmJ2OStDdDdncEtDMHlDNkd3cytqVWdIVDBPQVNh?=
 =?utf-8?B?TmN6bGVJTmt3a0VDeThJV2R2YzhrODZTT2dsVVpKYitjWG1leE9PQUVPV3Bn?=
 =?utf-8?B?NEYxNTF4ZnYxVFhWOFZZcHI4dmtrVnN4UkdtZUpKOUFEOTU1MTY4WThDZUlo?=
 =?utf-8?B?bXhTaFFWK0MwbFR4eFBOdDk5Wnk0cnVNZkxxcUVlRUFWeVoxZ256MXB6Rk5V?=
 =?utf-8?B?MjgxUG1NeHBBUlJ6S0VBRERTRDZQTUtoQ29NWFJrY0tCYVBuQ09EU0dhaUc1?=
 =?utf-8?B?ZVFJekF1NGRJNUFhdjRDZjBRbTVHVW5BRlZJc1pxR1lWTXRuZktOQVM4VXhi?=
 =?utf-8?B?MzlLVVJpTnovMkJSdWZwNUk4NHZKaHpna0YwOVc0S0dUNjVEQlJpRWRQWWhW?=
 =?utf-8?B?cGZ2QVZYUWIyQzZqbGx4bzZ4YW51L3dBSFkxVUxlcmk4WG1wL2RZeG02Vk5L?=
 =?utf-8?B?SkJqNm1OT0xTVWh4NUE0clRaUlpkYXFiSmZhRlNtUnBKc2s5ekttTkYxaDhI?=
 =?utf-8?B?eWZrbGtteTlVWjYxMHdIMDdaMlB4eFRCQlR6amFjZ1V6QlhqbnBUdEZkbjJG?=
 =?utf-8?B?SEtiUXNjNjNHLzFlcTdvZXh2K215YkdqaUtuNXM5SGxoanZzVDJTby9OVzds?=
 =?utf-8?B?eHEybjA5OTYwVFM2Z0lqSmNmOFVPOUpENlk5ekRYbzlCUzRSTDRha0FNVWFa?=
 =?utf-8?B?Zm5TcGhZVmJEcEpIRkZUd1RvZmN2VUJMY0FDRmFOVTNuTHByRjVabUJFY2pP?=
 =?utf-8?B?VHpkZVZtRzVvZ0ZSSlo5Vm5xWEhGSGhUSDVCV0YraFVPQjlrRm1PYjdsRkcv?=
 =?utf-8?B?Zy9TRHZBQ0h1c0NoRjIvL2pzYUlXNjA5Q2NMbVFib29yRWt4L0tlaVVSR1dE?=
 =?utf-8?Q?KbuYEJRu+WOYyGaU3S4nx16lF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8F6nWTBykfPISsvKsljGgW0WjgXaXiTGfBv8m6fQPCQwZFMJrXsZO0RD/YjUHBd4l79wN/FOFlSedm/N1VMpyStfxKH3bArNfoXqdD8XB86fzYlTvRxsyS0YCt3EfWv08wI4C+SO6oXDqhvNiuE3oPWUCrZASJS1rchLhkD29gSd9Kr8AbIOVvtsggSnX43xMN79svF5Xnwh95otRXRGkx5SjL9hBcCuHm7jRtdgv2Uv9zp42Q4ASKuZXApudwi+JRbxAGI1BjfXqaUJkwXFPkqQ5j9LW1G5S5GJ6JgBRd5YukFxDJjSJcS5MBs4PQEWGNpklalukMdNTpcrKhiIHs8N3Imr34Ub5ZToMa/0wJDSYWI0oVJ3LepAJ8IqZedDmu+U0OAbz6JgUnCqVDx5CC1gIm+30KaN+zDLXDyGnH8eQWyULXmkFdTp8rVEEipiKSsSOIg4AdNUCR3RThN9wbiBnoTeR0PDmXYROzI+UC9PtlBJPRDUn2WwW9PiZWExQS0/7Nq3I1xp9l15nmLbQJRRDZKT3UcvdVXnYWpjyFYVIjw86ZlAxvohjkPFJg7uaY3vYNLnA5TzhJ+Ol4TdGsEA+plPLgdrdMHYNzRboOA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b97f8750-2dc2-40cc-7671-08dc532728ca
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2024 15:11:23.5509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wtkAKT4iJsjRdvvnKPlmLeO4I9ubL3r289xnIt4M0Y1zV/Wov7kZioMjCqFegtp9PCBw8XtYrru7ub1BFJiEPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7978
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-02_08,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2404020111
X-Proofpoint-GUID: pWoNVwO8rphwE7iNrG_kn6C3WGG8kcii
X-Proofpoint-ORIG-GUID: pWoNVwO8rphwE7iNrG_kn6C3WGG8kcii

On 02/04/2024 08:49, John Garry wrote:
> Update:
> So I have some more patches from trying to support both truncate and 
> fallocate + punch/insert/collapse for forcealign.
> 
> I seem to have at least 2x problems:
> - unexpected -ENOSPC in some case

This -ENOSPC seems related to xfs_bmap_select_minlen() again.

I find that it occurs when calling xfs_bmap_select_minlen() and blen == 
maxlen again, like:
blen=64 args->alignment=16, minlen=0, maxlen=64

And then this gives:
args->minlen=48 blen=64

But xfs_alloc_vextent_start_ag() -> xfs_alloc_vextent_iterate_ags() does 
not seem to find something suitable.

I'm continuing to look...


