Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DABC327BFB
	for <linux-xfs@vger.kernel.org>; Mon,  9 Feb 2026 07:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770623681; cv=fail; b=RmhQFnVtPdQ3YFGWvFz7VBF/W/rCo12l573LZndefbyGNd/NdSigw2of3ITC1F5+SUDEHvWdXFyo6pyy76CEoYvPui09yPWCunPOI5DM2TnVs7S0CGaCQR1a0pa9hbaZq5P+Rkb1gnGoTWN3LEPVJQcJGWknwrsXdIDz6Zp8pBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770623681; c=relaxed/simple;
	bh=RiP3rb3y+ZKQ79YoY26vXaPldP0mgYITMUw7ymvlzIw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VtR7GzpSq/1JUvonkaLgYQpcS8l2tgIi5DVVK83+s+/vP7qQiKiRnHLgasyQgi6Z+i7zGLTVOeXFtUOA0LDkGeS7iZmoH8ihlcGabhIsfjs1mGo8mfwnHASWEDd6B5pialyTe4Ts/lKcVMUj2+jrFfWUxqKRbJUdX0UEJHBczhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WHDB9guE; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Jl510gli; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WHDB9guE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Jl510gli"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770623681; x=1802159681;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RiP3rb3y+ZKQ79YoY26vXaPldP0mgYITMUw7ymvlzIw=;
  b=WHDB9guEFCHmdrDCTCv8/5zZE/dOnuWpmlW4JvwLWSEobG29YdhaU+Yg
   xjX3zyDmLOnpYS6Sw8FgRtBXT6nsLBx9YhM3aNuNTIz6oDs2SmczpOmdz
   PWSgmDrSjcjeaBxDfcXRWmkH5RYXGLyE3z6SW9hhJ+VAut0Eg/nwx5gte
   7jzFlybMICunP4T7ZInLsO+2oPoFaN3EvLQ77esdxjfhGxw4pJ0u2Zdx5
   7VUQvoiYxHFEmIy3k+YGQpqT6n5LC3AcjRiw8LzQQDcoEeBTzWC63WhaE
   tQTv2Shdo+8ldOihvQ+LM4u7V9fg6nw4+EK5XT4Bw0YrhjpJJLECgHs58
   w==;
X-CSE-ConnectionGUID: VNTz2lRaSnqeS6gZiU5xSA==
X-CSE-MsgGUID: tjbYch24R46WSphcnnNQWw==
X-IronPort-AV: E=Sophos;i="6.21,281,1763395200"; 
   d="scan'208";a="140042710"
