Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D8F3BED35;
	Tue, 13 Oct 2026 08:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879383; cv=fail; b=K3pCWUnLIzyl1hTRCaBTdUnt2MGTs0VW4sDWuGfGVqe/5Ywa9/QjmpGoE1yrcA1IKI6zwJu11MwtpeshrWRzhnAvbcj1HWSM9ag1h7kXL1POPAjHsEpCZo32yiSjW8G58Lk8MzZZEEp92KPZmOTyZUnBtem02PZiK8zBOuX4ess=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879383; c=relaxed/simple;
	bh=TYcSN5L2I0z031dsPJqYpx09TbeZsdA+QNfihtqDybs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SeD4a2h7G6/UZb80JP05Ap1PEJpuHG1y6OZtAz5r5ISDgwoV/x0zEK+YXBBGbGsGpqIrl8hV059NULzH1ZSXsIN3lF7R5JB/rAhIE+mPUVN0XN+/lPJcjZ1r13CRCttfTBSZj5bt3g9pYfJg+tOhBA6Lup9Fdx/0DOmXo6kQ0Sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GYcC+q5D; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oqQjIB00; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GYcC+q5D";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oqQjIB00"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D5JeaI178346;
	Tue, 13 Oct 2026 08:16:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FjzJyrAc+L2v3cekUBG7b/K0eoBAA8gnGDNXdZ3VSY8=; b=
	GYcC+q5DHoAov2e3suL2tgvWFDHynd3njD+Yb2mSue1wBWzLGt/dWwMRJRsOgV7m
	lF9+XRF2OkoDl+sFvxaEh1O+iRl2Q2wHQWDdczFfIgpgGnTfsqVPxIb3tvCjNY+V
	s0tF5wAH/Nv4J3xvNmxu/SN72aL9/1dOh/pmiWeY6AAuzqly01B9mKovhx3fpHGA
	+FOluqqGbxgJ6RlyrQKoW6VWRucurAHXp8RhPGD8NepKvIkeOuekvupoq+21sOn/
	PeTLUo4aVAe2za5lyRbSvtL3P/tMrszNChpJMyfI00J9UbUDCbexMSn4nrlTntEf
	Ix/14a4o/aKcE6U2xXXtVg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkkvf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:16:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86PJ2024943;
	Tue, 13 Oct 2026 08:16:16 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9at2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:16:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sipnmb36k8UfjdndC3r1vXqnbVrJnp/aQQ0LxD1cfVzoOpePID2o8fAX9xW36Ad3tK6RYUeAOpvnnL2dANcDzOOS/Vpz5KTYkl4tB1UeZqNXHwFCt1Bu2sjKH8kbk37ACF8oBo0dr1EDLNoDVIgLtth/1BpD0NnGGXwy3TIrXPXcKsfE/KsOEpWfxWPDfVmJlBCZxb24vnGYdoavQqbi2OITp6znEYncjwW9nqbte1Jyg0pfZoxYvq8pZgZGW9QJhM30Dq9y0k05zlDEw/1s/47Dd/oYiR57gfyo5p1c015otCxMlK9higN95b69SgMMN+CnPiEF7iOknXbRCaXh5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjzJyrAc+L2v3cekUBG7b/K0eoBAA8gnGDNXdZ3VSY8=;
 b=sDjQCovb8EW+lZHLDdCVZcOaiJHIDGm51iyhVtfwDaNFiTfsR4hEj6n/FZpa5PD5fkYEM0xqtkx27+qEfpVfjZA1iaLvPL9TcEjF0SB0JPYrxhNroDjbxMletWK70R0Pu9Sm+OuwUF2FEeIe6ZgpW/MNjIVU42uTjtLRMRlcKFBSE0c7bS6pOIDVxUnO+sSur5P3Gy5LOXDFKrydMVAIJxUrPnMjPSQnQGjgj8L5ht1RdLqYxg2sa7o4x5h9Iup74E8T3jomyxZjRWqNImI21PgWMwQrccanzY9FYdn2USHiTTOaZHTShu4eVXt/5d1JiexoKvF9QkNpThfetlW6hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjzJyrAc+L2v3cekUBG7b/K0eoBAA8gnGDNXdZ3VSY8=;
 b=oqQjIB00MwUakhDwgqQzYCSlD3RvWDJYxPs8tvSf0YSjkqmOo4xe4AfthY08jHzayk2yih+2KloZ8c1oqKdxvlW1du/RHd06NsVVcBhb/KqeYYPVBiQXDhs43d7fIFZNfbuC5Cn4yCtwiHy4+m9uh0+nioOztOEsEgHJJl9VfpA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:16:14 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:16:14 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 14/19] xfs: buffer pins need to hold a buffer reference
