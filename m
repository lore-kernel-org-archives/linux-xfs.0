Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9490533A00F
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 08:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761813912; cv=fail; b=IenDEfQ/HRgIlxs1BqF0C87bpyIutouF5dPrwZLh/G7hrhxgN6Rz6eGBKdmYFmKX91OkM5d01cZRJnlKPIfWoYHEDxvyOGnGLzckc8ErLaKAgKhiM7eY5C4ApO39Fp/7DOfehURPW/YInGzG8SuXp1TvCYO12nQKr6orfLSgW0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761813912; c=relaxed/simple;
	bh=YVPpDtm+tqBJRXOsDOPT2hyAg5yfh0B4Y9DMeBnvCMs=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=WivqWrtFN2CCDtuHSzpXFyepHq5APJbceQEOGrLldmmwjTxkGKXcmYf6cUBPMRdLKY6BV7jVGCp7WVC+nX8VAZ21UIxVr3f9+8ZJi+h7cJPill4Bv7j0B9IHDNQYWLOXbThcB2jjURMnUywBONDFk6MwU8nb2nRlpgNnQGI5Lsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=czpWljEH; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=B/QQCEuD; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="czpWljEH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="B/QQCEuD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1761813909; x=1793349909;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=YVPpDtm+tqBJRXOsDOPT2hyAg5yfh0B4Y9DMeBnvCMs=;
  b=czpWljEHRTyCD2a3AgBJLB2xowAUMAeAZA/DQnNAmqz6uyzq0mBpiaXv
   D0LvitkkItFU9qjI3slzPH6ZNixT5SajXxa+I5x/uxi0IY6R36NqI2ohS
   CYbUfd4IOyDSdki6ROlqJrh4EwIYcTQIee/jVENswynmy5BC0PbUoejKW
   HVNehDLJ3yWA2JD3sla1P6g77O2HVWv764aa/5DE/V8rOJ5gDd+D4SQCw
   zHPTRhY0ac4F9kWeqIDL4ySR1sNRXNM2hVupk9KnJC8lp4gDii4qgeob1
   E3RJRjAJkOS3mxxUZFCsopFanFJQT1yCnZDjKCjNc99csLEihSl19O2OZ
   w==;
X-CSE-ConnectionGUID: WeNAuBhkQ3anVyI/EX7LWw==
X-CSE-MsgGUID: TZDx9QCbSraW0ArLIBYiNQ==
X-IronPort-AV: E=Sophos;i="6.19,266,1754928000"; 
   d="scan'208";a="131175077"
