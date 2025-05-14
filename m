Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E154C9F;
	Wed, 14 May 2025 10:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747219849; cv=fail; b=hTLA4y5MNyLq7o1jVyZxLlhBvWYjmIRR2qAioTjHnOK//spvBdNHSRjubsO7chG13dhwWjRePp3kIi4P9PvhtyRAg+T85iaFsKJcN384+yxmqa+5xGg/F3uEw6CRK0TgRF78/RqGpPl/wANJ8q+CwSt3Y1l4824WCeJYFlIFJyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747219849; c=relaxed/simple;
	bh=tgUjbGAgdsPDXxXYWCjjJIPArWc1Sv0McPtSVxe97ow=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jIy+/rOIdug8TzyKdBrsaSTuOQx40+8vwL4YNexUEg7XcPlWagX3S7jHl0dpO/9vyEBtELlqZwyFL2N3SbpQfN/SP0IjmjjXcvNfaho7AUCafoCHsvhsHu4tVbNgFbRS9BK0o+URqm/sMrllppcbXff7PBlXXiIF7L3eyI1AP8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qKUT837K; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ja3Hsch8; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qKUT837K";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ja3Hsch8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1747219848; x=1778755848;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=tgUjbGAgdsPDXxXYWCjjJIPArWc1Sv0McPtSVxe97ow=;
  b=qKUT837KAwvZjSG3Xt+5udL9NNbyhb/j9nvRFxJeIQOga5aqA96bOuut
   nK8HeoocVZUFcWj3rrwhKJuidmkTsvQ1bxD1nQ1eQRO0ZXjns5+jIh29C
   x5QkHgEG5C840FLDbLsUElmzXwNsj7gkBSDVmTz+2lSWrQjdfiVBV6EnE
   KvoCwOyV2BQ2Jzs57VqZ7qTrWuij5kd18uEyqxJ1cBChZv6PRYnLjJhXs
   PqnZapu7kDNz77i5mYEyKEJt4nE1lC5AssoLqsbCJJ8nGdi8TAM/I5wgr
   1J6GDDLtkI16L/L05DVmdChTYxL1eH303jdFZsvspHq0nATZzgksN1io+
   w==;
X-CSE-ConnectionGUID: 1LYMCoDLRpudcG/bDichJw==
X-CSE-MsgGUID: jDpv9Dh4SWSnh4SytbyB0Q==
X-IronPort-AV: E=Sophos;i="6.15,288,1739808000"; 
   d="scan'208";a="81835567"
Received: from mail-centralusazlp17010006.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([40.93.13.6])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2025 18:50:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6nIUPH9IZadEjV56PA9iWxka+GzQbYgTpQLmLMt/Zyy3orONu+NpWgFMicQzAlAhWy90/NAWSM/d6iXRFWvFhFZJXeCiRezYTJKuB3siO1CEDtEdwOPboyKif3AMHrbaLAn8OW0BEo63KMjCDZdfcB8+fidKnEeLqYe6lxcL0zTR0qUJOWOyuP+/OS1bMjzbC59lrExzGYoF77arBSevxJsF6yDZMn6wXXcbtcmqdV+FHkyPpHslOJ/Z7WJZqM0tWuzqb3Bv+JjFxGZ4bqP4DCW3NfQmcRb/bKqYvwuAQDLfr0ZsScH9dgMI5luQdMa9uY4gdbH3uimEW7RD73CDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FCV3JVH0UNLfkmLhWx9TQ++YN6NNAxqjguH6MHMQuw=;
 b=A/Bqx77FoeD6w8n+tZjp9OOlkLFPDf0ZD4ILRYAD7YiLtt/cGmifRCy8GzXjtla4a1H2SInuifsRDYMTmrqw87PHK6uzzZtORimz/GBz3PsBOKxjFacJ5MH6Rrm2rBj0cqIcuTUjk4OuCAE3SrVGs7q5gDda1zCBKEEySXO9NksUU99zYFNcDzEz1msp9tNoa8GZvH/C3YVAWQrw0cNoe2qEkJQ3y3sHvqALbtYi+/DRQPQnsvq/sVOWfSTOi7PcL2TWSXexoMshO+tayeNtr97dgOXeoeP9tx756kUgvdXJaFgvvX3GWcGxWghuwG4JuZH6RoHs1LdiogK+Zf5c0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FCV3JVH0UNLfkmLhWx9TQ++YN6NNAxqjguH6MHMQuw=;
 b=ja3Hsch8S3bdR5RuApGoq0K7hW+Xs6wbbW4SYGaWf+QKwozNHe21BipM4KKwOkTy0liTnGHkiY5tT6iaEHDVzFL5AxuO4TROBNqHL1mEsYIsDlU+KQe8rpw34dq++q2LqpYrVjlHfhBpHV/fAeQxJzMCZDzhWsqhLFcmjR6FGhw=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MN2PR04MB7023.namprd04.prod.outlook.com (2603:10b6:208:1e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 10:50:37 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%3]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 10:50:36 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [PATCH 0/2] Add mru cache for inode to zone allocation mapping
