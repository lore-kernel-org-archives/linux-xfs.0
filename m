Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98172505AA
	for <linux-xfs@vger.kernel.org>; Wed, 19 Mar 2025 08:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742372371; cv=fail; b=RaivZ25qQ98sEO5YxD2KwUoiyp230NR+rGoXaYzqkE7c+rmk2G9uy1GrZMQ0fSxmuBYs722LEDECZVFJkS2tad40EIk21n2KxzFZ7bZJKqsKvCGMJbKdrhlq96WPJmjQefuLuU7sCUVIugwdipCu7AXzSj008+gPzwaZT+ZPl+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742372371; c=relaxed/simple;
	bh=SLdvKfpgrRhk+4W+TMD/Ru3aHyPzuiDwyeVWWtPrNHU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=TkMX59kPSOfuILQrhoXf3Km4UiK60/aG1OIhXVmhmtjBSECuoMLytNtF9tSGvfhl//ZpG16imdss/4yfK70pN8nh71PA5f3FQzoCFc7KF+ZHq1mhwgHqPHh4MCdwjrAo2Hr1nNxc/B6FFMGNt4wnhmn6ORJlY4U78K5wKQ6sslU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EGtoO7FQ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RAIIPUIZ; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EGtoO7FQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RAIIPUIZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1742372369; x=1773908369;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=SLdvKfpgrRhk+4W+TMD/Ru3aHyPzuiDwyeVWWtPrNHU=;
  b=EGtoO7FQlXN+BPvEKOyieI4feTbJat9/Qmdea12H8Gssj28TbthXzZV3
   Pdd3SKIXxwPa5WdZqK3N5/RFT05QYSebJXL8k7a6JLw2O4qHErjwzMkJi
   pMht1qmKz/nEZ7HkfRw7qJgFycNeZbNd+0W/Hs/ihtE5Binxtl4bqXJYT
   R+8IdCCVWLlnz5PCEcVZpPJC5f6eK/RcJiBZWUT8mwhjxmFnnDVRHDhlA
   qsPr64yGHZ12Nhn7m8WwBoQFmSWSJpsyfrISgYtwglJzmL/xPqKOks9e0
   3kiABzVyJoCCn82hq6vewmrPBhu4vPtNvNpfZm6sSLaE+2QV0x3wzxy+I
   w==;
X-CSE-ConnectionGUID: ABViIEFkSKKsbEe8Ttxq2A==
X-CSE-MsgGUID: 647bfjAETy2bNyHSNVlx6w==
X-IronPort-AV: E=Sophos;i="6.14,259,1736784000"; 
   d="scan'208";a="53952479"
Received: from mail-westus2azlp17010004.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([40.93.10.4])
  by ob1.hgst.iphmx.com with ESMTP; 19 Mar 2025 16:19:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5YsmGgkBeRM8yd2kPgePaoO2CwXPx+jZPM4ar3dbdTEWIT1lC+1nH+HJ+x3plR/zGQPP66k6kPv2lrPZiTlQHlb9lN1oG4y6knIGS3jsBTjtolHgvkUwCOHAJfuAh7BLm7yGX/ktbBaBF4aEfJtpWffW/bBpw3IVngjeu1Pcj2jPrp6+jVFYPQpDA31/aWcrWOBvsRZWOVcBfIT8xpvWG8d1SuSmOx4/UxIwlmfX/apP5RgN3o0xDeKPOkJVUCdlGrWjew3Vp4fD5j+zLVPPBaAgu6V38uXzzIKsaWThX3e8+YGR533xxABB5pRUmknG8hj1RPoJ2kigXZ+UV/mFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZjidRO2Ga+S70lcKctVjtHrRvYKP8SonnBPPtd3F3g=;
 b=RT3Qp45ION3Em2Oc78XJhXf5wMRu0rq6GKh9ykUdCS1AejHVB6N1MncAWS8G54XnTeXXGRLC1y+KFcLB1YakQUlqRN6eqH3hBuHJKi8RrC4R1aVChzJp/LPGe1+gGahjPKc6yASVuWNvodYZJL6QF/6h/QBHRKFxneHyiyTOFM5XODo/NIIoUggBdq/DPspPtwgaG6CGKf12Abn2tP372pV/NtFUw9He+3IApQyIuzVQ97rkvYq9MjlD7CQOlrFhu9sVUtFNFKRLCM7o1oJjsQSOICaVr1qWub8Jx2RXkyCLGMMVGSgvD6z00yetqKu46EAYJ3fyflvdftJWSI1yOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZjidRO2Ga+S70lcKctVjtHrRvYKP8SonnBPPtd3F3g=;
 b=RAIIPUIZreY00vTRwZzKd6h7gKDVM7F0yBufnPzdLreCiFQ+igWQ8eB3tHlYCOrcxoEYtwqT1JimXf3QGZGT5G69BmgYAhAJg0Uv9YGV2qIKa+bTjCdGwIXR71DNyRps+OKn0B0CQwHPfpssZlUtMwKPdg6n4vjVSg8BAmuSFuo=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BY5PR04MB6739.namprd04.prod.outlook.com (2603:10b6:a03:229::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 19 Mar
 2025 08:19:19 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%7]) with mapi id 15.20.8534.031; Wed, 19 Mar 2025
 08:19:19 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [RFC PATCH] xfs: add mount option for zone gc pressure
