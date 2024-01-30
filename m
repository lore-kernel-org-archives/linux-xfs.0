Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22F937708
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658308; cv=fail; b=NAt2sHKLirv7ICmq67zn7bAcdvLZJoWz7WbEBSzsK0YCaXzaS4diE4SMBHTZ/87WyVXYc3AUTR2ky0rRFsZbVWGaoy7WYBoRATZAJEAREUtClkWSulVVhD/EFH1nSlhv+WYynpm7wVcqfgNF6PWiEWAnU+evovV4uiKU2QI2Q+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658308; c=relaxed/simple;
	bh=fJQMYeHpM46rx1GkP91J1tURhIUBidwM1I0ztO6eHwk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sutbsC69bVH0CoVlNPPPLF+DGjEQ8JP9rbreOuDV+YpoX+ir2+0DjYPl9nTo/EFPxll86knmw2jy4E0uD8v4G4ixaeTIkl0CGO0x6vxhpHmGBrlkxmM6fZHxrdOfMslcc8VCD8Y8ZvrtmlvOO95JfgSPMjUiJe9rFPFB/CeCyHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SP4vS0qK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gvxLpIEG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SP4vS0qK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gvxLpIEG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxaRc021724
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=91vsyMjs5hjpZevI69sB876kEobKPRZPm7CNhfsFUr8=;
 b=SP4vS0qK7eOe1Npl3QCw8NUmEN7ll2eGuZXSfIqgrat5t6khWV8mRENgS35yQ7wPqUxv
 oVabHTiAyHCVdjUi+cGlX2vofhvu0abQC2bz9CX4WZuSadi9CoBDvadYMeqCgK9efpyM
 YuGOdciY2Qx0TOC0hFAIXhc4kYSj3pRLbcBJNgBJFkUba/NfsXfI7zOshNpblsG8k2si
 9KhyVsY4DRftV1t09G8H+CYJXGhTyPDaBRMni18ilTmwY9UNPzjZQpcmcnBvRMRh/pYT
 toJXOtlvMgMxMAC59QHMyd86zt65gUbTyM1qKbbBZTZNqGUc9iTA6ozliZPzJEgwedwX gQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvtcv0f29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40ULbuWH014551
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr98015r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALGtRd95Kv4QCR65vC6lK3e+KV8vZqHIoqLHQBUEXbb5Oc3RaWuE+g2oCH9o2+d1apk/5I37UFaNpjYcg4w30BNS2N63lvkOUS90sxzQbiRyyStXuewEd8qXYNsGhrifUlq48bcqfH0irIY/Plb+nJtOFQ/gsQxfvvvHUDP1l5V9byNEzlE1inHd1dzUd8/5C6hlSqkjb17kgL6ePCSbEnX0szCYi81/86r9VyMdHWM6n/i50cQIXFVfa+cJNTzYV2IQ+hAzXIui72ke5WmuHtO8UQP2cpOGVAXJVr8PPAnKF0wscSCXne6pIez6wv59fRgo4wWxk7Ijk9T/qgYEUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91vsyMjs5hjpZevI69sB876kEobKPRZPm7CNhfsFUr8=;
 b=V03Kx2dEv0Dvy7P97xrdicq+6qrXnTCmwWv5hEFiBZIggO5+8JhO1tcj3vE+GBwfBNVCS4yoNBxQ/WTTNR5naGpq2inHCL/VlyKkUgxczjAU0hJrlaqUSgn8Dn1rqkMJnzm4n/XBQPeYaLO+wCsS5EpLixd4EYHUqxSXDM7fM2JXZuFqILfuQ3Xjx9sPmtpQSMdcI1U/g1I2zP4L5drfScHwHJY0tEwFVMrrIwSyoWRwbzi9b8xCOJEGpWNbIt2EaL6gE510DDQt8uhup7O5870gHS6cWXko4YOe1c41Pbi8eHzQ11CE0L44THXZ3qiS+0TViiAT0QV4Cici1E9Cvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91vsyMjs5hjpZevI69sB876kEobKPRZPm7CNhfsFUr8=;
 b=gvxLpIEGqG1BZ5G49yDR3mJxqBxesXsuQ57yo38zrUfpI1sGOKfBnvOusFfZBmxBKjOcwcE5YidaoG9dVFYZsaSThmeF64yTEid4LTR7aOkYN1ekjLNM82J+HFm2jCDMP9a0he5Qb0V2Ev8IE+cHmgmkzTRqkvfjpb4kRNGoVUM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BL3PR10MB6092.namprd10.prod.outlook.com (2603:10b6:208:3b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 23:44:59 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:59 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 19/21] filemap: add a per-mapping stable writes flag
