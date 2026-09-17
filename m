Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96E73DD85C
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 10:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789641989; cv=fail; b=RX5uQf8Hdh17QiHmm71DaWEo+Knc0yRVrAJWw3t2xlt0UaMIGCAynjG8/i5lG6dNAW3RusNZQh4OHEZOQbjX3gnPyIa3ayPxS9l0yRfHcvdanFUhfDVruFa+VobdHyy2DECrXW2LB8oStD77t8rprXkNYrwiWdfGfK/i93eXEJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789641989; c=relaxed/simple;
	bh=xpSrMOFhLo7Vlrju+fvNKnaasf/sv49bhvddkjocr8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NX+9/I8EDknSrlfwvTH+BesZ0Ng/BhfXxcsHBAJolcgkKdiW7r3Z13v2vo1vNQO2okS8ETGeE7ets09E/grUC9lwmxA/IBkOZV0rabQNALoHgzPWCAksrzgrOgraw7r7T0JaL2L2QW9OwBscneCwlRbQB2W94M/3zKq1lZcLiYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=S+wx4JYS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=OsbSNrfa; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S+wx4JYS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OsbSNrfa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789641987; x=1821177987;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xpSrMOFhLo7Vlrju+fvNKnaasf/sv49bhvddkjocr8Y=;
  b=S+wx4JYS8YZ3NwkjvcUBirB4jPzPpPVmK2y9vwx9uIYQksO3/egMWg3+
   RNPJXGgL856nJzkcvG8ei6i4p/lgcpccbsq9iAb6ato7rei2KqJYCvFNC
   lLZhel8ptEUMdTVtvOCKc/H9nHiCM++D3YOqKERZAe4m2//mRxCUj8IEJ
   4vI36lP8XqI2vVap4UJa/AAkZ1r0mXcJ1e6W4EPzGDjyFxJDUmQS1M0ge
   /bV+WrfV8v7Yb1K47YRMQerlpcnUdzVpyA2/5PX0BTcT+wRS08p/3wtx8
   yl5WoPy3iCaNzsuOStBx8vUcJSp8D6Rmx2VCmG2DpWqT2a9SiHuBQKzgc
   Q==;
X-CSE-ConnectionGUID: tojASGo0TSCd6JNHr5bqlQ==
X-CSE-MsgGUID: 6PCl7oQSQY+inzi2UivbKA==
X-IronPort-AV: E=Sophos;i="6.27,103,1786982400"; 
   d="scan'208";a="154308085"
