Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7564D383BE
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2024 18:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706208161; cv=fail; b=CG7Bh0XflZyiQv0b1VuiQgS65RMgj4H6ux1guLk5nkCOeMYBkyXbxtLtE5+4Ndd01n5OCXgJa5yokKe0LCHdRsVPG8SeeFHboOE/RUX6FsGdfa/OaeR3pz/YqPI4SG8HDnGau7HxSg0nmTIvf1f38US74eKmzZCP2iBBD/f46LY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706208161; c=relaxed/simple;
	bh=zrsuFN0bv+KzoF+W82yuGpGslkqNrrbKiRZf4EQpk5Q=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cYr7aub+fU4eipcWfyu6SrT7aDQIBGhVUy5CSTrAAvML+lqc+9lZnWRby6msg20QaEg6ew1X3J2lO4eqfIK2GCK2oc1S1E4ZhqqSOMPEwBRgN2CbWOESKq5jlsOD59+MFLtHy0KCP9NIk+0YAik1INfUTUH5v8TAjskFetjjdt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NcaO9GKO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ynJmQwJU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NcaO9GKO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ynJmQwJU"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40PGqQnr011467
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2024 18:42:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=zrsuFN0bv+KzoF+W82yuGpGslkqNrrbKiRZf4EQpk5Q=;
 b=NcaO9GKONWzYLrln4YQ37vXey0fJsthv53wqlVdzXRdy8DRMoJv6znM+0c6aoLKhXiKB
 vWoSD36fvc34x01o984FbxBojVV14YfOBeU5B3CwEu6mzf7vAkuhyZBw0C1jLSaa2Gv+
 SZnwieNSO09jBKnveh8/ts1KPqERbSbEvCPAYlAESm8YQjQ4xo6ch8v/mRxYXL/3intq
 Mjqvo/CFJJLlSW4ZkTL9ocWKGTfHz2WheZdWo+ZTKC1M2al+ayvaUHMHb+VtJWUW5kuE
 7tVdXsm5PKBDspIM0YSGhMxW1eCMa2tyEH+dS/X/TO2A/45XlPM9+xhZ9ihls+PXFXPT qA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cuywxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2024 18:42:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40PHhRnr029780
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2024 18:42:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs33x563k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2024 18:42:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYzjltb06aCFI57p948NUTZPjqvc7kIXL3tZC8rUxn0cqzX/GLttoIcifzpQnXTRl/VwZDcp7Prr0zjZWU5B03jMYFcW6NSaQJUsmfYH6kNaiWqM8ZcHZPvd3JBsa/kv6StQ1uv+RafJtk+SgzqnezPAeqTn3yA8rTbTdFan8M1tUtmzr1DCOQfJrIxTCPVyJM7fRhBiwkfCHAoln1ktcZUNux8u6Jk9dj6T3z4/9ngh9+V94sG9ixf2ju/7lwWrY0cQklu9OT4qvCnbfHwn6rM+vUZMWyYXtKa8fzODLdU2Oyc7u7I0CTg+8PMRletl6iMiE5T4wsvApUh52wLElA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zrsuFN0bv+KzoF+W82yuGpGslkqNrrbKiRZf4EQpk5Q=;
 b=k78Lc4VQCCgUst+2u6IanrrkWLymVikXYn/WzjTojGxuseGwpmPM2FlWH6knBDBigmE9iFztEmWUflyLILPhb9bbnF268B4ITCdwM7rst+i9qeQuuaXGgLN3EtEajND+OcB/B9VR/GBDJvnq/KMPrwktjsACCxvwT2X72lHwBqdvrSjeMVbLjPqtlPPwNay/f94OYTj0wDRHsq5V+zQHZmg/qHQ8VeesliWd3znbPA1Sw/+JKyi+tWueHAUFlUjxRRIP5CQOR4OaQBUbQgwwMsIU4y133trFzHBMJknIOofImxEEWOA2U8yfKiqyWGeNrOQiUpvTI9xyLY38vHtM1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrsuFN0bv+KzoF+W82yuGpGslkqNrrbKiRZf4EQpk5Q=;
 b=ynJmQwJUPsP/+v7i/xeqFStOb1jUkLTCNHN4676DNaohO5eXkx1N4zey4M8oTanoN8U38aNN9sSCi2XISwAuskxOMNSAWoWgU3WVaAVOcznur2vioNLDXuTSUjULwABKVwRDj/AG4BL3Aodcu6cE8qTHjhsCGvbClXBfAYOkHT0=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Thu, 25 Jan
 2024 18:42:35 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::d44b:1007:597e:841a]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::d44b:1007:597e:841a%5]) with mapi id 15.20.7228.026; Thu, 25 Jan 2024
 18:42:35 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] Introduce non-exclusive defrag to spaceman
