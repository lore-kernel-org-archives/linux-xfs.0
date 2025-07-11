Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527F621FF39;
	Fri, 11 Jul 2025 08:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752221416; cv=fail; b=CyEtYbLmhn6U8JmUsgdixdSFiKQfUcYUYhMoX78/Sn2xgf+Oa2bt2qWlbYLqSrvXnbg/8dIJmQ+OLiMsm51W85HS92dp0N1o0/nNs9JjvtvuHSP3AH0t9ykRE/lg0SZkzqTW35CivmsAGpjaRX1BEOG5qr2HaSYXpZvD+n0Scv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752221416; c=relaxed/simple;
	bh=zVRMU1Sf7LfwRzyxIq5AyPu21ICE8blLe/VGGBhnNx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B0DAD5LXHveNJDftw57cNxvFC1eSOtTsa0g4zKr58r+MRpCUrW75pkFAv/sI6fTNvPl2ZRIlYl2yxJO35FpacpdVbPgnRSBa34lIhKsw0eDC8DAN+XJzAVtLagPY/nyWC0gPFZXYGv8az3Arfpg0tCts4Y5aRY5gY1TT6XVDXKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fqpEuNxc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BMoP0PPP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fqpEuNxc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BMoP0PPP"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B87k50023404;
	Fri, 11 Jul 2025 08:09:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lgLqN2NxVcJM/hImjq5K9Y7RXqRcjOhqoG9SYNWvypw=; b=
	fqpEuNxcYajaeDEgSseKeKC5NSNmYrKAYUfq7oTtAUnAk4kN3d9dolDpgDq00/JD
	Rayj69+s88RnNsOKr9Q4pukFRYA6zE5VKLFNihnCHP5LhUCQ9Z0JeusDH726/bzC
	DRSZClZOBTk+uxELlctyZL/SRLwF4cPMluxNILoFU9LcH5uIVm36VvY+PQK0FwG2
	qS9Q7UbVDIL8wgSzXeX8oAX6PiICLTuTXT/2nCf/0kcMn0MdtEeLSgORqFsSBvMA
	pGCD572V1loipvkRZWL29ljQmY99tRB0hrgEDFaSylfRnrGLe8Fs62XIxMlisBFj
	B0SgbEC6XfK0bhTApQiNdA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47txtn002q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56B70Ejm014012;
	Fri, 11 Jul 2025 08:09:54 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012046.outbound.protection.outlook.com [40.93.200.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdadqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccO1GG5Zsm7V5ahabajtCoh6YmcrKFicDBWEjp7YnyPMCbnhg7em3mK1rshAEkEYTqmIEbe5d+fK7Y0v3sv+kMoPb+94JEDBCsykV3qTkGhXl8suMqEU1PiU52CqB7dS/SPHgBfgH7rOXETa+5nyojNGiZEs95Xliv7sEQZWhalyVisaWau7VvnolY7z49AYCBurDlewBFX1xfECLAtiL2E7zOLscdJuR564ECl9jsTjwktyZvCP640JDA5BWgZKx7j+4V1MnW9k5hnGN5hv5GvxoN4KlVEuIVDFsD34jgaO+/UB50nf31o26TnSrn3FehmdaMCJ8uNTwGNgn9JNYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgLqN2NxVcJM/hImjq5K9Y7RXqRcjOhqoG9SYNWvypw=;
 b=dV4PFamPpix+U7QjDfRNNNFYBMVKD5vP7PHmZHZTqosxJSAIMXZhllaqBFC3ppAatKSSt2ikKvAqEN3NQiEZ2Lr0R7ZWnGiyqcpoqZNfoBxgyDN4tB41gRXZDePJwOuHYlDsPFWagzLUcnnrXFmh2EFHZEEb1jupkRJRcNPhs/hMruimy+bTIOOGI5bsmchaqIIEFyrYnl2QTKUrQfwv08gKORKe2hP83wdGnt9xrfMkqWx3cvS0N+Z0vEBbgeXPpQNiPDdVLfkUTHrHz3fQWHdzCO61om3Eaa3gURQ69V4DLy46Q/1T2YHLj7BkiBg9wI5+EASxgax1fqx69nCNTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgLqN2NxVcJM/hImjq5K9Y7RXqRcjOhqoG9SYNWvypw=;
 b=BMoP0PPPt9it9YqEISt3bvXsLoT41W7zE4DwUPE250UIHdrLPeNpCLRehSwxSKtrguIRo+Aw/Yk9sWIqNsbmz7PLazdIHOCwJzAWPFnKU5OK94DiHovE8cusokyYTkCHSBg6hCiHrUMLKXPdbsBWGYOJhxEjflbNbFumTzKY29o=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ2PR10MB7559.namprd10.prod.outlook.com (2603:10b6:a03:546::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Fri, 11 Jul
 2025 08:09:51 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 08:09:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 5/6] dm-stripe: limit chunk_sectors to the stripe size
Date: Fri, 11 Jul 2025 08:09:28 +0000
Message-ID: <20250711080929.3091196-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711080929.3091196-1-john.g.garry@oracle.com>
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::31) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ2PR10MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: 01d97e47-21a4-4d8a-768e-08ddc0524f75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4bjY/CKCMHl1Ea3QrvBJ/qiMiHSR/x5n8ZEewdlbKx5K2f2cY978eQaae/C4?=
 =?us-ascii?Q?65ckyCMjYajuUKUqS4ml4fZdrCvyFlQ/HBYCaPf5J/GeBiQCzwKoKt8o2k26?=
 =?us-ascii?Q?9i36BmnYboySTmyTJOSYjt6gYRZ+kh6pwn6e3dd9lma0+MnOxV7FgMV497+t?=
 =?us-ascii?Q?XPRyam7caTRtaPqbSI+m4vpSN++Nvku1cf6ctcLf+pax3L6UaId01wlM5khj?=
 =?us-ascii?Q?t8f4n9qzLmvnxGXci8niWlLkq/E5p8I+5iJ8sxTBpuvuodYqmMBPctmBecoM?=
 =?us-ascii?Q?L6CGr0+WFddPGJM52ZBbtUsyK+URu9/zkIkPhFuLdxhSEZv3m8POTHjqbSEH?=
 =?us-ascii?Q?8YK4T6ksnZu5Omf5RQ684AXL2UGKDf4F/xrR+o+ohVlFJUjMmQ13dGZBgMAT?=
 =?us-ascii?Q?BxZFv51cJ8H/sMLiqODEb4yZot5jTnXQrWCl+IwkDuBFoYVYQa/iv3eFipaH?=
 =?us-ascii?Q?WmXMjSqGeD+ymGmeoDDrdUM/49QUvnPUzZ+y+MGLuBIN2cZbiu5lAeh9qv1W?=
 =?us-ascii?Q?mjY+0iH+3Jsm/QcUF2OPJnT9BgJA67CGXm7rNuEiQG2Duo8txKglFq4o1RfJ?=
 =?us-ascii?Q?04WeV5jV3NlTXf0DFMaAHjWPWvKoIQLEbVSe2Xh8/UGoMt3cugAD1Rtw4T2t?=
 =?us-ascii?Q?YpIODWjmEP7/k/CszLBekxNzLWmAcw6VMdhN5Tc7Hn9anrKEXkg7MlFj7XAY?=
 =?us-ascii?Q?kNDdYaDBoyLGZWYbZfYILDoI4vPBGARBuzuDPFTedzpB83jHisUYkn05hdDD?=
 =?us-ascii?Q?NjNvfmZMRykefgrYyVbXdjajaojJkgydeRtW6cWjN4vw/d/ihH81wqDoq+cm?=
 =?us-ascii?Q?s0eHt1GDb40AQ1Sd/IMvvclZU9pGWbQOX4DCr6rQa8UmW/azIo7YOk+1vozp?=
 =?us-ascii?Q?2y+kmmumkZCeUZ6IdrJ9S9MYS5QXp9qMtveNgRCx//tk0h3l2Kb24rn0/TAT?=
 =?us-ascii?Q?enNSWaGAxEZDHgGwPTaBBPgCB2+/YUapuCBjHhlx/phonb2mKmY0lCoBKgJ8?=
 =?us-ascii?Q?7HF/X8bieLtz4pwbmNfv7MyQMrepDm0P2vTTCXALjDOyY/oNVYEUzNfh3jXh?=
 =?us-ascii?Q?hjsZbC+2r3NesyP6okbcp6r8BqhdylvikBLEatbnEtbzUgtbbbBPuOPqDee5?=
 =?us-ascii?Q?L8iH7xWuOXVHPYo+nw7IiqS+mZ1Sax5l8NQRwkcwXz7WNOxJB6pOLWtNJQ85?=
 =?us-ascii?Q?Wdm0CzGqkZaW0by0EKCSarUkNyJp7AOZiXzGRxTKQ53vjdDj69BXu7X8w6nw?=
 =?us-ascii?Q?rdjW9tHO44ktUu4EapidMraTQ4hAa8HJMxT//JStg6ZWMb41pZP5IHfZJ/b/?=
 =?us-ascii?Q?2bfAvPsC/PM+cFziOSwb7VS+aRu+OBzdcMKmP9oNgl21AvEDvjgP5TD5gUwV?=
 =?us-ascii?Q?oBjGZ9MNd5oi/WH/P6wEnzXayAi/2TZT+3g70pIazqyJBaDJAxufMA2EW0cB?=
 =?us-ascii?Q?nGAKv/w8YtI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A7nvCzEn7utvteunzwDOth4WcIvUPr4QdjaY2Mw76BtKREAigje2IUItUNOj?=
 =?us-ascii?Q?bnThG2Cnry8V1iSYloH1setlyQiO0ucD4lNVSw3MpdnB6HAx0HTDBWgLZQ44?=
 =?us-ascii?Q?BD3FQ9qLzllYdiI53vq4xnf0BFL389HSNheqEbSL8A0ir/2akUj4iZ+RDfQu?=
 =?us-ascii?Q?nS4RBHKHysdgmWYUar85FJSv1rlB1LdgJaHysbHZOfEbY9k3F5sqJpPHBwgr?=
 =?us-ascii?Q?nD0x3kV+bB5s68I0O5pO/SD//fKBk6bqbJYFWiQIZxxn6H0VND10Qarsg1zu?=
 =?us-ascii?Q?cGRhe51wyN3OlMpqxbJR7UY1hN279MnB5OQzc1xdyuBsoHbRpbvzaDT1/YER?=
 =?us-ascii?Q?fuG+SGB2MjNCTFWu2TOiNb5Umjs4R5fuTbhit8IdoPV7RVXZlfGkFzKOgqiy?=
 =?us-ascii?Q?vhf0d806CJ8YJf7qcu4VDyuGytlLVrzbc63b3/NGN43ZL0Fcy9eOwOCKdVd0?=
 =?us-ascii?Q?S9O4yx6rm8KKQnyijVONjEyw3eDO61x69+Va0j+UFsPtukJe/NKesWjTW9UE?=
 =?us-ascii?Q?YZdlWUo4OKNsGSft1X5EOzMSe6vu+U7TG4i+HjPWGB/U3TqxGb6LecGaMzfj?=
 =?us-ascii?Q?OSJtWAGGELmHWSsa54B71RYGDPx9HBCUNffyQKh8bKRfiIm72FyVBEgCcR8o?=
 =?us-ascii?Q?wZcltfQw8YCQEiCs5wdEwc6t9igpDfvklJ+L83DRZcLFVmTIjHD/wQPG0hUm?=
 =?us-ascii?Q?OYNeDO6mwA4l96mAkN62srF0ou3Y4LxDjQUehQkKSZklp/SZjUWvnHiXiLg+?=
 =?us-ascii?Q?bJOYK/xae261t+fCleGIvVMIdMMqdixu1+6RH+i/b+w+pbDemzVgmtgU+qBe?=
 =?us-ascii?Q?9xxeZ6FHBIouKR2kLjvthvqbPjp9PLBC3X4w/rl9USIfnD0UrJZsjcFbfTuY?=
 =?us-ascii?Q?hvylBkHRnuktQl/tl4opP3icwfxY1DFIzbWGqqqY58vEgmTQ8SMF6FZPaoWX?=
 =?us-ascii?Q?gARMzzEalFooMUImR+0aTlmq14iSkCN0oiGgTZaNpbNmY3SFkGzPLRHXd1ho?=
 =?us-ascii?Q?NNb48n1Xdyf1dG+dNoZhHDcbY+OfFFcRARHhf51jBJpeF53oSEWxdY4LEBR5?=
 =?us-ascii?Q?too8B6wJD67HoKeMuYvJWR9wQU/O3N0CSdHQBi7IFn/XH/FCx6lt9T+OJiZs?=
 =?us-ascii?Q?mzTbd4ieHm91z6QOSKthL10MkQaEySJPh15+qZ+wLHJ48JrxObGFFWmRMncq?=
 =?us-ascii?Q?aa4dCODzTHWP4lIrPWrA12jsi5eLXanJRDWUqkoaDul+VGvGv3EpiWmlnfL+?=
 =?us-ascii?Q?RYyvuIsF8C97mkfpzTXAW6TNtdIPkGUySagyfi1IqLRvrLy81IMYGnRs6hEg?=
 =?us-ascii?Q?74tviNXK0sDt8F0bgL8/wmjPv5NHLz46VuUvdxXPlXp0+k6KjJ6J+S1oBxWh?=
 =?us-ascii?Q?sS5cYozM8At598eADnK4Z7zjXQFatYWskEkBpTW8IAdiXjz1KDRVsZrtKErI?=
 =?us-ascii?Q?cC+r5LFtBxCJvW5XYI8p2rPyTT9M4DqHXJCpIY5r0Qn5kYzHNz3UccPRc83A?=
 =?us-ascii?Q?DH9u7wipf1IEANR1XZyWzJ6qdWrEX+NW4/Bxhml3nDSmvdz59b9sJr9R3zm9?=
 =?us-ascii?Q?HCcDRE6rGTKtmg3OYzRgkvsnMHexYqKeQhm5gdVp+96nWoH3vWgjqF1DgLTK?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BmrKAhNtwhFujPvYykXeNEp6k0VPjz5UjlkpI8bZJqSAn4Yp9eskYEpJAzPxnvkebwHMS0F1TWCgTgtFp8rEQ+ruDr5M7+SG1TfO4l9a8Ml0IXKwtGnfKXdM+tP/LdkOf5X+9nVr8Qf0PbA7HCQ1AG3ggPmz02hC8xjgh6SSQ0URuyG08S3+Tf1SS6sJ9rrtdZJE/NHNlUjSurSs4265DZugFgnfRHdJRNpAQkQhzxeEr8RZ251VTHGkgY7FE5M5fZfSqdbHe93JLd5B0y92/8F5Kg8cIce//eDntx0XxHxJZrSvEAv8VzNAveIOtMXLN76BsDtdJT4F5zWnuUed5sA9QuTdoYlHSBZQ0JtEn4oUGrssxqwfpe+88nBt+ohWLPgEFtgNPdXGS6Fqt+TxbbmOiqzlwgLelQOkdcvAQvSEQgl2bdPaKHMZBQui6Ecuqjohq+0jhjR2kswJaFo6MxtWHrLcBUbx+GkqSqkryocSMdLj+ac6zRMnye0/W1Wt7LKTzrpj0s1BHyKjVkpnW//BWO8gkVGR/uaxcJ9q+SOlNIsreLbgHjqF6tG/XQvWPVDMOYyM7R0GpIIv6TMWZgQi3fIR9y9kP1spUrHuqro=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d97e47-21a4-4d8a-768e-08ddc0524f75
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 08:09:51.1172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sr4/fHwtXFPue/c1cbIq/dON1lpxt5GdQDkojjmi3bod4l/DzyoRiAEQFEboPG2VOhZA93SIBSH+0IJkeAIc6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_02,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507110056
X-Proofpoint-GUID: t_n78fyJJrt347YOa649lW8nIsgrNk1T
X-Authority-Analysis: v=2.4 cv=FucF/3rq c=1 sm=1 tr=0 ts=6870c6d3 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=RkmrOqiwSQOQut1nclgA:9 cc=ntf awl=host:12062
X-Proofpoint-ORIG-GUID: t_n78fyJJrt347YOa649lW8nIsgrNk1T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA1NiBTYWx0ZWRfXzVM07qDDtiTs YKw/YayP6GRjEW/q+2c5W0tmwl0k7XVsp6J1AhG2zyN5913wI3abzLXpEeXVSu9XyxoFFM4CFRS rH6vXniInfi2eWdMdIKUUCo7tBukVvuMLZbpEYCiKAuJhi3byhjPOWTaiB2qPL1SuONxXqcclf4
 5P5YpW6rWh437eYd5N4+39hNac4ni7MLPYGSdD3+Cu/jdu6YzkGcu/9+mb/40LeDrIOfrxHYB2a aClAlLE3dIHzzFT3udB0BcIiMIRZ6WccdOMvU3B/Tor35lXfozOnodmftm3PWrFtUah/i3qf/RE xDxiA/HEIrSWgsn9rcdRc7640ZwOEO0BB6E7PPgI29SUOVBwwJxSwmsovUc2wvh2wM+o9dPYjp+
 shtBih7jJvrCK0UATTZuWYLLDe/bmu9k+n80zwajJWd38jHet0eNY5rZMV2nU8Qm2d1nQD0H

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Setting chunk_sectors limit in this way overrides the stacked limit
already calculated based on the bottom device limits. This is ok, as
when any bios are sent to the bottom devices, the block layer will still
respect the bottom device chunk_sectors.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-stripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a7dc04bd55e5c..5bbbdf8fc1bde 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -458,6 +458,7 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
+	limits->chunk_sectors = sc->chunk_size;
 	limits->io_min = chunk_size;
 	limits->io_opt = chunk_size * sc->stripes;
 }
-- 
2.43.5

