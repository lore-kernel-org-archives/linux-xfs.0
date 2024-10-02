Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FB51D1510
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890898; cv=fail; b=ABhL9prfijzanig0gPJjjkMMgYI4HVvqZ6IfDwELk1IgMYCLA6CYid6lGInGtKFSGbe471bke5o0hy9HpjMmZm7FXirpEg1+DPFpjw0hCHjidW2I1KR3b1+jFsYeYcKwHFV6FLKhi4rm3a5vpWTG9d0KVcRNIUdB+caaP692b10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890898; c=relaxed/simple;
	bh=/q+tEr9kbY7kGyTmxdqdJ3oV/ODKsw/QKNy0C1nTQS8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HGPSwpt7jLTiLZiulX2ZyE+bnQeuCz+LZt2x+0h/d4cHPjIcr4kAxoIh0yOknzV42tas+qUr1JTez11lZUxTMVmGXXXzcUEsjSsetf3vg/IFdEdjcwu+k89ZQSLv3EeHxg7uFD6gwovX+b4xYCAIQtS19quPau23zUSLyxQc1sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Fw0yYq7k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pV1jn5go; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fw0yYq7k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pV1jn5go"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfYa8013221
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=+y2+BJE6vvwRyd3KeDqYlmchKlFZvyXO7xZqvOG9QdY=; b=
	Fw0yYq7kaJlRIszqtfEWY7o/WiNyMEBiPxjwd1sULdhWS4Rt94KPvmUjDytVsBBk
	lMeXrUesVGGorLJFyDyBvpknnwPcKsZ985dulOJ8yoUrz0bou2ZzHoszxJWq4phO
	OjdBizR8acYzZ4JsVB44PRf3Uyn1gbwXijA6dT7leraqUigVePlM2x+vfjI4SrVr
	XwZ/ihTJwROai0dHBfcbhteNRJLkZrgyV69PwHv+EU5xACQE8+KGQhATIs0J3tog
	pAYyzdJFvmiv/F4mZYamkAN9qQ3f3o6zROzvngULsUOamjyh8MtkObHxaEsaWvbe
	ldlAK/Amr/BT1+NIeXooJg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9ucthqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492H7mVA028453
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:34 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x889d45q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H4YuxvlXOYPiUrE6BcnKXfjN/eQQZ4A/oL5pNo7BiGDLPOIOyQvCrGgKOoB6aYSagtBaG0Wq8P0WFVgLzkPy9ZZWj02Er/abmUe7porZGGDqJ2XGeufmnjHQd4DbLw5EdVpWdFT0H4EVf7trYXNoEHI5/7A5MF9XXKykcUsFg1wPyzSH0KgtZUkxDsngZ4s+hCqFdAIvJz+VQ3Tn3D43xY9h3+Ed0weIWpS3EMtmhEsbL5jDl2dccqY/ik8rbeTHTB93l0LTpquAXZMqayX6rLq5gMua+cUy0ENKuBb6rcENER7oJIz3PhMasgizY4HF9PZ4rbPDLG81QSt4w24fFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+y2+BJE6vvwRyd3KeDqYlmchKlFZvyXO7xZqvOG9QdY=;
 b=pBaxG9s7+koG1juI5xLwtjZofbFDkDEfXcRBY98TG7w61EchLEXVvpzmhJeRRkBOsAuZUhlRKPtGgp4vuIOpEz1AD8EDmYOYMKHrztP5tSZ3Hnsh4IknOkvghNCVqdi9q6+QpR8sb+knBzvRPbGTPHkjqNVNnCZeaAmBqCh/qVn+xNCrhTW1OKiIAjjnp9FTxdPiOl0iW+hF+64xOWqpuYKqU6gyd0UtMvi73mDlhEc9H+XngveSQx0RsHIGvXYdhA9LoJZklq25izAbTJUWdnApgLaeLPJ6mj35Vlzr8KeqzZMcHAF93ymePnbiZUe4mfnkLSFhjeQdydytfg6Igg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+y2+BJE6vvwRyd3KeDqYlmchKlFZvyXO7xZqvOG9QdY=;
 b=pV1jn5gofHd76clay8/LZCkjttTOfaj7WxqlxEU1PiekFJiDIo6J9x9+o9ZSvsJ+p33u+Z+D0O8M0+GMEdQyL5XcG3JFyntXrxDtiRvyQcjeucr29fN9KS1E4zqzVMgmhUppLIqEV6iZhJSBmXy1IPkdGQ4LUvyPBwmoQCr5FTQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:32 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:32 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 11/21] xfs: use dontcache for grabbing inodes during scrub
