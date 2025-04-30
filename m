Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A192144DE;
	Wed, 30 Apr 2025 08:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746002488; cv=fail; b=VFOmA6yfqkIFuZt5dYqY9ffdrxcMCsKkOxkxPLw34iOUstZjyIpTYIDdUPaCcrCIZCfyoBy85N8dvjBq7FiMhUfalyX2ZebHW2qfKyfwPlFf7mMHb7C7hlfp0NMYg6UQZCKPcEBAvWg++1FhFTzGGejQ/ULDvhYbrkQphlDyvr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746002488; c=relaxed/simple;
	bh=Hh9VaUNZJN6Tl5u4wCcvxQbCni4lTbh+6D4N5v4Yfyw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oDScF70xCTs+IlJKS0fMd1AOkLiR4y2e55n7SnpQOgd700KMqs1J+o98qDrh37jPYk778owxK613HzxVm//xdk8EocqXbylmgP+BvC7Og41Lw/+JCEvp9P0wFfX8BDjhtZYvnkYAo3E5gR24y2btgJrEXaCAS+tUsqaaFkQ5aaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bY4tDYqK; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Brhqoo/G; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bY4tDYqK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Brhqoo/G"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746002486; x=1777538486;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hh9VaUNZJN6Tl5u4wCcvxQbCni4lTbh+6D4N5v4Yfyw=;
  b=bY4tDYqK1S8ch3i66mHDe1bYgwRsN09uccDoobobPSoATsp5KbkOLAvW
   Gd9D1ErV0u/Vv4cHtfiS4tNaW+hZhvAEjz3hXfgK1UygaZZQ1RnUWV9d5
   ne+4d9V+3tL9/Y2y7TdgdxCvbxReD0v0utCEqQ9x2p3uI5eakx3X3XoLx
   Kg/cU9Aw7CGyNkhsC3dDtRaM+m76PFl2+m954pj7k+Qvc735PaESHbN0Q
   0OpO1MjzbYNOm6zJQntSimgUurYql3F8bKejzKIyg81ZC0oiN/N8k+nJw
   mCafkpiaubWnKHwJ43eDArikt5EO86uY1Fz6oCltLs2oFfOlXI3++JnOk
   w==;
X-CSE-ConnectionGUID: 7MDYQk7qSyuiQUTlwkqkwg==
X-CSE-MsgGUID: TsTGoH8NS0u+4fV95glAVg==
X-IronPort-AV: E=Sophos;i="6.15,251,1739808000"; 
   d="scan'208";a="83812750"
