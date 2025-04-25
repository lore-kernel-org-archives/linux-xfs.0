Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99BA231A57;
	Fri, 25 Apr 2025 09:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745571810; cv=fail; b=hXBbpoQjh28DcWMa8dhXdAH7Win7u6IukILjmL+8pnG90FrWW4K01xjSpIilDhzeUi7S1RUJIs/xynMBspI4dqU1tIf4jKdcwds/EQdvkbRKLXsTnCprYh1FswM4/Z9vt6PrTes93byUCxAucYp13fIyo8VqutQ4kq4sHhw+WOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745571810; c=relaxed/simple;
	bh=oUwbIVpvkeAeEgOD7gUZZV5JEzNWOrrCEszI1WhSgyc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gk6xDtUcgkjTCX3ohFCnqmW6jFQCJaM0FjeBw47zWfZC6+MI0/0tk9N6gYtcXCgqFq5vkKRczByQbE5Gc0llXj43S0CgrxsQWgRCUK1BIDimHtpVZTCh4JqCPPPmYdQc5Xbz6CT5yPvYfqcvk60AJ4IC1stV3xm5Eo9P5c304bo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=V2LPFsSE; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BonBwBuJ; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="V2LPFsSE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BonBwBuJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745571808; x=1777107808;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oUwbIVpvkeAeEgOD7gUZZV5JEzNWOrrCEszI1WhSgyc=;
  b=V2LPFsSEX2Hnn6nfY8eDoOB//Al1+eWvOCsbNqJdLPzYu8ltObghBopG
   cyJR6PE2vZT0H5qYMLo/JCbCDHAGVvH13vdlyRY+OjsinKi4JSulSvVOJ
   w3gCugJgIwBPaMNm1jdxoNj6mu1Cywmx7B1TqT/9FANqCOlrbrz5aAOZb
   H0JQ15XwGlt2Njcsd6D5sOT78TZUFbsQE6xwncWzqFGnpKJ9WSTqE4Tn7
   p4R9wqxhK4lLcdaCgUpXrKxl/0qK/WUQQB1lOsU1qw3ulmoyunZdJrsht
   drwmS9qWp0qlXwpzft6TvdDC0CRNnB7J3oiQmYUyOXuabX+MK6IyjLxaM
   Q==;
