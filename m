Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41422AD0C;
	Tue, 10 Feb 2026 06:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770703535; cv=fail; b=GPLYx6M8VD8oAHgD/93MdovijfSXK/P2nU/53883cxGN20wIKHANSuG8PokkzcHOPtkmlHYzUnIeq9QgZC5C9ZVBhpRScDoxk7IHeEmy8VYG0jR8bgO4ruZUVp0Vp1sai8zbv5N5ktPqhQqfDFZWseXTKwB+xpvBrxdX0/V1cc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770703535; c=relaxed/simple;
	bh=iQ3CCEjFPzW8x8GZtwoCEds/9PaFaClx5vNUKoONo/0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HKqBze2Pi0itM9MvytbnflKKq4cBFN2k8Czl6dSHJjxI4qhsyB7QlPih45g+6ts+IUuAcLgoVITd/409OTPplSk8PTkZGAsXej5Nw978LQMHSmmap32h/tEPZ3ku+EW8Tjzbo1L7Rx6rkHPxM8pCbf9l8jLtBXhlYKbP53rZa2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lAEpOf4a; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wT998pEC; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lAEpOf4a";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wT998pEC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770703533; x=1802239533;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iQ3CCEjFPzW8x8GZtwoCEds/9PaFaClx5vNUKoONo/0=;
  b=lAEpOf4aTiXyEvAQjjEGwNZQkMmzWBj+ELitljzxCy0H6Qp3cxP76SCu
   HHdnKots5lb0N3LQmkNyq5Rd7iGOvWI65wO8fu596WKS0yghMqRx40bqe
   a9+560Ux1pSjxYyQw0PLEx5MlCkZjYqLzya74U0H4Cayr9Jwh8/vvloXE
   hkpXbqYnxR33OoRshHrMg9U0CPjb7PbR+BUYHWL0EobJ2tA3ofR1Z59A3
   Uwa1KCU4d02v1cnGJhmv8SFWXqeP8HO0oYouEgBk+9mZGkDzWdRkzdKs0
   rYGC+7h7+Q/Rnyf07QV5fIHZSY8dejotBKhkGXscpGNWVWw4sNxXD+zGj
   w==;
X-CSE-ConnectionGUID: F+vhAaJrQ0qz/qSptQKhXA==
X-CSE-MsgGUID: OgcH0f4DSMCzPaLmQFev8g==
X-IronPort-AV: E=Sophos;i="6.21,283,1763395200"; 
   d="scan'208";a="140108018"
Received: from mail-westus3azon11011023.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.23])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Feb 2026 14:05:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jPz17MygxwjqBGtQZIRjhX8TKOfqXrwNo13wJ5zncwfeiYsnqxdSp3xCc7EmK4VMp0JGj5b2XFvYdxLDWiS0MZIHqX7HGIOYEoGTG9RufR1b0ABswuB8WizAZUH0PO5cCjJGOe/pEzp+slO2UDTfTw6qlGf+SyevfjOeOVkWj/hzKtVOovkpAY2KszrTt4pYsxVC1jKpcxx1gWD/SkUgob0tDgfFA7dSigMZWCevjJyHX6dDEsc5qX4L4xuiQOkitqfCsYUWZKMjfr24gk3nvOY8G1YxCOdgr0Y1ZztMAG8/becnFNJRuCn+fmWP9y996l3uNO2jTboy9WkWzpKNIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQ3CCEjFPzW8x8GZtwoCEds/9PaFaClx5vNUKoONo/0=;
 b=swX7R0dz3pnANnviLbrTdC/ZQ4W1v1jMGtLeMaRbfFPZKMZ1WtO80MTS/X++eLwfYIMVi8dhyh8DKpGIgdFcNORJNF2samZ0NBRjFdeCaB4aef1qxDDrfCYitxf2f0+7HKZt+Ecfl+fP1EdeMyYA3NxgUYq9M92YvxZE0q1UqC4n8QW9lRaeqUKVv1hgwaQoP3SJAmsExjipQzBM/7NiIGxydnHuxECEguO11aOVEGGxEgJ4Ui4IHvBA1hu9OKElrVeemTJ4hTyzPbHYkqRtF4GEjDftpdQUQKCkp584FAmsJVLIbPMmlCU7pTbb2egprfzOTUHUaZUHYrPUMSegpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQ3CCEjFPzW8x8GZtwoCEds/9PaFaClx5vNUKoONo/0=;
 b=wT998pECAOEtUZrppXJ6OntDxMRLkOJveyBUvLqYa9bz2Z3Z/rs9FxW0dE48fTI6GQksaUn3RNHq2ibWm+Y3zBl+1hdghMaI0nKVFwVUIj4Oh39afIDQm+7+yl6DzNSevkJga5hCNhPumMMdiFpNkDgSG1jguBuynqFcZJn/O+Q=
