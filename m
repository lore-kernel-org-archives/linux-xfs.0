Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43B112BEA4
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 12:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046955; cv=fail; b=PRcTzvoox7IRMV/B+mnc6M2yW9CF2e792F8245ys2QzDsYWKndH31tyhAbxHKzhii1NWJqS/And5YqEh1UvEYeTFzCFlyq1Pz1Jjf5wNK2nHMNPuH5xi0bArtpT4xpACKqBdNzKO6+Q9f/qjwpY8/b4N4SPeq/Ic7bhso7YoZy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046955; c=relaxed/simple;
	bh=+5tedtcvqiZYqMC+2tgJoOUX79OeMtgOPwGMApe83Ns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tNBsvauGGa9bnTjMGruUfazxdW5sfBniVZ6t6w97ZnFkfN7M7JohODIR9HLXffObR4luilkJdqFrt6GGL4V9Iao+3txMd8oiMFpjE7ttWux1UFWjy7hTWbortb+aVDOXSjxv4UFq6iMQocFTLfJLt0Gyw6IeIH6LVP2jdUTyOk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ftGRZNBF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LS/6Xzo/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ftGRZNBF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LS/6Xzo/"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P8x3NS000742;
	Thu, 25 Apr 2024 12:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=0x2z2lMXeq2TDbYdq31rRHqCtFnplUO/Ay3oh395OUA=;
 b=ftGRZNBFf70AGqpLPNp+ABsdLzT4w+KHtZ4+ikaJAfqTjrH61riOF0/UY6vevCD+5dRb
 gEMTMlZcad78PvJ4WsjOcDOX0slMtNb3Y7TSnQmR01UbZq3hqFNSVi1EYCHRCFCvFsbP
 f3sqEG7/jJ2TyiPQUVd4jSEBOlzRhST0PgaGOO/gnTLGaAf8Q5eG9U6X+dfyIyq0xaf3
 zXY2bK7gxaFFnj/gJxfkBz7YiNzQBg3FdX9dDo/ONzZpw5sP4H3iWhdN3o1Bd3mRsS3P
 WzKiJvDXBq9xelIM/VJ4CkNvygg0+9IFWsj2qUjN2VlwGmpEG9jFyUFK5y18PwhbSzzH Sg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm4g4jb80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 12:09:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43PBGSf2006164;
	Thu, 25 Apr 2024 12:09:01 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45a9v1q-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 12:09:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9YQGQ2mLGoSDYvc94HXRHcTd+oj3J+dr7OkTHEPxFwqpSSJSI+2mQKlQkN8US6ee6ZV0WXn0DV5+uXuL3nb7LxEc/lHEwZEnaEQkEZCUtyNpPVm/l+aM6+Pwj1h6nvkI6Ht2ekuq7RMacYw5UAkAlTSqh7mKa43NnrZ5fUzpHNzgqJHn7HQHDPhreEvNZxN11f5RaaCVmZgLtdHy9wzTsKIq3w6F/cmtdPEVIoFUr2Flx2FixI5sxeiy/685jEe5q15JDXeeC/3dDqK0m89ajNPCzTebW4Rw8qHeA4VETDAGFLZUvhpIqjysce+7tVECclkEOzcgOaNSMs0/t12kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0x2z2lMXeq2TDbYdq31rRHqCtFnplUO/Ay3oh395OUA=;
 b=YAxKrF2hWCUz7ERg+S19B4kwhkU0Iudv4Lx4EA0xgguK8CPEHjniRys+PCEBuHF/vIXgv6tdtgqQTCnmNtpAhnv6dIgEtnB59kEgvPh/Fw6DCu9tZ3aROA/W7jikutYNBWAyAIOTqComaAQjZ7vyqOLUSm3R3YSNv6WJ7v9r/yKvvtaFgUugIWSiv1xvinZLOHrAsYh0a90SpXl+PISZQY8agf/yP2FKUdxdLR7eIogNzwB2yiweg06tSFklx8PMFeNx0GDcvGf8mnUDc6ufN5AZtAxnTb6rau9RrTBB/s7lcEjmTSPXU86lISMwfOHl+xxkNeVbO6pwk4IVyd3szQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0x2z2lMXeq2TDbYdq31rRHqCtFnplUO/Ay3oh395OUA=;
 b=LS/6Xzo/kxBt+wkrO5fwE1JScdX7X0/ON4PWBtHiLLNDj6xMhYmolbsHV9NMQ1KjnoUWHE3Q8PxiCmc7l0WmeECwxXAwUaKhES4ducW79qHSW4u1Vt1loucCfEIB3BRF/Q2MnhwphKB4tlpA51rnr9IpGAf4ONA76+kinhbVE0o=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7197.namprd10.prod.outlook.com (2603:10b6:208:3f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 12:08:59 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 12:08:59 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/2] xfs: Clear W=1 warning in xfs_iwalk_run_callbacks():
