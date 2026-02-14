Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFBD2F616A
	for <linux-xfs@vger.kernel.org>; Sat, 14 Feb 2026 06:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771051203; cv=fail; b=idlDlFBZInkVeBRp0DMRjKmqN5PdHJ9e93c4P3Dx+TtG+g+bXDAgSXRdaufsFh72WRieB8sScJDctpzU6Ti4BTXbvcnQfD+JK+l2pZLnIelpI9jWw/nRM+UzVhUW3o4nNlVxbIZpvg4uVpmnlF7o+VXksfF7JWsdMHCOqfuxuJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771051203; c=relaxed/simple;
	bh=hkTFfM2GaoFOgJOjnSmXio9FmZP3V3r6U/0xRfPCc1I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZpCFWYoFl996yd1noAvbYvkPzsWoG3uhZVj3ZWJzABEEeALApElMi9Cwrl2TF7issTF429Bd4l8DX2m05m2KpIDfERfsidaG5R9jPN69Pj8vy+F31v0JHi2fNYAF0BNLanviu6G22SNwNVMxH4RgaMEZpH1AOvY1aNjvzBH2X0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=k/nDBJsA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Lm0/vvdG; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="k/nDBJsA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Lm0/vvdG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1771051200; x=1802587200;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hkTFfM2GaoFOgJOjnSmXio9FmZP3V3r6U/0xRfPCc1I=;
  b=k/nDBJsAWVafzDhMRLMyQcbN/5Lx1+ud9B92WpeDmzeUcjzdD78J+x6d
   6rAsamZ7PKNrS27E0ypnMe4AgTTIyjqv+mM0ZLDSmeLHMFtAHSYat6fEM
   Ec5dk0Ceebk9xKVs8uKhLbfDAZmbOb+2bngzgqqHPeJbSYem1ej2YTqlj
   WdGHrXbmoQgxrX+YaTl7F2ZTUjYfMieZjRh+24xJA9r0k1xsMoV/+kTMS
   hm9Dg5dJQfhx+0xRqN91WHCHuMnCpxIGo+KVPgp3f5vThNIxbEZBhbrXp
   oQOxTR1MjKeLVwHTfON4FD8Fm8qTNG5+Hcj9z6MImJdyuYt66KmxJ7K1q
   A==;
X-CSE-ConnectionGUID: Um7wnR8CSaGFAkeFQOsvsA==
X-CSE-MsgGUID: k+63AiNPQhSfFuT4awt5cA==
X-IronPort-AV: E=Sophos;i="6.21,290,1763395200"; 
   d="scan'208";a="137209613"
Received: from mail-eastusazon11011038.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.38])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2026 14:39:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SCfuygIT36qpJ/LyhlmrEan1Tt55S+YwA34C+UfidMnN7SwCAeOP63jJOqbm+BpA6sJprvc1vJvGdO9LSjsTg3ZzuN6Gs68Ok9K0/pCXx0uBlW7jRDVQoYRV3FxpiQkCqA1FA8pHALJd6lsWGrwzyEWl0Y3nIhI7qefIdu9pSDFMQ7ML/5w+aAwATAQ+7lZ6XhrBj9OsbGkXo/KGpq+vMK9ZJYOLbUsKDvP2WCmShCQYdwZKaOtUCgIfJ5fCLT5oSBHD101xNQB4LCV6bMAdkH3Xgi3akSrEWPDGZ7mQ4hL2S+W3/ERmlP7v4hB4N3WtcOZj5wDGZS8Xs9r5XAT+IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTQ73xNoPz9+nSWrHI1lqAmuNzaO42fZlVMZyZF9g30=;
 b=m+Ewo/jSgTl1MNGGSVEojwVRIOEG0RIxFrnkspGdhcr2wt4yNV7Ip8vAtvVoKpcI/7/XTNvTZ6VUByYw7n8ssmlni3kFYR2mnQ+Ocbr26/u7VQKpY1SiFef9LcxxCuYvKaptXj5p0e0MZ8AW0RoGjYiyrhn624laHcy7HYsstk8Zryme2oF7JS+AHO29pbxo7A0WvPMD10uAZocdbRIVUrtWBtNynOqXhq5F9VZ6mTrhBLKMsMeM3LuivwpsrEDXUVxdwCiycWh0a9e+yZ0TpzDSkei6Av8H6+4eHvLLECW2a06UD5ZgCwVKRWXnIlS4YdFeZRmmb0jyfpP8weQAzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTQ73xNoPz9+nSWrHI1lqAmuNzaO42fZlVMZyZF9g30=;
 b=Lm0/vvdGJbODS1Onz77BOkSGBZ75Hd0bPwjyQkXJVs7K8U3fFjBGIprJ69JTTR+nKVYuKbEdMKgQWnepBrbAJy3ZqWGweW26jsdChh/nsE29Gou00b0Eg+lAQMm8TQg5cLRe45rCMyhOtJG5fA2kvCKOeYgVu90GCJz4VP4fvHA=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by SA0PR04MB7180.namprd04.prod.outlook.com (2603:10b6:806:e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Sat, 14 Feb
 2026 06:39:57 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.9611.008; Sat, 14 Feb 2026
 06:39:57 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: hch <hch@lst.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] xfs/802 failure due to mssing fstype report by lsblk
