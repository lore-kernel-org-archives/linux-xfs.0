Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2984A3033F7
	for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2026 11:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789818838; cv=fail; b=GtNzCDkF6HG2i733E8i2yxz/vygR7UTi0c2KJDGXsxzryadPs6AeSlAYcDG1Afws3OpiEQZREaTJo+BT+iSUgxlBRzLQ5/QUubyMH/bCpXzV7mH3+JlPb3j86Zerkgezsi/1fPafneXSLkbgghae3VdJEDcM8qDCJaeDSKMohkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789818838; c=relaxed/simple;
	bh=ox0UwcnD8KMqk5NLWP3WtxpIZn+U0MMtKK3uZ4ay/LU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j2xZTxXrmddq9GqVFPHmT++u4CyziOkUb0mXZ3AyLaTLjUHZP318rn6Te6CESRhfVOrYwG0BTouB5A9PXfEGlJFNmGUB09U/R1ibla+PVmyF9f+JR/PlLjH3sNydHtVKFCsaETCSGl/z6BZlhwfMqwg1a6P6g85MWVgNSc/MIps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HByRi6zO; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=nILhxfMT; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HByRi6zO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nILhxfMT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789818836; x=1821354836;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ox0UwcnD8KMqk5NLWP3WtxpIZn+U0MMtKK3uZ4ay/LU=;
  b=HByRi6zOg+ErEId+ODWnj6piqCXi1e1qdp+zVF68oCsGDCe6j/hNpunO
   v/s40ypvWcHm3R6kL2MraN9ukYhJFiYzzrx4vLcpfsx+s75CiPq5vHCu2
   Oqd1y6MmrleE7kzqZ71kG4yl2eRyqIHSKJwBKME5kgml75S9EySaWfbZD
   F2SB4fw02LIgQA3bROa9KT6YTE6jx+vh0s1o0XIlgiyJ3KK7EL8o7btc/
   KcsGcgQSInkR82QjIOE/Q2Xj/sc5WlBZrOT3VlqqHUxpLLebYFomUjvtD
   HRw+Um3PfYlCp/oJKafv8leppdGC4VfMOO9VAuk48cinRn51LZOKiudS3
   A==;
X-CSE-ConnectionGUID: otmH6KGTTAWzAgHOOTawuw==
X-CSE-MsgGUID: Tx6rOpchRq6dsyG8K7+dxA==
X-IronPort-AV: E=Sophos;i="6.27,111,1786982400"; 
   d="scan'208";a="155101645"
Received: from mail-northcentralusazon11010018.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Sep 2026 19:53:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FuCMVVpv4232M2gaBkzk0pblqJKrAbR5iMUH92FoiZN/OkWnS4tFxSXstQ/k/+OSc9/6ZmhE1pWknl0RJaa3QSb28mQ70jJsbMct5YVH272rFRC450pSmqaMOUl4rKkkpETPLEdw/aG/CL5hRFKjgFP1c9dIgHTw6Vqz1GmVPJGzxEijuAf5AOp5dVohX8XRZ+ja9D3eY9iqkloAROHySM29MChAeJKIaU9Od8Qi0LVKAWeOT+pAOf+tBnn1Cymps3NbiDd1DHY+So17x5t8zHDep67wXnfv/t2Kox/XxgXN4VFx4Oh6F9bcjiyvUBxD1f6UmzzJuJhxYF9JrGboGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDr2uT3957AvTQ6nxiFntvZTBBK2is5cqku4yw4xHwQ=;
 b=H4t45Jg2cV6t/UY+azsMFwf99LEZ9fB/9Mda53uOjVrRpwduySsHk1KFlKDMV1eJ0BxY6ZnFGYaxHtCYrmGt3zDyh2sCN6St+HHQmp6Z8Hp7vuXF64fSZfDWoFwjkDJB77GIMXM6X9SUAz3eG0qndhxdF1lSm/jra8ev22WFwTBpdkUZQ4S80gkzpG1VA76D/BPJgrVLZ3ehIkwSVb+IuL1UdFOvq/agYT+omzctd/ggR7CdPFlgufgtbuSJqI3X8tjZS3K8mgiwp9BbSRORifq0L+2jXEQdL6f6xCr3dOKDyHZ0X4J4V9rINQk5ftY2ziCvykbwGcF9wu+SlKgk9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDr2uT3957AvTQ6nxiFntvZTBBK2is5cqku4yw4xHwQ=;
 b=nILhxfMTQ7Yi6aIz8BtGC7xb2KvtDRZ6HZ+uu/am3DL7wvwspDMQ7nAQJ+xLNTJXY5N6IZri5hdkiOCzCAhgjI1TOqKBwTuuifwcU+sLxex5D6PY72o8UbZyQomrsEIPs/jy12hmip3c2bIayu7fIMoKWJWDp/fbiiyhdjEMeyI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by BL3PR04MB8186.namprd04.prod.outlook.com
 (2603:10b6:208:349::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.14; Sat, 19 Sep
 2026 11:53:46 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%5]) with mapi id 15.21.0428.011; Sat, 19 Sep 2026
 11:53:46 +0000
