Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124D83C1985;
	Tue, 13 Oct 2026 08:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879250; cv=fail; b=AtEOKxEtTBYEtJFbcuJq68JK0WQUJTZEeNABjhQKr9Pzf6u82JoLR+hqmHDy0g+rdKUf2ntUEfNm/N0oB+pDmo7WFhzMI4Cbf5H2lT6CjW9a8CXTzryujyBivGguq4lJPBhYLymOw3Z+XacX1viiP2UHtCou1znBogQhx95T8N8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879250; c=relaxed/simple;
	bh=T8cO4hypA02piRj3GENJuXzYbRbj2Vc9MN5QefU/4H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MR03ggPzVn5hYX3miGD2fOrXptnIztFso05LwaIXkVsiU4bDbZKGSCoePfxXZeQK4uQGe5ljfYwV3poGWv0HD1qHRavLuAuvvLtouN/2So0eftnRcqImdT9RqWrXNBCZlwGvLpMN3RAuJS3HRnTZZcKH5I8GsonrzdoNsw4TsZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G72wbqfi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AIM0xONY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G72wbqfi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AIM0xONY"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2FXuK3439852;
	Tue, 13 Oct 2026 08:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yKSU+vFm57ly7jqu8dfGvrvf0W7RpnMapLxfJ0eN20U=; b=
	G72wbqfi3g7t0nmJ7ERcbSu/xHFk6mWOh/pz0wW9tZXSd9GpE4UcH4HdqKgH7YCP
	e/GsH7OZnjGPCfFnuXDo85g2HNiDHiI2pnGlW3btAXflOuvPvD6XNCwuAYAPDCHa
	JbcIDBalXzX776F9j+LAZKYpTgN7BI+EFDI/zMztPg5NBt4hc/1TrhO44Jo22hmf
	0iOk9O4Aft9Av/0+/tq+Z0INIkCRA0syjffZXYEgMXFqn0hOoK+52n1Zued4vq5P
	nItsDHF6svXb/a2mcl3ndVheQadvf0aNfMcEKFY4NV4/sfXXWA27P1/9HA4T+8eZ
	CsrUBUOEWw0hDhXntRZlqg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kjjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:14:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86WSH024081;
	Tue, 13 Oct 2026 08:14:01 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013025.outbound.protection.outlook.com [40.107.201.25])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9ywnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:14:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B8wj3dffWGnEDTU5TKaboMiaTojyIuwUTzDDlRAV6Vfbv8NPma2Djr8OHDFiBa7oczJASgg+HKsGXDIvePfhUagBvOGnJZGCIbxTcvHELmnIiqFmJtOqtUidWZ/1hjWsii+X01zSZ5FDS4SAtCD6Qz3LuzsgEwas77CLEPTMSf25i7SUrEtPnsB63QiExOBKY256vfFKdMHVBlcrhkvm4Go/yZFUutRrjRaM8fQZ+KGOjes3Hh2lbUMDgQ6W18qZLcrq9rjU1akhodCiSSvqpM4xbfZB5v4dTz+rW5o88PfZ+okfZU8zHp1ZanUSWISFPsIRjUIw0e9wAub7sEXS6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yKSU+vFm57ly7jqu8dfGvrvf0W7RpnMapLxfJ0eN20U=;
 b=REckIGAWc8YGsc079Az2jeJTCevDdKFx5DCAa//5Mg7+qrtVtrvsYWS4qbywlHqTYHHAVSI0JOqiWWT8eCnyP3XdrMdY5A7b5JbUha9AhHp3fVX3dKluZDvGh0HFlL1viJncyM8gK0eVX2ww1uexjMPdwP/qGqsCZs6Bh98oUQyE/p7iw+CEz5F8nTLeZYPOwrp16XTIIWDVjVMe9oFkuETsyDUbEHBiXl3PE8YVt1YVBqV3P43YOre6YHZKscGm7COggBX5//AO6a2TnR4UK6tLOLwTu/mwyX5coIJWTl1Ub4jFtMKgdw7PtyI7sVUtReauObJ7a1bxtgstxv4IRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKSU+vFm57ly7jqu8dfGvrvf0W7RpnMapLxfJ0eN20U=;
 b=AIM0xONYSzKXWpsXxwFhOKD0RbrOpqsOOdKMYVmpGsX56HPG7q+OWIPsBRDYNyfZMvoxv+jQWYqT4camPSh97jTNxKRTS8ShmpM7v1pr1ogkEpjbXdiGawHo6u0jSgDkpAhDuC64kY81QNszHom7NR8nCXbtjQiCCM3a1sFh3Ws=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:13:58 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:13:58 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 v2 1/5] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
