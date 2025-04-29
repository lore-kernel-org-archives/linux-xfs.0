Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EFA2BD5A0;
	Tue, 29 Apr 2025 12:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745928208; cv=fail; b=ZgsxL9NJLG5ml64dupUxIvJRPC1rsNOsi0t6KExPNGYmNDjkizcVB5eaDUObIIdJf/QV5xWvRDjQ4Oh+osPMmY8PtosNaeMop0kaoL+NrUlmY3HI77MqXFXCweRb+OOSmedS408cVOyK8+PEaGdVdjRt9IwnI0dMMLUo8l2Qst4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745928208; c=relaxed/simple;
	bh=VZYUexTiorCipX7d+Z+9RMus+QXGZ3yIym6EurrFKI4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nSYpToi3GORkgZmirZzzivwfldJZqMrt2wT4PS3/oSryB1V6poOZUuYtaYF0g/5BlyJ6Qhukn744jGIJ203kzksRZTWXLpSNm35NxleWZI7OMsYcWl3Pd1KyqQ2LKUToCFMuCHaeLv6fWKJPZwElimmYMyh1PA2TJymuwn5Bdx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=etWBQnH0; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=B1wlSVzH; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="etWBQnH0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="B1wlSVzH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745928206; x=1777464206;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VZYUexTiorCipX7d+Z+9RMus+QXGZ3yIym6EurrFKI4=;
  b=etWBQnH02gL83CjqomTQ81T3fWibeNEIrefFG1/EzyMPUJWa30OnbIYx
   Z6XO65C2n/+XT0NobcCcQzDW96tNiKFPRgJ0J5zVlOF9bAVhuXXqNC3x0
   XD+vyjaGNiWVpjTvoDiX7rMNuFExx3UUBcvvOG0JdtitPys/AvTTrq+11
   V8Y2uAtuldHqluESzHIsPJN6CK8/BhDbdtM1fY7FGFjLXEjfxh3zoAESC
   tJBOOG+693MOlZrcLjRW3soasMlaZfLhKNd4Il4M07POD+BTXGWXi1II+
   5HJHrSkjX5iPJysqhjkZDV95zxbWN6aROpzWHeMBOAjaWtbBpamcpxIex
   Q==;
X-CSE-ConnectionGUID: 4812s/E+Rvu5r9LqNnmPrA==
X-CSE-MsgGUID: MatHv1oqQLGzMQTKKBhHQA==
X-IronPort-AV: E=Sophos;i="6.15,249,1739808000"; 
   d="scan'208";a="79725995"