Date: Wed,  2 Oct 2024 10:40:58 -0700
Message-Id: <20241002174108.64615-12-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 6784ab97-cb2f-413c-dbd6-08dce3097411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nkmfKmuHUE/hOoMchYIVYGY5UJuyekpDl4qu/Vr8WDJkxmxJfP4XIlJSQkX9?=
 =?us-ascii?Q?4ypYqS4CskGSMZEJ9fHk2cM2aJiIlQqTnTRLSgwd6g7HClnmYBYi7BYbiJxG?=
 =?us-ascii?Q?aJQOT02opFi/V984jMjm0wKuRB1fmPgySSJ1riVvC7nwlpRHo4HN/7O0mieR?=
 =?us-ascii?Q?tZCqliJZ68w3ZVp52AtYivp9x986xHIc/GCieBcyOrCfvrp0WxCQESjcW+q2?=
 =?us-ascii?Q?R5BVlztkcSU8tUKK34/MLBsWEKmxgnO2M8bHGHfCPLJowwf/Kc3h7/8VWSGb?=
 =?us-ascii?Q?uG5f4ZFLc9jZx3GnqWauWeXs0/7Glk3EKADK+gEnVCgGzGIXYhuvEFixUJ5T?=
 =?us-ascii?Q?/NYFutVzEK7zN3wnd44Ts2M6KWtmIT7UC//ZvSPKwgsm/HN29fDRKzbZDFmO?=
 =?us-ascii?Q?PJfn865gC0G3sVpkdtIWIXGIuDxskTHAFGzuCt+xEaw/8NxJM4OKGNEO+9Jy?=
 =?us-ascii?Q?cG05v9lNEShDjqFXn9MyqT1cMHu8SfMPNRUZA0M0lYs5Ky6ZzY9z2vjC4ZJA?=
 =?us-ascii?Q?LrfZHlRr6FivHziDHcQO1agovLHl8DEowXp1rBcmk1XrcsapogNG0CShwDMP?=
 =?us-ascii?Q?RMPMN+Bwe+olcyWvRrD3qU75eOCnle6FT4SkXc1HRepAJNT3IPF6rg3aEESI?=
 =?us-ascii?Q?9etfFZdltQQDkqya7zyJPU3pr15bTlXwh65OaL+rCuWrBHTZF4wP6JaEI6ep?=
 =?us-ascii?Q?Gpm5ekSrlM684nyBHIvTrW/dz1D6U+MkWiFBF+jH7gPHcXx7JiD7kpkhhOsi?=
 =?us-ascii?Q?o2O+lSknK0Madl2DFwdKYbbNqOvAFebuR7IT4RyLFLsCspzl2ulr/2PcW5rs?=
 =?us-ascii?Q?B6hIK+a+pDngEjHn4tvtsK2HnkxjHyhdxpax8Kn+6qsWVd7LXIjYC4rQBXlh?=
 =?us-ascii?Q?UnZ7XMU1xfk6qnRxDdkpfmrczGRbGTF4uNgGgSmYJM78QLx3nhJvMtVtnXLJ?=
 =?us-ascii?Q?i4LCKAxiHx+8wxicsDT1DZxIsuxyYw3Xut0DK20fWNm+Swmohkg4I24MEx0J?=
 =?us-ascii?Q?Xk+LPK4T7DlIVu1m/aTXswWfH4H2+3EjqKWjaoj0/WJIMCfqCOaNRHBDAz1p?=
 =?us-ascii?Q?c2sw7ebwdCn39bySHS4tFVVbvSP9dzTiZYstVxXIDYKJkW7FdE7X9Pz9Od30?=
 =?us-ascii?Q?m0g6MXyyjGBbUDJzQ/jWCbMeQcJLR8NV/COIhKFtWvQZl9xDW4u39m76SYxn?=
 =?us-ascii?Q?UnpmSrgtz5Fqvy9VHA0CaRr5XnCTsCt0nJFfZ8G2fKCDjRy+srzCrvLEOXVW?=
 =?us-ascii?Q?cFAaRBGzE/uGHDkqbNTr+gdSbeM1NvnNAZd8Af8Uqw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iJE8EMaXgXqG3Vy6OwUXwVehHbkFNkB1Gs+Z7fkad5T6BjmXk/tVp+2yz7nI?=
 =?us-ascii?Q?xC4t2c8eoR15EFocgIb+fzOq+otRXw8NEwBgGHeJ/3DQILOCGfAY5+P4Bi1y?=
 =?us-ascii?Q?Hf1RsVFVNITSpsghDyvTO8B7pWsxJVLA52MnmI5rdp7AyZx1L48+PS61J46l?=
 =?us-ascii?Q?Z0wxNcoRQiazKb2RokZ0KXTUR+gS7ZX2BbzTchGH9C/P0mr7vOQ3GEVihLz8?=
 =?us-ascii?Q?JgRgubEvGs8v1zHQTjHlcojnvkjtRRvnvdJZgY8UfloTjJkE+g8GS8PVtEPm?=
 =?us-ascii?Q?5EIHb0q+YokddrHOYRB/+XmP076m7JrMdw9Zlw6kGkWmiJ8dugL9e3bKV0ZP?=
 =?us-ascii?Q?wOKsrfYaXcTImr5XxJCPKdNaXESGfGWnp16VWjxCinmbyIZ/plIelWK3GVhH?=
 =?us-ascii?Q?NouWMo1KNwqshq3BWr8xtEE/Uvop/jkeAY1H5ynd37av+ux1JXTD8awAYad5?=
 =?us-ascii?Q?+7jVhi3808ySOb0f6CZifpMYpYBIU7fAihaZ/Vld5wklOuKTXq2h1Nmd4oko?=
 =?us-ascii?Q?HeIZnoPTPNLLkVyMjhbne/F9OZcuJdNQU6cWO5Co0eIeqdcAmcIxqESNRq92?=
 =?us-ascii?Q?VmkbvozPvBhctYQrc+lCAwltYZ1raOS44danZt+5rowGBhCSsrQX2r8jF7p8?=
 =?us-ascii?Q?zauGlYq7v1iwv6xD8AMKD8C52GLLVb0cshsrMwyBmB7Vkiz3NnfNPB8NADZq?=
 =?us-ascii?Q?b296kM+hOpsh0CELgZEWvFEnJPAk/bvdlYB60UUo8w5qgQQtji2B0uyoCtdz?=
 =?us-ascii?Q?lB9WsyY8a2y43bdjhO0thoMuoF3QQGE0wMK1gXpsq7Sl48RmWhCvGScXCMAQ?=
 =?us-ascii?Q?H9Qk3AYUZMI8dbijzx/JHlbyt/+tP/XlQWjQRW6WszT5KNt9c2LNh45hhK5a?=
 =?us-ascii?Q?86sTXofBtpiMUKLtP2ASEVovQxOWyT72aPBskPctYbKztWFSjxNmaN5woJfd?=
 =?us-ascii?Q?xTsKen5EOHav/b5IIM+yy8qEYlEQk5ocjBG7yZF7JnubbQ2BzXXNDAvc0mB3?=
 =?us-ascii?Q?U8T4ekokL9E5X62eHRE3Ks/+tgXSoDvOukJMlVOSK2TRJlBrwea5xBN8Jimu?=
 =?us-ascii?Q?UzhpKOohVm/qSHptWZmZVce+g8C8pnj9eZQsJ+8lTP5P6KYDNsEDM9ev1Kez?=
 =?us-ascii?Q?jqqqGZIkHP7kXtRbohdg3VGPUWJ+WLL0mCiflwql7rDRSm3W5DNejsmA/d0U?=
 =?us-ascii?Q?malCPIJrn+r8WX3fkgHPfVxzrwoC+bkU+UJUcu1iPEDsYF7HQsHHfF1EIpUf?=
 =?us-ascii?Q?UQ2pppeCirrlhjsKGjFjAmQyXgxnTfA7KO31gPbRkRPcEcGW9cfuc4TmxOpt?=
 =?us-ascii?Q?wIHcbJEF4GuDdv/f/q5hAJJyZN21OADZhtbUWeVQ8/6D88qorZOKFhzF2PlG?=
 =?us-ascii?Q?MZrD5bQ7FXV+d+ieLcVImJuA5teZCIbNLYIXtn+MBw/aLKWCnxWNjSJNHdHd?=
 =?us-ascii?Q?UZnz/QIKkA+rJREU7HwPtGj3NTxt75iYbsRds3XYgnKi2NQYPjDgYn1OHnYo?=
 =?us-ascii?Q?UBALDh854/lxIe8ANEg7TxvaE0gyVSHqsJk7CUih7i9MfmI7O3rq2K6wGk0V?=
 =?us-ascii?Q?qgIzL+MYaaeCKvlsUuCKaA+jaAJ/suZtmgxIj/8aJlCW4hys7DIKprpORziJ?=
 =?us-ascii?Q?7RpbbecabXop1/KdbCw8acD7MpPfsSaXPmZ4X9NWWuSAn/9SsecDNMtl7/GR?=
 =?us-ascii?Q?jT8WzQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sUHHC8gB2RaimlVByUq8/fHgReuq2QfAe3jEju/LL8mnVsLldIw7e0AQqyCXwfBA4JQDl8pAVSxkgRJufyGNHVMiOlwCchbHu34jdqFYiJUBy/yKKUAOSTplKKgWp8LqboVr6o9jQ4WcJzrwdsIUDTuCCqAm3AH+ytMOKTeX8DnMCcIS5QxwDILarRnRfTtBOQKqjSoIpP65NL7ns0saXaw0BE1bH405vSgNGm32mMDdBAwAgK/gLOrQzWLweohzoXLtloG48m4/p58s2l4/zA6njitPXyyMaZcVoKQ7yKIiTuRTLj7u0aEBFBf7G971kjz7B0EoaXM1AF21/+q2O6oCm8GO3obCQcaIPsIAvEAwq+ovAyj4CMO93+xTxrpCxUUq06QtkS4mEurBfJ1YFxGeIPtsVGJpslB0cjlD60B5RMJ9JV6HD3X4pLyxKURmMHlFfTX++57ujp2QGGvFMsSGoUdQathjvzyQdJCBmona2gkKWrdDeaM4CbykdjiXDZB764bssbTp3fL0BRkhnH8QQ1ld4sxuHnmLnyaIOMZuK6X38b0XJfqeevJoF2L6AkBqTtUM/35mYlQNEqxzlhp6iNTNuT8VI0AKDXoZc3w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6784ab97-cb2f-413c-dbd6-08dce3097411
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:32.2544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zn+P7o6zBQqArKFCzqOUORY8QKdmfnjncKRE2LhT9us3/kToy7tQ+vKIaCYCbCKXKItdrOd9zKmZ/710956E0k8rOPnabsNNHW+oYkYYtuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-GUID: _3pwPq13L34BYX4MUNjlQhVbpDsIvOot
X-Proofpoint-ORIG-GUID: _3pwPq13L34BYX4MUNjlQhVbpDsIvOot