Date: Tue, 13 Oct 2026 13:44:58 +0530
Message-ID: <671f30fd39ca9070c7653fab351229af5e0b30e6.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:4:186::9) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: dce80e25-0d44-4999-c854-08df29023f48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|5023799004|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ruzNvGkQvI/+pZdYiPiNuGVLrxqnhutBO90cOzlzgwM92Scb35FL764j3Hj3jqkzhOoIdRH4mtGbVOKVvHcGbEJCiP9DpjUQ8Bo6BTxl7qgidOm3J+RTcuj6lFmc/uFOu7J8zR6vXrsg1upQYILWyl/mjM4SnfsGh4xUs3orWo2pe0g5F6bSqzx1qptCL3fJRJdVBj5iUI5cEqS/UwBWXsFdY4IhiiT4SqLMLEmgJwekQ0FCQduA5+dxR/3pVt+bL0BIrjeV7NvktGSXknXQAqZQSLpNGavPusZiA8lsnSImr0uaIFWxdJR6vR01eWvUSZpnGTje/SncFW3N1iwbN6VQy32oxRoDjRrKndm/Gu0z5VvIyefPc0lXkUptWnV+gtaeJkCbsRKAW1QeK0IRDomZys3w4hBOsfQ86Dq0qNR8QO5U9l7uJahjGrniB8AYcmimnoj1mMN5hhVJIXiIVIhexaoBpgD3JoAEROolOFfxJDTbK3y+X3xQc3OcKcgcZuNAkYFzQVRNuV5axPQEE9e3js3AaJRF6/AvRL6CO/6+zPbGXj7GEUrl6yJuTVKUjuWofUHMm/2tVYXYen8dLg8bOD4yXVEJLHZ8fuU4HGWLm6fDfZ4A5RvRjElsgfta5jMROB17M1k2lsaJW5EhGqSwicntJgEUpbbnvEIcid0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(5023799004)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6vJKnanib2/KRwYTdLkak0GjjR3Lv7hSjZvTj0+wG0eJbtPhKXORwQwMT+QS?=
 =?us-ascii?Q?UoG8eqG9LpEMumG/n6EKkFdjj9QOev4CUrGjXURjC/OHdllMX/ta0yx5TrBK?=
 =?us-ascii?Q?b9Mlx7KLgII179hbnHbkyZD5O9xnmoBdt/lujPD0zDwQtOYjAzTMKMiC0lKN?=
 =?us-ascii?Q?+xJWrZkdavw4c9HwpBLAQBjl7TC2wTfbhAx9XKFCOKi7ZJNdWsqX5HR4rsWq?=
 =?us-ascii?Q?Bl72xFISgTX83/GphC4KjycpwQK82Gi6WHG2tRe1Qv5TzWHnD9kHOLNJCHe8?=
 =?us-ascii?Q?BoMp/vvrw9VcQXO54E4tL8MW3f/54R/0HTDs9+SHU/iUd8A0RJAx4t6RBBUN?=
 =?us-ascii?Q?CoddDwh1XyfeydXArjqSNJwAoaQ662aAbxLV3RZeiogsSh+416bMgE1zt4rB?=
 =?us-ascii?Q?dQMEAlBDBub5TPmjQWFmKmr8O62LfmcMIvKH7rX6CF72K7fr0Sk74jdkdzoi?=
 =?us-ascii?Q?qVjOPXcD3wJ96jqyaVh+M9ssMOxfaJcKwT6Dbp5RENR3vvuLDY0CsCn7Owku?=
 =?us-ascii?Q?AtFpbQoW+I187ccut8NH62LXPxMXusg8uiOZsTFMts7Ucxo87v9d8mTTsZZI?=
 =?us-ascii?Q?bH+RGWbbhHlwugMCMZQANcmj2fnSBZv4DtcJF/I1sZl9VSjQ83d7xBfp6mFG?=
 =?us-ascii?Q?U++TAfzCego4020OlWzfx/0HbVH6PhiDtiK9pt9eunHXjxes5ZH8vQkrpXNk?=
 =?us-ascii?Q?3ygq2wh2u11nF9gIOewIBKkgkXeqDIQB7hDDBwY5mwXVnLXi2Nn0XdReMd3U?=
 =?us-ascii?Q?+it1lKiDOPOrtzsWQqlI3nMofYtJJVO9R4f28HxEaOOQ0G0TwzqFGBBrMMHT?=
 =?us-ascii?Q?a7EoD5x5uzWfNQF2uZimrrRLcEWtRcCL9fq9JSSSQeum5wwnAAOjghCHzvmu?=
 =?us-ascii?Q?xOMXFyA9/UUnxp1GoWUMy4SEj91V2munN56+wgGJpIOKydxN1FcQOcWfeBGB?=
 =?us-ascii?Q?ZmOPCSNr7E2Y33HAUUtErMvfU0mxYoQusG10b7KAYZgkRStGiAmrikBP3beP?=
 =?us-ascii?Q?Yz0CqfGdIWbAdTSsP2mbT9Od7o+TAHjeteVlqQD8I+3oeARxZE5903gmaGJw?=
 =?us-ascii?Q?OBXlrMv5mcF1Snx9YksSrELmjgCetCSFy53OtndJmGdKmlnhD4y95i56GNop?=
 =?us-ascii?Q?Sn6sjF4chW9fZZNME+lvpdSklsZm+iR547iohfaGyH4dWk1jetUDpk0+MicW?=
 =?us-ascii?Q?kaPuibSefORB+c7e/sJfaHAM0/lLkb0Nq/k9T4ftSzcgQ8PqZFpfOgpXkBla?=
 =?us-ascii?Q?gWyYv4mfCLmSbshTTedV3DUULpuYRvxRQXaeLD10HPhnxAkFYthyEL059dNW?=
 =?us-ascii?Q?Dfj/hSoIT6XCJUSRDvLM63wJpLjDhYDMoxSVYmqaHtsalF2R7aD/xv0Wx01K?=
 =?us-ascii?Q?bvNEcOMVK8jTpWjxiSHSH4smTft2tP2fCv2V6nIXdhaRP/k3QFRpRm1GD6nM?=
 =?us-ascii?Q?rkdiLv8gjd/WxC91o6CUUFNnlEwes2j0XoTEwGwFC1fAqnX8eP48DU5CbZ+d?=
 =?us-ascii?Q?M5HqciB1sdT9yQtz4o5A1VpWUYmm23xpB479OyoxNLungDmR8KwuVl3pZ3lv?=
 =?us-ascii?Q?Ba6XvwuF3fsM7x8spsBR3k8fEaGcTHaZV380tsE+Y2lG+opSgXVdIfutjbmo?=
 =?us-ascii?Q?+dmPWfdpm9QTJ1tY8ZhnQnQDUB3eQTKyQP1chERhOocWgtVyarkTtKjT0XGZ?=
 =?us-ascii?Q?1BF7a74EIUG5Zd+h7OKSPDAVjC/7EDMu0tK8j6m1EbcnWsI1GlVL4F/zBfzn?=
 =?us-ascii?Q?2w5FEpJtUS6FTe18kHd/kYJhe2TWqfG3IWcf8va0Pab2dGuAZhLK6Lc5uywu?=