Date: Sat, 19 Sep 2026 20:53:39 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Dave Chinner <dgc@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, John Garry <john.garry@linux.dev>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <aq51WDjHLW3XyPR0@shinmob>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <aqsN4GOXthkF8rOI@dread>
 <aquJIL3Ztk3KBdHV@shinmob>
 <aqvER2bZyAO6H-4v@shinmob>
 <aqxag3TcgpYYVwTk@dread>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqxag3TcgpYYVwTk@dread>
X-ClientProxiedBy: TYCP301CA0025.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:381::12) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|BL3PR04MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: 950a81a6-ae2a-4c34-3ae2-08df1644a8f4
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|376014|23010399003|366016|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GJ4bFaQfprT6FIAd4NNJeYw4YsmNOKxnB4SizmtL9Vrn7Qps6YUGZt0DLVuk3LnNAiCeQLqKrYqJsw9jZhPUWByxenCEHMgNW3q+OxZ5MKvMakjbmmhkARg8gB95ubnSmjD4WgQo73xYn7hkyz7LvOKaeqR7gBqlpSgOs1pcV6Vhh24FzO2VDjZ1n0pi+ILBk2/o9w4wsBJQRFsTf0JTzk2WA0aH3NwtoVk6liKvRVANM6W4Mmicw+5NDjyg7kNxOPXHg4F0X+fl0d47oZgZXjG5iXi/wLD91tH9MPRnINg1wEtH6qaVrm6Ow0V/rDzpr+l75WkxGC71vBwya8szEPgOLoQgCq8OwimfdbzQ+uHYBcL9YwgCBUJMvdGS8mwWDDWvrKplCWjQTGpeEEFsG4KFt671YIJStVC0LKQdNVdVry7JcK5QIOG4pI4xmQwNZXLm0SODESTDLHrBj/r927ePnjX2D52SZ963xOS0igXBPbLH6le06cohEFDndZqHcJagvspeDJ0DuYs9ufgIuUgG7mTJtHNI4J+ZvF5c/vEbPEw3uyuliz6v6xyXLXgcC6c5OA/yBqVGUjozAdsQ8P4fjYBnvarWZcOxGIw78FFIvZcn43cKHc8/uITG02ZmTtb+zu/rFZruemDUX7r2BDSix/PSJu40MpdxpZiijmw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(23010399003)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OacMkYeIQS+Zxr+gi5QzyVLMTqZSi3DnorSrHaCv1CO6lZp+OS2p9ZI913Y2?=
 =?us-ascii?Q?ydGp1GPDuZgaT17rvRIav8NCoW6qqKBnUFrfIfzY14jomJzyGH5PIeCjz7S+?=
 =?us-ascii?Q?/ecFB6tb0tgMMgzEqmXrl5eRj+C+uCTErITnNjDL1kA3ukc2mFwdm91Q+Vp4?=
 =?us-ascii?Q?TDpKJcHAG+6sxpVWIbvRUf2fxOVLp5Ntpk9CLZxC41vUUR4GpNnGvNBLmbII?=
 =?us-ascii?Q?ywpgCDK72rE70RED127XcEa17XygH6TZXkCFsCWBxSqAhuDSnhXWML/vIEyC?=
 =?us-ascii?Q?K4QqxE7b/fv/V4XCM7iqhxYtudVy7+DDERY0wEyF5nu4xM85Io+Wd5WIVCI1?=
 =?us-ascii?Q?ah1IdvQ7VOpHqKiG0M1zuX4Q5P8nzXeh7V3LZZ6OZQAc9rx1er+x7YpqO+EA?=
 =?us-ascii?Q?RqZ5OyyR/ak+K3RAjcROrgTGtP5EfPuYODwP6O5/tzynUS7gi0Cv+g2o+ooz?=
 =?us-ascii?Q?dpXXgAb6S8gdmY3fOMhIK7gPMboJdryqmhbq+V215VR0kRk+FeTAy8FrRGRs?=
 =?us-ascii?Q?p+JJhPyK72/Be0Lgr/rxnGUgCmL50aTtEUJQsf8Wi/kli+qktsMrz9BTNIRU?=
 =?us-ascii?Q?/ODHpll4Y4+CeV5H7z4Ea43XcZ0fZ90C8oW5z+F3z4x15b9clMIFNxAZReZa?=
 =?us-ascii?Q?b6GuBexBCqnudkSwlln8XkcQ280MXVhZp4fDidfy0c9aOar7HOXwudvzkGAD?=
 =?us-ascii?Q?jLlCZPSJf8c0GME9rfluZXhP5kvwFTrc9PGRiqvEseYy1yr7ODiKpN+sAtkF?=
 =?us-ascii?Q?ZsnqezlvIp+xlZQ4GX0Uy07d6cCYxTHhRm3iRvYkNROFX621amis5mWYVbw8?=
 =?us-ascii?Q?CKibFbccbP378UFp+HlK2pPoW9RS9ewRid8rJ6Yweg5/pd+MuoilBLsWe2et?=
 =?us-ascii?Q?lUjDsMizm1EkMrKxd0uiJgA+BTi/fu8XqWakLNjbRKXtRaPwn5sJ0v5x1Prt?=
 =?us-ascii?Q?hmh/E/kFprwqZpHnfrNAMW2Dis9q3PevpPrphC7atrjsAb6mbcOcDc5bPs0b?=
 =?us-ascii?Q?p3Nz26S0Advw+VUWP1VtPNHAv8/f3Qe/3z849VQzBJhFNIWJYHJeDLsgntH6?=
 =?us-ascii?Q?uTgx0Xx4gkF2DRJ+NYhkHy+9WPuGENwAZ/EXWqEB1yaj+EdGNDYZmN5W0ub1?=
 =?us-ascii?Q?8JRa+MZyJFb/as3ZUUEi5gAcLh9WInWLtrUy1qFQYR3RX+z+JDlcX3LJCg+Q?=
 =?us-ascii?Q?0hYGhUnTmr1ClEKFVr697YPtz9mevtMweOLxaBmuxmcuAEqmm6wOYCHmDNOt?=
 =?us-ascii?Q?Q/H/E0tVbX1A8zi6vi920DE3z3EmYSJwla2SOr+NxmBUWg5tJEKre/3DJ6cO?=
 =?us-ascii?Q?oVGwtjc/DdqFbRVPjsU9nW6/Ini+oxnvDCzQw2pQ2YmIWWVPkdt3IviQCjul?=
 =?us-ascii?Q?i8uwrXvgzSx8DjHCvYa7+Nldsv+lmAOJCl/xDIILEQxRzZjXygiwmmvtfACY?=
 =?us-ascii?Q?+pb4xEis8yRYdPAmIoHw3ykGbysA06KLZ0C58bVkj0AIhyGB1E/5KpMW3spQ?=
 =?us-ascii?Q?corTBIT/aqZdbZTFxAUrSPAxYBSE63S70heGarUwM4zDd0s3GNJEv5/H5WrO?=
 =?us-ascii?Q?jgrPt+2EmZKkI6ef7n1JJn0BvipJkcwmZKrbF41fydUYguOjSfG089F8v/vu?=
 =?us-ascii?Q?ppBbLpSbKt2hr8hGWuVWLHQuM+MuYEo1lNLlK5SZalOCnjp38ts4tX3eQltN?=
 =?us-ascii?Q?xLZieQxGCdD5brLtmHNgWvb2fNWUR9H+zGXD4W+sQdTcahgfiuxegwgoXA3e?=
 =?us-ascii?Q?463lDS9lgyz65rfWDInrWtPq/EiM3BY=3D?=
