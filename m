Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1717C23F406
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 13:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739451817; cv=fail; b=k36eFu2XbfzwrJI8bneWgLz4IVQhHe0tjDIREuDDUtF59RM1RYCYgFlniz9u1ySwVqguy/7KYTOLC9cqvelQFtFJgdeqfTyn8XgfwMxeHxDnL6vsTg79NcLniwAjSqxC7RFAJpYeR0iZDzucRG3YaM+FoHpHbFtRl0MwvPAL4Jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739451817; c=relaxed/simple;
	bh=wPMAaHhVV0/3RtPQrDR4r+QqPZDSlBEGUX5K7rQnCH8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KKgWnm4+Ot5j/QN4e7DezyJmHAh5lKaBuKq6sDE/sT0NORmvFOoW/mr3WqyWZyRmEFgriUdzoEwgl0G6rTsi/L5QukAM3mW5qxjVkpziHYvE4dVgXLOCH1pySpESmwurwz2XcxsODd2ebeeocwwKnc2sSlDodPm/ohgiSxL9COs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oM+I1HMv; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=L5CGL4iK; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oM+I1HMv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="L5CGL4iK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739451816; x=1770987816;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wPMAaHhVV0/3RtPQrDR4r+QqPZDSlBEGUX5K7rQnCH8=;
  b=oM+I1HMvOC7YVckYJ0mlKJJf++tfuvNAyTFDHq6H1ZAOHh2iyKjOCEce
   pybYE1ahwEljTmofaQhyUxRL56Jl2lbEyqgCy79E+vDsKF6DX7Si2a2Js
   l5VEGKkl2CyhM+XTsgIvH6iLWCNV0oEVPprL7/cBZfQm0UJex4kTjB5x/
   9v8BemzX/Eb0Cju1qJlTycsoEc+E650ZS5EOrQtBQBw1EvwQXspafkt/s
   /mJJWWnaXVqISJH9FjHHhWf+M3pNqn+4zbnEtdhW/PJyD5Ssk5nuSmxVP
   hA+qL0b8wU8amStIMdUXo+w11dF+rRvzsvXidD9ccRpIlaki6MMSS5v8+
   A==;
X-CSE-ConnectionGUID: 5Kxj8OCwSEOyyikGdAj6PA==
X-CSE-MsgGUID: mBXTZ0pOQoWdEV1/k/5mEQ==
X-IronPort-AV: E=Sophos;i="6.13,282,1732550400"; 
   d="scan'208";a="38165890"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.9])
  by ob1.hgst.iphmx.com with ESMTP; 13 Feb 2025 21:03:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dQz3yL1h3S0MN+JVU0ouwtBnQ/J8DLNOwfzb/I+aYe+bTI9Si5Xo4Fc6DhQdD23VrTLjLi7eM9JfEnJmLuIEkV4jnCOrfLFNVSuuXl6e2nZi69nUP4Q3afIDxBYQ0sQnnVSuVrssAadPhNNHjKQ12NN4PrtPsZ9SV8REMbeQr4uw3YZ0lvTVhGptmGU1dC3QFjMQgqXWgKHIyg1dX46xSam3ifA8W2gYpgtUjbaQfWV97dBCwcyeLlX2qHlBZTLXkge8EerzZrrWDpc7sB7HA8NehtVBTDroy+bd+IfA1ZdiNxMppI2pwoUcrf181cEJ1njL8zbebxhRaSUdZ2ncLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPMAaHhVV0/3RtPQrDR4r+QqPZDSlBEGUX5K7rQnCH8=;
 b=BSP5ol8cjTN9mySDI67Z2/JQpzXEtllOP/2VgS97bKmOkXf8ov3+uYtsRk2/t5R/H3DpLOdmvBzUK2Ubi44ATJEQxMkQrdVSybjtEyjfTQ0CbZZng+HbAFu9SZ8fdb6f+yr7pwUGyyJBFkH9CE5zcOxkKZ20O4prolJAASiIVh+MPG/gmNS4vDHs5UwOrOx+W9eZs2psD29HGuynRSGxeYZGeqqkQK1HBB52cKzVXs7dKcsuyAXSU6HUaQ26qJmuHz53Acm0rCQqJ3YwD/WEm8FklVzMXIFK2l8yh/N32Li4KSu0vsnLrdQbf9Jt36XKLjoIQOA513BtdsHNaMggdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPMAaHhVV0/3RtPQrDR4r+QqPZDSlBEGUX5K7rQnCH8=;
 b=L5CGL4iKNWzNnrCSsOL9jHSrQtL/gnCK4JOlNLSrV3Of1DTGvEAQBD0VgPxw9eYAJ83bigavRHAtgIpgRgJ5p4u4+4yY8ex7gc+iSPSFDgPnqLpC+h1IGKf23O+lOfxiDXte1Ob9e/JSa6sX3N3OTSQ4XnE94t5r7napJBRXS4c=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by SJ2PR04MB8780.namprd04.prod.outlook.com (2603:10b6:a03:537::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Thu, 13 Feb
 2025 13:03:32 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%7]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 13:03:32 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>, hch <hch@lst.de>
