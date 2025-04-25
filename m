Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2819523E32D
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 14:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745589951; cv=fail; b=MhcqX++wwkKQ6om13mUfo6RxulSyeAs5uK6knH2kCmn3/rC6vymVG9q/VplRABppXY9GUCW3/y1QOFf7x8ztuwPbKR3iAVSFMyGQ1b1OHTtL8wOGQFomUTvA6MI3frq4X5dbHmU8KuKWakvI5NPIDeiU2W6113qSsuQBLd1wG1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745589951; c=relaxed/simple;
	bh=xThXbTC3rJTd8tV+rhh4dmeuFH0d50M8FoV5uIdtWbM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QTxAliUeBS2A73C+K6FGBnaG+52Y/NQqMace1erCMX8xb0nT56T+6O9fM9BKj9FxQyKhUVwDzjgVCn/CET3Cfl9bi1Z5YeX39m48NthZogYAyuEMBuJN4qxhjVOzM1OtydwiHPbE3qaoQdFWlh/9jsE6KUEw6MUcj9A3LDnceIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DSh+YX5m; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qvfUvBvU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DSh+YX5m";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qvfUvBvU"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53PDpdb8001006;
	Fri, 25 Apr 2025 14:05:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=i6DcUKluFTbGiXYzlR9Rb3RPzOmvC83EGZTufgym7h4=; b=
	DSh+YX5mMAmiYjjGDZTOxUwT7FNYhNhMYEjXPjc/m906W3rJClZVXas9s+lGR+0O
	bOF5QRm5icfEpE9pLRQIC4fIglKsKw77bChF092IgiVISQjZaH+qJCxt9reErJmO
	spkC3eYuYMzvQWOH1BjmnxPq7zQUV+cb+fV77C5DAviqbbzi4kDr/ueqUaCDGx2W
	Q7g67PR5JUAynVdOPC2UFemWv4cXSqEl6wLw7tqtboBxzmimPbxD932r8KisgQra
	zeG0l1FLLCLXgn/xRatKLynJIPDxHXGkVhpJfQjxdn36cXQgnhfDInmYLBHjz0X/
	xMbyV7kiJev7G43nBwKxvQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 468bbxg4rm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 14:05:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53PCpmDL031052;
	Fri, 25 Apr 2025 14:05:42 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazlp17012039.outbound.protection.outlook.com [40.93.1.39])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 466k08pdkx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 14:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L1pjXdxcUt0NlqlJ75aHt/hjJZwmdWfWOskCHSlIs9rowMLBEMHi8LumA/twnsluuMRR2vp1E4We7Pp1gwPZ8AYcNHeskQ5ovk+/G868lPBiMqd7WHcYpSzLAcz0J/EadJwI6CbGAfYYKIxjA60+kKiT+K/nwyUYpt2fVClvJVp5JHue82bv7utvn4hzobL8xSGz3Od5qkg/Vo44wbRoKmF6dIP5acgqa5aEeNNh/NuqjzEsNEhLH1OGyhADXlzFLrkZj3DSadD0SqMv4mDmEgR1VwImRVWxGNtbU4cdg3l0Fa14c1T5ChvSpQfaRPo3Ej5jmfiKtPTmi8WkNuQFHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6DcUKluFTbGiXYzlR9Rb3RPzOmvC83EGZTufgym7h4=;
 b=QmiQlyKo7P5IiyYkxq1KuawtoQNacxb0N0OusBMH2lJhHAVIls4xl5TwrHzV2KdI1lxhTXRCExRHnoRy9Q5baul2h4u2ge5CS0NDhthgZ39wd72/RcHxKpdj4X+qU+zdcuy/MSh1YL4qvj9VUSN9ZM8ZBeejMXVjK9JpefR8gWz6tH0sCdXmFMhPvzRzLICv8zW0Eu1QpC1Ne0YS001kJEMM66FMjlfPFdinb7v1jymJ0XZF4tDnXzQEl3m3YuCSQWbRKeArc5yS03GVypimULHK7H/cRmEG55AdN+vUeyj23o1TlE2ZeyViUXQvmODcFASnvmwZsODVdv8XAnjOFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6DcUKluFTbGiXYzlR9Rb3RPzOmvC83EGZTufgym7h4=;
 b=qvfUvBvUbfPmjT/MyDuTj8EUbnrK8mcc8tkMGAu4LvdzTDWLAYtdRYd0qTV+CLSL1xdII1Mi+Qgj7fE1UOUm1pqyTshQA+ZLmQAvGCSwXXJlktf4oY1hfwmn1R7QZvWDDDmQqwA+8qArMkG++JF45MyPksByabz03vbasFcEzxw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN7PR10MB6570.namprd10.prod.outlook.com (2603:10b6:806:2a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Fri, 25 Apr
 2025 14:05:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 14:05:39 +0000
Message-ID: <c77bdf38-cbc4-4c48-8a5b-82e938d7b40d@oracle.com>
Date: Fri, 25 Apr 2025 15:05:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] xfs_io: catch statx fields up to 6.15
To: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
 <174553149356.1175632.17456557520696046949.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <174553149356.1175632.17456557520696046949.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0227.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN7PR10MB6570:EE_