Date: Tue, 30 Jan 2024 15:44:17 -0800
Message-Id: <20240130234419.45896-20-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:510:174::21) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BL3PR10MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: 4be87d91-bf80-4aa7-d25c-08dc21ed78ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	MHxLX5baGuQ9B5cpDAfzTqe0EfIv62p2urr9GwhbbEoQL9jp+caURuaaBmg1khc+y8am7iTFdaVXq4gOAmzXrQX0I8P1ZPeRMZC5Jq4/Vtl5UwC+O8ECS2P6woW4WWDJdyrsTUQKIYOW+9MGeIGmd1aJIMLzHisnqtIUMSQVR0Su0+RJeJnrLZc2HCFYbqiFdABQ2aDaSvEjNtCJv2dHeOQUJanZn5sc+1ihGLtaomfcfCxNuBMMmHWn2RYf1AuD7I5z0alqO6nO4mVQG61tgoMyQZXjWN2fvcduNPYGsu1De5Ks0QuX6YkouOMZ5z+v5sb6eAxlAT3qLo5tqRp1khmo9HuOXVL1S4GeZZHchVsg2binrGdtGif77H+U72ekaDdo1zbM4x5252ZUCZ3oMULn8kZuqCGjJJJSs6xpykTfaFO1JOeoa/s586hKbiUEI9M8/YqMURbbJqCdQK9+nC0PdqyNR9+87634tsYvjARR7c1/jec8mHUDsGBsg3/d4TMVsEjXtvzloEYs0K7y+EqgGfzq96FC3AzI9E/V1C0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(41300700001)(8936002)(36756003)(86362001)(66476007)(38100700002)(478600001)(2616005)(83380400001)(1076003)(6512007)(66556008)(966005)(66946007)(6486002)(316002)(6916009)(6666004)(6506007)(8676002)(5660300002)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?y6U8GSyLvEXU0XRJ8LwkRI46FQ4q12LQKhjfRNgHgru9j3LCCdHuHinY+PcX?=
 =?us-ascii?Q?lXRZVk1wkUAytcBro8E/aeSI0pylO7Os4P82zO0CuFV0jp+UdqBgv5Ck1Per?=
 =?us-ascii?Q?igh7nrcXOigQN7TNeAq7OxVKj5E/7XLt7qXHEajhCRGtOi67rIGai0hYskOM?=
 =?us-ascii?Q?cuj6QIJlfBxtKyfs7GDnIrAkK2tsqrQCji7KwDmoehwnDZ1O/k8fEvfgYh30?=
 =?us-ascii?Q?vCZzqgYtsFvJUKvk1Zl8BcUq621IUS9E/uDgUYFnYhqCg6FOluv1+X8h10TI?=
 =?us-ascii?Q?HUlnfsehhuFhZU90BXRO3jjDhIH20Yak9/1IPzjUnfqygepTuz0wtm0WkYg4?=
 =?us-ascii?Q?P5s2XxoLMOyvmYnviA8gqQIb99CAfMw6JwyOEP+d3HhCOixTKDbqI9KfxaJI?=
 =?us-ascii?Q?MT1390r1n0Ga778s12eFRIpBvqmik4C1/vPWcCQ7ZeIyuyqv66iR3xdKZ0vU?=
 =?us-ascii?Q?Txdb3F8Gvnma/22SkfsFMfkfvMHzwahC9bEuugdNalRqnsnJN8xZwG01uPpE?=
 =?us-ascii?Q?MiCtfcCUwiDtgcNEGmPjUkbupvhEnsGt8OU+jQFpzYDM9RNiig4tQeL8TiIg?=
 =?us-ascii?Q?9V3HYIg8B/z4Cp8g+M3Hafz6T9JJ+F5TUmfitLDRMZXUapq07vi5qZRxDgrl?=
 =?us-ascii?Q?q8Mx+rJX9feCwWvTXRR0fhDSbRS0cjSfCzsriJbDmYl/LK3NihT0efHO/2HQ?=
 =?us-ascii?Q?xAC/FFdEwOh8zMasOy8owTmf4tFHCCAWfZSKBXaUiw1aB+pxMpIT5EBLmXPj?=
 =?us-ascii?Q?zLGUK7S49YxCWv/qlv1xzmKOb79eIUiAy9JCUx3x885ArSL4Kqu+VEt1Rq7Q?=
 =?us-ascii?Q?vLxLpVKZeLf8GtxXJav5UhD13jLw7/bnywuAZ3zsgYfeNJMI2Ow6tgcsyanQ?=
 =?us-ascii?Q?dwN5ear/yVZPBn60LPHqZ4ByJGUca+BkV9vnCRlM7KGNsRsuikDtI1hiXZl9?=
 =?us-ascii?Q?PFNU3KOWB7p0CQOBzs1cjKueq/lPSyIb7gQaUyJ18UhUDeXMoqbqdhMCED9c?=
 =?us-ascii?Q?YF+VMOEYIdVTn9i+smzd9k5K8fVieSEjrkKTif23YmRMaYXQFV2pjWsIwY+Z?=
 =?us-ascii?Q?VLnKT3gw7b9vtWDHLGI/O8eLN+2GJlhn2hEb4WRhpprfEnaL5t/uLb1Uan+m?=
 =?us-ascii?Q?qw+j9eSH6JVn788WVxEVoXndnyVPr0QlguZscDGMJx74BT16tBceBRJayJzV?=
 =?us-ascii?Q?//O5Xl0OarvjPeEcb/hEWZNTB6OEO62y803ao5Y8h+QQVZSHtab0Bkyx/w7M?=
 =?us-ascii?Q?rnWqaU1BogoQHbxXsTvciaAntnqQ1qvRav6zN2F+8oFrk1BPcfwvW6SJXReS?=
 =?us-ascii?Q?gVERCskCdTfMyHeGE1nTdm5is8ZF5B7CiD78FvcxV/J8tNv810QvLxkOxnJB?=
 =?us-ascii?Q?cADpQ2k3e0FrBKbzO2ezF2nH12WGqr3Cr56KHVeCL+mwbKujhzg/p+mHvTsC?=
 =?us-ascii?Q?M9GlLvKx8sl8emNWc2GeajW0ay+kYph4s7yanlAeUT+wzJZuJ60m6jNd4oM9?=
 =?us-ascii?Q?lp6lBft/IaMvEePWLEydYOc8lkoHB3ZFrIUpk5qtxbGFTnpinton6G6duOZe?=
 =?us-ascii?Q?4TqIWTj6qR/ibXt+H1j9SCc0h1ONED19stB+FZ6yMWeCEWUC+5zP+kHy/c8k?=
 =?us-ascii?Q?sz9C8t899hm8d+7XeND584+SceOqDaNR91KHRczWq/Mwf/z/mVGJ1SBIcwXX?=
 =?us-ascii?Q?anHGSw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	nJci1Zr0R3aJI7CB3VZ09zETzjlD04i0AdrihzFRyGHVVe7k6jdYDTTiQo6r3kMJfspodW4hBr8aoAJgKx2IGqraFES0xp7mZdrcU5cf1Fgsxdr3gGSHhIceCsZ5o8D550OOZfxONIjub1Q4xwIP+7Zq59XNp59AzqoN4NQLl3EHcLXmM//9Sk3QGGFkxwZydRuZNWjw6eqcJFdQZoiWjFq+73T9tDM6Bku5Y8Bx+Ww90hAZFsdO86HSeBXY1zYDPGw9beZl0HGnHHl0MBfAxTC9WFLGx6onDU4LJ5J7A0lBkr/jEg8b/0yLzXfB3Ogcu2UFvwXowcaK/EaWQXT2uIWZXP9dGNC+o1x+ZZUbm+Nkjb5oq/GD0dbEoW0RdAf5WyZDLDYHDQVuGSYaF9NWZunVWU9hjDtjwl5HMibXiCZ5wOOLQUSj34br5X/3/AEBTmorHxSqnk9xt8blRXPnBkHvyF6y9hwU13SWqc8gxbL4HoDt7GA7uA4sXdba/xu5zHji7u9Epwc1F7Jakr4uosTCmO4ud+4Fc6Sfn8mDnDAygfXUOpOBX8QTBuQ4BvVKPNZdZaml86+MI2OdubCuUVGerM1H+SnTT7tJIA/u7co=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be87d91-bf80-4aa7-d25c-08dc21ed78ca
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:59.8489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2Gt57hgXxSYdl+LzimkcJph0fQIXyLwyD/Tsr/P692clFJIfHHOq/s7pwx05HeJ04lHr6f+BPZFXyhDKvs1sg54BOAY2At/8mF7qovfP/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: XKB9QyxAKn1wdMDt60PGG0JB9o5MD-G0
X-Proofpoint-GUID: XKB9QyxAKn1wdMDt60PGG0JB9o5MD-G0

