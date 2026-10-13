Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E4C410D3D;
	Tue, 13 Oct 2026 09:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884335; cv=fail; b=mPbiUtRI396+L3U4RdPiMLzVqjNpxfMeQjwVE/I13xkiuE70bkhrtGwGkXgqaYUHZ4AoLdsczL/b2cVQUoJEPIize2ajk+Z1GIMoLcTVb4nIN/nRD8qI2cciGr060vx5sGu+FmLDltYufudkTmPvmpm/5PdB+jSIqB1HvSMLmLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884335; c=relaxed/simple;
	bh=dU3I1frWa6GdSKQZ2FLb/qnGYWs0epBH8+83LEIgbW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DWokCMUtSTlw3sPEfdvblXoB+sfJzStpo30luMCJWfJ2vghsWTIMtupRuOvkG6hHG9ChTsnRfzkvSmoLasLLYYJ8SJdD7SKKLD7R6x+tXUcCormO/ov3td52Ng5f8bmRXRnbHKLCQsRKyQ2yekuqBCwSYIY8n7JQ0eyP2Jrd1O8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jKvI/C/+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B/IHNCpa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jKvI/C/+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B/IHNCpa"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2urFZ4134675;
	Tue, 13 Oct 2026 09:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JpZVTqKMj3ulw2FM9NomKk4QUnLYr81GF2q/OvqnsS8=; b=
	jKvI/C/+Ehxx98WZnDtvwdswlkZASs6kE7p0gOnpfV/zwdgPncM3ZV5FJI+8TNHB
	9yVRZ9XetdfS3xh2Cj80nhsGQKdDJ5vROGVs3h1NguBkyHwmUTd16OLcew8NMnr8
	0QvSeW2EB+JDEnUfbTTuPF5f7eTJdLKEh9do6gtGBK69YpZZ108Po/UZrj6h7xlF
	FvR0hCESWMPb+NiKvWsVawLnDJ+JVhtp2ZEf8W1eqOwf0vBNqbJznC2FU3goB/N0
	Nt/2SFPF4Wy8VzWRL5N6wEpuwyKQLJrM/8uyve/tsJnSv2zYkrzOZ8Zhr9eZQ5cq
	VkeI//AeEWXj1WByTizmTg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkq6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9ajxN018245;
	Tue, 13 Oct 2026 09:38:49 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012047.outbound.protection.outlook.com [40.107.200.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp9tjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpLdVUyAaIzoSaEBbC1kS6tYzR9S9OSTnzqauMhsw9VrC7aJWXU4eHeSZrdXr2+UBrxz5BwiCn6un7ZP1J6oabLeSNIelp2/NlTrFW2kM+98a8OfjomI6HygVQn4OxjrZ9J5MeBKDjrL0oufshK7HfY9NZiytRKO5NyFXRRQG/VnF3USRCoP7HqBRLfl7HYimhYrVRO1IE6ggR5Zi7jXALUtqP+rBHEsaADcx0n3oX7anWaM8rr7gw6jHQE7BeToM56W6ois6AUSpEN1AV7RyZf3GUL2pN+m8SHjXthdD6qyM1YuiZcNknWfF0FZVNSncldci09URR/em4OPPIN4FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpZVTqKMj3ulw2FM9NomKk4QUnLYr81GF2q/OvqnsS8=;
 b=dWAs//Ffknh/1+EQHhixNm5474s8Nd5OuL2SS8pF493rSMO4My0f6nvyiNL2qEzazVUvMqv4fblWirKSMIutUGxZ+KBxlfFC7w8kdntPFGVI38Juq1HbpTMzGcA0p3/EVBRoKel2Dm8fcZcWoRSp95kw64Kx976VXx7A+/tgIr8/wMBbCLxesSgiI0CsmPNgzXku7SA1fqh0RKGzaCiwIdMO3+8hOW0k6mBxAu0yp7prPZpLzkS5h24kxwKxnv9dNCQ0U/jd3LgjRly+8Cdd74i27/5K1j58zn5NBj8n6F4Qo82XWEPI3Slunx2U75Vr1Jq7RdS7s0t+1vZ7+ZDUJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpZVTqKMj3ulw2FM9NomKk4QUnLYr81GF2q/OvqnsS8=;
 b=B/IHNCpa9IEcSbujypXnfA7nshYuAhD0dZ+chcxBbwshjFiAhdoju5BCl0kYOpRjM4v5wgqCquKWoghW+09zyEe0eEnA0f83g//O6eqGq8gSc+o7OQkkbGvwgH/c6nd7FxGiGKM9VMVF12HaqtEeoqDNpfmy62er0G/p8NO95wo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:38:45 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:45 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.1 v2 2/5] xfs: catch stale AGF/AGF metadata
Date: Tue, 13 Oct 2026 15:08:29 +0530
Message-ID: <3331ac43922dc7462b6ec7fc56d7b8d1b0caa12c.1791883290.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883290.git.siddh.raman.pant@oracle.com>
References: <cover.1791883290.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0016.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::20) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: c5a35504-502f-4bef-4bc4-08df290dc6bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|5023799004|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	A9i3hNNVLrxnxr7W+siMfWE6auPjFz4QgSgQ4I10cF1tuzfpQE8ecGkLMfrUohLqsYkM6++a3F8fnfJmFfbUlP8H6Zn5BYpxachArxC+mUvnSkYcszZ2B86C3858kGzZIsiLWY7gWmSeI/Sjpfq82ZqZdRLKOpZrplozhmy8/fC6Ftw8oa0ODMjvT3jXFKF6FEXpgb3yvbfzHM9/JcctCqieImG6QRtYw1XOi9RilnlPz/6o7Rt4Is2U7gDuEuvau41WwJ/2JPIJLLzc4a3BRX4HScv/fn9xSg/4yLHHIGAQtSq7wZpVS4hp8Q7PAKPYYrT6p9BOIT02nYcZArTO3Hrf8d5qA5EYT41736MmoW7MH80oviYyGUwSvQc7sJKuFfkf+Kb2mcPFPc3NMXeInsKdE8bEdd3jVaGKZMQwIOXglGJAiaNk2diQ2MIcMKlLd7hDqc9Rzbmh3cpvfYv7qE5R6DVY+jTgHGm72pHtHjqXzZDhkDtPK2JllHzO5XltznSs7sxLN8A4PYifqihv9Xvug2Tkk6UfjvbqVRSpLZ5bkQJOt0BRUnNiy/7mhDpuz2qVz45mtHJymC1+/B/6DY/5XFZjvUO8yeeoLMyAnh67tgRHvpmL/S8QDJ/0no0MHE1JUO8dCioxnqgmwMD8JEuwjG04a5dRda4uKNtHt6E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(5023799004)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3rkal5+0WuTv0GJhG1OQhoq8RWDUeFdjY49JztfDJXGuU4EoBpWQGAFC6SN0?=
 =?us-ascii?Q?VfY8QJRM8juTualvJoF8l2VtO0joUZXMVf9SICh4drdEEfasXBpAfL5MWXZb?=
 =?us-ascii?Q?5kWqE6pH65zssfqkrkOugLkY/gq08MkUl4yU22JIZL0dZTH008AXudVVWSB1?=
 =?us-ascii?Q?EqRWg51HfiSnumhjV3Nyi9Pb1rMP74j1QC7ZxiPd8sjtVMQVT6BC5OX9gczs?=
 =?us-ascii?Q?L3Mx58PuVVKjgJthAvkgWp6KS0QXNk432YNfXKVUo3Lm1UbbBBJPSKJsKQ+i?=
 =?us-ascii?Q?Mk8ciUPfrUGWFaA79BDEFEMgIo426GyO4Z/fymd4G7J4HU/ug/9Z3WmFTmWg?=
 =?us-ascii?Q?2gX+qkdLETLmTpsbzekplCus+8P6cHaIwFyHCQDq6aXL0MtjIVx//U+tzJra?=
 =?us-ascii?Q?5Mu0b1UbJo7mulml/oJeTfJdIZ1c05hbdASNdUse6dnNcI9GliSJP0s08iRM?=
 =?us-ascii?Q?1BQBoMdFmeUBFBDB/dRe90MMFq9fm0dp813vdZ55ZDsCWAIY4Iq5S+ExOkWe?=
 =?us-ascii?Q?/CtQwN4dLiCsgJxzZikjCFnvpz1UC6VVJ+STlvBFSJiRjujqHtPqEEpFMERB?=
 =?us-ascii?Q?f0M4JQOw+plEwbRNwNC4lGZARJ/hL2f+RE+xwcyajCheIyRR9iB2IYSGTsFZ?=
 =?us-ascii?Q?YkTpxOOCbL96mSameGVk02lD8F5eQPdRF5+UzMVcUn5IxMsvgJtEAovQrqHG?=
 =?us-ascii?Q?NZr/enfmzClMcEirllBIMGT+4ztYJi2e6oYD4SH+GCDz0w1fZqUs+otDhDFK?=
 =?us-ascii?Q?FzJSyE8CVyDCEYe6L3hS2NHjFOehF0OkfWvaCm7uP6B9dLyti65YX19+BYrg?=
 =?us-ascii?Q?LrriFIOrqklkc2YU2gv52wNN7s3AO4BwZM84fIt2x0Nnefk5zQ6qpGOgfKzo?=
 =?us-ascii?Q?I67od1pHehyD2azGT7DOpvE9C0j5PN0O1AgcaNhjsdTcXQvvkCrSpNbn18vE?=
 =?us-ascii?Q?GJ+ji8PdsgmY1ce4NxHklks6sW5MKFtE8CPH3EcbtmOS/TB/tmAeRCon4NM3?=
 =?us-ascii?Q?mJjF9P22Zta+AecrEHSOhwLBrdd44qX6rWuQ3xL10NhTLMWNIsrGt/tgawv1?=
 =?us-ascii?Q?ML8J0DbdPy5DvbaGwyaOwkg7nfyk9LjuJvWNFvFpEPN5sgxB3QqcPnULRPHf?=
 =?us-ascii?Q?tVlQZyYsV9Pg4j9gRRxEeg8IpmfssVw7384lxZ8IqPIjRbvDu61ajMGXIL/E?=
 =?us-ascii?Q?g4CRJ+a4oX7q6sc7Em+HzY75WdA0szmiu7wQpU+wmfhtJqGKEvWDX3Z9bYeS?=
 =?us-ascii?Q?hCYRwzHFMBAGh6X3QA+IWiUJAif2pAc60y5jn/lotm+/huyGJIhm/6Ja6N1X?=
 =?us-ascii?Q?He9rvIaA7KpkiX7TlreBaN9MtSqIBrR7rKt95jMJ0cb0IAStwONMSLDTz9a1?=
 =?us-ascii?Q?dmmiBAumZarIM4nXV/r6JNNSH/Tjvxux8XYkYcx+MrL83rGQ0Iuys4zvATW6?=
 =?us-ascii?Q?TOMbxwMfGso3rKu211QuH7J510kZeXTnUNfl6LJ/GPG56NxmHOTIQzcInviy?=
 =?us-ascii?Q?t4maoeAufMyWkWli4fiiN0QG8oQP3lzroXeAxo+2OoG4UFldywoY1u9cve5A?=
 =?us-ascii?Q?FItZWUt14e3BWscsaK9wPB2JKm6gcpEHb1QZjeeq7K//Msjt7EXyIoMyBmZV?=
 =?us-ascii?Q?iTa01mLPCTBizsd5rTe9dQsOEDxPw5hX/qGv9vb5I3u9708vTNmONw9wpP21?=
 =?us-ascii?Q?Zomx5Av63I7o+Lmvt53Ro+fk9W9NFxJw7gTdkfcOae9sANKxDBbtbgmdhmfn?=
 =?us-ascii?Q?iG+tbUrKIkXjRkmQRwVtNky0cz6+S4pVYhSeP4jhE0YkhhggnNbfi6fd9q7D?=
