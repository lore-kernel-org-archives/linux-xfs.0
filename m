Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2325464A;
	Thu,  8 Feb 2024 23:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434464; cv=fail; b=lUlU7qRUKDSSnvp01jdTAlxLUupfAWfaG/uyI+0WFvT5w63j7Gw0C1vfGNL/hMT8ZEzxCFspUxQ3WNBTVZlkMdRqJi1WBQdP9s3iZr44oK4e63+nMtnWogm0Wi4ptRe2Hg9L2CHSMiLGR3EAK8kXV7wYDadqSRarWBxVuHboWPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434464; c=relaxed/simple;
	bh=l+qNfDxQ8c9sUWCHYr5fLQB5cbAvwqmgv966PbMew0M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nwH/483KkQwVH1CCB3+Wv5gew5p8JElM0hdooUQJns3u/PRj2ilN8N8PXyxGqSg1cu7vA+Ddyh8fL1pYTcfj6BOPKnZ3Vi7wjeh5IfCfAJ7VeHyJsv4YUNV7IjAG/Eu3soFpnmYvlvwNebQ7t2CBgBR+YUM6GyQTvEdON1h0miE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d0IYO0HG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nzY6yGkL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d0IYO0HG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nzY6yGkL"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LSqEw016686;
	Thu, 8 Feb 2024 23:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=sZy8NgVEjXiYX0Fz3kPrQr+OIUBNWhD5EybtPWoFPSs=;
 b=d0IYO0HGD/AdDjS7xky02bhh1eiKyCfGhZ+6D40y0AHDlKoqtOlCwGljZwQAdLELzkjJ
 +LaN+1aNzsQmh2kNmxy5MXDUekMW1anrYIhJCb5YX4EzVu1W5ai3ErQ/s46Lu58zbQl1
 v+1xCCQa7nRnJi91C8IpwKgmb10LPhLyPIBkGqzv0ucb5fi8Z0XwuJvlJffi0nZvYND2
 3jJew+rQn79GSgL4utkg4sjlw3PINBatMZX/+JQ9hlfZqquRAcTWMjoSAG4NddwH7Ut/
 Q2CjAeEvrm7ivazrhc7ie0rHB4QMKcamd6CQ+59FDHENzANZiGeD1GzgFcGgwQboH/Hr 9A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1d3up3xd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:20:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418Lq2or038362;
	Thu, 8 Feb 2024 23:20:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxb7d8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:20:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJtWhaMZ3AkTjMDb9cAkBzirsndJpPR4aeqqKB0Dk5SWW08u2AvcgROMS1JwlgkWG7o0apX/lac596w63CNxH2SBfjIizQbkoPVHrOV+Ws4reNp6QCA95BIMrkyMrqDkFbcxaxb3sM2r1LhIEtLjb+mDhacJO6kgUYAXpzCzQN93DvtKa3XcMBmQrqAfvskgQDbBv9Ur7u7BlZFuIRmilMvAyiX5XSbAdSgj2ANCFw8RY8TiRuEbkf67B+BWF7ygGBzezjtvN51EMYLrtf4Zz1BwNShBMqVEr+AB+1XN1mHOudxaea6XMwUIBkShHBAFQNTln58x9IT+YZe77CTuGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZy8NgVEjXiYX0Fz3kPrQr+OIUBNWhD5EybtPWoFPSs=;
 b=av1Jr/xHRNoj946L3uZ9vaxx8QfV2NsyxBHFlGO7XGigEw2YnX4+UMHqlnBCPQ9hdoXIWMOkE4tRLvybp50+7DTKVPbvjUSjZRfDJFY9GgcuhDAXUDj7hlH5P0qu4yxeusrESZT4Ava3JTgqPRroR557FnQuIf8czEoJh6jhXX3tyzLM8MSfDt1Rdyb5WbfOCQ0WcJJ9gbVT4QgbEUGO4oNKpEPTv7uXn5YVV+x4v508O5SW7DqR6SqPcFMCdJBDWBkAlp6SDZyOQHy4MnxHqyfQc8XlOnvu+rQABjSSib3hKyffCncJIF5PZOJPUvrzlLZcWyYSjqXJq9LnzKhk1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZy8NgVEjXiYX0Fz3kPrQr+OIUBNWhD5EybtPWoFPSs=;
 b=nzY6yGkLhTSKa197f+HUg6ME7bw+f1AAtw7bAS2XfSEPQiSCTu0dFSMLiYnEYUBaJG3Pf77Pr83RTSrRcE3NQwIOCHYbFmJrPqdqGo2dcnAVWCczvuTZ/WpESvfR/3qNqTyG5AimnOkXu8o5LkuujctLZ/nAAOlTioTHJn2hae8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Thu, 8 Feb
 2024 23:20:58 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:20:58 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 01/21] MAINTAINERS: add Catherine as xfs maintainer for 6.6.y
