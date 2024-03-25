Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783C671720
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404468; cv=fail; b=R+nAbYvSSeiaQu6aq8IsXw71Q4C74LPqPXVgqmxn/2xhYJbF5L6VHA60Li3CjWIydWQ06JBLPzCnc9tSrfMo319kwOtQx254xXztQW1Yls40qJc0/5lyigc94ddWlxXIDOVGmUv0jF7geXJmf/wA6ztJOPFbf7k5dQDpR5RFRq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404468; c=relaxed/simple;
	bh=j5t23ItROCrWpAOgZZE2u7eA5J8+E0XwRbvjHFHaFic=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lVeyPVLV9+rZ7J+c4tMe7Tub6buCilpMPcB1s9XMqdUUgMgvU9DY6vz/x2pbVO661Xi84P7KGOuhiDVpaD0HPps6Dl/Os/NPyLqYys+dndGeVm/f9/tbaxcndTkKbeYGN1b+Nbz1sbb0GmZ2xnh7XPAQS1J6sWno9ch7dWBCOis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=INxZZSlc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sMMRXKZL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="INxZZSlc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sMMRXKZL"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFxH9019802
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=Zt/hDV5T5tqiefSb6YyQFHqfjVY0afy302RE8KUgo2g=;
 b=INxZZSlcC3hb98KGSsUdCM160AJGPimCgZ8JM6S0F4DLiMhnoRmW20LPl0PWOkezRZfa
 JajxvY3SrezE8Ol35ytuc/qKbJVwO+8NU+iXf3dIkClN30nIvmqgOiHE8zmty6JQMX6L
 z+zvtcDIOSfTcRdiC0IbE+sHNAYW6qvesHDW8uRUMJtXYUqmgmxM7M3rTZcDWm2rqt4o
 wzjnqbkq1psaSj8YpHOexzJINiOO0LrQdMgsALFJMRnTRzYa/Eg1oaa4u2UNnf2j+Yro
 mlwwdEMIjDR5+28DgR+lIm52wMDoJBk0TUMHOb4aztA7O88VurZTgQVHhAxrsfwlTRQU Zg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x28ct32g3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PK2Xtc024865
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:44 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17012016.outbound.protection.outlook.com [40.93.12.16])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6ccg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZKAPJduZmCR6LaTFDYUvrJr/MRHHwkRlNJVUbU1BZpv6D1AeIAfJVs3G47ND7YivE+FNawSxM4ji4IoqLpNn1Tj5GoahhqQkQwpmCIDZFR+NlhpQC/sNfGBupvi1sLrlWkH2ar0HADeHY76Kw9DaRWWqoqdKittVE2QG1voaw8TzST6N4BFG88IvqP7pprSdK2nJGBaHDEr8z4TkTk1svdRgc0HU0ERDM8Oh7OjTNzScwPWMSSOzKfcdvo8KYDkeUtLQ1AslJsdpL8EFpR7KMBZnsE2taO5h3WBcb/sEr3FQ7+SFtuFNW0wwWveVV61y1rQJrGxRK5cvC3lTGxN2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zt/hDV5T5tqiefSb6YyQFHqfjVY0afy302RE8KUgo2g=;
 b=Zr7iNUGi6wPXjAVx8CpnAWq538GLb02LDUt+8R9vJ1EaoBfYovEFk8DeEi0t9E4eX+UQ7lMkzqLIZ9nZJro/KvwghEHrLEmKw1rSAIDfrzG18wqO2UJLHkw/JlpuOocVPPNunc1dLo2HiTd66TJLhws1vGB/HPkwY+zxyv7VcLCjqSViKkOAzesj9sOOvBdJb1L6tGRI+GY+mXcfZQiFda7wZnXGzqbJPRICg8IGWx3oTE08mA7JX007jdROzclECN9ya3cJkZ8shs1uAEPaV/3A5+zmmDWsHMggW2KyH45rSseK3N8YQ0qhb9KSwH73mBQ1EpMPM3zDitN4Qa/Fbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt/hDV5T5tqiefSb6YyQFHqfjVY0afy302RE8KUgo2g=;
 b=sMMRXKZLSiLwZbPkpmaizXyBC8b5PPd3sVavAyiPhbncHth8Ez/aSgpQ8sdObeKJB1xI8cgMLoNgRRKfU/DULSAp/d+Bt6i1te+MYWlVZejCxxAmSnYWlLQDpMK2dDqT0oz/smSrTaYMjfosiL7OCsMITvMf+uHof4+GZnL3INw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:42 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:42 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 04/24] xfs: don't leak recovered attri intent items
