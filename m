Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD073451B0;
	Fri,  5 Jun 2026 01:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780623433; cv=fail; b=D46X+kj65g4qoh1YxFqh2gk8ZNeaMj11EXHGMYOK9KW2XU1S2czgGYE8bVgptSYSeBaGomk2WCQCqWM/aBIX8PdyvSu5UwAdW1L8g68TDxpagIwY+yTvFsdpjJHbC1uq6BfiuGPh1KC+p/vcPEAECdRZbKMV7mnCeiuuIvpZgks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780623433; c=relaxed/simple;
	bh=Av/oP5TBvgBYJJ8wdS5VTZiSbozUafGXCKNpkUW93Ck=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZtI2abdmn6Dt2oeHdemsh+NOpFQb97P+8r7D2EWOfmFanKVa6C5EHThOzCfATptB4ZKSlM6zR4xJhKyac0rodDoNMRlq46jhOe9GP7WIO0aUYSUHIGuZwxjH4yqDq1JuCxDIJ762mG7wj1oyD8bx0AkatJLLsDkrYx4IEZjGPMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=QYrSW1WR; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="QYrSW1WR"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6550IaJ04047366;
	Thu, 4 Jun 2026 18:36:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=rVNm7kCuPfg5tDXwMup9t7alT6H79Dd/rYZxn/m2EUg=; b=
	QYrSW1WRQ+m3HTErPTa8IksO92jrhjk/udHomAP8whwY1NOig93gm32WAnVkao5E
	Y3ml71KUXSQ7x/oJAO3aR7hN3l0XuKC3iugF1Fu6id96q73YFRKyIj7DBal+/gDO
	gqytWNYFxmw4MOjX0Y4II6MUk6baTKm9pPNYbAFKgCgfdUf0JeN4eaQgA4wnLldf
	E4ObGvrOoyBrWUssjGQrT94okFoUyTrKd4gm7MDopjmDHpxdXyFWV0WSDE8BG+c9
	vIP7GqpdJwXVv0du9SRktxiw1tgtq9Y1+4jzw1R14mvG9M1LdwQApw1ep1IeWJp8
	616GJIBZHZ4KinRqD0230A==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013002.outbound.protection.outlook.com [40.93.196.2])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ekkb8g38p-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 04 Jun 2026 18:36:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gYAn3hSyX5VMYBDOir11NiuqFclO/oOmax3wIjIttviYOHSaKR+Q0YIR1bYy9frs4tbHq2tLcz+9+XUX0pJq3u2woCXpdfTUglPYImd2xBJ2Dyuo4FpAfzRkZh/r+Yu3WVC6MzpIVDTie2W2MH9OFFxSmwJyyMpcS8DDg8cfZnzuVjB80O/wT0Kltmhla54xXQR9y+KAw0oWylGIM1Z8a0BuzbvCjVEHe20B5c5OpZlc4s9vB1yh2GyMKIvLFNkvREr+Kbn/0K1M0c6fsmOpAEKYfXtXKSRZZ/I4vxnxVlVyhFYX4S1/lsurjlpuoYoM99Wc9qU4t/Tsgzm6BsQYFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rVNm7kCuPfg5tDXwMup9t7alT6H79Dd/rYZxn/m2EUg=;
 b=bEhkqWk+bU8RY6k+SNI2tzxNmTGEY961TrpcKv3I0KHzgdLHfsf0c1TVu82Tc7xx7/sNRP951LHQrAj2GqsawwgGhMn2YWJ7AuVAqG0v4Cip/5JtKfVf2r1Ag8N8ffQ3LqwiakJmncarxY8gFqhNVsFiPuk6KVQAXP3cJfgN5a4gE4Ky1swxbhvCNyTXqlOB2HOLmjL5AqWwrxb6GovG3DGL+yIwZfiyra6+2qpJuQimqmbhQ2txgNMQDTn6GJCGv5wRrNJ6Rdv7aQKdivM4/stHB64zlsQrhxLiqikDPfzzEJ4fB3ET35SlqufMQT0TxV+5KRyclEC7kfP789EcbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH7PR11MB6498.namprd11.prod.outlook.com (2603:10b6:510:1f1::21)
 by MN0PR11MB6086.namprd11.prod.outlook.com (2603:10b6:208:3ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Fri, 5 Jun 2026
 01:36:46 +0000
Received: from PH7PR11MB6498.namprd11.prod.outlook.com
 ([fe80::492d:f133:b4c3:f94e]) by PH7PR11MB6498.namprd11.prod.outlook.com
 ([fe80::492d:f133:b4c3:f94e%6]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 01:36:45 +0000
From: Jiping Ma <jiping.ma2@windriver.com>
To: sashal@kernel.org
Cc: cem@kernel.org, djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
        mark.tinguely@oracle.com, stable@vger.kernel.org
Subject: [PATCH] xfs: remove xfs_attr_leaf_hasname
Date: Fri,  5 Jun 2026 09:36:25 +0800
Message-Id: <20260605013625.1393729-1-jiping.ma2@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260301013354.1693231-1-sashal@kernel.org>
References: <20260301013354.1693231-1-sashal@kernel.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0102.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::17) To PH7PR11MB6498.namprd11.prod.outlook.com
 (2603:10b6:510:1f1::21)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6498:EE_|MN0PR11MB6086:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e829132-8cd4-4a89-e693-08dec2a2e774
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|11063799006|56012099006|18002099003|22082099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	0GbBpB0Neg91ljxpsZME3sV8977yDFDOk9E1U+DShzLYDJGmQqZQAFMVrs2dxIUqGDcjFCxFUpyN+x+KRGFefz4s+9yFrg8tlTS4bv0CIy3eGN5/cXzlB7KrZr7CwVpWMwWAlNuVCgLy8r8G35NYmTi0JQlJeFpQO+JLJCqeSEML1ARKfX5XhRicptyFsZYNtrH4wK0S44xE8j/m66jUX1FRMilQsOUlO37cSi4iRop4+vki9/8EiEO0RqZm3Mg3YcmV+wO+/+QvwkqZ8XIbCDDkcUeUNrpTDOpvQSxLdFFQw2kMdli89Xxvq8njjQih+jIzFBer69xb6fMKlfqgr2Kb+jUYmfG5DotpMMTpf4jpE8tq0Y5a0Za18VS+z42TV3HmTodoC8wPZcf6MGTuhkixAYDzzJD2CZttj+mKYqKYv8Mv/trsRiLamDpnFl0yFm878DbJPgm26MhwKE8OBe6zfLJyshcpEfcGoM+dDgJlFetbQMGPWpq8LBH8r9O+32Y3I6iS0DN5S9VSNiK6BnWr5px3kMdKDpwUW5i5PPho+SWZwT0DeLRy7NAiW/rKJ6OWjsunl11p/2gNj1JBWm/cHTqDX6z1b4YZz4FfEdPUUJwCDVVmqrOAbFmK7b4n4xkYcSseTLXJdn1HnudKNnGPzTJhtHdKERlIB4wygtjTQDC51pOJ2ysibz902evWKfcRKudfmhUy0ANj0RA3OMw3o9NZ+4mVIBavdDCI7qLR4U030jQJvKaIpOreXHAv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6498.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(11063799006)(56012099006)(18002099003)(22082099003)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aXuJQ0BM6JLF612I8V8CRHp0qxOZ2s8WjW65jw33y20xsE3R9xh5wb7VJTPH?=
 =?us-ascii?Q?QE2Gnee+54Nq0XevnqiqqZJf3jx7TqQmVOVJ+L8K1XGMIt800S90yZVnKbGZ?=
 =?us-ascii?Q?OVNUqy2JSMeemGY6aZbs2TTWdPaj1zYBqRmfeuUZ4RgYrLIgSxk5x/WUsJH0?=
 =?us-ascii?Q?xOIFFYV04BrxfnpDxYum1Zb95czqLfk58UCoXrb0WuFGwmcDMw0o1TjYUvuc?=
 =?us-ascii?Q?KBsfXji+9xAvVaXWq0naiiU6tJe/DisRuQx33rH4sJjO175SdBBITnDGhxWE?=
 =?us-ascii?Q?E5gLTabm0zLX5nSvEIw+Oek8AiIRVIEj4tn61DdAzn08z6BwcbgmZB9XtvLN?=
 =?us-ascii?Q?EnDTbJHZpYtNXlI1vLgWiAeTvnjRKSegIPveN9RswC37YfhrEjlnJrCS4dZM?=
 =?us-ascii?Q?YRRcltSwYLhyPVSXG7coRwq9IjhhSRXVrvKbwlov/X7ttXYgnqebBXnmWL5v?=
 =?us-ascii?Q?wHm2w/ZL3Bs/vGauV3eR2uszzohWhmuGpGXfr9QCpMNs1SlBVgJkmU6PL1Y9?=
 =?us-ascii?Q?+NGd1ZMu2gW/CLjqKGrLSNf299gcVvWdfNJFDZ4TNELy6gTg/74PQNkRcJpb?=
 =?us-ascii?Q?0lyel45UrD2f5jbn2UynjsmZo/s5TBYO5yOimtZ2pil1Lt66TL5MKnov7A79?=
 =?us-ascii?Q?xHVyNLxslEwotrt+oAehaoeOtjSdU/HGZB6npnqZ1dSp+5Wq1zx6sskbMt94?=
 =?us-ascii?Q?HI+xSUESILKfDyAyGRYkykG+FGNZpnQYEL+CV4nAJrNjenHvQpjMMRKwhR8a?=
 =?us-ascii?Q?Gf1aln64h2/xgYUtXVr/MBqR9gkMplh2kJ2fQzbA5vCTp8fTKHGjYbFZAjfb?=
 =?us-ascii?Q?/sy9Afe2xYWupjI3ubjbkGOnYBu2aMTLm2/OBqb0y2n5x6C2EwxQGddMXokK?=
 =?us-ascii?Q?SNagv62gBJgkdyQTwWjqM3mhE8nmO9alYdzBgfD03MQiNQGEBwQT7aPtPf2P?=
 =?us-ascii?Q?seIgQa1x82+xZG5Zu7n363IYTLngdSfFhQxHQbS05MLIMB/cKffCJEyu6JNf?=
 =?us-ascii?Q?HeIc7SA5Nxn1Lj8hw9EefSsdnNWnuP18/vml/Hh05dTWYaV5hfhRxsRKtaMj?=
 =?us-ascii?Q?j2rkmIW4uXkcGNgGP5lsznjlqgHk//NlzC56AXLIQHEle0w7alGAKKRpVB6C?=
 =?us-ascii?Q?aJ8/sJvipyPSR1z3rqrig+obcqaMf24ummup28AIpsUm6axZk2XuiWNFTGdj?=
 =?us-ascii?Q?kAPFbS/C2Bve9aK7GFFyC6aP68vXIRpD/mmOZ8h/TOAOM0v8otkNs71zqmje?=
 =?us-ascii?Q?c3rGZaR4rfykmDAwjCqkfT2CkGwx1MjNUtahmNhToAu40QLKx2uin6SrUE5D?=
 =?us-ascii?Q?Ku0HBE9wL420ANbc5EenPyS7fNunvnXRHb1JLLlNHwF1aUeMdnsyjGB2AiuL?=
 =?us-ascii?Q?aBrJZKHSyqPwmWzVdKipWKNL/Rs5OBv4E27ZbxXuhzz6r0b77c5TTqONardi?=
 =?us-ascii?Q?h2R/lCNVKc/m1MWPJJAeKy88KMpWcw3k9CbTS+KbfCmNMB13m3QLPG8z3ZVA?=
 =?us-ascii?Q?qGZl+UJpnJQFrLwCFHbpNtqsIdNxX9JNbbUwIKbJX6BUIqdLHi+Pw4+BrZf0?=
 =?us-ascii?Q?zLbL9uWHReqRUOW7Ib7vIjRZb5gTU9LGR9Y3M4CJWFRAuMtZ2G90DT9DiZFX?=
 =?us-ascii?Q?b/YZZtjGuMzZH2wyZKcqb3bvysu9wtu/Ltmr5Kn3yNgR0d0jMJ2xZlpwB2VY?=
 =?us-ascii?Q?vIrKZlCLW6MHXyxQgFIXkxMJRbxCAJnWOAtud9zBg/jGA4eeu5KpbzN3omla?=
 =?us-ascii?Q?mBikn94E7A=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	KSUQGtrkepzIETfWLRMIBZFY+UIN3tXgAaTaNTcgGdO187Wo3c7gKECKtgrY5mTf0/+r/yDOqHKdiGqKvkpyBufyEJ4o9c/IZbBy7c2Uhd/DCkEvQxhuRGTOwu60tQg2kubK9lpAxg3wzWr9LSHRwuaOQGpms2EnRiTU6uMjId2Ks3mAgYTF6VjltxmWwgRmYH7QB103/m1fyLirskmUYUr1uRgp8zxGaXHw9DwnFdIZtM3qfbczsheTQSSGE7Gr/rKxkLB9+bm7oywa6E2YIW/FocvewJk1mlH0XE9uMucd7l7kfk8ZXSnIbYSow717DvPTfWkzlNP6ot3O4IY6qw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e829132-8cd4-4a89-e693-08dec2a2e774
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6498.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 01:36:45.9223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zzIwSpkPnIMo6efGQhzM3qIOf57ODTvzlNc6hvVhfvnM06FK+lFNzkq6pre2egCdJqy//eYXjs2fUDJfYRMxJmbHKgwbh9eFUCDvEwBz/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6086
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDAxMiBTYWx0ZWRfXy8+joUTqdjrN
 Or+FrUZOsWYY/mfNA/WzchnOjTTvYID3s/5fxUma7XccPVD/Ud9ydKcYV7cqZu606nvRve0EsUF
 GmJE19DKqLN0JMSROtMSsjybpdDkaUKmmoJ/Nd4AI6mP3WZvkSi0guBUhjeXUlwqAfUM+KZ+ln+
 DvmxAaRHchSb2bmJTlPZy/2vrbfEJGsU7YMcZl7x5MtCTNmGDx+Xr5ZRKUgU1G2fJq6+NZYOEvF
 ah9eVgnmPrp31FnySNXpTtaLCliiEbMygufZnqHHIxYrLD/ovGfZkrThmmS8xBo0ISLfEZ1CHWv
 3sVnjB/GSLGtrcYfANjEvu/6TOTsb9fdS3Ouqvkqw1mfpFawaIte9NxAMI3xuzWhnQssKZGlb8e
 2gc/thf9r3Je9T/UN8SY+jG7jF75nDfjWPPindl45kEn6ShQ9dZEES10a1MZ1Xu+/OWXiKWPgB+
 Nvot6d5OZs4fXznUyWg==
X-Authority-Analysis: v=2.4 cv=PtejqQM3 c=1 sm=1 tr=0 ts=6a222831 cx=c_pps
 a=qSv8Sft3UEt4GReRCOm4JQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=t7CeM3EgAAAA:8 a=5JT10hfYxzl5BSHJoHMA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: ejnRW1SZCU94wBWfEm94FApJ3SSbNGIc
X-Proofpoint-ORIG-GUID: ejnRW1SZCU94wBWfEm94FApJ3SSbNGIc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-04_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0
 suspectscore=0 clxscore=1011 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606050012

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3a65ea768b8094e4699e72f9ab420eb9e0f3f568 ]

