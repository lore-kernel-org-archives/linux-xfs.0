Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B92101C4;
	Wed, 16 Oct 2024 00:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037524; cv=fail; b=VH/bAjTJU62hyYcmHujz3tK0YyhM+/wTLX9nooHVkxIADtcj1J3kEQJCHWZnl5P+6dpLuvRuI4ti8Gu7Mk5ppw6jiMFIwo8LXX6UlnHc0MExA5dd06JVBA+7juqJAWqDPi2Fvo4v6ozrdb9RKKCvs2x6PdBqhMFh6Kv0ZdfgBkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037524; c=relaxed/simple;
	bh=6L0jvtfSM8EfNvpnzEaM/47Iw3u2R0/6/e3TkViILS4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k4u0MdY1/ziddbUU2oVp5z1qOfP8+ZLPvRFdU/oVYer5jrahhDWo1G6aE8tfw3DBSQ7JiZctXk7AbzStamMOrn4T9tHLeNresNdZz1IDUFdBpJFYlDFyb0k0zulD0ot30Z8SX4yYdtHHufjaDnbZt0njy80ncqDccU98Sa2xLDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OK/61KF3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u6cTrCxK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OK/61KF3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u6cTrCxK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHthT8019400;
	Wed, 16 Oct 2024 00:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=niMUj2EuowLtLXsP9tPrAje9fq5uathyL1/OoyXzizY=; b=
	OK/61KF3PosllQLYwitxH+erKDTL/YsQMIpUld2cogOZHX7ZgQ4Hr4s4d4l1Lih0
	9wmg31gD5s6nVW3syPLzspRp4uI9gtj9tHCTuAl69L/sOmgXQV4xXl/kuRaTBlSv
	CAf5CVPtEf9RJ+Fk+tPTtXfzMI7fZjfRikSxKcYdO0r6BB5vh9juqR1CBpqFLXeK
	lRZvJ+UGnynVviLXPe9ollYjgsveuzchRHslct0P86MzbZufBPkOBj8qlokEtHw7
	7QUt4h4irr/B4FjsbL1LEsOExEALLef3KSsU3QjFiDmxq48uK5jU3iCV+7jVZ5+w
	+Fp+TWZZrHq7o8bgPsf8nw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gq7jhqh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FMBPUi036115;
	Wed, 16 Oct 2024 00:12:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjegwwd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JH09MsuvnjWahBo2YufTbqHVbPCMUSvPMN0QafLgbQ0wpl4a2vXa7++wcCbBlWFqHUblpl2OXfGTSOKaxfbjq+QcghQyjqk/dXatfUYCi1Z19hQ6fYdtn+04UAxK/tBZvtYgo5StN2RCCbxQRJ1PoMGx2VFObQgH/+rT5AQfbwxpgxvR8N6You8BrTkP2k1s+0xfJGco1KwGH/WvmJb1gTwfOopisoaeNGUU9k6bNKl/+bODYFTlNyC1RNSSml8WmL6iAxRt8qpOBwUJ/GgA2LCHzdc5OVv+a3SwIh17kGT7wBErBshMHkTUsQGyW40J67B+vYV2kxt6SYPc7q9euQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=niMUj2EuowLtLXsP9tPrAje9fq5uathyL1/OoyXzizY=;
 b=J0mP3ClwphhOSQ51TaMigPBf5/+kFauvMY8xWfoX5NXokGSmm++X6HHVbEqJCfnnPNmpPIMp2AGzAGi33JLE0SbuhDnJOHIv6xTvuK6OImQyr0ex3Kvl235750hjZopZjM5NFV7NWO00AWSCRnZrviCeHZcUiLkrOouqN/lL3Lyjp1wu8q/SfbXLdrmRsia1dRc4bJRvpNMvgZ5Fi57Y37P/1z2IHGBMVhkIcYOzwBgyEu77GmMmD2xqw3nYnXAxj6iddhXC5U0ced268PnrDLXuRDCabqqf2aQsFEZuI107hwq3wSr1/EiwhpEs+mwixWYHdf10gssh063fc3j4wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=niMUj2EuowLtLXsP9tPrAje9fq5uathyL1/OoyXzizY=;
 b=u6cTrCxKZ1A6DVcLGh9Gl0m5MSaERvZTqWikY8hzeU/BphSeSR1bhIyAmPbrdkbqOyXjm9bzbGIY4Hu9E8/xs7jcZKepyTd0KgrJLPiLtBwHuGA5crm+vkYncPXLEDx3Z/xmEcMJ9Tc6FNHO44vwMeF68koSVs3P+E1SJ9o03Us=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:11:58 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:58 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 15/21] xfs: convert delayed extents to unwritten when zeroing post eof blocks
