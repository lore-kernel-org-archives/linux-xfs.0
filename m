Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A5C3FAE15;
	Tue, 13 Oct 2026 08:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879308; cv=fail; b=FXq707I0GX3XQEupnHSEuq0mbmqkMQ/nHiffSZR7cES+jjk5oVpIwBxS71lMPwwn46GnyaGP6g1UJzWdwy6+m5j4cnOYvzqQ8UMCTnw/k6H+mERWBdjfzd3Q1kXE3JGap28HvN9cNYHp8wZrmf46OLEdfHmX+pWdS6elYebH2Zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879308; c=relaxed/simple;
	bh=OrDOklpMOxQRViQ0T14WTlWqUIK7HbK97870U+zjNPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LnV9pIkbVG/TZPaAJaN/vOj8tw6WWBm+UAS6prARzgSyhSiEJzKsfGQ3CDibTh49CmV4jOJ1e5vNAPCMAJtcRUcUF8NnoD7ln0mxXCj9tojt48Tym2h8q+xkSYpEL7WpS/xs81YfNn0HyAQAY445+UP+rpUoQt3Fzd/Z+G4r4Gg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rx6ASqMh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Dmh6IfqD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rx6ASqMh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Dmh6IfqD"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BppI678222;
	Tue, 13 Oct 2026 08:15:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=B/NDq+ElZ0sta8AHNQYU5ZqPuQIOtgh5//R36FDf09I=; b=
	Rx6ASqMhMNT2Ngl7GW6YWbnZ1Ekdypqs2U1KnDKSqnClYl+sLsYgT1Cp1I/2fknZ
	EuDHWC1wsAejVvJTgJG3F8FoKbQc/N6WXRtLMzUIwcz1r+XqPo4lLMNXmaLWcoJZ
	sk/56vn1TXRagzv+K0y0uVL8G7mmGkP9omH90O2t/O8v1IwJtSTxKTQ3VbOyI2Vn
	sLveIxXchtRgK7PdR3MeOW1suawdHcowpxx68hRQSmqS1edCRbKIDmQ1x/+83Lws
	c0h2DRXLIrfGIac0t4rYUmEsy4Vx3KEtzWF/+cg1nqu2wdrBiGQE+uwVWrj9OgOW
	EeUyitnBCXj/0mWmPdhNoQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dddungc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86PFs024913;
	Tue, 13 Oct 2026 08:15:01 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9arc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fv2l8rHeTy7vCuupzLUpOCgwLxItZv/HhdpSFmmBeyGNaW4RDll56NfkfloNsKy2wsg5OfzIpm1BS8MnHjQch3OCNaN4aolOaLuGJTHgoVNXc7Pe6SEQMMOIClFhul3rMM5CC7ln3CjHqzgzfPaNDuK6twYLf/bnzJSTzU4fp3Av90OodZtV3UOU7lJEXlQwU07QDaziFNKmIWgZIHpK3KX6mobq4nWKG87Ps+do9yl/qHvFmYap7+zIp88pfjSUlB/KyNkhBNoB2pBJkx/wOU8oMHiZdWElh6nklxwIprl7uoNCIu6+FSlRtzXxXYTg7pUi2JMUtc8GUKw56riQ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/NDq+ElZ0sta8AHNQYU5ZqPuQIOtgh5//R36FDf09I=;
 b=tS8CZe6P0kDBl4VpL+9R5fDtWqjPa/qEkRnAHJ5wVe8Okw9NM9BDNGST6zrMSWPbBb3LVmCWfglCCMpf0csciSiYwyQIqxdyda//zwyGVcg0R2RiRPc94ITuEERCCPrmzS3UIotrtwpN0D6EMRN8YmLcAQLYY9stI6pY0+gWod4uaGQAudQHnY3/gtYnLtm4ZIj/3vfuHR5fjJuqDaGHWcscpzLpKQsbuhLHeDa5u0xdc0TBJr50IAPLtM86hOsZZsNGcvdzn6zYIiIvog4xwT9aLXTOJB5/NdIkkaE2lcPvKCC89lgrTCZrmbXVuJcVGC8bTG/tzKxBQjetzxCcnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/NDq+ElZ0sta8AHNQYU5ZqPuQIOtgh5//R36FDf09I=;
 b=Dmh6IfqDQSfb16qwkcIzbCTu1HjMJmqNuV96vAwm5Yga85+mS8H3T7exIQvXUmkxyVs8XCTwsR06e6DZAdiIOf9HN5bN/W6EHufIujsjCaTS27L0XUjO60ajqBMARZwmagCCl7ac+XlZ9WQyTP7+kg30Po3tty1yHuxaDdzJDjo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:14:55 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:54 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 v2 7/9] xfs: rearrange code in xfs_buf_item.c
