Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95813214208;
	Wed, 26 Feb 2025 02:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740535991; cv=fail; b=dUHgCSju78JP1BfOWWx6krpDkv/YYI7LdxWq9wGJ8E+IcXynMWC6JZ+GhM+m8y88PRC0hQpT+Sagv8gNh/GTh3umH6PMNsXpCHsMBm1ihHt6ZoS9obk6XhR5vpvRe5uqlmXaF4SeUQfsX8jvVUmJuF0TNmMNkAsrS3g2uLgMND4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740535991; c=relaxed/simple;
	bh=LhoAtkKoeNC88nM8G3Bhc1txXcXW7P/zrrhAIa0oAEY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MVILBiWyJHAvVrxJ5Ck+wS2vUQRiOazPmftwZHLfMV4qVCkba96i1WtSWzeey7TTnGOtGAasKrHG7WYcYwfmq3XhxupNJSNAkjLiXo+6JzCGLf7l4xJoLrwoFHLx87c5mwKeE0Zmv5aE4cWIDbmTOIPDqzSpP2s/xO9lZ/U1gE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=N4D4Vfuk; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=L1CLmXKY; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="N4D4Vfuk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="L1CLmXKY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1740535989; x=1772071989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LhoAtkKoeNC88nM8G3Bhc1txXcXW7P/zrrhAIa0oAEY=;
  b=N4D4VfukbCyertqSYme7INT9Qu6EhWaEi9JbBkUXm+33liPa1PAFGnkT
   Y1uqpXpa42oDOXdyrwEbtKTqZ2XV1VGUBwvrLDvsoLKLfLhMYVRlf364y
   G6ouK4YSNBhk6hCf1XG1ukvdHq3n7iaxdC1vJdJ4qhuchtYw/lKhQQ9tX
   yYiXlkpeqR4c9FsBPs2Xp2WGGQendoljyWruFSGptNhHVRGnCKT04oBEN
   jAKSmrwhYd4bU2izBGphZXIKoSd8HkMJuiiwruTWVT1XRX3Q/0aYQZIA5
   9HwF5WX/Y84MsjRNxDhnko7Yg8e1Vx+1LR/aFDoi9sbImFuC9tJiIzddq
   A==;
X-CSE-ConnectionGUID: AjXZ6meeTXerNORorKiFdw==
X-CSE-MsgGUID: sCIWeDQoQ06ZLu383s1Log==
X-IronPort-AV: E=Sophos;i="6.13,316,1732550400"; 
   d="scan'208";a="40735468"
Received: from mail-mw2nam10lp2041.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.41])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2025 10:13:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mS1PdCkrSKybIxsiubbYvYKd9DivS+YlWc05+eoFnWZspuWVlIy4NwXlfgJmmOOtJk808ROhBtgLlLBXoOc3o1xeyRRn23AmdpccmBfLvqyhYFndfvkR+QqG+ifrDg+QgT8PLfGw3Uxu81m+FrR68gWoDtOaWRg+SQeqpeayVkzp7iprD9hQz1vwrJIhWSZuwBF4GYY5420vfLT9VRnO70+FTLOUWWUPz2aeP8nrXvhE8YxNOFAsns5MZ3PsN7z1P6CAEdNtiSle6zeWNfZv3hy1iDqVQP5sxgRtMp4nZMNfZvev72Idq5Y/a6TeJZ9WKD8XwYrdoS8woRJBi1gThQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIOzG/pBbOy5qonmiQ9Q5HJiOFJ2FFL2P1CAMBkcHR4=;
 b=Gp34WIXZuZ+GQ39Rh0OgTfXlPqItWXXOQr8Ebu48sVVMxDgB5zkp+D20roodowszOG/jSZXKsAUCkEB+Z7DUXzL7m/nDhqXUwQBcQ+kdawu1mMpQKGjYVw23+cZlp6/WfRt2snSTVs1m0LBZu7BI1unEfqOWq59ucXpkoSeLjwhByL0nq1tT9k31HwBJH4cWLo7kZ4EZqnq6CiO7LZWyFphcyVNEkyvoOXFPmDcRoEgcRYrhJ/IonVIGgDBQMVZm3nPfePCEGzHodMZAtOfiNoVC4t0kpRxCoQT02DGs9C0/nTYlG9aeXCzDHzY8QFhmNHzH7WaoP3q0vv5imjtVxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIOzG/pBbOy5qonmiQ9Q5HJiOFJ2FFL2P1CAMBkcHR4=;
 b=L1CLmXKYudEHeJx528fpVf2UhPYkaEE1lZqNDZ7PCUBwnI2mXSEDFpv5Z/2VFXqj6REoEpA5xQdCGPoi1KIlZgcBaVqsc26B/OP9lty85vS2T2qzN6huLFzdAeJqKg1nwcBwFRBiet177UliQcKuTdPVZYwBI2nl3sFgQbCkIPc=
