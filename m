Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79668272E56
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 01:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790300304; cv=fail; b=p29BZWF6tqN6OnLeE2ewwbCncnMmoUaS+crXZWJ3NQqHNa8ti7/B1oZF+jKHOA38mOho1FUXsoQO4+xHLFhJBY/fudCOs+QVnVKHRz2alRPytCW4oj74c+dUipdRAGttF6vTFLGEPqUIeHSuJRQvTcktRyoIU37STtiz61r/ZvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790300304; c=relaxed/simple;
	bh=3Hi3wvBYkqq4SVKSz4aS01dQeh/mwn9byX7+A7HmBUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BTCp+c2hTDga9V1v/r1ruIQrhzFrcfMeqbSXQ7B9+W+fQOo+AxjKq084gZtULcKfdl/WVRQtXk9M33Ys2UgnFaW+i3E8X5WMry1v1TPQqxcUZBos3/tNbpuCVMu1t1AUGA09Z5WOCjz6BfLITwZ9OIkyFzQK0Ijdpl8IOjkNiNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=IEWFtSjJ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=JzXLA8wb; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IEWFtSjJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JzXLA8wb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790300302; x=1821836302;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3Hi3wvBYkqq4SVKSz4aS01dQeh/mwn9byX7+A7HmBUY=;
  b=IEWFtSjJ+dgM97DIAfXQyBmJeKkVQF/mUcUHbxfIcvOpmtlefiBPugpY
   1ycE6NsAt5gHLDHj13JRx5RwnhHibdTvjla5OHjEdl1jmmbCSbzp3ES3g
   kXHATnuLb+A5L0wxu0vlcRwprFFQhb4rcJa/y6/kyxkvQyz4iS0MOw9/6
   wLXeWM1yCH92YEhfW6pcZO/IBySFxUf3KLdCA6KsoAeI+zlDiIDRXV9/i
   J03Kr6yel97VXM8LkAWiGWcraaP6wKAoCkotQEL/06cWD8ctf0Y50Kgm2
   JxEzxODymCiOvsfylgQfkJjMRwg08QDEj18IFR125AvrYrTY2HWH7r6Fb
   A==;
X-CSE-ConnectionGUID: hIrvzjbvRRelWPhZGlLNLA==
X-CSE-MsgGUID: FLAvA5RdQiyQKw9WQoej1g==
X-IronPort-AV: E=Sophos;i="6.27,121,1786982400"; 
   d="scan'208";a="152288760"
