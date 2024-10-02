Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3611D172E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890910; cv=fail; b=TCWBzBO4QMx8GvNNv26C7iWPKFFPk4WlC2bN0N586uR88SarR6aEnl0gacigUlQAxCMTTBkeeG8N1cwNyaRh4ZyncDFQGtSbf+z9rE25O+djUwLMU1JttxdShz8wszaVoX4rDwI/aihHBftRecT33IB9eFzB8uzK8qDmjKDa9Fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890910; c=relaxed/simple;
	bh=SRIlL4xgXmRXiBOwWWi1VsEk+x3iHxH2LFfvZwedhAo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X+amOIjjv2MrFJTpiSXdloTUpZNS9nNUAhIJuxfiXuU0JxmdVES6wrcZOLwEHfUrYDrZPtwS37G+1autWXgFaEwJKZrf9iZT4EPKNUGDf5I0O6vr9KlokmJ5RGBlk3iFnTKp/M7tDK0tQEKCYVM1xJ40adwaaoOoA8jFo00f7DE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Iw/fMsuz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Wn+cZ+Eo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Iw/fMsuz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Wn+cZ+Eo"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492Hfan8025055
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=daYqU5HBP1jUzvPrbHscg9YPGF3bZmAUiZqYxWk+Cq4=; b=
	Iw/fMsuzg4ezg24H4yEBi+NqrAo75t6j3LClR+GTdTCH6c7O7YU3WsZF1nujFEyf
	JUQejtN2O3VeFzOEswhS/Lm99wucb3zR+rK6J3h5v6V4ED1tCmLPmR8rsE8RIvXr
	c42IBQKTF3hMRJnRr9dJLE40pHBPSMuia7W2szociqme2g1VhOMN+FkeDeBhkeHl
	dr51ePQeAdhGNGosPqCEkxv8/Y8kjrPKk3mqLjICR7+/v8w1L2aMkZCJIzk4UqLU
	1O2UBnuCgeU5LNRDNe8QwhI+klXJvrxkQvxtUmvpR0DPfOXNK57Ap+3oNzufzieV
	DMUcsCu6JvBlDSH9wgfnIg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9p9t3ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492GSYYR028430
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:47 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x889d4cc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TyZxvr9tHkQ6bSthTJtvz41qnHtegxfBzu/VG9p7/O25MVenr4GabOlwpXMxwfREvGVunKCiHEKqe8cszLrGcr22KzXxQ3m8Hg+sGMhwvPdXUMmKFBt4SC6WeZlOm+2h/xETMzqEImjQYOwZGQiINQePY8lwzpPMkoRSzSJTsU2fiNpoAuavUa/tU3HWM/5TbnsDI8A4E1YyYECdNlLl6wxgSHr7rCJC+dSq6pdH+5pbwDNXyTv0XUEhg/+THL8qsQ55sFRvZXxfKzp5LVX6InSM042eJ9WPedmkf8we4NT9XcFBAtBeKuh6pBLuD5vyIbDuf/XH4bOhoCynG2sDXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daYqU5HBP1jUzvPrbHscg9YPGF3bZmAUiZqYxWk+Cq4=;
 b=qS3H7ipFKsAvews6v9BEqDYiIjz7Du8E5S4tGxQEAJ/+kEKPSMmuFPni8N2NK6Q/pDQuo28mkP2FmhOecC5KnL/MyNdw1YbGvTQUiEPATwZ+841EXDzrLB7kw+wV9xeCmxGyUMtoRGVPHnayiR3ZT7qpNsIolS5OJTFcHvmn3XN5W3NBMp4O/nhdLBsy1OTDV8nAFsUo4oS5QsgTOkZoYRriWVArBorwN6kF7B9xV8Uw0zGVNViVgObHt1y7OtIB4OaS7xCQnfFt5SM+Fs5YHIKGkLmmjzBb47/kwfjsK4LgjCXTkLRrwIjVpIHVuFK0w2/2OaaOFbQ4+cL6zTEllQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daYqU5HBP1jUzvPrbHscg9YPGF3bZmAUiZqYxWk+Cq4=;
 b=Wn+cZ+EolQ6GRJD5quRHC0UyNTATqStL+zE+gPWQv4mBJA0ioor+5ShLEcol5zpnML9lzf9nERcYkLFbhO8B8VAOY3P8/SbbD8Jjwy4ukcH2dxEVcwBji197VX6IxofDCvuRO/PNglt8ELDEfDGWL7T04I2iQecdvTp64DdaPQU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:45 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:45 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 18/21] xfs: fix unlink vs cluster buffer instantiation race
