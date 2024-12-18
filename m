Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C87481D1
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488062; cv=fail; b=H8l80fU8Bxrsd0eFi+9ZcKreWSpdmWO6Q1Q1z8b4iRv4ZQyWnjdq+8JBnPWbkgQlx+Ftgod3+6Kx9PHsKvWz8bPtO75MRvj05fgHQwsRTBFRFJSYu2X0b1rAyH508mMg2rczXrIY8RHXd/2SjFlwzxq4smhV8oAXCCVJlTRJoPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488062; c=relaxed/simple;
	bh=2cjpo2LfyFnzeF2sisky0KQD4T9j4g+Q4NqjWDu0Kp8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BnAmuD9uavs0JstiWn7GlhFEwBf9aCmN8/gUEMdRFckUZ43UhGWw55uZnpNbX1UtNoKLqbclw1Ex0C8vvM+egA05JA9DGxZ94r8r92kMUxQiV4DSElr+9y1six+942q39ClTbA75iNEvy8m19pu3TNmmt6V8UTXigCSLBMMUtdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cbjKhE6f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t+jOcpUW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cbjKhE6f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t+jOcpUW"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2Brhr001151
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=oE52qi+pp1DoN1z8xxel+gd64Oeq6v7M/oaGdGe5Yl8=; b=
	cbjKhE6fv92JKEWP0NEKfATd8iZdy7gWOEI3W8V8oqtejVi8+SnwFe8/2IsZyqIl
	ip2twWliKfh4xrGnqCQP2hs8lzr3ojbotoEnv0zMmMfq//HO6InqVI8fRai1bH96
	I/9ANfWhJQ+dU0VGDyJM4vneZWwepnUYoeHz+KSk0HDAhpTnxXlwHJer3FD1j25N
	FMdrJRKhMSj9FhV2noIsQYkXmQMW/y/BDeftAYOc9MXp9mu1wYyCNe7SA5btF4If
	nXgP2aZt0R3Eg55Cl/SXBInn99M+xOxeVccTDqGzmddIath5SqRV/nnqzvzlnk5v
	RteGdrNZJWqUclNXEc3Brw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0ec7fm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI1gVP5019266
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f9fbqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=loEWaPjRTPG8c6lRw+EDW2VSQpl9nUaPUbzcnTPwiBwSl3g5pOeu1RXfezNk4H0gqSLDdlU43qqjvCsaBm84xqizzP1+ykFIfLtvmjUj5e/ve6xeVtGrm/HqtMdQa2A7oF4a+uKo6Ez2ADrOp4mHXIQ1s4FW54UrWYnKN0yiUW9v3LR6tqYQ2CT/Ri1nArDU6V0BuPzsdZxDcdmkP9LYejzTL0netaXReb1TVEmpdF60F/tRk1H21V3KqAoWtu85KsKUojiNGPTEpZlAzex7iQRkeE6Izn3fmhYHhNPvskZ9jptxkYAbSmqam3tJgSP4KAT855DrCE8MM4JalVAIXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oE52qi+pp1DoN1z8xxel+gd64Oeq6v7M/oaGdGe5Yl8=;
 b=kkLGN+zUvb7lmdiF1LqChrEP0DwKYTA5WtPxpYNgM+E+ad459m/JEgF0JMP43gBaG2S7G8W8juu+1CM95QgeAafSejzWXAOkKIcq0P2kfKALi0TqnVUMaTjTL2E4eTuJdfUwRXRwGA8e/ij4cgLUgWqA54hTc7FRO2afj03nayaWsUXusogS9LoXjjEIn0QFfMKsizpl3YE82A9X/Tqd86E8TFwuaxy3IvUFf2/cKzm3/FuWTgw39Ahwx4h0jyYK+JmLO0USsvsgQDbEwft8KyujPHls4v9UX7ulBizF4tjdK1T9L1jobZUZDsQA/DcVSuVYOFvGgMLBLN7w/o9eSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oE52qi+pp1DoN1z8xxel+gd64Oeq6v7M/oaGdGe5Yl8=;
 b=t+jOcpUWzlpIynROT657gxPQcDBKwXglweLlIqPp/CV51OoGir7/7zSEFZ9WvRPyuX/YPhc9ARtItYFoabmjJHABDcJeuvKwk8ylXhcdsOeGZq2sJ2TTbjpUObikcdnCuYQvxPSOkchRhQ0k1ae3TVScYg0Wcq4zy4xlm4boq8A=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:14 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:14 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 01/18] xfs: fix the contact address for the sysfs ABI documentation
