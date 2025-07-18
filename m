Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazolkn19010020.outbound.protection.outlook.com [52.103.33.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A81E2DAFA2;
	Fri, 18 Jul 2025 12:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.33.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752842614; cv=fail; b=elAofXndB8XTqhCGyyz8xQ8XPk+qZ34D2ZbxhjP5agi2HtW/wyMChVsmjVrzAduh8gyPveP1wITaw0uNr24XDHlYKYUPVOrrK3Gnun/NkXuBohxEWxER9lmVJO8wopy5/dCf3SSLhNbvmN4Bk+y6kwBQWAtEkdYssen6mm6dX1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752842614; c=relaxed/simple;
	bh=k+Gv8zekvmHWysgDC0732lLUJLAyqDvFpWAZ76CpbI4=;
	h=Message-ID:Date:To:Cc:From:Subject:Content-Type:MIME-Version; b=HZQ3oyxUIaBFwPQKaKQp1NChe/7atJVW0Y/qjCuUIJR+dSWf55PdJJhkOHMy44ADsGWL2kP8d0jlMFO7S9yv07nfIeE2M8CaULmEaeaaSyjA3FymNuwvfDhLnnDzgr7r1euCUVY5fUMVVRhjHS7Bo5wFcOcC4NQyGF+oklhoEuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=dxNhHpry; arc=fail smtp.client-ip=52.103.33.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="dxNhHpry"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nu3k7d1y+NvIOyTbnFz6z/1AFsAq46eR4mK9+wbt1+pOYXB4faLxek7GHG8zhi0SGaS2cbXlw4kkltWMfx15YTun1CZZj0omWLwvIU99+72mBrq3RC0FvqTUaX/rBc33mcZ463abBKTnZxb9UcTEmj12U0bVjq/Mq4UPncTxVlhaVlawcTyXs3IxhTLcY1bgAma29D7SW0vvEqHwVFHDM+qpc86a9Ji/hA0I2awz97QQndtemL3CPot9CaC2j770OX1EScic6iKTgN24ny5tI/N7DGP5zmZJy87nze3clMruGyk4OlxVjklr9PrEYpZkixHg3G7yeRwgUoIPlWo9Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+Gv8zekvmHWysgDC0732lLUJLAyqDvFpWAZ76CpbI4=;
 b=GSe4N68ruAdUKdeGtpt5xCmklgg1zxosodlbmOXtW/faBgQdg6mRLDZ1UZEjErw2aJqPYIiFLYmSo9hkSE2tdIw6BOenIVsjH5kxKZ1TTEqrgUgVOXGZomnhWKRgVrA5ruW+rmwDcXg4jxLcwaQ99XdeiKlLLXBHjwMolqx+IbsdA5HPEviWyUfCXNAZnIKqGJa8hEAVLk/xirP5SN3ErWlF5IqkX/EhK4l4rOl69W+fiHqpEciLQSTrv8hs/6JKGFoeRPJWIOr3ECywEA2l33A8kdAs5umR484t7V8kh+/osJ8eMu1FpzbqmTG2YOt3zZR+myZ9KuOJFKAe7DIwUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+Gv8zekvmHWysgDC0732lLUJLAyqDvFpWAZ76CpbI4=;
 b=dxNhHpryVfzcxGPKY+1L5akkU0iDcIabVbnP7HYNBvb9ER3pZElqVLDtlFhTJXuABC30FH1UUwAOfBrpjNhY9FtMEpJZhgO91EZu+pX4+VdnlIsTXdK7T+jTUdUi0CYzlfh0uKmw+WJR8A11E5mizX+ljCUnv6+kx3NWYOzuvhjDnJxn03arFARWtlgCcqOxP2EVQj447Nlefyz7/DGwg5rjYnJNGmMa+A8gRwBNl0maPdBQEH7cLbTd3oIr1NCh28fldsSNEpuifJJfxip1e62GZewgqmAktqCSVpogz1gQ6uM+SfwlujfL5ZnBoAQ22I4DsbDuBGegmwl+KZoUhg==
Received: from DB6PR07MB3142.eurprd07.prod.outlook.com (2603:10a6:6:20::13) by
 AM7PR07MB6914.eurprd07.prod.outlook.com (2603:10a6:20b:1c1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.39; Fri, 18 Jul 2025 12:43:29 +0000
Received: from DB6PR07MB3142.eurprd07.prod.outlook.com
 ([fe80::48b6:9e2b:c22d:1607]) by DB6PR07MB3142.eurprd07.prod.outlook.com
 ([fe80::48b6:9e2b:c22d:1607%4]) with mapi id 15.20.8922.037; Fri, 18 Jul 2025
 12:43:29 +0000
Message-ID:
 <DB6PR07MB314253A24F94DAA65E0CD5D9BB50A@DB6PR07MB3142.eurprd07.prod.outlook.com>
Date: Fri, 18 Jul 2025 17:43:24 +0500
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
From: or10n-cli <muhammad.ahmed.27@hotmail.com>
Subject: [PATCH] agheader: remove inappropriate use of -ENOSYS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX1P273CA0012.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:21::17) To DB6PR07MB3142.eurprd07.prod.outlook.com
 (2603:10a6:6:20::13)
X-Microsoft-Original-Message-ID:
 <182ab2dd-0eb5-4c4b-a49a-edd53d6ba87e@hotmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB6PR07MB3142:EE_|AM7PR07MB6914:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a60625f-6149-4810-dc0b-08ddc5f8b276
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5062599005|6090799003|15080799012|37102599003|461199028|5072599009|40105399003|440099028|3412199025|26104999006;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ajJET2pMV21pRUVVcFBTMm53Mnd1dkQ0Z0IvWGRsZlpxTUk3M3RJTWIyOW1o?=
 =?utf-8?B?R3UyeDNaL0x2NUprTkpzbFJrT0pyZzRnRVZpODhNQzd1dXpGNEpRVlVGS1F6?=
 =?utf-8?B?T3o4bmRtM2pOdG50cU1xck52NDc3SjNVVlMyeUhwTXljL1hBOHNZeEJadW9P?=
 =?utf-8?B?TkZQampNZThHbUh4Mmt5cm5HUjlHSlBFQmxCTGxlWG0xWDlzZkNFRlB6ZDhU?=
 =?utf-8?B?dmZVRysrSFRTSmJ3eWJwdGFnWi9qMjRCaHVNR1B6aUZhVnZsYkdlOFZOT0Zi?=
 =?utf-8?B?U3JsR2ROWU8vblFNOThjNG1XamljT3BqTkhrUy83MEVLZDZUbzVTYnFWRFB6?=
 =?utf-8?B?YlFZR2xIc2ZDWmxzajdzbXl1dHZOcTJhUVo5ZFZHQlEySUdPM3E4ZmhaT045?=
 =?utf-8?B?cXBVS05jQThBd2N1ck5IU2tYOWIyNGcrSlE0K3pSRzFCVUFLZEFMUGN3elZO?=
 =?utf-8?B?YzY0ZDBMZDBSSDFDSVpjeC9DdUxsYlV0WTZJeWRCVm4yQkJ5SXZ1d1RvaUNo?=
 =?utf-8?B?Mis3empQMlRjdG4yS01kbWxrMDFUWmpwNUhJY3A3a0ZGZlJqbGxlN3Q0TDVv?=
 =?utf-8?B?SlpHOGxTUyt4ZG90ZXR0NmpmQTNtNGtRR3hERkRScmJjOEs2RlJzMEUybVJY?=
 =?utf-8?B?TEZ1K3hGQ1QvdUw2OEMxUWJqVnZiKyswOERmRUZyRkwyZUxONFhiUnNGUHBN?=
 =?utf-8?B?UXErelFVWEpSMUZzZXdjUXZJd25CamFKVmQ0MWs3VFN0QkxmQWQ0em1yTUIr?=
 =?utf-8?B?K09zd3luMXJWNGNHY2VtMzNVSTFvWWxnSVBYOU51dFBUQ0dTeTBFQ2U0YkNq?=
 =?utf-8?B?Z2F2b0c1czVBbFhIODJHL21GTFE2bHZMOUE4Ly9HR3hvRVJSMEZScDR3L1Bn?=
 =?utf-8?B?UVB3RXZPV2JsbG91Z1RlQlhlbEc1NHZxK080cHY3SE1lZDhZd0krbHlZS3Z3?=
 =?utf-8?B?TXF3aGVmQWtxdlFELzM4cG0xYXpVZ3hjQ3BnZWhiSDhIOGFTTHBHT1BOclBl?=
 =?utf-8?B?eW9xYmNSRVZFWmFESGQxZTI2V0ZoZHgzN0hYeFZyTlhLQUxXdEFqbmcvb0s5?=
 =?utf-8?B?bGNkT2ljOWJJZXJ5WG1USEpGZy9vUHoyRUM5OXFEZWRoYTZjZHZFNzNVME52?=
 =?utf-8?B?R2Nad3ZkNi8yaTZxWWVzRHdya3NicWpVZWdEa1c4MmgrR1pSRE1EZ2w5YlVO?=
 =?utf-8?B?WmNIK21rczlpQXk0T3YwVFJ1V2pCdFZaL1FLSjA5Znp3Q3BJVy9CTVhmaVJF?=
 =?utf-8?B?YWhNV0dFQzhKcDRTQTRrU2NNbng2Nlgrb2ZnSEVDclBQeVlGUlpkSlpjUFIr?=
 =?utf-8?B?VnNVQ0NUWXFmUUE0Yk5aS2lzT2NGVlgzSEtPeis3SzZ5WDJjTjg0TFVLYXZ3?=
 =?utf-8?B?QXhPR3B2STh1VUxUejVPSHR1SGdiMHF1QjdrQUFDMDg5a2laVUs2QjNQcThE?=
 =?utf-8?B?MHo2VGxBWGdtNUFHQW94YkFWTElHOUlXb1BydVNIQ21JTXJ1a09PYklyTXVo?=
 =?utf-8?B?MDQvZGIrRXQzR3o0RlRidnhZWnZmOU01b0lBeWUvTjBHekxWZFpsR2lhVDF3?=
 =?utf-8?Q?uSE1fWD5NTxPvlmI+NC7Buhds=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3djSjh0bXp4bmNPNERMaDZRN2pWdE1lMFRodGJmQ2REdm80bDdqQTdJU2Np?=
 =?utf-8?B?TlQ5aTlJejVMaTlVa1h5bHhsTTVZMU40ZDJUblBoU0xFejVQVHJXTE9oK3VD?=
 =?utf-8?B?MVJ3V2dOc01qcnh3WUlkYUZ0TVJmQjBzdVc1MlFxKzhRS2M0eHBFWko5S3pq?=
 =?utf-8?B?eTVlUyttOGFTWUFMblJTbFdCUWI4b3VqL05iSWF6MGQwQmFGTHVsdENsam5k?=
 =?utf-8?B?KzhxV3dKeXQvSU8xUEt2Y2tUTFVsbnkyQTZzZytYV1ltNVAvTEtJd0s5YzJ1?=
 =?utf-8?B?S1EyK0lvMHRibnFCNUdLVm1kUHZXTWY1MzdhMnBYMG5SU1F4TW9iUE53QVFB?=
 =?utf-8?B?ZmlMV05VVWlnZ3NlaVUwSmlUVldySzJtOE53azBNZHhuWWpjNVc1ajhVdUd2?=
 =?utf-8?B?VTRFdytiUHpWRU1lL1FJQWFMMnhLeEgvMWxzV1JXNzlVWjFJbXhDZ2g5bU1t?=
 =?utf-8?B?TzBtOHQ3ajBqSHdvaVBxb05uSVBRVGNjc3RiRXY1VmhvZHl0R2VITlRUWHhX?=
 =?utf-8?B?bitLUjRQYU53WkJsODFBSkovTXhzWVlhb3NiWEVCNzNmd0RILy9zRlVHampC?=
 =?utf-8?B?NCtHVHA1QTZCSHlReTdINTZ2VUk3aWdjMithaWdUMk1FU3Jzc2JJS2haRmp0?=
 =?utf-8?B?K25sWWJHcSt5Zjk5VmhPYzBZaFpqRktTVkxibWJJemNWK05kMit3UlFrNGVj?=
 =?utf-8?B?cWpSbHM0Z2NpZHd4bC9VbkM1Skh6eXpsVFdDYnJRbVcvdDYyNmtNUnI3eEow?=
 =?utf-8?B?R1FjTnZ2amxRc2t6dEZnWGhFSjVqSExrc0dXcWxqS1lxYWhhYWltQS8ybFBF?=
 =?utf-8?B?bHpBdlBSa2Z3Z3B5SFBvdDZxN3VGeUtWSjdibEdyck9TbTc1WDdOUTM4YVhB?=
 =?utf-8?B?R1pnRHFMM3cwK1JwSkpqK0N3aWhGMzFoYjk0V3M4LzhLejNUaUV3VmN1QWhu?=
 =?utf-8?B?UXdmMVQ0K25oTmFvbFRiSVQwWVdMTWxtWlJKdXJjZ0xUc095cDl4bEFXLzA3?=
 =?utf-8?B?clhzWlpqamtwNG9TemZTWDUwb3VpVGM3MFFtb3VZMHJmbkJLeS8vT3NwMmhL?=
 =?utf-8?B?aWlFUG5ycmZoQWsyZ0RoTHAyRlV3VU9Oci8xdGoyNjRtQ0t4Mmw0aWpwMkxE?=
 =?utf-8?B?UUtoTzBXcFBQY0ZjRGRPemp2L0pQckkxd3hOY2NoOU91aVhSWEVRbEUvNi9w?=
 =?utf-8?B?REMrV0YyYWo3M2IxLy8zaFJCVk9LZFp1eE5aWVRuaWFJQTdFRkpwRmk0d3Z5?=
 =?utf-8?B?WEk1MjJCcXRkQ3lyTWZiWERyclBzekJHaHRUUDhqTzJ1YTNBcXN5VW1CNjV6?=
 =?utf-8?B?bjkraGhPVDNLd1NxbXZHQkZZWVF6d2c1UitJeG9xV2NtV1V3WkNEYVNXU2pW?=
 =?utf-8?B?d1dna01GejBhTElReVI0VFVrN3k5dlpFcTFPRzBvMlhvWFp2MUpkWXpGb0ZB?=
 =?utf-8?B?Y0tSdkZ2a3NtMGp2TkUvU3ZjditiZjA1TWFZNzNVdWF5Z29wbStCQ0c2SVZ1?=
 =?utf-8?B?YnF2bDRFTXpKK0tZWENQWEhFbzFNY3k0Z3ViLzltYXRvMWMyWlNBMUJGYm41?=
 =?utf-8?B?c2I3Z1NoVFlrMzFrNmhVS0ZuVnlzWUMwc0hMQVMyZGQwczcwT3pJWXJ6SFNt?=
 =?utf-8?B?T3BFOUtneGQ0U2hzNVdBOUpQaC9IV2JDY1JxVVE0UzVoRjZtanBaR3o5Q3Uw?=
 =?utf-8?B?VkgweXRzMW5hWEx4NVo4UTVZRFUySmJvVmRtNzY4NFc4YVFQL0JWS3dBPT0=?=
X-OriginatorOrg: sct-15-20-8534-9-msonline-outlook-caca8.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a60625f-6149-4810-dc0b-08ddc5f8b276
X-MS-Exchange-CrossTenant-AuthSource: DB6PR07MB3142.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 12:43:29.6858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR07MB6914

 From 8b4f1f86101f2bf47a90a56321259d32d7fe55eb Mon Sep 17 00:00:00 2001
From: or10n-cli <muhammad.ahmed.27@hotmail.com>
Date: Fri, 18 Jul 2025 16:24:10 +0500
Subject: [PATCH] agheader: remove inappropriate use of -ENOSYS

The ENOSYS error code should only be used to indicate an invalid
system call number. Its usage in this context is misleading and
has been removed to align with kernel error code semantics.

Signed-off-by: my.user <my.mail@hotmail.com>
---
  fs/xfs/scrub/agheader.c | 1 -
  1 file changed, 1 deletion(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 303374df44bd..743e0584b75d 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -134,7 +134,6 @@ xchk_superblock(
          */
         switch (error) {
         case -EINVAL:   /* also -EWRONGFS */
-       case -ENOSYS:
         case -EFBIG:
                 error = -EFSCORRUPTED;
                 fallthrough;
--
2.47.2