Received: from mail-bn1nam02lp2041.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.41])
  by ob1.hgst.iphmx.com with ESMTP; 29 Apr 2025 20:03:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y/Sy/j+xyFI24fV+6lUpfJKoK4CHqEGJNQvvhZK0nEsaovWJ+urlIaeKr3g26awPMOepIR8PGysUI2b4j7RWx0hNKJxarO/rsOWLw1C5nVGETd2A721YiS1cFS3auZTdQepQ6OmhGQSnFVEVbhmKZgNafUry9RgqQouQt2P81VBWooVTp7n2cyJ54a1vAOXud0W7AfYsJhvyCBI3fbrUdGAoZA7JGnGox4Azx3sjTG9ZfUEvpEAQZ5wu1GVsM2AG8g8D36bNYMy9Xk5gTt38QnJ0JR9asLt0zR5JAGjRUmAwMY6WhiXzf7FyAljgCUEL+4Oy8xuEUmrbq90QKolq2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZYUexTiorCipX7d+Z+9RMus+QXGZ3yIym6EurrFKI4=;
 b=BNzJ5wTfrJ7jAXKVGvG2lciv4vudHWMCxoS3tJGwrmfC/D1PklYwx1lKhfrEbCKNm8QwJnrNbk8J0VIM2flSdL2RTb1wf7Sl0tHzFueOqMc41Jf49o/XB9gowSj7+SDxTxkp5XEBKZDBv9lawKwXRJKgI2trts3mW20T4OQ3HCI5XSbUC9bIlsX6usL4bKte+zXbJY6No+TycK/ueOJusm0dh0QpJXZ+vkoY4skf8a375s5fAMTue9egX14JkjDRfh4boUbbxvyxLqQWOikYUeQle7oUTnsctadTZlxi835rjdY0xYHmMsU0CWr1mNMaDobk2ezniAoMHN+TwrLphA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZYUexTiorCipX7d+Z+9RMus+QXGZ3yIym6EurrFKI4=;
 b=B1wlSVzHgCRKrBAuStB+GGgpAMNrOI9odwxwxKqOiHMmallw6Z7JOOqdZlYueaLxrDy6Bk/VQSr8MUaaD0BPAhj1LAu+77Vhf0aRkv2MBMEIZzDVnjeJuoFIUjBYNbGvflvHReqlXegcOQ5EKHuR2xMlqDo5N77uC6rjG5XsKQE=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DM6PR04MB6528.namprd04.prod.outlook.com (2603:10b6:5:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Tue, 29 Apr
 2025 12:03:20 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 12:03:20 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "fstests@vger.kernel.org" <fstests@vger.kernel.org>, "zlang@kernel.org"
	<zlang@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>, "david@fromorbit.com"
	<david@fromorbit.com>, hch <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: add mount test for read only rt devices
Thread-Topic: [PATCH 1/2] xfs: add mount test for read only rt devices
Thread-Index: AQHbtcDlQOxnpwBoYku+VcbjviMnX7O0euiAgAYW+wA=
Date: Tue, 29 Apr 2025 12:03:20 +0000
Message-ID: <7079f6ce-e218-426a-9609-65428bbdfc99@wdc.com>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-2-hans.holmberg@wdc.com>
 <20250425150331.GG25667@frogsfrogsfrogs>
In-Reply-To: <20250425150331.GG25667@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DM6PR04MB6528:EE_
x-ms-office365-filtering-correlation-id: 47996e47-8583-40fd-4c4e-08dd8715d5d7
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?S2taWWE1a1lFUnI0SXFucEprK0QzZ0p0a1VocmFqaEc5cldCNGZzUHhiTDNp?=
 =?utf-8?B?azdUYzlsTDVqKzgzbHVpZVFnam9pQWZ5b3Jnd2Y1MHJMcGd6YlRHNnVlODNR?=
 =?utf-8?B?TTBTeUZvQTJWTzh2T01YNWhnRitVOVVwVzR5WlhHNzBIRXJkMkVQUVkyb2dz?=
 =?utf-8?B?K3BuUTBHZUdxQ0VDYlRGL3ppNTdRV2lDZTlCY2pZNWhqRGVKMlp5bVBwN2JX?=
 =?utf-8?B?WjBoMWF1V016UXByWCtaanNsbXo4dzJQOFhZS2VyVlVyWWtmbnIwMVI1dlVP?=
 =?utf-8?B?d0VrWklUaUlxbFB4UUtFaDBhL1Z5dmxvT0F3Z3hZc29YR2liT1d6WDRZTmcy?=
 =?utf-8?B?alUydG92d0JZSUFvbElJS2c3dWgzTmdqYzdEUmg0c2pNa252V1RXZzFUR0ty?=
 =?utf-8?B?ZStDcWRUdG10WTIvSDNOVkZ4WUFOdDRkT0xpbVNjem1mKzZMZmFWTGE1cFF4?=
 =?utf-8?B?aGNUNDhwVlQ4UFVYckFIZ2l3blVkczVPY2dnQ3JYOHQ1L1lIWVI2ZGpyMnB3?=
 =?utf-8?B?eVJISTNkcTJXV2IxVkEzcThBVXdyTWN5bkxucnNFRUF4Z3Q3L0sweU1kcXZv?=
 =?utf-8?B?Ly9aN0Q2UnptM3h6U0dPNWVoQmd2ZmRONXRmVHZnZ2FsSGJwL2xMQzhnSERM?=
 =?utf-8?B?a0RLNW8vV0NoYjNzQ2VkS0FJTllsL3N6QW5FZmJ1OFR4RkYrVnpaeEJ2VzE0?=
 =?utf-8?B?RGkvLy9KaCt6U3IwNkcwMDZWWW5DS0JvSVpsNmt0eUJTT0s0U25DaTlaUUQ1?=
 =?utf-8?B?T3BQczJOMDFYN3ZaZFB1WjcyYVdBVHdCenlZWXNUUGtSN3plMnNiaVdOdkpw?=
 =?utf-8?B?YWpYbnZhYTU4R3pnUjMwSkwvalRyY01wQm5EK2d4YkdVQ2NDMUhaSmUrSCtI?=
 =?utf-8?B?aFVIVVVEb0M4eitqbUN5TmFJNXJpZ00vOThqQzJWdGgxVm5oRDZqeFBSSkVq?=
 =?utf-8?B?VjJ2SzR0MWJqN1ZHcE4xS3dPOGFuR2F2ZnYzZ1RFd2hTYnZLem94WXFDRHFr?=
 =?utf-8?B?U1M1WlhtdGJxL2lBV1d5MmtTS1JuQ08xeTFSczJVc0Z2T3daN2tMaVl4Vk8y?=
 =?utf-8?B?ZzlzdHlJUkFWWWhYcHR2Mm5HMVRKVjNzY0dsdmhkVFRTMGpBcmlnd0lCMWhP?=
 =?utf-8?B?b3Z4KzRQeGF2SGVlcUJwQmdQUjZ0MWYzaVhPMFEyamExbDlrQ1NCT3IveGtZ?=
 =?utf-8?B?VG9tbk5oNFY4MHc1dXJMRnFLWVF6Z1dpTTlOZjhlUFd1TzBhcjNta1BnZGFT?=
 =?utf-8?B?Tmtvb0t3NjZsT3dLMVdQTU5Pd0I4V2JlTTNEdm9BK2FOd09NUCt4R0ord2t4?=
 =?utf-8?B?YUtnZUFtZ29TaThLS21MQ2NDa3pWbUlrTFBIL0lLdmZUdzJ5ZjVqWS9icHZT?=
 =?utf-8?B?VjkzQ3poeG1ISWRpM1ZHVVl4V1FlUWlqeHl2TmtOdHdRSWJsNHhZRnB4dUgx?=
 =?utf-8?B?VE90KzBvT2w4cHR5R2liWDhic2laUDhrTmc4OVVjZHhwMHN5WGhhS28vdkFT?=
 =?utf-8?B?dXk1V2JwY3RyWEVWeGFjckxmbVJmc3BLSDNrS1NSR0JYbDVnSHd6cDIwbGRk?=
 =?utf-8?B?T3M3YzRUaC9UOFMvWURLRy8yYjBsRldZbEVQUmovZEl1bUo2R0RXN0FXYnBM?=
 =?utf-8?B?UTRUVSs2OWFZWHkzWHNxK21KTHRaM05KVUVMTCs2Yk92YXVudzlMT1BMRlFh?=
 =?utf-8?B?RU02aUlUWGN1NTUzcnBuNHA1RzlXNzdiVi9CZy95TUpJUlZKTnh1RTZ1blN3?=
 =?utf-8?B?RWdNclk4RnN1aUNvNWpGaVp0eU9QVG1zQTkwaGVLU1pKZDJsNGNpZnVuKzhJ?=
 =?utf-8?B?Ky8zUXFiaEw1Z1pzVC82TkorcDhLWW5FRmFOdWJ1YlVrNlgxYVkzaXRPMmJl?=
 =?utf-8?B?VkdOYkdXcml6UFJNcUdqbVlQK0hjWS9pUzZOMFFJU2c2UTR4WmdISmt1N2dZ?=
 =?utf-8?B?YTBqREcyY3BvREJKbUNqeXR2dXJ4VHVDRmEwYkRJeDNDZWQvNkdJbUpudFBN?=
 =?utf-8?Q?fW2mXlbMiGLjhikKQOu4VoMy+8VMT4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dmdsUVBGUE4yd2VrV3NvQlI1UnFkODJqakluUGF2UjhkUEhtclNBbVhudm4v?=
 =?utf-8?B?eElpY3h1NjMzQlhFQk1NZlZNcTgrSFk3Y3RRenNTZmQ2N25yc2tTWU8wekhG?=
 =?utf-8?B?WFBRd0drK2hXSmVJUkxCVU5sdmxQOTM5NnArK2xmK2VTak8ySCsvanpWTEkr?=
 =?utf-8?B?OHJXczVuOFplYktHaW9qWWhGbnF5VVlyd3NjQ253dFdkTmMzNFYvNzMxWjF6?=
 =?utf-8?B?Z3R2RXpiTi9JZjVUSllYaERwZGJiRHNYWktveFFKRjEyY21jZ3k2Y09rLzh2?=
 =?utf-8?B?cDZlSFlvdTd2bTl4NlhPck9rbENEWDB5dUNoV0NVd2oxRUdDMTdRNzE2Zy9m?=
 =?utf-8?B?a2MyR2R2M3d2RUx6VGJzM0RSOHVsVFVKWWh5YzBIOXozV0VrdzRrM2t1dnZI?=
 =?utf-8?B?Nk5xaE1PdWlnV1dtWTFkKzJ5eWt1eGNINVhlL0NWdzhFNHZwTEI5REY2WkhZ?=
 =?utf-8?B?a1BnV1ZRMEp1M2M0SituT2VDbWt6VGc4WHNzWjhsZDc1NTZ3R0N5QnJxK0J5?=
 =?utf-8?B?ZGd0akJBalZyWDI5T0t4U01DSnpNd2o1R2VTRFlaWlYxU3NrV3Nnb0pQWk1x?=
 =?utf-8?B?ekVaUFpFWEw1cS82NEo3REtmbWlGdC8xWmZZei83bWpQbWR1Q2lxZjlzVU80?=
 =?utf-8?B?bUxyT29wQWhIZDc3OWVvaWVIRDlmSkZSaEVjRVFzWGo3VTFERjdqS09seFZZ?=
 =?utf-8?B?STJxQlUzN1VGSWVpRkoyODFnMndaa3N0YnY2QXByVldiczNWdWd2bDBvNFR5?=
 =?utf-8?B?Ykxad1BhLysxZ05mUkNrTWs5VXBPWFlWUUpQbDhPY0xrL1phZmlSUitUQmNv?=
 =?utf-8?B?SUNXdzZ6c3MwemF1K1hTaWNlK2FOZ28rV3ljcEY2NDhzS3k1TVVQbFh0Y2Er?=
 =?utf-8?B?UmhjYVl0YzQ0Y3ozWFZpQndDOGhCcStYTktSTjhUeVk2VFpwZlUyOC9iVFlW?=
 =?utf-8?B?K3N2TURDSThmcEpsSVI5ZEM3SmZkYy92S0NaQWE0STVUMURoa0tpY2NYbENx?=
 =?utf-8?B?K3hLa2RqaHI3dlB6ekZFejZmSXFuTW1ENkNxVUZxQjZHbDZGRTR3U2xqK3I1?=
 =?utf-8?B?T0lMNWVhZmpWY1BkM0FnQmF0cUw5U1hLOFFjazNpUERQMnkzMHg0WFZ0OHZF?=
 =?utf-8?B?ZEtRZi81MzhTZnRqVkZRaXgrRTBybEhVcnFCSzVvZE95TTF6RHpQcXBUeUFJ?=
 =?utf-8?B?ODRTamNjWDQwYThXVTg2N1FrM3FtV0dKUlQwL1Z0RGtuQ2pOeGhRQ0YzZjUz?=
 =?utf-8?B?aDF3Qkg1WWs3MUJyODVhWDV3ZmpjR0NXTEtrQkt5VHNxQnZma01WWWh6UGNv?=
 =?utf-8?B?UzBDOUYzT2JNVExmN0R5VjZOODhpakNWL20yelRxemVjbVV4a0VQVFBlcDZj?=
 =?utf-8?B?a1dZMFhGZE4wQjZtZm0zeDc1SmErWkg1eXQ5NTB1djFpZ01KZjZtSG4raFpF?=
 =?utf-8?B?UlBPSFFYbUNtd05MUWZKM0g1UnV6cENmSGZVVGFGQ0dRcHpBWnlJWGN5UE5J?=
 =?utf-8?B?Q29QWDdKQ3FqUmwwQ2RpZHRkL0kyMWVHVjA0Zlp6cy9Ua3p5dlozRnIwM29t?=
 =?utf-8?B?SHpnSEF6MVhaWmIrbWlGbGNad29yKzV5TzEweUNPVlhsaUcyMWduVi96eGU0?=
 =?utf-8?B?aUVITDVKNjd0SnJIcURHZGVNTk8xWERTYkVXUjZIOHh3RXdrYzdyWHFRK3I5?=
 =?utf-8?B?eVhjWlZ4bUhCZXJrZFBFUlZnK05aWkpkazNWRWRNVm0rRFhGc3BVdDA4eDM3?=
 =?utf-8?B?L3FWbVhTbTJBTC9SMHVnTWEyai81ZDdaTGJoRWc2K2NoYXcyQTBnNWI5MnNk?=
 =?utf-8?B?Y3VoUCt0SzNxMUFoeGZaZGZEL09lNStoalpPSVY3YUJsdm1QY2QvUmdzUFRL?=
 =?utf-8?B?d21VQUg0aSs4WTdld0tySW1DQVI4ZWE4eUEvd0tHVHhlOVVvYjEydVVlakRk?=
 =?utf-8?B?RjhpNFphb3hWVDY3Z25qVVZ6RVJBSmxZQXp6V2dzVUFWRzUrbjZXVVpFL3Rq?=
 =?utf-8?B?M2JZVFNtNVkzZzhEYlRBQlFpYnpaY3lSVSt3djdHMzVwNDdkQnhrU2YxNHcx?=
 =?utf-8?B?ZnZ5UVhnZ2preFBzSUFMbnpuMGNLckJNb1RSZklQdXdwU3E2ZnRlUnFncklr?=
 =?utf-8?B?akRnMDI2c3N3aFRPb1pIaFg1QW9udVJsR0ZoNTdkMGNTR1pxYldrYm96SU50?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59F7F6EFB601C94DA8E9D7F252F9152C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Uw45ke+c6Afvqx83KPCcoamm5hfw1YVml0p64BOeNQ9zbuGcczc9K+XiBXHtrlo8piSWrk67UxagClko/2KtxzBipwQrYlWNmdOI93Jy4Eh8mY1V1Ns97yLXcVUAk+REUJbNtyVUd0v6ugp+19KMx7qEuKkzn7T7FaShll1Ta1vnq26w7Ou+gZhWDrlvbULBMja+SfZxDSskZyf7jQaOmv5CdvJhrJ170w7fK13RZTf0XfnSXb40QrcPGn6jzS8x6p5HrGbTFZyCozwZc+X8l6ZstKAoSyCfduEvDwXIMGhchy8XR2Dd28/wgmfFCzkQ7qCLAdR8ir6aCgZiTX/TbRY/zann+smQfQVjTbGkAAmZvu2PQMekar22NAOVTUnSEigu58q7bGKmiOjil3PkrfGyAmeHLeqRreI70GfHDFngwoR6MqjThOr3iU4ptZWAaPTaCXWm2EiyYxCyDhJ9yvI5ZDHq1AgBOqN+tnL8i3bwxYelST12M/vVlkjuyRy1+A1i28ibzKBb/Qo82ffxE4K+bS8ZGhpWvEFvv8pk8ZVCvA2+3CQ7uK5rOXP2TKTOxyONOpOO3UFB9x2xY8HMbfIPs3vMXKxdC8c6JJKJv/Dow/20hL8FXTqbQ0GsrWUC
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47996e47-8583-40fd-4c4e-08dd8715d5d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2025 12:03:20.8160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GkabxwWOYaGAdKG4c7wLLT94qU5POWZ20UYb7FTz14bpBtrzES2iM9vYAbnjST1/1za/BHW1dTVhedtWnO+mwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6528

T24gMjUvMDQvMjAyNSAxNzowNCwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBPbiBGcmksIEFw
ciAyNSwgMjAyNSBhdCAwOTowMzoyMkFNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4g
TWFrZSBzdXJlIHRoYXQgd2UgY2FuIG1vdW50IHJ0IGRldmljZXMgcmVhZC1vbmx5IGlmIHRoZW0g
dGhlbXNlbHZlcw0KPj4gYXJlIG1hcmtlZCBhcyByZWFkLW9ubHkuDQo+Pg0KPj4gQWxzbyBtYWtl
IHN1cmUgdGhhdCBydyByZS1tb3VudHMgYXJlIG5vdCBhbGxvd2VkIGlmIHRoZSBkZXZpY2UgaXMN
Cj4+IG1hcmtlZCBhcyByZWFkLW9ubHkuDQo+Pg0KPj4gQmFzZWQgb24gZ2VuZXJpYy8wNTAuDQo+
Pg0KPj4gU2lnbmVkLW9mZi1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29t
Pg0KPj4gLS0tDQo+PiAgdGVzdHMveGZzLzgzNyAgICAgfCA1NSArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4gIHRlc3RzL3hmcy84Mzcub3V0IHwgMTAg
KysrKysrKysrDQo+PiAgMiBmaWxlcyBjaGFuZ2VkLCA2NSBpbnNlcnRpb25zKCspDQo+PiAgY3Jl
YXRlIG1vZGUgMTAwNzU1IHRlc3RzL3hmcy84MzcNCj4+ICBjcmVhdGUgbW9kZSAxMDA2NDQgdGVz
dHMveGZzLzgzNy5vdXQNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvdGVzdHMveGZzLzgzNyBiL3Rlc3Rz
L3hmcy84MzcNCj4+IG5ldyBmaWxlIG1vZGUgMTAwNzU1DQo+PiBpbmRleCAwMDAwMDAwMDAwMDAu
LmIyMGU5YzVmMzNmMg0KPj4gLS0tIC9kZXYvbnVsbA0KPj4gKysrIGIvdGVzdHMveGZzLzgzNw0K
Pj4gQEAgLTAsMCArMSw1NSBAQA0KPj4gKyMhIC9iaW4vYmFzaA0KPj4gKyMgU1BEWC1MaWNlbnNl
LUlkZW50aWZpZXI6IEdQTC0yLjANCj4+ICsjIENvcHlyaWdodCAoYykgMjAwOSBDaHJpc3RvcGgg
SGVsbHdpZy4NCj4+ICsjIENvcHlyaWdodCAoYykgMjAyNSBXZXN0ZXJuIERpZ2l0YWwgQ29ycG9y
YXRpb24NCj4+ICsjDQo+PiArIyBGUyBRQSBUZXN0IE5vLiA4MzcNCj4+ICsjDQo+PiArIyBDaGVj
ayBvdXQgdmFyaW91cyBtb3VudC9yZW1vdW50L3VubW91bnQgc2NlbmFyaW91cyBvbiBhIHJlYWQt
b25seSBydGRldg0KPj4gKyMgQmFzZWQgb24gZ2VuZXJpYy8wNTANCj4+ICsjDQo+PiArLiAuL2Nv
bW1vbi9wcmVhbWJsZQ0KPj4gK19iZWdpbl9mc3Rlc3QgbW91bnQgYXV0byBxdWljaw0KPj4gKw0K
Pj4gK19jbGVhbnVwX3NldHJ3KCkNCj4+ICt7DQo+PiArCWNkIC8NCj4+ICsJYmxvY2tkZXYgLS1z
ZXRydyAkU0NSQVRDSF9SVERFVg0KPj4gK30NCj4+ICsNCj4+ICsjIEltcG9ydCBjb21tb24gZnVu
Y3Rpb25zLg0KPj4gKy4gLi9jb21tb24vZmlsdGVyDQo+PiArDQo+PiArX3JlcXVpcmVfcmVhbHRp
bWUNCj4+ICtfcmVxdWlyZV9sb2NhbF9kZXZpY2UgJFNDUkFUQ0hfUlRERVYNCj4gDQo+IEkgc3Vz
cGVjdCB0aGlzIGlzIGNvcHktcGFzdGVkIGZyb20gZ2VuZXJpYy8wNTAsIGJ1dCBJIHdvbmRlciB3
aGVuDQo+IFNDUkFUQ0hfUlRERVYgY291bGQgYmUgYSBjaGFyYWN0ZXIgZGV2aWNlLCBidXQgbWF5
YmUgdGhhdCdzIGEgcmVsaWMgb2YNCj4gSXJpeCAoYW5kIFNvbGFyaXMgdG9vLCBJSVJDKT8NCg0K
WWVhaCwgdGhpcyB3YXMgY2FycmllZCBvdmVyIGZyb20gZ2VuZXJpYy8wNTAsIGFuZCBJIGNhbiBq
dXN0IGRyb3AgaXQNCnVubGVzcyB0aGVyZSBpcyBhIGdvb2QgcmVhc29uIGZvciBrZWVwaW5nIGl0
Pw0KDQo8cGFyZG9uIHJlcGx5aW5nIGFnYWluIERhcnJpY2ssIGZvcmdvdCB0byByZXBseS1hbGwg
eWVzdGVyZGF5Pg0KDQo+IA0KPiBUaGUgcmVzdCBvZiB0aGUgdGVzdCBsb29rcyBmaW5lIHRvIG1l
IHRob3VnaC4NCj4gDQo+IC0tRA0KPiANCj4+ICtfcmVnaXN0ZXJfY2xlYW51cCAiX2NsZWFudXBf
c2V0cnciDQo+PiArDQo+PiArX3NjcmF0Y2hfbWtmcyAiLWQgcnRpbmhlcml0IiA+IC9kZXYvbnVs
bCAyPiYxDQo+PiArDQo+PiArIw0KPj4gKyMgTWFyayB0aGUgcnQgZGV2aWNlIHJlYWQtb25seS4N
Cj4+ICsjDQo+PiArZWNobyAic2V0dGluZyBkZXZpY2UgcmVhZC1vbmx5Ig0KPj4gK2Jsb2NrZGV2
IC0tc2V0cm8gJFNDUkFUQ0hfUlRERVYNCj4+ICsNCj4+ICsjDQo+PiArIyBNb3VudCBpdCBhbmQg
bWFrZSBzdXJlIGl0IGNhbid0IGJlIHdyaXR0ZW4gdG8uDQo+PiArIw0KPj4gK2VjaG8gIm1vdW50
aW5nIHJlYWQtb25seSBydCBibG9jayBkZXZpY2U6Ig0KPj4gK19zY3JhdGNoX21vdW50IDI+JjEg
fCBfZmlsdGVyX3JvX21vdW50IHwgX2ZpbHRlcl9zY3JhdGNoDQo+PiAraWYgWyAiJHtQSVBFU1RB
VFVTWzBdfSIgLWVxIDAgXTsgdGhlbg0KPj4gKwllY2hvICJ3cml0aW5nIHRvIGZpbGUgb24gcmVh
ZC1vbmx5IGZpbGVzeXN0ZW06Ig0KPj4gKwlkZCBpZj0vZGV2L3plcm8gb2Y9JFNDUkFUQ0hfTU5U
L2ZvbyBicz0xTSBjb3VudD0xIG9mbGFnPWRpcmVjdCAyPiYxIHwgX2ZpbHRlcl9zY3JhdGNoDQo+
PiArZWxzZQ0KPj4gKwlfZmFpbCAiZmFpbGVkIHRvIG1vdW50Ig0KPj4gK2ZpDQo+PiArDQo+PiAr
ZWNobyAicmVtb3VudGluZyByZWFkLXdyaXRlOiINCj4+ICtfc2NyYXRjaF9yZW1vdW50IHJ3IDI+
JjEgfCBfZmlsdGVyX3NjcmF0Y2ggfCBfZmlsdGVyX3JvX21vdW50DQo+PiArDQo+PiArZWNobyAi
dW5tb3VudGluZyByZWFkLW9ubHkgZmlsZXN5c3RlbSINCj4+ICtfc2NyYXRjaF91bm1vdW50IDI+
JjEgfCBfZmlsdGVyX3NjcmF0Y2ggfCBfZmlsdGVyX2VuZGluZ19kb3QNCj4+ICsNCj4+ICsjIHN1
Y2Nlc3MsIGFsbCBkb25lDQo+PiArZWNobyAiKioqIGRvbmUiDQo+PiArc3RhdHVzPTANCj4+IGRp
ZmYgLS1naXQgYS90ZXN0cy94ZnMvODM3Lm91dCBiL3Rlc3RzL3hmcy84Mzcub3V0DQo+PiBuZXcg
ZmlsZSBtb2RlIDEwMDY0NA0KPj4gaW5kZXggMDAwMDAwMDAwMDAwLi4wYTg0M2EwYmEzOTgNCj4+
IC0tLSAvZGV2L251bGwNCj4+ICsrKyBiL3Rlc3RzL3hmcy84Mzcub3V0DQo+PiBAQCAtMCwwICsx
LDEwIEBADQo+PiArUUEgb3V0cHV0IGNyZWF0ZWQgYnkgODM3DQo+PiArc2V0dGluZyBkZXZpY2Ug
cmVhZC1vbmx5DQo+PiArbW91bnRpbmcgcmVhZC1vbmx5IHJ0IGJsb2NrIGRldmljZToNCj4+ICtt
b3VudDogZGV2aWNlIHdyaXRlLXByb3RlY3RlZCwgbW91bnRpbmcgcmVhZC1vbmx5DQo+PiArd3Jp
dGluZyB0byBmaWxlIG9uIHJlYWQtb25seSBmaWxlc3lzdGVtOg0KPj4gK2RkOiBmYWlsZWQgdG8g
b3BlbiAnU0NSQVRDSF9NTlQvZm9vJzogUmVhZC1vbmx5IGZpbGUgc3lzdGVtDQo+PiArcmVtb3Vu
dGluZyByZWFkLXdyaXRlOg0KPj4gK21vdW50OiBjYW5ub3QgcmVtb3VudCBkZXZpY2UgcmVhZC13
cml0ZSwgaXMgd3JpdGUtcHJvdGVjdGVkDQo+PiArdW5tb3VudGluZyByZWFkLW9ubHkgZmlsZXN5
c3RlbQ0KPj4gKyoqKiBkb25lDQo+PiAtLSANCj4+IDIuMzQuMQ0KPj4NCj4gDQoNCg==