Received: from SA1PR04MB8303.namprd04.prod.outlook.com (2603:10b6:806:1e4::17)
 by PH7PR04MB8974.namprd04.prod.outlook.com (2603:10b6:510:2f7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Tue, 10 Feb
 2026 06:05:30 +0000
Received: from SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1]) by SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1%5]) with mapi id 15.20.9611.006; Tue, 10 Feb 2026
 06:05:30 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: "djwong@kernel.org" <djwong@kernel.org>, "cem@kernel.org" <cem@kernel.org>
CC: hch <hch@lst.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] xfs: add static size checks for ioctl UABI
Thread-Topic: [PATCH v2 2/2] xfs: add static size checks for ioctl UABI
Thread-Index: AQHcmlKUuwuaXwmyIE2vz7SnVsgJkbV7cd6A
Date: Tue, 10 Feb 2026 06:05:30 +0000
Message-ID: <381ba346b12775a2f3999e499311a1941d0c7589.camel@wdc.com>
References: <20260210055942.2844783-2-wilfred.opensource@gmail.com>
	 <20260210055942.2844783-5-wilfred.opensource@gmail.com>
In-Reply-To: <20260210055942.2844783-5-wilfred.opensource@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR04MB8303:EE_|PH7PR04MB8974:EE_
x-ms-office365-filtering-correlation-id: 0f3fb06f-fc03-42fa-3a8d-08de686a6521
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VC91YzVZMEpnWm5Wb3pxT1B5L1piS2JTV0NFSG5KZ0FHcGY4QnJnQmUwYnZu?=
 =?utf-8?B?VmVFTERTS0t0MUhmeWZKZnhwVml5TDgya1ZDMlJvOFBoL0pnOVZxeG9YNTF1?=
 =?utf-8?B?Q2hCcFZvMEx2MlZaUFJvbEpQNnlNRy9VRWhFYVhmMGFlNElHam0zOTZsbVpy?=
 =?utf-8?B?Y1lQUWVUUzVyNG5KcmtwTnVSeWFPelFoTE5rZytBTUZxOW93WVhZSHJkTVdr?=
 =?utf-8?B?eEFSbVdUUHBJTFFCWVMwdnZTR3ZiY2ZZY0k3bGNWNUlYRDd5NHBJV1Noai9m?=
 =?utf-8?B?YUJGajlIRDVodSszTURRMDVSdzcrYjV5VXptK3NaQmFQWVZPd2lFeXhVRjZ4?=
 =?utf-8?B?TDZTdDMwcmNBRnVpQmdIb0p6eXpVY1VTaHpJZk1nUkpLMjRyOHBkdDdOQVV6?=
 =?utf-8?B?Zkx0amp1cklUMTdBUmpFVzBWbDlrVEl6VnE5OVEzcUZNYmo5RVNjSFpPbjFM?=
 =?utf-8?B?Wlp1MmFHaXE1Wml2ZjJoTlIwbGlxamJGYkJaWVZWN2ZGdElvRWFpMEkxRXBq?=
 =?utf-8?B?ajhMbFNFY3hvS1BtMnZYV1BVS2kvc3NCem9TYzIvNmxycTNDbUtLKzRxYnNp?=
 =?utf-8?B?bnk3R2xmTHpVcXVMT3pncXV0YXJXNXd0QkFRUmZjQVZYb0hIbnZXd1Bpc01q?=
 =?utf-8?B?Sk1pZFQ3SFVmcVhzNjVYMExjYmNuZFFrR09kUFp2NjVyMzVmUjlJaGVyUW9s?=
 =?utf-8?B?TXVHb0ZyOC8yeVBKYm1qMlVLazdnOVNWNHVhV2Nvb2RYMlZpUlF2c28yUjhK?=
 =?utf-8?B?NU9EWjZ0cEFSdUV0NEpXa3pwYXNBWXdKSjdRbVZKUjhiL2l3R2NVOEFIalN4?=
 =?utf-8?B?U1drZE1lbktpaVh3RllYbzNJakhMeU1mYWVOUStDeUxEeE1rbkFEYmhJT0Vx?=
 =?utf-8?B?WWRLanBjOGhvbUhhS0lsb3h4cTdnbGJhR2tDU3pNY0YvVkM4cC94YnJYTGNU?=
 =?utf-8?B?OG5QTnI0WENpbUlEUklMZGxSQ0I1ZGZ6VGlnQTdwK0MzZzNZbUpyeU11Ukoz?=
 =?utf-8?B?UVVVR01kcE5BYXMycGhaR3VwOFg2Qm0yTit2dTJFL25KVDVjNHZpQjBQQW9P?=
 =?utf-8?B?cVZ4Ti96aWpINDhrT2w3TkltdDBQeEpJa0JaamQ5cUNnTUU4REl0NWNmWmRr?=
 =?utf-8?B?SzZMK0kvSk00M2YyUzJITEF3TE5qN1dZbXpBbmtGeDhTYjQvYVlHUjVJY3lj?=
 =?utf-8?B?cjY0TnluS0VaM1ZlS0pZb1pibWdSeG5JOHk3NWE0OVJBeCt2QVhuU2FtVkxU?=
 =?utf-8?B?eVVwOVY0anRBTm9pSk1ubnZGVForaGtXdy9XbU9zMHlZTnloaFYrOFFFaURj?=
 =?utf-8?B?Z2pzYkRSVytaazBTSUdOR0NHdG82RTVnYzVscEhSY285eE1rbC9hblQ4dXhB?=
 =?utf-8?B?RFNINlV2Qm9EYXArdjhad0xzWjk5a213S1lTTDdiRFArclNuK0lpNkFFNTE4?=
 =?utf-8?B?anVBVE9ud1hXaU83K0FZYXo3Tit1SmdmMXpMOUt4ancwdFFaSXRTeDRvQmt1?=
 =?utf-8?B?NG1vaGt1RDZYd2tWQ3pnWGVoUWlQbU1lbUl3aWVMWHZSbnFTNmpvOWduUEtQ?=
 =?utf-8?B?SEhlYTE1ZEd3SDZwdjhGWmIrUE9IUlhxb25Fa2wyYktSUlFCNXlhVWxlQmZs?=
 =?utf-8?B?QmwzSGJpY1VUT1hXU0R1V3VYZ2F2TmFzdjIxL0xoVTd3dEpPWHdiVFN6VGJ3?=
 =?utf-8?B?N2RLQ0d5RXNjZUlLYnZGbWR2bTBCMWxLU3hhdlZiakc3K0RGSEx4ZHpaUWVX?=
 =?utf-8?B?bDg1U0wxbkpJR2VjK1pDT0ExVzJZaTUwTFRkL1RVekpOUFFxTXhoci9hUE0y?=
 =?utf-8?B?VngzUkwxQmZhUGMxK21iTUFSWUVXRUhRalFNRzNZOVcxUkNVMjNEZ1lFSDR3?=
 =?utf-8?B?ZE1DeW1naFdoY0EzeVNWMzFBOFpPK0xzYlpuVVgvUi9LWHZuT0F1MU5zNU1V?=
 =?utf-8?B?ZzI5dzBOdzJhWC9SRWlGSUo0SzhaaDlWdGswQi9nVGtlRjFCMzJaWGdlSkNt?=
 =?utf-8?B?RTl3TEwwOExpWjZVb0ZSU2x0MHpzblRBUkNBUEpTa21od0NDVUtxRnJ1d0lx?=
 =?utf-8?B?ZHJUSHFaQktRQjN2Zit6djgzVVRKVStKY1hUTy9HNURBZ2x3TVNDWmh4UWND?=
 =?utf-8?B?L3k3SWgyZUNxcFlZdXRVTm5UU0pJL1owT2JTSXltYyt5K1dlZjdlb0dHWmc3?=
 =?utf-8?Q?UHCpT4oDSsiEk5QbmMMV2cw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB8303.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SUd5NjNsamx3dmpWVjk3TTMyOFBzL3U4aVZJUFBoSCtSNG43U3l5eFo5Rkdx?=
 =?utf-8?B?MkZTUjVlUHl1ejZmV1I2emNJTHVad290c1dhSEFLR3RhdDMvN1RZQzZYMGRs?=
 =?utf-8?B?eTFJdXBuUWFSL3dkSWxWZEFTb1ljcFArT3JoQ2ZqSERLRjNrM2hPUDBUQXNh?=
 =?utf-8?B?eEcraTZIWW9uY25kMDg5UW9FcUNkSk9jK01TbDB5SitzZkFSdTArN0hYcnhO?=
 =?utf-8?B?QWtGQ0o3eWNXZzFvemM3T0ZKald4bnViQjBrMk1yZFF2L3VQOE0zb01VQ2JW?=
 =?utf-8?B?Qi90UDZ5SXNqV3BFOHgwQlFYa3lmcDRlSjRrZGVkZURXNkQ5VFlLa1JBWnNT?=
 =?utf-8?B?Z01adFhDTUlyNnM1Y25MbzY2N3d5dTNMcUlXQURGRllZeTBvTk5PVDY3TjVq?=
 =?utf-8?B?SVpBRDU3Zko3TzJLVEx1aVdPUGV0cEp1Z0N6VUlPUVRZai9BWmZVVTdTeXhW?=
 =?utf-8?B?VTlST0ZqbGQxNFcwSHdrZEhIMXQ4cDVYbHRGR2JMbHVnL0pDQXdVRU1hNndj?=
 =?utf-8?B?aXNsNG1vWTRnM2hlVVIyQ3orNkZyYXJBTnhpcjNCRFJGYjgzMUhQUzBrYjFx?=
 =?utf-8?B?VTdtOXFZMlJmaEVhd2ozRWV4ZXRjZ2dvQ2dXK1d0dzFKSmpQTzcrZS80REE1?=
 =?utf-8?B?SHpsYVo1RjhiZW9rY056OXV2ci9MajYvSHJsRUFNMHlRanNPY0YwU0liT0JR?=
 =?utf-8?B?U0pPREhTWDh1SGJLQlMzRTcrZDRXYlhsWlBqMXN6NjF1bmVlTFRLQzV5VmJn?=
 =?utf-8?B?WDhjMDlJZklzay8venlTdk9pUkRzRlloTEVVRFJLaW1NUWR5S1c1aWpPdGNi?=
 =?utf-8?B?L0E3K1Z4MGFHbExKazhiclEzSlNUd0tsRE1HV3Y0cTkrc0VxL09rSGxLTUpq?=
 =?utf-8?B?b3Z2VjN6TENNR01TcFFTTkIxSU1reVpKc3JMTVhTMEZuOXZ6ZEhOMzE5cEJZ?=
 =?utf-8?B?M1lmN0g4bi9ZdnNEelJpYVZFYmZ5QnhwenlYUThUekZETEtvdTkwTk9iNHRK?=
 =?utf-8?B?aDQvSkozT2p2SFJFR25VdHZsbHdhOGJJVW81a2ZkcmVWZml2RExkUGFNZ3ha?=
 =?utf-8?B?UXd5cmFldGNZVlo4dEZwaGY3MnYybXBzYmtzaWNOcisvNnpDbDVrdTcrb2pH?=
 =?utf-8?B?YUR5b3BuTkpXSWd0dEpJVDBJL3QyT3BGWnk4aEoxZmQ4NEg3UEVLNUNCRW1F?=
 =?utf-8?B?cElBVFJOOE8ycUtLem9TTGVWWGZxRVlXUzhDN1N1eE55VHJ1VW8ySGMwZGFw?=
 =?utf-8?B?ZkVFUUEwdys0N21ROUdSZHdOd1dsZ3dRcTdMQU5lSzVCcis3cHBWZWxmb1Vu?=
 =?utf-8?B?WG9oUWo5czN5bFBLR2xXZWs4NS9pY1E5clkvc2FWVXVoYXhQSmpWbXltNGIx?=
 =?utf-8?B?YXVYZ0dsUE5TdXcxY0xzNURzQUE0UFhRRFFkTEdtb0VjaTM0V3IwR1NOclk1?=
 =?utf-8?B?dmdWU0xHQmVjcDVEN1NmM2VKRlI0WjhoYi9xeEVKTHVWUUc2R1gzMnQyTzA1?=
 =?utf-8?B?bVR2WUFWeWJqdzVKcENmSEFUUlNSN1IwOWdsV3NHZ2E3elRmN3VTK0M1UVBE?=
 =?utf-8?B?OE0rYlBCb2dOOVVwcmZJa0l0Mi9yZnhFTndMa3c3dTAzbHFuUVRHZTBTODR6?=
 =?utf-8?B?c0Y1QXF4WWV0bU1yb3ZKUTBkSkU4emxqa010eHNPVVFsek5BUDl3cnZaSzVq?=
 =?utf-8?B?N3YzT05lbVJ2eHJrOHlUemQ0N2JRMEhQWktUcUZPRHNxczhra1J1L3p1RFJh?=
 =?utf-8?B?ek5wMUh0U09xUmsxZm1aVm4rOFBFNTl1ZEhxdGpEd2wxeGNkcEJhb2lNOXZh?=
 =?utf-8?B?TnJKOFpqNFVqdkZjU2IxTFllNXJBeHZpd213WElmTTVVVXhNV3RqQlAvai9r?=
 =?utf-8?B?YlRyT1ZkbkxEWFREd0g3SStmdm9Gc1J6Q2NlUFBOT1dzQ05hVGErRUhFOURC?=
 =?utf-8?B?eEFrWG9SOVhCdXBFSkROMU5CNzBFN2F0RWp4TUdKVWoyWWU2ZGY2NWFKMHl4?=
 =?utf-8?B?K0hNbFdFay8vR1RLT3grcWxXSHl2cWxNcnk3Qm1WaEo3cWFlWDk4VFVqbFZk?=
 =?utf-8?B?QnJqZU1HN1JZL2tnUDVoVmFpZDNqL0RXT2NFeFp3aDhxUlAvc1VrckVLMUJL?=
 =?utf-8?B?U2pnUzdOc2FYQ09HRzZrYlpyQzFhTUNjZHJtQ0UwYklUQTFWUVcwalF1Tis0?=
 =?utf-8?B?UG1VUjZWUVdCNTZjalNvZjBmTWhJUnJKWWliejI2Y3RIdE1VcTJodzNRblBk?=
 =?utf-8?B?K0F3eWJmWmc0UGtxOGFyRTAwWU5PSjEyeTl0OUdWanNDR0c4b3dyNDV1N0lM?=
 =?utf-8?B?RnhTZ3Z2TWZGakFlMXVHNUdwZ09JbFRzb2puNmVtZ0NHeUJmdUtSWGt2WUlh?=
 =?utf-8?Q?wbEtPbrqISsnRkOE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1DC8BE6D1A3734C94FD0F5CD41229AF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p8g5B9unuRT1DDV2iMrFWOqbsHMVtWMYyxRb3jKUsgdEirTFZeb6zDtlgif3uhLiqdlmirzdcY0BK2OadK3SkdRhLqR+WVfWb7aogfmsMsVFrdJcTJcmoZ9I5tPC1SG3io0X2runo6XgrAqa0QiKCePfiBDME1Tf4qZ9H59363I2St++GzbZFS/PsXehrp8tI93zY1S6ayhKpMBjmkC+WGaa+9N2Y17+R3EtsyLiKQCROBNdMZ0N2ZPXmJdG2pTYYuxSO0CHGaGJRPRDM1hFrtQSmwkrlfwq3uZH419bSt9VzC1+k5iqFm6yWVwssgph+te8vcaZIhlu0Yl9G1j4p0iwekcZn3YYHYsKH6G4d73KF4pEy8J/9IQV+PVJ4vdukwKQRlZHJkeELuf1M6VLHaiPh8ZnDYCKFspFAVWCQncKnv8d4eK90L2+O5+78U32+WNeDzW0V9yH6fyPg1DVHG4vWBWB5/XEOCV6E0llQzMDzeqZDQExJ3fh9RA5PwOQWav8StqNmy+P+Fnqvj3N6WI3Ng99LeRs0gEAY1gH57tSrTW3G4JUrr4ud/srSfWluI27qk/w6RWQbQ/w12u1SYGxb96mZuON/KgtGRwqS9so94CpNImO0asHK9Yvw8eS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB8303.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f3fb06f-fc03-42fa-3a8d-08de686a6521
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2026 06:05:30.5554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6kKhE1niIMyU/KqkVv5A2EabT0fywune8lopPxvpzYoXJnzVV2Khzp/RVMCc5Zw14OtkqyuH0VgWaMOOlwnTMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8974