CC: Carlos Maiolino <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 39/43] xfs: support write life time based data placement
Thread-Topic: [PATCH 39/43] xfs: support write life time based data placement
Thread-Index: AQHbeGMNUHBiCs4vP0Oy/NKo2p6w/rNC2QIAgADad4CAAP82gIAAi+YA
Date: Thu, 13 Feb 2025 13:03:31 +0000
Message-ID: <25ded64f-281d-4bc6-9984-1b5c14c2a052@wdc.com>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-40-hch@lst.de>
 <20250212002726.GG21808@frogsfrogsfrogs>
 <c909769d-866d-46fe-98fd-951df055772f@wdc.com>
 <20250213044247.GH3028674@frogsfrogsfrogs>
In-Reply-To: <20250213044247.GH3028674@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|SJ2PR04MB8780:EE_
x-ms-office365-filtering-correlation-id: 5e389db6-6a9b-4f46-21bd-08dd4c2ed151
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cTBWVGpOUWdiTGRlYVozVmlSSFA4QVhKOEgyd1dncXM2MTFiRExkNzlqYXhl?=
 =?utf-8?B?aWEzRDlTbXNGelRYTSszMGJ2MHNMQ2liVm9FWVJEN0hlSlNxUXl5OUlxZUNZ?=
 =?utf-8?B?UkFGaXZ4M1gxVmpvMElNYW5XMENzQUFCV2lCeXV6QXhCTXRERExGR2hPMVZR?=
 =?utf-8?B?RkJTbmZVOWwvdERWaGFPNDZOQzhHc1QxNnAwRlNBL09kSXEwNEpaY2FlazF1?=
 =?utf-8?B?cWN2MDNUQWcrbUo2YnVIVHhLN0prZ2dMNGoxZVlqVzY2TXQyV2UzcVFyUWVY?=
 =?utf-8?B?M1FlZEt0ZkMrdU1BeVpmVktqQ29lQ0VheENuYUd3b2w5blZaMndhYmdHaDVF?=
 =?utf-8?B?UTFUQW5Lc3crUGx5dVAwSEQwaEU3OCsyNHR1d1VCYk9odklWdk9HVUU5bWkw?=
 =?utf-8?B?a3FPZkRjOXVGeEFqVWF0U285TjFQeWkzTjA4Z3pNRGdnemRnemRpTWhhTVd3?=
 =?utf-8?B?MW4xVDNhU3FiZ1krM0ZOSVErTlI4L1BlSWt3U00rWDB2TXBJb0ptSlppVVB6?=
 =?utf-8?B?VUVSMVNHQTlTMHkrQ2l0ZG0wNWZkbzZCUStlb084SXh0S05jVlo5Y0M2bEVH?=
 =?utf-8?B?QXlQTHdxMzQ4V2pIREFlNElIZHJrbjJ0dzRreHd1SllyTUlSbHRvM0RxeHhZ?=
 =?utf-8?B?QUlIeUxtVkIxRE04L0NnN045Vlg4Q0QwVGxOdlN0ekVUbEpkeldlb3JWT1l6?=
 =?utf-8?B?dml6d3RuUWt3K05sOVZaTXlONE9FY0QvN2l2Wkl3Z1MyVGt0aWRlaDZ1enY1?=
 =?utf-8?B?SC96UVBOVzJWOXRLak5UV3NJdVZOcjVYQTgraDByVVBZOE95bjhmWmxrSTFG?=
 =?utf-8?B?MmtJaDVyS2cvWUlpakM0LzdSNy8xZDVnNllsMHowSEhRWnB2aitqV0hPTzZS?=
 =?utf-8?B?L3lXVnVrT3Qwdm4rSEpLQUhUbyt6dUpKK2lpTDArcklETjdvUVQyZ2JTL3RO?=
 =?utf-8?B?QjBqVG1kOTJQZm5jY2tCK1ZJbmZ5emZuOEhXM1dOVzVwalJLUkdNSVRHbXVs?=
 =?utf-8?B?V2J2c3dSbytuYkUwcVhnazAvbU1VeFllNU92Q2p5NmdkR2o1YUE5QkptRTlm?=
 =?utf-8?B?L051Z3hmUUdnNVk5cU1qZ3VDYXUwYVV3MEdVK0dsVmhJcVZVVXF1aFBHaTkw?=
 =?utf-8?B?azhORVVrRmJCVDlNaW5HNG1HRFU4MzBIdldzMndacUdwY1NxT1NGSVpMSk5n?=
 =?utf-8?B?blRKU2lFUkllL1lOSzFYVGZxbG94d1lOSXQ3SjhhaGVvWlltSEF2ZlpRQ1hO?=
 =?utf-8?B?RjRkVUtOSWduY3VmSDEzVG9wcTJxdXlVZEdhNE9WeE8wakxmYXFGdlNpemM5?=
 =?utf-8?B?WEFhSGJnbmUxZlB2aFVaRVEvMjQxMStSakxYOUxja0J0djBIMk9aODZEUmtv?=
 =?utf-8?B?VGFRY3c1bVZYMk1FRmN1dGF0R2xTMzhBQ0R5TjY0ZWFtRWlLK1hERlFTdXZB?=
 =?utf-8?B?NmVickpDK1d2OFY4dk1qRUR2bjQ0TTVlcWpTVjRuWndFRThsUVhIWTJjaVJR?=
 =?utf-8?B?OE9OZXpQM09jZEsyMkNCREdWOTJxZ1dTWVVlZ1IwK1VoeVRKeGNIU293SHN2?=
 =?utf-8?B?dzdwQ3IzNVBoY002VUsreFlQZ1hFTStrNERKTk9QMXhyNngyVE1yL2JxbWVV?=
 =?utf-8?B?Q1lCTWFEZUhNQmZ4WUxPVktaSkg1VEE3dURrN2RDdFYvYkhLWHVmT0VoUlVx?=
 =?utf-8?B?Q3ZHQlFQNURlOVJiWnZEeEJuZ2srZjMrRTNmVW9qdnU3WjdFZjBrSTNrSTh6?=
 =?utf-8?B?bTBscmJnOTRxSnVVeEFxOTRiUzI3NlJMOFY1Sm5BUVlkdWcveTBXM3dqVXFi?=
 =?utf-8?B?SFVxeHFvN1RibFhnVE44ZjU4Z3VsWTNjMCtmL05ob2dhVkRNNmQrQUFwajhp?=
 =?utf-8?B?cGtvSXhrdDVocVViR0tjbUFvdHpCTTRpRENPODRUYWNmR2hiKzBheHQ0a3lS?=
 =?utf-8?Q?4CXKjikEhDEjiMUhJ9K5hHf4U6YjUiUj?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bXN0Q3N0T2JDeGFJWTFWY05icnI2ZXI2b2tmSXdXVzRkRmd0Sk9WN1pqcy9J?=
 =?utf-8?B?UTllcDVSV1RUcWZjeVJGeTQ2dEQ2VFk2TnpzM0NBenhmakpodU9jc2lRazFp?=
 =?utf-8?B?KytzWng3cXkzSk5rQkRVMWUwOHVEOVp3UElRUlFNRVowZjh3cFY4ZjhEdTZM?=
 =?utf-8?B?MXdNR2l4WE1xNnVrWVRCYnhQZ1F3d0orM2s5RTB5b2dpdG5lUW1EVEtOSEtZ?=
 =?utf-8?B?dnUzdG5lSVU2ZzlFNzJwN3RFTExZaUF2M0I4MnhPeEljbHhudis4TG5QNmVm?=
 =?utf-8?B?QVBhckFKb2xQZWJtQk1VTGtXekc5U2lOdVV6dkNUMER1amRVMngrUDNaSFR0?=
 =?utf-8?B?eVFqalN5S1ZjRC9YK3FIRGN3REJqL3hLWEgycFBzQU91bVNQK0hGNXdzWS9R?=
 =?utf-8?B?Um54YzFMbTlOSlYyN0oyZGpTRExEYTNEZURodHV4b05wQXNmWU9IWjdWSGNU?=
 =?utf-8?B?b1NBd2RJV0h0NzNDNEdtdUQ0aXRiWGhHajlaWlB4VWNFM1htZFNDYlVNN0xr?=
 =?utf-8?B?eXdFR2RsWE1NZm15Nm1IeGh1UnlsZExPWjdZbjd5U2RqRjhEQi9CbWp0RU1J?=
 =?utf-8?B?RTYwS2xZUzdEeSs4YklPTy9pRWY4ai93QVk3eVlDb0NaSkwyOFlVYjFvQ2U5?=
 =?utf-8?B?MEJJVEQwTTBtMk1vOWxxRURLbDg4d016WFRFdFlmVWtKd01LekJMaTd2U293?=
 =?utf-8?B?R3ZjdzR4dHVEcERYYnRVbDYvLzBCVjhSeDVqWXlRQUVBN1hGa1FpbXN6NDl4?=
 =?utf-8?B?dVNQRjQ0NXNsV3lsbFIzMDBWUWJaQkV5YVdKWE9ubzIzaXhSZmYvWmcvRnFr?=
 =?utf-8?B?Z2gyNmx2MDVUWUxaTUlxOHRoZHU5N2pMNlF6cEFIQjAvMGovZjUzb09jM0Vh?=
 =?utf-8?B?RnNxUy8vN3ZTV1RQUDQvQkZMN01aTU1MR1d1QU1RZGdYbUlDZ1UrMytYTzVk?=
 =?utf-8?B?aW4vZUkyRm14Qko3RTVyQTJzVkJTZHdxWlhHcUl1NlZieWg3TGRVTkZXd3Fq?=
 =?utf-8?B?bUZUMXN2MXJqYlZmOUVKOW5xY09GZGZXNXo0V0dsU1FyWC9HcjhOanExVTdy?=
 =?utf-8?B?QXJRSDJUUXlhZkFJb3prZk5QNWR4M0JQZHNBaHEyRjlvUG1qeUk0dmNUaW9j?=
 =?utf-8?B?WjJ1ZCsvcWlFYlgxUGJiNUlsdEV6R3RyVng3QUhVYXIxSlN1NUVLUkdPT2VS?=
 =?utf-8?B?WVFYeHA0RWhvejl6U24yN3RmKzcxRXJ0SkhJejBweTRRK0wxb256RndJMFdv?=
 =?utf-8?B?VkZ2MGlYTzlPWUkram9zS01aYTBKaDBXWkdFd3FxaE0rNWtDVm8yRTg2WWdq?=
 =?utf-8?B?Slg1ejhtdjBQVFYrRGRheXdDSkFGZGFrT0NJWXVhbFlwNk5LaXQvODVEMnp1?=
 =?utf-8?B?T0ZWWmU2QW9aVVg3NXJzZERWSmFoNlM0YWJKbm9sd01WdGx2UC94Y01TMjZQ?=
 =?utf-8?B?QXNhOWh5Zi96TWNvaXhsZ1NxT09waTJVcE9MRFdIaTZSM2w3bnpqWEdWd1d2?=
 =?utf-8?B?U2pjS3FYZTdpU0Z2cUpWZlc2czVBalI1aHFFZFIxUzNuWmFyRTBBMUZMcDQ0?=
 =?utf-8?B?a2txQWJXbDExZTJkRjBtQnZSbkpnNHZhQ0dKaVM1bFVPbU9vUFJmQzNPZ3ZV?=
 =?utf-8?B?UjlaK25DdHM3YkFaZi95VTRFUWtSRHN5Tlo2dDZta2dKUGN5WHRZYVh2d2hk?=
 =?utf-8?B?UVlOazZkSldaMzhMRENaL0dWNDdPRGI0WnEvL0pRUER6NGU3MDlkbm9xUUQ2?=
 =?utf-8?B?RjMrcU0xdkZnYXgrRzZESU12YzE4ZUd3bG4zZy9zMC9Ib2tpcWI3OW1nTmd4?=
 =?utf-8?B?MTVIMUJtc0p3M1QzcXZFbDNWQUJMK0JpSldBdDFGczlGRmt4OHBOeElqdTMz?=
 =?utf-8?B?QlNOSXdYUEgyK0dFNkszTTNGdTAreGxBZTkxL1Q1YmRXUjYweWNjcEQ5bjVq?=
 =?utf-8?B?Q0l1TWlSQ2hWWkVjdnFnTXdVa0xabHBGYTdCOThHSXVZQ3ZhdUZMYjlCRFAz?=
 =?utf-8?B?NnEycWRlZndaeE1RTzI3ekxpWXc0WU1aUzZDaTg4RlAzNFNsYXhRMmZKYm9H?=
 =?utf-8?B?dU0yVFJVUzh1Rkt6cDM5aEc5cm93ajFlSHkyZW53bDZPVlFmYzQ4dTJFNDhp?=
 =?utf-8?B?RjZsTGFIVG5BbjVUc0tOZndNSVJZMjA2Q3lFU2NBZlgxOEtZM3hpU3pFZ1pi?=
 =?utf-8?B?Z3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73D195B3FBCE534681BF89BCB5678C92@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MFSufHjyRings3b4rafYiU67DrefiaCll2oqen8WyShYPSJci6lnJ267W2QOb4NkogzgkOwaWFMNZr8KRHeLwXeC/thwZwxNy1zFyl+Q/8M8rRUWNYbrKuGoKNCkfefDgqlA9dLEJdq5lN+aOJ6dzh9KeRJDcgjx7L5rqFpF9a/lgFNlJ05TfE+x3JW/fFKOGCqUEVWy5LUY1m3jKKGY3FqIP0sGtKQdUTHWteinrj0lpcgCAF4r+Skc7QjIlLD8ovg6vkjJaT4ZEJR+ZsyOy+xav1qN2zmwSuXlFiD2G+EwZ1Akrxnv3fZX/j6yDGeBbiXT28WwsvYSEw1PiHfcgfVXBznOARRPb5s4BpNBzM79Iyy64tcaMQYtB4blK7fdE9y0AoZTZ8LwU74fwOyTnJGTA+NxnOi/3seST5NxlFJ0mwH368iIMVyI27wq1ovcOxMWefYnyktC9UHe489qEBF8Fol7gecFAJPEr75N1xe3XcbDj5FTzbgvmxSJzg6F6kUz8Ed9RAYVPxZ+8D9vFGYMftYgz/N8NSlAclVZ5inFtnTZy9jBc9IwKnbnt+zzUBnHVbyb1PQekTGV8COxo79bnxDxpSVDZ+BUoc9B6OzRYbAW9xN7N+nQjzj2onNc
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e389db6-6a9b-4f46-21bd-08dd4c2ed151
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2025 13:03:32.0068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FfnEUkx9p3zyyy75A4tECVd2zI11AAL5/qOy8ZA/AGGFSI6VZlhCZevYez3BjvoJ9nGJPyrEGQZTACA6ee5flg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR04MB8780

