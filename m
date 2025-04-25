Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB1C1F3FC8;
	Fri, 25 Apr 2025 09:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745571809; cv=fail; b=iD6dmUJfz7b4QmGFh75M3r1BFWkynxFweoLSJVnQvp8ts8QDvj+E8tW4BzLMPrRPSle2dPvDzTFUUALP+41XaoPtrF0VKyp8mU5Jl81CgB1i016ZU4M5eWvSh7OhUNsSQRBxRy+k5bLTRIAqUutGbV/Zd8ecnTVn82jzhnGK9XM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745571809; c=relaxed/simple;
	bh=JRynWCUzqvw2XtBBXsDDvDRMs2Xl6Z8fLa+nb/06KSo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b42HooQUDNriPRx1aa1yuRjbYB5ryW7/w0/9xpwBky5/APAtByrB3ByZIx92fgTAb5/Aza/aUbIbPbquJQDa3f7YarIJ9lq4roxxmD7aGDnyiFQZjzItxrKemnfb/dN0bVd7ZUbvtHVZin1SqVgkDg+Zy7a5lxMblW7c5EZ0RXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Bg9ZvM8c; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Z7oe+YK9; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Bg9ZvM8c";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Z7oe+YK9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745571808; x=1777107808;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JRynWCUzqvw2XtBBXsDDvDRMs2Xl6Z8fLa+nb/06KSo=;
  b=Bg9ZvM8c/lAPH4lEXkVR4LdsJz629w6/GG+JaFPwVe95Lx6+7q0z8Apx
   TceaDX9COJvS/8fmJcc6RTPAPZosmI7/O+hQKgTU6ibRghoSIlNgQK5f3
   kYxnwU+Alg6rTfRHp+EGOdzkKH8Yr2d7wHqojOx72W+QBoNo9UpLdoYKO
   XxY1cm4c/2Tj17be8vXoiK23889/TMiSEY8LnewFM23Fl15wcoYT1yb2w
   m11WkbAX99xG2lyhIdUfedLOmgc+rPZCZKlFY6ilHszxjBaqL5HXxkkJu
   GJVNFZ+xESozZgmjTmRQoMvsJxem2n4Tq4IXRCrva/KQ5LaRPuNa7RPKy
   g==;
