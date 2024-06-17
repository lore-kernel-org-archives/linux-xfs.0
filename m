Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616141991BD;
	Mon, 17 Jun 2024 23:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718665457; cv=fail; b=LJKnaW50aOlPtba/FMNN/FKZqFotiDMj/J9clj/7REyeIAhnZ6uUYgQgi04l2JV96HAkw0tjqeJyImnp4XNAUy8xHvmn6X74CSyBKD8EVbzwew3CRuqQA0QcNjl9/kCw54bAuQP6F0mzxqUqSi6gg1MCjGhSFZgHy9r5Ih/CUFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718665457; c=relaxed/simple;
	bh=GZ7fsWG6av+uKO2BXDoLA0ldlQJRIGNTttAv98c/OSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G9zU9JEUk8w8mnr1GNeXbw9Q44ns01iUitlcRXsPvftuiWCJnLP0ur6mBpCmSKZ6dpozBVVicLkSOemfAuDlTDoGR6xiw3g+wSI9yHO/43jnzi8w4eD+OAhzkU+FQZB99RsNsDuzrjiZ3LHi4Ipv/K+k/Zd0xup5NHkBOvNzIaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cWeBOI5X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ga9Vi2PS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cWeBOI5X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ga9Vi2PS"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HMXaJ0029899;
	Mon, 17 Jun 2024 23:04:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=gVypnTaKZJvWNwjsx/5K+y25AldJzdJ/pSaWSiwvAhQ=; b=
	cWeBOI5X2P7uvfFJosP4WariuSVu8vYqTGAwYtmu8LMYu7ovHinY4xZil9L2LCkm
	3IdKPbqqd9C6POkmgyden5PY4ili7Wf0FplGndGLXtcbDfwbx+ET76YeHG3mk4b9
	R71zHCFEj4+PQqEJ06jW6WFhA6gaqWS1GoaHFfGQ+rPO6utnO3koh4s838bA8ksa
	Hl+2SytkvKP6S+ECfSfSTRePwupaHuDI2bDlQoyS1HF8CvgELjQqT2sYuw0hz3BV
	SG3KBM7Jj3eL2fs0WjJloE5pSp7vEQ1dxY1/BcHRJAAjIcY7WtMs2RYxXJuymjKQ
	ccfsFjrpF5ETZakeUUfMJQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys1vebt9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45HLO1li034800;
	Mon, 17 Jun 2024 23:04:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d7bfjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CORrY8aOA/oOjipJpdkc5L/JRdEqWIsUniGN+xyKUG/8fPoV7HiyLEbYXzfEcjWy3RaDnBICvVDJD1BC0X33HZhECzYE70YuBsxYPJZWhRYu4egXESU90gthJBMfhdO1iZaERqjUH1Gz4FOSeDVsYt71rQxlhtlUuVVc6XwvqEdCcQVSr2MwSNt5bi5zdMVYfGn/D3ZnwWc/pQ+yEWml2VonWZ3eqXDi8j0gP+fKIJKVwlmGzjWeynx3ts3DwYwR545WqLdO9S5rcdzhPjQ2PLPefLzJ3TNJ3Q39edPrBhO1eO3/hIez5wL7oCp7/zaGDpylIvvATYwA+DA+1/bnzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gVypnTaKZJvWNwjsx/5K+y25AldJzdJ/pSaWSiwvAhQ=;
 b=ZqsWvyVxU+3G6f/9QaJbWYIuZvUg1e+ycgjmM6vI6wNNKjqU3lYVA+6BSE0gGkBhY6LXApCJzpAdJEPmuZ1cdLBxQCFl9jL9AfNpWAo8AUnc/g/Es1OxMoebN6AI91xnnzl2/RQ7q3DiMijANRjgsYI/uOMCL2Bx4ZGavMpwc8GFrvrlo67SQDmvNXTHmdsXISPpiko16XO24XBwRMMZ8jEyZXTEs1kHIfw7BxC0R3FhIYFZ/VbxvSXIKeV19l8Z9V1Egel0orUpeJ6HJE4vzzIHvHZOy8ttwvu9JTA0G995eWEfcrX8Jv+2ncNwPvxLoVoIPSXY4VF8brrsomunTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVypnTaKZJvWNwjsx/5K+y25AldJzdJ/pSaWSiwvAhQ=;
 b=ga9Vi2PSJk3IWw8JIgVc/7cbuP9yE3UEXtvP7af8KaLo+EuRE/8wRIjknxN50G9uxxXNjw7S05F7YNbyXyvNzPc12H+UOzLqW0Tw4LZKAijvzRSHBxPX5Ubb5THbXn1EOMLMg5OZjp971LpYQpNDo21tY3BWk/1Z7u4OJYRah7A=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS0PR10MB7398.namprd10.prod.outlook.com (2603:10b6:8:135::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 23:04:11 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 23:04:11 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 7/8] xfs: don't use current->journal_info
