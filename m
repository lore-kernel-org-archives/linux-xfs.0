Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883AB20E037;
	Wed, 30 Apr 2025 08:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746002144; cv=fail; b=iLCgcwX75fSCQXWgMTEXdodXCKoX88EOzSOFX9afk+4UAVGQ89rFthPwthAdYqTDr6Vw9SjcJIrYBmTG4Ev1TWWVwxuqRezoWtVb5QUWQCx7RjfGqWRSTyP538jUzYpcrdVb8v+3nhnfE1iHjUqqq98c2ZMIZbwafj9wVqMOPyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746002144; c=relaxed/simple;
	bh=BG5XFRFCUTyjehCrLJomJNLhIYUb1phTcZLZpko3W1g=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SjLYqXbTl9A1YVWS4p8KDM2pTC0SlzWaBbZ++ATTiOjjDh00vedpu4GzgMEbIDuBJfjy4x5VF++QAO9/3tb/U+IgBjsZUOjXhEpPY8HEK1sBpa48T5cuw0+fTmvNYQUjEmM1FHKvs5bU6iatS1XE0+EqBiit9I/g2oCip7jj148=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jVTYgCn/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=VGPEPEdz; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jVTYgCn/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="VGPEPEdz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746002142; x=1777538142;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=BG5XFRFCUTyjehCrLJomJNLhIYUb1phTcZLZpko3W1g=;
  b=jVTYgCn/XDVdM2lWlfzHWCdsyYBLKYwI97Us4yesKIXA9tvke8QS8sWg
   VoMkEQgkD9FL2smYul3E12w8m5zS7Nhfna1hArLi5WEbfiROzWmjp/sbD
   qaubAzpaMw+QsIR2P3f81tewuA3/PG1ywfZSQX7VmB/grQVHWdS+Kadbo
   0lvLV1X0kVpBA5DT3LZCYJ4QIEVW4PqhAwuZDINb7hjDVQ8C6wTxZPMqn
   GTUdurOkjOS5cOkitE/Z5LLgA5FJnqx7kiFYVIdH9bG2wL77TAzO7boxm
   vlyYKmrNLP7Ubn866+79IO5oZ7yznNEiHcWXEkZAuOxvsPoy5BGqTcXMh
   Q==;
X-CSE-ConnectionGUID: OR41zoMPStqyGUEZ5MNqpQ==
X-CSE-MsgGUID: AWPTmug/RPa6A6BzN1dafQ==
X-IronPort-AV: E=Sophos;i="6.15,251,1739808000"; 
   d="scan'208";a="82884628"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2025 16:35:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JJX3WqZfXWS4Zyoz/qGfJJYb8855Yf/fwgK8hWiA7RWZS1d6MlZlJSRAfEDRDLnVqV2rWSmXUy+4nq0W7U6HiKb+jGbN8LP48Ce8Py4jawfqrPq5f1GphO2vZr68uC30ZqZdEtuqXa10Wv3XIZyonQ/xz/Baszjwi4R2f64VviILwhYOuWoY7NODKT7H1+qhOxsRrGrwKJrBdwsebz2KUwzJJqkFNCWZOLrbmzVOGqtTNHqI4DAmrYglkcgsYfdK8zqO6NZ2vk14MmQ/fxKoeLsEmCQB2tDpzCS0DbDQ9Ds/FE91uYUpDFRUWAk4JQ4Xax/Tz7kElzMatKo+JZJttQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GrvlrhX+j1id75M3mAhoeTe5wJVMy6QJR2+zNluqnoQ=;
 b=GfoDtbuaGMaQZJXx6s9bF0+qVwaQLA9G8/XDXe+WfZ0sEzUJl6hnH6vIJd+cebHktJnZcs1VBadDQ22ROiSSCCOB5BdYoFaYbB5N5J4q567riA+WyYeiMlSUXqV7W6DRBbugHxkOyHsP792pq6nvs4+sZSARdnm3VBOjG2NG8x3B8M0Gr1Huc3rVQ7ynqTCFD1PgHS1d56oHbIm7nwQFfjbcICL7M8Uo9Nb0tar84ZNEiDr8aO+U9Ddrfd3ZCvcxfWRCMQMgg9xxkUFuF6XhJRXELUpnL0pH3glqAzWdU2hbIUuz7uwH4jYeueJfO5//+vuCU/WIG3H6tr2kgWLUrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrvlrhX+j1id75M3mAhoeTe5wJVMy6QJR2+zNluqnoQ=;
 b=VGPEPEdzU8zsAwkKe440TkGMHF/AVyTvgCyFEtpmtO6FrE6YvMAeU8aj1UW8/UI0PYOKeLxv4lPe86xK2FlCoVge9VYAYKIaWeXVD0zwZZ3mVsEvTK/CUeyUOh9LTXpBQGd/5jrnB/YxaYrMKwFxvpGS5AT7034YPVdEU874eWo=
