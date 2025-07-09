Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C47289837;
	Wed,  9 Jul 2025 10:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752055400; cv=fail; b=ZcFIoArEGPRlYyAJh6IVQoUfyQvf4iGyKjENca6Drx0Zge8s+q+iz2KbbGx+L7ivuyei91/81Li544P+DHRXCmQqQGoH60lfGkidQoGna2DCqLvOn2deWrFbfv2PRHoIBqKn8L/AZlRZkWou4cZErqJtDvmtALZr4VMcLb78Bi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752055400; c=relaxed/simple;
	bh=BIucRWr6VtRYacFcNiRkF5mr1+XBmnQScWGj8ff7X48=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ufcUUypfG2IVum7pv6Q+2LzAVOJ/tVMWYQxIxtcqKi+S3UCvrerP9eqvGnbX0UuX9+tVnmnMdIHbZkS4ijxpNtCZLPmyaD+AMawzF9fj3rgpfWYHmFcZDBJ/s5izEIQkHnLAjljqVuDWo+URFYwW3NQ3k7CJPmWh1Jtw6W+xzD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pTFAoQFR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Buy6BmtQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pTFAoQFR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Buy6BmtQ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 569A20YV012744;
	Wed, 9 Jul 2025 10:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=88ROHmm3CNss4mfk
	ns09SyPRe4TVJ18nG0w1yqPRkHY=; b=pTFAoQFRfcggdzQpJXo/+QCjs1dBlYds
	db+8CpISPhlXLLs/FfL9+V9RDYDmy9RzBGdDlfJRlXH7D2GQzxDB+oX4OLZIKuzD
	t4e1QmWBobX5N9IGKHpVrm/98rDOAjJOdMsymBGWnTHliyPLAmlfPfZ2zCfUxWms
	4TZ33byGBSqyeldOx/jDX5aXEsPRgIh/TpKEy6sLCvsne+nJaQJ5i8RgbJ0hUoJk
	crPvzH3g2R5ncqBDC823HmKaoAzAjzz+fWDB2oaIapuOl7xpaInxv/ZCV1FE2cIA
	auf9KDsk8iHAPdb+WGY1v4N8GMn+qHXyS6InuIvtDrVwPeAcP5F/4A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47spadr01d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:02:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56990far024212;
	Wed, 9 Jul 2025 10:02:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgb17x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:02:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WTMWzzVQ5Rh1J/9AbB0lP8Plr3kF/jLro2IspN407A2ttWACmnvc+j0qrkiYznGrbf/PNSWHndgdGCw1rFVLh5M5cvWXctPj0cgrukalo3qfhEjeyO7eNW33vkOw083TevRUujzkmxiO+C+EmOX+72bwEp5hb6APpDzS8d4aoTT8RZvYeEUOJIjEj23/UBImioh9B62ufV4AUBWtulRBqFMFOO8KvCQh9rMNewaOpsRwKD6ACu3JY2oYprmpQsIRkwCNzTGDWbjLFJds13EcRp/8T+IzAE4hS3cpxBZrME1QH/GLFnnRtWfLW4UqZ9ywzeCQXxIIg6BXedOc6IdSAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88ROHmm3CNss4mfkns09SyPRe4TVJ18nG0w1yqPRkHY=;
 b=aj0bBuwrFncAM9el2yREpno7gc8atz1mc0wUhTGIb92ZNQLiSiylw6Q2LxzpON5tm/XzPZ7LWcNPA6YBJooOMh7paXMauCo9VSgKs174nBkGdfKBK2+l+/boe/NPM0EN+2aNDAIBEowLAPBP0uvcMlLBEqyNSUdRjQzgFdBGS2wgqwaspyiN38O+ah/Zln0kZy8LM0c6wl1rxd4QsRHvgejdtMHHWs5XMR/Br3+tIP6xsDU9XZyDcJi00+7A9wbkV8Co0Ui4gkE+NdwGBkxAUyatatVmYSbjAfAVWNwdc5b2Xnjvl1ClW4USZofl33y/FwxbIEH5sYK4AlPCxHo7+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88ROHmm3CNss4mfkns09SyPRe4TVJ18nG0w1yqPRkHY=;
 b=Buy6BmtQsqsG1OU0d2955WreYiNJftWWW+Jx+UEOu3JIb6dRrDU6UjhsAhRm4KTMEWsqeEceIglGQvUG4HgXa+5hQBtJ7yy5Utt9QuxORwvz7nF4vsq4isRuNTmH+ihc+ofSIg/pgFVnieyVJHmy5dQt+7q87tEs15Y5uzn08XQ=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 10:02:52 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 10:02:52 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 0/6] block/md/dm: set chunk_sectors from stacked dev stripe size
