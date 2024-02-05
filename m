Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E884D5A7
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171655; cv=fail; b=kLjkd6k2Znh6Y82yhGTQh94hKaqthX7ZzRAuCNjokJNqVwroD9xh/KWPnMrYAA3EltUjn53MRgKybwy3b2sJQ1X+Bc29aUICgVjIJgTEE25Ql8B0QSekcYrNU93w8PLaJSP0720lehpkcxFUc2cCkiNYTjj3HuuiXJuaDQCxKMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171655; c=relaxed/simple;
	bh=tM2ISFO5xvWCfC2gB2gXxiLxNsWZ3FOS97s2Egjje54=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nZF4P9sZ2C1+f6ZxVF3mpU9buq9UzikHpYDipSAK7Kj/DH/ye113wRTJ1DhITfUW716UWLBH7N4y3mWW3Fbi3sIoy6Eghje2XGmccoZ2+AM7bxuNs5cC1L8elix5NgEdqiR0sVM3qh4cd8GnTtxGusJ5JCZ+fRGH/19UE18k/Ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YXId3Yfc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qdNHMZrw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YXId3Yfc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qdNHMZrw"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LFkAX025006
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=6a/Vx+pcL13GNO3xhPo/HMGejI0TDJBNgPqeA/+05WI=;
 b=YXId3YfcFCWr1gNpQ7dvD3myMd+RzRiDAHiGUC/EBRtfG+k7rvoy2EymLOUMPkYvuip6
 g8btLyxJg7DZ78hfq53yzU74QOmKSqOSTz13fLGmNzpk6RpnzkcdwG9FV0SU7MRFHJZ0
 C3NseWik32pQVZIREkQCaPAn8sNfDwu+69OTLkwP1pTi4Fjw0Ut7HDPl/w2tNXfVMjNe
 ScCFNfcWLMBZ3ISFbNWSM26u5b60eHEgyXtRcbzAGHSkKD+G0mhX9GQnynqoLVw+BqsH
 S+aaUhiWhNTPhnA2g0qrxlZzGzHafBR1n75e7Gyt0W1dkG53V7Mg1EQ5Qm1NIX0xwh+r 3Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c32nabu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415KeLwE019865
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxcpjfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIYddOx5BVMUDWjqGoB0iCkh/6gal9m85H9l3kB1lRKrzBLCr8hJdJs0uN8Ee6P3dNYkuo+u8XbHNhW8kjqp7gRdo9pMUPwC8yAs96+NhDDbUcIvmldzy97Lu5IpEBwGNT7bMwGY9zCZsr5zabjlnGN6/PozWyDid3evvksIe9Eu+AK/GCstsmORaa20NuLilzAY8myq1AKjMfnbarxDLVF1fH0zFz4cTawkPnwmWX8AUp+7V2sca5VlIj6i+SUEkGU9z+q+N/PxQnzISAIgMm/KtLV6FpO/E9Pn3Kcf1iefQJoJJMjZYpSHIM9HOO/rXCHyKV8etZL9AKDQRG5JlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6a/Vx+pcL13GNO3xhPo/HMGejI0TDJBNgPqeA/+05WI=;
 b=aohiz2QO60b0aqHeIq7FkwcVTcVc6caWOWPe2yHc2qyTISErcnuIgpJNjuUZMvWNBFcfQzbxKXDph2bu0Xf+NiMr1PAx+6D1/hY0RWmMPs1/MpisIoybAyQNj4zviA40e1f3LfTKmtmj+2KZcIyBKo0yIF9pi8eYIcHFyLQv505u1aYz/Ee1+abOJ/GlOgmCgSMlWPAk6D5dz17EU+tXOj3QXMZgVGizdK6k/O9Y/ukfMeWGeHZg5yGalmdMrv9liN3vw4jyY3I4eP8Ekv8a9eSibmUfdI3j23jugcQHDWu0TBij/0kh6ZWrbgZz+kjHOeFPL6OTltsx8Hoa0PDkaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6a/Vx+pcL13GNO3xhPo/HMGejI0TDJBNgPqeA/+05WI=;
 b=qdNHMZrwajGzsCJUd7TgTpLv8neIhNmFzhwYDm6RfJd4KxIsgTQKWJ754Jvdav4/vy0WShiGSqztgzpzoZKCg+hNSDrwgG2SsCUHxyLtVREOKwK63QfCI2zlhdjxqiWNbslyK8T25fJ2+0wgvhmDyC3T8oxqy3u+0s6PsoZt65A=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:46 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:46 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 14/21] xfs: up(ic_sema) if flushing data device fails
