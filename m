Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD19259C;
	Wed, 16 Oct 2024 00:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037552; cv=fail; b=EHZPh6SHn17Pey51peLyAgvPz3n6auu+LGWmGndD59+lpDIvNPRJCu/KAjPw1r4bfXj49VOFWqxkKHXHI+PbUAkA4dvQ8MtgaOEGXsMEqWzWwgDsqN4/3EEng6FvuaZOcPnzZQzF+khy8yu1XleJCLm3YORxUPVwt+ubwkMiJzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037552; c=relaxed/simple;
	bh=Kh0BagGJNGvBs8fmT51DDOBp71gb3F/wa0+mOCo0sAo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LKtuCxhkkIyYSlGeshJ8M/TrLA7N+JxtE0agmuiKNvoP8ctoJRrC1FBHXN14tBT3XQ7ODe1s252Ukid75/qq6oPRhJ9/G/2MdE1vxDqS8DuzcIRWB4SnY2KXcr1pTwEpg6/qK9s/ERP+BK+SWJ04wEEl8q5wCUDHgEvwYNfQcSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=luGUEWZp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VTIUX6KW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="luGUEWZp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VTIUX6KW"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtd0Y011654;
	Wed, 16 Oct 2024 00:12:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=f6pO4oukCU5P/fkoPAL8CUuRf49VRR3M2BWC/wYQwMg=; b=
	luGUEWZpojXMJLjjZbu6Cx0NIny/SLvD/pXlUm2HCEtiWiixQgjvV6x72mEvHCp4
	Mn/En5cD9BBObnSWvlBPrlrfEk8O50PPZXYojZzgEEniVp6Z0wG50CgdadIYCJNF
	gQuyW7wb+UnT7SB6ORIfrnUvegJmoo1NBeA2iWmIvSW8rwMk/2TGDd4lB9YgKVU8
	V9+47F3QIU1RWgabO45OyaMCJL20yM78+tOumKMvulpR/POuha7QG86QVLMKna+t
	O2pBySGh/pjZpPTlBKLg2Az6L/F+GJ37wfVsEoLIQNapEjs9J7hL/DlI1+K8DFHO
	8SKz34k0k05b42hXImJ7/g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gqt2fpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLkLwA026369;
	Wed, 16 Oct 2024 00:12:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85aps-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8HtD9Scw4TJeOkQlQKu0GFf5hzOLk2WwyhQgWih8IyBjZX9R4ZWwuS9JWnhydqNr9LIV99QllWW4h3gGkmP0/oZ6Oht+DGMK1pBvcn9Gq+RlZQZmlZ36I91GHQLTjc1EN+ZY8+xLcoLViFu9ZMMtlPuLYaLe0ugkKDWQXyQaNTitmgJX5zXtIJaCImBg1645mClx0biF7f7nGfvF6BDI55JvAIykGBgK4xx6SD+8a3RM+Q2/Xwit/1Ada32EJFUvJHypFXvnf8rheyv8IcDGd9V6JmNMu+DX3HXqEIf/4CWyhK3+bq5HcMUYeDBYWsGlqNfD27VZM3SDD9mg88DbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6pO4oukCU5P/fkoPAL8CUuRf49VRR3M2BWC/wYQwMg=;
 b=uaYZIobr7dIWKjqJgpOXllaeaC9W3Vy2a6Hu1fvaUKW1M9U4NmHEl4SPztVS8PjHKTCgjxAATqMYKdUbc0gGBvttWVbsUZJM23TUH9+HI+oYFoZcr/CXprFqKyU0SiMSTVvDo6MFNyt940XA89n6vcMgyeQtSRt8pyR/KAhdPRS4DYtFxL0cX5jNB6OPXPzR1TdyChfDuGIfR6vuM6xs8IzTKyutGdRy7qp8V3JlPwLvIcwZeGfvb2GDoR/ntT8qmncAkwiSVwRFahA0PKvQwnYm+lZMGj5yXgs3KbFyqvYfdvtisWFQvblwT/ksn46/CIDEp0MLGwxw5RVFge/qMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6pO4oukCU5P/fkoPAL8CUuRf49VRR3M2BWC/wYQwMg=;
 b=VTIUX6KW1wezC+gp6ddkJToxtsh0rlsDdYYXzK11QJRnSL+cJ1h8aAQYDSKKpey7Kxvmigc6CMvQ5ZPbtzSJp2lyFOmfOGVjgTJWNgYCKMv+wIwzURVPA+5ifldhLavfjrb4TUaovTLMm4UkPhe+uYPnQxxaGiBfBQR01RC+OoA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:12:04 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:12:04 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 18/21] xfs: fix unlink vs cluster buffer instantiation race
