Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A862A1D79A3
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657138; cv=fail; b=QUP+Q8Pd8AOmMqR5BhhpaYvjE//ZoZ5FCkTD1UJucHxgP+C/iW5aZLT/EbDVTwLOZ5NbOVTJ14Kkn3woMN5j1DNpnmpXpMLPNvwTFhiQvYt9cj53V0fBfP3urKj/EJmjiAH1Sm9v+s4QbDF+IXfZb3rzzVpf9GIa4W3hMAZHUaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657138; c=relaxed/simple;
	bh=ycqVZMYkC+dfKiRhNiIV+c/Ng+x2368+xfWSdAgBamk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ij+k4V8HLmqa3waHYCbkyVpns0zaeE1DnUhnAe4kx78QJP0L4df8tQN5zkELU3LVTk84XMWvRy7NDAbubSkqFtOB3iJ+TzRTSPPLQ5e4cMiwHfDewqoswcg2L3ouRbYaGKk71OMQ2Z5umZTa/GeoK1AQ15HyDJjVx/RIFVqTx5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JKd2WnVW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xsjye/7D; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JKd2WnVW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xsjye/7D"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXiAF024739
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=rCA7hU3+yeUZe0sFXXScc90o16jiClySCAuoTOnlkRU=; b=
	JKd2WnVWIO3UM1e2XnNNXERkJTKcVI24gsFD1+lQZOfOpYRqiaYftCYKR+8bEneY
	n0PmvcCMDsmxkhqUCjtbzComk1rq/qVLAAFb79dGCNl6jw5EemXSJF4us/ZkA33X
	vzq3tUvpMDTU7D/2DEpXMOJPO0eEiHQsaczCdVYZDBxEm/KmEwYHpfyAoAccRRys
	WPhdIiM9F7nPjcjFPyy1wZkvceyDGp+W4GC0DrcPjvidSKCbxuXeCMJS8Y5A2p3y
	jIbmn/1Wp4qC85fEVcLDV7LGbFi/r0h8mZ7208qPM1nGEX4mK+vp4mzQpUDsVyi0
	jHUk59E1uRLl5/MxxJOTXg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkak3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486Ix2xp017932
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyhf3vp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjeBErN3i8JNBhonLqu5HR8tiM+bGS1yDfJ4Ip3dcqlw7JlDP8kwj6CyFjime9sRcTgoGxQp1cWWkEDVbGik+qwolTiKiGli9nbEU8nXj1RxEuBYoxyLI2mT9SL7tmCgKBIg7YDjfWzPmWOY5XF57938PVwukeoh9PFS62lEb76uFz8chkKW+BEnudOep/dhr3U74ZrX872yeDQ/mS/E3atFhCz9yhsN/G2USxkOR4TLj2q9Y3EwAVVxh5YHCEuG3X8Whsqie5oM1TuWzXGBLHAwcxnPr1AyCDrbtXtKap3fAWQQ/6rVJquFKi23RZVSTOKVLRAZsegPD11uyL/2pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCA7hU3+yeUZe0sFXXScc90o16jiClySCAuoTOnlkRU=;
 b=BzuNHXetWjHUeGZR6wDlKBeLvYehzddyRpxKFVWsl47sDIBHomqtuWs7+ey+kHh9YgUoQ+BWrbMagwaann19/Xc33xbSsWdPdkFPVqeWXHWhpuRH/AzPfz7PbJW53Co0JFYliMvAaBkdOS+80eLOOi0U4is3cnTR5seqsZs53ovgoM8XZlZIZ0U2+4pfYLdOxkt/ErvPKFSh7K85C8OttFrykmvU4TfsKjs4CpS36vKNtv63gw5tCbBc3Ldfi3YPckBSvEcSA2VQIy/Mn5/Xx43vw2Ri9T2FyG+Uj2yAnSiO/yGWMeK46ENoQMXU1imoThRUdC/Kny1TLPPP3IQWxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCA7hU3+yeUZe0sFXXScc90o16jiClySCAuoTOnlkRU=;
 b=Xsjye/7DpQtjEF4Y7rO06DHnHyyiV/zLwRCdf1rs+7+t5yeimeCLyYv08Lm7zm6WRb/cTNlPOLhgeBz6rBXS88PcM7HrPd8QkC3CvsAYoEgavqnhK/mEw5Vaa+O0GIVSKyYol/+Nkn9yCw+EWm53fz0Snn5/Nfryr8umdiS8JD0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:13 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:13 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 16/22] xfs: convert delayed extents to unwritten when zeroing post eof blocks
