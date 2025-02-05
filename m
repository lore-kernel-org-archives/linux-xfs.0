Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15098212FAD;
	Wed,  5 Feb 2025 03:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724895; cv=fail; b=nf9t9HZE7aBLBG1dibG5Klb+b//lzd7sXUfxsokxArDj2GE1sLulR4Coswr1PM28ME68xKoljKvMx1BLBt74rGXQpnCICZbAu+6w2LTzX14ikrEzY85J+tkVUVv4RcgEwxIg7Sqcpi1cKg/l5WkL/wPUUfCuFDFlhD/Q9u1ilHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724895; c=relaxed/simple;
	bh=dzDm247cCs46Jm0+3Mikbp9l5RebxToAWWaQSyBVQ6E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UKYRDZ9lBiPMBoe4SocSHzy33E9otuR2zfCKVLS/U8sRoHWTWY8WC7eCAY0GPqsG5CyR9wXzmukd6S8V6JyIaxy6HecwIAxdNlfop0MXuZhZFeZXhTGB0TZOUX4DZtTNxLrcXeGXCkwSRN2d9vaeKwCCC+xzn0AOfAWtZp9dha8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HGIftKsb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kDKV46YU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HGIftKsb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kDKV46YU"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBp97031273;
	Wed, 5 Feb 2025 03:08:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vH9lHVbQeP+S/xU0q3u4bpBX4YS45p0DSNh2Vo4kSfg=; b=
	HGIftKsbGXJJK6wEUuE441yDNh3xgZjhO0uh2/c/GhzYdg9BDW1GruzUMS9BQg8a
	FuYaqQCV835BB+H1Mf6gIC35f2RMl1D97u7l9W72uTMnUmMskVeTQqxKDpQ6S6DH
	YyiELrOsml3HXE+/GNKanoAnrxo+eJbXWXH4nHtv3DmcE/9V8rWiYpCnfts75pvF
	JLdwQXp90NOlVR3UyqHJdxiD3CYlkpsodrk7cMTTj6L+quOfBrGxfF7STPLZ19rN
	BmLXSfTVO2rOIicYzNKmxaZY9FaCgnP7uYZZS3YNBSE1L5fCayYM5a09LeSm5Av0
	A54zw9uttFa9V25nqQ3Fhw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kckxj3qt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51518ZsR037739;
	Wed, 5 Feb 2025 03:08:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LkpXmRGNmHHlhJrc1Xqp+RAXtBVSqDj03t4RQJKgKKbQFyjBmhFos0ejXbUdDuXbrEOTGFMJkvclznBSfmwY15iBUFJBH+kNn7LLG45Bdce6E0bbl/7aeU6p6L57RNRBcIsYMeMe+Hqeif7IW67jbegcvHCQuvTyi4jab+y576FigBYQGZ/YrGeZp0zSgw01HZrD+OAzAppkbSR5eVjedtSIr184TTPqDs8eZRKVoWe/50SkWXd+MDyCcaLMIZkpbWedbXXEklvMX3L2d/XPMLoeI7W/0JrLS6ANz96eNfPhlhwLtkRWS8op1lR4KdODRPzM9BSfJRlJzV0AUYKC9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vH9lHVbQeP+S/xU0q3u4bpBX4YS45p0DSNh2Vo4kSfg=;
 b=ei2znsjldZIIBUQQ2EsKaEPZlGhud385ewrupg+Gqn/0nSZpFsYdvaZgKhhjcLteK6LMq/tdghv8sJkiGFazylhXCfRxQUPxkle3iaytM4xk6UnP8i97yjsz7XrEISCawHif71NtRCR1hhTDkz/BQ/cJeXmTeNBGsKGoB+X7e0dS/iV+83Q26UOOi7rOXq2YMlVlqrD7r+5Yy05n4ckW82eohWUVx1VHXA/6qC+RxSlOmvGUYQItWBWLjC/PDFr9F3pPJwZLcXsN76woMQYpd4XdyWyLgG2hqNkMafH3HolMmdykSH6/fNYF+W22Iv+XBooJ/2UIY7r8FtaC/htwCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vH9lHVbQeP+S/xU0q3u4bpBX4YS45p0DSNh2Vo4kSfg=;
 b=kDKV46YUjnbT+DUU8m1gALjjoNxljIxYmmCPM83dHHAhBSvEiUJpPbWz5UiZFk/Sv24xot6w0q+LvnS7YxhwpjEAGXZ/1Rhfg5LgKSA1hzROp1rJsmnMJih/Fomu/LJFUAZlEN5cxHS3DiOG+czYkJ6weHQta5AIPwOhl8wOtbQ=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:07:44 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:44 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 05/24] xfs: skip background cowblock trims on inodes open for write
