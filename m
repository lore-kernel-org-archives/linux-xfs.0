Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDE9156F39;
	Wed, 18 Dec 2024 19:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549458; cv=fail; b=hrJ3gFxUZPegXZxOaYhCGnFSlC90+w4HeKNZRxbObp0lkTS9vfmB6w9PJQ/cBbRz9Aosm0juZtwcUKECpp8cqY7KHYiC7mVV+B6SUGyZ/Ip+QpZEaQh7p9RUq0YDn0ZHpCLO9gvVtp8nTCfyKt0WUn4IxeYQaR6DTaMeMzPzdZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549458; c=relaxed/simple;
	bh=0Ar1+fWvH0uh5c2X+hbCHJSUPA7BJz5YF7zTPdQI7LA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=hAXiogqG9sScUmlpg1dAVI9JT0L3igpM2JlvdzlTb1bc/tkQLjet3iDWdWRjDDIfoCo6c3ZDeBFCjTWu/Vi9x8pjtMnS+35/4cUJNdGpUpMl5PhKAaykJjtIoN31GomOe6tAj2b6zs7s+AsF/hq3lLJoPbzK6NsQKkDM1IBYzyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZtD9WDS0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HK+56QGB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZtD9WDS0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HK+56QGB"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQfVg005666;
	Wed, 18 Dec 2024 19:17:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=kwzHbe+NpmKtJWXf
	dbcIVyDSuHuXFI01x04OymWf/9w=; b=ZtD9WDS0hhhbI2VJcbopg+68ifTgF3gJ
	HLkCi4CcaRRwHRYhZ8MsYSwZVNjXkfAvphCOzWK46pb0BjhXnHnsxsJI+ZqixG5r
	vSHdveLVbciJ0JX4xX25R+fJl64R6rbk085sUd6JhjJy0ojW5fnu4U9jGpbr6/NX
	sQgk2iygbWCUozfrmkY4fYquHEGlVKlAZBK9Yf1sTQbWt1GNTybqd5TgyvQN+YOf
	o9wmXsLnpaNbApdzDbLCCFawbtYFyq3Q8ZT9Y1CR6uRReuQ2BXCZ+tmJ0gqafxEI
	d6uPOfZaid3MLdKxr3LC4Q9bLlQCA+sWLZgl1QFkAcjl69vzqC66cg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0ec9bu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIIBlkn035464;
	Wed, 18 Dec 2024 19:17:34 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fa8g1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BB1BASzMytf62FALXgUAiUc7EYbZHCE8y0eEBqHF8ToptS5XU3ETD6WoABi47ruhkJQK67GrPhbdjM5sXcW/h8vcftj0y7Qw1uz/JFEZaRcAuw3pHsh9qsWPx81n3irWbSG99c9pAMLypts6BwB3nID2WitIFtD5NoVfSnK1p9gOsgxyQKe6PyJb2rDlLe7FvNvpGtenK+tJ8ydEV7nDrYixJSRkMhFnNQNY9pC8F6c7Tg3RXISwoEXf8L64C/9RFpkYU2r0X9KuCbcHo/kzWrrm02ppbUHMTUECDcRTvgf+JwYMz4zu7X6JKwSLC9EoEwatHGZXycqjVTcg8ogbSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwzHbe+NpmKtJWXfdbcIVyDSuHuXFI01x04OymWf/9w=;
 b=nQJPtWOIoriU2A9DPi+UVUG+2qt2cVYJVyxI/6y48RheZcgfuC5DLLoBpkr0yLScNOVfuFfJBjnzSRi6SyPmGguccLT692ZhHSZCd8hsAWL3O1U/7FGPCDKLMX8JU5RYYBVBRwC2sTc+hquDgmCIp5++8H0vEJord80+K4LCgPlSmomyoH8dkPUpXdViQMJoeNjpgGTvDBNtTpC6fQbE7iQXGHWNN8b/wFsCa8g+gXHhekmJ8MaY5z63HopfmgZrFjrav1NnbgVq1N4q3i9vsonfLRdZ42puhiwKXVBZiwKvpmoM/DVH61wKsN2HtSJzTOzYIsiPvs8bIovE3BTQtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwzHbe+NpmKtJWXfdbcIVyDSuHuXFI01x04OymWf/9w=;
 b=HK+56QGBa0mWClczY8QggKXsUns2eieT0O8jeqn2OWOyVcFFnoY8n/Zam/K5kI4juwnpW/4OlEbb38L5m/tqC+AVqP7wMTzkKCMH6y4AlWC31NCtLqQwRj56J69UmtgoqbwNZchaMokuJWl+M8N+Di9qMFUL54sdzrOa3/wKlOg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO1PR10MB4481.namprd10.prod.outlook.com (2603:10b6:303:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Wed, 18 Dec
 2024 19:17:27 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:27 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 00/17] xfs backports for 6.6.y (from 6.11)
