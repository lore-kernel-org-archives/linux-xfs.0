Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDF7EC5
	for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 12:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742475095; cv=fail; b=scCXq/HmEQKMEzOCh5G1xfZphjYajLULp/BrHX6SzGHYdotlJM6tNWz01/R7VFKnMGQMh/P+W/RPT+T1Q/iy520C0rQzXTlHGJjI2hD6RwnedWBsuBrr1XMXmoHQs+MOEco+jT1lxQIgu4cjJqRnMA0qZ2MLAS7O/gmmxxPRXqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742475095; c=relaxed/simple;
	bh=e148gh1xtw1fuzkrVMlCw/8g3w/D2dmM4SuoQ7H/sHo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E2DItVUJbF2zADx/X1GaYvAGdRAPUnVyHWTp6+RYp3PyPJCeMYxO8PGkvZV6v1jqG1q7lYgqpmkJATX+9eCZ5Z94Ualz+OscIKRD4XSwAoKsRRayc8r6YKIvo1ww1ytsi9wkpobodGezWuRk6zbx9MD2i1Gonr4AJur78Yi3rFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rUtvQaxC; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=QqZCOnsX; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rUtvQaxC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QqZCOnsX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1742475094; x=1774011094;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e148gh1xtw1fuzkrVMlCw/8g3w/D2dmM4SuoQ7H/sHo=;
  b=rUtvQaxCQdzzBvbSdIp1jXFrO43SzauCy7q+GUGWcMZk3saRlZUgAAFs
   Gm7fnrx3IRZ8xXevwpC2+bBRzazu0GsosKm97E/5FzTTSyBWtT7ejk3D9
   i/Xzmil92It5/q3S8oVofBv++ZPfZiM75/AQM42sUes4fOyCdk0C4tvEL
   ZhB+qaEc1wE5HCTDNELX/6GD1A/u4FBK6QUltWPCWzYfn4GOyTO3W3qdA
   900zhHGn0EcWPl2Me5M8T5yWkRRCnIK0+rxm+e8iw95rnZvp7VEEaRJ69
   bmPIQqvK6yksVFKRIk74nQPnvhxzsR5dTqRWeDZMKu8TiG9OB9D/mCV4e
   g==;
X-CSE-ConnectionGUID: qPrlbbCISQKxOkZEP3tnNg==
X-CSE-MsgGUID: pLYdNkg1TtC1yDDP9Z7zZg==
X-IronPort-AV: E=Sophos;i="6.14,261,1736784000"; 
   d="scan'208";a="56773696"
Received: from mail-eastus2azlp17011028.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([40.93.12.28])
  by ob1.hgst.iphmx.com with ESMTP; 20 Mar 2025 20:51:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y8ViA4dR0c5h2bo4VBM9beQecxfqjwa9fK6fWin+pWZRo1WG0UEeZIViiDaKV2gdAL/NfqaCnvR9eVGTXsTjyGCPw9Y423VfUE7FtKGl4oOxswAJFAkMI1yZ7gpDmFp7z0tzrfCt6AX3GriYbC0vlAEKBeZMEgOaK6b5SfpFUw/PbgtAyL24TLxsnV32tgaBTDYEaho0HYzPqOrxNwO8XYlRWWJFjW1EAxtXC2oqujjNIq06C3Za/n/lgMxUhX4SCBZ5xIH2KN8THIWOnpaPJRF7Tre47gYBu8hSnzP03wxW1osKe48WTywU+31goGVlhxYrLnlbMUei7bnZ9r1BBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e148gh1xtw1fuzkrVMlCw/8g3w/D2dmM4SuoQ7H/sHo=;
 b=Fz8scKRdRub3J89R39jxLTbGOAKQBbJylFhhBSc1U14ebZae77AyMb7Y04iRft3LgDMM6S4R/Y1vBNB1DintBP0YiAnX2LIbxXP2bPOn9t4BRmsQJ+wmaY1AC/NBJfdNC4lxTF4BQegfO6CtX4q+bm8cWa9pBXnzHR/uWHRz+UcfLI7TW9FfFBLKVc6cXnUzhDPemMc8acSe27aQ+zHZzJID2vNvj3RLpMhNrs3+tdQKY6mHn72znUNrUg6uFhfTQ0lYqTtM78JYnXUDisDWxN7XqelEioyuy2dkxO54UASCAJIEnysdaCPbbSk3+B/ASURi95tch8321jjJ8MMAMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e148gh1xtw1fuzkrVMlCw/8g3w/D2dmM4SuoQ7H/sHo=;
 b=QqZCOnsXDZnXpOrjyEI9YZbbIWBhSQyLUzsFE6doAkCDnV8/eRdi98b5BdmcJD00nIAqXEk9HJC1fmJkNY9ULJUuawh0fW7B968H59Jwb9NzukchCi3v1uOFRmZtQJ/2Y+V9gNZg0YXV/w+W5Nxc3v0o4C+FUqLUQgbU/cdTxKo=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by SJ0PR04MB8259.namprd04.prod.outlook.com (2603:10b6:a03:3e7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 12:51:24 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%7]) with mapi id 15.20.8534.034; Thu, 20 Mar 2025
 12:51:24 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "Darrick J .
 Wong" <djwong@kernel.org>, hch <hch@lst.de>