Received: from mail-southcentralusazon11013041.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.41])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Sep 2026 18:45:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vaQW6qhUXuD+lmkd/UmGvGJgH/hLYFmNkApL1NoiKeu+e7cdcdeEXlOFSDoXCpfJ7FwudER2TD8P5FOb6Dq+fFBmtiUylt8vd9KVie34xd1sWqpCwv8kqRQPabztgDOGrQ/USdBI2JwVc8HhdJkk3wapSrxePYJPSgkmKPACyZnLy+iaO3pX41pgCWt/R4YbwEfVVOxGW8ryrKjkGvX7Hucnmph35aIHEJwddah/Bxem4zRfO2WZrKX9RNrqk6eVMkSuAtntS8jtO5CDqPsktiq30j01PCF9WU1tstN2mxuAjP27RhC6nXlpv5Fcc+/8ca7vJHx055nDzdMItGrbtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/Iiws/SytRneyDvXcM/3OEEiZbeqbQLed8q0/Cylzg=;
 b=y4BvqCB634TRrRiC+DpadVO3/TuD/Jlsb2KSraHsOSuFnScvh8LwZsPARbQ3mN29K4VEgl3T9EMfY3XhJbQfSXiVvh/+rNTtwvmOKoc0MebcCmzOPOX1z9FW5zSXn6be84q53ewty5RxVfWnmU9rnp23YC6uGVyGoTdOg+m3jm1CBAbutRPuCtVZwDTHjGQu3UO0A/CQLPHlgdaI6CanRvObhV6I2Yi71wkRFxO1H81k/Fn8siQQHSsQTDa1lXlDjC5G1b7j69FV6H+/dkXkEk/L7Q6xTMKs9tcAbPe7tM9oqnWNjxm3HBG+AZa25HVGOyob2AArV2su+OKjLw9MzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/Iiws/SytRneyDvXcM/3OEEiZbeqbQLed8q0/Cylzg=;
 b=OsbSNrfacVq2cBQ8AOp78+nB3CmuEJR2LLhWOdWxRjUIng8/0P+KteblsX4xMdbu1j3R+6prWQNMQBTG4G1vgaxTUmNfpe8ywcMBScVsBEsn+l0opbrnIaue+akqCGmbpbDFLGLlrtcns27M9hRmMHCp/YS3XN2aplQr3tOEaVI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from DS3PR04MB10053.namprd04.prod.outlook.com (2603:10b6:8:38f::5)
 by DS3PR04MB10031.namprd04.prod.outlook.com (2603:10b6:8:38d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 10:45:17 +0000
Received: from DS3PR04MB10053.namprd04.prod.outlook.com
 ([fe80::faeb:7524:f842:9f3a]) by DS3PR04MB10053.namprd04.prod.outlook.com
 ([fe80::faeb:7524:f842:9f3a%4]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 10:45:17 +0000
Date: Thu, 17 Sep 2026 19:45:11 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Dave Chinner <dgc@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, John Garry <john.garry@linux.dev>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <aqvER2bZyAO6H-4v@shinmob>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <aqsN4GOXthkF8rOI@dread>
 <aquJIL3Ztk3KBdHV@shinmob>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aquJIL3Ztk3KBdHV@shinmob>
X-ClientProxiedBy: TY4PR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:372::7) To DS3PR04MB10053.namprd04.prod.outlook.com
 (2603:10b6:8:38f::5)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR04MB10053:EE_|DS3PR04MB10031:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eb0a496-8c36-4229-c2d1-08df14a8c331
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|19092799006|1800799024|366016|22082099003|18002099003|11063799006|4143699003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	LxqXTZ4S8Pn6HxEG+KDqg5Qs8TXfpLvrrp3U2MJvfle1Cjjk43dB9BiYptT+v34KMPtG2LPb75d7L+wRERQCTC4kEypLvRY8IehECnd/CQVjfGTi3vj+uYSVdsD8mWtwZAehi4MyfoB6Dz1d+jkpObgYJMBeNzHHUsUCcieNDdXdZxob68Zklnsf0hJG0KqpLewTX0Gxh+BgPrI6k1dKw78KDoYyFikm5SjDUFci51nQAztYvIRGt99rIQdu8de0fl9eWtVAua8Pv8pyfjfYJkYxLMsZaUn/Z4sdodWlmTrfoelYbJGVRnNea2n1ALbnPpvRWR7cOkJ11Zu+FcJrL1Rog2T586wBrR9o7v386Pdgqo/O6WMnCZq+HGz/npHZvLC8TvCGMQ0bO0LZjeRuarDPYCHgQwTUWvE7T1yRaJc1lUeNIuGDava5+VjGlRxQa9SfNC3Bb0ZFjHU6bGoGdKvduRG63znMJ6sEbqdUDvZAxR6uguc745WS+h71E6g30Xz38Q1+DWMLv4z16XCVL8DpG8+36iqjua4OFVa3NpfMdEe9tPlRoOLtx7KEIqUfTjgi3u85ZB2JucT73E4Yny8FVTHf/agAvI0qYMv7j9AA4bunQCMrqmSBcu3GFpxTEIm3hPQT/1ylrhjE/yo1oAux788upPK1ZxCZDNFjPxg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR04MB10053.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(19092799006)(1800799024)(366016)(22082099003)(18002099003)(11063799006)(4143699003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EXklktoNC9PEZr0dtpmor3D6uXi6Eh5qVuxsEVh3X7el4819kVTNSH6kGyZm?=
 =?us-ascii?Q?54Ypzdw6qWUlN96tnaL+E/xAEcg7oyn/LXUhThjhwiCJarxLTTOlVZPAvCIx?=
 =?us-ascii?Q?98hg/V2hxrGaCiB/kItv0TzlbxcCM2Q3/2wycinGLODo6ls4HFs5LGzvZcxl?=
 =?us-ascii?Q?JZP2V24MQ715slQQchq+YZ1kwPkV6LGIq2o1F7pbIybwMtSAt8Dwfj8R3C1I?=
 =?us-ascii?Q?UTxxNVt1ZfW7Bfd7z8NUGnaQEVSB/qFBazVq3f9yYobeIINrXJlbdlyMa7+e?=
 =?us-ascii?Q?wa2n2GQYCt9K6jWar3FZHvqa1Um6dEqKo39Si0dLfsue7OzfC+UDNAlQ3ua5?=
 =?us-ascii?Q?KB22EIhMwhOjgkfHVESpXjqm9OmV7eohi88nztndpa3cZxpQ1DpxDO7f59C4?=
 =?us-ascii?Q?DIQ59j4D1tjW23nIa79R9fkM4/kS+47X3QS/t4F9XLZIBM20zdP+5oQZLgq4?=
 =?us-ascii?Q?yTK1jKXlDcV42T2kj/C1K0k4gPdzCXYPw2roa+l+fATANWTJLTcC1CQRW9rd?=
 =?us-ascii?Q?ReIOKloZp+LjmGLmcL5QiqmTssa6Nk2M3Lod/fk/zxzC1VERq8V+MzxjoR27?=
 =?us-ascii?Q?dMfZjQmQlgOMd8xkYbnQkMWL4RxF73EIF0+NPEk73fNZhUKgOjCRmSDYwvyy?=
 =?us-ascii?Q?FfKard/N+oTi3nth4X8C2OctB3y2x1ECrGLa5sNfJ+Qx/OaVufPxVsNLxcBS?=
 =?us-ascii?Q?81qcePKph6MKH3jqZi3kRFSaFIEyEZxsOLQm4DJC5tl7kdi6iuwVixKOzSzH?=
 =?us-ascii?Q?Ei5aRTuk2SSAU8ffgm7uAhZkH8V0VEemMmza8iAWM7gbYtrrlOtLFKykSvSn?=
 =?us-ascii?Q?XWwaktxxhY7rfXHCAqdSSgThl+EQ44gWQ92kQtVxBr9G0098WaDQQEGSsc3S?=
 =?us-ascii?Q?if2r/rw9uBgV1x1Eetbblzt/KuTc5obaOj1nHMal6PtqSGqPCYc8ns/MZ97U?=
 =?us-ascii?Q?eWH3S2RQoA1GHqAumfx8N95JI5otd9Jji+0oNJlhELochxUloGU8wIcnYuri?=
 =?us-ascii?Q?k6xkwjXVdp/RXC5vOBuJsvY21zDSjp3sZ/+1DW9UVS6t52awScNoZnMVR8oA?=
 =?us-ascii?Q?dEbPQ0guwMnmxCUssBk78luSs8v2wHKDpNeoks+mEUCxHgXrPl+9smypiV0M?=
 =?us-ascii?Q?zcmTwSsqI0nf++F3c9uY6rRXASDJ1Qag9fak988WhSWjY3yCrkKC5FxFqOzx?=
 =?us-ascii?Q?nOFwuFjDobgIsX0ZPELaHgvdL9B4ctXuLGAzi8J1Jm+kjXXzfLIi5R9UHoc+?=
 =?us-ascii?Q?Zu7d0lpPoH54iDptqVSVwMT8MoQcwJBcfzc7BVvBzEnOgNLQkFUxcHxEyjoc?=
 =?us-ascii?Q?twLLyLQFaTXWss7iQSFHdZY8RudBDKMjSpxfLS0r/pUOcJkQkNIuN824tTs5?=
 =?us-ascii?Q?Ow0dkRPMlaVetD0x23MOb3T6BNAnDxXm+T5IxNAtDEijFQPpeF1ZVhmP6NNG?=
 =?us-ascii?Q?ad6CD+3S5ezFFck5QzA90HeVAPf5z0QKXSqSQ3DQtKwFsOPs2qgb+7xOO9uK?=
 =?us-ascii?Q?QqgSyBoGKkEisFvxOkf0MR/SaHhPZSAZ8ZaVoRwAnJA93A+JY9XStjP4/iA7?=
 =?us-ascii?Q?LCDd8nx6pnJ+YMlHj+u7ydwoDYEHYGX3FVNNINkNDdt4Z5AbusB/ckx0hAJf?=
 =?us-ascii?Q?U4ZYn9voy/BGQtKFUkcLWioii60fppDy3gAr1Sfy6b2otAnVMuthHAiwOiWs?=
 =?us-ascii?Q?M4u6LsPTrexg6SwwQsnnOORtRhwQCC/3UWRBCodkdfcd0ttPLpHBA52smwni?=
 =?us-ascii?Q?XLIx1iZcVUw7GQRmxgF2g9jhaj6Cryo=3D?=
X-Exchange-RoutingPolicyChecked:
	5VJyBMBrlmH7x8nPrNfRiSALf/qcquSoMQVBfnNL9r4q6euRVyiYhFWrVqVvVy7HijaUSu1LnQteMJvp9HajLcaubZamWbBXvTCtkeUZY5p9CQT1vWzQrN2rTwHT96X1CBh4QxI43fN9vn0oBMgyDZ/54kFroj8aGlrqZSFV7za31+3f6cFseHr670aV1yJd0kZDWD/8DEbSNtLlfAGOZWmPqfqjb3NxsSd1Kcqt9/Jut91KYmI5IxcD6vjN7PAMAV8Qu8TJ6vaXQsZPyqCAYGlGJSZKo1sfjx/JEvyUqLqIUieslGZ+ymp5mpD4GUG5NZGPf9Ob5EyCT+3L4HfOHA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1qIXzh8uGKwH+fWWNPoLV76LIXksh1bGhKA2JIYqZTUqBLlTQbkggYnsje8q90X15g+qBxwSRknzcRvreEO1PXbk+eZLm5MI7CViAoYdvQMLlLQRYXj7/cqahufjUmtCKQFoWWEK2mqU5MygVPrLaRDPHNIQ436Q07kwtFvwoq75EwKR9jVze+0yYhhBJJ8jgpNmkcr5N5xdBuv5hteyyLn4vhqtnfAcUc12uFwHeSFIwV+QTvAAea1E+eGpJV2/LI2uhIRXf5mziuNiUeAwupHfHwTSAuWrYu1DYOS14aXQMAHyLiAbtWz7htivCX4YfOMs3+Mhc+chOUe+BHnfqs1RMZ/+lNt7YNuvpAls8F7E5VojuY6Hw0zrHvoke1N4NOWwTRd54amNyaVBNjRYQfJiqNd3GxvWB5smQKlOQ5BLPoiMBBJ4vKuBhHTEDf+4W3Cj2iuybOkXJOqjz8oMGWragqUQ58Ut3zKa54CskirVwIuXcHxTqreF/+OWBMpUwx0Znqi2slEy8V0EejhqhYOzF33MFBdcevwJiikwLGoPvtzwQk0Jio9GQHf19WPzkPHX9BLeLRAaHaHA2QwnVHsGsO0YrV7eMTJXVQWjNYT7o3QkPvIjKEPuKZuyAC24
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb0a496-8c36-4229-c2d1-08df14a8c331
X-MS-Exchange-CrossTenant-AuthSource: DS3PR04MB10053.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 10:45:17.2870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1f491xeFyn0lNiJsnv0RRNfa+wmkWv5hOlvwsD1AA3FPnEBgPZdp4+rCI8Qn/g/MXHZembXMZY2ZzoUEEpJDLis5vLzyu/2NkqM89d1O4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR04MB10031

On Sep 17, 2026 / 15:52, Shin'ichiro Kawasaki wrote:
[...]
> As suggested, now I'm trying to increase the journal/log section size.
> I added the mkfs options below:
> 
>   MKFS_OPTIONS="-l size=128m"
> 
> With this, I repeated the test case 30 times, and did not observe the hang.
> It looks like the log section size increase avoids the hang. I will keep it on
> running to see if the hang is observed after 100 times run.

The test case did not hang all through the 100 times repeated runs. Then
expanding the log section from 64MiB to 128MiB avoided the hang.
