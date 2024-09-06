Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AFC1B85F7
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657111; cv=fail; b=ZysfZciT2KRNGRtHOwTbGrV+9e7gasXAN3rbMmW/QjUBPqxgM5Y7PRYl78Zva2unXvvrTzAMVkJwTlDrfAjRtjtUU7A4T/RwhF9s6s0poQKUpbPVUo1oCxtvv2yXL/uRfGjZL9isIJZKP0OQpw8ElIhAaDUM6NGfkXK82vDuPDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657111; c=relaxed/simple;
	bh=KP6Ow3wbEl1AHSlMTIGg+WKU0X0hl9Zpe/lt/XPxfds=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=g4CJ08G9PXF3tCL6ys/FVfE9CmOXXcId6CPlkqa7x1onYp13+CeXDnRKlbDhhFjU4ZbxyQX100CzdrFcGpp2p0SFO4gKxudfi/+vJGRTtZjLFEMbB/kpFFVOp0zR2e581p/HHPOQ23Alm6jgu79q0xpTgpZZfw5Ti/By0jjJlZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XV90GuU9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NSr5kCEW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XV90GuU9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NSr5kCEW"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXYju032665
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:content-type
	:content-transfer-encoding:mime-version; s=corp-2023-11-20; bh=6
	rnIUCHEC5yPJyPP8eizK6G+pXFvBLCz0gm1DaNWiq8=; b=XV90GuU9OzQ0xDMRU
	byPL3/+FdmFJevHN6XtBhKURbvqyHWIOhto9nZ2nOnJE7lprn0ZLjK3sm2Lfqzhs
	xOUo6rUjJ0kLCflAswCdWmK8MTUxGKTelxIVuOfzU+mEN2JmD1R5bh+yc5NNCBpd
	zdC3dwSqDnCJBtlhBFfr0lrY4Uny3SZDbq3NbCLH+WUrfZjM3aqPCa3sl4mr5sxW
	Spbe/4OJ2ENs+NT43Tch4hW4zp10iTxsEA1YzYfhd9xuAGnaTnhYR+ZA/kCGEGxX
	vvRAeQQnjmBx27KX9CAsDIIQrsvrAKBqHKpQBXH5s7H28KigMIf81FE0quCCQPPZ
	y4Ytg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwhjmnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486JldpX016162
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyjeyqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/Bng2ig3MjylLm486Gn/NRa8ycaGXDQRIruBBtrQkZ3LyqIqsFo/wF6P2TYjLG5hL89bXL5AxE0jTh50Nt1B2Uqf0qQIZwwf3WxRNHNfMEo0SPkBgM11VdJmBCEuRfC3MaroUxcPJJQVJo1qYjSYYU0qiJYfIKDY5RRp+qN4J1g92+dZ9V6nfxjVYLpx/uE+/iP89v4seETCenuYAI41nF3iHHDOrzVmbIKvljMfXTjphyXeAcnsYpBk8fY+Kg49Mal5J6oc9RwkMO4IFXkHuYHIUi4Ay47iLEuMMAgRmqO6eEZaXv2+mMQTAeFGKyFoMWlQlOUOrqIv1Ilb+v88Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rnIUCHEC5yPJyPP8eizK6G+pXFvBLCz0gm1DaNWiq8=;
 b=qpkOGx0ok+GOASEcU3ypC+qFxee23JqPlzm1fVnyI7lCUBYr9CyvchhxjtjhSTpsIyH6TwfLLotyDykWfrhczMPr4kiilehPCkz/JikYrAbUrA05n3+hc12YcFUAegj+ypJFgOwgrnNX7arFqWzRO+uy8McjQWSaPcLtxsePMSbcMj67if8T8dNSnnNzRrqQ6YKeMsnTSiTPzyPEkUZwrdkjUEdNg97cBOAgAj87x3i7qaOo7ldqjJ61lrhhmRDSljadTOPAgInjreMg0SM2B7rKM2g8u9lKVrlYEgZiQjPcexODDTDP+x0lut2AwvaTXc5a0LZ6kCtFPvwENdzMow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6rnIUCHEC5yPJyPP8eizK6G+pXFvBLCz0gm1DaNWiq8=;
 b=NSr5kCEWOsfviUHhoM7hGlw75o1vwUKKe5qiqB9DS/wZgYNXfc5usUwTPOnKSJUlu4Oi/UsothoENYdzFzfH+Nrvgp6XONFKON1rWRCYzLf0+NaIoS71pJpFkPvHnmtxrh3GGd0JSHI6EC6N2bg5spo5cDLNptts8/taPGj/RNA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6765.namprd10.prod.outlook.com (2603:10b6:8:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:11:44 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:11:43 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 00/22] xfs backports for 6.6.y (from 6.10)