The calling convention of xfs_attr_leaf_hasname() is problematic, because
it returns a NULL buffer when xfs_attr3_leaf_read fails, a valid buffer
when xfs_attr3_leaf_lookup_int returns -ENOATTR or -EEXIST, and a
non-NULL buffer pointer for an already released buffer when
xfs_attr3_leaf_lookup_int fails with other error values.

Fix this by simply open coding xfs_attr_leaf_hasname in the callers, so
that the buffer release code is done by each caller of
xfs_attr3_leaf_read.

Cc: stable@vger.kernel.org # v5.19+
Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Reported-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
(Adjust the patch to reflect context changes caused by commit f4887fbc41dc
 ("xfs: validate attr leaf buffer owners"), which was introduced in
 v6.10-rc1)
Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
---
 fs/xfs/libxfs/xfs_attr.c | 74 +++++++++++++---------------------------
 1 file changed, 23 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 50172bb8026f..024e9734c0b6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -49,7 +49,6 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -917,11 +916,11 @@ xfs_attr_lookup(
 		return xfs_attr_sf_findname(args, NULL, NULL);
 
 	if (xfs_attr_is_leaf(dp)) {
-		error = xfs_attr_leaf_hasname(args, &bp);
-
-		if (bp)
-			xfs_trans_brelse(args->trans, bp);
-
+		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+		if (error)
+			return error;
+		error = xfs_attr3_leaf_lookup_int(bp, args);
+		xfs_trans_brelse(args->trans, bp);
 		return error;
 	}
 
@@ -1215,27 +1214,6 @@ xfs_attr_shortform_addname(
  * External routines when attribute list is one block
  *========================================================================*/
 
-/*
- * Return EEXIST if attr is found, or ENOATTR if not
- */
-STATIC int
-xfs_attr_leaf_hasname(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**bp)
-{
-	int                     error = 0;
-
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, bp);
-	if (error)
-		return error;
-
-	error = xfs_attr3_leaf_lookup_int(*bp, args);
-	if (error != -ENOATTR && error != -EEXIST)
-		xfs_trans_brelse(args->trans, *bp);
-
-	return error;
-}
-
 /*
  * Remove a name from the leaf attribute list structure
  *
@@ -1246,25 +1224,22 @@ STATIC int
 xfs_attr_leaf_removename(
 	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp;
-	struct xfs_buf		*bp;
+	struct xfs_inode	*dp = args->dp;
 	int			error, forkoff;
+	struct xfs_buf		*bp;
 
 	trace_xfs_attr_leaf_removename(args);
 
-	/*
-	 * Remove the attribute.
-	 */
-	dp = args->dp;
-
-	error = xfs_attr_leaf_hasname(args, &bp);
-	if (error == -ENOATTR) {
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	if (error)
+		return error;
+	error = xfs_attr3_leaf_lookup_int(bp, args);
+	if (error != -EEXIST) {
 		xfs_trans_brelse(args->trans, bp);
-		if (args->op_flags & XFS_DA_OP_RECOVERY)
+		if (error == -ENOATTR && (args->op_flags & XFS_DA_OP_RECOVERY))
 			return 0;
 		return error;
-	} else if (error != -EEXIST)
-		return error;
+	}
 
 	xfs_attr3_leaf_remove(bp, args);
 
@@ -1288,23 +1263,20 @@ xfs_attr_leaf_removename(
  * Returns 0 on successful retrieval, otherwise an error.
  */
 STATIC int
-xfs_attr_leaf_get(xfs_da_args_t *args)
+xfs_attr_leaf_get(
+	struct xfs_da_args	*args)
 {
-	struct xfs_buf *bp;
-	int error;
+	struct xfs_buf		*bp;
+	int			error;
 
 	trace_xfs_attr_leaf_get(args);
 
-	error = xfs_attr_leaf_hasname(args, &bp);
-
-	if (error == -ENOATTR)  {
-		xfs_trans_brelse(args->trans, bp);
-		return error;
-	} else if (error != -EEXIST)
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	if (error)
 		return error;
-
-
-	error = xfs_attr3_leaf_getvalue(bp, args);
+	error = xfs_attr3_leaf_lookup_int(bp, args);
+	if (error == -EEXIST)
+		error = xfs_attr3_leaf_getvalue(bp, args);
 	xfs_trans_brelse(args->trans, bp);
 	return error;
 }
-- 
2.34.1

