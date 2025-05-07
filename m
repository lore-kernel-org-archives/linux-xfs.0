Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595921B87F0;
	Wed,  7 May 2025 10:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746613824; cv=fail; b=UZd/j7sKHcsLCyUZ69H/RYVC3L7zt8Q1JzNMyY4OdJ3wi2jkpR8PwGXXPj+oPLaIgIPVf0TQktfralGht+KJiK2RhxUXG6Xn4/FOMhWVPUK38GmiRyUPV9GJ0Y5vH/cNwyQoH+VuQBqJZ15T68N/xdkX0xFCkMOQ+jJwulTtlvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746613824; c=relaxed/simple;
	bh=UfKeldnXXc8f5MapY1AM9OHujqoqSLVNYExlesmzHp0=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Ly75XMglVkNknvd3MXqv0BThFPrGAA6S0xwk2WWsgt+Y2NXrMirQmEobPVNCyJ7FQZ+BmrLufF0ODVm2MxUYZ8lfFUOvdBJTqSzKvamuVTL3DWjECtOejUI7PukpGU9TcR8X7+266QQp2OIQbAujAS50mkkIaYmYaI8XCNK4dC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QKDnzGjb; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=nTT3lO5U; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QKDnzGjb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nTT3lO5U"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746613822; x=1778149822;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=UfKeldnXXc8f5MapY1AM9OHujqoqSLVNYExlesmzHp0=;
  b=QKDnzGjbCI/oLqq/oWioGlrqnBvm/82hSoNEzSzn+TY4lrvanDRuRBN9
   PY6yAb+bPm00Qtj06i2DhTqV08vvKSYdyd90w3cLCMdNwv6zPjG1S37J2
   ZwlPewq+Mu+F8fPv3ztMo+kV7VSBYy+yIHrT/jQD1vInD+JrFU76PZ7Zh
   wEkjbadozBjzNfjnzF+rcrWOnoPyq1bJ8DifRINEHZmbYjBDpdOU8bA71
   wSskWCnhsQYH1PhWQ6GjqeoB/giFwhOXkpgieTfQYVygn+vYrMTDbTwQm
   zJSjPNU2vPX9RGtHt+1rTZ6Rh7c4y5dSoK/MrpqZ6u8jN7+Fec/ZvIM/+
   Q==;
X-CSE-ConnectionGUID: h1iRLiATT0yr37eogTGjLA==
X-CSE-MsgGUID: 6obf1xeySo+9qsE25Ir1Og==
X-IronPort-AV: E=Sophos;i="6.15,269,1739808000"; 
   d="scan'208";a="79053450"
Received: from mail-northcentralusazlp17013063.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.93.20.63])
  by ob1.hgst.iphmx.com with ESMTP; 07 May 2025 18:30:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s6qI9l75ckjV/PFKXJmS5U6l2vzGKAUF68XZVeYkcW8TpCP6Cwq6eF7x7aQ76Br9VJBYR7Vif9dgosjfelL7Tyv9LegtsNAPYnO9CR48sfwagXStE3H5fjjfVKlUefza5hSwCD0gdqJEFzAFb/0jeodEeVUR4IUSMwHk/FfzdgUwHXLSkeNeyCUSJJoM0+8x+3zMbg5OJJTapA4JXCJj9YKzwETnwYCCtVdFYwWhZ4dYmUOaxNwHlTnLxZgg/kvyKWPueMwsbZnSw9Rqq8qKAuCTf7VSq2Frxo0TIA2H8d/RcaIQXDEorED8f2meP72BLXhOSDoS4t3s1f5c862AXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2gEkDa905HY1Tl2brhlIjjD1vPekIjMtbdNBSw11s6A=;
 b=CYZhgFA3EHB2G5SPijVTB5H6VgWIqlbmHdvBE1tGxc2F4twBqfU8hRLIjz6t+4Bq3UGXXZR/U1qf0vznQm1RlE2EnD73leOvLhlFR+XW37B8qSzNsEGcNFldKQPA03G1DFTSxTZKFP5Dx1W3jyf7Lmn2GPWghXNBxBKgxw9GzoeOzDRXTccvneMVK6TF61LMpBtPHxbKDNyj4R4FuWsZMi1VWh2R9nIk4fgep48dQuDxruWSPW7MMVLqnYyg7KryAlc+2Q1Xr84Rc4/Hzi1ZWJM0SRvJhbvo2/eA0UAjaL8tqwa+6UAMIf/Nq63Ehrbxz4VMxRo4AnmjvPWmoxSfXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gEkDa905HY1Tl2brhlIjjD1vPekIjMtbdNBSw11s6A=;
 b=nTT3lO5UwClSEc34xI0EENOPxHG0QMMXlHc+wEeFEKw+/BmBcJla/Vf+JK92i7Je+uvhDQ1iC9ZTkeZdrzJYkMhA9XWaJ8or8kMf/wuYz0XRHgMESEno5txaaFGto13QRysR7kg5+SVZXRyACL+QKvLdydHO8/kpDn57vMG5JF4=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by IA3PR04MB9087.namprd04.prod.outlook.com (2603:10b6:208:525::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 7 May
 2025 10:30:14 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%6]) with mapi id 15.20.8699.033; Wed, 7 May 2025
 10:30:14 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Zorro Lang <zlang@kernel.org>