Date: Tue, 13 Oct 2026 13:44:15 +0530
Message-ID: <c3603d2856e91aa512d091eb64a4fdc37b05ce2a.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0003.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::16) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 40217be4-722e-4e3b-5d30-08df29020f9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	a1BwBWC2rmO44uaGghem3u5bhKnp74WfguRdgLk9Mex7XiPQKJJEjJXC8FsqdWZCvnhfmtbxgaHswfsKQ0MVFLizW2Siiv9Hu74Tr2CXLrKD3hhhFPneBsdAkI6Suuf1H1KphTa3ZkT2Vjoaa5qUCJUXXA2/zN5FgydTclObOvsKCBgk1+1FtIMmK83UWdFoDads+4QwSFnKJGCTmp5+IxOfp83QwUpnikn+UNYRSyh2/8r/VCTWzzqT8u8SIIBJe3VGXp6IEmvxrQ0ZPKMfYO6XnZrZNFH/S8a+Kd6IDiIq77l29XjvOTMgfxHqimKhq9Rmiw6qRCLsTwjtGFJTRHjBpUmiK+UsW6b5+azvhmCcuXDOakZSBlfYCZUvcmVZOgM1YIZ31wnFWPibsD+dJl+eDLYVbXWrN2gAIqjaJs1eheHC0vViZHUqL5/ek9vSodlil6cQvWNjKdEAS8JPUDBt02t6HMVZYRdnrhC0xmcuBLXGWEiyU4IESEOUq30AutP7Ar1BpmBgNqMisu0QXmul79GSeYZaB1xpydticOTA+zVDTffxU1U/S+M58MoJ+7ofUTkbfS58voCoe/2MvmeU1vh9Z7n+YZ2b7qQD3TbmMhnCP2q0zClrtiutGWrCwM/YxYyR7fkoB3HKFWaJCJ4bI6tcPXPEVAnIJ7Lcm7Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sKNWb5HAF9dF5JntOfOCUrMKWPFVH5NGaPeSYUpcSCROcBwKOAUSr1rDXFQ9?=
 =?us-ascii?Q?XOuxbxUirs38pZ5AfN9e4HwdHrht4nCCUklxT2mmjkZ174BgAHRTOlidGtcL?=
 =?us-ascii?Q?Jz1usJf6SAOGvqjUxxTPR5LQ6DyLa6CGGvtOWCaijufgDWmKblNWDFSCXE05?=
 =?us-ascii?Q?ZBuBe8JXvxJhmS3NIUa+M8C/BbGKOIb/9D6INL4vRiaMAn7xF3RTzfjs6dgi?=
 =?us-ascii?Q?XmLftJnp+rePJwmtH4rDjYGkY3DKH9DMYRkLizvm6vs7pEf3NIyQKdAyW4uB?=
 =?us-ascii?Q?0rrAHGk4r30sG7m+2c6bAk4SUY+RU8xIfKN7z7QtMvealHxEKVc5Hbj6qhVB?=
 =?us-ascii?Q?kBWDofj03W5gFhJuG/kRsViHWGlLMUaSi+ypCsK7ahqtsFtksNtv401Vx7+Z?=
 =?us-ascii?Q?UGGYYLxhAzxLOUJ85uB9fYTP5tRJpfnJ/zNZsu5i67eGEGsaGJ1mRgquVXbj?=
 =?us-ascii?Q?0/FZh53LioN6czGm4WLw4f8K7rBuTaK22+hI268Qs0Nh82PUI8fOeovnkMfg?=
 =?us-ascii?Q?WP17CCAV4htzPBB3FKn0fUlBXDjzi+4uL1EOB3KuS9BTpbfTYL87gOoIKzLF?=
 =?us-ascii?Q?RvekNNyOlnl3McNyZt9pDkR9KhVHr4jlyewmRRpgng/WzXpDioUxOI97fAhs?=
 =?us-ascii?Q?qUFHpt/22Ia1/ncTxvMaetsWP9Dl7ua+UMLwAwNQ5G8de1clA6HNpDVGvcta?=
 =?us-ascii?Q?yxdhgdJXzu36sC6umkw8W7lapqppuZ5q2FMHkiK7qMTyoe1srePTYJ5DmZiT?=
 =?us-ascii?Q?tuB7yS0vsU3QLnQyeJeY863YbgUUOkTJoifrW4XUtD2iYuAihRkwRS83cKn/?=
 =?us-ascii?Q?ueh/ogvh1g1iwGNuKkYIlLy9t1++xqSzv22oLgsXxTvr1pczrSotDxavtvz0?=
 =?us-ascii?Q?CRmdCyHlscOI+H03YyW72xZxUtBsglzZKV0ildqERnuhxSsz3vs1T859kAxu?=
 =?us-ascii?Q?V0XM8vf2zDuSJ0NzhCeGUWi1awlt0uTrhcCd3SbS/84+dub15O0zg6qivMSL?=
 =?us-ascii?Q?KX+QBcYsuqIpAJ96qYpFN485DdvFvQG/NA5iFldMZ8Zhx9PYr80fRIQDd1jQ?=
 =?us-ascii?Q?trmXYGnUPNSgCH93m3PF9HpRGnv8VG/o6rhuiUy5XjdIvtddeguqOXBE2k1g?=
 =?us-ascii?Q?64W1Vt0N5nkAryOjrTrXaCz/je/n2qUlJUY2jBPJ46Fu74B5uzrJa1xJB85e?=
 =?us-ascii?Q?nxDoDgmE1xPPjaDEBHKBUzEMjNfHF+uyNLHMzj3GOPBs3Kl6op75FCnUTyzB?=
 =?us-ascii?Q?9231nzQ8ITp9uYgqIVP7o8r91cEysEARs8kLs1mdP/3tE8brQsXEKDcHJ6t7?=
 =?us-ascii?Q?cy0Wj70Sl4fx643PzNZJu+eedARkvFcO65raR/B4BIfGuLGwfKlQ45BwgdG7?=
 =?us-ascii?Q?hxhYJwtrtPBSImXAvc0y/Brv47S1QdBtuAMlGLTM31kcg2Lj1oQtP7RQaL0E?=
 =?us-ascii?Q?kvuMTwJa1QGfCmjFG4T9xGpyT4E4ZAGgX/TyuVaV+IXitZWUoLtowFPMzBmA?=
 =?us-ascii?Q?LztcV/kLiWMdmICiicbbCbVpQUMz/AN6F62XqNNadOkOL2sbyobk9I9cqxwJ?=
 =?us-ascii?Q?Ii+KJuplVaMFCPPst0qbbHtCELqkE43l1CXeMRCFVHzI6imjskzIvpn/638Y?=
 =?us-ascii?Q?H3TFYKoJAmbJWCbrsOsS9/PedHlBpHTFesRxlPVHEwe9xBqptgqcM33A/VmF?=
 =?us-ascii?Q?LYDt73mXJ2FdasEcW2NX6SgopObhb94QXxTm/mFSlBc0mDhlNpp9ApU7T1yu?=
 =?us-ascii?Q?7xdOILg51GjHpoUGEnqnk6CIsHxG98IIQ2AoL2YKtnWWwKU+KUCuyFqDnpHi?=
