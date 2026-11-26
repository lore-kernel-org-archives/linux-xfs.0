Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795702842;
	b=iSY2/McXfCFdfgb7N5wEdGW/qAgN2LgZP2PWNw0UH2nXPnw7mMOU70z3hHPApm2tyVP1
	 5puXKKFrjj9hI4HnzITB2gvDLkNf3wxnyYZ/NGFfkhOScF9jh9FBbhMJhJJwcRWiRfDgm
	 PBfMox5zqlAKVVEsNfXiPPBcjCee5lYBvRG5PikZbk1XqQqzh6H9XLMVp5oK5I5Iy7c9+
	 rnUDsdHe+4yJVGovCtqZgHYw46SP0lBxvtFdbaD/A3mS+9ncn4fgmYmKWQi6ua1DPFsT/
	 jyMr0strx0Nt/VUz9iluZqXnKwsHIkvzQpR6WgHfaLKsU+bmo3ZV9xHz1h5EidWfrnw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795702842;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 msip_labels:x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-atpmessageproperties:x-etr-sdm:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=RtuNOp12A5ygD9+8wd8oSLncnCGXlYpIAmH/kzo13eY=;
	b=eEvedgS/FKVDkfaZRX1E1uk3I0MULshGrf31YTPDN+10KtaU7gtTncSNfMyfr6xyUc7e
	 ZobthrTFBD/LDI61ER6p+kefHuEtbCzOUfSBNBVVR+f9meAFnmkNixSVnNiEBhXOey84k
	 FQjQTFcMHbD13v23Ig3BwZQ076VkKR2w9tN8TSvJ6P3Zg7Rm7/0cQwmWXPYchJLRtoj6o
	 4XUJxjjyb2vEEEnMDxb6NDK9U1OpAXKeJ/VoRatXxBZTAEJEVIZP89EyF1uFxyU8CGkNv
	 Jr+EJDURGk+Ig7Vh5Agt/m+1rCqqu2nQc/hqyaDNd88nz7VVDcz9SK7fG8Yoh6Pm+GA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=solidigm.com;
	spf=fail smtp.mailfrom=solidigm.com;
	dkim=pass header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=IIRliOKd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.68
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1401606A31E;
	Thu, 26 Nov 2026 14:20:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1401606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solidigm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=solidigm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=IIRliOKd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZssEqmTXlpBx9oNzUX9wXeQbITb7FmuFbqN7A0/YjfWjnIkEFzkNSFApQdS8d8ZpzPt1NUUZDxFLWChOCLhKdZKPA3TByPor7YyIhkbXYw68Unm+JjrTY+yr83ni2eiOX0eQuq8Ao6dZCBc+c4imHi5t+3cThmuDMr5Gs3UAiEXwTr6VNa5+M66+uIU5It92wibKRzCt6fZEZ41XDlnFbqJdFRl8p6cHLJ8wJPG+6Af+/ukqO9VMCKVThDI5vpbk3mcL014Fe/m3UNg0dfBV6LLQHeBu/LMIAzw64IYJckEhBf0cgEjMLnUZBx9S77Th9l6EwXjfOaiCLJPCcX3wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtuNOp12A5ygD9+8wd8oSLncnCGXlYpIAmH/kzo13eY=;
 b=tPdLuG4mI+PxVzDQ5O8uOU4ZTv1k+VSgRX4iivwkMj2eON0+vHN4DOtjx0DV5Ruyy/6ZPb8IGbM2D5I2TJ3wSCyjgzznSp/U2p8evSmsYADIwNumxyL9Dc8YgxbE5XGB6dIrvQSQv1uEw4fm5xOhyn+TZGGebZjzugPZBZ+sVq3zPEGO3czckw8QNP/mvaLRujwWu4LxpPfoBJEjv3EamE1bqe8ilnANRuNrEjGFT4rtR6RXQF1Gk+SDce+KIp8kBfqrPoC7uJgD8dluRt2kNQGvc2xS+aM+roiTxHgC+C+3g+Y3pN/B1Wg1/PzgrzRgIauveK7wRpkCIUA1/bpxNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solidigm.com; dmarc=pass action=none header.from=solidigm.com;
 dkim=pass header.d=solidigm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solidigm.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtuNOp12A5ygD9+8wd8oSLncnCGXlYpIAmH/kzo13eY=;
 b=IIRliOKdJTavMwZKS3UyllHh6e2TW/2/2hbqIwq5thFdAScgX+SJ5lxFNaWJZL4/M3HvMGOotMZsuHg8lqtDwApMO6te3EIrSWw/psaTojg/dCLjgb7Jt93EaAT58Fu2Pcpqm8sgQ+ycGQ9pd6gYnFgBb3dN3+MySlg/t0Aym10RvvJqySvwtfbYF/m6aBuBRRLROmXYqYh9zVVE7UBPi/OE6WiB2IE+P9EtvWlPB2CKAJXposBWhqvSXSSqvCOBqmV1Xwy9bCgd5EYkZaXIHdclwIwFzR1pABX9KsWBkeXOlVM0TK0d97vn/flkS5V3hcrPc8WVeQ5hmh4qweeJdA==
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 (2603:10b6:408:33f::17) by IA0PR10MB7665.namprd10.prod.outlook.com
 (2603:10b6:208:484::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 14:20:36 +0000
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368]) by LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368%5]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 14:20:34 +0000
From: Wayne Gao <Wayne.Gao1@solidigm.com>
To: John Garry <john.garry@linux.dev>, Dave Chinner <dgc@kernel.org>, Wayne
 Gao <Wayne.Gao1@solidigm.com>