Date: Fri,  6 Sep 2024 14:11:14 -0700
Message-Id: <20240906211136.70391-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0141.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::26) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: 6788f55c-7006-419b-c214-08dcceb88249
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?djkyMURqR0h6UTFWenVPYzBiN3NYamdlb2FWSnJEK3UzS2daczFuaW10VXJa?=
 =?utf-8?B?dmZzUmZwQ1FZYUVwNUI4RFBCV2w0WjZZYXdESWZsY1JhQnFHMU1TV3pYNlFz?=
 =?utf-8?B?bndGNVZZaUYwSGxPRld2VkR1ZWdhR2c2MjFaaVBmY01NSmgzcmkwVmxBYURm?=
 =?utf-8?B?TDU4S04wZmdYcGZzZStJRXRONDRtaFpjdHVaL0U1VmlyTVJmM3JCa29hYys2?=
 =?utf-8?B?N1hZWDNMa2FhY2FzbzJtRjBubWpvRUttUmpMM3lWcDFiYjlqNGN3c2RXc0xZ?=
 =?utf-8?B?VzFPWXpOb3g5ZFdNVjY3amlvTFFsSWRjSUZ2MjRBTkwySEM4R2l6SjZ6U0hW?=
 =?utf-8?B?M2VyamlCMWdiY2xDNE1UNWQyTTdFWUtoS09pM05BaWJNL3B5bnZkS1pJUzI1?=
 =?utf-8?B?RkUwdW56WXdPb3g2WXZaNDBkTE0rNXZ0a3NobU83cDRxSm5kUUErc253SW9h?=
 =?utf-8?B?ZUVDMEtnNlB5SXdpRGRrVCtFVmRDWlQyQlVFTllUekFUTDVtMngyUFNxeWdD?=
 =?utf-8?B?S2FlRlYzaW56NHFqZnZySDFHVmdhMGhybXVrWE1iNnZFRTZVdW1rQzVhai9P?=
 =?utf-8?B?WmQvaEFxK1lhT3E2N2lBcE1GUm90WmFiWFFJeWc2cE15RTdkNWtIOVlJKzQz?=
 =?utf-8?B?UEtNUUIzVUFSVDNoT3d3TWRwVk45ay9jWi90WG9JOWI2d3FMZldWRStGV2hM?=
 =?utf-8?B?SGJDaU5lWGQ1QTlLQzJlT2F4VzZTMmsvYTlEc3JSSjhYVTNTWSthTkNEQ2d6?=
 =?utf-8?B?d0dwKzhCeDRERjJ6SHZwOFNROVNvcmdHUVhzMmVXR0xDcmF6dHVEY0l0cHRT?=
 =?utf-8?B?MEg2cDRINDVnSVFyM043L2hkd0Y5Vm9XWGJiRFBvYU1VRUlGeGljcm5CZndL?=
 =?utf-8?B?cTl2UXhoaUNFSlA1MmRYTEtzWWpMR2U5S1c3WDAwRWdNUTZ1TW9rNStLOFNC?=
 =?utf-8?B?NXJ3bmlKMjllMzVlZWR6TTlBWnJiVjdrYlNqU2F1ZjNoWktTa0RMN3I4Z1FZ?=
 =?utf-8?B?b1RWNzZ3c3BWL1BHUU1QN2RtdTJKa2wxMXVFZjIyWlNRanExYTBGLzRFREti?=
 =?utf-8?B?QUFVSGZ5YndWRlJ3aGhJb3RFR2xzdERCekxBOWlRT1BhejVJKzZlUENFOThR?=
 =?utf-8?B?U05qaFBZM3AxMDBOSjdUbTh5a0U5VGROYTZhbUg4SlRJeTNwcHNvNGtZbm5x?=
 =?utf-8?B?WlZhMVJUa3RWOU1UVjEyblZXanJrSlZlbWZDWWE5aEJzZDQ4VG5TRFJ3dEJ6?=
 =?utf-8?B?bGJSYkZmNlJLaXpxYS9VcDY5ekhWODY3YWFhRVFzRTdrV21MOTYwTkJmQmxW?=
 =?utf-8?B?UTZRSHpHc1U1RW9zVHluejlzZkFYNlZuQllEdkhrWFVVT3lacHNoZjF0Vkgz?=
 =?utf-8?B?c3BETmxZWEllWWZjcFFxK2RpY3FqcUtMZlBURVpkSk5xZTIyN0lWMzBXY2Ux?=
 =?utf-8?B?bGhpcU85eUllUDFmeExkdGxpMUhzZEhsMStNMlJJTCt3MzBQRy8yZksvY2Rs?=
 =?utf-8?B?eDlSOEVkeU5pdlFDUWo0cDZScEpZNnBqZkg4R3Z3OXBzUkZvTUEwNHFhWU1K?=
 =?utf-8?B?ZjYzL0d0Q2VTUW93ekNGc2tMdUlQM00vajVKajdPRDh4ZjBpRlJuNG1CdGxM?=
 =?utf-8?B?MU9KMTY1eGhOVkNZR2lSbGhvTEZBTUdnVnNwcGFSc1VjQzJPbVRKVFdTODVT?=
 =?utf-8?B?TktKaFdrT1VXUEZxK3R1Z3FXdldFeGhmcEdkSzNsQTVjeXdZcUg1dlpiMEEw?=
 =?utf-8?B?bTRCNDhkL3JFWHY5dU9UeHBCU0MyaTZkMFBWVXFzMGlKUis2T2taMXlSUi94?=
 =?utf-8?B?b3BBNGRuRzJST2JtMVBYUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MlJCMjVmM1M1cEZ5ZnpILzFFQnlyVmF0UEYrZ3RuTnJiRkt6a3ZSVEU1cldj?=
 =?utf-8?B?WXNhc0R4VS9QYTZBdVpHTHNyUTB6UWFNVWNpS2QrcTQyeENBbFhHdzlCaHdD?=
 =?utf-8?B?c3ZFNEk4dzd1Mmg2NHJsVWRGU2Q0ZHMzTzNoekNZZTRuYmNJMG5CRXphc3BS?=
 =?utf-8?B?VGY5SC9SZnhzaDZxMmxMdnMyb0pUMVc0ck5SYkZpamFUVnFvNnNkUGY0WXdI?=
 =?utf-8?B?cGkwVFZ0MlN1RXpBcVJZclBGWGVTSHMyV2RPQ2JDWmozZi9sczJBV0xmZTNC?=
 =?utf-8?B?ek1kVmt2TG0reGJUVHVQdWgvdkc1WCtySlJvdjdEeCtjRk1lNUcvVGdWaitD?=
 =?utf-8?B?dmFvM0lxSnM0WHVJeXVmMnQvL3ZRTFBJemdObFpGQ0E0cUVLQmZiTlQvYjhW?=
 =?utf-8?B?Y0pXRDU0L1YybFhaNWRlczVZdzlxK3c0U2pGWHF1bDdJQkx6Mmoyc0tOaGY2?=
 =?utf-8?B?TVNxNXBXOVVmMHJpTzlJUm9mNzc2ZnFsbWJkVHZBa2t1ek15TWF0dGJTTURo?=
 =?utf-8?B?d2x2YU5WaTI3M1FoaityOTVzR0VGK2xlbTIzZk4velZqdVpMaEFYUVdvZHpt?=
 =?utf-8?B?Vlc4Znl2VU56dGZyendweVBXMkNCdGtKa0h4d00zUlY5bmJ5OGNDVGVmbjRr?=
 =?utf-8?B?MUVRZU9UOElJd3B5QVBhcTRNVzJGZkhLZFJxMFVyZTU0MDc1RGhObXdDTUxr?=
 =?utf-8?B?WFljRHI0YzlMVlZNNjByRmlPZThXckk5ZVV5RGNjejFiZWVoQ3lZRjJHUE9J?=
 =?utf-8?B?bE9CQkROd3Y2Q0VrbHF4UVJnVXFsZzYxVWsrZ3B0SEk1M092T0tOUFRPRy9P?=
 =?utf-8?B?UEt5WVk4OTIyTWEwamFHT3RpK3Uxb2NsTnJDTU1MdG1xR3dzSGhrVGEwZ2dU?=
 =?utf-8?B?V1dPYUdjbUw3UkloS1p3UVozZW5PdmFwaHZpZE9ieEtoaCtobTNQbVYva09Y?=
 =?utf-8?B?SG1QOHNLMjRocndoeXZ4WkRHcFJ5YXIrZGNySTJPcnBSNWs0MHRwM2hmUExl?=
 =?utf-8?B?dTcvVjFoQ0FxdnhyUE0zeGpaelBzUjlvWkQ5VzVEdmVDSDhxUExJSFZhVFQz?=
 =?utf-8?B?TTRPRmVDV2lZZmkwZHF2TDRmNFYweFhCY3Q4MEtpeVN0YmNVeFR6aTNMa3hk?=
 =?utf-8?B?MFpSOTJkMGtpUUpiVGJ6OEpQMk81ZXNWQ3Nhd2VuT1NrTGhsUFdzKzl1RE9n?=
 =?utf-8?B?bnZLSE54SlBzaTlxK21mTDM4R0htNlRGVDJqWmUwL05KWmdUVVF5MzFQOGs2?=
 =?utf-8?B?eDB4dUdMVUdUczJTU0lqUDJjajh0YmZ4dnpGVXVDeTJPNEtraTJDYXh3RmQx?=
 =?utf-8?B?dDh1NkpXVENsQ2RrTzBVL3JNOXNQMm16dE1YRE93NUZHZy9kZ0VsdUlSWjZr?=
 =?utf-8?B?MkFhN0JFUXUySUQvTjZuUllndERMRUJ6NW5LM2VpT3BCbHM2RU1TbkRLdUlB?=
 =?utf-8?B?Y29uc1NFYWszb0lSUkZRR0RCZXQ1dmJVWXpQMzRabml3aGVhTTlVRGJCa0RJ?=
 =?utf-8?B?Yjg3dGdjMWtOR1VtYmZrc3RxUTlsK3h1S2JSRUlFSTR0SUEwUFIraVZ3d05j?=
 =?utf-8?B?ak9FbXp6SFpHVTA0UnN2a2RLTmJwb3hwWlpOMi8zSHFjTXdTRTZ6RUUwRFZ5?=
 =?utf-8?B?TkUyaFNVUHgvNDVldmJqQVdxUGxqcXI0L1JyY3paSzlWdzlvMUlxdG9aRm5K?=
 =?utf-8?B?ano4RE5HTzVORVgvWXN1MS9vMk9xOVRsUllQZ3ZMUk5IZXJDR3o3K0tPME9O?=
 =?utf-8?B?c29ZNVlhc2hXQnJ4SzdZUWdwY2xQcThWSmxEK1ZDanpzMjNqYkdPM21qaXB3?=
 =?utf-8?B?bEQwQXdjWm5DMFFMVkVkS20wUkY2dktVTUxEOTVGOTBZREs4cVUxOXdwTW1D?=
 =?utf-8?B?WldOOHh1Uy9Bd1pNVlR3YnU1ZENiYVRGNUR3MFRKcHo4bGNGWmI4UG9Ub3NQ?=
 =?utf-8?B?U21CdVliVDBSUjBrOENYYlZvdjl0NlUxQlpuaHJ5YnRiZmhqb3E5cU1TaXYr?=
 =?utf-8?B?U1JZOWNxNW8wRFBjVndDajZlVXFhWUtCbnRzM3BxaVAvWGtMM1gvTWF2T05T?=
 =?utf-8?B?bEh2WWhQOEY1U01ZMm1tWGJ3VU9KNGdxdCtacWQyZmpuYUxpVDBkMmhUWjNK?=
 =?utf-8?B?QU9aWUY0ejRBNVJpY3ZqZUVhTDlYLzdjNVFXRUtDUS9zSTJ3dEtzVmoyQXVa?=
 =?utf-8?B?U2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3p1+FXHiSdvyVX7noeElqIYvm3x8flzoIMAYOjRfO8IJg4yasY5KQN20/ARmbDwoADMHXKwYR9ZCUd6jN4x4lMAWHdCSz9dUdMlkuYUxDrewx9dXBfWcAWMn2xRA2wucLGIf+Iomd1kWfX+vwNftWLW2U6I6OdhzfVXNM1EQLXP2LPdXqwjbI14e0R2p7Xfy8z6Twe/ciX4mHUKL/HjyrhNsNoWwZsH1W9jJnzFUYMrUt5sDyA00XXd2qPMmriLpu8eTIoULw9JI9E9U1vew/2kQ8Gwlm46pF3L50qGT0IhhOobeBN8KbwbsK4x2CSvj4XXXJ8InwsS9yPskcjczS32TuhmJeR51TkTW3E8rppQNTptQhtvBoSmggbTAFTc48ft+Rnvp8nIC8TDNldxktTH6Pm1a5ocSokfF8rHPfg8+28DF0wYHVWjipb7bqa7hYO6AXinWlOewtNGOG5MEhfaKURS6ePbRXOM1PJt6+iziI+swpVcy593+CXuTS2sm8h6xR7uDC/uws+LxEJ9YIMuFZTOBS2ahL0/zLqwFTdPkRugf89LjZd7nb/89keNiSayueivt5SkgQ8KWrbmbqit0lEjkoKEMywXuZwscUz0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6788f55c-7006-419b-c214-08dcceb88249
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:11:43.6209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O5DHeDhLkQZiw9c6DgsxF4Yhd5v2Iqg0wF5eD5gTeBBcseR0pSigjC8HPI9UhoHHZ+uqMSZOcsGUsdH1TKvwDQk2tE6GU5T7rZgeCJA+tO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-ORIG-GUID: TDA6Fi6_2t6J8RLRnQwRL4Ga5EgThcjE
X-Proofpoint-GUID: TDA6Fi6_2t6J8RLRnQwRL4Ga5EgThcjE

