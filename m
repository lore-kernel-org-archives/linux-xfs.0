Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DAD52F9F;
	Thu,  8 Feb 2024 23:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434481; cv=fail; b=OjzM+A46iwVA4EswGnQYq7Jq0I52EQcLu2I36r1MkEiNMO/NImwPxTPMcLdtmHsOPC3Tj6Ye2BOcZoLlRfxvwWI8zJszUU0jjkYmy4EHoO+wz1dJ7s5jW8INesjyholsqPNBHjISYawKmTkmn+4ZWXec1PRx4ZC7An+gtXuzh3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434481; c=relaxed/simple;
	bh=TxWnesHOOYZ1jGXPj8ZqxzF3SM6d2TCMounvMSz+JRE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X+IMiCCRhOPvFNupYz7HVG1LY3c6XD98itpHB4p6QaYTDgdlAaEm3GkXX7i7MMmSE+FMiNVlkTo817esqZZ+kEijYXaTFOmXQU2z6QhnZJkNHyyAnJdKwyCWVfs7HOcxa0kCHVhdiqXoJuorm/9SSY8NMzcvhgcOEPlHI4vqiR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oT7HN51Z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xYVcoNUU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oT7HN51Z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xYVcoNUU"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LSqF1016686;
	Thu, 8 Feb 2024 23:21:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=+GB/OA081lSw4gj6eGlYU+gYBS53UBiWP32rROhOZZ4=;
 b=oT7HN51ZSEyXXIw6OaRQvZXmXHoaH2f4qKyHUNx8bhY0sgEo/zTSYocZrICwt87rnA97
 eOKGV7R7kIfzodS2Rwfk1buPJRBjoK5DNpWwiNqDU9uBYKhTHWAE6iBu0kxPiFCGaSVp
 BQ3nKCU6i0kqqenKaA2EjwNHLfNDta/HcpSSQR6v3X111Ni4HYdfiIfURngzX4MRST8j
 qgdXJ2b6zsFn2QahZoALFaIn2lJtTT/DEz/oGpRUT7Kg3mlrfaG0yuKfzIyy0+/vsvxZ
 HzoNWK/zB1DPZyBHfpR+73wKM5iHO1/vqyCnU7RBKBDNw3XOhzBScWC6sxF7Az+QsHN7 IA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1d3up3xs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418M2Ked007105;
	Thu, 8 Feb 2024 23:21:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxbtgac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/NLCjLs0ELO/GMtT5zLVhFjTJRO0PYU8Sh3NwCrNx8jtf0ZK2lvDInSphCvPRNSKz33zUc8B0bKOk0xNFIp33CR1O6LEDkDYhY37t6f1afB+hcy7r6dQRiM3/+0GyowVCGmscxMjg0kUhhCiX6O/s1WHGygIHMcE+j6WaDidROKgcDD6vi6GNym41Bv/parRMOFHNl52KGWdgbT0pYbYS8mZnw/RfhbucH1HzhjjRzU4i+sv31DCZP2xFHqqHJ+KquiMFhfLw0Dns4InkXwk4fLHk5HvKSSkA2mO+aafEtV8hM0WqH3nEwRnfd7r3vFULYJP2saJVzzUp6u6+pt2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+GB/OA081lSw4gj6eGlYU+gYBS53UBiWP32rROhOZZ4=;
 b=CMy3tQy/yJjsmONh2QDOLlz/WKr5IEKeJkkEz7uCo7NzrYyewIk4Za8GNwPNaH75JyHB1l4n7Jxw5iUlaYjrhtoI9xTrZxvMY6qZWLtfl2xNLcOZRwTdWykTLJBa+dqLan5x8OpyKGw7YNbwLuvZrBf8+n97DpYRaRaKtmaDNlFw/JkKtmKXvF4XvaV9RFFDlhUBdT23O4Z3+vPDhGrLS0efyC5SHXqLLuUszPSjmRHL7Rw7XyEzyMi8H4kuKiCe7oWpqWldpixTXt5iymrVjH6KEXzqSC9et0tnXx/1s3hj4mt3qCJraQqaKfXKf4ugJPuQcbnbOvhvMjoD+piJfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GB/OA081lSw4gj6eGlYU+gYBS53UBiWP32rROhOZZ4=;
 b=xYVcoNUUHuhhUJdTvll7dejyjacG+bdXMCCHKEX0WaCAjF/jnPCHytvor6CH2YEnewwN9rzofxr09fqa1D9HA6TGchW/NTXwxScT2sBna3EzkNvZsClnjt69N1rr/AMfvFUiU3utC+qU9aqVX3yA5wMsI1QAND9vbK6MfY/24HI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4487.namprd10.prod.outlook.com (2603:10b6:510:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.39; Thu, 8 Feb
 2024 23:21:15 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:15 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 09/21] xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
