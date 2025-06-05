Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93970179A3;
	Thu,  5 Jun 2025 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137247; cv=fail; b=QLAJTuZwtYWgNI2l5uato8jRB2KetSrZTbTduRJSYX0LYsPKJa2T/vnR2FByKbyvOVMPwP5mMyjXtEsTZHCIMhni9yJYeHUydAq2s+Y7OW+kjh0i3Aet3qRub8+mtUkuabEF6VZIGri1Qy9mJbtmkEGlBIHA/zUTLVOQiXLn9Uw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137247; c=relaxed/simple;
	bh=QRV0oc8TUw/jEKI0Wd6tuOUFN/fWaIO9ZEaMCs0HhRM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LeDk2HEuJMAXX9+XCYrojsWaSLZKa97VsLVZWAThNm0tqdJCr2Mcz1Q+ULIybtLcS0R3QbmawBEemO3ypgn1dghcEOMQ+5jVwIU8xE5DXlbZiAaxBQ195JqCcB7W7867s9a+k2heYsYPYXqlwIa16JSI4W2nvLPFeLzHK3QMVo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L05jWXRF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kPalMeJP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L05jWXRF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kPalMeJP"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555AtWIt007467;
	Thu, 5 Jun 2025 15:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=N/7SLSf7MiyF6xxsSdRJM4ztnqd4/igJ6f71EUR3FIc=; b=
	L05jWXRFKZsgd7SwWO+jNnY1UnwaD7qf8ukCAwqLjlYyKGNkpuekjs5puVm/P4hz
	HJqMpgHXOLzze/ZyDoi4j6z2uzrLU9am6BtpW3PwKcTcpWuo7+kfGsNGwubAIJia
	k7AnhKcaqtSFSfXNnX03JN5iR9YZtRxcuaTLrmys0lZoW7CyFsgWlGkoCsFBwtAJ
	yQesOWIxinjcmbUzoDYfa6TT1ZKd7U/lI9QLsDHCYGNuOX951HuyeFP6x0frzrLL
	X1ysRDoAC7QyHnAoRQjSlMTiAmoQvAPZty/iTlMAtlHWnH+/9/JuVoUpkFd5QPdR
	o8ymWvI6FOwy/gQT78AAqg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8bpb3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:27:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555E45d1016123;
	Thu, 5 Jun 2025 15:27:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7c7n2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:27:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c3BbmeOWwiIGwy5UfyglRuNPO7ZWy1SR1H4qSPsjSSBQH7PSTRClECW/rmJQ3cKBYH6VJ7RVZhKUhQJUZzJ7bKe5sPu2KXbWuWv5X5FI54FJjhX95vPOzOTLruks5vwqTJpQxk4LGMsaXLTGhBUmLKO9NhJUOikuTIYdLv4dQQ3NjaI8fUYE5PGXuabr/NLcvzsZz09vx2+PPerXKIdRHhHPt3ao4fVQCwcl9Fbdn58VqZYhIhe++NWeZkCyLWQQ0STDK9nlvy+Vw3VcYY1WxBa0dWVnvVFGooE3eOCl6oq8QK3hlm+vObkU6+op7Lju0cPNBNxyUKAA6viGS+6lRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/7SLSf7MiyF6xxsSdRJM4ztnqd4/igJ6f71EUR3FIc=;
 b=b9eXKg7o5bPOqbQZ1U4eKXOCRT4Q/DH26eFHucEQ6xTlRpirgz8Vpk/sB7JQ4kIyV5jlMPma9SBkW4KWR+MF9cWaXQMLucwEk0cS1iKMIJe213NmwQicCdlUessYUWRHSTQro2oSQc0rEdOKyBJqnZJLG2gnYg8iix84lL+Dx6fHikslzFP0zja8pYZq2oSOFWpNMlSVf+YlMWO1PDng7jsQ33H9nmTeiQSCMmmmtFAVAV6y96LnCmyIpYaS6pjSc4lK6OhzUN/uymVznOstm13L1B62B0sBgJjpkybtwslhJ4E21CFB80ILRvjjvWVuCs507iV1d/vGX0u4n9OHEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/7SLSf7MiyF6xxsSdRJM4ztnqd4/igJ6f71EUR3FIc=;
 b=kPalMeJPNHOKY7hp933kyTXTCItEqC3R33DX3kRXjFZvPrlJ/JXajOU0jSgVO93ZNNP6g1Ib2UpC6QV29ybPHPVoMGFqP7HsjsY21v6rVWot43Y7D4CcD1PD1YC3E8U+h7+wGEl/iAB0GU1PVoh6ff6y3Tz8ng1aWIr1tl8Wpgk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5099.namprd10.prod.outlook.com (2603:10b6:610:ca::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Thu, 5 Jun
 2025 15:27:17 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Thu, 5 Jun 2025
 15:27:17 +0000
Message-ID: <fc587ef0-bd8b-4336-8425-547fc9d1695b@oracle.com>
Date: Thu, 5 Jun 2025 16:27:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] generic: various atomic write tests with
 scsi_debug
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc: djwong@kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <20250605040122.63131-1-catherine.hoang@oracle.com>
 <20250605040122.63131-3-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250605040122.63131-3-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P193CA0025.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::30) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5099:EE_
