Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F046388363
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 10:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774260154; cv=fail; b=u6RVI2SFmXS3+RXpqIMaXeCv34y3QaeU8dipHryL6+fwyoWnZRmpkjlFaUVfgLTVrstYy/ukCuw0DTdF2G5seRef67yA9cjdkKEASqW8IqtzkSwoa6yZ7wykwZjf2FOJ0Ul1COHahC6X0BXE2os3R4MeoF06+hi15ZVOwU+7kjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774260154; c=relaxed/simple;
	bh=wFXBGmTE2ZKPkF8tkXS6GCMzVjdD08zFIoT/Rqa9sSk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D+avdsgRzCWqNh2YJEUS7rZyyRQO7ACg+WHcbX0SDo+lrHvOMAYd6iwq1YijysODalcdGjR8J4WIfnr+DFkuDP3+fn7lGiR32CUyxdM3W0Rpi3oUzuS1GkjVAsiQQ+T8dGZsVv10u6D1nD1nCS4aPWnDosSl/tw4soNJO1K8mHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QkJr5imJ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Pqzbh54f; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QkJr5imJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Pqzbh54f"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774260151; x=1805796151;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wFXBGmTE2ZKPkF8tkXS6GCMzVjdD08zFIoT/Rqa9sSk=;
  b=QkJr5imJPP/Cu/9ByECuYE6CrxQpPEknw/ejBmNE7VM7i/xRprVF9yH7
   IfWG+a1siPqWNEifqFd55N4BXnxjmN03jktzjesCNBLDar4asnMLyAkrJ
   z6mktFcIPl/xTtasBDuRXnlYSWm6smMpNopsdGT15c9Iexp4YtmfYZe/5
   1iS3Jw8NpkGkDelpo2cjdayGQZZsHCWjc23DG1TFO7QRE1wTeEOM4+CTI
   s6OWarMo37zVIOW4GQqnqrz7JQaLL81yTfIxkBonSRKYeYhi0IBfP0Com
   WWkmpximqzoxnyN8tiKKGEOcNA+yxsH7jCOPYOfWGAFQSf5RmUdgj32P8
   w==;
X-CSE-ConnectionGUID: QETF5+gnSdajeF2+N8Xt7A==
X-CSE-MsgGUID: j5OHJ/i7R/6TEody7OiV8A==
X-IronPort-AV: E=Sophos;i="6.23,137,1770566400"; 
   d="scan'208";a="143042576"