Date: Wed,  2 Oct 2024 10:41:05 -0700
Message-Id: <20241002174108.64615-19-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: fcd692b0-eb80-4753-af1c-08dce3097b9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NzO86ZI5OiVaR7yxSIOLWysKaACjOZsRvXjrvOUhwz77GExisy5p9Qr0Jkl6?=
 =?us-ascii?Q?D7MVnlpVqGGhv89vXsCYEq4fM0Ha92YNGyU0cy3I4ub8lg9blTElY6RD26QK?=
 =?us-ascii?Q?I/oVC9DhVTIAwtss9VZ5Ywiv7BK9KoT6Nlmgn+32MdhwMYnd0vL25etn3Jre?=
 =?us-ascii?Q?oIjo24RlLHboZfESnZMJmFsEAlJuOIqXu8jvn29gCNpFTEMDyE4hNqXXpWRK?=
 =?us-ascii?Q?N1jhqWAAkDE/su/JvFUAH7ISbU7uOHNERKyRCEitiZQyHxfgGncS/niEo86H?=
 =?us-ascii?Q?c6MwtuQ59ltvSJAe/EprsGUTaPtSeg7uZ7cWlplM4Xx3zBCb3Vjnntt1JYNk?=
 =?us-ascii?Q?VfEO27bUtVg3NJVBllyqiFRuVISSLUPEdw188aMLmmUrFzb3raUJbZ8i6SgN?=
 =?us-ascii?Q?oynk0WTpvPsVdj6GoMhCvTezp5oqzai+PM/tC21hVfyyzlWzQ9FfeVxxojid?=
 =?us-ascii?Q?qFdAB75pVY5vvdAY2NaEVaxA7S44UHH50JehWkC8al4HCKv8WQfmVoAC7MrY?=
 =?us-ascii?Q?D3s3tuygKAYXgtTzgL/juLBeraArRqH+aCfSMsoGE2Duu/+1QR+YgSloNetF?=
 =?us-ascii?Q?E9FH6Qig2uZAoqvuvaoHTKvXBn0LfvMOb5m9D6KA/CzGYjzxmPyfuA6O+nIh?=
 =?us-ascii?Q?MFyTevmF4FdP5xDnwaSNSUlmfMLfCIGJJ1/IRvbrvkftgSIlDAyjCLHDbmNq?=
 =?us-ascii?Q?rt//pZoUI56ZurXHqyWeh+M2wu1FnKoDzQJAAVkzwTIE+s/H+oypVN5grzMR?=
 =?us-ascii?Q?ggu3fM8AJ3FHITd9cwy85SHoE6KmyMPdeqz+Z22aB0flDnMVowcFNtgvCy3/?=
 =?us-ascii?Q?9fDZbdTyiBSNYEIY3vqAQwZ0vl8FhuZUOZNpeTuRpjrfBzd/V7ita6DPG6YR?=
 =?us-ascii?Q?G7+v//n09Rt1Q6TSf2wRJw21g1BowI/2ZevCUoB5ULA5VyXgfmBj8vHfJFl8?=
 =?us-ascii?Q?IUfA08nNWRb/LtN7+4YBR5olWB8R2wNcIc55h5M+5vDnJ0P0x2pYobkxQWi6?=
 =?us-ascii?Q?Xz+e2W1F8vgixzYjKPRKhnnTVi7bisWBiBhwXvpPT7OXbiukR8XthlFlJKlX?=
 =?us-ascii?Q?tN2LjTlU368oqHhufQeOBlMrpLvKFY5usOssWt+6mCCm3dNNqlSs05rZzX9g?=
 =?us-ascii?Q?l6eCzZ2H8EmlRUyTrynHm1g8FBYoQhJRUFFuWs4ADp9VVb9XT35ZXpsFLDzi?=
 =?us-ascii?Q?x6vSZLUQRXhrTz1WVMYIXcB3BKZDTpWrI9wSpdcs4xzIgkXi4cCEUWDyT+ka?=
 =?us-ascii?Q?XXcfjF/Fby/2d2XGPjrvjA8d4SRJLcrvc0LpSnTb4w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2O2v2fAw3+YUihCjCYqX+hyy76pKgbsFpvdOchYNP+0fjqWv9xsWKY6Xz5dj?=
 =?us-ascii?Q?IqOpyJwBhDmbp4A9pP9Ab0Q3zky4LVmkjdoatHUFSiJmiesIZibxYFp1Y7eV?=
 =?us-ascii?Q?vg46DuCh9iHjjehoEknK/t6+xyAE9nvoMr3NARMvrOlLw3+7LxB8Pnyl0NS+?=
 =?us-ascii?Q?+1pGRaIJLITq39e8hzNV0lQhH5mIjhkJEelRWjCEQmSXwt9SFPxpuFIOuC9p?=
 =?us-ascii?Q?aBtR1oujUt+3n8F8OQ8UIdTZah2LNMSt691gexvppWK/Fm/rjggTVODIFR9N?=
 =?us-ascii?Q?AGnPS+w7qnJIgNdBVQJx1MK2zsLKSVHtmzw+Wx+eZkbD6zHI7FJjXLGXhfOo?=
 =?us-ascii?Q?kr3aux/hiWcr7WEpJP1Cz8nuytmpzCtGiDwsFXaddxpWg59ag3+OhF6YnIUL?=
 =?us-ascii?Q?aArJIWkLUVHYJbYW73qFh315bEdFSIVm1duE9t8Knlb8wQoT6nfR9W0wKVZG?=
 =?us-ascii?Q?IC1J5yNefdx6YNYq14XlEBljinvvCYSiDilgPZZCkYgKqp2YXUcBFExAka1F?=
 =?us-ascii?Q?Dru0MswKVuO8y4kcxeNwqlnX96qi3cVd8J5ucYc9Xng6HjthuS1IQ3Dz9pp8?=
 =?us-ascii?Q?+RWk3irMJCPUGbJ3EJIVdZWWJMmF6cN4pz+6g2dXqSNRNWW7zZlWTMz/34jF?=
 =?us-ascii?Q?wugxJJsRKkAUDFmS8bnIVKTxhkxXgtOZg+CE2Ny37Z/SeHTXTCxLemoHODa3?=
 =?us-ascii?Q?9YvvzfspCQggitcxb0zasn/cov9Jec8jm2dkRpu9cVmM4pShvjCnFytCTDWW?=
 =?us-ascii?Q?1AiQOAPgqpgqRxtZAkvvxxKRW1fpMkUhtXtWTebR4mypRsqaEkOm5sIGjTnf?=
 =?us-ascii?Q?yoBV51Nj8RIdQAXq0MqW1NNTNS+oOn81FVZoBo+NsPnY8J56RT/LHCEk4eFo?=
 =?us-ascii?Q?LCzRk1QLNu8ziQBy/YGAYiSqKzySk23qBQ3mQDk21tRRrRPyghqazQyjSM+/?=
 =?us-ascii?Q?Ci3Wzw0jvP6n2V5ZvK5B4LacIISwvq0FMi07RVk06VfspzHbdUJOu9PK4vkD?=
 =?us-ascii?Q?oBHFyX7pPIQn4TE76MnpvPSAOu+6Lxq8ImWPCqJMg1EO1xhuWMlUfilFSLF6?=
 =?us-ascii?Q?GCG4bLq27Vbncz4j/OU0oSwkU0WthyCVei8jyEu3ONoeEnfPo1MULFp3TsZW?=
 =?us-ascii?Q?9Y+rhRL1tOBPKAxMbfJBQtiKhz9ExSzvHLSxL9NbKmvq98BERj7lFZ7vuZof?=
 =?us-ascii?Q?qeRkZ9W8fPy7SD//fTeajBTn/bJt7a6luWM0p9m/UvUsVNRKzJugwj9iZLNe?=
 =?us-ascii?Q?0DLOGTD472cTkliUJPB4fxwg6o1ID4Fmpco7JuCPDVQinVDrCtfemzrpCXS2?=
 =?us-ascii?Q?wWtcOupRPFffBPoll0oJ1RbGKBNtau/Us1bxJdhWiSfH4N2Mojtu3IOSMWvS?=
 =?us-ascii?Q?pR9UewPWV/tloFBnHWdpv7Qk8dOW27y9tVSTisn5afRC1eR5tzEztCQM1er3?=
 =?us-ascii?Q?Z68zqP/BE28GF494EMbLv83lzDoIs0Vfnb6owFs/3UVtCgwAFEHmc1twuUiw?=
 =?us-ascii?Q?9tVVE2s8CWmsV623M5G0R7PL6OiKDbDKIFZnbDu4WXIQWooAwm2KXxCFdqsf?=
 =?us-ascii?Q?o6iWorArsPD59rkbao5tJTP+YvbDXvqCkAIpvvtnhkdsANSeES6GAZg0KRsQ?=
 =?us-ascii?Q?n9GQGeNtd/Qe0Mu4rztCbdrrxgMEi0gcSax+OsCffZs6y+fWBbhchoadZ7/H?=
 =?us-ascii?Q?uA0YVw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3Fg77z+6CGJVttyxy5Y2FYMR5Z8clTZ0ZSCWa+rSoU1tDruURHtdHA9VjTmfOkh0YQIiVgMIP26lIbXM5hvFAut9f+Qcs/7lvP2EsiXp6J3idZKEEmpKzk0O7yJ9bfSHaxXz795W2YQ6ttQFIlhVKQVBF9IBJWtHPY94x5cNhk8WGYhath6DcbxNNRtfCWtkKlQJEMiHKM1RhqOOqKbr7j0EoVGmjYhYRuu+f6U6EliTdOq9T13AV1TQrFUidYpOX+CtQDaJWlAY06296M+M7dwmc1Oi5NTb9sEE533avHfSqEwx7N5qnRMF9dYK1Zm9Q4V1n1fWbdpyzd1V41rU5VIJfjSH7njnd8otJ9dye93Gw+fn6U//PNYsgFHjbbJa2Boe8aIPi4tIb1HmVKr7uO9ZEL05+B4Yv2sXpHboIcCzGaxNtJefblJD8QqTWRNoK39wmYhN6Qg0g0R6M97IiOW9KiZnHp8r07ZnxVQE6QzFJIQb5sUo5etwtFufdwyBk3IxpVc9knd2CETZjdT6d4P5jwl2AqlAGcchH2Mbzod580B7FPymee7xRIbYa3lcuGGezVrkgzAE/yaIkHQ//O87cTuDlq48ETAjQ22Fic8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd692b0-eb80-4753-af1c-08dce3097b9e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:44.9566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHcEhz4rQ6xllMrJbz5og1BB08A91wakqMlSDNKv26kEv0eIUNeXXWQf2AUHM9Rr/KGg+NTuzIu/S1O+pwWiXDwtTl/bt9HC9CXqW8fjL7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-ORIG-GUID: EipPFftma8J9WQaAYGMoj1sS2mDY5SNf
