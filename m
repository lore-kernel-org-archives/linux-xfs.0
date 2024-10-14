Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C49C4A3E
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 13:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728912516; cv=fail; b=Z6gHKKsw42Nu+t/ESBgZhRUrRKlSG/4V2IKQKkYvqN0bg6XcyK/txdadOR43drvsOP92ga3sVj8rLVXv5uiYFESd8pZ3OhOZNHZucUtast4CEsbcyqXkqYUL0S45Z89Fg8ka8vUiw2wl+MwJxolM+8c+Ueff05+js8QgCVZYA08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728912516; c=relaxed/simple;
	bh=eBMxaWegKjFJhvetZo6pXQqTHr0sDTj4IL4653Z5aPk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iduOorQG7FW6Tey29gx7nUtwi4OzRkQrtTQlsN2MQLtrVWq0zNB5W1c4MBTEt+GCZxXAQJn0ZZ3RIjTZgUvKP1nLz/G9neUy27htRgLRBdBccvYHM6UPwgMChyU4IFUphU/Nnl7ZsBrZGy/9icfm9pyG1qPpNTkNIe98ccK028w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Ht/DDut9; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=SQoQECr3; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Ht/DDut9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SQoQECr3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1728912514; x=1760448514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eBMxaWegKjFJhvetZo6pXQqTHr0sDTj4IL4653Z5aPk=;
  b=Ht/DDut95qDEke/tX3HjfF4mOnSs8t6Bh6uDrYLDHcc8NQ6gOELeFTu7
   mW2p6YF7+gTRM2amDYRyehVbdiebjS/EozG0eTQq1wNU88O6e3Sz8gyX3
   4pxrdvA5Hqn/s/8f+jeH2BIDCt4v0eko8qNBmL895wYrBUAcYGEi8r5eD
   asyxD/CuPoqyuJHFGw9/lqaZ/ntkyd0vN0v/EKi2mzGQa4I7ZOHzFpCQi
   Wo/CgaGLwMFjifI9Xle++6vlqAvmNWLeHD0BlzutRD7f78U3gcebbs5p0
   ru5vRcwVJ4XCuVbUCHVMQmTeVwsX4WTmjKyaFSTlq67oeh32uNe5Qbk7D
   g==;
X-CSE-ConnectionGUID: tyHtcd6RQQu2BIdbv/pmGw==
X-CSE-MsgGUID: G4xUUOMRTAiy7NphdWSqqA==
X-IronPort-AV: E=Sophos;i="6.11,203,1725292800"; 
   d="scan'208";a="29347208"
Received: from mail-centralusazlp17010002.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([40.93.13.2])
  by ob1.hgst.iphmx.com with ESMTP; 14 Oct 2024 21:28:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CZbHia8Y/Zf67FRFI7dN+hbOGzQktqBrsFkQZTbVQ17xwGax7246DRvlJP+byBX6ZQxDNqZ0xmtf23lpC/2vD1wQYn37ZZapKpfyU+kdE+rTgu6FfWGjlzIUyExwE4OVcHLOOwK5L/UYSjc7uphZwH/Qq4vt/QlHtgxjvTbvx0D+Mm8sd3K4g5IGMzuPGj5HEvK0esDrBHNzNs24dNDZXOeJIGkeY9r2OTwwvQMm6zacb7uHFbWTRK7gcdBq2faVqhq7W3vbT8IAaKJwaS70hFP9zHiEzH++D7WBqdS7fCcWGzoO6Yh3V6EobK5pINV4YtCpTnlppLqodbnJ//yXaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBMxaWegKjFJhvetZo6pXQqTHr0sDTj4IL4653Z5aPk=;
 b=w7K3k92zdSKzbB65WtH/mjc/CvE0w87Sg3L4hHVCLgOhorHDjq823nN3iggYpxILGekppf1giUHJfz7ub5yXLHssqnfPC1ib2dQojhQ5TMbOrfTBqDconLc/VgzQuEIHeGCivqne5Scdx0N66wOkwHSuLH0p30wFKrSc6YeNeysPBHQ8YwgdIDbLRi2MpHeENX1S8750av2WbDIYfYypNSbg9nfe/n7driMWQMHlTR/8fWHdYtqsedgR7zmBp0jgOwbsFT/5BgvjcqlwuPn6apt64vhdrZo4Jchy8jjawhwD6jIRNIUZYASLKQ9VJqiaMA445AGms+H25e78n16J+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBMxaWegKjFJhvetZo6pXQqTHr0sDTj4IL4653Z5aPk=;
 b=SQoQECr3e1EsIQNVQuDKUWiN/KyeKy9ihFlJQ5fd+aaCDJscaUK2FSV21ey3BtCqp58SJPUpAwUZWzIT0NYsRZ144A0og9sKf5ofzl9dyoE0JffVvbcbz0KLSCv5dVD9ckDnqVkZagWZfwkxVbhUweQmTW3FAd8wHKFlNOQA+yY=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DM8PR04MB8055.namprd04.prod.outlook.com (2603:10b6:8:2::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.27; Mon, 14 Oct 2024 13:28:03 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%4]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 13:27:57 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>, "Darrick J. Wong"
	<djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 10/36] xfs: export the geometry of realtime groups to
 userspace
