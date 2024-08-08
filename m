Received: from esa20.fujitsucc.c3s2.iphmx.com (esa20.fujitsucc.c3s2.iphmx.com [216.71.158.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1211818950C;
	Thu,  8 Aug 2024 08:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.158.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723106368; cv=fail; b=cGXDpjaX10b2ifUdQ956U4srcYNd73hn9bZIJAgCpV4eY4P9xEvWqu5MIg/rLSgMGtWh+XyJ/qT0QRuo7jjd5X1/jByDVRyjdS01RseYQRao+01HqreETBlivV1fMj2qwHDQ/fTRb1fnKs55EbrUDxVW5DuAAIqGe1m42of7HPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723106368; c=relaxed/simple;
	bh=Fx6MtP7xbId9593nG7XCBlXE4IVn67IMKQrhXPTLjxE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ewc+iOZASvQqTH1XdCGlYJQDejcTL6TMScnlQOI2dqw8Kz56BfJegvu+SR3sABkd3W4SJ4dSpC7b88rAjet2+6U5YweMAuioX1VoJcocRa6xjc3Mljw6inqBcGU5npkuTDh9uBYtvxwrUwOpzAM89Q4t9H8Xc6vE4nuQ+daHGBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=W+TPuBfL; arc=fail smtp.client-ip=216.71.158.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="W+TPuBfL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1723106365; x=1754642365;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fx6MtP7xbId9593nG7XCBlXE4IVn67IMKQrhXPTLjxE=;
  b=W+TPuBfL4vQxdN1yNODjsTwolDCSgqlnVGL9/aYSGU2nHzWxcQO/akT0
   a9Ak3+6T2YqcEu4Svl3FBTulfcgazKHOEWGZscX0vYOxgDh71M9M6//Na
   wWFWhdpwCkxN2KkfZqYJY71xWIfQL3Zo23GKHo8ShZLKSxtDntD90jHQV
   oa4CLC5pqnl1ysvsNDDfutvL4AtLqJgbYiD6oYPhRpPGPWvOK360LZfOb
   PcN3SxHmMy+LqyZKfMSrxxEqhHciYJaPp6uqjK+ci5QjGTLmjXNA9Y2mC
   xaoymWOxA9mqcKc2FF4g1uWX9JBKm0XTLN8idzkOUfesoq7T7AxGJxPnN
   w==;
X-CSE-ConnectionGUID: pdWN3n+2TUin1/prX/jj/A==
X-CSE-MsgGUID: tLG3WreFQS+xGKbdVWUHEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="127408230"
X-IronPort-AV: E=Sophos;i="6.09,272,1716217200"; 
   d="scan'208";a="127408230"
Received: from mail-japanwestazlp17010005.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([40.93.130.5])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 17:39:15 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I4H7hiLIx4T3uM/YQhZHUXnqiC9BSsIL+nqjIi0ocN3+ZN8m5OBk5AqbHeUh+yJ/3sj8YMoA2n/zzVSUzXSXzl4upyqHLKLFjPd92B+mSxsDj8u3nl02eBRWKUNXdmSVDgu2WcnwkBaSmbQZsRoTC5N5gVli3oF1SsojUIRSWWm6oIeDl9pNdu8SLjnUz//7DGg/D3RNaJw1T2FHckIxWOwqTwHGUI7YeYCzSfZU8Z324TJtc+LN+p8D2YIbS3QBVO/A9JO8nFwvarMUI67JAIdfxI820i4J2OiD6oaz8P6N5/kfIVCqqU39ny9YRO1WLKzPUwOVxdm7LrF4efBUeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fx6MtP7xbId9593nG7XCBlXE4IVn67IMKQrhXPTLjxE=;
 b=DwUfXEdXfY5GXfCRwfPhxM+yOCEjAl+WqBQ7tSdgPyViyTbM2Y6J0avaBHbDNbef3Ip2QGyRalrMDBJTHDru/y8liWNIMi9MfLrxyZVjbb//1n+6F3GaqjS1hrSwpZm3lTtBGGpetbJftXcVuNCo1ITMV24WD9yLf7K5rtjtKUphWy6BZjFpNY1Fh3K/D1Wy1B2J+hYT1Bc6Vfn31cnQHTMaeqdAVXMPXFq6dUm/tBB1lV9LCd9k0RUuMMBGYQhAJDLNARwHxnmQyFAt/McoPRj2/PauK9F/2OyEWBXoA1btD6IhHHK/tapXESsXYoXDhq0P4IZ5reJEovC5K6CoMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY3PR01MB12071.jpnprd01.prod.outlook.com
 (2603:1096:400:3cc::12) by TY3PR01MB11721.jpnprd01.prod.outlook.com
 (2603:1096:400:376::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.25; Thu, 8 Aug
 2024 08:39:10 +0000
Received: from TY3PR01MB12071.jpnprd01.prod.outlook.com
 ([fe80::479:9f00:f244:9b9]) by TY3PR01MB12071.jpnprd01.prod.outlook.com
 ([fe80::479:9f00:f244:9b9%5]) with mapi id 15.20.7849.013; Thu, 8 Aug 2024
 08:39:10 +0000
From: "Xinjian Ma (Fujitsu)" <maxj.fnst@fujitsu.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Zorro Lang <zlang@redhat.com>
CC: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: RE: [PATCH] [PATCH] xfs/348: add _fixed_by tag
Thread-Topic: [PATCH] [PATCH] xfs/348: add _fixed_by tag
Thread-Index: AQHa4lW9OsfX98L4XkSKvoN54kZuobIPWjuAgArng4CAADEFAIACnqqg
Date: Thu, 8 Aug 2024 08:39:10 +0000
Message-ID:
 <TY3PR01MB12071F457962A3AD2B50C878BE8B92@TY3PR01MB12071.jpnprd01.prod.outlook.com>
References: <20240730075653.3473323-1-maxj.fnst@fujitsu.com>
 <20240730144751.GB6337@frogsfrogsfrogs>
 <20240806131903.h7ym2ktrzqjcqlzj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240806161430.GA623922@frogsfrogsfrogs>
In-Reply-To: <20240806161430.GA623922@frogsfrogsfrogs>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5Njgw?=
 =?utf-8?B?MmZfQWN0aW9uSWQ9YWViYzBhZWUtOGY1Yy00YjI1LWFhNTQtZjg2NjBhZTc3?=
 =?utf-8?B?NjdhO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMz?=
 =?utf-8?B?OTY4MDJmX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQx?=
 =?utf-8?B?LTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX01ldGhv?=
 =?utf-8?B?ZD1Qcml2aWxlZ2VkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFk?=
 =?utf-8?B?NTUtNDZkZTMzOTY4MDJmX05hbWU9RlVKSVRTVS1QVUJMSUPigIs7TVNJUF9M?=
 =?utf-8?B?YWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfU2V0?=
 =?utf-8?B?RGF0ZT0yMDI0LTA4LTA4VDA4OjE1OjEzWjtNU0lQX0xhYmVsXzFlOTJlZjcz?=
 =?utf-8?B?LTBhZDEtNDBjNS1hZDU1LTQ2ZGUzMzk2ODAyZl9TaXRlSWQ9YTE5ZjEyMWQt?=
 =?utf-8?Q?81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB12071:EE_|TY3PR01MB11721:EE_
x-ms-office365-filtering-correlation-id: 83268ce1-f137-4fea-f528-08dcb7859303
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?SldKMG8wdUIybjBQRFBIMTVEd1NVM0taWVZJQTlUMUR5cmZWWkF3bDh5NHd2?=
 =?utf-8?B?SC9QdFF3VkVSQVZKUlR3VnhYWTFOZ0RmVHhKczg4UEgrTVE1QWNRc1kzUzQv?=
 =?utf-8?B?UTZSd0hCdDhUQkxKSHpoWVoyMENMQlM3K3d4RzhNVWZyVS8ydnFuTWJkMlFG?=
 =?utf-8?B?aWM1em8vTW9hNHFDd2hxSTVHaDczbFNxaUtLY1VYTWN6eXNkZmFuUXVOQ3Vq?=
 =?utf-8?B?aG1vbitoejNaMmZLeUNlVTgxeDA4dm0xaSsrRGN6aldIcVJqUEJTa1dqSkZm?=
 =?utf-8?B?Z24zeHROdG9BcGhXMnBiMDdraEdLai9vcHRmaDBEUEJmZnMvQzFUWVZxc3NL?=
 =?utf-8?B?eHozZUw4bVhmM1ZoWnNiYXJjVTU4NjBOMmZaNGpzclQwdEk5VkE3NG1OSG1C?=
 =?utf-8?B?VXhRMGdyVlpFTkRkYW9ENURCd1BOM3Q0K1EzODVDTTRxRlhmMWRYVXlRRDE4?=
 =?utf-8?B?R2pXYnFrdjlhTUJ4YmtjcmR2T242LzRES0YyOXdCMWNCZDJ3d2N1em5hbTE4?=
 =?utf-8?B?d1E5NEpGRkFIeG85WmdzaUNtQ2toZVBsTVRMSjZzTThuTFpab3dHc2MyN2o4?=
 =?utf-8?B?MGp0QlRBeitPRjZZQXJpYW9iTENTNWNienBGSU0vaFZqbkNZSkRuY011KzBT?=
 =?utf-8?B?bDVuYy9NeXd3dEFBbEdqU3RWV1JaY2lkVS9RWjhNT1htWlJScXRrWTBoY0dq?=
 =?utf-8?B?MFZlTnprOFhxVDhIZ0wrQ29QcWJFTkthbFlRMkJwMis4SlA3aTh2cDAxSVh6?=
 =?utf-8?B?dWhzV1JnaTVyV0p5bjZxVmFxWVZ6aXYrVnUvdG84YitFMTBabllRNWk3NTUy?=
 =?utf-8?B?U2M1ZlpMeTUzNGYvRG9jV1pmTlZYT1lWanMzR2dwbVkvSElTL2ZaY3ZKUGhS?=
 =?utf-8?B?eHFLcXZJR0M4cnFpajl0S1I0bDJoMzZVVElZRWRrSzdiYllkZ3ZiYUtud0k0?=
 =?utf-8?B?Q2VVeFBrU2N5MFYxZXd0amprbFEwcnAwUEpiaTUzQUVTY1Q4dTcyZjRjNEo3?=
 =?utf-8?B?Qktrd253cW5XR3dpRjllVmJpNkd5NHBsV09hckNuaG1lRTNFa2g4ZEpmd3pP?=
 =?utf-8?B?aXRSYUtMYlFBWVp3aTJ2M1Mxd0JZNVlJWlNpaXJvb3dUV09zZm1RdzBrTnVP?=
 =?utf-8?B?QmVYNG04b05HR2dyZXVQb3lpTGprMHg4ME9RUTRvUUFVZ2VLYnRqUjlSUDZR?=
 =?utf-8?B?TlhIK1BGbFR3K0VxL1lJVm9qQlNpL0E2YjYvZ0hDZmN1Q214UURRMGhSMmM4?=
 =?utf-8?B?ODhoVGVjMUF2aUd0Z2V3SXY1QWVCbnlmN0xCcFpwNVRwYVFOM0YvM3NOMVhT?=
 =?utf-8?B?VlNucG01NzFvc1JXbHJHczg0a3lsS1hoUDZRYU1IQVBCaW8rTGprZ2o0MEY3?=
 =?utf-8?B?NDBGQjRtTHNRZmd4QmY5b3FPNEMyZ2xVTWE0eVlIcHJtT3U0MEdGdEdrRzNy?=
 =?utf-8?B?RDJHMTZlYWJIN1IxS1hkZVJNeXVMZVlLRkozZjhHMVU4NS9lYVppRjN5RERV?=
 =?utf-8?B?SFZXMXhHSUJRcVN6TnB6Y3RFenJmQmZXbXRYRnVYY1VrNWx2ZW9vWWRxS3VN?=
 =?utf-8?B?ZW1CSW9VcksrajVMZUtTenkrRTlFTlJGQlMvRmxzUHcyV051Z1ZQKzRpRnFy?=
 =?utf-8?B?ai9hZkZXODFPUE1ldmptejNmajlSd00wYkNOOHhPaTcvSEU2VkRtR0xKQ1ZB?=
 =?utf-8?B?azJmZVJmRmdBNHVaN2hWTGUrSTJ1U1I5OHQ2ZWpoREZaWGk1QWVDM1hobnZ0?=
 =?utf-8?B?OWNnWVU4TVJ3RkkwckdyY282Sld4N1FVV1g4OWRVcVpQSk92VW1BdzlxdTZ3?=
 =?utf-8?B?TUZ5Y3lhcVQzSlNTWUhpL0JTVjRXY0dObUNTb1R2dk9PaU56NnJwZVlObFhx?=
 =?utf-8?B?bDIxdms0VU80dklFQW02UTlLVlVXY3VTRzg5YmNhaDE5RTVjU1Y0Z2dUekRZ?=
 =?utf-8?Q?fRds8qNs5TI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB12071.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QnhoLzQ3Y1RNdGhoYXl4YVpqeHc1a3B0VkMyUnZZMzhCbzBKOTBWaGVhNDJ4?=
 =?utf-8?B?djBTUTFrNGc0SFZmR0wrbDdkNnV4bTFPOUVPNWhjSnFBc200UkgraGZJcExJ?=
 =?utf-8?B?dFczSkdiZ2toa1d1L01nRzJoeVNnZ2lzNEpXR3dtWmF5WE5ScEFBUHNFVFda?=
 =?utf-8?B?dU9GT2M4bXAvU1VDVXllRUs1ODYvWFlRRlc5MmI0QnQ0ZGRSTFAyYXlrM2Zz?=
 =?utf-8?B?RFZDRHIwNW5raGxocnVzWmxKTm9XR1UrcXpsMFNnV0hXY0t3MGU3QjlnUWht?=
 =?utf-8?B?M2Z0aFd3VU5mcGR0bTBVWGg2R05MVjg1eExTajBnUkpFbzZsZEdXNk1QVGU0?=
 =?utf-8?B?bXZGY0Q1ZmxoYnVrUW4xWEpNdStHUWhOSW1OMnFvNzNJNnIwbDdoTmJyditl?=
 =?utf-8?B?L2F6RU1na3VURHQyeVBxeGJ0VUNFZkpDdFcwNTBXL1BUQUdjTUsrK2JkQThN?=
 =?utf-8?B?dU1lWkFrbGJyQmE1UVE5SjFKUENBT3V1QUdXTlV1b3lFU1JEaDN4c0VjWWg5?=
 =?utf-8?B?WlBHeXc0eWJ1bnFkV1BSdk9vaTJjdnRUeEQzekczZjd3ZmU1aHZLVUE3Z3cr?=
 =?utf-8?B?MWVtUXBqZ2dGc0svTjVwUHlJSk1yc3hCaDNiZVVMQ0Z5T3lERmxrT2dpVEJu?=
 =?utf-8?B?SFhVVDFZekNNOFpiOUdWZ0VKWTVoQlErWXZlT1lCcEl2VFdiUTRPZlFYN2VC?=
 =?utf-8?B?cDk1dHRqNlRJOEVlU2hSZzBJOVYxdjlFcG91QTBwWEE4NGcyY2xZWGRHWUZz?=
 =?utf-8?B?b2d2WkxJSVBaNVRmd0hIU0NibVhhSWQ1bTBiN1hzNUM1YVNZMFdMYzdreHM1?=
 =?utf-8?B?ZmlicUt3a2hDVXFsSjY5K1Azcm5jSjVKWDE3K0JPK1dXRkkvNENHb3lhQVhZ?=
 =?utf-8?B?K0kxbFNUYXVIYlZoWGNFV1FWZHN0V0o4MmYxRVlvMzdoV1RyZVhQcS9VYXhI?=
 =?utf-8?B?dXRlTUxJZ2R2ZHZvNmpOaVhDdkx2K2l5SkprLzQxQW9IT2hPTzdSR3YrUndJ?=
 =?utf-8?B?NmNzdllPVGFjSFZvazZvUXU4OUR1OFZNNGd4TGRsK29pUlhwNHVlSHVPdHdq?=
 =?utf-8?B?Qy80bVFPSE00ZVRDRlYyOWVkRE5wdmF0ZHpHRlZtV0szZ0tUVVJvaG4xYTNl?=
 =?utf-8?B?UjNReTl3VFFNekVuMDVKcTF4NGw0OU1IRitGV3VvL2NJVmszZ0tGUE00aVU4?=
 =?utf-8?B?U01STFIyWlE1bmdJMmE3NlJUd0xHLzdoL1p1QmJMcU9Wc1d0S3BSeXppZjYr?=
 =?utf-8?B?NlRFdW0rOUw0TlhiOFdURWtMZ2p4a1c3K0puRWNld2hQRCttMkVBRFBXNXpT?=
 =?utf-8?B?ejgwcndDOTZVZ1BYS1FsNElQbjA0NUEyKytRTXpkUU16TlpvZ1VtZThTbDF2?=
 =?utf-8?B?WDEwdVpqZ3RTUzFkWkNPK1RkWkpNQ1cwVGYvaFpMblhzai85WG80VnhPa2ZD?=
 =?utf-8?B?SFdJZk1SZllFaUdhZkE0WUhuU0NLVWZua2I4eDI4V3dvMWNCeXVYT09tRkZM?=
 =?utf-8?B?RVp5Tks0NFlPcCs0bU1lSENKaUhRWnU5Sjd0Y3B5T2JxVm9acFZZQUl4S2Ni?=
 =?utf-8?B?UWNUMFJtNTNPWk4zaEFaSlA5SnFpMTlaRUpGbE1pUFNBK0RGZ1ZVd1M1dWJH?=
 =?utf-8?B?OGVPNzgwOVN4Z1pHNlVHdndGa0txRlhDdlZhOFZveU9HZ0ZIT0FoNWtCWlI2?=
 =?utf-8?B?ZmZINWxxMzhnK25PTWVhTGdHUHlFMFZHQ1pMZ1BHaHVuNWdLdmlUR1pEK2R2?=
 =?utf-8?B?OEZVTDc5d1VCZEtmVVE2YW40SFB0SURqQ0RyQ09vYmtWWVNLUU1IMWUrd0xP?=
 =?utf-8?B?VytiZlVYcGhUWjVRNkJ1RkFCZnE5Q0hpTXpTWnRRYnJjcVczTTVvcFpTcHNG?=
 =?utf-8?B?ZTY4M1Nrb1AzNXNPcklOajBvRVRHejZtc0J5dnlraHFRMkJKVjIrSDUwSnFx?=
 =?utf-8?B?c0xOWmtuYW55V0lVNmtWSXFlTWJZSmVCY0xKQm1yak92a21SRWFYR2dldnlp?=
 =?utf-8?B?TVVROG10VVBNRFplV0xZMExHTm4zRXkyKy9xaGJ3ck9LOGVMK2pQNHV2aUVJ?=
 =?utf-8?B?dVdqS2FhaXZtYlVGRGpIUHhtcmtwU3FyUFoyUkZjbWpCbDJJbUlUWmF0VFpu?=
 =?utf-8?Q?ykQWcd3wOofPHOcZamNlBNesB?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/+l/nRom3y/OJViZeoXej1eBtRVTgYzDob+ji1+o41Bkz4Q2r3lW59ABzetNfxdRfj1NkvlXjkprQSDBAxpKuCsK5VjOIKmiZekjd4WkUqKG/w7gAmZCkNiNWpXXa3Mcy8krxatFnF7z1yOeITPf7oi4vBOpDqssJEV/2An9VYwKQM1XIRa3tXtil9tdjpiQcosVftPkDo2QYtdiQDsrhhcllkVM8y//TC+k+PAwlkoQt6ehKsPB2Mn4QOCXy9PIadI8gc1Ih2PQsXa5+9HNRPrvFbolmxMy0O12D4U9CSUQHOMSpb3sJcFcNDV9FUHgvzAuFGpeXnlAeY9ZuEkY5eb3PP3GKG53gNyQLzP9Flj/MhX/ceLqq4mxPiTin+sDaN7UF/vCUdp0cvN83ItxLaP77v7IlzC4wBIWGEo32faQTkGRDeOO4cICSiMfcaD2QLsAxGlKvXX20WqUesRbAy0YqLRtJEDiKo0RqxMTtyDGDc7ZVl9VNdmpL/PHNdyPeFsqJZgtA6RyzAKvQJCnzO/UbDoj5nAmxv8stmXdzEAJGFbC/p76rFPSM0FjSusiUjJK2LOlPlq/8e3/W74Vt8xtIJVV8BhVAFqZHbGcVXnoYSOUKwUOoMl/0rKZsMbO
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB12071.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83268ce1-f137-4fea-f528-08dcb7859303
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2024 08:39:10.4315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SywM3xXjgo8hj8l4O8D9ZnT1y45E2098RxVpUby5SxyyjHCZdhPgUdErsE8M1eO2Mmx68gXM/OURthwEmRTfKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB11721

PiBPbiBUdWUsIEF1ZyAwNiwgMjAyNCBhdCAwOToxOTowM1BNICswODAwLCBab3JybyBMYW5nIHdy
b3RlOg0KPiA+IE9uIFR1ZSwgSnVsIDMwLCAyMDI0IGF0IDA3OjQ3OjUxQU0gLTA3MDAsIERhcnJp
Y2sgSi4gV29uZyB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgSnVsIDMwLCAyMDI0IGF0IDAzOjU2OjUz
UE0gKzA4MDAsIE1hIFhpbmppYW4gd3JvdGU6DQo+ID4gPiA+IFRoaXMgdGVzdCByZXF1aXJlcyBh
IGtlcm5lbCBwYXRjaCBzaW5jZSAzYmY5NjNhNmM2ICgieGZzLzM0ODoNCj4gPiA+ID4gcGFydGlh
bGx5IHJldmVydCBkYmNjNTQ5MzE3IiksIHNvIG5vdGUgdGhhdCBpbiB0aGUgdGVzdC4NCj4gPiA+
ID4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogTWEgWGluamlhbiA8bWF4ai5mbnN0QGZ1aml0c3Uu
Y29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+ID4gIHRlc3RzL3hmcy8zNDggfCAzICsrKw0KPiA+ID4g
PiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPiA+ID4gPg0KPiA+ID4gPiBkaWZm
IC0tZ2l0IGEvdGVzdHMveGZzLzM0OCBiL3Rlc3RzL3hmcy8zNDggaW5kZXgNCj4gPiA+ID4gMzUw
MjYwNWMuLmU0YmMxMzI4IDEwMDc1NQ0KPiA+ID4gPiAtLS0gYS90ZXN0cy94ZnMvMzQ4DQo+ID4g
PiA+ICsrKyBiL3Rlc3RzL3hmcy8zNDgNCj4gPiA+ID4gQEAgLTEyLDYgKzEyLDkgQEANCj4gPiA+
ID4gIC4gLi9jb21tb24vcHJlYW1ibGUNCj4gPiA+ID4gIF9iZWdpbl9mc3Rlc3QgYXV0byBxdWlj
ayBmdXp6ZXJzIHJlcGFpcg0KPiA+ID4gPg0KPiA+ID4gPiArX2ZpeGVkX2J5X2dpdF9jb21taXQg
a2VybmVsIDM4ZGU1Njc5MDZkOTUgXA0KPiA+ID4gPiArCSJ4ZnM6IGFsbG93IHN5bWxpbmtzIHdp
dGggc2hvcnQgcmVtb3RlIHRhcmdldHMiDQo+ID4gPg0KPiA+ID4gQ29uc2lkZXJpbmcgdGhhdCAz
OGRlNTY3OTA2ZDk1IGlzIGl0c2VsZiBhIGZpeCBmb3IgMWViNzBmNTRjNDQ1ZiwgZG8NCj4gPiA+
IHdlIHdhbnQgYSBfYnJva2VuX2J5X2dpdF9jb21taXQgdG8gd2FybiBwZW9wbGUgbm90IHRvIGFw
cGx5IDFlYjcwDQo+ID4gPiB3aXRob3V0IGFsc28gYXBwbHlpbmcgMzhkZTU/DQo+ID4NCj4gPiBX
ZSBhbHJlYWR5IGhhdmUgX3dhbnRzX3h4eHhfY29tbWl0IGFuZCBfZml4ZWRfYnlfeHh4eF9jb21t
aXQsIGZvciBub3csDQo+ID4gSSBkb24ndCB0aGluayB3ZSBuZWVkIGEgbmV3IG9uZS4gTWF5YmU6
DQo+ID4NCj4gPiAgIF9maXhlZF9ieV9rZXJuZWxfY29tbWl0IDM4ZGU1Njc5MDZkOTUgLi4uLi4u
Li4uLi4uLi4NCj4gPiAgIF93YW50c19rZXJuZWxfY29tbWl0IDFlYjcwZjU0YzQ0NWYgLi4uLi4u
Li4uLi4uLg0KPiA+DQo+ID4gbWFrZSBzZW5zZT8gQW5kIHVzZSBzb21lIGNvbW1lbnRzIHRvIGV4
cGxhaW4gd2h5IDFlYjcwIGlzIHdhbnRlZD8NCj4gDQo+IE9oISAgSSBkaWRuJ3QgcmVhbGl6ZSB3
ZSBoYWQgX3dhbnRzX2tlcm5lbF9jb21taXQuICBZZWFoLCB0aGF0J3MgZmluZS4NCg0KDQpIaSBE
YXJyaWNrDQoNClNvcnJ5LCBJIHN0aWxsIGRvbid0IHF1aXRlIHVuZGVyc3RhbmQgeW91ciBpbnRl
bnRpb24uDQpDb25zaWRlcmluZyB0aGF0IDM4ZGU1Njc5MDZkOTUgaXMgYSBmaXggZm9yIDFlYjcw
ZjU0YzQ0NWYsIEkgdGhpbmsgdGhlIGN1cnJlbnQgeGZzLzM0OCB0ZXN0IHNob3VsZCBoYXZlIHRo
ZSBmb2xsb3dpbmcgMyBzaXR1YXRpb25zOg0KMS4gTmVpdGhlciAxZWI3MGY1NGM0NDVmIG5vciAz
OGRlNTY3OTA2ZDk1IGFyZSBhcHBsaWVkIGluIHRoZSBrZXJuZWw6IHhmcy8zNDggcGFzc2VzDQoy
LiBPbmx5IDFlYjcwZjU0YzQ0NWYgaXMgYXBwbGllZCBpbiB0aGUga2VybmVsIHdpdGhvdXQgMzhk
ZTU2NzkwNmQ5NTogeGZzLzM0OCBmYWlscw0KMy4gQm90aCAxZWI3MGY1NGM0NDVmIGFuZCAxZWI3
MGY1NGM0NDVmIGFyZSBhcHBsaWVkIGluIHRoZSBrZXJuZWw6IHhmcy8zNDggcGFzc2VzDQpUaGUg
c2l0dWF0aW9uIG9mICIgT25seSAzOGRlNTY3OTA2ZDk1IGlzIGFwcGxpZWQgaW4gdGhlIGtlcm5l
bCB3aXRob3V0IDFlYjcwZjU0YzQ0NWYgIiBzaG91bGQgbm90IGV4aXN0Lg0KDQpTaW5jZSBvbmx5
IHRoZSBzZWNvbmQgY2FzZSBmYWlscywgSSB0aGluayBpdCdzIHN1ZmZpY2llbnQgdG8ganVzdCBw
b2ludCBvdXQgdGhhdCAzOGRlNTY3OTA2ZDk1IG1pZ2h0IGJlIG1pc3NpbmcgdXNpbmcgIl9maXhl
ZF9ieV9rZXJuZWxfY29tbWl0ICIuDQpJZiBteSB1bmRlcnN0YW5kaW5nIGlzIHdyb25nLCBmZWVs
IGZyZWUgdG8gY29ycmVjdCBtZSwgdGhhbmsgeW91IHZlcnkgbXVjaC4NCg0KQmVzdCByZWdhcmRz
DQpNYQ0KPiANCj4gLS1EDQo+IA0KPiA+IFRoYW5rcywNCj4gPiBab3Jybw0KPiA+DQo+ID4gPg0K
PiA+ID4gLS1EDQo+ID4gPg0KPiA+ID4gPiArDQo+ID4gPiA+ICAjIEltcG9ydCBjb21tb24gZnVu
Y3Rpb25zLg0KPiA+ID4gPiAgLiAuL2NvbW1vbi9maWx0ZXINCj4gPiA+ID4gIC4gLi9jb21tb24v
cmVwYWlyDQo+ID4gPiA+IC0tDQo+ID4gPiA+IDIuNDIuMA0KPiA+ID4gPg0KPiA+ID4gPg0KPiA+
ID4NCj4gPg0KPiA+DQo=
