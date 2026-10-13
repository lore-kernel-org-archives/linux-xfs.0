Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE4F3B38BB;
	Tue, 13 Oct 2026 08:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879403; cv=fail; b=T9ZiV1dnvHfxXnvlknNoBi73i24Za4mv6CMDr1n9D8EtUPfRErs/o9ZQNmnP+risWoDAn9Xng71wzFdU2jZ6hTxApMPHxG/qQtyy5sQkywnTBeO0gXw2QLSQlwibR844S0tTiR3r65TX5LCRodobeCm+VRt7gcO6CBDaVEwCmgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879403; c=relaxed/simple;
	bh=nX/INH9j658EDkDGURREETAmdH1H4/wtpkalM9UeJ4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aB5WcO6O+aL8QUFVPIs3LRbEYGl1pkEqY76F6VcbCCp9JXSltNYg+yJMVT6VubD//v2Kqvw8pU6JqeBdsr5rSc5J41bDYquOgVDLTO+lQSwJjDGgBJg1iK194qdEqxHgBMjyk3gil+h2He/QxuT9SQoiwWCTok/5cSz3lwbm4mU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sAQoiMSg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=F9tkxI7I; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sAQoiMSg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="F9tkxI7I"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CFLK1440653;
	Tue, 13 Oct 2026 08:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OjzuJgWTDYcTfpIzqhuJ0/QLdD2na6oBcYPRe4DCl8Q=; b=
	sAQoiMSgDmokxA51f9ssYoidhczqNwdQ2CWmeYLREv7/w8FHWmGm1oeM7nPjl0JX
	QqelWUYtzLQgpCLhFuWTa3+3FSvKQgjt2PNEthpqkI/y8TbcWYdRAUR23R1FVXb6
	TO84+bnooJepebLUQ9ztSC55rZ3dr8KJafJo2abIfwdLT3KRH20rLX3vKTrSAiVc
	ATjvMzhcYOsxV6jv3Tq6mzRICkmIKMoSFlwv9k+iav7+Xtza4Ss+WKNZVpoVTE9f
	q6vxh7fiQ1qp3rF6ai13oNPzwmj4rIJ5q1jg6NnLzrYg8CtIXdmb/yAxhg3WpzMk
	4vHg4oKe6LMd2geSE9QuIw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7ukab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:16:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86Qq4025023;
	Tue, 13 Oct 2026 08:16:37 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011069.outbound.protection.outlook.com [52.101.62.69])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9atek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:16:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X3Ufp9+/jV1phaBdeGhCPYP+Y9aDlaSCTzsryKNmU+gsdCkGeZ7kSBxsCGGoVYWfKKfhM9g6NLlK8nFzdpZs923psxGR9WYz2UlhjTlc/g6OfxwXSryMvnSY2z/ZsjldWHtEbHkrvX9sw/gOR1xFsS713SogHAWD0I/CttKa7edLLHBTc6P+CWRPHdOjV8xCfdm9XOAo7S9KpY0gDrGA11ZammnIaO/XDJLLU2AyjbOAXyIrjFdjZ/f5XD873QVXuTJQykoMkhaj2SHYK5PfcF6xyLKLpt0WygGLueop3mrLJimW01b+EwH4IKwKzCNY7OyiBY5rOW6YBMHJUyEapA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OjzuJgWTDYcTfpIzqhuJ0/QLdD2na6oBcYPRe4DCl8Q=;
 b=BPPGrQcVG4kRlPf4Ixz5EAipdQRSoXSRAvPSWI15tKnD/sJNCde/hTWUCiI5Asmc9BRCgo0FOOgRG5PFMqSypK1WJ0rnT5mi02uNCFxRHFZoblnANnwVW9Ti4L6sR4uwrABav1l2O0AcdOaIIQPj57K8DePj0CKbWTTAX1afVdhJvaLaR5QtmrE3oZHSj4DKQOkgb+HRXdzCrWLuT3UQpGB9qe+LQMPD2Ls4DdRjyuj9R5ag42tQbeh9IMgKu5xQtEUHH/noz+68YrWhgnNv64p44agVq1pwa9xTZXa1JB4YaBRoWSD41Rx6EXc2axYIao40vmwn0pL8YSjzQxcMBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjzuJgWTDYcTfpIzqhuJ0/QLdD2na6oBcYPRe4DCl8Q=;
 b=F9tkxI7I/krZoi9LEDTev8gIL41OcMrrpsfBUSEtE8CDX5hBL9vvduI16hyJU9jo3g+3El8vXp15jbGiU1sLqPF+d3oXLBrQSWXILkU1mxoCkFVSOsKKJV4TeyuTch05ojx9ubS/4Oha1Vtd+Qd/cqyc/tHNO5/mTQpsWiWDbxs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 PH7PR10MB6507.namprd10.prod.outlook.com (2603:10b6:510:202::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.10; Tue, 13 Oct
 2026 08:16:34 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:16:33 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 18/19] xfs: factor out stale buffer item completion
