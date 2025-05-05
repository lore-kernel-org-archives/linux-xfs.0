Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9DCF4F1;
	Mon,  5 May 2025 09:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746438721; cv=fail; b=jMtTKYpdwasieDyZwge/rFgEgKH2FlwpburphpqOOyuytrYCrZ4dfZTJo7WcmToyh0812vHOpTyLbIx7D1ZNivVkKAKSnSS2n7ZsheGAjOjYoYcFSamdscyPE/yQAMwtijsdxjVYoeCdz/qK3Na5jWfkBurG3er8mwwxXSn+7KY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746438721; c=relaxed/simple;
	bh=1jtrQV4WkA3BEwu2Lp9tWUqMZhRUPe5GkUhwfykwehY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f8RQx02eDnWHY/Qoz28NIITZa/cmR7LEO08ah51Ov55gJ9KXvRircelq/6l5RxV455RV9ACqhG5cG6KzTP55T4z0hepuqhoUUpGnN7jwuTz7sEHuUuup6hSIYaV/gA3VTvo52pUMvzbDlEI9Kpsd34GFZfbg3YlPCpfwnpRUq3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VqX5I/do; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=N2uXaSQn; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VqX5I/do";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="N2uXaSQn"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746438719; x=1777974719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1jtrQV4WkA3BEwu2Lp9tWUqMZhRUPe5GkUhwfykwehY=;
  b=VqX5I/doBqT6UqE27TYS/fvjbPkn8qmo7aL+CIlmefUtdCt3Mmw5127J
   MBvPcTRPCjiYUJTMeDue4ht9IeDgd+XgCWmRy0V81Q0ZKM2R/zFzONveN
   eqLwNmuc0dd6hnJvAVAvzdcexXZu1FnQkky/owAqQo2cUbAy7Gyz8dctb
   MTxjJ32z5CEueT2I5W8nyAgG/DPwJTzA7PapYxRLXxrrppNT9LKh4HrHR
   xXrGc8et9tfoSBmYXX2hi3qCDq6CoOw5FJqPebxFf7OU46/1EibILJq7A
   8RB238EJ7YNPruITXJLLr9hPUZauNR6gob2QHVy+Dv2ykQ6KqDMj+y/Mf
   g==;
X-CSE-ConnectionGUID: 1RpL+I5mRmeXxDC2gEegNg==
X-CSE-MsgGUID: AyLj0GiiSRq+0Fim4M8Tdg==
X-IronPort-AV: E=Sophos;i="6.15,262,1739808000"; 
   d="scan'208";a="78671136"
