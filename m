Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A78770FE;
	Thu, 12 Jun 2025 01:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693443; cv=fail; b=pJFSbAk/gkekDNUbtKFhKRxdbC5da9YzyCOAeYYfsVcTIfrCmEh/yynZgq8FYeylPGyOhO7Twsbgb8bEdKqadFgrLS6lo8bmTiEeNPTaoLIXL8/Zt3Zx1RgQQNooBzT+cFy8as7gMkk93YL6yeUoDVP+xZzpNKHuXhRZscQLyEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693443; c=relaxed/simple;
	bh=4tf1kf24fDbCWE1b3JhrN7zQTc3s7nwMbIl43D9tIVs=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=cfwA/mm8id3dKfb+gnpuoVL90scmMLf+9xF2Uch+OFnm/wM4ZC1gS2GAVfxegh2LajiHj+ZAyr4qFmnDPYJzCNex1S+65NS4rFl3lbGIwBztUp4MudgnKJ3iToT6YToG7R63Zii6sKjhqwCsNgT//AwJnBk+KvttbybQIbBw6HA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iV7AX0+h; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DrYtXEl8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iV7AX0+h";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DrYtXEl8"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BMPJZN030558;
	Thu, 12 Jun 2025 01:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=MwW+Sj/CIeOWl94D
	Qk+DpCzaoI9Uw7H4N6m4BydzrBQ=; b=iV7AX0+hFn7TzfADZBsB9idX7yxCDmyN
	XemVoKxLkkAM9DUm7FmPNwvgS+fmAe6XgCf/gOl1qVqLLtOOMLf9MFZN9pbbud09
	MfuDw/fW7RXAmYVvnACqus2DtMjZhsGIJ0LnM5WKIhTfOisNRQ/cKcju3Fs1Cx6X
	r+fD7TbR8PwoFmY015pvNxAzyOF0GoqbWtzrlSOT4SZFvTe4NVHp1OGeaChWozCF
	x5QVIQffhQqTxkiVlvoFBc7Bi3UJs6s1oud8bR2ros6yo7WVsRY2JQ35cbfn/zBO
	nbhPnNsX3pX3NNAUC6m4Q3OK0wCZEo0AMmIvHVAhQbIAjbLbJoFwpQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4752xk0746-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 01:57:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55C12po4003202;
	Thu, 12 Jun 2025 01:57:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2043.outbound.protection.outlook.com [40.107.212.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvaywnh-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 01:57:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pzAoIycC8TLPpSh1SQdCU1QXL2xm9VKJ338AzFQey4wfjSDZKqANld5sIsTXvK+I9XttnV2vzv3ZDNsSdZisZ4Pr5DNnadGQ0J3KwwqoX+n5TzXUsRrIF/vyu/BzQR/qNTHVwhEG14L48rLPE6cwe3NhY8x5t9fCEekGiuE42D8TOqlAlklIBMslb9wRuTM5wPvPtO0pkP/bCApokc3jJW+iu/2e0grgkvR/rd+bRypva5C2UyHmZjjTZ/2y7nSTNssbU8LmRftMfyHCXcZokZIcFMmfYOvhCyYDiAJl4Y3X4Gn4bzy/8PpyaSC9VwJaE9JAYuRJ1AIgRBtviYJE1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwW+Sj/CIeOWl94DQk+DpCzaoI9Uw7H4N6m4BydzrBQ=;
 b=evRIDThD/yuk8KGAZXk61F/GkJL9M+f92wYJ3FnpZJvKsoA0rf3wbyqmscFDnB1ca6+zORcCnS8mqoXdBBye5cDqK4ITK/lYrpNg5FvtMMW+BwrCrMp8HuLDN8ssr7rtrjQQWDiW/HKXoJerDDmQ+7V69/ZkAsjVYjjwqxZHu3mGCuRcyKFTBYwSNYQdIyV9EUp6ji2ryx5oDcY1xbNgHCQYhbA2giyhoSNCvWlgvHIaZrcBwzhhOd0hRhJCqDu1bXMKXq1RiJoB/oafTXBWkRQyIGzgXwA0Yt7Lqc5BXoNcVxOXajoUvB5BV020RPrEt53Loc0u1/qxa1GBhHhZUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwW+Sj/CIeOWl94DQk+DpCzaoI9Uw7H4N6m4BydzrBQ=;
 b=DrYtXEl8cyRBuhpueuXPg/JcyCrk4+lev4GSyCkU8g0LFwKYJ5zLgqvsbXyx2+8KnB9qAq8kidJ4SnzGvcryglhasV8oc+qxCp/9d14ZOSXICf+0P4swFUG0Yq360O9Be075QuhcPHtG+WEeZOI6d8LKl9DE5tUVmeu6bHqUZjg=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by PH7PR10MB7839.namprd10.prod.outlook.com (2603:10b6:510:2ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.25; Thu, 12 Jun
 2025 01:57:10 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%6]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 01:57:10 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v4 0/3] atomic writes tests (part 2)
