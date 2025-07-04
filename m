Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C895A2D9EDA;
	Fri,  4 Jul 2025 08:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751617672; cv=fail; b=qLgfhfGaA4zdLpcO1vTtAUHStklzP01L/ZwyxlRD7M8zlpfMOZ4qYAqpFxnIlMXgc/sUWU+FgIBoLSMUVIiS/pbnYnZ4535nqrh56BJ/+jP9SidrCDkuqPRH2g/piVtghHUx+5PLtFXxXJz4KTl6f93eapLV3aq85+nxEKDNa0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751617672; c=relaxed/simple;
	bh=qbPM0WGfx5VHqS8Q3LJgaxE+0me3R6L5GvEUrEW8/WY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bLCy9Eo6iCNTvv7EaUNJxXHACS3+IY/leoFIsGdTGWGVT6BO6Z39zITCEL3tSsserulvXvcg1Sq81vWdGzyXsi7qW1HQploMxZ2uOJTZoDJU2VfmDO878HFDN/FuJhXqXwMWyIAbvupjVGFyRC/mm5k6aDquBXTvyBgkZ5lFt3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W/lu5OHf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tx63r//8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W/lu5OHf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tx63r//8"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5645Zae3031714;
	Fri, 4 Jul 2025 08:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cOCMSvwrcwV065+ZwBClIK356AbDpGMJ0RdR+N2J61k=; b=
	W/lu5OHf8qKXIt77fLgBjnGIuFbCYyK8XU6etTwtCzTMT4uYiJCzqR83jknU1+Vl
	Zo93VDD9I5RtKFedue4N3FGp2maQc0oobzPgWgPnZiij0uvuf5Bd9Wo220+Qd2O/
	yDJEjGsLgXxiFvv1EQ4o9ZQjJq9ffe3uWvozOC/EabS2xZe5oUDO00fR02QbXt+r
	GWzp0u/u88jv/W48Us4eFTLVoBk1z7jjTek5PRdQDhtItq1OmnJi21Mst0AXNV0q
	qkCPUxQLgp06nAIjf9eKZVdSKe/9jav1SlMzq0oLniHU14C3lGi8FFvGu+ZxF50Q
	YvBF9P8vkcyG2eAptli2pw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j704jfxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Jul 2025 08:27:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5647kejc018979;
	Fri, 4 Jul 2025 08:27:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6udk0fq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Jul 2025 08:27:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KKFQhGZCU1oM3k/MQfw+vqXZBZiU8D6zP2Hw2HBQyJL6Mt9hkjS2mCKPMG0NtjtOk0QaqtnRMbbmWpwFJNzCk+FKpS9KE1ViFumkaFSY+WhQRx4Qeb+DDyZh01J8gdM9nvs1oAetTQwAGU9saaK1k7VB38mfh63g25JugYuVcUGDzqbYszkfXOxQM7iyBHKQgQsKd8SKDIgrnAUExbbjHpbLlPl1Z3dch0LZ1U2c6f6kPngDBBUeZeH+i5OlHG7Gd6YBRxteNCNTYs8DbMXlsx2GRYKp8VlT+ZX2nYdgUGPTC2/gxC/et3MMVAVptQ+uwGCWH1DQlqvagTPraYijdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOCMSvwrcwV065+ZwBClIK356AbDpGMJ0RdR+N2J61k=;
 b=G16dhi31tD7WdHb06qkaFhn40BJA6E7mfah3keqfmscpp3N6/pbg2J7MqQq+3h5qiOfQ4c9u01FvpwglgNLfr32OGyPW0Pv2iJKhreztQP3MsuMfpRaooijPlMiomErTLxUoqgRYfsL+V4sVxpABi0xt2pw0DszjZxg540o+2G+rYW34R6Tt7u2UwZJWWRrlmkP2+GY4kyfQ1NDYSahwvND8u4+b/JKOtHq6kTzgPGPHf9QuzLLPHA4P6SJ6InUfUuATiQpr8y+dJNjNje9RuS5zqrySqVZzJuZQiP8i/TiF+rSiAeE6AyBDr8KQThy9Tj03jHUJVv0eASiWF8Zq0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOCMSvwrcwV065+ZwBClIK356AbDpGMJ0RdR+N2J61k=;
 b=Tx63r//8LE3w79AnyDzWlg2fWw74P3x63Gw+9po4cV2gh0m13bEdLWpcW2XTZtxWD70Y37pEavvKtbea3YDN1LHlJ6Xdcax2caIr0lYU66rtKvT30yeFtxu44jSh5YPrVWIQ+Wh71bXRcBXbj627EB/xfM7cbyADlBKprqjBHYk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB5858.namprd10.prod.outlook.com (2603:10b6:a03:421::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Fri, 4 Jul
 2025 08:27:02 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.8901.021; Fri, 4 Jul 2025
 08:27:01 +0000
