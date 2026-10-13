Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9977B3B6BEE;
	Tue, 13 Oct 2026 08:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879329; cv=fail; b=FIFOYju27D5kFlxNxlum0zeuW3IsuZvDUp1ZZv5yz4bI8tOhvXHoyUE+4sX7+M0OVQ5y/1q4fRcjjCXfnopj9i1EgAlebM0xH6LPTlQPOk9TDi2dwZIayn/cwhlLXzR/J5LcT5sc+crV9vgP4X/4ZCWrcC72BlISWiSmvxdmBsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879329; c=relaxed/simple;
	bh=z8aHxSDwEttOXWdAdjD3gOnEhrAj36zTNfGkn60B3qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NMkrVrEd2AKgKJFLhVamToCCZkK4AtLwIfkyeJbH25NJ6Dn+xNSmjehu7zUdE08VluwQnAIuIz/HcnzanEjrdJnF3MYGo7tm2f4tZKqP4FrsJBVXDPWORkBxQIhUh3RD8x+gH6TaiqAlNYhk/ieUbiMnSnAWwBTgz+6HwPg5Ykg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lApLmy53; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MyovARn7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lApLmy53";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MyovARn7"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BplZ3197994;
	Tue, 13 Oct 2026 08:15:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=A8jiv1xOvTlKjZs3CWsewBp8jIWBfcptJshjU8eO40I=; b=
	lApLmy531ffjKg6NJQKjArrioXVkULzrWwFtqKsZwTH0twZY5m3VOMynNAS5lxQe
	VUMJnCMbtgpSmI7AN8EIyPRcopJxXPc0ggMZYZZHY+szexx09nEuuh9OHAHfDsdW
	BSOQttwFUz79Bo24J+HnabuqtZR9HIAT0vAhGb7lBMtuyNdWYTTslHjUpgrAfCAj
	z0RV+5ieFkPG1JkARFXgasTOg052RWT1KBgh3FQHsL38Y4Ff3KfU8fay6mQ6AR63
	4DZNb9OHyRXZWUjzTpDizO1wpszCfWu1PeKqJXBh8Fo31vpVEWxohUkQi9Obb1/6
	QlJdL/aQeUhAoI+aSC4HRw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dcsbkx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86QAU002088;
	Tue, 13 Oct 2026 08:15:24 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012046.outbound.protection.outlook.com [40.93.195.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt8yr7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cKaRVXJ0gucZYLUZUBeNl2rU8s2ypGWE/zo8YxuGxn69g9TIGIY9vJi+2bS4yynRM1LkI57BP2IvCkdiLx9e1moRFtTTj+jaQchumyhh4q19EAzImVp8tkq5O3r3HCr3f+uibaZa5q9oA05uVtxNUa6dVF11LdS1vVNJ2cxc7QoVJpTFPF2kGGt2bhw/Bv4ynQownwAvLUwKa3dbChLroMO4SY0I/r8SaynCwiMoAoLnOKq4We5NjANIbWZ2le0eVqdJUII8AmRMoN2dOL533ix/0UB60WLjljRQn7uXoMdahxzwJdFui7LxAlYStE8+xvyJBN+iAD3U0kYOonWu2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8jiv1xOvTlKjZs3CWsewBp8jIWBfcptJshjU8eO40I=;
 b=Hm2OE4NH12enMkrOVEkfU8C6ge5oEej/nxARQDA0GJCE9sOFIxTWqJroRRF0G7fIjTDSGdzxUPu8e4+A2tVgE4Gz+rvHRNJq9B87zl/kYFPQssdIKPfUAD/x4RwRnODWTXqnMvo2OxuvooNxT7BQPMJNcxo+3w+kgdGgJYrT4JBLu8RSB4rWxjudqtukBxU3rdM3wT8n9CrNfnggHlMGBaA7mIHI4sz6r9aPfU/YfRpaQ7RsycckCIDcEPj0l/rvtJsKOXhAn9nz1fXTpPEHadTpAil400kvKEQrQ7J2cAqaeT/LFgkm1n4CTkbmBaWqE+0SWf8sEfuv77zKlI/xlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8jiv1xOvTlKjZs3CWsewBp8jIWBfcptJshjU8eO40I=;
 b=MyovARn7btALmtkWHJO+Bgzz3aBA+Nd0pG0eBi6E4qA6yu2uYEVod9Da40ELBIFEtHl8Gc1lZTKnZlQjLh5eWlCzWGV9QhRrexdsXwUqe+r/KZs2Zey4hySJr/cWuL513JTb1Ss63dXH4RQu7l/9clbAB63YbkRqW+anc/I6Ng4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:21 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:21 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 03/19] xfs: hoist recovered rmap intent checks out of xfs_rui_item_recover
