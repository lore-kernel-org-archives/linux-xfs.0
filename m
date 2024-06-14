Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58F0183071
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718329799; cv=fail; b=p9jB31cxcsM++OweUilf/zrEVIXN1LdhkXa0FgnUiIHzANZrYjf00iwQ2QvfwT0eWoKu6DY6kDxn12g3nYPQCXlR7xV1P9BIpjMWskkVpqsNFleFmex9e7jscmpW0rPSOSYY4DV45skl93ci/4uwsUFBp+TyLSD44teY2ge8syE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718329799; c=relaxed/simple;
	bh=wzbFtF929EmOpL3R7A4y94DuxhaM70xBH1qOc1UHGuU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PKQg0+ZMR8vdNzRKZgCqmLF/MGxGmf3XnlwsE9HI++uyI3frZsxsq/vvharbPQo6dfrv7uHKMWo2cUW4sH2rJ6JcxGET8VFWfWDfHmq2mTdnlEFt8tJzc76R193oF5+RW7Rn27rAT/xQxyuOMFtwOv2TV7+72Ep8tUwGR4ZGPrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QyoLJj6q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GXpbfVg4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QyoLJj6q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GXpbfVg4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1gB54010532
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=vB2FtZhWSXYF6eXYBwhRuPML8GvZWdeFCFMjHI24LB0=; b=
	QyoLJj6q3AKgw3MKQ6L9+idRA+1eHJZOKmbs4sRo8bd2B7OAP9msBH9yz17ArnxN
	D6l3YSGSqWbS+JTMlij5ZoCr5xHFVDqE/WVYxixrDZexA+oIYmqwkqOoG3Im8fEb
	sQwK0kz08JgvrSvjNEBLr/DfqbQfFGPiwOdIVmTHGue9l405N4ZFkDajXV8AX8PT
	Cew4KdhHaH09C0pTya2zmwVupPoX0h9hla+E1Jo8vkRFTSYFWBsI4g/vzzxMgdKi
	EY99uMcW6OrFrd+UC2wddWt3T7ptiRy6A3+NtyMRswXs1zkGbMtD2gKB/XR9yayt
	RuDds5EOENncJnxGbBBhgA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh19aq6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45E00CkM020262
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync91ytw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISqm31l2Mns3ANbZTuGqnTS572AugsB+oFLzzcFtC1A5liGNJUZG9BEFGVYr+rFA7oKN40yS2YmlIkgV+SbahEdDemAoY1fDkbsCmCLrnDAh1HeuBKai6nT8vPP/uWKU44mRKA4hkQhVQg6qcuOfgfO0ivbZ5oFucI253YKVI3+v5zaOikSaSeQJdLiAAuPYRp/FeQlYbF8y0WCVvKdsFvUHBLVvXRydNJGRVQnCr2upgPdkBFof1Ozua3f6ZzaaLRJaC1c87Ov4/C0v7g5CDgBJVZbIzU0KuBbNBc/6Jttr+GTP7QS6XzrOqZRPPB3HBMXUQ5b8qbs4uuR7pfVY8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vB2FtZhWSXYF6eXYBwhRuPML8GvZWdeFCFMjHI24LB0=;
 b=QAJXFPHmisbODjos5xEaYy+Lc4T9cANv8VAX4oc2p1eorN9jb48fYXP+7icSBNNuYF7UpSp/CMqollfMKfMUynYke7iEgdTvMAAc13a12wLagOpK3tu4xs7W0wHbT4Cp8tk/eeG+0dcIp4N/SOYrDDXmlVJDWQ9gLeOByu7nvQ1hsYpSCAMjj5RSdiKUUa6AJdUUhqwOYilVKayU0zYnb8n6vl/9w6WTswGE1NkaCs/+2Z99fDbE6D4fVer5CfPOXJXFpqBoOxtnVfoxEuy73bhXnSI3NeNYCBWBCX/phWqGizm3EKXvswNz5A47bv59VGMeypR+D0wIBbQ5ViFnIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vB2FtZhWSXYF6eXYBwhRuPML8GvZWdeFCFMjHI24LB0=;
 b=GXpbfVg4298W2XLN5WTlbfQKwY9OxOU+ASk5r+Wm/zIZEBo4S3gqHB+b5ps5di/JDTpnnP5fNik6nFvI2GqvefR5lJBl5X8NyssvgF61SwVymJ/EnekWD1QSPT6pUpqPJjX2dtipaeziYvCuy/Bg/LXNq3+C3nVyDwAaqmqjQJQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7475.namprd10.prod.outlook.com (2603:10b6:8:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 01:49:53 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 01:49:53 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 1/8] xfs: fix imprecise logic in xchk_btree_check_block_owner
