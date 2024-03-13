Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569E83E478
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 11:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710327820; cv=fail; b=ALqyP3Zdppjm2P1acAyes9R/sPKu8CuEzrUeykq4K8yl6jpc613sK7vRFgQaMeLO68tcH5kbQysVvAcEexYCDtQyBLL7HMbzHygyk7DVZgaSzNmQu1nDBV15YWzmNTdNkak4YoCt7011TGdS9YP8Mau1ri/UMpsjDMcedWpXoqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710327820; c=relaxed/simple;
	bh=AkI4l5U8GKRBJyik+YuXxpP2tcSk/Ga6CX+Tm+1rt2U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hxCMdwsiYC+Oyzhh+ff8otPNn0cDS8eqfwlX7MfOLBbwuGyC3yLpvNUceEQK75va8aYsOz7vBe7H4t5Pnw7GLPS0O8Bewqz7+wEx7lk37haXcj1N5d3h0SW7yKzOu+5qeLd4DF60VsfwUcGz4j0C4K6fcwg1JhAGc0IPboSBjOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iE6VZ7ZG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P8DPA+D+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iE6VZ7ZG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P8DPA+D+"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42D8huWw026177;
	Wed, 13 Mar 2024 11:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=oWnczBq+vP3DlgPvM10A1F3EAekotS5uNnCcfsEYDkM=;
 b=iE6VZ7ZGYE2QeMKn64nuenu+WQeBvxB8C/UyAj53fdeFguVcmo3UA1Q4hLzmv1pUrGCy
 +piVlbSDvyAmM/9Zv6olqKFBMKaBRmO8mf9d1ma59qhOGqHDIT/RyVrrVAwRxU0lhEbX
 Aijx9D2/uJss0neLiG976/fXu1qKKrddFxC6LsLt3VIAaSjj/gB+QTARCNadxLoqh0Aq
 FN9XGgX5oI59ZUd6CdKWB3cxNntQXOtAH4lSAlxqMcVh5gpP7GWYqBJxvZ+PEBXpLKKq
 zD9osB7IpmpZuk714/jZkSfSEScc9gTSIki/pORH2XfQ/jb3aQ4/CYCeJEgML+aawQai NA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrfcugr3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 11:03:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42D9R52E028539;
	Wed, 13 Mar 2024 11:03:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre78mmws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 11:03:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhDHHPtHveqjTBkkDn64YPK+lBNXY7g7lAZjDsj0Yb6KNBZJ7xGnixIdWSYX1ZkWHCPHhB7rRCKjDONt0Yfi9rDlLKVwh5UMosmz0nQXMCUt4aMU5JCWhyj9TTTAEamQoyhVnKJORFdw4aXerkBY1u/WDleUWAevakC9foftvalXAUo4xg2UXBnaAr4ndLvTMeWAQvumTJ4UU2Zi3Mh2RNszeYT0g9BUlxHFJhDwL3+88sOoHJLqTzih5j0zcnZtbFJV9aQw7hphbv6LPJP0K7v+oM0o05u6yxfCevSnAb6iZsg4wBPio6D11MhFihfTYAbIZsfLETuOLj0jR+kXWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWnczBq+vP3DlgPvM10A1F3EAekotS5uNnCcfsEYDkM=;
 b=DAo4e/O1EfRTTYwyF5uCxLbDfzWJrqxrJSzSvOT6Gr7oTow2hd4V+f3VhxmeR9cJ/3OpzyEvtkZ6hjwpJJdiFA04jsNAzhMAEjyyqUs82ghlJc0YyYEDKCyJwSHS/QaUXszBMtUsL+PE3SgqJGbQB0ySy0WCFn/CvLPSlx+ctXfUpIIfDyZ4WOFVfrkgxP1VhOK3lr+UjyQvan5WVzgg/PBf57TGxOyyB+qm7D5iFT6C533JFxyArO/KyNZCtATdVQKmTnC7JCGyqUSY1WzUUTvjSHDWic8aly5bsguTQq9a4i5wnWH2bsp5qxYI0+rToiMSzGGc6O4uK6fXgMOgsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWnczBq+vP3DlgPvM10A1F3EAekotS5uNnCcfsEYDkM=;
 b=P8DPA+D+V+k859YDELo8LxljQ2KYvKk8gvJfkjQWN3QDZXzF+7ZIEouoxyc0IFVdkmM3tjtoUxpi9RFDMZ4PFxN6PkWfmLzgaiSpwAWckNVNgmAxho/cS45TYVdk5ncP+95Y3LpgJpc5ujTdw/BH/yKZWe0CSbE5/r4romoDhKo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB7634.namprd10.prod.outlook.com (2603:10b6:806:38a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Wed, 13 Mar
 2024 11:03:33 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.035; Wed, 13 Mar 2024
 11:03:33 +0000
Message-ID: <9f511c42-c269-4a19-b1a5-21fe904bcdfb@oracle.com>
Date: Wed, 13 Mar 2024 11:03:18 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] xfs: simplify extent allocation alignment
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: ojaswin@linux.ibm.com, ritesh.list@gmail.com
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
 <20240306053048.1656747-2-david@fromorbit.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240306053048.1656747-2-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P191CA0022.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: f1a6757c-ca97-4179-7091-08dc434d32b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ATUEAkl6Y59qygHV125xgWNoVid4rF68OzPD8Yy9Z1xvGt965PSvyrEXdchTx/qzGJWgs2lCIJ0voMrz/M/7voBQezgyB7VQqdZ/aGxUR/FetXA7H24NkeFly1N0Ul7BatFGHsrscv7RYzzLteOsgZw7DLtxhfqN7azH9Ka1gqnxyXZKC/tevMrDueB10p5geoTyiPpaWYL53gYXJm+jMQCjnP8zwVuETtabl/dkB7QBZ0yXo/k1ZiPgPLWU7lC2+OwU4JoTD75K/EzX2SX/58ZDZXTMHcwvaqFDH4mkONxluZJvFkCSqD7TmnV17T/3UCRWdtK14JQuM5mdcp8GWXNXJ9daeR0KrQ3lcgqnHie74lk9Od8dINcDWtw5Sllgu214anyYQL4E5aEypfQ4iBuIB395ZNQorAUizF7LXJGEGUt9sFd4YeGn5tu10DPpB8Faz8n7oPdClQ+JOQAcO0T7lw+FBktGX2gDNr8Nu6AraxUobLVaJ7Vzyj3fVEEsf91FwwUOiJVuzQSbYiCD2TI1LuDJDhnuBhLG59UZqBXvQDJZaY0HloH394DEhpm0G+4uyv+iYJ4U7lcv/+zSIDyGAashz8Lh9c2exr0g6Xmcx/wK/3S5HvD6P8uE+KZdh8ENrgzBHv6rjjeFDk+URAeXHHzyYCWM/V9OTV3WBtY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VFVxRXlYYUlWaFlFb3lPaFJ5WDBHaXdML3NqN3ZNbTUyTE50dE9ZWVhlSFZh?=
 =?utf-8?B?UUJ3K0t4OUpvdDNXdjJ5U3VVMC9mdzlNOUpYY0dhZUMvNlVuK2tLVnFRdWRl?=
 =?utf-8?B?Y3NWSUxad2tDRHlWTDFRMnpJQnVzUmZKdDFPY0tlTEttL3RBTVZ4TXBteTBv?=
 =?utf-8?B?UnhBNDBReUlYdGU2NEt3cHNIQVN0RnpEOTg5emIydG5vd0dzSVBaejc4Mzdj?=
 =?utf-8?B?OGxaWGZCVENLM05kVkpKTXFMbWc1QXg3ZDdQTEIwRFd4WkU1WkwrNEpCZ3Vx?=
 =?utf-8?B?RUdQVkp5N1VUWElVcDlkVTloTFNGVkZ2WEtkeEVDOHlWeFlHODA4aWttMWxt?=
 =?utf-8?B?Q2o4TU52Y1dkcDFHb0NDaEdtVFVGc2lYcGVHUVkyclU5RDNFL1lXaGI5VFp5?=
 =?utf-8?B?d1lKVnI3Rk1EKy9acG82b2ZjUjM5ZUcvVVpvZFV4SzdxZGtYd2k0M3VEaEhp?=
 =?utf-8?B?OWFUSXdQcS9INW1qRVNseGoyQm1jRDdGT1hoNEpqQUZ1MFZsK0cvUkZYUlZB?=
 =?utf-8?B?aCsya0hwOHBhcjVtMnd6MGFvQmNPQjZjQkJqdHU0OWZJdE9VMGpHeGJsOWc1?=
 =?utf-8?B?TklodHVyNG45SmdNWFVuYjJTcmc4Z0JRSDRHd0tIWnJmbG1qQUFmSlhOdmVI?=
 =?utf-8?B?eFNWR09nbVhXWlErZk1ERGo5RWJxQ3ZhWkx0MUNrQURCUFE0QjI5anE1ZnBk?=
 =?utf-8?B?N05DU1dOSy9rWUNodW5URWRRTk52SnRDVkVML2k0SnRoSXZZdTBObnlKMUdL?=
 =?utf-8?B?dyt0dWN6Smc5SFFoTC9UWHdVaDhyQU82Y3lPUTBOenoya1NVMldNNThpZUhD?=
 =?utf-8?B?Ris2VWJTNmplMUI1Rkc2K0k2ckxtdUcrczFBY01VOHZ2RkRoc1RrQ1QwZ2ZI?=
 =?utf-8?B?WElDK2lKOXpBNFJyZ0F2dUZhSDFzT2ZBOVNoUnFFSVFUL21PREtyTndGcFJJ?=
 =?utf-8?B?Z1BZS3BRQmQ3eThkT1dINmxLbG9udHdmNUdjM1h2TDZjc2dXWER0YmQrNWJk?=
 =?utf-8?B?V1QwNnVlM09yaUNnTzE3MmVjaU5YUWhZMHVKdmJXRUE3dlNJTHk1cUNmamly?=
 =?utf-8?B?NGt0RGU5bFBqOUY5QVZXZHczTzZjdGZ6Tmc4cnpyRzZaeDYwUWw1RGovbjFT?=
 =?utf-8?B?RWpreTg5ZEhrV21mbUlqQU5tdUd0RnNVcVdzMzJDYUg1SThzbHZjcGZTd08z?=
 =?utf-8?B?UUs4LzhxdEplMEZuZGxUTU55REpVamx6SjhLNVdZM3p3b1lSN0NrbkVsU2JS?=
 =?utf-8?B?cHhSQnBDNnBGcEJYM0lmL2luK05NU3duNTN5RFFUZUNPSVRYQmJ1QlR5Uyt1?=
 =?utf-8?B?L0pLb0VvSys4RHRsUWZ6RVBYNlhVYnRBcytwU0ZmV2hOK1VnT3c1Z3Rhb2N2?=
 =?utf-8?B?ZjhDMS9jL0V0TTFVaFdhTFVJRDZQWXlkWno4NWpTSStyenNNa2M3RDc0THFP?=
 =?utf-8?B?QTBhVCtzWk8xdklVZ0o0M3hqWit3bkJaY05od3pWeVRnM2pzM280VWR5RHor?=
 =?utf-8?B?UFFpdnQ2OEI2VU1aaVQzbkhTSWl2MCtaUElpd1MzT3YxbUF1Q3YreGtMSUNp?=
 =?utf-8?B?NnM3cElRWDBpdnFqL1pBdXc1SnVmS3hkZ1VZYnVlYnVYY2JsWUpiWlVwQkxV?=
 =?utf-8?B?ZkR4TFkwTkR2ZFJ2NTVIRVZpZ21ROVhzSks3bGpKKys2UGp1Y3NNMzdPNUtC?=
 =?utf-8?B?ay8xY1VxV1oxeDJBeFNrWlRVeCtyZHNZVzRuZkpubVhlbmVDZGhOY3JaMExn?=
 =?utf-8?B?aDBqakl5RGtreVV6bkE5Y2plcmpyNFdZazdjb01WT3F4TEFIaDlBbXhpK01D?=
 =?utf-8?B?cU1lcDZ1dkY1eVpCck9OdGljMkUzTnFxekkwa2FYQ2cwVWEwdk1UOGlxeEpS?=
 =?utf-8?B?TEJBclg5TVhnYStWajdwbUh4SDQzdzcvaHM2UHBOZThwR2xBck5DQm5McDR1?=
 =?utf-8?B?bk93aTFnQ1Rkc3l6RTdmZnYxNTJDY3F6VlhWUTFBMEVORzlpd2FDZEpUbjZo?=
 =?utf-8?B?UWZaWks0VnFQYTBNQTNJcnFhZEpSSTN2cHgwQlpmSE5lRmYyTFJMZkJrYkNM?=
 =?utf-8?B?elc0T1c1WGx6bVVCS1VBM1BrUnF4Vlh0Vm5McmllUER0RnRrTUljdGJNV0Jh?=
 =?utf-8?Q?T6T1EOCim/KRrKOvy2WHt7qXg?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Rkn9Dz9xuetAPIP5qmPIPykQmOJCiOmLsNpoYu43JV4zcyb+WJd+aOklV9h3RX8nzjzJqHMnEACKVCxkKzCfr2zjHuki10HeEP1iYUhjbsRAjlqYEjPfdWRMxOYIeuYs2EiJOy8w9cTTkLaHLIsb1iKw82WAgZmaVvkXX2g0CXhSYpiwl91kYYI6EYx99kyfYqBZr7oyV5vgqRLdMkCEx4OtPgPw0Muw3q4qXdrKcQlgh1SIcvVyHUehzMvZV9+s79wEkPv5e0nO+k0ePBXr7H9McTXrIeOzQfTg3anw1pAngRBONz2e7ch1nqOJFToNcSesbiBoEbNevfnhj0nNt66ONGnWR1Io8g23yUfOocsMhG7mLFoshSPYqcM/IPTSUOWsWk53bW2/1R4/oKPS3KVH+BDU86StQ1Ha2QeEWf4nRsS8sapSgqxI+q6jM3njM/YsNWrkZ/SRORUSBoAo/eGCrnEy317Upy+049j6l9C8c4AIyORpLxUzhyNrjNZzyOoykG5k5ER17lA9u58JCVU08o+JTa8MzjuD9m4h9wTf38yL4rUptHZ52F5uGEo8MLpeCKaZ4heL/GOMDVTn/K7+0R7579fYNHNedOmqsqw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a6757c-ca97-4179-7091-08dc434d32b0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 11:03:33.0522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldUplycswtQ3BMJuLjlR8Rv/RcoIwgRovxWUPA37np3Qpa/2F3sjFsCBGIAk04v7EZk0i4XJDEZ4WNkAIElw2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-13_07,2024-03-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403130082