Received: from BN0PR04MB8048.namprd04.prod.outlook.com (2603:10b6:408:15f::17)
 by PH0PR04MB7206.namprd04.prod.outlook.com (2603:10b6:510:1b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Wed, 26 Feb
 2025 02:13:01 +0000
Received: from BN0PR04MB8048.namprd04.prod.outlook.com
 ([fe80::2482:b157:963:ed48]) by BN0PR04MB8048.namprd04.prod.outlook.com
 ([fe80::2482:b157:963:ed48%4]) with mapi id 15.20.8489.018; Wed, 26 Feb 2025
 02:13:00 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Dave Chinner <david@fromorbit.com>
CC: "Darrick J. Wong" <djwong@kernel.org>, "zlang@redhat.com"
	<zlang@redhat.com>, "dchinner@redhat.com" <dchinner@redhat.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Johannes Thumshirn
	<Johannes.Thumshirn@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH v3.1 15/34] check: run tests in a private pid/mount
 namespace
Thread-Topic: [PATCH v3.1 15/34] check: run tests in a private pid/mount
 namespace
Thread-Index: AQHbh3g6PWS8ZtrV60aHdJXNmBxlErNYKq4AgABfJACAAE8mgA==
Date: Wed, 26 Feb 2025 02:13:00 +0000
Message-ID: <qjjk4spah52oyautabncgjfluaixy4rbfpuecydm5izauhuqki@lkcw62dpij3o>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094584.1758477.17381421804809266222.stgit@frogsfrogsfrogs>
 <20250214211341.GG21799@frogsfrogsfrogs>
 <6azplgcrw6czwucfm5cr7kh4xorkpwt7zmxoks5m5ptegnyme3@ldg2d6hmmdty>
 <20250225154910.GB6265@frogsfrogsfrogs>
 <Z742RnudifADoj01@dread.disaster.area>
