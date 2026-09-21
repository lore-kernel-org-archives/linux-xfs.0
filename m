Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C862E7622;
	Mon, 21 Sep 2026 06:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789972819; cv=fail; b=ISqTp8TEcMbE3hxM1rbzk6npEgbOpurQh+YVIC9GbrwIeFFFnCvaPzizFR/OBjTCHKebSSxD1YqvE1BIIa1GXurB64pD4ITOoZnO5AfDGa8Lk/07fj9Mm12EubtGqb2oEyd81KGPoiHsu6TrVf4xrObTZyAzhTqm/CVWcPZsnkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789972819; c=relaxed/simple;
	bh=3pX7T7bmQbvOttZ+GedsKZiJknY2d8Ups9TRoekofig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Bw2wEMcYkN7sCVWQq9ZF9FCszwqea8rgVXrRgAsVSKhZNtiWPf2DRQBEDSvylVlyI1mUNToI+tojGGwiB8eQOloUVScGp+Asp5t05DGHtQTbTjUDMH3sRpx0hatq+nNwc2QklBZJ1505GgW1CxTxUWMSNbmjZJD3iFxPv0/OY0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F/li+bSb; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=QF/2qUnu; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F/li+bSb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QF/2qUnu"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789972817; x=1821508817;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3pX7T7bmQbvOttZ+GedsKZiJknY2d8Ups9TRoekofig=;
  b=F/li+bSbHTnK6B5v6VkZlqgWIP+Lv+f3e0MxNj84q4sm3yn+awozxUqS
   0WwwG4VtTb0+5M/dbJpRkWdIJWr6v/958S7lihb8r5kK0wqD+qGahjVFn
   xxZ35jDpVJvKzywsrnjhjSi+4UHrcq4DLTJBoBZRYgcR/bsYWDgGQ6VXP
   suNSepsVbNM60D6tBRoFejQWhR0/JbctaCKv7H7+dbVpvH6Jvj8i5OOpV
   XXJAjwjveH/ofkubSoT4xE168l6+ejZGhjDtguEQN9E0eoux2B5rbSUQr
   QS1/w3YJPeq1aRNdm1khtwnFioJIiVZdCqL5PlgIpJxvtvwfP9gsrc990
   A==;
X-CSE-ConnectionGUID: IXAoo3qCQ9qTY/Y7nVcD6Q==
X-CSE-MsgGUID: XmmeyrhwQtC+r3JhE2GMJQ==
X-IronPort-AV: E=Sophos;i="6.27,114,1786982400"; 
   d="scan'208";a="151942100"
Received: from mail-westus3azon11012016.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Sep 2026 14:40:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d5/Qn5p4qI/VB1IFEtAgO+mpTyMrvg5Yh/UIDK9vcvym1K45ug5n4pyJJJQ3HRGHFlDouOCGTDepUwCO7RaQaHougQOsA6ymWqAp2fjbOxGJOvkSncUoeZsV69i2P2+1+OFzsvPZyTCTPKgax5RqqbX4iEVV5o21k/4PHPm5uTucLIJ+Vh21zKddwwsIUEdua/d/CFpv1vHvNz1Rde1/SeiPMYEeFW63bDFq98kPebcX3l0Ea1ALPZ/YhY9ieMdFosarRjdL6IxzWev+3HSU0c8ppK6woKZHATcifIyePIsQTq7FJGwpOTEhVtbcKpkD+eGst7VMHuQJ3/MnhN8WFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUC8xKfTh2SbpK/pVa1u9AS9U7UtRo9X0+jhjbhMOuc=;
 b=P0WH4JKJVjAfITjD1Xu6Ywqg+KxHu1Rr7tsEAde7ykERvvjKBvQNQjEea2nSorPBN2ndae1kPLUTkokgUP9q8C1wh0eRASeGbqiJFbVtNB5zxY49snPb4CSZm/h77AX6F1/gMj715/9doHyKy2AGqMJR17ZPGGKFymC14ikj4e/jSvDg+zV4WWB4w/ZpF9FnAYjYZ6NCQTx9WkXJplwpAGRDTfCiY1yfwNWDEy594ZXhAo/wWPNc8L2q+X5r6r4lRWLnlPJdP1B0XY5b5RPSJs7voh7FKdXIGsd09hs8vaifZpzdBBy/uOrIbq0RKupTSDq3s9mPmaZt23grRNtTpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUC8xKfTh2SbpK/pVa1u9AS9U7UtRo9X0+jhjbhMOuc=;
 b=QF/2qUnuEJz/FqC3zUNX5L53MSJtfCN0XizbzYa8TjMltLdXwj0EaK30Tfw4lbSz1rafnl0hwgJznPW307FZYtO9USS6ScJeIaG5NGQUw2berQ4Fnu2zl2DA1aeRGuLc+VzOFUeXncAWyfoshGG63+llgS0Ul6RokAmzwyHHaCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by LV2PR04MB994494.namprd04.prod.outlook.com
 (2603:10b6:408:41a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 06:40:09 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 06:40:07 +0000
Date: Mon, 21 Sep 2026 15:40:00 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Christoph Hellwig <hch@lst.de>, 0wnerD1ed <l7z@0b1t.tech>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Tal Zussman <tz2294@columbia.edu>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 13/16] xfs: add support for lazy direct read bounce
 buffering
