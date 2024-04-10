Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEC712EBEF
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 12:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712753097; cv=fail; b=f24ml9o2+0Valzx4STFDVFVee0BJsGhvkQjb4qfnftAS9P/iOQfYKyJDebKKNx1tSVOBQqgavmpphQ+f4XogSKU3Tj6dM66hq791fxUDGO+rLrQr6lzWjw+AT70S2lalzYyxhB6FhVvYJ4uFnRQ90iBRjlucDEVF0ZcZqjQTwHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712753097; c=relaxed/simple;
	bh=oNWpyZx0kveFMRO4T0mUEJBPvhQmNEW/cFJvi9HmyEs=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Skilwl1MLS1WhhXtmPLrdgji0uqxZI1wGRrBMofT3PEMTUjl9W4pxSHU92E342Wll5pNWceHb+jQc/sqZcIvg+olGn+u65if6hYKzYj/OOqgLmIgqTzArxJwyQiAWgoBfuQRmjsUamNKzCJgfD+gs21OsmxPUSrhi09Tb4T9Zxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jpx0L/oe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D/Z+/BLv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jpx0L/oe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D/Z+/BLv"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43ACVMRr018399;
	Wed, 10 Apr 2024 12:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=1XT3QJYLRTqC/H3eSNepkP/K47r8OH6ozDDzOgPojas=;
 b=jpx0L/oeqe27PF/lBc6HTL69X4QCpgiblXEJtDBUzmZ3bxP+QdTTQyqL2afcyNZN5ecF
 hm8hNxI2rdQEHDONAWSKHFyEL3RDFo6R9thu2Tvr6Uequ4DHOk5itOnVF1bt/so+2odk
 4RctN/E8OMhOE6jqQxCAlXFPcNub1PmEU3V+587rqSlJRI1TCT55bA7rfqaSSCuDhakW
 e6MyFsgvV5/+OzVGhBQ7Yudrde+JRVKTxlfwLnJssH27OYWQTun9Hp1JOlkUdr5/NaQQ
 2yy/9nlT00+iCiOvVp7AVNepxssqhm0xIXNJlz7W+oE6Kls4WZstJARN4V3wlliFddcf Hg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xavtf759k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 12:44:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43ABwS3q010623;
	Wed, 10 Apr 2024 12:44:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu82p64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 12:44:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKQFtcErbcwUfHR5jCZ/VXYyx5t7ZuiMTpI/iYCJw3JZ1CQT1UVbsqqU8W6CxSmQOwXpB8zv05gH8xWKzpjlSE6UEjjIs0BXg0D0YYSlNaYjdy1XiXvn16xORxWypafkKnXSDYpnxSTy4C1n2loHUzcOjNLioDATwIK7X7FVxez9lGofXJog5wU+NZfGoA/G+T4q92nQsAGu6lNCPUaBIlqV2L7dRix9yKctekQZL04DTDo7heLOKLWa7NGzeAEv5IUbgJ/mSG60I4M5G4PSu/aM5mJUYBkMS0LhDTRXRo6UGYhSAYZrV8xJRIadzRj7ftx7bbcHw6qhqXGJQzqSCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XT3QJYLRTqC/H3eSNepkP/K47r8OH6ozDDzOgPojas=;
 b=HPZIIPDDLCVOsCUI82gmNTGSZEnIASXho5mYAmvvXT4+Cr8P4DB3yKZ3UW/wsK7QahzuahfT7YDUjgg/cvbq25aZfwQM1mZfZN6LynQIUBBA8hRsZhZ5DwLnEBjriB6WK2f/gsLyYgEmZTfuVBZdmOIgGI7LirmsAQuyERvpmkI+g7GIaePCBX15teoM65Qk+c2HZaYHiXrEFNbWZZFM/5coa3TW1Ay/IfWRJ1aCKGY6o3W+IFJ0e5PfIH+Oc5tFkfNyWhAR3z419yqQVG2qK29K4Qn188dnHIXfNENcGckrDMN4NHsaH++cXKgxztqddyrNzGh66ScoPDXyHA/Itw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XT3QJYLRTqC/H3eSNepkP/K47r8OH6ozDDzOgPojas=;
 b=D/Z+/BLviXmoo+wzq9rhLWQaterO45s7LPs6ktL7YE92tG6Htf6MnV1ctj8buuVPnhI//xyxRQy0L3DqfpKTPNl5xpSMKbh/iimjK8LG8mLSeH4trbWoDGp05HrkNDV24kllPt71kDP39QLt8NfEq0MTUXsQDEAC754RL7sSWpE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN2PR10MB4159.namprd10.prod.outlook.com (2603:10b6:208:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Wed, 10 Apr
 2024 12:44:50 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Wed, 10 Apr 2024
 12:44:50 +0000
