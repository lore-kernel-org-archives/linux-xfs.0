Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959841D1751
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890901; cv=fail; b=kC2UfALxxysXadD90xbeQ340BahD0/gF2iQ7VSdY6Eg2DLvAfjJFUgdK0/brZaJR5BCFo4sFcUF6Zchxty1d3TCCk48uUQ+EtHhvb4IrTI0QlJpwvpKYi2JI0k6cJ1+lfM9h3NPlHSlsZbkOm3uuHocsf3CgapaSBECEIqPVF48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890901; c=relaxed/simple;
	bh=xEtIUHQjOLDvesOD/Kk2rAj/tWg0GheOV0XvuWh9EnA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pf5Zj1j3E7F3D3lE7/wVJT76Ci6Wujb+UDbUSOLd2ACsUrm/92MHZvHEDlRYlQcGOrZQA1wkNo+q2MZNB9Ok+2nZnYONAzhqQZ3ZiBdjAlWw6gwwdbwB0PvB3DL4dOgH2CJ5qU5lVb2S/3gIIcpMW/xQj4PEDhEPeSlUUbTxioM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z4SYUd4R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=patOKyD8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z4SYUd4R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="patOKyD8"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492Hfb5d030327
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=h+KSSixwFXpOhmJfj5g+CRkOuvuGK4Y4L+TaHrWOv64=; b=
	Z4SYUd4ROfFPZHtBNeKuLRbGk/FvZ6OT/oqHmEE5x3IZGrVAeX6W2Z4AzdrLb7Xd
	fQ0BQzDE81NK8WKlMWwzg0mUAqi7JlCP8FWJL+CABTy30spDjcJiDdfN6ucdHszw
	P2/ob2YQkHV0ZRC7UseOkk9J6G59t6X/NFM8m7HcnWyvh0zUyixjAGdCLwzH42UO
	6Mn8iYV6E4uTMH4NWp+NQR93nXr30L5Po9GsZ4C9LAmlND+JnJtpjc6TFchcaF/1
	lYmX/YqliAdZ0CsK0tEHT/sE4Op8GK3YYpFV2s7D4M1IgWjaV73CjCVlNBTPTwmw
	0NYm9BnfTK8u8JtZAqVu9A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8k3aear-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492H6NYV040603
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:19 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x889565e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cdL1zzsMUXoD3RvwiqWUwbLL5CGG/bHrN20EkyvXNK57P3OoyIUIXxalqhaAkaI9IFX+TF8JcWxodzfDtu56nwmHq0+GkIvY1QE728JNa5lcE4IHIvYzY0JYwj0GlOFD+PA6d+WGy9oG1N9aEuQJxRPdrLRLMqJLI+aPGa0ucZnCJAze2gz5FJLQbIk7G+/5q9kR8Ay7ZNUFpy8xjdyxaP96KkRwhv9koWAM7kKwNOt3XezDLIIgZ/z3vdFz+v/JSibvoaHvdgksS2SRaFRcte0cNn3RCtgqJuDJ3xFHa9r1fR78cI6NJzBaLT7OugCpCWS7AUAhcaTiWM1HR8TXXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+KSSixwFXpOhmJfj5g+CRkOuvuGK4Y4L+TaHrWOv64=;
 b=zL/PDu5oChdJdDqxUHzVyJX8B+FnRk0nWWJ+n/LWGTFbGLtJcKKbCbXzdUzfP+e/7P4os9+snMwWYxooM85F6IeOFB5aVRUn6NA/KjjP8+3+MI8UrcFot6zotEBa9t9xbUV1ZxNoAw9phx6wrRCkOJyifHJc0Pq8ViU9tWvy6pbSb45JF0iLZKJ4G3qQOqgYyH16fpTZRCyS2lU8nCtcB9fMPiQ2mf9ij/y/YCb4V/qQw0JVxBLxThZj6OZSTsDLTorYBDCZ87Pg++lEWRmpelg/niHFRl+9ZgDP5wRtlRaZ37n6wvmMZnGqcJlmmg9NPY8/cDF9GSWOdfMWBOw4JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+KSSixwFXpOhmJfj5g+CRkOuvuGK4Y4L+TaHrWOv64=;
 b=patOKyD8acuO2TxQZh01naO+9d8CcRJFAZFJqwtPCZPmuIV/+rAj9GPMH5rHS7Z261NFe9jqwzAmP/xrPQUAaWbY7qjQx0hUkQ3aAjRGtwSYBN5lH1FnNyKYUcQbEqgDQ60R7l9PIhJTmqEgL+RodS1R2QeyDbup/0aZZWKu1tI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:17 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:17 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 02/21] xfs: fix xfs_bmap_add_extent_delay_real for partial conversions
