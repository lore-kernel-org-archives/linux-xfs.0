Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC2A9443;
	Wed, 16 Oct 2024 00:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037519; cv=fail; b=HKkQwOiWoiopI1efv6UIkANxXWBbwUvsvBDqAcPGIQhuTI1tS8alHZgROocOq1TFDNHqmh1rA+C3yIfrs009K4FxSzvVIrcw048bibBoGdlT0Q7thmfaQFbogKzZ8Zg+bnZAHNtxTUqNgP4MBt9km2HTQvCa8W90En8zOk8pLgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037519; c=relaxed/simple;
	bh=B0h34weELd0p05Ox0LuvE7CMfqtoQzrzye78I29nRKc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YoUfiVxAGCSwjS6qKgY5TVf4CXbphOzX8kuoGVAzIUaF5SiGsZNG1yKS7lXcyxJ/yrE3qMyGhUqfd+k7V2xMITXoFGzF9gs4MYt25LXbXNxwiQz1gnt1qzSULk8Q4/6GsM4o6ZJzzllTRdY8uOqbHVarxywGNR5Jbfb338aYdmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gX0k1Hep; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y5uzQ1dh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gX0k1Hep";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y5uzQ1dh"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHth1P019381;
	Wed, 16 Oct 2024 00:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=mvtjWTiAL1Xi9oxyFCQGngt00d3w9ZhdbMPsaqffMOQ=; b=
	gX0k1Hepq6mtucnAjpg2MSMXg4w9qZDD/jjFhLJol+deWFGpIJQPYEQWCdDK0p5v
	jfmMtTH0SI1m10Dh58rRPHXObV6BkDKBZCw/jAwmhr9gIYNgTKciCe+cZoiHZwYU
	j286OMgAYcmP5JPR8C7MJeDMpVicOzGZXlv88kwTzUjcQjuGHG/MWXeCDMkYGRZB
	kqZ/RB4Ztjp251sjnPxxi+jKXNldcnluwWKyFkOHEvZ5jKIVS43jd9nth7oE/gVX
	HCq3eM7EATtVfJ7cVQWBcgjnrUso3aek6Mj9AM/lAqdaTvDf103YLKZe6WqOPMys
	qqt1bA8q1ujWTLCu3493wQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gq7jhqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FMbLDJ026319;
	Wed, 16 Oct 2024 00:11:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85am5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aWwh7UYuPGo2re6mAHldEf35vL5GeTE9r9DZGgs+AHE8XHSeMUuqiMFBYU8oEUzg+L0o3WCsfQMOHMNsM6W7rAnCXwi4gnZps7BfdBUVPt5P2wNWkEM5HS1EmXndyFsBZ6MQRRTdYP6PHsIm70TlqSTGRGloH6SszaspzAL9OM2FkxhrVYlTO+F41WMZXPTcwsovQ+dsUXfNCTo1zhY0771cUMdZgjRLPnHyQ9neyonFb+jsWvYBROR1wwRUPFqHuZcdtMQhgbGNvEttu1GUAVPQcNZap9BU2x55Y07S4mGwp5YtpGLobLeeWwHTRVR3Om1A+nid1Uf9m+Zsr6O6bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mvtjWTiAL1Xi9oxyFCQGngt00d3w9ZhdbMPsaqffMOQ=;
 b=StBkaDBpGNMPe+Nk3d3Lr2fvQFV01qxvE4ZyHKrFgBQDO8VD8CTm2V6hwXZidDxQc5uEp27UmPL9jf/EZTTQdzUawOyKodS79p8RY7TuvL/bbI/PPKdLoLkzf0LjhvbqN3GtqEUy+YK9opFJ1J7kTcyZYfXDqcrO1NCMx3s6LIZX8aDN9NMpZsJauE2kII+OayIUPyvtl8rG+CNncZY5QO7F4uFe9Dwx8HudO/lKP1YFbnZ0K2dYTSocihDlESxkIxcpiaIwM710MSTKDwlIQzFxnVOIhmHgA85fH+kSewOY0nhg5KCrJ9wqSsjekRYK1uBVmMzGTfDpW2GWyqxYmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvtjWTiAL1Xi9oxyFCQGngt00d3w9ZhdbMPsaqffMOQ=;
 b=Y5uzQ1dhGmuEhlBqkRl3gS5mwxb8UUn+055z+Q+8+WEYiIIOvFWynzVhDeWM7AX38XOq1H2viUOXBQ2faF9ZM5RoEefG3Fg7rV7KiCCc5B4tdijr5FmtMEqvp/uyrMm6T8/2TvLL7Ud8An7TyIVlHq+udmkxBrXNNwDFWolYhpc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:11:54 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:54 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 13/21] xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional
Date: Tue, 15 Oct 2024 17:11:18 -0700
Message-Id: <20241016001126.3256-14-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0206.namprd05.prod.outlook.com
 (2603:10b6:a03:330::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: c7496325-2b27-4d68-215a-08dced77245b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6ld7aYMQOygdzmDlP6VZS7Brry+AeDDcvuaS6lQ4zjfNvTcURhUpXBhsu3e3?=
 =?us-ascii?Q?65iQ0kTk6bpHE82WS9Kqe5ZbDsEmZmpkkkQNuW6VSlFuVd4O7A1w9K/j5+N+?=
 =?us-ascii?Q?3k86Bw9vq03j3QUVKYWrP8rw4Sm2c5W6i31WeYp0GhpKiUUhx39MeDBsb43p?=
 =?us-ascii?Q?TWMFZgJcDIvAU7FLxsadgOuBLOcmd43XXuJpQujIzqJpeRY9p0ZAvnlZ1V3Q?=
 =?us-ascii?Q?HBfu4MlY/shvT2koawgzul902qNxZfzKTKbLzeVFekpl/LlT7Cr6uGes0Ft1?=
 =?us-ascii?Q?3oElOTYTctMHCnObR8n1i0kXF7rswr+r0x2QSEiyqnl4OOsqyIHP45lyQyCs?=
 =?us-ascii?Q?YUcpZhU33NNZe8kfmdJIrIjaAAARFYu7dKdtSfYb+DqhLwqd59sBeC4hM1uD?=
 =?us-ascii?Q?iLCpt+qJ4RXNMOxoKLXuCHMhD9JH+lxdYQySn94w/Y+8uyLEmujh6u45OJHe?=
 =?us-ascii?Q?bSbTJ4EsRzX998C/Un+b2h0kRarxoDcv5gAIyN9hLxdLWtYLuHcQ9rkwSooS?=
 =?us-ascii?Q?ClJSUsMHD+DftJuaAp2BTY8PGT3nstag/P9k0RxX/+WFxgthQfIxTP9yFYDt?=
 =?us-ascii?Q?o52SCEmSURfEc7BixNiIcaLx8k/MwEqdP7fn8bwvcH9SzvTcGzRNTE7eZM4d?=
 =?us-ascii?Q?IrcGOtvanyfFD3Sj/KV0bgffFjGPqiQpv1oGmWpQtHeXOVcdOPgR3PHEoQd/?=
 =?us-ascii?Q?GVN6ceSU6bB6ECSGeLAqeTVknTrhJ8kArqmKLaFj6qgFg3EjehZSw14bnjJ8?=
 =?us-ascii?Q?Jp9XCDpeGwp0cicc67patKiOyVWpob31xOxD17FxOB5bkCjDSxAAWul7Spts?=
 =?us-ascii?Q?eUoawY7iQEASbtKA8iUCzSAIIRH+mG1eworyvTSK9IBK+3sxZOzFN5Z+0cCv?=
 =?us-ascii?Q?XTwvLXXrwz3/RTcXUgRXWaS492m8ajS7UrgdMQQnTCqEMCtAi8BphB8WIAOf?=
 =?us-ascii?Q?7BLpYmvYmno1sta3w5kQQeqJzOE5NcAlhfsD/fiRIpGujqCYdIhHR72x9RVK?=
 =?us-ascii?Q?ou5CKObC9ni1gVA1UELhxl2m2c7o3BwHC8F80MTPVDG+SEI3+1GCsheuDKB1?=
 =?us-ascii?Q?tnTDvKjVNz6+3Cec/rY1uAe4xbC4qP1m7XUUDgFwV3plv+hRRaKBRY+PioWd?=
 =?us-ascii?Q?d4/oHzuExoejlp6arsJ7LYSWe50rcgSZ8KvLfMfjmv3CVnB3FM3ScJrSfocC?=
 =?us-ascii?Q?0FoTnfO9ilFLQmHWUvY+PhRywzEfFuSZ10DOzQRMl8QM7AcH5lF/qvR3XLuE?=
 =?us-ascii?Q?2QNBcfKk70JM388JLCL6At2uCSVhAykHv0tV6Vj1OQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FkYIsC7I8p1FpepDiibiKZ4/EqTG8QqqEGEWwZ7hzTJwoZR40d2lzVzI7M8X?=
 =?us-ascii?Q?XroO8Gvjhr2M2Ut6teqOCOd1B/yinE7t1fR7gDUiZQ3gOPNu/Wvsc46ZrWbd?=
 =?us-ascii?Q?fRtCT48FYfxIQ2ntm9sG5h30LQSkA7HuXAg+fg1egMgYzq18io9v5fooegAi?=
 =?us-ascii?Q?Lm6xAzGuot4U9QNBtOZjez0TLkAcSDAPfCOwOKvR6kiYKsVjHs8H6bzmNPT1?=
 =?us-ascii?Q?7g9nPQaJhwP9MEA50iISpcgRYkOzak0sguucybAFzlJaTKSTiuYeWAB6eIk9?=
 =?us-ascii?Q?Y+gwJsZiWd50/4bddFZFwzXqSO/tg/6na5+LKNsE6TxPUffKtXHT1WXCZp6T?=
 =?us-ascii?Q?/0SDdUTmBHYn7HUYD7glJmUuDW01xy2U9E7V3zulS5ACdIzVDW7LU/g9NAP1?=
 =?us-ascii?Q?4e+jfoazB81vgccqTihcCajhA3oKt4QQlWZG5iY1UxMiwadKceqH3Sq/XXH6?=
 =?us-ascii?Q?pEQ6PfApzOs6OmTi/rQKMxTxIMhAvkAAL1fbbGnl/Mn+novjAyfAssgCmxiV?=
 =?us-ascii?Q?4J1TdOrj+ynSr7S490YYmjls32qougL9dXbUizTWo6Nm2rBhbvxWYflVtoOS?=
 =?us-ascii?Q?iK2Q3i1QsvGEFwLMHq11VV1xApsLHBhk2tC7FNB2rIMTTt3XV+ySPkdChj2A?=
 =?us-ascii?Q?KlPayvhYwCes+MJRbDJcGf/40sgke5a5YLv6OhQx8e8DsSnusL4JidnufSrg?=
 =?us-ascii?Q?YOG6L7P5eRv7nEvBdXlcxxCdEg1aLSoQtjvooAjA8zbUvEkDpN9+PwHEQe7L?=
 =?us-ascii?Q?j2OZlSKJZ40xFAwg4o/RR9tIVZb/H/PF+lnIcCEPApJekBvEp1zPkldOT8gq?=
 =?us-ascii?Q?F5v+TkAUt/KNiv1aS2pVuW3Goy7boxi9O+ms92tbWs8mMsLtst00skKowCHA?=
 =?us-ascii?Q?vIkZDm8iL2g0S1vpIDfE/hoEJDdQYmePos6hcc1kNpMC4Tpe5qyTkHXszu5e?=
 =?us-ascii?Q?pN8dJu8jypaSqNq6YlNGJpo71N4yzFniToiyYYxMaKQl+9lIRjd6z1BumMUJ?=
 =?us-ascii?Q?H3UZpEfLm8SCnZDzsI/Erf2lIHYeLCP5N24CAPY0z588sn8srXxif20fK5f5?=
 =?us-ascii?Q?qjBympf/gsKAhzIQIayMy6fC8fxcWqtkHUStxro8xzmcYaP1zEM3eqkkN1VS?=
 =?us-ascii?Q?7Nq3yZ0tkm0IMxLi/ACWmSWQad3WmHjTIJRvBHr6K3CqESTWi+62zL8TGrwT?=
 =?us-ascii?Q?M2EbsO/hjTW5OvKhp7xRom7wyWJGZcT/xQ7BYWRcKspdgxt6R0MveFtwt7ie?=
 =?us-ascii?Q?3AwVBNSbchK0fjexjCocXuR4udaCVLkA2ROgfFvNdXIWOYbCqoyag3KxD6ML?=
 =?us-ascii?Q?sOuBNsqf2hxL9NZRp0mO3sgCw6Lceq5kE5f3jMjoEZlleG9mDieNllWJHBAC?=
 =?us-ascii?Q?j0Y4nveggNSOAVM6ACw2M41olGsra7rKhlvDtUZsP2IdkI+Y4acJIDEkktls?=
 =?us-ascii?Q?LEuH8LnWxM4NIG5M05M/8y5J5mhJcDxRBW1+O5DPfJu/6MNfVwn852vN333i?=
 =?us-ascii?Q?W+1yiAJ5Bl3qmvwPzbMWJso9AB+nF+TI/gwWILUU/hLzsIwbeuH7GxeL9rZv?=
 =?us-ascii?Q?+t+WTcVP6Fz7cxM4v8t0CtKJDD0ty8QxA5/xpzoLQQlDiKTpG/uadcpt/FhF?=
 =?us-ascii?Q?zHfeBgZ6hGc4FUqXozwnL4H+8wmFqRtJMg/LHHT1MrOTJnkGY4hz/ffz5NQy?=
 =?us-ascii?Q?0TzZ9A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EmPnan1qFIkHlv932za/6Eoh1wC79pXZj4mHOAPkTJT9URPsAfij66xs7aWCKV5pcXv60nxNfSDBI34bMWPkrQE1N8o3oMthF3SqhOaMzFQR76GkKUJ7krelfsUhYJkEiDf4oQ/fuNJHHPbOPEqW0vMMVrFZOozz+If+VMFxSRis1tf6mc9vsBbL9GORR7o19EJ64mNi9HEd1WHWOK2Klz72UWMjybXKiyu3LwQbRDfSVWtI07SXDdWTSnZzjeFwczD2TBTekcLENRdugSq0jpC5rSSZ6fAjRXqSvxLGLPtT1iC8cBrRlX01m96R0jUoGAZbtMXxa5F90fKO8gUyWj53vzQvSjziQ8Qdb2+W9iv38S3G8Vua6z7otz1R9Z+7DGuELNvx34IFBMwg/xHarFj0WQl/9w3jXz+dWP70SLjGeG4Os+Yva3i0KoZYJFX4pNWlozijgEg66cl13QXCwyxiIfRFQLVAwa47ifMw3iJwat7kyNrZNeQETL3lJXTaF0P31UlQhcrcU/7r08y7Fvi0L0RaBuBKUqFsRKzYlXnPN3Uj8vbJZQtXKaNYsiaHmOFF0h2r9kexYoRsDKl7OsoUdIA5uvC35Rx/IVbACCg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7496325-2b27-4d68-215a-08dced77245b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:54.8055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tz/pOB3AZtfEpzbxy49PX8HRK/dKLzeGV9N/MXrX4/+SS0GcJE6uICcH35zy4KFXeiCVI31wjO8wXM5m0Am7gi9MNY8/MlTO6eeyiYXM9tI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-ORIG-GUID: SFMEgDH0zo1eZ9KQXUIVom_KY8o7fIrW
X-Proofpoint-GUID: SFMEgDH0zo1eZ9KQXUIVom_KY8o7fIrW

From: Zhang Yi <yi.zhang@huawei.com>

commit fc8d0ba0ff5fe4700fa02008b7751ec6b84b7677 upstream.

Allow callers to pass a NULLL seq argument if they don't care about
the fork sequence number.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 18429b7f7811..6ef2c2681248 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4595,7 +4595,8 @@ xfs_bmapi_convert_delalloc(
 	if (!isnullstartblock(bma.got.br_startblock)) {
 		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-		*seq = READ_ONCE(ifp->if_seq);
+		if (seq)
+			*seq = READ_ONCE(ifp->if_seq);
 		goto out_trans_cancel;
 	}
 
@@ -4641,7 +4642,8 @@ xfs_bmapi_convert_delalloc(
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
 	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-	*seq = READ_ONCE(ifp->if_seq);
+	if (seq)
+		*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
 		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);
-- 
2.39.3

