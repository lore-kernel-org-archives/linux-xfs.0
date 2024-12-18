Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9B1481D1
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488093; cv=fail; b=ivOJH+UvBpMU07PKDax/0jNRcyCt1uQeMs8O1wggHB8PhF0BHuCoU8Tbv0Lyo2jGIziIteaX2YIlpG9QYvCPLB30c++1KgAHhYQeuFhTPcLLj2a/xNtgHFsH20lOmYI0LdKLz10vn9B7Z+kmLKagtvtxGKUxtkRzKgZjbqBzmI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488093; c=relaxed/simple;
	bh=DyT5CsR37T1QglstUHzgJTWLdV0MleVK7IWNwMmwpA0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uHsrDyola+2fCHonzM/hw09pJpnT37QruxEs1fuoSvJ9MOxhtcHL5gMEG0PmGi1So2kyssCSzUs6vJIFBdUjwgFs3u4P+eEn2FyJpbveq4CQkes3lj14mkcXm8ygMFV6hnKa1xQIrf0lzpgPQxDgJ5HGL16TxYIa3OyDnqk3xD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XD3uGbA9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CZseFP+z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XD3uGbA9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CZseFP+z"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BqAZ004590
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ci6H5fUahLW/ypWpJtggf9+ClHUWMn14g9r/1wXIqpU=; b=
	XD3uGbA9+NJOUo8RU+bfdo8jKLkjSOmxM1RiFt/8/Pn3niiIaZUt7HitdRrTrtdX
	V5oJhrSIGvRbCQxX0H0aGlkj3BtqHlD30cMYhoERkjTubxu8496aydlGSnLcU+sX
	SXVo5S7wSgdsB1xHXplS8afMI9r99Lii8PxCO/gk0pbF/BUX13cUR4vFbyHam30k
	5qW/kXKgD6KLa49+NwXyzqBCs1fAAfZKOb03Rtz98RWX5dVLBg6Mf4Wfev8SESX+
	PlSvZI1AN/9JAZEigoARuBNACcSfu/VgULGyF5bkUaT5l74b4w4TzxM6rZ9FjOXY
	ZJrqk0ClrghBluvr80SdLQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43jaj5db9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI1x6Hj006392
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fa4ws9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uKJ0nl51cXtabeskQgOT38GMQYGnsvLZKz+3ACe2cWw4iHCtZW3NW+Wt9jnNgHjfBjd8Vosqz/Efr0pkFadKn4+ySzz9TgSA1gViZNJO5FzCpapyLHZRLkzYgtngDUr2lclnYnE7/Obo9bhtrhHmO59wOCoGBn00y6Fx/BBX9F+EZ760ha7AIFmJjWATjEnWQeVHOTGSeY1xlpyvckryltNFMlq7Z87PrzW4d8bJLSC2QWxFdrgQ5ag4afNyIUEP9hQJcQ44BGOqigT5fMPOqIJvrCdlDnmVHQHXDdjrnAMWNdV5jb/GO3aFPlONPv1ijLnvAFfKLjSLL2yxMmxqEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ci6H5fUahLW/ypWpJtggf9+ClHUWMn14g9r/1wXIqpU=;
 b=uW7Vdd4Djvc7/Mr3sW76lja0DUSUK2Y0HwFmAbUP1BVncOgo+jEpXvQl9i0atviiYFSjAFOZdNoxoGdYot6mreAzwa6r3F8umtnDzEEnyi37Ui7k5t03dyxcEAHg/qYYRePhXJNOjRtAjZqYSN6wuq1lY0N8whzHd+yGAX26xKtBAdsSzG+ncPCVBOOnLlFfoKNPTri+s2B8c3VkiExWmT6GNbv4BVOFe5IJiDJiEzqdzlVJCFNMUjNpFxhVwKA08pcswEuw49WxNuvd1x3ka8FGVTC+s8Cf94WSPDEPFlCHy1fzYF3r6+yPgVaXiGfS8owjogEVNUFFvbEbWOaWFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ci6H5fUahLW/ypWpJtggf9+ClHUWMn14g9r/1wXIqpU=;
 b=CZseFP+zy+/RnzTEhACnJy+7B6cgiJAvi5WRC4yxb0S64sVoWd+9jfdznHwhT6AuH0k4YxnrW37id8sSV3i/qfXb1EgsG/DutuyT+u+EW45IcBnV5iuQfZ1wahWrW0Ojbdq6/8Rpt1xfQtNZzvJdO4EHMy0IdBCdH3xUPQffU6k=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7577.namprd10.prod.outlook.com (2603:10b6:208:483::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Wed, 18 Dec
 2024 02:14:46 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:46 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 18/18] xfs: reset rootdir extent size hint after growfsrt
