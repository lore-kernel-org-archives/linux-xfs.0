Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792667911;
	b=ses3OOB5P3EvEtzdR0pNxEAec2rIJndfA+VcX+bQYwBy/eXAfvWJzzh/VPEX2SGDoLc2
	 najXO1KfQaoEjd2Jz+ut8veVg0i1E55qmjDajov51Nk4j7wwfX/yBcTDQjhOC5XfBV90d
	 NyyKK34ympRK3yZbp5dzD3ujLlYJeB50wGNhOYA9KGZNqBOt6QtEojXZuw7NVcvnn5uVf
	 u2dr+vI2UnwDv/ADCGI3am92C6LqWeKB6EFnhuH3huovTHv9yzEwwjvrRaIl4fUaIoxsw
	 tHBixwzP94xDOh9zywIHys4dCLU/7AFsaC6uwj7BXPzalGUGOePLcFBkMdY0O4H5w6w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792667911;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=4UUqB9p4xqHYQNKPd7+X/QT4het0N4WXbpEmoZ46W4s=;
	b=XKlORUGY7E+I8gGa2Ce5mYGhSkhsH8tIm7sTI7fYVL7HfNOU6DO1AQTaPcEMIamhCJVR
	 iq6w+rrKmx/Tdc5f0lH3dfZ5Ew/QENh5YeO21U/iD7yibwTUACE9BIjEfSeDBDh+RZ0vD
	 rvTBNUDRsep9wf4U3dY8VYwqWQAXjQWL6GhCqqpFtNU5nJ9F9vLz4PTl9Fda8jLnsCJfB
	 Tfgfv3zF+A+R/ubm2Mr/VWi2H8L/wtuRaaGDriKyzZfysXpfxljj9Zgjjy+T4wTMDi0RM
	 k5KjyrIhwflHzfk0mKu4tHltzhqF38/E/FDSoob9lST/kkbKRXbk1lIV/IRGCfR3aWQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=YQ79VK0t;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=JtycgBl3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C733606A319
	for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2026 11:18:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C733606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=YQ79VK0t;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=JtycgBl3
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792667911; x=1824203911;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SsWQ+J98noq0MkXjfpJ9A3BztC1X9WI/IMcioqP60XY=;
  b=YQ79VK0tFwxGA5KB6vAtAO3XZgXqqzW3sO6i78D6INPO4S+95dKdCg0K
   bUCvNzrfGOmXq8MoZMSfo9+pguZOd2HTV73MeC+jFlwzW1qEZsQKRS191
   uoU6hfpL0sWYKUlBBbkCLQF2ZITi8QMGS6IaKWFEdfR2ny2CRJo1v9erJ
   6fLC5M+C0j6RkkitxPwDrfNg6tJeiAoR4AX9qyjmM3A6o3PY5QwVUsMi/
   KtwqtUK5dnR5syOsvySYqsXt8prCUbsGX+Rf5CfSuUhuzgVN5vu8so7S+
   /KphaA/I6S6Aw2A0eUvO+87cU1r71VBzhiQMpZenOV0cVf4/fi/QHewGF
   w==;
X-CSE-ConnectionGUID: vbmfUqjZQWqVPtfkLUfpDA==
X-CSE-MsgGUID: 3iJHjVTSQGWb2YjZDKkZ0w==
X-IronPort-AV: E=Sophos;i="6.27,172,1786982400"; 
   d="scan'208";a="157770764"
