Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2F615199A;
	Fri, 25 Apr 2025 08:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745571184; cv=fail; b=Q6g6+QpC7r27ZZSEYgK4Zbtv277ERlvSOcTCRdt1eIatuZvO8hNr2fNiG3yb1g5HvLegEIFaekOz6ygT7H6YKky4ZQuT9+g4ZmdxSKDkXKwJim+KYIr1kjK9LUl5CBzIjZayoWeccqLRLTDuGWUa7PU3BGn6kDgksf7paxXLYzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745571184; c=relaxed/simple;
	bh=ubXGUY9dXHtx4QghbPDW3m5Vm7lc51CduHhLJGJMpBI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ijXfg1r0DIW1S2m3lhQgZOFiiIvmVMhC0aOV/MzzWKUJxBptkoLiPbifO9nRzDvmorbp+w5nn9LRii8tcAenFPPpwUlNlgfDnpFhJpZ81THn6Ga9oBQ7iVOoiSEcjG7/KV9Nel3XDKnNI/sdUhgIPsd1xXxsSm6F57hyEtl9s0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mFq/AZGv; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oTzGWkdG; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mFq/AZGv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oTzGWkdG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745571182; x=1777107182;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=ubXGUY9dXHtx4QghbPDW3m5Vm7lc51CduHhLJGJMpBI=;
  b=mFq/AZGvfvzv5L9jYUSDry+Jh030J+n1ULTfnGSUPv5y+OZBPe90520F
   o7Nc1psJ4KaExJJX0B/GleESrAcCixBi9dfjYNhy46dcksGLIZrkHTSwy
   BKTMrdf6ldlrBQbZZI5qLl+yYC9vnBN9RGqfwcEsM6NmhxemOTotP2kQ6
   or1KLOGNLLOgv81KDBw4Hv6i22DHwE7ennreE5oJ9Ngg0bmfXjFNy3+VZ
   lwW1mAzf7dF592ilG36t0keZGn3rpu+10Qo+end+aK04w2Sr6T4Vk4X1V
   Eo5ulHUD5IJUAdBcrMsvq8ZLeZDZFAnWeyDiou84AJEcjm1z18yr7OiLB
   w==;