T24gMTMvMDIvMjAyNSAwNTo0MiwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBPbiBXZWQsIEZl
YiAxMiwgMjAyNSBhdCAwMToyOToyMVBNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4g
T24gMTIvMDIvMjAyNSAwMToyNywgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPj4+IE9uIFRodSwg
RmViIDA2LCAyMDI1IGF0IDA3OjQ0OjU1QU0gKzAxMDAsIENocmlzdG9waCBIZWxsd2lnIHdyb3Rl
Og0KPj4+PiBGcm9tOiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQo+Pj4+
DQo+Pj4+IEFkZCBhIGZpbGUgd3JpdGUgbGlmZSB0aW1lIGRhdGEgcGxhY2VtZW50IGFsbG9jYXRp
b24gc2NoZW1lIHRoYXQgYWltcyB0bw0KPj4+PiBtaW5pbWl6ZSBmcmFnbWVudGF0aW9uIGFuZCB0
aGVyZWJ5IHRvIGRvIHR3byB0aGluZ3M6DQo+Pj4+DQo+Pj4+ICBhKSBzZXBhcmF0ZSBmaWxlIGRh
dGEgdG8gZGlmZmVyZW50IHpvbmVzIHdoZW4gcG9zc2libGUuDQo+Pj4+ICBiKSBjb2xvY2F0ZSBm
aWxlIGRhdGEgb2Ygc2ltaWxhciBsaWZlIHRpbWVzIHdoZW4gZmVhc2libGUuDQo+Pj4+DQo+Pj4+
IFRvIGdldCBiZXN0IHJlc3VsdHMsIGF2ZXJhZ2UgZmlsZSBzaXplcyBzaG91bGQgYWxpZ24gd2l0
aCB0aGUgem9uZQ0KPj4+PiBjYXBhY2l0eSB0aGF0IGlzIHJlcG9ydGVkIHRocm91Z2ggdGhlIFhG
U19JT0NfRlNHRU9NRVRSWSBpb2N0bC4NCj4+Pj4NCj4+Pj4gRm9yIFJvY2tzREIgdXNpbmcgbGV2
ZWxlZCBjb21wYWN0aW9uLCB0aGUgbGlmZXRpbWUgaGludHMgY2FuIGltcHJvdmUNCj4+Pj4gdGhy
b3VnaHB1dCBmb3Igb3ZlcndyaXRlIHdvcmtsb2FkcyBhdCA4MCUgZmlsZSBzeXN0ZW0gdXRpbGl6
YXRpb24gYnkNCj4+Pj4gfjEwJS4NCj4+Pg0KPj4+IFRoZSBjb2RlIGNoYW5nZXMgbG9vayBtb3N0
bHkgb2ssIGJ1dCBob3cgZG9lcyBpdCBkbyBhdCA0MCUgdXRpbGl6YXRpb24/DQo+Pj4gOTklPyAg
RG9lcyBpdCByZWR1Y2UgdGhlIGFtb3VudCBvZiByZWxvY2F0aW9uIHdvcmsgdGhhdCB0aGUgZ2Mg
bXVzdCBkbz8NCj4+DQo+PiBUaGUgaW1wcm92ZW1lbnQgaW4gZGF0YSBwbGFjZW1lbnQgZWZmaWNp
ZW5jeSB3aWxsIGFsd2F5cyBiZSB0aGVyZSwNCj4+IHJlZHVjaW5nIHRoZSBudW1iZXIgb2YgYmxv
Y2tzIHJlcXVpcmluZyByZWxvY2F0aW9uIGJ5IEdDLCBidXQgdGhlIGltcGFjdA0KPj4gb24gcGVy
Zm9ybWFuY2UgdmFyaWVzIGRlcGVuZGluZyBvbiBob3cgZnVsbCB0aGUgZmlsZSBzeXN0ZW0gaXMu
DQo+Pg0KPj4gQXQgNDAlIHV0aWxpemF0aW9uIHRoZXJlIGlzIGFsbW9zdCBubyBnYXJiYWdlIGNv
bGxlY3Rpb24gZ29pbmcgb24sIHNvIHRoZQ0KPj4gaW1wYWN0IG9uIHRocm91Z2hwdXQgaXMgbm90
IHNpZ25pZmljYW50LiBBdCA5OSUgdGhlIGVmZmVjdHMgb2YgYmV0dGVyDQo+PiBkYXRhIHBsYWNl
bWVudCBzaG91bGQgYmUgaGlnaGVyLg0KPiANCj4gPG5vZD4gV291bGQgeW91IG1pbmQgcGFzdGlu
ZyB0aGF0IGludG8gdGhlIGNvbW1pdCBtZXNzYWdlPw0KPiANCg0KVGhhdCBzb3VuZHMgbGlrZSBn
b29kIGlkZWEuIENocmlzdG9waDogY291bGQgeW91IGZvbGQgaW4gdGhlIGFib3ZlIGxpbmVzDQpp
bnRvIHRoZSBjb21taXQgbWVzc2FnZSBmb3IgdGhlIG5leHQgaXRlcmF0aW9uIG9mIHRoZSBzZXJp
ZXM/DQooT3IgZG8geW91IHdhbnQgYW4gdXBkYXRlZCBwYXRjaD8pDQoNCg0KDQo=
