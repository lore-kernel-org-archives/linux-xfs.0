Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FE113C696
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 16:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711469330; cv=fail; b=nB012elRWruXdyIpCNa2k9iPvMufCFn+fHC5ZCBjPTNuRas5lP3rHEdrreARPFOIP4CwQ29pul363fJ5SFs1Vwudjh7D1FLGNbjxw0qGIDPKgEcgfbtDXPMWM5rz0kiKI08aQIBifCGw6R91L9UoyKqWUR9RdFXSMBs6Z3gm7DA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711469330; c=relaxed/simple;
	bh=VSyKd5+lLVliQG1K/GvQpCM59fYOJyFLD/8ToufZ/g4=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L6yjDjhfM8NKAq6UF3V9ReF9vlFzpCZ48FiuZYFlxCZoW+wG8AEV0ZTZB8u/jnqjvEIbv3j8fXCjbGkpNYTSRgdEg0PJEG3KrpnMrCiOVRkIxN6dwCXmETVlAx7e9LE+4qi/wDxZqSKOPMQEEPpM2YrQ6tKJD5MDkhRAqiw3KsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bmvtFA4u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=olqPx73U; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bmvtFA4u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="olqPx73U"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QF43rl026371;
	Tue, 26 Mar 2024 16:08:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=mMu8jccACNqdQOCcYjntb1PdoWCbLJmLHtIQhwM33xc=;
 b=bmvtFA4u91qLrBXuCgBlEpNLDOvkDEbTn2AWpRkpJz1NODp17p8dF9n6LLbPLyK9Kyza
 oCc1eDqAaxtYm2y8A1ljXKLXajS+Hy3fUrjRZp5V333gHip+RmF7j+SBMlj+q0SoyoGT
 dvaKcd8+L03wUcGfj1aWJgCLgtxQrOuBHPasePdPiFfIMVr6PB2Runmo90Y0ZLbA+Nme
 cK+t2dzdkLLhJqeBSM4+u9vqF1zOTeQhNo9PF2NqQH3o4tFh+EegEOjZqks1uj6d0gzY
 VUh8FV7f8uL1y2TxzyqMc/ED+pywCv0O2Px5k8gnB2v8JKv4v+gtb9hPyXTzIXJVRK4F YQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1nv45et9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 16:08:39 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QFDiGq017583;
	Tue, 26 Mar 2024 16:08:38 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh7f6j5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 16:08:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elJFKJPjWyW4i0Ik1EP++qaB/8EpU/IHhQptNlZjGvW7XHwAVA2lnj9vExfwt1K87YOPj3YH2oV7p600ltzpt/iKuRtdFk2mZaRVkzTXGjsKuVq8Zw/Vfz3JLH2/eglAh4QXeNl6J3VxQynK54jEnSIvaCvma4vfWWsucr9d/2Ioabhxx6fLfdNDWjyjFPVRlrKQCgSv9O+97O34qvlsGnANfOSZTcNuEoqWLDtmAPf/APhjd2Bld5swKa9O6ylT++TOwPZ8b8OVYvfB7g7Ke+m6bJTIaEtRmCvJHac8bjeEEg4pkTMDhuJxqbiBFXBvIw/0ZnRYq7AC96tYWCuJEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMu8jccACNqdQOCcYjntb1PdoWCbLJmLHtIQhwM33xc=;
 b=Mq6uZsfZ8RbGePlFQkjKfSzBhWD1PV4JoKx4tQndaxFq/4hE8ChsnUPDC3koFRTs2lrNAY7jvAnVxFfbxs8uU2Wc+h9vCANKkkp2Rj6rYkP4byNNQSgwhBuY0ePuQWEY68HeAroRi3kjkSc++QZEO7roOdBvnwnQe8r+w+KhvIvu/B2am95iDezpZx8rOrNlDW3pYSzaIqcCzHGTs5M8TAU5MLBywYpNIvKWGO1kW3HsjNxynMtLlj9rZktJJJ9DAmMPUGkcOLFal8vopCFRAHEdJIyw06G+Ls9zJ+S9SP8b24hun1JT89dTOp//ijR4Fye7LptmJ9pgAf0eR2YLjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMu8jccACNqdQOCcYjntb1PdoWCbLJmLHtIQhwM33xc=;
 b=olqPx73UtrJx+ggQTtrTfir8QvguuJKtKoS4iDYjxo0ufqOgp2kkb8GlNYwhF/bso0Z2aeS28uq7LiJ/8Zhk8q3v0wDCXI6M8IJOnFSr467FL6KSOKb7eiOAIrx4euXXGcxwanWlK8JkuI8RHx1kZvH8OQfA+aKh9He4EjjECS4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB6586.namprd10.prod.outlook.com (2603:10b6:930:59::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 16:08:08 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 16:08:07 +0000
Message-ID: <9cc5d4da-c1cd-41d3-95d9-0373990c2007@oracle.com>
Date: Tue, 26 Mar 2024 16:08:04 +0000
User-Agent: Mozilla Thunderbird
From: John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 1/3] xfs: simplify extent allocation alignment
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
 <20240306053048.1656747-2-david@fromorbit.com>
 <9f511c42-c269-4a19-b1a5-21fe904bcdfb@oracle.com>
 <ZfpnfXBU9a6RkR50@dread.disaster.area>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <ZfpnfXBU9a6RkR50@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P192CA0026.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB6586:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	1fhF+efJNAlw//moBt1ASBQvNnZBqQUFZuT73r3FK0gnZwDGxP+RH09U2R5eQJXvekzvfGVC9mgarYMfk1drCJCwOu6MXASwnJwaqRr8xTdHLq4IFs11jn6a9p2uCtvwQtxPExO/mMYk9/rBEdNZvAOsr0cIkU3jCvUFunRLBLZ//X5XKW1+BbpSM5ycEs5+ul7IaMU5zn7RmkNc7hAquD0NXBCO3mKG26Jy8vHmmfHKXD2Kjqe+uEicWhhKUYMqbYk9xjUYo1CiZvoL0ysMR/U7rQn9Lb0Q7ec+23Z8OO8z+ltGzlAVkX1taBafxuZ18sxTfVQSxGAG9mUrXDptX7Z4dhH8fkxPg49RKO8Nuwtikf1R0TAgN4W8WP1vJziC2S8Dd3+f2Ttar3Q96yJdKkYgzjfK3BSAwHOTGlZioIfG7akPAF3QAQD3euVWBARW8Zw62aqH4rJOmX+ofyRCfJRxDymGRNqhrKV3ParnLW3jksOgtyM5UeJz9EVnBuO7KYfgV54AbDm+XoCK2zXDCOBo3n8j5scjwVmOfR5VTPhEVhPNuRzOwldfm3P9fZRMR9q781IyyfF+VEo82QkekoQ4ccZhQ/G4a6YGNYSxIQJJfbXcz7hyK5Bt3wUETp9NqVwqgWCdxru5qpvvKwe+a+37EfkQr/7hPSMrLD/ThKo=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TmI1NUo3bGdvTnBYbHV3M0hmeDBZWHJLMHkxbmNjeW4rNFZWaFdTTm1hWml2?=
 =?utf-8?B?dXhxRFFCTnlPTDJpYktIYW1DWUlieTBvcHRBL0Jyay81RW85dE9QTnBuVyt4?=
 =?utf-8?B?SWRuU0FsVEZuQW5DTTZXUFIvM0JZcldkSEUxdFhtMEcvS3hLZnJ2NWZWQjVQ?=
 =?utf-8?B?OTVaUzZMVGFLWTBzOThOQmw4bjMyRCtJT0JhUnlJWWhad3VNY1lPZ2RIdUFn?=
 =?utf-8?B?UEVPbHVQUHcvbmhpYkNzaWpBSTlpcGZQQWdQWlZuR0tuK09QdkgvcVQ4VjBt?=
 =?utf-8?B?MjF0dzY1eWJoTTlZaERtb05NYkc4L2dIQkVnNWhqVWZvVkl1cWxMS3F5NlZU?=
 =?utf-8?B?YnY3bHppZVZjNGhWOXc2VGR1TDc1SGlkcEt0WFFaMHRsM2o4NVJHa2hrMjUr?=
 =?utf-8?B?MTRMSU01Nk9VVVZ0VkJOOXdDVHpmSEdETFRKM2lYZjdGb2ZQUkVWWG9vNVY3?=
 =?utf-8?B?cXBvdDhqSFpMM1JTcmF5Ri9oOWlmeGMzcVBxb1B1NzRPVWxLdGZTUjM4Uzdi?=
 =?utf-8?B?S0N3a2tLNk5zTnhhVUFQNTJIRkhIQmxQZ0xaMzF6ZnhFb1czNWxpVjcrMnov?=
 =?utf-8?B?RlkvMzhTdkJqbHA3ejAwNTF4UGFqemJiWkU1cW1kaGpncVZFLy9CamFOK0RD?=
 =?utf-8?B?Ly9iM08yK2gxTVdlN2RLSXp5UXM1d3FEQVNNRWM3VEs3Y0lDOWY4ZGIySWNy?=
 =?utf-8?B?aGsrK1gwdC85cllLN3Z1T0JJS3hkTDdEb1RzT1duakx6cnVMWUpoaWFQWnRh?=
 =?utf-8?B?N3lGZmVJZnRJVGQyT2IwRjllYlBmdkNhYXV0dEExcGhKVjRlSEpTVjVKUXpk?=
 =?utf-8?B?MURhRHg4T0JhS0V3WVNXY1ZXdjVtVWRXY0tINTJsQkR2MjdqTWlIakQ3b1hu?=
 =?utf-8?B?dGZHY3Q1QTBLWE5OYUtVR01sREE0dFpyL1lyWWtsSnJ3Um1yS1ZvNDkxTjhF?=
 =?utf-8?B?bE1WZUwwSjF4Y1BUZUYrWmc1SjhFMVV0OXVhQURlUzJ2Y1J1WXdzejZ4MG5H?=
 =?utf-8?B?UFFHZFNxbTUvN0hENjZGR0FrTDRBbnU4bU1WSkN5OHlmL3o5L3JZMnFXUWJq?=
 =?utf-8?B?RVZsZm9tUndyV2sxVlRHYnZxTElKTXljU09jdzdhUFJ2c1VOUEhFYXlDSE53?=
 =?utf-8?B?eGV4N0dNbVNpY0tCSWhLOXRzeXczNEQySy9BV1ZGblhZb2tXUWFUSldmbXBo?=
 =?utf-8?B?VDZEVzd6ZU16R3RTbUlydkFwSUlvTlRkbmVPdy9CSWpsZkExUy95ZE8xWUhP?=
 =?utf-8?B?Y053bVpEZTJsYnZsOU9jUHl2MTRneHdFR3hvNkYzRy8wRTlMQXdDRHFpSWlY?=
 =?utf-8?B?V283cStYRXFmanFNNjhueHZWYnZmN0g4eXpCMGwvRFNKd1hTTWRlN25mNXUz?=
 =?utf-8?B?QjhhNFVaWW8wSDFNUmk4KzBJbS9nUGY5cVkrK1htYWVJWEhHbFBVa0dyOTlK?=
 =?utf-8?B?bnhWWVpsOElRNWlldTZVRlNyZnlGems1R0g0VXp6S1FLZ2NsQkpxT2VEVXVu?=
 =?utf-8?B?Sm8wcVdKd1kya0dZSHF4ZnJKNU5QUjNPZ3hVbXNKa2RobzF5TWdxbmdPb0Iw?=
 =?utf-8?B?WFdOUGhFUGZwYUFPRHMyNWNsbURabXFHcjFhMWxLZk5vT3ZvY2d1QksvaEFt?=
 =?utf-8?B?cUg2c29CUytEWG5oU1NyeWdyQjRZN0I1bzZWejRPTUFDNlpTWmdwNjJjNFVv?=
 =?utf-8?B?VlBvaS9ZOEZPdG1aMk1TQXU3WU84QTUyTWFPNnhUNWNvK2dpSWFoSi83d0VW?=
 =?utf-8?B?Y3ZPRnhRbkZPaDFWSkdnZnltaUE0MFlPcUlSbGhWOGlwVlBmcnpJOWVrTGFp?=
 =?utf-8?B?RlYrTy9oeXZjS0hVckNzS2wwUkVZN0ViR1dVUDRHS20vQlE5cjl5UFNiMTRP?=
 =?utf-8?B?Ui81RU1UUlNHcEdwN3pvUXdoSnliU3VTeVFYc01lOTh1OCtueDVMcUhQVlVU?=
 =?utf-8?B?ZFdzeE9ud1VOanFOTHdFM0V0dFVrKzdwN054Y0VKSm9COUZTYXdsUVU4UUdC?=
 =?utf-8?B?cVNkbURpeEFYb0pHRjdCN3pnd1NZQ3F0cjU2eURTQ1JFNUhpRWR2WVBhVXhQ?=
 =?utf-8?B?VU1jQ0J2RkFrai9nOFdIK0NGaEozc3AyZ0g0U2VRTWFOYUxFL3FmSTVpUklF?=
 =?utf-8?B?NnZjNzRaMnNsWUIreG9nS1MxUE1HeTNsRzB0SUNoRjA5Y2JmK1FucmJ0clJj?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	oQQAznMfvmmc8syikPwAsVWPRiaXBB1Ga7yXMvsCRUUc3D+SVnF1W9lRYj77FPPP0bb/JIMyuTM9I6i4lGB7GYoKJQfpcFhXnZIfVPjuR/SRFtxe22oOEFc/T0QboepDpdyToDjX+3q3KBV3a/2Gre6EqmmoOkMwzXKSi1EP35N0dnt5V6mCamli4c35xLwL+K7YDM5kK+SN+1JiymHd0xYYK+NWVCmsFbHWLO5vlLZThlGflWMq2JxiqHBvFUAfjKHobbzND/3qRoKxmhN6qrd/Q72mr/JGMJNLxo8ELsGlLF5yT1aL/DTqWVTb2FZ8XaXHSboy0hpL9CQLEeCIRYqMPErUNQ0+fcYHL/CxmtjZJSyKs/W8SsLxAB5AKdfHOxXhYoPzOSjATgizjQeiogLsG3EqTEpgcjIy6joTSHMlx047LWaDgZBznOdlXIOqsTNa3k2mUaca5WH2p1pYHMbECoWqN2Xn4SBGxGMUccZgy1Xx/ZXffgWKDJO4Iu7YePZ2oxxmBQAlU1lZdkNMPbxWxX8HncRD8dKI+SrU4Zg4aLwgPpUN1h/qKzPsAz+SsxUOCT1taYsB4SXWl+fA/Ip2f41mcjKe2o8qPhNx3Hk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ab45c3-da84-442c-edcb-08dc4daeed12
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 16:08:07.8810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 138spLyVJFZB2hCXIkeYstVJnuCy7TxoB+wrGngGKmrgdefCFzFKzMdF55yegDrldVXPDl0QyBmTlH0QOcrlcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260114
X-Proofpoint-ORIG-GUID: VlYRprqAPGRnZgmwinO_JDTVuIWbuVfy
X-Proofpoint-GUID: VlYRprqAPGRnZgmwinO_JDTVuIWbuVfy