CC: "djwong@kernel.org" <djwong@kernel.org>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>, Hans
 Holmberg <Hans.Holmberg@wdc.com>, hch <hch@lst.de>
Subject: [PATCH v3] xfs: test that we can handle spurious zone wp advancements
Thread-Topic: [PATCH v3] xfs: test that we can handle spurious zone wp
 advancements
Thread-Index: AQHbvzsFsH28wJs7r0iv6l2nIDGjiA==
Date: Wed, 7 May 2025 10:30:14 +0000
Message-ID: <20250507102913.13759-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|IA3PR04MB9087:EE_
x-ms-office365-filtering-correlation-id: b763af86-3bda-47e4-e5bc-08dd8d522797
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?APY0VUyQk5MRjys+7h8Juhzy1gFYL0Pa6GZSNto3KciqBuCpGWyMapuMl4?=
 =?iso-8859-1?Q?mSMsouo0jvFrcgRTEBgErmuTi6PIPbS2z4rtIOIDmyUUMNgJWu5MpJJ2m7?=
 =?iso-8859-1?Q?KliBos8Lh38ODmDgB2VuehhIXoSWV2IF6W+1Y3rMHlGmDrAWJvg6QVgiuF?=
 =?iso-8859-1?Q?ERlGfZ8limXBRoRczvYZ914ml+JRQGk8ucZP028VTkxscdVEmWULYpaILI?=
 =?iso-8859-1?Q?8IVpw0gShqGh4B0aGKhByWzdNKoDXjColbAQclsqcKuCGWh+C3UZkzz7Gd?=
 =?iso-8859-1?Q?wWiHvsampSyhIDForbHzpffwNEpDdGc591WghbC1DyRIR81UmNOT15J+K7?=
 =?iso-8859-1?Q?vq5BpNc3JsO/aTW/S35/bopARQb6HNQvw+KB9vfpg5A6f7YIDFJAl6gUNZ?=
 =?iso-8859-1?Q?G2gyeSH5jc5v3KnzV+0aQQMR35nNq3apJEsv9qz1QN4h3/JvNdbQkgggIC?=
 =?iso-8859-1?Q?JI0huIehBl+1gns4OwnNgllFA+2PPip4jG3kvTZSms8u1oJT6bmxRArW7o?=
 =?iso-8859-1?Q?3glFqc0ga4jzCpWyZCdzY8pIon0RgfoGeq7h51ZnufzL7SBckD4jPDIonG?=
 =?iso-8859-1?Q?fXVSg2Myp3Ke5J7t93AOyPWbLsiFfNxPlaDM+DDf3Ji5OQlUR+skz8ykQ5?=
 =?iso-8859-1?Q?mxXDAMtsB7uJzdpkw7PcdzU5Ak5NDX2GPhcG0BteXAFZkBchulbsi6u5XS?=
 =?iso-8859-1?Q?MMzCepgAt611XUz5HOb7YtByksJ3d6YovqQkTv0FouDeb0fzjvcCYjZaK3?=
 =?iso-8859-1?Q?75IZzKZRlB6r3lM8ysWg5BABFmIOu8wT7Pcw9JT23lA4jtmeupJEzhFcqO?=
 =?iso-8859-1?Q?wUt1GfS7u5PtW+AMLW2C5E1skFTiiWhYb6sfeWB9sFFWsvc2mtDODku6d+?=
 =?iso-8859-1?Q?YkeSzhCly6ZnvW2JM6NRsPlI1hRletgDxRjEFw78Zeb9yzFbi2j197QDd2?=
 =?iso-8859-1?Q?KstrmOb3UV7IivEdR66euLAM3Uz7heshmGzf42fTSq2pH3dixL18544vYN?=
 =?iso-8859-1?Q?AUOfsVcbInVIF2xT9rq/Lz49Oo8JUZQ3LkthgHBBVFYCtu04RoPZKAhV6K?=
 =?iso-8859-1?Q?ak9hob7kxwtz17nFcmNlrftoWVsLqcMgavtQ11m2jL3aomYMpQYBj2wzTR?=
 =?iso-8859-1?Q?Q8/YTTVqnysn/UG9puqCMmj9PApddPLpzSagSKjeJrIRKCbGztKmpCZqwm?=
 =?iso-8859-1?Q?+s0H64jy67jChkZ7f9sRn4i73zsNqtbGSA9mo0hahRiOOIavXneMlFTH1b?=
 =?iso-8859-1?Q?/wAWXuvJ62fJHlHUREpkRmfT8aIpUDAxqeXx15o82yPNiuO0qaqmvhrwa2?=
 =?iso-8859-1?Q?OTvj8Z5AqpWGtHAIWS2z1cxT0vTFZpFLZvb95xOQIUKxapEFkJiQTvkPIS?=
 =?iso-8859-1?Q?oj/wAGpRaklmz6NrC0dDP3tkUoTaIhuOvaJIzpWMGqZFDhaXOTn3uvpies?=
 =?iso-8859-1?Q?CaF7g7oY9CjApPiuIbMshESnTrapweZ7+Q48lf+GzP6j8LX1r22RrenktN?=
 =?iso-8859-1?Q?IzzMSin4ETAelCCxMMyX9CNwuc2CwfP80JP0XE9UcK5hhoi5jJAzd2pojD?=
 =?iso-8859-1?Q?sV3ed88=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+I5nmDrZXyKv+h1NmgT+zVYRXnmE0vk7OcWaS+XBPyO9h8cf/dPwyAw+Op?=
 =?iso-8859-1?Q?ujtrbcD6KaNX5+P2RqawIX87vlMWyr6e/V+vb/RcK+A0A390u+ZR3+I5Bu?=
 =?iso-8859-1?Q?B7Zs/gutxbQUs+MDMTwYdWHpSHb37dTdCrlM9WmVE8RQwSZHdJ33E736as?=
 =?iso-8859-1?Q?trlIft3o07NWAYfclm1vTJNCY0N0B2Ntv8IrhxA1z/ktKUHEhF/8VneEQH?=
 =?iso-8859-1?Q?/Hx6qOSFW56utY/OYceRdAhdRdutzAw1zpAL5IluPSqOHme3bplz8qRfRc?=
 =?iso-8859-1?Q?CbTR4X70WtfpMj9ydrVl2VRr9HQIkTm741T1+04pXRUetdkL97b9HKug9X?=
 =?iso-8859-1?Q?sZHPReAGZwb+eDR3ZMp+NLLaaiToD5xJfeIB9MP+T2/+tUDaZWI5YnR0+F?=
 =?iso-8859-1?Q?egLE3VDojzC1NXTfwlNW8J5r2mzRTk0B9EcAEiZ46TqdsuMgxLUc7GVXl0?=
 =?iso-8859-1?Q?nqT5qxeCE3d6nPXQZ3ix/I6ZEADEfD1rKRPe+TRDXTnDFJ7nrYoH9FdatQ?=
 =?iso-8859-1?Q?goCC6zfUGBG2hBinCUvcajdWQYVWcy1Dli+v6M2Z0sbTyy1chMa17gp46s?=
 =?iso-8859-1?Q?MZD5QT7avxnFh9iKlBD/RS/gC1JlOh4/s6h5Iw2yPJFPWFhGuaQzhKUlWs?=
 =?iso-8859-1?Q?BPaKU6ttbDrndOBYbs7oFNnu+LmkNZzKhBg5CY5hCSu+0Sv7dGyNYXFtLz?=
 =?iso-8859-1?Q?x1wNPV445ZLzB2l2WnH8Fq7id5XSWw8zrtVL9EQP+8/OU/KxBKZXIR6mt+?=
 =?iso-8859-1?Q?jjQrhsccjxcnPwLxDfnQAN9Cy+QGjQaUthQDVVVYuX3uy0xpvYyqi7ZJGm?=
 =?iso-8859-1?Q?4LtaXqnl40UXngfJWNIDF+VN5lLyYIDAg4kMbyklqAcpREznUnS9lSlzcI?=
 =?iso-8859-1?Q?68tLHW/J37Dq5yDLAIJ4O+uKnZUA/Qop/Uj69EskK8rHSDalSLI1dKLTdr?=
 =?iso-8859-1?Q?ausAkAdNKoVZDH6JtKGpgA/a9ZpbESfKR6r+kW66ceVmVw1QTfGKto6GWZ?=
 =?iso-8859-1?Q?X1bF+Or20ngEQ7+2Lu9fMT8aLLF1mM+ROJmjWhlC2RKIZpZus1Q/IgsP2W?=
 =?iso-8859-1?Q?M2Lstm82s3R+ywbanfvdzbpmLrrXf8R01uXPt5qNB7QTb4W3I+4OlH5F4L?=
 =?iso-8859-1?Q?DC5zGmimWFugPQ04ungouEd4lIWCJVdb5KqsrywlRZwweBvdGYJK5RKfbr?=
 =?iso-8859-1?Q?0oPxhXk2+SQ6EF33FkLPAzQfkGUFR9+2KbfvEphTyHvHtc0RzX3Rn2xTat?=
 =?iso-8859-1?Q?rwowt6sPvuTVqe/W3weglPbLqtbmQfSzKpK6axGZRDDZpkaLkQWUKpXTxp?=
 =?iso-8859-1?Q?owPonWPlN8oP725MiHLDreUgIF2emZpnZNi12/YB7ivgQaoeFBjxelYGze?=
 =?iso-8859-1?Q?mpdeRpsWJy570qgYC/t/ZzldhgAWveCGhEY9dJEIVNBHpe8/GxR/p/entF?=
 =?iso-8859-1?Q?MOctSotxKhl09kX3s3z9d+AffEXoLj+EUpOZM6GGdCQf9YjFseWjFf39Zs?=
 =?iso-8859-1?Q?v3IA0OcLTssixSgj6eVKiSFwGVySi20sFTl3sXMfFIJsPwF+eRvHaDfdpR?=
 =?iso-8859-1?Q?00IZYbSl6PiGwArO1Cmix25RXvtmhG0kT+MKViuAHCTyEjUfBrMcfBOmT2?=
 =?iso-8859-1?Q?nsleCJAyrn7IjGe93/8EBnugrEdRfr8LDgjXmNRvsL7kf5wZ5opcb0pA?=
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
	W6jbcy/4FFD3er9/tCrvyDATsz5Cs/XhrJMvKpNffDc54S4mpNA5bRiySOdcW7/T8wSNJIncSyJpQoORsihwuBZniZvWM2oDUXQpW67EFoRDhDOlfLC6TK5Fh4QFVJQxMLyfyZ0MfhUupQS1UyPLFuniI00KL1TUW4wZyBwl/LwnzPDCyxRR61k79yNj5xuYUKSSXWIvREezllECVMuoxKW2RSgA8oaLLghLki5+1Wiu6C1zndy87MzYDafg/I7xlNQhVkI0K0gK3VsojeuKy/YwGW9w6SuuR2QxtjdbIcTLSXQO+mv8M4VEJ8hENfPERXyqj9v3aGY4BqtlLOZ9/wd6D3mPTOsLTd4SV/Jd8xDAhvCRCcaig3izjspLOWtodUh6LXOFOufG/In47kHYlBqTXSr0H9Jhu8aIlRYfwM/c1YmQ96GzoDQIWJyF0kkAj74Nk4qt3L/ztQmXe19BIJRrdFk0bcy5/1MNgeHvlwjdJlGo3yh/wh55jsesB7sX+dvKhuWUJvjKuCgNOXknN2alh0gXj5S9ja/kiVncu2tneX4rMIc2HcJL1HTQelkZQMo1T/+Zs5rCORghLC2JaXhFlGL4SUP/vP3xf2NpLXsg8tnHWZEj2TiVUxVXW+AI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b763af86-3bda-47e4-e5bc-08dd8d522797
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2025 10:30:14.7222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bdHYAVBGFiXB9rJeQEFs1SM+/MfJP4ujDiyfuQPH7ce1vzV4Xq3ouhlRny2IdebWW83AKaEOJuwLSjTOyBFs+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9087

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
Changes since v1:
 Added _require_realtime and fixed a white space error based
 on Darrick's review comments.