X-MS-Exchange-AntiSpam-MessageData-1: Fqtb3l/GwwgWdcHqjDf8tj801h8smoEHvL4=
X-Exchange-RoutingPolicyChecked:
	KvEzazu2A+mjc0i3kqvqF2rL3bjSpI+lJ2TXWJl9ji/Uvnd5FsXHGedQEAnUcN0J0oP+l5xroGAVHfnphA58tdWQ+gIpq3m6ADMsnBxk/mcjACJIgqI1/Mccqyx6gWUVVG8uEffYXqeQ0BQx03lvKhuy1oUrj1kusMGrr7wdSnKIiF7p/swJMtL7XWG8I/RXkGiYabXQxl0KitB1CCLOo+4fEhAO3PfbNJ3wo9uVB2/NzvUfiVCcayoLEg2Luhm4iKUhamEs3z95pOG6ZGriRBUP1CN+PCYfERN0VhVFyErQrRqHyfymG4mWivGCR7H72ussObtwaR+27qlSLEdKCw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RnBO67IRUmm/Ax+5UnP9uDZaUcJF60OuA+BVrJraj4g1Y/lw4wCPAJYe61sHPrT3qGzN6hFj9eo6byuHnrk5FJ4SAZfO+kC5XB80S1PuTSDqBeir/fqz80BY9ornHiH7niNr/viYg4iGe6VRYT1tkYUBmlqT/Te6Sfvia34471y8DQyuDRSHARaEPTP6OAJ7Px/fpB81EVdP+O3rmUlf4bioKpS0F9akgWeeL2rwYIwlGVrb03RxlXI6Lg3PLtngdXiwRuBALH+UzyM52nRhsperLjhc+/6FLmGs+voYeBbyZJ+C6XtVA8T5TxTLt9akDojLN3AiBpHX0nszViswarrWx55ttSVIMr15bBkpBzfxpwuS979vnUX8/cSTtnGSo9AIzs1hJW0D42PoEAYrnOCkbFOOqGsMgvTMPW/4mxj77m11vN3Ti+iZya1rGGoAv5k7QkARo+me/Mu+5URiunJrKsU6SUatBto+7zsy/L3Y2sSwNTeXPaq8QnAl3pRj4P4AnMKS3MazwdC6eC3vqffZYVr2vZDGENYq2OI7LkC7Eqa2wAANwmsOXfvqd7CXN5H27WniKFLXOqBPq1UQSce0WskMGomr68kE4y4rrnA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40217be4-722e-4e3b-5d30-08df29020f9f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:54.2119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K4a8wqf9rKnkFWv2xGnPIQGVGRZPTjtApVNEP7S1/uhqTIodotmcfYFg28mBFEVb+U0Q6ehLbzVyZRn0gboFnFQ+RaNSR8sTL+WJf8e0NoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Proofpoint-GUID: GwQBhJa4u0C7d4Kxoa70jrG4yY_pjL3h
