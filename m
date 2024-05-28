Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4FA23BF
	for <linux-xfs@vger.kernel.org>; Tue, 28 May 2024 17:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716916544; cv=fail; b=ENwPS/4SKmhKhSclvoVw0c1CLcuVak00FV9eBa7BWGYGwIvMOyuzi+x4iYvKXTaZQ/BV2gocbyR5X825EsJviEgIddFtffSRu8gjYv5fM0kXWoJ/psaGBXcu+lpmypMRjPgaMu0ljt/UWSL3SsETWlRdFITuva/hkM/9Yb6GUvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716916544; c=relaxed/simple;
	bh=rfiS/zkmoxuFcQOV4sw8BmvUjMntXnTST5BokogVsdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=orA/qBz+OWriylR0simpb40DNvJ76Tms3TzI5CfpZVGgiex4PAEP5zQe/g6vXme66dH1A29dRUAeI0ouRsz5H56Ll+UJz3C7QAQgSgs1T1ZlOf8R/Il9X1xGGnOqxWfiI4gDPPbfRTcojwsBzmTENB9pKiZdcRd3M8BiWQsplUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SBoxvH020196;
	Tue, 28 May 2024 17:15:34 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:message-?=
 =?UTF-8?Q?id:mime-version:subject:to;_s=3Dcorp-2023-11-20;_bh=3DZYClaQSPM?=
 =?UTF-8?Q?0S2r9Hmpeo9kzy2wm2nMJ6RkRYKgEqHG0c=3D;_b=3DDJ2+JvN3BKfM5Bcr3cCK?=
 =?UTF-8?Q?l9ATJjq2xH9ZpU72LQ2p27iEf1qOvF7aRhMx0Ewo65NoL5s4_F5RRZbd3twJJsc?=
 =?UTF-8?Q?j4PYJitSszoegg1WR+T7rcYldhNlDBHHMXM4b/albqEJxJKpsYbQJu_uIx/IGmB?=
 =?UTF-8?Q?dZIzjc7z8uduK8r6i/96krv89FBOhy5zZlLqSM7YjPI4fiHMwl4y1OilWZ2p_Zj?=
 =?UTF-8?Q?E+f+jv97JxU6xeVjDNyQHfvFwMzmyLtN5UGbfYh+iVbHzkf+lxAUwQOpGGWbW53?=
 =?UTF-8?Q?u8r_YRAP+mSuXY1ApKp1/VawTnrgfwUyztvFWc76HMtNyKPsqyXFnv+QsRIAH77?=
 =?UTF-8?Q?qrmwhpiHw_WA=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8p7mtue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 17:15:34 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44SGRaQa037657;
	Tue, 28 May 2024 17:15:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc5065swv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 17:15:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HxUoW/XU+eyEySPPRBu224JnfDYuYgYEFJTsVKzEa0vjApxisxP3p4ajGym3IxD86nvHhGRs2hC9E9nb5Y0Zo1D4BYbBB8qaorzfeP/OSeQRWHdqnXvRBW7TVYJy6YGZXEbH82mqjFphnAiUkg1oekvyUAQ15mOzsqBbp0iRCMKgTge5isz7wFzHPaP+ooX6YKZDrAZIEJFL21r7f+id+yfY9TU0Y9mxmx4HOuAnfvy4bFYpHZdjldWLTZMsukfxXsCvXKEpKcQkScaYhFt2SitXiBEPiGPd6kgnwqI8SW1cSUwT+voayoWiMk0eO109hUVc3VXjpWdvN/hVVu54pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYClaQSPM0S2r9Hmpeo9kzy2wm2nMJ6RkRYKgEqHG0c=;
 b=UXA8HVhOQsRefCUbnmY1qI/RCUXJkTnLaAWwrhV1vwyNfhz4AjdgjMewatS3hbpMyaUEkt+CqQizK84p+jflA3/mxqRhjiuCmeHbitc9LNHwUCTIJ9e0RzeqSOpkBdrsnoBNzNsNhzZhDaIeshxVaWZ2b3+n+iynPyfiRI7S3J6TBNT+wv6v1+YnvqDm38tWkm1+lwWojj//Evios3fL9Nm+TixBOBpz73F6L/pPaRDMmq9x+v7zV7A4B0oUoSO8cx6XfHU/0PJn5GzbHc9ZTMNur68MaophUPbIGt599hNW13ZPAm4N3QIM1ZSzsc+eQuE2yIyNTH2q9yISqdM7TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYClaQSPM0S2r9Hmpeo9kzy2wm2nMJ6RkRYKgEqHG0c=;
 b=N8BXEzKp5D16EKJniIiaI2VNjO+TGbCFHvqJJbjGO9qpHDW97QXiHG15Zj48Z+X9h+Q38PdoyP0NibXVrUxCkplPAmHjOqzXdHEbiPNJ3c+hNPGXNZ2UD9aCLrA8Dak7mq0Y0j1EQgTGp2ZV2BxSFsfxRpl+nYTNKFdgm76bu/Y=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5813.namprd10.prod.outlook.com (2603:10b6:510:132::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 28 May
 2024 17:15:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 17:15:29 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 0/2] xfs: fallocate RT flush unmap range fixes
