Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010054.outbound.protection.outlook.com [52.101.56.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443FC22A7E9;
	Fri, 20 Feb 2026 19:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771614115; cv=fail; b=GGCIA7GVwv8DwnpfGPYx9mp7Yp0RCbFABA0/zV6qrocEFxK4KNA/IA1IGl3C0UX0VWcpW1eHq8l4+XnJP2m1ReiPC68rfcf+4ITR1uqU0XCIB8mdw5B5b/aLFXksE8qWmepAwY6gAFfPrmG3kGjheIVtXhFgm/b3Q1a2DnrQxhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771614115; c=relaxed/simple;
	bh=6xdC7gsUhljZ2A1OAxyWNUq9yhHS1dl8pibq0pRQDNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CEQpMEwkHD9wURLT3TAbT2gN/PKWNnd2imOIrtP3/0kEveHtQQB/BFETGUAspBFuTiGHCeoCt2oGzquLCD2GHJsHtf9CljPWVYt+y8Ls2YTy/aSkiK3eGivNAUae5PTU2t6AaKoXKyRcBC0NMQWXTRALgC0aSw5Q8eBNPktor34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=frZxMOe3; arc=fail smtp.client-ip=52.101.56.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="frZxMOe3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c6iJsbOrSPi7da6xs2SsAMUQ9ogDRALjiM8ZHPDREMsqSpDa9UnR78/NOzAuiv0S2uxCu+Ac499tbkuBQY9Q94KLdzpz1PyHQx9rwrTlASQbG5s3W3M1v1UbYUwfzRmD83nokihbA0ARTcPYnjMn8vY/z9O1hteTpi7Zgq/cjHzlvIrdCiy4Gjnx/LXwbFvMsNTUAkXHL+Q16XYBENaWz01iz4+GdKAyZEj5mtq1Gmdn9zdLWzO/ro5sBWPf+f+GbX0BRXKYQgdb5Rj+XtMXXbUNZ08KmPtFvmopeCP7mRHervXX4VcccjEdCIh43HwMLUguvjXTlZi2CUbubHMTMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Rreux8E7mNc4HPszf6KeTWQ+ouRkjWSaXvSXLUkA64=;
 b=Qp2Vuk6fyZVzmRgODs+8OZJbOqezWTolCzlFSVYZznHo4uiZFanMi+6vmfNaMD7SHefGofh2/1CDll8wyG8HlyDmECBYDySHqn3tgy2bLP/RIOkDTDnOqryy78XM/e4BKqVkZnjWtc2rVxJKSFb6+lCLsZqT9+aWAKsKDCRKyRLKGK1X6QOcQpmCiY7hesgoFBocd/7F69nVhqGfl6Dtf/FJ7n8RvzrdVBxBhhW37f+KsKN+zB+IbYtBqwi0E0WgzoYGeykl9F5U0bE2GvqecRc591d6Wi14AdYqDH8ovNIwrKKawruwLTuA+u+gTrNKCj3XVY7CkcI/i1iHm58A6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Rreux8E7mNc4HPszf6KeTWQ+ouRkjWSaXvSXLUkA64=;
 b=frZxMOe3Yiemz3l/y2uiHvs9HFyGSe9Sw24ClfRrWTPmtF2Lym15Ou4YMwzmuOMoC9aSruk7OSW85MZAQV7esxKeRDawY9zWV7rYdxoYC5+J/TMS0wwf5TaZ1Qq0+/uW9N1YwNrf0LfghP2yqTCluN/rcgB8QzsEgU62ZKH48WafXuMRyVw3Sq4G1aPS3mMD+rNSg9gVWbaeCM6PHaXMbP/cfGjy6dbGiJTLchu47FHspe0ttWFEHIbMBo924qXWKrY2VI/lFb2H04URs5nA4C1wDq6A7dE04ULVp1OSGad7EfHEolscXqXOwGRTnA67f74QFGbniAiHDerVtySTwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) by
 DS0PR12MB6629.namprd12.prod.outlook.com (2603:10b6:8:d3::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.16; Fri, 20 Feb 2026 19:01:45 +0000
Received: from DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33]) by DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 19:01:44 +0000
Date: Fri, 20 Feb 2026 14:01:42 -0500
From: Joel Fernandes <joelagnelf@nvidia.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	Kunwu Chan <kunwu.chan@hotmail.com>,
	"rcu@vger.kernel.org" <rcu@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	hch <hch@lst.de>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: rcu stalls during fstests runs for xfs
