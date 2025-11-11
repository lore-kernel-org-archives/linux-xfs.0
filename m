Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE0F307AEA
	for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 11:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762861408; cv=fail; b=SqS8BmxDUDI+hrZuQxWMrZVtvHDY7uvjE5pZ1eoRnO2KrRqJ1+oa50+f2hB+6wrY5+6H0PuCxTDyMp99vMAUa550pmVqo1NnID5rrHwnmy8tBOlZhBtdM5+me8jAsYLaDOK9I2Qjku4zPSPyZ+DF7nxRogel2ZpGmaTTDoE3ya8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762861408; c=relaxed/simple;
	bh=SsDDi7EWv8smyvosD49tuaYlnLzXcOVttw9+X63v00E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LIdmtXFy+NJ3GhUrYhKfwos+xFdgshlbjRKxG+gNXJnMbak4cM4mf1V/CydiPMkia4JWFpdvBFXSKb8DbJ+g1tA713kkZCtse9h2I0OuzX8ryodJNVdX5yhFL06cYOH2wyR6BKrYEZEThu/ebHtR7hm6Z4xpZtDZKKDYroodDfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eBPbxr/A; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=WDjhGyIi; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eBPbxr/A";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="WDjhGyIi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1762861406; x=1794397406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SsDDi7EWv8smyvosD49tuaYlnLzXcOVttw9+X63v00E=;
  b=eBPbxr/Apl9yaMmAi4P3vnBWvn2iNdY60uNEK7JDkfHetYqQtSvfBqm9
   sT6xcb7LhjS2PYx1+LajnudSCphLRZ4XZhl45wyj94oTi1z9fk3ihxi+y
   zOzD5rBGD7gYjxwNL1PikfDNCvheY9csknGv4VatKwppWzxByLoFCbRb9
   TzrjIvKtD1PX8nEK9qQ3YSYUGKrPIiORB5Trn/VezPz9FLx1YbhmJ/GeL
   l4RFs6QihwXV/6QFj+s++GC1kiwEZCiUb/yYbr7jl9nPXv/pYNwufL/Nw
   TstW2lup7rQxz0c9hKE4pUMHcLrvGBlBxwQUUFZFslmKlG9js6M6Kq0Q6
   w==;
X-CSE-ConnectionGUID: HjW3ywiDTAKRARNwcVyELw==
X-CSE-MsgGUID: CGSxSpJ4SfylOq+671YGnQ==
X-IronPort-AV: E=Sophos;i="6.19,296,1754928000"; 
   d="scan'208";a="136205282"
Received: from mail-westusazon11012034.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.34])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Nov 2025 19:43:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlbCG8qOQEYAw/omxm6HvvDBzN5r6y+fBc8Y1voAlzPTUGwfQB98oAFtXclCwKhz9RYWDZBltC+pTqI+92o1Px6JKiGp3QZcAt8QEBVPoDKwHz4pHSvtQV2LeihpJ5cQ7zG+3fcoz2yDJCicydITOAMl5WA5n/2ZsmVHK4LqHIVL6WmmogCIJZutfaSiPAFWhJbvN34vER8Qs7+4ClmUzH+tIUUolzNjz5FN7fXsqJYbI1hU5bIasTvf30aw3kGp/PKfF3MWivd1fR4w1tuOFB1ATBvsebgRdG35Pf5VmJ/t38I8ZH/Ps/Dhbfw8zYORjQW5XsO+EsAxkVGvT4U+Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nEKWkAtOCdeVcFVaxoRhWQYtPKuDe1J28/y1dgyus3U=;
 b=ku70rzOkwtqUKZSf8Didy1dmOQ3Wtj/Jmx2OnRY/x5MPkjW0w2MYmyAhskz/TBiKDoniBahn7QgjXnM47poXfHhJUF4n/IrOnuYmis0w1X2AWJff6d7RlzHOEHiurpEUGxTtHCZn+Ab59T7OulADrlFxlM3CdV11WGn3hmoi56fGVbO6Kt1LZrE6xm01AL7J8A8ErESxjARY9XpC8SDiPrWw61x595Dhm1YmsSYmxcUBkOeOjiPAtUesxtPgPZYoMivJTw7JtZhSlMdBzN1LsFz4dUyKNls77ORgMZom46CLEe3w3hRJC8dJFyIy7AXfsSMe8OAEOlsBEKZPkRMfXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nEKWkAtOCdeVcFVaxoRhWQYtPKuDe1J28/y1dgyus3U=;
 b=WDjhGyIiCxCZ3Fg/K63ahBgtHhElLGLeCVq21+zqqMJHxk+LJEXY0LYFdUgAh7/7EYv64T//fwq+UOOfbZs9qXmnU6LDRJkl1JpgEuDmIAdEAeix8erJikOPeGJZ8ZjoEKjLhBgItBcL3ZUJ9HIzddXN4WsYu+5OyT+BhUCqi9M=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CY3PR04MB9691.namprd04.prod.outlook.com (2603:10b6:930:10a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 11:43:18 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 11:43:18 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Ojaswin Mujoo <ojaswin@linux.ibm.com>, John Garry
	<john.g.garry@oracle.com>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [WARNING: UNSCANNABLE EXTRACTION FAILED]Re: [bug report] fstests
 generic/774 hang