Date: Tue, 15 Oct 2024 17:11:23 -0700
Message-Id: <20241016001126.3256-19-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::42) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 236b6a2d-693f-4044-78dd-08dced7729e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cO6bwDJ/tKe3RZxwjRISwboDv2rxmDUHJFMaX1qvP++8F0qnjofl0J/yQtF6?=
 =?us-ascii?Q?ha+CuTdj4p2lSetY/GRRJWXvZv2knq8X6vm1JLH8ec7pSk0tue21wCQWr0i/?=
 =?us-ascii?Q?TJOvZ/Ss4yvl6nXrnavjhDqN2H79CzJBi0/h0tungddzfPEA4I9nAJAIpqqE?=
 =?us-ascii?Q?oRT0ckb/sHcKrnbJbUjAfwLF60pbqRhtkDrK6nv1SrzyjHyQ+iXGXqKSghtC?=
 =?us-ascii?Q?hylFXFeS1LRP5hOwT1dpDFDvtwRO1tcoU3WXoaFnW0rIi9hgx0WF6zRosNAn?=
 =?us-ascii?Q?0AsI1UQM5AXgIT6GeIIfXn6XVG5eqEtZ4smnNoayOruA754fDYkr8hm7knpQ?=
 =?us-ascii?Q?BeWibCL0zdeh3UlzYdtVKkG6VN9imyer8IY/pgXbTcZqgPI5qomvjVZuhrdG?=
 =?us-ascii?Q?VULBI1kvtrVBzf9ptRXBikLw31Cq1xZL6TEXK77vZ/R0bXdYD38DXXFEW7OP?=
 =?us-ascii?Q?p3xk/D7mJwjGHflzWikSxlx3FbAcdJWuqAAmhDMNm3LkYjKHO9GML5ROEKS5?=
 =?us-ascii?Q?xhvjB3dyEX/mFFiDQbBGa2MesTLa07nXWIpzpzVM+PPg71a3ntryNj8RRMte?=
 =?us-ascii?Q?FUyMN0D/rksEkqhArTDX9KGShcKq+Dr6IdXNc+5D2U5bMFhJ8c2YADXg5r6n?=
 =?us-ascii?Q?cpyVATazBkqZQxNtaVVx79k9Ri3XCKvSEmHZovd777bnzUZ0tlyahduX9PFB?=
 =?us-ascii?Q?tW2qUa2nEwQU84zpDQ1oWOE9uHjp4+wvroaPnDRG5Ty5DNrMOdstxdIdhpqL?=
 =?us-ascii?Q?gC1NpeysV6pP9HxImAf89HvNBj34nGY0kSzSIiP/PglDOGda+FrV1emFdTRy?=
 =?us-ascii?Q?+Reg+K9zswT0NLSQ1HC2M+AC3bOaY8GYLIQFUebBASDke9GmdmaDXbNWjlDP?=
 =?us-ascii?Q?DxfrMuVGRT+HS89Z/mPdUg/bvmJ+IU95bYVYfPA9mp62IuQcFD7oRSgb7Evs?=
 =?us-ascii?Q?rUaQtWBkElqz1nDm5yrjT6ZxOCGLGQZThYTJsRr187vpC4W3kMHhmWudLmDL?=
 =?us-ascii?Q?u2a7XWrRxDHltuhBLIhFVvbmIUJ9+03HsqLkUDZJf+yFgJIgNp8f0VSaTBKR?=
 =?us-ascii?Q?IPCdfRhiXobbyIek9zsq9W2rimCdQ/lup3XDDWhMCuGO+AMFQaYCqgQ69ork?=
 =?us-ascii?Q?o6WYiHnojcsBxED8C8Edj2IM0yE8afU+Nd1tflYgwbx5yQxZHsynIL7Sjx2V?=
 =?us-ascii?Q?H/SG/jsJd8722QkipW1p9eoIBWSrqxiSH4yVY4WQm1JYRFlxFfXwjHp5BF/g?=
 =?us-ascii?Q?UL0vck5G237E2bzbsprvt2HHqPDpOi5qI08kFgTtJg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?10blD/bPh6ffJfXmdy4MM1DNUTJDNKSaqk9YutBE5tF+GEZeEtd0exq+brtG?=
 =?us-ascii?Q?FudjXLThzwY8r+Yc3d2CzC5bCyXoIDNop1RGjKad0HTduCyyQq+el2gwAAJL?=
 =?us-ascii?Q?MvmYnuqR+Mgt/NhhJ+tfKxeNwa53yPh7VhSx4w3DzpQOgpvzLnbJHne9FmXP?=
 =?us-ascii?Q?c51BkVnaY3mZO3mFDIhFqBfgdlnesbBssJTMXVCgDIOye5DcA4WXGWZ/SERh?=
 =?us-ascii?Q?yZJWSZgtwhaWP5Bj3DRXkBRFrrkVm7r1s55kE6uVjb8qLbrUZY3GBotXs6D4?=
 =?us-ascii?Q?upk7/HyrCqr0Wm2EvYbT2ovPGnNwu9mcX8azUhLzeCBcdor0A8woui1x19ub?=
 =?us-ascii?Q?qOvOmfYjdOPB6I9ISFJOPmGbYSm8IuhqxH6UmR47sz5a9hL7YkTR53II6T5r?=
 =?us-ascii?Q?QuBJJa+iynsUKDwjQMamuQUwY6sAJ4jXKLLbnj+hw4P7dcgHEXPGMf6sg30N?=
 =?us-ascii?Q?13Lh2i5QFRi5QUnNbodaxk50CKeGQwMGppldlkpjtDKc8eHHvDQt2Fl2SY1L?=
 =?us-ascii?Q?VEQ/GKoa6hx2sKxcwd0NZxm/V2h9jPDbqwopku7/ZxRwkDssEl9qY5Mo70jh?=
 =?us-ascii?Q?nr4C9dQYzD6A0DDXjuQ8nSyLWd0cOKJsJ1BntvJP0N/ONRBclJrheIXK/Vqx?=
 =?us-ascii?Q?Y+IM6aZfn/IQ27LupV1MunRyx8dbYnmFU+GOvkfeNakU9C5KxCcbAxLDAyo+?=
 =?us-ascii?Q?G0gdwLkClPoNHQ9uO0MqyoSbvxQMJWXso0dLg87dLXdRXhv6ZmuAU3jFdGWR?=
 =?us-ascii?Q?e2zvDmjE+T6nQor79w/D7FSeJ4dguUxKrS/ObpzNPjS3yFFSacnE6aeKSXV8?=
 =?us-ascii?Q?tOKSC81y2UZFAHFxNmnbst37qbY8Wc94d8wz6SQqLrxT8H7wzrPVMDrDJfmQ?=
 =?us-ascii?Q?Le1aA30HqcSTB3HSRl9Crjud9Yfp89lEUw9vOXXPQq2RcThOOWYI/ATs8mwV?=
 =?us-ascii?Q?6l4DDLWTLomTR1dldwJXzhwQkMBZUW42cuVm8maAVc5O66LDYg4BM7w0CRye?=
 =?us-ascii?Q?xmpag0vZdChPaQ66JO+6TsF5I1SElBV6NlNjy0hb74BXkPIHZSNazzxq0hKE?=
 =?us-ascii?Q?riWYPopWHGcX2RVlBcQzEaYIS4zlmsEgw81x7xz7BWqgaS36HysnRDVyqHas?=
 =?us-ascii?Q?7V/UWWi721fj/X12rnSqKm1vYrttgF4R8qeWj38dSUs2CY30C25R2OOaHkqP?=
 =?us-ascii?Q?IlKqGCIQqBdBsS/8JYM5B0p2ZKkGnIrh3AnPXz4D9wEaCHSrWgi/9XTGuB65?=
 =?us-ascii?Q?wluviea/a5Z33R7n/BO7XEeZUOtRJSeU2EWmxCB8i1WYYfLwMAi05xoVeU53?=
 =?us-ascii?Q?BN3nppjGnnPz5G7jbWqTAvoh79Hm1lAnxHcncWoGbvoW6DSM9m/aLFHPooYH?=
 =?us-ascii?Q?ashtPwiQSgXP3Z7vIA9Xgdsc0E1xg9MrjkfRiu81ahQclIsx4DbB9bODRocH?=
 =?us-ascii?Q?QDCQZBHVZ9VjVyBXDHCA6FJzYcTJIQDl8vwR3vUy5lQO1o2GFuNnB6ZjTtIJ?=
 =?us-ascii?Q?rixI5Ucc5FA/oauYpDDDBDD32m2sM7Lrny/y04IyRkDDmNnLVmVERscAaPpP?=
 =?us-ascii?Q?JNBMfupJOa6s4BmLauuB5IpvJbBT4w/Z6X+KCsOZO7pwa7dadNVnZCE6yeDy?=
 =?us-ascii?Q?bz9VLgLZerKszmguRx7nIg/UCgpUvehaGKMJ9P/4BgqJ/4QEb5xljBp9pN4G?=
 =?us-ascii?Q?lVXoAQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YJVn1e/XQ1olF/9ulAMIOQa8g/FI6lgBJBSoK45PYJ2lKDAFlUDGakObYAKt+kccThVBKF2VZ3tGou6mdwb8XqnY3WEqErRZfIbT10kjsUFDUHTiESySn6TtnjEoe77TATDX6H77l8FPtB+tXdnC9ZaZz2hUiOWo6ANjpTU/wtYJ7N5xcaxWQiiPPph/gf/GHsGpxrWPxtyLKtsTqlTalfuBJyS24k6BSmfI6Yj4rjscLJn9xuRSiqUlHOBpqWQ2FBCrRmtN/EZ65ASN3EKW2AOaCxR1tZGw19GysyJfv+oGV2BIJJUB3fOg7bwhjhsAZf1mvpMvwuRsOLSGu4dejk5leDBg7j8GFoVhmyRIoyQPxzzkRAqkBbN0iR1adTIOH8arI2vSXrNLSltuQ+PQ518YHYjrnb0Q5rur1QQJjIFzcISA+TAElER/NH7NEUV8T4PysnLqRDGg8MJO+pBNfix8vCRRfB54rCZMndJXODGEoONvR9gjYj37kqRbGDhL7+moSK4EwCzS0uTTFQVpM7G2HQMF6ifxG7JEGyi74lOaqn/G/VQPUJ39QRFmKFTTK+jbdpcB6hTLh37wjGHtv5YpTH3f4t1nnGfATFqvG6Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 236b6a2d-693f-4044-78dd-08dced7729e8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:12:04.1023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oob3EAYJlXWMU9CvlIG2sZUUf8x9bZwbFo80FJK7Y7SISloClckSwjxxzf69/q+rzRcj789ffj0tRknw90aTWx16x85+dJTuuLeQONY+bXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160000