Message-ID: <20260220190142.GA2120005@joelbox2>
References: <aXdO52wh2rqTUi1E@shinmob>
 <IA1PR14MB565903564F4AA105AF6A21099791A@IA1PR14MB5659.namprd14.prod.outlook.com>
 <fc611e8e-0da9-4b88-83ef-092d300307e3@paulmck-laptop>
 <aXrl46PxeHQSpYbX@shinmob>
 <13b25e07-d7b8-4b4e-a249-b6826b2eea39@paulmck-laptop>
 <c33c3d3e-a59c-4f5a-a562-13e2cabc2faf@paulmck-laptop>
 <aXyRRaOBkvENTlBE@shinmob>
 <aY54lbpbvATqNqEA@shinmob>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY54lbpbvATqNqEA@shinmob>
X-ClientProxiedBy: BL1PR13CA0202.namprd13.prod.outlook.com
 (2603:10b6:208:2be::27) To DS0PR12MB6486.namprd12.prod.outlook.com
 (2603:10b6:8:c5::21)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6486:EE_|DS0PR12MB6629:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dae80da-4bef-4fe4-4aa3-08de70b27ccc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q5phgZagquxIRQ1xSxr5CMEg1FF0Q5CXPOMablKlrih/Q2TzCyXQUVDrSwqs?=
 =?us-ascii?Q?dudkmR46XpzHu8Ti3lMz3qrRjo/i9abjboTiCp9M3tCcKSwg6AXvZRsvUg/1?=
 =?us-ascii?Q?DnFS1TbBpmQbbdnN+9YHHFvDh50AZNMdEwWCsdxseR4D+xN0/CN7CYTAMfiq?=
 =?us-ascii?Q?hQJe7VduxquN9q/3WZ+9mWvIfnTACH3zT81LS4e7/0eHNcWNCFwdxv2DKu9a?=
 =?us-ascii?Q?NV9eM3PWraQ0TmUQk9TQKEXI5Ro63m+hkXujrJqvs0fB4KC5wORsomPBlTa2?=
 =?us-ascii?Q?/F98JCDOj1rzA7P7uK+Saw+OK7ISQjS9v1Bf254CMUx3NbCOpW3Q/X87HQVc?=
 =?us-ascii?Q?rOjw+faBg7mS7G29dMCh2NfjCOgA32gDe9kqlKoXqRc/VIemTeQmKOOa0uP0?=
 =?us-ascii?Q?+VgLGDWJAWeeFCh3QuM7KLCka8V4UN9mdX+hfZ1sjxpFCLakbRSXCtj+nCmC?=
 =?us-ascii?Q?nJT7wHJuowH9YSkpSbefKp3vkuJilaPt+3pbF1Nf3M4Nt7qHEXzsSpKYbndM?=
 =?us-ascii?Q?wBZFsFJYv+ziX4KZXeExC9PmL1G/rmJweE+AlKSYOUBHPaxdlZR/k9JCPZfj?=
 =?us-ascii?Q?+KAG/bHs0M2SBuy5NOEFgN42VFb+ChwJXtGEdgW2Y+RQUrjSzVz18Y2qy65y?=
 =?us-ascii?Q?Ylkth4jm+otRx2INQIn6aek3nEGZcrvDYT8+HUEHhzY49hpdn3MJMKU7gzgb?=
 =?us-ascii?Q?0pmr9FqC1ydpQuPcHv04puFYLtm0yHleEeMtv6mSXPDMDLBy8EdwOYWLbHZR?=
 =?us-ascii?Q?lEDSvtu/SzmRl5AfWNB4UOgVmVc26qhTHZjUzgHupFZEA77YC5eET/gU4lLm?=
 =?us-ascii?Q?34pVjGfEVhe7vD7VYPxemo63Whv+VVm4UmftQXX1dvdLARczCnItuDpS/+jH?=
 =?us-ascii?Q?1gUo0CA+meEJBNTOWPwfex3Lnlcarp9ql6a1FrOKXBiPCCChRjslj119WovG?=
 =?us-ascii?Q?YqSh0tBiCUHnYssvAH46MAh7Z+dPK9rNtQS2/VCdanlZ1Qw+NL9UuQc+KNiw?=
 =?us-ascii?Q?H1ZyHYnWqqTtHHBU3eBcawdETplL2n4f5jSqmA8YdhepDmXpuwWcdYvSHUNP?=
 =?us-ascii?Q?FoiZNByznpLeQIgeh2SOGd3jmjEg6gKkx2NigbC+XEuTEXrD2UwcnvUgfuPx?=
 =?us-ascii?Q?5GfpmVH4Ksk4nZjHqMfa6uome1VFD2apDGdTVfMHnj9ZhGoiZwZWYsWdIOfu?=
 =?us-ascii?Q?naL+sFVX1tZlFPmWuTW8F20/+K+qMGz5iSbJ1na4TJHTGAo2cSkIo6KO1Ddf?=
 =?us-ascii?Q?/6VMHtiyilT8uoLZBiKEIR5z+/OIWHbMG65398AxG37L99Sspmwntj+tuAhd?=
 =?us-ascii?Q?r/6+E4Yw/QmNwlyWwQc3Je4xO36kZtpP6YGnnUXNC8U7PrzKhjP7U4EzhJuI?=
 =?us-ascii?Q?yxccZQT4BsaqrT6m/pSXEW8zYYz75CWGpl3COYoKSNXZuNxnLHgERQkmGulD?=
 =?us-ascii?Q?5T3zAlXVIr8eM96VgnwOx5BF8pued3Od0gWBBLYLz9aLJzqQT2e5tqKnrjrB?=
 =?us-ascii?Q?csnQFvntYcrjoUsUFo6ANGuO+sbQnDg/AgaIcsEwQxH9XoyskAD/wbM14D6v?=
 =?us-ascii?Q?/jFMPiKnAUj+SEejg98=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6486.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sq4XJrgYccefjG/pH1iEI7XOnk6gWkDmOku7x0FNid0r5T8RGwpKZllpQKQ3?=
 =?us-ascii?Q?EJngDTwSRW/e16IT1Dr2dzY7jgZNOgLelRHCbRdQeypMQ0uDxtv32O6/Dxmi?=
 =?us-ascii?Q?u5yTtiDn7D6ArjHeVYcNsWbpWq4xVqbph3jf4KnZYXq6eqpKlECe+IH0V4xq?=
 =?us-ascii?Q?keqlbeMDeUWwodmYL3P8qpexde3vG3s2Jbp2MusJA8XkQrTSdmA0W2szxDe1?=
 =?us-ascii?Q?KPKsTpDSIEi1FBvyYKLsQWnMzpUmzT3IrImhtnZU6Ostda/iaa6w+7Ok6gSa?=
 =?us-ascii?Q?Y3TWTkW5tAaWjsaZe9z8cyjYbVZrcNV1EFv/k33RD+LJsctcBnyZBlV0Bf9G?=
 =?us-ascii?Q?RdJVadNrGr1E/q83I8PKhEgO0jpg2V5j6w6eJZi3dTZfhwgRj7qyKZbncxkJ?=
 =?us-ascii?Q?D5giuPERYdvEatUdJ+7toagTOkVaoKBABsjBfre5bWxSHxe3FbSWcpPQNS80?=
 =?us-ascii?Q?00tD92KMLI1L1on7wkybESohfdddviRWrWsjgRYGvITrpp263KiVgXRujPus?=
 =?us-ascii?Q?/71gIaf2fMC9jjlK2h8blOLStbTobxvAaeWczI0V33hG5tKPlprdZRwFLdYh?=
 =?us-ascii?Q?vgT8DjhpeUiQ+/Q84vYuEEURs3quk2LnPyCURGI1wq5wNyeMMcxF88ALQ2uD?=
 =?us-ascii?Q?VfUf9NcyW3cCCLobIId6B0Lr4DjoQ04lhuZCbsUnMJ80zzxcLWCEzFiUXjAO?=
 =?us-ascii?Q?zYZydNud9LECw8wiuPARoGxd5ItfqcmTEHOc5N4PHATyEb7mC1AAw80y5N3z?=
 =?us-ascii?Q?YMsQ0Y+eydybfQRy/Q55tgST0+BZXCcseMJe9jPsR6plcweT3aNVQ8flqwLJ?=
 =?us-ascii?Q?zv+Ce4yy/Ne4jMaM08+UZYDOeW0I50chHW/s0EOiEVF8khv0BwHNOKkqY5nG?=
 =?us-ascii?Q?epVzdMH5rHUTPcpTIYvvN21PFaD+L4ZumNLGp80Q47sTl0ICb8qf2L4gAwVc?=
 =?us-ascii?Q?fRFz7UaUO3CAVBEudeVbrxVsl2HLLAinJ+v19+5wZ+toFzHk9jgsE0WC/cZS?=
 =?us-ascii?Q?1QoLLnjfrVARa08/WTP3FxhOnfKl2DzWF1D4X/J0/51vXLuM4PZrD0FJI7uS?=
 =?us-ascii?Q?0Jjxe5heDBCfyJ630QMiOJxWQLBCAwV6y41F5/XnRLTyhULYQvG1XjrlamV0?=
 =?us-ascii?Q?RDAWjrzW4mIGabJjGqxUBTOgi/dUeffMDvgpVUB4cp2Jzb+sQY904z2hbnAy?=
 =?us-ascii?Q?fe8m0jgxokLtzz2WVJPdgZQcFpDTvtT3+knE/qvi4jDepm3NZabgXFhO9jXY?=
 =?us-ascii?Q?d8jLbpBjdcEJpGhQx0p3MTEsA+K0sP9/ddO0ZwcZQSEV4N+6LYgYgyNvD0dR?=
 =?us-ascii?Q?igziLfRTpkawmMXJvYx7vGBN8uYiIon9+I84S8JYnIcwFYpEeLkK3KgI820d?=
 =?us-ascii?Q?e5Va3Oce240bVD1HLiGPPPr7QR7ac2qJWKHUM09dFINWOU6CxIyw+4dnw0In?=
 =?us-ascii?Q?sTBFnWzDC5XJso19iE0d8aAKoP6aOz+8y8bvrQYCJ1+Nj5t2yGd2qqnhVasZ?=
 =?us-ascii?Q?uxFdLnr/AQ9nsM2A+eLGZovl8z5kHpGXaXTf31zSKlNEyjMVbDeHwIr/gkA4?=
 =?us-ascii?Q?umn0eyTNsr8eR2Wv45+eM5iZ8uheaBj3vxeTLUrRtoSXEdewapqWiUjF95L/?=
 =?us-ascii?Q?aao97OZP3tkuSjGxmbiTzHtUSwPWcR9L4RIsiJfKS3OPst6MRAkcj5aTeKxY?=
 =?us-ascii?Q?KPSeB0BaK+4aku5AiTmKYPMBONng3xg/91Ms1YKus+khrmqIuFhBkKSbjaRu?=
 =?us-ascii?Q?kEQF2demKA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dae80da-4bef-4fe4-4aa3-08de70b27ccc
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6486.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 19:01:43.9519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ppVZgDcNTgVxyFrfOrSimaMgbiBjxADA7zM2WkJIs5WYPoEhCUjVhffDSTih/0u7vSnLDk7zKubumzx/zZpRjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6629

