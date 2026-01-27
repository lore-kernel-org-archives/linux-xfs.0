Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E18227CB0A;
	Tue, 27 Jan 2026 01:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769477915; cv=fail; b=MFYSETEtb5fB2uxSTv8Gg6nISsfSK6uG2m4WY6cFIg5VR6xbcmGgO0hVkVhWex0YYYVpd6yNDftcxngjU8l6fzBBuH7LxWerZ2bt+VXe0mbkT8OYqPfr0uzVtyfQXS7pcSi2gM7URpyLCcFG1uWPB+6I6EN+UWrYhQGOiRhkpYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769477915; c=relaxed/simple;
	bh=jJ6FztQGi7EFCHmw2SHadEJ2tGsfyxqy1gpGbykYNlw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GkmdQaNJmO5d9cJBhx3LxvHxS9/C/vbvpsESAL3FDAOvYGwQrhlS180O5XTPS7f/KfaZ0t2Gc2QI2QKqMwwKf0aFR5jZFeGeQVtdlND4qkjKU/dgCzeBs1u4M8RawHjtbkkjWM2+WiYp98JfYt2Bo+/8XSb8yCECpJyYPhFPumI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RXIbLZPN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=p2xyy21m; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RXIbLZPN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="p2xyy21m"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769477913; x=1801013913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jJ6FztQGi7EFCHmw2SHadEJ2tGsfyxqy1gpGbykYNlw=;
  b=RXIbLZPNzIZzwvAJydFcO3X0HshMBeeLa8G6INo/l5G1ZOTG4nCufYJk
   f6ldQT0uvXc1F6vdqMqW3wyi9DvDMfLuySlBkAvHGitIIcGLlPxTmO6jV
   wXg9kU/v0VDzA699AD4+x+UXaxlytSmeTyG7qyz6DeEBl16EWc8hm+52E
   YwpM/FUH1tvrIGQwwQooss01fAIFAve0KTfn5aomJDkH1FKbv2fNDGJhR
   9PWKRhaSVi+BpeS+mkM1XOmzNT7rIMqRt0mTNjFrsJAXDeL/IyJLoJe/S
   bIiiEXmDVhokXFFl0XFEGPTIHxBFKEkLl9pDgD/z8Nq0Yq5FgL8vcYvXB
   g==;
X-CSE-ConnectionGUID: +EullI+7QRifv/tsZFHlfA==
X-CSE-MsgGUID: 44Fkg2cOSHyy9o7WRJ4Yew==
X-IronPort-AV: E=Sophos;i="6.21,256,1763395200"; 
   d="scan'208";a="139249296"
