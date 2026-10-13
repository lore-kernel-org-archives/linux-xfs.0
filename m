Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6433F3F65F7;
	Tue, 13 Oct 2026 08:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879409; cv=fail; b=qdQXqOt4tfb/9EJwpzgzC56SIsCoKadsIfscBHwKsqR+PPl7Q4YjSs0uv0g4OSr5oF0JPnYlkzxHpTwpQygQWBbIgTAw0I7OgkYM7HrAkQ0VruJph/0fq8jYwJLLrEFvXepTyueS0/v0KdnPGTU8yNmp4KL+5fmWplYwlo/axb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879409; c=relaxed/simple;
	bh=Xlxtkk2/MTS2I5RuXadDN7Suf+Wac7BVTOGmVhOTFB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h2dY1yLtDT2u3hs0bsrlBSzxZnHtL07uL/TAENvoNFmbaGo6dl9VzRzxJlh22kqBPH/ccK42E7fXmBoq3hqF2QzhIwQPlLVZuLAaJb8iYiUHc3kpIHnaweWCJLafUeS9vU7UWMHOADY5yGMaTHRly+SG6qwY/gngFwhvj2/ZLjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X19imrHw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KbsE8coU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X19imrHw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KbsE8coU"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2FElb3439587;
	Tue, 13 Oct 2026 08:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=THGeNLNJt6e+K8znTA8jMpG96yCFsxwKs1th2+sMsK0=; b=
	X19imrHwVkWQ/StT5MAAzww3RPRR4aXlASnwk05fa77B95FmQVIAhicSBvl7HV/J
	LFB/aZa7AW9uuZK7mm12PU2lsBqJKZY2Gyf+nt50WsOjxhYmpO8QE6eojpJu4ZI9
	KZqtDaBzLSyucHJreuADI0KPHOnmXIctWonkw7b0ntG9xDPIL4bPkuOdebmbLmNb
	0RxGquWXk9YhGfsQdJR+L/yIgGFia6brNbSsk0Z/HbkSfPiQSBseAdhzrrkVy0Ci
	z3V2RyCJJ8XQ+n823oCmpmFZrGTAr/BeaGn4mz9tMN9fTycGG79cj4YTkju51/4n
	WxlKEPfpMBw37EatrUdR1Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kjq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:16:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86ZsQ024202;
	Tue, 13 Oct 2026 08:16:42 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011003.outbound.protection.outlook.com [40.93.194.3])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta00pu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:16:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R99t0vaJmC3iUY5EUfPx+4dg3ImfatPu3qCxzg3sX+vKxSkDw8fhyR2J5bOuRbcT47R2fNE9Nj5mGp3uW1rxNMvZTT8OyBj9xowfKChOxxwc3QP1grjcHKUDg+KD1sJFaHhDEebXuRnwYlkkXMXZb53bNi2iL0ORexiePycZrkgvhsxQ//OgK8vNUQ20qqQQ72wExhl5Gg3gLs5U3/vi7j8w3b6zrM8ANWrZMu3W243g3IJXU+m111SGyZVWNTjEBLaQTmgOV5k9exhINkRRT97GZsjCAR36U1jcFVmikGERKdiPkx279clYpi3hMbN/M6080TvFUMCBGfmnNE+H6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=THGeNLNJt6e+K8znTA8jMpG96yCFsxwKs1th2+sMsK0=;
 b=i6fcCQptfTnV/rMIHBJqDsuUeBvCKddjtKlifPCmw86J12w5a7SH47qqlVYRGnqacExOeyJCeIxGMTIBRMv3fTv0lIK4tQBnQKesYiec0thTG+1uaMI62rE6OFEbjTXLTju/1e5+PlSlxNVxAD2x7Gb1+MzQqeSvXc8vsRM3GbABb/Ut8YVMoe7U7ch2qwWGl7LXxPnVwOi7S7Ab0/4+XRW6NR/nO/7yT2LoaxZaYCzk4JTe7WDR+GdDQa99RWJPbeQ60htgrCJc0JZZy3XYOdw5fIVplyXGbLd66IllkwGoNYfw0fQ7PPe2W77ECxN/lmn02+HVXsDMpF+iydveRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THGeNLNJt6e+K8znTA8jMpG96yCFsxwKs1th2+sMsK0=;
 b=KbsE8coUdtG1wZv2DhiElrQMzUvUfaJH2VY8Ew5kHUarNMqxCk3Ce1pxSpcQdNK1tpnijbSFKOaiYm3QmPVohEDC0RPXVh8R+BeQEnPhwYggy0BmtReFbqamTB+6er6ogdgEQhIZgmDGyPcBJGLMzQzHwEeHJs/H+Tayd1O/wQs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 PH7PR10MB6507.namprd10.prod.outlook.com (2603:10b6:510:202::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.10; Tue, 13 Oct
 2026 08:16:39 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:16:38 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 19/19] xfs: fix unmount hang with unflushable inodes stuck in the AIL
