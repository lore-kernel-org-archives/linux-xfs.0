Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6C970814
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602510; cv=fail; b=bQv85EYd7Bd+4xPvmMrQKQ270fp26hofY1OS78nzUi+sQCqJUdzwo45IJ3lLfhFuSGloBA2KwdRJImb2Ki947m5m2yGe83jQTr6+698p3gE03DCk9Lca4ocOR9z/jBiwNi+32bfJ/fl416w5v1e8QpNnEIorLv90hm/fsDfKmhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602510; c=relaxed/simple;
	bh=6VekvSSCQ/DeHLCKaLzSoLZTwCtF/351BMpYELcBtsA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IGK56UwQNEDYF60wSTF8nneiKbwzfy4wXby66vbjseOEH8J8YCJFTI0TMp38+MCGfitNyibi4bKJw+HruNj0MOoqyKkbvUWRuAN7o92w5+lRacpXN786bsIAqmEDOMjKngNCUCpo/YNOpBSDZp+zR1MYoLPhh4m0MXfBCF4Bkpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SiUk/dsY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=xdJ7H/MX; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SiUk/dsY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xdJ7H/MX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769602508; x=1801138508;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6VekvSSCQ/DeHLCKaLzSoLZTwCtF/351BMpYELcBtsA=;
  b=SiUk/dsYC9kRISM3uJEv2AtIIeb8anJr4L7HozMQz8syRrff3diWxl9W
   QAY4PYKLY6ezVy+caLZ78oW6sb/IQkjjnEEaIdBD3/jEWZ8HL0shhI74D
   Yjt867m1XnaSjEyg3iTN7E5IK2UF1X0e91rP65vfG8nyrZ7kn0jKlwUQU
   G8hekqqw1YxAK2LOatyCeFtQfcN4zMom4qspCFM1oouo1McyQuNi1zSNe
   vdDVQfnf5g+Sj/vvzc25JbV6YVVheIZg54sv67iYGlghhAkoJzt2KwRUK
   SEsC456+B6AAr2OqPOjnIamtMRl5wXO/iR0v3pS8+Ohk6mEitzUaVd/9q
   g==;
X-CSE-ConnectionGUID: rCICwGAVREubEaVAWuHXSg==
X-CSE-MsgGUID: 0zFvrhn1Q1+GofUQ45te4g==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="139349045"
Received: from mail-southcentralusazon11013051.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:15:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sTBCGu4laBRMMHiKAGbPbYbvv2d+3QcUuWyA1ewr45pJKXSBH2C0rug5vnJbDUuDyVrITMSvAmNGTjeNrES7ImduL5Fj/nnV+s4xPNUqtYkz4PI2SyBVWY/SvAbS7G+D3oevN4TjxCq+iJndEyVwLDvJWkIMnQGZHrlg6KXqxOZm8ONmZVPgMCjlGOgmgLLCWpYb1O71h3Li01pLs5CAMGQL69hXcAgVPzZ59YCRWUiK4uPuzHc+1TAJSK1431yV+KKs5cUfJWlpWmVHDncsmcM3EsB5SqrTNZBgPiOB/UnfIXWAbdAWOjgkTcg6sx8G3vQyZ337R+N9sfjGEPelow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6VekvSSCQ/DeHLCKaLzSoLZTwCtF/351BMpYELcBtsA=;
 b=mRakLHSa1C/GsgbMP/B1glBRM6lPBd4VVVmzyQqAMAJi9gbX8N/ToeYql1q14QQ2kAZR7XZYie+aDUGgmA9QT9Ki/zVW4Ss/PYl11A+NNxvTVReYCWnWwmKA61FabyuEcWsEz8eUo0e8prN475Ft2joMnnm0aLTyF1+UN5yRmQzYtjMqByzq8+VrC3JCIhq9Q8Vc7ePhJxTeq+9WIURrvBRtt3GxloEMrIh42OoTqeciPJsWoFl3WVQlyunreNXmRJq1ttZwA+dgpLrKdJcGS4A3AqOwM9IeTh05G+DaWJ50gXKzOI+InoHw+/LG05+z/RD+Waz0PPeGB+wxwRrhdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VekvSSCQ/DeHLCKaLzSoLZTwCtF/351BMpYELcBtsA=;
 b=xdJ7H/MX3M1BmM9fIII7aXNS8x7HOoHdbh8kwgDuhlg5l5QoJolEj/dpsBuYvBGHWnUB7iWXwGFe4fjlIcy+F93tTMVhrdDR2da5Ti+J7I0NCPeV0QhNF9QA9rlXrj91cpCu2LKyPmhNz0UDJ5WWCo+rGgGdtTM9UnmbMjY9oPQ=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MN6PR04MB9381.namprd04.prod.outlook.com (2603:10b6:208:4f7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 12:15:04 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:15:04 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 05/10] xfs: use WRITE_ONCE/READ_ONCE for m_errortag
