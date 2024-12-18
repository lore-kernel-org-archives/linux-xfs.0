Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4042E1FBEA9;
	Wed, 18 Dec 2024 19:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549467; cv=fail; b=EwygDib2dk4wffeJQzRLEvsCIL4h7QGfIID1G228cR6gr7SiTJMsbRYdd+eyjWkHh3AdI7/8MonIscGKlMS9anvSukQdU2HDuhmiE4UK8wssXHnEcPf6JgnGgTlFWfQaAosLa2klLSIbYnYsnOl/K5bgzOSCMkLSA6BXnnqqwOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549467; c=relaxed/simple;
	bh=e1LKVIhTbDxpOxBh5J88cIQIoP4yTbI+lcb8LVBh/NE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KL3qoYmLOSVNB0/HyawZkr+yrI7AZ0lket9yYImxHXiMND5Ez+GHmIs6w3CdUpAXQ0gScegyU3js8tnVB1MQ1DfvEXut2IV5KqG+nIUUc0UICvONSfrIIMtWXQybVhAELwWlyfPoTqRB4duryyTd+hqc6ID6HQmnPgRLLEnIPH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C4zSDC/I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZTURjZ4T; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C4zSDC/I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZTURjZ4T"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQcjL029670;
	Wed, 18 Dec 2024 19:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=mGn+jCOxOPPI8ohhE9B6ENtgDYWDIzypUll0fni4hN4=; b=
	C4zSDC/IH3KLBws9WkQGtDOkhAfGQlZu/T/egEB/dWA2BWREOPPUbZP9kLIpBH5g
	SOWkqnIpHym9+xcw1kkOpkagASY9oCxz0kIiUbVJm2Hde9Xh3yD0deBvbn3zWZmL
	lwx3YUS2/Z/f/yAW2rJyJunDquGJTeQexf5kZVC9cg/+4YtuGjDjWbGYXOitSNhd
	kI4eLlTX/ObyjmQGFnv9ldJXi1SplAqcuGFrVhWunWcFGNcPCZP/l3FI771hxEZK
	Mw9yXTSFKFqlmu2mB933vvonVJ+pwFLH0zIiw1kwn8+kwd0NL2wgCjndejDbjb8Z
	5XzM/j8M0299GMzja7Fykg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0t2hcqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIILfBd018984;
	Wed, 18 Dec 2024 19:17:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fafu0g-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fg25dlBwUvBvWSHFX6p9v+S+fupPBC4j+5WYizVLj0B/d48QYSeWYleuaYCtjERHDtP4nk+WR3YmVL+coligBYFP2DyQn7RZ3SY7mRoNE22XjG3b869Fyz1XDUDuyVB++lM4BQe0IMGAXJbQx9oqvrNxtdFDX5hGWBnlJGP6MB9jMo89kUALBB1uMfhncMBsM1Ms608vP60662oYDTiacFORs8OW+QWKW0cnJcaP3S+L7XNmBoNxvlasY0b2EQCazsYkAVFbk1zuxQOfI2IJBzQIcj6z/Nf/xP0M/gm1LiwivI+chfXgOQnwIKaBcR1/hE7ZJTCMjoCrL/0PZwFCww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGn+jCOxOPPI8ohhE9B6ENtgDYWDIzypUll0fni4hN4=;
 b=nJ4vXRQ0cyIL6EvtKJ/eT9S8zx5t67FPedYIUZUu6MQuQh3uuo6+Y2Awo3foSpQAEfC3V8RLeAwpr/gVY60GVPzBqsnYvyPQ7vYnO9ow/JshX4Y7M3SFPH/AASZBxVFdBBxpXWLJLpitloh1woJYZR3E7xs37TpHWH50dGvVnsBzTDKIIqHb5WU7rk1awMJjRII2vPc/GBE7ULGJQW+CSsVkSeMsnqw/NnkaGhI95ghSEtQIo9yzFHXYso0mPhiFgghd6xyyEyPPLEkeXtkRETplC+5juCtWEySqTyJ0mZ1kB/nvv2cRZB3ZoQpd4IezFXMDxAcV11gDMIAxF27qBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGn+jCOxOPPI8ohhE9B6ENtgDYWDIzypUll0fni4hN4=;
 b=ZTURjZ4T0CsC13MNQocgBaPsK+XbvOtsPFFy18gJwfaynhNaSxfYX+Iu3mW6p2iKKlN0rV+IDqm0uIjEpI/3nEKBf97JdYJHQnQO9dlWS5eNCVotoaXgpz/HCvtAYs26DcqLN+uH4VgzrYxihGY5GzZODH48eOBp80AQon9Iwj8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:41 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:41 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 08/17] xfs: don't walk off the end of a directory data block
