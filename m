Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4F23C068;
	Thu,  8 Feb 2024 23:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434472; cv=fail; b=VGX/t/yzpi8riylW9KLvI+JhAWcquoTQ8n3Qn8vNJjFAj/68bwYZw+DgyVrq4WqXwn/k34iQI2i26Gdwz60zvvnLiWPmGO9tjgLnh7cgk7ykmeRNKX/MJj3UlmAREm2ZUW9cirQ3PH7jQPiy8XsIPd7VJi7B40dEye373k4eduM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434472; c=relaxed/simple;
	bh=D5nR4/tA2+5YrJsLI9yr7/a/HiwGyGB/Ho9rVCWgLkE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Hlq4r9fg0CM1SBFVj+vfj8U/rPrffJd7Qh9hOu16dMQXa2j5t0k0ydO9qsBclYcgMffdP5j/Td6rRDymNM2p58ttop9CPUYHq4bjLR6CeK27TT1ePSa8VNnIEtq+s9336gsMqDnE9M6D7aRn5N2DGJnVqThyui8hcWvl+eauAlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e2+2pX1M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=evCWGnku; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e2+2pX1M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="evCWGnku"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LTB6t006841;
	Thu, 8 Feb 2024 23:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=rJwtGneOtvFyt57RW4LX4MgCa9i3GXGUh9iPEecNLoc=;
 b=e2+2pX1MQ7hzNgTg20NSvYGmGutRclgHlO0tqhpsskuFndX4QP1hvRBhTMlPa4zJR0ME
 oOQQHR3T2Kspbofe3UV174YaXgv2Q9fgrB8/iQEhSpNUvF2f6wEkswKw/cg+TBdK5ls2
 E8VNA61ski5HuP3vzt5OQAoqdX/I/GkFM3Qp3i23ogqO05DLtgCYM2DuL6xsX2Q2RiMB
 UMijUKzwSxls05/yMstB0bLxStWXMvOBZvSOMiNO68StxJwwFghnbrG7QatlaQU37G0T
 TXf1TInFJEGX6faZvIpGLbX2Idc7izjfrfBhT6pKnKfLqBbrVHDpwBZJewnTNXpOjyR/ MA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dcbnynk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418Memv8039467;
	Thu, 8 Feb 2024 23:21:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxb4xu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnpwnob17w7HWhjxF44+WfQznbWmrElK/evQRwJFBFlTYfMeDIUbbDrgbT+FWmcxa0CAimawINzMWltRpN/9nBR2vvONLL3iBPF4oyxsD4LKP1KQlR++mHk1m2vNh8mL/jUbDgHPU+yf5ff7TaVOSpWmL9cmV20Q0ZUZFxVUR+O8aAi2m0h2WRmvajclwYIlJHomOjcPSTosh93KxAQMpQ1AUjSmEz0/z5bKwYTdYydsiuIUSfrzsHSbmwBCtFezk2kawy4YRWWojyuRNvfQdFjpMmn3K1LMzwPLaJivfkdxvaBrf5YWWRt/25RjFx3QyTCPqXGcRkQfuTguW78SoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJwtGneOtvFyt57RW4LX4MgCa9i3GXGUh9iPEecNLoc=;
 b=QyMVr+xbaps/fh7TSp32AfdCkvexBvXMRSDb5wrc1h8AXI/o2bPkqZlgNF389NqHRRNbSdhEuGIK6NGmZ2714OxsiT/c4j+7lu+45SBVthp7XY6uGzQuK8Guwi7WfA/4qvDjnqNsnqdiLmKMYgHxrj7FlK1ApJGQr3erL1pVqAHD2eR75fzaGoirL25HfDn9cFqyQL8euJ6ntL4NZEzXaV18wTAzI9/+Dv3iFvQZg+9Qgghrkk1pZwBkpwP9OGD3xwVI+Wymkrsl+WvqwH31HNTU1k+/D83d8ltG6xGUwDlcVq7N+gdkYqDknJC4YY6MIdbZ7O+juGULRDEwYPgQEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJwtGneOtvFyt57RW4LX4MgCa9i3GXGUh9iPEecNLoc=;
 b=evCWGnkuFwjEfnrNcuh3CMs2NvY4s8tCA1o7Pz7N7p7bsbMaD09onmvqOw392v+yisUx2KeSNKsowrw/zHP8V3Thesyv4arNjz1JpSTyWtUGpjV2j5eGNo4bO/ZTVRnZ4g23IK13px1ExzuE14Tn0lpBJPWIkj/sG0/cfYJxVko=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Thu, 8 Feb
 2024 23:21:06 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:06 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 05/21] xfs: rt stubs should return negative errnos when rt disabled
