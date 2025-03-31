Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A7C8F5B;
	Mon, 31 Mar 2025 09:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743412575; cv=fail; b=XNx4CN+ffKCrLkoiOTkA4tvtEN86BEDMqHWT1CYIBtzuANQZft+I2Ts/cB351HyImuaLeabNYwdR9O+u9bfnHlyHD1KPjBYEIOF1z0rO70O+Ygy78bZcLhdbRSJd2/NuynrK8XvARKsWEOpaaC0wxA5bFLKB8itRFrhW/5hbd1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743412575; c=relaxed/simple;
	bh=GqFJD/XUsHmOpcVRgmQaWie8i8V5q20QuePqCjWporQ=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=uAOaVSrOgxuAZ3T/T/0uK61G5cAluO8CmdK+YdABYql6jolq8aEHaD9MqN50e4RNJ/PtncbY2aU0rugI/WZcpQeg3Q5N5U5rkuiQsAKmLDJarGKz9i8P2CC/b2o00Wk/Dp2s2YzNrK0mspvrzdEerbCdChDCfiFHRkUBQe381ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=O23rWRaW; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=xGWxaiFH; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="O23rWRaW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xGWxaiFH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1743412571; x=1774948571;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=GqFJD/XUsHmOpcVRgmQaWie8i8V5q20QuePqCjWporQ=;
  b=O23rWRaWVSbQMLuWHRfz65kQ6rE+kW5v4Iv9z6fTkKMW1xfMXJ5WTcSC
   pF2Im9hGZE2FQOvXcAu1TE65zZAqbE4ogbWJosTRTNjQtGmK3A8vyTKXz
   5Y1Ygy8p5jWM66wRdyI6zgCHnoMcg4QO+++YttGmSX/CZxz/5COUv5EwZ
   /7TlQlZgPT/HYG/06Po/CvzAIv8aTjTXQB/cDOTY/5eTnmehYr/a3YWOq
   Jl+3QPlgMvydWmnckk7bnd6j5vjLiAwA7Xq/MQYo2ZIU/fmYTxh1RIJAb
   F6CHSdTRzxptxiidGmBw5Iv5phs8pdT8PuiltRYt/kG57OSBboyAcA1Qx
   A==;
X-CSE-ConnectionGUID: HowvQVrqQuy87TBhE7Nzqg==
X-CSE-MsgGUID: gI1Jtg9dSCiEIxfjiDMblQ==
X-IronPort-AV: E=Sophos;i="6.14,290,1736784000"; 
   d="scan'208";a="65727750"
Received: from mail-northcentralusazlp17010002.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([40.93.20.2])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2025 17:15:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IX3xyAGxnPCemTDq4Ri3hh2q8NHdnqoK2rmtGa4EIn5uLqm594J/c20s+XnaB0T8EuQ3AzVllDbez7F5Vc4+z7Yq7hLi0p7INIIx2GVBadLlz9LiqNSlPWM+AnJ+79V1vdicrdR9eCssH1Yq2gn5J+/Vnw1jqbRt9taqnHouUVjD40vRw44fRX7675GAOotWX+ZPhgcr4AIgmTb/GuOkQeHkdW+iw16/SqfeCGGNE4EGjBFHSqH6B3i0Sip+3B4zGMbWgI3ybi/MB11Pwl0F/dBelrzyDvW67E68Z1ia6Y+uobFa25APVScsS2s4M84POTd3eb1YP2HGSLUXHO5GKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sm9AchJDbAlZiWhmWWCnI7fLJp89dORwVGzS7VvVa2s=;
 b=obpTrX4IW7JO+etNw5eNO840SbR8QTESAzb3ovkvcueMbuGtj/ZHzI/6z54s3Rqtrjp9IGB2P8HfpDJjNtBjhrW+JPkckOAQFTa6XqbOsBWMFwJ5pRrFDVyvRyPFkoJH5W/E7CvJRc/f2jY3fiTcVVr/QpvJLvDKh5vt0s+Zo4jeBMYcUXKXR31AnczeyCQ7jhbJCls4HK/HCxrp/G3TJ+bo4vpnA319N6fwGucj6XtpztbJzZ4Kjc5DW7FrjZNbKAeE9RMkPWzoxqBtIaC0braSRLFP6x4WzsAA5yrYDR/1tSt1ZVUdSq8xpwtl//5KUU2zBljAMi/PmghnUL+bGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sm9AchJDbAlZiWhmWWCnI7fLJp89dORwVGzS7VvVa2s=;
 b=xGWxaiFHHfcBxJVH2XYdDkXvt9Yswr+47aLvSC9doyymZY2NzRRNj7BLT3ktZqjbmG0bteZQZZ9g797H9LyaczyeMyNH/3KG8oi9dhNSRTTXqPKdv82fgVHdzqpB5WYBHGsBgvvfcey1IlpXUBcEVywzTBh+W6Y4LTW3WFfWF50=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by PH0PR04MB8241.namprd04.prod.outlook.com (2603:10b6:510:103::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Mon, 31 Mar
 2025 09:15:00 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%7]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 09:15:00 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>