Date: Tue, 17 Dec 2024 18:13:54 -0800
Message-Id: <20241218021411.42144-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:a03:80::14) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 5988f939-0cdb-4d16-c2c5-08dd1f09ab3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7tmnC4Cu/izvsV2aTJ0olUZMxYHg8UIrieC1uLaTO4cGdtDdGEjEDlmZDWfc?=
 =?us-ascii?Q?g6AyLHuYS4shK396tgVZfC9Jy0qHm9EmSGhtGW5q5vnySvkKUvwfuvlDEtua?=
 =?us-ascii?Q?7PefuAttN1eJTlm1W6CvmuxTj8PI+eGComli1x/pfXzUCV2xHmoDR6KRN1TA?=
 =?us-ascii?Q?dii5SO2kvVvDEy+SjwqTJwi41sdN93cTTDwB3WXZ9x3pJV/fCva43IYvGAH4?=
 =?us-ascii?Q?J157DCqQ+lYstAddTBJCdI5a5ItjA0Q5o+WR0uzVZlmHkm44W40kbHr8XlKg?=
 =?us-ascii?Q?8WC4bfbpZxZ9IAmJJcAHq44Qm+9tpHGE/DeIb9XYvcy7j+IxG5/61ID/Ew+w?=
 =?us-ascii?Q?VPEEwQZCx558aEHDcNE/VMu4KkKXZ2AHnA5p6PX6Nt15iZbvAf0gOh52IKcG?=
 =?us-ascii?Q?N1aQfMu4yralS19Hq1p02A5Q/qS++/BkL5tOK/3SlJJtWC+qT9r8mwPhE0AB?=
 =?us-ascii?Q?wnZ/lwobt4UGf8H1La7TVbTU4rSmVfUtnGbb4o9hznDUP97KsrMEw/ne1BvK?=
 =?us-ascii?Q?w+qxII02/mhojgHRKGCPED06ZqU0P6rTshQfjcHkVtqvn8LpLG2xeRHEnNoZ?=
 =?us-ascii?Q?txagXOyS2QddxZbjEDGSVssdX4uiMJnpRyVT8Jk1yHEVaratrl03w5W0SErU?=
 =?us-ascii?Q?ySkphOp9+zumJClsufd6TudIk1FXH4Ht0iQMe+QJQ9nRMF2HrbWAD8LrppGR?=
 =?us-ascii?Q?lS4R0zzVVvBh0hNeRchOkmFqyXPV/YmrW5w/k3s3uoHqDkfWmGV0M0zYaXld?=
 =?us-ascii?Q?N8BS16gbz05xoG9juwD2SJ10iYUFM4lTo8KIggjGUZkmzpBr0O8eJbWeV+a9?=
 =?us-ascii?Q?qo7c3MmxjRY3D9vbmC9/oM4GRnYBeZceX65Wfbi8K4/jJp+MY2wXFbqjklXr?=
 =?us-ascii?Q?/4GiWctKLIV7O1ulR07ZAQKzWpUKxPVAheoZy1tgSsuxSrQ8FUg4K5S+7LNf?=
 =?us-ascii?Q?XTsUlF+bWJwM71UdnJvsaxbBizrvWCfEQ4dwjsgxeROnoUMM91LApk/Rxmb0?=
 =?us-ascii?Q?xBmb4qHlKfx2q1JaX1FEDHZf7WhkOCK/tJlx6DqzC62bphnoW/zqldfZdCrb?=
 =?us-ascii?Q?WxPDyplaBJm+bap6R40VU3fQzMotsJYmIMGWKs+DwhmmoNElwzzkfIYG/ASs?=
 =?us-ascii?Q?eijNtzLIA9D71It/RvTRZzDIxIa6EY1Ed32EBoUrDHum4LBDukk66TlSrKIe?=
 =?us-ascii?Q?KxPAfke7PoZoIbfn2LJEbExqLDRBt05dl1dcGxiKFedjxOCwjKcDE3WUudcq?=
 =?us-ascii?Q?k4eD7Ge+36fWFvFU3eQpEfI8uIuk2p6bcvWUntpnfSoZ2MIwQiVLxsEPc9uy?=
 =?us-ascii?Q?8nBlxafR4w6C4uOTuR0HnGeLHmsAnZFqv5LUtUvcdU9pl5GOIGl9M5G/eqIU?=
 =?us-ascii?Q?7ym58gd+xeE4rciwXn00qCm98UbI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QHG3UbZIWyYJFwa8wb8bWKKb7T1ti9yEfomFvLw87q5Al/ZEMhMaY4Uj6qPL?=
 =?us-ascii?Q?rUxieLhmCa2R5m8FFjjwA/EYHtbtxMXPsEIraKvmTnE7VPhmBivGvXzud/nI?=
 =?us-ascii?Q?t+SroN5Ba8SK/xJ2krgYiSqBzgrHGCc+/D9ggCOUZv/UbiXbWCidCZOZdKpA?=
 =?us-ascii?Q?EwwtdU8NmqZQ8wjaPHKtKKKDnC/ORubfA3cFDxShee+WgwqNIsctV7LhnjK6?=
 =?us-ascii?Q?dDjfGu9chzVjdDoNhmNTT2A2qvV9Nn93iq5Ny4b0v8aPL3WPEHvxdRXl4psS?=
 =?us-ascii?Q?bfvG/zGLqYL8bnGqEgm/kG7BmBWuYStL3LeyyV699E692kTDSE+U9D6dHrwz?=
 =?us-ascii?Q?rB/ivEpgbQxWlPeMRr3197+eszFWlBSrgbDwXTLEw7eT1jbRtbAOF+jIQTZS?=
 =?us-ascii?Q?ZlJqCiZ0Y6UblfzIrsIm15bI7ZzCBSpwcT5pXjuDuYZT6r704O6PKrX9pYRX?=
 =?us-ascii?Q?gT7Y+n1NgC77ORaiqk5jvoQAg79GXhxDnWO3R1gM4nZ6C87Id5Xg6b9mp4oH?=
 =?us-ascii?Q?64XOPomEDEjCEhiRQ8JpbIVL9xm015GP/E42fEp6AdTi7Tn3yFmQaJa7tPDP?=
 =?us-ascii?Q?+Ek+TQ44HPggWRz0TroyzetD/Kkwdse5Nx3J7BK/RNbVfQZG8MWtdLKCoeuj?=
 =?us-ascii?Q?ALnsxuWE3TJCdl+45FFqj6qi66VDgUTePTnFaZGTBqK8iAmBvNSoY+hlgyDJ?=
 =?us-ascii?Q?xsrqhyQ7oXug/5l2dKdLms4+Vz48UCk5WWK+U1vpakXA3EJpKMcjy2AuRHCg?=
 =?us-ascii?Q?QECdQuXBaY2MGycLW6mntpSWtudn7elkO16HzhsXPOMclQ1tAuHl72r4yNAj?=
 =?us-ascii?Q?3aHX3//LjMOG6EFNIUOCdaaBSJv/3/kMsR08Lux8lSrD0uMi+3YAsxq3HNZu?=
 =?us-ascii?Q?hv70OUrY7l2AyK5m9XFOMQAPbGa+xwyz7s6q+9GN3s43lmf+t4khVKMPZgAV?=
 =?us-ascii?Q?aH85dQSUT4ax7qCGOlv2wmkjAVJKjUxj/AoZ5u/Lh+suung4xSTH68gbXD6/?=
 =?us-ascii?Q?P9E+xoTZilHjS3h7p2JxtSSpoMcCAH8UJOJXqwJC/hGLR48xSJvI/pt5BUak?=
 =?us-ascii?Q?5Pn6Mk9+ZRDp37rMcIPrr00w00m55Z2XVJk1iplPIKMGn4oG4KAQChZlVoc5?=
 =?us-ascii?Q?aSPM4ITJcMKpVNTCFiEoZa9bssfhoFWrTr69EiWPxUUcIoZNmzYWO3ihPo9D?=
 =?us-ascii?Q?SwbOobCn/IkynwA8ZnAV56XlPylji+oqLHuMZHbBYkQRcTK5Ib/jAM/W5diA?=
 =?us-ascii?Q?HjJ/lr8M3wIWqSaR1pIn6EMFTCM183qcmNswCqBZKL3uFIkafoKBBLKkVIXW?=
 =?us-ascii?Q?no70FUN5mcFBAp3rzvvuEfzTCw7W2SyClsaKmNIB1+C6Bd+n69wdPfLTP1fy?=
 =?us-ascii?Q?kvWxxWJaj5OgCtG8B7L003FyOQaiLbR+ETZql7271r5yD7/D4CJXr8un02IP?=
 =?us-ascii?Q?65GGHvFeJpYgDIhvQ68sNdzgsptw3LTxociz5I+zLLZAXcFxfeWjRUh1OzGm?=
 =?us-ascii?Q?ZDoNyvd+LdWb7bKsJvfqfQW7sBRbxNgmS9Sbnc/2/Et+JXphKJjVsX3KjNbm?=
 =?us-ascii?Q?XrGc4Vy40FnTiolnQJ54eQWUPA4Ievsxddpq4wmnHzcYs+dRe3OaPjH/EnwU?=
 =?us-ascii?Q?8r0+OiTA0su5k7nsxK8NqmGG2xrvb7nM2zS4jmxHYx0MtJL96Ynz0w0lw/OP?=
 =?us-ascii?Q?iJ7tSQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hw+oSckBvN8LBntXMEjBvlEX6xZPjIu0/hsykh32xLalhnWU89CjxgIXF3Hg8hJZOcAYIAjrj+0LZLnepEi4Se1Z6drDOVQC3vAjJjUr3zziHkfEPT5W62pddNMHYB/aNXUVRBSSsycqn50NkCb6J6E8iCYRpjQwf7DkrkoSMCpV1BZZCrUkDnzCStzoLHWeLEYBd93+EquHPxwmCHgpIL/pYW+IQTX/8BGTpErD6GD+VPQ7fFXRjE/GsnyrfZXM9uNLkCZg9+pQAwbN2OLZsVM03UD83MCcrsyHU4d6kEp2a5xAZ6jMqHyl497hbKkzJcUCHWxW/oKmYAzdQZ/LcI0CAAXGgjSxFBlnhJbbb6SrjkW0vFlMPqLEWKRgL/qinLBrMChdlzmlmWnWqfNttizZMs71dhSxQLNmzZzFs60FkY7Pe2niLmt53pZgVxFNZ1+tuYJVqLe1/uMVczIyzrxqkzL0ovwo5KBiyB2i4Ma+TtFADPmHvZZof+w2DYwMqsKzO41Mf899tCx/cMHwNdG6U+/7nwVP7pzS1dQjyB64mxjjyHMECwLsAwnWwwQCoybjDcOm3cGOIbMWYMxIOSFVmvn6mCnYiM1gx7WIJ0M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5988f939-0cdb-4d16-c2c5-08dd1f09ab3d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:14.6347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lFuXkpGKmHlmPd8Fx7yM7KzihSbVtS49KYQlW8uBAwlJWL4LdayIY45IYS/yuOLachg88C8ZDCbXl/qgUgYpsYc09a/R9ZIVYvwYCv17BWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180015