From: "Darrick J. Wong" <djwong@kernel.org>

commit b27ce0da60a523fc32e3795f96b2de5490642235 upstream.

[backport: resolve conflict due to missing iscan.c]

Back when I wrote commit a03297a0ca9f2, I had thought that we'd be doing
users a favor by only marking inodes dontcache at the end of a scrub
operation, and only if there's only one reference to that inode.  This
was more or less true back when I_DONTCACHE was an XFS iflag and the
only thing it did was change the outcome of xfs_fs_drop_inode to 1.

Note: If there are dentries pointing to the inode when scrub finishes,
the inode will have positive i_count and stay around in cache until
dentry reclaim.

But now we have d_mark_dontcache, which cause the inode *and* the
dentries attached to it all to be marked I_DONTCACHE, which means that
we drop the dentries ASAP, which drops the inode ASAP.

This is bad if scrub found problems with the inode, because now they can
be scheduled for inactivation, which can cause inodegc to trip on it and
shut down the filesystem.

Even if the inode isn't bad, this is still suboptimal because phases 3-7
each initiate inode scans.  Dropping the inode immediately during phase
3 is silly because phase 5 will reload it and drop it immediately, etc.
It's fine to mark the inodes dontcache, but if there have been accesses
to the file that set up dentries, we should keep them.