Received: from mail-westus2azon11010063.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.63])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Sep 2026 09:38:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z+PKjus7gj65BhfEW1L0L3WSaKJzngXwmm9JncdHapd+S3jFXgtnOwpi5rSdEommDpVZHPtXyjrVgJR9Hs3lrSmLGkxdrzrTeFouFW1Nramr67jddNB0KVeEsBUDumQ2hNf/rwYjkWzMfaKYWctcB2/A4GKPnvXlmR09KGSQoIHGx4hLfzIyYM8Hojvnp4VBVNudgGtiOZmcoMT4bUv5iBRhP/8+i6ouJQuYpkRWNTMARFvuVRavQQ//jh9z5mJu8lY/CTCid5lhR0Ae/N0yh/XxhZrpFLkfd/hv2SKjREZbTczFCXnXWXw2gVUpPPfMCa+GCzLJYQKuS6lUsziIaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z29ZGt88MmvnpuVDbbenw5UxUXo7DZB3zbx135wSWR4=;
 b=BIrd4SyjCADNhyK22g8GZZXyx3IEynxx3u/mTt/NZAulQZqjpYFD6JtEnMpIsn98RUyo23i4l63lkCSoryrYtpDFwPe2I/EocBTsaKoVo2Y3uPP1Zcey42mCjaUxDlBiSqFVeFBSCcvnico3FnSw9LBw8QpG+d+9/W2nSlMmp5epspzcd8NMWBMucaNqxxOQtOpg2HW0/An2MFkLrYC6Ez1fTnpPPvOMNvyFmz+iZMHLucaca8qUZ4xIeNAiE1zJnt1FhaBYa3cJB1Wdsa/aC5dBosfoio24NIh1vkXowC7ef/pEKGAXCZRtzDJROBcGx7KQy9G7pgQhdx7PjMrOlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z29ZGt88MmvnpuVDbbenw5UxUXo7DZB3zbx135wSWR4=;
 b=JzXLA8wbQZuq1Hj5OPQ81FEy6NdBAqOC5Cr2l3mxNbplTrfvYksr2wtfFHbS/tA3V6qSrd3t2bfs+SLxyP4Sz9PwaLKhgNe3jdyZu1tmc4LZPQLrd974+U4qmBpWH7hSD7Ig4/7uLkOfZc3+3e6oNkQ3LmWdJMC75tfJnGKBMhU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by BY5PR04MB6788.namprd04.prod.outlook.com
 (2603:10b6:a03:219::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 01:38:12 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 01:38:12 +0000
Date: Fri, 25 Sep 2026 10:38:07 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dgc@kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, John Garry <john.garry@linux.dev>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <arXPSS6ikVMDaI7w@shinmob>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <aqsN4GOXthkF8rOI@dread>
 <20260922002814.GK2705364@frogsfrogsfrogs>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922002814.GK2705364@frogsfrogsfrogs>
X-ClientProxiedBy: TYCP286CA0254.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:456::8) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|BY5PR04MB6788:EE_
X-MS-Office365-Filtering-Correlation-Id: e6d957a9-04f1-445f-4fd9-08df1aa5a986
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|23010399003|376014|1800799024|56012099006|10067099003|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TWrx6pK4fFt0BmX80P17IlSr2AqO+8HM/lnH4Q9nncTfH4ZyeqrrMAaeg1sD3LtrdMyXWqTzmgBDsAOxbuDI74QQbgMkEs7RH+tpyOCaYS0iHd0Xum8m0Zq2+y2K69VY4N4R4CRFmUTphdrFAu5syoeOvmLerWNnTqPA1AkOnGmsdYk7DLJNzsBxKnl9ECaK8iC4LXCbeeO0J3xIrYqTX2nG9Lc1VvedY/3euyXrjw688Kmlv7TuzaZjFEnfUjoUp4nkirtDDfjox6IzYWZ1jm/g8q28/yBxvhgPFdJ3EWXT/PTW3LiCZQ4emQM8Q6JlqNX75K2lJlTZvPzbu/6NCD5myzcnL+uyhCzv5OIucTk1LXikUpWRILNwAod0gHosSrZ5F7U+L6B49am0r3x3u2uLW8s/Il7CuwFE48P35xgDXZSSH4V7sVtjpANrZue6ShB1GB5mAus1pJ6tULtuMFRsZoo3B+uiAPAJMXeCcPjHxjjsB4z3OGHAdmmz7x8ei6xJGgW6Cu7kV4umWM+MDdsfkLEUWMBF1fXeo6aSXFvaNCtS35dvp0wEHiXzRjB6HPslNxZa3K09hsvwNE4LoM9S9wNOOYjvk+BzXw8ql/60iTmc7EdEUr102MZRBNN1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(23010399003)(376014)(1800799024)(56012099006)(10067099003)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VHHdzv7CPX/WZKSq8MrrCuY1KX3M+5eLzvcL0JNK2OPpHNBUU5sgotUfB9/e?=
 =?us-ascii?Q?YId+Mdteq6tjmsogP50a8Isqr5Ze37GNQdTk4sV+/QpX9c0Ie8GTYgwiwnfT?=
 =?us-ascii?Q?TIm9413ET/1hiWTxtP/j/SoeLO/0JNNJg+IyEyggUurILulZtmwswEwuhIqV?=
 =?us-ascii?Q?JEva+Vvwe6T1GXNwHePD7/hYTLDsGwNIvcwcYBP6hq6Ad2tU3cwBDGICc0kW?=
 =?us-ascii?Q?7DW0Un1+PPy5uun5x+gekGEYR/9sGctRfe+YPlOMSRaVCHxl5zTkW42nxF+F?=
 =?us-ascii?Q?Zf2q1zTs/fABQHnjNvPmQfyshGeQASMbO+s3P3gPBil18M+EbHhNwtdRvy4B?=
 =?us-ascii?Q?RWJD0QijWrURkm1gxVxgWiOVsfVAucAjTZrxOvhERZCU9VbNxTiKv5X+sKmI?=
 =?us-ascii?Q?Pm0+4ie/1VNIc67m6mmh1qs0tdoWIe/fBRnVGa5BiToz30+Oe6XiDfVJDHvH?=
 =?us-ascii?Q?haApdSvj6rotKSOdMYq81OJxr/s+3Ido9XL1L44Tl+LziToMUAJ7EFnzmV+C?=
 =?us-ascii?Q?TwTWVviamp61Lz/S0zyzHi/zQL6nl1lFmj2mibzKVnv1qPfMfYgNRjmVm8q4?=
 =?us-ascii?Q?8lffde7bYm4eyHftAblN7Ta4TTvyUangU4zo3AtCwEhtkJKGfyCIDKzm/P1/?=
 =?us-ascii?Q?6Our6EYDFY/mf2EsvttSYPAH8ebWgEVWntWxHFZNT4quv3c473VPue4i8Bo0?=
 =?us-ascii?Q?ZcsaqGhXqXVZZxuIoHNDPa8f9f12tPBCUjdjfIXrvjScid1V6VK6v3c5NtfJ?=
 =?us-ascii?Q?lGaG7HZHKwiNztV5F/qkuh5UMFx2yDIcXaUIWn5vE5IoBp5kcjQdnaZMHTT4?=
 =?us-ascii?Q?s9brAKbHvBUzJLeYOohklxxr3+/migtDCfF84MX3GNQT6Le5duTUATf0Tm3v?=
 =?us-ascii?Q?HXXaI/nm29CjJwPuFDUNKWZS5UC4mdP3WW1OtrX0iglGpezGMGy74inxmuZA?=
 =?us-ascii?Q?tLNSmPD9yGxLfAZFE01oNC8Y3rCVQpYG6HhjANJo3Ljy5dV3fOi+wiM1kvAx?=
 =?us-ascii?Q?aIJMnlndkMd1qF26z4hCcZBXGHJECm5jxpRnJNrQ7lxGYCkigj2ocK5n24bv?=
 =?us-ascii?Q?aM3uVl4nYQNP7QXMnYMmgTfDZZREKxlYHk37gAd4Y3UmjFK/roA0h/mL51cV?=
 =?us-ascii?Q?jbnkxxOvOtIoqfoYuk9MChCgBhRnJmXMOB7AoldaItEkUhH4/dE35dd6qnR/?=
 =?us-ascii?Q?RVOmczxcqkHiJJQRiZ/Qezu3X8lA/F5bewF9MP1sQ+qT1LK3d67PbFtorewN?=
 =?us-ascii?Q?qjpLLddV+UE49ihGKYsXkBVghAUBUpWPgUGrDCpLH4JsLYD33C68MZhycx4c?=
 =?us-ascii?Q?LFGKJE8+tUqeWVHP77xU3onb+L3Y3aLRAJOyf8IlM0O55osxiSKMfPXc53fa?=
 =?us-ascii?Q?qIdx8n7O+spFsgCN7rIzm/8hQ7CPtX/th7g/pIqSNC+fND8MxuwFvPYp+73c?=
 =?us-ascii?Q?KE1cMuW1TTNLonJhH6HHPpI7NQOBE5cG97CpxJo1x0sSZfmKTUObVA4hdTFI?=
 =?us-ascii?Q?9yP0Zbgo/2Qb4lugOB92C+HkDDxW9fybjkbftivnMTwxL62FE5x5spzgiGG4?=
 =?us-ascii?Q?gZklIlc0V/+R30lxHvlKuyywKWD8AP+3v9/+Se9+T8b0C6Dc3yBg5zrPYMiT?=
 =?us-ascii?Q?bV/Oms5qcDvNK0Ww/6VCARF7JWAnVgARgiY4mUFJQUuD/ceILt7uqfbyMSh3?=
 =?us-ascii?Q?40/8hW+Ea2nJ3ZIkO4MBOWAJ9JTqzSIf5IpzsT2sbALX1JAXr8kMM38Ly45Q?=
 =?us-ascii?Q?ZIf3O5yy31Xeb7G2Z91K04inSWJeXzg=3D?=
