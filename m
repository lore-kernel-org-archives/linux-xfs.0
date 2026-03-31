Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207973A63F2
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 07:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774942778; cv=fail; b=fwE1CwWSUUNMYikbHgbr2D/YkulLeirtpBCCvJeyVNzqmbdbeiHAAsOmfkNzvSpqqvFm1Zy4MeWMklAM311JwFFrfVfCI3UwOjCvYyj4n/TN7cbhnlXKTSvKIEAOIxAZTCnZYRgiwhyAisOqFp+WkMQRFjb2nAbhzVN1lhQ1yIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774942778; c=relaxed/simple;
	bh=5TFBTqpt+dMrrsC+yKHTKZ9y8LEdVjqWqsLP2VivIQg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dBE5QlvjDhPl/0o73RkWLEtijQ+U4oKEAeNvhfl5CqyC1QloT/svMcYMuyWLvK1fYsjyComcVAXbI3tciNMpZvMHf19uDtw+Ays4QBnhxBZmxITmAfAdKdfwrIu7QBpKDGlVIaELIEfJLK9i2fLeqw7WzfAJP18b+ftR24YVV9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F7YzRiuX; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ghHwl7aD; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F7YzRiuX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ghHwl7aD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774942772; x=1806478772;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5TFBTqpt+dMrrsC+yKHTKZ9y8LEdVjqWqsLP2VivIQg=;
  b=F7YzRiuX8uNdFfLTo8dGw9FZvQRRVibFvhl7XmQgU3p5Iqte3+XCTsBQ
   4/jF2PttBxtaanK4vSRGkncPfCyGrzGT325/I6xcs0ac/64bZpbOJu5Bk
   EGgHveqkdW5n5g5My3s2prWXkHX3TpDbp2voUbsQ+J9XctLcA0JlSiZ1H
   Rlk8pKIkwbqS7x8GX3lqe8ce4zmVsqWqTEGf3/oXMS+nmVaHg8G3YM8v2
   2xFgM7z21CKaBMXwM4icyeEQb//L0Z9cdt9VkO+9hQJ9rvk76wuyy1YsZ
   TySOyveNbloNSoed/YZGzDtcd7JhW6qeeMJEUSsyBkOyjVPkIibxDNlHh
   Q==;
X-CSE-ConnectionGUID: aZlUECOsRoGJKbAukAg+Kg==
X-CSE-MsgGUID: LoPe3wgrQW2yLJcwcq7Jog==
X-IronPort-AV: E=Sophos;i="6.23,151,1770566400"; 
   d="scan'208";a="143584310"
Received: from mail-centralusazon11011012.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Mar 2026 15:39:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ChSEwALPymepcmSpVCAO5I/X1qRdZMAeDN518WMwj+KOrldpA5vFYadqKK96nYIeEB/2vdpLoUpOtB+3rDVwEIfudeSZ49jkbALppv7mHwBaRNfnMfAHfgGEBwV6q7wjeLHe3kkT9JxkAgUCXsUF2dJQg4F7YbfUgS+0GVLsnyM3+gdRefcUOt35QPcVTvirS2EDDHOLellTsFrbzLg3OpV9wEdrG8hjowWr7z16kLlEXNUu3T8JXXwfEHfxeXizJy0MrVUqkuZZXaQvaQHw65cm9iI9dpNW0AeUSbsPzEqqLr8IFbgEBkWLIPw3yLi82HsdA1NXphuHM7dpJcuN2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5TFBTqpt+dMrrsC+yKHTKZ9y8LEdVjqWqsLP2VivIQg=;
 b=cwGJbuw3jDPoMbiCwHGkoqtDj9a7b8yr8UNhdzmQeHhD4uG/+pEWLAjyrMZaR8aAyZEVit6Ckkn50fANGPfHChuKD5qqHDUyIiBvk7NhY78TUZhrMX+tudQHs5pQTgOH8ShEib7yzertLMcyUub9vFx133hEzic7ZQqSCVDnQQQHuNpgViLSypcorqRSCDUmiWpgbHfOi5cx5rGMmPZLtFQ4d28eHQAkIHR9qPqPCdkoiS53Qyyo4HqZ3SWMMx74nOzi+3TDHjZKe3kGr469fef53QkoSIbXYY9eIAQAav/7lz81MuA5GL3dY3xBlEGafLNi3EqesKKyAIE5CXqE4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TFBTqpt+dMrrsC+yKHTKZ9y8LEdVjqWqsLP2VivIQg=;
 b=ghHwl7aDpYiD+9MnOf2XpXc4tC3VIRe6ZQoZGtGFMpCkYiKk6tfbth7eJU0cZsNoT86wyuScTmfcvnMgU9ehbNS+m7ofi5bnhbdT2vMEPhVlYO+wOiXLYKkxH4JBerUoklCEotV7VweU3tLNzVwkU2VwwqtZUQiVyHQPgRVuOuY=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH4PR04MB9481.namprd04.prod.outlook.com (2603:10b6:610:242::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 07:39:30 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 07:39:30 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] xfs: expose the number of open zones in sysfs