Date: Tue, 17 Dec 2024 18:14:11 -0800
Message-Id: <20241218021411.42144-19-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0052.namprd02.prod.outlook.com
 (2603:10b6:a03:54::29) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7577:EE_
X-MS-Office365-Filtering-Correlation-Id: 1106f516-50d9-4a7d-465e-08dd1f09be0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N4C+PI3u22xyaqv9bESiLr0nOFNcfsCJ18w9powtEabgBOXvBHZPZTNQHBfY?=
 =?us-ascii?Q?SEIdGpI0xsWjRp/Ifzdr6yjS6LeRsseHUIQ1wkoSw1HI7gvJBVYV8VFhyjDj?=
 =?us-ascii?Q?EbPoJvLWUZPX05hBZtU5Dwz0OLnlw4IxSF4MZyj2FrelyDp2VtQg4lls6uZb?=
 =?us-ascii?Q?jJv4hSD2kk4qJ63POstFwLtopc1vswXiszKU7lHcPGVSualR2ru1Vbg567bp?=
 =?us-ascii?Q?lbcBps4PchotvrcDsfFs/qOzuupKMgJExGuUtWrORE68K8f9rigp4KCWxuv2?=
 =?us-ascii?Q?8M91UtHReTFtYIgVoooOT/Qdt5RggYVQrLOWfiwyeFjGo4ykxpJi0lDH8UWg?=
 =?us-ascii?Q?SO50pRbHy7QbXxw26TS7TQUTtP6r/StxuoZP2z/nhzZZag20D6c+ncKl3LLA?=
 =?us-ascii?Q?4qor6gIO+KKBWIwazE+SpBjexg4P5Q7ADDpnHd1WOVYS/l5YyYZmFwqtukTO?=
 =?us-ascii?Q?o/htPmf9g3EauUzrXJFrzdf2SVfQls7Uy297I8it4lF3nKbfG5EXoRGsIToO?=
 =?us-ascii?Q?2l0Lj0CGeUWvw3dc4yZJ+Q1XpYngG2ypvVgfQR2c9cOK75c75VlarW25yIEh?=
 =?us-ascii?Q?GgIg1FZewQtSjLWFXx1ER3EPeqZNrpEw2IxyfAw8pZuu7QlSsVKIJHBwxrgi?=
 =?us-ascii?Q?qFmKjJy8uFBKwDE35lvmIJu0oUi+M7saepQbCvCH/cVdhU6YqTKChqh6Vx5H?=
 =?us-ascii?Q?sT/ZL6BAbB+q8CMsMbBcilm9N7gllZGlc1JaeKUGXYzcjIXIuSF+DRGaoSWa?=
 =?us-ascii?Q?VXSJW/J9V7McqU/jI0mY/L4Y9fI4L0QfSY0D6dm/OmS7yBXMqiG9kDC5PQW9?=
 =?us-ascii?Q?2T+HTJQ4y2ySsrCQeQ51PmdvgGJI9BG7bSb+r7u3toVzDDcjznu1xA1/kcGd?=
 =?us-ascii?Q?uMzZVOuBPWNhVEiR6C8AMTU0mK/Jo7Xs5lrD2AwW739sYR5L7BXQYeYgw1om?=
 =?us-ascii?Q?7X59RnF8ypcmAjPjiATsHskP8DFc3jnmySOkcMk4+4qMoIDbpDJJGDgHmvTs?=
 =?us-ascii?Q?kcSJ5k1XrgFc+NyoyTxaHp7FdFzBdZBrhZ+5yg19gnIreOHNizNi3T95sYsU?=
 =?us-ascii?Q?Lk269fVCVW2OOOoBy3ipIE0l1vo5l2HXBctTkA0LLN0KMeKufhGZzyJsJrTY?=
 =?us-ascii?Q?PU7HeRMkMEBy2L8kdneXrtroj0mbYgtvTiw8LRkMJHI16xi4vcKcfwScnXbS?=
 =?us-ascii?Q?GoEAGa1/xVec6iHXbb+skJWydjk0ak948nE1YDlF2AePTPtOHyxS0ZBQrZaY?=
 =?us-ascii?Q?iBhwQJxOOavIEwYRjMbZWlDZoJf6ibfjZFSrzYlcN7F/1Ov13rdXLJREwpry?=
 =?us-ascii?Q?gbqpMyxODH7aArFijABkB+jlpBUwBBby1sUdicTIVWQ/cMMGgqlyLM9LGAm8?=
 =?us-ascii?Q?uIN2aV3SSFE2ptxh6/falaCJfCH0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O2TbXdhEmwhwpdAAiVWWL3qsZX1f/yApmHZAirBMmRxRDTdU7tT9Swbrk8Dn?=
 =?us-ascii?Q?BrlU5fIRLFxKiViuLzoZETS4lTYGE9OqvmWzquNDLQlFvvAsnicRQ1xYtd2l?=
 =?us-ascii?Q?aO2lrnLi92bDhPDo7O/UvgHZ6jdLzv5PhtDwQ2rfOJQi+1+C48m00hH/taW4?=
 =?us-ascii?Q?Gi4oFXfcuURfRvEDpoZrXB40yFRKDFMTdeFIi4mdVc43QJxRJP5fv9jzllNn?=
 =?us-ascii?Q?HNOh3y/mcWgSM2MRy/HWssswrMmcDM21k+HS0LpEosSqkfrNXOtXFCUWTm+Z?=
 =?us-ascii?Q?J7Op0jXBxh5Zx1SlCAcYd8uLz/+YrKnEFq292cFPUphRIdEt+bVh3Mr0cWzC?=
 =?us-ascii?Q?gnqIt5tRkS+dAq3ntsVbqyYVKO0DKAdv0tlkApFNTrmZYZazlkOS1uq803+q?=
 =?us-ascii?Q?m51DARN0nXysKESYFaQfvsb2PtBB/Fbl32HQYG9Gl4UUHjZkeItYkgTKBWCq?=
 =?us-ascii?Q?WxK3YpdCeCjLTOYQ3XQ6Xsn43lS0Qjj5qviZte3WS3wRmsRoy/Cy0aMGRqkU?=
 =?us-ascii?Q?xvDqCI4oD+k7GzOKW3r2ufn3mTyb8vv9df5ua4a0w3nVdFVtmHYyOhBM3PCF?=
 =?us-ascii?Q?+/zhF5Bqrt10+SONT45LSYRG17cFDlQKohbPkU2+VaOIP8eCGhd2uw2Iykyb?=
 =?us-ascii?Q?UnUkJ5Wdsggzwg3cGdqgqeuC7wMUnSW/Qn+kvmzOICvm5PPHv2uqGqMWsKUA?=
 =?us-ascii?Q?/V/MXeax3VaRE2RBL9q8VNJSGrIKpkPDdMOdIqbbVxXdYn7CiGsSFk8Y6zRn?=
 =?us-ascii?Q?cd0pC/m550duaCsg0wvwcbHncRwdOpO9aY0VT/S0smWjk5cMUesPzDl9NIVc?=
 =?us-ascii?Q?qqvX/6990a2VWbXhml8ynzERoeI+LO0t0gioZdMoFyTe5PUZmgXntofRStQT?=
 =?us-ascii?Q?zJMVw6xogkBLeu0nFnWgKMOuGS/FCZMMOZr3OySx7yvuImwAxmHeGt/gh+QF?=
 =?us-ascii?Q?FUc86u151Z+DVPZz4G2keXLi+OZ80+OxqZGnzV1D++p229WuPA+v1CGowqXX?=
 =?us-ascii?Q?Z06S/8Mjof7NT2ITYesiUCfOWvBYFvD2mBkRwymxGiuDpti1oU1y0AuavHOD?=
 =?us-ascii?Q?ocQPe4Y8gMPwhXU//GPHrp16mRaWn1p+te8R6Y0gi89mzAPuf7KU/uUUkBpe?=
 =?us-ascii?Q?BBvYjENO3dR2T3jNFW+FgqnAnPTsJh1xGIJg2RRb2U9HQxBEcGjWPlBq6t7z?=
 =?us-ascii?Q?Is/mPpnSu8vsFnorrGYxIHnzG8GiUZZCP/GB0gLoc/I6YxpW4NPtElnR7sWd?=
 =?us-ascii?Q?aw1b3OidNUVAfAoU6z8uhYhiOZQf6Tb0eBtXdirC3B6S5Cx4lswU6vfCAUgW?=
 =?us-ascii?Q?pjP3J+SZUVE+6LKxXwnuVll5NXJNTyk1tvNCIexslNMVWc+hmAqVrUPR2lS9?=
 =?us-ascii?Q?X+feZqe+L2ylgKobCmWbBkzzgs99utI9I07Pr7hw4PK9EZ+031zwExUAdo/A?=
 =?us-ascii?Q?Jzt7YqZAzjDNuNnxoEr57F4s5gYMZ8/ogXwV8w9s4qVvtPbQtlso7yIX5AUG?=
 =?us-ascii?Q?BmiScIaeO7Pb3elreNqXuoefursYV7xVDATjhVncHZU7Ck2MF+biJDTYlcEY?=
 =?us-ascii?Q?5MbvFToWL6zwESpBMpmqiByrWBdL3UZF5GKxm/562swrzzbXotCA3KuH806I?=
 =?us-ascii?Q?z7tivGSUd7ub5N89irniX/dI/mrwEkU4sYM3ADY7Md/DTQLBpl7oGVUN8N3Q?=
 =?us-ascii?Q?LmvKAw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XHgNp6Nhcx8j9wwd1s31ZFk2KsH4dsldUZR/Yj5aTBgtyHTUsrX/IEhW6yv1WxDlS5MoqCYcmGGemKCHtV8Py09hi4g3oduIcxlOgKxwRSUj5kdxuDLNMIi003eC4Y5QTTi7jJo0U1gs+WYzYtph6mvkUXFr8tMX1S+T1EfCJBr8zUUdzZYr/s3iALet+x8aQvu26r5J7nci9LizPI97Qj5y9jLtjF/P9eywi/donYmyX3kM1j7EiO7l6fgPtXdMxT40tvx8v6mibahDnAiuotSPZjx4hK+R+HX2YCKUu30TnJmHvWdwwdfgPdRDsuROofJ+b1W5pVMrMqeCJ0wRoQkZBajYlj4yU4cZj9E/d6gbS+5Syw9z8qCnc9RQ6QotCEjHyF5n02t7VSVJEPJpmCAuNmOiAemjC84kTM65nP5nQj3A0COrTbeTIBX1ablOqL6FG+X/6taibPCgPeZamZplbZfZ+g6LlCtHaK2iNjZXDGJ5NH0xTRBVuQhrSbWNTnjMlhLHHi5PlUAqHCf2cdk+mheje1YzIa4A2wkCwQA0th2SNyjSRUBrZwqSIRVWng98nTYN+J87Uegh8GD7y3KrwzLASyD3L/pmCarleO8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1106f516-50d9-4a7d-465e-08dd1f09be0c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:46.2698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJ5zGr9GXN+GxvArxE6a5BkxuQ9h8O7tBa4iDvagBiXL5f37ivUm+NPt4oIKra8+XiiDOL9LZ1c31PjFcPL+1EU7i5drgVHiIZ3RgsOJnM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180015
