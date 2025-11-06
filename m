Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E710145FE0
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 08:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762417164; cv=fail; b=NTl3nX0iCa4EeSE9aH9FdiuRqiPJjdYIK3MCilpde1GYYP0fPblnsVsEy9n3VQ0ARkMq+nF8mPDK99htJiYUIe71zOh8CZPAT23gSot++7d/syeP+Anw6+1HjbB7jFrP5fobOUqM5Gn5tHLnW/vC+y2syYN3NyRmuXg9V9U8v3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762417164; c=relaxed/simple;
	bh=4Nje8046rmKWczUh3HLEItDVCzToiBLWzMaOoJmD+VY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IF4MiJ9eABsfL0PwAcO5nh3Su9f/eCzUa8DrLmQCsEqnm5HJ31LJDnXwHc7GekuzLJBYgaIDm6RXzBpU/hvOuPrjlpCQaprPBJe2g57KPW+GNdMEOA4LdDQ4tplST2Rt4zLDqs98dfpyO6ReL6jk/E2WA9OYvd/fAQcvhNUrT/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jrvP0ekG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Vzb7aIDt; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jrvP0ekG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Vzb7aIDt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1762417163; x=1793953163;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4Nje8046rmKWczUh3HLEItDVCzToiBLWzMaOoJmD+VY=;
  b=jrvP0ekGHJJxXVr+Oap/KvCisUKtYzCWlV2E6JK/0qHWK3a53MQbm+4Z
   XlqMGCaWF0fYu6UeAEFLViTFze9wBs+UYNWlDyD9AIFVr6GGUDtjGpUFl
   SnFn+J9Zlme9AUY2mbTJV8EJAhZXqOUgfcDxftF/2lD80bCabfaUe0+8a
   DmGuytpTNkUz1VVgi7iCwR4lrJDm0gmNFCvatzJlVoVVinWE+QQysQaye
   5SRXjKCQSCjjRZlQPKhBRk5A0ve5diH3VhTASzyz8CTXWrTH80AGvWO9A
   YdA+rrUVQgaJFDQ9s255YE8v8Uwwa/Pu5w2n1yPn/U+sqyiMEqJARhyP+
   w==;
X-CSE-ConnectionGUID: dM/1qJISSV+mypzNaw5oIg==
X-CSE-MsgGUID: SfB1brMcTJmLe/PZKIfpLQ==
X-IronPort-AV: E=Sophos;i="6.19,284,1754928000"; 
   d="scan'208";a="134616119"
