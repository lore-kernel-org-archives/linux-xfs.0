Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C880F18EAB
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 06:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119419; cv=fail; b=gYbIFDP8CSzsZjG9ByKzE2Xc3s7mdRq4utQqVX6k7A6/gvSyxBDgfWhKd5k6uw6oAKpDO9cwDr9yRfgrsHedYk6v5sd7e5DebGA9Q2Ru6meekS0hPq0LqBHe6AQ4DM7pp26PKR611ARczACRuh6p73L/2oqhaBenEGUlM6YXMpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119419; c=relaxed/simple;
	bh=Ip/S6KI3Ce+AO+nVmhsJEwUTx2QivxZnw90X6r9k9FE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j9eQUdB9b40qNosTNCi/fjA0Kjhp/1zqzVcOofWOzEZ/Sq+8sTblvXLhJF+dgu1OHPL8G/Rhb3BlWAf2WwEX2v0fZG62cI5ns6SU3JL94HqC40VMFjLzp0bCvogc0M2hY55851M3RMqpWStU4lW26KS5Blw7BsEOG3G/ypP5ALw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VjQSvRgb; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Futwom5P; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VjQSvRgb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Futwom5P"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1747119417; x=1778655417;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ip/S6KI3Ce+AO+nVmhsJEwUTx2QivxZnw90X6r9k9FE=;
  b=VjQSvRgbo8/mmkJk2ctdEtyeGS8YFb0YFGz+CPIdqm7ppqn+PZ2mgcn4
   HFsqDBOTt/1uuGw+NkLzgCvYhPfPNKCwsBhe9jFay/U6OI4p9oMXYgkKF
   KKMglq+61fGb6mQV9Tgtj4cO6QTMar3OMOPNNZzTTlUACNrA08Zq1cipJ
   RW2gWhp4TGZGZccwDIW96khTi6MGSFoJpz9aOK91uS9F5QYDOhFCh0RkP
   xnFp+c9K3RSVMykw64B0302tsIzlzY+JoIL7H8vReyOPSZk6DckavOpsx
   rCvTAXP9Q7jssMrXBgEv44GXcJthoLa3UqyT5g8TN6X8GCrw5SzUCpYvE
   w==;
X-CSE-ConnectionGUID: NR1I1/V5Sl6GlVRliEAdJA==
X-CSE-MsgGUID: wiAV61CQRcm4omCUgxZhJA==
X-IronPort-AV: E=Sophos;i="6.15,284,1739808000"; 
   d="scan'208";a="86383037"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2025 14:56:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mc/JrXUB7ZTOqqRVZb/nrSCzUri4mM0EKz2SZbNvjZrdf5mYO85KSSQQsAvSvQE5RscyJ4oJa8hIzutA0ChTgzIobFrE1agDjVvwI+BJlXvbaQtWfvcOk5Cd3rkVUA1mSo1Id8pJ6BCRzEkWaD+aVGKNsWGfSsiC2imyVuTN18G3UmU3IWNFfWetn2Kai8dqFh3uI1DVKpQ0KdV9BLTEWgrsdxLPk9NcjB2KmiGOSyOA2tg8fE0yp37P1fmPL80eFLMe+eIVtBY4wT+b8XuJwT9ZW0hbReGTjjGRCFMslxBdeel6IHVcQLV88BHviCKdhihk+nMi+mg2KNpSF12y2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ip/S6KI3Ce+AO+nVmhsJEwUTx2QivxZnw90X6r9k9FE=;
 b=rMbpujX94gjYcu19fM+GW06fN4+uMRtXqyLHWmI8ztGvA4pVisv4lgRh95D94PcFXHGX46NxFbeb+zV0mEVPwkxzIudXqoE+Mdl9HnCofCGI/hDXNwx+syHI6R7TiAkjX6s5AKnwZN0cH6xi34EV9RxlU9Y1v7fz8b/Fs9z/tpHZ8mCXZFIi6g0xGVhPekKl5zKRtJeEGZ6Ib7RWXaKDzWXSUn6HIE8S6b2yzSyXT7WosGKGOXfa/Ob5O8qK2LaDeMeHIGLip3IgrJuB8SGZtDTA4YhJIMEyx68S8zXrtwAGa8p8pZmmGYcyZ2H1c5MTLjxSjT7j6HeT+6ZfU5YU5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ip/S6KI3Ce+AO+nVmhsJEwUTx2QivxZnw90X6r9k9FE=;
 b=Futwom5PXmn5ofiL21qxmleUyyh6uD77YRCl1QME5/z+VHIebDCXSMXGXoQKMVwuJ77CYechMLKPQwkQAZIRjSiob0pOI7PQhCaUW5/JswUuIFWwXnL4/Shw5lliJ/6q3OD90T0LeJxu548QNbn4CWjhsWq6Y9QEoWdUeQYI7gk=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH7PR04MB9593.namprd04.prod.outlook.com (2603:10b6:610:24e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 13 May
 2025 06:56:49 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%6]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 06:56:48 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>
