Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEDD6A33B
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 02:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762309166; cv=fail; b=XwI8fMOtawkM+8SQV+qG5iy6j5IC3pUa/PUpcF+f2dMIivEqx7nkvdGWVCH3a88+IiiGRmwL7fvT6hgFdtDGySacN5EwTd5ghwRNn/4jus3mQSs46VIzhLrjpyxfhX68Q+WhxF5HhBFr3WuqPRHEdtdOp4xTCvOvrvZIg8W0rLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762309166; c=relaxed/simple;
	bh=BsAjWbg3Mm0gVabtv/QMhmyW30NeDicFK7pNNzCXOZk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SHUnZk4Z9NaQCHnEMmtNy65FjHzv7Z/Rxre8HpYhzr2LhxDq1fd+tgIlXCngIcYk/BHp2Hm/+ODtDAuZbcVs22G8GSVFcDyuEc1Hy65IWwqBQ2oVsPJUa1z+6fVC4mu7igAkOmGc3awnmJjdoP/f7fC0PV/cI5rat3VtyFWECqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kXMRV7S6; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=TzXJGCdE; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kXMRV7S6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TzXJGCdE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1762309164; x=1793845164;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BsAjWbg3Mm0gVabtv/QMhmyW30NeDicFK7pNNzCXOZk=;
  b=kXMRV7S6ex6xmTbq3hE/Ps8skgYvDMRJTcm29E/QoVQ/ICfnr20OwwmD
   5ywkI8EnBh0QhYvwIrxVwTQiCM/sxjVXzwMNEHLCcZp6meDQNqyYK2LRq
   WFgfVJ/qVaNlGI0L4ovkuN5IGLvJhZPP9Nb+ZXXknMuyUpQ4pT9N3Pp5j
   Aa7uKtNdc+p2Fl+mcHlgJNMeGRb4gXSkugyZ4zgRz847SZWZqm2Tuyq6G
   9aNrPFpYCq9e4kwYbQXcsaznBzBS3zuuzrV1h2hqZpkJQU3pamEmHxUbW
   yQSgcVC7ygIodfJVpsmk1Q7MoW8y32aoRDcxwjIGBm6CiQpc7FiHPg2vL
   g==;
X-CSE-ConnectionGUID: R+5/L3woQO2JE/TivCdiGg==
X-CSE-MsgGUID: cbBhG0F9Q/i/2UGZT040lQ==
X-IronPort-AV: E=Sophos;i="6.19,280,1754928000"; 
   d="scan'208";a="134519583"
