Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCB620B80B;
	Fri, 11 Jul 2025 08:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752221408; cv=fail; b=KMtK3qrNTaTkpLXDLDbAoIvqiiqM5advaoCY0tEIn+4kxfHWsSa4FyhEbq1GNQGYv8n0zydz6Cai7NErXH5pVrKBcYy6z80LyXd9crDGELGBusuvCxoX13QqpHLgO24KH+ITU192Snh5Yd0sLY6XR8JFq/tIzggBfF8ZkiBFEk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752221408; c=relaxed/simple;
	bh=yycJVmr3c9FKOajDmjF1GfgbbwvmTHlyf5Hyec/q/UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CQCL+HHyzAeBs5Y+bVAaeukBmYTMNIpAbc/B4BempbMgiyaeLcejlcUmLalZQXUPey5IByuKs7u3vEsZsiu39yqHgOuF0aArqOu/91SKtwgCujB7BUCokE3kPtqrSXRq1wzha2xuFdAhUSLBpnssgbECGxU51Spqp1AT0j1dHF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eGOGSmmr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lWnhZxXv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eGOGSmmr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lWnhZxXv"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B6uw9x013489;
	Fri, 11 Jul 2025 08:09:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SDbJJ2oBHJmZKCK3Yk7trq0/6fF3jz7a8JrFVoc1zB8=; b=
	eGOGSmmrzQQ4HDq1d5FkQRiYTbxLTup8PMgkz1xOOCX8aUmcSe6MSOJYpTUmQsaw
	eJbpeSKAC9NiXizc2dV3yjjiiaIMU8RljzHpyFtWk5aNYDBuLh8v8FguzQRRsXQb
	CVTruqRTMZg0+IwRQWXPdtkS9PPAr+lqS+gINsMx2BDFMSJIC/Qs9pBOtNkfUFf0
	M0FMVb5+sNSrZ7D/ECgkodwv20YSJlakc5GPlWJaIXQTVhL5lazJlWhuVI6s64hS
	Y+3G4NJmdAbH/V1ZrEQ2FfWDA2mL404M/LsANm7PETgUYNEN2F6c8fG3oPYd8ccC
	imjEE/W095Mv7k6svpLiIg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47twsp83bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56B7Z1bE027371;
	Fri, 11 Jul 2025 08:09:49 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012035.outbound.protection.outlook.com [40.93.200.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgd9k57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k2pF5IejfJ6AgCRpYCdL0FTrupLSufkullwbzIGJm7p8aiR0b6Y0pvwxD0PuSAHYzvzHWm4Q/Ak+uKYq8RAJoBh4SymVztmscs6ROindQoAoG9kivXSddOJklrcMAJ6sJE08bKUBwfq1aLmARMrN5UZel7HT2uLxoG7fETCzckU+aqlX7njIQW5kjWKoKAtUCXQIY8iaF+RYin5wt4c+dQvvgog6Fpvn6v3eS228LPUisch1Fy6qyk7sxzko3HwIPIPZFkQkd078thVg4mif/mYUVF31Dp6xyafnTfIxhIUi0QtgMLsS77ydrxnV6T89dPldDjM0FwzlpF/e9YU8/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDbJJ2oBHJmZKCK3Yk7trq0/6fF3jz7a8JrFVoc1zB8=;
 b=IsBv+NCN+usk1oI/sezEYdNV+Ur4v/XJ9vIbHCn5TYtQCfIw+mieiTfLftfgddfYzj+RSz13lEkTd3JJon2OhU3jtVlRIFsXDBKylxdhhq4s9283J5FZf5s8obGfakZCx0QaO56bzZpP1ufBS+6QFmLKOcCia2HkPNjAbhPeWVQzpfcmvYDRymjUnB+NolwSz3rolEM5CHpDvM3qC2xI1vdR43MkSN/2zhoyZ6mLK9j9binZbyqHiJTKUN7bwzTmeA3DkowFXZaPlL7S5WyMYPS6o6iCbTS7o+ZmO0Sbb5+snhJvfQ8U9cctf1eMZAPq5W1xh2IuGpRcd5WKCMcfkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDbJJ2oBHJmZKCK3Yk7trq0/6fF3jz7a8JrFVoc1zB8=;
 b=lWnhZxXvjHHfeN2GRCvTod5fF4dxbUHjHEAQVQZgIv2M0tVUZrsUfZlU/DcozIZ+pDxZmAMcCy+kb+WGSwRXh5UQ6BRG6v/XMjIMm9FleFpqwyW0gtgt55C0M4UtYiyzgMv/Vs4CzLW5VbmgDvsg5qlyL8JhiIPWzyIaGJxl39Y=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ2PR10MB7559.namprd10.prod.outlook.com (2603:10b6:a03:546::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Fri, 11 Jul
 2025 08:09:42 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 08:09:42 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 1/6] ilog2: add max_pow_of_two_factor()
Date: Fri, 11 Jul 2025 08:09:24 +0000
Message-ID: <20250711080929.3091196-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711080929.3091196-1-john.g.garry@oracle.com>
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR20CA0014.namprd20.prod.outlook.com
 (2603:10b6:510:23c::24) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ2PR10MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: 47039549-4e72-4e1a-7bf1-08ddc0524a2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W6jtja9+oKjDJJE9y1hN7+xjL9nukT0uz/hDrL1CK7X5TanRCWz4plooFq+U?=
 =?us-ascii?Q?Cu1GYYAr013GuOicj75Q3MqlF4FsS7rTP/Krzb9+GBwXs0SAMW3o11WdHsQW?=
 =?us-ascii?Q?r7UEsLXMqu9bAtAHfFW8ds/a7hn64g7Vl0u+EWfyXN0hQhxl4d/9S/OkREM6?=
 =?us-ascii?Q?9Hknt35pFIBmT+vzxIg0nHI88Jd6g56qWBa/eBhVt06qQWoIyEZY2VS5Vcfo?=
 =?us-ascii?Q?pmHAOs+BXfE2Btg0Wy30XI/IUdWu2B1yUGcw6QVnWNQ/LeUED0QdxV1D3yoY?=
 =?us-ascii?Q?QsQZuhFu5ZWYwI3lG3kBrf5GlBwtJhAHnQOghN9G384l7xPEqlgRjt5ckyG/?=
 =?us-ascii?Q?z/G9q6gisIW+HDwoLdY9hnhl7kILaR8b6mK9YpF1J+UUQf/+ud3JIck6vKX3?=
 =?us-ascii?Q?NFVht/O815Ya4A1x5mDGlt/n74Hk23aFoQF364FNaH8r8SBe95GM0UWEFIy9?=
 =?us-ascii?Q?M5PQEZkOdjJvGB8VNpdWFAbusFe9DRaNA7eCdO2oMwx+dWCzCnAzNZSFmdg/?=
 =?us-ascii?Q?Z3dY1AOqCmD4vFLMcQVv8KyyEiZOw7zZM74Tbf9s2EQIPzftbXoa8G7c8b3h?=
 =?us-ascii?Q?Jwzwuyq6TxwEsMNEPDJE4WSV35VQVORwFSzR8maDjOcp0H3t/jyTEwYiCRkR?=
 =?us-ascii?Q?MWQd3HrlzmDNgZvTj85GLAm8Cy0Ic/oMuYu6zsOn5mJKGBsGrj5TUzDomjez?=
 =?us-ascii?Q?a8wxL+ytU+2bVkwYUJaNxK2AHhi16QrHBG1wAyRTsx0X6DzG+GPNLd8w1baz?=
 =?us-ascii?Q?pYMEZk9D7+P0m9vGpABxxGJZZJ83uiorSnfpqrzYmK19CU83sLGqBW1rOadb?=
 =?us-ascii?Q?sZQ9zAUNGul89JqZKMm7/dmEwx9NMiWVFzwqEI2ujoBbvMglXA+Pxh7RjYO1?=
 =?us-ascii?Q?xqzQfoJK7CRFQohwVFr+g+9MzQyO3jyE9iWZNytgzALD6Mkj0HI8IW7Qvys1?=
 =?us-ascii?Q?ggF1k0FLP8JMoagLeylQQhgR9wpLk9RVEY+K/H7OWohJnFk30NAghgdxXXmb?=
 =?us-ascii?Q?1PocRkcpLDM+wVDs8hGBOsakK4ZQAHm/78LAK/HjMVkE1YnIqNXheU4HAGwh?=
 =?us-ascii?Q?RiNfvkSLv02v3AtColNqxuIAy449nhgVGfQzbS9VsAlroAvEB2RqsgQfGT2a?=
 =?us-ascii?Q?qvnWzyImB+VMyo0WPwEXcomDILzakIVhdMevOqKH849BHeQIlPdBI+Nxzd9P?=
 =?us-ascii?Q?vKHyQ3jzq2ry3tVB4KZxoPShYHMaXAva6wu57rlts+Ds6ZOiGDxefxYdDPPv?=
 =?us-ascii?Q?h/sCbt7qAiC4VayjvnFoK8eXMrzcOci/R7mrRhzjVhfpC8DqAaO49h+rgSRq?=
 =?us-ascii?Q?mrH9K5GHxb1jSMyXEGMqXROmIFx/Unh3l8Ybrmd/B8t4NVziVPz4uxpRaGsf?=
 =?us-ascii?Q?SojU5zTqqwkGcdElYLynE2xUb5CVFPgcIwfJb2HXOu/uJ/eU1KH/x5ZTKbk+?=
 =?us-ascii?Q?6B55NqGVL6Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7cR43+9a8LsH8Dtpi37YLrE4Xt0+TcC+ZmjUXojUBcTaN5UoxIuwFEhrlQLo?=
 =?us-ascii?Q?sx/vqXRrjh10Rufcd8IbroN78ia30v6U/kyVlB+gWeDaA3xBKvvUIH72lkcp?=
 =?us-ascii?Q?EqTrCHWiMeeHWoXPnFMdU27J8Z6PK0dDPTdlprZgjxcdAvCwdoSLv3ZfUPHp?=
 =?us-ascii?Q?P0wOzHPpwTOjfaIiBQENObpWgVRF9V6cXkFziEcrAhOLSB7P5KkVQbcM8ECh?=
 =?us-ascii?Q?tQQ+B+QtdqIAAfu34eXXkbocS++KPnNxgFy15wu+Xm3RDGvvJjID/qMMPlpO?=
 =?us-ascii?Q?5BsVh+LSsaKDHZr/VzW+Y5abYuhbX/drVIyJxuKtfGPU2oVhnHcHmx/tblou?=
 =?us-ascii?Q?muiXWHLvYnRLXJf+78P8trYKSrQSp+jP38Ne/tzpIhoPuMIHe7Wc8gzLL8aX?=
 =?us-ascii?Q?hfR7uACBoJtgJMlajehrnysBS2i/Fi+kxPpJL45dHDIhBnHRIwLEIGGWuRop?=
 =?us-ascii?Q?Za2SuiG4L343EpJcD0JQNJOfjVzuk2MGND18By/ZXiTJ5mCc3+lV+ehRWQx7?=
 =?us-ascii?Q?yEgzoCUCJqSxcqUzBGKAORTopEhQ3kj+kHleizT+hLEDY3DjG9QG2t4awRa4?=
 =?us-ascii?Q?zF9IIvPAgufEHMcW+/J+nFxb/eYpEoPJj+itAnTXsAG4R0vwlS9cXttptUck?=
 =?us-ascii?Q?v+FEHvYd2Se8vXzE9Cq3LX8K2gpz+SC2uPZCQMLXHu4EYduRpRXg8gU7RVt8?=
 =?us-ascii?Q?rBt/KRO5b4wSfk2TJCwv8rZ6MVENIbEY1u5iiyQsILJxWEP/59QeEyb/B6dM?=
 =?us-ascii?Q?F4EdyiKpjy/gxggX07D8igglmep7jXxE1yXG9BXoJAGmkM2CvhnlsCWRJ+iY?=
 =?us-ascii?Q?YN+N1tMruLz6tqEP7bcTLxrdb+mW8AcFqXNJ5/f4AwvWGCu3RRgIzvQMYFUR?=
 =?us-ascii?Q?3aoN1Sf0R4wSqiAIN9y8sNofljTtRlT1CaUyqNWRi86kFXnbknUQ2Il1iYxe?=
 =?us-ascii?Q?dSH1OUEXVgXFSQr1KoFEcagdImcoOC4gf+pqQvwgQHeo200KF2C79CaqAHp2?=
 =?us-ascii?Q?/U83yE7c7Acg5zZMTcklHk2Lg0uJrYb89lQeowckmJVdV+q8WgNCwQxY2o/q?=
 =?us-ascii?Q?VWXEusKBWAUFLebLwY9Eu/4DtLJBaxNGK7nH3NIN3U2YQszbh4S13Mf6WLca?=
 =?us-ascii?Q?L27JmF4AbqdDN8dQ59mTyGGEUESScMPe2boxfI1rzmAHzCK0ewFjxB/3MbGx?=
 =?us-ascii?Q?vxULoa//gHf7Apon8uOe+YMbbwEQkNbSVUB83JrIDXH8xGCBd4SnaUBer9Kn?=
 =?us-ascii?Q?qw+ra44b/1LO0ZgcbJfnYrhgDgrpUsI1QX7k8fHKA1zHmzr83spythbZYYUx?=
 =?us-ascii?Q?oyLS2G3GbHchqmr4UkfwN0r6T0as+B6RdyiFSS8cSZxtHOoV44r56kz12+Gr?=
 =?us-ascii?Q?nQi+MFy/h0Gr2vlB9qpKsnF+WdRtQLg6Wey84kwjgr7pRRP299Txp/QPlsCV?=
 =?us-ascii?Q?m1ZxtsVBk87uRqlgxu8/uUztUNLP0h/dvakYwUtatY8lTD2aV7J5ZYj7t4Fh?=
 =?us-ascii?Q?nYosMTsPLfsiWqUZ9BYgnXmIujbze3IF9/uzSWaTVZ/kS0boCfRLNaj7K8r7?=
 =?us-ascii?Q?GD9QwQfNR1h2YY0jVBW1XI0cLyp2EgSdb3lI6CGacRCgSPg+Q8Nj1pG5ZdKo?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2M/gnUK+ZvDUpmnGqBwgB1IchR0abi0WjYFPE7zC21kC+5UWDyBQF3zjJK1Rh5g83QpiDskua9J4MSlqkzTKBOGNtxVLmbmpG+dUwI9e2LNspgGbRitAC4CNwVECk9YQEODIjxxCsiGAJOR3mJnVF9gm3IEImfV52uUzHOt8H3lv4ppWACOKycXqMkH1bv6bKR/8uKcQsc9kqT/DLs9kf9QNDjYcsffDOh8G4boAhrv+Ys+sMzNNPKjtVKimm1b3bk5M58nqwkV4Gxe28KXZygbX7jRVpHhGXfJ1a87zAM45k/ZX7ZPMKRF6yoyR7xqZGl6JQGdzmQpHMU+UjO0RLYm1gM9RPCb+tI6et2O8CADzeu5RUJ07mxLxJDEqfK+CbiNLqiVb5aqMWtoOWr0CuSU/fiYttswVWFku5PPlzB3CIqFg3pfyDtjAfbVSHx47x1DsJMXajAPeZbYAobTEOYituF18n0sFpxnY0srAd5bHOwdCE+bl/iBTWAsVGStkM3gzMqhjhF6V/4tQo8Rjyvpcv4qupLbXTBU/oQcjzxGCVDtpgLGgWxUsY11Q/toRWazl/D89xhJLNh96bcEB3/CWdkEvmLgrONQOE7IrmIg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47039549-4e72-4e1a-7bf1-08ddc0524a2e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 08:09:42.2129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5f/kHboFpmrq6l0kWZJ5WG8eskHcyeej/ZYlCkYD3aTpmdTKD9yX6WXqPGX+fSkn/PH7G4NGqQDkoJUHqbEAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_02,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110056
X-Proofpoint-GUID: TnwQMzX5697rAgTafjcPkxRI34DhNV_f
X-Proofpoint-ORIG-GUID: TnwQMzX5697rAgTafjcPkxRI34DhNV_f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA1NiBTYWx0ZWRfX3xEuUumT1ANR hKzzwsNtxnAO3nDUGU0RWp9WrmI8aEkDNp94r9a0nth/b+yg9LSexinDVjTU0+bxGfMoO8ItplP cBFX1WOALzmcAA9Fdx4I2R845WFfVwu2nerBCHXHrgFuxLezDlIsWUshbOpQ6ZmApHaojsPwJRy
 31/QAku5AAbZmXpBI2H0dDcm6YtN8aRCi0f+cA7HGR1ygUiQh+orhUWNDX5G3134H8JO8+OwhU0 g0aC2NxvhllJ4pxlXSLdAEFXjH67Q9sGsDgnxjyEh7nQAkklp9uRBtcs/pSrqiU/Dh5rxLG1LPc 0h98vWPGZ9AVZYEusAUEn5nE5J+HysiA++Letrh1rfEvDlOiZAZ1o1SUR+Rg4zvLJhmTpGW9t71
 Ys/54Y1i5i0a3CFvQnRhd7leNRf/OOYdtiSoRVlIwcr9f5xJtW2e9HBcFhrhSEo1EwxmYIi+
X-Authority-Analysis: v=2.4 cv=JdS8rVKV c=1 sm=1 tr=0 ts=6870c6ce b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=9wh2qRDMZpkBaRsaGB4A:9 cc=ntf awl=host:12061

Relocate the function max_pow_of_two_factor() to common ilog2.h from the
xfs code, as it will be used elsewhere.

Also simplify the function, as advised by Mikulas Patocka.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_mount.c   |  5 -----
 include/linux/log2.h | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 29276fe60df9c..6c669ae082d4d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -672,11 +672,6 @@ static inline xfs_extlen_t xfs_calc_atomic_write_max(struct xfs_mount *mp)
 	return rounddown_pow_of_two(XFS_B_TO_FSB(mp, MAX_RW_COUNT));
 }
 
-static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
-{
-	return 1 << (ffs(nr) - 1);
-}
-
 /*
  * If the data device advertises atomic write support, limit the size of data
  * device atomic writes to the greatest power-of-two factor of the AG size so
diff --git a/include/linux/log2.h b/include/linux/log2.h
index 1366cb688a6d9..2eac3fc9303d6 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -255,4 +255,18 @@ int __bits_per(unsigned long n)
 	) :					\
 	__bits_per(n)				\
 )
+
+/**
+ * max_pow_of_two_factor - return highest power-of-2 factor
+ * @n: parameter
+ *
+ * find highest power-of-2 which is evenly divisible into n.
+ * 0 is returned for n == 0 or 1.
+ */
+static inline __attribute__((const))
+unsigned int max_pow_of_two_factor(unsigned int n)
+{
+	return n & -n;
+}
+
 #endif /* _LINUX_LOG2_H */
-- 
2.43.5