X-CSE-ConnectionGUID: UfEd15SQTbWrgnBdY9BypQ==
X-CSE-MsgGUID: OVwWXYnFRdCks64NxHPvig==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="83316630"
Received: from mail-southcentralusazlp17012011.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.11])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 16:52:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GwzB+PxVXRjLWUpi82bmJX/OUKtQBlq1FKnZsazuMVNzuE4vpskcsq2n+ORfgI7bOZon6h7kMWXEJ5ofyxstE3h4flXpCr87cdxqitU+I+Wzgg9G1xzIaGzXukCjsG49qiZx03zuJwlOSNUkGHIZmmzlW1cVf2k6HVTKWF14p+fvckqOpr2pi/wGt1FYWpYWkBY3L2RQU6ND3uVYBsCVdoLRvP7180FQ4Fpw5cp7s1/CyVqjrr6s/q3LsJfIs3dAKSdeON7FtXO7vX37qd1oMtn1kg9iixQRtumd7HkGWpMTPKoLm3yity6P9I1eVETplyim6pJMkDdAWO97eQO3KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlZwtk0auZ02LXTa1jzUBoK4bZ1r6ohYuZmdz5Fqfuo=;
 b=DpzeVjq67dy25kke4/VAgqTauDQwheJ0ZCoSRAQ0FHP/2Oo8LUQO/p00eettDiFQLeT8/rBIkZamfVxKoRPbh1r8vJuVLpQpjAncT+V6UUDW7kwyyyA3fctUGz5S8MMrFuNqSeL/Pf4GLwGZdSHae7oYM6QeUzC/TKz77poIjwBUVf69lZWKL8aMmH6tllyJIwl+Akoodkx22h9s0yhwebPYOKaqE3ctkZjkaxsW5tmHMz0x7XvUHr51Pb4N6LRf4pmgRj4Mm6CQqNl1qEGavotwWkRHECwQXmBOh1AZ+xikp15unj4d6zsUYVHRdj3ykZImyOgGh4A/fQP4TQdNDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlZwtk0auZ02LXTa1jzUBoK4bZ1r6ohYuZmdz5Fqfuo=;
 b=oTzGWkdGv+F2P6hxFKXFcqJ0h5Yl6u/EWmVrQOp5REJbax77W/toL0yvc2Dt6UK4obkSYOjhDA1x+cd0J4wsnmJRuuDgMVgLp1D3gM54X/5Ct1iXHJr6/wJlrQC5GSKxGkYsul7E2SMmkccO3fEcJMulejqn5++QO4C6f2Ndk/o=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH2PR04MB6553.namprd04.prod.outlook.com (2603:10b6:610:69::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Fri, 25 Apr
 2025 08:52:54 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 08:52:53 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>
CC: Dave Chinner <david@fromorbit.com>, "Darrick J . Wong"
	<djwong@kernel.org>, hch <hch@lst.de>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Thread-Topic: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Thread-Index: AQHbtb9ugJyGk1wFU0SBquvCoobacA==
Date: Fri, 25 Apr 2025 08:52:53 +0000
Message-ID: <20250425085217.9189-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-mailer: git-send-email 2.47.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH2PR04MB6553:EE_
x-ms-office365-filtering-correlation-id: 11ea5ea4-c454-4145-a8cf-08dd83d69135
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?F6ROa23tVfE/qjuT8Ulp5XRE+1cibYdQM76Hc9boy5n7KvJ5Vpog5FArfb?=
 =?iso-8859-1?Q?BjfsFYnJCgRPF83ujLhwo8NNg48/MEpv38TilMJ08MpIB/Q1SfWYRTLsMF?=
 =?iso-8859-1?Q?B5Vz8sptUSp438XbjrN2OUbM+aAnpCAP8J1EFlG4fquJzN4gXvZ7t9YH+F?=
 =?iso-8859-1?Q?LgTYmJBPRqZYqzf4clTVds5XCjLS/jlS1QtuQAmJrNUu+vYI6aAz8vMNYJ?=
 =?iso-8859-1?Q?GTasm/b7dwNjNBl87vVgwgc6SXbwJUulqANaHRdt5WqNWXll7PirInk9a+?=
 =?iso-8859-1?Q?Anh0DH8pAexWIP6pcffgj9/MDxsxwF6+WLY5fCirZ8csm5/9J23E5VMyMd?=
 =?iso-8859-1?Q?Zb2Ivg27xfjWnMPKF9ddYOrafoLlgJOzanIiVT2me2yslKvjvvPkALCL3j?=
 =?iso-8859-1?Q?kZQisn9/vCl+2QF9NHtiNWeVeQ8z8v6Th//Mnmu+ea/2pfahf+Z5id3Vjo?=
 =?iso-8859-1?Q?dcme3iivCaROhkHt4I6HPNqOuKoGmiZh7J8Lm8PVTYCkCO+hNMDOSF3fxl?=
 =?iso-8859-1?Q?Z3VZF/y1hTpcCfIhocYPu0Ms0/rTTozIb2/Q26fc9FI65EirHc1bq3UWWH?=
 =?iso-8859-1?Q?QDS7YLV33Nw44glItuU/QHePGWMe3bxowGvxBEvg4AioKhiIF5VkjBcO3v?=
 =?iso-8859-1?Q?4wYH8WdDZ22wjYBcF7sDQHXzQFguhcvIPfkgpvI+McQ+Av3twtHqf5Fkzt?=
 =?iso-8859-1?Q?L2zU4aEFt37gKXjmeVIt7S0haG7A6agBrfRDl+ic/d2yePFw5PMsegR8JJ?=
 =?iso-8859-1?Q?JYa3iB+k/g4AHzSkA29gwT861CuLwAMyCnDIHbdjqIN5ajG/3RUIR0tHkF?=
 =?iso-8859-1?Q?Zx2IlZ4qBW7xm5VFJ5RpM+RK3ZELPxIU0FjUfijw2L6KCTlj+fVcAGI4Ar?=
 =?iso-8859-1?Q?oL2EwvF2lmmKq+0YkU9sCJQ+xE1aufP9l9wQ51BIvWjKFEkstnyewNwtbL?=
 =?iso-8859-1?Q?0gRNziZ9MDK19HtbLXR2F1HezeuWUdkHOIksHupeYi3XAxSdSNsWUMzFnq?=
 =?iso-8859-1?Q?X7ISW7rjmVQqXYtpaJnDKOJ4DuCCZl+OzZHwoxCNkpDuzNTYOCLamYlvnf?=
 =?iso-8859-1?Q?q1vhE0tCVztZFdI06WH5SMe1H4mFZBhVvOUZfT+clfUvwxL4Y5ubBKG4jC?=
 =?iso-8859-1?Q?PwPD3VKiohBCbm2rZ3VoSIFdtzC/LDZ0VNh1sESXzIVSSIGNFNryNZFtaK?=
 =?iso-8859-1?Q?lO/vj8ujVCIUx9o8jtyD2u1lfa4KeKgi3lZsR0rKBimD4Hdutopwy8slvM?=
 =?iso-8859-1?Q?ETWjh4ksLKnD9R34TBYBIoLHJXDEpy/3RjeiVGORLbzrV+fbaK38ogKrjA?=
 =?iso-8859-1?Q?1CnSE0Yj1ItMnJjNcw3YW3qRHOp24tS3jvid6h67SLAgA6wC6RTDsX0FDA?=
 =?iso-8859-1?Q?CQvH5Hguj6FBf4aimPeO5UsKt9v0maffQ+3WO21+xIhcaXirzhkvqhhJ7a?=
 =?iso-8859-1?Q?n6C41VQ5RHzuJyN+8/+UnwWfaxLyQ0GKstdI3Ds3Vlqc8mfp4/c9Ym/jGu?=
 =?iso-8859-1?Q?HmxIuTFAuGB1/oNzaSKQzPybTqENbUaB7X/hWO5Vx4eVHFsKxaoN25peK+?=
 =?iso-8859-1?Q?LPavyj4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?RYeVY/Ox1c5uk7tr1esPo80+JamScs9WZTi6mfvjFCcsfsVvmwN2QYw4Wp?=
 =?iso-8859-1?Q?TN7Il5y3pW8mOl0EMMNShOcAYfNGJlGEsqaaup2im5kFRgUTTyqP31mJyp?=
 =?iso-8859-1?Q?5E39qyaF8LjkPmt564hqplhxNiaUeeeEHiMZ+HMdbh/TiaVFF3sNaPj5Sz?=
 =?iso-8859-1?Q?hD3UiqkfOFBL7Ig4oBoj7tsF3kuztpKCatAOKXgLBLdr87VhOOIERPuemW?=
 =?iso-8859-1?Q?c1X6qnFLDPCtMqI7R/KYXxT7xnSbTMcnWoXzqH8MA0p+LuUmeD7LS28VCv?=
 =?iso-8859-1?Q?lzApsSihUJpzc5e9ADtGZEyyw6fDcEH/JdFHpvoZrt4kIKPBnl5kSJanqy?=
 =?iso-8859-1?Q?SHy3OV5BibzaUOrBsocZoUr612FB7op0YLqXwAicbLXi5VpaAsKMB3vv9p?=
 =?iso-8859-1?Q?pHg1DtE7womDUbonR6lGp1KGqPu4eyIVkLBdCCMtkvXrc4nJo5nFXysV+w?=
 =?iso-8859-1?Q?9+mi4zoHQRsJW/Hn6lYQ15e3ZbbOVS1AHe+vU0ck7LBipwElsr2hLlZVEP?=
 =?iso-8859-1?Q?fqTUd7EQPugmPOKCzN4jhC6Ddx5C7Bh5HqP9F3BnSiczwXAUvQ0OyulTWq?=
 =?iso-8859-1?Q?+GURsOCL9274eK0dZhMdkmciV147ZqWbMNyp3ITjNwcHTQlelBwX5KbjL9?=
 =?iso-8859-1?Q?1OvSiDcs5KTidteeQnvahGAoGNHtkjwdg4GWlc8po/wHq+Cs4nJ1jHUNFb?=
 =?iso-8859-1?Q?i/azD64oMGTLNACaViGdiMsDAr1/kPxGt/WhtOh/k1E9W6lMENsK59AN0P?=
 =?iso-8859-1?Q?V3HGu2z7aRZ4GUr6+7nGzN7ixdjzKTCDmNlvbp/GeRv/qF3ECsANcl21Ax?=
 =?iso-8859-1?Q?urVH5kbdrQ9mToF6nKlWoPMEbPVcdD9tXNCFGYpLzFn4vmJPLgT5eJ8BvH?=
 =?iso-8859-1?Q?5HziQseCX+yeefd0N6rjh5zXBMc4Z1ZXSQiPB31d/XoXrPy/7ZQBWwfLss?=
 =?iso-8859-1?Q?oaAppE3KNHJgc6fDNgbcBhkPL51idjDB+8uYWlxHImErWK4UylC62LmoFv?=
 =?iso-8859-1?Q?dkCVEu+JimfUTLP3wR4970cDGw8eCiLhNMS/IIPzEgDoZmcY5zTeiB71qW?=
 =?iso-8859-1?Q?2nh7//f2kZfOKKRAzjJQKW0NP8f/AW9Oef+pFIX02CLrknQegKBN9bPcHn?=
 =?iso-8859-1?Q?t7jD9CTIeCBFdRZFWBkaVCktAx7WQhlcfDXHxfKYW7IF5ag4u1+FGnA7oS?=
 =?iso-8859-1?Q?ZsAFUksBGROcRmxXoqhhlbRLkj8RGDlgpKAGHfHcxCZDs3crpiFWUtJjFW?=
 =?iso-8859-1?Q?BO0n0Y7gzhkbrlqIXLchzO7mx0W0NJw0eq+yNzYPaHHVX0ueSU0Z6cccNI?=
 =?iso-8859-1?Q?kC6ipn5/ouvNhIuthgM+/wkuzajFBH17mHtI/LoBSNhBQBQOb+v8JKXsYv?=
 =?iso-8859-1?Q?gV8FWu6+CVeWV9DA+2rvPWsoYCZJZIvUkWfoZHNt7jUvsyT4GbWdWZvJqM?=
 =?iso-8859-1?Q?xdSbw2yk2SgKm1dUcaw50xm2wqJdsOfcZirGlLG1EVT4xn6+kGR+BnlCTn?=
 =?iso-8859-1?Q?3b7FcEgZEFTQ+BUAn0qhiS5UatQlSE8GSiZk4LWLEcV5g9qJpqC5ZSTkhc?=
 =?iso-8859-1?Q?T0yAbTcqUYNB9jJ9cya4m6dYsmpZMj4l8zt3hV1R6nbLpP1bfxVwv2Iy1V?=
 =?iso-8859-1?Q?ICO/AfTv+4jbONeCf08y3EgmidlYxBX42yTsl+yl6dVbbCpq7bvKWFhA?=
 =?iso-8859-1?Q?=3D=3D?=
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
	rphG7fDhn4iaJtJys+lEXyns1HhgLT4z+u2EeFhZDXkwOxIWX1PlGRbmbOLc/li+QgHXQjjKgldhMwHbwfwdBEP4VpRsTZ9jdWtVY/iRzKvsq0vH3+MMKawRgzT9Mdiawr42IKc3mS/NIs2XRxaWxhCz4NbpI1K9kGenirqO/Emjzw/33Gz95xkT1PNttob9jkES/Y2vhHZdIN0MRu31TZEBGrX1hovrLHRoa9edwIKSCaYF7MfcbHCac27d4fARddZWtI+DlgBOJwtbceLCNQF+b9SZjIaCSOJhdHtY3mNV0XvmHD5aZxB9CcCDnWoHeTWHY1E/oiJROSChWDOaDo3N+MvFyuP2yT/BmQY0xmcAMQHiGFZ/Q6y1XS0X5jYztbPafA4+1FZSvs5bMryJRjI5g9/mqPNcdFl9w+C8IRMMhF0WosxPMfLDim7d+8JdgYWzk/ilPpWqATT8dExcK4QF6XbPWs4laS7A1AGFnschAAItDMi983zj1UUZeG8CvkktfLVn3pY4N4xKPmkaESWGShF7IUQRkYXLYf2DzJjvOIjy9h8z/WlD3MwUgiLsHzTFQBVRW8JtMgQa9bJom1Rm8O6GlGSxxpKjl6QlvTqyxTrlSyDnBxU0gMBEEYMV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ea5ea4-c454-4145-a8cf-08dd83d69135
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2025 08:52:53.8428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nCZoowcZG2v/1a90b3WKfkiXnB4QTUGcwFejlY88rz79zSmvAQRWmzKOgbsYrVFXaOi81dXA28adalvEQQvkJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6553

Allow read-only mounts on rtdevs and logdevs that are marked as
read-only and make sure those mounts can't be remounted read-write.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

I will post a couple of xfstests to add coverage for these cases.

 fs/xfs/xfs_super.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b2dd0c0bf509..d7ac1654bc80 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -380,10 +380,14 @@ xfs_blkdev_get(
 	struct file		**bdev_filep)
 {
 	int			error =3D 0;
+	blk_mode_t		mode;
=20
-	*bdev_filep =3D bdev_file_open_by_path(name,
-		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
-		mp->m_super, &fs_holder_ops);
+	mode =3D BLK_OPEN_READ | BLK_OPEN_RESTRICT_WRITES;
+	if (!xfs_is_readonly(mp))
+		mode |=3D BLK_OPEN_WRITE;
+
+	*bdev_filep =3D bdev_file_open_by_path(name, mode,
+			mp->m_super, &fs_holder_ops);
 	if (IS_ERR(*bdev_filep)) {
 		error =3D PTR_ERR(*bdev_filep);
 		*bdev_filep =3D NULL;
@@ -1969,6 +1973,20 @@ xfs_remount_rw(
 	struct xfs_sb		*sbp =3D &mp->m_sb;
 	int error;
=20
+	if (mp->m_logdev_targp && mp->m_logdev_targp !=3D mp->m_ddev_targp &&
+	    bdev_read_only(mp->m_logdev_targp->bt_bdev)) {
+		xfs_warn(mp,
+			"ro->rw transition prohibited by read-only logdev");
+		return -EACCES;
+	}
+
+	if (mp->m_rtdev_targp &&
+	    bdev_read_only(mp->m_rtdev_targp->bt_bdev)) {
+		xfs_warn(mp,
+			"ro->rw transition prohibited by read-only rtdev");
+		return -EACCES;
+	}
+
 	if (xfs_has_norecovery(mp)) {
 		xfs_warn(mp,
 			"ro->rw transition prohibited on norecovery mount");
--=20
2.34.1