Received: from mail-eastus2azon11010050.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.50])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2025 16:45:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hffuoo+alNCV93ihtVyZ2dnX7h29LNECo1NYwpfX77Q68exoqswd3LlXphuRyltzlG8Z1TZ1rStBPpnvDl2GS9ogtabK0SoFr8Aj7yczXSak9jK5u4rn4WsT18UPGZ86VUNd21yitIvqNAjgAvK9PR6tuD60yGGBxaLCdlayCXZafiyfe/p0+scGkCEdq5x6fs7aZXb+ahOFJgjfQifVe1CcVzrx1/IaZMDMaj46QkKmXPZDP277jIKERQN4Ka1YHX7OKlYWdfOhEe3n2MxLjT3eq9slxztYAwMji5ekLsnv1kLpdONacTG9hUVgbeK1kWLmiAzy+/WX7B0tRpKI+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9ckt1cKcpyvJX5cxienwMgNdQYRpmVXs+IYem+xG+s=;
 b=oEZRoZF08BmtMi9VWLhBglsFdgc9EZ7pNi00R4qimmAtjM4ifRGONgIPbO3mDYvTVu6tEPe5gf3d9dUI+8GWCxqimS2kY9/96g2+KB5C5zV2+E5jkHzkTAN0yuJZHvalIQ3rHnBnoh5AKr7EHGyjwXEYI3Y7ziKiHpSdcQRhccC272pqP8VLG2CvBDwdNzJM+U7UV3L+Ei49H+3H7XgUQfWUdNFgbyIWEEwF91iGtCYDJ9CzvRR1SuYlUk4M91/+pUOnpkG79HYwqCP8w5/X+fmyjgV3eTeXOrReSi3HXk75m7243sz+LyjqErwmV7yJUoYH2ECchrnU9B+fJxi47A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9ckt1cKcpyvJX5cxienwMgNdQYRpmVXs+IYem+xG+s=;
 b=B/QQCEuDoRRXSxZslHUzkcJAEWoEJmrSxL8ett2dhCto36p5bBrP8giuc0yQUkfi4cI6ChnHHOHhj9mSP5qerBafitVjP4a6BUVtW8s5zWh2pN3ojqBBIsSWe02YmWqqxsbHFBi8GuhhZyZgMs67bq0nuhWnHR0Wz5xsNgTQeKc=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CH0PR04MB8036.namprd04.prod.outlook.com (2603:10b6:610:f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 08:45:06 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9275.011; Thu, 30 Oct 2025
 08:45:05 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: [bug report] fstests generic/774 hang
Thread-Topic: [bug report] fstests generic/774 hang
Thread-Index: AQHcSXl9LlvNthA6Oka+c9m+4a5Isg==
Date: Thu, 30 Oct 2025 08:45:05 +0000
Message-ID: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CH0PR04MB8036:EE_
x-ms-office365-filtering-correlation-id: 013eac29-dc13-4db9-978c-08de17909fd5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|19092799006|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?RFWZv9Skhw/0190fGl2At5TCaEtjfSJOSPLtd/AFhbcO0LGoYCq5ozhR0KHn?=
 =?us-ascii?Q?gNnBzEeb41LjyrpehEpq9pdHGuDG24za1vDPmZH8e5/BlWrArgbFucNkbPdf?=
 =?us-ascii?Q?V4JI/ek3B13dTVVBWH8a7jaDdOczR7WLfWtMdA5qvr8AqK6YPoRHL7GbtLmd?=
 =?us-ascii?Q?4SO8ETjg+n9D9dmgZGVP8SiKnc+hXUQCvtr6sYskXIino9kt4XxrVBw3gZ2I?=
 =?us-ascii?Q?1sGdATDcb7V+t7eqM1e2tFUh08A65T0vOFQOF8ahU4Qvhgq2xxxNYTgZ4RhR?=
 =?us-ascii?Q?KYg29x3WD6IZJmeHSW7YbUBw0QfkmIVOR6aIiQ79p3P+B97PDqV0TKcjydJ1?=
 =?us-ascii?Q?U+iiCBpzGVsQH656qmYXzGeH7iw8HaCsXBTLMxLOoS07jV/ifZUjwl8Erlz8?=
 =?us-ascii?Q?ut6b/MaSPU9LHe2mOjHHXa+puMehsRnng0JdyA2cNomUgTBrDurGpRLh96J5?=
 =?us-ascii?Q?9EXXxJS+EDGi3xapMCFP6OwQHN6/zqDsJWrIEWxoNqUhSuMGNm6QCPDtFpUX?=
 =?us-ascii?Q?HfXEY4vvE89b83p3ojq0i+kFNUKqBGnaP1I3sqGdkg3VR/QD0PTn4TRsTRJb?=
 =?us-ascii?Q?Le1KuEQB0oS3eCYxU+QiXdXrYrlPAwQ2fkJ60E/FBQclQxWdD30xypDRmOhV?=
 =?us-ascii?Q?TN1i7nJSiUgZZw+RXJpEikuke7iMw6hy+3dYqmI3H1Taejg9yP1ULhSQ8en/?=
 =?us-ascii?Q?XIgHjDQKQlnDv3RXf0sLP7cDjpxZXLTAqGrTnmEfZ9iDItkW69YQwHPPrT0+?=
 =?us-ascii?Q?LRqj+UsRA3OGdpRJ1ju8rSDFcOly0ejRs5mMFO5KVGZzTJg+MgAd+Iu+PWeW?=
 =?us-ascii?Q?FtDitVwtWR7G7BPKsI+j+nzi2N2XeHm5LTzMJ33yrBoyrfouaZBqJYmUULTf?=
 =?us-ascii?Q?VTB0/7/3DauRmTrtSzq+snsI06+UcdX+0zqArIJfNHRRDK+oX0a/hxTEsrGo?=
 =?us-ascii?Q?L/r141CwVuvKfKWWmqAbi+dMe9TsUhu9bQw8roB3IX760pt5bOQAgAOt6r1r?=
 =?us-ascii?Q?vgD374nbpJZcnYd0nxZAMNAwwcVWQkYY7oBhx1fGoXs9A78owry9ksnErhEs?=
 =?us-ascii?Q?9B/3/9OPsWYU/MLdwetQM3ue83LIDloZXbeLfx/TYm3Q+m3pkJui6s6qcZ/h?=
 =?us-ascii?Q?ZgWllYGYwSv0t9dJLrfk6UQhUbfL3DSn0ka5eWv4LvNGKZhmHtsEgb/PB+69?=
 =?us-ascii?Q?SCCdNglIobJxOAf26kQqI0IH3PamKGJbE8qd+E0nLbMVNDugKCIqhw9y/Nij?=
 =?us-ascii?Q?xtMLOQDAZ0HSvcs8+8+4kKt6EyIGnrIGr43ClsYv22bskzDIT0Qhzapflw6T?=
 =?us-ascii?Q?CycTDR0UmfcgM4Ybdnf4cNHo3xr+peaXhrnazU5UvAvffTGx8vbqu2hnIh3m?=
 =?us-ascii?Q?UpEcILUGnSUG1qk2Vxwih7hC/jTYWrTdfGd7H+XOs2DARbvjqwepwxWS0i0f?=
 =?us-ascii?Q?eHDN5fshWcmTG3zu1TAIOG+wr673FAE2YqGgFsbJklyg5zcRqBhByWTTvQ6u?=
 =?us-ascii?Q?eGHWWKqzo4xwrPJmEVzI8eGZ0fUquSqnSYbU?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ePEYbuVmFTQP/tnnHcy7pJMc4Mj5uxEVGfn+FiNEDGCTeRYWoB2c6iiqhfrU?=
 =?us-ascii?Q?uX9nIUJJ3cNmyo37Y/3aEjVIdnkG9L9AdVKdqS7n44+1uxf+F/s15gdICOhz?=
 =?us-ascii?Q?zO3kGPTspRNiq4EiG0NzValPgZJfFlvWs0C53Srcy8PgJa4r5lk1Gi0Afw8D?=
 =?us-ascii?Q?nnlvaFlYXUz8SecOUHQutB6G5zLAC2wgOJ19ihz9pSS6L6Udqyk7r/zonC/t?=
 =?us-ascii?Q?ExmDcw+m/If5O00CZLsHYBVTMnzwho77mtRJCc3j9cZ8hyTczhlGkxEP9Ora?=
 =?us-ascii?Q?Xep4mCZj673nJsHrj7d9O6AzKgkKiQzu5gJTySbRB40X3RUWKg/mWyGASbkJ?=
 =?us-ascii?Q?fFsZtHTvaTA+3o45O3etW1OzlGkoOnyGuti6BSyCcg+MvoGIcT2LPZfLYe9O?=
 =?us-ascii?Q?WyrBmchXbYyJrQvMu4rr5ebQFg1cziCCR9brM9auYQHKN5ru9UMwZZV4XNPW?=
 =?us-ascii?Q?S0Ag46KMPRk6X6QUJong3O0W6+5MXMqvmM1OjUHNLKtA15+34a7A5pv5s4LQ?=
 =?us-ascii?Q?eC1EPoUQ2CO6mSMtn/72XDLXZcfvTSpK3FewQNKq++cASTmAbuEN+LDtdBMO?=
 =?us-ascii?Q?bqFCGnHkjZmgfyUNB7ddQBOtu1XccZbywC9wUxiEIPIOCqFYgoUOSDA1T4yU?=
 =?us-ascii?Q?RWRAk+G6k+ECO9xhg4BBMQfFLZFr0eYecmV672Jx+dTdSHryMNMIeEFpzCiv?=
 =?us-ascii?Q?O83YSXGtRD2k89KjQ++C/AkXc8+c3qiXuQJWSd3nONzw2qSNsNZivgPoOHSJ?=
 =?us-ascii?Q?72oYxy1axP1M840Xo+aCQULeJoLsaxdYrIq99fnoiwKLHSLx1/jgra7OPsbz?=
 =?us-ascii?Q?Acfiyfp7TH/ZMwDekWuv587sOgv/WgialB+ce1ju7j4B1KpN/3ZfUot8hZzw?=
 =?us-ascii?Q?lrpS/p5KMJFgAN3vtwHgHqHglC+1Vpb5Xms/zjOw0v/Cel7YQ2Q1XUy5XKpj?=
 =?us-ascii?Q?m/E5p0tdYgRbJVfQ4VtvxRmzU4HnbHZB7tbOB6+8tOyeOXTmxFhs8pVDuv5P?=
 =?us-ascii?Q?YViYJ4E53X4qpBZpBItkwb8GnroyWd4HBS9lQrywQqUDxrNZg6VlNXZJ1aKD?=
 =?us-ascii?Q?pr5aJwKHCBtlCFKB+QqOWHwkv299ThI/J8E9xZ/E73fT3iNkUTQ4IyLgvcJ4?=
 =?us-ascii?Q?3i4paWN9YSUiC0Jz//AnmKBKZw+jNAWAtsQSxj82p8ibceVK6YyFejq4s7H5?=
 =?us-ascii?Q?2AgFc1fZd2UKqq/hYdrESaeGlZWZMa1VcydkV8Hyre1UbhNd34Sd8QNfZ7VO?=
 =?us-ascii?Q?fFxT4ZDt28Q+MQLI+YI/RCV2YRiXg6y5LAXK8LLq6Z6Ugb2J54hRWqsSs+yq?=
 =?us-ascii?Q?I0TWFs6Bh7LKEmPTq9x8HqHbuhkXseZm7uqNlPrFksiGoMTmmiSauDUBNwTL?=
 =?us-ascii?Q?+z13fqfaOx6mZzUeYAAAB6jF9IwRUI2nx5YknFHWRBB7sBc7WF7X/J7y4Mw5?=
 =?us-ascii?Q?/Qh6DNSYfT9RBRTMoVTrwSSxTEag8/ya1jxpz3HTLGtlQnhmcsniUgt+hPkE?=
 =?us-ascii?Q?1MIWq2efxiQQqma4pKu5rFq8PQ1vDvbWhgv0hTw7HbeecpQ2A/1hK4OKSbl5?=
 =?us-ascii?Q?+jjrztutlkCaDqFLPt+UpzmpcGIG91WDQIHaTGmeEMJSpLU1grr9WeDFqk/u?=
 =?us-ascii?Q?K8Zyu0EqrDiKNK6iKmV5Rxo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <499E10E57FB68C46924F56500C61A3C8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0NxGS8fEipUMUxFQMJK82rSRS9fbjEiKuyZnvUfmjEsflpIIbEC6wpzlAotUrSbKRBGhes9PW93MCt9+HVnP+nOrEAo62ys6+lCFhhZdcScQ4L74NNOj6gc2tVhXxARCN6Z1+ls9zuXpB6GMEHqXqlKnsHbDJcPMI0ujAcpETvkc4c7vxZHu5gIQTVfiQbm6kzJ0Et+g9vpIVcziVWPql3u6VVORDhMhX0Ss6J4IUgHfxLsohJyODn0vGZ+iOZOPdrffpOzagF3ng0R9cvjiFnbBgGJ4lTXvgLQvUzq/HeO+TuZXmaHofswGOYFwlvPqdaEGKI3KNUMUrNHllrz+IFftj4ResqyPl+m94c5xVviU2RgW6aFqSi51/8VwokX9t/WNQueFgdvmsnU9qp9U5gOEcDfu4GXl5wYa4+MZXF0ANDVr4wHtoT4taqYZcJQibilPNMJvFh+vdpfiHol7t6lCgPpZecFBFjVw4pUw/5E+Rn/kQfepKfcxptMdRSJ4eX3G9/T6GRUR/Q1vfVci3p10tzsf8PvmVjGJiNgdDtrpYQUHxkJhL0oHwHrm9XhQ+gOiJ91yGeLxVPEkmICpG4bLUWFN3Pcyyx+k8AY3Lw1TCHLrWAgT2MhGb2xbBYGF
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 013eac29-dc13-4db9-978c-08de17909fd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2025 08:45:05.6997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VHZkKc5L+q3HnY5BkwOKgJxNNlX5l26Ny6YUfHeadFaUqHmqP2H4zqF6OLhgZOmk5guEMtpWjlrR7nQQ7DsM0yTalnc3vxXALrzbzyzasvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8036

I observe the fstests test case generic/774 hangs, when I run it for xfs on=
 8GiB
TCMU fileio devices. It was observed with v6.17 and v6.18-rcX kernel versio=
ns.
FYI, here I attach the kernel message log that was taken with v6.18-rc3 ker=
nel
[1]. The hang is recreated in stable manner by repeating the test case a fe=
w
times in my environment.

Actions for fix will be appreciated. If I can do any help, please let me kn=
ow.


[1]

Oct 30 15:11:25 redsun117q unknown: run fstests generic/774 at 2025-10-30 1=
5:11:25
Oct 30 15:11:25 redsun117q kernel: MODE SENSE: unimplemented page/subpage: =
0x0a/0x05
Oct 30 15:11:25 redsun117q kernel: MODE SENSE: unimplemented page/subpage: =
0x0a/0x05
Oct 30 15:11:25 redsun117q kernel: MODE SENSE: unimplemented page/subpage: =
0x0a/0x05
Oct 30 15:11:27 redsun117q kernel: MODE SENSE: unimplemented page/subpage: =
0x0a/0x05
Oct 30 15:11:28 redsun117q kernel: XFS (sdh): Mounting V5 Filesystem f93350=
d1-9b73-448c-bca2-b5b69343922f
Oct 30 15:11:28 redsun117q kernel: XFS (sdh): Ending clean mount
Oct 30 15:11:28 redsun117q kernel: XFS (sdh): Unmounting Filesystem f93350d=
1-9b73-448c-bca2-b5b69343922f
Oct 30 15:11:29 redsun117q kernel: MODE SENSE: unimplemented page/subpage: =
0x0a/0x05
Oct 30 15:11:29 redsun117q kernel: XFS (sdh): Mounting V5 Filesystem 55534b=
79-27e6-4ded-82e3-5c249c68cb4a
Oct 30 15:11:29 redsun117q kernel: XFS (sdh): Ending clean mount
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/0:0:9 blocked for mor=
e than 122 seconds.
Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18=
.0-rc3-kts #3
Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_tim=
eout_secs" disables this message.
Oct 30 15:33:37 redsun117q kernel: task:kworker/0:0     state:D stack:0    =
 pid:9     tgid:9     ppid:2      task_flags:0x4248060 flags:0x00080000
Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_wo=
rk
Oct 30 15:33:37 redsun117q kernel: Call Trace:
Oct 30 15:33:37 redsun117q kernel:  <TASK>
Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? rwsem_optimistic_spin+0x1d1/0x430
Oct 30 15:33:37 redsun117q kernel:  ? do_raw_spin_lock+0x128/0x270
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/=
0x10
Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x33e/0x1df0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10=
/0x10 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/=
0x20
Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __lock_release.isra.0+0x59/0x170
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
Oct 30 15:33:37 redsun117q kernel:  </TASK>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/0:0:9 <writer> blocke=
d on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/1:0:45 blocked for mo=
re than 122 seconds.
Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18=
.0-rc3-kts #3
Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_tim=
eout_secs" disables this message.
Oct 30 15:33:37 redsun117q kernel: task:kworker/1:0     state:D stack:0    =
 pid:45    tgid:45    ppid:2      task_flags:0x4248060 flags:0x00080000
Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_wo=
rk
Oct 30 15:33:37 redsun117q kernel: Call Trace:
Oct 30 15:33:37 redsun117q kernel:  <TASK>
Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? rwsem_optimistic_spin+0x1d1/0x430
Oct 30 15:33:37 redsun117q kernel:  ? do_raw_spin_lock+0x128/0x270
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/=
0x10
Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x33e/0x1df0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10=
/0x10 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entities+0x24b/0x1530
Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? schedule+0x1cc/0x250
Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __lock_release.isra.0+0x59/0x170
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
Oct 30 15:33:37 redsun117q kernel:  </TASK>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/1:0:45 <writer> block=
ed on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/13:0:105 blocked for =
more than 123 seconds.
Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18=
.0-rc3-kts #3
Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_tim=
eout_secs" disables this message.
Oct 30 15:33:37 redsun117q kernel: task:kworker/13:0    state:D stack:0    =
 pid:105   tgid:105   ppid:2      task_flags:0x4248060 flags:0x00080000
Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_wo=
rk
Oct 30 15:33:37 redsun117q kernel: Call Trace:
Oct 30 15:33:37 redsun117q kernel:  <TASK>
Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/=
0x10
Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10=
/0x10 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/=
0x20
Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __lock_release.isra.0+0x59/0x170
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
Oct 30 15:33:37 redsun117q kernel:  </TASK>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/13:0:105 <writer> blo=
cked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/1:1:189 blocked for m=
ore than 123 seconds.
Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18=
.0-rc3-kts #3
Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_tim=
eout_secs" disables this message.
Oct 30 15:33:37 redsun117q kernel: task:kworker/1:1     state:D stack:0    =
 pid:189   tgid:189   ppid:2      task_flags:0x4248060 flags:0x00080000
Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_wo=
rk
Oct 30 15:33:37 redsun117q kernel: Call Trace:
Oct 30 15:33:37 redsun117q kernel:  <TASK>
Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? preempt_schedule_notrace+0x53/0x90
Oct 30 15:33:37 redsun117q kernel:  ? schedule+0xfe/0x250
Oct 30 15:33:37 redsun117q kernel:  ? rcu_is_watching+0x67/0x80
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/=
0x10
Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x482/0x1df0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10=
/0x10 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __try_to_del_timer_sync+0xd7/0x130
Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
Oct 30 15:33:37 redsun117q kernel:  </TASK>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/1:1:189 <writer> bloc=
ked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/13:1:204 blocked for =
more than 123 seconds.
Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18=
.0-rc3-kts #3
Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_tim=
eout_secs" disables this message.
Oct 30 15:33:37 redsun117q kernel: task:kworker/13:1    state:D stack:0    =
 pid:204   tgid:204   ppid:2      task_flags:0x4248060 flags:0x00080000
Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_wo=
rk
Oct 30 15:33:37 redsun117q kernel: Call Trace:
Oct 30 15:33:37 redsun117q kernel:  <TASK>
Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? rwsem_optimistic_spin+0x1d1/0x430
Oct 30 15:33:37 redsun117q kernel:  ? do_raw_spin_lock+0x128/0x270
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/=
0x10
Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x33e/0x1df0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10=
/0x10 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entities+0x24b/0x1530
Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/=
0x20
Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __kthread_parkme+0xb3/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
Oct 30 15:33:37 redsun117q kernel:  </TASK>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/13:1:204 <writer> blo=
cked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/2:1:261 blocked for m=
ore than 123 seconds.
Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18=
.0-rc3-kts #3
Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_tim=
eout_secs" disables this message.
Oct 30 15:33:37 redsun117q kernel: task:kworker/2:1     state:D stack:0    =
 pid:261   tgid:261   ppid:2      task_flags:0x4248060 flags:0x00080000
Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_wo=
rk
Oct 30 15:33:37 redsun117q kernel: Call Trace:
Oct 30 15:33:37 redsun117q kernel:  <TASK>
Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
Oct 30 15:33:37 redsun117q kernel:  ? __kasan_slab_alloc+0x7e/0x90
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/=
0x10
Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x482/0x1df0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10=
/0x10 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/=
0x20
Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __kthread_parkme+0xb3/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
Oct 30 15:33:37 redsun117q kernel:  </TASK>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/2:1:261 <writer> bloc=
ked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/12:4:352 blocked for =
more than 123 seconds.
Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18=
.0-rc3-kts #3
Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_tim=
eout_secs" disables this message.
Oct 30 15:33:37 redsun117q kernel: task:kworker/12:4    state:D stack:0    =
 pid:352   tgid:352   ppid:2      task_flags:0x4248060 flags:0x00080000
Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_wo=
rk
Oct 30 15:33:37 redsun117q kernel: Call Trace:
Oct 30 15:33:37 redsun117q kernel:  <TASK>
Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? kick_pool+0x1a5/0x860
Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/=
0x10
Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10=
/0x10 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/=
0x20
Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
Oct 30 15:33:37 redsun117q kernel:  </TASK>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/12:4:352 <writer> blo=
cked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/3:2:545 blocked for m=
ore than 123 seconds.
Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18=
.0-rc3-kts #3
Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_tim=
eout_secs" disables this message.
Oct 30 15:33:37 redsun117q kernel: task:kworker/3:2     state:D stack:0    =
 pid:545   tgid:545   ppid:2      task_flags:0x4248060 flags:0x00080000
Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_wo=
rk
Oct 30 15:33:37 redsun117q kernel: Call Trace:
Oct 30 15:33:37 redsun117q kernel:  <TASK>
Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? rwsem_optimistic_spin+0x1d1/0x430
Oct 30 15:33:37 redsun117q kernel:  ? do_raw_spin_lock+0x128/0x270
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/=
0x10
Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10=
/0x10 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/=
0x20
Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
Oct 30 15:33:37 redsun117q kernel:  </TASK>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/3:2:545 <writer> bloc=
ked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/2:2:549 blocked for m=
ore than 123 seconds.
Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18=
.0-rc3-kts #3
Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_tim=
eout_secs" disables this message.
Oct 30 15:33:37 redsun117q kernel: task:kworker/2:2     state:D stack:0    =
 pid:549   tgid:549   ppid:2      task_flags:0x4248060 flags:0x00080000
Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_wo=
rk
Oct 30 15:33:37 redsun117q kernel: Call Trace:
Oct 30 15:33:37 redsun117q kernel:  <TASK>
Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? rwsem_optimistic_spin+0x1d1/0x430
Oct 30 15:33:37 redsun117q kernel:  ? do_raw_spin_lock+0x128/0x270
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/=
0x10
Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x33e/0x1df0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10=
/0x10 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/=
0x20
Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
Oct 30 15:33:37 redsun117q kernel:  </TASK>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/2:2:549 <writer> bloc=
ked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/6:2:557 blocked for m=
ore than 123 seconds.
Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18=
.0-rc3-kts #3
Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_tim=
eout_secs" disables this message.
Oct 30 15:33:37 redsun117q kernel: task:kworker/6:2     state:D stack:0    =
 pid:557   tgid:557   ppid:2      task_flags:0x4248060 flags:0x00080000
Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_wo=
rk
Oct 30 15:33:37 redsun117q kernel: Call Trace:
Oct 30 15:33:37 redsun117q kernel:  <TASK>
Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/=
0x10
Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x33e/0x1df0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10=
/0x10 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 =
[xfs]
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/=
0x20
Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
Oct 30 15:33:37 redsun117q kernel:  </TASK>
Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/6:2:557 <writer> bloc=
ked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
Oct 30 15:33:37 redsun117q kernel: Future hung task reports are suppressed,=
 see sysctl kernel.hung_task_warnings
Oct 30 15:33:37 redsun117q kernel: INFO: lockdep is turned off.=