Date: Fri,  6 Sep 2024 14:11:30 -0700
Message-Id: <20240906211136.70391-17-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0120.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::35) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: 77032a19-ab24-4f76-6f29-08dcceb893c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x2WDbbSxgn/RVAY3MJKOPCZ2lkNngajrzidS2Zp6bIdw646AMtMH/L0XNqAv?=
 =?us-ascii?Q?tsTPen19loc67dWtzGhrnatEmQNNnNSgzwpQhyua5Y+86ew+uvAYd1FbyX69?=
 =?us-ascii?Q?JM7zWDy3ih8rjsw34CoiygM8IzAg5DPyg7raLAIL+wHaUxmJbgAI6qRLpO2z?=
 =?us-ascii?Q?Q01h3zAFDmB9h2TYoAzA5u0FSsGrC4vilb32u0POrnd0ZRzrtyqvG78ilGwh?=
 =?us-ascii?Q?DNQy/Bl3t56qVTEKSH3VT/6FRCSnArSDG41OVVhmCSaw03phKGPO6cRWoeFH?=
 =?us-ascii?Q?q9bi1ji5dlG2xwK7cnyrYQCA9khwy53XG1/BKjf8EbUAvqV9Km8Hj3JGzaZN?=
 =?us-ascii?Q?JYLEpuKY2QnM97x8yVPcz4LTWKxHhTQ39Bcm4A4UAE6ZRSOwlzMK/0DRm8kJ?=
 =?us-ascii?Q?K/TYBGEx4bNYZE/TF25pEYiSZYNeEM8XS4YUMekpcz6P1lW9oI+sHHj1Rsk2?=
 =?us-ascii?Q?YTOOJ4sHBq6D55yRTAzegdXw4yWOL5Pcfuts33SxjVFh6XO6XwcGZuWBT7Zz?=
 =?us-ascii?Q?AW0XBWBzV/8x8CLDZ8tbS+aO7gmGRmpYZqxOK7EIL+4N8hGRVCB8URjNEftD?=
 =?us-ascii?Q?lFB2KaeH3SGOHldTBH5HCLPmrlsLGFbUmValCa5BjhPg6zdfgpxhoM1olBPa?=
 =?us-ascii?Q?Ipj6K4FnXkDsND/db55+KI8woTfl//1doyk+Q+g4Jw4ENpp4SYeyolXMj/7U?=
 =?us-ascii?Q?AQuRB7uVBK3lgLqByl1GPYwD1fDJyeBNPGWdBXTOD94xNQfVC7z5voRabbs5?=
 =?us-ascii?Q?vmXRHWph8y+KwzMrrRzYgAWbYZ3cMJuWX65HoQwZQf3eyRM015LHgCrgq/Vl?=
 =?us-ascii?Q?i7XJW0i5xlNlr8NuXzWLbVwxX8Zl9MSkd7IFPTxP1pRMvTbRKUag6+eXH/Xy?=
 =?us-ascii?Q?JO/UUmnOIkUXRU5bBE9uAmm5YM5v+GW0Um2avBgUvAOEQBceuOkpr98JrgCP?=
 =?us-ascii?Q?Jdk52HaaGNrZgFHr4O/dDwKH8WHpst+NLqSjtr5PHj7bOzKXylQxN3MwoMVi?=
 =?us-ascii?Q?e9ZnUgXLsKgoqxxZW5lkYFXK++pZrJny1wDRxyW1+kCYl8duZDtlIpXKzrgZ?=
 =?us-ascii?Q?MjdTssmop5etFNNHJxNjT3XzUGVy57QqzmIKt76mSbQBCYHQnqXr7iBVdgam?=
 =?us-ascii?Q?i32GqzqUserdxudH8Nj09+XCiMo0CpqR6W/qK06eml7KJkuWkUzHK8A3XRq4?=
 =?us-ascii?Q?h1G54J3fV6AOkWaR8934Uf0Pv5I9stB6+EVvuO5C79UADpieWhTf2XzibZqt?=
 =?us-ascii?Q?nWdFD0463iYUQwPVHzdFCW8xSapJhPxSgXo9nUdhmRsCKa/UbEhfs53GZFGB?=
 =?us-ascii?Q?caWUdL0YVuciKoOqWxy613rbdAxGk2lw21MX+aKgT7a+Wg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a+N8ecsVYUV9cJoQPXor5gX2m5uw/AILr23NVmq9KeFyV4LMIX3JS1sKkN60?=
 =?us-ascii?Q?kVz6sdBayTFOAsJgbvUMpdpJgqmdpXB8hlQ2TOCS4k3hXCrcrHvI+SmGyKQJ?=
 =?us-ascii?Q?xaN6nDT+cUR305zBlafX3Qmb81ZANNdt8RG5TjydozqiTCOWr/R3Rzy5+MM+?=
 =?us-ascii?Q?MpeI7latmiiIy/rj+7DFfowHFM8/tyI5sCeffA1hKGAphzfj33eAQA1Z959/?=
 =?us-ascii?Q?WDngPet9FU3BaORRaN44TuXbfzrNP3EVOu5XVAWkrjcDG2IUMgq+tos6U6Ki?=
 =?us-ascii?Q?SK5XN9B1lA1WdWd2pErVFZCnNQYu0zDYBUnn9Sd2InaPnSWWMwPaZNgXfZ47?=
 =?us-ascii?Q?iEPZj3l/R68z97vTXluewMJre4K4xPfcDEELn8D5UVAdc18K0hvWKgv5l61p?=
 =?us-ascii?Q?b/CDank1qHtVYbjDbvxF/N0UlVbCpoOVEpB4jZbdAzVCw42s6QypU3t6z4yz?=
 =?us-ascii?Q?ErRHI6hQ0SSVb/Ky8F9OAp3H30MxjmZlHKJIqQMydjz765p99S+vDAwxxqAO?=
 =?us-ascii?Q?dtuo+mLGV4yEBOr2n8DB0BM+g53aBVAfRxo5vm872SyvRP7zxxssnRrZ0SB9?=
 =?us-ascii?Q?ax/gKlo6J4UJXQ1TMAnL8VHtGEdfC6cdLhYNMi3iSG+akrp2PpagepartVXl?=
 =?us-ascii?Q?m5k+eMET7Swom6F3ysJOqGmy50NbakPM/KB5FiV1f8q0um/ucmS+OwOdfaxC?=
 =?us-ascii?Q?6bzmxY3eryXmvtvy4oCrQ1x26eX/wW/sD+sbGPny/KWajriwbUxvZMOsScFf?=
 =?us-ascii?Q?6OTPd+PtLSVte5P3xT565jqL9O9w+/1ZpAHpXioPoia3g1dz6EZ5BjvI96wr?=
 =?us-ascii?Q?xJenjH2ivTzP/x74iG2YrsRbU6j/k5Rm7hIt9r5JtHzyhLnAwyTc4a4f2mru?=
 =?us-ascii?Q?ByG3YfYmZ6QW6dg6GDTUGhyg1hq+QaEp8dVvElbvczFmwKT3soAhULoeqMmo?=
 =?us-ascii?Q?BLB8YiANwe2K0RSiFLqcS4vfzSRDXHKcQC5MbxSAnWhPr4OI1jqwmBxAlnW/?=
 =?us-ascii?Q?GDv4uqRWlcEGfTOsLimpQBHMtEaIDdKeZg+edjnemIedVJpKaTpqrsZuonf6?=
 =?us-ascii?Q?ZC8aBMIFUEFXD/F0beeaxXF2+YfJilDZjIt5IS5Qi0/v3gEhzWWEWMTyyLOF?=
 =?us-ascii?Q?EqjHhEW6DN4Pp0qy4MSzyfpZaIwFRqI+dwNBZl1ykA3MXlB6uFdmt9BH2wqh?=
 =?us-ascii?Q?/2pqNmiO6gihGgsNF9R3787VFbWrTCRuD+7OBzwiDqKWFRpFNyVFZLDwJXoz?=
 =?us-ascii?Q?KyfwOHNPgIeGeq5/vLl6JtQdLAwQgs8tG+LIFEhTcw3TjR6ki2UhcEJEKrzB?=
 =?us-ascii?Q?lHY1VCLncgbyL347RHXxlFXCBy9dshZE0o+j3MOP8LtTmTUZQBqAP7OQ3Qkh?=
 =?us-ascii?Q?8N/o3UfH7LWBWrmG0Ajs3TifRA1dry1IylZw0X4L6AbGGIkqUitYGQnx14CD?=
 =?us-ascii?Q?1jB3jeBbbwbsiD9Du8tvLonf8FAgbNhfS2vL7z2sME7QeXaKW1nwK0VALRW8?=
 =?us-ascii?Q?6SY2VGP0BakPlqdddiYg0na3bPUQMGPHIU9aRJsgXhResWaOI3P1lPvCK2y+?=
 =?us-ascii?Q?qguZ8up1GpWu4vSEARf3kr1Cth6ty6ZwjHwalhwRM92qOBGxy/w9jHAcu2eO?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cFPS9qZNQwIXwOPfaq0PwwcafEuZwmuJiom4Z6QuF4mbwrBr6nfRu1lPWq48+8vYTgoh74tSiyqvJCr9Nii3Uzj12X2YDVuRD4k7n4zhcHjTsEnFpN0gintC1EFyou8UYuSVvbXmfTXlPoHHw07IMIwXLc6H9FdFAz/TgqOLTLG2vnOqrdxJHo3AC0x+y8kmbGmHphtwsuQ0O56VKRmVpMNJCKmaS/ucVnA9QTJnnJSlbQR9UH92NMEYpqKNfKkqeBn2dV1m7Vtj4TyonNtkeXzYtCX9aVC0AU8lBQeBaEP7oWsW0smvPJziiIeLBYdiVwuktp1Nr/zVXbbAyZtokYuWaP8PSERMW3E5DUvCokHMgc07JFeEMmaCWr52WURbknZWdUN7T/XxWuxf/wB/fWL0QxKc2QUYIcXIDC/b6hqmbyPHqEhs2qZK+1yHnsrWOltnQV4anQ3SSlk0PSaPfZJoD28gq9SSQ6CoSXMiDagOrqh1RgORsTn9cB2BGulp+NTetXySdz3DMwjjLTdBTc3bKCkKqw1IQ+um+NZq6YiPSAUoPjS04GtBuGJEAnWjSp6kEWdny4zw2r4+ZcxnaoD+mh0gb+/C418BLtWOMbk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77032a19-ab24-4f76-6f29-08dcceb893c2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:12.9464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /pFj9oJoVTBAgTkmogu3X05cdAQsOwxbZS8/6gNq/HitiWLD7pk0GlQDONsjJQ29NjRxhJtW+hH50Qx4k4kNTOEbl3wgxnmoeimtGyZSOy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060157