In-Reply-To: <Z742RnudifADoj01@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR04MB8048:EE_|PH0PR04MB7206:EE_
x-ms-office365-filtering-correlation-id: b0ea40de-3d74-4c33-de74-08dd560b183d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?cMlRuVy58X5WWRvmrVdyZ3FdUspEuAO3E9Pj4tked/DQCsgklpra1cmzy3Tz?=
 =?us-ascii?Q?2Nle8PLpAt7hR1WYZSNF9y1hlQdfikj9+JTNSzx2KGvFjdWXHksNozR7G20u?=
 =?us-ascii?Q?5Rzkn4DESqpqaX29Zgmbq1N5L4rqTtDAFzydkoizfdkJjpu4LA0aJbmH0K8y?=
 =?us-ascii?Q?k1+CqynGvRdJD3lm57a1rntS76wappGkskknb+dRkEfwWNl2i1+ggGIkWbjb?=
 =?us-ascii?Q?mlApCaJXcjKmRc55/IrAVco9WV+K2IhTxiTFgAbFnhZjEizgk/+WPZDQ5UYH?=
 =?us-ascii?Q?VroA6fGPoIMlSyApk7qCFQ5UbYyTljX8oJkJA0MbHRzuGJNMajtPNgU+6VhL?=
 =?us-ascii?Q?VRIoK1agz5/49QZQ4NRAVAQSVCsnEiZtwZp8iRfOyrqVou643ovZ3NbeVtCa?=
 =?us-ascii?Q?MmJxy7tqR3nIxN+U1gIlTtLQH4MZOp8obmAIOdkXcC4KLXtHBj4t7HREmp43?=
 =?us-ascii?Q?kb2PKDrnkYwg5ZQ72EL4Sd+tRf0R++OoQQN4/miVbOndZklCLhj3vdL+LsLs?=
 =?us-ascii?Q?UdKfYoVSSPcNPQW8baZPCIlEAePDnanYB8CNQL5giz+xMuKc6p4aeAThciCe?=
 =?us-ascii?Q?+9M/DQh+1mRWDcv+DsT4/p/hx/O2ZqcNbn7ZYOpSqwJYIE2QNYCo4w+tEXkI?=
 =?us-ascii?Q?3dww7Drr4n6pbV3vlbulsz9JW80o3LDQR+T9CDI2ooTNNu6p+w239Bpt8xKS?=
 =?us-ascii?Q?RPPG5qG8yP3pyreeNx6plpEw2dG+PNYRTTjLkr5cKYwa+FXDrCjoaUqrC1k+?=
 =?us-ascii?Q?Jfbw5QaR/kOlOQaBZmTrbs9SmjAWqLWGSHSWHeRdSXdPGHPfWU9aGO/F/vQi?=
 =?us-ascii?Q?WBYSS42QDT3qMD9aXC99UUoRFBIYXEevkqHBDyYhgP0R8oG34zrubGugUzJ5?=
 =?us-ascii?Q?cgdLsBdu3mVthOUJp4N7ge0F50HHoWpChCWpsh0sK86DJ8LD4mObY9J6djqf?=
 =?us-ascii?Q?qg9lFwt+yFHJwN28Zx98CbIbMjKbNEx0Hb6IUKtAqL1fU5Alt/0iW1/+3kQx?=
 =?us-ascii?Q?Gz2PMNhQtjcU1U52knnOUzRIAXLKP47ftp8ad6xjqntkwDjuM/hwOScB5Vbs?=
 =?us-ascii?Q?UCabTKL7tH/aAIR/VXDTbgjkwt4CU3um2TLAgl8ZiFtnAPRNe/GSKubl/4Bv?=
 =?us-ascii?Q?Bu14TS2wJHzigc/JhOWzr7YB/JFocHY519hvb2poACoMOWoEp3PkHCIB6kjn?=
 =?us-ascii?Q?d0zDcMHegdEBjysystzwEFfIZfywLCcEcCQH+csB7LAMJiQFEF1OSO31AG9A?=
 =?us-ascii?Q?WKJHeuH38wHh+ordjNmqe4AcDtRjSVacg+VpWaqG7UvwayR0wxY1i5JK0dpc?=
 =?us-ascii?Q?cVWvSxm0YNUn6FFuS0ZaGkXijbqfDVoNWjFu8vVC+Hca1lv4Z3cy5yLgFeXF?=
 =?us-ascii?Q?HisX0AiYtCCPsLFvgNx5g9NvB/CfKFme5IYM5yj2hf8gvlCUvgOUrkduF0o1?=
 =?us-ascii?Q?pAX6srldrHkQPKMW+0NUqiYCBer05EPA?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR04MB8048.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?XTBXu4SMBMvbXOWJzDhsJ/8pIJzPa/TfFMafklcSrp+MUUFLx8HbgRtcGwC2?=
 =?us-ascii?Q?bKckSTbY5tP5eiA5AbvU64HQu/Keb0iWsoEvMnsF+qAz4EWrH/SioZf7S/te?=
 =?us-ascii?Q?4dcGuwzlkyfS/va+4Vl108WwtxmNYAr6GLeqaeO4x0ClH2NoQHYtnxOLN61B?=
 =?us-ascii?Q?CKuirO9Mq56bvMlSaFAHfGrjsMRRqgxJC0Tp7z149L9OzNm2tvwbWKs/RRFF?=
 =?us-ascii?Q?02zu0W+cYO1IeAoi1LnC6pwA0UJ+tVDXTzXbF/vrKM9PVcTqPxZeUQwTF8hK?=
 =?us-ascii?Q?VBhIbkVi+dY4mTQ5Mw/sipugEKpwHaFYJq7tQ+izTFhn2Fl/Vt2cTFDA7Ee8?=
 =?us-ascii?Q?eyIz7Y+Vkj0lq0N08CWhmpXfN6Kb837WkTkVmd+z4vvDC6vAahlPY8hTgQjc?=
 =?us-ascii?Q?NcnW7VOv2LfX86EEOQxPEWXkCrTCH+i0FwL1a+zVBJhjDIpTsiw0gXO673wp?=
 =?us-ascii?Q?s51o+6D7zC8P8s7HWNSrhw6ey7rgBuhVeWyLHSIM0G97FbLvOnSF1MlhHy/w?=
 =?us-ascii?Q?e/L3wOFiXUX36j5MFVJZ+Bls1mtyzTFzoHl5uZbPGHesLK+12k7vKEvMqkco?=
 =?us-ascii?Q?E56hjRQ6mQiThGJ1AR4RoerkODaU2if660Vvv/xWCvsjEOQSx27q7hiBcHPq?=
 =?us-ascii?Q?+FrJN6CrKJVCvrD0yJKwKnaOHgfqn0ldki9qhoMBSZDVJdAPGqnuK3VywOAX?=
 =?us-ascii?Q?KjRZa21xn875nbMLMj/7U0tEvg55xHJ2MnQ2A4iReSS8wwVA6I0o9gAfgEl7?=
 =?us-ascii?Q?k7DvHI0zjzvYJ//qcyRncTGxhHF8CXURrz10jwRY+r7ooPVamrETJouJJVw5?=
 =?us-ascii?Q?h6oYFoRmSx8qS3liw1mbzYUQHtGcE6RcxggC8vMRCh4kjuXJ0B/p+0LTFfdn?=
 =?us-ascii?Q?R7rKikUxJSn2Sg/L1c+mW5XPnwqphrcQHtqDeXVSxs/sPDvGiF56KPVohydo?=
 =?us-ascii?Q?zk4so0t2sVC3HNb+25fVu4kzSFfLegCHE73Fy8uTdIJ7lJWCHCI2Pgq6Qb0T?=
 =?us-ascii?Q?S1IDrItLWNGsWFjHRPRTC5/vkq6t6G+RbTdiFp23wKBbJ36b2JjFE5JNJDn8?=
 =?us-ascii?Q?37pbUi+0iJtDXKfIEPud+wslXVLBfTkXxYgmGtdzC3bASFQiQ/yjr8USZi2m?=
 =?us-ascii?Q?ac8zVaFtqKB1br3o+AIuPH1EwDTY/s9VkEQmZiZIcgjXfF/22umMaE0Su36t?=
 =?us-ascii?Q?LKzMyi+bKudMAHlgZ8qtSETvdbMISxgCWfshvGOfY2iuU4E0H8nP0VN7i5+H?=
 =?us-ascii?Q?ocI9taMOryVTDltOdrNZLbXkvkL7L7bSpOhkefAUF8E3uP4DuJU+1zKNontb?=
 =?us-ascii?Q?VOoMPi/11bC6+df7amV/p4QAjrPwaW+LgWjnROKnJYzNCOzcEv4kB0+cOf26?=
 =?us-ascii?Q?hEH4QLooYqOR+gwoyn3rnv62b6Cv2t3SqpSMgshFcr4ApBgg7/lDHA0pQL5D?=
 =?us-ascii?Q?5agVKbN3FofYTgJ1IAEy4o0At3752Gsqe3KdCys5Qmmrxlutgdnvp5aRaBa2?=
 =?us-ascii?Q?DsuuIPH/mkZOSV/VYA5+I5Mv16Yeb4YtVO3Bt0iWOApuaqEJYxSaRG812Dgl?=
 =?us-ascii?Q?1YuhsqY0TxBQ4hDT2FahetDzPAg3ZXjOMUxyYlWhACt/5MJsrE1r0L2aBvJf?=
 =?us-ascii?Q?xM/fWGxvlqVStmyLiyIqCmM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A7EFC87CEEAD534490E10CBB99E16A1D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vueBbGpjPbedmVCQoCpUOO8QsJZBrdxrwue/H93p6c60KeHe+fAApUceVePesCq2ZBiz/uzMx5L6bKQOjXuDizvpONrlFoaotj7HMRCIrrjlgYM+UqMr9mgT+Q7E/f2J+/X1o8P57hr6YrhF5Eys8cwX3U1QPXFVPvucLQGuscHe/b1nTmExfxmjMI41U7EIsk7jTgdT9Blevcv7COWDwJRoWqjGIX6NE7vzE1kpkQKIAassr5+/ddkUn6gTSdz/N587FaR8CEJEcwkJc2nTuU/SggZ3HWrYSu5EMvRy4PrJZ9yDqnwPJQ17sZIn/9iYZpZsgHHYigiSBEhQdhtIqO3TaIwfH21V9hDGr79Z9iim/AHnGNyOEnxZZBMtg4035juSrt4MPAiti3IO3mbtULVkXpL+O04CBDSMJbvdOegLfBUrhcgB2xDqg77ixxH8rMz2yI7u/6thKtq109JujOR8DGDVRNvcMwvH6FCn/CSOKtjbQd5aeHg2ballgcMM8kt8fg49J3wc5waZ29cSkyteoFiEDMhTMmv9KR/5RqU1Hx6IYy/SwJzlhnYOTJiksGPdgt39tmNSS2e7/AXqPunuyLOOWWKOwMu7hmpY85ocLe/KGWXIhy9Hr1fdg6bj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR04MB8048.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ea40de-3d74-4c33-de74-08dd560b183d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2025 02:13:00.7638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hNix4Bw0uA3GBk8jSEm0EJhVeBdqZPMD5zPhvxk3BzD01Q7XSMpoy0cvu7kxCVSHbxzAVAZZVMSmekkHhIdxLCgnDJMkpjr/7yYMCbYkg44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7206

