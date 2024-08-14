Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374B81B32D0;
	Wed, 14 Aug 2024 14:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723644028; cv=fail; b=PE562a04QJw556f/2PxepSIBPNHMX/Bqt39vAg/aCO0dhn6EXQiaueSPswZ4b1Fvvf0RJ26Y3Frln+aOMpvjgzKCnXG9+0dQ2I6VW/53Ahn7s6WT/DphWvtkD4MI2FVuQi1UYsTcKGvWYmfxHY8rLR2hhbgLLd+/YIU+rONz8UM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723644028; c=relaxed/simple;
	bh=n1TvQTUE85MgdCEhWYNi+uzw0x4Iw5D5+qDsu+P91Ig=;
	h=Message-ID:Date:Subject:From:To:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Xv+m5c+HEkBo/N1s+tb7kIIUw3RaYj66RxAt3DD4z5aBsp4DA9YrHMsUdam+/2bTthMXqV9qC5WGEi4+vNOfJDHgWuYl0eOpbDdeb5NEAh7v7gHwqRu8zql/cNhh4fya24QIQYChQA9ITPpW4dZPx0cfV/zgcwrcnIKdww7EEIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=axFsJ6pG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w+9L3lKP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="axFsJ6pG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w+9L3lKP"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47EBtcpg006145;
	Wed, 14 Aug 2024 14:00:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:from:to:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=0l0TBhikDwQvfz/t/+9mXedm6jie8tQKc5edbjoq+3U=; b=
	axFsJ6pGG3VSvqKF243VXrKtGCxkC19cifqYbaGy6a+4APs4cEjpizgnYxbRQD3g
	XGh7MeOT42vgoKTFK4Gh3IwyBWeeOGwf5r9yyfx+suioBeaZG9ANhXsOhjJP/FzC
	4zlhsMJqX/CfM+o/xFkdwKE5IWGxTNcpBlBoqsKl45juVPzqgRxqla9yToM4djhP
	5kpbiD6KJwDM2qduc5bvspSeo6Xv9HxZGvaVOt+jE/tIEPx2RTiIIcWs4AjNXkeW
	aV0ec8/3mgdPFQYlB0ORTnpaWSHVkwXgFcPggJxTfPvLNqFC2/RQLccOi4mkNdom
	eZ03h7vgHmdmsmikUDepig==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy4bgfhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Aug 2024 14:00:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47EDEMcY021157;
	Wed, 14 Aug 2024 14:00:16 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxngfb0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Aug 2024 14:00:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OnudgPn6fi0zMPBIZENAbBM/ZmmsqvlPmHolaUb0jRfXAl0zeoINjg7IbGDan318sPnxqULfqyiMpCrIFHgQBTqoIpzIvYuWGZ+jBEi2cIIu8ijj/H1RwRyuBrpjMTdQAXm5vzdMp8tEgDUkVT/KoQrVRTrlD+UGAqkum16m/93ptQjS9LUFipuSWzhHvXdKfCSlWWw1VqNkj5kOFzb+KNIXNb0t+39FU+OCxJBpBMzD3HT8LG2MGqXp9YCH1iod9b4gqcgTHWYJFZV0trmy9EcbLOBtei84o79VZRDqVH9uRUA0fGaI8adBpzszjMxN8m05PPCtqyTMAADMV3C2gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0l0TBhikDwQvfz/t/+9mXedm6jie8tQKc5edbjoq+3U=;
 b=EwIGyX47YFryDrKA5m5Ae0bci1jgrM+5tO3sQ8KytTh5RnvPC5NfjBMjZd4Niq7V91DZukqquneknrhAgpr+6SUX2ortHoRGTZelO2gSIk1e5GIliJUc9uaAeYmZDbgQGtsPCQOyMLqlOKGLxHbo4wPeIkWWMJgQVP1HM0GXk//Hc65iATOh26HWf9FWJ1olY0n/V7rl93/XGx+faDDIPjyBmgWgrqTuyeIYWmHeASR8Do25nrhJDAA6HTBuJ66ucBwqIl0paZBaF8QNnOFe20a9aREDA5FB4fUgzTfMhwN3S8O4cP4M8KcLvhV+HriGxWkvinoyU7GAl+wGleJSEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0l0TBhikDwQvfz/t/+9mXedm6jie8tQKc5edbjoq+3U=;
 b=w+9L3lKPF+1XYR8OzpqVudzj7Cd+ovMq49L/8O+VXPms01WncQ1M4Z0AbHMtwvml6KwedZaxzZ30AYvw3JzjQNzUqb1yc86uTZb4KKtQCJU3KaUXT84pMJyTKsAoC6ELKAHnZLFVQCZvq/1VETVp0OrBH+167Mb4/ocV3i6Ub9E=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4712.namprd10.prod.outlook.com (2603:10b6:510:3f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.16; Wed, 14 Aug
 2024 14:00:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7875.015; Wed, 14 Aug 2024
 14:00:09 +0000
Message-ID: <ea82050f-f5a4-457d-8603-2f279237c8be@oracle.com>
Date: Wed, 14 Aug 2024 15:00:06 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] raid0 array mkfs.xfs hang
From: John Garry <john.g.garry@oracle.com>
To: linux-xfs@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        axboe@kernel.dk, martin.petersen@oracle.com
References: <8292cfd7-eb9c-4ca7-8eec-321b3738857b@oracle.com>
 <4d31268f-310b-4220-88a2-e191c3932a82@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <4d31268f-310b-4220-88a2-e191c3932a82@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0296.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4712:EE_