Date: Fri, 4 Jul 2025 17:26:53 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Zi Yan <ziy@nvidia.com>,
        Barry Song <baohua@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        syzbot <syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com,
        david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        matthew.brost@intel.com, rakie.kim@sk.com,
        syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
        Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [syzbot] [mm?] WARNING in xfs_init_fs_context
Message-ID: <aGeQTWHSjpc1JvbZ@hyeyoo>
References: <6861c281.a70a0220.3b7e22.0ab8.GAE@google.com>
 <DDD5FAAF-F698-4FC8-B49C-FD1D3B283A8E@nvidia.com>
 <1921ec99-7abb-42f1-a56b-d1f0f5bc1377@I-love.SAKURA.ne.jp>
 <630b4379-751a-4bf1-a249-f2e051ec77d6@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <630b4379-751a-4bf1-a249-f2e051ec77d6@suse.cz>
X-ClientProxiedBy: SEWP216CA0057.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ba::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 984d790a-358d-4a8e-7a21-08ddbad48cb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8otAqw11gPSthjClOMwiGicPEvCkf9TAkpLoGzz8wSzNg57XKfS4lIi+YNNh?=
 =?us-ascii?Q?rAu+E88DllHgGzz2gfTyV7DDBVWtLHEGL+QUt+3TtJt1v38j1lmso9wy/gJw?=
 =?us-ascii?Q?Pt5IXit04r0XjfWnutBf5ZSkdiVvAk8hXwtMsjzessF8X7Yxhkte5J/0rrRg?=
 =?us-ascii?Q?O8IiVW9Ea97pFfzdf1U+vn6If6r1Sx6k04WaTVPKsDMZiE059iGp3bgfJC74?=
 =?us-ascii?Q?2+/8aA5TW2mUcLazAggefD8aQVmje/4OPZGgb18zOHw3p5QCsnDYOUKUxeCR?=
 =?us-ascii?Q?R7hrFokCti5Df+W0JCiGDcmBdSb1X5aZOJedlKbXCrAPvrXSA5365tgTrdVP?=
 =?us-ascii?Q?ytqC6Ey6h5OwIpio4op0H4TrZR4ago2Utv199Zqydmak38XbASYb+pL1/A9d?=
 =?us-ascii?Q?Ha3ohcaK91rwuyPRAtGNOS1BpJxy2XvC57somoVC5t3zoQodxzztvb690K9l?=
 =?us-ascii?Q?UlNGnbku6BO8okLXy6BiozRvAv2lA02B8Ry6wuHliGuBuXtGRzInn3Ln+Z1Z?=
 =?us-ascii?Q?mqmTMx2XAr0r6+sM7OvrcbwJMQWglOQbr4OLZSwc1LugbUEbTJDtGWiXveoJ?=
 =?us-ascii?Q?DhyWL0VaiaqYvr3Kk2O8xsLtKY8ei4gP/s9UjCLw8AaphpLPGhy3l9S0IEMi?=
 =?us-ascii?Q?mQWqEznCjZhhVAFcUY0GAlMJSil2Apln4wisJywE7pr/nQNoEqwfO6+lmajU?=
 =?us-ascii?Q?kTmVKnDajYlWf90JzjGbGvWy6nXj4HTp+BfnQn76VX+5FCX8lfdmTRNmmu2C?=
 =?us-ascii?Q?G01BMJXeZv7izK24IXNsEGY451qtmeZwufaj2DZU3qj3rgus94ibCyuGb1fB?=
 =?us-ascii?Q?z9HncPMxzI+qdI+fcDneYZAfkp4TFsCLZpaQaC3eVGpd8dbNmb07yP0J7kjk?=
 =?us-ascii?Q?iBwL/ZY/QxL7lcYkgZYTY5NuDm3HkXaqDUGx+lKk7akGDsCjY8m0/r9WWQgB?=
 =?us-ascii?Q?J72KFdIw5Q9I6jVGHAlr17kyP0go739nYC2vtP/98Wz5t3MeC7eySs7BYkip?=
 =?us-ascii?Q?uvuJdwLJR0Aig1YIYSQBjprKTY0Lcchzad/xH+FPUZ+nJkqUrx5M+s1bdHSY?=
 =?us-ascii?Q?b7RVdlbO0jMOJc8hEt3id3fa3YjUJpR99iTdavf5nNmyTUFJ0qOhQ11H7esE?=
 =?us-ascii?Q?80uYohYorCn1y4sw/6vU/ZtoxI02Vsn+3kOON92SvwSvmPp5sdqgFM3E1m+P?=
 =?us-ascii?Q?vWw2o8s+ncUaQsG55JbVD4pihSZtbu0ka8O9DHljmdYADceQ+fewLHaLdnmA?=
 =?us-ascii?Q?GtMXUtvoJ7PBNQdab0Obm+u7Tl6taPan61ylguYo1fLBVo8XhcOIiBYWFQrB?=
 =?us-ascii?Q?JQeTHMgdkJoSP/ALtJBBH859K2pgfl++LEXwtyzCkOUUGOn5Ejb4G+HeDMnx?=
 =?us-ascii?Q?YXSPuz1tSXzcPxeo6Z5tfIEY2XHA20U3GxXfoqJ/7NOaB9fZ/82ixmMnrtyZ?=
 =?us-ascii?Q?u107vkXxAGQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wujfDmV/F2dpChxmBEu3i2RVhwvfQjpmU0szAgKrqjkHz2uONi+PXylkCgy6?=
 =?us-ascii?Q?wSPrXklPni2pY4jsSIMbCLRdlhng88uFCfgGdPMJ5OybtIh0Hf+Z+XOjbTM9?=
 =?us-ascii?Q?pPONjXqvWX3lnchpOGNN+EnCDqZ39OjLTuAaJ7lagH+B4aBz5EaH8rVYSn/A?=
 =?us-ascii?Q?7MG9cFDcEjDe2pMDRAuGDum7bcSP3vpPFAuF2l7rKocSstson+kDp5tsE6vG?=
 =?us-ascii?Q?pD8lbqComVGamyFquYTpzyDTcEtif1kHIUnDUBtwq+j/ezfrANpO5EMIpUkI?=
 =?us-ascii?Q?VAchCa2bop01hIm5ZPxQtmZ3q3AsoDMsfYSpYwmS1qIFnvtPzQk7oPfqUQmO?=
 =?us-ascii?Q?LsoUVejPN+/0juKaoVCE4UYEti6/LUQ8g4ViSHZCxCbaU4VaGmFPBwABSUl3?=
 =?us-ascii?Q?NsJUNmKVvRunxx7WIrYG8jy4sQMLOtVAdkTMraQUIXobPYqjckBpYIzMU5Nh?=
 =?us-ascii?Q?vb1Q5BwkpUYnyGvQMEtUWrdJ9+cMjFojYPZG4lJ/HFdvtGfUbjNDpHCL1V5G?=
 =?us-ascii?Q?icvSw6lwfOqIG+IhSs3vBI0FmCRpnjAigQqYqBFf1PcEWgODw0k3zpFLs0V3?=
 =?us-ascii?Q?/pddMGy6gtqLJ1gptXYJcKHp4a3MwImlkRMtA6NjJDL+Q7XDRd8RJf0Fapbj?=
 =?us-ascii?Q?s7cOEqxZ9Mv0XOdHWHEtFPmpYitCkamO/haiOmM3cV9Pyz5EfdB+y6jO+svI?=
 =?us-ascii?Q?Fg9FZYXyZFzf4YZTZsUocAKc6E73MrtVkwmRQaFLxs7NvDAR9TNmJSxI7rET?=
 =?us-ascii?Q?As/ZRBK5lVYvgnOW7Gt1XqQUO6Gb4Z8W8ZRzJptQrxJjk3PyvvTYpQOwoeBr?=
 =?us-ascii?Q?Jx6X/Y1MaTi3BuSAXe2QJPQAv3QffiQ9YgefBFt8FGgUorBl0DhGgZJTYulw?=
 =?us-ascii?Q?PaxRjpIr3M0pKB8PzkFGfVyyPoDtqzB1tYz/RM0M7QtNVM0MKOyA9nt2TW16?=
 =?us-ascii?Q?k4peezW1XLHjtya8SQaJeqAdtIkm4Q0573whIlLKaL05ssBHs9oxcDnu4aOQ?=
 =?us-ascii?Q?xEvs3NQZh/xflemdYdaK2gT56eoacFhl1olotXxOANIru+UzVcnUXtKJVQMr?=
 =?us-ascii?Q?5NtH3mE71Gd8dUlreKHrtkDIh4J49sq0+5sbzKZ318kbTprgpc88pBDfScG2?=
 =?us-ascii?Q?JxVwB/RCDDQZpY81/8G3oCX5NkgIXDYZVNpzMjjqjmRLG3wo+Xc0EOSXCBv7?=
 =?us-ascii?Q?voUXuUseIBXp7y06G3G8ttIbEtM4+3IzqamwQELanu4GPATCjamZE9t4TacZ?=
 =?us-ascii?Q?pHoQKso4e1NVDQIEsWt4nXtQj1yN5W+hUUkwMnBPiVqLp78Gmi+EBQcv5Llg?=
 =?us-ascii?Q?LnoR0bF6Ix3jFq9b/G0GTWJNgNOWzhrUeusBX0fE3y8EKC76yFxy5r+pRhaH?=
 =?us-ascii?Q?eedzuTKWkKHChZp7vejeYgQPd3p2w/UQs7hbwH56pg8RNk4jluPmz1uBmK0e?=
 =?us-ascii?Q?JF+XtrQeLHKqH40aZr0N0spvXeKlWt6W72iKI/UMp3uj/Vnzwl7AAt4hViJd?=
 =?us-ascii?Q?YEw4QB0pb/a40PcaYWkqrZbAvbqQSRDZlUhUkMvwXMV25jdSisW+2yhzoqVz?=
 =?us-ascii?Q?6g8r3BcRbeKiYisR7U03KFeXgyy/ydBfQYqjjtpH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	44fQO1vnnlFk8oPAdXrWi7TJ7OtSsQLshQ+QiXUjTVB1yIAH6OI587LC1b16pYaab0bDM9zFr21NsrNe9I1YBr8APehA59rw5vQIgJISVLl9hAwfvg8YiILrKvw/Is9U7JAACu1m4jxZS9ptJ2hxqwz0tpY0hUcnA8yAYDy06A3Qs6KRM/l3yzeiDT0ksYbn5MzKSkCXYDTiJ7Hpqy4ERE3gwB6S3LugKCaiIRyai2wr3kehS3W1v7/9bTYSy7f0/GTv/vRXyRtJdfNLNKgHBR5feiPFidpGy5uZgoClchjtfWyJtnviNQ6m0D+SE3gBu4pduIjZcBl1GvmfjbMueGMns0L4AFNkruc3lOR2jPpeKDlvuetMp9xHKVynO+C9Ha8Dt4sHUmfXitfmQPO7++p876xdAUsTqyd917j1pgv/rZWGYwkQFM5NUaijaauCiDjWYbx/eB9xOxf6aG5SkkGTIVlUaXkyfdIU03bodRKSe7Vx0ahvH2mywtpOdy2XMjrI31IKyHW/ulKS6r6t9OQBugSSqD7HCrThM9Z9ST2ycxb0ZGLW6aRr9bRc4Gi+42xWyoQ7vxkbAZ5jr5FU5uCFLWW68nDSWEXkxae15xk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 984d790a-358d-4a8e-7a21-08ddbad48cb5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 08:27:01.8060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VioBY/QYBRvgazJD/iHb/TZxH816XpooQ15qPw3nB5pSjZtUbzvT2a4EhRkQeZYfSorK20CJVi8iyWe1ZkbpGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5858
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-04_03,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507040065
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA0MDA2NSBTYWx0ZWRfX+2qYhMp4rQ4V j5SRRUgj+T6orHYr7u8mnRA6HX08AuE9ama6ACfs8sTB9mPoF2/NP1+v3QucQpT/Qts2LRCB2FI 2sr/NnvVeqJC/10MUpm0E9iV4PtvxFpKzNgScz9gbQ5eWQ0j+wuENfZDW8W/F5laNFIHByGDg4X
 nwnvz8qaHEPo+MUMKWqQkGvu3K5T2y2ix4bwiAeiWlp1xheeo/Ambv3fKISFY8zVThhUxdNUGjB 3VDsKar96stb+HtSDisU9b+xR1QxTo4/k1kby9EFIjoYtclMgedj6cDnC7dtJmFuujXWByLBJ5B gx+ziDNoKTk8VNyLwFMrBKve7OB8q1byp2AWkKXxUy+EEM+DVMFqohEBh0gr+BijC6s6nQ4Nc3E
 C+LpW/WNbg4zqV3QIYLymp6atc9WTCE/FlFrFGcBGyfDZuk/KsEwDWGQ9ys9uPMwrhPBx+b8