CC: "djwong@kernel.org" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix zoned GC data corruption due to wrong bv_offset
Thread-Topic: [PATCH] xfs: fix zoned GC data corruption due to wrong bv_offset
Thread-Index: AQHbw0wykbjM78KB/USrkWiSF/CrK7PQIckA
Date: Tue, 13 May 2025 06:56:48 +0000
Message-ID: <320e7c5b-8d58-4e9b-b675-5587dc840f08@wdc.com>
References: <20250512144306.647922-1-hch@lst.de>
In-Reply-To: <20250512144306.647922-1-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH7PR04MB9593:EE_
x-ms-office365-filtering-correlation-id: a0734863-1fcc-4411-8bef-08dd91eb550c
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZEhHWU00WXBBMTh5blUxcEhRaWFhd1laZm4xeHBOZ3dpVFlkN0lyZTFUOGZU?=
 =?utf-8?B?Y0IzQ3hZeStOaVZDRmhCdXpqZGs2VFY1bFg5MC8xTlZXaUVnV2orWERTMU8z?=
 =?utf-8?B?V2VhT1U4Y1JjdXZWU3d6akRvTWVhQ2hHajBOQkp5clVWd3F1SDBZK2VCT09M?=
 =?utf-8?B?ZkF2dmc1RjQxWEl5eEpaV2cvSlErK2hKVWYrUlIzSG9EM1ZOMzNEYjlIOVBk?=
 =?utf-8?B?aE9FWHNaV2J1aXNxc1RvZytSaUpjSG1nMWVVOEttcHRyTE9OcmZVSEU1N0VH?=
 =?utf-8?B?dWNyNXR5UGlGSlp3Mm1LajNZclVHWkJwSWpoTnZKNzZXb3RnUlo0dEVJeXBW?=
 =?utf-8?B?NlI0azdXYzlSOWk4bG03MXdWM0RsY21oV0NBMkliZkRpVjZrQ2ZHMTFWT1R0?=
 =?utf-8?B?VCtUazV1Zzd4TjdPMEZQL3V1alRSZnV4S1dLbmVsM2RmRy8wTlVyTUp2dDEw?=
 =?utf-8?B?bTdFbCtibFBYbmJMOWtEZ28wZjRUS2h1clpqNWpOWXUyVEtqRG02cFlCN1pD?=
 =?utf-8?B?T2FkQ3d1WVg1bkxaUW83WGw2QUVYR0NSRkVtdWJrMGJwdDVLZ3dyRzM2VGxU?=
 =?utf-8?B?MUtkamp3eWNMZVYwZERRN1J1Ym5Bb0txanVjSFprcURrM3hjSWhveWxoM1VL?=
 =?utf-8?B?QXpXdnlqN2poVXZ2M09TMndiWXFsOTVzN0RQTFFwQ0U5NjJPSVRMWU1MczBq?=
 =?utf-8?B?ZmxCZElQQW4zOEV3UjJ3dG81S3MrTGNIU0Q4ajcvVWpLNEdvYzNtZ3o5Q0p6?=
 =?utf-8?B?SEQ1bUVqZkNrdlloSTUzN2ZaYmhLWUdzeDNQZ3htMUJueU9QSE1zSzFSNEt4?=
 =?utf-8?B?L0YrSmNSVVpZZ0x2eFdsQlVkY1ZmQisrTkFXK3U2bkFOQ0NMenFGM3VSZ2Iz?=
 =?utf-8?B?akM4MWtlaWsySU0wTEZ2V0Zha20vLzFZQkw2NC93aW9naVlhZXlFcXlUdEZv?=
 =?utf-8?B?dEF1OE1OcjNBWkxKTFJqRWh4SlZ5TTdJc1lhQmpMN2YvaTJIL0s0TExmSWJP?=
 =?utf-8?B?RDJ1TzVwWjJ1THVJWkhKMlZNZm8vazV1a2xSenFwbkVLZ0J5eGVBQXk4YTMw?=
 =?utf-8?B?eFJ5WWl5RG5YRHdYdExtdlFSNEkwTU94RmloYWZkMWh2QXNqTVBrUDZ2MmdR?=
 =?utf-8?B?b1NzWnR2aS9MeEZaSzJzVGU2YlE1LzRwOXNESUlUN2RmN0lXUWdqNFBFVWtF?=
 =?utf-8?B?OW5XNmVOUStwbXZLakJDUGxZRlNNZWFEUmlFcjc0QTFIY2pzMElQdHkwdFF5?=
 =?utf-8?B?UzFUaDMxN3BVMWZubm9WZzYzTVdTZGNHcG1iNGc4MEExdDZjVmNkcFdhSi9l?=
 =?utf-8?B?dlUvM0xOL0x5enNkVjd0SGdCaEJFcnRjWjdGK1FIRXRMUzl5czV4ckxDWlMr?=
 =?utf-8?B?MThCOXFtNzAvL0hVaHMwZ1AxOFRwMjNyNjNiOVZsSUFSMHY4a1llVjd3djVZ?=
 =?utf-8?B?WkxHQjJoTldKQ2I3dGRHemQxamU1NUdmc0lsQ0hnUytiRzhxdkRaTnNKNU00?=
 =?utf-8?B?U1NJSWZjMnRIOHJFOGtoYWRFaHNPanBpSjlGc1Zzc0FWbHhRNitCbzRDbmJ4?=
 =?utf-8?B?aVR4RWgycmloajRSVnFjNTVKL29xUUhndDlOd2IySUNPK3dSdHp5ckRLR3Zh?=
 =?utf-8?B?T2tCeVVmV21sc1ZPdDRwUjNycXp0OWxrbXhqUG9lK0JVRmd3UFl2U0RLUUJy?=
 =?utf-8?B?WE5mS2tqK0lmVHBqcDQ4ZjFZN2xIaC9EOHR1MnorNjg4dms0bFBweWJCWnl3?=
 =?utf-8?B?VWFqNlN3YTVnc1FjK282cXRZWHdDcFlXZE90aTZaSnFkQmMrcE1sS1JnbHBQ?=
 =?utf-8?B?VVVHWGlGR2ZZM042N0twQ0JTSFdUamN1a1VDa20zMXNGcUFRYUQyT1hBNHVI?=
 =?utf-8?B?dld5b05SRVZROG4veHB4TkU3NHZVV2wyMEsyT0swTC9zVUV3M3RqUHZZMGhy?=
 =?utf-8?B?VnFNTFFqTWtMaDZxZ2h6WHd0bmwyMXJrdWdZSDdLMXdsQWJnbS9BcUdHZHRJ?=
 =?utf-8?Q?PvMLbQPYMCf2jfxVB2gRjRNBVo7tPw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SGNjaHRzcHh5Q3BaOGhURC9tVnZTT0R4MlZUcHdLT0hxT3N1eTBMVXY4OENY?=
 =?utf-8?B?dG12NndZd1YwT1VuV0pVRnpwUEkwdDl0WHBRVmc4VitpYVZQSVhxL3RvQzJ2?=
 =?utf-8?B?ZHlnTlgvdUx1Wm82RmU2S241ZzM2bFRIQSsvZHVTVmVmWFFSOTBHMExkRlZy?=
 =?utf-8?B?K21BdUZrRlhkdjlHMjRuMHA5ZE5QZzllQVhBWlRpODAycDNQbE81NUo3Q3gv?=
 =?utf-8?B?T1Mza21tSkVKeFZySmFIUm93cytEaDAyMDRoWUFOK3pENnVNU25JdDdYSGlr?=
 =?utf-8?B?aUh2Y3NUWTJFVzNiYjRNN3RtY2kzcFlLMVZlRnJ5TUZxKzk5VUd5NGZsNWpq?=
 =?utf-8?B?N28zc0xOZkdzQXpTSTduZVM5eDJsSW00eGJ2SlFsczJVdG1ubE5DaHJpSjBv?=
 =?utf-8?B?eHp3dFpjQ2lHYnNjK1htY3ZJMVZCQjVXS3NkSGJlSktWNlMzUTlpRVB1RDZ3?=
 =?utf-8?B?Q2JZc1FmWEdrTWZ2T0YwZXppMGJLQ2Irdm85cFJxdnA5ck1yYU1Gb2hnVUlF?=
 =?utf-8?B?c2MrMHVJeVNmRVZuN2h4d0FsdTlSelhpZGwzK3N3S1RUK3dCV0YrMzI2UzFH?=
 =?utf-8?B?bnphOUNtVWdMUXAwcXhYNTF4TytCcSthdXRZeWpNQk1aTHRmTkYyOUdlK0hK?=
 =?utf-8?B?cm03eWpNWmxCUDRHWDQ5K1hPUi9saE01cnpORlhkUm1MSHJQaFJ5cWxibzRP?=
 =?utf-8?B?MitvendrOGYzSXJ4ZzQvS3lxRVFxdDA3S3k4ZkhGQk1DTmdWbk4walhGZGJB?=
 =?utf-8?B?d1N3VHROWEZHbXBGNE5ITC8vS3hqdnJ5Sm1pQWppTXRXRk9FVlVXamdHVk80?=
 =?utf-8?B?VXAxVmFxMXlxU1J3ZW53dWd1TDczWDdFZEhwbHh3aldwYjdXMUo1SDZKR3g0?=
 =?utf-8?B?MERpTHpySzNxM2xsM08zOHZHYVZuemFyZVh2eU9veUNoT3c5Nkw3OGJyMk5t?=
 =?utf-8?B?UlhZSHlOZVJNV045UHVWQ0FRcjlHVndVTHZHWnBJVXBHK3hMMTFPeVMvQzlp?=
 =?utf-8?B?TzZ4SUdXeDcxQVFHbGpGcUdEay9zVTB6V0FUYkd2aG1RVVRRamJIaHhkdWpk?=
 =?utf-8?B?SC93WVJRdE16M0xNYVdXdzlFQ29TeStWT3plQW5vNkpNa014M3VmeUFtTi9R?=
 =?utf-8?B?bmhZLzJJajgrWklJK2dxUjlMeldySk8zcW9yZzRmaVByYXh1cjRxanhiNmxV?=
 =?utf-8?B?RGFIZ00zc1U3N1lYSWJJK3JVMVJWM1JoaENnZ1NnWE5XY2lKT0s4K2JlTHVX?=
 =?utf-8?B?QUYrMVFJVTFGZWRMaWRoSExzUWQ3eDNQQktxVFV1djZRUEZtb1FJYWtJM2NT?=
 =?utf-8?B?djJ1Q1RmZzIreWZ6cElEbDUyMVhLTGxKMkVEWXl2bTdObjhDbW4vQWRVMkNv?=
 =?utf-8?B?Y3kzLzJCUTlTcDlaMENUdFhzaG4wMVViVjMvTFJ6V1h0ZDFVcVNQc2MrNWxI?=
 =?utf-8?B?dHVmZDMvYXNLN1pNNzNtTGdZZ2V4ZzRwSGlsRDZKamJxL1o0UVJ6Y2VMVGto?=
 =?utf-8?B?WVdiajBtRVFLcDVWUWVzWmx4MnlHQndSd2JZTDZFVUtXdDZLZ2xlWWZ5SjNM?=
 =?utf-8?B?QzF6akxDSmh5bi8zWEpYMzA4SEp1c3BjQm9lTmxqT3AwRTFHMXJEVzNzYlB1?=
 =?utf-8?B?Mzh0ZTRlSDBDZW02Y25zaDQwU2IwV3dGSDRWbldDMDQvcmp2TXJ3bHFOZks4?=
 =?utf-8?B?N1V3SWhtMVRrdDJGOGU1em1MSng4YVhNa3d5NFlMRllUb3NTL1NsMVJyZEI4?=
 =?utf-8?B?eG4wWjViQzJQRXdLSk1MUW9PSWFuQyt3V3k5d2syVTlHTFBoUjkxYzJUOHJD?=
 =?utf-8?B?akgzd2lUR2RxUEIzV2RLdnQ2dUZUb000ZUkwNGdJZWY4N0djWFc0aXZyUERL?=
 =?utf-8?B?aytpdUxtYUdPaWMwM1hKbFI3c1A3YUZBMTcvRmx0UmJvWW16ck4rVDN1UUpW?=
 =?utf-8?B?VkRLc0x0YTgwRkxjdzFramdMUEluVUFvajZBclYxaVV2SmxMM2p2UDRpaERp?=
 =?utf-8?B?N0NyNEpNRHRIUXNLQ3BXSzZ2U0VzbHZYOURjU2FUYTYvaDVFYThuTHJzQTRw?=
 =?utf-8?B?amtHKzduY0VKS3d2aEV1ZklSR1pOVXpReUZ4azFJZ3ovQkhuemRxZ0xBZWZR?=
 =?utf-8?B?OTd2RytXUWorR0hXampxWFFHbGZ6UGdOdnFac3UycElzV0t2bGNkbkhPaHVG?=
 =?utf-8?B?N1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C7E95E8B12DF34C842A8B69902C8BBA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3VaEhJJReUpnR+y7knsup0N27e9tJQvjYNmNn4ZPzu1JlZJJHmb2DtAcRohc73d0FrwHEOEZe6gnTOA9s3d3Nbq/QzKH7YSGmMr12uKblS9RB6ogFWxODhHt+/25dk8gTnfT8SnEoKaFeAOekwCXsbZ2ufkwcMjV8nO6ozH+JSwtAeCb7oQXLWaWqPKcsqNYj/NHWpQo4yIN+OcgHzN6TLErc7iazeJjoVlFzGVBmrxgGoyzDxYLIH2KrvmvbKBFsq0sM0Aa0YPVgjSdyFoIvbBj77hqw/tLp2t0ycDfSM3K2mckwfQtDk/ZGW8MXNmMsG8R7hESAAo2DNNw13ODy81JXte+QLXEpoUUZ1fRUGQZOtEWjcOXyj6obBon7BjoOJ0PcedmayzzYZ43vCQxmNAWpvwpb0OzkSV+y3Qz5jygaB/e+IGSmdIGGtM+G73RfZslk5sGIbA3+EkkEfVZBJRbnrunmXFoduUDPzUEz8ccM8EuHLYxZ2GfS1RY0baS1IE/xaobGBnHq0KXqIvLfIAsN7g4riEn69+fXkgraeExmiIIt9IRjHZsmW9VaRBNz/pDj+jr+9UjTLxyBaJYLpDest3Uew5uDyvistdthRESCNISbsuy0QyjLYgeHSsU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0734863-1fcc-4411-8bef-08dd91eb550c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 06:56:48.6570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E9NkkW3sajDuoCFLe1jUnTKlya+oFdLLhFOSaOG2Blq8/stkd0BgR3tjOL6VxfmoBofgBRHobA0ZEy3qFuSNTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH7PR04MB9593