X-MS-Office365-Filtering-Correlation-Id: 1864931e-a0b1-4d0e-3fbf-08dcbc6968ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUVwUmVTWGh4MDRWbzNSYS91V3lNeTIzcWRyWXkrLzA3L0xvUThHeFpibXcy?=
 =?utf-8?B?ZTEzWGR6aTB4V2gvUkUwU0FvcjN6VWhIMFBmbEJCQk1SRnlDbjMxemtDMm9T?=
 =?utf-8?B?a25POURIczVWekhVOGV4dzVRbGFqNCtqV3RhNE9XWFFSdmRZeWxuSFRZTXNH?=
 =?utf-8?B?WCtTak9DTDRTTFphOWxlMGZpcmZ5aC9adGhiR0NUK09iS3F4WXV4N0xIUkRB?=
 =?utf-8?B?dXhaRW12YUFxUVBUb0RORUFhalBON2Q0NnlpRVZMbDJ5QkdXRDU2MFRnYU9S?=
 =?utf-8?B?MzNJU0dzZTVhcDdqS2hQRVNxd2MrSTJWK3EwREhSbXg0Rmk5ck13cEFUTitn?=
 =?utf-8?B?cVd5UVg5bTEwNmNSdWxQZW5vaHl2UzNyak9MRjE3MmhGb2dOUm5ob2F5VWtq?=
 =?utf-8?B?SXZBaXBjZHpLVWJ1SnRLaUdJbjM5MXg0Smtndm1zM3h3R3FteTVLVjhUOUQ1?=
 =?utf-8?B?aWZORkZ6UjVMQmdKS2dEemhQaEg3dSsvdUUrL0I3UXFFc2xYYzArN1VaNmVz?=
 =?utf-8?B?ODdHZEI5VjZVaFpuWkd5N2Q5dU4vMjNhdlYxZUYrTUVmajh1REZmWFVoZkZD?=
 =?utf-8?B?dE1oK2s0RjhKYzVnOUpKNDRnbGJiOHhzd3pGV2F5VEU5UGtmQldjcnV6UTN0?=
 =?utf-8?B?WFhrbmtxUzJKNVdSemQzMXFxd1FCWDRnMlhRZDhLUHBuUFIrTm5jVGxUOGNn?=
 =?utf-8?B?WWRjcmp3TFh0cnFKNm03TjlSbWJxMmZUc0hUc0dMcUZNY1NLeWZNeFA2SVho?=
 =?utf-8?B?b1dNakdnYUVKRHdyT2Fjb2pNU2cwdjNQZjJBTzZmSEpRUy96OU94aXlDa2s3?=
 =?utf-8?B?b3dUTXhkc1hwNXVuZytpcjdpOUZGZ3NNeWtUelRSSkFDRUQ1cURSWmV2UmVP?=
 =?utf-8?B?MUhxRlBDbzBjZ1ZOYXZ6K05mMEhSVnVIa2dwQmRBejRLOHBiQXdtY29UaGUz?=
 =?utf-8?B?RGdqbUdValhWRmJPNjdxS0gwbVBHSk5iZHFDL3hRdW1YTmU2cGRXakxZbGRa?=
 =?utf-8?B?ZnBnQy91S2VRWFpheVVMT0dJVmhPTzRIWXZHbUpxTWlHbXIwaklob2FTOTR5?=
 =?utf-8?B?azUyWUZIZjhGQlNUZjNidlFkTXV2MHpZby9rSFcyd1pxUzUxcFNpM0ZiU3M0?=
 =?utf-8?B?QTBmWFpzeldycitmOC9WaksrOUlkeFJ2OUs3eDUrRy9xcVBVZkFNOFE5b3Uw?=
 =?utf-8?B?cHcxb3AxbzFlcTkyT2R2djcweEcyVkpWOFUvZVJsK2FLVDNiQzNBSVpxanJD?=
 =?utf-8?B?ZFB5VTFmL2s5OWdVR2tYcThwY05SdkY4a1Q4cWRvRDlCWXM2VzBsNlhib2VF?=
 =?utf-8?B?TG5UUU5aeTh2b1JvUC84UXFldERsM0hKVkRHZ3dNVVJzZDhmNWxHRFJ5ZU9k?=
 =?utf-8?B?Tm5XNUgvZFB6YkRZelgyejJwQi9QV2Q4NjZmSEp3UFFFRkZTd2E3cWJnNkJm?=
 =?utf-8?B?SHlQNHl0OFpYczhIVUgrRzBLQ1NVa081OEFGSExZc1Evd3dLVWcyNzFmNnlz?=
 =?utf-8?B?ZURvUVBDZy9sQnJ5eGkrWXRpbGlYb1d1REhwM3RrZ2htcVVzdmQyUzc1WUNH?=
 =?utf-8?B?NEZsVnZXZCs4SzBvdXJ5WlNhd1A3a2NwOUJwRStrVkhtR3Vha3ZnNmk3aFFV?=
 =?utf-8?B?TndSRldvNEd2Yi9HT3dEODlEWlZOZVllTlo2dmZaMHV3YVloS2c5T0Y5NjlJ?=
 =?utf-8?B?U0hndUFtVElSaTNWamJITE1VbDVDSTdNeXJobWJSTlpwLzZEUjhaYVA1UEVq?=
 =?utf-8?Q?iiYIP54GtXNPD/XVas=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmVBOVlqU1Npcnd2RGFlS3lFWGozWUxlZ25aaXE4MVdzblVqUi9wUzNqYTg4?=
 =?utf-8?B?U3JBZ2NRRnJwcUtJT0ZCY2dZUU00bFZCOS9Ud2FQUHNrUHVKa0lIeWxhRzBX?=
 =?utf-8?B?ZE43WHlCcUdacEVWTGpVUXFoVzlQY0tVWDFWWDBkV0J4R0pxVHJtOTFjNXhL?=
 =?utf-8?B?RGxyamh1Y1ZtcHY3eFpIeDFXdHhIN2N6bFhiamsvTEErWis0SlEzQ1JvcUhl?=
 =?utf-8?B?L0NDN3FWZ1ZyRmt4SUxTcUtlcE1Hd0VnREV6RzBsZUdoQlM3RUY3ZlkzT3Fn?=
 =?utf-8?B?MEdpWWNmUEpRRm5aZzc1ZFBhZVVaY3VBbzZKY1RHRk1KQlFWbDh0RDRWWGxC?=
 =?utf-8?B?SFVBajdpOTUybTBrcFBvOTh6UVU0MTVvaHJGOS9XRXpWa2ZleGNEa1Bua2Vo?=
 =?utf-8?B?RjFWcWQ3TGFDSHp5YzRCcjhNL1YxZXlBMmJjeGRmZzBvZGkxRE9oSXN5REpi?=
 =?utf-8?B?NTFvT0JSdlNlaTZnS1NtRmJpb1FOY0U3ZU9FVTR3U014SU93SUM1RGFrcGVm?=
 =?utf-8?B?ZWJWMkhqNjRoY3BqaTRYeis0eWJzdy9ORnY4aUJEKzMvcmxTcTZBOUU3U2cx?=
 =?utf-8?B?RGJSVTY2djlqWVpicHZNQ25hbjBDcDVocWIzbjBVcFA2eTN5Vmx1WEYxNVI3?=
 =?utf-8?B?WWI0a2dsOWk1Qkowdi9IWHpDWCtOMjJGRUxlR2I5cFJFS2pqRmlLYTlzRkU1?=
 =?utf-8?B?eXJBM0dHQlpENGNETGw1VzRHNlVZbTRPMlNyRUpJQlhpRXBIaWhkRmZEaFQ1?=
 =?utf-8?B?T2l1ajFyOUlqTEVIZHpjZGJ0Yjl2Yi9mNWs3TmxlZjVYZ1E0Mnhrdi9Mbk5G?=
 =?utf-8?B?VytteUNiWW1Xa1BJd0pZY2hwRkRHYXgrN0p4VGpGeWpHV3JSMVlXcUFOOU03?=
 =?utf-8?B?azgyRThROTNiMGVKZjRWa3RpRGgxM3NkU050dk1tTUlsZFllOUpNTWpSOHZP?=
 =?utf-8?B?cVltMENITGFBaDBsS3I1SEpZZ3I4SWYxK0FvbjNZWnVlU05zSXdoS0lJU1lD?=
 =?utf-8?B?UWlNMkFUVDdQQTBCRmROWkszbytTOG9XUVJ5dmpGNjFJRWZ5QmJYUjZ3R0sw?=
 =?utf-8?B?aHFZVU8zc2dVWDlhcUNiZUxNVWVDc0thM21mWUF2MkgrLzNJdy9SQ3d4T2JR?=
 =?utf-8?B?bWMzU1F4TTl3WThpbUVxWDlyOVFhQVVkZnNucHMzb1BsQmgyL2ZLelFRTTl0?=
 =?utf-8?B?TXhGTGVUdXFTN3ZhTjhZa29GTHdkS1JQU1ZKYjZiWjg5Z3o2Z0dORjRxakNn?=
 =?utf-8?B?dmhYY1lSYis5WFEvcmplNEFzK2pIY2FZUURWR0xwUUNjR0VEd0VnT0ZlSkor?=
 =?utf-8?B?Y2VtYVZIMlhvSUJ0a3RLdGI5Y3ZVRDdIUEVyU1NpR0gvRk83NEtpWWZHeU9R?=
 =?utf-8?B?aENXNUxENWZhTjZVclMwTWtpS0RXY1c2ZnBHQTN2VHJ3TnM5YUp5YUtwQThZ?=
 =?utf-8?B?Z25nVDNhRldlblk4SUR5V0k0Z3RDSC8zSE1sVGZmS3A5dTd5ajlYWUZVTmxO?=
 =?utf-8?B?cmFPWUcxSWR1bWkzZFNOL3JZWklHT3o2RUFXbkc5Q003TGp0VyszQU9VVlhB?=
 =?utf-8?B?Sk16Z1JxdXd6TnBieHpEc3JDM2ZsSHVYSUpvWEduVDAxRUljc1dhVmFtaVgw?=
 =?utf-8?B?ak9xZndXT1p1L2ttZkc0VFhtQXM5YXlZbmtLRXlpaTErZUxoWEoxNHZSdFpM?=
 =?utf-8?B?UldXYS9kZ1J0NmYzaE5ES0ljYTFqQmxIdVozT0p4NVVuQmhScDFnQ2x2NzMv?=
 =?utf-8?B?R2ptMTZTV2U3Y0kvNHBSS1ZvUm5sVDRLTUFqSTBzMVdPelJuaVdCYWVWL0hU?=
 =?utf-8?B?eWllTjFZeWpJTy8vRFlreGpoL1Yzc1ZNekhkeE9HQzJkM2FtQ0NXM0k1MlVw?=
 =?utf-8?B?VEFsdnMyQjIzaVd5QmdGY3dUcHNCZUg3UHJNZkc0c2xwTDN2QnFpejIwZUFh?=
 =?utf-8?B?OG15c3BlL1JsRkhELzdNdWJ5VVF2SFg5SkpKVG5Uc1hDNFJQQ0R6ejhITnBN?=
 =?utf-8?B?MEl6SHJzczlJNDJ0c3pxK1JsMEljWjJkd3VzV1V1ZEtpazRqcWx5N3JYMzBF?=
 =?utf-8?B?OEpOM1p2dmYvOWtzSG5leGFMTzRPaTBNSVNFeGpGcGJNOGJoT3Rhc3dBWXpx?=
 =?utf-8?B?aDJoV2NKR2l2cUFzUlZGYWFnNEVxVWRqbitjNWtySlN4RGMvRU5uSm44VmlX?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Xa6jaD8VGEHz2ookMj6/dX53aSLljiA5Q3242/R94QER3cK80DaCrRmbggnl0oLysJxDf4Hr/AnGm3hMctHraMVj2ZqvMAEZjTEDUpZVDPZTgpnrjFrKPs12sHuTJb/vF7+egSDXxq5UQwr0hmxa3VybymRwUb0PHDq99pIzdbi2g4cwWTbuJL35y/h+zHXFdnG2JnwaBMoi02jn/QlQm9CMQ/XC6xM00IrbXJryQhTtJ4m5t0UDZF31WijIr11HvfM+Lc2sb0hGmKIKjT1ulPtucbRwHEAPteJn2pzwnUhpzz50PFbHCn/15Jrh/5ch7aCBptnxn5GxqwdSHs5c704MrkZorKpoft+2CNZ+rq6TnOcfpmaAiNeQGQaXEqDVjljNKBYb1j43temk0Jd/K1v2BAeQ4WBesuOGLrrqGksfi7m8i2dJKnEDE7nuh7FKOTlLAiRH7j4d4WQEtXhPH3hWkwRxgvwKQ1L0Z3lhuT1uVKza/R3C7v0MBKFiwZyE60AnRLqyFuAuFGYmpav38zwLRphvK/cipJ0wwRIzWICoZkby8A0xGNsHZc+tXeW/e+GnL3Html5k51K65fkjyKlgsFCafu/yd0QbStM9iR4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1864931e-a0b1-4d0e-3fbf-08dcbc6968ab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 14:00:09.5914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BoNgKZZXV/+VCqlLzFtEzqk4O+wUZq5hJySONR4CR3KK3ERL3Nxg8dPjkhMkMgaqkrICo4qii6oPI8yxUQ/6fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-14_10,2024-08-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408140098
