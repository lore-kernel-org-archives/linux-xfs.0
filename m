Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421A63DDB07;
	Tue, 13 Oct 2026 09:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884279; cv=fail; b=de9AlgxLsueJSd4qObG/J0geIT/zHmJPAlPFUFAx9h/XtI5HGMxqZVki7sS950ia36/79QF4mVrTjsv1l5usryakZq5w1VzZLmyponf6Vg9vLUN2+t/M+g9KrZvbleSvygJWK1cY1niQUDisloYtUBCK981mvFCrqoQmEqybz1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884279; c=relaxed/simple;
	bh=v2gaA/nmcFkyKoRGATkxEMl6GCwSnOtjSchQRyc0aNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SvYbXj6SEoianL9cHdRSoM3m2VjYmQ+a00mJfHL4pCARzBv+YnQDgaKCpPkBl1/Cq9ODmisxyTwQfn2KV9Z2MC2y/GoDEbKMdUFP3Dwr00HxrF3JZvGDAcZCJSRRWC+2eOhvvnz+4+D+/Wwu5zyvLdjWNIMU/cNFz/aBWtyxwr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DKUDMjSh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BSfmpCgT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DKUDMjSh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BSfmpCgT"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bukk3198110;
	Tue, 13 Oct 2026 09:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5IhiBSH0mqjgVGuvity4z+XAf62pmU94n3AB1FgisjQ=; b=
	DKUDMjSh8V8RLszCQ4uqVWtTLuva65OcYSdX9XSYzIU6YBPdgf5Kal9FzTS61o2/
	oFiQTuRZBGQQki8tKWuC6Yohxg4H1PJeh+3Su0lwQZVFH17nQsZHF/opzKNUwePd
	DTsVOd8Zn9nT4XSHuGQpB7yfmdWmtZAeS3uVg0EFvoPG0fAtVMVA1Vv/qF3kiioy
	7l6J5saklqqCmyKX5doOHrEtZhqK81Ya94JaXOc74D/fWzLzEZOlyhzbrY12rotW
	Pyk6bZAO7c6naqWtUJlrcpAMXsk0ybvTyUhftxM6nnsicrVD9vD5apByo233SsIz
	WPvAr9chlUDz0G0kbTs4Lw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dcsbqjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:37:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9ajBr002425;
	Tue, 13 Oct 2026 09:37:47 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010040.outbound.protection.outlook.com [52.101.61.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjus1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:37:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g438D3zXZmbRl82RAZQj6BUk1jGie+BYKugoh0Q2uXn/F38pbGSk2myhOI7oO8IdSbiCQmez/Du4uPzwwU7KSyvnEZE/WILbzHYWfJGM7rg9kp9LPbJgU8Ta3/LuXrhMqgA11Ethdz6X2Z3DyNqlSyafEiWEJi8jvOBMcars7pduuubA1P0AlDKHB1ZEYAUrU7b/OoVEPucfH7MSuVzk/FJktFhNuPLqkDOWL7xcBfMK6gjQoY1E9GLQb/K0E+EXWPdT8in8MeFGnByQ/tLAR71ViqszfmI/PWChwMXB6utIaZrxspTZMMjQaxXPI+UZH2J4iWbsJeqX4T00yi1l/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IhiBSH0mqjgVGuvity4z+XAf62pmU94n3AB1FgisjQ=;
 b=BMWcrnQuO32vXPEP/v44Oz0XNosy03y/QByTc7Jlq9jD8WbKIZ+O9FiRzVuxvsu/gsOtZ9x4sA3HRCpC+yggKQiXDqtQn5rPhdqHGDQV2UZ/Z9adlSWB53vKD5W945nxbVsDSgmf14rCgPGHsJQIl9OlVU52JE1UR72SKhdHaO7/6z649bV28+6YJM0iCYJuVgGsmYlfpGMRXAJ3krT+fZ3KQ4MEmt4S23itwemTLjeW3vNwmCOcDbvkhZ6bd4F+OnwdRCa61Yc5zRUqCRlBihnD7enSOI26nq0/sSdnO5soQ6ME7pTVi9p4VOXaHVNEwO01BkMVv+rgzG+o4/UW8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IhiBSH0mqjgVGuvity4z+XAf62pmU94n3AB1FgisjQ=;
 b=BSfmpCgTlxWcnlzLJLIHRVO4899ck/xl4ESHIkhvE1k+2cHPjsnddfQLGCoIJMmVhxEuu09MDQMMUsuN88QSrFAVI+LQa195rZMy1dxO2xWsonrvn+bvWBtO9gEnIJOZk7faZEpril3BbIFw1qWHFudBnWKWIoiZ+DWJNsJGc9Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:37:45 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:37:45 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.12 v2 2/6] xfs: catch stale AGF/AGF metadata
