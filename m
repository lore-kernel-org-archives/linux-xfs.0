Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE4612F5A5;
	Tue, 22 Apr 2025 12:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745325312; cv=fail; b=Bcop+zQ3348lNhjZVcR5QQKF1iFPewPwvKUiR0FUgPToYDvVqMDVl1NuKTkIiB8N23sivM4IA5eMjov2AunhC4dyCRsXyztrwePrttDmjL4MFRiRhsvfgK2txRehiTN8ADuRoRWMSmJeh/79me2R0GtoY+TBXeMe9CWAaa10ScE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745325312; c=relaxed/simple;
	bh=TxNSpVZrmGUT75l0Odp+XjOHSScPv5iO3hU3QJpZrL8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p4clEOXi2XPERAGweSHdDpICCHeYM898cBSeUnp+QUVl8okdMOWWVE6Y+eVL2UYYS4r1Vl+jOav0Ydn5wDoxJi/1e39FTN6hbOvDIL3Jxy739urZNzF2ZJq+1O/U01H7fY9cdyN32kZ4SOdrQZ8s3LDZa4Ig3QQnHr+s7qXrTgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hRxvcdxp; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=uYayvLFS; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hRxvcdxp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uYayvLFS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745325310; x=1776861310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TxNSpVZrmGUT75l0Odp+XjOHSScPv5iO3hU3QJpZrL8=;
  b=hRxvcdxpV/xhBPEWKRQlhgqKYxvFdAHWgqoyLnzpWEMVpWOPve4pn8eE
   hXg5hLkKYRtICbIN0zMdtZG5M9UWVPSsXdJ5dTxsg7+EzyA4nLFZc8DUZ
   u2hhnpYT18j8nGoAZ0d6PvI2+2SMQbkhZ7uOMPt67NRJXRO+ceNhQgodu
   VgKDwFGEkKa6s6IYlqQBUoUi8ZAFdq2z+/W0jJzVkyVzK2OBWrBXUOHAp
   Qh4ptwReHI2oHXmkLDLyDMP34RdbJo32sXg1HAKxYLKN/UrtRQ5vy1NwD
   uV7yi7gGDCCC6KugjdBJASEBcUsnUYq4MpLQQx6HJLQe7XarJdwY+Noe5
   Q==;
X-CSE-ConnectionGUID: IOV0JD/8Sf+J6dU7DQZ0aA==
X-CSE-MsgGUID: k6zQnjyvSX6KIIYzJLDS9g==
X-IronPort-AV: E=Sophos;i="6.15,231,1739808000"; 
   d="scan'208";a="77446075"
Received: from mail-eastus2azlp17010019.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([40.93.12.19])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2025 20:35:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xyT4HqxZG3pH+ShusWbIQDzAHn8uGEqe8o5kdyOi/wvd0XgtV2oK0L8KYPctN7N2hKKMycOQMBEm/I2W+8tBeP08fTIoWRAiViqcArpIeoivgZ6gZXxPXQ8jKXC+vR+Bs1n7uK3JO5iqOx86vUCaEhYdzow687euaruDNoivRCXN3wpKf/J78u7PqDjoGOTAFezWfPI6gzO0kiVp3syp0WvfvpZZoa8+rZTFpgNgGtYpDCzFWHViiICHrrEhvGf3hLfjpUQ7IM/Y+p5pG6Yefx+OShqmvOnjx+++6sYw9VQjhlkxgQrrV/8DXyqD7w9GPY7fCVWFvfsqLnqNbqvyKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TxNSpVZrmGUT75l0Odp+XjOHSScPv5iO3hU3QJpZrL8=;
 b=Yg1LVrEi4AlJ87fsOk5MEFso1w/hwL+KEVU0vgBlc7w9oW8N0ItIC5usSri60eTthBb1r7O/Y9+Io+tItme6Z/n/ksNAzBfyAV1e4NH8cJZ8FDAaya2XO5sZ4BFJXxavSbnFjYPHoXlu5rx6/C21lUu0Cey8S8O9T+rGFEyLrU+UGSaeHxCut+HEljSpXTgpJWQ0+xXrWHNMwnwUalBARi/HMD0eNvioFG3vMI+M6Jht92yyComxCH6Mo6LpgLqLUxrpm+m5rmq0fZmYQ/omsxOtjIzg3e5b0Wx85NAnAAlLHqi1j1DW8UB3ttqrHshpx80Wa5QmkYPKnFis7SmuSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxNSpVZrmGUT75l0Odp+XjOHSScPv5iO3hU3QJpZrL8=;
 b=uYayvLFSsCGFEwBLGhZN1ILzFidIF/1EvcJsohi80ts62h+R0hbd8lIk13IyWvFvXDSHYdAG2vOFlG074lU+TVgJ2a9GiKunvR1aa7Cq39KrM7rSP8yVzR4ram9C/0Zd7huY3mdAztATMR17qAfKBrnbYq0wov6zSxhmeLwdCL0=