Date: Thu,  8 Feb 2024 15:20:42 -0800
Message-Id: <20240208232054.15778-10-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0374.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::19) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4487:EE_
X-MS-Office365-Filtering-Correlation-Id: 017686e9-9899-4d4b-8d7a-08dc28fca548
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QW6cg+YVlWCvMJx4qGRtmiMDZ3iRpFPQNOZ76AcAeVG+Hodd3kLEEhzn4Vd3/n8QzXJF68aUydL0A8Fy99+xpEvm6SQ68QoZMTqUTD8OydS3uEjCkMd3reg9VOlEoOesMGWuH0o0MrbDTcaVEkidda5ETmwCagjUDFWGO3IAmqd9bkHggXh4yG4wlT7mMhAKsiWJEVg7Qu2ELTIMydD11D7Ni83hIvXKBcPHK45xqdixwMpm405hMv2Rnjo7Z5d5qRtziXzRcGIoJwKPtR+GzZGxC65xpdMr/8y245jByWopd9sD0CuXqX0wFaRj5ROcWlGRzSVvQtjOvR64IIYNWugZfFyjKbs72vOMXJpoZK6wxxfCX1M0ckRmA6loyJqUrIjd/Qt0ZFzcthlkJt0Y+UWYq7BISYoSpkKXiTsfn/7ZwLginFfOspmV0kSgXH9MNr96T92pZjTTNum/QKLCzYDzYwvVSxztmdEcS9QK3QXn/09B+8mUcmGgVeWrQ1esxfeT7o4/ZwFYlT0t6J/wiPqoVc358/ZT9JOBo/t0sfUSZ4bT5myJpGuHrFI0gTtq
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(346002)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(6486002)(6506007)(41300700001)(36756003)(66946007)(66476007)(6916009)(66556008)(450100002)(6666004)(316002)(478600001)(4326008)(6512007)(8936002)(8676002)(2616005)(38100700002)(1076003)(86362001)(83380400001)(44832011)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?tY2+MOOAW1890Bvfh2Zk96gx3tsbj1t1ZJKznQgJytuV5YKto9HBcmzMq7nq?=
 =?us-ascii?Q?on5joau+yhvUhVgczF/s6sV4jEsRdkGlv/6dgCmUaoYitVp4xr7D0wo85fwC?=
 =?us-ascii?Q?t5gswobqqgihpFFTv+4naXRFXhmgyz1iQ+oWb+DNHt8uLLDy2Q6iuML07SdO?=
 =?us-ascii?Q?sGow0Ml6n9o4xkjN6LPhjzADIB5TilbFNA/K0rh/GLPfl4DpBkEZBbMeUuNR?=
 =?us-ascii?Q?+29zUYuZCb9wwSHo0q4UQWa2DCLqYAGmv2KmndgCRuPduwQtu/adrCyBkVNU?=
 =?us-ascii?Q?JwiLFTNKUvNjnpk4GzogeOfNE90YdVIf9bUMfCjl8oEmGxlH1JnT1xt3UlLF?=
 =?us-ascii?Q?oIE9KvdbLZtM6sAtkHvy7rjo7VE5quP1sh+8/YdfDI9b+PhGndErEaU4tjEM?=
 =?us-ascii?Q?XVwQKdyB27yUnmQ3ONOAuhlMwHVATUIxGoZ862F8H0bqVmRSDrhn0SBKT0Kd?=
 =?us-ascii?Q?AOxv2XxuSxTNU2FzYhZeeRfsMDrjHRDlxrBxQGWe5t+zu4/Zr5+De84txbB9?=
 =?us-ascii?Q?u6rvzc9knx7QCKYOtIrygCFPyHPx6ryvQTQQMUdo8KIoSyPym2aYhqclFrjF?=
 =?us-ascii?Q?RmzWWUk6QUNop+CC65vBF+7sE33ewdNpC31En82M7mrapQg2QBQ5qFurXuOd?=
 =?us-ascii?Q?yG5IVcBZ49rO9zaW1UuFnBZJ+K08VlptbZbLHpCBk+2Sft5LwHKvr+E33kNC?=
 =?us-ascii?Q?kBc4Ck1p/uxalbixJDk1GxIrtoqIpAPLDEWiXZr6qvMn07i/D9kaS4Lc6BsC?=
 =?us-ascii?Q?zy/tOaVJfrSWo2UWmaEXaGyLQSimDkAqBQhgpdzTZ7uQHxC7WoReowKiFo69?=
 =?us-ascii?Q?Gc4Kn6T+8iilorVyjLCnAaaUkBoENwanVGk98yIrx/UFlcLPp9Xu2v8XxJa9?=
 =?us-ascii?Q?ejJNWakfWwSJGq+kATX2Ti1As1SaVtvnyec24Bc2whCMxazxu4rdolmFe68f?=
 =?us-ascii?Q?HTdlUZ9PW2+KYL7P2OLO1cnNQLKPRSg2PSGVsFThi9llaCZGPjhEngDaOhqB?=
 =?us-ascii?Q?H2zIFqaOkNu5jawyDqutuRjvBEi3OuUej0jPRi+HrZZPFgfci8b0i2hkzfIm?=
 =?us-ascii?Q?5xTp0bHjrRqySNkyEsP0ROg8AYVJ49gI8pT+Ufve6tfxktoAtYw70tyyCaxe?=
 =?us-ascii?Q?n/XxxPJRCGbnommhFbeQWD4u5PBq3i1xaRaoNXO67vyeofHWGmClGlXNOCF2?=
 =?us-ascii?Q?eg+UxrPOPAipwS/oLhmoEWFmbYcYq4dDkUZ+hntVhfX5zMD4+P4CPmwslVqm?=
 =?us-ascii?Q?2sGwHb3NzjQGyKJKUeFddckQVAFgLWL1utWqOCOMQqKFGYziJx2OERp80osN?=
 =?us-ascii?Q?7/BzV2ANJuuCwPJk3dcmMHehhzBpsMnCqJ+6tE3QXPjhG8yqmlo0GiB/p70e?=
 =?us-ascii?Q?XMUkyj0vk1BZ31ww4a6wB+BtAKH7220Th7QlrR+xDFY6WatIkNURDlkW6ctS?=
 =?us-ascii?Q?X/3xZMpsBu/aWx/givB/72uh2m7sS+VPS8vpcctwzl2cq6lLB/JHidDaSXO3?=
 =?us-ascii?Q?X0wIXiHYfHKIcGbgJfTs6ssy2lUydaX1UEqFws5ggZJzjixIpna/RDlqllmA?=
 =?us-ascii?Q?JJyP+yhg5a+OFGil+0pQDiF5Fhj2erMRtQAJ5Ua0/EEJeogVhIgBA2yJ5s3R?=
 =?us-ascii?Q?Ft0PXt9GY8SjVwXQ/yKMfyh9WkfBb6ftvg26UR1b6HJYbmvFV97FUCzJLeAF?=
 =?us-ascii?Q?1jSuzA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	V5P5Mr5bqku1vtV0pElztR22Pvm5XQ4BZJR/qLYKfJjOXhPWREIkWMfqFV3Wl1o4OD6tnlzKrrGxF730YhaTcfbOQeCeVx59sLMz0wgHzq2rPwVqGpQ/ouIV3qmxWH6AP21/9ut6Ocj7yWUI/jYmj6AAommgm+V6v61t18zhk+GphEh5W5XcpxhIvX/1S3hJ/mL5KGfRSL7yjgqf9KYlSnpQ/DrwWiMWXL+yv1VexsMHSlz7/WGpAH6bGPxKAcy1f7XBXppRKAhqXg9ZUE6TGOkihLAHFTZKLLzVLxYbQ5fCQFaH3RLTG61UdvcFHQC3IbJjqFxt8snZ5qgJ9CF48C/uN0D+oKeyoTQR4NiQQ1chtfPXk95b11RaPscsIsBSNO/O99PD5rRX+g/1cediFE/ULjb0oSVBdjYs6j6KKYpm6WJviGKZUzCFjvg7nPOlfguZ/oYKxdqo42Staw7EHWUPiocoQPHz+2FQwQTqa+E9WBSE6IFgYISfw+5jrrqKp5sIjltz0I6FBR9F/q/9yEZK/omP3GMaSuHVazPOa3BZQ0Q0HwPVIoUdAYN3/ayZWj9gCHm171Cx9cH5hLZWlX9ZZuoa8FuYPgFcaXWRjP4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 017686e9-9899-4d4b-8d7a-08dc28fca548
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:15.1185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ucWlqG64pgoojJCZwcHibilEtjyfmS3+7gZD/Xk6eANtRmdcY9viOkIPND8iZQMjBgUApaI/rzQ1D7mblm6j9pCZd2l1dG9H+g/Hihgws84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4487
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080132
X-Proofpoint-ORIG-GUID: ByKy-0pNCl121ua_e0u9P7-vjqCMYqnT
X-Proofpoint-GUID: ByKy-0pNCl121ua_e0u9P7-vjqCMYqnT