X-Exchange-RoutingPolicyChecked:
	KUE38XxmZTKyahLOh2KYvqDDXzfjfc3MvGm25lEygRG30F7sst+JjcE1uB98iiOSJ1AXoyiU/X1P3zyugs8NYANt2pTpgulkA5OxEBwwPX8ewt7mw5Ekffk911H18G+vyxBDUwqhulbcYxjN1Bse7S3/Vwwqtdh9BzAbQkIA8eybGfqj+p+oBFNAhZh56zuJWDHU8rWuYrUyfs92yY2g+ix40dbvTiQMYWdq6hCAMwgG2zpiPNY8EiKukcHfJynIpuRCezOnCNW/4Yo98CQEAT4MoufATxAsZmyqgaxDgjBMN2X/j0el6QA1Y+Iw/86qhyxplDEarQe3Z3RY0frMgw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WKJpwp8DRWwScXPu6Ki0U45rEY0TBVmjjDYwDzWSTKiCFin9ZY7N4ql4B+C/0iHec0l+jp0VybZd7RR7/gnvhMgZoFEoGI/kiK5ZgoueU5BNbUhZIxep/Gtn4bQvGItxzTVVBIaHvsbYg2DYL856PNhYQr4XXVdMh01FsUjg8M5MkFhFP/fGW+Uju7ydNG4NT5UBKATd8q0Vjq5EO/PMZBimswvmzt38t1JneaHVdGZU1i4YeQeLreLlz9b+NMlSm3E2Qn/hu6CfOshz+flmH8DN+w6VuD5SJrqPeQNW+Rz+Mci2Kb2t6CcNtRezIBnEEqMDRv6QN0T3LniGGcbVFtkfsPGEjilnzO3oVrt8xNA42FX3m2svEgsTwD7yFvEtWC4ToIUbpIkoVZPCtD0c6MTYSQCZHSp7kWGMEg0YrQiTdRNK/uYB2PVS3VGbyND9UIO3mY7V3W103DO5q3JHCXSGiExhOW4nml7h36t/WDXBx/hW7I0C3pizE3LNNHZclrLYMsfzWtl5mHBMEtDTI39rhGmAtenZUEeHfYC3X1sp4SIx7/xu3WZYHYJ9rm9lJPxz5lfaq+9JibDNVGMM0qTAHGorl+t3hEXRltCWW7A4BLNHfNa0/4hFyXBCsDdk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d957a9-04f1-445f-4fd9-08df1aa5a986
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 01:38:12.6622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k4/yDK2taOFEbJW2DxR2qhy65uTWs+wb40jNaT/XdtFV8naD5hIwY2rz/hAHTNvn/sYU2pD6UdXijoZu+dJfGQ4i+dtQV+zx5xIuRYjPiBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6788

