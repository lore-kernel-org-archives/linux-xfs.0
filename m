Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B083D47B2
	for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2026 07:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788246461; cv=fail; b=gaCPdQcpUI+UnRRDbRfixjS0pPjgByXEOtvDn2zZdDjHqCoIsa7qqnrnph0jkwRrklkmNIL1s4fvRKEEhqfyqKrv7ug131v/1qGN40HbxjxOl+CgIH4433AFros8VgTM1KBBSaPVORK6KhdBiiib8i2GRnJFgwgg9wwbQzdyLY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788246461; c=relaxed/simple;
	bh=dqp6Nkjd4upR2j0wNL7QgjooAa5/BYkzY+hO+DpO8xA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=THlK9zh7aZ4toIYt+E4jA8okRz8a39DQQwxQrp6TSJqk0Ai53CIonxSaLs+JlQnoN5tKDM+NK0b9BwROMXVWgV7N8jGuyMz7TcTrFCxeXxJGfJuRtreh0wJH7z+H0QYmpAw99YhEmV3Vduenil+iYrX50L3XKOe1aQQE3onObRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NO01hm7j; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Rp+QSwVC; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NO01hm7j";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Rp+QSwVC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788246458; x=1819782458;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dqp6Nkjd4upR2j0wNL7QgjooAa5/BYkzY+hO+DpO8xA=;
  b=NO01hm7j2P3u+9xmYVIz0RwebQjPMIQKjgRA+r5KoyFF+6lRNk2sIZsj
   mfCzNxZUBmNCUj4z3rnOXwNQPo+6RT4Oo4prjnQ4QydLWhbv6KSJuQxik
   HnLme75yCUxJKSBXtkARrMY6VI4CiLY5EFG2gqR+DmSS+L4iyPqY5rb7m
   4q/QajC0CpIE/AgVee3+5nE+ioINLZFia8SrTsJc3tvIfrTjsXdged2Vp
   KTFKpeScFIgkHlMcx6ZUthmA69GAaMRSpNfYXSYQcp4teKvt7BDE7t5ka
   pTwkBDpRVOnsakWUb+qKmP3DZ0988hkveto8eMl1c5HSIq7iqGGj+Eyw5
   g==;
X-CSE-ConnectionGUID: Ay8p8AIiQKiay3cVSZQAhw==
X-CSE-MsgGUID: eLsGgut/SMmLasiTHsf0JA==
X-IronPort-AV: E=Sophos;i="6.25,255,1779120000"; 
   d="scan'208";a="154680640"