Date: Tue, 13 Oct 2026 13:43:45 +0530
Message-ID: <b114923a5caa85f20a82659bde200d0dad39350f.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 90ff25c1-6913-4ad4-e299-08df2901ee8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	vef9TGfqZOqCnWTr5s26Nz0JlZecB4ceLR7OyGuQlqaA/YyB76XOUXlCGEqKFnZ8TJUHGKMsW4SEXYx8Qtjn+vHbOUZg5PqtgtdLXSbevHs8JCrUJT4pwS/KOSHREMlzs2HjFbt2i7CI8wz5czEC8G7XmHpAJdYommro3XRGqgdAOplIQ79NszjJkCxOOli5sDLRa1Jr2F6W0upT9t3YEcg5uIyWavtqJzab7+z/7XpAddHSSzSQ0KVEQEOUlQX02f/ciJcr1mTs98wrXMxPV/3KFucJ7S+YFXXTttP9jS/Sp3b3RwFeUj2DeQpdtEa8M6HH/oce+NYFdo4iwq9RMYyt/vv77g2EFr0pNlN8cDogNUTahtnDL62FOKY8r1Ch8UL6cDtsivZZ0Gb2Kk6SYvm5JyG5ZpbFnXwBFK9JIw5G4du6VS8+A2oHR95H6hfI6aN2ngAgPzVfgzbfOmi7C/rXYl97OJlSSufY43OKe6GbImoGlXmumWNAVBL8RI5nh2QVUzLQSmKBqTq3EOmd5G3ptZQZ+SvAnEqAb9WWigOGWcyvy/cCUxWFG1lkFNHM9Z/qsJlMJeO6JqnqJBXiLvyeFi/mA3nDNfDisAumWJsw7+F5NN7rOpqu27vVSstt9dRUpf4qFjvylQtvSbn7WeL6FEkfAB3IktiV+G6sKFo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dlQYr3hYGA2McGfjOTZrJE5sH7BQ0BQVkx9FAUPSpB17vNy1vmflr/DCxhSE?=
 =?us-ascii?Q?oJ9/ouwpC8QJRwqXfIB3RYUn+cK0gupqhv++HPt1tpYmoIN5omWqkthD9897?=
 =?us-ascii?Q?7O96VlWArPFsymVzbJMjJcCOnbJYFT+lXe1tfOhj2EgAlskywHX3v/kUmPKk?=
 =?us-ascii?Q?+hiL0rwRC3xTo9J9RQTGFfiENI3vL620PpteUu4DNL/ROHwU40fCr8GV7WKr?=
 =?us-ascii?Q?bOFDwl8Y+gozFZi+jC+c1jS9+g0eVQwosml3Rp8ylUMz63qFYn52VLxYGi6Z?=
 =?us-ascii?Q?jlJL2g/jnahyhYKS5BAj1+OTL+j3rVL0Y8Zd2kRmoXjBNjIUsz90f0/NPqaB?=
 =?us-ascii?Q?krybKw2/0LruDERRGG9o/e+R3LcNVRk3MEYXEbPbiyafzVYoFn+tEIRwX2Ke?=
 =?us-ascii?Q?5wq7v2GCaEU2xAEtZvOYf4PYxRz66hzpoYoCV3I2FTYo9tSWsOwZs/BHdM6X?=
 =?us-ascii?Q?g6G8xXEn4HQKRH+fqVqSg1mfTgvY5pCGERKSd5zZ8XqczIyzpPATO5lcRJF6?=
 =?us-ascii?Q?zQalFKoSINn9Zk2hF8lS/MSB97HE13RbVahvUWTmjTTeDilmVXD9SQtJB+kI?=
 =?us-ascii?Q?j8zwfoaWutBz+ZMViT9TdNoahDsK01aFAknS6q6252nGGV5lwaAjPUxniugw?=
 =?us-ascii?Q?niepEyo1/bQORu2MoN1J0ZKfOurt3jDmNE5ZyuNX2xpEiKys94RRXE0PZJHU?=
 =?us-ascii?Q?2/7QygfTZIvNBOf++eECL959Al+GSYDgH9QtXbSXJvl3ObzjYWXdMlmy/Xxk?=
 =?us-ascii?Q?Da9a8JnO38U66LhaQ/lnnHZvmJuRY533R+it2fv1es8pdxUKnEwa0TkEHphj?=
 =?us-ascii?Q?FvEOM/NzXGhobrNp7VBBImHzi2kr/GnN/88Sk9OOWruNuygewJeK6nl4iVNX?=
 =?us-ascii?Q?pPTeQ2SyY7wANaKLPYFOJ5Lt13HKf7VcUaosEGiUezXDDq740hicoDysLwj6?=
 =?us-ascii?Q?7pdFcrDYeZT/nLThJtmgoXGbQV1KYL6ECuhh/DVhf3iecOTVw8hR3Gds0Igc?=
 =?us-ascii?Q?fnuR30/LN1Q2jKYM5q8DKJZQnyTylmbqWjosqmn6cNIaOTZdsvgWyKBAWeUS?=
 =?us-ascii?Q?Z3MdPZkpJTXH6WHXVtE+rkKeChYQ3a/LoH4dkcxINCI2iSMqL06R9nAK2uwz?=
 =?us-ascii?Q?ObNzxEdlvMw/5tPpRbLXpUk7FwBeQo0BuNQndvSNzCBy30tVEZ6Z0pEALuVE?=
 =?us-ascii?Q?uAXMZijvfrKwgny6SQsTl8FLPCijzMGwJxW4qenatyrl8Lo7C3ufuU9+qhHB?=
 =?us-ascii?Q?oPRs14dGzEg2ytfuoGagQfq5GKFeP/o4XAbDTo7Puj79hhIo7xtbo5vZhZ6O?=
 =?us-ascii?Q?wxwLshqTO5ryptASl5ejfOhy3cCsGg8zvTcHLxcXXHTkR2K+bbegczPMQzP5?=
 =?us-ascii?Q?b3Ccebk2eAlE7YVgnJyp43I3iSpMiHCJjVuOkSSaCo5qQZ6OOpYCAPYYiQtJ?=
 =?us-ascii?Q?YW6zFPsIKh/zuFAcutHQhMb0jc2IFCBk6HNbBBuIn/X+++oAKhHAqijxd8Bk?=
 =?us-ascii?Q?lMnlBZnU0Zv3FlVJZf/RYXpCQEiSQTTI1MPL7lGkFoY/1PcmKvL6DgAZhFw6?=
 =?us-ascii?Q?1Olznw+/oIEG/v35uN8ktSH53X5ThXDfvLb3oLINR8/ve+t6+xCQnAKkq2uz?=
 =?us-ascii?Q?MeE8gVPk9u76ktFcZ68GwEpMqs5zJm1ysdpGRAH9/4mcYrrzLJx43Uh0ZY/D?=
 =?us-ascii?Q?yX8dZjNRDUbqRBCRfCWVHhkWUx7buAI5siMTbJxqYrJsHqt6Cpjw4cNMz7fi?=
 =?us-ascii?Q?0XMmxFPcfFDkM1a67xLuhXOJzL02LuAqCRqgNQOIQ70EJxMz4w+UopooM4CL?=