Date: Wed, 18 Dec 2024 11:17:16 -0800
Message-Id: <20241218191725.63098-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::10) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ded68a3-9a9d-40c7-fb2c-08dd1f98a4b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NneiRlkO8gP1VpfFIi9P9HtZQUkFGoCBINHJllzUAxsvfzaJDHWgdlVOIfjz?=
 =?us-ascii?Q?cR56KofJ8q7AcAeJQKe2AG81LFT7NPeXdH0kGTWShLGQn3QBda8jOLWdR7hA?=
 =?us-ascii?Q?ADtLNDstEPZt+eR3ihBecs0aPfCcwd/WkwrPz2FRLROP9b36L4ZB78vrMpri?=
 =?us-ascii?Q?oah+8J9ovk+CWIJSLoZI/+Ly7yYX8fbUSa2dgu4r1ITEoHlSgvjByLz0n9/f?=
 =?us-ascii?Q?1QdBFGXtPT7oKeuJr3nGPy+m+m9zNOyXoMTR+0oW9kl6F3nCy7SXkYJkBU2g?=
 =?us-ascii?Q?4n1GbPNAXGj7TIO2RQPRRHbsah1kNk9pEUivEPRwA0VcIGqE9/h7LP1ndoe2?=
 =?us-ascii?Q?giX0yMP61ZYuHhNCbQwQjEG6HkWauPiz0IkT2LhBnm0426frCNCEP8T1yZ7M?=
 =?us-ascii?Q?KKHfh5GtN9xM24ZhsK205C+hXh5n96FfNsJjKywm9r0tOyDBNAVbkrKYbMaj?=
 =?us-ascii?Q?jMYgPgGdPf5mf44gnQWdLtlGk+XWvTncleaTJ81ukFl+EHMuFQWEI7WzTiF/?=
 =?us-ascii?Q?IZw+4hQJ6msyEhaeX+RxtDQ69rfguwBweBVtSOjxztZ+c/5VbR3+rOyk6ZiZ?=
 =?us-ascii?Q?gAlqnyePjUQ5Coh3DJUHEQNFbHZmbtTRNilVqsOmDZJ/ExqyGf0OVUs9Yj6H?=
 =?us-ascii?Q?L7zUOBEaFmIIg4tWDTMjtQ5pWxcjPgHEj0W7A6Kj1/UYnGzzB68vAR1j56ZE?=
 =?us-ascii?Q?OOrJiYGtZg8zmG/7be8H1X/A5vi0HdaEL5ofE+l3e7befa2GnCDVNyvMTyS6?=
 =?us-ascii?Q?zEHsAt5Zamq21jCf1pw6Ir6OLSdblCxyAKht+dFP+/267sCjYYD93DT4t5gH?=
 =?us-ascii?Q?VAl6QKZ60dy+K6L22npdnqAoUQLBuvaIlQNBuX/IRIMqaGh3VcO8cBY8R7iv?=
 =?us-ascii?Q?f+7R7l2qiRdoJg3d2jQRyYDRtWXulhDwVrB9OTacygasNLWe7jrK8zB8zRIe?=
 =?us-ascii?Q?YSDecR2tKoxi3oVoKJc3xqY4+KDbzEIPRBJDKEG2zgGq8HzPqKEMN/d8lj2i?=
 =?us-ascii?Q?buBZVGHjnXb6CPk5DJ018Wl94R3ecF8TvFyPaD3okBJoq2ibAKuf/CJfS/2N?=
 =?us-ascii?Q?HW25fo7RR5rHOOfJFoswNd/buWX+s11PpxDoaPLvhLnXHDeAXmqzcmW5JiQ8?=
 =?us-ascii?Q?ljQkI/ECom1LgXrH/7l3kqnzw4WG17QrB74EIv/UWD22tJt9MmfFVZCdHIB5?=
 =?us-ascii?Q?jmhCrBy4fd81JU9oX6thUSUaHgQSjiHSCPkUfLQqnzX6BWmLWNk3bWEgtYxf?=
 =?us-ascii?Q?m+8JlTzr0RNcWfc+ey5aWv2UFuFyEtTafhC7gKZgsQgdYtO5DKjnmhCt8xki?=
 =?us-ascii?Q?P70iTGJ9s9vFVdYHRlrjICuzDrGlNKd3o1Cuvg+jvEbu0UhakHrteJXkciFp?=
 =?us-ascii?Q?Mv6gOr96S468K9qyy5AOxHf3lh5E?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LLEbqgqGmhRN5uA+56ST7jOF7yRK/ZIO/0Nb8l5YP1eveF5AXyNZglEokk1y?=
 =?us-ascii?Q?r8SUfDAjq1WoKpUSDEq35IQM448GHirSwheoXk9GAmlwl3KNXMHjA4Ouy9wR?=
 =?us-ascii?Q?r3mrXBYFzgqwh0YA1RV+cqp2kX/VA1DXDkeVhFEQypLfmQakM6vmvQ2If/wd?=
 =?us-ascii?Q?SNwrz+FbYUC398ZJn3G9ZtTDXnqK6QxUtmAidUnhjEZK1vpbsc7tnJv7lZE8?=
 =?us-ascii?Q?SH7+ohYRpwG6aKcjf1+ZRRdAF8y/gaZ7EviEF6qpUHIuZcpx4vHqzM0QsMaV?=
 =?us-ascii?Q?yJPanZdS5e18+234z56Vjr7YDNd+nweJhyHWbpC04fG139Uu1lhT7oQ8HGNW?=
 =?us-ascii?Q?8TxPNq+M1iii4qcHh67oQzaqpSCNj1H4x9mDmeZIOvT6KSxPCdpwHOZ6WJ6R?=
 =?us-ascii?Q?rfHdYQdG0REeNXmsbCAMZ6YrH5BZ6akinKDAWaVQMmsUpPv39JFm5CtDEP+C?=
 =?us-ascii?Q?dvN+g51MrdzoV8NsKYnMcBoxWgqgFy0uu0KxyYBdBtmqBOKLrLppQOB4ekKa?=
 =?us-ascii?Q?PJ6FqxeiRkKoHFzXLOE4Uu4jxVWDby4dwLUJdiKyiPPFoC+qTPtexJgmJt45?=
 =?us-ascii?Q?n1LlMGjDY5RvNRjSszATdV5UIgUrwO1yhpa0ggg3ojxedX9UkmdN01Ol2WEj?=
 =?us-ascii?Q?YE5hRB4YCYp9IJSX8tXblpSI39qcXqXHqdLOKHn4lxSznekBuxwa0R9i39Yv?=
 =?us-ascii?Q?UDMHcnLfHZYVdVAkbliAXgRF0ppI++u6BDiIrT/KXo7mimT501zuUCe1bkQp?=
 =?us-ascii?Q?ffVRH7/rQCUhRLsZaz/wuXnI3b1EhDhIzQ8tb0GOAEcgai/m1K/lOBOqj45O?=
 =?us-ascii?Q?e0Iqm/sQJz1sXaZaur/9m4KGiR8aQ5pScUJErYxCvxUX2Vtuc6gMDWxawsIk?=
 =?us-ascii?Q?BcFo6oYot5vCgsRvSzSDaTRGwbC9meO5g/HIZPHxYqHN4NKwWptExWaSnGKM?=
 =?us-ascii?Q?zot/mAwd3fG7gvm9WHjzC4lQyqWeAC+3T5WTVSRX/bSVG/zv8wuiVJpD8Rp5?=
 =?us-ascii?Q?Bry0+A/Zxcyk3q5T/8Ky3s1LTs++LMvJW+QB9JLffhIJq+XmqbTIzB+GCSKn?=
 =?us-ascii?Q?XWjyZ+oReM09oepjFA8mYfh1uoQB0imScy+K5d0sVbM6CHLcAxT1nbVje+3u?=
 =?us-ascii?Q?2FoZDTNId9nefK6ImEf4+MH1f2ajMVTVqa2ujRGgULN4Gy97nxB7F3hHL4Ta?=
 =?us-ascii?Q?YARJIWhwSkF3xKHda7Og0Je34ysQAwqWOgWrIdPpHJOoniY3WFx63OHkDaPI?=
 =?us-ascii?Q?I2UWCIhkKlMEGA4ecvmWJ46uFFV7wutBlilW4oBiDpvlATjQPi1Ph4xnFW9s?=
 =?us-ascii?Q?JDS/N+E7OG0N62A9nXPK0yOJQ0zx+flQabUG9q1gUQ8K36M3b4b1BZoDASSz?=
 =?us-ascii?Q?GZPycDuG74p9b8kqNtS3XfA0unaX3GeGJ+1Ut5CKhqIuMsftgk0duR0Fofjf?=
 =?us-ascii?Q?81uyoWCdV9iazCT5ZUv2tcI36JuNbMwSAGZ2zaziywakhbJTYOfZ//XdoG26?=
 =?us-ascii?Q?q1M0HbQUZQHE2DHmKyOPQhSvjtCRJ5kODnnXtpX9/ipDv23Qs7fg/omfUdjo?=
 =?us-ascii?Q?LcEC15bM+8o+BDfZ+pvdOizHmZKp+sMifsqWyIXsvrtd36OnKd17glNnyZXl?=
 =?us-ascii?Q?s0FKe4EphAwn9/3MvMYASi6sS1w6dhkbxHjAaToMRBfXjwt1acTbFLjJmMDn?=
 =?us-ascii?Q?ajfvJA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dFYnS2HrO7Ws+vtjOA9R6IjyClAd8GT37oPeolAkq//X10j2M5ayCVZ0B1LUCi2TY4CeLc54pWvWiM6gOpDZ/ckbECsL7eINxlWdaS0LD3djFsiflAjbaTXt8wN9meCvactEu7HWlghYnLEVq8z3wpns0q2mSbg4ZpnLKRsUF4ufIr444pv43693qDYEKFEhIvSYuwtnV3ojp3SBWYoEXtEps9mC5N17uYEZw+fRuW2UAdihTjCXQQNvESZHbt56td93nRPH4yGgkkrmEtHh3LXjmcPVcfN+oCZhERibPEV6d8rx0nJx6+P3aF5mGwjdXF5vTpBtnYjSvDIHCQCiLHdEQtGia54HYT3bIwgPqjVdeGYpv0XkqGAHPB4YzRAI7UlYUxxaMjTL87c8othO4siPqOamHExXkvRBmrpgDesRAHSZLqf2TKlqQE6YHCwNpLgi00kbpeZXIfLGJLUSzXRbW3eAis5Uz94oCZn8uPCY1peFZi5o5wz2VNq4EIO3ycVepMT7Q9d6H0hw8IM8kipQhcwWMdxndbWWyOh9aP/zBMvJOWom5XrdEXvzvAUnGmHsZhOXL+oVsx75hgZMu6f/T2MZrRBYPT5M0oiESc0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ded68a3-9a9d-40c7-fb2c-08dd1f98a4b4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:41.6816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRjjqz93O6vSBRILumgrXCR6TRMU1QeGYabule7/v7luSjdbhwk+JL5JdS17lB30gA3OidUw39hVZc/auma8caExB/NVIwMZ0FXmkWpEsbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180149
