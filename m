Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08801C10;
	Wed, 27 Mar 2024 00:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498410; cv=fail; b=ZQapCDmEYXlh8LIW4g54XJyxFmD3bQv/k0yvOcw2pQTge6c5snnvz1IQJCBlqeBJ3otKoybOWGDOfeHYNazu9TeL7pzz0FrVS7NvKuiGkoZhH3zvTTgx6xLE+x8KmE5dgDKGLELbN3cv4hQoE2+4kxt2hliWx7MIUhvppeWpaE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498410; c=relaxed/simple;
	bh=UA26M63q40jup9ukC++G/r9IN9VdebchySojqlPrwCE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rSpsYl1MT88Sidq/sW8BzJM2OSh9aJ257PXGz9n6A9ZJ3NsDUCVOXuAT7fr/VIpWUD2HW9zWJx996TXBcs3KbivaDQXjEufzga9/UkWUV9oOshsB3LQk8ir4oo/FEk2hFz1P9oVCUIadPRPV7BjUNYeyRAgfIBFK8NE8OJQ/8kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HRHa8Vhm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U3tNIxOr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HRHa8Vhm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U3tNIxOr"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLi0x1016402;
	Wed, 27 Mar 2024 00:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=lsS7R+mGl9YdTeb9A79jaiEou6PX0O76Mip93uqkDYQ=;
 b=HRHa8VhmUv3bOVv5UYH9/gaT6KI76PYXV2CB1s01ErPJ84CLuHUNjHzDOYY65YnL0BVE
 4YUSBXTBASKVrcnHyO58Al9q2K0BO9ZYWG+n06SyDdViNt29Vapm1qA6ATjaL4gfUKye
 1WowkxpiLPlag2iXKvQmwBB6/ECD/nl8YE3PEPE+6RXEWh3hrUjS4n1aN/lVLfzarb2f
 mnWE26iFiRXKCSCIYf11wmqnV56XqnDFmH60LYLHlnJbd/2qEfGPgnLouWrmzr6vWqVD
 U51x/2G/dN85nXk+7SuDvLsnlwYZWcZthoT+UwSUK+I3vbLuL5vSDdRI8aRx0txdOGfI og== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1q4dxc0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R01oai012358;
	Wed, 27 Mar 2024 00:13:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1rnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cfw/E3G+tn4QMIv2rHtNUifHHSMSVOYYOharcrVLn9WCVyBxPd5F6ZyRfXwNqF/A5/HYlnKwua4vhpFqGIvxZWZvOm2Lxrc1HTcYsZAb5zFZXI43KXr02RVXgD4j/Ei1Z4nFWQ74hZYq3eV1IRK/nQie/Am7iHbwSRr6v1ojlMaCvhduuZGnY9ir8NRXJAceWfs7z0lMR72nWmYuBEWp26vXUziVArf2+5Pmcw7i6uMWOgpksabWX7cFSH8RxrADDxSNAjaX1p77wrTABUSd2zqDpTMQdduuqlQVtgReF8IMJGxJhTb1BUmqYs3Z3uS9jQADP43Bu7x8PPdOKShvUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lsS7R+mGl9YdTeb9A79jaiEou6PX0O76Mip93uqkDYQ=;
 b=Mk/vwtqvIimwe+oBou1irpKcBftfK4cvPHWlGOZwmgC06G8MBIBw5dG12jjY0Jm08JpVe5MDpJaFFkRICtfB+bzfUFagB9W4IXKeqx08Io0yTcxzH7AWwQzQrM4vX8DhAr6VXqs6jUQxAR9rpTSyogGRZSEJZadg059NPjxc2SBEF+fE2XFZe1LEJfgdPNqhdasn3jqhmuHI1qClg8PzcNsaK84cy6pETnkuKqX2KQUJ8Aw/ej8DRbyU6s7vrPIl8BFc0vflT2FzZYGs7BbT5KlB+hcamIkphO3hHXQHm5uu1Zep+GSDKdSeBIgQ0pR40y4zxoF2w/dY4h4UUUXHhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsS7R+mGl9YdTeb9A79jaiEou6PX0O76Mip93uqkDYQ=;
 b=U3tNIxOrq1qftG5KnNMgef5p3natjc+7ipPwavXJoZomVHC3l1H6kJ3gb+N9Ibn7MI+wQXfstOOiG9sx/D8AvqDO+ZOUfBINXWMvI23ZEHg9U7ixjyATfUaJAuaFXuf37a/Ni8QS67zZIlzhw9RuaBvm+znxEilY33rJF9WYJ1s=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:23 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:23 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 20/24] xfs: fix perag leak when growfs fails
