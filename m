Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F444A0C;
	Wed, 16 Oct 2024 00:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037520; cv=fail; b=LTKz+AYmgQqk7cddVqSXFWD5SMaTrNoWLpMo4pNrzagDQa5GcMcazZY9jLVqNWgDdkwyCpzwdumaqImKmK18n4fYJ3Xopv33NodIkgkvHQcIp7nfYbSwtz7cnf1zVe3yz9jkGMn8R6TpE//XVg6tQx6rFLcXsvoOZ8vJjJadUpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037520; c=relaxed/simple;
	bh=C+pIhWoelJI1EPAzuplYKlpklWBu7elT7ZEhj1i0R3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RGEgovzJjt2WqARRgDrIYI2tb03W5ApT1g8TVOPQhRHFAcirOyJlmuCXv/hp6yQ1w5kV/0Tqc4ASzkHV4Af99e0k5/DYIzP53tLf1AhAEhDC0fmXDXXLbj++MG+kqOfJZCO4R1j7a39qPlS9BaZCb7YZBbpoZ1DAL8ka+YK/Z6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bitKbUMT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g4HVavCx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bitKbUMT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g4HVavCx"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtejU011672;
	Wed, 16 Oct 2024 00:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=7y1+i1Y2dgMCLROT7pwXwTtseKVvwAZ8jqUHJDtlhH0=; b=
	bitKbUMTDsS4OIYyVDd0nv8WGxVeaeHvMg9cfG5Ss/U0lpT8mGGACb2mFszlJDmK
	3E6RZhJM7heaLcvJgbuIQNN/ndZhefCP62ZXFqr3mVHPmKX06xEB8zmS8x8uGWMU
	KlNjAIhET/af/6KbatxwPdo9OMAP2MwORGwuoDCnGWoD11KIcTKnhomWVtdJEgER
	+iz7wvdSTtpuydClEIxkqaclGp+AnkUz5SR5NXyjh6Bfau/PBj48l1UkinINn7xF
	KBjJ7T7jC6TG+rMzzgSwMQRAEQIx1/Vh7VbyL6AuuJoguEnSRiXRGACnbh8Jczax
	bM3wWvPwHKk8cLesaFYYjw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gqt2fp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FMHfnO019918;
	Wed, 16 Oct 2024 00:11:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85mf8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wsldP4Zfxd90cdkREmD0k/7JoxgAmShEXAbGaSwV8iFWHQogS+SMjGxqLTr3byoNX4sm6u7fp3//n5KysWKOTHLirMFu1Bjydx9HPhvt6MCa0aT2E6qeaQQA1tEp8fLtRUwQ1Sv+A/HP3MpJAtJNgctKIZyLdV6UW0PrV3oDpcGBp9U/jIPjQm25998koe7JZov9BHlNHsA/BGIoOt+4bkSab4cpb2ia+kIuGcw7BW/ZIqyMhBGFgQYXCDzIGO2JmYNiprMU+AJcY8pgK3i/pGZsBBGqYLizNCpHnVVbtDvfoEl6BYKhDKQgDbiIZj0BB+o+cA3PaCYVToZaKjhEnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7y1+i1Y2dgMCLROT7pwXwTtseKVvwAZ8jqUHJDtlhH0=;
 b=OPbE6Kv4bF2Q8fmkpKpWlnNK+TEWONSJga28Neeod+1+3aftB7MHn0ooUheIy/OoV6n/4WmXhewBk/p14Hvx+qsrGmDRW/bTc/yDKGXfP/2qmcKAWhKqBK6r/IK2V//ibESq8RUeGaynz3sEJs1bZ/N7L3ALYBSRmFdRECIKmFp270WWmp/mfzSA5kqZI6Gv5RYo0TVIv7Cr4wIGSh6CTfBAY9i04qNZdGOuAZGGaltJRgeV1QNn8uoawhXdRrbv52sy6AFSWb5LoZh+wO4Umb0TLFLOaKl/YWv6/JobXpNmdw0FaC4okJkxdbQzfuUy85VH27/6TumzAiucLyNgpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7y1+i1Y2dgMCLROT7pwXwTtseKVvwAZ8jqUHJDtlhH0=;
 b=g4HVavCxfYWf/d27WIBi3dw3W1/QkieeSlKUT89awH1grbjT5nXa2tljXLtsEt8FLj9Mr0pA1JNBQarEr7kZ7+qvHm+K/EbgMIdcl9ll9tp5PZXhe/bFue7xzW9IEFB5j9X/pNo1j/nGgXm/GyjgSQZS+Sb3Vqtw8N63GoN4Z3I=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:11:51 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:51 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 11/21] xfs: use dontcache for grabbing inodes during scrub
