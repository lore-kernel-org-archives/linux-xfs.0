Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420B96F520
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404478; cv=fail; b=tOIow1RYO1c1r1+b9QASwLFLSPaG2J0F0X5ICc1fOemSstnG5pWz+eEYNeIiNTxbnyuk+bPMiyJ6PN/HcZzThmUdXasJRw7DSlTX8I9cz/qear/B0ksFgKWL7XaY7OI8GDgm59GC9Z3Z4p5XlJH5pPqE45ar5sK5us4eIM9htcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404478; c=relaxed/simple;
	bh=8jwYWjKCGerZKNTDAj4pgA981/Uk5vxRQ5Iw+NYe6Lg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SO2lV9M6MHu4xvz2Jdw0091T40YL0nKnAtQxRC1jrBHkv0LuxIO+WdSk8YOHlK+FXo4QA+2FLYgdm+yfbJTrCyhNYAhuL5+SPsi1G5k5+CIFaVXu/ALSz5BPM8mj0rtygn4YIcJNoFDaeTZJuFsciQ+KWn3c7Bq8pdTNUDTHefI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bqPAMiJG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o4b6BhLq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bqPAMiJG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o4b6BhLq"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG6CB027956
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=GK6yV6IozZ8z8Thgwvvd5u2CNWQFZNQxIdIBgqY1TeQ=;
 b=bqPAMiJGA60hF+i7+fe5vYDgrKifhOxhhp84TmEpsHjg3Etjwn7YljkFv8KpT/1KEPx+
 KWxR270xFjxXi91pQlBqXR7olIs4v7d21FO9igE93R2zRQXUkEXhIioSACBZyvsRwdbG
 bndbzsQ7oRUdj/VUjdMZT54w+nVG5PEXPenrpmNDP9AbhnzCvijVbqQf5+UZ37W6PwlL
 14qZIMl8inMHg+zfzeQnG/HRaGSO+j1TvasQGxOowt0GspDn3El1qQFIsVfpvz//j1yE
 k780NaxnF/rAn28CkKbXrk0N5QJZgSePRqaIqKd1EDH3mqxliD/usOxY1m1mml1rRKtT 3w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybkqj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PK1FAH007164
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhcctt7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUDO9Bi2UfxUfGzO8e+OlvxF8sIoGTkktw1ZHG9pB4Qm8/O/t2UFQwh0xJktZ+Ph+++wIc5tqHAKkPTBGM1Ajgyh/E0NTcju4DW1t+cE9DjfBG7DvX35AqffHiOmxIG0CzBtLXDed3FdmvCS9vbuySVypQr2XAKzAYg5cJaXcRKXy9YDnEvVfNPvIxUL4mliTwL8DeOJc9kywtrFlEMSA8GbIJ96+Fg2xg0s6X+okC+zqFwtsWey+s4oyLHtGXVpBwgfIdEc8FXbrZYtr4/dc7xx7H4kKS8BWjjQbr3s5clFKFL9y2kpIeAG8WivOFk6KAJjiOI5TqtzovVQxkEcZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GK6yV6IozZ8z8Thgwvvd5u2CNWQFZNQxIdIBgqY1TeQ=;
 b=mxKBs9jNUArAd2j69eWbdTsX4JbW74zD4uJchctR+TH9SqRC0wDMYMBhhFMJ+b0/hgHu0ULIx1cy+pP/ZfM2BcpJn/1Gt0ylu1iz9AvsaTtYO5vfy1ggB1sx6hAIA/shgLWnQKCJXWLwOiKIkFsnARXPLw9QW5fGEE/b36T0TQj3GVbShL886C2erh5hWlCqoHLId8eNf66dXN15jR4/3IJOeWKuET39+ChamdXJrKQJ7Fj1jeppbFvF2bNunPfpfjAQ9REd8DKJAH+88NOXf460c7Tnz5v8/Jg665RaLuznKc0YvEBuo1ZQD5/Ab1JjN3Slh3weBM6H3sdcXR30lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GK6yV6IozZ8z8Thgwvvd5u2CNWQFZNQxIdIBgqY1TeQ=;
 b=o4b6BhLqgLPgsfHQ4TOD3IoRjXwRsgwlliBOYXDptfowxjfSNAY+/I+ATsq6OqACqfwiQU2hqAycWDmbAbAuwmmxj8l0dMGeUrkK/e9LgJNct1VapnclCJXJEKdJ8ikGNtFeR9BMLXE2/VUkOD1tTYWcCVmj7A4VgtDNnRMoWtM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:52 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:52 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 09/24] xfs: fix 32-bit truncation in xfs_compute_rextslog
