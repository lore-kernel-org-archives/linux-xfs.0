Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441C5450EE
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488081; cv=fail; b=f8St4nq60QlVQrnO/o3kq2bR4AT3mhnGpp/XDKYHukj5PCX0JfvEQ7pcFEltir4BGUsGpB/2OhoVeN6TFVkJInalwzikFBzsvD1XimRHNsIFHRG/CdjGQbwP/mxUKOwUOOr6hErTIxGlmCWV+zYrdFfQFwzyH6onaysJ72FXLig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488081; c=relaxed/simple;
	bh=psZHwsuA9sy6e/QJFA7PJIVDL3CLHRoeMrUOAl6Zyzo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GALaAa8tPQHjigsD1H4BJBpYxe2NVZl/eRlILpigYkybVSf6nb318QfRGO0o9CYIM5lnUhTx4I4nneW4uNwNOpKS4lEhia6/SOEb9FEQ0dXz0p0cszYaQe8veP8S92Np9dKCsb19e4e1qJfs2Y5Fcdm2BIz0Jtrz/gvJkt+7HJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IK4q5QKW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dG5FYHE4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IK4q5QKW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dG5FYHE4"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BqoB001111
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=XqofHiSLi6EtRfVc+YEDTVFXeKI72cJeabGzqWd1wp4=; b=
	IK4q5QKWBuAiLdKe5X9VaFEjIehR75J2Tz9VEOGA74TJ9Ij+UN58fAyLY66plW8i
	6keBln8cSRqBEhKnAMqJ/paYGyYXCKewocYW51jIaz5ijrYUG9hJH0fpZWTj2wIS
	VxnlMpLpiZ+YjlJ81BMcIwcc1Ta6T8Ii3Wyvxd6+tBnTpq0deEh8oJNJPKnXpr8a
	1FWAWKR4Iz9cmx8AXrFybREZpDIO0bUXnnUiWZL6Q+tgLoD7nn/Lx2yR3ym+RUHk
	bXOk6wr59ERX4g+GAJNyxeS32RDiRqBHqByWgJk3NwSnMNmrS7ZsCADKoyhLMqIY
	K/2YuYzAlVXntWvlz4czpA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0ec7fmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI0N95S010863
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f945wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=puj0DDl7pVaon4qWXJFMlcWfnuxQBHBDS8IujhyM0Z+MIa8FDhc8RjHxlFVE5X5ohKY3LgAS6zdWbCwers4YAWblnjtENizw7UYvdLP8ghhTGsiSVCf+tarIhf5VFfk1Q6q/vQebRTSE+el2VDOEdXA7kJhfEFw++TtqT3dHwtsblhkBT07qbrgPcqbf3ReqoKEU3pSMofhYaIC8q1YlOhKX9bFcmShqkYkZLz839SFb7oxoQN49lCnrKM0JyAvYH6hl/ieK0mWcj8LZ82hWinAOMbV8aSYI2rurX4BA4D7/ShfAZq28bJqZfQ3ygvD08vP2S4xDIpXt7pnHDcUb6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XqofHiSLi6EtRfVc+YEDTVFXeKI72cJeabGzqWd1wp4=;
 b=MAi6pLK+vRT4Xc+jwreef6rjaALN6ZrzlNHiOA5QfelnzynU9EKHo7TOt1pS8cCicGRcNomorrBvNqX/+nNd+++MnjlyWmnKqiaoqACvAiTYfksIgr90siy6jVBaWB0kqVUxnJB/GtVK7JIHCl9NeVPWMN7klEgwRzg1CbwqVT4sj0+pJs46dfitTDaYavqXZZCuKV3l+aFlkLy4ZGLWNm6vXiKoUqtdeTb4pwPS49P/rK3etKUYB91d+XwzQBtOKGXrPyqALj6iXzVOja8wQQLn2kuS6gsoJz82D86Kq7a+MI4cJMy7orbfQwjZ1j0TXNLxWrxjqqL45HTDt4koCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqofHiSLi6EtRfVc+YEDTVFXeKI72cJeabGzqWd1wp4=;
 b=dG5FYHE4XEGAFNqSRDD3lCS2ggjVcULl+mbZtXPYDgwRI77DoB3TxosTjMep+d/DFoCyEVdFiBy72e+UOinhJ9F5wpifoKinU67gt7hwKjVrAcUlg4OTCSIafbJZiX8BDz6K/T2uiyN83SoGHE6ZDzguT0UM2aI1jljODTNKD+s=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7577.namprd10.prod.outlook.com (2603:10b6:208:483::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Wed, 18 Dec
 2024 02:14:35 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:35 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 12/18] xfs: attr forks require attr, not attr2