Date: Wed,  9 Jul 2025 10:02:32 +0000
Message-ID: <20250709100238.2295112-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:510:33d::14) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB4744:EE_
X-MS-Office365-Filtering-Correlation-Id: cea5c557-66c3-46ad-2e9d-08ddbecfc45e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VawGYvjD/p5T6m+fftoOvz6rPEjRP2ovICnIgh85WaQ0zZ7g8gbVe+3+XnOn?=
 =?us-ascii?Q?1XLVpjt89Upmo7/0e8+VOVbcw9OX+U5dyH/vGsQw98wGKN6QguFSI/cW0uIR?=
 =?us-ascii?Q?Jfd4I6cqlhluF6GsM12gY7mmiAJE4vIEgLdaEEPQJhmUQqA+yUvyMWydUdjc?=
 =?us-ascii?Q?9eO2qIHRG/CB/hnzlGr4KDdglbQMI4I9B23/W9qghTjBJKtqaAiWARbbuSIB?=
 =?us-ascii?Q?yRyrUNzllv4iHRqQaw0k9gMFC9qEoOxwtJP2LFpQC2Tz8E1FxTLvV1jshDp+?=
 =?us-ascii?Q?biRLmFMjnkT6VrZOHAVAfgYqDu400+k6l6cARvzh2aSQh0arF0t57F1Ww9Ra?=
 =?us-ascii?Q?DZieqIICfGo31mNYD6k7K6sU+k35kcQgRpoHvg1KLjPZ92jG9+NHCEshWLtS?=
 =?us-ascii?Q?Fus7OUGW9Ji6XSX2m1iXRd7HrNxTTcuguxyIdi6HJlqlrOH83mvVkXiC3PUu?=
 =?us-ascii?Q?rLwuOroT2CyrDN/laMJNk+jImsA41Jk2zTCHfkStMp9tGOOSGqfynyVBs5GA?=
 =?us-ascii?Q?sNth/bq0vSRxR4kf7R22S1KYiCbCDy28KWN5Kj4UYNgFwekldg1y/tLNkOHu?=
 =?us-ascii?Q?Uj7Nz7h5YPAnwbCwekkKeoV6fFsBUvUE6QJQx3WMVQiR/rHjwSoK5paNZINW?=
 =?us-ascii?Q?UmUTrclZuwbxgx2x7I4B0pHB8p69IGMmUmRZOFpkCEzP+vDcF/QQ6NsR1B3+?=
 =?us-ascii?Q?OpwJyuQpbrXl0HJM9Q98+wRQcbfu3v3JxusVYDTXIuaBJKTou8HG51sQvOYF?=
 =?us-ascii?Q?v3dSPP4oFiGnV2ApoGQr35AlG0UyXD0r2pk5dRycHYGrwfCIIAvbIxwUc5Nq?=
 =?us-ascii?Q?udFW3+jLajZZWAzftQ5sDOfM7ltEfH4mWeLc6KeXK24mwYGjr5q88XDxZBbs?=
 =?us-ascii?Q?Mk5E5CFv7KPBQkEmkO7wYNrIOywSMzfjCuUVSgWYjSXliH6f4zd+4OsGCGGO?=
 =?us-ascii?Q?ZiHivlt3kxAVVgQjhXVSJb4xzU+C8FRD3yLNYLSr6cI+902m3EEtEStgtvGB?=
 =?us-ascii?Q?EXkbi1434YvQzCG3kbmqBZ78lsaVaCbFO/6N9iVe4qjYZWRJpZu/GDtEqE+V?=
 =?us-ascii?Q?yvwaofoZPeltG28cdkCFFPrRm0ddSWwqGgWrFSp9CCfEeyoTz59iAZsVsqHb?=
 =?us-ascii?Q?4LfKXVqYIGoJKU37ta7sJ6DhuTZNsTYJ3pCmk7QfuCtuK+vw2jPp9yxPHJLH?=
 =?us-ascii?Q?c+1nndik+KeMskJ4D1vfIdSJ+tnuni2ks44+Tr+UQE3cytAdfm8gneJssVB4?=
 =?us-ascii?Q?tl3egn8O/5DLDTgAFhnsCCm2ryUPyuLlYKt3ANZF0xYk0yhJiSBcqe5qdb+U?=
 =?us-ascii?Q?PtPsMPbIEAbgFw+QkcqOg+abnr9CdmKRw4W7lWN8Nme94hkiM7iI9134zBH0?=
 =?us-ascii?Q?b2wC8q6wzONargYVIInj2Vwmf86Y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IkNGSqIyh7sTxmmCLVGJ1Z0aEPF7UTKzeBP5oaJhgTQEWtyFcyjVi1VK+Ga4?=
 =?us-ascii?Q?8cJW3L5VGYjPKtrwT3QDfDD2Thdypoybt5HquKSeCkU8yZE4vJfxkP18BuTF?=
 =?us-ascii?Q?NnH24XORU8CawKW8/fXPaC1gRfbg0xapdkxFebkHgSM5jtUsAjOHgpfslZOY?=
 =?us-ascii?Q?2bewjvC5aAWzBy1Ev98JvR8IckDscqvNrzZ8KocA4S4WFcL0He0wf1T+nmRv?=
 =?us-ascii?Q?xV54ZbqEFRnQBgr8fSRB2e/tKfAHzRJ+u5LzUVbIvg1g5U/F+fgUKSea9dzg?=
 =?us-ascii?Q?brN5lEmcUN7bnIjXkVJ6pXYcYL8+Y5MTLZWOhD96gIHWqNE3gV2dUEHSdn4y?=
 =?us-ascii?Q?iFKCAbRzoH6H686PZK6Bya/OoqtLKyRY6PdLwEp3zsL2RnSoK+lLo8u9jiTJ?=
 =?us-ascii?Q?naSSHEmBGciqWpQaCxaFX7wk40Bz3p2LkSpryLxKVF6cwcmvrdwjLMSdyUCx?=
 =?us-ascii?Q?4fwNTWGwE8s6KCFndPYAGNv1bGAcC6IhkL1CbQAS2XINxqXplEi5y/Z+zF7u?=
 =?us-ascii?Q?F4/3HYczxYpQBrJGQ167S1nf86yKu4kEFMb6dIS4v3AvH/DuhnKw4sgN+YdV?=
 =?us-ascii?Q?fLYJxtrKbeAfWnIntddXS+CvX889rUnh95e/krEB2G0RMefsilkdiAlEQPj5?=
 =?us-ascii?Q?57YPMdz9xKrY1L/vJm/XO73R2gqSjUra5g88C4zKsOwMP1TvCEzyVZQHm2ZF?=
 =?us-ascii?Q?48Ky+6mqqCloC+x5OzsqkJ6RUgdMg//alwWwACadANg/m1gaPWHTrfPKO1cE?=
 =?us-ascii?Q?z7n2fRMz4dWS2s9J3kNzhllWK3tte5gzHq2IBXWAKdxusZ6j47+cfpttmudS?=
 =?us-ascii?Q?Os+Z2ctLppFYD0NAfvC41D1A7E13A13kYJtRYRNPSIpjTRDxCOCwhNfIHDit?=
 =?us-ascii?Q?cpK3wgPiDmBzuV01tO8AJ9A7ufAqY9i6SseBuhyNPtI4WT9rZ33fYqOGvYB+?=
 =?us-ascii?Q?vnEjRIhwj+/kVPX5IaqoZ56Jt2GS+DXrzR6CT8NJS+qPDcSTPs2a6OvgdgI7?=
 =?us-ascii?Q?Y19eY4eh3oq7EYva38cydi/HoKBxRe+EWleV7A15h/uTDkp7m1l1XN9o4N4d?=
 =?us-ascii?Q?mUzJ2p2UStkzGaCAIoWUn3UMbQAUCkJQqFEE9UXZt9AI2HdlsjbSMbhWuwaJ?=
 =?us-ascii?Q?O5I8tWQbwD39/qyZfP692ONgHUqEexbM2oA50xJ0uD7zF1KL73S8iEhB/tSl?=
 =?us-ascii?Q?Y9zyuBqmFg+XasGOjL/nQxzHl+End/FYExWSIYI+r9FElp5aIUdLEBL1TRFU?=
 =?us-ascii?Q?K3UzcuQVtQrxvO+sU8P9TAO6+OKQdeqtYzjjTuvYLK0TyLLJi1p9AgZNK55X?=
 =?us-ascii?Q?YNgAO22x7jSbooJ9ns/A9AfySmmjv4edQyzhSVBze9St1kONy1k4ioLwW3E8?=
 =?us-ascii?Q?wpy7Id2LK/mlSgTTifRTcJiEvKroWL1m2JEh+WWXO4GeKVwtcYm05s+YLIIx?=
 =?us-ascii?Q?C7k4ZzD7/o66QHGo3s93OU3wKRroz1w1Aq9CUaDvtRz2CbSJsW98YmNKwAf1?=
 =?us-ascii?Q?gsE/jGQOtFlajQuZxIQvkt2Ig1MwQieXJXbI+Ee1IdpYn3HXAiQThmDS70mG?=
 =?us-ascii?Q?4mSv6dM8hbp9+4UIyPiroaIUwBySWwfSF0VI7OWYB/vBwrf/TKC18hRVAHmr?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fAmhJxMzYw7EYI8OATgHKKEGjNtnG0UP2xKoDl/8j+nFSZfrBpqnk/8DXzGfWxcma839ocgHa9SkqM9fsIQ+E2xQnuWwuEPBXd1xaVX6TygwNn5KEhPLpZKynhAMBf23+7CFUt0BybDsqsWzohLiebarira4CV8yyT3yViWjmbmj4Mfn7VQDgkrXLBOds1tsyoOl3nw+Nrz/xQGhrgnx5AYElmPNjv5KTRoO8/wYC+/xsZsN4kn5DkMmCRNJknElYc6u0WC+zJx+6EHH2BYbix7KGfLjJr1l6Sk5EiNAKGHG5yda+LQ9TfeH9JC/kk67YPw+4P9z+F+l5Q59S2KD2jHxaX7AtqGTvOfKqyZDdmrrWGYx60ONnRdUj+AHY4IvRFMKV06KglYDuub9njJ9ba475Gk8+fBvXw4yOLYjbNl9hmZLyvYztDPbQTwukI7N2LErlPQQItn3AjXJGo+nWDKr7TBHVfWGs917+m7loGm6yoGrQToV9Hv1x6LVXZoZ+XVmyOoTZmcWpwctUzmdQ2iDuN7olmo7NdnclJBeWmTOrzSvk+IgdxDsoFQOWRXijBiPuh52ExE4Hj6iBTmF9mtqmwDGI83AXNOrG9Z7GqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cea5c557-66c3-46ad-2e9d-08ddbecfc45e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 10:02:52.0853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/Itdym7+KHIOTt6tQHk3NYz+jfkW8WyRKh3Ok2zvb8EHTapa07KzX3gefDLXB8iZAOgReKcqF4b/+i39R0vow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_02,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090089