Date: Tue, 13 Oct 2026 13:44:47 +0530
Message-ID: <d2ff467512de99344122cdac20d4f2732e67daf6.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0193.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::18) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 324e3124-293e-45b5-50d1-08df29022007
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3qmgJvIh9MoAoxaWUQc4K/xjhnLjpqpHtWNV6yQ1h8cGjPK0pYCsatJ3kD7keVS87PkUYkPm1KxImxgeBVTvwo6RzKwSRO3bZ+wW7inAXiKNsQ9Cu7q+Cl8YzaxECt0hEjiqC+nnf6WxzumG8IA5T0gIgDbD7Pzye6eJb/nHwj3WkmnVZXAMitmRs0yTR1VTYKK7r8Sr9chEYLbPUZwLgCoUATiT71XwyX02VjRM7QV3hjNyu8nE05lzqh2JWYuBkdq7mxj0yguttMGP4vFMOA7dJoId1i+9yb3wIYBdk3EFXv1CCvxwviTYjcLNGhiDRpmBE6VoQA4CKk0/wbBCF4IQpAif79vTf0V2Hjf8zclr5IwrJ6YZc8LyqfS9wvXgiJ2+2AHpJ93b0G6GZQzCG4sAmzTx4RtFYJxxWUYlXx447L7PUvHLoZ8DRz0BWcau5V5ZdUlX1Plw0rubr+X9QU0NV4WHpJw5rI8zEpgenM9h/N312/+AkmCO/cOp/eYz3dOM4MxHCXw4PtbW/Z9YREWEuomiXvEyQo6UhvjU0Mzft/ahgwxokc/7i7qryOlmfgCSiZABzvdNUnfpUIqMpW5boZ6jITsXWS6ABwiFjJdbVgi0mdi1K8nnWA5bqIC6LmxsZnRqNYOpHgde9uWeJqvmTS839ck588bGrHqEPO0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EGJuXexE3tkvVzt4H4GEY2tGQTYE7ZdEJlBTDOjJqBjzM6XLAMocriLOT1iO?=
 =?us-ascii?Q?Ht4EZwMyj5mn3S0xogS/ZnpTLXp1KuRkW9EUDIAMQzsdYwe1Wuz8QmMlkgqj?=
 =?us-ascii?Q?7YKlQnjn3XLq8eidoMqxZXeFzNAuNYsU5pS/NfnM3weR0v95LdzF8Y/m9Pln?=
 =?us-ascii?Q?WACNgtgguIWfiqovw+/ueQbJDvdcb8qzW8hEdNyFv/4nq34eRRPT0ZvfhcrL?=
 =?us-ascii?Q?voGIcj32Z4Or9zfbBr9LL2hwLbhxwtBMcbCp8H0B42PvdIkcwaYXH/O/6ChU?=
 =?us-ascii?Q?0Y8dLszX55CHKj3LE2pZm2uSLsruXF2w4xnh+MR5GxdfyQ6gma586I5+xDdX?=
 =?us-ascii?Q?yIg1WMftnCmZnd3lx08B/7N34MiR7mbLWoGqdQKr3DRVF8cqg8xbQhZNrqVn?=
 =?us-ascii?Q?GQFPK6XhwQgsdglLFjbNL/Pq9YU4BR/eVDU+io8QLAlViKXV5vhEPVntHO3E?=
 =?us-ascii?Q?LyxPx/jhP1yHjwOYivPKur6DKNv0B3BsUcFjF8LWR/Cftaf3uE6gzw7WYiPj?=
 =?us-ascii?Q?Zt1cUeSvY9fzlMMLLoBUWleaylLKao+AXYYre41yAy3GOjzzCFiae4fA7rRm?=
 =?us-ascii?Q?Pacj1JMhQgY5ZBgmxdr4fExRIeTkPwerzoY8ufXzMllBvCh2VKQC5oUMDbHK?=
 =?us-ascii?Q?xREIs7jtfGY7Hhm5O4QBOp2XhXr66Y73E5WVcZswLNxCwo/JjvQXz0HOxqr2?=
 =?us-ascii?Q?PpozFa3UFxlKBAIgdEsethAl5JNuWeTRvRHOHD23eczIfoTIgLQAN7k+eraR?=
 =?us-ascii?Q?WHDxFsRvmyw+Gq5N6Ld+TxO7i276bq/nlYDzF3WL1eaK0dzUqjY5W+2UBJAd?=
 =?us-ascii?Q?7L8m7h601uckL028mfB/PImTujJVV7+oVyZyasPTQIKuWR3TWP043j33EBfF?=
 =?us-ascii?Q?qPTTiiJuX8vZPi4ofobvUfjSrLWNvdHUb0QY6jIpKDhN19JzlsGt5XstUDQC?=
 =?us-ascii?Q?bq2WMFTC3lFjPaBAfsk8T3dSomYAC32SWQVSgSuU4V2QrXQxXmfG5IPrGFqt?=
 =?us-ascii?Q?GhR+Brq/c63knTp8IzGzuzZAQPZ32YBBfFRAuRDs48C4roj66dQd9Aq9fwU8?=
 =?us-ascii?Q?IxpCDaXJaUqT+gFWWJJKttbNuTP0/c8LJeyHfIMUT677pXaUio/q5qGTZu9i?=
 =?us-ascii?Q?ggLv2R+Oe3T95gv6F9t10uPIdcXlNRGuNYiVbWGiAs5oyi2Kdi+IYxf7Ch8B?=
 =?us-ascii?Q?EZPZwGzH9axSx4rWhJUHxucWteTO3LTOdF8h1G7DsI19VmR5JrEGYM3BmBVO?=
 =?us-ascii?Q?H5+f9GyJ/luycaOcbvlWLUqXP1TIl++uGNqRBG82XSe0iM01FkoCcmDNoJaI?=
 =?us-ascii?Q?s2R+JRJ9QBJQ9AgGX+tkJvwPc3Lq26sd4dxZoEDxsUU/O68bFxASPMtfMLCS?=
 =?us-ascii?Q?uGJ0agpggaAhGN8P3srW+tmofLZKOT7KvF0Ma8QfLSnEk/a9ZGruJuzzRLB3?=
 =?us-ascii?Q?Hu50YJUT6pWZSNlsD411hh0pGy3PteCCFkCfuCTl2lzsDznY1Bxt/kHQJ1w2?=
 =?us-ascii?Q?Gwe1UG9ypxzUHf7baDZiVRq5PBG/a0ve8wo5ZbskjyM2sM9mRUJuumPIF3gu?=
 =?us-ascii?Q?ITFPh2AAZLV0wipIxWqz5M0Btp6P/9iWwvX/JGctxfWe3Hl6obIU8hykD6+D?=
 =?us-ascii?Q?ho4B7JZOtyYAYNj8Op2mrjrCw2fkNZBPhMtEURXFgQH7jmyn8wM/EAG0+phG?=
 =?us-ascii?Q?rMSAsRvN4zOHJIWk/lCE/fMAcxLxz4XjaxIXx5cXEz5R76A8/Jgv4UBV2ln7?=
 =?us-ascii?Q?IiMGfNwRFTVF0WKGE5gx+8hJXZTnjoEoHt0DC4Gkdd08S56wTtQRbjdseIwx?=