Thread-Topic: [PATCH 05/10] xfs: use WRITE_ONCE/READ_ONCE for m_errortag
Thread-Index: AQHcj6b1OReta+HEk0y3gXlzwWb97bVngCkA
Date: Wed, 28 Jan 2026 12:15:04 +0000
Message-ID: <86711ec2-956e-4e19-b19b-efda47f9d211@wdc.com>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-6-hch@lst.de>
In-Reply-To: <20260127160619.330250-6-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MN6PR04MB9381:EE_
x-ms-office365-filtering-correlation-id: 85eb39cc-ea76-4ece-8a6b-08de5e66de78
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?U25JcXZSUUpuVVEzUmhteWVEV3kydHZDK1BnUTQwYjRWeElGQVpiWm1ZazBv?=
 =?utf-8?B?Q2pqeGlVV2lVUnAxUzE1RmxYc00wTEdHVC8va0ZUako5eFRhYlR1YlVUdita?=
 =?utf-8?B?cFI1ZVdCZStDMEpNUEZJdVBCRjdzK1VESW43dkd0aG1ncVFFOW5ENHBscXpl?=
 =?utf-8?B?NTkzVm4weEs0RFVFQWhxUERYbVJHVE9ZcWcvdWFVdTZvTkZSeVdTMWZMbThE?=
 =?utf-8?B?ckFmNUl2U1gyc0NJYndWU3p5VTBJeitIOFJpamtBNnJSTlpMMDhBK3Q3eEd5?=
 =?utf-8?B?NjZMbHJDK043WVR2d004bjhOdDVyWjB2SEs0bTRuTjN4RUN2RkNhRENoSmNT?=
 =?utf-8?B?bjRLSU9TZktpYmY3UXZ4ODhRVUt2ckRreGlJL0pFWk5JdksvUDRkVjltSmlq?=
 =?utf-8?B?dXNnVXJaY1JsMHVvUnZDYWNpQTVnMldzbWZiRjRORDlhMy9iMVFzK1pYYWIv?=
 =?utf-8?B?NFFKa1BTa0JoN0lxWVlEMi82ZTQvMm9sb2g0aUJPYVA3SHRJWWdDVFk5ZkR1?=
 =?utf-8?B?THJuM0tuVlg2ektaR3VWcHQ1SFlLOHZrV2p2YlN6TTJuNFBON2l6cFpoQXdD?=
 =?utf-8?B?dlhQRStaVHJIZXFlWUY3eGsvdU1SZkdOWndtZjV4aFdFS1VvZkZXL1lxR0Zk?=
 =?utf-8?B?MmtIOWFQTUJra1pxdS9rZUI2Rmk0aW5JYTk5S2N4UnNObGxmMUthV1ZEL3NU?=
 =?utf-8?B?alRKSTFFMCttRlFPYit0ZzVPTTdBdldPSjdiZmpVSnZLRHo3d1A4YzQwMWZw?=
 =?utf-8?B?N3pSOVNTNGg2bDEvMFNxRjdxZmlUY1ZuYUptdlByVTNkY2Erd3E3RE9EREdH?=
 =?utf-8?B?eE1MNENpbzRUTUVmYUV6QnpBd1JlUVVjdzVqOUQ3bEkwRmpJb05KaUVlendq?=
 =?utf-8?B?Zk5PQ0YyYjJkSURPd202QjZQVE1uSmV1dEM2VEk0SzRwb1NrQjM0R1BxdjNH?=
 =?utf-8?B?QTRrd2hMaVhZa0llMUd6cnhVcWN2R1pKS0lvcjhvUk8wY0NYSEpyYWhkNnJJ?=
 =?utf-8?B?bUtvanNjRnhnTXB2TmwrS3NpaVdRa1ZLQnJjODduWUNpa3hLa01nMHd2UElo?=
 =?utf-8?B?VU1heGpUSU1iMUl6WWtMWlJQb24wdUwrSmMyS3dMSG9PVkhORWRwN0lCQlh0?=
 =?utf-8?B?T2wrbGlYdWkzZERXbU1ISzBhMVZPYi9rd0JON3N4bTJ3ZE5hZkhhS0J6THVy?=
 =?utf-8?B?dHZHd2drcTFsVTdrWjQwZ0R2REhONFYzY0ZxeFFheHVhMFQ5TWhmRW5GNDZr?=
 =?utf-8?B?TXduWm1jT3B3ZzVjYUJ4ZTJKVnQ3RzluOEkrWFpFY2ptY01DZk1ZelJkMmZq?=
 =?utf-8?B?cldqemV0T1YvS1ZKZWpHZ3ZLSG9HR3g2NmowdWlaZ0l4Z09VYU15OXFKdW1i?=
 =?utf-8?B?cjQxL0RuWTIybkRxQzNpakxhTEQyZmphUjZEZXJmOVFSRkNyQjNwSndmdC96?=
 =?utf-8?B?a0IvYTZ1c1k4Tk1XRjVOblE0dXNVc1poQU9iQlFhQVBCVE53TUZzZHBNYXVL?=
 =?utf-8?B?cDArTHZyV0xMRzJnTWtaMk4vNXRkNnBaTU4zaXlDa3NZZXlDN0xIaWRObDZw?=
 =?utf-8?B?YkhVZlBTUU1GcWpYMWh5dGdhbkRMdnRDNWEyTHNVcW5rdytVK2FsQzE0Rkg1?=
 =?utf-8?B?YkxPZnpNc3RuRldUdGRoaU1TaVFPcmpLVDlhcjkxZVAraEgxNFRXOG9tZVky?=
 =?utf-8?B?L2p5V2lqdU9hckNtS2VvWk9UZDdqeWxlWDU4SEdqUXl1VUtDUUhScGI5ZHl6?=
 =?utf-8?B?cTYzRy8rZnBIU2NoZ1NvU0dGM2g5NFRIUTd6RitISXhXRXBuaHVvTGNkd1Nv?=
 =?utf-8?B?aDRtQUtETkdCaDRaSDJmRDJnZUx1aFFQTkRUNWVpNDJMWlg0MW8ranZnTlZn?=
 =?utf-8?B?aU9RVHg3TGRVYnRZeFJidmNNTVk0MFg5ZXVOZ2tqdzRVVmZuVUxuSEJFWVdN?=
 =?utf-8?B?d282M0s0eW1FR3RYQjRCUFJQUzQzbzlMVWNvTk5LTElVaXk4Q2dPT2tEcmps?=
 =?utf-8?B?YW01cndQblp1QktWZVBoaU5oNnkwS2E5UkxLNXJMT2pqZVdsV2Q3ZDNVaHNs?=
 =?utf-8?B?UldkbS9ZWkJxM05ETjB6eXZFQXJwZW1IT3Rib25jKzRlSFo2ZUZqeWR1eUZu?=
 =?utf-8?B?SWhjUUljUnZBcHpHcG9NdFA0ZFoxTWh5NkRnaHdxNDlkQlU1NGM2L0czQjlw?=
 =?utf-8?Q?e1VN75k64OcRYXsGyAOES7s=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RWdkZEw0VjVXZmdkZmlpMmg2bms3TEVvc2dCektJNWRsSUZHUGhMVnRuSnBM?=
 =?utf-8?B?WEViYStkQ1I1cmRMNnJGeGFTYWxSWE8yWExIbThVNkV4QnV1cHl2WEJKbUZG?=
 =?utf-8?B?ZHZVL2FwOEJvcTlLempGaWRTcEZhYnBETExSVTZaQ3Nhb2dESmxTRmtnMHZY?=
 =?utf-8?B?T0hTKzl0enVJNlZoZXNWQVAyOUxrenRmWGJqclNCeVhHd0JPMFVTcElQYVo0?=
 =?utf-8?B?TTJGaHROeEVwOFQwVTlsV3BjZ01McEgrQ1Y4V2xKbkFJZ3N4a0I4UDlidm03?=
 =?utf-8?B?ejlyVkhmQWU1ZlYwRXJGdGVrdFNOQ1NkZzdQdURpVTk4YzEvaEtNd1NVdklH?=
 =?utf-8?B?K01Vc3RBNnMyeWRKNm96VDFyS2hibnMreGZKT2cxSlhqRXpKSkMyY1RzZWhp?=
 =?utf-8?B?ZkhjNHV3ZDFFUDJXaysxRnAzMlRETTJVemlyL2ppNUZUcklBMHV5U1ZGR3Jt?=
 =?utf-8?B?S3JrNVV2TkxQNjdtMHEyK28wTjF3QkV2c0ZpQVZUNmltVnIvWmRiRis2YS9M?=
 =?utf-8?B?eFRHNnhRUXVoNzZEU1dPemVsY2R6amZJYk1QVWpBeWowd0U5RnlmK2ZzLzdF?=
 =?utf-8?B?VWhlT0F5aXdBSmxnbkpTbmt3S1FnZlBNQitMbHpmTDB1akp4ZzdGQisvSzdl?=
 =?utf-8?B?K3JPYW5pYnVkVXBMZWtiK1JHNDFRK1R5Tit0UWlhMjZrSEZXUksyTnJnanBW?=
 =?utf-8?B?Rmd0UnJ2VExjdDRZc0FCRi9RRlRYeEhuRjBWLzRNWG13cFNKbi9wTGYvaGhq?=
 =?utf-8?B?NVY3MUNtSEowRGUraCtrdmFCT29uWWZNOXRRSFJvbmZVVVhrK2Y3dHpVbWFN?=
 =?utf-8?B?N2wrY1pLWExTT1pYbTczTEdMRTVsR0wxVVpXNm14Z1RYZ2NqVFRvL1QwYVdj?=
 =?utf-8?B?MUJEbzMxRHUyT0RiVmZ5aTBIbzBsWTVGNFRSY3c3MDhDU0NnYnFiS3lGaEIy?=
 =?utf-8?B?UXdyWjRQb0cwRHhQcmg3UUJqYnQxRWowMDZKL08wNDdHa3A4TStpOUd6cjNS?=
 =?utf-8?B?RVFMOU9aWUN1VlNFT0Z0aEdGQmt6a2xXd0J1cGhESjRLSXBwcEdaQjFubTlS?=
 =?utf-8?B?RnRURXl0SDIvTUNaVTZoU2YzREV1UnhrRjd1SkZLcUk5RzZ3RFVUNlVqYlln?=
 =?utf-8?B?eUkxZU1DZmNiZG1KWExrNHora3NQL0hZd0J0RXpFOW8rSzNzeHp5K0JFNXpT?=
 =?utf-8?B?WVdDRmxsYkJxbHVqM0JDYUNvcnoyRjRkTHhvSWppajZ0WU8zMlIxL0E1ampt?=
 =?utf-8?B?SnhMRDV6dUFiRGUvbWdEa2NaT3RXWVJ6ZVNEMmlZd2tvNkI1Rmk3RWhMbEdC?=
 =?utf-8?B?dFVCalhCaWZIclNCdFdoTDdZTVVGZG5oakFJb0JjdnRxT2o1MWVWV050YlZU?=
 =?utf-8?B?RXJPZWFvTCtJdFFDeVVSZVVUT1ZYdkJlS0lNcFY1bk9wN1U2NnVuMFQxMXMy?=
 =?utf-8?B?OU15c2dOd3gvQTJJeWNLU2lNaW0vKzc3aG85L3hxMkJOdmVqZ0x6K0ptSUdm?=
 =?utf-8?B?bmFGcndqRWsxMkJaSGM0bHp6UCt6RDhwQnhWZk5kMjFYcHprdUIxc3dRVWJ6?=
 =?utf-8?B?QTJoeHhRajFQa2RNN3UyTjZuTGlXbXBKTG92bHM3YW5MaVdTVm1ERmNiMDVp?=
 =?utf-8?B?WnhnYlFqS3pzTGRGMEkzNzV0eGhuM09VaU1yc2JMZ3R6MGMzdUNrb2ZNZ3Ru?=
 =?utf-8?B?Z0t0OVhuQmVWeXVNb0Z4WEhWNk5aUHFsYnhrb2F6VEh5eW1tVFJHWVZrTmVP?=
 =?utf-8?B?V2FjOXhmV3BMelFJWC9XVEJVaXFNU2VTK3ZNamx2SlRYOXE0M1FmUXFBb1Y3?=
 =?utf-8?B?eVNGakFPZTZTN0hURm9ZdXBMdG9iQ1lXNjd4NzlJVGp5Nm9WaVNsemZKSG5t?=
 =?utf-8?B?dzlPMi9mdk0xUzJBWUVSVXZ0YkF4K25tMGIyNTA1L3pCL3NUZ1ZGTjZpYmlu?=
 =?utf-8?B?WVQrSGliQ2hDYVo5MFE0ZHc5bFBVbHhodmdjcjl6QWhFd3RDaVNsNkkyaDA0?=
 =?utf-8?B?MHV2UUtibzBuRy95M1BsLzZIV0FZNnJiT1dEWXVod3VJZzNMNWtRWUg5R3dE?=
 =?utf-8?B?eGt6VmhXSjZrL2M1dk5sNzZuRzhMclV6YysvaWNVSFBzalYrOFdzK3pjcGxR?=
 =?utf-8?B?cFppV090aFBtTmcwRGwrQ0NKbGRWdjZqanBPd0hjeFdkMktaQ1MyeVowTUwz?=
 =?utf-8?B?ZENvWFJ6RVV2VXZPZUJ4QUFuNW9rT3lqWEU0MFR1Z25jb1I0Mmo1MmlKMkky?=
 =?utf-8?B?RmYxQTU3ckp5MXJjUU9pRjFadHpHSFRWK3A3SzlxNmEwSGU5b0NvSC8zVlA0?=
 =?utf-8?B?QWdTdXhMSnh3Y1ZCTWZDam83QTlYYzR3OXM4cjFia1VsMkVoVFR6ZENqRXJS?=
 =?utf-8?Q?ZstomsexGNfg+aYs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CA3A212767C2943A094FBA3A8A9A8CD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HqXbnRPw8T9ve8JXTihdOG8+ymXVHJ8zwrN+G8elgYMARjFJMJqILm5Rv6U9f57d1Qej2Og4xT/XY923qu0wNwevp9ysEIucYgZ9yDFy2vtTopAICYSlEzEMoD6oAQK9DvKgdXlrJWJ+5kyYxjmbI0a3kioyG1z9ojYH/1Q3WKUAS/nQytv5G2IM47uYi9DHjhkL3AyO+XH5JAevp+SrIo0G8MefFt9uIVMhRTNr/07JRicMMFSX8DLs8eattVebdVoKcyMaJzxLgxgAi9u5XKPHmGkoP1v3Ky5q53KPhevqpweAI7FHUxr62H013JvYOEb1hkaiYZZZrQ/SZ5ycBwQlUQuYLxwdyXlaVYE08bs5zZIOMQKkzBFL+wYaRYgGBPDTvw2x5xvKbVaruqz/9wTjqwR/6UQ/55xp8yt04+AJQDTZQYoN7wA1WUta1IWSXF1UinEAH8xzuVGJusgT0IU2joW9/GPVMicyMdCKaEaC1d8gHyF55LgNAkjDzE7l8VZor91X193EhFBkETu88pvUelzi6q6RvD3mYIi0RvFrGko6CoSIbuhDJYV/ijwA7WWroetDpEuGQcVijadMk0WlE9z7t1t3jxhzztSgKNTe7ul1jGLFpySCTtS0ohGI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85eb39cc-ea76-4ece-8a6b-08de5e66de78
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:15:04.4508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4zvhWJvDtaJSyC15i98kz2Yxl+ATzSZd6J9Cjkv4nd4/zOn/Y3u4hWynySRp/XLB1VrF7CccJUNkY1ICGggyHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9381