Received: from mail-eastus2azlp17010020.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([40.93.12.20])
  by ob1.hgst.iphmx.com with ESMTP; 05 May 2025 17:51:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jSKF5Wrsf1t+xxniHB9/8hF6IOrPxtnfyTiIRChjE+jHSoS44QESXnQxmg3DANw2NtHfH5IPIyA+FlDV2g4eKc0UI/oDgVFoCh9XCszLhjgzOPN57+oSjm70f9qBF4tMAwDXms0oU7Am3oRaJfvpC0kXvRlDb05haSV/vFFfsrDW8gb+mfrNg26STP8YoYmoLOd1NB5/N0ptDXiFacRdMH1ek9MDfTsVJAXzMdc/XP6hR5RjgQG8dkTdvpELOmiClasz7Tab1qGZuzySR22Bkmbk3jJg9mvpIcwjT8/BRVlUDAobv0V82OhPmsXEhwuN73VlxxCbSye96Fj8d54v+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6mJ9Zy0JvOAR9LVVuLQ8G5UOwDdDXXOIOoOfVwnn5Y=;
 b=N6b1wuD2GVGhjuy/9z4TlzOjDFRpElDenDiN6NdCjfuaferf2IsJWZi6AG6Qgp+IBZ5hF/EJk2y85Pm2UJyqtEy32pPzsVEqrd4Mpg/w3ylOfaJ8YK0g/Xuohx7zIC85jNl4wrP6at+ZLJJrMyexVreCABR+6CoiDwM8p4KiI7tDv0rkrs/bAhXO7GbG+D/31oIS33wF3tzStjLMrTtuRHVLMWyqJukmgc4Si9JCpu/Uejh3Z1o40N+ucy2Z7RIBVEBXwPgOmEDLKPtcqnUe1Ylk0WiBCacn9y8/Q+F77WQd5Hkw7qT63fr9D9iA6sH/SQ7/Ebke7rQY8EiezmjHkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6mJ9Zy0JvOAR9LVVuLQ8G5UOwDdDXXOIOoOfVwnn5Y=;
 b=N2uXaSQn5Rn/u1PfaKp+0Rpi8Hlj1OK0MlVvUoqVlCc/JXjGXhgXfkcJ2w0IF2qB6trtJ3wGkIUYm35MeaiNbKcIAyacFhQdMSUNPFz8d5qFXd4BFxwIBBAdWkk0rDLKtNVNLHnTS4oA5zTroxfOBiFQrpqmHne1ADvYIs1fito=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by SN4PR04MB8350.namprd04.prod.outlook.com (2603:10b6:806:1e9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Mon, 5 May
 2025 09:51:48 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8699.021; Mon, 5 May 2025
 09:51:48 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Zorro Lang <zlang@kernel.org>
CC: "djwong@kernel.org" <djwong@kernel.org>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>, Hans
 Holmberg <Hans.Holmberg@wdc.com>, hch <hch@lst.de>
Subject: [PATCH v2 15/15] xfs: test that we can handle spurious zone wp
 advancements
Thread-Topic: [PATCH v2 15/15] xfs: test that we can handle spurious zone wp
 advancements
Thread-Index: AQHbvaNRJpxLJ5FgFkmrq6GcallV2w==
Date: Mon, 5 May 2025 09:51:48 +0000
Message-ID: <20250505095054.16030-1-hans.holmberg@wdc.com>
References: <20250501134302.2881773-16-hch@lst.de>
In-Reply-To: <20250501134302.2881773-16-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|SN4PR04MB8350:EE_
x-ms-office365-filtering-correlation-id: 23ad5d48-44c3-4839-6fd2-08dd8bba743c
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?XsTdLyO4srSirPpuPciJFubLII9Ffeq210q/rPKh9dWUO4DwWbRKGzaun/?=
 =?iso-8859-1?Q?wZI3+wuwpacWOo5rIDowSAG2QPWdI9Onoh4jgMAHGA/LfRnUdcDtIeDTg6?=
 =?iso-8859-1?Q?31JZD43BKr1p4SHWHj7TJv1SY+zEcYuzNK+dSPqbFKFXiseYHOUe6ZTbEs?=
 =?iso-8859-1?Q?UInSUSkkCgUOeYcNkTrDokgBMkE1kj732N+LbRwMMDipMex7HNwTFI1qbv?=
 =?iso-8859-1?Q?gLkkjA4h39PtncvJkl9pzd9LI//vvzk8YyY34v9V0JurAkG+JIGnVZHRi/?=
 =?iso-8859-1?Q?IRapgTs41iqv5QHMfvpMA4+opTPjstIHqS1AyWIDd+WxpjUnpJwMyUTFky?=
 =?iso-8859-1?Q?gdit9jE5aCNdO4jMmMjIfIzhqdr5Wxpew1CX7kU0Sq88/02UgR+Tb11YyH?=
 =?iso-8859-1?Q?+wnLirLFdrrwShks1tsLpi5p2iLmX35Ds58/9GmIs/VtkbHsnawVUMI4nU?=
 =?iso-8859-1?Q?66gve9LSPdPXzSea83g9IinLepaf7YO5oRGCNXtE4NtScChkcB+xVfSonG?=
 =?iso-8859-1?Q?0PMbIfc5qw7E+STTVzHqE8xpL5AvjB+Si4of9OWmNoXGpWZBUbl5OD9Le+?=
 =?iso-8859-1?Q?Ie4RnoQWxQAH15jRsKKdv/NkeXUvoUlZ1JAoFaf7W6AmcahOnXeSRGVDTK?=
 =?iso-8859-1?Q?iJ7Y7Jm4lX1WgS1FDXojl0JyuTXm8OT1UWgqNgWJyw38D3QxyGuRyUmn3/?=
 =?iso-8859-1?Q?2kvN5MNndEG2UvdZx2y7h+vyP9cLGwMisnkinw6oTWcz+At+GtxwyVC17r?=
 =?iso-8859-1?Q?KjWG6Asmhb0hLJdlCducPQ/G96qDyBtoGAkE5BLNqtxbi89IpxvmBUhILJ?=
 =?iso-8859-1?Q?/pqPiE/b7RbF9T2EhybpnEjekSmvXtBLmAh1228zuITpuyDxduMXPCsYPm?=
 =?iso-8859-1?Q?lrjvJ+RXNQlVHNd31zyE9egWych9m6aLrxseZx8x4annuTvLJSSlrDpseO?=
 =?iso-8859-1?Q?ssFBWDSZ5cv67sn08AAlqo7PxFpax+ygrpWRItcLerfbFOFCrHrdNiWPrg?=
 =?iso-8859-1?Q?8Vf1a9iIIwott2Wtgs+OD1Ud7DluK4RAJYZpnhioDepFGxciYpVuMsWNuT?=
 =?iso-8859-1?Q?ukWJqKgtvb6MFtV7FWhelkYCVSh/kByGDkAF4evePdIzVb9qkbLrMoau5U?=
 =?iso-8859-1?Q?ByFhtzRurakveCkEf+diS1BrjxVz9maiIuRlJFrgOuV27t+lpw1+AhtFLy?=
 =?iso-8859-1?Q?7OJ2cOsLuUtuER3ZYPZrTWe2uTHGyYvrqpLNPtTTbA7Za4F1GUJOhYRUez?=
 =?iso-8859-1?Q?j42M8pOwFmso2YjWOBYEgmIdgAe61RJrG9eR56iagdZ7uBV+bTIWXQpAWk?=
 =?iso-8859-1?Q?2lHz7o8Y/7BkFYXLbV5AmbBWIkHHOIrN+KBfpakmQWDzUOqRtHQ+E1QX2F?=
 =?iso-8859-1?Q?OHlV6L8us35YYvFforhlxwphboo7E50gmoCxq8Mlenvfke7RnSplYzMgiP?=
 =?iso-8859-1?Q?VNK2uBJsstdqWsbfE+sGLVvFyHwdjBvVs0oXh2kUT2X81UmnbUrw+oJdSO?=
 =?iso-8859-1?Q?xWKHi8QwxcSy+HQ3gJp9tLqnRF04ibaTECAw5pUTB2Ug=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?96k7lmEpdOPsmglVxmhVey40TeGQaBbcp5hwBXEWHHDfnIZWNAok0fZu2O?=
 =?iso-8859-1?Q?p6E0JyrX6uV/bPqXiDbCpK4BbHHFETD7AJe9hHxhmZByETO957yN6NATRJ?=
 =?iso-8859-1?Q?GB4jEp9xUYiZjkZ+E/xtkw9D1+hV6p40meCrq4XpzNTTm7+OPccoyiY5Th?=
 =?iso-8859-1?Q?Zzu1q/VUD7Toi9At8fIKhb56EwkAd/A3h2alqBMknsNdTniAhMRE2n+ydk?=
 =?iso-8859-1?Q?NBka+HZ2D/Prm5DYqWAg0QDIcH9f4VzVASkHKkOJATyvE5TIuitvkBF4r+?=
 =?iso-8859-1?Q?G+xxDFm7vLhWgOcr6qDXvHN/JkRKRpQjdxOq4FEnxIQDVbsXytOir76X+s?=
 =?iso-8859-1?Q?ZIhfthkLgsU0vpCUlHAB8nDJLiAsXx4n/3T9Tk8oklPXIRBT1qr9Qq1tXR?=
 =?iso-8859-1?Q?RpQklgyKGcC+OM/oRakt18UTEwGhqMnqfOpFGEs97EAe2N24gHfuJMfKE0?=
 =?iso-8859-1?Q?b6D7Z9FTg7z2QttWi6iarbl0mQLDIz3b9T2bvVy9vL6RmM0a+WSd1KX80k?=
 =?iso-8859-1?Q?pxZ84LwKd0URkVZnL6jvLTLsSgCg/vj6DqCneYBgg+FAMrYJ2GL0IlGy6d?=
 =?iso-8859-1?Q?GTuVvvSxO6J13mULHGEuQVCIxop+JUm9yL+rwgyhhyGT/lKe1Luh8WgPe/?=
 =?iso-8859-1?Q?bp7VEk9KJjQz9dFQf1VALki0JGcGgrCJnZKsSGaCQH1933/EurUgJOohvW?=
 =?iso-8859-1?Q?rNAa3ihkis75gOaz962YO/wrRcCUuDa4TwJMDcDSJIffZxxNjpDaZQbNCA?=
 =?iso-8859-1?Q?Y4Z/oNzdv+xhEw7WJ1TwAzFejzwKlBd2PSPOIsaRYO0l12/y2AOmylrrF7?=
 =?iso-8859-1?Q?MotQpEaz0yU+bQrPUijfvPfYp6j+YWHGuOCN3BBs7r/wihsby0ziuFYzaL?=
 =?iso-8859-1?Q?4NXFnbM/TI+vsnBiA8R/PxZK7qZIfVbGdnpes7DSueMMXTWI1d425l71dn?=
 =?iso-8859-1?Q?k5Ayl7oK+UY3cMQwYDISAo4LOtGwrfq3JMiwhVh8SK6ytn7s2PSEqUDVeQ?=
 =?iso-8859-1?Q?QyHxzTn4nsQA2J9yV6VtfDuCBoPH52YLnri5JYTG/KnUYHPTNoG0+rXj0s?=
 =?iso-8859-1?Q?/1sXXuj1arV2z5DL/uscnE/UcO3EjhdlmgMO5I2nVTNfW7TzXYY35UhAbL?=
 =?iso-8859-1?Q?4WWaz7lBYONs08KYw5Aaw2JpkGExGDoRRxHwEU8HboiQwwN69r3pkqXe1h?=
 =?iso-8859-1?Q?14XtERFKGqUO5b/gVtvzePEpZrfvIQ2zpPGe2rYverCBrDkxM59nVfXeBK?=
 =?iso-8859-1?Q?1/53OldpYwJtrVYxorua2EXCXhPKg5okDIjzbRU9/cLGfT38MxvhwYy+xH?=
 =?iso-8859-1?Q?7+zK3mwTXzvtQ6Ft4FOqirlGbJpYpyGzc9Rz6eyeC10TdQAGu7buxkkQcq?=
 =?iso-8859-1?Q?fueLWSGmzFHyVx/fsghLPZtPgNM9Guibf8xjXPyha7vVhcWhgYQtYP++4j?=
 =?iso-8859-1?Q?xM2gNQpHFGtXdGuhVFV9tVlQsejzpaxkw0oBcaJZ0QXqwdiQBJLQPftWle?=
 =?iso-8859-1?Q?pVOZy56yGgaPs8dbuUTrG7PD144Qcq4sXyGq5IxT5EcvB3pg+8Sq9FLZC6?=
 =?iso-8859-1?Q?1Xj31HgFKOv6+/e4uROJXXNNYUIsAANr/inzg1C37tCZ/vaSFMl02erfdw?=
 =?iso-8859-1?Q?pNZdvf7Jt1fUDxxlkjt+pNX7TtqHf81cx+ryoFE2epk/ujYY2AEgM+HQ?=
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
	0l8fGJNIxdPcwsB/TAm59lS/l863EuKgziR61mEAG1ulLGO5UffLPXUhqlfAOOPwpH26vrQ7qoURS4qK+YE5p0sAuAeua3l1af+Zoz2Ja1KmGbEA+9Fb0k2pMzpKLZFS3xdS/+E+o0RhPWvHo7pzNDJnLqNKB5DPk4JLDjHYQx+MBC3e3L1IHyUWzkkEddFZdphkxfvrMaqDC7uribrew/Ldlb4q4vtAhyC/ZbzHvPX0C82qEYi5WKL2v+3xWAvoSTLautbaXtc9pBlOPi+XUKvTpimir13ih/JMmuXr6U3p+q8d1IKeOMjtw6MkeGVTKEObhGJ5gRVJFOWGqTSLefCgmrm3+mMyIy6PLBLarGdfDqVm2D1yFkMyOZiqpBIdVja/GN2urbJLifxhM6wCQKMuW4eb1vk/hjj/vQ3V38djnE2PtgLkW9mLpORHcgxVZouzUJTNEiylceeuTlMeTwL5CVBWmA2VCDssJv/4YjgNGWAcDyNYtt70DjMafMv+O9teiJYQknMJ9Ktd6jHgcWJ7XZvKM7EUNU4A+Cb+t+tIlhDMygHUffbfTkSeAUcwE1eHwOneqjcexD80FAmEU46Pmext5lrt82tTPYjU277sYz/qMRhUZwlpHOvTsrwa
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ad5d48-44c3-4839-6fd2-08dd8bba743c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2025 09:51:48.6465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5bNxYBoz1gjPsof7fx4vhymCaVlbc4W9oTxy1JJZvli3N7nx1gP5ZiTIVdaY9RZuzynGXn52UtNVjkfwtchpcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR04MB8350

From: Hans Holmberg <Hans.Holmberg@wdc.com>

Test that we can gracefully handle spurious zone write pointer
advancements while unmounted.

Any space covered by the wp unexpectedly moving forward should just
be treated as unused space, so check that we can still mount the file
system and that the zone will be reset when all used blocks have been
freed.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Canges since v1:
 Added _require_realtime and fixed a white space error based
 on Darrick's review comments.

 tests/xfs/4214     | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4214.out |  2 ++
 2 files changed, 64 insertions(+)
 create mode 100755 tests/xfs/4214
 create mode 100644 tests/xfs/4214.out

diff --git a/tests/xfs/4214 b/tests/xfs/4214
new file mode 100755
index 000000000000..0637bbc7250e
--- /dev/null
+++ b/tests/xfs/4214
@@ -0,0 +1,62 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Western Digital Corporation.  All Rights Reserved.
+#
+# FS QA Test 4214
+#
+# Test that we can gracefully handle spurious zone write pointer
+# advancements while unmounted.
+#
+
+. ./common/preamble
+_begin_fstest auto quick zone
+
+# Import common functions.
+. ./common/filter
+. ./common/zoned
+
+_require_scratch
+_require_realtime
+_require_zoned_device $SCRATCH_RTDEV
+_require_command "$BLKZONE_PROG" blkzone
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+blksz=3D$(_get_file_block_size $SCRATCH_MNT)
+
+test_file=3D$SCRATCH_MNT/test.dat
+dd if=3D/dev/zero of=3D$test_file bs=3D1M count=3D16 >> $seqres.full 2>&1 =
\
+	oflag=3Ddirect || _fail "file creation failed"
+
+_scratch_unmount
+
+#
+# Figure out which zone was opened to store the test file and where
+# the write pointer is in that zone
+#
+open_zone=3D$($BLKZONE_PROG report $SCRATCH_RTDEV | \
+	$AWK_PROG '/oi/ { print $2 }' | sed 's/,//')
+open_zone_wp=3D$($BLKZONE_PROG report $SCRATCH_RTDEV | \
+	grep "start: $open_zone" | $AWK_PROG '{ print $8 }')
+wp=3D$(( $open_zone + $open_zone_wp ))
+
+# Advance the write pointer manually by one block
+dd if=3D/dev/zero of=3D$SCRATCH_RTDEV bs=3D$blksz count=3D1 seek=3D$(($wp =
* 512 / $blksz))\
+	oflag=3Ddirect >> $seqres.full 2>&1 || _fail "wp advancement failed"
+
+_scratch_mount
+_scratch_unmount
+
+# Finish the open zone
+$BLKZONE_PROG finish -c 1 -o $open_zone $SCRATCH_RTDEV
+
+_scratch_mount
+rm $test_file
+_scratch_unmount
+
+# The previously open zone, now finished and unused, should have been rese=
t
+nr_open=3D$($BLKZONE_PROG report $SCRATCH_RTDEV | grep -wc "oi")
+echo "Number of open zones: $nr_open"
+
+status=3D0
+exit
diff --git a/tests/xfs/4214.out b/tests/xfs/4214.out
new file mode 100644
index 000000000000..a746546bc8f6
--- /dev/null
+++ b/tests/xfs/4214.out
@@ -0,0 +1,2 @@
+QA output created by 4214
+Number of open zones: 0
--=20
2.34.1