Date: Tue,  4 Feb 2025 19:07:13 -0800
Message-Id: <20250205030732.29546-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:a03:333::6) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 0688e34a-f81e-4ac8-99f1-08dd4592426d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R1brPaZcvpcrNDerZqUfMqI/ePkXZB+ORwmSAbDPvPdJYJ1irNpvcbdlgxcD?=
 =?us-ascii?Q?0pnMH3H5oQPWMaNOBGZNUB173oYg7bANmCWSi59nCff3tr9FnIXTlygHGc9b?=
 =?us-ascii?Q?SbuCTGhBXIKIVorMeNVf75u0pgNVQ0ISK3jAzsauzfrkeXx0avDdxoeBVrva?=
 =?us-ascii?Q?42AatqTQkzpxlHnZcUwdWhaE5EtSyZmYXQnVfxuJJ5ZKpK7xDqp+xJm4sG3v?=
 =?us-ascii?Q?v4FM4qIYhcGgKfyKaxR9JMq20Mtgrdf7ALqM8vtMoahHmeaxb3hRRY/hcp+a?=
 =?us-ascii?Q?/sUt5yPJLINohcdlihkZ2cJkw2Rseha+WLUCf4tIBTI+Mcv+ZvkdXDx9PV1Z?=
 =?us-ascii?Q?yezWIzOX6vT5tkwN92Ob6XX2gEDoJ0+D2OdYYX7NwSpGGBvDjz/Fs7b8R8yk?=
 =?us-ascii?Q?8MbzspSAQc1ZjToUn5DUznR49E8oSQ+89ELB/jcpIz4pd6JCWHgKYFRWC6hj?=
 =?us-ascii?Q?8iBDRUYp0U6TuXr3cT5cJnVqTP7aHINFw2jpRpVgMmYknUfWxntRJrj95ync?=
 =?us-ascii?Q?1flM1CXHcn6r80xD4ryHAZXMyq5ByCHXaei7egMXwekfeEX+6ze6ke3LanCK?=
 =?us-ascii?Q?l/oEZPizsQ4dC6pBDtM3OlZmHvS8a1vyHybyf9w3BfnV3vHykQn9VXljNyYD?=
 =?us-ascii?Q?u5wtCOLNUomEXowWVciq+TUZ78n4rtyRhpSXHAI/MeCnTOozBcPMIKOXXXw8?=
 =?us-ascii?Q?PcC/sBzE+J+eryaeo9LYH3z17bcOMFi/e33bdZkCQqyeNuAI4VziTB9JN1d6?=
 =?us-ascii?Q?RzZ4hWwQxqNsVb6K3xoYAZ6TfwhyJcgRo/snwxZMRsgG91i49jRwk/tPtOhf?=
 =?us-ascii?Q?ZWkXezHXCRwYzF1aEU2LaSvTDPKAJOUVJhjJ01j59b2jmoH//N7HMF6SmA1I?=
 =?us-ascii?Q?oyQjQzhoYDifdhb4/K+egUaKLsUJqx6FGgzI9bYlpQCb3K3NnwWS3cHH88dF?=
 =?us-ascii?Q?g2kVzRtMUv/vvjFlhL43i+d7pot1t3Cq1iv4UsKXM3+VGUpnBvw5IhgimANJ?=
 =?us-ascii?Q?OlUHCqz1IdfVCXCATtyU327cF0AOVMyrGfuWQYV8N9vA3G8IxWBVetv5Pqrz?=
 =?us-ascii?Q?WclopqclEuWBYBufGzOwNczwAAjZsQ8hgUVxM56y7wjehLUxt4J+iJB7d9Km?=
 =?us-ascii?Q?ENdlRrsgBgG3l0yYU468NvRhZOPI5XAFlHe6A3etwoNWwJ0VjXcpTbntxnP5?=
 =?us-ascii?Q?9OynB7zgN80UpwqEP3oU8XxoFqTSlKdR9TSlrcK99x2oGjIIM11638iEQ9JQ?=
 =?us-ascii?Q?ExsOf/45lzoMQ12OeYLWBMMQwqlNPB2s+uT6Xgs2NTY+X7pT1/6b9nXKbJF8?=
 =?us-ascii?Q?FDbSzX0hKOj8WpBtP95T8EHW8SwKBxn/Uh6ztPYATMc5QX72FQtDcqOkT6oS?=
 =?us-ascii?Q?Vj2j1sb0bI07fag9lIDfHb2z1+Yw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?95qBewvEK9kDnA72F9c99Hufu4ldIVpwfxPweh6eKgc/auByh8d0EFDQ2OsP?=
 =?us-ascii?Q?iOwdmdw4KYh5nI7d8w2OpZnokrzS2RtsL8vF6C6KCZIb5xWba2WomeIDHfw0?=
 =?us-ascii?Q?gcbLVTRUCOPMbmgiR4au5fKEdL84iQx21uO7JRUzvKzqpZQijE4dSFJU6P2m?=
 =?us-ascii?Q?RlnmCI7fvEy9UqIjvhtOatiTylCV6cT2HjxgPn9+jCRmdNgE4pn99nvQbLc3?=
 =?us-ascii?Q?w2Mjd9B2B4ZA3Z9cOL6gLKJxoi/YMYhV3uy500VHzD4leeDkE9cMujQHdEdW?=
 =?us-ascii?Q?jkeztPYF5hidb1IqWwD6/ILLQWBOc/BrdaNz5wcjNmwhricFiNAD6APJlt4I?=
 =?us-ascii?Q?C+0kz31ivQi5rFt+T26JLYe7gvpyIyWxo1qoAB/809GQrJkXZsF+/R/Tc0w0?=
 =?us-ascii?Q?TI/hgLFrn6AJ1gaDe/HK0hyY2RtkTbYQgar96ljppGNRd4Evf1WLMIxh/NtV?=
 =?us-ascii?Q?6XK/1l/0emwKF/kIFJsIUSKa6kTu9iDda8AyWwrIBMHXayKpJG3Pq0wdV8nV?=
 =?us-ascii?Q?JsQhcbawulB4cc+RwbqyenZE62FBFp3aQAdyiTK2S+/7f6nyngUeN5Lh91CA?=
 =?us-ascii?Q?qs7OlEvsbQNecSvA9ifQhiFZzGvR7Xgnva0KmvEFPAI2LiFanMduIIeHiGFT?=
 =?us-ascii?Q?y4UC3zlgaZcvqpO038fv2xY9oVumudZ70F6bW10wJWIsnbeBhVtJLvO02mg6?=
 =?us-ascii?Q?mDl0VnngCNU9ZoH2KJOSnNoFXQRSyaM0+B4yDPaOTZg8MyPiorTfBU+2eAiL?=
 =?us-ascii?Q?ug1oI81l15uST21iPl0jwEC3h9BeeijflNnpK+FjRAiLg1HtUC0QfnoIeqv0?=
 =?us-ascii?Q?qklIA5hItAV/YbMbhrvNq9LxvxMUmLbEQjQIUgHyJCCZY95aTbgH1vwgsMyb?=
 =?us-ascii?Q?3ehBa6qkDxax4y6ZeViutsoig2oXhN7Dpp2aIeH8+BEa+fSAKY4Xe2H8PVaE?=
 =?us-ascii?Q?PVl7Rzn4j2P7DkAyBx7G64UuLOD6ZgnLK8mHiv5BuIaxlLXzh/IO2KvzVEFh?=
 =?us-ascii?Q?qlcuYbF28Gjjv7SrGj8iuw7p2Bb8d2VCe3lG4K6cI+E+Pi4H32VMnlvYvXrY?=
 =?us-ascii?Q?ogZbD8/3n/uPFrgs9heRn4PCFDXaBoqWrm6zvPMfDFQl7Q9T+CMe9b09VNma?=
 =?us-ascii?Q?1IcuIsd1MKwY86z/bftSM7rZJuGiz/iJ1ueU6lGv03dhTY7Udmk+IoMFHN3I?=
 =?us-ascii?Q?kvHyqgQH0PJ1BUVZBaXLTLvvxEScSpld323OEmOpWnyhipyJB/4wD2/26+PA?=
 =?us-ascii?Q?pq2QaD47iZfIKA4WciSii2TD6aEbnwZCRUbdB/i7pFXoPsOk0oihH67iecGp?=
 =?us-ascii?Q?Cd48jMjdnVYiY8eqMEFV3EhopgknmIGCXKuC54tCT8aMBKxhmAcILN2ZSVeY?=
 =?us-ascii?Q?iwTpv+e/K7+UERCRHbgv4JdsIvHdt1CiaStSu6hLguUU/44sHn3iRewdTFpO?=
 =?us-ascii?Q?D7oQyhAXquThKZzGu8jC/TJ3pGW+cRwOAFBT7i0LgvjNKC2Je3VeFCdkEtk/?=
 =?us-ascii?Q?y9XYpEAnU3IGaIAGtdJC80USqxXONmgI5iQxyzwM2U+BEcobY2IMNiiM/aSn?=
 =?us-ascii?Q?73V8s+20U0PnGWuFjaeU7LzTCEO+mOXIhqXPwSGI0UUudkD4P06Q0/VXj624?=
 =?us-ascii?Q?3p2U1uETtKvEqYsKFBOJVtoXAU75Ib75KEs4g76yLpa3bHEoInOrtiBq4DU1?=
 =?us-ascii?Q?00iSgQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Gf3poP+6UyTSjTFC28I9T8C/rKsJuuJ+FxPqs9N/k/1QtCJLJOcpeIyPRKJJMMSh5meh7HQR+w8VJpPEIJw5v49Z295lqUUouVhIZyrin69VuSSAgx934/jBYs1J6Ae8C3825xuD9ISliifsl7DTbCuJyc4TF1hfVZfFpwGr1bSOCnr3xI7/pJ8cKNwrm77Tqx2NTJrZNcFft01M0gktAMZuwIB9vt1w0QX4EZGfPV38/zaWmul6P2/aqDxgcTI5nG+U7XEl7YBOyLDCerY2Lj0eLNQIcWXhVQDOLGC9G/q8TXqyjPuNEbTyG7gF13BJ1Ptr5dup64wF/CZVVclOGADJZCPmhGukIIDBcO4kuXXusijfmHF/GyrtiNH6vASi8bLipi+H7tchzS5TO3QG0NEHc9UJhtlPpiZjQs6rTNan2zwPszIYyPoMYX3o/rrniE3EPssHGFDTG7fLzF/NBCpXJvoKnsbgUANygU0rCxX2j0d2Idk4bCdxaaraIirgurNx5/vzXED0hjFCIk/HD/y2IZZckFIq5GStmzizvZe7q8zJVadPBFrNq0+gY+Wux3mG80HpcbVkZUU9DN61/ops/S5KOgkZP4aHu4Gp1RM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0688e34a-f81e-4ac8-99f1-08dd4592426d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:43.9942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYWV8spArnBInM5jUEcNlLOtxUW9EcZZQ8206sKCczVKx8GavKmBI2jUC/Ns06y+4g66N0tI+ddwKZeaUPY5kf9F69uLh88AaUAC/WXUy+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: T-1CiT4YT3K90WE0ftIZWAm71sk7nseE
