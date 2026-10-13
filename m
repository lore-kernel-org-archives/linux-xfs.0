Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9676C442B06;
	Tue, 13 Oct 2026 09:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884369; cv=fail; b=OminUHJXucRy6rYsffpfoJ1Rfn2xFOGA0Gmy5yDu8fifisqNcYPYG0pb9Y3aab2SnylxFR3fq9eQxu9sgsNCggQNf7/gN2+aTRV7DUPnz60vXMENFPzQLz0FPSYc6LJ0SsLvcCPQkzAXEjchXfvUnVz7zV+Ef9uGXr4wxkL9V24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884369; c=relaxed/simple;
	bh=cgCLEnL+WmgQyXi8XZx1/Qs7yfjcZxr3JO6rTPmt+Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fupo66eYzSoO9TcPUhSlwKreD9WkkkuOhYqypJQX1pqRje2zuI6ZG1jlVvsRAK+sA5JD9rkUiggqVaxmNWxkmQHueWGMpt+MMr7Q6BWktmjQvmDvaB90XDzQ4o5D1xdvbjq8k9RP583mVN5B5WW/YZ2VYAjjY4UBcCAI9o4hPIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VvShAhuH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J+O87P++; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VvShAhuH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J+O87P++"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CSVe4061657;
	Tue, 13 Oct 2026 09:39:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7HbwMLJQmB4ZVegqluQgLTHPltUqbZKMXAttcPmp85c=; b=
	VvShAhuHiQPRE/s8TH21dHyh0LUgGlo9CHdP+8aseKNr/Ox1j0UUGKPb13pcE1wB
	RrUHDFdfBSaNB34NY8uou+GPrjfQ5m8mtI1a+B3GeARD1Y73Ax7pWhdHwXKOTdrL
	4hvLm5p9Dx5liyIXLi6BzNpCGPt/2FFYBkSfBul8PkxQ+uGns+gThXHJSZlW41Nt
	rpWoUs0MO4BdBzSS+RqH6hHMu8xaJsQJHa4m//5owJQRj6+5lTgJZ5LcPUNgrj5K
	mt/aCBU+xDS4w6WUFFZmvJos2BvLjx9KUFBAnv8jjqSYIowJiCGxGcbaZ97NqJaf
	ZkKjJm0a41hPmFGjOpcZgQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkq7d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:39:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9ajhQ018268;
	Tue, 13 Oct 2026 09:39:22 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011051.outbound.protection.outlook.com [52.101.52.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp9u2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:39:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QYdQAF/MdngPU50nIO+zKFVrlURlVxQyJYNgZoPcaosrcRm/KPbLS5/ayNCoyAluvq8KNylINy4hhmn4HheUJZe5KxvH6ropNqysZp6ge+vtgRMjhS4i3F/WHxnH+iyQbH04Y0/j0XLVG9t3p4MS2MaYjz49rRWo50R0Ga9bwK8AF2hxBsG+fZQzlr6qU0xFalbWvG7FM+pWD3kuxbTzp0c0OpEI4e6fPHg9WHJ5zMtGX+vqWwC1jRKJwViwqikQZIQ1SDEd9qMyPrpIY8F+4Ny3YrY6Zz/+aeIUzRMRjEGYvOEqNmdaNgWOgrcz4ZXSwGIDoPhS8e9hUhaOfJ5aGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7HbwMLJQmB4ZVegqluQgLTHPltUqbZKMXAttcPmp85c=;
 b=V0CG0A6L3VTP4vi+/2smZVeMKK5NhlypJlv2S2rtUY/7nrgDEtATcE8FobEcPpWrpW/5myj2JG9JN25C3Nr4cpm7ce5lTfuLE8MD/w33HxrWAPspe1i0+SoTpDvzERch1GNG5+N1M7vX0AKHMHIPBPP/RUP7xEp5MJ3DtDY8JTykJ/kpD6krjDh+fGJ5Elo5jOkf6zhuRgPZ+oxIam1NLt7SJ9zdBGa3AxDpF9O9zcJUWGWKbdOgt43WgNEu3dGSisRRkghqZms6S3x3UjS+lFCTwATDSRkzt4J9WY8/laQYvbPJgSjHgRXUzwrmaz824yxIx97bgnEX5bdEgdA7sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HbwMLJQmB4ZVegqluQgLTHPltUqbZKMXAttcPmp85c=;
 b=J+O87P++cIkrBpGp8+xU51HZrTQaIEQ6W503mORihLF3pP2e7dXOjlpQ6mu/u0GXvw70padfkyvV/5IC/UUWRbLOQgU7pdbWPql/9p5hjpYIUoN1Qb+hxnfhs/sqcX5HqBXXg+lcBFh1LadB6S0CIOOkStLmYkYNd/haFSNjBug=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH0PR10MB4987.namprd10.prod.outlook.com (2603:10b6:610:c1::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:39:18 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:39:18 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.15 v2 3/9] xfs: fix super block buf log item UAF during force shutdown
Date: Tue, 13 Oct 2026 15:08:54 +0530
Message-ID: <a32850e5f8c70d5d5c9952694f70179c3c42de0f.1791883296.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883295.git.siddh.raman.pant@oracle.com>
References: <cover.1791883295.git.siddh.raman.pant@oracle.com>
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
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH0PR10MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: f0f25333-615d-4350-003d-08df290dda0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|23010399003|56012099006|22082099003|18002099003|6133799003|260925021311599003|260925021911599003|260925022911599003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	lw4qtmML62S+b6CcqBy0zX+788zaiVfELytDdBPFQ3lj1Fkp4Qvg8QpvwgyPYFPA2C7uOeo5/zNTFltqKeyRR6qJrFln9XkEWi7zRw/8MUp3dVoxmoM3vAjtGZqQFShxo389c4ZLuxrOcvlQmVZkI+Ie8yfg3Y9dyRLnb3GAJXe2i33jYUl3T+38vPU9gUIVYqI1tfW4RIBmkK3EOxTwI+ZdnVS1QYAMynloa6Z+KinyRMQQWuuL9M7J7rsboDUFf3fh3cRsCGPcEUE3XuZRffLzgJFmcQvAWzPxYIy6+LUgh84TsQp51wabYumkv39txtPdBH6Y2l42GXUZy67q+93qRgY6X57lfnlmSlpJSvMX9f1Vl16cnPLAidIphXq/p6N3UldLEUi5mVO1Pc2PbhtgUBRGlw8NMHtdrClnRAnvd2Vrq4w20nJzoi8otswAqoJS5vjP1E1+ceMPLZEJ/MHbOe4mtdNz8zQi8oCkiP7DzF8+kXFBNJ+gwsvbjYTpyNrTF7ax/Uu10wqEEwGliOG5D2mGJRVVzlplnMXAmYMkF8IZi4SaD/ONjTadbBKpbYR3Cq6J4Zo3tZQFoP0sOXhji8k4Ovz38eKnIWV43uYN19PPq6Di4Y+uLL7stnPhQ9YuFPHzqbJYAlTdcJaGDJfYWiBNh0HJOBOuqe4SY9c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(23010399003)(56012099006)(22082099003)(18002099003)(6133799003)(260925021311599003)(260925021911599003)(260925022911599003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5gsn9ILq0JNjNq9zSIhbtuCFa43Nq1nyRPb2orGL8l7EATd+fLmIO2eQBmjx?=
 =?us-ascii?Q?a9W4JvXp4FYjxkvsbclr/Z2l6LHQ3LeTeDJ7pMBStaVF1M76g/XgvUUGd52o?=
 =?us-ascii?Q?v9aqe+36Vq5bGmp2NcPZFQuNMpNemnsKojNTbq41DE5ciGO86THMieR7HyAB?=
 =?us-ascii?Q?pmgkZUWYjTIuIKjxXAt3VA2se1j/f65p+Lnlp906PFesP2P0veEj3MT99Mu0?=
 =?us-ascii?Q?mWNKde5ACxUNYg4blcW2QQaelG3pneTFUHT9uTZrRqxNzv8ZUUGOHU3BRW0v?=
 =?us-ascii?Q?7OE6TxV+YSjQ2DHgILmbmYsE9kt1G8G36eY6T1SQSUGjasG1BzsCCGE7AK/C?=
 =?us-ascii?Q?ixQ3tMWZd9WJyVowZmiQ1UagWJZf1vtE4gDcC3VmFFLDODdMKEI0nqrD/iI0?=
 =?us-ascii?Q?neJqPpNpFZ87CHzMhJGhJrO6GA0T+9ZfYevDDo1B1c8F82iX/qY7T0Vz9iAD?=
 =?us-ascii?Q?VAM9cMIflIA4CBnyBNPxU/QVdPXs/ogSLwB/9nbaGkYC7IwPNlV9bTDTJaqO?=
 =?us-ascii?Q?N8igSIYLgk+5D4+IE7UQy+hi7yA5TTUEJecsHGRGlkzq8vLbBH4eazMFOcBc?=
 =?us-ascii?Q?w1h/6p028LC8UJAOVSA3B2Sr8JwjAoWovodqANb3fHBKb9T4H62Z9SE01b7M?=
 =?us-ascii?Q?LupZbAhgB1//XiH8oYpSGFnMUXfmSWCYhOfXxXG6dja6IU9dIR5MFPv+oABR?=
 =?us-ascii?Q?yVD1z+gjPRMyFZSKVlSmnURAr3JsWNU1r+Tm2+2FXrj8VzNJ8xdPiRGqL0dX?=
 =?us-ascii?Q?8PH+SipehhZ7aGVO7mW/hD7nP3SghsiCMFo/6KA9yoc2pccir6pQZvYym2rW?=
 =?us-ascii?Q?OsZrL7sw1GiU2P+4MJ7YoGmHI5Glj2PGmAgnkbIaLfD6oW7ZB/M7HAt19xq0?=
 =?us-ascii?Q?wWJpiDU68pz4toZqTlg3iGqKwWYAjYRFyrfZxJzRAvXkwxQzM0mYBaL1qbJ/?=
 =?us-ascii?Q?LMqG9dSAiDcYfZuiar2vmxyKsWhlYj2WIXXq4ccKHkHOtPm/QKdn/JwvF4Cj?=
 =?us-ascii?Q?37PDYCqTxzbM0TbrAVzF3STSypA4RXsctSqlGi7AzubX83JvxieCtTPVdu9v?=
 =?us-ascii?Q?PIKEoJ0jUX5f3PXo/ny4zt9QheRHATFZwTyhAl8VUuWSwV9JFnaduGoORdvC?=
 =?us-ascii?Q?ASi49vaQSgK4LzfJFtc0TPoqo+IiCc6ZdCCL+ReKusgMYD9HXxGa3x8aicXB?=
 =?us-ascii?Q?AGxXM9oroFFt5v3odPf+WxslHYv7XZrK5z5lyyLnRWNaMJKXV/7Yn4cZo4EN?=
 =?us-ascii?Q?w8dwZfdIJ7MZvjDwPeP3uLjx2YryvzAdX8BitV6XjBLLKzMuvkMeMsOJU8ca?=
 =?us-ascii?Q?cPvh3JPEh89ez91DD39PTL3IfYzhmDI55TO5rCl+3klbXrSn+vJX1U6c/Kqi?=
 =?us-ascii?Q?gbqvbszKnFYuuYcaC8DrulBOSrhpvJtBi4RFPheMemrYECgfoI3rfOGJVic8?=
 =?us-ascii?Q?9dP0QF5wfnTdq2WDkzGrMdvcUmcVyHPMoUEWGx67cnkXBkASMFzyejheg5fT?=
 =?us-ascii?Q?t9DVJCG06PFXTg+5FsyE8IBt4v279jaj0n+j/QfJasCol/GyzAdD16IsJpAl?=
 =?us-ascii?Q?kJTkviQoZ4a8P42i6NUNIhX6ZvCWCviEvj6N+qM+263rr1yQhfyfigqAdlNh?=
 =?us-ascii?Q?aghvbcIF8Az9iOElv4HzYWA5gw9KfrVizjWnGsbl3Lvtoznpz77kBgFG5lQ/?=
 =?us-ascii?Q?3i335OXy8hHaDPUrFKy8YZYRThNzQm3agdz5Tp3mehZPuKLFu19Jy+Dz8pr6?=
 =?us-ascii?Q?YTz54okyf1d07CYCb4IkHb/+hPMxnA80bPt2VN84phMEYy/u+ci/4YmyENt8?=
X-MS-Exchange-AntiSpam-MessageData-1: FepW2GG2AtvkE9hfVeQS3TJRUJcxU7OBPpw=
X-Exchange-RoutingPolicyChecked:
	BrhjdIzTRZYY2lS78T8Kll9WTDrXpItgVU3tD2FgwhhfoUL7aIrrFq5umIlfmG+fXVQYjfLxnM4uzbW56CQDMxp99uaEIATrQr6dTOrWY8qYheoIubi5R0BuSOpS9OCFEN0A0DatsAKZrIVc1JlKAqd8XAHy9tdq66QSacP0d5ARKUV/ALIbHGeGj+YKMxMyOIYMen3G492yMIbVYZO5JuJunKwoZqAuPxFIpQVk3/6fsHv4O2RgPKJPyck/i03yaKzHv5gFcvY8c1LVodN7WdRv9Mw3cIkML9n7g6FEt58ekcl6ZXHRfltpUWZhRp/uHwPCNSGC2cCJYJSY1cKa5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LcS3eKPYXemzBFgW9j+fLXFSokCnYobOtQbOiSs1pYWmqMP4TW0EhRK1Fgj4Lrx/FMKxiLgWN+tatVFV7HkQRS67HHIwbmsdNPhtBkoVpQzPIqJscJemEEYrexWqJyg1gbIFkRibOUMVevsC3jbfJ4FIt4u0iYDGoZTwVtAuvT8Yg7Fw+mLbhAEAr/+DcYY7OfMWd+819ZCJp8iYDFPe6fvFh2MvWpQCUQXLZIoPth1FWYpV3jgRHp/NXofz4U5j/RiiRrX+dTLPNMYIixBkT7YDLACCcGWPBITtNjHFYpqbPwd7LWIh9+7Ff/l7J8FmzSmVzwRyNNr8kDE4C9FP3uyN0HmH5J3/tG16xc8EpBbDwIJcQk6NYPAVWkAt3ARHimZNZIKYsvjGA5lfd/00gchwRBjrcfgQTk+72fxLs/G4ggn0kRElEcFAm3JtRNrORTvcH0mwCieVU9O6f3LBm2n12dcbNSa+bUbaYIidFSb8opcuoThozf2N5sFxB2HFs4wJzk7Apww42VDeUrziufFG43mnWZLZ3qN0F2Gady+4JkPc+edLiQ86Z7hCuT1Lqnj1xXJ7fHze2poeNS84LUPJnolrrDOAKasHP3bWmUE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f25333-615d-4350-003d-08df290dda0b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:39:18.0351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eL+cvIsFtwdWduz5+FveM1LkhkU8wulA92pKqwLRQohs9bpzf7JeKqhMBcca428UV8D7EEieemRGDWo5OKXavwlquLjEGAbOI+tfW2mHo0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acdfc4b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=ag1SF4gXAAAA:8 a=yPCof4ZbAAAA:8 a=X1hi7w48wxXEZvHpCekA:9
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-GUID: pOoZ5UhTwvlEcmdqFHfl6hE1yZnM3Nyz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX6hMVBCA+lNSD
 g936S8AN5Zq8bjlG2mhws7q76uZ+qIPTpfve1wDzF3kOffSmik51CHuWO+hzzCFyB8hWmylXeMW
 ERPr4Tg7zNJwUbKdqm5jf/u9xgdK5PW/JlyyXUOK1BfaQyixjnjLUbURbAjNTXd3FrL1dTCZu8M
 jZnkbwUAL4t8DXBdSApjjJIkhAk4SP58xxYukpuP1Rz57lT7jGvIMFdqK/a8+W1WxuAzMPH8NGC
 T1IOd+tu62n2VUocDF4jXQ0YFN55tO/rMzm27NsV8q2x33cuDEfvevNVlblCO/FRe+jh38v36lY
 7HBTLCCWmmsfLVHx1VbisGgqrlP/2cS7bOc7tBMvDfJZfULN+tmjUrt5cmlmNjDMKI2q37uWU5n
 OZomE6f7algY7pX5zU+xNRaP9D9+DR8BlRnVYM37Yj2sBzU74zaMzZ7RdDWMQCiUFDB11lR0Fxp
 JdLHT7tOvqVp2EeYCd2on/MtVHLC4PDsFFIxsX3g=
X-Proofpoint-ORIG-GUID: pOoZ5UhTwvlEcmdqFHfl6hE1yZnM3Nyz
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX/zLA70b4Bwqu
 PNwjUEHWmtwjUa8XofKU7EL9thbvrWurEj1jV9s3b/H90gjsc66GcwmniEONgNaR6RMJRkGgqRK
 L4C2dfLbNc4BIKyHLi5NMWTJS1UMRHgFU8jtJ9aIupOPS9BiThWD

From: Guo Xuenan <guoxuenan@huawei.com>

[ Upstream commit 575689fc0ffa6c4bb4e72fd18e31a6525a6124e0 ]

xfs log io error will trigger xlog shut down, and end_io worker call
xlog_state_shutdown_callbacks to unpin and release the buf log item.
The race condition is that when there are some thread doing transaction
commit and happened not to be intercepted by xlog_is_shutdown, then,
these log item will be insert into CIL, when unpin and release these
buf log item, UAF will occur. BTW, add delay before `xlog_cil_commit`
can increase recurrence probability.

The following call graph actually encountered this bad situation.
fsstress                    io end worker kworker/0:1H-216
                            xlog_ioend_work
                              ->xlog_force_shutdown
                                ->xlog_state_shutdown_callbacks
                                  ->xlog_cil_process_committed
                                    ->xlog_cil_committed
                                      ->xfs_trans_committed_bulk
->xfs_trans_apply_sb_deltas             ->li_ops->iop_unpin(lip, 1);
  ->xfs_trans_getsb
    ->_xfs_trans_bjoin
      ->xfs_buf_item_init
        ->if (bip) { return 0;} //relog
->xlog_cil_commit
  ->xlog_cil_insert_items //insert into CIL
                                           ->xfs_buf_ioend_fail(bp);
                                             ->xfs_buf_ioend
                                               ->xfs_buf_item_done
                                                 ->xfs_buf_item_relse
                                                   ->xfs_buf_item_free

when cil push worker gather percpu cil and insert super block buf log item
into ctx->log_items then uaf occurs.

==================================================================
BUG: KASAN: use-after-free in xlog_cil_push_work+0x1c8f/0x22f0
Write of size 8 at addr ffff88801800f3f0 by task kworker/u4:4/105

CPU: 0 PID: 105 Comm: kworker/u4:4 Tainted: G W
6.1.0-rc1-00001-g274115149b42 #136
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: xfs-cil/sda xlog_cil_push_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x4d/0x66
 print_report+0x171/0x4a6
 kasan_report+0xb3/0x130
 xlog_cil_push_work+0x1c8f/0x22f0
 process_one_work+0x6f9/0xf70
 worker_thread+0x578/0xf30
 kthread+0x28c/0x330
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 2145:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 __kasan_slab_alloc+0x54/0x60
 kmem_cache_alloc+0x14a/0x510
 xfs_buf_item_init+0x160/0x6d0
 _xfs_trans_bjoin+0x7f/0x2e0
 xfs_trans_getsb+0xb6/0x3f0
 xfs_trans_apply_sb_deltas+0x1f/0x8c0
 __xfs_trans_commit+0xa25/0xe10
 xfs_symlink+0xe23/0x1660
 xfs_vn_symlink+0x157/0x280
 vfs_symlink+0x491/0x790
 do_symlinkat+0x128/0x220
 __x64_sys_symlink+0x7a/0x90
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 216:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x40
 __kasan_slab_free+0x105/0x1a0
 kmem_cache_free+0xb6/0x460
 xfs_buf_ioend+0x1e9/0x11f0
 xfs_buf_item_unpin+0x3d6/0x840
 xfs_trans_committed_bulk+0x4c2/0x7c0
 xlog_cil_committed+0xab6/0xfb0
 xlog_cil_process_committed+0x117/0x1e0
 xlog_state_shutdown_callbacks+0x208/0x440
 xlog_force_shutdown+0x1b3/0x3a0
 xlog_ioend_work+0xef/0x1d0
 process_one_work+0x6f9/0xf70
 worker_thread+0x578/0xf30
 kthread+0x28c/0x330
 ret_from_fork+0x1f/0x30

The buggy address belongs to the object at ffff88801800f388
 which belongs to the cache xfs_buf_item of size 272
The buggy address is located 104 bytes inside of
 272-byte region [ffff88801800f388, ffff88801800f498)

The buggy address belongs to the physical page:
page:ffffea0000600380 refcount:1 mapcount:0 mapping:0000000000000000
index:0xffff88801800f208 pfn:0x1800e
head:ffffea0000600380 order:1 compound_mapcount:0 compound_pincount:0
flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 001fffff80010200 ffffea0000699788 ffff88801319db50 ffff88800fb50640
raw: ffff88801800f208 000000000015000a 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801800f280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801800f300: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801800f380: fc fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff88801800f400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801800f480: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
Disabling lock debugging due to kernel taint

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 0d889ae85fcf0cf9bc6e998fca2ec760e08e0b46)
Stable-dep-of: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 5eb6d787ed4e..065bbf03c7b0 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1019,6 +1019,8 @@ xfs_buf_item_relse(
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
 	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
 
+	if (atomic_read(&bip->bli_refcount))
+		return;
 	bp->b_log_item = NULL;
 	xfs_buf_rele(bp);
 	xfs_buf_item_free(bip);
-- 
2.53.0