Thread-Topic: [PATCH 10/36] xfs: export the geometry of realtime groups to
 userspace
Thread-Index: AQHbG3mHxyGzTDXuRUyB2QKhy7jAZ7KF8HKAgABSXQA=
Date: Mon, 14 Oct 2024 13:27:57 +0000
Message-ID: <8ecae4c5-aeaa-4889-8a3a-e4ba17f3bf7c@wdc.com>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644412.4178701.5633521217539140453.stgit@frogsfrogsfrogs>
 <ZwzXRdcbnpOh9VEe@infradead.org>
In-Reply-To: <ZwzXRdcbnpOh9VEe@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DM8PR04MB8055:EE_
x-ms-office365-filtering-correlation-id: 87441234-d89c-4e24-f969-08dcec540452
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?c3NOMThGRlJYNmNQdkxXYUZBNTg0Y3ZjZ3Ryb2hGY05STXphaEFGUWg2MnA4?=
 =?utf-8?B?RVRZM1VmQW1vRElScGsyaDVja0p0K3lEdEYxOGlwWXFYZTJHMEVDOGZ6dVNz?=
 =?utf-8?B?T3U5UE84UWM2eU0xM0Exa0tBWUZSVmZFRG8yREkzaDFwVUtUaWMvNFhGZmdm?=
 =?utf-8?B?TmFOajdEZXQycE1NZFowcnJ5SXgwQXhRekZkT2MxcjlUclQ4T3Y4TGZhS09t?=
 =?utf-8?B?a3RRTzVTL2EyZi9wQXRqdGV0eURjd3NScVY0bGFIRlM2KzJOb0ZSQzVqTnZu?=
 =?utf-8?B?Q3VvbWJ3elJPdnRmQ3RPcUdUb0RHdytFK3FHb1lITC9QRmpldkcrdExlK3Vi?=
 =?utf-8?B?cERYVkpSN3VlSE10VGVOcEZqYTJMeXRzcCtXUlF1dkIzalFCYzhYZmxQWDFC?=
 =?utf-8?B?NG8wbTNtL09BcE4wZzV4SC8vb1JzcnBrMkYzSHR1SlppejBpVHNKclRDVDgw?=
 =?utf-8?B?UjlzbUtPT29Fd2p1bTQvQWEwc3dyZ0o1VjlJTjZUSU1PSXYwY1g2RFlVMWtX?=
 =?utf-8?B?bXg5ZkN1YmpUbklHdEQrNmlUcmRGY25FakU2WHFDL2ZoVnNTM2xOQzRVNWNo?=
 =?utf-8?B?TnpyR0lTMlltaUpiSVZiM1BhaTBQcVZibUpkS3NrcHBvVkRkdDF1dVlMOGVi?=
 =?utf-8?B?L0RFbk84WW92aWc5WXVEV202cXFhWEUvYjBpajlVam5VMEc3dXVWZFlwcSt3?=
 =?utf-8?B?VjFDZEZyZmNOS3d3cSs5T1RGMERiRVBxUkJybmhaT2ZxbEE1L0Q4bEZHbWE2?=
 =?utf-8?B?N0dDbjJYaStpVTFYa2hzbUhkemhDY0x3U1M5RFJCWkJ2SjBCaWJnWDQ1a2dy?=
 =?utf-8?B?bHRPTjBLSjczZlN6R2ZRY1lXT0N0MEJkQ0JpZXlmcnlGVEkwVTBiT29aQTVw?=
 =?utf-8?B?VFMyMVAyazk1N2NhQnYyck14ak9NeDYrK2owdFFueGxrRExqSTZIL25ob0Nm?=
 =?utf-8?B?aUJYNm02eUFTTk9BdDV6YmlzSDdzdnA0UVBMK3d0ZHRab2JRaitmK3NTM2lD?=
 =?utf-8?B?cFdyRFppdG5DWWIwbHRySFAvT1l4WFZGYjU1NjZ1azFudjhtUDcvcFpuUE1S?=
 =?utf-8?B?T2FMTGhVeTZDWnNwNFRrUDV4N0pWZ05NSWhEZlhuMnhaRjdmTW82RWVLU2tz?=
 =?utf-8?B?UDhSSEttQ1Q3VmpKNTdLOHhFK05jWmxITUNrckdOaDJQREM5b0FIU2YrbUpr?=
 =?utf-8?B?RUFaaHBCemxrSHRwT3F6S0pQdHozNjI1Wk1hVGxCVjJXM3oxUEQybW02UXg5?=
 =?utf-8?B?QnkxTDhYMUhpNUU1bHZQRklJWUNyb2d2SFAwQUtNdjRPaVpYYkxDN2J2Q3N0?=
 =?utf-8?B?Z3poY2dIUVRGNUhoYmZLR3h2TDJxU1czRGlDQldYWDB2RmxKTk0vM1RMTndu?=
 =?utf-8?B?cnRhQmQ1T3lCTGd2UlZ5SUQvcXFGdlhOdFJkbjJWVUdPckJ2WEViTVBqMDB2?=
 =?utf-8?B?d01uZTVWS2Frd2djV2ZoVWI4TGhVdDRuYVZsQThsK3RNZzBpcDNncHJQaEp6?=
 =?utf-8?B?dUxIakhqVkNIZVlXOUF0ditTVDRlM3RTTjhJSXo3Z0NNckhZamFiY1l5ZFZY?=
 =?utf-8?B?QXQyaHg3SnUwbE55Rk9pMi9PaGt1ZEhna3BwdzVaZE1FWVZqalFSRUxMOE1v?=
 =?utf-8?B?cUxUUmt0U0EvRWF6LzRTQzltWk1UdXlMWW5zc3pkekJOeEJhbGJ0SDg5OVdm?=
 =?utf-8?B?UTZVb3VCZWx1NmFYWDhndk0zNlV1YkdCdThEZEFUZ1JLMW9JUTNJMXluaG04?=
 =?utf-8?B?NTFUT3pRZnRLdzRDRnpxd2QxbXBwVWc3dnhzUWZDV0NtaHdnclJEa3JLWE5j?=
 =?utf-8?B?eEpOMlV0TGI5TUxTL0dtdz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QTJHNE1weFRKVW9VZ2dnY1I3NGhxVUVET0xxMWJOZDZQMklzOWQ2Vjd1LytQ?=
 =?utf-8?B?aWphdTdOUk5XQmZuSkhWQkVOV0FxZmw1ekZ6QWJLVEVBSENva2MyaFN2NkVS?=
 =?utf-8?B?UUR0M2FHcXhCUUplbFZBVmlWSG0wUVpoLzdtbmFmcjNDdlg0ajhxMk1vNm5z?=
 =?utf-8?B?bEtTVFlLRjNqcWpwZHZKaGJsdDBnK1BGa1hETGRwZUZuM2JHUmRjSUIyN2lu?=
 =?utf-8?B?UHVncGJUTkZQbXdGUDliKzdLVTdQVEhuOTBqTytsa29mMFFYZlN6ZEtyMElq?=
 =?utf-8?B?YXFUelFyblNtcmtqaSs2NGEyazZJYzNQRTllVnlSYTdpNW04bDJUTGJFV21p?=
 =?utf-8?B?dmZ2amYzUTZ2eVdnVHdVUm50Z1dvQWRBWmlsRjJPSnVZVWp4R0d5RHlWUmdo?=
 =?utf-8?B?bVpTcXpiRjAwcUJidG1VOFdtcTh2V3hmdGJ1QkF5VTd4UllDUmdGWGZ2RWtN?=
 =?utf-8?B?YWlQUUV6cDJDc2t5cGpZWXFpc3lKYXUvWGhudGYzSFFPZzV3amhQaFUvWXV6?=
 =?utf-8?B?b2FIdmIyRFNMM3BVeTVleldCOXMwMGYxYUtkQ1VxdDNXS3ZyOXRGb2oreEty?=
 =?utf-8?B?cUZZOGJ5aTZWcUZXRWo0RFBBbytwamI4QXUrcUFOM1Q1OThoZFdYRWQ4eFF2?=
 =?utf-8?B?ekR6Rnp3Wm9sVFJSayt5TThiZVl6R053d1A2YWtiVy8zbUFoZFEzNlF2S2My?=
 =?utf-8?B?NkpTalpkL0pheURiYTg4QXc0c0ZNbVBWWVZ5YmhybzYzUDQzT1JDZytjWmZt?=
 =?utf-8?B?UElvYXNvUElxU3pTMGdQK0ZyK0t2Rk8zNThxVEZQVlMxalhzTWZqKzFMWmxF?=
 =?utf-8?B?OVZLallXZVc1SzlUcTQyckl6WE9oK29PcDJ5dmVNWE9lK2VHbkk3M1lIMTRL?=
 =?utf-8?B?QUVDVndnSzRsSk9MZUhHZmk0eVFOdkVTWDQ1ZHA4ZmJPbi9reUFkRlNtVGdQ?=
 =?utf-8?B?WVVoR2hVYVpmbzNVdWZXK2VCWjc0REovVkQ3VncrZW1jQXkxakl3VENJOXh3?=
 =?utf-8?B?ZE04dWQvR0tOb1ltKy9XMDBPempPMW1jWGE0d05oTWI2RkJxckwzODB4WXRt?=
 =?utf-8?B?Q0ZrWkQ3UmtYdXB6UUNjQ2NJdTZrMnhOY3o5OEV3aXlkOUx1L2k3c0RiYUV5?=
 =?utf-8?B?TXFlM1hvaXgrZXNaRWRzTVA5QmVXSTZkWlV4aHhnSmNOejFYSlMvdytpRHdm?=
 =?utf-8?B?ajJzaURQV2c2MzEzT1doWmEwL2dLMjdtM2lpVTRPaTQ3VVpydm5OekVBOTFm?=
 =?utf-8?B?TSszZXBVWDZLYXBSclFsVmM1Y0dHRGx2emxKSDZTKzlaeHZBaUcyU0JaRStn?=
 =?utf-8?B?bDV4NUJ4K044TjFPa21sdTlaWUtVVUhTTFdXZXNqdlkrNitwL2oxKzJ1dHht?=
 =?utf-8?B?eFdFWnY3NXZobHovdFFEVmJFWUliMTdNdFowZGtPMnFRSnl6cWdzN2xSZGpr?=
 =?utf-8?B?dGVtM3RibTVFOFZVdGRabElCM2x5aUVOYklmM24vYzRLZ04wODhEQjIyTi9m?=
 =?utf-8?B?SFhESkZGT1UrTVAxYmZEV1ZUOWk2Zy9Ndm5oYlBXdEp1ZUdpWUhEbGo3Sk9Y?=
 =?utf-8?B?bWJvWVdEYmM1Z2VFRzA2bXZUV3RONmdCRERZNmRmR0FiMnJGbW9BTEI3YVpN?=
 =?utf-8?B?R1dwTG5LM0dIWU1mNVQrNDZvME4rYW5xa3J1ZmhXdzNVVVdUQW5CUE9Va0sy?=
 =?utf-8?B?ZEt3L29wL2Nobkc4bVdzRjdDNTYrWGxGcEFRUG5iN1h0bDBjcFZsZnFKdUN3?=
 =?utf-8?B?UjVoM0hYL3plUGxFSGFIVUlqRzFzZzNRdi8yUUJyQXdLSm1TNUluT1dxS3Aw?=
 =?utf-8?B?eUhrZEJSUEd1RC9lQ2tlWGkwd1BBZ0tBcmI4eFZqWXIzNVVWbncyRzA4VTVX?=
 =?utf-8?B?UjVjR3FEcGRTSlRVTmhwQUZTWXN4YnhYMm9iWm0wenB2d3JvK0FWQzJzd1da?=
 =?utf-8?B?cFdXS1g4SGlNSzg4RWtseDU0Y1N4eVBaSmdwU2kzbjdSa0RERWI5by8zeWxr?=
 =?utf-8?B?RUNvaEtsbkh4Q1R0NFlQa3FrQ2pNUWU0ZWtkekhQeHowenZKckZpODRkbEJE?=
 =?utf-8?B?bnYySFZ4RHc3cWJLelJoZXZ2WVdZUEVRTzZLVlgxOTBMK2VXbWRodzNBOTdF?=
 =?utf-8?B?NmpveDNGS3VQb2FUU1BTeE01dnhCdHFtaU9BazFHUFVFZ3NNNHM2WDZhclQz?=
 =?utf-8?B?WEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D7007A6AF3F6B4B8CE29E1A479C946A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ktRU7MbIOXX6VH66Srr9O9SEYMUk6ySE9pn3PLHtk+mbHFwCGZwRgA4eqw2xlFX6gI7fBjTX5y+bdB9psV/Qz+WBh4H60ZbN7vlYjPM0IGBw6VhmjVcQ1s4k2hqKG6IJq6nUSD4LqVAJHmqHTVmjZPhYxonwRNR+9UJ4Ydkj6ZhFjPywg78LagtGyyKecQ5LpK70UctJU7xl7BDpJzmie6o+yGu2ljO/KbyrryPR8TEVuroP/+feHQpZmRSpXieZk3yK8RGL9C0cpbZwf+UWzGiM5E7UgKsEPjn1kVlxSD2u6QpOgy+lWExIhDdCFCjqk9CFNr2aWyHwtoklGeriISByQr63ZQ74zgcIJFVCPVXOOuOQQf+SK1xv41isowx7QJyrTd5S8OpBfTRc3YaF+YX4OqA3L1fKKF6YoX/CyQt/wMZuzRB6gfPgmE5nqYv6tx4Qsseg6fsga4toem1lmRHEbUYK5sF0P4ljU+tSIaoDT2ZPEoHxfxn4tvReM7SalAA/VH1+P7EXhrnevL7Kgoxz5dVekWDfatbeleNa1xkJU4+TRAFN3nmXAYso3TR4ZfHPIH+Gfb4ckTXFp4cvs/5oyjYVe7RKkUid70x9D0OW9TrM8CXSEuJTxpccPA8I
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87441234-d89c-4e24-f969-08dcec540452
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 13:27:57.3188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UONvvaoAbsXg6UOfihEMI+AT86lMf5u25wHjIarv0/6632Yuc/dRN9Hy2FgLTl0iYuAp+I2hBvAkre/gFHPoSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8055