From: Christoph Hellwig <hch@lst.de>

commit 762321dab9a72760bf9aec48362f932717c9424d upstream.

folio_wait_stable waits for writeback to finish before modifying the
contents of a folio again, e.g. to support check summing of the data
in the block integrity code.

Currently this behavior is controlled by the SB_I_STABLE_WRITES flag
on the super_block, which means it is uniform for the entire file system.
This is wrong for the block device pseudofs which is shared by all
block devices, or file systems that can use multiple devices like XFS
witht the RT subvolume or btrfs (although btrfs currently reimplements
folio_wait_stable anyway).

Add a per-address_space AS_STABLE_WRITES flag to control the behavior
in a more fine grained way.  The existing SB_I_STABLE_WRITES is kept
to initialize AS_STABLE_WRITES to the existing default which covers
most cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231025141020.192413-2-hch@lst.de
Tested-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/inode.c              |  2 ++
 include/linux/pagemap.h | 17 +++++++++++++++++
 mm/page-writeback.c     |  2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 84bc3c76e5cc..ae1a6410b53d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -215,6 +215,8 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	lockdep_set_class_and_name(&mapping->invalidate_lock,
 				   &sb->s_type->invalidate_lock_key,
 				   "mapping.invalidate_lock");
+	if (sb->s_iflags & SB_I_STABLE_WRITES)
+		mapping_set_stable_writes(mapping);
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
 	INIT_HLIST_HEAD(&inode->i_dentry);	/* buggered by rcu freeing */
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 351c3b7f93a1..8c9608b217b0 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -204,6 +204,8 @@ enum mapping_flags {
 	AS_NO_WRITEBACK_TAGS = 5,
 	AS_LARGE_FOLIO_SUPPORT = 6,
 	AS_RELEASE_ALWAYS,	/* Call ->release_folio(), even if no private data */
+	AS_STABLE_WRITES,	/* must wait for writeback before modifying
+				   folio contents */
 };
 
 /**
@@ -289,6 +291,21 @@ static inline void mapping_clear_release_always(struct address_space *mapping)
 	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
 }
 
+static inline bool mapping_stable_writes(const struct address_space *mapping)
+{
+	return test_bit(AS_STABLE_WRITES, &mapping->flags);
+}
+
+static inline void mapping_set_stable_writes(struct address_space *mapping)
+{
+	set_bit(AS_STABLE_WRITES, &mapping->flags);
+}
+
+static inline void mapping_clear_stable_writes(struct address_space *mapping)
+{
+	clear_bit(AS_STABLE_WRITES, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
 	return mapping->gfp_mask;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index b8d3d7040a50..4656534b8f5c 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -3110,7 +3110,7 @@ EXPORT_SYMBOL_GPL(folio_wait_writeback_killable);
  */
 void folio_wait_stable(struct folio *folio)
 {
-	if (folio_inode(folio)->i_sb->s_iflags & SB_I_STABLE_WRITES)
+	if (mapping_stable_writes(folio_mapping(folio)))
 		folio_wait_writeback(folio);
 }
 EXPORT_SYMBOL_GPL(folio_wait_stable);
-- 
2.39.3

