Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3277414407;
	Tue, 13 Oct 2026 09:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884340; cv=fail; b=aaZy6GvHfvhcMNQzeHJWvPQN9DOWI7LPhxpK+aYQfV5J2KBEltBl0L0wEczhJv56KLmWp0qwvEN4XSq06RWpgBBLNG/AB6gXcr6jFu8s4glreLwiv/yWFJguHxSeE2XB+lexkqLph9XKUPsLoNIPmKgXQG0pP7cgm3YrbwKfrq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884340; c=relaxed/simple;
	bh=aNgLsvRCaD1d4TkwBeB31zBaaeHCo9cbNtReMoJBL6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X3F0ZZbfHxtLhk/7x48F+V/qRNhB3rFxcmnvUSHMYhXlBSjCd777fSUNl1lkNk/JjHz4BEjIeR2RMJG2zi5tS8DObt1e6hVOghttkVDTtd+R+IVdvS69jWqs7FsCozikIAQF0Lg9PA5gnpili1oI1FzANCdc938hcVEQ0w2qlfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TeeamiRY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=akjaw+kj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TeeamiRY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="akjaw+kj"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bq033200269;
	Tue, 13 Oct 2026 09:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=; b=
	TeeamiRYNaYR6D6tLK803mEH3yommoQ35kO2P9X9bKFEkGph3AEgIHHmyeYoEmem
	EeXKb7aBEKwB6aG5CF6fhWU7FwU/hJjT9QHP2vOE5XYntfYSrmLbFy1Y1n+7JUsc
	F/9QCjmd+B6xwTrN67ePLI9MjDS9s+AZCxY0ibF/Ta5t1SF5a9DcCl7mH2/qVPWp
	anrMDhUnY4ru4t6ptbCiUKDUh6+b/XQ6cbN9+FcVfrgrHn1S71VEcW+stMF6yqmw
	ryWpOajcYyMgic86fUUT4fYlPAOscSB68m3pLmQ7BIfjVSCzwQmpv4a3sV3P6hKF
	4OUp/uwMNeXj8hnHcQOxKQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demkq6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aUtZ010940;
	Tue, 13 Oct 2026 09:38:54 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011054.outbound.protection.outlook.com [52.101.52.54])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d49d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a10hsZA/27MwwhagENU+6zuQulC00+sbrkxt2uLPaxbWC6+MuEeLKdG6kMSSoM9frMS84KYf96uMPznRF5pnIvvOIGgs1Xq4FzU4YtObYSVNy8Svw6FQ7saiSydT7M3tLreW1Zj983BVpfzCbBPhJTJmG+njXcAqPwNimtk2i+BfDEW3LDoTgFH7gNPFBilmoSh9Ex31G5EOh2CHZ2oyoEr9sKRVMlhY9tSnvyDoUJAf21aXK4NOfadNHWhnoYC2amPL9No8GtyyuokT2qiyteDmkPuEe3UXY4x6z0F02cDkKHtiPcg5RD1Jlv6DmFa9Ej3d4ET4eZwLV39Cs4yRQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=;
 b=IgCAJk2kbjyI5YPWyQTVSYR+Cg2cOlDpSW52FquJlyzYnxPEEBNxVfmyAYa9rV8Jzs73AYFztfMe4+GgCu6b1ZEznYULSvcgWjF82LXFeUnKsYgtIzTBOGJleTgvMfkhcQWKHq/6deRqrxJMDCfHHYR4Lq1iymjirxrbRvjSh2jsFeHAsFy+NvAQQK9HGFGdCE8NgmXasSjRhT43pUuYGPJlY88XPbElq5eNf9t98VN7VxmPnsCCpu+4kZml8snFrYuQAXc1yTypdcbDCCLRBugmUPfx9Oy/xwHvJJVLCD4LA+F6w8VjGBQdt3gnW5byLLsT/jQkK8RM8YWNRKdAWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=;
 b=akjaw+kjFf6RvuKsNH7cFwE8smy7ANyi2jrWDnUuw0EuNnNNliDPKe7/2Vfe88G409ePEzv63ntB6lbSA/WjqWJOn+gYPO/9W0iTUhW2EG4Fv3C0hGdMSOnn0aBL2+9Hx9mkPaeuSo9i/iY1OTO8llUOcyM7JuJltVemJcT1rqo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:38:50 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:50 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.1 v2 3/5] xfs: rearrange code in xfs_buf_item.c
