Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012064.outbound.protection.outlook.com [40.107.209.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB16196C7C;
	Sat, 24 Jan 2026 21:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769290520; cv=fail; b=pzUmeRAQofC0BhgjPhtf+MpdM8dYyGtH19prrp/HwePvjmu/ufNRBco+WspiFYs+xU1hOT5rBR9jZdtQWZwTSk+9Iw+Je5/gerT3NiKCz+exMgCHgKZNVTEPsUyqTExcRh5a6Mn1qcGUpqXpYX0vCFrDFBUFtfwccvx6U26mQNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769290520; c=relaxed/simple;
	bh=i3/j+i8Hh6Mf0cSNe444HWsnKmO1Iv4pWK4wI/xFhec=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QF3uyqIloCQj7RMKhsQAtqYsfd9fj2RzzOzVid/c02+V+bFgl5PJUJHwSGIJNQq0L4/OR7UuEwcqjeNj+uNOUgXXidv4QeRC3KsoqBhhE457W+BSUaHgh5nuSPhpbOlrwwFyvgyN/YxBCZBssNF/fSs8GYZjx84WbyHp9FEaDwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J2zTnJl3; arc=fail smtp.client-ip=40.107.209.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J2zTnJl3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gxec1wlYWy8lyBUkrMRkdAHFjgB9RLlIAbkDnYov21FKQ4f0TDLNbrwiTFCHOD2nXLktmMcPoWtYxV+F34Rb3AMchWVB03Yzi6ZpVsf9bZj6ziPnq6yPq8rYW226m1menOzG0GD2P7aS9wEZldyHrqNxUcARgafLfuWStMaJcMp3c/n3hDrynAs6kvJYHjV5mHYdyLwkSrq3UZH61IXrGyuZ+aSsWkrMD/zEU93+VIy4qxzyUPFFBeHvK2820t5IXwCXG/HBUtNmJ0e7nbkgsKdYn0ORa7vgvWQgi6zF9CFfxfWgthLUjnFXJxw6RY2Kf7XuWDpQlwAB/lFE04mRdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3/j+i8Hh6Mf0cSNe444HWsnKmO1Iv4pWK4wI/xFhec=;
 b=xWS/aGgdpsc2WMtDJ3bwlOxolU3Tdqm/4es1fMNS3dcqMKAktPAaRG3lFFxst7OaavvUMDUKOTw5WRnoGnXw4RDfnLIuP/cfdkbWqR7hBg0V0cVEC0edCSvcNSr8/Vh+VAKwIfsf/vkmfTK/9vLLRnM/le96Z5PPtdjd1m4hrrY5OTmHKrJmu6shGvXrkLxHZJJm1YTXDhhxjvnJAmi3zTa53BTG/OcA4K/87edfh8eRaLQNWop1GGg5aoyWen1Ril3ve+tl69y4fqBpd5BFlPT8mACjFSUDkuAd8v+7cNe4ZyiVPJHW6EJ3sEmDSqLa/wG7gxlH7kQ4iHZVd8x06A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3/j+i8Hh6Mf0cSNe444HWsnKmO1Iv4pWK4wI/xFhec=;
 b=J2zTnJl3cRgy7art1/T2PzRMciNuR+ARqHAP3UiCH3k/oV7BMLvoIYiqkJ+LV6AJZ8c61vXFc/fTNrMT90+ukL6q4dc/Glk11l2TRYkeqJVGHO2jJaLDuHYofEQ5lHzNJI/n1T8CdbzYD62uGto9EUhYbDpQC/cM1/kB6N7QtRcfhKkpf7YG/JLXKR59iXcLaT79FdHWvWT+LFcauE/lKMErN/C/+Cx7djmJUTDQHbtFOAaP9w/g7NDDKdyTfBWpoA1FDGHAWnZPqk0UcrxxpOrU7MQKgrtXk9eqtAGBKdYBYCTah7OkmtSFTLkV/bAqXu6UYw/bXacN2LoX29TTIA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CH8PR12MB9767.namprd12.prod.outlook.com (2603:10b6:610:275::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Sat, 24 Jan
 2026 21:35:16 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 21:35:16 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "agk@redhat.com" <agk@redhat.com>, "snitzer@kernel.org"
	<snitzer@kernel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>,
	"song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com" <yukuai@fnnas.com>,
	"hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>, Chaitanya
 Kulkarni <chaitanyak@nvidia.com>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"chao@kernel.org" <chao@kernel.org>, "cem@kernel.org" <cem@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-f2fs-devel@lists.sourceforge.net"
	<linux-f2fs-devel@lists.sourceforge.net>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn
	<johannes.thumshirn@wdc.com>
Subject: Re: [PATCH V3 4/6] nvmet: ignore discard return value
Thread-Topic: [PATCH V3 4/6] nvmet: ignore discard return value
Thread-Index: AQHcXZzXDfTSuV3W4kihFfciFgwCxLViN28A
Date: Sat, 24 Jan 2026 21:35:16 +0000
Message-ID: <942ad29c-cff3-458f-b175-0111de821970@nvidia.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-5-ckulkarnilinux@gmail.com>
In-Reply-To: <20251124234806.75216-5-ckulkarnilinux@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CH8PR12MB9767:EE_
x-ms-office365-filtering-correlation-id: a6e00b11-19be-4a89-641c-08de5b907745
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info:
 =?utf-8?B?R1g5RXEyMVJ3MnJydUpiK2hDUnljQURnMC8zVzZORW9vMUJRM1VjNFlGYWRw?=
 =?utf-8?B?V0xQOUJSVnpnakE0bFJNemVZVWl0OWdyTzUyMFZoZVVUQ2VzNTJnZFlTRDBw?=
 =?utf-8?B?L0dKV0NKMHRGb3RUY213YjZmTzF2YlduUzB3NE8wTGx3NVR1V0Vqdy81UytD?=
 =?utf-8?B?V3JWc2x3eHBLV1VVMmt1VmdpMkZVV1RpRWFMdlRaSS9RdndZYXdhL3M5ODdZ?=
 =?utf-8?B?RGdxVFN0SHBLckNLSW1yR3c4cVVVaUpjTXhuL01vSjg3cWxyWUZWbDlOTDdu?=
 =?utf-8?B?Smp3ZVFwUGUxTWo0N2NDYnUzZWFvT1NtOEoyY1NNamFFNFV2SHdvWjFmL095?=
 =?utf-8?B?Yy91NldmLzVjd2RXblVTNzdnZ0llLzhLQ1F6LzdDS3lzaW9oU20xZzdNMHVo?=
 =?utf-8?B?eWZFUU5oS2tPa2NGbStMNy9xKzJjdEVvR3FTaE1IWVBnOVZ6NDBHVGVnYklP?=
 =?utf-8?B?bzNtYmpmbGdxSThhdHdQS1FHV25CbFBXOUhiVkZtVlVYZ0wrQksrSDM2aUxz?=
 =?utf-8?B?dkVFNVQ2dmpYSWNpYkhDMHFQekxoUERkZjhlam4xQ3dxT1NtVGRRT0p4Tzh0?=
 =?utf-8?B?YlhETjFkMkppSkprbC9oaTZ2UTdhQzRUbUp5eFlpaUptME9WWlhMbFhnN20r?=
 =?utf-8?B?NFRadll3M1IwZFZTeExEQ3d6VWRPNmpyeW1HUWpsSmpZa1pjVDJpSUZmRmk4?=
 =?utf-8?B?SmtaMlJ2UVpFLzFwdDYrNGtBK2M3aDZLT3RaaFNJSmpyaTV1ZGZnSGZoTUpu?=
 =?utf-8?B?Uk4yNU54KzM2VS9sVDlmTllWMDBvelpQVWVKWHZDQ2pDUXNZRC9tRkRyWU8r?=
 =?utf-8?B?cG1OTEUxbkN5L295eHNidXR6UDZsYmU4NDdQOEhiL3pkMjJoR2FQaVJmZU1V?=
 =?utf-8?B?YUI5aDRFSys0V2pXRmxXdVB5SGcvOGpZRURrWlFZNXAxUm5CQzlMeS8xYVpG?=
 =?utf-8?B?bmZqTGxwd3BUME1iTS9zaDIrcVh1NmFvenVJV0dZdmQyazQzcFU0M2ZOV2M0?=
 =?utf-8?B?YUJCQklrTS8wa0NQTURUNCtkY2xWT2Z3OUdSdW9KbHlqMU5OWW9rcHYyc3Rh?=
 =?utf-8?B?c3oySC9FZHZtTENwalZGTTllN1Bic0psb1BIVGZZMjVxV0xlNkN4bW9SdVZh?=
 =?utf-8?B?U0hQcCtrTXBLMkxwcjVrK0JnUmpSM0xZNThoMXFhZ2lHWGlEU2ROUjFON2c2?=
 =?utf-8?B?T0tseGZrQjJjdS9mcERhWnpZMFBSK20vUXgyNWltZHFudFlialMwbG83NkFT?=
 =?utf-8?B?MHljMFNKQkppNWw2SnpRRDBRY0oyMUhhcmNlTDVPOGNBMVRHSFRoMCtLVzlK?=
 =?utf-8?B?U0JIa2JUSFg2a2tHSTV0KzBUekZzOVI4NU5UQ2RCR3hlUzA5WGN2d0VyZnBH?=
 =?utf-8?B?cUNybDdLY3J0UFdwT0tQeEpUTklzRVh0b1EvNUgvN01CMGttL05NQW94bVRS?=
 =?utf-8?B?YXVkc2pTeDVYamZ0L0RvazhaWVVNOTNwcVB5Y0xDQUN3ZENOaGxhSmY4K2JN?=
 =?utf-8?B?WDZsY0crTC9CbVY3M3J3RjMzSCtiZHRLSFd5cnZYbG1FVlExcWJ4TkR6NWVP?=
 =?utf-8?B?RkpVUWFLOU9JZFpmNlhmMllBNTlibUl2RS9PR0pEalR5U2l2UVFBa0o0bWdZ?=
 =?utf-8?B?SXpzWitwWVVXT0trR3BNcHFxWFZqTHI2V1NDeW9SeWpsOGdVZ1JlZzdsM2h3?=
 =?utf-8?B?RWVhMUpHaVVyVVJnUHlXYS9yOXRVWjd2aVJKL2tZUzBFSWZhOUdVS2ZPWTdl?=
 =?utf-8?B?YkdsT295S0ZBNHk3OWxKTXBNZUhoNjN6R1E3V3l6dFhjMlY1N3RYMG02SGU3?=
 =?utf-8?B?bEVpbmdwMXRDU0VXZk9SY3dld1g1bzB0Q1JPSDRSYmRsWWNtTHlhREs0YjZl?=
 =?utf-8?B?NDFuZCtFd0pUYlNpN3l6U3dySGlWcTJ4NGlGbDhUZmplTFJUUkpZdGtrR2lX?=
 =?utf-8?B?TVQxb3V3T3N1Q0VvejlGNkUxZ2ZMcFJibmdSTGgvM0Y2MUZJY1lPS0ltRm02?=
 =?utf-8?B?dW94VmMxR3M4a2hkamlRb0l4S2VBWnAraWtHRWU5YWNmYTdSWTBkNjU0QTZG?=
 =?utf-8?B?OVBReFlLWURUWkxJYWt1NWt5Y2lFSnppaHVlNUtPTnV6QytVUEFOS3Y2OWpx?=
 =?utf-8?B?YkRpRmtxVi9BdXpYTXZaTUFseFJUVlY5RStKV3hKdXhaSXJMRHdzUnRHTmdq?=
 =?utf-8?Q?q0ZwQW6bmANMsc8BQihm59OsvZD4dZK3kr8CmEtWn254?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RWtXa283Ty9jdENlK1FPRTRlQWIzMXRQQy9sNUFsR2lCY0hveHNiOUpaSS9F?=
 =?utf-8?B?czltUjlMTmRpc2xMNUI5WnJMSFJneHJUTlJ6NXpwWE9xM0cyWkZlZVZqb2M2?=
 =?utf-8?B?YUJSUzdPUmxGeHJOOFN6RXBVNXg0Nit2aW9NNnJpUlg2T0xidlcya2djcXJD?=
 =?utf-8?B?OWtldWNZN3BhQlJtb3JmcUU4a1ZHSzNsOERTRnpWUm10M0Q2UDU5N3MybkZs?=
 =?utf-8?B?TWxEMUp3RUdjbXFoVDdnOWtLWTZNQTdhdU9yRzJ5dTgxRWE3TUlIbzdhNENl?=
 =?utf-8?B?ak96b3JTSW9aenZPeDl4SDVlcWRlMzlXaGw1YVl2aG1WclNTakI4cXdya2I1?=
 =?utf-8?B?M0tuY3I1QjJ3ZEx5OTNKY1FYdmNwZVczcjBQVCtkVzgwT0tHUGx0MmpvSVQ1?=
 =?utf-8?B?NGZnRitzamowQTQyWEtiQ3I0UUt0akx1YVFGOEFqYlJWalJlc0JqeHZQcGhV?=
 =?utf-8?B?d2FubEt3TEIvZUV3MVUrcHBTbmV3R0gxVDVJTnVtS0ZmQWxXMTJrTEtXWmlI?=
 =?utf-8?B?dXF2U0R4eVJwc3BDM2JvY0pTQlQxakFGTTVCdVRVWS91NDM3RldZRDZRSWll?=
 =?utf-8?B?ZTF3MjYzZDVhaStVMjRRR0hrY3hEQ2poWGhDZGpGZXhOcXRENW1ScWpPWGo2?=
 =?utf-8?B?RG9aanV4SGFDcy94SlFlRzFSc0VCRmRwSjdIcC9RUDZkaGZwUzhiV3JTV2Rr?=
 =?utf-8?B?TE5pMXpzWWJBdlJuL2lMZ1lBN2J1TnVwbzRDTXYvVFdKNEo2dE85b1JqdnBO?=
 =?utf-8?B?K3JDb040Vm1lQ29ZZ3crN1B4dktxMExVNURSZCtFZ1E2VHhzNWlHYXU3dFFu?=
 =?utf-8?B?OHJPNDNRaTBtMnV0R0l4YzI0TWhJZzZFdDdVbzViNkY0N3k1NmEvQlQveThI?=
 =?utf-8?B?WUxwQjJua3pFcUpDcjJDQXpFUW52Q1owQzR2dWRHbEFOekRnUWczVW9WYXl6?=
 =?utf-8?B?SklnN1doK2xEVWNhRG96eVNxU1hOOGRRMVYyckw0bTcrSXlWSVZSN2JBcGNp?=
 =?utf-8?B?U3U0Qnc0ZmUxUldWSWZaL0VIc1RSL3FlR3hDbXZoQTBDUjUxQ1d5V1ViRDJZ?=
 =?utf-8?B?QzYyUVdGaFM3OGV0OVlUaS9yYjZVQmtYUjgxMEhxK213OWRxWHRGbHZkQUpn?=
 =?utf-8?B?L00wL216aUU2LzgzSmNuR085U1pCRmxSWit6Yks5UDJIMDJqanRaMDU3WXk1?=
 =?utf-8?B?bmpxd1lRSmlBb09CVTQzL2d2R0NBdnB3SklGSUFPQmNnN05SQVVreldhSUNq?=
 =?utf-8?B?clYwM1RITXZKRUQzQVM4anEvVnNjTjJTRDlMY09lcTJUa0pqRHJzakdMNk5X?=
 =?utf-8?B?WHdtMy9QZEY1SEhsQ0lidDBhNWxvZUdGbzlxdzJMZDFRZGVRTldmYllydlVC?=
 =?utf-8?B?NElrTFZEemRTT0tvL1BXVHhCRE1wVys1Y3ptbWt2RTIwYkozMU5JS2FlN2xx?=
 =?utf-8?B?QkYxVVV5dWk5L2tUOFdzZXQ2R28wUVlmQit6RlAxN3grTUNHN2lFdlB5eS9D?=
 =?utf-8?B?QU1PWWtQcW9JLzYxWXRzdXBFK29FWmQyL3AzcG50dDlNN2pQMmdhS25KUGEw?=
 =?utf-8?B?Q2Z2WDQxU1FhdEttQlJ4MjBDL2tXUEViNjk2UkU1VmxOeGZIcUhJbG1nR0Fp?=
 =?utf-8?B?Tlp1M1ZOUHU1OGhvTTd3d3JQVUVkcm5QUTBMR3p0ckc1L2QycHFNZG1ReTJz?=
 =?utf-8?B?eWZzeXZEWTlXd1lJYzBoc0N1aFFnOHZIdmRjT2JnZGFkSjdMeENUQlpEd2V1?=
 =?utf-8?B?K2U0WU1OSEUwWWplbldtdm1HZEFidFEzNFplVmk3WVVrY1p1MzY3d0QrTk9j?=
 =?utf-8?B?ekdRTlFaWEIzREp0SWh0M1BrTDZhMGltem9IQll5UHUrWjRiMzZQWXlrNHJs?=
 =?utf-8?B?aFVsZEtJWHdYRGVsZzYwclJGRjh1Z1l1ak5IV2FzTWpBZ0MvamtXRUM3T2Fh?=
 =?utf-8?B?cnVIb2UyVVN3bE9QWkYrQ3FIWEgrMU84N2FLR0hxc2tYTnRwa2lZTHdyOTR0?=
 =?utf-8?B?ZWN1ZW9KNnpmeXpWN0xKRVEvUkhURVAzeVFFaXlIUFd1YVE5a3FVUFZnTXZC?=
 =?utf-8?B?K1BRa2daRzVsNVVHYkIyR0VydkE5a0Z4Zy9CTkdJWnlKby91ZnZHWmd2dlN5?=
 =?utf-8?B?RERKR0tuR1VtUzlYWVh3L1pTZGN1TWxtSEJ0dGtKL1pvWDhIN3l1M04xTjhp?=
 =?utf-8?B?RTdyS1RrSmRvbnRBLzRqNzNuRy9HMkFXc3hzbCtXdGhZZFQyWDNlVmRlMElm?=
 =?utf-8?B?STc4NVBReEJWZVBFSWV5ZHhZVFBUanI0RGNRQy9vcnpvVnJKeVhqSDhyaGE1?=
 =?utf-8?B?cU9SR0VKTloxV25qUUpoRXJUV0JTNTU3c1didXJMbFI3cURlcFdxbCtmT09N?=
 =?utf-8?Q?/+V9gzjEGigs9XkJDeL+JW3QqxBrA2Yh0ejGk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DD6CA08F101B94A9B9A86A8DB710E7C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e00b11-19be-4a89-641c-08de5b907745
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2026 21:35:16.7191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WaFZhpieHAO+wJtaGX4ntCIvi/e9yAlqh6H1RdG3yeKymIQ6Go/jTmai1CxASsxPqqQAk/fQbDGwS12BPIfi0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9767

T24gMTEvMjQvMjUgMTU6NDgsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToNCj4gX19ibGtkZXZf
aXNzdWVfZGlzY2FyZCgpIGFsd2F5cyByZXR1cm5zIDAsIG1ha2luZyB0aGUgZXJyb3IgY2hlY2tp
bmcNCj4gaW4gbnZtZXRfYmRldl9kaXNjYXJkX3JhbmdlKCkgZGVhZCBjb2RlLg0KPg0KPiBLaWxs
IHRoZSBmdW5jdGlvbiBudm1ldF9iZGV2X2Rpc2NhcmRfcmFuZ2UoKSBhbmQgY2FsbA0KPiBfX2Js
a2Rldl9pc3N1ZV9kaXNjYXJkKCkgZGlyZWN0bHkgZnJvbSBudm1ldF9iZGV2X2V4ZWN1dGVfZGlz
Y2FyZCgpLA0KPiBzaW5jZSBubyBlcnJvciBoYW5kbGluZyBpcyBuZWVkZWQgYW55bW9yZSBmb3Ig
X19ibGtkZXZfaXNzdWVfZGlzY2FyZCgpDQo+IGNhbGwuDQo+DQo+IFJldmlld2VkLWJ5OiBNYXJ0
aW4gSy4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPg0KPiBSZXZpZXdlZC1i
eTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNvbT4NCj4gUmV2
aWV3ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiBTaWduZWQtb2ZmLWJ5
OiBDaGFpdGFueWEgS3Vsa2FybmkgPGNrdWxrYXJuaWxpbnV4QGdtYWlsLmNvbT4NCj4gLS0tDQoN
CkdlbnRsZSBwaW5nIG9uIHRoaXMsIGNhbiB3ZSBhcHBseSB0aGlzIHBhdGNoID8NCg0KLWNrDQoN
Cg0K
