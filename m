Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A7D3DA5B4;
	Tue, 13 Oct 2026 08:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879261; cv=fail; b=P9G8abtWHLLiIMtvf4tnuP2cdj+qYHgcROgM+2gxauckXTybwv+l8UGmrhC8xzvsX48Ae1A79xQkqi2yM1Cp0145ewLjWxkHDgoYZV1IJZkIF+Hl9/T7gEYzqAYs2lLY0Xg7OYAHVGqt2pnNea7ap+fz2RWwVs2m0+cbcZDZ/gc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879261; c=relaxed/simple;
	bh=wIC5ah5b9G3A38/PIe7V+7NvkOdhNmjbXQE4d+4hioM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rM7aITA8XA+VkdzsZWMBefMyHVKqnjWmuYusFq1zumY6wfVtCOppdc3l8AuzXtqBNZjgsvFzj5ZhpYTFkqjZGcy/N9vNsYpOvDPWbr+C+QSYGPt5Oq/NGWSjFF55uUcjMnxXIB1j3dc1EDmiLnQ1M2vsIpo5KF7/q8C+c7w1Omc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AQG6tnzV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zF1tCu8U; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AQG6tnzV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zF1tCu8U"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CQgN3434524;
	Tue, 13 Oct 2026 08:14:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=; b=
	AQG6tnzVrnMeA7GrXvdvckKi9oQk3FHfn8oXEMfgZzK/qnxpyDIk9nX8MZywjZgg
	1WpyogrhF1UD+aJijrjqN8dU68C+Gl2KJm0zjnpBT5Cq2sqSFHnHQOChDnOT4Bta
	kgEEru+HZpkfM0NdBnVxDyoFG0C7O3hMTgt8SG4/jWnocA7VKv/C/jv9oufzUKW6
	VRv+GHRmTgmv1gO2lNAUSkyXhIrEZZ07QHKcEyfGSw7ZWKkzoWj0cAH1nZoG5E+7
	bR/5QtXFA5UKCrdF+BExPOVvyWPM6ktBjfadxTWdvZqkMsVvSN3eXAbloWRyMF9K
	qdrYcj8ixdBA5s0KExMjjQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kjjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:14:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86hrM033569;
	Tue, 13 Oct 2026 08:14:16 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010041.outbound.protection.outlook.com [52.101.56.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btnxqsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:14:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vgu11lAgLVpmIPTcJE4gtVKk47gfAj3BTTF13ux6sRqM7Ykkq4vIarGuvGXdeVCp5IXwrujCLSvgJwQmYhd14/bLYVxHo+9X7nxh6c2cojOjuFr1t9o8KZMFjaZaizMcJF+oA22zpJWWcuD+YLfR73I97FOprF/xancQkEkBfXnVOH4SxBpHdPsTBxcz94gmdEcyGhUmx/YTc1uWyczulCAQ0z71oLPrEPx4ta8dFWwuJYtvPRBCCbccCI13XCzfXQTICsCiycoyNNiaCKIUPek9xBms93fPI6oM+EclWBBBy8cR0taAhaJMhpaRwymRbGakuydW9pgVcmIPnl00oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=;
 b=LtOgd6w6lsHzbZT8tVbpFkCvNhsJ4XKZEAxe+A9OUwBlMtYEdYn3xn+Iue0BUUuUNzVk2jEudC5UzGyk5GXWOlXGGFOY7h9jd92qdA0CXg6qliktu53Ds/ixl+trIUJ9ltvfz1tiYZh7DVuSb/wBU+HlPcktFh4GszJ2SKO+USJ6OMNpj1/KtFVDh8zizNRuz29PN8cvazRFXOYUPC6hTYpcsWpgMdW9PQzf9mLZM3xmLSHtSFuhxE7YTbytBv9bhgfViKGOfD6yAaOh03bRM1S2qv+Uh1Loj6/vGkUErWjYd6AcysYRITOzM0cBx7R/+dBx4NPlsNDbHCoI14+sRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=;
 b=zF1tCu8U7/SUid+0dDv9V2vBwAgKw826QiYt260pnQu+bhmmvf6Gtmz/f3GCOnuDbI68ixP8DYo46XP/9soVE/xWknreFXyRcOMEI7EQ1T0xC9G52ueHsb+iPGRXXb9owDsYYvNS7G/Bu+TPHKZNrRqQDuOJLx/llXEj3jPboDI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:14:12 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:12 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 v2 4/5] xfs: factor out stale buffer item completion