Received: from mail-eastusazon11012007.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.7])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Sep 2026 15:07:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=snzWHdinIvngivFmyyi4kSwKAM8Ws2n0c1kesp7atAKg41f8qBLBr1KN7nhhVdi7Jlo4AIa6Z6NQ41hEeg2BY6y2xhxigpB4Mkr4xu3j/n/4ALwYonCl/5807Ahs70kGJgAK2ap4BboKoWGKa1msqIDgBJhbgGssJY/Y8FnfXzOW5jo1GrtfjBTYS8hTRkIZ9Co0oEIviWEYLECEc/sbuWcjYCVAMUaqfpFyLgyehQnQXoWJdfFKADK8EWdll2yckqo7Xj4ZEhYx3Z6bFzhGJqNpKsa4/I7WWB7IRjyGw/G141bHKLQpir0DY3exSyTv9u9v++aJQBN02NAf1feXnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcIbBOwgjevqrQf+RofQZx7XO1Febz0/TpZrrRhihc0=;
 b=uPzFA2EXxwqYBLr90qc7w/uu4XimXCkkQmfYfX5WNNjWk2tuEL5TemPy5r8CmfphxV7GMxnghwYbiSAXwUhyTkYvt+rcp+DBGe9xogX1CKr7Nvue3weS7utiiJqjLChCn7Yn2xnOoQD8niYlesSEj7jA+im7/CLnHRvXOIJjzbLypdspn1s5OJYFXqL9KA0mrE8VRBGN86MI6M4DUDjBmCDvw0RhU9M3yo9EF6x0oSh9j/26IQYg2acQ7vzgdtl01QEFGLw4TPkkS5iZpjsPrDqhDeIOnnkcKmwBafY42TRymb2WyT46S81gLPQpBJkohkUf4fnrCpscN+UUW5f7zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcIbBOwgjevqrQf+RofQZx7XO1Febz0/TpZrrRhihc0=;
 b=Rp+QSwVChkIRCbmetV8D/e8NJEf3ePmdIToq3jJyEqzV9B1h/z9P804uRSV0cBVSx3NrwB2utfcXxWpokPB1hBO3KGVAN8I7ijNcCkwuF/JClBPmRUMxUsCQFKnFoDOrz0N86gO5sZIa1jl/IIpSlndr5IxrZS2iNn1sjVBxVvA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by CH4PR04MB9083.namprd04.prod.outlook.com (2603:10b6:610:229::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Tue, 1 Sep
 2026 07:07:26 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 07:07:26 +0000
Message-ID: <b1cb1564-9ac0-4b34-8526-d5e2b455d757@wdc.com>
Date: Tue, 1 Sep 2026 09:07:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: prevent race in zoned space reservations
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org,
 dlemoal@kernel.org, shinichiro.kawasaki@wdc.com, sashiko-bot@kernel.org
References: <20260826123219.73978-1-hans.holmberg@wdc.com>
 <apUqKvNgd1Onghg2@andromeda.toxiclabs.cc>
Content-Language: en-US
From: Hans Holmberg <hans.holmberg@wdc.com>
In-Reply-To: <apUqKvNgd1Onghg2@andromeda.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0406.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::11) To SA6PR04MB9269.namprd04.prod.outlook.com
 (2603:10b6:806:417::19)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9269:EE_|CH4PR04MB9083:EE_
