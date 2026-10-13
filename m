Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D4D3EA97E;
	Tue, 13 Oct 2026 09:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884384; cv=fail; b=B0OJD3P55pq09PsLHq59AMVd9gIUSAZPSJpPJ7wgLtIOD6+y8lD+SE0TQn8N6Ctrlax5B3o5nJCrxu34cotXPJA4e6UitMaWuR1g+0rk+ZQmitA8ralv1w5ZkMo3h3OZxX/PeQyRFDJQxX766uTndR92fibAXoINnhikfjUDACU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884384; c=relaxed/simple;
	bh=bXS4Nlm9NjAOfYO7EPPOme6CYeLp5GKbnPrIiobDUEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OKv6/0ENtnNguUa+YfE2ich+lHiEEKNUEhrsVrQtZ+w0h1SV8votPuztaPEq3j+LQ0+N9lYoBkl1qJJZjxvhGT0UgVvvxLMzflmN3tNmXPVL6bNj8qFWVTHA/CJRinOCFdFkAwfwSl/aoY5H9CswIE1fYG42jZ4IrIAobLDj9x0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P5yw0187; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QW7raoUh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P5yw0187";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QW7raoUh"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CQmt3434524;
	Tue, 13 Oct 2026 09:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Sip0nQy0U3JnT5OTbSTSKF7mc/9kh6CySPYgRcfpTwc=; b=
	P5yw01872OOyS9cqtzmE6t0sd7sDPjbbnRy8rhmam67ebBLfliCg+durhgcyIdXJ
	O7ebckIRhZUx0+qCoZcwYYW8/dS52ha6SDOTUqJL92FBY8aG5jWWWjZuwbCOwMbP
	CpfrlS+ScIeUO8HLwbZgLa97zI2xVtarNe0vFnZskFrrw9g4kCyTYO1xrCzG6p2G
	qaEkUU/vLWZGr/IENTxRSyhHu6VTzcf2e2qf/W7lMqXK52oTtZu40UnCC7qrPdvO
	byAc/3lITm4wiiPiw3VAsC4FSYhnfWFdc84sJQpGu1BDR6Wz71lGB/XircJLsgWe
	jHAWdUKGB242SJyGADIMXw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kp54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:39:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTiW010917;
	Tue, 13 Oct 2026 09:39:38 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010011.outbound.protection.outlook.com [40.93.198.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d4yg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:39:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sucQQfBi5ajAgs7j98tY6uwpUg1QIuzYXLmh89INv8P0WiYTL7IJvJb4itOK2SsBaKOH96MG+pd88z7y7Ra6//TusVqtJusfMCARhCqeqPRJaF5czOKlgqXP9rG50kDuSseKW14PsL6bV6JkHO7I2t4mhEU1erqc0TvWYrusFLrdI8jBOZRP4TyfkE5G9Ezeq5MZswiVkz/2MYhu3X++HsE8lmodEVNgzjMISlS8WM4UsyelmesAlMmmrxlF9GcFbs0VdOKV8Ltz/WfdEZjt8bCcYQXr0kbbui0QuLA7309wB+j8RD/bWYQDFx9qcXLFnjgCaf2P5lEDewcBiEiiqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sip0nQy0U3JnT5OTbSTSKF7mc/9kh6CySPYgRcfpTwc=;
 b=Tq8+mVQyBzOZs8g5prTDk6BJ4dLkVQxoMT0cUXfNI0s5XfQt29heuJStSABQEmv6lDgFY61jb3tZRmzzfUE615nMMRYSDIfXQWGKZrhdPC/28I9gEo+pR2dPzAjHF47GstR8yYnZbQ9QGV+JM5ehNpBlJh/woUnofvq8MR4+uNu55frKhnMMVGkmnsX1PHF7qbQ0rRH+YuNYUF0DJiFV3MU+eszRPqasx1UtTMUgUQ7N4O4o+IZtvxG4KR7DAkeD3KQrhukdB9swZV8zCz7WE7ECa8f+VAOXORWu7/fxX3pztycnhhc0MFa1Zkb6WW1gp0/wSDrCuzPjUfK/fGag0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sip0nQy0U3JnT5OTbSTSKF7mc/9kh6CySPYgRcfpTwc=;
 b=QW7raoUhUgOJVOSwPbL18B3HSoDBIMDIA/6lTtSaMvv+LlJxamHvQNCR4QUZMG/ILmIsF3XEyxW6kmu6HZ9tyYDrX9+bSqFK3a7QGWekCTcLl5zHnEQkfryBOOaIippA+M6H/bBWW7h+GJ8cUZeqlE2nk18HYd4cVXvL2BrUL6g=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 IA1PR10MB7213.namprd10.prod.outlook.com (2603:10b6:208:3f2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.7; Tue, 13 Oct 2026 09:39:32 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:39:31 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.15 v2 6/9] xfs: catch stale AGF/AGF metadata
Date: Tue, 13 Oct 2026 15:08:57 +0530
Message-ID: <5901a67481d94cb21874d9bedefe9df881ceb61a.1791883296.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883295.git.siddh.raman.pant@oracle.com>
References: <cover.1791883295.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|IA1PR10MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: cf6b7312-fa50-4979-32c9-08df290de21a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|23010399003|261009223027099003|5023799004|56012099006|22082099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	kjyzafZZ8SKI/PH7fduqrTUArzTjUFGiRjvQC75jVQM1BuKSS0SXwLb8CWrGTEqam9d08Bj3JiIgJKHbnecGBeE8w2wITYJzqlzKpP6oq1xS0Rc4OLSUmz1mibxT4jXqRV9FPoN2Foc4VVbWBsf/9DPZml1ntGElyJqgGN0TMCNb7UKEUzdFXUlvsQrUXU7a6+se88riWIi2Uwz+9LH1iGuk+pOlNXOp1SXRXOEK4S0FCRPEGMvyLmyxzDJZX7sR7mfBI/uXDsjSyO5Bx7N7YShGiHAhoBdWo8xkS9IvoJbCqwESyJ5JPC0N2sppAQo8DXKTT8EJwy1dbmVboPlTyshdqJvtvM8EaPCGce0DVSRGIZZofQppOvPmGxra8G6MZDZS4ZGZkM1VWvcp40fiyZ8lpMU2eu3R2J+B7m31ug3pkfRvQ3PNs7Yq7dkHoCk//gVmKeeIOrU7+iEz3QSgZGDvEvozDfAWefiyFLOxLXiWlKgTLL6SxHvD1WGwJJ4XD7MTiJqUr380p0b3TgqTH0qXtn2nkuwAC/qCYg2GdqeBtJ2pXEeb6fn3tOu1tjznWtsOfGgtyWDBxakDgZvsG8QL93yZtFI346GS2MOnDYsFGrfi0Q0QFgNsYWCao2nSSwONn3RhZX5v9liR2U+jEwo4Y2BkV/xkgFID/8yIznc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(23010399003)(261009223027099003)(5023799004)(56012099006)(22082099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AocFnXjxj/a/48NduYRjitDBMHZYWjvxM/PRQ21WYWP+U0fQrQpC3daq6jB1?=
 =?us-ascii?Q?swt3ibiJVNbk8ilFcY3xXTGJdeJikCLZo651O6QrmOsnUYQH4k55oJPddxEv?=
 =?us-ascii?Q?Pw5fVbqHzjHvouMCC5A9vxu6ky0mXEjhg3mXFBSNimkGZWQUH4Imx7fvXnY0?=
 =?us-ascii?Q?kcXSo/qBathKSQuyph+iyFS6rIkcT0mwiMj1AmbLStpcYB8NwOxIsKetC5NI?=
 =?us-ascii?Q?/3VLp7Z31d4PvFAjWbFSNcVdQzTPng/6T7WDu3jfaET9NuzW+mO7KJzkkez+?=
 =?us-ascii?Q?lAqYqvnKzzlIaWEnxZjmIeDZLm5Fx0NbS5YwNt0dnlFIJbaBBzjQ4idGmGDU?=
 =?us-ascii?Q?5CcmJ6PXHULbqW1XahAjdyKACDOTx0efATvmfEC+E7tkZTGdNjrAa1wJPejL?=
 =?us-ascii?Q?4JKU/C/1Xf+dsj+rHmPf1a56++vN4qwmT0ZkKI2Nb25PMDgrAgW6FYa8WWhd?=
 =?us-ascii?Q?Ce28lSUDEqRRu5Aw4DyHCDyisI8Sog3y6J3XZFGZZxjKRcj0xVpPPJaxkMaK?=
 =?us-ascii?Q?B2NWb7X9lZeE8hlJD9Ff/0Ewpm1mHWgg3cgkBgys6QRH+lEwdteun7iFuTlS?=
 =?us-ascii?Q?nZcZA+WLXcp1OY2xtK348lRqDZ/9ZwzOFy/41eRCNNhmMVY31arbUJS7S+hO?=
 =?us-ascii?Q?7NaQkZ3EMf4YsxgvCUH6SHBB71QC7s6vSbkIuEaE7CqvUZTUFzuzY2T/u+GK?=
 =?us-ascii?Q?vymqrFO8tShXucfJ4MH/4dY9R1vae2EzIfJGT78yQVi6M46DYAWVnwtj8Ek3?=
 =?us-ascii?Q?ExIKlZU4H2lfWV31eoBGhI2ZX1AoCt7OjWGiZd6HIpZK0fNhDX4F+RaPsyNL?=
 =?us-ascii?Q?z0MJ4G6M7sHqeuKaS7HOzSf2Pmj+tW92NjBL8tgU+sYM0D6rPJKe0Oqx/RNN?=
 =?us-ascii?Q?PVxOMrz+ihDIMhyJAxmUaxEUhcUNMLMgdr43KK9EPG708ZL8b1JD8p+HgMCk?=
 =?us-ascii?Q?s6hRu/grgXZ8haiIcuyXHulC7UCYP57skE7oblmbH8XoTXA7LjZTgGphAeaE?=
 =?us-ascii?Q?VLFRT/cyfdWaGj4w00dMFaN9szdHaboEbtB1OkH1pgCe2T+FZCf5FXCCcqag?=
 =?us-ascii?Q?9AfjCSTHfhvM96oAp4U8arwSlPRMT5hY00LSrT7GW3CRWtdDr+z05L8k6skf?=
 =?us-ascii?Q?S976Ef6y9XOxXRwFaYubUF1+DR0ydTWfIe2gLaU9KlQcBIsXZknJzbFhT80+?=
 =?us-ascii?Q?fy7cLXt6NtwOqLaPyNM8jqLkdHtYNQQlT8Ic2UcUJz4XK7jprvrP+BESRxD/?=
 =?us-ascii?Q?xpNiqAapy/MEm3Xxklvlt8wpR8qp0Gqnk4daO4C7zNEGPwUwcsHaVpDHGmJO?=
 =?us-ascii?Q?QoptfrjplVLZSTXUs129Z2J0Vocb8HkfCLeQG7HdJyEARAIA7G/s9kxAQORX?=
 =?us-ascii?Q?Inxz1E7ZQiaK/o+TBwehplhM+42xFFrA5+VI8pw3Qdm8m9B/Ln1I2CVNsdk4?=
 =?us-ascii?Q?fvG+k4QF6ViIF6DcByMBEnmxqHsAEDqHymfBdoi7I/dKKsA/RvFqnaeKn028?=
 =?us-ascii?Q?qFsY1BuXyZ49NkO68VRoui1etIAm/z5/yU8XBFLHKg7+lz/2rF+g0Z61zwU8?=
 =?us-ascii?Q?eEi03yt2us2dFtJeA24mvmD0dK0hHwI04jMsNIJpDs0BqqkFsl1XSYlK7k6D?=
 =?us-ascii?Q?Sz/eUXVRNWKfUgpNshAoWQTC2zt4/mhoFoa8ZE5vVcK8BEdUxHHlbGAbG+03?=
 =?us-ascii?Q?pA3juiZwSQ0zFFRA0UWvOUZVo3pJGMtETZWPM+wQEGMJvY0CWFKH7/HV9rd8?=
 =?us-ascii?Q?Z4h4wJ1GG0bxk7DLlcszPLt+AtubHImDijedwGwT3Z7ATs53PNm5MoX49PHK?=
X-MS-Exchange-AntiSpam-MessageData-1: NiSqVhuYkk38Bb+B39I7CXzLMTRtpzOCYB8=
X-Exchange-RoutingPolicyChecked:
	gxRBK5VkHLag+etEx7h1UO54mJvwkezwO5aKqwydJbIZ1kpYxg3Eja5RRz/DIkXFn8t+ixb1/frtk+Z3S84ZKpZq1trocd7PR1kRQ3BqL7/4kRN7nVX1S+bZ2s9mdlXhUU1HVhv+SgNFnSI3JP680dFCfwBzZwrPPjyNiTAcREQJngFTmNt8RSBLB/EZMIRaQ/YltdV0C47Ur7aoJgpnFQBtDIIYGtq15fZvkMqCj71JQqxAFKWQQXg6vT6h3SEzmOz7iy1VE1ZJURlIQqUSl6hZDPHbHy2rV1nbWX6t5p/01I4aHwP7qXnZuusr/fU6hg2ZaAZZdxoIbyArqd4ZpA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cywKm40sOr3XFZu5AsvnHeWG4XfN3tpuJQ46s/ZQ47sGCbYBuaKi9M5l2CXwl+hlwez9Tu3FUlecIilRbnf6OncQgtaPijwFxy/qCAFLbQ80cfuhiE5C5bv+wlUvwg1CqHNTcIUZy37Ef7t7jWLjbPxz0luAHDaeuVgyqPZ8nkdYp+QN/Ps9QXoDiYh0TDDdVleMfQx3YY4bIUhQyTqnxMKGGY5y973r3IiXyTakk62aR0Aqzkp96Ppz1j/zhxa899L8vVRwvcJSDlqNvU6BUxX+YRJpkNkuLv2nn59ldNslAlqc8AaO8hwtU6RQjgXkdJHbGN/eMo+6M3VKZ+TTGqGlXtSyRb5q/E378elM4C1TObW5vIOTb7bm5WLppY1t5SjkI1wjHotru+3M7gIbzC09kEAmDvnYL9F0Jx6+sND0gQ1ouztiJ1+lZD2Jq6MejqxIB64G5sF2KBfTYmrXs1wMilqY0UJyr1e6S10werjn5kD0Bs1g26+UMEzNzn4Q7DV+ZPNTCH5HmOvx+bjoHWt0x5qzReVi4ExhCBD7xFh+zPvD/WdK7pR54T0RmYNbYia0C+2YqYk2mUZcZnefHvHdL8SSoKzHb4KMuiKPQTY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6b7312-fa50-4979-32c9-08df290de21a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:39:31.7940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jobq0ZaX0zPdgiuQlAxqehspvrRJLsZux3+Qm2Qh+BsjRQFt/i246pKeuQiVitLcMqDTiFO6l3DWfCoU1mvH9TQmoQrpiJ3i93xFGxp6Wqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acdfc5b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=pCazNFhamJdtUKLgDfYA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX0JGieY/kJB6o
 xMt1hC3PTTauXTfO7IPZ0uE99M2TgZdtgewsIH1h6HrDQUFJgZ7mnxi2f/e99uYQ4HWFqbYGXmj
 vRtEiLTLpfbiC1MFP5ay04toCY4mtf0krlcZY7P2Ho3fcCcCofGV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX06PvG8sCS1Wt
 /goIEq8OG0HAZAgp8TX8AKYQ31K1HSsfdjcwuatpaCSTlFeqX6X+3LJRliBgFO3W8IKhBmNB3/r
 FQ+gfSKhFF7VkQSpBXMNefvsWmnv7VPEfNk+rTFT3UJkKkGyZ9u7nk8cQiQ3foERGDSCf6qHiNc
 hX4m+GccGqY3pWt447LAuo6nNo3v/06wnAgBG8Rv8Uj92KgWkcFBaWDRXZWE2/xH37Jh/aMBS7e
 7+2FCirRKpP1kxdtEgBvuVjdKEOIRqSGW/LY+TJRH0DxJHwQOY96EjsjF20LMUWCQ6/8HENt7Lm
 C160TzX0BfyqLBOXzzqPmZ9YVxkow/8/lECHyLIYWRZQCOiiDtuint68Ai2pGJRVI3+TBjrSqua
 Cp0jWLYDbwB2fwvdaTJScZPWuvK3OIlAOVbHYNWpw3uIBLeFNjikhxNWNNcElsX4X3f8ADJdnf5
 +TkpP4FhkoC3Ar8Njbg==
X-Proofpoint-GUID: QDvYRSgfOUVl8jn3xB2G1pzd-L3vQHbN
X-Proofpoint-ORIG-GUID: QDvYRSgfOUVl8jn3xB2G1pzd-L3vQHbN

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

6.6:

Fixed conflict due to the following missing commit:
	e45ea3645178 ("xfs: split the agf_roots and agf_levels arrays")

5.15:

Fixed conflict due to the following missing commits:
	6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
	[Continuous range: a95fee40e3d4^..08d3e84feeb8]
	08d3e84feeb8 ("xfs: pass perag to xfs_alloc_read_agf()")
	76b47e528e3a ("xfs: kill xfs_alloc_pagf_init()")
	99b13c7f0bd3 ("xfs: pass perag to xfs_ialloc_read_agi()")
	a95fee40e3d4 ("xfs: kill xfs_ialloc_pagi_init()")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 45 +++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_ialloc.c | 32 +++++++++++++++++++++++----
 2 files changed, 63 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 95157f5a5a6c..c4d1c7d436ef 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
@@ -3078,18 +3079,42 @@ xfs_alloc_read_agf(
 		if (allocbt_blks > 0)
 			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
 	}
+
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(mp)) {
-		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
-		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
-		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
-		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_CNTi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
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
+	if (!xfs_is_shutdown(mp)) {
+		bool	ok = true;
+
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
+		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
+		ok &= pag->pagf_longest == be32_to_cpu(agf->agf_longest);
+		ok &= pag->pagf_levels[XFS_BTNUM_BNOi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
+		ok &= pag->pagf_levels[XFS_BTNUM_CNTi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+
+		if (XFS_IS_CORRUPT(mp, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
+			xfs_trans_brelse(tp, *bpp);
+			*bpp = NULL;
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			return -EFSCORRUPTED;
+		}
 	}
-#endif
+#endif /* DEBUG */
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 31dc8e5d8725..9b14a6e4e48c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2619,12 +2620,35 @@ xfs_ialloc_read_agi(
 		pag->pagi_init = 1;
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
-		xfs_is_shutdown(mp));
+	if (!xfs_is_shutdown(mp)) {
+		bool	ok = true;
+
+		ok &= pag->pagi_freecount == be32_to_cpu(agi->agi_freecount);
+		ok &= pag->pagi_count == be32_to_cpu(agi->agi_count);
+
+		if (XFS_IS_CORRUPT(mp, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			xfs_trans_brelse(tp, *bpp);
+			*bpp = NULL;
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			return -EFSCORRUPTED;
+		}
+	}
+#endif /* DEBUG */
+
 	return 0;
 }
 
-- 
2.53.0

