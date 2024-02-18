Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1644A29
	for <linux-xfs@vger.kernel.org>; Sun, 18 Feb 2024 00:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708214432; cv=fail; b=qZOQpKDKM4rQTJRUVgz49PFgMEsCCshdvwyGAh2IQel/SHAJerq/sKH729TGgpKqEEQoMObRiUIz2QS4jSztUxNxYwJ03p6K1Ue9ZahVOkkp+i1hpZHayY/PVY7AcTXaXU8aQrDPk9UQgXXPUKcwth+9X0tBgDMT+Vi6Eogmbyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708214432; c=relaxed/simple;
	bh=HVKQX5+0CIHihF+xbsRjAV63/TenvPsTsB9IO3PCvc0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LnUscrqQqZXHndD9b9wHqILQajrZ/cRgXWNaVoZ1QGftVc9HzqUUoUywO2icOLt+jzVjKV+GyZclAZIOHdMoFcICiNjmamatrJNVHTvnLw7jHuM1OgbqjNmwT5YhgVYtXYiGmaQ2Vm2rirmiu0ay3QwUoGCkUI86QpwaXPg3VYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c3IhjWfD; arc=fail smtp.client-ip=40.107.223.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c3IhjWfD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEgzwS+t7C9GdjMSnxibVVKJHIepb+nisG461QfKH+7X7soz+jSNJeSayMqQfe4evIwFn3IFL4RDYek+Rfjsd6ZLxReBbND1CeK7BbTlrR+fmylnb2kmkvPM0omZXYl9NimtewSOT/3So3O47Yoz+7Ta9UtJKWCYcncysXTAoViiuzj84wQINWClGco/hSpLRK+uMCdCPME7WukiZA+RLlgqzavQtvUq9JBf3bPS1PwPJilgyTorIW0y7kOCbENEd+61vSLHGoR+XR6Bbrz1tII4LvruNW8pM92kw9AjvhifApzc4kGQZyJcBCfXX7N95SuEfEVXkfPIB81fvuUw2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVKQX5+0CIHihF+xbsRjAV63/TenvPsTsB9IO3PCvc0=;
 b=XiEio1+t+apm03xDry1wZYL7fV951Wk74BjmYQQvrhz1JQfsD3ilGeoxTrfgdPf009dSyKEMg3ESBiluZPH3Y/SiTFz2BVTGdrj4ryzzmQY62JHcCDOoLXteTpNr+ePQG9ikD4yhqorYUcvlxy75JBaIcpa7X21xwwg/SJl/rqbCc/5+3QzXN5Uuc+1iQIOqBBuCUiPCrp1YQg1MIeMwMOsm08wPysOR6YS672rEd2gOIZldnr7ZY8hJHR8Z+Qz0oOUgnq0lYpL+VD373VY6s8wEK7gD+X38oUQ3FuWXJkWn0RnhLg18E6Dh+/9cQZOqSXorj5a52RX+PlWuLgjIGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVKQX5+0CIHihF+xbsRjAV63/TenvPsTsB9IO3PCvc0=;
 b=c3IhjWfDUzarL7qPUpoPutmBZ9yZlZ8CQcxEYbnLRogTm5jdT0sWYZwjce8tkCLr3pqcmwFcH6QoDwDRfuwUvoBkYDI0nRMRXeYtixe5+WQQq9tptpmoASqWkwoXpWa3p6KsW6BFP4XnIGRjgu/34eAnlgtr3Cs0GbKUxihOL9gmB7iw8+Ew1dxiRBA4ezWMHf6mig0Tn8TQgEjG1K3HaldPWBJQnuopBCuX5E8+gX00fnAPKAQGbCGpqi7sNj3g7kGCEnlC6geyxs1RxAlS9MUfutHUnwkqgJoG8mRMFbmiErc+yNeXMqPVVs8T0Pqhn5K/UcW4ozb2bi0uaJFFmw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by SN7PR12MB6981.namprd12.prod.outlook.com (2603:10b6:806:263::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.14; Sun, 18 Feb
 2024 00:00:25 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed%4]) with mapi id 15.20.7316.012; Sun, 18 Feb 2024
 00:00:23 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, "chandan.babu@oracle.com"
	<chandan.babu@oracle.com>