Received: from mail-westusazon11012044.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.44])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Oct 2026 19:18:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qg3Z4x71fbD6a2a2h+jImYz99D3FGbC5ptKYbDZSDobcLa8V5ceuDoj39ZrR0FWN32ufNQ50JH9xxodbe1oMPeM7HZlaMEnyAFphpbyWrrJzqGzUW4yPyqE+IEmDy1wq4udiAz4VINZemqEWoSCqaLffZusHcWMDKtLGnbfIBQlwYds9UkZzJXmUTrgjOcu9cktxw/LSvh8HdJv2OJd6/WR8kqE4SxO9h4fNOeAhHbVcVVbdBsBcm8YR+zqPnTAs7WarTLc0pE66aw7dqbndTmriyemOYZl6MlQ0lPfjg9kOw5u/WNrouGmuEq3ob1ttD58ivVbrO5G9CPxgU6chJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UUqB9p4xqHYQNKPd7+X/QT4het0N4WXbpEmoZ46W4s=;
 b=kBhllVLJ47YzDY2cHUop3eLzA2d4+jWuINox3SNKD6VUg8ab5DLero8lGB6JAFOTnBe/3z5i5Sa+iKRCg8yeAN5UaUXATQSwMM5EuMswn4z+RBMTvn6lB/Kd4pp+4nxDtZL9P8M+Fytvc6TfgL/GKdvsnxscDFrxKEJEYB/QQSKrelcSDM/MvDitpCWrnECKFQl4QxnsCRNHBkucNodOYxZYWp4UJ0j0iG01CxgHGjgB3e1QvicjWk8VCzXsQi4ZQiOsdzH2Bvf8gHnA+SXt9IQJy6iL2uAgyEzTQMfIoyUV1Uhk4VZO3Ic8pOVAnWIWbSAmL1F/yvkXPlFnRhgtBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UUqB9p4xqHYQNKPd7+X/QT4het0N4WXbpEmoZ46W4s=;
 b=JtycgBl3L6ZiKWLdytlRGsxS6uG23ClsM1LHeT4t7VWmvTJp8eRWhsuvmPu61mcQuqO90RVBeM40aQyr5folhL206Oxsn3oXCVio8N+WF9RWckSF+eGpYq2fHWS/vqGVchBa8sPdWgOeAzqKUemWWuwAb+KMfOLdaD0QkwUpBfU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by LV2PR04MB994589.namprd04.prod.outlook.com
 (2603:10b6:408:418::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 11:18:28 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 11:18:28 +0000
Date: Thu, 22 Oct 2026 20:18:23 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dgc@kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, John Garry <john.garry@linux.dev>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <atnvvalMNn2iAAI0@shinmob>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <aqsN4GOXthkF8rOI@dread>
 <20260922002814.GK2705364@frogsfrogsfrogs>
 <arXPSS6ikVMDaI7w@shinmob>
 <20260925230329.GE2705364@frogsfrogsfrogs>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925230329.GE2705364@frogsfrogsfrogs>
X-ClientProxiedBy: TY4PR01CA0113.jpnprd01.prod.outlook.com
 (2603:1096:405:378::7) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|LV2PR04MB994589:EE_
X-MS-Office365-Filtering-Correlation-Id: f2103d49-3911-47ff-8cae-08df302e32b0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|19092799006|366016|261021121427099003|56012099006|4143699003|11063799006|261009223027099003|18002099003|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	c9nPW6DUFEazxnCgkLEOXq111mvGtKkkOEKj5WnL35lAwjtZE1IUCI1jauSNKCSdAMEM85ctWFQs6tzUBOSXZ0LFqriJEWaM3gnpJJY2q49P8CymZONXduZJQ+R/OdJNUdZTTuVmV0KFaZOP1cxWpCPopOhr50R7jNUItomzHA6ke5rharJaXZjt6yl8f1SCDMtNMZ3xbnKd7JDDDgysup8WTUngrSJML9Whl8GFI850lN2y+fnBPCQ6E46BZGy0xPPVOs6Atlb0PP1uLnPzuJnVeT/X67okAcGOappAZuGSCGmW+DX25QyfD7056f59s9/c1GATqLsopnCb3zrB+lMb4L7xWaBcDRkP/9x+WBZvCHln3DtjtIdz3n/o7qmXVnV441vPYDjG0RSvVpZ+48UNFxChUUPpLBusd4aSF+9RGW4kFTd3D+byKPyVhp8d1S2q46A/ubRX0ephU5xHdlsCwcWe2FvMZZYd5LdXIk4/zxvrdGaRIPtmo0/wC49bWVVXKwOkouP8GwMfWAgoEudEoSa0C+Dd2sEiQFfIdfOjXSTEzOk9sbvPGPzTob2a6Am51PE9M3lFEHFPyvQ+ygasla6oVUeHCRm74SteZGUIU95gZXXoWJ7s/wCYXIKwCFFwZzyBHu8Ldf24XNbj86c/wdfRA4kNgL+Nu3AkS1Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(19092799006)(366016)(261021121427099003)(56012099006)(4143699003)(11063799006)(261009223027099003)(18002099003)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MoYd2HU0ow4XaSPp3lknZ42Kgh41SRyXbOOOcbDmDl9wUmtlwjLmrhwVGgnC?=
 =?us-ascii?Q?CpMjFOw40Q/usEx11yA+1D8BuSxVEtLdheODnFT7U3GxsllOpzq38aFPVkdk?=
 =?us-ascii?Q?zbjGeVGUwTCwz9Or8Z6OX6GVUOLsPn7CavMw0qk3bTFFAp9CW8ULXj3ZzU5E?=
 =?us-ascii?Q?Q5f00T7PGFle0a673HxYR2GXaRzln5pi1CmiM+Lq0MfGAAluaBHYIWeCS6jv?=
 =?us-ascii?Q?pNhe/AiodF7Wdy8VLemy14t/UUv+xdSMMzYlhLnTO2fA5+YURnjXZupXN61h?=
 =?us-ascii?Q?jBVCG9PRzgXBwbmUwpQUrSqafBIQVGzMgd4HVLva5K/rnfCB0L0dqL7oKyCl?=
 =?us-ascii?Q?EWjxNq7yTdGbQL1YU4HyHo0AzACiLfO0iQkT9j5k+KCJPet/wLw9UUiiK7GV?=
 =?us-ascii?Q?ja4ukoLukMeMV5wQ0+WMlNmsguhtN1AJqHzK47qHeYTRTKtn/FqAA7l1FyaD?=
 =?us-ascii?Q?mM+C92oS0Wl1OFiv5LATMNnkcUp5AXTJqGLbf1JPB4YHhliQ77eD2m7KXxTF?=
 =?us-ascii?Q?D5/ksFPntyJrP80hjL7CXX05eNjVhZknCB4xOFCZ1oK3iFEg6xc2DKGqL2Rc?=
 =?us-ascii?Q?8lnvufy1xup37fR3GlR28N3kMi3eQFIa0MQ2knTMRgzh0f7Ho80MuROR3ADB?=
 =?us-ascii?Q?yY6u+o0or9mI3H7cDvRCWJWaFE3JL/ShpPkTVhcHf8Hn26n3Mk2nVwT9sXPw?=
 =?us-ascii?Q?Lpe0EtnotLeh3NXyJEhqnJ8/ML73Q41h392evbifHEw8nZ09+Q/WGx3o8wUA?=
 =?us-ascii?Q?7UDpkYuww4L/7IDqp6urgGb5t4n1UozZXhMZNheI3L2YeImNfqMGtGRUdyJo?=
 =?us-ascii?Q?64+JE1hNX5kZHyQeoym6PNcRXVhsM1a6Z5Q3vLn0VAuw1Gjt3cr64UAlsn67?=
 =?us-ascii?Q?MooSZnCy2J2mBW7SL+V1iplH9irvqZvCt4vjJr/Swssz1g5Gs6dKyZCpUSAd?=
 =?us-ascii?Q?B05C6lLk+GYqNtXEGdDBq15ZO2PGJDuc/sNxFEc8oJGIIORb/63BSV915jvZ?=
 =?us-ascii?Q?LF9PnUDhnFDMP/4TT1Qr+j7e0YL/6kRPJuaHosnHkDjnd+nzWdpmzWc7MGoU?=
 =?us-ascii?Q?xMxHR+FISlBu57ooG00FSRYLHHNZSlJ/k0IADD0BF5H+P7dCKFHe6cppmwrC?=
 =?us-ascii?Q?pbrJQixFQErRi6BVRXEJhMS5SB+5Z+A0BqDlZRjqBfB7zS0FddfREo9y/lwf?=
 =?us-ascii?Q?s/cRKybD0NkShZMsxu7HLKpXgnsghhNjo1Hu6oBSlVMkLI4LB2tb2wvORtv2?=
 =?us-ascii?Q?3zFecrl4SoyM+rUTBOc1o3hBYMasQBkiJklmQtTAQvfArOqbkh528TUp4YK2?=
 =?us-ascii?Q?irAMMhvaeCjzm9JuQx2GVr4GXkf58dfSIDLv/OVqNMMRpbaLykEpOmU96FVq?=
 =?us-ascii?Q?fezVBAoaXAD7Zg+twdqOXmn3ruzCPQl8RtNHFp4dExopXTBzRR2TmNFQPeA9?=
 =?us-ascii?Q?GkruiMfxIb5oXw3jxYc27qC8e09KcTjuDXhu3/uTYUixC9WX5zgqvC/4ZuEf?=
 =?us-ascii?Q?O7kWqzbcj992HezJ0VwU0JxrNxFO3L+M6zD3tJYalM6dBqn34EuskxCpdmak?=
 =?us-ascii?Q?8F85EkIHq5hbjG4Dt360qvi5GUvco4uicNgGKm6FCcd+HG5Ko5Z7uu4I2c4q?=
 =?us-ascii?Q?S5etOkR0324Ywa0l1jUVs4dNGzrOftN1TpGk9e4vfEFts03KsU+vdCm0IrAn?=
 =?us-ascii?Q?gEAbAFfStBq2Besz7AOv4n4FqKScks9Gs/ubvobJF2sseuY825l9iwd9w1OG?=
 =?us-ascii?Q?EKITmLakQN1coBiFUkGrMHC6hZZ2vm4=3D?=
X-Exchange-RoutingPolicyChecked:
	cKPOWjUHqFSabbm/+fj4YlEdz0yYgCFst3aIVXvA4Ia80vifbHFmurrfHm5AWjqvYTVi0uISUhLigXVunnw87nFiCo7Qkx705qWcMXdwcTOku0bUZr6iMLfbRkKs8LxB5fbmn/RMH0sMeRKQHuhQqttmeLKBa4/A7BpUFQdTekQkfWacNXYuWCN8LNmZlh8pXxDxMRScB3WLNTSt2bEJkWHiB5px5QxRp5wOwT7Wa02DKQdsJmNB0s/9SLCXasuLHYMEmb8q8cfOf/eMnHB/fVuNLBlbH+TvrwhxbawQM6kb+G7lgBApMN4cMeU0A2DjnGa7IzGfaqJL0x4RyvouMQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2wpJdGJ+pyJV3qteIpRJXOyPZPUvQ32Da9lefhJVte873msKPWn0LRfWvOUiJVjkgLR5OcejKi7P45HGXiVerKMYWtp5cc/KbRZs1Sp/HxsaXeONRopYBbJncpPcs0AZEDbFT2mAnqNpABwfF1mhUCnVTx3evopI4U4BfUGTcdwGJgiT/a+MygXCmabjvsCkDv68r6ByHmvvWDyoEMvK+chOg2VhOrfT/kG6JGcJJyrk+qZjDKTXlkIqq7jFUp2LmY+db4pRlQlWaE1wbbqwvInlHLaGwBnWO8XaQGrI6jA68GM/h3RIHXQRmYs0vsLLO8OIrD+P85031vz6IwijAtLmvseVRDb6DJ4d4uMEpU1HzTET4RirCrGGecyP9zozmozL33SJVv2niXH6/8wGUuexWSHRSiOm8vbv3dAEZPKPhvcIRSOPYc+pHCLFKltTw06wOxVLTi1WOJ/cc+LysPOjzvSQ/yCMtF3iXdAh5LvzYXixz4PTaTOLO2KFKsS/0lglOejHr/soWUhwIVPVW6WAOsnimq4jbwT5nck0Vlb7DLAhhBiVAbAdsWWrBJDV1cOrw+Ihh6VYvTdFqXWDvPaUwmrKMO1S/r/Ses3CcgZgP24nWm+MydTd0BexdlvW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2103d49-3911-47ff-8cae-08df302e32b0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 11:18:28.7934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqKw6VgXcaHbw2wZ/kWZ19iU7zVU/AQqUO2KsfvCbw2HTy9p2YYCrwA0lQUGGq2Ohqru3t011na1Y5RM2r0MJPOBk84QZesE1VANmfiJjyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB994589

On Sep 25, 2026 / 16:03, Darrick J. Wong wrote:
[...]
> 
> Yeah, I think you're on the right track with the dynamic tr_logcount
> changes but I wonder if you want to constrain the max software atomic
> write size so that we don't end up with gigantic chains that consume
> significant portions of the log for a single write?
> 
> Admittedly I see the multi-megabyte atomic write limits and marvel at
> how far we've drifted from the original requirements.

Darrick, thank you for the comments, and sorry for my slow response. Today,
I found some time slot to try out max atomic write bytes capping. I took a
look in your code snippet below, and was scratching my head.

> 
> --D
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 1c20a7c27aa1bf..2e84544cd22a0a 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -1473,6 +1473,10 @@ xfs_calc_max_atomic_write_fsblocks(
>         struct xfs_mount                *mp)
>  {
>         const struct xfs_trans_res      *resv = &M_RES(mp)->tr_atomic_ioend;
> +       const unsigned int              max_log_bytes =
> +               XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks * 10 / 4);
> +       const unsigned int              log_bytes_per_aw_block =
> +               (resv->tr_logres * resv->tr_logcount * 5) / 4;

I wonder what the numbers in the two lines above mean. I think 5 means the
number of transaction rolls required for an atomic write. But not sure about 10
and 4. May I ask you to elaborate them?

Anyway, I applied this patch, and confirmed that awu_max reduced from 1024 to
64 in my test setup (4MiB to 256KiB). So, it looks working as expected.