X-MS-Office365-Filtering-Correlation-Id: bae93ec3-3e1f-4bb1-8ec5-08df07f7adc4
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|19092799006|366016|23010399003|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KYuZ04OpxAQEcaJBKIOiDatwTewVV0Y2/+z3tN9/j0+RYABPsQAHsku2S1/jW3RYhueOsdEhAGpjLxKOtc3MYosDodWuQwd+qWBML1ITjRxfwb86Czl72VauHMTcqPteDVPu2kXPy+xzhp/54Nhu1+vsf2mwbfaQNymlEHXm+Ev/mS7TxB9b5aqVgljxlRZMNYAZLNXdo8reUQSAY/8u6aNBrZnlLZ4f8N/GsvCTYP9WKnozzien1WtuhlRn0GvGMmMI+7WiUOKfw5MlJsi4Vue8yqCxC1gJThj0W8NrAEe7+z0OBtiXXzrfwV489Hqo/6yVO20WEHsd9nNqbq4raiI7QYWEfmSVVqQMDxGF2xKZWd7Z2leTQ+QwwFczyWMowTbJIqkoKHtHbxi+vX/0yiNydEKl2uMw0VZA6Zl9l+h6teamNQ2F0nCVcH+xZ7RosI/czAiSpawzo1WrdpU7X38BGJOZG462FgIcw28JodZGPYIoLx1tQmnZsvn0pK2t7YnCKHnSbOd/1//YWltzFrxJPdD6F+e6tSMBpatCIv4hAZmzXW0IiexpB6PjZZ7C7n0CeTZouzq/FFGroFZj4G9ttEp0LLvjzU++qLixOEU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(19092799006)(366016)(23010399003)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXFublh0SlM2UXpiNklvL2xLZGdxZXNEVkV0dEV4MHBuRVFBZUsvejF5SDVI?=
 =?utf-8?B?SlpSdzVUalJWUkxuUjlqVGszT0grODcyYmlUUGdWcldkUUJGWkpwbkU2L0xs?=
 =?utf-8?B?M0dKNWhTVi85T1hUTFRkeVFtT3d0UU5QYTFQRzQ0alhOWWhhazE5RHowS1lu?=
 =?utf-8?B?dzZjaHVBK2lHV2NjOElwclFhOFkycm9nQ0o3OEtYcGdDeGJvb3IyMk5qUHlV?=
 =?utf-8?B?bXRuVDlNTHgzNzdvcE10NVRCL1lmSC9LZXdGSlpsbE9saXZPdkdrYkVsanZC?=
 =?utf-8?B?TVRpRHMySitDUUNkVTdPSkg0TXJYUGhaVWpXa3dMdlVGSVZTYnBlaEU0S1BV?=
 =?utf-8?B?TDNsVGoybGlnK0FZa05UZ08rZXc0czM3ZytoVjVnL2VzSWJtQVljWHhXOExm?=
 =?utf-8?B?cHVQYWFhQ3hrdm9SUTJvTWVpZUhuMzdGd3dSaFJxaHh1SjdxY0ZEVHZGb1Vi?=
 =?utf-8?B?N0hDbnM3MlEzRHo4akQ0QTZKTEpiZmpzYmk5TmI5QlJZK1ZZeDJPQ1VUZmp0?=
 =?utf-8?B?M3BVTEVLMnhoUkp6SzhxdDNzN0d1SmtVWUxxdktYUm1TYkRaRjZ3UEhlNEVQ?=
 =?utf-8?B?TkpMU2hqOFNqSnVTTjVpTmQzYWpyVmNtMTZZRHVkWUo2OXA1bkE1RFVmUmdu?=
 =?utf-8?B?N0U5VW1OZm5IejZJTm9GcnlFZElHQThUdCt3TXo5b0FaRE1kbFpXRTRNOGtC?=
 =?utf-8?B?Q1BkSUF5QVBtdi9uR2lUSEo1Q0NOdEtFT3lBVHJFSjRoelRmMkFpNjRJdm13?=
 =?utf-8?B?WEFycldoOWdsWlplSTlmcXljZGRHeGtiazd4NDZmSVpOenNUSTBqdndPREZR?=
 =?utf-8?B?c2QxME9NY3I0UXcyODAzMVNWVlY3QmxEQ1B1NFo3ZU9CVWRkZ29oL3BkUC9K?=
 =?utf-8?B?aWJvNHIvM2tUVGI5WjI2Skx5SmZKeGo4RUVnYzNTNkgrZmNCWnNVM0dlK2Vr?=
 =?utf-8?B?dFpPR1dTNUJTeEZNRmU0VytyUFdweHFxMWp0RFRqc0ZrVXNyWGRGc3VCditm?=
 =?utf-8?B?UDlmeXU2OGpCWHFIa1RMU2RndTdGM0d4cUgxOUd3dzBqT2dZQ3ZSZUgxY2Rj?=
 =?utf-8?B?d3FLOGUvUFFmUzhmQWRqUEZscDFIMFp1RmNtM0cwNnp5RXdwVjN1aWdkYXNK?=
 =?utf-8?B?eUtLZTBSaS9uS1J6N3FGWm1UNjVIUVJYcXB6OVdaT3VGaE9RWXZDVHgvRjFX?=
 =?utf-8?B?ZjRGM2JmbHZLZWZNc214MnYwcmVMYlpGV2dDZjRWYlpMTmtLQ2RtRG02bnJl?=
 =?utf-8?B?WTBXYklnbFBTTjlCOGRrRUs4QnkyYVZOWEh0V2JVcnJrejRjbkdWejVCVEp5?=
 =?utf-8?B?bGIxT1lRelh6d1VrT0x2VHF6eVFMNlBwRVdnb0xxVEp5YjdZUFlrY083L2s3?=
 =?utf-8?B?Y2M0L1IzN2pocFlHL3E3NjlzZ1NFMktPazA1SnFiemZUamVUTG5xVFFyamxy?=
 =?utf-8?B?MEh0UVo4ajFndUsrcXl3RlJMWlNYczFVNVhMZURlV2V1K1VoTXVBKzdMcWlL?=
 =?utf-8?B?ZUdwQUR3eFZHOWxSTmN2SWduam1vNDdTRUFCNWE3dG5lVGNhMC9jMzlZV3V4?=
 =?utf-8?B?TGpTOFdxZU9HTkdkZ0s4OWtIZ011VUlGKzJQc1R5OHpjR2JNSFNpR0l2SmJw?=
 =?utf-8?B?WDVDa2ZsR3JGQnhvZHQ2TGtpc0pMSXRNb3Y0QXlsczA2U1JLTGhXR01yaml2?=
 =?utf-8?B?VW44cWVZMk5xd1U4dnYvS3RVN1JlSWZnZkFocXJTL2dHd1pyZCtRVGxsZmNX?=
 =?utf-8?B?RFpsd284MFdSNEZTRUx4bUdyL2MzKy82RCsrc2trN0RHS2VFS1VKSmlGQTUy?=
 =?utf-8?B?NnBaSjNLbEFtSXE3dUlNK3BkMzdjcGpzR1g1dmlQbjU3cmNKTGhmVW9yWFh2?=
 =?utf-8?B?dVE3M2xLL3pZdWlRdnQzc2djUjdTYzJTMkxXZGRvSkhRTmQybGx6bGJybTlO?=
 =?utf-8?B?bmR0eEdOUXNod2ZmY1JUSlY1R2RWM2lDLzRVbU5MVHN6ditBR0Z5ZUVGUDNi?=
 =?utf-8?B?TzFtTE9wTnI1b3ZJRTMwbzNYSXRUQnU3cTVCWElGYk9yRTdELzNxT0xJM1VM?=
 =?utf-8?B?d1RhdzhpUGVuYU1RV3hybGI5Kzh3VFZrS2Fici8vUS8zWWVjVUtQZTR5RHhk?=
 =?utf-8?B?c09KcTVjM0hKVzZ1ekFEenM3V3huTnJ6WTNsc2FWSmxsbEdpK3JUOVV4UWli?=
 =?utf-8?B?NnlacUNvakRRMXJkRUZlcThIaXRpN1NTa2toODlyb1dvVllwMjJOZkxuVUV6?=
 =?utf-8?B?N3VzaE9kK1ZZYlB6UEZsUWFGb3U2S1N4NDBqc050NCtQNk1HSjJXNGdXZlZQ?=
 =?utf-8?B?TEZXTS9sYnBRZ3F4TldZOWpZU0Zodmk5eVNxVjl2Y3k1SHdqWldKUT09?=
