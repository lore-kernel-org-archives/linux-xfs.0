Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DD31CD33
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 10:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711017986; cv=fail; b=AxD1pzI8bmpOunQhT+fN0TrqCcaKFdoMG+YSy0u4eGPuzjwNvLk3EmuT1+/lpSTxI/5+sZnYkWkvjt0u9+DBHK+SIPkyKflm2ybrVXnzqVp+ruK2N6xed9Znq15Jd0ZtOxihPFdoo1cUcWP3cqrycWpyinapw69amuBVt9L04xw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711017986; c=relaxed/simple;
	bh=FLn88oJNcfaiXSovmIvYXFHebcyVZddQvvfZL0Y9T9w=;
	h=Message-ID:Date:From:Subject:To:Content-Type:MIME-Version; b=DMyT949u0vl0MH0JGNhFAVogS9cx5n/7ONw6Hi/eh0LOSiRly31+Xas3o4fDjfsvMQb6yIVoxcceeXQ4wEAr+9ngMadmzRRJRKMFx6y3ECLJgQlAdKaQO4GDPnKMM3dx68a5qB2Ld0nQvtQEus4hAJemJQJdzReKk8yUeY467hQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KvNkZeaS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GnP+jHL4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KvNkZeaS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GnP+jHL4"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42L23xhV013563;
	Thu, 21 Mar 2024 10:46:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : content-type : content-transfer-encoding :
 mime-version; s=corp-2023-11-20;
 bh=Epn80FpJS2jh1aXNFHYDnvgtlb4rLSW6hg6QDsC/5iw=;
 b=KvNkZeaSd3glHcTQOytj2lc6R1Fwx2w81u8eXFOVouY86od0rj6iAEvbSo+4VyQ7b2OK
 fADjXW33B2V0bUuvIgatonTpTdqaqTiDNrCHxR5PaqGZmYbIMcYMQh9XGQ7F02hJOCB7
 oAn092QhHbEBSYr+4uzdmS5AF70c86/WCAC2fGMu/v8pi+EOkYZsAi44ZfD0URH53fhO
 U4+o0L4Y8azWQBU2yGOMw8b5MZi79TlvwBbNc481lldBbeyW7WAKHxEYB2i+iJN+Y0xm
 AQ66xSVJrboOpQMCNCho6/nSD5qpintKNx16Fa6f19Ko7yTIHx36Z7l1sxXOWDfCuCMH Zw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ww1udj332-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 10:46:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42L9SII4007510;
	Thu, 21 Mar 2024 10:46:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ww1v9ppr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 10:46:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5U0l6rvqwZnTGAPR9zgcTKJI83W5m9Kfnwqg/AlJapxD+YqcKU8rs6DJoamTCJp9aXH7yda5rHMwl/UDPhS7T4FUrb7moVxKpeNkyu8w3L/7WxjlvN3bWRi8YI9pgPyrZkKlT7+6T+GCD+yY3pbx7qII8hzyFla4Fk0FWt5CKWr3BnQY3B9OD7zq/ZlMDdPJeXUgnj1FaS7PHDClgU2taS2IlZNXcUdsCQ6wdBJ5B5jxlz2UqNvnGxwZnDgEV7fcSqxXuerS58L4OzRF1IV/4gbqexI5t2Clfkd/7aNMC6PAsk3pFCqPGgQVTZYsj8c+Xi0d5unDCz2qvM1MJko0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Epn80FpJS2jh1aXNFHYDnvgtlb4rLSW6hg6QDsC/5iw=;
 b=b9cfFrxQP+wza0i/+nuosGNFjk4StxtCODpBm0fzO07CyCKbSR4o14UtH4K4J9uYoTDhGTqB3lSYtb9biVSZ2Xt4GUfziRJgOmeGeUy2wbVFlI6Hp1mvewa1tPbfxLGPQZEWs/8Zq1fbg6NJdprsOAjvx++G6hagjKsRQefAvzhHriQVvCGmU5YtO766tVN3buOYqV/m5f0Qk9CMEgaNu8ao5mNUrd4CHNF4qc3P7ZUPYD2hNOaGg0KRhI6gvw+ErPzKZ+qNn1JYWlCItcHSXwhBwHo7HRTmOyG+CDiIzOGq0xW8OLjJ2v/D/xZgAkUFxGqC29wWRIB3hIfz189+5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Epn80FpJS2jh1aXNFHYDnvgtlb4rLSW6hg6QDsC/5iw=;
 b=GnP+jHL4HKEP3CH5Q/9SwtvbhzjTE/LQOocMb6mmSxATSzMU1DLSSNfTp63CbPn5ErxbieFO0xU1EHO9olDPotIVNKdlZCCN2mlyHmeRNafA07/u9I+1Tf3Q6/aomk68QhJTGAFeiG1pGH2NlfeIAO2/xuA9oDsoosVybUyZy08=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB5837.namprd10.prod.outlook.com (2603:10b6:303:18d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Thu, 21 Mar
 2024 10:46:14 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7386.030; Thu, 21 Mar 2024
 10:46:14 +0000
Message-ID: <881d7dfc-c11a-4d19-9c2e-4bf8d9f607dd@oracle.com>
Date: Thu, 21 Mar 2024 10:46:11 +0000
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Subject: Storing bdev request_queue limits in xfs_buftarg
Organization: Oracle Corporation
To: david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0100.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB5837:EE_
X-MS-Office365-Filtering-Correlation-Id: 613e2e5b-fe1e-4da2-1743-08dc4994216a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	y/Uh6Mn9tHxmt3jt24BEK3yMlUXg+biLqF1fI1jZNOFQ8vs55chhNfOMKHi+fLB8S0msql9xbM0VtN4GyNAR1OiGxddvbYx7bK3QsdUjBDUIRZRzTHKeq5hmNi1gm9QMkteuCGkeCfthBRpZEwMQOI9xI9/23aYTetivM0KUOp84mwTSmRFPgaeHO9xk+4vcTvKucKn9Jh9lQp+YRwdwNEyvZ2ozJiWOfRqszzcz6USr1XTr8mgEsexA0GoqjXgIC7R05ISi5/K42BnqLzGGuSpV3tPzyooWNPxY4OAEA5Ij2qtUJ/Shz7bDFfZUcwbJtKe+aixEZbtORx+XEhirg+2tPelUd7qb1yWun78lFxyW8esEO2hDew3NJoKqfSZ4QWtrFA76QTaZQ/JS2OMcr+oNVzVhR4Pc4dCXKyWRIZ334qNIgyt0DmmazSVN5lBg8GxGI8ZU0VdtI1cgBUeC/+gj09t+hRbwXNx2lmIYr4WtaFVgSy1iJ9n4zgYblP1hB0ncrmAhzfdpJw+7h3U9NbHwlcEvcSpd5FxWTrVBNRildckYX+KwaA/6MRqxqaEr97DLQutVdhyH+2ZJI59w5OfkcIu7wjwfHUjprkL1xiBlWpA+ePcbWhtJ/2LKQ7Kn
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?b29SenJYU3hTblBJWm5zRDNSZ09OTnlTMkZJRnRJb0xialhKMjBiRXJLV0U2?=
 =?utf-8?B?Wm16NEk5dWd2N1hkejN6WWsxMnVzTHFqWTRiUGI2TnhpUWN6RjBsbzlhOG0y?=
 =?utf-8?B?dnUvN1gwb2xZd1RRZi8vUGl2ZTlrQ3VhdmNlUCt1STRnMTh2RnJLeERnZUlS?=
 =?utf-8?B?NEFHM3U4cyt5T2doNFU2RjFVd1NNNmE2RHQ5N0dkaVlqaDdRMS9Fcm1sNXpX?=
 =?utf-8?B?aUlqTVg5MTVOR2tKV0Q4bjFNYTdoQURncjJHR2QwaWZTTDd5OEgzOEUzT05s?=
 =?utf-8?B?VVl1eGZHcVhUUUJVblBDWkU3VFJ2K3hYOXZ5RjE0c0YzeDFxMURid21xVGF4?=
 =?utf-8?B?bUF1dGxzOWVBVnJGNXl0OGNYNm9NNGtvT0l5WjB4VytwWklPdkRjandTUmpP?=
 =?utf-8?B?eXl3RHR3ell3UEV2aTM4eWdydEU0VUoxUWJoSVhoQWp4dk9OdmN1U2kxWUlS?=
 =?utf-8?B?R21aYW9pSXZQYnN6NGpsQ3YyYS9tUXpxVzRsZi96K0dHVVdMblRRaGpGR2Yy?=
 =?utf-8?B?cXpIOFlZVVZHVGp4V0lITk1uY0swckEwbjFYZUR5NFd4d25EbVFDNE44bWtu?=
 =?utf-8?B?WHBGSkVsYWdEWnRhMGxreFQyTjVhbDFyRXRhRHYwbWJnYjhIS2lRVVJ0WjZ0?=
 =?utf-8?B?WXRjUjNZRTdaTTduOUErTzFzY243NGFYb3dMRVd4RVdaSEg4S2NyQTIrSE1p?=
 =?utf-8?B?bktBOEtYUWkxMzBJdDhQSnl3cHFoT2dtSmFkTzJSTUthS0dqK3dieHhqNEpJ?=
 =?utf-8?B?VzhGSG5KSWoyMXFIU2pmQk0rdHNOc29CcE1Ra3BIMHJIamVEekpaVDdKTjZM?=
 =?utf-8?B?N3d1SDZ5N21GUFB5cVc3R0RNUWpCM2tKSm5UZ0tLaVk3SlVPaWFoUVFxQVE1?=
 =?utf-8?B?NlhvNWFKbDByQnhQeTVka0huMFB5ajlabGt0R0lKaHdrNjJqRXQrSFpyeGxs?=
 =?utf-8?B?MFp0VHVMaVRvTU54ZGlpRFpVdkNockcvYmUwSC9MZ0RaSDlYYm0wODRjcG9v?=
 =?utf-8?B?UWJjaG43WHl2VlBLd09MZGxUVk95aGhXMmJ1Y3RuUWN1b0kyRSt1ajFsRWhO?=
 =?utf-8?B?T0huZEJZUS9XOHA3NUtGeTdqeld3MXZIZk93RWZMYnNWYUlwbEk5ZFFzOUxT?=
 =?utf-8?B?aUxHMW1zc0g2TGRRQXFYNnJsQVA5aDZtM3ljM2Y4dndycTFTWHV2Wm9FUTZr?=
 =?utf-8?B?M3N5aklrMDRhdlcxMG5HK3Qrd2JWc1Jmd3dBczNRWEtPOEdXTGtBV0psVVhQ?=
 =?utf-8?B?N0FvTGg5S1N5MmNJWndvejhXcUJJZkVhNDRvN2YxSVJ2SXFwWVV2Mkh2NUdk?=
 =?utf-8?B?RU1TbEFna0JoT2x4cW1pTTFWYjJwWDRLcmNDUDRqTVBxWDNyYWZ3dkhxakJn?=
 =?utf-8?B?RDRjclZWQ2lsRmFNTGYzekh5UnNZNlY5M2hySkhDVzJqbnlJa2xWTnc4bExM?=
 =?utf-8?B?VzhKR3RNVzV0MG1GNml2R2loOEJMT3pVcUg2MDRUMDJONjlCVUxiMnBEenlj?=
 =?utf-8?B?VEFtZ1BZZElTZkpSZjU1V3AyRFdHUE9BeEg5NTJ1Vzgxem9VZ3lMeXEyM3hU?=
 =?utf-8?B?YW9rRWV0ZU82eFpBdnZvMGFaZ0RYN0MyaGNjOEdsR1EwSVIvNmpMdzBDM3R3?=
 =?utf-8?B?R011Nm9LVS9sL0ZxaUd0NTNUeWhRZGs3NXN4MkpJQU1yaEZuaU5jMENSVzV5?=
 =?utf-8?B?MUtqRTNTMyswTGQvZjB3OEtEMS95SVRwU2JjdjZzN01rMS9Tb0lLS0VKWjR0?=
 =?utf-8?B?RjU4eU93SzlSZmJIV1VUSzBmdUc0bW5QR1R6eE4razd2VWRZRUFlT0xleUh5?=
 =?utf-8?B?SXN1ckZoYXJObDIvbU93VHY1WVlmV01GSTJOTlJRUzdzTWJwVFpqaVVlVUFF?=
 =?utf-8?B?UEg3aEl5UnJYSjQybGJqQ2FtWlZBTTJvZDdLcllWRXIxTkJCQUFaV2VyMno2?=
 =?utf-8?B?YllRSjVWd2kxYk84RGdKVnYvVmcvREVKUGNtUVgrcFlYNkE2TlJCT0s4empD?=
 =?utf-8?B?cTVoemttZUJreFBZbHh2UXlzNnVzdmxBSVJ2Z1N6cW5kUXhkRUoycXdLVlJQ?=
 =?utf-8?B?SUx4aTRXYjFiemIzQ0tyWjlhNnEzdFRwSXV5aWJuN3l1NGZhK2prdGs3c01r?=
 =?utf-8?Q?KFNKdoExKDuo2H3Gi3r/cLMx8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	pnpX5bl7be0iMOYv568ALzPCBmGqCB8ouVBoBXrd0fHKT30k1teW3VsA6J3r0NkDmYJp0IccY3LlhWZ1orE/dCQGRAuyC/AQ2vgLDG+hTJmVmEmEtwrAgZDroBnpnl58iO90TNY5bK1v2QHimhuZnEWyhrkgV7P2ftNyI6VZV6kQedIn0fXvPnBEawM/4a/1DEWYVJpedgiM1jLbVThntRvAPIPbH53D5GeS8NKgWFkav0NlpVmPqhsczCChjupf+oByRDM+vNs9EMnW0osvWo8gxarphNcZ2vp6FS+D6CuzRVrghuEw0AdslUHNWztbX3sVHfhjXGfldWi90Ne1NNiF9zXkG7vTH2Cbc5q19ODYFc43uiaKErM8ExsLvm62mGc9uRe8g1DTkZqyulPFXdwJTrfA8tc8WFt7Gea43Hc7Snt/H14I1pwOeGfmNInOl9tWHZDFTr/HitkYekxZ8FvgRThQ+gGD5dKrsbEDSerxd0bUTSOvVJdSPwyCtvuzUZ3KqzsSIxQYv0bdo8wSDN8cBgKEYVWdY4184I+5Y3iAVx29p3mPQi35fzPNITa8ZrwHr67KQIqbS+1OJmaO8x/s0lmy0AjKAMLz42XnR7Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 613e2e5b-fe1e-4da2-1743-08dc4994216a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 10:46:14.6530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHEwR8udMeJ60XvT5T8NsZnxwR5dv3Ah/SQJUgeu8JiKKIQtSLpxvhUxHMBm/+yJ/WxcV6QqoWL1jX0WdvBekQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5837
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-21_07,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403210075
X-Proofpoint-GUID: qjhri6tDERhnE3CGH_5Fib3QZBK5WRaO
X-Proofpoint-ORIG-GUID: qjhri6tDERhnE3CGH_5Fib3QZBK5WRaO

This is a question regarding the atomic writes work, and whether it is 
proper to store atomic write-related bdev request_queue limits in 
xfs_buftarg, as already discussed in 
https://lore.kernel.org/linux-xfs/6430d813-cb30-4a66-94e1-ea89bdc921da@oracle.com/ 
(and also in the v2 series).

I can't get a conclusion, so I am sending a separate mail.

A suggestion is to store atomic_write_unit_{min, max} in xfs_buftarg, 
like we do for bdev logical block size. But the concern is "geometry of
the device can change underneath", see 
https://lore.kernel.org/linux-xfs/20231003161029.GG21298@frogsfrogsfrogs/#t 
(so do not do it).

We only need those limits in XFS for statx reporting of 
atomic_write_unit_{min, max}, as in that series the block layer will 
reject out-of-limit atomic writes.

If those limits did change after mount, then the worst that happens is 
that we report incorrect atomic_write_unit_{min, max} values and the 
user may have IOs rejected unexpectedly.

I assume that we would not normally consider adding other bdev 
request_queue limits to xfs_buftarg, and we rely on the block layer to 
handle all sizes of BIOs submitted.

Please advise.

John