X-Proofpoint-GUID: 5XWHwWy143qklS2wq7KNsjIatwpIC5W2
X-Proofpoint-ORIG-GUID: 5XWHwWy143qklS2wq7KNsjIatwpIC5W2

From: Zhang Yi <yi.zhang@huawei.com>

commit 5ce5674187c345dc31534d2024c09ad8ef29b7ba upstream.

Current clone operation could be non-atomic if the destination of a file
is beyond EOF, user could get a file with corrupted (zeroed) data on
crash.

The problem is about preallocations. If you write some data into a file:

	[A...B)

and XFS decides to preallocate some post-eof blocks, then it can create
a delayed allocation reservation:

	[A.........D)

The writeback path tries to convert delayed extents to real ones by
allocating blocks. If there aren't enough contiguous free space, we can
end up with two extents, the first real and the second still delalloc:

	[A....C)[C.D)

After that, both the in-memory and the on-disk file sizes are still B.
If we clone into the range [E...F) from another file:

	[A....C)[C.D)      [E...F)

then xfs_reflink_zero_posteof() calls iomap_zero_range() to zero out the
range [B, E) beyond EOF and flush it. Since [C, D) is still a delalloc
extent, its pagecache will be zeroed and both the in-memory and on-disk
size will be updated to D after flushing but before cloning. This is
wrong, because the user can see the size change and read the zeroes
while the clone operation is ongoing.