Subject: Re: [RFC PATCH] xfs: add mount option for zone gc pressure
Thread-Topic: [RFC PATCH] xfs: add mount option for zone gc pressure
Thread-Index: AQHbmKececZlurDM5k6Psoy8DLTbGrN6LJEAgAHPsYA=
Date: Thu, 20 Mar 2025 12:51:24 +0000
Message-ID: <caaff621-2da9-4c7a-b6c1-76cd2317022b@wdc.com>
References: <20250319081818.6406-1-hans.holmberg@wdc.com>
 <Z9qKUt1iPsQTTKu-@dread.disaster.area>
In-Reply-To: <Z9qKUt1iPsQTTKu-@dread.disaster.area>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|SJ0PR04MB8259:EE_
x-ms-office365-filtering-correlation-id: bb2aac0d-be07-4a0b-7622-08dd67adebfa
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TjRReXZ2TjhGNzA0a3pFUW52cTJTNXVpMThXOHRYendZRmhzeVNveUh4RXY3?=
 =?utf-8?B?VmI0QlZHdjRCaUQxaW5KMzFlT3ZTVHVIaWNoU2QyL2xCeVpzaFFpUmJqWFpv?=
 =?utf-8?B?NzJaZDB3UjB3Q2Zaek9kNWF0MG5VKzd0UkUxaGE0TFlQYkpuZjRYYjhVa095?=
 =?utf-8?B?bEt3ZXZNbk5VamZVZWJFc2lDTE0yM1VmUHM0cVVHRUdueUdpaUFhSVRIRTRL?=
 =?utf-8?B?dDd1aWZjLytDaVlDWGVHRnJGcnY0NCtUSHlyUkZMYmFsK282ZUR1VFZibyta?=
 =?utf-8?B?dmNZT0tGTDlNT0VPcWl1SUhXV3psaWVadytoM2k1NlRzN3V2MlVhUlFUSDNp?=
 =?utf-8?B?Y1hocVFBWmRDbUVCakFPdW9vam5ZbDF5Z0dPUkxjcEJOcVN6STRwbUFmRUU3?=
 =?utf-8?B?QVdTaCtGaHR6MFRHeVl2SDRxTTlQaDd0cUl0dVBTU09pM05iV1dwcmczdHp5?=
 =?utf-8?B?dFdndUhRTklBazJHN041RWVZZndrblBrRC9yRjdvaXNBK3B2eXUyOWc0QjVS?=
 =?utf-8?B?cWVNektKTzFpR0VMNDZhZlk2ZDJBbi94ZWI3VFR3bGRKazNTeE5odVozL0xw?=
 =?utf-8?B?OFpuSmhCNEc2TDdCK2t2ekhXbnlPYmxEcGhzM2phMlY3MGdqaC9LOU9ZMFdU?=
 =?utf-8?B?VEhJSW5uSTVJT2VIRXh2aDErSVJMbHVyckFOZTVzeWNnSW1NaWdIdXBnVVFC?=
 =?utf-8?B?cDhSNDZhNWZuZ2VKS2NHQnVPU1U3S0tzb0cvS2Z2RlRzdjNYTHpqTkw4NEU5?=
 =?utf-8?B?U0cyOGhNZTZMb1d1ektOTlVXV0pwY2pyWmVqQ2t4aSs1L1E0MjVISjRWWmRz?=
 =?utf-8?B?eDdvZlNmKzEzV2tybGx3OTJCcDQ5OVBiOHVjQXd3YWdXOEduOFl4NFdmN2Vt?=
 =?utf-8?B?OGtxODRJQ1N4cTY2dUt2clhVRXNWaEpsTzlmMzQ0NGVhQnZiUUVhZEVvMEI5?=
 =?utf-8?B?dHN3YXdzc2VFUDJZbXR2Z2RsUmYwQnl4V1IyUmlLUzRoY29VdjhLcHY0Ykdo?=
 =?utf-8?B?T2NNWVBnNHNBR00vQTkzQ2tHWWFQbjkxalcwVGhoRWMrN1R3eTYyTHpWdFlx?=
 =?utf-8?B?RjBwNVMrZkxMWVlFZnNzbThMOEE4Q1JWNkEwdmcwbkR1bVhZTEFoY0FqRnBN?=
 =?utf-8?B?czRLenFrU0xVZlFSZHFzUENyNUlNZDQ2Z3BBOGhBbkk4TG03alZ3RmRWODg1?=
 =?utf-8?B?bytQbWkrS3BqWW9tSDh2R2RXQlZpWHEwL0N3ZHNWMXQ4Z0l3ZEU0U2VJMUFw?=
 =?utf-8?B?Qmk5R2JnUTB2WXBIOHVtd2JIK0g5eWdFTzJhMVRpMVVyQ3k3V3k1S1BHTm00?=
 =?utf-8?B?VFRqdU0rcEdZWFlBc3RBUHpyVmxUcWF3cTZHYnNVdnBDZlNIZUF4THdOYWxS?=
 =?utf-8?B?b1ZRNDMwVXJwZ3Nadmt5dHdpV3NkK0NqcGRKTmg2V01kS2UwVGp1VFpiUnF5?=
 =?utf-8?B?MGRPcUFFdGlWUGExRzNEMk9TRGljWFl5OWx3NTBUelZ0YXVYMGpVUDRFTU56?=
 =?utf-8?B?RE9IcGxOY2JCQWhmYzB2VWI4akJScjJwK3lhRG51dkpLQW02QW5ZY1FXMnZW?=
 =?utf-8?B?TThUVk55VkFZS2JHVUpjQnI5dHRkdkxjNTJ0ck9NR0xFZ0pNMEFIMWttL3FV?=
 =?utf-8?B?dDk0SG4yeHhwY1pDZUExZ2p3TUR2M0x4djNQb2JsaUNpWWtpQXF4ZXBoM2Er?=
 =?utf-8?B?NGFudityd3c0Q09LeXdXZTFUYWlMdUI5MjcrQWEvZEcyT3JHWWtVR3BuZzha?=
 =?utf-8?B?ak5FandPbGpVdFAvd2N6QmNKVDZoNXlJMXRZTVJpTThrQlZnelFQc09od3R5?=
 =?utf-8?B?aG9iTC9taUlOMW9KdVdlT1Rram1OcHBKTklNbExtUUtHOUYweWI4WENrOHE1?=
 =?utf-8?B?QVFFbDJub2orQ3M3c1lLTWhabEx6N1BYWHlPbFJkczVOVmdWQ2M2aGU0VXcw?=
 =?utf-8?Q?SKk+U9IgVkkniDcuqQxA9xUEwjv0VjN3?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MjhTcnUvbkNVcm9OOEFscldKVWpKMFdzckt5YW05UmE5WEZEdGsyMWxGeDJC?=
 =?utf-8?B?dXY2TFdzcEliaDBmWjlvYU5yaDFSMDRITGdHS0FhSklEcGt6Wi94OEJ6VFhl?=
 =?utf-8?B?S3FpOWxyL0MzaUxwYndtQWpVRVl6UVFFNmJ4U3lWRHAwWTFSRWpFMkFBSzZL?=
 =?utf-8?B?YWYyeHFwNzBFb1VjZ2l0NHo5cWlGVVNPQnp4UittTzhyazhDWGlXZWJVekg1?=
 =?utf-8?B?VVlYWmsrZyt5RUlMSGNYaXovanpBRlFEY0o0OCtDWktGdFRKMGVhOUNsekth?=
 =?utf-8?B?ZFd5RSswanFqK09YUlNneDBta2tqeDJoYkxTS3pSdnhVdWNFUmIzNlRPYUp6?=
 =?utf-8?B?alhvNThKRHNBcGhzRzFtUTM0aWRzcjJzSFhpN2xGMXVVZkNPeWpyZWlnd29p?=
 =?utf-8?B?OGtKQ1pVSGttaGNwOFJBRzE5em1ocGhWRFBPNzFwSlMxYTdrQU1PRWVqUzVE?=
 =?utf-8?B?Qzd5cFhxOHBtaEh6Tkd4ekIyajRJcExiZzUrZXROeEFGZ3NqQkd3T1I5UXZN?=
 =?utf-8?B?ekkzc28yYWNZV3lMR0J1Q0h0TVByNnROY3BRckdhSFdiTzByd1Q4RkJXUXBB?=
 =?utf-8?B?RWtuWEFOS01JbjUvNGovWWQ4M1lSQ0Q2YzRsc0tzYWZBUFZrK3F1Q0ZBbkQ1?=
 =?utf-8?B?aEJqZjc3WUhaTXllQW0xbGd2b2hUWkdocm1FcnRvVFlMd1JGNHNZREpnRHNq?=
 =?utf-8?B?Q3BnUVMva3RPVmNjaGR0M094clZxZm5UanBvUTkzakk5aGZ1ekhBTDk4d1By?=
 =?utf-8?B?VUtraUI4WHpjRG5xbTdxdjRmWWw5elBPV0NJWStML05aQjlaYTZQVm1OTzkw?=
 =?utf-8?B?VVJHZkFaVWlXeVlSVUZ0UWpKZk1DckoyRVNSdkJiOGxlUkhoaEkrS2pXZVZr?=
 =?utf-8?B?dVI3K2taOHQvcHVMSkRrSElwUXFpaG05VVFqbWJmeEFxSGlHcEVrblcvWEY2?=
 =?utf-8?B?TEloQlR6TjZKWXZ4aDh1SytJQzYraFVyMktBejU3R1VieXJZa2Q5YU1VUUg4?=
 =?utf-8?B?TzVtQTBSanVTdStNb0dHL083MEg1OVhTaG5aWDZJT1J0SE1sV0pTd1g3UWY5?=
 =?utf-8?B?TTZkVFA0Q3Uva1ZZRzZZUzltUXNkZ2kwQ2NHcGQ3ZkgzeE9MWnVVTVBZYmlV?=
 =?utf-8?B?VkhJL092Y2F1UnZ0TTE4WnR4bDlidjBaZzA4enFkQ1NmWWpMeUxtZC8xdlV0?=
 =?utf-8?B?VWc3enNQTDZyODZkTW9URnZRK0U3WC9aVS9EK1ZJUWFoVG5yMTBYWGhBWnZJ?=
 =?utf-8?B?Mkh3UXdCditYbGhjeENLQVNTUjBLVWJzTW5tclhvN1FaOVhaMHVveDJzQWcr?=
 =?utf-8?B?cXdjY2FsazlNZnoyREdxcHYwZHhJKzZQOEVvck9NVzZzK1p2VkxDcCswZkhh?=
 =?utf-8?B?NmZTcXNrT0tDNzZ5elQ4UDdTc0svTTRoVUJFUFJPSnFwOVlkZklNRWpSU2dK?=
 =?utf-8?B?M3F2QzBCZFJHV09VSFNpWWV6dmJ6UW9lZjluMUNPa0U5c1Jmd25KQzNxanJB?=
 =?utf-8?B?K3ZBV0cyTWpKeGc1YzJIeTZYakdYNkJMcUVQQXhtZXIzSU9EVlkzWFhNZ2Jv?=
 =?utf-8?B?VkFLTXJrUzZVTU8xS1I3ejlCWk9WL2xmbXJDUzQya3ZhazhYc1Fpd3JsZ01s?=
 =?utf-8?B?YVF6VlBpMERYWlJGQU1meVZ3NkVpckFoVWZFWmUrKy9LRzRZbWN1Q1d3Qjhv?=
 =?utf-8?B?MEx0THhKYlJkTFpMUmNxeWRLN3pRUHB3UEpaZC92cXJwa2VHV2s4VXNiWTRQ?=
 =?utf-8?B?K2NuY1BYNWtGWGNXdGsvTzNuOEdlU2RtWGt4ck1vL2N5ZjZhMnZ6T0ZPSkkz?=
 =?utf-8?B?NzZjMHpBajJGMERsM2pHdHhkb3pXdG5xSEExOEczTXZHekVuN1NPMTVlVFcy?=
 =?utf-8?B?NGQ1L3FRLzVUR2FBNjdFb2Yya09saUJBVUtxck9HZUE2a2dsckFhSEhudy9z?=
 =?utf-8?B?dE5ta21BUmVNbm9vZ3MyL0c0N3FtR2gwYTZXSUJ2dGJCUStMSGdMaUhoRGU1?=
 =?utf-8?B?REJXbnRrTlpNSGdYQkprcUtBWkRURTZXRW5JVk55L1lHaXVCSDMrU1YxVU5I?=
 =?utf-8?B?WHNLTnBhNVhYaWJPSG9ERERkc1IzemtkUldYeXN3R0NZSGxzT1VoTG8zZXFF?=
 =?utf-8?B?UmtwTEgveXEvQlpwVVVIc29FK1crVkdneHFpMklncTBicWhCMGlYdnpQQ1VV?=
 =?utf-8?B?cGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AAA6B6D38463D47A2AA4C628706721F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DmqfzNuamTA1na1DwvjHfMtPTLWU4O3rbC0U0t10l/I/3OBpbnvGAS+FmTgntDWUS0v7PfoXHVSRZfny2Tit8u0UPcfXkKfC9PZRiwZs7w/6nBMVZuyxehWyhNRyQfqYJI2a5r71Qme4A2crBlTq3tecLOfvUeG8EuuWUfmFJ6D0XRiBa9Tv5OFJQTSMM0NTvLk9QWrQM1LIfngyWb7dhdA+1W7+WolbgbhfSqn+Qcsu/wwfA8yqN8U7wZEAb4nwizvjRllQsIZxhvDPxbaafu0rRwSP7DcS+jWorClc1HBp1PfHg/WRv6GHATYANdEv5mHGbjqb4cTBSsNQ/3wm5SQvyqRZSrxbmUKpY37+qzYVGT++Xoez2vrGZ/fcEqohP9KZCyUJqxnj6LVzGihLWLCtxcF9lqpTcCyWxEr9I3W1DFsYDeh35MpXyjsBnj86NLGRq2UdKAyuhfgZ74UgYGEBVd32xUpyV0HflrHa/D3i//jW8M44Qktky5ujDdIN8X308cU3WqypoV/adSE1cnHUY2xi22NwoD45GY0AAJIMbGxWtZSH+d9WDCve1EpvIotb8ZhUah8r1QPqqrj/l6h8C7TVLI6+YKoEyl561xmoZmh/Gtbtlgy8ImnYRl8S
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb2aac0d-be07-4a0b-7622-08dd67adebfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2025 12:51:24.1634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O7qsDiDAIOBdyp0ytAr+L30N7X7Do72x9q8Sw+uiNmixVQ7f1T2BIpng4egly/eGHNs1f5TmHZwTAbf/wNhxsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8259

