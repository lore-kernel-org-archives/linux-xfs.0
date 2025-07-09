Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89362E6104
	for <linux-xfs@vger.kernel.org>; Wed,  9 Jul 2025 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752075564; cv=fail; b=Mag7zlSTQuerg6gT1kw1UOv5Jb0fcM9ME7HhqFB5ZwGvc8Y6dhtmZsJtJu+BYvdv925x8MCD/0E1Ya7lDoRMNqiCHALNdW1vF904H+PwZj9lfSlCGXkc10HMTKvBX9l6rr/gUdv84OgTMT+mn3X8/w/ThhSvir41iIVCkG9W6+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752075564; c=relaxed/simple;
	bh=JnAjJMsray6q/g6kVafq+MrVplNqR4Ig5C938sFjvM0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WVsoSkZA/FH7aPFrJBgf0EgsVjjktXS2qa7Jp1FyaHKoYt8WojLq5d0dMb3MFpYHHGDk+iudbpY798O3owEeQx/dJoYyf4Fc7V136XAofB6lB4Ir9ZHKG0EpJXVzHAiinF3F+og96mG03aTsHydPaf3pfhd1TSmswJ6GWgk96Cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SbnMEg2f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hjJEzSrC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SbnMEg2f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hjJEzSrC"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 569F1wTC023574;
	Wed, 9 Jul 2025 15:39:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=L7/2kkLOcvrZFPVqYgvJicK3MLNn4Bve6ESzCsC3pr8=; b=
	SbnMEg2f4P3uXndu+6x2TwFe8Mn2U7ohuLWFhjypS6itUHvXBi24eWfQK3sRqQGr
	s84/5lHDtPmt/nauEpR6sVG373Wp3lNxmREbltTGJ5NYRYT2CGsLnVwfeb0fVJTV
	R1A7sk/W8l7m8h4GGH5CJ+NpUdIHgmk25IbLEB0NyXRrMhuLzw19JoxJ/aXmrWrF
	6Ly9ihn/NB+q4Cs38zWbXCv9mbSKGMOTnytV0q4yejfSiURLQ9gTrwdKqrC70KVI
	9fSKcG5CUvcg/6QGUnHd9AykbXn9JxvypVpIt4Ki+uGp+j7QQHd2cJhZbhaLR/8T
	5IkRHGtpZKGl1G3SXZCyog==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47stq082kr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 15:39:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 569Ef3EW021453;
	Wed, 9 Jul 2025 15:39:18 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012017.outbound.protection.outlook.com [40.107.200.17])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgb4286-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 15:39:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gGBNeDm2o2sLbRpp4NIcdwlR2F/BsmJifkHMNXwJIW5F1X4aM03/KPUWXhrEhWK+OjNHs4Muj392OwlgDkfimt8M6v3Z3ZETrar84bmiPxDkS+kPLuxIudSHgvGYcXru7QGt/hZq5DgdqSLlLJnRJ5pk0zjxU2N7nyxX1GnDBzgzzBqcTQlx/EDoXosNxAAeFiUtVtPRX4DNlZTNnehIYB5uALz6MYzfMpeCBweVKHwAK5p2If/MoVQhEl15+cDMYjkQf9vET3g4uGG4/9ha0HHk/EdTnrIjKBWCHosQ5VHYXHjaj1hFM8/IPYmYpZhDO6wrSmNk6EoCe/umv0VruQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7/2kkLOcvrZFPVqYgvJicK3MLNn4Bve6ESzCsC3pr8=;
 b=Yx82GJECFFctpWiiAti3nFcffVaKmQNjtbwbsxV/S+0OhvSa9gTsmoiIuoiESOAuPYYoJ+KmBxrDNaIMwKppPcTqllc7QgtcA2wOeeDllo5E4S6N4lfKaQxd+svuqsg/Rv/IgARZIbhM5c8PjQFEkK0HvMeEbBGG4MBFJ1y7RH+qAUhN8MXDcFC76AWL36bW3biBJ33MMgDnuIgAACGPMoonI4SnWSbOPNgFVP8Fo6TGUn0IQdTIgfrjCnm2DIP9CwwDYIjxFfbTESGUBgnsoaGM0Q3WhQ8Xru8PZjGNNuH65bKIEAnnWounaNfnl7ELKr8x6Jw5Gj/2NR6WudoezQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7/2kkLOcvrZFPVqYgvJicK3MLNn4Bve6ESzCsC3pr8=;
 b=hjJEzSrCteAefQAlr9XbFKvChVu/cKq+C3dfgvkwxlldqKWRR30ToYorVtG78QxhxPDrJDItRbRaJshYhrNL3+FwVnzQcmM1LT21vghJnTUoZFJ6cX0aY+1nwWOGopX+f/N44pXUm24HlkJbpeJXx8/YcrfVtNSWbsELYX7IO/o=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by SJ0PR10MB6397.namprd10.prod.outlook.com (2603:10b6:a03:449::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Wed, 9 Jul
 2025 15:39:15 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.8901.028; Wed, 9 Jul 2025
 15:39:15 +0000
Message-ID: <ede6d2ff-62e5-4b82-95e7-edb683199aca@oracle.com>
Date: Wed, 9 Jul 2025 16:39:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] xfs_db: create an untorn_max subcommand
To: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303875.916168.18071503400698892291.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <175139303875.916168.18071503400698892291.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0187.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::24) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|SJ0PR10MB6397:EE_
X-MS-Office365-Filtering-Correlation-Id: b4d0cf5a-3f70-422a-0581-08ddbefec285
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2xtbnJoeDV3RVlWRXYwRVZMb2V3Ulp2K0RGUS9ybGV6MVNkTWFjaGJieHVX?=
 =?utf-8?B?MGxidTE1UGZXdXJBc29HS1hYektYajB3K2xqZ0p2K2RDYXpXM25nR0k5U2xV?=
 =?utf-8?B?cFNPVGtYNVk1ZWxEM0x5ZE1PTk5kaXVXbzU2TkxtbnpMb2dYWkxTY1Z5SzBF?=
 =?utf-8?B?OW9SMGNmVkthMUNMbUZpTlp6eHRYUFp1RW10bDNibWIzRm5ZNklNWWFTc2to?=
 =?utf-8?B?Q21maURZRTE3RURleUNqQnBoNWJDMkpZWUhPcTBmaWswTU51S1FoU1dRZHky?=
 =?utf-8?B?WnZQVm9LRjY3WjJrb2V6U3VpaHlXenRacmNHR2E4czlDQ1V4dUVlamlUd1Yr?=
 =?utf-8?B?blZheTE4M1NXb3dRTGEyWmxRMTFXUDhmWitvVUdmNEVaZHQrVWJYS0x2ZXYr?=
 =?utf-8?B?M21jUVN3VnU2cU43c21UdE5mRXQ1ZFhrSGNsdzNhUVJjd1F2OEpicnozMHNz?=
 =?utf-8?B?RVpVRzJzSWtyOW1Pbm15M0ZTMFdHNXpGa2lOR2JFWmNNV2ozZnBxT3B6VzQ5?=
 =?utf-8?B?bmFtd0w3NzZ4Mm8wZTVDMWIvdmxIbXd3anhaT3ZsNnl0dnpkNnlJbThWWFIz?=
 =?utf-8?B?N0FXL0gyWEZtZWxoMnJsQ1FTS1paSGhKNm5Gb0NXcHgyakNIZDFVU25Yc1d5?=
 =?utf-8?B?eXB4UE9GK1JxY2FPb1U4dldjQzBvclhlMkdpbXB5RGJTeDgxZzk5bGFqai9z?=
 =?utf-8?B?Z3R6NzE0YUNYa0VTZ1FEWSswL1IvU20zdUxBOGMxaE8rVHg3Tk9qZm5FODNi?=
 =?utf-8?B?cC9pMmMyQUExaDFUWjJja3JaY2pPcFBIZk9zQU5XS2hMRUV3Y280bHNBZkd3?=
 =?utf-8?B?ODRFdFBwUHdyTHo5WjlJRVp2bmtSczJQalQ5ajJ5N2pjaUJubzdua3dvdm43?=
 =?utf-8?B?VmI5Mkl6NkJsSTFPak5qcnRKQ1hURVpCMk9oZXZYZ0JLUUFmZ3piY2ZqcWFE?=
 =?utf-8?B?UWNhWHVZdWhBNlBsU1E0U0ZWbGhEbUNvUnlaUjdtVFJVSVNtSVVqUERYZDh6?=
 =?utf-8?B?ekhtMGZNWFg2ZTdhek5iYmsyVjhMQTYvWjE0ZERYNlVCQlZURUtnc2c4THlG?=
 =?utf-8?B?SjFvdVltckVSbGZEb0FvMXZheVdUQlFVd1MyL2JBM1EvSWJCMys5WW1STjBK?=
 =?utf-8?B?TkVNUHBJcEc4dy9Cbkpjd3dOblNFUk8wb3pxR0lTUG9YWlQ2N3JKMnBaYTZV?=
 =?utf-8?B?aGcyVG1IL3pGUVlVcFRGdlZpMVRDVitmdGNBbXN6eXFtTWF6YlJSZitmV0V2?=
 =?utf-8?B?cG9MSlB1QWFaU2s5Y20wSGJUS0tpUGUrM29OTGlDeFlPUW5KV0JFVGtsSkZW?=
 =?utf-8?B?RTNHWk1WWk80ZWk3ekVqdDIzVzJZNlJ0aDVFVTBGWndKSVBZZmRDalNISzZP?=
 =?utf-8?B?VGt3R2ZmTUFydnpiR0ppbTdOTnFqa2p5UWRxa3hMeW5UUHhVbm9vODlmYWl4?=
 =?utf-8?B?L3FScklDWXFqTkhTNWU2RTAvYVRzUUF2Wmduekk4SjY2bVVMdXppNlBKUWxh?=
 =?utf-8?B?MUZNd0dSZ0tPcnF4dHBVcnFFcUxWTG8zUFRVV2VBNndoUHV0Z0lxM0p6NExJ?=
 =?utf-8?B?dWd2Qm9JZGZFdnVZTlZrV1lENE1xMnN5TEZ5QWoxak9oalNnT0NTY0kvUEVR?=
 =?utf-8?B?eTllY29OdHAreXgzU2NvbXdzU0djdkFWZzN3SHZacFpaZS84aTliR3Vhd3NU?=
 =?utf-8?B?Q3krT1d2aGh2a2lnM1hjSWRvdW5hVzJmVmEzcVNvRG1LN3dqdG1wRmFqZWVm?=
 =?utf-8?B?dmwrYVd3Wm53NFV3cEtKWjZYTWY1TXZ4azRJalJvRGVBbXByMm1SZFlXUVo0?=
 =?utf-8?B?U0RwVHdFNXdOTXk5R3VrMTVMbi9VUkp3czBaaG12ek5Xb2JLZ01DaDN0MVJj?=
 =?utf-8?B?MEllQkNtZWxvV2dsbGs4dTNQVHNzeDJnaFViTk5Qb0k5Z0l0V0ZzWW1vRktS?=
 =?utf-8?Q?z3ywdPywEv0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3FuMkRjRW8rRnBTYjdqQlUrNkJrdnFhcllRMjBYbkFMeGVjYzdMRkZyaEhT?=
 =?utf-8?B?UERBTDZOb0p5bWNLOXVoejdhMUpCN29vSnVzd3NOZmE2QkQ0SzJtVm9JYkd0?=
 =?utf-8?B?bEpzVW9YWXVSZm1qVXpoUDh2cm1Ha29xNW9WQ2w2czc5eERGSzEzVVVoL3NE?=
 =?utf-8?B?UE5OcFJwamJJSlNYNjlCQWZoQWpxLzFHMGtMaTBWaTB1K1RRaWFpWG0yQWtV?=
 =?utf-8?B?MlQ4ZDB2bUxFZnZjUXdWT2FxRHdxR2VhVjhLVGlBeFJvMFU2M25zcWtIRmRJ?=
 =?utf-8?B?UlQ5UGVyRVlGdGVtVlgwWVFEV3Arb2I2UnlFTVovSlFKeVJpN3QwVVFKN2Q1?=
 =?utf-8?B?M0lrNEs5MU50V2Q0cWpObWRDQi9Ia0lOR2dhbUppRFd4S1I1VmxiUUMycEtM?=
 =?utf-8?B?M0FaNUZrOXFUNWlpWnhLTzVPbi9VR3J6a1BuZlFOdXZicUR5WVFoSmZLVXJt?=
 =?utf-8?B?T2VxT2ZJcU9FVEh1dW5zdVFWdjRDVHJkcVJGMnhRbGp1S1hmczh1aUV4cTBU?=
 =?utf-8?B?YXR5QXc3ZDVlbHJEQlJjL1ptQTJPbHE1UlI0ZFk2OHBXcTN1SHpTVzROcklF?=
 =?utf-8?B?S2pQOHVPNkZJQllQVG5WRFloVlB2UllsVmh3MUV2c1YrUUtrNUFwcC9BWWph?=
 =?utf-8?B?N2lTNkRDUm9yKzVidkt2WjVvWmVMU0NvOVpuSEFMaUVDNGw1L1dsdEtneFdJ?=
 =?utf-8?B?aE5mcHlMYkZRaCtDc1BUN3ZycTF3eU9NSXJXY1JBYnc5cEZxWkZMSWFDWHV2?=
 =?utf-8?B?VVpOK2JlQkU3MXE1L2tLZUF5azgzQlZuQXpRMXlXTU4zYXQvcFh5RDhCMEdZ?=
 =?utf-8?B?TTk5T1NWajZFdUZudEZzdmV4SEwrakFZcDZFYkxWbG05YTBvSGNhdndrVDlW?=
 =?utf-8?B?UU5FSzArb3dvZlFsekpwb0lzaWl0Y1F1TUxPMHdaTTlab0lwRy9hSndZVWN4?=
 =?utf-8?B?cmlGcWdqN3A0dnU3b2ZaTk1oZTg4MWNza0tRbjZxTXp4QjRaVEIzUHVmL0JU?=
 =?utf-8?B?RFVxNTZYUFVwSFhHNkVUaDFpTWpma3BYTm03SldZRDlhd1Z6Lyt4VXA1a0li?=
 =?utf-8?B?bmQ2Q2xwM2dNam5TU0gvdTFid08wTzQ2Uy9tNStPSVRMdENGcFZYVTgrY3JC?=
 =?utf-8?B?VEZTU3FrSlRVUFo0OURSbVZueStCOVRKdnZld1FJdklKdjFMWlNUODMxaEFy?=
 =?utf-8?B?akluQjFTaUVxZ3ZuWVVnRFVOSWxsbGJYVzdhUE02Z2IwL3ZyT2tYYjM4Sjh2?=
 =?utf-8?B?MFgzNDR1UW4wWU1hWTBRaTEzOHd0NU84dXprWlJrT3NNNUxCY1JZSytTSDNS?=
 =?utf-8?B?a2tMc2ZRa3dlY3pCdDhldFZIV1M1ZnpQZnprMHFQaVRyRStRcTh2VHBwS3RL?=
 =?utf-8?B?LzE2YjlvYUhOUDgyd2RqcGlnREV6MVRnNDJPUWxCNWR3OHR0NnJFcXMwWlh6?=
 =?utf-8?B?cko2SXhvSlorS0JwMDhySzQ3NWxnSm9GL3A0eHhGZThVbFNhZUdHbDkrVTFl?=
 =?utf-8?B?VkxYSU51MHRuVUpwbUQwM3VsRGlwaitaMktjT0JibmRwZVBYd2xNRFk1eW1J?=
 =?utf-8?B?b0ptOVV2QVZEeXlqS05iUDlLMUtkWllDdVZEN05Ya000dE9jRWZOVi9QbkJM?=
 =?utf-8?B?YU4reWcxaVkrTTRvUlY0NkdXMDRqQUtETWRrT3BjUnY0bERua01zNHNlTXlC?=
 =?utf-8?B?WWQ1UkIvZ2plMDIvYmdQYVMxODRyTGZIWkh4eGJ1QTVIVlNQVnFheUtDV3Rh?=
 =?utf-8?B?b09uS3BKNEJuOGhpT01MSytXeEZ4dlhGY2NQL1lYL1RZTkhDSXFZU3V2dS8z?=
 =?utf-8?B?Qmx4S05iWUFZSEVtYVRPR1gyZjQ1dW9EeXdMeGdhV05uUjJWNWNPZWhIdksy?=
 =?utf-8?B?MjJsaVRYYzA3RGtqTXREYUVrVzdGSnJqRDRwcjJCaFVlQ3poaVdCSlZ0U3NI?=
 =?utf-8?B?VnNFL3ZOSDdRSFUrK3R2MjlFTi8rQ2t1bEorSmhrZGw4cnlEWVpxQk4rVzZE?=
 =?utf-8?B?OXdJS05lRmFpaktuSlowbFUxM1didnZjZlB5RzZqQTN3cXl1OSticXZzazJ6?=
 =?utf-8?B?cC9sZEpBNlJQc3o3QU5ra2YwQTdrMXBEYllsYnYwSlhWSnNEd0N5cGNJNUdH?=
 =?utf-8?B?NFdHYnBmeFJRdlNoNUtSbVZIV3JSK1N3eE5jOUk3RmRjeHdSOGxQZHVKSjJn?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	51/QVfxZ9+xljfyKSiDBT12MuAtMB1GR9/T8VWK1YL/PLxYc5AZ57ELoQ5ljIAjSyxM+S/NuHODzb484BqbkKULlBRekObpXvqKxpp6ubQ2bx5TTcbvnWT5cdBc0Pa0SSBoIZqhnb45kWGA+0O7EYZFLpmi5vG1Uh4sAgGe5JubxoKdAAEiUQx3LgAL/ZWhtJdznqw2XejxGDbgqYvDgBtd7gvSNmh2CmPwgWUn/u+PB5Gz++e5JlfGSAh2BwstUZw+muo2PeBIoXhrYIYZY95EH93OSMl+/pMpBAtw2a0R1iGbSbz03/3qrTmDvc7W7yx8QiodhXld1BnkMQII2LywJc56qz+iCfSZoLOYvl4xcmhBH6HUM6C6fmCI1EooTLWmSbu9Ll7VKBUstRxtAU5pL6OznSZUyESOqzqmj3og6aoM+lFYMoWZQr8MCKC+Kj/8JPIupnVA32I0G0p/LNbrxio2rvxhOkxBV5MIRg8Mm2mX0Gm9yggPWNh4pw4pTA9juLygNZURI+qdPUZozCfY5LUDqrg9bXB4hOWPO+d3hekjblVY/rhrsSlwEDvdBzyrWl/U7lcxEQqS/sdGhvHT60KYlT+CBs1LUQ3x7rhM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d0cf5a-3f70-422a-0581-08ddbefec285
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 15:39:15.3823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXfZ3EJssA6oqKK1H/0QV/kwaveOpOAs9I7S8tEubpsiVMp27ykbQrRa54UEI6ewQ470+M2O9v1qLUkBrRj/EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6397
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_03,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090141
X-Authority-Analysis: v=2.4 cv=PbL/hjhd c=1 sm=1 tr=0 ts=686e8d27 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=vlUwcTED3fhSdHojOzwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: rL0AkeWe_MEb8HHzUVEV0SLpbHiSWhk-
X-Proofpoint-ORIG-GUID: rL0AkeWe_MEb8HHzUVEV0SLpbHiSWhk-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDE0MSBTYWx0ZWRfX3NnRwXpGHX1V iTWFSTLCK5LXCQUG9YcLeyYIoPBr/hlcWrrkcuBrjfi3Kp3bwvw+CfxJq73vkiLPXFxr057rnKv cjzP7VdKmiArhd5aX0+qRgCWZHrLYwRR2S79HmkVWdUn97B1WXeViY/W19nOMpApdCFHTRF9UBX
 BxGylVNKOmcAK2O7S6Zh4QWpecgp9rJgOhsio/cCRSmEb49l3tBFFnYaWywms9cqT6SpVe324OP WRg0f5VgCsodpHZ8dILgyCk1Yuu/V4dZbUrT46ccQ53AP92MuwpgoT6ypLBpPRX0hp0Y3bjN0aJ 3O5Qc0GjhcVKL8nWtUo+ZJoHk7YJkFtziun6qylRzS0c+e6B0561YfzylJK0pNzGY0D5bfhXy9Z
 wJ1iaZfNnG9WlDcJf0wZ26I9tmVszoxKft6Z5vxoXnyErk0b6mgvr2RWN/dvRGa7bWnlnP1E