CC: hch <hch@lst.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [PATCH] xfs: document zoned rt specifics in admin-guide
Thread-Topic: [PATCH] xfs: document zoned rt specifics in admin-guide
Thread-Index: AQHboh1g0lt5Uvc2qkuGocBjSjWLeg==
Date: Mon, 31 Mar 2025 09:15:00 +0000
Message-ID: <20250331091333.6799-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|PH0PR04MB8241:EE_
x-ms-office365-filtering-correlation-id: c1b72a7a-cc5b-4388-c9cd-08dd70348357
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?WiAEgocRJgmKtQPXg+mI0uAFjJGwn3roYOLqpRQeKmH3f3mBygxYOTuKrH?=
 =?iso-8859-1?Q?C2VQxkpWcGXveHf8iS5RFHwItLwZJrgB2aO0im7tI72JlD6ndX7ASt3OOD?=
 =?iso-8859-1?Q?XOH45AwFQffAr/qhBIpIhtVgLhb+rjPc13Ky6r+U2lFJtOmB8ISUP5fCRe?=
 =?iso-8859-1?Q?kbiCiceVuHoVrhgEKjffCwHqtMFQ8+L3l6RF+6x7pnFKqjIyYWyjKoBNoJ?=
 =?iso-8859-1?Q?Mv6z9HDfJhRsjQqRl6ivDIPiCgwfFkISR89t1NDotXe87w5Qit1E1chYff?=
 =?iso-8859-1?Q?gxtm1bnEmnkO4YA0WU/oLitwcWJAiEXiD7z5oJTs3ZaiEULXUqsTAEtmh9?=
 =?iso-8859-1?Q?RtE+boEVv/hoFdV7XWCBq8O3LuYyBrxWR7GKrTNGfObMs7ASVgdxXkFD0l?=
 =?iso-8859-1?Q?pFxEtGrPIA1GRsMsxWgTWR7C1vBP9BJathWyyBvEV1TuHbM39aZmG9il3s?=
 =?iso-8859-1?Q?xS1TSVuQYCxfTa9qzW/r52wsEQ4VtvGN2i/5PuXxN2eRtHeA04abnKpYQf?=
 =?iso-8859-1?Q?z98niOutgu5A1b+4gmV1weC9ctGfArvSranp3uIO3HU5Wa0zYqwP4gtR+c?=
 =?iso-8859-1?Q?RWzdYkCoLOhbHwgllliarcim+5g2hDsCDG0am+u8iiOrfM72zjFUoAL7w/?=
 =?iso-8859-1?Q?ysjSHFjP5BH1Mx4jwjMHzNOMDXQ84mv+M2xC9YSDtjkixRg0kJ3z4RTgpv?=
 =?iso-8859-1?Q?rNHla/6EP2swCdJP8m7d5iZOyu0X9CU6axcV2j1rkN9PZasAkgc+HWBmnr?=
 =?iso-8859-1?Q?nkyHgujA0NU11U10j73e7UW67gO6rvQutQEwTFqMIv3LZ7Pu3KFgi8LQx5?=
 =?iso-8859-1?Q?c6UmCVtZiyFs6Iy5gH4xLqEtY96WRNUlw6f2Ms3CUjHzYR0wGSqJaRRn9t?=
 =?iso-8859-1?Q?C1LK22I+Pnk9RoBkaC8DlN1cXJ/+8+5YlXFFjPoAPfUg4wm3ZcinL6VkmC?=
 =?iso-8859-1?Q?zggssWjWXVsuXmg5ptqREhokMdPZ5hpOjy1jshkOhpZA2XL1U40y517TWs?=
 =?iso-8859-1?Q?+x4ggSYj7/SJpaCxbaSNpGyNLzz8j6Q0zqS+OqHssdtPWGjwGcJ6Ddvzp/?=
 =?iso-8859-1?Q?JY0v5JGhd5HJSk9N51Ia0GvmVYhSs+y9yrpRuxI4oTgWXBB1wTl3/23+ri?=
 =?iso-8859-1?Q?hnrxKX1+/nT5CiRlyiIRV/dux5+bzz4IKNaTyQn1dMDxQv/iQbLsroQNB1?=
 =?iso-8859-1?Q?rDg+uhr9fAMXlG5N/E0Etu70Fx9Dj0KfSA/9eczSZ06ucXDKY02FT9McxM?=
 =?iso-8859-1?Q?vMXyx2l7yAPo10FkHiI+AuA8jXCvUYMe00OVTM1WiKZ0TLd5ejnFRcBeu6?=
 =?iso-8859-1?Q?hB/gsRfwb8XiSTmbZNKlHpI2sJo6q5i7WF5+MKXkmC/ycmpVC82oDNIk2I?=
 =?iso-8859-1?Q?mOyCFvVob0tdB30dLDFlWQ8WzdAYPbsUuWsNGJG8jQC/2Vtiwlhb+aREog?=
 =?iso-8859-1?Q?dhqSYuHRGMAcL3AmFTycaR8wmPisKqWxBcpLlOfToxAnG3z1NxhAvdkrkn?=
 =?iso-8859-1?Q?622mpIy5sRfydqBlNoqjrrhjHUOel4/LlA7Cy5wzuPWg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?X4cxXqBcVNNYOREEU1UfDNAEYYdnm/zSKNcv6IleQbLpSLLE+KBY0EQTWL?=
 =?iso-8859-1?Q?1ECMgg/yxrAYZZtqe02AS1TUgQux4QOZVpGawU14njcN36xM1RbNPCE3Zp?=
 =?iso-8859-1?Q?Lj5gm3+alo0gZTe0b/AxxUj6G4JEUQ2jedSu8ZtO7UK5Iy/XZYvK/dxnMa?=
 =?iso-8859-1?Q?7lzklbedhefJ7rv94suEBB8w23oHPdpVjrjCz/HXfnZS4zlFDGh6SdKB2g?=
 =?iso-8859-1?Q?qtS4CoNvHzj1C0TusJeQEjoI76MBiUumr3lvhlK+K058YBZO6D2RxBsdEm?=
 =?iso-8859-1?Q?slOhTCe+lfn1cwzGWgsChXukUSfzZ42VjTZR7uPCi8wVvJfYnhO+E+XK/a?=
 =?iso-8859-1?Q?6zf3EYcqjuesMu2jKtd9ME5TRF0pxUYt3H2qNIqUFt6tZmY+nEsWtPS4Av?=
 =?iso-8859-1?Q?GPA0r62Eu6C3yrH14m/DeeE1aypBz0oPxcc/lxPtuhFxyuroyGG/ZNq30b?=
 =?iso-8859-1?Q?yRa07qCZpo+CW1LJcXFVrcDoCN8Gv3Oi3PhtSDrPAo8RSpRHgkz/WQL/WL?=
 =?iso-8859-1?Q?Iq6aMWRGYmq/zRIVoQVfWvFbBzati/3bSTDM7+oMHr1T5acERN028vlX8l?=
 =?iso-8859-1?Q?5+L0dqCqamQGc+FkRsjtugJuKy0C4H/roFeGCQDCT3IURozKM245mCaVOY?=
 =?iso-8859-1?Q?CCHtsHvCFDSB1SfczU1eavMx5AEAckpAKo8MtLL5co64O/uDEs5tOMx8kd?=
 =?iso-8859-1?Q?DpFJ5KDMSqm3gg8mbFfZqDUpYmU5BjkLkA/ScPAMj0APl988bwMTmlGrXi?=
 =?iso-8859-1?Q?ITuA3SZs9clc4kIPjYbNAv8W1LT5Nt1QFgWiDroZhQ3DUv8qSgoirN+NsO?=
 =?iso-8859-1?Q?Nd6lehaZOYDNdXRcnrm4g8AYtS0JADotLrAjSE/Rzu7PpWnd7vymSkZpUY?=
 =?iso-8859-1?Q?qnxGrXQGE7vkgG4gdOeLXaNfsl1yPwHfPzx1ELjrd8g3iZ2nqCM2rlSAgm?=
 =?iso-8859-1?Q?HALVuUQmpig/8gV31830ZqJI2YoMTHZHW2LQktOCCQc3wQTPQF+xQYNyNd?=
 =?iso-8859-1?Q?Vhia7BqEARm7aY+ak/Uiyi88xyGnAZkxzP61sZplfV08mpwVPPJ30K/apR?=
 =?iso-8859-1?Q?n25u4B6YgZsSFRUBx1CSQg/GLqEO9pXE+nKrYoeBretVDeNoyvejimQQXM?=
 =?iso-8859-1?Q?dTuG34rNCYN/a4/aYuTjzGdf+qWmL72tsdXrmDzk0jEFDa+yxy+df/CZwH?=
 =?iso-8859-1?Q?uofatfmt0Zfe+27KXAIDjTvkHW5twX7WeRaiIJyTM4X5W5f7nk74GzyNCT?=
 =?iso-8859-1?Q?I2tmYk4u6Z8ypJM/cDxRbuO6CwHFar1DdmE3ZXr/vz9PY8BuDYiO5NQWEb?=
 =?iso-8859-1?Q?RVSI1hsptGKTUhHAD/6lsXL9ELvhBH0CcQ55A1h2ewhhtUpBcXGGkhyt+A?=
 =?iso-8859-1?Q?nJ1qKB2rphQaI5gzThXEb5xZ30f9M52bsyCrEYNir4m50Lgonl3qz7Lyve?=
 =?iso-8859-1?Q?ZfEZtRtEkIlk9Nyp5Mpgy3a/DU24F5EOGO1RWhWLUbbHD6DYQdKJslmgf0?=
 =?iso-8859-1?Q?VC4QLghoTpB+4XZ69xdPjoNV4tdtZeZJM2VxMVUuJrFmZh5GSa2Kvb9nmf?=
 =?iso-8859-1?Q?Cehfpq6XF7DmYPhloKpT/lJOx2QfPdA6HYSXh5KSgiDPg03o7+0d2ukPu7?=
 =?iso-8859-1?Q?4oo1jnYO+GrMWWtiBR0NvV/i1glfbDkGSZ6GQb+r70YQubkuFPKo51sA?=
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
	2J1siql3KlrEOkY0Pv06zKOdFeVwWXAN3Dcqx/nU4m5aNq6fZvh3RYntjiwy/xYCpsAVF/IVu9UOes0WUK9vx4GOQ2SGALfSwjg1jfUt6YI4cANlB3PgY0rE1OjY0EwpCNv5Qv0Bk3LRL0Y0mBampqagHFSaBueQJXALSRhhNQu2dvZuPZH8MJCzzdHoy1DAEgq6LUJ30chyHJeZGUtGWsusEwaUXvekz0gbu5QShSKTzCv46WaDFfgXQhZmBpjqihyMlsO6ci2AN1SriggwYVvO95Wb+7mebjRoKgk+XKozKptopBMNBhqzVV7KajPFiRlo//L/QG7tmm6kwiLd+kB2KPKh7LUR70ESxiOBw3LpFCxgfM8T0qWfbQ8dYGsZdUxmj7ot3zDmJzy52JTiH6g9jHT+P542AfLwzY+NDxxEx+KsEfBXhHZfxVBC2iLeALqzGgqN+P0y6OALqEvqG9kL3NOFIhsu0BzGtI1IABeX5g8vTD6MX6o2WNmDZK5gGk0a/LKJsL0AKT/PFnrP4mQ2ev+A2NX2Wz/ypkED+9iQesqrF+eRn5Nwb3LisWMweHUQ/pLyVnwqqEq6Ot0Ha+EE+MetkygWKMMwlEDY0Mc0p4VeOSIdvMxWEUqtBGCJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1b72a7a-cc5b-4388-c9cd-08dd70348357
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2025 09:15:00.0617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GUky+0Nm3VbiyS7FZYi//qGbDxSO/4zvs4VAEOyFwQ0Iosr/IJuojt+CTqPXuyoIKdmOB3isu0ZCi/SwJ8Z66g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8241

