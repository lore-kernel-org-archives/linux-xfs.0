Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012002.outbound.protection.outlook.com [52.101.53.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D657946C;
	Tue,  9 Dec 2025 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765303161; cv=fail; b=tZkH9elsL8S3xWIbVunM1yc1KdCWSnG14odMHhBmuV9IXDSS3rIIe5Oq9T2kqcGGcRjuX4cYUuMi6ByCreU52WMXugWTqbJZuxwSZPruoL0r8YK+h5C2RjqjqKpKFkaZE5RJc7UVJCcVxMAyceEZna5uK9fJzcQXmF3LKY++nDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765303161; c=relaxed/simple;
	bh=8udvs7+97sBSoQenymTF6uT5NcKJ+NTi8oSLOC/Gmb4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fdEgXWNStLaSIm32O8NL2lz6TgBH6SVddNr73QzHdHxmtHug8OmntwvK1ujr5tQ7mhFoGUpbe1llnxds0PwjsESxEgs7Fl/PVADhCZEuuWYikbUqbqp1xcF3zmzoo9ShBXjRYtEH9FFaGarCgouxNK9+IaUJrDeHMW1yiYrMmw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nyB/lU3/; arc=fail smtp.client-ip=52.101.53.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nyB/lU3/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pzB044K9vc60lhsOd25yS6+iUI+LZz9QKkKcGW32xdA1YWZB9vdsvxo65jqecmGQW+cjxlbS8jF8tRAe8/JvREksePUmQwGv0aA4P6Q6s7jePjA/unYzkjHAkID7IsgNZsLXaldaLflYDRix3OFxBnyMg1weoo/LCQE475jziOuZnwn5iW3ow69O+Pq2/YAxMcgU+pdbzjdLhrqV9RIcqZt+1gXcm5uB0OLp/aOu5ejtZhLOCtN6dquVCBLGeWQl9Pqv493p+CbEZCg6T7fsHMXAKJ+av+DOHHYUF5GQKsq8mqpjW5//f1hqgD6EV/GP6KIhfuZ49Jt/ZIHNc1/4PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8udvs7+97sBSoQenymTF6uT5NcKJ+NTi8oSLOC/Gmb4=;
 b=PmiTZxJSTQ9+civ7Imaa4rlyazyFaLxeYWLljNgTzgA+c3MHt47r03yCOmqsP0BwSAQ+QXOR2Gc2lyKtm2PiaLOZjiEbvbMnp9oZ1NQq/HXNzAAfWPah9s3PSApfsu562xDPbUXd1RjC9HtuIbX0kRxIrnUUBu7Ri+p0322VjypyFk2cvdunJdFXv8NS0uIoGS9fjwyH7zs7eIqaKKMmdqEw3ILobC4yxviCfQ4OdCJaixE+gapCcdVgWOu9CkAs+NNHwx8PXMkfb8MwUIVeZWxSMiOJ4+qsNDwIT1hLJSKw48B9p8T6ixa5pERc0PGpIGE+xWf0DsBfLH45kv0XKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8udvs7+97sBSoQenymTF6uT5NcKJ+NTi8oSLOC/Gmb4=;
 b=nyB/lU3/LttYDR6aDuePJ9uozObFLH38aJD2TgFNHcWbrR2b3UUgisI2UWXTSCbmGOtQ56Le9wzp0tITuSooLa8zLrtFm5ZVuxVfiiI+tmABVL67KB4RexGGnr3LiSz+t0szYUpWVKmtKWjVVWCvBqcqurtAsVnfmXpNKd6Z1NTxQIU96E6qDOfhyz+S0YqMLyfVDjr+qcUh/vJx0KNCzvnVz+SHu6D/O433nT3fKiJCVZi6I92ZmxI9eD6NXZ+ExnDGYvBjZ1gVhRasbUF+S9MfxbyfHlmWS1sLfueG1nuFDRpNPHeA87Xl0vLb1GIWB97XqjX4bnslPvWamAAszw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by IA0PR12MB8747.namprd12.prod.outlook.com (2603:10b6:208:48b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 17:59:13 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 17:59:13 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
CC: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Will Deacon
	<will@kernel.org>, Carlos Maiolino <cem@kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Sebastian Ott <sebott@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
Thread-Topic: WARNING: drivers/iommu/io-pgtable-arm.c:639
Thread-Index: AQHcaQFVH3CUuaIhmEu/T0GQ8kjfQrUZMfcAgABerYCAAAFnAIAABv+A
Date: Tue, 9 Dec 2025 17:59:13 +0000
Message-ID: <35d68746-63e8-48f2-b4e3-045354a5934a@nvidia.com>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
 <4386e0f7-9e45-41d2-8236-7133d6d00610@arm.com>
 <d1d76dcb-5241-4290-ae69-7d20e4461b9b@nvidia.com>
 <3451a93a-e4d5-4017-b4e3-e58fae3751f8@arm.com>
In-Reply-To: <3451a93a-e4d5-4017-b4e3-e58fae3751f8@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|IA0PR12MB8747:EE_
x-ms-office365-filtering-correlation-id: 56af5625-9001-4e96-937f-08de374ca98c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?dmNhMXl3SUhkbmRoam5OdE96N0xSQW5pNHU4ZDE1ekcvNmJWdytHSi9sTTZt?=
 =?utf-8?B?RlJZc0dxVG4yR1I1eGh0cmpnZEtDY090YzZ5OHJHRU1mS05tRisxanFkdEJi?=
 =?utf-8?B?bzQvS0VmaEpmWXRYYmg1azYyK1E5alpJL3UzQ21qelV0MVovYU9VbTJycUQ3?=
 =?utf-8?B?UjU4dzd6UHV4VlAzd0xyM3dBZ1BXd2JFTXBsRnVXVXlkQWR6MUVIOWNxOGdM?=
 =?utf-8?B?bEF3TEtuK1kwUWVrcWc3Uy8zY1NNWmR0SlRyNWtGTmc2ODR6R0ZjNnc0ZUFq?=
 =?utf-8?B?bkdFc0xyS0dQa29najJCYUVwK0oycmgxdjIyL29UaHFVTGlvcjBNSE5qeGVO?=
 =?utf-8?B?bTZFczZoNFpseVNabGdlSFlRMW83cE5ZVWVZcEJoMVZHMFVTdEtmNW5jZENJ?=
 =?utf-8?B?enpRREJvaTJrU2tQcC9YdFVBdUlHbzBWQVB2cnBKQStmSW9KS2hrdWV6RWpz?=
 =?utf-8?B?Ty9YWWt0QjFmL3d1YUZBdWp1RzFyRDRqMzJ3bnUzVXJCUEZwN3BXMlhwYmFZ?=
 =?utf-8?B?NkJDaSs2SjRuMUJ3RUd3YnhpbitvTXovK29hdlpJOUR2bkpPVnQ4ZzY1cEZS?=
 =?utf-8?B?UFFFbUZSQy9XMEJ1S05oQWZBQUxTWHVtQ0JLR0RVMWp1TGI4TlB1MXhVMTZW?=
 =?utf-8?B?Si9xQVE2U014QXY3TzBab0Zva0JqWVE2Mm82T2RpM0VWbXBvNGdiVEJwRFN4?=
 =?utf-8?B?R0lvN0krQXd5VEJpQVB4Nkd4YWx4SWdWanRnaVJuMGpkUTVDNVc0ZHRZVVRu?=
 =?utf-8?B?ekpUZG9jNTB1WWhDdGUvRkJ5NjE1bVlpQ0JwTzh5aVordFhldTMrTWd5dzd4?=
 =?utf-8?B?QWpKaE5lV3RmR25GemltS2M2bU8rWUN0OHdVZjNLZTl5OXBjejMxRVE0eTEy?=
 =?utf-8?B?Yk42aHdMaFVXdGxUc29JRVBROVJ6S0FTNzhzUktjQkJZV0pWTzN6bzlwajV4?=
 =?utf-8?B?Y2hRbmxXUjJFSUJyU0h6aE1tUkdZT1FHaWprMUx0anNwYWY3L0czd0Y2TGZj?=
 =?utf-8?B?NmFtTXhHUHlEbkZHSmFUR0dZeXhRQ29BZ29jYktzeGNWMjhMVVJJY1g4VkxV?=
 =?utf-8?B?MHVrY25ySjBuVTlUMU8xTmtMMWtCd1krb3Y5N3g2ZEFQSStkOGtOSnd4cm81?=
 =?utf-8?B?NlRyS0srQW9iK2NwL25QbWR4ZktNNGpXczFKWXBWSTUydXA1Tm04ZnZFMTN0?=
 =?utf-8?B?dnYyMXh3d1NQM2wwcjNVRnQxVEdZVnRaZjNiNTc4RHZqY21MdWMybEJaZzdC?=
 =?utf-8?B?N2xVNWp2MmZBK0dtdnZ1TDM3TzRUZzd3d3Uzc2NOVW9IeEo4MjRjWUZTVFQr?=
 =?utf-8?B?eFYxOXVoZk16b0xIekE3QkpnQnRlZ0x6TGFPZWdhWE1EelJqdlFHSytIS25S?=
 =?utf-8?B?NFM4dmQvVzdJMHRoc2lWODg3MEFhalRIYzhYVkpLUndIaGxheHZaSEpHaGlM?=
 =?utf-8?B?bDluVHc0ajZhWHBQSEo2bVRGZ3hKWHFvZFZCU3A3SFJkYTRzWmlFQm4zSitk?=
 =?utf-8?B?RGt0R0VSUWhkVUNsdGFUQ0ZPdDU0VXBPNmllY1BCZ2w4S2hsSm53T21lNUJD?=
 =?utf-8?B?bU13ODBUSkNrLzZwaDVubDQ5WTZLNG5CRmFnY2Y5UlliWXVDRitvVjhwU24x?=
 =?utf-8?B?MGlZQkprcmhjM0lROExDcUdHc3ZZZzZETWlvNjgweTJ1SFdnZVNMbjNZRVZF?=
 =?utf-8?B?SlR0dkRudU5BYW5tUFlkVitXRG9kOHpiOTNwRWRSOWhtV2tPbDF0N05xR01a?=
 =?utf-8?B?VC95WlhDaWV5ZWROL3VZSHdlTFR5V2xzQUdWcWtqeGQxVmdHcFE0Y0ZYY0pi?=
 =?utf-8?B?emtyMjhHelBnQ1ByYmZJWW1Dem1ZSW9nZ3FOWUpUWnFHekFiSGx5RVFBa3hL?=
 =?utf-8?B?d3R0SlYxc25uMWhJM3VacUZNM3Nyb09Mb0wwZzVoRHYrNm5lc29ZQndRc1Nz?=
 =?utf-8?B?czVRbEF2VXNzMGFmNUxDMnFYZVpka21lekJ5bXZiMUJpbEtVYXg2clRINWRI?=
 =?utf-8?B?T2RPY2xETkR4ajlRUnJ3OEk2L1ViMkxLTXRJS3Q0SnVyMGZTakdMZkMxdjg3?=
 =?utf-8?Q?f2GzYe?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z1VlSFRJdS8zTGozSU1xOTRqYkloL3htWElLSCtOYVJYWnJlN211QVVYajgx?=
 =?utf-8?B?bmVhRE94bXIzUzVFOCsyUkxzK3hQR2d3cGhTVitWSTgzUjQyOGxTK2lnVHhv?=
 =?utf-8?B?UVVjS1ltSEZMQnRHY0ZWZlVJYU5paWlPYkpUZzFlcDRyT3VLbXV4QXU1eWxt?=
 =?utf-8?B?bUh2T2xwZGI4UlRMNGJ6WFVsV2t1SGlpZzhXYzIxamdaQk1taWNJNVlBS2xZ?=
 =?utf-8?B?dmpxSi9zT0F5QjBMU05VaGZmRmh0Snlmak5QSk5IdDExUWlwa05iR1prYWpI?=
 =?utf-8?B?cXhPQ3EySTdkd2lBOUM1aUhraXVzOHZ0dGhPWEJsTklKUk9SMHpyN0tFZitP?=
 =?utf-8?B?c0hRWmNuQ1NZSVZBUmtWdkhxakNBeUJqaEZFS3ZZWlZOdUdLSGlPWUtFTFpT?=
 =?utf-8?B?ZGpHdzZqQndTcmlWbUoxWnMyb05SaklFQ1IxRmU3ckZmdllVdEFlSnlMcDl5?=
 =?utf-8?B?eS93SytkUVZ2ajd1OHcxaEdGOE1wTnZ5OWxKbWo2QXpkQWRaejVoKzRzWmNt?=
 =?utf-8?B?UmdFNG8vNW5zMDBqaWNuUHVOei9hUjFqZEM1VTBJY1dRRkdQcXpqemR6UnNS?=
 =?utf-8?B?M2UxcWFFZ092RFgxR3pVcmxNNnVSZXFtbERXVmdHZzZMK3g3NStLellQMkN4?=
 =?utf-8?B?eDQ2NUlGVGdQOU5sU2Q3aFNEK3pOemVBNS84TStsUy9idERaWUFZRUl3NGdo?=
 =?utf-8?B?cm1ocWxmRm1FU29mWS9mVFFML1l0Y1BtWitrQ05ONS9uWFRIQVpVanBYQTBH?=
 =?utf-8?B?MFZZQnBVYW1jamJYQTFsK3d2bWM1ZHZSYTIwOXVoZzRzdlpudnhBTkVuN3o2?=
 =?utf-8?B?Ymk5UlFxb05ncU4yeUhCbWprRitMYmxHcTN1eTNzbkZsZmlvVitEZk9lY0hH?=
 =?utf-8?B?OS9oYW9vSEczTy9YeDJ0Wnc4dlg5ZjVBdk1YclluZ1NrSXpEUkdmamJZalVa?=
 =?utf-8?B?S1REQVAzOVhsY2dLRThWV3Q4Y0JJWEhSSFJDa2Y2OGpWa3BINW1BRHRYVmJT?=
 =?utf-8?B?bCtQNG5OYlJab2JxZU81TDVzczd6S3lyaU5qV2VmRzMvR1U5K0RHc0tXMWVZ?=
 =?utf-8?B?MFVucG5mMHRFaWN6MTlUR1g0RFFNcE9SdG81Zm0wQU5BVjFvQlRvaGxJQU42?=
 =?utf-8?B?UjNwbURYRmRKRmc0Z1JVYzhUU3pmcjFnUk9EQkpkdUs5OUFzS2xCcmVzdmg5?=
 =?utf-8?B?a0JaNkRDaUpjdjlXbDFKa1dNLzVTWW43alFJQ2dpWFFSaXFlcEFRL0JuWmg3?=
 =?utf-8?B?QXVLaElYQ2Q2YUZuRlZuL0RXdVNLVGpFakFlK3o5NkJIdHNmWjlGN1ZHaUZ4?=
 =?utf-8?B?SmZmWmUwRXNEZ01FY0RIYitLRnlGMUhUOVZ0ZWh2ZlY1Zkh5NUJrbHZlMytY?=
 =?utf-8?B?bTBJTHlVSjNWSmpIWEk1aVBISFgya1BDZ1EveUtKaGtvTUVycmlwSmQ1RWN5?=
 =?utf-8?B?VDF5RC9jRVNlSm1MZm95SVNoeUFGYWI2Zkd0Z1NkVWtXa2FubEdjYlJKTm9Y?=
 =?utf-8?B?Wk05eFF0b0VUUmE0Vk9IRVMvK2NKNHd6V1VVdjNpTXYrZU84UUVIN01PRUdK?=
 =?utf-8?B?ZmxvT3Vub1BJT1lWeDlHOW15RjFxUks3dlVSdTFNZGdKR1BLTDFSYkQvcGov?=
 =?utf-8?B?a2lWQmNqbklIRnlLZ1RpRHhzMXBWcjFzUnNlTDRySjA3T09ldW1sS0Z4Wi95?=
 =?utf-8?B?U3dwK3dkR2FnOWI1TzA2MUlXKzJlRW50ZGk3SGU3cGJienk0QVVSMmZSWHRx?=
 =?utf-8?B?cVNQeFpENTVqekRFeVgwYmF5MWVPUGorVk1RUll6bWlRRUh4SVc0akEvTGRx?=
 =?utf-8?B?bTVKUS94V0s1eEtwQkRINXA2SEE3dHZIaFFHRHQwZUNMNnNJMG5EdXY0dVhQ?=
 =?utf-8?B?Vis5UTg3STdDNzk2MmFja2Q2eUhMaGtwalZPQUJ2bGQ3TEIzMnR6OE1FWVNk?=
 =?utf-8?B?YmdXZnpmSWxhOXdFZmNvZDdyNEgzSFpIaXkxZTc4azNoaUlBdHF2THZNZGw2?=
 =?utf-8?B?b0FNV0VlU0pwbWJVdlpnbUMyS2VFT2tSNkFuV1pHKzlzb1Z6SzFkNzU3eHU3?=
 =?utf-8?B?TlJVOVNpUkR2WkZPdlNlTExTU09Jc1dybi9ISEVic3pZMlBvemZvU2RZOGwv?=
 =?utf-8?B?T2txZ0ZQQ2J6OU9MV05pTWoxeWxpVmJFa1B0MjlmQWpXT05pcDc1MGQ2K2Zt?=
 =?utf-8?Q?YiLKVwuLqdPSIAlwZWzg7kg+pXhwkQCcjOSYrSvR+PgE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8C6749CB627BF468E94E31FB3F2CCF4@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56af5625-9001-4e96-937f-08de374ca98c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2025 17:59:13.4222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HH9dMZqKRs/v8OljLL9aOTkaeQLzf22DXB9+S3WWPXYrE+cv7m1JUkOuq5BRLcR0Z+Qc2ZUTVsLKa7owjjcDEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8747

T24gMTIvOS8yNSAwOTozNCwgUm9iaW4gTXVycGh5IHdyb3RlOg0KPiBPbiAyMDI1LTEyLTA5IDU6
MjkgcG0sIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToNCj4+IE9uIDEyLzkvMjUgMDM6NTAsIFJv
YmluIE11cnBoeSB3cm90ZToNCj4+PiBPbiAyMDI1LTEyLTA5IDExOjQzIGFtLCBTZWJhc3RpYW4g
T3R0IHdyb3RlOg0KPj4+PiBIaSwNCj4+Pj4NCj4+Pj4gZ290IHRoZSBmb2xsb3dpbmcgd2Fybmlu
ZyBhZnRlciBhIGtlcm5lbCB1cGRhdGUgb24gVGh1cnN0ZGF5LCBsZWFkaW5nDQo+Pj4+IHRvIGEN
Cj4+Pj4gcGFuaWMgYW5kIGZzIGNvcnJ1cHRpb24uIEkgZGlkbid0IGNhcHR1cmUgdGhlIGZpcnN0
IHdhcm5pbmcgYnV0IEknbQ0KPj4+PiBwcmV0dHkNCj4+Pj4gc3VyZSBpdCB3YXMgdGhlIHNhbWUu
IEl0J3MgcmVwcm9kdWNpYmxlIGJ1dCBJIGRpZG4ndCBiaXNlY3Qgc2luY2UgaXQNCj4+Pj4gYm9y
a2VkIG15IGZzLiBUaGUgb25seSBoaW50IEkgY2FuIGdpdmUgaXMgdGhhdCB2Ni4xOCB3b3JrZWQu
IElzIHRoaXMgYQ0KPj4+PiBrbm93biBpc3N1ZT8gQW55dGhpbmcgSSBzaG91bGQgdHJ5Pw0KPj4+
DQo+Pj4gbnZtZV91bm1hcF9kYXRhKCkgaXMgYXR0ZW1wdGluZyB0byB1bm1hcCBhbiBJT1ZBIHRo
YXQgd2FzIG5ldmVyDQo+Pj4gbWFwcGVkLCBvciBoYXMgYWxyZWFkeSBiZWVuIHVubWFwcGVkIGJ5
IHNvbWVvbmUgZWxzZS4gVGhhdCdzIGEgdXNhZ2UgDQo+Pj4gYnVnLg0KPj4+DQo+Pj4gVGhhbmtz
LA0KPj4+IFJvYmluLg0KPj4NCj4+IEFua2l0IEEuIGFsc28gcmVwb3J0ZWQgdGhpcy4NCj4+DQo+
PiBBcGFydCBmcm9tIHVubWFwcGluZywgYnkgYW55IGNoYW5jZSBkbyB3ZSBuZWVkIHRoaXMgPw0K
Pj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2lvLXBndGFibGUtYXJtLmMgDQo+PiBi
L2RyaXZlcnMvaW9tbXUvaW8tcGd0YWJsZS1hcm0uYw0KPj4gaW5kZXggZTY2MjYwMDRiMzIzLi4w
NWQ2M2ZlOTJlNDMgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL2lvbW11L2lvLXBndGFibGUtYXJt
LmMNCj4+ICsrKyBiL2RyaXZlcnMvaW9tbXUvaW8tcGd0YWJsZS1hcm0uYw0KPj4gQEAgLTYzNyw3
ICs2MzcsNyBAQCBzdGF0aWMgc2l6ZV90IF9fYXJtX2xwYWVfdW5tYXAoc3RydWN0IA0KPj4gYXJt
X2xwYWVfaW9fcGd0YWJsZSAqZGF0YSwNCj4+IMKgwqDCoMKgwqDCoCBwdGUgPSBSRUFEX09OQ0Uo
KnB0ZXApOw0KPj4gwqDCoMKgwqDCoMKgIGlmICghcHRlKSB7DQo+PiDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBXQVJOX09OKCEoZGF0YS0+aW9wLmNmZy5xdWlya3MgJiBJT19QR1RBQkxFX1FVSVJLX05P
X1dBUk4pKTsNCj4+IC3CoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVOT0VOVDsNCj4+ICvCoMKgwqDC
oMKgwqDCoCByZXR1cm4gMDsNCj4+IMKgwqDCoMKgwqDCoCB9DQo+PiDCoMKgIMKgwqDCoMKgwqDC
oCAvKiBJZiB0aGUgc2l6ZSBtYXRjaGVzIHRoaXMgbGV2ZWwsIHdlJ3JlIGluIHRoZSByaWdodCBw
bGFjZSAqLw0KPg0KPiBPaCwgaW5kZWVkIC0gSSBhbHNvIGhhcHBlbmVkIHRvIG5vdGljZSB0aGF0
IHRoZSBvdGhlciB3ZWVrIGFuZCB3YXMgDQo+IGludGVuZGluZyB0byB3cml0ZSB1cCBhIGZpeCwg
YnV0IGFwcGFyZW50bHkgSSBjb21wbGV0ZWx5IGZvcmdvdCBhYm91dCANCj4gaXQgYWxyZWFkeSA6
KA0KPg0KPiBJZiB5b3UncmUgaGFwcHkgdG8gd3JpdGUgdGhhdCB1cCBhbmQgc2VuZCBhIHByb3Bl
ciBwYXRjaCwgcGxlYXNlIGRvIC0gDQo+IG90aGVyd2lzZSBJJ2xsIHRyeSB0byBnZXQgaXQgZG9u
ZSBiZWZvcmUgSSBmb3JnZXQgYWdhaW4uLi4NCj4NCj4gVGhhbmtzLA0KPiBSb2Jpbi4NCg0Kc291
bmRzIGdvb2QsIEknbGwgc2VuZCBhIHBhdGNoIGFuZCBjb250aW51ZSBkZWJ1Z2dpbmcgdGhlDQpw
cm9ibGVtIGZ1cnRoZXIuDQoNCi1jaw0KDQoNCg==
