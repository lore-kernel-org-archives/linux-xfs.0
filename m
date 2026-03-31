Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C4F27F754
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 08:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774944467; cv=fail; b=kmw/BLCUpzH/iCzZHTST/JAZiGqWlsO1n4m8A0oTP8s4M5XQhyWEdCVFbMBaJ7/yVM4sW6gfSblj92lD0ZutY96k+9a5I5GutIZn/IVQ5cIQ+YXSr0oXjcabzjiMW/pX9y8+kIccMB55ILOvvHyJX2WrkHfKkjYiKkrBAnaJ1d4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774944467; c=relaxed/simple;
	bh=kjkTwB/oZTFdM5COyq1RtDMosEI4ujiSPcfz8rBemPc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qiYXFhxd4vNrLU1uci6pLgvsHF9gtf90Sc/gCapfDc/D77tE0lPIh4eeUOexyWoqO7lwz8I1aGNKuw3Ab9HlGId8f0i0nFsaNMUCq3hfCfZvFKHHU3KpWM2IzhgtEKktGsS+lXbaw5EP1Oj3NVbkMMqVqHrxtl1298QrSecm4tc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qpSMphA1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=yp4ushjz; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qpSMphA1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yp4ushjz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774944464; x=1806480464;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kjkTwB/oZTFdM5COyq1RtDMosEI4ujiSPcfz8rBemPc=;
  b=qpSMphA1Tl2DUQqzV/Ciqou+PQt839OfqaLgKxy3fO69bRNCevmNCT1q
   vRXQi5BPeeAXPa0k6JdaDxwK2o+ne1ynFTW8CFemW0HfVBWIxxQChRof+
   gNReKavSqKnvBsmKsKMkfXLBoiFmLoJTZFYDODYBIPE4HeO11ZbQvZtz+
   KQoPrFd5xBCZySMDBIXvMCCZg9SVVYW/PSVd2pk0+XuV3T4Hi1Lp15SRn
   ZNqeMWs6p6wQdzqWlAMVhRIYMnDEtB0AK2lmV7x5ItFJT+D2PEWMkkn0M
   ulSNRyagvHWapzJX3roPPAaJwkeyjZcyEpiKH0OI8BWwRPt9OlD0mM5ov
   Q==;
X-CSE-ConnectionGUID: /Ly7flg3RwmHv+UB1auK0A==
X-CSE-MsgGUID: L3gCkPd9TlazGeI1B0BUAQ==
X-IronPort-AV: E=Sophos;i="6.23,151,1770566400"; 
   d="scan'208";a="144724488"
Received: from mail-westus2azon11010040.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.40])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Mar 2026 16:07:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gQcYhlb53MWi4Hn7Oo3NhR3X6RDKglcZVyI18TenHDdRVP9kyWDNY7HYoce6s0k9l3WriML+4S4YOLbEozBn6pol03i4c4qJe8xS8RKDeBYMUBXoYZucAbT6uUnu5l+BbSZ1rfAmBwmpgEwXfYdfQvrzixlVMcgfCsbFcjFsM/ojf8wsAKfeNjdWAC7/yxEucTlS3WjwhGzf20Uh5CDOSLAqczMUlqXh5YbajbaCz6Ue6Gpy9K/+MFYZdLLBxTmSBAryPukb2z1cmEZHqr2U5lNZiD9BsM3Yv2N2WekVjZZKoUG5D4nBa5TQS01lLFJf1KGSOYrljcKZGs2agMGLdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjkTwB/oZTFdM5COyq1RtDMosEI4ujiSPcfz8rBemPc=;
 b=PSiUvtadQREpByHMBwPVq9MAQoqfbxk/Gl4LYp1WCvTGb/PNUc8r2Egpd6A6pnl723leIB4X7aL9Kd1l45/PtCgeqscwusvWFag95UaCWvbDMMgKsorov8HLEpBOZCXeoUtbw9fQDEI4So5T3eJH972oHwG3oh39rYYfWpXB4rfYWQMbFr8cUn6Y26JmIlQ8yWkBajN+iWpnPVuaq1vQWWK7LZQ8Xni/jVHIfp5muE5vtk3OEUcva6eyZl8oS8lCdgkhXV0NV9461S7RSWoFO8gSVHRoTO4qs4i95IpYZX6Q72vUjZZCpZ2QUmb/AHx3rFeV1Fxu11wb3SQ1x+ZO9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjkTwB/oZTFdM5COyq1RtDMosEI4ujiSPcfz8rBemPc=;
 b=yp4ushjz+UMMpk0tJzDvUPEE2uRJ9F53fEG/bVVPTxjeFCwJyP2PZfDtMB2LTFoFoMO5GxFay8Xc7vIrihM3WBEd13bu2Ntu3jomsknR5xAepoaYs9kxoLB+F6yM3auBPP5Kjmpc6SvhI4OxK+/9l8rRz12cJoeZelA6p75diVE=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DM6PR04MB7129.namprd04.prod.outlook.com (2603:10b6:5:24b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 08:07:40 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 08:07:40 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5/7] xfs: refactor GC zone selection helpers
