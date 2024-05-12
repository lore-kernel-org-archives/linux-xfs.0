Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2040.outbound.protection.outlook.com [40.107.20.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D9F1BF50
	for <linux-xfs@vger.kernel.org>; Sun, 12 May 2024 12:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715517019; cv=fail; b=rKS0bh9eBdUpwlT/1PTM+5T/mwSw629bpmU7h5V08fQxmcEfXug1LYLHrUEmVnHbqB9V1QeRcy6FFVmg09QhIPIOPppmMDXeriv1jH5AUGlMZNSMOxEAoI7ccyTjoeEQDO/Sn7dvmIQnwNkF+UUotzexDpQoDapWYOgBdEJsOpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715517019; c=relaxed/simple;
	bh=8uPebY1Q1cYCh4JWg8ARD3iin8wA5eonOEDkbED/Hdo=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=elTQtuHnKSbW0SDIT96qyDK28AnlI7xMMwAUzWGaBEhtHjDfeiG9yBhJBhkRLR17Ydf1dpBc0tQO2Hsc9ujqB5ZDe+qBbrtONljqx8kK/vQuqz8f7I46B6xDNKblNK+1jiNgueGrVm1II8DFIrX2M4/uJ+7vnDa9Y2m9ZNHE3Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=helmholtz-muenchen.de; spf=pass smtp.mailfrom=helmholtz-muenchen.de; dkim=pass (1024-bit key) header.d=hmgu.onmicrosoft.com header.i=@hmgu.onmicrosoft.com header.b=wiN6fdXB; arc=fail smtp.client-ip=40.107.20.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=helmholtz-muenchen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=helmholtz-muenchen.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hmgu.onmicrosoft.com header.i=@hmgu.onmicrosoft.com header.b="wiN6fdXB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CX3Y3VvqBqyJ/AiE6r8Abh6nFuC/CI4YxdCiIeTzDqypiCG09FbYbObPPkAr5OYsmzOTl6owfC5Q8wHhXoKmz1h/2QwXBe/0cG4rhl+bpgQOIE5Fn8nBt3K0m/ES6jQMzbKpqBEMwEGC8GQoiX9n/rTiqUoT+SsR2yJ+M86V3mvCfW10XfhbQu1HoJjWVKTIwGsneYSKM2MLFHbO0YY/BKBmRY1ZJgc1iuT/v0GgKVpDe3Hd4PgH5QjdzniUeKbO8y71KbwkrajJlPPDfJdQUh44whE4PAnDyy6st7QTtuRQJJbJuftUzQYmu2L6pF3hMC3c1z0WqlX74l4Hdo7C4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uPebY1Q1cYCh4JWg8ARD3iin8wA5eonOEDkbED/Hdo=;
 b=L549XO5qW/9Yyr7xhlqNZ3Xu60laeJBdZRaL3YTnNwWIJdaWGjbH14dlvhw2wziN+luaXJb0DP8ZFL47o1qxx8P0LanJ8R97OdJY7d6ZOO4kelnI/jW7kSPwdbPS7pWNX8zrRBuKgDO7LU3Wg/Q7kycqlYwOJnnbq+j55Q6o/sfq0h6eU5/M6bKUXS3zYmZYzhdzqxCSCs2yQjOeL00Tx6iBPkBZQU/Shp1IifSc6V2XIZPgBMLFI08zlLVZsgQojNO6phrHAjQ/PZhFptaNh9TsUBIXzAki6zICy3081QlhIruD3Lt7FBSwJBWTz6mMqqJRsXGF+hPxWzDcJOBmNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=helmholtz-muenchen.de; dmarc=pass action=none
 header.from=helmholtz-muenchen.de; dkim=pass header.d=helmholtz-muenchen.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hmgu.onmicrosoft.com;
 s=selector1-hmgu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uPebY1Q1cYCh4JWg8ARD3iin8wA5eonOEDkbED/Hdo=;
 b=wiN6fdXB9A4QjYWbQlY2lCpHkaZ02hV8d9hR+6Fz0AqJdOrxmCMQnuwTUqPhNBUdeqwscSytAeIxRgCJ0CVkhvvHoRYIBY+Ess0i7uCaigQpwvB29fETktjlkcb0Z6hyX6Y1B6RyTPXeKCmpgOg0qA3qnxBNTrPhF07raSkGt4o=
Received: from PR3PR04MB7340.eurprd04.prod.outlook.com (2603:10a6:102:93::18)
 by AM9PR04MB7714.eurprd04.prod.outlook.com (2603:10a6:20b:2dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Sun, 12 May
 2024 12:30:12 +0000
Received: from PR3PR04MB7340.eurprd04.prod.outlook.com
 ([fe80::299b:6408:26a0:9006]) by PR3PR04MB7340.eurprd04.prod.outlook.com
 ([fe80::299b:6408:26a0:9006%5]) with mapi id 15.20.7544.052; Sun, 12 May 2024
 12:30:12 +0000
From: Bernd Lentes <bernd.lentes@helmholtz-muenchen.de>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: how to restore a snapshot in XFS ?
Thread-Topic: how to restore a snapshot in XFS ?
Thread-Index: AdqkZhEBBLHWMkVbQFGuyU9QMSGkXg==
Date: Sun, 12 May 2024 12:30:12 +0000
Message-ID:
 <PR3PR04MB7340EFE53D742D347C9ACE58D6E12@PR3PR04MB7340.eurprd04.prod.outlook.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=helmholtz-muenchen.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PR3PR04MB7340:EE_|AM9PR04MB7714:EE_
x-ms-office365-filtering-correlation-id: 678e7ead-e498-40b7-763d-08dc727f4529
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?Nm5GaG1PRnUxMXBOSlUvc2JyT2pISFRJQUF1T0dhQkN6elVkZmVJZ1VuOGd5?=
 =?utf-8?B?Z1R3RDhiWlEwZ1N1SW5oNUc3c21qTVpVdHJEamlRL0s0WFczRTdkR3MyMldx?=
 =?utf-8?B?VXk1bGNsQ0Y3NW5ORjgwSmJsLzN5cXgrUXR6b2J1b091ZFBUSU5SdDdsWnRM?=
 =?utf-8?B?djFRelVaMlFEaHkvK0J4OHVkWkZQK1NJOTA1ZTRsMDNibDNPeVQrZjBST3l4?=
 =?utf-8?B?RWF5azNCTUgxSE9YWW1XaUw5SzN6c0RZdDRmN3hoLytFV0x2RFVGbzFXLzRV?=
 =?utf-8?B?V0NzaUNrcEVPUVN1Ukx1ckh3Y3FOeW1PV2hvci9reUl1M1ZhVEhCWEhEVDAx?=
 =?utf-8?B?UjZueC8ranVwenJXaU1wbkwxNjIxWnQzdnR2N2pTVnp1eTcyMkQ5eVVOSSty?=
 =?utf-8?B?VkIzREpZcHVOakpqN2RtY09rVTZWYzlqNE4rVWdDZkFnQnVvdGFKRkdhelFN?=
 =?utf-8?B?eExxVG5JZ0JOemIvc1hPTUZsZXk3d0J3MUV1aHk5cGdlUEJYdVdjSjE4UTA5?=
 =?utf-8?B?ZkZTdm9qcytKYk9nTTRpdjNSUzFvaDkrOUFxeGJobld5Q2xqeFFxVEVTb2d5?=
 =?utf-8?B?V042THpYZnk0bTZPaERvRk44UzhjVzhxbVhQbFFGRzVqdmFFS3hjbjJsYy9B?=
 =?utf-8?B?S0RFeWt3WjU3b3lId05ZUlNhU2VWbGlaUkJoZ0l3Q0VxNG5GQVBXRzlKeGcw?=
 =?utf-8?B?U212V3F5TG1uTXBQTU12RnRCWWVmejJZbnJRV2tPZXBCZ0ovQjVjOTBydi9w?=
 =?utf-8?B?NG1kYnRlY3ZzVTZRWENRZWFnVFdZdHh3WEw2MUpPOWxWa2I3cncxZ1g1SWE1?=
 =?utf-8?B?ZE5hR2dBK2hrZXNUSlNQWGVsUG1BakNIWURycGMwdHVCYjhyQmNHZzJPVHUr?=
 =?utf-8?B?Wko5bmJidUR4UytiVThDaUtLNXJBaEtRd1UrU0tzQnBzc3BVTUF4SmpZRGVV?=
 =?utf-8?B?czlsb2s0YzVZVkxFTkc4bXN3dFc2VVZZd1ZVem81RnlYd0M2cGthVUpyZnJI?=
 =?utf-8?B?TFdiVG13YjkvQ29WeEdwRGJKRDNZRWRUNVRsZjkybGdqU1ByTFZwQnE0dmQ0?=
 =?utf-8?B?cElZUVFFdVQxeldvdkZNS25sSDQrK2JkbjRTNDRyOXNrQTRsVEtLL3JJZDdV?=
 =?utf-8?B?KzdJRzdpZHZNNllQOGlIbGIvYTd6dUJPT01sV3dCNzRYaDk4K2NlaFBOL2Nq?=
 =?utf-8?B?MzBxRTlWemJNYWpaU1RMVC9GUEUydXlud2c5ZmhJVHVobmtDQ1M3SWNmZ0tv?=
 =?utf-8?B?L0dNY01TZmZNTHFFNGp1S2lKRWp0cUUwN0pBV1UwUnJIY2hTN0tZZ09zTzVD?=
 =?utf-8?B?cFdIVnNBTGdSSHN3bTYweVJOZ0dWd2VtRFFRK2I2eE5QVUdrcFh4SmJUY2RI?=
 =?utf-8?B?Y0s3T1lHVWpFUHprMlgxQ1pxUFFTRTBDRERVRnNyV3JZUzE2TzNpeFVqcERN?=
 =?utf-8?B?QVlrZ0ZEcUFhR0RYU0VmWk1xc1pZM1RFOElQTHZHSWFGRlZiWk8vSWp3S1A2?=
 =?utf-8?B?TXBkU3pXNjVEcWNQT0R2YzZMcnNiTlJob2ovL0w3dC9FNW4xRmNwN25WOEU3?=
 =?utf-8?B?S1dRZEFZSXR0RkF3VS9xMDBVcUJZaWFERXpvUUVvSVBQQi9sMmpCNk9ZQmVn?=
 =?utf-8?B?aE1sZWdYQythVTdCcjk4TklZYWRlVWl4YzNPRDNMY0hIVFdvUE10WUtFRnRa?=
 =?utf-8?B?ZlRtQXo0TStCUFYrQWRRL3UzUXVPQW1uS1BLaWFWcHRQejVPTkhuRkZUNjh6?=
 =?utf-8?B?bHRlVVVkK0pQSDdaMEs3UVlxUHBCbVdmbWxlbVowem1WN1YwZkQ4cjlrMU4y?=
 =?utf-8?B?YkFSS1JINTRkVE90WHRsQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR04MB7340.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d2twcWdrUmprdEtIL3A1c3MwcnNDWktWTTZNcy9hcm80cEMzU3drWmRzK0dD?=
 =?utf-8?B?M3B5V0xzRm1RWDR4Nzl1djgweGdSMGFBWXhmUzJucnhISjFJTnhQNmVYSyt5?=
 =?utf-8?B?UmZaNWxyOWdyaXFjYTNvTHdCWjFHVFZ4aXh3ZWtHNmNHV0ZWcnBlY0w0TUFp?=
 =?utf-8?B?WU01OVd3ZzE1MkdCTVZZVVFvQUNmaWFmbDdXREhsR1Vnb00rMEtkcDYyRGFz?=
 =?utf-8?B?eEVwS1ljbWFPYXZjK1BhN2dxa2k0K2dPMTY3UklLV0pmYnJpN3JScUxGZlFu?=
 =?utf-8?B?bTJSc3BNK0MwSzJiRGxmc2tLUjVXMHU1Y2N2bUlqNXlUOTAvbVJzRUI1RFE4?=
 =?utf-8?B?V1NmQjVvNitIRG8wM25FVlFlY2phR2ZCNnFkUjl4M2R0U2hxZkdhSlU1aXFu?=
 =?utf-8?B?cUJJNU9IdTQ2NnF4WjAyb0t1enZiOHNXQnBrcW1Nd2o4em5zWVI5SkpPNURB?=
 =?utf-8?B?Q3pSa0JyOFNKbWZHWHRNaTBCY2d4MjZFRFRDN2xHR3lBRXpNZnRJSVM1N0ZB?=
 =?utf-8?B?THp5SDB0QkdaUG9tTGpEdEczejhiMExzMG55RTdRUDRReXd6QVNsd0U4K0Mv?=
 =?utf-8?B?M0pxdFZKUDNnWldYTlFkQk5vYzdPU20wczZCMGt0Y2NZYjVRNTh6UFJWelpu?=
 =?utf-8?B?bFdJL1BseXQyVHVRYTcvbU1XRnpzaTF3SlNvRnNlMFNsTUtqTnlSRFZxRmNM?=
 =?utf-8?B?N1phNWVqbGVWekVGNFdEZjF1ZWRSajd3TEJ6MEZHekFLb1RzQlFqaHhLQXZj?=
 =?utf-8?B?aFRMb3dmMEhSMnJObStpWjRyVXB3Q2FvYkdXWCtWOFIyUWVBckxnQXhxVWo4?=
 =?utf-8?B?ejVSL0F4N0ZPclgyVWY0N2tiSjdaMlZaUGxwUGt3Q1BlN1N0U3pDcVhZWFBH?=
 =?utf-8?B?RzUwUngvNkt5UEtaU3cxNFd1VzJxQ3FQTFZRZ3lleTBnTlZxa2lEeko2ZFZa?=
 =?utf-8?B?QzQvNWJsSmlQSXZBNmZmd3hpYzZTU3M3T2dGd2V4dlJEZFp6TytQRENkcWFM?=
 =?utf-8?B?YStHZWdFOGgzZTdXYlNXTEhvZnhIUWZmNDhub2JNRmV5OE14eHEvQnFKNmE2?=
 =?utf-8?B?aXUrMUJ0dWFtK0xHNFpPRkVURkZraERvMWxEUS82SktMQTl4ZHRSTnFkQzI2?=
 =?utf-8?B?a2tuVUoxYitLUU5ORE9icmNjdWdIZnJiU0Y2MVZINkNEUk0vekVnQTRrZ3l1?=
 =?utf-8?B?L3h0M2dFa0U3emdTdldHV2VGMUJpOWxFcUZzdldDS3Bld0o2b1dNUVl5K09J?=
 =?utf-8?B?ZGVMc1NpaWFSa2QveDFISVpkM3VEMnlZQzhZSEVNT0FxQ3ZIaEdteW9xclQ4?=
 =?utf-8?B?TVMwR1NxTk8xeHQ4NnE3dVowdTZvU0thRnp3Y0VpWnJLTDJMQ1Fmc0tXMDV1?=
 =?utf-8?B?MHhTbXRibGUvQkV6RnNCWkVkYzZoNEJMMnR4MU82azdieDNYU3ErTFlCa3BM?=
 =?utf-8?B?eXJjTmpCc0VHc2JNZldQd1V4cnRNNi9pdUEySDBOSmFPZURCclVDNXR5MVFj?=
 =?utf-8?B?YXFnZWY4QXlYNm1oQ3UxT1JSbnBTeUJPODZ4cHZaMnZTTU40ZzlwK0Z3V1Vj?=
 =?utf-8?B?Z0dGSTB6YTA3WFlad1o5L2NoYmUwUDJXSnE3UGxKc3VONi9BblI1UGNuS1k4?=
 =?utf-8?B?ekRiS3pBcStLRE01OWxhZzJMQlFYb2tWQ1JmMWlWSjlLNklPTWhxVnJETnZt?=
 =?utf-8?B?UHJDeVo5MmxPTlBiN2ZRamZpaGVicjQvNm5OQm9NV1QzNTQzT2NJSHhMOHZy?=
 =?utf-8?B?QlRjUy93ZU9JazRDWUxOekthZGNpSkZzdTlVLzkyMHVFUjJvdFkrZjRhTWtF?=
 =?utf-8?B?dDBocnFHbTM4M1U0MXIzc21PekR2MGd3M3l2UkpoaFNaU0VWSU1TZ0tXUklK?=
 =?utf-8?B?OVhBanFjSjVkRy8yVUFYVGd2bGJ3SWNWdUFObHpsV2RIRmprWkorVlRvajdV?=
 =?utf-8?B?RkZoZ2lCYzltSnF3YnlNcWJobXdYZjQwa1RyS2hnMkorTFg3TitSSlRlS2JS?=
 =?utf-8?B?MzZrRkNQZUFVMjhhTDBNLzRVWExaOGc4clFUbUJ5NzVWenYxclcrR3JCdnM4?=
 =?utf-8?B?U3BvZGkxTHVkQk5sZk1HY0c5dC8rME5zbDQ2OGhvbHFvaGErcDd1bGMvdW1z?=
 =?utf-8?B?a2FXWWNHeHo3dXFzeXhWUDAxVlVDZGlCblgvS2lNSFlGVFVMQUpmVjJJMWFj?=
 =?utf-8?B?NWwraXRIK04wbkpsNm5TOXZHREJ0YWNzSVhKTitEbmhFOWlxNm5HR1hBY2FF?=
 =?utf-8?B?bG9hUGkwM1ppZXZ1SW1xcFYzcFdRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: helmholtz-muenchen.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PR3PR04MB7340.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 678e7ead-e498-40b7-763d-08dc727f4529
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2024 12:30:12.6089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e229e493-1bf2-40a7-9b84-85f6c23aeed8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9h7bXu0s4mPYCCjoZo9hOu80sHeFCa8nb/5cXFiUfASeQi08zs0WaGhRMQDp/x7/h3A0ZnnKCfyLjlPIlIWzpBmy3YKtKGmuJoRJz31lqNStx9pktpArPk8Lm3H62Dxc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7714

SGksDQoNCkkganVzdCBjcmVhdGVkIGEgWEZTIFBhcnRpdGlvbiB0byBzdG9yZSByYXcgaW1hZ2Vz
IG9mIHFlbXUgZG9tYWlucyBvbiBpdC4NCkkgY3JlYXRlIHNuYXBzaG90cyBvZiB0aGVzZSBmaWxl
cyB3aXRoIGNwIC0tcmVmbGluay4NCklzIHRoYXQgdGhlIGNvcnJlY3Qgd2F5ID8NCg0KTm93IEkg
d2FudCB0byBnbyBiYWNrIHRvIHN1Y2ggYSBzbmFwc2hvdC4gSG93IGRvIEkgYWNoaWV2ZSB0aGlz
ID8NCkp1c3QgY29weSB0aGUgc25hcHNob3Qgb3ZlciB0aGUgb3JpZ2luYWwgPw0KDQpUaGFua3Mu
DQoNCkJlcm5kDQoNCg0KLS0NCg0KQmVybmQgTGVudGVzDQpTeXN0ZW1BZG1pbmlzdHJhdG9yDQpJ
bnN0aXR1dGUgb2YgTWV0YWJvbGlzbSBhbmQgQ2VsbCBEZWF0aA0KSGVsbWhvbHR6IFplbnRydW0g
TcO8bmNoZW4NCkJ1aWxkaW5nIDI1IG9mZmljZSAxMjINCkJlcm5kLmxlbnRlc0BoZWxtaG9sdHot
bXVuaWNoLmRlDQorNDkgODkgMzE4NyAxMjQxDQoNCkhlbG1ob2x0eiBaZW50cnVtIE3DvG5jaGVu
IOKAkyBEZXV0c2NoZXMgRm9yc2NodW5nc3plbnRydW0gZsO8ciBHZXN1bmRoZWl0IHVuZCBVbXdl
bHQgKEdtYkgpDQpJbmdvbHN0w6RkdGVyIExhbmRzdHJhw59lIDEsIEQtODU3NjQgTmV1aGVyYmVy
ZywgaHR0cHM6Ly93d3cuaGVsbWhvbHR6LW11bmljaC5kZQ0KR2VzY2jDpGZ0c2bDvGhydW5nOiBQ
cm9mLiBEci4gbWVkLiBEci4gaC5jLiBNYXR0aGlhcyBILiBUc2Now7ZwLCBEci4gTWljaGFlbCBG
cmllc2VyIHwgQXVmc2ljaHRzcmF0c3ZvcnNpdHplbmRlOiBNaW5EaXLigJlpbiBQcm9mLiBEci4g
VmVyb25pa2Egdm9uIE1lc3NsaW5nDQpSZWdpc3RlcmdlcmljaHQ6IEFtdHNnZXJpY2h0IE3DvG5j
aGVuIEhSQiA2NDY2IHwgVVN0LUlkTnIuIERFIDEyOTUyMTY3MQ0K