X-MS-Office365-Filtering-Correlation-Id: f958f585-ef73-496a-4d3f-08dda445746d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YjlqcWpubXczMXRpSzFKd3Z4Y3AxdUltU29KY0E1T0hoRW9QMTh6WTVxOVVP?=
 =?utf-8?B?a0dLOEx0cUFhT2RpYjJGUVcrd3J4anhaVjZ6RFo0TVBNa3hJWFZkREZIUVFB?=
 =?utf-8?B?UFh4VWFlYnJlNlZ4TzduWVJYeWpOay9IQnovcC9hUE5mdE5xaDNlVTQ3VDZS?=
 =?utf-8?B?OVpOaDZWR3g5YW0vS3Axb1lDMmMyM3EvK2czRER5NjlpdDd6dFh3WGpGQlMw?=
 =?utf-8?B?WTVvUkIvZk5BNHlFeEpZR0Zpa1FIS2NDMzNiL0MycnRMcEJJUXhMY0JBd1FB?=
 =?utf-8?B?d2FDcldBcHJNbW1mYjdSN01waVBJMDBlams1blAvVWk4bklhZVdEVjRsSkFx?=
 =?utf-8?B?QldvVjh4bGFlOUdHemIvb05aMjdXR1lhZEU0Q0pON3NDMVpPNG5pK01MM2da?=
 =?utf-8?B?cGoyQVIrdHhXVk1NQ0tjVEU4WkFjbUhZOTBmN1ZsQnhJUkxpdXpQRS9VSml1?=
 =?utf-8?B?MEErSXlMT0tMTG5heFNaN2ZRYlFKYldHZEUwV3o1cXRqTjVORld3eDVqN3Ir?=
 =?utf-8?B?c1kyN0VtRXdLYmJPbm50UjRwMnQydkUxeE5qODJNZjduVEtQdjFyVms4cXdy?=
 =?utf-8?B?U2Nia1dyeVY2YjQwd1d2NVpnMVZ1Z1ZCdjRQV3BSb0JGaDZQRmNTSmtRK0s0?=
 =?utf-8?B?dnZabWpDS3czRUNVQ2RoSGNLemNyR2w3cDVoVk1yUlpQR0xMSlNQNlBTLytV?=
 =?utf-8?B?UGpoNWlRZytYMHNpTnZqWS8ybStuRUhhaHBlZDBVTEVJL2JRbUFza2tJWkVJ?=
 =?utf-8?B?ZzJmMVl6b3BTajNWM0pqbGNOOXhoRXlSSEVBWTZrUUlIZG9IN2hCL0l0V0dm?=
 =?utf-8?B?STFzNHRJcnNWY0F4R0NtYXpEQzNCNlZteFM4Vm9ydUMzMmpCZFBqS3UzRmNi?=
 =?utf-8?B?WlNKeFFJZERoUTdUL1A4WmtRaVFZVkd5cndiSy9JRUJ3SkhNVitML0M0MU5K?=
 =?utf-8?B?WUw2dGwzOFNTbS9RT2VsKzhvMmZEY2RaZm1XYXFpaVg1Y3JyZ051UUJMaHIv?=
 =?utf-8?B?NDcyMG1OeGZlOGx1M0FJTVBScFU2azY5YU5LaGJJMXdtT0FvbFgvWEZyRlZl?=
 =?utf-8?B?cGdaMnZtUEFFODNGbCtTYU5ubkZmcFF0N2JzV2hVSGlXTlhTMU9LbUlRSFpp?=
 =?utf-8?B?aCtuY3lZbXV6NDFBZXFnUVk2a1YwT1ZORG1SdE1zbytMaTUzT2dOYitBTHhM?=
 =?utf-8?B?Q3FvL1UrWjFEbUpORW5hSzdWU0pianlUWG5IUno5TW50YU1TWUkxdEpBdWZD?=
 =?utf-8?B?OEs3c0w4cTRaQWdDbTNSTDRVTUZDdTBrdzhaUU5jZXg2SkNXNEI2OWx6YkVy?=
 =?utf-8?B?enVEN0JkeUFwK1MrUDR1MVhtS2hGdHdZM0dTR2VybUl2UnkzVkNxeHpCRkdn?=
 =?utf-8?B?TVozOXVKQzVqdk9tdHNqMUpCdXFBREZhSG9SbU16TDY5cGxoc1F4bHh2bFNL?=
 =?utf-8?B?eWdFQjNHeTVaSFFaZlg2aEdjOHN5a2RRak9KWHF5QXpMN2dheWlhcmlseWZp?=
 =?utf-8?B?SDVnZWExdzBXd3FGRkc2c1NsbzM2MSt6ZW9RN3BObVorM041c0Fob3FtTlND?=
 =?utf-8?B?NElJSkV0OERXRjhzZVNJWmgxU3dkeStkdGtHaVBqUmk1MElHSldiUlFYTXhJ?=
 =?utf-8?B?STJDSEloeWlxNDBaeHc2U1MyY0ZtS3A3cFdONS95ZS81bXF1Sy92RXExN0VR?=
 =?utf-8?B?aFJwb3ZkTDBRMW9aeGtGejNmRnQ3LytRSWhUYUpYbnZKWlFTU1Z5eXZXZFJB?=
 =?utf-8?B?RzBQekExY1hKVDlyVk9xSmtkd3JkemcyN2dhcFlDMlM1TVlkcy9WQmFJaW8y?=
 =?utf-8?B?Wmd3cGNNdU44T3QyNGtSdWVha2J2L3prL05nNmVKcHJocElsOW41ZnR0Y3ZL?=
 =?utf-8?B?cVQrNElRZW5ocFIrZ0RDeFhuK1I1VXAvczlQTDJiZEZFNFpqR2RKNkQyMmxp?=
 =?utf-8?Q?j5fCCYmIujs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlVxbjFNT0hvQmFWalZ3K1hacEU0WWxCUm5OTnE3QjllTUlUZlFlK2pVYWtL?=
 =?utf-8?B?WmtXSXFybnk0ZE9pSmR2NlhMaThOTEtwSWlvVmc2bE1ibm45bVd1SU1kV2V0?=
 =?utf-8?B?MVlUZk1YUnBRaFpHS2lDZVhKbGdjSUtRUEZIOFR1YWxkY1huUDk2TFl1QmU4?=
 =?utf-8?B?azUzTml4QUtkaTF1NzhHVnRjVGw0T2svcWFkZXNjOGRTZFBTNlpXeWg4aS9V?=
 =?utf-8?B?WWdBQlJWWHhXcGl4cTRPN2g4MlArSlpkdy9PSUlFTUhUampnakJXQ2NIeVBo?=
 =?utf-8?B?UFNyUVIyeW9oRXp6bmtEWjgxQmhxbXBreCtOaUt1MUU3dXREaVV1S2JZQ2FP?=
 =?utf-8?B?ck9LdDExYWJUYkVNNE1WTW5SOFA1RDFjelJtVy9Rc0VNVXB1ZC9HenJuWjR6?=
 =?utf-8?B?ZlhxY1hhZEd1cjd5eTI0c1VMQUxBbzNuUmlZL2xDMm9XS2dvUXpZMDNtM2ZR?=
 =?utf-8?B?THl0c1NNNHR1eFZqOUhzaVJ0UHNsRTgxR2JHOGZ6TnE1eWlyblJ6UG5xeGF4?=
 =?utf-8?B?ZldHR2M3eC82blEvNExDVWR6a0Y3cDlzOTVEUS9EM2NLd0NaaW1ZYmZjck9h?=
 =?utf-8?B?anZZVkZrVFY2RWdBZE1oQ3MzTmo0YlpUNDNUeTdVeEM5dEJDMm1ZUXFjeFlU?=
 =?utf-8?B?U0pPYmk4WThSL0lVbmVCbE1VZFdRWEVLditSVWgrVmdGdElRYkRlMHVwUCtl?=
 =?utf-8?B?M284UnM4REQwenZtRkplbFNGbXNvN1FRUkx5bEJiM3EyVFpaQkZhR25PQ29T?=
 =?utf-8?B?MUpEWDlxdWx0V0dKSFFJc2g4aUs1WXdkelcybFVDbkNxWkNjS1pzL2hROTcx?=
 =?utf-8?B?bVR3UWFGNVl5WTUzR2grbVk0RWRKeUZaLzFwOFVwZlRZZmlJUjhkeUI2Y2Z2?=
 =?utf-8?B?UEpqTGVjbmx1ck5kLzVpazdkNzNVWlVscHJMSit3STNNajcvQnNiR1F2WCtl?=
 =?utf-8?B?M3FPaFVYSzF2Nm56SUNkc3ZZbjNxVzJpbGw5TURRbWU5bVdZSjl4NFNuSVhk?=
 =?utf-8?B?SmoyRGIwYVVyUmZSZWFRQ05RblpIdlJ2SHZmUjdzNitkQ1MxUFhodGk2S0p3?=
 =?utf-8?B?M3NkVEY4TzZseFNFc0FDVEl5RVgrZlVjY1N2ZGlBKzlkenFONVRlNkwyR1pz?=
 =?utf-8?B?YzExMVVJeU9aNVdlTVJiTFRkT1JTbTFEbWpudEF6QUNGcUhYdjZJOUhkQTd2?=
 =?utf-8?B?RVo4OGsxWXRySnVGR0tZbGRJUkFhdGRWeDM0WUsrNFNYcnhiR2xReHEwbTlJ?=
 =?utf-8?B?MGM0bExpbkF6d1BlZ1RCTHN6Y1FvYjZFT25kNUdkcWFCaXRGQ0pWcnZnN1B0?=
 =?utf-8?B?RnQ0NlR5RFRhaVpHcHgyOWpGZ05vUHFOdENYWGVQM3NjV3JLVHNkZ3IvZWpV?=
 =?utf-8?B?WC9GRjRWL3QvZGIvMm1uTHlTZzZhZ1p2ZmxiczIvSlJOeTRqcm5vSCtCQUVT?=
 =?utf-8?B?elR1NG1aQnBqcDcwYTRXZVBLYVdPM1gxMWlMNVNsMXNNVEV1cXdtRFhsTWkv?=
 =?utf-8?B?UWFmUE5CbEVsMnFlUHFCbER5RlYreGxjaXVUTjh0ZkJDUi9Gd0lRVHhzOGdG?=
 =?utf-8?B?dEx2V3BMNmdWcVcwc1l1S2JtSVNEYmtSSG50V0dwbzV6M0c3eVZITE5XRTRr?=
 =?utf-8?B?Wmp5ejI5dDExamprTEllUnF2dEVVQng5RFJhTkFjVzVtZlZJM3pXUkhFRGlm?=
 =?utf-8?B?bG53WEErNGVUS1hYaWlhNDVwVUlMVzV0eHZSVnYrczE3K2EwQllPYW1wakxP?=
 =?utf-8?B?U3l4NTg4Vzh2aW9LY3c3RVdEajBLckZEczA0b01BM2ZGQnhNSEdNWVpFQm5E?=
 =?utf-8?B?MU55cEc4L2RtdGs4SWNWMW1WQ0VZRTY0M2E0OWxRbGRFK3lMaWNEL3YyaDRs?=
 =?utf-8?B?LytZSStRVVBhYU85ZXFnQzcrenhmWElVV2o5ckRKak5iK2tRZ0tyMEl6RDBD?=
 =?utf-8?B?UDFES2JsUHVFUUpWcEYyWFlYZnRwcERybCsyM1BuR3FtMVRLQ0FCMkRkZjRJ?=
 =?utf-8?B?MjZyeVdBVlZqQnlzL01HemFiQ293OXY0WENOVlFEUjJLSytFcXBRZTE0TGtV?=
 =?utf-8?B?Nk1oV25QSmJqSlUzcVJvUCs1cHNYNWxRVTRQb29ZMk44dkNYTy9reUJSQ0VY?=
 =?utf-8?Q?p6xrAHXuxo8XfWRaDbrgbw+8g?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rbqH2PousTgsTsKUdQwq2IsZYbI9ooDeFFpa7L+BITFWEl1bvXFWtjThbWEgm1WTS80ffxbuo/lQK5Cq4kSHFCWJYMN53yXZoO+G8+Fp9uEd/oHTR+jB4ABy1Xjc6kDliDqOZQLr2SgfCHaFUSNxFxorUusRThvgwhsT7/HHyTJlbZiw3Yr7CV4psOG4hc2ioqKDP/ZkVNY/tg+CBi+pIRNhcKqXJqueWVtqNPnauDobqhPBfJ12568Rz9BkMrL/l5GOJzaIqLWSk0oKGUXy+UBYsPHfqZiNWxVe55ETrGjBGupraiIKD+wWe1ahsyJA5MB+VVTWwmW4EjEWpzdg59zAbFg/wWK9qzwqCSoCmOQ23I2DWrV3aRLbt6ksKF2+MoH2v1Gw3o3ECDdp8Py5fBPHYLrXEfkGwa1oOTWjY7rypO5XMgKv8u/N2sY/FNaq29DcDmA9va3lO+wwRcHuZY8VxRivmvBL7583wU4NrRjJCzGSjHT6QkoBqf7aNwgoWDM+n2yYtByuYw/3IVhekVgjUWK1ea4yzA+C3nvZ4vYOdAysOhsHfPNAJNKW4SIgvADRIaze8GKwZhS+SpjLTR4NsGxyiEcg9NUzVHI3Y/0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f958f585-ef73-496a-4d3f-08dda445746d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 15:27:17.1844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3jiEgbBVxmrLWsKEoyYAsJFzbN1zX8//gJITel/78S51KvduJokofr6d4DFUsRpPBLaNQQ16BqE3QubhnxyWrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5099
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzNCBTYWx0ZWRfX9zk11fZkL0xj PO5hS8GLXtDL3K4R+xiOH9xzd30dRWd4UPoUw6zRns/APXf7781ice6qmSl7JgY6sBIHPZCe7po C89CyMU68UNollrFxXkwvC3H+h/MEQy3ULlhXOyAPwt7BkLx1jimxfO9OyVL1vGtuyHfDXuFdR+
 6lnJFDAzkPyMFrqSXXX+v8SYpzf1Nynwkj/ewrWXAgXjOeQCj1gJO9ZTNeO9EAOqOXgkxptKWr3 dlXLFEf3+ZQdqdXIlbXLChAVPTS4qfPZPRg1a7WIAHxBs6gWnEdlyolAUyc8EHRPDRLXJgrBoPJ M0r4VKYgghyC42WDDYb6Sr1R/00kUkwbICuoeRYs9QzPdnGBJBSSpH8PXfdsJNkzg4wl1tcoNCc
 WNt2KfX1VFtpiUA3EkYLDuIh8Z3/fHco6BQxVgcRB15B2AdziIWn8++kb/mqNTJzZ8jTiOsW