On Feb 26, 2025 / 08:29, Dave Chinner wrote:
> On Tue, Feb 25, 2025 at 07:49:10AM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 25, 2025 at 11:27:19AM +0000, Shinichiro Kawasaki wrote:
> > > On Feb 14, 2025 / 13:13, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > >=20
> > > > As mentioned in the previous patch, trying to isolate processes fro=
m
> > > > separate test instances through the use of distinct Unix process
> > > > sessions is annoying due to the many complications with signal hand=
ling.
> > > >=20
> > > > Instead, we could just use nsexec to run the test program with a pr=
ivate
> > > > pid namespace so that each test instance can only see its own proce=
sses;
> > > > and private mount namespace so that tests writing to /tmp cannot cl=
obber
> > > > other tests or the stuff running on the main system.  Further, the
> > > > process created by the clone(CLONE_NEWPID) call is considered the i=
nit
> > > > process of that pid namespace, so all processes will be SIGKILL'd w=
hen
> > > > the init process terminates, so we no longer need systemd scopes fo=
r
> > > > externally enforced cleanup.
> > > >=20
> > > > However, it's not guaranteed that a particular kernel has pid and m=
ount
> > > > namespaces enabled.  Mount (2.4.19) and pid (2.6.24) namespaces hav=
e
> > > > been around for a long time, but there's no hard requirement for th=
e
> > > > latter to be enabled in the kernel.  Therefore, this bugfix slips
> > > > namespace support in alongside the session id thing.
> > > >=20
> > > > Declaring CONFIG_PID_NS=3Dn a deprecated configuration and removing
> > > > support should be a separate conversation, not something that I hav=
e to
> > > > do in a bug fix to get mainline QA back up.
> > > >=20
> > > > Note that the new helper cannot unmount the /proc it inherits befor=
e
> > > > mounting a pidns-specific /proc because generic/504 relies on being=
 able
