Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B1647F3B8;
	Tue, 13 Oct 2026 09:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884422; cv=fail; b=S9evMf2D+D2Ampuygg9Zh1d0U4IyLCs8tGfTl0cwq+e15dABhvVF9+8kzL6LPUnYlEaPXpnVYuNZOkvDgv4oZzxqIEsK4v8zwWUdX3LKLDHgga9GVjPuCFV88AOZPf01osEUwJ+PQKtZwaf3MxUSu8VDbSbCv8zeg2oM0IVMYb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884422; c=relaxed/simple;
	bh=GfkLJvfi+TKr/BxVPd0m413Btu4HSQO1BLpkeuBr2kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sEOPYrOQR1hcfoGECLGJ4fq7RBCwUtVAUY5UHHKyuLjpUzX8Yfc1GLUToeYLlM0VMEjBiOPJbCr3VY+Z836V+7Xf3bdtE5ym5fYB+smIARtYvqgFmW7VY0PLp3gh/LJ7f7U7AkokXSzh3qEeBGizVXpYfrewJbQqRspUoKiQmd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aWLXrj/u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P9cnr4wk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aWLXrj/u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P9cnr4wk"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CQrQ3031808;
	Tue, 13 Oct 2026 09:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aF9MFOI+diNExF1Xy4CKPzklCCLFnhJLtJtZ2EXKSOI=; b=
	aWLXrj/u5qk55V1ZSE8noYJpSakVxxC3cGLrWxSd5s1DeVFq/MHQDU1ia2M9b71J
	7ddxYSGaEcXjj7C2A+R9UX04akA9/cmsX1k5vR1E6CLHfBDKrEFKSt4NJ1wUAb2H
	NHkWRa+mH/FIx/1VoVQbo/LhDCGCL0Cv9X2NhHkUy9/8MZruIMvaRhiOYS6JoD2W
	lz0ENF6S9vi/pjXlWn7Qi4iJ/SIpi4/KgtTDR0Nd3BpIVJP31l4smxuYctzQmOwd
	32lDC+bvP8sy3hS3qYl3Bp/yVK8JClLj7EW3+Y8w2ZnGwo6q8CFTgefyp5u0tuss
	pLwRMhjXQNknkiNkp1nDvg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbpc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTQA010872;
	Tue, 13 Oct 2026 09:40:17 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012000.outbound.protection.outlook.com [52.101.53.0])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d5y3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p1ov6zNQ4mShiIrzJsP2fHOWFT9Xi0XsS9sKAjPQFCzAs9cwVO7NMYqEFTDYiDL3g1DNOL2e0nBmw8HCrQnfYWfXSvErgTGr1HDMvy0/e0LG7ihEsSyQskYVYakJ/drf4ungM8dnS8uVR94BzkXAaj46wifEd1KhNNxoTYNqk85Puk4ugnfQUC2tgje/DIMg/OdXPXKuWH/uaF3nxAzL5ZyZW8GNi7cF9ZOFmP3FJ1trWp8veRbGk0i2pqvTmFnfAW1wmfszygZSgXckpqepxRJcDoKUDLeIJFY8y5pWDpR9hz1R+F6gl7YnpUPo2MBJMU8T/6pP5TU7vvtVnL3g9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aF9MFOI+diNExF1Xy4CKPzklCCLFnhJLtJtZ2EXKSOI=;
 b=nYWS2n0ocnicFmVcI8bnPq1HllkvRWSmLQSu1rqdTWKKuDPDQk5gZJ21MTm0ZQBEM3XBP7Je1aPZs2cowB5sVPVwHEDtjJ4hHy9XomHLVQepyEZBGTKKsETlTE+tIDiEif+a6uSe5cqYX8UvCpNx7XjiS6fajHzD+1ml0uWRtFCiDRvj/55hhrQWZo/qfGDnqNE+wdGNLgbX0HWybghr/vH/Ob8poYmC7aucU6+qKSyil+Uk6ZOpNY7EGwfO/fS+5ukdkycX3r9+n0Ba3sEExzT9AeCJtsofS9b1oStf7lMcxnhVsaJLLVtHUK1fUC1UWce+h2VkHxSpkePbesfrbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aF9MFOI+diNExF1Xy4CKPzklCCLFnhJLtJtZ2EXKSOI=;
 b=P9cnr4wkH7/V7X7BrMPfJtE2fI0dEDMJs19pPJ9+wimT4xeFqyQJEgKk3ZrFAWTrSExuz28fhs9xNMs9nnsMYV1RtWThhTSBnUQahH9AWvZZBbuOYVimeHg3mEuMUkMlb3qcnkNOD4ojhQeVLfK7WI2V+Mbi12GQkCtapDGsNMg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 SJ0PR10MB4542.namprd10.prod.outlook.com (2603:10b6:a03:2da::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 09:40:14 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:40:13 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 04/19] xfs: improve the code that checks recovered rmap intent items