Message-ID: <205661cb-6d7a-46e6-96fc-a4ac9480bebf@oracle.com>
Date: Wed, 10 Apr 2024 13:44:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] xfs: allocation alignment for forced alignment
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20240402233006.1210262-1-david@fromorbit.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240402233006.1210262-1-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0564.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN2PR10MB4159:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	UX6FcDx/Am3my8P/MnPy5+CLpXR1pR6MjDgcNDsZGPg+UV6Tvn2+4ChdRIn2scgmGCJX5IBTu4RXOu2aSuA2ybn9r6oeRSZ94ugCedh+yOid3os4qjj77vD//2l9UvIjGjzU6xgWleYEDxKQX6eKVG5kcqmeq+QDS8rLUFmY7qONUcTWbEKS6emQLk/lO9eX8/YTu2ZxmdBdXHBFc1z/7QUPJNqN5cRtD+55Bdw65sk+kghV9a55aLH4Rx5TOzsEnRaunYlDJSGypsmQRJZ3g/GH4kN5G7gniixm1YxcNrAGkyQHxjpBlnulFZA/umsHzbJZy/r65iue5PVUEgoc0rV4pEON/OmkYOY7XkdUQqu/3bd7JV27VDVP1ZliLUj0JCR9R+wSVM9J/a7FwKujMsiQd2VnrqVpNcSfwxuwXB0v+TpNWpknG5DVJIvFyjeYuk0eX9A2yKVbnxkE9hP4U5eBdrzFPnXakg8tRVveMv9VT6itXKBNKb8Tq9hEgIWnJ0qno2hQhgtPsbMNTpa7RLI7Wluz0uMhkLSbyq7hvUW1Mz0uLmvZqMfAZn+tdl25KN5KccNgLQG2Y8GkiIFrHGW5mkMExN2l8fgV5BfqzjIED6vvbMRQjmNmyV23AdYkIG/zVvgL9btxwU3hti5LX2vmADop4+H6tYsVbQx+OnU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Qk9HejMybXQ1blZGVmJ3MW1DdEJyMDZQc0MwdW9RdDNKS2tlSytyTmFVT1hh?=
 =?utf-8?B?UjVkQmRaeEgzS1p3eHgrcUxNNXlnOE1uWlZOamlQR0JnT1hsN3B0Znp1a0lX?=
 =?utf-8?B?WjVvOCtpc21RNmExKzZNSko4L3BTZFlrYTR1QjdHSWZyYkVUS3pTOTZ2cjFi?=
 =?utf-8?B?RkVTS005Q1UxTXpVdmRUQmoxYVdqZ2NLMkhydkVPellmOXMrYlFFL3lNVGdF?=
 =?utf-8?B?QWpLWDdsYWhqekhwRXhIaFVnWjIvMUhHVGQ3V3hxYmUxTmY5d3dpblFNYkN5?=
 =?utf-8?B?Z0VnRWJXQnVuZG5FVEtoa2pFNllyMTNNczIvbjUzQmpsOE5QZUoySzBSM2dI?=
 =?utf-8?B?b21KMnRLRWxCSGNqRWhXQXdIVjU5S0Y0SjFUNSthYjlkbGFtWmRiV3FVdDBo?=
 =?utf-8?B?RWVmMmppQVlFcmwweVFrQUpZZ20wU0JobE1tc1podGNSM2JXSXdtbkRkcEdx?=
 =?utf-8?B?YW5Gbm5SR0tWUzFkZWwxZXFrVzF3bDFRNjhxK3A2V2FOMUkwUG1MemtibFZV?=
 =?utf-8?B?Q2pyNml1WjAvQ05Pa21SWGNtbUx0T0lzVGFFWm9pQWdsaUdtL2s3TXZMa0VP?=
 =?utf-8?B?MmozQWlmOEFudSt6bW15bW9zQXJvVnBJaDNMVUkzcXFrbHozaXpKbVhHaFNU?=
 =?utf-8?B?Zk5mZXEvbHNua29hK0dCczZxcEpveVNRdndDZ25FamhmVDgzUVkvemp4NzlR?=
 =?utf-8?B?NGtZclZmajhBSkg2V05HMTVOZDFSZ3pScTZ1UjRoajE2d0ZQTnFZd05PdUkv?=
 =?utf-8?B?c0hONXpqa0RDQnVFdkIxa3l5bWVZQlh0SkFnZTBBN3lvMGE1MjR1NW4rRDAy?=
 =?utf-8?B?czJWa2twc2h2dituREpZNlI1MlczQ2NqUXladnJ6OU1ydnNNbGVkSnhUUDZB?=
 =?utf-8?B?b0o1eUxKQlVNaTFodldaWjdET05lQm9kMFhDSENBNVJLc0U4Z1lNekgrTWNB?=
 =?utf-8?B?djZSR3Y0aUVvbVYxYll4dGYwUjZFUmRuZVFGSG04SEhZWGRKVVVpY29rVUNm?=
 =?utf-8?B?YWZmZjNJbm8wUHNGM053cGpQU1hmQjAwVkkxd2ZiQitTNjhlb3JrN0R4ZHRD?=
 =?utf-8?B?VTFjc1pTUEFveUJmZW1tb3NmRjNVQWp3d1BYNnJWSGJibFBwdU9ia3ZUbzY3?=
 =?utf-8?B?dXhJcFUyMVZWeU1ta3hLZmRHeFZJKzdNQWt5ckFiYW10d04zbnBLdVN4NkNW?=
 =?utf-8?B?TTVxcEpKUVAzTkV1dExUYXQ1b1BhaWVQU2tRckdaaGVlZVo0NTJnQUU1Y0ZW?=
 =?utf-8?B?MDJhTW9mYVovWnRLeC9sSnB6c2c2WUxoenJmVkdGZnQxMUpEYjNRVnVKNDMx?=
 =?utf-8?B?ZGVZbzFHQzdZSTlNek9VY1pmbGp2bjVrWjAzMG1DUHJRbmh3b01OamhvemZh?=
 =?utf-8?B?K0VuSFY2UHhrN1RqRmJWc3BWZ3ZwcTRXaFFxMWlRWnBaUHVwMk1BTXczYUtm?=
 =?utf-8?B?ajBaY0JOeHpCeDNMc0JTbElHMGRUajBRQ0hrc1ZOMTRvbU5aWHo3d3NpeUZ5?=
 =?utf-8?B?NjFKMUdpUjZTVjJNM3B4WVJrczg0cFY2U1hkL2dpVkV2MUZUL1g5amNuVnpT?=
 =?utf-8?B?WDFtNkxTZnFhQyt1V2xKejZZMks0M1QxM3BCRjJmSTBRaXl6U3NMZWpCUXpq?=
 =?utf-8?B?WkxrRS82OSs3OC9yQWFVajhaNUplY1VYUVBYQnJjM3BaRjJFMmpKTkFzWWRz?=
 =?utf-8?B?blpINmltMzhWaTU4M1NRc1ZZQTg2T0pBUEwvMVduNFlPL2NFc2ptNFg5QzZP?=
 =?utf-8?B?M2k0SzY0Zk1ZTXprZkxleGEwakg5WndRYjNNVFNkNzNrd25wT29tdnZDRUNv?=
 =?utf-8?B?R2JZeTNXQ1oxK1ZHRTVIZVkybWpBYUJieHFDSmVOR3RRQTdlZUJEUDhuQzQ0?=
 =?utf-8?B?bE45NVZ4SzY3eVpGaU9DOEtpZng4TTV0aGZ1cDRlOHBPVnlORFFTMThlL2d2?=
 =?utf-8?B?bnFXV1F5bm5YOWo5UVpGbytPTnBXQWdQdUNZcnRIUlVibW9vT2NZVXBCcHJs?=
 =?utf-8?B?QzVUbVliWkFST0I5MHRWU1hkK2o0bkhnSG5YekcwVlVzWHBYNDFvaUwzVHUx?=
 =?utf-8?B?M09YUFdGTmFnWXdmNFNaWU82S1RiTHZJUWNlTU42NnUwWGlQTnRLOER3WWRZ?=
 =?utf-8?Q?DaAb2oNPCLYEJNnvyaKkmlfU5?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	SmIOewPr1sci0h0tlaGEKI4Bq8LjXfJftLyHQpAfv7ltHPOc3YlNwD/AjBdILdFdHdmSeXGcCldPcI/K6E/lv2zN90ykjn/zA4ChbxmI25sdsGlHWl/bgxmw2nip0gLVon8XIvlZLvrsVD0czzBL6m/myc2z72DOMwT55CVxWu2E56hdEXAXebRU9J3Anlm7catKhVGTPPaggmZ6E1rxOSzCpiTroHenTpF1Tv0EfLlDEnbNK2RMtOPIFm6ZyoqsrM6I59tOGf6XSZDwukDYhcIFWwsUtyG7ats+uXYsmSQRmuGBle1uNs9PXb4N9fSL+JWcWKVohLtYUkrKbQYlENutd/5hnZ8ny1xXMi+diDpt5eK8FOpe6j9vx4NUox+WbSpdKyfte6Q+/QdUz+7nZGVuDtDjrUre8JDj4I2BKsZc8hVDBTEm87z9KwcVRNJeghtNSNavrEwClLDKnzJnPhj2VJj1NfefXRevoaXs7PTso9vbNFF312cqh7ypv8cMJbvd1u+SG2ldjwvKmhKzitISxpUGCvej0Gma4IsacPPrpFi/m0iT5fDA4J+tjagJ/eHVxOuHzomceWyCcvqX4sXJfek8rJcj8uBY2RxHM2c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbed86c9-1aaf-464b-f3b2-08dc595c0305
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2024 12:44:50.4645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6u1VLEd0gl+HnFDiyyaxFmdin9bQB7aAwrrI7YMsSG1C3vXG1YoLsUBs/B3Jd6PzKaaj05qQOCdirO8Y7IhFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-10_04,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404100092
X-Proofpoint-GUID: tYjSpWYk5TYapjNnK58uTRE9EOk7mlZa
X-Proofpoint-ORIG-GUID: tYjSpWYk5TYapjNnK58uTRE9EOk7mlZa