Date: Mon, 25 Mar 2024 15:07:09 -0700
Message-Id: <20240325220724.42216-10-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0143.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::28) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS7PR10MB5005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	FOU4ITk1QUJOzxsvM9ntGdJUPZFZ5qhJgE6ZTbpxs9X5Rj9OBtWsBPeQQq42Bw/LcrLcOaBwCZdPRk26AKVntlBGx64yHtmxpJouhcRU0v4XXUo2uZPfOxibav0KmOApMJki7bmALtESjXs6/Y9YwaAuvxDquYy60+MZjdhn1Z11u9C+elm6gz9WSRdIRNQHPQ/9za8iLe8GKMKSpxLZPO14psTZr6Kto4lmxupUJujLl2d9fG7A7FyyioPV6Dod1eQkC/zVZiI9ZaA++lJtIduxr8528+iLlr0fkxJw9/fQmBgeQGfrkno/LINLbK56YFWcgSLHeSMsQWsF3gQj1WNfkLzH9OMKrBJZtDAMfFLX1BVHJZQAboaWpYLUEiO08lFF++AgRtfNfw8DPvWD+MP9VSg4w4YvDhEmPHpRVUkgpOKAS6Q/XIy5PUah9vIquvWEmAX3KqhBBAbKKagBPRrYXldQKrZ+UHG/1FJ40PtkfZcrL4SFdwixmRTBuCeQs3ulBmb+6HPnhO1SfXFMrvmOuPMaTBWG4SU7vL1U73W9NwUi0f3lqbukY8Txul+kZ3HXaEALYkzVjxT1f39zfPjKqlyKEhRyGl0PB36Mc5U2Xl0yK/lukJ2TcVSOfKrOSWW/0xBlM4DctkG7cvtfzbLXQgFJnSjd9pu/G1ajHG0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FoUCT9/b2O0WAs7+u+G9FJhjYjyoee5+mnykC4P5XjGn6YybwMhFyPeLeNvs?=
 =?us-ascii?Q?+3WCK//fohQKfeiWo5bxjV/5wURihayo0lIhoP29NHwebA0/XS5gYVNL3FKJ?=
 =?us-ascii?Q?vWNE+JqNCRh1Q5hLGVS9rdOdVJW/7r6wmgWPx9Gr3iIKKG8Et4PhMHnHQpv/?=
 =?us-ascii?Q?HorX3R9hIn4qtFkmf+sT4QiTaI1wd4LVLueDPodw+kI5/q8955VIE4ME+UxK?=
 =?us-ascii?Q?LXEvsiT9tAkQT+kuOdvmOWLF+Xn63XRXF+QISAoAw/vtc2bOVZNdkoUiYPWl?=
 =?us-ascii?Q?NMHRz5f8KMyrImf2C32wOVRNl+PZjNdQMszskqgZ/kv/HXhTDILogt2pUW3Q?=
 =?us-ascii?Q?CpifawAEQ/Y4CuQNPVN/T8zTM35PWW7H4XhfBcVHGoVBYSWQHSpmbCZyD7F0?=
 =?us-ascii?Q?IqsmuduzkHVp1HtIyJm3xnFGZSZJMFmo/JlptAy3W+QWALLOVfpPQxOE8W4o?=
 =?us-ascii?Q?onw/oPR3MgNn/LrHs6dDWKlbmWqNisAgHm7MycidJiuMS113Ho1CDALHo/0N?=
 =?us-ascii?Q?goxyvJ9/fpy75KQiiiHpukw2ElqVgPf37uwpezL3M8N7ISI4TgS8FlSMfIUP?=
 =?us-ascii?Q?p1KNrdFBGwZMHy4njmNkbNeEx8ZDzFxTR+iHkKooJjh8ifFj9IdrprMuGXUb?=
 =?us-ascii?Q?I7GeFMBiTSoon1PAZYaXUX9CiuRBcu1phQJ3BNQrRQIOPLIo8Bj4gFfocuBX?=
 =?us-ascii?Q?dLHecnfsQmPrjNpi0r9EfRESAwsTnmNdoNnM1/r6QoEFBCeGMf6H0Z/4eTay?=
 =?us-ascii?Q?fAFqz8vV1NDKOnDnV1HBvyEcNgh1mspC0pQOjgAbkWp1R+aFxL6vF0kemASt?=
 =?us-ascii?Q?Jm3qU91kQ1L+Olh2uGnNTd4d8PicFfy6yUrGBuLqOvW2ul5CJ2EaLCLA4WuJ?=
 =?us-ascii?Q?QgETdzdFLPORbXxVSbe9c5fF/0VGHOOmNsPIjBqhNehmwsHjqYmqFBY6rykW?=
 =?us-ascii?Q?yFxPaT9OXy3Dm6+GfvEiotb/4uqIOwk3cBay6DNumKsyEi755co+PnxBhz+V?=
 =?us-ascii?Q?Wn1fVWohS31zP1MQBZNBur/B+YsCtTqTi5hJf+9XGgPPv3UUVE5vlUgS66JR?=
 =?us-ascii?Q?kJetzRhFMdJLExXRYIQxrlBZYv1SMByb4Ysdxfox8EGynLmXYdTrpj4G3ePt?=
 =?us-ascii?Q?UPZJpOLv79sUY6xUTSNJYw1Si6+rds6xOYSRRlU6UtJpN04aEqmSoOyOn4n1?=
 =?us-ascii?Q?J0w4pj/RMq9Q3YBZr9cYXFT/+PqSNC9RoSUoSPM7sjHPwFyjQN2ZQ5Y+nuk9?=
 =?us-ascii?Q?eiMpLFcMu3CzlTDu+yEzZQM3bTy02mP6eV4yLuA1byk1kuUqqrMDXESHYvf1?=
 =?us-ascii?Q?Q+7zFIYLALhgBPHdAfymc9kupdYWNAR9YbntW4uU7WsF8bC6owO6lDVzI5L4?=
 =?us-ascii?Q?mXYksYF/pP5Rr0WR/moy95kIco446+2UmKHUlGRjXFohSKxGbtqvNhxukurP?=
 =?us-ascii?Q?tkuMMBL/xcygVfBvvQje7sYrWiXdbOnQ8Qa2MEHaxUqkVJd0FJgqxCEU7tLj?=
 =?us-ascii?Q?C7ge3N4d4cbkTWZ+G/2yCQ+4WM0toq8ggKZhXZ9nUpy2aicMUDQ0HgKjYhqi?=
 =?us-ascii?Q?y0xnOhlsExqrR0UxGtZlOSh8HJIggQ37FHvPjP8Fdb2oNMf2GzYauiKFT2ch?=
 =?us-ascii?Q?jc1kBrp9ZIyaINTn+R6z+emCMveT7T1SsXzOwuv5ZAgoA1myxzIZ5Dqfu92i?=
 =?us-ascii?Q?SGuDAQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Z/Dwgrjpm096a5PF1OMg0xeq/nXGHjpNYl6k9f7Eht7O9h6s3VVDK6pGfZbLOF359Z8kdwdpBI+Rh5gtPd271zyR5DslrjoEqwc2WvA+h2qQ7xJORinxA2As0UjdboAZcufYUcv9uqp+wa2A+gP1EyXT1UlVtQBFh0E/uAzLZgdVvDcbR8DVSbkw5+9/BE/FETh/QlsSuwqAf6odCg+oJKCOY+XUOW7o6puU1g8/0VO8GlqCo2Wkh+dqQrLnKl3jyWk3MOVM/MxGbvyOkf1V/9jrvMnIjXVzXnRTnaVLLch+NpkuejnwdhaAdrYx9VixPW/kJaqdYP09Ilfdr9Z3DkiF7hjYVZBm2LNeytok/T8wtqsgv0HfLfQQUOTvAYAoBT0v+EPZt08ScgH5hd+tIuUCULunrpR0A+lNkv2+jivQw9BkmzDNwMfJsEMosPD4WGtTN4EQDw78OB5hCFQmqCRA87lzkVMKThNgSeeqiiUCq5sXd151Dd6k+PfsbUGC+3UOVZ4cCNKghxB3NWSFXatild3tpp1uiEX59da9o3AQzpUd+t5cuQzWhnl58oSY5W0/gp23rk5ancZTag4CpMb7gBli+pBCZ3gHAML3Bfg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a1abfa-a534-4e41-25e7-08dc4d18042d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:52.5662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wEIzWf+IQRP079ngSoNCqNxBFZ03+MR1NINqWfdXX7NsRNWpzw9f+tNGCDXYs6hWf1q81mq5VtD2AkeB/sKHFCIbqXnHp4TRn87ACJktHI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_21,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250137
X-Proofpoint-GUID: kSajOLe1qmhArtyi4As3kYaJGj-m51ea
X-Proofpoint-ORIG-GUID: kSajOLe1qmhArtyi4As3kYaJGj-m51ea

From: "Darrick J. Wong" <djwong@kernel.org>

commit cf8f0e6c1429be7652869059ea44696b72d5b726 upstream.

It's quite reasonable that some customer somewhere will want to
configure a realtime volume with more than 2^32 extents.  If they try to
do this, the highbit32() call will truncate the upper bits of the
xfs_rtbxlen_t and produce the wrong value for rextslog.  This in turn
causes the rsumlevels to be wrong, which results in a realtime summary
file that is the wrong length.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 37b425ea3fed..8db1243beacc 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1133,13 +1133,15 @@ xfs_rtalloc_extent_is_free(
 
 /*
  * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The use of highbit32 on a 64-bit quantity is a historic artifact that
- * prohibits correct use of rt volumes with more than 2^32 extents.
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
  */
 uint8_t
 xfs_compute_rextslog(
 	xfs_rtbxlen_t		rtextents)
 {
-	return rtextents ? xfs_highbit32(rtextents) : 0;
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
 }
 
-- 
2.39.3