Date: Mon, 25 Mar 2024 15:07:04 -0700
Message-Id: <20240325220724.42216-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::26) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7476:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	cRY4CKbYL5yaJQHj0xM2DdVXrXKp/tQJpb746qlnXmIeYGMrDL6Vuzp3rIiJHFyyPmO9D1oaOI8kvoSV57MyCLunYDjhXybMiR8tEel1KA3YTaeiwZuYlutbC61aGqb1Y9i767KGPCkFfvaQoOsUvxoooX0bS2VKpSwqaAPyzdgecuXXkvspPeZB8PShN4zswRavxJSK+UuwLMJgz9KiY2RnxYmYY5jNI2P9qvNeIDk2G8qFyUNSPzb+UoovuI3J9mxix9G9g0joyoPQ8pdlkcQdS5uBGzV97yuc8GY+Z7WwA4+6L8l0xR/sqzqBj3f0GrHedwmW42SYS/72GexsAHfDDRP9OPJ5H81YmDz9ArWUjke8zqsqF/17/atHL/OSNjHjyS9Ip/XZ4UuAnj6lAsdprI6K5W4ujGtyDyJgrl06LmeXQqaSrN9mJOtbIZF/M+AbhnE08sUGXqT8OG/0x3zEYai4Fh8JDGjyr+fR14Z+8Cyc1rYtVtABUGxmeqH+aAJ1uzyn3yrzeiFyJAe2lurwBsiamqrXk8T17JavOOnPxLGV+l/x6ApVYS2FLLL7xY+SqtPwzL6TlKvLh/evLgAnPO43nScVykwUBkjzcG6qxWaUUD5ep+5NZErrZC1E8kBHU2/DZxeBcWfAJ+NEgtABQnoygjp1xALaXiaYrYc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?YtZkZu90Xdmyys46fZV29fzEEfCTEdxbW40eBCSBm7hjTQ2dhjEw10BqD1on?=
 =?us-ascii?Q?V9ANYX5rCNI/Hw0kpf/5OxjEyrHPXpBsH1RZvKo4Gpeg1tU3DYcXdtCm5LvU?=
 =?us-ascii?Q?ZkVLwk9Yl609SygGAfK8SOnhQnhts40JuWJM5hIpxSoGoBGSSBFSNNv58RL8?=
 =?us-ascii?Q?KnC5ZHoHWNcdUUrmMlv5SWKfygfwtKRalqhkgrkOaVErZNUY9aqR3at1Khgt?=
 =?us-ascii?Q?ktb9H5Xo3wO5vdWmhi0swAKyE7O2JqLluQhJTbV0WDrGG+1STpS4AMRhcgLi?=
 =?us-ascii?Q?lJlQ/JbnYkIZEIHa2RtSW/+w7xJX8pgBBKhasCmIHWDfUAB9q/8SURadcmH9?=
 =?us-ascii?Q?1NDRD0U389oj3Pu7QO6BkUmDZTphI/8Z3tmwniQkdQpbCXlwx5ZM4CGWFxha?=
 =?us-ascii?Q?HCw4eyAxdu2bQqWagsaci7Snbud9BE8RuS1BDQQCeEz2bzkV3JNr9LezrG1z?=
 =?us-ascii?Q?p9abhZ+2V/jNm4/5h+sTf7mZg5oz/Z/f/0T+VqlnkI3TCMSonRFLQjWx1EtS?=
 =?us-ascii?Q?E1cbvLpY7y3oOU/h13KjWTxzGTQCrlQ+IdrKmH8uPZknmVaBVocXkGdSqIb1?=
 =?us-ascii?Q?NAYFe0sbH+alerNSS0LN3u3NXiWH2MpwNQ23332B8lDRxPWvz87zA2hKOqTt?=
 =?us-ascii?Q?QUOi2U/Dj0e+wsc9XyTuBOe8bHDMGhkXJN6zjdpdYFJ9eNvRq/PbVsjEiZN3?=
 =?us-ascii?Q?7tQ/Npj4gywWYo8/1KizorkLQ94z5fLxVp1dIUW4yljfqwMULtBVN9voWlU/?=
 =?us-ascii?Q?azfotWco4Dr1rd4p9iQgur5Orex95BPQFycnz3L5AEw0sk+drdzjR9h/Ox+Y?=
 =?us-ascii?Q?sUJw/cgcdKC8ip6KS5Q7PKJdMwnAX0Eh9EFEFYlZwYxhubhb5mS7U7EwQr3E?=
 =?us-ascii?Q?u+1yojQfcrBXJPqXGpMY1R5BzfqmJKoRjgaUWliWS1VgNioKChgbBKBzPPXv?=
 =?us-ascii?Q?jyX4/926+PZTxgc//TAS3QdeJqxOCr63Y1P8QRK0o7qRHz5M6G5QePDozb/4?=
 =?us-ascii?Q?3+Yri9k1LQQ64N6/4sJGxI00ixMD9/mB1693jgmVINsGEkeXsbJO4a68qJnt?=
 =?us-ascii?Q?s4LjlXhVRzAppViSOI4FoMuwAgVjbZ6MQF1sUigHRL1liOJYouNlHMlWnLUO?=
 =?us-ascii?Q?xVt62m29trI+X6yYeMVXsGPw+GLh11f9duHP/oLozFOKR10rIp5tzNykbiIt?=
 =?us-ascii?Q?PjNs3O+IPXKjBzdAljWm51pf0atBlX/d3UPoBQEjPNjpW9TZSBOGfFzIl/nD?=
 =?us-ascii?Q?uXkBPWzH3Od3O2YFhxGW8VGdOa/4LE83LaKH7wuU4I2p3qR1T7U7P5FwVvwN?=
 =?us-ascii?Q?Nd809GG38hY6UHw8iLeBsQHrhIKPXm4as/mlS4tINglUIHoCdqkAgG5pdIP9?=
 =?us-ascii?Q?PJIAsE7kCatX6q+UOhXHBwYmUOimR4Ar+yBn6ZbXk7QYQi+KblPTl94P11Jn?=
 =?us-ascii?Q?/mFeORDl8P+MlR2WtKjMWcDWIRbw66aFTKBWONpAUng9ucTpP/HLx5VVcYxZ?=
 =?us-ascii?Q?QcQEM9a9nKvMcD9UffApoaIWurG0FTdfBNvzar5NeKXk+njxtDry81xzWdlO?=
 =?us-ascii?Q?Tw+ynWP9IQ1lXGNvJD7Q867oO46XPoM5NQs4IT6+uZMz3hhNGIH5cXGDaf//?=
 =?us-ascii?Q?h5rmhsHC5cTxauw1d5kJoU1XLyU1CLcVy5Davor/Xb97pWS66sGWPA1swqcs?=
 =?us-ascii?Q?2zGM+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	eA5RwVZlAwFU1LrMQ+1xQK3YtGsXvu95KcBBjNCFBBZLxhky3QgOyhvq0cHeVf6iT3o01xvDfgS32COaIxfJ0+U0BQEpa1J5IuDEyOjjBQZzLuqytwFzp1Xv31+YNdu4diXK/iUKBmhFC5udh2UYzszZoDJ2/fTsZl2/ejY3k8Bo7EySWhWMO+DJeTywkeyJb3kr+gBt6cHNsmFm88HAN9S2SME6ualyp1vdpwtkIfeSYiVOnovwvwbVnLNOfmQq2eDD/m2uJa8Lcm1QryjCiy9fCpSRw+N9dTpy1tbLSezi7BduZ6jewY4y1XFcXYbdopLdJU1UY9Qd8QgPTiF4E+cu1AGRmZ7mL/KiMc1upUI3+Bb5aBUSnKDkq3tK2mdWy6X1lORrpqan0Q8dnypDA3766l31T/WBIGuFQCun8CpvFWv1RjyJvvC3GjGHnD6YMKj9GP7v0nc21s1UvV6ny/Dfpn5kfBQcl4poKzmwcxNQxLkdaqRvFuEJRkiwIN/YuG4IH0q88KS/fciL0aeAQcDKDT9H1N1to3UC5tzAU7plVoaLvyyndncIY/gzP0qUYWXqQnTM8K6AOHOGuDRqes90tFry+wyvP15SoJbwcM4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b044c6a-2458-4c09-b06a-08dc4d17fdf2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:42.1445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJnHCn7msVRdkIvvVgjPQCxQjyeFwCplAemETWf1hmmoR8Jqr3R9KkyX3svvL2DsrLXx+no2JL/waPcHFRDyjKpkt36Z6EGfcRKJOQyIGfM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_21,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250137
