Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF38F3FD955;
	Tue, 13 Oct 2026 09:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884449; cv=fail; b=fYp7RlG8zg9eXpVGeSPyvFJH0fJT7tu06mAkXGCrSWcYJCxUb4TNoVHWN8yBNOcqGjfFqF9FeXoOdO/gyMqqObi5U7XKh/nEV0UZsWMO2wgkg2ebmYbtJQO6vJro/2zhBVSV/GoGk8BQ3dIm17hTnyoSSrN8RNjMAqYl4RF4EIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884449; c=relaxed/simple;
	bh=rUbJ53z8Udoaq9ctCnM7otGaGvYjIBzjOeBQHLC0YRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P0JJhzgerl23GvVEeLCkdWobnHSIwRBZjTB6mZjr7T1Fd8S80xsBRJjq2yAOtIP+SMEof+/66TDchJTtYn8oUPDm1mvoXSmDOodeqG6CKvvxpsWVSm9rrRWQxmnD2WrGmHQgP7qapX8yHCvfN9+vrEqQxwnalpFxzarB1cgYsqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oQS7Kuvd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y423OL5Z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oQS7Kuvd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y423OL5Z"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2D3Jf3436329;
	Tue, 13 Oct 2026 09:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FsdTNh3wyQ6OA8DFrfSDd4s5dz5wajzOn141+cOVxbY=; b=
	oQS7Kuvdi9wqPT2OgykHFwnV1PL/THsTKYhMOmejeK89v62iY0n6MZBgJQV7xiga
	I6E+b5lMLRgxYdZpllMiuleWe73dAxZl+4d03NhQOr1pj0bJTd0ouEeAjAAosv4s
	KzlpzkLZkMGAceagHgTeamcZtwPFOGVNQxwabbTkrd8l2QOf/iUUmuy+EUQHfi1G
	ce3YsZr291FQ6LS9n2aL1ZTMC0lyAsjhpzcD82oCkooSlDxQbokbZHurozPk4JKk
	H4K2Kw0DyZ5uIChm+uDp8daxkgwwDCpHyMP6JZD7Ctz9WHgJGWfO1G+M/L1KnMs6
	Pp/uy1MDstWwoUAov7lGMw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kp7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aSTf010856;
	Tue, 13 Oct 2026 09:40:44 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012002.outbound.protection.outlook.com [52.101.53.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d6q5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AsDUQgDCTZmWzkbcM9tEA3ql6D8tDKM1HFGXTIR9lSMZLNp+t/FXYvyc2eAFf652GkDvbACS9IYewhKUxClqwGA2UZI84bwxksUUeVi+GzZQ5QVapwoAAzntFZx7D6ng4WYOaSLhcVu6+5rxR3rQdbEn1+vEf7djWmqnnQezucC5x6gnLNqs7vpRKVpxpQWCssUURYjIYMhwoTbUhBG5m/uncaWnBrx01lhMb4Z44Jpg8be1i+qbmucz/36QQwYOwsGTVWRY+aiE7IS2bUZkfMtP5hmDp/60ay1C4RwrBYPmrGYw/VdP9v3XnqOIt5vAi5DxHzb/dOvCZrLQ6AuocA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FsdTNh3wyQ6OA8DFrfSDd4s5dz5wajzOn141+cOVxbY=;
 b=w+oPJ5Z3ibURun+SApZuGhq2bXlkTw/Gd5kCEyh0vJyZNBdnHtPx8GRKdkDwuy0XS2mQL40xoYYFSi920XElHn7N5OpGvJ0YX+6xej0b5Lo84rSbT9sVSjl0E8Q5149X7mDBrRDz4gwGC9PMRIDNTbYSU03cdBjQzc8uzvcrONzoXSDmRKrGcRYKr8bqzUF4+6NQ/QuWqw06AfjeCKD/vugCEjdb9MkpTiobeapJDxiPML7LsECGgRiTbYNanZzl3egqyupvjB9iQ6mvNg+Kd+tVem6djjAF4R9t/2Dg/+KmI6EBbOzhtoM6tL9nZEaPgee+1ZkD9hS1/XQy2oFEVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsdTNh3wyQ6OA8DFrfSDd4s5dz5wajzOn141+cOVxbY=;
 b=Y423OL5ZnHVT+NDdspNAhyianIMH84n/Wck1xS60hJFnlC0cd1KS+kJiOLz27v5J9RVmI2pjDY/NqxF4ufTYTKln3+ofWagxHy65vN7e7zHEHNW1Ikndz2/A807kKd4IvM6Ph/Rwj1S8HIv41qF/kZsecH7MR1e62/COyoUB1cQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:40:40 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:40:40 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 09/19] xfs: log items should have a xlog pointer, not a mount