Changes since v2:
 Make sure we don't fail when the rt section is internal
 Dropped inclusion of common filters and fixed dd parameter ordering

 tests/xfs/4214     | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4214.out |  2 ++
 2 files changed, 73 insertions(+)
 create mode 100755 tests/xfs/4214
 create mode 100644 tests/xfs/4214.out

diff --git a/tests/xfs/4214 b/tests/xfs/4214
new file mode 100755
index 000000000000..f5262a40b229
--- /dev/null
+++ b/tests/xfs/4214
@@ -0,0 +1,71 @@
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
+. ./common/zoned
+
+_require_scratch
+_require_realtime
+
+#
+# Figure out if the rt section is internal or not
+#
+if [ -z "$SCRATCH_RTDEV" ]; then
+	zdev=3D$SCRATCH_DEV
+else
+	zdev=3D$SCRATCH_RTDEV
+fi
+
+_require_zoned_device $zdev
+_require_command "$BLKZONE_PROG" blkzone
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+blksz=3D$(_get_file_block_size $SCRATCH_MNT)
+
+test_file=3D$SCRATCH_MNT/test.dat
+dd if=3D/dev/zero of=3D$test_file bs=3D1M count=3D16 oflag=3Ddirect >> $se=
qres.full 2>&1 \
+	|| _fail "file creation failed"
+
+_scratch_unmount
+
+#
+# Figure out which zone was opened to store the test file and where
+# the write pointer is in that zone
+#
+open_zone=3D$($BLKZONE_PROG report $zdev | \
+	$AWK_PROG '/oi/ { print $2 }' | sed 's/,//')
+open_zone_wp=3D$($BLKZONE_PROG report $zdev | \
+	grep "start: $open_zone" | $AWK_PROG '{ print $8 }')
+wp=3D$(( $open_zone + $open_zone_wp ))
+
+# Advance the write pointer manually by one block
+dd if=3D/dev/zero of=3D$zdev bs=3D$blksz count=3D1 seek=3D$(($wp * 512 / $=
blksz)) \
+	oflag=3Ddirect >> $seqres.full 2>&1 || _fail "wp advancement failed"
+
+_scratch_mount
+_scratch_unmount
+
+# Finish the open zone
+$BLKZONE_PROG finish -c 1 -o $open_zone $zdev
+
+_scratch_mount
+rm $test_file
+_scratch_unmount
+
+# The previously open zone, now finished and unused, should have been rese=
t
+nr_open=3D$($BLKZONE_PROG report $zdev | grep -wc "oi")
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