Date: Mon, 17 Jun 2024 16:03:54 -0700
Message-Id: <20240617230355.77091-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240617230355.77091-1-catherine.hoang@oracle.com>
References: <20240617230355.77091-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0348.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS0PR10MB7398:EE_
X-MS-Office365-Filtering-Correlation-Id: 6405d972-4272-426f-99e7-08dc8f21ccbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?j5qNj5BltlzqA642/U80eFZEnZuyHhAnEd5AyC8mEElf7p9V8wX95qntFc7x?=
 =?us-ascii?Q?9XHRJZkR88zMlwIPbO9jJ4HatrIdPSs2zw1iPPSGS8OJhL+PQbgtqitoDb3L?=
 =?us-ascii?Q?YUctu5Nx7nM8N4sCMf4MsxAphkHBR6npmJKt+0e/vU1WJKD3Ki2H3qx8Dw5/?=
 =?us-ascii?Q?yfFXqHLB+EVP+PSKQaJ7lEt/fTd7oPAdEfyS2XPWiOJL8dtfLPpsUy+hLl4Y?=
 =?us-ascii?Q?fJJPClets8pvewJmHr4a+vl5FVWF0jcNtnHSwFVd4vLNjLA2YIJvMlc48VXl?=
 =?us-ascii?Q?kKnRtaIh4P8jIeV1E0stnQyM67wVrVLb0xT2G0ZWHOprRZvRWkbNaq6SJMZx?=
 =?us-ascii?Q?b4aJ8eYrq44/oUOnCbS2So6wuWhu7VcfGb7V4osCZybt7fHEO0l5jdAlkN6r?=
 =?us-ascii?Q?nzkYUSZiB2hXoRkCsyzURBTOGnzoCKImMK7L9t61/MRfW7NdcX/hGlM9SEzO?=
 =?us-ascii?Q?ucTX8Vp1beeLk1GTtoaoMN4MlBujvNA4avt2vFCNHziS3TiN5Yg9VsqGeT2T?=
 =?us-ascii?Q?XgAMgU49vmrcmmSgOxBwdBtXCR4DaOBqH2igHCKbONE3cIXvXRP9GjRhb7w6?=
 =?us-ascii?Q?utxuDpV5OU1KDN36CLDZIbQU8d9elI+7ONxJv8iyby53GHj/qudyoadH9Af8?=
 =?us-ascii?Q?g8kCnZcTIr/V/tLKsCmDl5zSDrHeoWMTNpPbff0r1j6roheWmDIAMeCR0b9/?=
 =?us-ascii?Q?fI9BK1kiTPGYan1TmIEDScf34SH3GYeFIA5PqtxAvbwaTbFgtM163X2boiNs?=
 =?us-ascii?Q?9lmCjRaX3lu+VTKQVFbW8zdzrhU4z1NcN1rKl3mBKJEyKR6Qz8BLAw2pzoJp?=
 =?us-ascii?Q?Li7roq2qSK7+10BMQxh9NFAxrVYdSusO2910AHBostZDkuOb6Z7vtHQ+KMuy?=
 =?us-ascii?Q?G/8J2n1VodU8f8p/k1NjxYndNyPeRP2GJH8cLoZczpYrAaFsJGq/LsJcUzjd?=
 =?us-ascii?Q?7S4kNnQL343nD+nwPBQ93TV8wYaWRFz41sw3cJLTk8ppUTHHs2hndKIEycka?=
 =?us-ascii?Q?F1UArgBB2KfL50TV2j/JmQh46AgQuE7DcDb8+kyWl8HiqwWZtCB76/j2gcWj?=
 =?us-ascii?Q?61/TnNZEeu6Z8PCgtV9IH180dRRtBQZWdm2YG1VT9txMh3+wemaByuFqGSh2?=
 =?us-ascii?Q?jqlLzq9Cm6RntS1Bcf/zDQwwD96YHRdLSQ0BtS8QMqD4thZ07sP1lqmthiC3?=
 =?us-ascii?Q?NCjzBjoFWlK/cNuuIpfA3BwILYCWxHxWzRN2SGOUSS05kkbTVpWH+jyjjBH0?=
 =?us-ascii?Q?r8HjA3jx4ldKWEaOEe/ICsN46Jab4yU0Eh2D/mQXgRIQznkrfDI167dBz73H?=
 =?us-ascii?Q?mfQ=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?aJ5Kj51BlwVdf5eF2QzRG6cXVFkvSA1x+/8GSrfKgTysxzEv3U4Lcg0+HAOD?=
 =?us-ascii?Q?mEBms2y/ml7hGSDOpnK2heAjeDBrZj6itoYgRxuyZzlmz2XMYOZKPV6IzVL8?=
 =?us-ascii?Q?DkWntWsjEsL8K5fOWaU6fFWQxnvDF1iep+HK+2Ux+pgFjuqYf6NN0qHYijUj?=
 =?us-ascii?Q?oNPhDcEkAgxusq+ImC5/be7bz/kwdMWMdsxSep+k+TnYHsP7BGsAOV3PQkAB?=
 =?us-ascii?Q?Un1hwWJu1KgogHPBX343JgNN75eyN0CuDHM+TGZ04aakqeYWj1OjyZrIubIx?=
 =?us-ascii?Q?6Hmr4GGwOWGaApfESW6CzKkU0ab2HG0g0gK72pYE30SfCWCxmqu9VnIlOBsR?=
 =?us-ascii?Q?h6UMJYgaGqbL+l6liwIfApH1BZWqYhrUVrupLtZvsha/KycspepAOJXKLo9s?=
 =?us-ascii?Q?CzFt+c4QTTCO2l/4JzAkl+vIzwpvnH7KCZXr0k3U2DypaUJS2oJOAeG34anR?=
 =?us-ascii?Q?+MUcsOV3uctGLsqFH9X0D+rAN6J+2ZwlKf7My7hIsVhXoB5NwUCsWqyI3quS?=
 =?us-ascii?Q?mh88xg309Biuhn/Ouqd7HjnMCKuQ/esiFkBx9vlbyvtdv3eRpAzyDgrglH+M?=
 =?us-ascii?Q?XCWJ18Xue6txhAE6HVmRQXupDxoB9CAbiukqQaD5I9zOclRCb89E4syYFZNP?=
 =?us-ascii?Q?CF+Hdd5eUL5+NMyoaEi/FwPyKVLEidnhhKrgK7yEI0R7tJyhcO+Lprc0H41K?=
 =?us-ascii?Q?WNVnT/YRhcipblvX6YjTxzcYgc3JMamj7vKW3gTh8YnbdtLfPjaq4ZEyvI4k?=
 =?us-ascii?Q?hE3KT7bfBzWRy0jqR+ENCScdsKQB7JHtHoVpJDpcqtau1j5odmJL3Ui92Isw?=
 =?us-ascii?Q?q/9Coz7y5PcBONMFMNAXL+LIQfVDaG9l9t3NK0Dre1YhicDfkgS6ZYnOY+FT?=
 =?us-ascii?Q?PMg1dWycwqUlRYUuLa+Zjs5/kaQ/esV8jhJ/lxLowQMRwqP19C2vr+0tUfEU?=
 =?us-ascii?Q?ZMwbzK8pR44oQLCN2eC2hM8dVAK18L1xRZirnilvuWgVGEsOQpTi9uqgcc57?=
 =?us-ascii?Q?XLzSK7zIDLyX1apw0L9CabDMl0CzHjdEtejTVGIGSqzY5/Vk1fNu1OmPjnQT?=
 =?us-ascii?Q?0kLCGkCCE9i2ZTgfT6i7XQIjw8qURcMYpBdjmiXkVV1N6PGBW4Lg9+Y1tQB/?=
 =?us-ascii?Q?Gf8x7VPz2XWMNgx7iH4lfa5F4fU60H0nuLhjqb1G0hBbBu2nsdyJ7Ad5xxZz?=
 =?us-ascii?Q?SS4Vb5r5zH2JtVMeLhVbAZ8GMUBHtV1NyPpV1KkXHduqNHA1gqoE+/nyWGtQ?=
 =?us-ascii?Q?D3Cg43xbJEepD5jhUa/BF/QOU5MWfnYRsNNi9VvJXlh9EB1lGjRIU2k52zat?=
 =?us-ascii?Q?gLVn+6bdbnsEZgPa6FqXAkZNIZP07tiV+K9TjbpMzdN5aRZC8Ipkh5Sc7+rJ?=
 =?us-ascii?Q?9DsSr3iM2DTe5Jxh+gqsbJ5At8VokcZlTJTF3ufyvtE8LqtJ0JxO3ogI/Nib?=
 =?us-ascii?Q?CASna3QPybuFWVGP+7pzd139tUdaKcqEwt1+XCSILli1bsMANpSn1kk0E6PJ?=
 =?us-ascii?Q?a0JaPTBiAUvn6C2wmvsa4GcFyKGH2W0tNo/n2937gc5Ip+oT/o7cxF7WZWcG?=
 =?us-ascii?Q?NurRfrDR4cLC3fjzVos5rO3NDTbRTtAjVivYC/scm301pdWOMk4g+QsnMLcN?=
 =?us-ascii?Q?0vkgHU67XTKYCphw7PuAdChS4FCyNRAa7VWZEtNhtuyeGrZCc8stWpfsQGMF?=
 =?us-ascii?Q?jdK1iA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	qA1tmZ+aDej7btnOW6pSvrPuEcBSPbkFR0xY/wJVN4nJuECf5A/6wSJ0/0RRPh0HfcBRc9132fB0lMHRo1QLDZ0CdeAoSsypJophHDPGd28l/rTmURPFXTOxNp79CksHgvwAOiIJag0IaQ27Dn6ODIYbQh2dAmI+62WvfaF/AiRMO5mHfdd1J/SUc++id1a/XtZMPRMftKqg63Czd8yjPzZKWDcWil7Ggu/8aB7hc/p4thfo8DCG98vb+IMzdQPoA5TYQBjER0+Mxl/6C66DKMJBT2MZtCDGt4m8qSESSP+VtefW0swyahy/bHz/7yLklRWta4N42OxEl/J1YIbZKE/r+wWwbVd10GK8dMJucUzutHVwm7/FjvWyx/JeKC9ytlQFoetf78J2l1dsl7cVWQBTvVa8HKM6oJ9ng/HfQcrlAEadEZrLwjiDnKDeunKz7AhOo52oHEAcxPW/rP/sSx6NEnXfOHk4C+9Ok1tJBq0Gntb42cRNrB3pNOvpJFp7NxIRGT8E6qHyr0bdIKUSQbtQW1QISWQ1XAy0+/ta+iq6PKNv9edPLW3H5pvZGsY3k+KVhedSzn1+AQF+QZbmjMkhz4Z8m7wMuk6h5e5DnG8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6405d972-4272-426f-99e7-08dc8f21ccbc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 23:04:11.2834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XNcP6w5ixmyEsDhDc5fg7ju4JFMB6/2p92SyBVKQId/m3DqCHGoTjBgJXbmQ1IGV1bcBtfCGgQhe9QuRQSOlCntfP/LtdnOlIYSL/5nVe1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406170179