X-Proofpoint-GUID: EipPFftma8J9WQaAYGMoj1sS2mDY5SNf

From: Dave Chinner <dchinner@redhat.com>

commit 348a1983cf4cf5099fc398438a968443af4c9f65 upstream.

Luis has been reporting an assert failure when freeing an inode
cluster during inode inactivation for a while. The assert looks
like:

 XFS: Assertion failed: bp->b_flags & XBF_DONE, file: fs/xfs/xfs_trans_buf.c, line: 241
 ------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:102!
 Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
 CPU: 4 PID: 73 Comm: kworker/4:1 Not tainted 6.10.0-rc1 #4
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Workqueue: xfs-inodegc/loop5 xfs_inodegc_worker [xfs]
 RIP: 0010:assfail (fs/xfs/xfs_message.c:102) xfs
 RSP: 0018:ffff88810188f7f0 EFLAGS: 00010202
 RAX: 0000000000000000 RBX: ffff88816e748250 RCX: 1ffffffff844b0e7
 RDX: 0000000000000004 RSI: ffff88810188f558 RDI: ffffffffc2431fa0
 RBP: 1ffff11020311f01 R08: 0000000042431f9f R09: ffffed1020311e9b
 R10: ffff88810188f4df R11: ffffffffac725d70 R12: ffff88817a3f4000
 R13: ffff88812182f000 R14: ffff88810188f998 R15: ffffffffc2423f80
 FS:  0000000000000000(0000) GS:ffff8881c8400000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055fe9d0f109c CR3: 000000014426c002 CR4: 0000000000770ef0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  <TASK>
 xfs_trans_read_buf_map (fs/xfs/xfs_trans_buf.c:241 (discriminator 1)) xfs
 xfs_imap_to_bp (fs/xfs/xfs_trans.h:210 fs/xfs/libxfs/xfs_inode_buf.c:138) xfs
 xfs_inode_item_precommit (fs/xfs/xfs_inode_item.c:145) xfs
 xfs_trans_run_precommits (fs/xfs/xfs_trans.c:931) xfs
 __xfs_trans_commit (fs/xfs/xfs_trans.c:966) xfs
 xfs_inactive_ifree (fs/xfs/xfs_inode.c:1811) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:2013) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1841 fs/xfs/xfs_icache.c:1886) xfs
 process_one_work (kernel/workqueue.c:3231)
 worker_thread (kernel/workqueue.c:3306 (discriminator 2) kernel/workqueue.c:3393 (discriminator 2))
 kthread (kernel/kthread.c:389)
 ret_from_fork (arch/x86/kernel/process.c:147)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:257)
  </TASK>