X-MS-Office365-Filtering-Correlation-Id: cf4d12aa-450b-4568-65a9-08dd840241de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cXB1b0RFTHlBdWxiUEUxWUJZZ1BCR1laRDBZK0ZIUS9sY1Y4MzhnRHZzNDVi?=
 =?utf-8?B?bzlqZjhHb0hRT1BScUh1eGNwQVQzUmhhbXVtVklYRlNSYm9XalNYWDZaNnRN?=
 =?utf-8?B?cjJybXVXQnZNME5LUC94T2dWZzF2YUtqTnFHNkRjd08xN1h1TEtHaFRiUzBy?=
 =?utf-8?B?eEVlUCtWMVlnYU5XL0FickRQSXQyTE9FNVJjYVhQUDkyRXE1TzBOSTNtOXJC?=
 =?utf-8?B?eE1ZelU5OXQzZjZNbS90OTQ3akJ0YjJTaldtbGQ5N1NuOS9IQ28yOC9iLzd6?=
 =?utf-8?B?bUtzSzVLeiszVlRkK0tSOUxCaU9qaHBWVTZaYkZlaWdNYmlabnRST29YZk1G?=
 =?utf-8?B?QUlmaVBvWC8ycmhRdU43MWsrd2VmdmU0MW9ycmxsS0dRRTgrWDREeUVsMFRj?=
 =?utf-8?B?ZDhTVVZ0bGRmZkVGSHpKYWJrdFRsdFE1S1JOSnlldlN4eDcvKzhPVWlQd3Jr?=
 =?utf-8?B?RGkrYjQvSkk3UDV6OXhQWldNNkk4K05pditsVHBOU0E4anhqYS9TM2VlcG43?=
 =?utf-8?B?c3JneHZqYlpxVWdNeDE3Vk5NZEQzQVVmUVpZNEZxaEM4S3piSktuYlgrdUI4?=
 =?utf-8?B?dzJGU3V5emU4aExJMlh5UENNZTJkeHpjUXBvMDBWWEU0VUlZcE84ZW9pWW83?=
 =?utf-8?B?MHJOWi95c0lYR1dHdk5LWnd6L0RZb2drTmxjdnlCWkFzYW5jZW14M1lGejZI?=
 =?utf-8?B?WlJtTXd2T1pjSGlDeDlCOHNRQnlKOUVYWStYdXpta2xPdlVKR0RvSDlrRFZ4?=
 =?utf-8?B?TUhmR2YzR0lwOTNORUo4N0drKytPYnNzRUQwaHc4emhwRVhNbkp1MmhVYStJ?=
 =?utf-8?B?RkJOa0YwRnl1WTVSVHNXQ2tMNUltOFh0NitWOElpMjR6UjlGK1lnajIyeWFu?=
 =?utf-8?B?VkNSSU4vZHpJcE9DRWhLWW1VSnNQNDV0UzlzSnRDNEtmMDJqbUt0SnNVVHlN?=
 =?utf-8?B?Nk44U3REeTgyUEVxbzNSU0pvU3F6NlJkUEhCbHkvY01CbzVxbWJvdUplSFFU?=
 =?utf-8?B?cE05ZU1zWGF4OXVMelhWU2I4WWo0V29LQmRGY3M5ajRFNTZnN1ExM1hUQmtE?=
 =?utf-8?B?L1dkSGprTFJOb2JJMk9UejBmelVTUEhkd1lSRXZiWXN1VnlidUN3bk1jQjhJ?=
 =?utf-8?B?OTlEVEp2bnlCcHZHNHZGQkNwbWt3dTNOOE85elI1a3hwMTdWRDZnTGFwZEVx?=
 =?utf-8?B?d1p1Smo4Vm5RUmF6Z2hRWkM0TFBQTm9FZUcyUm02QXduSVdScG1KZmhia1Rz?=
 =?utf-8?B?Q2hLcXNvN3VieEtwUEJwZFF2MHdRT0VNK1NEQUF0Qi9Zcjd6VWJLNGllZ0hr?=
 =?utf-8?B?WlRsVkYrdWJyaW00dktqbDkveXFOT0pGczFLVGZCY3R1QnNlaDE2NlBBVkhH?=
 =?utf-8?B?cWVVVFhQL2lUalY5TTg5QUdWUEE3NGlMOXY0SnRJb01XT1BEQ2ZqOUVYUEtJ?=
 =?utf-8?B?TmdGUlVXbjVtdXliLzhiTWVkU2o2Nm1yeGR2aUErTFBrVFdOeWhzTDNZZWps?=
 =?utf-8?B?NXNJRkF6Um0yZmZwazBvSWNKUkNxY1AzMm5MUHI0VTI3K1RaUStyalI4eWxI?=
 =?utf-8?B?cm1aYU5VK2tXeFZxaXpXanVsbnJoOERTdWkrTXpQcnpIeU1VU2RhQmdER0oy?=
 =?utf-8?B?aW5Ib0RVWjRNSFBjUm5WZS94aDN6NVBsTHBUbTQweXNPQ2dEYTZBdlBEaC9o?=
 =?utf-8?B?K0xaSHVaZUJqRHlndkRvMnZDRmI5ZHZxWXBjWXRHVlVQdktZVERtVXpnQVNV?=
 =?utf-8?B?NmJORTg2QlJEbkkrRlp4bmRKSUx4dk0weEs2K0ZUZ3U5aVpFbkkzakJQZVNQ?=
 =?utf-8?B?cU9yTEdWbXF2Qko2L2lRQzhGVXN3VUswZUJTTDVMOFk2WFpvOVhPN0RtYjdG?=
 =?utf-8?B?UHJQdndJeGNzcXIybk91MDNHSDEyTm84Mzc3UHFoWlVwNHZ6Slo0SkdIODhz?=
 =?utf-8?Q?OF+dve2G818=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cC9DbEcvYThtZFNNeG5hdmRtcmF1dVF1MHd0MG5yVnFNL2kxQW13YUlIZksz?=
 =?utf-8?B?czVXaUlLRE9zZUZNVGdORUtDMUxWSFExVnlMc2o4ZlRESFFQQmh5V291THJV?=
 =?utf-8?B?L09ORDIwZ294cnZPUzhYRWdKc1crRTBHV0JOOWwybkNHNVgvUE80TmpYZzJI?=
 =?utf-8?B?M25NVW5BRU9lbG5xRDBISXlnN0ZVbHpXeGNQcEIyMnQ1QWFwdERUaWtkSkQx?=
 =?utf-8?B?Z1ppTGVlRi9WWVBqVkl5Z044UmsrRDM0bGcrc2hETmVuSHRxQkYxbThLUDla?=
 =?utf-8?B?ejFyY0FpcUt4bWtUK1NyR01uQ3FSblFjb3dyTVVZYmdjU0YxdDU0WjNqQkJN?=
 =?utf-8?B?ZE14UkZ2cEk3SWt2MkZYWHZqY2I0QUlzZlY1QUdOYXlKZlVnZXJ0Z3BmdDlk?=
 =?utf-8?B?VjlUekpFTzUzaEhCWjdYaFYxN2JaYXQ3bXVzeUEzVFlOQU5Da0I1dlphVWdv?=
 =?utf-8?B?TmMvbUhFeFFweEZTOEc5RkxpemhvdVNlWWF1UTV6eG8zdnpuR3locU51Rita?=
 =?utf-8?B?eElwbzRqYThQQ0tLQ3g2SUJtNHpnME5DV2ZpcGFvQUU4Um90MTlYUDhheUw2?=
 =?utf-8?B?WjQvQ0ZjZVNaNUNUa1dNY2c0a3BjREJySE9GOXQxS2NIS3BGY1JuenBtWGNT?=
 =?utf-8?B?MC83bmJtS1RJR2tOTWIycEtSd3FzcGVlMGJPQmF3dEtKbVdhM3lwS0ZjYndE?=
 =?utf-8?B?aG1JdEx3KzNEWjB4ejNudTZuRnZFZEhNZEM4Z0YvdkZVSHlZc3ZTWjdvL2Y1?=
 =?utf-8?B?c2ZJWk84N3FjL3REK3R5L1J5eHllZzlDZVhBYUZ1YlZOSnU5SzhHOXBsdEJ6?=
 =?utf-8?B?SzNrMDN2Y2U0Ujhwdk1JQ3dSd2VRZ2NTNEozRE1qQkNjM3NxdmdXMm5UMjFM?=
 =?utf-8?B?WVZoSXJiWWUvRmVocy9DRTM4aVQ1cmdrRmlhb0VTTDZBQUZHWmNaSHUrZm02?=
 =?utf-8?B?b0VnOVBqYzc3UnVldHFpN0Nxd2lBSCtxcEd4OWpFVkFpRUFNd2ZVUUFWUTJ4?=
 =?utf-8?B?dTJiQnl3RkxxOHgwN0lRNmkzcmVOWVprY2d0MlREQ25rcUZHSmthR2tJMHBZ?=
 =?utf-8?B?a0lGbXphZzRNbFE3VFRzdWJtVWZ4aHY0MGkwOWFMNTM2eUo0cVpORHVEY0xO?=
 =?utf-8?B?U0ZGdnhkRDg3QjM2Vlh1NXY5Snh2QWlndFFsdThtVWJNcy9tU3Y4NHVveG9C?=
 =?utf-8?B?UEpLZmUzbXh4ZWtPWkZEWEFDdFV0eDh4YnE3ZUFVVWV6QWdFQ0hXS1ZVR2xC?=
 =?utf-8?B?bE1TOXdiRE42Rmp6ZW5kSkpxcG4wOW9kT0JrSWR2QzV1RnJERU1yekF0RGQ2?=
 =?utf-8?B?aDQyUFhIWVpvOXBWQzg3VGE3MFFlUlBheG5jS3g2bkM2dHBrRHVlN0xpYzQ2?=
 =?utf-8?B?M0hDUWxpT3JnNmVwa3liUFVZOThGdW9Yb250ZkNMMHZWTFRxYmdlMHU2bEpI?=
 =?utf-8?B?aXlINGl4TmVib09WaVRsbkFDWHYwMzlJeE8rS2pMR2QwYVVlRXVMdE9MZ3Rh?=
 =?utf-8?B?RDlPc2s3SFZLUUhkclhSTFVaVk4rN1NuQitUeVV1Wjh6aTFwcjRmeEx5MFJL?=
 =?utf-8?B?T0tTV1FYanh1WjROTmZwS3ZtWFhFODJkTENDeFhyaXBHSzhrbDU1MnNSRHpv?=
 =?utf-8?B?UEtkZkt2UURyVnNHWk84VHNraDVNaCtueXNWVU1RZWpvYlhHQmpROS80a3hl?=
 =?utf-8?B?N2NTNmZnR2FzdysvUndKL0NDVld5RnJ2OE0vZGIzVjBjTS9idjYydE5IdkRa?=
 =?utf-8?B?T044dGUwdUl1SWdlU2tmZm5ScTRSSUh5QmNpZGFPeDlabktlaTJkanJaWEhR?=
 =?utf-8?B?OUhHampuRTFQZXdMVlkxRERtNEtSMy9KWkwvd3lwbFcwbGNveVVrNC8vcWZ6?=
 =?utf-8?B?bmx3SkIrM3pVeklwM1hMMjJIM3F4bUJUWmpCQ2wydm1xRDdyR25meSsxa3hU?=
 =?utf-8?B?ZFZQaDF2WDdrUDk0Ymk3LzRvZjhsY2lTU2pIZmJJQVVDOWV6ZjRYak1RUkNI?=
 =?utf-8?B?bkVLSEhmSGFjcWVhbXpEcDVSUko4S1B1UzlKUVM3WVVMemlCQVlUYUVKVzJt?=
 =?utf-8?B?ZkM4aHo2VWtTMHZiSE9qb0FxSzdBNEFpSGpRSlpyeFM3dG5FTVlFRUl2YUlr?=
 =?utf-8?Q?JEBL4kLlidNHqnIackEoP8mSz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h1hD9OOwAIarqjp3BVAI4ixY5VEAxxA1TDoHaRdpkw9blU9Zx+qkNOucL2PduaNZcNkeLeQxaJpEmbY8MkZsPllY1Z6+XeQkdtfDE0ZSykxejp48TIflFT7U6FLJfyUcUDmWi/tmxsi5sCZtBReHJN5HXe1ajhIQKMhc52kr6jdCGT36/w87UPkrzyHWoJUB2N+pVnoumi3FILLPIW9mnX+0XBi1GlGAwLTONvYEqFxwbAWxPOlQJlW9VTLITtwpxKl7lrz0ALWwAcK++TGkLO3b7xwVEDDDdcCh09VnwD+4zYxhSqu4DZwdLhr8N/lGWG9+3YQ6bxFWRYcx3vNW8VWyqe5WsOcwlUoz3O4zaiFl52vkUGaSBKzxZ6HKL+YK2r3HhDfsgH5Yv5lz2rk2Yw0r4LT26WASMNBmrXvMhTqHD+utjum3N4zxX7RBSscOMo9bU3vpXdpMZmbBuwDtK+k0QDJhGFnRVx1XYLM03cVPUZVof2zR27KLoO5Qcjqb/8805ablfbpYNa2/gdHACBVxs4cXMyxcAykF/FwVQQqpFJn8nB/H3+9VOlw2uYxXpURAgtLr4Qyg1akOWXID3HyOI//R2d1sbhX31OZg3VY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf4d12aa-450b-4568-65a9-08dd840241de
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 14:05:39.0013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DtwQJVzLIBGDJ0iPkvx0mGoeHzTIDec+Ot5lFwQZIbIvz/6qGQ0MgPDMOLIr4s71oB1zX0BhW3ClSBnIM8VDOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-25_04,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504250100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI1MDA5OSBTYWx0ZWRfX21uM/ZAc3WIZ KaPkGggIEunfH4lTC7zS0aZIt8j3PC3kmY04jjqVMgZkdwUht9Rjqv0Yc4KGAFAMcvf34+SbCFv A5tYSdij+3WdpIQrHnmAxfB5gVI/f9XMNOR6orx9y4Ss/HmTZ3DrJLr58JLVRYvMpgBMWwgvuPx
 X5zAU89gJmIODYVDLed5+rJhMq4yPVQ+PgyQfeLPbZN5kRCum+lNkcsA8V3i7Xp+Tpec51BYTkA 1O7pA7W9r9FkchAXCmp8n5iyMAA1D98o0ldZ7HCYdsdhbRR5IU32Iolv7SS7+VXLLtVy3gyt5rg 45pOo0FvehY+xvNAQ8stHRE7F+1QiM7BbZhUzM2AMOtuuCezwybmMZMno7OtmYPFXvTmvWgs6ZC B8yWrnQi
X-Proofpoint-ORIG-GUID: CsTFRHRljQflLt-pdB3YcMt-JcotHGe7
X-Proofpoint-GUID: CsTFRHRljQflLt-pdB3YcMt-JcotHGe7

On 24/04/2025 22:53, Darrick J. Wong wrote:
> From: Darrick J. Wong<djwong@kernel.org>
> 
> Add all the new statx fields and flags that have accumulated for the
> past couple of years so they all print now.
> 
> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

FWIW:
Reviewed-by: John Garry <john.g.garry@oracle.com>