Received: from BY1PR04MB8773.namprd04.prod.outlook.com (2603:10b6:a03:532::14)
 by DS1PR04MB9584.namprd04.prod.outlook.com (2603:10b6:8:21f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.30; Wed, 30 Apr
 2025 08:35:34 +0000
Received: from BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5]) by BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5%3]) with mapi id 15.20.8699.012; Wed, 30 Apr 2025
 08:35:34 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>
CC: Dave Chinner <david@fromorbit.com>, "Darrick J . Wong"
	<djwong@kernel.org>, hch <hch@lst.de>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: [PATCH v2] xfs: allow ro mounts if rtdev or logdev are read-only
Thread-Topic: [PATCH v2] xfs: allow ro mounts if rtdev or logdev are read-only
Thread-Index: AQHbuarXY8DDEm4ocEKRemMFUsPP1Q==
Date: Wed, 30 Apr 2025 08:35:34 +0000
Message-ID: <20250430083438.9426-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB8773:EE_|DS1PR04MB9584:EE_
x-ms-office365-filtering-correlation-id: 7141c404-4c95-47a6-d62a-08dd87c1f998
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Htz1axcond+vayplm5fohifm6bBFlOixEd8ibAX395o2Fi1rebJF02WlUv?=
 =?iso-8859-1?Q?NAvaQWs/wIthWVrXSRzvJxWtx+FX9wZ0+EcWlEYS4CobySTN6r45iNuoQc?=
 =?iso-8859-1?Q?s+vQGjiUr5yLNLIbSHEc1ufLHRq891uAle2D9SU8dxXJj9z8B3jK+vR9oH?=
 =?iso-8859-1?Q?TCpC+FFmN8+gnbQRmMGJ0cUl9ctgjgxJXkiAeYY4JJ/Kx11GJv9m7OlGHw?=
 =?iso-8859-1?Q?pq2APN4iMyXdQnquVgdh9I9yrQatA9dA3ffkVR2bSSmmOuqh4dqsg0B/F/?=
 =?iso-8859-1?Q?hDCCtclClliR63NdmYziTK+cPFb1NVtHuSaC2COWmmKFSumhfa56FJKNma?=
 =?iso-8859-1?Q?Lml9tPHiHw1LZGxdT9nBHGl3RKQMdscGNSmvk02fB5VIFm/kZRQ32jTZaw?=
 =?iso-8859-1?Q?2UXSWlzdQnp1SeBZtFAjScBRt4MUaVH09ZGJAJF2ku30nOvuJtAtDLxp67?=
 =?iso-8859-1?Q?qeEu22m+l3vjolshgYUqFgy1Im3tKWor4KPMrkHoJxwqmrUtXgBLclybX7?=
 =?iso-8859-1?Q?BGPgd76wZWKH8WEZ8bevpX/o8aYinAm53IhKn3j5mLGRU9AvBlqm0NqQ6C?=
 =?iso-8859-1?Q?dlfo4NKZj2KxX7GXoV0MZpNS5I343kY/oq37OWRs0h3UEvWMt9pFX8VqTr?=
 =?iso-8859-1?Q?tJjYHh3hmZED9tIB5RW48QdzS5E/I+q0jhFhQXDwwK438gAUP+0FXqmDjD?=
 =?iso-8859-1?Q?KsuRD8Sb8wDiwfsF9nSpdjs+07Hz09n0lPNz6Qz5KXIsO6By2UOU+RXXQ+?=
 =?iso-8859-1?Q?KDQrrWky7jMk9PSQEOhvw/tGNASKt73NOux42B1PM6conyHxJ8Ng8UuA1D?=
 =?iso-8859-1?Q?2HPCHyxesi/N0f+tjeFtW1mDRzGFArgExjEPQEr/rbUTfO3qPYuSdedIaI?=
 =?iso-8859-1?Q?mx7AlK8VSgV2PbJU/1Ol+Y0Se6i4pQd3LMXhpsqh5Wm1JaN5hRuhh5Jv7p?=
 =?iso-8859-1?Q?QPBEu2y8TEx8YwD3gvAdDgdcLXmCBbARyPTfi5yLysVTrVawz85OT6GnAv?=
 =?iso-8859-1?Q?+zHbQhr5/7mL9DP1dWFnGUG168M/pFD+qW5lv5M6uGWwmW42Kdi/PlPGPE?=
 =?iso-8859-1?Q?zi1EnrqJ9XzFpbCrpPjWoZCOt6RAhyKYHLCHqhZBiechbh+upzlN3r6roj?=
 =?iso-8859-1?Q?2SbV5+Hx4mpp78eUOJEvpiClrH8AxPxrW/dfvOXErwb0+k2dG2jUm8iHiR?=
 =?iso-8859-1?Q?k/CnWA6+OM6/a6ZwmPLLfNmf+FngSOj7vGiW1fny8SgF/mEV56HiXkj/c0?=
 =?iso-8859-1?Q?EOLuh9YuoeeGYDw/nbV9PxTfzJ04Uj3y1Q4eJMD2SCHNnLEoUTf0nAzMYh?=
 =?iso-8859-1?Q?pasw2ujkjQAGnDrAXFqA0ZSzYZEzcYrrTi1be7zD8Kvst9PJXlUUBl/W/9?=
 =?iso-8859-1?Q?EQ7EjUCk8jv/9DldrcYpNocrCNy3MWoJc3qHMKGJFRtsjHTqG/HWjCBSlJ?=
 =?iso-8859-1?Q?3zyYHzDLBFdREmBAf/Qfyn9PofQXfhoegkGdpzf7X9NKNMA6lKtC1irREN?=
 =?iso-8859-1?Q?/gnyKVvsT0X9ajsao4q7ECcNGgl1LCDpHO57hNKRFaWeSLxHt64JOXalut?=
 =?iso-8859-1?Q?SmqEX2o=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB8773.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?t1NaNfBm1LGdESsEymhNwm3f3Gaum1z6GmTcC0MLHKwXF71IPSaBE2c9EN?=
 =?iso-8859-1?Q?fcemWdP4gCF2NsiktCW/HPqTHdlx6fqdZeQqPJA6qSK6fl8LkOWhfrocfy?=
 =?iso-8859-1?Q?wJaniXsgmCr9UznBT2E76F+k+/jymFTP+w3ua/BMRepIOOvDQzW8H5U66d?=
 =?iso-8859-1?Q?JbVX2RKnSobSXndFcvDyD5dpN6GC/Ll9/AlpnesMiI6ld1Tk9H3qw0tWm1?=
 =?iso-8859-1?Q?dattLjGFo96Gnf0PsDtUhBos4VaTHxHN+9pshJa/NH3pfGbuij/UlaCfQq?=
 =?iso-8859-1?Q?CIvsP7QC7riQXLgdHeW32qKKyZF3S4S4iDT4pEtR+WhM6M/+1DVZ6hG3S4?=
 =?iso-8859-1?Q?ztkbdCFZIO/JaUtc9R6j+ptRUPmxs9HYdYngG6U2/MsNH2KBMWhugC4v0q?=
 =?iso-8859-1?Q?M+vwom0EEo7Dnb300l+iKpHmlDfX5esYAxHtZVdCZg3+u2WTmuODxi0Nom?=
 =?iso-8859-1?Q?qf7YB4QuS69+aG1VXjqE1wp9Awaue6bsiJSpMaeOAEPPjV7UN4qRc9Xk6J?=
 =?iso-8859-1?Q?JF19N5lD8JhQsp+3o1iX8X0nWXUATU+aU7mykzYm7qIfetqwAkEbSjAsQQ?=
 =?iso-8859-1?Q?gy7zHrhV7uekzamlTWIjoxdBP9IEFmQZOXkJH5Fu60EdvrZeAAl12qhFLP?=
 =?iso-8859-1?Q?uwzEti50iTVp+MeMK7+TCo/BW7y5HHpyPDCkWD8LdGgiPgJtKNqS585Yjn?=
 =?iso-8859-1?Q?8BXV4ADfFvIPDnndkFZcNiOdfF6Y3UyrTVsKGLDl7cKoMMOe/fYHbUW/ma?=
 =?iso-8859-1?Q?wp2N5vP7p7GEdND8zUY0eeWsjdrnaw3Zsp4uUOlncam0VbWath1Ak4Rpge?=
 =?iso-8859-1?Q?GAT4lrK97acJ85DWOkSk9TAmSGGvmB5+iXHy/DauXOmvZFZut2yJtGIbSw?=
 =?iso-8859-1?Q?3B8H/uoFB1AIOvqkzFbynfd32TRcLWDwRJ4Fu2Q2Pb5UI8r3HoO56Ex3ap?=
 =?iso-8859-1?Q?gAFem8aMIYmoVGyoazz1Sc6vHNPOVgyz0tl/T/zknZ+u2TfWcKj9Sp1wKx?=
 =?iso-8859-1?Q?KkrqYQ601PK5P+/h5wsWCSHs0uMHjOQjV6nO5hQWVrtHboVlQ496rNtd+y?=
 =?iso-8859-1?Q?/TjCJVeBX49iio16D3vNzCDM1yMwibLT5HdCOWAuzxaOZdKo2LsVFdYb/c?=
 =?iso-8859-1?Q?ShurFPer5IkHxbKiSKCe8FvwLSal5eWHFE5JjnpWP7oYfaEbOQZ/XdGKZj?=
 =?iso-8859-1?Q?Vrhc7AyVMIXQWErkeXWw8CYIfhrFO95o7oEPC2Wi0FOTWPOgCOOELzcQE7?=
 =?iso-8859-1?Q?m+XjF+xVkjY7gy1pmKE/6YGLdvuhfvy/YiHwUisECVCn+nz1eYfLjMeiU/?=
 =?iso-8859-1?Q?yufrfEFbvkqmnRF7npCgFLOhfy36fMNJL4g8eDOW95rSzlRxSqk+5bcjep?=
 =?iso-8859-1?Q?R4zZegnCoTqx5b0AXCEc+y9ZmYpaMK2oFlzLExG0y6HqqdCWK7Bkf/IEsF?=
 =?iso-8859-1?Q?LRnkmqFWIF1cvpB92jTihtSv6jsziZHzJ8cVYXJciXQlOcqRMkMM7QcQls?=
 =?iso-8859-1?Q?O6FF2pTCZWmsFb2+gQMJW9BT9yFe09SkR3NqfJ1YJBw1DQyNNQ7JTgJdkw?=
 =?iso-8859-1?Q?Bv70zczwO/XChipIpriP/NrpF/A0ZlFr7tZTz3MI0rvNUY/MS//xeRq2hE?=
 =?iso-8859-1?Q?Z/RgjvuqIvDt3k8tTxJsj/9cP0vRKi5eRTI4bC7gg36ivU0CwdvFWq7A?=
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
	Fw5uGJqOIrFgXi8qNCsm6xNjjrjz5Y5vGYZxeDsgtE3K74Dfij5lqwH9vV3PQSBWMLbePHu7GWRcN+Ej+ryTUn+cuj035UdMwonYs/fpkpbEW8CVDjlJ+aUYLBCNrDTsQExWc45ERNDXb4vu/jEKVwiQpSvNamCKr5Ac5fTaXvCrM7bZqu3tP35jwh+nf8V3PlQigwtMA9X8rGosmRXC1z/15umwiWRxqmGiAfbidUxdqDlmYJ4iLHQwT0Y1bNChdtk8ck+YZViOCu0X7gZROzDH6RvTITCuVuZocZbbEZBSyUdLDn2CefQzOTlRecHs6VADNNw3UivsE4kLfBeL3Wdyo4nUsj/EKgKfDd9Zk8thBAzojKdcg3MnnGZ5xFcuc/kdc1rDwXyTcAcz8uD03DmesMC4FQOZ32MwC5ZueeiM4oFb54hsAZ+ae0Lnd5eTlwyJfHaW4q7vvGh4IZHo4k6jl7xu1gI4X+mGdPxEs9eus+7Co0kfchYgCEqqMTZyXESAE4lZP2cLJUx7k9t3fhEbDyFwpvZV/ltzzb+nVeehwbTHIpDjHb8UZA4k+ehC2bX7LK9zD68hy4+KiVFaJDRgheHREp1NgiTHnD8X60gzC91lHREi3mB1p2hTkH8o
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB8773.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7141c404-4c95-47a6-d62a-08dd87c1f998
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 08:35:34.2176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p3UGMmBbr+TsCPmmtSLtTnM7+x6i17uXf/mNEk4Beytc7zpoGUOXrakcqeQKqhVkfshyKV5rIxGzGHImw9eqzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9584