X-Authority-Analysis: v=2.4 cv=LcU86ifi c=1 sm=1 tr=0 ts=6867905a cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=XY8bM611AAAA:8 a=sFoR3AaSVhllv8nMLqsA:9 a=CjuIK1q_8ugA:10 a=t7jRrxMttnDnNWY1o8da:22
X-Proofpoint-GUID: 7xvaPWz9eDV6ApDPMN39NX0zAm141wGU
X-Proofpoint-ORIG-GUID: 7xvaPWz9eDV6ApDPMN39NX0zAm141wGU

On Wed, Jul 02, 2025 at 09:30:30AM +0200, Vlastimil Babka wrote:
> +CC xfs and few more
>=20
> On 7/2/25 3:41 AM, Tetsuo Handa wrote:
> > On 2025/07/02 0:01, Zi Yan wrote:
> >>>  __alloc_frozen_pages_noprof+0x319/0x370 mm/page_alloc.c:4972
> >>>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
> >>>  alloc_slab_page mm/slub.c:2451 [inline]
> >>>  allocate_slab+0xe2/0x3b0 mm/slub.c:2627
> >>>  new_slab mm/slub.c:2673 [inline]
> >>
> >> new_slab() allows __GFP_NOFAIL, since GFP_RECLAIM_MASK has it.
> >> In allocate_slab(), the first allocation without __GFP_NOFAIL
> >> failed, the retry used __GFP_NOFAIL but kmem_cache order
> >> was greater than 1, which led to the warning above.
> >>
> >> Maybe allocate_slab() should just fail when kmem_cache
> >> order is too big and first trial fails? I am no expert,
> >> so add Vlastimil for help.
>=20
> Thanks Zi. Slab shouldn't fail with __GFP_NOFAIL, that would only lead
> to subsystems like xfs to reintroduce their own forever retrying
> wrappers again. I think it's going the best it can for the fallback
> attempt by using the minimum order, so the warning will never happen due
> to the calculated optimal order being too large, but only if the
> kmalloc()/kmem_cache_alloc() requested/object size is too large itself.

