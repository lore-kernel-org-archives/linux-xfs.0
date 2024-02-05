Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFC64F218
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171664; cv=fail; b=FQ8S4zTPwhlbo0X6YqwXeuRqwi8YcNt6gRb88HZzM3abJeREATNhNPme1K0W9CmXeDU7VTXzZLfHgCxPSb7mFpqn+IgmdOwUg5eGov4JI5yYT8QGR7wMKZmRVgehNNr/zjBC7EWNwqoaCriD9rSOxUwYOpfKkb2pzgnmc+zvuls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171664; c=relaxed/simple;
	bh=8nJQ6Xfyu8kIESNGyxqX/d3QyLkc7TMEImcDNDV1sOE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PAn3AzHpfVou1pJSFdnw4cl9WFotb9HPYPEj51cWxNEySSn31YaOI1oRgHlvhKv/7g5CXCV1JLA0LbXBsCYdPWvGiTTNgBaicTP7pcUbi7WadHGbs/761E4yH/NHfl1sCVYka/RJRklReEVozURgod/pwVJrFYHqrICl6yyrl6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dBJmVwfo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uA3jpHAf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dBJmVwfo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uA3jpHAf"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LFnxR018452
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=ZcVg6FhlIzOzz73xD+aGgcmYSbYZymJ/o348m+dO8uA=;
 b=dBJmVwfoBFYl6TcGpZb0mdinW8XR5BCu1yQ6IDlW15sXF+8brPDuQyisHzn/GFoB1mom
 gZF+CgHHHkB/deW7GGftjQRVNluOH7kJu0ldI72tgc/SOsDhyR9mMzlqR6uGJc3cN5Wr
 2SPw5z1Z63nUyEO0W284CthXwDzvQVRafQtBe+TcrnLipFCNCXR31SlDrqU4pOW65wx6
 JOMItGsqJjrH9omsvz6r4qo1sDJHq38alZOhZLwsiYkWH1DVBx2JRZHk6dunjFplCw6J
 bctpa5UXZSGW/IZgymw5aCZqrsGf3qYhZKcPu9/Zra1udzZ26ZhDza48BoJeWkyEcIqu dQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1cdcw9pu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:21:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415KW94Y039512
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:21:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx66890-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:21:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3tkWM+9mahQW/RTQrrUfHEPt9hGPHBKE60mQZdCkxDuFe5ivylGRn3BvDF9jQw4xbLlhsjlqV6xUElV4flITXTQsHx4X7IsDazwCLfpr2vl9IFkCGY8XFbaPARM+cVSUYT9wmvGL7Zm2OVE268FX1iK2+OMUlvX1yCOz3nS2GfKLv2kJI/vp/vXVmEa81WoMDI1HvwFFD9Rv9bnyq58JVuLNKJwTey5IzvEh65LMWfL0HLxVWNIEBaIWy66JexUtX1gHLNVZYzJn1s23SxmAZ0iU5L+iU/paEM7vDV5ZabR5oJwSEPFIV3q4rymoztnt9Msj2Lkxnq6XWWOd0PA2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcVg6FhlIzOzz73xD+aGgcmYSbYZymJ/o348m+dO8uA=;
 b=EWgn3yHin4As1IyNzVBF31BRv++uo4dWVYpSrgLgjXixpv0RS0W0InbHxcazgNMd96ZLH8EPeRcM/P1cT7cS9+Pq0V9Ufzuxxc/bD0sovKtoRE70/dhve4EIFNTKFy5/Whr/xJtLoX+gqlKv3yK7hgUvdSM3wMtqatCjl/Oq/1xMSPc27CQc8c5kt3r84CqwYEJH8jpnWhMUDg07SVvsnSJS6N6TuX5ohprVhJWM5J5+waE2/jb7tk2WH7/o3HhD5BEilx0TuDwSG7kAEVyg3/QF9afI5u6RbRLx3iX92F+sGBjGgfkMoKCFYrl5DoQHeQziYz5z8080pBl4wh0QYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcVg6FhlIzOzz73xD+aGgcmYSbYZymJ/o348m+dO8uA=;
 b=uA3jpHAfn/baAj/9GvjPemBbo9KIxW21RrgPR2nVBpijaGCiR00ICv8nrFfeWvBKVU/NA8ezakG6HECqpv2IDmLgpfs42fZE69j+agY1/D3n4HTbh0PnmpNFQEwV9HvOKD4pvwtGUpGpknBXYwadEPMYRcFvvlp3GisulheMAxU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:21:00 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:59 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 20/21] xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags
Date: Mon,  5 Feb 2024 14:20:10 -0800
Message-Id: <20240205222011.95476-21-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0278.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::13) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: baedd93a-8779-409f-aa04-08dc2698baf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jOsEtXVWfKiIVVFyxspIx/+QC2zTtsnLH1y+yDnnn/r89RU4obOLz2OBzZraatDQMqd7QBkKnlHblVeo6j4JN2k21yJ3Trui2TyvAS6++lWKkPvhGgjU4cW0NzEw/GeIVzO9WNcAFEoH8652m54dugeSx9V7iSj0Fn2YkxCbL9QuljE61lzh96X6Ip4UFCkHB9WpEUZalktv8Uk6L+angj24ao3Fk7em3LYi55BHi9ibF4rSj9uwJm3gPXR2uFOFEMFLLXtLSpbzM/Tn7n7I800Btk0dAoohVwKWHdChLLBu6mfg/0VtRuBneE1j9+b+o3WxOkmQek5J9NShw6lNn/ruozJ70uBFFi9DZ6FXPntmk4eUo06FlFNDGA2I6DoDtGqeJoza56kk3g2Jalo/hiJLTz3YoT/axWrZvlFCiC1W91sMfFm8BxSuLwjvJDjl839H3BYYXPy4yt9kYU3PiOFP9x/UXHQ9tSv7kcAcqS2HrtKZ2zO0iUi58iWb2/QsGHzkbkHjwxrHOTcB1XDsiQ2h55+kTLjeE5p+klsgxL4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(966005)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?IdjzWfm1a9OGF4Z1OqRkxVw4syPPuwYY8hSb8EC5uHNs0azWNtqCYJM/Txzk?=
 =?us-ascii?Q?Nsu/VAA/Uhhm7l7JsEidobRxEYJLQBZWlDqzw7BvlFUhFwQMHsSWxCi/vAxF?=
 =?us-ascii?Q?VNMovkuK91Tf54rojktuTNxlrFGmL68c21E6aIYjqn4RF29mkMxz+2HmY8vu?=
 =?us-ascii?Q?KmtgRGIWZOa7YrsqFy4ufS0PaDmL4KgNZIr0HG75TCWU6+uO/tAK+sAaGshB?=
 =?us-ascii?Q?MHmNx9iNzzsmDvJAnOoPFhxIb5d1nV7ECZCN2huQzweiNFw9o7FGDc004vOV?=
 =?us-ascii?Q?AZj9oqu9cQJGDXfJqvwJZaK7zt2vw/XFxukvJCWVmJDhW6YIBJKjNmDbvtBY?=
 =?us-ascii?Q?xeGdvPIPkznH+BOgyBYVWt26oAyUig9lD2MpsujOL7hVdrh+AgSqzhRBJyj3?=
 =?us-ascii?Q?rn1P6fIa/jbtZhl8uSBV6AuOjpt+qCsSJ8a+qo/o6YVSSytReVo9QKVwlETR?=
 =?us-ascii?Q?GiJP0Rg0yBk4ClJR7gxVg98hivtfHc4tI+Mw5VqM0/5cIQSnObSZreU0eWXF?=
 =?us-ascii?Q?hV0DN2KawdhAC7DPYkoI3+L1pOZ7wUK+W0HkjQMEfZUitIpQ/l1zNQvJpn4L?=
 =?us-ascii?Q?FUIalwLdoU5LytMGlbjYIu5BFxWMpCJ7U+fxFJYk52tNwK7UezFRcxOn/RuN?=
 =?us-ascii?Q?YMw7vtuOqwK6ZA5kDecmVjt0QZA5yqzI8tSiwrVktc2P+xruAUnmE0iwNErq?=
 =?us-ascii?Q?gQire9LWg1o/zs0eQIj/e87OhcPZzcfKMFsIu4Q0PqromI/DRF9sPKUpKK2y?=
 =?us-ascii?Q?ooCSGfl6Gwmz/OMDgKKF9v1qLZcFSwzjbwQAni/elwKH+H3PmdqYFBZ0OUz3?=
 =?us-ascii?Q?1R3Dqdm46syySUQrE6w4JkPYUiv5J9C/qcLe18+iox8DFw5LzDNoqSbDQAoF?=
 =?us-ascii?Q?AcybHSRZSYC6Agt+IXolYDFsEprga71OKIkuyUskUkWD5NgpwR3P4fmjLeAg?=
 =?us-ascii?Q?99YZBQ0sAGTurB9NFivGUlgSXm1Jz/bZBpW0IPBhoHTqUZIo+sOaORVlcluH?=
 =?us-ascii?Q?CBoIEsEUG1VXhIzUpBSIop/wvJ5ItEmKhsOk+sBYuIFzSFwQSus9tBmC9sgL?=
 =?us-ascii?Q?ofA7xPgWflnz9mZWB7gm5zLncYSiJii9vRF3hnYHLEK2aeqnMj2CvgXjpND4?=
 =?us-ascii?Q?G6YG/dzqsYaKD4T3KKDG+7Cu3Ugc6Jso8RRh6jF3nW+Ampdv8c7op3NyX6yD?=
 =?us-ascii?Q?C7k86q1V/MCHIWD47MB96Cnc5badAZAExOLKtsuOl0lf8YuoisDXuzXAjIRs?=
 =?us-ascii?Q?drfOlGsC8IEe9LCWDSceRbVICv8QJ7DKak51EmxlP2CQBfQCRhTbW36FNThl?=
 =?us-ascii?Q?+WMTl2++qY9kuOjLuvk+44ytMD4BMPnH0elTQ0igsLrpe1VOjhRWZv0AeUUw?=
 =?us-ascii?Q?lxpNQyljYO07mfGu2LmyGdPmZIjgijz2f6y9OnxqQP805K467sBTUAOhjE0U?=
 =?us-ascii?Q?/mIw8YhIG4twqwtvML/fe9CLAvClt4B5GjCTGME/5oiFtYtNIX8cMgATtIWj?=
 =?us-ascii?Q?ZtiHOuGvfrpIPzkN14xbkftH6fNGhPHZI2SI5n/44OowrZFCL7Tw/ss6Nnke?=
 =?us-ascii?Q?PDgjhY31vYuHWeXM+FD2isKRnndnfqWImndr5itaLh3LCF5Cmj1PBsNyeZOs?=
 =?us-ascii?Q?oU5ueBkzKUVmHYOrOeqshICg4bwDeRdhPRjxDcgaDrZXZdBIdpmeXT16dW1q?=
 =?us-ascii?Q?TVybIw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	3vFi2EYGSyttKxUBK8+HhU1DIxwTy56WACd7dB1oYzQhVQfXdnDYPVUblcmuepWtWBXc6kvSwldLs0xPDJJHh6yT+m7zUF7T9XHEQJv19F+djZ5qZQdU6SgVv/HlgWKKGPxnSY+RBD87wn+S0yR0AcraeN/75YoigW/Aoalme2YdR8b8mVw93PcPCRQnEdCM7P+KxJJpJJgKvpVcfpgmFpTRgSN+MIX3JiwtnnDI+x76sYpDkRETDu0Gt3qO0ew86gbr5T/ordlJhdCI3ARmy+dZQJ3caL36oh6GYrSfptz/6Z9gF9AmTU6nMgVtylGk9LZZ/JRl83hvhtdfmVbWyjEsdMBCQ0gDG8f/eprg5KR5U5Q9NzuP1dXuXdtuVu7pAstDPsbk6vlKfoAHqIQ+YdC6NYDNeYOSuvmbnF+6WkMqnwlt+fdZUqqz0iHdU/f35IpZH1oZqhMFqGwwFmP0xuFykaPeopBAsJV+qUaKfy7faT7kHDT8W21ZGXPUg9I3RX3tmt9ROEBASk/uv5XzrDyIRpT/mdpdSbfO810wCOkT+0QKLC2CgpAa4vBFhOP5xwFnXPixhclTA8lidhPuSgWrmXRo+7ZqWf65x63bePQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baedd93a-8779-409f-aa04-08dc2698baf9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:59.6299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6i8nUBSz/Vd60ieQLZY7R/IzdXJv59Rhh7NEK7g3ywagmBXkVbkoJ8tbkD6pcjqBznCoiMXp50h6LqGLGD0EXOxdkAQKlh1BCqVK9OQ+Bp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402050168