Received: from BY1PR04MB8773.namprd04.prod.outlook.com (2603:10b6:a03:532::14)
 by MW6PR04MB8872.namprd04.prod.outlook.com (2603:10b6:303:245::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Tue, 22 Apr
 2025 12:35:04 +0000
Received: from BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5]) by BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5%3]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 12:35:04 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, "Darrick J . Wong"
	<djwong@kernel.org>, hch <hch@lst.de>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove duplicate Zoned Filesystems sections in
 admin-guide
Thread-Topic: [PATCH] xfs: remove duplicate Zoned Filesystems sections in
 admin-guide
Thread-Index: AQHbs3yxy7ODo4rBHkGtk/rGTzlD5bOvmBKAgAAG5gA=
Date: Tue, 22 Apr 2025 12:35:04 +0000
Message-ID: <7df3bda8-7450-4446-b810-ada1aaa8d5f2@wdc.com>
References:
 <_RxmFF7sLGc26Wr0UDPdK5Mxv9AicUnbJ2I5Cji6QZiiHz5pr9uYx7Zk8xOeDutTUsJvS143LlYYxoitgsEEGA==@protonmail.internalid>
 <20250422114854.14297-1-hans.holmberg@wdc.com>
 <dhowchhm6zfb3hir76tmbmunadqobbkmgaa5uardswon2keggy@3bgfjikvj5sf>