Date: Wed,  2 Oct 2024 10:40:49 -0700
Message-Id: <20241002174108.64615-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0031.namprd08.prod.outlook.com
 (2603:10b6:a03:100::44) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 3253df93-9258-4bb8-fa05-08dce3096af0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6pmjyQbIsvNxWcmCey8uPCG6fs/xUPsJPmTnEuUGch0gHs/3b8T+ZrB1rM+u?=
 =?us-ascii?Q?rUW5qe1CpxRXS+CR4abxkcyB+BwLEi/uJ8kFlkdlFYDSD1TtI//UMQFHptsm?=
 =?us-ascii?Q?Fserc3p9rHf2L5gK5jdpARUSlSVLwRPHw6yTKImEXwNlEYfqofGtqF97O4Eb?=
 =?us-ascii?Q?CxaiaZ6uI+K2dJyuaVTXPDHWlCQo2tjtaXm0L+PjvUOJ5RTUMC1H+HskLttB?=
 =?us-ascii?Q?mt058Ev3MM5yWTH9zTriOsN6cK0u//L/t0X0KVfW815a91dOt1ladtZk4mAf?=
 =?us-ascii?Q?u9CrC4akWMeNLPY2tOOgM5sgL5e8yyYQtwz73sQHQiRejTv4sJPqxHtuSKWE?=
 =?us-ascii?Q?tc/2Rg4dLTW8V1akEzL/UFYB9MtcPxkINI1qeFcEPTAPmeC8Tzp+2IAf37nR?=
 =?us-ascii?Q?77wWiHYJR/mXFWObeF+wvufa8gA1PBvZ43uYtNKtUSi6kf/g2G7OZg9vO/O/?=
 =?us-ascii?Q?1oyAmzEJ6pwD3Y9jFlf6JYv0y2y34K/6w/7Nl4kHSbeB7NX3FJEU77MZ6LgV?=
 =?us-ascii?Q?OctQo9xqTw+k3hwL+IE8o5afOkNsUKLzH0/rw1xocx5Sj5N9YaQOMLzepuHt?=
 =?us-ascii?Q?PJ7f2sXQjrfbSyvL7qXxBjuEvjhnl2V3IHScx22YECfPurcZwR3aiiSWFMCt?=
 =?us-ascii?Q?GWCgSdU7a/07PxntCTN7fvdoLSaZCh932Ker1T9+PcrEPxTCRb991x8rIVdH?=
 =?us-ascii?Q?ZcZWNaqD+TZT4WbTGyhxUuh28rL58B/aUFFBtTNZyARPMIrrWlhOrRCzQ1/K?=
 =?us-ascii?Q?BkVmcvFOtpqwEl4YJLN75w8blIGJvgdtZxqisynRde9XXIAcZ0ObnaVNPpkZ?=
 =?us-ascii?Q?cQRD47RJgsN5iVhB/HCnp/tGit3KOSapHJIe9m/9wHccH5OGjIfiJdp4sogB?=
 =?us-ascii?Q?NwIEdud8DdT9mRHoY6KNeKBqnF44gTQcUDiWIQUq0WJOw4AFIBjEeghKB4GL?=
 =?us-ascii?Q?20x6Rub9g8KFtT9LMySp0ECsBrdkLXpt5KDE7NEnezMt6cKEaCr++YR2vzb0?=
 =?us-ascii?Q?s61dW8Rrfqs/90wspCenJUuCsGWjKTIqZdwVaNJmAvXzqoWHoFC7OeJKarA9?=
 =?us-ascii?Q?4ndJkTYKg3SyQ20D5H/2quOLfgHZL9cmjqDkm/ZEvbTaJoihtsdj8GEroKXd?=
 =?us-ascii?Q?W0AZr/SG8v3AWneKuGGfqhHFnx1mHQu7uiAYQEOzlBtddZzNLieNZV4jnAXF?=
 =?us-ascii?Q?DK3qe4ayOviHXY60tqHI/cKxB84oCXWYVIIMvH8w2z94bD2sSMEtXzpLGTN5?=
 =?us-ascii?Q?EIqLBjX1q0IXNpu66P7rPlWsCbvGp+PepX7AlYFBBg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vymWIroQt2PSDGT/4jAAWAyq6uDpjg5L22NI6mUy+wiuY6DsZ1/egpZs7bGR?=
 =?us-ascii?Q?B9buVRDjUZQ4sc9G+g3Ho+gBLDjRz3iy8N3OLCCFNvbfRqBlFzBDfH7FWXuh?=
 =?us-ascii?Q?u9kUZgwcv6cuSotrMhhmyGotjPmYgQTPukoWPzxNP/K0SrFH3PYI7ihzRSlO?=
 =?us-ascii?Q?chMjj0gPPkJL4TbE9DpcfyJPKWBGYUIV4dKQNpuSiWEmACGY4jB0Mw2Zjc0z?=
 =?us-ascii?Q?J9nrYyhbZG6zoauB/UhbeD9ji9/AkFSLuiUnoycZhQ7ZSE1Fn1k7ffwOcara?=
 =?us-ascii?Q?GMtwtojBU+RS4UCh43cNwlsuHvAMg05qRH8N5c83FSXv77nJkfwZJh4PsQ1D?=
 =?us-ascii?Q?06w/0EvCVNFAQ5JmBIOd8K7AXM9Cd2xXqlLv+GBkR3GLQ6DC0ppwROU/8XOQ?=
 =?us-ascii?Q?s+vTtOHqjJvIdAd4ZsoXBlnfPPQ/GViQMJrPBDjz4YrkVG/Q7weTZozd3N2s?=
 =?us-ascii?Q?9hBq2oiYyI7+DF+Vh4+l85NnDUOyK5QK+hbHsisUlkYYQ2T1AyJ2xdUTHBxU?=
 =?us-ascii?Q?tYLM0RKkopfG9+uam7qwUngrtqIdWitKX1YJfTLdi644qkN1+QlYzzPPZlAY?=
 =?us-ascii?Q?W+Jvy17pgjY92bOGJ6GL966YdB5uzWm7nL3Pfu4tgkexgje9DB9YxdCKQGmf?=
 =?us-ascii?Q?HPs2qCLGDksSz1eLEaFsgadv844EWh22yO7v2uds0/GbCpZ/GDnmR4ELLjVo?=
 =?us-ascii?Q?JLB2p+Gys4pu2Z0aECpINXwGfkYvpnMePlJLWVHE7VvCM4DnlHwI9yLLvGfB?=
 =?us-ascii?Q?lpRNJY87pP/ZV6+mUoD+Ss3L3PSGM31PzEw4xa7DK6kOR2P+3+Oa/DeLuZg9?=
 =?us-ascii?Q?94ICjJuN/gsKLZbQoMv79Kx7t+gGsltrENx15bIiX0XdQRvpBKBiwrQTk148?=
 =?us-ascii?Q?VjfQ21xKvjQhiNYMTaDWvAKH78hKKD262ecQsksSc/goahRBUIoZkp55NekW?=
 =?us-ascii?Q?yEYr+RpNn4b/fqbFTnwGE/tA9OHhBCnzWddP0ghh7P8Xull8Ie1Af24QGGFI?=
 =?us-ascii?Q?aZSqFkch/5MmVTHCyGw7Z7aJ4JwHkKzhAyXqzXXnujhho1QvzYNQdH4oN+CA?=
 =?us-ascii?Q?qY0lCGZj0QaBSn9SnT1OCyVRKp/vqrb57wkhLYcmcF/CnKuLKavXXENHJH0b?=
 =?us-ascii?Q?kcYQqREsfZEkJkkLwDfwdaOPuyoi9ulunB+Ja9FL+Ug7xFVR2dyZhe0Z1C6A?=
 =?us-ascii?Q?CsJvSpJCh2j3v+gxNHXvfEH8A20cIeVYfpTfFjJyX0TKOsEJUEaIQxLey6hX?=
 =?us-ascii?Q?tLGrizbdWc2pFkDwBKSs80RrikIIvsfQuMsHsidUFl72S+hZ7W0JrB2Kpvxf?=
 =?us-ascii?Q?YGs6icd7EZbhesrYR0BKQ1TwhLCq0wv+KFCuxvoVPvp5cfi18LL3DygYRSSb?=
 =?us-ascii?Q?krUYE8JBW5NTkf3/oJ2DoYDXxWkL0WUmjiJU9dI62PDkbowB2M/il3SDGijK?=
 =?us-ascii?Q?2VIb56dFryRt/0wUxaYPwehbQt163AiYbcdZgJ3XpGYQlnZAZzUrzH9UL22D?=
 =?us-ascii?Q?MEsfDadw484P60KOraerfMQ/SlCa7LvRjOfjRs+vq+6h0KuJxSQ70P32lxG9?=
 =?us-ascii?Q?SLsIRiXkTQvgnqpdAw6pyhLTaV9XgD/0FkjB92VJloZD0vD3O90sOzm1baeA?=
 =?us-ascii?Q?r3PW4sRETN1X0EykBYoF4JiuRq2YzvtDZmGOHIlE2LAmh60emEmL1RLaqc3r?=
 =?us-ascii?Q?lXOytA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/vg/2hc/co4RsjxD2CKpzVlTZPU2IfmsbpJR23HrP17k7Wim1bfDkFtbliOC/duEuxR0YmK4W1KI7JH7aKrwd4oDrJ8KRZ9xjFp/p4RHc85rBI+TKiGCgHRG02qBFWqDxBEzsSj7ufVPmPgz+h9r2TdwKVmHxcZ/5ZkCritCjMvnTFuWNIHxPToF5mtPTR4/XlibyVfSO6jF6i0jY3o2WuptXFkluaA5luWZDKagg3a3OiW7pnXDiWivVexkWrrfQxvgeJ4B7kq20PDa6ZBADLDoGtCsCTiqkBkd/vor9bTuDAFLXwy8cX4UbzOKAjI3ogeoOiIY46zCQeHa5mJ1CKtz00CjOSHdxu+qqXIre2TnRbufI2tHSYRWrrIkRKLX+d8yJL+knChT924OWzuGQm7yoz6YvZoJnY9cT6EfNC5lr7H6mPzHfP/R+WmIVhWMX95Dy6KNxkGwuG5l9Yf1cCbzPPeBxPybxa2eTS2qyNdGU73ePZlVlfJmu3EKPEe7xrlu5ljtVB7QmZLk0UBkoe78HneRpqt198TEaUxn/nb9dDtTAw7lvCS7hBGoTV3buw5bhhziUCKfUyKf5iatsbqWcn4i5CX6zmF2jIwTfIU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3253df93-9258-4bb8-fa05-08dce3096af0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:16.9778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QgHMjS8Tva0BA5S2AccLR1o4QQHrjr2eGyx3fvd540HT1w/U8uxhtk8dA/IsGoiVA4kMTWS+sZoeBG0NWiuSMUhptOZ7Mg+hlmHFQx/MZIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_18,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2410020127
