Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859331D6DA0
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657128; cv=fail; b=VT/itXHd1uneYz/lsABssJhNUI+urbtTZrZDLTMWDjQFVssFyS/jkKXruIoJ0ReXN14CloFmwHfdWbEBgn6egcPM1EWU3Z1V8MpT8HHeVvDTgw4OpfgvFSKGUxHF1c9/lzL6DP0SF/2Fx3tq6YOpAolM5ldj1uW8os1rbp/R6WA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657128; c=relaxed/simple;
	bh=1OFV9iN5b+0ixNonCj5IHEOvOEoapRpl94u8VsJ4TEs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UVOoaDP8iufVG78B/zsKx3GU5vyFUjTkv6QxObVYF3HKIoiZ3AwmRC5e0GFh3b8uR4SbFGm3uGmCLnAvcAOTWTAWTztc9kUH0d7cxQhDBu9RHhhfUVDjUSHoj1tGw8x/RBhsJaZN30PS20653+rPTpISTdPjQP95dgAMwN3oJX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WZbfunK2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z6CTneAp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WZbfunK2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z6CTneAp"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXWhE027369
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=HcPmlUOKVP2YRDMye9Q8kLU7L6SZftb2eFQPkvprW7s=; b=
	WZbfunK2I4Ma+6Kv+P65Nu6jg8OnCDvUuB5YysXWSxSyc7FQ2OmOWwyjI24Y6J9R
	hjON7+qtBu+j+xHvsh0ywb3d92FuESnLOLIg0Huxl5GM5oWvK9sP6N47lzk+/qKr
	nlrcDeNz9Hvg2ThUhDozgTy91OCWWR9iqpGEwCT7/C6qC2Cl06rlapBAnurYlv2w
	Vtdv80EmL/IGVztx05vlIePN3o/TxAciArtL2t7s1zPbEXKGlnurlhP83zZFKzM1
	F9LQSGKYwK9hJEOVE+/Ca5rgzUPXY8GyDm7iEawwYedq/N1/unQ12eS+6bJ2ePht
	65Jz9Gbu5ssNUhWMQDCOdw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwqjhc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486JZTM7006782
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:04 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhydej34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=upRqmh3M/EM5XZdQ2ivi/5xaohK5NqG+ZT9XFuH+U9r0d82rfjz6F1UjiuHuIq6KibH0gRm6Cr0EyT8oCT6CC2qUb//U20pMHMKQQ6ZXyY8Mj6O03Z67SSoFXP6BeBfcKCqGh5/UjLn1+UY8szjQLaqBJ92v5n9w3O8HKGNYhDe4xQfPvqruUtBE7LQ3ZHuvvEo//CCZn36nQP00WU/F3c2FHIYiOlPwhYJRlq5W6cK7Scuepcg62JFXrcc8jeqZ72bs1GIW9tE3M8RG6l7i7ielBVZHJr/W7nFCQ3vv2xrSlKJPMJC1WBfF8qrinhNi3TbVQtY0Yn3wcd3EHaMYWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HcPmlUOKVP2YRDMye9Q8kLU7L6SZftb2eFQPkvprW7s=;
 b=B5lqY8OfPFCpX2kgRMutMbLNIOj4mrXxdYa2j2x6VMZ6az6FYBVA0TgUEu+xB9PywVKkrh6lI2FCeomzA/CEd3qwyyyOLkgrZRKJq5HWwFoVEhIwbAhDfOwO9hqzMeTLlArwcZqaiVGYihcCgk+UdzTHgHBLh3kE4Amdw8PA8QcLWQOTh8qegwqnUcnWO8/KSz6PEUrBgcMeef/T7LaFwrjp5EnyPbzpiM8/RN4ka27j8ZDn/wFNmrtohb30zrLvS9jDj+sOHd5Bh6VrzwXilwaCCEiy6FwDIJvzVHUC0ru4IT1k/OYN/wnZVZAmqtccJSr2XRpjm648z/2ctNGfJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcPmlUOKVP2YRDMye9Q8kLU7L6SZftb2eFQPkvprW7s=;
 b=Z6CTneApRsoQkUN8UwkPOUe8mdm9yjRFcctgSpfQEDGg0sMUE+mbK+LjLxoGhEeBMzWSuQzzyk4PSHxfRmhUDVJicJ6BH0vCTG8SAlQ8caG+FNRALGiDG9TkR76N6LZt+Iq5ah5zn2Xg+Rn+1fsp+cyZeLCwPCY4x+OTrGZUkaI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:01 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:01 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 10/22] xfs: enforce one namespace per attribute