X-Proofpoint-GUID: KiEFkp9lLtthWfFtq8kJVeSznkITcES2
X-Proofpoint-ORIG-GUID: KiEFkp9lLtthWfFtq8kJVeSznkITcES2

This looks to resolve the issue:

------>8------

Author: John Garry <john.g.garry@oracle.com>
Date:   Wed Aug 14 12:15:26 2024 +0100

block: Read max write zeroes once for __blkdev_issue_write_zeroes()

As reported in [0], we may get a hang when formatting a XFS FS on a 
RAID0 disk.

Commit 73a768d5f955 ("block: factor out a blk_write_zeroes_limit 
helper") changed __blkdev_issue_write_zeroes() to read the max write 
zeroes value in a loop. This is not safe in case max write zeroes 
changes, which it seems to do. For case of [0], the value goes to 0, and 
we get an infinite loop.

Lift the limit reading out of the loop.

[0] 
https://lore.kernel.org/linux-xfs/4d31268f-310b-4220-88a2-e191c3932a82@oracle.com/T/#t
Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9f735efa6c94..f65fb083c25d 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -113,11 +113,11 @@ static sector_t bio_write_zeroes_limit(struct 
block_device *bdev)

  static void __blkdev_issue_write_zeroes(struct block_device *bdev,
                 sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
-               struct bio **biop, unsigned flags)
+               struct bio **biop, unsigned flags, sector_t limit)
  {
+
         while (nr_sects) {
-               unsigned int len = min_t(sector_t, nr_sects,
-                               bio_write_zeroes_limit(bdev));
+               unsigned int len = min_t(sector_t, nr_sects, limit);
                 struct bio *bio;

                 if ((flags & BLKDEV_ZERO_KILLABLE) &&
@@ -144,9 +144,10 @@ static int blkdev_issue_write_zeroes(struct 
block_device *bdev, sector_t sector,
         struct bio *bio = NULL;
         struct blk_plug plug;
         int ret = 0;
+       sector_t limit = bio_write_zeroes_limit(bdev);

         blk_start_plug(&plug);
-       __blkdev_issue_write_zeroes(bdev, sector, nr_sects, gfp, &bio, 
flags);
+       __blkdev_issue_write_zeroes(bdev, sector, nr_sects, gfp, &bio, 
flags, limit);
         if (bio) {
                 if ((flags & BLKDEV_ZERO_KILLABLE) &&
                     fatal_signal_pending(current)) {
@@ -165,7 +166,7 @@ static int blkdev_issue_write_zeroes(struct 
block_device *bdev, sector_t sector,
          * on an I/O error, in which case we'll turn any error into
          * "not supported" here.
          */
-       if (ret && !bdev_write_zeroes_sectors(bdev))
+       if (ret && !limit)
                 return -EOPNOTSUPP;
         return ret;
  }
@@ -265,12 +266,14 @@ int __blkdev_issue_zeroout(struct block_device 
*bdev, sector_t sector,
                 sector_t nr_sects, gfp_t gfp_mask, struct bio **biop,
                 unsigned flags)
  {
+
+       sector_t limit = bio_write_zeroes_limit(bdev);
         if (bdev_read_only(bdev))
                 return -EPERM;

-       if (bdev_write_zeroes_sectors(bdev)) {
+       if (limit) {
                 __blkdev_issue_write_zeroes(bdev, sector, nr_sects,
-                               gfp_mask, biop, flags);
+                               gfp_mask, biop, flags, limit);
         } else {
                 if (flags & BLKDEV_ZERO_NOFALLBACK)
                         return -EOPNOTSUPP;
ubuntu@jgarry-instance-20240809-1141-3:~/linux$



-----8<------

The value max write zeroes value is changing in raid0_map_submit_bio() 
-> mddev_check_write_zeroes()


> 
> xfsprogs 5.3.0 does not have this issue for v6.11-rc. xfsprogs 5.15.0 
> and later does.
> 
> For xfsprogs on my modestly recent baseline, mkfs.xfs is getting stuck 
> in prepare_devices() -> libxfs_log_clear() -> libxfs_device_zero() -> 
> libxfs_device_zero() -> platform_zero_range() -> 
> fallocate(start=2198746472448 len=2136997888), and this never returns 
> AFAICS. With v6.10 kernel, that fallocate with same args returns promptly.
> 
> That code path is just not in xfsprogs 5.3.0
> 
>> After upgrading from v6.10 to v6.11-rc1/2, I am seeing a hang when 
>> attempting to format a software raid0 array:
>>
>> $sudo mkfs.xfs -f -K  /dev/md127
>> meta-data=/dev/md127             isize=512    agcount=32, 
>> agsize=33550272 blks
>>           =                       sectsz=4096  attr=2, projid32bit=1
>>           =                       crc=1        finobt=1, sparse=1, 
>> rmapbt=0
>>           =                       reflink=1    bigtime=0 inobtcount=0
>> data     =                       bsize=4096   blocks=1073608704, 
>> imaxpct=5
>>           =                       sunit=64     swidth=256 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>> log      =internal log           bsize=4096   blocks=521728, version=2
>>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> ^C^C^C^C
>>
>>
>> I'm using mkfs.xfs -K to avoid discard-related lock-up issues which I 
>> have seen reported when googling - maybe this is just another similar 
>> issue.
>>
>> The kernel lockup callstack is at the bottom.
>>
>> Some array details:
>> $sudo mdadm --detail /dev/md127
>> /dev/md127:
>>             Version : 1.2
>>       Creation Time : Thu Aug  8 13:23:59 2024
>>          Raid Level : raid0
>>          Array Size : 4294438912 (4.00 TiB 4.40 TB)
>>        Raid Devices : 4
>>       Total Devices : 4
>>         Persistence : Superblock is persistent
>>
>>         Update Time : Thu Aug  8 13:23:59 2024
>>               State : clean
>>      Active Devices : 4
>>     Working Devices : 4
>>      Failed Devices : 0
>>       Spare Devices : 0
>>
>>              Layout : -unknown-
>>          Chunk Size : 256K
>>
>> Consistency Policy : none
>>
>>                Name : 0
>>                UUID : 3490e53f:36d0131b:7c7eb913:0fd62deb
>>              Events : 0
>>
>>      Number   Major   Minor   RaidDevice State
>>         0       8       16        0      active sync   /dev/sdb
>>         1       8       64        1      active sync   /dev/sde
>>         2       8       48        2      active sync   /dev/sdd
>>         3       8       80        3      active sync   /dev/sdf
>>
>>
>>
>> $lsblk
>> NAME               MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
>> sda                  8:0    0 46.6G  0 disk
>> ├─sda1               8:1    0  100M  0 part  /boot/efi
>> ├─sda2               8:2    0    1G  0 part  /boot
>> └─sda3               8:3    0 45.5G  0 part
>>    ├─ocivolume-root 252:0    0 35.5G  0 lvm   /
>>    └─ocivolume-oled 252:1    0   10G  0 lvm   /var/oled
>> sdb                  8:16   0    1T  0 disk
>> └─md127              9:127  0    4T  0 raid0
>> sdc                  8:32   0    1T  0 disk
>> sdd                  8:48   0    1T  0 disk
>> └─md127              9:127  0    4T  0 raid0
>> sde                  8:64   0    1T  0 disk
>> └─md127              9:127  0    4T  0 raid0
>> sdf                  8:80   0    1T  0 disk
>> └─md127              9:127  0    4T  0 raid0
>>
>> I'll start to look deeper, but any suggestions on the problem are 
>> welcome.
>>
>> Thanks,
>> John
>>
>>
>> ort_iscsi aesni_intel crypto_simd cryptd
>> [  396.110305] CPU: 0 UID: 0 PID: 321 Comm: kworker/0:1H Not tainted 
>> 6.11.0-rc1-g8400291e289e #11
>> [  396.111020] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
>> BIOS 1.5.1 06/16/2021
>> [  396.111695] Workqueue: kblockd blk_mq_run_work_fn
>> [  396.112114] RIP: 0010:bio_endio+0xa0/0x1b0
>> [  396.112455] Code: 96 9a 02 00 48 8b 43 08 48 85 c0 74 09 0f b7 53 
>> 14 f6 c2 80 75 3b 48 8b 43 38 48 3d e0 a3 3c b2 75 44 0f b6 43 19 48 
>> 8b 6b 40 <84> c0 74 09 80 7d 19 00 75 03 88 45 19 48 89 df 48 89 eb e8 
>> 58 fe
>> [  396.113962] RSP: 0018:ffffa3fec19fbc38 EFLAGS: 00000246
>> [  396.114392] RAX: 0000000000000001 RBX: ffff97a284c3e600 RCX: 
>> 00000000002a0001
>> [  396.114974] RDX: 0000000000000000 RSI: ffffcfb0f1130f80 RDI: 
>> 0000000000020000
>> [  396.115546] RBP: ffff97a284c41bc0 R08: ffff97a284c3e3c0 R09: 
>> 00000000002a0001
>> [  396.116185] R10: 0000000000000000 R11: 0000000000000000 R12: 
>> ffff9798216ed000
>> [  396.116766] R13: ffff97975bf071c0 R14: ffff979751be4798 R15: 
>> 0000000000009000
>> [  396.117393] FS:  0000000000000000(0000) GS:ffff97b5ff600000(0000) 
>> knlGS:0000000000000000
>> [  396.118122] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  396.118709] CR2: 00007f2477a45f68 CR3: 0000000107998005 CR4: 
>> 0000000000770ef0
>> [  396.119398] PKRU: 55555554
>> [  396.119627] Call Trace:
>> [  396.119905]  <IRQ>
>> [  396.120078]  ? watchdog_timer_fn+0x1e2/0x260
>> [  396.120457]  ? __pfx_watchdog_timer_fn+0x10/0x10
>> [  396.120900]  ? __hrtimer_run_queues+0x10c/0x270
>> [  396.121276]  ? hrtimer_interrupt+0x109/0x250
>> [  396.121663]  ? __sysvec_apic_timer_interrupt+0x55/0x120
>> [  396.122197]  ? sysvec_apic_timer_interrupt+0x6c/0x90
>> [  396.122640]  </IRQ>
>> [  396.122815]  <TASK>
>> [  396.123009]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
>> [  396.123473]  ? bio_endio+0xa0/0x1b0
>> [  396.123794]  ? bio_endio+0xb8/0x1b0
>> [  396.124082]  md_end_clone_io+0x42/0xa0
>> [  396.124406]  blk_update_request+0x128/0x490
>> [  396.124745]  ? srso_alias_return_thunk+0x5/0xfbef5
>> [  396.125554]  ? scsi_dec_host_busy+0x14/0x90
>> [  396.126290]  blk_mq_end_request+0x22/0x2e0
>> [  396.126965]  blk_mq_dispatch_rq_list+0x2b6/0x730
>> [  396.127660]  ? srso_alias_return_thunk+0x5/0xfbef5
>> [  396.128386]  __blk_mq_sched_dispatch_requests+0x442/0x640
>> [  396.129152]  blk_mq_sched_dispatch_requests+0x2a/0x60
>> [  396.130005]  blk_mq_run_work_fn+0x67/0x80
>> [  396.130697]  process_scheduled_works+0xa6/0x3e0
>> [  396.131413]  worker_thread+0x117/0x260
>> [  396.132051]  ? __pfx_worker_thread+0x10/0x10
>> [  396.132697]  kthread+0xd2/0x100
>> [  396.133288]  ? __pfx_kthread+0x10/0x10
>> [  396.133977]  ret_from_fork+0x34/0x40
>> [  396.134613]  ? __pfx_kthread+0x10/0x10
>> [  396.135207]  ret_from_fork_asm+0x1a/0x30
>> [  396.135863]  </TASK>
>>
> 