Date: Thu, 13 Jun 2024 18:49:39 -0700
Message-Id: <20240614014946.43237-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240614014946.43237-1-catherine.hoang@oracle.com>
References: <20240614014946.43237-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: 90b2368d-58e2-4d64-2df4-08dc8c144912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?6OJLW3kVPWjo8/ksvkJF1vYfsFrkF3wFczD3qPUjZl8X0KPjdqBSI0NiBSUC?=
 =?us-ascii?Q?OW+I4HO7xmfP3ldU5lLnQ+2Wj3PpVUMMrBNkrPn4gueNbe9LqtvmR59mFIpm?=
 =?us-ascii?Q?vOrb+ZvlVgFxlqVw+frKbWE/reb+nXHo4ypMqFhbotes4icNGm7sxrgRDx28?=
 =?us-ascii?Q?nXIQaXvPEYI/UqRAkCgQiH2//TqcHLGirv3kwBF0zoK4x07o7EZQM6QKf5r+?=
 =?us-ascii?Q?SFlO9OivJvJaQ/qBorBhMhuL75WwXxWgtPfObruIxtJgUxyTgEuHeauz8Eqv?=
 =?us-ascii?Q?qujmv0GZq4NLU+lySGymESbvDU0jsH+rHMu6XLWhMPDAupvqFBhodA9VFwip?=
 =?us-ascii?Q?jhpwkTZtNPGn/Ajx9ChXWKJfGwSx8dsPImBzkZO9J4WtgrDpFZWgUmwoTnuV?=
 =?us-ascii?Q?lWX4+l3AAt/cn8enDDy540iYp/LoLXTeEuBDt4vUX+lidofe4SNAUHt0DqRK?=
 =?us-ascii?Q?P/80EByxUHSMIwkyzdv2lK4wSNU6ggtdoNQVI+QjkrdH0p8RLRcQe2a1Ptgl?=
 =?us-ascii?Q?PFU/XCtJoK6RRbmzbyyHzfoXi0FlOkSRbHPrTK9LdMc8erIzulc5L6ngTGUc?=
 =?us-ascii?Q?OY7cUq08Rf28hja8MMQjlNBvRCOw/cusUQWyzDjYb5kWFY7zHOa9UwI1u8hA?=
 =?us-ascii?Q?3f6QSo9sQ5PwqL9oPTgOSg3xf3KxDHifV7MiLD5NbUWiObovqp3WQMPacyIg?=
 =?us-ascii?Q?el3Uan0ZQjn5wllMj1zX4zFYiVFojuA3nGU636eMKdcGzVqcIR/GELpsoL9/?=
 =?us-ascii?Q?HlqX3bP0JvEVdGH+5Zq8R4bl85fjwqJydVD0vbl23xssvZdvb/5Cgao/fLRN?=
 =?us-ascii?Q?UsmcfIqUmKt5IHUbgt8/R/jpjTT0FMUYUZQtco59g1ZiWHXzhjiTIO+xjtC6?=
 =?us-ascii?Q?GI391ctsj2BPXXE7IeBLu0B9mQeu2zzoXlx76Yq2yr5e1RWtUTigdXn/Omih?=
 =?us-ascii?Q?1l/MMERibZU6ez1XQC4ZOT06wJt0K3UUbrvXtu3ehAmb+LGZyfdilvq6nrf0?=
 =?us-ascii?Q?OHdQ1jmqDaCpqjuHZKKaghvBQsETZfaq5uReUA+OVReGLP4zI/hWRoJC2Ea2?=
 =?us-ascii?Q?ZQUg+RS2PFKmTe+7PU2eb4Kj3yC7GlNt3LKyLSXiOKoRK4REDDIxWbVPmq7s?=
 =?us-ascii?Q?b9duJfVTMTs2WBhbZ718Cf66I1lNGwHUvQJOxGygcsSc8bjTnrwYIKhlzwl4?=
 =?us-ascii?Q?UfRwsWOdDdBKnt4ytaXxT1CxTVIUNFP5vGIsHVfE6TSHO45Xk/8gJ188kkEI?=
 =?us-ascii?Q?BnimPut8jWrPVQVSEXrx7aLdo/Mqp5TfPWascL0RlHqhJ6x7FLxQ3Sh9nFTM?=
 =?us-ascii?Q?hLmXdC9xDjojPTOXxDpz81Wd?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4MLVrmH1QuDWesBGSNaMN+ifKu5BOg3drrHTvs6M/Tx6zCQpJStEL+X9VJlZ?=
 =?us-ascii?Q?uKeyTEh8sgEy1kw5WZ27VObjIUQZIxVOizY7YSxnMgEGyV7panMwWapEPIuI?=
 =?us-ascii?Q?mIE6ebrsaJgSMdIClPGOjo12hzy1EcGrkFr47dX1RWAwdqkAnoZeAjNK9/i6?=
 =?us-ascii?Q?KYfuoL761kWTXM0KzCCVj4TBdWuhQltR35gGafV1EBhxDFRKQrUOfN4HNnXD?=
 =?us-ascii?Q?0e+MzB3IN6YWFbhzAUrRzZ4ukijTPxSUrcH3fCsByAL6J2zGpOqkNHLPKXho?=
 =?us-ascii?Q?XL3MEks9E0D+jscdeXUqO3PaeKYXisH68438TcOhhhgZWk+7c1HpzTnson5I?=
 =?us-ascii?Q?bsALu/xLevVRgJRWRHqwDYw5FOuENwWUg3NZmlKY8zzKBbSoxUWLvp+Jycb8?=
 =?us-ascii?Q?040A/dRP+4BRqR9X80gB37ZuUqqJ/mrEylWv6C/JUXab6KOySzpdMgMwCi4I?=
 =?us-ascii?Q?/Ggb7oY3UYcPXa1xAhFzJDdo5nnxAd4p190sKNCO/QmAgPBcpLtlKZ0NaTPb?=
 =?us-ascii?Q?3uiwyUIqCWVNhOmb+LygfZJRiWOLNS/GALIx1pMBuqThATMTc9280PhoxFD0?=
 =?us-ascii?Q?nb+VaQuEW4OQtfCQgP4eQLL0L2QKbkTIqZixwsBsBLpKZkZkKlj73vbOXxUs?=
 =?us-ascii?Q?FDQRIC6k1Gdup7CChGy/lStEGPLJVDCT+D5Ziap7M93BalfRbk2uj8S2SBYl?=
 =?us-ascii?Q?SoRirdznSWYJNgpNE5InkJK2Ox0BKpu4xH15y1Nd1Nwjd9zY0IuuYK/RPPVo?=
 =?us-ascii?Q?2F7DU4unM2E4Z4uaJ8KSGL6BiJJ90h2152YG1mEJdpGj78kdlvSN3ktOH9AB?=
 =?us-ascii?Q?511XYkDYm2032SUfyTT5U0dmHjFNCqFBsqK7M1tp8/zfM6k0DGLMoYPb2JQv?=
 =?us-ascii?Q?SN00DcV9/buoR7qXJc9+qes7e43p5uqAgaDg+/Dm3fZFmBVcqZmMOILF3WpS?=
 =?us-ascii?Q?1X+3TN9Xj6+S9WuiYd86N0cApxdRJEDO2AR2S4ZDLlDAAR1xJo4af3ce4Uab?=
 =?us-ascii?Q?hmKDCEmuO+s1Uy0ClSmJxUEfEVrqvCCYJfCuqeOK6uBIEVA6eBvTYOaLHHa/?=
 =?us-ascii?Q?B9PGjqJ3I7ZLnbI7YR33OojsxxoPstlZe3NqfMJ4l/BFnRM5ivDq1aifNCe+?=
 =?us-ascii?Q?BrDvskAZwgipGgxOELCSeBGW81+wYPPBPdtiJ8dORwXwNZXOir1mS8xrBgCm?=
 =?us-ascii?Q?z/QBUZT25V9aeAhciPulCfKGvHeHeifdrNUGHjBdYYf8NKEz4uncKl1MtA21?=
 =?us-ascii?Q?UZhZsTuTvntnU6hiwSwmRX/yh4BfDWeOUQiOU4038eYpafn7cdfO0iMiSlJe?=
 =?us-ascii?Q?DGA35V5ts1lgVACHcXH7tfKfrltmZzgs+2K9co4RTTCyA44LHVPKJ6CczKCC?=
 =?us-ascii?Q?1RL81Jkdcg1UBOzdE9lIUgWA7jZ0yxeSKqh/qHGKhcGgqN5L1YC9MrrHXVZD?=
 =?us-ascii?Q?nVSIO9FU80ClXycsW5vQfB3gTpB1JehrTr8hQLGEiNdtJnc1hWb06g9eTpje?=
 =?us-ascii?Q?n+SlF2lJb9ELFL1R25wvERpK7MnwsfCE6vNlWVrWeAVKQw/LBva9mR4a+Xdf?=
 =?us-ascii?Q?Ru6PDIEP0G1tTJi0V1StYsuJZmtLc2aUaoKHYDti0QR0NtXyJCpDAbYxyNAy?=
 =?us-ascii?Q?2bMLsVYog2ai8h61JFhnRDpQJwkFdLxbR1WqMg3zoLn2G0OtzQlIMk77m19P?=
 =?us-ascii?Q?usgVRw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8NwtfhB+Xc5NrEnZYCHo3xp1eK6uM63IktnBGZhXmE0a5DYkSyxxPzCZ3cOArW9CxkWptwJEoR79tVqfbrPUsl2q6DheSIeorTbEkl+1h1flBVTrnH+tMu1yMl6XLyfCfZx2Fw22di081XZfjhLTqQWIo5r0xkSVeLsc4U4QSkYA/UZUZ3LlLC+L9gsMTZcCu7utjCj2yv4QT9jalkJXN4avNaNgH2lg4CMYxRTcd1iLY8aUByh05p4nK2aJTziwpZebK7XtcI41XrtE7pPRTy7Zk6pePdWZyjTNMvm2ycnX1Q4O4fjwp5aNfnLy7UlLyjPGFvVDBLQXuA2PwbpuhbURAnGsXSPYLAFK8hRKSBRkVvAs32vAg/8SjWlf/stAludgvZUn0jtsltqxUiyASbG3gkAdzIzi1cCFvQu+AkxIhNH9oujC8dI89o512/axtHfTRdySxxjgxeEGd5umJ3VZx72E4sJRuckfQVAeMcs7jZu1AzKvqvtKXu6boXecZII9oHI3dZoZLR1v0Az8B10zTXl2ddk489ZEUF9urHPBpPt8sr8xlcpa95yoEPr59iNdQBIcVWasQr1C0YdD6dmCKaMAqcczh2FF+Mpct+Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b2368d-58e2-4d64-2df4-08dc8c144912
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 01:49:53.4382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Vq+m7FEImjh4mSOOhF5HA0il7vwgf03ZTU0flSfOBoTDfbo1guE4WYJBjXRW+bvxKEXTOe2DJsviDNhiufHUI3bLQaBycxsmhIK2sBjRN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140009
X-Proofpoint-GUID: qjO8BYw5raWsYzWtKPD20sFHkyF8lQTx
X-Proofpoint-ORIG-GUID: qjO8BYw5raWsYzWtKPD20sFHkyF8lQTx

