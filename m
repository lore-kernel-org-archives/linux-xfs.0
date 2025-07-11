Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C86A28EA6F;
	Fri, 11 Jul 2025 10:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752231240; cv=fail; b=j69Ewu16T6NPhEpUOp7v+0ux3wwlDhdnAEtFtpYdKNpSOTbUywF4yO/dGt0nNnkDGlmKeqB7xDV/f0eg14HjnHQgjjpxXsptIWN2NPk8KNUchvpAj8c3BDglNYThINGnOY1D6UkxHKJtnSIwqYX1BPmYkJeZ0xhbI7EzSTpDrgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752231240; c=relaxed/simple;
	bh=gdYZP/Nfd1l50NAIbZBCTu78HTnTS5Kq9bOS4MLtnNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZPPy2VDsDiBbPnRvvtDXgNQM0+G5T5T6NyEKwVm9w+UALO6qwbZ69gWuUISFAxMqO7pRlsE1Di/BVkMVGZUy6TT6gHFCxuKz/dUGA8tn7UGeOHWZYdZ67458t/5+lnbxfxVi4NfEmF9ad4/aijcxhABZ4rlFIDw2cMhaJSqk2fE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YKHuEvtD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jh89ospG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YKHuEvtD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jh89ospG"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B9Z0Tt004872;
	Fri, 11 Jul 2025 10:53:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=byuqvfeJ2zr46d8K7LWTS+eB8OGtxMd+WzNuHztL7eQ=; b=
	YKHuEvtDOJ7DzYhknbyhdo1Lts9j8aHmZo/7psoCpj7nIstJU2JhiMQk2AqxgXRj
	yEFGbUGyq7plkMnB80XbIxOXNoDfmwM0KjISIHVxf0y5vDj9Hnr4UYHYa6W+W1lA
	gFhONxQr4DAuwKFjA+J71VIWAI0Pq0hsF9ppRhOKnd4fx9yzgcOyY4YOx3FW7HbC
	3/BxFasUkBC5m49enMmuuuA3jajWR9PSqkhpBEnzf4D0keHxDMmZtWSGmWJZW9Iv
	9WsWecas7SkOkYI+QCncVQlmkksbn1N7dYH2zmqEMmz8vFhj+7iUEsTvSKiJe1XD
	2nzrYuVN6DxThNf+fiBmwA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47twjmrd9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAok6c021358;
	Fri, 11 Jul 2025 10:53:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdd1bv-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o93fZz1P5voF4dtooPFfyMcF/RDmRjMKnsLryIkmQFhdbKZsH29jewxl3KJrNVzt0VzCe+3+qvuJ1903sljN9/pIkqyt+ZxWYnrCVrYBB6lpgh8cI1G4YQw0X3ydYF1OMVeOLn7DUxs028iUPMSFjMd+CUYTlPnKrgwSE5lGrP2AsEZ3skSEIUfW5QDvkKbzAkbqYY9k/yqO3bDXwhEz/y+5MnTvlqb3pw9X8iDh6eNPgTU3hrLAc+SyAaK3S0yqyXdr3TJfDGNRYa6+NqF2/KawqGAYFWEEKNn1A4nhP1GvfozCoL6agwxXXyGKA/Ba13Md7Hf/owhUXGBg0Nyc6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=byuqvfeJ2zr46d8K7LWTS+eB8OGtxMd+WzNuHztL7eQ=;
 b=azkTXunXMsG7aPN7MROAdOtBEaqTTE0jgtSYq/w2KlckH2XyfUe8tJXNEZRA6viR1CG+qacACrKL6FqEDVJEzmyIhs3096cvVlxQrOpqnmDdA5J+r5B0ac3LjwJMkwdPx4isucbDs70eFm2QOc1+N6PdRR55Rpx487VoDTfIjAVQXuOIbG1vX7s9orOmRlj2JUWnNSgt7sgtimvAXJdLUBPMIz5wC1/WKwG08YdzdMRJx7QUOUub0yRImo8SOj9SVxiHvllgX+rvNK39iaYneGB/hlgDiDGECtmYLy6GKNnnZI2CV9YdOQQEWXGMNa19wL4zZRUCIihrsMhH3iSa1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=byuqvfeJ2zr46d8K7LWTS+eB8OGtxMd+WzNuHztL7eQ=;
 b=jh89ospGpkhGJ6AgO+96qJxr8sKoMoPuICTkQkDYYN/WsQI9goKhMBCYdhr+T+1H1Mb7PvCHC9DgMJY0eW3anAhiFKxEJf/pnvB+aP9wZLEdIQfxxA16ZAoAjkiNXf4G4EOVm/57j6d5ZIHSqNaxUdc6g9p74tgFsXUC2pmcEfI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF079E800A3.namprd10.prod.outlook.com (2603:10b6:518:1::786) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Fri, 11 Jul
 2025 10:53:11 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 10:53:11 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, dlemoal@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v7 3/6] md/raid0: set chunk_sectors limit