Date: Tue, 13 Oct 2026 15:07:25 +0530
Message-ID: <9a84b2d5f20ddb3a69331c553b3946f6c42d2d63.1791883280.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883280.git.siddh.raman.pant@oracle.com>
References: <cover.1791883280.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0200.apcprd04.prod.outlook.com
 (2603:1096:4:187::15) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: c64ccb61-0bd7-4d12-2912-08df290da279
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|5023799004|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	m9OHwQgg6InWMivOP2di9K4cLLbRgGEjuQfQGjzKnsrSEESFgAJcn8FmHAOAX3VQj/K0hfE4CqB9V741qaOmen7moUCOsmmuncq6H54hY7PBblMu9oaNdFcNosHe9I3GvbF9z5g/EEcY+y6AyLU0taPodpDEhJs9pv6i4KqS8kuoFi02hO3tHPYoF9GUWIbddRpmvvOSDl1YfXVpHnqyOtBwXeIjTvZ6pUyc20vHRbADZrx+sUrz6DZbQmLu9K4gfjV8lpasVaKvj1pOce0YG6Zw7B11uQIb1xZKoZt3hlkeQGHLYpen01llKifQ93r43FDKZz3d/hQGqIpCSWHjp6HRq5h5SsSywn9n01O7DiBcyBwK3iFt73afFTiJ+LZtt2BrXauYjOeCmUK+rBB8dReSgiSvF0RwyLnZXVcWKRGvgmJQlIqtgbtI7HIXmL1BNUN6Xp0NmKUzLW67IgZeBDWcyo5zaV1FLMQsPFetQIvAHTQbHCoFASFEkuLKPtEuVBy0t/QbBMGM0HSLmZYfKkyvBlWb6m/eddX3+1O4x5rdBBs1kmyFDWWzAa8EAAFwg+n9T7yBM4qkFIWEIC9Vwv9z8ERKrQOUrcLXEQ2Szpsx9pM0Dhj+xcrIBovThIYYC9I3Xa1jWdfklqb0G4+67xDBFgH7n8nmCUErS38G+UE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(5023799004)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8ssK+PSpFr34su4udDygD5WXsQxzMpzQxEru/J8AXB3wuyGv1lKivx3paJkb?=
 =?us-ascii?Q?odcI0f82th/bo8DQI5U0vnc4M4IKJpMGFLu7IH/CNxg/G6eBaSaJeANH5WSL?=
 =?us-ascii?Q?UQ1Ww/A5/WXt6BclmMGGbiP+WKiRJyRWdZG88swNFHtlTVFMNYZmmeo8Fwkd?=
 =?us-ascii?Q?BR0S9Q5JzIXrIZCJNMTXBzFowfgdgkrfxPCX9AkJcghMWumlUIbbQx0w/+ZA?=
 =?us-ascii?Q?3UWxdabctKvHGjTw/1z8krf1zCA/nOxpMNl9fIRqo+6DJ0BAIQy9yZ727XOB?=
 =?us-ascii?Q?maysjPHG5AKMNTrbPAlcSNl0Go93pcFYwVMXstFt7RD5YQLSvzxICmTPA2+7?=
 =?us-ascii?Q?9WAkmN+6uytjdFCiG7jAy5zgzjGC4NrL6A380jNEkRdv5RNX6i5gy5rs0Ykd?=
 =?us-ascii?Q?ZdCw/D1QK3gPkZyloSjbEGR0KLnVxzh78VnokMDwt4oyypgxxZJm0BPDeI0z?=
 =?us-ascii?Q?9J/T7cRPzbXpMtc4UGttrld3iMGgoJZaTHD/GFLECbrjrLInWEBJO30hDCCM?=
 =?us-ascii?Q?JQfy39VB2OgvvVpHOZMV08UAF0p0QBev2b5TroFKCbAWg9LLVpODmRj57CgE?=
 =?us-ascii?Q?q8E/fNT44+4bZApA578abL8gNHkAS7sgFUaMEKQHzuQFVkht+jCenmSanipp?=
 =?us-ascii?Q?rc53/bYh80Q9TYGULcyZFiWyxJ2aefVEYJEVxpc4Uj6NnIJYKfI8d1LduORu?=
 =?us-ascii?Q?nauzl7CtLiqlHqfAYWZT/GeVZ/oAkpPAiE7q1sybReg1mzNpkjaYA04hAKNk?=
 =?us-ascii?Q?8xQZ8bJkUdhMswo+dL6bFf0IVNqJTjjQWQJG7NTBW0e9vQgJtfxdCaHKyKrU?=
 =?us-ascii?Q?PO/ftI0xpoysmBiIiUj5oqoT7KvHZ0YGFFOluEv83DUCVmc9MtFcsKJB/B+w?=
 =?us-ascii?Q?wyCH7ZBEEZT+yD8RvJKSqWsNePlQ8822OM66iuJEW4zkx7r9XQEPs3MsLqs2?=
 =?us-ascii?Q?d9w4zFPEvB19iFo963l2/khz/hX5mTaEUZDN9ORMYd0iMIZY3UZes8ZlI5TG?=
 =?us-ascii?Q?ZSZ8Cd23wP+K27X0vAIUjTlAa5YdOCJUGMH7jM02h4jXocXupjxytL60JNoa?=
 =?us-ascii?Q?9KnPQod9tsq8+3sof1wYumOweARNhyEOT9AEwKpo5kKCmzw7qSSxv3Y8ToZT?=
 =?us-ascii?Q?rvhlgOSfKNEA9540IB6k6eiuQPPSaL8CmlwPfp+Tw1IJziz8e+OCmzKVe0zp?=
 =?us-ascii?Q?ozj1NS/Qwq01D0J2ZLXfZ3U0Y5R9TcvOlkh9g7HnsSrZ24j2jsyRdYM/lFFo?=
 =?us-ascii?Q?do+F6wd6hYORHBDlCQLfLyZMF0kgdW+dHDylP8dKfGa5s4R/DS/Fuieh77md?=
 =?us-ascii?Q?2uOmKUfMwqUTXVdPRbbOXkol1bDgFSvm+/SC3XIjGpOTng0sYkN/lNB7yLug?=
 =?us-ascii?Q?Z5c+CTgIij5pIq5+v/dPsPxLN+UJ6z4uVXrDgoL3yWLPc7oUAy2vqsbDKURp?=
 =?us-ascii?Q?z+f0XWxDbkO2vc8ASLjEO8F8Eps3v8x6CxgTmoj2PRRlSpkjq1plO+aX/A8Z?=
 =?us-ascii?Q?5FjyB/ekXQVT02Y+2B4EyYnoz7BzxKgddPIZnuBbEFcgvHNVyMcZ5UjhKDTq?=
 =?us-ascii?Q?sNJ6nVRu/Ae9AtJp7stFPR1FCaJ24xjrb4bsn/BMOCMMPvbXeFHsfDmy6Vab?=
 =?us-ascii?Q?5mdbrtI8ldNRYl2UIu3UOQb4/D2lzDBylHpKaIUVqEzUTbfE4KYda7iq+lS0?=
 =?us-ascii?Q?g8ikO34xO9fSNIZs5bvPXpq2AI04Mwv1hssii2KBznbBOsnGPNO80Gg29OM2?=
 =?us-ascii?Q?JqO3gM1doB/+co3nSsE1kHAFmHRWp9g30ElR69RhhKDb7jNZrgxGq4jJ6M01?=
