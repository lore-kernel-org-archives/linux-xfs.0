Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3E34BAA6
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 18:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710355019; cv=fail; b=X7PIfQbChmbVWkRs/jbMhbnjkhCkfyuBmQ6ufjSTaaEmhXK3tfFp4njX7ipl7k/7dAlrBZfhm+iYfTbGQ8tNrbhlEvQBad+Yp76dIEgH9G1K4R5lzLyrsPquEl5Lq303OFoZYgCs3QxLH3Rchr3u/KpisPqIet1N8MiDr9xAZzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710355019; c=relaxed/simple;
	bh=szWlenyrSUmLojE6+ZerovPqMhQUeb2Of2MumvR+Q/I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kjsfxm/9j8RBWQapv+P0V0cbxjXcZisH6cIVvfsxblSzJrArg0FhF1XgorBYl499lcoTh6Nge58pQGX6WbQN1nEZKcrrh+XxmmyoQeii7is0TD8egyta33Xf+CKW4dVChLj0TIrlNXWtmRVrCf4GfE8KUI9ecxPH3g8dfrq7EAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DVnWFmFs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hFZ6v9pV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DVnWFmFs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hFZ6v9pV"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42DHx3Bc015143;
	Wed, 13 Mar 2024 18:32:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=veJy+f5aMg6kpk0TemDcQStP8t8J9DUpWiDiB31Z930=;
 b=DVnWFmFsABqvGrhwisMEzhyjtLru/6dpyKkC/sr2OXkfZWeIMnPqk7E+AnEuW+i77bBL
 FKcsXuAVVmhJmAbqZNZ07J7nf62/cJ+TDD2xIV/a5G2JddaOuMkgiHLA5mkLV3T5PlBW
 thtJ/sr1hC7+NtpIRet4nJrpqFVYK3D7VHhFbU50lCod2Kcjc71RQ6zxyaaaytXzQ9/I
 5Ldp7YTCC7IppCiHmLuV8K7HFZM2JgS+eJepr2Ar/Bfrque2+JpC8AcaKuFh1CyqiyrW
 wztJzUdadeyRl/rGqTlRO4Fq96Mv+wHBXmhgw8kDKeB+00VEdwJbANTwdBZoCziyEViI 3A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrftdhu9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 18:32:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42DHZXLh004864;
	Wed, 13 Mar 2024 18:32:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wre79hv9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 18:32:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiUDggxLXbT2FdCJIacUsDjEUYJbP25W9mntalSxFuQMDd1kG7YwsXKXbPwWAGFupn87BFrSA3UDp+W9aSWC/eos2iyKiWVowIbHrl3lKgMIYrtSC+6QW513B/FMfZRgWFwFKwyW0wjnxxVu8eFkCswXnk4ETX5V+2B4UJhRuyVfyB3gg4ujWUU/1mCapN7Av+j51wLuQk1e7Ow5qIqYFKhX4oqtuV1EuaEEl2yArg7tc2sCfAbH8aQylB7yoCSu0HSMrTnUr0yIG1AakXmYOpIQ4du/Rdwj2Y0m74a51zSxua2/D3kRj2qZYBPia6qE0vZAqV/SN/dAG81sKdiLFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=veJy+f5aMg6kpk0TemDcQStP8t8J9DUpWiDiB31Z930=;
 b=aYxXNwncELyRRFngDulowWqEY8W61VN57lEqXDDb6mRzEjekO08L2yfBuB+wkwMS9xGsdS7zwfWUMJINitPVUzg3mONru0Gu/ygkqVyyo9B9b3N02SWuHEjDCBqDFOlUWchxP5k7cPenN94Xh/z0RPWXNQeZqmfgW7oL4aUqxlYHGp1NMnKSECmqDcB0I/+/Gztye6bDYhuT08PIFwbdxTCNe/4lXKsKf0On4kXClVLnqK3KRn4ThzvTJTRtSuGad2GD+On8aPtoWJcBy5RoyT2Q6KbfVnHbgelUuUUhyax2PGAc3c0uc9WGzgMNWZ60IJQ6PLGefmq+g+02z7nmvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veJy+f5aMg6kpk0TemDcQStP8t8J9DUpWiDiB31Z930=;
 b=hFZ6v9pVpI2EHlEulWY4cfly0kwhzs8UhmjdfYQc9stxVIMMoRbT7C31nHhVen43GyZOD+9sybNulTP+Hq7Rz04d7qh7HViVRmMs/IyJnjDSjEAcgYVHGgE5BKzL3/npClm6pjrIo9uQiM9irZf4PH1Uo7JwF/RtJ2+aQ7Wk9M8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB4983.namprd10.prod.outlook.com (2603:10b6:408:121::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Wed, 13 Mar
 2024 18:32:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.035; Wed, 13 Mar 2024
 18:32:42 +0000
Message-ID: <b9b0b744-496f-4fcd-83b6-fff0b5008eca@oracle.com>
Date: Wed, 13 Mar 2024 18:32:38 +0000
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
X-ClientProxiedBy: AS4P195CA0021.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: bb3fcc14-5bba-4aa9-e3be-08dc438bf7d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	PTtx51Kd/Z263xqIhSyrHi9W0p21NzhK7UITpJkymDbAq9Lbx81i1tB0sKw489F54sPiwyj6zZp1dw5fSQranIPDyLSRw+lEKYMBjDUAsTi//K8Og9rFLUnpc9sWzREQ5Dil57hVSnHPeuugH1qaQBpEFC8IdR6LOge0F8Ou7P+jG/xiaaCBy5bDVM8WgHRGcmVZ8WbDglQmTdBwW0g0a7f85MKaUfiDpTYhelwNj/lrHyG/Zz9HbiG9oumRUU0XapaTOG0REcknDheq2OXYgoKyUpHGd3zWPGYn5ZBae58BZMrmn8OSrd2ZvH1WQ/zBk3jhoBj3CBMYj9HIDHP4lKuSmN0U/714kRXTO5mN8Z/5oFZpF070b9qkllA1ZS5WLK9ZuLmqY36Te/cp4aziEqPEx27BeqKh/DHXjj58AVs+M0usRB2gTaHdzxTIExKvqj89MsGVzt9YlYwdd58hIsHrxEwGSxa2iBWOPB1zMyGu0Z7ysAqkeAzGYbshB649o7U5vKlKSMzVzGhRyTJLnTIOxCiLYzyelUEvW+IXr1H6pemNPJUMm9bnl/wD+l8UGvfC1obn8pKGHzs1g2aFsP1jk3tbcTOwtWuORUfyyJnG2diHgkBs5+YztMq+JDZJ38QkS4SiDWnSJIheIL9DtgInGyqeZVVj8G82u9WvTSA=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZEhObjJJM1lrVFk4bUV0MmNMaU1EZXA1WVhkblJ6STN3clc2aFI2M1E4YkNl?=
 =?utf-8?B?RVBmS0NWeCtDdXh1Z0NjbDdFeVNuQTNibitxUHI0a25XQ1NndjRxOWRQNWht?=
 =?utf-8?B?Unh6ZzdENWRwZTdSa3dTcmQ0N1hjRkFrdnl3OGFQUFpPVUhFOTdObDNLRFZs?=
 =?utf-8?B?Vnk5WmtyQ2EzTHYrd3JNYUZHaHN3OHZuTDk1S0FTdnoyRXRTWmUrcThIWk1x?=
 =?utf-8?B?b00yeW84cXQ3N1M4dTRkK3RTQVVVZzhFSFYycVJoNlFZTzY0SnlvQndwZlNQ?=
 =?utf-8?B?UGVSMUpiQVY3YzNaL3Y1RGt5ZUU4K0R4M0JvYk9qa3ViQS90a2d2c1p0OTJX?=
 =?utf-8?B?OGM2dWhYc0x2akVlOU12Y01XcGtNT05BY3BGcnJRL0R0eXd4RDVHZEEwYmUr?=
 =?utf-8?B?VzdIRzJ4ZkpaZFpHWDJROWQxTVZSbndLamNJVVQwckZGdFNPUThveG9JZVo3?=
 =?utf-8?B?ZVlsRzJ2RmVmQVdPekJEc3dsZ2FpSVh1czB5VTc3WWdGTGk0eitlM01MZENN?=
 =?utf-8?B?cWpMU3poT3YxS0NycldCZW51QUhPOWo1ekh0eWIwanhBUVBCN2o1Uk4vTUFJ?=
 =?utf-8?B?a1RvNy9TSlQ0Nm5seElrcC81aWNiK2NEczQ4SzJPK1VSOFljNUIvRXBLM3VD?=
 =?utf-8?B?RkpxbUZiM0pMbUFNU1ZhWjhGM3h2eWpoM2wwWVJaZjIyeWsyc0YvUEdPeUtP?=
 =?utf-8?B?MWovRDhBSGJqTUs0enNsVUlQWFpwMjFBV1NidE1jZ21tcmhqYVRWZDE3aDF0?=
 =?utf-8?B?UUpuQ0s5ZElwakxFK1FmNHhBMDViUnJZeW1xNWpneitodjgvL0R1MHRtRWZV?=
 =?utf-8?B?blJGR0Y5S25yUkR5eEJpeG9sazAzUVh2WTI5SE1TNW1MZ3U5OXljUUNteXNh?=
 =?utf-8?B?UTQ3WmUyUEJwbllxVlB4WnAwdWhHeDd3eHVXaGNkNTNtbWswdHk4L1lZeHUy?=
 =?utf-8?B?MFhWRTh5U3hUUUFsZHpZVFIxNE1yR3VRcDUxY2RuTDBEVnRXWVFzeTArVmpL?=
 =?utf-8?B?azFxcmZRQWhYTTJtSDFXeGJXWldCU213UnQwN0N0cnpUcDdSK001K2k1Wnc1?=
 =?utf-8?B?V2FtNTFnVS9BYU42aU8rQlVEY3JLVjU0WHE0RUppMWJXdldoeEg2ZVZOSE9P?=
 =?utf-8?B?c3lUazd3RHVoSkV5ZWlvOHg0UUh5SGFkcDB3NVd0UHVZSFpjNGc5WTNpUks4?=
 =?utf-8?B?cW5qckQ2VENSWVF5TnBHNGptdXREcThwbVpzWmZ0MkhJU2VWVTlpbG9IcjZ0?=
 =?utf-8?B?L21HWWcrdWRRci9sUGNjQVIyb2RKTlF1SWd4STUzeTRQZ0VpZWo1eXZLK3Bl?=
 =?utf-8?B?MFhvMXdPcklvOFd6elJhbTR1M3dERFFsVENCZmdiNExZVlZGQVNGSzVCWWpt?=
 =?utf-8?B?YlEyOUY1c3Q2QmZKSy8wRkVrbVYzUUdnd2kza1FTZFdpWWN2ek5MMG90Y3hC?=
 =?utf-8?B?NC9RUkU4TDRsN1Brd3dWUzFWRkFITmlDS1E0akcvT0tnSTlHenZPeUNNVHdG?=
 =?utf-8?B?bGl3M0JHbEUvd05FUkxwNjFGNDdyN01ESkV0MlcwRkJjeUcxVFpvVE9Kb3ZI?=
 =?utf-8?B?ZDJNaTY3ZVNsczFSWTJkSGdJR0V5SjZqSmtOUnNPRWRIYUFmZFgvc2czQ01o?=
 =?utf-8?B?WGJ0dVc3ZmMxdXBUb3FqNEpZQU10VDZ0NDBTcTVvZkh2SytFL3ZnbUNqOXhi?=
 =?utf-8?B?d0YvSU85dU52YkZvdFJsZlZkSXQxYjFrblJGSnNGcDR6UGNBTzNGWXZ5Smlj?=
 =?utf-8?B?NDBDc3FrRElrbllFWXV4ZXBiZnBteU9GSndMUExSSjQ4SW92Y0VHWU5UeThm?=
 =?utf-8?B?YXVvOGgrUmEwQzhDRmpJUUlDMUlpQVlJUVlJWFU3bld3QjNyUDR2MGZYeXRF?=
 =?utf-8?B?aHVjakJ4RFJPRU1jRXFyOElOaFJYS3RNVm1yYzdjdzlYaHRIMTZqMUNWeVFU?=
 =?utf-8?B?Tk1rZkdNbDA4OUp2TFF5eFdQMmFqN2NxL0pnVUVwOHdpSUZvSE9takl0OGFP?=
 =?utf-8?B?ck1WUVBVWkVjWXUrQmFNQTBpbldWa21vQXQyV1FXd0FIb1FsRmxUaStJMHVT?=
 =?utf-8?B?Um1tcXJvNFQvMFJUbURaQ21HaHBOMk1oOXI5dHoyWVpZbjBkd2xSOWVLbzFy?=
 =?utf-8?Q?4vc8NwQHiHAdbric2SKg9rDjt?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6WFu50RxDLppfQGzXn6dDV/tKFouuU2nwEEwlAM4c4ftoMYMWDjddZPa/48yUTWqOz1SVB/q/Swj7tKj+l9E26oAZa2JHXJUBIOe4FwRr4VKmlfIqJrn4RtsxxhC9d4zUcxNn4GruRr7TSLjxwso8ZMlusx6e5YKzP5v9VJzOH3++EPp5tDPUglFouLY8u8B/xBJJ+Qxlpk6Moa1UCpEiHf242SZJHdAsOXXPz2hdDLju9KIT2FgTZ/i4lhgelQXIMLB7KIKmEw4iWcgyzjNhp1oyKdKkf7+u8WGLGT5zVaI+5/2B2uAAqs6ykmOB3IqEfh1grPmXS8pHZtN+bpw1sQKsIhbl0qxb2xwZ1Hyl/TmHXFXpS5BmKGBV6BwWLgm57t2ouvtzC2ZWvN3w7D/kxbK9kyFsMUzI+wu9VKryjPh6gMJe/eTz0ymT8VcGMCnWlTtsyb8saDIqw4YuNK3u/txzinRc7GMKO+ue6gElreak2dEv202X3SjmG5giBoKoUJiG9w4GH0iqRzsg4g1WGDxbyD+WAy6WpyPjQagYNT7mNKt40f+b6PlrDu77aS0Z/tbSh6E5WC1qZqu3oMdFbBdaLdG5LGiKEkdU1jpxKM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb3fcc14-5bba-4aa9-e3be-08dc438bf7d3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 18:32:41.9510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TeUTPPtuWt8sFLO1kX7itgCkTMcEcadj7yMPDjO1gWYZNpWDQIkfr0mkvaM1BTt1qG94cjahnBXZKRaLGGy8gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-13_09,2024-03-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403130141
X-Proofpoint-ORIG-GUID: TKVq91Y0526ezuRzPTFpMvIiokfZ9PaH
X-Proofpoint-GUID: TKVq91Y0526ezuRzPTFpMvIiokfZ9PaH

On 06/03/2024 05:20, Dave Chinner wrote:
> Hi Garry,
> 
> I figured that it was simpler just to write the forced extent
> alignment allocator patches that to make you struggle through them
> and require lots of round trips to understand all the weird corner
> cases.
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

JFYI, I started to test fallocate for FALLOCATE_COLLAPSE. I think that 
we need something like this:

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -61,7 +61,11 @@ xfs_is_falloc_aligned(
                 }
                 mask = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) - 1;
         } else {
-               mask = mp->m_sb.sb_blocksize - 1;
+               if (xfs_inode_has_forcealign(ip))
+                       mask = (mp->m_sb.sb_blocksize * ip->i_extsize) - 1;
+               else
+                       mask = mp->m_sb.sb_blocksize - 1;
         }

         return !((pos | len) & mask);


I think that we also need to fix up __xfs_bunmapi() to do similar as 
isrt (for forcealign).

Thanks,
John
