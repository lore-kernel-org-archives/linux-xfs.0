Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D1C2D7BF
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 01:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790299981; cv=fail; b=q7yp4Oqo20AuRsRcAEORpVBaPkC8QD/uK5j3iPhAtivVe7cpwuVHQCp7aI5M9ixp0W3+R3NyRddgSwgspMwpJ+ScVLYVwOqcGxH/lEyVG6OydOaMNngW43knYREupOrZCpF6Z2kPXiVv2xZ5WAG6jg5++8h3qjLko2eqBFZwbjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790299981; c=relaxed/simple;
	bh=nn6eZTzN1c6OYNUC1twsMloDimWXQxT4kZ+wIWLqscY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qj+hpmPiuCeDIGnCX67K5SLx/V5XS403YPPw+kS9veqsHX6oHHpBkv2ZogrIYb6OOrMF0txMR8p2tqi5EcPZRpKaSh3wVzhtaANUQ6R6pjTwkr/VeZdcXY+QmSFTaW0Jl7EyFwRcuxIT2rxC2PEd97sIbo4UwQ+S30p4DK3AVS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cJFatuiI; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=zWFcXcDs; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cJFatuiI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zWFcXcDs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790299979; x=1821835979;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nn6eZTzN1c6OYNUC1twsMloDimWXQxT4kZ+wIWLqscY=;
  b=cJFatuiI6XEr0FGFUMLwHrcTuQ9D79wCYwK2Dolrx2Fjzpieol1whrzb
   qV8PQwNs8MZ5k3QJ23wxXEpxwtJA00NsxWb9M5UJiOZq+IZc/6wG0+Lcs
   IKmrLGcSldWoU4NNv2qc/+VlY7E9E4ryxSJ0jC6/PpMd+ojvge9Qv7omV
   egH6RVmOlSnFKpvbya1P+cIwHxTxW1AxxWx+kbp5SM7KAwrQqIQyDdtJJ
   5ae783HVDIcxqQBqHuFanVHD38yVmvkVz3jCxuL3NZwxgMAQBz1aWONB6
   h2nzeGyDfHcRCFaIP4+1rCChLJrnKDNoRESXBKODwDeaAZtPxJQitu3OZ
   A==;
X-CSE-ConnectionGUID: vxCrMAueRtmvcaO2WHfFsw==
X-CSE-MsgGUID: yT02W27aT+GGwAXj6w8oXw==
X-IronPort-AV: E=Sophos;i="6.27,121,1786982400"; 
   d="scan'208";a="156337178"