Date: Wed, 11 Jun 2025 18:57:05 -0700
Message-Id: <20250612015708.84255-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::22) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|PH7PR10MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: 365f1814-f651-4999-6375-08dda9547132
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|10070799003|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NI0fP3tiLd13CTtODVoNhrU7owUj1hM++Tz8TwP8pgPARm+GpZxy3SbjtgNn?=
 =?us-ascii?Q?cvmFSqim71ex04MtXtoGEoNiMvKh8XJlpK/oE0Dm4+zEihi6L95BrmzLI9L/?=
 =?us-ascii?Q?esFhBBi8GM2JoP5fE3PxIfK9yRMA0HDFW0mmT/PE7LrIn89eBjFQMIrWCI0S?=
 =?us-ascii?Q?qvNzg27nDegSNWxMhMZBYoD6IQLi+V86DDfuyE1IKHSOLAV2HX5+Kj2BRVXm?=
 =?us-ascii?Q?IyzgIEXRqZ9OEV0YM+cOKphif6WRIKOiDSD/WhAYtYRIuE35wWlg23yN5zUq?=
 =?us-ascii?Q?0FOZu5ZrOYz2xhfeiYXSI5sDB41ebDyuKXaZycjbdFRUY3INx5QYsun9hfFp?=
 =?us-ascii?Q?EbA2+Fnps+T5/99AUgqq8yrPQOo6DyddmZzOBs0rzkt9hPNQKdAQChP7SJav?=
 =?us-ascii?Q?IpnG0MGIi2YpZc4g2Qj+TuoBn85tJMeqtWlGoSd9zMSSAoJ0A4wClCLSiin8?=
 =?us-ascii?Q?+FnPrs6iY8EH8BuyEGybcwyvOEwAhpnnaII9eHOV1bzAW25V4FwUnTpqcPcH?=
 =?us-ascii?Q?v6lRbC4XT8xAh4qk1+GsfKtlkpIw2G02sg3k9PF7Ii0ZD9hGJf5ilUsy3cgx?=
 =?us-ascii?Q?MR2/p5JKuL/3xuN9acT0nvFbDrUvS4/o4nAmjY6wr75I9wuGalecQLbAQSgA?=
 =?us-ascii?Q?XVdLcTAaqe8JzP1Agn4DnLzwoOOXzenEyCyLKHjDWDBQMEONPbkPY9sMzTNd?=
 =?us-ascii?Q?10e5S20odlLA9W1JQMrP4/RAPBycG82QVoIYYjATLBjI95Py/0zbUqHyFUHj?=
 =?us-ascii?Q?ER0L9swB3C2l4PUEaYzoSn2X3BA+NrOkPzSuCXLD+Ul3XZ40alZ7uL/ERz+F?=
 =?us-ascii?Q?OIwEq9nIWvIJSO+2dFldBvOjWIeCOMK5UZn9VWSU2rhmNeSrkcRbh/7Jdgle?=
 =?us-ascii?Q?wLYM5uyzt/AVpjuaDh3lkQ3vvgZ/KqjZNT/e0HC2nw3tA5E2oPs7zSo88KvY?=
 =?us-ascii?Q?mFyKlcpxE3SLMjyEowD+NLdRWkr6UPQN1QEaK30FyOWe1IW3isdF9mxNqaRM?=
 =?us-ascii?Q?lWtd1SeDRFv89fScYLIAeBKWYiGJxjTTRkqKv8WfLfBtaKs8Dp6l+ed5Pa6J?=
 =?us-ascii?Q?1XGq814oW6I/71jVQxl6D0+77pRXFF7tWZqrLxfcE+qU40DT0lTBjQbonCPC?=
 =?us-ascii?Q?vqiz2FpT5fZrXBRMXvj1G4l+h95qnohtG1ndMv6JD5L1NacEISWvC2NTDIj5?=
 =?us-ascii?Q?eYfNKiMMCPrQdKmgst5t+0+Ids8YxTIyAYW3/hFvhMksKu11CPahL0a1peUQ?=
 =?us-ascii?Q?BobGUchoMIq+G+U0BjbZMrtu9C/Q6PG50TfPKBb4UMAM39OzIfAySg+HZ7YQ?=
 =?us-ascii?Q?WKEoxgwoVTIVaNgCVH11glMy/34oxX+S8750BwmvN3xhrGkEclIuhYPk/7L9?=
 =?us-ascii?Q?G5wPYnXzEAZAOBDmmRoULkr6mm3ux/lmaUB33SjV6wterFpDcNg0+u5t6Chr?=
 =?us-ascii?Q?Inxzg8dB8e4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yn53ysdjI6zjeoFRFsoHyvEwyPZfUwU7I/sfPRzku3/cZq0ZZJDzFzNPsfuG?=
 =?us-ascii?Q?sPwWv/hguZKh6SlMTqwyB3gfYrLIa+5Lro1WYrXDtYjL1OZwq4AEkS+71a+R?=
 =?us-ascii?Q?ylGotz0j0QP26jPAnkbLzWoVGrvGdx/G6FQ6I9B/pSkS2IRyhVJRmq7zPZ0d?=
 =?us-ascii?Q?jtJlfmkMWvRPd6+AT8s8UNt0aBiXpA8piiVuvwRbSZUmMRyy//173gMtVOXs?=
 =?us-ascii?Q?NEO6OmVRHGrD/TgCzRUie6NP30u4w2W99dCYyZEVwZWrQsOqg2AvVzH1pUb/?=
 =?us-ascii?Q?LcKn804gCO6oPHyD1taL1aZS+QvFORIW2UsDcXzMLq0dEFq9hNmklsArNNOj?=
 =?us-ascii?Q?Vi8Pn8Z9FWIMvaG8agxYBd7Xfk0HpgFl4A8hrjqcF5/JulC0eFplQRPtVCbk?=
 =?us-ascii?Q?F4lqE/D5+ArAIl7jOAVkYDe8DFCZr+JwM2viCS8pp47y65PenSO/UebB+VfL?=
 =?us-ascii?Q?sqL5YsNl1cpm/PVpB0qblS2w0DRpxJBH71EGaD3mDcxDZgZ/tPXnA+V2E3gy?=
 =?us-ascii?Q?dr0jfcSMiX8OX6X+/RRrOYNjE8vOVpJqna6E3aaIztKS5dfP7iQkrnyycfnV?=
 =?us-ascii?Q?pPg81+ipRXQtm1Ed3MZk2Rzpq8eKjL+0lt2iPQY3i7YNbeXVyzDeB/YOAmxe?=
 =?us-ascii?Q?ALgEcEBsx3SKFrxoskb/sOnEIYRLW1ReTF97pG4Ozt8BrUSu6cU4ypMOPjHI?=
 =?us-ascii?Q?6uoBH1nh7JD5b0GtcOrK0q0CRfaqhm/qPnsfJhxxzs7KYP7D4eYVjAhM3ClV?=
 =?us-ascii?Q?MTDC2/1gGHPWTMP+S4ATtajEmI9O0PzFzqEp37RRmEB1uEqd8ejULMmArmJW?=
 =?us-ascii?Q?e32LQ9HbPe8Do/peMaxb9y1JrHpAfHzWkJa0bNejTNKbU4rC97YQTI2QUqjw?=
 =?us-ascii?Q?snssV/Xyz0bHKaIEXML6FMZu1511c2yJ6tCWBkAC8zSu8HKiKabQhPDwNhrB?=
 =?us-ascii?Q?ddXriAbMIePV7GMNl0e13C5sftbW22wg1UKWW0y77HyiZ2xo7Y943tGuHPB3?=
 =?us-ascii?Q?1O6wujoxpKuya75MosyR0WEsAPdR5UzrUrpnpnMSy0KkXAQr85C9lWADPD0R?=
 =?us-ascii?Q?xP4C9NIgIuUM/tULlpbLPIVO/Z9nFZk8mJadA8R7vwcTCYBGMrCvVcR8IFcb?=
 =?us-ascii?Q?iApHQkdrbOwxev4iozlX3wKhKtf0kSPMORM2fRb2c5rXUxoH59XAHuFO1VPC?=
 =?us-ascii?Q?9zi3ruwkdvyAUa5CH+wiY4BhwBNiZBK58ZUHtPRxJEa4iQ0SNaSDWlLqJQAJ?=
 =?us-ascii?Q?OuW7HYiOZLu2zNMuIpsAdA/8VFw16t22Hd4kQPQxl2WQKwZHqUVslvmBST/B?=
 =?us-ascii?Q?6pzghdWDQhYYteTUNyXedoT8h9VNFG7AK4YpMd2zb7dHCHm2nMKZEMyBwTRK?=
 =?us-ascii?Q?5nV5mSDXI5rRMKNmW/StBAX/YDnwku76+TymVB7HRnWnU4NK3OcysfFtjjPp?=
 =?us-ascii?Q?pUw4pSAEnSFlhXz6dONXha1xxeP3A4yRrK8wn920bmpEkLu/xR94qF2/Zioy?=
 =?us-ascii?Q?K/JCyaP0qd4YGeeyG3/Z8ttxb2DyA/CJqbCmWD+3TmZ3KiMJ44In8V88dL3x?=
 =?us-ascii?Q?bWEHGsjNnxSid158LNm1vuZEIxKtP+isilcRnEYyOQpmxurxjQui6/xpvNRQ?=
 =?us-ascii?Q?faDyriX/uvxlLoE+00JnnDs4QwBeuvZktQN3AgtqwqyWjyESwzGHP7ORQIYI?=
 =?us-ascii?Q?i7WJUA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z+mWXeaCmYrDLY7tz12hSxlGGXEF+FonNgS6WsJbvRWqtZgbuaHtT36SwMaPg7Yb19TzcoeRlR5kcaGfPMIcngaDvBPkeC98ze0UbXA+0kVKWqj1TdW8e/aUInypDakjpsjyjI5p0dGaMUk8Xrb3lpTrS7JGdquRnRVGcPWdTnF6yyD7DJ6QdaLXxYxCje/x/i/azHdE5RchivmhDAo+jhY2H6TPWWo+rzbCj4avNdyHEsPEKVQNSDzkRjTPoBsML79Ln/JQ3rEdrLy8a5UhnhUxF47V2ynv0fGefLthb4MpsfZpU/3tbfLiQQs6ZypWIy5cUnVg0dp3Z01P9G4HKq10KLahsb6W/OzAGAEy0hsiIyo80mw2BogeNTXYUih+TXhIqSVh8lEym9rT5U5rp9Rr716HsvZq4IjE8+JQ7Cp1WgVvxb6cwvCJX2lEJTYqp/n9VVnQdq0Ho/kg3Ii10wA/TddWlex740Zw0dXpJumIh4ZWK5x3Bubjd4Qz74BsAnsyscrYU7CuBFFaoWf3Qo6QQUKALRhh7KwD56m+cWuCM/myD4yBxHDLMvvFsGhxP3uqF9wJZJvXTZt0O1YLmLQQriMiYj9nyYxfoO4t2kI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 365f1814-f651-4999-6375-08dda9547132
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 01:57:09.9617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SngbEZLMxyU0jy2RrB90ifD2+ZQzkfcUBMXD1vYXUcE20c8Je7etrn5bPogRXeO3IDJxApUbzrw2/uRznVmh+khWxjHiHX0ejqDjmfSBIm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_01,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=910 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120013
X-Authority-Analysis: v=2.4 cv=K4AiHzWI c=1 sm=1 tr=0 ts=684a33fc b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=-IYNSZDYlNDzzX6TvQYA:9 cc=ntf awl=host:14714
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDAxMyBTYWx0ZWRfXy/+6qblrhRKL MmoFt+uCLzL1QoNdELeHysNcvIehiTrr0Vop+FsSpXKICFViPVempfC6RmeMhqv0kmzPRAc+A6C Nc52epgjnQ9IeQPa5kdBQ7m8R4R7iLktwNrx6a4TMRK4zx42LbiTHmD+mFIjBG319g6n7fQrUjZ
 W0JRYIk3ktPpgf0GDjmaBH3/CMXrgdwRUFNzxCGkXKuTZ0KMdKB+K02GDb+VxLtzS3jfE/jJumJ fZWKV56v2gs5ih/cLtnqHUIy3JKkCPQflT8ZBFFdKjjcUI95VyYRslj7aQqTNt5Cl4AS+YwiOoy 3nMXZKli5hJEp6PL7WFqmccmfY8XZWUETsgpuc3KwvCjMUIjARxcNTS80nzquv8F7vTvOzb67Uk
 7iP6biYyziCWd4hMTk2AOTG2KQDVmW6qtZSp2YkoXNwNmEAk9gefVtIxugVAxJD9qaqlFceJ