Thread-Topic: [WARNING: UNSCANNABLE EXTRACTION FAILED]Re: [bug report] fstests
 generic/774 hang
Thread-Index:
 AQHcSXl9LlvNthA6Oka+c9m+4a5IsrTjRJmAgAAdnYCAAG3sAIAAHemAgAAgzgCAAUpDgIAE9XYAgAGefwCAAI16AIAA8z+A
Date: Tue, 11 Nov 2025 11:43:18 +0000
Message-ID: <5uyg7de7jjjft7halq3xyb4v6hprsxz42zj7afjiqrhy3tszdj@6dazjzhwtdho>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
 <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
 <aRCC5lFFkWuL0Lph@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <gefhyxokf7l2kbwy4fazphvh3dlodztngje7r4n76zmvylpgri@kca45isrne2e>
 <20251110211240.GX196370@frogsfrogsfrogs>
In-Reply-To: <20251110211240.GX196370@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CY3PR04MB9691:EE_
x-ms-office365-filtering-correlation-id: 6f7741a6-5068-415d-e207-08de2117823e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?itbHwsO5rr3Hu/QOovKIOlks1ANSb5hkYwHoY1X7TYH9e01iFsmju0wCWWtD?=
 =?us-ascii?Q?8YoIc+MMRKC/BhGm34ND5szHrLcxmLdZ5gtrutDDkeP19KvYkqnIqDqLpEwG?=
 =?us-ascii?Q?q+JMfEm4k308IqUEj6F6UQrVg4Z8DaSabElptTCXo0eTVZIEqXx56yESPcRn?=
 =?us-ascii?Q?QLHo7y9HuFykRdtM2RV71xpH7TDTWnTprBNMRmGCitd5BjWRiyBmSMZQF19/?=
 =?us-ascii?Q?lLk1wJpK/4RRQI9f3cEiXUhN5+Bavi+xotIr4iU81LxscHG9cdupJ+uRVmm+?=
 =?us-ascii?Q?5j/jH5j0uMHttaMGwEF06El2+VByseVZZEEn0M2d2qBzikpt/dnUtsqhzA08?=
 =?us-ascii?Q?SsqJTDSPNnPUmGbugC/YN3TWY+24oLH1+NLygMiIOTp3+T7RypQZzZazfmeJ?=
 =?us-ascii?Q?VjbAcPHuv/GCJr3BntOrEJY8hQo3ZIz4U/oqGpLLB5rDKgTZecGj57gCROw8?=
 =?us-ascii?Q?/aFWMxhmXUDU+qmQXVae1gZiJZoMjhEDMgVOoAur3CL9r/ukhhgdVxWOAfEg?=
 =?us-ascii?Q?R8NpAiE2HZo5qE66huKlg095X1lQ13LJxs0V7djkKXg06cdCTPvhIb5/cqjr?=
 =?us-ascii?Q?o92hhTyeylQ9Mi+MbuftDCnPgc6mL17rRmJxnYuW7Af6gKHJFFjD0osGaycA?=
 =?us-ascii?Q?xuNlWfvSPkKuNdD156SjOiCmyfW9GgLgqfwhF4I52NCBX4YVIeiw5TZ81I+8?=
 =?us-ascii?Q?xQ/N5jJJC4c4zW345Evm31D2m40QzSVeR6jXGiRRCLGmKZefQHE0NGRoYTzl?=
 =?us-ascii?Q?F54KvBqzWvrBWwX15h9G3DAQ33v7EKKRE/eY16wl6Gfg3K9NbmxwxuCfbGfO?=
 =?us-ascii?Q?awvGtl61/rL6no1h1miE7Q9eL9gACU8s0/CXXFQ80CROOeujcNNYIvcEc92m?=
 =?us-ascii?Q?JvSt8gzrR5V/4YV8mCuKlS4+g7z28G5wTiIwWvct5HJr39qCwgLrHZtPI2sT?=
 =?us-ascii?Q?ue6H8BBEiT9T6O1ucBZysBWtF1mGla/5FIsOOFD08c8FIDGbI+BOjOKzDdvS?=
 =?us-ascii?Q?pI6324S3kmbUSeEYxXkaTuJBuiqMOgaagSbv/scG3XI1jJpcLiiITC/cX/OJ?=
 =?us-ascii?Q?jYLBKbzeH+XCQwBTRuGJ1QB0yY31JT+lvwkpBX2ewJ2b5GGJdvCdNEdYIu+Q?=
 =?us-ascii?Q?2SoFEP3HMiopzqhUpM4d3g/9cubPJvQ1ajvGmwzsOxKc8iFQsxOGEE/8F3SS?=
 =?us-ascii?Q?ZxCkfWj553JBQCVJFmKGQeT03Su2759GAaHvm2iiiI69melXvIHZixwYX2b4?=
 =?us-ascii?Q?cMpvpOiSFHE2qpBEYzuSMGdFO/RKxpUy+jkFGJFuGZKlrCsNQtv3wCklDYH4?=
 =?us-ascii?Q?sI0EGRxrj6fQMXCwoSMQZ2UnPV9XrpDX7FPQpRE41uIoVxxRhX1T1BfWRENp?=
 =?us-ascii?Q?z29RgDKIQUeP6he07Oj8Zoi4ftCtz2NNgEehweGzb8cr9N7U+EDymxT9TUHJ?=
 =?us-ascii?Q?FLs+K1qf6pf3Su3OXF4e4dtZbPnuYi/tITQQdV+TV3h5MSmPP75bJQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?EoHw93OL2KEhLDsAhcxEF9WGggja2x9yn4oLXIScvdt/20vIvTR45nH4Y4TH?=
 =?us-ascii?Q?uNPmVWiY2Ppitu7Cm+NqPz4uPteLqT9llXBGLrDOMNkj2rIevmiPM4wkrfq5?=
 =?us-ascii?Q?aU50rnXDor0OAlWzHUP2JaC8xrwIqehwKiQ+cCRtfamsiB9Bu+wRD/IubQR/?=
 =?us-ascii?Q?MhJYXfUJoPypqKH2BrLEtST4z/scseF4CSqcQ88PXe7W9jj7vXN2t3Vl8v11?=
 =?us-ascii?Q?TXCAH3UTkgPJQglHGsEiVq1A1WTGjgOsJBof9RwxOzaHDmUwNzaStFJ++9gy?=
 =?us-ascii?Q?ZS7Vgxr8qru6qiKXlBRmAw7jEXJ/MxsnZbsaiVH6OovDOKen3BlvLgyUgLL8?=
 =?us-ascii?Q?DV5hBv/iQxXn5I6AOIjmGEvlh9G6B4jtrPwKp/CHRd9Yi1UIS4mtI+ME2SAK?=
 =?us-ascii?Q?K1T/qLS/yI9mOb7lvcxVP9JqWFkIdBN0bOs/KWuwPZYeAnXw6BaeV+5MJL1U?=
 =?us-ascii?Q?ZJcLlksFwGYipcIX9axLUKH7oLYzO6NPK1tN2L14YBQcCKetmfjkIx2hCjE5?=
 =?us-ascii?Q?pCJjQtJVqAOko1ZIpnQwEMQV7yNxnmrRPMIEhaUnD0C/MNRC4tv6uTvnctJU?=
 =?us-ascii?Q?BOV41YEvvkGLVwm6rlxJNQefwpshqmnAYyZBPBeWBigZEnwLB9MTnmk4JlAq?=
 =?us-ascii?Q?bBS7haBh5llf4R+u+pqxOG9hZ2tweAzt9E4wy1hfOhs9gUyMSmBeF+/O7hlp?=
 =?us-ascii?Q?SKdes4cqdmXE1c2W71/+334MzMv9HGp2PatEjrZn+XjvF6wIeQWUiICRYHcR?=
 =?us-ascii?Q?Y7Fj/hgxX6I0QvgnQAb5QXdpdhw2mYX6CsIlT46J8ARPMgeyonBEIT6/cj7U?=
 =?us-ascii?Q?nhrcdnWIY0JrziiT+3KSgW7y3ygrPLNdXSxUoQ5IBxzsl0XXUKlp5Q2afwsD?=
 =?us-ascii?Q?ovQJ9+1ijXW5tYaBawLUVDE5IBnfl2bbEwGAmtC9vXpLDfccYPBCr3c/imNu?=
 =?us-ascii?Q?TvvWwlfeo8sg+exdrLJ4Z//InPJsb/CN2sLoD/OVrno7PNHchMC3SCWAqgg4?=
 =?us-ascii?Q?yDE3op4HNNWJxa3p7m9kxmV0Jp7SOcMUqS9qUj2VkS4y5wN+eHZEkCaU1f3e?=
 =?us-ascii?Q?RJSwgrfP+yykx7r8kK1xNT68GPRrSlFb2CwmwMTTmirbvZb9QUyeRUGRrxpU?=
 =?us-ascii?Q?rZg7gIPn3VLak5Yn6TaR7NqQHDRfDkM4HUx4hX581V0R2uVK0rrqH7YE63pk?=
 =?us-ascii?Q?BeO0ypLaosObZHbeuR96EsHXV2gQfl937W2xIWPyI93W9R6vyV4O4AVBix0F?=
 =?us-ascii?Q?6WhlILz271dCFJgAmLNHZmqLbAVNeuhHFZZM8ahki7YZG4mdPSA/Q2XrGcuM?=
 =?us-ascii?Q?+k5qKI2ZvIzb96gosWwa5GMo8An4KuHnpTPJ7p+D3g1Bb5puBPZ4VSdno+6w?=
 =?us-ascii?Q?gG075wHtvFmR1KNPQsntu+L4m1uvOiIIKeO2diJFZ5ER9V2sBIJg31Jj73Vd?=
 =?us-ascii?Q?HsxNAGbWgMCkavnEwbM2wnK+EksRZ2KudcRi2fYt6P79r8kLZBHWF9P7Hf5o?=
 =?us-ascii?Q?hDIAPSGLpuY4+eAHsfTmMNvGyppdXBDCxbFgk5ael/XLew8mOVWVMWRC71V2?=
 =?us-ascii?Q?sD3MyMmYTCXoqjOtuUsGeWJG8jsByMB5RqypStm/Bw5++d+yKIrTzW516tF5?=
 =?us-ascii?Q?q+keMRTGaPql6c05cCkLcxc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D668D3A27F789B41B39C7AB2D3795E7B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ue/ad07zO773jwfHmpVVOerfTgeGU+sLZgkhsEZLsqqAo2j6uPHKE/kgvAgsEDwM+0Fbn4R92vGG6n0hUKKFvZEXjCb3ySqRdPMAnMaTWDRbDcrA3fBtcsHng9D/Snqmx8HDGXbQAJqlbsd+b4dNky93veFhgOU8bG49LZPI00ZmBeKA6K07D34zhZ8zbmD1qBQAJgOt8uInd8rDj4mmJcpte6S0uSP+r2Ri+DkQY2IEK/KBg4Q7QmuXjAGiX0lb6Xm0xZd2371fbZud53FJdBLSGyAnTu60Dv56fk2Y/f5fQrXaaJ3xIaENiZwbK3UJ3HdR2lLzec+d7WDTCA24FfNPNfPn6TEZ1IsWkdgwB/seLOaNrXldoNgqqoKerzDkGtMg3v6LA2ruSxaxS4atrjdrgwaSZGMIMscVCfSXUUrkWGz7IpYn50OhgzaZHp8qHG+DhlTYaB8csc/oNyROBbJ4Ny+DhVFPNPF34+UscajPPFsunguGMCfI3ZcZdsx4bUU6qZK0sWdsKlEz+xxGaiaasXmm8z972nvanK723Dx17mbwUbWNCWVM2GI8OiPhTgsXqTVTZU9L7Blzs44zc+/zaTHq3fvzeDHSZHAvUEgabuqZrG0u/Z4c9Ttu2ul+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7741a6-5068-415d-e207-08de2117823e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 11:43:18.6287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hq8G5fXE61qzMDgGLpHMX33onSEqcIUm8HpfvStqSR1i1tRrorb6ZyniDMOTaOdE8N/6OevPx5UzByJFOovIyZF2qG01d8PtpMjas7u6E3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR04MB9691

