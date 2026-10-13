Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751DA3EFFCC;
	Tue, 13 Oct 2026 09:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884366; cv=fail; b=htqK6EPNvvMaFa+GxBfhQdP8h8Cf/KZ8kds9c1jiw93+QO9KHiwjYMm8fiV8F7PFS7hQSuwiwVNZAkwZadCaoT4KawdMVR2zzZzoavTR8di3BVYVGg7isl+16d732E0WNOPI7zVQ5kcM7kTzVFqGUxCfQAbIrBpZmepDpMDrm6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884366; c=relaxed/simple;
	bh=QRJ8/9FbWuhsvWbfsvGvpyXyOvNCBcYyRicHhfNV1SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tz3z1fQyLUFrHdfyzqpBhdB52O3e0QUIgyE5mX5Agyrm3Xdy1q/CwGeUhQ/tSnekxs3hnelKfyRK6kvb0675WG66AznNgwdGXIhxP5Wz0xg2wHhbyGpc5JYlMK4fojYbT6d6ULJL3SCd5X3s10OAgp8+xJe02lUiC4pIkM1Py58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e0YQ3pDv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ocn2AAgw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e0YQ3pDv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ocn2AAgw"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CoWK3435858;
	Tue, 13 Oct 2026 09:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QL0CJZx36k7joUG1MvtFaeaEaisZwFkm8LbEszvtdA8=; b=
	e0YQ3pDvU82yoy799uAnF5HIIJoeca4Acv9OmIGb/CZf+MLCaj6gGFm2bbqijuuf
	r6g0djjinxfgZwkOUgwFGkOfjGkIsvTc85sI4lOElw8BxjH971Waeli7TD89Bm8u
	RbURtyNuuP8sGx71+e57cwiapGc1992Ae1AwPShrHETRkLiGmnC71TDmsxOsXTgt
	aoeHwBYq7CYGov8eNcVgGMYKsSu4YyNIsbBRnuBOqTWI1Vi41vetQfg7b51ZpHJ2
	JuNS0YD32IHPc+Qm8ftnUIpKtThnzl+uj2p8vBpzJn1jKAsMrzSQrGnDd9KXtLlp
	r/7ANoITLm6SAsCom8OEYQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kp4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:39:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aUJw005457;
	Tue, 13 Oct 2026 09:39:19 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012001.outbound.protection.outlook.com [40.107.209.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta2cc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:39:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ni/WHBcdgIM5G9HVjMHbU6GqkslCdXEyZB81JeF1Sz9KZFIi7kuzQ96qhSwiuzIpgLMHglky/knruCjEqrf/HJBYncLoqBuqJOdz3N83WpJvKhljfZlEsF2ithwToo6FQdtdD1v8Ky4HlMbeMEOdk/V0BrLsTjaig0QCbFGnm5sBwsfVwPK1Nm+o9Gzp6lNi0tY9ZrbhQJ4bnlIDPGunspULxyB6IrD8DpMskOj6sqNGQgQvFr6oglY9wuk41nWEJqTH7kEpSzJQ9r3op9wZEjPbBNbNrxBfOAtn+IgAN+SRn5DyDInOsSDy+ZzavQHSfVdg4esoJe58TEZo9Lmlbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QL0CJZx36k7joUG1MvtFaeaEaisZwFkm8LbEszvtdA8=;
 b=o+W16/WHwekuXI0F6Kq9DJ/7WWr5zGU1uhc6rj3/0iGdgjmm7S8SHVo8SxAT+ljpatOa/f7PS/txVI7uPrJHGm3asIGfC2F8G4OoQYx6P6QacowrmUbfosjt4RxulnbqElf3OMM0Onh+2hrNgQn9X1UpJ65WUQjLjVHmRS6IYNiSY/hGWAB1e7T7Qc5y9Jed7C0eSzJt1kNa9j2J/8wo3Whloe4qretdKZmZrkRiK87bw+pxVi6RuwURTQ+ARFI2vsmzHDcFyI9mCvtAzIUhO3tOmQ2FgpjGtZUXMQpo7eoCl5oWYuM4kM79pQKgOlp+8uf+/u3jEOgfINEDUwMWqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QL0CJZx36k7joUG1MvtFaeaEaisZwFkm8LbEszvtdA8=;
 b=ocn2AAgw9pOIu3hzmWTH1lKXYT0BgZSORTaZZSEnNMz5sLnS38kJeITNJ4yYuoVidqxcwM9xfKQ3YDKhEqlkwgTPlh8n9Y51IheVIHlkr969eUzTDXscQpm59etz/iD2zpHmnz/tTFLNYyEozLi/8E7eoWf0rVs7iZku+Thz3wM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.23; Tue, 13 Oct 2026 09:39:14 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:39:13 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.15 v2 2/9] xfs: aborting inodes on shutdown may need buffer lock
