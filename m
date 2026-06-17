Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4232F7EE9;
	Wed, 17 Jun 2026 01:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781660609; cv=fail; b=UgfbNExkvIhlvAAFHSFIKhgDJVSeeJiBFcxikSVg00/FNpyk/mNbHrg2P66AnzGMa8MBb4grkH6eqbzdS3eLjqe9t+sdKlga+PXsSz9E2DcAz7WtpDrhlGeReZqB7/U2yQxiY7sd6xrnlgPEmofR/RS5ffH+EICp7sNHpVSnabY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781660609; c=relaxed/simple;
	bh=12MW+ABdrlsWqaNRjwIc71vDrMeASQey4sv9znwAIYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GknMfvu7itKNr5d9AqaK8SNO8Q4if2mgeTghcbWEijt0MtRbbXkNfioaHNffxAEhIepy6+MdpSZh6acOalpprk4lnIqsiSXx3/jj+gJDhdoEahgb9nurpK3sBkdMnvfmVPhAtI0NWxKvwly9c00ktE/8CSCyZagtiF4A426pM34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bCLOvK5s; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FPT4TK6/; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bCLOvK5s";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FPT4TK6/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781660607; x=1813196607;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=12MW+ABdrlsWqaNRjwIc71vDrMeASQey4sv9znwAIYU=;
  b=bCLOvK5sVocoDEvD+zq26Kl7uSwYdHWs3KOxFfSAmCyQneomLp5UcWrW
   uEPkcCRKW0d+I9lkIqr0AFpc//fkfd2ilngIAAwrxh9NGqsVtG8v0bTR2
   ECiFcoVhvt7hsq+tR1Hwmgqkmp4HbRqesIHWJdQa9DfTYRWS5ljsRunHg
   cCoLGPWcD6BTj7eV8Oho9xso7kZ8cSr76SqBqXNuAbHWEhUYs+Gh7BScm
   shDq8mXtSkmqdtJYs+460vPpA0RH/TXs7jk5AbOPL3+TxlN5w8Fg0v2ef
   EuBCpR6xeh0ZQkWlC8kPcom/3OXp3xmXk2udz8YyWjIl7aBGkQvUh0J3F
   A==;
X-CSE-ConnectionGUID: rrhOc2vaRumOTbGrHEQkjA==
X-CSE-MsgGUID: gnPfB6lFS1+Fk072NqbpUg==
X-IronPort-AV: E=Sophos;i="6.24,208,1774281600"; 
   d="scan'208";a="149289730"
Received: from mail-northcentralusazon11012014.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.14])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jun 2026 09:43:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wF2TRRJvmirO7Iqdjbouo7xu6jrRCqW6pVz1bQu2PutZVuySzOkS1IR1gVK5oCiPSs7ewdtijiHk2r0sM5IU6MFlHlemyan7WTldx1Ez6jUgqPEaOJDBiSyptRWV9EC86XCEfYVh/afLznII7dAxqnew7jD7bIJo4fZlcrQsKcWjIOXX2aK9tYK6f6yGO9Rxvg45mvECeiSyk0LaMvxK8mHDJeVTuRPDpXp9JAqXUdIMbAu+Mu5ZnLTuXdjuYZszztfoxm0L8Oijv0M3wPBeYPZRGPnc+aDoBZXkVMxW16+/vWCOlmH8D5/b0eN+cXF2BU9J94+vGalxCWKKydGp7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8IHXuRz0sZzB/bnStZbKZahbxvA4twzVkLmG4xUVk0=;
 b=DhTEsGG0dfC7T7xq7IMdjmJy30TVk6BKT9hA8GKyhfz1wi1zIFNh0W3b5jQD+tBx/zMo5AE/a4VANUkwym2nHMrZEIu0HIgKzLPdo6WuJuN/0x76CwQhQFMuwbTRY6s5z0YyezAXQ1Ys2pCi8SPFPmm/VZMjyIXNDFgZvVsf+xyQoyLSwz974gwtrJMbME6rrQQurj+kAg16ancJN1LJ7MSuDlgchX3jQrVTPYnSnWFbJvM00+meRokfuyA/MftqwH4pCzMMdj79rv6r85K5LGYagTFNsnvetFmkjWoVB5UDoz5yyMi/nCE+ch8Kli5Lv9MnKrdzYMiWMUV/b5EQkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8IHXuRz0sZzB/bnStZbKZahbxvA4twzVkLmG4xUVk0=;
 b=FPT4TK6/99GA1X9U9p7+iFeklkMwQceD6CYpfOVd4b0fNJGGoxhJ29Rd6aGoNQD17/5PgN1JEgOlsIGPowJtm+oMiszr0aB3D+6bA2M2eaZJT11kIsL8hfh5wwLihG3MiH5rLeC8Vs9EyQLhlzi/oNf/8kn82ZlKZR9be+bevMc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by CH0PR04MB8163.namprd04.prod.outlook.com
 (2603:10b6:610:fc::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 01:43:16 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%6]) with mapi id 15.21.0113.015; Wed, 17 Jun 2026
 01:43:16 +0000
