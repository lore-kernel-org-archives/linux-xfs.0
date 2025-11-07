Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650F4238150
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 02:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762482537; cv=fail; b=e7JSTghlEt/ISx/ZS4f28v9cEn6DLxoviozCbTRwwR86GRRnuxdFfQs0JtfQe9y5KkrnZsjoGfoR+QvSA4JsCBmrQOUd5l0I3102M7xNmOkAWy8OgCgNyZdThWwY9/qV+SEeYmV7CKAJl+hAUzQWF8G7tf3ZVrLq7+zEpP8wkBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762482537; c=relaxed/simple;
	bh=TBJNDyNu2PY8xrnQ49eZQ0RBllcbrYF8jssXasP2hm4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ra9P/mceDcWYqPjWQWdeJTV6PHUUZPByYeb7caE88DdaOBiTsBxRieyt81vUuh5tToZcH0u6MiUVdDn3xe8eQX2P07187qj8kbqqrOzTCNLyZr48835Veq/0G1eN+ocrEO/7J9AhHLEmh+dj3kNWnGrQ789YdnDNQiiSCFwgcws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hpY8mC2J; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=D4dVmUb7; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hpY8mC2J";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="D4dVmUb7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1762482535; x=1794018535;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TBJNDyNu2PY8xrnQ49eZQ0RBllcbrYF8jssXasP2hm4=;
  b=hpY8mC2JsOTKHgBxiqo1gXym5HedOz2+NISTZ9p9iOgatWk+pgxrDTIw
   mgRve6VRLhnlyaq/Lp5pur5qRdMRzekMhXrgVvHazn9IYEkpzEL9P1o+T
   8/ZSZEMafx6kIHiBrODo8fvrisKyONu47g4gbGjbnzKcjK6M2oCfiXaSb
   GhHuXjDMzDVHtPUPuPwzkhSswljr5c2C/dqaZS5Iw6F2oQIwGD8jf4jfo
   8GOIzbvpmB+3mder0ZrsaGn/LMhVGt0YMm0X2o2aLNOBpYYKwnhEaWtmL
   Wkc4/ftrFwil2jfbJ2YKRqnhUwWPpvD8brkVe3P0AO4j2GrKtVh4D63mF
   w==;
X-CSE-ConnectionGUID: Sg+8XYEKSKGUXMMiVZ5ZSg==
X-CSE-MsgGUID: K5uWZeh0TmmcXqSrTML+8Q==
X-IronPort-AV: E=Sophos;i="6.19,285,1754928000"; 
   d="scan'208";a="134686330"