On 03/04/2024 00:28, Dave Chinner wrote:

Hi Dave,

Can we come up with some merging strategy here?

This feature is blocking me sending an updated version of my XFS support 
for block atomic writes series.

I suppose we can transfer all the other FORCEALIGN patches from that 
series into this one, so that this series is a fully complete feature 
which could be merged separately.

Thanks,
John

> This patchset prepares the allocator infrastructure for extent size
> hint alignment to guarantee alignment of extents rather than just be
> a hint.
> 
> Extent alignment is currently driven by multiple variables that come
> from different sources and are applied at different times. Stripe
> alignment currently defines the extent start alignment, whilst
> extent size hints only affect the extent length and not the start
> alignment.  There are also assumptions about alignment of allocation
> parameters (such as the maximum length of the allocation) and if
> these aren't followed the extent size hints don't actually trim
> extents properly.
> 
> This patch set aims to unify alignment entirely via args->alignment
> and args->prod/args->mod. Alignment at both ends of the extent
> should always occur when the free space selected allows for start
> alignment of an extent that is at least args->minlen in length.
> 
> Hence we need to modify args->alignment setup to take into account
> extent size hints in addition to stripe alignment, and we need to
> ensure that extent length is always aligned to extent size hints,
> even if it means we cannot do a args->maxlen allocation.
> 
> This means that only when we completely fail to find aligned free
> space to allocate from will extent size hints no longer be start
> aligned. They will continue to be tail aligned up until we run out
> of contiguous free space extents large enough to hold an extent the
> size of a hint. Hence there is no real change of behaviour for
> extent size hints; they will simply prefer aligned allocations
> first, then naturally fall back to the current unaligned hint sized
> allocation strategy.
> 
> Unifying the allocation alignment stratgies simplifies the code,
> too. It means that the only time we don't align allocation is when
> trying to do contiguous allocation when extending the file (which
> should already be aligned if alignment is required!) or when there
> are no alignment constraints to begin with.  As a result, we can
> simplify the allocation failure fallback strategies and make the
> code easier to understand and follow.
> 
> Finally, we introduce a stub for force aligned allocation and add
> the logic fail the allocation if aligned allocation cannot be done.
> 
> This has run through fstests for some time here without inducing new
> failures or causing any obvious near-ENOSPC performance regressions.
> 