Received: from mail-westus3azon11012044.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.44])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jan 2026 09:38:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e6pfvrNPsCz9A5A2i8qs4PJLYe6uOaKm4Vz67M0NERukQE/DYQmk5uvkzk0YVaZ2KlXwSnVOgq1lPidCLq+isXYh9taK0iQnla+a/kYVSaHvQs1Qt9zrt1VTvnHwkZSVyGUzxWTAg/wDkYJG7Hqe7Ta8iCy5rS9YQCZD0EPfzcNMwDq6cXrGgU8GAKpTzBqkw8Ka9fdwhnxr4c7IegveDJ3Y8EMH9UwJAdupP3/FRKcvnsub2hha3KmxK/4iyvDq6/8x2DsQ+Doz1690ocD2T1rhXvczygYADAjBJDdHXts4tqACmQIVIfY3Ggb+sLBwprP7KIfXVsaGs5ywiKVARg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJ6FztQGi7EFCHmw2SHadEJ2tGsfyxqy1gpGbykYNlw=;
 b=i96GAfUpyGno0THtjGXWysjMvcBMlNWOVAvhtQLXNWhrdlwCCkzWVo3qVQ2NDnobDSlNQbIt8SxulnQYNCHQuIA1wzgqyjhCwXJ9tP1SKGnfIF+XIG5H+QSMHZKpFf1BTB+n6FI7St1AqhcEZYfHpGxLX8upMyIcufYDGy0NEGlX0Ozy5j1hWbjgBg0tDb9YTB/npXepsGis2rU4x8DQolWyRgQDqmPt/TOxVirIcMwABA/gYJhHDxBuvES82yiV5GdCGhgo3AZsWD6S69N/8lz9Y0nUJr/V8Bio6FqMU6iMzK1ehzqEskdmb5soab7Eaf+Xs/X4mpL9jbdVT5v2Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJ6FztQGi7EFCHmw2SHadEJ2tGsfyxqy1gpGbykYNlw=;
 b=p2xyy21mWFtMUcZA6qgF3/1mCcUN+p4GhN2+PIaQbWoVWV+e2deBwaliv5/SaBuU/eeBVWfhFfZ4ZJtKK9jR2lok1b4/H4q9oNOpSnSksb12sJytfIlN6/ZdW7EbL+jgFFMCsT8avXo+m7jm75SrAMjZWhD58xcERVh0LrScHzk=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by BL3PR04MB8010.namprd04.prod.outlook.com (2603:10b6:208:345::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.5; Tue, 27 Jan
 2026 01:38:24 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9564.001; Tue, 27 Jan 2026
 01:38:24 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Dave Chinner <david@fromorbit.com>
CC: "rcu@vger.kernel.org" <rcu@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, hch <hch@lst.de>
Subject: Re: rcu stalls during fstests runs for xfs
Thread-Topic: rcu stalls during fstests runs for xfs
Thread-Index: AQHcjrclowh1moKuUEq8Mwy02Ri3kbVlExSAgAAqxIA=
Date: Tue, 27 Jan 2026 01:38:24 +0000
Message-ID: <aXgVljuSfUomyikG@shinmob>
References: <aXdO52wh2rqTUi1E@shinmob> <aXfzNW7cf2ReVDA4@dread.disaster.area>
In-Reply-To: <aXfzNW7cf2ReVDA4@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|BL3PR04MB8010:EE_
x-ms-office365-filtering-correlation-id: fd3a01ce-c901-438d-57bc-08de5d44c2dd
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?EZoBv6pTMRkJHxQ9TRRWfGhgJZhfYC0/nNinD0ITGdturBKBpgcGX+Tb25Ze?=
 =?us-ascii?Q?ADRLfuzqPeJvQeBj6TiYVLypLYWybWbMPxb/7MAqdQLA8tg2leZWTTockXCc?=
 =?us-ascii?Q?5+3zq1fslUv77xeI7TSI08tffh63Dp8ri37l91ACoBny6RPLZFT2CcLEPZw0?=
 =?us-ascii?Q?d7lYI1kTjuCsio5bXUjS8qGv86BvQ6OY+xc0aIdJ26WLEh+Dq/hJVzS5Ayx8?=
 =?us-ascii?Q?OXbqYTLY4S2ufCZ33dFzrRxQ1hvpxiis+Fe85zh9grkxihKUZoHwAjfzlYEa?=
 =?us-ascii?Q?1RJjfcLLwqqMYj8sK8PYJfZaDDsGA01KJfaUtuT8Lsbfa7tckcxqJUrPTWLK?=
 =?us-ascii?Q?KlWnG46KW2zY4zfPXpjfeN9afQUdLgXo7p1Q0V6MKbTCwiQzWejUPaYRUJEG?=
 =?us-ascii?Q?BvnEc5UmxL6dTPN4PG/bByfoOw/SGJHkUNb988sdyPYGitXcH8B0PO+7OwDX?=
 =?us-ascii?Q?Jz9LMCps5iqJXt9ohVLf/SE+DbeEehVx0PNI3kiQiYbhffZuiN9VKjK/TxB1?=
 =?us-ascii?Q?nK0iICzo+Ni1uAz4hKteWPKcLrqDRWRgTfuVb6Cwy/Ja20Dew5m6xgJ7yFRJ?=
 =?us-ascii?Q?tjk4sK/POb/shdfv9I5UB019JfXzbQtS5UFsPbFztacGBTFqUe1ErV6QJnnd?=
 =?us-ascii?Q?TWPEmGzQkwi7PWwdJXLQxgt/kDtLVynVPkB2bDCXKIAGff/zTdDD7gmZH/gk?=
 =?us-ascii?Q?h5uoX7u4KViHNIewMBnYxdoGQ0eszVnr0DL1wg4cbooOigQbmkr0+x5hUE6E?=
 =?us-ascii?Q?+RpOfr4ZcHrO6MHQcgrfD4HSbvfBvOXK5OokE8oTKyN+oT1ufeSo62QKDVOy?=
 =?us-ascii?Q?BrLXV8k1gpE4AWQGDCZNYtAZNOgcd7v9s+Snix07zIsRyoybypprV1wNMiHM?=
 =?us-ascii?Q?hxEPpVVzn4tJ0B7F5erwH2S/2VhwLKDX8dU75D5fxt/QyDARKDbMGfM1iI9R?=
 =?us-ascii?Q?qOoBkaDr/kGKVqPpDj/7ybF0HXKSn+5Nmz82YeSPE/keSMX9KWhT5rgFim/s?=
 =?us-ascii?Q?JrNpLZKLZsKKJwYVuSEY1xPsEEv6fRiVW7w5Q+Miu9rNLqs1n2n0awkDTPWT?=
 =?us-ascii?Q?j6XPy+d7JFaRt/bslDpGYac390wgGKUSIWZhUBBHIz9IUM36bxZOCtSmUl4r?=
 =?us-ascii?Q?ZSlrfaamL+bu3til2Ve1OT00ocvWOKcVcKbEQ9zKxc4bqpz5gnPnS/9nDAYp?=
 =?us-ascii?Q?k9U0YddMZs3LFfRso36gzrCCvLKVaIUrQQtjnjeq4WvdJQqYJkoHhzTqt2cu?=
 =?us-ascii?Q?MWnQWtAYzo1SQX1ZxOGsAZF5N8qEpEKWuiZm+IPIzVTJ2Azy5OqtJkCGvdI+?=
 =?us-ascii?Q?K+WMk4OxfEGkppDAXK/g3ycy8+2XPb9C/L9/I3acE16rgSVe2PJ7L3kJYdT4?=
 =?us-ascii?Q?u9nAfhCK32mKwlb7fl2P3URBbRI+6xuTRrxtc6wYiHOTcp20Vmp73tgiTg1Q?=
 =?us-ascii?Q?ZFVpWkZa5PG0rSzjcH3WWJvYfkGvog9GWz6NOHLkYFuMsl7pc5QHoG9sAJsq?=
 =?us-ascii?Q?iIFwwpPLBq8mrt+jhNtrspcLOSwSUI8Wgy28OMronkzcbHdnwTKOiETvC/h6?=
 =?us-ascii?Q?KnyBH6yNCnX7AhVF2LLikLuQEHPIhRQ0D2nWVaDdZPg7b2PXa6f+fiAvT1Hz?=
 =?us-ascii?Q?xAjRug+R/uJrz7Pwr/eRuVY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?M+eLAUvd1+FemCNAgCnz76LYtAFoDFJcQw4wgxak32cB3j8DJiVOirPv9MFm?=
 =?us-ascii?Q?6j6SKN3F7tGTiaMUaKT13IqeyZqO5EPZ8YFIbPZ2TVAZq9Pl5Wlz2QjNyJUz?=
 =?us-ascii?Q?y0mNidXXFoi4YsJCGzsZ9t+bB2RdEOzi45FnYzhfqOcM9JWNU4erBg0s/vG4?=
 =?us-ascii?Q?vv4PSShIP4rE+mGTkID0aCRvAooofVWt2hcehb85Vsc2UdoaxIGgXpUorQq9?=
 =?us-ascii?Q?6BT0vx90ualFiTDw1XC07XuFUwQ8PdwQ4R9OgFxn4XcfNallA8WVDn3NceNY?=
 =?us-ascii?Q?slgLg7LZKKxwZ3JlOhZTHw5QMxGp+OUy9SmCH9a+XSznQH3fY7Rkgh2qnBYs?=
 =?us-ascii?Q?r2A6UXlVuEdA1/DbJ/E7jea48xfGda3fb8PKij1bu2Dgt2bAOiDyKIVyHOI1?=
 =?us-ascii?Q?MAk5fnnSGTuvi2a1+AR4p/XIXBLPLsF9St9WI5CbgNat7iO2PqUVPdLID8ms?=
 =?us-ascii?Q?LxWCG6Af31R1fqSiSwxITE00UlNBFBKH7944HNaI0qWcWw88Ya8rP6zWv6Kx?=
 =?us-ascii?Q?V36DZHIPBNV2vkVG2mGOWlhrQHbkYM8Jg1fQk3De//UYlqYEwJ2+6hbuSBkB?=
 =?us-ascii?Q?N7xmcUVyIu5kMfuknsoj2PVsRZEUDMHS3UQxaFI07r6eF8pCcAf5a/8XSk4P?=
 =?us-ascii?Q?8qIUHn+xCK8MCh60Z44gbwbC3Jv48ah4PTZ3+fi6doex/ixYTYFDLW2GkiaO?=
 =?us-ascii?Q?ICBS7HL2Sp9oyLlOvtLbUerKDz9LncK9iqCMZdjl9Luocr2OBsEe5JqhZQ7x?=
 =?us-ascii?Q?D6mAI/CqvgZJp/bKNdVt7D4ozeHfzi92D8x4xg+fmY8rgQDoMwMhsajn8fq2?=
 =?us-ascii?Q?Yav4cZTB3SwGMiTW1eDo1CJtldtrQUNV+cxqRkP81Hu2Wyhv9OVneY4gtd2F?=
 =?us-ascii?Q?lnuPqbwwFy/xlV4wZAZ6+8c1yyXDCJUn1MtNMqmQ5ikt8WAv0bQmbND1geLm?=
 =?us-ascii?Q?mMmN5hNYIV/qJ88E728mGVMA66xAVZr1crVz8VDdOR3LxfqVgGRYXai4fMKC?=
 =?us-ascii?Q?tPjm06ywyhuVBoCtA9GFsAWI6VHZ0xKuz6UX5i9s2zgdJv9RIWRg3oltyjsk?=
 =?us-ascii?Q?40BXhF2Oci6RAYI5n2nIUDGSugTMXR+NBplxPVECni0Lt6hCAN+DVvKXn2Sa?=
 =?us-ascii?Q?FIj05Tg0GrliP/oMRFNX+xIKNXlU3DG1VD0sVESmnulPMquoYoET33Vz1MKD?=
 =?us-ascii?Q?hNwCQ9iblPyBvG1ebMhGsibryrgj8coDWW/1MhB8UHxiRNhBdjvn49DoOXAC?=
 =?us-ascii?Q?bAYCfDFNY0wCPAMZ58g1zXUmveT051tqzlB+7WNe3JckmVCL5WbWCnzb2Sdm?=
 =?us-ascii?Q?qSYwixLMJP7+m7vfwrQ6+HET5Q7ICe8lMc+5/9RTg9v503NdNlZOJDoU54DP?=
 =?us-ascii?Q?RFllNbciAGjnsW1uT/nIgIzpQc1I78qBXFZIqlCVCBYmdyYhCEU55AW76U8S?=
 =?us-ascii?Q?J+UoXQMZEog0E/9nVDrCdgZoXfthZOCdlv5pEGJuYg7kDoHvqKEbL8LSxUPL?=
 =?us-ascii?Q?XBGlFyN204Mr8uQLpY/z0qvuqvFtggdVLyKunDIHdsJjtz7z2w1/bcxEo+VQ?=
 =?us-ascii?Q?FJFYmK71MWmZ5rcd2rrykUzgbymf04J4EZYymp9RXbM8iBC/jBd/6Qez9lIg?=
 =?us-ascii?Q?Fza14jCLDJUmO1A1k5F8hYmTATQhrcBzQd86dfKmLxvLTxdXsHe9A6pdDq/f?=
 =?us-ascii?Q?sB4sCDPstZmNYK8ieFOyxOrN7AvNSKf/x0GoF9eaxU7Imlt/2AzbFBNewpn/?=
 =?us-ascii?Q?v8VRU9+ZcaBLZy07tngaJVP6+fUVomw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DA33CFE657B3ED4589BEA4D1B9E5A76E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CaGSNEpQOOOJGNxlbjice34LIq0TzeHZqWsvi4ig/iTYX34JugHQ6ZgoWKtBWMrz0ukr85R5aAMaLkBrTnOJbVV5F/TBGKIoXqmTdthl7asT/BRAMqQnx+HcTmgZaN5P3jgOSuWHcgeZgbRQ99RIf1EacLnxIJ2oJslKl65EEXOCdwTXM9gJXWhUosYAgwQEy4vmusRzd2qDDVdtoK+LriDaB0pO/wLBp12hMFkhEP4EtktHzY4NN1jy7XUXfwO08FlIrnxrCfX/BDODlA16tiF1YD2hB+0J0CCfAUGiNtvM/a4VhQUtZ8Z7igOcCeq7D/PykqD9kWMKSFgROi40vKeQqQqDY/MWQPyaWqt+++XgXa3zo82M2TyZcvrYuJ6dzG2jiVq+4Lk7COqKTpF9BiSot3FcqN+9n47/8oSSksdAqdRSOClRWu7yNK9M2utWB4wMUO0G9av6X2u8W5x/YjPf7VxFZnoWBvK3juU8xgzQSpnYpUyjqpsdVyXbNNIlN4QNQ19QNsURredlBRoXHpAugj11k2HNZX8aaN7H4m34lnpixGWcW0mutUA8egvFdjuvPlW6OB2DeXis/zcltuCzOXNBb0erSkCpu//tyfPNbAHJRh4GpaoYS1Po0ONY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd3a01ce-c901-438d-57bc-08de5d44c2dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2026 01:38:24.1416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ms2AnA+Qv5xnbeCI0xwzqKGF/pOAr6Dm23CxCSJmpoQzDBG/ok91ALNxjx973ovHh0kBZwYvjPc1WObDEzh+C4EVmVLa/5li7C+R9aP7j3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8010

On Jan 27, 2026 / 10:05, Dave Chinner wrote:
[...]
> IOWs, this looks like some kind of RCU/static key/scheduler
> interaction which may propagate into the block layer if it needs RCU
> synchronisation. Hence it does not appear to have anything to do
> with the filesystem layers, and it is possible the block layer is
> colateral damage, too.
>=20
> Probably best to hand this over to the core kernel ppl.

Dave, thank you very much for looking in the logs and sharing your views.
I will wait for comments from RCU experts and keep the effort to recreate
the hangs.=