T24gMTkvMDMvMjAyNSAxMDoxMSwgRGF2ZSBDaGlubmVyIHdyb3RlOg0KPiBPbiBXZWQsIE1hciAx
OSwgMjAyNSBhdCAwODoxOToxOUFNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4gUHJl
c2VudGx5IHdlIHN0YXJ0IGdhcmJhZ2UgY29sbGVjdGlvbiBsYXRlIC0gd2hlbiB3ZSBzdGFydCBy
dW5uaW5nDQo+PiBvdXQgb2YgZnJlZSB6b25lcyB0byBiYWNrZmlsbCBtYXhfb3Blbl96b25lcy4g
VGhpcyBpcyBhIHJlYXNvbmFibGUNCj4+IGRlZmF1bHQgYXMgaXQgbWluaW1pemVzIHdyaXRlIGFt
cGxpZmljYXRpb24uIFRoZSBsb25nZXIgd2Ugd2FpdCwNCj4+IHRoZSBtb3JlIGJsb2NrcyBhcmUg
aW52YWxpZGF0ZWQgYW5kIHJlY2xhaW0gY29zdCBsZXNzIGluIHRlcm1zDQo+PiBvZiBibG9ja3Mg
dG8gcmVsb2NhdGUuDQo+Pg0KPj4gU3RhcnRpbmcgdGhpcyBsYXRlIGhvd2V2ZXIgaW50cm9kdWNl
cyBhIHJpc2sgb2YgR0MgYmVpbmcgb3V0Y29tcGV0ZWQNCj4+IGJ5IHVzZXIgd3JpdGVzLiBJZiBH
QyBjYW4ndCBrZWVwIHVwLCB1c2VyIHdyaXRlcyB3aWxsIGJlIGZvcmNlZCB0bw0KPj4gd2FpdCBm
b3IgZnJlZSB6b25lcyB3aXRoIGhpZ2ggdGFpbCBsYXRlbmNpZXMgYXMgYSByZXN1bHQuDQo+Pg0K
Pj4gVGhpcyBpcyBub3QgYSBwcm9ibGVtIHVuZGVyIG5vcm1hbCBjaXJjdW1zdGFuY2VzLCBidXQg
aWYgZnJhZ21lbnRhdGlvbg0KPj4gaXMgYmFkIGFuZCB1c2VyIHdyaXRlIHByZXNzdXJlIGlzIGhp
Z2ggKG11bHRpcGxlIGZ1bGwtdGhyb3R0bGUNCj4+IHdyaXRlcnMpIHdlIHdpbGwgImJvdHRvbSBv
dXQiIG9mIGZyZWUgem9uZXMuDQo+Pg0KPj4gVG8gbWl0aWdhdGUgdGhpcywgaW50cm9kdWNlIGEg
Z2NfcHJlc3N1cmUgbW91bnQgb3B0aW9uIHRoYXQgbGV0cyB0aGUNCj4+IHVzZXIgc3BlY2lmeSBh
IHBlcmNlbnRhZ2Ugb2YgaG93IG11Y2ggb2YgdGhlIHVudXNlZCBzcGFjZSB0aGF0IGdjDQo+PiBz
aG91bGQga2VlcCBhdmFpbGFibGUgZm9yIHdyaXRpbmcuIEEgaGlnaCB2YWx1ZSB3aWxsIHJlY2xh
aW0gbW9yZSBvZg0KPj4gdGhlIHNwYWNlIG9jY3VwaWVkIGJ5IHVudXNlZCBibG9ja3MsIGNyZWF0
aW5nIGEgbGFyZ2VyIGJ1ZmZlciBhZ2FpbnN0DQo+PiB3cml0ZSBidXJzdHMuDQo+Pg0KPj4gVGhp
cyBjb21lcyBhdCBhIGNvc3QgYXMgd3JpdGUgYW1wbGlmaWNhdGlvbiBpcyBpbmNyZWFzZWQuIFRv
DQo+PiBpbGx1c3RyYXRlIHRoaXMgdXNpbmcgYSBzYW1wbGUgd29ya2xvYWQsIHNldHRpbmcgZ2Nf
cHJlc3N1cmUgdG8gNjAlDQo+PiBhdm9pZHMgaGlnaCAoNTAwbXMpIG1heCBsYXRlbmNpZXMgd2hp
bGUgaW5jcmVhc2luZyB3cml0ZSBhbXBsaWZpY2F0aW9uDQo+PiBieSAxNSUuDQo+IA0KPiBJdCBz
ZWVtcyB0byBtZSB0aGF0IHRoaXMgaXMgcnVudGltZSB3b3JrbG9hZCBkZXBlbmRlbnQsIGFuZCBz
byBtYXliZQ0KPiBhIHR1bmFibGUgdmFyaWFibGUgaW4gL3N5cy9mcy94ZnMvPGRldj4vLi4uLiBt
aWdodCBzdWl0IGJldHRlcj8NCj4gDQo+IFRoYXQgd2F5IGl0IGNhbiBiZSBjb250cm9sbGVkIGJ5
IGEgdXNlcnNwYWNlIGFnZW50IGFzIHRoZSBmaWxlc3lzdGVtDQo+IGZpbGxzIGFuZCBlbXB0aWVz
IHJhdGhlciB0aGFuIGJlaW5nIGZpeGVkIGF0IG1vdW50IHRpbWUgYW5kIG5ldmVyDQo+IHJlYWxs
eSBiZWluZyBvcHRpbWFsIGZvciBhIGNoYW5naW5nIHdvcmtsb2FkLi4uDQoNClllcywgdGhhdCB3
b3VsZCBtYWtlIHNlbnNlLg0KDQo+ID4+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX21vdW50Lmgg
Yi9mcy94ZnMveGZzX21vdW50LmgNCj4+IGluZGV4IDc5OWI4NDIyMGViYi4uYWY1OTUwMjRkZTAw
IDEwMDY0NA0KPj4gLS0tIGEvZnMveGZzL3hmc19tb3VudC5oDQo+PiArKysgYi9mcy94ZnMveGZz
X21vdW50LmgNCj4+IEBAIC0yMjksNiArMjI5LDcgQEAgdHlwZWRlZiBzdHJ1Y3QgeGZzX21vdW50
IHsNCj4+ICAJYm9vbAkJCW1fZmlub2J0X25vcmVzOyAvKiBubyBwZXItQUcgZmlub2J0IHJlc3Yu
ICovDQo+PiAgCWJvb2wJCQltX3VwZGF0ZV9zYjsJLyogc2IgbmVlZHMgdXBkYXRlIGluIG1vdW50
ICovDQo+PiAgCXVuc2lnbmVkIGludAkJbV9tYXhfb3Blbl96b25lczsNCj4+ICsJdW5zaWduZWQg
aW50CQltX2djX3ByZXNzdXJlOw0KPiANCj4gVGhpcyBpcyBub3QgZXhwbGljaXRseSBpbml0aWFs
aXNlZCBzb21ld2hlcmUuIElmIHRoZSBtYWdpYyAibW91bnQNCj4gZ2V0cyB6ZXJvZWQgb24gYWxs
b2NhdGlvbiIgdmFsdWUgb2YgemVybyBpdCBnZXRzIG1lYW5zIHRoaXMgZmVhdHVyZQ0KPiBpcyB0
dXJuZWQgb2ZmLCB0aGVyZSBuZWVkcyB0byBiZSBhIGNvbW1lbnQgc29tZXdoZXJlIGV4cGxhaW5p
bmcgd2h5DQo+IGl0IGlzIHR1cm5lZCBjb21wbGV0ZWx5IG9mZiByYXRoZXIgdGhhbiBoYXZpbmcg
YSBkZWZhdWx0IG9mLCBzYXksDQo+IDUlIGxpa2Ugd2UgaGF2ZSBmb3IgbG93IHNwYWNlIGFsbG9j
YXRpb24gdGhyZXNob2xkcyBpbiB2YXJpb3VzDQo+IG90aGVyIGxvd3NwYWNlIGFsbG9jYXRpb24g
YW5kIHJlY2xhaW0gYWxnb3JpdGhtcy4uLi4NCg0KDQpSaWdodCwgaXQgaXMgbm90IGF0IGFsbCBv
YnZpb3VzIHdoeSAwIGlzIGEgZ29vZCBkZWZhdWx0Lg0KSSdsbCBhZGQgYSBjb21tZW50IGluIHRo
ZSBuZXh0IHJldi4NCg0KPj4gKw0KPj4gKwlmcmVlID0geGZzX2VzdGltYXRlX2ZyZWVjb3VudGVy
KG1wLCBYQ19GUkVFX1JURVhURU5UUyk7DQo+PiArCWlmIChhdmFpbGFibGUgPCBkaXZfczY0KGZy
ZWUgKiBtcC0+bV9nY19wcmVzc3VyZSwgMTAwKSkNCj4gDQo+IG11bHRfZnJhYyhmcmVlLCBtcC0+
bV9nY19wcmVzc3VyZSwgMTAwKSB0byBhdm9pZCBvdmVyZmxvdy4NCj4gDQo+IEFsc28sIHRoaXMg
aXMgcmVhbGx5IGEgZnJlZSBzcGFjZSB0aHJlc2hvbGQsIG5vdCBhIGR5bmFtaWMNCj4gInByZXNz
dXJlIiBtZWFzdXJlbWVudC4uLg0KPiANCg0KWWVhaCwgbmFtaW5nIGlzIGhhcmQuIEkgY2FuJ3Qg
Y29tZSB1cCB3aXRoIGEgYmV0dGVyIG5hbWUgb2ZmDQp0aGUgYmF0LCBidXQgSSdsbCBnaXZlIGl0
IHNvbWUgdGhvdWdodC4NCg0KVGhhbmtzLA0KSGFucw0K