On Nov 10, 2025 / 13:12, Darrick J. Wong wrote:
> On Mon, Nov 10, 2025 at 12:46:19PM +0000, Shinichiro Kawasaki wrote:
> > On Nov 09, 2025 / 17:32, Ojaswin Mujoo wrote:
> > > On Thu, Nov 06, 2025 at 08:19:12AM +0000, Shinichiro Kawasaki wrote:
> > [...]
> > > > I tried the other "atomicwrites" test. I found g778 took very long =
time.
> > > > I think it implies that g778 may have similar problem as g774.
> > > >=20
> > > >   g765: [not run] write atomic not supported by this block device
> > > >   g767: 11s
> > > >   g768: 13s
> > > >   g769: 13s
> > > >   g770: 35s
> > > >   g773: [not run] write atomic not supported by this block device
> > > >   g774: did not completed after 3 hours run (and kernel reported th=
e INFO messages)
> > > >   g775: 48s
> > > >   g776: [not run] write atomic not supported by this block device
> > > >   g778: did not completed after 50 minutes run
> > >=20
> > > Hi Shinichiro
> > >=20
> > > Hmm that's strange, g/778 should tune itself to the speed of the devi=
ce
> > > ideally. Will you be able to share the results/generic/778.full file.
> > > That might give some hints.
> >=20
> > Please find the attached 778.full.gz, which I copied about 50 minutes a=
fter
> > the test case start. The test case was still running at that time. Near=
 the end
> > of the full file, I find "Iteration 13". It looks like the test case is=
 not
> > hanging, but just taking long time to complete the 20 iterations.
>=20
> <nod> 778 invokes xfs_io and fallocate a few tens of thousands of times,
> which makes the test runtime really slow if fork/exec() aren't fast.  I
> try to fix that here:
>=20
> https://lore.kernel.org/fstests/176279908967.605950.2192923313361120314.s=
tgit@frogsfrogsfrogs/T/#t
>=20
> As well as reducing the test file size for 774, per everyone's comments.

Thanks! With the series, g774 completes within four minutes, and g778
completes within a minute in my environment.=
