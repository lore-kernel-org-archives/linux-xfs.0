Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291B721FF35;
	Fri, 11 Jul 2025 08:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752221416; cv=fail; b=vBDLs5SCJNFq+Gh1/KsCCYIIkaiZj4nAacfntE6U1cgVTYZSG2BafkUbjCRDQwmyMLsmdNcj1CRowCaS+LDtzDc/sbsiVcJkV+9o5diknIOnLF0ieykcG4LwbLfh7jhvV4EjuX9L2eqNNN7AVo7+t7JN2pLINX3o4KZ9Xbgqxw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752221416; c=relaxed/simple;
	bh=SMmCvk6H+TIusZ1+coOYl3/NZhOg+Ehno8X6dK/u38g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IWI7T6DKDlCcVa19uiJCHLobvpm4NwUEVAd8dNvX0MqXeBFejGqZNExEQxYVJeQ0LrFMfhGiStbUJCGkNYhGXCcbYSfsspx8RHYJOs2zrGwJjApn+0SlRo/nbsfeOYDTNsEHBSNacPAOubgP/CqqzVPsznXxz1Hj7rBhhO80UUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eK4JQXIE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PCdzPtCH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eK4JQXIE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PCdzPtCH"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B82P3C030678;
	Fri, 11 Jul 2025 08:09:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5QXHlASmi9iq/b8XMJmHV6SIUWHxkQAqfRC4IVWvWms=; b=
	eK4JQXIEz206Gc6n2O+PZww/ab1PoQEgAtYO51HZOhLqxAxPmmTkfOtUh32TJS5E
	bFzXgnTEzynvnLabEGiXqtlwzkAj4ef5KbeqWx9Ijm7Mx2zL/dUQLjcAp4+z3civ
	JhXcGGfpcCrDJHNX+9lwXL1cRgs63IOpaLHn5CfKncdvPbh6wjhPDiWyteQPmms3
	easMhH5C0QGebJDLcU0xvlOHBzRXtNcbmEEh51DZFUjXc/zL/Q3PsKiW1cBeN/xe
	ni2ckJPGLq2tsScwllhcDovEvXYzmwZ4mu0st4/zmUjBaVvOcWNlrrnBBb1Wzmbv
	kUlyYmABmMCYMvT7vqQg7A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47txr9r0e3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56B86vNU039906;
	Fri, 11 Jul 2025 08:09:56 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012000.outbound.protection.outlook.com [40.93.200.0])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdh6k9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ls6L4Y3f6Koza9jd5rKsqyl5Dff/hWVDJi62nLD+bU1O4O+e/GL/EdQ1n3sjfGEEB0sDaWttwKahD1O1Emi18BT9WAT82smx3e8uCzUTMVA67zdKeFFK1tHX6MAWhZAdY0B52hpOGg25xjzxr4MLwuxImkzyhlnWrZ4WzzovglczfwYVPo1y2++NbLed7FPhJufm2SJQiC5vMrqZ5FsERmRZ6SDEs43ZLdWx8hrKu+GjaDfmexeAwFBBlaFd2Idf4gx18jAs8oiSCV0P2jn0eDwfP49MSC5+ov6LzWSXiSvnUBJlbo2Vh9mLuiM4igeJrR/zFUDDjLbMEjkFESSvsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5QXHlASmi9iq/b8XMJmHV6SIUWHxkQAqfRC4IVWvWms=;
 b=ho1ILr6frnnBIOCgsoZHzFY0pEus+LcnmpB+bjhpjjnsQEUVgbck2XwdSFF9cDVRLHxysrnz1YslsoPr+/oFUOsAe6NS3XN09FSoGbfkbgAvkQtoQ5mBbetRqZbfxft224lPBB9hE7SXN1SYjTdMgudOM3XjRpYUTGtVW6b3/9kVVx9R8AlfuGX3ac9Fe1jwvH4/r9D+EE9O9TIcxGr2RCNprzlL5IdB6GHl7Q5xccRNU/tpZAyPGpk36Zng7trtamjHy8InjYFKehYwcEF0Pt9cg9ZGOLdOc9wUI/dbLY+mKKrF2nADU91CQqhx+VtpCtRgPYCCTmyv9z8OMk97wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QXHlASmi9iq/b8XMJmHV6SIUWHxkQAqfRC4IVWvWms=;
 b=PCdzPtCHNWc8gTGOFmo2OnrfFQveqsYe9ZVRFEwUqkzpj0ciBfjJ8EwXl2h2beGcKMs1JpKNg8d20NxOLbFBkTY0G3wEEckOCfQnFRWGPCTHaI4ANmBkdh4yIoBqMrg+xjJCQx2j7eUgr3rE7gK68iH1nrydJ7d9eS2cKgLOpWo=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ2PR10MB7559.namprd10.prod.outlook.com (2603:10b6:a03:546::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Fri, 11 Jul
 2025 08:09:53 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 08:09:53 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 6/6] block: use chunk_sectors when evaluating stacked atomic write limits