Date: Tue, 15 Oct 2024 17:11:20 -0700
Message-Id: <20241016001126.3256-16-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0192.namprd05.prod.outlook.com
 (2603:10b6:a03:330::17) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: f250d672-5495-4071-88fd-08dced772689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7ljtZXS6Zua+j3RsVJ9erjAY/6cJK6NuFtPkO6fEhjSs5OBgGjQJzqdjyEO5?=
 =?us-ascii?Q?sEUYTW2cqww8r/lYrBKRhjvBTTI1LWtak/1P02pP3N/GGxqXmTrYSQJIayvi?=
 =?us-ascii?Q?uESCysuQ5k1C6pjozzHPGZO9epCRTAQpKo7cUPxn0u4HWyqdWWZueN/3DaaW?=
 =?us-ascii?Q?rpNSZSJhDZ04VFo1uFd+1xPz8wF8CzO+Wffj0VkXQNOn9HyUJjI5wWcSVLWb?=
 =?us-ascii?Q?DdRo3ZJAj+yXgt/KfmpHdom7WKd2cVCvfT7h1SoQCz0Kjo44bseyudqbqJZP?=
 =?us-ascii?Q?34qVGkJ7ceu3e1VxwyQUCkzN8cdakHRPSHCxBuxAzD7oBsUAArHmIqSzMpgR?=
 =?us-ascii?Q?oKord3JduDj57/w2u6dZkHyrW7+FxUhejPyFrB949XEJf5R1rXSmmCSuu9gx?=
 =?us-ascii?Q?FT/iUnoe75dZxWZygxxHOTenLXk9NAvcX+hLbx+5ABdeOQ53tlsr6hIqEWFf?=
 =?us-ascii?Q?QwBUHoLOltMCbK0zxkNXInwBV9+a7goDdy21OyIYJFcLyFWLWvNWMy6R3D/d?=
 =?us-ascii?Q?r9YnUa1jNS4+CWR7xxTMKXHND+Z/U+Vbs3W9e9a2ZJnAIB0NUQLWsaHl7mX0?=
 =?us-ascii?Q?mUjmlnPbaHPkjuCoSAoU1nQqgfIK+Y3z3YKWhRYEsUxf+QMewQvvY2XCTqvd?=
 =?us-ascii?Q?4LNe/8dokmisfd8iKx2Lp4/9DCvHvkJIyO0TBMANwFjaEH2BypBrdwoMHYZs?=
 =?us-ascii?Q?rLMUYSYgUjhE0sENh4VxxMv5OQBhN+phSfZ00IJKjAM7P57RZ+QLZ7WZiWbR?=
 =?us-ascii?Q?+xHL9iybQuCuSLLsqQsJFI3pruU3oBVM98alSeVu6thifHb7jiZl01WRXAT+?=
 =?us-ascii?Q?xDuO76Ud6d46Mw/SmD8UfDB4QvKj6kRqPZOY1d0SB4WeWhujW/NElcLjwMdl?=
 =?us-ascii?Q?4EOi2F1aYuu3BjMPVdtvk9io6FOUFHJWaiA/iWkUn7hDIOHGD1AdAJ1kMl5Y?=
 =?us-ascii?Q?Xnxt/NMNB/NWu0lDP4IogzP+TFh+XABhIEkgKOMe6RtkuccrjDWi29+UlOL1?=
 =?us-ascii?Q?6keOc/i6SH12HOvwHOWF+pGQJlQU1PCqWKFZC4cmjqTszYkUaCqDxmMHtgVr?=
 =?us-ascii?Q?szBEeJdTS7NzMKJB/In7eVf9ANYE3beR1G3EZB1JY4zB3Qk92lbgUI5Egidn?=
 =?us-ascii?Q?78qB4F8A0pjRD3KzieS4ZmmIahPw8Gjhu71g2lgWbebAqN7R7wdTGnXF51DI?=
 =?us-ascii?Q?STSCWD9O3LBWyacCfalncANd3zNI4u8L1ydTbFeICdTUxpZgEgM/UF4OwTNu?=
 =?us-ascii?Q?qHSPDs4sNUTbZyIFv5kGvVmW8FemcFNMcBudz/zi4Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QseqVimldkjhGzU7w2ICJH1P2+J7pMiv/Pwbtf3LbLO/0YwOjBz5Koikx4L+?=
 =?us-ascii?Q?rYLvMSug6NjJBbWTVqHjK6gy3Iqfugf6XUrdeQE3c0ilXhhaEAntOU5OdOar?=
 =?us-ascii?Q?92k27i7m1YxKQQYvks7BRCxWdmXXq9R95W0d8mNTUu2rsZoPNkwWwJC4DO6O?=
 =?us-ascii?Q?L7k49m6hKVBtBXr0/IogwwAWJm4fabBf4LjrZejtuxWzRK5Mlfkaf/OYzWuT?=
 =?us-ascii?Q?OuZZ3pW0Nv2yebEw4at4N/DrmgdRVIpmmn7fzUXQkYKrwN6ZdA62aglLc3Ik?=
 =?us-ascii?Q?G5zea5C8JW7BfVU+J+vMfDFiMgGqXnmZFU8Q7mQBFNB4DVO6UBIgon1+7bpR?=
 =?us-ascii?Q?oiWnSLyuFav45M0t4IKttP8VdY0ro1uXY3Jy3gAjg6Qe9GP0jnYXGiWEvbDJ?=
 =?us-ascii?Q?zUvkHHGBbluRIDzKZVLC8vZLpOecwL6I/fIBpoDBgSePMe9UxpFPt+Wcn6Ye?=
 =?us-ascii?Q?DmTATR2areEcFegBnU+0o9VoDnSyMVYEY72eaPQaHOZZrwTVe7L0KtpF4SiW?=
 =?us-ascii?Q?ynecq3scEDdMgZUt9PWM8lm8i3nPxp2uRoc5Q7af1EKIjojd3PR6TpP5obv2?=
 =?us-ascii?Q?iW1NRN+qeTfYb+JAIc/WzScnrHzhc9W+xUdwEeLIxt52+beUWf5HolFioeAX?=
 =?us-ascii?Q?dhIrzfzxfUIBJmKgYAjPcOwUmQNTzBEyYfqKVRdOLfCNtYV4PZ/0Q13/AFbl?=
 =?us-ascii?Q?dLeOdKwf3+yL1HGedRHmYqJG+izBAEA1sVM5JaHppSZuXAriKCN5HtvVmhMO?=
 =?us-ascii?Q?QHhiYdG3XjeyePKaGKih4z6PmcRDwea0/WcY+RHKvbWUJbqIkVgs88qtUEU5?=
 =?us-ascii?Q?KXfyD+Bs1V+I28R+I9RE6c13yulDyMOGBgM0SshKehrYSQcC88n/zCM5LIc0?=
 =?us-ascii?Q?kdDotUMXkwTvHEdxHO6HntSE+LnOHNU9R8MNc/t8ZKaTxgh2XBvRJPX/kd8i?=
 =?us-ascii?Q?rOj6pVp4cXcNW28TbDc2DJ9stG97dosJcSD3d4zmtHumWO/0cM794nMFxZw8?=
 =?us-ascii?Q?pbv2ZpPKR5m5m8+/v6rcCCYtF3lJKIM2ZS4XyHXj25UJAVZrzgEJ5cg6f8y5?=
 =?us-ascii?Q?/zb3f5ZM+htyKZfsWRnazouSfZ6J4lmd1v3kUORB5vKsMA/o/8f3IOaQwL65?=
 =?us-ascii?Q?fnm+3gs7sM6hYWaqnpBwdIrsFMhoIzVkhlm3LK4G0Vn5tvGzGivuxncXC/mp?=
 =?us-ascii?Q?K3eLwOgi0EeIFGw1tCwljsBptDxzJLuClXqRdA/qnUcfz9T5sw/JvFiEmts2?=
 =?us-ascii?Q?7INJXtiLRB08ynCyGhmHpBXzw6UI+cP6sJQHmO3RMyNHfrnGrYo17DN00xi0?=
 =?us-ascii?Q?vOEwjg4R9A8Oy4jNxaC8p1/xigQgTMFzUsteqn6VuqFbiLoZYasXE9C5vrv1?=
 =?us-ascii?Q?ZaXzncQAW0S07b4qIKjUV+8L5quhRgXo/W+HiqaS5/72Ztu0l2mTZC41yLMw?=
 =?us-ascii?Q?N0z7kqSJLqebXNGhJ0DiKsZfRG8gGo4TsEo46gSZWccvAvCH8gZ5la0gKSp4?=
 =?us-ascii?Q?wsieG2aI98FduHKj+Zba0Q9WeXFucGOl2OHideQxNAyiTYNpL6cgRgiBXAcx?=
 =?us-ascii?Q?7OqSwhPnzE/tum62HkzR5nQ+G+kpXrgUHYPDStczkEpk0i2Tj3Eeh6KNf6YW?=
 =?us-ascii?Q?TXL44RCyb/+Ixo987tF1HQeXQJsJVI0S5Vn91H/O77hjtm7wBNFDXqOwHbBV?=
 =?us-ascii?Q?j1HR6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y3zWwbmXpzMSshYYnr6KpAYkm13RLz3jYQbjhl5eMbAvDlawxf1IoshriCXBN/lN2SXPrY8jEFvBI+vuvZhbhx/VmcqesLWu4/3OdMPM21UphXUa40RN388/4cNgOJ5CPMNFPWPWGNolGKqSphGi/3g34slSTM1W01PezJcC6QUqiV0kMpAh3iqVQYjgDTcT7IVsnrT23mPKtsJH/lxWuKIi9po1Gue43KcjCfQHeXPgj6D/ohUBby7hoMebxOeTaCwiRpg0OelUDdCyJ2e8XekTC3T8LgEmblLr8f1O3EFSGW5Q6Ej+z4bBmgeZnGaYPsqtbsxUSTXyrcgsNBulasKtpiypBp/BO959/oz1KPcOOXJk0bcLkmPYR5pWEKLEITkFyxB5tIQKKPVVAwnpIGzhCK7pRyY6VnAtrWbm6fKAHsNLj7f6M+Ti9NC8fuuG9RkKQQl17424Y2GoFaheBBKL8DZ/oWiyjLtqFiI208My++fk7SFLfeKOlR/VygUMDJThizTph60WHHR7iudzFBmiyHVzjUDP/YRs6zlDt0JFkzqEvj9VzL0lFpLAkenS+XURM/iSPrvwBcql3aC0/97FOm5ieJ0k8TkVMMhqPCw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f250d672-5495-4071-88fd-08dced772689
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:58.4660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PwUcN3wdyu4lsvZsNKVrPOKaZb1Bp3K/TFkNMD5I/sPSI86q6/nLz1fLiM7EVd4svlqzl2mI1oDzwXaDv/0GpUElmlx8kG5sRzkwp+HfbkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-ORIG-GUID: vFDwY03bwDBdPRIqv_jpifJvL0P3Sq2K
X-Proofpoint-GUID: vFDwY03bwDBdPRIqv_jpifJvL0P3Sq2K