Date: Wed, 17 Jun 2026 10:43:10 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Eric Sandeen <sandeen@sandeen.net>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: mkfs.xfs "concurrency" change concerns
Message-ID: <ajH4WwBqd_uyqQNj@shinmob>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
 <ajAJ6lXJWcko4epj@infradead.org>
 <20260615154048.GW6095@frogsfrogsfrogs>
 <ajDeAYs79j4enacm@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajDeAYs79j4enacm@infradead.org>
X-ClientProxiedBy: TYCP286CA0274.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c9::10) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|CH0PR04MB8163:EE_
X-MS-Office365-Filtering-Correlation-Id: 0052d446-bd20-427b-991f-08decc11cd37
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|366016|23010399003|376014|18002099003|22082099003|4143699003|3023799007|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	uBSJUONlUG9JCgTqRlkukEydLXjh+BXh+Uk+RYcIpL+lXj4WOsQDIKu0s5Ax16H1e87/PFa872PD/nBorNth/ZbJYLGnBAMQrjtvcA1yt7aZLKW/09S+diTMeUmfbl7Zjtx4+AgOK6NPBY5OGHwgRIBfRvT8roQlxxxfYuRkww19YaUvugOPQCqcZsV0Pzp95G9n/QBQyjro2sG2xxYu8cSfIqKMOy2fgQTrWr4bpW5HELq8XF9mQ1Qf7IEvhG6a1IIHmrek5T+lJQQkBhqStYDbYtNgLf++DnkTuL51WE2P0K2A56rJMrD8noNC8LrF+xw8n4OJL1E5ULhjXB7NStVnr2l4uuU+u73fnl1YKtljQhJPZDPnGBc0v32e/qheQ211ipNGlCAuiWL5y+mNByQCSptNBRCJPI19CEKlxhvjPwyawN6KHkftyiCI/rYvsa3baNrdWZ1zIvQ/SrmcJZI2kpRUSVIEOCmhZF/5ZkZBjwO+a3gruyHxgeXhXE7bcoKDxxhIx0dya96u25PRGoQB0QBA6hdOEn9I6iQFuk9E4lYBbYcIfnUXQanEuTbsDX8YwRwfiC7eNxr2t0E+R06IQa9uQbg6cc09/z3zflIiwdp25sv+6uJwmg5YT4S5TrsH8yJ8fTvh/UJF/QQRMy4WYVCHIOXrKHPLhe0BYAVIZs1hhcoGMO3u3GauwOtT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(23010399003)(376014)(18002099003)(22082099003)(4143699003)(3023799007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s64/9FQ02Bm0k1frjlNgOf8l6/H8wkYMSofccrdexDUva3GxK0dASbyc7bgm?=
 =?us-ascii?Q?I5KB5+zv+djGR7kp0OzEJ7OWf6Xbn2YtoWakkgRH0DTL5Xj87zsk6lJdgfxu?=
 =?us-ascii?Q?CHEWukoF4F6HWDxTJDT3EEdtGn8ClrAKi4mDTOBiKUKWjBY5Rmg6hCakhUKK?=
 =?us-ascii?Q?Wg037mlf3b+pn06PUMdTj7cMC6o6Id+Lyyw9xWSFb6Tb1XPxD6aliqJxmrJU?=
 =?us-ascii?Q?ZwUuV8ATWSSvrm4M61oPXp/iX5Z1z5+UTcrK2JKn9TtTazn5+srPT9ll66r3?=
 =?us-ascii?Q?djOG/8W3IxFLGIQF3yt8cW3aRIAZfsuCA9w69t/kN8sOovvQWUVj79wQoEdo?=
 =?us-ascii?Q?8sPM1RPEswsEZg24BZskheSt30lSHsdYCwKZ1uZ0z3NljsZPRSXMjs44gB7v?=
 =?us-ascii?Q?p+SsfHbsp2Mie4ezR/OSXSLzCgTIHnj+NxdrTX4SoVB73LnIHvr5Q5I9z5QT?=
 =?us-ascii?Q?WhYlfRPUJPOzexHzB0j2e1ff2E/tvyQzdAX9yl8wj4zu/+ARHeimr8FIu2n+?=
 =?us-ascii?Q?eLV3k3Z8e/LTYDda/N5AIVARSVs9t5qIqbFD/tj8rJ7dotex+iv0aVBrM0Du?=
 =?us-ascii?Q?6rPDodRYC/ccce/t+sBnArxoqcqBXKrG+axjMOuDEVEQKXxfI+7Lki47ASd6?=
 =?us-ascii?Q?8CTZKWDSnqbbpWpEGiZTbIkZDubHU4dGxKHvMMDTzbZZ97KAujheWAtZ6pet?=
 =?us-ascii?Q?GTmpl7it1dE1DIkooYUqTYGFyBZc91xBcpvhfSiENtXB0a6H3J05ZqmsJ1lt?=
 =?us-ascii?Q?2eZ9Jsr89SYnl0wKXYY02p8GZaItwxBKHKbXmi+KVzdAT/fxMFYTeGzrxFuP?=
 =?us-ascii?Q?OwZCEIllXkRudatZ8rChG0Ipkkjk2YCz/L3fkfm8TJsohFOxShCNw2LazaeM?=
 =?us-ascii?Q?h+Ca1hRNlTURI1GmKXmNTafUHLpFwbu+Obt9ffXUkZSiDU+2urYUeXaJKGMJ?=
 =?us-ascii?Q?+jmOhnQ9GEx5Bs3vGiZTkvVnwt76Bm6heCdfhxnfVUZJfPE4EPvpgJzaY4X9?=
 =?us-ascii?Q?pMzw5gmt8H4gu0wungg4sGeQGNLF8Tt70ap/v3aqcyoYe7P7Q8L592R0VaN6?=
 =?us-ascii?Q?p6NcpKHOfdUrYA/FdwTgHLhBadOtlx4hSV+MJn552hl612tn2m5C8151QIHb?=
 =?us-ascii?Q?nqiXD4l6xwkD1oKPz8BrtfNR2cLjK2LUyuTTiAd45kV+bDydzHikOL/Fnqkb?=
 =?us-ascii?Q?Ssgnq4BMAIFRgLXj2mbr1P+o59XJALdQxaQ6CrWxQ33KM7VEKNEEmaPkoTCo?=
 =?us-ascii?Q?dPsdUYoe0sfLsH0ZUOn+OC0HqIOCAPdUi3jCuqPcKI3iqZmjum64XydKCPrD?=
 =?us-ascii?Q?bQl87cJCKFGWIg3CfJOkcpkN5tr2w5G2sUAnoQgTI7+sCy/Snz5bQTrcZeBK?=
 =?us-ascii?Q?wkI+IR6RXZRTF+FSr2cvBw/lhuPWxM+vGHya7/7kLEFTyUpXcuV++3gc/U20?=
 =?us-ascii?Q?4S5BcKhvr8aD8NdqYKldqQViKndkcHrtFdOpEX7jlrRVmS8TRVhbiFlXzBJg?=
 =?us-ascii?Q?uzyjZ7LD92zQ1q+hFvNHiwbj8tXWi25uMKzRvw3snarVS9LE/Amd2gvzr5Nr?=
 =?us-ascii?Q?9DIOy4lDPfNtyfpwNSoMvfuz5KChUeqEu9mo4Ke4odyyn5Lv7da0Rwwb5eqb?=
 =?us-ascii?Q?PTIW9PP1y3thwQlJvAZR1Zxs8HQrwHkc3Zh3sM/NoXhqgAUwXSd1ejRxMVBa?=
 =?us-ascii?Q?rbcmgzXSvIiTDs1JEiJCw1idd407xtsr12mlyyDExSl2c/zWAie7VHheyuZU?=
 =?us-ascii?Q?Ga3hALfwlrKUgA0YSn+6Qrx/Z0Jguqw=3D?=
X-Exchange-RoutingPolicyChecked:
	UYE29cl2kzqdQDOFkG7O5g9OM63O3iExyBtsFTbasp3IGxRcK9c5HztQBzi1JCyyNXSKjjAFrB+Lk8DcR2PZ6hiVMZF3Vd5mMoYqF1C7ZfQ04S68ZJU0M3wqXWBpVk8VXxElOyrlYwrH6yr9RoFJeWQbkRnYQ/G+UQyTBHjP+N03Z47vHzfVCyWAq+DzhouJsLW3Z0WRdUrBVHXHOeHitayxJbWH3GHWsb2KW4+LeSgIrTJysokvMjaUomQ6d6C8WTKXb4+JViKi4z9iL81YUvUBQtIc/9h96K1l5Hlv2HHI4KPW7zQFh++Nm67e7OqYdKATV+C2DZZQye+JoPUSgA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bf7AMjPQA5z3RpuDWG0OkxRb0buQSKW83+CstA3OFm1OMTolZY7v8+XS8fTo+HeMPKladkFE5S5NNNG/+v1Kkl7d85XuAD9087iMoEEyk2jYF+UwRK07HyUF/P3HGuqvQiuqHEYezFj+q7pVQ8vdLBd3pjmsKoZw/gs9SLZUhPauWh95cWyJD5dg0+s2yN9cRL0fYuB1RAyr6zLGxjb6OC2UYLeKJslyix/b5wZaRlnOxzuEWuSRLENBbnStr8Z36DEEdf7jhn24qx09SMDJLDNYgzlBjuygW4XLv2Hsi9tmdrKLD8MxydW4g7pO6ke/u/qSLSsDW6i04ppT4WqxoR/iBKB41NwCwvRdanXpuhJfuiV5b7Jof2XuX6jdc8YegLJuu+CrOY4X3phra9FijvjF8+HMwThTbUb3guuL9ketinWJKHt6yluBe17uoKPJVQl3jbkI5CO59KSY1sgmWwImJmzrezDwB5poSPtzMPIGUEw3uraDkodtgAPWJV+7DN9oRIeTSJfP/0ow0mIpin78jvZNvbfn7LlglYoA+wWUd2bnHLsHs+ylO8lpbyTKqwT0OxSDOP5iHXcv5QdHrtoxWQrYkaAwgWbFX+mx5zMJxtOSWelnDbHhjU/qLB8d
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0052d446-bd20-427b-991f-08decc11cd37
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 01:43:16.4593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ThkzksmxF88ktOanOKlI9URB5d60nbAQXYfZTSbaQ9gFPvi9k2Q2Cljq/Bbz4WpbnIymcaDDIrpCCbVF9flX9Y0TD8R3cJ68Yl5wtjbEuaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8163

On Jun 15, 2026 / 22:24, Christoph Hellwig wrote:
> On Mon, Jun 15, 2026 at 08:40:48AM -0700, Darrick J. Wong wrote:
> > Lukas Herbolt posted some fixes for a few of the fstests to inject
> > concurrency=0 into mkfs.  IIRC there weren't any changes for 078, but
> > you might ask him if he has more bugs to address.
> 
> Shin'ichiro, can you check if inserting concurrency=0 fixes xfs/078
> and xfs/216 for you?  (and IIRC xfs/217 which lingers in some reports).

I tried mkfs.xfs options "-d concurrency=0 -l concurrency=0 -r concurrency=0",
specifying all three options together, but it did not avoid the failures at
xfs/078 and xfs/216 in my test environments (I checked my recent test run
records, but did not find xfs/217 failure).

Just FYI, here's my command line logs. nullb0 and nullb1 are 8GiB memory backed
null_blk devices. I also tried each of "-d concurrency=0", "-l concurrency=0"
and "-r concurrency=0" seperately, and observed the same failures. I used the
kernel at xfs/for-next on Jun/12 and fstests tag v2026.05.17. The fstests
alraday has the commit by Lukas ffc8bad17e5b ("xfs/21{6,7} Use default -l
concurrency=0 on mkfs.xfs that supports it").


$ cat ./local.config
export TEST_DIR=/var/kts/test
export TEST_DEV="/dev/nullb0"
export KEEP_DMESG=yes
export FSTYP=xfs
export MKFS_OPTIONS="-d concurrency=0 -l concurrency=0 -r concurrency=0"
export SCRATCH_MNT=/var/kts/scratch
export SCRATCH_DEV="/dev/nullb1"
export FSX_AVOID=-a
$ sudo mkfs.xfs -f -d concurrency=0 -l concurrency=0 -r concurrency=0 /dev/nullb0
meta-data=/dev/nullb0            isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0
$ sudo ./check xfs/078 xfs/216
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 redsun71q 7.1.0-rc4-kts-xfs-g804826eac53+ #1 SMP PREEMPT_DYNAMIC Mon Jun 15 09:31:13 JST 2026
MKFS_OPTIONS  -- -f -d concurrency=0 -l concurrency=0 -r concurrency=0 /dev/nullb1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/nullb1 /var/kts/scratch

xfs/078            - output mismatch (see /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/078.out.bad)
    --- tests/xfs/078.out	2026-06-15 09:49:28.616774560 +0900
    +++ /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/078.out.bad	2026-06-17 10:19:09.364881845 +0900
    @@ -68,8 +68,8 @@
     wrote 4096/4096 bytes at offset 2684354560000
     *** mount loop filesystem
     *** grow loop filesystem
    -xfs_growfs --BlockSize=4096 --Blocks=268435456
    -data blocks changed from 268435456 to 655360001
    +xfs_growfs --BlockSize=4096 --Blocks=268435440
    +data blocks changed from 268435440 to 655360001
    ...
    (Run 'diff -u /home/shin/kts/kernel-test-suite/src/xfstests/tests/xfs/078.out /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/078.out.bad'  to see the entire diff)
xfs/216            - output mismatch (see /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/216.out.bad)
    --- tests/xfs/216.out	2026-06-15 09:49:28.794774318 +0900
    +++ /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/216.out.bad	2026-06-17 10:19:17.643595048 +0900
    @@ -7,4 +7,4 @@
     fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
     fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2
     fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
    -fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
    +fssize=256g log      =internal log           bsize=4096   blocks=32767, version=2
    ...
    (Run 'diff -u /home/shin/kts/kernel-test-suite/src/xfstests/tests/xfs/216.out /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/216.out.bad'  to see the entire diff)
Ran: xfs/078 xfs/216
Failures: xfs/078 xfs/216
Failed 2 of 2 tests