X-Proofpoint-GUID: zyhKuaZJEeJ23dRyOGaTOb-UKGIrhw3F
X-Proofpoint-ORIG-GUID: zyhKuaZJEeJ23dRyOGaTOb-UKGIrhw3F

From: Christoph Hellwig <hch@lst.de>

commit d69bee6a35d3c5e4873b9e164dd1a9711351a97c upstream.

[backport: resolve conflict due to xfs_mod_freecounter refactor]

xfs_bmap_add_extent_delay_real takes parts or all of a delalloc extent
and converts them to a real extent.  It is written to deal with any
potential overlap of the to be converted range with the delalloc extent,
but it turns out that currently only converting the entire extents, or a
part starting at the beginning is actually exercised, as the only caller
always tries to convert the entire delalloc extent, and either succeeds
or at least progresses partially from the start.

If it only converts a tiny part of a delalloc extent, the indirect block
calculation for the new delalloc extent (da_new) might be equivalent to that
of the existing delalloc extent (da_old).  If this extent conversion now
requires allocating an indirect block that gets accounted into da_new,
leading to the assert that da_new must be smaller or equal to da_new
unless we split the extent to trigger.

Except for the assert that case is actually handled by just trying to
allocate more space, as that already handled for the split case (which
currently can't be reached at all), so just reusing it should be fine.
Except that without dipping into the reserved block pool that would make
it a bit too easy to trigger a fs shutdown due to ENOSPC.  So in addition
to adjusting the assert, also dip into the reserved block pool.

Note that I could only reproduce the assert with a change to only convert
the actually asked range instead of the full delalloc extent from
xfs_bmapi_write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 97f575e21f86..18429b7f7811 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1549,6 +1549,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -1578,6 +1579,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1611,6 +1613,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -1643,6 +1646,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			}
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -1680,6 +1684,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -1767,6 +1772,7 @@ xfs_bmap_add_extent_delay_real(
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
 		xfs_iext_next(ifp, &bma->icur);
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &RIGHT);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -1814,6 +1820,7 @@ xfs_bmap_add_extent_delay_real(
 		PREV.br_blockcount = temp;
 		xfs_iext_insert(bma->ip, &bma->icur, &PREV, state);
 		xfs_iext_next(ifp, &bma->icur);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case 0:
@@ -1934,11 +1941,9 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* adjust for changes in reserved delayed indirect blocks */
-	if (da_new != da_old) {
-		ASSERT(state == 0 || da_new < da_old);
+	if (da_new != da_old)
 		error = xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new),
-				false);
-	}
+				true);
 
 	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
 done:
-- 
2.39.3

