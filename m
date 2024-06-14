Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2887D3211
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718329808; cv=fail; b=W85yUmR+c9f+AGiNe+cm1PguZjzasAVR22+N+Ym5AGuehTXSkVmtUiFs4BHPas30Qe0FFw50OfrlrWrgRYJ44dgqkQ0bPZNrCL5QReQ12K8b/Z6ZvQ/ozeMNGnLQdhty8Uk1FXWo2o4IAe8K5yrI3bZAhqAiONVYTDx9qi5w4pg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718329808; c=relaxed/simple;
	bh=nfoaLKzd/AvB1cVW5YKg13V1gt/GkV6hE04KVMfkPYQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Un+QTilChf19WsTUPGPVxTX15Pxm5rhPlfFCfZbTQQliWykgit9ME5ffK+msycusetuRa3BSJUKn/ceQDBYSluqOXZKl5nopi6Xs/ywlBwa4c4Alne4Tqkv/OlrctUNYAJq177cSFlwpyj5APqGUirWBdiNLrQlAD1fLOVNGz2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X0odEcnj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Nd3IOh5B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X0odEcnj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Nd3IOh5B"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fWN7006369
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=qdluHNktMQI/+0oPHzcna72Ke0r0azmSgSieW9j1xCg=; b=
	X0odEcnjymFH7iL6+8HmyPqP0HJwZvCn24cJ/8Ity063g6Bx3xKYVaNU7phtqVKF
	v94oMaHcoRHimPyjjzAG4M8/cMjud58X0o2kg3ntWLw5i/l4K3R7+iXez1qWXUzg
	yzYkl8fJemHIa38L7z7YKn1FxQjfhWoQB3gBxeZUBUmMqnWdMfNOmpFboO+1f/g/
	fTgsfAM3l/cP9e5EfBWDKdSG05Ayoiyc45dXkqyXLI0siaasutYNgMRPP3iEiEP+
	LUrNyCcV6CLtZvhO3+sFDlxWzxtP6f8+3ZMKAVhJa+QwvV2w1RhQudIxNRd3u4/U
	5n3W3mMs2yIEg0hBo8Yl7w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhf1js9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45E06JVL020455
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncayaune-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8tqeHJfozLWLSHZqwL0b4uLDsB5zjFbYEG9QoIWeBC49U+9iqleardTjGX0REgI70AAdRYfti+OOz+aPEOD7UzLOE+jGgJJXBPSHXqjVCasOZr0kBT17xF3HvlRM76Qt/8KwxnnDXj81huPivF/SUgCeuJ7gJ7WvPzUAFBEDReW3j7IcTWeJpcqS3aeg41IVXc6cmTjGtRT260FkIgeP/rCe8DhaURNp67q+S2mOk7FV53LqKLWuDh8cDvgxP1fnyF93faiSa2BZp3jRmoj1hk1UfS0kEKXnQzQWCSLYSfAGXjrs3PfZeqGeJx//kF41iP5ZvtPOGdB9BsAdp+beA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdluHNktMQI/+0oPHzcna72Ke0r0azmSgSieW9j1xCg=;
 b=OjIqEBRyvZJSpnvhxYfdGMBrSEeutaXnp1hvMoYRfW8TqANcvRGSyH3gAk00424tz/C+lDbV5IajzfGqUhd+umumcwbgFhk9jCTyKxl/Po2nr75hwvQ3vQb7AomloOWwfSfEp3ZCkcGSq08b2n2oZPTUP9hrwh5adsVvRowrnYsYrybfJkIcfOr1NUgErSPhSWUMHaf2TRLiT/eQCMlQE9dS6oaR7QL3W32ogTIiLCCqBYHOWA3SNztV5KqSd/uqLOpp+UtSCPgKMaRjGjoogjO0gVTSQB2EMiXyLHn+uzL60y41HMCz6QiLMDTpxYAqk3m/HXvqwIWZXhDJ3cyUPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdluHNktMQI/+0oPHzcna72Ke0r0azmSgSieW9j1xCg=;
 b=Nd3IOh5BuaWQ7cmH8k7ocPyx4Dc1LAlW+grujSF/OBFTaQUDOgJymz4QQ0vN4fzCwN4THs5UMiati89Ku9+LK3ky3bS+Np/8FTnzKGcfMtWNo3kXPsuJryub++BLpyXS41HbWWfZ9KkJ7Dv4m4mswbHSjParHdg8q3kEEhCmTFw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7475.namprd10.prod.outlook.com (2603:10b6:8:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 01:50:03 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 01:50:03 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 6/8] xfs: allow sunit mount option to repair bad primary sb stripe values
