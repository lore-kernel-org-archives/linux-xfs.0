Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6842CA8;
	Tue,  8 Oct 2024 10:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728384739; cv=fail; b=Zw2IuokH1dKCynHoDJOPan2RjT1ul6AEHCLz8Owh3/wwTYYSJZ2D5jm5GbOxjY+DRpCyhrUmyceYV8FxWGQBrA5jfeGqVmfNL62QLeRLG8TNmtLsPqVPsHP8I7GFAzUc+n3BZTDUzdLhOpYLgy09QGA2A/HUJPVnha1a4/LsuRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728384739; c=relaxed/simple;
	bh=frpmCQa/61DcSWQKsBKa8tHrMCFPDkyMDBSNwUnXzRc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Byx48ALGrmSqgLXVwwLv+jtfH3YA5AOiU1zR9cDxuD4n/uk20q8ygGOhfLpNizm39HVufLBZd1C/3+FhkKaUjY/JoM42pE7WNva9Vk6zvl+RHypddmK98l+n1dtODY2nFSnpqoshoWwtGt4omx5uEoNhlLfweIwf5Na/Ai+BAGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ikTmpvmk; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=a2LVr+/O; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ikTmpvmk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="a2LVr+/O"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1728384737; x=1759920737;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=frpmCQa/61DcSWQKsBKa8tHrMCFPDkyMDBSNwUnXzRc=;
  b=ikTmpvmkhCX/X/v35DHPrx99Y0BkjFhkawargYVZASDaZbvQ9/8ZJ/dH
   RG9/xcZQi/zcoNnz+Tayggkylwp2DHctXsfGo3zBcMV0bGHK5kquMc5Mb
   +OoB7rrk6SYAuJskeVkomQZUvwBiB/5oPWQKj3O7UUt6mrZcviB9EXba1
   1xwzTyR2MQttW1hXILU5kpc4gRsv2+pQc0pZaX3nvo0mKMW7xlqbTdpWx
   QL0rVnEIxTdTdFJz5T8YQPJNS8m9KiVjTdsbw6D6s1G1XwBvqdmIpwAW5
   w7XAC9AgmCcR+Vkm5WXBJRlV/n9SR8es3a+0voKqIsLcDxCyMV1HSUzkI
   Q==;
X-CSE-ConnectionGUID: X1j82LKXQ8iz1yf5CPezLg==
X-CSE-MsgGUID: zoclcAFyT8SxaenPZml2pA==
X-IronPort-AV: E=Sophos;i="6.11,186,1725292800"; 
   d="scan'208";a="29398712"
Received: from mail-southcentralusazlp17012054.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.54])
  by ob1.hgst.iphmx.com with ESMTP; 08 Oct 2024 18:52:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/krIrA/bffVAFJNzJLi3ijfPFRONIaFWQESrUXGojVBTBrXetDkGf7458dQc0W4v5HuIMaEec2/Tvp0YAvGkp+Jfe3J66bb66bbePZCROz8fkkhZhaF/hjYq7dbP3I36KouPzkq1mmsSFoV6XdboQJKCVf+rJbgkW4nw4NPI6i1ixlUqzDWTw6kFMBJZFGTEDhebwOB+1X2CF2fVq7QVESEK2tT1PIRynI/1k4AtZB7maPPSqh1eOGEttfzXs2Q91RKK+j7m8teZnzihKMmn9rwTnEB5+3/PPcBEAdb5OOX+1KlCdVgcxkiUDLkYaeqzdu1Rh+4A47slIF8DVy2Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMEdsm+K1Dr0vaZo1ScEcvqX+J+LrsLvq9+fiXad0ns=;
 b=FRH/KdbzIKv6qyLMWoOzqegRWMsQ7nA7n9X9FEg6n22P4Vfjn9vRRAxzNV4cJ3urWZ/o8xFM8rth7L1a2jj0J1jUT4Kw5541fKPUb+RcghSTiPOJB4V/2DffPMdLeBq7gXMs4EKqSXW54hqLrXOloo8uSr1k4t2uTZUHzjij6IdsIZxmpCCUTr7y8Bq7Klp1bTyuW8vtRhdz5ZZb8o+9st6wjhOAu0VcJG3j9z1yADnpFYK2fT8OdHWDGpvObE9ahujgzK3vxM830Y3jKTAB3yTiKWNWZ8zpcAmzpAfUlBMrm1UY9NRZGzHIW/Q3LdNV/RxsnDX39cWqNhoW9mofQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMEdsm+K1Dr0vaZo1ScEcvqX+J+LrsLvq9+fiXad0ns=;
 b=a2LVr+/OphhKsjYNwIgky14fYCmcgIYiq8TfHqFfafFcZp4TSmDpGuFl9G5mR6tZ121D2AO8/2OIVw8L2Ni2Fi2xKbR8uHA/B1ZoNoBOToDMcB+ASwV2W9/N1H8eSvBS9MG00XRJ/Vkg+lN32aH+6lcFEz8MiECFaeJ7Y9T/xTw=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CO6PR04MB7553.namprd04.prod.outlook.com (2603:10b6:303:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Tue, 8 Oct
 2024 10:52:04 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%4]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 10:52:04 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "zlang@redhat.com" <zlang@redhat.com>, "djwong@kernel.org"
	<djwong@kernel.org>