Date: Tue, 13 Oct 2026 13:45:03 +0530
Message-ID: <a7c8a0d8d5828d0cf57b8d46f92908c7bc778df8.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JH0PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:990:58::9) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|PH7PR10MB6507:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f5ea7de-029f-48f9-d9b3-08df29024def
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|1800799024|23010399003|366016|6133799003|18002099003|22082099003|10067099003|4143699003|261009223027099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	gIIN51WAAy/uO2fDTh/b79NXaO3mdQNj38KZif42/gUX/Q6xjLBawZHnS7E2U4+4nAQ59Lgz9nIp1/AxAPwzJ0HUrjbKijJJW2SdZKlyD2YJZrflkz2OdM738j2ysFU8ifz/p9L+/3redlmT8ZF1fgTdnvJkGS4ePOBk6Uji3uKNl74AvS1D/NRSwbb9MBvOWTd+oCcODngpBbwcZdis1o9OmWRYZ/aWrYj2n6tHyHBL66FWojA7ZSaBe32gKfLb5qYoNZRrkBkj/gTtDInT83Eoq6TqSv8CXPhgQWA54qjDQ3MmExs1bQSecoxfbucqU8oVOCmzU6Xl+Od1vk7JsmSH63AaxPsaW4aZxIbMbR4PXs9UPsSf2JC50aX7bwaYbwqbExFYirsrvm2BT08gvCHbiyzgPc/+AmmKx1X6ZNFrAW1t076Dqow++eochNNZwzWXaho41V0pbEO5vHuENF8iVB63p5ppsmzLT7MSOiGIPUdEydTj+OcSARz8ShXViZDitEFaU5FXthILap+6DbBlhQJZSyaXSr+rW7VbX40Jg7wXM835OAh4NPYwI+NNxRSNvQygGbUlX1gjXn3Fi1ODQfuVqgM1xKvz9EJXconAfVauQ8O9FMcPdDeKpREfnVYwPjL7U8npMUeHLlDoHBrIj5OSNeu2lJBBR7w2IDc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(10067099003)(4143699003)(261009223027099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WjA7mVBFU2r33bSod8NC8ZA8pGM89HK8+Hxq/g85UGcOtSvsd1FuzXJcTDd7?=
 =?us-ascii?Q?X4Dhzf8nlVKV8xxXFX5EbtlxFLe4FkuSF/InrlHeRGazCd77CtyC7tuqUJqm?=
 =?us-ascii?Q?dNsv187mFvXWutzuLHbYnh51nNJWrOfbGO/ov8Y+WjkAIuPg36esaVjVAo0m?=
 =?us-ascii?Q?JB1LNTsKnwSttNjxebvHQ4XwZD4JBGZOGTBF3Z1qKxNv2F2g2c42rdYVSKJE?=
 =?us-ascii?Q?GQTuUHKaKtlU6cySd8KzwZHFWsVawdg0cQBTosLwLSssTR109NI6lyi1FUjQ?=
 =?us-ascii?Q?su7u1mB+/m3lFh1pyTfwXgCvsDm3J567Q4yGRTeANjwXL5e9mG484BarJxGD?=
 =?us-ascii?Q?pzOYu/YKdeodflDpyAlQft3t5EmdPvR2gDqUXtcaQ2otW1puZM9lyB3khv4L?=
 =?us-ascii?Q?RXm4KaRc/We2RLuM6F6tbe8V83j87kkPjkQSTkG0JidPyriPZ9/YNzOXSrmC?=
 =?us-ascii?Q?ZCG7dfqlHLZrv4sMMI2X/s93eKnGcp4iPcjLxC/G9EHP2gsHDEf1bKPGhUTS?=
 =?us-ascii?Q?Hue4/dM6jOLdTXqkSKbF552fiS2cr/IiF3O+2TjkGGe+g6Nw0fQ/axBd6Hiy?=
 =?us-ascii?Q?LjnBtTBUn/3tVsPLxT+uLtwfGuuRjfuWKzUXMNKUUlunrYQxAporrsnSzmea?=
 =?us-ascii?Q?CVAMhWhB+adWZQThFjPXvPqHlQlPmxFHefo1LxJNmNC3Dc5pk1592eR7HnUX?=
 =?us-ascii?Q?s5AMGVO8S4umDEWi4oexy02VUVrpiHIubbUy+QmDLCrLlrUTU0gUtGFJoasB?=
 =?us-ascii?Q?hAEQ1rnaAhXSkCZFRRCREttcoBBzU0GpaKlylpdpTBTm1CA8HpyGAQpPgQlg?=
 =?us-ascii?Q?MnLFU7E1d87wp31yHJycs5A++IfUneccERGtZNAmZs/HyYuEFKOrSRd5an9o?=
 =?us-ascii?Q?zwHofc5I9h3FuFFLKtnw9Sb6erZSoB0RAXXFvXCeWDJpRg+llWNUyy/5JLtz?=
 =?us-ascii?Q?VnyNU6yHOYEIUuaxxrl8z4B1ranmMaEx2nUW7OZHWqaVRSjr8VbAQ36Kyfn1?=
 =?us-ascii?Q?ToTqNa1k+Wax7iS4KvhxdASh3/AjgbhG6JsCYGTNgLW8NX68irenPihiBlQk?=
 =?us-ascii?Q?IlFIQ0vUt/f3L7Kh/APwT1vtqSiK75HGtiK/jbBmUkNLfq+Gatx3p6abTLFZ?=
 =?us-ascii?Q?8JGbxomYc+mgaC0AZY6vOPw20PT23VA9lOVoAIuMpZSyngExsLmT7wK4sqJo?=
 =?us-ascii?Q?1fc5TKkuAnEqxHrXf/D/SRZ50Qnyat5behfBGHeLvV24I9LeerT3BwjRXitw?=
 =?us-ascii?Q?YV3QJwUJirD+8E1R3B76klhmDwtD28TN4f7XZOlZpJpbD6CSqoM6yTlij20u?=
 =?us-ascii?Q?JTQO2N7qRUSEqlmnkLEjgW2qZR8gC9JpkdkY+FPgmIjBYPg/MyGy9ceUFFVh?=
 =?us-ascii?Q?I6xSQVm0sNQb45x47gqQb1TLFL0eAnYvdHa/tSeBWlbxmRlwCMW+/IqXp6NJ?=
 =?us-ascii?Q?Wpu23VgkDsYjjtJ3hoeNk2aqMV2PMWzzNBL2+JBFLbe7yVI3SKE5p4sMxvnJ?=
 =?us-ascii?Q?hfgG4HB9IkvhZKVfmjkLsEUnBlseIF6aWcqp94WaZj2ybSEHGKQHVplHA83y?=
 =?us-ascii?Q?UH9aPbcK4CAgrpU0pwDYLyZbcHrl3Pbl/byqKqYmoB0r1xO9BS8yXoAYyH0A?=
 =?us-ascii?Q?Um7XhKUs9TGB1gHFFeOk6BbpJn8Ch1XMz15lqPj/z44dsgc7oU3imK5ldDIH?=
 =?us-ascii?Q?8wTP9sJYKFI6zHQYBFMTzzMUhgjHLiykSdGsKon3jluaGnPg/CYRC5PTTRaG?=
 =?us-ascii?Q?zJdSks60kuVH0CLogyhkRz6q5rgpJjBtejtTTpPbaaEiOV+HPSDOWnn2wPH6?=
X-MS-Exchange-AntiSpam-MessageData-1: FYzdWQykEDbcSgM9wLuqAQ0ecKsHS+uT3K0=
X-Exchange-RoutingPolicyChecked:
	PDeR/m3jQgIHWYOl3jIonRW3hzcs7pzEVG0XC2zklLlPGuWB4VrR0fPYRFtZi2xHlFuhiHCax32DA4vYON5pIhpDFMQy5Jp8CN6ibsdREEvA7b5iCJrvjwOVJHWcSdSSRVcsd9UJUOqs7MCcoSTlW+dwqli/357+NGVZmqED45XSNAIUCZC0wmvtX+rNEgHTryMdUmBxcwczh9mF1+LyeiuHH69CvjfIOZ91DEf7bW+EQkQH5ZS6Z6JAFrqZZZtokYKcGf09IcA1jIA77bfBV5IcUu8SrLpfQAadjsrrp+ifTvWnxra9VrKBeszisX4nHnkeVMlgMrdzHxh50YFjhw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s6P5A9EHrsNxjkn8+ewexpCOovHUgzXo8pgAAlB5I9dlQM9m/YkbSmJOU95gytzAtZyhlHGV+Ds10JRHlaAAYERlYt7c/75JtThqz+a0oz2MqQr3XASyt0QC75IxJxCuvGQIgDHLiVTGloaP0E3vXhNibvit3OXbqj0AQAOQT91el/wi61v3FpS5oOW7vsEk8nY/mKfIHOXTl8REkFSBxOehpsLvElMmLvelxVGrVwkHaLIPT94j9GHiOWmzK01ByOjlkUmTpgEIh+NsiPbfdwwGHCRRsHUGCGHP3BZh8LuHdoHe2u4wEhyGjpCca/G7MCsfUyLyHrLMEo1neaKertDjadmleZ6/9pPNO42/Y2dCy3UdHLLYClMb+rmNw8ki7oPm6Z+LhenLpR7ch/6IuX7tiBKuF8E0b1oiVZxS+MBSizAPJlWGPGCCDt67I+JZlzPiJowFwNysbAxoETC5vOJ3Vem5jT1yMbtWybi6hlwLH4rI8w1BwwX3fVD88xmN5HqEzBlw3r6gp7fW45dbF2AhVhNV4llXCuHIkFEWcL5RhUazLWhy/HkE+iDfh5GVryfjC/gR2qo3Wz2G1XdUd6Q+PpvKKZlXSnQFwyxxXBc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f5ea7de-029f-48f9-d9b3-08df29024def
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:16:38.7885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yO62Yt53gu5EXJWhmbiEP1LLJhQCznNURjRpSYu6dvr2qlJriVVkRokoCXRfipEOiO6Qv0FZc2s1Fcb5Z2Pdcw4HVcDZhCPYlWiHrDkEwDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acde8ea cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=kGPDooFuvBrjL3bSUbYA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX3PIOBahjF3xE
 bM0eQjsyiQeLVcThQjPwHRYH5ZDhdkXWpq2uMPFhDY950Zl6T1+va2mco9rKM7dWTrbjxD384Ss
 B6o1XwEkOdr4U4z6qa8apfHsIJFmtDy1twycyJH6TyEvbwODmwkv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXxFJaLIVWFOLo
 PUzOIJ5/NTqV8R/vy1faVuwjyT65qMnhNCqI+dax2aIaHuBVCb5n89MZFKgL8LzHz+yGVCC1319
 8TKuUpjfvqArtjLzub/d+kSRAvfHcOjjAYDgljWR42b4grhHTRr/RJYBZmIGIggeqIZv1SrQxQT
 3dGxNbTS31Xa3XVp4olnhxcW5aZAnMHJKmpeuIfql/J8aBZhwMph7Ntr7GI9Qw7YcCsVFV9yeLO
 5e+2SzZYMC+1QQWOmLfM9Tq/mA5mbpQlQWTZtToKNK9surmSMuhZAtelL44c3jKSUvRLgQ/r8WQ
 qr9rZgYPaEl0XO6IumK87A4pgnBIjBZd2jBMVbk35fZWjtE8ygsfR3R7BpFcle6vgM+IUzbC+K/
 1cxNzamxMfuPMO8wOu4U/Tk5K4sioYy/AGHkrJTHyEDI0awSUzp/IKRPkGxbF/GH9r7sWMmQdT4
 QGPsIYTi5R9c8JZiIcQ==
X-Proofpoint-GUID: ynqN9Yu2REqTMoBzENXgfKnNLIZ4sXG7
X-Proofpoint-ORIG-GUID: ynqN9Yu2REqTMoBzENXgfKnNLIZ4sXG7

From: Dave Chinner <dchinner@redhat.com>

Unmount of a shutdown filesystem can hang with stale inode cluster
buffers in the AIL like so:

[95964.140623] Call Trace:
[95964.144641]  __schedule+0x699/0xb70
[95964.154003]  schedule+0x64/0xd0
[95964.156851]  xfs_ail_push_all_sync+0x9b/0xf0
[95964.164816]  xfs_unmount_flush_inodes+0x41/0x70
[95964.168698]  xfs_unmountfs+0x7f/0x170
[95964.171846]  xfs_fs_put_super+0x3b/0x90
[95964.175216]  generic_shutdown_super+0x77/0x160
[95964.178060]  kill_block_super+0x1b/0x40
[95964.180553]  xfs_kill_sb+0x12/0x30
[95964.182796]  deactivate_locked_super+0x38/0x100
[95964.185735]  deactivate_super+0x41/0x50
[95964.188245]  cleanup_mnt+0x9f/0x160
[95964.190519]  __cleanup_mnt+0x12/0x20
[95964.192899]  task_work_run+0x89/0xb0
[95964.195221]  resume_user_mode_work+0x4f/0x60
[95964.197931]  syscall_exit_to_user_mode+0x76/0xb0
[95964.201003]  do_syscall_64+0x74/0x130

$ pstree -N mnt |grep umount
	     |-check-parallel---nsexec---run_test.sh---753---umount

It always seems to be generic/753 that triggers this, and repeating
a quick group test run triggers it every 10-15 iterations. Hence it
generally triggers once up every 30-40 minutes of test time. just
running generic/753 by itself or concurrently with a limited group
of tests doesn't reproduce this issue at all.

Tracing on a hung system shows the AIL repeating every 50ms a log
force followed by an attempt to push pinned, aborted inodes from the
AIL (trimmed for brevity):

 xfs_log_force:   lsn 0x1c caller xfsaild+0x18e
 xfs_log_force:   lsn 0x0 caller xlog_cil_flush+0xbd
 xfs_log_force:   lsn 0x1c caller xfs_log_force+0x77
 xfs_ail_pinned:  lip 0xffff88826014afa0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88814000a708 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850c80 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850af0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff888165cf0a28 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850bb8 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 ....

The inode log items are marked as aborted, which means that either:

a) a transaction commit has occurred, seen an error or shutdown, and
called xfs_trans_free_items() to abort the items. This should happen
before any pinning of log items occurs.