X-Proofpoint-ORIG-GUID: 2hCtuHZ5tR9qbQZnHIcwy8V9MIzLfM_z
X-Proofpoint-GUID: 2hCtuHZ5tR9qbQZnHIcwy8V9MIzLfM_z

On 06/03/2024 05:20, Dave Chinner wrote:
>   		return false;
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 0b956f8b9d5a..aa2c103d98f0 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -46,7 +46,7 @@ typedef struct xfs_alloc_arg {
>   	xfs_extlen_t	minleft;	/* min blocks must be left after us */
>   	xfs_extlen_t	total;		/* total blocks needed in xaction */
>   	xfs_extlen_t	alignment;	/* align answer to multiple of this */
> -	xfs_extlen_t	minalignslop;	/* slop for minlen+alignment calcs */
> +	xfs_extlen_t	alignslop;	/* slop for alignment calcs */
>   	xfs_agblock_t	min_agbno;	/* set an agbno range for NEAR allocs */
>   	xfs_agblock_t	max_agbno;	/* ... */
>   	xfs_extlen_t	len;		/* output: actual size of extent */
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 656c95a22f2e..d56c82c07505 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3295,6 +3295,10 @@ xfs_bmap_select_minlen(
>   	xfs_extlen_t		blen)

Hi Dave,

>   {
>   
> +	/* Adjust best length for extent start alignment. */
> +	if (blen > args->alignment)
> +		blen -= args->alignment;
> +

This change seems to be causing or exposing some issue, in that I find 
that I am being allocated an extent which is aligned to but not a 
multiple of args->alignment.

For my test, I have forcealign=16KB and initially I write 1756 * 4096 = 
7192576B to the file, so I have this:

  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
    0: [0..14079]:      42432..56511      0 (42432..56511)   14080

That is 1760 FSBs for extent #0.

Then I write 340992B from offset 7195648, and I find this:
  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
    0: [0..14079]:      42432..56511      0 (42432..56511)   14080
    1: [14080..14711]:  177344..177975    0 (177344..177975)   632
    2: [14712..14719]:  350720..350727    1 (171520..171527)     8

extent #1 is 79 FSBs, which is not a multiple of 16KB.

In this case, in xfs_bmap_select_minlen() I find initially blen=80 
args->alignment=4, ->minlen=0, ->maxlen=80. Subsequently blen is reduced 
to 76 and args->minlen is set to 76, and then 
xfs_bmap_btalloc_best_length() -> xfs_alloc_vextent_start_ag() happens 
to find an extent of length 79.

Removing the specific change to modify blen seems to make things ok again.

I will also note something strange which could be the issue, that being 
that xfs_alloc_fix_len() does not fix this up - I thought that was its 
job. Firstly, in this same scenario, in xfs_alloc_space_available() we 
calculate alloc_len = args->minlen + (args->alignment - 1) + 
args->alignslop = 76 + (4 - 1) + 0 = 79, and then args->maxlen = 79. 
Then xfs_alloc_fix_len() allows this as args->len == args->maxlen (=79), 
even though args->prod, mod = 4, 0. To me, that (args->alignment - 1) 
component in calculating alloc_len is odd. I assume it is done as 
default args->alignment == 1.

Anyway, let me know what you think.

Cheers,
John

>   	/*
>   	 * Since we used XFS_ALLOC_FLAG_TRYLOCK in _longest_free_extent(), it is
>   	 * possible that there is enough contiguous free space for this request.
> @@ -3310,6 +3314,7 @@ xfs_bmap_select_minlen(
>   	if (blen < args->maxlen)
>   		return blen;
>   	return args->maxlen;
> +