X-MS-Exchange-AntiSpam-MessageData-1: ol4qJg+fSqFQkMa9sz0nCPDOpefy2othVIw=
X-Exchange-RoutingPolicyChecked:
	ew9zyJNnBbmt/P43SMZ6NCO4CLnnuhE0oGJgr/AuNiyLHlN74K+56TFXEO+0fRjtXZpjoZrKKFmJspwarj4ylO3kHwP8H+F+IIyyp/gjL7c/qQs08wGhWE3PmRsaLpAdtEeAkGkBUkM7efzqQQm3FHY7Jsr8izX97IpAWx9EtUyyyaV/c2UOri7ohwsXLdMc0pXz3vIgCaDq6igoLhZzTiOjPHY7a6mr0mSUjWK8c2zA/V18CTlbwDDyW4qbr/MzGBqT+8OFqy2RW/gMWeW2fNoRoGcqXCAI6eFXhDRkiou+PXI1JN7BPfpPWUQVlt1D7WJ1c7CwNOPzbBqhp8qisg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0kFI0l3AI+CvaweYaAuThD1IhYp9ILzc0WJXPlG24vO+5BiFL4Rv4rqKmuX9tCWtodIaz8SRlvuQaVk9bowF9+X3SD7W2zDsP+niRHbC37dO6SrWqRQWOg9vywg88tDopl1HadphDD3XOQVhDMcahUU+28HD+AqvS3x27g5pRgL4sbpdxZ1byvBVrQYIejQmk7x1uBnsPFfVN446IvtRWW7bBZLQpjylaXiyIEaLj45IhjY4Lppk8QMAVoxHkNsBhbLW3ooxHDl8yyYHC3GmsNYWuHxvQ1g4JfSRvWjXe5WZdc1xvyhWeBqwBOxRYk/gQcy7g5EtsfA1r67D+9/y95nXeI1D7BaQfwJGCB+kv+DGwpWcy8QivSM36uivfr6lmWgrk/OnFaNyndAFMPpcKPIu7ZLqA/PMGcbqibk6R0bwvv+s8CR7AsNkBPfB11rC0hoMcgfTDKDbh54f7E3XJSLtBzOv1P903LjUIBkSNs76VC6b8lbmgppEDm95QHN2jREQ6gwdjll+/jBjl3RQ0gNdILZkcOUmQZo3jczptc/iF4GxDaPUHhRbUbDjbUP0AK/LNWszlWi4sYcXEc+F1i0+jldG9NQTE+4LfcI6mjo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dce80e25-0d44-4999-c854-08df29023f48
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:16:13.9839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mSnNN36h0j0W7ClDKPigIgAuRIZRnjpkvwKmhAJ8ubEENFRW5bmJAsZ4/9vwu6y/zARq/hxlnVZdIOKp3u1+vV71yDuEu7rIRH9aE2rIOok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acde8d1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8
 a=7-415B0cAAAA:8 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=yPCof4ZbAAAA:8
 a=t0Y7tUnTQisWX057riYA:9 a=WmVTiCyuxqgg3mnwYu6p:22 a=biEYGPWJfzWAr4FL6Ov7:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-GUID: 7-Tj6MHAkFS_7zwCVa0VhmnhUQXJAMUh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX+qqBy1GhRv7C
 C15QJZAL6j2A2yTMbFitOSDnJAOvzrMuvaO+LMsCCa8q3q3PmGVZN9Ywe6pmpUO7XQgEHZjm54+
 mgPzbBMcJcPFsH/OUnx4y2Ryxvv6lqZT/ko41p11pLNK+CDePb4L/qtlA++tCh1PJrf6jJjJ1T5
 Apb0+rowPO0cGC6WoCFfIwpDmNHJqJ18rg22X7JG0X+Gi9YiunOHQ3nbjNmFH40cksElQgxPPBP
 cjt3ijjht44Q41dn8CeLi2oW7UBdDWChUViEqJktcrepyiaDlyuX2Kx5L+Ygq6JWltMAEb7KioJ
 fKtBHBep01jgl3O9SiFOuB1o+7t+7wfNYsBezAvobpxgWjZNkF94T94ITyFbzJfG+0TTMSj1oGr
 g7SB7ysnl+E2pkQ3FVY4G0ZGNEEcHdvTqD8ZlfzO45Y5DaKPq+5S6ZIOqp7QW+7DP0o5SSnuROV
 afqRd0UlV3Tys8CVoTA==
