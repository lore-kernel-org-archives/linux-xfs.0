Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DCD20DF4;
	Wed, 14 May 2025 00:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747182566; cv=fail; b=E4q10W4RsMvMUuCRdEv+m+JuaQxba5bRvaK7iLSw8s9XQWT/XnJKju7SeAMmM43hgYjOu0sovamur9jX228ScpkcicGfZIKp4P8GrvvKPR8hPltROQxWxa2LJv2L0QmVAu5TpLV6R2u4LQN72r63XjZ359cEtbMw4l2fpQnkGso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747182566; c=relaxed/simple;
	bh=sSEPndZGc+HiHwc7i1jGJZvBbtyALO7ue8NZN3lAQXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FNfnfS/ltY13rs5GyX9bA+KjFo9PLhYG878PNZalvTxYdEVGkQxJVMBsSdqw1h1IPsX7uNiRnWujwCgDxdbaRfK8Nhfavb8QF0hSYo5OYTm+kv01L/kGR+P26Uq4rkRL4jHv9zjSLExVvxDue9T0jsy7gsFrmg015ahQ80qpACc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n4VJK91Z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ERy4MNXo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n4VJK91Z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ERy4MNXo"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DL0n0I020895;
	Wed, 14 May 2025 00:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ESCXTaoBEuUVqXXrKgS8WcfwttTY/hiVHYCcFrvTB+I=; b=
	n4VJK91ZSC7zq1mKWVBYNzoG6QNbz9hqK5XweqsIf71QY00s+oN1n3/PKp7GgwWf
	3OrUejZfSMNcLxs+49tU8E6jdh1zgvvUUtjY8IeQHfLIKsav1UQ2Lpi8ujhWPyJt
	mygHDDnLVp0BAOve+DmOU4+Buxe/Bu96ZZceEDOy+Mmk3T26iwxbkbspGexKWBKq
	dO+GmyTQjjzyaoRXCS5I2WBcen7+Oc0+inkQMGt8HbBPiqnlqE7MLnAMUrCy1wLs
	y8ZnapVpdFLGvcxdLGOsCPi+9xwdF1zP+mj1pRLU5tNT7GAKB5dBvjOCx+HMg1AI
	9hJwdHUYdtAE/mPUrZUSRA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcrggbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54DNoS3o001894;
	Wed, 14 May 2025 00:29:21 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011024.outbound.protection.outlook.com [40.93.13.24])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mc50131f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=torjcJqcGcQ8sN6BOSwamPIAl0rTQgBGwchnZdQbbLv8oLLMofJHknQq8l5bm6GKE6Xr6OhPeP0reALO16soLfN/OKllpV0btvBQUNPgEy36KRrBimUCM5T6fcDidVHpElPwv7akSKdQ5UL/o8eVsfvCIAgb/byfldl8inqnkeVxsolu4Dnx3S+zs1Qng16M26QPUey1eVGvvwf73Zcmp14f+hxD6ZPJ8Rwv3pxAEJ813amvT26k1CAiXbjTGvVoH1pTOBjPHAbVATQc7E6bjgghtXsxX0OEhcq5qtOXHEuNjNfZ5KcC+hjG69rC+20smsiE2zAe7dIr9nLZ0CkBAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESCXTaoBEuUVqXXrKgS8WcfwttTY/hiVHYCcFrvTB+I=;
 b=A7zNo16XjLjV+FKQEVNjeMSMscDo85hp6lQs+odZ4OfDE3nvsVtrR6wU1ILXTarn3kgtjaqeOGCL0HELIwn/65w7Z5uFsR2nakCtS69U3eLUlNw4uMFbHAB4Lrhn45dGDBtwnfEnTEwqrT3pCjbwQmROWJQLHctq6oOeO11lGf80gjFp/rTQOyG+bykzEpR9dTTI1f6lVxMqqXAb4tffmi2RtDxtkb0T7O7z3GtPjdeQknzqiqvUlmG3CFl5xMF2Avbaa6TQrdH+Ev7xCsX4ST0GoZdT66YTknh+ncJSNqvs7VBjWgHHjX1zh67bMiL9Zt+OSmqGaWK623VsNFulSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESCXTaoBEuUVqXXrKgS8WcfwttTY/hiVHYCcFrvTB+I=;
 b=ERy4MNXoj22sB/C+v+RGzM+YnEcUiutfww7gUJF1nCKNze2V5NhrYDrmB0EEF9H2BEjI9Wh08PvUVQA4laPUuaCO+y8Rjk2oVRfIG1iivk6UKFBwpqdNillEN2SVIdRmHpcm0I6QXb4iearckbPe4Ijgi2aWS1IL75QA3baF3Ts=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 00:29:19 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 00:29:19 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: [PATCH 1/6] generic/765: fix a few issues
