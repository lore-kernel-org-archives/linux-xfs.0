Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E6336404D;
	Fri,  6 Feb 2026 10:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770372167; cv=fail; b=M9HhtpBlcQEXpTILrCaw3lcM1s9EuOdZcVIexEg6mW+nm+wPpd6sChCXdBb/tsc2Nw+sgX+NNQSBk0zyfhR7aQPcinR9g9GSFX8Wm/+NFqsI0sO76HCm1PioG3zqE1CSlwJTAUbpBOiNdBolRMZh82ADuvw4wQ2gV3lQdEhtCGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770372167; c=relaxed/simple;
	bh=Y37dZDj9vdAVH1XH5pqn5YzU8FQDJK/yEriFAuPv3AI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VCNZkSeCC/nJ5Ycv7WeeseT60rwZy9PNGv1QVrTEF7VD/FMRKt+4PSOivhvsQnqA0ae6JbA4iIxv0jdJOvz4C7p4P8MhjTuu+w7PEw+8HE6QaKNL7RVFF71NuCFWBOZFVWIJW1DddQ37NlYptbruv/0MmGw8DwsnlCeriAeiqGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rKeeo88k; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=cyuMZf3/; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rKeeo88k";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cyuMZf3/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770372165; x=1801908165;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Y37dZDj9vdAVH1XH5pqn5YzU8FQDJK/yEriFAuPv3AI=;
  b=rKeeo88kY7KogOmA/vSYarlbwUOEtuCF4Hg3r66cM949CRSfUtMPkvHU
   tVqdi3LpAipevKSKus1XJjuTzixiF5HUENlYV7KlyLWFObbzj+gTYD+aJ
   JXCNmlEcK0qWo+mNKu00NRJJxA0y548jUK3mLt4YVQAHk2Vh05YI8ukNR
   7rJqq0JB8ESPD3hNkgKDPIGR+6gVaXhFMBBPlKZZ2GxuxZ8UqdNVmU5KC
   1xFf+zoKOGpPBJ2rdQoeE2whrQ4eOuMLci2aWZjtDBtNXB6Rkpb5rCPPO
   MTDBYp01Byd2PQ0OZIeMDuHSqzBLauOI8nELsr132m7fWIkiThzjt+num
   w==;
X-CSE-ConnectionGUID: Q/5bBFoNRQCC3Rs4QvY9Bw==
X-CSE-MsgGUID: nwzv3S+aSkiUP4pjnl32Gg==
X-IronPort-AV: E=Sophos;i="6.21,276,1763395200"; 
   d="scan'208";a="139395614"