Thread-Topic: [PATCH 3/4] xfs: expose the number of open zones in sysfs
Thread-Index: AQHcwAfg0Ln8FSCIpkGLvaFqL34Jk7XIQvQA
Date: Tue, 31 Mar 2026 07:39:30 +0000
Message-ID: <9dade651-721d-4a4b-a736-dea2c5db7b6e@wdc.com>
References: <20260330054111.3855818-1-hch@lst.de>
 <20260330054111.3855818-4-hch@lst.de>
In-Reply-To: <20260330054111.3855818-4-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH4PR04MB9481:EE_
x-ms-office365-filtering-correlation-id: ab8900c0-1a7a-4f05-4cca-08de8ef8a4ff
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 r0cNGI3izpQ4cq3exem3Y4NfBMzecC7J3vgaXHbvFEsHlXO4IrXAk+EcdA+GT2DfTUp/EgveMd5Ul8UXKUjYD4L6L2z5oM8P7A29xrjywZJ/a7EMhDMerBYXwDxom/qPm+maUxwxrJHGFNgWGHZU0UZmlx87akftdecfY2ISGFqDGJP86yaV/jtKJtpZblgX92ziKBrNqVmkUI3S4MfhQclm0Rlz0RCPZyrbQb736Wn0bp8InTnhxqSJ6e3m3mHf7k9SBOJsg7FyE8f+i64R/eIv/giiBRAWmn3p2lOPt8JR6DGHzHD/opkqq5TTudnqvPk/46cfSvu6PXULzUV7+xcIgJSgNAdpKDWMNWam5P6pqkXGi2Cl3duym6hy5F6imn7Mlj6k99X/5mhY0zTKth0p2rwXkc+nDNNAJiEe979yafabZsuhBeGZzmJd0Dq2sKCboC76TqTZqa3CV6ue1XQHQD8kfGlj5MF6rThpGjCzFNZ/a0nm3ymfsEInaIHu4kupYnov+skU4cJMnw4PvuCVZQTRRehNOS8m6Y8Z+si4UzNrO+GQxp0KIsB0MrL9A3q/L+4HWyYMq2dhXOWw5PNOgcZVj8/5coJglkejOUK/AmzC6eXl+SGXED9fqzDWG4Uk5W6JQVIzTR7SklWg21aocnI/fBq9R+fKOc+UxeRkY/i9k7/zsvdMNOfnbnVwqMbXDkvcHG97RPEYSTFF8BucwE7xczPoE+XyF4MbmDiEftvDME53s9bqpamHtoxG/ZkNVfmjUnzszAY7GQC5bZleMb4H8E80MdysIh/AhX8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cy9rSlJCdlNuUXlUMmVabVNkQ1FMYVJaUVVhamx1ODB0SExpL3JlenE2Q2Rh?=
 =?utf-8?B?T0R0bUY5K3ZVYXFTTUVvMnM1VzlvUHliSnZiYTBCK0hOV2cwekdyRFBzbllB?=
 =?utf-8?B?Tk9WR2N1bDh3ajN4TFNYTnFKTHEzSXpFU2NGeW1FNEdnYUd3OFp5bktyNDlx?=
 =?utf-8?B?WkY1cGRjVDZBdEpSbC9remRhY2czUmFNZlpDM0FGd2gwMHZKMUgrMncrTXhX?=
 =?utf-8?B?RFRFZkVKS2l6M3FyS0htQXpBU0lFOTV1NEh3SXBLdTZVMWpkWUsrZmJ3L0JE?=
 =?utf-8?B?NWp3aUFCWlhLUmt5VnUwelR1R1ZMMGhndDR3bWlOTFIwRThON3BmTWlqNFVj?=
 =?utf-8?B?ajZBazM3eXNxWG9DZWRlUUYvNXB6Rk9UZEpueW9aQXlTWUFZY1NsanRyNXJ3?=
 =?utf-8?B?djBheFRtQjZEbW0wODh5VUhuMUJRT1ZmNVFRNEQ0bjVWektZelVLdkk3TDFH?=
 =?utf-8?B?T3lmZHgrcG5qZndpQ2wzNmRKZHl6VUlTbVJhUHRRTmc3MjVUZVF3dEdlSXB1?=
 =?utf-8?B?Tlpzc2dFS1JIM3hPOUFsYUZyNEI3a3RVOWtVY3FWY2VRRTVDSGRRbXNORmI4?=
 =?utf-8?B?cWpRNTRwWDk4aXprZ1p4ajViaDJEQzVybFBiZU5ZbnFLbWxBRnRIT1BCOFNk?=
 =?utf-8?B?cHJtZDZMc2VENFVybTZkTzRKRlgvbVc0aGMybzlGbUtBR1J0K2M4MWtwaHBQ?=
 =?utf-8?B?amVDR3cvQ254aElnRmgvRkxPak8xK0VISXZzNWIwdHJXeHRNcHFEdnpPS0tu?=
 =?utf-8?B?UERCeU9YRjVBRUtLZlJjd00vS25iUElXeUR6enFoWUUzeDN1bGR5Q1JlTWd4?=
 =?utf-8?B?YXBUcWlhS3RkbkZ5amZsUGpFcnY2QVIvWFB1OU9vK2gzQUdNZ0daUndBVk9u?=
 =?utf-8?B?TVY2cG9IT2xBV0FVbTR6WlJrdExmS2hvcXkxNm5LOUlsdFdNOXRGcEZHempt?=
 =?utf-8?B?cnhWU0pNcmtxZlNVc1pGem5JZnlXc3lWMFI2cnVESzBRdWZtSURiZ2dzdDA4?=
 =?utf-8?B?R0tReUF1dkYvdzZDNFk1UEF0ZzhnMVFZM3Y4K3F5NmpuTjBGZzMyUVdacDJM?=
 =?utf-8?B?VTJGV1IrR3FiZWVsUGp4V09MN0xLK1k2dUI4NnkweXpxSkJlbEo0OVlCMVI5?=
 =?utf-8?B?OE45M0hXbTlSU1ppL2JMZW1ybzNwQ0JaZG1ib21xR09xdFBtWWNzbWZlanh6?=
 =?utf-8?B?Q0pxcm1pcThkOXZlbmRnVVNNYlZMdFlJUGsxNSswby9qcDBMOVBndDVNbTFG?=
 =?utf-8?B?TWE1N21jL25aN0ZZbkJwT3Qvb2tpOWZ5cjk4VjN3NWRnTlgwNllKT0FHMnRm?=
 =?utf-8?B?NEozVVk1N3VMN3JjZ2hJcFlRSXo0VGpwbCs0MlluaEYzMHhoaE1sZXJTSWdM?=
 =?utf-8?B?VW9zeUZ3R2Foc3Y2emtyQVRPTTNzZU0zcmVKZlZDMnVNd01pem5ocnhIZlR1?=
 =?utf-8?B?MHVnZ0x3Y05GMGUwQ21FNUQzamdwK25kcWpGa1V3emorOXpiQ2xHTlZMTnBV?=
 =?utf-8?B?R1Y2Rk5UMGtJd0FtMjFneWdSM1dQTW5BbkkvMit0SnJtY0FRU3NCSVIreTU4?=
 =?utf-8?B?cjA4K095ajRiK2pPTWVyMkl0MVhWZWJWTHhrNVExazZBb1dVMlNOeSt4L0Iw?=
 =?utf-8?B?bXJDRW91ZzNjUVpTSjdiWjdaMzM1OE9tWHl0ZlkvdVRnd0cwdVh2T0M5bjZE?=
 =?utf-8?B?WUdMbDMxQUhhUUlIUlo0SU10bkVhWTJZci8xVnVZcGI4amNVd3M5T2RacWl6?=
 =?utf-8?B?ZUFzVUVoSTJ6czBveDhzS2d2OW01NEVkOWxKMVpYdWd4eUV3Mmx5cisxR0VD?=
 =?utf-8?B?Z2Y4azE2Q3U0RE00TE1SWTRObCtaRXMzYURCQjg2TGVvbHdPMGZqYUU5OHlN?=
 =?utf-8?B?OGRXQXpaMHVES3Y4YmxkQUhlS1pWK3BOcWhvUTNMeUdONVBGUWVVZ2ZBYS9F?=
 =?utf-8?B?SlgxN2VzeU84S0lGYXpndFpMZUdTcGhkYWg4Y08rcVA3cGFKTko0UTBSUS84?=
 =?utf-8?B?Q0ZmMU5VaGlUL2RQbFhlTFhnOVFjTE9yWnRMYUNKMGpUYXlvRlllT3JJMDNl?=
 =?utf-8?B?ZTV1QS9aRVdTYWtFc1M2Um0yWFVUWVhCUWZyN1JjUXBTaC9GamprcHlpMUpC?=
 =?utf-8?B?Q01zb1B2R2N4MjNKejJPSHBNMVc4MzgyTnFrbFA2Vk1CWWZyeTltZ0x1dnBL?=
 =?utf-8?B?SmJtaWdIdGhCeGdpWmFQS015SkJMREhBMHJZWFBaSTJWRFRQUWtaVVViZDFx?=
 =?utf-8?B?bTZLcTBDeTQ3ZktYZnlXVnk2dm8rTXJ6dlBuemxYdlFzRTgwTjdjNWpoZHVJ?=
 =?utf-8?B?bkRpTzFwOWxSSkpmdjM5VUZ4cCtpSkU2RGJXZW91R3FvK3BlekFKZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B72CFC2AE172D04683D41C43CD89CD27@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	WnBGyYAeN5Ue44wfZ17RtDT9JQAbu5PPkiBusqQkuWwxh7/BlYb3XpSqqIL6N8yRCksgypbTWqeH+mqc0ugcj/evtXtXQnAX388RXMsTMiJujfzjVaeopQLrF3jLgIwUUF4cnRwzWfBWCAmK9qMUoNRTkDZTHZIKYAjaqLvqBvWWFQMjAeVFSx47PBkjTK2xqi5lgDFkhUIVCcbcVfIOtRHeZ9Dw+iCqCsGuNyd/To2nCNrGucqdNFt3iob806sKkpo5uh8I1Dt6cV6UQZ1Lj5sFdH41Ji7ClDnERItUxKEMEbWTevzKXxldBz/MT7Qd59+NWB4hhJ1vgaikij/1mA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UKaa/oCfS1myIgoO+fD+0RmoUm6Jb5AjtMhcgwsVWMZnLMFHHEnZjFZeBg+tShGUUfKQ/18bDtHjEq4sXk5lj2PQgNr1/K2ZheBmMMcjDLuCztmQwyrH/mKtrFdgIcpWRhyoyBO9bBbRxKWNSTpPhuZYIQxCocKAyjFZ5xcclz4X9AAdpi2Vd1a6mFGYIsoTAxHlUo5pIcfkIfmin8E7Q2Hr4gQNcityj/+Il88SnLmq7Ztc7Ohe7CIlultcrbaKDDONzIU/qV46amuWzvojCG9OtpxG0BBasnetOGWkyTE0GBRoBcUaHlP38v7YVhxVvaFPMuscI+iBchHtpLYDlX+F41/4a87jBxQhyNZ4kf9Tt3whq8zd0AQOggrFLkhBHuX/M1npHAiUULOoOtkFVdIV09OuuoBb+h8FPRvJlxDCdH/w+X87mA8apzw1G3v1Gkh5vTvdPIN1Rrkj5zoyXoZO/kR6TOdTRqxtALijUjmDNKrRQvAs1SFF/9WuqJJDlJ+5Ie/mIgstcOtkO7BcBrhmTc0MCq1NbAf2E2jCew/mx9UsKK3We/POQHtuRj/Mu/R631b/M02eA1RT715VG05mczQ7ppKbohUxGyonaZPcOqFp1n4U7SlyEj95GpY4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8900c0-1a7a-4f05-4cca-08de8ef8a4ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 07:39:30.4032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9CX3g9ICHIXgouczUkiLDTFASkEO0SxVnbYW0WIw8/wXb/Wa8dipZatgvkeL3PemY6XkngwEKUnpvSaazqNwOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9481