X-Proofpoint-ORIG-GUID: -hGvnETYUJPpvUA-_SAaWJYkr0zSgu6c
X-Proofpoint-GUID: -hGvnETYUJPpvUA-_SAaWJYkr0zSgu6c

From: lei lu <llfamsec@gmail.com>

commit 0c7fcdb6d06cdf8b19b57c17605215b06afa864a upstream.

This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
to make sure don't stray beyond valid memory region. Before patching, the
loop simply checks that the start offset of the dup and dep is within the
range. So in a crafted image, if last entry is xfs_dir2_data_unused, we
can change dup->length to dup->length-1 and leave 1 byte of space. In the
next traversal, this space will be considered as dup or dep. We may
encounter an out of bound read when accessing the fixed members.

In the patch, we make sure that the remaining bytes large enough to hold
an unused entry before accessing xfs_dir2_data_unused and
xfs_dir2_data_unused is XFS_DIR2_DATA_ALIGN byte aligned. We also make
sure that the remaining bytes large enough to hold a dirent with a
single-byte name before accessing xfs_dir2_data_entry.

Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 31 ++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2_priv.h |  7 +++++++
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index dbcf58979a59..e1d5da6d8d4a 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -177,6 +177,14 @@ __xfs_dir3_data_check(
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		unsigned int	reclen;
+
+		/*
+		 * Are the remaining bytes large enough to hold an
+		 * unused entry?
+		 */
+		if (offset > end - xfs_dir2_data_unusedsize(1))
+			return __this_address;
 
 		/*
 		 * If it's unused, look for the space in the bestfree table.
@@ -186,9 +194,13 @@ __xfs_dir3_data_check(
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			xfs_failaddr_t	fa;
 
+			reclen = xfs_dir2_data_unusedsize(
+					be16_to_cpu(dup->length));
 			if (lastfree != 0)
 				return __this_address;
-			if (offset + be16_to_cpu(dup->length) > end)
+			if (be16_to_cpu(dup->length) != reclen)
+				return __this_address;
+			if (offset + reclen > end)
 				return __this_address;
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
 			    offset)
@@ -206,10 +218,18 @@ __xfs_dir3_data_check(
 				    be16_to_cpu(bf[2].length))
 					return __this_address;
 			}
-			offset += be16_to_cpu(dup->length);
+			offset += reclen;
 			lastfree = 1;
 			continue;
 		}
+
+		/*
+		 * This is not an unused entry. Are the remaining bytes
+		 * large enough for a dirent with a single-byte name?
+		 */
+		if (offset > end - xfs_dir2_data_entsize(mp, 1))
+			return __this_address;
+
 		/*
 		 * It's a real entry.  Validate the fields.
 		 * If this is a block directory then make sure it's
@@ -218,9 +238,10 @@ __xfs_dir3_data_check(
 		 */
 		if (dep->namelen == 0)
 			return __this_address;
-		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
+		reclen = xfs_dir2_data_entsize(mp, dep->namelen);
+		if (offset + reclen > end)
 			return __this_address;
-		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
+		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
 			return __this_address;
 		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) != offset)
 			return __this_address;
@@ -244,7 +265,7 @@ __xfs_dir3_data_check(
 			if (i >= be32_to_cpu(btp->count))
 				return __this_address;
 		}
-		offset += xfs_dir2_data_entsize(mp, dep->namelen);
+		offset += reclen;
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 7404a9ff1a92..9046d08554e9 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -187,6 +187,13 @@ void xfs_dir2_sf_put_ftype(struct xfs_mount *mp,
 extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
 		       struct dir_context *ctx, size_t bufsize);
 
+static inline unsigned int
+xfs_dir2_data_unusedsize(
+	unsigned int	len)
+{
+	return round_up(len, XFS_DIR2_DATA_ALIGN);
+}
+
 static inline unsigned int
 xfs_dir2_data_entsize(
 	struct xfs_mount	*mp,
-- 
2.39.3