Received: from mail-westus2azon11010061.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.61])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Sep 2026 09:32:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LDHRHlFQK3clI28cm7rVCbOdko9NOVmF0gUkuFuyGaB6knPm3/FgwuQ6axnsoQeTLABydNydaQM2pg8gtRsZdeXNTTcKoGIQfkvyQVW8fPd33AMSVoh5S1ExXp470LaDdU2DoAsmTqSLmFjd85KYygZcgwr9ujs3d0TK2VS3gysICzUQ+XiedtPflES0pi7T4UTjnOShy9fEVjbJ+WvnbxwiWsHUhyScdRz8iuqiYZibjgbM4AvOKHFsssW2k2igAv9UHNeE+b2hhDTmJiGpNGgAGxJcjWFAOcjD64MV4VE4ifkHRb5svxXy3jyMqaMD7ELz3YnrTlpwNl0qupdfxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODwDlb6c+Tf+fX8wynbG0umbYPPtdtlspgxqfUuVqbo=;
 b=hNaytSU1YmX7d4B359yBdPJBmTLvH9YNc/FEkp5tKa065u4e4eNnasNLpUKOr9QIGSH6TFbEjdx2JUAReQVjTfeejUeSyf0TVVz99iBKnDhR5Uv/kSLrCqfD5DoCgvGs88FdurEJ5KNvIacAWybFuz67SAwu4HaWmU5wNp/xiWsTl8e6HGOtG1tjs5pfPnrguucOmyLDTOWAGT88K4OuD6dXo2HxWPNgBdrfRSwCU7DAZcKO/2oXwQ7pmw6inLe7dOwC9/1KkZCD489Byx371CWgzXz9QJ34VFJH0m8a3m7X82UsLhxei3J8kmWk8hRebwgCluGkxzvCYAdf6pt4zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODwDlb6c+Tf+fX8wynbG0umbYPPtdtlspgxqfUuVqbo=;
 b=zWFcXcDs3C5sTvs2Db4HbBm+RZKWCX1Lw8YEc2+J5yynXJwvsGkQ3SDqx4ENROF2mRxwLShh80wD9kxDj4B8znOsItz4f6gUnJrh1FfyPOZ7p82kPRyMsaKvNE3HaHVo0KPiAp5pEPjumotpQtuAk5VG5bsg8eZKSOSCl6YWRZU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by CH5PR04MB9575.namprd04.prod.outlook.com
 (2603:10b6:610:215::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 01:32:51 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 01:32:51 +0000
Date: Fri, 25 Sep 2026 10:32:44 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Dave Chinner <dgc@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, John Garry <john.garry@linux.dev>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <arXOOv-OCEUs8xgQ@shinmob>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <aqsN4GOXthkF8rOI@dread>
 <aquJIL3Ztk3KBdHV@shinmob>
 <aqvER2bZyAO6H-4v@shinmob>
 <aqxag3TcgpYYVwTk@dread>
 <aq51WDjHLW3XyPR0@shinmob>
 <arGqH7adMMyhM1pi@dread>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arGqH7adMMyhM1pi@dread>
X-ClientProxiedBy: TY6P286CA0015.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:3b9::12) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|CH5PR04MB9575:EE_
X-MS-Office365-Filtering-Correlation-Id: 5db0efa7-b86f-4829-1c4a-08df1aa4e9e0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|23010399003|10067099003|56012099006|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	C0K9UN9HapvqZgn0HFTJ2iL5QTSL9vx0bwe7k4gXuhishyk4pRV1CByHb3AhE867mXvxrmJaoMytCiVlkomglebf2UiP0NLQl2MNi2yks0/apIZ7gD3eV156G1FsyA4OgaxmsynPGD/Qcl9wZSDh9BLakRFUP7MtBE9yBrt4JvAcLmA5g2reM7AFG/0E8ud4adHIQZ0433CdtNanpLSZgLA6WBxDD+6Oqs626wjwwWaQhSce0TttkhxxCD8BZI3CazMjOVqrvd4W32tTkuUf3aUQ8hRUVo0sI1tEnd4whcT4nB1MoSuObgH/K83+p+rLAoaEzeymX7EJaDR7ypl+KF74hycqVYFkmKXnayelmZoJD/PZqW/LKt4c2MDYxk9lLQHpbyDM9oD6G+jPUbFasILcs89bMjXqO7cvyphB168k5aOrmBF3xxukiuHY7kFl7aTxLdgGsaJsJ4RgflrJPY4LMDpjMH5i6V3jm2r506IZfnL8S1fJniPolB/b+LQ5IhkcPdnydY6zGjU3M5QFxWMap/1ou6Df4dqUJfY0q1I5KU6fcJo3r85NANiNMe4SbAN1/hdUDnefNrYF5P8mTjjB/Ye9rSbYzf47F+PbRfWW/GIW7SdLox09opUVUtoFwodP+kBjlSz0kptArg/xkEYjtCcHLKG+bvI1IETLMx0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(23010399003)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R/z2cXgik8iynnHeqj9qbBSz+8z86ywa/GisQHf2+3hRD8ZkgLAHzoAEj/W5?=
 =?us-ascii?Q?CZ1oLIH/5ENnyNoJqeBojXMtvLQKoL61txgJxxa5yRGlcDf/FyXa3n8HdBt0?=
 =?us-ascii?Q?9QfHeSq9sixjHUd5a9YXGFpKg6MOOhhWyHxkHPWfNRM99hiDK1ZaEvQhebSF?=
 =?us-ascii?Q?ccUZay3Nrr4DXn828eD0NMlHsS/DbP4NQy57xU4Fm5QDWWN+NsIuGkIaEGWC?=
 =?us-ascii?Q?/RMufUoqK54XxtcBBie10vi1K+C1oshJWzQY7FxAPIlnqu1dAIqTM0JggT8d?=
 =?us-ascii?Q?16STyToB2PSH+/a2dBHzhHTS4HM5b3rDQqO/LCC0OG3xei1IM6l4SrY5DHZj?=
 =?us-ascii?Q?3bvBPGmFhGzLzJUC3kXFDXqc4eiNjAYVdhG1oXGM8sIHJ0+Xlq5W932F/iyd?=
 =?us-ascii?Q?4epIBnM97/MBbtZvGhLe9uC1p7ZqIxnR8IH1H/akohVCexSwHmoUeMFdD9ur?=
 =?us-ascii?Q?5DPLPxn6mxYFaQ0h/aUXGUIWka4ZR3PppowK50niVfNkz23VC+CSBnbrm/7s?=
 =?us-ascii?Q?i3fivBdkTWs+UAKfrOvjuFjoP2RAFpTuqlaOkWCuvSHDYJITBNzN7pm6+qha?=
 =?us-ascii?Q?9OkBCT6GF8VXWeVOCdysiZeTz1Ku4x7GU/XJfWJnFeyR3Ljg/8w+OqYB8GJh?=
 =?us-ascii?Q?CaFwRZswRgcbOoAKWKOdFUEsjeahnlNVboPyHClcdBJO3fSGMUnfJisPSFd2?=
 =?us-ascii?Q?+CYYCFwDeVFifZz9n/gQsc6KbTs2V0JMszLbC/bMYs50dkURY4DCze2C26oG?=
 =?us-ascii?Q?REMIpOePF41nQ9oA6nIrdEnCS+fUry+xT9pMWtTwd4KGJ7TkMrhBIrg5+ajd?=
 =?us-ascii?Q?eIjlOemP3FnpUYAddDAmAi0/nz0kTdrFK9ql4Ue0+go4LD4LZ4FIeaRGkLq2?=
 =?us-ascii?Q?4bCcmTHWM9TbNKxf47YH6r61aAgh4tIQtnnrCLb6MMN0yf/uvJA0v1wkgc1C?=
 =?us-ascii?Q?Eb+FaJisLQl9csfGI3Z9+q0ht+aENPqowtAC4+qcvyJVgpxmTeC/vtx1Nf4O?=
 =?us-ascii?Q?FhE8kQ4A/HljaqtTRGs/oua0ZUp+0p8cVhamVaznxI8bvxdQTQdxLinKyx/h?=
 =?us-ascii?Q?LIYd3zZcxqTUbLNBzAglMBKtU8obMCwAQbSODqeez+11HmN2kCdcQ+Pnh8YR?=
 =?us-ascii?Q?Pk0h7izHduKpoMst4yR9zVh17+5PkqPfqUGtmxTFmZabn3Qx/UGJK939LWtr?=
 =?us-ascii?Q?lV+m/UNgjNoX4FH1qSMP3Rm9XxFric5xZblGas5N5XsmW+WlPEBtMHMhlXWv?=
 =?us-ascii?Q?2c5KEdgJXDo5fAxZntojopZT7XeruL1dI1XKeGay3C3adAaU5uRpaSQxZNAC?=
 =?us-ascii?Q?c19FJWjO0/5mdT5yGRL2+N5dFSjs1LrNgwIcbTdLcX48wFJYGkrh4R2vRTdg?=
 =?us-ascii?Q?AkhYqpssPUXtf+vhbs5afCIDmrNcUE9iLGIvTiueRvmNrwInVrClC6lCG91U?=
 =?us-ascii?Q?ix2lmKafmfRBOFGGTMUUh0LPgR8gm3+qXkqESlm0P0J9zfpys9xypwjvhp0T?=
 =?us-ascii?Q?uAff3KpcZyAF9kMgZKDu8hv7iDg16fIOGSPXfxrwq4m2alnwbQjraxsRfBUj?=
 =?us-ascii?Q?jz23Yu0gJTtcLEXo55guXcIgvMTa1d3DCh1U0RVYSHRzKCN4hxjhp7K2FTE3?=
 =?us-ascii?Q?Dgb10XfxBECi3W2cV1VNVYKLrhA2dA2fdAKk40rCgbAXlTC9vteNjecOZEF0?=
 =?us-ascii?Q?b6koH24EEUUeINhbcZezbAEYvPl4RoDv4ye9vvem60Cuw8EGyZaV5u4FXBKJ?=
 =?us-ascii?Q?YcCL9IaBH3QZCqndtDrbxXYDqVuYH4g=3D?=
