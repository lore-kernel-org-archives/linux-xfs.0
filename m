Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43A856B7C
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 10:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714644556; cv=fail; b=fus8mDAkjUp4Bkfa6taR/LDuMGOicK7RVUbK1k9iOPbeQlqad3ZeJS85Uj2olqkNDZN/OlZWESsFjb9QVrbhHpuWAZmj2cTG22kTulTtB2/DXUkyjOUGmUXK7QVzXJmli9aF69WgsCDYxAqK5D2v1KQivWzw2tXC0KRfnVEzNm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714644556; c=relaxed/simple;
	bh=qDtm3MlrYGRwBLaQ+hq4KSLTtrQVUrCGnKPB2UeGnEg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tZhU9dRn52/g45PLc7V+daSM0axuw4rf2sEK4Mz8yBZwOImdrZGPFnNRVbmubLrnsvf4KeHd4g2pliuQ42NnaI7Ci3ee7cH82UYEGOzfYJYaI5a8/MsZdMVZKepYaKCfFy6U34ZoJaNQXUjODWMiGDLYQKgvDgRFtf1ywun8jwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PisuYqvT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=szL+x+/O; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PisuYqvT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="szL+x+/O"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44283l1C030763;
	Thu, 2 May 2024 10:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=H0L/s9WhyLNXEQjch8q1D2vVU/Wvh87dL6iSUzyQ908=;
 b=PisuYqvTxwT0aAEhV402oePl5ixMcZKJ6wDV49qGFBVS7jVG+nJVVmCCqJO/w7PF7yTR
 m1WZz9osvOt1PbpbE9wlyG3rOe89hrv+rlOGjVljrA0NMbRS6/GwMW9uRSnyyxJAAD31
 MmwRyRGKbwy1Dtu1H6PsQqEYZasyYbpgffODy1r4tdsxasnBin3PFlAETnzrw0yhA5gv
 ZcpYM9lRtBWHldsLw1sBOhHLMg+ZxtzwJbDENZYvFDDieUkRuwnMtFe2OTDeXSctz4/x
 Gk8N+kso6p4da7kl8miaw0F5ZRPwrDQE90aG6vWUKZrHsxoI7GFnzbMJgo2TYA5jQdv3 cg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr54ny2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 May 2024 10:09:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4428oCXP006091;
	Thu, 2 May 2024 10:09:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqtapcc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 May 2024 10:09:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrrKIp9IjbEKMV3paSa4Dwc4RqpMWjweIz4iWjZyWhA92B8adGKi2GLcPeC2UMpYKu5e/O6EGIBoNKImxmB9IjTnvMiul3rK2cSaQxv93G7ZP9/gZ2sI2cTUrxqJoneAVogzWUzgotc2qtb/GTmETC4aEoodHiLHd5RtV7a1od3+hLGRien7m0eu4/re+zVsVkE7RknKaFOh+YE35qh9rsz6Ggct5GBA7MvWTqtTw1pnAL5GNxhNKKnaJa3PfJlNy4TvO0Q0IM18t/unAqGlQBd0gOTzcYFRtWmoKDjCRcWLhXTC8loE/U+EY3/t9d9Y/JXI5Ed5K3bjNZg295aZlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0L/s9WhyLNXEQjch8q1D2vVU/Wvh87dL6iSUzyQ908=;
 b=lqzfvnl8cYmMz2tEpsvuKjYADTRRA8ymO2VNjLn+4seH9E4VMtTy7aGoEBCznSiI1lJJ+vIZrvbl1y1+NJpMjnp5mU53Tm3S7RQuh6fNvvKVhIDJ3y683nfjgJ9okv6IbPt18LcduJ4bC7Gth4tMy4xEXu0fBXy+jFqgbxkXvD84lnokbGMQ0CfEIJjEd5f6N7X8tgh2dFcRV+X4TG8/EYXcW+lAdvir9WpnzZHrzowLW+dKtRCQgspnRiCZXQSGKU4GwEn9TSARwV8duPeELqD5OnQbV2AOTANuVYlvMKFkfK0RkNIP0noJlmikpCuiXpkz2iNENFbkOwxnulXOdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0L/s9WhyLNXEQjch8q1D2vVU/Wvh87dL6iSUzyQ908=;
 b=szL+x+/OqbF9Q9ir6056213GgEdmDDJG+WYcblLQt7pVdyOHpK4dxMPeCcfC5xl5DWt10uyCqQ5J8m/fqS5O9Fc2BIdAmm6wGqNtECfN9zSsXlsDqWZdVGKelsmSh7nZ6kjSE4UPw8iXVqGPoGity3b7PePjMLZiYKtfB6Y/iIA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5737.namprd10.prod.outlook.com (2603:10b6:303:190::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.40; Thu, 2 May
 2024 10:09:05 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.029; Thu, 2 May 2024
 10:09:05 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 2/2] xfs: Stop using __maybe_unused in xfs_alloc.c
