Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795276179;
	b=X4pJf/vO/6EAYRjtRIB/F502JrGqD0l+/Z/pY7lm50Dm2vz5Ga3pET1smjVpL8y1hOv8
	 lk/2iWK996Pijxe/82qJpgy3GozHGZ58SecTwGsUSg+XGW6rqK6uYTTvhHfEX1TrHaepI
	 57r2qHzuwyAsstpBeLzjBnXXyMwuXzpVavJjsd+53hkNBgev3jBVSrdq3a6d8rFAXlMEn
	 HcHyi/tEMsYkTQHCQZhwGTWQOhe/X/xVOkeG0zEU88yq8kP9rJLZ0e7BganLlkvnBU693
	 0RFAFGOa+2NsP0j28/3+x9fe4z5fSi3FrzI9yFLv2JUUXWihdcOAO5d5OlSs4CuQUPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795276179;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
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
	bh=7vAH9Ry36tAJQnaZqLPow9AkGPgtnaqOswFsBvsdS8Q=;
	b=MVjucR/JX6LXIOt8Wt2pePMDwnwU+4DdQwnvYf0IbqTRksDK0y27t4PSuaPZLOHpy3uz
	 v+sXfAp9UCcV0wHS8+aE58Hnn4h2F82F5pNTlKYrORVArPrlPjJPXLiL4EhRL8xcY0hQE
	 oGEDc3n7AdZNwfmmMKjKlqxXVJWq69Z0je36Vx4eI5OjKjnsFIVHDrvCFYNO8hl4I0E8n
	 B51cSGWNzBJwNK93Ah6bEGv2GOndvlRgZ+VXrhsvPrSOejfnHzxDmfOTn2kLoSfJlDVAq
	 2ZEpRM0kWvkXCaA0b16wTSc2IaOS18AMt/eMdu8fkJ28D8tV9pnIebUb3a5qyD8iWDw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=solidigm.com;
	spf=fail smtp.mailfrom=solidigm.com;
	dkim=pass header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=ZUqcVhAe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.5
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011005.outbound.protection.outlook.com [52.101.57.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17109606A339;
	Sat, 21 Nov 2026 15:49:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17109606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solidigm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=solidigm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=ZUqcVhAe
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R9o7zEaoN771prNUQbWCPsgq98pEsjDOIAwezROdkwh3ZXAo9VjH9mX4etbN/I0na1AUWyjnzzTL8zAqELjiSyHBi0VA1++kJ9ijmQ72B/KvWjCpJVhSRKKLhTKdoJBBeAYw8EEMV3AzCfgDHxiN7vJbrZGGOE+RKAHOov3jsE5a+r7ZIli81gQlVY6AAUCX8wSpsmNkCxpznxlniibBMa49L0ZJ1SAQTy4pQdLD+tI5EV2Ks2ud3m1OEfNH0fRXR1GnyKeBvNzSDBGrt+70a6GC2LXcpDmwQN/0xBnfD1O4BMZOwsFJwXkFKDBw6HeLH5YyrdkfEDz/QDEv6NKZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vAH9Ry36tAJQnaZqLPow9AkGPgtnaqOswFsBvsdS8Q=;
 b=k9bLe+ARTcW5w0bL76fvELvaWxQw1vuy9yKxHW/mx9Pz/kV2lJCE/59kkOQPi9/BGYvgOBDH+0hO9GkSZeNeTuyEq0z8E+XMi92xsIlZEJlX1cWRkJ+kWFjweXL3phFBaQ+vxJWbJ9z6ngwspOIK4+jvLHrhaOBnhAqXzhqFkC7EF/wG5GsldCiRvDB+KeQAY0QHlPhBuSjgYxWzsR+BOR3T9Bzn8Y2j/bMygf/reJPG6i71hhuibKcIGMTZghTm4lGUR6AAC+MjhzKKHbpk2Vgj2uAwU427ZuXZD9iuVc1c/e1+h8M0zOUnz1fiuMoSADCcPRjLYFVw+p2nccAw9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solidigm.com; dmarc=pass action=none header.from=solidigm.com;
 dkim=pass header.d=solidigm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solidigm.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vAH9Ry36tAJQnaZqLPow9AkGPgtnaqOswFsBvsdS8Q=;
 b=ZUqcVhAe5/R+ZYnh2v++ETTosIC5QEI5ZlfIaaOkS2Je6wfNmrq+cADm54cIKyd+ThYalkTtI79wGQYfAfF7xK/KESRx1F/tGSFO97pGxpLS3sxn2ZpSTN70Bl0uUQudszZWoQ1jHGqKobv4XCiMdusDs5l9BzgVkSa0NSBMBnnHEblZYRaGHf4Tzbwrex4qqkcTYzVB1WHTFOt13lPI9m85QwcTlQ/2pj/OahYziFX0scOq+jWrma1M36VBIUkwb4j9/dbkd+/gqK8rpPkoMw8NeFydcWVFj4N8Dog/9S5xTqjCuPKm3K6VYsTHJ2Sg1GniKC5Qk6yWmLX98NuxZQ==
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 (2603:10b6:408:33f::17) by DM3PPFEACE3F2B7.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 15:47:32 +0000
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368]) by LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368%5]) with mapi id 15.21.0639.011; Sat, 21 Nov 2026
 15:47:32 +0000
