Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80FD183085
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718329804; cv=fail; b=OL6UrqW7hyw6zRmyxfOxVHhQqWZivOig0+zxPg72ZmYflBULs+Cau4jc8DzDeWV4GNUMQV6u1ysTbM+00N+QDHv68PeACX4w3QmXVDPaPeiKwbzHu9bY4lPU0WhgY5jmLYe3QHESSc49MuGfwCO5VG+hLAx+0rmhxH5SuapYfVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718329804; c=relaxed/simple;
	bh=rR+1/6FyAKBJMmqVkASxyuW+Rr/Lp68hs5Cg39YVy5k=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y87ojRoyFny3yFYafU/fHH6qm8enMb8bjUsWlhZOhS8PzIlivklcDyWAMYImSdlboVsOFWaHOignMoB0pFYnUtly/udIi2DiBl9f92V9ACoGr0NHvIKmju1QMnUkmi7PEhB2XG5AgCY3/im8IfrXJDi/KV5EohUPmRi9/7OdHhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ghtGficB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KNF+8LQ0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ghtGficB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KNF+8LQ0"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1goZr023646
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=EJtd8geM4PZXNGvBAuL6kI1RTJvHuk+clRI6j67iCPs=; b=
	ghtGficBJhBRhcWgdD7kWQC9l2oqytSkPETJK5bwBTY51DWxjDes1LBBWBC3ZLC4
	Nve5Eg4NFHxCXVB/vQFxFQf7HEZFXulhInWYgWx4p3JvAwSUu1Ajz+ndZHemOlFP
	4e9f1OamcCkDPk5YtV27l78j0ofAxP609BAFjRIQBg0V2JoMav8rOwA3g9RjVGH8
	lGm1YzLw4PHnTyxUYOixWeJkiO5N9j9nHPstrW6Xewy92eY85WwTUJQe4D02acap
	I9jdxw9mXU8bDdMDWK6tNBqJ9ZrNwCmNpaNKNNtyZEFmNQF8pxbWygK+nRKHaPLw
	j3RqdunlIUbc/16hWR0eEA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7dtseg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45E1FJsq020228
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync91ytxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsGcv+Gt4IVNdU2SJBiZMx1XaGet19RSpuhEZaftojnscPxjwNwQfJdn9WyXtGpi/3pvU8L4qqKSpvI8CGWAceywP+j46nNivMf2kuGwH/hk0rJRfFGEY086iagYShrTP/s/N6+pLmaTDJi7XZa4WhSYHFT3hNrA98s9zg7LPYjSlKMFDV2sEPKjEdvl0I/iObsqK4Zp1aBGzr+AUfiHVU6IlJPo4UgLrCoO+vbjkMPo2kEWTULs3jg8zqCLguywb50yX107FD83W6H50ue0Ei0fm/Mj0+usn9vCDdjdWHeuGFjRAN4ZfwedY8G81n1hDAl/W7MeRPCd8hYiirvgwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJtd8geM4PZXNGvBAuL6kI1RTJvHuk+clRI6j67iCPs=;
 b=LogyunMAG7MKEA7CUCBsY0bNsdei7+M/J8wahOb2mZd6pu4NjUA/eoBPIa6+ulyTzMFRpfgaOcMkcqkJxLg5a0JbUuIIDrP74okU9eWdQnxpJWtGxq2+zSWWR4a3VBtxBoA1UyvRsSIx+ppBfX4KP2FNstGmvWBSWNVrlogeXNFJm1maJVJU/ufnqeKthUUhK4b4MvzQ++YzCtNEFvwwi8wuBjluBEkcrfBarAR8LXqH50wxBWZhxonwhKANB/lZwMC7x9qjInaXdFzvnj2YVh4SrLT2xI9ZO0uAlEFAju5NENYLGJn3pXur9zn2x/vzUbaiB/IuY2VT0CRhbFsc3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJtd8geM4PZXNGvBAuL6kI1RTJvHuk+clRI6j67iCPs=;
 b=KNF+8LQ01kL0CJkXI1Z3Ui/1Jm/vCsYyGXy/rSunS5PicutVZf3FUaYYCYhbfAr1csaVRxN1+aMu9NeO3pPrdt+ilJHDmt4tjhwPv7PqnTi6pSlWxZAFz+QURiHSMhw22ZQyrLID3BZsaJI+XRBJdRhwfK8fuNmGK7vLv6KljcE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7475.namprd10.prod.outlook.com (2603:10b6:8:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 01:49:57 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 01:49:57 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 3/8] xfs: fix SEEK_HOLE/DATA for regions with active COW extents