Date: Fri, 11 Jul 2025 08:09:29 +0000
Message-ID: <20250711080929.3091196-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711080929.3091196-1-john.g.garry@oracle.com>
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0207.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::32) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ2PR10MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: 133c173d-349a-42b5-5e96-08ddc05250fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B+u0MdQcP0DIfwd6xHpOZFMrFOIcYhmQaNDutqIXtDbeqD/m0gXrDrEHIpxm?=
 =?us-ascii?Q?9N0q5cZ14aDbW7T+Xk1bqRlBKgH9wlwDw3fpmoyO9rwNok5iLcQsAQ2YAuA5?=
 =?us-ascii?Q?FhE1Rtjsffs4hjWaIBj8HhDISw7YfKPnTg5D0UzC+NQedswDxr+HcW5dYGsa?=
 =?us-ascii?Q?FjnP7gy8Rxhu/Y3XezLPFoGQf6vlwbnL0tZi18wSv1Bg3fEhp9OdheS+8u+p?=
 =?us-ascii?Q?6xi/WWDwQPCjD/mNf8IFRgx56FZ6xttufMARJ0N+UMmo8IQD3isnmQ4nFRzO?=
 =?us-ascii?Q?SZ6HC+2UtEQKwnNw9U7y/DQ/v3Y5iJJ7iITdldUYY5LIaA5kvif9O0er0Qb9?=
 =?us-ascii?Q?b/x5+X5Jcj3eAAfesho256b4AmnmY+wue8ObmTnsNhbhXqcj7D4aqxm2D5Pp?=
 =?us-ascii?Q?gcvnUGY5YvZICXFoKDAmU313iQbfaiWojiyrqgqy5WHFyMIyOcKb5E5go4aL?=
 =?us-ascii?Q?yAfkURi7x7EEo02h6LY+S/T/kiaJ84O6fLT33OKl/uAxW/DzmAFvDMO00p4a?=
 =?us-ascii?Q?BrX80l4SOiPr1V1R0NP2cb+50GsTo+WWFPC3tcYFqeJJg1bo5DGD5l/yqWSu?=
 =?us-ascii?Q?nHVEKlsGk3jUoH80cHph3JlOAEq7Y1PVHYz+etpeqaJbYysRVXTuNv67PWju?=
 =?us-ascii?Q?Gcw5y3u88O8wFLQFiYugqz+ags8vQv24L6EJ7OoAwWo11Q5eyrRyT/828v8f?=
 =?us-ascii?Q?a7DpMAJh9ereZewjB4/1rOs8BweBMiyBpf/SBppKZBeGTIkQiZbKEpI8Xs+A?=
 =?us-ascii?Q?oVe5iWS13DCVgNy8is3ZfAZFCholWjsIsMHNxArWW0r+X7xDUHzx22rDnIlK?=
 =?us-ascii?Q?iBUCjZ51oMw7K2R6sPJ2zz0RI9RrMBtXd/ylYPpZyh2zEX61FCsl6qrLMn5R?=
 =?us-ascii?Q?mxaH8iApFrKYMSa3hq9u0t3gc8B8btdZw61zfoIlqxYsFtq49U2QhG1BF7VX?=
 =?us-ascii?Q?AgQMsr7XpoPHYT27lhxDg4FDwZ5wIiM6ckwzGHFu6ZeRJzo3YzWovfekZXrV?=
 =?us-ascii?Q?z7FrgsQ6ZbAsF9gNBQbtTpqE9xP/DVsVQWB9SDefzwCNWva+WH+w5HqGZgaF?=
 =?us-ascii?Q?qtpDX7NfHPn7FlJZU34mXWq7f7HJDCOSOwIL1tb2WExncXFIoc/nR0EsZxim?=
 =?us-ascii?Q?ATov68tHk6g3w4LOOCAD9tHrHiY18pDe0SnbkE23vuAF7+OTDH8z3DeDkawM?=
 =?us-ascii?Q?sn6d4COPhxpwg7PrJ6fkaDdFekuvDA6W0CNEL3jCEsqa6eMTuMd+esAOhchN?=
 =?us-ascii?Q?tyhT8OR9MhYeA+Xu+t5l22xOjf63+oyanEHeXnadPCMeLCSFNFgYgxQi1R8Y?=
 =?us-ascii?Q?cd8nMSRekzwQcnVHs8cQyd5nB2HvSXersN6J+Uy4ZD6+AoPdcVpSwI8aRVtd?=
 =?us-ascii?Q?dkfAMN1uLpmNn1HA0+ewnxBniCOi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dbUqecCXzQOKGq7aKBiLvRdYczbbjNR7zZNtU5bPJ3UJvohNUTm/8PNKNS/U?=
 =?us-ascii?Q?R8PsFx19hUzFo9SLvIaD+2FiXQx+AAaJLXdpU6yUX0Fg2uyFoNFzmEVLoj46?=
 =?us-ascii?Q?RQETyYaIfqRd8vBr3Ij4uea7SEMmijudY+j6on7mACsm71e4jwpnQc59gjy7?=
 =?us-ascii?Q?F3avil1wqMr5u/9C36aujOHMrwwpZ0fMsfUxPYo8M8P+H4S6ArozUTotMa3K?=
 =?us-ascii?Q?b7jO6M4MYhAZkGEE7NCeNViKL+JR4s7XE7Ng1cZmRbHW8fNkuLY9IDZmrYM3?=
 =?us-ascii?Q?zt0dX1Tb2ucXW9ocYJ4p/hDbINyXjLOxtr/zv74dv4IoNmW/HL6uvNyUkXJr?=
 =?us-ascii?Q?RtWLcP+CRAlQA04rvtZ8rstUsVgkO1ISyalUHZ1o606K/hrG0/1GIsIQKip4?=
 =?us-ascii?Q?vcogdKpfZVkzPAcy05ZTfV7mmR44wnelVubNLthiPnA7XNoiYrxfy/qFtnV2?=
 =?us-ascii?Q?bihA6Q3eAjA5eadDwfBJhRbcL9nzNb6MTm80yGWfnziQD887U7JxTUx5b1u9?=
 =?us-ascii?Q?22YpbCQ6Jv5PSv2F7e98Nb8C2qq3hqu5QcJECr2M9UeyUX6ucn6p9mtLzjZf?=
 =?us-ascii?Q?Db9o+u6vEBN7gEFYaVopj0qOzoMjZ3sBuJa7B1X6o2gYtm1MWkZfacV31W/E?=
 =?us-ascii?Q?tEDtHA/RNusm/ldcepoO9nOXKBF2+v7U12a+ieHLmw4H/ztSg69tICC+wPQx?=
 =?us-ascii?Q?TxogfGlXBYXxU17UNHcw8klcXjpzn3j/QXAq+5C7qLc16Pva2+rJhYzZ0IbQ?=
 =?us-ascii?Q?QfagDPsem0h/bhYZ94ckEtpyDOfi7qpbRVEn8qqggxT/RQPhHGz8say+XPU4?=
 =?us-ascii?Q?xCAd24sJSB23TgC0Jj9OBfzi84+t4Hv48gRa9c6jElaOX5UhWhQZd7+B7tis?=
 =?us-ascii?Q?b+/QaqriOKMvJHYUDUhPZx5KPFCrOLS5ht8uam9jY/Z3mA9B9GyGo/CHyBPZ?=
 =?us-ascii?Q?/WrSbXOnEcuhVUCk6vOx4F14rfgkBT9XJFSzO7KNz+YnqWgB5Ta8yBuPgL9e?=
 =?us-ascii?Q?yDE/iKlu8uoiAeBMllNBTgjRBu/sVoMPY/VykNWRN0Xkjj4rDu/jsKBGG1CV?=
 =?us-ascii?Q?Z3sqAszIbTvbcb+1KDeZQImpGQ8h4wzieLb3Feh8NOkEM/9nt7R2wBxiav7X?=
 =?us-ascii?Q?O+YGn7OeKO/SUK8MqY9N+1y6z0QkxBkiMXWghSezVu3LlD2D2mgvROFN5n1J?=
 =?us-ascii?Q?tfxGrdaXxmC/Vdt5wR6+7r2zYaHsyuWO6TfLU2S6+pTOhvduJy03KweSP/NI?=
 =?us-ascii?Q?KuRFJatPbl5KFrdd0X6xOC0gaOU+FKlGoluH70k9QBX3XtJLTLH98VT8ksQC?=
 =?us-ascii?Q?kivlYfA/N/UXj2nU+ZcMh1rzUuXE4PZy7s4A69VPEGDWcWK18y1bSv7cM3Kp?=
 =?us-ascii?Q?3mvJyvc+rXm36wWyZsVZRKezsmq0rUazyQjsgGllSWIybUjGrCTuZUPivf00?=
 =?us-ascii?Q?Xt/mRZMHDNjw5guIXqJP3kLjJUF31WTp25Odd9qlaLBc/9DwOAAlxBeGzOGU?=
 =?us-ascii?Q?aPhSyOAZno47GDWy4IvakEAgx9B9rOvFKMClbqneuEOIix4c8/R/tvzZXvk3?=
 =?us-ascii?Q?UD7SfK5rS10oj6WlPfO+mLRvKTbJEBv6KgT2z0wYyEvPq/jtQJPsgH9KETWm?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cAzXqGT0EkQo1x0kheXF+amqwHBM7KpQ8xiRv3CCV/6iy2Ku/BWX16i5fuQNNDRnkVl+j5Jjn76fqRw4bmMpjWvwC0/SBoQw97opYennr7egixPqWlWv3/Ja7N1SQoPYL8u5VV+NTE4eshjiFOsjEM03zOTDVc3kXSyMNkQ56UCbVnaLNlB6YhJ91QoD3ZjT+5mmpgh9ltv3l+ZPLII53wbLiegZyFEqAA03VagTg55rmH3cAL8DD4oBBQAdxPQKJncph0PBLvs0KinSjrWRU1hty8aW529LiI1x0BBuCnCz1bAmN7vImAyKyCBKsZYfiY7/NQFYD4pUKPFVK9MMzZRlLlImIcH/WeIiwzAI0dihKLXAvF1dDqswCdz4GNu0JE/QUF5lpXG49nq0vJgLgV8JYP/h/a/m3lDjd8y7S47wJxmsirnpi94Z34NbxDhbpY4Bi7G1SehnFMi/o5D6xLWbLvhtC0wZcljywW277X5uLJA7LH3SFe4Szo0oWQJKsXKgaWs/3egG+UcS4pe5JNkRr7bxzmUENLVbtQERKT4qPQFoRsHspdouNpO55Cf/OFkxwRAhk3zS6sFMFMOHG/hf6nOd9NZSx8kjoC/2Tk8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 133c173d-349a-42b5-5e96-08ddc05250fb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 08:09:53.6200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAh1mqj/v83OAA2M+x76tiTLLcyrnKmI0bNpTS/NqJb/6kalLmnL8D1QTjaVYC7kUKGOlgVY5V3vz2SNMtoKzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_02,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110056
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA1NiBTYWx0ZWRfX69X/ii/Eg84V FUB2b1P/OIA/2NZzCMMt3GotUuA1DzDG0GlMkxw9jYkcy11OargujRR7fLa0b9JsxSUSp7/HzI1 BqcY7Qeg0MW3hwruFh99OshAHTULwfhkdViTFNFd2Gar3z6zwgCBu7y3ZmnvFvD3z2NIsYpVtbs
 8+P13xTTsdPajKZgbAsFpt/PbRsgZM5L9PC36Kg640C5wDCPG7E92z3Qml1MkTE4+M3mzkFU+lj B9jZXP/Vy1B/thMDIxhl8F/9cyxSPHSNcK5GaEJKx6ys5vGELgmAAVOW6rr/T/hVjpNB+QLlV6v A5Buw5SUACQuxyPj95XjEIunhVbjkQsYOCaZEDoWWk5D+W0FY+rLDx8BFBSd8UZpXkSbOFhssZY
 Ttask7HVt2U3/U2WrErs2Cj4eKuhdUPBxDoaNuRyV96oNpHJKSmqCkRfnDWVFiTNL/XKrT+R