X-Proofpoint-GUID: _CEzkrGxDivQLFj14MEY90jAzA9n0n9F
X-Proofpoint-ORIG-GUID: _CEzkrGxDivQLFj14MEY90jAzA9n0n9F

From: Christoph Hellwig <hch@lst.de>

commit c421df0b19430417a04f68919fc3d1943d20ac04 upstream.

Introduce a local boolean variable if FS_XFLAG_REALTIME to make the
checks for it more obvious, and de-densify a few of the conditionals
using it to make them more readable while at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231025141020.192413-4-hch@lst.de
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 55bb01173cde..be69e7be713e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1120,23 +1120,25 @@ xfs_ioctl_setattr_xflags(
 	struct fileattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	bool			rtflag = (fa->fsx_xflags & FS_XFLAG_REALTIME);
 	uint64_t		i_flags2;
 
-	/* Can't change realtime flag if any extents are allocated. */
-	if ((ip->i_df.if_nextents || ip->i_delayed_blks) &&
-	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & FS_XFLAG_REALTIME))
-		return -EINVAL;
+	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
+		/* Can't change realtime flag if any extents are allocated. */
+		if (ip->i_df.if_nextents || ip->i_delayed_blks)
+			return -EINVAL;
+	}
 
-	/* If realtime flag is set then must have realtime device */
-	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
+	if (rtflag) {
+		/* If realtime flag is set then must have realtime device */
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
 		    (ip->i_extsize % mp->m_sb.sb_rextsize))
 			return -EINVAL;
-	}
 
-	/* Clear reflink if we are actually able to set the rt flag. */
-	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
-		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+		/* Clear reflink if we are actually able to set the rt flag. */
+		if (xfs_is_reflink_inode(ip))
+			ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+	}
 
 	/* diflags2 only valid for v3 inodes. */
 	i_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
-- 
2.39.3