X-Proofpoint-GUID: X1sceB14sOxRcj9w8IkC6sXfKNwZENNE
X-Proofpoint-ORIG-GUID: X1sceB14sOxRcj9w8IkC6sXfKNwZENNE

From: "Darrick J. Wong" <djwong@kernel.org>

commit 07bcbdf020c9fd3c14bec51c50225a2a02707b94 upstream.

If recovery finds an xattr log intent item calling for the removal of an
attribute and the file doesn't even have an attr fork, we know that the
removal is trivially complete.  However, we can't just exit the recovery
function without doing something about the recovered log intent item --
it's still on the AIL, and not logging an attrd item means it stays
there forever.

This has likely not been seen in practice because few people use LARP
and the runtime code won't log the attri for a no-attrfork removexattr
operation.  But let's fix this anyway.

Also we shouldn't really be testing the attr fork presence until we've
taken the ILOCK, though this doesn't matter much in recovery, which is
single threaded.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_attr_item.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 36fe2abb16e6..11e88a76a33c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -329,6 +329,13 @@ xfs_xattri_finish_update(
 		goto out;
 	}
 
+	/* If an attr removal is trivially complete, we're done. */
+	if (attr->xattri_op_flags == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    !xfs_inode_hasattr(args->dp)) {
+		error = 0;
+		goto out;
+	}
+
 	error = xfs_attr_set_iter(attr);
 	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
 		error = -EAGAIN;
@@ -608,8 +615,6 @@ xfs_attri_item_recover(
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
-		if (!xfs_inode_hasattr(args->dp))
-			goto out;
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:
-- 
2.39.3

