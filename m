Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E747F7FF
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 11:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709725610; cv=fail; b=hY6UotunptvgU7kMs9HiY11wcU5I/fbTkLxNGA0kVC8hXradBFPLqZHFP4QHJqPfznz1poyarjqQ+syacpuI1WBPgIZjov+9lcN0yvDzsj2uxmJyEBdf847y813QBshARi5mKd4BVSO8eI8EhajCOoVo+7nW8lFz+WNYmLoQEoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709725610; c=relaxed/simple;
	bh=K8/ootZzEAG9ReUYcsEJTs2Izqq+S03jH1idIYcPe8w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m5E/Fd12wmSS628SYNrhPz9KhcmXAaPimER1x2+wBl4K/2CWiyLAlkThFbJPZ0wRO3XaqzUdEDYEF1xd9gJKcoeown12UJwJivzBENJoLZsfNu2AbBtQw1cVN65iux5je9OaH7Wgt3W7QyL8QNQQahjXENiPgZ0sDTRido3OAa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ktmNnx4q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dOeeTBss; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ktmNnx4q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dOeeTBss"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 426AKHcA029802;
	Wed, 6 Mar 2024 11:46:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=/LWPNTiVBk/rtDDBuDCqUjJ7BmP10yiet3SotbK6ABY=;
 b=ktmNnx4qhnWbbGIeJP/3GomoXb1RoD/2rWXrXGFa1FXhNHZ3EPLH1Z6tIqD3oSNNo/2Y
 rmjva2ysmkU56heaAw5p/+l2UQu5JH3Lwqgd33G6Va7Ryr+pOfReSZKon+yJpMsQsGoH
 ovDbkNybgJxBJ97TBl1TyLYtZ/8wYM29vrnFTVaEkT4OxYzm5nBvga88surYUrS084MK
 k88GB+jX8mAJZ7dEnaCgr1/qvl737Gnj0xbcA0YRi1sWoPaun2M1afEyrnEzNH8iscwo
 a/Yr4kmk1heRQUpzvsoY3Te+78N4GsnJwU1X6GUcX5+jQF7XOioOrjb8rDKmACMC36QT Ng== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkv0bgnsn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Mar 2024 11:46:44 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 426B296l013770;
	Wed, 6 Mar 2024 11:46:43 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wktj952d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Mar 2024 11:46:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUof34lQlgChNSU/7GSUjdSnFe7sZ88E3r7SjPFpoTVAGI+Wc26L2sPkF/yzZESsz2yJ9p9m7NUMYH7fxwTm9AC+G8T4fySGDLBHLQaou3XU8mpsbDZ/f3L3zBtAC6EK3MzPWPYvP25DtEzYmeXuLr3vdx0UQN/htqr5Hr/4np3HH5G12KXiKRCFKKjfOoAatjLykrmutqa9/Yh/1mYXhvWAXnLPk4wjPq4pah9L0reyVBqrsQHzgam2ZgLddZMsFlWMj2tthI/qFfHiDJUj29GJOI6+rDbmAa9UkE4dCQ/CRMCh5QY543CEUcoSNEGw4u+EgERDMzEMuJyXih/vvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/LWPNTiVBk/rtDDBuDCqUjJ7BmP10yiet3SotbK6ABY=;
 b=hN88p194evvaY7z1GmX4GROhDoNOlnw+Wim4ifEgMXIZUYVTkzFl/YnViEf70fqx0F3OOlNLdss9KOLRYl3N4otEdqMLSotFEAsrhcYN7/ay7sQAsvKZ30zObnnWM+A6YhwvZUKdM3eQysMx8h+kt0Odh1pcNYEoCNvNx7q11xnPdu5s6S6wJAdjMmDPNEMk0/PTvJVet807umkwIe0gTKiiv4AHSZ3D0X7656YKyVNsRZ5Pmdjq82l3J2ubjfpxBHnyXS+iZUftj9bnf6kT6FpQMru230SfV0h/f7eXleiLHHML2ngc2rCYkw44EwkBRbX3zuYyXiGFqcE6ibz6xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/LWPNTiVBk/rtDDBuDCqUjJ7BmP10yiet3SotbK6ABY=;
 b=dOeeTBssBZIT6ELYau9xZCvYFZhcPc9kr4gHmN/teu5eREPS2Vj1MHjP4+vv9iQDayxIBHrRQgivQ7iImBAkq5kODN2RZGNRBS5rVqNcPhGLxmroYGIL1YB1s3INVnuWOceKtTGxAQj9+tSmOgyyJ3l53F8AQfs0XgSAAuivln0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB7079.namprd10.prod.outlook.com (2603:10b6:510:28a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Wed, 6 Mar
 2024 11:46:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 11:46:41 +0000
Message-ID: <53f4519a-6798-4925-ad5a-5d2d17b6a00f@oracle.com>
Date: Wed, 6 Mar 2024 11:46:38 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] xfs: forced extent alignment
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: ojaswin@linux.ibm.com, ritesh.list@gmail.com
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240306053048.1656747-1-david@fromorbit.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB7079:EE_
X-MS-Office365-Filtering-Correlation-Id: 759a4feb-cdef-4cb9-8ab5-08dc3dd316d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	BDRPhiHjv9rc6PqqpCNawEwNzF3sjrHh/T+pADDdy+MSepPPje68MNFmkmKf/uxS/VZRHXJAQYtBxb3f3Bs86uo3S4GPQsolvo0uK/ea/ZSMIPBZQEpY/kyc/ZvzZSt5POMAdQPLKhmGs/M7OBIlh/dfVOayBMYIpQ0UVJ2DBy7SeMeCNhEvobAKz0DGlH/v/8mZ1E91nCrIM2pikbyIQyy2w9ReynTzRty/6stZ8meG4CcDcEnL687KDrmJxiY1kiL+75UWZvqxQCKxL2ef+ruhBAbPqiQDkl02Q30joHrRhRKhK/vFt/mNIXDLmEqqpH4H2GZuERM4xtg1BJd+VttoBXKr1Y4TwuQFxCHwfqEA5to2RGaPrUdqVN7DNWpF/Ir3Nq/K3WxOyivb63279dXYjzSG8ZPsdiZUYlIo8FfkuVJVnUoAimRHFtZaDpdQKjduERnDsKyun0KEFtyskxSzSgkviQULbibaDi20ydqa7jGzWk4mNhD6uPKoJUdKYslkd9lXurYDpsEgmpkXhVAkwbg6DGIui1Ba0X7ezbvLs10Ruf+Kwjb2y2eBAwELTGZL9mFp4Oz782I8HfJPkxJoi4uMvZ/66DIxaOxCs74nwqKoNmSelitiRXwTIwnIMJkZ3IysqH4JJCEuYocKg1iS7Q8Ht9FczkZVA/VsanY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?K0hGU1NDblVxRmw1K0hTZE9nVFhyUkptaHE4YkpDL2RZMm9RMThhTFF3RE53?=
 =?utf-8?B?MzBWVC9HTHd0TFBlenVTc1B3aFpYVFNOK1NGc3pTM240T1FmYXRHbUl2bjJo?=
 =?utf-8?B?YlZUWmd3Wm1kR3FOeWJnKzBRbmNiZkYzemRaUVV2enhKbEJxV28rV3RMaGt6?=
 =?utf-8?B?L1M5bFZkRFhwbXVoWU9HbFhDUkVkTytIZ01meHhhdkxiTFRnNXU3TUZ5TnFy?=
 =?utf-8?B?UEIvT0RXNWwwZUpjdm8rTXlmRmhONjJWeDRQSGZqWTg0NUwzblYvUDFXUGVB?=
 =?utf-8?B?TUhHQ1JQM3hDL2FXTWZFM2dwZUZ2cHNraE1JWkVtKy94bjllN1J0S0NJRG9D?=
 =?utf-8?B?QnZsVndYUlFZbnRJUnEzTDlxT3lIR2svZEc2NjJ2VnY0eUpVSStqZFQ2MVFp?=
 =?utf-8?B?eXNPMmVycXlmYnJCM0NLNmFXd0FFS2VxeDlROTg2MTVMYWM4NFZseFZnRWow?=
 =?utf-8?B?V3B1YWpDZjNNdlZTT29GRjZKOW5QQUF6NGRxZ1pzVDQwWTlFSUpncEJZZTZ1?=
 =?utf-8?B?ekxkUzZ4aFdQRmVnajBCdHRGUUQzTXNuSWFEcUlKek82ZGpOcFcyZ2toVHhr?=
 =?utf-8?B?Njc1cDkxVDFaMUNubEkvTi9IYkFwVjBDTm1kRHh3YmdHZUJBYzM3QUFWbWlI?=
 =?utf-8?B?U2hwMGdFaVZZdFp2Q09KVUoyZHF1OVNTZjltb3lRcmdxdzJVSG51UE1nMzNJ?=
 =?utf-8?B?L3N2SWhlSGFiMTY4cXEwMjM1YVhVallSK2d4Yk0wZUZUVkpMbDZ1MlhYSXJZ?=
 =?utf-8?B?bm0vTlUwcmhIbHFvVEZET0JSWTZ1R2w2aVhhQm1KTi8zdmdxKytLR1RpQllx?=
 =?utf-8?B?UVVFZjdBOUF2dGpDTVRobEpKZ1I2OTBiWFlxczZtejlRSHNlSXIwSUtDUlkx?=
 =?utf-8?B?N0V5N0NZRUZsZlRkZm1wRUpyZ3g2MEdSYlBJdkY1bmdmT0dBaWtzOGVOdzlI?=
 =?utf-8?B?OHc0VDdDelgyR2QvZGlzRWZaa0YyM25FTk5yNWNpVnJZOWszNkJlT2RXSTZj?=
 =?utf-8?B?M1dobnFjYUkydWx3NEhhTjVPeWhGdktSYndkS1RhaFhIR3Z4TFE3MGVxM2I0?=
 =?utf-8?B?RnVKRThrQzlnd3JXTWhQUExURWRrS3ZWZXVSVFB0Ukh0NXpwcHVJRXJJTm1R?=
 =?utf-8?B?Ym9pTjZQYVBaak9qd01LcWJ0SXZSYTRLUjZlK3EzZFZLckxFYU9abHBXNk9W?=
 =?utf-8?B?MStNeFltbmtZV1pIYTZJbUFPaW1wZTJjSXZzaXpIdDE2WktrdnVNdlY1dEtJ?=
 =?utf-8?B?Wk9QeCt6OFBwdTI2c2ZVNXhTOXZiZDhjM3ViMkdGRElUbXNTY0lxb3F0T1g0?=
 =?utf-8?B?SEcrSG54dHovblkzTHhmK0pvbStYRURWTUJNYStuN2YxeTFQaEpwY1JqZ2d4?=
 =?utf-8?B?RFl4VDRhV0JaTUwzY0psK2krbnh1MU5rbC9DNUdrclBJeHJNcWtZUDZNUWlC?=
 =?utf-8?B?U015K0ZKenlPQ3QyMjNCQUs1cGtpazVaNkVKLzZDc2p4Wlo3RzhNS29YTW5p?=
 =?utf-8?B?ejVZQTFSTmtHemMxMXBiV3lwZVlRWTJNMitYdUNrVEgwMFA2aWY2QkRUQTRO?=
 =?utf-8?B?bUdpbVYvaEYxNEZrVlRPTE5DUXI2NEw1SU5YRDQxQ3ppeGNSQW9ST0Vad2Ja?=
 =?utf-8?B?TGV3Z2FucjRQZ0ZITlNrYW40cGRSbXR3YTRIbTB6Lzh1M2Nab2JWTzZwSG1M?=
 =?utf-8?B?SWcwWnVXQ2lJWHFaWHlvN09ObUYvVEZiOFdidlc5WHliK25RL3c4OEJKdEd2?=
 =?utf-8?B?OE9kcmVMZEp1OWI0TGFwYlpkNjQ2MzBFbVk3eXhJeHVaUWZJZmFqVzRKREsr?=
 =?utf-8?B?dmhxY3dkc3ZrdFpnb2pPcnBWVmFXanA5VERMb29MVjRnK2o4a1dycmlybUFC?=
 =?utf-8?B?ZjhvR3NGYjMwbzFFVmt2R3B4aTJ2SWZsU0pIRDBRUXFYTVREK3dFNUlqNzFv?=
 =?utf-8?B?Z1Q5RCtqR0F5aStyWE1RYWY0N2RuckFZbWkzdUJBTVg2dUl4UGhPTE9sdmNh?=
 =?utf-8?B?emJPc0Y3Wkw1MHVBK3VaL2dsRzNXT2g3djFiZk5UcTlXSkdla1RjK3QvQ2ZD?=
 =?utf-8?B?c25VN2txQUJ0TVRGSXBUMWZQaFZWY0Vaczh0eWljUzk3bmVXRGdzVzdkQ0wy?=
 =?utf-8?B?LzdHdS9DR2hsS0d6T2hVQU9iOWoxV00rSGpvRGd5aGdjZG1HYkt4OSsvZlg1?=
 =?utf-8?B?ZHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	4fvG5wCVKAFlV82c1d/0Jx1oAl0o4VxLmju+/zZYbZOfFDwiBr0BA6ZGckaU5dTb5QMCzvQ9EdeKZ6xgt+gGadsn0eVl8Z7WA44CiiRYPVHKWPMHfRmh4ubFvz8EPKGb+TNdj5xRcD6UM6MvLcpuQCXBALPcWqH8852ekQduxETzvZJ8B73mlYVAjUZvrPUEDnvC6wnh9UO6Oi9z2A8rA/fhiHx1IaTElEp5bweue528hVp3vVEsIFclDw78bFbPoawGo0fl5g5PlkywvXf7yhn0O0vLyLAIYsx7mtsh9iDhdPDZ4hSZczkES2weTKGgy1ML5iCYF7yQwi7B0OP3weg07xI3+lK0PUA3i4XRcGrjzat7mQnExOVKPPWs7Hy3PHjkMWBGyCGaYeuqkXb8Zz4YE13tbLUsVvP1SsUNzMtOcKvj2888JJgMzX/PYovBIsXb9YD6/f3GVA9p6ey0wa2u7RLQ/30G2AaWVUONGguzVoecIR+pppXiX8Jo8b26QEWwktoIZ+EGZrWOI6vsUSq55IGRzoytFjqIdTtlWIz9gZAHfiq6Rd2oZLRZmVDRuBm3sb57ap64H952+/RaLoSrE57XD3lGEfGodDq6Xgk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 759a4feb-cdef-4cb9-8ab5-08dc3dd316d2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 11:46:41.2133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBz8xkiS9Fw4IKjLuyDUpVI9DBSaTXwgu6/pIk620VVKxzHNoVSEX16Wc/cDUrAwAvenn+dB/61KpMI6SaYutA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7079
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-06_06,2024-03-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403060094
X-Proofpoint-ORIG-GUID: Isrtd6BiaGjOtR93Oav61Cl_bS3Jr18_
X-Proofpoint-GUID: Isrtd6BiaGjOtR93Oav61Cl_bS3Jr18_

