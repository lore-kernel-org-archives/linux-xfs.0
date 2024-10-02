Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4361D174C
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890900; cv=fail; b=Cqqbo6o0UVds2sDhiQA6PGSG682+Gqd9KrPvvesaJGtVfWLJaV+zYsHBcVocAarQK+llq54Bl1DM+to27wu1FVqDWnWi395CHEWLJshP5dGiSREkcnYY+zthR7ARYIAqFV7jhiiQjozx/bXJ3zTcBHZROLSA9VTAOiFf8q1q/WE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890900; c=relaxed/simple;
	bh=/yFhShMsiZQVVKJmf10L3KPPS3o67lLMjGLP603145g=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B4YxugGBIRzKg4btvLZXTRuqL/Xrhcp6uG4TByrhCMoj2nUyQ0dfVdsvvn6P24zMtoahcmrNN2nGBLzT8mM+/Lp6skNnsffyDFP4VRRwObuWjjXttxqA/ez6Ml2owxYg8bDwjPomo7VvjUWj/k7LjgQxm1Na89W6tks8lXM2dho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cbwq3fto; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GZNQ9J0c; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cbwq3fto";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GZNQ9J0c"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfcNW025762
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=uDBlipRV5kDf3e1tqFszGfF5GDRdZRdYIlu1u2QeQA8=; b=
	Cbwq3ftoFcCi3cp91k1Tl/rUhyADoC+09DKBOwlktuTbKLqB28fQuo935XvWMxZn
	lzKWFXzT7EU7vlipDgGv4L+MRBpBLj2tAIzFeewoFVCKp0AvIxM9cZ8KZU+5EFSw
	ZAilLgHnZyOoYbSpwbVAMF8H2SPWM7ZuK4kZCbdIjTRGeRZtcqXLK9AXufiKAdUg
	r9ntY8PlZDs6ck6ZhHs2X59dMgCDu0KQgSO0iU+Ag6s8jVRKsvN7SaOnyQQhhNuT
	QNSOyHWtEK/T98CvrIV8VEFP9TVTd/awoMK+R0uedk+UqqYKE6OQgKqCMv/+KQ6+
	KO2VnE9+5lNEs3SCrunUVA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8qba841-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492HFebk038677
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:24 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x8897808-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WHXslsyp8xcYBQbOnyoS4taFiSUezZ1C+s+auBdJ+wIDxSxfgn9io6jDop+uSRZpOA1q3gwSAektL0OtDLZzobrw+UTV07KntnIe13OrPspSzKzpra0kWPfC6l2Gf33PUMTrauGOP5zbt6gHFHhPTlWi+nKJw4knkWyjz0Y7gOVlcky3QU6VYnzWTIEsLuyd/RJ5CaAg2VHUWhwFjevWvCWimYIsN3vRvkh5WHPxCJEJqa8SJy9o6W9AOuaMwtahvcddNhAfahy1+OeA+tverYjkrBxPKrFMePu2Glf67Hpq9wA5z98nS4OZl4LWsTNl+JwniHj40myKKzTSQIJRAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDBlipRV5kDf3e1tqFszGfF5GDRdZRdYIlu1u2QeQA8=;
 b=Z6Ncwsv4dPc3evZUjKes0A66egSmvuSKmB2bN38pPOeuCllXHlI/gveQddTwflQizYaUHzcojrgW8WRqFzL3fJcCm9obAHyZE6jOX0FXAxRBQmLC+lA5haYD4lpjgI6rsviDaWgTOzl3/Wa8bDF8rTLZgL73Cs4lPrxzH11OJJ5IYKe7IYm7qw3zM0inj3ZuAnfQG1SykV0c9wrxYofzdKuLm9SLNEA6lOkV091AVg8kUzpxTj1cVucn18iXAiXIJ10AX2b+paYUZQQMsolRfU1E1Dt8k7VHcnMTFPSlTDZZvv0afpPgqtTYsG8W8r4mCGOoO7vDihdBjBoqTNlzug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDBlipRV5kDf3e1tqFszGfF5GDRdZRdYIlu1u2QeQA8=;
 b=GZNQ9J0cc5+oqdpclS+xzXPAGjFbqKP7CJanOp05D24QyNXSCmv37EUyH3DYx3lnIFFTTXMgw/n+16Chm0GKbyLkswzNWMeKPITNmCShpCuW00sj+ktqdDhqXBLm5Vo9ESyJrQmeCr5tBpuoIZiZ26V/QSNr8BRupSbSTy9Xj/0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY5PR10MB6047.namprd10.prod.outlook.com (2603:10b6:930:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.15; Wed, 2 Oct
 2024 17:41:22 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:22 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 05/21] xfs: check opcode and iovec count match in xlog_recover_attri_commit_pass2