I validated this by setting up ftrace to capture xfs_iget_recycle*
tracepoints and ran xfs/285 for 30 seconds.  With current djwong-wtf I
saw ~30,000 recycle events.  I then dropped the d_mark_dontcache calls
and set XFS_IGET_DONTCACHE, and the recycle events dropped to ~5,000 per
30 seconds.

Therefore, grab the inode with XFS_IGET_DONTCACHE, which only has the
effect of setting I_DONTCACHE for cache misses.  Remove the
d_mark_dontcache call that can happen in xchk_irele.

Fixes: a03297a0ca9f2 ("xfs: manage inode DONTCACHE status at irele time")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/common.c | 12 +++---------
 fs/xfs/scrub/scrub.h  |  7 +++++++
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 08e292485268..f10cd4fb0abd 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -735,7 +735,7 @@ xchk_iget(
 {
 	ASSERT(sc->tp != NULL);
 
-	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
+	return xfs_iget(sc->mp, sc->tp, inum, XCHK_IGET_FLAGS, 0, ipp);
 }
 
 /*
@@ -786,8 +786,8 @@ xchk_iget_agi(
 	if (error)
 		return error;
 
-	error = xfs_iget(mp, tp, inum,
-			XFS_IGET_NORETRY | XFS_IGET_UNTRUSTED, 0, ipp);
+	error = xfs_iget(mp, tp, inum, XFS_IGET_NORETRY | XCHK_IGET_FLAGS, 0,
+			ipp);
 	if (error == -EAGAIN) {
 		/*
 		 * The inode may be in core but temporarily unavailable and may
@@ -994,12 +994,6 @@ xchk_irele(
 		spin_lock(&VFS_I(ip)->i_lock);
 		VFS_I(ip)->i_state &= ~I_DONTCACHE;
 		spin_unlock(&VFS_I(ip)->i_lock);
-	} else if (atomic_read(&VFS_I(ip)->i_count) == 1) {
-		/*
-		 * If this is the last reference to the inode and the caller
-		 * permits it, set DONTCACHE to avoid thrashing.
-		 */
-		d_mark_dontcache(VFS_I(ip));
 	}
 
 	xfs_irele(ip);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1ef9c6b4842a..869a10fe9d7d 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -17,6 +17,13 @@ struct xfs_scrub;
 #define XCHK_GFP_FLAGS	((__force gfp_t)(GFP_KERNEL | __GFP_NOWARN | \
 					 __GFP_RETRY_MAYFAIL))
 
+/*
+ * For opening files by handle for fsck operations, we don't trust the inumber
+ * or the allocation state; therefore, perform an untrusted lookup.  We don't
+ * want these inodes to pollute the cache, so mark them for immediate removal.
+ */
+#define XCHK_IGET_FLAGS	(XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE)
+
 /* Type info and names for the scrub types. */
 enum xchk_type {
 	ST_NONE = 1,	/* disabled */
-- 
2.39.3