Received: from mail-westusazon11012018.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.18])
  by ob1.hgst.iphmx.com with ESMTP; 06 Nov 2025 16:19:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ShRjPuXYc1m/qDsK8rqKqIuwp8pNBkyURKmQsB59JJT2XRr3MvqjjXmfSTAf61EnXpL6ee1rDVfZUGcVJAcP/UOTfXNET4dxflDmnLwY4UKOhTXPD5uzRGLAvgOLClr5DL8tr+PsjzUzgr+9mAeHZDccbJZGl19RmnIvGsZ8UtBrb4B13IdzcxHmfOWjGv2taaaLCWNwJ1S6jq2uoS9Ym1WPD/9ti8I8CEfDBiqqwH9P30s3MwC8T8OsBYZwtymrop4kmz2dcWMybIjq8beX8t1XOX3sTBhMoyqaSGYMnYLxNeg6YKk5YiGlB2sqGKUyx46LxH5V38e6N3YAnELcxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PC5/XEEVZGmI7JwWa1hvHEJ0SBh3mgB2bv6avjHUV4g=;
 b=euDNxhZ7+59NaEMhooD/ctvRq2ZvG+HSEcKuaK+QKvHJx8tvUbwRbS0IjccSj7tmvCzwgajULcxoJPS4kBrmjFjr5LdyS1owv//QnWnw2L+5Pe5xIPnzZPh4OBbLz2hq1CzIww6aNKNziD1sC02VZdeaprX0+znwnPsbOGgaSGUp2Idb80cG6hsyzGWUhJg04/FY6eLeS5MoWTjtI4QNOV6JxHy1heZisnbHAaO4BajEhlrNukDG6JHZGuX61w7S3XA3e3B+rUnlTuhVkqwoi/YD8VQLVUUztpG+gh7oktrmTdW3u20yJ+dwuNpZUAxt+bgmk81DqtYGHjVuciA2QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PC5/XEEVZGmI7JwWa1hvHEJ0SBh3mgB2bv6avjHUV4g=;
 b=Vzb7aIDtT+41Nqa4aO5uEMoHIKP2D8cx4jamD1goc+Hl0q92CXfGceOjaI26epMSr4EquV7teiKHXDZ0BHEpLmaNgPcyEMesnWC0Vg0Mch/hpusomH9i+CsTv/x2WIuqCmp0ui1IAsZHJ6K/iowA17WTH7EQqZtKjwPpa0gPcq8=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by PH7PR04MB8664.namprd04.prod.outlook.com (2603:10b6:510:24b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 08:19:12 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 08:19:12 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: John Garry <john.g.garry@oracle.com>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
Subject: Re: [bug report] fstests generic/774 hang
Thread-Topic: [bug report] fstests generic/774 hang
Thread-Index:
 AQHcSXl9LlvNthA6Oka+c9m+4a5IsrTjRJmAgAAdnYCAAG3sAIAAHemAgAAgzgCAAUpDgA==
Date: Thu, 6 Nov 2025 08:19:12 +0000
Message-ID: <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
In-Reply-To: <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|PH7PR04MB8664:EE_
x-ms-office365-filtering-correlation-id: 3add5c98-8fe7-4096-2519-08de1d0d2ad2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?7pRF7MaZ/tYcxaQSpxrztY13joMMKCBw1Fpmg7Sysa3MHsD81lPVzmxLEx?=
 =?iso-8859-1?Q?LspYgy00lrn1Kwn3bZAz/GzALpLIdrkfcnN1Y/UDRSwds4pKzKIO7sOT8q?=
 =?iso-8859-1?Q?h+GYn06sRQPZVyYQQ/aeyxyxFL4plFef7UoAQ0yv5f2P0sjYCV0wQZeP5p?=
 =?iso-8859-1?Q?K36khBiBfRUJBnkwrqS6HRra9wCUk+J4RAyhHoxCX+epgvSr1ldZPB1EFu?=
 =?iso-8859-1?Q?LR43vRozNBXotP+ZFzPR44boqxXfke2WPtrDshkIPt8anj7rhp9OMg5Ihp?=
 =?iso-8859-1?Q?mWuGnEB2skMt3sirrtyh2qwi3jJvKaeZM8rq8m7t6bFiBXOuX2W107WScV?=
 =?iso-8859-1?Q?cpZqQb/kSl6Kz5L/SImiT0LYUN3dciga1KXTuUfqbs8NgOMxwe2Yk8XMZS?=
 =?iso-8859-1?Q?rkmQ66h2SCWwBkfy8FEOku56krlXMw0ipoUdYRLUQLcQR2SZW9BPl+kjiq?=
 =?iso-8859-1?Q?LnKsGbXRpzadkLXs1TZf31KEW5C//E+UbqEpfrjx+pQKXmNSS1k7HOE4fm?=
 =?iso-8859-1?Q?ROkBlCkysBobHBngy5CP4XttPpjCkRht3nNdOJZ2tG3T6eioaYV15NmV21?=
 =?iso-8859-1?Q?Si2KL0LZ4Y47iWNSS/eqGjUOIf7XfERxmpoXPR2buL8Pjo+xkf1mKYFhv+?=
 =?iso-8859-1?Q?Jt3yYZZp3qdKsecWVeDasUPhuyXzQOBFuWfUOsWxLM9pZ34eqfVrRe0SHC?=
 =?iso-8859-1?Q?MoovwIzhZlCu4Z2PkVGNgtMpSDrxv6e8uDv1VawLvg/C49WztQKF2zTQYb?=
 =?iso-8859-1?Q?goB1gl4aatG3RMZYJiaOrwkUZzHRmGbAskBYDrZEp4+iybkfRwvia14N8Y?=
 =?iso-8859-1?Q?k0tPCShwY+2GA874NDYvBi1t1AGG4uj0DdJQTDWIMCFgzWEWMPkDKqBud4?=
 =?iso-8859-1?Q?ekWWnbDdyiNGltE1orkSNG3iNOhca4wLtji8PIT4AQWcGzmJ7OSGxH/azK?=
 =?iso-8859-1?Q?7uzEvoGrkxCyQjNAIxgGAlCbiqtLCLlrFhAz/3Px21UwGimTe72mPJJORn?=
 =?iso-8859-1?Q?iUesCbVQPm6WHY5z0qS0I5qajUNfxGBWU3u5VsdFDdA8Epu3i6Z9UES1X/?=
 =?iso-8859-1?Q?0R6Axq8UntxfW60FRpggn+nLvevU/pigIVc4eUTRVD5lM7OSpV6mTU1cFj?=
 =?iso-8859-1?Q?t9ZNXVjYS3v4xMZObRBr2xMfsQ4kwP/1rsoxjwl5eJGcBQ4WV6e/7PIWGI?=
 =?iso-8859-1?Q?wbGGXtbhdZKcA4L8dRi/OnRRWbS91feJrabo+q6bfSTkrcWWj0rrXGA2jj?=
 =?iso-8859-1?Q?b0eEsBDzWzIAG6G/yMuB/dB7+TBAqG6vV2KquAOyaqb9QvjmljgdEBzTPv?=
 =?iso-8859-1?Q?yYFbvLLCGjrcRsSyHFHmqdINumwZNL69hwONx+BY/Ek7B8FpjFLNaENAhl?=
 =?iso-8859-1?Q?G6Suodqp6Yac1aKvmEK1DB8Jnq0WP7dyHmY6uI46IejM2nSlVHO206/FbB?=
 =?iso-8859-1?Q?Ya1cIFI6grznbTI08WkFuxDs8DtLJwxA0z0w1MCbKRd3Jh53npeVPeX0eh?=
 =?iso-8859-1?Q?8Q1jHnj8fCk/sPj3btxLo182mgixgdABo05z+qVpENNQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?SNHGwfnyQY3/YcAZ1RVB5+CkNfl1R2aq8i+fTW/jZhrhW97M1cLBEgws4E?=
 =?iso-8859-1?Q?CDmhjZqgRuHHrhkIAneN6m0nQGR9I1Vw7M4lkaESdnVoYzQxrZinKr+kab?=
 =?iso-8859-1?Q?xmEi/KgwSyyOczJ2ffHgFdgagKgEP1YykxZRXLocEjdC+a5SvnJfSjkyYQ?=
 =?iso-8859-1?Q?0VFffB0doyPp16O3eJ1vTTPDQQNPtJqU4M+/exy5pXhC1bjFxphemzp3bI?=
 =?iso-8859-1?Q?9trN6OHCqVYtPidqa/gz4pwSI8MtQm7LC/fowieRX1rQl5JoGDP1bADyXL?=
 =?iso-8859-1?Q?dtIDkQDlW/Xj0/ne13Z4S5D8KYYsA9F04pdP6+ehZSwPxe50eUcWUcXMTY?=
 =?iso-8859-1?Q?32kMcbAe9Ug9WHpNEych6TQ3UQ2qvLdmYK934NvilpW/edXdoVm5kifrBN?=
 =?iso-8859-1?Q?JIDhYUboGCb9x118x91/Wp/PCNDJ4LVZQc194eRDxAqSjKTMq9UGtjbxLc?=
 =?iso-8859-1?Q?ieN62IsGhl+ltoE0OvykUzVf6VIj3gZEzxDqrDKom96i3GsmDkdo7UPnyU?=
 =?iso-8859-1?Q?34dyH/lUCPijeLfmpQiSBVhghyxGNWdvfn+BF/JMFuVZ5s8QQxwLIohUNF?=
 =?iso-8859-1?Q?r7ep8ZPhE6ozIsTV2YCIP1vJQia+KVMsGZlekIKQNDI/omo60VJtOZVG/v?=
 =?iso-8859-1?Q?Ph5nt4vI7JBmahZh/UYC6vK74lOkB3+gydf5kr3JTsZf2/EbzLPNbs3oca?=
 =?iso-8859-1?Q?/f13YzuP/QqJPm4AkiTyvGnemy1QOiKTtRkzdgmgVQHo148jrk5VeIJ+sA?=
 =?iso-8859-1?Q?5hq+jZ1exEWJF4iqzHRYIlr2EaCvLL5P6jw7wbJPETJf+VQX/DUPH+GuFE?=
 =?iso-8859-1?Q?l/2Swyht/Cd5TXgvIbkleZodx9+Ls6Oe1MDJ6SZtsYOGLRAAAdk7EBVSdz?=
 =?iso-8859-1?Q?xioYntzHiHic7RTtvvyaG/w+/fcV8uiMykKd/ZyxKsFY37df0lqbwq4fjI?=
 =?iso-8859-1?Q?qZ6gt0ZESJuVjiKKghNx5y9NVeeL7vM0H46LUWMRTcAgUAmirrjduM4qo3?=
 =?iso-8859-1?Q?/o9oxbYXb5b7vapULzobn8wdhA3GTswCS03caQcZdsZlJGYz4LdI7z9Aa3?=
 =?iso-8859-1?Q?TG6n6EwLoNDhm1Rd4jxG3ntMk5K9Vpzhr2beaNbXff4nDXmUD2STEYUtQQ?=
 =?iso-8859-1?Q?/lL4WplGMfWp3bXq0RyiAONKd43nqe5HjSJkwuxVxa/MGpqI/EdUDv6Ujh?=
 =?iso-8859-1?Q?anaXGujZKjR7Udk9mDkxLFsijA5bBUKzx4467DRn4jWpj1oozwNCJY+niQ?=
 =?iso-8859-1?Q?fed3MhCxIsytlN44h9ZCki82cjxWrXNinxH2szwqJZy7D62Auz6S8qo77A?=
 =?iso-8859-1?Q?VIwGU/YIYxRpJ5iSrtmJfXkZwVSIBwG/OTeDiosdTkhaTmO1JjM/VzBIFZ?=
 =?iso-8859-1?Q?VyCX9l49ce095UAQKvONxd/xqvSdzwkX/6+TUYrrPzu5/vJ9cfheC6JLTg?=
 =?iso-8859-1?Q?Rd/A9SVOHqoTwJ87UG4T/GkVBab18lGRByjK/JD1hl/5hbrDhqEqBOxdG1?=
 =?iso-8859-1?Q?JElwVIfvaOR1vFjvh7vxZf5CMXDpwMODgHpV1OnWsyv7qB5chJhA2Yvgt6?=
 =?iso-8859-1?Q?7IG80YN3kEndB+EuSkRHqrn0jx2DT10P2sXznIAgVTUN8sz5CKNGzPq0bI?=
 =?iso-8859-1?Q?tBhD+v34559lhXgdFHlzRlhy6jZ0sBFFFX6Wbo7lkwEVGzsJmRH7mA7nqk?=
 =?iso-8859-1?Q?5YHwBmKuQgsLAp/MH1o=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <2DC4D7DA867A6E4ABED0BACCFBAF426E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+/nHrC1icZjSK1I+E0P+fYduevqgvmgaL5DbE8mruEfSoGjadMCVK/SavqFXQhyvLXbT84WpBN3CIAY7U/WtFEUNCloct2fXcieUlEr4U0qNhWf9nOn3lgJCytu8oiiC+4wtBHZVEbAbUggqtTIh7B4pdB54QFkxfvljdRMprvy76COYLgaoCcURQRZKV/R+N5IAa0AukcEuPmW0LJqxBFZzkr+a2rwwwQAtOr1j2vkZzRsVoQYbiu5umY3euHHvCeC60T9GsVpLiJnPGdoTYwKZ2m/kkCxAGojC6ok58OPaLAzmNPcO2DrKcdD/+hmscooi637gIpopKf0PPTps2BDmbxa1xuyhmhWPY/e0f+k/i2x0Kf9JXJ5ydSkQVxU+GsisCKiUe6l2LRKg3nWPj7UG3LX2KLOdS73JmnJvjW2TByaDu3uiI1r3H52j69b3Jl5vNBF28LdHzdirjqXxQ3WSi3xtSiSAd7p9U/clGAnW4i1YiodgTNKP15JrFqkk97VAw4clYLJL5N8ijkZQyZVYRfRaCJJN7wqth4PpQf0j/SrKCiOGA6eQiGQ6LLmi0z3kI774iLgJzyf6wk6lWLv49orONssH/0ZXfKpEGPHvrla+FYJibSM4w3zgqQpm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3add5c98-8fe7-4096-2519-08de1d0d2ad2
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2025 08:19:12.2303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QSjNnRnEVDxaOWl16/9fE/R61RKPEBvJ8UysSmAz+o+6hzQGGnbTtupcG44ZWu2tRZKPyYbAyt/3Z4zfhx96KHA8eNTUnX8cvWbnpWNTB9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8664

On Nov 05, 2025 / 21:37, Shin'ichiro Kawasaki wrote:
> On Nov 05, 2025 / 10:39, John Garry wrote:
> > On 05/11/2025 08:52, John Garry wrote:
> > > > I don't think the disk supports atomic writes. It is just a regular
> > > > TCMU device,
> > > > and its atomic write related sysfs attributes have value 0:
> > > >=20
> > > > =A0=A0 $ grep -rne . /sys/block/sdh/queue/ | grep atomic
> > > > =A0=A0 /sys/block/sdh/queue/atomic_write_unit_max_bytes:1:0
> > > > =A0=A0 /sys/block/sdh/queue/atomic_write_boundary_bytes:1:0
> > > > =A0=A0 /sys/block/sdh/queue/atomic_write_max_bytes:1:0
> > > > =A0=A0 /sys/block/sdh/queue/atomic_write_unit_min_bytes:1:0
> > > >=20
> > > > FYI, I attach the all sysfs queue attribute values of the device [2=
].
> > >=20
> > > Yes, this would only be using software-based atomic writes.
> > >=20
> > > Shinichiro, do the other atomic writes tests run ok, like 775, 767? Y=
ou
> > > can check group "atomicwrites" to know which tests they are.
> > >=20
> > > 774 is the fio test.

I tried the other "atomicwrites" test. I found g778 took very long time.
I think it implies that g778 may have similar problem as g774.

  g765: [not run] write atomic not supported by this block device
  g767: 11s
  g768: 13s
  g769: 13s
  g770: 35s
  g773: [not run] write atomic not supported by this block device
  g774: did not completed after 3 hours run (and kernel reported the INFO m=
essages)
  g775: 48s
  g776: [not run] write atomic not supported by this block device
  g778: did not completed after 50 minutes run
  x838: [not run] External volumes not in use, skipped this test
  x839: [not run] XFS error injection requires CONFIG_XFS_DEBUG
  x840: [not run] write atomic not supported by this block device

> > >=20
> > > Some things to try:
> > > - use a physical disk for the TEST_DEV

I tried using a real HDD for TEST_DEV, but still observed the hang and INFO
messages at g774.

> > > - Don't set LOAD_FACTOR (if you were setting it). If not, bodge 774 t=
o
> > > reduce $threads to a low value, say, 2

I do not set LOAD_FACTOR. I changed g775 script to set threads=3D2, then th=
e
test case completed quickly, within a few minutes. I'm suspecting that this
short test time might hide the hang/INFO problem.

> > > - trying turning on XFS_DEBUG config

I turned on XFS_DEBUG, and still observed the hang and the INFO messages.

> > >=20
> > > BTW, Darrick has posted some xfs atomics fixes @ https://urldefense.c=
om/
> > > v3/__https://lore.kernel.org/linux-
> > > xfs/20251105001200.GV196370@frogsfrogsfrogs/T/*t__;Iw!!ACWV5N9M2RV99h=
Q! IuEPY6yJ1ZEQu7dpfjUplkPJucOHMQ9cpPvIC4fiJhTi_X_7ImN0t6wGqxg9_GM6gWe4B1OB=
iBjEI8Gz_At0595tIQ$
> > > . I doubt that they will help this, but worth trying.

I have not yet tried this. Will try it tomorrow.=