>   };

Generally it looks ok, just some small comments.

If you are not too concerned with any comment, then feel free to add the 
following:

Reviewed-by: John Garry <john.g.garry@oracle.com>

>   
> +STATIC void
> +untorn_cow_limits(
> +	struct xfs_mount	*mp,
> +	unsigned int		logres,
> +	unsigned int		desired_max)
> +{
> +	const unsigned int	efi = xfs_efi_log_space(1);
> +	const unsigned int	efd = xfs_efd_log_space(1);
> +	const unsigned int	rui = xfs_rui_log_space(1);
> +	const unsigned int	rud = xfs_rud_log_space();
> +	const unsigned int	cui = xfs_cui_log_space(1);
> +	const unsigned int	cud = xfs_cud_log_space();
> +	const unsigned int	bui = xfs_bui_log_space(1);
> +	const unsigned int	bud = xfs_bud_log_space();
> +
> +	/*
> +	 * Maximum overhead to complete an untorn write ioend in software:
> +	 * remove data fork extent + remove cow fork extent + map extent into
> +	 * data fork.
> +	 *
> +	 * tx0: Creates a BUI and a CUI and that's all it needs.
> +	 *
> +	 * tx1: Roll to finish the BUI.  Need space for the BUD, an RUI, and
> +	 * enough space to relog the CUI (== CUI + CUD).
> +	 *
> +	 * tx2: Roll again to finish the RUI.  Need space for the RUD and space
> +	 * to relog the CUI.
> +	 *
> +	 * tx3: Roll again, need space for the CUD and possibly a new EFI.
> +	 *
> +	 * tx4: Roll again, need space for an EFD.
> +	 *
> +	 * If the extent referenced by the pair of BUI/CUI items is not the one
> +	 * being currently processed, then we need to reserve space to relog
> +	 * both items.
> +	 */
> +	const unsigned int	tx0 = bui + cui;
> +	const unsigned int	tx1 = bud + rui + cui + cud;
> +	const unsigned int	tx2 = rud + cui + cud;
> +	const unsigned int	tx3 = cud + efi;
> +	const unsigned int	tx4 = efd;
> +	const unsigned int	relog = bui + bud + cui + cud;
> +
> +	const unsigned int	per_intent = max(max3(tx0, tx1, tx2),
> +						 max3(tx3, tx4, relog));
> +
> +	/* Overhead to finish one step of each intent item type */
> +	const unsigned int	f1 = libxfs_calc_finish_efi_reservation(mp, 1);
> +	const unsigned int	f2 = libxfs_calc_finish_rui_reservation(mp, 1);
> +	const unsigned int	f3 = libxfs_calc_finish_cui_reservation(mp, 1);
> +	const unsigned int	f4 = libxfs_calc_finish_bui_reservation(mp, 1);
> +
> +	/* We only finish one item per transaction in a chain */
> +	const unsigned int	step_size = max(f4, max3(f1, f2, f3));

This all looks to match xfs_calc_atomic_write_ioend_geometry(). I assume 
that there is a good reason why that code cannot be reused.

> +
> +	if (desired_max) {
> +		dbprintf(
> + "desired_max: %u\nstep_size: %u\nper_intent: %u\nlogres: %u\n",
> +				desired_max, step_size, per_intent,
> +				(desired_max * per_intent) + step_size);
> +	} else if (logres) {
> +		dbprintf(
> + "logres: %u\nstep_size: %u\nper_intent: %u\nmax_awu: %u\n",
> +				logres, step_size, per_intent,
> +				logres >= step_size ? (logres - step_size) / per_intent : 0);
> +	}
> +}
> +
> +static void
> +untorn_max_help(void)
> +{
> +	dbprintf(_(
> +"\n"
> +" The 'untorn_max' command computes either the log reservation needed to\n"
> +" complete an untorn write of a given block count; or the maximum number of\n"
> +" blocks that can be completed given a specific log reservation.\n"
> +"\n"
> +	));
> +}
> +
> +static int
> +untorn_max_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	unsigned int	logres = 0;
> +	unsigned int	desired_max = 0;
> +	int		c;
> +
> +	while ((c = getopt(argc, argv, "l:b:")) != EOF) {
> +		switch (c) {
> +		case 'l':
> +			logres = atoi(optarg);
> +			break;
> +		case 'b':
> +			desired_max = atoi(optarg);
> +			break;
> +		default:
> +			untorn_max_help();
> +			return 0;
> +		}
> +	}

 From untorn_cow_limits(), it seems that it's best not give both 'l' and 