X-Proofpoint-ORIG-GUID: T-1CiT4YT3K90WE0ftIZWAm71sk7nseE

From: Brian Foster <bfoster@redhat.com>

commit 90a71daaf73f5d39bb0cbb3c7ab6af942fe6233e upstream.

The background blockgc scanner runs on a 5m interval by default and
trims preallocation (post-eof and cow fork) from inodes that are
otherwise idle. Idle effectively means that iolock can be acquired
without blocking and that the inode has no dirty pagecache or I/O in
flight.

This simple mechanism and heuristic has worked fairly well for
post-eof speculative preallocations. Support for reflink and COW
fork preallocations came sometime later and plugged into the same
mechanism, with similar heuristics. Some recent testing has shown
that COW fork preallocation may be notably more sensitive to blockgc
processing than post-eof preallocation, however.

For example, consider an 8GB reflinked file with a COW extent size
hint of 1MB. A worst case fully randomized overwrite of this file
results in ~8k extents of an average size of ~1MB. If the same
workload is interrupted a couple times for blockgc processing
(assuming the file goes idle), the resulting extent count explodes
to over 100k extents with an average size <100kB. This is
significantly worse than ideal and essentially defeats the COW
extent size hint mechanism.

While this particular test is instrumented, it reflects a fairly
reasonable pattern in practice where random I/Os might spread out
over a large period of time with varying periods of (in)activity.
For example, consider a cloned disk image file for a VM or container
with long uptime and variable and bursty usage. A background blockgc
scan that races and processes the image file when it happens to be
clean and idle can have a significant effect on the future
fragmentation level of the file, even when still in use.