X-Proofpoint-ORIG-GUID: QkUDpUMFNNeKJaPe70Hn02a7A4hnd5aB
X-Proofpoint-GUID: QkUDpUMFNNeKJaPe70Hn02a7A4hnd5aB

From: Dave Chinner <dchinner@redhat.com>

commit f2e812c1522dab847912309b00abcc762dd696da upstream.

syzbot reported an ext4 panic during a page fault where found a
journal handle when it didn't expect to find one. The structure
it tripped over had a value of 'TRAN' in the first entry in the
structure, and that indicates it tripped over a struct xfs_trans
instead of a jbd2 handle.

The reason for this is that the page fault was taken during a
copy-out to a user buffer from an xfs bulkstat operation. XFS uses
an "empty" transaction context for bulkstat to do automated metadata
buffer cleanup, and so the transaction context is valid across the
copyout of the bulkstat info into the user buffer.

We are using empty transaction contexts like this in XFS to reduce
the risk of failing to release objects we reference during the
operation, especially during error handling. Hence we really need to
ensure that we can take page faults from these contexts without
leaving landmines for the code processing the page fault to trip
over.

However, this same behaviour could happen from any other filesystem
that triggers a page fault or any other exception that is handled
on-stack from within a task context that has current->journal_info
set.  Having a page fault from some other filesystem bounce into XFS
where we have to run a transaction isn't a bug at all, but the usage
of current->journal_info means that this could result corruption of
the outer task's journal_info structure.