From: Wayne Gao <Wayne.Gao1@solidigm.com>
To: "cem@kernel.org" <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Wayne Gao
	<Wayne.Gao1@solidigm.com>
Subject: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Thread-Topic: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Thread-Index: Ad15z2WocV/7eyH8R22b/KBFBzWDVw==
Date: Sat, 21 Nov 2026 15:47:32 +0000
Message-ID:
 <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ActionId=5e320fa8-cd9f-4c5f-9965-cd68baea30a4;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ContentBits=0;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Enabled=true;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Method=Standard;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Name=P2
 Confidential;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SetDate=2026-11-21T15:43:47Z;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SiteId=4bb44aac-867a-4be0-aa34-30794e8470dd;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solidigm.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR10MB997684:EE_|DM3PPFEACE3F2B7:EE_
x-ms-office365-filtering-correlation-id: a27b52c7-58e5-4670-ab94-08df47e6c178
x-ms-exchange-atpmessageproperties: SA
x-etr-sdm: Outbound Disclaimer
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|38070700021|10067099003|5023799004|11063799006|260925021911599003|260925022911599003|260925021311599003|56012099006|261021123027099003|261102123227099003|261009223027099003|261021121427099003|261026140227099003|261022113327099003|261022105027099003|261022075727099003|261026121527099003|261028144727099003|55112099003|18002099003|6133799003;
x-microsoft-antispam-message-info:
 M8RMqgdw0joZ6SH9Wst1aFjDB4EMEq3QWcTuXD+e9g4aWG500epchZTd8QBgfdAWISJnpLOSDmIz0CExJdlVYu2j63k+xVNLif0BYJPvDyq9OTQNDsbp90pBfWrkSCzJxkBB0TLwjf/BSKJqEWohaE2rKdHjJrbsNhre6Z5x6IaQtaN9TXbFDdMyqSVtfeTPFM845K899tRWC7RAALUytFWLRdCTNHJ9UViB7pwjJvAE83e7bmZYxcPBVz0mvA5E1aeucUMHaamUix7SObA6oeMOXoGNCNEve3MmsmjqvBpVX1/Jl2F+Iu9jnBOR5DexzmGAvprejIPbWF9GBl9GPcMMf1mWqh2WAAuNszz680MUfSA8Ax2CmiwoDLAmojjrGgDiZ1kRU912S4Knb/yJ1Tl9HUJt8Vw+Qb21O1ktYZXQbHcXq9G6lWZqID+/iJWBAgKnhFXgCnMpD/3Ob9ORIYqdTKfmncB/vo197ROLR3OEAxON3eL10EEXB1Fhu/W8XQ17RySdpt0bamhQSL87ME209Rkee0VYW4M+NuDRYKzm6CNhECOc+99Bv64Abmn3ceO/571r8uhZtAMBb7MIZJ2nIvpUuzUhnAGRpv5mnsCjLQ4EPUppCaeUg3f5k+U4DLMlaOGhpM+IQP7FxAc2e3v0QZnozZlIY2q6KaAOOj7Rw/m7TYOm6qEDodtcokqpMQZBxMhzttrjA4aQ6sA+E9vc3JTUm4kqhOxRCsnb0w4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR10MB997684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(38070700021)(10067099003)(5023799004)(11063799006)(260925021911599003)(260925022911599003)(260925021311599003)(56012099006)(261021123027099003)(261102123227099003)(261009223027099003)(261021121427099003)(261026140227099003)(261022113327099003)(261022105027099003)(261022075727099003)(261026121527099003)(261028144727099003)(55112099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?5Sep0i+5ThMD5fSd1cSOsNZvQt2FVkLx2TGGU1ElzetI7uE0b9DbuWRVGO?=
 =?iso-8859-1?Q?zu8H0zDNARMACoNoipdI9P03Gik5eZlHjjtAXyUmSc9z6k7tac6JKEgaSR?=
 =?iso-8859-1?Q?X3uj9GDDgFsjL7DS8necnns3MIVGF6/eY3ERqs4PIXxydP4MXNtYG6Y/Zs?=
 =?iso-8859-1?Q?Cq4vAt03/MFVoPQy3Lj/e2UVaDz7gyowfCoYWB8r7JsVpwX/D+lFEm+EcX?=
 =?iso-8859-1?Q?FrzO4BLa2nkLEZnFSMAS/OhHP7s/a53mMaQPGpJMGNyvu/syWqEmkEk+dU?=
 =?iso-8859-1?Q?GQl/sBkLYheN+8lxBiXTa048vSyaSnvbapeE4SW7qxNrrfnrbzKbN9K5x1?=
 =?iso-8859-1?Q?OuNbcPLhXoLbtyhi+bim1dIndt4rQmYFEln7xTsd67LYaBulwlt40Le5Pa?=
 =?iso-8859-1?Q?ZNgzkEsKj9XmCGuYIyEE+Sx9xj9w7WBPLm8ses38bw4IJvRkfVrXwWPVYl?=
 =?iso-8859-1?Q?F7eWbQFAqhQ7plIg1j99Cx/S06EawPWejKbRctWvt4KcGjOcNF5ERWLMqs?=
 =?iso-8859-1?Q?dRH+H0hPaDJMvzgv0QRKVML9oaMzWLUl2+Cn0q9uzmYXOOwcLRFZsKE7uC?=
 =?iso-8859-1?Q?/PYcw5g4/Tz7aIwUJaSVe4uzKY5+5eScYVTdGazVCoZYuCtk8JUmRaeMYP?=
 =?iso-8859-1?Q?NSbogJ9p18GgvnjrfuXiRDlCl1JWkNinJRnZTYjC0bsJLFe/huIzy8kp8x?=
 =?iso-8859-1?Q?9FrfkHhWBqogFSYMyIma96u7lS94tLOZ7MKPAYSy1JeWYvbmiedXw6OHUN?=
 =?iso-8859-1?Q?difGi8je7gz9WaZuapfKOutKwoNzx4Vy5YRQyj5Wkp0MiHTX6AktkAT0LY?=
 =?iso-8859-1?Q?itilHFkJbwy4exXKHB92nSOnPQNEL2Na8swnV/I8E/dE6B9jVtyYO0TIe0?=
 =?iso-8859-1?Q?sfQL47/UwXPMGaKAzq+TGwO77r3O0ctc6xZoO7qOUkK1vhKJIK6BiE1Jxh?=
 =?iso-8859-1?Q?ft8NfmdzkcuDDEpbVkVIc2p3gEdmPQyTT0J5xVJ0fOL6mYb0juQpt2Qghq?=
 =?iso-8859-1?Q?OjXjwAFyf/EUuYmposoHk9+PQMEWjiApAGm6hpkH5+tSMpDtvc6AWLhOth?=
 =?iso-8859-1?Q?y/mEPbBcWnnrzBbL5RTwj3DaamaH73j4iKOl6aZ2D61D8j0OZvTBhUXYBs?=
 =?iso-8859-1?Q?C6fLC+wGcksRdTFIPrf5rO5ZBMrg9t4g09l/sVuhOtoCEQYMJeAeLj1apA?=
 =?iso-8859-1?Q?0rcKBmNoTmwPhBVwR6eFo66i/lLfcJUVaWA7pDWCZ84QBCIvV6RMB+BErZ?=
 =?iso-8859-1?Q?CToBEO6WZ76gFqx0GuJ28ZT/pCk+z1Q40mlZtlSI5PmFWK7qBaJ800fWPG?=
 =?iso-8859-1?Q?SJrTEwSt0mShz1wVlj4/qh4xxoQ34hEfv4p2OQcvnf9NsoYsWJ+KoF87zE?=
 =?iso-8859-1?Q?bo+37qZ+3KwASwGYGI+9YwoW+/BsFxORg97txMU3GXttvl4mFGdrN9wz6K?=
 =?iso-8859-1?Q?XL1jDc6T3xq2wJvAJrG2h3ELNsUzA8gW+f1JmynQNmZxqGoISyM1XAON0c?=
 =?iso-8859-1?Q?meP3qEZ+uFadTUOp9+cWVA2AKNe/Bjsj6sk4dmrd+I4UAhByPWmpGzOurT?=
 =?iso-8859-1?Q?WJmsK63AWyU2gc9roWl67nVD+S47PnuXbQw/bvOmaimjfbHc8kPhkzGz6o?=
 =?iso-8859-1?Q?xwtuz5+dDqubq5DhMPrXrlnO6CM2vgHntHh4+v8N6fyDLcjU1tn5GntmAU?=
 =?iso-8859-1?Q?NYwGs+QOIq1GQsBp7ZsffNL132lO9NFiVCWdUel0ZaB3fsu3F33j/mQOF2?=
 =?iso-8859-1?Q?A6A3huR3Yd6qRihpeX9OmSSfmMZ8aNufEk/BNwricnfyqWZ3t9dtqiHi40?=
 =?iso-8859-1?Q?sm9yxLnBK55CBVfZjGlG2CU2o8Bk7So=3D?=
Content-Type: text/plain; charset="iso-8859-1"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a27b52c7-58e5-4670-ab94-08df47e6c178
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2026 15:47:32.3819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4bb44aac-867a-4be0-aa34-30794e8470dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GixQ9x7et/Yd7RlKfSrJgM+feXXrG+SPSoRcqp6guZmxcjBuO0vVt5JtYec5mToUgPyYpVIhZsHi/8taaUyTzBgxjBCJeDPd3/k3Xg29yGxFAgRF6nqVXiE9UUO8i8kF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFEACE3F2B7



Hardware-capable devices normally prefer hardware atomic writes, making
it difficult to exercise the software CoW path deterministically without
changing file layouts or affecting ordinary writes.

Add a non-debug force_atomic_cow sysfs control for each filesystem.
When enabled, route RWF_ATOMIC writes directly to the existing software
CoW path regardless of hardware eligibility. Keep automatic selection
as the default and reject enabling the control without software atomic
write support.

Sample the setting once per I/O so in-flight requests retain their
selected path. Preserve existing validation, completion and error
handling, and leave non-atomic writes unchanged.

Report no separate optimized atomic write limit while CoW is forced
and document the control's runtime scope and lifetime.

Validation: strict checkpatch passed. Linux kernel build and mounted-XFS
runtime tests have not been run.

Signed-off-by: Wayne Gao <wayne.gao1@solidigm.com>
---
Hi Carlos and XFS developers,

I would appreciate feedback on this proposed interface.

The intended use is a controlled comparison of hardware-backed and
software-backed RWF_ATOMIC writes on the same hardware, without having
to construct misaligned mappings to trigger fallback. The existing
DEBUG-only always_cow control also affects ordinary writes, which
changes the workload being compared.

In particular, I would welcome feedback on:

1. Whether a non-debug, per-filesystem sysfs control is appropriate,
   or whether another existing testing mechanism should be extended.

2. Whether reporting stx_atomic_write_unit_max_opt as zero while
   software CoW is forced is the right behavior.

3. The expected fstests coverage for this control. Intended coverage
   includes off/on/off transitions on hardware-eligible writes,
   per-filesystem isolation, unchanged non-atomic write routing,
   rejection without software atomic write support, and concurrent
   toggling with in-flight I/O.

Linux build, mounted-XFS testing and fstests coverage remain outstanding.
This RFC is primarily requesting interface and semantic feedback, and
does not make runtime performance claims.

Thanks,
Wayne

 Documentation/ABI/testing/sysfs-fs-xfs | 42 ++++++++++++++++++++++++++
 fs/xfs/xfs_file.c                      |  7 +++--
 fs/xfs/xfs_iops.c                      |  4 +++
 fs/xfs/xfs_mount.h                     |  1 +
 fs/xfs/xfs_sysfs.c                     | 33 ++++++++++++++++++++
 5 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/tes=
ting/sysfs-fs-xfs
index 7da4de948..3d0c88df5 100644
--- a/Documentation/ABI/testing/sysfs-fs-xfs
+++ b/Documentation/ABI/testing/sysfs-fs-xfs
@@ -35,3 +35,45 @@ Description:
         outstanding transactions, including regrants due to
         rolling transactions in bytes.
 Users:         xfstests
+
+What:          /sys/fs/xfs/<disk>/force_atomic_cow
+Date:          November 2026
+Contact:       linux-xfs@vger.kernel.org
+Description:
+               Read-write boolean controlling the implementation of atomic
+               writes. The default is 0, which prefers hardware atomic wri=
tes
+               and falls back to software copy-on-write (CoW) when needed.
+               Setting this to 1 forces RWF_ATOMIC writes to use software =
CoW,
+               even when the request satisfies the hardware atomic write
+               limits. Writes without RWF_ATOMIC are unaffected.
+
+               This control is available without CONFIG_XFS_DEBUG and is
+               intended for testing and comparing the atomic write paths.
+               Enabling it requires software atomic write support (current=
ly
+               the reflink feature); otherwise the write returns EOPNOTSUP=
P.
+               Invalid boolean input returns EINVAL. Failed updates leave
+               the setting unchanged.
+
+               The setting belongs to the filesystem instance and is share=
d
+               by all mounts of that instance, including bind mounts. Each
+               atomic write samples it once when selecting its I/O path.
+               Changing it affects subsequent path selections, including
+               writes through already open file descriptors, but does not
+               wait for or redirect I/O that has already selected a path.
+               Drain outstanding I/O before switching for comparisons that
+               require an unambiguous boundary between the two modes.
+
+               Existing atomic write size, alignment and direct I/O
+               requirements still apply. Forced CoW can fail for lack of
+               space even when overwriting allocated data, and RWF_NOWAIT
+               writes can return EAGAIN. Failures are not retried using
+               hardware atomic writes.
+
+               While enabled, statx reports stx_atomic_write_unit_max_opt
+               as 0, meaning that stx_atomic_write_unit_max is the optimiz=
ed
+               limit, with no separate hardware-optimized size range. The
+               other atomic write limits are unchanged.
+
+               The setting survives remounts but is not stored on disk.
+               A newly mounted filesystem instance starts with it disabled=
.
+Users:         xfstests
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8070a07e6..6f45b22e3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -787,10 +787,11 @@ xfs_file_dio_write_atomic(
     const struct iomap_ops     *dops;

     /*
-        * HW offload should be faster, so try that first if it is already
-        * known that the write length is not too large.
+        * Prefer HW offload unless software CoW is forced or the write len=
gth
+        * exceeds the hardware limit.
      */
-       if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
+       if (READ_ONCE(ip->i_mount->m_force_atomic_cow) ||
+           ocount > xfs_inode_buftarg(ip)->bt_awu_max)
         dops =3D &xfs_atomic_write_cow_iomap_ops;
     else
         dops =3D &xfs_direct_write_iomap_ops;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a84a4c1c3..c1720b2c9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -664,6 +664,10 @@ xfs_get_atomic_write_max_opt(
     const unsigned int hw_awu_max =3D xfs_inode_buftarg(ip)->bt_awu_max;
     const xfs_fsize_t  hw_align_max =3D xfs_get_atomic_hw_write_align(ip);

+       /* Forced software writes have no separate hardware-optimized limit=
. */
+       if (READ_ONCE(mp->m_force_atomic_cow))
+               return 0;
+
     /* if the max is 1x block, then just keep behaviour that opt is 0 */
     if (sw_awu_max <=3D mp->m_sb.sb_blocksize)
         return 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index cbcfb89c6..71f574c21 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -239,6 +239,7 @@ typedef struct xfs_mount {
                         /* low free space thresholds */
     unsigned long              m_opstate;      /* dynamic state flags */
     bool                       m_always_cow;
+       bool                    m_force_atomic_cow;
     bool                       m_fail_unmount;
     bool                       m_finobt_nores; /* no per-AG finobt resv. *=
/
     bool                       m_update_sb;    /* sb needs update in mount=
 */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 4a6a8c92c..b8fead80e 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -67,7 +67,40 @@ static const struct sysfs_ops xfs_sysfs_ops =3D {
     .store =3D xfs_sysfs_object_store,
 };

+static inline struct xfs_mount *to_xfs_mount(struct kobject *kobj)
+{
+       return container_of(to_kobj(kobj), struct xfs_mount, m_kobj);
+}
+
+static ssize_t
+force_atomic_cow_store(struct kobject *kobject, const char *buf, size_t co=
unt)
+{
+       struct xfs_mount        *mp =3D to_xfs_mount(kobject);
+       bool            enable;
+       int             ret;
+
+       ret =3D kstrtobool(buf, &enable);
+       if (ret)
+               return ret;
+
+       if (enable && !xfs_can_sw_atomic_write(mp))
+               return -EOPNOTSUPP;
+
+       WRITE_ONCE(mp->m_force_atomic_cow, enable);
+       return count;
+}
+
+static ssize_t
+force_atomic_cow_show(struct kobject *kobject, char *buf)
+{
+       struct xfs_mount        *mp =3D to_xfs_mount(kobject);
+
+       return sysfs_emit(buf, "%d\n", READ_ONCE(mp->m_force_atomic_cow));
+}
+XFS_SYSFS_ATTR_RW(force_atomic_cow);
+
 static struct attribute *xfs_mp_attrs[] =3D {
+       ATTR_LIST(force_atomic_cow),
     NULL,
 };
 ATTRIBUTE_GROUPS(xfs_mp);

base-commit: 5e7b6fe39324913f6416c854c6ed3a1793aaba8e
--
2.54.0.windows.1

Wayne Gao
Principle Storage Solution Architect
wechat: 13636331364
solidigm.com



CONFIDENTIALITY NOTICE: This email and any files attached may contain confi=
dential information and may be restricted from disclosure by corporate conf=
identiality guidelines, or applicable state and federal law. It is intended=
 solely for the use of the person or entity to whom the email was addressed=
. If you are not the intended recipient of this message, be advised that an=
y dissemination, distribution, or use of the contents of this message is st=
rictly prohibited. Please delete this email from your system if you are not=
 the intended recipient.