T24gMjcvMDEvMjAyNiAxNzowNiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFRoZXJlIGlz
IG5vIHN5bmNocm9uaXphdGlvbiBmb3IgdXBkYXRpbmcgbV9lcnJvcnRhZywgd2hpY2ggaXMgZmlu
ZSBhcw0KPiBpdCdzIGp1c3QgYSBkZWJ1ZyB0b29sLiAgSXQgd291bGQgc3RpbGwgYmUgbmljZSB0
byBmdWxseSBhdm9pZCB0aGUNCj4gdGhlb3JldGljYWwgY2FzZSBvZiB0b3JuIHZhbHVlcywgc28g
dXNlIFdSSVRFX09OQ0UgYW5kIFJFQURfT05DRSB0bw0KPiBhY2Nlc3MgdGhlIG1lbWJlcnMuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0t
DQo+ICBmcy94ZnMveGZzX2Vycm9yLmMgfCAyMyArKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiAg
MSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZnMveGZzL3hmc19lcnJvci5jIGIvZnMveGZzL3hmc19lcnJvci5jDQo+IGlu
ZGV4IGE2ZjE2MGE0ZDBlOS4uNTM3MDRmMWVkNzkxIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZz
X2Vycm9yLmMNCj4gKysrIGIvZnMveGZzL3hmc19lcnJvci5jDQo+IEBAIC01MCwxNyArNTAsMTgg
QEAgeGZzX2Vycm9ydGFnX2F0dHJfc3RvcmUoDQo+ICB7DQo+ICAJc3RydWN0IHhmc19tb3VudAkq
bXAgPSB0b19tcChrb2JqZWN0KTsNCj4gIAl1bnNpZ25lZCBpbnQJCWVycm9yX3RhZyA9IHRvX2F0
dHIoYXR0ciktPnRhZzsNCj4gKwl1bnNpZ25lZCBpbnQJCXZhbDsNCj4gIAlpbnQJCQlyZXQ7DQo+
ICANCj4gIAlpZiAoc3RyY21wKGJ1ZiwgImRlZmF1bHQiKSA9PSAwKSB7DQo+IC0JCW1wLT5tX2Vy
cm9ydGFnW2Vycm9yX3RhZ10gPQ0KPiAtCQkJeGZzX2Vycm9ydGFnX3JhbmRvbV9kZWZhdWx0W2Vy
cm9yX3RhZ107DQo+ICsJCXZhbCA9IHhmc19lcnJvcnRhZ19yYW5kb21fZGVmYXVsdFtlcnJvcl90
YWddOw0KPiAgCX0gZWxzZSB7DQo+IC0JCXJldCA9IGtzdHJ0b3VpbnQoYnVmLCAwLCAmbXAtPm1f
ZXJyb3J0YWdbZXJyb3JfdGFnXSk7DQo+ICsJCXJldCA9IGtzdHJ0b3VpbnQoYnVmLCAwLCAmdmFs
KTsNCj4gIAkJaWYgKHJldCkNCj4gIAkJCXJldHVybiByZXQ7DQo+ICAJfQ0KPiAgDQo+ICsJV1JJ
VEVfT05DRShtcC0+bV9lcnJvcnRhZ1tlcnJvcl90YWddLCB2YWwpOw0KPiAgCXJldHVybiBjb3Vu
dDsNCj4gIH0NCj4gIA0KPiBAQCAtNzEsOSArNzIsOSBAQCB4ZnNfZXJyb3J0YWdfYXR0cl9zaG93
KA0KPiAgCWNoYXIJCQkqYnVmKQ0KPiAgew0KPiAgCXN0cnVjdCB4ZnNfbW91bnQJKm1wID0gdG9f
bXAoa29iamVjdCk7DQo+IC0JdW5zaWduZWQgaW50CQllcnJvcl90YWcgPSB0b19hdHRyKGF0dHIp
LT50YWc7DQo+ICANCj4gLQlyZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsICIldVxuIiwg
bXAtPm1fZXJyb3J0YWdbZXJyb3JfdGFnXSk7DQo+ICsJcmV0dXJuIHNucHJpbnRmKGJ1ZiwgUEFH
RV9TSVpFLCAiJXVcbiIsDQo+ICsJCQlSRUFEX09OQ0UobXAtPm1fZXJyb3J0YWdbdG9fYXR0cihh
dHRyKS0+dGFnXSkpOw0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IHN5c2ZzX29w
cyB4ZnNfZXJyb3J0YWdfc3lzZnNfb3BzID0gew0KPiBAQCAtMTM0LDcgKzEzNSw3IEBAIHhmc19l
cnJvcnRhZ190ZXN0KA0KPiAgew0KPiAgCXVuc2lnbmVkIGludAkJcmFuZGZhY3RvcjsNCj4gIA0K
PiAtCXJhbmRmYWN0b3IgPSBtcC0+bV9lcnJvcnRhZ1tlcnJvcl90YWddOw0KPiArCXJhbmRmYWN0
b3IgPSBSRUFEX09OQ0UobXAtPm1fZXJyb3J0YWdbZXJyb3JfdGFnXSk7DQo+ICAJaWYgKCFyYW5k
ZmFjdG9yIHx8IGdldF9yYW5kb21fdTMyX2JlbG93KHJhbmRmYWN0b3IpKQ0KPiAgCQlyZXR1cm4g
ZmFsc2U7DQo+ICANCj4gQEAgLTE1MSw3ICsxNTIsNyBAQCB4ZnNfZXJyb3J0YWdfZGVsYXkoDQo+
ICAJaW50CQkJbGluZSwNCj4gIAl1bnNpZ25lZCBpbnQJCWVycm9yX3RhZykNCj4gIHsNCj4gLQl1
bnNpZ25lZCBpbnQJCWRlbGF5ID0gbXAtPm1fZXJyb3J0YWdbZXJyb3JfdGFnXTsNCj4gKwl1bnNp
Z25lZCBpbnQJCWRlbGF5ID0gUkVBRF9PTkNFKG1wLT5tX2Vycm9ydGFnW2Vycm9yX3RhZ10pOw0K
PiAgDQo+ICAJbWlnaHRfc2xlZXAoKTsNCj4gIA0KPiBAQCAtMTgzLDcgKzE4NCw4IEBAIHhmc19l
cnJvcnRhZ19hZGQoDQo+ICAJCWJyZWFrOw0KPiAgCX0NCj4gIA0KPiAtCW1wLT5tX2Vycm9ydGFn
W2Vycm9yX3RhZ10gPSB4ZnNfZXJyb3J0YWdfcmFuZG9tX2RlZmF1bHRbZXJyb3JfdGFnXTsNCj4g
KwlXUklURV9PTkNFKG1wLT5tX2Vycm9ydGFnW2Vycm9yX3RhZ10sDQo+ICsJCSAgIHhmc19lcnJv
cnRhZ19yYW5kb21fZGVmYXVsdFtlcnJvcl90YWddKTsNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4g
IA0KPiBAQCAtMTkxLDcgKzE5MywxMCBAQCBpbnQNCj4gIHhmc19lcnJvcnRhZ19jbGVhcmFsbCgN
Cj4gIAlzdHJ1Y3QgeGZzX21vdW50CSptcCkNCj4gIHsNCj4gLQltZW1zZXQobXAtPm1fZXJyb3J0
YWcsIDAsIHNpemVvZih1bnNpZ25lZCBpbnQpICogWEZTX0VSUlRBR19NQVgpOw0KPiArCXVuc2ln
bmVkIGludAkJaTsNCj4gKw0KPiArCWZvciAoaSA9IDA7IGkgPCBYRlNfRVJSVEFHX01BWDsgaSsr
KQ0KPiArCQlXUklURV9PTkNFKG1wLT5tX2Vycm9ydGFnW2ldLCAwKTsNCj4gIAlyZXR1cm4gMDsN
Cj4gIH0NCj4gICNlbmRpZiAvKiBERUJVRyAqLw0KDQoNCkxvb2tzIGdvb2QsDQoNClJldmlld2Vk
LWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQoNCg==