X-Proofpoint-ORIG-GUID: F5fg0P0t3ZSTHZFOCkEOti31dLpJ3He1
X-Authority-Analysis: v=2.4 cv=caXSrmDM c=1 sm=1 tr=0 ts=686e3e50 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=loq-tJhv0IFIE_0Y8b4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDA5MCBTYWx0ZWRfXzfjnYyCuu15y h/7NLZ6BNUAMLloVE56zZCJ7m9eVmBR8FgT3nRq8TCOYCd+WtGEiYIjXSlVIJVvUDneQulohqsA hqDMS+kGk1Hx+8R7TtHxLsmTNa+AITV9NmPtjlzvRaC6RX/QY7P4DAq+4XkgNYUXCPR0xQvLqAD
 wj1va7yH+CALBlOtO6Wn9mzZwGLWBWLG5qRhs8/q22hinZ4nM3IU/eG5jA9uPAwwSy+jxfc5YKY QDcUd1K0pCw+mzAja95+wRHiU9ospGUJs5eJbTrxfQdks8qmxXekFY2wDJoDEQMu5albwKUAhr4 J8/S1KcuchBRlISwx8UlxT4GKVT4fuB/zAAilysWAk2joecBTmxbSoS8rG/VbtNXZpHFXfMQZeg
 a9z0aFeuIeTaVifCHEHdDl965ksTRX+q0tv1QOGZFvNsjfFUnR9JeuV6lHX8Cf8/GOEoSRqa