Date: Tue, 13 Oct 2026 15:08:30 +0530
Message-ID: <10ff9f67a65be8534d41b262f5f642add299544c.1791883290.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883290.git.siddh.raman.pant@oracle.com>
References: <cover.1791883290.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d17e1b0-3422-4ed0-115f-08df290dc987
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	wujCDbzDb0nYYdsvEuKoSpw3lXer1KyBS0t4CrbopiSLjj4BL73zddyvjEh/mkvlEZoc9SmXcuTye7bCnKC1q/gTHtIQN0MAsl0yeGUuM3Yq//bPm/PiHcASHRmxJX3zdM/6nYer8eQauTrNQJXOf3krxZypzbnSPJo8RnKWagl7mfx8VLPnxJxA8bC3JX3Jh/uU4nXy7MJnqxAUeWc3QBfy8ojia4U1ZtZnZdhjWGirQbo8rQxilQn4LNT68SL9VTf/Sq7VWwzwebJmgh/IsYNYs4g/wc6KtpRyg+lRv7o+t91XClncupCqmaPMCP0PpHadAcpM1E6NiW2AbySGRb4Xkb2nkvH5kpewgzu5ujVv5CVoLOFT9UlbY8C+PnzO+jYa86XdQWNZ/u5lfxVrjziXq7XcdiyaMEJOkSDg0lAuaDHkSeTQtgC8igZUVJ8rJzm6YAYq3lT6gjnyWEiFpucYan3ybubgOtr6kvbM1qF6TVWW9rU7HIu523mgKxxL+iHr3N9UUvfzib6cOUkPx9G5jeWZbd2ElcLA5IYE0TkM7kK1rTCHOD6FPAezQ9jI8R//14S6tZPgavAo8n2LuGdgD+FpxALAdcwq3hBy8KKIPyt2jaHKEEnRXeFdyD7V3UQsd/dSi+mfocp1aYLpvabNbHVN5ASzDrkH+QDMM5c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9clTxim0z8hLMIRx/mbmWQ5hRt71P6zNjJI4zuwqe0sGcel3n1eH8jq1gR0Y?=
 =?us-ascii?Q?qLLZZUwfzAjdzyPcq3KmgRvvT2bqmG1knKyHiiWvK2tbCe/ndpqIenLSlIsh?=
 =?us-ascii?Q?/QOo45qb6ySGq0BnweKLUA9eufzKbHVcL90WLm86b+vTQcADQAeyCapDdSuu?=
 =?us-ascii?Q?VnAusc09ZW8qXd23mzpymTFbV+9o6fdbe1MiC73Ovm6fkKHYTr3aBRaVnSR9?=
 =?us-ascii?Q?Ukz6yK20LafMvKEJq/WCjwobgRGHIJpFGZYYnrbT7fp4tTW7saMOvuYn4OJv?=
 =?us-ascii?Q?uaZSGyA0ezXLa6ioufmnPv7P8D5L0NyaoYKv3Ld6KPIv5a1+fUWtYGGiftE+?=
 =?us-ascii?Q?N2ON0Xre4282yQnCfREL3oKIVbJ1bgVd4T10JvRWgE8Om+x4az88ANJm0kT0?=
 =?us-ascii?Q?Svaw6vqhTQ1a+hFFZIh/ziqTg+RF3nO44VPJbUW/hs2hNEVdBSJeA4f2PbZx?=
 =?us-ascii?Q?Cxb/YThMUXpLogsDZ5Z3II9Jf31H8Q0uSMnN320GdhvMN7DC1wzhoif/Jf7v?=
 =?us-ascii?Q?DsOtd60xeAmIxs3bp74p5cXWA4fHDf97OJB7KPkP4BvWpM3g3WGcYLQ09SGs?=
 =?us-ascii?Q?cQly7ogSgB+mgL4+y3ohG5RgNejzbSGyu/sGkg6bnlvQjFUQgl6fMgxKE66Z?=
 =?us-ascii?Q?2gjdgpOFDehpRBdMDCYRNi4DRacEv0WjM4KDTZ95GWW6ty7hb5LWALQm608s?=
 =?us-ascii?Q?sJ/8e4J7qlsC0NkwgSDZbTxe3voo4UDPIDrg+y+QWX29Ys+8BXuRgcAKa1HP?=
 =?us-ascii?Q?OCBRls8rryFQy230N2xVp3PDwYGvxQjFEKS9709mVpen2pXanvXz9uYdN9Q0?=
 =?us-ascii?Q?tjpTkJ2f1tD7b8lJplG8oAdjuzEg6OTvAlh/ER2qypa9+n/PPxJ7yc+pFUeK?=
 =?us-ascii?Q?8WKMBMmQsJDP4btqe0mtIbChDvrxc1b49b9gXHxQwNhPbLhIanwtfwDGIwEC?=
 =?us-ascii?Q?f3aKA+NP3LVLZTH1ATIC9t4kqaUAMu1Rn3yRgrqamL1uwHpR0Lhbrh8PBXR5?=
 =?us-ascii?Q?PArEiQLFJYrBVNIuMjej/aWJtIyjPP9fQR5Tq+cSDlmcehQenC0qTZ/9Nlxm?=
 =?us-ascii?Q?WuEINpQWIKbRR8MY37Z8t3JaoDDd937zH5nqmG99rGbowAGv3bjBABnRJ6CB?=
 =?us-ascii?Q?Ee5axS+Lk8tDpHLiHuce7/CaPms+QjYUTP0cAU6lWj2Q+gTOxS1pR6Pnz5xo?=
 =?us-ascii?Q?ZYJgWAoZpKqOSVPYNLXpKVT1vyUuf7+M8O1ViBfH3CKjRql6LUjKka5RXbdy?=
 =?us-ascii?Q?UJ0X5lf8hOt+wmQdhaK2RIFxYU05Ix3hr/E5bKa/RrisY/pxg2lc9oHIuxRA?=
 =?us-ascii?Q?xzjNhg18/bj6mOjXktt+YFeJfH2s+0GL8j4Vf7oUocGgHT4PDXDrk+MGVWQo?=
 =?us-ascii?Q?Ra/DK+MQDJyIvLWZ1Si0qJ8Rd412nWc/IQLjDWnUDN7zufzqJ3aQ1NSH72Oy?=
 =?us-ascii?Q?94caPvyEnMi3UNXJ47J8zfHq1gsJlkpyZelb7+UlikDbngX88L53UwhU8+Ga?=
 =?us-ascii?Q?mGBXvOa+4yV/wcLYTRiHSJu63ljIs/mEx8opozLUnX0eev1l6ClPrbxSJZlw?=
 =?us-ascii?Q?Be2RZdTpPXleTeuKIt4XcrPQigEv/vIHlEl5DSetL9ZoC5REpI7/55rDoo1m?=
 =?us-ascii?Q?Vw/pitYQSdw6l32dFz3YIIHdC0Hp6A8kQcsvf2WlyHM7pPRjNJ2w/g3QiSR7?=
 =?us-ascii?Q?CUCzx1wyDjb4kbzwKFUXUL4/0DfBgsShRO1sj65IC8ItWM1X3nCie1WIylDR?=
 =?us-ascii?Q?MYq28pLhU/5AuHW0tlFpCLlfoXrzK1o1yjExH6DEc4FpPGcEj4s6hyID6kgc?=