Date: Wed,  2 Oct 2024 10:40:52 -0700
Message-Id: <20241002174108.64615-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0006.namprd08.prod.outlook.com
 (2603:10b6:a03:100::19) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CY5PR10MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 5525ea68-b34e-4e4b-827e-08dce3096e06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HXmbkPGrGe7bO1YYmVo4MUqj5LV42aakv7TL7O+e97aMmtFjoUYHp2rnG8Ok?=
 =?us-ascii?Q?Zy7msAVv9edXWlQtJiueKV4YEVOAhc0RWWQApNYCAuJpIJu51I29gT80VGaV?=
 =?us-ascii?Q?99zlM4xFAHUUEnMIcWf78Oh/x6dtHJtzYYiM8hlG2whxi/tIuo+bMvNOmMUx?=
 =?us-ascii?Q?rjDqxC1PKCCEV/ILNiqLQJIjgvqOsZ85ywst3iTDrJegBhH/62CgNY4+BNPp?=
 =?us-ascii?Q?5XSPGgYisAfjntEf1ICnoYflkAUewCLScnVwruAzSVCQh8MPLMTeiPL8b5Dh?=
 =?us-ascii?Q?F4DRgzViEHbkD1YABYg2D6BpmduxwNBFVpZj2/UYfNoSgi4owrLiWL0ZDgw2?=
 =?us-ascii?Q?Sr7RJB28lN8jb1itpATs0p5LiKtxzHQozeYeeDeb4wOPkVx9ZLYn1yye598h?=
 =?us-ascii?Q?zB/Geh18VZsgrBvAzpmy/g5bD2ttJppFce3QgwlcGtRSisMZub+Djx1eLUsE?=
 =?us-ascii?Q?QxsJygL+/liOBZ/Pe/qv5I6+BmUM46o7STBz76quWm1Kf72vPwyLSfbtgKTX?=
 =?us-ascii?Q?r99ay9rp4KEWQZttXvK2n+S0uIWSs8hBYKjEU163Il9ptaoIoN2aBmr2O18L?=
 =?us-ascii?Q?xrdfXcxGsGA91wLH6FX8HftMtvuHMdk/eeQsvCLkqePt4AumzycLSc660rVd?=
 =?us-ascii?Q?ocqLtsErV5TKDJONwqt7q2pRRhNbT566+JikgG3x+84RdjJCcDU8ESkn7iSJ?=
 =?us-ascii?Q?9r4adbCtvOgdUkg2s1sRmsQ9pwp5DZgGysDUS/p2/OfsnpZUEQ5OfyDQ/hzU?=
 =?us-ascii?Q?5ksJLD0h+ZkhVi7EVdWvWY9g+SQZKflsiHBUxs3LN3voezNuVurLnxHdtx9T?=
 =?us-ascii?Q?z/4cATFHmkxB+F45atve555v5eqjLPbuKHOBB7nFwGrP7x4XkRVArZ4ff5hb?=
 =?us-ascii?Q?yboTuBTMY/7LECMf/luEijSx+T3iOfsuwNIq2U1dghkynsRKHW6kmMAGTi6J?=
 =?us-ascii?Q?/eY83kyEEv7lInLtMc2lsoqHcvqqYuGD76wFqHeLcYvPH9e3EC0DtgP7VoEy?=
 =?us-ascii?Q?QkaNlSyRELy2xQ27EXUDbHCZRCQCz04Lux9hviUXAm/vnhCw/kW4HR1QhnCF?=
 =?us-ascii?Q?9b2lzlHPsfPSQSjoQQjgm912ZpuwilcMvXZ4w2d3wk+1nvKBxJ7gf2YfLn9V?=
 =?us-ascii?Q?EdD3bm+NrFv1FMGIvEe8/3ncQVZuU/CTiXufs+Rw5V2l2II74QjagDYstlZv?=
 =?us-ascii?Q?VZse4XkT15upxZuJRTwS3aC3jnZpDdKQR+thVHPTzNlm0KuIE9YZiv1JKAxj?=
 =?us-ascii?Q?kL2YCOpy7JOnFM4iSnw60GxlIz07btTd4lZ5GWIxuw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mLK6+MA7pOSuw8RJNNykl/tS/86JpzKP49CQH9goWslgd9EX5ygd0ZQTGP+n?=
 =?us-ascii?Q?S7ZzjTP9Sz5sDFnEw+JQ+sjbCI5ldyouBLhY70VHD3cT26PRjERUUkMFvEK8?=
 =?us-ascii?Q?4RjCZyhrFVm1R32JUqyLg3AYVGSHw7nWV1t/Pi8SwgNPrIiBENKmuowmsvh/?=
 =?us-ascii?Q?+V7iTNOXye+5pn7slmNBRm50Aoc5qxjQgchVp2mWjyqb1UFyoGfs4XDcl2yZ?=
 =?us-ascii?Q?J238v1POJ+cSsrIqUZBjIExvd8qlB/DX6ixGuLA0VBm1+PpmBs1d1ArymaOt?=
 =?us-ascii?Q?eQ9WugzVOo9LxyoFr1V+9MuW5VriRJNC15xgnrzrDdxUydzfzAHpEJH9veTN?=
 =?us-ascii?Q?nDtkaO1tkl+7BrLw3p5HGfPnIBObD9qilNfMWexAglD8qhNfnMr4bWhlqzuK?=
 =?us-ascii?Q?DoXQnz3O5MBUA9EaBs2B8Yqz2pRkpwE5jn8pnmqChA3DeERk5nWmftvMaOKj?=
 =?us-ascii?Q?dPLtYRAayPTCIxmbXgTkHlIDD3DLLnac2R1CBiZH8bj03hGxS4awAIODmGXG?=
 =?us-ascii?Q?LrPcTUBbazacfsSxso49QPGWopCkBzi3EQmS7QLOp8GX+xEFPs0y7/KxvJxA?=
 =?us-ascii?Q?4Nc1vi+ZEDbzDB6G74D2q2EnIBT4JRrNgkSFp8LO9x94H2NCVg9yMVMxF2ka?=
 =?us-ascii?Q?FHNc1pyVkel/UqwmYEgbD71dSH9BW3okTogEOO6sk+sBj5dQ6tSCcypJYExG?=
 =?us-ascii?Q?aXw6L73ImsF94tZMb/yl02GzLRLd4hIbX/vUejW37Pmqmg1V4FXkPO2rN8pu?=
 =?us-ascii?Q?cBM1d9+I+KIwZkBNw1FBSKWYnxVgbrv72kv6N0aZ7QyNR1+WHrf5PRh/jFDF?=
 =?us-ascii?Q?79fzC8yN/2EWdWx9XlXBoRfdRGWhI3fs8+VJy4s5uxkN0eBq750Ons6Km2OF?=
 =?us-ascii?Q?SpCkrd6kVlgUxMfPIOBXdQkLsPJNK+Gu7oij807DqavgvJBaYCm1ugzZue2n?=
 =?us-ascii?Q?SQiccV5NsdsGWC5Q8Etm0oIwCmoL3MQlsmmaMbmf5zpbP9GaEURyhVViLgXz?=
 =?us-ascii?Q?o8NErcnbBPM3f25U+R+hee7a37XTAcBmFQB/9Opm7vNIQ02+ongxBc3z/+hR?=
 =?us-ascii?Q?d7znzUhR5ErYpDmPV4pv0lFw63ghamtgYWM9s0zPTHJWglblAMPxedWBRNqi?=
 =?us-ascii?Q?it7GzclJYXfnHG+vhqzdVhJgSH50Tik7q6Je/yqG0/UzOfWLXhqzcmOgzu7W?=
 =?us-ascii?Q?DbzmKUUePQfP/24f6bht0GknTi1pN5Q4LeF38j9+AC+BTDsToFdx5udlRcE4?=
 =?us-ascii?Q?tW9Whok+F9c9Tx6IqVieomatMe81YhQxHq0ZBJTWdTuU3Cxo7V+B4LmXicyT?=
 =?us-ascii?Q?ah4NwrMf/48WWyxmRRTX35mEZ+33XIs2OK+vnPRpcisWkuOhIWcWa/8lHcfU?=
 =?us-ascii?Q?ht70LVxUXESeZyWnJdeZJrDot1quTHIm9bWtKaG1Ggckz9Ljhrb3xSHCkeHv?=
 =?us-ascii?Q?uhccYNaYFfWVjtFMuG1ms9Aku11F+VS0VqZM23KIgsoT2nqddDSW4tyPDxhg?=
 =?us-ascii?Q?RgPAW3NbY3ugRhYKhh8YcvRqg/VhE40Zs6SLYvU3tKZdcZyird5D8Wi1WoP9?=
 =?us-ascii?Q?5UH+zfC6uiDO8CYEi2VLT7Y6OXlCZjjvzoXQS/D9vmuMSJt6KkTRaHPaV+xR?=
 =?us-ascii?Q?a6oktDC4KKz96Bv+khSH4Bfbmcna9Vp58PDRqzyQkz13tssnOXTqhdzTIdr8?=
 =?us-ascii?Q?23RPzQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rngIzeF61Qrf2LtzhJkM1yByz6qpWYFUnLg+JUoo6TC78my8zxTSjgukBWJRv/LWYzR8Ivd1areCkGOaS3k0Y2lnyDPLF/3asr2WzcOY8fyH0+cBWht6risEdiT6RFRFewuWxpE4ceUPYGCB3g+yeWn5IV6k6haIOxFFTtzYVzuAJFsGvfuADeYALNK90TVU5trpiddsrHsmyyjAKt7eT2yHv+acR1ZkwcvOiFXkspr7j7URenkDSgU3D+sQuALOSx7A+3ZQfwykBh24I0p7QolMwqFLcrc0rZivVJ3G/GBoXPInL6RrkXZAVEL/r9EBbeVIOj3zpvCqW1vUHf3fwvN4lrzLYWR6VjDKq8K9mzbH4ucbtc60wIU5MZlD0VPAsxU7Fc6zv7p1xD4RvEVmDV2weUYQZEUZaSOurdDV2belKGiaZzKp8ELvcZkpVIzTltkW8kFT6ECc31WqFO9+c75u7SNPHqRmKXHkZbp37/3VUWiDL3jqTq1GsNLmnWQhkuaMM8PkiGIzug5l1h8AHSCd0kPXfO7+gBqwKAJGG3MQ5XhddygeJmOFdg9jmuoZkqz5hHNtcvLtv8wPatIxIjpuDucsiFpqVq4CD+Hzv0I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5525ea68-b34e-4e4b-827e-08dce3096e06
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:22.1123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9v41NBKnYT5yWMFXFyLUzh6tMMYFLAbfpT3bIleeqjHgbhEe6R8gVsv6GXIvK9TOUHGHRDszYMGV7S6CUTvm1Y/uIyNEkdmeApgfbw2u87M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_18,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-GUID: SehoT-kErW7xFmbij2gT1TrFEbIaGe4z
X-Proofpoint-ORIG-GUID: SehoT-kErW7xFmbij2gT1TrFEbIaGe4z

From: "Darrick J. Wong" <djwong@kernel.org>

commit ad206ae50eca62836c5460ab5bbf2a6c59a268e7 upstream.

Check that the number of recovered log iovecs is what is expected for
the xattri opcode is expecting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_attr_item.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index ebf656aaf301..064cb4fe5df4 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -719,6 +719,7 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
+	unsigned int			op;
 
 	attri_formatp = item->ri_buf[0].i_addr;
 	attr_name = item->ri_buf[1].i_addr;
@@ -737,6 +738,32 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	/* Check the number of log iovecs makes sense for the op code. */
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/* Log item, attr name, attr value */
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Log item, attr name */
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
 	/* Validate the attr name */
 	if (item->ri_buf[1].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
-- 
2.39.3

