Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CDB1B6D11;
	Fri, 25 Apr 2025 09:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745571807; cv=fail; b=BqJr7aiSzj1rKRuJKV8fr39tKJkpWoaG5QI6z/BcUKoUnMcw/cyDluFxjlKYC6jZlv9OVTL94GOCoslBBGwaqrScLzHFYe6GflQk5E5X4irjK9PQHihu2K8um0BU/zqo0PtjnkRBxo4tsyUPhCi0hYPBFe6+NtiAxV+Fxoc+Hgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745571807; c=relaxed/simple;
	bh=G6dTezxhmn+Ajvd0jUD8aFAn1S5y263o5ZVWgcyvkyU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ll67S4PIZ0AhbNMdDBMj6AMLlxiDeyQC6tYuQssuPias92VKaaIVKrwF0JTGyQiCMDfXPRrgMRvWralktRpl8hC2sMQ5b4dv87oxpZ20gcKLZQ80PxqdNambu0b4g/SkFPAtjOFtAfBhX6xp0wHEKyUMGQv02kAyYfXCpvB9jXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Up21E2Vx; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=EtF5m4KL; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Up21E2Vx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EtF5m4KL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745571806; x=1777107806;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=G6dTezxhmn+Ajvd0jUD8aFAn1S5y263o5ZVWgcyvkyU=;
  b=Up21E2VxXq/2MvcsLENTJuPVFxB/6fsptKqonAgjdCJUNsCPtuD9fY5R
   FxC2SWUdIuM+NmVJLNQDmHQnf7lDNL0jM8VBlhHARasGVxkFzz4qNYXFd
   H0LCUeTbsro9qxWG4brzYDAaVXT52lAlNfLuaaKUHqRsPU2zEzE1Kuq8z
   hM/X0Aneahc1aGUM8fJdzs0EvFWAUTo9Xx7kP7P93zclAjkH+cQuCjk4x
   ot3brJ+GkFS+Pj6RuYsjX2JqJTUOCUXZFFJmBlKGO+4+CA8u9+e3W1qED
   REZ6Ti9MzlTfO0iv4eTMN84GNJaQlbXvbOTqP2rZnfENwhp69uFqGx8KI
   w==;