Date: Wed, 18 Dec 2024 11:17:08 -0800
Message-Id: <20241218191725.63098-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::12) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO1PR10MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d52427e-bdb5-4a32-45ff-08dd1f989c11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tIsUKo9N3RTaPajVfUmfZbUThv8TLLTUOXCPZbb3+J17vcvEB0p3mz1MdlzZ?=
 =?us-ascii?Q?vtspZtgRHJHgfoLiAONFCJc/XKn4dewKRqtyiIveBuICaTGp5YvyYFyiGXvB?=
 =?us-ascii?Q?25HKEKCUeX/4UjPLnPT/iV90qWgxGatIcYAowVVxNSivhEj3dtPPKb+KaK53?=
 =?us-ascii?Q?E00xQ55jXUpN/DRrBBCKxqjLCW2pGDm5kDvReT6ayINsJKBTGy0UCpRvTB9p?=
 =?us-ascii?Q?tZ7Oue4lx1fNLmTSsmYWLtEhKfDWLkNOaLTXd+YG8+pBJCAl71sqnVhOdQy3?=
 =?us-ascii?Q?uwOcpZEXv1Dq+Y7YiFOUmGUYP0iA15903VScxJE98stZKFIn4ZZfcJaq+PSH?=
 =?us-ascii?Q?V8RLCYEK7sr9HcBX/pl6heDbNFOLskaqGpDLBG2fRFWoEi1QFbBBtyPauCSR?=
 =?us-ascii?Q?UQsR8W7954znPCMzvnG7PVHsd90l0A9p6ISTrvua748jNWv99BmztYRpP9+K?=
 =?us-ascii?Q?5n3Mcs5dPPITSAxq4X1izPHs9pQV/vDDYiIE1EiQ86ejtPU/lqpI4MvfWya7?=
 =?us-ascii?Q?87wfc1iaZPOICOPxphkQtASOD6O3qvwfP8qNyvMhiYGZfj1bMaEZAYasBAu2?=
 =?us-ascii?Q?uQLxccbyTwew6KQLLU7rPAoEEwlcaOEMdNr7GTF+nvysMVhh0SYN2fT2c7Jw?=
 =?us-ascii?Q?u9f59PwOT+oFIC9F8ImONSjWnS0X5OCPnqfjSHElfGJ7kYKEbh8md/BYDtcD?=
 =?us-ascii?Q?MRkz40T1P4LZfz/DANvMUPGdrdTcyj24CBYK+ObxMdDG87tFN4Xa3VZPqeqp?=
 =?us-ascii?Q?6i26u55v+ej4fikeQsL8adWL2n7Xv0UrIxHoi7UEyMvUYpTKQKrA9V9TIZQm?=
 =?us-ascii?Q?dR8le27Hxk2wD6u8dHcL7TgmznfbYcB/BMTehNrlVaerzBM6YnFwoqW/+v46?=
 =?us-ascii?Q?I4qWkGLsmnlScVKLoN3vJPmdS1FD1JFYAGcq3jZ8r8U+2HSi2ViIv0ZocKQ7?=
 =?us-ascii?Q?jRMnzDHpZTERf2oAvsSFEiXhsOiE2pEwdCz0PouDsJpIspQlwRAnzOXgB8nV?=
 =?us-ascii?Q?XitxIYj+Gec2mfOZZcQ301d/eXqf6u+eztAbHlMvL5ADAzz+RrmSKR1AyIpu?=
 =?us-ascii?Q?RlUYa98bc68vv3mfHas3968qAL8mpi2CHHKJ+5SOHsZWNikntMMGnhB6WLRT?=
 =?us-ascii?Q?pVvoLzX97X/fB1i2PMz8HUTphAU23uPHyLDIqYhgKKCSB6bterHv1eUp+FTD?=
 =?us-ascii?Q?vAgVhk1urz03NgEYLOe/SVhp3hDsb5rm4XwwNrV8RR9hdOHoOhAPy8K4VoDt?=
 =?us-ascii?Q?eRmtQGzdmQ1P1uhIHjs5G6l0tziyOHD5w6CAPmfo6zICFTceP6tWE5Hc3wsO?=
 =?us-ascii?Q?y3SMuDeItFoiFYcXO0imv3ZORUecYMYc4BeLdykPi5xV3zojvM2zoI7neZcw?=
 =?us-ascii?Q?DG5WDHGemaxQ+OAtRsc31fvw6uKG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ty74eQdy4OQGOEiIXsW6JvPv/8xa5ydY33l+IiCDBskLbvXbGi/nuBYWwK3S?=
 =?us-ascii?Q?KNCga0OOiZgp+ZtaIRCD+30wbT5d2A9o2G6tfBUtc34rYifRhmtZuiq/8w0a?=
 =?us-ascii?Q?wzQhAB3PzfcLwT0cWM9kVQHGMTsSNOFglzWlJ0lr6+TB7nWTl9imbGiixD2T?=
 =?us-ascii?Q?swA3IN5yA723wnKmkWWmu91ZBrdiK51jAViMC4RmrYTVUcghiOyKcn+KnTTG?=
 =?us-ascii?Q?OaUUmH9YJ9sAuVA8W4u69CXRBklPojoI/e2/FsMiO9Y1dYeEhh4u8nbjv2KK?=
 =?us-ascii?Q?WQZwBBw3LsCYIn57QOF3w6GqeUlJFVDdb7Ldn94p38Vov2e+ZU/WLQ6TfcZR?=
 =?us-ascii?Q?fx8x37/Nnv9a6yoetKrOlrv3fzj+Libs9C6zZa3uno9lRKg1P1sU+RhPHzSM?=
 =?us-ascii?Q?0WBRnkQx+knb0rj0WZgiAjRdLwESRly7LqAYkEOiaDNE0j8eP0dk3WWI7qEW?=
 =?us-ascii?Q?CIq7HwGGUr1CwhbcsgB14AIIHEj/TUUfLeS9PqlJVeYZTDqbSfXFNLsiTE+E?=
 =?us-ascii?Q?0qNwuIi37d2SUgLcjID4eEZ0VOHmJVtwrebrtiasJM7D7M7NUcZDmwbogiS0?=
 =?us-ascii?Q?L3h22WoOZJi2/SYcLzTrf2An0aH5/aoqJSQZ2MQCw660PMG3zDKHzh2f19LB?=
 =?us-ascii?Q?qAV8iFY+ATmWKwS92hPTGCHKF6DDTM8r7Gir2hbrg+GiHF963HMWNVjBqvNk?=
 =?us-ascii?Q?xw/TsHTY47ek+w9Z6Zjd3fb9YCnEgOuIQSaReWcjrnXAwZ1Jj4aptWJvvvfY?=
 =?us-ascii?Q?c6wBLSxQX5+9bWED3kf/HV+iUKat+TFYyI8vmaXGEe6io8b/A/ZcjHbZnTUl?=
 =?us-ascii?Q?PrBSioD7HSdJ7LPGdDf1ASJV2X31RX6S4/cZ1q7u7Mfd9+nCrSuqZBtxp9b8?=
 =?us-ascii?Q?hIfNWG8Rzam9NQdSFToduOgyuE83EuTeN5l1Py/9xDcZZc1AMhfwssiHXwzZ?=
 =?us-ascii?Q?JF1Q/T5q6zLtZmF+lCftoKV9NjJuTb+3m76VlkwBLPehnIBl0E9mrr2yOZ92?=
 =?us-ascii?Q?ePVBjSgH7/f7EnE/LBBd5BEt5tAoGR2Fe/j9gpHJcUqb1oUVKg9wSKbup285?=
 =?us-ascii?Q?mPh9nEYxmpTIQmwRsdtt11KR1ySsZdGdv/HRGtx8eVueFrXMowQVSb5nVgpv?=
 =?us-ascii?Q?ZGFuA0akZhSWxnuTZoZ2b+eALCG0uAO4vkPXA2ZCbz8lLtj57FCp5d72gMRZ?=
 =?us-ascii?Q?zCTUia4DciswUm8rXLBfEM2qRVGQbV68zOShnWGIdceBOj7znPz8R+bAveWx?=
 =?us-ascii?Q?qOFgNeDSIYodAo33DjNHXrk9qhEmpr2jJVYTP+n3rs6X5SLmYqTyv3sQy5mA?=
 =?us-ascii?Q?uqqIBM5w4sAtpb3+6H+qHb9Ql746cEj3XpFa33ZWkZgqkmt0A+caj41BPqCj?=
 =?us-ascii?Q?2EYyj0TyVSfFY4USQpGZRzHN7k1VcwD7xCNi8eVWLTrniDoD4CYLCNz1xApz?=
 =?us-ascii?Q?H0Ep5MV2KpphBDSirwtX1FPETD3kLApg9T/XLP+0NRUDVJkeqRkIQHimIeDN?=
 =?us-ascii?Q?GSPh1ZhgkTKlij6R9l5PsFofCWmBbSCzGkykWU07YKbjQy5gXPTT5At7qdRK?=
 =?us-ascii?Q?kXxnYLIT4ym640w3LHjyYSQDHf2hrlLc/EJvBB8gArD3mKWxr0HMV8r8wwqm?=
 =?us-ascii?Q?IO+XHnHpdzYHyb4kFVFwkMiRmqjOROXxeEKgAm1qUFpv+EmQXc1QElIBsCBJ?=
 =?us-ascii?Q?RxXx+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LbehjcGcLK8jKWC7Q6XCJdO6pKIbTxyJMaGoYFVm80SE4HpXLh0JF4ezhv4jnTjK/3HTWpzHx0Iy7v+GGRuy4lNmaoWLE6zmy4BaJ1tJLsuwHsc410KRqlmtcrZxgPZc6wJupD0W2qZjtGcjlhMMFgL/f/902VuimvcEkeAJWWJwLqHXCWO/3Sps89Z+/y593wXn7z0rEAt3lx1NoP3NV15sE1MeDSRdof+R0snQVEr+Hxi6vYPqvXcneJ09qxMILLwA1XTYYvRhzZkEcp5O0xYWDK8bjHvvMCU4PLXyJCkNLiObE2Aq2sSobA6U9dOwtKY10l9PVCpHHZNNfS/dj2T7p6Cnvm2AkGowj5KmDr4uTRrdvl3lc1P+koYCI61C0sMcD+iKcTZgtFcbNhh8iNv8uf+jBbmPBS2VewfOazSMKK1MZ/TVznVyCuQQozFKcY67sAXXNagCCyYz5ue64WCgNGog+2Yf1jlLE36WtW6P+keKztdyzYIUEOcC61dXTJiaBDUbFFLWHdEFSgvCxNLelWGye+GiCsROhGT/A9H9jW+dNOuOIy9OoR3EMhGi9Wmi1wLGop50h10nXWUcb8DKj7MiroLjDeUKnrrp89A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d52427e-bdb5-4a32-45ff-08dd1f989c11
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:27.1888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4WDSUHOEiHaJOnw05+Y4sKxfRNxI9u57TvYpdUhY5GrD/7gb8SF4qY8KknehX16NaK8uArK1s8aWMbPyekcYxsAzXOIVcGNGlEYUbvdYSHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180149
X-Proofpoint-GUID: DUHv8rfdh2XRY-3hXVH8JD5BF5AMSLpB
X-Proofpoint-ORIG-GUID: DUHv8rfdh2XRY-3hXVH8JD5BF5AMSLpB

