Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6861C3491D6;
	Thu, 26 Mar 2026 09:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774517597; cv=fail; b=NKNNJnn+NqnoR7BFQV5udSdvTtO7M9PKr4it4+N+ELo5fHro4ye8zZDVLJdtGx+Eg+xL0NB5yqZywO1l3WNADNap7LvYV4fD6AWU1CSrVrkNUTxscRQqsU/ZRiUM2oq41pOIGeOfn7JOsfel30W5EQS08LZvISKXZBErnqFTuk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774517597; c=relaxed/simple;
	bh=yZTuRn75P4KCjiPt0hxY0NAqVqzBqGZlJuJic8IeoAg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cb/lX3oOs8di0aVsKqC6pRKQWwLakepr9ktiUnCm+YLLnl5lYD2/2fpnrrGPfqnslLl4VOOUVuvFP2/xNq7ryQ3AdaaF3d6iBUfEhP7sXEosdS5VMXD1bO4LAheRXBBakepyXhOAslxt2mWWub0WUN8qekaPtHdF09niwZFP5js=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HqM0RZww; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=l/Qrysoh; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HqM0RZww";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="l/Qrysoh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774517595; x=1806053595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yZTuRn75P4KCjiPt0hxY0NAqVqzBqGZlJuJic8IeoAg=;
  b=HqM0RZwwZNTv+neLLjNSksy5cr7f4hmfF8nzwbCtV34VAWGIxm54FM7s
   bap6xdveDssfWCoPGNvgs9cSdYjZRvjjxAfHz654pR6C4NxL+kRkbFGDJ
   tyRAZTNGd/SiO8vKwo0xzRQRa4ZMg6iZJQgeAxHLhJeFIk56X2Z7/2WgS
   mDFX+hsmf40Bd3hnMK4OBEKoj0Aqblx7YZpPaHNM6uREYzW7KFoXRIjpJ
   VpsHrUBSjU0OcBaNMUCEA9bzwdKz5v0YTdnc60YW8gp93FT2Yz50GoICM
   ZytS5QtP/L935vSZ4Q8KBkuJ8DFicd5PyGo/nlAkIL0IkB6hiNFMZU1RE
   Q==;
X-CSE-ConnectionGUID: /K+WwL+8RfmXfXcwc298NA==
X-CSE-MsgGUID: 9hkwc4C8Tw21EuynrXyw5Q==
X-IronPort-AV: E=Sophos;i="6.23,141,1770566400"; 
   d="scan'208";a="144412328"