Date: Tue, 13 Oct 2026 15:09:38 +0530
Message-ID: <1d0b5f631acd7913c24397d61ee30f18f33df835.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JH0PR01CA0075.apcprd01.prod.exchangelabs.com
 (2603:1096:990:57::17) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: e31871f6-9f16-40d2-33c9-08df290e0afc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	kMqvO7GiWX36ZbRI/oUg91TX3o1mXsMkMdKWbwxi8bXFE176NfsMINSbPiJk/Ap9fRvHXfWYXVdSJs/zGkPtIgORjxiOB/WH5KvIlOaimatqOdjHPocfoQx1SKiJk/mcNfAauWg+HRpCNlxtlQCBZvQVe1RkGhRd1wRrv8krTXuWkNungbhwsASs07c5v7TSfhB60kxY6oMPjhA28GA1Dad4KZr2TdOYVBl1n8GXkpRSvzh1Et8WZ7nrsMz0H8QWZAxd7V87xmZR/lIXw6Be+g8sk1VVCBAOoEsPBXHBFmqzgTTTGkIF6lpte+Nd50lathZJXo/skYQPTxAmYk3lAjbwH+in//3Wy1Xgj58rnV6SI8h77Z87QKDZfNHuguImbK5mFL3uhMdLOv8U4LUUW0W2pikwtkYbdDhV6GukrZng0f8YWzyogttxFPquCD9w2bgbt2lwgjhiGS0m0/EJnElHzHZadv4V+VcWjyJzY4y6HQ3hzXnboUy8jwX5AjKo/YpKbkoWnXCCmb3aqU0MkPvRGZ714lJy5LtCQVNkZf0kLGYSPK3oXkDN/UCXjb6me9a4pyPaAuQ2+F1rjR5sCY69uKQIK2BOBk+9Lkmic2lVFOdmggO3BNrvSpyu4duNQ0XpnmiGuWgc6doUKJzMm59A1itfF3w8CjE/3gt1jKQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CO0nrS1/NJ59Js64HNEbUSdO9ZZBJ24KwhydyfCHKJPP1SJY1vPawEYLt6c6?=
 =?us-ascii?Q?qG7lrUA87cwX3IwuSX/66Bh76fDhoXxlrDG5kmriNCbCq7PmCUb/XON6TaWf?=
 =?us-ascii?Q?G8bJJepkug8PGyfPw3SjFe1q0RteQ0eqb6pPQTN69UAaTrKLrVttpnTxhatK?=
 =?us-ascii?Q?DvwUutcQxAB+gYsMOgBecmjakKC5oxAiiMc/n1O+nKBZu9w6FNJcDEaE3/6y?=
 =?us-ascii?Q?vCWNirTlIQBopy6tm5+S/XhvIeU2WG8M9XdtnBQQF6J6yFICxH50X0F3XvAr?=
 =?us-ascii?Q?AYJhMHWLFEstIHwMjfw2428XZSe6hhyu6OqXb0yap+04HFClmUiB5EiMPydF?=
 =?us-ascii?Q?XQbo0UAhsuWJWdyvvv000h/IDwNubIbYisgOTEHdqb/VnSFGiCQldmYJWjad?=
 =?us-ascii?Q?LarxpAetuVRozlKMNPfCxj97F3KnCq/uI7YK5q5Mn08HJUa0KLeiga/Xnqxv?=
 =?us-ascii?Q?i6FlKkxH8Hg7Tp8OGZMBBUZRSt61WMvARdoDNO187w49lYITjlO3mMQKOKIr?=
 =?us-ascii?Q?q6Gi6+M7sDihotqEFpuFJ7oYQRHeUt7X+CGuQgNsWKgpjhx17HOXBY1mX4gS?=
 =?us-ascii?Q?qnxf6L4SiJxilM1IblKSzOzP0nJ+tllbX2IQnAby5N25K2hZR2w6NgFVFypY?=
 =?us-ascii?Q?FENKtShyJQCLMQPK2JrwVLT81T6C3gXWRecIR8pRu0bxZGe/4fg9nTldb1x1?=
 =?us-ascii?Q?Fb1iAi76tenl5+XT1Jy/ZSYlh0a4yiLM4etQht0iE718iAMk9HRe2Qd88nzn?=
 =?us-ascii?Q?b1y9SVGSs5yI+geC/gsmkijFe5hGH5mkDkdKQ4A1mIewWd4/JiU8vnSetS3w?=
 =?us-ascii?Q?C3anLFL7qms5ddLbmBYOScNoWWutvC/znASTXHOUJhefj1OMj1vAamTh+dMK?=
 =?us-ascii?Q?eClauRbDmk7Gfi/K/eZbVrTNL831l1Wt7pT4Y0UbPNreB6dia7LWHZMOVHsM?=
 =?us-ascii?Q?94XSPcM1M5IW4qv7FGjUq72sd2NMGb0Wo/qTGxfJMrlhjaNpwSR7GzesiVJC?=
 =?us-ascii?Q?n5WQmq/r6os5GF4IHxTfj+0BMXLH1qB11Ptwf/QHOerCkcU4OhO1rBGgGThr?=
 =?us-ascii?Q?DDnGDHFGWwrwGS3V/NmEnuoEsgQ/fQ8sVXlBkpAXWL7yP/8nA3vSipiaHddw?=
 =?us-ascii?Q?52vJBsfy0hm68q0zXzNK5f0GiPJOGFKPGKwqH6h6m/2NIDCGlRqk2LY8ZEzR?=
 =?us-ascii?Q?ry/5vpEknKscaUdVIhd7vB7ckyRQn5uYkDekvPPLVE/tAKxpR/b/Iqx9ZOrg?=
 =?us-ascii?Q?zPWjrN3XxglQh0GmxabsI/yn5xXsda4LaKs65W8TJnePmnRuWp8U15YgVFMG?=
 =?us-ascii?Q?r8Zk1kRTw3r/nZKaCxsX122qxzuLY6aQQBKEgb4UgC9/CvnAx6/JUXSpesr7?=
 =?us-ascii?Q?bvUTGr6skNWDkigHpTFA+kPG4PUc8WYhcQXjYnUIZPQ1OY2zh868QdDyJaz1?=
 =?us-ascii?Q?0hmJkVaCDT60DnePRPx2Z2IZUba7V5O27Mm9T2VOmh0spJPfgdNPT3oadMpb?=
 =?us-ascii?Q?1jVOuGh+CsZ4DDzL6Bccbqgh24igCTsqeW68Fyw3g//d69tdqA9uGxCbbXxr?=
 =?us-ascii?Q?RKGH9dCgJ/BPBXxxA/qfxlAVsq/9ADF8BT+7KH3nqg838p6rj5QPeQhOtJIw?=
 =?us-ascii?Q?J5ZuWizebaziYCFbzCSkZIXSETnAf8P/VhSu8yoOIxbuEBITFa8XZehZESMU?=
 =?us-ascii?Q?pdQ6nxgpmLswlRUmTwCXF+i3eX/+BM4c0KlbfoljwEz0pSD9bYGQQMtUv/6R?=
 =?us-ascii?Q?3FYoP9aJ1Hf0GTld5k/mUYSaS1ziZOi0Ufz6mp9iY06QITeYApYpVdn5tdRN?=