The problem is purely that we now have two different contexts that
now think they own current->journal_info. IOWs, no filesystem can
allow page faults or on-stack exceptions while current->journal_info
is set by the filesystem because the exception processing might use
current->journal_info itself.

If we end up with nested XFS transactions whilst holding an empty
transaction, then it isn't an issue as the outer transaction does
not hold a log reservation. If we ignore the current->journal_info
usage, then the only problem that might occur is a deadlock if the
exception tries to take the same locks the upper context holds.
That, however, is not a problem that setting current->journal_info
would solve, so it's largely an irrelevant concern here.

IOWs, we really only use current->journal_info for a warning check
in xfs_vm_writepages() to ensure we aren't doing writeback from a
transaction context. Writeback might need to do allocation, so it
can need to run transactions itself. Hence it's a debug check to
warn us that we've done something silly, and largely it is not all
that useful.

So let's just remove all the use of current->journal_info in XFS and
get rid of all the potential issues from nested contexts where
current->journal_info might get misused by another filesystem
context.

Reported-by: syzbot+cdee56dbcdf0096ef605@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c | 4 +---
 fs/xfs/xfs_aops.c     | 7 -------
 fs/xfs/xfs_icache.c   | 8 +++++---
 fs/xfs/xfs_trans.h    | 9 +--------
 4 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 23944fcc1a6c..08e292485268 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -978,9 +978,7 @@ xchk_irele(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
 {
-	if (current->journal_info != NULL) {
-		ASSERT(current->journal_info == sc->tp);
-
+	if (sc->tp) {
 		/*
 		 * If we are in a transaction, we /cannot/ drop the inode
 		 * ourselves, because the VFS will trigger writeback, which
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 465d7630bb21..e74097e58097 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -502,13 +502,6 @@ xfs_vm_writepages(
 {
 	struct xfs_writepage_ctx wpc = { };
 
-	/*
-	 * Writing back data in a transaction context can result in recursive
-	 * transactions. This is bad, so issue a warning and get out of here.
-	 */
-	if (WARN_ON_ONCE(current->journal_info))
-		return 0;
-
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3c210ac83713..db88f41c94c6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2031,8 +2031,10 @@ xfs_inodegc_want_queue_work(
  *  - Memory shrinkers queued the inactivation worker and it hasn't finished.
  *  - The queue depth exceeds the maximum allowable percpu backlog.
  *
- * Note: If the current thread is running a transaction, we don't ever want to
- * wait for other transactions because that could introduce a deadlock.
+ * Note: If we are in a NOFS context here (e.g. current thread is running a
+ * transaction) the we don't want to block here as inodegc progress may require
+ * filesystem resources we hold to make progress and that could result in a
+ * deadlock. Hence we skip out of here if we are in a scoped NOFS context.
  */
 static inline bool
 xfs_inodegc_want_flush_work(
@@ -2040,7 +2042,7 @@ xfs_inodegc_want_flush_work(
 	unsigned int		items,
 	unsigned int		shrinker_hits)
 {
-	if (current->journal_info)
+	if (current->flags & PF_MEMALLOC_NOFS)
 		return false;
 
 	if (shrinker_hits > 0)
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 4e38357237c3..ead65f5f8dc3 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -277,19 +277,14 @@ static inline void
 xfs_trans_set_context(
 	struct xfs_trans	*tp)
 {
-	ASSERT(current->journal_info == NULL);
 	tp->t_pflags = memalloc_nofs_save();
-	current->journal_info = tp;
 }
 
 static inline void
 xfs_trans_clear_context(
 	struct xfs_trans	*tp)
 {
-	if (current->journal_info == tp) {
-		memalloc_nofs_restore(tp->t_pflags);
-		current->journal_info = NULL;
-	}
+	memalloc_nofs_restore(tp->t_pflags);
 }
 
 static inline void
@@ -297,10 +292,8 @@ xfs_trans_switch_context(
 	struct xfs_trans	*old_tp,
 	struct xfs_trans	*new_tp)
 {
-	ASSERT(current->journal_info == old_tp);
 	new_tp->t_pflags = old_tp->t_pflags;
 	old_tp->t_pflags = 0;
-	current->journal_info = new_tp;
 }
 
 #endif	/* __XFS_TRANS_H__ */
-- 
2.39.3