And occurs when the the inode precommit handlers is attempt to look
up the inode cluster buffer to attach the inode for writeback.

The trail of logic that I can reconstruct is as follows.

	1. the inode is clean when inodegc runs, so it is not
	   attached to a cluster buffer when precommit runs.

	2. #1 implies the inode cluster buffer may be clean and not
	   pinned by dirty inodes when inodegc runs.

	3. #2 implies that the inode cluster buffer can be reclaimed
	   by memory pressure at any time.

	4. The assert failure implies that the cluster buffer was
	   attached to the transaction, but not marked done. It had
	   been accessed earlier in the transaction, but not marked
	   done.

	5. #4 implies the cluster buffer has been invalidated (i.e.
	   marked stale).

	6. #5 implies that the inode cluster buffer was instantiated
	   uninitialised in the transaction in xfs_ifree_cluster(),
	   which only instantiates the buffers to invalidate them
	   and never marks them as done.

Given factors 1-3, this issue is highly dependent on timing and
environmental factors. Hence the issue can be very difficult to
reproduce in some situations, but highly reliable in others. Luis
has an environment where it can be reproduced easily by g/531 but,
OTOH, I've reproduced it only once in ~2000 cycles of g/531.

I think the fix is to have xfs_ifree_cluster() set the XBF_DONE flag
on the cluster buffers, even though they may not be initialised. The
reasons why I think this is safe are:

	1. A buffer cache lookup hit on a XBF_STALE buffer will
	   clear the XBF_DONE flag. Hence all future users of the
	   buffer know they have to re-initialise the contents
	   before use and mark it done themselves.

	2. xfs_trans_binval() sets the XFS_BLI_STALE flag, which
	   means the buffer remains locked until the journal commit
	   completes and the buffer is unpinned. Hence once marked
	   XBF_STALE/XFS_BLI_STALE by xfs_ifree_cluster(), the only
	   context that can access the freed buffer is the currently
	   running transaction.

	3. #2 implies that future buffer lookups in the currently
	   running transaction will hit the transaction match code
	   and not the buffer cache. Hence XBF_STALE and
	   XFS_BLI_STALE will not be cleared unless the transaction
	   initialises and logs the buffer with valid contents
	   again. At which point, the buffer will be marked marked
	   XBF_DONE again, so having XBF_DONE already set on the
	   stale buffer is a moot point.

	4. #2 also implies that any concurrent access to that
	   cluster buffer will block waiting on the buffer lock
	   until the inode cluster has been fully freed and is no
	   longer an active inode cluster buffer.

	5. #4 + #1 means that any future user of the disk range of
	   that buffer will always see the range of disk blocks
	   covered by the cluster buffer as not done, and hence must
	   initialise the contents themselves.

	6. Setting XBF_DONE in xfs_ifree_cluster() then means the
	   unlinked inode precommit code will see a XBF_DONE buffer
	   from the transaction match as it expects. It can then
	   attach the stale but newly dirtied inode to the stale
	   but newly dirtied cluster buffer without unexpected
	   failures. The stale buffer will then sail through the
	   journal and do the right thing with the attached stale
	   inode during unpin.