Date: Tue, 13 Oct 2026 13:45:02 +0530
Message-ID: <e20a4c889208bf5271a3f073ccf0b4ce0adf1b65.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0213.apcprd04.prod.outlook.com
 (2603:1096:4:187::11) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|PH7PR10MB6507:EE_
X-MS-Office365-Filtering-Correlation-Id: bcd2a89b-f3e7-4602-5a21-08df29024b0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|1800799024|23010399003|366016|18002099003|22082099003|10067099003|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	voucDPddFHxCpx4CFWAVOyKeCFEsRef9heU82RZZtaIcSlzEG3HdwibpgpwCROGFKQ9njkEvltidx+c9PiBSI8JIzcmjZEGPhnZF0yiQfd1spdclxLCznLRWcrEMbFMzm08lSdkAj6/l1atMII0lfJHD+FoZOGmRsH4B8EgNRbMWenCiFCPhPGtddeF4nwYqr3OFZ5PKp7MTeupEtZlPUl7GA0RJjPY41PElPnlVa7vVJ+Otv5jTPSl13g9/KJOMSnSbA5yPRjACHRv2cq6sTF8VC9T3T0LYzatlBlM/n2XObPqXkyLJj5Xvyl55FueNYcOduM+FAx/WBvr5Jf9Y09HyC1Ye72MXvJguq7Nrw5stkGkrI4GZCbh5iArnUZUzpZS1sfCWAjun0zO+ly6hLzWtCSh7t0K8L5EmIDkV3e0BlWauK3P1ktn/MSjjBgFBoB3lpIZ4ugig/p2Nwveam1jhR5DbSAnVDbGFZUbTORjO46mbtD0pYnGYJtTSzjwzIFAM9C1U5CH/1ENAqgzrVgPkQdbNqUb0XuczCN74/mJYrT+C4+OO456JwK8HWUU+7vkeh1AjgiGO21s9WD93kAZrczjtvz2OXRI41m4segVOXCUyJCRcQAzM1kSNJygobvHN5h/7YjWmew9ni36H+6ivk7JdPMVOB+yJspUc36w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(10067099003)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?++wEVCjaP1dQd23AZhc+uIJY1rIwQYo0ps3GqEimfIwchyw6PZLwoQo7IgRe?=
 =?us-ascii?Q?J18MvqOjIi/xGIPhkQ5C5ppsLEhhoSm48dnvJPadWeQhevfboXrvfoC2D/8H?=
 =?us-ascii?Q?HEyoGb223BRv2rysxqfGf1m6n1Y6w1Nr6GrGqDFtqX6bhj09XDWiocl2nIf/?=
 =?us-ascii?Q?+3loKpgDnKexn1e1nx1e0bSINJpeKIL1anBIGR+z1WRvqGd0YeC+zV10a930?=
 =?us-ascii?Q?aFcKnVAUO4+Wr5MlxVKjLqClpAImo6ywliPRyouGS0Iqh8AI19m0f8cquvZR?=
 =?us-ascii?Q?I/eYrDCiFJTyT4vdzHE5ncabWaFACP7CE8Kr85+jAAiBMRawmCEJyNDLwv3b?=
 =?us-ascii?Q?rh1Du5ej+iTVyMQ8ju564qdKc9F/ZihfrvyiYK0huNOcsQL6fqyqb0CLuo5n?=
 =?us-ascii?Q?EJw4Oo8hCUdk5vyrprMEAycJiF1P5g4tgH98vsFyMtbz2qygu1CzZDToGHC9?=
 =?us-ascii?Q?EOcEkcVQyqdnIbtq1tQF9TPtWIIdxMwomW+RDFSYe3Sf8q0RU/YL9haV6WCr?=
 =?us-ascii?Q?ffSt8B9U+yokMSdpMNOyz3LPY0fFnHsGasDZFYIWxNJyttuz6/ljpmLcelU4?=
 =?us-ascii?Q?SfxlnXgM7bLYrHVkoTmlSS7NJ5sObvN+Ad6U5J1Me7a3M3xuSHOIWLx5uLOQ?=
 =?us-ascii?Q?6YIBMu+ZHGI+mMUmkOtrPtuGy7+07U7tbxhuYo4U+bgRdkbTbgypD2VkW9WK?=
 =?us-ascii?Q?/Rl7eIFzyeay/kzSq6dmEWKEujy3BBYy0krnEE4LAuYiCem2wSwPVa07oe3D?=
 =?us-ascii?Q?umxwwAWKiLLIJlCh/0BhnG3FhbhlE89vH6U/pRXWLDE8CVkKhK0zjgysj0et?=
 =?us-ascii?Q?5Xx/Wybn0fPOdJKtdcaNlMSrwZrrYVuVZ8Zg9M2oRnYt8hGLIKOJKR6ftS13?=
 =?us-ascii?Q?NawuLE9Bp9DKayBPFFykL1sgA0xRwh2dEwuaae16eFD8OMOtVu4y6GfoytMB?=
 =?us-ascii?Q?O8HOt+G7FO9iYDhsEt+Z91eq5oJU+dXLrvJ9aXQoqlwFwTZ8XltqUdsmctLX?=
 =?us-ascii?Q?bskde5C6dH3ADzYL+5NQaGcaOL42vO71M0FnNskwcJqlwNp5cxEj7iDvNZkk?=
 =?us-ascii?Q?VywDaX6xP0BBmX6xsTlivTOkWPzlSzy2IvARcYf84wKR+tMbXRHr5x58AWq1?=
 =?us-ascii?Q?DvLUqKy6tlRZdax6Wjg4Jj38iYn2vmyFPjSZHcCNiIsGgiyl01E5kuWaygBM?=
 =?us-ascii?Q?3LIhUfgtXVViwaHi+ANVe+/WecaLQZmoWf9xwUaDg/pGrn7l62dm3EfJjKYr?=
 =?us-ascii?Q?QEb7ntf9ZVVtpw2p/Lg2tkWBpMpCz7uCAzE0bYSUq4yJMGt8IyWWjDMt6ork?=
 =?us-ascii?Q?SB0e4WLA+Egh/vpw6dUP4KgP4wu0/5WtE/8d0JSfgobCYdQdP6pnWY9f0YuT?=
 =?us-ascii?Q?wQv2MBKjMK2uZQsG+1fV+eS0wwwh3CNBDj0UF6rRqRx3Akue4AYGKBZ5rI/v?=
 =?us-ascii?Q?QwPyLi6Iz9ZGttAlmP6wgK1aLwwf6vmRP4MJwAhg4aDWHlWK86vZpToBKHFh?=
 =?us-ascii?Q?KwwRIPUoStTPMMuPqgRtUIk3Xsm+HJkpODqZQG4GhZ2lFcfr8rc+6WYDJEl4?=
 =?us-ascii?Q?8VjKRJH9i03PJw8oyPMbG3aCLC4830N2h+JkD2rb1rXiloOwOWsM2e3m1hGL?=
 =?us-ascii?Q?7rtQvhmRGVpWE+aCnBzEjaaTcd7p6mju/BHaT784ZU5Kdh6BzSa/TvPKrb5L?=
 =?us-ascii?Q?xbJeZzyiu31dEyWw9RJfMLEEJuPI5Fqw0JsamwWBIAbFEHw5neGCwViSrCOF?=
 =?us-ascii?Q?M0OitSim8oFDXgdqJsheYI830ilDDhwimdQOuf8zBdE+aGA48tzpMSGzQMFo?=