X-Proofpoint-ORIG-GUID: pav95U-XRDG_gKXXFZfhOK9txcvG5wQd
X-Proofpoint-GUID: pav95U-XRDG_gKXXFZfhOK9txcvG5wQd

Hi all,

This series contains the tests from patch 6 of the previous atomic writes test series.
https://lore.kernel.org/linux-xfs/20250520013400.36830-1-catherine.hoang@oracle.com/

v4 adds more descriptive commit messages. No functional changes since v3.
This series is based on for-next at the time of sending.

Catherine Hoang (3):
  common/atomicwrites: add helper for multi block atomic writes
  generic: various atomic write tests with hardware and scsi_debug
  xfs: more multi-block atomic writes tests

 common/atomicwrites    |  31 ++++++++++
 tests/generic/1222     |  89 ++++++++++++++++++++++++++++
 tests/generic/1222.out |  10 ++++
 tests/generic/1223     |  67 +++++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     |  86 +++++++++++++++++++++++++++
 tests/generic/1224.out |  16 ++++++
 tests/generic/1225     | 128 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1225.out |  21 +++++++
 tests/xfs/1216         |  68 ++++++++++++++++++++++
 tests/xfs/1216.out     |   9 +++
 tests/xfs/1217         |  71 +++++++++++++++++++++++
 tests/xfs/1217.out     |   3 +
 tests/xfs/1218         |  60 +++++++++++++++++++
 tests/xfs/1218.out     |  15 +++++
 15 files changed, 683 insertions(+)
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100755 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100755 tests/generic/1225
 create mode 100644 tests/generic/1225.out
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100755 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

-- 
2.34.1