X-Proofpoint-ORIG-GUID: gftr5ChuFR9lRkkZY7tZVxLgYi4DyDlJ
X-Proofpoint-GUID: gftr5ChuFR9lRkkZY7tZVxLgYi4DyDlJ
X-Authority-Analysis: v=2.4 cv=OeCYDgTY c=1 sm=1 tr=0 ts=6870c6d5 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=Vx6Y8ZnjGDVhUwe7cXkA:9

The atomic write unit max value is limited by any stacked device stripe
size.

It is required that the atomic write unit is a power-of-2 factor of the
stripe size.

Currently we use io_min limit to hold the stripe size, and check for a
io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.

Nilay reports that this causes a problem when the physical block size is
greater than SECTOR_SIZE [0].

Furthermore, io_min may be mutated when stacking devices, and this makes
it a poor candidate to hold the stripe size. Such an example (of when
io_min may change) would be when the io_min is less than the physical
block size.

Use chunk_sectors to hold the stripe size, which is more appropriate.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Tested-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 56 ++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a2c089167174e..2e519458e7b1a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -594,41 +594,50 @@ static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
 	return true;
 }
 
-
-/* Check stacking of first bottom device */
-static bool blk_stack_atomic_writes_head(struct queue_limits *t,
-				struct queue_limits *b)
+static void blk_stack_atomic_writes_chunk_sectors(struct queue_limits *t)
 {
-	if (b->atomic_write_hw_boundary &&
-	    !blk_stack_atomic_writes_boundary_head(t, b))
-		return false;
+	unsigned int chunk_bytes;
 
-	if (t->io_min <= SECTOR_SIZE) {
-		/* No chunk sectors, so use bottom device values directly */
-		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
-		t->atomic_write_hw_max = b->atomic_write_hw_max;
-		return true;
-	}
+	if (!t->chunk_sectors)
+		return;
+
+	/*
+	 * If chunk sectors is so large that its value in bytes overflows
+	 * UINT_MAX, then just shift it down so it definitely will fit.
+	 * We don't support atomic writes of such a large size anyway.
+	 */
+	if (check_shl_overflow(t->chunk_sectors, SECTOR_SHIFT, &chunk_bytes))
+		chunk_bytes = t->chunk_sectors;
 
 	/*
 	 * Find values for limits which work for chunk size.
 	 * b->atomic_write_hw_unit_{min, max} may not be aligned with chunk
-	 * size (t->io_min), as chunk size is not restricted to a power-of-2.
+	 * size, as the chunk size is not restricted to a power-of-2.
 	 * So we need to find highest power-of-2 which works for the chunk
 	 * size.
-	 * As an example scenario, we could have b->unit_max = 16K and
-	 * t->io_min = 24K. For this case, reduce t->unit_max to a value
-	 * aligned with both limits, i.e. 8K in this example.
+	 * As an example scenario, we could have t->unit_max = 16K and
+	 * t->chunk_sectors = 24KB. For this case, reduce t->unit_max to a
+	 * value aligned with both limits, i.e. 8K in this example.
 	 */
-	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-	while (t->io_min % t->atomic_write_hw_unit_max)
-		t->atomic_write_hw_unit_max /= 2;
+	t->atomic_write_hw_unit_max = min(t->atomic_write_hw_unit_max,
+					max_pow_of_two_factor(chunk_bytes));
 
-	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
+	t->atomic_write_hw_unit_min = min(t->atomic_write_hw_unit_min,
 					  t->atomic_write_hw_unit_max);
-	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
+	t->atomic_write_hw_max = min(t->atomic_write_hw_max, chunk_bytes);
+}
+
+/* Check stacking of first bottom device */
+static bool blk_stack_atomic_writes_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (b->atomic_write_hw_boundary &&
+	    !blk_stack_atomic_writes_boundary_head(t, b))
+		return false;
 
+	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+	t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
+	t->atomic_write_hw_max = b->atomic_write_hw_max;
 	return true;
 }
 
@@ -656,6 +665,7 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 
 	if (!blk_stack_atomic_writes_head(t, b))
 		goto unsupported;
+	blk_stack_atomic_writes_chunk_sectors(t);
 	return;
 
 unsupported:
-- 
2.43.5

