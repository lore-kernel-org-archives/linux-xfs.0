Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377BB2459E5
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 06:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770704433; cv=fail; b=gfnLpitgf8J0RTeRCrkSc11gQguanNpUXSAvz6vB84cu8E/TjyENis2k93ofqNPSlWqGF2X+Vt2F2g+KV2jwdi3BpmN3WMxO0ZrQWQoPx1ZahObE7FVBMQ6snRviKqu3Umh3FCzZfqglwMXofJQG1n0gw38d8KKeOK9uMPww/74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770704433; c=relaxed/simple;
	bh=gK1zyS5ulYnYbYFoRq7q6N2UPQIs0ZwbBs168M/uCXg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bLqkex+HiVMobpn0uD/mf7sNYwX2aEWPCzhi1vF924FEzylI+b3lAg0BUAeeHl0hzN85WmjBpR/az32bzD3qCAShUH3ueQiwRyy00rtxrKxFdixQ5kApuPKhrHjBekvoL3bqamyH1h+Um8oT5EfCzngB5EV78gyBkUApuxPtmFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jPKMIqPU; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=m8vpereB; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jPKMIqPU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="m8vpereB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770704430; x=1802240430;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gK1zyS5ulYnYbYFoRq7q6N2UPQIs0ZwbBs168M/uCXg=;
  b=jPKMIqPUpnhb8z+QhjowjbnecWTFl4ghvVs1pCvkvjFe4rTmACliS88a
   9Bua11ZWyNGF1GJMPVPouxmfEoPMfGpTot16r8+vC6dTpDHnw7c5GwbV4
   N1SYvxdZuNYk9A2TexBaq01APvlpwvje2k76l+kP3cjgy/rK1oTQwKDKw
   Ke2Vie89tsBsQMsIxJD3mqnG5ZO+RvwrP9ax4jGs6MSgcmwW91M9IkEt8
   dPLuf3ryMGErdisCLjbZQj8QrBbdAfIWwDqTv13T70msXbS+q8+W7Mdkf
   qk34cQCAIUSDBLqB95mrhQudtG4x0O29mrYMx/Hb9Xj2vfvowif0fflH/
   A==;
X-CSE-ConnectionGUID: hEjwNsc3TSCPoPhYdc+FmQ==
X-CSE-MsgGUID: RLRwaWrpRt+/3hi7AEfzTw==
X-IronPort-AV: E=Sophos;i="6.21,283,1763395200"; 
   d="scan'208";a="136935021"
Received: from mail-westus2azon11010044.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.44])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Feb 2026 14:19:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vvAqDeQ/r82unsAckifiqZ45czTzqmE1rkwM3GIod26u2fjmFrUBq63krxPJeg/mFcu0omwC0hMMkeMr0gqUc6mXiqdmiJwQT/3za+pRu3CSPlT59hwClCHWDEmKz2XarjXpaK3mESQDAHPs6LkpHXc2xJWnzW8yLq/CfTc1MsHK/CwVFvITM9LZtTp2vz9P2tvquKnAnafnnB3+OBMdA+Si8R5Od6pK30Bkt/+fh2EeCI8beOrFn1yy5Tqxdn6jCF8t1K+ypVY+oFR6qo1V9XkXPizo+C28QtqgwtuKHUMicg3R/PnqbyoigDCWRHL7uJj/shb2ORRatholwN8OEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/qCPhMiFO5BMa/aA/BC0g+Dc23FHwBuRESPKReJVuY=;
 b=BwyTbuxjJ6khg0oaJFwXX4tyN1iFCeUGu8yMJcoNQChRjsveObrghnFXOpCNMjTsH2KJNhxGzLX0K+Crw8tu280aClK0WaLuqB/I5EOJ4EEmU44Aco2JnWgY40yrn830uIzRP63X2txnaurV6c4FTaSrjGWYKHZ7sLA5seZDe1YyjIg5D9gOLgI0HOaEe08yM7IjlBI+2QYVwl9hXopFI9L1+/sCSrVvJnT5r9X2Ggziz8UUI6QShL/ojOU8bn6YesM8uHMbnoR+fHeJxvMDcmIqer8wffcz46y0oT6DJxF7FHCMXxNP5FcTOW/bHCDnAxTmFxwLHiV0flJB/pKwnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/qCPhMiFO5BMa/aA/BC0g+Dc23FHwBuRESPKReJVuY=;
 b=m8vpereBE3RtdOIQZT9nlezVPoecX9/RdJYrLuOIsODiaVARp//M232T7XRPzVshB6s7G1+/l5mLljJPUyRtZG1rlw766W05VZdVsw4hzs/xG52QNIjpyJQNwPoS+HEwGkUfcffgXFnSsdnT+Dn6zxhNYftpE2NolEgdwO6eeBU=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by IA3PR04MB9307.namprd04.prod.outlook.com (2603:10b6:208:50c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Tue, 10 Feb
 2026 06:19:21 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.9611.004; Tue, 10 Feb 2026
 06:19:21 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: hch <hch@lst.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] xfs/802 failure due to mssing fstype report by lsblk