Date: Tue, 13 May 2025 17:29:10 -0700
Message-Id: <20250514002915.13794-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250514002915.13794-1-catherine.hoang@oracle.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0375.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::20) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB5204:EE_
X-MS-Office365-Filtering-Correlation-Id: 53214667-f1bf-430a-7cca-08dd927e5d73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?llnBSGPBA80bCgJVDHfKWYPdWQ9bpIw6ISenqPrZov29Ahq/GCwR/x0LYthf?=
 =?us-ascii?Q?SVbFS6WqfYQ/RyqtEtcmrVluAOVgbZM4jcFNkqiD9E0ppglUlnEWtNvhfZED?=
 =?us-ascii?Q?v96yKKFCr1/YVzZ4nqHXnFw7sb9BDREVTwPOej5HwrQJ7ho+LaAOg6MOBbR8?=
 =?us-ascii?Q?DD47C1kgIqQa3TC63a7FWWtGv/D12AuNhqRMdYsUsHisOG0TOT9hkU1wMqxY?=
 =?us-ascii?Q?o3vZArv/e3d36etK1zc0L/5+4FASBKJAAGJimNHXUONJSaTl+/xskoTrj55u?=
 =?us-ascii?Q?+p5vqZtyacgylMc/rIW6bCEATLbdA4iMJSF2BpNjxaMIa58WIyODq4opF/ge?=
 =?us-ascii?Q?DK9nP5VW0t7OhUXHcZHvYp+wRnTArP+SFVAbM0zauouBAcTP3nyISqfbRpw1?=
 =?us-ascii?Q?F+EvhpCzkryeVJLbFwcztyXWasn+y3S00FAS3V9Q4D9FLkjwzIphUZE87pbq?=
 =?us-ascii?Q?maSSssbluVVALUqlWW+jcDbXJjPmJxnnO9M01TQvdgEmba7GIA1VigdPsU+r?=
 =?us-ascii?Q?JNbUHDzFN6XBB8BPfMwcIVY3K+Cv9qcu4+XEsRuGc+GHv7E5rtSlwA4wc2sf?=
 =?us-ascii?Q?s8z74bROOXLu/oODFj5fJiNrmlwz1jBTziDcE9+49YqR4t2PbcbXx79cOZjf?=
 =?us-ascii?Q?miu7z//0YyzHMmno175enzk+fIG5kboYC5F5xxAm2AXl6Xs300P8tXmdrH+M?=
 =?us-ascii?Q?0btCJvAV8hF9iYYAMmlHCtwjCZCpl4Zyj+tC8Qw6uNjnzohZLkEhGNLWCu6i?=
 =?us-ascii?Q?TzH/kSzSfhZSUuoYXTeR+lei+OD56bFWfOJlWXZxWPzCC08wPMcc9uy9fVt5?=
 =?us-ascii?Q?CwoWp7jQmC31kIbC/NIGl+uBuQFOyYBsj2QcubPUgVQLzLW7eeY+puGP2Ks9?=
 =?us-ascii?Q?GlmPC+1qXBz5ULkfA+Ty0LFWGZ570sHlB6En1Z8iYq5HcWudtqwppNI/WOj/?=
 =?us-ascii?Q?WSuHmTQHZWtpqopJjiPb4cor75MxDNb63T6OR7fUjFU8ayEyW3IXMqZdSaTg?=
 =?us-ascii?Q?TCiBgkmCjFAhCFFT2RKnhomZSoG41Y9r6bNbXQKvSSkRcVgEzK3xm/ioNi25?=
 =?us-ascii?Q?43BGNxWKCN6iPknrW1dKUjDPy3FQo58KbjF7Qp4UyT19whcQuZtP2L4d2ZtD?=
 =?us-ascii?Q?8/Lz1zSE2oyqP7Mfwqe4MxrAVnt2GB25usXULj+qeI6Kbi597pCh/I7/2kH0?=
 =?us-ascii?Q?feUXGh4ojyAgd1RMfcyrmHNOVPUFzB/viAzw1/LSFPJkvg+D3MQcSTIZJ6Fw?=
 =?us-ascii?Q?GexbYgu46YxEsyHAytb1UMigqyTDK1Ov5H9y/1H2zDoQ3xfwk0dFKEyQI08t?=
 =?us-ascii?Q?dwRQ0tmqN9d8H2NLQj1xIZpAEIDGu7sQlHNGoOlKMJn5UsVYYH8PFBVbteK0?=
 =?us-ascii?Q?jy4N0ebH2x3x4ni8nsLZwNAekzDtnpCRVdFxGWzBOCG09bLf9bTnCupFLaCf?=
 =?us-ascii?Q?EHelokS6rM0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bWsRymmeoQ80b3EoJFZsi6wTKmSrv0JwwgcwnHQSzPWspkt3mB3FjPO+nejW?=
 =?us-ascii?Q?2c3z+cu6axhvjNlKFgdlQBGdlSGzpmU3vRlpSivjyQsYIhBzFh5XyR6OvMTa?=
 =?us-ascii?Q?YmNrtxbdX1JqHzik48tETBVJZJ/RPQemepnJOvIrKVrEprpAMdcvd4DGPVfu?=
 =?us-ascii?Q?TKM0X8EmjxPMnbw8V8YIaidRC593yu4zkahpVeMcTle4iuuc+eMrR4qzJ0xs?=
 =?us-ascii?Q?Ga2LVD48F4ZvfjNBy6nM3nhA3vou1diIV0jE0sCmyKOAA92KZIBePzOmteL/?=
 =?us-ascii?Q?tVEug8FAtfaY/ptSpJbU9nmMcNSCDgpNFOVPomxA/qZIhK7VujagEVnDtzE2?=
 =?us-ascii?Q?gav4Vq07nErIzx2iM0Z0B/j2fpTwf45jTJb/V6nfp7ZlNU+9Si3JYw/lvpGr?=
 =?us-ascii?Q?1CD0fT+tCgO7gOgHwIrTz3cy6hI16kHOBeHf51Ob97qrnDoNqRCtBpLv6Ki9?=
 =?us-ascii?Q?DcVt2p8VVNVXRLLypiiozfE+I/q79A9pcg5/uxiliExfOychYKuliHzHfc4k?=
 =?us-ascii?Q?XghwTuwkTSaIxkvt/Qcd7awSzQ3iZ5/CaseDic1OtdPsEMCJ4RRX0PIP1O+A?=
 =?us-ascii?Q?7CIifzDaIKDNlXThSqEY71Z4J8tYNGfWpkr2ZihZbPu9AbuBGcShUy2YTRGE?=
 =?us-ascii?Q?Hsxkp61YwlY+mFgXHleAUAZNnA/9SAKNrvrcaNkAqhaJuomfV6AyNXalF65Q?=
 =?us-ascii?Q?8rfjajL3RcXyLXOZYcOPvmtBtgPZzCe3yk/sZ6iG6qvZSKnkbo6l60+4cloL?=
 =?us-ascii?Q?88iOLVZFD5oDVfKjXkwlE7tf6pkv+iBgJCoYAXE83UYuiSa0IwyvGRXkEyp9?=
 =?us-ascii?Q?Ntjb2TLQ1V+LB9bPmqXHplTFmwZP6jl6nJcsVxv+0dMOscuBV+i60A8Xvbs1?=
 =?us-ascii?Q?kk5klrTg/JgzZp/wIP+UHzhVa88SPQ2OR0kMrE0SO2Ftg/DHVcGh0Bqc8Pb3?=
 =?us-ascii?Q?U5stBJvucERSlD9/Z8Ic9St1t6snJW7qnsjeH1abHDLLjq8wyvkCrXkLjIa5?=
 =?us-ascii?Q?IFv/eC+T3c1dYndlIsibtGXFbSe2hR9TxK5KThSOWvZXeynqgs5/fMOJfskA?=
 =?us-ascii?Q?XzhXinDnFV6uWjnlRUnFN69p7DsSBoD23gfFZvDdiKhd41ap1pv3/MSqjt8a?=
 =?us-ascii?Q?bBj82Xuzj1nHbDfZJay+r5EyJGMeSM4BOKIcpJd/s+62fJg1zSYZ0xPNh390?=
 =?us-ascii?Q?s+UTDb18Ng340jvIkXPnVj5caj/uIeXNmkW6t8CznTOaAe7IqZ8a4W6Uifvt?=
 =?us-ascii?Q?vJH1MojijS5bY/5Vn7HhImX53SXFVpangkgyR+HBodYFECJIyVdHP9JpAdjq?=
 =?us-ascii?Q?KN7M1qR1y96fBpY2p8+WIHNBNKa78pzvlNbtTTCeibRz6N/2t1cpSs2sTizz?=
 =?us-ascii?Q?LLhZDHHd18NBJ98aDupU05h0HglH+xW3DTgyP221D7h+63HmxoK5SLi4dEyQ?=
 =?us-ascii?Q?jRZVmZBHtgFl5IB1wXRuMSPNPklUsjdP/CZCNaiarbBMtXIBmOPClAmrzU5u?=
 =?us-ascii?Q?OTTd9E7XvvBug0bbsg5I/qqGJtynuJwbK2/jGdqHHW/zda6yPG6RUOhrvIxH?=
 =?us-ascii?Q?9jDXr9wWvMB53icvYRKp2573XEw+ltgcrkGwFprA/+i7+5Jx4IeoPeeeSnIN?=
 =?us-ascii?Q?JCyUAnv3dIxe+NHEM2uw4t7P/nVSMiFjHHYm4/vgXpWRZOm6/xDud1hyrO5j?=
 =?us-ascii?Q?qWqeXw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dd60B9gpFbhUnRS8eXFDgnUznVlnrF78lK3QtYTxn3HTnKYYnejXk2KSnKAT1EEGrKhVYujyED0jvPHx1oYSGlCOaoppHm3NIZyICkG2zyYLPmESFoRJ4aakY5hKt+U737svKr4uMh9uresy4k1H6EOqiAkmmsvO1adDEKEhfffa5NWkMDyEBX1xkKTIjkLD7WkvJONxrLVt10esfZsvTfo5PfmrV92Ra1nx1AhCHsWzzZwmIcBEZG3SHbAJzf1HZ6Tly6dP7nKIl6zvXFzszM0ATnTwVHOJkyvweGgbmeJxGBaWqqT9GoU4+RDoKOj7jTxX272RfWWYCuEFDOxFN/pidIg0HhawwMEWX6ntIUactNacBdyHM7/4KL5QS1s3KNTrz4Zen8BmY0Gx+9xPJPsovqXUKhu7QvtBO89YDKUSf+JdDdmHS8+w7H3Uy5yHR/OKhSLP0Me/U/RAuLCc8rnFJSxqPYKpd9Xvmt33eeipuh8CQ4uY7CKfnO4f+GJfQmzNCfl7Vdqctqcz33fL3yds08GkCEOV00v7yHihlM5vgkQ9eOeuWYneFfNeCnxlBTqpMJBHROHVkw3CVeQoAMw0/4w/IZRqB+9LT+2Ev3A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53214667-f1bf-430a-7cca-08dd927e5d73
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 00:29:18.9612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwD9ntveuXIwV6e5ms73xx6DikYl1Z0vCFJmiAW3Ky41Yh/VetSdLm6rqY890wLUPMAijjV5X/q/XJmdKLY8Omclj4+uQ5iSxT/kc6R6FOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-13_03,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140002
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDAwMiBTYWx0ZWRfX6eSyn3gMR/v3 EeoqwnfIYeR4q9mJcNj+qg9kgfb8siKoYtM/DqriFZV8N/9Vx2W/EWSy1cysaUogy+Qp7TlXVA7 cE43QiewPyV0WGwakutOlwXYHDW4lCZyAz2UMP5MNmCyaxVacJUFfK7YqvMxsarLPp+SLgyiddN
 jE8JQtW5BwbZ8fv32e7wiLf4rO40FAm50kax87lLOxma7AG5kO7560/W5Ssc4vtruaph04o2jX9 HzCl12QEn2TR7GCcJDZB3JTspIsvxoNndYWvu9hKnSmpzVrjQKFiYgHfMwP5iVyyWR2jmU9PGTz thEbXW53O1tPjetQObNOMO42uxBoo11Uz4FLzbo6R/rgL7K6WnA5OzeWv+MsIVwbJhjrseLYrck
 Jsq0Gfcfy5R/134uW4U421stwL6+mbx2NDl36M2VealL9rKamgMcR4O276CQUZMbtkzlwCz2