Hi all,

This series contains backports for 6.6 from the 6.10 release. Tested on
30 runs of kdevops with the following configurations:

1. CRC
2. No CRC (512 and 4k block size)
3. Reflink (1K and 4k block size)
4. Reflink without rmapbt
5. External log device

Christoph Hellwig (5):
  xfs: fix error returns from xfs_bmapi_write
  xfs: fix xfs_bmap_add_extent_delay_real for partial conversions
  xfs: fix log recovery buffer allocation for the legacy h_size fixup
  xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent
  xfs: fix freeing speculative preallocations for preallocated files

Darrick J. Wong (11):
  xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item
    recovery
  xfs: check opcode and iovec count match in
    xlog_recover_attri_commit_pass2
  xfs: fix missing check for invalid attr flags
  xfs: check shortform attr entry flags specifically
  xfs: validate recovered name buffers when recovering xattr items
  xfs: enforce one namespace per attribute
  xfs: revert commit 44af6c7e59b12
  xfs: use dontcache for grabbing inodes during scrub
  xfs: allow symlinks with short remote targets
  xfs: restrict when we try to align cow fork delalloc to cowextsz hints
  xfs: allow unlinked symlinks and dirs with zero size

Dave Chinner (1):
  xfs: fix unlink vs cluster buffer instantiation race

