Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB394BA93
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171630; cv=fail; b=OhGqH4WjTioZ321838eoiz8sQ42/rpe0kf3QK6SlmTF98cgyv/m4nnFNmdr9gjUnJjwvSg86L5bQ5aCmyGcTyGx328cYV/YeSmNz+i1KcbCcc/Xq7H+GZsGTyye4P+swqdeFxfm/GfV73QADicqDb5/qGZbbZvkUULyvH882naM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171630; c=relaxed/simple;
	bh=lRpjgFQMQWbjh6ZkGtiVxygUvsSeURvFKoxMTZrCUvw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m2AhKEQKYPtwAzmzCHNDQgokNUMm4AitRarLnnULtM5gqnV7wYrhxBN7UKIlSnKUY4DFeAgDJjoWtyDxAVUKDil12UvJxx6HtjCy7kZA8JQj15MRyDaq42WG6fZ6mZy9MriWE3OyE0RXjlvr4UPr4dL9hnQ5bsEXe6Y/Y0mriRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m234xSh7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WNJkQJf9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m234xSh7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WNJkQJf9"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LDxbr016015
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=vA8fwPw/gtnmEWpERlcWOfQ2TjQ36X+WkUwZvqYm/j4=;
 b=m234xSh7UJqGbsCWGjUcqH0HKU9FAhRovGDdxi8OVN6WQpLlk7L/x1UjbKCE6eSwiCIw
 CokLljXIclKqjRpFeyIijlH1R5N/E0AlLRtloylwu4+EBzfLDiBU/epZwBilzML9DfuT
 dhOaxXPylKHOWAHNRonswRVwl/cWDtTAMyLVIOIid3vEnPS6IUH8Wic1gwlmVv6qgBQQ
 K4km7POTma3sVYihObQOCk/wIXPqSkmILhxDJbNwAf8CAextEpJxzJ3MAEXlyNeNq64Q
 qTKh1aIUZeY/PQN8axi/jMEIZM2jveCq30qilQcVa5Xmueab391nqM8iMLoEWv4uWmhY fQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c93wb3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415LBaFU007074
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:26 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6k59j-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C63EoNaJ4umeewZjSlC+YPutsEDWql48p6xzJGdicNymOHHAjSKyHLxIiwVwbKkgwy5Ir7VNNpqEOdgekDGdhMN649kKohmgY7R6Ig4TA7dYtAMxSAu0Tapgn79hSghe0WmQZOc3DlCYQX3/tdthS9MN6BWz7D14Vl/G3lHNqVUYX4A7g1+TZ4N7xiFNOLhKN4S3GNXfaEvB3nuIyqDZlF7pucMfdP4WUnyK+ImClQcQZk7UTbRU862x2KsWi2a+g8edf8XixQtxJjZKNepAf22pHUegkbJFwO4pzzo62OD3V4+qYbeFC/zBlfBHPJc/BGRI6TGouY8uNLBVkEb/XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vA8fwPw/gtnmEWpERlcWOfQ2TjQ36X+WkUwZvqYm/j4=;
 b=AVqv1tDDhjyq/cVkj6189lVuVL9h5PG63cO/mpIGyieYftanx+PD+WAkhg14jRJ4CTmDC2R+jkQuxZBDHOhgOysMjF3+7J1csUGs2O1IyRAWgJCWEuipOwSwd6etFdDXvwke4Qb2EzwwFancfOASlYGDWPCrfKeW4ZCRl3po1G9jEzUfMvisF2nv71t8nPBR5ESeXvrMgl3rK/BcyBoEGmYM3nTo5YuWnGudACMvneSuTG4G/MgzBmXsXKlFyOTQxfOSDpiFt/oNU+TjRxcuh4TMtsqVRZBopirPoicncRbxkB9QHoN6p605kNuPTAhkxIcV3cPbLYnayXGL4ddRhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vA8fwPw/gtnmEWpERlcWOfQ2TjQ36X+WkUwZvqYm/j4=;
 b=WNJkQJf9zYiwyBSwVLTPUL/r/0wEnE+tXjt73CxW7b46E1DnzjnsJjEqdWHFejDEcOPllmPg4aZbMqLdqQ0pu4S+TTEWDLK69YKqnjUwqrRxnT8A5jesxqW7hGftj5Uj7STrce13nqo9b7e/nzxqEURAgweC8/CMOV2vwX9Ps4c=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:24 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 04/21] xfs: prevent rt growfs when quota is enabled
