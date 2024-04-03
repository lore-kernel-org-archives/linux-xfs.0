Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D888A3E48E
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 08:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712134178; cv=fail; b=nQWd5xIqOSTIgbcX7ubIysQgqDuSYQkMVcPxKUHVV7hA+Tsi3ecCiwaN4RxaY9b7Oid9PcJY5AA8O1n9FaStoQotmz6DrkXrWJIBSWAzlb5KAuI5vUudQ4zmQXio0gjfv2sTKstG0tMRpUlJLutjyJ+DK/CHXggY+NymlnqdW+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712134178; c=relaxed/simple;
	bh=EoJmlxxZyQAy/4/AdVt3yq+elKatdwqVShlqCwjs/Ik=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ODCZn9MBAs7yVCX1iPURM8cWOMfqLNo+rb8QzGwUHffCXL/H2jo8ssPwVbeH5vwVCbYYeV9WiyBrYAlPcUE1oHQ2jUuKF+PqkOVSrsOiaCtPTtAnUY/IPk0jmS9g0fDddaQkkAjmXPnIQa2eJNJdIjDNt1iCABA9jj6qpMxYmQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jl2jarVK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Wfv6lHKH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jl2jarVK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Wfv6lHKH"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4334pE7W008597;
	Wed, 3 Apr 2024 08:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=2lsPoBKZQfdTDIBNqAgLk5BiSYzdIHJG3UlqMxT8OMo=;
 b=jl2jarVKAs8gcQ/3aSC2+F7n2YKc7QpeLBVKi18ZAKh/QlTx9IiIWmjJ+1eBFXeJMm3+
 5Cfu1IcQOomu3ReVTHBkSkijGcuxsqntGW5JXtvjw4SFQlJFW3k2JB10C4Kbfq+iqi8x
 IncYXKQWIe/aZwaHAChhJEF3/Dvz7CDLiwzlvgWYXGIJc5xRf0+roVxElkO0Ofe+IzNQ
 vHSM+R/1aNrew0O+xfDgYcmu18bj1ic50bFgAz3yDrTiEjRw4kmuCQZ4qcmEKXGPDuL+
 oFTVUn2MQBBwv/iZIrfN0GmQ+zTIR+pjobhJnmdu1sN8LEPlOQUllJxRpdW8JOuXw28S 8w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x69b2pp2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Apr 2024 08:49:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43372HfX015396;
	Wed, 3 Apr 2024 08:49:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x696802kt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Apr 2024 08:49:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBIsBI4zPD+/+ErK2QjRqOcu+J3vyFkEvaYwuHnReq44g/+GL1oQw3ZA5fqh2sWstJvprjfPncCSiK/NgMMyB2E9Sp4T0WT9O5R98039ut3yiEiy4SrttlQHixGy+fToBc4MTNyJtRhURCJLWkH4j8VbuKBIqNih9qbg5VHyLeg66rb1FvQT2efAbxhWnbyl0WKTTEeCGpvJWc7kSp2ptXyqmIoaptd0+Po9X6T1NhXdgTd951dMCNIRSVGB4w9v52GLRaynKVGXhNU/cGNBRARnuOjHuJ/D2jyL9i5GSAL6rNvkr70f0pQkdEB1vagyorCFeBhhiPUlWELN4ONDiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lsPoBKZQfdTDIBNqAgLk5BiSYzdIHJG3UlqMxT8OMo=;
 b=cwGE98edTK/XsuB93neYPuQqjUq3qsq8lKTHNmc+YdHmZ4BKwQilTD3QYzeMeAs6kPUb2F7FBgSlWuLXSJSnRQCWjAd5XlIHAC3tf0s2+Yr9ZtjiHCxq+dOCagwFGfkxxPKTF/wvVCp/gOIom1EW/TCEU5sxOZOfWNyYYqBdO9Dp5z256fPKqLUpo1p3ckiiqZIfwIQkVqzP3d0wP1nZ6FIZD0OSlh+oEBy5QPNm/sq8w5GdVZvSdNpbzyvZryV5WQZ4agS0R5kNBZHSDcP8NO0jaYzg1xXHzjIP4Cf4JAeZepOjH/hTHS4gVBaCCvTPa0zS67CSTAZTHnmPCYKImg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lsPoBKZQfdTDIBNqAgLk5BiSYzdIHJG3UlqMxT8OMo=;
 b=Wfv6lHKHXsUCudK+E9CyN6RXeIcOLFnm7YxocOGj17KgnjbUSRwEq1UV0MHsuLtDwboUb86Erj5Y3bV9ahO08vJftI5HWE/n3oXDeyI5rF8Rf6EnibuAZaqyFyZe1gIQ3atvPKE6FftPDeE8yUrnll1NI+Ztf5ryBdyOO8ZB8zg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6104.namprd10.prod.outlook.com (2603:10b6:8:c7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.46; Wed, 3 Apr 2024 08:49:09 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Wed, 3 Apr 2024
 08:49:09 +0000
Message-ID: <d17cbb52-0d30-40c9-b700-6617c50fa86c@oracle.com>
Date: Wed, 3 Apr 2024 09:49:06 +0100
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
 <fd9f99a3-35ef-477e-ad64-08f71223d36b@oracle.com>
 <Zgx4BhcW9/6XAiq9@dread.disaster.area>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Zgx4BhcW9/6XAiq9@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0004.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6104:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8dZOR8BKDQzAtFUF3ZGYhD3cM/qiVuhxkvxopjH3pYfhv8hpUd9QnIe/o8ZW+h4Q3Kk7ABOEtZNX+smLGSVgtoByXfE0//yHk+NHgVqWJ6yqxxxYvazTOwqmJi1hu/1YIkzmUsgSKpYEq2Xuq+JbdkQ29t6Y0IwSEUaIjobtatI0xHA7vIANxiFYkXp9Q+1KGa1W0yM7DvPrXolGvjm6pnmQ4bIpoZC6H2XIaUOubw7K0uMBnZ/jvbVc0Fy0a/pKPw5NVSJwTAufAPDlricycObSUFLMV4Lkg+KNO60QE6GZE90Fq/gK12X8WEiaMXn/UU7iNNeoeRuy1fgYupcAhUd/xVsWofxVbaqa9PlbqHzMhLVWK0l3davOVCjdp8MPaPNnOKOM1d27OUSr5PzTT4DXqgZ35ai7uo+zqEtL/ruGvLta2XorQW1J+EJq7bakCZ33QbZnsFN5rR3ERfuZ36MsrTD85CfQXMgbmf1HUlRez3NslrMpRB6DIJTTsX/j3zvGoR1VyV1QWfC1JMnBSlhDhB7xrv38Vf83lVa7ufL9Ix8YLsRdNx857gSdE0CCsC9d/rUtVmWvQOP4hEyJO24jt7sWe/GlavbAYxfPsS+gGHd4iBZCq/CTGtpqQUVwT5DugU/2bnWtAqSLJvOYZkcQgrefcYoD2ZtGVLmS6Eg=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MHNCeE1IZjdlZnZJbHBxNjdhdFZlMWZLYy9OQThNWngyVXlLNW9CVXBYcjFi?=
 =?utf-8?B?RjM4bEgzTUdBaTdjTlpLeExUVjZhLy9ndVFWdE45elN0cVBERk9lSTNsdTUv?=
 =?utf-8?B?azczeWhNd0ExQlMvK3U4MXBIZ0ROL3k3MW15S3F3em92SDRRc1dINFpJZWNn?=
 =?utf-8?B?SFFQeXRGQ29yMHFxdHlzR0tFamlyQnZCWUYxeG1qc1Y0eDdjWFh3S2xlUWN1?=
 =?utf-8?B?VVQxZEdMUndsNmRGYnI3N0tEc0Y0T0tOK0phVDFxeVhlaFFLbHl3dlc1NFFz?=
 =?utf-8?B?T1NHL0xMMklxMldtejQvK0Zpd2JFYURVc1dCWmkxOGh1anp6VS9ZN2ZncTBO?=
 =?utf-8?B?Q3NNSEVPOU10N3NVL1JLUm1pQzVqTkJkSWlLdTZzUVh6UjhOSVJwdnY3RnRW?=
 =?utf-8?B?YjcyTHdRcFd4eEdvNjBheENmR3BSbDE0b05OWEN4TDVtVWRxTW8zMU10MldT?=
 =?utf-8?B?UW05QkpQMllmcTBaZzN1TDZidEd5dmtnZUkvNk5BWkU3Tm1xOTBEeVVPbHV1?=
 =?utf-8?B?NHhvb1hkRlNPNXM1KzVzWXdRWmJoRzREVG5oeEkyUFo1NDBML3A0UXQ1VzdQ?=
 =?utf-8?B?Wll6eTFsR3F0QVRYQmh2VjlOWUJPUFhrNzJBMFdiWHlSdW8rN04rSWtDNEw5?=
 =?utf-8?B?S3RxZWRucGlJK01rV1VyMXZNOHprYkppbDI5QlBEM2JJTTBzcm5IYWhlZnVz?=
 =?utf-8?B?b1NvL1o5QzFMNW85QUsrWDhoa05nQU85bVIvckdCUHAra0s5dmdYak81UGpt?=
 =?utf-8?B?cGtBMDBBRThXS2phN1BvSG9YTEhKalBjdEhxRzFFdlBsbkFuZHR2bU4zNTQr?=
 =?utf-8?B?bVhyRjRHODZGZm1teHdiY3dnN1E1dVYyOWF3NExUNldXYy9uVTZjT2liV011?=
 =?utf-8?B?NE9YUHd5bGpsTHo1YzBFd01vTmZkcWlwT1ZESGVrcVlSQkJQUEpXV0tpOUxw?=
 =?utf-8?B?d2tjV1B5WldJcmNHWSs1UStpQUcrR2VYNjM5QjlORXJrVjdOZks2M0hUWjk5?=
 =?utf-8?B?L1dBMGp3dlFRZ2Z0TDNmeWFqUmwwU3pJOHBiZkJsYThKNzRST2lJSzg0Qlkx?=
 =?utf-8?B?ODJzZWo1Q3lFWER4S2FPUGdTcTArQXk3UUVMY2ZHcWtXY0hBVEhKUFh2R2Ez?=
 =?utf-8?B?RDdaVW8xOU9paExVNW1UTjJSd0dPR1hhTzc4NDFCTUh4LzJPS0t6aXhKRUN1?=
 =?utf-8?B?QmkrYWV4dGFmUDdaSWg5WFFtQ2tJVUhTdjM0VW5Dc1RLS3hiNXNqcHlkNzE0?=
 =?utf-8?B?bE9TWXdMdWhNZXpHZ2tVMldLLzlvblordktUUHFtQVlVWjI0TTRaMkpYVkJi?=
 =?utf-8?B?THdWaDMwUFJ0bEFZVUVwWHp0QWI2S3lEVXBIQ1plTEtNUkViNlU3OFNWM3Mz?=
 =?utf-8?B?L1dqaFVqTjhneWI0TXJiMURSTDZSc2NYeXN1REgyL1NFVlcyNXBJOGIxdlFs?=
 =?utf-8?B?UXUwMStlNlhrWCtoZ01XYkdnK1EveUE4RUoxUHhZN0F3dTBrZU9NajNFZEpm?=
 =?utf-8?B?cVE5OEVWWTQ4b2JOQTVvdXh5MUUyM2I0czVxUE9LRExFZlBhcVRnL2ROL29w?=
 =?utf-8?B?c0dWSWszakxXQVdITDd5aG0zVGRsd1pPN29hMTJtbW45NVFQOEJ6M3ZhSnJQ?=
 =?utf-8?B?REpzYkc4RElJTGhjRWQ2K1o5N20rWGs3N2RVaU5GRlZJdFY5SHRjTXNPcnZR?=
 =?utf-8?B?MU04QzM4SHVJRzNJck1IUzVBZTVTWkhwSlB2ME9KL0JjWGtVNEpwblM5eHI2?=
 =?utf-8?B?U1YwTlpWUnBWSE80dXRBR0w0KzR5S0FCamNOd2NXV2M3Qkxld1h1eFkxSVZ6?=
 =?utf-8?B?NjlReGdMNWxTUkxQL0tROXFuYitKL0tVUi9QazZuaDhYazZXTFhwdXUwN2th?=
 =?utf-8?B?TDU0ZHdVcEVrbnhaNERSb21FYzQ5Sm5qY2pIelkrb2Y3VXVJUDFVQmxUVTRh?=
 =?utf-8?B?RGRXZ2xZWEZMTkUxbi9jZmR6R09qRmJ1aVBtTEd0YUVmalUxSjF2RDJtNjlm?=
 =?utf-8?B?MzREWXMxNmNFRVVFRDBIMkJUdTc5YnNTb2xMRktPNUhhUElROTdlUDNXM2xC?=
 =?utf-8?B?SGNPNldhY2dQcGM2RDQzbG9qL2cvbGY1UkJCdFNTWkNDV0FNeGVoMmZCYlVH?=
 =?utf-8?Q?sAe7qm1aPU8nt+PCAIMp3XhLz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	r8KrnqT2tfgSKHzvNVp0GBOki8udcrzAJHlZ2VRayH5f70W1Nej3hvktygFUnnCbpN9A1gtRLIgrRw0r3rwPgzlVp3AoQS4uifAEsgxhvrwUCnJYNmwqjPQSVeq5AL/KfKM5QBgOnNDWxHLhtNLc95bDZlT/9173H0h1eeRGHScSpuCHC6NZCcCGdXDrO9aKE826gjHol8xO/kldN77PXXu3IJm0iK0/HW9H9KtEpuSK8FGRptzYz1g2fH6S2bpcuwueVjRFmT4YPQEZiVAG777HwzaPaPRjzinhlGxGn7gBIm27FU9SNJFZ+fw6MwoBd7dLBaFow5BNYQP361UGX41YQjwri84As4tKmdax7NObyroKOi/hlQqR6HlOV7SW1LYvPg/udF3ACcx7YsQkqdPE9lGKT/CkumivdEE1IzxPYjWMPOzGcAywN+QAZyhFO43vT5wTtge9kwB33oYiN05mw3gHKV/fAekSS6J0sx+cw4eRHKEyKeMEKqIyD3rODSoljC0Rm6vjo+YQHj4bNReTumuTXGWJLzjHD8xtUI04w37TZfLLlK4jWXPY/l0C49bqEf3zms8N/KG7ILF2s20s9WUypm1jLHJ9phugOII=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f14924-4499-42df-e736-08dc53baed8d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 08:49:09.6321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bKwq37p9bvxCHMr4UxeAyZget0wcfr9xIzYJXQLGXfW1HpVMafI6ogl2g4/iajJl9oK7MCJDtvK6GW8KDmkDbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6104
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-03_08,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404030060
X-Proofpoint-GUID: f3fz5bB7gYirr9rOGGGS7CqPLu2dILqA
X-Proofpoint-ORIG-GUID: f3fz5bB7gYirr9rOGGGS7CqPLu2dILqA

On 02/04/2024 22:26, Dave Chinner wrote:
>> And then this gives:
>> args->minlen=48 blen=64
> Which is perfectly reasonable - it fits the bounds specified just
> fine, and we'll get a 64 block allocation if that free space is
> exactly aligned. Otherwise we'll get a 48 block allocation.
> 
>> But xfs_alloc_vextent_start_ag() -> xfs_alloc_vextent_iterate_ags() does not
>> seem to find something suitable.
> Entirely possible. The AGFL might have needed refilling, so there
> really wasn't enough blocks remaining for an aligned allocation to
> take place after doing that. That's a real ENOSPC condition, despite
> the best length sampling indicating that the allocation could be
> done.
> 
> Remember, bestlen sampling is racy - it does not hold the AGF
> locked from the point of sampling to the point of allocation.

ok, I assumed that some lock was held.

> Hence
> when we finally go to do the allocation after setting it all up, we
> might have raced with another allocation that took the free space
> sampled during the bestlen pass and so then the allocation fails
> despite the setup saying it should succeed.

My test is single threaded, so I did not think that would be an issue.

> 
> Fundamentally, if the filesystem's best free space length is the
> same size as the requested allocation,*failure is expected*  and the
> fallback attempts progressively remove restrictions (such as
> alignment) to allow sub-optimal extents to be allocated down to
> minlen in size. Forced alignment turns off these fallbacks, so you
> are going to see hard ENOSPC errors the moment the filesystem runs
> out of contiguous free space extents large enough to hold aligned
> allocations.
> 
> This can happen a -long- way away from a real enospc condition -
> depending on alignment constraints, you can start seeing this sort
> of behaviour (IIRC my math correctly) at around 70% full. The larger
> the alignment and the older the filesystem, the earlier this sort of
> ENOSPC event will occur.

For this scenario, statvfs returns - as a sample - f_blocks=73216, 
f_bfree=19950, f_bavail=19950

So ~27% free.

> 
> Use `xfs_spaceman -c 'freesp'` to dump the free space extent size
> histogram. That will quickly tell you if there is no remaining free
> extents large enough for an aligned 48 block allocation to succeed.
> With an alignment of 16 blocks, this requires at least a 63 block
> free space extent to succeed.

# xfs_spaceman -c 'freesp' /root/mnt2/
    from      to extents  blocks    pct
       4       7       4      25   0.10
      16      31      90    1440   5.77
      32      63      12     400   1.60
      64     127       1      64   0.26
     512    1023       1     640   2.56
   16384   22400       1   22390  89.71

> 
> IOWs, we should expect ENOSPC to occur long before the filesystem
> reports that it is out of space when we are doing forced alignment
> allocation.

For my test, once ENOSPC occurs and statvfs tells us more than 10% space 
free, we exit as something seems wrong. As you say, deducing an error 
for this condition may not be the proper thing to do.

I do also note that if I then manually attempt to write the same data to 
that same empty file after the test exits, it succeeds. So something 
racy. I also notice that the FSB range we scan in 
xfs_alloc_ag_vextent_size() -> xfs_alloc_compute_aligned() ->
xfs_extent_busy_trim() returns busy=1 when ENOSPC occurs - I have not 
checked that further.

Thanks,
John