X-Exchange-RoutingPolicyChecked:
	IhlNsXAIBQ3CxdRxUh2HV53ap9Wsj1Ma9r7zpoiJcnoI82XQpEzD/cOhKFfMoybig3HqTCjUGqTpgtCxKzVFqUPFbL5r09ya5YSFOc+eBLQT3hh17ZiZyFzmAhu/ynH2iqOzTS+ahCV4ju7/O8wB7Uk8sPH6iVr+cFueHBjFTBG01uT1WhObw2sDJQwVu99qUTT7WOmcWU/GNpmrdI2zjr1UoNFwqrVkwWFmcK67Ax9nfAiIEOU4WNU8HEu0pn2Ijzm9WQNbjTfrk26qUokDRB3uA4xxUi5EOEUeNrjDbJiZ1xiLao1nt3oa8tV5mkfbmrNtluTK1vArJjC99htM+A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pJJCsfW+3pfkqOtj2+tYhBQofMv9NCF3EgbAXeXsIHLPj5qfQizKJWm7qyNcZAUTnx0/+tqOXQcXalViDamDnE77JdzPQfQulhuO6BZujQUNQdMmHU59GDf/dJI2wYcOiENYgyz1ux6OmZFRR8Vioq1Yf5TBK6Udt6PGevN7Tt0KZD+TBnfR5V4l2tOOxMzh4+4f0E0GwXXkT2I9YSKY19m8Ly8A1Po7FXqCJEdS8UVxekT+u4ZbORgYC5x3Lc9GA594/7LVYuPZA9rgKmS/wGfux4BymRRx6fuGyo0uRN3xCKhek6XkFija1vSJwZj1pRNalEUaVXKUNA+Zzp21JJE1sbraGpUARFM0wF0be0UDYl3DFxpa/VLlqlmgKiL/By33n34/t3BGpiRbkZYPR9VYCnoasudnBJdFox5Kuslm3SvZDwITEF3yhNv+xKbXUqbZAVokKLDvKNerQR1rLt6RrtAf4tdLbTU+5CnTogp2dXUpmZtqqyqKd/fa+86SZkFA+zo868PQepuvMb6pSJ6H8RoQAvF7qrQDfo96eHOn/rj8lSUTRFI0+WcArAol1DAT1nvOnoyrW2UO/164tsiwJsnJ3ZFRy3dZZ8eItVb7eBWoYaqnezy+1lr4OSWW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 950a81a6-ae2a-4c34-3ae2-08df1644a8f4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 11:53:46.2019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/sY2V1fHJoUDg8udg+VBw64Is3Dks8apMmCQ2/PwD70b9PN0tzqisJm/bBfz2hCQMeb1pEWoyu1VBRh5+XVLpgrn2jp33KaXUCqobgHA0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8186