Document the lifetime, nolifetime and max_open_zones mount options
added for zoned rt file systems.

Also add documentation describing the max_open_zones sysfs attribute
exposed in /sys/fs/xfs/<dev>/zoned/

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 Documentation/admin-guide/xfs.rst | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/=
xfs.rst
index b67772cf36d6..9d0344ce81f1 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -124,6 +124,14 @@ When mounting an XFS filesystem, the following options=
 are accepted.
 	controls the size of each buffer and so is also relevant to
 	this case.
=20
+  lifetime (default) or nolifetime
+	Enable data placement based on write life time hints provided
+	by the user. This turns on co-allocation of data of similar
+	life times when statistically favorable to reduce garbage
+	collection cost.
+
+	These options are only available for zoned rt file systems.
+
   logbsize=3Dvalue
 	Set the size of each in-memory log buffer.  The size may be
 	specified in bytes, or in kilobytes with a "k" suffix.
@@ -143,6 +151,14 @@ When mounting an XFS filesystem, the following options=
 are accepted.
 	optional, and the log section can be separate from the data
 	section or contained within it.
=20
+  max_open_zones=3Dvalue
+	Specify the max number of zones to keep open for writing on a
+	zoned rt device. Many open zones aids file data separation
+	but may impact performance on HDDs.
+
+	If ``max_open_zones`` is not specified, the value is determined
+	by the capabilities and the size of the zoned rt device.
+
   noalign
 	Data allocations will not be aligned at stripe unit
 	boundaries. This is only relevant to filesystems created
@@ -542,3 +558,16 @@ The interesting knobs for XFS workqueues are as follow=
s:
   nice           Relative priority of scheduling the threads.  These are t=
he
                  same nice levels that can be applied to userspace process=
es.
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Zoned Filesystems
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+For zoned file systems, the following attribute is exposed in:
+
+  /sys/fs/xfs/<dev>/zoned/
+
+  max_open_zones                (Min:  1  Default:  Varies  Max:  UINTMAX)
+	This read-only attribute exposes the maximum number of open zones
+	available for data placement. The value is determined at mount time and
+	is limited by the capabilities of the backing zoned device, file system
+	size and the max_open_zones mount option.
--=20
2.34.1