Date: Fri, 11 Jul 2025 10:52:55 +0000
Message-ID: <20250711105258.3135198-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711105258.3135198-1-john.g.garry@oracle.com>
References: <20250711105258.3135198-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0033.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32b::33) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF079E800A3:EE_
X-MS-Office365-Filtering-Correlation-Id: 15c9d57d-8e83-477e-638a-08ddc06920aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?LSI7EU9/vKOMvmDUVhR2Iu4ei957bHcYe4DFR/w+zBncDdl4qBU3TeGyI5wU?=
 =?us-ascii?Q?3CqliBY5yOtrG0eIYAjGUVdiY+SW52soO43gN1jdVacx4NC2IdD3xEGt0enH?=
 =?us-ascii?Q?WKCW3p445VNHSqdsyGJN49VCi1asxuUJCqsFQTGMbqrfJ/1lULmH1x07zYaT?=
 =?us-ascii?Q?YV3OdxMNYUCyv//XUvPJVFm0mw9Bs2SH4MqzVF4afS+mS1CMNMs5ThrKQmeX?=
 =?us-ascii?Q?FjUJxzVSeb7K1Wq8YBEUHbHS0yAPTfZKs7yZmhvPvTJ6TxgLlFya1H2aGUAr?=
 =?us-ascii?Q?UsFzB6hO0K6214T5bKyX5Q2fgAV4zqTqQbOkSe8ep4P2Khd4KqYY7VZQ2hyw?=
 =?us-ascii?Q?bxloqWA+hjCi18gvycR+mFeI7iK9ia2ysvmSjJr4ZcWE0gjNYneN5xN1cucR?=
 =?us-ascii?Q?jtRhyUICiDgOoI8Xbh7TApWM393Es9m1SZLygd5za1wHVy7KXRPe2lPsvqMm?=
 =?us-ascii?Q?0csOt8hrLkq8zZcUEA/1oGpR5rpeKGtUTfNl2i7J8ZgKTdwQDZE6ayf/7ZC5?=
 =?us-ascii?Q?Ls2JwfIhEToVCY6MiXqQGLSu+TgwL/X7kDA8TRXhbXbroATQMjQq+PayWivW?=
 =?us-ascii?Q?yiMB7lP3NO4Fs5it2c8kDc3uRuePG9dvtORAcMCHUQd1jlGcdC1ioOaTsOEq?=
 =?us-ascii?Q?0Leo7qb979Hp576MgVyF2xqknVgGz+GOwP0lzdvDmmazjJm2yb1VDR0wMpLW?=
 =?us-ascii?Q?aiIVIziy8SSkvU06be/1MytBx0r9zZl3gCH+jMf5JRYngZpjhpx9/ruJkSDw?=
 =?us-ascii?Q?8Wenbiymh0iamrrJwtp9pHIBvMLqHJ+iIvz8ZipDHbY5RuXsr3JeRORobE4h?=
 =?us-ascii?Q?kd7zFqw6tseSp3Bf1bIQP3em6Wfi5KLwA1z+YHMSRyG+Pt2HqpipkyGuoutv?=
 =?us-ascii?Q?ZkCZzHiQwyGksceZphBGECWAuSwwhU6QYJNMLv2Z+/df45ucHCFem1Oxj6XZ?=
 =?us-ascii?Q?sXvIx7rk7GQ9xFHr8FWIx025Hl8konYdxJuohspLq5nlPLKvk+SbJPbCzec2?=
 =?us-ascii?Q?XhFi+zl5KhlKsfI9K+EPw1jL3uhRIwsdY+d7fMbqYUFGk0oDZP+hTHwwfzIr?=
 =?us-ascii?Q?BEPqKtyJ0XeXUZq65oPtwrDkAM+hFrVCH4NkoZn8CMhogtC7zXRdu62w5Cls?=
 =?us-ascii?Q?xDWqf3IkMfettE088zkzSbt5ow4hFSlaU5zt9DSoVURaVuv7gnxDb1eEkHvI?=
 =?us-ascii?Q?YgeM2mSAAiNbAZiJFmHVfHMKmQU++BAad3iGwKE/2crKp1jve1o+LFYwpvUc?=
 =?us-ascii?Q?6VXA35kbAvW/r/LyFOdKwJUtc0IoQimdQKfAikPh6TBA0e6pOljDOZLyh7V8?=
 =?us-ascii?Q?g4xknd7DCyQru9M8D4nlzsz2Iuhhi2EZQciu3Tlo32R080u1skjKBRSSEBiC?=
 =?us-ascii?Q?08eW7bqHchLb6uyPIcoD6KkjTaEkzGE9fjNGS/br1HMLDf6pa8TeSt2EYf4M?=
 =?us-ascii?Q?mZpkE4ufm44=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?MtK3ER9MOnPlFb90uzg0wcHPnmQhEQR4mLHqsnlW80o4GAF/MyBKIZeF7nwE?=
 =?us-ascii?Q?Zkwy+YGugiIdIbWvMURYIlrlcNJnCmgCrq7KaoPkfyUYBLcjnyhRy46YaRzI?=
 =?us-ascii?Q?14WIo8Pw1loY/0jgm4zCqXkKcIJyahj9SwHrAztu9dNXn/5p0H2xwadSwvy0?=
 =?us-ascii?Q?+/MfsgNnskngPj5j6PJHIYZpRjfxrWfMd3ixYkY8PHik/XjpuX/+5nTIyZbd?=
 =?us-ascii?Q?WXqgaLq2RIP9mkIhT/umnDVV/EjsQTN6fXEhGkKdzRTF9HtEzf7cCjAFhU9s?=
 =?us-ascii?Q?MHB5BgDPKybSzNt60JNUQ2+jzFnfT7QTzD5S9XlElk2uLn+KhblcWwtEjgce?=
 =?us-ascii?Q?Q2kwdJiRlGFqru7JhbuyqYBYvyrveFiF0xOOgPRBiJTfT7+2TW/hJ8DNJrpp?=
 =?us-ascii?Q?UI1YGQiDLoUTiN/EAOxBuDbTNopkl9HJrXWneoz9L06lDzEVZ7OFQz10S16L?=
 =?us-ascii?Q?JO9LSAyWR0WmMjZaBzS6DJFSg5cvxmvNp95lBAi6csII0b192Ny84aGDRzCr?=
 =?us-ascii?Q?yB2CCApmkL305z27bKqcqQJKqLNH7CgCcdibSBfjoo5J/OKL33i03XU0c6gJ?=
 =?us-ascii?Q?BlZuQk9bUNSN++kTEzaQTbFmulH14TPbyigyqPXkWO4Q0D04GMCN3BEzqTfN?=
 =?us-ascii?Q?wmte4eCTx1C2+rMM8rFfRK/CydWwmwOglcETDUSGsrQNkwpayZrjX+opta7r?=
 =?us-ascii?Q?29xEED08rRQS3kK2PunYXWBxvNZxY0/TMoB9KcKmEkej3Mu/6P93TUyJ/jIY?=
 =?us-ascii?Q?ddJYpRvE0SmuP3KVuEqC7vg93yxI8sDCM1wMaNQD8vJ73rjgDJGCUtrJEqbD?=
 =?us-ascii?Q?9HGZk+6F2UnMjgVybhqdrf3YyW+V4dygrf6PtjSnIxjnf64O9rz7W0v/XjQt?=
 =?us-ascii?Q?rqQBGiEQIAtYt5u+JxAOct5r7ThCeQIY/IpNUu2Bbf+1rnvXV99u/0zVjkJV?=
 =?us-ascii?Q?Gru6/mPScxsplQhXl+JN9CNbxl7F9H7BVbDSoSE7egMKDKgyLBXAtTDKc2Ls?=
 =?us-ascii?Q?/NMYuIYMRTdax675WBOaROzYO2ebzk16P3yknZrwZuDWSPwPahUBVqesJlAA?=
 =?us-ascii?Q?BcpQj95PEDqkh0I6xKI/Miwk0ZAcfx5Q3kc5IhP9uXqBbpt4sgOKyTgMsWBl?=
 =?us-ascii?Q?ziYs05JhEaXkJV3UyACCABHuKLIXDzPr41IF1cPnABMk2yLZk+Xxq3HWP9bB?=
 =?us-ascii?Q?/EWoWFXeXIoRPOC0tY5/P9Cag9/7XDjQUsML/nBEImTV9/nb9YxVTvbKAH6F?=
 =?us-ascii?Q?/MrQsiMe+VujOwiZO3dl7XgRVHclbkQahIHtDJ72/2US98qEAOGNuk/wbpi0?=
 =?us-ascii?Q?2hnVhcc4q+9axN6LpNHySgTUxTNvN40gwPGrkKdnMpWj8fOSG86ECkQ8aUSf?=
 =?us-ascii?Q?SZ4u8y9HIrNfB+BJVbM978RnJcocJAOqZqTIV5rnLFgXz6M9fhLINVNt2gR0?=
 =?us-ascii?Q?ivMuqRs6iLv5TvCSPRbqjfPR9JWEV5BKv2XsCOdjXibUkUL4GvsPgpStay8w?=
 =?us-ascii?Q?2LCnyGy5cUpC4lzBwfxjSUdPNXjxhNPaNqcgVdmAlJU5WMx/GeoLFGWvco66?=
 =?us-ascii?Q?4GhBTx9eTiYUM4VBIPoZ0WhGRntHL9cNrUW1FCH+v1TRVVSwfD2JvUowqnsO?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 rkuGxuQDTd6B2zYxYRclVGUuKAeqpLU8RYfMmWcvkH3Vn8pxIDMq3w4/2/l3Yn2Drv+Zv27T+erZWkI+p1geC8fbb+ROh9mV2j6eGt5xQwwa5kHDAOs6y/eOS+1zaIyhmOENIfBw+R5IObl2C44sRKXlLpaQRSP2uY0VdhH3MybpFoqP3Pu6mLJ3i+XKzvEX92svgmdBAUsXjlIk78BwdXzV0/X47GfIROLhJODYzZzY0L20y78hB0MROZ0HW2CTc9AO3P/mkR8mSKK9G3gkaW5mLyyDeAn+otPzga0mgsvta8XCTYgHHns58wsOe+WI0tQxz1M2p6GR+LGxTHDKXQq71+Oks1neUBb9lbCYlILUOzhIE23xX/MG7208DCQBH7mkOLu/6UdO0Ud6mnZANwWpUmc5MhykzY1vzxbTocQzArMlrZDbs+NMpKCfN6qo2jKuTSOrETzRrM7C8U88I72/tn6kvvdxlHS/QkB3ZWc1NGDYHEY6q3VgUYGS0OtCmX1AalG6MIDYG1fWQ3qBOBI5ANllgRNNjkHXwqg1I1bV1TiVFqQdpYj2ITd1TM+qRjEdqqV8Z9i6ScExRlk6YbpEfwUvTfbMu6rovlPx02I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c9d57d-8e83-477e-638a-08ddc06920aa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 10:53:11.0428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ibPF3U0R7yY0G7XmWaJtZc3v0YA2coAi1lCQvXAsQdFDTOFccIkA9We4xNV+HEfpXRXh6mUb+bJFKI0+5LjDsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF079E800A3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110077