X-MS-Exchange-AntiSpam-MessageData-1: ZVGCOqspT17kOg+CM5IyClfUT3piBlaOCeo=
X-Exchange-RoutingPolicyChecked:
	42XGC2dtXo8xRGFPxRignWzd+aoQQRdcEU29QxD35FXqtu34QKQbdRWKvcSfjJbx0a1JccbE5o36lHaOlEiUSv1yBt2L6dbPiugCgdY1erKstEcipYics1RGbn6QEe9UhhhN+OhruBUBprjxB0zLQ97/gUNy8w17whQQIp9cUFuYlfiIYsKzcAV5BossoX8riA3PCb7X2r7ERIZyl1AtX6V56NJOsAtNpxGGZPN7LsMtAhYpMvZQHHjFiIfUwOeiYluYFvKzo/7GNZGUe3OEVVXmPPQDnQkqPxJt+fumuMRU3Db0PpljPd+Ftr8fdILv4K8xXBGdYrem/G+3TrXG3w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rN+PhRwvzMtSc21r2A6fg9TGLnpKoUdUht603nwrniOWcjc8AGM0td4A7AshEWSORHX1XhxAbvv76iVnjmx7RqOfk/UBYmsWw8ik+KgH04RFcFXhfNFa4PBv7ZuqjSguErLoFOx9IN3iIK+PkdIlXhcRAX3VlBqeWakxQhHdjXLgI+8sWSMxdhi9Va6sjni42u2iRtX7tlPk4mhjVtgr6WNXPmE5b+35JLVVtbAE+lCty9v6AaGeL6dOHe1MzU6J7rK6LFokg7gWlsDIesdxoso3XVHxT4AJ7CPXrTNXMYy/WxufwgRU+F7/GDiSj89H/rTMRKw7T+6vDJt1j8P+X+BueSmR2WP8klwV3mxEbKQMHgKxrAe6yTY00HpBLcgiwKFlwIcEvKeYBcu2QMJUxZAYsLuoTx9oqW6V4NTDgjYPk3Ur8To6evT4AH5FAYXina7uJ+9QPl4Q06BNoMGnk+FOtOJmwajfiaSyAVap3ffWmTVTYRzZ8NdpcrGxzjavztBZ3WkRWl6uczbIuTxsMHAG8YO3JPioTo3ZwmqyDWA/MhVYnu50navtWv8Uw4zhuKoCgkLt0iP3C03A2WyEqRBOvkGCnnXp5i+/kwvz2g8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d17e1b0-3422-4ed0-115f-08df290dc987
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:50.5237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Y805FkB3b7v0QGfVgLPqvJhxjaHXAa11d+40DBpBLZ6BRzysmfSYH/Iwq/+DqJmNJgEKG1rSFtSDL5Pm2sKvWzPsCQs1ktvVkWhJF1BYzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acdfc2f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: fgpRmkC9lVjE7BU2HopozIwgr_EmjW8q
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX8sWnPa4sAHoL
 71CkYHJJZ6QNKJnZpfYJSCYna9j2MqPzPZ1809burZptOjEgvMSFLkrcv8c09dnDSRYbqpR2shL
 Id66BedMYHUJFQscqeXF2OX1liqFCMKk//qnAvBf3qzdv20XTn7t
