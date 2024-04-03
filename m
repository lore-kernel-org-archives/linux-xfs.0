Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF721411FD
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 11:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712143846; cv=fail; b=ca+jHj2uqSTgZK21kw4lk2jGgarCO1m0z6vQMWgEeKvZyz5UDNdkk3vNQ0DVCsutVOyZg25cvwcZ9PBPRo+JDoT8TksQcOQV+aFD/CgdGYb36fhZcnenD+2uDUOuVTT2RU+6YNzYRaR57OknhGV/BlCybh74kCyKk2vu7KEabXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712143846; c=relaxed/simple;
	bh=rc+eaFKdY21ZM4mo5lV4tdq+Gqhoa0Y0GFwYLKXWSys=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SfkBSwbCNXH9qqp2dx8u+1x2yJXwLn94eyvhKdjpW2fFOPhdjn73bONr7rtIptF4dunp12UODkaQoAZu2YI8uizTpjbJM04/1mrbIi+CtwL0D6YL1Jp2+zZa3tUUF1xb/TT2c/klanl40c/1II9XXraWDcfWQS60fH9aDIgD/dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GJvKboFC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dWPG1ITT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GJvKboFC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dWPG1ITT"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4334q0xR023044;
	Wed, 3 Apr 2024 11:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=chepkixZV3i8mziQlMHL6q0yi9QlxUg3Yy0YawnEVu8=;
 b=GJvKboFCok4F+TMCPlDhCAwVeWSx2wuN3diJHSWOAq6JxxMLAq4Df6CS89M1Co6vcLad
 csrYXkZBY7m0QgAAsfyI61BFLD9V12vL9m/ojqJL5I+R3u8qlnlHuylnHtgKiUohDteY
 EK48CQcT9jSoSna9swfUlp4lt+eqTmJ+LUAZ7+6vJrLvtmZVodatvmDwiHMquBwFDpIH
 Xim4ewEC7Ox8HPXdQHKP3RwyU2Vk4y/9X46Ho7S+gJiY0sEw4cENc7lnjTA+AArLLTVi
 WQOX6IZpZ6QracBEJSt7yeH7vw0QE7WrI1+VmTsSR/KEdOYJJDNyVn1r8aagwN04C13M 5Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x6ambetde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Apr 2024 11:30:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 433Awo0u015852;
	Wed, 3 Apr 2024 11:30:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x6968dtcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Apr 2024 11:30:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/x2/Rp3ktePImIU1DCtfboQHj8/zsvrBR3/bNTt65XFj2UwuDrHklF0/036/rsU2r0HABvlqJbUZjLuVwSokCWA7V62e2jGxk/kelS4uR0Nm0i5CSCarKP9/rnFd7WOtIaUz5bChoAZavUbRkPuei3Wi54cD6TXqgjl7nouV/fBxQBc3bgY/CY0u6ZAIyCkUWLdn/IbKxJIappGE4krQ9pA3CmSDlXSXYcJIhMBUbOHgEVehnmknoqRhnHjquH3Mc0T21kEHhGPKUqjofVe+lQjBsFMRNKtMwA+YfddyjCN5cJ88rjpsMvnZsArjGu0KWIXOCc3IzLBL2XaENrBrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chepkixZV3i8mziQlMHL6q0yi9QlxUg3Yy0YawnEVu8=;
 b=bNlG87MZ4AMJG+TJ+9zMnIazhcAnkc2294bWdgAx7wAPQKelEyHIP8zbq0zAUku3fHb2+jzAjgpzOctT9RDJQl0QKbXmX2XsrHNKT1i23R9J5hid7AV+364ditFqmIKdEPuWE86ya37xWhx5NqH1rZtbyFt++FgWX1gl+UMxiVMysYeeXUWiJPPye8f5NZZJrCRHlewEHy6liiZCy57ubzXR0koATPMs30QfNGGKQ3+feTnaLtBafyfWi8TkbQJMvTnQ6bkZ5zeIOyLfjrTMc8aqnMPWjOkz2hL0uDSIT8DtQk+6dZhNKNc/knGJaUE/W66YVo/M3T1IE5QhQfENLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chepkixZV3i8mziQlMHL6q0yi9QlxUg3Yy0YawnEVu8=;
 b=dWPG1ITTwR73sQUtraQ7D1UIWf/P5GXDa9MaWNVNkUjQ9c7d/vHkZLghwiOmc3+BaSofTrl/Ukb/LWqNfjCO9xt3i6sqdfWupVC3gxcQuIhH7vf2BZ3HN/YrG6GmbRkR0C08RSIA8mw948T4rkf5ZCAFwDlk3Cx8MWglzrfNYw4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6664.namprd10.prod.outlook.com (2603:10b6:806:2b3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 3 Apr
 2024 11:30:30 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Wed, 3 Apr 2024
 11:30:29 +0000
Message-ID: <a7de9521-d101-402d-a59b-f7ce936ba383@oracle.com>
Date: Wed, 3 Apr 2024 12:30:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] xfs: simplify extent allocation alignment
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
 <ZgyYcu7pzsGJzxGX@dread.disaster.area>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZgyYcu7pzsGJzxGX@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0225.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6664:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	HAMUVHmTU5V5grtEI8/MrMwfPIPRSuiGybCDr3OIlDQqL2K9/mXjDU68Yfubxd4Y+kq6BxHPoKainwdsK+vhGDTSMLmiIVL/L2vHqd4XpMp6d01Pt+Lwq6AJpRRWFwjreuFXOAgrOTCn5ooPZNAtrbc2Q8W35n4xtqdwv7QwLuBbvsIArpAPLd90qN4YhMhy58LRlyQnRmVwfz06g1vQP47cie9mmCY2Ygrm+fdrg4XOi1U3tXq47KzksFZ2pI+8LhfvRWY//J2dO0XMQzHH91bw7+CsTSkGsPFbkqNRMDS3Y8PnbBw0H+XXWUZAXPgk+z9EvN75gsuk2pTATlmvUogpjxK16C56BwI56QBxG2guJK20B+w6AJGldkgdQnDODyIdrLHlyFMC0XglbQEjCIQ4jnBCUn8Gxx1hEAKBJuvf2VoHewohqC8BQF3bjFpdqWPa01bk8n2kQ7AIYT9FtgFAlbfBXIyHjTPGN5eBAUnPXC/rKnoBIbvFLuzi6Cotsj7v3E3Fsy4qzu04Vnpz8YtcdnuAXbq4blVSXMa8WlLng78BMAICsMIS2Kp+AjOE5id5R9YMblBsTuyUSx2wFGfz8LeYavU42KTFWENPl64=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MGNTWExZajdsbzlXZDRGdFMrcm5RWitUbG51TU8zdUhSSGNWMzlmNjRYYzFq?=
 =?utf-8?B?WjBFOXBDb3duU0FVaVhpT3d5U2VZV0p1VW1sOWJDZzd4NlJzM2lBallueVpn?=
 =?utf-8?B?cFhPWUV5bDJuYzUxdFJFYmZVNHIxVlhqNm91TDNETEhEN1RhUFVGSk9LMnds?=
 =?utf-8?B?WFZjMlhud3VFcTVpWDJpNmNuNjBhQTVQNzJ2S3dvTEI3SVk2amJDODYyU2pJ?=
 =?utf-8?B?eUsyZk5ubXJuK2x1Nnl5aFkyM0owREo5UUMrcnZpd1d5SDZpbklydEZwUVBz?=
 =?utf-8?B?RUs3Tlg1YTFoOGZYSFRzRFpwL0N0bDU0Kzg1bjZzOENJOTE2Rzc5bndzYVBn?=
 =?utf-8?B?MWFvU2hiVkZONjZnZDQ1VEdBWExGQTlGSllDSHF0bFhDZDVFVGl4MlpVS3VP?=
 =?utf-8?B?MHlZNnA3RHlTTVJ2SVVFYmdoQlFNQUJUTktyRHlxMmRUTUczUGhlWEVPaWo2?=
 =?utf-8?B?MldvM3lyWjlIV1dGZUxvNW00aWdyU2R5TmNLdG9tQ0o3V3MrR01PaC9ZVkFv?=
 =?utf-8?B?SXVoNS9vK3JMUFl1ZUdQQ0pheC8zZkVEQTdKZFMwZ1ZnN2Z0SkFNeUZuMUs5?=
 =?utf-8?B?c0orTitVZUFSdDdFc3ZJYVVMR1VNNEtBdy9scW1Wbjhvc0t5aTRRYWVmYmZo?=
 =?utf-8?B?R2hOdnVVcmhQaENnWFZPUDRFZVE4b3hqWEFmV044dVRVNnRrOEpYZnlCSUk2?=
 =?utf-8?B?RmVrVkxqeWxScHNxcEdlZFZQakh3SlZldWt0SW5PVTRFeFNDNGJUNGx3eXBI?=
 =?utf-8?B?WWE4RHZuZ3J2ZWVGVnBlUm1VMytZbURTRGdoSVFZSFNJc3c4bCtML2JDN2c1?=
 =?utf-8?B?Vy9zYXErbUYwQUJFKzJOd1lWdGlianVBa1o4Y0hZVm41TXdyS0hFS3RmTW5D?=
 =?utf-8?B?UjhKNWhwOHpoaGphcHl1YnQ4M0tOQWMxbnNZZWdYc2EzcUZzb1pjb3kxb2pV?=
 =?utf-8?B?eGJkWmNHanJYQzlHd3lCTXVraWtibHNsa1RmYnNiYzROMHZjcUdwdWxlOGVW?=
 =?utf-8?B?TDcrQlFwNVR0dTBVVEFpUGZpUkUzSzRicFJCd0xONDFYZ3FHYzRaTHRNZDJ2?=
 =?utf-8?B?cGJrcGw4OFVaR3FZb1F4WG9tdVFQcmQwd1cyTGpIRHFObVhlVHk1bmNEYkZ3?=
 =?utf-8?B?M1doblUvcXJZeHY0VnRqbE5XOTVkMmk4d0kxclBsZXJFa0M3cHNLZmJFUk96?=
 =?utf-8?B?dk9VNUtMOEZKZkd5MVpEKzkvR2FvSDVyNXJ5eE5wc1RJeTlSM2NNazMxSWRi?=
 =?utf-8?B?TzJOTnZ0dFcwVC9LVVh0UzBHTXBQMVJBbFFvQzcybkZhaE83aFBJUGdCbWVT?=
 =?utf-8?B?dlNkYWlOeXdRMVpONU9KdUkwQXN1MkhJaUlnRG9BU0ZFblJGVSsyc0Rqa0hQ?=
 =?utf-8?B?dHRaejk3VGpkQmtqSGVGV1N6Z0pLVGJmRzR2aE1vaWdxLzA1T1lJRWVBRTF0?=
 =?utf-8?B?THY5RklHOEpCZnMvdkxjREdwVzBlaGh6NExkeUJiS3lDeDdQSFRuSzRLV1ds?=
 =?utf-8?B?ZnhwUVBJMEhsanFjQitRTnVINkkwY3BzWHEycVV1c21SVGtDVjAwSW1ZV05Q?=
 =?utf-8?B?dHBodVhxeWhkNm5STVlTeEM0c0s4MFVydUdCUTJweXZPNVNpU0pMYlV4Yklt?=
 =?utf-8?B?UU5wN3hHU2s0VklnWEgwYzJlSXBZajFwbzJ2MEdFWmNhbHhxcEM4S1NzRE05?=
 =?utf-8?B?cWNGckkzMVVYNWE1a3krZEZmaUVWS0dLdzIwK2lEbERiWDVnYVFvM1V2Qjd0?=
 =?utf-8?B?TDlQYlRxbUFRS1pwM1I3T2RlL2I3OGlZTXQ2OE0rQzNxczZhYkd0TVNYQndh?=
 =?utf-8?B?TjBkcEFiMVdJT2xQaXRvaTF0QUljQWw5VkJ2WGVORXgrRUR5czJrc3JHWVhF?=
 =?utf-8?B?SzRqZDR4SDhyWlNLbktnVFV5K1NXNFQ5Mng3dVMxUFVPcElsWWtCdFg3d3pR?=
 =?utf-8?B?NU0wRU1uc09ZUmttQy9YeWJaaFovWTgvMURtUGUvQ2FYQVIySzJObGRHV05L?=
 =?utf-8?B?ZjEvTXB2a2ljdGFsQzY5d1VIK20vMTlQOSt4NDlGK2ZlcDNDRGhaWlFReXhT?=
 =?utf-8?B?TjJRNnk1WTJobGFhU004ajFzWVJUS1RjN2RwS1JHbUxpK29PYnVNTzRqbERD?=
 =?utf-8?Q?gGCHzJmAwLsd9H38nm0toqG++?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	AB2La39Poyv3vdRe+hZyp+r2oE+0gv69y8fLPSOZRl8gt4wxMreGZh76XEvcvSsn8uKBMG1vaS1DOO3I71SMsZlfzBiwS0skrkgA19pCzeKoS0NPZfEGQsaJcfb0WsbcdmYXhvyQbczYywgneA9mFFzNAtYyLXV8DC/BiCrngu5catMqDVNtmMzATEWS6rtMVFHe/S/i2g1kjnzeieYIYecpsYn1rGzDEeNTMwcIlrEjY+Vp3dECIO/VzBMrk+zSfcykDjJ7n/YOp74QignwXargFAitg4UX9DozfRVWWSPfuO0hHSilTUbQQABo9noIajeG0E3wsqEypQaBRSEuhqGa0DSsUzzI9TOzJwY77HR0xkp2Z2JnQO57qrmxyI95tbfeBtKl8M/ntt882x/fhiHMlM6nuhFF8XmfA2R7IaGQn7zgOOP94QTsnWg56ftkjL2ZJB7L0e6Q6FVVgK8GaAgqjAoUiS8JTGv3l+SuTgn9wrwC05CmTpEPbu8fIxR5OjtSIdYTbp7K3R0leWkY90B0vdMaMqd+Efdi/jR9gLP6pL94bqNzfujPiGF3+ZD1X/jowPbaF+8c/M5oem2r5h+8QUVPMAusOrrJQk69xfg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeb9fc8b-4f98-497b-c705-08dc53d17774
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 11:30:29.9245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nuDLTPg8abj/bpyHvCGxX32rDYRW3mC9LnzkSD4Xgl1hok8mNxPZP1Qk3Vr307DmFaA/q8n3arlUYAOaschG6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6664
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-03_10,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404030079
X-Proofpoint-ORIG-GUID: 9HtF-4ZZ10PUWRvrAFjyd7d-z0eBtfYI
X-Proofpoint-GUID: 9HtF-4ZZ10PUWRvrAFjyd7d-z0eBtfYI