Date: Thu,  2 May 2024 10:08:26 +0000
Message-Id: <20240502100826.3033916-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240502100826.3033916-1-john.g.garry@oracle.com>
References: <20240502100826.3033916-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0103.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5737:EE_
X-MS-Office365-Filtering-Correlation-Id: c6495999-28c8-4445-1e7b-08dc6a8fe5da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?mb26gOQl/PZioZK+TVMhgSO+eA2mEBgGlab5XRlvigv7sM9uzOApOgT6q8wn?=
 =?us-ascii?Q?IJ/q8U5GgyJMHSIgKSatDe9047svxrASL9ZMZkgDapxXG6bzALbTB+5Vl0r4?=
 =?us-ascii?Q?ENoYjWW5hMyCH02umbrDpDKOqRrsiaUOC9qxn+4FILXG7CKxYrER1ARux4bz?=
 =?us-ascii?Q?mfDvcMwO8orUYIuNj74vnguScrfKI76IeKB8+l6wzbR8XHsqaBSjwcaxcc0R?=
 =?us-ascii?Q?w2Xln4iWRmvLrzoC7a1iNgtmzRDWgCXOdlBMA+rW42UN9COdoxRJo+Vbbich?=
 =?us-ascii?Q?wW7/BgI++0M4/BLHvmfCbNdXsHT8LSF5Egq3X7MRfDAAXsi0bcsHCE4toXGd?=
 =?us-ascii?Q?xINcpSLnwRduorYCUwY7KL5CZnYcoGokJxJzohfGF//gq8nK6jCRHZfpHslr?=
 =?us-ascii?Q?VeefnCITu/BJTSomcucldFSKYWVgXQMR7vXXZw/V0S7KTb8Jtm49a6ZObv2Q?=
 =?us-ascii?Q?/NlyDI8nlXAknkEGcRzfNNtif6+GJvyXd6kVY8LYvbadAg6QKdv85tJ9METg?=
 =?us-ascii?Q?kSLBo0iHjz2scYXM3Krtuxd19OgJHq9fftvIgyWEiXf5J1PQGjdgmrWnvrND?=
 =?us-ascii?Q?wKaR09QYY/1ZloZD6LE1wtIU41dSUo910DM4pJQJt7ccmuJtit7UDNcfDMWb?=
 =?us-ascii?Q?Feq3Viyp+Lu7+mNUGrvqq5OVtYD1o4fi5H5zwLfMC3zFwYXy1JpDqoXZ/cx6?=
 =?us-ascii?Q?+naRhd4Q2STwSYFhBit8dxou1Uiuwu63ESDHFSl/JOhB79QkpUfjHadscnn8?=
 =?us-ascii?Q?9rF/2I8VbWkywtWP3oRj+4bEil0go7eCEmv/chyg8dDlR5KLwkaMk21dQXXn?=
 =?us-ascii?Q?H6g8q6BYgQAdfgXqFra1oyfcdFUvcu+vO4PqoCwlW+4vRZ4SUDcx1B/icVCV?=
 =?us-ascii?Q?oqZQk1518W6DI9+vs0w/11q3WHFv9mZmsSPj1Za6VaKy4hkC0T817MoRuPXO?=
 =?us-ascii?Q?GalUVodSxzBnpdiJa3/QD2Visqc2BssUvMWyFD7NL1KERwDL+ebDPvEUUoMU?=
 =?us-ascii?Q?FpAJALwSzxjDVnLrn6bECNEadRfAiAY3zHW6FVcF6960H5IKTZAitAxIKunQ?=
 =?us-ascii?Q?VbyNxHs1qd5TkWfT2MYrkvZuadAGE3n7ZmKzRjrtZN2fgXkvJzOcoW8CeBWa?=
 =?us-ascii?Q?0dLbitpRCyaY3my+/d7L1zaiV82nbMWnPmVT4D7MKftkHWDBVRvngsLxmg5X?=
 =?us-ascii?Q?Eap5cdsTEjrjlTwDUCREdfRnJLpyHpcvHbEOUBQ8tBD8gMOp9NTTAzFQdqFU?=
 =?us-ascii?Q?HsfQWMXe8T9YhO2LXvVTggTv1vLSGYUs7Z6f0CJ+9g=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?fsJ8mkD1WUbFKQRwf3t6zaNIxfzYRlXRtNb91Mq0w5rboqhDxY36E9AwXupK?=
 =?us-ascii?Q?R4vPTcgEIQsYAZXY8nbqD2j4N6V6NMJFbYz29m57eCLyTeLgchwSjy4NCqKH?=
 =?us-ascii?Q?G1IcQWG491oje2LSPNNyn4eIBNFcgs/gkE76WINaMJijOj+Py9S2+gSxG6hB?=
 =?us-ascii?Q?Rmev3g8hJeXmlyb5EGNEBgT8uVZw0zHZjlZwzlF0K36VJv8FOqYyG6rR7hqA?=
 =?us-ascii?Q?rQTEODm9DPOb1/VqrbHnuOQ4zuTVhIuBbKy7w/icefhGBrRj8FQ87Wyqn9Qe?=
 =?us-ascii?Q?qW5VkzbJBkrfBSdtLhJMj9somW+v/yCr86skvTT1c2xTiiFDtGqG7eK0ILUE?=
 =?us-ascii?Q?sMSSqI0nXSEBHLkJGPgbVzPNSW/tyU7KzaDR6A6oa1CKWEoPLVwqXbJ2sfBk?=
 =?us-ascii?Q?E5lXJkC4utI4cXHmkN8ZaawUzluQ5BYVXMKn/q7WdodPaYy/dwHaCTezRYdd?=
 =?us-ascii?Q?MpCVbRnx1ho6pY5qHSvP4EyAPd/NQxldukhlLXGC8wNgZN9hl6dg/rlmU2V3?=
 =?us-ascii?Q?slQ82xsvXaL4KCZvXFkWrIT+9u6F7eunDENoSyg2wN2o2y13Iyp1sYc2Qjyb?=
 =?us-ascii?Q?15eDS0JLn2GcCqRA7OBJ2KJ/cN7Wn6A6GnAN1tmdhdMS4e9c01th+zxxZtby?=
 =?us-ascii?Q?5YfEoxoEOZVzBlDwgs/4h6LwYrtaEitqPzurw86ir/QsUV646C599G13K5oA?=
 =?us-ascii?Q?meMSTgV8ANjnxFoSCchO7x3WdychFC43/UsVXiVElnWkV2PWQc7wZpe5SXGy?=
 =?us-ascii?Q?tn09fydpmcw86zyObf/Zz8jcEeCpBViQzcVkKaSNeAbkHVlYKvljy7arA7S/?=
 =?us-ascii?Q?LKiWO4RVmb9YBgy59GPfW5cEBiHE03IFYDFjHzXTuate9tAWGeBAj5mDzBdH?=
 =?us-ascii?Q?g+ZTzKR/lQJVDcTw0tLIrL+Ac5kyRqi+BREYuOpVN1XVfmvtFVjg/88j2yXJ?=
 =?us-ascii?Q?pETFyhqt4VlyLzcc6vCpH/evLVfUxv8F1oMwAGNy+PF/22SNuS7QP1pRIg58?=
 =?us-ascii?Q?XXgRAXHS8bfiitY3ijJs1bl4ZieUpQiNmLCtYM1gmEeEd9xMJEXHCOxeUhR/?=
 =?us-ascii?Q?+15YlnHKwBM+KtmVWTFMsi/WPjFUTDijN3FLGnRGegeY8VQZ61+fyRdrHO2U?=
 =?us-ascii?Q?HQAIrUR7Jas63SRsWTtFXjOz8X1gvjZ2S2+n1uC9bimWsOD4rqKFd5u1lw8l?=
 =?us-ascii?Q?MqjfOy82CHf+iLmUO7FvmMlEtYLutTqD7QjsMh5aVCLDISQpa6oqzH1aFks2?=
 =?us-ascii?Q?4u2BFwlUcr7fFU8aLrzVe0231go3CxVbN7XRysFdiWUq6/urKdZGMnlHxtmr?=
 =?us-ascii?Q?nDuZrsYcwZ0+gE6cCUyhaa3/ImgRayYrD98l95LBWBax2icHVc2FTI/pKi1x?=
 =?us-ascii?Q?XctE0ItkHgSgHITa3ooiBtt/VmQfnX4trNevf6fTxGEv/Mv8ZOSpegJ82UAf?=
 =?us-ascii?Q?sdLCndO/19/vO6yJs8GiQFFyhO+8qLbp14DpTgQB6942KHVbTppalLVXUxm6?=
 =?us-ascii?Q?HD4E2NunuORExxNveZsyyRcFiHryiCex0W1gJM8Z7YZWcHg/v/3MZ5ZMW33r?=
 =?us-ascii?Q?PI0JJ/cE3ECwc0HKMcIKXPeUXUpxyoWjoOsmAsPpRNQnTVsZHcqMuQk1DGWj?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cw4gq6BVcLNp4UM4aonmF/fDUncGqT7NghX9f3cMpqAC8LJ0BM5CxXcA1DIaDoQbmMp8n225toQe9Z73hgXQWKsKUQuwXbTznxdZjNiCMY9r2sGDYN8zZiyp6OKo5elJSl2LPzbMIwiYlc9XE9mZOEIoP7e3PqKops4N7fBoOGVHzNvfy7sfSewJD0ICiWD+ykcSa80uGgZufoktb+buvglyWsQQNVYKtF8u+n+rfBrz3IGxoqPp6Mc5T9fA4tWlxFalyXElV1SGIB4vqHp5TN7k3oasYH7Tpk0gXBa2WrJWi/+NrTrKXzxGRNGurN28/m23v/ksTkSdOtEUnhwoBoOdDg+akYPG+9nlFPjScexLnaf+hSrtvEumTVCE+vIs3GpwaKlNVvhiBmfokA/E1nSpWiyL6T8vghwQl/uTF9jd7/yPBVG26x4Hid4XX1qsyEpDQySLyG/Mz/GXr6TgF9xdGhv28Ay0gaWoSrGgMB0rInRFgGZAm01FN2H4KJCxwZvYGK3ZiPmjDi7UtF/SXfdpxT5tfiSY4bD1OEYlle5tAXMiCrMP2mTFZHgqcq46sxc7CHe04SaLZZqHQESrYiv3r4MUXVueVqwij9rcfYY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6495999-28c8-4445-1e7b-08dc6a8fe5da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2024 10:09:05.0029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KbNthHjURN9J9EfBRLW+KSv7YQ4h+3RAoKrog+Pi3/sl6lTjAZitX62f8okEhriQZYExHAmn5/bl62EKNBkcIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5737
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-01_16,2024-05-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405020063
X-Proofpoint-ORIG-GUID: z4_A3KudTQ_2xPxK-40MpRBIAuwBcUhy
X-Proofpoint-GUID: z4_A3KudTQ_2xPxK-40MpRBIAuwBcUhy