X-MS-Exchange-AntiSpam-MessageData-1: 8dy3cIZXTZ9f5rVJLDRc6ZzqGyukuGiW1eY=
X-Exchange-RoutingPolicyChecked:
	a3lgFz+nOAi4gpmwivn07Mw6gFr//U0PlC9FiDNm2Tp4/phJnAUvXKefyVZ9/n8NFNlJWQHGNzbrwFzeIR09+FZOS34iLz7iFZ8O8Gfl9SwbI1FQ6rNQG+vsoxmZJ5JNRGAgfGhQ+iDChp6LF83Li6sG1FXky15HmiFt3G4JKVRVfh5w6/UTCKq5+7m9EdBzdSUrq6BDH07esk21sp03Fa+vesAARaQNuCzyU6ikRDeLwmklOcbaCnmEvWpSgtGwiR5t6kxD9yf69wt2T5MRdZZZoXPDQ9yyNZxsnbDUJ4hlE0qMrWuM0FcR4bfp/OvR94KNc4dB5IhPM3NKSz3CJg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+kDKpf5FARCvMSjpvCkMfflv6HWlNK5FJ+Cow7QGJj96Cwgyz4TJtVHmCdSOUoz74rOnL5qY3udWGKt5oK3ENLPwJ6FcfA9vLO5copFhTzaSuhb0XYh3KPg80cq3w9T+XCH4LBaTM8qpStHZBWHIoPrIELZuOlQO6RWGKdhCOGvSF3eSAzu0YpMRPdeSIBQHYiHFHEbK+1IrGJK26DJxagNUnB+BiY7OTD7cL0WCTLV+qwMuJSNmxXPbj0Pt9WzGlkwB5HUmhdR0gyzt4IpUom8urD2D7RX5a09RWfgIBgTUufdjvh8Uh14ZE281bCyOH8k8pIK3jApPg6B9CfPCr6rM7S57HcSMQtFNvAOtD5y/vkzWpaM+XS+9eAma7B1LInfRZtQVl1OQwhU8qSTTp2ctv8eZkpHYhnRAEfQhvLF+dwkVTeEsLMR0l4RJBBbGWfIlYQwy0O++ZFiN1q7PhbU7KdYpweg/HjweT6H46huAQ7osic2ydrJKHyrzjSa00I5K8o3VvSeMh5KZFm4zywp1kqIOZScawdSPT8hSYIfO3jxomZ2Lb/ZbDyn//CUeeRg3JeMgqmlfV3QHoPD6Hb8GWgeC7w9p7QYwJbjj7y8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 324e3124-293e-45b5-50d1-08df29022007
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:21.5338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmqkyGTeBGfODi/ITz2xsV88ybZ9biLu9F4wFa7AgolFGFm8BUBLFRN9EcnOiGvCafnrLZ40KHXS6Xw4AN8QAZX8/Jaf3GAK7vz57dYAxak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXwqREgdxIhR7J
 XPisiC/zra71PUsOTLkwkOhLJWI2QG7BgmNHs+2YedUGAG6nIF7OFksQJkx7h0Qc3fi+uBWjzEB
 96U5nqaP3h3I+GijZwAkpDp/hFcBoWB3Vc4KhyOc/b0HJIm4d/oP