Date: Thu, 13 Jun 2024 18:49:41 -0700
Message-Id: <20240614014946.43237-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240614014946.43237-1-catherine.hoang@oracle.com>
References: <20240614014946.43237-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::8) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e32c0ce-f453-4f9d-b7b0-08dc8c144b86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?SdbLrxR4X+Pp69X3gkD0fWDQEdSF8ioVCzNx40vUM6qsPfECYqeBnb4SVPKv?=
 =?us-ascii?Q?91VbQ+UkiAEPbPpDVT5KI+HKpa/1w6aq/s3vOQEcP1KrUIX7YhNNp12RFCI+?=
 =?us-ascii?Q?U6gvLmc4KYvcYvAPAIzzqMxAsyyQyZgvlAdpw3UAYJQjaV0QOBEVAEEzbN/s?=
 =?us-ascii?Q?4nsZ8IE1ePZY9yBaCzdXPqRXCnUoHN3X1vcbLzd2G7S9d/Dd70w9avYDQB9a?=
 =?us-ascii?Q?wurUrFjgfs0YjKr+j554uMIdkzbyVJ2PBh5DGA6gg6gLTBiu/OhimU7EFADX?=
 =?us-ascii?Q?r3LTA2ZBbt/Z13JmbEzSVjEZBRYid5JzWAKKzPaEak9r7TOei6WWOXERF1ao?=
 =?us-ascii?Q?NRP8+w3sYqviBmJCIex5rI6PGdOKRGAT4vbHBnOvOBaRm24SSaEJ7KM3Cv71?=
 =?us-ascii?Q?hXtUsvccUD7ABJulG7iXI7kA/b0IlLQxJPvmk53OINA+Gm1dJMv6KbbT3YPm?=
 =?us-ascii?Q?4pn6QsRO9T29NTD4donMiAVPq2lPb3oEp5hPBtgQgx2aQlZnJHwUx4IdiWci?=
 =?us-ascii?Q?xyd/oX3huylFvdneI3A08ucbYPU/u+O7KcvlwQsMQ2kF37oPsy0AGwvV0jXD?=
 =?us-ascii?Q?7BUPrB7C/e7pkbxhkvZEhI0XOLvA5QqwUeE0nT4fb93TSAsY8+PKyeu7heeJ?=
 =?us-ascii?Q?JIC9MdzAQopOSjqV5Tstlyag66U1yzkNQPh3o+elY+3wugnIAU5595/VOlOL?=
 =?us-ascii?Q?GUEQpbLDRT6ZHtb1Q7kWKw5VhrBIuU25bWebMgzpQKWnDIHJi/wyKEEBOCQt?=
 =?us-ascii?Q?aFh37iCyb73GMVydy3HLOkVUwmwJQkNVwm0VsbpAOuIoYnswqxRPxcBV1Ph+?=
 =?us-ascii?Q?S9cWnD+Yo3yqa+fGHPK4cuZeBiJYYV1/wPzo7co5sor21rKmON8mOBvJ2w7d?=
 =?us-ascii?Q?pA38mOKy0z0AQjVIfi19aGkwzlK3kqLzKkFOBdVey8vimCYxC4iHdJvTeg7x?=
 =?us-ascii?Q?TBXoS3GozwkrIXITGvd8DHXcupYhp4UrIYh/suQDFN4ngUWdOkwrLvniG0AL?=
 =?us-ascii?Q?gf5D7HeP9TsZ2Ft2kq5FH2LDsKyGd3bI2MpYF5+VdzJGY4GnT8bZcjrvMoPp?=
 =?us-ascii?Q?L9SP07/I2Cl6R6JgUpj1UDeMpe3enhqvkpL8cff+OJg0styjOdqtARTJD0b6?=
 =?us-ascii?Q?6o7MGmmJPpOlkFslx/mJA2Po6AJCQaFTOBjKwFIeR9/ua9mzKs+9ucy/9bhw?=
 =?us-ascii?Q?FsULNIIGAf/pYJUoGwYZ+kWDlmLX4QVRMcXAdzwuWWpiUb5Qs/a9JZ2XLT5Y?=
 =?us-ascii?Q?YCAuWpN0ZmPv1yqhyUKr?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?oipoSEq5ZEin3UDBJk88e6KxirrFv3WxDVZb+4kUHjPLmSKLY9mNtpj0xx43?=
 =?us-ascii?Q?xEG7Y+pxF5ndXzeLyhrsI7uWl1ARCKPNbtQO8b4r7rzT5+CM2oovgiq9DvM2?=
 =?us-ascii?Q?q9OyCuUD3LWSu7vzz4m43J6uuQslPwsHxhIBBIyjjNBDOgxuTy2e7GvFRZJi?=
 =?us-ascii?Q?RJNHifC9xzgAf9xTyXQHtN0qniz2zlfZ3lEaOqa/GhU6+hCEu6Bu9JM1cW1o?=
 =?us-ascii?Q?lDbqZrGbBGPzaMr72ZR4JhvDzKs7j3cV+qqkAa1jaLQpp1YK2tYsGAV+IUFs?=
 =?us-ascii?Q?W8NHMVzcNYVGvsiJMeo+BzKr9TNrI1HPAID2IePKhfkTuJUWl+AM5n7rrcK8?=
 =?us-ascii?Q?oXfodFirf8QXnkcdQYYscfrEqr1tZK1TTv4T0aKXrx9kex73wSqZxFdU8uD1?=
 =?us-ascii?Q?bp3JAnrPe0knjwh0FbNxPZNpNxnf/O1qNp+TgLX7bciJcpZl0uetD9LizPYb?=
 =?us-ascii?Q?5FVv86yPrFEvpkXXfgq4CXbFTGRS7fXtUhrbKIlWXF3Ky6W85/5ZcNBf1Zop?=
 =?us-ascii?Q?95pCPs5Q5QbQbsxpOReJn6TC/BgazkxFN2AFYGoxSEhZsEpPmNopzaaxYzkN?=
 =?us-ascii?Q?l/l3xiCIisVChKXVDF7GDuCt5WSwqndUNQeLjhXV0Ssd8r3N8sfXkXN0IRnZ?=
 =?us-ascii?Q?LnfAxvx6RUydjGZqeWIpP2SUEc44upB4m3ukPEEXmolCHnZLkI2ofzbtbwus?=
 =?us-ascii?Q?idMPf/PrbIVwxunTP1E7D1gS0RYdc7qNWdNtrzN1Q5Fv/sFsvKhozY1aLnRQ?=
 =?us-ascii?Q?BkezbPpfKY9KHdgnAO/h+tbz3I928ehsO3/vCbsl3Z4BraJhZG36h/hQCpFy?=
 =?us-ascii?Q?o4Jrh2UDc6959SPUdgKNP1bgT356JTk3ZjIX/awWqjLU57iqpHEVY2NjirxI?=
 =?us-ascii?Q?1PePo3iGiP1LCfrAEgb+dCyKuSMXhv04vw2DOrs0RyTl+FZSss/1v7WLyeZ+?=
 =?us-ascii?Q?arzVlvkd1uty+zZriHbIz97LfLNTzEncEr4RrISJHxL9WnrBkIyFHOpQ9wPK?=
 =?us-ascii?Q?rwc4yi3P1IPXicLNJpNT6KaXHcL/9GSldD+VS3ED2B9hiS7P/UwYPTBtkC39?=
 =?us-ascii?Q?NzYy9FyBDVeQvItr9/hvzTDurbU7xFBh9Eq7dXNvWQ2o2tcAj8mpTxHNcT3J?=
 =?us-ascii?Q?vQSuI94GlXLWQlGrxN3x2aO/3h3Ww8u7kE0MYgSicYPboGFFWsnoI+qoO3vF?=
 =?us-ascii?Q?j50c1dxu390S1fzmoFWLwUhGeEc7AX+beBRuYtGklil/4ph499lbKX22eISt?=
 =?us-ascii?Q?0+wDge2KOqt4/a5ZypjDQjzsYZkh2Ra3E0nu7AkL1+RNtjsIjZnbeOkYnYgk?=
 =?us-ascii?Q?ThT7+f4Mj4eqrmDd0WOio819rpvGYVHUihp2tm2Dw3rG0VOcWkEaZ9tc7sh5?=
 =?us-ascii?Q?BV/NmHrJlTs8w85Rqq9WiS/28jgtmpPsN+ldEL1WEv9ncNq3KIJXxWfNFd+U?=
 =?us-ascii?Q?OdFK/l7uNptDe7eG8V3XGu9LgeN6afQw3vjR2E2etQ5JFgrOxvJNvHf/boCh?=
 =?us-ascii?Q?lkZAaI5ImX0zgCxo0D3wk6BNWRHCof9q36YMFLPJG6wtYvTBzHOj8DposbLT?=
 =?us-ascii?Q?EoWrCWFK3Ud2PdP/SOX23vvDBYJOqPHphxGyZS4XCBmRovFotK8ILlcZbCNd?=
 =?us-ascii?Q?iC1ZOP3o56RYEuhUDz8t64XlZI1JQS4Ewe6bCHZfbu/lyruzCxc9s4EdrTrK?=
 =?us-ascii?Q?dNAb7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	uLNGzGhtciTy9uQIik/hjeJHbOx7bfib3EUfgYmi7HtKjbjD7SNabEMd1/pIN6TetAFeEXWhx1UYem3/SFnthIzKkECchdhWZK+IiWO7+nc1OQlYjn4HpczOJKYnjxhHS1VHluZdEfFoE4NToXS0NeSDlJ4wzATO4PeKYmSavl0zWcTpW7eEbJtrMMGYWOvISjJj9OW7EuxbRnppWJGjVynVio+6deBkiNMb6JdEJpV3kgxPqMxooG09HDtHFxasEHtXPyrUa5x7ze3q+us3TnuWI+9ailsVFYILflXzOG0ONmlH7+0NMrr6dvNIwzJhfgjwlRf7JU1xNtEodAWcut9IZQ7UvGtcmB8ouci6OHk+zIjAzooMChx/sq6UDb06fudxPi0kTITmrXldItGiWmj1xyQBOO6yrbFEzvGZ2Kl4FGg/jFvWU5evqHBukSD6zv7fXNQLDHjlINgOdEWiQzDbbrYsVvX6coAGhRR6J4SKrIVsfqjDMbQaDtrOl6+8jTHNy0kn9oStf5JfUNnZnw1Qdz5poY5acTyZjFbjYH1CtZxTKQxpC+Qmr+LNCoSoP3Wj2DO+dRg6IlaPPhXeWiH77e95Xm64m19rlwJh+58=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e32c0ce-f453-4f9d-b7b0-08dc8c144b86
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 01:49:57.4957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iwHHvcMYx1rZHL7KNdiW4/ejr/TrzBcRZwWz/KRs6o1G2Rx2p439Z1wKPIcUAhGq5KftlZBYwnlxqFyv7xs+z5t72fouWS5I/cDZGx7b0jU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140009
X-Proofpoint-GUID: Xdkp2qq2aYZyvqMMStlt6rzTPJIFp3RB
X-Proofpoint-ORIG-GUID: Xdkp2qq2aYZyvqMMStlt6rzTPJIFp3RB