X-MS-Exchange-AntiSpam-MessageData-1: 5E2JvLU2T0x5h37SzsPcD1yeqVdanLopQ7g=
X-Exchange-RoutingPolicyChecked:
	FcMrYPLQudHGbSHkFhSmAghDbktKWu809nOUyaaaWPCIFVT65g3PSD4arSSyoKD0EoC9aiuxqYD72zJodknLWxXI+SnXyfsANq5aMC5nBjaG2jRs0r3t6r6QM0r22qrfvwWo2X+EUe2pgbuoSQzFzUXawOcc/xKDRThU6LQf3gJOdPZZAqMYC8Q20BFXCdb6BQ+CaVp0JdL+euH5Vh7eJ3dTqugMIAbK3yEiHitWg1THSxK73OlbWrHiKlAhMkv6jOnAtsimMWgeVgxuPSWtmvYAtLYxxlRCMy7yl2wCUMjmxU8+YnX0/Gv0CPDFFmPa4C9HcGW9uk6u1K5RrTyvQg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3mdXLF5zg6fRmfXjq0Iyt4M7TPEe/HvgIxOW4kG8tKOXmUs+5vfW4zykHnfql7Gcn8plDU3KSP1Fr5WqOHdoMdqBcV5+wuNpjntmbVh134jocWXrF3GTCGAqYJle0qmqH5NBGCg/TX2DB+/YRI4AcHAYaRkvN12FXfUKSPDBmO/r3tXN0Yg4IJeK5fX7fuVzyKRYGKzpz93seV8p+aJ4KGxLpdndElhs2U3CIBtI5tatvARN86JuYZjzioK+ODkKh21AlVfNcF3JcZpfO8+m4hQrNyQZ/ybmzOUYn04bVA7qpZ0dcGDWXAazZwLIZL7WwuXIdIkET1kstZK4Q9FFuCnSl2Q3zD02vC1KJ+atS0NrcWXgmHeadbUlSqydfHi9j1HWJgMBVcLKimwc42m03HNVcZF/OJbvEiHo2q6Eok3NeaaM8FShLI+aRSZ+H6O9CpjwAk68cIDpSw62R/F8iFow/ZE1mzzoneHFYbDrjaa3JAOJiWLrcpjhPVbtg1a9x28G4dKmMoHewRU8/4WCp/H/4SSluyvnRRUDvywRrq3GVw4mdCPU47fERNBOtWkQtxyBC/HNkzj9rQkzl2bP9ieADW/pXA+5jlCheSek91U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c64ccb61-0bd7-4d12-2912-08df290da279
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:37:45.0287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uVaibqzPnBQKKsi/xQbSYgaURNtWtkspi4lT07fPUPBvEL4KnatU92EshXrZNVeS9XFIwYn72c16qc88P8JM4wJ5ZyOLOPjw1NnpYH8/bXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX31ssAILyWSAF
 tc7FPCKaYNdX6CYOqngL8/UZDLDzAwukH6fNvmgaVtnaiwG5nWLPvQWCDaAUGnsnL7DcaROCl45
 r2nK9WQY+IYwPtAn/tzzQU+q2bo2JeTQvKcmrcjf0BwuDnPgi1BV