Thread-Topic: [PATCH 0/2] Introduce non-exclusive defrag to spaceman
Thread-Index: AQHaRLUvNGq6jP/6GUCRSsAWwysJOLDq8xCA
Date: Thu, 25 Jan 2024 18:42:35 +0000
Message-ID: <3092B1ED-AA18-49C3-8A74-9AE1416A262D@oracle.com>
References: <20240111173949.50472-1-wen.gang.wang@oracle.com>
In-Reply-To: <20240111173949.50472-1-wen.gang.wang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|DS7PR10MB5005:EE_
x-ms-office365-filtering-correlation-id: a7a6f0a0-c159-4a80-5089-08dc1dd565ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 CzSO0oF66nBKI57Sny7nE58OLew0fw1rTSnEPsf+rAx065BS4aXJPVaU1sCqcq/ZXCceEiE8NJ43C49P99Uk8uNKzcPqY4y36SKbwhGIzucNnAN1GqkGx9ASdhB7J/ZeZFrKl1tbRUz8qMBndj1U1hOKQZJks2TdaPkZVuOygB4fWbblqJdQXLG+JTbjwyiTlC7REfWuRplT6BaGXUL4UOn17yjwJRKChVY5G5aQjaXqQMnKbBPioJ82T7nMj1M6DkC7MgFh4Tqq9+dLCnHfFJXrNl1acog+OgGx8Dg/GqsMKJmxK2vPWnzeJNi54/pdmX4VZNB/bztujEIbBXq1BQgIFseuLREqXsg6bjyj/xr4pUtV7pSDBkt57KhOgYVIzGtDbjZzeEixFMgM1dtIBkkNfZ4iv2behYgx5mDCmpqIU/HGp3PC+iaPVnuhpR4JxG+4C3tjnbvvi2i09HLGJAe9YX1lMuPjyjTAHg/A2PIHa6NrEly7gvf5A986B93eSBiOyzRRMwdzonjUQ9gdn4CSp647oMDLfWSgi36NJ759TexxCM8U3LV8SBMYbVF+8iEa2MAwx/8WjRAuIZljSzX6Lx83TCIxwHonLhvW349rxSPX4LCOoAnC+tMC20qk6A+zgIQXSIdyZCaD89erRQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(376002)(39860400002)(366004)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(38070700009)(83380400001)(5660300002)(8676002)(2616005)(76116006)(6506007)(316002)(6916009)(64756008)(66556008)(53546011)(66476007)(71200400001)(66946007)(6512007)(478600001)(8936002)(66446008)(6486002)(26005)(122000001)(38100700002)(33656002)(4744005)(86362001)(41300700001)(36756003)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?NEVHZkVSSVNPaFQ3Z2FnN3RsVEI2dGVhNFNXY043akhKR0pRWThFOVl0eE43?=
 =?utf-8?B?OWRSL0EwcGpBSUU1UVU3ZVFFQm4xc0tTQ2c1YVdLNUJSazl3dWkvOGIxb09K?=
 =?utf-8?B?VEpDa2kwWTR6UFBXbDF6YThnYWNucmdrdm5PbTNjOWVkQUM2Y1Juangyckxx?=
 =?utf-8?B?YzUyNmhEeWJQeVVLUGMrMTBqZU1XVlhXVWZGNzlnN1hwQ0tqZFRLK1VxeTlD?=
 =?utf-8?B?YWJzSGJaWmhGd2VHZ01TUlRHcWxwQ2NCMzZSR1M0ZGNhYVF5K2IzbDlGZlU5?=
 =?utf-8?B?VEZSZW9NYi9DUWw4S0YvWWlvUExPRklIMVplSDBkUWNNbnlXYjhlTkhuc25h?=
 =?utf-8?B?VWRTaDAwdDJuWXlvOStYVG81V09iN0lqVGQvRkVEWDlWVjBhWmFSUFhoTnhn?=
 =?utf-8?B?Q1FpYWwwa2RBaHNZaWZIM3dIQ0V2Vk5xMkFSUitHVG90WjZaTC83L3QyYjNR?=
 =?utf-8?B?ODlobmJXTHpRL3VPeTFWUW4rSW9qMnUxZ1lMemdkQmtHVXllZFBNMFJzbVVE?=
 =?utf-8?B?anlYZ0c4bk9YK2x4UmpMRjVXTWVpa0t5WHRzSk5QaHV4TkI0Yzh6RHQvUXRH?=
 =?utf-8?B?Q1hrYWRFYkVoTEYzU1F3UUN3SERrbmFCYlRIM015VXllZ1QreU1wSmd5UlBQ?=
 =?utf-8?B?NWJ4QXNFcWo4enVmWGlQWmJMOXV2Vk5NQTRMdU1DWTlLMDYzTk5IWE5vMTVq?=
 =?utf-8?B?ZkhOODRhSFVPblhRYTZVUFVTbnc3Yk5BTm1WR2ZkcDRSYXpRUkJwVnozMzVY?=
 =?utf-8?B?Tm5YR0ZFRzg1d1Z1ZVpOTUtWMEdUOThDN1h0NWFoaTB0elZxM0FxMTJMNk5v?=
 =?utf-8?B?Yjh4NEpZbkFzenk4WDFVN3ZIOUg0a2EvUG9rWDZJTnRoV1F4OWVoL1NIc0Iv?=
 =?utf-8?B?UHEwTVhnU1FKNUhpN2NRV1A3MGQyMGJ2N0R0ZkplbnYvVWMyeVdFOVJyNzhq?=
 =?utf-8?B?ZHpOUU9Ta0d5b2dlUHFmMlJLQ2VUN2RoL3JLVG51N2s2TE5VWVlhZWV5VjJw?=
 =?utf-8?B?NzVXNyt1czNjbkVobnJ1MWMrdFo4aUtraEZyWmFuUVJZVDc3eWxGSitnT1hP?=
 =?utf-8?B?RENSOTYwMXRaZnU0djRBNXpqWkRNWVhIdDdDTUNhbUplR0NEVW4zRDlnNE9D?=
 =?utf-8?B?U0tIUFN3QUlacDZYbHhwb1JIMG5HZS9kRlAyYWI5SHRjWEpYSWRUeDlwNmFt?=
 =?utf-8?B?U2FwbjAvWkJzaGQzeTFWakdrVEkzekxBS3plbUwrek9rSzdGUFZEY1pJMHVi?=
 =?utf-8?B?M3hnWFBENk1SMHBlNkZGWnVTakJMYjJseVhEYUJFZVBramtIVFdnbDVmeHZS?=
 =?utf-8?B?aVBGeXRwem5KWk1lZGEvQ0V3ZUxlNW82ZnJpY1JtaUJlSGplNzVwUUNIM0cy?=
 =?utf-8?B?TGNxN08xd0wrWXB5VS85OTk5R0cyNUpBcTVKTkRHSW1kNDRFWTF2QngzMXRX?=
 =?utf-8?B?Yjh5ZHF5M2haRmZQaVlCaXFEZ2V2dUhCY0pMWmN5d0h2MytnSjhuUzhzUVpy?=
 =?utf-8?B?aHh2dlNscEFLUXFESHBZMFZZSTFFREZHTWtzOXNPNXJuK2NIbU85MzgvQU5U?=
 =?utf-8?B?M09SODd4ZEtxMk02azdUYTh0R1h0V3hoUVBzbG5FbHNIMTFpeTM1QllDaG1V?=
 =?utf-8?B?VHo1QUMwQXhuQXdzOEEyY2lXWnZ0cGRUK084SW5jQ1RLL1RadGVSczd3djdu?=
 =?utf-8?B?UXhpVThtb0w0Vk9JYWtiZWd3N0pVWGVmOXVqUC91VkJvUTZ1Q0RUTFJHVHBp?=
 =?utf-8?B?VG83RHdOMUMzWVNSb3ptR1I0a1IzU3ZsbitERnVhbW83OFlDREU5d3lTMVBt?=
 =?utf-8?B?UE1XVk96OEhVam8zWENaRnM2ellTZGpLbGxYZ3FTblEwWlNTTG5wbE9TU0NU?=
 =?utf-8?B?SFJkdWtzZU5xS3BKTDNzYkRTNTk5SHQwbkpycVF5czhPNGRGMHlubUVCVmZY?=
 =?utf-8?B?dzREUlNmVlJCdG9YLzNZLzF6aXhtcWNxSTJiT1dKVENveWNsZ3VZaktNNllY?=
 =?utf-8?B?YlZjaFZKMkRaL3NVOHFWZUZPNzZpeUN2ZzlnZmpISTdjaU9Odit1TkpYMjk2?=
 =?utf-8?B?VEdVbHRuTkh5aVh6V1lBRUlibVdmbEdWSFo2UXkwazFDZzJGb2habEJ3UnpK?=
 =?utf-8?B?QXJ2WFNPRzdtYzluL2lCenQvNFUwcGVubVcrWXR1V2Q4VXdVQ3RnUDRkVEtV?=
 =?utf-8?B?ckE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96205468AD368A43A639299091BA359F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Z3ptreoSwNqHWUdY84JC3UVwNF1TP2OJAqrcGX7D8SSNsV/G5qw9HKltWsswB3lh2lyErMwafpbY0BaDhG301I0ynmZJUpdQIWQSIHQHSQRX56JVInVIMc5K9KYjZ9i78SywNy94Pk+nU++teO9pBbMptG+2LwBSZaAwjdpV/uCIUxjZOlMZm/0KZ1sAcmDYbf0E6YevitBZfpLqVf8uGD8/dluknQx7NfZZWjWSi/Mej1klq3VtFd0jR+KRj9DSSGgYWcJV5NlSnGEgBvxPY5jl6g9cWpX/DuWkiIYri97ExnvMk7tzJvnGxWKCeJI/70Nj+UDDOYs8w0fdpPrH92AXfOWwfoyfv5vWSio4N/7oL/Jxin9w7ync5hq5TOGilX1aCkLeO0D7cWS1UqIPnmueO3qCUt9C/7dnKmaTB6Bg6YQ+h67LXGEOKsSO/vi7te63hcIPUyO7pl5lKb3zHDm50HCB1h5kla6XoFaB7i29j6Yy+UjiJMyIAyIFD626x292BOIo7bUxs3OY6s/M/OhQDHOuIYapFTa+aMyr2WrdNZhSG6ZCqCBb8kv1Zo757OVDWn/G2DuWEi3cZs19clf/KMzsTogEwzyKxtmW4xk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a6f0a0-c159-4a80-5089-08dc1dd565ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2024 18:42:35.5921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xir/sPv1jnQBmsEUufHME69Ogs7YX6S/TyMl9LoFQ4uOrVYtoGAf4mBUbpg9WIVZS9xIt4oKxR2+VJxAnkzZRFdH7bx4grPSZeTW97rtk20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_12,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401250134