Received: from mail-westus3azon11011071.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.71])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2026 18:02:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aVT5Yw+X3FxwGXbu2nd1zhFAfwANFt1w7/ZPC97kZXv3KN3Q6vUm67TmmTgcFCTxY+qzdmXPHV388OBZdCUWdsGWi2UhaZ9bHjyfToRrxg1ARb5Bboa/fETjOnO6JvkAhgvArwsJEHoZot5agKY9lQYTq+50pjmQ1COirQeH90P1QKjQXyYnLH/jnytfcrCy8inWsV/AcfTpzPBBW6ZEADXwxsOE4GtVfgEHcS3UvX02s+KY7TfICYBC/hNBsvGPtgqVSSjWfQ00TmDunoj1uGeBQv78lsBCjFza9fZ1VicOcnbqS5roGTkH5dSr6TWRD3qTWpI1EaK1rJkeFxv5Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDlcvuAsu5qRk6d2a/3wFbyv5APyOnmWczEOeSLLxJQ=;
 b=vVOC98D/LENj/zRhUtGcpIsQSGVHf3oC/FAeXLrRvbQlRkXsCWsF8O6+wGTqj/Sp6obaVm8v6lEfpdbRJS0Cr/Cj3wK+4EZXB1HiMgzh3F1TJkLw2VnYFVQG4DCRTnTQBe8HpGBHw+WAC17XT8JHfWgjdnEt6fcsU/rRB8CjRPPrYYOVPJ8xUDjc9TODbr5ARUnGk0JbkgYSQsnFN6Q0STcdOzrL1lIJcjIZnKq2Ba8PM8Me64gSGKXUvjzN6N9wJMebZYF4RaOhUkr7aX+0PN31Grp2rEbEs9Bf86vOxWVkVq0t10by2RqpEXUBC9O++26mGogtpg8BRHNQVJf7Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDlcvuAsu5qRk6d2a/3wFbyv5APyOnmWczEOeSLLxJQ=;
 b=cyuMZf3/I1j7oVlv2HZuoCmzSR03Oksz0TIu+S+BhiJ8/W7IOn3ag44/IlBTe+4ue+guNIIs2K1aVJF3h+oAqPE67s36LwarDL8MsOd8hA8UBjdHCwJlHN+wn+LoM38nEU2X3BVu8unHSBU8Uhg9pjMZe+rQw7pFfosPHpyBNUQ=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by MN2PR04MB7102.namprd04.prod.outlook.com (2603:10b6:208:1eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 10:02:38 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 10:02:37 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Matthieu Baerts <matttbe@kernel.org>
CC: Kunwu Chan <kunwu.chan@hotmail.com>, "rcu@vger.kernel.org"
	<rcu@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, hch <hch@lst.de>, "Paul E. McKenney"
	<paulmck@kernel.org>, MPTCP Linux <mptcp@lists.linux.dev>
Subject: Re: rcu stalls during fstests runs for xfs
Thread-Topic: rcu stalls during fstests runs for xfs
Thread-Index:
 AQHcjrclowh1moKuUEq8Mwy02Ri3kbVnWueAgABxzACAANWrgIAAzoQAgABdO4CAAMgvAIAK46+AgAAIBgA=
Date: Fri, 6 Feb 2026 10:02:37 +0000
Message-ID: <aYW6GCmmCFeivAxo@shinmob>
References: <aXdO52wh2rqTUi1E@shinmob>
 <IA1PR14MB565903564F4AA105AF6A21099791A@IA1PR14MB5659.namprd14.prod.outlook.com>
 <fc611e8e-0da9-4b88-83ef-092d300307e3@paulmck-laptop>
 <aXrl46PxeHQSpYbX@shinmob>
 <13b25e07-d7b8-4b4e-a249-b6826b2eea39@paulmck-laptop>
 <c33c3d3e-a59c-4f5a-a562-13e2cabc2faf@paulmck-laptop>
 <aXyRRaOBkvENTlBE@shinmob> <144e31a9-e29c-4809-af2e-5ac45150d3f7@kernel.org>
In-Reply-To: <144e31a9-e29c-4809-af2e-5ac45150d3f7@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|MN2PR04MB7102:EE_
x-ms-office365-filtering-correlation-id: cfeec566-b438-4e9e-e537-08de6566db7c
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?MPxCQlhV01NThFSR4qLKRY2DclWyYDOA2cwprxUcLvzre7osjp9tvpJ3nEOV?=
 =?us-ascii?Q?RrG7bacv+kFrc2uIaCJgVgXDp/zLKpXA2U+RvolLZKMvR4rV/PGTNAc0YFHK?=
 =?us-ascii?Q?GwCKstgaB+TFIBrx8LE6kn4tPpZtjDuoB3jldcOyy9mBHf0xaAWtOjC8zWf3?=
 =?us-ascii?Q?6/UDxdVCRNvjpNXxV4Lb8ATM0Egspj8PTlWJUJA+aRBnE+uUqD5/4Fnx5qxJ?=
 =?us-ascii?Q?8swZ6Ivv5YdHxLnkACWd0T1yvbRduzoW7uPQTtTNYlO25AFkLXaguqIq4E8/?=
 =?us-ascii?Q?q2337toUmIkgO15foqdV4AzBtNw3D/th3lmTl31kAKAhZ16HiJavXg4Fu+/8?=
 =?us-ascii?Q?Gk/POYaKi+Rm0HuZP3YmcS+YHVUR66+FSFnUL12It20RDDyelml2r02XrNS3?=
 =?us-ascii?Q?bx3AyzoP8Zj5+QCQJW7otGQPLZWLF1DK6nplYvD2WmYenwg4CDQHzzmdP8f7?=
 =?us-ascii?Q?ci5x9UDIfANF2PIe2zcy6JDb8jae4URgl17/i37ShUkIcXfeudgd+ynmzw6k?=
 =?us-ascii?Q?+wDyE1lwkkeK4eVYDDR6n6vQHKiIUQZDQPQqGU55f0h9T2UcOzdiqz2zKQSG?=
 =?us-ascii?Q?jIzSazvaM2+N7zF0Ykof1WDLvYYpD4FXJO7mcvddSK1m6x4jXAV8oSk0WmIE?=
 =?us-ascii?Q?imVIzphhiJhNbiDP5uxNMvU673VAbdZg5Yg1bHKHiSRTy0HLVNRec/JbhSkQ?=
 =?us-ascii?Q?ldGZ+o+x1Z35E0ZrgeSFPDfbpwsqizystzskeRJ/ZKJCWxheQ6HIJaChrqNM?=
 =?us-ascii?Q?/lg1NgzGsdDZPvdJbr/ZMCjpUOXnHftyx0UKUDvbOowr0V3x49lLHS5czazA?=
 =?us-ascii?Q?HItahepNGDe7WDR9vf+556/+1WDqhI/l3woSauwbnSxE2ai+z6GkdQgFWhpO?=
 =?us-ascii?Q?l5aEDsFOc68vTT1JlpncKMMqCMlCDJUnUdvA3P+X3Myih7V48PtU1dRFDZfE?=
 =?us-ascii?Q?fpcBWYFrnzGXWmehTCOz8YbHcFiYmX+22RwXykSwTqeRkFvLhFy6KHJIHVF9?=
 =?us-ascii?Q?6A2Tt4Lx1z6h04cabMlHeSQ2JL2xsAu0Y55o0Ah75iOAssF+IyXr/0Jkeayi?=
 =?us-ascii?Q?6Qxugb/1yJhpAb5hVnX6Erw0yTsq6BKlcao95Th6yS1nAi1S5L4Y90z0bnGk?=
 =?us-ascii?Q?htuGTC0aPta2UWmqP2/EqfdDw85Z5eEUwzptYFoWwxYLYOY0e7tafsX0XOF4?=
 =?us-ascii?Q?FE7RLOFNhq5B3V9UM9tHETQUoULGyTyR9P2q7CKx67w571sjp58j3zg7cRFq?=
 =?us-ascii?Q?JF/fyyn5bndx/if6dzGp0bFHIFvhOr5qTctUG6v8ii2k436a6Ad/bvbKNyrG?=
 =?us-ascii?Q?qqcX1wkX1+uFUIH/jwO1X2sFXpmitTdj7FiUiScrq/XbhtwZ6YW3Me68oTn1?=
 =?us-ascii?Q?HtZsrBrm78hWnDx1b5CuSOZoD4owSQ5EARouW0F6RLiATFmDFVfocB+Sdu8f?=
 =?us-ascii?Q?xtjaFj2LhJzEZJG6Lm4kEHsLKjlw1L16wKAGnBDVMt7ho7xgetHJ2SDFzSsA?=
 =?us-ascii?Q?M6POm9FlqRKZ6ZMRfgMK8R/L6X2uGEYZAQXi9pmUVObQO68L44iND+VPLPal?=
 =?us-ascii?Q?FETLsO+qjaGejWjEbLCqJmKG8lqxaB6yQ/8K3sG339Qewc8/ViWfFH07tpGZ?=
 =?us-ascii?Q?48/ZKJPGxXZiRZX4fUbRqoA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?lIKehaKax6CVdX/7Xi6S7hhSieGyjaerCE6bCVsc2QC16m8ZHg/bc4Fzea3I?=
 =?us-ascii?Q?DnPIo4q9LtJ046axISUiovrVTzYWOZF/dXEgDNPmpKLSoXechx3tx0F45Y9v?=
 =?us-ascii?Q?QKrZ9SxHm5fweK5WYztTueQ3nGazINuoYurZiad6JPdCguCEaFrPEVkpVZra?=
 =?us-ascii?Q?k0oWHtwCpylG4HcfzQD6UIe0SnrzzxkM6ObjQe7f9k4luQkH+X9aP3YUmQC7?=
 =?us-ascii?Q?2jPmrtLpOyOCWxBWgzaO3Z3p3KiosqnbW76Q1f1ivZbRhe2P50PfUeLX7kVM?=
 =?us-ascii?Q?MPkTNgGp4KEbewtK2HGeqTLYVKlpK1AwwATCQ1kK3lx1I7Qjfzd2wdj6i/lw?=
 =?us-ascii?Q?FOw5OWxvnBHWeHA6aMxrH73zuX6IRNu8AVXfCAhHGN7Nqvc+c6G5RaH3MF32?=
 =?us-ascii?Q?wTDDjC5BZZ1um2EbReQd1BtCgSGS+Iu/EGWHn3v1Dq9xoa1yRh8Dh1NiwwvP?=
 =?us-ascii?Q?xbE1n1iEOpqLDAGrCRujNT8HSPPu9MWkXTu2JAavpQ8VU9oBe/dDD27TVuJa?=
 =?us-ascii?Q?jQJR7j1TUWoHij2/Whzn7znMaVY8opoaLnuUFwqP3Ne/J45YyNyFb+O27ezU?=
 =?us-ascii?Q?NSPP8pC6i1p41N6QcXfHHuLJPhEWEIhkS/4k01H2HsCJJ9czSX4bvX/3qOX/?=
 =?us-ascii?Q?WuVvRU0eLr0q+NDo7DwrGMHvYTDuI8gb/P4jX8P48D2AQR962dD2RBWO+5zB?=
 =?us-ascii?Q?nhwaX6CMOPL8hrvJ9VEayMomNS4Ac767igu4co35PVdrtMeoYbRu24QubbOY?=
 =?us-ascii?Q?o7YVfwSanR/CvW2aJYFBCowaEuBx87aXNwJqQ/x1wXOk/Yp00QwLpo9RNSSc?=
 =?us-ascii?Q?vVIIE0h9en4gPJBr4znyRfjThEMWmAcw/KmnBLAdmfI6k7quko5/cE3HINDB?=
 =?us-ascii?Q?jk4zXVCxjUaffFm3tSRRM9t3dWGph0+sUDwkpoHP83RGAk5n4tbORKbM43KN?=
 =?us-ascii?Q?OuF3ybW6CiIbkGSiCkeWDnXEx+kOtTPi/C+j3O5pvYLhdMhWseB++XGracxv?=
 =?us-ascii?Q?xX2Xa/N+lgrnrg9zCOqwBFn6wtlaSkhIKRgiWqYXdOph4nHXFK3yxpveLh/a?=
 =?us-ascii?Q?DAbZFUnntL5PxKhfKt94bn9TQ5Qq86GYU+pesXlYNVqTpzfCsOUTY1q1DZvp?=
 =?us-ascii?Q?aCXflClxYyn3mUVWzba2VJUzpocuGSLSEK4p3Gafj7hi2dEnWldSF2LmEAWr?=
 =?us-ascii?Q?VQvb0HlqNU4YIS/L3fhGrHOqZ/eaLeNKfHrc6KkiyqM0885FdXHxDqTwz8q9?=
 =?us-ascii?Q?zegmolSG5p2BmBfa+yh1cN3Kc4TrhjOCLpk7spfKKkPgpM7elc7Ks1HwhXN/?=
 =?us-ascii?Q?0FR/PQpoV+qH8qFSZZqXZgpasvzPigDekVNWMm4X1DmUp/M3PWGi2HXoieQG?=
 =?us-ascii?Q?qISKIOjRV5gfahC7d5lit65GwkaVtH0GYYFWF3H+XzjDDObJcUNDTzesvCH1?=
 =?us-ascii?Q?D2PkIIBrzibuUUZ/2telYL+Bn2+EYhxjTU2gieI67kULAJ31qicdgg5zxN5h?=
 =?us-ascii?Q?CHopOd2e9UDoXrTfYmmvI72TqXP6I9tFLXMfAXA9Mt2/9gNnX9uxxXZiAxmE?=
 =?us-ascii?Q?y/zZJ7o+CemLOxoyeqTyvYNMiAwbYpCuDqO6UHJlzjNN2DEGJpCdLNT4Pd9x?=
 =?us-ascii?Q?E6txYx31epwA+fk/cqCpdH3A5ryD1PJDuW/nZaF1l4QTEZUEMDe00jTU153W?=
 =?us-ascii?Q?Bnrxj1pwQN39wRI8h9b7TtXl+4F8Q5eWdybY9LZTUngBsVmS9pbCTElx0CCv?=
 =?us-ascii?Q?QNU+4ci7PLz9pG3z2YGlwdhb3ggeDN0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <496C23671565EC4484FCEB1DF318F660@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B8eMJT+BPSNV0ASkBVBk5coEI89mhnePhYzzfk0wb3MxG/Rj3D8xXUIZOk/BqDtAEIKPXtnF+FecwiwHKfvusL3oumyK3O/Jl0u4cL00KB4BweS7Ef/U1fvQouujMzHhN9BE3MHgoF6vtaSBkWL4FwE8MqsmvPz+KXFHrZvM0HGoM4lNHWnhSGV0HHw673ajYcOgsL5wP0wc1yCHiGvxBwAnQKznRz1mPME4YubpKBDY4+k6rNcXhSlO+HTqg/hIioePv/VACo1VZk+hOCQINY3ek9rZnT7OtQzsc3lL0eSBQhPY+JrkBT5DwTTZ7s4c6MPpyNdrNSNzKx/sW5L7crdgBZhkFnYNeaINS/HAvmbn+WBXrxANNzXA4k+NK4+XuHKrdMgs+YNI2EsYLVPzxRBEU7DzA2YPs2P5yT6YLhGgZQX6eAG5RJdVynXWVMPkm/cY0cX0jBwwlPzoWz0v4dpsZ8gcUHsDiBh/SRzPZahM7zyQBVmjD3mIBx7lqyv3ET8vKZIUPWFFv9HkVKQyKXJkIxnvsC8nqOIwmxpdPPPSEuTGr9diOFsdxRgkh6GXY7HSb5pV6jGhfkHibo0sB2vn9esKQjCwegeTFwGTKo4gFDnJmOB2F81hfEw5umJB
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfeec566-b438-4e9e-e537-08de6566db7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2026 10:02:37.6233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 02VgIUVlSwMbk+Gwedi0lni2vzZNS7R/SuoGRkGB5pcmx1jIRKUnB01Nm6G29G7jPbF+PkV5HvyNw9HPun3N3gzH4YGSc5NDFE5kFQZcjOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7102

On Feb 06, 2026 / 10:33, Matthieu Baerts wrote:
> Hi Shinichiro,
>=20
> Sorry to jump in, but I *think* our CI for the MPTCP subsystem is
> hitting the same issue.

Hi Matthieu,

> On 30/01/2026 12:16, Shinichiro Kawasaki wrote:
> > On Jan 29, 2026 / 15:19, Paul E. McKenney wrote:
> > [...]
> >>>>> I have seen the static-key pattern called out by Dave Chinner when =
running
> >>>>> KASAN on large systems.  We worked around this by disabling KASAN's=
 use
> >>>>> of static keys.  In case you were running KASAN in these tests.
> >>>>
> >>>> As to KASAN, yes, I enable it in my test runs. I find three static-k=
eys under
> >>>> mm/kasan/*. I will think if they can be disabled in my test runs. Th=
anks.
> >>>
> >>> There is a set of Kconfig options that disables static branches.  If =
you
> >>> cannot find them quickly, please let me know and I can look them up.
> >=20
> > Thank you. But now I know the fix series by Thomas is available. I prio=
ritize
> > the evaluation of the fix series. Later on, I will try disabling the st=
atic-keys
> > if it is required.
> >=20
> >>
> >> And Thomas Gleixner posted an alleged fix to the CID issue here:
> >>
> >> https://lore.kernel.org/lkml/20260129210219.452851594@kernel.org/
> >>
> >> Please let him know whether or not it helps.
> >=20
> > Good to see this fix candidate series, thanks :) I have set up the patc=
hes and
> > started my regular test runs. So far, the hangs have been observed once=
 or twice
> > a week. To confirm the effect of the fix series, I think two weeks runs=
 will be
> > required. Once I get the result, will share it on this thread and with =
Thomas.
>=20
> I know it is only one week now, but did you see any effects so far?

No, I do not see any hang so far. And I hope there will be no hang in the
next week either. Fingers crossed...

> On
> my side, I applied the v2 series -- which has been applied i
> tip/sched/urgent -- but I still have issues, and it looks like it is
> even more frequent. Maybe what I see is different. If you no longer see
> the issues on your side after one week, I'm going to start a new thread
> with my issues not to mix them.
>=20
> Note that in my case, the issue is visible on a system where nested VMs
> are used, with and without KASAN (enabled via debug.config), just after
> having started a VSOCK listening socket via socat.

I applied the v1 series on top of my test target xfs kernel branches enabli=
ng
KASAN.
