Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9444971748
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404508; cv=fail; b=EJA2I4relTrxuo5KavN9pFKbj7i0kt5tcQuWBRw9Fzgw6dBNRMYWWOsVQ/eJgYbtxvjQUz9Xedzh1j3AbdtGIrxyQ4mm/C3bIKKQWueauxGDNcfw9mNzkQLVXrbNTTmRL5GEhjBfS3tQ6Kh2Nm9TOrjp68+iajtg32jPqXOGaK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404508; c=relaxed/simple;
	bh=TnSKkGkYzdVuhPbrr8TS3GSJu8bN39SYEQjUIVMfZu0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DdrXK/Z/wSdOZ8iEb+5AdJei34Dqy2t+5m1UEpWZhCsKUGdy9MG4veapC0p0/cDZwBvGJtpm2AmHxE2xiGky8JrxaC5UobSgHYRM9KS0dpOAzCEvG1pYUNeJ6OfPOsJjPCRAWhpUfeZvdoa+Yz3j5PL8utRQuVWyxY2MsPL+rF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VnFakN/N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DUEvUQ/+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VnFakN/N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DUEvUQ/+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG2Ll027543
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=md4VGxJD6HoZewCEIVeUoVes16L+0rEZhte2Ulqn/HU=;
 b=VnFakN/NCLoQ702wjdQ9BkK5XBXwqprgrWqhMgwOTtgA0doV4zXVvxLZzBMeku0jLKpM
 B8P/Wz2OsXw8DXFaaYzK3l+vVY+hpQcGyc+3SM5epcBuxmO2yqQRt6/UiifmEd4bLsNL
 IV/oos9Dd3YP9JIj9QJr5ogTgJaBgOKhaJGgoBwbqPLvgf8+ww3iyoTns/Pv1/lUioSW
 4+fDqJQCib1xR5jNliSRPKPLZMeZLmcbuMZXn7IxqiIvrqfU5yKWUv76IVSXCA5Djn5I
 xKNcMoQJbfuXvQ/wSjXRBzLbVo193l8lZqKFPmbHsR5TLNwdVu9XKL9J789OMbE5n0V7 JA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybkqjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKPhAJ015960
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64raq-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsGUMook+tfFo4/qXeFOOju+TaCGNLEVhSgobE0SMJtkaTAy6DsQdwwCt1CtbA5VDpfl5zHEl7w970kMWKdGm7azXW+3QCMD/a4s5k2Ruu+DPVMqFYZ7NaWSDQIflgt2DyItYTZmj85l90xNGu14atginvUSdAFR0xSFnIlOM4y4j88ykzc3dJZYVjsDOstLafLnhggzWs4wgUF7CRYnBe+9SJmQxNxLzAcBL9QVWUW5NE4BPNFVNWh9AJM3iZbTp1QDp6hw8pRTQPyPvueT8GTTpzq8HJw+weKFEvbr+RmivYxTryFysD7JUlk6DM2dWx9hxQ+i38io5OkdIxoMvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=md4VGxJD6HoZewCEIVeUoVes16L+0rEZhte2Ulqn/HU=;
 b=Z8ZIawxmra/7nV7AZoX6X+EV9GBt1ug5sdmpv12KInShNgIH/CToWDKCJp7sLza2kridrYTBK4s6RkuormvxBC2dtE1p8DOp6gZ8Nvju+9MShZZK5RTvKB07zX8ICV+M4qwTdGzp5M88YyCsOO0qbaNdJncZWlRDJ1eDvc3mMeY/A/tbWui81rnuFT6WnficYsRhOKRx49P5fG2bln71xDgnE3QofNBe+cM3bcZPQcxb9ENyrgm0xGdEz1vTTCGgXOYG/pdmLHfIeN+VobU2BRTzmSoVAASkq1184yP7cwIRT+3A7bUMc1go5Q+8/fTfNcdbIsrAZTjhUkPfM6aMCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md4VGxJD6HoZewCEIVeUoVes16L+0rEZhte2Ulqn/HU=;
 b=DUEvUQ/+abND2doKF1py0ZYFUmUcu7IZvkBHuJntAKzhS+qjuFMq8iTEwdmfUYdXKhvBMZXWKTVzLrJ4kIXtdc/93yYXgfZqMKIbwJQ9VKRbO86855d09eNFpNwSzBGvS08kXrcQ3isNkL+A5dug4j2vy7m5WvTe/xYNEF1LQJI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:08:12 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:08:12 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 20/24] xfs: fix perag leak when growfs fails