CC: hch <hch@lst.de>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>, Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: [PATCH 2/2] xfs/157,xfs/547,xfs/548: switch to using
 _scratch_mkfs_sized
Thread-Topic: [PATCH 2/2] xfs/157,xfs/547,xfs/548: switch to using
 _scratch_mkfs_sized
Thread-Index: AQHbGXAcO8L/aUmkt06VOR0qHTTj/w==
Date: Tue, 8 Oct 2024 10:52:04 +0000
Message-ID: <20241008105055.11928-3-hans.holmberg@wdc.com>
References: <20241008105055.11928-1-hans.holmberg@wdc.com>
In-Reply-To: <20241008105055.11928-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.46.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CO6PR04MB7553:EE_
x-ms-office365-filtering-correlation-id: 185d15d9-b299-44ed-175a-08dce7873f56
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?t1d6m4v5OoYFJlnXiLALg/Qpro5aN6DpY17GK9rxjCj+VG/Z2pUreC9MN7?=
 =?iso-8859-1?Q?uPxG/SlZfdvC+9DdLfKtplhos7ArpdbpKIxG5GgexPfsrcXXWPRcHtswJH?=
 =?iso-8859-1?Q?AuqVZ+epGCptB5CoACqR6CngHOwJa0GDZlCttLG8G28l/hGLTqf5jXi0Uo?=
 =?iso-8859-1?Q?y4WVq3rWBXw2BULbNt8Z+x+PuZjPwYIlZZzH3wgQUiiEK7Z4tIeQAAF8f8?=
 =?iso-8859-1?Q?kKl6zEiHJZqNl00mTvhHJ0XO8S+ZsaXFzhd38JBq5RlOXQg68OLiOxiw3Z?=
 =?iso-8859-1?Q?4j362BkKHWiE+I/rfeU+IHFCvpBkeDxfo+Ech7PLefQNN64GO8CrDqkmbO?=
 =?iso-8859-1?Q?8kGTodfSNI/kNnurU3gHe/0WKZ3zxxOpSd4SkOZ4+niny88OSHmQlfOXw0?=
 =?iso-8859-1?Q?vWX57pjU4IiFucwwle8MGgpp3D3Cj88pKb52ks+WCxCsZ8IlDfhbBvnxrF?=
 =?iso-8859-1?Q?cWk6FZrDrMYyTECRL17PVzEixLhpdx6BKT3E6EPSXgWgevPffp9ig+Iwck?=
 =?iso-8859-1?Q?mHLy8muELsUWBFpnzEABDTG/BcMyUqy9fkCHNaA0bdmopFj9dha8bNoWGy?=
 =?iso-8859-1?Q?EKlEht6q+pFcSHHgZQ5AI6NwvQPrX0JiZu34BFqIqqsWGo1xPQV5DAINRr?=
 =?iso-8859-1?Q?jrJUEYapCtubCoW3lov6xEUhtrs7ThTOOjc7N5FnLImrFzxpK6p7iG/V2F?=
 =?iso-8859-1?Q?cpuIDA0ErDsXu1ILanb/5mWPVpyRc6YpSzzx2btjCrBvcooIyrbm7QFjPM?=
 =?iso-8859-1?Q?Q/I5zdStd+LL3d0dzay4mH0apwMjginY1P1m5rIggxx00n7dKNRlpyJcn1?=
 =?iso-8859-1?Q?SfmR1X4KWfr6S7SbIcL7hD2hYmo2JLZsEhDOAbvRYMuRngGrMT5CadFfXN?=
 =?iso-8859-1?Q?1MOsGjL7NSlrXZKBYy0/MAfrEM7essJiFuKfobyKjglDnvEDOY15ekOpbx?=
 =?iso-8859-1?Q?TPmzkmx8C8nFiu0MwMXIA8X5Ezuya5Q2rlQ19AY8rPxAuepkNjj3TKlmg4?=
 =?iso-8859-1?Q?LSAMIBl8LM0wFsFdxH3ZdXCjg5edzz81VI2V0rlB5Njg7drJDEgwI1uzAe?=
 =?iso-8859-1?Q?zkCha/NJnjRtjzzhNi6isVWg1A02gv1W5ksdv1OCXHvxZZATL6yZuEoY+6?=
 =?iso-8859-1?Q?N77sNEvP9aRU7y8A1w1fyTJ4wQ2oIfPeRImhNTEs/AwdZFfJR0Q0MwCaQG?=
 =?iso-8859-1?Q?nnJqN+3tFumF0zeDdyO0NrIswjE+Fh9SbkUYlDfthIIxeK2oYttY2DwNWv?=
 =?iso-8859-1?Q?Hp9NXojzc9GnDKC0TyPKoUpuNZM8itOAPcL3U4JmUxKnAgOY/Trob7+a9m?=
 =?iso-8859-1?Q?zHivMA5onogrnXF6tszxkDKDM95ULS8HpgMuXGnFqAsFywuYP+9X5RWMkf?=
 =?iso-8859-1?Q?b5w3tFDtzOaRbh+aCBXxCe3hjwmMWVUQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?EnpdhkJs4S7ugXj+Rpx+Ee3fFT5prYSkzbSJDBlasEjdWjl08g8Xbu1R3/?=
 =?iso-8859-1?Q?T9jD+8qg1Erj3ahR+UNnydL9XHrySZwZSLgZEU5nv11mlXVdFWtae3YKCp?=
 =?iso-8859-1?Q?nJ7Y/ldjXWr/0vdB+R7qEWbWWHYGm51Mgnp7mhLZ5DWqZIi+FsxFBY4fIt?=
 =?iso-8859-1?Q?xXpHrTtv+qujLH5zZeigFtMHLTftrvyhw6qr3dy3RzrkLuRMm++SDh6HnL?=
 =?iso-8859-1?Q?Q9HkFriV9cIxgujt2FTz/nBe0ybVVi130nIU7yuvxohr3g/Xdvoq1M4uod?=
 =?iso-8859-1?Q?kCRtrCP6YVDkh6W/lBLKs0ZRLt5f6BoEzAzsN0Bcug5HO5ehVtfb3Z8Q7O?=
 =?iso-8859-1?Q?SETSVlHrlKvxbwuWozkKdOCxEw3OeTq2xDpc5C5babj8vhX6+Xou0bNMvY?=
 =?iso-8859-1?Q?5V7bgVCz8JwgvKXxTVg8OvTB2aKo8k0Hv+jHzvCs7epl4gJLhcRIKNcskw?=
 =?iso-8859-1?Q?jKDDfDetCUWJJ+fFW1tg10T1xcxEqicleyJ5ZiwjVgF5RZ1l4hSy6RKVM1?=
 =?iso-8859-1?Q?eABSVdR6/RQLF71ievOUEacHtk868qUtq+nzmGMef81dh6UcDvjJSu63Qe?=
 =?iso-8859-1?Q?NkzEpkKTmPjuWVLvi+kPkxsRg7gMZ6SttVDP/kvfc3PMcRGEHGCyMCuzcq?=
 =?iso-8859-1?Q?41O7cSgIyuTwK8Syg43dhJ7gizmc7zRAdtcw1tZANdEu3UDm9vAsBojnmo?=
 =?iso-8859-1?Q?qrr6VyHwRAG7L0+FmFzbENkt9470ipWYuhls7s5hteX/JdymqwKdIKMlMX?=
 =?iso-8859-1?Q?kQxKKrxlqVvqa8JY5mbdG/WloxfgHsGqUzIzN0us3t8RtTtXUhFcHO0y2g?=
 =?iso-8859-1?Q?jJLvsK3X8HMRdNrCi4/4FuTy8m5gzE1UJZPBZbnNhsfJpsZAHY6hqneRMr?=
 =?iso-8859-1?Q?Ubg2+fZqk/SUYvWO/BsMxfNpXkx69iQKxzRFa9vn1Y7Q82Pprtqw4FERVv?=
 =?iso-8859-1?Q?a8oq0EX5phjKxeX1or0L0+JY+BlUYJ/ktYjMsIhU0RWYyO8oFpvsTtuWP4?=
 =?iso-8859-1?Q?c515fVVZZWhhCjYupOpisAlIuLjUdzl+6cDLobe61Jnm6YLx2Cb2SCoqMt?=
 =?iso-8859-1?Q?Feo1l3OdQlDItXag9C0nPlbuMdsqwnJ/Xv8FHH648hPCG4cLlMDEHrojBl?=
 =?iso-8859-1?Q?qdge2UeWYTLnuSapxPNEJbCAx9SC6DOOrDlPog9STjr/B5wmbhlCzUvilQ?=
 =?iso-8859-1?Q?vsHYtqYal4zffgbI9WuHPO+ehbkpPZScsC/tZkgIzM3IaJxuAh/V/us9pS?=
 =?iso-8859-1?Q?WSoekZYjyctZ08iMk4JBWnoeC6OJfkXMJfMf2Sr0mHY65vEXaY2VIuBhh1?=
 =?iso-8859-1?Q?EOeih3KwP4uovPBgbD5T09gQalXf2Bj1MfCGaVcfqXYZAdHoAxOqp5XvU6?=
 =?iso-8859-1?Q?/wbs7JPUO21HeWPMi3EkcRwf9RLLllAcAhZUZroViU1SIRDIiTd/jyhjJY?=
 =?iso-8859-1?Q?WggkFkAhfWbvTNnJG4b/9NQtmsszdDK+kWN0IPsE3s1PWPnlRoHWtxxWG/?=
 =?iso-8859-1?Q?+x5vpsM+0/Mxdr0+ai5flWoWKT1X1OlKLx4lNg7UuZBhRCJqeJ6jr4mCTk?=
 =?iso-8859-1?Q?t0GakceerhbbR/Fe1tFemC3gMTyGaEr4wsrQoA5AldBzIuuVsMbwz+j09l?=
 =?iso-8859-1?Q?pUDuMZtRejgkJ99M0sF+s1RQRzyjhlaXbQ?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mOmZJi2b9w3wVVrgp1lEdNIQEwyQ1YhAMSTH90qz2l3sYVsEdnifx60S2XoK+haP7fHxuGeRmoi8sb94t2ADbZ/WsWpWmduNETXTQ8PjbIJ0UQZ4K77SLK9jLZMYxcxa6GSkqElIfzdHtDi/PBznPxN61NJ5fK4XaBu+gywQEBwahkEhO//MZimP/y3KEnzyAbpgzqchNf+NKr6Tsx6DE4NIUM0U6Bn1Njy+KO8/sYUEPXZepVHENJBx1b/+BdsiLWlNsrflX5Z79wDEgLRPKahp0IL8J8mGylA8o1QMMjpfHMY8ttORAi5J8nvXVfDgJYskJ23TpAnPeb7rtqSV2GgvAvdNkvZZdqwo+f8krSSVdmO429MYsor8uZP0+H+UGfnaqiAlPp7H57LAcNjwlR8RNE2py9QXm2vjxwJuiqEjFM3Qoqyb8EH7uZT/b0uv6wLlQ6a9QMitz5wKixCZ2jXVkkfqhUUc+3whXzr9WaxQ/B66rOROo7djLCqx4BHEPO1vBUal8oWx+/qr8h8/2iTSdBE6VfVfAcSbn0YvqGUyNU3yqQJUi3Yz2uMLZXeLnUCRBgaN5exoQOqWKjKpXmiKt+gLutF1yusuJ+FSG5YWwh6cy0tVlK9eqySIWN+0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 185d15d9-b299-44ed-175a-08dce7873f56
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2024 10:52:04.8600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gYf9Lzj/rOP6DBQt6tBnT3cRxG+BkyR5Vueozfs6omln4gSIZ1YwNST7HDNxtUrJNhNaG3NWfXzb0gyZ5sjdVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7553