Received: from mail-westusazon11010004.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.4])
  by ob1.hgst.iphmx.com with ESMTP; 05 Nov 2025 10:19:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cDkuGSr/Q5LrcCixNK9ywf0DHq5d7VIh6RZvSO3r/jy9IWpszykFWmg619nnbes7dlflG55XSSu/4U+iwiuNeTyvAaOfOPX3C9wk9v9UjfaM0Od4nghIq+2jFxHSCU9V4tw90z8s4B30dfkDo6M3oAU7C1/2yQ/S3Smlc597Fk2/j/w/l5g+2MaWwwln7Tr1TKq4hOW0pSFbA9z4g7wJN6GCYOq2RKufmU16wDVQMQZKnSaAZ6/eF+bP7DSlLANK+lJ/6vjGwrCGrtooC1OoM3NnI1dyo996EEw1wZ8G/q1gm++Q3OlqfnjR3O+gzgJvm/zHO8bUmNPAZmNdobkZqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGgyn/REdvPdZirQLbojFoytq191DSkc06squYVThiI=;
 b=BljU5CA8yFbYiUWDggGqcjB5VOxXnyJ6KHmkO0ekJSqbjSY3gE+FFHO78/1IQ1j9bLhAol2sUzNUTNFnGbpUDqLnZsj0isHeuIye5CfcjBgQfaRBf8DdFQy4Do7m2+zYgY18HXKqJjV6cNhldfgeeXNHEgK1DG8XBhCNvDFtM4dcsnVvHZc1PHgaXGwMqRnoTKbB362NbG6ZPVcWeTXeMhavRD0TT8gZo55eTT6XepUzqNvmgtsBt44y+oakR3kohUfhfu8hgoHaCGiAv1/dJPx9Y8IuSOJ/8nlG18dqO91Oq+KWmTsm4cVTPolQCoqo7iqmG3CK2WVe1K33dJiP5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGgyn/REdvPdZirQLbojFoytq191DSkc06squYVThiI=;
 b=TzXJGCdEJfBcQfo2B1YxZj0l/AQbydWWk5a3OA7vC6LchPmfzHMP6gwGqntVlVCALoVcaAistxARNfBxKToDCsJqNyrWylIzYWzl/WemfHa0tFH+Br8d/N7Km2F3idc9uPdEzn/hVI7T4FC0YRC73eHo3It3fXoH65bcSabQiU4=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by DS0PR04MB9344.namprd04.prod.outlook.com (2603:10b6:8:1fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Wed, 5 Nov
 2025 02:19:16 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 02:19:16 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, John Garry
	<john.g.garry@oracle.com>, "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
Subject: Re: [bug report] fstests generic/774 hang
Thread-Topic: [bug report] fstests generic/774 hang
Thread-Index: AQHcSXl9LlvNthA6Oka+c9m+4a5IsrTjRJmAgAAdnYA=
Date: Wed, 5 Nov 2025 02:19:16 +0000
Message-ID: <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
In-Reply-To: <20251105003315.GZ196370@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|DS0PR04MB9344:EE_
x-ms-office365-filtering-correlation-id: f331cd41-cefd-4740-d987-08de1c11b845
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?noeLu+Pzbzkp4qPtZ81w6JeqAZJktt92z3b5xkcTqJpA8S2YE5ba0jPjsj3P?=
 =?us-ascii?Q?TjZ1IZh7SqO8PK2fFgnfUHXkJOBzXPReACmH74pg84xnHZ7TVnw2kaEJvFSf?=
 =?us-ascii?Q?u6jJP3lMOPW/pkyR6oDHEbgS0HklGD2rMYTAuFp++fl1TJV5jM5Y5MK/zqnC?=
 =?us-ascii?Q?BVQCivZWk5iamoaHzlHIAEp2S0FUsDx2OGRwJYhFdLdwWqXxq+LUKzHUCkUc?=
 =?us-ascii?Q?ORyS0iDFiZ0MIKZ7Tf5nAoUAPAcEXzbGi9xpP8gZyUePA7EhoobwXgXTZQQu?=
 =?us-ascii?Q?iSBOH/n24vz+ueTJw17ctxSFjXxBiRBa0ByUnXK0kXXss+O2cgNI8GNkWLx4?=
 =?us-ascii?Q?iVQgXdNZIt9QsYvO+f6r0Th0k28HRa0IF5SNorB3l6AZNxZbCWSgoN+OvETr?=
 =?us-ascii?Q?FDMPbTDap0wPWFsRN4IifId3P4UOvjZOLOOkcEy61GvvB9QePC7VTZTm0+ro?=
 =?us-ascii?Q?tf1SLGiC3dO+ABb+ggK7X5EYPqCPIEtFekbYAhHLIazHe/7nArerxL/wNqj2?=
 =?us-ascii?Q?xqoIOauJ/ALVjWLwrHGlxgdkGijfYYFi6X8hZNhO5j7y4mNY5IL8JTxRHaeU?=
 =?us-ascii?Q?JkciUzYrEwS93voLI4u56Ls/brgSsxfZqlGHJjboVInESJcvJf5YOjIW4BUl?=
 =?us-ascii?Q?ICz8yLBcRA6pww+vNDm5n9lC3QOsKSBBZ/mtgwms2xa/FBLadWFN+2NWySAT?=
 =?us-ascii?Q?eOkZ35tj/3IX7Fk8GTEZi1goeITuKT3LzL8fSB76MxM2PoPzTLlRt5ham/jC?=
 =?us-ascii?Q?pOrenpgU8SefKPoFXIJQed9XhYIIXk19s2OIgjVQUT1xYU4YbS79foMITzCd?=
 =?us-ascii?Q?tnr2mWQur0Ck+7bx3cvgWSd2c0oR3Pja4P7G0RhsS2tBMIvnMxC/FSnZJWEj?=
 =?us-ascii?Q?EqGAr7t6GkbaIulIiCiN5BHae1kUK+TKiCfER1eWOzbJ+EyzwtCBtTNXBt0p?=
 =?us-ascii?Q?6qIG3hxI7lKtTGWEWI09kHpvVFcl1NmotL6eeqEyhzZXx43wqGrI6LgKjhMT?=
 =?us-ascii?Q?Cutbc1UsiuCTuzGnjCG/IEdFVcTZLd/+TQzrT7hm+hSAAIQq+nopXcwelS+H?=
 =?us-ascii?Q?T6qdcjhRdBuJ2tbYHmOOwGAufY79iQN0eQWzuLP3yTsfunNwpFzabVk2xVg1?=
 =?us-ascii?Q?pRAkzpb0J8mkPRiP2VH/YCRojTufdVz3fHtLm2ruy/hymiy29QjYiUKeEGkk?=
 =?us-ascii?Q?MGJ8ivVqmjgzyM3geoZhYi2k/mj1G3lm8r8laz6EXeAd7/cBYeKwvA70X3wm?=
 =?us-ascii?Q?qh8tMTjbWxAjV3lmloRoZzFZJE+/c3DwnCLiiB5oD4kOsDodV9pAx0v0BtSe?=
 =?us-ascii?Q?evUkeT65EyA7aa81KI6EGJz49KOkkGBBHtGiT1ri5vF6YnHXxB7upy7MgF/D?=
 =?us-ascii?Q?pJDBlz2v67H1q9NhenDD6ZLBNb0f5xlFGR5DExCkvvz1Qyy/5PQXWlig7GCd?=
 =?us-ascii?Q?1c3gIUMWb9MO0R8IqmmlN6zHKJd3oRzsd/ofb4KNrcFSmADbLD3BG9+ALjnA?=
 =?us-ascii?Q?oSXUr3qxGiFuGL7u7AvFdMsVDetRIsLETpoN?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?WGWVE4cDz1LG+8VYr2EoMxoTjArFQMkfF6Ucf5LhccIvsxDkST+XsRkg6Y5I?=
 =?us-ascii?Q?zgF1DrzAOzsPNpEE+3xis1FyT2o1Epg1zKda2U8jDJWbCdZ8sg4nm16uZU+i?=
 =?us-ascii?Q?S7LPAl1+2pO8pv1SPM2PzRdzGwjjJXVghLu7Fmv2RawGt+mdhdnvkCNYOat0?=
 =?us-ascii?Q?hxz0MC15KEKVhXz46kYEK+D8xLf5VvZYo5WO5FoxvnO8kXrzjRCzuBdynCqA?=
 =?us-ascii?Q?vrSQysdAc3tesGqzp1yOsbztoInmgutM3Tv5HECk2Oa6K6EI35+yqoWS/ucY?=
 =?us-ascii?Q?CTGbtWCBjFAHT3RNhj0Y+1tSx7uqlq96GmWLZdY6gXnADAEcYEVfTBKQSykF?=
 =?us-ascii?Q?1QjVem9vBvmwuFSe3ItFR6feVb7nW5wkZGUWp7oKrl0EIXtBsfczFKoDh/Bk?=
 =?us-ascii?Q?qqP6oDE6azDsHX8n75jDzwliGUCpjuzvhAKrXbALVysmutlNq3DlHDz3bgRd?=
 =?us-ascii?Q?j3gTeH7J3CScUE0kpa3MmS3939C+QeMeD6j1NWwnk9ipw2VF3oNDe8/g1w9Q?=
 =?us-ascii?Q?aisBf7eA8Ft4KUSE/nDLkMUz0LxEsIgpZqXNeQ+lBjO1faT5oFz5+pvKkeHD?=
 =?us-ascii?Q?nEV09Kq8U1mNZmc/bqYJmSqOReURHfgTA1ZxZ1efHWtszKgiizpfDy53Mo1a?=
 =?us-ascii?Q?dWTBvrykX1vJDZKpGfpW9nm0RCFrQ1TjAs9xsNkr8bAymeANwvmYNf43vdDA?=
 =?us-ascii?Q?640GBRb5sjQXV5jU2xLr0JfcqhZiwp4fUnrgdPdV0iD5H+Ufd8v/EA0vGpwX?=
 =?us-ascii?Q?dEIIXfYtU1ag/QM6XcMLzrbpNFsao2vDyrH/dxpxv3Xwesvx0TwfIafQmcbD?=
 =?us-ascii?Q?68rhGOgcIZqz8gokO8apnu0W0hcQ4mZ4iRF9iBV76txW3HVru+a4Tnh6IFTr?=
 =?us-ascii?Q?kHANeozkcxGbY5L1e/j7WFTQbflS2kZFsYcxIROfVDxpLNSHDQt3HDL1yQla?=
 =?us-ascii?Q?qUsugvm1SWyAUr24p7xOe39/zxAIaTv/KzOIBEZpTatLzB9LsAiR2Rh3RTcQ?=
 =?us-ascii?Q?mMjXyKcF3oopieOSQx5yF4djudQoyePfoTvz4eeZ/t6D2ponqYU6RCv5faJA?=
 =?us-ascii?Q?h+WXfrCjJktqSjgBq0qFbGWoJA8Vegs9gmc+Mk9YDmjT1RPGYlQgS0c/40eD?=
 =?us-ascii?Q?+hwIAfb4tJpW02J3FYZEfLkXPA2du5dUQJvWbtX0vQh4zdB0dhLbnqkwmUmG?=
 =?us-ascii?Q?/Qg9nOKvHBTA6KoijN2tpA3MYzul9OUK1WN0gWwcoXgwc0/+BT9N9lViX7I1?=
 =?us-ascii?Q?DCUUgJJ0UNsgUCM/5PLXB8cKjVMCVkb4TKqDxCB5H/+EZLazvvn8lui43UiW?=
 =?us-ascii?Q?T53ppfGgD8vCokGGva6Oz0eA+u5e5SJdJFVuZlxy3TuvAj9ZyGPx3/moCdbj?=
 =?us-ascii?Q?Y8wErfionzSef+NTrJ2SRIxPVZ9Q6PabguVBFZNIiESFPA++RI/5Kge2HXCs?=
 =?us-ascii?Q?kYihpPzReQ8mi7oSKwe8FvVTWOY/TpYyLN6xUHZGoe90WH+PjSXnSo+WnKRv?=
 =?us-ascii?Q?hO4NKe+zExgkoBwYR7vds3sbl9QIFhxVROilITvEWzw59U37ETjjaWG/67D5?=
 =?us-ascii?Q?wfJukaLzVijKcKp6QlGyiy/ov4fDV1krPh9SL0N4lvbqSx2EPG5wvV7QUeh/?=
 =?us-ascii?Q?7m0QR1+TSvVQn2xSQkt4TxA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4DB4EFC6A292444AA75F76A8F7EF712F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ANNqeJFE6zkvoTSImnW6lOwxnaJ9UX/HlQJvgdy737tSyVOZXMKt/KqR9tEVD5oSzFaGd0/Ho732iguRn73NapzCoLV/gWpL//d0R6SqtDlerwt4f7bY8q56QpUEcuukKGrppfTrvzfisjXL7jYSis7WZa1dZ2ELjmQdU6MuOFyl/BD9om1OCnO62FGOZfcFcyVgYtx3B42sN49kldVuR90Om8RrHW3nfDmqPV6LbYYaRK+PN56+ecGlCvr7gUOCp8LII7dn9GaFEjDEK3IKZXA1APG9tiG3wm1yVOTZD5o8EmWZ/t3HHxbUsT604jztVo2j7WOeICXWVq8hS5aWJnnU4kCD2qQekBhuhzj35c8FVKyhmRg6uSp2LLzBqcCg7ZKBm7UaNlGIPF8sfYfDwJrgGpmWi77eclvWe32VOeqQjvyp4T8S+9Rc4UsBIClw9AsDfRv1DSuRmx3XFQdIl2ugzrxmfkfLvjySLQSegSBEqufN8nW2CyGsyUZjQQ6Cw72A30Sh+pVLgPJtBchJRdD2s8OJk1S1mpHBYCJc6mGQywxzZ6iBORTAKyrLD+e+umkst9RdL7Zvmm4h5iTDq8n7F4J9chihzXMZnzngSF5ygiFU4fYePYP8XElZfMYY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f331cd41-cefd-4740-d987-08de1c11b845
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2025 02:19:16.4356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: csHptT3665mQTTqOxDur63QLA9DH005t0FNQzxjsSGgcPNPZ4Sj3iDnHy/IEERdyD+Ppx9OfN10rFhCVldGQ0D+DJr3heAgKauY9N8k44Ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9344

On Nov 04, 2025 / 16:33, Darrick J. Wong wrote:
> [add jogarry/ojaswin since this is a new atomic writes test]
>=20
> On Thu, Oct 30, 2025 at 08:45:05AM +0000, Shinichiro Kawasaki wrote:
> > I observe the fstests test case generic/774 hangs, when I run it for xf=
s on 8GiB
> > TCMU fileio devices. It was observed with v6.17 and v6.18-rcX kernel ve=
rsions.
> > FYI, here I attach the kernel message log that was taken with v6.18-rc3=
 kernel
> > [1]. The hang is recreated in stable manner by repeating the test case =
a few
> > times in my environment.
> >=20
> > Actions for fix will be appreciated. If I can do any help, please let m=
e know.
>=20
> I wonder, does your disk support atomic writes or are we just using the
> software fallback in xfs?

I don't think the disk supports atomic writes. It is just a regular TCMU de=
vice,
and its atomic write related sysfs attributes have value 0:

  $ grep -rne . /sys/block/sdh/queue/ | grep atomic
  /sys/block/sdh/queue/atomic_write_unit_max_bytes:1:0
  /sys/block/sdh/queue/atomic_write_boundary_bytes:1:0
  /sys/block/sdh/queue/atomic_write_max_bytes:1:0
  /sys/block/sdh/queue/atomic_write_unit_min_bytes:1:0

FYI, I attach the all sysfs queue attribute values of the device [2].

> >=20
> > [1]
> >=20
> > Oct 30 15:11:25 redsun117q unknown: run fstests generic/774 at 2025-10-=
30 15:11:25
> > Oct 30 15:11:25 redsun117q kernel: MODE SENSE: unimplemented page/subpa=
ge: 0x0a/0x05
> > Oct 30 15:11:25 redsun117q kernel: MODE SENSE: unimplemented page/subpa=
ge: 0x0a/0x05
> > Oct 30 15:11:25 redsun117q kernel: MODE SENSE: unimplemented page/subpa=
ge: 0x0a/0x05
> > Oct 30 15:11:27 redsun117q kernel: MODE SENSE: unimplemented page/subpa=
ge: 0x0a/0x05
>=20
> My guess is the disk doesn't support atomic writes?

The "MODE SENSE: unimplemented page/subpage" messages are reported to all o=
ther
test cases, like this:

  [495623.282810][T29013] run fstests generic/001 at 2025-11-05 11:10:33
  [495623.377143][T27961] MODE SENSE: unimplemented page/subpage: 0x0a/0x05
  [495623.650270][T28145] MODE SENSE: unimplemented page/subpage: 0x0a/0x05
  [495623.683842][T28157] MODE SENSE: unimplemented page/subpage: 0x0a/0x05
  [495660.733929][T32362] TARGET_CORE[loopback]: Expected Transfer Length: =
0 does not match SCSI CDB Length: 512 for SAM Opcode: 0x8f
  [495662.073182][T32548] XFS (sdg): Unmounting Filesystem 16ee26f7-5a36-4e=
84-a6b9-04d076522519
  [495662.170053][T28145] MODE SENSE: unimplemented page/subpage: 0x0a/0x05
  [495662.439897][T32792] XFS (sdg): Mounting V5 Filesystem 16ee26f7-5a36-4=
e84-a6b9-04d076522519
  [495662.459341][T32792] XFS (sdg): Ending clean mount
  [495662.886657][T32833] XFS (sdg): Unmounting Filesystem 16ee26f7-5a36-4e=
84-a6b9-04d076522519

So I think the messages are irrelevant, probably.


[2] test target device sysfs queue attributes

$ grep -rne . /sys/block/sdh/queue/
/sys/block/sdh/queue/io_poll_delay:1:-1
/sys/block/sdh/queue/max_integrity_segments:1:65535
/sys/block/sdh/queue/zoned:1:none
/sys/block/sdh/queue/scheduler:1:none mq-deadline kyber [bfq]
/sys/block/sdh/queue/io_poll:1:0
/sys/block/sdh/queue/discard_zeroes_data:1:0
/sys/block/sdh/queue/minimum_io_size:1:512
/sys/block/sdh/queue/nr_zones:1:0
/sys/block/sdh/queue/write_same_max_bytes:1:0
/sys/block/sdh/queue/max_segments:1:256
/sys/block/sdh/queue/atomic_write_unit_max_bytes:1:0
/sys/block/sdh/queue/atomic_write_boundary_bytes:1:0
/sys/block/sdh/queue/dax:1:0
/sys/block/sdh/queue/dma_alignment:1:3
/sys/block/sdh/queue/physical_block_size:1:512
/sys/block/sdh/queue/logical_block_size:1:512
/sys/block/sdh/queue/virt_boundary_mask:1:0
/sys/block/sdh/queue/zone_append_max_bytes:1:0
/sys/block/sdh/queue/io_timeout:1:30000
/sys/block/sdh/queue/nr_requests:1:256
/sys/block/sdh/queue/write_stream_granularity:1:0
/sys/block/sdh/queue/iostats_passthrough:1:0
/sys/block/sdh/queue/write_cache:1:write back
/sys/block/sdh/queue/stable_writes:1:0
/sys/block/sdh/queue/max_segment_size:1:65536
/sys/block/sdh/queue/max_write_streams:1:0
/sys/block/sdh/queue/write_zeroes_unmap_max_bytes:1:0
/sys/block/sdh/queue/rotational:1:1
/sys/block/sdh/queue/discard_max_bytes:1:0
/sys/block/sdh/queue/write_zeroes_unmap_max_hw_bytes:1:0
/sys/block/sdh/queue/atomic_write_max_bytes:1:0
/sys/block/sdh/queue/add_random:1:1
/sys/block/sdh/queue/discard_max_hw_bytes:1:0
/sys/block/sdh/queue/optimal_io_size:1:8388608
/sys/block/sdh/queue/chunk_sectors:1:0
/sys/block/sdh/queue/iosched/fifo_expire_async:1:250
/sys/block/sdh/queue/iosched/back_seek_penalty:1:2
/sys/block/sdh/queue/iosched/timeout_sync:1:125
/sys/block/sdh/queue/iosched/back_seek_max:1:16384
/sys/block/sdh/queue/iosched/low_latency:1:1
/sys/block/sdh/queue/iosched/strict_guarantees:1:0
/sys/block/sdh/queue/iosched/slice_idle_us:1:8000
/sys/block/sdh/queue/iosched/fifo_expire_sync:1:125
/sys/block/sdh/queue/iosched/slice_idle:1:8
/sys/block/sdh/queue/iosched/max_budget:1:0
/sys/block/sdh/queue/read_ahead_kb:1:16384
/sys/block/sdh/queue/max_discard_segments:1:1
/sys/block/sdh/queue/write_zeroes_max_bytes:1:0
/sys/block/sdh/queue/nomerges:1:0
/sys/block/sdh/queue/zone_write_granularity:1:0
/sys/block/sdh/queue/wbt_lat_usec:1:0
/sys/block/sdh/queue/fua:1:1
/sys/block/sdh/queue/discard_granularity:1:0
/sys/block/sdh/queue/rq_affinity:1:1
/sys/block/sdh/queue/max_sectors_kb:1:8192
/sys/block/sdh/queue/hw_sector_size:1:512
/sys/block/sdh/queue/max_hw_sectors_kb:1:32767
/sys/block/sdh/queue/iostats:1:1
/sys/block/sdh/queue/atomic_write_unit_min_bytes:1:0=