X-Proofpoint-GUID: F5fg0P0t3ZSTHZFOCkEOti31dLpJ3He1

This value in io_min is used to configure any atomic write limit for the
stacked device. The idea is that the atomic write unit max is a
power-of-2 factor of the stripe size, and the stripe size is available
in io_min.

Using io_min causes issues, as:
a. it may be mutated
b. the check for io_min being set for determining if we are dealing with
a striped device is hard to get right, as reported in [0].

This series now sets chunk_sectors limit to share stripe size.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Based on 73d9cb37478f (block/for-6.17/block) block: remove pktcdvd driver

This series fixes issues for v6.16, but it's prob better to have this in
v6.17 at this stage.

Differences to v4:
- Use check_shl_overflow() (Nilay)
- Use long long in for chunk bytes in 2/6
- Add tags from Nilay (thanks!)

Differences to v3:
- relocate max_pow_of_two_factor() to common header and rework (Mikulas)
- cater for overflow from chunk sectors (Mikulas)

John Garry (6):
  ilog2: add max_pow_of_two_factor()
  block: sanitize chunk_sectors for atomic write limits
  md/raid0: set chunk_sectors limit
  md/raid10: set chunk_sectors limit
  dm-stripe: limit chunk_sectors to the stripe size
  block: use chunk_sectors when evaluating stacked atomic write limits

 block/blk-settings.c   | 64 +++++++++++++++++++++++++++---------------
 drivers/md/dm-stripe.c |  1 +
 drivers/md/raid0.c     |  1 +
 drivers/md/raid10.c    |  1 +
 fs/xfs/xfs_mount.c     |  5 ----
 include/linux/log2.h   | 14 +++++++++
 6 files changed, 58 insertions(+), 28 deletions(-)

-- 
2.43.5