Thread-Topic: [bug report] xfs/802 failure due to mssing fstype report by
 lsblk
Thread-Index:
 AQHcl0QyMGi0b3KRKkOnzTIETMr5/bV18CqAgAO+3ICAADcfAIAABeSAgAAYG4CAAS9wAIAASEUA
Date: Tue, 10 Feb 2026 06:19:21 +0000
Message-ID: <aYrKf6ukceZrSRhJ@shinmob>
References: <aYWobEmDn0jSPzqo@shinmob> <20260206173805.GY7712@frogsfrogsfrogs>
 <aYlHZ4bBQI3Vpb3N@shinmob> <20260209060716.GL1535390@frogsfrogsfrogs>
 <20260209062821.GA9021@lst.de> <aYmRhwnL286jv550@shinmob>
 <20260210020040.GC7712@frogsfrogsfrogs>
In-Reply-To: <20260210020040.GC7712@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|IA3PR04MB9307:EE_
x-ms-office365-filtering-correlation-id: 66966904-fb5a-4c73-2847-08de686c545c
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?H8cMm5FTTXMEGMMNPmbTVokBo0eyp75e+Ydk7dPBGosS2FoJpxOqSfc1x1iC?=
 =?us-ascii?Q?k/5smyggEwiNC0aSbPtdqZaPDU2cX8kKRSTbqPQQo92O7pQ0YMOj1NHfNr+L?=
 =?us-ascii?Q?zO6uqUg++GQEivd3zoDWmxojJRYM/fwEqoga8jMsvSLTT5x7NFrfyTIchM7u?=
 =?us-ascii?Q?PVlEF/4lhS3chqL+u50QeJSUdIh1oVxUu8BUByuxMmD0Pa5BH7jWEDXiWpNp?=
 =?us-ascii?Q?eGmQlWGvpcLFQfbc/VOf+UMzeq9vzk/D57lDGkfFv9LMLI7rpVKCbFaYOOTj?=
 =?us-ascii?Q?K8+4ncOg7UL5KfrJhkzd3mhH+9uq0TxYaXQ5ZmwXuv763tlCbrTMEv6+69ux?=
 =?us-ascii?Q?xcOQlKYlk+5Whd+lEARKpKqymsWxLDWpIFqFdru5LakK4fiuFMRkK7uXgjPe?=
 =?us-ascii?Q?K6jDfAJq4zanyVdmqHENBovcMob3mA1G8MV4gVnDX7TUXT4Y4jjs7cY7dZXt?=
 =?us-ascii?Q?VBALzMm5SDdYqbb3G9639gvWK0+b40l0w0hrr1HZWW+eLVfRGvSJ/R2/Jt7I?=
 =?us-ascii?Q?KCXv7JGmc8lMg+iMPhI/cV5YRUF8vBlP2QDjulCaSWnhOPRw+CloV2sJBwux?=
 =?us-ascii?Q?9fcKF7sdqKw9q3eMhp9/4gyYijgBvLxYIwQKiPFP7bAE+nkh9tTJLmtd4HfG?=
 =?us-ascii?Q?1Odfe2/78Qo0DJnWmwB5K3yMIv5SZk3+Wfitdt5YdXWWsU38bNs8lpQrB/w/?=
 =?us-ascii?Q?V1UI2kG7tdZ7ZZscYCRvLaHTw+P9X9yh+e3z5jUgblCYT30qDd3dnYuFCTP1?=
 =?us-ascii?Q?IAEzTzfGcfs5qK3aKcbvJNbwPCT9Q/Yr/leTuO8bASAXIhm57gfD0k2ykjQ2?=
 =?us-ascii?Q?0QEuOxQgooOlvo4kTAnFGnare1ior7Zv95Ngo0ZE43JfbkpM2Xz5lU7ixh0R?=
 =?us-ascii?Q?2qLmt/xhowy/d8A/rS5Yn4VLmCTNHQuoMYSCcibM1J1eZqrWPSMx4qj64xyY?=
 =?us-ascii?Q?B3GAtLpT45aHyJGwWNXy0SxZNx/bovPdPk5hsD4d4Abe+QzyTCeHlo5RAyh1?=
 =?us-ascii?Q?xZoEkOtnpOK3OFFNjl/wyJqWNOfWVj450U33uA7Ph83pB8J17LFVt4+sL8nJ?=
 =?us-ascii?Q?cZNDMNrqFbFbminLLQxFTqzNm+h6cGaEmuSuu1l8TMOvndYnU8JgOwP3iw/p?=
 =?us-ascii?Q?3XewgWvtJfayk3TnqiWi5Wp8cBGFZc/YBqDVqr1GYODvXBWRPrx6qaw4QGYC?=
 =?us-ascii?Q?Up6qGtoOhZ5UnJ4Lhzy7DjgyKW1vvIi9tL1mimmB6heFLoen4yftMHuGL2o0?=
 =?us-ascii?Q?sQrwGr8ipJPu2M3kKJVebdi3ZW1MSARfeSDKOOTnm5TABEWXzx36Cn4f8tY/?=
 =?us-ascii?Q?gYlMb9gphmrBA6P3ff8xmds3To9OzyaxRDVD90V0Zdohoa1raNGhXemiudao?=
 =?us-ascii?Q?P1nX6PO7LV4NLHRT3F7054/GXY1kEXdYgWzOeD9X0NTdhR2Nl7WdSqE3pMyz?=
 =?us-ascii?Q?QdptJJLIviIG0aEGCWDU99yk99mGHZ9dxGIgp03MRlbSmlcIejlJTzOi005o?=
 =?us-ascii?Q?2uZHCoftwa3eG6B8+0XRFXarknXFiFeTCthO719nU7G5g3JTUTm3R8E/q62A?=
 =?us-ascii?Q?XTPuqq9oSMBrArTZdTgIFHdWeUIBMFxf0lqmKZ2RKxLUNA/VIc+Ey4+E/7/Q?=
 =?us-ascii?Q?rq2VGBUM9dNgy0HBextmTKY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?VgF0PL1mKvvHyf/VAZvSe0e5UwP6/zpFxXcZbVRUmkKu83emqeJZVNx9A1G+?=
 =?us-ascii?Q?esDCtipAgQh6Z1w93zUzKwq/bsoas+Ny1Y7OVDZPDJIDj5nB4K0cKf36KzDY?=
 =?us-ascii?Q?X/rGCeg29zMdSHn4OUSkuA+YUaX1hbanHWKhNTwsXHBW/UyBHWR98ja1YWEy?=
 =?us-ascii?Q?DyQrF0USd1MXcaFyOJvGpFcCU+gAj3FkvkxbLwCU6Y9TW1c0bqCNsMK/JpR5?=
 =?us-ascii?Q?DRJ5c2jttCyN2/MYhFfxaW8LVsbV2dR3AMpJsAPsggGrw/Y4sYh9SyIZiv/9?=
 =?us-ascii?Q?zV3eC1U2CXvvoM0Mlu0bsG8x59qW+jUYe/SaiR/2b6Uembjbz0wg+l7FyUDD?=
 =?us-ascii?Q?poBqLMfUtKPqrK4O2HhBz3D0wWAKBXB/oFkunzIJKjRDC99lG8CrFhkprldv?=
 =?us-ascii?Q?mRyiYfHz4kcl3qarzvqABouIFJrF6irJ/m0Gk920kbJoKUsjynkDAo8ds2NF?=
 =?us-ascii?Q?4rmYnCM/e4VIMgtysvZmS5qIlYhshqMZc0CmqznfWepHT8jef8bjHl6q7U8j?=
 =?us-ascii?Q?PUdXxf8PDf0Dob6zFyZyoXYD3k+RQHuXmSyQOIjcSf94EKqk/IJpK+tJwhZG?=
 =?us-ascii?Q?PmcSf8euXFMMBSqmRS+u69oENRdFHqh8bheA6oFPrXbG/hJZgrj76NDKpSJi?=
 =?us-ascii?Q?gMUO44QoYRNeHpyoEu7a4HcatpjSp11o9SyFITrc27z9l4DOn58cu44UP1i6?=
 =?us-ascii?Q?NX/VTbKiZ3UuieGqiTVtMS6/OVItt+p78f31aPPHG4ZV/JlvZOiWnsHx0ymc?=
 =?us-ascii?Q?n5orTwjuqvbuqIJUF7GF5GRizFHf6q6uevT30MxyD3duQrqABHE6hRvDZEnM?=
 =?us-ascii?Q?7fw0aYzTgMPqmF7kNR+eZ1EEL7g7CYzswtl8N8Euji2K3sJ160qmnQJ5sEtF?=
 =?us-ascii?Q?pUMOqI3nUCNNZuCGx99w6GckDnLMtlWz2+0bUIJb4pGUAY8f67hXP90gqgWf?=
 =?us-ascii?Q?d4E++4Djawld5eey4us2e0ihTg7SqSnhTsbzBS2Bmxzi75ZjBEBMuK9SYxEw?=
 =?us-ascii?Q?JM8ucMVoOxUTWdSSRPQobPxOvyUcWhaDPjY5XkWFBWgWz1sczC3/6JY9XMAT?=
 =?us-ascii?Q?wA4OUCbnJDA00JIZYGJYdtwLYklgvHYmQz2Pyss+ZQxGiJkBVode92FMJPY8?=
 =?us-ascii?Q?k73+q8AZWv/zj/bUBHSlVo+pUbP0Qi72Bulz0pjAzd/LNu58VEy3jE+4t5zI?=
 =?us-ascii?Q?4A79DpJLGbpHY7exwGgfKo0ubeI3d4RbMf/NJGY2nf6WCQi8gSXvjzyjaQeP?=
 =?us-ascii?Q?do6n7idqS6URF1sAVf6znG2TznA2dnHmqsnVQTNWrJdXK5c7OkW5b1cLrGYe?=
 =?us-ascii?Q?XfwONtY5VcotMKWgXfHGBsy+jJMwmIyNWt2en8gSSNMDJ2VPgAvgAXgP5cz3?=
 =?us-ascii?Q?9uIoY6wQPQpg2TtNsr733KjcROHwAy8/bP9GN3cjLf8ESNgQJCxDmzC1zPxq?=
 =?us-ascii?Q?rEvcqpE+3C4xpQFJ34yKR6AlaOL1oEDO8TxFOnBS/s8Mw4bYJtQ/wFo4g0YX?=
 =?us-ascii?Q?C4qAHhZZmr9NPgbkn8xXCm0k1VtL3mZXG1/ma1ohchLCmYfZdHIDP8/xyp2M?=
 =?us-ascii?Q?Ipbub8fF7dDVwHwCWlBy5woCkXIApxh3H6HbbaI71ciJ+lHJDDh/8/b7HOHa?=
 =?us-ascii?Q?vF/K1RPtcrgu4USpVd624oYxpWvGdEWFpY2k8YTMOJ+6KVkJmBZuVosFCO8p?=
 =?us-ascii?Q?uVDmZDVAgPRl4eFrbOvSN5rFYbxq5WbACa6TY5tSaPgdN+os3K9N9FgNhfoe?=
 =?us-ascii?Q?ZD79OIMFL3A1hh+3r6iL04BT5uR1668=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D95C21A25997A940975ABB6C44EEDD7A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TIsI5twLA1D4Z8slHr4y2qcKyVkGee7e32iZRT1jZNVaZcgmh4FToQaXVuuJGKFgjbBKp95ubiJU5OSJ56HvUOE01zk0Pa/nxg54NslkYEqhQ5kXnfkMH6lIyPRjt/BnzzRTGkfXQ7MYBX+DDoWfeZp6+/5nERTHTjDG8fo9xsU1yccVTpcHweUBdN8VOgaGKQwWJuJ68KVGpg1TUey+g1LXEDHgPw+E/lOBV1yJCL5puywrk7CTHqI5BIh05zzMYyMiLPZc2d4GHuf/Hr1NHsk7F5hCx+faPxDlOw2VO3RsydQ/aqWCa+l4JPWNsczcgEAntUArtp0WjDBAvTqL4lNXh5xYkAYoHgh+FzWivn9Sazi9fJM5k4tFczj6DKK5aIEKbsvr6CNiQvszHKftrUs0VsX6yTHMVi4aazCQgrx07lAbTe9E1NQCrM0pysqgL8v1TbXR6fKYK8qHwSXrvx+nGyAGxU2ddNTL0XJ692G8XlHHZyj3fU3JihJrtxgtZTXSnxT3zV3FAonZ5/eyZozJRiI3RVkYe98ueV6X/C90QQyM7yPiH2FR7KHEKuWQBC8H+jimMtEWCHPnIdHdx+UruvCQaEnJoT6qXU716HJcNaDHSRM0akaugk67h3RN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66966904-fb5a-4c73-2847-08de686c545c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2026 06:19:21.4214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qg4gBtmS56saJfd69ObNTawyslcIhZq6VZvJHNT8Sq4almR97S/cyIecyIGabgjiHxCHlHTxbzJS2BnbcvWpBRyNffd69p2/WhynIbf/CJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9307

