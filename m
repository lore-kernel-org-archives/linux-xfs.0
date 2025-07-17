Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C311E5215
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 15:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752765572; cv=fail; b=PD/Gapwu0mAxtnCPIgt1UPly5XOLwG2947ipE73XcNMMNR9mEYttzQyYys7x45buO1TRMhgd85cSbE6XunT78n0tT6/3HbpneuTu5vm3YLgNMNP+WJDFQoapOk9n4CAhRS1c2D5e0BdpLSCAZh5kZFSu38aPNxopyBAdci4ny18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752765572; c=relaxed/simple;
	bh=nTy8axCBKuY146KeoilaTe6rX+bOy0DRE9ELftGPKe8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=L3hxmt1sQNBocCVyzwp8zlj+zBEsuFoDwXMxFGSWrUHgdbDZQCjOxaI4ei4+TcUT6deNzrIG9xREbrOzf3WZPfEhWRQ4iVsQ7w6MzUzlZ+Eddq1chHBkodK61JzLPWmp+/piqRGzBZIXQieVILy9kbAP/fIJHqHV8coisAW8pms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lwRAgxy/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=COBtVt+G; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lwRAgxy/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="COBtVt+G"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56HEggCp007122;
	Thu, 17 Jul 2025 15:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=QddiWmW3u8Pe4004
	BfYrpBOJ9mYrFqou8qACXHovL6k=; b=lwRAgxy/M8OAw2XQwTOBKRdxe+fBozmO
	iaVAp40rzUOvOW4la4GPdxuMvSEjQthhZtMc17cz59Yt8YyDDx60fx2l6pobj2S1
	iEe87C3DcndaXBPbbrZ/QzbbsaZTbfLUK5bYsqfYnw++Bvyae2L80V1JMULYG9xd
	2JaP72v4GfU3cz3XSycUhfr13f6EDTiDho/Yc4U/fuidZnGBXIe3+LOzQSvu64JS
	liNkYpjTUi7CHfB9JnH2Fm8lUQXV0yMuoFvf1PpYHS8EFCJo0ka4JQFqUpO/A9um
	0F1I6yICXUgNN6HVcjvkxiK2BrgOGSeX99epbUO3+SQQz9I/HO3r6Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ujr137xm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jul 2025 15:19:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56HFCq47029722;
	Thu, 17 Jul 2025 15:19:12 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011044.outbound.protection.outlook.com [52.101.62.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue5cjxqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jul 2025 15:19:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oi5rDXrIBvFLmBh+0NCX4dGebBZ4pIPPOPoYbl0zXViL02t/6CqGbSJhBdpMuIt9XzuxzBL23re4FYgunTwgg6Q+AlCa513IQGj3XnP9oIDLueE742BcCKLSzkS0gTXB+9HSeMt7vWKetpr+4uyaT4WNKJd2/rEVUmaO494Tvs6TOJT9B/sR4AnSSD9YW9Hb89v1UQGyHUw59CEn8/CO9NZWD+iCDWPgvo9En/YLfZlnXXek8pFl/ILofY0p3JZh4QSdJJobG/R8v8+3dsNNCwA+x8XJB9UQlOE5wHcm2Y55x9H+nZs7j7B9bVmO4LRCcMgrfvijAwGUB1eXio4B6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QddiWmW3u8Pe4004BfYrpBOJ9mYrFqou8qACXHovL6k=;
 b=FHtqB1+8Sfu1+MdkY2lNju9zDtE2HtOVbNh77A5Cm4IOUtL56dfStNG5msftGVodNX4bFlCxVREtUFWsuWDRqPnFOaXDP8lvKk6BgI8Mkha10Bc2rlm7ZoIpTtUiIg1D4e44taqxFaet6hzPQswFwzZNGKgBrcEAOkjvgHpAEVGpCeAa+QqctHpxYLkZEJEyJHk38zuihuvkpOHO0YO4HhtuE/JQNIdC1lw9K8UxnBpAue1FW0+8Y4Kl1CydIyPPt3maJb4T9UiwDRiS+Zz8DBRYkrLWfBQTq1501m+eAQGQjHYQGwmWx2A4YXFbDkb8jQxVFBuB2l4VnQRlUv1bDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QddiWmW3u8Pe4004BfYrpBOJ9mYrFqou8qACXHovL6k=;
 b=COBtVt+G86dJf7VaxKgK9ALw+wIPnwNBUcEbbsxLlxQaeRkedvnImgODaSZnK8OgIGeS8hP6svnK+mPeBzmsOLRJOfpI6qaafRqO926KdbbrXxcTaxXoxlWIGhG80pMV8h3P5tCADaC8ifxR5QctCkbkt9X8K+zx8ugDBjIvTlQ=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MN6PR10MB7520.namprd10.prod.outlook.com (2603:10b6:208:478::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Thu, 17 Jul
 2025 15:19:09 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.028; Thu, 17 Jul 2025
 15:19:09 +0000
From: John Garry <john.g.garry@oracle.com>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] xfs: disallow atomic writes on DAX
Date: Thu, 17 Jul 2025 15:19:00 +0000
Message-ID: <20250717151900.1362655-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:510:5::6) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MN6PR10MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b9a064a-a2e6-4d88-7ca5-08ddc54546c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wnzt5qskl6C99h4z3ydPNk22wz/oYqMRcbphItQEaZbkiLufwEJI/Rk+thh0?=
 =?us-ascii?Q?2MPyP9CM+fjMQ4gHdaUYKy2hv+/dHf48PxIzk/iziLe+qD+CP495PBQbYkUw?=
 =?us-ascii?Q?LmkWL04+jmrtFIq19xdymF8w0RnsUDSBxYerSLmSgfeoMxme8ZoCmyuekk9W?=
 =?us-ascii?Q?ku62iyNQb5gCzd/UamwLWbwpxb6TnA5UwORrd1v2A/mIeBRDj3i6wlwPf7KF?=
 =?us-ascii?Q?9ELE019UjIy6/YQmcrvEU99xNL90XcTF528OrqRmIEiSwGbXpPO1SEoaEuwn?=
 =?us-ascii?Q?NF8OlUdCqB9UWSR/1JcKQ9R6Q2+yqqiqeGNy/FKADNL27NyJbSIlFxaBG/Nk?=
 =?us-ascii?Q?GaoBbMv3aLJjcdj5NVZY7i1/lNUfLuhUnVq5pQEbUE9sxCnjYBWg40M/Pi6m?=
 =?us-ascii?Q?wjTTNNxcevZcyO0an4q1ZV1NyBakv9oHYEBkdz4OnEG12aKN/1V4Tj1J9w/X?=
 =?us-ascii?Q?T26YagO1APh3VDSt/6DdgfCjt8meEI6aAFytlusJY/lobHq6ZjbQFZCV60uN?=
 =?us-ascii?Q?CiGcsAmKarLe8xOjHpGMDEAvqVZm9RA7atLjoImiE0HJmCk8SOjGqTayRDn/?=
 =?us-ascii?Q?DZyke3R7ZFG5AAWXt5RVjiChmPDIZnpmYD/cz+ccpLFLmAFXYq9QgCu3C0KO?=
 =?us-ascii?Q?HkdsncVbWwgtewGH8O7pR+s7NCIwdurTH9otzWchD7Ku+zXiru8u2T5Doh81?=
 =?us-ascii?Q?zAKGNiLIxw7siSgf+UP+ymzlqqPBiaaisRhLWjEeIjvMO9Q8DnwOHf7bv65S?=
 =?us-ascii?Q?P9tTKP+AsvdE+bAS8CPAEeNAqBMhAusqVmsxcjcNMjG15+xSi0jcvwjaOy+W?=
 =?us-ascii?Q?fekWy3RxwzoxqfIIRJtOJR48y5QbQsQ16RNHV1hBs/plIScLS7rcM0QA2MCp?=
 =?us-ascii?Q?GOuuY4NMJk6OsB1gAG4n5kPrFIF8jPkZ1tA8lv3qeGw3tsSZrHqJsqwcNMhf?=
 =?us-ascii?Q?U4Zu2XeuLWlP3L8KdJL7sK59lQRstO+MUnbHw7cIgiPVTwp44Zq6DUGmBWrZ?=
 =?us-ascii?Q?BcMHSYRkZE4UqqYbzx6ZrcTDyWxo6yfd+sMKRNfnV/8cnaSTguxdv6HqGQOR?=
 =?us-ascii?Q?hs5vmyJztNO0IhKVe3DgXD/J9RimvIdUxb48NmtU3wYMW02UovuTSnLQ84V1?=
 =?us-ascii?Q?wiInasp11N9lZoWLxlbRZtZss9FF+aP68Z7UDEjXmSzjq++xyQt2RUchkPLy?=
 =?us-ascii?Q?cXluk6IthVXjzmZBVxejucUDi2Et8JQghOY0juwxrWiBYUNG+wmWIIiHXEut?=
 =?us-ascii?Q?uHmrsQSn8qQC1qp9hVOufyYNJto847gqG8wg3QnY8OxTM5FyzOzQR+17+UnB?=
 =?us-ascii?Q?RHpTMphe0GOu2NuNGX/cWOtncd+jOuO4BwadgfzU4KLj4War1GYEM2U6wuUd?=
 =?us-ascii?Q?OIH2xwsIoOJaCHEz8Jm76/6R/0kIrDGtKSCDa1+OiZlX6mxBEQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sasgpsqCaBYGpVeSpzm6P7PEcNQzSJzfmL+NmtglQhUVNEdbG6usiYvy2wDE?=
 =?us-ascii?Q?eW6V8oKJ/pGSqG0GwAJ0aFX52teP3aSgOfvSUVOZAjTcBURZ+n3K0Tj3WmaK?=
 =?us-ascii?Q?2Bl3jiXcs+TblRSYJKEO6Kl7u0LfvRDQM7bEtX8x9IoNRcoDmGYSmoMRSY18?=
 =?us-ascii?Q?wTW9GDFKtPAPGhfGjKuAywJebfEy3koUgBMxWTpzRu31dyTjNk2l6Kx1YV+c?=
 =?us-ascii?Q?lnbwjlvAn3o2+i4K4GY8VQmIRQEEvJslTie98ftr89GIIyB5BWfSJviP7XNs?=
 =?us-ascii?Q?fg3w12sKxqK0Tbmikg7O+rYKfSzkYGxhqdGloYUECrmIJCdVLB0cs+JMYm41?=
 =?us-ascii?Q?px1Y+rD0LdMPTvE3P2bY73Oyd6LXa2OmpKGpz8/F5p13SmD5CEVZuLx7YU5X?=
 =?us-ascii?Q?t8jcf4CmOyxfEDT27N0YzvZy52JLkufQiK6V7N4elrBjWpQq8uBlMw0RwbCy?=
 =?us-ascii?Q?hPIlH4xisjFRVRscYMErJTUCT9gsWjPfQxSgt7A5khTG+LqVHz3cXirYXjIq?=
 =?us-ascii?Q?hksHEFLZu5LY78bf4weLs3AYP9QskcZ/YN0koE/FVUp570NzR1DK/X1DXRjR?=
 =?us-ascii?Q?sND+/3WBZvJbTJWtNXe/5pwJnfa2S9xyyNmhWCn80G24gUBdPp9E6MvthKUy?=
 =?us-ascii?Q?V4lFpYE5Bm93jMfCVE7rj5lDEypmfCnWLyPC0M/NhEBwfQxibDjDFF1VSvEM?=
 =?us-ascii?Q?VV6bt2biXtkztfH35lzilhJWa8WO6Z5WapYAVcOH4GXKlTKqfgUUr7vNBDMb?=
 =?us-ascii?Q?hIPTyL63XSshMMdBdSaLqtZJACJ5qzQlCIPVFTXq2UNL3QtNGyMF3piVdfKm?=
 =?us-ascii?Q?nb1zmLL7O9mdJXdUro8NnnrMWfaBKZrgVUD6nIbD1rZuPWclZY8t1992e7Rl?=
 =?us-ascii?Q?WN7TWltdNLixSZb+JL/qeK3HLu3T3Pbe7iozMcRmCFOdDZhTd6A7yp5wlW3A?=
 =?us-ascii?Q?2JTNK4E+87e08+tNZHRxrarVvStDpoNQ21EI9YZJWjpwPekLW+IrQIoBSxXm?=
 =?us-ascii?Q?CyOfaCD7wPrEQHcXw5PD3+gOXKA+tDomw3N3ClSpae9djhJwQ9kEHwTCAXXS?=
 =?us-ascii?Q?eHEw+lXj+x2lRXIULN7NrVenstbKtXWFJND65U1kRirKZqxsEiuTdyX0vDM4?=
 =?us-ascii?Q?9e3Cl8F+FjwrPjU7+Tn3kwZW93yPE4wK9KdnLonAEc2T7yLcJQqRrjOFSbKi?=
 =?us-ascii?Q?bjn7lm5aDAuPhpvGWkb+7gpdJ3zhC7ATPdEH8bFhuZcStPrN+c4bbwHf5KP/?=
 =?us-ascii?Q?HI3k/b9hOF2yBFAL0PyY2M/1li0mwC64KRxbNWAVacxCGh6V++pvTWuq19sV?=
 =?us-ascii?Q?iX2PrRyBB3akGMVLXRfsz8LhR23y9+iTlj++M9uyiXpeXDQOq2zNa47OukqN?=
 =?us-ascii?Q?eMFhL2MRQvat48ouLj6ddDOIXr9nv84SNRg5JCXmPOyopX5fKOZrx82erV9Q?=
 =?us-ascii?Q?fAa5VM5g+gmt6DfUREwQKceamwyKij9cYA1K71bMLnXq9obrbbW3zc2dMaEr?=
 =?us-ascii?Q?jpQAlrraE+eNtuszszZ5FvmFX/Brow6kyd1LT0/P68vSE1nVBMugKwi2juj1?=
 =?us-ascii?Q?Bme5kX+dGvMBzuUUhKZaULeLi6ueHsUUXMDJ/M8IZYYe3Wo+xBC+0y8fvn9y?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p/8Vo77Hu9xRII0HSEDZRt0XSBep4NcS4gV1wcIhHMWoUV84CHx8rhmLpVJwYALxhV0HUzztugHtN0qKjUVHuEc5vv6kMGcKCRXkb9h0eycUlBnTY4gW9HEBbRXrbKfCYHKG0wbc8l4P09KsuEFQka96vmmXk7RCgMj0bRA4xFpQpTMTupAl2K65D2aGCSW1RpLyeC9C8kAAL8Sx95uYIPbTLZifyDmiKXWbL/AFslTq/gGw5MYUQzFyQpRSBCS6aCT1IVipRsh3ZHXfvUlKkSrSmOmVW+kNWviZneIFRnV2fTbjaznj9aQPicpzeBc/WkOeki6VTCN2vZSKLOZr3KIpkEBj+RPrcySnS+CqpFfq1PdO+pofwPaT/IqSAryfyS73qfDN2ZTQ1XB6JnXSNHLoW+6JFlk/tJzXlFe7tcboKt4Lg2Lmv4zWScvX4CAeLILigxffUvI+tgQroEWiEQ2SkktjWgQ173mKxCGI9y7NUpHYt3qqA8kw2pGodxHA1YJTnQ+t/0LxTSCRLWPT+gIgNIV0jV32cj03tAeVkyaEyW+5kuaiMPUoy8fCaQoEWlXnGv7jAmEgBpXH/RUsTQLS7KeMvdU6zQErPpVDecI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b9a064a-a2e6-4d88-7ca5-08ddc54546c8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 15:19:08.8729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bIdP7wrXpcXT77F6Yzgdi1Jy5bX8IXe3ixY0OkOkrdoGguEcCEOiUsY0Bqx1RNp2GcrjhmEZer5nQtVSRRxYjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7520
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-17_01,2025-07-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507170134
X-Authority-Analysis: v=2.4 cv=d9T1yQjE c=1 sm=1 tr=0 ts=68791471 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=VH4Skgj1srliuj6KCL4A:9
X-Proofpoint-ORIG-GUID: 7jzc3N-URofpXltpYWcL1lIgMLTWWJfz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE3MDEzNCBTYWx0ZWRfXyFH8fcy/5tkl UmtPQF9//UIEJL2yG1nDulsUMJADILJJ6+Bh23FXhE75g00q8HbWWJVQZMdMcsvusra96BsM4VW Ms1/OKvdusrR1iqH/CWWD0nK8ScCM03Bmi6uapefhF32P+BCLt5Bfv6TqM1xIkAXHhVtHoiQ9kG
 RXN3fGKnXJKAMD11eZ6/PJzBJIuGwHFxJcBW4V8LRffTrgppcML1eXA8X+4L/MMuIo5k2T4HcC+ SkEnX9rEVfMoy1IeFlaoY/mbkijqpY4W5XLsS/7QOgLqPyPdr9PUWVCyFXDEqJkwdR0zur5oTa8 LDGAK0TJBwBxxCbp7WbEu6p7X0GnHfTMzJpI6s3pqBrviaF+Bcxm/7pAxgPw+t8vx3UnsGaa6eK
 naGIvFWZPSnCWZaivteveluKAYCMCq8jw9BRghsBigdGcDQVTf3ZP2g6jw6FzHC18h9xPNBZ
