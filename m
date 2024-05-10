Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B590C21340
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 11:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715339444; cv=fail; b=Ly8DXPbSx4sVPHwHFG8zCIUwfUlJyx74Gpv67mOsP7xK0KyTS2I2F75UPpibj65EzZLRd2DHuKF2yB2WnPfPDwmX90LIU8P34iTwJAklbgk/HftTbCcgkOCNwAx480YKR+jF6cRyGzzyPokOnVcH5mp98q6QsYx5kwgy8VcIVXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715339444; c=relaxed/simple;
	bh=4lcxnm8Y9cRdjQnHRLm+R2gWlJQJnRILbVLM1WwDSds=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ahBNiTY1IAPFPXsKMMRLpXajoYDlHsppvxofBzc+Fwqs6YSH5Fm3xI1vQXntMcxE2Fj+/GZDnljQGGhCtOPJRGMxp84ulIhqqxupFd7vvhxzfOvegWR27EDylWDLbCUbEtnGyRuKcxlnoaNoJmN0PVhbSVgMAUuBkBPbm/yKtDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c4SE4QWo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A0rJk6Rn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c4SE4QWo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A0rJk6Rn"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44AAx2Iq022039;
	Fri, 10 May 2024 11:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=B/RSSLHV+Q2AXrpvCwjdYAPat6EwNEwM2bJs9I/cEF4=;
 b=c4SE4QWoy47Q6g0KiCWe4KpKKiFjm0Y3WSImWb10lirwxCcPmDmwJMIjEwe1lr3jRchC
 5VGfMOMRK+6wh8ECnMVPlu8rqjKjzuaXhpFAK89xVP23Edl63dYPD7L6YPFzXA0uteXv
 nCf+KWuV0JS8vGQNpaM4O56o3usiVOd+8q31aWlfmviqVE3A4V1u9CaWxuIYTvwZUgXv
 7y73Gmc4Du4D8r1N/zX8vslJIKgRcjN03jGWW6gd0GRjtCHQBNlvHgeipf9bvAggH2k3
 sIoD1c2q1jbSugBsE+ek0BJ8fW+PcXcdh47YZDSdTFIW6jrzZbpIAhmoQ0KtkxPbbQcq lA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y17x7rwkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 May 2024 11:10:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44AAN0Bp030996;
	Fri, 10 May 2024 11:10:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfpp0vb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 May 2024 11:10:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6d+fkIAziHGA+e4w9XbFLkKEVg5GVRMaWYQ5h/B6Occ5xKmTMWJbMmzuapV6TIoMLjOQsysE0t5Et1lYx02L0UqRA4k1SbhjmyLBmTtu9jqQyvWCOZAnb0dUjD5fnG0Hcc/Xsq6IjLidGzf5tkFh7mzosy+9LvjPV+8d/npUADTlI8AY9BxzwOG2KBPCMWfunzg0UcRZkXPf4Lwlpivl/H2PBzWHd3EgwBz+Sx2PxQRrdMifkEuw4J485iQOCp7qD3F0K71kclMj7aWQm8XFaDd91DsF47NDeOI3AeALZpR8ljP3/HAj6OPMozkJOyjvXN+2m98fwFD7vxPadW+hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/RSSLHV+Q2AXrpvCwjdYAPat6EwNEwM2bJs9I/cEF4=;
 b=hPKr7oDSjSyW87BpOdH2kwxdmPUwP1RnPosOEszQ9Ah8SMJ9k6vbrnJk24PrvshvN1+drnyN61GzcG0l75ddHYGdgwtIVKnW2zvuX71PLNz6luXwQXAKZg9+OwRmu+TqLYSvbfBME/FOxrOoKP3mtfNqbJn1oyhomKcHvQpO+h6v5cKp4aleinpjBeV1IDx7AHiYqwqjAysmXjXayftNEhhqrS6yGraNB4yCGmg+WXW+bjZtJMBDLox7jCxtiirdKMMwzJN7qnYk1wpKPY0yoC8RY8S6nm+VOmoTpTtu+e8q+TdvftynPXDZWv9n9TgkbJaCf35sx8XF+KuAaQ2Ghw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/RSSLHV+Q2AXrpvCwjdYAPat6EwNEwM2bJs9I/cEF4=;
 b=A0rJk6RnlUfhhxWW5RKXvD0fu7vN4KFBFSXYaEC9+/73VS9umFwEztRlL7XFNcow0WOD1fBLzTIE9j7t6xHsax/SoUb9Wi/yoxZ31ot81rt3BcgASd70b5LqQHnbBT0qvLgV/6fm6AnQXzgHq5fvlf+xMqU9g50sEZKBqvIMKBg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4479.namprd10.prod.outlook.com (2603:10b6:a03:2af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Fri, 10 May
 2024 11:10:30 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.047; Fri, 10 May 2024
 11:10:30 +0000
Message-ID: <112d379e-bcdc-478e-bfd1-511d4f4371f1@oracle.com>
Date: Fri, 10 May 2024 12:10:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: Fix xfs_flush_unmap_range() range for RT
To: Dave Chinner <david@fromorbit.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de, linux-xfs@vger.kernel.org
References: <20240509104057.1197846-1-john.g.garry@oracle.com>
 <20240509104057.1197846-2-john.g.garry@oracle.com>
 <Zj1e66zN0iReurEu@dread.disaster.area>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Zj1e66zN0iReurEu@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0611.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4479:EE_
X-MS-Office365-Filtering-Correlation-Id: 80de5390-d801-4c67-27c7-08dc70e1cd75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?WXNreVc5V3prNjNoTHpQdXF5RUo4d2xtT1ZkZWRyZFJmY0E3ak5xYzE0ZXoz?=
 =?utf-8?B?c2UxdmR2SWRpY3IxTjhFMmpBRFJFTTF3cVQyb2Y5QlNTOTB0YUdodGtuejRF?=
 =?utf-8?B?VGR1NUVQL1lTbGlVd2dWdVF5aFlPOC82aGJrOGNTYWg0QVd0OW5tM0V0eXBa?=
 =?utf-8?B?dkJHSWR2dEhwOFYzb0hnbk1rNnJWbEVTcmJLa3oyYkI2K0t4aDh3L0FlV2hs?=
 =?utf-8?B?aFhOVlJReHRjVCtncXRaSk5KSncxeUtzWmM4THNNZ1Y5NnhnaXpFS2RIY2Nj?=
 =?utf-8?B?Qm1YZGZlQVF5KzYvdkxvaVJWQWhUbnNSUnZZd1JabWtJY1NGZ3N2cUYvUHcr?=
 =?utf-8?B?V2VhREtIVjNNa2xpK2wzMERlazlHTGRkeGYzanp2UnRZTEVPWDc2U2Q0dEhn?=
 =?utf-8?B?NEhJNlRJcHJqcEtkZmY4Njh5Zzc3eU90RitjM0lxVHBPYUV1MXVleXo3NzZ0?=
 =?utf-8?B?Nm5qRE5NMlI1UWI1dndCUGY0d0FxUERFZ05QeHp6ZlowVzBBeGJQSkd0NGpj?=
 =?utf-8?B?KzhweFdJbENCL1hZeHhLV25GYmh1RU5BNkZyNksyUHBDcEJwNzREbWMrMk14?=
 =?utf-8?B?NzFNWmJrSVJtY2ZxN0dVL2dnczIrUlMzSGdFZjBWR0ZPMm5DeGhWQ2ZWeWxu?=
 =?utf-8?B?YnZpQTRhK3JhUkJZVkRNaGRjTmtSMzIvLzRpLzB1ZUhzQ1RQcDQ1V1B5c1lM?=
 =?utf-8?B?TnNvTU5SQlRFemFOQTBXelNidGRLRkdoZlpZWFhzeFlSNE4wMUpaRUNWWVdW?=
 =?utf-8?B?VWVIYjE1dGg3YTY4VjUzeG5YUEFETG5rdVk4NUVveEJpWWZsejNBTzdlNnhC?=
 =?utf-8?B?U1RieGFmUGk5KzdnQzJEalpua05OQllubGJNSHgxaTRDN3NvVWluNDdmeWVr?=
 =?utf-8?B?NVRnRkJueEJUNDNHU292M1F4VW5JclRCZzRvY3ErZTdIUHZDM3lhb3c1bVk1?=
 =?utf-8?B?MmlZOU5mdzNXbVFuL2Vkb2N2eldZakJhVU9VeGRGNVpPd3BuekFuenBmeXRX?=
 =?utf-8?B?MFFQVlhiVGpEdTdPZFFaSkplUHFLbzVvWExiLzUvWHF6clNFL2tCelBheWhP?=
 =?utf-8?B?dmpaRUJrT0daem9qYzNvbExxL2xRMTZaaC90UmYwMGRYZHJqRms3NDNWYmtG?=
 =?utf-8?B?aTJmT0hDOFgzTkwvN1lucjZhRkZlQUVxQ0sxS09VUndJWXJNc1UwSUU4bll4?=
 =?utf-8?B?K0w0bUdHNWVTbFZCbFd4SnZIZHFHdmN1Zml6eWxuRER3V2FITVdzTXFUQVRC?=
 =?utf-8?B?R0g2aWtuS04wa0FUZGlYd1M4UmhIMEFkTFlKd2FpSUwzYjJodXBzdUNDTWdH?=
 =?utf-8?B?aEticVI4Q3QvbVZScjJtV0poWDNONGZINzBsa3JzaW93c2RvMmZjY256SmFX?=
 =?utf-8?B?V2trRWFFSXVseFNsV0lWNzA3YlkzbjdveEQrZG5XaWY2RmJuVTdWYWlkK3hS?=
 =?utf-8?B?aE5xSm9GbHZVSjJyVzdUdzlrU1gwNGlibVZPV1VqK2krdkxEOVZLbk1wQWNW?=
 =?utf-8?B?d2NnQTdCclJ5Tzh6dnJWbGlEY0RhWlZmTHRJeUFjMWs3d20zVDM2eERRRkRQ?=
 =?utf-8?B?bGJjaVRvNy91b3lISkUySWZScDkwM0tGekg2Tk1WSXNvUkJXVEQzS3h4YjNK?=
 =?utf-8?B?L3JxYmRXUnJScm1LWTVaQTFSSUp3RlJYVUIxaGdlZnFBYUdjUE5nMTZvNnpN?=
 =?utf-8?B?Ymk0a1c0Wk9QWW9WNjJMbGpmcXdwcGxvaXFINE8wMjV0eDdGUkpGZ1FBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZytXNnhLNUJGczBITGxVWTh1b0JTWER6aThXcXlLQXQ2clF0eXBrMWhCSFhQ?=
 =?utf-8?B?V3gzZHBKYTBPQkdBK2tqM2VlQ2g5VkJtU1ZEQzJNcnlOYVdCMkV5ODZVV1px?=
 =?utf-8?B?MWtIRGFWL0pXemFCaElqcE8vTmc4WWJZdkR5b1ozemkwbjg5d0UyT2ZwWm5V?=
 =?utf-8?B?L25LNDFBOUdDOWJiUmlyZVg5aUUveXMyTjNMTDdxWktjaDY2WnFMakp2bVBV?=
 =?utf-8?B?RmxCTURWNTJRTCsrT0FSaHdVbjVMajZldjZmTjdpM0cybk15akxrSmN5dERW?=
 =?utf-8?B?MnRETmhZUHhCaUEvUWUvbDVQdWR4MlJROUdVM0Vqa3NoTWdPMERZQUZiMFRq?=
 =?utf-8?B?SWdhS3UrL290L0FmeTBxN2N2VC9wdEpnekRMWU1oME11VzR0aURJR2w0WlZN?=
 =?utf-8?B?Y2tkMkhmZE9ZVzZXK1ZFdGllTis2Z2IvSFA1NGcrMTFhSm9SUjgvS0JLbk40?=
 =?utf-8?B?TXJFNWVMYUZ5NUFwVmtnWUV1YnM2S1FKekh3YnRIcXZzUUx1b2pxR0RlY2xq?=
 =?utf-8?B?UWpjMzdpZUlyWXRWY0lnQ2oyOUwxZGsxNXhKWEZpSnJSQUEzNnUvbjFjUDM1?=
 =?utf-8?B?RjhKeUdGc1JudDFrUFFLdXZXUHpjRzF4UkhQbUNzNHhkUUtjS3JHMTdpSnNI?=
 =?utf-8?B?RDJYTkpRc091SDVmMlVDQmo2M0dQbm44WStoLys4bWVxWGJDWDZiZGpJNnNJ?=
 =?utf-8?B?NlAvQm1FWk8vR0dSUjNCT1NCTEtGNGFidkFxY3pvcEV3NDdPYnlmdkRnaVpP?=
 =?utf-8?B?QWhWV3o0WWFLZWlLUTJoMHlsV3NXZE55eXdHSGI4L0lyMnY4UEN2UVVkWnR4?=
 =?utf-8?B?N3kzeEx1UDhQa0dpZHpyalhiWkVXU0lyVWFuMUZ3MlhxVnRPRFVveTkwcmZS?=
 =?utf-8?B?UnZERWZ2Y0Y5enhpeVJxZFhrY3kzVFJzRmNzU2NlTkZhS2ZvUFZkd3BNMi9s?=
 =?utf-8?B?L2NWN2NKSUF3RGsxb3N3dUdsTWc3Sk4xN3Z0bHFld1E5OG5CNjNmR1RVbWVm?=
 =?utf-8?B?QjhMUEJFVG1XOUROaWVDdlJETnVta29MbW9lSFBvWnlHbEg1dkRVeDEvUkhq?=
 =?utf-8?B?WEVOd1pjd1FEWTFCZG9vb2IxVW9JWVdPMUJLc1B2SlBxaHIrSXRWNm0xeEJz?=
 =?utf-8?B?cDNVSUxoVWV3MUtTYUJyYlZPdkI0RWR4M0JjYmQ1ejdGYW5lTWt5U2NCVStN?=
 =?utf-8?B?VldjN1U0a2k3QWZZalpjYWVWY2FNSHdodS9jaXI2Qm5YSlNEbVZGSStFN0t3?=
 =?utf-8?B?aVd3WEpsU0swb3JiYmlKNUtRTVl5UUxNSWZkQjhoNGxWZ05lZ1JKbndQLzht?=
 =?utf-8?B?WU42M3d6TlJ2aE42bzhRbS92N05KMlFmYXpRMFJYd0NKQ0xZdzRXbjBYV3kv?=
 =?utf-8?B?VnBxWndQVnRSb1lMdmxZQVRZTzNiZ3A4cmU0dk9FZ1hYL244THR1YkVkVVdY?=
 =?utf-8?B?YXNSQjBJcXJYUlRjZlpjWUR0Z3VEaGVkRnFFR3RNZWF5aWViOUNtd04yZktn?=
 =?utf-8?B?djBZWmlCZTB0UXp0R0dvSXk0K0tFdktZajlRZkg1K0w1UDFvY3VURXlNVnFj?=
 =?utf-8?B?aUFvUHBVaEtJckRVZmVnbmZzRUpnRmE0enR0cVRGRGxYVllSd1pCVFdCbSs5?=
 =?utf-8?B?bHp4WVNJcCtuSkxzakFoWmR4MEJ6NTNtMHV6b3pucXBUUWxsb2tKbDh4dnpv?=
 =?utf-8?B?TE1BN1Jweit4YjdGZUhpMEN6Mmd1YW5nN2FFaldMdDhrNzMxVmhnLzFNMUNK?=
 =?utf-8?B?VGhhNktPZllnNG5RUWF6MTR0R1J2V3V2SE1sQkVnRGp0alpSYzdkbzd6a0Zp?=
 =?utf-8?B?bmVlelk4SGxQSEVlb2toUFlzR3p4dHhVS25TMExMa21obGQvd2dQNk1SQmRh?=
 =?utf-8?B?RTJjN1JwdTA4M3RoLzlEYnArc3BEc3ZHNjVRVlVUNEc2RS9LM2ZTUWswdnRR?=
 =?utf-8?B?eGFTM2tBbWN2a3Y5SFNYWThyWUVnOHR2NklxY1NzS2xORUlUZkZ2c1IzUFRh?=
 =?utf-8?B?SE1UbTlSSExBa3hkeUpadlM0dWRWYVQvb3diZjRtWHJvRWllSkRGK1VZRllC?=
 =?utf-8?B?TmZTb3JBNFFRREIxL2V4Nm1WUE9RYlhzSyszTVBjdVlkbkQxZm9DdXdLVUNt?=
 =?utf-8?B?Z2UyVkZuODcvZGdVaUtWWTVlNCtFbmYzSjREZ2g0RUVKUlBhUk5Oa0dmVlBC?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	r4rA8Ugb9AaSfHhh0TqXWlgYbmLbY2dxACPdPj9RoGO/9krKa6kxRl29c+vdzNPV+A6Tpnyu6rVN/7fFxs+CABsqUL3Se1G5MIS4lTEF87izdWS66h3MvKk7yj86DqtZ+scO+fjyRwzHHQuAVLICYRld9QPRuUsQNLSCxlPNQqzPxXcwhmHfZazk8RuItFh15cRVO4scuToCCs8Un5h8pgym1lO//8EpD/gXTMpRUSaMzPIk42Qs6Y71cJlOheFryBkACGB+2GB4Cqxp4b7hjLbZzTvXExdExU7SK1shKoTTU2EdZ9J5tmDx3t0ocT/eNhCxzBsV+8eyS5RlP3rbMWovu/ug63sCEjyoCEBu5NTGhA9lEhjDPl8a/yATf75RIQaNVSrdhzlvL3aHN/vFF058VIeUgdz/R8UdEDg4U2mq61AGdT2SQlWMp1vFvNKsPOmJUY/8cz88wDhxxXjBJ/tjNubGLCFp2qxNP/A6OnBVlevp6mLq2VZ+M+FFTN7fDYX3SSRa1VxHOMVXdkY898Fr2ZCZj3MfyRSWFP7hDZt01f3Un9Oa5BnVS01c5Gv0SzpKAySCO9wuh5oa6EDuKkW4ubfzWlLcvr0ehTMlxOQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80de5390-d801-4c67-27c7-08dc70e1cd75
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 11:10:29.9767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xH1/dElUkICvIH88I62TeOvh7/XprI49MhkfM3GCCpnFYKx1hqirknCfuPlvdV4FNsfq/KKTwSSNPJbvdiLPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-10_07,2024-05-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405100080
X-Proofpoint-GUID: 2hmfwb2NxFfmvwXlglotwOaqlh5JKqFB
X-Proofpoint-ORIG-GUID: 2hmfwb2NxFfmvwXlglotwOaqlh5JKqFB

On 10/05/2024 00:40, Dave Chinner wrote:
>>   
>> -	rounding = max_t(xfs_off_t, mp->m_sb.sb_blocksize, PAGE_SIZE);
>> -	start = round_down(offset, rounding);
>> -	end = round_up(offset + len, rounding) - 1;
>> +	/*
>> +	 * Make sure we extend the flush out to extent alignment
>> +	 * boundaries so any extent range overlapping the start/end
>> +	 * of the modification we are about to do is clean and idle.
>> +	 */
>> +	rounding = max_t(xfs_off_t, xfs_inode_alloc_unitsize(ip), PAGE_SIZE);
>> +	start = rounddown(offset, rounding);
>> +	end = roundup(offset + len, rounding) - 1;

I have to admit that I am not the biggest fan of this rounding API.

So round_{down, up}() happens to handle 64b, but round{down, up} doesn't :(

And that is not to mention the vague naming.

> These are 64 bit values, so roundup_64() and rounddown_64().

yeah, thanks.

I can't help but think such a thing should be part of core kernel API.

Thanks,
John