X-Proofpoint-GUID: IyS-rkfgzAnUWZxXcwxwWI1Wi2z6bhms
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX+9aH0s+vBWSj
 k3BJoKcjq1f1gs073teqNzN9IZlrb3TMdx85/QickKdjgCyHwIDI7w1+MZJE7ytdSDEhxTPXjZG
 /T+OkM/gJFhE8/3UxBI6RZgaGFt1l5QabVkFOIHqJroGPH4gXx1T5gUrNvPkdyUI6JlSMgNzU18
 gLzG2D/lINK+rUELkJKrqwsPamenm+JZFOUju60j5f9Xez7W+kU4Y+LaPwC2lSPjGJIEN26QPKb
 uqzAGQGwxhEe6T4uG30aIxEqueXkaQasVFOJpz26by/DGg1oN4TzAT9RbSCkhoSzkUjL8cNRMgV
 75ZAxvotJjXAHjYZAtcFeeqw2Z/T0UDIDyrmeAmc/dH9H/3l/Z3bPjEigVFpzlb6R3a1Y2L3slq
 uHQq5KziuXtMaZb2ozY3jgCp7s7MwgoxGTO8T0BrtbAwTd8YycQZMrfRfc4VRj/uipz9Ug008xA
 bjItYBqzq4A5cgi4/0X0Oaq6MoA5CUIyOb6j2GBM=