In-Reply-To: <dhowchhm6zfb3hir76tmbmunadqobbkmgaa5uardswon2keggy@3bgfjikvj5sf>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB8773:EE_|MW6PR04MB8872:EE_
x-ms-office365-filtering-correlation-id: 723868ff-8f41-40fc-e34a-08dd819a1bbd
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QjNPdGUvZXlSTzMxYTkwM1lqWHB3R2ppcElaSzhYSDFvMnh5UzQ4aTR2Zkxi?=
 =?utf-8?B?YlVBQ2hoMnF5dFZVSVQ1K3laNnB5bHdTNklid1BhSzBGNUt5MThERkhkKzVi?=
 =?utf-8?B?dUN5UDBGWEVKRXRCUm56M2ZteTRlVUJxUDRKK21Ia2VxeGpKWWxSL2RMU1ln?=
 =?utf-8?B?WG5NVk5janRPTzkvM1hQVDQ2WWowYzk2VThkUTBzRHBBVW1sRGlzRWtXa05O?=
 =?utf-8?B?ZmZGbWRycEdpVWxVdlpzQnNjMXVqNlI0Um9CNXRzb1gxVnlJS0VQTVV0OFF0?=
 =?utf-8?B?TFBqUnNlMUduVmFiY2lRQk5uRDBwZ0JIc2ZEd2ZHMGp2c1BaMUphd29VVS9j?=
 =?utf-8?B?V0RaWU02cDRjZHE4LzFwNlUvNFZ2WnZhdnZwNVdYRDZKTEdmcTYyRjBURzRR?=
 =?utf-8?B?a2dwRHhxMkhrZTh0YmpRZjI1VGNRWk9uV3FWSG9RbDVjZHhSUTl6L1BHc0J3?=
 =?utf-8?B?bGNJWWYvbzZnNUg4UHFoQ2VwTW1qZ2YvT3VuU3ZqT2ZRRWt6clNCd1EweHJs?=
 =?utf-8?B?NW13T1RKMy9VSDlkTEZXZGtTQlU1THRlMUNsU0dyTXcrMmJ0UDBLRlE5RFBl?=
 =?utf-8?B?a25PT25sOXpoS1puMkJNb0ZhWE5xSXlkdEZkdDcwYVFsTUErMVBrbkovYzRL?=
 =?utf-8?B?eEptTlp0cFpNSXpTWjNORVpmSHRLd01uMXlKVnJ2WElXeFIxbTlyaG5SN0lU?=
 =?utf-8?B?UUxzNGp4aFk4cGdiaExZTUxOaDFLa044UmtwZFVteWtOQ3hvREl0NjVDTno2?=
 =?utf-8?B?N012V0g2dWdsTWhMNUE4eC9RUU41Q05rTnY3SjFXY3QyWWR4WDEreEI2S3c3?=
 =?utf-8?B?VGpIYjJwN3d1aUlERTAyaGlTOUxaUmhyZ0xGczBza1lla040T0NsVlU1dUJU?=
 =?utf-8?B?ekZpQXN4WGlGQWdqM1V5TDhuN2pBVjJMKzRra0xIQ0ZyQ1lKSFN5aDdCRFdr?=
 =?utf-8?B?UTRQOWVhOGtUaDJvdCt6Z3FNSG9jd2R0eWt5NUhwTXp1NDZlTDhNMWRyV2FF?=
 =?utf-8?B?blZmYzZrUEYxUWpLakxqMldNbmZ4REFvc0ZETXhzL2ljc3NuV0xOZU03WlUy?=
 =?utf-8?B?OWpCUlZ0a1pHZkFWcmF1TXNoaUpFVkNTYlpucjBaMUw4d3c5YUkzY3p5T1JT?=
 =?utf-8?B?My8xNUtaTzFYbjRnbFRGdHRsSWRlc0cyWFhLRFo4MUZISm5lNDNESnE0Rml3?=
 =?utf-8?B?N0NQOGd1SWlCeFBGSEIzeHlTUFR5SzdhMjJEWE40RXBXT1ZVUVd4THY4NFVN?=
 =?utf-8?B?d21pY1VQZXFDbG5YSmJma1QwQkJ4QzJIMEgzcC81WWFseWY4Um5jZ2pIZjhR?=
 =?utf-8?B?OWFoOWFWdXgvaWJzWFA3VzlnQVhYallFNHVVTFkwMjRkSURxcDhueUpqTFJD?=
 =?utf-8?B?eVJOSk9aeTlvRE1mTXVqaGF6TG5aSUtkcVhYSlFzTTZHcWJNUk5wbDgrYldx?=
 =?utf-8?B?WmFSdFpabzBlSXl6UTlLWkJRTnRzZUtxamZoOHV1MkJYQkhFWS83ZVVJeG42?=
 =?utf-8?B?Z3dEOVdiVDFCcVd6Lzh0eCtQclp6RzVDMjVFOXVXMHF2REVUUWVKcEJWQWZl?=
 =?utf-8?B?RG1IK1ZiTmtZQVJJYTJyVlBBaXdlczFOdytMSjQxWit1TEVoUTg1MmlOSEFU?=
 =?utf-8?B?MCtWWkxTMDNUK3gvQmFWaGpRSzNHRHBBMmlpOXNwR0lONEplbXR4ZEVWMmVR?=
 =?utf-8?B?Rys1ZXFyd0tWS1JMRWhQVVpGQzJ5dWNqdE9QUWNpbmE2WlRja3lWUlJVdXpX?=
 =?utf-8?B?bCtSSGdVNjZJQkJGMjFobEFONW51eS90bXlTNXc1NDVlYUg2T0tTTVlOa1NQ?=
 =?utf-8?B?bTBaN0w2V1NMdWRyaFF0UlJaRkRoelphWFN2Q0xmRjFOQXJiUmFyQ1FRRGE3?=
 =?utf-8?B?eVZmQXI4dS9qZFBITWp2blZGTDZYd2oreFM5Zmh1NldFeEN3TFk0S3dNSC9B?=
 =?utf-8?B?TFRNV1JOeXEvSktyTUpPU3R6NnYxaHphYU9QRzc1dHd4b2VLL2xPcllVS2Nq?=
 =?utf-8?Q?ck4Y7UdCVdOgx90P1tHbd2PiCHdEbg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB8773.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QXBIdzMxcW8xOWVhelRRaExGVWxqMktQT2ZSUGNZRW90SVpzTEVheDVhZ2pD?=
 =?utf-8?B?YW5NM1I2c0lTdEJHRW9adUcrY293NXJiRGZzSGZyVnhjM3l0d1VqQW9NMEVQ?=
 =?utf-8?B?Ym1ZdmVLUEJTZ1Mxd0dGdmx3SStQTUlETkVMYTdGZWVIT1krNHkyUVZNV2R2?=
 =?utf-8?B?ZktBNEU1OUxud1lYby95YmF6K0JSbmM1d21MV2hQT1JDTlBiOSs3NnVQTWtD?=
 =?utf-8?B?M21abCtrQWRxNFdnQXF3UGtxTzlrWW1jc2c2WEZVc0RIM3d5eFNDYW4yMFFh?=
 =?utf-8?B?R09JdW4xdjZhSGZjVWhXVlBKLzdPVTNjYnlSWFdKcXVuRXB6b0t2cldPVElK?=
 =?utf-8?B?WW1ONDc4MFg5L1prZ2tORzB6a0l2MjU3Vi9YbW5QM2cxTFdWeTM0a081Qjlj?=
 =?utf-8?B?aWRtK1NiZVFmelZIWFpEWm5FcDJEQlFFRVVYcGtHT0RreURHaUR4YWtGUDFu?=
 =?utf-8?B?ZUVOTmJlZGF5K3VpWWxxV0NvemJSTGI4WHdOemJydWlMYkF0WCttSERMSTQ5?=
 =?utf-8?B?bEZIelhrK3RqTjBnWDBxb1ljVE5JQnd4VW5iZlN4Y0J6SDdhNWdGZmNrMCtI?=
 =?utf-8?B?dWRSd3IwZmFpYlRiL2Nkemp3MENLRS9kWVc3dDh6Z0FQeTFEc1d3YlQ0TVNw?=
 =?utf-8?B?QmQyNncxdGc1NUIvditVckwraGJaMDNJZFZaczJvMmJoejM4Z29xNS9YbmRn?=
 =?utf-8?B?VDBsQ2h6Y3h1U2dHM1lUOWRNYndrRmlyYk4vbGVmbjh4RXRrRXlLWDZrVS83?=
 =?utf-8?B?MzBJcDVsd096RGFhRGRqa2J6TXJBU29tNXFmeko0UU9uNDNtUFZ3VHVBWDln?=
 =?utf-8?B?UVljT3NoVjlsb0N2SE5WbFZRM0pWeUhnTFRkT0c0MHhjZko0NFFUcFBLT2ZX?=
 =?utf-8?B?UEU3NnM0d1BMV041OGtGVGl2N1A3RVFhaU5VLzJMWW5UeWwvRkpVRkErSFhk?=
 =?utf-8?B?aG5hUmJOS255eGJwOEJONXA5R3JxaXozZkN0RnJKQkVVTEc3RU1aZmdnYnJu?=
 =?utf-8?B?SXRDVzVJc1pubXlJcXh0L005NnFZK1k2ZVZTYkZnQlI5RjdmcVAxMk43NENu?=
 =?utf-8?B?RUhMZVRIRDFWbWRSVnNTS1VsSWpCOERCNS9MWnB4NzFiaHhZZXF3WWcwMTFZ?=
 =?utf-8?B?S2p3WkhrNEpmVjI1RmJJOGJPVGpCblBGd0Z1NDBNRHhYSzBOUFN2V3lGUE90?=
 =?utf-8?B?UHVZZ04yZSt4aVVoSzlHdE1ma0NQUG9Gd0g3cTZ3WFpXZmxZVy9lVGpHODNq?=
 =?utf-8?B?VllBbWhaT0c2dnlNZWxlZVo4bXhSdTQ0U0E3VWc1dXhkb0JoNE9ZemFlYUdh?=
 =?utf-8?B?cG8wZnp1Ui9yNWFCR1Z3SnFwQXdqaFIzV0M3Q21ncms1aUUvaitteitxNmFY?=
 =?utf-8?B?ckp3c2UyUEcwWjFMUUdPVXZ0aDRsSTRrUnZ3MFlnSnZXK2FkSHAxUXAzZzlo?=
 =?utf-8?B?SU9sOTgyOVFiL1JFVjdQVTRkRzBQZHM2R0tuRzFEemtsWlM1VFNPSzVPUTVs?=
 =?utf-8?B?QzNQV2JIcTR6SU92aGcrTm9Ec2VGUnIrWGNFR2VEVjVCYzFjZ2piVjVoNUFm?=
 =?utf-8?B?TG9ydjUxbTBGUElNYVdDYkxhMmNUZTNDcGxlRUp0c0ZhVHFZVCszUW9NcSt6?=
 =?utf-8?B?a3pFSVZSRDBSS3NkU3hmclhZdzBoMUkvUC9TVG1zZE1xbUNkQmxGRmtuMjZF?=
 =?utf-8?B?SE9KZG55ZW1lODlKSVJNSlZJMVlzdk1MV1pqSDloN1JLbVBmSGx3U0VBUkFt?=
 =?utf-8?B?eFFlWDh5RS9FVyt5L09qMStqNjltajVpbEs4bW5wV1hPTkNkTXY2bnQyRnV3?=
 =?utf-8?B?WGFRS1VtQW8xR3VnS01DeC9mQlpFaHNVQ1A4UG1WRnM3MnhoUDYrUHd5VG10?=
 =?utf-8?B?aTJUeWVhY2x5Z1I3TkxFRGwzdlZ3U3FqcEd6Z0VwSnNCaUp0dVpsWkxsYnJR?=
 =?utf-8?B?YlFydkpIam9FN09BcnAyYS9sNTNYN0tOUzdoS3liMnMxaXNuQlo4bnRpckFk?=
 =?utf-8?B?RWVaTlZ5K0c3R2VVNnE1N3RoYkQvT0tablUyMFRSY010cEZvZkkzQTNmY05X?=
 =?utf-8?B?S05ZcDdCK1hsblFqa2JJeWcxWFVpV0F4dzNHNVdxNHlzYTMyUHhMcWFWZXdO?=
 =?utf-8?B?cmpCbGhoRlNmcitlTWY3My9UdVBqczEzYnl5a0premFiUUl3d0VOZ0lRYWdF?=
 =?utf-8?B?OVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <027242E98011644D8EC135460BBF7D1E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BIveWdvvhgzn/qPmJWW56i0hG5BqBsFgrZ5DAdy7/ZGWO/Ds6Iduh8dWe6JiZTHwExXIUFSiL1QdZ2ru73EXDDEgDqd0PB9uP9wW0dDqQBZSUPOPY1QeN0MIRim3lrpRuGFmgJI3t5I89AvPzgieywG2ypnM1ON3QdH+X8w8KwvspuVsKzhNcP2NnWWZgSpZY2guTwycAoTARfaWvsS5uZFWGltfv51ogU7ahCzHqxeqQgZcb341iZISGe7qIMQzIvbhHf7eOmUtmHJB4hvCMRWYHLN9GaDc3Gapm5ri2WprNevSkoQSznb2bsShIV1N9bcUBXksfP2Kg8A9GBmEoRUw0B80MoCWDqzseYBmN5uwtp/dZMnZ8MVI11A04xniTee3/Zj/gfBNTT4j+V/dBdGoMOUFTUI5PbZv9AzIABnGwppHxfUDRIkFO0FBKxaldno0++IxqjLNkzfHjroT3iXR0aIartufpFWwF73SS8DNLy2/Cy/rjpX03hxHHgEsKuoKaj93ZC6x1lj40oyrcqfJ3QAYWZlaPXXfe1hIaZ+JA3clkpOhHB0xRb48XVxi5Ps1KMJOwnAhm4ZLP/46I7jeMC5zt9gYKzhVlK9927tZz+dY5hN22uWEWYJ5/dW1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB8773.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 723868ff-8f41-40fc-e34a-08dd819a1bbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 12:35:04.6407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lG5hUdQ3/egyBmPFDAlE6Hji1E/H56xT2U8r0ygFTEn04YAzUeTgM4II5g1KYZxIYChPBwf6FHGoIT986QY7wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR04MB8872

