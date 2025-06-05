Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A154F1F4626
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 06:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749105765; cv=fail; b=P8Htqk+6ouCGEupczzG9k6QJNlGnJNAevZaV9JjHmJ3D9vuiAqAK4nJ9CuoTHt2rrNS5gNibqSJ3gIX4hbYsshLoNN9cJwdJagi+ijyjVKyHumZ9xovbCYYlm+2iiB79RM9LQnN02gEl3kbw4wPetrbXxfuSb7Bv/Snlmp77Z3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749105765; c=relaxed/simple;
	bh=wvJsU6krNkKTP3fZtL1REgFmVb4in/gHrOqn2J4M+Xk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HFvWph6RR0QnvBZ+S5M1s0UEKqvQeWGRMSph6EIJovRLSqT/8Q5w9gsd2kxNs9vJr95TU8hx6lz4YJwrUdsfP2ZR93LQnaem3Vz5cZQ2SQUF4ZEjg2DfmBTTY1aweNa3gmOKIVctArzzRcwiMxQwjGC/qAEASvR/yu8qgutG6ZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NL8M8As/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=xNssrJ7w; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NL8M8As/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xNssrJ7w"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1749105763; x=1780641763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wvJsU6krNkKTP3fZtL1REgFmVb4in/gHrOqn2J4M+Xk=;
  b=NL8M8As/AWLI8/3q7EHsdWzrC+3O4qdHTzblby7SpCNbDOwgKtsqFFWe
   wszXMizt5kXQYjxZ6bhPeamFrIVyR70WLxXELUjAfoJNVkoumfobRAmjU
   6UJFC5eUHr7AtSg3/05gIgqGjTsOuR2WsKpfgIDIEO3Tf6RNKmrZJIRKP
   2oRnloTBhFx3bjyd4Yo+DMSlR2+8n7xhEMxgZXvTdAMTC/weThjckmZT2
   AF1xfvzaiKtV4ZJcabEtyVCjQ4ct2D+BRlxV8TI0/dhejLobyA7eKvYo3
   2ig+1XrX4t0jD7QoeoYoGOVXZ2uXdpV9NBPYpZAwxebo1HoE7x3LSE8B7
   w==;