Date: Tue, 17 Dec 2024 18:14:05 -0800
Message-Id: <20241218021411.42144-13-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0199.namprd05.prod.outlook.com
 (2603:10b6:a03:330::24) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7577:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bfaa40f-4dae-41e2-728d-08dd1f09b781
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8rEJpC6au2yRqNIJhHmLk2HEA1ZCHy/iCfIrMQjjsbXp1JeUQKXsI0ZFpL3u?=
 =?us-ascii?Q?ujJ1QD7kX1IB9Tj6jKfXo5vXS+ekFhPr/7oEBXuSy9UABCI4ft6H6k8uVfw+?=
 =?us-ascii?Q?81UZYy3MtdYQbSstj7IJ3s4seJ/SEsdcKNidpJFvka+od291c5n1fTtVf/4a?=
 =?us-ascii?Q?YU1Jt0h5bxZXnFYwGyDJ9iu84+Mb6bpU1i2o3XQJgR2XhDDtgEqDMQZzjSG0?=
 =?us-ascii?Q?KlCMBGTi7RJbVDyxMpCuBZopNKKGPW9MoDHjBbt8H58r+hMy4GYCdzyBzC3M?=
 =?us-ascii?Q?A6vnwukmWaucx12xP1EFkTHzfvfSXH8vXVCP67CWXgAO3BJMDr3Af8+pGNcB?=
 =?us-ascii?Q?JhzIZgYaCbc7kSJrSh1IZnbgtVQlul4UXaX/949Zi+1XWVqFkOaulMp1ZZLn?=
 =?us-ascii?Q?1fkgfKQAl7aKqedAo8IjYDSQh3Ix87rpeLu2JRmevb5tDJ26bC6mUP1071XH?=
 =?us-ascii?Q?3XxPr6Gidok0MqboocRutrziTYaX2LHq/YBlbn/VuMEFlvOtrB24gMbq3Lov?=
 =?us-ascii?Q?fFJYNoraDxwjAJ2zulMpHL6Lw1rDeNozZ+VJq9SQpcOTvyxzpV9V+xpAgm94?=
 =?us-ascii?Q?hg8B+n0lH2hGSbZ3+K/C3l5JTLTl6g43FqzjAkqKgMQoMO1bLfm9ZNZEEDV8?=
 =?us-ascii?Q?4bnhTHPjh4k+0rs0FjWeA4qQ54Tp5foT87GHC42eRcHDvQP1o8dwZGkTGi1+?=
 =?us-ascii?Q?TjC61cl8ScRTaWCNEEACRoDvw0FPcWlvCeEvgbybsqPS83DvgjWLv5T5pqvv?=
 =?us-ascii?Q?VV6e8KNcX30qUXQ1nC/APySplytwR4xw3zlFDW6EcWWWsniBFIyTI6AvCU15?=
 =?us-ascii?Q?OHye1zQKICdhhjNFQyqnCZ7ZBRKFIKosJ5h4RBqG0Ln8zPuE2C0LvaokzwXk?=
 =?us-ascii?Q?wZw1TGRYVHLtxyvoE5WQ7ClW27ErtKgzaLbKDtFJ6KxFuo0ntYut5BoAu+4y?=
 =?us-ascii?Q?eLkcOS9gi1gmpBA7HuP2nmtibxA+HdmJaZluWuLRs+PFn7XlUC1vWhgUUv3p?=
 =?us-ascii?Q?L/PdPKbIAyimbTq7GH6FKkfyG2AGoQ64o2QxhKxm5UW60+AwrhMDeNxVi3dE?=
 =?us-ascii?Q?W3hHzi6pQFuymMdy01/HgXnS3HRgPw0aPevKKxg2p6Nb1SFe/tg/jWvS30Ci?=
 =?us-ascii?Q?zD8NxnC9nly/iQ0pJdKzbQqJUE4n8O4brIJWz7b/YPYQMG1Mz66CTl4rP694?=
 =?us-ascii?Q?EzeIq8yQhsD5PI/hE3Tg0rB/WKCkhoHZG2xD8+BPYhxMXTaH0ehVs8qVYx4Z?=
 =?us-ascii?Q?NX4fqOiPFhwelRm+96wmWMvrGrSw0pgVHInliguwyrfOE5eaBouWYTR9N6p2?=
 =?us-ascii?Q?UjDb+n+OPicXg9/AXUGftoZN2StSFRTsCGLa3XrZ6zq6A27Z5CmtFT1GzpJo?=
 =?us-ascii?Q?DLvwZGzvdY/ZAbYk6WDLi/LI8hrJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gDn4p0YWAolWFnzmiZ+bzokc/a8vGLOruBT6xwubn5jwlVhbOoHIkUvae53C?=
 =?us-ascii?Q?oLbegi3AKIDlmq0UPSkCjCm+YlOrZsytgpft5BhLb0ncnuMzb1LwucXheQ5K?=
 =?us-ascii?Q?o/38oR8nd/LXuEDrXjQ1jlaRvORCc/49r3lEE1CcUtjio/DeipUa6nVqsgad?=
 =?us-ascii?Q?KZVXVKJhfn9I/dVSqmRuypYpu0jpnHI1LEP0xUQCeRXfkRUk4c+ar1Da4FD6?=
 =?us-ascii?Q?CJaWngfflXNVDYvrPGTZMJ13c4XWmhDB3qvk/wpOUjX3cOc96gaX83F+2FHa?=
 =?us-ascii?Q?NY7hdccBBHiwf48wgMr9h62lWN6Z7dbi36/kMxIYJ3SDRB2ZTe52Z6r6b0tn?=
 =?us-ascii?Q?V2QJpNraKxxbh01Fe9Sl9FMZVDq5n++HCB1LwRxqdm+q91d2bVUMUNaiginF?=
 =?us-ascii?Q?Z5csFguhlll+IJDzHo81YL2vNRY1DDA5bdhtJi+Y6WWQPckvyjt4beiPFLet?=
 =?us-ascii?Q?h8xOgl1klaoSoQ/wbyl8Iup7wglsqy33Pu8Xb65ShKMs+Inc4VkGClQdMh1c?=
 =?us-ascii?Q?evKIuZjgpCAOoS6ZXW2sKyaIVyqOTc8PHIF5jAdmKi95a8HR3SeLGI9+8SCe?=
 =?us-ascii?Q?N0Qn6rfhRFUowVgUKsdjhlYeVCEBINQl9KEX23jOxMXKjLOBOM5Sta/k7b2e?=
 =?us-ascii?Q?3oEiHb6iQ9hKGC7WP8Y2qFYsHvrMd5UIr3KRtuaYAOAogABcewnxh+pV29ne?=
 =?us-ascii?Q?AQArtiJAdguvsuuBuoJOAx5bz+1rwE4pPSguAmh/VFyRoeU7IH6KzSI9hprO?=
 =?us-ascii?Q?2z9M1U1zRnXyIP3qP05p0b6wG0n9yoVbCjhAHN49ZjewearUgVakrFHQIYyK?=
 =?us-ascii?Q?7qiutRUFo6rQd0d6OtkH9UYu0x+X36DQFxlbFbRxcZby+EOdmfVWs+4JZm9J?=
 =?us-ascii?Q?mbqXIlvkWGqBdE1VTHeyPvTNXVqTBjm7yBubjCThjUk3saD5PtqNHbtdhC+W?=
 =?us-ascii?Q?cDmd4uUC9Kycc1FT+SqB0p2KaxCH5Lf/f9uywZgRFtGukgTpcterEo3rm3wS?=
 =?us-ascii?Q?/3CW2WHbI+W9qtDjPF405QRvr/b2hL3JuwiLXTh+lFUQC6zReLvrq9wuXH9y?=
 =?us-ascii?Q?/gpi98pFZEXy6SNqzmSvPIBxV3OAmxpsa/IPBA5n1me3MuYKiUVGFoTrcp94?=
 =?us-ascii?Q?xzYRzHNOkFMo57RiIPZ7NtZf01IwDFKc7pcFW+rriG2kEOdXRwlwW0omqDgb?=
 =?us-ascii?Q?9pIMA1NBI3bynQFPKfV3WwgQFC5G/DzrYHpxDt/mnA2fgzVNI6mdHgzkB2bi?=
 =?us-ascii?Q?tQa74GmGL2BebEy3Vm18K6vKiv5A7Wx6RMXJi86IbwbUgg3qWaZNbkqrcEmv?=
 =?us-ascii?Q?gDGsqevpnTnMZYT0sg4LGEAqAm6Ek/IKhOcR4L6jsUyQAWcgMJFhfKaFYwcK?=
 =?us-ascii?Q?4KvIZvHKbWr/2aG7f7JqFqUOr3TcnJvqLp7D475FIWeCWiRMxm3uSLk/hNyR?=
 =?us-ascii?Q?D6JPO48aXw0H5V4YSouQS+totzwok7iqO5q25CjKe72OrTTrGU89qUwwaLQ+?=
 =?us-ascii?Q?G+VbCFKgQYl0wVe2vvrrLQ5OlnXiCCZ8SYwtfus3VPD5TusQjW7wRgkn1xdb?=
 =?us-ascii?Q?zn8bitMv3LPsBJ+NG9xo28hRGc1YZDqWdqGPT8M8xSUzLVa6Csy5ZUPP+v0N?=
 =?us-ascii?Q?kswpZBkBI+Sr7AIKy+XgUw/rN34tGoS37YP8yj+xaGyT6QF4PAfI/m/o2xXS?=
 =?us-ascii?Q?Nsdc4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u8VUDbps7NOKPvCOINc3MIhRZSku88LBIrLyrhImK6aHMeEjbcTe/NhjwdoA58x1fvJRKBL0DHE+/J/dZmh9jUnyMNtxbW1dnezQxX5W+kEazhnbIUiti8I+b9V7pJOHRObV4Dgd4N8OIM429x0vBgwFUm5YtWXrRLyJvPwXFNFc/bPuQfrRGTpXylYfgr3SI70eNucRh2KjZ3yXEljgcSG5RbZyr2BYCWGxus9HukbNbN7dgrcRM5rhavGdogelaZahATNgFZAHuxt8szSQlRYuekCf38uxtcICthZYi9s5QhfBwwfbpPUNZuhYJcykqSBvA6Z6fB0z6LxxBO3MCC5UZtumfolQX899UE5wG9nLc4hJ1H5qgA/ujmLnciuDslfcu7Kkr5ch9A1zY+7bQDuyUxLZUfEt17a3Q723nkSFF3Z0UphUy7mMKKp4D7BZ1WJMxQ2xzlHtFZTajVlWvgPyX5sL/WS1sEuV9EuasyD/f7WG6UUAkSce3JQjXgZCGEIAHuYPmggbejuPdZ7CVBMNSzs1tQyjZV16lSKNTM0SGxH9lPriaUpgvM7Ggh9TJEpfrn865c93uD9i4RWHkPgYFcp9qcaIv5RSr1NP65g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bfaa40f-4dae-41e2-728d-08dd1f09b781
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:35.1913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gx07NOoIbJvcMCj64Af3Uz6cu/4yob/zF4Qb2q1tIFH961S5T6xcUQZZ0y8TkfU5pl/8eKwrk/ZfxpyA8h+On4YIi5LkNnD0GntC4IbrW18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-GUID: yGVLRLOONpd5jcRR4HGREi4msGyLEl31
X-Proofpoint-ORIG-GUID: yGVLRLOONpd5jcRR4HGREi4msGyLEl31

From: "Darrick J. Wong" <djwong@kernel.org>

commit 73c34b0b85d46bf9c2c0b367aeaffa1e2481b136 upstream.

It turns out that I misunderstood the difference between the attr and
attr2 feature bits.  "attr" means that at some point an attr fork was
created somewhere in the filesystem.  "attr2" means that inodes have
variable-sized forks, but says nothing about whether or not there
actually /are/ attr forks in the system.

If we have an attr fork, we only need to check that attr is set.

Fixes: 99d9d8d05da26 ("xfs: scrub inode block mappings")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/bmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 75588915572e..9dfa310df311 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -857,7 +857,13 @@ xchk_bmap(
 		}
 		break;
 	case XFS_ATTR_FORK:
-		if (!xfs_has_attr(mp) && !xfs_has_attr2(mp))
+		/*
+		 * "attr" means that an attr fork was created at some point in
+		 * the life of this filesystem.  "attr2" means that inodes have
+		 * variable-sized data/attr fork areas.  Hence we only check
+		 * attr here.
+		 */
+		if (!xfs_has_attr(mp))
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		break;
 	default:
-- 
2.39.3