X-Proofpoint-ORIG-GUID: IyS-rkfgzAnUWZxXcwxwWI1Wi2z6bhms
X-Authority-Analysis: v=2.4 cv=EdZd0/mC c=1 sm=1 tr=0 ts=6acdfbec b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=2l8DqRWQ2dbnbHYYE4MA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108

From: Dave Chinner <dchinner@redhat.com>

There is a race condition that can trigger in dmflakey fstests that
can result in asserts in xfs_ialloc_read_agi() and
xfs_alloc_read_agf() firing. The asserts look like this:

 XFS: Assertion failed: pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks), file: fs/xfs/libxfs/xfs_alloc.c, line: 3440
.....
 Call Trace:
  <TASK>
  xfs_alloc_read_agf+0x2ad/0x3a0
  xfs_alloc_fix_freelist+0x280/0x720
  xfs_alloc_vextent_prepare_ag+0x42/0x120
  xfs_alloc_vextent_iterate_ags+0x67/0x260
  xfs_alloc_vextent_start_ag+0xe4/0x1c0
  xfs_bmapi_allocate+0x6fe/0xc90
  xfs_bmapi_convert_delalloc+0x338/0x560
  xfs_map_blocks+0x354/0x580
  iomap_writepages+0x52b/0xa70
  xfs_vm_writepages+0xd7/0x100
  do_writepages+0xe1/0x2c0
  __writeback_single_inode+0x44/0x340
  writeback_sb_inodes+0x2d0/0x570
  __writeback_inodes_wb+0x9c/0xf0
  wb_writeback+0x139/0x2d0
  wb_workfn+0x23e/0x4c0
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30

I've seen the AGI variant from scrub running on the filesysetm
after unmount failed due to systemd interference:

 XFS: Assertion failed: pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) || xfs_is_shutdown(pag->pag_mount), file: fs/xfs/libxfs/xfs_ialloc.c, line: 2804
.....
 Call Trace:
  <TASK>
  xfs_ialloc_read_agi+0xee/0x150
  xchk_perag_drain_and_lock+0x7d/0x240
  xchk_ag_init+0x34/0x90
  xchk_inode_xref+0x7b/0x220
  xchk_inode+0x14d/0x180
  xfs_scrub_metadata+0x2e2/0x510
  xfs_ioc_scrub_metadata+0x62/0xb0
  xfs_file_ioctl+0x446/0xbf0
  __se_sys_ioctl+0x6f/0xc0
  __x64_sys_ioctl+0x1d/0x30
  x64_sys_call+0x1879/0x2ee0
  do_syscall_64+0x68/0x130
  ? exc_page_fault+0x62/0xc0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Essentially, it is the same problem. When _flakey_drop_and_remount()
loads the drop-writes table, it makes all writes silently fail. Writes
are reported to the fs as completed successfully, but they are not
issued to the backing store. The filesystem sees the successful
write completion and marks the metadata buffer clean and removes it
from the AIL.