Message-ID: <arDN1UdZIydNLUjz@shinmob>
References: <20260909060924.1102037-1-hch@lst.de>
 <20260909060924.1102037-14-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909060924.1102037-14-hch@lst.de>
X-ClientProxiedBy: TY6P286CA0008.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:3b8::11) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|LV2PR04MB994494:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fe16d47-7d69-46d9-cd33-08df17ab2d22
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|19092799006|366016|1800799024|6133799003|18002099003|22082099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	x4fCDOuZNWt+qp+rojx+OaPBWlRsGh56YTfHPqJ+1V7QmCCLwl0PiNN5xBH16BOowTbdWLcK1n9ZEu55SnHtd/vdGORPZTHeQiDQqKVgpJ910IBQf7qCUZg59RTUZ5avwVVdMs6qenLw/w773U6muERMfnYiYJ8+AfFqec1KPNWGdw5jXJ2SRRIQrjTuJLotWesr34b8EZD8N8jqNcjY28b7pCigK8hKtvkG/umPrfKRNd0M5ZwI/LvH0vgKzuLMVi4I+5xhwPhHSyrWGEm5wW3bbkZeccXprB4RKKin2Tkj2GTPa0a9p7mEXwTehRQbzLRywPySEGk+2J/Rsa20ESECfGjcW+915r+agWUXq4l7v6QlPVNINpISTkI1mc5H+3rCGF2o4Q70cIOeaKEbAcgMBAhKEq1up8vp0Y5VELr/2nPRRRhM2aXk1132/z1ScBsjyIgapkuUoDWdxBECHHlpU4JXfFt7ZSrPZSBv7C5DkjRLkdxiy0FnvxmfthoPzvRLlIgEDkXQRq9KQlZ5SdrfkhpMUBHObF0Tm5kEc08zRQlWqECdNVXoH7Rz8qaksR+DyW826NPRQ9XFeqKcKeHCpYMoZ6SoGBXK8VumpMbDvpPKy3W2H2osantt52Mo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(19092799006)(366016)(1800799024)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9MhRJMJefjH1fFl8QLDSiZlqo9cIY/yJ0xCOgRqvcV35BZnNOu7eMA6mW272?=
 =?us-ascii?Q?cQsOcpOHsca896GxiiTt50ho8S8Y7fEFEXzL8d1zWUonr3apY9evjXv3gSMn?=
 =?us-ascii?Q?uBZQoqlA2LNjy7Mlv2MHvKfsXbG+tI+miBI7AeeeHdYHHpv9CuSfOWejhzC1?=
 =?us-ascii?Q?2ydLyI3V4WTyE56dYYwCeJqvdroJVjToPbp8IYwsZjFxiDmTnp3f9+2ZcKy6?=
 =?us-ascii?Q?0c++njRMLWNRec3z9dxpyOU/JaWLUOz06HfwISj8AobihJTAq5c6hKJzgdpI?=
 =?us-ascii?Q?osF5gMrLmT8eNsO43z7KzZGLT4oqKnSKAqMr49MupsTH4MrEFZ4lEh6jhbQO?=
 =?us-ascii?Q?dOzPWEFKRWQuCPsNZ+D2Hf8rGDqVJHAS6ls/jxZm5FXBcxhwCRtACq3cNzsr?=
 =?us-ascii?Q?cg4+6EReWB9Eu+Ofn+84k2yQvXqUSmrioOtjBa88WUrMBqusTCTzzZlhnrAI?=
 =?us-ascii?Q?BufxPORdUcREdVMp4Yqan9i8gDNNZxjUscwVh5slIn8mjWdlxqDUycdmbZ6o?=
 =?us-ascii?Q?n5qKOUVO6RXre7ZCI/Xf6FThta/b+RPZGDKmv/owtDlpAKk5eD+8tE6ZXe3H?=
 =?us-ascii?Q?ZIWhf7qN4R117Jo5EFcyQhS41OQaNleOeqts4GWgVUNkcWn32trMS4/8J5zx?=
 =?us-ascii?Q?bEY4trN2RLTzhMf6yXuGPbMki5ZMiYwvUKPndKwtnY8Q7nAIbdQiInnYN58I?=
 =?us-ascii?Q?gbLKCYRt5Ga0U3P9qI7/Zvt5FsDBdt2NF67Mh5ghn7t2jbLLHaf0dgnpxr7d?=
 =?us-ascii?Q?gTPz9vqjtwsCGywL0NVugu0XxYbIRNNuemXA+3xGnwZqXMTkZboBlKULP3b0?=
 =?us-ascii?Q?HaWNHOxodYtQ1de9NqBvtZ9Ya/oWrPCdEmWYsqZpTapvi/jysZJRnYMaQJ4L?=
 =?us-ascii?Q?/GM23WbXG825Yarb7IsrqU83wSso8awhgM6wbzt9VsXkF66uh3NhA7g2ZkVn?=
 =?us-ascii?Q?uPpt+hbRfStr9SxhT8BqTGH68UD3/Cf6EUyf2+UCN2R0o3bMyNB39wBAlqe2?=
 =?us-ascii?Q?YyafOpOXHzOgkf9exgGWhghJszYOOTY0uZafHt0xHw5PVNU0787jMJEp4pV8?=
 =?us-ascii?Q?UsyFEswDljC0+X9E/KvbqyMEW7NSorMBgX0j4kwpIrQhTPOhDuzhmq39CySC?=
 =?us-ascii?Q?hCrG5aQ3e+ge0dkRaI7bZsjPNB7dD3oRtgA7nNEU9DqE7JIHEXhBEFT+WYmg?=
 =?us-ascii?Q?xNORtHZ6y2JlRPyKdDOb9GbwHf/dB9scIGEnYo5Q1bg1bf3p/IDFStmCOCDR?=
 =?us-ascii?Q?5gMzAMZX2HRKmKcOHVBzZiuJu4HCFw3Ev9dd+zH8gSwAwXR9MROBfQqec6DW?=
 =?us-ascii?Q?nyqQVgkdcg0FpgpZo01gX9+42yaBlXP1oY1kGvlr1F+T4NZa2AFBIIOdjzTc?=
 =?us-ascii?Q?o7dZ2tpupEuvGiXpavTbJqRdscISWnfJJl8Hkb2CZxlHmQ1mjeH/dOhoxYE4?=
 =?us-ascii?Q?7F7Iwpg0MifFAn1yjNpIt5rNDmppp9tBZLf5anZifYYRj5p0rNarbVAil57I?=
 =?us-ascii?Q?0KOVwYsAWaHmBdj08jwTxi5X2nn53q/+3wsDFpmGGvufA+RK4Kiv5Ck7ih27?=
 =?us-ascii?Q?Zqv2JPRepRdOLwXXtyFhNSp3ZMu3P6j29xGKYkT2/UPPYDlepPM6LnmeWs6Q?=
 =?us-ascii?Q?MYmgmZZeQrF9eq5dLhUj8enK1Fjym8GIO0k/hRXZjlfakmV/YQUc7RMF9RWt?=
 =?us-ascii?Q?eVpw7DMCSochqnfquK05FUoWnwVscGvu/VxWdOFKcZCVvOT2stiCz0aTmEEl?=
 =?us-ascii?Q?Ffh+I/5dQciFhy/n/5xSV5eEfEnKW9s=3D?=