X-CSE-ConnectionGUID: 1CP6JKb1R0qweJHyAKhuXw==
X-CSE-MsgGUID: cf5IrxtvS5K5nEheiqkShg==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="77775070"
Received: from mail-westusazlp17012037.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([40.93.1.37])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 17:03:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eiy+4YJO8Ll9w3jiHiUTsen0qMDThyu3PxneijBKlrU/6oD0WbpRUXCt55uQr/NhbyuoOET8egtFB0usf6rfPjucFDoz3hbJ0zclLz0hmPpTt5eItvqmRKd/L9AcblVVTYDOn26Ndu5DqyKv/bROABkal2QS5YSo+9ms08qmceYRQ1fw7rR1X0E7OTBsiG6fMNFSCmSE4lwAikeyXzMnMrn3P58r/fOHayuc7kxcqynex730y9uhzx8CDJYZ3XHODKi3OubhqdE8AVEEHWGpfP3BFyLFDqx73jfxwvxsUU9Sj2jkoPMxlpx3QHh5SQWU5qE3L01hypov6wKmbxgDVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2fR+ls5uVTfnI9GWyfPeqELUkoqU5Gfib/wiucs0CYY=;
 b=MUpABgy8C5mNQExvkxOPgOBIRud0qyiXcohVvEHR54JeDFEVwJLj1ZGoI4DAm3Ge8wk3syFstFlrS2LaZyepUhJcptP1W+1vpJH+zTkscRMF5sxho0siuzDcFMSWoagidRhLVvl2rLkua7XGxJ7v34h40dXVQ+Dj6uO5wL7xHemG/XM2+q9bEPNw2l4vQkcNg7OEVDENU6n0Y8OU5cGqnKhI/FvJATvaRc9x6OpUgKtIEGLpZ3ItH35whGySdsYyAjfzQAI5gRMw5Y9TM5k3ZYG6pcwGDasUAUEj+L3HjRwKtmT2NVWPznM4aAkX7CaoRe7BOE3Xrrp7acU14Y3F9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fR+ls5uVTfnI9GWyfPeqELUkoqU5Gfib/wiucs0CYY=;
 b=EtF5m4KLw8YIDbGXyLbZkx0UhiSxdQquzAPjf/nlpXKIvJ3P07We9ZRn708jAl7Vn1KwG+cSYEjuHU8Zlpl2OMcNUQuQvPA7D4sD7wkt5LaS8wcwFtiz9TJUodIcy/p7UIytSNe5GVqa35oISTeb2zgHpV+F30ywmGH7GsmQ83I=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH0PR04MB8131.namprd04.prod.outlook.com (2603:10b6:610:fc::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.26; Fri, 25 Apr
 2025 09:03:22 +0000
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
Subject: [PATCH 0/2] add read-only logdev/rtdev mount-remount tests
Thread-Topic: [PATCH 0/2] add read-only logdev/rtdev mount-remount tests
Thread-Index: AQHbtcDl7hUd7Pqk106MD2EINbtBBg==
Date: Fri, 25 Apr 2025 09:03:22 +0000
Message-ID: <20250425090259.10154-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH0PR04MB8131:EE_
x-ms-office365-filtering-correlation-id: 3f057d1b-9086-4ec0-c9ea-08dd83d807a8
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?V4gtF/7VAUvXXLSh+mVooWafalc3UEL+uFVm0cKT1ktAvHbed0cshB5nRj?=
 =?iso-8859-1?Q?Ip6te62/tFRN5owAqEayl0yMbAiqj0W92o3oIPQEEow5q0Yk94JwfVmVlx?=
 =?iso-8859-1?Q?/Z4lN8TDFsdqInSn+5CdfiaYZjigZTwRJ9hncIz2zyw3TrHKJd7VfriYQn?=
 =?iso-8859-1?Q?udZ9mtVs1/QpekhYwKlLBy0FwASC5rv2acKFoMxKcp2wkZaAOtQHnHxMS7?=
 =?iso-8859-1?Q?4DC68WsO47+lCIPF1rBTSp6YTreZWYuxnax+IWoRkFvfzUmWEUE3jQ6BYd?=
 =?iso-8859-1?Q?qTKGUUh0cS+5L30Zks5grmRPxG2FhkdtQnu74Q6q4jiCVnpdN5s31ZPcmC?=
 =?iso-8859-1?Q?7pILtprQNVtVlkYDMFckYPVavA238laicWqy/mqWi8pQsHBbewRXEOn2DL?=
 =?iso-8859-1?Q?776w/wIMSVGQuvfezVs7qHj5Y9/rVp0ZiaT/T0wdTu8NoO1sB9LS8KYn9D?=
 =?iso-8859-1?Q?bJHHL+3c422FHGuEOaMuracxXH6fwP4elQH6LjOJzmytifgFppwp3RbSs7?=
 =?iso-8859-1?Q?wZ4+xlCzQurO1Zwk5eaupt5db9o0CzwT97EAraPJZJ0T+AsA5kFivvjx29?=
 =?iso-8859-1?Q?t4HCysHy9CxG97huSYAdknnpbaMCH+5p0GqoRvjI8uonhfjzj1LMoqBH4q?=
 =?iso-8859-1?Q?R89l3O5pjtfnL/rlVnEz15IvkbD/efqm+YiUMuEHrYSh73E3N0r/8JINK/?=
 =?iso-8859-1?Q?BhVS/O0XuxsmUA9G26rEgPvLsXz+Pw7dGVVzDobzV5U2JpNVoHoHWgTxSf?=
 =?iso-8859-1?Q?lrscZsVTQSRww0YLLDLnOwH52LmyTlegDZP5w8520bVQothM5SkttY3+LI?=
 =?iso-8859-1?Q?gzyMH/mujxceExntVg6eYcsUEfoxbVsUX4pYY4y1FXh5BeaNeELDhcltOP?=
 =?iso-8859-1?Q?69ybJ30RDYvBYzmMvgaQUeqv+bojEMde6/ZlbZRNGyWtD23SoTFgf0eNNJ?=
 =?iso-8859-1?Q?Ims/ouApSeFvId23h7S+cxSwpFmrdpZ2c26Ivy5nggraP4rOutxXTJJqfZ?=
 =?iso-8859-1?Q?yyR0GhEA0FdLGXbj4/iN8Q9FHs9fMAqs+K+kP8aSLutBk3YFU1lDy0w9/b?=
 =?iso-8859-1?Q?a5uAVBhFSXTplHj01dwD8LC8qrBIGFWVX75m0/IXGuUdgT6pSd9R9B33Zt?=
 =?iso-8859-1?Q?kJ5UiT9nzqVZxx9r5iH4mhn2pmQsWBQVdrpic7pB/a4ykDkt18HMIawcIl?=
 =?iso-8859-1?Q?Zx9PY2fUhtuFnKnGZbEBrdDWnskMQaP3qaM5XZOhMPq+o7NF8hYKq/kgIV?=
 =?iso-8859-1?Q?culZl1kTdTleaFHtA8B2/+BiEZyrjvjG59e6Cd6pOPGcwKUmA92DVyBI0M?=
 =?iso-8859-1?Q?p1XXwcfeGFoNiCxzE364hCm4ezfnEPere+L42MNuKAadn6nxdrbAZPVyzU?=
 =?iso-8859-1?Q?ddBp68lbD1a+KYgWnCYEmQoLRSIvbWcPpZ5+GLX6cfcAPtfqBZmh4OPE/Q?=
 =?iso-8859-1?Q?if7QUcFlAY1hVU9raf8b31Lp4KxNZUpTw/hrVzgbZnE2TUKnd5ki3KvUP8?=
 =?iso-8859-1?Q?0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Xgq+Fx1NJHypfN2wD4csTqT9rbNmHiNeDE9WfD/RgoScNmNcq9smVCKBvF?=
 =?iso-8859-1?Q?T4Z1QiYW6cCd4JQPBD5r3IaaUtdhXWU/vr9e6uWPtyfzkr602XypPzWK8K?=
 =?iso-8859-1?Q?VoxvYpXOrC03NrfqC93PPqu+UdkiA7fMZCj9AeqbqwHR9HWGpOfQQo0rT2?=
 =?iso-8859-1?Q?+BOy8EHU02xoya20yp5vpFtobZmIUybo0BbJ6Zlqrebu9BrJMMk5cIiUb7?=
 =?iso-8859-1?Q?TeMopmQqNRSmDAzqPx3SJKCtVm/uamSgiCl/Zqn7tCixg9G9AoZe34sOBY?=
 =?iso-8859-1?Q?P2RnFO+5XiVsdur4dO73E23QEWE1mn0A7HmiFi5+3Ar7iPDdbwIjd1l3C5?=
 =?iso-8859-1?Q?kUn1Q9/FCwDQMWfb2Dnv5R6pcxjEVtL87V+3iwBQclkBbGkmdfI+yN29Gx?=
 =?iso-8859-1?Q?W/3hHyS4w8c5hAkr3vE+Iiocf1LAhR4QSVvjYHna7w3F5Zhxok/1gDWcQn?=
 =?iso-8859-1?Q?MbYGt7DCHuBTwrq31pfDtY1BmdZ2CJgCQ7/6hnpWMzG67kH7rd2YyPdLOK?=
 =?iso-8859-1?Q?kLe/j7sRnAJ0vD2leDPw5O/yrQhPQ1qTSTOkXEIiUrw8tsdBGSB2w5E3Vi?=
 =?iso-8859-1?Q?7snr54Zrr9T0Rc58AFk4qgtZX0/OJNK5ZFQaaknjP/iohWzCChHI7daZRI?=
 =?iso-8859-1?Q?lvg1LIcwR+J6kTPDUnOHRsscEu8DMOPxAh/xcDSbKb/bcH13nysj6KIytz?=
 =?iso-8859-1?Q?rsmhNYC8okojbsCA7ia2clDMtD8xiYGJwNylE1opTQMp6v6RQPIz9q25kP?=
 =?iso-8859-1?Q?9M/gyKbR2dfpyk/I3ChA5rSQxnASfQrRrMI5naKTQJY1NHqRukfHe6e7Hx?=
 =?iso-8859-1?Q?t4i0m8EtlGnrUYlEV4Mlydtgwp7HaTbt2hLXfoiztL1pCO4yj9Njw5bWbC?=
 =?iso-8859-1?Q?cHTSVHz07Iu2ZboOOQXVizf9vDLXeJ0otwMd8lx727lYMzM5kW16kkU0Jl?=
 =?iso-8859-1?Q?/tK0fNbuCLFJftMrRee9Twz6Hg543XqE+fzYXCvwCBRZgCUhzmoJ4NChNW?=
 =?iso-8859-1?Q?5VSMhz2tgm+mwRsui7O7L+g/8ksg9ei+uP/SRTeha+SaqootwN/F1PEOBC?=
 =?iso-8859-1?Q?Rx4Kp8hO6l52g82fZMxjtj1+HFtfT/HmpogrkboIf1xAsk5860/JjMAPJs?=
 =?iso-8859-1?Q?zDeyTAzCHxnPP2BhgZW6iMT6BM0lJwMw2Okzwh5xyi8g3HqRC+EVhgU/aj?=
 =?iso-8859-1?Q?510IzMATMoZx3OTidkdYnyzJ8BW6G/5Odr6vryToT3hBuIOW5kzQmzovKi?=
 =?iso-8859-1?Q?Zfalsj1h4Von4ieCfxzUjb9fQfH57R6yZpiqw8wGZ5BNLcUGcY6qDlqDW8?=
 =?iso-8859-1?Q?4pxCwNr/edNZ2J8XkPqwS1rFD33eyVeTsO+8p2x3hcEOifhAfGbmxUI0BO?=
 =?iso-8859-1?Q?GZ8qL76nbQx+5m0RhumFcx0e2dAqUvTQI2NHVMTD2kMshb7h6aPOyaXVdj?=
 =?iso-8859-1?Q?xv7xugtbXGrditoU31r8LJ2j5duo+k7QTK1EQLnxuY60KMyZhzBa8+7Bih?=
 =?iso-8859-1?Q?DVqTVDvam2w5Riw32RNzIXSIssLH8xCFjB+kBatpdhGK8u3Ag2EaeCQgkj?=
 =?iso-8859-1?Q?qeOr4Y3y+XO8VXuGxnDzgL1QpfLfuQMwY6a2nKw2GC+/1rTSI7ydjBxLCK?=
 =?iso-8859-1?Q?pH0xJcnMrYebMC1ilgyboy1L1zZ/EspXxNfKXDdOl4FDacluoMKU5LFQ?=
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
	RvQcHJRoG2oEgDKikss6xLKfcoQOZK4XFWCvZn/asITOfvsX4zXtIarcDZ0Ya/u5LB9sFd8mIudEkQ5o0PsMvbd8tIfRTfmhyJtjLoGsi7YYdk374y9OuNh9/l1xKqx2fqont/Aug5fqqZDiFwIOYWnFo0bIjguUThFUxfRbqLu2F2cNGiMIW6mFP3+iA/dUCrRvk2Ksey8TI3W86KkVpyYZ9SwSbpmCo8h8LDEbKp1BjQDmx8p4SZ74bYop/mV8AnHHpHUeUVVzWfcCEW6u+TgHb2B5D47bmE4DdOeNN6CMR/yjlWZ8QelYo76jf2YY0zPQt14lqAWgf7EZtXPu7lkyw7PxG+nw5lhsONCn8UJkKzuy7Re9r1hVACCFLAbUfRgweIM7q0jOEOxJ8zHX/nJ3Kbl5v8wMvilKaARuV+HKuIxGYo10S0aE1ojVLdwXrrRVXNuPJzm01njpsJ3YgLfoliACZA8mQg9NNwPo2n37ex8uGQoqnxQ7rjGbWZiYjBvZKfsCLv1O2WWcUaVIQE2R9Jwcluky1nNMPu68WXjZJ5+fFKCuak3hiT+aEGsvLGh4v/QI/JmhO6jdMsIbW0B+lZy8qsZDbGKIMhJQ/VJt+aBLswPKilwiuGMObocN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f057d1b-9086-4ec0-c9ea-08dd83d807a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2025 09:03:22.0541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qvuLpLNyM8C2lpLeDBBL1nZ4ZMfsIzkHFLZHAoAPGdUIhHCJ0xl+6x/WRvmwdSUFBUJcC6Ly6DTNK9p4oOJxWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8131

These two tests checks different mount scenarios when logdev/rtdevs
are marked up up as read-only.

Currently these fail (mount fails if rtdevs/logdevs are ro), but
I've submitted a patch to adress this:

https://marc.info/?l=3Dlinux-xfs&m=3D174557094404857&w=3D2

Hans Holmberg (2):
  xfs: add mount test for read only rt devices
  xfs: add mount test for read only log devices

 tests/xfs/837     | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/837.out | 10 +++++++++
 tests/xfs/838     | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/838.out | 10 +++++++++
 4 files changed, 130 insertions(+)
 create mode 100755 tests/xfs/837
 create mode 100644 tests/xfs/837.out
 create mode 100755 tests/xfs/838
 create mode 100644 tests/xfs/838.out

--=20
2.34.1