In both xfs_alloc_cur_finish() and xfs_alloc_ag_vextent_exact(), local
variable @afg is tagged as __maybe_unused. Otherwise an unused variable
warning would be generated for when building with W=1 and CONFIG_XFS_DEBUG
unset. In both cases, the variable is unused as it is only referenced in
an ASSERT() call, which is compiled out (in this config).

It is generally a poor programming style to use __maybe_unused for
variables.

The ASSERT() call is to verify that agbno of the end of the extent is
within bounds for both functions. @afg is used as an intermediate variable
to find the AG length.

However xfs_verify_agbext() already exists to verify a valid extent range.
The arguments for calling xfs_verify_agbext() are already available, so use
that instead.

An advantage of using xfs_verify_agbext() is that it verifies that both the
start and the end of the extent are within the bounds of the AG and
catches overflows.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6cb8b2ddc541..6c55a6e88eba 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1008,13 +1008,12 @@ xfs_alloc_cur_finish(
 	struct xfs_alloc_arg	*args,
 	struct xfs_alloc_cur	*acur)
 {
-	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
 	int			error;
 
 	ASSERT(acur->cnt && acur->bnolt);
 	ASSERT(acur->bno >= acur->rec_bno);
 	ASSERT(acur->bno + acur->len <= acur->rec_bno + acur->rec_len);
-	ASSERT(acur->rec_bno + acur->rec_len <= be32_to_cpu(agf->agf_length));
+	ASSERT(xfs_verify_agbext(args->pag, acur->rec_bno, acur->rec_len));
 
 	error = xfs_alloc_fixup_trees(acur->cnt, acur->bnolt, acur->rec_bno,
 				      acur->rec_len, acur->bno, acur->len, 0);
@@ -1217,7 +1216,6 @@ STATIC int			/* error */
 xfs_alloc_ag_vextent_exact(
 	xfs_alloc_arg_t	*args)	/* allocation argument structure */
 {
-	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
 	struct xfs_btree_cur *bno_cur;/* by block-number btree cursor */
 	struct xfs_btree_cur *cnt_cur;/* by count btree cursor */
 	int		error;
@@ -1297,7 +1295,7 @@ xfs_alloc_ag_vextent_exact(
 	 */
 	cnt_cur = xfs_cntbt_init_cursor(args->mp, args->tp, args->agbp,
 					args->pag);
-	ASSERT(args->agbno + args->len <= be32_to_cpu(agf->agf_length));
+	ASSERT(xfs_verify_agbext(args->pag, args->agbno, args->len));
 	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
 				      args->len, XFSA_FIXUP_BNO_OK);
 	if (error) {
-- 
2.31.1