We need to keep the in-memory and on-disk size before the clone
operation starts, so instead of writing zeroes through the page cache
for delayed ranges beyond EOF, we convert these ranges to unwritten and
invalidate any cached data over that range beyond EOF.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_iomap.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 359aa4fc09b6..1a150ecbd2b7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1005,6 +1005,24 @@ xfs_buffered_write_iomap_begin(
 		goto out_unlock;
 	}
 
+	/*
+	 * For zeroing, trim a delalloc extent that extends beyond the EOF
+	 * block.  If it starts beyond the EOF block, convert it to an
+	 * unwritten extent.
+	 */
+	if ((flags & IOMAP_ZERO) && imap.br_startoff <= offset_fsb &&
+	    isnullstartblock(imap.br_startblock)) {
+		xfs_fileoff_t eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
+
+		if (offset_fsb >= eof_fsb)
+			goto convert_delay;
+		if (end_fsb > eof_fsb) {
+			end_fsb = eof_fsb;
+			xfs_trim_extent(&imap, offset_fsb,
+					end_fsb - offset_fsb);
+		}
+	}
+
 	/*
 	 * Search the COW fork extent list even if we did not find a data fork
 	 * extent.  This serves two purposes: first this implements the
@@ -1150,6 +1168,17 @@ xfs_buffered_write_iomap_begin(
 	xfs_iunlock(ip, lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 
+convert_delay:
+	xfs_iunlock(ip, lockmode);
+	truncate_pagecache(inode, offset);
+	error = xfs_bmapi_convert_delalloc(ip, XFS_DATA_FORK, offset,
+					   iomap, NULL);
+	if (error)
+		return error;
+
+	trace_xfs_iomap_alloc(ip, offset, count, XFS_DATA_FORK, &imap);
+	return 0;
+
 found_cow:
 	seq = xfs_iomap_inode_sequence(ip, 0);
 	if (imap.br_startoff <= offset_fsb) {
-- 
2.39.3