Date: Tue, 13 Oct 2026 15:08:53 +0530
Message-ID: <7e7b833ff0157f3ac29b0de8e96d84dfc9638334.1791883295.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883295.git.siddh.raman.pant@oracle.com>
References: <cover.1791883295.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::18) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|PH0PR10MB4776:EE_
X-MS-Office365-Filtering-Correlation-Id: 03bd5519-1252-4cc5-85e7-08df290dd735
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|23010399003|5023799004|56012099006|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	1gbbWvVaTLoxP54Y5HZfvsm6JIGtN559Ra/UMdYse8IEFb+MZOyUh2ZVAJQAttEcIvZ7xfMAtSf35WAXl+8fyqaCZNJOoxEv6o16DvUSPF54/CokuCwfp4YHXIYdH1td26gKclcrYsVtJJGIwkjussd3zpKuQ50uZ/tj3Ix86GmVNLfWjy+DfT1/pPYYygFEVcNbj9ZR7qzWrLtzVGxomrGsUxzOiwubqQjMPGePkbbAiNHJjKqkmhYqT0nOeL9ElLZlG6/1Q2ohKT+cpSS4q0wncSNpw5UAEXw4TnrEUk2IeJVLDoviiDxtZE+Rlj3nRKPQnJIu0ukfm/L/cgdOORyBNRF9J/KWBGruOgsTApg/wQMIAkhcrjg1uz/9DmM9Rqkiv1kc/bDPcYW4WMCQ9hOoJNLo8eCgZq7Qi1ZRycxe/NMxOyUVgFTwrUNw0v4PSrPqk5yw2r73ZHd+Ga70NuHgEyI4b6LATF425u4dAs3lE2pXcHW6e6NhcAih0h2YUejbHbyTd5bxRAN/OaolN9Xxzu6Va2UCL+pkt8t0QPxBJXuOxaCwoT+BdkqVVwOozvGhGi88yUquxVn3X0loTPHc6W/BOa4oH74Z8NrKwnbsYFEh2+qKUnxhdsAt1JGMVu2P/K5h33nqmSx+JoRG/fA3soh1eLmvP7vOP9K69zs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(23010399003)(5023799004)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hi3hGFft37DKN0LVKMoBN0r77JaFEq4QXf2hCuXZgh0pVaEeKQj2QPjLYJl3?=
 =?us-ascii?Q?CWbj1m1QUxV57NEQUjMOFhO7ioYVxY7sqDqpXI7lE/lnDocDvY6aq63sOvrb?=
 =?us-ascii?Q?ozxcPx1vnLfhGdkdLTaqxQnjhp7sJ46f5TpoxrlS+dl/FxEtG8uCpKpzbHh8?=
 =?us-ascii?Q?BitvWUQO+6153y2jE+EwJWnueg15Qs0ErsnsTnlGaeMNE0HdJZuTHPo4xPKF?=
 =?us-ascii?Q?ZCmHL+KwTJ6fZI780SZOOyPjYT7yLdZlOWoAhzGAXnY90uJnny0qChpM4n67?=
 =?us-ascii?Q?HYrFKicktdRw8ns89nqY6wcKoSApSrC4XtXt4/mw/JgZzBdlexjoDPMMn0Fu?=
 =?us-ascii?Q?i/ikM2httvNYkMNH+43e2sD7vY2ReJnRJBpdhZbZfd+A/P9+rRYV6koYlX0F?=
 =?us-ascii?Q?sTy+DKQrNO/1GkNIzLF9tLwHodHbNDO5kkQSoZttFmYEpTTQr2HLXg3FOgok?=
 =?us-ascii?Q?v2UYHWmJg+4DnpMMBRkaA4fILCrW7HveyX0PB4StapOZk+b9atI0yx65kBBo?=
 =?us-ascii?Q?kVhFSXPnH/1n++bio2zYDPnWW9/0p0AWbRWo5MKwX993Hce3jz7JcUN5sWDn?=
 =?us-ascii?Q?H5goPMCC0uiQllMIkazFUEgt5vG+CkkHvgUZSYVmQUiCui1aPZjlpudS7NOI?=
 =?us-ascii?Q?Y1IQxl4iQOmFjeMzxqEV0sb2R5UNIddq+QJwvv5NRVSY6X0YhWupZfEKfN8V?=
 =?us-ascii?Q?nDRopTzog2SoBIkcTfn6TxaownBUGKhJHQBuN7iWHyPLDkqQyYnXVlR0Yf8Y?=
 =?us-ascii?Q?JGKR7dmSITK3ZCqdcC4rK2Cnp/NcnSG+Eo50lRqsXm2wlZcOA/PdxB3GLKJz?=
 =?us-ascii?Q?Jlcdg/K6/aaB72h8+tt7ApRgvPMxvyBU8rsQyMtr0arp5GF8rEqmSP2mqa74?=
 =?us-ascii?Q?F6rmLu7cC/f3MRje1tCOSeVdug+dnO3q9ToGqZp7g/Uw8ws4jkdivKkoD+Fz?=
 =?us-ascii?Q?cjHQw3le5WW+98LXXVl97Qg0gG9nev+Y2dqZfryHATyQvNu84Dq+JmX4TXPd?=
 =?us-ascii?Q?v6jzO6275oPzIkedEAAy47UuAmZHw48ZZ1LIVetkuJxD8iYtkIwCLswHlqkS?=
 =?us-ascii?Q?QOAQz231/CUYhU2PI2hu5pjMljF3CuNZLD+6XFmy5yZ0Ih2qnU0ZXU3fPr64?=
 =?us-ascii?Q?37bfTUGKS51PpPTulfN4Q63S08PBB/FybhUMVPlfazHwaYm+8KR7b39Fh3tZ?=
 =?us-ascii?Q?v76YBOqSPEybgneSwy13cj1L109yRIZZLISiWv7v4IMDUqBjdo/1OaAt8+22?=
 =?us-ascii?Q?eFvh4BzBCTLkP4KhmbVs+qBlNCBe3xkRYD6+I0OFfkUnODPz9v28afx5fkgH?=
 =?us-ascii?Q?mOiNEr2DmWP5GwCXRyI7BcH3q2hn/ITuhb4xiGdVC8tu6ni1VuBI9u/cYLmH?=
 =?us-ascii?Q?kJHfXRZplIQhgCxYFJ2Hd9ngUB/klRAyCJUcpwPWMAXE5foEPF9Z06uqDdgI?=
 =?us-ascii?Q?9EPBt64gh14En0sf7GBoQnrJKUhZq6V9DosnJjMKv+GmxxBQnp5/5lAPLyKj?=
 =?us-ascii?Q?Wdg4BnOAPJkKWll5S35c0c86yZXzN6u69PnBefCfjbNKsP8vO3Kl758ZIdV7?=
 =?us-ascii?Q?MNWk4JZ02rk0jb1PQJrNW0gHYJoDQb+70R/Koe7TBeuOyaEjFG5XM8Yz9Pj7?=
 =?us-ascii?Q?Z+4CLYKTY0i1iJRO2u7dneLcsOKTbNh4H8ne//8ykLClfTDRDLKtz6O0TlSU?=
 =?us-ascii?Q?CYbg+jzzJIQX4TsAYdOVSBmZdr6VbotXo7zGEiUgmTqrg8LrIQDRnWdb3Jfe?=
 =?us-ascii?Q?5Cb216BWJxaSlIWOEyrnN44phcBEKmuyBWm0Ao/+OCm38d45mcHOOkZ6ceXK?=