Date: Mon, 25 Mar 2024 15:07:20 -0700
Message-Id: <20240325220724.42216-21-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::40) To BLAPR10MB5316.namprd10.prod.outlook.com
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
	mmusLRjOXs12SwVQbNcyBZMm5ht5h4sNHrVMWlb9vXnb/oh2327UF24c3pjIJSu6kUtjyYrdEKms4c+LrgGX/tiaZEpnvNUVfaBBwa9N9Y0FAfgjWp8XY8oQxQMShZfOuR9pgI/IXGnlCB/hn78l4YSzUfmTxupD6TW82mXc+gr+J9JzpF0dzU04DJeu5t+w18R6EZ69ebApP/5CnqUJVgtG2c3/rl2JtEdTnyPQu6VFH0mIEZsJQC7dsFErx+5lmP0NgnB+5cq+ARtvJfpIFElCRaRJ0APhvxqVtzt+PWPoHsygqacTb/6khf6AbNkrdAhxEx99rstSa91cD5WY9FaIOHaVTbKRIxBVHNekQKkQindbuyUKlNxCj0IpLx3GkslKYHzhqnukYI+8yn+aDrN2iawb3dtD7y0tglSZ5k+vVqHcTc95ojF9tJHWYsFJ0z6Lyz5aL1Pxx/M1N0XC/epi1j6r9WKUPmSx7/gOw9b9kIm9EgNcR8MhdCKUDKMn0KcmaEkHU7UHcfyPgjlKK9ScNdCHd7JJc9U8LCffb1+IZ2BtIwykEuOUSXYPRErrHFk/1F7rhIyqASS15nAKGMxT7R15R+fTVzjoz46q3mjgny/xaPypsVekJn9TxOgRz+flYQUy04Gv1PppXjrDHg7jSQj+2YPTVRSKdhrSdwE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ITSylR9D62nkuxZ5aHMPNrU+FxaFaIW1flJex65ROFYNcc+Q5RIxH6iRPPZm?=
 =?us-ascii?Q?6gDyUnd/FsbLWfDktYS7Dz9BUYV8BtQqAehaIxDykJuHFwGoNpYZQqG/CYd4?=
 =?us-ascii?Q?t2foDodec7epZgxgTXY2iaSQDm30USnn62/sd4BIa82furPgkVjQVB55jRJD?=
 =?us-ascii?Q?OuzuVq6nuCBCmfOQziLuCC1lVp3jgP9xnZe/Ydf0QYgxgASWg2oTHwK86o+H?=
 =?us-ascii?Q?tRAlzdOR20mElhsGjB5hNod9B5g7sYMXWm/RONou4DAU4EaHjxSsMnGZr241?=
 =?us-ascii?Q?kGDSbleZkjGjnSfqtAKzDnSd3bSjbf5WpGioFG3QLpiyqidgklf1cdE5rm8P?=
 =?us-ascii?Q?olQi5ySh79b+jWnsG2HZ4Iw/5jCy1ogeow+jTGFTLH+kqIw7ABxpQo2ZiUmh?=
 =?us-ascii?Q?OYDGnXn0vvQCvCmfgYXKG227hcL9/dNs5hxgPV9D5muKGDbJbXptc/yFDA8c?=
 =?us-ascii?Q?jhZBqUVrpny4NhfCZf16vey0LBxfTblWBNAeoAU8hS5LzJZYWBbmLfrKoeLK?=
 =?us-ascii?Q?gcsyNSQrxgKBCWW2Qdfs/hctnsNU4wJSNB/BdzOHojLXdnCvheX72H5z0DRv?=
 =?us-ascii?Q?+S+MNXIdG8IatPF9q5rUEPFpsQ5H5mvDJEuEphNfhGsYtEqOeTwsCKkJBqYT?=
 =?us-ascii?Q?Yy/bnDIDmsqV8ToByKrB2pX+FAwJ+I9FIbGy5l07KBHKtieXF7p5Nt7Zfiw2?=
 =?us-ascii?Q?L39QIgkL/5Ojuqzx0iv/Td99AExvplg5N//asogcH3ghZeOnl3qIXLcmF+z1?=
 =?us-ascii?Q?6F2tSYfhCGh3dJ1hgr4rEQJe0uqp3lfIz/fHmW4YNjZgjvNW8VQFvy11i29J?=
 =?us-ascii?Q?3J8s6krqlE+LXKcrWbiUbNXm5u7PJbV0M7m7DW7ezE0jakbxpgJlZOSG7SMr?=
 =?us-ascii?Q?cVcB1ByHLbi3bJ6EcjR1vnNfkyWt3vFqatUXjA/KrHs4WLOsYbiBoCkcFByG?=
 =?us-ascii?Q?WYv3QxrOXEcWA3VX+SdkFBaV2Rezh/szLjybGif7v4W2/Q8kNJ8jYepVmewG?=
 =?us-ascii?Q?Imfz1Z4n5eD8thPa9I6K3OUncz1dAXqdGRuIENeYP06MF17Qd3n1YmYlgibs?=
 =?us-ascii?Q?gBxlav1+4Jq+dDkrTSLscuVeNzrXzjvujK3tUTz9XtnduwJflt89O8ahs/gc?=
 =?us-ascii?Q?k6C89+IB9tv/JLiZnwAWmYDiBYQjUCuyGoXE1ZI6Rq2lRXz3Z+LFJzg1B+nA?=
 =?us-ascii?Q?+RgkcdmH5TParRIIeNauG62BGrI2rv3zP9CYAk2FWhvBj/GYV+Jb3SXxKkY3?=
 =?us-ascii?Q?IFImhXR9kCdK/+jEVNsiHbua8YY4naXaHWv1Sxv2v9Oq7+9mGRY1EQpRw8qK?=
 =?us-ascii?Q?hBdVWoQJiYZJ8NasEpex75pgjRT6gJP/0B72plMxoHUbnKuOONkv+EyIdMWD?=
 =?us-ascii?Q?rwah/yYurBD3Um4eQsSMrXXlKW7Y/qgWUqLI92DxFY4kLEIuT4rQ0lqrEGYF?=
 =?us-ascii?Q?zLqubtubbULmXUc8NPgkbQyEqX9NrTbjszdMfkiv5txGG1XFHXn+EsA5jyyt?=
 =?us-ascii?Q?MYlYNs0co5aHFYUWW2IAFh4yCf0bnl6zi+0XYg3Md7Wrf3cqMVlTshd4wLBU?=
 =?us-ascii?Q?+XjxxGIsNc+B2BEUIO2bmkyDqMMlltbUwrEnAXcDhT/uSfl13alpHnvdT3AL?=
 =?us-ascii?Q?iGyr5Bp3CYe+oxY4df+0JCuUMW36XmuPqlc7LIBzlcaXOAMFUYhv3pYw+d87?=
 =?us-ascii?Q?WMqOng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8ZFrWu3trY6N41Ek+780X9Q2K0sa3qNov7IrROATXImIIDgig+LIsDgzjLGCpO7Tc+dm5vr1JIigCA12IUKUzbOS13PELTQOpKHfRQ9n/OZ7ZMvRxmjkp0L5yXn6bJV4GgNyRpFgb+XMuWN537l75cvVlZ1cZuiUzs0cTwgNjZEXF8KIaIUbtWxg3JI6P70QcMVnzshviPsI9ywGmjE/Fne1I7TQfKUn3m0Nz7aAtTPzSe4HJqhq0Iy6FZ3t3XMDGwPkgW/P8HdgG3dDP2QIH/3sCkwwYEHL23tWmawrUQaA8F70E1jGZk9oCblHIugIiDA9WEwLXYAGCoBiyzp4z2t+1ibVdLFFJS+EZv15J1YriRd7yfB3XLSII1xG+xEK5is3B2S9OX5AopVK6YYPX1qTCxtGtMCKNdjLJQs5QM3tfyW9IH72tL+PIQ4TBAE61ECPC7b5wII0EEBhUobmIKLrIiLm3q00fFSJdXoilmab7gtrpApgYVqi8mRPor4RRTHjogVhVG2WOgumR/f3iY8PZohok0ZUtoaOFkqpUUmO1o/i9peysxVm9EhaDu6vKdRcJGKeJl1kcHYq0fIvIapSKzTNavQ7YrQXfiCKkkI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27ae23a9-1e91-4d36-90ff-08dc4d181013
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:08:12.5489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgoAR1LflrW8z524vq/Jelx0AHxBxPiCTjivMSUPvMR+n5oBdk0kGfrPt8ecwlkw8r2ZN8lEly0f+QDLnk3OZVGEo4YTOYZfO2zP64cFqJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: pNBAdgJMOPwhcUR5lFNx5cBZXQ1Os9wY
X-Proofpoint-ORIG-GUID: pNBAdgJMOPwhcUR5lFNx5cBZXQ1Os9wY