Right. The warning would trigger only if the object size is bigger
than 8k (PAGE_SIZE * 2).

> Hm but perhaps enabling slab_debug can inflate it over the threshold, is
> it the case here?

CONFIG_CMDLINE=3D"earlyprintk=3Dserial net.ifnames=3D0 sysctl.kernel.hung_t=
ask_all_cpu_backtrace=3D1 ima_policy=3Dtcb nf-conntrack-ftp.ports=3D20000 n=
f-conntrack-tftp.ports=3D20000 nf-conntrack-sip.ports=3D20000 nf-conntrack-=
irc.ports=3D20000 nf-conntrack-sane.ports=3D20000 binder.debug_mask=3D0 rcu=
pdate.rcu_expedited=3D1 rcupdate.rcu_cpu_stall_cputime=3D1 no_hash_pointers=
 page_owner=3Don sysctl.vm.nr_hugepages=3D4 sysctl.vm.nr_overcommit_hugepag=
es=3D4 secretmem.enable=3D1 sysctl.max_rcu_stall_to_panic=3D1 msr.allow_wri=
tes=3Doff coredump_filter=3D0xffff root=3D/dev/sda console=3DttyS0 vsyscall=
=3Dnative numa=3Dfake=3D2 kvm-intel.nested=3D1 spec_store_bypass_disable=3D=
prctl nopcid vivid.n_devs=3D64 vivid.multiplanar=3D1,2,1,2,1,2,1,2,1,2,1,2,=
1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2=
,1,2,1,2,1,2,1,2,1,2,1,2,1,2 netrom.nr_ndevs=3D32 rose.rose_ndevs=3D32 smp.=
csd_lock_timeout=3D100000 watchdog_thresh=3D55 workqueue.watchdog_thresh=3D=
140 sysctl.net.core.netdev_unregister_timeout_secs=3D140 dummy_hcd.num=3D32=
 max_loop=3D32 nbds_max=3D32 panic_on_warn=3D1"

CONFIG_SLUB_DEBUG=3Dy
# CONFIG_SLUB_DEBUG_ON is not set

It seems no slab_debug is involved here.

I downloaded the config and built the kernel, and
sizeof(struct xfs_mount) is 4480 bytes. It should have allocated using
order 1?

Not sure why the min order was greater than 1?
Not sure what I'm missing...

> I think in that rare case we could convert such
> fallback allocations to large kmalloc to avoid adding the debugging
> overhead - we can't easily create an individual slab page without the
> debugging layout for a kmalloc cache with debugging enabled.

Yeah that can be doable when the size is exactly 8k or very close to 8k.

--=20
Cheers,
Harry / Hyeonggon