X-MS-Exchange-AntiSpam-MessageData-1: QCDMRO7kJEk0eNozsNItETDQPhOtfMtBqik=
X-Exchange-RoutingPolicyChecked:
	CWJ2c0tHmTC9Hv8HhEs+jv7xZBdOb3bQZv6OcdvunV4pLGe8/XASr63BypVEHLj3gpvQ5EpUKYFXkl7Zj9y2Sm68mfXOtWfCUV5BRe4oMZrVcawBheVNZVSoSB8//VQMdLJHrvdMq7i/doUne2hnY0dpEpflfBQChF3ckRuTV3HfAMJCSmV6e4ETG+R4j47Zgr4mt6OinrWuk73KHjxdbBn2DpCXL3OqJ1foJEmgNUNhxLdNY7uw2NgZ1/pfYjA8sHcuupi8/v7cqmH1HdJ7nJWTGtXynkUIELiuAVg7wIPu6nPEORj/6dJXfVWts+VGxUua0w8uEv7ceoPGRLoUVQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DbQkI2uPJ3CONSLolKRhzjejnGy/EFVE/P1pfW0lqn2kzGM1XTU4F/3sYagSOLFlyTEDI6ugh0kXqdbvGaW3dR5DRzpyWCc8TVV+1ByUG82gLIxNNaJB8HWGwiE4w894r02DB6FbzmikpCsSAHLSkepfqAgUv+QAp6zLQkEKeUOdqEfzJhuk8dO9BS3CgbZEYGw4AitWXRfH+Dte1PUq0ky/WWetpXORcIE94Ilp4nCIqni6YsPAYaBVv2ck1QQJZnjNl5QisgqmVyM3YKj9P2tOb2rPPrbQ0ahRjo0TEqEvSpwrFObLETxjp0PH0iFE7KN/gSHcs1ANI63dGVIvzQd8K5Ht78YRcEM5GbAlPk2omqbZUTU+l8/rfDCtEaF5RerCfz665Cmv8vUAUkLBrV2SjUtG/szPvxAAWeKq9yvLz6XwyRSzXv6cOtYcRw4WqcUIR5uDAf1XVZrgSAaiKsxYa6zMH9lw0qJflMTlSM4R0XAuzchTFkjgjMZGg+rW2qdyN04wuby0ODVkeUGeI4e2yn1DNzJBS/19O4MMY8nyC00kDy/VsQ5a3IC+xdWeeI/D5kCuuDSs3N95sumaWJ0awMhz4LsLVgvDBMKob+E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03bd5519-1252-4cc5-85e7-08df290dd735
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:39:13.4037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WGkWtRcH0ks/VPWotYeJIb24ql8B9nxCuCrGrJW3NVNDiAMPk1ukww5EgJe35wAIs+1jm1uXJvJ0uiCDJo3xVK5YZHYH0jnPvq8XRQJOfxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acdfc48 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=45b4cX4q9fnkLCOmiR8A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX+4t8hIxI7NmI
 oB/JFUkXg0YfmKq94norxCwd1JvqwIG9e8JmDNBBlOHF5VX4b34i55ksRPfHdkzPrJTP3KT2UcV
 9w0qGk9nX1FNWwhBt4GzL+BOK88t3/Om8CJcBe6BC/Pz8vzxXAqJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX4tIMW163JDXz
 2k4aDHRM9CFkWiawWNaWE/Itv3SdAKYANx9hVWpSeRoCfyNr8Gs85hB1vN5lzCE4DxseFozlF8l
 XMJ8LNyQZS3/Fs2UhWJiWjeKUwe168Hj1cboTb6oC6OIp9HWQlHyBZCygXZLr7s3z2toisYXD3n
 HOk9HVs1Q3Pd9d5M/XpcPFtIba8Acw9f5h2awloxy9AL+qbf2MThtv63b3024s3tCfUznMaUQbY
 NAmaKRibdrrwAcuAF36b03eAw6Dwr8B9SlmJRJdjaMjtUmeRa96eflQtXJvm1pGPxOb9eHJSTAf
 N0AcaG1IO2av3uwzIG2g6SK6LmosnnDDv/QL/Q9atF5qZW8hn0jij57X9y6hb4vdTGROuHJWy5I
 /CCdqZCPQIoF9ZM4gFO0El4oKHQwOOq++AmLm+twu06kEitz+4pzBvnu/pXiaH97dNgN+UC022P
 bxe7QAbWejvsbqCp8lA==