Thread-Topic: [bug report] xfs/802 failure due to mssing fstype report by
 lsblk
Thread-Index:
 AQHcl0QyMGi0b3KRKkOnzTIETMr5/bV18CqAgAO+3ICAADcfAIAABeSAgAAYG4CAAS9wAIAASEUAgAXBvwCAAI1WAA==
Date: Sat, 14 Feb 2026 06:39:57 +0000
Message-ID: <aZAU9J5nGAXQ6lyK@shinmob>
References: <aYWobEmDn0jSPzqo@shinmob> <20260206173805.GY7712@frogsfrogsfrogs>
 <aYlHZ4bBQI3Vpb3N@shinmob> <20260209060716.GL1535390@frogsfrogsfrogs>
 <20260209062821.GA9021@lst.de> <aYmRhwnL286jv550@shinmob>
 <20260210020040.GC7712@frogsfrogsfrogs> <aYrKf6ukceZrSRhJ@shinmob>
 <20260213221404.GH7712@frogsfrogsfrogs>
In-Reply-To: <20260213221404.GH7712@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|SA0PR04MB7180:EE_
x-ms-office365-filtering-correlation-id: 91aca0f8-0487-4185-b4d5-08de6b93debc
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ctLNebYWmJfSkR5gzSR2GG+k5fVpEOVBtHwsvzoJnEyg/2wMau5oC7uQJWGW?=
 =?us-ascii?Q?ZvuGtsj2sF/Dm1u3mjK9b743prGfaHS1ORoLyPTVNGp+vkiBzXvw3h39t21U?=
 =?us-ascii?Q?/T5ue5rIP3yJ6mgrGG1bzyoSHuFTPl/Q/RG0c34Y+C48s/9DF4n2S81ejJq7?=
 =?us-ascii?Q?ALWE8PSJwvEajCdUNnfL+l65zB6QvI0OrHkTMjYHyVDNQTPPwyWHAcIDpNpG?=
 =?us-ascii?Q?yW7/0hNWEGGqeLSD0VkZDrSsl2xmMELT83kT0Q0Cgnehxi//VkNgLz3OmIqn?=
 =?us-ascii?Q?Y1up00fYDHRGGGIuRzQ30SNgJ7HzJU65qh4QDJD53j4fBH/6vcNVuZErn6Cq?=
 =?us-ascii?Q?yD+mAzei+g+T62myfBwer/ylSOvTCP7z6xMVul3x6wCia+qQE/NU393q5BK8?=
 =?us-ascii?Q?7wk+oGPhdwG5A/21AupiJwNpSbT2XyiXnCaXqPvGy+/vNBXjpoqGRE05uE1G?=
 =?us-ascii?Q?R0SSlCPxz1z2niiI/VgWJ9hb59PWCDOH77Y1LVM2p4oqUB8MgBsDWtf4sNFX?=
 =?us-ascii?Q?WxSbO1YHtoCUAg9ASH4YRMl6Q/ZmiGSt9FSB6w6hVgOk0MQZJDgFtxkrnQ5n?=
 =?us-ascii?Q?220kJUJT5NMmtDQ/5yLw1e/ZIT7cvB4VDol8EvDoTOar+H4Cd/tcQJ2EBksl?=
 =?us-ascii?Q?CcDa8GVnd4bI0qty5mntb7B1/928OZSxB7XaKGj2juE/NWWjfi3O3n0CwJ74?=
 =?us-ascii?Q?bJfsikfJ+WjTZxD1lV4acylcxA8BBb1/U/fx9uKgCG4v9LjcjI3/HzOnD5Ar?=
 =?us-ascii?Q?D+RJywkEi0i1ZmBNi38f0Opl73yATy29vm1x7WiWcxeliaLWFA9vg0s+7wdV?=
 =?us-ascii?Q?Sww8OXG1ic2jd+IHePCAFUmTvTsTzSbNcU5pCJMe7a0gAZ5dD73XVofzh7EN?=
 =?us-ascii?Q?2/6Nw5cc1rDuqwHKBuWZTc0Aa1nbH7Jcvkct9Z0Ik3WRszxpi4wjaaQRwP9S?=
 =?us-ascii?Q?vywolA5E5ZJHoOu0GrRyJDyY2+7F8X5viboFCtRWMlTrwzFR6hhNjWY02g2I?=
 =?us-ascii?Q?SDK+fswhhV12c5FBZtXYhVNedfCcx8JUW8dRkHugpTY772WWMbwXyP6cqAZI?=
 =?us-ascii?Q?jh3jKPZcGCmHUi9SRocyPGMwUxVI+S8hXldtQ4yW5awAOV4UyxciZzZue9lG?=
 =?us-ascii?Q?jYbXfUbTiFMmrfJOMe+aqWSIUL2pH1aA65UBUUMJ1Tu2IysogwWgHGM9HIql?=
 =?us-ascii?Q?hbyAZNbHr2DwqSVNtxixw0c6kSvgshxYINqhz3GDJugRn6i2zfe9RUOrAfQz?=
 =?us-ascii?Q?hnAo4WGqF4HpmHf3dIg+/28gBNEfTS0SSKTdpqsJHozF75oluHHXJBqdkD+1?=
 =?us-ascii?Q?mCRPYmQ4OMC/YJB8yyvZp86s1ylELGFgWKZjMtpyRddz6FWOXcDcv2gRE2CR?=
 =?us-ascii?Q?Pdrk33QiZcLgeC2dd1voZAIT/TelUgZSChGg67B8brQsowWwo7cryMBVYbqm?=
 =?us-ascii?Q?YWNNNdqg1z8rJcnDDepajt8L6xQ+Gflv30+92kHIN0oJ2VY4ULUFu/uX7Bp0?=
 =?us-ascii?Q?8Wdw6iHItFsAlOc8RP+jmLZpJG/1NruO6BcbJhLxbp8ziE2jtbsRHdUBiqG5?=
 =?us-ascii?Q?MdFHN7YWtELRvZ6Qiw52Xy6by1ZA/DtKw7SUTdIFBJNsSHAGhjwbKjFVou9A?=
 =?us-ascii?Q?LxbqhsIloTomRhULWVJ0Sz8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?gFptAReIxAo1jLeN9baQHNJnsBBHBPgbBNk2tD+VJH6dyQ+Yj2DCWoI3Tc8l?=
 =?us-ascii?Q?3DecVAOA5jligAU0L/Zi5im78a2oLF/J8iWC2817oi89exu22H/LzH/wcw6A?=
 =?us-ascii?Q?X+0mf1eAK5Fx95G63qaEQgWLGyYQIRCqSaPOLLP4ALNoFzun6aUDJip1/ZFE?=
 =?us-ascii?Q?5sD4/H7/dTSY5e3JB8BXrFB+q6sv6gIFpOvyq/G2AVk1Qqiway/XIs2+Ac49?=
 =?us-ascii?Q?pQob9wKERf+wAJ6jFgTwS92cIU6x+OqAH4V1ZlUwkSs6ysFC50xyraPdELAN?=
 =?us-ascii?Q?I2yZ3Zpx9AB8sjz3tEE3A59XKY89PuXRu/Yvk9qdSgc6ABrCqqTiKln3jtjy?=
 =?us-ascii?Q?GAVmyFitvOTH/O4VfUfgr86MU40cGidQv2PGT8jc5n/+f5ur2IYI/q0zxH/D?=
 =?us-ascii?Q?FpVaT2iy4ionPJQzGu22qwV+Z1Bs+mOuC4LauvjtwwFRwOP3gHlvNr09lyHm?=
 =?us-ascii?Q?CKpZWh1nz3YsjGMmGdQF0Ud62hZ+3mAzSBvLsbNysYrj1D5jiMo/aN3tvwyB?=
 =?us-ascii?Q?RSGFUpSdTgMpc16pSLEoiHGeP18WmzKWP1crXiD4sWxIQE/ngZ+aesuLycdT?=
 =?us-ascii?Q?yVi0ijbLL53v4K8f1ONKnbZyZ4uiXOqOX5BJBxnbzf4+qNjGEv7jp+ZCqUa8?=
 =?us-ascii?Q?RBlH/ESNLK4hpPbixeVJJfdXn327WcUJ3eCQNW8QldEzwxD9D+uSUcUljS5r?=
 =?us-ascii?Q?O5h2wYKbVtaVFqYPEwaMH46Z1JIzAcoZ2gjLGFRg0C3DAThPP3x3BXWGziyg?=
 =?us-ascii?Q?l/fK00O/cEOyJXqhoHVMvh0Qematjk6Gtd0k9KyorunHrs2VgRUXpF8NUpcm?=
 =?us-ascii?Q?1aaAUWGctsf2VNlO13E9b1sWhUQxJm22CeOs3drPJpqHWVaiwxcD+g62O/Du?=
 =?us-ascii?Q?hBafP5lxxHWWmMnAk9u/HdYcAEzdh563ZmblqZRfUsXukEOr4PnW9cX6BB13?=
 =?us-ascii?Q?Kg5oIpX9isLH53kRX0G89VLUROi7Rs121BSwC+O1E3ugo/WAG7lsyMt+zLua?=
 =?us-ascii?Q?Kl2dvsksUHYlCXA7r1SiRyD/z8QYFBjQcU620yvJYSrOXBVz2nyWx3zO/im8?=
 =?us-ascii?Q?gDy+r3HrW3kxtTsrLZFfRlKlPvOnFpJGT5uACuib6TdYOtS0R8PQhGdndBP4?=
 =?us-ascii?Q?BddhWXnQZb4ZP7ZKWWSNCog7CcQNPG45uMyzIP5Pqc6CoYwxBPrdn7Wmkuun?=
 =?us-ascii?Q?ZlnKjJjX3iPqM4Gsjd7pz7DDhWIQkbuOak2dRQWi6nPlSfEe06DJosNLGCn1?=
 =?us-ascii?Q?rFEcyNLfF3B8B5RiDaR6hQ9SGpzzde8fR1ZFHfocH/TvPMTvaOeDqeJo5ABg?=
 =?us-ascii?Q?arhi6GrLgMveRJWsv45KwqGwDDg36t1hz0zjhYmhxjsLBD36EWUZ+avT9lzw?=
 =?us-ascii?Q?qQGvOhf8Zx+XhYaIR/KAd+pa9I0L8ujhIN5TLXxc8+2Vfsk2xjzcxAWjVq3a?=
 =?us-ascii?Q?mO4JeW12idozVihcDwygzRMREjxT+Dwr0z2vycuUa6lUS8Df5ZSRl2AQvSGf?=
 =?us-ascii?Q?xnau3S8R1J/mMCn393mSkRckZt1o1VNa1dpcnD1WgvnpBU5FlLQCczBlqFbW?=
 =?us-ascii?Q?Kh/VD8EgbxGPBXedYV4LzXIaGgq8oyqZ1W2My82n31OjvXfMzUyT3IRGuoCt?=
 =?us-ascii?Q?e5maepazD3oxxHC8ovIvWbG8MUlEI3AGbvV/KNkb8T0R0NNu14NP5tNbFrUV?=
 =?us-ascii?Q?008dQeZWsqSLyuBwsf6EXBooC3UuVL5cHPxCbHxTMcC/H+cuhiK2+MNZXphO?=
 =?us-ascii?Q?8nqQCrSpkYSJ7StFGpqVqKNBm49v3Gs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8B429AD769ADA744A5B371A25B2198A0@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2pyhlQBm5glhZJvhmgpTxGfFDnl8EYBr+Idhd2ShYwYxsaiwx5yVGw2Vr60swgE34Db1xiNDgKPK2tw4PDm8y6BXNI652Fd5HjknhMyWHn1i/dT+1LDiwvWBZ33aVOfq5p04Xrn7JzWCnhoYBUSr6PZG4yIp1FgrmeNHp9CnD3QRe+h+FaTeXEZtURnD4M8rJalbfHh+JXyS4ac0VIxpwuEJSjY5PCC0U4yS0Ysjqf+i40h2cDM/ctQRQnFs7lVoideWbD4IgTDeq6YU7NzJS2jbkV45NhQjxEdq2fwTNP1npDpe5UFxrrh7iaqepJ4aWxYszXzgLPyEPRt9DVxEoydsdOkt5XegH4BAVCm4j+c5haq7Sqq0tIkBptAVyBptKKqeSEDhPKV1KvV18O1gaw9+abFT4HiVMMU7aV3KdVDxKQ07xQk2QqVTR6yrIlHq2tbYBQl8plUbiSjTlS22rgI56dyRK+aLp7VYwblWjYvLwRPaNyFI6nK/KuifaOunnf7321uD/Hnks9apkMM2LVcYb4aOuXZHCJBX60jQRcQg/BUlmQjObCJM6Jv2+tR/ZjgScEKVOk2YWAjuN8epRkl1TW5TQBm3+kGNxOmr5u048UjdZHFUjrH2SLELN0Hl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91aca0f8-0487-4185-b4d5-08de6b93debc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2026 06:39:57.3927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0m8064XuNZmZq1H3EYr5xGRudBvHsuCF0qrErqShtc1ZvZ2mIh1169t9Kwq/0L2oZ58lK6J7GOoNVR8n1Np1iI+Yh26DURkiaDvErny/OGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7180

