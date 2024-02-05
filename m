Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201544C628
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171635; cv=fail; b=UyQmw6GCBvK0kOxrNJ1Bv27dCb5sExXsK65Vq3MhQzbsw9WGubrEice1IQxu5peUrceNiWoUtR4uZBQ2SAy1iX68KskqIfhbDDs7s8iXktWJQy/q2jnlIn5i3X8Mhe37zYz4qOpTM5P5jPC3lhBpiDtQfzYLoIO93Gd3g4A9XG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171635; c=relaxed/simple;
	bh=6NU8jXfF3y1dMdGjBwDfsEPQOv2g8hDn3+JdauLKzoM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iVoDnZxylqQtDlNMTsCW0Tg4gaxMij3c7kwexwC8haAwwEyLLfwFPYDJQ6LmwbA/r3T73Z90NBM3R2ucqAcNbmh2jepxsmazRZsUB/GXm2IpUxWTyAhTPEg0O1VY8Gq8t+ZXU8TPZUQAyazWvmtrF1UohfZfwfoMoKofKqmNdGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lR17x0nN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Lfo64D5J; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lR17x0nN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Lfo64D5J"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LE3VM004487
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=F+IEb7c+21Wxpkhnb4dFre/qwU36rFvNI+SL7WfsXpo=;
 b=lR17x0nNoSLayDKnth34lzfQCkQfVbQd4W7TZxOsSyAOafaudBNprZWfq18W4b6oFsp9
 hsXl9CZBIOPBNt7g4zHkWsDD3a1xwo+37lGr/+94+HyLhzNw1xpIDdTFPKJPgA0Llu1t
 Vh29VPzBN0EMaP9hDNWgXOkS6I35qMDi8/k2vZVHucWtb8cxesy7bmXYLVxsZUYWoLJq
 vG97J0eTlJg7L5+SGYq7RCu7dO1D5w7fZ+pLXyCkCi6kmOhC8aBd6az+ru+73zhaQhWg
 wBjUn+oIsF+CMaQEexRCe74B49zYbartomzC7JMd90pe/ckaxWuR4er0Z31obMKyaEG3 Kw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1bwen7kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415KnjNq038427
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:32 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6e5es-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+L1tZyvoXOpWIr38MsXuVOa+61MLgtmpUfU71DyVYsm/j9B0ITfGoisM3qrOALrP5XOBrSn+vnREpqxghuET9votQ0jUlbzfU4piZsM82AW+yxEKpZkJF0Q/yGOQBSZ14wbbO9yFZyO2F0qZasJQ2fkm6URhDmUWtjnblfyXwNiEQW9zggwmeWn/cxUfNULhaSLyx7oFiatg/IxoOSRQVtXB5qxGdtRVpJUP1ymG2B6feBNb5434nAaClfepkkcg/aF3ElODDlAp6bhgwNnM6YxwTItK4vXGpcJUqeRflzQImTUukZcTDNalqzypILrbaGZYgYsw1xeJEDQ46HvsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+IEb7c+21Wxpkhnb4dFre/qwU36rFvNI+SL7WfsXpo=;
 b=F8wad8YIJ45JhWK/dFpKJF9X/XVtTqPXtCpD6tdn6PakQn6CBR/ECRIPPuJFHR6+FLUhPmq9e7lIp3gI/BbmOgt+icYCd1e/9+jU9kW6hpHYWc6J0oj1W581wAHQhcD42aihCSQ7ITUnnm3uQXUCcjslaX2LRFqb+/mOVHqec7aC2sNRJr2ZZsQaAm9/w3OBHS3hwfh4abL+je8MkTlgRfg3KqOFwvv31ZtUMvpB+5I1LAupiG/AaDep/EnyEfv7gPn4qUPpt0L45t1uRoh4bzeqUd3thAKsj9AFiJVppqgStviwgaQelNsPX4Dd3d7Ce64TQcgJX7s/bSMUBaaIjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+IEb7c+21Wxpkhnb4dFre/qwU36rFvNI+SL7WfsXpo=;
 b=Lfo64D5JHUiyHHBgwJCF1DV99lxD7gqJjNnzJOG0+g9J72wa66/AD2Tmc39t30gxTJ0knzZoKvOIrsddo6bWTIw7mJE9/EIT4I5W97Ole6O+yelFxMckDZWYhYkCKjYYKphhdDr6/YlvOomu0kPP0i5HXHO2EJA6vouVi6+X+qE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:29 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:29 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 06/21] xfs: fix units conversion error in xfs_bmap_del_extent_delay