X-MS-Exchange-AntiSpam-MessageData-1: UGS6oioFfgmDYjAhyLi5F8/Ra6x3NJzRMhQ=
X-Exchange-RoutingPolicyChecked:
	ZBD12AXbqCK5sEd4q5qrJDpCD84OVniKh3zSlk1qpHIIBW+i+tCZrP1BScN8ekoWMXXbbHLgVoeSTf0fYvLEvIXfr22PHWrFqvIPCU7ipPGKviPz9QVZYs+VZtQbw5jL1EOVGpOrfnvnhr1Rm4h2Gz+76KHZrw5fpvKxFUZ7fRdMJjbd9HLfuiGubAGhDztoLL3JMYzj/R5gYS4LU0cw4koBzCkAqx+ZIAjCXgPkwXI4p5mcnIL7bpCga7U3kEEl7A1sNXXfV/3RpMd1gEd/hfmnYZrTMsm4UCgifvZz7AUBdnTRqwOk7+ZlSaGzMrBxYVk5MNjZGLbOe4dG6tgU7g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eFuo/ih+eQ5afN27Af/vkjVoWa+qfqznACsFUHo5/aEUvVjg/0cseAeLiLWtKVur+51J1WPdaC0AyEVA7FpAQhHXOkhvrRIWHOys+jh0tlaJoEuCrGXlUCQkXdyVhHVmtRzaBPkcIB4UeHvwh84OrFoJvau2iAiHpGK7e/1QxZx8PrO144H+0MfQSDhnp2iAG8/1IzvjFYHAKAaQ1WP9adNrJTxov7CuxI3QmXWue4m1VWFsqyaxVzOUQXJxxxt0T7q6nxF4qOKGDul3c2xML/0A+f6klqApDsDkPp+kwObPTEBWi3mH3f9/Slfx/7oOU0p2w1wdgXohhIBGibWwHyiUxkT0H1AFoa9vOAhHsoCIJrRXx9wXdr2pSPWxYFb7EIXKfqNKkBIFVBix6F60W+JVgZHlRvVJ3vU6PtLxnJrlFhyGtSBGNeQaMhN3/D5ZZK9uUYC3kXsGwUZkhjop8mWTT5nz0T4psbR//ba9EhdU/VULPPGxY2wgiRP1dBNyNCSjaRu5cSUEhiPF9mY9VRtdNEkk30nLZDLhjZACfOo8PlwYpdOMzX+FU3XTyHyvUWqD8Fb8rwglTZ2Ko6o9lT04JlfajgwvvAYbwcQGaV4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e31871f6-9f16-40d2-33c9-08df290e0afc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:40:40.2920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pS1/MoU6CC8sGusFxyUaZlJHFW9rD2Wtum2rPm2qYAfxNJLe8+vN74o0/aw3RpSqwD/v1Kj5X67mipCMWo3ZKaKsaB7k0hSiavT7xm6LFtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acdfc9c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=nZXUwzawmNCwDP6AOoAA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX3eCuK44aeO9O
 ZMHYs8m2Ghday3LLyShYQDb4JymvmvkFeZtA5eCL+rKbFav+epJYqU2jFCzmKsnYIIi3JOwDNtw
 IdiwTxSbHXnfp4w2AR2pdvSsHvn+KxQuDd3XglrvG9rryFTEoInj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX2UPjklhkckIA
 N8jH7kvOniyX+clvKa80de+tjsFbQ5k5QtM5W2xoa9ZAI2RNi2tDSzVqE32/EcDc6BtC+HYSb4q
 ibkW0k80dkEPvCpkJ1/qlEnCEzAkjas2+iHI8YA+rOhoyn/lQGELXnSKzRLCkEErb4Oea+qnfwB
 ITI4A+LIbGPKnsrnyMda0cK/vMOhjpjuYuxkAeVe1iyzZLoC+FtcpytdJjJrUBePnBiTuS5IBi7
 KOvGaPQ62Tiglh+vMhI7UDL8qghfI+HhmznPd4hPO09WpOWv32coYbFkdk8Uduy7oj/mWHNzV8F
 rUzXfO1xw3v3cLE6HK1ae0k4Q50UKgHk67YzbIipPScHRbsXGeof6XgVdj923nC0g3BafxctIr2
 HxDZailR6DEvJlUKzXe2lva9MxRhrZway0zQxHQAx7jW3rRxO1CPxSuasjL7CsUVQjYL5v8urTt
 SB9u0QqCPDVdt++Zxlg==