X-Exchange-RoutingPolicyChecked:
	vVWcCb5Nq2AzOIh7QABrZaGGb6lTzO00sbIqVVzTyjgePO3yE4vldM3c8H9WKpfckB0BX0kmKM52O+Ns3FXTBqeOoXpOxQNyYfIV2zbq1893iokRL0RvUxbHKmxaZpaK04G0hx00Yasg17ODLe0anY5VwDRtpVFyLRpYyREqBflgz/w30s0d1qiWDcM2cCbTpa9tAgBt6jFROXu2EMUYM1h4THZ9hrGoezLdsyf4DruP1mb7BoQrUH/zjWOcawK8sDgbkzlwuziqlfIf72lcIS1dTstgAfaHwNub8XyEFsCibBQT3TWtEh0ssdY+I1nck8Mg+gB/f3gBQU34RfkrEA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qRo/Slc4QP4YdRFYQTXF1k3SIfD2BIdFv0QjcFBmSDGQt6z9Yv9KOPEd2/znhWxxvWwYcc6eMnT3tu9JaF21Xa9gtVHk0Hgq81saBVXGuHIlE0kDIM+29mpWlm+4g/myQHhEygQP+LaBUbdsgWBDp+jYdkmd4za9+zgnH94HF1VoDSkEuOVyL+lmfV0BAuANRwq4esbBz4i/zhxk/eVeTKXu9fWjbo5t5ifr4sd434tFBRd7+fGUO4jiP/ffvcwV61KlvuV9BxmevyjWs89W9jXaDNqOXDYpc7qkMLC1sqOdz9WgmCxUlWOfw8nUZ5XK0okAXFlYRxk/Em/PIWvRgJ71HXAFAT3+OJVu1Mfx62if/o5enVHJr8cb63NVi3Bb553aagHxXVFkqFycQ0fjnbzEjglDKeeyxliGsHTS/bTj8vvXdKdLjkNkdfLiThyGh7oDUaTiDeubHEMSaaWOBg1NhFGpQ41C7nkddfMdBezvymkiwcKox9gV3WBNaKCITtXTgb7D8xO37Snfs3QRKjGt0O2OiJmrWVUVTjIYAr3lHRGcOYdVOlhqWtThhqi5UMovCm6HrUvmAiqZ7J9+tpH/msfjcqIrQJ6HxdET2LH9xoP6aSy6AAhtH2jqFad7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fe16d47-7d69-46d9-cd33-08df17ab2d22
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 06:40:07.4844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7eYjQxIB9YCtOsqfTDNM4ndYdYDG8Bk3KJeZiZgHOCX110OYts8F9480JkGiSjnjO5yZzU0Nd9CalQ7uwETc13RVm9qXLED2oYp3HKLc0ts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB994494