Date: Tue, 15 Oct 2024 17:11:16 -0700
Message-Id: <20241016001126.3256-12-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0209.namprd05.prod.outlook.com
 (2603:10b6:a03:330::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 9688d855-1ab1-4893-0ee0-08dced772235
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t21StTl2+d2X/g3TaqRk5w6W6a8ak+vKbZNyqJjSjsgUNHmwzjgV6NQxq78K?=
 =?us-ascii?Q?sfvujN9PsPxQOJqqtq9pQAyoLAL6cC9TT6EKiiYf4WgdXs96cHuirgvOlc/8?=
 =?us-ascii?Q?8yaFO4XssHyNpMuuzIRxKTomHq2HDF4S2j4Nv96J8Lt5MSR9syutJTS2e9Qd?=
 =?us-ascii?Q?zwlddwa0R5v1aJnaiLroACeb6d91jZaBks/uB98oaLZiB6OHDjMRj0nytSh6?=
 =?us-ascii?Q?JOQ+qe6EX9PSej+UVzmnQQ87pTMYHjyN75PxflFNUqdtUj8Kcs9vYiZBudMB?=
 =?us-ascii?Q?oKjvXvthjGfcDA6aQyFTJCcHizIXFyMs1CIMIZiD7FPefeE1HUBHMSmsvWqF?=
 =?us-ascii?Q?WVecxz21WOKKt3ONn2mf3Wakt2Mc6YLXShRofVqkY0DlvYqLNVVc5ODRjagC?=
 =?us-ascii?Q?Lu7yakxGtbGwoRABQjkotjNNRF3m0hpa5mTDxOmUW1WwtJB7qyCoA0Pm1rvM?=
 =?us-ascii?Q?nQc4uptPVHx1P4GnEAk3PE5r1eKxYMvGwOQG7kv8IYPCeKmqPDzwZQF82ELO?=
 =?us-ascii?Q?j4wiirDtnB3v23LC0fBU8S7IjOwd8r/pajtWkZUK48bMZPPVsAK6ex4L7wVO?=
 =?us-ascii?Q?R+osQf14LEcPV/pVTuVE2FIQp/3PLrV+0Yo8tGcRf/AadLRBY+mV+f7CnZlW?=
 =?us-ascii?Q?vgdvu4k7NFfwiB6Bjc4gvr3ujAtLyPomYniBXlp7d/sCT/1cT1IVcwIPvHU0?=
 =?us-ascii?Q?oqullxL84Q/8VLu8gEEEQ++UdeRJ+GH8FvMbzWezhQ5YKZO45laNn9/FVpDZ?=
 =?us-ascii?Q?uGHNQr5+gnP8X9nOnu+5DZVt+vytdxoJ31Yxn3u0bHwZwGkzSgdn9g5Me9+J?=
 =?us-ascii?Q?iItt3HGtBpwhKe/OJazS54FisfAfmxdjJ8oEdYBcABmKkHz49rHgMbwgqzED?=
 =?us-ascii?Q?hqD3E5LVSgunsu+w80NxmwqsKFohCIGLO7fesTPDq4jqOR8PUlU/3eJarxGM?=
 =?us-ascii?Q?To5O5gnhfVaH34RmcQezRjd2q9NTtK3WLm5YNWcBYXnCo+H2CvO4D8QmCKRB?=
 =?us-ascii?Q?S31Z4wB0vg1TZCTF0+gOBAtAQ6i+mAFe4u5ojl/Kkf3kaTT1YeEggaiyZHE7?=
 =?us-ascii?Q?q4637HsbwxN3KgKAqqrSmzrdfrK7NlLsfgVn5/T38bUGs56W7qpB/LgLLsAV?=
 =?us-ascii?Q?lpvQnLForVCQ3ttK4hK5tYIUKEMe63599s9GHz/1AVCY4LtG4ch1uxanzalG?=
 =?us-ascii?Q?cdlHB1rWQPSDbTxH7joI0TAjY/vtIg7ZJ88mBqsPDsqxkvG9LS58ThX75Cuo?=
 =?us-ascii?Q?eHPmHEY/APFnmbRsuwWxP8/BOmwJWS9nOWkNhMcGmQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ciEdlDVnUj+2in1k8w1JapDAPMHWmp+dYFhUiWYjV0UOkqHSYbLwpv9Y6V8M?=
 =?us-ascii?Q?E9rEUQt3A1VuQNcRL0wylS1j8Dh6w90x86S/Ay+sgbmR3ApmIAsavUrck5uE?=
 =?us-ascii?Q?aRCHypOEtgAHp3KB6NQq44AgRPj6wT4YQzKBYXXawGtnnBxG/CglfRqx+hqk?=
 =?us-ascii?Q?HmTaFD29Wrckcu3gPOuXPHGywvx4wqDsUhbKKtJlnG4sl3PlTD7PchYrfHDp?=
 =?us-ascii?Q?qd46TtXqyeLaJUoPcGBaDoqMgYDUNAmrrt4Ue08E8OJFQw0kX7TxGf+zoMIi?=
 =?us-ascii?Q?HS8pWkxr2/Bv8NJNCDa9I3nv+S/7RveIz5MU23O0fJpM4Bpuevyldh57Xjdf?=
 =?us-ascii?Q?NyIyGs02c6D76KNqOFv0P1+n0vwJSJhwu5u00/6uEEaYut9kxgVso1+Q2loY?=
 =?us-ascii?Q?KnNxVtJPhm7Pl1gjA8q0UrH49mUaLtQfjFNOx4eIrFIFS17wgZCrvwSJGOdY?=
 =?us-ascii?Q?dOBabAYO0VzEzhUKgx9xhEbiIiiTT4R1emSbRMA8IWagmm+tDkB9yzKyxlfW?=
 =?us-ascii?Q?Xd38DXzdIEWzW5U0PEiKPrkagONufGZVOdVUj0unuTZRCtutaj2wMqWUgEDM?=
 =?us-ascii?Q?XwzV6v59mxuP4B6eVBpw0tJQ1q24XxlZmGDdiMnmFlBj7LJgEB8YX/PKgHN1?=
 =?us-ascii?Q?hEFFjj3IM17dggTqVa15HqgPs1a+u74jA7j5OSN98u7sCs6umMcN3ZjHHfZX?=
 =?us-ascii?Q?8ckMks1gElCcJEFcAAeE/PyOLKcKYfbtzweBbQ60AjrIACIDo77i3huLCKuq?=
 =?us-ascii?Q?VFf3zfyq8HwTLoFDpwd0A+62ZX6C6jsSlj0kKbQKvyIXLVn4iVRs0kcWEOoe?=
 =?us-ascii?Q?COIf+K17Tekl05Kl50Aw6SwmInBWjkciSenvOo6vEaGhCFowddCnMFGQ3mPG?=
 =?us-ascii?Q?9Rd+lxPq4VkQZGZRpKjRR1VZpSJrrkAwzSdqfY1Pkqe/TL1jKbtKRgZQBqfc?=
 =?us-ascii?Q?T50xYoeqhyp1p7XxSuY3er7KO4tnOMGjW0vLdxksOfuGUy5EaifB05IdMvNe?=
 =?us-ascii?Q?6W5AvViL49Ht4TwmxzR4T5S5N1az46r8JLfnuocbL7vJE4APwqitC9EUXR2T?=
 =?us-ascii?Q?wqTmWOYRdUGVUR/yWHEC7SovyfbYORykNy8Iezu1J/eJHG1wcojHVOquGS9t?=
 =?us-ascii?Q?Qtpfk2mh9MfyNlqPol6rqMlyb2DC0Ku2eVdGZr+XhDSZwbqVynrS6fgk5G9D?=
 =?us-ascii?Q?01XSvb/xM3+nE+ECxSMsFKqk7Ve07Vqi/zp/cHJ5ZQkzZLuhLAMLzy1g36As?=
 =?us-ascii?Q?Sw8FK2n2vfwmPdBreFJYkAAmYMhs/aduWfOFPjtZ3x7rceaRFVbkcH0zlns8?=
 =?us-ascii?Q?ZhmS3TD8XYx5ClAyB66xt4jztoFx4NvUP3Gr3scbE+Q/fixlnhqphyMTPf3g?=
 =?us-ascii?Q?Y6tvqr357D/TSL6zrlgcz+VKEUHvgr05SwAkd8O3z4fRyShP8WRNfrMBOYs6?=
 =?us-ascii?Q?a+1z3fN0U5V+tbzi6zW24LzjMNukUu1J/LkGO/T/XevqywXInFtc8Vcu0qgn?=
 =?us-ascii?Q?JRkCqwdr4qZM+SbCEVMP76Klk72/bcukcW/9Q2slRJR4fwuUiEsBLvf1cEnt?=
 =?us-ascii?Q?fVi8AbMOrCDvVf/mniFfHCDHBP1lSmxNbLpFppPgyWqW4zZmiPaNle1b1/ZQ?=
 =?us-ascii?Q?8+07hfm6qIViTlna0w23/zwfSJhHF5ruzicNasHI2sBDzi/hRHwVllqd0S9u?=
 =?us-ascii?Q?MpG4/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	leXvvuk+UDFr1i0++iVPpzaiZNw23d6aTPg2NyB3lfsSEsDZCRuzL5RkoTS9hPVAG/61swLvwQeh+qb24gRDqzWBGhctIPsGIuCy4tGBTplWSV2HgupuhwMTSGIucY5ut99WCOA/oozu+CUry5HihNXfcHP9+n/GKP9DB3a3BRN4Gl+wasTlqy3DMklJym7hOdlaeTs4Vg9ThVbWQgzo/cE5A45xjZjkgS7NpJNmPn3GuAFIyz2wmZOpLnhlGhpT95W7SxRVX6sBW+8QMo+ADIw/pvsLucauQJqWi5Dhj1DlsAZYWql5X7wZEfSzINSMmWL728Vk5TbssAq9ZhDSNlHCwD5J9VwZV0A+C7BHBExnUgQkKK1DxwwvOH4WJ4vQ4IKNQnmvodij7ASaydC7C/WiXW2IbNDCsWuKgkSMa9lUEtRZ+/1RaD0bEzoa4WeneUNyShRhODmXcbHMJxRhaKw0oWNHbdGKyrifuMBinDMJJzUTBYytkzCm4bPN1b8A79l58YtnhyLRaYIciTw74xZP3n0FcSV+B5zOza7zDl4tv1cDrjpgCOwmZuybY+jPPVTK1us+GZ1zrqap0LCwDvthSKU8rJiuP1Crh0i5LI4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9688d855-1ab1-4893-0ee0-08dced772235
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:51.1800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mc2c0DETJlrl6WNZTi6BZkTBFV8UwiS6C1I2akidwm1ermMctHVg3y+Rd8BhpLDziejo1/T/QmXTZq+ci6K9DVPJ7dVTKyEIASDLyhvtHuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-GUID: b9fnZghc_V9ei7mcuznvRO_LaK2QJcbz
X-Proofpoint-ORIG-GUID: b9fnZghc_V9ei7mcuznvRO_LaK2QJcbz

From: "Darrick J. Wong" <djwong@kernel.org>

commit b27ce0da60a523fc32e3795f96b2de5490642235 upstream.

[backport: resolve conflict due to missing iscan.c]

Back when I wrote commit a03297a0ca9f2, I had thought that we'd be doing
users a favor by only marking inodes dontcache at the end of a scrub
operation, and only if there's only one reference to that inode.  This
was more or less true back when I_DONTCACHE was an XFS iflag and the
only thing it did was change the outcome of xfs_fs_drop_inode to 1.

Note: If there are dentries pointing to the inode when scrub finishes,
the inode will have positive i_count and stay around in cache until
dentry reclaim.

But now we have d_mark_dontcache, which cause the inode *and* the
dentries attached to it all to be marked I_DONTCACHE, which means that
we drop the dentries ASAP, which drops the inode ASAP.

This is bad if scrub found problems with the inode, because now they can
be scheduled for inactivation, which can cause inodegc to trip on it and
shut down the filesystem.

Even if the inode isn't bad, this is still suboptimal because phases 3-7
each initiate inode scans.  Dropping the inode immediately during phase
3 is silly because phase 5 will reload it and drop it immediately, etc.
It's fine to mark the inodes dontcache, but if there have been accesses
to the file that set up dentries, we should keep them.

I validated this by setting up ftrace to capture xfs_iget_recycle*
tracepoints and ran xfs/285 for 30 seconds.  With current djwong-wtf I
saw ~30,000 recycle events.  I then dropped the d_mark_dontcache calls
and set XFS_IGET_DONTCACHE, and the recycle events dropped to ~5,000 per
30 seconds.

Therefore, grab the inode with XFS_IGET_DONTCACHE, which only has the
effect of setting I_DONTCACHE for cache misses.  Remove the
d_mark_dontcache call that can happen in xchk_irele.

Fixes: a03297a0ca9f2 ("xfs: manage inode DONTCACHE status at irele time")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c | 12 +++---------
 fs/xfs/scrub/scrub.h  |  7 +++++++
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 08e292485268..f10cd4fb0abd 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -735,7 +735,7 @@ xchk_iget(
 {
 	ASSERT(sc->tp != NULL);
 
-	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
+	return xfs_iget(sc->mp, sc->tp, inum, XCHK_IGET_FLAGS, 0, ipp);
 }
 
 /*
@@ -786,8 +786,8 @@ xchk_iget_agi(
 	if (error)
 		return error;
 
-	error = xfs_iget(mp, tp, inum,
-			XFS_IGET_NORETRY | XFS_IGET_UNTRUSTED, 0, ipp);
+	error = xfs_iget(mp, tp, inum, XFS_IGET_NORETRY | XCHK_IGET_FLAGS, 0,
+			ipp);
 	if (error == -EAGAIN) {
 		/*
 		 * The inode may be in core but temporarily unavailable and may
@@ -994,12 +994,6 @@ xchk_irele(
 		spin_lock(&VFS_I(ip)->i_lock);
 		VFS_I(ip)->i_state &= ~I_DONTCACHE;
 		spin_unlock(&VFS_I(ip)->i_lock);
-	} else if (atomic_read(&VFS_I(ip)->i_count) == 1) {
-		/*
-		 * If this is the last reference to the inode and the caller
-		 * permits it, set DONTCACHE to avoid thrashing.
-		 */
-		d_mark_dontcache(VFS_I(ip));
 	}
 
 	xfs_irele(ip);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1ef9c6b4842a..869a10fe9d7d 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -17,6 +17,13 @@ struct xfs_scrub;
 #define XCHK_GFP_FLAGS	((__force gfp_t)(GFP_KERNEL | __GFP_NOWARN | \
 					 __GFP_RETRY_MAYFAIL))
 
+/*
+ * For opening files by handle for fsck operations, we don't trust the inumber
+ * or the allocation state; therefore, perform an untrusted lookup.  We don't
+ * want these inodes to pollute the cache, so mark them for immediate removal.
+ */
+#define XCHK_IGET_FLAGS	(XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE)
+
 /* Type info and names for the scrub types. */
 enum xchk_type {
 	ST_NONE = 1,	/* disabled */
-- 
2.39.3