Thread-Topic: [RFC PATCH] xfs: add mount option for zone gc pressure
Thread-Index: AQHbmKececZlurDM5k6Psoy8DLTbGg==
Date: Wed, 19 Mar 2025 08:19:19 +0000
Message-ID: <20250319081818.6406-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BY5PR04MB6739:EE_
x-ms-office365-filtering-correlation-id: c2208abb-78bb-4e85-0769-08dd66bebf10
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?e1BLS328KEBaWQhZ86SlzDGAOFE5OuQ17C/lHfIu8jwS5cd75NgoZqncGm?=
 =?iso-8859-1?Q?GGhb+kTsdrAG79WiBB2/NDqigbV63/RamHAClrtdi32SDbBd2ZG4XK9qHx?=
 =?iso-8859-1?Q?IYDujOsfXEJNXWME+5CNdgwatOtOtkmPr7wYD+ea151R6mzM+LRGMdVsyj?=
 =?iso-8859-1?Q?Af3qbeT7FjFyjh6aFBkBq1/il0fAKF29V6JxjWWG12VncFx0vAXtVWnKN9?=
 =?iso-8859-1?Q?agvv2+fFoSCWmITj5MDnsyT/yRiBlHR2SWoyo1SuQg5AAuvZ7ZSbcWCVC5?=
 =?iso-8859-1?Q?afJ5N6xdgFygkP6WJeaY7jsRqy1Ia0oRrd86hw0aA4QA/E2HWxY+YC+yjF?=
 =?iso-8859-1?Q?2Sr5DvMxIQiReBJ3dRO+gH+jh3PabjuC0RhuP34UV9biuz18GtU1szj1ZF?=
 =?iso-8859-1?Q?95COjpjryH/BkCvdmhSXz4Odj33e8DjNE3yYdc+MsN+Td2bgegn5EdnOb/?=
 =?iso-8859-1?Q?klM3hMF04PclUMgWaN3BpElyKkvGxqpHmhrmUaaqCzgxVpSP8eKXlWkZ8P?=
 =?iso-8859-1?Q?hQbIUQagG4RrpleztA/kZGVQJePve2zvAxajiaEMuQWKYwb2/xGjNXUAyE?=
 =?iso-8859-1?Q?IbjkoD9K54rfynqaupjnCR3pS/mUAjq79fkAL7WHlCypMWk7PtwQXHPk/g?=
 =?iso-8859-1?Q?DdY4xAozVrjixT9U5WIP9hij4PFhdx1WKPrqDojr6lYGhK4A2WL8+SmYoj?=
 =?iso-8859-1?Q?3xwIc+IZws/HnC9wagc+x4iNxgbhQwi6vbZbeLibpdxJ5oJJgWo/+YM5yR?=
 =?iso-8859-1?Q?nOhedxSGOlcHz5fzbj5I5Lh1znzo4x+ppr4hIvI0eKnqeu59ZCT0X0WSc6?=
 =?iso-8859-1?Q?fAEx+BeP6L15SDuVDmUjxq9u1swxxYs4ZT26mqp9iKkn8g4A63+J6u6Rrh?=
 =?iso-8859-1?Q?f9YwWIiUsX/DCEy3Hf0wsg+FrAF7WjiWTS/xJBL3kGeR9GV4GyTENLPyO8?=
 =?iso-8859-1?Q?Ojvi9ZxaqFEzuNmrvfIaWPwCk6hrU3OEYKXSK86ufnDN8uu8mvSoKMJoD/?=
 =?iso-8859-1?Q?ZrB8C8Z5mQfgUQNPfiohTem/58vB+WZ1lx68VlF4uuXdYwNaolRaCMZC6t?=
 =?iso-8859-1?Q?7xo7U4lMoJk1bQpj8wuHdO5/1PVd9haLGYw2h2tNB8vcyLsasSsESvy4UG?=
 =?iso-8859-1?Q?MrCp9UmNqANegDzM4HxM4y68yZ7rTsc9tO55MyGZrtdg9FnYZaesoG1hdk?=
 =?iso-8859-1?Q?4O1a78ONpP8Io9iuLGi0XNKcRBwmHmlDR5TSPdumpWubwWI4U3e7NnETj5?=
 =?iso-8859-1?Q?cGh7rrexAmKFKjMhJH1gWuHFKFd+vtfR93q+rg/D1aj6R0N7O/PEOLJGmm?=
 =?iso-8859-1?Q?9zPIld++fv6tnTIlnoJAlfIoGxCVj8c3eWJsjYZXzTyVdQY5TUXWVAVE8Q?=
 =?iso-8859-1?Q?0d8aznXqx98rh2CEwvh4P9c2q2pJH7fqRvoWqZglGz2eGpffIw8XToueTP?=
 =?iso-8859-1?Q?t+6wZGnmlSiWlOkjKQK97gFqjyahtZ/QzGOElCKXG2weFwkDg4UYjL8u2l?=
 =?iso-8859-1?Q?VF090v+QXNghKMixkeY4nC?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?aHu1YgdEbUr6n5Th4LOtn6xlYTYdZ2Y+U0s53/jpKjLlXr3zVI1xcV/+Mo?=
 =?iso-8859-1?Q?ICGSxYNJR8xARmEJXz7/uI/kMQGL/59MilvjDhC8907ZzpW5cJ8BVmuDju?=
 =?iso-8859-1?Q?xq9ZMvpre7Ew3whOYhvHY2xd4FC92qqn7of15SS50V2IWvwrc4w+VwcFtW?=
 =?iso-8859-1?Q?KIas5t7l298otdInyh7ndnXrrCuWyurwCj4NpyKdcUYYKhoIA5xd4WlutI?=
 =?iso-8859-1?Q?Bvvni133yfJSjGZOSW5FRZpiLpwsq1YOdEekdnPoNMOmpt/u5T3Ivp3/G0?=
 =?iso-8859-1?Q?5rksuPqFwmWo235eg9QRrO68lKhIyNQJqlY+cImVxf/XNZwcRU/PJcFNCX?=
 =?iso-8859-1?Q?GSmP8khAoABxyDY6LejuYh26Ara8G5/CtH6ShcO+iCddWD2q+o7TzphsEh?=
 =?iso-8859-1?Q?D5qvfyp0txQnJJMjmaw+PnI0P4P4eAUGBlD/Dgs+4lhPr7S4nqdOg/Ln5x?=
 =?iso-8859-1?Q?9BQhhfMjnVyX0wRIx+KdHRSfLhEbEdV6VF059ZI3/Ky8CxpDjPZRLMcNva?=
 =?iso-8859-1?Q?fcvUQNoCTVy+LikzE1bwrqeahbYoxuHmGqgZlepq/4e0aZwlWTuRcXqWSg?=
 =?iso-8859-1?Q?cSRuCgoUXYe87AaHBDTiNqFSUjw9edzdN9SYttRLhKyuARA0gCuWqr/TsK?=
 =?iso-8859-1?Q?1vwyIkER+QSTZp/dAoH9deBUp47QekJo1oP3yca3r+LVRQ020ZI/zyK2zb?=
 =?iso-8859-1?Q?euMOaWNqGjPKg9TeRN3UP+pLYGkd9wtezVqInJ1auo4eBKJbN1pGDhWnS6?=
 =?iso-8859-1?Q?NA2zT1FQPXxmQtQ6tbvpj6Smc/use9pYymTIIsI3doUmtONZtPGVqp6WjO?=
 =?iso-8859-1?Q?ku94J99E9Djht3rCN2d1eoUE3Ppqi4SPTln16A/NqQJSbGa/ySwE+f6b1V?=
 =?iso-8859-1?Q?Fer2+Pct61EeV7TE+O4ZfRmDlDCggVdTOM0IudTgm2UWJBhFN9rEs21tJ+?=
 =?iso-8859-1?Q?bKU5MECyKKITNpwN9KkVylPeOmfM37IUaxtPKS332D7wVK58zrgHsBpfSh?=
 =?iso-8859-1?Q?yf2EmuctN3tFKjy9JWeWRosfRimWGd1eGccbV4gA6pFANcEZDz2fj0528f?=
 =?iso-8859-1?Q?lCwQ3r1s89VYmDnSYEVaJfxrTnj6SRwXqBnUGQW6/3DDuvA8CBqYBKUrhl?=
 =?iso-8859-1?Q?FkeiIAQPMJNYCAK9laJzloqbWLz2KbCH7NBCWrQflYZaFPVoQQIfKExUKG?=
 =?iso-8859-1?Q?G5Leun3BkRR04XADbEnzL1kuzKpCd9csi4W9a1mSH8/sOXuDVX0WYQDqxe?=
 =?iso-8859-1?Q?o48zaVWHYrd08Cn4VqSYUcX4bVfdAIr9RNwEHOhI0uHQoaMYcSxhmh3s0/?=
 =?iso-8859-1?Q?XhDg8AR4UgkN3tPYY6UeuhVF/OBPVOnN0Yjs/PgxUQPaHPvDNklp6VJzBG?=
 =?iso-8859-1?Q?L2av+4JQd21ZSPE4rn1kwO/8s+ZcI7jjHOmpX4nhudvifGj9sZF3nq2sl7?=
 =?iso-8859-1?Q?xNG8nzDBCWhFVBJ6T1n6UZ8OA7MnD2GnsvDgsQFam/JG/JJ/yfECEV40vP?=
 =?iso-8859-1?Q?o40OpiF5ALJTCWvqykp71vI4A09i2zs898EwAWyiOxoWypIgs1+CF6ngjV?=
 =?iso-8859-1?Q?dgIBJoC9bIGR9SDuU/OkLV4MNdUgE0yCy9E/qGNMBAkuedDO9l9vYvoPk7?=
 =?iso-8859-1?Q?clhm1dFre6f4FsxNiRaW+Q1bu7DKNf73CQs2xpPdow93Z6f7IBRmMoJA?=
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
	YyafG/c6jO3WX/L79HKOGZPfns2ExaoLWzd4xn9+IPrAIA5f+0WkXpPIZOxOrDfNnrtsSU3qK2BRp0AO/GpsPO+ZfSTMk3BAKW/1Ww8sLetd9wB3Y5LfkZMVdW+5nMg3G0lVyybK7mH/nIwqD8uXbqlVXRK8eCDPzgu599fFrp1+4FHS8+bMsZX/KbtkJPAMmIyzLEX1g1+hyUtyT4IBt7XQp6Q24/xPMxd5n8CvtR7QuwSda4N2Wu39gIuN+hGR/SIGt657IYHhZxC2OkodN+Vlx2jlOT7lbc3F4wW7nWoI/YxcBFbgMOkAKzBisFQyirss+JQEl3PCAMYOxUvyCq+xLhYg4h1e99BU0ILzsjKMM2vzkMyK7m84QLT7z5rSlIIzLvyzExorDJdH/2b/VnynW7wOSrbzpJSwwfklosrBSXWET2jrbF/SKif7/Ubz/WDlaJL4N3gYtnh1vpRkgQ8+rHReanUhaP57p14YFj3BVngSFQHG1OKM+b48oRz8KoYvh+j1M+nqFGGFWOyzbcS3L0+ZbZr67Yp20MdAUdVicrv/DmD9CUx4Mk0vLYE7KCudnzD8eBPzyoOQQnQ+tI6yx4zyIIpTQEqXhDyPVBRR79xeMPvFfafOQkLGoTjv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2208abb-78bb-4e85-0769-08dd66bebf10
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2025 08:19:19.1762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y0A0osO7puqh3kVf+rB/U6fJFQl7CAKQbcALT/dss/Kc7Ry1nJve/rqH5F/yEpxw0bMDx62LiKcDqEOgmd3uCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6739