On Fri, Feb 13, 2026 at 01:26:32AM +0000, Shinichiro Kawasaki wrote:
> Cc+: Thomas,
> 
> On Jan 30, 2026 / 20:16, Shin'ichiro Kawasaki wrote:
> > On Jan 29, 2026 / 15:19, Paul E. McKenney wrote:
> > [...]
> > > And Thomas Gleixner posted an alleged fix to the CID issue here:
> > > 
> > > https://lore.kernel.org/lkml/20260129210219.452851594@kernel.org/
> > > 
> > > Please let him know whether or not it helps.
> > 
> > Good to see this fix candidate series, thanks :) I have set up the patches and
> > started my regular test runs. So far, the hangs have been observed once or twice
> > a week. To confirm the effect of the fix series, I think two weeks runs will be
> > required. Once I get the result, will share it on this thread and with Thomas.
> 
> Two weeks have passed, and I did not observed the hang! Then I'm confident that
> the v1 fix series by Thomas avoided the rcu stall issue in my xfs-zoned test
> systems. The series is already in v6.19 kernel tag as v2. Great.
> 
> Thomas, just FYI.
> 
> I faced mysterious kernel hangs during my regular fstests runs [1]. RCU experts
> suggested the hangs might be caused by the recent MMCID changes. I tried your v1
> fix patch series "sched/mmcid: Cure mode transition woes", and confirmed it
> avoids the hangs. Thank you for the fix. The v2 series is already in v6.19
> kernel tag, so this report might not be so valuable, but just in case. (And
> thank you again for the additional quick fix for my blktests failure caused by
> one of the patches in the series).
> 
> [1] https://lore.kernel.org/rcu/aXdO52wh2rqTUi1E@shinmob/

Good to see that this got resolved. I am guessing there's nothing from an RCU
point of view that could be done differently to diagnose this earlier, since
I pretty quickly spotted it was MMCID related when I saw the existing report.
Let me/us RCU folk know if there's anything else to do here though..

thanks,

--
Joel Fernandes