Wengang Wang (1):
  xfs: make sure sb_fdblocks is non-negative

Zhang Yi (4):
  xfs: match lock mode in xfs_buffered_write_iomap_begin()
  xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional
  xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset
  xfs: convert delayed extents to unwritten when zeroing post eof blocks

 fs/xfs/libxfs/xfs_attr.c        |  11 +++
 fs/xfs/libxfs/xfs_attr.h        |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   6 +-
 fs/xfs/libxfs/xfs_attr_remote.c |   1 -
 fs/xfs/libxfs/xfs_bmap.c        | 128 +++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_da_btree.c    |  20 ++---
 fs/xfs/libxfs/xfs_da_format.h   |   5 ++
 fs/xfs/libxfs/xfs_inode_buf.c   |  47 ++++++++++--
 fs/xfs/libxfs/xfs_sb.c          |   7 +-
 fs/xfs/scrub/attr.c             |  47 +++++++-----
 fs/xfs/scrub/common.c           |  12 +--
 fs/xfs/scrub/scrub.h            |   7 ++
 fs/xfs/xfs_aops.c               |  54 ++++----------
 fs/xfs/xfs_attr_item.c          |  98 ++++++++++++++++++++----
 fs/xfs/xfs_attr_list.c          |  11 ++-
 fs/xfs/xfs_bmap_util.c          |  61 +++++++++------
 fs/xfs/xfs_bmap_util.h          |   2 +-
 fs/xfs/xfs_dquot.c              |   1 -
 fs/xfs/xfs_icache.c             |   2 +-
 fs/xfs/xfs_inode.c              |  37 +++++----
 fs/xfs/xfs_iomap.c              |  81 +++++++++++---------
 fs/xfs/xfs_log_recover.c        |  20 +++--
 fs/xfs/xfs_reflink.c            |  20 -----
 fs/xfs/xfs_rtalloc.c            |   2 -
 24 files changed, 446 insertions(+), 238 deletions(-)

-- 
2.39.3