X-Proofpoint-GUID: -IA5Bw0g9Dj8Yft9SyTfeJBWWqSmOG3Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX71ENFsH3SoVX
 PejUfjpymgR7I8QlLmRpNpUmgcWt6btokhmp1SKG/hAeVnkz/8MwPZHz+aWQkKCkjHaJIRoayG9
 hHWqCP3MTDeOUM7V7VwQn1IG1ny3ZBXSkaLVDg4gEIecOFsv9Y2YPEV5pHaAE/EGlK2eR7QyGs3
 khrzSgrYTH8fMQsYrXrSBNGoZ8sjJh2eP1Qmj/KnOakbTsHmw07VjtMbLhpfoDlcEtDl1tUkDQy
 awldn88WiYqEYPf9rBXZvZZ6KMWBCXA9fTXyzI9MBd9nE8sxC0AZKbUEs8EDuSX0oauhSCSv7pU
 ZtRrfKKimIGE4qzIhzigYnJ5nHR8EuaoQzE52QPLH1FuOMB7hv9TF4206iiuaBhAheuHkxeDoUg
 3Cz4lmA+IRflMdDsEyuVwk6N8COmlj1aJW8Kz20R2e/uB7CFbMcNVq9TW1zR4WYq86wdZEWVZc4
 sY2dlMRFosdO+yeeR9g==
