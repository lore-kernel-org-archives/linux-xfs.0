Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7BC1DEFE8
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791300072; cv=fail; b=hAjTk4J2Hm3cYP9gb2NaGxKfZye92BWrcPSam2oIK5gxPYCReSt7lbqR9b3eWWUSeLpqk9m2VWnD9I3h5+Ty0Wiv56Vvif7z2A9N4llmkWtIhA6c/aknOdbhPpecpHSUom7NX+SCxq2TL6lB9KsEq8tZFhV9h/cRqq+t1kpNSm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791300072; c=relaxed/simple;
	bh=02PIZdHPp3G1/nTVuEn6SCfBdu6d9Iy1YKxJ/PNeQHc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LVdGaDdANRlcVpY6sDTGcoIoc2no9kr+G3svGHGyC+2K5IS+6nEwocF5QpUwsKX+jy14A5zaBTAYwwj3znO2elIwfBbYlQwHJ91Jk5IWdx5AoaCOE0Klka/QIIzpz+CqicBr26sGHXWtmIfw8KF1N+SjxVEVNJ1cIreeOqtdCJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lTlRKCes; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ryCwwGoZ; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lTlRKCes";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ryCwwGoZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791300070; x=1822836070;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=02PIZdHPp3G1/nTVuEn6SCfBdu6d9Iy1YKxJ/PNeQHc=;
  b=lTlRKCesJV7eqppVV/qC+xAfVh4m3mAeTclSoDgyfYSMtlVZFZ9sjodt
   QEVUYDOfkS82h037tfcS92xBk4wUBRhaIVZuhJB+NUMI+fyLFdtSFa0X2
   4FeJaP1VFSMAoqWENW3FfHhqrcWI7TrOodGIITwOSEyfeHtE8O1FpgCQ8
   btk3vjnKesYnHSHJveujjLdG/eSa0jBpHa6KucOi3gVN/X+GRKu6tX7qX
   tXTUL4fYT+fQ7+oGOVfE78nr1Fagko9v/NxoaZUkA9NqFRKP4dI9pJJwI
   l3jlKODvElGUccJUKqVDL+U817Z50JRlGXRrM7m7L47WnTqrmZTG3/1CJ
   g==;
X-CSE-ConnectionGUID: NywdVXyYQHOsL5LlIukzXA==
X-CSE-MsgGUID: xdeXNEFfQ4Gp+aeozqamfw==
X-IronPort-AV: E=Sophos;i="6.27,143,1786982400"; 
   d="scan'208";a="156467555"
Received: from mail-eastusazon11012068.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Oct 2026 23:21:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KIDyNUSqoRNM68vzskkInww5DKu82f1OetE21L2MWgp9CiGfYpOb5mjwKHJg0pViVe7XyEfT9Jv7D5uAoNZ71ArpJPart3254Y9mxC2ne2KxIlepsUaQ7rWKEgxYqVc1tntgGWAl1bc4C59FHQ1u5eBgOdOaqVQY+8gDMd0/NI8O+y70diq02cMpCIHVRWRytjpW9m7wmbyQ2hAscg96Bceug0IrXDTsOKHVD3bXqrid3qUzubhEgc9zx5+15AA7rswuQfK2pB+o2Q7wDPaWe/H3fZ1aZ4XixJm5smxa4Go97c9GMqdGQ0fn1j5isR6ckJngh1Clza0jHnQjRk+jfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02PIZdHPp3G1/nTVuEn6SCfBdu6d9Iy1YKxJ/PNeQHc=;
 b=bDw3J/X3f8xvacsocsyjowa3bwzGI/2WlutH+pdKqodAr6FL6IyH4ui0gdBTw4v4yD5A/Dlm2W3g62Vd9VkvN3MH2INHlmgT+XGqgtA8EbZqAk4dxTEQYCv2PUztqi3FyuYppzt5CWwmO9f+Al96SwQJsIEXyvjQ28+EzKno06GsAUQCCctolgy0P4ptE9WEMAFSFhOAGYQWxCIZChmDnmmIXQjkNmggRbKfs0ZgkX+AasVLKoVJqW2TFZxSXr/7XnCvj76M4k0lQCVSuo5bK4OegeXUIf9wDP0ccv3jBUsPY+5dAIxyGS6sfJuFHR1yX+rkct9bh8Y/hoY2akQBbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02PIZdHPp3G1/nTVuEn6SCfBdu6d9Iy1YKxJ/PNeQHc=;
 b=ryCwwGoZuEeFjR79oSKMRXms+IG7lFTmdtXaofnjRrjdBt75q5tT98SSwcecbg2ZYEFAtbaDHEQtQdAHxHELKXDybb28nnvV7YjMGMVsEukkRl78l8bE0niDKvYxZ+4ApWDVPrFVM56Qs1rfnT7mrH4sMVpXEX2w34j9evP4ZtE=