On 03/04/2024 00:44, Dave Chinner wrote:
>> I seem to have at least 2x problems:
>> - unexpected -ENOSPC in some case
>> - sometimes misaligned extents from ordered combo of punch, truncate, write
> Punch and truncate do not enforce extent alignment and never have.
> They will trim extents to whatever the new EOF block is supposed to
> be.  This is by design - they are intended to be able to remove
> extents beyond EOF that may have been done due to extent size hints
> and/or speculative delayed allocation to minimise wasted space.
> 
> Again, forced alignment is introducing new constraints, so anything
> that is truncating EOF blocks (punch, truncate, eof block freeing
> during inactivation or blockgc) is going to need to take forced
> extent alignment constraints into account.

Sure

> 
> This is likely something that needs to be done in
> xfs_itruncate_extents_flags() for the truncate/inactivation/blockgc
> cases (i.e. correct calculation of first_unmap_block). Punching and
> insert/collapse are a bit more complex - they'll need their
> start/end offsets to be aligned, the chunk sizes they work in to be
> aligned, and the rounding in xfs_flush_unmap_range() to be forced
> alignment aware.

Ack

> 
>> I don't know if it is a good use of time for me to try to debug, as I guess
>> you could spot problems in the changes almost immediately.
>>
>> Next steps:
>> I would like to send out a new series for XFS support for atomic writes
>> soon, which so far included forcealign support.
>>
>> Please advise on your preference for what I should do, like wait for your
>> forcealign update and then combine into the XFS support for atomic write
>> series. Or just post the doubtful patches now, as above, and go from there?
> I just sent out the forced allocation alignment series for review.

