Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881CF54F85;
	Thu,  8 Feb 2024 23:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434503; cv=fail; b=fenFL0u0XE6TIf3mrwuHcr6ag/o+J3RxStiVFb9/vVTf/rnswnlJdnvw5Drzp2jFQjbnisycps0vd1xlpGbI+mBCtMEiwNTxFkbGxu3GHZo/QBxx83CJwNeJtNO8g0gIxr9IU2G8PqNanlu1SbCzBSxcFoArzZXPMN3CLaoOd+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434503; c=relaxed/simple;
	bh=3IOyiCDd8V1mnpSh5GfGGVyLq66eV4SgmrKp9at/m4A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ojwe20VEAbWkK7/kVNW9vdTI2xvcKTshNT2AvevFHGSKNztRBydx9Rt4z/2J7wipWN/h0ph1UVUzvbamLbYYRT68SWW+bkSD3K3Kt2MOWHK/u4E6IPjlPyK/YWukHBzLYz7EE5WYigTClEfYmwi43TYbT3bdD1obO9pgoZiYV00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ly66FNs+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IZxIhATL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ly66FNs+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IZxIhATL"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LSpkb016662;
	Thu, 8 Feb 2024 23:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=Pq22V6MBAUBZD5TQOvcs/gcJdL+9eizfW+ATCNcW878=;
 b=Ly66FNs+4qyd2/FF4WyMAQwEQMpn9Zjd9ojcHRrSuoQi0UP4KsqeVzfCWLM64YqaRzeM
 d0g6xr6ZWNZEShKcI97WYHbKjqFMuGt0UqRsxH1NQOoNV9+M9h3OrqlNDpTZ+YoehoZn
 kk0EAiHF5IuXyTAzpfMTkmHDOn1X+H0VKd5nxRgod0mawNUu9N6s/1RhaCMkPBbageIP
 aUzMRlyuzlZACQX72AISZ8S6FJHh1TutQF3senBLe+aFLkC0/mgJHazQUppmic3hV4CN
 7e4qqOHb84H7ox2gwPndLBgfAPV7vcF3DNtHVNPUJCFBIgJ1uXpkoHHqOQLX54t33d+R GQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1d3up3y6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418Mn6GA019684;
	Thu, 8 Feb 2024 23:21:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxhq5ck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdA+W1rUP++EJXngzdXXclnHhjAiw9G9PG6J1te7+6Q7aRMnADnbQ05sFxWuAvtK4Kt7sQZGgaZ6inxZ31tBE/84Tmhd+PU4Uigum0UIS8N1u0PLDZ1oC7cJBpflGJlUiUp02J9fpexKnYxjJahDKupZz8K5w11fq20RLki7bJKoZt3JihEu3VZ3R8XVpoPlag/DSuGsGLMn/JxBmjJU/mjcyF0pqiGOXGSIEaP3YLEm8BBvpK/Bu246snuJl26FJYfjuo5hQw2ThkBnAV96Et26att+ZSMhwZTU+XV5MRk8sCoTNyAgEoAZlbcofCiTRq5xCdSFnV87Dc7sIvnrMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pq22V6MBAUBZD5TQOvcs/gcJdL+9eizfW+ATCNcW878=;
 b=kaY/2mzNLkHnHltKsG9aJAAzPZVeIt2GsjSSH4T+4FhE3TPylieHbYFmslxzhGstOobhxWNAiZvN6h5TomH+tDPkdFy2lUTg8ObCnnT8fqoi7ngEV89ynfi/QkAmTe1GU0T2XWep8bSsP3oHJCHcIgJ7lY23b3thAoEgbMsP102QoHhlhOonrDQCI4ugWATEU9STvIMF0X05s5GwzpBMZwaQ/jcfgZe4GW6SWAbCy4Z9uUawgeuCt69Uqu2X+hrBqu1mxOBUxJg7YwpPjHbHSdPeoeJtlslP/l0Z1asuUIYKaDSkRwNJppOW6+qdYYppQGWDMmLKus96ultO6B+kZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pq22V6MBAUBZD5TQOvcs/gcJdL+9eizfW+ATCNcW878=;
 b=IZxIhATLL0TziH6p96V+dzgg1WtLVN8SlbdEflizmXzIj4BGEnqaITDLeG2wh2WcAop1SOxwb2wh5Zt6LkNDHZbH+2FbC0P4xf8+d0subuYY0HkCRd0Gt2b4hr28+usqEr83PpvNvb95NpCiOz6rAQP2KnMltJkp0DqKGw4jgcg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:38 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:38 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 20/21] xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags
Date: Thu,  8 Feb 2024 15:20:53 -0800
Message-Id: <20240208232054.15778-21-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0032.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::45) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 14b1b5ba-62ca-46d7-ed81-08dc28fcb2e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	j4XG5n9ucgUxvM+y7JzzwefU6U2c6CxbIlG6N7WD14ySBuNy4nRV7AZPBkiYp/goARE7sbivFgRU+hvczdVhN9wiebFFh445BpNiNnu7XQ/ZpzIcWLj8rVOXLW2TF0CG2hrj9HLp19g9u/sALxUji50liXgXLPnbvECFocUQZtw/CsXTJRbXrjHhwSkpDBqESAUh4BD0I/wz5FuPmwT62gYIF5mlc3YDHiG+DPKKEkSeYGt1bCZc6O8Ek/zqB7LbFqW/Km4T6hGIAZgJ9c6dmcKS/LroDkHt3VcqE58fG3wvMjWQsTPREzPmv5SRA9LCjx+0k49i1y8dsyQEKL5EhkJZaW638ix+o8Jo+H7OKrWR5qPQxWknqZcbyQMaVjMn1A4R+vZi1KJEsrJEiwU8+aRUGux6D7+wnSYja1d8wtllgXexxgNIpvJ5UTBBkzAAwZj6Uga869sw7MVpvu1uv9JEYnts3oPIC0xNU+/CZ78UJmZpyOT8PO/Bd+fZAZ/B+NCQmcLDkP9TAzlXoyNlIkolw1G0WtcqJS7RGgY3v5o=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(966005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?XIkLxsiyR2HWsHDsfKoVwZnS2OeaUPnnmNV/523Swa/S+LscqhkcdDrfQeWv?=
 =?us-ascii?Q?WKPa/1sOMzQKFoPnwH8/br0tC1D3LAnb4oLITTEqeH4dbsufDjvmpVGw3cIb?=
 =?us-ascii?Q?wJY6y5k6kOqdhgir1J5zwev/5cq2P3U40rauq+T9N/7qtICHoCUhy41rBnOF?=
 =?us-ascii?Q?cSUC/pV5rQVC11ynkSqFy9oQpzPHH6l1YZdWUx11E0gVG6pZpAhji4LlYAGh?=
 =?us-ascii?Q?0DbWGjWOatxRyF8aODEYTBcz4b8GmP3XNs4+ZY3lq7rTPf4sPFgrAXwQwwL+?=
 =?us-ascii?Q?hNAMWCOTkn4Tn4CVT2k1CV1hLvCqOQ5qKMns+FtPpGSeZDxodB+Hycrhbt2r?=
 =?us-ascii?Q?/CSVM0p4zFVm84ISkENg8x5eP01xPEVV++3zQ+/FyxoqqfA7vrgFwsD4RG39?=
 =?us-ascii?Q?egg1y2fXEN7gjldDqlWMqpe03yOhtglRw3zrS33EsWq9WGGApuT5MkI/4CzW?=
 =?us-ascii?Q?m5Dw4UMlyZV1KRMyOiMP14ToTdmx6P6bjAcxLChawdYrfGPzvhOq2dJ9fPfk?=
 =?us-ascii?Q?WXipWOvn4wvnMLWN2ROhpe21FdDNnGywIpBEwQqdEM0eC0DdCWg9RGoDzBU3?=
 =?us-ascii?Q?S6jR+uW2TS5Ip5NtoJbGPxtuXs5JYyuO7x/p3aSR230mjFpZbnOTpAgQMRH/?=
 =?us-ascii?Q?q47zaZy8HiWsC2CUWD8jgrymoxUu2gIei9DGGpM6BVc5FQb8CYeY5/wZHSKM?=
 =?us-ascii?Q?S8Ji9hcR/oO4xdOV3XD0aSQQyrxO0Qqj20um7JR5dcwAdtWlBHfmq4UVXtb1?=
 =?us-ascii?Q?1Ero97OufDxWDRICK5abBPeuK0q//Biu7+2yKFkCdCh3kjozO5OXddN+nua7?=
 =?us-ascii?Q?GnCud6V2RTeJgMXJRvt4ZQ5coLXIkbnPlTH+ZENLN6EpeX7df7hEipV+ELm3?=
 =?us-ascii?Q?mxAHsf0wwgiTp5absPGmHcRYsXi5X/Nru6Mfnk+8RlAQfRx/el2kR5w1poik?=
 =?us-ascii?Q?1EthAPUowEm0gzs0eTqKpietF+KBuhJugd6WmTyJFk8RrjbpnXTmtq6Ji3pp?=
 =?us-ascii?Q?jsxrihh5BQ2P7kVwXN/eOqSgarKIr5b0lPWuI50FO1d50/xrFZEOtByN6/f4?=
 =?us-ascii?Q?+TjMXkThimQPUrXaBJZwjMPEDC479V065etqhU0SyP7ArPkB3QFDz1p+7a9g?=
 =?us-ascii?Q?4rFgxPe7wua1r5rlOqkDCoBLhfZJOBN97u+aE52ZtSWZgb8rcPbcbUl4WdbP?=
 =?us-ascii?Q?O/xLqRN037tQdpDJIhgLt9hl1oRtdB56WwSrsnd8tNjUQSrvXwTQA9UBtnq0?=
 =?us-ascii?Q?0aETm3vpfbcr+g/g+BKm4yLAABcvQy2wsQrNKJqXIhINBzQ1DbCcuJH6c2fY?=
 =?us-ascii?Q?cr92L/75Y82Lmz4pmPMhENgoByc3UaQRoW7iYHIW46m9q0Mo2aAOpwjV1Knp?=
 =?us-ascii?Q?bziwaQ4vcAfblhBSsmrP2SoLg+AxrGb5KgTXvzpOJDVS4OI7/la2SOKoMjtz?=
 =?us-ascii?Q?jCHWi9XSXubY1xYclpKfsIw6Ao2bakLHMpyG4XeOzMnRXgBmckncfeht57ax?=
 =?us-ascii?Q?XeyxOnRBkq0WmV7ppvr7dL0gwmVAhFFSaWI0k7MJSY0+I+rPMHwvv2tsC0La?=
 =?us-ascii?Q?iep6luG4fOgCIwu2MIqc5yjNHnErzI7SXe91blPoWMM3K76iXSbh+Bqc1Ylb?=
 =?us-ascii?Q?Smz6y5CEaAPMe5lZO6nV3Bg60YoRKBE3TNBH+NVyF7Pf4V9RQ7EtNykuhg++?=
 =?us-ascii?Q?tMCMMw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	wLKMqYRqrqVWQ+avWKly3Vb8aVWITqCiDN0K/rMqcVQIHUMgtjOm2ZCszMrsJ5JZnphMRYbDMY0uS1znouSo1KvG6uUf8sGt+x/BHT93j8tw7kbLNRWs1iu43P/hfjCbZAewg1PGZ/5Ht4jpEutq1K2N1E9a7rvXSo5NeD1IiTcaZCDbEsKslcmGaigTF0RkpTEDLTd8AQ+TSXkfTuCcWtJfk7h2AukrZGu/+Okyrr9BBoaZHoR9r2p0zNDM6CPwEfyFQeEx5C63alQdirWsk7mmrifl0ZVhtgtl5kctsR9klRfxhp3BKeFgwhrefX1yJRiUrQDtpnvWUW+559T+4KnFprjwEqe6/tF7Bn0JZWjCvhgjtewB7gZsPgzReFcSiejH8geL1mxht97xp1RRz1ESJ3OgaV9nzyoEjhF3GqPJw4xJRVhLxBHMwa8zy3nKU1EmaOL6U3VGDcE139CHy5GB18qVLOlp76O9RSSeC+UEFFcO5OxWjMMoMNlNHYsi2TwdAYiefVuPaw6LuejezclMFGxl2j20UsB43jD7umtSq0xBuWnOo+pwZgNNEbp0x9pYgHfr70t09X/YRPvqxNunyJWUUUSrYrb/libMJO8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b1b5ba-62ca-46d7-ed81-08dc28fcb2e3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:37.9633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3m3aYKvdCi08rdTEP+4FroB+vDiDpzdFaRSYxAvCmKmSgCxLS2coxyq50YG8UXgPbByseErBcNuogqASQTGA1yGa6wr0ojdrxSWp7MnSnbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-ORIG-GUID: EUaSvvPcv3InLjbXxa49FhwDcmP9zQrc
X-Proofpoint-GUID: EUaSvvPcv3InLjbXxa49FhwDcmP9zQrc

From: Christoph Hellwig <hch@lst.de>

commit c421df0b19430417a04f68919fc3d1943d20ac04 upstream.

Introduce a local boolean variable if FS_XFLAG_REALTIME to make the
checks for it more obvious, and de-densify a few of the conditionals
using it to make them more readable while at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231025141020.192413-4-hch@lst.de
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 55bb01173cde..be69e7be713e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1120,23 +1120,25 @@ xfs_ioctl_setattr_xflags(
 	struct fileattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	bool			rtflag = (fa->fsx_xflags & FS_XFLAG_REALTIME);
 	uint64_t		i_flags2;
 
-	/* Can't change realtime flag if any extents are allocated. */
-	if ((ip->i_df.if_nextents || ip->i_delayed_blks) &&
-	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & FS_XFLAG_REALTIME))
-		return -EINVAL;
+	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
+		/* Can't change realtime flag if any extents are allocated. */
+		if (ip->i_df.if_nextents || ip->i_delayed_blks)
+			return -EINVAL;
+	}
 
-	/* If realtime flag is set then must have realtime device */
-	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
+	if (rtflag) {
+		/* If realtime flag is set then must have realtime device */
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
 		    (ip->i_extsize % mp->m_sb.sb_rextsize))
 			return -EINVAL;
-	}
 
-	/* Clear reflink if we are actually able to set the rt flag. */
-	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
-		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+		/* Clear reflink if we are actually able to set the rt flag. */
+		if (xfs_is_reflink_inode(ip))
+			ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+	}
 
 	/* diflags2 only valid for v3 inodes. */
 	i_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
-- 
2.39.3

