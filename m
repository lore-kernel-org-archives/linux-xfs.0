Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28ABE7EEE4
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658270; cv=fail; b=WeO7f5IKPsyDP1cJnUCZ80Mh96/KYEd5mI43mo1MFeJDUjF5V2u3x5NCGPnY3E+hOh+ntFPNplw20kcNu7AYJrS2yJgM8gtVK9tXkMhBGEt6Sb2ntLpfoA1SP43Mtw8YJ7DRGx+BhzyaRpXwjyctBWa2JiSMiyDCAD0fsWS1aVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658270; c=relaxed/simple;
	bh=VvzN4yu1fmQ0VYqSjtKVezznRw0LavjhUkFiu0aYWsM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hhzIOgCayKZMGHIen2QfRB1Ujnqqm+o4EtAdTo/C3MXifk3P9/TjJifmlzgSENZThiXZ3a4nrTULiDaK84YJJFkPNXjyEhJz1j7eSk5BDy8Ozat+QXKGrxNhd6jKYcee7kUfeumjlN2BDNiSbOJoE2f3wQABPg++Rfpq3RuN2qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q7+IEvK2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=np2NaRyG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q7+IEvK2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="np2NaRyG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxZer021705
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=BlYNkxjGWSfbfZQ+XxFjmVB/mlx/td51hSe1ITYbYsk=;
 b=Q7+IEvK27HxVaNClUFN9uGqNdh6pQgMe50Zh+ZqswVMZb80GSmAVv5EbYSRwPPy/Ik+H
 ZnDllfaww+2Tpk8ti9gHAlozE+18yZM2SNkBJUy/iLXlzEGhNtCQ+TRhqPSTHSevXDFY
 5f5nM54pTmzdsc5Ce+O/hyx557U//ZizmVcqkqpEOTqZ1upQn+eDJzXdHmazjD2zte7K
 EatM+v0ZHBv4eef888tKDHKrhiJUheKVvC4FXQPPFhZXQ4/vbPzyPp2MBn3jB+Nng/Az
 VG9WXa2ll2JhkEPYGqiMM13v+jPpyQzbwgI8O+yG9GyCan26WtyZA+dDN48WYZlDikvG MA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvtcv0f0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UM0X44040253
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:26 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr987yc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3cTClpd7v0FWR6unmtm3v5nEphDACd+arQy8JCEZbw0QfJEpx5I5YRr3tRxRTxJxwK5OfXsgmXEA1UHdCWHlJNUCy+cBsklhOHPOGO9RWo/ElRaN4Bo3vOvu95WCcyEGMRVdmOAyJY4q73E/LBYIFapVXvBYONtdyifAEpQUM0noHlQ9L/rUr3Wb8ubKsRsmyF28Es58tYngfXhlv/CJHT3pFDiXhWaMiMKf7Dbrfo+OYbC5hI/ha6B6tuNcW5UKah08Tiiy4A34da1wGdGq8wKjF6bdWRHHk8PX4ojluW7GQDTkcLZL0NqzvnnuROb4oWqOU+eHy99Ce6Wp56svA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BlYNkxjGWSfbfZQ+XxFjmVB/mlx/td51hSe1ITYbYsk=;
 b=J9kKnmX9yOyAze+uOxUmbH+BV+SUe1aZlLcOfCMqGhw7aPC25z+kjOejK1QwjLE8+evW+0/uRpA1QtAVM0YSA3oV9+jPGYBxgHmGggjurZ/yGaFn/BKr1QIiTZO988s36M9ITIDswbrfj0B9iiRoIEtg22yQkKUYxmtNPXdIsBy+9mUX2W3p4crlduM/rIwbBTffbLeEsS8dvTxCmo7ix0wcJmNn0JbH9ScEkEERyZw4ynDsLnaLEZ04Fnu/Qqi/QTsPBtknBRmt22OpZ5JhQ9Eg+GdKyTQMuv2JkC6iNUbzbg5nS3ffH+ua+3Xx71ta/1DVwBKely9b5+VKn1eDZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlYNkxjGWSfbfZQ+XxFjmVB/mlx/td51hSe1ITYbYsk=;
 b=np2NaRyGRkjpKogGZ9SNjmJY9XrTf2MIZczkjkywBYVSFbcqmTf5NkQoysiWvtwvlIqnUFNUaeEu8NeqSSAfCuujv0BUOQM4fHcW82K2MQvmnCxpJxrO4fCaI2vQkwc/C9rkPfaH4DsrVv/7XxXvHln2WIr4V6Sj1y9kahs4o58=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:23 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 01/21] xfs: bump max fsgeom struct version