cheers, I'll give them a spin.

> Forced truncate/punch extent alignment will need to be implemented
> and reviewed as a separate patch set...

Below are my changes.

I think that the xfs_is_falloc_aligned() change is sound. As for the 
other two, I'm really not sure.

There is also 
https://lore.kernel.org/linux-xfs/ZeeaKrmVEkcXYjbK@dread.disaster.area/T/#m73430d56d96e60f2908bab9ce3e6a0d56d27929c, 
which still is still a candidate change.

Please check them, below.

Thanks,
John

------>8-------

 From ec86dd3add7153062a612cb1141f36544f34e0cd Mon Sep 17 00:00:00 2001
From: John Garry <john.g.garry@oracle.com>
Date: Wed, 13 Mar 2024 18:14:37 +0000
Subject: [PATCH 1/3] fs: xfs: Update xfs_is_falloc_aligned() mask forcealign

For when forcealign is enabled, we want the alignment mask to cover an
aligned extent, similar to rtvol.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
  fs/xfs/xfs_file.c | 5 ++++-
  1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 632653e00906..e81e01e6b22b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -61,7 +61,10 @@ xfs_is_falloc_aligned(
  		}
  		mask = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) - 1;
  	} else {
-		mask = mp->m_sb.sb_blocksize - 1;
+		if (xfs_inode_has_forcealign(ip) && ip->i_extsize > 1)
+			mask = (mp->m_sb.sb_blocksize * ip->i_extsize) - 1;
+		else
+			mask = mp->m_sb.sb_blocksize - 1;
  	}

  	return !((pos | len) & mask);



