Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3665D28DEFA;
	Fri, 11 Jul 2025 10:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752231239; cv=fail; b=cn18zsFNz4q0js248UZsUBEPh+k/k/N5FO9P/Q9BcCLriBLvE/WPpYh9+9+mLNPZg05FFEIDY7sJFNpXceQnqL8c/PUoy1wSDb8FXohVLVGAlbvspp4lUjMaxY4BEtnohNDR6Trzs979MavUnOA8GI6zfTnaR3Dd7lvdvTgYoqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752231239; c=relaxed/simple;
	bh=zVRMU1Sf7LfwRzyxIq5AyPu21ICE8blLe/VGGBhnNx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QWXBy0V5kUyVRHUYiqKvGkq9Jl1XO2FLdWShv/3wb2Xkb+uUrf+UR4eeppOgOUVmjH2J8P3Vg38KREjarV2k+S1rcWG1FPMFpdJ7wgRfibpKvDI/Qxi7XLYdobCLxLG6DZejYIHwUifV4gwToN318GmJSs21MRZ0LcR+6WirzJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lIcwf3IG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gChXRudO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lIcwf3IG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gChXRudO"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAggat002685;
	Fri, 11 Jul 2025 10:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lgLqN2NxVcJM/hImjq5K9Y7RXqRcjOhqoG9SYNWvypw=; b=
	lIcwf3IGklUqI50Q/OU7U5p4NfZsPjXVsbCWIcH8unSxLheLoaO53I/+HMEafESF
	q9ShLzog+xafWaiGQDYrpP56X94iPoYp7l0AneZgxfmO3gKz27JVdtrmmOl3Fa77
	9voDf2Fe7mCmSecpcTAbv86SmV1LoB8JdTCyaMbOlSmDacb44UBOLngnCuFdryVs
	geqoaXdpsxNQ92Grb9PSNajKjHvPizIu0jwqlW042is0cW0JZYlJXrpvB8frf5x4
	EpqwnH4+iT99zK67KluKRKQYYDOvl8RKzlUsfiql46FhZ6CvrdRjEJ90lKoLSUCM
	Xxkch6HPSoaj+OLJ9C2Q0Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47u13980hv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAok6e021358;
	Fri, 11 Jul 2025 10:53:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdd1bv-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XEO7+REgXhHxMZDA04q/4KMepqyI7DUQsupZ2Ws31oykYHSrl2hGW4tocNqxEn8dkDK12h2SL1ZB/4XdwplPP2w5wHnYv743MyfrCUukt6wQ1MP36uelm7eKhvDOeS1HsPMqQ5lsn1+0lm56C5qH1vNAi6xeQPNxnPGRv3dGEVBXj00GBRIftDP1Mmslgha2hXTuirxOjogunrmzDpQZJbV/nKtlE7l7XOtgYvCkNO0Rl9fds3qB4eackz/FGm14vjfxSrDSLkOJsz2xqcZR186/+pd1IZE68HNvitvoOTk+ZbPSiFcCbRSfvnRH0vDM7kw8uCFQ5OnQaUHaJsSD5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgLqN2NxVcJM/hImjq5K9Y7RXqRcjOhqoG9SYNWvypw=;
 b=nJc6Axxvc3tEeJ6kkJ9tphsDq/KxBlYgMStZGNZVR0C/JsoRhJZ55mnpXjuqgMTVJTtjJ6oW0qSUcj2FY/evhm0aI1xPjB+SUq83J0KUnsAlbCaAB0LGYaD7HChXAczqIFOKEy9UkCfK5QcAVoMeUgbjXPCMMA3tJo/BswcRxDhCHLG6vKzcnCsAkezYTJBaeTCZnx9HxGTQa3BgUvdCaKPWDhcsIKCgGOQVf19bNpjvIneFLFuW0Tw5282ZDqBMpeNqEG/VMBzQVutSJmlefQnkYkvlrMrcA2t+HNF0ZbxFtkb3mHZI+Mr0nVAs5iQ4IhKn6LkAiJefHpObsmicNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgLqN2NxVcJM/hImjq5K9Y7RXqRcjOhqoG9SYNWvypw=;
 b=gChXRudOdNOrBWb5c1vPaQwS8Yctv+WjxT7bSePk/XYG8AOzKJRMDw+xDh1N5aogJ6LylG1cU3fVZhKnzN8RXp3EtWr4Y20/8YihmCA42Tmu/wB6v3E+54Tfi3LyemXsN3ZmyJKGtAMRzQqpazTB+2L8LFdN1k1HwKgylOTSKNs=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF079E800A3.namprd10.prod.outlook.com (2603:10b6:518:1::786) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Fri, 11 Jul
 2025 10:53:16 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 10:53:16 +0000
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
Subject: [PATCH v7 5/6] dm-stripe: limit chunk_sectors to the stripe size
Date: Fri, 11 Jul 2025 10:52:57 +0000
Message-ID: <20250711105258.3135198-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711105258.3135198-1-john.g.garry@oracle.com>
References: <20250711105258.3135198-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0096.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF079E800A3:EE_
X-MS-Office365-Filtering-Correlation-Id: 9366a239-202b-498b-e3ba-08ddc069239a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?fnO/n0IxC8ZfFbO2UXIdpYvkhZKFgalN2tg2MbTZMDInXkRMRdWiVJ4IaFvv?=
 =?us-ascii?Q?yUAcIsRTdvRwfOiPfkjRrjq+1MBc20z7k+PeTxhQ/yb4tjDNehflyPjT6zYW?=
 =?us-ascii?Q?OSVvxnzUcM/7fvgCgKptrqW4JV4lgtmDMtwqgzEUT963WJUoPtVoer2sy4mn?=
 =?us-ascii?Q?K+k+aoPoMsz3JejDfsGgPcbALqFP6n9GkXx68JfafBhUfRGYSpl0O1u86+Ti?=
 =?us-ascii?Q?mKNJcuUsnC0lQd619YuW/dQRQmd/HLea9Pl/ZZR0us4Vdf1R956y+W7sjrPE?=
 =?us-ascii?Q?hqUGiMS5qTWYHhJemv3mI47+Y/yBZij4awSd4g7GswaeJIvFK3pAimStWdij?=
 =?us-ascii?Q?9gh8cvy/cAgeWq/lF7GjerfaN3cctMM3aiUECIHUeQmysCVjp7qSrY4TRDTn?=
 =?us-ascii?Q?idfvXiZ4bt1s5WchamK/NouyLq2XkCF7ldfshkzQlyKmIXIwK3urwnKt+w7Q?=
 =?us-ascii?Q?ChLNfBU4Zbvk8++bolQNE76BcZOyvJNkqGxwj+kYckgSjG1BNoNU9e+qXfRs?=
 =?us-ascii?Q?DPvmCBXN+XuGFY65IryuAhEQgsmbjbA4p2rPjBFGRzXDbrhrPopBi4WW+jIB?=
 =?us-ascii?Q?NnqE6HWIb44wlvirKAf+IN4/FELyCrWlwhSsGM7mabwjqxDlgjrWYxaYkZmI?=
 =?us-ascii?Q?9zv6lTRfk7eFW+bPsC01+6MbOjtAQhjmLd0T0TW0TzX2zmVXWU7qZEX1QV9s?=
 =?us-ascii?Q?JNWHZex+08q93OKUMqwue7697Gjgz1EaP5VaqypbDRYcs3MPO03VWoUbPbcS?=
 =?us-ascii?Q?3Jee5C2Nq02ZwDNW0Uv6UUaZ7iRQFkW0FNHfq/8tXc5VK/4LfM6b9P6re7U/?=
 =?us-ascii?Q?ZOmTgKojWV2zYvZm4ZtGddZJ+djPjye1+kApVhzpjwWA8TKCs2s/PcnCK/oO?=
 =?us-ascii?Q?qkexOzhG7enYpe9xl1udRgu8M3kvqLasRjq81bv2g4m580JKyxnsyxTmWVgZ?=
 =?us-ascii?Q?OG+RLDecB8UDuO5teWwUH4O37cbVYxrZN6OfY2hdeNQLV8OCGuuRIppy7xNh?=
 =?us-ascii?Q?TywvC9sgYdr+psWH5FnHGKnzzhF6IzrUasW9AvU7bWPlLg96Db4/gmCSLCe8?=
 =?us-ascii?Q?md2i06rTnf+PuHUZZ65sDMsJmr1OriZhM/olPtGU1rB0wcHlbqeoHh8n8eEA?=
 =?us-ascii?Q?EyL34LsFupL4Plqm+mRBQqI3AWTHfqmKWXoSNI/4i/603lZRWLb08bgql7Yj?=
 =?us-ascii?Q?/lVpG9KHxDNypyA0kxXp2UWBHp3xWI1HmCOgNJmCMVQGTgqvnX2k+SWYXP43?=
 =?us-ascii?Q?rIJPA0JhVrBsdTCZbsZHRuabp4fws0Bhc/3TFeuRKL39p+Yd7gzg6Dv5QFu3?=
 =?us-ascii?Q?bqzxJsn+r8crWtVJrgdFOHu4a2wuNNo4JjzkGEYUzS8f99k3UtAvjEycYxkx?=
 =?us-ascii?Q?a+4afH8iBE+qoF4Vq81GS0fKe7I6Og7CheSLNVDGiJlq5TGhGB6cCmxCrHC9?=
 =?us-ascii?Q?2TPIzxBn3vg=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?bhOVh7tMZlRnho7FwcT7eTL9t5DshGsUb4e30UGhCEuAd1p/qW2br0C4I694?=
 =?us-ascii?Q?ThptTbqo3qlGF/znSHsmwOCoDyi2QB1ihWZv/3Iujfh+fCCPuAhrIUGciZzQ?=
 =?us-ascii?Q?FsyE+ESwsubZ/lOR8qclx4f92m1LtduFupYDBXkdErF7LP23lsQSG7wrR8pB?=
 =?us-ascii?Q?GrHAdKq2X8lDzFsDJ25KzQynY98v+84LT+oa+SGHlVOVeT9ZPd6n7kIOetdF?=
 =?us-ascii?Q?36QtqpuyyYTb2pAQE01GmFCSSnAreDA9cW63NKNL3HoctNb2wDVqItuPpNC/?=
 =?us-ascii?Q?JGZK1O6T2KSVvIk27tPgfAI/HVMl1ZRzKcAt5h//bfJbZl18CVwJj35uH/im?=
 =?us-ascii?Q?23pBFf97TdfSTSy2+XHXpYjCdXGCUJa+6i7eVFIMFX3FwTHrQt3z/nGhOlKc?=
 =?us-ascii?Q?17LUN8r26qdzVwLMU2ixxsSX3DP0BdNqTB+M9jMMk8qntc6NJyTmxNvhoNS7?=
 =?us-ascii?Q?MNZTiMC2bl3mxGZErlPPLjBKva6q4616nT+X0w+28nneqOnuFoTJLWE48J6/?=
 =?us-ascii?Q?3zpS0++A+rEu5XO0CID4t6H0H+GDo2HfY2vKs8u09NjIBiIc9o2hEOTynZd4?=
 =?us-ascii?Q?HDgV1d0URAU2kD+5bpJf5g6AISsnTGf7Y2rFYNKRmaOifSFcc1S6FKFgjcgN?=
 =?us-ascii?Q?JEf9pA1akpM60DOaOjeDaOHPsSa/OSH+DZdWCvONH1JJXk5NL45/7AV/AtYo?=
 =?us-ascii?Q?q81rlPZbgmwwOXYOh4Q2swERD4ENnadsMOQBYSwMHjHnxoznhtsSTFWWU05G?=
 =?us-ascii?Q?W5KE8ISN7Tqu1YgD5FtSpPt0zCSd85s+sKfMilAaDJ8RVm9vhvmHI/2iyG0i?=
 =?us-ascii?Q?cE7ODxYgUDUPQdol6FjQoI5j4uAna6qncbrgnLluwUTeRMnCiYVQIeGdhtTI?=
 =?us-ascii?Q?ZmzUfS/W2YdCEXki6thBvteNjdc5mrVJ+18hFcKlJknyooCqXQoYrNVjOn4H?=
 =?us-ascii?Q?UqOBzFyIqV5zaNevf8R2wuE68PFPj0X3Lj2Pqa91g4TtaG7tON754+ltktGS?=
 =?us-ascii?Q?OYOp/DO1Uz6TvEjVC9+WejFNVsRzVSVJH0lkPIzmP/gYouYH2eBZaomTbk5z?=
 =?us-ascii?Q?vJlNy0uMbvbPXoiZ9H6PGRhWGPyE4J9ThY1W3bl/bqTK8AgSJgWt12NuFXqE?=
 =?us-ascii?Q?kb/xE11cgMmMjFCcVQUfzPhMGun3HxThuqinHDJ7SFqA61Vwt/B7Um4c0u9J?=
 =?us-ascii?Q?pV1gtwnz09DG8BaBF1z2q98EJFWnWnX39iFyJfir/jfZkkn7mGS5G75qMTWM?=
 =?us-ascii?Q?ps/Kjs+p414cT59VC1zLgx1og/yJteoT4KDWHLai/dwFTk2ZbcwGC7V8WwGI?=
 =?us-ascii?Q?8t068EhO4tO5jzUhFvzOZBfHtH7QsyAxPCdKzd3nJRqqINMrkOOnZUDT6msG?=
 =?us-ascii?Q?Bdcg4EHJeXjsW5ZN6+NcjeiBSj81GbyIuxgLcoGev+radvNuVjWos3OiVFtX?=
 =?us-ascii?Q?ZrWzJ2Lxkgcl9h4FaWtR5WVI8KZ14fzRpf+NyikN2QJ8oqnjrlZGelRvkn7W?=
 =?us-ascii?Q?pSJ9rHLSPOSywUUHSFNEEBFUIgql+ERQMfCkJTH6oJkR30ZBt4zZWyNKOafP?=
 =?us-ascii?Q?ALKdqm3MhOg1Mad4S2pRmm1FzmRnxHJqqgny3+5Ix7/Hsn0DsLEpts8GVBgX?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 bKhLwdaJllEs9QMotEpbP97ljHRfi/HwGhcNDnbUIPi2Hv72rpPuOH+nKvSaIrRjdeB+puWcX/SkK02zmfFBwwpt6A+oPJ5BNlhk3uddZ42P9B/srtIUsu+9E6e+pLeKIBHrOtG9Q/owsK8ETJzkGOFnmfWgwalH0MLpdN/glvsCw9kbkB/Fld4VQdXpEoe4i/jsrlU1LT9EjMdJX4jplxz3WV/6Cr2x8U+Jkv0qW3m50g+xYo5K5NQltjnXp3obZ2TwUCOQVHVIwPhwxflnCNJR3ljI05HJdNlrRDpIAAwTkfxqgR4pkHPjv409G9e0NxZF3AG23zOYxBcABCVPqfuwtAoG+UtHhidse48sm45cB6yp26O4cpfS3x1RtBR3K+82CEI3/iAuXm+Bl/4REYWGcIMVuIrjmFB+JnxOcgvKxoVXn0xTcxQXQMolJmsaZScKUpUCQi9YGIkIEG2vwDuIvMxW+9EOxdlN1XE+F/zHIZFlR7z6q+9oF1v9KX03IFVWO+3bK0B2xEoZku919ZXEHa/frKR2bqKhXeD0CEnkuVoqjfLC92yTZ0MLFsn6w+C3Z6MkEXfz/km6JMD2k3huIGhbfxWNHrOw/b8u9q4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9366a239-202b-498b-e3ba-08ddc069239a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 10:53:16.0849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iIqcwK/4E5iK89A5zMcDeaFO7wRSZlKMhZY9p/Qb3B+V8zjJLOPjMFwOu46emlLIq7LcB+VX4Ka6LLslmFQ0jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF079E800A3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110077