T24gMzAvMDMvMjAyNiAwNzo0MSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBhIHN5
c2ZzIGF0dHJpYnV0ZSBmb3IgdGhlIGN1cnJlbnQgbnVtYmVyIG9mIG9wZW4gem9uZXMgc28gdGhh
dCBpdA0KPiBjYW4gYmUgdHJpdmlhbGx5IHJlYWQgZnJvbSB1c2Vyc3BhY2UgaW4gbW9uaXRvcmlu
ZyBvciB0ZXN0aW5nIHNvZnR3YXJlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhl
bGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KPiAgRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS94
ZnMucnN0IHwgIDQgKysrKw0KPiAgZnMveGZzL3hmc19zeXNmcy5jICAgICAgICAgICAgICAgIHwg
MTMgKysrKysrKysrKysrKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS94ZnMucnN0IGIvRG9j
dW1lbnRhdGlvbi9hZG1pbi1ndWlkZS94ZnMucnN0DQo+IGluZGV4IDc0NmVhNjBlZWQzZi4uZWIz
MDg1NDIxMjc2IDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL3hmcy5y
c3QNCj4gKysrIGIvRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS94ZnMucnN0DQo+IEBAIC01NTAs
NiArNTUwLDEwIEBAIEZvciB6b25lZCBmaWxlIHN5c3RlbXMsIHRoZSBmb2xsb3dpbmcgYXR0cmli
dXRlcyBhcmUgZXhwb3NlZCBpbjoNCj4gIAlpcyBsaW1pdGVkIGJ5IHRoZSBjYXBhYmlsaXRpZXMg
b2YgdGhlIGJhY2tpbmcgem9uZWQgZGV2aWNlLCBmaWxlIHN5c3RlbQ0KPiAgCXNpemUgYW5kIHRo
ZSBtYXhfb3Blbl96b25lcyBtb3VudCBvcHRpb24uDQo+ICANCj4gKyAgbnJfb3Blbl96b25lcwkJ
CShNaW46ICAxICBEZWZhdWx0OiAgVmFyaWVzICBNYXg6ICBVSU5UTUFYKQ0KPiArCVRoaXMgcmVh
ZC1vbmx5IGF0dHJpYnV0ZSBleHBvc2VzIHRoZSBjdXJyZW50IG51bWJlciBvZiBvcGVuIHpvbmVz
DQo+ICsJdXNlZCBieSB0aGUgZmlsZSBzeXN0ZW0uDQo+ICsNCg0KVGhlIG1pbmltdW0gaXMgMCBv
biBhbiBlbXB0eSBmaWxlIHN5c3RlbSwgcmlnaHQ/DQoNCg0KPiAgICB6b25lZ2NfbG93X3NwYWNl
CQkoTWluOiAgMCAgRGVmYXVsdDogIDAgIE1heDogIDEwMCkNCj4gIAlEZWZpbmUgYSBwZXJjZW50
YWdlIGZvciBob3cgbXVjaCBvZiB0aGUgdW51c2VkIHNwYWNlIHRoYXQgR0Mgc2hvdWxkIGtlZXAN
Cj4gIAlhdmFpbGFibGUgZm9yIHdyaXRpbmcuIEEgaGlnaCB2YWx1ZSB3aWxsIHJlY2xhaW0gbW9y
ZSBvZiB0aGUgc3BhY2UNCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfc3lzZnMuYyBiL2ZzL3hm
cy94ZnNfc3lzZnMuYw0KPiBpbmRleCA2Yzc5MDk4MzgyMzQuLjQzYTAyYzYyMmI2ZCAxMDA2NDQN
Cj4gLS0tIGEvZnMveGZzL3hmc19zeXNmcy5jDQo+ICsrKyBiL2ZzL3hmcy94ZnNfc3lzZnMuYw0K
PiBAQCAtMTMsNiArMTMsNyBAQA0KPiAgI2luY2x1ZGUgInhmc19sb2cuaCINCj4gICNpbmNsdWRl
ICJ4ZnNfbG9nX3ByaXYuaCINCj4gICNpbmNsdWRlICJ4ZnNfbW91bnQuaCINCj4gKyNpbmNsdWRl
ICJ4ZnNfem9uZV9wcml2LmgiDQo+ICAjaW5jbHVkZSAieGZzX3pvbmVzLmgiDQo+ICANCj4gIHN0
cnVjdCB4ZnNfc3lzZnNfYXR0ciB7DQo+IEBAIC03MTgsNiArNzE5LDE3IEBAIG1heF9vcGVuX3pv
bmVzX3Nob3coDQo+ICB9DQo+ICBYRlNfU1lTRlNfQVRUUl9STyhtYXhfb3Blbl96b25lcyk7DQo+
ICANCj4gK3N0YXRpYyBzc2l6ZV90DQo+ICtucl9vcGVuX3pvbmVzX3Nob3coDQo+ICsJc3RydWN0
IGtvYmplY3QJCSprb2JqLA0KPiArCWNoYXIJCQkqYnVmKQ0KPiArew0KPiArCXN0cnVjdCB4ZnNf
em9uZV9pbmZvCSp6aSA9IHpvbmVkX3RvX21wKGtvYmopLT5tX3pvbmVfaW5mbzsNCj4gKw0KPiAr
CXJldHVybiBzeXNmc19lbWl0KGJ1ZiwgIiV1XG4iLCB6aS0+emlfbnJfb3Blbl96b25lcyk7DQo+
ICt9DQo+ICtYRlNfU1lTRlNfQVRUUl9STyhucl9vcGVuX3pvbmVzKTsNCj4gKw0KPiAgc3RhdGlj
IHNzaXplX3QNCj4gIHpvbmVnY19sb3dfc3BhY2Vfc3RvcmUoDQo+ICAJc3RydWN0IGtvYmplY3QJ
CSprb2JqLA0KPiBAQCAtNzUxLDYgKzc2Myw3IEBAIFhGU19TWVNGU19BVFRSX1JXKHpvbmVnY19s
b3dfc3BhY2UpOw0KPiAgDQo+ICBzdGF0aWMgc3RydWN0IGF0dHJpYnV0ZSAqeGZzX3pvbmVkX2F0
dHJzW10gPSB7DQo+ICAJQVRUUl9MSVNUKG1heF9vcGVuX3pvbmVzKSwNCj4gKwlBVFRSX0xJU1Qo
bnJfb3Blbl96b25lcyksDQo+ICAJQVRUUl9MSVNUKHpvbmVnY19sb3dfc3BhY2UpLA0KPiAgCU5V
TEwsDQo+ICB9Ow0KDQo=