------8<--------


 From c0866d2a5753f1c487872ef3add4e08c03c22d00 Mon Sep 17 00:00:00 2001
From: John Garry <john.g.garry@oracle.com>
Date: Fri, 22 Mar 2024 11:24:45 +0000
Subject: [PATCH 2/3] fs: xfs: Unmap blocks according to forcealign

For when forcealign is enabled, blocks in an inode need to be unmapped
according to extent alignment, like what is already done for rtvol.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
  fs/xfs/libxfs/xfs_bmap.c | 41 ++++++++++++++++++++++++++++++++++------
  fs/xfs/xfs_inode.h       |  5 +++++
  2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7a0ef0900097..5dd7a62625db 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5322,6 +5322,15 @@ xfs_bmap_del_extent_real(
  	return 0;
  }

+/* Return the offset of an block number within an extent for forcealign. */
+static xfs_extlen_t
+xfs_forcealign_extent_offset(
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		bno)
+{
+	return bno & (ip->i_extsize - 1);
+}
+
  /*
   * Unmap (remove) blocks from a file.
   * If nexts is nonzero then the number of extents to remove is limited to
@@ -5344,6 +5353,7 @@ __xfs_bunmapi(
  	struct xfs_bmbt_irec	got;		/* current extent record */
  	struct xfs_ifork	*ifp;		/* inode fork pointer */
  	int			isrt;		/* freeing in rt area */