To help combat this, update the heuristic to skip cowblocks inodes
that are currently opened for write access during non-sync blockgc
scans. This allows COW fork preallocations to persist for as long as
possible unless otherwise needed for functional purposes (i.e. a
sync scan), the file is idle and closed, or the inode is being
evicted from cache. While here, update the comments to help
distinguish performance oriented heuristics from the logic that
exists to maintain functional correctness.

Suggested-by: Darrick Wong <djwong@kernel.org>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_icache.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 86ce5709b8e3..63304154006d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1234,14 +1234,17 @@ xfs_inode_clear_eofblocks_tag(
 }
 
 /*
- * Set ourselves up to free CoW blocks from this file.  If it's already clean
- * then we can bail out quickly, but otherwise we must back off if the file
- * is undergoing some kind of write.
+ * Prepare to free COW fork blocks from an inode.
  */
 static bool
 xfs_prep_free_cowblocks(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct xfs_icwalk	*icw)
 {
+	bool			sync;
+
+	sync = icw && (icw->icw_flags & XFS_ICWALK_FLAG_SYNC);
+
 	/*
 	 * Just clear the tag if we have an empty cow fork or none at all. It's
 	 * possible the inode was fully unshared since it was originally tagged.
@@ -1253,9 +1256,21 @@ xfs_prep_free_cowblocks(
 	}
 
 	/*
-	 * If the mapping is dirty or under writeback we cannot touch the
-	 * CoW fork.  Leave it alone if we're in the midst of a directio.
+	 * A cowblocks trim of an inode can have a significant effect on
+	 * fragmentation even when a reasonable COW extent size hint is set.
+	 * Therefore, we prefer to not process cowblocks unless they are clean
+	 * and idle. We can never process a cowblocks inode that is dirty or has
+	 * in-flight I/O under any circumstances, because outstanding writeback
+	 * or dio expects targeted COW fork blocks exist through write
+	 * completion where they can be remapped into the data fork.
+	 *
+	 * Therefore, the heuristic used here is to never process inodes
+	 * currently opened for write from background (i.e. non-sync) scans. For
+	 * sync scans, use the pagecache/dio state of the inode to ensure we
+	 * never free COW fork blocks out from under pending I/O.
 	 */
+	if (!sync && inode_is_open_for_write(VFS_I(ip)))
+		return false;
 	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
@@ -1291,7 +1306,7 @@ xfs_inode_free_cowblocks(
 	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
 		return 0;
 
-	if (!xfs_prep_free_cowblocks(ip))
+	if (!xfs_prep_free_cowblocks(ip, icw))
 		return 0;
 
 	if (!xfs_icwalk_match(ip, icw))
@@ -1320,7 +1335,7 @@ xfs_inode_free_cowblocks(
 	 * Check again, nobody else should be able to dirty blocks or change
 	 * the reflink iflag now that we have the first two locks held.
 	 */
-	if (xfs_prep_free_cowblocks(ip))
+	if (xfs_prep_free_cowblocks(ip, icw))
 		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
 	return ret;
 }
-- 
2.39.3