From: Hans Holmberg <Hans.Holmberg@wdc.com>

These test cases specify small -d sizes which combined with a rt dev of
unrestricted size and the rtrmap feature can cause mkfs to fail with
error:

mkfs.xfs: cannot handle expansion of realtime rmap btree; need <x> free
blocks, have <y>

This is due to that the -d size is not big enough to support the
metadata space allocation required for the rt groups.

Switch to use _scratch_mkfs_sized that sets up the -r size parameter
to avoid this. If -r size=3Dx and -d size=3Dx we will not risk running
out of space on the ddev as the metadata size is just a fraction of
the rt data size.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/157 | 12 ++++++++----
 tests/xfs/547 |  4 +++-
 tests/xfs/548 |  2 +-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tests/xfs/157 b/tests/xfs/157
index 79d45ac2bb34..9b5badbaeb3c 100755
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -34,18 +34,21 @@ _require_test
 _require_scratch_nocheck
 _require_command "$XFS_ADMIN_PROG" "xfs_admin"
=20
+
 # Create some fake sparse files for testing external devices and whatnot
+fs_size=3D$((500 * 1024 * 1024))
+
 fake_datafile=3D$TEST_DIR/$seq.scratch.data
 rm -f $fake_datafile
-truncate -s 500m $fake_datafile
+truncate -s $fs_size $fake_datafile
=20
 fake_logfile=3D$TEST_DIR/$seq.scratch.log
 rm -f $fake_logfile