X-Proofpoint-GUID: 7jzc3N-URofpXltpYWcL1lIgMLTWWJfz

Atomic writes are not currently supported for DAX, but two problems exist:
- we may go down DAX write path for IOCB_ATOMIC, which does not handle
  IOCB_ATOMIC properly
- we report non-zero atomic write limits in statx (for DAX inodes)

We may want atomic writes support on DAX in future, but just disallow for
now.

For this, ensure when IOCB_ATOMIC is set that we check the write size
versus the atomic write min and max before branching off to the DAX write
path. This is not strictly required for DAX, as we should not get this far
in the write path as FMODE_CAN_ATOMIC_WRITE should not be set.

In addition, due to reflink being supported for DAX, we automatically get
CoW-based atomic writes support being advertised. Remedy this by
disallowing atomic writes for a DAX inode for both sw and hw modes.

Finally make atomic write size and DAX mount always mutually exclusive.

Reported-by: "Darrick J. Wong" <djwong@kernel.org>
Fixes: 9dffc58f2384 ("xfs: update atomic write limits")
Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index db21b5a4b881..84876f41da93 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1102,9 +1102,6 @@ xfs_file_write_iter(
 	if (xfs_is_shutdown(ip->i_mount))
 		return -EIO;
 
-	if (IS_DAX(inode))
-		return xfs_file_dax_write(iocb, from);
-
 	if (iocb->ki_flags & IOCB_ATOMIC) {
 		if (ocount < xfs_get_atomic_write_min(ip))
 			return -EINVAL;
@@ -1117,6 +1114,9 @@ xfs_file_write_iter(
 			return ret;
 	}
 
+	if (IS_DAX(inode))
+		return xfs_file_dax_write(iocb, from);
+
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		/*
 		 * Allow a directio write to fall back to a buffered
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 07fbdcc4cbf5..b142cd4f446a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -356,11 +356,22 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
 	(XFS_IS_REALTIME_INODE(ip) ? \
 		(ip)->i_mount->m_rtdev_targp : (ip)->i_mount->m_ddev_targp)
 
-static inline bool xfs_inode_can_hw_atomic_write(const struct xfs_inode *ip)
+static inline bool xfs_inode_can_hw_atomic_write(struct xfs_inode *ip)
 {
+	if (IS_DAX(VFS_I(ip)))
+		return false;
+
 	return xfs_inode_buftarg(ip)->bt_awu_max > 0;
 }
 
+static inline bool xfs_inode_can_sw_atomic_write(struct xfs_inode *ip)
+{
+	if (IS_DAX(VFS_I(ip)))
+		return false;
+
+	return xfs_can_sw_atomic_write(ip->i_mount);
+}
+
 /*
  * In-core inode flags.
  */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 01e597290eb5..b39a19dbc386 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -616,7 +616,8 @@ xfs_get_atomic_write_min(
 	 * write of exactly one single fsblock if the bdev will make that
 	 * guarantee for us.
 	 */
-	if (xfs_inode_can_hw_atomic_write(ip) || xfs_can_sw_atomic_write(mp))
+	if (xfs_inode_can_hw_atomic_write(ip) ||
+	    xfs_inode_can_sw_atomic_write(ip))
 		return mp->m_sb.sb_blocksize;
 
 	return 0;
@@ -633,7 +634,7 @@ xfs_get_atomic_write_max(
 	 * write of exactly one single fsblock if the bdev will make that
 	 * guarantee for us.
 	 */
-	if (!xfs_can_sw_atomic_write(mp)) {
+	if (!xfs_inode_can_sw_atomic_write(ip)) {
 		if (xfs_inode_can_hw_atomic_write(ip))
 			return mp->m_sb.sb_blocksize;
 		return 0;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0b690bc119d7..6a5543e08198 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -745,6 +745,12 @@ xfs_set_max_atomic_write_opt(
 
 	ASSERT(max_write <= U32_MAX);
 
+	if (xfs_has_dax_always(mp)) {
+		xfs_warn(mp,
+ "atomic writes not supported for DAX");
+		return -EINVAL;
+	}
+
 	/* generic_atomic_write_valid enforces power of two length */
 	if (!is_power_of_2(new_max_bytes)) {
 		xfs_warn(mp,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 97de44c32272..3c858b42a54a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -474,11 +474,6 @@ static inline bool xfs_has_nonzoned(const struct xfs_mount *mp)
 	return !xfs_has_zoned(mp);
 }
 
-static inline bool xfs_can_sw_atomic_write(struct xfs_mount *mp)
-{
-	return xfs_has_reflink(mp);
-}
-
 /*
  * Some features are always on for v5 file systems, allow the compiler to
  * eliminiate dead code when building without v4 support.
@@ -534,6 +529,14 @@ __XFS_HAS_FEAT(dax_never, DAX_NEVER)
 __XFS_HAS_FEAT(norecovery, NORECOVERY)
 __XFS_HAS_FEAT(nouuid, NOUUID)
 
+static inline bool xfs_can_sw_atomic_write(struct xfs_mount *mp)
+{
+	if (xfs_has_dax_always(mp))
+		return false;
+
+	return xfs_has_reflink(mp);
+}
+
 /*
  * Operational mount state flags
  *
-- 
2.43.5