X-Proofpoint-GUID: J3M3AopMJpDJT17054SYj9sJNon_JR4a
X-Proofpoint-ORIG-GUID: J3M3AopMJpDJT17054SYj9sJNon_JR4a

From: Dave Chinner <dchinner@redhat.com>

commit 348a1983cf4cf5099fc398438a968443af4c9f65 upstream.

Luis has been reporting an assert failure when freeing an inode
cluster during inode inactivation for a while. The assert looks
like:

 XFS: Assertion failed: bp->b_flags & XBF_DONE, file: fs/xfs/xfs_trans_buf.c, line: 241
 ------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:102!
 Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
 CPU: 4 PID: 73 Comm: kworker/4:1 Not tainted 6.10.0-rc1 #4
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Workqueue: xfs-inodegc/loop5 xfs_inodegc_worker [xfs]
 RIP: 0010:assfail (fs/xfs/xfs_message.c:102) xfs
 RSP: 0018:ffff88810188f7f0 EFLAGS: 00010202
 RAX: 0000000000000000 RBX: ffff88816e748250 RCX: 1ffffffff844b0e7
 RDX: 0000000000000004 RSI: ffff88810188f558 RDI: ffffffffc2431fa0
 RBP: 1ffff11020311f01 R08: 0000000042431f9f R09: ffffed1020311e9b
 R10: ffff88810188f4df R11: ffffffffac725d70 R12: ffff88817a3f4000
 R13: ffff88812182f000 R14: ffff88810188f998 R15: ffffffffc2423f80
 FS:  0000000000000000(0000) GS:ffff8881c8400000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055fe9d0f109c CR3: 000000014426c002 CR4: 0000000000770ef0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  <TASK>
 xfs_trans_read_buf_map (fs/xfs/xfs_trans_buf.c:241 (discriminator 1)) xfs
 xfs_imap_to_bp (fs/xfs/xfs_trans.h:210 fs/xfs/libxfs/xfs_inode_buf.c:138) xfs
 xfs_inode_item_precommit (fs/xfs/xfs_inode_item.c:145) xfs
 xfs_trans_run_precommits (fs/xfs/xfs_trans.c:931) xfs
 __xfs_trans_commit (fs/xfs/xfs_trans.c:966) xfs
 xfs_inactive_ifree (fs/xfs/xfs_inode.c:1811) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:2013) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1841 fs/xfs/xfs_icache.c:1886) xfs
 process_one_work (kernel/workqueue.c:3231)
 worker_thread (kernel/workqueue.c:3306 (discriminator 2) kernel/workqueue.c:3393 (discriminator 2))
 kthread (kernel/kthread.c:389)
 ret_from_fork (arch/x86/kernel/process.c:147)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:257)
  </TASK>