-truncate -s 500m $fake_logfile
+truncate -s $fs_size $fake_logfile
=20
 fake_rtfile=3D$TEST_DIR/$seq.scratch.rt
 rm -f $fake_rtfile
-truncate -s 500m $fake_rtfile
+truncate -s $fs_size $fake_rtfile
=20
 # Save the original variables
 orig_ddev=3D$SCRATCH_DEV
@@ -63,7 +66,8 @@ scenario() {
 }
=20
 check_label() {
-	_scratch_mkfs -L oldlabel >> $seqres.full
+	MKFS_OPTIONS=3D"-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
+		>> $seqres.full
 	_scratch_xfs_db -c label
 	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
 	_scratch_xfs_db -c label
diff --git a/tests/xfs/547 b/tests/xfs/547
index eada4aadc27f..ffac546be4cd 100755
--- a/tests/xfs/547
+++ b/tests/xfs/547
@@ -24,10 +24,12 @@ _require_xfs_db_command path
 _require_test_program "punch-alternating"
 _require_xfs_io_error_injection "bmap_alloc_minlen_extent"
=20
+fs_size=3D$((512 * 1024 * 1024))
+
 for nrext64 in 0 1; do
 	echo "* Verify extent counter fields with nrext64=3D${nrext64} option"
=20
-	_scratch_mkfs -i nrext64=3D${nrext64} -d size=3D$((512 * 1024 * 1024)) \
+	MKFS_OPTIONS=3D"-i nrext64=3D${nrext64} $MKFS_OPTIONS" _scratch_mkfs_size=
d $fs_size \
 		      >> $seqres.full
 	_scratch_mount >> $seqres.full
=20
diff --git a/tests/xfs/548 b/tests/xfs/548
index f0b58563e64d..af72885a9c6e 100755
--- a/tests/xfs/548
+++ b/tests/xfs/548
@@ -24,7 +24,7 @@ _require_xfs_db_command path
 _require_test_program "punch-alternating"
 _require_xfs_io_error_injection "bmap_alloc_minlen_extent"
=20
-_scratch_mkfs -d size=3D$((512 * 1024 * 1024)) >> $seqres.full
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
 _scratch_mount >> $seqres.full
=20
 bsize=3D$(_get_file_block_size $SCRATCH_MNT)
--=20
2.34.1
