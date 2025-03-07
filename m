Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A405183CB0
	for <linux-xfs@vger.kernel.org>; Fri,  7 Mar 2025 20:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741379890; cv=fail; b=Y2NJzcR6J+8k50AetzriHFTQPO9TO+UZjSdMblSyjleHJofssthiPESxUdFn185eQW0WO5FYgi5C8BKJEsLW6BCE29Bsx3yvlL18CFvaA+e68dcrJkObAbk/cRvASXOjF//anhBzNDCdcahbMIQK8tZXBGP8lSMtOcyZTOT+3BE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741379890; c=relaxed/simple;
	bh=ugRuOIkyDGycIjkjU1oX1ZtC6OnF2fMPB1hBJAakPBI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=muRo9JkHjEqKmvPzHEfYBCuzGVcF93vAsDgrzXV6zCeHlb8s+DFzSYDHrH7gwqxVeBdQLr0yIbsXGDqzeOjz8/Prr7K5uNibFh73GZ1cU5xNcVvmvlALxDZpdeUMTVy5ab0S/MXW6UYM5zh8ofh24DkYtvTUdkqe6MeJam/1pAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Lh9jMyoF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wbrVmXcw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lh9jMyoF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wbrVmXcw"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 527Ju5RC016530;
	Fri, 7 Mar 2025 20:37:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=R/NV2pQh1Wef4bfndzaaCJ+2Cjhita0A55PvE4Ep7xE=; b=
	Lh9jMyoFZcLVPAZa9iDcVs/ln4oIcwWl/plzJim97GwF3G+yZW+LyEdayWIfcJQ3
	jPop870zxHOu/WH0kabptyGRptL/sUo4/yBtHPkG+acUjOmm0V9X6c1AEiLXE4mO
	P2QId61DNWbS9SLD7lUIlQ3mxydOIA1q3AAB1gdAu70lRQVMHAzggXjXOdRmHHEN
	EpFWqiViPWKJ/IzGpQuNUVS6f/QiKrfNcJV1Lg53IcStgfwLXFkT9lH9XpWZJ8Mf
	UCPANLA9UBmbA506cYnFPpBcOn7Lm2psBic0ycTbN/cZw0SbW7Gx20/SxDOCO+TK
	gHmb68ou8apeU6Q15ZP6mg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8wvuq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Mar 2025 20:37:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 527J6wRf001246;
	Fri, 7 Mar 2025 20:37:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rpep9qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Mar 2025 20:37:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OpSv3zTu12I79pFXfWfYzg8bK8aZtlW/W2ILXmm+fovW1PA1imw+vvCsluU1rYIXc7c8NHoSITp9O+5X73r3gm4jFqGRHu4FCuFK2EF7RBl9pOHBLjLM9nG4KH1vhy+mTGv3SN2zCgsPZL78ePuNptb71xOrkZNAtPA60PojKZBKZlQKNtLguLqqt0ANa3NlFh22RMvp5vLPTgGNv+IZh+60AOPrVMDAo8RanBmvDm2R5wbf+Wmy4hFFC2h6LEE/KEjZXwHEbiN6846Mn4jWCch8R19bTN4FSuMjau9M+Gk3CgFUsvHNhGkb7sp6A0csdjpNQl8UxmwG8619PVWJhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/NV2pQh1Wef4bfndzaaCJ+2Cjhita0A55PvE4Ep7xE=;
 b=Hgy/7HggEucqLioQDgkpoK3eKMIU9pX1AvpeI8Y8lg8VDF8saeV3/mbKp9O0wNYjrayL9/SbXVtbjTF+FiFPFVXbb+LaLjEEWB607+V+qTCghnCQbXWhrUvc3McUBUPdXooEQaDTlTG1BTmF8EFDnphNd7Wpji92Tg0VaOgdh5gy1sYtDy3IK+zuZLa+6zeoXe8uJAlWdLxCb7F6wg8y2Ckib0e4ZZmLUMGPJN98MqSTvMA9vtI1CrJd6W9Xe2FjDDrZMBmUWP+fMNxvkVUPQrPxWWheKQa3T2Nh2GPQFt7kG0BYRU1/lHjPSUb116PzD7x6zMZngwu6wyVKRpC9jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/NV2pQh1Wef4bfndzaaCJ+2Cjhita0A55PvE4Ep7xE=;
 b=wbrVmXcwKNEpsijbTDKxcQtrRfUAXfJ4XKqwb5RcMcAwCn1atdadlzXf6K1hJEfudPpa/6ZyiYHhUyLbVrfh2QTAzGX/EdG/c7Jhb9Vyufjgi7T26nFuFfH5lukeB7Gk3pYGNomDfFxckoUfBvmuDSXZ/qnD1rfUfJJ0ud2Crvc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7833.namprd10.prod.outlook.com (2603:10b6:610:1ad::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Fri, 7 Mar
 2025 20:37:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8511.020; Fri, 7 Mar 2025
 20:37:52 +0000
Message-ID: <f296547d-7a7c-4df5-89e2-9e3cdab546f5@oracle.com>
Date: Fri, 7 Mar 2025 20:37:48 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_{admin,repair},man5: tell the user to mount with
 nouuid for snapshots
To: "Darrick J. Wong" <djwong@kernel.org>,
        Kjetil Torgrim Homme <kjetilho@ifi.uio.no>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
        Andrey Albershteyn <aalbersh@redhat.com>
References: <20250307175501.GS2803749@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250307175501.GS2803749@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0052.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7833:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dd0f033-f4ca-47a2-f8c7-08dd5db7eed8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEVTdFVweG9vWkhqTjBDS2VmMVdLaW9ZYU9ETGtQc0tOSVlsVnFRb1RLbldN?=
 =?utf-8?B?OHdSN2x5cEplZy9IaFBqSGNHVnFmTTNSQ3NwemNlUmt6dmdMZlU5aTdGdDY0?=
 =?utf-8?B?OWdQMEZ2REVKcXZ3d0xrdXJOdWZTQTVxR0YzUEFZaEJDZkdxWFFzSno3SThT?=
 =?utf-8?B?bUFsWkpiT0dyTFZWejRKKzkvL3o5YndDMktnMXc1WlNPMVZoMy9kYS9YR3dU?=
 =?utf-8?B?MFpuK3duY01TMVhETXpNdFpCTmpSazg2bGJBRmlaeEJ4QmRNbUNHSkc0cEtD?=
 =?utf-8?B?NzhHeHlFcU42TnBNR3ArUzM1TWhxZjVaTzFqbFBZbm5qSHVzMENsZWgrYkFv?=
 =?utf-8?B?T2JZVTc4THE2RzN3ZVk2anM2byt5ZHhrdVJqek9ISkJhL1M2SkF6d2VvbU1B?=
 =?utf-8?B?Mlo1QzM0Z1FzS1QzMFlKcGo2a3JDVjZSVFhrdXJaNHIwZkNaSXg0QTduZjdT?=
 =?utf-8?B?NDBwK0xEOWJGWjczNEZZUi84K0kvK0xpK0crdTh0YVo2V2YxK2pERlE1eUVx?=
 =?utf-8?B?c3R0dzNKWnZ4RWVkNis4TmhYMi9MVzhielJOUmxUb1ZyOUZneklwdFNXZ0Jy?=
 =?utf-8?B?Z0svcnJ1NytQZ0VwVkRZcEc5a3NzZFNyUDA4M2hPN080eFBkanMwUy95c3Vw?=
 =?utf-8?B?c2NwYlI2RmdGbU0rUmFvejdMQld5Yzh6d2lnblJpZlJQNlA4TkFTZTdFUnZY?=
 =?utf-8?B?SVVaRjFKWFFOYkVrVlhhZDYyRm56c3h3aFVYSUZXTEszYjU1eTFRd2xDZ1N1?=
 =?utf-8?B?cWFtME5yeWlLMXpPL3l0aEJ3NlBESkF3NVZySEJxS0t6TTM4OVpRbEdFbjJZ?=
 =?utf-8?B?a1BadUozbkpTeThzYzRkY3UzQUtzejdsMGxZSTJ3S2p2QlNITEVJRFRlU0Rx?=
 =?utf-8?B?cTUyOGhKbXU3SFlDOERaVVFvekJ1OEQyRmQ5TWpnL1VHbVV5elFCZnRjMEx5?=
 =?utf-8?B?WTBtRC9raDFwa1pORzBJN2VYR2h6Vm14YkMzcVN1aWhaVXIyaDBlSHFvVk9M?=
 =?utf-8?B?UzZ0OEF6WTQzSisyVWM3dVc0MzBsU2NRNzBzWXZadGx5dEs5VFRsS09pamxC?=
 =?utf-8?B?ZjlhMWxVTzBoZGgvRG9FeHR6cXVsZjFZTXlIazhjSElZQ2RwUm5KRU0zQTN5?=
 =?utf-8?B?Z1hjeXJiZWI1bjlleFN0bjNtSTF3T1B3M1lmMVBXcklKeTE3ajQ3NGtqRjF0?=
 =?utf-8?B?QWt1Y0lZdlZQd2dreWVEOXNQNVh0aDhBYzRyNW5nbThkbmU1K3hyaUNZT1J6?=
 =?utf-8?B?QlBvM05RZzB3Und3T21FUkVPQjd3akd4WWkxeC9EQUVIcnUyYmZVREJhSVp3?=
 =?utf-8?B?ZUFnMkdZTndsUXJudHBkVzVITFREdTVNSFQvVzBTaWVWZ0Z4L2NKeUMvR1BR?=
 =?utf-8?B?SnRYOVhMc3pKZmlkUzN1dzhXS2JMRVFSMkxkZUJEMnhsM1I5VkVaR1BRUzhu?=
 =?utf-8?B?aWN4VzdhUDBtQVpuNjRKRjBNeWlUNXMrVEk4Tkc5ZHhDaWZnWHVHS0MxSnBC?=
 =?utf-8?B?VlVaKzBDRmdTUTVveldSQlZlMjRSTFd6L3Q1ck5aZ0ZvR01OT3pDaEkwVU80?=
 =?utf-8?B?YTl1eGl2cVRiWU1DRTJPS2ZDdWZYTGlWanBaRFNjU3hQU1VaTGwxSVNBc1Bt?=
 =?utf-8?B?YjJ6b3JoU1YxWTJmSlM5RTFIbGpQVWFGMUxUZHFLbHFPcU9RbFdBWWorZ01H?=
 =?utf-8?B?bDBUWnJkbDB3d21oQzVjYkw0enlQTFp2S09mUGY4d1VKVCtmZmNDMURFeDJW?=
 =?utf-8?B?TDFHc3VFSGJia2ZCVXJxeEE2c1dTeW4yTFVkZzUzSURldjM5SzEzTTM2cC9s?=
 =?utf-8?B?Z2hYaUZSd21WaGwxWTc2T0N0RHA3SmdneDZrMnBYZXpUaHBzV0tMblZleWtn?=
 =?utf-8?Q?gdnqgCL1Dm9wO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OU1OQjRNN3duU1ZCWnc1ZlVUZFZDUFl2K2d4bUdjazk1a3JnemFiQlpkV1FH?=
 =?utf-8?B?REUxaUt4RmhxMEdyOVB3K3hsMWhKMWdsR3FQSnk2V0N6WFZQdG5NUko4a2M4?=
 =?utf-8?B?a2pPLzZORWNJa1pWVjNSVVVtL3dqd1BoWnZnUXhwUWZ6YXlLSGM5cWxiQ0xX?=
 =?utf-8?B?S3NUN3RZZm9sWW1tajg4bGN5SGNuSDF5Q2RsQWhRSm1zL1hPbmlmQWVnVlA0?=
 =?utf-8?B?MUNNMEpESWt0QVMzTVhjYTBidHgwZ0NyNExUUWZjUDFnOVpBdmhudEUvbVgw?=
 =?utf-8?B?enpRWmFhRS9nOGZ3TWlLa1lSekY3elVHcTlxWkpDYW9FcGc5OTVqbWxLaGpa?=
 =?utf-8?B?aWNyZmVpNVh6LzE0Zkl2SCtLd0FPdnFVRk1MekZpS3ZaSm4vc0w1dzEvREpx?=
 =?utf-8?B?MWw3VUlPTU9xSC9uRTMrdVBzL0NrY0FIcE1vNzNkdGthWUs4R2tFaHNJUGls?=
 =?utf-8?B?Z04yUXZ3SHVqZ0RuOTdBR2s5ZzdnSDJNamdtWTRJT2FWbWhvbEVkSUhtZkpI?=
 =?utf-8?B?djR2T0R6cmpPVW1udEtseUt2NVJFc1VZcmYxMHRyc2NEK0ZjR2o1eFc3MFN2?=
 =?utf-8?B?cUZQc2p5cHFTSUsrZkNMSzBpeG02Tk02VE9PdTJ3UkF1eTNxNmFrc2V3ODJ0?=
 =?utf-8?B?UlIwcDQ3TUdrcDRyMTdIbVhQT0N2N2lSaGNUQ2xrank5am5EWnZCVkVGRzhQ?=
 =?utf-8?B?SXhka2sxSnFxamwxcDV6UThSV1dYVmJjU0JDSnVGOHB3aTdPTll2c0ZhUHJT?=
 =?utf-8?B?M1Jlak5TaWxoYis0NVVPdGVPMW0yUU04RFhJb0tHUUVmaFRHSHZKZzBOWE5y?=
 =?utf-8?B?dTRiaVhzR2JhSDRJd2RTL2dNL2kveXpOcy9lbE5oQm1MeEloM282MnV3cmhL?=
 =?utf-8?B?SmNIOWczc0JMUHJTNmc1MzdZNFlrTFlVMnJBS0IxdmlOV1Blam1TMkNLVDlV?=
 =?utf-8?B?d2NFenU0ZGJKejBNaWYwSFdMZjZ0SldGN01MWnAvYzc2M0l6cExxb3MrRDVH?=
 =?utf-8?B?OWdnRFV2UFJZSzd5ei8zRTlvK2hML2ZXWFpqWkJtVUMzeVd6N1E5MHFEM2Nv?=
 =?utf-8?B?d084YkFVK2FKNTRSRWcyeHc1Q0N1OWdManNzZ3ZkNTIzUmlHaUwzUWxKVVBS?=
 =?utf-8?B?TnN2T3hPRlNYVk5UVWFMaExMdlJZVURQZElXYVB4akhGeTIxUDUxdFlZSnA2?=
 =?utf-8?B?M0FmQXVGNnZ0bk1NQmNlakkrZ1NHUVpDYW5rVm9qUjRGYm55Y2d6Q2ZDS3dH?=
 =?utf-8?B?azREQm0wY0dseHZuQnhCd0RZZTR5Zzc5blhqeTBOeUM0QXFDNkZ1OTU2VGM1?=
 =?utf-8?B?b05UTG1iYUl4NXZFbjRKOEVvUHArVmpXb2NpN2hTNlpvUHlPMFU0Mjk3bCtF?=
 =?utf-8?B?SGN3VEFDVDdLUEhCbTZRaDhLV0RPRHlHMElmbEtEUU0zaDFFclR1d0NCbjhs?=
 =?utf-8?B?ekVCcGxSWkhNT0oxenU3amQ2MW51YjcxN2NlcndDYVFwUVlNMHQxbnh1NFhM?=
 =?utf-8?B?UllIeVhlelRMeUVMb3IrRkg3Rk9zazYwQWo2MHdiVmh2Vy8rNjVVUFZnclJI?=
 =?utf-8?B?blJEV01ZS3E1R2VFZlJLRlVBTVZaaXdBUXdmbDVQZThOODg1d3p6cDgxeWVE?=
 =?utf-8?B?RDFlYVl1eW1pR2QxaEpWSmVjNTY2Q0Y0ZTZUNFhFdjNyNmd3d2VFQnJFRVdV?=
 =?utf-8?B?bWY3STcvUDV5eFJvalZrRGdhQjZCY1NoUkd0Z0IzVXkyMm5JeE0xOVJCazZM?=
 =?utf-8?B?QlZkMVFqTUxJQTFJUEM4WDRqSXRYTzhoMm15Rmd5Ky90NnA3ZWNmaGltWVFw?=
 =?utf-8?B?UVJCQVN4dEgxbEVRM2Fhb1UzR2hzMEFsbE0zaXZ1cWorejI0VTQ4L1ZrYjcx?=
 =?utf-8?B?WUJ5MGdNK21vMDhFQUE2QTBKVU1PQnlrenZ6RkdUalJxaGhzczdldjA0bmdo?=
 =?utf-8?B?WXBSZVZGRys3dEprODJXczQxdFpUdEpvakpneFFyNkwybFNIOVk4MzAwMVJ0?=
 =?utf-8?B?Z3hJaHZjZGllb3BTYVg3cVhjcS9GU09JTzZOUG0zaHcvcWFBZUx1V2I1Vkow?=
 =?utf-8?B?RktjUGpOeVVZZE9vaS9wTUEwdDh5dnRlTTg1bTZjMnluelJPNUErVk16blZp?=
 =?utf-8?B?YkJMRDdTRnRsZWF6aXJEQWoyR0lLMWRGZlExVGdYU3pnallEc0NUR0tNNTBJ?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PuxjvTEO0h1mzAkY81KQeTpQTXGlUjEIrDDySEV/YcMrTcAGc8kgYjAgeVJtj8Dqo0zTHsRn3QJCQtFde6dPj4L8BgNZTSNePsR1Fd5R+YE6I4L+kHG2rs+JXofBmxFVmIM9NaoyU4YEdeNv8pvM0e3PEBUouhXFsJkwbUQvM4IK3zDZxViNFXzXQpIaonqQDX3dEO0Q22TAcnATZYqA2Fp9Pat3sBSXnMISDBwW612mJefrocrLiEWxhWc6zZPlEH326iG4OL/frZDNBkKMDw36Zbnum95LjUqkqQfp2nfmtOGOOuYVtxaGPiT3JenY7gEQgK3OliZI7AE7aIsoQ/CMzBHYF80ANU0vU5wiXBmP1FZv/uO+HDwaj30oHtxPh1qSQdBJAYBcWD1CSuWrNOdTx+DnXc22HswUMaM0FtAvsdfmy3gCGDYkd2xVQjGi4lUtQ9z8Pc9mspYlYDuoHjUIMqOzzKGPB23ATWYX80a2TwqFbAjsFPxH+nzIxSWmtyULQpagNFkojsUZXW83+I9Ik0pgyQY+VVKMwjux0irw4W9qWdgoA9MrmK9ZSYw8b0ZSCMovGha4HxTHiJbqipQ+wKi9fcy/HZ3JF0t5Hbw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd0f033-f4ca-47a2-f8c7-08dd5db7eed8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 20:37:52.6613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e3xkf7BRyDojVk34Uw8WKD8vVVxCUC4hEVe1LZ4VOKqPwojbkzFoHT3xgGk7GRFZsNmjjJv4TJdRGoDooUT1Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-07_07,2025-03-07_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503070155
X-Proofpoint-ORIG-GUID: eIrgovmKREP9TPRXe-dcBVfXL4krQX1o
X-Proofpoint-GUID: eIrgovmKREP9TPRXe-dcBVfXL4krQX1o

On 07/03/2025 17:55, Darrick J. Wong wrote:
> +"re-running xfs_repair.  If the filesystem is a snapshot of a mounted\n"
> +"filesystem, you may need to give mount the nouuid option.If you are unable\n"

mega nitpick: it looks like a space was missing before 'If'

> +"to mount the filesystem, then use the -L option to destroy the log and\n"