Date: Thu, 13 Jun 2024 18:49:44 -0700
Message-Id: <20240614014946.43237-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240614014946.43237-1-catherine.hoang@oracle.com>
References: <20240614014946.43237-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::21) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bdb58ed-484d-4459-57e8-08dc8c144ecc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?c4QRn2B9tg3LHuBzwzzzgx/UhBR+myu7/YM3xHxhSYUL3fnDWat1oeibN9Zh?=
 =?us-ascii?Q?oZeHzEIdhcO/xP0jn+43v9Bs6BZClEF77iNFZwzhz0kIJN3X3gBaiqWb/Lw+?=
 =?us-ascii?Q?Q6Y4YWjeU74oxsntGGAutyu0tGxQJXzZMaXZIezGLk5HdbgpqFynHM2zBExG?=
 =?us-ascii?Q?cNj2x1bMOTJCXtAyqMK+LhXtuOjAY2gfMfUZfDDCVNNQiOLX1dBOlXyFfDGU?=
 =?us-ascii?Q?9ALRr9OwSfVJUNNvwHVSSRweChYXcPbfW7Vq3lXJlfh0/n4XslB/TKnRokHX?=
 =?us-ascii?Q?SN67SwhhSGOW3aeOXXQA4cRy0RpxZn6ahUmIOfwwH4G1+6Fb3Bk5GoylrWCy?=
 =?us-ascii?Q?l0qdHZPZSh3NDTa3Qwynt710x+eOQd7rbr3b6gr4t/gzXe0Rqxa6dTMvpfRb?=
 =?us-ascii?Q?w0SNdRKWkuJDsRHXxJeWK//00+9BNinKiAF4Aiap8ua2WtO4cJcWqlvrkwsP?=
 =?us-ascii?Q?Sv2J0fFwO5+m7UIhYG9brLYijSk7cLgdxa4T2t7T9v+q09RZhO5XP0sUI7Vr?=
 =?us-ascii?Q?H+3Lxxchi65LyOlpQHKLeS4RtvvedsW0j8cRmTgWORQlDDsXqLNkcUER5adV?=
 =?us-ascii?Q?14rG8wctnaVS41ipSgrHK1/QJbLvrGUBocxLje59CDDzhiX5Gr8/3x/RTsK9?=
 =?us-ascii?Q?HxcUQH17T5vV8VP5T44zIlVmYp7HM5r+DtgBMwD+/Qaj1M0t+2abM2caTrOw?=
 =?us-ascii?Q?KhKzFnwmwG189h6GJrDayeSfYYc2IQbu4w41wQuDwL92YaaoaYFdfxOs+9oh?=
 =?us-ascii?Q?zfRcOtg+x0trya2sfYebDTArAq4L3zWsG3bkC0HEVtSXZAXztmnjo2i84pZj?=
 =?us-ascii?Q?rpBnnaKHE3MFSJLn89n+b9fvabdHjpd7KktmaB1vlapxqHNro3TwCeJKIbrm?=
 =?us-ascii?Q?013XXgX2+J/xNAknkkFil1p410lwCrpCRw/+KXkDo+8vjF5KpyKDtSn/MDBi?=
 =?us-ascii?Q?nHeehG2PyKifehVcfwKk7s9L7BKqvYYWHw/DO+8gOjG9Wt5wdng4R2cSvJyU?=
 =?us-ascii?Q?51ksIY83wQ5W4Id/lg4av7EhlvFLqpt6YgjOoXS3Ux1XufecRneXM6UYvpLd?=
 =?us-ascii?Q?VBWPwb2nlRoBrFtMiJaMx/P4nVVm8mOqMR6ZgTUEwxvWY+tOhEaeZj0l9/yg?=
 =?us-ascii?Q?P4YIgjvrD9hTfhZqRoMK52F5APQPkL7iI54jgVw5JX6BBAemJ8pYvWZCfkXX?=
 =?us-ascii?Q?VyjTyvrJYAZfbdkytt2mQTRxMOUA16wHr50rIzOJWYhW/hQ/BeBZQtyplG5O?=
 =?us-ascii?Q?G2U1Ixy+6H9L60QFCWqDZQRtrqkmsbd8XQasHSfo50RJWcAnsEfDwhbk0CDL?=
 =?us-ascii?Q?5TmWgK0XdFGJIoFCv1JGGfe4?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?0h/i83/L0VjNayhH6K/fy1HCtBofiwbHnKmUgPFL2EL0Jedv+6h92X1WkzKk?=
 =?us-ascii?Q?g/NJ2PQ+on9ojHm1hstz6Xt6mZlprvJesEkGsRn6UFNNL3HJCfJ71uKM9awC?=
 =?us-ascii?Q?OFRu4hvEbVpDUPMDGvXmS0qhyz8UVgsM7O1I/es31LMQ31qo9wXIdtLXuopJ?=
 =?us-ascii?Q?LgPuZ9ht0vsoSq+b7pQZloQkDYon8nE+bjRcEuIYgXzvYCK3J0ck0d8O3ZXp?=
 =?us-ascii?Q?0e4IXd1jEOuu/X4YxIAAVjG3kjxSs90/DVA4PPOqz35/Q/NJhMjU5XK+snfm?=
 =?us-ascii?Q?h3+l8UySdSgqhSYqvSza/5YdRfZNqsvRJQeV1CFllvKFU7rzv5erFm+mAZcs?=
 =?us-ascii?Q?1kelWraCWFCfPNSB4cVpnVkYFZCUw8hMOAl7wKLdB8UnjkGM040YmugX/cQ3?=
 =?us-ascii?Q?TH9yMbqDtrcTryvmNuCLb0NV/qqbsUkVvdsjSzNYKWov9I034tkoN4SGuJIE?=
 =?us-ascii?Q?n+kdIotuuOqiA62PcocBasRK5W4nhT2g2TQJjg0vNcB/YyrkLhY7jXX8P5kF?=
 =?us-ascii?Q?Fl3FOgw4izu3FMsJFvxAKQnVbZfSWSGqNQaNjLiamgiTnq/d1CvRF4il9KJl?=
 =?us-ascii?Q?Ez0sZ1K+7wE31KxdJmyE413QLcvoGR0WTr30CYgCcb5avM2lRov1dahwsCyG?=
 =?us-ascii?Q?8bIY3pKfdVhmyNxjoC8Ror/K/0SCUBTV4SwhLn7VmZ5V9IWpNbrwIXoYL8DH?=
 =?us-ascii?Q?Sn0v4lV+HvnnsEoCxQrKNf4lS01Era4Nk/81INd6LqqHHPk4kOwxxylKmzUd?=
 =?us-ascii?Q?N4eDG39oqzieG6f943PzNaOQx6xVJ5xPqptEQ91YBX/dfy5nE5ZxUZZ1Uhjj?=
 =?us-ascii?Q?p3SpOjj4OCxrgZnKhdELt/muTYXEXFWSQu+JaV5i+P26KFBcAB3sQN9J8hEz?=
 =?us-ascii?Q?nwjERzXgHy8yCWIPxnaDZPXlU0haTeqndjrFu8DBGJwFLQC0wlp6tXa23b49?=
 =?us-ascii?Q?sNKM0TcrwYnO9c9Ih+ep6uqBa6PT74Ic+OPhE91IOU2g3VyJX6WAYErpjFt4?=
 =?us-ascii?Q?TJUs0bNvkOrsc2K+ap0AJsslhx16YboHg+jlrdKrP/UmGyJTo4LFm93pSnv8?=
 =?us-ascii?Q?TpqfqgpIyPyRp3s2kx6M0hiqpo8eUsP/bWt5tnDFX/G+UWNRiEgt6gdDLVc1?=
 =?us-ascii?Q?xJeh2brSAEU7RI40S7KE1myM+brSx9/IoXGGz36WlX/4PxdLBeGfgrcuxeq4?=
 =?us-ascii?Q?upewBYamPuNVls+PUMqnJ5TyPwg4GquNBPw+/wBg+gEvFn0HlFMAv4+tBSDq?=
 =?us-ascii?Q?BESbpxhrJxJ7+ZleU5QJfek4UH7eHqbtJ68e24s7yNmtMKU8qP7FkgFyGkDZ?=
 =?us-ascii?Q?fEgk3LyLdLNnedL/pCutCkkUw3C+qow0I2XyeZ3aDm3PLuR0G5qnsKCitih3?=
 =?us-ascii?Q?gp1LtPi5kM5ajvtbtGMXpBvF2uWqcvVc6MjkommoxWBxy65Cnkza6U2Ssdk4?=
 =?us-ascii?Q?QJZQYWeiwa7Wn1s8hD7pPxJLI9OkHzQl3YJbU9DEnsjpNFoeoyfCPDTuW9kT?=
 =?us-ascii?Q?P0X6AlbiWBuiq7Kg1DbdZS2ZDfQC7C8rfIC99/fkJAAiz5CBTvbIUeLu1mFB?=
 =?us-ascii?Q?D7+38XNetSKynC0x1uh0S68jGHfFmqaKslr4rbNG37Avop+BaU+r7egvSOl8?=
 =?us-ascii?Q?9fS3QOvGIQTl7j4J2UFwb2940XZ/bI4OgeFBnneSmrEJTQPHhAqG+Te07rq1?=
 =?us-ascii?Q?stvwaw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	759fZVstsgQO4bbU5HAhDYVXCjQpc++TSQ57yHoMYE2B3ES1p/VJBvS2RC5CfB68BU47lQZ6tYLWwcUMClyPQAmI7MSir7NVfmtwvkO84B15xb3BkcH7wPKl7gBFLiaOGsAwz9v+LOj3PucP4aUU0YbacdaI+ZE0Tb1Sin78CjU4NI/tOGKCwU0OUBsNfoYPRF7jXsz/VS3rTwCE4YhGS417/Bsm5CxkREXldqk/V9PuJHMoMRVvayMJp3H5CAzo3I3FtFb0vPpWyhw4vxCOrOK8316LoTgBFcuI/jq+XOdvqRSfK8FJE9N6/AZefkVqEfpmIg7hKcfEXh4q3wNYxRWzbysyAhDpJyNvci6EAnLc8UbmzMgerceFcGZo9wyd7d0BQxJKGPdM+8oY5QTj0C9xUlLDUqO4I3/1FJIYSCIDlXFc/INpoVGb8fdmNRBn4hIezQp12Fo6vA5zRYtn25EA4SSvV2iY+C3W/m00j7JhKwhZfMbclEgVksp5JTrijFCFrvNiQyNcnp8MmtJWP+fc2KzOfFCCEPOFFaWjG+Vej83Iz1D7gTljAhHlXGaqy5mrl75kZd2KUcBEda2jGt60PokvHfTuH7fZamAmW9k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bdb58ed-484d-4459-57e8-08dc8c144ecc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 01:50:03.0549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kbCLGCcdt6SgUFxBsuW5/aBonHst+2RRh1xYxCvFjEpdkke0R2TypbJQQ/PIAS9EXFX9cUU5vOrt2aMz3APVApq7jnXXVCp2R1nnb5F67M8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140009