Received: from mail-northcentralusazon11010059.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Feb 2026 15:54:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bGuByFS8c3CRx3Pw1OPU1Gcw5Eg0p2H5K4AHkmxzKWqK+X81JWQPPWlIwJqhC07hSSNLs0sKKprP3isbnAETMRUSPUZKpvT31X/tmcZ2OVvb5BEi4TEpXcPRKSciczvZZkUALUNmhl0z2DNZO/KIRYWZmfG+HjLK7TZxzSO8TZAJi0oSqhbsyaXkpTYfmXNwsSvdOVWUNt2wA5in2hUMtiCuivxkjLTtVmyzi8U4v+0iRsyeGyKRsEQM0R5RZuRT55foJgBlgul/J7EIp58mAKqv5FPSZB/Nn3supdpx121xVWsZQlZsdLO+ZKWrkkQ7tP9zbhs6IAqMDPj0I2qN+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UCl/9F5i2HcW7k5hDn0XO9/yR4PsqUBGgi26khHe9g=;
 b=xhuOV+U5AT9AGRxakQ/TzC6JBpKMtDfRevmclXKQCuPrXn8MCjUaHIzeVWqH/lMZi4AnlhJ74dqidt8O7Q7d895ZO9ThcYIdSO+wd8o6sK95RyxeBAAtITPG5MZji4Px+awkL8Y1Ys7/QSygASp1OeLTfbayzY02kXJpEjz+oChSDufnZcQ/PX6Wrh6URUv+BdwmIes8WBmqcTKxceuX0WYtnGmtYp+D3sZpUzbd/JLIyuT3WRuNSVaIRy4ivYX5qlGPfDTlTmIzT8lRCbHH7T/rv7XgLUOjJGbYHB7khm7IuTCqjneCWNmaMdOyeK2ZyIDZVCdbDmHi4RLpmpJ4UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UCl/9F5i2HcW7k5hDn0XO9/yR4PsqUBGgi26khHe9g=;
 b=Jl510glio5TI5qtomRFf/Z1bj0Z3bhY1BWGKVvZJACTXWT4xs8wYuNesSejtHMzNQxo+0oTDf23t/SVmg6TZHM+50eD5xP6tVeUV8mFcgjhzHNuBGcwCc8i6Ye4qI8B8/FIl/WzQzF75lVWbplnBZS2EL+UguvNZSeyYVEZf+qE=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by LV3PR04MB9260.namprd04.prod.outlook.com (2603:10b6:408:274::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Mon, 9 Feb
 2026 07:54:38 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.9611.004; Mon, 9 Feb 2026
 07:54:38 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: hch <hch@lst.de>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [bug report] xfs/802 failure due to mssing fstype report by lsblk
Thread-Topic: [bug report] xfs/802 failure due to mssing fstype report by
 lsblk
Thread-Index: AQHcl0QyMGi0b3KRKkOnzTIETMr5/bV18CqAgAO+3ICAADcfAIAABeSAgAAYG4A=
Date: Mon, 9 Feb 2026 07:54:38 +0000
Message-ID: <aYmRhwnL286jv550@shinmob>
References: <aYWobEmDn0jSPzqo@shinmob> <20260206173805.GY7712@frogsfrogsfrogs>
 <aYlHZ4bBQI3Vpb3N@shinmob> <20260209060716.GL1535390@frogsfrogsfrogs>
 <20260209062821.GA9021@lst.de>
In-Reply-To: <20260209062821.GA9021@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|LV3PR04MB9260:EE_
x-ms-office365-filtering-correlation-id: eb05b0f0-44e1-4186-94da-08de67b0797b
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?sQsz9MNzQbI39ZHBp3P3VZaV+P9fQJqERK6oy+w1wbJFSYKY87SM1sWTPjm+?=
 =?us-ascii?Q?rMLPQhzHeNfnqOgGtl7jpUenXpq3LQp1xQEIrHgK6Nh9uA4Rbjdd+jpZ9+2f?=
 =?us-ascii?Q?eG8H0MzBqcT5UlIzU851bHwG88wONHKoP4FzYcoA57dzZq/9TL8B2r4+K/MC?=
 =?us-ascii?Q?j0FJLG6TfYB59CFAXo0SPyPwvk/LUhsovIyXgwNFh/ma5zoSNE8vZBDi7Zwu?=
 =?us-ascii?Q?1RpenxPxNFZr9FN4iBqfyRgXaI7NT6vpLIGV/xvybzas4fY6wA8VHA/zSmaP?=
 =?us-ascii?Q?CbOeczXy67B3bsFC59mJgYopE3kKYWqnwrykORPkt1Ta/ztxiOcMLiehyx8o?=
 =?us-ascii?Q?fwX58N1H1O4ZXXLFhhkTRHcwWn2t9k3Ej3CQ/4HgQgciVYx8S7FbABjfJ2Fq?=
 =?us-ascii?Q?0k34xs4kThmaEFig/GEmpK8iaMFgdRefqpB2up9Ym0/nrmpkFh0KHV2BvTWg?=
 =?us-ascii?Q?mmqq+yOZ5EwC4o+GKDD2qV0AM+hzq1yQBE9cnpvp7gmqEuDxytwj6i9wMDzb?=
 =?us-ascii?Q?unWo/Tv5mDXZ2cifXmXNqvZEtly+nNjIq7Nvgv8rd5dObnKOMe6eakwJTUL8?=
 =?us-ascii?Q?kwuaw+mb+CPmlAIrEFHjM5JB1MbniZzujV8jQmE70JkSKHuyqzARw3OQe5b+?=
 =?us-ascii?Q?hWudUyVaNFNUlkPMyEY0XZZ4qVt7CXG1oMIFbLa98jxGEpQPEfPvi8xwS2Xs?=
 =?us-ascii?Q?U1jD3Kle2/Kuuvyrw7K6znQRN6erOn4e8MVim3Bg7NUb057IpZWR7izI5uyD?=
 =?us-ascii?Q?as/4Z5cSHZH6MCz/Luv9qsE64qTNOOV1QSLFzU7yZfGVAmL8zhYuuJzzJnVx?=
 =?us-ascii?Q?WfbtPXfbDmg0kUsa26jZzYbUjfSvH9wEfXTRp79eus6aH62C2vP8H4fZSVIa?=
 =?us-ascii?Q?xNmihFu3jOnY6saqRrdDPdOYIh/j4k0FJ1eVn9EtiPq8kO+EyY6Zwd+FgFuV?=
 =?us-ascii?Q?cffSGJPEZtkSdY5Kr9DnzxEOh53bOi0JZhQMPycJUtaS6NHxxAY0DnjquibS?=
 =?us-ascii?Q?A8TJKSpHn6XvSFLJD+ICxq1lGPZncxcm2kt7xuXqhwOZhsy4eFPle4VaZ8Nv?=
 =?us-ascii?Q?mmuAzs3OabiO6UCaTyyd1XWXX8klIyef4n0igTuUrBhL0FiDwmzjgdpqOs93?=
 =?us-ascii?Q?TeAEYKDcZqazg7Xpa1qSgb8JH9rlg7UHh0V5pZT8Dtg2OdTeCFASqqWfEDsR?=
 =?us-ascii?Q?FNkvvqxxVAEZvJN+OedtB1rJgP4BOOCKmj0fhsKl/CaSNE7UdGglOG5PG83T?=
 =?us-ascii?Q?p3wOJwOT3cfaYka+4kP77m9tWnc/SxQeWLIZGQPzTWBaHj2r9Q3sc2tfi4st?=
 =?us-ascii?Q?h07wFliAlYtl+nJPb5JqXE+XgjGLO/3MVtHov2R7tLnuP940kw4K7Pr8HvOo?=
 =?us-ascii?Q?fvSbJT3nzJ9Z6vorVJIX2Rk0YlB0KuT6g+W2zJom9k69oVQSXp56j+sOCsrk?=
 =?us-ascii?Q?vGfpFBfiUnISmj4I8qaFm+6oKMh9l2x+aRLOh6xkXRYAyCWDWf1lQQnLoe7C?=
 =?us-ascii?Q?p3PWhP/quP3sItqO6bK97eo78uR3xDDHNoO4lCqJ1+9Hs0QMwWfdHR68GNkw?=
 =?us-ascii?Q?bQbqf2J4WJlk7DZS8RyXT+o5pOONoVWji7hexRsknI9MO5Xs6/I3UE3c1SAu?=
 =?us-ascii?Q?Z5rvV4SZR9SA9N60XkE0bTE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yb+5n7YB9BiSGCWb21a0UVO1P4HE54/+HAm7h7f3yGOwLttE6OsIaCxCo11D?=
 =?us-ascii?Q?1DGFzu5WxP1UbH11p8X93gbmpodw00VHSvAF4K9hfUcoQ2r5WmceUu5RDnYg?=
 =?us-ascii?Q?QMvgxR7P+93fcZ8F+V2MqQnKKBNkwHnSSaXXCTSGpFP1lkQaV7wkJr/nJIq9?=
 =?us-ascii?Q?DoRkLJJVwsitzUprolih4FZlZATZevU4DvE3oNP0M+AKWbpOG0LXQGBHOoAZ?=
 =?us-ascii?Q?nE4Thn7md6Tqti7t0sS83d7yjcFVV2lNwRtXZJuu3guctOjGKc6Vo7HZ7S0U?=
 =?us-ascii?Q?gC+6+jJQmgFHu1py3WoeziMtJLZ38Q8tPMHr/xxtcl2hLLmpbkeLwCWOqzpo?=
 =?us-ascii?Q?NkorcxKfVl4ppXDGjgRXv1mb9gXCk/Tm7FaKgcgnNWaElJEZTYu3L0du5i7x?=
 =?us-ascii?Q?tdQFam3/8Q5EFDi5DGfSNO+q6XVbf17Zhz/AmOXu5NQgypMx5ZHqWkxT95LJ?=
 =?us-ascii?Q?Ol+7MBwFu1yA9NRfw4zYBI4Z8vyfVsqgqREkRY14UXyuxM8KSjjJ7BYhR8mU?=
 =?us-ascii?Q?fymcRWncoc7Rmyng7AtHR+QO4tHE8XxMnTZ0T75xbZiGhCSNT4d7GsTf7Rcq?=
 =?us-ascii?Q?Oo+lyPEchkXdgYS5Q3vY1vframQp10E7aqIHOk/MJQ2QOe81I000ozu7y9cu?=
 =?us-ascii?Q?Qgd8V3u0n+IZ91fYrvF8W1T+Jm/KPvYVEKEzM289dG9V+ulsNZkkfpjKLjCL?=
 =?us-ascii?Q?0F6H0CkoYvQLBNg9XvoMpo9so/RLdBY08HwjsvTapHayUA7oIfaTR/hNpVhK?=
 =?us-ascii?Q?QLwYhq+nMYRn1IOt/aJV9PI7eRPf5QaVlBXL4W1zNt8ZXznYtzOV5zV/9pt5?=
 =?us-ascii?Q?rtrS+b+VKnt6buhWeCpLH/g9P+oWENQPCP9SJsXxsY5K8DmpHNDAejseQvc8?=
 =?us-ascii?Q?g73cJlv7VSMka/aUGTiuH1ywhPvq14DABa0uiRJVuMmg9Mbzb7NL+1fWzC0m?=
 =?us-ascii?Q?jviy2XlQhEhrjzKQ0lYSJQt6vIjHeVpiNEy8xOeLN9sMOb3N/3S4lj3QhjkW?=
 =?us-ascii?Q?pq6Z+Cmny/l6xJhJ7qi13LXau9UtZ13X/jUs4HsG27TPqUzhxjIjyabbKp8o?=
 =?us-ascii?Q?72c7IXTLuNvuRD3bKoMSbjZkT9bKrOL+EgLT5XPtMK0eFEwvJUvTRWR4pw8n?=
 =?us-ascii?Q?pl7tDPQbfC8liRfWlKDTOfQiDoNiQoGRbpZG/CybeZI05iM9uw/i008BQ8U3?=
 =?us-ascii?Q?lyNAYuM2+zHvevLNngxSx4MGjz38IzedycvS7cpD8ABSt8igHbvRV72GAWW2?=
 =?us-ascii?Q?BJcqfQWnVuuEwCsVYhziJeixtFjFg64rh3NVhBjvHYguuOd8tU9TjGqNRNoU?=
 =?us-ascii?Q?YfaCM191Cq5us3LKQw/JqhjqH0QAe8pY8OsqrBUATG0Rta0om+tqlrIYagy/?=
 =?us-ascii?Q?0IIFFDY8XmgomAze13tcGWKxeVmL/zWt2EQEJatY6KOkqvNvDtxmdDKJkkRi?=
 =?us-ascii?Q?WHvhki4bMGPRtr2LTgXemhlRbEFasR6iHphsLBndP3HncxVswLoCi8VV3F8C?=
 =?us-ascii?Q?1l+w3fWtq7aBg4p+Y+32Bn0iGTt2X0b5Jm3XlXGXbtqEbH0VGc0J06XnB+Ix?=
 =?us-ascii?Q?koITocE4d5yMhKsWYbxrnyUd2nByp3TDHailIL1hugZZptoLmpD8vXHNZ2Wv?=
 =?us-ascii?Q?KAxUVp/aZVSTKS/5DCXYSz4VaiRBWbT59xwy2/HKbUfaEb/xRy1MamB/AGGw?=
 =?us-ascii?Q?UqrjFL7Dcgmpb3GnWaQ+iJxoAf0WH3SNOITZZzOhtmbK3KtfB0FcIwcgG67k?=
 =?us-ascii?Q?DTHzC1Ti5g8PZvN5hIj/0I7zsV8c2D4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2D24FEB716DDA8448F620059DA69A203@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GnPSQI9ONjyg6DwXyaDPRmkWAY1URAPQUvvC4RGjU+Phv+YaRyAndVbGWkR18jmL+b6P4i4SgAqvJ8Ji+1bENkaqw2cjlkQsZ/ytB3c7/POLTuMJ+EFGVKyiVf/9yEf0Jgs9Q2VGnCelWS5TWz6kQNkp9UJ0UyJXPwF4js4bfd/SePW8IFsr7Chr3YkHiJglAp0PqT949v7kfk1uMO6lFx+om+/kePtK3UHic8fypD1bn0t3bGaXgcrNZABap8YYgmIOVeMWUG4QHfgpeN/7dmj9RZKD10vWHqOZaTOadGqag0WiDuUcXU7WWoFTRJlkFg9k9MfG6uM88EJITQUqbWySgl0oIJ4Gh9AwV8lw+Cr8bv61KSo1biGPoU7gWVKHFUHGmbeZZ1kRwM5KnciSl6t/Kvmu24p9nMjZ8BIbCtzPQ/58+FpcR8l8Y7Uqfq5Bgvt+6QdV/wS2uJ86Srk+mgf51lX3UN9RgXKhukN3hc198dA7CW4IQWQxzmG9ciuTqNAGcV6rIV5W/5eniT4j8dv7LRAuO8poiYNX7XEg9vGNtBrycPRA4+kQBZOQyEttzkl8PvDbieA3ipKiIgStm7me2a2OZYFnT6QC+bwQg1FJ/eim94xL3u9JhLl5xg4U
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb05b0f0-44e1-4186-94da-08de67b0797b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2026 07:54:38.2636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sh54SpN8GJPM85yEl7gDZpFs6P+kAN6UIUn70KKCGqMB8fa68B47j9QKWfNwxR6aQBWat5cfr1YckG1geSrHqWhbwP1JmCSoSdUp9Y5vXS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9260

On Feb 09, 2026 / 07:28, hch wrote:
> On Sun, Feb 08, 2026 at 10:07:16PM -0800, Darrick J. Wong wrote:
> > Waitaminute, how can you even format xfs on nullblk to run fstests?
> > Isn't that the bdev that silently discards everything written to it, an=
d
> > returns zero on reads??
>=20
> nullblk can be used with or without a backing store.  In the former
> case it will not always return zeroes on reads obviously.

Yes, null_blk has the "memory_backed" parameter. When 1 is set to this, dat=
a
written to the null_blk device is kept and read back. I create two 8GiB nul=
l_blk
devices enabling this memory_backed option, and use them as TEST_DEV and
SCRATCH_DEV for the regular xfs test runs.=