Date: Tue, 30 Jan 2024 15:43:59 -0800
Message-Id: <20240130234419.45896-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 461b2ed8-a362-4fa6-aa84-08dc21ed62de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	BmxV4f3yDjbwt6pBi0sVzrcAQRXRwTAZOz/mfIgv50eFW9g3nfBr1MvTCOFcKtBWpE5RVekC+6ale+VRWMs8fLUknXJMBXJEVy54RMxgFE7VplS4GWfTpa8XzLWdGeKfhBDe+1VPFih3fvi2ZDacG0X47U+0oBt3/UTVo3YfXkmqy9LuDQuN0thxFn0AgPExsDAzJ9DOyWmKGjRE4FFyP6FQ75NjsfXGSdMMeP7NVjfqbCXn3+PSZdTtJCoixGKx/V8nwYLkDkw4gCRB4jb95+envxPS9WBHBTJib3a0As/sbiFnygxokxBL+r9QXyPqfwoXeE/eb2zTvHMRu3FLLMpQLznY3/uJQE9XEUiGBJCleA2QMHQkU0VitMKg8Cd3tTna3akbje0WbV6I3awhMnJnJhe/1cRROouDu6yWAbns+M/6q7qOMwB3LrvvqYDOui9dTVF3WfeDWMbRJ3x8IF2w/N7w94TM4kPxua8GFt4Gw1Ss8ON7dkVcxgLHeoMtUQj/y9UJ9FxgVM/uoix0evlX+w3THQHnLW5hn1bmmsiS6n9Pu9QjOLcwZ1TrnDwn
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?jAk5rkJESa2xvTtVIU6qgynuXWIIJbj18HXlPQKwwbqms0dDFvUiXnksvp5b?=
 =?us-ascii?Q?viyrq1qxYx5lypbdz5WOOgGCxV87Waf2W+mmFIzKsZzzAf2dg9G2jPxS273h?=
 =?us-ascii?Q?Sk3pZekzaazMEYSnJCxHYNdAjzIyBAsX0DGANR3/70hi1/ixsh9clRqZaVHE?=
 =?us-ascii?Q?mBSwlrcCmeR7mK9kd1Q7nVqUO0f+WGDvUoP5Cl+0b6H6xvqNVPJa8KTpbHKe?=
 =?us-ascii?Q?nioZBYGynHIVMLLMD68EyGy103PztxochOzoqEs1XS4Z7YOBwauej4wQlwvm?=
 =?us-ascii?Q?3afa5RngEAuqvoKGk3Wi5iLN+BHNC6s3rPfUqp34z/N/4DWDfzp1ob4Jrn/k?=
 =?us-ascii?Q?8iAfhS3pLz/MIUdUHOjQ4IEXDcKM4JqlxR4wMuitvph0cRnPCVjJmFz2YqnA?=
 =?us-ascii?Q?5tdrZl2oJSVu3Ao5aSIyImh0VFa+BRQfdip//+hLbfql6DB58ozmA4mAHdDJ?=
 =?us-ascii?Q?JxFZ2Iz638uo2KhJk5Bcra4dN6w9Sey9lK6UsRa+Ot+1VmE1gYfqQEjCu/y9?=
 =?us-ascii?Q?RJP7tpW/vov5UuQMuXYS+x++s58hMAhqBbZOP9qDfMFtyvQ08FxGLUUzyaC6?=
 =?us-ascii?Q?gPZewCWwO0U21VeFxApafPPr6cOwOVsPOnLVkEks+HNFvYKDNXn0eLfxhjLr?=
 =?us-ascii?Q?n6HbCKHw6RZ5A32WR+vjB8aYe/tX5jrZd1fjtIs2iQzV97nJyRQC3+Nu3kOS?=
 =?us-ascii?Q?UPrhHVlG89vd/KFJ7jj7Xo3pUG9qXLF7+V0pt2woR+Pmj7A2d9XP7vsm2VGY?=
 =?us-ascii?Q?XMTKKHXz4xr/bA9AQLDGwNAEy6Almdz65cVM77GLBMc7l9gg6gqVX7SHVTo+?=
 =?us-ascii?Q?BJeI8+e+Q1rABdsFMytiTEhMnIWuMnUK37sQdOeRkfEcn2Vn+bYES2b3iyK5?=
 =?us-ascii?Q?vMXKHbNDU2w4WWgjjNVdj8rba693UE0M9GDbSb9ajGd4ejb/3wrN6/1ss6nF?=
 =?us-ascii?Q?qT+Az7btCTk/bKfqlYmUU97yudWsi9MVmh1JTAVZdX17ntucy+/KSRHB3Znw?=
 =?us-ascii?Q?OyZ4zRcQcUCAN8/s9CzfaILDkuzwJK9xNc5n9lbtK9LzjrLFiIbo+xjs/N/L?=
 =?us-ascii?Q?B9DsOrChmx8v3YlR6SgIw10BzyIceazyxv3h9VRT+BwcP98e5Nvt3g0PlHqz?=
 =?us-ascii?Q?dBIVhGKeGmQz4OIbLHnRgbxuTFaoO9SGqbTrFzVpWWq9yvmyTusn4PlDUmAL?=
 =?us-ascii?Q?bVny5qcTzfLnnYV3GToEOfs4FWGO3M3rgboyZrl8AYlSyXCeu+EZLo/XRROL?=
 =?us-ascii?Q?BExwh2hU/8ZtpV/2mz0ZlGrJ6teNagjhzAUJr4Lh96wT3NkSe0lcUFaKMGLF?=
 =?us-ascii?Q?mV8gFeBN+7hZ6OCpnOqs88MFa40+yNLBn7aDp6l5X3EbSShX+5cFD0HsXRt5?=
 =?us-ascii?Q?pxYdikOtT2E/FO5nWjPK6f0RLVAaNq1gUG5ZOM437TlbvGaGznQI9m0gnG09?=
 =?us-ascii?Q?0T+UQ9u/lB7l1IReo3zlqQybSHqFl7koh+8ahCCOPXXru+7E+PD1tihLGX9D?=
 =?us-ascii?Q?2LJRtwQEJ9ney3UAv03Dt/yVUSUT3eaA8uk5eX67AJi9H/XPQ++ihxQePtwD?=
 =?us-ascii?Q?BWtDaaxPfw5H4J336gAgpRu84DNafrDBf/cF95uFTNddbDlx5eN6NxvlVOyb?=
 =?us-ascii?Q?dkklMoep6qPCMX+C9E/9U53BXnqkpqi8zyDw90RrpnpP+j4kLBdeYi4kj5ej?=
 =?us-ascii?Q?Z1ryyg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	fNGtCgPLLN07xhz6QHJ+UVI8jMZty3/B0eTg1BlV1nr4pwsuadSdgt5GAwnp4nQjzf6jp6R+CttU+GIocD90lQQXniz0asLnDzwXLzA4T9gpLgPO80GsaBQd7+zTuZdgHJoimrbr/oYSR8nCRZxcpAjg30k9Ds8nonMpeEmpc9UhtQ6H1K0U9ZsVsSW1vvv2HDpR3cq4V5xs4/XX0rAD6TeE4GRpmjxjy4HFfyGvYVA1qLQr3hd8G1hENV73i/3h99KIabrLbn7mrgcqvN+2y9CYUY4cu4ePp1ejWpgCrSoeSwp9d+oWB+o5xaAaptQvQAXwYilb0yrLUgSw2wDZVJiuY60l4Pih99+JZDlTddDKEiYI2UHKA1oqBhxyI+jOBJpKIApv8/DgbsExYi+jPU3e++Ivhn22AyEN/LT6OgChihjs9+8+3yHJH3l6Xt8bUxkWrNl+Dqds9y/ABLH/yA6+KVChAbzxfjiZT7EaeZmFhT06EkbDBxlubJtnM28j8UboAQNOGvMKEyYm6kSeDKK6lytU+TU0G6TEiVdMyvVTjkI3P7iLlwptXK6lDrhHPP65vAaLE2TtjYrejK/rM72blYCaduyFpDqHRQpDor8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461b2ed8-a362-4fa6-aa84-08dc21ed62de
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:23.0659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWRHxld/gMpTMsE4pKNSh7f/65pGGV4nBVtdjUwWUGyBFa4LQ0r5Gzol8o7hkn/vsnzyiP/Ey6W47H7fcYkqhrsbs3DHZEoz3SseIRv4TNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: YjM0-NePGx91wHjOdxokCEKzXAWcunkJ
X-Proofpoint-GUID: YjM0-NePGx91wHjOdxokCEKzXAWcunkJ

From: "Darrick J. Wong" <djwong@kernel.org>

commit 9488062805943c2d63350d3ef9e4dc093799789a upstream.

The latest version of the fs geometry structure is v5.  Bump this
constant so that xfs_db and mkfs calls to libxfs_fs_geometry will fill
out all the fields.

IOWs, this commit is a no-op for the kernel, but will be useful for
userspace reporting in later changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index a5e14740ec9a..19134b23c10b 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -25,7 +25,7 @@ extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
-#define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
+#define XFS_FS_GEOM_MAX_STRUCT_VER	(5)
 extern void	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
-- 
2.39.3