Presently we start garbage collection late - when we start running
out of free zones to backfill max_open_zones. This is a reasonable
default as it minimizes write amplification. The longer we wait,
the more blocks are invalidated and reclaim cost less in terms
of blocks to relocate.

Starting this late however introduces a risk of GC being outcompeted
by user writes. If GC can't keep up, user writes will be forced to
wait for free zones with high tail latencies as a result.

This is not a problem under normal circumstances, but if fragmentation
is bad and user write pressure is high (multiple full-throttle
writers) we will "bottom out" of free zones.

To mitigate this, introduce a gc_pressure mount option that lets the
user specify a percentage of how much of the unused space that gc
should keep available for writing. A high value will reclaim more of
the space occupied by unused blocks, creating a larger buffer against
write bursts.

This comes at a cost as write amplification is increased. To
illustrate this using a sample workload, setting gc_pressure to 60%
avoids high (500ms) max latencies while increasing write amplification
by 15%.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

A patch for xfsprogs documenting the option will follow (if it makes
it beyond RFC)

 fs/xfs/xfs_mount.h      |  1 +
 fs/xfs/xfs_super.c      | 14 +++++++++++++-
 fs/xfs/xfs_zone_alloc.c |  5 +++++
 fs/xfs/xfs_zone_gc.c    | 16 ++++++++++++++--
 4 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 799b84220ebb..af595024de00 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -229,6 +229,7 @@ typedef struct xfs_mount {
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	bool			m_update_sb;	/* sb needs update in mount */
 	unsigned int		m_max_open_zones;
+	unsigned int		m_gc_pressure;
=20
 	/*
 	 * Bitsets of per-fs metadata that have been checked and/or are sick.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index af5e63cb6a99..656f228cc3d9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -111,7 +111,7 @@ enum {
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
 	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_max_open_zones,
-	Opt_lifetime, Opt_nolifetime,
+	Opt_lifetime, Opt_nolifetime, Opt_gc_pressure,
 };
=20
 static const struct fs_parameter_spec xfs_fs_parameters[] =3D {
@@ -159,6 +159,7 @@ static const struct fs_parameter_spec xfs_fs_parameters=
[] =3D {
 	fsparam_u32("max_open_zones",	Opt_max_open_zones),
 	fsparam_flag("lifetime",	Opt_lifetime),
 	fsparam_flag("nolifetime",	Opt_nolifetime),
+	fsparam_u32("gc_pressure",	Opt_gc_pressure),
 	{}
 };
=20
@@ -242,6 +243,9 @@ xfs_fs_show_options(
 	if (mp->m_max_open_zones)
 		seq_printf(m, ",max_open_zones=3D%u", mp->m_max_open_zones);
=20
+	if (mp->m_gc_pressure)
+		seq_printf(m, ",gc_pressure=3D%u", mp->m_gc_pressure);
+
 	return 0;
 }
=20
@@ -1100,6 +1104,11 @@ xfs_finish_flags(
 "nolifetime mount option only supported on zoned file systems.");
 			return -EINVAL;
 		}
+		if (mp->m_gc_pressure) {
+			xfs_warn(mp,
+"gc_pressure mount option only supported on zoned file systems.");
+			return -EINVAL;
+		}
 	}
=20
 	return 0;
@@ -1500,6 +1509,9 @@ xfs_fs_parse_param(
 	case Opt_max_open_zones:
 		parsing_mp->m_max_open_zones =3D result.uint_32;
 		return 0;
+	case Opt_gc_pressure:
+		parsing_mp->m_gc_pressure =3D result.uint_32;
+		return 0;
 	case Opt_lifetime:
 		parsing_mp->m_features &=3D ~XFS_FEAT_NOLIFETIME;
 		return 0;
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 734b73470ef9..f75247c16600 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1162,6 +1162,11 @@ xfs_mount_zones(
 		return -EFSCORRUPTED;
 	}
=20
+	if (mp->m_gc_pressure > 100) {
+		xfs_notice(mp, "gc_pressure must not exceed 100 percent.");
+		return -EINVAL;
+	}
+
 	error =3D xfs_calc_open_zones(mp);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index a4abaac0fbc5..002a943860f5 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -162,18 +162,30 @@ struct xfs_zone_gc_data {
=20
 /*
  * We aim to keep enough zones free in stock to fully use the open zone li=
mit
- * for data placement purposes.
+ * for data placement purposes. Additionally, the gc_pressure mount option
+ * can be set to make sure a fraction of the unused/free blocks are availa=
ble
+ * for writing.
  */
 bool
 xfs_zoned_need_gc(
 	struct xfs_mount	*mp)
 {
+	s64			available, free;
+
 	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
 		return false;
-	if (xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE) <
+
+	available =3D xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE);
+
+	if (available <
 	    mp->m_groups[XG_TYPE_RTG].blocks *
 	    (mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
 		return true;
+
+	free =3D xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
+	if (available < div_s64(free * mp->m_gc_pressure, 100))
+		return true;
+
 	return false;
 }
=20
--=20
2.34.1
