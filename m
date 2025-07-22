Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26357217727
	for <linux-xfs@vger.kernel.org>; Tue, 22 Jul 2025 15:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753196441; cv=fail; b=p8tcauGpNsRJU4HnMhR9iHiBTHAjdcZNXXIyuR5Ow4ybZoZ3X+6EBHqSRFA4E6opP45sQX2Sg+7SgHC99OrROWqiYNtgM7jvxu1P4cq5IM4GYVFUaME7GsbB0jOgxSWSbBiTwWfMCvubaRSEXGHGhq2RtLRQTFtVxHPabJ9EVCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753196441; c=relaxed/simple;
	bh=yxzkJGFudDLy8fv6+apbVwhrRS2mGbYj4JkFe6teQxM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SC9mtURCKERVbfPZA2YXyNjGhefsK6qdNlp384k9qudWDqAYcZ8LcZc/prvfLUEJaT9Xq3U1FuAkR3npt16zDNxDa5VSsHJU5GSZqolOoMZLPMA+pXKPH4DXI76s4s46WFlsGtGgGr+wkrurvgK1Ni+X8lVTERqntjKohwx54ZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bFV1OhLT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YBQKDB9M; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bFV1OhLT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YBQKDB9M"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MEtwZA009035;
	Tue, 22 Jul 2025 15:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=qwoP7TuBHBsigwTK
	tlAFSQ0KXlCMstdTErFdvutVTfc=; b=bFV1OhLTdKrkekveNCIEZK0fWGe+qFDC
	G0uzGtG/NCwOTQx62jTfrMw5Z6SUf0zufbxTmT1odWqIEI6bkkEYTiZpHGvQwprn
	jBWZvq+F7FbYAQbhwugI12DIOCMsWvM4BvCBWuZhqotfMkvzCqbKLc/zEfT/H+2s
	flBP7c8IgxHjmMWkIOQJHn7fSbpUVZCNMK85McU/PJysY1Q3KsxZfRTP5pg8OCJQ
	kgcI3AVei9rDD8P6ToHMuIlNTkxyTINkjSZDGkjOUvVtu8NxoIELTExesvS1H0zI
	UoSyLHg1jjgKnv3ynjFExiYu3hHZcNUbnjty+TVVnbkvIUWxAeKIBw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48056edgw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 15:00:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56MDVwU2037661;
	Tue, 22 Jul 2025 15:00:31 GMT
