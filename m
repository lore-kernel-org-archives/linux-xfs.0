Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41113239573;
	Mon,  4 Aug 2025 07:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754293150; cv=fail; b=DOvK57alkwxHmUPntA/GXhAsGd5Iuv6rfQPpYlyIW/sMrbFDrE+vPqJtdZHmg16SerWsW5uLUXH1XEK6xhkQkNPt7MuMqTyKVdtxik8ZMd0nsbQyNSXg7yIvifMVKHkZqiRCQMcBeoY5MXDUgVvXXI8ELa2oGasdVvm1Fr4LXxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754293150; c=relaxed/simple;
	bh=TABZkEcNHTZyrucpZJuUkSKhkMK2vYo2Xw5z/53KhIs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uyD8Dqj+j4kalcpMJk1Yqt6mWA5f3LA+8B5M44s554niuLlUKpLSGD5+VKJTnimTO9mRgzOl2jl28UGQDs0IIYPY53bdoj1/lTa0CvQ6teuXRl6K0VHcLjJgKTZDOvjLhle4QF+13wfounnzh7NlyQbAsPJcfOx6KrHHTn24QX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=By/2cCgl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=O0pUvgTS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="By/2cCgl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="O0pUvgTS"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5747QuSW002966;
	Mon, 4 Aug 2025 07:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jz2cQKuNCBBm0ER5bOByNYi5+GK/mVLL2kzXhbcwHtE=; b=
	By/2cCgl2XOCHJOwsYR0WhNQk4kfddLyFqwVzIKa4SBEYyiZ08PHA8t521I8KP/c
	UPJd/Zv+AJRzLz0C9XWQ4gvQfaA0dcK4SG+xYjkFxg3q/NcDpFNJ4wDwPRceeGm3
	dEqAGZe1u++xzXBA60SkzmZh5j7lm94JXcIL8ps+pGc2IHvbAW6Kw5Bdpopp/2t8
	mdMovr4xoXLge7MfX+PlB605iGoX7o+5lXLGllGmySfOQ6TimelPVMDH6rP2acm3
	uklAqd3HaU4QTP+e1RdUbwzIk5PNTQksH4xCpKWFOWhdE9DL3xykcS6Cms6wr4TK
	RjfxJhd8nEKUYIIZbb3Kiw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4899f4t1sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 07:39:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5746rhvK015025;
	Mon, 4 Aug 2025 07:39:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2069.outbound.protection.outlook.com [40.107.96.69])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48a7q0b1ke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 07:39:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FqT58pB0fqrge+AGGxF9HnxpFf9dcVJAdEcUCA4v3DAJs0nLLvRkSQ6sDq1/e8f/gQzmcb+osswZzUpZQsdJIcBnA6LLupLkXx42wjnNC3WtkZFrJi+Jqu3GTBUsV1c+NuMPf7VIiWUQC8F+tiFMfyxQVtt6Ibfhuxu6NfeiXbmmhiN4I4hbHkhlqktnXWwLwEKm8ogp69QOBLSgkqGou3EVa+Ib8s6jLp9C+HIsy6BsLgxGvUd+DkktwdBPJEJz5r8CIP95qAg3s4bQ3SnKiRKq/nnTls/h3uUtTDNne0ORIDR10r1usK5jPP0NlNVom4wpJcrChXB/q1fSl6HaoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jz2cQKuNCBBm0ER5bOByNYi5+GK/mVLL2kzXhbcwHtE=;
 b=ie7X8uGDdL9+tWPehzR2LsrYQUOtLvRhvaP/WNocvzVTlZK71utA6GY5jJCA/I5v1mJRY64j/um2UDifkzjWpyFlwex+tdL9TQzAhJHue3wkh4WnPwqsWeZiuV0s9JG3cp02dx0qvhNUWyGe5BxvkqYw6F9L/P8D5urcuQ3lO3doEcrMQLX5ibXyeER2x+0dRI8+G6hqp++RYekaiwNT8dTOlunO/6EbigMccH5qgBobcLu4P+P2LN3pPc4GJnvtS+OCExIyh9SdInIfNUtZaxT5Kk0txn72UYizMuxQ+Ao3OcQ3qp4XGHHdRuqw5JkVhoERCRn8QCR/cra8nHWzCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jz2cQKuNCBBm0ER5bOByNYi5+GK/mVLL2kzXhbcwHtE=;
 b=O0pUvgTSsyUnCfHBybmVuPgtww/CvK3lZjMjp9j8iRSo8ARsoam405b60NElYSEpqXEL+xYC5zXm+mjQdfQa0CSyD2ijb6pqjP8l8H4eSTTilpfOsLDMGHTm4X/zyfH9BXmbyBg9H7nqcdM9PO2E1dJ9xWWmn5ASYQrXsogZsgo=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA3PR10MB8347.namprd10.prod.outlook.com (2603:10b6:208:57d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Mon, 4 Aug
 2025 07:39:00 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8989.017; Mon, 4 Aug 2025
 07:39:00 +0000
Message-ID: <a37e16cd-75e3-47bf-ac75-add0a5fb8126@oracle.com>
Date: Mon, 4 Aug 2025 08:38:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] generic/767: require fallocate support
To: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957955.3020742.3992038586505582880.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175381957955.3020742.3992038586505582880.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB8PR06CA0053.eurprd06.prod.outlook.com
 (2603:10a6:10:120::27) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA3PR10MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ef5d330-f098-4f03-d8c7-08ddd329fa14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEg5ZHJ0RU9TRWFHQUN5NGNWQm8xdytQN0NYdUdmS1lTUDZsTnh4T0MyalM0?=
 =?utf-8?B?YWhybmpBWVVmR1RodU1IdGlUQmd5ZmlmcUxoSGd4Sk9lZlVOb0c3N01kOGFK?=
 =?utf-8?B?TWpGYTFXeE5Pek5iMlBaM0JDSzRYbXJISDNUcUlza253Y0hyNnlMcDVBMkt1?=
 =?utf-8?B?cU5UTDFpbUF0d3p4dW1aVXpwZnMrTDdGWVZCU3FtVjYxeC9pdHZLWGtmdjZi?=
 =?utf-8?B?VjBIeE5zQnJUOGlsT3h6ZEs1d0k0Y3h5R0tkRC9HWWtqWFgyT1JMYjBNOUwr?=
 =?utf-8?B?eVZvYmxZRnhzVDZYdENUenFsUVRRRFZlK3Y1WGNNaFNSUDhwUS9VV2w2eEdw?=
 =?utf-8?B?UHJYWU41MDk1cUwxbllIdGhzb0NBUFllRnUwK2t0NGg4UGhTeXp3V3FiaVgx?=
 =?utf-8?B?ZzJiN244aDVtSlB4VE1XS0todWZ6RnRmdk5YZ0RQN3ZNZjBmUzFpYTJsM0pC?=
 =?utf-8?B?QUgwS0ZMdUhOMWFKZ0dlTXFBa0hBMHJyNTNJa0RVa1hJNHRZTGs1b1pDY0JL?=
 =?utf-8?B?UmY5VEZPaEF6NDMvM0QvRUpMb1QvcXhwaGhTclNiNmtDQXBDN3dCemd5QWxy?=
 =?utf-8?B?cm5NT2JKME9lbnF6bElpMUZkK3NyaVV0SWk5dkxqWnJyb3VXbzUweW5mZGl6?=
 =?utf-8?B?RFEvQWl0d014NlMyRVAwOFI5YnZGQVUwdWMrTGYyQXhhQ1BnVUtJU3VxRGho?=
 =?utf-8?B?eHYwRDBWbi83U3k0Ymg4ZFdQakJJeTZxbW81V1FkUWFxSUlIWXF3T2JUa2Np?=
 =?utf-8?B?d0J4WnFkY2l1WnA3cTRaRXpIanh1WkVkcTNpYXM3RUF5aW94MkxzTmhPbHY2?=
 =?utf-8?B?M2ZZdTc5WlZCVFlKbWpnelNzZUZNazU3TmFUTnFWQkhMOFZ3U0JMbEUzQnVL?=
 =?utf-8?B?MGthK1BYb0h1OGUwUFRhWExXbE5iTzJTOXZrMHFUbC9mWGZDVG56QkJmZ2lJ?=
 =?utf-8?B?M0p1N2VIS3FpZkJxZFV6Yms3M2d5SmliYVc3aWZmUTNPSEVoR2ZPTkx0OFdN?=
 =?utf-8?B?L21wOGVEWUtEZUUyWExqWGIvUnZNMm5pWUZyZ1Rxdi9tdlZuem5KY0p5TDUz?=
 =?utf-8?B?TWNSdnZQN0E3TEVlWjhCMjZNT0pYN2FqeEFudm1ESm9WZ1E2OCtCVFJFSC9Z?=
 =?utf-8?B?ejJsVjFwVnNKNnhGZmF1NzJ6OVhqdTNUV25yZHI2MWpFbEdpL0V2dG5IdzV1?=
 =?utf-8?B?K1Y3VUp0alVuODBUOW90VllocnVJR0tTSWFDaUJESmhtS0wwRld4b0hoa2hs?=
 =?utf-8?B?Ynh6MjJUR1U3c3Jzc3MvenFmVFpPb1VYTUhYMnlodUJtR2tQWHdKczI1WGZx?=
 =?utf-8?B?dkVBdFdDbU9jakNSaUo0cjBHWjNJK2ZrdGIwUmlzOXRPOHFhblRIeWtMZVE3?=
 =?utf-8?B?SWxISi9lUVJWRTJmRFplZHdyamt2cHBrWjNJSWFad3VtSUcyMlorYVoreFU4?=
 =?utf-8?B?ZG5LWXdUZnJMOWc1NHM0dFJhK0hPMHhHbE10ZC9Zd0VHUDFKaTFVYStXM3Rv?=
 =?utf-8?B?WEM4SzFLa3VuMnVtNDZrYkJxZUh4Vkp5UlJlM083K2pwTTBWNy9GUlpCTWZ1?=
 =?utf-8?B?YnV2TkRYUEJDSW41U1J0M1ZnUXdsallPOXlET3RzMXZZcFRaRTRWRjVGMGIx?=
 =?utf-8?B?MzRBd0VVYlhnbElXQ1NYejh6UHY1QUplN3poaUhibi9NUVNhbE1LSlJYYkR2?=
 =?utf-8?B?dzlXQ2twSFhnWkxLazNRYzF2eHJlb0cwajByNVVrQ3B4S1ZicWppa0tMSzJa?=
 =?utf-8?B?V3doWjhVelliT1B6ZXFTaTZWQlB6RTFPenJwQkFyRTI4RGYzMUtoWm1Cc1cw?=
 =?utf-8?B?T08zZWlWOXN4OTBIbHBLNnBzalROa1pyMDNNbnpqd25sKzVFRFdhWkRKK2l1?=
 =?utf-8?B?VTZyVjJwKzI4MndRNWl4Z0N6OVNmQnJkSFNkSnNCN3h1N1p6LzFyQXl6L2Ey?=
 =?utf-8?Q?FYS3L4Z0ZoM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlNtbFBjTGV0K2EzZGtiekE0ait2ckVla3pDT2wxa2lleVlUSWFaaXltRVZs?=
 =?utf-8?B?M1JRcm41TzJBNVorNjJld2ppcElvMFdLQVZtWU51ME52Q2JaV08zcVlqWHZV?=
 =?utf-8?B?bFh0UUplQytoMEFKOEY4RGNHK21QbUpKRndBdHAzb3hhVjVpb2VKVVBDSnRy?=
 =?utf-8?B?bjVTdGJNQVo5Y1pkL2lGTGcveHpsSUdrSUg5dmQ4Y2VKSE1WQ0V0SytzVDRJ?=
 =?utf-8?B?bk5vRTZHanBjZm1zM3B2Mjk1akFHVVJaaG5GN1ZXZzZtMnlxdndRT200OWJ0?=
 =?utf-8?B?QnI2cytQWk5nMkMvOGNRSTRpV2ZPeTJpU1V3UXNQUHhtYks3VVFVcCtWNEZ2?=
 =?utf-8?B?MkZNdkZYYlNwZjh6dUc1T1ExWi9JekhGazF6UjJmWDNRTDdKY05RS1Vuclcv?=
 =?utf-8?B?VFZ0bENoOTNpTmRqVDRoTEFQNk8weXVDb2ZIZldOdkMvYWZveEYvQ2RuZXhI?=
 =?utf-8?B?dFhRejVLY01zbS8xVTZFWCtCendCTVYyTjNDbDQ1ZnBlazVWNWpTWVNjVkdU?=
 =?utf-8?B?SmVlcXJmRXl2UGg4djh3WXpWNGkyUXpTTEFnNmJId1QvbEhBTGNBVVlQU2JM?=
 =?utf-8?B?Z29NbDAwclRjdmgzSTRDUndPbk0wcmxCWjBCWGtoR2tOdXd3bVliMWFVekxt?=
 =?utf-8?B?MGl5Vk9OdWRRZlg3bDlpWTZrYy9VQmZuR0MyRFhwejB5dUhMTGU3R1lmSE1a?=
 =?utf-8?B?Y2JSSEsxQmlGU0ZocFVlZ3NWaVpQZW9zRm5JaDhtOWxzRzVUUnRKSmFHQlVM?=
 =?utf-8?B?c09WeTlwcmVqeUVPdzIrMEp0OHdNR3VweDd1dFI1RVdnbFA4ZEtpRmhnRWJC?=
 =?utf-8?B?em5JMGJrRU1YNkhRUzVzRHp5NFF5L1o3TTNSQXVQZkVMUVQvMVMydDNVanlC?=
 =?utf-8?B?cnNwbXlJMWtQdkdiZ01zbHBZYS82cmtZRDkxYy9jSkRiZnV3U1BtdHJCVzZ3?=
 =?utf-8?B?Yzl6RHU2NEFlZ2lHam9sUTlwd0Y3VW9UOGdEU1d2a3loQ3VMaitCTElUajdU?=
 =?utf-8?B?cXhlUE1PbTZYcEVKMmltd1NWVm9WWERzdkdubVVRQTBvWGN0MWVSQTZZUWRQ?=
 =?utf-8?B?Ujh1STFHWTB0UVlpZEVLNjM1bXd5cjJpaXdzRjQvV283RUxoZVhSaEIrbFJW?=
 =?utf-8?B?d3VTL3VvVGhoWnA5dFVueThQRHI3RHVIUWJlaWtjMzJTRVhWdEFSU2htY1BP?=
 =?utf-8?B?RWpjVjhnN2JWZ3lkdU9HbWQ5WFJvLzI4enR6ZmVpSnIyd1NWeGVpOGo3T3hL?=
 =?utf-8?B?MmE4WHpxUVJ6SHRiWFQyTzV1VnN6cWFrdE1pR2hMZTVlcDhDMy9uZDIxTGpk?=
 =?utf-8?B?R0dIYXBBbktTQm05Ukt0SnFFZGJpWUZsZGdya3VuV1RYdUIrWFpyOFNDVklH?=
 =?utf-8?B?Smh4VFlPanI0blAzZnRKaXJTK1hKMXpXMUsxQWhoQW1TWW11OGpicFN1Zkxk?=
 =?utf-8?B?Q2hpN1VId21PN216eXdCeHByVzFiRzcyREdmVzZXWlZ3TmdzNWRQVUxMZnNZ?=
 =?utf-8?B?K0pUenZ0S25yY2M4RzdiYmFHZW9WQmZIWm52YnNuOE9iUDdKV2dXb3drSTVp?=
 =?utf-8?B?QzlHUllGMFR2aDczUmdwVy92KzNNTXhYdDFGd3NyTVFQa0xuZjc3a003UGZ6?=
 =?utf-8?B?WnBrMGI1QnNjV0hjSEZFbFhzZGdFUUllVkcrUVJ4VmtWWUVGanBCSXV3eTBk?=
 =?utf-8?B?YVZCZXc5bnVOVVZNMkFTckdJRW5zS0hMVEhTWUxHZ0ViU3dyeFN5N1JyZHN5?=
 =?utf-8?B?aXlSMEt1VmowZDJ0V01hV21VWkx6Qk5GYzBzUnpPSmpvN3hjZGw5b09TVmJJ?=
 =?utf-8?B?Zlg2UzhsUEJiMTZ3a3htQmdLMktoWE91TWpGeGdnSVYvdVh6RGpSK3B3SHVK?=
 =?utf-8?B?dDhNU2R2bUwzbHNyQ0tsOG1SSkFJM2FaVnlwSTZvNE9WbHpROEovOFZjaWlS?=
 =?utf-8?B?MTYzZ0dubDhNemxLa3V3aGFnNVZoOTRmcWFjTlpORXMvRVFNZVp3VitSZlN4?=
 =?utf-8?B?clBCMTRTT2ovNnZrdXphTGR1Njd2dmpwbmtVSGNOamRDYlgrcWNWTG5JZk5R?=
 =?utf-8?B?V3lvYUZmczM2OEdBVm9SdDBicE45TU9STkZRNHRqZDFsZitYTEdrNndhU2hY?=
 =?utf-8?B?RFJWRmphZEtFdGZlZ04yQng1WGJwNU5NZitPYnM1UVRjYWJZaUh3c3JZYUEx?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eyCOB/NnnPVUtRSc1c8G4HQ4dzOVlbFgw3amQx2LR6ZJvxlgluloz/Nq/tVdvZtJYggBFneNyGJcCDL/naOPWckMe7IHVEUiByZhGVWpEbam5XHpqP662OOr4s8Njtz0HOQ5BqpgxPxBPHz5bKLHUTRul51qaghoctTA59k3uU7ryA0KzMM0QEFZOzyO3djlOlmt6t5PVi0dJF1I5BL4kOYkJhcyV8JFHTyxO6Rc5jKPOgiC4KH9i0tc+P/QKzfbfc+zUuG1dqGX/W2u93ipqYFCo880XVpoxJM6TG/v2qcNhgP2M+HUrHXCnjFbaoW8aVfjC5x7aNLB9dh0O7bcGmWWQQly+a2YwCmIqyWDwQz6hyKD4DaA60rzcQPu1fevy33+9gu3UfO9ZSQeWRHrP75pe1zeGiPbDjkvb8OAgU5pDyjx8OhrNPRKbqJ0gNEBBEqXzbzv2eZGenQom/PgpKRg0cbJxuUHCRZZLdpWQN5OMZEv4X7ORwmIJGL80zfdqVV0J2oJJOdBI0UpX/K1+NaBvxsBN1GU63Ah3q+zWBwWnGR363a5wDDVI2xaS3HGUEwPkYzvGUmcPOuUp2AFdeSVQtkEzKj0At+LA5YHZmc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef5d330-f098-4f03-d8c7-08ddd329fa14
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 07:39:00.1891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gNqxrsQ4HbriS+gS8yZ0ky3yiw+G3fAft2qX4Iz06TObLhYiWk55JSGcA42GXtqdDs1yro7kTc5keKqJVi6lWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2508040039
X-Proofpoint-ORIG-GUID: Upc9jKxyNhwl34LnDXu-yICDANY-eEN7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA0MCBTYWx0ZWRfXwLh5YCNjO2Ag
 vdTZVZg+4qgSEj2tRKuzNkpHrY2SkD5gXCaIoz8yRobOkgvuTWg3gxFeyOs2l5t0cpepzq50xlc
 63c+ZNF4ffGdWszBYm8sPY0l2jhrQtx12pWG06PoU3qIr9b6N3OrK7ZyALvfiJyEYKlcNi7xf7J
 HKmqUPWh6lbL6JTiVpC5OEEPOsXm+l4t0HHFoky4SBLtQXrpFI22o4haJCQeOpS9G1xfv1wo93X
 e6WBYrz5ygjRo/f8CIzDNhrT/j0NpswPRibp5IkaZ9l9JQu4u59C5CdQPx9rsq3/PtTTH28g25Q
 4LnkA3Kshfl7JqMlXPzb80f0AttSnvSE8bkFsbRQk401OvlvM3sg2iteH9t1Y578eFWZXTcW+LU
 EypxgZg4SiwxpoFluQp3kkRR7ImxTQRoW/bMRuuYPH3rG8NiW4nTHzduLGesEocHJ6GCk9b8
X-Proofpoint-GUID: Upc9jKxyNhwl34LnDXu-yICDANY-eEN7
X-Authority-Analysis: v=2.4 cv=daaA3WXe c=1 sm=1 tr=0 ts=68906397 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=AYdOZoFED6dLgdZAUHEA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12066

On 29/07/2025 21:09, Darrick J. Wong wrote:
> From: Darrick J. Wong<djwong@kernel.org>
> 
> This test fails on filesystems that don't support fallocate, so screen
> them out.
> 
> Cc:<fstests@vger.kernel.org> # v2025.07.13
> Fixes: fa8694c823d853 ("generic: various atomic write tests with hardware and scsi_debug")
> Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>
> ---

Reviewed-by: John Garry <john.g.garry@oracle.com>