From: Long Li <leo.lilong@huawei.com>

commit 7823921887750b39d02e6b44faafdd1cc617c651 upstream.

During growfs, if new ag in memory has been initialized, however
sb_agcount has not been updated, if an error occurs at this time it
will cause perag leaks as follows, these new AGs will not been freed
during umount , because of these new AGs are not visible(that is
included in mp->m_sb.sb_agcount).

unreferenced object 0xffff88810be40200 (size 512):
  comm "xfs_growfs", pid 857, jiffies 4294909093
  hex dump (first 32 bytes):
    00 c0 c1 05 81 88 ff ff 04 00 00 00 00 00 00 00  ................
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 381741e2):
    [<ffffffff8191aef6>] __kmalloc+0x386/0x4f0
    [<ffffffff82553e65>] kmem_alloc+0xb5/0x2f0
    [<ffffffff8238dac5>] xfs_initialize_perag+0xc5/0x810
    [<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
    [<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
    [<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
    [<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
    [<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a
unreferenced object 0xffff88810be40800 (size 512):
  comm "xfs_growfs", pid 857, jiffies 4294909093
  hex dump (first 32 bytes):
    20 00 00 00 00 00 00 00 57 ef be dc 00 00 00 00   .......W.......
    10 08 e4 0b 81 88 ff ff 10 08 e4 0b 81 88 ff ff  ................
  backtrace (crc bde50e2d):
    [<ffffffff8191b43a>] __kmalloc_node+0x3da/0x540
    [<ffffffff81814489>] kvmalloc_node+0x99/0x160
    [<ffffffff8286acff>] bucket_table_alloc.isra.0+0x5f/0x400
    [<ffffffff8286bdc5>] rhashtable_init+0x405/0x760
    [<ffffffff8238dda3>] xfs_initialize_perag+0x3a3/0x810
    [<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
    [<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
    [<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
    [<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
    [<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a

Factor out xfs_free_unused_perag_range() from xfs_initialize_perag(),
used for freeing unused perag within a specified range in error handling,
included in the error path of the growfs failure.

Fixes: 1c1c6ebcf528 ("xfs: Replace per-ag array with a radix tree")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c | 36 ++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_ag.h |  2 ++
 fs/xfs/xfs_fsops.c     |  5 ++++-
 3 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index cc10a3ca052f..18d9bb2ebe8e 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -332,6 +332,31 @@ xfs_agino_range(
 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
 }
 
+/*
+ * Free perag within the specified AG range, it is only used to free unused
+ * perags under the error handling path.
+ */
+void
+xfs_free_unused_perag_range(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agstart,
+	xfs_agnumber_t		agend)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		index;
+
+	for (index = agstart; index < agend; index++) {
+		spin_lock(&mp->m_perag_lock);
+		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		spin_unlock(&mp->m_perag_lock);
+		if (!pag)
+			break;
+		xfs_buf_hash_destroy(pag);
+		xfs_defer_drain_free(&pag->pag_intents_drain);
+		kmem_free(pag);
+	}
+}
+
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
@@ -431,16 +456,7 @@ xfs_initialize_perag(
 	kmem_free(pag);
 out_unwind_new_pags:
 	/* unwind any prior newly initialized pags */
-	for (index = first_initialised; index < agcount; index++) {
-		spin_lock(&mp->m_perag_lock);
-		pag = radix_tree_delete(&mp->m_perag_tree, index);
-		spin_unlock(&mp->m_perag_lock);
-		if (!pag)
-			break;
-		xfs_buf_hash_destroy(pag);
-		xfs_defer_drain_free(&pag->pag_intents_drain);
-		kmem_free(pag);
-	}
+	xfs_free_unused_perag_range(mp, first_initialised, agcount);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 2e0aef87d633..40d7b6427afb 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -133,6 +133,8 @@ __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
 __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
 __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
 
+void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
+			xfs_agnumber_t agend);
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
 			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 80811d16dde0..c3f0e3cae87e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -157,7 +157,7 @@ xfs_growfs_data_private(
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, -delta, 0,
 				0, &tp);
 	if (error)
-		return error;
+		goto out_free_unused_perag;
 
 	last_pag = xfs_perag_get(mp, oagcount - 1);
 	if (delta > 0) {
@@ -231,6 +231,9 @@ xfs_growfs_data_private(
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_free_unused_perag:
+	if (nagcount > oagcount)
+		xfs_free_unused_perag_range(mp, oagcount, nagcount);
 	return error;
 }
 
-- 
2.39.3