On Sep 18, 2026 / 07:24, Dave Chinner wrote:
> On Thu, Sep 17, 2026 at 07:45:11PM +0900, Shin'ichiro Kawasaki wrote:
> > On Sep 17, 2026 / 15:52, Shin'ichiro Kawasaki wrote:
> > [...]
> > > As suggested, now I'm trying to increase the journal/log section size.
> > > I added the mkfs options below:
> > > 
> > >   MKFS_OPTIONS="-l size=128m"
> > > 
> > > With this, I repeated the test case 30 times, and did not observe the hang.
> > > It looks like the log section size increase avoids the hang. I will keep it on
> > > running to see if the hang is observed after 100 times run.
> > 
> > The test case did not hang all through the 100 times repeated runs. Then
> > expanding the log section from 64MiB to 128MiB avoided the hang.
> 
> Ok, so the fix for the moment is to make the software COW path for
> atomic writes use IOLOCK_EXCL, rather than IOLOCK_SHARED. That will
> result in all the IO submission blocking on the IOLOCK with no other
> resources held rather than blocking on the ILOCK whilst holding an
> unreleasable transaction reservation.

Thanks for the explanation and the fix suggestion. Based on the suggestion,
I cooked a fix trial patch below [4]. I applied this patch on top of
the xfs-linux/for-next branch kernel at the git hash 0ca15a1a115. I repeated
the test case generic/774 100 times on the kernel, and observed no hang.
Looks working good. I will do further testing to confirm no regression.
Meanwhile, comments on the patch will be appreciated.