To+: 0wnerD1ed <l7z@0b1t.tech>

On Sep 09, 2026 / 09:09, Christoph Hellwig wrote:
> Currently direct I/O reads always bounce buffer the I/O to deal with
> the case where userspace is modifying the buffer in-flight while
> reading data into it.
> 
> This is a very expensive countermeasure for something no sane application
> should do, so try to avoid it by reading without a bounce buffer first,
> and retrying the read on a checksum failure.  This avoids the cost of
> bounce buffering for sanely behave applications.  For the rare case of
> an application regularly modifying in-flight buffers, allow forcing the
> always bounce buffer behavior through sysfs.  And now that we have that
> knob, allow disabling read-side bounce buffering entirely for those who
> live fast and dangerous.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

I found that recent blktests CI trial runs started reporting the failure of
the test case block/046 [1]. I confirmed that it is observed with the kernel at
the linux-block for-next branch. I bisected and found the this commit triggers
the failure. The error message "preadv returned -1 (errno 22)" was printed at
src/bio-bounce-read.c line 121 [2].

AFAIU, the test case does direct read to a null_blk with bounce buffer, and the
kernel side introduced some new requirements to use bounce buffer for direct
I/Os. Then, I guess the test case requires some refinements to meet the new
requirements.

0wnerD1ed, may I ask your help to fix this failure? At this moment, I don't have
much time to dig into this.


[1] failure console log

block/046 (test partial bounced direct read bvec alignment)  [failed]
    runtime  1.174s  ...  1.199s
    --- tests/block/046.out     2026-08-03 19:26:40.410053604 +0900
    +++ /home/shin/Blktests/blktests/results/nodev/block/046.out.bad    2026-09-20 20:14:33.795794868 +0900
    @@ -1,2 +1,4 @@
     Running block/046
    +bio-bounce-read: preadv returned -1 (errno 22)
    +bio-bounce-read helper failed
     Test complete

[2] https://github.com/linux-blktests/blktests/blob/f0603f960dcc2fc215161545b4b94633222a35ac/src/bio-bounce-read.c#L121