X-Exchange-RoutingPolicyChecked:
	kLHfWKltYot0910+we3+5J16vjsEeXfbP1a6deecLpTn7aCoPuUyTZvnjD+djc8RbXTd+EG/WekGJnONK0XWq3PVJU1GTNBFPnNsWib4vM8gVV2bSy3wOQB8Yn5jEmD3GZR60lRK2MLpdRNQ9mPbjiCXbj/zbbwGlAnoK3If5fbvzJ/kogL829B8ZRgZsGKR1awpuoONdTTZuzWCDexlPPTKb+fX6IVXtYTgMCxP8W8JmJ6Fl3NVtRiG0kFb92sLie3ds6x0syJKOpAKVnWF4r5QeDogKbxUQRkZET19/6oAwLyFSziWye7y1uMDZJnmtqdgukB2AeT7GBWuPc0X9A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1hu0ubfrKTcb72plJPEv+Hl/el5juCmkvXutMtWeI2dJzUpQVyBDf2B9oaBXOsYfk7woBOWU3PjUXN9QGf3+4e4s9WlfRMN2PrysDofxuiS1hkdYaYyPtnuhUXkPCPAAQDqFBO4QCSv2epHFZjNsc6qNoErFolSLOAPfqFPixYJCv5bfQLiqjANu02ghS35VVDmpL/8zzsaU9suocnlNoVJ5n8nPY9q4MYCZzeilVomZIR4+M8XcfY71N6p3al1dv6zeRC71ZIlATass02+DSBjLfXNKaD/vEPvQxtV+bLSkDXxpVz7PNVuNkjTytNwdBj6XGGL9wK+8F6ll3lgtTWg3K8twtUfhw9wZGSBpb9mwuAz66ztPjwSHah0yCUUmxTISHGEoB/kbKEapTLaVvBrcylQxmL7/0d1UM3K1QP7yD4VjiBP5krnF45aAdGnVMkVDV2uJAZ/crQA0mRt5hu5K2z6LIc1Ra/M4BzL/zyG6ldBNdCQsetyqStEBG4Htl2YGaOtuyU4UdQ9xzuzRGKJ1ZWh+mWbNguMuNPOlXU14/WddwnSAuvDXPsPOW1o+42P5wMCvyu913jGTMxztOkfYhhZZoJImFeD3C1FsCjR47dW2Genqkzo0YOqajngT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db0efa7-b86f-4829-1c4a-08df1aa4e9e0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 01:32:51.2926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kH3Ui+/MFxlmooAPL1a7v/ZmW0B0Hz1bk00lTujMOkpooMNFXuLT6rp/b12/TFksxg+kYnz0DU6yocDp20DdE3Pry5cARR3wdm77Yse9cT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH5PR04MB9575