[4] fix trial patch

-----------------------------------------------------------------------------

From 2d2cbd8e3424953880f6ffc8e2ed5b4f844b0822 Mon Sep 17 00:00:00 2001
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Date: Fri, 18 Sep 2026 00:00:00 +0900
Subject: [PATCH] xfs: serialise software COW atomic write submission on the
 IOLOCK

When fstests generic/774 is repeated on a 8GiB device with a 64MiB
journal size, the test case hangs. Dozens of IO completion workers are
blocked on the ILOCK in xfs_reflink_end_atomic_cow():

  down_write_nested+0x1c0/0x1f0
  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
  iomap_dio_complete+0x140/0xb20
  iomap_dio_complete_work+0x58/0x90
  process_one_work+0x947/0x1760

while the ILOCK holder is waiting for journal space:

  xlog_grant_head_wait+0x175/0xac0 [xfs]
  xlog_grant_head_check+0x312/0x3f0 [xfs]
  xfs_log_regrant+0x380/0x7d0 [xfs]
  xfs_trans_roll+0x2d9/0x420 [xfs]
  xfs_defer_trans_roll+0x11e/0x4b0 [xfs]
  xfs_defer_finish_noroll+0x460/0xe70 [xfs]
  xfs_trans_commit+0xfc/0x180 [xfs]
  xfs_reflink_end_atomic_cow+0x3b2/0x560 [xfs]
  xfs_dio_write_end_io+0x4b7/0x650 [xfs]

Each atomic write software COW submitter allocates around 1.6MiB of
journal resource under ILOCK. When a few dozen of atomic writes are
submitted, it is enough to run out of the 64MiB journal size. This
caused the deadlock between ILOCK and the journal resource.

To avoid the deadlock, take the IOLOCK exclusively at the atomic write
software COW submission. This serializes the submission in the IO path,
so concurrent atomic writes block on the IOLOCK holding no other
resources.

Fixes: 9baeac3ab1f8 ("xfs: add xfs_file_dio_write_atomic()")
Closes: https://lore.kernel.org/linux-xfs/aqkP9CTUvlC2YCIb@shinmob/
Suggested-by: Dave Chinner <dgc@kernel.org>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 fs/xfs/xfs_file.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 426a67b813a..8d10ae22884 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -829,7 +829,7 @@ xfs_file_dio_write_atomic(
 	struct kiocb		*iocb,
 	struct iov_iter		*from)
 {
-	unsigned int		iolock = XFS_IOLOCK_SHARED;
+	unsigned int		iolock;
 	ssize_t			ret, ocount = iov_iter_count(from);
 	unsigned int		dio_flags = 0;
 	const struct iomap_ops	*dops;
@@ -844,6 +844,17 @@ xfs_file_dio_write_atomic(
 		dops = &xfs_direct_write_iomap_ops;
 
 retry:
+	/*
+	 * Concurrent atomic write COW submissions under ILOCK can run out
+	 * journal reservation resource and can deadlock with the IO
+	 * completions. To avoid the deadlock, serialize submissions of
+	 * atomic write COW by taking IOLOCK exclusively.
+	 */
+	if (dops == &xfs_atomic_write_cow_iomap_ops)
+		iolock = XFS_IOLOCK_EXCL;
+	else
+		iolock = XFS_IOLOCK_SHARED;
+
 	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
@@ -853,7 +864,8 @@ xfs_file_dio_write_atomic(
 		goto out_unlock;
 
 	/* Demote similar to xfs_file_dio_write_aligned() */
-	if (iolock == XFS_IOLOCK_EXCL) {
+	if (iolock == XFS_IOLOCK_EXCL &&
+	    dops != &xfs_atomic_write_cow_iomap_ops) {
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		iolock = XFS_IOLOCK_SHARED;
 	}
-- 
2.55.0