X-Proofpoint-ORIG-GUID: fgpRmkC9lVjE7BU2HopozIwgr_EmjW8q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX85dtTeORX7Xa
 Csirkv0VKmImaqpyhwZDNmnrX4XJGY+9as/LKprx/aA1yqYCROwm7bN2D15sTFSzi2e0obXHdxo
 OPJ+xQyYRp0zuonMAFhwhABQN8yVu8h8JepV3oVaHCdUVt64LoHc7uGNva5ReuIdx4T6vIXm1XH
 9fh4XKcsWVtMMrpKModqDIGO2RNhWX/edOQ+7oRiVcNWUF4AaM1ywlUpB3OmTE8mr+Lz+am5JA+
 lAHw6/MuZiwe/J/MZCl9XA/KcrudlO/ChytQ1lOixXHUSffapov7veu7wyXP6l1zsFdUa0GPc/M
 vCIbmm8QRH+8qiM9xCkL3SfUdclXtpUlvYWstG3ENs+EICpj/WguIxXHXXCUoaUoXtzXdh7XplI
 bqe9Lo4RyX2kOSTVbAscAob466ImP4hgti4IoKSn/XV4bpds1y7PVd1A1XUZRD6MfkEZwg3AwNX
 wg7V4tC70UCG1X7SVwQ==

From: Dave Chinner <dchinner@redhat.com>

The code to initialise, release and free items is all the way down
the bottom of the file. Upcoming fixes need to these functions
earlier in the file, so move them to the top.

There is one code change in this move - the parameter to
xfs_buf_item_relse() is changed from the xfs_buf to the
xfs_buf_log_item - the thing that the function is releasing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit d2fe5c4c8d25999862d615f616aea7befdd62799)

6.6:

Fixed conflict due to the following missing commits:
	[Continuous range: 10634530f7ba^..d4c75a1b40cd]
	d4c75a1b40cd ("xfs: convert remaining kmem_free() to kfree()")
	49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
	afdc115559c5 ("xfs: move kmem_to_page()")
	f078d4ea8276 ("xfs: convert kmem_alloc() to kmalloc()")
	10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")

Removed ASSERT in favour of existing atomic_read-and-return in
xfs_buf_item_relse() due to the following missing commit:
	3762113b597f ("xfs: don't lose solo superblock counter update transactions")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 118 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf_item.h |   1 -
 2 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 72d6e2dd5ef5..1b323b3c0eb9 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -32,6 +32,63 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
+static void
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->__bli_format;
+		return;
+	}
+
+	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
+				0);
+}
+
+static void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->__bli_format) {
+		kmem_free(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
+
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kmem_free(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_cache, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+
+	if (atomic_read(&bip->bli_refcount))
+		return;
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -563,7 +620,7 @@ xfs_buf_item_unpin(
 			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
+			xfs_buf_item_relse(bip);
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
@@ -673,7 +730,7 @@ xfs_buf_item_put(
 	 */
 	if (aborted)
 		xfs_trans_ail_delete(lip, 0);
-	xfs_buf_item_relse(bip->bli_buf);
+	xfs_buf_item_relse(bip);
 	return true;
 }
 
@@ -824,33 +881,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC void
-xfs_buf_item_get_format(
-	struct xfs_buf_log_item	*bip,
-	int			count)
-{
-	ASSERT(bip->bli_formats == NULL);
-	bip->bli_format_count = count;
-
-	if (count == 1) {
-		bip->bli_formats = &bip->__bli_format;
-		return;
-	}
-
-	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
-				0);
-}
-
-STATIC void
-xfs_buf_item_free_format(
-	struct xfs_buf_log_item	*bip)
-{
-	if (bip->bli_formats != &bip->__bli_format) {
-		kmem_free(bip->bli_formats);
-		bip->bli_formats = NULL;
-	}
-}
-
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -1072,34 +1102,6 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kmem_free(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_cache, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	if (atomic_read(&bip->bli_refcount))
-		return;
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
@@ -1119,5 +1121,5 @@ xfs_buf_item_done(
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+	xfs_buf_item_relse(bp->b_log_item);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 7ddda0aa9dac..8a8a46e698be 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,7 +49,6 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-- 
2.53.0