Date: Thu,  8 Feb 2024 15:20:34 -0800
Message-Id: <20240208232054.15778-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::10) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: 0602e413-ced8-4ba5-1ad0-08dc28fc9b25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	CSPcmX4Ob203OJgVL/MezkkFcTcH6KOofCzvC/i5AfDvSZmJCOvGpCghbU0L741OExtgTJxCd2frFCO7VRws/hMXUtNanTOUREYdPJJDRdFfBoTUGd+nMBbW+6z/BLsthC7202USXeGPVOV2dPR+gzFYhd/u1wCqVKwyAvmdJsLNlOZWY03Oc87W0w7aE47G1b56zZwOX8oM9h2NRbLm9lWQZ+nJT6yPLqvyy62nRVf/Gu2nihaTdsK6p7pcCN3fWFAf1o8Fz7JSzl8JqXqaWU99dTAzjtyz4X5t+3bPj3Bgrg2Cxl2BgA3VpDglabnd46sNxN7rfpxQu7oCYHrKG6AvcePtxYx8cT70rbz3UadRxoeUkUPhqzCB3mcyIkt9zHKgqMr2tAySmQJ9bFUynO4VsB/Jlp1kS3JoHOhL59mbSz4V2whBQCdvcaFEH0APkdlPjF+pAqSw2mjVKwOyatjo/Tj6owAzN7NUwge4WSstiHx2YYOq8ns6JEthvjjVvS6juVriGZRAne/5GIL7Gu46BExc1UQ0WjFPiHB4uWVISUDMxuh037W2aUvp37md
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(376002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(6506007)(4326008)(450100002)(86362001)(44832011)(8936002)(4744005)(6486002)(36756003)(5660300002)(478600001)(2616005)(6512007)(1076003)(6916009)(66946007)(316002)(66556008)(66476007)(6666004)(8676002)(83380400001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ulvM4in8O+btYRF7WHctcEoBP8Zpy3gCv8/pC7rL1m2O62RbkkJ8KAm49d33?=
 =?us-ascii?Q?tzPsxmrqRQgotGs+1f++4k5Q+1IztdYqReWZazdosl059M+qYNweU1+WB+74?=
 =?us-ascii?Q?MThjRkUhJ+t+q2xElpSsczCZ3LR3qp3+rEh/SaJ8527eFHeIiBAmi7OsJsRq?=
 =?us-ascii?Q?cstn0ozCIe0JBdv+N57h/ogRjw6U/QhdNrHMR2UWRFKg56WBchZQLxAQib7P?=
 =?us-ascii?Q?2aW2FSzIUutHhW7crd4OTKrfZiG/NgvmJi2FpcpPUQgMRsWt8AMHyrwYC0Q/?=
 =?us-ascii?Q?LgW5UG20PgZRn2A3t0aVR2awMh6PbC+pzySXstB0Vm6vorJvvifRRTP+Bom/?=
 =?us-ascii?Q?uKN+68ZDOYv2uo/CkME/XhBgNBlO7KrmRSJAWT5ZCatG239zZ722AOXfxnsj?=
 =?us-ascii?Q?tFgoLW6OMosSFAWXLcZLVQw0MFZllsirE+unc/7nT7f0jSPyryH+QgHeSWIz?=
 =?us-ascii?Q?Sh5ibJDwDQkxJY8bbnGMFY3hS5LFJu7FWdCHuoPEPC6pwGj5NwIWSeN/+F9f?=
 =?us-ascii?Q?zui8Wwn/gbmZ1XuXJ6i+TMhuFc5F5lIGOtNSuKakUaJjI8h8aL8loa6sxy6x?=
 =?us-ascii?Q?S2gn/x1Dm7hMcSTB9GeAfjPk2UHNb4ChdPOpr0i7LHqRylNOv5HCAGMdDTTA?=
 =?us-ascii?Q?gNTy6SCEZHpf1tODVw5scNVED6zX47tKYvpVz+TBZMZU+9zsTsGdhLoNPMuY?=
 =?us-ascii?Q?88rZlNyfEWrZGsrG+OhVbq57xW6o8jqDUEGoSnXfU9HPxkh0egpi/GOKOdrE?=
 =?us-ascii?Q?FgAB02jwUpToCQttvpMRffCcdobNlNhfiyejQuYoF82knJ6+RJDQhrp5y+Xh?=
 =?us-ascii?Q?5+Kil4k0JrWmAZnfsrPD5IZXE3OCSja/acTbkHaNNCez54AS1Y2Hny8bYbFa?=
 =?us-ascii?Q?8+xj9uR6DGZxQXlA2n2Jtfm2n6e6TMCFriqERzLnb8J1os7bCRNZ1t/MAsbI?=
 =?us-ascii?Q?+ru+AYTBik1lTX0E8/P89L6LkXvmfT4Xh/U1mxF/7V7cA5OZOMD0myiyAWmc?=
 =?us-ascii?Q?zZLaKCte5aG/c4qESVEWwGqTEYLm+ym9FXsKvXL0xTRuTBPuCw0bNpsWEEfk?=
 =?us-ascii?Q?cFvffnIyZEr8GxgOoQNoAFtomBUyh4bs0jOMchhMu6bheLzekERBOgn+lCOA?=
 =?us-ascii?Q?Dk95uPYMX0B1LiXQ5MPffPWL1YmHQRcaapktxvasijiOzRanA/KI/kQvU0Ni?=
 =?us-ascii?Q?okutT8rPlg4xMX466tyDlyWMg5j3wbxcYSpf9ywX7XQ6sw9OLL9f15dutHiy?=
 =?us-ascii?Q?hp8EtVbbfBPx907wcAhwPCd3aI9Upfm+litj2TtXNni7D58ggtTSCWxMxJa1?=
 =?us-ascii?Q?wNTX0+v2rEsMKseDkTOrQaLRUwpz5n+P2ML3v6H4Y1aiJ92MwSn39KH1qE+n?=
 =?us-ascii?Q?iN+c2/r4X8O7vgJXKwV7z9Abn2mNLvDvrF8Oec4xLPRYbTQg/rGgExy8MhJT?=
 =?us-ascii?Q?W22+iGQOHIwgz9YS891qAocv5vp3ZYUIPvWRPNgZkwr/z8m62YlQGueScgPy?=
 =?us-ascii?Q?ZhBowJKYLDVwG4Mr/dTZqxYnQ2RmOnz6ByqE8R0S789DvCInkJmQ52nZHplU?=
 =?us-ascii?Q?q26o3KKIPAmvL8ZvfmhuL4Afj9weo4iTvI3yP7EheS5FEdVVaAb5Y2Tfla5g?=
 =?us-ascii?Q?oQJMvlvlFc1aHTMoCpILiB6cA1dK85gOZ7+12w6DKSLEV7/aewfQHi1PCJq3?=
 =?us-ascii?Q?sSKilw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	xKxzzwQ2YJDWgSu8IjR4O8vKDrMUoedTzbMfpKHatA3ABl9ICLXD56EdEF1+vb1wJyCidZ0DxWLidWALLjrWLSa29m1I2C6Z83MljYFglB3G9YI+G6QZ1oI5dwHxoNA3mnTaoBjShtzWjtvqC+Or5EwPKt1Tg77vwgeL6Ee72sRnPY0/0uNR/5tE08liSVzHH1/eWSDa3yURikuia7KB6PnR241zPWNXTOMO1c6HNlnsKVHHYXr/Yy3bhX4juO8eDNyyDEMRQtTbpV1M3aHVOND+2MUAZRa5zEEziLfTbAzPVmGxMeJKcUMGAQIeowEUi+g1S0TXIYnsf4JM7M8wPo9eFmOaCTR/5jsOTTWOZJKKuhdEzRw6NX3GEs9xHwkntYT9f5y9wIeTL0JCP5lyei+qebMgMYhKjgDSe6UypEvs9LAY8+kG0as4hP2MWocGr1QdYdQT2xOOECRA37fUcoT5/SiUu+YvUSoHXQkaM2cgu3Nj3Bre+zrcQheHuK6iMjpclfhgSGz9SNmDzOks3kMVdaVndDBOMTWt5OGfZJ21Q8YrgaQxr/YeXPJR7VIRJm6gWGnIBvVE+8oXv/kXVSC5YFRJo9TwWyVBmsBDVhw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0602e413-ced8-4ba5-1ad0-08dc28fc9b25
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:20:58.1292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SPossNSwLHpUAzEnq46K0+3ALeD3cte1AH7S2aXkO9l0U+gKDFXPU7SB0L8Trat6PMNlcU4zoc21332VWBAMvXftnDw9qiC6fAPvE+gNwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080132
X-Proofpoint-ORIG-GUID: uKCZZoYbPJ1HnJaoDUkK9KvTPAQKhXlc
X-Proofpoint-GUID: uKCZZoYbPJ1HnJaoDUkK9KvTPAQKhXlc

This is an attempt to direct the bots and humans that are testing
LTS 6.6.y towards the maintainer of xfs in the 6.6.y tree.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index dd5de540ec0b..40312bb550f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23630,6 +23630,7 @@ F:	include/xen/arm/swiotlb-xen.h
 F:	include/xen/swiotlb-xen.h
 
 XFS FILESYSTEM
+M:	Catherine Hoang <catherine.hoang@oracle.com>
 M:	Chandan Babu R <chandan.babu@oracle.com>
 R:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
-- 
2.39.3