Thread-Topic: [PATCH 5/7] xfs: refactor GC zone selection helpers
Thread-Index: AQHcwAiGAhkDA8cz7keBZsGpGjwxJbXIStCA
Date: Tue, 31 Mar 2026 08:07:39 +0000
Message-ID: <c2f64bc4-190c-4d49-9ff9-93af4a72b9b0@wdc.com>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-6-hch@lst.de>
In-Reply-To: <20260330054533.3856339-6-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DM6PR04MB7129:EE_
x-ms-office365-filtering-correlation-id: 0e6bc544-d2a5-44cf-6d4e-08de8efc9405
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 OJE783inubxjEyKiTstbTV4baGWTeR+qhg2FDNt4mjTjtMiLiSyr0A7dr8ngi+qRRHr2UAOoorbo+dc/bg/OIJI6piKBU79HGGURHxajmmvMMs5GbKbKitn+d6nqyYYIVz/ff3cdq04/3gDvJ8fDc2qC2JrSWw4HCKUTjXnhZH9JfWwBh/M/jYeXQhF85ziOohQbOV+eJwhpG8+OtWBvPydMGXJoM3u9MiFN1Z1/gNMr4sO8DNHD01fjO+jZzMdgh6LalD9hhjB+869yEyL/OzRJpoew1HVScA92StLcXo2s9opUJS1pCTRcUPUNhfNZhqV05IS1PbbhscwYAzQzJaG9vC4CPm6hQHpWUJviHfMIgtORV42+cO4e0nKFmasRFptKYcBRwQD9o7m+uMtQZhixiST6ATffrSHzqscxuckJvhUxLU1lKZ3r2Dli04rSD5zoAtPMyP2IHEfk8Dj+pv1x9cs6IOybdEyrSQ15fa1qrgoNgsNN5+gLnqa3G02T8WjG303EWD+GNf21tjnoOUsaCW9Od/vt89/IOqqvSVzedgLXMyppwhMY82efXVjv1t5a58mrH0+BTn0oPiVkNoZa+vinv17p1+olBjznzU0D51WfNFNzfGLdVkqMB25IoEnaxsO0NTbpVNGjLu8EtBvRp86lVF6EIjFF2hJ4mQC54w43IggVnSxy0O8TO0UHhzRRCA4PFAuDHjvRvS7DXhKIMtYxn01j6JeX9N3N2d58qJHQw+hn3+bdQpD87ucrMMjEHAp8z68x+4nspYgK+MGX5lcXyIU5xL3gBx44+JI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d3d0QkFyZmtmbGwyaTc5U05OMWJ1bEdiWkFCc0hKWXh2b2ZYWWxoRVhONXdx?=
 =?utf-8?B?ZFRVWngwWTZJdndLSWNHbCtCRjV5RVYzQkhyUG5LbDhVWEQ2eW9SdkFkUlRp?=
 =?utf-8?B?U2IzYmI1SXY3QXFsakYxTmxmTHRtT1hEazFNSngzTytZTlhCei9NczZzZlN2?=
 =?utf-8?B?QS8yYytMZ3djK1dGdSs5STB6QmhxbEU0MVNyYjZqd3h0bC81bS9aOHQ2ZW9O?=
 =?utf-8?B?NTlOa1JlSmtKclhIcm1IWU9xRlM2bzY3SVJJWFoyVUpRTmpCWS9ES1FmVzZO?=
 =?utf-8?B?NFIyS016bjU1NDFEWVllRTJ0ZDh5VEV6UWdoWU41UlB0ek9MWmRnQ1BsZFVK?=
 =?utf-8?B?eHU2QWVCTkpOREVaLzRsR1RDOFRCNGsrQ2lZakptUWI1cFpseURDTW90bDIy?=
 =?utf-8?B?QmsrdVRhZlpBSnJxN3V3QWJyQnVBZTlOL2RPL0tiWHp4Z0JNdHhpcVNxZmZu?=
 =?utf-8?B?MkVpQlppdDczMGRuQSs3aXdKbkRkVWIzQnZFVmhDaUZkN0xlQ1hVN2FkWUho?=
 =?utf-8?B?OGd1aTlKL1Y4V1h3WkVzZUxRTE9mL1lRT0wyTUlSdG54TkM2YmpxZlJpK1pN?=
 =?utf-8?B?M1U1ZUJmSC8ycTRKTW41cEE2RjVXcWozcndnL3RmY2MxOFJzcDlrdFlTMkQx?=
 =?utf-8?B?UWMyZzFnU1F6NS9KRUdINmNnWFlLbFFqdm9nZkgrVjh2ZERoZjdxQkF4OVhu?=
 =?utf-8?B?VVZMSjBzcDkwcXVyY0RmbW5kazNPMTNQL2JDS1VHd0RPSE96OHdCZkE4N0Mv?=
 =?utf-8?B?aXVHaUV3NnVUSEY1bE5vMlFSYTl6NEEyM0F2dFVnc2ZRM2dGeGpMUU54bS8z?=
 =?utf-8?B?eGJwNWh6d0VrZldjaCtySGJzbkZJR2xjSTlxREpqb2l4MXU5MnlSWXdKZ2lV?=
 =?utf-8?B?cWpmY1VtQ1oycksyaTdCUHJVd29Hc3QwZi9GcU9Yamd1Vkgza3VYL3JuVlZG?=
 =?utf-8?B?YlA5V1Z1R1hob0h4RHdqa0lhU0pxcTFsWDdHdnBQcTNpQndNSjJsM2V2VXEw?=
 =?utf-8?B?SlhYOUNlZkRDeXVJY2ZKMTIzVlpQN0ZoQzZXRWc1MDliMFVuWXFqNFVaTVRE?=
 =?utf-8?B?WExrRmhNL3ZWQkhQaThyWHowa1M5MjhzMElJTHpjWjJaK0hhMExyakx6bkh4?=
 =?utf-8?B?bHpORGVwTzk0TEpjY0xjeSt5TUxMSldyVFIzL1RRcGNWRnhrZVhUZklXcjRO?=
 =?utf-8?B?T1NQbzhZY053b08zeFd3YUxaOENyazUvelAwRks3RlVPeVB0VkFRQ0N2aURs?=
 =?utf-8?B?bGJHQUdHTzJqOFRSZHV2N2RIaFBUN0k2cTJoNzFzUHI3Vm05WmFXUWZkSHRo?=
 =?utf-8?B?dVQ3NlVZVk16Sm9mNlhrMW9Ja1o1Rk1aMHRHenJGOFlnVzVKdlhjd1hyaVpQ?=
 =?utf-8?B?QWcxVnFKaURCYjBOWDFxYVJGQU5aekJQTFg0bGFBMzE0TVdsUmdCMXpsOXJ2?=
 =?utf-8?B?bkZSTWI0dEg4VC9RVUU4YW9iUHkwcTM3TjUwMWl0dFZuNkJyM1RlM0VzQm9I?=
 =?utf-8?B?ZEM1eGVnWHFWUjlmRnM4aUJXSkw0SklRZE1PTlVYV1ltcCsrR3lyTHhmWFNa?=
 =?utf-8?B?bVJPempKWm1ydmJZc25MVkJRczlIbzRwOUk3YWVvbjM1Y1VGMjZKcFV6Mnd2?=
 =?utf-8?B?K2o1Y3psMFRDUlV1MGZERWIrMW83RHp6d0NxeVJaRVJxajlDQ0RlRGdBTC9H?=
 =?utf-8?B?aHR1LzFQS05JVlRGcXdSWFJGN0pVWUxjOFRLSllXNEdKeU05ZUo2S2NqTlZ2?=
 =?utf-8?B?ZVo1M0RUOS9WcXE3ZWJmNDh2OFJHN2ZKYzExa0loN05MVzNtSFl5M2NDUjYx?=
 =?utf-8?B?RzdsV1VCYTJhYVBCMWdIbFBRNUk4MXFLNVRIeUNheG9LVW9vT2FBMXhyUUgw?=
 =?utf-8?B?d044U1JnUnJjSFZ2a0ZVU0NYKzRnRHE4Q1J5TVpZaFYyM2ZGMTlyVkhydnRs?=
 =?utf-8?B?NUk2QkRuc0NOVjJqTGhzeUJaTndEaFZuVVlCd0o4K0RnbU9lZDZsMDhsQnZu?=
 =?utf-8?B?TjZ1VlB0WlRJSGFFYzM3N292cEMwSlFXWVV0UWdRSkx5WFVnMTNYTW5EQmNO?=
 =?utf-8?B?d3JuK1BCZ2hiL3hwWEp1SVVwUnBpKzFVaTNyZUxMZm1oVlIxWi9sMFJIdCsx?=
 =?utf-8?B?T0NqNVFRMVZLZ09ObXpvRlhYdTY0bU0vd0hXT21aa0YzT012dWtsb0NYWm5M?=
 =?utf-8?B?M2xMbnltYno3SmNCeEtFQkhCMDlKeFNOMzVwc0x6Z3ltNUNtTXVKOVhPZ1lp?=
 =?utf-8?B?L3VVSDl0OVdnZVFCQ0E0c2p4bUFVVlFzOWRmOVJ6SDE2UVY3aTM4SjZvY0Jm?=
 =?utf-8?B?YlNxaGRIaVNuamVGNTlOL0l0ODFCWWdTcHdGK0Q4Zlcya3F0UVZsdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88C98FF60AA9884EA689349B8D625ACF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	R1fGWzGlReN+kuBZ9cJ/m+yVcD5zUHdM3HIRyPLD8Kx42m9mgYYNEZPlLtCTa81PxVImd4WypivcneAbUbuZeCLbotxtN1a/EAK+htRiNwNYT8TRn04XQyjPNpkm/HUb57UOGU9gMhFJAzK8cIv3Gd5JHj6OieHGOgRmPDxwWiLvZgbEJVw/Jqi9nHyFpJR2HEVScDZf/M42WR37/qChzlTqEsPmvahSkcVVxwRYIJ+1AmNyxZnsnjQaBz5o/BVRmUW7mSZoqIc1XDUFisvqAT8BoM3c0SQ338wxG2gJoLwaIBjmYQQJVMErfMvjSzNqQww5EGLq1DfI9TTXKKfcOQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Wf5P8mRAqZSF8HtBEVjO5vAqTrj+OzjukL3S0vte0vFMu/X/wWY1J3R4ZU2ugh7b3sT7tSz4vNxRw4ybf/iXPfASyDTouYnjC5lcNbEUQFouu2261wHY5FC1lGMxgDZnwidSSV2TEO6iBz263f2umFnxlDjhsththUEDrVa5B5WaH1WobbgGhBSmGELKPFjjkfoJU/HJO82SrhqyWBemn0EN7SzIzACo3p5IibcSpOyYNESyekgjTvevE58ru2XUu7mc75bLzxnbSq1v1D19pUljfY4pHH0PJkYAFeweTX5aYuZhGCq3T24lKjlSZewk12Ohvj4+SIb0cPvyk3s0sBOnt0qm+ukN6238fi5kIGETMjk7YLmtEOWyqzEyYYi+6T39l+TVmo3OMmbRY784g9ihZbt2v9BX+eTgRFknQQWOLyc7HUyyCY6GcSk+wT9DkOzFZGVo8FCSgCAJ+KLOy+cq9JLZFh2i/Qf7i6DM4d/4MVhNTzgH9nb8zgw14IO8nVLvHDSfNyYs25WteSSErHbGCWbdIDL3rp1qHnsS5+nc4+fGfEEhA+sSQESbr1bwUYzlUUodbbpHCepbRf8pHsxKvLynt0bIwC+q3/t94smbOQPA/RiPaxPvXuLoP78A
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6bc544-d2a5-44cf-6d4e-08de8efc9405
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 08:07:39.9429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SPb7pl/Xuf6/4esbKZlQ3cpsbu4fJXlIRA6aNWnaoDFzV01DI6EMME2qrcltfowvdWgwVxns6w55Vtameeqe7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7129