T24gMTIvMDUvMjAyNSAxNjo0MywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IHhmc196b25l
X2djX3dyaXRlX2NodW5rIHdyaXRlcyBvdXQgdGhlIGRhdGEgYnVmZmVyIHJlYWQgaW4gZWFybGll
ciB1c2luZw0KPiB0aGUgc2FtZSBiaW8sIGFuZCBjdXJyZW5seSBsb29rcyBhdCBidl9vZmZzZXQg
Zm9yIHRoZSBvZmZzZXQgaW50byB0aGUNCj4gc2NyYXRjaCBmb2xpbyBmb3IgdGhhdC4gIEJ1dCBj
b21taXQgMjYwNjRkM2UyYjRkICgiYmxvY2s6IGZpeCBhZGRpbmcNCj4gZm9saW8gdG8gYmlvIikg
Y2hhbmdlZCBob3cgYnZfcGFnZSBhbmQgYnZfb2Zmc2V0IGFyZSBjYWxjdWxhdGVkIGZvcg0KPiBh
ZGRpbmcgbGFyZ2VyIGZvbGlvcywgYnJlYWtpbmcgdGhpcyBmcmFnaWxlIGxvZ2ljLg0KPiANCj4g
U3dpdGNoIHRvIGV4dHJhY3RpbmcgdGhlIGZ1bGwgcGh5c2ljYWwgYWRkcmVzcyBmcm9tIHRoZSBv
bGQgYmlvX3ZlYywNCj4gYW5kIGNhbGN1bGF0ZSB0aGUgb2Zmc2V0IGludG8gdGhlIGZvbGlvIGZy
b20gdGhhdCBpbnN0ZWFkLg0KPiANCj4gVGhpcyBmaXhlcyBkYXRhIGNvcnJ1cHRpb24gZHVyaW5n
IGdhcmJhZ2UgY29sbGVjdGlvbiB3aXRoIGhlYXZ5IHJvY2tkc2INCj4gd29ya2xvYWRzLiAgVGhh
bmtzIHRvIEhhbnMgZm9yIHRyYWNraW5nIGRvd24gdGhlIGN1bHByaXQgY29tbWl0IGR1cmluZw0K
PiBsb25nIGJpc2VjdGlvbiBzZXNzaW9ucy4NCj4gDQo+IEZpeGVzOiAyNjA2NGQzZTJiNGQgKCJi
bG9jazogZml4IGFkZGluZyBmb2xpbyB0byBiaW8iKQ0KPiBGaXhlczogMDgwZDAxYzQxZDQ0ICgi
eGZzOiBpbXBsZW1lbnQgem9uZWQgZ2FyYmFnZSBjb2xsZWN0aW9uIikNCj4gUmVwb3J0ZWQtYnk6
IEhhbnMgSG9sbWJlcmcgPEhhbnMuSG9sbWJlcmdAd2RjLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
Q2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KPiAgZnMveGZzL3hmc196b25l
X2djLmMgfCA1ICsrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfem9uZV9nYy5jIGIvZnMv
eGZzL3hmc196b25lX2djLmMNCj4gaW5kZXggOGM1NDFjYTcxODcyLi5hMDQ1YjFkZWRkNjggMTAw
NjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+ICsrKyBiL2ZzL3hmcy94ZnNfem9u
ZV9nYy5jDQo+IEBAIC04MDEsNyArODAxLDggQEAgeGZzX3pvbmVfZ2Nfd3JpdGVfY2h1bmsoDQo+
ICB7DQo+ICAJc3RydWN0IHhmc196b25lX2djX2RhdGEJKmRhdGEgPSBjaHVuay0+ZGF0YTsNCj4g
IAlzdHJ1Y3QgeGZzX21vdW50CSptcCA9IGNodW5rLT5pcC0+aV9tb3VudDsNCj4gLQl1bnNpZ25l
ZCBpbnQJCWZvbGlvX29mZnNldCA9IGNodW5rLT5iaW8uYmlfaW9fdmVjLT5idl9vZmZzZXQ7DQo+
ICsJcGh5c19hZGRyX3QJCWJ2ZWNfcGFkZHIgPQ0KPiArCQlidmVjX3BoeXMoYmlvX2ZpcnN0X2J2
ZWNfYWxsKCZjaHVuay0+YmlvKSk7DQo+ICAJc3RydWN0IHhmc19nY19iaW8JKnNwbGl0X2NodW5r
Ow0KPiAgDQo+ICAJaWYgKGNodW5rLT5iaW8uYmlfc3RhdHVzKQ0KPiBAQCAtODE2LDcgKzgxNyw3
IEBAIHhmc196b25lX2djX3dyaXRlX2NodW5rKA0KPiAgDQo+ICAJYmlvX3Jlc2V0KCZjaHVuay0+
YmlvLCBtcC0+bV9ydGRldl90YXJncC0+YnRfYmRldiwgUkVRX09QX1dSSVRFKTsNCj4gIAliaW9f
YWRkX2ZvbGlvX25vZmFpbCgmY2h1bmstPmJpbywgY2h1bmstPnNjcmF0Y2gtPmZvbGlvLCBjaHVu
ay0+bGVuLA0KPiAtCQkJZm9saW9fb2Zmc2V0KTsNCj4gKwkJCW9mZnNldF9pbl9mb2xpbyhjaHVu
ay0+c2NyYXRjaC0+Zm9saW8sIGJ2ZWNfcGFkZHIpKTsNCj4gIA0KPiAgCXdoaWxlICgoc3BsaXRf
Y2h1bmsgPSB4ZnNfem9uZV9nY19zcGxpdF93cml0ZShkYXRhLCBjaHVuaykpKQ0KPiAgCQl4ZnNf
em9uZV9nY19zdWJtaXRfd3JpdGUoZGF0YSwgc3BsaXRfY2h1bmspOw0KDQpMb29rcyBnb29kIGFu
ZCBmaXhlcyB0aGUgZ2MgZGF0YSBjb3JydXB0aW9uIGlzc3VlLCB0aGFua3MhDQoNClJldmlld2Vk
LWJ5OiBIYW5zIEhvbG1iZXJnIDxIYW5zLkhvbG1iZXJnQHdkYy5jb20+DQpUZXN0ZWQtYnk6IEhh
bnMgSG9sbWJlcmcgPEhhbnMuSG9sbWJlcmdAd2RjLmNvbT4NCg0KDQoNCg0K