Received: from cy4pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11010050.outbound.protection.outlook.com [40.93.198.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t9etfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 15:00:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5p9IVj0gsvOFyZltj45qDEeXbGelhv+khlMuyqvihsAtuM1H4TbmdWIsFqZC2NjiOZ+1KbW+aRsTt1vwXOqrH1SkY45Fg1pMhdxs0KUvp/s/NKvEhXBLWZpD3w7mLd2diZuJNF8EJJSWf6iAA4/glwUK6Ur3NwTD34W5ZVZMUcrV6pCa+524W+JmWaLJTYf5wknwOr2iG45hHT1knhiXBKU420Qyb0VgqoAsAoeoh6mWa3EMzFBeTf7+2rbR8Ao2bh7OV3lBk21QjVgLS2hESBK91iqSmZqm5ProZgYnXnSG2Ee9eorctC+ZDDIAzC7pBfN0zHawk4kylVZk95gGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwoP7TuBHBsigwTKtlAFSQ0KXlCMstdTErFdvutVTfc=;
 b=DgSH+xgqlZwyg+kwp3zXEAXo46F6tl0n1KopyW6ZSDWuPbpsUdcoKdhPclmH4uP0kS+7BT3KnW3/f6jdmQzlpWLD/O2ZxrY3b6j9jidLYNGXMXhUdFp0TKSfmbB8caxgP/Cw9wXJrnnx8jt+Qe+qEDZQ/2WciYzEDkEcp2vafCKrrJjtOi+ZitvQh0hUzzLcThLDFqsf0npTA6HDKBnJBX6Z7C3gofyoJE5RUBVKrkqam0RXLyk19SW2B5ffXzMgdcYStccVCSPP9FHGCUP8xXEELg0zHI3hx+yP2jtf/pFj+gSFkJ+CiwtMp4lB8I0BsWpIeSYY9V/VU/moKsITAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwoP7TuBHBsigwTKtlAFSQ0KXlCMstdTErFdvutVTfc=;
 b=YBQKDB9MuqY7ClSJme/79Q6q2TRMt1CUZwz3FPi2zrJcW5A/yJRajmAP/iI4qYsK3zm8bSwQTe085iSZJYvjmDBV4EpU1YKn1zqRomUelXoydGWN3irhs4fe9Bl5XGOOFkJiYygO2rgiRxYPisjFKK/Gd6fJJ6W7CrEO+z61K4w=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA0PR10MB6698.namprd10.prod.outlook.com (2603:10b6:208:442::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Tue, 22 Jul
 2025 15:00:27 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 15:00:27 +0000
From: John Garry <john.g.garry@oracle.com>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2] xfs: disallow atomic writes on DAX
Date: Tue, 22 Jul 2025 15:00:16 +0000
Message-ID: <20250722150016.3282435-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:32a::17) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA0PR10MB6698:EE_
X-MS-Office365-Filtering-Correlation-Id: 11f07f82-3378-4de9-66ca-08ddc9307e2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y0Xh2FUrS5fMjMa8dC+557Rza7mqHXOB2WjWJ8dtQVYkT5fokA92RqWqeMjf?=
 =?us-ascii?Q?2ZE6AkWH4iymoIx2FrqOaqd/XxzeYS/9GGh+crlcb3ag6r/baxHwafHhxgc7?=
 =?us-ascii?Q?qV75TJRUl5pxFtgocO0jw+Zyy2OCsa6aSXAnztpfddXt1fVRYklcp8JWfYVX?=
 =?us-ascii?Q?C6JpLyhpCjxmYzdN7KPDlEF6wpVIjUrDjwhMGHO225pixqd9obAvzUxybAVt?=
 =?us-ascii?Q?A8eZl4NOMYDCaKqi0T6rUKkK5m6HTDmJ2zOh4rJN+miDFVtuK72fT6A7c9q8?=
 =?us-ascii?Q?WSyyKAMpWYxjkliK4y97RzNtTLz04JSUo3iVGSKs/SghxPFagMgcxbEGrLEd?=
 =?us-ascii?Q?fh+s9KzewRb8oTaHJN691qb9yUXB/ZOGv2rSqbkhR9kzeFtQGEyk4IHfZsnf?=
 =?us-ascii?Q?Kveyj3umOLvwyHO26Wfq6mdWUZVzvrwh0cVFSbNFhbidsfLqtK3kbJ7MvpC5?=
 =?us-ascii?Q?GetOMSEYe1W9UZmipGzKyJ6wZRgSRI4j7V74XhG5dxwTlIvIjvz6yXx5BpFM?=
 =?us-ascii?Q?QB7F89fPPMiBQsB5WgfQFKPYx1LiDWovUG4VNF4URwf1Mqi/S3I/rKGAnc6I?=
 =?us-ascii?Q?Edc+dmHtWOO/C97R1pdF2An8b0I9kXRmGgap/W1ass4cZyzp6WYuQTB/rRU4?=
 =?us-ascii?Q?5CG8VC8B35vxwwbHKhCzkwbHlo1P9U0kcm+NdJ5/g0c4MIba/fw9Y5k9LG+j?=
 =?us-ascii?Q?7u8pDQYHXXKu8ZbwFMb9YURnl0w+FqP3ZuXUuprKGRc4ghDP1S4N1tEVLaSF?=
 =?us-ascii?Q?Qdj+4zaxm1oE/12O9sh7yHwBCf+P1IOfDIYZG6AFokyw9MYZI4wOll06RIW3?=
 =?us-ascii?Q?I9xMX3hKFNNIj84jNPHWrjfXFWG6s1UIO5cuv2anzGUDyXOgM8ruQ2P/lm8L?=
 =?us-ascii?Q?28J/1n31i8FpRw3eFxMINx+mSku5HztPJOLrdRnSdFrNiN2Pr8tnq+mZif+h?=
 =?us-ascii?Q?49JhVJ6AlPHQdDi0VnZWucY/YOpaihTVkGNB7GrbqjS+NoK5n6NbhrraMCOi?=
 =?us-ascii?Q?3BGxv5Lwed5Yz1dAhGXcIUnZxYl7oBRsiSLTZrO17Q8wyfyH4kKP+beDwMnU?=
 =?us-ascii?Q?g4AeI1Kz4lrfd4cYkQn0vyWT00XGMiwu7zyHRYl0OTa8WU7mzUGaDBjBM6Sy?=
 =?us-ascii?Q?sPDO9Rk3oAwEUQ3Wpw8Pg9JlsQPfRvSiPnAM5e/OhFYkgd1ctvDbnIVNV1Wr?=
 =?us-ascii?Q?hKL1ncQs4G3T/EkDkRVBT6x7YROTtZ/0pfCJCPsRaPMWQsQlJfV8gJpxWCbZ?=
 =?us-ascii?Q?L+1zQrvEBCD0if/lbIeX+gM5hYh7udm0PGDu5NLTdjWbSM/tJMUy0u2oRba2?=
 =?us-ascii?Q?84Gl0HAH3Ugsr0TMVmUK0sqrif79Y4PyuLpqcWpkx7dVnW9teMFnA6VOLh5G?=
 =?us-ascii?Q?Z/h6qpWmsQroTfCbfikn4xG7VuKB0csYoOFiON5zoyiErL4fEA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0MiPUUZWxqOyVvq5i42PIWhTfIZLJldYhR7U/vq8QRMwi0VhcYLsgf3FnCsh?=
 =?us-ascii?Q?n4fk+DuCPFNRdC5Ol67V4dlAabx9cC0BIkuWscXhcDAqKox4rP0hvckcGtcv?=
 =?us-ascii?Q?XwtB/aatnogyw+xkt3TSekkUU8iB44dpLcPvhWozpqR5oTM/lFDEuYS5ZY4x?=
 =?us-ascii?Q?TlVSTGQEX19o6RdTOjadVNpYyU0ouy6Tc7FRBhIH3/arQkcIOZWxfs0PXC7a?=
 =?us-ascii?Q?0O4WhH3yoYSrxeiBuqY9TdudsIRX+DWG5t+5rmKwHaGwOYHUzVwn2+IM2vu9?=
 =?us-ascii?Q?6W7vtv/1MBJ/4OvBHCjVcRBlPbMPggJyqX10KetdIaqYVTmKknJ4TdD+ahjD?=
 =?us-ascii?Q?t3g/+NHhxFY1enfYaZhjCUWISD4qhM+zJzRIdLtFH0PK2jHXRBrVbDqJsoo2?=
 =?us-ascii?Q?ciIrqH3HmCG43cCN/6Dchavs7NC+0VG+bb1vk0Qt1vxlai0zCImkcShRYaEM?=
 =?us-ascii?Q?DqBRBW9Pl4hWiR0NI8xbSZQtRhsqgLZTDdR73VxoIK+Qh5VJ1fKfI+qLRl8P?=
 =?us-ascii?Q?aXy/L0VqKZFn2yUVU9HAHQPYon/ZQY3etIh6qfT99IbWa9fEWrt0bSBqGmRN?=
 =?us-ascii?Q?0dRrNrM6k/q1L0em7Nf1fHgP1VfvfDP8H2hk3QVS5Lx22w3CP1BzgJPH561G?=
 =?us-ascii?Q?VquDc88hdQGJMcSPqZ/7dzUOcTpEIv5VOeAVr0nJPJ7ghdDfgfQtVPX6zUyN?=
 =?us-ascii?Q?X6fHxVT0IQKutXcnWR+57/alikvyUiXprWuj4c+UxuQNw4tIvoaiLwcr9ivL?=
 =?us-ascii?Q?cCJ13vFxm1IqXzGHgQNp/cN0FvWs44cSrTjX64GWtx5yc7Ok0u5WKlZoJ5do?=
 =?us-ascii?Q?JnoxVbiWkHRZE53VrdC/z5eUx5LYdvTsijF+xt7OSotQ1WoBRN2Niis8Ram0?=
 =?us-ascii?Q?JxLlCjpfs39Mqdm/pt6P4IowKYMdan2xaoyWhx0na5yYn/9LxcU0Cb53hYvN?=
 =?us-ascii?Q?jl4QfXtBF4UPdx5YnjCK1dXppcKgJrRz6JugTR7bkWGA3BjliuYGNeYqRIFr?=
 =?us-ascii?Q?d1DwYfm6fGSyOZ+vMQkcuXrq3OwdTRj5KvoBgwdE/09/EHx7gh2n8dgXLc35?=
 =?us-ascii?Q?VYL3pYaUttlEV0VNSkHhoxRi3RB5f6KGWt+zIbCJCpQRvz6rln///DcIIwot?=
 =?us-ascii?Q?sPQmiir1akkxxNxA6acGCzRP0NqAGKxY6T/CIzO5ZG52jm0GdpWyDyeR/hkZ?=
 =?us-ascii?Q?jmOeADUGU00oZYzL5DUJQZFYUVhDYOmhoTIXw0XnZ/fALSF3/x3jlDAiymEl?=
 =?us-ascii?Q?h0YcdK2XgefYJmm8s/mmlE6TOdeppWYwse18RWeBYsArChUoPCLpZeYRgiDb?=
 =?us-ascii?Q?FAYdyDLqQ70ey0J3YYQEGSbayR91C5rjIJbPjdlI3bSVOXNPsiaKiFctiUu+?=
 =?us-ascii?Q?7JU8/G6lSbq27gnj+bYHop8b5lN3meHAPmykwGC48EW87gJHHlVf/B77fMdc?=
 =?us-ascii?Q?hcu7rQ+dO6qvwtQ305E9ABRAR03S+/7xsaOwYwQv3BYtkNyScRLP8gkKC+OS?=
 =?us-ascii?Q?pFTr1S7P0EyRtruoXObmvlFD0/i1Zp8b6/Y+mTZw6XdifLM4rgHutTgusgbX?=
 =?us-ascii?Q?bqbeEpxmFfZwvZACHNt8J0FkFHCiafiJ7DfWr84JM5lRWXv12psyOZU6+LLW?=
 =?us-ascii?Q?Ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OCXx5L4hNxeq0zwElxFdFPQNYrzxI4labhL12URXtSlaDc7MaJlfzyZ0Lg5/qkcfqELcaUifGwhBNxQv8uTVhGKe39CoFTV1wVWtAcJG/7h9xWmoEc/puSOAjYYVMYm9s4G4ZDl86Rh84haMPmqu/PEDd0793zth88kQJ8Or5ZLgVT+sQZkaQLPkUYWfBv3x6JzsaEjtxwjNjZjE+WEWeDjTA/ejoBlT0zIhQmt+OwYnmJj7Uey/wTI2OBvKkOkg3bnX8J5efrinkvD8MsfmjCxdFLSxGCwUd/B00gaJ8qHF4ACMXFAeSdFZkcAVndPTGEHnyM7Y4wuBy5ivxq1pvwGyk2VNoAYS8FcgAXAUsfFNjWVhxF+YOb5O5pe0isuH0mSciy2nKUCoCE19dZQTOvIaV3ndfJQGe6pg/Ahi9IUjaZkxSW+WFUcxkE86H5qDreZdl7cUDyGMtUBYk4MRvIP4pXg/CbkRAEMMzRkpsGSeNCTHEFGLNr32FQJPQI/sE9/50EDI2uqw5xU+hVCtCsyRvSAH68bDHTqj9ITwQxTI8uooFTZGbJRdudAwEsQt1ZOzny07gU4rZG5fhbKE8jGaUmqipBToW7Mem993UJk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f07f82-3378-4de9-66ca-08ddc9307e2a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 15:00:27.0807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B0dD7nZ6Zvx1hoJ1/zpUGSSuJAmNck9/6fdqV/K9cqy4DBLuSmJVd2LjgmdYH3eKXww+/jL8s4WSC/suB9jrZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220124