X-CSE-ConnectionGUID: Y+UzbiX7RmerJe2tuB4TSA==
X-CSE-MsgGUID: phzNUjI6TfKohhJvVWJ02Q==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="77775078"
Received: from mail-westusazlp17012037.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([40.93.1.37])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 17:03:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vz/FSklrYCwmIlWBTAIPaappFZnteTydFZvDr5La+AGhOHdxSjNQFXvtIXgA9s3D40O4WHubRYkSDlLefcrEnvL69bYLKw4c1MJgI6Xnz4Jbx20cl0u3JYlEAftVDyxkNYDuyDY5xKScUNpTvwESs2nRi7GP0FtocCdaLppdU+vEgdajVVijBWMzsj4naHQN0ExE0CVcAbctoDk+hRSgGENAmJH23KFhDUgNjq1X/AcLgBIPmAizxxw//ypPpgyw6IuPGM+h2PYaPHMtJjVT/ee64H6gOXtxZP3jO/1DLikGUYbpJ3iqVzK4A7mCqejs4HJrzJ7WNLD+gXecQzzx0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NzBaImZAwtpitTw5Rzq0lfnTHfI3Mlfay5HFkJx+BUM=;
 b=CK4ZW0GiN+HaEoOstyRXD/kAFs6pvew3/FnqYSD2e0GgxYVm84nQAHZ2GyiabQ71SEk6cT8ZyJ3sfzTeZ/hkqJS3Y2N/X58cPPEqvyT6g2n0QxCLu9TO7XcO1PIN2QDtAP6JWaS6DHzHmyjnDbts7y4e5iAj60V/f2IUlK+9TnoskcPQsY0l8MKkaUD3lbEdeDAKgk/1O//2WaZASST9AqDDcoUhX7IwB20sZ6xJ5sLzeoctJpWgAP1D87VNvv+Atyh4jKW0DSxHorKGQPKtjFQnZIloEyyLXP/3DkJhcpczVgFBvq+n0yjgHWDdfjwutiPud9rzIWkIQlCGlKXgug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzBaImZAwtpitTw5Rzq0lfnTHfI3Mlfay5HFkJx+BUM=;
 b=BonBwBuJ3OpHg34TLF+Z7JIR5ZHgMdn7LAinN8T6cm733tVsvjKKpPSj5sCJZCWySCnjVKRC+mI/SDvVNeWU6+NYbzC+wHJByBcSdrync5hZEp/WJHC7xfYmJlm4SkIay4sq0Gp4/WN+ng/LSNE+ClS9hKwGtThN9cYNpc6UeXw=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH0PR04MB8131.namprd04.prod.outlook.com (2603:10b6:610:fc::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.26; Fri, 25 Apr
 2025 09:03:23 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 09:03:23 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "fstests@vger.kernel.org" <fstests@vger.kernel.org>
CC: "zlang@kernel.org" <zlang@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"djwong@kernel.org" <djwong@kernel.org>, "david@fromorbit.com"
	<david@fromorbit.com>, hch <hch@lst.de>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [PATCH 2/2] xfs: add mount test for read only log devices
Thread-Topic: [PATCH 2/2] xfs: add mount test for read only log devices
Thread-Index: AQHbtcDlALwMj9CgvEO6QaqlIzHfhg==
Date: Fri, 25 Apr 2025 09:03:23 +0000
Message-ID: <20250425090259.10154-3-hans.holmberg@wdc.com>
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
x-ms-office365-filtering-correlation-id: 51d01354-69d3-48b5-68d0-08dd83d8088e
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?DllcbblUHP9ci/xCZJ39qKbD80WO6wWqV0/w92jOLk/CrV+aXMmt7+TAnm?=
 =?iso-8859-1?Q?e3UMBj62zZ4qfkSgOxcqu3oQtEofuoRmaSyU1Fl2XNCn6QkuuFuGLVyGm4?=
 =?iso-8859-1?Q?WFOu/mya98D5kJ2Rns/5h7jMQCaUCgy68e92WwgQY5KOkEXgi9OvRJpkg2?=
 =?iso-8859-1?Q?od2sBPnTqGiOXkMFfW0NsOJzFMltNG6yMd8ddvYCATJzOZgVppUDBBxBX8?=
 =?iso-8859-1?Q?evKdyq14IfLUHogmDCBt2nYaEBWATvSiP748VWl7abNiYvH5MabnfmJzyJ?=
 =?iso-8859-1?Q?R/vcOxtWMfIEUYjcnhhDlRP4EBgx7k0Dt69b2XZEuKEn2jlYTZzAVUNELU?=
 =?iso-8859-1?Q?x+g0pynk4DB+KqGIoh7/FjJfVErPwlEssQ5UbU13uD9/kPbmr+HbC1qgcs?=
 =?iso-8859-1?Q?6xPcZBcKljZxHDxd9lIC2OIPYrSvT7awyHER3qpiHGhk6HAuvknLEQ81Lf?=
 =?iso-8859-1?Q?Bt4svvhoJ4QD7atRmpxj5EC1pWSNEswaTzmUlOOEOIHwayPVwxgDFH/nzJ?=
 =?iso-8859-1?Q?a92anvppfW14/V0w7LI56QI14yXkys89Guw5X8dkJiHvrxnSXqnisOxsGp?=
 =?iso-8859-1?Q?0oNi+o57BEa93iKNTvF6YQXvHMluciUTC49b3L6WrNRN2ikUs2s98iA68N?=
 =?iso-8859-1?Q?pSTc5Co2EiRcO4Ulr/tphzzTqDfpVKQT/q27SEiuWfGpvsg1XJZgZvgkFn?=
 =?iso-8859-1?Q?oPgc0pFeQxFolWqL+zzXvoMn1j4uCYEB5XJZCy5c8dnpBudomOajt6e8zW?=
 =?iso-8859-1?Q?i5fJuFhnpbgzGcw7DtWt1TULtjZ8sWi5oilgb73ZjJTyxjZYBjJLIbjV+W?=
 =?iso-8859-1?Q?0Nsrh6IF14/UT615uXMBK90LGYKJyDHL8EMe+ozSk0UV9ofjtBewzbprGA?=
 =?iso-8859-1?Q?gDeSunilBpva+ot1Xy8yDYwSmzuUe15rnRmGi2a8WcxIQXA8g7CgZQEgYK?=
 =?iso-8859-1?Q?sKQvBgZTnpi6R5+sAIoHw1qGN98hLp8AM6RRzng03Ea3kFYFMtefV4WY/o?=
 =?iso-8859-1?Q?C6S/S05nvgV9k8i8q28JuZgODMm59wz8VtPYQ2RTMJ+2xjkkj4uhW98m0D?=
 =?iso-8859-1?Q?pMIyTn8WjbJigpr+N26cfvDCyJ5BCeNjp3XFAAmMeJKGsIXLFL30Jpg0JZ?=
 =?iso-8859-1?Q?4qzyUltVnRTerDn6p54qA7gQHUG8okAOmkSEYpHD9KiouFozipEI86TYRZ?=
 =?iso-8859-1?Q?wgsrQMvVdUH0XZFVklHlWW9ytLYn4OPjhvZuURUKK9jvMiqYFc65rxgMOA?=
 =?iso-8859-1?Q?s4m9KkukmBBMjiBs6XcDAX5rzdRSGHI0pTi8DNAq4Y17s+w0iwdjQoCGIi?=
 =?iso-8859-1?Q?LRnCc/ObNhsk9xR3U6BF+o2jB+QOsAoyv1hGZAsN5qwng4JJAiiAYkAkCQ?=
 =?iso-8859-1?Q?DgCtpqGcmmK1mifkyEeP7jGWqMFmTa3tlJ0Kp2J6Q1RtIUqlUEt/e5pzPD?=
 =?iso-8859-1?Q?hGNCXwHhsIGTGa6uGl4aXFnERPzWRoX+Vb1jlSlVc8leowbQ83a77tylBx?=
 =?iso-8859-1?Q?cOjFRU9FrfE7dbuvboNCpRgy8ml85MGcXudkJNzIq3xKj4sRGzY9yCTsaf?=
 =?iso-8859-1?Q?+0edMwU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?H64bbekZMIM8QGjY8U1M+zOhcWNHXvUy0hY72JDEKF7+9QSR+aHZr6AX2E?=
 =?iso-8859-1?Q?a+cey4uJIrITUAGmydFdSEwYU4VyUAGgdwz4gh6FLJCX+DWTA4Ko8M3HJr?=
 =?iso-8859-1?Q?nGnmD0plapuJnsah8Rmp2hUibYGolZHMXWpJ3U1+hhZHmVPhkuiUbFGWaV?=
 =?iso-8859-1?Q?zZ5xKmlEghwAVBaN6rkEl2fjW7xDy76n0c0GtIirP7Oj9vu2IIQyF+NvoK?=
 =?iso-8859-1?Q?AKRvUaKdp2v7J7Sa69req34o+waOPEpEvvP5FupgdqUz/I9Ho1UJhw/21B?=
 =?iso-8859-1?Q?BnnbkByrftqkCn/Ub/pao72A3DB6ucVqGGfzTtMWLcefcJogRwsJ792eTa?=
 =?iso-8859-1?Q?Ocifj1w7HF1LyzKdE1xU+q6v8JW2IVHEwu8VPJXHhBBmwnHwNNHWD9w1Rd?=
 =?iso-8859-1?Q?FDlwiPdYcCYa5rMKAoNQX+VN+0+ycmfigj2dJMBK+ytX5ADcvvzVJ1AC6r?=
 =?iso-8859-1?Q?3Sijudun2KDW2HNblaDOAsVDXy5YuFETIyXQ+QwqUeEeSCs64Rys3Z/37B?=
 =?iso-8859-1?Q?rvZ2YIdeP5i9/FO4lrRT4Ymp81bR5u1ZEIMmncKt6/bj4UpO6vRSbHrCVe?=
 =?iso-8859-1?Q?zT1698d1+vrjZTzbRHTid9cX5teO9+d3J3iPkB1xsfvCkaYrPgo5QJGcli?=
 =?iso-8859-1?Q?D430Sj2BX1pCWPp8QuGc9GXy7luigSBNOEYxhtXn/LRtSqA6KkhCpygFC/?=
 =?iso-8859-1?Q?da5yT+/ejmPPWcdclVsCCsKZoW4nWvfjDpkyZD79l9DnzioIDZFubKs9WY?=
 =?iso-8859-1?Q?EuLH48QWdVmxaDc32eLERyfIlb7MuzYMoFgcHBnwv3AGKXJagIc9Wf0gmu?=
 =?iso-8859-1?Q?qp0hAZIA7IDc9vloYb2wlvOvJdfhiKjcuWYihTarBp99jwQreslO/G/xz0?=
 =?iso-8859-1?Q?krrLyRPe5rOgyZiEQHMJ9P2shxVELJoyJLcizJ9NL4bxel5PQjAZ2X8m6j?=
 =?iso-8859-1?Q?DHBn6oASf/m4Qm3/NgJC9VXCOdcAfa+qlD7N7FWvyYKm1ON0+9d3aitZgS?=
 =?iso-8859-1?Q?TyLNbGyi60cZs7uCevp0pIs08TqNnfst7vAcgT139eTFDDX6GtM/yQozy6?=
 =?iso-8859-1?Q?5hpUg+CLE6KjK2bH/Oj3sQoePnlkioJ6X19Ry5AeCMDLvXJFUc+s/PD1tv?=
 =?iso-8859-1?Q?HTFrk+fU2HVQbD3rEsVUjwnttctOeLNurYgeIsASwINtfPocKcE0FRcQmz?=
 =?iso-8859-1?Q?IHG0/u6sUqlCI8GpL2315k2f8RmQPmC4Y6adGwxGIfRk0JL8dYOOKOsdFf?=
 =?iso-8859-1?Q?xH+qrU4DpC32p1qUlaiCi6/2M7osMXrbVwO5QNbsKwvfmgc0NWk5DarvAz?=
 =?iso-8859-1?Q?H88AIfVS7sOsHOYxabqLGyufY+g47Ue9m5a2Z2arpXDkctoxceGlJZVox1?=
 =?iso-8859-1?Q?MHk5MCZcDnOXuYRYUNQ3WOTaE/5utuHPQ2DGVt1SE57MO/UdEdtd9DQNNp?=
 =?iso-8859-1?Q?dHMZfhiQJNdF9TkxoJ+LubBmJTnSlrMm6W4we45h59keq6ibb2fBSa3bWD?=
 =?iso-8859-1?Q?w0R2DZevI8Q2kb8kbzqZ67De+ed+v4+hS/qeZW/cu8R1C9m4hOQX8wKQff?=
 =?iso-8859-1?Q?CUu93sULsIml0OrGvdBrx53nSNRUl7r2qrgUdMjZx/NIt7FIzRP/fJYQRs?=
 =?iso-8859-1?Q?5ebnGNccLdh/ObRl9yDbEg+uo0KDhADjg/xwSXJYf3RFPuyJt5bWk4bw?=
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
	QkdALPORXiwgey9ehteRAzJpc5F/GWBVOz1+/tghCOg8xSI3ymisq5rTv8C46QyQJN1zP9IwAYLoc5l0zqSP5sBcYT49Fw4JpwEEk5AFDntsUPYx8KQoa8vLo2qJplfNHJnaCQ9umqEsNmo3HSkr4MIgN9MWtIyARYffL9sMkolaxrlsMu0nEUlbNogJbjuR19Tq4W+Hy6P8DAJDg/VhvdESati9vOXxqC1JS/KD5MVJWBS//53nVS4Haxm89Vp4uKrLI7Unv3SkkqmBS+AyFY6MGKz3EtHVqpkDf/0BRCo1rppMHvY5CN4BJuh6DS2dz+Tf+JgyetHo8KYqpDOYN1PguAB+7xXDrGc1/7bw9Se4rN/7BOQ9xfK2+mLvr+GPgwrZLxekQxoNlN3TqLUk61P4SRpvOk7axBlMDLJbxaNP0ur6P2QeRl6KqEtcQgHqdVWL9pmlL2EfRAOvqYFpHm/3o+eVFUR6Rhd6HAoaCCTWIqLsWL8CxY+4/xbWjwvhKt+GjXdS9OVZa3/BtiLj922nvLHvB82OaT28+xKON21ybUH0P685zn0HXxIwU5tcVSXi2xsQ8okFnEyXCEpihE3qWBo9PlPeAXbvbIsG+F4uUFq6t74yvrRSQ6nKGyUh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d01354-69d3-48b5-68d0-08dd83d8088e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2025 09:03:23.3493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HQIPBhVhSRF9NMfYWFfrh8WJndIhh7UcEwFn2WsueI4gCetD1GIKPbhLeCC1zbCHqfn1MK3gnenropb2DwhwMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8131

Make sure that we can mount log devices read-only if them themselves
are marked as read-only.

Also make sure that rw re-mounts are not allowed if the device is
marked as read-only.

Based on generic/050.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 tests/xfs/838     | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/838.out | 10 +++++++++
 2 files changed, 65 insertions(+)
 create mode 100755 tests/xfs/838
 create mode 100644 tests/xfs/838.out

diff --git a/tests/xfs/838 b/tests/xfs/838
new file mode 100755
index 000000000000..93a39a7ec8e9
--- /dev/null
+++ b/tests/xfs/838
@@ -0,0 +1,55 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2009 Christoph Hellwig.
+# Copyright (c) 2025 Western Digital Corporation.
+#
+# FS QA Test No. 838
+#
+# Check out various mount/remount/unmount scenarious on a read-only logdev
+# Based on generic/050
+#
+. ./common/preamble
+_begin_fstest mount auto quick
+
+_cleanup_setrw()
+{
+	cd /
+	blockdev --setrw $SCRATCH_LOGDEV
+}
+
+# Import common functions.
+. ./common/filter
+
+_require_logdev
+_require_local_device $SCRATCH_LOGDEV
+_register_cleanup "_cleanup_setrw"
+
+_scratch_mkfs >/dev/null 2>&1
+
+#
+# Mark the log device read-only
+#
+echo "setting device read-only"
+blockdev --setro $SCRATCH_LOGDEV
+
+#
+# Mount and make sure it can't be written to.
+#
+echo "mounting read-only log block device:"
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
diff --git a/tests/xfs/838.out b/tests/xfs/838.out
new file mode 100644
index 000000000000..673b48f42a4e
--- /dev/null
+++ b/tests/xfs/838.out
@@ -0,0 +1,10 @@
+QA output created by 838
+setting device read-only
+mounting read-only log block device:
+mount: device write-protected, mounting read-only
+writing to file on read-only filesystem:
+dd: failed to open 'SCRATCH_MNT/foo': Read-only file system
+remounting read-write:
+mount: cannot remount device read-write, is write-protected
+unmounting read-only filesystem
+*** done
--=20
2.34.1