Received: from mail-northcentralusazlp17013063.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.93.20.63])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2025 16:41:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iRtXRV+QeAhM+urKl2WJnN3tE4szIEsDGljbkGSStVOu4msN2WcjyN8sk6iZMYKNIU+daR3trufPeA1LjDyla/kYHgCDMpNiP6J11i2LpQerDq/arnKuMmzcPscitvNHTr7q0IQs/T9ehPQrAtjxqEJmoSpy1L46jl/9r7MlS7loRMyq7cSNkrOkJ/x3NrSjPlQYhtLnydgiW5yJ8IVjiOcEHdMrvK+NDPr5n7QRgN1Dc0kS5tjdQhMRWXgoCntGZC5xLab9v46yKUCjdJRA3BeT1ydAQnmf39YPz1woObLx+Q1K6uqHdndLyQaSNDeqaHIngqbxV4skH6GKlzPjXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=goGXh9Z8fGp/jDM2ReSJP6jbKlKlictK9pJFZKQGvVQ=;
 b=eoQpI5waSKrxlUkRt2fbVH06JLTOncvkpj+iSdaa86x2aozuzSRewnHH+dv4rUY95bH8TpnTnR8C+U0o8+N67wWgmLXzZA1bCuFJsd89nnTt1FR4fvy8ZsiRey/lhK4iKYnKs9d2ye6BqYJffh3FBM8QikXS6sTCFBiOAU3/ahWAkxrvIulse9Kd5TGACGoM0rOG7YeTBkwJOh7L8uKkmhkr/bJqN7z+X42PP2DUhKW204Qlku6u0ulqAfl5hN1+12Kh7NNHoCxDiA9++WPpAQW2E2WSnZQzbu4wbvEUKXdqGCZeTF+wMLsefBhfGtjooV/eHi9Owy4FF9LhHQEW5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=goGXh9Z8fGp/jDM2ReSJP6jbKlKlictK9pJFZKQGvVQ=;
 b=Brhqoo/GQOR79V2YDd7ifn4S09rUTAYlYF3+WxppkoL09RjgrqkaMaGGy07K6g/D3wwmFuP83cKV/o/8HHtLZsLOcnaNZreiVwQZozOvkRQ+QQcsMLFU5iYjTUJMILW0D+d5W4zSxMEhDK5g0YH5IV9kMHkCnhjno9T8EUr9bfQ=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DM6PR04MB6922.namprd04.prod.outlook.com (2603:10b6:5:246::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 08:41:21 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.028; Wed, 30 Apr 2025
 08:41:21 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [RFC PATCH 1/2] xfs: free the item in xfs_mru_cache_insert on failure
Thread-Topic: [RFC PATCH 1/2] xfs: free the item in xfs_mru_cache_insert on
 failure
Thread-Index: AQHbuauln+ES5jEoZky+2LR11tU/sA==
Date: Wed, 30 Apr 2025 08:41:21 +0000
Message-ID: <20250430084117.9850-2-hans.holmberg@wdc.com>
References: <20250430084117.9850-1-hans.holmberg@wdc.com>
In-Reply-To: <20250430084117.9850-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DM6PR04MB6922:EE_
x-ms-office365-filtering-correlation-id: 8e0c44af-e9c0-4e38-bfce-08dd87c2c887
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?p8PxJWkiXk0riOWz8Vo0yU5DfMgq7eOJRX2LisYR8DUia+Xfldr+AOA7ke?=
 =?iso-8859-1?Q?xq5Vg/+yJfXMtA4aT91g2NVIsLA1+JsWz422jpap8daWumJDkE8Q4jO1ju?=
 =?iso-8859-1?Q?c4P3bQJbtREYZV4I9Dshx3kvYZfOozy70sbs0NZca4AFVqERb3nqllgiyF?=
 =?iso-8859-1?Q?FiVW1mqnp7Oi9YW3NcMnngVkmqSmQjOHPJPhL0Ngw0mZutcMatd++Ozjun?=
 =?iso-8859-1?Q?VmVsdpwfP/v2qPKRDhIjn3Kr+KjVqbUF8LXG2dF2uRNcdAp9R8MrbuEuKW?=
 =?iso-8859-1?Q?AV7FuPzJ04+hxE0zJdxz75FyRRhvDJEkcsu8hIwogAk2D+fDY/oidxImQU?=
 =?iso-8859-1?Q?Y90M+kgTI3st0GZsTwSEUwrZNw7uKVF3TKFkpiRrCJjCz2lOHnaIiif3Rx?=
 =?iso-8859-1?Q?jiCRAC2pl5v/+jVbvAooVYooSjh2fEQOa+M6HwflXLgFh3HiAJaOZ3ILZs?=
 =?iso-8859-1?Q?/aQJW5skeaa6DP9qBdA1LfZc5pbkK2FdMVzFmtEvWOxOXVSBcEgHoZDdno?=
 =?iso-8859-1?Q?5ugEoSKdF6MhHd18n6gIqeXhEse4UgV2e3fYynqUf1txUn/imeO08w0uSN?=
 =?iso-8859-1?Q?udRx5SjqnkeZBFTWSrr2Hc611GTc/2KiqdsLjFppIlhx2nsEhZzEX990Z5?=
 =?iso-8859-1?Q?+NTJCf1tSyjB6Saw81YFjSDCJkVetHD3utNnBu9KOWbf0QlpChld9DK85O?=
 =?iso-8859-1?Q?MHWwGh6c5giscYkbCPyXZCc8NpPvyqXTVhBrkgMQ6KW6CJ/y5rO6TTM1Up?=
 =?iso-8859-1?Q?8TlckmOhAatQ0GLDUsOg5X5lDVKyoN9uA3M7WeHB27epmYsPnoXMyNZuW5?=
 =?iso-8859-1?Q?iEQ3WKtqPWC4Sy7zojgXG0kiGmK61Ok/BZxtsMktvbBMzQLjiwG0O5muaZ?=
 =?iso-8859-1?Q?gILZQZcxBiEz2Rtj+oQpjGtc01TIDRO6gQaPVoRWugsJyXS6OhcUG9pdcA?=
 =?iso-8859-1?Q?vByAcZq4i3SbTjhD4goy7V3G2Q3Q8x1Kjz8w8xhKpPmjlC12BDnYdoHcvd?=
 =?iso-8859-1?Q?UaDFqyn/ASDp8M1U/FIxcrPtjhHoZ/YQR4yzvqsSDD4zh/8EXHtKE6Q/no?=
 =?iso-8859-1?Q?7zyDmk0/rlUPrT4zxnZ4TbT+zNWHBPeev5LDtEnsgGMIuCG8F/MVzNEC49?=
 =?iso-8859-1?Q?EGzdbd99sFV/5Zz7q+5o5inut8bh3NuqzMlE4jdnehhpEUZeK5j5QXbuRV?=
 =?iso-8859-1?Q?9pCn1jXWPTsUhsCZ1vKJ3mlEN3JiRWR09AUOJDEqudhNKX5oYBWPQoWNrJ?=
 =?iso-8859-1?Q?/SXieTA+SN4/yQWnrwihixFvOeY5h4b9mzH92LKayq0Hhq3Wt5yF2h2MOj?=
 =?iso-8859-1?Q?edEt6uhtXHTjvyLZIBIwY+u7uGpX5juq8d63Z+uM9800YujVOOAMi7eS2h?=
 =?iso-8859-1?Q?4zuB+sm2oiY55ICKDr5w1OxzpQgDqsHZiR8dNr3NZFYJWx8yq60vPY5o3T?=
 =?iso-8859-1?Q?rIpbVuf5uOuC3wqeSYv9I/ocfeJYjy2YstxYOPOtoB0L+govvX0sSTgPy7?=
 =?iso-8859-1?Q?uh269v1XjU9BKEXY7Zn5EuU6mj+uabXLHTzkgduWLvBF5hKFmxs2C0vMxH?=
 =?iso-8859-1?Q?IJkJxhs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?W35Yr9X9grStGVWaip7pBwWn9gqTreCr7YNI2UclqV52v79S2OCAMAxU7+?=
 =?iso-8859-1?Q?7kRGviVfjbJws/+OCAQuP3/vmLgucUAOQ0JaHqZpY42SeiZotSHkXDSq7W?=
 =?iso-8859-1?Q?urwARj8JN+4l7EwZlHsxEXNWWFQ9qtNKBAyA8MgFD9Q2Yn87bvtLHT5u6v?=
 =?iso-8859-1?Q?BaDsUKXmaDoQ/VlxwMQLRqZ6P5EXTYoTbVUA2nleHXHrZk12XiC9wkGV97?=
 =?iso-8859-1?Q?ZcJ2MfE7k4BvAESngVSMBy0NLtWiWwaj/MybIJP0aBx1yPIFyg+MBlvsjx?=
 =?iso-8859-1?Q?4TTX03+ga37kiayvEW+Q4pUp10eO9VsOUIzdvgJ64lZjGS/V6mbFd0/PKK?=
 =?iso-8859-1?Q?HjqOqs0LIiVMgROtLwq3RsmEUEfEkoKl9nuPdqNKYlCHqHZ1mK6DUxv/pw?=
 =?iso-8859-1?Q?8syAuGS2Fg+xItDnoWDUR761giKK1iDeGsVGSiIll8o/q3CmP/USf3O9PP?=
 =?iso-8859-1?Q?yhj+timWjJ9dPleFAQC9HdJ5auCSg/AGbVBtZ5bFJ+LM772aLj6c/vsx9q?=
 =?iso-8859-1?Q?9M1+MxSDJXh3HfmO8IxIiNAOVWOwsfnuUu/YgFGaQLDHC76zCyTX2uF35L?=
 =?iso-8859-1?Q?OHPgw9+kaAz9Hgeq743LfA7ZjwJseo3GOkgJgMnIkFl7MB8GSoOWgIa9WM?=
 =?iso-8859-1?Q?JliREg44ulpjXm0ChTYBKTMmNU61YCl5b0xop+vVkDDsY7Mh7bEvnxxBvw?=
 =?iso-8859-1?Q?67bX9KKNKX1l8N1+gRnwIVQx8Dout30S0t37cOj7+b6gRayfRCx1+vDVkh?=
 =?iso-8859-1?Q?De8DbZ/j0+m7CrVVfmLFhYWKuxLqzXuTxpO4MlfUIXMEaE0RhaMKRW2C2X?=
 =?iso-8859-1?Q?cjZq7QzHR/bkrN7b1k8JrPh9093PdrXeXgA4l0MbKbolYecbxevUo8/azS?=
 =?iso-8859-1?Q?jj/z7x4id3ervUQB5D8/4lVIDLBlMOPioph+TKtp0QGTs/SnWWd++st8st?=
 =?iso-8859-1?Q?FLEjIRmZ8mpIJPOFmiv+JAFUwEg45xVDNJ0A3qASTbGj/67NIWgry7d9xm?=
 =?iso-8859-1?Q?iD7TTAYp6DVREJ2tOxXlMvBUi42RntCEMdi+qUFrXwO05CTz2Lvu4KKoKK?=
 =?iso-8859-1?Q?cRVwAln1vbTxorKUS7UolG/I06K5LbMgMh8Lm3I5qsAWW3F047w/J1cZxo?=
 =?iso-8859-1?Q?lVQKkxklQ9f6/dh3SAQ7qVaydDfutgw4SEOe5oY2QZy1VAetngnSSSI/fr?=
 =?iso-8859-1?Q?zH3Ypq2rbVzGtJi16eFpV5P2JOT/y8RBEEAcTMlu0c/vBWEyn+d7AQDS5i?=
 =?iso-8859-1?Q?wlp42fpPnu4FxBdrMoiFug94Dt/0aKKm1DAIbflnKGpcp3GZDUZimbUREU?=
 =?iso-8859-1?Q?c1WF88nxaHU5N5vwqp3EO2u0qwSW0Mjid722qEI6KKGIHpCsUo9XmSkHEt?=
 =?iso-8859-1?Q?zdWOzuSo/9dfwV/OrKk8jWLiEE8CkNQnXU1iZ2aQKf16ktV9qzEEn75Iap?=
 =?iso-8859-1?Q?GgkGdKyAjhxMfQ3o9yw343XHwUdo/24jIkBCErLQBNOge1YB/FI9KPK97G?=
 =?iso-8859-1?Q?IP+f2UOEKixfwaCpSHu5/FhCBVyNv9nQbBqmTLPI501E2hY230zVvlU/iS?=
 =?iso-8859-1?Q?oCUHa0XRCTkIxrdBrGWGWfmWl21HUC4YQrdXpTyJUX0uwTdcUc6JOxWK/a?=
 =?iso-8859-1?Q?sSi1Q38wwmuD7y9oxENz3EvhdkBAVGW2R21wOTNn/Pji4yTymdSyR8ew?=
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
	VumGvqrzbZ+0WAAeYRmNc+h1nmGmQoAz7FLC5OrIYqeSflf1cS2TibdEfTyhMnWOES2eHnGb7Rn0JLRbo3Y2PesFQSKQtSzNX9hvRa5xyYHE5no1dtSWR9Y0+bUgBhh9LoD07Qpf04j5torhIFPrOadmvNJQwJz7DkuiLCmhIsiZcHXijrTWo5ZFWLuLfZwkwZPLNC9we4TkqX/5wesv4AbL/dNFdHdXauFIow/NCsI+Zep6Vl+GVEeaIYdutnL6HUULE851l27fzycU0bYYCQ0aJ1fTzaHqQkxc4oYPntsH7XgVt4zyScvH1C4PWjX31GcovrNfv/YeWptDyuJnmkxJ0Xk9CQ82ZwZJZf77Inv9Sl/BdkUR7R9+615COzE20fY0bQWAlVrgHLhbGzfKIehrCJT4MzxfSapPLt4h+WdbJlnw5DJQqACaxK+jgSa1J6ORF3G3jHJ3xSnPNhsuOY1c4rWzEcfguv2D5preT8kRQL534NU6j+dF5C+LzjrBE/Xv6U9D+TT6QfzEGXocWTlSbGPb6LBRsYq+ExeZUrcRSInsXzaihWW/vP0B2ojxiFL8sQs0p3Iw5MYGpqFkptDKwXByEAK0EELWSVZlK3UNqr4A6jSUAJR0Z90Yxki6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0c44af-e9c0-4e38-bfce-08dd87c2c887
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 08:41:21.3641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 44hlGHsHhi4M+reVJJmoIu4k9o/JV72nf0V1IPLDW1cOwmVJxNHrHA/RoGJsh8nzsamY76r88y/GA3xkcdqiYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6922

From: Christoph Hellwig <hch@lst.de>

Call the provided free_func when xfs_mru_cache_insert as that's what
the callers need to do anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_filestream.c | 15 ++++-----------
 fs/xfs/xfs_mru_cache.c  | 15 ++++++++++++---
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index a961aa420c48..044918fbae06 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -304,11 +304,9 @@ xfs_filestream_create_association(
 	 * for us, so all we need to do here is take another active reference to
 	 * the perag for the cached association.
 	 *
-	 * If we fail to store the association, we need to drop the fstrms
-	 * counter as well as drop the perag reference we take here for the
-	 * item. We do not need to return an error for this failure - as long as
-	 * we return a referenced AG, the allocation can still go ahead just
-	 * fine.
+	 * If we fail to store the association, we do not need to return an
+	 * error for this failure - as long as we return a referenced AG, the
+	 * allocation can still go ahead just fine.
 	 */
 	item =3D kmalloc(sizeof(*item), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!item)
@@ -316,14 +314,9 @@ xfs_filestream_create_association(
=20
 	atomic_inc(&pag_group(args->pag)->xg_active_ref);
 	item->pag =3D args->pag;
-	error =3D xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
-	if (error)
-		goto out_free_item;
+	xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
 	return 0;
=20
-out_free_item:
-	xfs_perag_rele(item->pag);
-	kfree(item);
 out_put_fstrms:
 	atomic_dec(&args->pag->pagf_fstrms);
 	return 0;
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index d0f5b403bdbe..08443ceec329 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -414,6 +414,8 @@ xfs_mru_cache_destroy(
  * To insert an element, call xfs_mru_cache_insert() with the data store, =
the
  * element's key and the client data pointer.  This function returns 0 on
  * success or ENOMEM if memory for the data element couldn't be allocated.
+ *
+ * The passed in elem is freed through the per-cache free_func on failure.
  */
 int
 xfs_mru_cache_insert(
@@ -421,14 +423,15 @@ xfs_mru_cache_insert(
 	unsigned long		key,
 	struct xfs_mru_cache_elem *elem)
 {
-	int			error;
+	int			error =3D -EINVAL;
=20
 	ASSERT(mru && mru->lists);
 	if (!mru || !mru->lists)
-		return -EINVAL;
+		goto out_free;
=20
+	error =3D -ENOMEM;
 	if (radix_tree_preload(GFP_KERNEL))
-		return -ENOMEM;
+		goto out_free;
=20
 	INIT_LIST_HEAD(&elem->list_node);
 	elem->key =3D key;
@@ -440,6 +443,12 @@ xfs_mru_cache_insert(
 		_xfs_mru_cache_list_insert(mru, elem);
 	spin_unlock(&mru->lock);
=20
+	if (error)
+		goto out_free;
+	return 0;
+
+out_free:
+	mru->free_func(mru->data, elem);
 	return error;
 }
=20
--=20
2.34.1