X-Proofpoint-ORIG-GUID: -IA5Bw0g9Dj8Yft9SyTfeJBWWqSmOG3Y
X-Authority-Analysis: v=2.4 cv=EdZd0/mC c=1 sm=1 tr=0 ts=6acde89d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=XUHDQfcMxKEf4e_NL1gA:9

From: "Darrick J. Wong" <darrick.wong@oracle.com>

When we recover a rmap intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit dda7ba65bf03b6f3a7502b9f85c2524a5ae5aa2e)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_rmap_item.c | 67 ++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 20905953fe76..31cfd734962f 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -460,6 +460,42 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.cancel_item	= xfs_rmap_update_cancel_item,
 };
 
+/* Is this recovered RUI ok? */
+static inline bool
+xfs_rui_validate_map(
+	struct xfs_mount		*mp,
+	struct xfs_map_extent		*rmap)
+{
+	xfs_fsblock_t			startblock_fsb;
+	bool				op_ok;
+
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
+	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
+	case XFS_RMAP_EXTENT_MAP:
+	case XFS_RMAP_EXTENT_MAP_SHARED:
+	case XFS_RMAP_EXTENT_UNMAP:
+	case XFS_RMAP_EXTENT_UNMAP_SHARED:
+	case XFS_RMAP_EXTENT_CONVERT:
+	case XFS_RMAP_EXTENT_CONVERT_SHARED:
+	case XFS_RMAP_EXTENT_ALLOC:
+	case XFS_RMAP_EXTENT_FREE:
+		op_ok = true;
+		break;
+	default:
+		op_ok = false;
+		break;
+	}
+	if (!op_ok || startblock_fsb == 0 ||
+	    rmap->me_len == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    rmap->me_len >= mp->m_sb.sb_agblocks ||
+	    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process an rmap update intent item that was recovered from the log.
  * We need to update the rmapbt.
@@ -475,10 +511,8 @@ xfs_rui_item_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	struct xfs_mount		*mp = lip->li_mountp;
-	xfs_fsblock_t			startblock_fsb;
 	enum xfs_rmap_intent_type	type;
 	xfs_exntst_t			state;
-	bool				op_ok;
 	int				i;
 	int				whichfork;
 	int				error = 0;
@@ -489,30 +523,13 @@ xfs_rui_item_recover(
 	 * just toss the RUI.
 	 */
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
-		rmap = &ruip->rui_format.rui_extents[i];
-		startblock_fsb = XFS_BB_TO_FSB(mp,
-				   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
-		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
-		case XFS_RMAP_EXTENT_MAP:
-		case XFS_RMAP_EXTENT_MAP_SHARED:
-		case XFS_RMAP_EXTENT_UNMAP:
-		case XFS_RMAP_EXTENT_UNMAP_SHARED:
-		case XFS_RMAP_EXTENT_CONVERT:
-		case XFS_RMAP_EXTENT_CONVERT_SHARED:
-		case XFS_RMAP_EXTENT_ALLOC:
-		case XFS_RMAP_EXTENT_FREE:
-			op_ok = true;
-			break;
-		default:
-			op_ok = false;
-			break;
-		}
-		if (!op_ok || startblock_fsb == 0 ||
-		    rmap->me_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
-		    rmap->me_len >= mp->m_sb.sb_agblocks ||
-		    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+		if (!xfs_rui_validate_map(mp,
+					&ruip->rui_format.rui_extents[i])) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&ruip->rui_format,
+					sizeof(ruip->rui_format));
 			return -EFSCORRUPTED;
+		}
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-- 
2.53.0