X-Proofpoint-GUID: 2wj3nSvYSp8RV7qpEV8HW-0e-fh4qCUZ
X-Proofpoint-ORIG-GUID: 2wj3nSvYSp8RV7qpEV8HW-0e-fh4qCUZ

From: "Darrick J. Wong" <djwong@kernel.org>

commit a24cae8fc1f13f6f6929351309f248fd2e9351ce upstream.

If growfsrt is run on a filesystem that doesn't have a rt volume, it's
possible to change the rt extent size.  If the root directory was
previously set up with an inherited extent size hint and rtinherit, it's
possible that the hint is no longer a multiple of the rt extent size.
Although the verifiers don't complain about this, xfs_repair will, so if
we detect this situation, log the root directory to clean it up.  This
is still racy, but it's better than nothing.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_rtalloc.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 9268961d887c..ad828fbd5ce4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -915,6 +915,39 @@ xfs_alloc_rsum_cache(
 		xfs_warn(mp, "could not allocate realtime summary cache");
 }
 
+/*
+ * If we changed the rt extent size (meaning there was no rt volume previously)
+ * and the root directory had EXTSZINHERIT and RTINHERIT set, it's possible
+ * that the extent size hint on the root directory is no longer congruent with
+ * the new rt extent size.  Log the rootdir inode to fix this.
+ */
+static int
+xfs_growfs_rt_fixup_extsize(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inode	*ip = mp->m_rootip;
+	struct xfs_trans	*tp;
+	int			error = 0;
+
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	if (!(ip->i_diflags & XFS_DIFLAG_RTINHERIT) ||
+	    !(ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT))
+		goto out_iolock;
+
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange, 0, 0, false,
+			&tp);
+	if (error)
+		goto out_iolock;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+out_iolock:
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return error;
+}
+
 /*
  * Visible (exported) functions.
  */
@@ -944,6 +977,7 @@ xfs_growfs_rt(
 	xfs_sb_t	*sbp;		/* old superblock */
 	xfs_fsblock_t	sumbno;		/* summary block number */
 	uint8_t		*rsum_cache;	/* old summary cache */
+	xfs_agblock_t	old_rextsize = mp->m_sb.sb_rextsize;
 
 	sbp = &mp->m_sb;
 
@@ -1177,6 +1211,12 @@ xfs_growfs_rt(
 	if (error)
 		goto out_free;
 
+	if (old_rextsize != in->extsize) {
+		error = xfs_growfs_rt_fixup_extsize(mp);
+		if (error)
+			goto out_free;
+	}
+
 	/* Update secondary superblocks now the physical grow has completed */
 	error = xfs_update_secondary_sbs(mp);
 
-- 
2.39.3