Date: Tue, 13 Oct 2026 13:43:48 +0530
Message-ID: <cabb67cea29e57cccc9dedfd87c57dced80e0122.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR01CA0003.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::18) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 860cd8c1-a3f2-4926-dce5-08df2901f6c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Qfh5bTnTHQTc73e83vd9ZKidUWM/UVyx7D1e3N4Ln+4dVtXbspWFwQsuJ3t4Ph4u5N+50amsiNH/wX7Bvh2/seOwFu52s5x6jgPAW5216SNjVVRAdv+UjGvx6Edqr8j5XTSXDB04ijm8o569dFnNkV2/iA3cNYQdkXEO2W53rDIBXYfePKpSe7oYoqdqc6lHYBvN5IAapUFbV3o6q0nCkQH+fPrJ0Ox9lOPtY4uzeMXWbWpcQm/ynTb3JelU45hJaSj6bqq+6d/cz8At3A+3YXXuidQDXZQ7wdqkoqu2l6gUeiwO1Du5nA5CJtLHLeoIDFvr4QE3GvGiwUiHDR/GdQL83v5DupUpuqowWEzMIPeEWDtYWcEGyh0GuKahmNUSlribqdmUEJudgcZhVJLLDAALyd/RW/iXlVu51TczCsbUfBivPuszMqr4kivHHcUWmAb3zFZlWiR0gI+z1ni2yeyuIRqixiCV0mF2+//vVdwm/gRPFiMitLMfv8AuaWqJeQq1eBen2S/J7KKt++CUsMwneDBi/8QS4kY3Iu0sSEQlif17t5deYLl7yeqgr02+V0oHhD0RidN7MfVItm6srHcAT/SbxCm8aU+ddm5iA0Ti1hRjijmcMKKETJTIGdfOI/Jpnfx4q016RSr2MmOPZMQEY5sQk1GimiCRgUfRdtw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2p3w7n8t9ed4HiLEVjNz91h3Em+GzHibVPORr0TzPNLLmNiTniSki4tN60Nh?=
 =?us-ascii?Q?T3UnRfnl0Kn8yWcAoZhk3KjESZYSFrJLKxseQW5TY20WN2q/805kcjNd0vAo?=
 =?us-ascii?Q?nzs50Ju+HnrfU2MR2rR4ZY/T8+mgzDgeRTluYYnhfRxcpFkbF0tSfRriYolL?=
 =?us-ascii?Q?Rn3Qbz6tBXrdZE6DrMyG/2oP9Cpz2E/+Q63mFKGzp11B0XG3iRVC1tL8Hij6?=
 =?us-ascii?Q?kq9eIadfSYAk9k7u62L7Yn7i+dWRaWzcPCqBEkkZaZcyvdHyoTrgLHBaJBXa?=
 =?us-ascii?Q?ZHQtI6b9VxGckuviivwazZwxVpuNkh+C8rJvXv4vDCfVdI0wOAdTFHraHWRf?=
 =?us-ascii?Q?qrKTy+Z2T9cZhEyXDAm8DCYwrO2YJQNDnpJ1KByNF2HezsKeQGoZplxBn+aG?=
 =?us-ascii?Q?yTEPPlwZAtmjyE34jUU35j+CEQJGqFFy1gU1xvO5rjE3DWpoo9eKqNTEavpk?=
 =?us-ascii?Q?tE4gwSLsoeNyE8HK4VvSDwK2bigG6e2O2mDqChJQpgkV+ZUGWOAuHFuwuaeA?=
 =?us-ascii?Q?iRf96biVLbHFe0EIgDDt14erdXPbwAv76yTRxL55LcFKE9A97k11qnpJBGV1?=
 =?us-ascii?Q?rVeHW7Lkirx2+3Ocn13MHGOBGvqDmaG4xTa/TNn4LGdPzXGJEBpxTqWkYvXH?=
 =?us-ascii?Q?WEqgrEe4azlhLETQi+WrXC06pVdbksl5ARaUmps1cYfjMMv/I/MaFiEsBofS?=
 =?us-ascii?Q?JjNU6Hhs2ftjxq7YPGDRnY/1dT/fy162VqQYdqSVRbuNzlIaEgTwwIlVCwcQ?=
 =?us-ascii?Q?pBBBvme+JBj6obKcDDOE5FkmSIDu3CpviB6/Mn4UabG3ANW2fo0S9khHfQzo?=
 =?us-ascii?Q?erneNbMO7Qm1LZhEOCOW2Q5Xn+rhROa1ZexXZ/8dD550EUnBbGCNV8BUvKBd?=
 =?us-ascii?Q?4whZplsa2oz9ELp/mMqWPlb9Fk48pAlrqxqdKY9AJfGWjNkcIATLXzp+iX5e?=
 =?us-ascii?Q?YjD8BLTcleM25bqirvPBPH3ruFJu9kVRztcXQ1+ag3bKZBjVw4ki2e0CezjX?=
 =?us-ascii?Q?8nbiv87XM5XSxqTR2Dbq88uBG1MA05TaWp2HHzmuUxD9LcFudaYpmbsGvaZ3?=
 =?us-ascii?Q?sigMlwOU98QwHH+e69uKghM5r9D7JPwxUhOH+uA5HiWQg0alU50JwPMr9BFx?=
 =?us-ascii?Q?rd4VOYIJEof4otLwEDH1DZvll9zafYHbtmw+jXrb38/vBDLxksWP3i8+s39Z?=
 =?us-ascii?Q?VgeeGAAVWyuRoLU/4EPAqzfmj3yH3555krZKCOKOKsHxh9GtQGiXD8JgWTam?=
 =?us-ascii?Q?+SYOUjBY8yoeY05nzBa2z/sTicUDoewpTqetDhxH0LBq9KyJ+q3SDcsVhiGX?=
 =?us-ascii?Q?dmVj3GXOdrzIsRhZ8AI/G1IeIesZAkuVYrBxiNyiIuRs6oRZ4s8+rzgozVfn?=
 =?us-ascii?Q?I0ctnVMAazn/DwFCTmotixbI2C5vKBo6TBUldUCCDXSOR2+dkyxyeyuKb1OU?=
 =?us-ascii?Q?dGL5oesTTTGui2h4DV400ABw/JmPSv1Ab3nloIwdpVc7s3Jz1IZblTviZ4FS?=
 =?us-ascii?Q?bG655zNdlsXM42nWJ/OtEMesXbx6qFyFgdfdbFN4BtnNh0okCi9N3uA8QFyL?=
 =?us-ascii?Q?QIS6I0mLSa5UD+OS2PCUO78a8PEeyZDrglZr3KSAZ4Iqquu3HjBnbkmL7pLK?=
 =?us-ascii?Q?/dU9Y4PWotr7Sm4thiKaZUN43Pb48NQvXsgywh0jpgG+PLWEJ/42vKv63hcF?=
 =?us-ascii?Q?LddAhyiFPS75ZD+dSvLMBForVOgkIl2Xy/Fjj1YglJ9c5gkSBeZ0G4kpLYLg?=
 =?us-ascii?Q?fu3PtL9vDjU2SttiwI6MZ3rJacnN89u9JHlUsYcjtD2YPmdzFv+6H9OPLW9H?=