On Sep 21, 2026 / 17:28, Darrick J. Wong wrote:
> On Thu, Sep 17, 2026 at 07:45:04AM +1000, Dave Chinner wrote:
[...]
> > A bunch of threads waiting on the ILOCK here:
> > 
> >  down_write_nested+0x1c0/0x1f0
> >  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> >  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> >  iomap_dio_complete+0x140/0xb20
> >  iomap_dio_complete_work+0x58/0x90
> >  process_one_work+0x947/0x1760
> > 
> > And the holder:
> > 
> >  schedule+0xe5/0x2e0
> >  xlog_grant_head_wait+0x175/0xac0 [xfs]
> >  xlog_grant_head_check+0x312/0x3f0 [xfs]
> >  xfs_log_regrant+0x380/0x7d0 [xfs]
> >  xfs_trans_roll+0x2d9/0x420 [xfs]
> >  xfs_defer_trans_roll+0x11e/0x4b0 [xfs]
> >  xfs_defer_finish_noroll+0x460/0xe70 [xfs]
> >  xfs_trans_commit+0xfc/0x180 [xfs]
> >  xfs_reflink_end_atomic_cow+0x3b2/0x560 [xfs]
> >  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> >  iomap_dio_complete+0x140/0xb20
> >  iomap_dio_complete_work+0x58/0x90
> >  process_one_work+0x947/0x1760
> > 
> > is waiting on log space whilst holding the ILOCK.
> > 
> > This looks to me like the test runs out of log space because of all
> > the IO completions holding transaction reservations waiting on the
> > ILOCK, whilst the ILOCK holder can't get enough log space to regrant
> > on transaction roll to continue the transaction.
> 
> Agreed.
> 
> Why are we calling xlog_grant_head_check from within
> xfs_reflink_end_atomic_cow?  I think the reason for doing that is
> because we've exhausted t_cnt in the ticket (i.e. we've already rolled
> more than tr_logcount times).
> 
> Oh.  tr_atomic_ioend.tr_logcount is 5 on a rmap+reflink filesystem,
> which it inherits from tr_itruncate.  However, tr_itruncate is only
> intended to remove two extents from a file, so it only needs 5 rolls.
> Coincidentally we calculate 5 rolls for each atomic extent remapping
> operation.
> 
> For atomic write ioends, what if we increased tr_logcount to 5x the
> number of remappings that would have to occur to finish the write?
> That would preallocate all the permanent reservation we'd need before we
> take the ILOCK, which avoids the situation of needing to obtain more log
> space while holding ILOCK.
> 
> The downside is that you'd have to limit the software awu_max even
> further, perhaps to 40% of the log size divided by
> (tr_logres*tr_logcount).  However, we'd still be able to handle
> concurrent atomic writes to different parts of the file, at least until
> fragmentation got bad.