Date: Mon,  5 Feb 2024 14:19:54 -0800
Message-Id: <20240205222011.95476-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::19) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: bbf56123-cc18-4064-380e-08dc2698a63b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	RKaSe2n3ohBRQALxFNNfkGxvYkeDHtqFE84iekrsDsnOY2ux/X4/TlnLMhjXD2J/CXWERJ2KCa1+gzl8QmfhuviIMHefS2RB00I5dhEqakezTS1hlMlfBWIO93vvRz8xztIVfF4+6wkkPCMgJhrW7SKUWFmKLl2n18qyXsX9uWgrEUHk4heFAvQgoZWGpyz4UG+rZ9Ynh6evpv5zKDtmm4dA6gJAWnHfA2KEphNQuUVK/02uuVQoHY19P6c/s2SStQGJ1gFUnfGJwjCkFYz9DIzjQj7urHJHaKp/D/0jHjgAGo4sJHGBkQjN/DYWIEI2Of2GPqtzVYAUrm4xFyumoPOpTGQwuLxzpSRkV0UcmDNCHKCRgtvhpYq+xLgEmdcIOP6+207WBshAbeih1aqaxo29OKpeivqNx/uATZv66tg1BuOP81U4lEV/PUXze8r2S329MhLRCG+YMYl/Gaa7jkRrGUuuIGmUwP0bM6pDK1Z7HjoeYfrkKgagF+Ns6q7ZGAQUBDA7wnYGo3yB1aIC8XyAHe5eexnZrxwjwhsWuJCj2/3ZXWQOdW/D8QNs55F0
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(6666004)(316002)(36756003)(8676002)(8936002)(6486002)(66476007)(66946007)(6916009)(66556008)(15650500001)(44832011)(5660300002)(2906002)(38100700002)(6512007)(86362001)(2616005)(478600001)(6506007)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?7xej2XS4jSflG53+5UoOueAbdygENKWIAu7TWqEaD+WGJ2QBZkr3gTAcy05c?=
 =?us-ascii?Q?6WHhHYmCbKSsSf9FGVJCDmbXjC4pyHO/pJr3kNNto+gVkK5bTJa+xMb57gEc?=
 =?us-ascii?Q?48RX4pHA+JlnXSJDh5/a2xR1ZagK/n/fwlRcJC4Jci2Ev9cUkTmk3lEsK36o?=
 =?us-ascii?Q?Ghixt3VZvuSU2SjzI/SP7tG3psJnCex3R6mWtNsabmO6jTJqw0ZSppwcsj0J?=
 =?us-ascii?Q?3HQy7Lt7DMoDwOCkdi5Oivy31IesZsbiaWOSIw30XFPGDSatZuoj8H17EM7e?=
 =?us-ascii?Q?l1GerGspyX75WzFcteVWEC+KdE5PGwyeGq8X3uRKl7iqxeh0caHZNjdBAWPI?=
 =?us-ascii?Q?dJFnTcxOm5b4Vg/tQIzr4uUk9dD0zcn2kMf2jg5a6c4JUxfpt3mVnuvSDcVq?=
 =?us-ascii?Q?0HbdIdyGQT7nJXiyRBQCiJCKAx/tcAPThXC8/Md7Dr6+ZM8Fsu8hgrvDpojj?=
 =?us-ascii?Q?6pH0oCa/3WZflAqPeL2tX+0geN4F9YfsaGaEXb5bj3AlCRE3mM62wNRFga/c?=
 =?us-ascii?Q?fmZdqAGj5+IC00LjlIA1ZBDKy3xazu7BvDqHCmCiMEX8FYBJTU/ZrqOFAyNa?=
 =?us-ascii?Q?7B80tNP1n3se0cCpb6NNw9EO8AzlB4pQeXEOkkKeONMGB/XZgucvLJzQJbnA?=
 =?us-ascii?Q?mEmD3gSD4Z6YJg4Fn6PmOWjX5/Un7/J4Ojw55xf4mLFFXUxUJD/3fFIzpNCT?=
 =?us-ascii?Q?TA73stG0z0gMbORTC5nu4h4ISczZce4ETrjkgyx7RFBHwiXgUuVICIv5SPQx?=
 =?us-ascii?Q?3TFIW+3lMm3F7btIfK5F98NH/Ke7o2EYKodea6VYog9FW0O6Jnrmk5gFIf/k?=
 =?us-ascii?Q?Dq65dyskZ1B5UQ+9+vLvbtndH9y7ULxBiQq757Nr1DgXMg8AvCynj7Oq7am6?=
 =?us-ascii?Q?TAEFunJgZmUNgKjpnj5JO5eUyvxw5bO6r3q2FEmc2g247kXCJDC7ygddkiIz?=
 =?us-ascii?Q?uLVCK6aUJ53SSrbOt6GGKvgKa5nH8yWnI9LjkuRCLMURT45+qOnkzmyTUOmW?=
 =?us-ascii?Q?J4+iE2erke3ARktwP5KvxBlJBvk6M+OIzJtDLij3QsF/L4o0Wwz4VT61JgcC?=
 =?us-ascii?Q?ov1N5eO6E5W5p0zqxPYpx5tL4XPz3YMzdugX9sIo3zUwnAMyCuF2UoQHZvsh?=
 =?us-ascii?Q?sGXLXbTpBL0WJdO6HhDPAeEEWqVg6tIZ6WOQLp8YI1h/Z3SF6Z+JG51fPnSa?=
 =?us-ascii?Q?5akh9+sEcn5xz4tIwWR4NLYuC1CbErR/gwCjuhmFmLODKl7IMjQ6EA7xNC9K?=
 =?us-ascii?Q?cFRMN4xbYrU8jPtdsKf7OikZvUm4YBi8Lew8edncPKkg/SEuJZ77RBE+AT7j?=
 =?us-ascii?Q?77RmEIgwlscEgYLTr0cAONaDYYBT947cZbZz8fXZCmOS+VyD/HRiZYULk3x5?=
 =?us-ascii?Q?7hr5G0ebBJriRahHsvIdcq1t7x4ariv8zhY6itWxbAZAAHk1D6mvFe3NAsmc?=
 =?us-ascii?Q?qO+oS/tGoRCDqWSzLjtlt4Ha5DZ9Opp1sOiIvyet30ZrXKKKPPr+nDYUdPu6?=
 =?us-ascii?Q?DoKg1K4LjHJyBzRnq9NfY4FL7SS+oXwAGzVuaIU4v6olrwYydk8H4+1fdwUT?=
 =?us-ascii?Q?61nOGYw/Ckvv+4RFmB9lP0kkiGw2LGGoT7EkggrU1n4Tw5Wd6g2UsGT1gzeT?=
 =?us-ascii?Q?tqL7Fjn8JgJF1LJjhztj6v4mFIBxKmpIEIQILjOwryyd0d+llJKGuI6fy7Z2?=
 =?us-ascii?Q?z9rBqg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	odvbfxGMjr3qyw6X6+OyByZlC9YWUjJFYTcX8kVzc9aCBQ93+gM/Sox+kdboRPqdEU6nxZJX/RUVD9P971j/2CJJgDV9GD6URpjob7AP1OdMf7Be9qc4uP3PEb3Ja4AYsOEu6vtCqqZ6mzIewUDWIxe/6hKpTgV0ns+v2SrGJr2jyeH64j2fQAtPGtx1eQaG/zfplkrx49j/ykyH1ZoVoqXK/sc6Q9u8nnbZafQWEhXWEsswxTby0Hl+nYiln4ssBy/ntetKp0JT1UzGQOH0t8ChRfe37xQPxhra++hinuBR/sJ+no9/prwBvgRz2JrJkAKIHfdC6aTC8NYcNNrAW4++JeiMkZk9viRfSWgL0fBlSKaGHPv4J2hGRGk4gEJB9cc+j7NpT2qzV0Z/8whU2eAF2vveBpsBm2CZvBsg2GmnuYv6qRlT2hFlWpG/URJtpXrbV95vPUGaeu0wWUDzdY4qD39fJ2tnXR7/xm1bzk+at38Hc8L/WLosZ9/rEF6NQlC5vHllFm6pWJ1sNbAj6g2aycOycRP1KbcaGGvdd0KJgIrtnq2TckYFuPQnWZ45bLx8cAkW/CLmQoWzn0BS2C6YseymtZHDX5Wy7Xlzexw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf56123-cc18-4064-380e-08dc2698a63b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:24.7717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8amKm6GdE6/eBqFSx6xrugGJlK1EvZF4F53ZOJHTF65G92UOqf/WeX1bSQjuEH12Yjzuhy1caVJNYQFypKbBnZmFSuNRKqWBU4MaFjnjNOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-ORIG-GUID: CqirqhXyTKjovczGVaUShDi7GblgjTI3
X-Proofpoint-GUID: CqirqhXyTKjovczGVaUShDi7GblgjTI3

From: "Darrick J. Wong" <djwong@kernel.org>

commit b73494fa9a304ab95b59f07845e8d7d36e4d23e0 upstream.

Quotas aren't (yet) supported with realtime, so we shouldn't allow
userspace to set up a realtime section when quotas are enabled, even if
they attached one via mount options.  IOWS, you shouldn't be able to do:

# mkfs.xfs -f /dev/sda
# mount /dev/sda /mnt -o rtdev=/dev/sdb,usrquota
# xfs_growfs -r /mnt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16534e9873f6..31fd65b3aaa9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -954,7 +954,7 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
+	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
-- 
2.39.3