Date: Tue, 28 May 2024 17:15:08 +0000
Message-Id: <20240528171510.3562654-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: 63ec8be8-fa92-4e7b-53a4-08dc7f39c5d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?S+MoZqkrO1Pwmz4VIV0sLXgYaJSfBsOKNjJaL3t3Olm03Z/eEYlWMBh7Wdm2?=
 =?us-ascii?Q?vkN6LPAiGc1QBbOJ8HlcLY2jl4ZH7vV3G/E8ePgE54oJRWYdQBIS0uDT70CY?=
 =?us-ascii?Q?idJb2vizbaiJG1p/x/+ysp8Ooc3VjJqjP3LzCcMQ9B8dk9fYVjg/kiGoQoQf?=
 =?us-ascii?Q?WKpALxrIcbttRY4GAjwT1xJqZ/jE7EpTEo612csGiTO2w0pPfHnLE2xjDaFO?=
 =?us-ascii?Q?mpiUWW1RcJveXLZqvZ3bMy25vcFeazHZtjd3iivbvj+11rxC9JwUMQKBS616?=
 =?us-ascii?Q?YBVQQJR0s+0rXZX4v+Hwi73QE1waW1ag4vsgrxR/wCdlKk2peGhDHaAVmsDj?=
 =?us-ascii?Q?s9xf9Nm4Tza4nN3E4ka2+RzT0/+l4voPkQI8k9J2y3kU+NHp2aPjhXRP8Pr1?=
 =?us-ascii?Q?RGrDhqsBe/MonOmvDOheQdtwTXQ5CSCBmZaSbuKewnOn/ybSkC8XmXqZ+Lru?=
 =?us-ascii?Q?Uh4ZsPjOAaThLhkxbBGzwr9MOgTEvx6dZ0moEUquTnYjxbhdtBQzHc3qrHU6?=
 =?us-ascii?Q?LKBwRITpnZL7TnZa+EneRHhHwFw0IP1teCDJJwixTmX40UvqZyWoS+HyCFKS?=
 =?us-ascii?Q?RXpXiC3JEDw/enyjrHVdEZwQ4Djwu2QJbxbX1thZoHG3w8ks8Q9gAXPZOT/t?=
 =?us-ascii?Q?j7NknjDiafIk9BwGWQbPsDLJ7gPBMBVHXSOFAg/5mhwxA+egjiUWqcrTVBU4?=
 =?us-ascii?Q?0ftBlDJ2hKTaIZ6diHTEgaMqIgHdj1oePbepQ6RqtdU+4dM/ShHlInRpNG/g?=
 =?us-ascii?Q?qmRO96ygH8Yrr3LRwrUHUw0M5N42Zzdjr/3cbNO9R1tL54i0xppryUTvwp/L?=
 =?us-ascii?Q?rRzbRD3M1IVSh4YswKeCn899O6JIuGOVLTUyhZSQDgziy9jZe/6RaoGOtCsq?=
 =?us-ascii?Q?NeBuC+rWysRbHVF0EqZ7VLI62KKn1iATBbM6QfzV2v7WhJ86JE7EfWLD597w?=
 =?us-ascii?Q?HPYsxsJwbbMTbihu4vT8huMj/KZXNmEzIfrdGJ5hKX6qCFocc+sdLWIDnI/8?=
 =?us-ascii?Q?t3S6QcGPxD3oABj8u8qvAGNKgLFV7K4seCKsw9yBPW43fiqpcJEC3S8TZJCs?=
 =?us-ascii?Q?SalFBgCneh7LyfJZ6Eh/lx4OJXbwzDhx3iGj4yYHnW9jYIBMR0w49QNoSWf3?=
 =?us-ascii?Q?fYJN3gp5RpLsi6re2LTot7xu4AQXu0sHSrNE6cqIY/1pBMQtN7MRteWgh4h/?=
 =?us-ascii?Q?bx0ZwVBVIn4Iz/JAIeKph9JGgNMifr3U48oiRQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?vq8HZVx7przsH7n+BRcpb2i4Iyf8AAaXDJgKlJKKYJwO0day5Bo55PZPLoVR?=
 =?us-ascii?Q?XFpTlwCPI35udLoUzWYvy8+4VduCL6IzZ4X7D8G5RYUuviGgH2HaD8X4ittV?=
 =?us-ascii?Q?mdE8FMZSezYQssXkqUhUV1m4yz6uf2pH0T7TLT2L93D3GkeqZaHW9F9MkSLS?=
 =?us-ascii?Q?Aya8fo5mCBtY2wHYgOoQvAA/0RnCn03neK+pncCyVyxeLjRYF+e5Q6OzbZqf?=
 =?us-ascii?Q?82dIrB3vyHlwvn051doAuxvoAzgNdyRnU8EV9DQGvMuHbam+A/piSumsu5r7?=
 =?us-ascii?Q?qlc1hxs9oKt58MKrlylzjBrfLftlNdE2yiWR8Ptp0ChrRGXZq7gaxtd20V9g?=
 =?us-ascii?Q?EfPNJqu+R1F1LqzpLkv3Cdh3MfpgRp9XV+MJzyqFqdhDxvW985JJ0W7bD+ws?=
 =?us-ascii?Q?5pdD04IOx5TTU7KP1g8j7+mebYTqRONsCym8LJEOUOgoU67ptBv8WMHIhJrz?=
 =?us-ascii?Q?q85zqlGly9t+xC+TTlTBszT6XVD6tig1FxIg+NybE+yH7lQZTYDP0xODNsZB?=
 =?us-ascii?Q?2H2BZqPnZpkOnAmx3ofKAd0EurkO/cvZ/ZnTLJktmsnWAd5OTGwiWHwO9jEt?=
 =?us-ascii?Q?Vd5WJS0FtxsPtSPHdMG9JuYFKzAlA5ivqftZ8PQGpGwCuPvQ8Mnz5diaPAKB?=
 =?us-ascii?Q?P4Tqo+YJ1XEt3S2aIPZCl03uAUQcQsGH5IrgHbirGMw+Pc+ZD3KB6MqLsfxI?=
 =?us-ascii?Q?6Cb5F1HDOg6+2O2sOHvXDyNy3Kq4zETWMH9Y2qvZ1UDKO0PI6pHlJWpqwXhP?=
 =?us-ascii?Q?bHTvAfBokPtLPI80XLxwawBrZ/P0VO/PLtXZJPboyw3/TrwB1WCIv1DSrFr/?=
 =?us-ascii?Q?4m7wVT/Vqj8yyXQIYxVbJHdg1CY4TLEZvqIoteIEyKuaQG6MDFA5Bs3GitMT?=
 =?us-ascii?Q?xFNPbrXRjlaMejNcgKuA2Zru1PpSnblu5EgjyiiGpS+n30g7dSEYv7SHkmjJ?=
 =?us-ascii?Q?h+uub08S2ksZUPVIPyHdeA3tLdxr9W5AZ9WayX5PErMF0+pxbKYLQ/KUEjar?=
 =?us-ascii?Q?FMqiBS9CeEKedAmiOjyEjEh/Ce3KX97a14RRx4KBry3HS8L4OBl8bWvC2xb6?=
 =?us-ascii?Q?i3/6fL9d4YHHro0KwWEeWg3cGV0umRy6PjPQH6ihNIE0phcgdIosOvtsMNxE?=
 =?us-ascii?Q?2lsUuNCGAJ6j1j0xWaD2sxDdg8ib6v2VTml+hvVi/xY2TyC/xha5Yuxmhluo?=
 =?us-ascii?Q?RYXX6n3N0+W4ylXwYpnwCA4NNAO7eXwZiYPMO6Mb5vf/5FnMIxKjZ6uINO5D?=
 =?us-ascii?Q?a7eottgZ6tvUtQP9h15G1NLAsp3VnQO4mLpXRNdXzGTwmVnPjT6CYcE3GdmN?=
 =?us-ascii?Q?qd7DiMlbKyAXoJWBpUFjJLb7AjlydEEhT22gp8KJLaJbOcCudhX2a9dFOli2?=
 =?us-ascii?Q?k9NBnlhwP4T1aBXSkWj3wGCgQItzD+ReTmpvoTOAXdqwo2ijHCSo/9E23x33?=
 =?us-ascii?Q?9F8iCLnFxWoh8R/hQvm+zyl2hmT21g1bbewHm15ItOQ5JMxyeVajLtD4utWG?=
 =?us-ascii?Q?gCzcmUmwec5NPZUjvi8FvBmBxGKqKmC/dg/zsqkH8c3JnBny8+OzRSDpPVE3?=
 =?us-ascii?Q?WkI5FbJ9Xqzewf8gyz4hy3KM4UXS1ZPogqhDYa0ysMhy8qNSxl7zVfXIy7mW?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	HCI9Xbad6pGZ6KvtPuMY4P3sEb+FJ8nugXFEbtxv1JGuQNa10NHMojCLnEOmqjusJu3yBBVx1ukUXFrTdDcW7qEWB/dPop/GZ03Kc+RSAk91M11ifz681FEmMMsrj4eY+U1lFnzrNZp9XP+2cWUBpO1+JEmmfrAARIAKhz+Iu0uugvmh+CKfL3/8ArPxX2h3kCxbeG5ILbGlXSCgxc299faVFIMjWB8fTS0Dt70QobLCY2tnxjarTka1s2XP3PNvzuKI/V6uByS/+hkhKvhnz1juSjyVh0dWH129CzTijK4MK8ojtnbL/Ormib3QOtfI/e0bDjbUqCebOSFp1Gy2Z/a6jZWyIyVWD7tG1GMP3+xS8MLTXPKyzedPIAI0oQ5rIWQLP7BzASAAK1wv2t9bB8ceHCBjloHQKRDVtzsSsr8XSwHJZ0jPwD1GfPezir6fjVE6NRwbzyUWRMiUFrWIy+0WMhjNpPi/Z0/6ZUCZUSnu0pze1sQqK5tl741eSrjQoI6I0n5KY1jM6kTpcQe3bPmQgt0pislG1nv6r1PplK4zkTnDkCR1hW4QGbTwUpTGW5KC3bG8H1/4XzaDIm1fwb6M1s2OH6vvXbVG8O40WK4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63ec8be8-fa92-4e7b-53a4-08dc7f39c5d5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 17:15:28.9585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7/gLHF0OSJBUyt3ZG9prBt7W0TDlIDSk9KhYsyzDz3dcqSk7ZSbcP7/D63UuEEPgj9NNR7f6DDXP0z2vfBNkrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5813
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_12,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405280128
X-Proofpoint-ORIG-GUID: KJg5DbMKhmWMEueMe56-vUjoKHLeceOP
X-Proofpoint-GUID: KJg5DbMKhmWMEueMe56-vUjoKHLeceOP

As mentioned by Dave Chinner at [0], xfs_flush_unmap_range() and
xfs_prepare_shift() should consider RT extents in the flush unmap range,
and need to be fixed.

I don't want to add such changes to that series, so I am sending
separately.

About the change in xfs_prepare_shift(), that function is only called
from xfs_insert_file_space() and xfs_collapse_file_space(). Those
functions only permit RT extent-aligned calls in xfs_is_falloc_aligned(),
so in practice I don't think that this change would affect
xfs_prepare_shift(). And xfs_prepare_shift() calls
xfs_flush_unmap_range(), which is being fixed up anyway.

[0] https://lore.kernel.org/linux-xfs/ZjGSiOt21g5JCOhf@dread.disaster.area/

Changes since v1:
- Use roundup_64() and rounddown_64() (Dave)
- Add Darrick's RB tags

John Garry (2):
  xfs: Fix xfs_flush_unmap_range() range for RT
  xfs: Fix xfs_prepare_shift() range for RT

 fs/xfs/xfs_bmap_util.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

-- 
2.31.1

