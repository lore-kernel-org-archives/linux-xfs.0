Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6991DC9B0;
	Tue, 20 May 2025 01:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747704860; cv=fail; b=YnVZcLpM2h3zu+YHCM+x4NP3cgarEW+NI7UH7aH5Kf0v/0M0vWVr3RWwYFc6EwXSvWCAprWBuyltOKGLr0dtfrWsS0uOWwbT9TariB94gVxy+QxvW3Cp/J0hwjlDLXbanVXZFkwYsKVAITexI5Gau0Wy+azOp4e3Js+G3Jq3Xjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747704860; c=relaxed/simple;
	bh=eNqZMczPWgTUFTKqBt8WtuVCs7iQNetrU/kRsl2nm2w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qJ8VesffllU/w4cd/W7JM6ZVDO0+j6awVnpM8q2sSkWQTo0NW89ChrytIIxhfnmKix7zfRvHZC1Ddztyj1MzYJzz01PWUQV6xHZglgvFx1u8ZlXG93en2BGxHGJ40P63zDaTt8nMJj9aaLixIJdsHauER+Ff/nAYMQy9iiyK6x4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D63O+aAO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m0ShAcay; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D63O+aAO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m0ShAcay"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K1MrLC005130;
	Tue, 20 May 2025 01:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rPdQf5/QkTsD7jML0MAxAPO21VKpSypjmOHDQQx0laE=; b=
	D63O+aAOaoWYEht0D8/m66puQ1yfpMa/YceWF0KrF4vTmPUZbo5QQM1RtPLSZeXg
	e5tI1lSaAMmelQmZNOPsa6rRIcc9y8NG3B7ph8qRhpbyiCpcIsBR8n8GI8qD+5E1
	4w0vUSd5VjSx40JIOjRbiprh37WWX8VSeMJPATOXmW36BDLFPAoqHkWz0jUdkkIM
	aGF2qzgv+2gfotM/XoyYdyYV6NeMnVDWu7upfRWB3xFWLLFWuQdw6d4G+7aPluj1
	kGv2WDbYKtWsvF8yLKh6dNTuG+1btilX74/u7SclxV+SJJ15BYLAR7otrR6xp3Br
	MBtY0P8rWRfNllCfwo4wlA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46rdceg6g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54JNloAe037258;
	Tue, 20 May 2025 01:34:12 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17010022.outbound.protection.outlook.com [40.93.12.22])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw84met-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p7WlmuyNcjbwRoG+RFRji6fdQ+Z40EAZvdM9nWdvK8h8tqwmgtNYa60gLb5NMe4hmA98i31jjzEEjhSd01qeR8bt4yZ6zXbOf0h7rr++ivzUR+IULuO+j/cHrWJOgaYX2bcFoqteatz/Pl52mTSFVS2Kk/b/HEX0qpn2qK6dhA55AtwnXWt1gQ0hVhhD8f3hJhQ210WFqKFolOFPgcXGWLwVKcanOe0lun3zWsNlW8vR6sNKZPciLsr/WwAOK/AhvvNM30aZ21Ix5CXGpDVI0qqhzIcdT4lc2L19NEO/DHm9iqweC6mhKmTY3o3K04GxfSfXFVcnWVSMZ+/ocjgP5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPdQf5/QkTsD7jML0MAxAPO21VKpSypjmOHDQQx0laE=;
 b=GQVpWuJRfJpke044ae7wDBZ+KzcEh81VJE2kROyWkbE9X78pTktGAWnVJMVwowU9m8DCuBczaX/cx00+yDRZj88SBJQtp9h23Zv+MzWR27AeUq0X4DSebZoKNEUY0CIJNF7UmmS+E4zBpMXo6NXfpuqH3A7xg4hCpaurqLBr2hNxDSDk1mI21k613V7CaF8EBXxTfNB7wUhSiHUHr3ScOcOHNApb3+qp/qV3zXaOa4Hqk0yAe6w1eZDzdot0J98avc3v3gJZaXX10Q8noXU9Hbvk4lRk6FAuVsVGFYkQSQZ0iNPVLfqsv4FkPYVviR3nVUtj10S+kIgFAVew1LoUNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPdQf5/QkTsD7jML0MAxAPO21VKpSypjmOHDQQx0laE=;
 b=m0ShAcayNaK0Px3dHgfMFbs17W3mXdfHOdIo/yN7gtfgiENUC3F+d5F4fuW2ELbeAcD4aa/RbPK0pC9ishzkMFgBH63sann0mrk1aGyHtGy14sOatpjMPln3nwlCdqitvkNj1Stmf83XcZ+jx5sWBcRKPnEy3Spx7wN4DvwXwAk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB6639.namprd10.prod.outlook.com (2603:10b6:806:2b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Tue, 20 May
 2025 01:34:10 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 01:34:10 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: [PATCH v2 4/6] common/atomicwrites: adjust a few more things
Date: Mon, 19 May 2025 18:33:58 -0700
Message-Id: <20250520013400.36830-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250520013400.36830-1-catherine.hoang@oracle.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d87f4a9-87ca-48c7-4713-08dd973e6b5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f6JPIJW17S+DHHTLUJE4cwSC9Bjyy8T+kfxAqOM8QFEdsRb9AyIYaoCUZT3p?=
 =?us-ascii?Q?9H0xxCo2rjk4t+hefB12t/hB+5aSDeUWRFcEmW7MY9+DF5l2AguV36Q1hutH?=
 =?us-ascii?Q?rzUtGpUSJWoxBLIcs1b9APEnH8bsYQBtSqbOQib45OV2VMgQasXihgWYmtYC?=
 =?us-ascii?Q?BykmZZVI3pARAbK539Yza6enMQ+TBwouMZSlrBivD80GUyisSG5dYpCwT+qA?=
 =?us-ascii?Q?y1qUOgXfraBnf5e9ghCojNgyHgzfluxfilOky1ZgQl9BXU6XrxbtnB4Cfjh7?=
 =?us-ascii?Q?tniDftkGW3KaU47BtTr3OIkwjIplVvCnRgPftU8PmoGQHaB7U8Gz0uxOgCYp?=
 =?us-ascii?Q?lkSIEHpL7xEQTCrzlbcJFQS4ruAhs9OB/51XBRyUP3uHS93e5VkDeb2CshQI?=
 =?us-ascii?Q?CbkZSTQy07zNpRjShUGDglKPx2/yQGriJGB4kXNq/nwC0wyMYWSt26RBajBC?=
 =?us-ascii?Q?k3BAFlYbpN5UEUtJ4a605x4V1uecbJprG8SrILNG7stH0Bsrku59xhsocBq1?=
 =?us-ascii?Q?coXarwEerOiB/HWjHmy7UyN09v76rG/0UomT+/WVk9Mda5445J5c62G9+2nf?=
 =?us-ascii?Q?0D2uHFyFMC2ZaOoFmbA4GDgbRCJrRDBbEvdlx+8s2bBiEgUtHEZ0aUjeX8Xr?=
 =?us-ascii?Q?LWhcFH2CyPwnDjkpji67NIelmTyhpXVCtegel6DGScVTrSnV32g8F4dJreer?=
 =?us-ascii?Q?4fPwTrbNeQt5ZWIAYHTzCuXGxbptNo3cgt9A0jdgcEgZktBCzZEXuLZNd5ou?=
 =?us-ascii?Q?i+gF/MsFwcxZ084JS2pagDp1V8P3kpgzXgbXHM8X3+dpMR4cla1N0MUlpqzL?=
 =?us-ascii?Q?kgyXGQ8WMi9bUinP5WS3f2O7u7Ll1M4K5Ozps4XebeT8mYPQoUQlsNOuSQI5?=
 =?us-ascii?Q?exuDTNKKL1tcVQdgJ2AlHlkty1hvtFNnFDCF2x0owS6hyk2Wv2wFHvgogAdL?=
 =?us-ascii?Q?K/c0q5ouEU258Oi/kqSsYSQ0e7LSP/ZTvBPmk8YhVi7nqIPwfU3SY8liXGj+?=
 =?us-ascii?Q?YdvJ9sX2WYh/RNfpmo63NqW05WaTdVMHwAJZmsG5ZlmlM7kmDJuGgma2Vf4P?=
 =?us-ascii?Q?5pag6EpbiYl0nI5b4rncUPrAWrrc5/mLIeuevYuxocuDhQluXlVuLwHMwfvY?=
 =?us-ascii?Q?cfbFcI7vNH11DSZzuOUK1VK8l2VN0zfSEfympA4nKcjtuQXFVEwxHeMYeGhw?=
 =?us-ascii?Q?eQYh9/IJp+IgHyI1bQbhV5U0f6nZNtWTl6IvawNo2SXPCug98gQjeviooANW?=
 =?us-ascii?Q?hTuJV5yLourgKUyG9BOiqw71xuIIAwnfWSUuKXuQ9J4TMv7EAy4ZWiWC+xYH?=
 =?us-ascii?Q?x0DLn75JWADBjrYfJU7dK83lvsDTErBXtglgzufOm3cSQx6Doyo84+ZmQZaR?=
 =?us-ascii?Q?0mCnt082NxT1ABgobYanZ0/K+jIBPbzMHNK7M/ZbnhYQrta4jPFaNyHzZtka?=
 =?us-ascii?Q?TzIUcjcT17g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2A6aiugsT1n++cROCuy/yX5/3kqebRk+Ai/7N9s6IuYSWUfbRbJ5SMFb6j+I?=
 =?us-ascii?Q?qzZ6K1sLNkRihWENiD8olKGQ4RgjIoJxbGvqZcotymv9ocMxCOmVWIYAO/jQ?=
 =?us-ascii?Q?af6mc3Lsuxz3Snf/e2YylCI5DnVnjuSv2zHuAYOXwwiURiwFkh548mONbaOx?=
 =?us-ascii?Q?ZeXxu96Wk67L+mEt5DEt7WlN0G9NFvSLHEYfJOAWwCQAa70cLyYraFf/C1Sb?=
 =?us-ascii?Q?gUoQ+nFSSboJXfEVNEUXFyDouM4a/y2Yupy3t3zyD61vF7OjRk9f8XS0Ozi9?=
 =?us-ascii?Q?Jf+CRMLo/0H5ReM3AqG7RgrIFJuV8etEidQAo+TFPrDV7VHVBfA0x1IXvWjn?=
 =?us-ascii?Q?5uotwVm3IjlaR8TSx5Gnosn8qH/fC41vPyu7C+G/m6VZ438ueOi9qZ2Zkv8m?=
 =?us-ascii?Q?4PHhGGuJIDSY1tyn59jem6r/J4u7UJ9m8t6RhiYXHzhjtjipXkpKh/UHrA72?=
 =?us-ascii?Q?VzhJPcGpLW95ouViZlCfXy0sdGL4a0bQoFrTi1eOyiUBWBslbyEUxa9lWvpt?=
 =?us-ascii?Q?EgLsqmHghT0rBnKZ6Sn7/p+iwb4z6kaWOXZwIHEPqSmQrvJwmH97iPs6DSTH?=
 =?us-ascii?Q?y4ThShtHCV5+SMoKEtNbihBxG4knBWU+ns9sx2pjF83btPZndAzP7IgAI8zH?=
 =?us-ascii?Q?0RtU26m1E8rJ08Gqab4UiUPz8Wdh9q6TkU7DzgugPva7yfJ7lz+WUYOuFneK?=
 =?us-ascii?Q?sYgLm8o7iy/f+G7oOBMHdREPqoKqINrt8zIMadmLA2528FvVj/g2he6OvkUb?=
 =?us-ascii?Q?dBEoCU/MkWyiDu5Nll4AqMjW7gcylqcunIoGdBb1ulCCja1jVgkaDmpt7zst?=
 =?us-ascii?Q?ep8+JA0vbDQH7mXI1W2VQJ+n83T4jqtdem+rb7TPIm4CN4WiJWUdkB6TEQpU?=
 =?us-ascii?Q?Q1skdrDGu4h+QH+gcglDR5Rrs6nsZGQ3RxJ0IB0+bWFnytv6NDt1onv7geyS?=
 =?us-ascii?Q?k/lkkYcX7sUNE1FltFusa3IkB9rkOh+M24suBB98eFZz1RqR1ucfsdaaBqwT?=
 =?us-ascii?Q?XnS4muOyidljm7CCOjPbtC4ZR/UhOqwHkIqOmQRzD/AqyskAVWFPoShd5u81?=
 =?us-ascii?Q?rsLGLzMHnxSZx75Kwaa7GKah1/23MLhUALtHyKWNZaRqcfbD1+ZtUxQf291O?=
 =?us-ascii?Q?PEfkS2tndCdnqNTVEbx8VAic31AFleLrGehcJcIWvroaFxM6tFQrqel/3/j6?=
 =?us-ascii?Q?JfhlJDPEVC/vhwQrKmoEZ52WD0nVou6421l+gk1UmaolbJQYTCyd7+kbllXZ?=
 =?us-ascii?Q?H5jH8PDpTSAlag/c3tWKhnxzOFUv/k4xaEMVoyI/ce8xFAOypINN33YY2M3C?=
 =?us-ascii?Q?Mv7MDfsFUqOdKIqSn+euHsGy8kCq1eG4+Xp/FxuAGA5hoex1WjpGsTwBeSgq?=
 =?us-ascii?Q?wf7Md6lrAUUs2IbQD8GMGZsYq+l7Upz8nuBZFmizG/DsA24zSQzKh4LkYqdC?=
 =?us-ascii?Q?lmO3ek6Xg5xAZj81dNGyrptFjzqOaX7WzcGxBKvYROhKDNQfyIXEA5rg/lWQ?=
 =?us-ascii?Q?f/DSBFfuTiJaqd3BLHTXn2SFZ8AnjKGse0MOhGgC1EmPIDkaV5npbVRTiwNQ?=
 =?us-ascii?Q?9klIb/+GWwmAnjVC7/trcPISguw34wyMQRbXvqhR3HGzFbORcgUHROLOWVbh?=
 =?us-ascii?Q?iy5rD2ZYjG62rEiwGlca6HgsqpJK5l0aM++uaPRB6LcpdU1QqZNjEXxBZRtu?=
 =?us-ascii?Q?tnplzw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XraHrBkUbZDLVd7GSOXzXYCheHRm23DvSol1+OXGJSyWLq/PPLhz3F4tsktiJap4VDYV6wGJyTOb0744XNH0AbQqTIbMFaktJHIrgGW+WsyllTdvpyfe67Cj67lz9xUCG0XMc4tVDVhhYTRUjCVmT77hbDIBKz4NshnvV+nddCRwWgPpXeEk6vq+WhlHV0R5BfKRBZ13piWznkbf9yQOPzJmJW8G8Iv5N9YEd3K5g4QTMhT+IWRa1F6EqjETbMIVQWRGCQGf6g1ZDC/I/PKFDHqfTNjC3riEmnAkRqiX9aiDOggO7ixK/ph+AA1wL8W9O2L2rq95wSXVVn9dACvoEMOmWTeVwsiz2zWtkirCn1CI9jKfY4ok05TxQTLAq3BIHaWRfmKNek9Yv7TOd7pxsdwAITd3t+WBBXiycZrtCJTep5BIih4Vj/er4+WzE84brBTRWArPEsEyymM9g1ipHDDP4AVaDJcF0GKX/fLPogQ4RgHpMsblCilNPdCZIh9jldgaWQONqExDudbItsj+a+69gy06OMxXNLM+vaGQJqwTMCuGt6d6+yJzS59BHRIn6kXNMjnG/1UXepO+a8jVOUggd2mhbCf+MOSjbzmPAQA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d87f4a9-87ca-48c7-4713-08dd973e6b5b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 01:34:10.3177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDF9P+04FiYbRBjv/aHjjs4DQwcR7VTiB2iLfFJ+oQBClMGp8NzBzGsNVGKhWQGkV8vH++RNCGhRsgn/ufXCs4mwG6uApzRrTpS1SD+qgbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_01,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505200012
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDAxMSBTYWx0ZWRfXwDWMldfX7YOH FdgdzSnfLM+NSJpS+903oMokuS6CkxYUnriLyqCh4wApbg4NbqJ/UCGW/4T0fd4bQzM2tPqkIDt TmDh3NCbEsGySF0gXh9TGfsrH4XwILw/izpHUju+Ee0BAsE+fVpQt0CWM7UuGk9HYZt8a1+S7ky
 /PxI66IYmJOWUOpNzvOG8139SZtSfDEbqFw41YRJupkL+kcc2Txb4w2JTfmRKUYVjBdTefgSTwY 66T58xtRI2Uan+lHQMG1OZ87brXnWInkotM/nEAnGcKkzjnZsimHo8gaPR4bmX8nhID2Xrxb6+c CwImDxTPQrx3GVgJ1b7feeh9trMT55vV0S1jnPwWSKXlSM1NmOKq2k/u6sW/7VWNWZJ7F+McYQP
 Ud7HyOJLI0qrTVBN6PrRhNDApSiPft9RVylaPIryMwN4qHdT2lKhBGV92sigZxhxTAGe0eZI
X-Authority-Analysis: v=2.4 cv=WO5/XmsR c=1 sm=1 tr=0 ts=682bdc14 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=-DNM3hN0B_qGNDMabmQA:9 cc=ntf awl=host:13186
X-Proofpoint-GUID: ksAeqH0SUTl8fiRSn8Grhg0iay4FHZCu
X-Proofpoint-ORIG-GUID: ksAeqH0SUTl8fiRSn8Grhg0iay4FHZCu

From: "Darrick J. Wong" <djwong@kernel.org>

Always export STATX_WRITE_ATOMIC so anyone can use it, make the "cp
reflink" logic work for any filesystem, not just xfs, and create a
separate helper to check that the necessary xfs_io support is present.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 common/atomicwrites | 18 +++++++++++-------
 tests/generic/765   |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/common/atomicwrites b/common/atomicwrites
index fd3a9b71..9ec1ca68 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -4,6 +4,8 @@
 #
 # Routines for testing atomic writes.
 
+export STATX_WRITE_ATOMIC=0x10000
+
 _get_atomic_write_unit_min()
 {
 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
@@ -26,8 +28,6 @@ _require_scratch_write_atomic()
 {
 	_require_scratch
 
-	export STATX_WRITE_ATOMIC=0x10000
-
 	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
 	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
 
@@ -51,6 +51,14 @@ _require_scratch_write_atomic()
 	fi
 }
 
+# Check for xfs_io commands required to run _test_atomic_file_writes
+_require_atomic_write_test_commands()
+{
+	_require_xfs_io_command "falloc"
+	_require_xfs_io_command "fpunch"
+	_require_xfs_io_command pwrite -A
+}
+
 _test_atomic_file_writes()
 {
     local bsize="$1"
@@ -64,11 +72,7 @@ _test_atomic_file_writes()
     test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
 
     # Check that we can perform an atomic single-block cow write
-    if [ "$FSTYP" == "xfs" ]; then
-        testfile_cp=$SCRATCH_MNT/testfile_copy
-        if _xfs_has_feature $SCRATCH_MNT reflink; then
-            cp --reflink $testfile $testfile_cp
-        fi
+    if cp --reflink=always $testfile $testfile_cp 2>> $seqres.full; then
         bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
             grep wrote | awk -F'[/ ]' '{print $2}')
         test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
diff --git a/tests/generic/765 b/tests/generic/765
index 09e9fa38..71604e5e 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -12,7 +12,7 @@ _begin_fstest auto quick rw atomicwrites
 . ./common/atomicwrites
 
 _require_scratch_write_atomic
-_require_xfs_io_command pwrite -A
+_require_atomic_write_test_commands
 
 get_supported_bsize()
 {
-- 
2.34.1