Allow read-only mounts on rtdevs and logdevs that are marked as
read-only and make sure those mounts can't be remounted read-write.

Use the sb_open_mode helper to make sure that we don't try to open
devices with write access enabled for read-only mounts.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

Changes since v1:
 - Switched to using the sb_open_mode helper that does exactly
   what we want.

 fs/xfs/xfs_super.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b2dd0c0bf509..5e456a6073ca 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -380,10 +380,11 @@ xfs_blkdev_get(
 	struct file		**bdev_filep)
 {
 	int			error =3D 0;
+	blk_mode_t		mode;
=20
-	*bdev_filep =3D bdev_file_open_by_path(name,
-		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
-		mp->m_super, &fs_holder_ops);
+	mode =3D sb_open_mode(mp->m_super->s_flags);
+	*bdev_filep =3D bdev_file_open_by_path(name, mode,
+			mp->m_super, &fs_holder_ops);
 	if (IS_ERR(*bdev_filep)) {
 		error =3D PTR_ERR(*bdev_filep);
 		*bdev_filep =3D NULL;
@@ -1969,6 +1970,20 @@ xfs_remount_rw(
 	struct xfs_sb		*sbp =3D &mp->m_sb;
 	int error;
=20
+	if (mp->m_logdev_targp && mp->m_logdev_targp !=3D mp->m_ddev_targp &&
+	    bdev_read_only(mp->m_logdev_targp->bt_bdev)) {
+		xfs_warn(mp,
+			"ro->rw transition prohibited by read-only logdev");
+		return -EACCES;
+	}
+
+	if (mp->m_rtdev_targp &&
+	    bdev_read_only(mp->m_rtdev_targp->bt_bdev)) {
+		xfs_warn(mp,
+			"ro->rw transition prohibited by read-only rtdev");
+		return -EACCES;
+	}
+
 	if (xfs_has_norecovery(mp)) {
 		xfs_warn(mp,
 			"ro->rw transition prohibited on norecovery mount");
--=20
2.34.1
