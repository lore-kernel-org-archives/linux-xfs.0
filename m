Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA17554FA5;
	Thu,  8 Feb 2024 23:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434509; cv=fail; b=ROT2haXKrYW9qzu+EtnV7LPNBPXzbYVQARy41D79p1TBItvXRWE748nBRsR4yE1RTv6TH3ADOhctdw5QsBpnZH8V2iihUilNmSQdhHdfdk9azPpJUAoVbANgTFhF2DJ8CpuWfrNLATQ5T2tNX50TjdA0feMslhg7UuYOe3LN0ZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434509; c=relaxed/simple;
	bh=3lMUzZAHK+2msHoQ60bo7TmpmyS7V5I2V/VT+6KvA+k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z1l3svWQbpMlJJEE9ocwmvMm7vlnsl6SkEEo3DEVhAZK7lFXlB/7ONQ7o17je95L4xDWT+imFptGBlYq11Sw0uezT6eixWU0FBxLcsnqkQMZZkAO6GxSQtrEYq5B2WCAZJ5bCXxnqQfa2evxBsp+Mxzk8r94nQpS+QoE62PZtR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MZwMnPbo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XEAYvhT0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MZwMnPbo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XEAYvhT0"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LTmbM001749;
	Thu, 8 Feb 2024 23:21:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=FpAMSpWVC7cLAdfk8xIWKcSdrW7WX1GiZti4V6f2T4k=;
 b=MZwMnPbov8mB+82YzyLxbJgPiJIBqnR3TSyqYnSq0T/114bAAFYkq/UhIKqCcu+cyCy8
 kk4PhjmbSgVD+pbFgZA2hqAW4pIkNxtEkr3glLspHh9SeRtZYmP8Js7OEa3s4asiKV0A
 XanGtrUq4hz0AMD22pIP0pUCwf9xGNbj75jM26ORmn+7T9/Uo7wXZzLiEX8dX/DyM/Z7
 ViBlfvk5OWnh2JnWnPDIB9LvFPakxQgTBfQgouUMDAQQah+GJ3Cmmof+f3zcJo6pyHsr
 MpLsIA53d/krTvazAGTHPscZw3/sh1PvUpaGzqoBKY0nqlXvcLuEgsrNYimMviVTtKke 7Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1cdd667h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418LeG8V036817;
	Thu, 8 Feb 2024 23:21:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxbdxhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFKHad2kNkKwOY/g7ecAjqsHFUpZAIAK09KdxgE2Z55OU5BJYqWGDuPSJ7qqMXPXQMv7joL6ZeMpN6HhH9Qdp/mmDxY94P6hcNxA6sGE84ocZFMZMA4N0a/smSaeVD+kqkvEYzJWqjPYjohngLwX/xZV1CM/5NI4Iy99qG4BhwFDrDmgr17VWvQGEBwlj/AU7+0lnRdQ9o7t4b521nWvyQnTyd4BEXvJyUBM5roHERq8cATNv4rCqaeuLB0202Z4dhzQZzLcC6+yV4fPKTOp7+OYyx0hDpzXg0Km5T8mTalxZaU4d80U4qU4mTx55RbFOtcHrTaJVF5mkosb07zTOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FpAMSpWVC7cLAdfk8xIWKcSdrW7WX1GiZti4V6f2T4k=;
 b=m/D/j21Ijf27s2TfVeI/2D91ptNedXJkMl7x3VruDZWHSPcdUOE62chZbFjBKC01xTq9naCnX5a38DtKi25QQZy8R/f2uckZRlhR/FsRfs5KGjgkOiPpzpcClY7kcP8GfS1UuVVayIlgpRcIJx3iGLjbs0Ly/+koxEbuPHlO0UEHpfJREY/fu4A4BwsmxvqijSv38T+m/OY7myfsLlCzeoSkp9PV9+basGuM/hJHMqXKLlZmgof28qtD9ux11HtI3i5Yk2jxX0wsYRJaFMItaikCVDQg9+5meyhK1sYzNPBPOsb44iefXXEUhEqHrpeqRMcwATZSNXwIJTT1LMXvEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpAMSpWVC7cLAdfk8xIWKcSdrW7WX1GiZti4V6f2T4k=;
 b=XEAYvhT04BuTyrT1+KDlgbqd3KIDzpr5yaxWg/D73LBY6TCQDhCIyRPhBLb9UUiEUj10aa4uIdNUt9O0KUEU+1Qh2291cgLWnOm1x371jdqiuDmEIMfdzdIpBBkcoO0OvgUu76Xvnsw31oyZWijnvB2RRCpJdaJaCuIJSb73XHY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:40 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:40 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 21/21] xfs: respect the stable writes flag on the RT device