T24gMTQvMTAvMjAyNCAxMDozMywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IE9uIFRodSwg
T2N0IDEwLCAyMDI0IGF0IDA2OjA0OjE3UE0gLTA3MDAsIERhcnJpY2sgSi4gV29uZyB3cm90ZToN
Cj4+IEZyb206IERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+PiArCV9fdTMy
IHJnX251bWJlcjsJLyogaS9vOiBydGdyb3VwIG51bWJlciAqLw0KPj4gKwlfX3UzMiByZ19sZW5n
dGg7CS8qIG86IGxlbmd0aCBpbiBibG9ja3MgKi8NCj4+ICsJX191MzIgcmdfY2FwYWNpdHk7CS8q
IG86IHVzYWJsZSBjYXBhY2l0eSBpbiBibG9ja3MgKi8NCj4gDQo+IFNvIHRoZSBzZXBhcmF0ZSBs
ZW5ndGggdnMgY2FwYWNpdHkgcmVwb3J0aW5nIHdhcyBuZWVkZWQgZm9yIG15IHByZXZpb3VzDQo+
IGltcGxlbWVudGF0aW9uIG9mIHpvbmVkIGRldmljZXMgd2l0aCBMQkEgZ2Fwcy4gIE5vdyB0aGF0
IFJUIGdyb3Vwcw0KPiBhbHdheXMgdXNlIHNlZ21lbnRlZCBhZGRyZXNzaW5nIHdlIHNob3VsZG4n
dCBuZWVkIGl0IGFueSBtb3JlLg0KPiANCj4gVGhhdCBiZWluZyBzYWlkIEhhbnMgd2FzIGxvb2tp
bmcgaW50byB1c2luZyB0aGUgY2FwYWNpdHkgZmllbGQgdG8NCj4gb3B0aW1pemUgZGF0YSBwbGFj
ZW1lbnQgaW4gcG93ZXIgdXNlcnMgbGlrZSBSb2Nr0ZVEQiwgYW5kIG9uZSB0aGluZw0KPiB0aGF0
IG1pZ2h0IGJlIHVzZWZ1bCBmb3IgdGhhdCBpcyB0byBleGNsdWRlIGtub3duIGZpeGVkIG1ldGFk
YXRhIGZyb20NCj4gdGhlIGNhcGFjaXR5IGZpZWxkLCB3aGljaCByZWFsbHkgaXMganVzdCB0aGUg
cnRzYiBvbiBydGdyb3VwIDAuDQo+IA0KDQpZZWFoLCBpdCB3b3VsZCBiZSB2ZXJ5IHVzZWZ1bCBm
b3IgYXBwcyB0byBrbm93IHRoZSBhdmFpbGFibGUgdXNlciBjYXBhY2l0eQ0Kc28gdGhhdCBmaWxl
IHNpemVzIGNvdWxkIGJlIHNldCB1cCB0byBhbGlnbiB3aXRoIHRoYXQuDQoNCldoZW4gZmlsZXMg
YXJlIG1hcHBlZCB0byBkaXNqb2ludCBzZXRzIG9mIHJlYWx0aW1lIGdyb3VwcyB3ZSBjYW4gYXZv
aWQgZ2FyYmFnZQ0KY29sbGVjdGlvbiBhbGwgdG9nZXRoZXIuIEV2ZW4gaWYgdGhlIGFwcHMgY2Fu
J3QgYWxpZ24gZmlsZSBzaXplcyBwZXJmZWN0bHkgdG8NCnRoZSBudW1iZXIgb2YgdXNlciB3cml0
YWJsZSBibG9ja3MsIHdyaXRlIGFtcGxpZmljYXRpb24gY2FuIGJlIG1pbmltaXplZA0KYnkgYWlt
aW5nIGZvciBpdC4NCg0KDQoNCg0K