X-CSE-ConnectionGUID: j4sKzCegRC23vTGvGuD6wg==
X-CSE-MsgGUID: Ma9X0MlVQvGiMqDb+pfwAA==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="77775074"
Received: from mail-westusazlp17012037.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([40.93.1.37])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 17:03:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jROWnRrwDwgrgB3chexMuDcRRnzUU64vLAPuWbsUZ/YUJwuI0mFfkqlwkTf5/6nmU4J1dlF2jZrxuAmma6t9ZjcjJphWoj30RdlfA/W+J+xfeHMjhjhi+0VEfNzXMxwij19gipEsenEpx2thzgsS4EHPf+FH8ADQXNUtorCmAyXoONwgNpr7/kNltQozOEU8VxeCmN26rSAbiQytm/BCZc+BVtK9iHwzyZ9FmL+bMHJFN8FmfG6goi7NF0bj6soamRcqEA8ch6heCs+HYdYYdu1Wyk6JrhX2eGKn7nZFftr8cd7X00VAClm/wJqQkgZltib5Hwgfe2Jf4eauW/Ty+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5J5/1l7ZdS062X6372fz3y8O09h8Om3adNK0YaIjdSY=;
 b=qCzNYpa2/rUfQl65sH9nTLnwiDyi68vhMfZUb1uGQmOmIxv0dBKublGO04aKr54ucmowfnRvhBTIPYb3BrxgJ9YIw5sGr76T3FqDPtYBM5rt6bkaPYV9c1M4ot0ou9pRgMnRTQueTPMtbohlrVm1QHhyhARsWBt5/zTxY7vR8zyYNWFS6e04t2cnEK18aUaUpE5vhAo4MzffiqIi6LDBjiu+pnz0VjhsDmb/rvksdqfq3BtcBm3ucCBJFnlHlh4Wt6ajkYCmY6VONaIt0A3GAm13G5C4XwBGUrR4bAlwXrKq1ZZfTH3oSid4IjMaEO6fwVFCP74y2CFQQGlmEP7pUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5J5/1l7ZdS062X6372fz3y8O09h8Om3adNK0YaIjdSY=;
 b=Z7oe+YK9EWXMZsMCK5MU6Og7x+KGb579paxlXJduSEEVc36A63HV9WfGF5as6WWvNA2C9l3Teci8Sud8GYOE/HmGlq6f591dFw9xf1/3/a6VkroeIOnbOIJ+ozq0omSKEi89iZZYgZK3TcOOQRKa246DInDvMAruCzdNPTiZOyU=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH0PR04MB8131.namprd04.prod.outlook.com (2603:10b6:610:fc::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.26; Fri, 25 Apr
 2025 09:03:23 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 09:03:22 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "fstests@vger.kernel.org" <fstests@vger.kernel.org>
CC: "zlang@kernel.org" <zlang@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"djwong@kernel.org" <djwong@kernel.org>, "david@fromorbit.com"
	<david@fromorbit.com>, hch <hch@lst.de>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [PATCH 1/2] xfs: add mount test for read only rt devices
Thread-Topic: [PATCH 1/2] xfs: add mount test for read only rt devices
Thread-Index: AQHbtcDlQOxnpwBoYku+VcbjviMnXw==
Date: Fri, 25 Apr 2025 09:03:22 +0000
Message-ID: <20250425090259.10154-2-hans.holmberg@wdc.com>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
In-Reply-To: <20250425090259.10154-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH0PR04MB8131:EE_
x-ms-office365-filtering-correlation-id: 75e44822-7673-4374-88c7-08dd83d8080a
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?mMV4ixtu0j89/6BYy7W/KTnljZZhAYq2weo8M/4LuxobJ+52g5w6xGgl52?=
 =?iso-8859-1?Q?f83ANJDISD6kCQDH+EiNg/bm+XGiUx0XpEBY8ajoE1Y7RJgThyWgouHTAO?=
 =?iso-8859-1?Q?GtiyefiOTk13pfI+XGgTJmwbbXsaySkJOjRswHZY+M7+/8cQaeJNqV2rkj?=
 =?iso-8859-1?Q?eq21dGhT/DSODTgPzwmRZ+Qet/jQnJgK7SAAAEbeyXYSeh10Zzc8Jv7PIF?=
 =?iso-8859-1?Q?f0noejfZlHvgKxaXUsw6fUzHmU2yxek0POQWDzWtIu4TjwBVTkgTkbJHnk?=
 =?iso-8859-1?Q?dxjfXpaUUyERW/65hGckUpysaVA8G427PEZF3NeYuUdR7JV+h564IsUOlF?=
 =?iso-8859-1?Q?J6G4Tth1lWZtCaYYJ38GNFU7pEc+r2oMnG18IOSghguHPxbygP7cLCmCYK?=
 =?iso-8859-1?Q?7UxRZCqtVdIkMaydE8rhCN4hkLIDeLMZewvXomrVaw7/dx8EujRCnnA7a9?=
 =?iso-8859-1?Q?Z4FU+cuxUdTOw8OgPIzimKyr0RJ9gmplV4NZ1JpFB6t52ruKTYmgqG5Fsr?=
 =?iso-8859-1?Q?XGqJjg/PwTeBe9q212gCF88+4WWBU+51XguQXjTzPJTidFzcjVq+59rwSI?=
 =?iso-8859-1?Q?3zo3kNj0nonAHpvC+iwlbLOXVMypb2XzHJSvWHmd0mWfLlQNjFIoVMO+K3?=
 =?iso-8859-1?Q?20ADEZUTnV/eoe9BLDT8XFHhREk9FcLy27P/tLCStTNMFFILBBTYwsZHG+?=
 =?iso-8859-1?Q?tmel83Wx6nTprBYvGyrs9dINsCffcfze8tWpU/ryAUgxqz6zTUUpghn34h?=
 =?iso-8859-1?Q?GRfXtMmD8RuXv58GdYWrSlSRrMFsBy0qotEV8PJR+QKUwAQpMrMFj6rT4a?=
 =?iso-8859-1?Q?UIpvli21OCYwYbXowG8j3s04u9gOEVbIVVADtdpEHv2xdTkXJKFv44u9S5?=
 =?iso-8859-1?Q?MmZ3KJrGfpk1lCRSm7htJU/mDUJg+j6o7N2srYDJIkI3ZaW7tURt9hr8bC?=
 =?iso-8859-1?Q?MQgNq5KhWze90hFAIj/FJzSCWYhosljgJIPBOePCamdG8ECJJyu6/cSeDj?=
 =?iso-8859-1?Q?2uj1mJ6jgwODyoooZ5mlXtqsY5jS6FiEElaB5ZxvanSwUo+QwPRaEPZG8N?=
 =?iso-8859-1?Q?fQ3/oa3rg74WCPA1tB+Dt8vVs0wVmauBsgiA8Pw5YGN4H/r7T3YIet2p3D?=
 =?iso-8859-1?Q?oMS0KQV4JE8kbYGqc9aII8KjZ3qNTgpqmY6R7SAhkYdEzamSb3H3steCCL?=
 =?iso-8859-1?Q?rxHUJNlnlAtDz6h5bSz9QcCYBTTUkgL9WqszclN9laG2Ff41iRoVjPu6sz?=
 =?iso-8859-1?Q?BKQzT808o3hPkxwJhlhhusdAoVgE4I9CaSvfWMnxrfkXF2a3thN2JeU+BK?=
 =?iso-8859-1?Q?MOjDQBNphp7ZNZf/bTl3mxYhhvwk8TUvS/jeQlEmlDc8g4TAZt/KENwaf6?=
 =?iso-8859-1?Q?2q1zAV8X2l2oM5RQj6AHEHkN8Sgo2WaxznM5W2SjODbql61eU3glTI7Gd5?=
 =?iso-8859-1?Q?WfaCxWOLuxG5Pw3npl44GLpEA3rGCjGTF/mYT9wio7OOsrDjlPrhMu3tE1?=
 =?iso-8859-1?Q?06u0rG1jf7TGMnM0XusnBjlAnbVSqk+Awy3C6ceQ9fZJRB1EbmTfsb1wQ9?=
 =?iso-8859-1?Q?9VxJqAg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?pV6WZiH85n5WTFhpi3/2Nw2qJoVTitj4YJEBfDmQI0TuDq/qiTc+8k3SjR?=
 =?iso-8859-1?Q?xyhRRjXCHHesaW9OeMkVdCtSGEhjMOhfnew0vYeV6tlSA5YqZmoh9DtR4e?=
 =?iso-8859-1?Q?CS3ABubXQwZan4VnNzYR6yFvzZJ47caJasnUO2ECh3P6OlsVLXUt0sRnbE?=
 =?iso-8859-1?Q?tSc3BlsweOaMGKiybCcpxfq+EWESpml4eOpCWLphQGhosMendU6Bny9aX0?=
 =?iso-8859-1?Q?8exJqGeilRB9iZjIqgC8aopGTjg4KjkRCQG38igLWl+0Fnb1t78R1H2XYr?=
 =?iso-8859-1?Q?lkrOisaCz4x4cGj+jnfXIJLDO0HrNkecf4gtgpe+yE/zatrdNlRPnISLS2?=
 =?iso-8859-1?Q?AlP8PoAwfcFyuiVLbeHooOWm9Aeq9ZImHCcA+Lc5NJjiCr1Ex5UH54I8ny?=
 =?iso-8859-1?Q?hhuf/S0tuOWLO1zwuwVItMbXVh/Ba45u3dWuwdhCJXD00fGJJnuKOVm96s?=
 =?iso-8859-1?Q?v1jIqA1X2wNSq77zCUxkOfsno3qV1wiX+nZI/i+GCvTP/rH/uMY80CVTPq?=
 =?iso-8859-1?Q?Tq/yFspd8POVsXJXLlejUsg0TBdoGHXlo4iuo62s/kvoBB7If8G5WN1GaX?=
 =?iso-8859-1?Q?cmA0mhyvKy8KHuek2i6FKDac/rlxwoAzXgjutuPYQlZRjed7AtfqWDy66o?=
 =?iso-8859-1?Q?1KFNUott1EilGtPlHMcnqL4/1oQdsyO6KKflL54MBSTmTW6Q4qsOOV5sN2?=
 =?iso-8859-1?Q?HhXf460i1oMJCB9X3/AGBwVZoqsm2bD0uSuhICwLwOBZXJ1s72NRlcY5j5?=
 =?iso-8859-1?Q?pMR1+pj5H3IkxRBIUMiTre5nsiEDkSNpXnM4pW4LKT4AJeT5wuFK/HNVV7?=
 =?iso-8859-1?Q?1Y7643tSKR9x3yfk3w1AO1r/9F7MTtxWDOS+BJhjP4x38nWDVoLlX7vciC?=
 =?iso-8859-1?Q?QnAaFhdpo3ATnb+1EPVFzQgLBRj2E4Z0XQhcyB1bZBdHbCc9DpsY0rYHkS?=
 =?iso-8859-1?Q?0kp7zLmV4/C46oJk+NsMlAI1E0zL02EOJkwkO1Cj49npOcwJKhiYSrkesM?=
 =?iso-8859-1?Q?Xk2ceLnsrZu9uP/knTJIrrd+nRDHYP/XJLSZq+3U1LQ9sA/n2Eb5LzcrST?=
 =?iso-8859-1?Q?3gCcJ4dkuA+V+Fynar+BbXVUqNJxH0lJY36uddpxCSj/ZtSU5+ys5t1Mle?=
 =?iso-8859-1?Q?JDXxpHg0liNnT5Jwu+SvARP1rqruypEuLlAXTLyOA0IPixkeOUr9zIru9l?=
 =?iso-8859-1?Q?oAiP6gapRTnXfVqoXQoHtd4sdqyf5tnlmhtLmXtbAyBxdJ9L4cjW26GSQd?=
 =?iso-8859-1?Q?yVUsIke1lbDtAUEKRT0jKjiZc8afUhYO5GuHZsdwRWtysj3IxPTl0GOrtR?=
 =?iso-8859-1?Q?bF6Rv2YJnY+4q8flIKAnc9Ub/gUtv4q+msDnUHc2ea/bef5P+Sxn8ENiJg?=
 =?iso-8859-1?Q?JonkjEGTNzqtbn0VReT/p9ajR4YN9jUTtRGii6ezKjCcp04FEQh0Tjr9M5?=
 =?iso-8859-1?Q?QySUnjoTUaLsOEQWuuY3Tvtkqhd27TNPU548ztFufQjL1fcD79dlYn9v5i?=
 =?iso-8859-1?Q?ZBKeFqGstRLWSBGtrjSAX0gyrr/NYBUK7uI7WR24n2WvOtK+NTi3qYJJt5?=
 =?iso-8859-1?Q?SryjOdyyC/Nw/sMt+IYJ+Y+eiSqrHyUqHvocjqmvRc7qdrcuyzRx85LGwr?=
 =?iso-8859-1?Q?cwgypqpGWFrZRP67tmPa//FuU2qa0yPssJzVbIMv2fnAkF7RJXCwtNog?=
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
	3Q/prlCeBRg6vSO/6+3ZN43VdoKyWdtV3jekzJWaLu9NXt1PifsuTCOx0JRftB3l/J2aW/2qdrr2Nh/eZDxXKKuYd+jU0Eopp3a+NhD18ie4KidVpZC42hh2ow8p1NScvWpTXFbivPId8v1oOG7Zy7KhfwuPPZbMLYUxIU30wJ2QMkK1FyXNAt1I7GuldV+Q+ypQhXwLc7vV3gDlyNqJwfovGyM1TmFYIeqsqES6gxYahUlIHf/JNyfhg1ciOx7gPKGIfWPIdrVC97XkTol1bOeuIzfoi2pL80gz7kQ0/sYgupvz9Y45n0njMhQBcoaUdUmv6WgHahRs1WltkVUBq7+lphO8uIfmNbNv/bRMMn4KsEXb+5yDXAONg0EH3nq9khsYzD79G/HuL14bqEMoCP3Sm0I1uVQBmRqwtMmPkssr+l9edQc2nwoLAouqrYDr8svKUHCbaQlJ2GJwaGXt55buzOGrY9WZuJvlE2EGwtcpCGBwc3qh4GaDZdQHZVpjrSVVkXxuO3TiWE8ALvRlKaiekW51GVFRr5ajngZ2v3y6Xsd0CapYNuP5P2DkJN7Zvi05S/bPL0CWwHVKOh+8xstNxOYZZZV9z8M/ppLsj5wle0W5RRLxAwj9TkxwK/yP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e44822-7673-4374-88c7-08dd83d8080a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2025 09:03:22.7525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i60SRdJoAL7+iLzlo7NL+9cSS0iJ7PisfQDIV7iA/P8iFtREcDTDdhxpSItrBEGxAeN2upiadm8CGBtcWjY8aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8131

Make sure that we can mount rt devices read-only if them themselves
are marked as read-only.

Also make sure that rw re-mounts are not allowed if the device is
marked as read-only.

Based on generic/050.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 tests/xfs/837     | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/837.out | 10 +++++++++
 2 files changed, 65 insertions(+)
 create mode 100755 tests/xfs/837
 create mode 100644 tests/xfs/837.out

diff --git a/tests/xfs/837 b/tests/xfs/837
new file mode 100755
index 000000000000..b20e9c5f33f2
--- /dev/null
+++ b/tests/xfs/837
@@ -0,0 +1,55 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2009 Christoph Hellwig.
+# Copyright (c) 2025 Western Digital Corporation
+#
+# FS QA Test No. 837
+#
+# Check out various mount/remount/unmount scenarious on a read-only rtdev
+# Based on generic/050
+#
+. ./common/preamble
+_begin_fstest mount auto quick
+
+_cleanup_setrw()
+{
+	cd /
+	blockdev --setrw $SCRATCH_RTDEV
+}
+
+# Import common functions.
+. ./common/filter
+
+_require_realtime
+_require_local_device $SCRATCH_RTDEV
+_register_cleanup "_cleanup_setrw"
+
+_scratch_mkfs "-d rtinherit" > /dev/null 2>&1
+
+#
+# Mark the rt device read-only.
+#
+echo "setting device read-only"
+blockdev --setro $SCRATCH_RTDEV
+
+#
+# Mount it and make sure it can't be written to.
+#
+echo "mounting read-only rt block device:"
+_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
+if [ "${PIPESTATUS[0]}" -eq 0 ]; then
+	echo "writing to file on read-only filesystem:"
+	dd if=3D/dev/zero of=3D$SCRATCH_MNT/foo bs=3D1M count=3D1 oflag=3Ddirect =
2>&1 | _filter_scratch
+else
+	_fail "failed to mount"
+fi
+
+echo "remounting read-write:"
+_scratch_remount rw 2>&1 | _filter_scratch | _filter_ro_mount
+
+echo "unmounting read-only filesystem"
+_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
+
+# success, all done
+echo "*** done"
+status=3D0
diff --git a/tests/xfs/837.out b/tests/xfs/837.out
new file mode 100644
index 000000000000..0a843a0ba398
--- /dev/null
+++ b/tests/xfs/837.out
@@ -0,0 +1,10 @@
+QA output created by 837
+setting device read-only
+mounting read-only rt block device:
+mount: device write-protected, mounting read-only
+writing to file on read-only filesystem:
+dd: failed to open 'SCRATCH_MNT/foo': Read-only file system
+remounting read-write:
+mount: cannot remount device read-write, is write-protected
+unmounting read-only filesystem
+*** done
--=20
2.34.1