X-Exchange-RoutingPolicyChecked:
	BwkC2FZqDeHNiRHhnqeSjyPfuo3TgnmTq9PPj8kzuuJhkiZYS6TrjxvzB3uQNQoJRUCtSSr8kua5dbu6N8SH6sXxOfqJZwyPmVQV9XtwIG2vpDYs4sRnFsZKz+lWVhfesVszXsFM+XU8wOmUMG74u5CjTzfYJQgTDpj8AIHxrXj2UiryfJY4Ufq4yUpHkXEkaRtkuUyo0S7t8kvE2Gj2UW3sK0HG1gjp7Lx4J0l0zPNTj5yw3aFIZEDTqYvnUIBAhnJOa1Cy4Ug40Q2rU8Sm4FBmEAoTsfcjflli/iHw/5a2P0YiV5L3E96VQWQz9SSe+J1q3XZOTXmEWG415MLF8g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LckfaRih1K1DbumrIvQHW6SAbYfH6qWjrvve6s1jFrwtBMpxo+6YtRm75x+TsT3MhGUFYqd3qgtl32qvpWZFg/sLQoxkvW/2Es7qsMDs5QqaFUq17Uq+SKUrs2cDgBD7Li4oiNY174eOs0k+32AjsRJ/9pZQ0ddq2zlUXNWfqeL5SbuF+2ObXadoYZGBno9xKzhAkoM7ONxAqN2WuGj3OmR5a2iTag5aSKuNDvnA5DjHEP2S1+PK4/4lur4YJB33xBxFVqoFa3IL58kw8endAxZ18hPE+8GWRq0DY5eWbavGkErA6fiD7FicfpkhdwbgJGkpHZuJGmCamL+c9HEZ3HuyOAgWX6H3gWtfuaMkr39vOCTWSVv1s3KMApi1G4Rsv/du+CnKRQElCR0c0hZkjwpLF8g8KbvWmEqVNHriDvP0CAvEGGbZosZ3u4zz5+Limzk4HsOCS+Gcx2HzOQPB9TXO5+YksL6SrB7JdCTJUp3JramPruR+7GhFLWMoASdH+bIGTKTfyiBUW+Ov3sATFc+5k1SeyGfrKPkSYRn9J65xyc7MYKdi3vQi3GFajRkR2OfXFsgxuPVoLQ7bBd3LPl5tE8kAMk1i9L5UJvje6BMR388mA7r34pOmpTj6BUXU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bae93ec3-3e1f-4bb1-8ec5-08df07f7adc4
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 07:07:26.5693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8xKfY+7lo1bH50X+iHH3+A61VmmkBltxBq+OWlyqJS/qy3UipEDX2ihekric4YJxN74dgFgyXDVs/yHg7BOag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9083