> > > > to read the init_pid_ns (aka systemwide) version of /proc/locks to =
find
> > > > a file lock that was taken and leaked by a process.
> > >=20
> > > Hello Darrick,
> > >=20
> > > I ran fstests for zoned btrfs using the latest fstests tag v2025.02.2=
3, and
> > > observed all test cases failed with my set up. I bisected and found t=
hat this
> > > commit is the trigger. Let me share my observations.
> > >=20
> > > For example, btrfs/001.out.bad contents are as follows:
> > >=20
> > >   QA output created by 001
> > >   mount: bad usage
> > >   Try 'mount --help' for more information.
> > >   common/rc: retrying test device mount with external set
> > >   mount: bad usage
> > >   Try 'mount --help' for more information.
> > >   common/rc: could not mount /dev/sda on common/config: TEST_DIR (/tm=
p/test) is not a directory
> > >=20
> > > As the last line above shows, fstests failed to find out TEST_DIR, /t=
mp/test.
> > >=20
> > > My set up uses mount point directories in tmpfs, /tmp/*:
> > >=20
> > >   export TEST_DIR=3D/tmp/test
> > >   export SCRATCH_MNT=3D/tmp/scratch
> > >=20
> > > I guessed that tmpfs might be a cause. As a trial, I modified these t=
o,
> > >=20
> > >   export TEST_DIR=3D/var/test
> > >   export SCRATCH_MNT=3D/var/scratch
> > >=20
> > > then I observed the failures disappeared. I guess this implies that t=
he commit
> > > for the private pid/mount namespace makes tmpfs unique to each namesp=
ace. Then,
> > > the the mount points in tmpfs were not found in the private namespace=
s context,
> > > probably.
> >=20
> > Yes, /tmp is now private to the test program (e.g. tests/btrfs/001) so
> > that tests run in parallel cannot interfere with each other.
> >=20
> > > If this guess is correct, in indicates that tmpfs can no longer be us=
ed for
> > > fstests mount points. Is this expected?
> >=20
> > Expected, yes.  But still broken for you. :(

Darrick, thanks for the clarifications.

> >=20
> > I can think of a few solutions:
> >=20
> > 1. Perhaps run_privatens could detect that TEST_DIR/SCRATCH_MNT start
> > with "/tmp" and bind mount them into the private /tmp before it starts
> > the test.
>=20
> Which then makes it specific to test running, and that makes it
> less suited to use from check-parallel (or any other generic test
> context).
>=20
> > 2. fstests could take care of defining and mkdir'ing the
> > TEST_DIR/SCRATCH_MNT directories and users no longer have to create
> > them.  It might, however, be useful to have them accessible to someone
> > who has ssh'd in to look around after a failure.
>=20
> check-parallel already does this, and it leaves them around after
> the test, so....
>=20
> 4. use check-parallel.

I took a quick look in check-parallel. IIUC, it creates loop devices then i=
t can
not run with real storage devices. I run fstests with real zoned storage
devices regularly, so I'm afraid that this solution does not fit my use cas=
e.

>=20
> > 3. Everyone rewrites their fstests configs to choose something outside
> > of /tmp (e.g. /var/tmp/{test,scratch})?

I'm okay with this, since it is not a big deal to change the mount points i=
n my
test environments.

If this solution is chosen, I suggest to document the restriction and/or ha=
ve
the test script to check the restriction, to avoid the confusion.

>=20
> How many people actually use /tmp for fstests mount points?
>=20
> IMO, it's better for ongoing maintenance to drop support for /tmp
> based mount points (less complexity in infrastructure setup). If
> there are relatively few ppl who do this, perhaps it would be best
> to treat this setup the same as the setsid encapsulation. i.e. works
> for now, but is deprecated and is going to be removed in a years
> time....
>=20
> Then we can simply add a /tmp test to the HAVE_PRIVATENS setting and
> avoid using a private ns for these setups for now. This gives
> everyone who does use these setups time to migrate to a different
> setup that will work with private namespaces correctly, whilst
> keeping the long term maintenance burden of running tests in private
> namespaces down to a minimum.
>=20
> -Dave.
> --=20
> Dave Chinner
> david@fromorbit.com=