X-CSE-ConnectionGUID: u7Oj4RC8S6yvNrbNx+yjsQ==
X-CSE-MsgGUID: kiAkuZfKSJa7bwGKpKkBvA==
X-IronPort-AV: E=Sophos;i="6.16,211,1744041600"; 
   d="scan'208";a="84026543"
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([40.107.237.72])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2025 14:42:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aOapUO9qPIHPbGFeWbaGJeQwmFrSeIFeFuGB5Lb5vwHvWth7wknuhN7bR9YY8wXh966wj1S6PjI+12o68tbrZLscaa1J4rykOYCNq4f3FIGfYH5f/dWD6RGz2/1uSAbyrLv8cnfqE6+ddliY9MRgdC/ZVm44173H9KbE5wCSht03cRtOs00MnkTVYJrXvRsAJLjPfX/8WcjTwjJA9qV6/KaIn7sEOjbu0XVtrZy7V6IJUyghJ1wY2xsRXTb0GtP1Y/ysN1iufGbK2KLzyvyoVWdaa2EtDod2yYxmwl+3/Np0ZLXYTGtN2yl/znc0/mERWLrwQP/vQxuE1qoPw1vdmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o74j3+I64b/GfGYv2w/g2QkVzvDUvzXEMgI59z08bUk=;
 b=HVJgvKP1pykTsJjkNEGUbHTyWdKePh5+hy41JHm8bEj5TM6pWqAySkOXYhlt/CAnB3fkrw3J6hzjA+yZin8hHWSgj9qJgN8OuPYa+t1kj/rXwOKFw5MML6+cCZ0wF8yqPn/Ij00rwg4WZ2Lwi++kem3kSNzANj3Ket8GZzxB6Nhlt5u/IJ0haQUtFhFjVYlV98dF0PDU5/qpbFM+DH1RhzcK6AMGBFXiZYnyY5CRwDNDyrZX4pHurC/yC8yjmFFyWQCgNAl+D2I6yiT3MFSn2STt3PeFvFXqG8M57q66o9+9iSMdJvjhXOFEOrHgwVHjW+TfF4zn8dEEtAaEkDF+7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o74j3+I64b/GfGYv2w/g2QkVzvDUvzXEMgI59z08bUk=;
 b=xNssrJ7wvJgERRW4lxxMAGs5JstP7x9a9jcxxggzneYhYTABfPS7ihveGJG3EYcj11J1KWZ1B3mu9XVZOGB0uIdeP6hVz6GtXhCp7Huq5uQbBh0KXgrncQlkWVndLrisUelLmL0Om8sryezLww6t8UpB7AkR+2s/w5cgTqOexE0=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by SA6PR04MB9328.namprd04.prod.outlook.com (2603:10b6:806:443::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 06:42:40 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 06:42:40 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: hch <hch@lst.de>
CC: Carlos Maiolino <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: [PATCH 1/4] xfs: check for shutdown before going to sleep in
 xfs_select_zone
Thread-Topic: [PATCH 1/4] xfs: check for shutdown before going to sleep in
 xfs_select_zone
Thread-Index: AQHb1eFtlliX25QDEkGSLmGrMWf8aLP0HkyA
Date: Thu, 5 Jun 2025 06:42:39 +0000
Message-ID: <m7hngg46ohecpckvuwm6ykvkdqqimockm3hv2lbsa43lansqhw@in4qlzfn77fz>
References: <20250605061638.993152-1-hch@lst.de>
 <20250605061638.993152-2-hch@lst.de>
In-Reply-To: <20250605061638.993152-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|SA6PR04MB9328:EE_
x-ms-office365-filtering-correlation-id: 350a8b9a-3504-4271-25d7-08dda3fc2ab9
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?E7vSRlEW15nqvmTPoA9ESwbrAV20bJ8i+Cty+TK8I0FqiYYq3L8mZyECb2O9?=
 =?us-ascii?Q?nJkhj/3Ab6UxrGIq+dFMsFL4hyTa6faleOvXsfKRIu+w5fRrKznAR81AbOWK?=
 =?us-ascii?Q?DMCxkrCW75l7W4MxCrwJn1ycO8BiCCLbXUVWmMOTK7WMOGs2VaqEjX9VTWd1?=
 =?us-ascii?Q?Ef4XUiPJOM/LE4TC0gfC+VmTn61FkPHY3Ord4aR7Sg4o6nfTWdKcuusJtgJF?=
 =?us-ascii?Q?HcX6qnoJ7hMIk2Vipxkt70rRRPckHRWD78tK+s0NEk+LNOxC+k/GV/sArz7U?=
 =?us-ascii?Q?EO/0eNA8gsDMAfpJ+GD8Aa5GxS/nxvqUwy1JlOF6nJM842cdqecBS1DF/IJ3?=
 =?us-ascii?Q?5//ZkZgbbArLqJNDWhhn6RKGmzqA4qo4vPPR0rn1iJvAcpZ5RIUwg9GnLMPd?=
 =?us-ascii?Q?4eetRVGMApbt/LmeiCc9naNWXhoVWTZTLHghXAsIXjrjCP9GIxB10U7xyo/n?=
 =?us-ascii?Q?mdrqYiPEd+dXAz1lF/4tgxXrDDq8tVE1pel5VhMNeGgg53cFuDCOx+SZ+aR8?=
 =?us-ascii?Q?aDlk7VMMagFlr/BZUbKBbbYhJzBMZ7EWA7X98bs4ha0lsZwhWKpZWfd9Ucme?=
 =?us-ascii?Q?zGagMwo5+ZV9+cNMb8Du42Sl9z0dUOt+HPLmNt+bhF94l10o639GXF0ZaHqF?=
 =?us-ascii?Q?fyS9BjK1cN3t2xKpjZBZ1mxHx7ick4RZZCZ415ljlrKY6WN6UlY67UzLf+uz?=
 =?us-ascii?Q?5nJHnwocPXC4uRkR3Od7M940KtluCqrBGcL0lZ2gfkG80TM+caCj71gMmi0E?=
 =?us-ascii?Q?O3ZdIm6SqLH2oNCeUiqfYtGFFyzeg/eCF+8dF+PugLLGQhTJbIZHYCNB1CBy?=
 =?us-ascii?Q?8DuxIFyhZqT/OcE6FRDe5EqDQ481rA+rYAP+iyBB8aMo4X/X9+hgT8iW3xC3?=
 =?us-ascii?Q?xupSq2kBC9jcPdmdmKe/BGeyUhRGDokobhixS0fzd03mv80AgIOoiyGV8C4Q?=
 =?us-ascii?Q?8rk2WlXv7XEnvmACn0QGRWptNeeiieZJ+9JHQzo7BRjFhLvJSEq07FYlagP7?=
 =?us-ascii?Q?NPUMp4wwY4vum8V9MYQxegwq+BboNTLv6mUFtxvR6v8gXWYFCyTUeHLMSSUd?=
 =?us-ascii?Q?xFTc2TXjPpTAhHd4CplcIUre6FqtxruVuNibIgJFPjSU4HcO7qRGnnogeDoO?=
 =?us-ascii?Q?LKhHBFHwUlVbQofXUPST3QS5Phw9H5+dxDgNaBD8aE6lNPU+cUW1V9qQNnu3?=
 =?us-ascii?Q?xg0KFkSGipx/ApFDYyee+WuuZ8CqNea0Z00a+BtrxglY9l4w1fRECREWQRtq?=
 =?us-ascii?Q?Ceoo0hzF+5SiIWMPI4LhMH2izy0Hrlh1I1QeL6CQiGxN+bm/sycTSF+Vmnob?=
 =?us-ascii?Q?3eCRZMenQHCwiPXoUTdVsPZgg1gsWJczcrABldUFidltjgUKk4KgEQzz5v6k?=
 =?us-ascii?Q?CcKQBvkXn5/GegtbwbvJrFrYshDYuvj5qtCUefZsDXMFQGyJCo0awW3RzASJ?=
 =?us-ascii?Q?tRe3WPx7jpVucNrlO/SE8eBaOlt/aRMDE1KgR9iM9ekFRDHs7s3lNkj+qoKQ?=
 =?us-ascii?Q?2ZPiveC9kypYB4E=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?WuTH3LivmbnEfpyjHQosiiF7yw4XQtcTRzbnWZeEcZuZbhGa4niFExl6hMqy?=
 =?us-ascii?Q?/9cr+1xEiXPyA1efSNUP1ActgxRXTBGrhxILXAvUY7FbQ3VytRVFW6sZlu8h?=
 =?us-ascii?Q?pwWKeI+hTF0eJmmNzWkGRvTPh8dyVPWMIVD8iK8AS0/FLfP8gjjMU30p56vD?=
 =?us-ascii?Q?2l+1J2ad2pGncoDcr/3OZO62cTKxtch6ILE5Qbu+wPvG0HgIQYAb5nlQ9OcD?=
 =?us-ascii?Q?3+t8NqqYhcvGGpoDNcSLW9Z/L8fl299XLgaIj8xpuOy/dZk2xVpJCSM3aRwy?=
 =?us-ascii?Q?4If2QmBE943mYTusGw/GfYr802kYJFg7fEJpws0m3m7RQKC10R9hTP/q2AAb?=
 =?us-ascii?Q?wdtxrDRNneUpCLL402uzbytcQWZdA0ejnN15NIeF6cqAlYqfVMGsMa1dabMk?=
 =?us-ascii?Q?fQJXtSUWCLpiFGH3sTjVLZe7sA2wT1An7+Fq0+1xEcCTesStzlOIr9YiHvPY?=
 =?us-ascii?Q?TYsUd/+QhR0/G3M/XvWiBurYL4qlxZ+AYIiKsv6KTrCxnqHc164eltY7WWLo?=
 =?us-ascii?Q?EJdvomz3BQzQFPvd4GBMxZ25LRCdjU5R+4m6LAxH2m/L48JK8JnVRoWeT/jR?=
 =?us-ascii?Q?5hiQFGTYne0ngv0s6QoMTbXG1dsypC/FMarMV2blpv+PqMOU0s7m7PtX1n/j?=
 =?us-ascii?Q?E45o8rU3+okpi3xvQUT1qc0YdzojTRVGGzFCrWpStcVCrE6xlXBizRPyhrxE?=
 =?us-ascii?Q?fy25dMuNlwALnvW9RcqkI2Y6q5KNSuk7msLVb1+L2ZITNESZ4KI63ErI/W7t?=
 =?us-ascii?Q?7drM2XfUjmvJ+ubWnBBi7+jbHNfFveAS/n+EIPMAujzt4VMZ6c6pBnfHHeIG?=
 =?us-ascii?Q?gLw8XiUdP/nqUjAv3/25UGQfwUWydDEFS0sp3uLXkGbPreTnnTae0eSMmN+m?=
 =?us-ascii?Q?zkFaIgGjoS7unRzXyCG78xwwhbqB1WlwCFMb6+NJgf+n4O3mcuHZ5+1J8iYN?=
 =?us-ascii?Q?fC2fcU0ltz29+dd3hyPz6y1F7ZUHWpO8cBznGXueD9BukWkEZHQM5ot+KjqA?=
 =?us-ascii?Q?gn9aOWJ4Q5Eb292976UDmvp8ZbbrGAEbbLvrczhuBfnZMrcH6SirVxZjY7zH?=
 =?us-ascii?Q?2NUGij43IgZAtIM55WeVDVCUXmmi2FPShLF+YbV6RVdvcZKw0SipvZ98ookC?=
 =?us-ascii?Q?zsmiMB0aeoIGH9CpWsOyya6U/D2SRL2t2AfqfBOJr7oiuis6Qiqg1m8Oyybj?=
 =?us-ascii?Q?5HzFFaNFmLwWyeJp27jF0eh5WHYXJrzzXMR/X2Kc3Y54SJhoswJGStDqyN0e?=
 =?us-ascii?Q?zueOnrDWuKHXPU/XAhyE384KvkamGXZBHPpaw01HKFV3iiiYxh27NtBF2kxL?=
 =?us-ascii?Q?F/5UrsUv4iZoEKBgbHIMbXjmPTshTvbkffmD3X5xNhNlcAxczwNQ9lA+beS0?=
 =?us-ascii?Q?MBEmv2avED4q5j7OeFPvRIMWcsnfu/cbNO50uMn2fVc4tt9u87HLh94O68Ol?=
 =?us-ascii?Q?WOnQhvBirATE9G0cA4s6kZ6yOUJgEsDgvg1jE94Qu44JXc4zNzd3eDSFkYyX?=
 =?us-ascii?Q?Csv0h/4NvU3W4LgrB8fk4f2PpAxyBuvLaTlNvuxYSfEEP4st1T4DMSb66c35?=
 =?us-ascii?Q?ePqsPMiLTzQPGdNzZu2qYrqqVY2TviPzJ9cEDfYRH8N03wgT84GPVYMy9wdW?=
 =?us-ascii?Q?uuckHdzKz0OnX0xTV5CLTbQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12F66A5583236A4BB020FD1EB114030B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UOtuHM1aOrEH7JljAkFgsT3TrWUcFpaUVfLDSwU9gRVeT8HFNJjDwbNC8gs3RhLMlEKw14huFxDdlBQRdIe17/sFBaqnTtShPD8WfUHgqnqIfmLdqzYriOdbQrKFxH4I0LqesCy/E+6+BRHdCdmPMxNhJ7FyykyHiqGRXQ7wW4ZpfIIULPPinkqLfL3+it5bfay62I1dsK1u0z3kwPJMHuAd5M8RfthQjdAb6TBTJ9CTNkjl9GQIvTjQDUS5Zjfesb8ilJqWVKFRRCet03jbzj/2VZ08MDg1+CliqeuCdRWlWQj9tAwxxDuKhrszwhwhu5Rj/rPvLaR2dgy6jimPewqEFbfMaUNXP6orwA2UBpPzZE8hMZqtC2NfLDOr8DK5Y06fMr/g/FetqczAct7JddVJW4GBunV59zm34EipjVGmOMpGxvjwFSxcJ7l6LrGFQeIv+4HRDtYxKgTGlEKAaZP+tTNokuYf0ox/pwT70P+rRgfUu0YxYA2MNx5JEExh86LnAppCLg4RWAktDkM8+Xa9xzYZUyVUBoY04drz9iHomlIJMXRfM8ST02XLhwok07oy6xJdtfUO29gNG2boWLcIvULkX31Do73wo3bpanplo7ry8XJavF3RIhOwoYMu
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350a8b9a-3504-4271-25d7-08dda3fc2ab9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2025 06:42:40.0041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /sg1xGoMeCMlLREcx4LiVOaOIk/Lrn5MueWb9ISxRAoW7Rp+k2EG7cpzwmUleiBhwRmb+6XZLRulW74mfcO+PDd0LMZ6Prn1FVTLRrUha1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9328

On Jun 05, 2025 / 08:16, Christoph Hellwig wrote:
> Ensure the file system hasn't been shut down before waiting for a free
> zone to become available, because that won't happen on a shut down
> file system.  Without this processes can occasionally get stuck in
> the allocator wait loop when racing with a file system shutdown.
> This sporadically happens when running generic/388 or generic/475.
>=20
> Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
> Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for the fix. I ran fstests twice on each of various zoned block devi=
ces
and confirmed the hang did not happen.

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=