From: "Darrick J. Wong" <djwong@kernel.org>

commit c0afba9a8363f17d4efed22a8764df33389aebe8 upstream.

A reviewer was confused by the init_sa logic in this function.  Upon
checking the logic, I discovered that the code is imprecise.  What we
want to do here is check that there is an ownership record in the rmap
btree for the AG that contains a btree block.

For an inode-rooted btree (e.g. the bmbt) the per-AG btree cursors have
not been initialized because inode btrees can span multiple AGs.
Therefore, we must initialize the per-AG btree cursors in sc->sa before
proceeding.  That is what init_sa controls, and hence the logic should
be gated on XFS_BTREE_ROOT_IN_INODE, not XFS_BTREE_LONG_PTRS.

In practice, ROOT_IN_INODE and LONG_PTRS are coincident so this hasn't
mattered.  However, we're about to refactor both of those flags into
separate btree_ops fields so we want this the logic to make sense
afterwards.

Fixes: 858333dcf021a ("xfs: check btree block ownership with bnobt/rmapbt when scrubbing btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/btree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 1935b9ce1885..c3a9f33e5a8d 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -385,7 +385,12 @@ xchk_btree_check_block_owner(
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
 	agbno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
 
-	init_sa = bs->cur->bc_flags & XFS_BTREE_LONG_PTRS;
+	/*
+	 * If the btree being examined is not itself a per-AG btree, initialize
+	 * sc->sa so that we can check for the presence of an ownership record
+	 * in the rmap btree for the AG containing the block.
+	 */
+	init_sa = bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE;
 	if (init_sa) {
 		error = xchk_ag_init_existing(bs->sc, agno, &bs->sc->sa);
 		if (!xchk_btree_xref_process_error(bs->sc, bs->cur,
-- 
2.39.3