X-MS-Exchange-AntiSpam-MessageData-1: U9AtBSxZ9fxHLQptAJMKyI3p1ja9UOIKbo4=
X-Exchange-RoutingPolicyChecked:
	kgmZRXHS2LqRQtNL3uncwTsxZNKhCgYzIf2U3+we8ogiB+Iia8C/g2OAH0qSlXOaHzPUakE9SJbTHhCoT+F0rFsM+Hx/LXfQFCFvacmF+49sfgwxacBX6L1/5Ee4gdYGsggSEwv6prdO7G9qWhNTOrsPUUBTlTiGIkG3aIBV1+Us575TMmTw10FjiIRwwNgo95KoiIYjMpUGjdyCDDgzA5SOt8YetoGRioJKPvFzjviuZ3EtE2gQF+C3P49NKdWQcbvaWoDRXFjNCifjTTyJKdIFKwr3CW0Y3zuF8RovLe0KFjposmLDorg+KKdi2NI9Hx7pliafiii/zlrWESzxFQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3hc1nmRSgUYr6mSaTUZ/1XTO9J4W7pdEBL5fhYNzkAx/koMdatka48RdQT/P/WM78q8ophxV1jo9DNNTx6qs4Kb2X6F+jqoZi3/7pLUD1krzyAVmSAajkry8wMcGorjjhawQA5cwhYAzJOMvMlFP74rkOlN1M8dhGAmWxQAyn0Mn6I8d5tfls23hT2ZmnSJP7HKHtYmj3c+QQNwhqS99iaPvB4UmhkrHQ28LYs16gpTseA8yT2EtNmO68yit+GBVQbi1WmryYtcLZU8reprWQB9oxLp321pybeNO8PVmAVAUxhBnIbBnQg3QcejbI7286ADv5MCT5/jpPGF67R/DX1siGyBg3MPHQugaQBImSaxZUyChG+rkMg3Ao8EBM7il6KBom7dr4vJyFNZ1LbT6A+Qex+wZaSYKvGtpkC4AQWsGdtr4KGP8qJIE8due5QArnPVs/XvsbcPuA2NHx0VelJSwTCyAgev+0GnomI7jiMYfAy1wHYlAOHmQ1yxFvsOHtrXqLIHLQKvvboDFWxvHDIVMeNo/KmckwsA35w0GUfD6wQBqs6HAHYiP2XS7zNXZj+aDLlw8ICx70bjbssRR+e5bhtWW17eqLx6CUJ0tXCc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ff25c1-6913-4ad4-e299-08df2901ee8c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:13:58.4963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJwENVnpTf9sIRQvMc6ObQaw/ELQKSTq7DuNmrXO9qh/0bsoJnrzlkb3bTMu7v6xQmzI2iWLes5y7m5EjoA8jgN2wLGu24pMceD+UFet74U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acde84a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX4G5O8cr6QbLw
 eFIrI3Yn+YjNx9XOsGpVuttO7gv2SsfEL+J9wQ2IzYJTQE1aA2wKiUSh3su5PpxVQaH2YS2telk
 +whsC5oAA4z4uDoKRZoUGAr2nI0bhpDSkNcS6PwRMQH/k2sfMtAv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX2auNXckhxQfP
 My/mDmcW6qDjgAcFZwbscqEaFuUeVSGCQAdws8VRRL0TMBnfEsUn0lYCjfHlhCR/TPEfMAv08I2
 +nVz8phdeFvn6BtiqovfsxBhUlLGa7QkWlwgR3O5bBEtFNQJ5N1gp+RdankZ+FyNcnNyu7S85SV
 QYfgLRVSBb8rHCfxB706a6kZ470xKj09ThvWSYTiAsZv/zHsU+JPiVsrW6bP30kWFAlRl4AKfOj
 rsfm2sDFhQxDLalOWlPDCCtSbNlzSW3Q9VdymaHP2mp4mKlwpP+mJioAe+bBSESlWKPWlXPKVdJ
 485o1txi5vi/UgCR9tOHxn3vC6oPcv+737DlzhaigOiOVyEEquqUh6rrTk/nWDTvW4zXVSfrGet
 Tyc8nLgr9zVlRTwHhIzwQU9UnePts/erG4MD7j3H6OA0lwjl1agJFwhcv6hdnqZd6xWXQMytlQw
 /sGEoOhhHxqRRn8jCIA==