X-Proofpoint-ORIG-GUID: k-ZHwrgyuS2NYjPGu2SFAB1xZstav-Du
X-Proofpoint-GUID: k-ZHwrgyuS2NYjPGu2SFAB1xZstav-Du

SGksIHBsZWFzZSBpZ25vcmUgdGhpcyB2MSwgSSB3aWxsIHNlbmQgdjIgc29vbi4NCg0KVGhhbmtz
LA0KV2VuZ2FuZw0KDQo+IE9uIEphbiAxMSwgMjAyNCwgYXQgOTozOeKAr0FNLCBXZW5nYW5nIFdh
bmcgPHdlbi5nYW5nLndhbmdAb3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBJbnRyb2R1Y2Ugbm9u
LWV4Y2x1c2l2ZSBkZWZyYWcgdG8gc3BhY2VtYW4uDQo+IA0KPiBXZW5nYW5nIFdhbmcgKDIpOg0K
PiAgeGZzcHJvZ3M6IGludHJvZHVjZSBkZWZyYWcgY29tbWFuZCB0byBzcGFjZW1hbg0KPiAgeGZz
cHJvZ3M6IG1vZGlmeSBzcGFjZW1hbiBtYW4gcGFnZSBmb3IgZGVmcmFnDQo+IA0KPiBtYW4vbWFu
OC94ZnNfc3BhY2VtYW4uOCB8ICAyMiArKysNCj4gc3BhY2VtYW4vTWFrZWZpbGUgICAgICAgfCAg
IDIgKy0NCj4gc3BhY2VtYW4vZGVmcmFnLmMgICAgICAgfCAzOTQgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKw0KPiBzcGFjZW1hbi9pbml0LmMgICAgICAgICB8ICAgMSAr
DQo+IHNwYWNlbWFuL3NwYWNlLmggICAgICAgIHwgICAxICsNCj4gNSBmaWxlcyBjaGFuZ2VkLCA0
MTkgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiBjcmVhdGUgbW9kZSAxMDA2NDQgc3Bh
Y2VtYW4vZGVmcmFnLmMNCj4gDQo+IC0tIA0KPiAyLjM5LjMgKEFwcGxlIEdpdC0xNDUpDQo+IA0K
DQo=