T24gMjIvMDQvMjAyNSAxNDoxMCwgQ2FybG9zIE1haW9saW5vIHdyb3RlOg0KPiBPbiBUdWUsIEFw
ciAyMiwgMjAyNSBhdCAxMTo1MDowN0FNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4g
UmVtb3ZlIHRoZSBkdXBsaWNhdGVkIHNlY3Rpb24gYW5kIHdoaWxlIGF0IGl0LCB0dXJuIHNwYWNl
cyBpbnRvIHRhYnMuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5o
b2xtYmVyZ0B3ZGMuY29tPg0KPiANCj4gU291bmRzIGdvb2QuDQo+IA0KPiBSZXZpZXdlZC1ieTog
Q2FybG9zIE1haW9saW5vIDxjbWFpb2xpbm9AcmVkaGF0LmNvbT4NCj4gDQo+IEhhbnMsIEknbSBh
ZGRpbmcgYSBGaXhlcyB0YWcgYmVmb3JlIG1lcmdpbmcgaWYgeW91IGRvbid0IG1pbmQgbWUgZWRp
dGluZyB0aGUNCj4gcGF0Y2ggYmVmb3JlIGFwcGx5aW5nLg0KPiANCj4gRml4ZXM6IGM3YjY3ZGRj
M2M5ICgieGZzOiBkb2N1bWVudCB6b25lZCBydCBzcGVjaWZpY3MgaW4gYWRtaW4tZ3VpZGUiKQ0K
DQpUaGFua3MhDQoNCj4gDQo+IA0KPj4gLS0tDQo+Pg0KPj4gVGhpcyBmaXhlcyB1cCB0aGUgd2Fy
bmluZyByZXBvcnRlZCBieSBTdGVwaGVuIFJvdGh3ZWxsIGZvciBsaW51eC1uZXh0DQo+Pg0KPj4g
IERvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUveGZzLnJzdCB8IDI5ICsrKysrKysrLS0tLS0tLS0t
LS0tLS0tLS0tLS0tDQo+PiAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMjEgZGVs
ZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUv
eGZzLnJzdCBiL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUveGZzLnJzdA0KPj4gaW5kZXggM2U3
NjI3NmJkNDg4Li41YmVjYjQ0MWMzY2IgMTAwNjQ0DQo+PiAtLS0gYS9Eb2N1bWVudGF0aW9uL2Fk
bWluLWd1aWRlL3hmcy5yc3QNCj4+ICsrKyBiL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUveGZz
LnJzdA0KPj4gQEAgLTU2Miw3ICs1NjIsNyBAQCBUaGUgaW50ZXJlc3Rpbmcga25vYnMgZm9yIFhG
UyB3b3JrcXVldWVzIGFyZSBhcyBmb2xsb3dzOg0KPj4gIFpvbmVkIEZpbGVzeXN0ZW1zDQo+PiAg
PT09PT09PT09PT09PT09PT0NCj4+DQo+PiAtRm9yIHpvbmVkIGZpbGUgc3lzdGVtcywgdGhlIGZv
bGxvd2luZyBhdHRyaWJ1dGUgaXMgZXhwb3NlZCBpbjoNCj4+ICtGb3Igem9uZWQgZmlsZSBzeXN0
ZW1zLCB0aGUgZm9sbG93aW5nIGF0dHJpYnV0ZXMgYXJlIGV4cG9zZWQgaW46DQo+Pg0KPj4gICAg
L3N5cy9mcy94ZnMvPGRldj4vem9uZWQvDQo+Pg0KPj4gQEAgLTU3MiwyMyArNTcyLDEwIEBAIEZv
ciB6b25lZCBmaWxlIHN5c3RlbXMsIHRoZSBmb2xsb3dpbmcgYXR0cmlidXRlIGlzIGV4cG9zZWQg
aW46DQo+PiAgCWlzIGxpbWl0ZWQgYnkgdGhlIGNhcGFiaWxpdGllcyBvZiB0aGUgYmFja2luZyB6
b25lZCBkZXZpY2UsIGZpbGUgc3lzdGVtDQo+PiAgCXNpemUgYW5kIHRoZSBtYXhfb3Blbl96b25l
cyBtb3VudCBvcHRpb24uDQo+Pg0KPj4gLVpvbmVkIEZpbGVzeXN0ZW1zDQo+PiAtPT09PT09PT09
PT09PT09PT0NCj4+IC0NCj4+IC1Gb3Igem9uZWQgZmlsZSBzeXN0ZW1zLCB0aGUgZm9sbG93aW5n
IGF0dHJpYnV0ZXMgYXJlIGV4cG9zZWQgaW46DQo+PiAtDQo+PiAtIC9zeXMvZnMveGZzLzxkZXY+
L3pvbmVkLw0KPj4gLQ0KPj4gLSBtYXhfb3Blbl96b25lcyAgICAgICAgICAgICAgICAgKE1pbjog
IDEgIERlZmF1bHQ6ICBWYXJpZXMgIE1heDogIFVJTlRNQVgpDQo+PiAtICAgICAgICBUaGlzIHJl
YWQtb25seSBhdHRyaWJ1dGUgZXhwb3NlcyB0aGUgbWF4aW11bSBudW1iZXIgb2Ygb3BlbiB6b25l
cw0KPj4gLSAgICAgICAgYXZhaWxhYmxlIGZvciBkYXRhIHBsYWNlbWVudC4gVGhlIHZhbHVlIGlz
IGRldGVybWluZWQgYXQgbW91bnQgdGltZSBhbmQNCj4+IC0gICAgICAgIGlzIGxpbWl0ZWQgYnkg
dGhlIGNhcGFiaWxpdGllcyBvZiB0aGUgYmFja2luZyB6b25lZCBkZXZpY2UsIGZpbGUgc3lzdGVt
DQo+PiAtICAgICAgICBzaXplIGFuZCB0aGUgbWF4X29wZW5fem9uZXMgbW91bnQgb3B0aW9uLg0K
Pj4gLQ0KPj4gLSB6b25lZ2NfbG93X3NwYWNlICAgICAgICAgICAgICAgKE1pbjogIDAgIERlZmF1
bHQ6ICAwICBNYXg6ICAxMDApDQo+PiAtICAgICAgICBEZWZpbmUgYSBwZXJjZW50YWdlIGZvciBo
b3cgbXVjaCBvZiB0aGUgdW51c2VkIHNwYWNlIHRoYXQgR0Mgc2hvdWxkIGtlZXANCj4+IC0gICAg
ICAgIGF2YWlsYWJsZSBmb3Igd3JpdGluZy4gQSBoaWdoIHZhbHVlIHdpbGwgcmVjbGFpbSBtb3Jl
IG9mIHRoZSBzcGFjZQ0KPj4gLSAgICAgICAgb2NjdXBpZWQgYnkgdW51c2VkIGJsb2NrcywgY3Jl
YXRpbmcgYSBsYXJnZXIgYnVmZmVyIGFnYWluc3Qgd3JpdGUNCj4+IC0gICAgICAgIGJ1cnN0cyBh
dCB0aGUgY29zdCBvZiBpbmNyZWFzZWQgd3JpdGUgYW1wbGlmaWNhdGlvbi4gIFJlZ2FyZGxlc3MN
Cj4+IC0gICAgICAgIG9mIHRoaXMgdmFsdWUsIGdhcmJhZ2UgY29sbGVjdGlvbiB3aWxsIGFsd2F5
cyBhaW0gdG8gZnJlZSBhIG1pbmltdW0NCj4+IC0gICAgICAgIGFtb3VudCBvZiBibG9ja3MgdG8g
a2VlcCBtYXhfb3Blbl96b25lcyBvcGVuIGZvciBkYXRhIHBsYWNlbWVudCBwdXJwb3Nlcy4NCj4+
ICsgIHpvbmVnY19sb3dfc3BhY2UJCShNaW46ICAwICBEZWZhdWx0OiAgMCAgTWF4OiAgMTAwKQ0K
Pj4gKwlEZWZpbmUgYSBwZXJjZW50YWdlIGZvciBob3cgbXVjaCBvZiB0aGUgdW51c2VkIHNwYWNl
IHRoYXQgR0Mgc2hvdWxkIGtlZXANCj4+ICsJYXZhaWxhYmxlIGZvciB3cml0aW5nLiBBIGhpZ2gg
dmFsdWUgd2lsbCByZWNsYWltIG1vcmUgb2YgdGhlIHNwYWNlDQo+PiArCW9jY3VwaWVkIGJ5IHVu
dXNlZCBibG9ja3MsIGNyZWF0aW5nIGEgbGFyZ2VyIGJ1ZmZlciBhZ2FpbnN0IHdyaXRlDQo+PiAr
CWJ1cnN0cyBhdCB0aGUgY29zdCBvZiBpbmNyZWFzZWQgd3JpdGUgYW1wbGlmaWNhdGlvbi4gIFJl
Z2FyZGxlc3MNCj4+ICsJb2YgdGhpcyB2YWx1ZSwgZ2FyYmFnZSBjb2xsZWN0aW9uIHdpbGwgYWx3
YXlzIGFpbSB0byBmcmVlIGEgbWluaW11bQ0KPj4gKwlhbW91bnQgb2YgYmxvY2tzIHRvIGtlZXAg
bWF4X29wZW5fem9uZXMgb3BlbiBmb3IgZGF0YSBwbGFjZW1lbnQgcHVycG9zZXMuDQo+PiAtLQ0K
Pj4gMi4zNC4xDQo+IA0KDQo=