'b', as we only ever print one value. As such, would be better to set 
argmax = 1 (or whatever is needed to only accept only 'l' or 'b')?

> +
> +	if (!logres && !desired_max) {
> +		dbprintf("untorn_max needs -l or -b option\n");
> +		return 0;

similar db command handlers use -1, but I guess that it's not important 
here since you just rely on the print message output always

> +	}
> +
> +	if (xfs_has_reflink(mp))

this check could be put earlier

> +		untorn_cow_limits(mp, logres, desired_max);
> +	else
> +		dbprintf("untorn write emulation not supported\n");
> +
> +	return 0;
> +}
> +
> +static const struct cmdinfo untorn_max_cmd = {

it would be nice to use untorn_write_max_cmd

> +	.name =		"untorn_max",
> +	.altname =	NULL,
> +	.cfunc =	untorn_max_f,
> +	.argmin =	0,
> +	.argmax =	-1,
> +	.canpush =	0,
> +	.args =		NULL,
> +	.oneline =	N_("compute untorn write max"),
> +	.help =		logres_help,
> +};
> +
>   void
>   logres_init(void)
>   {
>   	add_command(&logres_cmd);
> +	add_command(&untorn_max_cmd);
>   }
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 2a9322560584b0..d4531fc0e380a3 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -1366,6 +1366,16 @@ .SH COMMANDS
>   .IR name .
>   The file being targetted will not be put on the iunlink list.
>   .TP
> +.BI "untorn_max [\-b " blockcount "|\-l " logres "]"
> +If
> +.B -l
> +is specified, compute the maximum (in fsblocks) untorn write that we can
> +emulate with copy on write given a log reservation size (in bytes).
> +If
> +.B -b
> +is specified,
> compute the log reservation size that would be needed to
> +emulate an untorn write of the given number of fsblocks.
> +.TP
>   .BI "uuid [" uuid " | " generate " | " rewrite " | " restore ]
>   Set the filesystem universally unique identifier (UUID).
>   The filesystem UUID can be used by
> 

