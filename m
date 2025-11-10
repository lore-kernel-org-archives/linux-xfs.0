Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA07030CDA1
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 12:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762778353; cv=fail; b=bBQXXB2g2fdvi9i+vaVGSndT3JEPsrOEIDqDsO66h2WYP2EPE6a4tGim9PVqz+J2MFMJtBn2MI8XQoxOAHQVF28BiM7djviT9dwnIkdr7cX+TRUwK9V+1xYdWAwVlEYcJVCILpt8daNuIodCbQuGwzft/UghVWJ+QotYBMviSwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762778353; c=relaxed/simple;
	bh=j26GkmTWgZBpRQFymWJMibkPYjepq2Xj2VuOq21HM8Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qs+UjU9h/TXFfFYTfxABp4r790x/gPdsnLQu8BPywZD+eSKAOwnwMFg0EG+JvR1y3bzIom78Gw/22972SsoTnm42+o2n7iajUfMbEchVvBnlqNJlRQlRM4qwpq15t6Sh/0blZtY8xpFD+jpJiBxlellko6zgjXTPLA5WzIn+pHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=i4vvbkAQ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FSDJItbW; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="i4vvbkAQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FSDJItbW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1762778352; x=1794314352;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=j26GkmTWgZBpRQFymWJMibkPYjepq2Xj2VuOq21HM8Y=;
  b=i4vvbkAQp8RFAxflQMuUXwvx9HaRRS6nYzyohAsbjW8inDT3avVdhtfb
   V84XCzZJty1CHJjMS2r1duw57kRHDFPcx8IObuW+0xUq8HjRGl0v+jmon
   iuVsG0Cv6HiNdObvcfHjH28D3V9Za1Px+KgreznOtP/M+tWRYSz6xIUNj
   xuw9bttvwR25V1GbUJDKTnTlzvMSJFdLommSNCw5s60IevHeW6yW/U6jJ
   KbcB8Z8jqTMnIyPYirgeRoGxqrXbn3YV6oVi8KfwLgFj8qYBzK+hAV/wV
   Qq+3NJYtD+z+GexVfeFps53h8acj5WLi7LcKedk42OwOfGkpIESaRcnAT
   A==;
X-CSE-ConnectionGUID: +LZdWx9+R/uYa+4VZXN7Tg==
X-CSE-MsgGUID: z/aj2vFmQGizfSsnQ49nAg==
X-IronPort-AV: E=Sophos;i="6.19,293,1754928000"; 
   d="scan'208";a="135786701"
Received: from mail-westcentralusazon11013035.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.35])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2025 20:39:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bLj1SculJzGFmivCaBIe5DkYA+efephyZl9wWTlfEIoqZDeRO+NI2ECNaoh59l9lILA/eBRlRmUsBq2zKyBeAckNL8uWKKnQERBvSxowptzfe7S+3xL2q29RDACFzx+OUapJ5/wXsoJceW7HUWBkj0UkDN2Jm67/1i3PCak1VaRBmjOKdTiO7WXGppoRMqlDv+OIQjxlng8SzZe1FlofpApxDrxRLcOz1ScvLCiWu0NwOZET7hR42/T/HufjbQ9BQMARinbpforjihN6DYQRFgt+hs8QciU++NaEaVhYv9mlcfRRkf5B1Dei9JZNaqjPhA9QvuY01cKEW09PmR2E0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4QWPvyNOXs0nMYGjnBVezQn9eHaMPywW2umBpJMw9M=;
 b=xoicfSZbfrJZvEfgWNq56yVSwaCLP4n2LxaoPd664N8kd+fqQ6LihlUa4RJOojgMVHvxDJ0RO3Z6GV2FfyEMQuPBTNxilmJzkMgiOzCWPb7h0NmwmQGCpR4Izl8NlHB1GsveuaLDE1uKhEe2GAGLmyD0QcaVaqOaaA8IeNR63mar9vIEd+OB8+1YwzcDMqRtYCi5LPS2WqUBjAqfhVhy/NDkCxGKrIOvK6+HoqDdqwANN95vUT08Wgy6K0UfnfW24hAaC+cuyPd5jT/9PBoC7+BG3+DjSRV1iuelPvWL+5LgotCEhYhi4UwspdHM2bQ97UkL6uWLsZiWjpDn7cOxUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4QWPvyNOXs0nMYGjnBVezQn9eHaMPywW2umBpJMw9M=;
 b=FSDJItbW0D0f5T9MMK+vH+T68CBfkWXqJLLFGUzx+tAg7FVy/nwRFwGOdKD7QZpL21W6SSptvVk4IVMJHVQ7+7OUB0K4F+x9nafq+HXUA4VtebIOVY6QQuhwHxUsXKmqqsRx/O+ouwefQDL9uSsV1EWsZGREYF+oXdPmUG1AwTk=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by BY5PR04MB6850.namprd04.prod.outlook.com (2603:10b6:a03:21a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 12:39:02 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 12:39:02 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
CC: John Garry <john.g.garry@oracle.com>, "Darrick J. Wong"
	<djwong@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] fstests generic/774 hang