X-MS-Exchange-AntiSpam-MessageData-1: ZJSHh2lxbu3DKPAqt/862MuEwdXn02CIBuc=
X-Exchange-RoutingPolicyChecked:
	gFcWHMhcN3l35zsgbYKg+0VOPgm1tzGNyq66mK1BNMGqTiX4/u9cplZGsg9GKh2LxId2O5PCnUbqm2lnEiUMfWvQ3AJ1HfqUhnH+tAArwy3eH74TtMbuzIyLAmrmdh2XAuGlsmgewezYKvC1Jr8m7pNNONST1Vbmn2R9dyp8lUhhPblt6THnh8QZN7yorGsSFN2485FI0lmf+WfzBwHrtBdQM1Q4lUSLh2fs9qgLqgDuGN5BH3mzyj2aRHDtc97SaFhgs/oe+rAw9OGua9hGpQlwMl5zAUKwUW/nnTTyc6hwdMfA756TkyeLIFJdEyqtZsL+Kse2WWftS6QPOK4pqg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6Cd8AW5qWHXNvLcs2+dNTfhSFnH4TU6P4ei/4nC3+XqbwtDv93iNvYHybIW5n/aJNzVP2JfNpfT5gEDzOM2cByxTfdfNIRbaZ5pfjveqk7/xzYU9rD3YrSqD9TXBeG7Mu58f6Rvx2gKG5lOd2lelj7tbGbbJ5hCW5tniW2b06IeVnT/3aj2/0rXAM5umsTUjPXILXay14Nd4bc7e2Wq4KOIB+CkEjm9BbJuyqvjZcV9yd2fzH4xIOdUNv3O++Rk6oLsPZ1ubtHPGhtPllcDsDjy7y3Mb7jzU7jBJ15HmDTSRpTKeceIOmbxC6KkkKbx80C6SZuTJKEVxo2YMLMFhOiGWZWAqFNOejul/dv8RrGPJQxRT96pQL7Bii9BftlJhbJJ0duH2rHYbXjpvwv051awFZJ8yyeevGPUrW5d3M4IoP7Sk26HqRiiWfBZYD5Md32r/bENfjzHBEYA83t1ZNBmqt0MQXvddZCT5PfG+s8Nhec1lpTK8lEDJJAZPt10Dlu7RtSixrDE0Kv/XpJHJBopEZKeah1ErygAuDeqqPuDMKRqDj3yhoqqusSvVdxLmWKJbd1Px2jpg3jUY4Aos1dsdP/ZPpJugDEZtPSqP5b0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a35504-502f-4bef-4bc4-08df290dc6bb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:45.8392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9nnHByDoaLIEgdMoE7UYSbb9E3JJYz6JrdyeiK/4F2W0BECJxABqwuyzsVxO4BA1uvchaI33SNvZEutYeJw9L+4KBR8Vt+Bp99w++GeQ48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acdfc2a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=2l8DqRWQ2dbnbHYYE4MA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-GUID: 3awqsWN87gQaRSKC9T0ojwsil0qwjTJs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX7Bj9ps6rI5Rd
 4lKmr8Z0BMN6b5AyPAsgTUSpbcej0kE2Qp5iaSDUqX7eg0WY5jRSVGDZ0ER55Vf+isZFSViE5Jk
 LqudzDNmAH3aDcayq6YQN2rJTfpp/zhiUeFERMRmug/3sOxrT4glfxCNRGMauBWeiaZD8sox4k3
 U2hcoC/tnZmYndSKb0RxdQpD+3z+YFHpipHgMkCfhWDsjLmGQvcUv86n1Fr2+g+B5oZZ8rfRozZ
 ko9RDyExc74KHkhKDzsPzG2VgBq6nYrGewRi86gF0cvmYdM+iT+Eiyotf+OrmGI1kvJq9qD5cUi
 CgT9Bmu7ZJPRfU7bM7M0jJ22T4qD8NQX4IunWrtmYl33GIh7v2kvBvZBFTjF2nU9Uc9y9trOsXW
 24awZRc7gb9sUfL/fS9R9p8BcouEiFcfe6O3/Iedaw6jY+zPgTBZ6PXjfM1f4OxcmFcf4QfQitz
 ILqmA1rX4fssXConXLeX13vBnAkiXs7HeP+NI/xc=
X-Proofpoint-ORIG-GUID: 3awqsWN87gQaRSKC9T0ojwsil0qwjTJs
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX6WVhQWCi8Hiz
 e5PxLoNPbWLe47h/3u+emuWyyZ187KfdKymyRXKGVL1V3g7CoLQpr/4vrnnq6QWr971YIEyPgL/
 W+L2qcHRsk2q0tERIwNbV4h2+3Leh8TfcdTZQX7fyNiJ5NM9r1Li

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

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 46 +++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_ialloc.c | 32 ++++++++++++++++++++++----
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index cd5b197d7046..5bc37f984b00 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -3167,18 +3168,43 @@ xfs_alloc_read_agf(
 			atomic64_add(allocbt_blks,
 					&pag->pag_mount->m_allocbt_blks);
 	}
+
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(pag->pag_mount)) {
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
+	if (!xfs_is_shutdown(pag->pag_mount)) {
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
index 4b2894c85cea..1d3c07506c59 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2645,12 +2646,35 @@ xfs_ialloc_read_agi(
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