Received: from mail-southcentralusazon11011062.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.62])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Mar 2026 18:01:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e2z0pwhfdH04fUEHdj5oZbEo8w2hVnh99Pomz+MbKsLzmFbsf/S3ErDQzRppfD4Hc4a61uT3Jy1L8Nbz8vQ3EOISQbHC4TZsrjBvPU+cmzQxlBdvfOuVuHRLe86BYukLdQLdWcDOcqPnIUZoZECe4bIjxZ50No85MCv7nNc+vv9+j8UNDRsxduKrS2fDZ1VpFZgbJkOXwlrPqbp/F7FFiq2I7LoeqheRIR8RsQ6dSln0EYSyPETrol5Ojag13u9BNjlqwDmtKc70xdD59x+8ksuGA715eZ5aAZoxKCG9DTqw8rnQojuTfhxV3qqeCVQ/6D7ck57gVlM4N7fWDF7irw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFXBGmTE2ZKPkF8tkXS6GCMzVjdD08zFIoT/Rqa9sSk=;
 b=bWdo8qEeI09DqcS2ioFH+iDrsaWzfmwo9L5qSNO7BSTypaXZuVK/S3OmOMsYzbFwMdrDNXJ1GB2IXOSaPPcrOG1xUIOa8U4i+1HzGRqxgq5/uRDj0tZLAL7LZsFPDF4aNWL9yFg0r9FmtVaVan5aDCISTmN3pBnMJMKfUjrqYajRJbiKVwgGP+B2rN7GarhF2ZMZDHOvJuQQrA+I0d58O3RQy6ZjWF8G7hcbppvzrB2m+SPPUWIrpDiUGBZl4rQBmf/YUB/mVujBh0bk1kYZWapXEsHEkzYRmxwO1vGmjEFQl/RkPS1uKKrgtX9l3BoT5S8rcAlXlot5IwrGrV6jEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFXBGmTE2ZKPkF8tkXS6GCMzVjdD08zFIoT/Rqa9sSk=;
 b=Pqzbh54f8qg1lYTdNTPRwwBOv9AolNhU2l2Ij1pd/E32SLgh66sdYYBMSfJjm07+Qj4YB3a0ZDRdBaLHDwo6ET77fQ2KhBoYvwnBjGG9Fkv2cZ5SC1wM1EYr4XCAcPAM5OhLWv12AhulWAMAE0zVyrxV2ynDeBmlWtsZUx63Zfg=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MW6PR04MB8842.namprd04.prod.outlook.com (2603:10b6:303:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.25; Mon, 23 Mar
 2026 10:01:14 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 10:01:06 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: start gc on zonegc_low_space attribute updates
Thread-Topic: [PATCH] xfs: start gc on zonegc_low_space attribute updates
Thread-Index: AQHcuGneZFB7TPbR1kKesCchYVi6DLW3fd8AgARpSoA=
Date: Mon, 23 Mar 2026 10:01:06 +0000
Message-ID: <123ef1b0-48dd-4770-87b7-04118a8eb41c@wdc.com>
References: <20260320130256.35225-1-hans.holmberg@wdc.com>
 <20260320143926.GB6223@frogsfrogsfrogs>
In-Reply-To: <20260320143926.GB6223@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MW6PR04MB8842:EE_
x-ms-office365-filtering-correlation-id: 77ae3374-f6a9-4034-238c-08de88c3198c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|19092799006|1800799024|376014|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 pHNdcYI4mx0BbE1pLdiV1PVSJXvD/rMkFZKItIsIWQdXqDEZe0FCeDIEXwWTaMR3vfnifmsbwSo3Ipm5DjxGme+dNbgzOt0a8ZC/BxCUwp69Uh58WzMHQ7pmNKvvrGAInG7XXXA604nbWs6JfBlWuELavZIKfE0QpU8oBkoDvlKJc01BcB2XD1NIYq3HV1xAtgDFdOvgJ1QHpFSdvp3OLciiTG2fQfgvb8ADzUJRh9Vh2J8nPU4tju01w6eiTxNa/PKAjvQz0LzrhiK4b1OlGGk/L1TUYdtL7eXaAoaPLt/ujPXA5Ca8gIbmZb/afcXKS9v3pqu9AQVHr1il3ePvhAJfnmU8mWOkmTENfQKNy66p7sMB1fYP7y8xYHwd0/e/BtXHf2mjPI14vYoXWZ881UM39n3xF42j4qlVspX0OON3r6NluXejVXvkkmwwZyWrRd73/sTAYRQwJ9r918CGeI1jgaY6ShPcpk7aaKEl1qUD2Q7EJfrtRVPbO0CtQJOU8E9IrC/dlDMZVG9HNC8niS82+qGe0ILVIPj/qUbuGomn0zYZS8n3dd3bt6ZVJBwfmxieixrJ2+EII+8IUi5oWHqeTegzf6+31MFaqrI60+oQHY152t1x76HvMc/Ijxx+T/0vxp+hR3z/QlzpxeHV+djJ9MHV3++wJganZ4U5kEp/0UIsjLHhGglc0T6TnwBwdnHjFs/RXwvK+bkplo71c9vzTCw3ZQP8dRUgsGSEnLF16DOJLZ9CAVYIrAsX3ZkLKyxdxNgiq7auKiAqGiREJ4ISJj3mmo5/iEPlAq8n2vA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(376014)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K25CYy9kaTlJOHdCZU1uMGhjQmtxUGswSTJDR2dEYUVjT3BpSEw4c1R4dFJV?=
 =?utf-8?B?dHhib2lxT0JyRTZzRlp1cWI1b0ZsV24yOHRCL0VPNVNGOGtLRGI1c0lKV3g1?=
 =?utf-8?B?MnpORWFLUTl4ZGJJRDZwS2tuMVdpK01oUjNJcFRqc0JJdUtqNTNieXhkSjhN?=
 =?utf-8?B?TTd4ZHVpbjZGSkt6VE5rZlJtTGkvZGdjeVNiai9EdlIyc1JSWExmdDFZZXcv?=
 =?utf-8?B?TFR6cVAzVkhnejE4MTJyN2tna2R2dk5NelB4OFAvVlVyQkNObUZSQkIzZkRC?=
 =?utf-8?B?WGlNdVhGN2JQcWVCeTFwSEpSN0N2L0FnQ2hYaUVtY0tncTFObzc1S2M0VDIw?=
 =?utf-8?B?TDNoampQRGpJZ0kyTEcvblczWVVaaTNLK0UvdVVUZzlFZ2J0ZlAvSzhVRU12?=
 =?utf-8?B?R3dnWFRUWGpNTFF4Z1l2elZiSHBiN3lDb1R6S0xIckM1VzlnbTBjeVlnY2hM?=
 =?utf-8?B?ZnJCMy9sQmppSExxeDU0c2xSaW50U0crYXNvdWpLc0VBM3EvWnc5RVN6YXVZ?=
 =?utf-8?B?eXpiSVdoNEVIbXJjWC9SZzU4eEZvVFNlL20vSXdXTzQ3M1NPTWJoWnBWSTBW?=
 =?utf-8?B?NTZCdTVYWVhTbVRZMjhuVkNZZXVUb1BnTFVlRVZ6WTd6TGk3eFY0ZkFaaStJ?=
 =?utf-8?B?RUR0ZG9kSWZFVUdBbitTWjB3YlpJbjZ0T0hjc2tJdG8zeDlPdWJpQUx5dXdx?=
 =?utf-8?B?RDdiVzNVclFKWGZtSE13am9hRk9nRVh3cmVweVEyczBBaUxvaFgvbnE2dzJM?=
 =?utf-8?B?QWsrTGFkcnBKczNQTE1Fb3djY0JvY2RkbXhPRlVYK2lGc1BKN2t2KzRBbUh3?=
 =?utf-8?B?S3J6QUE2dS9jczFvTG10RmY0cnBzSDg5R1dZWmd3ZHdVdEtHdGJZNFR3WHVk?=
 =?utf-8?B?R1EzeHNCR3EvTXpGaFlLWm95ZUpFaW56Y0trb2VoQTA4Y3c5dExEQlVTdTVR?=
 =?utf-8?B?VTVDdkpzWEI3RHB4NTZNVzhVRjFVWVhMNC9XRUtlSTA1dVZuNG05Y1FnT1ZS?=
 =?utf-8?B?bWs4MG5pRlBwUUhuRWVTdmJlMlVDZkpFNFdkWlJueng1MGlaSHQ2VW85NDRk?=
 =?utf-8?B?OHJWVGZEeGZMKzY0YTBoc1BxdFdIUHJLbUgyKzBobElJcnoxdnE2d0NTY081?=
 =?utf-8?B?RFY0OFhpTUt5WXRhQ1RwdlhqSGxQNnNVNTFRNVZVVXZDVVhiKzRyMW9FekVV?=
 =?utf-8?B?bHRYa1NGc0hPRnd5ODZOcklpOVdBdGJNUVRFT1ZpWDlPbHR6c2UwZVh5ODB0?=
 =?utf-8?B?eGlPUUowdFBNTjVsZmE2eGQ5RkF2aEtZY09ldmtWZGJ3VFlvZmNlWnd3QWpT?=
 =?utf-8?B?ZkY3aytpTUJGZmpiNkVXclZON3FseUVJLzVCS2dTYm1MNGkzd081aEp5UklO?=
 =?utf-8?B?UjdJYmZuTFNIZDF0VXpsTlQvMk1yNm0zMjNCTExxMjVXSk5vNkcxeVZLdStQ?=
 =?utf-8?B?KzBlcGcxNnZVdysrM0JsNkNGdDAwRDBYbklpN2hDdTVOOU92ZWxySTBVMUZ1?=
 =?utf-8?B?Y3FOOGtELzlCekxtOEl4WVVPTi9pRXpVYjRPeWY2N1lKWVk1UEhrMWtBMTUy?=
 =?utf-8?B?NFpOb0N6bHRzcFF4MHRlcE1palRnKzBnR3pEZDVrdWFkTlpEcXVrOGMzR2tm?=
 =?utf-8?B?Q3VwbGRxQ0MvbUVUd3BxVU9MaWtRaThYcnRSamg5aUV3MXFtYmY1WTJTdVB2?=
 =?utf-8?B?Z08vZkVlMVE1blpCbWlXOWhWWVJYSUh3RUZmZEtOS3k2NURqWTN3RTlTVUdT?=
 =?utf-8?B?NU0xc1VJMmJ3OHVZMnh4MGh1dGtsQWFURkpOUG9sb1lHNTlXbU1zQytjUlhR?=
 =?utf-8?B?c0xOODZZL2pBaEJGNlk5QWtVeHJrM0dPdUZCZ2dZbzY1RkcyUUZCVUpDYWRw?=
 =?utf-8?B?c2FHYzhaOWdNM0NFc0xWd0M0SEt1UlRUWlhhcmZMM2FobWJhVlRqRlQ2V3pR?=
 =?utf-8?B?ZlNNM3UrOHllWXU3UEJZTnBiM1BSMVNMSGk5T0lpdkw0TkJoWEZ6ZC95cncv?=
 =?utf-8?B?eW5sc2NCa3FVeDVsMk5UN2haN0ViSzg0TjIrYlQxL2czdSttTEVJQTl6cndy?=
 =?utf-8?B?WlpLVzFDU0ZGQnNRMXF5djJRaUdpaFJQRDhzc1B1cStEQzlUeERGMlppZ2sv?=
 =?utf-8?B?aWtrK3A2bE5oc0tvK050THBDLzlEa2tLT1VxZkNwbHVQN2ZWTjE1Z1Q3VWIr?=
 =?utf-8?B?dnpIM29pamNtVHJ0N2NnYnlrdC84MFhVeEQwREZ0ZnFRR0ExSkdLUzY5RDdh?=
 =?utf-8?B?cWo0aFkwYWxXSkZENDlmN2Z4RUdDa0NRYUU3dVVIZzJoOGVRRmovdktldHBN?=
 =?utf-8?B?dzBCU2Izek5OYjIzck9JM3Nid3ZDbEFHSWZvUmtnblF5cWFmd1llUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B9D4576B52BC84491592E196B527145@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	UjBq/DcUkvmO0XYZ/xblikakCT8TBmVwvFGFQUP7VbavOrjOEa2FPej07LOJ44W51rftKAMZZCreW8cCcE4Pm8TCTTnhIUafM8YW0oEvhGSJb/R2hRIADYolWoyU8FoizCgvsx3fij32SP8URqdMp2nW0R0f/jlVwZHDnKP8tn2PetNPaK+6RCsPTXD4TrZ7ZtCJ9lToQNprxWcLZAkcGCznZKiF7DGbziuit3sQKqLCcz4LbC3ylNUTiGq8Rt3Qw47zzzPxRr/7iUFw+AXyKtvXmUH+pzN3mk9BlvNIMZFUKrj/Og/egc3D8w6Abns4uUEC8Me99TRx7hfP4cigTA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	egFZMqZFobg0vrM7p1Kl4L9/OrOhL0SPj/vYG8NIHPwqQVt4h7PeVGO4uT0r2YuetSY/IXgFFI0t0AXWPpjEtKcQGQ6YHQqdmBpV19WHAWdVCvEL8lp0zryBvoxARtT+MV1x6F/iU7bkQThhmdfkJUHBDp3vP+VbF1+AY7fn0Zjoc1wWJ2F5Lr7K5fvQwy541d5Eqro3NRTDk8I5pEzbWjklsJPUhGrpRKyinI4+LAPvKyEdXdsFSLZfigUK/fjfutu43kjFVreNoCnJ4ZG6AHeNQp6lHYRsqKZIxbHZELTdsx/l8RGVt9L7hiXMw+l6Eo2GDNk4q/foETEHmqPqiZhV4pP5YbIgS//Pjw/P+HME2DHZlFerveUKfJlqk6YIB6gQITWUMyLim2Wny7xegA1Yi3UMVQfoC2+cdjCv6kRQyEaA3ZxqxsruabSqbJbYztL2Uzthp2AiSm7aLzJDC3lRi74TF5r6BtEboCBWYltXdCWnkGx5m+RbsSmRhKqB74jAUtAOd4BKxKhlwpPPY34AwwHpaIm31uCJ+FwZOuRM1reQ5XRVzDaVZFuOJqcFpQKEMg3kQ/LLgmofCl4fpjiHl+b4swOA8lm7URMmzAHnwHfQzrcUOesdqxfphRdq
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ae3374-f6a9-4034-238c-08de88c3198c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2026 10:01:06.1223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fo1e4ReMqOpPKr/Adm2LryWlTMQFnXTXfv7R2hUxB8zn3GjfTCmXiVf8l1fm+r7RPAmPDJ1NJlye9ibZXyeo6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR04MB8842

T24gMjAvMDMvMjAyNiAxNTozOSwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBPbiBGcmksIE1h
ciAyMCwgMjAyNiBhdCAwMjowMjo1NlBNICswMTAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4g
U3RhcnQgZ2MgaWYgdGhlIGFncmVzc2l2ZW5lc3Mgb2Ygem9uZSBnYXJiYWdlIGNvbGxlY3Rpb24g
aXMgY2hhbmdlZA0KPj4gYnkgdGhlIHVzZXIgKGlmIHRoZSBmaWxlIHN5c3RlbSBpcyBub3QgcmVh
ZCBvbmx5KS4NCj4+DQo+PiBXaXRob3V0IHRoaXMgY2hhbmdlLCB0aGUgbmV3IHNldHRpbmcgd2ls
bCBub3QgYmUgdGFrZW4gaW50byBhY2NvdW50DQo+PiB1bnRpbCB0aGUgZ2MgdGhyZWFkIGlzIHdv
a2VuIHVwIGJ5IGUuZy4gYSB3cml0ZS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBIYW5zIEhvbG1i
ZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQo+IA0KPiBUaGlzIHNvdW5kcyBsaWtlIGEgYnVn
IGZpeCwgc28NCj4gDQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2Ni4xNQ0KPiBG
aXhlczogODQ1YWJlYjFmMDZhOGEgKCJ4ZnM6IGFkZCB0dW5hYmxlIHRocmVzaG9sZCBwYXJhbWV0
ZXIgZm9yIHRyaWdnZXJpbmcgem9uZSBHQyIpDQo+IA0KPiBUaGUgem9uZWdjIHN0YXJ0IG1ha2Vz
IHNlbnNlIHRvIG1lDQo+IFJldmlld2VkLWJ5OiAiRGFycmljayBKLiBXb25nIiA8ZGp3b25nQGtl
cm5lbC5vcmc+DQoNClllYWgsIHRoaXMgaXMgcmVhbGx5IGEgYnVnIGZpeCwgdGhhbmtzIGZvciB0
aGUgZml4ZXMgdGFnIQ0KDQo+IA0KPiAtLUQNCj4gDQo+PiAtLS0NCj4+DQo+PiAgZnMveGZzL3hm
c19zeXNmcy5jIHwgOCArKysrKysrLQ0KPj4gIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19zeXNmcy5j
IGIvZnMveGZzL3hmc19zeXNmcy5jDQo+PiBpbmRleCA2Yzc5MDk4MzgyMzQuLmFjMTMyOTk0NDA0
OSAxMDA2NDQNCj4+IC0tLSBhL2ZzL3hmcy94ZnNfc3lzZnMuYw0KPj4gKysrIGIvZnMveGZzL3hm
c19zeXNmcy5jDQo+PiBAQCAtMTQsNiArMTQsNyBAQA0KPj4gICNpbmNsdWRlICJ4ZnNfbG9nX3By
aXYuaCINCj4+ICAjaW5jbHVkZSAieGZzX21vdW50LmgiDQo+PiAgI2luY2x1ZGUgInhmc196b25l
cy5oIg0KPj4gKyNpbmNsdWRlICJ4ZnNfem9uZV9hbGxvYy5oIg0KPj4gIA0KPj4gIHN0cnVjdCB4
ZnNfc3lzZnNfYXR0ciB7DQo+PiAgCXN0cnVjdCBhdHRyaWJ1dGUgYXR0cjsNCj4+IEBAIC03MjQs
NiArNzI1LDcgQEAgem9uZWdjX2xvd19zcGFjZV9zdG9yZSgNCj4+ICAJY29uc3QgY2hhcgkJKmJ1
ZiwNCj4+ICAJc2l6ZV90CQkJY291bnQpDQo+PiAgew0KPj4gKwlzdHJ1Y3QgeGZzX21vdW50CSpt
cCA9IHpvbmVkX3RvX21wKGtvYmopOw0KPj4gIAlpbnQJCQlyZXQ7DQo+PiAgCXVuc2lnbmVkIGlu
dAkJdmFsOw0KPj4gIA0KPj4gQEAgLTczNCw3ICs3MzYsMTEgQEAgem9uZWdjX2xvd19zcGFjZV9z
dG9yZSgNCj4+ICAJaWYgKHZhbCA+IDEwMCkNCj4+ICAJCXJldHVybiAtRUlOVkFMOw0KPj4gIA0K
Pj4gLQl6b25lZF90b19tcChrb2JqKS0+bV96b25lZ2NfbG93X3NwYWNlID0gdmFsOw0KPj4gKwlp
ZiAobXAtPm1fem9uZWdjX2xvd19zcGFjZSAhPSB2YWwpIHsNCj4+ICsJCW1wLT5tX3pvbmVnY19s
b3dfc3BhY2UgPSB2YWw7DQo+PiArCQlpZiAoIXhmc19pc19yZWFkb25seShtcCkpDQo+PiArCQkJ
eGZzX3pvbmVfZ2Nfc3RhcnQobXApOw0KPj4gKwl9DQo+PiAgDQo+PiAgCXJldHVybiBjb3VudDsN
Cj4+ICB9DQo+PiAtLSANCj4+IDIuMzQuMQ0KPj4NCj4+DQo+IA0KDQo=