X-Proofpoint-ORIG-GUID: YrR4f9b4kiHYI-cSPxl_qtkecrs6KDRh
X-Proofpoint-GUID: YrR4f9b4kiHYI-cSPxl_qtkecrs6KDRh

From: Dave Chinner <dchinner@redhat.com>

commit 15922f5dbf51dad334cde888ce6835d377678dc9 upstream.

If a filesystem has a busted stripe alignment configuration on disk
(e.g. because broken RAID firmware told mkfs that swidth was smaller
than sunit), then the filesystem will refuse to mount due to the
stripe validation failing. This failure is triggering during distro
upgrades from old kernels lacking this check to newer kernels with
this check, and currently the only way to fix it is with offline
xfs_db surgery.

This runtime validity checking occurs when we read the superblock
for the first time and causes the mount to fail immediately. This
prevents the rewrite of stripe unit/width via
mount options that occurs later in the mount process. Hence there is
no way to recover this situation without resorting to offline xfs_db
rewrite of the values.

However, we parse the mount options long before we read the
superblock, and we know if the mount has been asked to re-write the
stripe alignment configuration when we are reading the superblock
and verifying it for the first time. Hence we can conditionally
ignore stripe verification failures if the mount options specified
will correct the issue.

We validate that the new stripe unit/width are valid before we
overwrite the superblock values, so we can ignore the invalid config
at verification and fail the mount later if the new values are not
valid. This, at least, gives users the chance of correcting the
issue after a kernel upgrade without having to resort to xfs-db
hacks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c | 40 +++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_sb.h |  5 +++--
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 571bb2a770ac..59c4804e4d79 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -530,7 +530,8 @@ xfs_validate_sb_common(
 	}
 
 	if (!xfs_validate_stripe_geometry(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
-			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
+			XFS_FSB_TO_B(mp, sbp->sb_width), 0,
+			xfs_buf_daddr(bp) == XFS_SB_DADDR, false))
 		return -EFSCORRUPTED;
 
 	/*
@@ -1319,8 +1320,10 @@ xfs_sb_get_secondary(
 }
 
 /*
- * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
- * so users won't be confused by values in error messages.
+ * sunit, swidth, sectorsize(optional with 0) should be all in bytes, so users
+ * won't be confused by values in error messages.  This function returns false
+ * if the stripe geometry is invalid and the caller is unable to repair the
+ * stripe configuration later in the mount process.
  */
 bool
 xfs_validate_stripe_geometry(
@@ -1328,20 +1331,21 @@ xfs_validate_stripe_geometry(
 	__s64			sunit,
 	__s64			swidth,
 	int			sectorsize,
+	bool			may_repair,
 	bool			silent)
 {
 	if (swidth > INT_MAX) {
 		if (!silent)
 			xfs_notice(mp,
 "stripe width (%lld) is too large", swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit > swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sectorsize && (int)sunit % sectorsize) {
@@ -1349,21 +1353,21 @@ xfs_validate_stripe_geometry(
 			xfs_notice(mp,
 "stripe unit (%lld) must be a multiple of the sector size (%d)",
 				   sunit, sectorsize);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit && !swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "invalid stripe unit (%lld) and stripe width of 0", sunit);
-		return false;
+		goto check_override;
 	}
 
 	if (!sunit && swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "invalid stripe width (%lld) and stripe unit of 0", swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit && (int)swidth % (int)sunit) {
@@ -1371,9 +1375,27 @@ xfs_validate_stripe_geometry(
 			xfs_notice(mp,
 "stripe width (%lld) must be a multiple of the stripe unit (%lld)",
 				   swidth, sunit);
-		return false;
+		goto check_override;
 	}
 	return true;
+
+check_override:
+	if (!may_repair)
+		return false;
+	/*
+	 * During mount, mp->m_dalign will not be set unless the sunit mount
+	 * option was set. If it was set, ignore the bad stripe alignment values
+	 * and allow the validation and overwrite later in the mount process to
+	 * attempt to overwrite the bad stripe alignment values with the values
+	 * supplied by mount options.
+	 */
+	if (!mp->m_dalign)
+		return false;
+	if (!silent)
+		xfs_notice(mp,
+"Will try to correct with specified mount options sunit (%d) and swidth (%d)",
+			BBTOB(mp->m_dalign), BBTOB(mp->m_swidth));
+	return true;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 2e8e8d63d4eb..37b1ed1bc209 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -35,8 +35,9 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
 
-extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
-		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
+bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
+		__s64 sunit, __s64 swidth, int sectorsize, bool may_repair,
+		bool silent);
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 
-- 
2.39.3