or

b) a dirty transaction has been cancelled. This should also happen
before any pinning of log items occurs.

or

c) AIL insertion at journal IO completion is marked as aborted. In
this case, the log item is pinned by the CIL until journal IO
completes and hence needs to be unpinned. This is then done after
the ->iop_committed() callback is run, so the pin count should be
balanced correctly.

Yet none of these seemed to be occurring. Further tracing indicated
this:

d) Shutdown during CIL pushing resulting in log item completion
being called from checkpoint abort processing. Items are unpinned
and released without serialisation against each other, journal IO
completion or transaction commit completion.

In this case, we may still have a transaction commit in flight that
holds a reference to a xfs_buf_log_item (BLI) after CIL insertion.
e.g. a synchronous transaction will flush the CIL before the
transaction is torn down.  The concurrent CIL push then aborts
insertion it and drops the commit/AIL reference to the BLI. This can
leave the transaction commit context with the last reference to the
BLI which is dropped here:

xfs_trans_free_items()
  ->iop_release
    xfs_buf_item_release
      xfs_buf_item_put
        if (XFS_LI_ABORTED)
	  xfs_trans_ail_delete
	xfs_buf_item_relse()

Unlike the journal completion ->iop_unpin path, this path does not
run stale buffer completion process when it drops the last
reference, hence leaving the stale inodes attached to the buffer
sitting the AIL. There are no other references to those inodes, so
there is no other mechanism to remove them from the AIL. Hence
unmount hangs.