On Feb 13, 2026 / 14:14, Darrick J. Wong wrote:
[...]
> Why doesn't udev record anything for
> nullb0?  I suspect it has something to do with this hunk of
> 60-block.rules:
>=20
> ACTION!=3D"remove", SUBSYSTEM=3D=3D"block", \
>   KERNEL=3D=3D"loop*|mmcblk*[0-9]|msblk*[0-9]|mspblk*[0-9]|nvme*|sd*|vd*|=
xvd*|bcache*|cciss*|dasd*|ubd*|ubi*|scm*|pmem*|nbd*|zd*|rbd*|zram*|ublkb*",=
 \
>   OPTIONS+=3D"watch"
>=20
> This causes udev to establish an inotify watch on block devices.  When a
> bdev is opened for write and closed, udev receives the inotify event and
> synthesizes a change uevent.  Annoyingly, creating a new rule file with:
>=20
> ACTION!=3D"remove", SUBSYSTEM=3D=3D"block", \
>   KERNEL=3D=3D"nullb*", \
>   OPTIONS+=3D"watch"
>=20
> doesn't fix the problem, and I'm not familiar enough with the set of
> udev rule files on a Debian 13 system to make any further diagnoses.  If
> you're really interested in using nullblk as a ramdisk for this purpose
> then I think you should file a bug against systemd to make lsblk work
> properly for nullblk.