On Sep 22, 2026 / 08:05, Dave Chinner wrote:
> On Sat, Sep 19, 2026 at 08:53:39PM +0900, Shin'ichiro Kawasaki wrote:
[...]
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 426a67b813a..8d10ae22884 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -829,7 +829,7 @@ xfs_file_dio_write_atomic(
> >  	struct kiocb		*iocb,
> >  	struct iov_iter		*from)
> >  {
> > -	unsigned int		iolock = XFS_IOLOCK_SHARED;
> > +	unsigned int		iolock;
> >  	ssize_t			ret, ocount = iov_iter_count(from);
> >  	unsigned int		dio_flags = 0;
> >  	const struct iomap_ops	*dops;
> > @@ -844,6 +844,17 @@ xfs_file_dio_write_atomic(
> >  		dops = &xfs_direct_write_iomap_ops;
> >  
> >  retry:
> > +	/*
> > +	 * Concurrent atomic write COW submissions under ILOCK can run out
> > +	 * journal reservation resource and can deadlock with the IO
> > +	 * completions. To avoid the deadlock, serialize submissions of
> > +	 * atomic write COW by taking IOLOCK exclusively.
> > +	 */
> > +	if (dops == &xfs_atomic_write_cow_iomap_ops)
> > +		iolock = XFS_IOLOCK_EXCL;
> > +	else
> > +		iolock = XFS_IOLOCK_SHARED;
> > +
> >  	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
> >  	if (ret)
> >  		return ret;
> 
> Urk, that's pretty nasty.
> 
> > @@ -853,7 +864,8 @@ xfs_file_dio_write_atomic(
> >  		goto out_unlock;
> >  
> >  	/* Demote similar to xfs_file_dio_write_aligned() */
> > -	if (iolock == XFS_IOLOCK_EXCL) {
> > +	if (iolock == XFS_IOLOCK_EXCL &&
> > +	    dops != &xfs_atomic_write_cow_iomap_ops) {
> >  		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> >  		iolock = XFS_IOLOCK_SHARED;
> >  	}
> 
> And at this point, we now have several atomic write cow ops specific
> operations in this function (locking, the retry loop, etc).
> 
> This feels much more like there should be a separate function for
> the software cow path, and the fast path simply calls it on
> ENOPROTOOPT from the dio submission. That gets rid of all the
> conditionals and looping from the fast path. i.e
> 
> 	if (ocount > xfs_inode_buftarg(ip)->bt_awu_maxocount)
> 		return xfs_file_dio_write_atomic_cow();
> 
> 	/* do normal DIO write */
> 
> 	if (error == -ENOPROTOOPT)
> 		return xfs_file_dio_write_atomic_cow();
> 	return error;
> 
> 
> That essentially makes xfs_file_dio_write_atomic() and
> xfs_file_dio_write_aligned() the same code, except for the above two
> checks, hence they could easily be collapsed back into a common
> implementation is:
> 
> 	if ((iocb->ki_flags & IOCB_ATOMIC) &&
> 	    ocount > xfs_inode_buftarg(ip)->bt_awu_maxocount)
> 		return xfs_file_dio_write_atomic_cow();
> 
> 	/* do normal DIO write */
> 
> 	if (error == -ENOPROTOOPT)
> 		return xfs_file_dio_write_atomic_cow();
> 	return error;
> 
> That seems like a much more natural breakdown that the current
> duplication of the DIO write submission code...

Thanks for the comment. I'll try to factor out the duplication based
on your idea.

On the other hand, Darrick suggested antoher solution approach to allocate
enough space before taking ILOCK by increasing tr_logcount. I wonder which
way is the better: "allocate enough space" or "take exclusive IOLOCK". I'll
do some experiment for the "allocate enough space" approach before working
on the dupliaction clean up.