Date: Tue, 26 Mar 2024 17:12:29 -0700
Message-Id: <20240327001233.51675-21-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0014.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::27) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	M7JiHUWeQlrHiOEpRGsZRp1RGOce3W38YBbSTqNIo1iAbYaZX8wRySULjFGQ4PS5V7QTXdhl21V/44XqYplHE2Aiu/wp5LkeQ5YomavfjzEJ2LdI9lsQ/vSnR3a8HVsJkfoX+kJrHYZzLhKdLH+CAAdfxpyJBLjHPa7jscjcEzgBjx4chQi0uiMiplmnt+k09o6Eu8JgW7DTSNw4FdDFr0zF3IN1eZVk5RNgnJFTy8PL6PjZvBJtrqfP2zL51NlQVjPvhGEQD9t9ZeEQhLJbb0u9kQgkGE5bDLW359Cyrk4IrFn3cPpWfD3PtPmcOXDUrpfv9aoe7CueV2Fh8cTIsUXMlfUJnyq1ujTr3t6/xcCFem103iKbC5nXYpM4howbx6JcSQ/rfHquHntcKK/RS/Euex4UmQfqe7OWqU7u9Thm3ziUw9S6VXglrZovF1AK8HgEeXHLRlbpwuGSh0iDTK0YTzNEl6gO6twzdbmh0hPop9BoyzDD+9QKHYD5dZaLJ9PniXUR6g0zkx1ZBS8588+/l84yvw8u52P+EPM6jbzQhLWeXuCsGBPVRXsWIgSMedfqkqUU7RzilSQgGjWDfJ70A87vG/qqyQxZwRTnutHfVq+owpDbKh2iEcAhgqTACOfGXdS7xImreKGzL6xhF5bXSwZCazFq3iXLFWuKGj0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?y6Ef8miKESmh6j2dCQcSRiXcFMKEV4yXzNdyUZgVvCRnbnRzlkuNm39BygHT?=
 =?us-ascii?Q?moXDk0cLBIG/2t+y5ax9ZxRQL/t/zyxW4w6OUqIx5hKrdJNEypVZumbXfkrb?=
 =?us-ascii?Q?VjHm7SGqRysFGtGMk6ClRN4vR2FGNyTjmk9nxMJcOyq9DvPUz4rDaxSpFfcC?=
 =?us-ascii?Q?emeMmh+M6wL7itmsQRChXCYIyAwneBOybczZYbsMzVD9nOX2j7MuRZ0nT+4O?=
 =?us-ascii?Q?hBi17/alhSiPjfSnB3FDmpO0TYSmUeQabaxNjGtvMFnkUGnZqSbPqfo4uvWT?=
 =?us-ascii?Q?kaVJDusreAgwifQmYjG7IDOrljeCaqsd0LEpJrOrRPwkkrTE8gAM3A/KiLt3?=
 =?us-ascii?Q?JwKwKe7+USSdiJ6risMYlRKlWAkUog24BWx5c68jHc1lH9ScVtV0Ytl3EaTs?=
 =?us-ascii?Q?iPUXfG6On1oWadRJfOMRT8rdr5EnqUglz77VYz31stn4GC4eV6KgxVkpFgIh?=
 =?us-ascii?Q?ez8mfiGMlxPj7rEm9KYAucvbNbaur/8lV259LykpJzADWo/TP+bbiVEHD8gc?=
 =?us-ascii?Q?w4muP5FAvxcnrnQ+jz1FKOpW+BY+lALRp/KjMk+ZbqFazc/2YmmsW9YGhcgo?=
 =?us-ascii?Q?0Gn8N2rpSQorq93hvYZsnYM6l+kLAoR7WHZeLyc0fbaUzg9wuPaUUA1vPg47?=
 =?us-ascii?Q?GMhqQsefwO3JveyJXz/0MAQv+ctahWM8gm4QArX1/Q02FfCRru2iA9HOC7Gp?=
 =?us-ascii?Q?OHf63bZsf5qw+Ap3fCnPaj+AmM5JJmQFR9rOwSzqwUdMevRIGxsVw6xPEzY/?=
 =?us-ascii?Q?F1+2R8gq/ag80IRQt64lp8qlTVCVWMP3Jq5vN5PLlNOpNPU7ZEpHi/8sdJmh?=
 =?us-ascii?Q?viKkMgQD0aSdMUwZAOrK5LXj0N35y3JDwzJ8Q+2P8YEEKT8NE8ptCPhOvB8A?=
 =?us-ascii?Q?zWYEodJhkf6OStppeuDo+767Ljyo0iTUE+UJhNSbTNrLfMBFMeOcAeN3yLlW?=
 =?us-ascii?Q?ZKyPFl7Mgtj7a24P6QbiarMWJw+mg2Wo4hhJbydo/SfxHIBYiVbRvOELmJQG?=
 =?us-ascii?Q?rXzt9cDYrsZFrmKGK6/E1PPqtP35QoI3Nq9WeRMTSjctLeF+btFZgW3aWRys?=
 =?us-ascii?Q?GlXCQU69/107+nOHzV1S1h/mqnx8c/suOxcMPFUy6soT3nKmP5a9tph8J6RE?=
 =?us-ascii?Q?eGHTivGHlfaq1BFtN27uN865C+7zG6VwGyaGLwtv00odf2aJGJKsY+JVpzbn?=
 =?us-ascii?Q?SnMy5yqHblxsiO1YIGWRXvAlTXDWAeBfPSRcGlOYv+TkM9SfFb0FGRDg/J9J?=
 =?us-ascii?Q?y5suV/Tqp29IPZZx8yq/FbbtU4jK/v3qlfateNz64rj48HTYcjIgybZCfdEG?=
 =?us-ascii?Q?tQbyAIAiAC/CFup0AEwWNM0CLb9ZJapOVLvAqrzE0NM5jegdAG7kKWV3BdSR?=
 =?us-ascii?Q?ou/d5UCWF4N17GeAc0s+ZW7bM3ZzcPDnPJ4fHn5GZtDEy6FEECMn9NjA/1bD?=
 =?us-ascii?Q?gXqq/RODT1bgSQz09b+Mkf9HvGn3IkVBAd57Ftit01dug+7LjsRnigBRiWTt?=
 =?us-ascii?Q?40dyX+ywjmWFCVqSEP4wFU+SPRoSvDiXoKc4Twfa+TNUIzDzZWa6UDoYxGpQ?=
 =?us-ascii?Q?kgLramx7H/U5ARzsRpTCSKUSNkAdZFCvuZ/nLEQUvAin41YH7D1Csyg6p7PU?=
 =?us-ascii?Q?oXMIpe/Ggz84WNtj30dpXc+HIyypzsXWQ2gzOdDMm1Jd3/FChrPIO/dPK0Wb?=
 =?us-ascii?Q?NiI9PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Ttf7taRhvNJGS86bMUXtdC0cwEm+7eEMiLU9797k1cMWvsVPHMbXJHlOzPRJHYIK/q9YI9XZrLWv1vFHr8pXN3YXk0GiC3njgvoXAsktbbPY1qre4BXBzjddT1Ea/8JSESXPONZXQQw5Xnm/jKhlFXKYfIA4F99AOQPEx+sqOuqChOXtBmJV3qc1OYhifWVUol8+FyHq5MJG2P5X1WCIzpU98760QSf6buAv3f/lbxZBdgeVkz0KXwSLg1NsUo2dG9poU3m9xnA5i1cpeKNPQd0SHJFePA+mvUyi5zdKM18T/IV1GrfqyzNaIBRgoQnaqdmZQzGunQM6qVq6qEr5wAFk3FBFrAyFs66IIPU7NxLZOMirjHop/+QO2gT7JBImE9PHUA3zNu+gZwX5H0PjJA/Dp0VRxEZnf3p1GgK8JHOJWRkPZdnSCvcYC9ClDJfrUZ2e+2TpbNu5/ibYN61gHDoQGSlWT1U8+yiS/uoKqxJ4P52YBCKHTU/iVh1X2pPx4o0aMLr1I9vJeOlfe8mWdUCyMAjaIUkIrYVlCRjfRYIwo6mxAegVPvjBeRMml7t1PHeoH8PfsEPI561tYErD6Hv9TKcDa65tNZEpG4onNeI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4955c924-a433-4bb9-734a-08dc4df2b755
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:23.4579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3H+4mqWZqzRbKoypjIxa3YM5PR5Bg6gBJJzyAM5m1ThgtKkHB4AOFesk5c799nAb5SywFMXTCn8xm43MzPp2xjzEwRWw1Y0JVgXSiJXKW50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-ORIG-GUID: m15JDkkG0vi_zWnqidax7KHzvOCJPeiz
X-Proofpoint-GUID: m15JDkkG0vi_zWnqidax7KHzvOCJPeiz

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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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