X-Proofpoint-ORIG-GUID: XjU_V6E-u0J1wylI046PziyCztHrGVLw
X-Proofpoint-GUID: XjU_V6E-u0J1wylI046PziyCztHrGVLw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDEyNSBTYWx0ZWRfX7ERgdeH7Trxc
 ZhW6cE54PikBgyjCw/F+s5f5CwVdMOHniexQNKEVGe4EuwerzM6IUfkvXQ3e8BZWzvyeE3aU49a
 gz53nTQBjTl5f3/1oX8+Rve+7rWK+9cxi6IBz9f+Hji+YDnRn1o7dp3X0N+stpzwNIidezBwKgU
 JFKgG+yINS1yTUTZY1Snt7B5jRC8Gq58SlmiFkmdRLTxEgeX5tYb6RNfcgkKI4iwiEINtKpWlTO
 oj55/ORc8oktl0VBGl6VVlSYNbRZ1npFxy1KvAN4MBapb4xq6HihgD3o6W2wbEMIZ4D5zHem2Gv
 iGjyNNy8KQShEafKXSBWkFW21ujDPuy06cC+dYjLvaDwQHFbEJULEckULEs69K7p9JReye+s7tV
 eVrnR3e9IGfNgVt6Dqob7g9eNwMF/QAkprHbXNcNI7iEVwMsjxKdewjtloJE6B4RQrODKH2f