From: Christoph Hellwig <hch@lst.de>

commit 35dc55b9e80cb9ec4bcb969302000b002b2ed850 upstream.

If xfs_bmapi_write finds a delalloc extent at the requested range, it
tries to convert the entire delalloc extent to a real allocation.

But if the allocator cannot find a single free extent large enough to
cover the start block of the requested range, xfs_bmapi_write will
return 0 but leave *nimaps set to 0.

In that case we simply need to keep looping with the same startoffset_fsb
so that one of the following allocations will eventually reach the
requested range.

Note that this could affect any caller of xfs_bmapi_write that covers
an existing delayed allocation.  As far as I can tell we do not have
any other such caller, though - the regular writeback path uses
xfs_bmapi_convert_delalloc to convert delayed allocations to real ones,
and direct I/O invalidates the page cache first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fcefab687285..ad4aba5002c1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -780,12 +780,10 @@ xfs_alloc_file_space(
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
-	xfs_filblks_t		allocated_fsb;
 	xfs_filblks_t		allocatesize_fsb;
 	xfs_extlen_t		extsz, temp;
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_fileoff_t		endoffset_fsb;
-	int			nimaps;
 	int			rt;
 	xfs_trans_t		*tp;
 	xfs_bmbt_irec_t		imaps[1], *imapp;
@@ -808,7 +806,6 @@ xfs_alloc_file_space(
 
 	count = len;
 	imapp = &imaps[0];
-	nimaps = 1;
 	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
 	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
 	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
@@ -819,6 +816,7 @@ xfs_alloc_file_space(
 	while (allocatesize_fsb && !error) {
 		xfs_fileoff_t	s, e;
 		unsigned int	dblocks, rblocks, resblks;
+		int		nimaps = 1;
 
 		/*
 		 * Determine space reservations for data/realtime.
@@ -884,15 +882,19 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		allocated_fsb = imapp->br_blockcount;
-
-		if (nimaps == 0) {
-			error = -ENOSPC;
-			break;
+		/*
+		 * If the allocator cannot find a single free extent large
+		 * enough to cover the start block of the requested range,
+		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
+		 *
+		 * In that case we simply need to keep looping with the same
+		 * startoffset_fsb so that one of the following allocations
+		 * will eventually reach the requested range.
+		 */
+		if (nimaps) {
+			startoffset_fsb += imapp->br_blockcount;
+			allocatesize_fsb -= imapp->br_blockcount;
 		}
-
-		startoffset_fsb += allocated_fsb;
-		allocatesize_fsb -= allocated_fsb;
 	}
 
 	return error;
-- 
2.39.3