X-Proofpoint-ORIG-GUID: DN8kXY4ueL2fBJfxcgRjume6f76cNcBN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA3NyBTYWx0ZWRfX688k8gAvUo7+ IoiY3ZA+kjN4P+O1IRbcQJMfkAZ+/mhOHkpsIZYPK0k5Xw/jUN1wNBVQ/NwIZqWqjyeLBhIWfaq eUv5M30lACOZFFtIAKKPvk5xMPwxVAz5lGics0zKGyHmSDQRlBnIF2bvRMxFB4zhBWZOYA2CaCT
 3Bh1wmLa9uwIpkMpdlqPy1pN8OTshRTaJiZS48ZlLeukMZdZfwyD1xKf3LXx7O/a78Ft5+RDwDe auO9VybTcPCbISf5gWKZaZklQ17TpOtHlXI2bVtmDSLmp/+H3M/lwtukiyMqfNus9o0s7EN4Uc9 gzHmdawWT+QEtKU3LtjTUc/OsFKFUIAz3HKLALLd2rtnXdyDh9e9i/e8bDNZQedeN5ElcFmL/PP
 +a5iWNwLIEIS211dfU6GLgHAL5qvyyjaiUFBozvqKBIWCnR3AtbSZWCsQ/a7z9QomDwV8UUJ
X-Proofpoint-GUID: DN8kXY4ueL2fBJfxcgRjume6f76cNcBN
X-Authority-Analysis: v=2.4 cv=ENYG00ZC c=1 sm=1 tr=0 ts=6870ed32 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=oeePQw0IGsqOEWDZT9MA:9

Currently we use min io size as the chunk size when deciding on the
atomic write size limits - see blk_stack_atomic_writes_head().

The limit min_io size is not a reliable value to store the chunk size, as
this may be mutated by the block stacking code. Such an example would be
for the min io size less than the physical block size, and the min io size
is raised to the physical block size - see blk_stack_limits().

The block stacking limits will rely on chunk_sectors in future,
so set this value (to the chunk size).

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d8f639f4ae123..cbe2a9054cb91 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
-- 
2.43.5