Thread-Topic: [PATCH 0/2] Add mru cache for inode to zone allocation mapping
Thread-Index: AQHbxL4GC/HVTvv9KkqeATD7ESwY0Q==
Date: Wed, 14 May 2025 10:50:36 +0000
Message-ID: <20250514104937.15380-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MN2PR04MB7023:EE_
x-ms-office365-filtering-correlation-id: 49671f68-bdaa-49a0-daec-08dd92d528df
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?PnA7NMPge2OAvxFdL59TeFelVfZnsh9IMZZ9ysk3l7FIsg26LnffskDh8U?=
 =?iso-8859-1?Q?GIC/KCnrzU7jaIEWMPz+CX0t6IRx+ab0wejvIXq+wEQxGDPTvtsPaFAJII?=
 =?iso-8859-1?Q?bdY2GOcpsn6dX6ZTHrv8n8QCzNVpmzmbR40/mfjBq62wr1JgK7Zn0UtN8Z?=
 =?iso-8859-1?Q?DJw3IoUXXeUtyPdQRfkKm4SyJ6jSgqKupV7Et1nfiSZ9YbS1hwq4qEUevU?=
 =?iso-8859-1?Q?Z+UkAkn8btc7rYvgSME9v+k216IVz21ba3cctyYhN5uSALSwYYLWAgrwvQ?=
 =?iso-8859-1?Q?nDlzTRso9EoVSEZo5AX8BoDDmsdiik3/BfSE177DFYRpdc/7rx0WPTPHTM?=
 =?iso-8859-1?Q?OOqYU7Ls0YPY7RKkpusnggmvvog0tpN+iOChMreT9NrQn9AD5qyERxFV2X?=
 =?iso-8859-1?Q?EOV6Y2ZaKzso025KPB1N0hKDDTu9fgbDULU4AA4XO81Wmq1wAAq3sQGUKD?=
 =?iso-8859-1?Q?JiNUYo+CM5Td8JMBRNooOVLQiBUMc/Mv0RYRmo3oP4OZOl2sZFl4IJOF2M?=
 =?iso-8859-1?Q?Y3hBvKFU0K5DlJjxdREVgIkzfJU2KNZ2nD4m6GAA8QNQ4OKqGFkuSM6qUO?=
 =?iso-8859-1?Q?dvzkj6Gq6FuAqbyHUqiroRvK1D7JEUzj1hdX+32xcXXEynxK1pElz1C2iK?=
 =?iso-8859-1?Q?Jk3MiojWqZC/qlatCPsqxkubeSJ2+exIwdkmMZpHVYtuwrp+EGTT0tStQ9?=
 =?iso-8859-1?Q?C2rYDoHSB5jr55yYqeiGxs22zjRMZ1KUOPtui68fiI0GqY4dkEiW2TcXSr?=
 =?iso-8859-1?Q?/Giz7DQmPXorJOzVhmRC6KtHNEMLzmFCLpd6T5LzDoh0WQXyNqzJGitnI5?=
 =?iso-8859-1?Q?GE1uGX67EsO9qqzVUEwfL8q6CNeBXVrNBhxTm5+eQrp70yKfI2NoBZvez+?=
 =?iso-8859-1?Q?y9yKhmWN/xcGUPJoXmo7H2SXODh1xfFPAujbVcWDJzgqcNwXv3uXuUAK2a?=
 =?iso-8859-1?Q?5EnQBHRpXyXJlTeChpSJ19UV30Chv0ZRhcQ0gQQjtqP833IQBEWbdcxHWE?=
 =?iso-8859-1?Q?HmFjV49FbFlK8GGdR922agbb0Zgf8GQQPy0GjB98M85lX/ffo3T9r+YjDm?=
 =?iso-8859-1?Q?D2HMKSyJWsM7dMRscPwsRWz1VkGiZiXDEr5pg55p9yRdyIGgdfYoGUZPUf?=
 =?iso-8859-1?Q?bk3gqkR674qJcI7ZE3sraAyxYRzXw1Y6HvOZy7PKiWy9IeISzb5LnjAAGq?=
 =?iso-8859-1?Q?INrn8sCtUk4eAQcAx1k3YX4oLjW6NYP9kUlz2h4AlNnqwioxkWOgbsb05y?=
 =?iso-8859-1?Q?C64ZBOtbRSCQsUonMunI9QqJnzMvA5C9nVwBDEg72cQg44U8s6VwLKUCOt?=
 =?iso-8859-1?Q?muQx3K2xSHtmslLV73oObQqXb3gde0/mOg/fs/V1L/+l7sft0WESafYKng?=
 =?iso-8859-1?Q?4F07A+x1/J9cR1i6+Y818DZbz52u2dV40MRxp8uhmWXCxOOz1Oc1mK/Oam?=
 =?iso-8859-1?Q?xfRUvTqxT3PYmYhSc3L0jev2ckSl+bWdZUViKaL7fTSczZ9xySIE5/tLJu?=
 =?iso-8859-1?Q?o=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?C3k+ZCGWfajew31dHws+2N4uPT5p7MJYHFlbrnngUqYdU/T6FYxm8t+xs2?=
 =?iso-8859-1?Q?PKt+XXT/wyYpuN0ENPowBOGqz9FTwlNy7v+jkaDNpODiPqmNgn7RU5iJSA?=
 =?iso-8859-1?Q?zYEqpNhySRCDbt6r7jCcD9QTFaIW813hj2chnkxcfQ8GR6k781CR3Dh4ny?=
 =?iso-8859-1?Q?ThsTwyF9YwI59bEO8XIdwbNvKIrBmPhIf7keu/pHWE7+PRyAwiXyIa0e0A?=
 =?iso-8859-1?Q?DHXgfg0P6CRGNEhoVo0QEqLne/xaPTR2y3lgrDj1OOkR6QrY4mF/Btsq+h?=
 =?iso-8859-1?Q?lU6sFojlS3vwBouBZMsNLgv4oQQv4fJ63FLfU1Qhna6i4fq9qHk9043qGA?=
 =?iso-8859-1?Q?85SU8NH1eU/GSDfb1xuVSkMxk+LZf0y7hk3APtzij70T1K65KTxyeazJa4?=
 =?iso-8859-1?Q?+Ao9/rrg+6RdaothSIXlIgfRQSn4297EpfmqqLYqepC5tVDoL2E9jYfzn8?=
 =?iso-8859-1?Q?e5sNWJyI0Emikgd7QGUpTEsC9Abzkjz4IJKZZWduhha/rXp8ipLqR9orN1?=
 =?iso-8859-1?Q?x7yg1m1B2uYeSmflpHtRtRc/kZa/Cv7nRoNkUq0R7FQwajOuJrMYOP88kW?=
 =?iso-8859-1?Q?B7zeG/gAoEzCyJ6fiTey+Z6+C6Ijw4NfPbx1mOOtPoeyNQ9Ej5oiCaP4fY?=
 =?iso-8859-1?Q?5ujkCJ9coeVauXRwqYUcLxyZQg5fkQz9uG4Uy1/VCAyGetK7I7vv79Rch3?=
 =?iso-8859-1?Q?+75ziy5kkjTr6XLt67bNWBIudn3fp6k+dApBPZ82VIVQFU+tIJm26RVYQ9?=
 =?iso-8859-1?Q?yZFak43UoRHEojEcZCVo+eKl7c7THfzw4eSkj+Pv42rBJb/v/9UMe3pKQW?=
 =?iso-8859-1?Q?/AFbjgvuPjOdTelJWg10PRxWdUCppJlAaRW3k80DC6FVGxKxNjaoD9G/1S?=
 =?iso-8859-1?Q?ZU6QPX8uTG6rQwU92Yy25IvAHO0LI5p5/v+OdFDjqBX43RnAoLktgu88qr?=
 =?iso-8859-1?Q?MphOYktVmL4QhQJjBEKGdZkN5IjSWTZAFO+d5LGauqXpHOb5moNBjMefGG?=
 =?iso-8859-1?Q?VrzvTgqVnGoLp+RP01K94TvYnMisB6MLbBivlF1zHrYNg8ueJ///X/2voK?=
 =?iso-8859-1?Q?MbaBvxYPkTsak33f4yW4TrC/HkIVZG6FbJZwNfYbDyb8a22+OgTWrsWa6r?=
 =?iso-8859-1?Q?zNz8EgPEKdknGClqbgLmnQ5xfDXdnuWoQweRvjA56xwoGi9E4opzPadF5e?=
 =?iso-8859-1?Q?zBXOtwy0tnOj45L5sPi9CGgLrivGlxV5ivemUdGjVaGVRAJIKGjUyBv1jR?=
 =?iso-8859-1?Q?w9FeT4rnbvPiF7iRVP2werSeC08e9vHxHvmVXg7qWxztCjjYqtbvvo2+R5?=
 =?iso-8859-1?Q?GH78HDDj5bDtDGIDtoJ5Si7YFwXDzN1Hmu9FT9HznhATqsrd8z7fyllg3O?=
 =?iso-8859-1?Q?F4+JEP4ACVP/B43Ri1aCh30i7u44Z/sO+M6X31y1j7vt3CGRgEkcMS4ais?=
 =?iso-8859-1?Q?GaxKhUI3WErjZDyP0gxv/V0dA2hggisf60y+EJ1nVkyngtToq7vutsuAYC?=
 =?iso-8859-1?Q?Kos//1hdQDDByr5uPM86n2CrHM1zVJMLtp42vafaHCw7ZM3xQte6rXNG1V?=
 =?iso-8859-1?Q?hjvb0Pm6fMI9BSEZ4s4AqSYtUOPy5s/HkDbHYdNnGylgtOB6O2b5jzqxYy?=
 =?iso-8859-1?Q?eE8kS4BmxeTw/4k2I9fAl5PG6gZVbtwusrmObEBBKuV9pIm9iW8AB4QQ?=
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
	aJVoFJrE+pPOuWaC0Fjt5JnYi0F/Pr0ympaabJQPSXDNCTNtLUFX/w97aFbzkmUNEnLV8QppJku+NxP+qnIjAn9lqdeiygnal2P6B7b/elT1JanRvGWHSrzVTUcIj0WhrWSYC+SEzex0MLuKUqKJ8p/L0oNtNDtbs4jMwvCILiQ1RTrceXyI+d/6q9Y3TG+svRZj4fSh/q0x/JDAEsK1iKmUrdsBbxALwApWGqTVkKS8PYDqEkYzamVcTZ8J931VzQ/vsDlh7LbTMx3xnoS2eEJjWzcUi9z/MuPcIEqc5YSCTjRJuu2XooURyMJpELfbdxWWwl/9YZ21Zzj3DbAEHifr+yx1fHj+LaW+GT01TWiLcx/Wb85MzrdjPBmuYzHj+PsE1ACAkc+khfpWFaO8TTtYJMJv6p6BjmVuyGM4AId6BfHDiaGtkmIjMrADni6CFzNKRAmd1FQzYPeEMFZUPz4MUX0bFoHgf0Qj2XyqZVz6DRDW8725nzgcS+P3SPXwu6Nj++FcmxaYbk3evXaks92Ywpo1Q5Gs8OQmQgwovdKNgBiR6Hppp2m05OHmedicggWXxhxTvY+Z13gYiNfXLHw5mIRiX/kwE4j55a0EvBmK+7GP11s9FrrKFexEcmYl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49671f68-bdaa-49a0-daec-08dd92d528df
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 10:50:36.7879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GBTg4ruyg8o5s84vKSXYz+5UShOwIik72CbpukCTDwtV5PQXxu802WwI7oIfscY3axbU8uxtV/E7+3dLyF0F9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7023