From: Zhang Yi <yi.zhang@huawei.com>

commit 5ce5674187c345dc31534d2024c09ad8ef29b7ba upstream.

Current clone operation could be non-atomic if the destination of a file
is beyond EOF, user could get a file with corrupted (zeroed) data on
crash.

The problem is about preallocations. If you write some data into a file:

	[A...B)

and XFS decides to preallocate some post-eof blocks, then it can create
a delayed allocation reservation:

	[A.........D)

The writeback path tries to convert delayed extents to real ones by
allocating blocks. If there aren't enough contiguous free space, we can
end up with two extents, the first real and the second still delalloc:

	[A....C)[C.D)

After that, both the in-memory and the on-disk file sizes are still B.
If we clone into the range [E...F) from another file:

	[A....C)[C.D)      [E...F)

then xfs_reflink_zero_posteof() calls iomap_zero_range() to zero out the
range [B, E) beyond EOF and flush it. Since [C, D) is still a delalloc
extent, its pagecache will be zeroed and both the in-memory and on-disk
size will be updated to D after flushing but before cloning. This is
wrong, because the user can see the size change and read the zeroes
while the clone operation is ongoing.

We need to keep the in-memory and on-disk size before the clone
operation starts, so instead of writing zeroes through the page cache
for delayed ranges beyond EOF, we convert these ranges to unwritten and
invalidate any cached data over that range beyond EOF.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 359aa4fc09b6..1a150ecbd2b7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1005,6 +1005,24 @@ xfs_buffered_write_iomap_begin(
 		goto out_unlock;
 	}
 