Date: Mon,  5 Feb 2024 14:20:04 -0800
Message-Id: <20240205222011.95476-15-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:217::12) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 68e83d20-bdeb-4a4c-6211-08dc2698b365
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xynSGBxBqoq5Mr3pCUjpgxW0G2a3nwRaDcmp/VwgVDy8ctwuIdmxOE8dky1U+0sQGjrc43IP5iyiN2w57F8fuleEz09RhPz0AGktfrnyDFtpzEJfB4JI7SQtwD92hN+vugVejSUm39QiXsfaTV/ruVpkvxWCnGEtb46wOvFIKY05iUaqI+n9GAgvkrzXu+/dpczRQ5nVOY4BQvaryG6cojRMc/qRR02tI89QpktggC15SaUQ50j15aXkhOb3yq3zFbOGqIB4ECcqibHKzZgmIfdpIUb3Lbna21RY8407hlFiWmadJnsbgyPrg08+G4/2ajvulGou8KstNTH5kGeo8BzW5GoEzwP/QM2FUZNpOJK+6gcxfRZ0xzS0cwIpfd8frYsta6nS54/FwVAyNGa5xH5eOxQlJj3YDJb4qhaO4ohkpm8u4DDrKGOZK3ltTSmW5jmnKXS4pvMfTo7+OOi1ptK4Of6Gd9QIdBVLCVKZU0MTrWfsPyKdIlJviwB9lvDH3odmds+LucuKutSyzMm7VJiRh0bffCHjx4vav5ToZt32esG6m9WsBdgUERvs4LfF
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230273577357003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?SuYsNLCqu9qpUkekQGazgMZqubKtu6flhczRtgl7lV747zFZpuBChV+gtmO6?=
 =?us-ascii?Q?vBRtZrLMWzG0RyypxihBQNq5frhRrjhShASM78OSVT3Wag7BJCJVYaKnU3IV?=
 =?us-ascii?Q?g5u1QafBix46Qe3HTWAJ43N6dZhwPnerqceDFQqG1+NOHAZYa9xi54hq4We4?=
 =?us-ascii?Q?b+o5+Eu3i3fsgdpn9cJLSjdhAf1UaMEoedo/f6zm1QjgISRBVWaPmXP1kiD4?=
 =?us-ascii?Q?EIPsFHS9e8JMlwDVFeqxBhAzCJiT3u+YOnbq9xR/DRc78T44RNhIz8ieAySE?=
 =?us-ascii?Q?yoTQTY9jC7539HuG7IH9y8rmHiAl48ImClFsoBWyIky5ILSneiONu6wnjrdK?=
 =?us-ascii?Q?zvgCQf2u8pprDK64e7nx9tOyZu07cLCaa54QlFerVbqh8Z66K4dgsJKPzXXD?=
 =?us-ascii?Q?EjdcNmHrYE2O7MRdCldL/2awgvOuz2Tlo+CPG0Djaob2+dWtJT1Ga0MOOygE?=
 =?us-ascii?Q?BRG4H8lzgsInqZHtoiU1KJLxKYcUeKKZ+gOb1TH3d42Zsq7UMojX+jziKr2x?=
 =?us-ascii?Q?hyGh3EqD+qwoig0JL3wl0z3VhoEfbl8I/BS3kqNyY5mNGlJjAp2FCaRmjgAe?=
 =?us-ascii?Q?eHaNeuRwhjr6qBLCKAwIg/ujksN34vI7oiNjk3Lfj9yUhvPVovazrADOmzIM?=
 =?us-ascii?Q?Qm3qc0awkQ+VNxSADcJ+yKqMWEAD2/C7DnBGFPpe/rwFQ3nIPkmKxXme4bE4?=
 =?us-ascii?Q?zztTnURA3bT1DV3sncYnbLFUaLc4xi69JkiIdc0k+J84RD2N0joTG6pxeLAD?=
 =?us-ascii?Q?H43ljHde9jPeiI9a5dRhskgi+FPb4G6GMIuQZS8fV7ii3mzRTD4b/8xOL1Dc?=
 =?us-ascii?Q?kr4rYnQdgho5VADa6Hzyi5W5mZ3mpMYvRUhwILv5femxiXugwKm8nQocXkSA?=
 =?us-ascii?Q?bJfXVVNClN/NPVTiDA+VQ6lNpncPPMiZZL77Pv3dMnYj8ld6Mbgr8Hsa0dA7?=
 =?us-ascii?Q?ltjn/3Sm+Jnr9nrvqRneTqckFolEu4JLPu0TNY1dAbEOmGIS8NjXfGRDMkYI?=
 =?us-ascii?Q?XNSzYuJesSY91Fr4/67shc3QiMVus60UuMntfTqbZkT8zI3VhY0DeBz5eh46?=
 =?us-ascii?Q?8dHJTCTXjkPpe168GAFntgRwqK4W1iIA9KgDfMS/LvEv8ijAOFIS8DkyBQ6f?=
 =?us-ascii?Q?h58c234pHXYPvNn8w4rxxJBUPPCNPjUbCxbTlTtQeDVmrxiz7uAuFp/uBzmv?=
 =?us-ascii?Q?BZw34eif7/yhFqSPxqKeJywPWIso2BJsufhT7W2pvbhMqimSvQLf4NIgxTpe?=
 =?us-ascii?Q?Vn0fRqZcZQPNmt2dXDwTsJRaWx7tzuC0eA+g1g+6hLPO1p34P0ItttNsH5fu?=
 =?us-ascii?Q?Ijz6Jmn0EaCBxbKhDIVM1XLuBe0aaBT2DcNqZZkSaCBZEoXQLoyqQxMOUCs+?=
 =?us-ascii?Q?ykhLtGOCn5lCHSXa6gdN/JZKCRbpvKFc/49pZ1sz6BtxdySVQDhrj+zN2Fz7?=
 =?us-ascii?Q?XX9lWJfFSRR3wKtNG6vuM0dfJO/O+QyXB+SkSttLQbdqbFSFe3RCxcDd9rKd?=
 =?us-ascii?Q?vOo3mxaYCscOF5ig52g4laXBtjc4S3EvvHXFqvA3xl2MxixOGEq2RhrlOnEY?=
 =?us-ascii?Q?OIkRRTg44ndR45m3Cvfs/XxXKNycPq2yvygi7WEBMKfEf8uCsjQdPqkMhPUH?=
 =?us-ascii?Q?HTz9lufz/gK7Jxs5goQh2PDj0z2wbgDEKM2n7aEBsCBaX8Ws2Y8mPffVe+d9?=
 =?us-ascii?Q?8iT/Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	rwJ30B291TfytivhZw9QJTB1hVwJDVg0Z0L+5InG8K7iyuK8vetpq/HVTbEFCWSkaa8qHGvpPD53eyqydyaU3qHu5Vw+BdJ/Vk7doahKyGbYfKYw9TpLXexD4t8KsJ+1HdkhqM/MKeJ9DuT7+zc+7i8S/Jf4ZrbsZPoAUomehGLNUp8jV/gV1EwYlw8AV0/M5ghGp3wdDWRaVOde8YD5ADq1u2cq9k8hZ1Z8N40TENz4VzLOLKUdCLWKfZA5cltX2nH81jZgc1WTvuETcxWmijWwsPYUAMRu36AIW+OxAbs/0oG1zhDrD7aM/ucHFvEqB6be6Zw4/URwpFS3BQZ9PSy0mIT7wggjyxtux7mXzhga8beFkkiZqXvc99gr6CByLqQmnqxANy3pTRwCU9orYq+KKT6/+ufp+G4QQaVLc7KgIK97zfcuZvv4knY7exn0tCDrxEypjNdzqQdrwnHETkbe/oREmVoalVSs8PyKgo58Tir/j7UKqc4xyg1zT39uP2hCx5imh/a0iuFeej4uZFNnemUpfQxRZ+fxfP5JrVgyV1dN+wGbhj5Ir3ZviCwdtBIlIs57FqWb+W/dT+LHdMdudNW+nT2WSoaEU7ahHjU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e83d20-bdeb-4a4c-6211-08dc2698b365
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:46.7680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5dPBmi0qQtBxUgnKRO4i9q13GQ0zeFKcmqgLij8zX7RmnyHhiGsJvVdmYjw1FtkLUUz01o7o3ENFFU7UNalhgKwPN+arCQtFXcrF5osCzpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402050168
X-Proofpoint-GUID: Sx10WYNE3XS0UEPzhE9aGpe7nQvR620p
X-Proofpoint-ORIG-GUID: Sx10WYNE3XS0UEPzhE9aGpe7nQvR620p

