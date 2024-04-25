Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F9D149E0B
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 13:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051498; cv=fail; b=qs0rBsqsfa9KgNGZFaGWVkNLGAJHu1lHFU4e+2JaneQC4/M3okblWi93npyCAW+Ryx1OHI1iuPHD30PxHGcEels/pgMNEwu7+/I3utMkuNLoS+l7iJK/8uVV0xDwHC+ZvLAXyGTjm9XfKUzCfDdngBigyz05ARhWFUmUistMZcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051498; c=relaxed/simple;
	bh=b7aWKwH1MQFYDK/EkD156oGmIn2iT9CEE/POJVeKSyg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bCML2G8ztNBPIeyjNWx+p+7i9gEDoKmhqQoKamlg4PC45V/ik70hBV2sNwvKbDxFodHf/1EZ2T1Sf3ZhAADf4FGSA89JI5ZyUJG5UgKqb8mTYx4LPW3D+yu1R/OqE7Ga/HN1+JBSIU+g6qZXZv7mt9chTizjafczuuegeq7Bstg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DEhHOFM9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JI8ic4b2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DEhHOFM9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JI8ic4b2"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P8uT0C017708;
	Thu, 25 Apr 2024 13:24:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=dz6ZlUknVeps9w+cJqY1H1/hODANwJcvvwxE8ARADxc=;
 b=DEhHOFM9b1Bvvs8ral2DshCXaUbWpvQfm9YKtVDS8c+9g8UOEtiOIomVwPX0p4Z3Tvev
 roz/VceEutITc0yNmM3qEBESRBp2F/ECBd+Q7JejzeGfKwOk08Zd5Arx6TLM9ruEQxNv
 ss2um10zFYhAoVVxG3apCKnEceAHD5VE80P7M0L+A+kQhBeOM4WCfTrbdRuEAGzQjo/9
 5CJp/wWZdROgApiOMM/P6sXw9RyBQhh67iKxaL4Ip6b+7JzHMpY0ATiDs3orUWyWVCls
 2loUnPRal3wCD92OkP/eD4CySIWOREOb9uH6cnQF4ZfmO7wjGcFB7rlJND8kgeyP7vbp uw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm4a2k70f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 13:24:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43PC21NO001912;
	Thu, 25 Apr 2024 13:24:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45b0h2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 13:24:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeSGgI+Lq/J+hVVu/3I3ryZ31n3VDvRi4ZsYTxQSf5wy9R9ij5hZwxE/Cy0smPl7h9FrrpOOBmieilYSaIXnfqaIOR8/vSdcY8bOire5ATSlWPt3DWp00LZuvnj4nw3v/+Z5bk6IvNKEGn98o7LgGLzSiQzy2U8M+fBMu7746VXXc6OT9Ouk75I/OCE6+3pZthUVDlXjn9TYNJJoIHcrtAJwBmfqQH+dzlnkNXL0ShlhnoTC1/Uq+f2U3dogXhP3sf/WdVLtqj5Dgr6fu2nNDWYTfEF92IzNbiGk4JF6g2Fo6TIo+7rZ8nxIxCH6Md42WB9+R3Dx45rsZzrBp9sVYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dz6ZlUknVeps9w+cJqY1H1/hODANwJcvvwxE8ARADxc=;
 b=g+7iHCDZbUiNqr1egKwWQIjTc1NTO8a7dvsuGsg2EGhIvUzUyCfOk7h1oRYpFyATV3Qopj5Cp2Iwc2gtwxo9IKiBs3rS3Bzf5hdEjBKlnEI2XTgg5JXrLuR9gzAFt0qzinkt9FAxort97PHtgq1q5SSwd1BKyNCV3R7qRTaFKPHO4v3vhBt2PxAVmPXvS2qlm4wK1gfj2CTxhGrr7Sq7/cS+9U/Xe/4bq1mUX5WjDAfzmeXD64A1wIkPM/5hldPsClb9LIZlV1m0h3gQnZyWLLkckSYxAgYGNCrjb0LCcsZpS07X3JuajpVOw7n69tIza4h0qxealpxCa1tTGwCutQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dz6ZlUknVeps9w+cJqY1H1/hODANwJcvvwxE8ARADxc=;
 b=JI8ic4b2HxPOWpCk6VoRlqIX5N1+cH96wjiV9cgVUgFpYaGpXnVVj5IghcDuvCtWbkcsE3NMVfAwNsl0cWXtY3h31bBxqwSj6IP1/xZU/ogmHv/ERFpiVcaP6WWPE1s3xmWDWj1JAM9HMkmzjWq6PrHaEcI3BIaSVBsVAc9ja68=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6881.namprd10.prod.outlook.com (2603:10b6:610:14d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Thu, 25 Apr
 2024 13:24:38 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 13:24:38 +0000
Message-ID: <01b8050a-b564-4843-8fec-dfa40489aaf4@oracle.com>
Date: Thu, 25 Apr 2024 14:24:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: Clear W=1 warning in xfs_iwalk_run_callbacks():
To: Christoph Hellwig <hch@infradead.org>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org
References: <20240425120846.707829-1-john.g.garry@oracle.com>
 <20240425120846.707829-2-john.g.garry@oracle.com>
 <ZipJ4P7QDK9dZlyn@infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZipJ4P7QDK9dZlyn@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0211.apcprd06.prod.outlook.com
 (2603:1096:4:68::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: 2330bb56-d128-451f-73b1-08dc652b0e3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?WlQzUER2eEM0cWI5QTE5Z1R5aEUrL01hNmhwZWNTYWgwVFhvYXF5V1ZxRnlj?=
 =?utf-8?B?R1Bxb0hrVlhYWEhHWFNhVExtNkF5VkJVTjg1Qk1WTHBtdURZOGRhRm5hN2hP?=
 =?utf-8?B?b0lCeGNUa2x1d0VPZGNCTVp5cnJ3aXRoS2lodGx6cDBuakVVYVhKR29XZmFh?=
 =?utf-8?B?L3hvaU52WmN1WEhzb05GOGZZMDFXUklJMldtaVZpcnl2d01JTXFYc0Q4Njhs?=
 =?utf-8?B?OVZkSENXZEZVUUw5SVpnUTBPTXRnYWcyUCtScy9HTmtUNnVOc1UyK21LT0da?=
 =?utf-8?B?M0NZOVdZYlZEak56SnJXVGNaVDk2MC91dXB2M3cyRHB3Z1pqeTJCb1o2RUdR?=
 =?utf-8?B?TlY0ZklQa3JkSmJOaTNqb3dpb2RJK1Qzd21zeEhTT0dnVCtzc2ZidmZsZXhN?=
 =?utf-8?B?U29laHplWlZISmg4STJPRStjVmdSZlJZVlVVQ2FxcmpOT2RoZ1VpenZXclI4?=
 =?utf-8?B?ZmFrNjBJd1VuK1pvUS81RmZVZm9VSW9rYUhWbWZRZUl1VHhYbVRqeGpad3g1?=
 =?utf-8?B?ZUQ3b0hPUU5jWkNNZjlDeWd5K3hPTldLLzQraTJTQ0t6TXAzQ3V2RXpjdUFM?=
 =?utf-8?B?OE9NYkdXR1hLUzExTzlDeVpQWG1waXpGSlkwTkpxL1pMZVdUUk01MHpQclhx?=
 =?utf-8?B?VmFaV0xrZy9XU0dNSWpwNTJHYkpUa0tQQW9wY0ZkbGpvVnMrcWloT0E0bjNJ?=
 =?utf-8?B?b3lvNGFrcTZFOG5Qc21yWVF3USt6NVlvbU03aE9PNVdkS2tzSllYdnNIVDNE?=
 =?utf-8?B?N2I5OU1BK0k1ZUprSEgxdEFiYm0yaDFwemVscTdQMXMwekcrYTJVQXdXcUFp?=
 =?utf-8?B?VlN1NVJnYThDd1ZCL3FId2prb2JGRUtzbmJLbUVaNW1semljOGtMSGRwVkUv?=
 =?utf-8?B?b2dWT3hIMVBRZkVES28rMWtuSS8zajlBaDRNSnZnQXZNSmdiNGJ5eVRJaUxR?=
 =?utf-8?B?dHpKMmtYeXlxdi9lMGlRNnkzVnU1dXNOME1PSEZ0cllUdGZQV1ZINDcrem9i?=
 =?utf-8?B?U0RpOWxLUEpVY0xlVnNSb2hjU0wydGhoYW1iNDRaNEVlalFXV0JqakpvUmsz?=
 =?utf-8?B?ODVMeWdaVEQrd2doUkRyWERDQkg5My9FcnQrVTFSRW5wN0k4NEIxcFlhTXVT?=
 =?utf-8?B?ZENDOVNYNUpXQlEwaE1neG9FWDFNSHNMbXZsbmZDeHhIRlNtVUxVaW1FM2o5?=
 =?utf-8?B?VTg1dFE1bUN0WXJlMFpEMHpNbEtjQnd4T2VLUWt4dUFCa3pYOTVGOTdkUzJP?=
 =?utf-8?B?akFjek1FVjNOUWowZmNKeU1XMHF0MzEranlsNjJGRWpzeitUclhaT3g0eDZE?=
 =?utf-8?B?NXh1a05KdWx4cHYrNFRvaHByRTdPcm9RckVkTWc3QUVOM0QvR0N5WWhPMmVZ?=
 =?utf-8?B?U1UyZDlyUXNlRmQ5SHNCdEw3UUV4Nnh0bXFianM3RzBVTmtqSnBRY1MwS1RQ?=
 =?utf-8?B?LzRHMjQydlp6a0M1VzRDYWkrVXVGUUQzemxlQXFXNmpmbWNhb0JOUUQxZ053?=
 =?utf-8?B?WUNlY3lMMnFMdmlMa09naTVMK0ttWDVzSGNRQkEyVVdoOG51eTJVWW5uTXhV?=
 =?utf-8?B?OXQyNHQySVlKbFhHaUp5cGJ6eVBjZFFoWFR0MjQ4ZU9GZnVRdDVqdWJYbzFr?=
 =?utf-8?B?VFlETVNFSWxhNWYzcGU2ejluUkhPMHZvcUtDNXZZbm05YnNXRFRrS2VFeElW?=
 =?utf-8?B?NHdZTXJieUJFWHdNQW5JcnkzRVdBQmgwZktNakhyd1ZjRi9JUW9CaUVnPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cCsvbjNFWWtqb2hmbldmWVQwUEs1UWppVXBZMlRhSWpuQmZZMG5LaWt4N0F6?=
 =?utf-8?B?Qm9XK3dqRGdOSU5FWnc4NnZJUnFzaFBEZHc5NEJ1d0dXVURZUTNLek1ITzNV?=
 =?utf-8?B?SDV0TlEyOHI2UHU1VmJiUFM0eVBaaVBDNlRzektIMTJzdGl2MkpIUnUwQXE1?=
 =?utf-8?B?OUFHVFFQMnNkQjJFT1hZZmhucWYvM2JpVVR1dU53SERMOEFQUFBWb3d6RzFB?=
 =?utf-8?B?VGt4ajNLTzZzWkxhTEtJaUF3WUtzNzJpTVBDSmh0MitWdzlyRUhtd0JRcWVw?=
 =?utf-8?B?UnVuNmZNZG5lMWQ2MjA1K05HK3FzWnVXWUJ6QTRiZkxaelgwTTB1TVd6NE9o?=
 =?utf-8?B?NlZRN1J6VmJva3FDeFlmeGM5a0t0QjhTbkpOL0h1aU9mVnVzelpISXZSL3pt?=
 =?utf-8?B?NEp2RDg3NzBLTFIwbW9lTlBCNCswY2J4RE1KeUxWeHBtMXVrb01EUUt5MDVo?=
 =?utf-8?B?Z3grL3BYUmRaWnFVUGExczdXY2VJczhoeS9yMXNIUllMK1RwVGxOQW1KYjZD?=
 =?utf-8?B?bkh5a0NPMmJUaitvbHV3MWhHd1hVZmxqeDBCQ2o1Wk5wUFl1Q1VVaE83Q3hl?=
 =?utf-8?B?VVY3L1gyUTdLVTNZb0tvU2RMbEczMWJIK0FTQzdhWWJLNDQ2eVpiMGYvYkpT?=
 =?utf-8?B?eHhLN2FUazdvQjl1S0d4dEZNU1dxNFZTQXJoT3ZCcUQ1dktXeDA2U0pDaWhP?=
 =?utf-8?B?WGlXWEdzZ01JZlFXa0VnYkorT3BkbkIzT094UXhXVy8yUVJTSWI2YjdwOXVh?=
 =?utf-8?B?TDhiODFaTHVWZzd2b3Qvc2piOFNyOHRWUEZqTkFjTTFSZVpRYlhHUUFnZnJa?=
 =?utf-8?B?L0RVVlYwczdTRW5YQ0tCTWZtMzQ5REJaMyttd2FoMFh2ZWIrOFRzOFpROHEy?=
 =?utf-8?B?Q2pZa205SXhJWE5zeFJnMFdmSS9QR0xLMlNRYjFTMHRoZEV6UWF6L3Zucm1i?=
 =?utf-8?B?Nm5JajdEL0JPdWQrelVoTmo0bHg4KzZJUEJlYlVvS1FIcU83OFNSRmpQVndC?=
 =?utf-8?B?bDJZV2RBK25MQThmUjdLckZCc1RaWEx2WG9lNlpzZFdQKzhVMmhDT3ZuSUZ4?=
 =?utf-8?B?bjFkZDdUVVNHT0xYSjM0bFBHM0gzWnJzMjRqdDFLVXI2VTk3OExJdXpNWDZC?=
 =?utf-8?B?Q1NXR2JGTHozekJYbjk4SlIxZHZzaHhPOU5WUmg0SHBFOWpWbjRDaFZHWUtD?=
 =?utf-8?B?cjhSR3cwT2JiUGlxOWZMbkxWWUFtUnlIc2QrOUFuV0E4M3NvTTRFSkd6NG5R?=
 =?utf-8?B?R09HbGpiU2FXL1dDQkVxV3Z5RjVkRFpVc3VNdzRpcEVXVXVNVVR6VzFHcmll?=
 =?utf-8?B?TGh0VHZ0QTBCTmRjR0VtM1hsSzYxZGRLQURjdCtDOWZxWHRpQTNnbVgzSWFu?=
 =?utf-8?B?V0FhOFd6OTZmbjJvZnFqR1ByWkhUWlhoTldveXhueE1nbUhnN1pnR3NhR1pj?=
 =?utf-8?B?Sm14aVBYc3JQa3NlOHRjUWd0cWFZTDZ2M1dRMndPRHZCRDJJWFUxTno2UGZ0?=
 =?utf-8?B?KzR3dnFva2RGbFljOVZ5UFNJQkpKcGYvT05zL243M1JYL1JEai9NaTc4R1JL?=
 =?utf-8?B?KzZEYk13RFdhcW90eElsVnJ0MHJCcnk2aEdNaWsxdjlBR01TdGZzUFI5ZW5X?=
 =?utf-8?B?NSs1MXRwWmhyN2p2NmZpOG1JNzZNM3J6MVVONWRtazRmeFppYTFybzNDYlBU?=
 =?utf-8?B?TThTOUdNbTA4VTU5Z2dmWHdqalVjNGVqVTE1SGh3dzNhbmxvRzR6NjZYYmxX?=
 =?utf-8?B?ZkZqRVhQbWJjNlRCWVkxcUN2eUxMTCtXdUNxMlVKMjlnU3pOczY4d3ZRdjVs?=
 =?utf-8?B?RjZ3b051ZGJMSldJaUdGNHZiNmdWa2F3SFF2a2N0K05qQTZCUWlYUEdxRTlJ?=
 =?utf-8?B?UW1OSUZSSCtQTm9naFZKU3FYSk9SNVRXL1RiRUhNNkszNG1YUlB6MmdTbWxI?=
 =?utf-8?B?QXo1OVN5bnZTUzMyWGhCM1JYajk1Z2oxSi9ybDFmMUxHODIxMUg4djB3Mkp1?=
 =?utf-8?B?d2JBOW1vYkM5cXU1elgrVWRYWTZBeExabXZiN0pSRytCb2tMNU1lVlVVT1ZT?=
 =?utf-8?B?QUJRdzV2VVZkcTVCb0ZGMSs0WnFTWkNpNjJ6dTZKdTNXejVWNEhrY1VvK3JD?=
 =?utf-8?B?aE9WSUVlSXVGTHdFWDRJS1VpZ2xZMjhKanJBRzNtR2k5Ui9qY3hLUlA0anZj?=
 =?utf-8?B?OFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	F8QxJ72qtLzXg3yqCkpIUcy7YRUdXwLkaq6YWXkhik5HusnhM/16PnVlF/SuSDDwkeEI505cNIGlhOAiVlJP8hlRNTdYKjL+N2HtRAJW62LU40OIFTduhOi3BuaLJhGnrw0nOKsBgoB63/X79SMXQ8eST2QzzqmgJqdGMiT/AR9Oo41Hs3FDlUN8y4w7Ql6IHv82/piFoUlfHHMYm+XGculh1y/1MIqrKgzUDP36QbT3EdVfBfNnWs4KQJLzrGTnC0jXx+5BB6e8Ow2GbuWDspAR6hb+urqjkfk/BgHz8XnQfVrdPoiiXlUp3Uhl6I2qZ5QPnWs5rd+0OuMMSVNJde8fZ/xATySpeN8Z25XbxNDYzvJ5b5XSK4zl3YTkvDrlbHOdh68IbIG7xxsVHFTZoQrc6ZW2Gmh2Jwlk/WCFgzX9hoXTLxyF7JjRCIUu13ttyulyHD40HgOaqXXb9oKOIHvDq7+FyBeDJBMYCX9MFvosDXYJh31+Ib0ppZ1t1chDk/41cDH/iugU8Kx28pcKMkSZsR1pWPF5rXM+bk1KyU7B7dekAZUgvTr7QcqZsUfchgMiBJvycTvSdFuV/43Ix7iKA0DhdnQnvw4x3NeIJYg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2330bb56-d128-451f-73b1-08dc652b0e3a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 13:24:37.9201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YH+sc3GiE/6sywVm+cLd1kXVk22TUKQPoLBNO2EwVZ9tEI5BbHL96A1h40x/U2F5QDETItUFwkaiqq/FKUeHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6881
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_13,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404250097
X-Proofpoint-GUID: Yp1gemKQt26dPpiW6Q9MLeOamvMgs2aC
X-Proofpoint-ORIG-GUID: Yp1gemKQt26dPpiW6Q9MLeOamvMgs2aC

On 25/04/2024 13:17, Christoph Hellwig wrote:
> On Thu, Apr 25, 2024 at 12:08:45PM +0000, John Garry wrote:
>> +	struct xfs_inobt_rec_incore __maybe_unused	*irec;
> 
> I've never seen code where __maybe_unused is the right answer, and this
> is no exception.

Then what about 9798f615ad2be?

> 
> Just remove this instance of irec, which also removes the variable
> shadowing by the one inside the loop below.
> 
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 730c8d48da2827..86f14ec7c31fed 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -351,7 +351,6 @@ xfs_iwalk_run_callbacks(
>   	int				*has_more)
>   {
>   	struct xfs_mount		*mp = iwag->mp;
> -	struct xfs_inobt_rec_incore	*irec;
>   	xfs_agino_t			next_agino;
>   	int				error;
>   
> @@ -361,8 +360,8 @@ xfs_iwalk_run_callbacks(
>   
>   	/* Delete cursor but remember the last record we cached... */
>   	xfs_iwalk_del_inobt(iwag->tp, curpp, agi_bpp, 0);
> -	irec = &iwag->recs[iwag->nr_recs - 1];
> -	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
> +	ASSERT(next_agino >= iwag->recs[iwag->nr_recs - 1].ir_startino +
> +			XFS_INODES_PER_CHUNK);
>   

ok, that seems better.

>   	if (iwag->drop_trans) {
>   		xfs_trans_cancel(iwag->tp);