And occurs when the the inode precommit handlers is attempt to look
up the inode cluster buffer to attach the inode for writeback.

The trail of logic that I can reconstruct is as follows.

	1. the inode is clean when inodegc runs, so it is not
	   attached to a cluster buffer when precommit runs.

	2. #1 implies the inode cluster buffer may be clean and not
	   pinned by dirty inodes when inodegc runs.

	3. #2 implies that the inode cluster buffer can be reclaimed
	   by memory pressure at any time.

	4. The assert failure implies that the cluster buffer was
	   attached to the transaction, but not marked done. It had
	   been accessed earlier in the transaction, but not marked
	   done.

	5. #4 implies the cluster buffer has been invalidated (i.e.
	   marked stale).

	6. #5 implies that the inode cluster buffer was instantiated
	   uninitialised in the transaction in xfs_ifree_cluster(),
	   which only instantiates the buffers to invalidate them
	   and never marks them as done.

Given factors 1-3, this issue is highly dependent on timing and
environmental factors. Hence the issue can be very difficult to
reproduce in some situations, but highly reliable in others. Luis
has an environment where it can be reproduced easily by g/531 but,
OTOH, I've reproduced it only once in ~2000 cycles of g/531.

I think the fix is to have xfs_ifree_cluster() set the XBF_DONE flag
on the cluster buffers, even though they may not be initialised. The
reasons why I think this is safe are:

	1. A buffer cache lookup hit on a XBF_STALE buffer will
	   clear the XBF_DONE flag. Hence all future users of the
	   buffer know they have to re-initialise the contents
	   before use and mark it done themselves.

	2. xfs_trans_binval() sets the XFS_BLI_STALE flag, which
	   means the buffer remains locked until the journal commit
	   completes and the buffer is unpinned. Hence once marked
	   XBF_STALE/XFS_BLI_STALE by xfs_ifree_cluster(), the only
	   context that can access the freed buffer is the currently
	   running transaction.

	3. #2 implies that future buffer lookups in the currently
	   running transaction will hit the transaction match code
	   and not the buffer cache. Hence XBF_STALE and
	   XFS_BLI_STALE will not be cleared unless the transaction
	   initialises and logs the buffer with valid contents
	   again. At which point, the buffer will be marked marked
	   XBF_DONE again, so having XBF_DONE already set on the
	   stale buffer is a moot point.

	4. #2 also implies that any concurrent access to that
	   cluster buffer will block waiting on the buffer lock
	   until the inode cluster has been fully freed and is no
	   longer an active inode cluster buffer.

	5. #4 + #1 means that any future user of the disk range of
	   that buffer will always see the range of disk blocks
	   covered by the cluster buffer as not done, and hence must
	   initialise the contents themselves.

	6. Setting XBF_DONE in xfs_ifree_cluster() then means the
	   unlinked inode precommit code will see a XBF_DONE buffer
	   from the transaction match as it expects. It can then
	   attach the stale but newly dirtied inode to the stale
	   but newly dirtied cluster buffer without unexpected
	   failures. The stale buffer will then sail through the
	   journal and do the right thing with the attached stale
	   inode during unpin.