Date: Mon,  5 Feb 2024 14:19:56 -0800
Message-Id: <20240205222011.95476-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: e315cef9-b48c-4193-a72a-08dc2698a8f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	gvAtb3A+aGexYBCuXX27I64NJgdmgykwqtRRkWgZjrSFa+jSLq8A8qwNKO9En7ffErGmVpJwCEi9JYQdjLlAcd6lXWp5v12biyL+dvVf/S9njad2f+CvqBqSyVvRcZENr5de1lQIlYRKi+igqDDqoDSMMBJgdKpMEyQXqcSbxmjTdLlMuL8TpX5/zQHJb43xKHVAbZ1Uo4f92tJwiePd0UZdhF8SuN2QIFtffbfMybbsTuhNfR/JXNbeqkl74Wd/EKSQWhk6OSWnJSqVmEaeEnEkJJtHbFoeQVOVHODbADcfygAoEeL4zypCLY7sVShFiHsAzLK9ltWYJsUnnN0HjEeke7HPV/o56p7xTLYXm/RQc5mf+NUtfcriikCeYUrV0f9TxPpQ/QSA6DbkTRRtDr9SXbZYYywr7T42D9EqRDeB23YsfUAPg9GMV81NcIYfEUoFdAWenQPBvghGRRkUCQeLejHGz0rmOa1N+/oKOFh7rv/LEruYbaTtKK5hMPoOXViwoB1Ty/wtdjBpvhyrhiSFT2v79JLb6J+3XRv3Y8w81Tzr8bnBbL69EHCflkB2
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(6666004)(316002)(36756003)(8676002)(8936002)(6486002)(66476007)(66946007)(6916009)(66556008)(44832011)(5660300002)(2906002)(38100700002)(6512007)(86362001)(2616005)(478600001)(6506007)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ZU/4IRv1cGEj5HxTJPVpScWu5yRRT3ekpFQBFa80B9Q4rq1zUS0CD4v5tiTu?=
 =?us-ascii?Q?Ke3LdddGLa7CjkOtUm4woHFNIRybeCczEJad0me+Im4d6ZmLWmOGUkzGnR/J?=
 =?us-ascii?Q?SdCF8HVpcFiSPojGzLdW3xxZ8OuF2DwcHWfyZ1ixhkDctX7+K1N/fz6ouZva?=
 =?us-ascii?Q?EnN3smz37UlQ7u6fynCk6LABc5gpLs7Qopof9gMueuOhOk90kXKHWM8nL1IY?=
 =?us-ascii?Q?5aYHXlU/ADkBdqB3z5DPr6NdwgC1Wl3tIxvE8lZls6MK9ar9MCh+EmWDlxYw?=
 =?us-ascii?Q?29CfMugxH/h8LWZqcidpLCBtp+ijI3rAWcQn+fV/HMLjKc1Epp1Dca8kfP63?=
 =?us-ascii?Q?6iqc3pAXpg/3Xc7GxhcztpqkLWVRnjKi+j/2/qG88tIkRDaVDycxW7tuGtAw?=
 =?us-ascii?Q?0rMpKsxOU6Zdi/Ubkp/xpP2NL34lvRDKGqVVBTm1aFz3fB0yHQnFuUxCtfzj?=
 =?us-ascii?Q?LeEZ9pCwLUfl/ubiual64ZgqVgER12VMToU3AMZ8AR3ke6QgyquNmUE384Vo?=
 =?us-ascii?Q?WImGgQMnV9egtoToy6TFHPS7JDmVOdfmffFtwr4zDdcnfwhw4eJnCSAa5Xr5?=
 =?us-ascii?Q?C9LCWG62VX3Qq9qAUCzJhkQL+MNVE8VUV/ncg59CnRqJJWoHev62NhsXAtua?=
 =?us-ascii?Q?0+L1mJ2Jn/MuSCGXInIpZLFsXsdRB5GqkMheqXpg/BIHiic/+I3HJRzauXj6?=
 =?us-ascii?Q?ooUIPDQfXt+7kPG1neoHI/8/FkrXhvaecyg8ZLuWELVwotH2dRKNHr8kW+Rs?=
 =?us-ascii?Q?NpiOFaDKYn7rUDaGS4XZTkLJQVVn0U81UyUYPomxx4j5PunJpKrQ+sx+FZQb?=
 =?us-ascii?Q?cI3w5+MyY+6Zfa7ZNf9S8nwvJlm/YU4J+itJMkRiclYO42FgBqB1Xz2Q0bRz?=
 =?us-ascii?Q?7BSh3w79nijmJ/XxmCd10qRAko8tMCa6YT7Vxg1hscXPUYfq6nwY/3g0ydw7?=
 =?us-ascii?Q?jtq7dFzrkTlXMhNAjqp0YpeLdcqv9oW6BMqSnnhnAnwpYedm2zrl2BG9leE4?=
 =?us-ascii?Q?Bap307P5AXqxOUe5hnFD9QYOODTnH7MXD4D0rpN+7/0MFY5jPzWdXuGMlJV4?=
 =?us-ascii?Q?0Vwxtrv/RWIkJNbBb1hduRP1dzQFs7lNK6p3ECD+QTvgaCZIMAmf8EcatMN4?=
 =?us-ascii?Q?28kCDyBm2bWidzrv4VjbjeClM+T08Ig9vdhVPx3qS9N5w6RZKQKzqInUacpO?=
 =?us-ascii?Q?j0FsXffbwM3bHmrET1MePIzuHeo8M0lMabheXYFLSYxINgKpsYQZ4Bhbq3Lf?=
 =?us-ascii?Q?TBbYOgSaqiShRdKmAyzPcHoLlOgRwQ9TyxlzZJwU1fT9x6HDXz0xRh3Vmf6x?=
 =?us-ascii?Q?C0nEqpEWJ7HaCTI1qQDJnpSZ0ce3zMXNAV5nO7zHushR0n119yTh6urg47Ra?=
 =?us-ascii?Q?mW6s7VOJG08EhzfInjzyNjvRKX47yJGeHySoAbgj4zdCMcn5EzYQxiGmQU7z?=
 =?us-ascii?Q?hnUx8LHahNtDHhGqvngOSzC6/OIb6sFrU7H8TgUfb+E42g4o3t7gs3udgc67?=
 =?us-ascii?Q?YRD8JjqQzg7e5x8Izgv0Bnv1GxX2yDRKMglYznAIJfRGKcTz9qwvbG4b9DUW?=
 =?us-ascii?Q?ajqvDUQQjNeuLXhDVGFTAYhe3sSQg4IXtrFlfapuJ9U60UVzRXl/fpQBci6m?=
 =?us-ascii?Q?2stJoyRK9jxBCgY+MM0kOMip6vY8wxMPfX2xksKmZumPxHZVk04hvLHwwqno?=
 =?us-ascii?Q?1TCNdg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MSqXY8YGvVhANHphXsGs4Zs3ojm6Bb08y/CxqqXqgWw5VxftBAZkAdbyYhH7JbFHlMMvn8YKGSSv9Hx5Kylsb/jo8TncqwttThzopEdx2A0w84kLqZ7JyVSTeYIR1mpzcqqBlZso3NG8kOJ7suExf1v82Goh4NkfNtQ5szS12M2kgEXRVKrLNAbNsadxzGGFWkfO+s9wolDP7RNZ81guIoznPY5eERO3Bkaforh2dch5c3DQ5qXaigplh1Z5ne7eJnEE67cDYpXH5mhJN4ltEeoRUTQrKmFtvnJGuCK55YAXiRINWQRlcBPLWah8ExIeAAaVfIK4kFCt963ZubPRXYLycTGlXw8STWNKrdbC5F2i6Euadr8/Iv2bsczA+ftZOVgzuddZvsjcfR4KlN8hqNA4yqSLel0qJhm7JjkmBhabUwbic8LqYNJAFcG3FliCyp9oQ9z49jzVPrDkGMYoZ9N2ntnnyKhxgx4FI9D37T1dj8hQ/wDB0r8mq+Nobq/ljdzIy04Hnb8QMqLUwAA6BNezHwibN7diOjS9/Zm0wL/ICga8IkfHXQL6araLnKA+ZOYyMfFbhpdcIBXz6TY1HcXW1q6iNu6z9OS0yFfuVUI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e315cef9-b48c-4193-a72a-08dc2698a8f0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:29.2135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xynYVMHonbjFL65t2jBYX4AoR0QRWOsZFucbZqAd7cdcnu5Aw3Oy7JNz4xuMHLKs77O/omiG1FoeFbLXE7gy7rIzYC7Oav9CHGb/BLhdh3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-ORIG-GUID: 7OwLKqmSaP9_kk-j5fsLXWPjJucVPyT7
X-Proofpoint-GUID: 7OwLKqmSaP9_kk-j5fsLXWPjJucVPyT7

From: "Darrick J. Wong" <djwong@kernel.org>

commit ddd98076d5c075c8a6c49d9e6e8ee12844137f23 upstream.

The unit conversions in this function do not make sense.  First we
convert a block count to bytes, then divide that bytes value by
rextsize, which is in blocks, to get an rt extent count.  You can't
divide bytes by blocks to get a (possibly multiblock) extent value.

Fortunately nobody uses delalloc on the rt volume so this hasn't
mattered.

Fixes: fa5c836ca8eb5 ("xfs: refactor xfs_bunmapi_cow")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 26bfa34b4bbf..617cc7e78e38 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4827,7 +4827,7 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got_endoff >= del_endoff);
 
 	if (isrt) {
-		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
+		uint64_t	rtexts = del->br_blockcount;
 
 		do_div(rtexts, mp->m_sb.sb_rextsize);
 		xfs_mod_frextents(mp, rtexts);
-- 
2.39.3

