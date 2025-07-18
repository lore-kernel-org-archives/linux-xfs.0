Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD521D7E42
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 08:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752826525; cv=fail; b=Bxl/sQLK6HsOyybe+jKzGk0wMprip/BtxNMUDz8GRbxvwBIRLOeggUFkPx6hbivnaWVbbZzSTcpmk/iLn+GCGRNiMeYmPF3K12GXMan1L6rp00OTkefmTY2xlXM1JWIDVlyO0xxJbdcg4cQuwDx39tNuO9gubtctuA3YDep+wL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752826525; c=relaxed/simple;
	bh=TKGvup+z0By4hssIRRkKHOi5KdSx7FdaVVYdGL1yMbM=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FEJld0kUQiDNbCuMIyrM7USqneLkhAOfRQfXHHeuLGOK8Yf0KSowh1Ai/iGq7hjPLcwbjZosff3ZXg6tHnkRFVrp0fWu8+ds/qvXK0rHEOxcaUJ+W1EYwFBNMShDZCUdKFtS96WsjOhQrXY14ASNqDw4ubdW3Kvf4OAz8vMof80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=re3Ki+Lr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PUmDNwTG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="re3Ki+Lr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PUmDNwTG"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56I7MqZK013170;
	Fri, 18 Jul 2025 08:15:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8Rrub9v/hRt+9BNlRQLfFAesJ9eSqsGe1CTb1oNPQ4Y=; b=
	re3Ki+LrFSJEO3/NOPmeeOEMwuHgzzTmZWCcHm65lwE9/B3Hlwe5RHDk9Ee6FN7K
	VtTrNirD+rKQQL8vmXiUNp2BAQnc10yhHgMpsALNqdDoBV+uYBR+2vi4Dlh5+3FM
	w+D7GHLjfTOL02cRGTNrEbd8pLn1aYerrflXa5OFTER5h2C19DrjSkiDrjHShz/C
	ashO9QavjwVov5h5yy4pPoBUauQiDk4YD/rZrxhz9o7nQzAXHzW1685TQtCTOfHl
	s+/Qsu3cND5/bNdAfCKOoogFqRAxxOnQ+Ofu+aduLrqXtK8cSNRfND6soe3KmYyf
	QBkPsYy9yHC1iJalgQvslA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk1b4kvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Jul 2025 08:15:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56I6arPu013024;
	Fri, 18 Jul 2025 08:15:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ue5da87d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Jul 2025 08:15:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JlOQkDVdyYitZ3ehDcKSUZzE9WTGRBc7No7YTJ2I17rX27bsAVvR57MRV0tIYqR7Rn6LeGP/qwyZbNCunBeq0iKKsBuMKmqVpT/aBRPz9FvP09RvhBl/tUtVXRizq1HByN3AFI7BS3vLeKdlL0W95DU+TlCygQZBjox3GMAJotKFhty6E+HeT7SEXNtk3IIZtLFO2B7VX0Z3zPtm2vXzNK9vjXvmLfz9qmE4QoruBTnxSAxwBh+dYMxnzUgo592Rrfg6PrcjXNqVyasn2v2BkAdZgkWay26I6EoU5gwR6dI6Pm7ZxI43iTjAwB+lD7q4FTzJGSmcbMY0A4vVjKsnfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Rrub9v/hRt+9BNlRQLfFAesJ9eSqsGe1CTb1oNPQ4Y=;
 b=adcPuRdzPFb43CNLOqVhkfz2H19X2ewowQ9qsKTnPUs+nJKSFiSh45dFw6ukhIims/2WzEfqWlC6G0zrw5sYMFLnB+UkZjIFoQLq8fB27OFdNE/ErElmHns0X1ZAS3csWaCsqP+TT9+pLBdLqLuCJOzl9XsEu1zL2ChB4pwmVPx8NM8W3bUVr/K3SdkyOK5yVhVWgfruzB6TqYqHJVE9IFqlHCttiW0w8WiOsNoWpCzLU+Ism86TnSUUShPsPnpH5VZunYPaXIwajL+QxIRmL9YKKE7vs9v3cmNKNhmuj3PQR8Wlp1aqMIsSy643HTagmMR77dptwb+IZurZ4U/9rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Rrub9v/hRt+9BNlRQLfFAesJ9eSqsGe1CTb1oNPQ4Y=;
 b=PUmDNwTGUOlFHCo7xQB1y2uxPwC7G74KogQYraLBBAY/4aQnFDfzs5bGsEn54kN2pRxEWlmAADR+s3uU4zXxm8KEclswNuvgItE0Zf91FUZ9dj8sV2yym/A3te6WzOOGq8aydsmTjKWvmq4FocnSWbnjUctsVW6YKbOm1GPvdUw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA3PR10MB8489.namprd10.prod.outlook.com (2603:10b6:208:583::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Fri, 18 Jul
 2025 08:15:09 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.037; Fri, 18 Jul 2025
 08:15:09 +0000
Message-ID: <1b61ffa1-870d-4b30-9ba8-014a9ca5d33f@oracle.com>
Date: Fri, 18 Jul 2025 09:15:07 +0100
User-Agent: Mozilla Thunderbird
From: John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: disallow atomic writes on DAX
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
References: <20250717151900.1362655-1-john.g.garry@oracle.com>
 <20250717160255.GP2672049@frogsfrogsfrogs>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <20250717160255.GP2672049@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0015.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA3PR10MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e3d77f9-ee6c-47aa-ec8f-08ddc5d335fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Wld6cXdHNE5zYThtMkZEdlVQZXp1dXF0VWVxeHZQL2Q4bTlRNVJnbHhucTlI?=
 =?utf-8?B?aXRLVzBqMGZFTVRRRmVxOXFFWG91L3Vwc1k5Tkxha1plY1A4dXNNdmRneVY5?=
 =?utf-8?B?aU5menU5K1N6TklnYjRLM29DQTIyVlBxTmhNMFJVOTVuTTdWbG5zNk1HYjNy?=
 =?utf-8?B?UXphSC9ZZkxYUHYwTzJSSnJWRmFIMUxKTndaeGNLanBrb0gxN0VTd2JObGZB?=
 =?utf-8?B?clpRVFhXWmp0VDF6aVZUUUlzOHlwTjVxbVlmQ2wwZFVuL2pyczUrSFVENWc2?=
 =?utf-8?B?UXNtT0RxRFhvZGxWWFB0Vks1QncrdHduaFUrQklCZHhRZWhQTjJlNEZiVTV2?=
 =?utf-8?B?NG5kQ2ZJNXRzLzNFdmxmbkFXMGRXUmh5Sy9Zemowd3pGellwcksxbzRYUDRS?=
 =?utf-8?B?eXkwYmJ4SE9MMWVhaDEvamZyZ3BXZi8zWUswdXZKVXpQbEpNTHU4NWJSY1M0?=
 =?utf-8?B?SmJ4aTBzSW5FSzVlY2IvNVRkR1RYNlhicUwvSi9TTWU2dnpEZk55ZWtqTk1S?=
 =?utf-8?B?eUtDRmNsNDg1ei9EdUUzZGdxd3FXRFhKRGxoMTc0cWlydlphNUFIQzloSUwz?=
 =?utf-8?B?emxQUGFjN2xSQ1EwbDlPcE41R21QenA3bThIcGp2a3h2STBETXFNazBxY0RK?=
 =?utf-8?B?RG9QdUU2R0xHejdlcDdJZzBrYWtDOWo0Z244UDQvUFlRUXo5eDRwUm5LQzdJ?=
 =?utf-8?B?WGFidW5Ydm84WE9lc1FBaTV4ZUUyeGhWZ29jVyt4bnZiSnJ6OVdrSy9PRGx3?=
 =?utf-8?B?VnFPVkh1Q2pvRG9aVVdhZFVuZTFXOHBMeWxDMUxJTEduZUUrT2o0UkRyNUlS?=
 =?utf-8?B?eXBwUXZpVnFwbEpZQ050ODZRcFQ5SkYvZGw5Y0E3Z09rc28rWmE3bkxJbStZ?=
 =?utf-8?B?S3loZmtxQTVuK1l3ZjloVW1QbHQxOWl4Yjc3NHlvUitzT1Zrc0V2ejVocENS?=
 =?utf-8?B?bkV4N0p2d3lieUV6dmQvT1FQUEV2UTduRXhDSVpNcWJxK0JrSlJEWkxMWCtW?=
 =?utf-8?B?aFRxTDVad2xQdmZ5eUUzby8vQ2VYeVpTZ0FKU1o2aldaTUlZRVZuMGhGTHl1?=
 =?utf-8?B?cG93N2QwcDR3Z0ZIZCtya21ycGtSaytGRXBtcWxaS29HRGJIbUZRdjdPalBm?=
 =?utf-8?B?Zy9tRlh2YXR3N1A1N3pOVXEzZUl4WmpMczBwbzdGQTdTZTdtZkR5cHFHWXg2?=
 =?utf-8?B?dFJuekhzRkF6bVRzMzAyMWNSczgzWkVkbldtZDcrb1Vka2JFZTRHWVJPMUFz?=
 =?utf-8?B?V0svNGwrUnp4RWQ5cE5CNmN3aUZmTGk0ZjZKNUpXUmFQZ2xWSE9iV0IrSWEy?=
 =?utf-8?B?Rmx6OWxIZDhaNGY3R1pHeHkrOFdRTlpHMExTUUdGYmEyL09lemRmdHBKbzNw?=
 =?utf-8?B?TlNZNTJvdTZVNkhkaElNSldvYXJLRURocktZN0VoMFkwVlBkZXVPa2tmSjZs?=
 =?utf-8?B?OXZkM0MyVENWa21abWdHTU00dWRQTThxczJ2d3pWYWljbkZRNTE5aDZ3TklL?=
 =?utf-8?B?T2M1cUxUQ2dGZGdmQTVwb2Y5MXJzU3JOWmlzdnhCNGZ1TGRkQ3REd28wSkpG?=
 =?utf-8?B?MmZXZ2dJRmsvV3dSN3YzcTJBaWpEMXJYUGpDTUZ5RFdMNVFJMXoxeTczTlpJ?=
 =?utf-8?B?UnNkYmhtK29YeVc1bmVqcWJ1czZrVjBlZW5JbGRLNlU1N0h1ZUVQemVYa1JX?=
 =?utf-8?B?SmFiU1pidUV3endKRDFzK0RkUmhtdC9kdUQ2SU1yQTV1ZC9FOW1PM2V2bDBk?=
 =?utf-8?B?bitZTXhySThidStZNThXV3hwL2p4Y200VnpWZTgvM2txVlh6MzhLM2ltbUZK?=
 =?utf-8?B?Y1BHbGFBdXl4a29McEZXWXNreWRISHJ1NFZFeStNVXVHSVhyOFBXSzBCWC9r?=
 =?utf-8?B?UHd1SVZhR0dnajBBak5VZzBoVzFiZ2hudzlqV3E3ZksvWHJJUmZOVVJjUlFn?=
 =?utf-8?Q?IEzorRAeCuw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHUzRzhkK1lNdUpJM0cvb1lkam5EZ2NYZWNsQktyZ1dCOHkrYmx4L2Y2VGNF?=
 =?utf-8?B?QWVtNXVXTWpkVVhTcHFjOGtOenpaaitCbEx3aWZDVnQ0d1hWRjBHb2NCVEtV?=
 =?utf-8?B?T1IxM3VSZlhmNkVuNG5LdmtRR1prNTdKSDkySER6NTVWTThvQUp4cnl2ZXdJ?=
 =?utf-8?B?cWpiVTd1VWNMUS9Ub3pxdFFMb2NKcncyM28vV0hVTDVjL1k5K2xzZU44eCti?=
 =?utf-8?B?YmljSFhYYktYZ3pnaEtpSUQxNnVRTmFaTlBZWFVzSTVNRTJXL0MzeFptZ3gz?=
 =?utf-8?B?d28xZzVZT25BSldoWW1nRVRQb1liNFhsNlg4ZHBWQzMwVFRhZXZKbDdoWjlB?=
 =?utf-8?B?UEg4NnB3dE9jMWRHNUpMc1JVUm40UjEvKzJwMTdXQ0trdEt4QnJxR0dsWDVn?=
 =?utf-8?B?M3A2dDRHU2k5VjNyNTJ3SmxURHRZZ0JOM28zZzI4RTdwbkNJeW55bFkwOGtz?=
 =?utf-8?B?cjgxR1hJb21KV2gvaDQ4UlpLZ0RsMnJpL2wyQ1lteDlDbUhILyt4UzFaYy80?=
 =?utf-8?B?TWE1aysxVVVreUdvbXJKU0ZEaUhFT0dKYTN4Vzh2SUlQdzF1dkFpdWxUa0or?=
 =?utf-8?B?VlZVUGhVeEd3REZieldvRytqM0lOUm5Rdk52N2dRdEVLeGNrcThwTk9BVTM4?=
 =?utf-8?B?d3NySnZMWC9iNjVhbmxnOExOdFI2cVlVM0ROZVFDM3RHWVN4R0RCckVPSS83?=
 =?utf-8?B?bUc5bjRhSzcrTlE1OFcrUFI2OWk4N21LWlJudkZPZW9yMVNVdUJxTW5RTkNX?=
 =?utf-8?B?MUhPWGxVWFhvL1NCc2dZYzA2MjNoUGNaZ0o0dS9RaUloUVEwdjFZZDhudTZr?=
 =?utf-8?B?TkpMUnFCc1gxbDV0VWY2SnhGRTRDUDZjNCt4M3VoWldQUlNBenlPOWF2MWJl?=
 =?utf-8?B?dDlzTDMwRkU4aGVXaVFPaXNxNGpCd0s3emdMUDZqcjNEN0tBc1ZqLzlycW5u?=
 =?utf-8?B?OGpjY0JSV3AvMEU1czdwYmI1clNLL1VKa3NMWmlMNms4Y3lWeDY0eEp6bmVP?=
 =?utf-8?B?MWI2VXR6L0Vkc3BXQlhCNDB2WWlsMG1kMXREOWtRVURQOXJnMGhRaVB3VFll?=
 =?utf-8?B?M0FiYlFVYTdXWHdzaTRLN1BIa1prWVZldWdPakhMdWhOWFdPZytLRUpnRko4?=
 =?utf-8?B?ejhBaXJBZ2dGc2l3eTRHcGxDS2RERHE1Tm1NUDZZeVZwajd2c2tTUmtVRTdC?=
 =?utf-8?B?dHVHN3NLM0VxMVhFRXpWT1d6ekhGaTYvMEpUWjJBTW8zMEMzYnFJVWIxaWRn?=
 =?utf-8?B?akVjaXRNVFlEcE1mdXNYTjZnUTdaQ3pDTzZobWE3bWRiZy82dUFQcVVibjFo?=
 =?utf-8?B?ejExRTY0OWVpL1BqSTFkSWN1YnE1T1NYdnhuV3lxcFFuSm9MTVBqRW45NDhk?=
 =?utf-8?B?aTZ1N2xZZWx1b2JUTzRSc3lKcVNTNEpYbTZzYkY3ZmFYTXpENDZVMmZhZFNa?=
 =?utf-8?B?SUJ1RTNyRUx5U0JnQ1RzWWNTSXZkZUY1Z0hkcjZSQncxZ21qL1ppbWJySENY?=
 =?utf-8?B?UmRyU0hyMDIxZ09OVllIZWlhOFIxd1JVT2RYOVp5dmZDMkxuM3FmK0dpMkht?=
 =?utf-8?B?RWQwajRpN09vbFRVT2lVRkJMZ25veTB0VDBTMDJUN2hXMnEwWGtVSWxLdm5V?=
 =?utf-8?B?ZVlkcDFqNEIwLzY0QWxDYmR0b2RGc1Y1SWE3SW1yVEdUd3BiK3NtTjZKUGhh?=
 =?utf-8?B?S3pEMlJsSURDaEduWXhsS29oRUtySk9ON0pLTU1temJkV0lIam8rUEJuUGIw?=
 =?utf-8?B?ZUExZVJxdCt4U2tNODVqelZBTGlzMkRJcTFPbEZvdjFZVTRGdnY2cmwremNM?=
 =?utf-8?B?MFgvZDdpbFFNSklOTGdQRE1EOUp2VncwQitxZ0lZR29HUHhxVmxSNHhseDBE?=
 =?utf-8?B?a3hza0N2eEl4d2tlQWFQV2RmSnNsVC9GODlLbHhpcVF5Rk1QUWRIOVZhMmdT?=
 =?utf-8?B?d2FuNi9wL1AxOU1XbFNpOUxFbnFXczMveWExLzRIUmZweWttUTlNUzVKOFEz?=
 =?utf-8?B?WG1FS3NpSVM0YTN0NkJ0dGY1d2l2eVliZjRqdS9rT2svMFV1MThEbVpLbXd5?=
 =?utf-8?B?TlhhaExGUE5sTi92dnpZWUxLWlVTdTFQd3M5Z3BHZ3hSUFhPemxyTGQyM1Ro?=
 =?utf-8?B?OStsZk1Hc3pDK3FzWk9MSkN6R2FLME1KZS9neW1kOUFTWlpqRiswN3Z1OE4r?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c6Cqr1GGf0XTvmKS5Mc1QHTR1npZVzAQlDoI4HrzUCvEz6VsGlWL2kATF5XlQ2eCVqftuq+K/w0QQuj65HtLIL0fqtXMpwpVt+INE3U8Lvyhxq4Hd2XD2T3QFSTSX3PRHjOOjBaodtsUZasr8FfKEpQCajUhLJecv0QdgrljIBFFPFkDkArsmaRUIxmPx7jU48AZBkvNgX9lnavV+yxES8N4hh4UfaMJohR3xfrwtFz0XyjVMhz9pY5SCwv9OvSWk2i7IXp1PnhrsGllKI7CyOQCMuzta6NS1CBNyncrqKJ7zBxGcMDBKzK/gKhHZbrsH2hSPuMie0asuoplCQafN+Yhlod49mr5tmLcsaPgC8myUnIebTsLoqOYqtlrHAC3RyPgR2x3v3CO+xv9MleLQLOC3RFr7qZr7+fRps72KNG85Zb2y2mqlOjCfDsQ5YNrrezwA6Z/ef1PP4fCGr7v2+JYoc2EcuprVn5jTFVal0Itf3YBrLXPJMUC2G44vGC76GFzUKi8VP7BZHx52fIQg+RRs9rDYbzHNd4ZaQeJyZyUra2gGnPWqiHlNvz40jUza+s7mgKAs8wF1cNqfABHdVipUNSoCq4jMjc1xHeOBls=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3d77f9-ee6c-47aa-ec8f-08ddc5d335fa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 08:15:09.4829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FN/Gw/cCoZAEG+90qT0VvXCZKAb7OrQke9CP0tGIERS1qi8wNE2KL1NFnlQOEjmPPdqu7lD6P6donB112OzMSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8489
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-18_01,2025-07-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507180064
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE4MDA2MyBTYWx0ZWRfX7lJ7coDpIaW5 Z28GCVEycLMv9LDjRbOUauo0wxVNHTU2D6ORaRItp8x5ZVlB0x+iA7YP41QMIafZMAkM5fwK4lK +eNUjVm2tsCygrUmJVZQ2nMFV02IumkH2QrESQUwn8tEBy2gE9eNg+QBRufoAfoqkGfzD76SDqO
 +3jjhR+ngxlyWnI+Y0fciTC1xRaN0i5mimNk5RIVpQEDnaQZDXY02kq7wpb7fVf8HTcx0k0RlRM qvFX3nF20WMWJE0MjKeq11FeK8MiO3QFj5ipACyuU5FLGUvRrqLbUwBCaZUyXxfvIuDl0ZdZUBx PJ0NejJdMY5f9vf/IE/Rjy1bWJ57U6p+r9le+xiYePjmLdJVpVfOJgbqCaHliJCgNYVOwlckZ5G
 YYaWVVKK+wLU9NjjhArdL8dalVuh94Oeo+LhhxoNf4VcSWOuLxLWNXSDhFY7a/Tw7xU/9fEx
X-Proofpoint-GUID: sAEKW-1F-CjGeM4H7oSCfQJ6jjOHlXkg
X-Proofpoint-ORIG-GUID: sAEKW-1F-CjGeM4H7oSCfQJ6jjOHlXkg
X-Authority-Analysis: v=2.4 cv=J8mq7BnS c=1 sm=1 tr=0 ts=687a0295 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=K6CpYvCNbD1OAp4fp1kA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12061

On 17/07/2025 17:02, Darrick J. Wong wrote:
> On Thu, Jul 17, 2025 at 03:19:00PM +0000, John Garry wrote:
>> Atomic writes are not currently supported for DAX, but two problems exist:
>> - we may go down DAX write path for IOCB_ATOMIC, which does not handle
>>    IOCB_ATOMIC properly
>> - we report non-zero atomic write limits in statx (for DAX inodes)
>>
>> We may want atomic writes support on DAX in future, but just disallow for
>> now.
>>
>> For this, ensure when IOCB_ATOMIC is set that we check the write size
>> versus the atomic write min and max before branching off to the DAX write
>> path. This is not strictly required for DAX, as we should not get this far
>> in the write path as FMODE_CAN_ATOMIC_WRITE should not be set.
>>
>> In addition, due to reflink being supported for DAX, we automatically get
>> CoW-based atomic writes support being advertised. Remedy this by
>> disallowing atomic writes for a DAX inode for both sw and hw modes.
> 
> ...because it's fsdax and who's really going to test/use software atomic
> writes there ?

Right

> 
>> Finally make atomic write size and DAX mount always mutually exclusive.
> 
> Why?  You could have a rt-on-pmem filesystem with S_DAX files, and still
> want to do atomic writes to files on the data device.

How can I test that, i.e. put something on data device?

I tried something like this:

$mkfs.xfs -f -m rmapbt=0,reflink=1 -d rtinherit=1 -r rtdev=/dev/pmem0 
/dev/pmem1
$mount /dev/pmem1 mnt -o dax=always,rtdev=/dev/pmem0  -o 
max_atomic_write=16k
$mkdir mnt/non_rt
$xfs_io -c "chattr -t" mnt/non_rt/ #make non-rt
$touch mnt/non_rt/file
$xfs_io -c "lsattr -v" mnt/non_rt/file
[has-xattr] mnt/non_rt/file
$xfs_io -c "statx -r -m 0x10000" mnt/non_rt/file
---
stat.atomic_write_unit_min = 0
stat.atomic_write_unit_max = 0
stat.atomic_write_segments_max = 0
---

I thought that losing the rtinherit flag would put the file on the data 
device. From adding some kernel debug, it seems that this file is still 
IS_DAX() == true

> 
>> Reported-by: "Darrick J. Wong" <djwong@kernel.org>
>> Fixes: 9dffc58f2384 ("xfs: update atomic write limits")
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index db21b5a4b881..84876f41da93 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -1102,9 +1102,6 @@ xfs_file_write_iter(
>>   	if (xfs_is_shutdown(ip->i_mount))
>>   		return -EIO;
>>   
>> -	if (IS_DAX(inode))
>> -		return xfs_file_dax_write(iocb, from);
>> -
>>   	if (iocb->ki_flags & IOCB_ATOMIC) {
>>   		if (ocount < xfs_get_atomic_write_min(ip))
>>   			return -EINVAL;
>> @@ -1117,6 +1114,9 @@ xfs_file_write_iter(
>>   			return ret;
>>   	}
>>   
>> +	if (IS_DAX(inode))
>> +		return xfs_file_dax_write(iocb, from);
>> +
>>   	if (iocb->ki_flags & IOCB_DIRECT) {
>>   		/*
>>   		 * Allow a directio write to fall back to a buffered
>> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
>> index 07fbdcc4cbf5..b142cd4f446a 100644
>> --- a/fs/xfs/xfs_inode.h
>> +++ b/fs/xfs/xfs_inode.h
>> @@ -356,11 +356,22 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
>>   	(XFS_IS_REALTIME_INODE(ip) ? \
>>   		(ip)->i_mount->m_rtdev_targp : (ip)->i_mount->m_ddev_targp)
>>   
>> -static inline bool xfs_inode_can_hw_atomic_write(const struct xfs_inode *ip)
>> +static inline bool xfs_inode_can_hw_atomic_write(struct xfs_inode *ip)
> 
> Why drop const here?  VFS_IC() should be sufficient, I think.
> 

I dropped that const as I got a complaint about ignoring the const when 
passing to VFS_I(). But, as you say, I can use VFS_IC()

Thanks,
John