Date: Tue, 13 Oct 2026 15:09:33 +0530
Message-ID: <0d89d11eb45b336bdb681994090a27e79a61633e.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN2PR01CA0208.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::16) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|SJ0PR10MB4542:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b12b316-8bdd-4e13-8440-08df290dfb11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10070799003|18002099003|10067099003|22082099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	RdgXsk/vRy2fsgbkwjad8g4XUU41zSCGxq6HmnekXj5srtCvGErtKd1ilm/MYpu10njJQKsTbKUCBO8fBpRCkqnJcxxzMp9VaAUHlWUikcbTs1TacBg0uMsLtSPoYdH+QAwrwYDY1eMe9luDwlFS7GfV3vGjTy0ngWUqqbtdh4RJgVkvh+MNSi1j3sJarhtB9WQot1TgxFx5Qqs5rhzZ0qsQGXrYIJOD9MpIwhPLBPSp7LRYwNuFBelhUHBwqV3ew4hxc4akcXp31hxqdApTDYXxuTaaNc9tfnOQf99Dy84xNDyA3uCAmzZ3zDV1UyPqBHHjW4g+wbqSlW+VkpPla23X26xg2I2RFyjVlOhMoSxKmZdh8kvZ75gWmwWMXQIpx/UDwfV2mcXweXlEKpjNnkrrqv+W5Hl9C4+99RLA7iX3AGwAr5WDxNKwEdpVzjHsQhPhpn7ypnG6IfHx1+p1uF3Z+s1P0tR7nKc2yEzcR3cS2eWkK+/Xr0ci71w06sQDctCBFKACkDBUW++IrjBGXTB3K1mvvq2Z5ZSyBggxv90hlJalTNUmOOVsFVQNd5ptFzqn2JVsjUfn0Eh4NktNKnGJB2woRReJrazgVQhfylW4Su389Z8TeIiyDub67DTN/eXCbkHoQkM5vudld671cRfBqTOQEJsaaPV7nfq3eqU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10070799003)(18002099003)(10067099003)(22082099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+sMDrhjwuB5nJxZe+AUHxOy1Fqvd8NHKESuamtOuWHs27zfN9YTwOTmCxIBv?=
 =?us-ascii?Q?9MlN10qIhGY/rTjp0wcfrKCkplqw06Dat8fF8pCHfPqY3Nu9riXCl435CjwM?=
 =?us-ascii?Q?bwOyrXN3bEFyGMIpsAQOk7kR4TsunLSMlwRCho56Uvgcjy13B0xLurgyRIdc?=
 =?us-ascii?Q?iI4cbDyPhPMn10CEqz+hoO2ecd2bK1xJsoWTK6VWoE7F/g7MfUi0Rzsq0O2g?=
 =?us-ascii?Q?MGwsmpoV/S1FgMaYLdSx0rrHgRQjs5YtN5AtyH6amrXoN0dPwYhf0d6nK4UM?=
 =?us-ascii?Q?3J34a8KYbfjOvW5VeSdVhE5UHAFuFG9rHhOXzBzbYl2q05MIuii6IYHSr0yc?=
 =?us-ascii?Q?YdDYushgot6XWCbgS8ut/RIbgzLeKxWYwL8YRJC+R/Q3E6Tok27wVmhDFfKT?=
 =?us-ascii?Q?HqZqJHXRJy3B3OHyzQHvsqaIP3fVy+YEe2p2mxdv50fTQio+7xa8UZjKTX54?=
 =?us-ascii?Q?LAtdUbfy/raS5Zty+46aguhKtUAHFAL8AHVwa4V4Vcy8MMC+k3S9WVUGEciR?=
 =?us-ascii?Q?DM1mGsjokOpOF5baqB2zaYBS29OO9ueoayL0LoNqSA8J7Kx/ZdWgtWX8CMKP?=
 =?us-ascii?Q?jJ3XZqPlnK97flglxziBdpEUFVt14iDnHGIk/MbMgyamf/3GWC7og3C+5BNE?=
 =?us-ascii?Q?KV5EW94Pf175YmHlEyQXjrlDM6eudC+kvmOY6QbBKmmBhVrJcNEE3u+TRskJ?=
 =?us-ascii?Q?Lupg2njgzeYv9nbvG/6XBDpNCKT6dXS9sFhgflItj919XW7STp+ptc+iHqAT?=
 =?us-ascii?Q?9I4ECjB5Aal4hv9HyixqDDo++VlPR1xhMMfSYpRJkcL0dMZGqRryyca8N1jM?=
 =?us-ascii?Q?FMK7fE8hoZymTIw61DqcoAGR5rIesWW75kLsKKO1G4Ej7GIxEEC+G7K40QsN?=
 =?us-ascii?Q?65v69g1XpCcb9LYVeszpHfYg5dz+1soZCHXPPznkdYJUGDjQmsQjIGI/dcqe?=
 =?us-ascii?Q?q5eijcX8ICT/Xp29yxdGaRWuTQP7wH6oYkO3yIHLb7woCMWp/wLs3hPhziix?=
 =?us-ascii?Q?I0+hOfR2dspGT4khf6kChgNLmYnNHj/V4OokXA2dU9tuq+W1p3dfWsx1EM24?=
 =?us-ascii?Q?MBu64yFk25QsXlM2JKR5c3UWr9tjyBfzGNi8Wd0bfGc0ZvcyEWtsfXGIO9No?=
 =?us-ascii?Q?H3Qh5VFHFmNDxBtfOs9oNQIKZThOROfqohcgH4O+vnySGym46sN1zl+yIJ21?=
 =?us-ascii?Q?HV2JiuzBvnwtuRDHN5lTCu3Gm2xZxMIkN07zUk9DEK86RE/Ir/43I95Zagnb?=
 =?us-ascii?Q?HXTIdDwSZJ039PpupbJPnrZmIwFnj1+oAE0oybFoeXdHBGiBUTLqbOns9Vp7?=
 =?us-ascii?Q?NlyUJSCFK1ICKN6gQmLM3g1oDiHnzIA+HnT1oK+82nDFgLjEHO1mcngh/fx4?=
 =?us-ascii?Q?AZOpnSFB0/zE4HUcogTlzcTysIZxizAqn+qwid9v35rVGsLUURfNWoG5yIPQ?=
 =?us-ascii?Q?uAY68E3NnrehNt5gbTqfh/GbEfQ3QBkSOZuuMb6hUvdbUx9pAt4Z+7GUVaMX?=
 =?us-ascii?Q?KetWYT60t9PGUHEfprUK9udDAExdmYdHChG4tny5gtICBbfUKx+Cassh/mSE?=
 =?us-ascii?Q?AxD8NINrNejoBYJ6F8rUbtCok6U0+6eSobR6rgSa/3+ZNwIavCSQhf3REsVG?=
 =?us-ascii?Q?45WoKKdi3QX2w+IsQrnfnUWY15NjWfL05K7K2VyxQz0XQf7lzsrA4H45z64B?=
 =?us-ascii?Q?dja1T1yFbd7ZTdb210qmohU7SqxTFSD9UsWZpOGADPaBu/iwweRFW1diOE+T?=
 =?us-ascii?Q?nUifShxVVXVV1HiBN9UZvjchWzhJK2GBpXdgampURy9zsFW+emNFefDT+PEg?=
X-MS-Exchange-AntiSpam-MessageData-1: duSq6vJ4UokOICtBk+YM4aHD4rxGBens58g=
X-Exchange-RoutingPolicyChecked:
	uSuGgWsadV+feTFJmkIXQATjVAww8WQQdMLwL8WCfRa6PgB/IQvIKgQEe9B9ZUUCzq1ur/yiNqNZJzpa4iyT67RjIxSUbuRjfdt6iespbMVkRzOoVGqbZlIWnrXZkKC9t0/I2fj+I6FMMs1LRngOYh739gn/Q2UGxc+fAjaA+2QEp17tBEZ29r1VY7uURoLnGlbdc1uIgaxFRNgxlxdXcMg4RHdj1c0gROqvqP0Zf+wNA/UvbXm0X2kKIkzo8sfuyw5qVrbxp+iyTcLNZFtwRkmA/h68axXhGSCYucpJkJTy0kVGbQ2pDil7hPtK1M/JqAsrWihSvgDNiN5gkueA0Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	99piXelw1VcrNPGGDiYLzNpa4B7T6APzvBI66r/DAYYO75AU0ebNM9GIa77aQ57CxyESXHEe26tfHQc2Shh3XnrQUbMgny3veZIfGii2Bdh7fnBjuWxTUoeU0kpSJVFQ8IqW8cHRdKLt0m642jdU9SmQ76UHH5zZEMXzzbVBDdGesog3stQSBx7LMKAAtvveziUhNx0681BhhscraZujblc7RbKGRGvHEg581s09YH/qB3Qoq6AgLl+dB0YrnxK7ytL7k5c79NjRS0KRl8GCFCy/+bsCAormJNz83RHHxPTsFeJfXuMRZ/MlbclQxJTXK36RH7qEJujtNt3C+YHXgk8bTrTuuqFqcD0ln2LN74DftisiORTPY8XPG73MhgkFBwnCmgXZmKAW3JjfOTxo36Mbga06L53VGF+10YLQbVQ1YPSRneW5aqJePYkc7Jv10Y5Wu31yg/Df7kDzLC44EAztjuCjnK3QVEq/l+iHxph7zaLoXj4Zb8FUOTXZWS1LOLoToKofRuQHMj0Tql61t15nvfU+HY2JrJ5SfgA4c2RAu/gFu1DkRePSijBF3RPdaUmBIIJ4dm/hVe8pCfy/I/1phoFALexSJL88E2w95VE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b12b316-8bdd-4e13-8440-08df290dfb11
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:40:13.4528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Edz9mpxLvCllCusuUg1giWVsZM+eHqksc/xH8poWIqF+/BjY7Ff1rttV+vrw/453jZCPIgnXG3v43d9ROQhG9rMNque3oDthOLstvVavBN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4542
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX6nwgK7sq3LJe
 8U0eyxd/llaXVskyAfKi0203T15sO/YQZW5Z6FKL13xGPn24xNyCMU5RDo5MfCxsrZ42ny0mm7M
 iZF8S8NhecKAF8cvTlcsM0UAcnpGQQSwYp9jQXljXlEZBsGojOR2HALS19qa+5GeUUKdAskrmM/
 t98eDHkrKwcQOXgeH51ot4gkPeUKF6v2ltrcLgK3FgFGMKIJ2hTWkkVgR0OVU342HpQzQ2JYGAL
 qh71ihnZf5TwIeSSVm8XVYnoWy4OmZvADKeN6R6MZXuiZGj+nFSbvPB7WIYJSFyKb2io8XlRw7l
 CET0tih14rbYY+W9Cy45NDsKCPi5yMRe5ffRRopheV/6O5gE7PGAfjVlivjzgsONIVxKOhVcTLR
 AiF72SyttEhmB4HDk/UKRqdtf/DEVPgLDAtmqaaKp4aMP5PzzU9WXDmaX/OtI6v5a3MCccolU3+
 ogQvf4PvihloCr339hA==
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acdfc81 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=vvjUwkIsEb8c9uUV7N8A:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: C4f6SOfsJpWl2x6mp6LHU88QqlZIpJhn
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX4Hx49injQzr1
 NgP5pV/wI9np1lTLo9VrFFoqaiq/9hWiLYV7z7Kt3woDwmwiYB0djX3sm7E7pn7fNBeJQSpblqd
 JjDiWShp8GQwT/cvzUQR82qDO7XGFXYjcC3Ftrg1I9G3qneUwbiP
X-Proofpoint-GUID: C4f6SOfsJpWl2x6mp6LHU88QqlZIpJhn

From: "Darrick J. Wong" <darrick.wong@oracle.com>

The code that validates recovered rmap intent items is kind of a mess --
it doesn't use the standard xfs type validators, and it doesn't check
for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit c447ad62dc906f4b5f788e8ff20c1768ab2eab2c)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_rmap_item.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 31cfd734962f..f248e2b0ab5d 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -466,11 +466,9 @@ xfs_rui_validate_map(
 	struct xfs_mount		*mp,
 	struct xfs_map_extent		*rmap)
 {
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
+	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
+		return false;
 
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
 	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 	case XFS_RMAP_EXTENT_MAP:
 	case XFS_RMAP_EXTENT_MAP_SHARED:
@@ -480,17 +478,25 @@ xfs_rui_validate_map(
 	case XFS_RMAP_EXTENT_CONVERT_SHARED:
 	case XFS_RMAP_EXTENT_ALLOC:
 	case XFS_RMAP_EXTENT_FREE:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return false;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
-	    rmap->me_len == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    rmap->me_len >= mp->m_sb.sb_agblocks ||
-	    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+
+	if (!XFS_RMAP_NON_INODE_OWNER(rmap->me_owner) &&
+	    !xfs_verify_ino(mp, rmap->me_owner))
+		return false;
+
+	if (rmap->me_startoff + rmap->me_len <= rmap->me_startoff)
+		return false;
+
+	if (rmap->me_startblock + rmap->me_len <= rmap->me_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, rmap->me_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, rmap->me_startblock + rmap->me_len - 1))
 		return false;
 
 	return true;
-- 
2.53.0