Darrick, thank you very much for digging it and sharing the interisting
findings. Yes, it is really misterious why null_blk is not handled as other
block devices. This motivated me to look into the udev rules, and I found t=
hat
60-persistent-storage.rules does this:

...
KERNEL!=3D"loop*|mmcblk*[0-9]|msblk*[0-9]|mspblk*[0-9]|nvme*|sd*|sr*|vd*|xv=
d*|bcache*|cciss*|dasd*|ubd*|ubi*|scm*|pmem*|nbd*|zd*|rbd*|zram*|ublkb*", G=
OTO=3D"persistent_storage_end"
...
# probe filesystem metadata of disks
KERNEL!=3D"sr*|mmcblk[0-9]boot[0-9]", IMPORT{builtin}=3D"blkid"
...
LABEL=3D"persistent_storage_end"

The "builtin-blkid" looks recording the block device attributes to the udev
database. I added one more new rule file as follows on top of the rule file=
 you
added:

ACTION!=3D"remove", SUBSYSTEM=3D=3D"block", \
  KERNEL=3D=3D"nullb*", \
  IMPORT{builtin}=3D"blkid"

With this change, now lsblk reports that null_blk has xfs! I also confrimed=
 that
the test case xfs/802 passes.


> > Anyway, I think blkid with --probe option is good for fstests usage, si=
nce it
> > directly checks the superblock of the target block devices.
>=20
> That's not an attractive option for fixing xfs/802.  The test fails
> because xfs_scrub is never run against the scratch fs on the nullblk.
> The scratch fs is not seen by xfs_scrub_all because lsblk doesn't see a
> fstype for nullb0.  lsblk doesn't see that because (apparently) udev
> doesn't touch nullb0.
>=20
> The lsblk call is internal to xfs_scrub_all; it needs lsblk's json
> output to find all mounted XFS filesystems on the system.  blkid doesn't
> reveal anything about mount points.
>=20
> Yes, we could change xfs_scrub_all to call blkid -p on every block
> device for which lsblk doesn't find a fstype but does find a mountpoint,
> but at that point I say xfs shouldn't be working around bugs in udev
> that concern an ephemeral block device.

Thanks for the explanation. My take away is that systemd/udevd support is t=
he
prerequisite of fstests target block devices. I suggested blkid -p because =
I
assumed that fstests would be independent from systemd/udevd. But the assum=
ption
was wrong.

My next action is to set up the udev rules for null_blk in my test environm=
ents.
Thank you again for your effort.=