On 06/03/2024 05:20, Dave Chinner wrote:
> Hi Garry,
> 
> I figured that it was simpler just to write the forced extent
> alignment allocator patches that to make you struggle through them
> and require lots of round trips to understand all the weird corner
> cases.

I appreciate that.

> 
> The following 3 patches:
> 
> - rework the setup and extent allocation logic a bit to make force
>    aligned allocation much easier to implement and understand
> - move all the alignment adjustments into the setup logic
> - rework the alignment slop calculations and greatly simplify the
>    the exact EOF block allocation case
> - add a XFS_ALLOC_FORCEALIGN flag so that the inode config only
>    needs to be checked once at setup. This also allows other
>    allocation types (e.g. inode clusters) use forced alignment
>    allocation semantics in future.
> - clearly document when we are turning off allocation alignment and
>    abort FORCEALIGN allocation at that point rather than doing
>    unaligned allocation.
> 
> I've run this through fstests once so it doesn't let the smoke out,
> but I haven't actually tested it against a stripe aligned filesystem
> config yet, nor tested the forcealign functionality so it may not be
> exactly right yet.
> 
> Is this sufficiently complete for you to take from here into the
> forcealign series?
> 

I'll try it out.

What baseline are these against? Mine were against v6.8-rc5, but I guess 
that you develop against an XFS integration tree. Maybe they apply and 
build cleanly against v6.8-rc5 ...

Cheers,
John