On 31/08/2026 09:19, Carlos Maiolino wrote:
> On Wed, Aug 26, 2026 at 02:32:19PM +0200, Hans Holmberg wrote:
>> xfs_zoned_add_available() checks whether the reservation list is empty
>> before adding blocks to the available-space counter.  This check is not
>> serialized against a task adding itself to the reservation list however.
>>
>> This allows the space provider to observe an empty list, after which a
>> reserver can enqueue itself and retry the counter before the new space is
>> added.  The provider then adds the space and returns without waking the
>> now-eligible reserver, leaving it asleep until GC or another event
>> provides a wakeup, potentially adding seconds to max write latency.
>>
>> Take the reservation lock before updating the counter and checking the
>> list.  Use list_empty() because the list is now inspected under its lock.
>>
>> Taking a per-mount lock when handing back space is far from ideal, but
>> benchmarking with null_blk showed no measurable performance regression.
>>
>> Fixes: 0bb2193056b5 ("xfs: add support for zoned space reservations")
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Closes: https://sashiko.dev/#/patchset/20260609075655.1698743-1-hch@lst.de?part=2
>> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
>> ---
>>  fs/xfs/xfs_zone_space_resv.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
>> index 5c6e6ef627e4..7aa3c74fb2e0 100644
>> --- a/fs/xfs/xfs_zone_space_resv.c
>> +++ b/fs/xfs/xfs_zone_space_resv.c
>> @@ -85,13 +85,13 @@ xfs_zoned_add_available(
>>  	struct xfs_zone_info		*zi = mp->m_zone_info;
>>  	struct xfs_zone_reservation	*reservation;
>>  
>> -	if (list_empty_careful(&zi->zi_reclaim_reservations)) {
>> -		xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
>> +	spin_lock(&zi->zi_reservation_lock);
>> +	xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
>> +	if (list_empty(&zi->zi_reclaim_reservations)) {
>> +		spin_unlock(&zi->zi_reservation_lock);
>>  		return;
>>  	}
>>  
>> -	spin_lock(&zi->zi_reservation_lock);
>> -	xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
>>  	count_fsb = xfs_sum_freecounter(mp, XC_FREE_RTAVAILABLE);
>>  	list_for_each_entry(reservation, &zi->zi_reclaim_reservations, entry) {
>>  		if (reservation->count_fsb > count_fsb)
> 
> Looks good to me:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> FWIW, don't xfs_zoned_reserve_available() might have a similar problem
> when decreasing the free counter? I'm not that much literate on zoned,
> but a quick look seemed reserving space might hit a similar problem?!
> 

It's a good question, in xfs_zoned_reserve_available, a writer could
theoretically race and skip ahead of another writer that was lining up
to wait for available space.

So while xfs_zoned_reserve_available is not guaranteed to be 100% fair,
I think the alternative (adding the lock on the reserve path) is too costly. 