X-Proofpoint-GUID: dGUzhGroL9rKNq-zrnIMFPu2Ue_eBLL9
X-Proofpoint-ORIG-GUID: dGUzhGroL9rKNq-zrnIMFPu2Ue_eBLL9

From: Dave Chinner <dchinner@redhat.com>

Most buffer io list operations are run with the bp->b_lock held, but
xfs_iflush_abort() can be called without the buffer lock being held
resulting in inodes being removed from the buffer list while other
list operations are occurring. This causes problems with corrupted
bp->b_io_list inode lists during filesystem shutdown, leading to
traversals that never end, double removals from the AIL, etc.

Fix this by passing the buffer to xfs_iflush_abort() if we have
it locked. If the inode is attached to the buffer, we're going to
have to remove it from the buffer list and we'd have to get the
buffer off the inode log item to do that anyway.

If we don't have a buffer passed in (e.g. from xfs_reclaim_inode())
then we can determine if the inode has a log item and if it is
attached to a buffer before we do anything else. If it does have an
attached buffer, we can lock it safely (because the inode has a
reference to it) and then perform the inode abort.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit d2d7c0473586d2f22e85d615275f34cf19f94447)
Stable-dep-of: 09234a632be4 ("xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c     |   2 +-
 fs/xfs/xfs_inode.c      |   2 +-
 fs/xfs/xfs_inode_item.c | 164 ++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode_item.h |   1 +
 4 files changed, 137 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8d5458b463e3..51fb70bce819 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -898,7 +898,7 @@ xfs_reclaim_inode(
 
 	if (xfs_is_shutdown(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
-		xfs_iflush_abort(ip);
+		xfs_iflush_shutdown_abort(ip);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 98955cd0de40..13a113ed666f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3648,7 +3648,7 @@ xfs_iflush_cluster(
 
 	/*
 	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
-	 * can remove itself from the list.
+	 * will remove itself from the list.
 	 */
 	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
 		iip = (struct xfs_inode_log_item *)lip;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index cda71e0c70f6..1e9980a5f80e 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -544,10 +544,17 @@ xfs_inode_item_push(
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
-	ASSERT(iip->ili_item.li_buf);
+	if (!bp || (ip->i_flags & XFS_ISTALE)) {
+		/*
+		 * Inode item/buffer is being being aborted due to cluster
+		 * buffer deletion. Trigger a log force to have that operation
+		 * completed and items removed from the AIL before the next push
+		 * attempt.
+		 */
+		return XFS_ITEM_PINNED;
+	}
 
-	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
-	    (ip->i_flags & XFS_ISTALE))
+	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp))
 		return XFS_ITEM_PINNED;
 
 	if (xfs_iflags_test(ip, XFS_IFLUSHING))
@@ -827,46 +834,143 @@ xfs_buf_inode_io_fail(
 }
 
 /*
- * This is the inode flushing abort routine.  It is called when
- * the filesystem is shutting down to clean up the inode state.  It is
- * responsible for removing the inode item from the AIL if it has not been
- * re-logged and clearing the inode's flush state.
+ * Clear the inode logging fields so no more flushes are attempted.  If we are
+ * on a buffer list, it is now safe to remove it because the buffer is
+ * guaranteed to be locked. The caller will drop the reference to the buffer
+ * the log item held.
+ */
+static void
+xfs_iflush_abort_clean(
+	struct xfs_inode_log_item *iip)
+{
+	iip->ili_last_fields = 0;
+	iip->ili_fields = 0;
+	iip->ili_fsync_fields = 0;
+	iip->ili_flush_lsn = 0;
+	iip->ili_item.li_buf = NULL;
+	list_del_init(&iip->ili_item.li_bio_list);
+}
+
+/*
+ * Abort flushing the inode from a context holding the cluster buffer locked.
+ *
+ * This is the normal runtime method of aborting writeback of an inode that is
+ * attached to a cluster buffer. It occurs when the inode and the backing
+ * cluster buffer have been freed (i.e. inode is XFS_ISTALE), or when cluster
+ * flushing or buffer IO completion encounters a log shutdown situation.
+ *
+ * If we need to abort inode writeback and we don't already hold the buffer
+ * locked, call xfs_iflush_shutdown_abort() instead as this should only ever be
+ * necessary in a shutdown situation.
  */
 void
 xfs_iflush_abort(
 	struct xfs_inode	*ip)
 {
 	struct xfs_inode_log_item *iip = ip->i_itemp;
-	struct xfs_buf		*bp = NULL;
+	struct xfs_buf		*bp;
 
-	if (iip) {
-		/*
-		 * Clear the failed bit before removing the item from the AIL so
-		 * xfs_trans_ail_delete() doesn't try to clear and release the
-		 * buffer attached to the log item before we are done with it.
-		 */
-		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
-		xfs_trans_ail_delete(&iip->ili_item, 0);
-
-		/*
-		 * Clear the inode logging fields so no more flushes are
-		 * attempted.
-		 */
-		spin_lock(&iip->ili_lock);
-		iip->ili_last_fields = 0;
-		iip->ili_fields = 0;
-		iip->ili_fsync_fields = 0;
-		iip->ili_flush_lsn = 0;
-		bp = iip->ili_item.li_buf;
-		iip->ili_item.li_buf = NULL;
-		list_del_init(&iip->ili_item.li_bio_list);
-		spin_unlock(&iip->ili_lock);
+	if (!iip) {
+		/* clean inode, nothing to do */
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		return;
 	}
+
+	/*
+	 * Remove the inode item from the AIL before we clear its internal
+	 * state. Whilst the inode is in the AIL, it should have a valid buffer
+	 * pointer for push operations to access - it is only safe to remove the
+	 * inode from the buffer once it has been removed from the AIL.
+	 *
+	 * We also clear the failed bit before removing the item from the AIL
+	 * as xfs_trans_ail_delete()->xfs_clear_li_failed() will release buffer
+	 * references the inode item owns and needs to hold until we've fully
+	 * aborted the inode log item and detached it from the buffer.
+	 */
+	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
+	xfs_trans_ail_delete(&iip->ili_item, 0);
+
+	/*
+	 * Grab the inode buffer so can we release the reference the inode log
+	 * item holds on it.
+	 */
+	spin_lock(&iip->ili_lock);
+	bp = iip->ili_item.li_buf;
+	xfs_iflush_abort_clean(iip);
+	spin_unlock(&iip->ili_lock);
+
 	xfs_iflags_clear(ip, XFS_IFLUSHING);
 	if (bp)
 		xfs_buf_rele(bp);
 }
 
+/*
+ * Abort an inode flush in the case of a shutdown filesystem. This can be called
+ * from anywhere with just an inode reference and does not require holding the
+ * inode cluster buffer locked. If the inode is attached to a cluster buffer,
+ * it will grab and lock it safely, then abort the inode flush.
+ */
+void
+xfs_iflush_shutdown_abort(
+	struct xfs_inode	*ip)
+{
+	struct xfs_inode_log_item *iip = ip->i_itemp;
+	struct xfs_buf		*bp;
+
+	if (!iip) {
+		/* clean inode, nothing to do */
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		return;
+	}
+
+	spin_lock(&iip->ili_lock);
+	bp = iip->ili_item.li_buf;
+	if (!bp) {
+		spin_unlock(&iip->ili_lock);
+		xfs_iflush_abort(ip);
+		return;
+	}
+
+	/*
+	 * We have to take a reference to the buffer so that it doesn't get
+	 * freed when we drop the ili_lock and then wait to lock the buffer.
+	 * We'll clean up the extra reference after we pick up the ili_lock
+	 * again.
+	 */
+	xfs_buf_hold(bp);
+	spin_unlock(&iip->ili_lock);
+	xfs_buf_lock(bp);
+
+	spin_lock(&iip->ili_lock);
+	if (!iip->ili_item.li_buf) {
+		/*
+		 * Raced with another removal, hold the only reference
+		 * to bp now. Inode should not be in the AIL now, so just clean
+		 * up and return;
+		 */
+		ASSERT(list_empty(&iip->ili_item.li_bio_list));
+		ASSERT(!test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags));
+		xfs_iflush_abort_clean(iip);
+		spin_unlock(&iip->ili_lock);
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+		xfs_buf_relse(bp);
+		return;
+	}
+
+	/*
+	 * Got two references to bp. The first will get dropped by
+	 * xfs_iflush_abort() when the item is removed from the buffer list, but
+	 * we can't drop our reference until _abort() returns because we have to
+	 * unlock the buffer as well. Hence we abort and then unlock and release
+	 * our reference to the buffer.
+	 */
+	ASSERT(iip->ili_item.li_buf == bp);
+	spin_unlock(&iip->ili_lock);
+	xfs_iflush_abort(ip);
+	xfs_buf_relse(bp);
+}
+
+
 /*
  * convert an xfs_inode_log_format struct from the old 32 bit version
  * (which can have different field alignments) to the native 64 bit version
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 403b45ab9aa2..9c829cf5c839 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -44,6 +44,7 @@ static inline int xfs_inode_clean(struct xfs_inode *ip)
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
 extern void xfs_iflush_abort(struct xfs_inode *);
+extern void xfs_iflush_shutdown_abort(struct xfs_inode *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 struct xfs_inode_log_format *);
 
-- 
2.53.0