CC: "cem@kernel.org" <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Thread-Topic: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Thread-Index: Ad15z2WocV/7eyH8R22b/KBFBzWDVwBt1w8AABnpZwAAGC6KAAAbsMgAADzGTTA=
Date: Thu, 26 Nov 2026 14:20:34 +0000
Message-ID:
 <LV0PR10MB997684AF8DF28BE949FFF608FBB9422@LV0PR10MB997684.namprd10.prod.outlook.com>
References:
 <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>
 <awSd1JEB0F4WeKt0@dread> <2a615ca6-3777-4b71-bea6-4072d4fbd950@linux.dev>
 <awXuAESDkLr1nd3n@dread> <a337f9fc-b6ef-48c4-ad98-52972b10b4c9@linux.dev>
In-Reply-To: <a337f9fc-b6ef-48c4-ad98-52972b10b4c9@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ActionId=08378f95-7757-4183-a382-481aac197866;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ContentBits=0;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Enabled=true;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Method=Standard;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Name=P2
 Confidential;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SetDate=2026-11-26T14:18:21Z;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SiteId=4bb44aac-867a-4be0-aa34-30794e8470dd;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solidigm.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR10MB997684:EE_|IA0PR10MB7665:EE_
x-ms-office365-filtering-correlation-id: ed296c35-f60f-4c0d-97ed-08df4bc86f4d
x-ms-exchange-atpmessageproperties: SA
x-etr-sdm: Outbound Disclaimer
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|4143699003|6133799003|261009223027099003|22082099003|18002099003|55112099003|3023799007|10067099003|11063799006|5023799004|56012099006|261102123227099003|261026140227099003|261026121527099003|261021121427099003|261022075727099003|261021123027099003|261022105027099003|261022113327099003|261028144727099003|38070700021;
x-microsoft-antispam-message-info:
 rcin9rhX/cOpqQMAY+nK+54xvkv7UlW/Zxcf2RnR77FdkCwjWFrJAmHrv0jaT1iepFe6h2MdlY4fh1rYqRwcEHnypIIc2HiLZF2QYwmEQlJw4EgRNBZExqV1GTAG2jYUrNUKa4WunBZx+9yLIsU06uo2JveajBjb7F/Nky1QrpVImsRrP91bAFFn8+M0WaPnAVkIBsystfNLq3K0TpACC5FwoBm4aC7WWHpyxBm2NmRjyjfjTm078q0bCL5GJZivmmI3+e+uqcIiEB7sIPW4MBP6BrkIZLBvXQTpZwXvAVjvpgX7NMiBoDcn7ZP8PVDgyvlHn0i2MNTRI7ElEXhaS9ocXjvUbxnZ7RYa9wsexUs40CMWlPaAHu4w2uBJU78k1RofrBKROJDhbZKkG5EeFPFhqnXiyTqoLS/x4W2NRmHktAMQ6ftesWvyvk6MUqrvjNE1RofbVV0vqbWiU8us+zbJzjVNZ1zbWXtbNRK2C6XhqTp3dqoMEe/xFJjjpGy28nCT79CRLlmVZoPS2IyWM5dXkgr4tAAaSCxyRqZorha8PtYMEFJNcrHi5Qlx2Erp+gL3/tGSB58kV02b1Pohu3yw+Rs33z9zNcUP6Zt/CKofUh3mm5osmQt9LMQnfIqCZBAjn98AwsoH3MM8Fi/EUQDpNiDBvQFKMUUSFur87E4V85AOzF7PCcujSUklbu8JanNf9qhbrG90rPqVbQqAmg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR10MB997684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(4143699003)(6133799003)(261009223027099003)(22082099003)(18002099003)(55112099003)(3023799007)(10067099003)(11063799006)(5023799004)(56012099006)(261102123227099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261021123027099003)(261022105027099003)(261022113327099003)(261028144727099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?eU0OsexEJ8Lx+1m+GP0RNoLd401O4U51bePy7fxvagBaKC8fBN7BgiiWumpN?=
 =?us-ascii?Q?rMwXyN+yQD/aVyOWAVqikQgtma5qehEcJ/6Qq4OWqHW7cdJwG62zF447p6MP?=
 =?us-ascii?Q?E45uVR/mwKXVF88K/xbpxFKgTOA7yGKelkQEyK6E3enGQ7uSJo6Q7LpFfMwb?=
 =?us-ascii?Q?P/ZpLebXU/3uD2mwshQ5CX0wKHWhiwE4QBrM0WEa/PhYYUrJkV/2IdB3W+J8?=
 =?us-ascii?Q?3XWal5pi30nXKDUprlcQgMOHVRr2kpa6u669r4hQq5iu6YVPL7T/cfTdAyIv?=
 =?us-ascii?Q?K6B0W04tpfSzZj1hBA0V+/A0ocL6HQ43rxiq1H3mouHIwvzlsYFfUrtKkcDk?=
 =?us-ascii?Q?3YKa7i/2Hi56lGJo0ly9/735+sH4JSUF3Eyv9ZiiGcY7ru2NR6J5hTWKx/xr?=
 =?us-ascii?Q?PoErO+pSQBt+O0Y1y+AvQh/MB4ZATNG3nXcvTptNq+tFZ0jcEcIjDmnepeLT?=
 =?us-ascii?Q?mTifNk4Fh+twaqJHBhH+NbwAEDKj6cpd0V46Fz+EQGYhKM14O90BXjZxua84?=
 =?us-ascii?Q?q5gLsEA7BuLALrGg3ZOHlojT8UcCDl2XyPYnxu2XXSEL2rj+MN3wk1n8dt8c?=
 =?us-ascii?Q?MFNJpAeCYhQhCf0izGUcvIqp365gbuq8WoZA1d1XILURhzgXJH4Bk7R+nLyZ?=
 =?us-ascii?Q?Psz0eytMq1NtNRpwu5Lgh6+GhM0aqaELzk/gATvFaB1NoJZBQgnPMBW14Irk?=
 =?us-ascii?Q?ma4h8AOHopvh6hFzPKoAydwlCzkKEXbA+c2tmhwOkufkDMkB+RjENzSYdqFr?=
 =?us-ascii?Q?BMKZ+rS/Tjp4k9D4Rw0cEaZTroJyRaMZwXbG1bomsqZdmIL3/wUdXU6xSE1s?=
 =?us-ascii?Q?MBK3YZcJssstGXs9kkG5Y8Yh8P/ZOLEdqbl+wtLi+m/5pMQXcroOjyzhCCSv?=
 =?us-ascii?Q?uDCmOkWmI40zlifq33/0zR5/6T2ZfITw4GjULxu+cS6m7Frz31vVg+AkU8HV?=
 =?us-ascii?Q?JSZWJzq4Yw9z/QUiT5HiC3UeeVoaVPX4t0l9r8boHIczVxpjq0347BsV4sMj?=
 =?us-ascii?Q?GI/U+sI2VlUyWVlxyj/sXFj9UQAfwIuyi7LiNus0mV3lCAmpGIiNrXuo44q9?=
 =?us-ascii?Q?5imvOph4SYRwvfmTNney6/9Sy0Tn3koPRL9KMewPVhrS/xeP+kQNO85hyopA?=
 =?us-ascii?Q?7qKHcb38HRB8Fz/NbHI9gYrbD2FiSMuU6TOoDu10n0j5tdhvvrV0AR0w0062?=
 =?us-ascii?Q?qn6AyC65Lvr1qUfmPQvCESdQMa4egy1w9SuhrjqjpGBs7PA9pGnR9JUrRPH/?=
 =?us-ascii?Q?5vo+FV9vSoJ0aJR8navPL6OqhvXZpJT3y71Y+LJJfE4nZ4anufBuwJusrGwO?=
 =?us-ascii?Q?lpcuBtCsztj8ZknEe5Vi24PtglVqqXMd0FmYl95/cqP/L83uuXucuatnh2kv?=
 =?us-ascii?Q?LrEfMbeaN30AYj4A7UAC39LBSQF3lhjcVkECR8cVsZnzZBTwCJsskS+sAwCA?=
 =?us-ascii?Q?iqv3qYZ5aAlEv8pHCyeyrzQt/ukYOa6rGXJqIDE6kt5reOG4oiXhKtJz3LcK?=
 =?us-ascii?Q?vh1esdcBsCslsUobMWdM9F/ALU+xFDooNJTIvCLB7cDYreN6jtMeianivxuQ?=
 =?us-ascii?Q?m9bC/u/2wpNvTB0HJk/70p03oTW4S9oa9Ybj0AZsfHEpxyBWZ+xir29TKL5B?=
 =?us-ascii?Q?bk0Jj3KrKWosr4F3HRAfcbBRAGoAg5dk2uI59jgCNjaXBpJzfKfPCRZ6HgEf?=
 =?us-ascii?Q?K+6PJIH1yEYF+AB4zLgOjRy83NRC05KJyGSGn673QgU29XYpBc4TKeeoTe2p?=
 =?us-ascii?Q?hbLrhNuPpjX6GGoyohWQ3hxEzks1zms=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: solidigm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR10MB997684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed296c35-f60f-4c0d-97ed-08df4bc86f4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2026 14:20:34.2286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4bb44aac-867a-4be0-aa34-30794e8470dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GN9f3GBBd2ZpVlOE2CPMhqeWNVFTesiKe7BiZS9LclE7dJIE3nlTYurd1m4yDCGOd5qVxA8TwKxrSOaVxIV/9AJ/tq3akyL5iDukT40Y1JPANvVnckIFXxrQgNCcjega
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7665

John

Actually this PR is not for dynamically change atomic limits, it is just on=
ly support XFS atomic request have one option to use the COW instead of HW =
atomic if the request size =3D HW atomic size. This is only for benchmark c=
omparison.

-----Original Message-----
From: John Garry <john.garry@linux.dev>
Sent: Wednesday, November 25, 2026 5:18 PM
To: Dave Chinner <dgc@kernel.org>
Cc: Wayne Gao <Wayne.Gao1@solidigm.com>; cem@kernel.org; linux-xfs@vger.ker=
nel.org; linux-api@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: add a per-filesystem switch to force atomic C=
oW

[You don't often get email from john.garry@linux.dev. Learn why this is imp=
ortant at https://aka.ms/LearnAboutSenderIdentification ]

Caution: External Email


On 11/24/26 20:05, Dave Chinner wrote:
>>> Ok, so you want it for your test/dev environment, not production?
>>>
>>> I thought we could already change the block device characteristics
>>> (i.e. support hw atomic wirite or not) at the block device level?
>> The block layer just accepts whatever atomic properties is reported
>> by the block driver and there is no method in the block layer to
>> change these limits or turn them off.
> Isn't that a bit of an oversight? Lots of the hardware related IO
> capabilities are configurable in the bdev queue (e.g. max io sizes,
> max discard/unmap sizes, max queue depth, etc).

Generally anything which affects atomic limits is fixed. As you mentioned, =
there is max io sizes, which can be configured from sysfs - however, for HW=
 atomics we ignore max_sectors and just pay attention to max_hw_sectors.

For any normal IO, the block layer can slice and dice the IO any way it wan=
ts. HW atomics are not like this, and the IO must be submitted as a single =
bio/request. For any dynamically changing HW atomic limits, we would always=
 have the TOCTOU challenge, i.e. bdev limits can change between checking at=
omic limits and submitting an atomic IO.

>
> Sure, they are initially populated by the hardware values, but the
> user can then override them (e.g. via udev rules) and that means we
> don't have need to add 'override the <bdev queue property>'
> management interfaces to every filesystem that supports those specific
> bdev hardware offloads.
>
>> Then for the only block drivers which today support atomic - NVMe and
>> SCSI - similarly these we just use the atomic limits reported in the dis=
k.
> That seems to be inconsistent with how we manage other hardware
> offload size limits on block devices. These are -not- filesystem
> properties, and we should not be trying to manage them at the
> filesystem level.

As mentioned, HW atomic IO is special in this regard. Now for XFS we do rea=
d the limits once at mount time. We could read the limits dynamically inste=
ad, but it still has the TOCTOU problem, above.

Thanks,
John


CONFIDENTIALITY NOTICE: This email and any files attached may contain confi=
dential information and may be restricted from disclosure by corporate conf=
identiality guidelines, or applicable state and federal law. It is intended=
 solely for the use of the person or entity to whom the email was addressed=
. If you are not the intended recipient of this message, be advised that an=
y dissemination, distribution, or use of the contents of this message is st=
rictly prohibited. Please delete this email from your system if you are not=
 the intended recipient.