X-Proofpoint-GUID: 4ecvmQslmu-5EgxFYb6lYDaxCVMn4aan
X-Proofpoint-ORIG-GUID: 4ecvmQslmu-5EgxFYb6lYDaxCVMn4aan
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA3NyBTYWx0ZWRfX94VMNVamDrrV mmGudsTmBkc83SUpU7GzBBOXk59BPGwAALzSeeIC/lyT8EiaNBwaosbUPjk7CWgNLuQH6+cgA+c jjHZ6tMcIOLTPeVQSYLI+jEzz9uw5Uu9R9IxNnkgF/Bknhh419nTCOvBKPvgOFdy9mClPkEGufU
 JvxA3W9f4Rj9/tUwidvnTJzz67kBsIONKhJnOACK5veOWCtomHilX/I8K6DfWMPyTSl8gh5MH0c fAM6+kEO2oCuYBJY1NayGWFY4NPYxatxQnHTtakAHETVS/dsdIIroonowvGhzOR9h+dgWhA//uw v2/7m4Yot92xNAshWhOudKAbSQzW+6o9EpG0SfevwHGU8Xa4FPgxx7J576Tr8KnRQF5PBsUApZ8
 i7J+seamGrGYLZgxMqI5bDs52qdWBLguOeq6RcOp4oUDrY2lJ4Zy6xoh2ffU2hwPKD23hPNJ
X-Authority-Analysis: v=2.4 cv=bPoWIO+Z c=1 sm=1 tr=0 ts=6870ed33 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=RkmrOqiwSQOQut1nclgA:9

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Setting chunk_sectors limit in this way overrides the stacked limit
already calculated based on the bottom device limits. This is ok, as
when any bios are sent to the bottom devices, the block layer will still
respect the bottom device chunk_sectors.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-stripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a7dc04bd55e5c..5bbbdf8fc1bde 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -458,6 +458,7 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
+	limits->chunk_sectors = sc->chunk_size;
 	limits->io_min = chunk_size;
 	limits->io_opt = chunk_size * sc->stripes;
 }
-- 
2.43.5