X-Proofpoint-ORIG-GUID: GwQBhJa4u0C7d4Kxoa70jrG4yY_pjL3h
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXx7qeSKayY0v8
 T4tcz3CwzzpN3E+B8jhsyVEoxJST/0wbJsUauLT75EUHr1TyR2JtrSqJmungBGBUwu6wBrXuKsU
 GvCfVMOxyGh5HTtC64ATHeuUOgwJRLIQMLyuKmFk6X1RQx9uGbpV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX/pCd51Xk51hI
 X/hYX4MIwI6Zb8F8MK3FKNhDudwudE0IIxOFGmgqJZn2SIV9DCi9y/cgrXqvJTeO1orHnMWVJFS
 T3HPUcXW4Gn+hiJcXTjBuHvquUU3Wr1hxkvSuzDetZGLYfKKeKnKJPcLhg25ayCLiXKuDOWnDw7
 YOOgNJGOILoufJ4Es+TFEhhZxxVu0a3ECWgeFykq1muNNRn0RSsgTxJkm59EyL4GaEzWu/RHVRs
 B1nIOPSqOHoCXr5I2lmiQg3Q7DGtX9MldGSDV1DA9Ri+16VeVohPl0Kcb96dHUsm+9DeiouEURE
 PVsAcS2TFkvPogumCrzr7e0ew3ebugKjZB5NAJgb9vP3xKyPzcHjKhzokAv4VKEba3BUYTvmtNK
 5OS5WOdTPdrouErzrjI0y8aR94iZgJolygR+/d/ZIGu3QiaL1yafjZHrxhzR8WZ2KYNgbu9gjga
 duD0sr9U8mlTXZifY9g==