The buffer lock context for stale buffers is passed to the last BLI
reference. This is normally the last BLI unpin on journal IO
completion. The unpin then processes the stale buffer completion and
releases the buffer lock.  However, if the final unpin from journal
IO completion (or CIL push abort) does not hold the last reference
to the BLI, there -must- still be a transaction context that
references the BLI, and so that context must perform the stale
buffer completion processing before the buffer is unlocked and the
BLI torn down.

The fix for this is to rework the xfs_buf_item_relse() path to run
stale buffer completion processing if it drops the last reference to
the BLI. We still hold the buffer locked, so the buffer owner and
lock context is the same as if we passed the BLI and buffer to the
->iop_unpin() context to finish stale process on journal commit.

However, we have to be careful here. In a shutdown state, we can be
freeing dirty BLIs from xfs_buf_item_put() via xfs_trans_brelse()
and xfs_trans_bdetach().  The existing code handles this case by
considering shutdown state as "aborted", but in doing so
largely masks the failure to clean up stale BLI state from the
xfs_buf_item_relse() path. i.e  regardless of the shutdown state and
whether the item is in the AIL, we must finish the stale buffer
cleanup if we are are dropping the last BLI reference from the
->iop_relse path in transaction commit context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 7b5f775be14ac1532c049022feadcfe44769566d)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 123 +++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_buf_item.h |   2 +-
 2 files changed, 87 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3a96279f97a1..8250347e2a94 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -627,43 +627,42 @@ xfs_buf_item_push(
  * Drop the buffer log item refcount and take appropriate action. This helper
  * determines whether the bli must be freed or not, since a decrement to zero
  * does not necessarily mean the bli is unused.
- *
- * Return true if the bli is freed, false otherwise.
  */
-bool
+void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
-	struct xfs_log_item	*lip = &bip->bli_item;
-	bool			aborted;
-	bool			dirty;
+
+	ASSERT(xfs_buf_islocked(bip->bli_buf));
 
 	/* drop the bli ref and return if it wasn't the last one */
 	if (!atomic_dec_and_test(&bip->bli_refcount))
-		return false;
+		return;
+
+	/* If the BLI is in the AIL, then it is still dirty and in use */
+	if (test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)) {
+		ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
+		return;
+	}
 
 	/*
-	 * We dropped the last ref and must free the item if clean or aborted.
-	 * If the bli is dirty and non-aborted, the buffer was clean in the
-	 * transaction but still awaiting writeback from previous changes. In
-	 * that case, the bli is freed on buffer writeback completion.
+	 * In shutdown conditions, we can be asked to free a dirty BLI that
+	 * isn't in the AIL. This can occur due to a checkpoint aborting a BLI
+	 * instead of inserting it into the AIL at checkpoint IO completion. If
+	 * there's another bli reference (e.g. a btree cursor holds a clean
+	 * reference) and it is released via xfs_trans_brelse(), we can get here
+	 * with that aborted, dirty BLI. In this case, it is safe to free the
+	 * dirty BLI immediately, as it is not in the AIL and there are no
+	 * other references to it.
+	 *
+	 * We should never get here with a stale BLI via that path as
+	 * xfs_trans_brelse() specifically holds onto stale buffers rather than
+	 * releasing them.
 	 */