X-Authority-Analysis: v=2.4 cv=Ef3IQOmC c=1 sm=1 tr=0 ts=687fa791 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=gOl9iw8zJ5YvPalRciMA:9 cc=ntf awl=host:12062

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

Reported-by: Darrick J. Wong <djwong@kernel.org>
Fixes: 9dffc58f2384 ("xfs: update atomic write limits")
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
Difference to v1:
- allow use max atomic mount option and always dax together (Darrick)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ed69a65f56d7..979abcb25bc7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1099,9 +1099,6 @@ xfs_file_write_iter(
 	if (xfs_is_shutdown(ip->i_mount))
 		return -EIO;
 
-	if (IS_DAX(inode))
-		return xfs_file_dax_write(iocb, from);
-
 	if (iocb->ki_flags & IOCB_ATOMIC) {
 		if (ocount < xfs_get_atomic_write_min(ip))
 			return -EINVAL;
@@ -1114,6 +1111,9 @@ xfs_file_write_iter(
 			return ret;
 	}
 
+	if (IS_DAX(inode))
+		return xfs_file_dax_write(iocb, from);
+
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		/*
 		 * Allow a directio write to fall back to a buffered
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 07fbdcc4cbf5..bd6d33557194 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -358,9 +358,20 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
 
 static inline bool xfs_inode_can_hw_atomic_write(const struct xfs_inode *ip)
 {
+	if (IS_DAX(VFS_IC(ip)))
+		return false;
+
 	return xfs_inode_buftarg(ip)->bt_awu_max > 0;
 }
 
+static inline bool xfs_inode_can_sw_atomic_write(const struct xfs_inode *ip)
+{
+	if (IS_DAX(VFS_IC(ip)))
+		return false;
+
+	return xfs_can_sw_atomic_write(ip->i_mount);
+}
+
 /*
  * In-core inode flags.
  */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 149b5460fbfd..603effabe1ee 100644
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
-- 
2.43.5