Hence the fix is just one line of extra code. The explanation of
why we have to set XBF_DONE in xfs_ifree_cluster, OTOH, is long and
complex....

Fixes: 82842fee6e59 ("xfs: fix AGF vs inode cluster buffer deadlock")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index efb6b8f35617..8bfde8fce6e2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2329,11 +2329,26 @@ xfs_ifree_cluster(
 		 * This buffer may not have been correctly initialised as we
 		 * didn't read it from disk. That's not important because we are
 		 * only using to mark the buffer as stale in the log, and to
-		 * attach stale cached inodes on it. That means it will never be
-		 * dispatched for IO. If it is, we want to know about it, and we
-		 * want it to fail. We can acheive this by adding a write
-		 * verifier to the buffer.
+		 * attach stale cached inodes on it.
+		 *
+		 * For the inode that triggered the cluster freeing, this
+		 * attachment may occur in xfs_inode_item_precommit() after we
+		 * have marked this buffer stale.  If this buffer was not in
+		 * memory before xfs_ifree_cluster() started, it will not be
+		 * marked XBF_DONE and this will cause problems later in
+		 * xfs_inode_item_precommit() when we trip over a (stale, !done)
+		 * buffer to attached to the transaction.
+		 *
+		 * Hence we have to mark the buffer as XFS_DONE here. This is
+		 * safe because we are also marking the buffer as XBF_STALE and
+		 * XFS_BLI_STALE. That means it will never be dispatched for
+		 * IO and it won't be unlocked until the cluster freeing has
+		 * been committed to the journal and the buffer unpinned. If it
+		 * is written, we want to know about it, and we want it to
+		 * fail. We can acheive this by adding a write verifier to the
+		 * buffer.
 		 */
+		bp->b_flags |= XBF_DONE;
 		bp->b_ops = &xfs_inode_buf_ops;
 
 		/*
-- 
2.39.3