Received: from mail-northcentralusazon11010059.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Mar 2026 17:33:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wo5TamaBAE1luqktAydvnin/RQpgz1uBeDTfrfyBuJQOTv1Q3AXdatPCtsLGJnvDa9H0nN1AojWaP1lQy8FdP7rOvldtewEX5WiZeaZ6ckzUxX+k3u3NnAV36badh0j+b4x1Cpt1+NzeUQJ12pzXS+/1lO/SMSPyzLzGkAqzdEUu/+P5b7dPhOfBWrc/OmTOmUeUkwUnCsLTpzfG27xKwVPINtV5A5G8W3ZCL0Q59EFn+GUtDeQgqolLmKVpQiJNFWs+fD2MR9Tltf7h7jGP/WzoS/kJjetP+3Z8AEnl7JJgZ4MS71f4E7sG1ZhHWNKWJXwAYmX3xrcoHhWyafZeWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZTuRn75P4KCjiPt0hxY0NAqVqzBqGZlJuJic8IeoAg=;
 b=LLysjm8Q3fVQ83jdaap3aelNlLfdP+yF2/Gb1cxz05jcLLLOKiG1wY1W9fn3aWg8inpF9/X25epKcCuj2YW/t8jKVAvDZ1mKSbN8Fsj62c4XsRZMVUpK3N40+YPCUD5Yhr9+MRX31aRc8WE44TS6ivzGw0ZQhSy/S1h8zgnqn6LGvkIO4ibbDT5fRqypzpUL++mUgrDOMoLPfZ2F70P7k8mEMiDogR1pslhIN6jK85VrQB4Thms+0jxiIT8Z4YPxxsYDl8g5ZA77IlAJwrX36qQH6zY28hZTS/ezrCJ7TtIho376lKBeUuo3ys2UE8dZluoCqHzUWHk+2VnO0GdbDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZTuRn75P4KCjiPt0hxY0NAqVqzBqGZlJuJic8IeoAg=;
 b=l/QrysohelJTXU+pWmKBWrHCoLrMsdTd3R9/sCNWDVLF4fD8qfVpkiK+c3uG2ZmZC2MNifdnppMAVok3/uM51ci1c9qL9FDibxeOkt7HLQHVMGKcuXLrHsYaEwlX2x0LNexDegQVqOANnr5l8UugEqxxh/MVVrTjl0LnwCk/8Dk=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH3PR04MB8864.namprd04.prod.outlook.com (2603:10b6:610:177::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.25; Thu, 26 Mar
 2026 09:33:10 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9745.023; Thu, 26 Mar 2026
 09:33:10 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: start gc on zonegc_low_space attribute updates
Thread-Topic: [PATCH v2] xfs: start gc on zonegc_low_space attribute updates
Thread-Index: AQHcvFT/oHBImh7GGEm+eOU61ERwhrW/XayAgAEwyAA=
Date: Thu, 26 Mar 2026 09:33:10 +0000
Message-ID: <aa57898d-5009-43fe-99b7-cb2aaff37154@wdc.com>
References: <20260325124312.26349-1-hans.holmberg@wdc.com>
 <20260325152219.GS6223@frogsfrogsfrogs>
In-Reply-To: <20260325152219.GS6223@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH3PR04MB8864:EE_
x-ms-office365-filtering-correlation-id: 482d2900-fffe-4fee-5af9-08de8b1ab1ee
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|22082099003|18002099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 zjKLI/TG/pq3IAoaXqVkaR2Cxdwg4G2riUuyf2WS/VFDqn+V3p8bEd+hxEh3WDyx5lCDbTdJ6nl0bbXy92D/7J1/Jp4uFB4bdiXy+LdKo9si0gTH9TBZ8FfcQSHYI+8fuwL9cK4L1YTidu5mmgaTsDLqMe1ZnknNYMTdL3ssv5PcGvv5aeiK8hCkPOho9sEDP6QVSJj11PAJAC/eB/K4x+loHVknOGwVh/dPLI5wIJO19hOyxxRrHxY3NbjW1ymdVq/54bWfLJXxGL6dIpgkgRd0ZWK3VRqi8dD8d8SOp8k0J66OmvKu78oOyToYqrhqLzRobmrDKeCJBOR+mO55LzA9KnarL6KxRWnbTkGF/sgLk4RVDsd3CnhQr6S4o/utF7KhkKGL3zaG7zxXIhTwzR2HoHUufMksd/vGhC1NgtGB4s7RLy+1tC/F4KK4coLahCApOVeg8yCgkq5r20RwXqGQh1/MQucyLjcK90jcxjoe8aGFLW4TjBDRIqkFO5asdvPauVgG2esZ7P5Z+stOOFmuh+a+gIrvRt0jUjioeDd5QE0eiQm4nxboSZxYybgm1guzJm+m6ZleR35o47hF6SrnYtk+E9K5B0SqhYMIH5UQdpBRvVvSxjV2aHvsGdYFB/ZKrF/pzHvjDvofX9XVb4p7k8jaeG15osIqHZ5jE31H1TBneel+6mUm65LPQLsm4HviRme3zBwBzh22dEAPPxBOsdf33HutYbGHlMXm8cCQyhuxH/c27q06OsTxtkqdgF5NUQWrnYXYidBYQJayZv/PTki0aFa/RUW4BJifYfE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Sm1YRk8ySUxycmtvMXpJZEdmTVVwMll5Mmt4V3h4c0ZQV3V4cEFGa1l5Y0tk?=
 =?utf-8?B?clVjTXE2SFVhYkxwL3ZVY2w0ZStpcGsvTkVnelFoalMrM09uQkNqVDF1cWpy?=
 =?utf-8?B?R1pnTHhFeldUNFdjaVc5eHkvMnBVVi83L2o5YnVGaGVxaTZ2Z0lxYURPcWVm?=
 =?utf-8?B?V3gwL3M2TENPZ1pEZ1ZnY3grR3F1b3YxUDNHTGRNOVFrNHdDMnlyOG9zRjg0?=
 =?utf-8?B?L1Uva0dtWWYvbWJ3dkU5Q0pPZFE3SkVoakd3S2U4akw0SVZidlJtZTYrRVBo?=
 =?utf-8?B?cDVvRXpPaDcySHAxcjZHS2NLMit1RXFwRnBCdDFZSm1Vek9ReWEwdUJ2azZ6?=
 =?utf-8?B?eTlPeXhtSVpIKzVYaWdqcHE3NTN5cXFkK0JQSVBpeXp4OE84RUF3QlJnb244?=
 =?utf-8?B?Nko3Q0U0YnpOc3VYSmxNMlJmb0t3T1pSTGpFLzg0NTczcFcvMzZ6MSt3cXoz?=
 =?utf-8?B?L1VTNU1oTUsva2JSUitEcStDaTNOdWZ6eWtOd01DSmR0VHgrbWMxYm9STnpv?=
 =?utf-8?B?amE4TW5CaUlaTFdSR1pHMDgyRUxEcXRGZi85NS9RUG1PYkZId3lBUXZ4M2Jm?=
 =?utf-8?B?LzZLUENxT1dpaTZHa241SWVqS0JQOEtxczhNMURMTmFBbWQ5WlB6Smk3cW5w?=
 =?utf-8?B?SjQvdXAxeWpuVm5va01aNStFTnhNRHpWbFVVdDlVUktKb3M1TnFCS0VGajIv?=
 =?utf-8?B?YlZMZzFjRnNvMmZ5azVkMXFnV2VFdG01azZvcUtqWU1mQ2FmOUZHU2lhaDVm?=
 =?utf-8?B?Zk8yeG1keHk3dXRST2g4WEZTYndEczlNb21ialE2S0R3TUZwQ0pOVUpOS1RC?=
 =?utf-8?B?SHc1TkxBb3FyY2RJNzd5SS8wdE90dU0zN2JYbFVreHJ5UnlDZnh2M3k1eHh3?=
 =?utf-8?B?dE44YXZXc0pzNks3dFNpSHlXcURacVU1cTdBYzNyUEcvYVJmSk9IWVhzVXE1?=
 =?utf-8?B?NTkwRktUMGVWN0twUDUvRk0rSE4zMkZjbE5IQmVzOU5IRVZneHlGbEtTbnRk?=
 =?utf-8?B?VitrSkQvb1pLNURLSjRNMngyOTBEVkI1QkFuL3NDTjZydUkySno0MlNUMk9P?=
 =?utf-8?B?bDRvS3VoN2cwMXg2bVI3SnFzckU2YkdJdlpqMXRERzUzR25sMXpzd0VoVFZu?=
 =?utf-8?B?WFJDYjBZUWpHeTRnMmVnTmxITXBNelozVjByRWx4Zyt5SGVFQkZQeVljZ0Uz?=
 =?utf-8?B?SGpLWllsTjA2WHV1K0tTQ1Jld3RobUdpWG1zdHJiSkpGSUNLV2RkT3FVSzk3?=
 =?utf-8?B?dlhad01uRUJJRDNOTWpiR0lRUWw2ZGRuOEN6ajEvMS91NGR5dzZ4Z2ZUbHVL?=
 =?utf-8?B?MFVOZ2x2UEJScmxKRkhnVlc4dkliKzBsUC9uaGtNNjRWQnJ6UVhyQXlBVU9k?=
 =?utf-8?B?K0cwdlRPZFBQOXZ4QUc3a1V0cGNXS1ZrZ3VOMi8vc2V3cXkzZVRCTGZaNTY5?=
 =?utf-8?B?UzRTQy9CbWpJajFQOHJEODZGdzJIV1BwOGJVdkwxWHZWb2hhRFJGMFRORFlz?=
 =?utf-8?B?bmxpRHBYMzMyT1AwWlVkU1BDM2s5bk52enM0UVV2WExWKzZJS1FGMTg4Mnp4?=
 =?utf-8?B?SzM5eTNSem80Sk94MytENytCWVJISk5NcnJCL3ZtWWJqTVpFM2M5Y0Y2anpp?=
 =?utf-8?B?UXluNU1rNEQ1OXR3U1dWQ2FUNjFwbnU3T2FBY0R4QlhTWmFqNDZ5dmpXZ0NT?=
 =?utf-8?B?emRzdWRvQkl5eDh0OEFlQVBLdU1wakJPTHY4R25TV2NKeHJ0MzlBWGUwQkY5?=
 =?utf-8?B?Y3VmcFM1eURnRmxkM0lOYWwwSlQzUlljN1dzcHpHMTRIdTBzc2t0K1lwYUlH?=
 =?utf-8?B?eE5HWUMrM09BVVRUVzRkbEpObkRKbHJOdDl4WUVwNlNsVVhPRUQxRUpFK2pI?=
 =?utf-8?B?VVQrdkN3amhzTERrZzV2cHJKTmJ3MzlSdWtxWUFSa21HRjV0ZEVza3hFZ05s?=
 =?utf-8?B?b3R6THN6OEZzRFcvZGVjWlhyaDR1SVZQamVRNFFWTXlCYkxFTC9OZFZlMEsr?=
 =?utf-8?B?Z0hzWGdjdkg1eDQ4RzBsTkNnQlJpVmtDSURVQ2s2R2xUMFVNZUpmWE9aUk5W?=
 =?utf-8?B?SVd6UGVua0RtWngwUExWVnN4SlM3YXpmWlpDMDJrZjB0T0kwSW1CZzVTMytl?=
 =?utf-8?B?Ty9YOTFKN2RXSEh1a2FvR2UraFZvNGtNMVRsRGhvNC9WMGFIWnlJMC84Y1VX?=
 =?utf-8?B?SXQ1eks1bXRxbUp1UXMvSlE2SXp0MVhLNVBZY2lWZFNkQ09YM3BQZVNaK1lE?=
 =?utf-8?B?cWVBVitsbmtkYXR6WVV1RTBjSWlYVFVWc2FYcHFHcEMvbWJ6djBDOGVqNHFH?=
 =?utf-8?B?cTRHWkRkaU9nQk11T1ZSQVk0KzRBRVRLbXF6US9lTXVETXI0ZkFrUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC7CBD3469B0F644A4B2003A0A9051DE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	HPSONtq+qGLlF6TRrVYRMkaItcbwYD8XpIIWwYiDBoBy7Va7d6XqctQ3sLKkcZZkSVb+QrLmvPXHjJU0+FQhkm3KD0J2HHYbgw2x1kymK3FZUYjPoLf3rpNadY9Uyk7LAiaS1oqWnZgt6h6J98RGEvRql0KcN1mXDHru5dLTb+rRbBmZjeFNNu58AXCsk9XZT5Pco3Z1HUEJyFW2yI0+HAyI/AH0AO81GRz5/TuNJm6XkqgMax8Kv/AZNPqGISsGsMtG1wUc8oZuJi0iZdcZgfmslFIJ5GungZc/DUCaa/MPgb87ZoXTkjlkCLOSkWaKjiek2FPwcg0r507scXH0xA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0be3sZHmHxCPtGa9cJwqS0/4zN/eomUUZ9dUULGCfFlNPMvXsSSY+2GisuQHVtfuh6Wza0nLK881fVktBpT1aAcm3aHsVIL/ouGtFL648io/EREAY/B0vAN8CmFOXOQUMkQIjmGJX7jNwXcwOFROHpMl6v/UbrXIs0avL5D9+jRp4lfIu50Ype81Nslu/dFw42jQratBpweeB49ifhwPJLh0EDmCVKeYAgar3iqJMIyoEyYuJlpp3lUM13KcbKj8Dn0AMAI2k1/Ek76+zKPs6i6rSo+6asbkUGUfeDkoqhGskgfwhsJitOsQ9nGY8X21vnt3D82vgeFpYpRPUspEL2x1RXsg1RKc0ciHlwh4f+V+TDcMj21/ZpLeSjUb75xtyDT47YneulS6U7kWc/qTk1mgqFuqs43JkVKnJZK8YnE26YCVpiYbdlPH1NG9XGQf/LtieDLjSm4MZQwbZFwe24ZEGsRgO74tbuxL9zQDwZ30BsfzBJ+UOJzBaPFZQ9P/0khR7dsObq1620QXo5CylrdD/+mOjg9uza/Sds+/Q7jDP5X6OzO9HKSFSoxT9+gYvy8lw+dlATIE9PqvK9JIkGJlPdrUiu7XOxScZITuCu3YmnvHUoXZ9LLsoTeR73wC
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 482d2900-fffe-4fee-5af9-08de8b1ab1ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2026 09:33:10.3654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Wmv+ZxclzXeBjpcEVdJL+5jLIsfijndPRkISVC+jI6c3nu+LOGr3pXUt9nKK5dttqL1TgsmPhDT0M/wrY+QTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR04MB8864

T24gMjUvMDMvMjAyNiAxNjoyMiwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBPbiBXZWQsIE1h
ciAyNSwgMjAyNiBhdCAwMTo0MzoxMlBNICswMTAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4g
U3RhcnQgZ2MgaWYgdGhlIGFncmVzc2l2ZW5lc3Mgb2Ygem9uZSBnYXJiYWdlIGNvbGxlY3Rpb24g
aXMgY2hhbmdlZA0KPj4gYnkgdGhlIHVzZXIgKGlmIHRoZSBmaWxlIHN5c3RlbSBpcyBub3QgcmVh
ZCBvbmx5KS4NCj4+DQo+PiBXaXRob3V0IHRoaXMgY2hhbmdlLCB0aGUgbmV3IHNldHRpbmcgd2ls
bCBub3QgYmUgdGFrZW4gaW50byBhY2NvdW50DQo+PiB1bnRpbCB0aGUgZ2MgdGhyZWFkIGlzIHdv
a2VuIHVwIGJ5IGUuZy4gYSB3cml0ZS4NCj4+DQo+PiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmc+ICMgdjYuMTUNCj4+IEZpeGVzOiA4NDVhYmViMWYwNmE4YSAoInhmczogYWRkIHR1bmFibGUg
dGhyZXNob2xkIHBhcmFtZXRlciBmb3IgdHJpZ2dlcmluZyB6b25lIEdDIikNCj4+IFNpZ25lZC1v
ZmYtYnk6IEhhbnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCj4+IC0tLQ0KPj4N
Cj4+IHYyOg0KPj4gLSBBZGRlZCBhIG5ldyBoZWxwZXIgdG8gd2FrZSB1cCB0aGUgZ2MgdGhyZWFk
IGluIHN0ZWFkIG9mIHVucGFya2luZyBpdCwNCj4+ICAgd2hpY2ggaXMgcmVxdWlyZWQgdG8gbWFr
ZSB0aGlzIHdvcmsgcHJvcGVybHkuDQo+PiAtIEFkZGVkIHByb3RlY3Rpb24gYWdhaW5zdCByYWNl
cyB3aXRoIHVubW91bnRzIGFzIHN5c2ZzIGdldHMgdG9ybiBkb3duDQo+PiAgIGFmdGVyIHRoZSB6
b25lIGluZm8gc3RydWN0IGlzIGZyZWVkLiBUaGlzIGFsc28gYXZvaWRzIHVubmVkZWQNCj4+ICAg
d2FrZXVwcyBkdXJpbmcgcmVtb3VudC4NCj4+IC0gQWRkZWQgZml4ZXMgYW5kIHN0YWJsZSBjYyB0
YWdzIGFzIHByb3ZpZGVkIGJ5IERhcnJpY2suDQo+Pg0KPj4gdjE6IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xpbnV4LXhmcy8yMDI2MDMyMDEzMDI1Ni4zNTIyNS0xLWhhbnMuaG9sbWJlcmdAd2Rj
LmNvbS8NCj4+DQo+PiAgZnMveGZzL3hmc19zeXNmcy5jICAgICAgfCAgNyArKysrKystDQo+PiAg
ZnMveGZzL3hmc196b25lX2FsbG9jLmggfCAgNCArKysrDQo+PiAgZnMveGZzL3hmc196b25lX2dj
LmMgICAgfCAxNyArKysrKysrKysrKysrKysrKw0KPj4gIDMgZmlsZXMgY2hhbmdlZCwgMjcgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZz
X3N5c2ZzLmMgYi9mcy94ZnMveGZzX3N5c2ZzLmMNCj4+IGluZGV4IDZjNzkwOTgzODIzNC4uNDUy
NzExOWIyOTYxIDEwMDY0NA0KPj4gLS0tIGEvZnMveGZzL3hmc19zeXNmcy5jDQo+PiArKysgYi9m
cy94ZnMveGZzX3N5c2ZzLmMNCj4+IEBAIC0xNCw2ICsxNCw3IEBADQo+PiAgI2luY2x1ZGUgInhm
c19sb2dfcHJpdi5oIg0KPj4gICNpbmNsdWRlICJ4ZnNfbW91bnQuaCINCj4+ICAjaW5jbHVkZSAi
eGZzX3pvbmVzLmgiDQo+PiArI2luY2x1ZGUgInhmc196b25lX2FsbG9jLmgiDQo+PiAgDQo+PiAg
c3RydWN0IHhmc19zeXNmc19hdHRyIHsNCj4+ICAJc3RydWN0IGF0dHJpYnV0ZSBhdHRyOw0KPj4g
QEAgLTcyNCw2ICs3MjUsNyBAQCB6b25lZ2NfbG93X3NwYWNlX3N0b3JlKA0KPj4gIAljb25zdCBj
aGFyCQkqYnVmLA0KPj4gIAlzaXplX3QJCQljb3VudCkNCj4+ICB7DQo+PiArCXN0cnVjdCB4ZnNf
bW91bnQJKm1wID0gem9uZWRfdG9fbXAoa29iaik7DQo+PiAgCWludAkJCXJldDsNCj4+ICAJdW5z
aWduZWQgaW50CQl2YWw7DQo+PiAgDQo+PiBAQCAtNzM0LDcgKzczNiwxMCBAQCB6b25lZ2NfbG93
X3NwYWNlX3N0b3JlKA0KPj4gIAlpZiAodmFsID4gMTAwKQ0KPj4gIAkJcmV0dXJuIC1FSU5WQUw7
DQo+PiAgDQo+PiAtCXpvbmVkX3RvX21wKGtvYmopLT5tX3pvbmVnY19sb3dfc3BhY2UgPSB2YWw7
DQo+PiArCWlmIChtcC0+bV96b25lZ2NfbG93X3NwYWNlICE9IHZhbCkgew0KPj4gKwkJbXAtPm1f
em9uZWdjX2xvd19zcGFjZSA9IHZhbDsNCj4+ICsJCXhmc196b25lX2djX3dha2V1cChtcCk7DQo+
PiArCX0NCj4+ICANCj4+ICAJcmV0dXJuIGNvdW50Ow0KPj4gIH0NCj4+IGRpZmYgLS1naXQgYS9m
cy94ZnMveGZzX3pvbmVfYWxsb2MuaCBiL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5oDQo+PiBpbmRl
eCA0ZGIwMjgxNmQwZmQuLjhiMmVmOThjODFlZiAxMDA2NDQNCj4+IC0tLSBhL2ZzL3hmcy94ZnNf
em9uZV9hbGxvYy5oDQo+PiArKysgYi9mcy94ZnMveGZzX3pvbmVfYWxsb2MuaA0KPj4gQEAgLTUx
LDYgKzUxLDcgQEAgaW50IHhmc19tb3VudF96b25lcyhzdHJ1Y3QgeGZzX21vdW50ICptcCk7DQo+
PiAgdm9pZCB4ZnNfdW5tb3VudF96b25lcyhzdHJ1Y3QgeGZzX21vdW50ICptcCk7DQo+PiAgdm9p
ZCB4ZnNfem9uZV9nY19zdGFydChzdHJ1Y3QgeGZzX21vdW50ICptcCk7DQo+PiAgdm9pZCB4ZnNf
em9uZV9nY19zdG9wKHN0cnVjdCB4ZnNfbW91bnQgKm1wKTsNCj4+ICt2b2lkIHhmc196b25lX2dj
X3dha2V1cChzdHJ1Y3QgeGZzX21vdW50ICptcCk7DQo+PiAgI2Vsc2UNCj4+ICBzdGF0aWMgaW5s
aW5lIGludCB4ZnNfbW91bnRfem9uZXMoc3RydWN0IHhmc19tb3VudCAqbXApDQo+PiAgew0KPj4g
QEAgLTY1LDYgKzY2LDkgQEAgc3RhdGljIGlubGluZSB2b2lkIHhmc196b25lX2djX3N0YXJ0KHN0
cnVjdCB4ZnNfbW91bnQgKm1wKQ0KPj4gIHN0YXRpYyBpbmxpbmUgdm9pZCB4ZnNfem9uZV9nY19z
dG9wKHN0cnVjdCB4ZnNfbW91bnQgKm1wKQ0KPj4gIHsNCj4+ICB9DQo+PiArc3RhdGljIGlubGlu
ZSB2b2lkIHhmc196b25lX2djX3dha2V1cChzdHJ1Y3QgeGZzX21vdW50ICptcCkNCj4+ICt7DQo+
PiArfQ0KPj4gICNlbmRpZiAvKiBDT05GSUdfWEZTX1JUICovDQo+PiAgDQo+PiAgI2VuZGlmIC8q
IF9YRlNfWk9ORV9BTExPQ19IICovDQo+PiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc196b25lX2dj
LmMgYi9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPj4gaW5kZXggMGZmNzEwZmEwZWU3Li5hOGY3MTIz
MWYzNTEgMTAwNjQ0DQo+PiAtLS0gYS9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPj4gKysrIGIvZnMv
eGZzL3hmc196b25lX2djLmMNCj4+IEBAIC0xMTcxLDYgKzExNzEsMjMgQEAgeGZzX3pvbmVfZ2Nf
c3RvcCgNCj4+ICAJCWt0aHJlYWRfcGFyayhtcC0+bV96b25lX2luZm8tPnppX2djX3RocmVhZCk7
DQo+PiAgfQ0KPj4gIA0KPj4gK3ZvaWQNCj4+ICt4ZnNfem9uZV9nY193YWtldXAoDQo+PiArCXN0
cnVjdCB4ZnNfbW91bnQJKm1wKQ0KPj4gK3sNCj4+ICsJc3RydWN0IHN1cGVyX2Jsb2NrICAgICAg
KnNiID0gbXAtPm1fc3VwZXI7DQo+PiArDQo+PiArCS8qDQo+PiArCSAqIElmIHdlIGFyZSB1bm1v
dW50aW5nIHRoZSBmaWxlIHN5c3RlbSB3ZSBtdXN0IG5vdCB0cnkgdG8NCj4+ICsJICogd2FrZSBn
YyBhcyBtX3pvbmVfaW5mbyBtaWdodCBoYXZlIGJlZW4gZnJlZWQgYWxyZWFkeS4NCj4+ICsJICov
DQo+PiArCWlmIChkb3duX3JlYWRfdHJ5bG9jaygmc2ItPnNfdW1vdW50KSkgew0KPiANCj4gc191
bW91bnQgY2FuIGJlIGhlbGQgZXhjbHVzaXZlbHkgZm9yIG90aGVyIHRoaW5ncyAoZS5nLiBmcmVl
emUgYXR0ZW1wdHMpDQo+IHdoaWNoIG1lYW5zIHRoYXQgeW91IG1pZ2h0IG1pc3MgYSB3YWtldXAg
aGVyZSBldmVuIHRob3VnaCB0aGUgZmlsZXN5c3RlbQ0KPiBpc24ndCB1bm1vdW50aW5nLg0KPiAN
Cj4gVGhhdCdzIHByb2JhYmx5IGJlbmlnbiBoZXJlIGFuZCBpbiB0aGUgb3RoZXIgcGxhY2UgKGlu
b2RlIGZsdXNoKSB0aGF0DQo+IGRvZXMgdGhpcywgYnV0IGl0J3Mgd29ydGggYXNraW5nIC0tIHdp
bGwgaXQgbWF0dGVyIHRoYXQgdGhlcmUncyBhIHNsaWdodA0KPiBjaGFuY2UgdGhhdCBzb21lb25l
IGFkanVzdHMgdGhlIHZhbHVlIGFuZCB3ZSBmYWlsIHRvIHdha2UgdXAgdGhlIGdjDQo+IHRocmVh
ZD8NCj4gDQoNCkZvciBmcmVlemVzLCB3ZSdsbCBjaGVjayB0aGUgY29uZGl0aW9uIGZvciBzdGFy
dGluZyBnYyB3aGVuIHdlJ3ZlIHRoYXdlZCwNCmFuZCBpbiBnZW5lcmFsIEkgZG9uJ3QgdGhpbmsg
aXQncyBhIGJpZyBkZWFsIHRvIG1pc3MgYSB3YWtldXAgd2hlbiB3cml0aW5nDQp0aGUgYXR0cmli
dXRlIGZvciByYXJlIGNvcm5lciBjYXNlcy4gVGhlIG5ldyBzZXR0aW5nIHdpbGwgdGFrZQ0KZWZm
ZWN0IGFzIHNvb24gYXMgYSB6b25lIGlzIGZpbGxlZCBvciBtYXJrZWQgYXMgcGFydGlhbGx5IHVz
ZWQuDQoNCg0KDQoNCg0K