Hello,

This series contains backports for 6.6 from the 6.11 release. This patchset
has gone through xfs testing and review.

Chen Ni (1):
  xfs: convert comma to semicolon

Christoph Hellwig (1):
  xfs: fix the contact address for the sysfs ABI documentation

Darrick J. Wong (10):
  xfs: verify buffer, inode, and dquot items every tx commit
  xfs: use consistent uid/gid when grabbing dquots for inodes
  xfs: declare xfs_file.c symbols in xfs_file.h
  xfs: create a new helper to return a file's allocation unit
  xfs: fix file_path handling in tracepoints
  xfs: attr forks require attr, not attr2
  xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX is set
  xfs: use XFS_BUF_DADDR_NULL for daddrs in getfsmap code
  xfs: take m_growlock when running growfsrt
  xfs: reset rootdir extent size hint after growfsrt

John Garry (2):
  xfs: Fix xfs_flush_unmap_range() range for RT
  xfs: Fix xfs_prepare_shift() range for RT

Julian Sun (1):
  xfs: remove unused parameter in macro XFS_DQUOT_LOGRES

Zizhi Wo (1):
  xfs: Fix the owner setting issue for rmap query in xfs fsmap

lei lu (1):
  xfs: don't walk off the end of a directory data block

 Documentation/ABI/testing/sysfs-fs-xfs |  8 +--
 fs/xfs/Kconfig                         | 12 ++++
 fs/xfs/libxfs/xfs_dir2_data.c          | 31 ++++++++--
 fs/xfs/libxfs/xfs_dir2_priv.h          |  7 +++
 fs/xfs/libxfs/xfs_quota_defs.h         |  2 +-
 fs/xfs/libxfs/xfs_trans_resv.c         | 28 ++++-----
 fs/xfs/scrub/agheader_repair.c         |  2 +-
 fs/xfs/scrub/bmap.c                    |  8 ++-
 fs/xfs/scrub/trace.h                   | 10 ++--
 fs/xfs/xfs.h                           |  4 ++
 fs/xfs/xfs_bmap_util.c                 | 22 +++++---
 fs/xfs/xfs_buf_item.c                  | 32 +++++++++++
 fs/xfs/xfs_dquot_item.c                | 31 ++++++++++
 fs/xfs/xfs_file.c                      | 33 +++++------
 fs/xfs/xfs_file.h                      | 15 +++++
 fs/xfs/xfs_fsmap.c                     |  6 +-
 fs/xfs/xfs_inode.c                     | 29 ++++++++--
 fs/xfs/xfs_inode.h                     |  2 +
 fs/xfs/xfs_inode_item.c                | 32 +++++++++++
 fs/xfs/xfs_ioctl.c                     | 12 ++++
 fs/xfs/xfs_iops.c                      |  1 +
 fs/xfs/xfs_iops.h                      |  3 -
 fs/xfs/xfs_rtalloc.c                   | 78 +++++++++++++++++++++-----
 fs/xfs/xfs_symlink.c                   |  8 ++-
 24 files changed, 328 insertions(+), 88 deletions(-)
 create mode 100644 fs/xfs/xfs_file.h

-- 
2.39.3