Received: from mail-westus3azon11011038.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.38])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Nov 2025 10:27:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vaGO9jbYEeOd4dp+VzeaReZwUOmsRhPiYMXzw2pNxgorWN7gaC9f3UWqcLGeoXVCg//vlHyJgk1olOQw/Blp80jOkPf7rc8eoOO9kqr1OTEV8hT7JH2A+IVqZ4Xmm4NJ33tFW1lXWNsfM7ZSPDnWJPIfx6+3bOkgO55MxlXYVdTM2aRZjxOC3k9vGlLc0n458B2mklf3bLmloNZ38xWkfJrFwDrcneWlIusJ9VTMDKPncEH8aHhIfPzMpIKNTmQFh9QBNjoCmCdYm3lO9LP+gFwBl2kwL11sd0ltdjEGVg+Vfyls/q/xTKic4kRmYb3C1hRnU6NIlmf2KeSN1igwQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPnDNN65bmBdYVowW8wQhuSJMBWqATKnY4/l7x6o7Iw=;
 b=NvOMepnGq0475SccfLd5I3pjdXjzrKRk0ds/J5lA+kgzWOTFShzPuBKzqdt8Kew8cTXs2Pxtc4oHz5yT6cJWKl3+DgPCPyg0H85gRYKjd/Akkhnoug8hExB6gJPGim5iZcSjU8xuiSFEz27x5JuGs3VEZeXp0Z4d59JJVu4uFTlyjZJ8qW8ylk7zIFRtjj1c7gfbePlErRksUGdhdjEuq8iFtIjV1ORsLwpnaS9u8EtP0LwRPPfAzFxkB/+E7NFwuTHAWggQDpciSoK6fDRcgHJyjqxNm4cr1fUxOC48uiLR9LZSop22p4/tB0kms615KXTVEKWRq399EwzefV8sfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPnDNN65bmBdYVowW8wQhuSJMBWqATKnY4/l7x6o7Iw=;
 b=D4dVmUb7P2kOamVPHEvPT+JC11Sp+PLnv1Lki+obpLlOnYq+dtnfjqbVOzCXe5VO42eMqg5VbNRiaBRs5JOWLWgulK5Bs55gwfl5n/17nhvSZ2pNFcWYIW8sNSQyijUe9MvaMGtoefX1RJFjaYZe4Vq/6knbldaEaSQgu9t2a6Y=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by SA0PR04MB7227.namprd04.prod.outlook.com (2603:10b6:806:ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 02:27:51 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 02:27:50 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: John Garry <john.g.garry@oracle.com>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
Subject: Re: [bug report] fstests generic/774 hang
Thread-Topic: [bug report] fstests generic/774 hang
Thread-Index:
 AQHcSXl9LlvNthA6Oka+c9m+4a5IsrTjRJmAgAAdnYCAAG3sAIAAHemAgAAgzgCAAUpDgIAACXaAgAEms4A=
Date: Fri, 7 Nov 2025 02:27:50 +0000
Message-ID: <cc5yndgo6enxwtnwvcc26wdoxg3wdnnzie6lvn2mttrzkeez24@6sk5qlhlrozp>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
 <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
 <c690eebb-ad51-4fc4-b542-58d0a9265115@oracle.com>
In-Reply-To: <c690eebb-ad51-4fc4-b542-58d0a9265115@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|SA0PR04MB7227:EE_
x-ms-office365-filtering-correlation-id: f90a8f5b-b979-4ef1-1dc1-08de1da53fbb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?NvkmOOM+L35vTJ6x5fJd9vz0STrQkEb0Am4Fqj14bp5NBzNG+9l909bBrfXj?=
 =?us-ascii?Q?a0tV+wA5wkCZaGjwqLjQj8UKDn0PCQTS67eGPXGlRUmNxkDF0gcIgSe4C63i?=
 =?us-ascii?Q?LIqn5AocZEQfLj/wwtGjm/x5DueC8TpVk/YMA1L9BMWJXdCoX+S8v9HVV7co?=
 =?us-ascii?Q?vEC2hQyV3sVe2cAg4bcd1EvcF1V9DcWs2DWCXJlGAGRudMIrWG+UI+Rk0Tuw?=
 =?us-ascii?Q?v0kV9RRcPf3MDcbaYpkNAUEGodFUaZb1JkCJv2v8qq4TUoctms32QhCsPuuG?=
 =?us-ascii?Q?2QpDUaDma7Zsc4iMXqMGGAaDxD8OgAa0v3wBnYtUFB9Pk8Wq/bT5ReaAtKW7?=
 =?us-ascii?Q?vLNoOHTI3QKy4r3sjulVwLwq8zUbNsZ+aZfYtcNvXRfmGgrEMDBtAA13aIux?=
 =?us-ascii?Q?DWTD49r31HnYTT9t8A0UPhyLVDYGjTlWOPcoOwgqxUpDtCeUOjlucj0bsjkS?=
 =?us-ascii?Q?ZPdfDSswjysrftNKOubTh5HD2A9n+Q+b0jXBdluwehOKvr6a5U+GQ8DuBx9G?=
 =?us-ascii?Q?nBOHH7HXXx6DcQ4qdK1x1zAu6zxW7KNCAUQ/D+c2CEhYA0I3FWmTcLzPgw7R?=
 =?us-ascii?Q?pI2Qb3bW7HTf8ulyEEXlsGvsopfRTkLtWcFiipJxXCvweiD/2dQZmiCSEHNS?=
 =?us-ascii?Q?354/+gD4wQ972nOVZLpGwb/bmjJ6iCg9ZUvTK2S0Pi1aU/Npf9iecqJvCwcz?=
 =?us-ascii?Q?lmrzpJmfVU5w3+/3vZEE6qyU6gxFFwEYt+bBItrhPfB0DdbS2BtUDPVlyBRw?=
 =?us-ascii?Q?0PoW9+pfNKdicVA3IK5O3oBaPfd3EeVTndChp6hWT9Vjimr5CmGDhY7cneb4?=
 =?us-ascii?Q?RUKe5v7rqJFJ4cD4EQswZQDn8tC1qkSUtOEJnayy0Hyk6LrftQJ/AsDvFrOV?=
 =?us-ascii?Q?Zisdq5Hm5POf1X1sd8VRzUBQwAOpEap2Q9AgTrNQJM7VFe5+Pz4aHyRv1pYP?=
 =?us-ascii?Q?wVv1542/OBXIeoNVPKpiskYiMHFRKyxQGy5mpalOeX+huxUag3TlixUm27iE?=
 =?us-ascii?Q?oZQOjacucHb8tawUNHcjTINa4I4fUHGT5942jL+K/AunRblMv9b+t8g9+Eng?=
 =?us-ascii?Q?IxixM8OESNu39u/MJzOwr1HxD90T3cCk6KvdZflImLpFGQAvTHk+cLDFoxic?=
 =?us-ascii?Q?xo4+53EuaN+c0ruiSF0zwzM7v9248A5IQu/x7vwUXyf5Na0N1MOxblcX+EYF?=
 =?us-ascii?Q?WL50ux7IuSefFOuyvOokxPdUUHDvNfoQtHa+4fQ7adVFo9yPNeRtxTS3bkI5?=
 =?us-ascii?Q?QXl1qM90inVQ6ESWGnNQ2sxiUlPI1ajH9Tfctg2P5++jSjVZDgMPV6+hwcOX?=
 =?us-ascii?Q?KnAEojh9T3EUi2Is3t2W0KMQtX4iCmnMiHl+E3cAyhl5UGC9Ant3tabUQcCC?=
 =?us-ascii?Q?c+rQOPmoBb6F+VsStElJyxV81DdUCw2FHF/XEez7Ze6+IgpPwIGUxo5RavSW?=
 =?us-ascii?Q?lhS31yyRYuVs5cENqhTTpf8I5EtiinpJ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?vpzR9GyITqygQtz8wM3yL7VGnouQPiyT3LSfF7Jwg5PWEGolxB2mZRsUcyaY?=
 =?us-ascii?Q?+zAFxXiUpZO01W49ElJ+nCkQgBhFrCIn+ACZqVFcuQygg48g+c/PRxLJ7jFX?=
 =?us-ascii?Q?FiQSwNJlbpEXIX7kpfyQyBKmuaJS7BdR88zYk44mbqHlwuipdxlkWqv7lEdH?=
 =?us-ascii?Q?Z6lOGlJgsjnurWNUkhTFff567/+K+a5joLkcqgjk2N3n0DkC9Zum9AgEuhJJ?=
 =?us-ascii?Q?DQeCCDzNs24M9ZmDcpl8QN4Tky1YFx8XRiiaEBzFuBzqPEddl/xR9NCom0wD?=
 =?us-ascii?Q?W2ubFI+WNGRdQoYRHX227KWb8e+UnKQHSm/gEZSNMDjuJ6ym/KoKmwYdR4Dq?=
 =?us-ascii?Q?32qXGWt36gkknuTrOw54BAyQ7RZW7qhsT6OUaN0OVswIQJtgjGpoT4EKwDRG?=
 =?us-ascii?Q?/7T23uDo2gqIZdut2B7zsqdzZWm68AcTUj4G4YrRyKbGjLxiqOUSQGCNYRPU?=
 =?us-ascii?Q?WtCskFcG1KdvWNYnUgYr6JiMwpVsXz5CbcMgfhUkqYNTRBG7Xb/JLN+ER9Xf?=
 =?us-ascii?Q?6rwEdM4MJTvs4GtjTY8abS/fQ6lo/O76Wrvhj5BeFfjWmuIPvUshoczkAGGn?=
 =?us-ascii?Q?pE/NFGZ6cwvjiRiV+dBHQpBkRi9mUJYwXygmPe5EDSoi1QmaMBRCDj2aPRpp?=
 =?us-ascii?Q?b5OuWL3xGJoaG8+Yt99Mg1SQ2NEtwBJDHjfFE8e7uxtEmYKh/4wJGXyRRPk8?=
 =?us-ascii?Q?3JOwCtCizQXjx03KI0B8QWKLl07kDPXqI5BB0AyE5kSKbpE4xxRNI+3Fvm/u?=
 =?us-ascii?Q?VYPjdxkMei+qp3y/B6Z5AMc1/7XN2NecsPZttaR4paGklslKs/qiwYQsjZjk?=
 =?us-ascii?Q?aukdqhIQqqffFDCtZwmkJW2TZIpooA+BEasO0sXHv0HpkQL0VrN1ev5S7XQ4?=
 =?us-ascii?Q?TV8PgmWyQLRLEsM46ED7sMF6cBJcAZPZbfIlBuT3HEVjR0dUTCJkgJA5Rsie?=
 =?us-ascii?Q?xWggcwR8OpjVfmSoyq3DbeJTbkhtqt+SDortFG70H2quQlBEp7Bhk8gowANu?=
 =?us-ascii?Q?cdYOvg+33el6aEf61vVdrN5O1UKtyRGP+X0ypWDndQV/gFbeE7SvqI22XVuB?=
 =?us-ascii?Q?qg97mp4fIhWzs4SDDdXYTd9CHIUX+JWRph670vhFM0afxQrAcqABP/aiPGC6?=
 =?us-ascii?Q?kqhuE/DSq+5/of6Ug1WmWw8B0kTMBpkt53xirluoSlr7GxcVSUxEol0x+FaB?=
 =?us-ascii?Q?mOjEdZX6+/6ALBCDUrx3FGAyrHjQQv3/6dT9jN/Sw+YOdVvgFaiYOwOVRRwF?=
 =?us-ascii?Q?dRKDtgw6IKcvj9RYITB1giBkHsOGh6ikH2VUOH9WKxv5edL2BuwA8+ImrgX7?=
 =?us-ascii?Q?b29JHVQAtVoASfJN3w0sDnwXAwcOEqJeTfUBEBYpBcX85a/fCRrevV+FuHEZ?=
 =?us-ascii?Q?ZGb3XtABohjkl4UYOgrXmTCQj6mg40Vfvs5oRM3jB8miv2bROxyMSEVlUGaj?=
 =?us-ascii?Q?lYyUW533b/IHutgVpmEqo+3VDUHMkfzavCh8nIB2TKTjz6BpEtgwYI+XXzIA?=
 =?us-ascii?Q?YlNiphougJDx4Hg3XkDN4YFD98IdVDhcn6tOOaXO0LcGigVlhLW0aAA7f3kD?=
 =?us-ascii?Q?+l6Iz1gF2ZrI4BzKuIYv4qosgITD0PM1bkIE6RY3utAGVLkdy2o21wdfJxNj?=
 =?us-ascii?Q?I3NQOs6S2ekNhPv0GUH5D6c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <36C8C6779FEA3E4F8D2C8117C85821F0@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rpO3pz5lgE4r1GO3oxkAGnSWaHWFbBJ2n3LAhTuTXphYeAY7L4/kM9kHSSTGIvLGviTq5SNXxqfkOu4olhSwbdDXUEnBaMdAvhrLmaiImhgwgqOR/78gEpHd/NKk3H0uBezU/up+SWgMx1AUpGTuwgd9FyRpK9ZH8Veq23gL38HGxN0bpUKn90UKz+Vw3mcBzPORjLesX6ja7ipvIRWd8LmuWReaIyCrryumQgb/jUfwCStJ/ttjDsZYOrwuI3zZFxxx+LeT8cLB7OOLjGjP2IkDtrAczc87BHqNJ+EiYMXw3+HHWrpkREmUZ8uHeTGLvfR3T11AqNLX7jfYlouxXpTNrugHrHuWgU72Ec2mOMsbPfaul5ZV9kEtP3yr6DwGzxR5EJMlxNyD3ahIpKnrzDWffXQ6D+d0XW40wqTjae/J3aAOnjQ6ixrG4IXPRfNBylmc1dxCPbFazUhHjBBd+1WIvClId24m/9IEPhZkyjNHrBuchM3OaEb9JOBozAxwS/RRT+ct6+DT4pdKeFWjid9fjuLCX+0Di59sTm+UNMCGkL+AQf3fzCK5rRFErtwbTNXcWzQ4zgbyncTG1OdhIjb3GSide55RtSsRj42P+g+1itG0gva+1Ksf0GY2CYEh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f90a8f5b-b979-4ef1-1dc1-08de1da53fbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2025 02:27:50.9029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QTPpDoLFDChq1AFoMpNRX/pW3jM4E2SZHzJqTLxcv1LHOeuZKfD6I9KjUjcMyHhZa5q4ERFt8ka+jK1/UvWe7OjDR2ZFjEhIV15PRrljJxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7227

On Nov 06, 2025 / 08:53, John Garry wrote:
> > > > >=20
> > > > > Shinichiro, do the other atomic writes tests run ok, like 775, 76=
7? You
> > > > > can check group "atomicwrites" to know which tests they are.
> > > > >=20
> > > > > 774 is the fio test.
> >=20
> > I tried the other "atomicwrites" test. I found g778 took very long time=
.
> > I think it implies that g778 may have similar problem as g774.
> >=20
> >    g765: [not run] write atomic not supported by this block device
> >    g767: 11s
> >    g768: 13s
> >    g769: 13s
> >    g770: 35s
> >    g773: [not run] write atomic not supported by this block device
> >    g774: did not completed after 3 hours run (and kernel reported the I=
NFO messages)
> >    g775: 48s
> >    g776: [not run] write atomic not supported by this block device
> >    g778: did not completed after 50 minutes run
> >    x838: [not run] External volumes not in use, skipped this test
> >    x839: [not run] XFS error injection requires CONFIG_XFS_DEBUG
> >    x840: [not run] write atomic not supported by this block device
>=20
> This is testing software-based atomic writes, and they are just slow. Ver=
y
> slow, relative to HW-based atomic writes. And having bs=3D1M will make th=
ings
> worse, as we are locking out other threads for longer (when doing the
> write).

I see, thanks for the explanation.

> So I think that we should limit the file size which we try to write.

This sounds reasonable, and it will make fstests run maintenance work easie=
r.

>=20
> >=20
> > > > >=20
> > > > > Some things to try:
> > > > > - use a physical disk for the TEST_DEV
> >=20
> > I tried using a real HDD for TEST_DEV, but still observed the hang and =
INFO
> > messages at g774.
> >=20
> > > > > - Don't set LOAD_FACTOR (if you were setting it). If not, bodge 7=
74 to
> > > > > reduce $threads to a low value, say, 2
> >=20
> > I do not set LOAD_FACTOR. I changed g775 script to set threads=3D2, the=
n the
> > test case completed quickly, within a few minutes. I'm suspecting that =
this
> > short test time might hide the hang/INFO problem.
> >=20
> > > > > - trying turning on XFS_DEBUG config
> >=20
> > I turned on XFS_DEBUG, and still observed the hang and the INFO message=
s.
> >=20
>=20
> I don't think that this will help.
>=20
> > > > >=20
> > > > > BTW, Darrick has posted some xfs atomics fixes @ https://urldefen=
se.com/
> > > > > v3/__https://urldefense.com/v3/__https://lore.kernel.org/linux-__=
;!!ACWV5N9M2RV99hQ!J3HKTWLF8Qx-j42OOJ4o1YAttSSoqOCm9ymJtisUYoOtGgOyNNGqHnjj=
l1Zd9DQXJvCz8zqPMG-kgeVdo9MQuupMlcAo$
> > > > > xfs/20251105001200.GV196370@frogsfrogsfrogs/T/*t__;Iw!!ACWV5N9M2R=
V99hQ! IuEPY6yJ1ZEQu7dpfjUplkPJucOHMQ9cpPvIC4fiJhTi_X_7ImN0t6wGqxg9_GM6gWe4=
B1OBiBjEI8Gz_At0595tIQ$
> > > > > . I doubt that they will help this, but worth trying.
> >=20
> > I have not yet tried this. Will try it tomorrow.
>=20
> Nor this.

I confirmed it. I applied the patches to v6.18-rc4 kernel. With this kernel=
, the
hang and the INFO messages are recreated.

>=20
> Having a hang - even for the conditions set - should not produce a hang. =
I
> can check on whether we can improve the software-based atomic writes in x=
fs
> to avoid this.

Thanks. Will sysrq-t output help? If it helps, I can take it from the hangi=
ng
test node and share.=