X-Proofpoint-ORIG-GUID: 7-Tj6MHAkFS_7zwCVa0VhmnhUQXJAMUh
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX5Pg8PN5+kAIv
 yS2078if7Ln2QLAHnE/ztdDnBlGf96qm6DplQETs4TlCGAvYvZSm7b9o7erSCw2xb9UxJPeQ1Cm
 MFiZjQuSwAsjWDNaiwzBAHBRU0g07FqXMD7TXufrWt1loSBh6PeN

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 89a4bf0dc3857569a77061d3d5ea2ac85f7e13c6 ]

When a buffer is unpinned by xfs_buf_item_unpin(), we need to access
the buffer after we've dropped the buffer log item reference count.
This opens a window where we can have two racing unpins for the
buffer item (e.g. shutdown checkpoint context callback processing
racing with journal IO iclog completion processing) and both attempt
to access the buffer after dropping the BLI reference count.  If we
are unlucky, the "BLI freed" context wins the race and frees the
buffer before the "BLI still active" case checks the buffer pin
count.

This results in a use after free that can only be triggered
in active filesystem shutdown situations.

To fix this, we need to ensure that buffer existence extends beyond
the BLI reference count checks and until the unpin processing is
complete. This implies that a buffer pin operation must also take a
buffer reference to ensure that the buffer cannot be freed until the
buffer unpin processing is complete.

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 81274891036602355e72eabbb5184490f354b506)
Stable-dep-of: 816c330b605c ("xfs: factor out stale buffer item completion")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 88 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 73c548d5b593..f864e0b8a805 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -371,10 +371,18 @@ xfs_buf_item_format(
  * This is called to pin the buffer associated with the buf log item in memory
  * so it cannot be written out.
  *
- * We also always take a reference to the buffer log item here so that the bli
- * is held while the item is pinned in memory. This means that we can
- * unconditionally drop the reference count a transaction holds when the
- * transaction is completed.
+ * We take a reference to the buffer log item here so that the BLI life cycle
+ * extends at least until the buffer is unpinned via xfs_buf_item_unpin() and
+ * inserted into the AIL.
+ *
+ * We also need to take a reference to the buffer itself as the BLI unpin
+ * processing requires accessing the buffer after the BLI has dropped the final
+ * BLI reference. See xfs_buf_item_unpin() for an explanation.
+ * If unpins race to drop the final BLI reference and only the
+ * BLI owns a reference to the buffer, then the loser of the race can have the
+ * buffer fgreed from under it (e.g. on shutdown). Taking a buffer reference per
+ * pin count ensures the life cycle of the buffer extends for as
+ * long as we hold the buffer pin reference in xfs_buf_item_unpin().
  */
 STATIC void
 xfs_buf_item_pin(
@@ -389,13 +397,30 @@ xfs_buf_item_pin(
 
 	trace_xfs_buf_item_pin(bip);
 
+	xfs_buf_hold(bip->bli_buf);
 	atomic_inc(&bip->bli_refcount);
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
 /*
- * This is called to unpin the buffer associated with the buf log item which
- * was previously pinned with a call to xfs_buf_item_pin().
+ * This is called to unpin the buffer associated with the buf log item which was
+ * previously pinned with a call to xfs_buf_item_pin().  We enter this function
+ * with a buffer pin count, a buffer reference and a BLI reference.
+ *
+ * We must drop the BLI reference before we unpin the buffer because the AIL
+ * doesn't acquire a BLI reference whenever it accesses it. Therefore if the
+ * refcount drops to zero, the bli could still be AIL resident and the buffer
+ * submitted for I/O at any point before we return. This can result in IO
+ * completion freeing the buffer while we are still trying to access it here.
+ * This race condition can also occur in shutdown situations where we abort and
+ * unpin buffers from contexts other that journal IO completion.
+ *
+ * Hence we have to hold a buffer reference per pin count to ensure that the
+ * buffer cannot be freed until we have finished processing the unpin operation.
+ * The reference is taken in xfs_buf_item_pin(), and we must hold it until we
+ * are done processing the buffer state. In the case of an abort (remove =
+ * true) then we re-use the current pin reference as the IO reference we hand
+ * off to IO failure handling.
  */
 STATIC void
 xfs_buf_item_unpin(
@@ -412,24 +437,18 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
-	/*
-	 * Drop the bli ref associated with the pin and grab the hold required
-	 * for the I/O simulation failure in the abort case. We have to do this
-	 * before the pin count drops because the AIL doesn't acquire a bli
-	 * reference. Therefore if the refcount drops to zero, the bli could
-	 * still be AIL resident and the buffer submitted for I/O (and freed on
-	 * completion) at any point before we return. This can be removed once
-	 * the AIL properly holds a reference on the bli.
-	 */
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-	if (freed && !stale && remove)
-		xfs_buf_hold(bp);
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
-	 /* nothing to do but drop the pin count if the bli is active */
-	if (!freed)
+	/*
+	 * Nothing to do but drop the buffer pin reference if the BLI is
+	 * still active.
+	 */
+	if (!freed) {
+		xfs_buf_rele(bp);
 		return;
+	}
 
 	if (stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
@@ -441,6 +460,15 @@ xfs_buf_item_unpin(
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
+		/*
+		 * The buffer has been locked and referenced since it was marked
+		 * stale so we own both lock and reference exclusively here. We
+		 * do not need the pin reference any more, so drop it now so
+		 * that we only have one reference to drop once item completion
+		 * processing is complete.
+		 */
+		xfs_buf_rele(bp);
+
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will
@@ -457,16 +485,30 @@ xfs_buf_item_unpin(
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
-	} else if (remove) {
+		return;
+	}
+
+	if (remove) {
 		/*
-		 * The buffer must be locked and held by the caller to simulate
-		 * an async I/O failure. We acquired the hold for this case
-		 * before the buffer was unpinned.
+		 * We need to simulate an async IO failures here to ensure that
+		 * the correct error completion is run on this buffer. This
+		 * requires a reference to the buffer and for the buffer to be
+		 * locked. We can safely pass ownership of the pin reference to
+		 * the IO to ensure that nothing can free the buffer while we
+		 * wait for the lock and then run the IO failure completion.
 		 */
 		xfs_buf_lock(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
+		return;
 	}
+
+	/*
+	 * BLI has no more active references - it will be moved to the AIL to
+	 * manage the remaining BLI/buffer life cycle. There is nothing left for
+	 * us to do here so drop the pin reference to the buffer.
+	 */
+	xfs_buf_rele(bp);
 }
 
 STATIC uint
-- 
2.53.0