Date: Thu, 25 Apr 2024 12:08:45 +0000
Message-Id: <20240425120846.707829-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240425120846.707829-1-john.g.garry@oracle.com>
References: <20240425120846.707829-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR01CA0003.prod.exchangelabs.com (2603:10b6:208:71::16)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7197:EE_
X-MS-Office365-Filtering-Correlation-Id: 62543036-ef19-4a8a-7772-08dc65207d19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?SWNBdCs0ODdMWlp5Y1RBb0tYQ1dBZitCWTJRNDBPTW5lUFRDMnVqM2RMM2JZ?=
 =?utf-8?B?eDdCdWg5OE4zZEJ1K1VtYU8rbzV3dDZrNWpWb2dESFk2TUFOL0ZOYmpGeUhC?=
 =?utf-8?B?cWRoSDBtMVBCakNmMXE2eHordHZWTmRkRWxIVG9NZHZ0MFVwLzJvWGxKYjNs?=
 =?utf-8?B?YTkxV0paQktUSG9ENWhiMVdXYWJLdVl0RFlFQzArYWhoVkpJYWtseGVDVmFB?=
 =?utf-8?B?ekRGaGVycHRRcjdUQU9KbWJhWWdDLzJ2SEUzdGRKcWE0eVU3Vmg2V2JuVUVs?=
 =?utf-8?B?bVBpWm9zakRRSDNkZ3ZrREJFUkZBUDg5bGtKOE9BQlFZTFo3TEhsQUwrdWpM?=
 =?utf-8?B?UC8rVzlmSUQ4R3dHeXFmSnhmcEw1VU56WUZLZUtuRFphRGJPdjdyRFVPNVB0?=
 =?utf-8?B?bDQ4dlNJQ1BkL0htK0NMQTlqa1psTkdtZ1JVWFlMR1F2cEdBaEpscjV6NUo1?=
 =?utf-8?B?YTEyOWQxWk8rKzErMVZ0T3BZeDdFaVgvN0xDR1RDSG9uL1phYzZkeGRvQlV4?=
 =?utf-8?B?NlQyU3o1ci9WSk5HVDk2VXo2NjlLS1pqVWhwS0ZsMEZRUFhWSlMxUVNMMnRP?=
 =?utf-8?B?Z0k1Rlh4eStoSVgvc2lkRnVmMTFEc3kwbHEwOWxXcE5nemNYUEd1eVNDZnRw?=
 =?utf-8?B?TFg0UUljcFloWlhjclRGWjAxSE9JcFB5MmtqcVZCSExaM3BxQUVpZmJJTHdY?=
 =?utf-8?B?ZWZRK1AwRHRQYjNYS3RCbHUxanJycHVFaklncjh5cFIvSG5hR3VaWGVPWWlP?=
 =?utf-8?B?QmM1OHMvK1B6dHFWMHNRRURSVUtwaG5SNlhVdFQwVWxNUnBubE4zZC9GTnpY?=
 =?utf-8?B?eGpjTVdoc0pQTE8zWlNONlZabXR3bVpqSHBsUmUrUGluMTdmRTlCNlpFUjN1?=
 =?utf-8?B?Vi9iNFpwVUdpa0dMbnFCanpPMExCWVFhaldCK25aQzhCRzVEa0c1Q3Q1RElX?=
 =?utf-8?B?ZjRIY0ZSZ1lIOUU1TnNMdEtBK0ptdnpYaS9yRzJ0c0NuaG1IYnF5OGJDQTc4?=
 =?utf-8?B?Y3ZtNFg4ek5OcjhuWnhYaXF3eTNnZitFUkppaUhSelVsNDRaTExDVmIyNFJr?=
 =?utf-8?B?THUwWmFacmNpTDFRc1h6bzNKQWMyRHlFTlhtb2lmb1lHd1hhNTZkMUpBTDd1?=
 =?utf-8?B?TENlNE1tRXpxR0tBRkRJb3VlTDZ5SWh3QXF2YmlnaEZKNzJ4eko2SUNVTlBx?=
 =?utf-8?B?bHhjTUMzVndRNDlNZHcwN1BZR090OXd4QjlySkNhbjZLaGhRdHdlTWVhbUhm?=
 =?utf-8?B?a0M0U0wrL3d3TkFoZmU4YVZ4NXcrN0p5TXRFTE1RWTRRWFQrRzY4bFFOWFVp?=
 =?utf-8?B?V0xrcGlhOTBkZGM0a29WK05wc25aaHFBNEVzRUVRMTB0STJWaGx3bW0wNS9F?=
 =?utf-8?B?cVJzV2FSRE0rcHRvcVJPV0dhanNPeWppY0k2UjRDY3JNaHM3VXZKM3BDcmQw?=
 =?utf-8?B?bm92K2JKenJuQ05XQ3FpdUg5ZGpoUDVYMlR2c1dhRGZWNHdKZmtNOWVYRTFU?=
 =?utf-8?B?SGNpU1ZiL3dJNlFkRUttL2xnd0MrNGhMdGNkcUR6OVVKWnVGUkVpcERpN2Zj?=
 =?utf-8?B?dzVEOG9pSmQweWdQQnZ6YllKL3VWTWF4NWZDVGRFUU9ZUlhBcTlvcHY1Q2Rt?=
 =?utf-8?B?NmhXem5TcmJtRTd5UGNmTU43TmJ0Q0M5cVlXcGYyRSs4U29xUUNqYlVueFV2?=
 =?utf-8?B?cm9GYUNXcU1yNUxuOWc5VkZRWDVqblVwZCtUdnZXWFl4QkNsUTRKZGF3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Q1ovd1pBV0xNUXNsR1lHeGVJYXlpU1F5V1YyV05tRXBoOWg4aXdNclpyQU9D?=
 =?utf-8?B?VkZiVHN3UTR6YU96TlhuY3phUnAxY3BabmVtTXozenprS3VpT0oxZmdkaU5Z?=
 =?utf-8?B?UTVhWFh6OTBZaU1vblowV1ZuSHRpWGNmREZady9Pcm9oQWVPMFM0NndnbnRv?=
 =?utf-8?B?THdnUlUraExsTjJwTExJc3BXQ05kbXNTbnY2ZExsa3Fqa29KNFFEc2lOSkU4?=
 =?utf-8?B?cWFmdmthNXBJZWFYWVNCVjF0VnEzUEs0VkRNRUVCeXdMbEk1QmVKQ2U1dXMr?=
 =?utf-8?B?OW1KaVA4RnljKzZFUkFaZE1wTE8vWEJkcWVHNUJVZUZLSmRxbnYzVTdjNGZn?=
 =?utf-8?B?SjZDVFJpRndGMEpIcVV3ZDI2ZTRTMzd0Z2E4Wk9hak9qYVIxSHFKWkNybWlh?=
 =?utf-8?B?bGllcHlzSjlKUWRBckV5ZHdPbUl3YU83c0U3TklCVVU0bzdtR1F0TENuT0cx?=
 =?utf-8?B?eXJXNXdlZENxWGg4MENiMUo0WDMzcWNaakhlQWIyRmtWcms1ZU44K0xKVUc3?=
 =?utf-8?B?MTM0dVFnY3N6ZFc5bTJ6d1ZxaW1BdkxUT0V2NU5SUEFPa1dKK09ZTXZjT1k4?=
 =?utf-8?B?a2pyNWc2VzJzNFQyVTRPVUJkbkxWZ2VXaEQwMHM2d250ZEYwZGdYMXYyaDRQ?=
 =?utf-8?B?Y0pmbE41OEprSkk0OHl5Q3FYc0M0WGNncGxwV0U1SGJQbEpjZ1hMTHI0Y1V4?=
 =?utf-8?B?NW5OTVYvN2ZyQk5ZRXgrdDFxak1nQUR6d1N1YjI2MGNXbEMwTXlxTmNlMUZN?=
 =?utf-8?B?bC8vQjVNM3R5ckFtSTZkbUxnNTZ1c1BhWEJjTnJSUmpHdGI0RFp2Ui84dUtJ?=
 =?utf-8?B?TlBzcmhiUDZwUStWSEFCU2RSWjlIdHJ6Z3JOQlIwUEZLWnE3T3hEaXJNd3pX?=
 =?utf-8?B?ekEvUlFDV2E4RmNiVGE4MXpYQ0RpazhDcGdjSUNwZWNSeW5TQVZMR1ozZitT?=
 =?utf-8?B?WnJsS0dYOXpXMTZOMUFibU5ybm9ha0FyV3RFR2xzY1NXM3BZMmRpLzduQnlm?=
 =?utf-8?B?WHdkTldWSFFyN0xmWEZVRHpVeWRoTUZ4dDcvSFZjb3FuS3FVWGVDeS95Zm1H?=
 =?utf-8?B?M1NNQVF1QzRnQ2dPTjFaakc1RSt4TzVraTNBOUJ0TCtLTjdKTmtmNXZhN3Qy?=
 =?utf-8?B?OGxQdWNhMGRCMlhBTXF4OUpDcnNtd0szdzNYV2pvVWl6MnpwMUs4eFVXVjA4?=
 =?utf-8?B?MEY1elVxcHR5ay9aazg3VmlMUWxEYzA0TWM5ZCtYdW1JcnU3Rk54L1lYM0JB?=
 =?utf-8?B?R2FjUUd1MG85V011Wk9tSElReVhTZGQveU83VVYrZEQ2ZFNBNVMwYUlXQmVX?=
 =?utf-8?B?UXN3U3JKMUlGN1pCRktOT1dHUEhQUVErcnUxYXF6b1dFdVJ5VWJYOURpeW00?=
 =?utf-8?B?cFFJSGE4ZU5tQWtvbXJMdTQvakxGMExwdHdJUEFrWXcyVm5Sa08xejZBb3J5?=
 =?utf-8?B?elFtMHZRTCtBSm1tL20rUEFjVllEcHhKVGFJcERHSUE1ZE9KUDEwaXkwMUZo?=
 =?utf-8?B?MHpUU05pN0d0ZlpZMGxxaENQcnFQYWZodFM0TmFNT1E3RzNadE1ybWdaWUxI?=
 =?utf-8?B?L1lRNmdzYklxcFVlSzdVazh3S0RKeTFkdkFWZEgyMURKSG5rVUsvZnhzVWtS?=
 =?utf-8?B?YjdXZ2Zpd3hwNEM1SnY2bGpheWlVYS92L0FnMm9KZlY3ZEhMbkl4aW0rb0hI?=
 =?utf-8?B?Nm1SR2xPdWlSZGx2STV4TGwrYXQydklJa04wamVSeXhIYTZCSEJJK1lieVoz?=
 =?utf-8?B?Uld4Y3R1N2ZLeHFCSk9rc2Jvb2l1bmZlV3dtNGlaYVA5R2ovWHFQNWdibDZD?=
 =?utf-8?B?WG1xWDdyQ1JJVVJHd0dUT1N5dXpTMjJaeHJyZ3Y0dGVtbllnRWZsR2FsUjJh?=
 =?utf-8?B?d1dTODBZdzVYS0V5L3NURlh5TXYrMXFSQ0xncnJFNDBhYjhjbWdzUWhXZUwz?=
 =?utf-8?B?emlOQmdvUWozRGJUb3Y3UnZjcVRnNWJtZmV1WDVYUUYyOUVzY3c1L251UFBZ?=
 =?utf-8?B?VjBkdk8yM1lid0JOaXNXSXk2ckdNbjNMZG9hWTBJbjI2UHNGdEloK2UvOUx4?=
 =?utf-8?B?dDl3d2liUzBvYS8xdmJ4OGt4QUJXZStPalB4aFlFSzBvZDFodlpKT29acVFC?=
 =?utf-8?B?SnNsbGVtaEdkeGUzdytHWUNWMG5iZldaYmU5Wks0bCs3aWV6a3pmdThSaXBh?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CMHNcXBQc1MPkcZsiOOCy6blbqy9RrlJMdk3NTdSqmNPqNtIOgEYy0wPZw+sI8B2Br8gACJ0TwsSayR01drPrDKtfVkwRqym/VqdNN9FPpsAoJS5iw2fs5NYJeJwH0wg0bmz9U1pbdF/PprU5tQCsT7HeDHQ7M3WAte9nx+G2EC6+7POJG28e+uHnqHL/mbgk1nfNmFASrR4gh2rONE5x4p/Bw5ZN1aRSZ0Jr6VEUtZEbSXd/htFrny3UFjIdb2O3AEKfc6PUuJxU1OYwhEUgkKn3b6L4edGiDiJq6m4HLRncLFmfd2uTxk3rts96jEZStUSpTmzr0Kz49gmtO9PFfuptZ2nEEx0dOYFwEBUYfSqoJEOlG5Y787NP5tEchCy/lClLizRs5OqGrin5pxF+yCVHqikpTlS8f9Pymg+yjvD7ui/k3GQkH0OVeYCLWCTAgHlgkOJ0urhz3yWnxSZtpznbsnqn+xvVR/U8Z9Nt6gpQRXAzeAD83GCVVEGoccQ7SoCKXJWr6cLMFTejFFMYAFQhcZakLIbX0ObgwfL0j1ljMQoFafmiX9tigTnOEANVSm9LP23Q0Rw7QOQvEn2I/fhPxgVCcBweL7Zm59aSjw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62543036-ef19-4a8a-7772-08dc65207d19
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 12:08:59.2739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yr7cDqjD9h91caNvIXBpfcEEtUHn2TfHnvwSMBmKtGVyFAWFKniJ6y0kb685gzjhgh1kqHsenUPBzo/wDSuSrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_12,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404250088
X-Proofpoint-GUID: gunM0sVaBIvLJRWcubwTaTmUKLDwrwPK
X-Proofpoint-ORIG-GUID: gunM0sVaBIvLJRWcubwTaTmUKLDwrwPK

For CONFIG_XFS_DEBUG unset, xfs_iwalk_run_callbacks() generates the
following warning for when building with W=1:

fs/xfs/xfs_iwalk.c: In function ‘xfs_iwalk_run_callbacks’:
fs/xfs/xfs_iwalk.c:354:42: error: variable ‘irec’ set but not used [-Werror=unused-but-set-variable]
  354 |         struct xfs_inobt_rec_incore     *irec;
      |                                          ^~~~
cc1: all warnings being treated as errors

Mark irec as __maybe_unused to clear the warning.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_iwalk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 01b55f03a102..a92030611ff4 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -351,7 +351,7 @@ xfs_iwalk_run_callbacks(
 	int				*has_more)
 {
 	struct xfs_mount		*mp = iwag->mp;
-	struct xfs_inobt_rec_incore	*irec;
+	struct xfs_inobt_rec_incore __maybe_unused	*irec;
 	xfs_agino_t			next_agino;
 	int				error;
 
-- 
2.31.1