Thread-Topic: [bug report] fstests generic/774 hang
Thread-Index:
 AQHcSXl9LlvNthA6Oka+c9m+4a5IsrTjRJmAgAAdnYCAAG3sAIAAHemAgAZfcYCAAZ2KAA==
Date: Mon, 10 Nov 2025 12:39:01 +0000
Message-ID: <yatoy2usff3cnmiq3rjdb77losbli5yghbdyxtgnq2mqsuglmv@otcjbdpp62qw>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <aRCB_TzOAtHaTPOl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
In-Reply-To:
 <aRCB_TzOAtHaTPOl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|BY5PR04MB6850:EE_
x-ms-office365-filtering-correlation-id: e36625ca-d778-4420-81c8-08de205620c1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?02+IJ1gX+Ctzi69skNsAjAzsjQu0HGSFhtiufZvHveLEuvtSUJT0CMlxlXIy?=
 =?us-ascii?Q?LTbHw39EMN3hz7iHf/d1Ae9fXybExWmmRkh7UFwX/67r4scRDRogtQ0VgseT?=
 =?us-ascii?Q?a3hMGJ+lba3O9BC6uSCTFfeQWMBW1vaGKe+ikdlgotRe58uXOBHRfGTu+OIJ?=
 =?us-ascii?Q?mab8Zp035QeCEF8IMmMRnwZ54grdb8n1cmN6JLS4Y2RPOZ8tKEiVDrW8csah?=
 =?us-ascii?Q?mLKLKrQv44NQq6iltnG6mQBpCHpF6IN8OE6HqJk+NOixjWCbmn7qBWSIamVh?=
 =?us-ascii?Q?HD9dP6v6O6sodaZghN+CjpclQnCeZnhrKycIdxUrTjbDSeFO+CmOLj5Wt+ne?=
 =?us-ascii?Q?LjvL4lb4wpP2r8L6m+nzt799w1I1fjmAju4m0mt+oMT3Jp8THWnPfB+YcsW0?=
 =?us-ascii?Q?RUs4LvUBElzmPYkNUi6fTXkZ8WX2FitXNaMmWqEYRqz20lgh2u5Tgpt1Phls?=
 =?us-ascii?Q?zwVcexARuhRuVJIW2mqcC4BcIJLmCsYLq1uciHi6CJMF+to1rcdUPe4LPypD?=
 =?us-ascii?Q?C4RUDMVSejHRN7MWijitR0NkghBehlrM74DAW9v/CJ9leJA18MIcpYxXxiGF?=
 =?us-ascii?Q?E23VstWQHa7PRecVP0InxPcRpKKLRY3iSpOIwRuyiuoydwdrS/CRlZCoF6En?=
 =?us-ascii?Q?C30SVSzjrSVnp07BJqm17os05HO1doMwJtA7RzdqK5aBXbrg/bpmoG6NXYL7?=
 =?us-ascii?Q?nzT0DZ5v/hmZQsB8nMvaLm2Ncx+mI5WO3+cI9rL2NHsXYtIKNiebGJDIJpWj?=
 =?us-ascii?Q?gitwnC6rZV2Tzkui13AACQZlnYoFQaE4wW8420AFcDRjuDmPFeKYfhHROhvY?=
 =?us-ascii?Q?P6kyIUbUSrotiN4TpJ3hJhBx8JUSkLMgUXuMg4VQ/BIXlrAIeDDpbF1H1qQW?=
 =?us-ascii?Q?iDBZRum0u08aSy8uQv2NP12K1eeC+Ra324sltHtQ7e3+xXA6sdp7VtC2NAMC?=
 =?us-ascii?Q?NXN482qwAt1f5KkfyhXRoR+6ucIQqOxzxKUmqj2x5Oe3VhOLiUZXY1Zim6En?=
 =?us-ascii?Q?26CVtexKAnCX57OWfR91yFOoClV5THsD+XGE+z5A5RomMTCtjfC0NlBUQA2r?=
 =?us-ascii?Q?Msp+ddZpnO8v0UreywXmywmlTuE0qUJBCAc+RseaZXzNGV/tl9rYqh6Fqa0F?=
 =?us-ascii?Q?AZAlicAyQaAfovyvFjmcREydO3opAMnrYUn987DXjGAOnAD8lcQbJB2MreGO?=
 =?us-ascii?Q?g6jVF8YQPT0hbJ7DH/OeZ11sxxdL7195fRjqh2YpkJmyzqJ7OdTuvQ5eYGat?=
 =?us-ascii?Q?URMKxwfw53vKp6/YPxo89VZK9fDIxtXCrPzri8qIwavqrproZ5/GVZHqcCuP?=
 =?us-ascii?Q?dNuQUZsSFEYJHknpYfrfWmsW+peD9c86OSMEVUnuPPXBuFXF3YP36N3b5aYH?=
 =?us-ascii?Q?2cv64CJz5ov7DpR0yQlDxS9iG0Pu38btw6PATE4wx14bMFbBJ0ezytHFDNt1?=
 =?us-ascii?Q?N5Bbm3c1IehAcCbPH0qeY3cTUxoH1B+A8KNKdGrKqgjJZmHq+u8tdFyazxBu?=
 =?us-ascii?Q?cVIK/qbc/joG7a/q/RMxt0a9nqz/yBo/hSl3?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?9t7+JPEDrGYfgzE2YEf7c1CZzVEJpNDiz5lcmJmvdKVfq5gpyS90fp9ipzmn?=
 =?us-ascii?Q?AMUKgKZMR6HKmnQnVSmcDd5guC7Yevd0YPh40uYUBsjePHjU8dlUKhgQERiT?=
 =?us-ascii?Q?+PPA0AKM1Bf/mrI3y0L2px1A3Mzpmp6cEMDGgreg94qnNbQFVeUXzi5s2Uqj?=
 =?us-ascii?Q?F4PXuQyR1Bw8Trqtly1c2l0uKbt8VrG3dzpkHZKcTq509iTJ/odE3VcX9Kkd?=
 =?us-ascii?Q?/Y+dN6tTG4H3E5f1o+WiN6c1WsOD0yo3jP0ZZ5Br6xq7JlTPWiYdL94cCh41?=
 =?us-ascii?Q?Dw9uQ8Gf6L+rRvyoWlMyuPH9wq1N5TjrPVPCpP5ab+nRd1aooHxBX60ppt0s?=
 =?us-ascii?Q?BB9XYGUBnKqjbW8Pxou+fRz5/6ub7cE91nJHVGq7Cx3weCO4zJTY/pdg+nsa?=
 =?us-ascii?Q?lyN5PjZGvS3fBiwiXShJs7bpGvmKYUa/eyDaFny9au5JfGpEuUtKRerWx9J+?=
 =?us-ascii?Q?YqcGJETvExUEUnr0k1MHbv/XZmFi7krR3NpRMPsRSPbfgfTDcSxeO5MWLb8G?=
 =?us-ascii?Q?OCi6XvtZ8UdA6NLHHIwy4QhNSPJ+KxkGEO6/9pxjrqUd3RhBmOYRWm0TzpLo?=
 =?us-ascii?Q?4ESaGMzBPHQHlu1NB2BkAg1pjmyivP5MLRCoI83Ejqd/KmipFT+OYeAdwtOk?=
 =?us-ascii?Q?we1LSUKL9trMZ9V+qP+0hoGwBlYnEsVYsew6TQlNHQsq+UJykd0mMt4eoR7g?=
 =?us-ascii?Q?rANwHzGPAuloIh7hhmLSRgr8fUYZwtJOlVPaQpXzU9uDqSGyht2xSWi1eH3i?=
 =?us-ascii?Q?u6Ni1w/CBN927jsyxH1nZqVCkM8rL+/QDtRfRCAaTOMBupwGSCaHXjEEUacY?=
 =?us-ascii?Q?wd7vhLyvbMuI2Ci/9kCc3yCLdwah8YrUVA7suH/+wJIWW3A+837qUGGvn4pH?=
 =?us-ascii?Q?n/wvXu2Ph7P7g/Dj2j43kFF4UxNVZ1nvxjIvIuFH5RUc76as3GXdPixAvJIE?=
 =?us-ascii?Q?bshIBzIb0Zv5NAgeXHlL+4hhmfjc+ZCJ5MZw99KbxDzBsvVSXCDSckB4vTYU?=
 =?us-ascii?Q?WYpGwRXOoScm2ODmFPwqUF6GUQOTKIkq8jCDnLJzroxMNLL5dgKIG+tx1NUs?=
 =?us-ascii?Q?U4URjFnh/+1aTqfqi71rg+xcg8YgXu1EXFNn/VNM2iXJxo44uuQkVKixozKi?=
 =?us-ascii?Q?ZhQ6BXvxvjBaAAtI1Z4sfMdvOuvJIN3L6GRvfmEJusD3Ow742dI3Vbimpa68?=
 =?us-ascii?Q?VwxciYlOs/g/RxiEK/RHpHpw1kDYxcgpOV940IMip30mtJYRhmTO/Zv7s4wA?=
 =?us-ascii?Q?rxShIMHly7oE1hlgxAabEpIoszsCQLLHSEC2wKeUe9ITn/ivWeMY3rXBGiJ2?=
 =?us-ascii?Q?8vNrMHBTBInfqOKmeFz1Le58W/uZyMQngUvdMlto6CK4Nygo44dbIZDEf5YX?=
 =?us-ascii?Q?CFwodYgiLWqRlqNe4NMxTGar2YxQrl4AGMfpQctVIV8Pjik1r934g+ZrEM15?=
 =?us-ascii?Q?NNDbmstmy4olsyXbS73kCQP7blcaagf2QNTDrJdTqPl8Bcezj8jSmEW2O/dg?=
 =?us-ascii?Q?Kw6iMhPp//6tCX5Ck2Kvn/uL/SyT9Sn+Y2FpzMJeNAqNZFyWdUqjD6i4P3mz?=
 =?us-ascii?Q?/nhXEV/ESxSmcd4Dg8WwsPuVGBYg9Nda/VNplpL2hfdK5COxhb+eJ6OP7rN0?=
 =?us-ascii?Q?EXDhEHmrMC+o4wx/mL32220=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6FE0A1C27EBC46438473DB66BCF1796C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rnBb1gQFtUwScU9XZ4BkhDgHILjK42hMklUnf/r9SKpBGk9lAFWjH6ImdlAfoyFz6ItPOqhDIl+mmeW4Pn67YuxA560RJ9fbJwxTnW+oPv95DhYKy5O/IG7PenVsucaVx1eCWOaJ9oWzHDMWhgZ0ifSAzPdB9P0QBh9MAVaqZq2Bff5wjFlu0BbKvhR8zzYlzmAstgxPQJVKZDbUby185XAZ69Zj1bvHTc/7SpxprZ9KgMwjqPZ2E3/+zirpYsl+G9P9XQGr8x7MY/FMeaFs1AW7JRKH1QDp1NAFJE2GbUVujzluFe/FmGCrzBWZDnxuwTK9f9hKGPemgI1gNJDcNPDsXZUFjY7o2qCTlOMk0fBsPULSo5Dc2dwCYQOB8BZMhLBxjzRKO4an8aHxgPj8WPTsLSqGLu2E7AElvRaduvSfe9Ept4FI1wSdBmIfh4MjlDIBdrMSsjZDIcmKQM6xHFB1bDK7JfIRi+TJQI9ZYcoO9mN2bdPZbzWc5bPy4Pq2O5nmzcnEVjSX/nTMi7x2HZfBzEMXO/dJzYJMejbcmb7YWMVHxmr/hgq1uGwkoPmpuwiBYKTY0HR+vfgXXg04ZbUIOceOHBBSNlPYy7KpxpnN0ZE7//2tzApUBm4tXQFJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e36625ca-d778-4420-81c8-08de205620c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2025 12:39:02.1235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5GGAmgdtppqNmTzrWX4bdNFCROiMVQW/VfubuQ+QLCH/z/7MN6/HlGdAt9E9lST19iVl24o12lnTJmXVXSaFFvMO7I/4lJuvwiNj3yNxZek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6850