-	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-			xlog_is_shutdown(lip->li_log);
-	dirty = bip->bli_flags & XFS_BLI_DIRTY;
-	if (dirty && !aborted)
-		return false;
-
-	/*
-	 * The bli is aborted or clean. An aborted item may be in the AIL
-	 * regardless of dirty state.  For example, consider an aborted
-	 * transaction that invalidated a dirty bli and cleared the dirty
-	 * state.
-	 */
-	if (aborted)
-		xfs_trans_ail_delete(lip, 0);
+	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY) ||
+			test_bit(XFS_LI_ABORTED, &bip->bli_item.li_flags));
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	xfs_buf_item_relse(bip);
-	return true;
 }
 
 /*
@@ -684,6 +683,15 @@ xfs_buf_item_put(
  * if necessary but do not unlock the buffer.  This is for support of
  * xfs_trans_bhold(). Make sure the XFS_BLI_HOLD field is cleared if we don't
  * free the item.
+ *
+ * If the XFS_BLI_STALE flag is set, the last reference to the BLI *must*
+ * perform a completion abort of any objects attached to the buffer for IO
+ * tracking purposes. This generally only happens in shutdown situations,
+ * normally xfs_buf_item_unpin() will drop the last BLI reference and perform
+ * completion processing. However, because transaction completion can race with
+ * checkpoint completion during a shutdown, this release context may end up
+ * being the last active reference to the BLI and so needs to perform this
+ * cleanup.
  */
 STATIC void
 xfs_buf_item_release(
@@ -691,18 +699,19 @@ xfs_buf_item_release(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			released;
 	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
 	bool			stale = bip->bli_flags & XFS_BLI_STALE;
-#if defined(DEBUG) || defined(XFS_WARN)
-	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
-	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	bool			aborted = test_bit(XFS_LI_ABORTED,
 						   &lip->li_flags);
+	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
+#if defined(DEBUG) || defined(XFS_WARN)
+	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
 #endif
 
 	trace_xfs_buf_item_release(bip);
 
+	ASSERT(xfs_buf_islocked(bp));
+
 	/*
 	 * The bli dirty state should match whether the blf has logged segments
 	 * except for ordered buffers, where only the bli should be dirty.
@@ -718,16 +727,56 @@ xfs_buf_item_release(
 	bp->b_transp = NULL;
 	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
 
+	/* If there are other references, then we have nothing to do. */
+	if (!atomic_dec_and_test(&bip->bli_refcount))
+		goto out_release;
+
 	/*
-	 * Unref the item and unlock the buffer unless held or stale. Stale
-	 * buffers remain locked until final unpin unless the bli is freed by
-	 * the unref call. The latter implies shutdown because buffer
-	 * invalidation dirties the bli and transaction.
+	 * Stale buffer completion frees the BLI, unlocks and releases the
+	 * buffer. Neither the BLI or buffer are safe to reference after this
+	 * call, so there's nothing more we need to do here.
+	 *
+	 * If we get here with a stale buffer and references to the BLI remain,
+	 * we must not unlock the buffer as the last BLI reference owns lock
+	 * context, not us.
 	 */
-	released = xfs_buf_item_put(bip);
-	if (hold || (stale && !released))
+	if (stale) {
+		xfs_buf_item_finish_stale(bip);
+		xfs_buf_relse(bp);
+		ASSERT(!hold);
+		return;
+	}
+
+	/*
+	 * Dirty or clean, aborted items are done and need to be removed from
+	 * the AIL and released. This frees the BLI, but leaves the buffer
+	 * locked and referenced.
+	 */
+	if (aborted || xlog_is_shutdown(lip->li_log)) {
+		ASSERT(list_empty(&bip->bli_buf->b_li_list));
+		xfs_buf_item_done(bp);
+		goto out_release;
+	}
+
+	/*
+	 * Clean, unreferenced BLIs can be immediately freed, leaving the buffer
+	 * locked and referenced.
+	 *
+	 * Dirty, unreferenced BLIs *must* be in the AIL awaiting writeback.
+	 */
+	if (!dirty)
+		xfs_buf_item_relse(bip);
+	else
+		ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
+
+	/* Not safe to reference the BLI from here */
+out_release:
+	/*
+	 * If we get here with a stale buffer, we must not unlock the
+	 * buffer as the last BLI reference owns lock context, not us.
+	 */
+	if (stale || hold)
 		return;
-	ASSERT(!stale || aborted);
 	xfs_buf_relse(bp);
 }
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index e3ccbf3ca801..c39202c0135a 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -51,7 +51,7 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-bool	xfs_buf_item_put(struct xfs_buf_log_item *);
+void	xfs_buf_item_put(struct xfs_buf_log_item *bip);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
-- 
2.53.0