If this happens at the same time as memory pressure is occuring,
the now-clean AGF and/or AGI buffers can be reclaimed from memory.

Shortly afterwards, but before _flakey_drop_and_remount() runs
unmount, background writeback is kicked and it tries to allocate
blocks for the dirty pages in memory. This then tries to access the
AGF buffer we just turfed out of memory. It's not found, so it gets
read in from disk.

This is all fine, except for the fact that the last writeback of the
AGF did not actually reach disk. The AGF on disk is stale compared
to the in-memory state held by the perag, and so they don't match
and the assert fires.

Then other operations on that inode hang because the task was killed
whilst holding inode locks. e.g:

 Workqueue: xfs-conv/dm-12 xfs_end_io
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_preempt_disabled+0x15/0x30
  rwsem_down_write_slowpath+0x31a/0x5f0
  down_write+0x43/0x60
  xfs_ilock+0x1a8/0x210
  xfs_trans_alloc_inode+0x9c/0x240
  xfs_iomap_write_unwritten+0xe3/0x300
  xfs_end_ioend+0x90/0x130
  xfs_end_io+0xce/0x100
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>

and it's all down hill from there.

Memory pressure is one way to trigger this, another is to run "echo
3 > /proc/sys/vm/drop_caches" randomly while tests are running.

Regardless of how it is triggered, this effectively takes down the
system once umount hangs because it's holding a sb->s_umount lock
exclusive and now every sync(1) call gets stuck on it.

Fix this by replacing the asserts with a corruption detection check
and a shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit db6a2274162de615ff74b927d38942fe3134d298)

6.12:

Fixed conflict due to the following missing commit:
	e9c4d8bfb26c ("xfs: factor out a generic xfs_group structure")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 41 ++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_ialloc.c | 31 ++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3633f4d28c3b..c9a211b7564b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3435,16 +3435,41 @@ xfs_alloc_read_agf(
 
 		set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 	}
+
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(pag->pag_mount)) {
-		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
-		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
-		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
-		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_bno_level == be32_to_cpu(agf->agf_bno_level));
-		ASSERT(pag->pagf_cnt_level == be32_to_cpu(agf->agf_cnt_level));
+	/*
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
+	 */
+	if (!xfs_is_shutdown(pag->pag_mount)) {
+		bool	ok = true;
+
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
+		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
+		ok &= pag->pagf_longest == be32_to_cpu(agf->agf_longest);
+		ok &= pag->pagf_bno_level == be32_to_cpu(agf->agf_bno_level);
+		ok &= pag->pagf_cnt_level == be32_to_cpu(agf->agf_cnt_level);
+
+		if (XFS_IS_CORRUPT(pag->pag_mount, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
+			xfs_trans_brelse(tp, agfbp);
+			xfs_force_shutdown(pag->pag_mount,
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
 	}
-#endif
+#endif /* DEBUG */
+
 	if (agfbpp)
 		*agfbpp = agfbp;
 	else
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0fdb2a30e50d..482540a7e8e8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2785,12 +2785,35 @@ xfs_ialloc_read_agi(
 		set_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
 	}
 
+#ifdef DEBUG
 	/*
-	 * It's possible for these to be out of sync if
-	 * we are in the middle of a forced shutdown.
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
 	 */
-	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		xfs_is_shutdown(pag->pag_mount));
+	if (!xfs_is_shutdown(pag->pag_mount)) {
+		bool	ok = true;
+
+		ok &= pag->pagi_freecount == be32_to_cpu(agi->agi_freecount);
+		ok &= pag->pagi_count == be32_to_cpu(agi->agi_count);
+
+		if (XFS_IS_CORRUPT(pag->pag_mount, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			xfs_trans_brelse(tp, agibp);
+			xfs_force_shutdown(pag->pag_mount,
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
+	}
+#endif /* DEBUG */
+
 	if (agibpp)
 		*agibpp = agibp;
 	else
-- 
2.53.0