CC: "dchinner@redhat.com" <dchinner@redhat.com>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: use kvfree for buf in xfs_ioc_getbmap
Thread-Topic: [PATCH] xfs: use kvfree for buf in xfs_ioc_getbmap
Thread-Index: AQHaYPoKJRCYZdd0BkeOC8FWBMFJE7EPOPyA
Date: Sun, 18 Feb 2024 00:00:23 +0000
Message-ID: <42351baf-87a6-4cc4-a91d-ea67ab6b8854@nvidia.com>
References: <20240216170230.2468445-1-hch@lst.de>
In-Reply-To: <20240216170230.2468445-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|SN7PR12MB6981:EE_
x-ms-office365-filtering-correlation-id: 9f2ac116-967b-4093-bb77-08dc30149ada
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 p+huSs9pHCxjhqTXHTjkwf8C1KRXqOFVmFaBBW77LVJETH/bEgDOzrObTtK/+C8VcJhPsOrNTHwrF5ra64c7yjaM/qn51/ef96cv+zcK52dOODQSawDlYIDyDFtonHaYIlX6s9dDpnidVBo9YnQCjUp7gah1Woq83Qhpv4Jy59CMDtTdk0P5xQM3jfBqjdx5MFIznABsEJpQzz3EFOVsPG68nWRpdovpdar0nA7Owh+qKeCy+2DurlPJPHI2rIC4Dq2MatSi+gaQzMGs50DqUgG8ZHtC3Ydg/jvhWOYtDzLyvaFRiD5lEyiDrRV2/BvvnqyMf7qA2M3MuRv3X2ys8XdfeiQUa79hRudaH9fgT4IHet6W56dmKXPu0irGdYzRtvxZb1WW25l4jtPpo6odoe00THZdza88nfOQ/oLveh0nDbNgMpkJWGXYw6cZ+kSNlRUfBPQkfI/5CS3LzcjdATdZSEjfzuP+ZwXbSdC5pyGR3Q4ogKsQ+zpbo/5i4DQXu13JMbpU31W+n+6JT1l9lRxgWrhUUQ1oVPF30mMER4QWWlcMardAry7WXFe3vySYzrfwA0Zuk0mbppdbe0dBv5qM310eXb09biiohKHSpBmz4pJY9WjVx88V2egI5Iut
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(366004)(396003)(39860400002)(376002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(36756003)(86362001)(31696002)(31686004)(8936002)(8676002)(66556008)(66476007)(64756008)(66946007)(76116006)(66446008)(91956017)(5660300002)(2906002)(4744005)(122000001)(38100700002)(41300700001)(4326008)(38070700009)(54906003)(110136005)(53546011)(316002)(2616005)(478600001)(71200400001)(6512007)(6486002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?azdPeVFDakcxVWNwVUhFRWdIVmlCdjJQa2tlNHlqanR2VGsvYVN6Z24rdkgr?=
 =?utf-8?B?NElLc2F1RlY2Y09yUnI5dlNjK2JzZitraHFIL2NBU3V1OWY5MXVQWVJZSlkr?=
 =?utf-8?B?OHcrOHlibWptUXFqNVlicXhPbGdjelBUWW5LeGFlSXREZ1lnaHhPODNTcHVI?=
 =?utf-8?B?eW13M1MvMGZlRlpVNXBtcEROMmI4dlkrY3JMRUhzUTZ4K3p0TExFY3B0QmI3?=
 =?utf-8?B?OTBVL1BjL3ZsZ1hiMjM5dzJBWGxLWmJQdThUdFpOZ093QkRwamF6c3FkKzBu?=
 =?utf-8?B?K3NOMVVFWXF6MTVuczhuWGdRczN2NElxVTVtWmRPbU9YSTA3N2RyNnYvRUFF?=
 =?utf-8?B?aUx0ekxLLzBsQXdPUWw1amUveDR6RnNPM21kb2FiQ25iZkdhVUZRU2RFSkI5?=
 =?utf-8?B?RGc5d1ZESmNtNVpUUE43TnZxYWR6UHVaaUpJVW0ycktDMTNHVmdsNWJVdHFK?=
 =?utf-8?B?d0FlR291TTY2ZEtLZHNvQ2lVaUx0a1ZhLzdoTjRVTE9pRWxIOFJmaGlRL2Zp?=
 =?utf-8?B?VUhwWU1ndG9CVVFZZ3lpVFUwZnY5RUMxODRUT2pMaTBNMlhtaDZrd1lmUVZL?=
 =?utf-8?B?S0ZuQmZ4QUo3L3VMT1ptSWRuMjlTVzVHQVBIak1JdUVjVWN3Q1N1eUp3dlBT?=
 =?utf-8?B?Wlk5RDlCSXZFTHBZMGdWY3FYSENYMmlDYXEzNi9HNTA3c3VVY0hmY3ZWMkhH?=
 =?utf-8?B?N3BVVDVUMERaOGFqdU9iemRXamxDOGl3eEx3TzhaMnh4ZGt4SnVtSVhHUjBT?=
 =?utf-8?B?OHNoTjdobnVlb1MxaEltODNXVERjOSsyekhJUDN6Nm94NjEzZWFTS1Vqa0do?=
 =?utf-8?B?V0htSnp5MmJ3by9rTk9lVXRLcnhvQVJYbGhLVjdhRUpnUEo2V0o3UWlXVmhC?=
 =?utf-8?B?eXJGREI1ODdNaFEzaHE4T0hDRkplZTBlTVZJMXozeVp1QnpBSnZqSnN0dEpS?=
 =?utf-8?B?Q3R3SktzUkJ0MzMwaXVPUUY5bW50aFA1NUR5MVErQzArMCs2MjBxODFYcUtC?=
 =?utf-8?B?ME9BT1dSaXhvTU1tZWJUdGhicDVnZDBsZkR6bE5nQi9JYUxTK2dVTHZHVnd3?=
 =?utf-8?B?dUtZOFh2WlZ2SFlrczRtYTBDeWtmWWxIbUxKcTM3WHdqbUU4L0RKbVFIcXdw?=
 =?utf-8?B?UFVWWUk0QTMvYTZCOGJDblNTMkhlSCt6bEpLNFZXNkpXL1RXc3hTekxhUWM4?=
 =?utf-8?B?OFdyN2pweTlHWVNKRVpUUXRoZC9BU1A1aWhEdHlXNlJjS2JlOW1SanBOc00z?=
 =?utf-8?B?dy9XSjhZNHNSWmVBV2ZWN2dwdnAyYUlxcWduM1ZvZ3hja09BSnBVbmtJV3Ji?=
 =?utf-8?B?L2xCZEFaeks5dlcvcVpYMHRsV01ac2xvbkNacnlNSXRkQ2w1SGxuTlNGQ1E1?=
 =?utf-8?B?eHJVMEgrUFBYTjZSNEt6NjlLZzY1dWFsODVzVEcvQWtCcjhTZkpxNlV3WlVs?=
 =?utf-8?B?c0hCeTlGc2ZRaUUyeUxZNFAvdWIwWmRkMU81NWZZbng5ZUtXNjZhSTJnTzVI?=
 =?utf-8?B?ZkNGekFsWGMxYVYzd3VVNy9qNHpiajROd0tRNVRXYWRyT2pwZXBZVUlWTE4v?=
 =?utf-8?B?dTZ0WGJLUk4wT2hVdXY2b1ZmNHdkRkw3Y2FJWHo2eHZUUEVkTGxRVFIxVmFV?=
 =?utf-8?B?eGhRSjhmNXlmVFJVZE9sbkNoWGFTaVJMcHF1VzVIQVZVajVabGZxdmd3UDZl?=
 =?utf-8?B?ajdKclgwamJSWDFmejI3ZFFTTE1zVVNQN2IwTUZvQlhHYkVxVXdkUE4vbFZB?=
 =?utf-8?B?QUJsRUZEOXpEdVV1d2RRTVRreFNaQ3czRlRwenNSc2VjdjZaWUpnSHdSVlJF?=
 =?utf-8?B?Y3k4aGYxMDVCcGppcG8wTlNVNVZyRFdlT2tmenlGcTE1RTNLRWo3U1hBeEta?=
 =?utf-8?B?NElPUGYzdDZHNWRWUEJQeCtrOS9WNnl0NGNvNWVjSjcvV0FQeERyRktHZ1Qr?=
 =?utf-8?B?ZzhwVm9GM1pBVmswMWc1YTZtZ3h2d0t1UVVVZCtmMVJabHhZREZJbVVUVmJ0?=
 =?utf-8?B?cVZCb3RadTJXVVZNVkZsVkZGNk9LWCtYaHlZMmlCU05zYnBnN2VmdlprV29Q?=
 =?utf-8?B?UWwxaHl2bzR6SkRha0xVUnhIZTZKWGxaWm0zU0xBbkEvZU1lUGRCSGJsTXlh?=
 =?utf-8?B?ejZIMUE2ZDFSWW4ydTF5Mmh2VTFuRnRiOTVxdHRld0E1VndidDdiQWtwUG9j?=
 =?utf-8?Q?y7A3YzQ8imajhIUlF6Kh3hd953nPapaNIgUAmVnSgq1A?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <22B05F125639BB4B9CD4544571F97671@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f2ac116-967b-4093-bb77-08dc30149ada
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2024 00:00:23.4970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TbSJ3BeTb6y25VTv5BghDr/5EuQpmBhicvE3OO8c5v8piccr3gG0XwRGQNqpRuU5wA4Dip5rTnBykCUuQbGJcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6981

T24gMi8xNi8yNCAwOTowMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFdpdGhvdXQgdGhp
cyB0aGUga2VybmVsIGNyYXNoZXMgaW4ga2ZyZWUgZm9yIGZpbGVzIHdpdGggYSBzdWZmaWNpZW50
bHkNCj4gbGFyZ2UgbnVtYmVyIG9mIGV4dGVudHMuDQo+DQo+IEZpeGVzOiBkNGM3NWExYjQwY2Qg
KCJ4ZnM6IGNvbnZlcnQgcmVtYWluaW5nIGttZW1fZnJlZSgpIHRvIGtmcmVlKCkiKQ0KPiBTaWdu
ZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQoNCkNvbW1p
dCBkNGM3NWExYjQwY2QgdXNlcyBzZWQgaW4tcGxhY2UgcmVwbGFjZSB0byBjaGFuZ2Uga21lbV9m
cmVlIC0+a2ZyZWUuDQp4ZnNfaW9jX2dldGJtYXAoKSBhbGxvY2F0ZXMgYnVmZmVyIHVzaW5nIGt2
Y2FsbG9jKCkuDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2Fy
bmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