Date: Fri,  6 Sep 2024 14:11:24 -0700
Message-Id: <20240906211136.70391-11-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0119.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: cd23e5ba-e7f0-4487-a87b-08dcceb88d0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T5+Cn6l9OTsVU1aXQUemap7MwTMDr9G91U6nLH/eFXLypkXF/9RgPc42HoPV?=
 =?us-ascii?Q?Bsj5MwAoLfbsFblr3i6qpz7Es64HbxYS7U/zK+m/jvF2y1WozkKpCM0T9JPB?=
 =?us-ascii?Q?ZuLRq08sQku7C88CLOldqA5Exj8/KhNAIx+B6Qns2utoBlG1hAsrkHq0YLx/?=
 =?us-ascii?Q?df/zrzT4+lnc5Lk5J3zq2sWmtAajem75gC/IiD7KNqoAR6FAxD6uwdj65VeN?=
 =?us-ascii?Q?o/XkajVaJYF0ylvt09SqmcdLlkv6wK+U54wMCgDtwdI90K7aC61SCQ3mKSH4?=
 =?us-ascii?Q?ZL/k7DMoui2jKfvlDruJqzPZhljWnRFY4XialPv95+a/BWR5WNgLakTQu3zO?=
 =?us-ascii?Q?xVtz/cqO1jrAHpFzIt/qWZAXrILvG+v8EtCnRdeEZLZEY+htCCAooNxbb8U/?=
 =?us-ascii?Q?e5pXaJ1BiBTMWPYnatECSYNzKePFTyZxN8raGY983BVYbZohVkLUN7D6nTiV?=
 =?us-ascii?Q?/SrbaMcOcZRTgdvl6c8bqk1qQ1blybxO2BBJwZo7IbD2djCR3omFzlI9HlNk?=
 =?us-ascii?Q?e9ckQKtQkdz4X9R0nHvnDmOb3Td+UQS4wxwm2kodBzwfpXctG+JWkUGRrhpL?=
 =?us-ascii?Q?xEu+VSboApOLBrzfGTJYPwbccalLjh5orGzPorXvKqV3k62ZhiIbxR8yYFip?=
 =?us-ascii?Q?Dhevz7DYm/HlCvY6q8bwUnc1tTwpJ9cUUhZDuGBaze9siaGSDhQAxuVHq7lw?=
 =?us-ascii?Q?dRoj1oUBt/TXueEJ/NHb+tDRLkAmEzV2z1e+vyh9/4velN9XAkRDRo/DhPru?=
 =?us-ascii?Q?/iNh9d9oahv2O250yqO+eMKtu0vL0+PwwUPOATIHkXSPJWIWRntARsIUTFBu?=
 =?us-ascii?Q?5woyf1Zq8syHXW5+zSeiOL1Ms0pOnMWRZzZz2B5kkNkUF+t1uBBYcefZCcwN?=
 =?us-ascii?Q?/tsPuQipCrGpwgW73G/e08SdFZTFE/ydPBYhk6KDgznWPC/asM04w0o4MdbJ?=
 =?us-ascii?Q?Lwhz2ZL0ytzmmljA4tErlzg2F2oQnUsMw1VYAv9U/qZhEqTsJPl1jacNkLf6?=
 =?us-ascii?Q?3mrEZ4moYUKHxBpc6mS6MWxbXwCztJteoIEKDFNdzZ53AiVuKIwfsukjfE3o?=
 =?us-ascii?Q?EI/uaCh9VBmn0NoEFbRPR4NRPwFj1I+MN41Uio8LKn2uGUWGq/0Nas0X2clG?=
 =?us-ascii?Q?JYnHV/i0oi6AP6Ei0D8BiA2/7LjAECjQQ1XQPmYKwh29r4awNLOARnnJ6zX+?=
 =?us-ascii?Q?7HimLeFS6CrfBuO9Hv9h5HplsvcuqjpYK5SmoxjvL49Dr6hY98URDG4jERMd?=
 =?us-ascii?Q?4vi1BC2YM5EUa6KEcbOZxdnHY8wYs2h2QzN2F8xuqtEXkq603HXeIbMNazmF?=
 =?us-ascii?Q?HDWDR3RjHn4G6K55QzklSmsyBZ2SYhmki5HUxM75WBnVBg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fuKZCn8R4prxjs4fUgtq8VUt7VzCB0aegyGfbMQMBtVelmB7B4ddX0GuHSxj?=
 =?us-ascii?Q?PELrYNTNBCaQxK5+IbffFX6QrJCE4XrXRFDInEDcAa1i+Suu7Rok3fA+F+86?=
 =?us-ascii?Q?yDC3v+gw89zA4603s9v8W0C9o99aWm2j7tI4B8vyB4Cz0XficDv5FP1D4T4E?=
 =?us-ascii?Q?qKCekhKvUa7D5D/EtsKWS+rLrwrW9wyXaCwDhw4TOg7eMEplhARVSBL9bwa7?=
 =?us-ascii?Q?RfGUnV59enLI+FrZBtD6y54abN88wM4wwkHfziMsskojOJeFn8+lslqnc7co?=
 =?us-ascii?Q?cS2+dNXBbcLwxqsRwc5zCvCtUPkJL1S0Rlr+ERzNW8B6COZEAdkkZ8DqB19H?=
 =?us-ascii?Q?gQwp8uIW+j4PyudckOoiQIf57bL73PO4xPy5dUaU+RP1qplE7jimcGlVYe/E?=
 =?us-ascii?Q?RVJk+eIhmMF1XVWh8DlHs1Ifgdeb6wJAM4+AwMHUc282odib18svF+JyYGMk?=
 =?us-ascii?Q?nAx2TtwZYOkef1fXUPgfqpSR1GopSHiX9oW97pwXc3kIffgEwojpkGHmLf4q?=
 =?us-ascii?Q?BMr3iRkC4VYH/ywctiUUa03G3J1XtE2ySoX7N4hwRfILPrtV46ITA7ixZB5I?=
 =?us-ascii?Q?A8cNm0ZvsckmVNVNDoNzm1pYe+KZceEbppk/tEIwslnSQDLn9p730usXcc2p?=
 =?us-ascii?Q?/1ymhK1SWEkjdyLvT92mLRwM+Ckjynbsa80JPY6ZDREZkXxxTuNhjNkcJ9f4?=
 =?us-ascii?Q?1rB471UpQa8O/Ip4ghSfKusuh3/bJ6gQAyt1q144PCulXPFGn7pA8f2NjJyK?=
 =?us-ascii?Q?Nx6WQLGyZ+zbJsYO8jiAc155lfmlrSlGTj1JSqBB9ms8A2UZCOvhawP5NTQN?=
 =?us-ascii?Q?hgSq3F+3Op3px341jz96lSxFXLIYtSBWs4aBsYnz7n9Gj4QX47bP4tjH2TSx?=
 =?us-ascii?Q?UeazkTfNNC3V1R90oXE52v4w6aEPYayS2oTcFTgTzuOGETXnbrssaN4hktJf?=
 =?us-ascii?Q?rwDcCuhSorU5G3NBKw+/9wzavN6cpZQIY89GMOVhazDy3sfnIaD4f1xqcSNk?=
 =?us-ascii?Q?urp1wcDR8V/hXlIjnGRr+w+dw7uyfJ96671UX3Ne5PbSr1nMyDcoP1UYmENn?=
 =?us-ascii?Q?IHZ1baytMXL/fbS3WI1k5OX86ZzbStVyGAJFDwKFFQeMkRRCkSPwCdP0avzZ?=
 =?us-ascii?Q?fgTbs+NgOMOJDiOtsc8drnkiuMAfbsmMv+RZ6IQIo39EcaAM/5bRwThE8HKG?=
 =?us-ascii?Q?yaQit5xkz/k5zkpJEInscar1rs/NHtbmiDYwYauix3ykZgL4lw5tRN8Dc2Wc?=
 =?us-ascii?Q?CZX7jrfSNXf65XmrJngySbe6ckAyOh/zeXuNxJqHvUBGl/Jb8nFCp5ltErgT?=
 =?us-ascii?Q?YHqNOCDyfgiysLxY/qoSnOnJXjO/JXH9lspQ10NeS7HTQjKALx8O4ossNXP7?=
 =?us-ascii?Q?GBywsNtZzEzB1HorDtPfnf0aQ9RlXKLlV2PHuwKLLtKI4+e1J86lB4polRMt?=
 =?us-ascii?Q?BPXXn6jwKae35QNx0dhSFfOS5oxcgmbpYEf9M9CNCl2+os5qcOr3yolOXh2h?=
 =?us-ascii?Q?/rmb21mZC74CZA2jviMKkEs0jB/inse6iTOQecULabmoNlbXkE6jxQThWEdy?=
 =?us-ascii?Q?r0eriKZCgk965bSrNav15RYwzUIIz5qZ+WWrZgwdIEb/DXa9L/y3UA0iJKx0?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k0Q0inqhp0rcnnAvlYYg/XwV1O0B54I2UC5OWtfci2/JIlWwqZpKkRZmSNxZ6CqgNbBeXVDJpBbZ9/WupzLA3L7O4lq+CnIUkcZCNsRHAbbBGSAnDDmQ2OXNVvQQfsDwgZsRDTz0l+ljTAEBE0NPWj1eyC2t9/UfTqhS5jJDkBHmoTnJJM3O8J/A8bm7A+DVWAS1S9Kb0ePDkeHZjXolMS1HKd5f9QxBHBeeGTEb2eez8XcOhsjuq28cAt9imOKfAqp2MaTkB6c9Rm/Bc1LRy8NgTToWLntvgkjhkfzBpawAeKgKbWGFwzL230AUmne6TQiRUjx8Qvv1JUoZgyoDXP97RRCBhayvsAiG36F1EgkI8MJTGssyKMT+vi/N6q7geI7962ZHcdxOyvIwjG6wBH9PNBtKGv3k/1ZwkgjeLnDSVDMhCEk0OjCLUyf6pO0kAuFkL7CJvea47hrepvUuCUke/EIbwVYGKZVkusLrgHmjP6YZdZwLlxh4Ns9wB9hMPP/3c+g9n9Fj6glniALBPc0WSvRYR7PBPXriEfAbhi0rEEat+h1zEr6jQWuxi00N1TNyVNUtySeoCMDvWQyuS6wI5jloUL9r1iviQc4I+yE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd23e5ba-e7f0-4487-a87b-08dcceb88d0e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:01.6993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +vCGbvepOf3e2XHMxilCvmEAvFNhJlzpephs98pWVq55GEI4gL/GWEMUDXIy+8tvPGkHQMQBaboMYamT6NH/8O3iBzrwxAK3c1kuZWkeM1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060157