X-Proofpoint-GUID: spE9LxJjXO1pOxV3CxP-hMZD5QNV-e-s
X-Proofpoint-ORIG-GUID: spE9LxJjXO1pOxV3CxP-hMZD5QNV-e-s
X-Authority-Analysis: v=2.4 cv=cuWbk04i c=1 sm=1 tr=0 ts=6823e3e1 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=jxo5mUw8ZoZ15m-23zMA:9 a=U1FKsahkfWQA:10

From: "Darrick J. Wong" <djwong@kernel.org>

Fix a few bugs in the single block atomic writes test, such as requiring
directio, using page size for the ext4 max bsize, and making sure we check
the max atomic write size.

Cc: ritesh.list@gmail.com
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc         | 2 +-
 tests/generic/765 | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index 657772e7..bc8dabc5 100644
--- a/common/rc
+++ b/common/rc
@@ -2989,7 +2989,7 @@ _require_xfs_io_command()
 		fi
 		if [ "$param" == "-A" ]; then
 			opts+=" -d"
-			pwrite_opts+="-D -V 1 -b 4k"
+			pwrite_opts+="-d -V 1 -b 4k"
 		fi
 		testio=`$XFS_IO_PROG -f $opts -c \
 		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
diff --git a/tests/generic/765 b/tests/generic/765
index 9bab3b8a..8695a306 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -28,7 +28,7 @@ get_supported_bsize()
         ;;
     "ext4")
         min_bsize=1024
-        max_bsize=4096
+        max_bsize=$(_get_page_size)
         ;;
     *)
         _notrun "$FSTYP does not support atomic writes"
@@ -73,7 +73,7 @@ test_atomic_writes()
     # Check that atomic min/max = FS block size
     test $file_min_write -eq $bsize || \
         echo "atomic write min $file_min_write, should be fs block size $bsize"
-    test $file_min_write -eq $bsize || \
+    test $file_max_write -eq $bsize || \
         echo "atomic write max $file_max_write, should be fs block size $bsize"
     test $file_max_segments -eq 1 || \
         echo "atomic write max segments $file_max_segments, should be 1"
-- 
2.34.1