Date: Thu,  8 Feb 2024 15:20:38 -0800
Message-Id: <20240208232054.15778-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::32) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: a66109fc-136c-48b5-4015-08dc28fca043
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ERUI48UjVKiJF6lzVVGD3SSaVlongmMwGeXHduFz+/tioX9JMJuhIahfGrofS0PICnvPFU6fDinD5keLQ1/tDMqmxHfH8JzODjwvoeGPPOCPQ0ISOrPC9L6LMoTbIGd8W0TSeLk9c+3qW6vA0QUv8030GCrrVcafiq6KdcTg+xQ/SLj0ZzXsu04n+T9MdURXJS5UnE14rcg0vK27s2iVRu9xgUmkVpKofAMmP9jqYBHHOPiDdMrQEaePahqDfgoa98euwEZfBL0/xTrlr5lkt2zkzpLbHQZjO0ScoL4oE3tBX+/+Qdb71QBGpJ0inRwiIzNIFZUtfbtqIU2Cf3OvyfOwQm2Z2sC3BXertcYrLrhT+sKI9RPlrTk/uptcNnLRbn2Wm3SQnP6Uvvh3VLDSRGzN4/I3OHXXdS3rgZUpKrIgRkcj5AoQGXanvBMU3ViqUKV/sHQxqcdnEZLIGpootjYWCzo/P3t3WbFh+PlUVPrIiTTHyxoVt4mr1KYYZ7AAr5Kj5C47JnN0JHj/I/lDKDAthdZP4YKluS7c6JHPupfCA5R+2UoH1XS3b7v9sqWC
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(376002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(6506007)(4326008)(450100002)(86362001)(44832011)(8936002)(6486002)(36756003)(5660300002)(478600001)(2616005)(6512007)(1076003)(6916009)(66946007)(316002)(66556008)(66476007)(6666004)(8676002)(83380400001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?IUunoGRooxirkv92ZO1Nh1rt4sBbKA3eaWlRKhRmshMCPdcIz5gzAsYbRjDE?=
 =?us-ascii?Q?PyQPgEUiCc5FQF3DmzHlVz5kZYMkh8NHgAh7ko90UXEcnL1+yeH8lI7ETAW3?=
 =?us-ascii?Q?aH69KZTOHIXiSxxMU71tgSRriVMDdMWZsWlbsQp45xfyAZYiEavpqZDjwM1+?=
 =?us-ascii?Q?XI3f1guTknIk1W6KGZPwJ3fALUptgBIx+zNzP0TCixys+CSEXKJod67+S003?=
 =?us-ascii?Q?M/vQZvKmMTAEw/Awwg+wH6p1fBmbKjRz7c3i3LZyoapbxXTDzQKDCP93q1mj?=
 =?us-ascii?Q?Zc5WzY/AEMyaLaEEbkuQazM+WaTvSrd3His3JSd+TqNPuCJxYhsqdGdrRopl?=
 =?us-ascii?Q?SI2jbj2RkKLiQbR9TAI3XFivcY4f3E5OkQjc+qAzM60SxMIdvcjh0RioQtQz?=
 =?us-ascii?Q?Hvi/k/FyuY1kecUR0mLO5Q1CPmbwRjXvsW9MGUQJX5R396mPxaMd+dUHRx7E?=
 =?us-ascii?Q?zDsbUa31p1QlXUJUJMWPYE3KGSp2VOR/2gI0o5dCMiJV1cc3T1nKcICRTlMw?=
 =?us-ascii?Q?CRIXFoDV07Jj4P+Xm4OkzU1eaDbY6b3Pv7ssC/gf6MXr5VwmYBwdaOQqWb0c?=
 =?us-ascii?Q?2EeyRm9cw6CMG62DUeKypPSVF4c8xJmZktCk5As2qbVBqcf32eOrJ1FfCZIA?=
 =?us-ascii?Q?R+dzN+Obzbvf9iicmQ7Bl6kKVYVrFQSpPscU+xtNOzbl9vU3SqGiQq9lOp7h?=
 =?us-ascii?Q?wH7HVAGGl7A2cKXRzlxn1s2GeesnFDH9jaWcZy/jgTqSsqk6ORfBsHhKvRv5?=
 =?us-ascii?Q?6C2z1fO8fjf+JXNplFNvilLSVkvQRBBsFk8NKomwlwE89OyuukJIKXUbT5x3?=
 =?us-ascii?Q?DkzR3QKRvKzGyg3Wy+wgLxGHAVUzNsFknDVnnXylFgaD0V9GwM1V3fmklfrK?=
 =?us-ascii?Q?CkdT7JC1HAfyKzAQo7zOUBQy8n4xO/UyndQOjZZAjCOihOKw274UlFZLi3cG?=
 =?us-ascii?Q?Eu7w/tDybtWVAGn1+2J050Vg7J9GiSLWKQ6xdHL37h1kBKQF9sLjtQkqEGpg?=
 =?us-ascii?Q?O2Hyy2V515sblIipG1FlArRgbx06KTgBEPYvuWnLaaCZRrBp7+Ia7w4zETz1?=
 =?us-ascii?Q?XFHCIcl9REy181tBuYeBhGByiZ3pIkQhFX95snJbf0FYq1o3+5Sq8PuEKY7q?=
 =?us-ascii?Q?dkCfNjTuXZABJJVbMM45hlo0Xy3nChmTkdCJbTLyBmec7RznchnNByvS+655?=
 =?us-ascii?Q?UywwOrh3Qzaa5aMiHP9KtZa4pfE3CitGcULbz5dP1HCp9yuDv7+hbfMegubn?=
 =?us-ascii?Q?WoXQq08xmyM7a6NF3c6xJx4w02+dN/5rvSKoHhfxdl8BpfK7wiPyyo7iujBo?=
 =?us-ascii?Q?BWZ9d2Nspr/Z4rTJH4VZbqPAgpeuLNsrFUL/cGwytzNp0fk35A1olhPwEHxw?=
 =?us-ascii?Q?IJSApsmQicYy7zF3ZKsw2nE/CPdKMqhcdY5jr2MMxwX7uhceAMJdgIexIDJA?=
 =?us-ascii?Q?FLed31OVSl40NMaha9v6mZisn7XxaIBeWpDhmv4cBceu+xJN/Z0m18bIy8it?=
 =?us-ascii?Q?wPE7okgAiKa6qSx4BhtUtbQLZqUkK5Qj68JkiDgGMtlVB+jI1LyQOlPLTzvC?=
 =?us-ascii?Q?33y4Q3UDCpiI9hlIJyGX7XNKz5NPGYls8X0wjATLiT8/GXlUQlbbhRu0zgnv?=
 =?us-ascii?Q?9M3CmI7ExMAr3wfzH6g4TyD/lxGaXG/yyQQRGTqdA31ru3DgT9mG7kgfMxUP?=
 =?us-ascii?Q?2T8h4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5xeN02i0hTUhQ5t3Y7fZiIOeddZRaewK2gz9NQZPngxCqOIbETh7pobotGQU2BA/fWQEefCnrTLfyvBXUA8O5Sd54HC+W8KJjkfoZD1jgsZm7oFqx4ZE9ZeYK+DhZKWG0JJzyU3886eFAUSZImZOEIKLU0JZJ0KHXXiRCn9jIKQw5fJMmsBrXtxGronNzG+KfFxyGgfXdyRQrmxvbbHGmGt4n4l6mcWIxPhPxuqU3S9BUa805Rzy46wr2++sbHvkuRttjBHSiok9IFYINnkY/9lhI6C/VmQJ4v2tUgS7nN1eC/NyFR/LAuSEt4AUsPdEoXsQTVHhYaxlkFXygMMjBsERf7rTtxqvKOil1BPJwOyYJsUsihM6pT4op7IMhwMkUtNxEtGMepOasCDI0DfLplKfLaus/cW5gNxH6Rn4A74CIwNfzrf03EEzqQUQSeEZm900Bdkh2MB4x02/O5svUrBGBx1sPoJxbcRCH3smoiTngYhiFnYNe9gNJJsGOxzOGwyfR+UYPOiOFM3kbuwIgKGR86qTjVSVFJ8OdvWHwyuYnc4oFBKH4xh5C43xJEShnJQprRSoOMx57V/jG6eibI55LwUPDBGYeKcHL5ZaS2w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a66109fc-136c-48b5-4015-08dc28fca043
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:06.7088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DTdU7C9meyKgxfXFatYS/KBZzsJP5bm+i17Gjvw+cUOAWKPfxmR5HdCSizeuuElBamifpq7I7RsjwDwqkUWMm8eavTGZlWgBx2crfI0iziU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-GUID: oPuGFiNcFaZu8uWviANVB42evMQVbTP0
X-Proofpoint-ORIG-GUID: oPuGFiNcFaZu8uWviANVB42evMQVbTP0

From: "Darrick J. Wong" <djwong@kernel.org>

commit c2988eb5cff75c02bc57e02c323154aa08f55b78 upstream.

When realtime support is not compiled into the kernel, these functions
should return negative errnos, not positive errnos.  While we're at it,
fix a broken macro declaration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_rtalloc.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 3b2f1b499a11..65c284e9d33e 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -141,17 +141,17 @@ int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
 			       bool *is_free);
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
-# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
-# define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
-# define xfs_rtfree_blocks(t,rb,rl)			(ENOSYS)
-# define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
-# define xfs_growfs_rt(mp,in)                           (ENOSYS)
-# define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
-# define xfs_rtalloc_query_all(m,t,f,p)                 (ENOSYS)
-# define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
-# define xfs_verify_rtbno(m, r)			(false)
-# define xfs_rtalloc_extent_is_free(m,t,s,l,i)          (ENOSYS)
-# define xfs_rtalloc_reinit_frextents(m)                (0)
+# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
+# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
+# define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
+# define xfs_growfs_rt(mp,in)				(-ENOSYS)
+# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
+# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
+# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_verify_rtbno(m, r)				(false)
+# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+# define xfs_rtalloc_reinit_frextents(m)		(0)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
@@ -162,7 +162,7 @@ xfs_rtmount_init(
 	xfs_warn(mp, "Not built with CONFIG_XFS_RT");
 	return -ENOSYS;
 }
-# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
+# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
 # define xfs_rtunmount_inodes(m)
 #endif	/* CONFIG_XFS_RT */
 
-- 
2.39.3