X-Proofpoint-GUID: 9E3piGN9uyCcUMQJ72_uUGc4mIQ_MJ9u
X-Proofpoint-ORIG-GUID: 9E3piGN9uyCcUMQJ72_uUGc4mIQ_MJ9u

From: Dave Chinner <dchinner@redhat.com>

Log items belong to the log, not the xfs_mount. Convert the mount
pointer in the log item to a xlog pointer in preparation for
upcoming log centric changes to the log items.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit d86142dd7c4e10e50bdb3679b405d748214b2c28)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")

5.10:

Fixed conflicts due to the following missing commits:
        38c26bfd90e1 ("xfs: replace xfs_sb_version checks with feature flag checks")
        75c8c50fa16a ("xfs: replace XFS_FORCED_SHUTDOWN with xfs_is_shutdown")

Extra conversion in fs/xfs/xfs_dquot_item.c due to missing:
	40b52225e58c ("xfs: remove support for disabling quota accounting on a mounted file system")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     | 2 +-
 fs/xfs/xfs_buf_item.c      | 5 +++--
 fs/xfs/xfs_dquot_item.c    | 5 +++--
 fs/xfs/xfs_extfree_item.c  | 2 +-
 fs/xfs/xfs_log.c           | 2 +-
 fs/xfs/xfs_log_cil.c       | 2 +-
 fs/xfs/xfs_refcount_item.c | 2 +-
 fs/xfs/xfs_rmap_item.c     | 2 +-
 fs/xfs/xfs_trace.h         | 4 ++--
 fs/xfs/xfs_trans.c         | 2 +-
 fs/xfs/xfs_trans.h         | 3 ++-
 11 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 5f1c2fda8e4e..70849a2bda45 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -474,7 +474,7 @@ xfs_bui_item_recover(
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_map_extent		*bmap;
 	struct xfs_bud_log_item		*budp;
 	xfs_filblks_t			count;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index deb69740d492..132acdf0aac0 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -21,6 +21,7 @@
 #include "xfs_dquot.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 
 kmem_zone_t	*xfs_buf_item_zone;
@@ -347,7 +348,7 @@ xfs_buf_item_format(
 	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (xfs_sb_version_has_v3inode(&lip->li_mountp->m_sb) ||
+		if (xfs_sb_version_has_v3inode(&lip->li_log->l_mp->m_sb) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
@@ -535,7 +536,7 @@ xfs_buf_item_put(
 	 * that case, the bli is freed on buffer writeback completion.
 	 */
 	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-		  XFS_FORCED_SHUTDOWN(lip->li_mountp);
+			xlog_is_shutdown(lip->li_log);
 	dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	if (dirty && !aborted)
 		return false;
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index f2cef1470373..12b265a630ba 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -17,6 +17,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip)
 {
@@ -331,7 +332,7 @@ xfs_qm_qoff_logitem_relse(
 
 	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
 	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
+	       xlog_is_shutdown(lip->li_log));
 	xfs_trans_ail_delete(lip, 0);
 	kmem_free(lip->li_lv_shadow);
 	kmem_free(qoff);
@@ -352,7 +353,7 @@ xfs_qm_qoff_logitem_init(
 
 	xfs_log_item_init(mp, &qf->qql_item, XFS_LI_QUOTAOFF, start ?
 			&xfs_qm_qoffend_logitem_ops : &xfs_qm_qoff_logitem_ops);
-	qf->qql_item.li_mountp = mp;
+	qf->qql_item.li_log = mp->m_log;
 	qf->qql_start_lip = start;
 	qf->qql_flags = flags;
 	return qf;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 11474770d630..632747305463 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -588,7 +588,7 @@ xfs_efi_item_recover(
 	struct list_head		*capture_list)
 {
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_efd_log_item		*efdp;
 	struct xfs_trans		*tp;
 	struct xfs_extent		*extp;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bb57a125eae5..dbe5c9ecbebe 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -991,7 +991,7 @@ xfs_log_item_init(
 	int			type,
 	const struct xfs_item_ops *ops)
 {
-	item->li_mountp = mp;
+	item->li_log = mp->m_log;
 	item->li_ailp = mp->m_ail;
 	item->li_type = type;
 	item->li_ops = ops;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 407e80d06bec..f9c24bada01d 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1181,7 +1181,7 @@ bool
 xfs_log_item_in_current_chkpt(
 	struct xfs_log_item	*lip)
 {
-	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
+	struct xfs_cil		*cil = lip->li_log->l_cilp;
 
 	if (list_empty(&lip->li_cil))
 		return false;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2532a2a1cd59..459d04320c6a 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -463,7 +463,7 @@ xfs_cui_item_recover(
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_len;
 	unsigned int			refc_type;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index f248e2b0ab5d..132976ae6888 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -516,7 +516,7 @@ xfs_rui_item_recover(
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	enum xfs_rmap_intent_type	type;
 	xfs_exntst_t			state;
 	int				i;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 86951652d3ed..2b7e6322ec66 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1169,7 +1169,7 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
 		__field(xfs_lsn_t, lsn)
 	),
 	TP_fast_assign(
-		__entry->dev = lip->li_mountp->m_super->s_dev;
+		__entry->dev = lip->li_log->l_mp->m_super->s_dev;
 		__entry->lip = lip;
 		__entry->type = lip->li_type;
 		__entry->flags = lip->li_flags;
@@ -1222,7 +1222,7 @@ DECLARE_EVENT_CLASS(xfs_ail_class,
 		__field(xfs_lsn_t, new_lsn)
 	),
 	TP_fast_assign(
-		__entry->dev = lip->li_mountp->m_super->s_dev;
+		__entry->dev = lip->li_log->l_mp->m_super->s_dev;
 		__entry->lip = lip;
 		__entry->type = lip->li_type;
 		__entry->flags = lip->li_flags;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d334bb3ce643..4e1400ea6a99 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -644,7 +644,7 @@ xfs_trans_add_item(
 	struct xfs_trans	*tp,
 	struct xfs_log_item	*lip)
 {
-	ASSERT(lip->li_mountp == tp->t_mountp);
+	ASSERT(lip->li_log == tp->t_mountp->m_log);
 	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
 	ASSERT(list_empty(&lip->li_trans));
 	ASSERT(!test_bit(XFS_LI_DIRTY, &lip->li_flags));
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 97485559008b..f1805119a1ee 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -8,6 +8,7 @@
 
 /* kernel only transaction subsystem defines */
 
+struct xlog;
 struct xfs_buf;
 struct xfs_buftarg;
 struct xfs_efd_log_item;
@@ -31,7 +32,7 @@ struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
 	struct list_head		li_trans;	/* transaction list */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
-	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
+	struct xlog			*li_log;
 	struct xfs_ail			*li_ailp;	/* ptr to AIL */
 	uint				li_type;	/* item type */
 	unsigned long			li_flags;	/* misc flags */
-- 
2.53.0