T24gVHVlLCAyMDI2LTAyLTEwIGF0IDE1OjU5ICsxMDAwLCBXaWxmcmVkIE1hbGxhd2Egd3JvdGU6
DQo+IEZyb206IFdpbGZyZWQgTWFsbGF3YSA8d2lsZnJlZC5tYWxsYXdhQHdkYy5jb20+DQo+IA0K
PiBUaGUgaW9jdGwgc3RydWN0dXJlcyBpbiBsaWJ4ZnMveGZzX2ZzLmggYXJlIG1pc3Npbmcgc3Rh
dGljIHNpemUNCj4gY2hlY2tzLg0KPiBJdCBpcyB1c2VmdWwgdG8gaGF2ZSBzdGF0aWMgc2l6ZSBj
aGVja3MgZm9yIHRoZXNlIHN0cnVjdHVyZXMgYXMNCj4gYWRkaW5nDQo+IG5ldyBmaWVsZHMgdG8g
dGhlbSBjb3VsZCBjYXVzZSBpc3N1ZXMgKGUuZy4gZXh0cmEgcGFkZGluZyB0aGF0IG1heSBiZQ0K
PiBpbnNlcnRlZCBieSB0aGUgY29tcGlsZXIpLiBTbyBhZGQgdGhlc2UgY2hlY2tzIHRvIHhmcy94
ZnNfb25kaXNrLmguDQo+IA0KPiBEdWUgdG8gZGlmZmVyZW50IHBhZGRpbmcvYWxpZ25tZW50IHJl
cXVpcmVtZW50cyBhY3Jvc3MgZGlmZmVyZW50DQo+IGFyY2hpdGVjdHVyZXMsIHRvIGF2b2lkIGJ1
aWxkIGZhaWx1cmVzLCBzb21lIHN0cnVjdHVyZXMgYXJlIG9tbWl0ZWQNCj4gZnJvbQ0KPiB0aGUg
c2l6ZSBjaGVja3MuIEZvciBleGFtcGxlLCBzdHJ1Y3R1cmVzIHdpdGggImNvbXBhdF8iIGRlZmlu
aXRpb25zDQo+IGluDQo+IHhmcy94ZnNfaW9jdGwzMi5oIGFyZSBvbW1pdGVkLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogV2lsZnJlZCBNYWxsYXdhIDx3aWxmcmVkLm1hbGxhd2FAd2RjLmNvbT4NCj4g
LS0tDQo+IFYxIC0+IFYyOg0KPiAJLSBBZGRlZCBpbmxpbmUgY29tbWVudCB0byBkZXNjcmliZSB3
aHkgc29tZSBpb2N0bCBzdHJ1Y3RzDQo+IAnCoCBhcmUgbm90IGFkZGRlZC4NCj4gDQo+IAktIEtl
ZXAgdGhlIG5ldyBzaXplIGNoZWNrIGNvdXBsZWQgdW5kZXIgImlvY3RsIFVBQkkiLg0KPiANCj4g
CS0gRHJvcCBzaXplIGNoZWNrcyBmb3Igc3RydWN0dXJlcyB0aGF0IGFyZSBpbg0KPiB4ZnMveGZz
X2lvY3RsMzIuaA0KPiAJwqAgKGkuZSBjb21wYXRfX1gpIHRvIGF2b2lkIGJ1aWxkIGZhaWx1cmVz
IGFjcm9zcyBkaWZmZXJlbnQNCj4gCcKgIGFyY2hpdGVjdHVyZXMuDQo+IC0tLQ0KPiDCoGZzL3hm
cy9saWJ4ZnMveGZzX29uZGlzay5oIHwgNDAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrLS0tDQo+IC0tDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDM1IGluc2VydGlvbnMoKyksIDUgZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL2xpYnhmcy94ZnNfb25kaXNrLmgg
Yi9mcy94ZnMvbGlieGZzL3hmc19vbmRpc2suaA0KPiBpbmRleCA2MDFhODM2N2NlZDYuLmRjZWQ5
MWQyODFmYSAxMDA2NDQNCj4gLS0tIGEvZnMveGZzL2xpYnhmcy94ZnNfb25kaXNrLmgNCj4gKysr
IGIvZnMveGZzL2xpYnhmcy94ZnNfb25kaXNrLmgNCj4gQEAgLTIwOCwxMSArMjA4LDYgQEAgeGZz
X2NoZWNrX29uZGlza19zdHJ1Y3RzKHZvaWQpDQo+IMKgCVhGU19DSEVDS19PRkZTRVQoc3RydWN0
IHhmc19kaXIzX2ZyZWUsIGhkci5oZHIubWFnaWMsCTApOw0KPiDCoAlYRlNfQ0hFQ0tfT0ZGU0VU
KHN0cnVjdCB4ZnNfYXR0cjNfbGVhZmJsb2NrLCBoZHIuaW5mby5oZHIsDQo+IDApOw0KPiDCoA0K
PiAtCVhGU19DSEVDS19TVFJVQ1RfU0laRShzdHJ1Y3QNCj4geGZzX2J1bGtzdGF0LAkJMTkyKTsN
Cj4gLQlYRlNfQ0hFQ0tfU1RSVUNUX1NJWkUoc3RydWN0IHhmc19pbnVtYmVycywJCTI0KTsNCj4g
LQlYRlNfQ0hFQ0tfU1RSVUNUX1NJWkUoc3RydWN0IHhmc19idWxrc3RhdF9yZXEsCQk2NCk7DQo+
IC0JWEZTX0NIRUNLX1NUUlVDVF9TSVpFKHN0cnVjdCB4ZnNfaW51bWJlcnNfcmVxLAkJNjQpOw0K
PiAtDQo+IMKgCS8qDQo+IMKgCSAqIE1ha2Ugc3VyZSB0aGUgaW5jb3JlIGlub2RlIHRpbWVzdGFt
cCByYW5nZSBjb3JyZXNwb25kcyB0bw0KPiBoYW5kDQo+IMKgCSAqIGNvbnZlcnRlZCB2YWx1ZXMg
YmFzZWQgb24gdGhlIG9uZGlzayBmb3JtYXQNCj4gc3BlY2lmaWNhdGlvbi4NCj4gQEAgLTI5Miw2
ICsyODcsNDEgQEAgeGZzX2NoZWNrX29uZGlza19zdHJ1Y3RzKHZvaWQpDQo+IMKgCVhGU19DSEVD
S19TQl9PRkZTRVQoc2JfcGFkLAkJCTI4MSk7DQo+IMKgCVhGU19DSEVDS19TQl9PRkZTRVQoc2Jf
cnRzdGFydCwJCQkyODgpDQo+IDsNCj4gwqAJWEZTX0NIRUNLX1NCX09GRlNFVChzYl9ydHJlc2Vy
dmVkLAkJMjk2KTsNCj4gKw0KPiArCS8qDQo+ICsJICogaW9jdGwgVUFCSQ0KPiArCSAqDQo+ICsJ
ICogRHVlIHRvIGRpZmZlcmVudCBwYWRkaW5nL2FsaWdubWVudCByZXF1aXJlbWVudHMgYWNyb3Nz
DQo+ICsJICogZGlmZmVyZW50IGFyY2hpdGVjdHVyZXMsIHNvbWUgc3RydWN0dXJlcyBhcmUgb21t
aXRlZCBmcm9tDQo+ICsJICogdGhlIHNpemUgY2hlY2tzLiBJbiBhZGRpdGlvbiwgc3RydWN0dXJl
cyB3aXRoDQo+IGFyY2hpdGVjdHVyZQ0KPiArCSAqIGRlcGVuZGVudCBzaXplIGZpZWxkcyBhcmUg
YWxzbyBvbW1pdGVkIChlLmcuDQo+IF9fa2VybmVsX2xvbmdfdCkuDQo+ICsJICovDQo+ICsJWEZT
X0NIRUNLX1NUUlVDVF9TSVpFKHN0cnVjdA0KPiB4ZnNfYnVsa3N0YXQsCQkxOTIpOw0KPiArCVhG
U19DSEVDS19TVFJVQ1RfU0laRShzdHJ1Y3QgeGZzX2ludW1iZXJzLAkJMjQpOw0KPiArCVhGU19D
SEVDS19TVFJVQ1RfU0laRShzdHJ1Y3QgeGZzX2J1bGtzdGF0X3JlcSwJCTY0KTsNCj4gKwlYRlNf
Q0hFQ0tfU1RSVUNUX1NJWkUoc3RydWN0IHhmc19pbnVtYmVyc19yZXEsCQk2NCk7DQo+ICsJWEZT
X0NIRUNLX1NUUlVDVF9TSVpFKHN0cnVjdCBkaW9hdHRyLAkJCTEyKTsNCj4gKwlYRlNfQ0hFQ0tf
U1RSVUNUX1NJWkUoc3RydWN0IGdldGJtYXAsCQkJMzIpOw0KPiArCVhGU19DSEVDS19TVFJVQ1Rf
U0laRShzdHJ1Y3QgZ2V0Ym1hcHgsCQkJNDgpOw0KPiArCVhGU19DSEVDS19TVFJVQ1RfU0laRShz
dHJ1Y3QgeGZzX2F0dHJsaXN0X2N1cnNvciwJMTYpOw0KPiArCVhGU19DSEVDS19TVFJVQ1RfU0la
RShzdHJ1Y3QgeGZzX2F0dHJsaXN0LAkJOCk7DQo+ICsJWEZTX0NIRUNLX1NUUlVDVF9TSVpFKHN0
cnVjdCB4ZnNfYXR0cmxpc3QsCQk4KTsNCj4gKwlYRlNfQ0hFQ0tfU1RSVUNUX1NJWkUoc3RydWN0
IHhmc19hdHRybGlzdF9lbnQsCQk0KTsNCj4gKwlYRlNfQ0hFQ0tfU1RSVUNUX1NJWkUoc3RydWN0
DQo+IHhmc19hZ19nZW9tZXRyeSwJCTEyOCk7DQo+ICsJWEZTX0NIRUNLX1NUUlVDVF9TSVpFKHN0
cnVjdA0KPiB4ZnNfcnRncm91cF9nZW9tZXRyeSwJMTI4KTsNCj4gKwlYRlNfQ0hFQ0tfU1RSVUNU
X1NJWkUoc3RydWN0IHhmc19lcnJvcl9pbmplY3Rpb24sCTgpOw0KPiArCVhGU19DSEVDS19TVFJV
Q1RfU0laRShzdHJ1Y3QNCj4geGZzX2Zzb3BfZ2VvbSwJCTI1Nik7DQo+ICsJWEZTX0NIRUNLX1NU
UlVDVF9TSVpFKHN0cnVjdA0KPiB4ZnNfZnNvcF9nZW9tX3Y0LAkJMTEyKTsNCj4gKwlYRlNfQ0hF
Q0tfU1RSVUNUX1NJWkUoc3RydWN0IHhmc19mc29wX2NvdW50cywJCTMyKTsNCj4gKwlYRlNfQ0hF
Q0tfU1RSVUNUX1NJWkUoc3RydWN0IHhmc19mc29wX3Jlc2Jsa3MsCQkxNik7DQo+ICsJWEZTX0NI
RUNLX1NUUlVDVF9TSVpFKHN0cnVjdCB4ZnNfZ3Jvd2ZzX2xvZywJCTgpOw0KPiArCVhGU19DSEVD
S19TVFJVQ1RfU0laRShzdHJ1Y3QgeGZzX2J1bGtfaXJlcSwJCTY0KTsNCj4gKwlYRlNfQ0hFQ0tf
U1RSVUNUX1NJWkUoc3RydWN0DQo+IHhmc19mc19lb2ZibG9ja3MsCQkxMjgpOw0KPiArCVhGU19D
SEVDS19TVFJVQ1RfU0laRShzdHJ1Y3QgeGZzX2ZzaWQsCQkJOCk7DQo+ICsJWEZTX0NIRUNLX1NU
UlVDVF9TSVpFKHN0cnVjdCB4ZnNfc2NydWJfbWV0YWRhdGEsCTY0KTsNCj4gKwlYRlNfQ0hFQ0tf
U1RSVUNUX1NJWkUoc3RydWN0IHhmc19zY3J1Yl92ZWMsCQkxNik7DQo+ICsJWEZTX0NIRUNLX1NU
UlVDVF9TSVpFKHN0cnVjdCB4ZnNfc2NydWJfdmVjX2hlYWQsCTQwKTsNCj4gKw0KDQpFeHRyYSB3
aGl0ZS1zcGFjZSBoZXJlLCBteSBiYWQhIFdpbGwgZml4dXAgZm9yIFYzLg0KDQo+IMKgfQ0KPiDC
oA0KPiDCoCNlbmRpZiAvKiBfX1hGU19PTkRJU0tfSCAqLw0K