X-Proofpoint-GUID: oa3GLEr-Y6sfQDk8fbLNY5gAF_Y7SCsY
X-Proofpoint-ORIG-GUID: oa3GLEr-Y6sfQDk8fbLNY5gAF_Y7SCsY

From: Dave Chinner <dchinner@redhat.com>

Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
-> IFLUSHING, except for the last inode in the cluster that is
triggering the free. In that case, the lock order is ILOCK ->
cluster buffer -> IFLUSHING.

xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
so this can safely run concurrently with xfs_ifree_cluster().

xfs_inode_item_precommit() uses ILOCK -> cluster buffer, but this
cannot race with xfs_ifree_cluster() so being in a different order
will not trigger a deadlock.

xfs_reclaim_inode() during a filesystem shutdown uses ILOCK ->
IFLUSHING -> cluster buffer via xfs_iflush_shutdown_abort(), and
this deadlocks against xfs_ifree_cluster() like so:

 sysrq: Show Blocked State
 task:kworker/10:37   state:D stack:12560 pid:276182 tgid:276182 ppid:2      flags:0x00004000
 Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x8b/0x180
  schedule_timeout_uninterruptible+0x1e/0x30
  xfs_ifree+0x326/0x730
  xfs_inactive_ifree+0xcb/0x230
  xfs_inactive+0x2c8/0x380
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 task:fsync-tester    state:D stack:12160 pid:2255943 tgid:2255943 ppid:3988702 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x31/0x180
  __down_common+0xbe/0x1f0
  __down+0x1d/0x30
  down+0x48/0x50
  xfs_buf_lock+0x3d/0xe0
  xfs_iflush_shutdown_abort+0x51/0x1e0
  xfs_icwalk_ag+0x386/0x690
  xfs_reclaim_inodes_nr+0x114/0x160
  xfs_fs_free_cached_objects+0x19/0x20
  super_cache_scan+0x17b/0x1a0
  do_shrink_slab+0x180/0x350
  shrink_slab+0xf8/0x430
  drop_slab+0x97/0xf0
  drop_caches_sysctl_handler+0x59/0xc0
  proc_sys_call_handler+0x189/0x280
  proc_sys_write+0x13/0x20
  vfs_write+0x33d/0x3f0
  ksys_write+0x7c/0xf0
  __x64_sys_write+0x1b/0x30
  x64_sys_call+0x271d/0x2ee0
  do_syscall_64+0x68/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