On 20/03/2024 04:35, Dave Chinner wrote:

For some reason I never received this mail. I just noticed it on 
lore.kernel.org today by chance.

> On Wed, Mar 13, 2024 at 11:03:18AM +0000, John Garry wrote:
>> On 06/03/2024 05:20, Dave Chinner wrote:
>>>    		return false;
>>> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
>>> index 0b956f8b9d5a..aa2c103d98f0 100644
>>> --- a/fs/xfs/libxfs/xfs_alloc.h
>>> +++ b/fs/xfs/libxfs/xfs_alloc.h
>>> @@ -46,7 +46,7 @@ typedef struct xfs_alloc_arg {
>>>    	xfs_extlen_t	minleft;	/* min blocks must be left after us */
>>>    	xfs_extlen_t	total;		/* total blocks needed in xaction */
>>>    	xfs_extlen_t	alignment;	/* align answer to multiple of this */
>>> -	xfs_extlen_t	minalignslop;	/* slop for minlen+alignment calcs */
>>> +	xfs_extlen_t	alignslop;	/* slop for alignment calcs */
>>>    	xfs_agblock_t	min_agbno;	/* set an agbno range for NEAR allocs */
>>>    	xfs_agblock_t	max_agbno;	/* ... */
>>>    	xfs_extlen_t	len;		/* output: actual size of extent */
>>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>>> index 656c95a22f2e..d56c82c07505 100644
>>> --- a/fs/xfs/libxfs/xfs_bmap.c
>>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>>> @@ -3295,6 +3295,10 @@ xfs_bmap_select_minlen(
>>>    	xfs_extlen_t		blen)
>>
>> Hi Dave,
>>
>>>    {
>>> +	/* Adjust best length for extent start alignment. */
>>> +	if (blen > args->alignment)
>>> +		blen -= args->alignment;
>>> +
>>
>> This change seems to be causing or exposing some issue, in that I find that
>> I am being allocated an extent which is aligned to but not a multiple of
>> args->alignment.
> 
> Entirely possible the logic isn't correct ;)

Out of curiosity, how do you guys normally test all this sort of logic?

I found this issue with the small program which I wrote to generate 
traffic. I could not find anything similar.

> 
> IIRC, I added this because I thought that blen ends up influencing
> args->maxlen and nothing else. The alignment isn't taken out of
> "blen", it's supposed to be added to args->maxlen.
> 
>> For my test, I have forcealign=16KB and initially I write 1756 * 4096 =
>> 7192576B to the file, so I have this:
>>
>>   EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>>     0: [0..14079]:      42432..56511      0 (42432..56511)   14080
>>
>> That is 1760 FSBs for extent #0.
>>
>> Then I write 340992B from offset 7195648, and I find this:
>>   EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>>     0: [0..14079]:      42432..56511      0 (42432..56511)   14080
>>     1: [14080..14711]:  177344..177975    0 (177344..177975)   632
>>     2: [14712..14719]:  350720..350727    1 (171520..171527)     8
>>
>> extent #1 is 79 FSBs, which is not a multiple of 16KB.
> 
>> In this case, in xfs_bmap_select_minlen() I find initially blen=80
> 
> Ah, so you've hit the corner case of the largest free space being
> exactly 80 in length and args->maxlen = 80.
> 
>> args->alignment=4, ->minlen=0, ->maxlen=80. Subsequently blen is reduced to
>> 76 and args->minlen is set to 76, and then xfs_bmap_btalloc_best_length() ->
>> xfs_alloc_vextent_start_ag() happens to find an extent of length 79.
> 
> So there's nothing wrong here. We've asked for any extent that
> is between 76 and 80 blocks in length to be allocated, and we found
> one that is 79 blocks in length.

Sure

> 
> Finding a 79 block extent instead of an 80 block extent like blen
> indicated means that there was either:
> 
> - a block moved to the AGFL from that 80 block free extent prior to
>    doing the free extent search.
> - a block was busy and so was trimmed out via
>    xfs_alloc_compute_aligned()
> - the front edge wasn't aligned so it took a block off the front of
>    the free space to align it. It's this condition that code I added
>    above takes into account - an exact match on size does not imply
>    that aligned allocation of exactly that size can be done.
> 
> Given the front edge is aligned, I'd say it was the latter that
> occurred. The question is this: why wasn't the tail edge aligned
> down to make the extent length 76 blocks?
> 
>> Removing the specific change to modify blen seems to make things ok again.
> 
> Right, because now the allocation ends up being set up with
> args->minlen = args->maxlen = 80 and the allocation is unable to
> align the extent and meet the args->minlen requirement from that
> same unaligned 80 block free space. Hence that allocation fails and
> we fall back to a different allocation strategy that searches other
> AGs for a matching aligned allocation.

ok

> 
> IOWs, removing the 'blen -= args->alignment' code simply kicks the
> problem down the road until all AGs run out of 80 block contiguous
> extents.

right

> 
> This really smells like a tail alignment bug, not a problem with the
> allocation setup. Returning an extent that is 76 blocks in length
> fulfils the 4 block alignment requirement, so why did tail alignment
> fail?
> 
>> I will also note something strange which could be the issue, that being that
>> xfs_alloc_fix_len() does not fix this up - I thought that was its job.
> 
> Yes, it should fix this up.

As below, xfs_alloc_fix_len() does nothing (useful).

> 
>> Firstly, in this same scenario, in xfs_alloc_space_available() we calculate
>> alloc_len = args->minlen + (args->alignment - 1) + args->alignslop = 76 + (4
>> - 1) + 0 = 79, and then args->maxlen = 79.
> 
> That seems OK, we're doing aligned allocation and this is an ENOSPC
> corner case so the aligned allocation should get rounded down in
> xfs_alloc_fix_len() or rejected.
> 
> One thought I just had is that the args->maxlen adjustment shouldn't
> be to "available space" - it should probably be set to args->minlen
> because that's the aligned 'alloc_len' we checked available space
> against. That would fix this, because then we'd have args->minlen =
> args->maxlen = 76.
> 
> However, that only addresses this specific case, not the general
> case of xfs_alloc_fix_len() failing to tail align the allocated
> extent.
> 
>> Then xfs_alloc_fix_len() allows
>> this as args->len == args->maxlen (=79), even though args->prod, mod = 4, 0.
> 
> Yeah, that smells wrong.

Would it be worth adding a debug assert for prod and mod being honoured 
from the allocator? xfs_alloc_fix_len() does have an assert later on and 
it does not help here.

> 
> I'd suggest that we've never noticed this until now because we
> have never guaranteed extent alignment. Hence the occasional
> short/unaligned extent being allocated in dark ENOSPC corners was
> never an issue for anyone.
> 
> However, introducing a new alignment guarantee turns these sorts of
> latent non-issues into bugs that need to be fixed. i.e. This is
> exactly the sort of rare corner case behaviour I expected to be
> flushed out by guaranteeing and then extensively testing allocation
> alignments.
> 
> If you drop the rlen == args->maxlen check from
> xfs_alloc_space_available(),

I assume that you mean xfs_alloc_fix_len()

> the problem should go away and the
> extent gets trimmed to 76 blocks.

..if so, then, yes, it does. We end up with this:

    0: [0..14079]:      42432..56511      0 (42432..56511)   14080
    1: [14080..14687]:  177344..177951    0 (177344..177951)   608
    2: [14688..14719]:  350720..350751    1 (171520..171551)    32

> This shouldn't affect anything
> else because maxlen allocations should already be properly aligned -
> it's only when something like ENOSPC causes args->maxlen to be
> modified to an unaligned value that this issue arises.
> 
> In the end, I suspect we'll want to make both changes....
> 
>> To me, that (args->alignment - 1) component in calculating alloc_len is odd.
>> I assume it is done as default args->alignment == 1.
> 
> No, it's done because guaranteeing aligned allocation requires
> selecting an aligned region from an unaligned free space. i.e.  when
> alignment is 4, then we can need up to 3 additional blocks to
> guarantee front alignment for a given length extent.
> i.e. we have to over-allocate to guarantee we can trim up
> to alignment at the front edge and still guarantee that the extent
> is as long as required by args->minlen/maxlen.
> 

ok, understood.

Thanks,
John