X-Proofpoint-GUID: K8KL08tPWMSPxy1fEbLjpV--zQrkHY0n
X-Proofpoint-ORIG-GUID: K8KL08tPWMSPxy1fEbLjpV--zQrkHY0n

From: Christoph Hellwig <hch@lst.de>

commit 9ff4490e2ab364ec433f15668ef3f5edfb53feca upstream.

oss.sgi.com is long dead, refer to the current linux-xfs list instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 Documentation/ABI/testing/sysfs-fs-xfs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
index f704925f6fe9..82d8e2f79834 100644
--- a/Documentation/ABI/testing/sysfs-fs-xfs
+++ b/Documentation/ABI/testing/sysfs-fs-xfs
@@ -1,7 +1,7 @@
 What:		/sys/fs/xfs/<disk>/log/log_head_lsn
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The log sequence number (LSN) of the current head of the
 		log. The LSN is exported in "cycle:basic block" format.
@@ -10,7 +10,7 @@ Users:		xfstests
 What:		/sys/fs/xfs/<disk>/log/log_tail_lsn
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The log sequence number (LSN) of the current tail of the
 		log. The LSN is exported in "cycle:basic block" format.
@@ -18,7 +18,7 @@ Description:
 What:		/sys/fs/xfs/<disk>/log/reserve_grant_head
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The current state of the log reserve grant head. It
 		represents the total log reservation of all currently
@@ -29,7 +29,7 @@ Users:		xfstests
 What:		/sys/fs/xfs/<disk>/log/write_grant_head
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The current state of the log write grant head. It
 		represents the total log reservation of all currently
-- 
2.39.3