Hence the fix is just one line of extra code. The explanation of
why we have to set XBF_DONE in xfs_ifree_cluster, OTOH, is long and
complex....

Fixes: 82842fee6e59 ("xfs: fix AGF vs inode cluster buffer deadlock")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index efb6b8f35617..8bfde8fce6e2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2329,11 +2329,26 @@ xfs_ifree_cluster(
 		 * This buffer may not have been correctly initialised as we
 		 * didn't read it from disk. That's not important because we are
 		 * only using to mark the buffer as stale in the log, and to
-		 * attach stale cached inodes on it. That means it will never be
-		 * dispatched for IO. If it is, we want to know about it, and we
-		 * want it to fail. We can acheive this by adding a write
-		 * verifier to the buffer.
+		 * attach stale cached inodes on it.
+		 *
+		 * For the inode that triggered the cluster freeing, this
+		 * attachment may occur in xfs_inode_item_precommit() after we
+		 * have marked this buffer stale.  If this buffer was not in
+		 * memory before xfs_ifree_cluster() started, it will not be
+		 * marked XBF_DONE and this will cause problems later in
+		 * xfs_inode_item_precommit() when we trip over a (stale, !done)
+		 * buffer to attached to the transaction.
+		 *
+		 * Hence we have to mark the buffer as XFS_DONE here. This is
+		 * safe because we are also marking the buffer as XBF_STALE and
+		 * XFS_BLI_STALE. That means it will never be dispatched for
+		 * IO and it won't be unlocked until the cluster freeing has
+		 * been committed to the journal and the buffer unpinned. If it
+		 * is written, we want to know about it, and we want it to
+		 * fail. We can acheive this by adding a write verifier to the
+		 * buffer.
 		 */
+		bp->b_flags |= XBF_DONE;
 		bp->b_ops = &xfs_inode_buf_ops;
 
 		/*
-- 
2.39.3