From: Leah Rumancik <leah.rumancik@gmail.com>

commit 471de20303dda0b67981e06d59cc6c4a83fd2a3c upstream.

We flush the data device cache before we issue external log IO. If
the flush fails, we shut down the log immediately and return. However,
the iclog->ic_sema is left in a decremented state so let's add an up().
Prior to this patch, xfs/438 would fail consistently when running with
an external log device:

sync
  -> xfs_log_force
  -> xlog_write_iclog
      -> down(&iclog->ic_sema)
      -> blkdev_issue_flush (fail causes us to intiate shutdown)
          -> xlog_force_shutdown
          -> return

unmount
  -> xfs_log_umount
      -> xlog_wait_iclog_completion
          -> down(&iclog->ic_sema) --------> HANG

There is a second early return / shutdown. Make sure the up() happens
for it as well. Also make sure we cleanup the iclog state,
xlog_state_done_syncing, before dropping the iclog lock.

Fixes: b5d721eaae47 ("xfs: external logs need to flush data device")
Fixes: 842a42d126b4 ("xfs: shutdown on failure to add page to log bio")
Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_log.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 51c100c86177..ee206facf0dc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1893,9 +1893,7 @@ xlog_write_iclog(
 		 * the buffer manually, the code needs to be kept in sync
 		 * with the I/O completion path.
 		 */
-		xlog_state_done_syncing(iclog);
-		up(&iclog->ic_sema);
-		return;
+		goto sync;
 	}
 
 	/*
@@ -1925,20 +1923,17 @@ xlog_write_iclog(
 		 * avoid shutdown re-entering this path and erroring out again.
 		 */
 		if (log->l_targ != log->l_mp->m_ddev_targp &&
-		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
-			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-			return;
-		}
+		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
+			goto shutdown;
 	}
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
 
 	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
-	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
-		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-		return;
-	}
+	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count))
+		goto shutdown;
+
 	if (is_vmalloc_addr(iclog->ic_data))
 		flush_kernel_vmap_range(iclog->ic_data, count);
 
@@ -1959,6 +1954,12 @@ xlog_write_iclog(
 	}
 
 	submit_bio(&iclog->ic_bio);
+	return;
+shutdown:
+	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+sync:
+	xlog_state_done_syncing(iclog);
+	up(&iclog->ic_sema);
 }
 
 /*
-- 
2.39.3