On Nov 09, 2025 / 17:28, Ojaswin Mujoo wrote:
[...]
> Anyways, the logic behind the filesize calculation is that we want each
> thread to do 100 atomic writes in their own isolated ranges in the file.=
=20
> But seems like it is being especially slow when we have high CPUs.
>=20
> I think in that sense, it'll be better to limit the threads itself
> rather than filesize. Since its a stress test we dont want it to be too
> less. Maybe:
>=20
> diff --git a/tests/generic/774 b/tests/generic/774
> index 7a4d7016..c68fb4b7 100755
> --- a/tests/generic/774
> +++ b/tests/generic/774
> @@ -28,7 +28,7 @@ awu_max_write=3D$(_get_atomic_write_unit_max "$SCRATCH_=
MNT/f1")
>  aw_bsize=3D$(_max "$awu_min_write" "$((awu_max_write/4))")
>  fsbsize=3D$(_get_block_size $SCRATCH_MNT)
>=20
> -threads=3D$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
> +threads=3D$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "16")
>  filesize=3D$((aw_bsize * threads * 100))
>  depth=3D$threads
>  aw_io_size=3D$((filesize / threads))
>=20
> Can you check if this helps?=20

As John pointed out, the 1MB atomic block size sounds too large and it migh=
t
need care also. Anyway, I applied the change above, and observed the test c=
ase
runtime was shortened from ~50m to ~8m. So, this change shows some improvem=
ent
for the unexpected long runtime. When I repeated the test case g774 20 time=
s,
the hang was not observed.=