Darrick, thanks for the idea. I wanted to try out the idea, so I cooled
the experimental patch below. Is this what you meant? It is a very rough
patch, and does not reflect the "limit the software awu_max even further"
part, it is just for experiment.

Anyway, I applied this patch on top of the kernel xfs/for-next branch git
hash 0ca15a1a1151, and repeated the test case g774. It did not hang after
100 times repeat, so it looks working.


From c90ec246b0b9e14097b0ad1d1ef5661261dd61db Mon Sep 17 00:00:00 2001
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Date: Thu, 24 Sep 2026 19:08:32 +0900
Subject: [PATCH] xfs: try out Darrick's idea for g774 hang

[experimental patch]

Darrick's idea from
https://lore.kernel.org/linux-xfs/20260922002814.GK2705364@frogsfrogsfrogs/

The deadlock of g774 caused by grant space while holding ILOCK. To avoid the
deadlock, allocate enough space before taking the ILOCK by increasing
tr_logcount. 5 rolls are required for each extent, then multiply tr_logcount
by 5.
---
 fs/xfs/xfs_reflink.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 48013613663..9d3da713a01 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1020,6 +1020,28 @@ xfs_reflink_end_cow(
 	return error;
 }
 
+/*
+ * Number of transaction rolls needed to remap a single extent during an atomic
+ * write ioend.
+ */
+#define XFS_ATOMIC_IOEND_ROLLS	5
+
+/*
+ * Compute the number of log operations to reserve for an atomic write ioend
+ * that remaps @blockcount blocks with a @logres byte reservation.
+ */
+STATIC int
+xfs_calc_atomic_write_ioend_logcount(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		blockcount,
+	unsigned int		logres)
+{
+	if (blockcount == 0 || logres == 0)
+		return M_RES(mp)->tr_atomic_ioend.tr_logcount;
+
+	return blockcount * XFS_ATOMIC_IOEND_ROLLS;
+}
+
 /*
  * Fully remap all of the file's data fork at once, which is the critical part
  * in achieving atomic behaviour.
@@ -1036,6 +1058,7 @@ xfs_reflink_end_atomic_cow(
 	xfs_fileoff_t			end_fsb;
 	int				error = 0;
 	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_trans_res		resv = M_RES(mp)->tr_atomic_ioend;
 	struct xfs_trans		*tp;
 	unsigned int			resblks;
 
@@ -1051,7 +1074,15 @@ xfs_reflink_end_atomic_cow(
 	resblks = (end_fsb - offset_fsb) *
 			XFS_NEXTENTADD_SPACE_RES(mp, 1, XFS_DATA_FORK);
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_atomic_ioend, resblks, 0,
+	/*
+	 * Reserve enough log operations to remap every block of this write
+	 * before we take ILOCK, so that no roll below has to wait for grant
+	 * space while holding ILOCK.
+	 */
+	resv.tr_logcount = xfs_calc_atomic_write_ioend_logcount(mp,
+			end_fsb - offset_fsb, resv.tr_logres);
+
+	error = xfs_trans_alloc(mp, &resv, resblks, 0,
 			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
-- 
2.55.0