X-MS-Exchange-AntiSpam-MessageData-1: ghGeQeeNqUMmtm60J6zz1uWm2ZvMwE2wwuI=
X-Exchange-RoutingPolicyChecked:
	pDwo2nenhmyoqDnN1ao7N6qbF9vZknfuTEEcmJSgZYZOeFREax1dHlySmPcms74y+nyPPrAWS8pfbRFgBzvwrJOaw6n0IHwNeVc3feyKyMlVyF08RN5JLJ7eciMiK3avToilyjG/9cdDZMQIyrxjmBekliO3IwQZDKzTkt5GPGjibm7PlM6U+3JjxDrOs+VKet0VKT2w5SVh4YV+PM7zW62VZun0oEr6yQA2gXWmu8wboENn2uUuIasUnRb56TTl3g5d1vsidni4h26BioPhZGGfGDzavVoB72LiAGdAojF5mmYalEgfs1Wrrl2dRmBTkUYHqsqM8arxRKFYKYfTqw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gnlfJvEem+Qu/OXfuU69k5GTDoR3/7ZypU0UNEQksisyS2MY1puyCSTarFinrytK3gojhjVdbRR0LzTvjcpjMCXogDyyxsFRt1BRZy24f3r23OoKGAaDmCbJ9pfHifClx5nP79Cagp7alI+NDTHBFoHtdm1Hu/Md829IEpBJHxOZRAAKGf5xttxvA8iCEETN9BSN+dA6cuESCCVWm/6gHm/z6EPKDtNxHzp0G/qnhVLUo8V9mgW2tu5fkdSbBunMAMIVBT0tYEA09z4YrWeeXvDywxpuZAbNamEUDqb35xM6lk1Rh2OpHTeLG3c1DnNW0INKp19HjuamT5gHPv1VglPGLGSfmXM9kTP0urimy/hkvLXxzvvls7LrfGSgr6wzDbfYS2Lyrp9XMJeZCk23fxmJ7zPsCmITVsTPN0QL32RCU8oPr1OFYdF11aqmVLBnouSbEmWIcXov2zsr/x5TiqmiSUdcNmEQtdrqp1Clb4DFKNqlxe6EwOnA7zi9bnleWb7zk0MHLw89tjjbYMo34J9rf+K8EilIi3EAzM0wwNPV3nR/vnztbrmOodqfhKrSJP9oRRquk9iGeCl5Nwepgi+YYW/OTNpbVb4iCL6nhf0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd2a89b-f3e7-4602-5a21-08df29024b0d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:16:33.8570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: buIwyw+5ebS6a2aJyL4aGSisFamUV8ZONPiP0EDED4x2/vN+NkfnGivL6dJbJCeo4AfU3TxRAJoPZM5E2mMoXP8l4696LS30lRlkK46wkaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acde8e6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=HRhzHcoIBzGTXiVGymcA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX8dU6eKrgCaWG
 A5hkEPuxYNQ/PJ6HOg+Rju8LIT9s9lkyIMp1phwbhkMZZPvmL4eOtAZ62rKdR/GEl8Ovn7pfavx
 mLcfZQetn21BrFR1h7aJfRJws0YS0nvaaDiSCTceM/O55IolI09tBE5BcG3tW8XDckl4SVpqqJh
 HEobTI5tYWAuITCc9f6792BSgmQiwqSHb0+uAOfg6HgtRVjGDeqFYbR/EKH17e80p1uiE+opHjL
 ctxK2VzH58zehsSrA7nVqdxCrlmJgOiTPVP4XcaWxqS5Oj9y6SEDxx2LQjthKffavyvLBOcveJA
 s0/4RX0CIsGBEhvvz1WvIDkeRPSu+z51Utk+DUVQ4KBc3CC7aDhTROErgUQ17rsWCcDJHEHIxNL
 9tjdN+hEDIAC9wc9DvxbQcnqLOX4GKKPzM14h7zLecRsbIdGJPLhzgob+527GdEytim6MHeCj3C
 MmdnEG8zgSrqk6mkxSQ==
X-Proofpoint-ORIG-GUID: BGBFHr8J-tO5iTaioPUIWg-MgX64iCVD
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX9WBn01cVnMdH
 b1R8Qhrk4kVfRgJDIGwaf7TGClHLpxX2g/IhA1SFfvkJ2EBlx02fwz46j+c5gTpIZGVjPUIJ1Dr
 QvSGtnJ5jiPZlt9KMAr4V0XJmmHZZjgiYzOtdDEWZcomxU7xKxjy
X-Proofpoint-GUID: BGBFHr8J-tO5iTaioPUIWg-MgX64iCVD

From: Dave Chinner <dchinner@redhat.com>

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 816c330b605c3f4813c0dc0ab5af5cce17ff06b3)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3124f96ad6b3..3a96279f97a1 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -459,6 +459,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -508,13 +544,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -525,22 +554,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0