On Feb 09, 2026 / 18:00, Darrick J. Wong wrote:
> On Mon, Feb 09, 2026 at 07:54:38AM +0000, Shinichiro Kawasaki wrote:
> > On Feb 09, 2026 / 07:28, hch wrote:
> > > On Sun, Feb 08, 2026 at 10:07:16PM -0800, Darrick J. Wong wrote:
> > > > Waitaminute, how can you even format xfs on nullblk to run fstests?
> > > > Isn't that the bdev that silently discards everything written to it=
, and
> > > > returns zero on reads??
> > >=20
> > > nullblk can be used with or without a backing store.  In the former
> > > case it will not always return zeroes on reads obviously.
> >=20
> > Yes, null_blk has the "memory_backed" parameter. When 1 is set to this,=
 data
> > written to the null_blk device is kept and read back. I create two 8GiB=
 null_blk
> > devices enabling this memory_backed option, and use them as TEST_DEV an=
d
> > SCRATCH_DEV for the regular xfs test runs.
>=20
> Huh, ok.  Just out of curiosity, does blkid (in cache mode) /ever/ see
> the xfs filesystem?  I'm wondering if there's a race, a slow utility, or
> if whatever builds the blkid cache sees that it's nullblk and ignores
> it?

I tried the experement below, using /dev/nullb1 formatted as xfs:

# Clear blkid cache
$ sudo rm /run/blkid/blkid.tab

# Call blkid, but normal user can not parse superblock, then can not get fs=
type.
$ blkid --match-tag=3DTYPE /dev/nullb1

# Call blkid with superuser privilege. It can get fstype, but does not cach=
e it,
# since --probe option is specified.
$ sudo blkid --probe --match-tag=3DTYPE /dev/nullb1
/dev/nullb1: TYPE=3D"xfs"

# Still normal user can not get fstype since fstype is not cached.
$ blkid --match-tag=3DTYPE /dev/nullb1

# Call blkid as superuser without --probe option. It caches the fstype.
$sudo blkid --match-tag=3DTYPE /dev/nullb1
/dev/nullb1: TYPE=3D"xfs"

# Now normal user can get fstype referring to the cache
$ blkid --match-tag=3DTYPE /dev/nullb1
/dev/nullb1: TYPE=3D"xfs"


Based on this result, my understanding is that blkid caches its superblock
parse results when --probe, or -p option, is not specified. As far as I git
grep util-linux, this behavior does not change for null_blk.

Anyway, I think blkid with --probe option is good for fstests usage, since =
it
directly checks the superblock of the target block devices.=