X-Authority-Analysis: v=2.4 cv=J/8/fwnS c=1 sm=1 tr=0 ts=6acde886 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=WmVTiCyuxqgg3mnwYu6p:22

From: Dave Chinner <dchinner@redhat.com>

The code to initialise, release and free items is all the way down
the bottom of the file. Upcoming fixes need to these functions
earlier in the file, so move them to the top.

There is one code change in this move - the parameter to
xfs_buf_item_relse() is changed from the xfs_buf to the
xfs_buf_log_item - the thing that the function is releasing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit d2fe5c4c8d25999862d615f616aea7befdd62799)

6.6:

Fixed conflict due to the following missing commits:
	[Continuous range: 10634530f7ba^..d4c75a1b40cd]
	d4c75a1b40cd ("xfs: convert remaining kmem_free() to kfree()")
	49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
	afdc115559c5 ("xfs: move kmem_to_page()")
	f078d4ea8276 ("xfs: convert kmem_alloc() to kmalloc()")
	10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")

Removed ASSERT in favour of existing atomic_read-and-return in
xfs_buf_item_relse() due to the following missing commit:
	3762113b597f ("xfs: don't lose solo superblock counter update transactions")

5.15:

Fixed conflict due to the following missing commit:
	182696fb021f ("xfs: rename _zone variables to _cache")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 118 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf_item.h |   1 -
 2 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index e0c75aa3cca8..ebcaccc4ad66 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -31,6 +31,63 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
+static void
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->__bli_format;
+		return;
+	}
+
+	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
+				0);
+}
+
+static void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->__bli_format) {
+		kmem_free(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
+
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kmem_free(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_zone, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+
+	if (atomic_read(&bip->bli_refcount))
+		return;
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -562,7 +619,7 @@ xfs_buf_item_unpin(
 			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
+			xfs_buf_item_relse(bip);
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
@@ -672,7 +729,7 @@ xfs_buf_item_put(
 	 */
 	if (aborted)
 		xfs_trans_ail_delete(lip, 0);
-	xfs_buf_item_relse(bip->bli_buf);
+	xfs_buf_item_relse(bip);
 	return true;
 }
 
@@ -792,33 +849,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC void
-xfs_buf_item_get_format(
-	struct xfs_buf_log_item	*bip,
-	int			count)
-{
-	ASSERT(bip->bli_formats == NULL);
-	bip->bli_format_count = count;
-
-	if (count == 1) {
-		bip->bli_formats = &bip->__bli_format;
-		return;
-	}
-
-	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
-				0);
-}
-
-STATIC void
-xfs_buf_item_free_format(
-	struct xfs_buf_log_item	*bip)
-{
-	if (bip->bli_formats != &bip->__bli_format) {
-		kmem_free(bip->bli_formats);
-		bip->bli_formats = NULL;
-	}
-}
-
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -1040,34 +1070,6 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kmem_free(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_zone, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	if (atomic_read(&bip->bli_refcount))
-		return;
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
@@ -1087,5 +1089,5 @@ xfs_buf_item_done(
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+	xfs_buf_item_relse(bp->b_log_item);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 50aa0f5ef959..e3ccbf3ca801 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -51,7 +51,6 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-- 
2.53.0