These patches cleans up the xfs mru code a bit and adds a cache for
keeping track of which zone an inode allocated data to last. Placing
file data in the same zone helps reduce garbage collection overhead,
and with this patch we add support per-file co-location for random
writes.

While I was initially concerned by adding overhead to the allocation
path, the cache actually reduces it as as we avoid going through the
zone allocation algorithm for every random write.

When I run a fio workload with 16 writers to different files in
parallel, bs=3D8k, iodepth=3D4, size=3D1G, I get these throughputs:

baseline	with_cache
774 MB/s	858 MB/s (+11%)

(averaged over three runs ech on a nullblk device)

I see similar, figures when benchmarking on a zns nvme drive (+17%).

No updates in the code since the RFC:
https://www.spinics.net/lists/linux-xfs/msg98889.html

Christoph Hellwig (1):
  xfs: free the item in xfs_mru_cache_insert on failure

Hans Holmberg (1):
  xfs: add inode to zone caching for data placement

 fs/xfs/xfs_filestream.c |  15 ++----
 fs/xfs/xfs_mount.h      |   1 +
 fs/xfs/xfs_mru_cache.c  |  15 ++++--
 fs/xfs/xfs_zone_alloc.c | 109 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 126 insertions(+), 14 deletions(-)

--=20
2.34.1
