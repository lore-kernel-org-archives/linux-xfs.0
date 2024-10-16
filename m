Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED48E4C98;
	Wed, 16 Oct 2024 00:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037504; cv=fail; b=QIykCXgWMQs3z8vhqZVKJ0PdV/hF+KWjAK57AJsX2H10YVwBluNKpPEjSFiMts+gcr3Z7OMNpDxj6gRjCsgi0CfmWR/dpqLxs1xn0vlAo05xKmkokeRFv6tyLPjpfAFDcTVfMI7RtoKkPe5uVCHO4jQD/Z9iT54hDCJpzeMR5Oo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037504; c=relaxed/simple;
	bh=DsyZJplEZpoY3Jj46DggnsDJxzthPU7hUmPinskqFMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UWzNaXT9hkEMtbqA1mM3Z36W6SMAXy/ERYXKjgNBnyxCtg7vXTnqbCaI7mBP0wGbP3kc8tRXEvhiyeAQUzKWgwfSYl0E7FH0qUOtllq4nxGReWjk4v9EZJnz4QOZp7Gk8JHBGfYnFxuTEAHPKSFUYFO4uXEPS/04wk6d5fI7veg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oGW1DP85; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OL1ULUBz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oGW1DP85";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OL1ULUBz"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHteR6029022;
	Wed, 16 Oct 2024 00:11:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=+kpUmVNkgKFIS4VDQoC+mzQCvjHXfIqE/vQfQkRsZ70=; b=
	oGW1DP85T+EKn1ZNfOBLexQ3fDjpXGrxWyGOQ0XoGVRJqVO27jngNLDH5V8dgBbw
	nhgngH6M0pU7Ni30EGSWVGLiDdNuMTRLe/H66Dr65ApyIHi9YnjA3iw/QXPY77SI
	DG8M7cscHdgyQpD181AlAgPogk2pzCy4f01K8cnKab6Lo+9Sm1ERLkkSq6YEZcqa
	BT6aOP/rcd1GwwhtsAocuG4kb/YDpw7uQja6zI7ICPhAFyuoFDGOi5WehuKylfOR
	b+n3PAeqZIHwrz/f9X41J7VC45TiUwhAZ5GzspiC4ZhPfLUlyO1oGXtZGX3aIJ8t
	QGPzY000zw6qXTVMGEdz2w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427fw2jk3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FM5Qw8010401;
	Wed, 16 Oct 2024 00:11:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjef0bf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tthZaT+rmXj5PXO8JE7XQjc7ypSNGeghhgHrUWCPaCP0peVeHlrtWbBT34Ps7pWej8hkkF/TAOXIp33/qsGawOcZjkPpkwFWyhXdkDj8wTC3gX+asW0Q5BduZGiVSGnS4wrcy5d1h6abpQQ6VlumTX371JwApapsB5bdDO3sy4TTdjrK2nnOtknAX4JJLNV1EsDS1KzfVmnKh3DPR1Yl/VZEcV1M11au3IHAhJG+ewHDQW+Mim/XokGFRKbLZ50SYRn6TCjdeV3HwaCSQP4QvSktuUAkjWUsJB7f8VcOkLNkzli5b+w967VRbuRTqAG1HqiDvzFMymyxZaAMZiX2sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+kpUmVNkgKFIS4VDQoC+mzQCvjHXfIqE/vQfQkRsZ70=;
 b=Kq96UWpliV1MvR7KUITdY5YzIz8pr37krdbozSfPVCrliu/nWcNCovZfAcZNRZe+ISZMpErFBfCIkvDok5rK0yu94QqKhIMFiyz/Z3jbA6BLaZAbQ0c0uQqB+ytJLgYHoCu/hc4TIqMesy5h5KeyqSzDhrl9/uhmqJeOSvCxrO/40p0DHNn3wURAZzPH0+ljt/PE/1/3H2vPxrNBwHp1/pkN8NUgD1R8O1jXKc3DQ/pBUh711A7GBlEeM8JivoAMWw+0OmUOKH0xdFrq/E6ReZPmWKQAfNmOdjXQZUhoZdaUMz7uL8TIVNYjx7rdnNbuLniwgwJGzfQwm928s9mVrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+kpUmVNkgKFIS4VDQoC+mzQCvjHXfIqE/vQfQkRsZ70=;
 b=OL1ULUBzCVyyY2aPSa3AdDc167SZFvr6KZFRAgr7aG9WGYlcwFqileJoQUSpMxzDa3i1BRObqviynIaNOpQ1X6/c3GN4aWpcYIH1ekVxFkuzPte4WTUgh3w9ua0tYzbcm41MFlhbaaJfvYo8X4kkRa8JxTIK1c/U2jmDd5+626c=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SN7PR10MB6977.namprd10.prod.outlook.com (2603:10b6:806:344::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:11:37 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:37 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 03/21] xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent
Date: Tue, 15 Oct 2024 17:11:08 -0700
Message-Id: <20241016001126.3256-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0047.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::24) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SN7PR10MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: d812654c-848e-4ad6-323a-08dced7719cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L2P7arbFtYYbUa0rkak/KJFP1C78jyeQBqqQoEqT+xaPCqWOlmwrYnssqupv?=
 =?us-ascii?Q?fnnWJvuMcR/rQxwtDSbw9F8w/3ccPSDwBsGxTpuQ3dEuI6d83hLdo+5O0oRG?=
 =?us-ascii?Q?giG1hMhFGtO/+w88cjMlrXOSDPb5eyfSMCjHFTlVnsbXbiFwZzBIdrxYW7Me?=
 =?us-ascii?Q?A6VX+hkL/gjQHDmhe0tg1sigocQVmFiV3ml28k9CTuD7d7XEDZ5PJI4wAU3s?=
 =?us-ascii?Q?2dg1XY53hh0bToUybQ4D8JraH9yen4GlwnItdsRc6cGbsYP/Iucb6r7KxSkZ?=
 =?us-ascii?Q?3jV/eaXNlznEvTyW4S4D+DDQZ0ixgWt1MhTcO7blWuSfVbAXTUduD5rPyPUy?=
 =?us-ascii?Q?EIel8/nSGOM85D4xM+h0Xy1543K32X3jKPkKUFPrU0f8rzhATbLEpHLlCBz3?=
 =?us-ascii?Q?fJAj7cRJv/ISfBxAhH7zmFIFM/Dl80fkco2JJez5fFmigKNeU+jqCbRuulV6?=
 =?us-ascii?Q?RFjgoUEWGh6A5Sj0fj8I2FEMsGk8QaGDtnv/kr76RIywxYiMOe9TieBLR5FA?=
 =?us-ascii?Q?nuuzQ+RrcmxFXjEmZ7uluSuJEZMgqlwMeDj/LJrdAoM/FjGhgGMLsG2hmJw+?=
 =?us-ascii?Q?fU5b0AegS0uCsaGWhNX64tUQjd313wrDLVIyGiA1FV3D21rD5/BRLarI5ofv?=
 =?us-ascii?Q?rAKFXI4P7wxBgjzWyKFhs3+DoYBtXphm/yCsn1fbrpAbGcRgHsmTGAY6bPNL?=
 =?us-ascii?Q?wZohRTg36+cWOEVNXWt07aodFW9lvMDGFBISqGqa5oo/3g7TWaqgc8IUeXK6?=
 =?us-ascii?Q?GxsK1ko9Ugyq5BSRfBcpNhh4FU8c52hfdK+n4VGAs9x+7FFfJJNGzT93FMmg?=
 =?us-ascii?Q?dCItZqimqm10/MUY04oJd1hz/3uAYS2zxrCVhseu5qplgv3ONP1M5Mn+/Otk?=
 =?us-ascii?Q?aflHBQOmd65tRKJxgcLKn6ijUSx+v40+DMZJabnJoMpMFP/nzVR4UXxcgAv4?=
 =?us-ascii?Q?znbLlynEr2NRwoq42NUbtV7bKi/Dc+Si2k2cOdCBcYakd6VfotyqowPUNfgM?=
 =?us-ascii?Q?FAfhwnHB3l//BswZxMXev+BjR2wHnucNQDTRbJQkCG1p8+PMa3kdvPaumf9f?=
 =?us-ascii?Q?O0ALBGk4es4G9OuzZv+aa9/2bCYPGwaQmqc+dRAaNGgQqBgRAW/z2KoHzKj0?=
 =?us-ascii?Q?W+eBkQp2eoJs+eAvjooQjQ3BfxNCbxaF9wGgJp560iURzv+PcEoYa2EwE1Da?=
 =?us-ascii?Q?baus1an0OG//N/ROcSYnTfH82jnVaIvnQcXj8lINrUbx4YzKIS2y0uOjZN01?=
 =?us-ascii?Q?/HYOe06dY6nMRrrNPRUjFrlrv7dp0XI8Tx96ora0MQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kGGmtiEDqVD9FuHRnFUo6r/yuynsd9padfcICvye0GwWZX7k3BaeGvlreNvM?=
 =?us-ascii?Q?x+sXbyg2WNr/FSgowDx0U8c11z3h72kAnxwrE8YI5W23bqWli2boT//7r029?=
 =?us-ascii?Q?4dej59wNOCpka2XB3h+ZkiYHX6vx9/Z/M5YLK6sEdi/wijIMGvBvfC959uPv?=
 =?us-ascii?Q?MkU0YDW2v+cxXeSjgjWbUBRf7QCTxQDQ7Hl9bZXyjS00pLQFjBAfU/kMzf8v?=
 =?us-ascii?Q?Fm/T/+tRcphzYIunGXkc7il6/7fgCN+BXchnNKdi2ZbIFNt/hgIVX04Su/rE?=
 =?us-ascii?Q?WTO+7zGMxbjuZB81yubIasCH0BoBt49zlH79vtOiQypM2fz2SW3G0rKlDuJm?=
 =?us-ascii?Q?UdyH0ZoRz7RpVwl/FeZ24NejJ+VbiUctqSRrfA7x8lAMzhSkqnJ2UHqQXeuv?=
 =?us-ascii?Q?maybjcTNrNtd+senuCnMJqYhxqlZVEX+4ldUsHSRtbo+Qvfftk0LtmBZriMW?=
 =?us-ascii?Q?qZft0mwkYVrQjJALXSqlNq8kHp8qfg4Lzk9Sq1rqXATL57dAaAT8kNb4NE5U?=
 =?us-ascii?Q?8xk8Tjm243VU8SfWb19rLkqKswpTDO0gnpOEv3uIoxEhcaO1kgOeJif1+V2d?=
 =?us-ascii?Q?gkgSsp/ZZkWRYPQL6sIDF3pgKk6DBM4xIoNesP9tSvGlkKVY5sEuAjoX7jQj?=
 =?us-ascii?Q?nYkUZC1W2HQNzSmEzZ/9yMJhehWgsRaziLokbHQaymy8wTTOZ4KFJLB4POhO?=
 =?us-ascii?Q?ss/cnXnhk5GJeU3g4l1yfJvNGVaGjrXDvzav0SQ0chSD80ZxTLFFjV7bDyD0?=
 =?us-ascii?Q?DPg5dU64ioMAGn3ivh+0YeujyM/FSiSugHKT/UcQOqnU8EHP5WBaeDp9rb0G?=
 =?us-ascii?Q?odOq2XMhrzGT5w6lMFK73YQ7INKihlf/Mald2h3gF5fwoAUEcYbTQHkJgHXD?=
 =?us-ascii?Q?Ov8tSGvQDaXwRkpSREJtty8NfdJ85AAwj2WJ9OKE9jzDoAjcfhp4gv4bwfZC?=
 =?us-ascii?Q?erXuyIddJ6HxbswmwX1QAT0oPRdzf5IDkWiD3ViGSVJzk0Z34+5ZP3nRi1Jz?=
 =?us-ascii?Q?nWvxvBH/BslYSnqtCl49y9o1oANY/ibRhKOgf/saEwfFh2Yk2d7fkYddA/ol?=
 =?us-ascii?Q?B7TwyNXUy1TgNFGTC0aWgYoqQK+gtKdhLbTYdStQZldEHqyGn30oOdCWnw4g?=
 =?us-ascii?Q?0Gy8NQmjv8RmaWwzAf61SpiPeY9r43hHmo0ihTFj9PlisrM6gNZPeop1MJTv?=
 =?us-ascii?Q?ve2WMkZgET3UDBAJByGuRHgkHkbpEd2ZS7Sn5WL/R6Kuba+HTt9u1zHJBDRE?=
 =?us-ascii?Q?XsPqBGX4MEh5r+DLLqDemGsMmrSPLiPr1l0TUOw6Qes+7KM7f6uMQxVtbHF2?=
 =?us-ascii?Q?EK8LjWaaEiWyV+0kIWXryUQUwa8n6uAdNQillQTvXB35GXdAd6izBdbQ1Y3W?=
 =?us-ascii?Q?vRrAQDbtvK5A7gAZ3wQY9lt5s+NdkMeo3DTdI3FP5PfOScaMogMkyhcnuLH6?=
 =?us-ascii?Q?hs7QJLybyru8k7XkeZb1NgADFceVbdQeq20c3uDBnSV/bB/p5hv1UcGjLAhj?=
 =?us-ascii?Q?05iqrYRrnklsx9Z4jzqBvqkZzUxALeMAezEHdtlqRJ3WuqBZTBAV/9f/0J/i?=
 =?us-ascii?Q?5IDp0BBybJBPsEujApb++kTTaPdl1NbK1lt1wMjPS8ekOyTPNW7cHqI8KGVJ?=
 =?us-ascii?Q?/ySEsmt/Mmx2uT994wljazj+s13OxpbmWyMfD3lvBS8a3XSHCi8aWpAsC0Gv?=
 =?us-ascii?Q?Fbzesg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4KUKhhjP757gomUmNOymG/UmFcnMoGGnzaqHWdkXkAE9eyGhpH7PHQ9U9IS7hAgwgYgseIv/o3NzwsB+Mp0T/1bNSEg6rJX0N4GqGkw3uuhoMp1lrV32kLnUHV+5HZ4a61s/Xr5+kAwYEl8kxSaWErQIgcUsAWRKckoaKmAKtI/B6sAHswfvR7sVsQi7P0s5T3IBeJ9D0AsN8cnVXeYW0+j/oh/pEoR7EI4wz9InUzPMjE3w1zC/8ekMZBeVeZxdqXqwZsAjYtbidoz0IvN8kKW/Zcsu+qrQQIiIDvGFNuqXaozPcwKDHlC+XWV4ZlK83tSdpK0K5W2LrToK3NRxDTtp4nVLazO5madht8ZBWJz+0O3FQFNMhlytiRf7E42GgEvLVpy/YghL632wbZVbpXGXMuLo73GQzK3fknIodYHBk6thGhz96rMpCDOR2NvyUawl6E3P1Lia/NJZGRjnhrAYTgHx1T6wCj4rTEQfB4PM6qQmrVUWbTSgLqq4ggSOlG/fRtSa9Yg0hdP6KiNbeKcuNWulBOknrVJRwaEN20EFSIPt4FAV0oaYsXjXHtwLLgYTqLGFuK/KTxc9veWARK9zMfphNUFeBO2qZH5XxT0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d812654c-848e-4ad6-323a-08dced7719cf
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:37.0640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9BWOPUzFUOFbctzdKFH0IRTySzCG9/0GkCV1Ucw6zTv+WaoSBBk8Dk3Iv7ii3NQfcB/RJxlG6ybfCRjcCZwIvHxIHt8ryS6Jyi4+wZAwpdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410150158
X-Proofpoint-GUID: K8UVRQxymlF7b5YX9tBp_Bn9PGVxtfz5
X-Proofpoint-ORIG-GUID: K8UVRQxymlF7b5YX9tBp_Bn9PGVxtfz5

From: Christoph Hellwig <hch@lst.de>

commit 86de848403abda05bf9c16dcdb6bef65a8d88c41 upstream.

Accessing if_bytes without the ilock is racy.  Remove the initial
if_bytes == 0 check in xfs_reflink_end_cow_extent and let
ext_iext_lookup_extent fail for this case after we've taken the ilock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b8416762bb60..3431d0d8b6f3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -716,12 +716,6 @@ xfs_reflink_end_cow_extent(
 	int			nmaps;
 	int			error;
 
-	/* No COW extents?  That's easy! */
-	if (ifp->if_bytes == 0) {
-		*offset_fsb = end_fsb;
-		return 0;
-	}
-
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
 			XFS_TRANS_RESERVE, &tp);
-- 
2.39.3