X-Proofpoint-ORIG-GUID: AnGxYkisi85ly-snAy9l0paJIn4NPIWy
X-Proofpoint-GUID: AnGxYkisi85ly-snAy9l0paJIn4NPIWy

From: "Darrick J. Wong" <djwong@kernel.org>

commit ea0b3e814741fb64e7785b564ea619578058e0b0 upstream.

[backport: fix conflicts due to various xattr refactoring]

Create a standardized helper function to enforce one namespace bit per
extended attribute, and refactor all the open-coded hweight logic.  This
function is not a static inline to avoid porting hassles in userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 11 +++++++++++
 fs/xfs/libxfs/xfs_attr.h      |  4 +++-
 fs/xfs/libxfs/xfs_attr_leaf.c |  6 +++++-
 fs/xfs/scrub/attr.c           | 12 +++++-------
 fs/xfs/xfs_attr_item.c        | 10 ++++++++--
 fs/xfs/xfs_attr_list.c        | 11 +++++++----
 6 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 32d350e97e0f..33edf047e0ad 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1565,12 +1565,23 @@ xfs_attr_node_get(
 	return error;
 }
 
+/* Enforce that there is at most one namespace bit per attr. */
+inline bool xfs_attr_check_namespace(unsigned int attr_flags)
+{
+	return hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) < 2;
+}
+
 /* Returns true if the attribute entry name is valid. */
 bool
 xfs_attr_namecheck(
+	unsigned int	attr_flags,
 	const void	*name,
 	size_t		length)
 {
+	/* Only one namespace bit allowed. */
+	if (!xfs_attr_check_namespace(attr_flags))
+		return false;
+
 	/*
 	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
 	 * out, so use >= for the length check.
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..c877f05e3cd1 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -547,7 +547,9 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_check_namespace(unsigned int attr_flags);
+bool xfs_attr_namecheck(unsigned int attr_flags, const void *name,
+		size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2580ae47209a..51ff44068675 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -984,6 +984,10 @@ xfs_attr_shortform_to_leaf(
 		nargs.hashval = xfs_da_hashname(sfe->nameval,
 						sfe->namelen);
 		nargs.attr_filter = sfe->flags & XFS_ATTR_NSP_ONDISK_MASK;
+		if (!xfs_attr_check_namespace(sfe->flags)) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
 		error = xfs_attr3_leaf_add(bp, &nargs);
@@ -1105,7 +1109,7 @@ xfs_attr_shortform_verify(
 		 * one namespace flag per xattr, so we can just count the
 		 * bits (i.e. hweight) here.
 		 */
-		if (hweight8(sfep->flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
+		if (!xfs_attr_check_namespace(sfep->flags))
 			return __this_address;
 
 		sfep = next_sfep;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 419968d5f5cb..7cb0af5e34b1 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -193,14 +193,8 @@ xchk_xattr_listent(
 		return;
 	}
 
-	/* Only one namespace bit allowed. */
-	if (hweight32(flags & XFS_ATTR_NSP_ONDISK_MASK) > 1) {
-		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
-		goto fail_xref;
-	}
-
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(flags, name, namelen)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		goto fail_xref;
 	}
@@ -501,6 +495,10 @@ xchk_xattr_rec(
 		xchk_da_set_corrupt(ds, level);
 		return 0;
 	}
+	if (!xfs_attr_check_namespace(ent->flags)) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
 
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = (struct xfs_attr_leaf_name_local *)
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 141631b0d64c..df86c9c09720 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -522,6 +522,10 @@ xfs_attri_validate(
 	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
 		return false;
 
+	if (!xfs_attr_check_namespace(attrp->alfi_attr_filter &
+				      XFS_ATTR_NSP_ONDISK_MASK))
+		return false;
+
 	/* alfi_op_flags should be either a set or remove */
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
@@ -572,7 +576,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(attrp->alfi_attr_filter, nv->name.i_addr,
+				nv->name.i_len))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -772,7 +777,8 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(attri_formatp->alfi_attr_filter, attr_name,
+				attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e44..9ee1d7d2ba76 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -82,7 +82,8 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
+					   !xfs_attr_namecheck(sfe->flags,
+							       sfe->nameval,
 							       sfe->namelen)))
 				return -EFSCORRUPTED;
 			context->put_listent(context,
@@ -120,7 +121,8 @@ xfs_attr_shortform_list(
 	for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 		if (unlikely(
 		    ((char *)sfe < (char *)sf) ||
-		    ((char *)sfe >= ((char *)sf + dp->i_af.if_bytes)))) {
+		    ((char *)sfe >= ((char *)sf + dp->i_af.if_bytes)) ||
+		    !xfs_attr_check_namespace(sfe->flags))) {
 			XFS_CORRUPTION_ERROR("xfs_attr_shortform_list",
 					     XFS_ERRLEVEL_LOW,
 					     context->dp->i_mount, sfe,
@@ -174,7 +176,7 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
+				   !xfs_attr_namecheck(sbp->flags, sbp->name,
 						       sbp->namelen))) {
 			error = -EFSCORRUPTED;
 			goto out;
@@ -465,7 +467,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(entry->flags, name,
+						       namelen)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-- 
2.39.3