Date: Thu,  8 Feb 2024 15:20:54 -0800
Message-Id: <20240208232054.15778-22-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::35) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 80d214c0-0772-4f4a-6965-08dc28fcb42c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	+h+3bubQbCfMoMMIUIPGmlzEzw2ikowpx58LVDQPYbLgPZQT7IqcQIkvOUhOddmpWTmaXflz4xmL1ncDs+VnF8hjvQj5osMFSn3d5aueHhxiCHcE1CgoNSrhoQn7TiOPlapxotjm47SM4yJ/5z5nRplIsg8r+dVzMoJs5p2dVFIaD56nKNip8bycWwellpVxtPMA6nZAmWDGDUE8t8Yzz6lteetuoAWvYOu62cCV6luEYDgjoVAxH61D5xTQeMTM5PUGEcx3zjzIGR2ZSjlQ+5PWcf9M7T20HCzDwafK81LMqZcdYNoce1THwIGNmw8BKx5pt3Yy/dFGcUD3WWBwdobNaUgh81+IOdUWi9Mpzks6cJkIVXKzUwMy+9YKVQ4Bkmp5ousuTCcQAhlyoG7y/G9FPlatGG48qee5IzlxcPzEE6xur4dgl4NOTiVbi6RtQry5gmaQQM2HAXDv1w0v98UMm+MkmWLu/Yo/UUsu/S8Nw7goejPve3E1eoQPhfrwLD/kfgfF4ay5AoI9zAfoOkD/eMggdTZO44mQHZCAM8c=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(966005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?aGznVb9JRC+aXNsBlj8V7N5ESq2/9Lt4iIdJ3npRGa4I8jNNQk4pIGTggT0d?=
 =?us-ascii?Q?V9A2hNWcRusCiInHKOUmnJY340CI4cpm3dELhtObENuvxy71Jndfgbaq0o6o?=
 =?us-ascii?Q?XZUBDWfJCoMIC3k8QFrIl7a44I3swfFuJNEPL6jSZ7MJSZddabJ8Nfk5egWG?=
 =?us-ascii?Q?6EGtzT92Xt1Or/K2Dguon8yZiULGDPqzsNGCbsV8d7V+7t/GlaTJhGFSxaSl?=
 =?us-ascii?Q?7ZmnIprYZYKKCjA0SwOXGGwHviMos2dWk+qqZwnAgOctEP4TYcSFlKCxtea/?=
 =?us-ascii?Q?6dma2tiYINfStT0Gn1qU4BtKZQoAYWRrpNCi/EKU5w7aZvlFB34JuOJBho23?=
 =?us-ascii?Q?4OUvTZpsJcV6XoAar2NSymxgv0kFl6ydSl3wtviwIHeyBkz4ndGFNrK/GYtX?=
 =?us-ascii?Q?ytTiItolCwi4V3GpJ3WWFpZ3aE8Cdpw8yNEKrkAGc7ea+MXCVI3y9eKqN5S5?=
 =?us-ascii?Q?QSbGbq6nvAveRXO2RknSwjRTThek5mvM7gG8CuCE/k6feF2Wkjnw2AB3FvFZ?=
 =?us-ascii?Q?IK8gVwBu+8DfWlADvtDq2jBO1+3j77ImMDp9yDRh1Nu9KVbIevmnngSiPrEo?=
 =?us-ascii?Q?sAFu3tUZtTcuPpFRHA3nIaSbHnE6c/o0F2fZwvmavkpftUsKA54Oz9rk7JjI?=
 =?us-ascii?Q?0JZR43ML+ng8TlSw2a4Dd2A72wbIppjzyjzfWcy0bRXZ2PlwB0/hmn3Q2aPG?=
 =?us-ascii?Q?2ETsN1hjf5ALf0jHI4411Eg1nZS4bmYyqrmJCVAa9h+wMexN3ZBMB7u/Ivkl?=
 =?us-ascii?Q?Y9tok5Tn/buLOtLful6A+fS0aWqrsln9qpbZpa+SFMHL/XNkwrvomK7TmLmA?=
 =?us-ascii?Q?0hVqOCQDcEBfWTom++861MMO6eRQ1zFc9ZVxZbviFw4TYPHJjhzBY98yyBGs?=
 =?us-ascii?Q?k4iSmGjQi4bu9keKSD9Kjl/Iil/nOMmBGMYxiGTblmbMClz3f9h7O53RowO/?=
 =?us-ascii?Q?VuQ5X5KHGoaRqr3IVLpZrtkpbhxKM4zudz+UdpQLV2YakACNKrbq6c550j84?=
 =?us-ascii?Q?ehjIz42hgbRiLa4g6aEHXfmRSden0n+MVHnUkSXqLs3wpWE079TqOagOBTX9?=
 =?us-ascii?Q?API/h8ybuK6edeZ9N6PGOsw5Tlg8qB8hXaedidmXeq9SMq+x2mbwZeQdQZjC?=
 =?us-ascii?Q?/yl+zjfYl08YP9+vT+y+z/tYjyX+v5QHyfDwgYD6SSOg/Usflpr4I9zdaHXL?=
 =?us-ascii?Q?zcX7eT55uZ0aHdPhLMNHOx2Wfbkv/aa/AMx8/zLoCnjHet96Brn+b1opDjkw?=
 =?us-ascii?Q?TPY5wSaXwXUcjJ0U1imiZoZdhx0BAjQhddv98Tl8bxTQrSP4hJTsCQAZ4CLV?=
 =?us-ascii?Q?9ZgqBdcSzdZiPQTbGL6iYMP1ZAHafr3d3uwYDglrC4h/KPDP17OEyMaSpNpj?=
 =?us-ascii?Q?uA6K9+dLjrXsDFzD7dahLl8eSiEcDASEJqOVVfyxncs2WHc8yzGFIrkmynyR?=
 =?us-ascii?Q?VHYXQRNlOTiizBBS0byWH6EUxi6NbipI1pEWnhXHCXcuUGgGrWIJrXfIbIvy?=
 =?us-ascii?Q?elsHQL1g4PD/dWLmcxBIjWvmRF3N0yxLQwhNKArstZ+h27KYnqdFXutPChnX?=
 =?us-ascii?Q?Y/OZtgSH5A4qbVwt/sRuOeQVRNAXhScg99aAjrnUdzs6ajSCmRjaRHfW2CC2?=
 =?us-ascii?Q?PxpHwymF1uwEEU63C0sV3lzqC805+TH7HX53eiibgEsCn4iIczenewX7lKRb?=
 =?us-ascii?Q?bd9t/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5lWak2RjlZoEM8b90gZOsIDcYKk8L8VXmorAnR3X60SrVtzAMN4RyZ/7y9aKgNjSRm6zZt3H4bkf8+90kuIf1Iyt+isqzY57Y/QWOZXEMwl29xgUmNsCz1rkpLeo2MzZjG8KymCse35oIYXgxj6JszyPE+tBvv4d/+lo7EcJz3LoqpZSd+L2s8/EPXREhdvM/ilYSWqyJXDOPU64/HkchGKWvbZiHPBKDdv9iv1CylWa4FK001qqFm2eMmYAh9jxe0MK/fxyxaPOYMj4ZLnec0QttYjujZSf3e1Zn9ukqLaisd7MyCiEVutEeHiPRJI28P+i9jaXniizvfRGByYpZLnfXxplws0ZiPPZWo/ULp8CVvbnuN6ydkp2lYSAFm96y2nG1VhG4cFBagc9r7hthczZZH76DyXzFBtI4mvzH32qNa+K6Kfqn7GeDSFUVcldBidboZ/kLuc8VCEHWlBeMz+LHoE0WwsJcUfKmC5n+NspaHhkY/BctiAMg9k9iCiJpA4vJQDhsGv271Zo87RN+d2nQZTq+/btEmk4T14c/1Q/W8UUqfOfX5mVSP2ojx0Y/O7rwUjm2n+qVAaLqNVNUyHAngTRxlQ6/QJE/85ciQc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80d214c0-0772-4f4a-6965-08dc28fcb42c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:40.1019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdslSTzcSlyrfGuUHj2c3H2Skckqakmbj2/nFqE+jBIwsITpzi0dB6Ue+XvmjjRos72Zy/h/ug8xKa+ivP9jifVMep9/kA4XABVoI6ZV3XQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080132
X-Proofpoint-GUID: Q06z-LC7VuKTPS9DQo2MFPbZwd4u9R2X
X-Proofpoint-ORIG-GUID: Q06z-LC7VuKTPS9DQo2MFPbZwd4u9R2X

From: Christoph Hellwig <hch@lst.de>

commit 9c04138414c00ae61421f36ada002712c4bac94a upstream.

Update the per-folio stable writes flag dependening on which device an
inode resides on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231025141020.192413-5-hch@lst.de
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_inode.h | 8 ++++++++
 fs/xfs/xfs_ioctl.c | 8 ++++++++
 fs/xfs/xfs_iops.c  | 7 +++++++
 3 files changed, 23 insertions(+)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3dc47937da5d..3beb470f1892 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -569,6 +569,14 @@ extern void xfs_setup_inode(struct xfs_inode *ip);
 extern void xfs_setup_iops(struct xfs_inode *ip);
 extern void xfs_diflags_to_iflags(struct xfs_inode *ip, bool init);
 
+static inline void xfs_update_stable_writes(struct xfs_inode *ip)
+{
+	if (bdev_stable_writes(xfs_inode_buftarg(ip)->bt_bdev))
+		mapping_set_stable_writes(VFS_I(ip)->i_mapping);
+	else
+		mapping_clear_stable_writes(VFS_I(ip)->i_mapping);
+}
+
 /*
  * When setting up a newly allocated inode, we need to call
  * xfs_finish_inode_setup() once the inode is fully instantiated at
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index be69e7be713e..535f6d38cdb5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1149,6 +1149,14 @@ xfs_ioctl_setattr_xflags(
 	ip->i_diflags2 = i_flags2;
 
 	xfs_diflags_to_iflags(ip, false);
+
+	/*
+	 * Make the stable writes flag match that of the device the inode
+	 * resides on when flipping the RT flag.
+	 */
+	if (rtflag != XFS_IS_REALTIME_INODE(ip) && S_ISREG(VFS_I(ip)->i_mode))
+		xfs_update_stable_writes(ip);
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2b3b05c28e9e..b8ec045708c3 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1298,6 +1298,13 @@ xfs_setup_inode(
 	gfp_mask = mapping_gfp_mask(inode->i_mapping);
 	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
 
+	/*
+	 * For real-time inodes update the stable write flags to that of the RT
+	 * device instead of the data device.
+	 */
+	if (S_ISREG(inode->i_mode) && XFS_IS_REALTIME_INODE(ip))
+		xfs_update_stable_writes(ip);
+
 	/*
 	 * If there is no attribute fork no ACL can exist on this inode,
 	 * and it can't have any file capabilities attached to it either.
-- 
2.39.3