X-MS-Exchange-AntiSpam-MessageData-1: hoAFov1pVnUmbOGQFyWX4CQsS2QYYYrsKeQ=
X-Exchange-RoutingPolicyChecked:
	Oj/Am0tDRgX6vh9tbNga3jfU5oGdx8hktjfLqAyWSKrKmp8dgTN9ON5+S5LdjXZE8WMFSq0YMBfOaUClpc7QiDSd+TgocJNbMgsJ9yX5ZL/3cMhzXH3d7GPYKkfFD6xIcSorBGyJdsGMRu4xNLjs+yKGzKKal1tQMYFrNpPpHpwU+sEy5u69dChYuZPWJgmIEYFRx87vJnnCWfwUIhYyV1U5SEvK6EQOr6Y82sFFBNHc0vzr0quSuzqvPZw1E8sY5WwfXAsp1u5FZFpLbj0TgP+ceDuURllKVggdj0ylrp/IUBlSr+WOoP0/xrxp0pOrFOpxcUT3byH2Hsjeg3c2BA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xHZriHUolCH26kUu4Ud0F6S4+0ugBS4U8SujtHdthOT3v1ihGI+mjPu+QmJ5ypSr02DVk075a3SLSKXBHoEHdTvaRAg40x1Ri10yLsV4NVChIOvh5ZF42kZPZ5yNv8Gu0hUDbPiLRmeBo6MxteOwp+9SEBDhP9+HRlWOptC05JmRGSIwAfLkHWn5RxniTi5NIluuZa6MabUREewKvDjl8oUu74/THwgputyiztpJ1y0woPjfvkahThbwEc58Yb716B4gwO8gBBhtJGV7IRnrHiaPgwldu/dlzMxcqlgOZGISWYDOI27Gf4XDytHJC4aHrKVdicnEuwkTS4oc/LtuMR6+BibecBuicrgv6W9ckE6agcikaEeoJKWAgA+4NVvvI2l6ZhrQcqGAV8kWX+yqTLOyQZ+0P04lnNf6lx9k+HoTTN1nWVN/elZhX+zhNRGacOEWF+QGlfeDHOBZ99cD3FoLH28qzdd8MNUJwdSe6j3hERnk8cL8Y3DuRMzYeJIO2PQ2Pq5Q6NQX0AzxIq1FxbCjYMoaYZtnh/viQLy48NI99asqFuCZ9+wBxeCTe+RKx3yLlYEtVXLWC8+eV8CwK6BBYQby7sIGQQutF+PayzQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 860cd8c1-a3f2-4926-dce5-08df2901f6c6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:12.5177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vOOEEia6h3B39tPVKvxXrTxiniQyK99NX0mieEwmEmMSQfdlP4f95d5RPrYKpzZVyj3Dh2zVrBpwgvpKQSS6FMK93fo7aaiyeMmBxxOAokQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acde859 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=HRhzHcoIBzGTXiVGymcA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX+rh+UxPqRBsK
 e8Peio/6++/NMxoYGCOmR2qLpVpSaf6mrSwwjxMF3upV37a7NGz/yy9AXRHwVHbZJ7j4X5UZUq+
 pAXSx0cOK7Yxvlmurih8S5NW4QjTv0rk17y9o5av0nXfXlx6HJfb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXxShy/EOrau4X
 Jkn0+FOHSaUfIfxieAzNerkzBHP/7omWded5ZlZ74z/QR95Q8cE4ieqQqp8T82lK+gUtegP2xWx
 wd6cpcwmyGCXj/Prt/MYFCm5wjRF6PyoV3lYJm/XPer/duCxsnTR0UdGnkuTHRy8CtwkyRKjZTI
 Nv0A4G4+09LuYswOJudtOqEYiDSsmOy2XG8UzEM3DjfS+jZh+iRNSO/e7i1AnDiQXgKKDTiVONg
 5i5MCqqI1Yq+rwO17JugLfrI4O87IEBcx8jQjjW1PLGe0gAVBws7a7nHl+c4ExjOo7kdvcN7MTi
 WpPJcpOnjXWDjyGTE10QYcgBL/vBWxosB7VysxSuGzJZVWzTjUTZwM/un1gOol1tq1v0pAcB+we
 2wd5MXLcp79RofrOCbzLgSPpCCRXWVKh9MPYg4GuXCyR7GnaBPI+tD9XYLjLDYv1xwRqDUVJAEB
 qgI/2Gb0GVa7CMQYm/UYvU10egxiF6UfPqANu4vo=
X-Proofpoint-GUID: UyGihvEBhkfr9WaoLmi4ynKQew1eoU7Z
X-Proofpoint-ORIG-GUID: UyGihvEBhkfr9WaoLmi4ynKQew1eoU7Z

From: Dave Chinner <dchinner@redhat.com>

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 816c330b605c3f4813c0dc0ab5af5cce17ff06b3)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1b323b3c0eb9..ade89a233e68 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -541,6 +541,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -590,13 +626,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -607,22 +636,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0

