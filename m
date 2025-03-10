Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05ECA224AEB
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 09:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741598735; cv=fail; b=CyxCd8vAgLk2GHKZ71dbUfAwZVssckB1BIDr4JSxUNOnuxZa3flf94dbSlpSJ2jV2mad2627C2DP3m+U/1j58VQJZmIJo55mmplz++OgMiiTMptQWX+mepn9aNxeWM/OKT5xnWV3NvkdFfJBdU7WmmRZsLUM3SvL4YciANNHRms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741598735; c=relaxed/simple;
	bh=5BMtfLLwFD5//xqshHD6CcrXejezH/yCayQ3GT0sDjw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oi5b6V8vq18rP3C5MSVLPtsmXu6qWVUEiRDIvfgDIFwXMTOV8wGv3+UVemg2N79aqcNOefa5trMZ9iCkXOS2SzjeMsQEmLWRxP+Tyg748qySdNUnCNRSTIrP954I9FfcwWx+4H5+elo15bSqtnU/LUUXK6o75BcTBpPnQiB8aH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MXn6lrY6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FLSIhdFL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MXn6lrY6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FLSIhdFL"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52A9BgX1027605;
	Mon, 10 Mar 2025 09:25:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=2DqyiYNW8ZsrPrNzjS0iHNhOptWwnBn3npKVlxIku5E=; b=
	MXn6lrY6YgDGTrV3PO7bRpMWrGl8wqS1KQV2mjM/P4GHG4EJMpHmSSPCuBpBT+db
	K+7fLDgfnKvPvNd+UucqFNihUsVuGCN+DwLbzgjXjQ7+TEcVKpy1e5vsbFaEM2or
	csxtRgbytfKghbJQDWGuoTRHWrhN2CSUmSDgnQUvgCj7UAt+110CG3HWhUel8ZO5
	AdElGywcTYMr/zae0agvKVfNbvMOPFOSbXK2/fI+2BVyMcIUux0XDEGM6giFe1oi
	c4wMmB5XyatrbTMi+gdRx80tuUSg056mQQrDX9L+7iEIi2G1MM2DMjFosRWU+NAQ
	CJOB/r0bkTv8jjC4chz9UQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458cg0t6f8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Mar 2025 09:25:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52A90FbZ021738;
	Mon, 10 Mar 2025 09:25:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458wmmss10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Mar 2025 09:25:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M/LfUzKZPntnuBc5j9W+DL5vvOfmZqUjmRMl2zmFcpoUOJkkq83TdL1FZ90QapdXwi9Jv0O/d0GKpV+YRlEttYtaA9Jz88CSWdeeYQWDGRTS5CAlG1KVadOnN2qxGjt5Qez2VosprgBOjHD424P8NKXLZZNpuCQVOnKLPscXGftVjWvuICObDO6+eXxFF4Jhra5ClrSqEfacxO8Md7jxcAsptfBOIxAtDN0WTyPf61n8oIHzT9jlT89I+e6bsebuzQAaQRMZ9/w68x8mjirLykgGjG2VobQPsWuLuiFoh41Mh/In+RSnO/sV7Ell1B7MKr+eGy7SHlWLIEtvbkTr5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DqyiYNW8ZsrPrNzjS0iHNhOptWwnBn3npKVlxIku5E=;
 b=NRybxRYNfxInVJnvUUeUUm/aYvaAIwiAC+ultZQRVxLrfqbYexGxTFOtNADX/NMh9zUpcXtWrUpGBL7usLRuqExwjxt52P+qHW99Vg5KVkzBF5QDib5VPMgmiUafrQtd5HmuqI3EgtXX6BZUbKpODUP/jxY3LvySc2WtG2H4/OxHxKq4Ot+i90A9vLVka+9fFqGy2DdMZ4406xDkN8HBd0XzsVNocXVQTfNSbjadEz/YbvrsWuNIvhdsdqUY1dzQ1Bh9DhXH9veoMXXUYUnmGtte0OHlqjlbKg53qStMFWqf0FG078OmtgLIa9M+FfjlzTy/Idu7kzdG/SOCWyLbnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DqyiYNW8ZsrPrNzjS0iHNhOptWwnBn3npKVlxIku5E=;
 b=FLSIhdFL8nBA50f+/CCWfi5aIjGrfqsAM7rOvcomUaWIQXkjWldfRa/dE4N0cdXWbXjOBJu1Be83U2DFfsrOAEtYLywnfYcl6D/AKxiVueUVKqwL82Ca7tbrzpeWJXGaGceIJi/OexLqbZ5KX8856y9D8H26Ps/cnu4B/RVVTjw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5582.namprd10.prod.outlook.com (2603:10b6:a03:3db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 09:25:15 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8511.026; Mon, 10 Mar 2025
 09:25:15 +0000
Message-ID: <67a8ec09-f7a2-4723-a60a-e19f834f3da2@oracle.com>
Date: Mon, 10 Mar 2025 09:25:12 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [xfs-linux:test-merge 13/13] fs/xfs/xfs_file.c:746:15: error: too
 few arguments to function 'xfs_file_write_checks'
To: Carlos Maiolino <cem@kernel.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        linux-xfs@vger.kernel.org, hch@lst.de
References: <202503090042.CWpAx3iG-lkp@intel.com>
 <-snKkUpXKLf6d34AfSaS0n5bb6CB1Lvo1pjfXIlmUp0gWycw1DVpA_QvioQtUAP_57GkYOu6_cHm3TNdPVTuVg==@protonmail.internalid>
 <7ade7fb1-b48d-4ee1-b9b5-2aff9c1c9622@oracle.com>
 <5kyqahqmufx3zbacsq7t3j35fwiiphx3kbvmpmk6s3sznex5wn@nav7453wf6hw>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <5kyqahqmufx3zbacsq7t3j35fwiiphx3kbvmpmk6s3sznex5wn@nav7453wf6hw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0144.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5582:EE_
X-MS-Office365-Filtering-Correlation-Id: bb8435ac-ea7e-4fcf-7d3d-08dd5fb57725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0FzSVZrc1FZcFAzK2ErMXZscm9ZNGFHTmNLVTNUV1lIZXIwQ051bmQ2WVRS?=
 =?utf-8?B?clRWRjBxUDJFQXNvZFl4R3BPZzZWSUV4RmM4YnZkMGVQaldwWGdIWkFsWmR6?=
 =?utf-8?B?M2l5Z2N3ZENvaURPZTRMek1FbGpTWm40Y3hYLzE4S3JSU1B3eDd4bWRrWENa?=
 =?utf-8?B?blBXNFhITUhUS2kvMHM5c0U3RGhTcGRiemIydUNVNmhHQk5jN3h2SHlxV3Ry?=
 =?utf-8?B?TU1yMWJ4ZjFMTzFaUlNCOG5aM2Z4SzRVTzhTd25ZWFZjSTZQMGJnMDYvMWh2?=
 =?utf-8?B?VkJpUGlCVGx4dEgwTGU3TzJNUFFQT2FzZ0krSk14U29CMW1WQ0U3SUZhV1l3?=
 =?utf-8?B?emhMdk9FV2ZZengzRldQemRhdFRIejB2VFl5ZUUvWERMRjdYNTE1VW16QVBF?=
 =?utf-8?B?M2syeWVoWkgzK3IrQlcvcFJTNFZLbkxxNVBIU0V4aFdZQVd0RlhTOC9rZ24r?=
 =?utf-8?B?VmlHWjdDL3U3VGxjYmszSG1MQnFPeFBFMlU0MzRJQzBpNm1Wc2tMNkw5a2Nr?=
 =?utf-8?B?bUV3RnNuU1dNK3MvNUJ3M3BYaVA3cWVTVXJpbFJIOFcwdHdKNlF6Vzd4alNT?=
 =?utf-8?B?U3ZvVUl2MlRzM0JJOUZuVU52dDBuTWNVY1MwVjExbTg1djBOYm5nM3FkMVM1?=
 =?utf-8?B?d282NnZKc05IVE9zY0xsZWU1bUIyMTRPTGE3YzNhQzB5WC94NHVPUEJQS05u?=
 =?utf-8?B?YzcvbE5SNEN4L01oWkZlcWtyN3M1Q0dpazNaMWJyWldUbWpsWmpjWVdOeEt0?=
 =?utf-8?B?N2ZOZEllQVZnbkQ1ajRzTUNMS0ZQTkpoL2ZkRUhTcGZOR2FOZnR2SmkyVDR5?=
 =?utf-8?B?RnpRV3VzSHVFVHFUVkxsVStvbE9PVFA0ZjduSFdWTGNQeUNML2U0MmwzMVBx?=
 =?utf-8?B?TCttanZQLzhralNObHFBTVJ4WXA4TDFBcEpRNjRUSHgzZmN6aEdYR2JlWHBw?=
 =?utf-8?B?Nm9XdnNIbE9Rb045UFEzbEhpMy9xQlNqcU4wVy9qVVZhSmQ0UU1FODB6VTZS?=
 =?utf-8?B?cGlyZWIvSVYvWkw3RlRBMzduR3pQbkVWRzQvV0tDS1BDZDNPV0I1WW1obnNO?=
 =?utf-8?B?eE5wVVEvMktWOFQ3Sk10amxyTHhBSjk2cDNybk85WE9oMWhxRUdqSVZIQ0FT?=
 =?utf-8?B?dlhmZEorN2ZKd2h1MVprSmlXclduM3JMRGM2YlBnY2k4WFRaaklkMTUrcjVt?=
 =?utf-8?B?UHhLRlcyWlZVc0Z6U3V5UFAwK3dzeEdYYVFoUVMrbFVIQWE2K2NUMkFCbmo2?=
 =?utf-8?B?MHN0dGlkdXZiK0JOb3lFRGNWTisyYngxMmo3VXpONFVsRXJkb0wyS0ZId21t?=
 =?utf-8?B?MFhDWGZKbE1mSURBN09TczA5V3pxR0lTMGZZS0VZZTZoS2QrSGQwN28rTEFW?=
 =?utf-8?B?K3hZMnRTdXVxSVk5WUwzY3RVUVBRcGFWUkFsSHZ4Q0txVnVMUXdpaWVEc2Vu?=
 =?utf-8?B?U2ltejl3WjFYcUFhNmt0K3pNd0hjMkJuZnY5cEFlTThoVEp0Q20xSE5DeFlV?=
 =?utf-8?B?VEtzTDcxZ0plOGovdlE2ZWs3Mkx1Y1NiTFlGNGFab1Jmb3RDT3VGNnN6Z3lB?=
 =?utf-8?B?R3dQZFNkWHFUQ3VKZkx0UGRhN1dSNm1HcHVnTU9OL05RcE5zMEdBRVlyUE5o?=
 =?utf-8?B?TzR6bHJ5WVpDUEdzOXkzcTlqVTRMU1B2dGloK3lQNU1lTU1CRW81bVY0UCt5?=
 =?utf-8?B?SGxYNGM5c2lPU0VaTTZKV2NIVVRoM0trOUZnQ3E0Mis1NTBTenhIVDhCbGNq?=
 =?utf-8?B?V1pKNTV6R0tsQmQ0TUUydzdqQVEramNmcGpTenhYM2tEcy9JTkVJNnZOWXE1?=
 =?utf-8?B?RU9GblhWa0phWWxWZ3R2aE1Va1FUeTdlZkdPb0dWY21lRzVBK2ZpenV6elZs?=
 =?utf-8?Q?ZQfI9huhass9J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjRCc09IRlRpQ2FsbndkUjdPNENWSjRaejhta0tmUVdhZzRwRGFzM2RIajBu?=
 =?utf-8?B?RVVrY2dpSlAzWUJuTE5nYk1XL0RMTEV4SkRnQ3dEcURlUi9GcjFHdjdPamYw?=
 =?utf-8?B?NzFCLzRIQ2UrQ2x1QTg0dmI5UmM2U09aejdBcEQxZ1pqYmovOVZhQWhvREZi?=
 =?utf-8?B?aVpXNkNRNFBQN0xTUUxVMWw0UWIvelphWlRDV0sydDNKdEo2OTV0dFhRV2Vx?=
 =?utf-8?B?d24xRmZQTnBsUjhSUnlPMkJnY3IxVUFQZTVYQTl5QXVRUy9OUndqWHNqZ2Rl?=
 =?utf-8?B?bno4WXE1bSsrL0hLVWoxYjRaV3ZOMVlnNElQWHZBWWNSNzVtWllIUmR3N05u?=
 =?utf-8?B?QW5TZ2ZmY05oKzRGdDJpcE15TmcySCszSmkvdG9VUW1adU9aNER2U2JtbXBx?=
 =?utf-8?B?b2I0TDd1WHhENU55Yk5DMkQ4V3l2UjJzVlNRalNqdWRNUjdTR2o3ZUhwNU9u?=
 =?utf-8?B?alRkakk0Z05TelVQSllxbUJSTzNUMmNYRXFZdDlLb0w5SE9NSFJGaDQ4Zy9X?=
 =?utf-8?B?TzQ3aUdqQVdkWVRTajJpU09GTEt6UzRFaUQ4Y0R4bkRjNGd1clMxWmpXenhj?=
 =?utf-8?B?dWhTR1FkczZBSlU4aHRLK05sdzhqZ0tvVkluenI3YnNTK2NzMjVHQ0tPeDk5?=
 =?utf-8?B?YUVqZW5TNmVyUTMramk2WnVrMkhNNXpRY0paWWxVY0FLMDluckZzSE83cWlU?=
 =?utf-8?B?UDYzRjNMY25Ma1BEM3VKVGNDWDVyQVllVlhKN2l6MGNoWTVxa2pQWXAxVnRm?=
 =?utf-8?B?blFYVzBBa2N6cmdVRUYrdGxQZDlOQklwMmU0ZzdKcU9ldjdGamVLYzAzdHdI?=
 =?utf-8?B?KzNpczBsYWVYaXREa3ZhZDBsYTIvQVpIemxmdkFOcDNKSnM4K21ZZFJCS2Jx?=
 =?utf-8?B?Z2lHcFZuKzhZK2xPVXBMU0V1VG5qaC9aK2hsMzZJdTRVRFZNcElXYTU2RHNy?=
 =?utf-8?B?VXRZUTZTM3JHeG5QU3hiNGkxTllnbE40Q0ZzaE1DQ09PSXYvdEJ0b2ZQd1N2?=
 =?utf-8?B?OUE3aytIcU9uMEpnMHNrM2lGRG5KdVQyUTU1K0lJazlkSHJyNUQ0dlpqV0Ja?=
 =?utf-8?B?UVhHaTdzeElpWHZrZmE5Sk54ZHJOYmhHR0RzUmZMQTlpYk1TY253VFFpTEk3?=
 =?utf-8?B?Z0s5MjBPNGMxd3hKdGhKL3kzTUZ2R2FQczBYdlNZL2hRZElaSm80c2NUZ0Nv?=
 =?utf-8?B?YmI3eEppSGRZLzBnaW9rS3gwMGhUQjQrRHVZUTNjVndsdjNkc2NUb3lGckxa?=
 =?utf-8?B?cmw3blB4TFJuaVE0S1BXSUZpSWdVNlNQT0hPK1FmWUZmMWxMMnZVRnYxZ0Iy?=
 =?utf-8?B?TzZGbFhFeXk5d3lpNFdMYU93cUd3Q0dLWlh0U2w1VGFmWUluRnU5ZXRnQjJE?=
 =?utf-8?B?VXo5QkxNN1BTT2xwa24rcURBWW9Gek9mY2h1eXdCeUM1OStkdXc3WG5maTlK?=
 =?utf-8?B?MVlSL3prTWRGcG9BSjhYQ1h6SWx0c2JSYkZYVWRmSUpmcnBjOTE4OGpjSTFB?=
 =?utf-8?B?OGd0NVVEcjhqbFBDbGVUMTc0Z0grS3VXMCtWcEl6U1BRWklGM1AvTVh0aEE3?=
 =?utf-8?B?cndDbUE2OEFOWlF6ZzFFT0J4NXFwU3R2WFh5eTA0L2xGRnFEMWJkWE03Y0w4?=
 =?utf-8?B?UXU3WEVVay9JbkpUK1dwb3FBUTA3Z251TjRxZ2xaOUcxSGZQOW43WmF4YWd0?=
 =?utf-8?B?d1dUVnlrSC85WUlwbDRqczNWOTRHSjlyOVZMY0Mwak5lUFhOZHIwbmpPWlh5?=
 =?utf-8?B?TytGL0tRTnoraUh4Sno1V2dEKzhMYWowMEhQRDRmVkRHM2xwd3EwVVQvN1B0?=
 =?utf-8?B?VVNQeVQ3NGtJVHZEM2laVlZCc3BhaDZVZCtvYTgwK3B4TFdHUncrMUEraHZ1?=
 =?utf-8?B?VFB1dkZpWUIxUlU3RFJFTXlwdGcxeVhyc1NqeERnMjg4VFNKcUltRXEvM2xG?=
 =?utf-8?B?TUp4K3Btc0hWanUzUk5qNVNhKzFzYVFrK1dkakZjbkNpYXFTOFRrNllEVzVP?=
 =?utf-8?B?QUVEL0VGWDZqZldkQmxkOERxT2dqbWs5Q3cwMEdkVUhtVDBXMnZtcEZRMnQw?=
 =?utf-8?B?VVB5VjI2RTRSS3kydEpXSk4rZG94VXZ4Z3Zualk0NzVodm5haE1vMERPQUpo?=
 =?utf-8?B?alMxZ3pNK0FkWFdwbnkzRE5nTGpGWmNlbFd4QzZQT2ZIdUFyQlg5Z0tqRGti?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M93Oyhj8JTToh9kkFZkHKbnqkO7+P1x0pPVoEJ3dZhEEjg7l4NNqhGXkkhWBqiCP5Aw8dZXChOr1Z/6rY073qpdNS1DCPeqI/0Px9Bl4L6kQcwMo6jIy+jf66aXphRs9NNOi4YvCzy516aQi2uyLr5xBQS4Fa9Ykg5IQgMUGhY2WQWEU2OvRoK0TjdPtZaaTzbPSVXVakBHJfUw3xRXSVKXwE4m/r6xUUab8H/gFD61QIOvhkcUXB/9acTdMIs/mZ4jaLlpNXYoIzaM2rg2co/4N/nbgcBqoYKVTTtaDYOLcuTuubOrQtV9Yo3pZ7IPP28uI7LHDKQs94yTD/xv+AH0Yl/0Pqg/7dYyhXkpwsfF+JS5q52viqOb3h2NNsOiAIPNhNpa2w5KUO7va90+dflVZyuqqPsZyajErgxtAPJLkYhsYNsXUhD3V8C45h1f+RBCt3JPOAxMZjHdmDqYcsGUgXRmyEWKHPovBzpjE9oFWMxZcn0o3FuBdFVHPaUYh0DmQ89rXXZW25ojx/dm6Xe0H20rX/ITNF+SRXVjM7XDJCPlMNIWE3PVzL7kTKko+wKyQaVIMq9EJQ5Bnb/pX4mlZPSmr4PKoierAWzcdqvI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8435ac-ea7e-4fcf-7d3d-08dd5fb57725
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 09:25:15.1292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQnfKYbiCj6vACWWFzCJZz+bQ8gcz/fGX26bxGzrT+syfmQ88cENEf1pxHp5kS4ECd27OZl525QNAj/FBI+iug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5582
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-10_03,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503100073
X-Proofpoint-GUID: AoKAEUXdvJyvYFD9aG_bYFafDsfe2bUa
X-Proofpoint-ORIG-GUID: AoKAEUXdvJyvYFD9aG_bYFafDsfe2bUa

On 10/03/2025 09:23, Carlos Maiolino wrote:
>>>>> xfs_file.c:746:15: error: too few arguments to function 'xfs_file_write_checks'
>>>        746 |         ret = xfs_file_write_checks(iocb, from, &iolock);
>>>            |               ^~~~~~~~~~~~~~~~~~~~~
>>>      fs/xfs/xfs_file.c:434:1: note: declared here
>>>        434 | xfs_file_write_checks(
>>>            | ^~~~~~~~~~~~~~~~~~~~~
>> Christoph's zoned series added a new arg to xfs_file_write_checks().
>>
>> I think that we want to add a NULL here as that arg - assuming that we
>> won't support atomic writes for zoned devices now.

JFYI, I am testing that change just in case

>>
>> Carlos, please advise to handle.
> I didn't know the bot was monitoring all branches, I just created this branch to
> open a discussion with you an Christoph. Well, I'll do that on my personal
> repo next time 🙂
> 
> I'll figure out what to do with this today.

thanks