From: Dave Chinner <dchinner@redhat.com>

commit 4b2f459d86252619448455013f581836c8b1b7da upstream.

A data corruption problem was reported by CoreOS image builders
when using reflink based disk image copies and then converting
them to qcow2 images. The converted images failed the conversion
verification step, and it was isolated down to the fact that
qemu-img uses SEEK_HOLE/SEEK_DATA to find the data it is supposed to
copy.

The reproducer allowed me to isolate the issue down to a region of
the file that had overlapping data and COW fork extents, and the
problem was that the COW fork extent was being reported in it's
entirity by xfs_seek_iomap_begin() and so skipping over the real
data fork extents in that range.

This was somewhat hidden by the fact that 'xfs_bmap -vvp' reported
all the extents correctly, and reading the file completely (i.e. not
using seek to skip holes) would map the file correctly and all the
correct data extents are read. Hence the problem is isolated to just
the xfs_seek_iomap_begin() implementation.

Instrumentation with trace_printk made the problem obvious: we are
passing the wrong length to xfs_trim_extent() in
xfs_seek_iomap_begin(). We are passing the end_fsb, not the
maximum length of the extent we want to trim the map too. Hence the
COW extent map never gets trimmed to the start of the next data fork
extent, and so the seek code treats the entire COW fork extent as
unwritten and skips entirely over the data fork extents in that
range.

Link: https://github.com/coreos/coreos-assembler/issues/3728
Fixes: 60271ab79d40 ("xfs: fix SEEK_DATA for speculative COW fork preallocation")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_iomap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 18c8f168b153..055cdec2e9ad 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1323,7 +1323,7 @@ xfs_seek_iomap_begin(
 	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
 		if (data_fsb < cow_fsb + cmap.br_blockcount)
 			end_fsb = min(end_fsb, data_fsb);
-		xfs_trim_extent(&cmap, offset_fsb, end_fsb);
+		xfs_trim_extent(&cmap, offset_fsb, end_fsb - offset_fsb);
 		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
 		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
 				IOMAP_F_SHARED, seq);
@@ -1348,7 +1348,7 @@ xfs_seek_iomap_begin(
 	imap.br_state = XFS_EXT_NORM;
 done:
 	seq = xfs_iomap_inode_sequence(ip, 0);
-	xfs_trim_extent(&imap, offset_fsb, end_fsb);
+	xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 	error = xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 out_unlock:
 	xfs_iunlock(ip, lockmode);
-- 
2.39.3