+	/*
+	 * For zeroing, trim a delalloc extent that extends beyond the EOF
+	 * block.  If it starts beyond the EOF block, convert it to an
+	 * unwritten extent.
+	 */
+	if ((flags & IOMAP_ZERO) && imap.br_startoff <= offset_fsb &&
+	    isnullstartblock(imap.br_startblock)) {
+		xfs_fileoff_t eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
+
+		if (offset_fsb >= eof_fsb)
+			goto convert_delay;
+		if (end_fsb > eof_fsb) {
+			end_fsb = eof_fsb;
+			xfs_trim_extent(&imap, offset_fsb,
+					end_fsb - offset_fsb);
+		}
+	}
+
 	/*
 	 * Search the COW fork extent list even if we did not find a data fork
 	 * extent.  This serves two purposes: first this implements the
@@ -1150,6 +1168,17 @@ xfs_buffered_write_iomap_begin(
 	xfs_iunlock(ip, lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 
+convert_delay:
+	xfs_iunlock(ip, lockmode);
+	truncate_pagecache(inode, offset);
+	error = xfs_bmapi_convert_delalloc(ip, XFS_DATA_FORK, offset,
+					   iomap, NULL);
+	if (error)
+		return error;
+
+	trace_xfs_iomap_alloc(ip, offset, count, XFS_DATA_FORK, &imap);
+	return 0;
+
 found_cow:
 	seq = xfs_iomap_inode_sequence(ip, 0);
 	if (imap.br_startoff <= offset_fsb) {
-- 
2.39.3