X-Proofpoint-GUID: WfgEdl7HrkqfzIVRgyatUYVKEEv0_8F9
X-Proofpoint-ORIG-GUID: WfgEdl7HrkqfzIVRgyatUYVKEEv0_8F9
X-Authority-Analysis: v=2.4 cv=H+Dbw/Yi c=1 sm=1 tr=0 ts=6841b758 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pdeSVrAIm7IRPjHQvZAA:9 a=QEXdDO2ut3YA:10

On 05/06/2025 05:01, Catherine Hoang wrote:
> Simple tests of various atomic write requests and a (simulated) hardware
> device.

There's > 400 lines of changes, and a one sentence changelog.

> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

An odd Signed-off-by chain.

> ---
>   common/atomicwrites    |  10 ++++
>   tests/generic/1222     |  89 ++++++++++++++++++++++++++++
>   tests/generic/1222.out |  10 ++++
>   tests/generic/1223     |  67 +++++++++++++++++++++
>   tests/generic/1223.out |   9 +++
>   tests/generic/1224     |  86 +++++++++++++++++++++++++++
>   tests/generic/1224.out |  16 ++++++
>   tests/generic/1225     | 128 +++++++++++++++++++++++++++++++++++++++++
>   tests/generic/1225.out |  21 +++++++
>   9 files changed, 436 insertions(+)
>   create mode 100755 tests/generic/1222
>   create mode 100644 tests/generic/1222.out
>   create mode 100755 tests/generic/1223
>   create mode 100644 tests/generic/1223.out
>   create mode 100755 tests/generic/1224
>   create mode 100644 tests/generic/1224.out
>   create mode 100755 tests/generic/1225
>   create mode 100644 tests/generic/1225.out

This all looks ok, I would suggest a separate patch per test and I don't 
feel strongly about that

Thanks,
John