Received: from CH4PR04MB9666.namprd04.prod.outlook.com (2603:10b6:610:235::7)
 by CH2PR04MB7109.namprd04.prod.outlook.com (2603:10b6:610:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Tue, 6 Oct
 2026 15:20:57 +0000
Received: from CH4PR04MB9666.namprd04.prod.outlook.com
 ([fe80::c5c2:d54b:103e:3895]) by CH4PR04MB9666.namprd04.prod.outlook.com
 ([fe80::c5c2:d54b:103e:3895%6]) with mapi id 15.21.0472.016; Tue, 6 Oct 2026
 15:20:56 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: "djwong@kernel.org" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "cem@kernel.org"
	<cem@kernel.org>
Subject: Re: [xfsprogs] mkfs: fixup memory leak on exit
Thread-Topic: [xfsprogs] mkfs: fixup memory leak on exit
Thread-Index: AQHdVXtCquID+nF6ek64bdvaE5VYBbbwVlcAgAAyfoCAAA/OgIAACPaA
Date: Tue, 6 Oct 2026 15:20:56 +0000
Message-ID: <ea812e22cfe11d3ab45e0078ea5972c7c0f848d5.camel@wdc.com>
References: <20261006101232.357124-2-wilfred.opensource@gmail.com>
	 <asTQdEMkpzc7_tSd@cronus.toxiclabs.cc>
	 <75bc883c4d45a514aaad949dfe301c3f2a79112a.camel@wdc.com>
	 <20261006144851.GX2705364@frogsfrogsfrogs>
In-Reply-To: <20261006144851.GX2705364@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH4PR04MB9666:EE_|CH2PR04MB7109:EE_
x-ms-office365-filtering-correlation-id: 779618f7-2b0f-4649-43d8-08df23bd6b64
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|366016|376014|23010399003|38070700021|11063799006|4143699003|10067099003|56012099006|260925021911599003|260925022911599003|260925021311599003|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info:
 kg5O08aB7Fy/OtazD6FXy3RUClv6alyXYxcovWtKTesS2vFZprqqirVwJLSB2yITmZM91ckhMxJxIItnH8Mk2df+7NsH7qcy8UQxEeMV8a0Ycf9leA7U20wOrpNxyDKwvb6imHh0wHRiCk2R9OMFiyfI0EPfmY6K+ou6QMAc5buFJ+n6LsTgHuyTF/TLAjtpAFxlBE+0KW0+HdgZYpprFdDVItxNFhRvN4qPgp/z/Ypik7NEHIRzFY49wX3J05CoDSg2t3/LfW25r+E4RKGFjD0YPDZVOSD+JV002dErMm+6hdSCR/ZzsHWkSMTKJW57wjuY6VgvZBbBn8gAd1CS/TqZsVlrBFYgdGBNHPpekInK0Pc3R8bY4vAyeRgXjxWjp7L0sEPo92JEDMTv53Y1w46x3h5c8EAHwp+Asw5ASnoN4Pcn1Hcd1NAQlTEQkuUBbxVgo8gK9Ma9o7mrm9xpohl6K6nzRkZJV/sptVzRqOeUAijCip4Krcpr32CM4g8loCE87nR9tihXa6jsPmfLc0yLsHSk4Kik0ns69Z5ukLwjPWToKQgivP2BoG6JVcWetkKl7gk9d7HNErGaCn69xo3KIXToKLb4cnYcE2nh3HP8Qq3r/354Wsw9AlRaO4mXupkVa/6N/4p0kTVKXGcYkqIbNh2Od+tla/O95puAGntsqsyss1Ygvg+7H4sOl6kMfa7ezPX788Eb668Pu3W/AfrwMlaMuB7w9lV2LxAvn9s=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH4PR04MB9666.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(376014)(23010399003)(38070700021)(11063799006)(4143699003)(10067099003)(56012099006)(260925021911599003)(260925022911599003)(260925021311599003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MnNieHB0MzA4M1l4R2RpUHRKd1BoR0lGc1kwWW81Y1E0cGlWQy9UcGJNbHdx?=
 =?utf-8?B?QnNkdjl0bHNBR3U3NDN2b1hDSVk3dGw2ekwxWEdxcnlWYWI2MFozVXNpVFY3?=
 =?utf-8?B?K2hKOW9oeTBGdytjK3JIYVhWeEhpaytJVUFwekVwcjh0M0FZSkJzUmdjbEh1?=
 =?utf-8?B?M254NDZaeHFtKzJuNXcwazBleDVDd1hiRmRNeDJ0WGF2bEVqOTdVSVROZ0ho?=
 =?utf-8?B?NWx2bEY0U1BBQndwR2dGeHpkWHpNOFZqVWlxWkNiMzExZmREeDM3NU51a0pG?=
 =?utf-8?B?SWZDQ2JDTEc3RFk4Z0pvcHRHaDNxNDY3emFYeThIYnNPc3hZYzF3MVhYdFk2?=
 =?utf-8?B?RUFjNEg5b3Q4azZ6VzVFeHFMdVJhc3NKVkVldEZGMTIwY0VCWjlmd2s3OXgx?=
 =?utf-8?B?bXJQYzJtcUZMbWxDV2c2TGF5UTQxZlpLK09tS0h4eHNtQnBESFltMmZUWEhi?=
 =?utf-8?B?bUQwOGlleVFORHpReFJXTTF1ckx1Slg1VVBjcjJEekhtWDYxU2ZWUGFJQXFM?=
 =?utf-8?B?MXlONmlSRjdoTGhISWdVQVFJSGxWNU1BSjc2TzFlREtIV2xhaVk1SWJqSERM?=
 =?utf-8?B?SU9FQ1FrZlNtYTBWQ2s3VGwyRDNzOGdPN3JuZVcyN2JvSDBjSnBUTFIycHU0?=
 =?utf-8?B?eU4vRFpZRTBuSFNzcEJSNGM5ZnY5N3pzSkFaQzg5d1ZTMHdEaTBhZFZpZW5S?=
 =?utf-8?B?V3dNTy93YjlQOVM3dDFUUm9QNmdQTllaK3ZVZGNGUmlBZGY4Zksvend4WUlz?=
 =?utf-8?B?bms1bC85cUxYY1hLT2tZN3g5T1RSTkdLeE1VN1l5eVFhRXpxaU4vazNnSnU1?=
 =?utf-8?B?ai80YjFETkhvMnM3NTdBU3JzblVMeHFNSTh4M1ROaXR0SjRPTUJ4R2JmWXl4?=
 =?utf-8?B?YkhrV0xBL05KRE9qUFRHNkRsU0UwSUdVVXNwSjhYK0xaWE9CdGptZWs3QzEv?=
 =?utf-8?B?emo2bFFxaXFORHJXbmhrL0c0ZTN6STlOek5LNXg0aDA3YmRpWWRtYzBWYVpK?=
 =?utf-8?B?WEQ1amJERURzSDU2RVc4Rm1RbEVFMit1ZVo1SithckppL0tyMWYvVlR4M3hL?=
 =?utf-8?B?NC85UVc3elBXVGRneldHeVpzcENMbkYyajMybW40YzhzUUNLVTE4UmdXL2RN?=
 =?utf-8?B?Tm9zQTJGdVIxb0VaazlUcVlYSENxcWFJcGlUcEhBejRnczhkVnorY0RnZkR2?=
 =?utf-8?B?NXFXK0pkdFRxV0J1VndDaWY4TE04MVNXNVk0K2kwZXovdmYvU2k5K2J5ckVU?=
 =?utf-8?B?b2wwRG5YOGhMZzl2TlRQTmcrN1hwd3NhdGxBcGxpYkVJbDM5MFFSam9KSmdK?=
 =?utf-8?B?aU5lVWdTUzBweElnRG9jNm03RWt4OGJhVkIvK0dIdzFFT3Q5N0lXWjlTMysw?=
 =?utf-8?B?S1RmSjFJZ0VpdWpLQkNnWExvLzBSVjZ3azBoUnAxMStIUmpSaWdKd3dkTm5i?=
 =?utf-8?B?MFg2dlNvekRPOFlUdnViUEUwZkRyQU9BMCthSHJpc21BQkFpcUpLLyswaE9k?=
 =?utf-8?B?a1J4bWVEKzV2NVNCL0JITWdVWjNBcWtqM0hmWnN3TWNhY0dpeE9rUkIyMUo3?=
 =?utf-8?B?UE1kTm5NQkVNNW5xR05DWFRUdmJZbmtaNXBDcTRhNjN0ZTFWVk9mUlVOWVpz?=
 =?utf-8?B?eTlRRGQwM0x1a3pxYUdkemQyTW13c0wyUjg0cFdGU1l2WWtPdlVhL1liVHpv?=
 =?utf-8?B?Z2hhNzFvYmgrTERid2NZZVA0ZjFHampBVlh0Y28wQnRDcWVncFlTZ2FNc05q?=
 =?utf-8?B?TEo4YWUxTzJkdkFVTENjVktyVHlCc0R3NktzTDJOTGRwN09LakI3ZDdYUVhQ?=
 =?utf-8?B?REFnK2VISFlPUGVzRDR1M2xxWGduWWdYaVE3bzBmZ1BOSzFCZUw4K3Z2UnNn?=
 =?utf-8?B?RWFEQk95UDVEd1ZWeS9IVEZkZHZQYWNxZDZ4ZXNwRE5RUTVYQ2hsdDFNbWFF?=
 =?utf-8?B?eWNNYXZGZHUzUWlGWEprM1JreFJlTUlraFdVaFZQMmVTSEtka2NwV0k2WXBl?=
 =?utf-8?B?WVBWaFZBcGFITjZXVkNpQkxSK1NzWlVpL0VESE5aTm9kQXJWd0RiYkxjcGcx?=
 =?utf-8?B?ZUFIaHM4a0pEYVp3SFM5S3hBNzJ1SFdLdXlJU1RSdzVTK2JSS0NpY2RZSWwr?=
 =?utf-8?B?MjZRZUx0ZitHQUYweTBYWXJCNE5Va2tDTXBUc0ZHRGJqNTdmcmhIdE1IcnE5?=
 =?utf-8?B?ajdleHVSdzlsT1d0T0ducEt4WWVBOWRObnpYcWwvUU5KUUlpbkhOUXdlNlhW?=
 =?utf-8?B?UktWNjV6YVVXS1dMZjdMQldJd2Y3YTkxVEYrYWtwSHNmbGNqR1lDMGczM1Ru?=
 =?utf-8?B?V2RhM2JINXptRGhiVW52Rkg4WUJGR0tLWVJtZkYxWTBGYXBWUExOQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A9ECB0AF15CEE4EB9FEA815561F60BD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	kOFkuIx758hOs9QazAZoVgWOM4H/XrZ0nBPz8JqPriP57RwUGCCO3G9ypLOiLG64z2ljGqKJaaHjxEnoLP5jtucxnLEUTLZdATOlN99HYpxYKwUBiN/sPl9YGQwJ2CELrZP7q7Txr/yeq7keA+Rniu0BUx3ycl5o5FZDwdeP96H508qgz6/6NXAQlRMDZBmpU7Z5UKlDEsD5Q29tKGTsModCBo06Qq0ou1HHWxPCrJd2PzKO5qAnTH+/c8D/WpU1I/JpCJYDwaFJ7/7G+v4BvP4T8d/Ak9MmjZfgOYReT96Lz3EZbOGHfk0knK88cn8xtXHi8YyyYMmydFfvzElfPA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	joh77ZYxEG6PYOT2Ci3sZZvbm32o5sY7ibb4AjZ2qPFiVDcjJgH/n5WiZX4TE4/kFckF+WLZCLGG/ihjrNhvOcyAc4BbhwMJ3eRinjeDStsfg3ngSttUiwe7xFjo354wqc6DSyj/dF5WhTUm9gNqCaz0O/nwoi/7qF73keWkuPznZ5dNqN5K4Dtr9rXZ4bQ6t0LndGEool8sdbpAqNSGEVaMWoJoDohc5jfTfIoKirhXzFxP5fFVIFLNwNhkMLAoJ/OwkssxRrCB6N28sPKL99pRVYisYLJR5cPB0ADM8BdqYKHOsKmTZqg7odz2wU+X7r8URLdZUUxK1JGQxX6l639PwFSZVa6SDU7opAu0kYXr1ormRVZ15GttDL4wYz2c3O1Qi1aZ4P0bZ3DokkKIpCsY6KZHkC64vFlbhZTydEhCCbopyVWe/BDSAcKbwjrLpi2QXjcSUFC9RGl7ISvaYwCGxRZIqGwPnlhIJELyu88JK9S7Q30R7TRlfr5XChiyzPSPqPunYFg7Efr1TA9yN/ljk7XEkmWzQkFpSYX84nhAZ9yW0fPaDViwXE/q+GepTONZwKEJc3TNZmVeEJdR3zKf9QBSpHakci9Nx6mTAoWxPFZZKIrbe+IFUnBfyzOV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH4PR04MB9666.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 779618f7-2b0f-4649-43d8-08df23bd6b64
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2026 15:20:56.7190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2rDJfktVqCiv6R5ribZdLAgb7bNvPjoHwC0xjc34MndWsPgjc0fb5nAGASgoLoUaqDvobg3z8/PvH/xy2r+LYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7109

T24gVHVlLCAyMDI2LTEwLTA2IGF0IDA3OjQ4IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
DQo+IE9uIFR1ZSwgT2N0IDA2LCAyMDI2IGF0IDAxOjUyOjE4UE0gKzAwMDAsIFdpbGZyZWQgTWFs
bGF3YSB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMjYtMTAtMDYgYXQgMTI6NTEgKzAyMDAsIENhcmxv
cyBNYWlvbGlubyB3cm90ZToNCj4gPiA+ID4gwqBta2ZzL3hmc19ta2ZzLmMgfCAzICsrKw0KPiA+
ID4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4gPiA+ID4gDQo+ID4gPiA+
IGRpZmYgLS1naXQgYS9ta2ZzL3hmc19ta2ZzLmMgYi9ta2ZzL3hmc19ta2ZzLmMNCj4gPiA+ID4g
aW5kZXggMzM0MzY3YjguLmZlYzQzOTg3IDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9ta2ZzL3hmc19t
a2ZzLmMNCj4gPiA+ID4gKysrIGIvbWtmcy94ZnNfbWtmcy5jDQo+ID4gPiA+IEBAIC02NTAzLDUg
KzY1MDMsOCBAQCBtYWluKA0KPiA+ID4gPiDCoAkJZXhpdCgxKTsNCj4gPiA+ID4gwqANCj4gPiA+
ID4gwqAJbGlieGZzX2Rlc3Ryb3koJnhpKTsNCj4gPiA+ID4gKwlmcmVlKGNsaS54aS0+ZGF0YS5u
YW1lKTsNCj4gPiA+ID4gKwlmcmVlKGNsaS54aS0+bG9nLm5hbWUpOw0KPiA+ID4gPiArCWZyZWUo
Y2xpLnhpLT5ydC5uYW1lKTsNCj4gPiA+ID4gwqAJcmV0dXJuIDA7DQo+ID4gPiA+IMKgfQ0KPiA+
ID4gDQo+ID4gPiBIbSwgd291bGRuJ3QgcGVyaGFwcyBiZSBiZXR0ZXIgdG8gaG9vayB0aGlzIGlu
dG8gbGlieGZzX2Rlc3Ryb3k/DQo+ID4gPiBBbHRob3VnaCB0aGlzIHdvdWxkIGxpa2VseSBuZWVk
IHNvbWUgb3RoZXIgZXh0cmEgc3VyZ2VyeSBvbg0KPiA+ID4geGZzX2NvcHkuYy4NCj4gPiA+IA0K
PiA+ID4gSXQganVzdCBzb3VuZHMgd2VpcmQgdG8gbWUgdG8gZnJlZSB0aGUgbWVtb3J5IGhlcmUg
J2FmdGVyJyB3ZQ0KPiA+ID4gYWxyZWFkeQ0KPiA+ID4gY2FsbGVkDQo+ID4gPiBsaWJ4ZnNfZGVz
dHJveSgpIGhlcmUuwqANCj4gPiANCj4gPiBBaCB5ZWFoLi4uLiBJIGJhY2stcG9ydGVkIHRoaXMg
b2ZmIHRoZSB4cmFpZCB0cmVlLCB3aGVyZSB3ZSBoYXZlIGENCj4gPiBiaXQNCj4gPiBtb3JlIGNs
ZWFudXAgYWZ0ZXIgbGlieGZzX2Rlc3Ryb3koKSBhbmQgSSB0aGluayBpdCBtYWtlcyBzZW5zZSB0
bw0KPiA+IGRvDQo+ID4gdGhlcmUgYnV0IG1heWJlIG5vdCBoZXJlLi4uDQo+ID4gDQo+ID4gPiBJ
SVVDOiBjbGkueGkgPT0gJnhpIGluIHRoaXMgcGxhY2UsIHNvIGZyZWVpbmcgdXANCj4gPiA+IG1l
bW9yeSBhZnRlciBkZXN0cm95aW5nIHRoZSBzdHJ1Y3QgdXNpbmcgaXQgc291bmRzIGxpa2UgYSB0
aW1lDQo+ID4gPiBib21iLg0KPiA+IA0KPiA+IEkgY2FuIHBsdW1iIHRoaXMgaW50byBsaWJ4ZnNf
ZGVzdHJveSgpIGJ1dCBhcyB5b3UgbWVudGlvbmVkLCBpdA0KPiA+IHdpbGwNCj4gPiBuZWVkIGNo
YW5nZXMgaW4geGZzX2NvcHksIHhmc19kYiBhbmQgeGZzX3JlcGFpciBiZWNhdXNlIHRoZXkgdHJh
Y2sNCj4gPiB0aGUNCj4gPiBhcmd2IHBvaW50ZXJzLCBidXQgd2UgY2FuIGp1c3Qgc3RyZHVwKCku
IERvZXMgdGhhdCBzZWVtIG9rYXk/DQo+IA0KPiBJIGRvbid0IHRoaW5rIHRoaXMgaXMgYmV0dGVy
LsKgIGxpYnhmcycgaW5pdCBmdW5jdGlvbnMgZG8gbm90IGNyZWF0ZQ0KPiBvcg0KPiBhc3NpZ24g
dGhlIGxpYnhmc19pbml0LntkYXRhLGxvZyxydH0ubmFtZSBmaWVsZHMsIHRoZXkgbWVyZWx5IHJl
dXNlDQo+IHdoYXRldmVyIHBvaW50ZXIgdGhlIGNhbGxpbmcgcHJvZ3JhbSBzZXQuwqAgT25seSB0
aGUgY2FsbGVyIGtub3dzDQo+IHdoZXJlDQo+IHRoYXQgcG9pbnRlZCB0byBtZW1vcnkgY2FtZSBm
cm9tIChzdGFjaywgb3B0YXJnLCBkeW5hbWljIGFsbG9jYXRpb24pDQo+IHNvDQo+IG9ubHkgdGhl
IGNhbGxlciBrbm93cyBob3cgdG8gZHJvcCB0aGUgcG9pbnRlci4NCj4gDQo+IFRoZSBvcmlnaW5h
bCBwYXRjaCBpcyBtb3JlIGFwcHJvcHJpYXRlIElNTyBidXQgc2VlaW5nIGFzIHdlJ3JlIGFib3V0
DQo+IHRvDQo+IHJldHVybiBmcm9tIG1haW4gYW5kIHRlcm1pbmF0ZSB0aGUgcHJvY2Vzcywgd2h5
IGRvIHdlIGNhcmU/wqANCg0KSSBhZ3JlZSwgSSBkb24ndCB0aGluayB0aGVyZSdzIGFueSBhY3R1
YWwgaGFybS4gT25seSB0aGF0IGFkZHJzYW4gd2FzDQpjb21wbGFpbmluZyB3aGVuIHJ1bm5pbmcg
bWtmcy54ZnMgKHNlZSBiZWxvdykgYW5kIGl0IHdhcyBqdXN0IGFubm95aW5nDQp0byBmaWx0ZXIg
dGhyb3VnaCBhIGJ1bmNoIG9mIGFjdHVhbCBsZWFrcyB0aGF0IG5lZWRlZCB0byBiZSBmaXhlZC4N
Cg0KYGBgDQo9PTEwMDIwMz09RVJST1I6IExlYWtTYW5pdGl6ZXI6IGRldGVjdGVkIG1lbW9yeSBs
ZWFrcw0KDQpEaXJlY3QgbGVhayBvZiA5IGJ5dGUocykgaW4gMSBvYmplY3QocykgYWxsb2NhdGVk
IGZyb206DQogICAgIzAgMHg3ZjYyMDdhZThhYzQgaW4gc3RyZHVwICgvbGliNjQvbGliYXNhbi5z
by44KzB4ZThhYzQpIChCdWlsZElkOg0KNTM5NWVjNzRmNTRkOWVjN2JmOTdjMDY1ODNkZDM5YTk2
YzIzMDgyMikNCiAgICAjMSAweDAwMDAwMDQxNzVjZSBpbiBnZXRzdHIgL2hvbWUvdHdpbGZyZWQv
d2RjL3hmcy94ZnNwcm9ncy0NCmRldi9ta2ZzL3hmc19ta2ZzLmM6MTc2Nw0KDQpTVU1NQVJZOiBB
ZGRyZXNzU2FuaXRpemVyOiA5IGJ5dGUocykgbGVha2VkIGluIDEgYWxsb2NhdGlvbihzKS4NCmBg
YA0KDQo+ICBBbmQgaWYgd2UNCj4gZG8sIHNob3VsZG4ndCBta2ZzIGFsc28gZnJlZSB0aGUgb3Ro
ZXIgZ2V0c3RyKCkgc3RyaW5ncyBhdHRhY2hlZCB0bw0KPiB0aGUNCj4gY2xpIHN0cnVjdD/CoCBB
bmQgc2hvdWxkbid0IHRoZSBleGl0KDEpIHBhdGhzIGRvIGxpa2V3aXNlPw0KPiAoVG8gYmUgY2xl
YXIsIG15IGFuc3dlcnMgYXJlICJJIGRvbid0IiwgIm5vIiwgYW5kICJubyIgYnV0IEkgY291bGQg
YmUNCj4gY29udmluY2VkLikNCj4gDQoNCk9rYXksIGZhaXIgZW5vdWdoIDopDQoNCldpbGZyZWQN
Cg==