We can't change the lock order of xfs_ifree_cluster() - XFS_ISTALE
and XFS_IFLUSHING are serialised through to journal IO completion
by the cluster buffer lock being held.

There's quite a few asserts in the code that check that XFS_ISTALE
does not occur out of sync with buffer locking (e.g. in
xfs_iflush_cluster). There's also a dependency on the inode log item
being removed from the buffer before XFS_IFLUSHING is cleared, also
with asserts that trigger on this.

Further, we don't have a requirement for the inode to be locked when
completing or aborting inode flushing because all the inode state
updates are serialised by holding the cluster buffer lock across the
IO to completion.

We can't check for XFS_IRECLAIM in xfs_ifree_mark_inode_stale() and
skip the inode, because there is no guarantee that the inode will be
reclaimed. Hence it *must* be marked XFS_ISTALE regardless of
whether reclaim is preparing to free that inode. Similarly, we can't
check for IFLUSHING before locking the inode because that would
result in dirty inodes not being marked with ISTALE in the event of
racing with XFS_IRECLAIM.

Hence we have to address this issue from the xfs_reclaim_inode()
side. It is clear that we cannot hold the inode locked here when
calling xfs_iflush_shutdown_abort() because it is the inode->buffer
lock order that causes the deadlock against xfs_ifree_cluster().

Hence we need to drop the ILOCK before aborting the inode in the
shutdown case. Once we've aborted the inode, we can grab the ILOCK
again and then immediately reclaim it as it is now guaranteed to be
clean.

Note that dropping the ILOCK in xfs_reclaim_inode() means that it
can now be locked by xfs_ifree_mark_inode_stale() and seen whilst in
this state. This is safe because we have left the XFS_IFLUSHING flag
on the inode and so xfs_ifree_mark_inode_stale() will simply set
XFS_ISTALE and move to the next inode. An ASSERT check in this path
needs to be tweaked to take into account this new shutdown
interaction.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 09234a632be42573d9743ac5ff6773622d233ad0)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c | 8 ++++++++
 fs/xfs/xfs_inode.c  | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5f6c2a1f3299..d4eb83e7934d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -916,7 +916,15 @@ xfs_reclaim_inode(
 	 */
 	if (xlog_is_shutdown(ip->i_mount->m_log)) {
 		xfs_iunpin_wait(ip);
+		/*
+		 * Avoid a ABBA deadlock on the inode cluster buffer vs
+		 * concurrent xfs_ifree_cluster() trying to mark the inode
+		 * stale. We don't need the inode locked to run the flush abort
+		 * code, but the flush abort needs to lock the cluster buffer.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_iflush_shutdown_abort(ip);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3ccbc31767b3..3139363d892b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2225,7 +2225,7 @@ xfs_ifree_mark_inode_stale(
 	iip = ip->i_itemp;
 	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
-		ASSERT(iip->ili_last_fields);
+		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
 		goto out_iunlock;
 	}
 
-- 
2.53.0