T24gMzAvMDMvMjAyNiAwNzo0NiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IE1lcmdlIHhm
c196b25lX2djX2Vuc3VyZV90YXJnZXQgaW50byB4ZnNfem9uZV9nY19zZWxlY3RfdGFyZ2V0DQo+
IHRvIGtlZXAgYWxsIHpvbmUgc2VsZWN0aW9uIGNvZGUgdG9nZXRoZXIuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBmcy94ZnMv
eGZzX3pvbmVfZ2MuYyB8IDQ1ICsrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0t
LS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc196b25lX2djLmMgYi9mcy94ZnMveGZz
X3pvbmVfZ2MuYw0KPiBpbmRleCAzNzIzZjUyOTNhNjQuLjZjZTVhMDcwOGE5YiAxMDA2NDQNCj4g
LS0tIGEvZnMveGZzL3hmc196b25lX2djLmMNCj4gKysrIGIvZnMveGZzL3hmc196b25lX2djLmMN
Cj4gQEAgLTU1Miw2ICs1NTIsOSBAQCB4ZnNfem9uZV9nY19zdGVhbF9vcGVuKA0KPiAgCXJldHVy
biAwOw0KPiAgfQ0KPiAgDQo+ICsvKg0KPiArICogRW5zdXJlIHdlIGhhdmUgYSB2YWxpZCBvcGVu
IHpvbmUgdG8gd3JpdGUgdG8uDQo+ICsgKi8NCj4gIHN0YXRpYyBzdHJ1Y3QgeGZzX29wZW5fem9u
ZSAqDQo+ICB4ZnNfem9uZV9nY19zZWxlY3RfdGFyZ2V0KA0KPiAgCXN0cnVjdCB4ZnNfbW91bnQJ
Km1wKQ0KPiBAQCAtNTU5LDEyICs1NjIsMjUgQEAgeGZzX3pvbmVfZ2Nfc2VsZWN0X3RhcmdldCgN
Cj4gIAlzdHJ1Y3QgeGZzX3pvbmVfaW5mbwkqemkgPSBtcC0+bV96b25lX2luZm87DQo+ICAJc3Ry
dWN0IHhmc19vcGVuX3pvbmUJKm96ID0gemktPnppX29wZW5fZ2Nfem9uZTsNCj4gIA0KPiArCWlm
IChveikgew0KPiArCQkvKg0KPiArCQkgKiBJZiB3ZSBoYXZlIHNwYWNlIGF2YWlsYWJsZSwganVz
dCBrZWVwIHVzaW5nIHRoZSBleGlzdGluZw0KPiArCQkgKiB6b25lLg0KPiArCQkgKi8NCj4gKwkJ
aWYgKG96LT5vel9hbGxvY2F0ZWQgPCBydGdfYmxvY2tzKG96LT5vel9ydGcpKQ0KPiArCQkJcmV0
dXJuIG96Ow0KPiArDQo+ICsJCS8qDQo+ICsJCSAqIFdhaXQgZm9yIGFsbCB3cml0ZXMgdG8gdGhl
IGN1cnJlbnQgem9uZSB0byBmaW5pc2ggYmVmb3JlDQo+ICsJCSAqIHBpY2tpbmcgYSBuZXcgb25l
Lg0KPiArCQkgKi8NCj4gKwkJaWYgKG96LT5vel93cml0dGVuIDwgcnRnX2Jsb2Nrcyhvei0+b3pf
cnRnKSkNCj4gKwkJCXJldHVybiBOVUxMOw0KPiArCX0NCj4gKw0KPiAgCS8qDQo+IC0JICogV2Ug
bmVlZCB0byB3YWl0IGZvciBwZW5kaW5nIHdyaXRlcyB0byBmaW5pc2guDQo+ICsJICogT3BlbiBh
IG5ldyB6b25lIHdoZW4gdGhlcmUgaXMgbm9uZSBjdXJyZW50bHkgaW4gdXNlLg0KPiAgCSAqLw0K
PiAtCWlmIChveiAmJiBvei0+b3pfd3JpdHRlbiA8IHJ0Z19ibG9ja3Mob3otPm96X3J0ZykpDQo+
IC0JCXJldHVybiBOVUxMOw0KPiAtDQo+ICAJQVNTRVJUKHppLT56aV9ucl9vcGVuX3pvbmVzIDw9
DQo+ICAJCW1wLT5tX21heF9vcGVuX3pvbmVzIC0gWEZTX09QRU5fR0NfWk9ORVMpOw0KPiAgCW96
ID0geGZzX29wZW5fem9uZShtcCwgV1JJVEVfTElGRV9OT1RfU0VULCB0cnVlKTsNCj4gQEAgLTU3
NiwyMyArNTkyLDYgQEAgeGZzX3pvbmVfZ2Nfc2VsZWN0X3RhcmdldCgNCj4gIAlyZXR1cm4gb3o7
DQo+ICB9DQo+ICANCj4gLS8qDQo+IC0gKiBFbnN1cmUgd2UgaGF2ZSBhIHZhbGlkIG9wZW4gem9u
ZSB0byB3cml0ZSB0aGUgR0MgZGF0YSB0by4NCj4gLSAqDQo+IC0gKiBJZiB0aGUgY3VycmVudCB0
YXJnZXQgem9uZSBoYXMgc3BhY2Uga2VlcCB3cml0aW5nIHRvIGl0LCBlbHNlIGZpcnN0IHdhaXQg
Zm9yDQo+IC0gKiBhbGwgcGVuZGluZyB3cml0ZXMgYW5kIHRoZW4gcGljayBhIG5ldyBvbmUuDQo+
IC0gKi8NCj4gLXN0YXRpYyBzdHJ1Y3QgeGZzX29wZW5fem9uZSAqDQo+IC14ZnNfem9uZV9nY19l
bnN1cmVfdGFyZ2V0KA0KPiAtCXN0cnVjdCB4ZnNfbW91bnQJKm1wKQ0KPiAtew0KPiAtCXN0cnVj
dCB4ZnNfb3Blbl96b25lCSpveiA9IG1wLT5tX3pvbmVfaW5mby0+emlfb3Blbl9nY196b25lOw0K
PiAtDQo+IC0JaWYgKCFveiB8fCBvei0+b3pfYWxsb2NhdGVkID09IHJ0Z19ibG9ja3Mob3otPm96
X3J0ZykpDQo+IC0JCXJldHVybiB4ZnNfem9uZV9nY19zZWxlY3RfdGFyZ2V0KG1wKTsNCj4gLQly
ZXR1cm4gb3o7DQo+IC19DQo+IC0NCj4gIHN0YXRpYyB2b2lkDQo+ICB4ZnNfem9uZV9nY19lbmRf
aW8oDQo+ICAJc3RydWN0IGJpbwkJKmJpbykNCj4gQEAgLTYxNSw3ICs2MTQsNyBAQCB4ZnNfem9u
ZV9nY19hbGxvY19ibG9ja3MoDQo+ICAJc3RydWN0IHhmc19tb3VudAkqbXAgPSBkYXRhLT5tcDsN
Cj4gIAlzdHJ1Y3QgeGZzX29wZW5fem9uZQkqb3o7DQo+ICANCj4gLQlveiA9IHhmc196b25lX2dj
X2Vuc3VyZV90YXJnZXQobXApOw0KPiArCW96ID0geGZzX3pvbmVfZ2Nfc2VsZWN0X3RhcmdldCht
cCk7DQo+ICAJaWYgKCFveikNCj4gIAkJcmV0dXJuIE5VTEw7DQo+ICANCj4gQEAgLTEwMTksNyAr
MTAxOCw3IEBAIHhmc196b25lX2djX3Nob3VsZF9zdGFydF9uZXdfd29yaygNCj4gIAlpZiAoIWRh
dGEtPnNjcmF0Y2hfYXZhaWxhYmxlKQ0KPiAgCQlyZXR1cm4gZmFsc2U7DQo+ICANCj4gLQlveiA9
IHhmc196b25lX2djX2Vuc3VyZV90YXJnZXQoZGF0YS0+bXApOw0KPiArCW96ID0geGZzX3pvbmVf
Z2Nfc2VsZWN0X3RhcmdldChkYXRhLT5tcCk7DQo+ICAJaWYgKCFveiB8fCBvei0+b3pfYWxsb2Nh
dGVkID09IHJ0Z19ibG9ja3Mob3otPm96X3J0ZykpDQo+ICAJCXJldHVybiBmYWxzZTsNCj4gIA0K
DQpMb29rcyBnb29kLA0KDQpSZXZpZXdlZC1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVy
Z0B3ZGMuY29tPg0KDQo=