+	int			isforcealign;	/* freeing for file inode with forcealign */
  	int			logflags;	/* transaction logging flags */
  	xfs_extlen_t		mod;		/* rt extent offset */
  	struct xfs_mount	*mp = ip->i_mount;
@@ -5380,7 +5390,10 @@ __xfs_bunmapi(
  		return 0;
  	}
  	XFS_STATS_INC(mp, xs_blk_unmap);
-	isrt = xfs_ifork_is_realtime(ip, whichfork);
+	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isforcealign = (whichfork == XFS_DATA_FORK) &&
+			xfs_inode_has_forcealign(ip) &&
+			xfs_inode_has_extsize(ip) && ip->i_extsize > 1;
  	end = start + len;

  	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &icur, &got)) {
@@ -5442,11 +5455,17 @@ __xfs_bunmapi(
  		if (del.br_startoff + del.br_blockcount > end + 1)
  			del.br_blockcount = end + 1 - del.br_startoff;

-		if (!isrt || (flags & XFS_BMAPI_REMAP))
+		if ((!isrt && !isforcealign) || (flags & XFS_BMAPI_REMAP))
  			goto delete;

-		mod = xfs_rtb_to_rtxoff(mp,
-				del.br_startblock + del.br_blockcount);
+		if (isrt)
+			mod = xfs_rtb_to_rtxoff(mp,
+					del.br_startblock + del.br_blockcount);
+		else if (isforcealign)
+			mod = xfs_forcealign_extent_offset(ip,
+					del.br_startblock + del.br_blockcount);
  		if (mod) {
  			/*
  			 * Realtime extent not lined up at the end.
@@ -5494,9 +5513,19 @@ __xfs_bunmapi(
  			goto nodelete;
  		}

-		mod = xfs_rtb_to_rtxoff(mp, del.br_startblock);
+		if (isrt)
+			mod = xfs_rtb_to_rtxoff(mp, del.br_startblock);
+		else if (isforcealign)
+			mod = xfs_forcealign_extent_offset(ip,
+					del.br_startblock);
+
  		if (mod) {
-			xfs_extlen_t off = mp->m_sb.sb_rextsize - mod;
+			xfs_extlen_t off;
+			if (isrt)
+				off = mp->m_sb.sb_rextsize - mod;
+			else if (isforcealign) {
+				off = ip->i_extsize - mod;
+			}

  			/*
  			 * Realtime extent is lined up at the end but not
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 065028789473..3f13943ab3a3 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -316,6 +316,11 @@ static inline bool xfs_inode_has_forcealign(struct 
xfs_inode *ip)
  	return ip->i_diflags2 & XFS_DIFLAG2_FORCEALIGN;
  }

+static inline bool xfs_inode_has_extsize(struct xfs_inode *ip)
+{
+	return ip->i_diflags & XFS_DIFLAG_EXTSIZE;
+}
+
  /*
   * Return the buftarg used for data allocations on a given inode.



------>8-------

 From 8cb2b61fa419b961d22609e12f2d941ce976d0f0 Mon Sep 17 00:00:00 2001
From: John Garry <john.g.garry@oracle.com>
Date: Wed, 20 Mar 2024 13:05:39 +0000
Subject: [PATCH 3/3] fs: xfs: Only free full extents for forcealign

Like we already do for rtvol, only free full extents for forcealign in
xfs_free_file_space().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
  fs/xfs/xfs_bmap_util.c | 7 +++++--
  1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 178a4865d1ed..e3e6e27a33bf 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -848,8 +848,11 @@ xfs_free_file_space(
  	startoffset_fsb = XFS_B_TO_FSB(mp, offset);
  	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);

-	/* We can only free complete realtime extents. */
-	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1) {
+	/* Free only complete extents. */
+	if (xfs_inode_has_forcealign(ip) && ip->i_extsize > 1) {
+		startoffset_fsb = roundup_64(startoffset_fsb, ip->i_extsize);
+		endoffset_fsb = rounddown_64(endoffset_fsb, ip->i_extsize);
+	} else if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1) {
  		startoffset_fsb = xfs_rtb_roundup_rtx(mp, startoffset_fsb);
  		endoffset_fsb = xfs_rtb_rounddown_rtx(mp, endoffset_fsb);
  	}

------8<--------
EOM
