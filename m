Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7405274650
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 02:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789527235; cv=fail; b=e7QbzyQ3PT2yb4+SXql9MJMc87CSr9XKp+nRONF+OLjAZYO9ljJWXIPxMOWSoL/2Ahq8F2iHG7K1yg+q4LgEMDoOw8yoFpTn+iBM5x5/sWLV0NzewbAXUV3avWH/FKGDdYT58rA9YV6gdtGP+PkiVVObJZKv6UEWnr8lFtDfkaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789527235; c=relaxed/simple;
	bh=U+Gnc7PiFFp9JujMo6O/VaiVE7MdozzoPv6zSdJG4hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QWJoNDMilwjEI2FQmmuymF/fCpTN4NjQwDNO0MFjZs0ex691mcfLV6rwj51c+GoppwvH1604ecpvieF3wK9VxAdcsHNUGWoFEnfXX/MVyAdhvtlChEkeDh+aje7HOJcRD6b0WQUv+3IITQEkcwafqRxNvc3skoyKke6gPtRHXiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=E9Ra5kBp; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=XfK8Kmt0; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="E9Ra5kBp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XfK8Kmt0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789527232; x=1821063232;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U+Gnc7PiFFp9JujMo6O/VaiVE7MdozzoPv6zSdJG4hg=;
  b=E9Ra5kBp5l0Hi0ra+DwVpKUHHjzYlt3TsOSB61gf1JsWrTuvqIP+YWGQ
   4RA/02N8KnslJ+3sqaAi8SHndicvrS1Kqdb4TxkzLtZHQj2vk255BJ2ha
   EVd/JBguKrQqOOsgZNaOmUy9ej4fr8COu+Ww08oLUuRQ4Enzmh+7VLYsf
   Se+jSKchr/K53dmancNscqNvoNNoLWOUNsAjdnYV38hr6iUSck8Hzl22o
   pclUi+mt/t+/HfHbEw2pV4Nhlsv7UQe4Zl7RnTLlZlhKFoE/oI75utf4b
   MIHXqaWiYJkk7eb6cN2aV0omdf9IKdpr0G60wp6YLg53EgnCARwn5qcOq
   Q==;
X-CSE-ConnectionGUID: Qk8nwe99QlexiKtuROgkLA==
X-CSE-MsgGUID: LM9H22NGRkKLHj1QhshOKw==
X-IronPort-AV: E=Sophos;i="6.27,103,1786982400"; 
   d="scan'208";a="155600399"
Received: from mail-westcentralusazon11013059.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Sep 2026 10:53:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xAFxh2PH+qZztWgn97K383paLyuDHWPNnDEQRLkPIEn6L7x7IBM/8d6x+VY0mQJR5kFYR9Bl5y8bEvpUBskjpkfzRZtjOavbD4gCRJxBl9gj2yk73gLLBh9Da1nI9U4E3UwZkQHLOvWuSBc4CQCuW0uUZq1vQuSy+2s8rFvwuCI/tyzak/wgiGoiq6XEWsxUtgxvRt6fZ/rfIGifkehV3TwPww1OWjr9wArPU2jz6awoF6MtyOi38+j6I5/fX8i4RXBpvHPlGRxLpQu1sIyTT0RSr1avXqulRJ/z4irM/FcoSCTxazc1t/kaLFYETfIMy4MZD365qIo+MoGFX82kfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUpK6NYmoIkjPgKoNUvmNEfQpBG5HUOpFIh1Y31ZQcM=;
 b=Rb7s89nXujr1YN6EJO3SjPnzhFiYndBGepWQJ/poo84MHYXSnpSVUTiCLuw7CmFOzLJn7aI7zz2VJ/0PgLAmkDGaDsiaArnkAko61Tg54M1ZHOqcPrDGAC2kVM2TR5TfNrXAbMfJsbEZ6rFRwvd716hfODvUixKf1RyoOwwdVLoM8qD0CxBDDeRm0LzwGVk/N58MRTG1uixa7N9HK9HZVpUXeJ+2t/oh6DE4TJm7tRNOB6NMUOa4/86/tpXi+W4s1Qfj/WZNSVnbsOLb4Zp5oR6aKfoSR5WxlfSjjSzYzDK3wrJovDyQcsg9U0g7GqUXnTKT1M1+FGY6iPy8jjai2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUpK6NYmoIkjPgKoNUvmNEfQpBG5HUOpFIh1Y31ZQcM=;
 b=XfK8Kmt02FIbaMbEB0dsM6hIWXoGBuBbAXQxQa97XHFTsLXInqmIuUPuw6EBdmo2uN2iVPp9v2vpfu4r5iIkliFz8KiyYJ1sVcx8LwaStzS33tBxt8P5FQdXAw+USx/QvXDOSQHseS8eoZts03ajl7r+syz/PgpNi7dj0IUcsLM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by DM8PR04MB630426.namprd04.prod.outlook.com
 (2603:10b6:5:36a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 02:53:47 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%4]) with mapi id 15.21.0406.007; Wed, 16 Sep 2026
 02:53:47 +0000
Date: Wed, 16 Sep 2026 11:53:41 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: John Garry <john.garry@linux.dev>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <aqoEOImeqWI9HG1F@shinmob>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <98190f62-ccc3-49df-934d-f168e293c485@linux.dev>
 <aqkv-2opTlWD6bzU@shinmob>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqkv-2opTlWD6bzU@shinmob>
X-ClientProxiedBy: TYCP286CA0301.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:38b::17) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|DM8PR04MB630426:EE_
X-MS-Office365-Filtering-Correlation-Id: 12aadc1c-0010-4f94-1e97-08df139dba87
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|376014|23010399003|1800799024|56012099006|11063799006|10067099003|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	lBEft5G8Wq27a7/cGBXsXJLaNPErzgc2gwkhBviz3w7STf6l8CVrJkbTXAVKlhNjUxgjjIVOC5SJRJj/RWhqYTwKlhqleB0nk355RuVPM7yHilLpgKke6Bh1hHx9KfjR2iFSo0vHW8UIgjLjtTJC+Dva3E7mth3GiAI7URcXVboHZZ7i6R264aF66fsxsM0BY6tiVEiepvUwyC3VoA6HxibxvQt7hVUooA1XKmbHPTdHzsWBER1mOwtqHnGKqrWpDAJKt2X1BSOM/P4k4b/PAcRVq5oBSKsxSkUAOnSaxjfkvZq4nZZHsyRb1O7JPPhi8n4aAhh+u7SHCsHrtz0mvan9r4+hFyvTiz9Aao3zv0jedp5G3En9/wLPyp42WA3N1zSDRf1garK4qqCsTQA9sLecd2MndE70S+D0MpOq2nKJHQypy9kUqd9uQEyUUjNAhsL8qQ+/wYs0OSThJm7FJDWuDD0GsuzJ5Vw1j8cVYqJuGgOGqaZpKk1MNGjirI4s1cQUh+JBkvrwAxaKemXCzXEmS1yz48LBQ98H0zg9FqtWGyf/aDILMBmZBnpEsIof32WLZuq/rsyBsRffa7CZcW0yFaxnI2tndBEzZYX6OIzLZ+QfqF3NjME2VHKLxwcW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(23010399003)(1800799024)(56012099006)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aVQ8ZjW2xBIvqxljlTi+mngip8iz73ZAJpk4qAOswnzutsfk6YEMS6Ir5XwA?=
 =?us-ascii?Q?V4plMzN5KoQpTAPLPOAFGvlLzHJIWl+j04TGt1WEfRXVF70EdritlAlyl92D?=
 =?us-ascii?Q?DGpu+ZfrMu025UuWa4Ug9FwGzZdpEkGyO+TA8rb17sA/weV5pOcdd4+dv8BJ?=
 =?us-ascii?Q?52cV2yPRbBVULz8YJdK2Bq9480OHOAw9itcg/ci5z0f8mKtZj2vFnwvasgLc?=
 =?us-ascii?Q?nGFPrTTEs1+SohiG3/PPG6+pSXXNVZtytylUaefd/9gGcpTHLPa73IVNLvVR?=
 =?us-ascii?Q?dHMpDeWky5wUOEzKaV/32cAMdHAjly4LPzeUKnDxsdxxqNSRaAOBYHZl1GsN?=
 =?us-ascii?Q?ZKco+xPr5zWA3Xd6Lm5onc+A7DQQmFESGYS3Kr8bGJ4+duMHl8hTDPNKJzP8?=
 =?us-ascii?Q?wMAfim03J81wthx0co4a62YuzE3/ibboW14vsfWNdVVA99FXS8cUPuSrBL0D?=
 =?us-ascii?Q?hvDMxTpN0TjONkZNTG+eLNDQkOrmliOql88KpPZXZh9N5xioONC6VU29e8kF?=
 =?us-ascii?Q?qUszG07wP5flYXoSG5QjRnN10GQq4B2jV4/+NjEwQCN3igEvfhABwnDkiBva?=
 =?us-ascii?Q?0T5Su8Idd3AU9dLIwNQfXl5/ltEC4nQ3qEx/qN3IrwVRZ2CpfiXWWOqg7tz3?=
 =?us-ascii?Q?u+ZWnjt0xhis666gCuiv/5eEP5OTSvzgEULJoOnXNl/uOKgWYuqqcqCdutTg?=
 =?us-ascii?Q?g1wxJz40e4vjt38rjnn4jRIzyg0QCGMyaoNZUVOmwdW0qmM+6n1faR6HnF9o?=
 =?us-ascii?Q?SnTr7sSk9vQVFeMjiUBYm4Urw+GM18P8yX1wmct/DKnRN88LuZxJX3FdMd+S?=
 =?us-ascii?Q?QXqhbKfIMnj/hK89uetiu+fmS/pMqSLHU0rxIxaaeOZdApoFj1865DIu73xo?=
 =?us-ascii?Q?RGUTJeIlS2zFu7V8qcg21KRrpOfRpVSmCCCMtksA6A8rUrj5vriqpsySmycP?=
 =?us-ascii?Q?LVGTyNsvYZsMvskKp2FaCZXKRuatO6QzVlF+pldj3w/3TlvxjVDRkHnqxtln?=
 =?us-ascii?Q?+X8pH9kX1NuvK9BFuy24gOeS5D72anunJKFW6ABr/ewA3SkCD04QN3yIx+pl?=
 =?us-ascii?Q?N2BpppRe7TOY1gmrjnZWMdIsunWSDyaCN68x2k44sQSE8ttcydCItq64OakO?=
 =?us-ascii?Q?UrQqHocCzedvDYjf03Gat6GdLcAfieJiGiJkASuwx+Vx/PJ0QZiCSZNkRbkZ?=
 =?us-ascii?Q?Uv4LZQOGsoVMIIA9AzJ4I37EbFl7zV7OU4eMyfHtpiF6d628xBvM5jxoxZAq?=
 =?us-ascii?Q?6uFt3IeW0WAH9q2upk4/KEH/2p66Zj7y+UyqfA9r93myuS6czRKUa3eXE894?=
 =?us-ascii?Q?bCoQdr5M58uEQ1/vcfLuw9MXDVJI7bIuR6cqbK012a9B6P9u8gp7MfOR+7yK?=
 =?us-ascii?Q?4fxfzhDtLOs/k9PFNRzASrWICzTKLlhqbNfP3qzOr8DLIFAt0ythixkFriWT?=
 =?us-ascii?Q?aZsU9kb/+r+Z8WZwsYp1+Wa59eC9nCN3rSpg0S7zb9+tnm2bPzpDrixBZdCY?=
 =?us-ascii?Q?kALol2kZiLTC5bBzvotQtUH0pvMSkCc/ISUd9V/UTKHDKOnnJ6rQkvbR1MwX?=
 =?us-ascii?Q?YAOsyeNBbYV3u8tUKJze9WwZqyPZvDZNqderlMQCmVbHndOaZ2Ipwg0y9z6i?=
 =?us-ascii?Q?80XmSUCgNSc6lEjBRY1CQbJ4VohBczeE88A1IAjQY8SS3FA48dFfq5Mh51Lo?=
 =?us-ascii?Q?4IOIIsvWZV8PX4/unZ4P/tY/9jo2fo6UIIHwd17XJ5coo+BLh4cxYxRmCqGE?=
 =?us-ascii?Q?E718t3Y/cca+htMG92vA450AlRvqnDc=3D?=
X-Exchange-RoutingPolicyChecked:
	dsyhsz4dGk1M5zZxciuvXfntJ2mW464hbvqOqoCOgO13ghrPRw3w/FqTUiZ1J6HoxvRqMFsW+X8Br/QJtVVv8538Fz7kJq7gYFfkYB6Ow3L7pWzV7jrZIjHktmYXZRzQkl8/AMlrZ1CHeEb+7Lj1wuofjzq/OgflBdZuhp5jAcCcIbIZiCifBn55R9hxBmlbA41JqJ8VEWjK+M6olFACrDvBEnBwZq+yvbE5Y5mq1pNJnZb5Zda/gqZzncPdzd5C8klgtUBKpx2OQYxm0Ei3iVz7LheFoxVJg3jTpYC/u5xwKIbGoPcYTiTQZe5bGz+1pWcTzTJOF/tOZqE/5YYs7g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kC6jsRncjD7lBeJh2SlMISl+BI7RKRcWdZrdjLmeczvZoST8iYAPQi/MMQ9uvGP9u/5y0OxEVdUyrzOzW5GWAAH9mKyu//NsU7fizNLDwlFXaf/RVxsWUocGGYscyoV26JwpTYzVog0V3mBwC2R2GqJd10zrGD14it2jQweGC9obYIp8Ei/FD8V8AhtYtC0U+TAm0PPxch/vbEIdO/54ombwCFqIcqNDvy9KEUxwX9MzTaEl7C+NMa0CCYU1455EF4W/3U7sdtlpRpYAxv4qDaSviATW3q1Of0pDpz3zeDDIhYXowk47uNnWazM2+QPawYhjpaFJBxYAVVSCXXc6H7DZpH8GAtyamT8K2uPcrdpHX3p853Dl2UnBDAeChTAXqv7QBedayLAHO0cqL2vtMIquC04mG6ErKuUGrJQLQDN21A8mWzolFrOdQ6irZdhi9z9CF2OzIp9OkC9I6AS21HkX4g4vHxj3cUh2KM4nLhNk7/YRRzBz5SKWOmddREuRcx12XI+hYxXphWyFx3sjexxoP255HzHCuq1Nj7QzlQWw/VaH5Uvw5yMTaL6n5G7vqwVY20/Rdiolgplx3gG5dYEK2/oX7kDnnjCPKtaZYKjx1kB1mwuVVosJdw6RbiAb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12aadc1c-0010-4f94-1e97-08df139dba87
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 02:53:47.2357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFeiH1pbH6AGn2vkV0seSiaqXL7yTcFsB0acQQ5J0mVEdNbzhSs1PinxkeJEmdtK2RUSzTWz7v0koNkgKNWSW5a2BC4WFcqZ2LygKrQNwfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB630426

On Sep 15, 2026 / 20:48, Shin'ichiro Kawasaki wrote:
> On Sep 15, 2026 / 11:00, John Garry wrote:
> > On 9/15/26 10:34, Shin'ichiro Kawasaki wrote:
> > > I observe the fstests test case generic/774 hangs, when I run it for xfs on 8GiB
> > > TCMU fileio devices. Actually I once reported this hang symptom in last October,
> > > and Darrick and John kindly took some actions [1]. Since then, the hang
> > > disappeared and I have not observed the hang almost one year. However, my test
> > > system started reporting the hang again last week.
> > > 
> > > [1] https://lore.kernel.org/linux-xfs/cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2/#t
> > 
> > This was the series to resolve, I think:
> > https://lore.kernel.org/fstests/176279908967.605950.2192923313361120314.stgit@frogsfrogsfrogs/T/#t
> > 
> > As an experiment, can you reduce the file size further, like:
> > 
> > --- a/tests/generic/774
> > +++ b/tests/generic/774
> > @@ -29,7 +29,7 @@ aw_bsize=$(_max "$awu_min_write" "$((awu_max_write/4))")
> >  fsbsize=$(_get_block_size $SCRATCH_MNT)
> > 
> >  threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
> > -filesize=$((aw_bsize * threads * 10))
> > +filesize=$((aw_bsize * threads))
> >  depth=$threads
> >  aw_io_size=$((filesize / threads))
> >  aw_io_inc=$aw_io_size
> 
> Thanks for the response. I repeated the test case 100 times with the change
> above, and I did not observe the hang. The change looks avoiding the hang.
> 
> > 
> > > 
> > > FYI, here I attache the kernel message [2].
> > 
> > Is mainline baseline hanging, i.e. v7.3-rc2?
> 
> I will try this out tomorrow.

I observed the hang with the mainline v7.3-rc2 kernel also:

[  516.678848] [   T5360] run fstests generic/774 at 2026-09-16 11:01:26
[  516.808855] [   T2710] MODE SENSE: unimplemented page/subpage: 0x0a/0x05
[  519.197067] [   T2825] MODE SENSE: unimplemented page/subpage: 0x0a/0x05
[  519.325438] [   T6378] XFS (sdh): Mounting V5 Filesystem f004c5a8-b5fd-4f05-9ea1-977c32c9fc76
[  519.342073] [   T6378] XFS (sdh): Ending clean mount
[  519.704393] [   T6429] XFS (sdh): Unmounting Filesystem f004c5a8-b5fd-4f05-9ea1-977c32c9fc76
[  520.341237] [   T2904] MODE SENSE: unimplemented page/subpage: 0x0a/0x05
[  520.461538] [   T6477] XFS (sdh): Mounting V5 Filesystem dcd73d62-bc80-42a1-9893-7815befb6fd1
[  520.480790] [   T6477] XFS (sdh): Ending clean mount
[  862.484216] [    T169] INFO: task kworker/0:0:9 blocked for more than 122 seconds.
[  862.486738] [    T169]       Tainted: G        W           7.3.0-rc2-kts-xfs+ #3
[  862.488497] [    T169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  862.491457] [    T169] task:kworker/0:0     state:D stack:0     pid:9     tgid:9     ppid:2      task_flags:0x4248060 flags:0x00080000
[  862.493590] [    T169] Workqueue: dio/sdh iomap_dio_complete_work
[  862.494696] [    T169] Call Trace:
[  862.496681] [    T169]  <TASK>
[  862.497741] [    T169]  __schedule+0xc86/0x1b10
[  862.499020] [    T169]  ? trace_hardirqs_on+0x18/0x1a0
[  862.500434] [    T169]  ? __pfx___schedule+0x10/0x10
[  862.501999] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.503638] [    T169]  ? wq_worker_sleeping+0x213/0x280
[  862.505095] [    T169]  ? lock_acquire+0x11a/0x140
[  862.506540] [    T169]  schedule+0xe5/0x2e0
[  862.507546] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.508858] [    T169]  schedule_preempt_disabled+0x16/0x30
[  862.510463] [    T169]  rwsem_down_write_slowpath+0x4b4/0x1460
[  862.511857] [    T169]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  862.513526] [    T169]  ? percpu_counter_add_batch+0x80/0x220
[  862.514807] [    T169]  ? lock_acquire+0x11a/0x140
[  862.516272] [    T169]  down_write_nested+0x1c0/0x1f0
[  862.517706] [    T169]  ? __pfx_down_write_nested+0x10/0x10
[  862.519465] [    T169]  ? xfs_ilock+0x1e7/0x310 [xfs]
[  862.522491] [    T169]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
[  862.525468] [    T169]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
[  862.528537] [    T169]  ? lock_acquire+0x11a/0x140
[  862.529870] [    T169]  ? update_cfs_rq_load_avg+0x4b/0x660
[  862.531028] [    T169]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
[  862.533879] [    T169]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
[  862.536645] [    T169]  iomap_dio_complete+0x140/0xb20
[  862.537895] [    T169]  ? __pfx_aio_complete_rw+0x10/0x10
[  862.539424] [    T169]  iomap_dio_complete_work+0x58/0x90
[  862.540711] [    T169]  process_one_work+0x947/0x1760
[  862.542425] [    T169]  ? __pfx_process_one_work+0x10/0x10
[  862.543881] [    T169]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  862.545586] [    T169]  worker_thread+0x601/0xff0
[  862.547505] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  862.548953] [    T169]  kthread+0x361/0x460
[  862.550636] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.552067] [    T169]  ret_from_fork+0x560/0x860
[  862.598716] [    T169]  ? __pfx_ret_from_fork+0x10/0x10
[  862.599886] [    T169]  ? __switch_to+0x473/0xd50
[  862.601344] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.602570] [    T169]  ret_from_fork_asm+0x1a/0x30
[  862.604391] [    T169]  </TASK>
[  862.605720] [    T169] INFO: task kworker/0:0:9 <writer> blocked on an rw-semaphore likely owned by task kworker/14:8:2880 <writer>
[  862.608060] [    T169] INFO: task kworker/10:0:95 blocked for more than 123 seconds.
[  862.610611] [    T169]       Tainted: G        W           7.3.0-rc2-kts-xfs+ #3
[  862.612670] [    T169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  862.615074] [    T169] task:kworker/10:0    state:D stack:0     pid:95    tgid:95    ppid:2      task_flags:0x4248060 flags:0x00080000
[  862.617510] [    T169] Workqueue: dio/sdh iomap_dio_complete_work
[  862.618863] [    T169] Call Trace:
[  862.619984] [    T169]  <TASK>
[  862.621425] [    T169]  __schedule+0xc86/0x1b10
[  862.622635] [    T169]  ? trace_hardirqs_on+0x18/0x1a0
[  862.623900] [    T169]  ? __pfx___schedule+0x10/0x10
[  862.625384] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.626539] [    T169]  ? wq_worker_sleeping+0x213/0x280
[  862.627851] [    T169]  ? rcu_is_watching+0x69/0x90
[  862.629309] [    T169]  ? lock_acquire+0x11a/0x140
[  862.630501] [    T169]  schedule+0xe5/0x2e0
[  862.631786] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.633410] [    T169]  schedule_preempt_disabled+0x16/0x30
[  862.634482] [    T169]  rwsem_down_write_slowpath+0x4b4/0x1460
[  862.635829] [    T169]  ? __kasan_slab_alloc+0x7f/0x90
[  862.637088] [    T169]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  862.638545] [    T169]  ? percpu_counter_add_batch+0x80/0x220
[  862.639768] [    T169]  ? lock_acquire+0x11a/0x140
[  862.641378] [    T169]  down_write_nested+0x1c0/0x1f0
[  862.642616] [    T169]  ? __pfx_down_write_nested+0x10/0x10
[  862.644347] [    T169]  ? xfs_ilock+0x1e7/0x310 [xfs]
[  862.646648] [    T169]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
[  862.649368] [    T169]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
[  862.651640] [    T169]  ? update_load_avg+0xb65/0x2c70
[  862.652721] [    T169]  ? update_cfs_rq_load_avg+0x4b/0x660
[  862.653736] [    T169]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
[  862.656196] [    T169]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
[  862.658537] [    T169]  iomap_dio_complete+0x140/0xb20
[  862.659475] [    T169]  ? __pfx_aio_complete_rw+0x10/0x10
[  862.660451] [    T169]  iomap_dio_complete_work+0x58/0x90
[  862.661510] [    T169]  process_one_work+0x947/0x1760
[  862.662631] [    T169]  ? __pfx_process_one_work+0x10/0x10
[  862.663652] [    T169]  ? __try_to_del_timer_sync+0xd3/0x130
[  862.664757] [    T169]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  862.665845] [    T169]  worker_thread+0x601/0xff0
[  862.666850] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  862.667903] [    T169]  kthread+0x361/0x460
[  862.669351] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.670628] [    T169]  ret_from_fork+0x560/0x860
[  862.671393] [    T169]  ? __pfx_ret_from_fork+0x10/0x10
[  862.672180] [    T169]  ? __switch_to+0x473/0xd50
[  862.673196] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.674012] [    T169]  ret_from_fork_asm+0x1a/0x30
[  862.675087] [    T169]  </TASK>
[  862.675904] [    T169] INFO: task kworker/10:0:95 <writer> blocked on an rw-semaphore likely owned by task kworker/14:8:2880 <writer>
[  862.677484] [    T169] INFO: task kworker/13:0:107 blocked for more than 123 seconds.
[  862.678751] [    T169]       Tainted: G        W           7.3.0-rc2-kts-xfs+ #3
[  862.679934] [    T169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  862.681454] [    T169] task:kworker/13:0    state:D stack:0     pid:107   tgid:107   ppid:2      task_flags:0x4248060 flags:0x00080000
[  862.683148] [    T169] Workqueue: dio/sdh iomap_dio_complete_work
[  862.684174] [    T169] Call Trace:
[  862.685025] [    T169]  <TASK>
[  862.685742] [    T169]  __schedule+0xc86/0x1b10
[  862.686690] [    T169]  ? trace_hardirqs_on+0x18/0x1a0
[  862.687637] [    T169]  ? __pfx___schedule+0x10/0x10
[  862.688543] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.689410] [    T169]  ? wq_worker_sleeping+0x213/0x280
[  862.690380] [    T169]  ? lock_acquire+0x11a/0x140
[  862.691570] [    T169]  schedule+0xe5/0x2e0
[  862.692351] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.693301] [    T169]  schedule_preempt_disabled+0x16/0x30
[  862.694317] [    T169]  rwsem_down_write_slowpath+0x4b4/0x1460
[  862.695571] [    T169]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  862.696636] [    T169]  ? percpu_counter_add_batch+0x80/0x220
[  862.697620] [    T169]  ? lock_acquire+0x11a/0x140
[  862.698603] [    T169]  down_write_nested+0x1c0/0x1f0
[  862.699567] [    T169]  ? __pfx_down_write_nested+0x10/0x10
[  862.700843] [    T169]  ? xfs_ilock+0x1e7/0x310 [xfs]
[  862.702991] [    T169]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
[  862.705330] [    T169]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
[  862.707139] [    T169]  ? update_cfs_rq_load_avg+0x4b/0x660
[  862.708286] [    T169]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
[  862.709873] [    T169]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
[  862.711607] [    T169]  iomap_dio_complete+0x140/0xb20
[  862.712622] [    T169]  ? __pfx_aio_complete_rw+0x10/0x10
[  862.713758] [    T169]  iomap_dio_complete_work+0x58/0x90
[  862.714854] [    T169]  process_one_work+0x947/0x1760
[  862.715809] [    T169]  ? __pfx_process_one_work+0x10/0x10
[  862.716900] [    T169]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  862.718142] [    T169]  worker_thread+0x601/0xff0
[  862.719263] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  862.720613] [    T169]  kthread+0x361/0x460
[  862.721568] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.722681] [    T169]  ret_from_fork+0x560/0x860
[  862.723567] [    T169]  ? __pfx_ret_from_fork+0x10/0x10
[  862.724692] [    T169]  ? __switch_to+0x473/0xd50
[  862.725643] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.726494] [    T169]  ret_from_fork_asm+0x1a/0x30
[  862.727727] [    T169]  </TASK>
[  862.728590] [    T169] INFO: task kworker/13:0:107 <writer> blocked on an rw-semaphore likely owned by task kworker/14:8:2880 <writer>
[  862.730308] [    T169] INFO: task kworker/18:0:131 blocked for more than 123 seconds.
[  862.731761] [    T169]       Tainted: G        W           7.3.0-rc2-kts-xfs+ #3
[  862.732954] [    T169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  862.734431] [    T169] task:kworker/18:0    state:D stack:0     pid:131   tgid:131   ppid:2      task_flags:0x4248060 flags:0x00080000
[  862.735987] [    T169] Workqueue: dio/sdh iomap_dio_complete_work
[  862.737180] [    T169] Call Trace:
[  862.737922] [    T169]  <TASK>
[  862.738784] [    T169]  __schedule+0xc86/0x1b10
[  862.739699] [    T169]  ? trace_hardirqs_on+0x18/0x1a0
[  862.740958] [    T169]  ? __pfx___schedule+0x10/0x10
[  862.742223] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.743837] [    T169]  ? wq_worker_sleeping+0x213/0x280
[  862.745556] [    T169]  ? lock_acquire+0x11a/0x140
[  862.747573] [    T169]  schedule+0xe5/0x2e0
[  862.749001] [    T169]  xlog_grant_head_wait+0x175/0xac0 [xfs]
[  862.751614] [    T169]  xlog_grant_head_check+0x312/0x3f0 [xfs]
[  862.754331] [    T169]  ? __pfx_xlog_grant_head_check+0x10/0x10 [xfs]
[  862.757018] [    T169]  xfs_log_reserve+0x2b2/0x7a0 [xfs]
[  862.759361] [    T169]  ? percpu_counter_add_batch+0x80/0x220
[  862.760571] [    T169]  ? __pfx_xfs_log_reserve+0x10/0x10 [xfs]
[  862.763313] [    T169]  ? xfs_dec_freecounter+0x81/0x520 [xfs]
[  862.765660] [    T169]  xfs_trans_alloc+0x1a4/0x820 [xfs]
[  862.767935] [    T169]  xfs_reflink_end_atomic_cow+0x1b1/0x560 [xfs]
[  862.770604] [    T169]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
[  862.773762] [    T169]  ? update_cfs_rq_load_avg+0x4b/0x660
[  862.774868] [    T169]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
[  862.777326] [    T169]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
[  862.779795] [    T169]  iomap_dio_complete+0x140/0xb20
[  862.780989] [    T169]  ? __pfx_aio_complete_rw+0x10/0x10
[  862.782460] [    T169]  iomap_dio_complete_work+0x58/0x90
[  862.783667] [    T169]  process_one_work+0x947/0x1760
[  862.784759] [    T169]  ? __pfx_process_one_work+0x10/0x10
[  862.786260] [    T169]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  862.787550] [    T169]  worker_thread+0x601/0xff0
[  862.788602] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  862.789757] [    T169]  kthread+0x361/0x460
[  862.790931] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.791965] [    T169]  ret_from_fork+0x560/0x860
[  862.793177] [    T169]  ? __pfx_ret_from_fork+0x10/0x10
[  862.794419] [    T169]  ? __switch_to+0x473/0xd50
[  862.795543] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.796560] [    T169]  ret_from_fork_asm+0x1a/0x30
[  862.797661] [    T169]  </TASK>
[  862.798604] [    T169] INFO: task kworker/21:0:149 blocked for more than 123 seconds.
[  862.800419] [    T169]       Tainted: G        W           7.3.0-rc2-kts-xfs+ #3
[  862.801700] [    T169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  862.803425] [    T169] task:kworker/21:0    state:D stack:0     pid:149   tgid:149   ppid:2      task_flags:0x4248060 flags:0x00080000
[  862.805354] [    T169] Workqueue: dio/sdh iomap_dio_complete_work
[  862.806351] [    T169] Call Trace:
[  862.807571] [    T169]  <TASK>
[  862.808374] [    T169]  __schedule+0xc86/0x1b10
[  862.809575] [    T169]  ? trace_hardirqs_on+0x18/0x1a0
[  862.810650] [    T169]  ? __pfx___schedule+0x10/0x10
[  862.811595] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.812602] [    T169]  ? wq_worker_sleeping+0x213/0x280
[  862.813639] [    T169]  ? rcu_is_watching+0x69/0x90
[  862.814471] [    T169]  ? lock_acquire+0x11a/0x140
[  862.815458] [    T169]  schedule+0xe5/0x2e0
[  862.816473] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.817491] [    T169]  schedule_preempt_disabled+0x16/0x30
[  862.818527] [    T169]  rwsem_down_write_slowpath+0x4b4/0x1460
[  862.819664] [    T169]  ? __kasan_slab_alloc+0x7f/0x90
[  862.820690] [    T169]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  862.821863] [    T169]  ? percpu_counter_add_batch+0x80/0x220
[  862.823035] [    T169]  ? lock_acquire+0x11a/0x140
[  862.882304] [    T169]  down_write_nested+0x1c0/0x1f0
[  862.882992] [    T169]  ? __pfx_down_write_nested+0x10/0x10
[  862.884022] [    T169]  ? xfs_ilock+0x1e7/0x310 [xfs]
[  862.885942] [    T169]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
[  862.888021] [    T169]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
[  862.890047] [    T169]  ? update_load_avg+0xb65/0x2c70
[  862.890723] [    T169]  ? update_cfs_rq_load_avg+0x4b/0x660
[  862.891859] [    T169]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
[  862.893613] [    T169]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
[  862.895520] [    T169]  iomap_dio_complete+0x140/0xb20
[  862.896394] [    T169]  ? __pfx_aio_complete_rw+0x10/0x10
[  862.897155] [    T169]  iomap_dio_complete_work+0x58/0x90
[  862.898492] [    T169]  process_one_work+0x947/0x1760
[  862.899478] [    T169]  ? __pfx_process_one_work+0x10/0x10
[  862.900184] [    T169]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  862.901237] [    T169]  worker_thread+0x601/0xff0
[  862.901968] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  862.903572] [    T169]  kthread+0x361/0x460
[  862.904365] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.905281] [    T169]  ret_from_fork+0x560/0x860
[  862.906378] [    T169]  ? __pfx_ret_from_fork+0x10/0x10
[  862.907247] [    T169]  ? __switch_to+0x473/0xd50
[  862.908264] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.909171] [    T169]  ret_from_fork_asm+0x1a/0x30
[  862.910168] [    T169]  </TASK>
[  862.910906] [    T169] INFO: task kworker/21:0:149 <writer> blocked on an rw-semaphore likely owned by task kworker/14:8:2880 <writer>
[  862.912626] [    T169] INFO: task kworker/10:1:182 blocked for more than 123 seconds.
[  862.913741] [    T169]       Tainted: G        W           7.3.0-rc2-kts-xfs+ #3
[  862.914683] [    T169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  862.915828] [    T169] task:kworker/10:1    state:D stack:0     pid:182   tgid:182   ppid:2      task_flags:0x4248060 flags:0x00080000
[  862.917294] [    T169] Workqueue: dio/sdh iomap_dio_complete_work
[  862.918366] [    T169] Call Trace:
[  862.918970] [    T169]  <TASK>
[  862.919592] [    T169]  __schedule+0xc86/0x1b10
[  862.920361] [    T169]  ? trace_hardirqs_on+0x18/0x1a0
[  862.921220] [    T169]  ? __pfx___schedule+0x10/0x10
[  862.922009] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.922876] [    T169]  ? wq_worker_sleeping+0x213/0x280
[  862.923772] [    T169]  ? lock_acquire+0x11a/0x140
[  862.924586] [    T169]  schedule+0xe5/0x2e0
[  862.925449] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.926194] [    T169]  schedule_preempt_disabled+0x16/0x30
[  862.927011] [    T169]  rwsem_down_write_slowpath+0x4b4/0x1460
[  862.927988] [    T169]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  862.928985] [    T169]  ? percpu_counter_add_batch+0x80/0x220
[  862.930050] [    T169]  ? lock_acquire+0x11a/0x140
[  862.930852] [    T169]  down_write_nested+0x1c0/0x1f0
[  862.931837] [    T169]  ? __pfx_down_write_nested+0x10/0x10
[  862.932707] [    T169]  ? xfs_ilock+0x1e7/0x310 [xfs]
[  862.934501] [    T169]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
[  862.936477] [    T169]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
[  862.938135] [    T169]  ? update_cfs_rq_load_avg+0x4b/0x660
[  862.939145] [    T169]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
[  862.940733] [    T169]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
[  862.942374] [    T169]  iomap_dio_complete+0x140/0xb20
[  862.943029] [    T169]  ? __pfx_aio_complete_rw+0x10/0x10
[  862.943836] [    T169]  iomap_dio_complete_work+0x58/0x90
[  862.944511] [    T169]  process_one_work+0x947/0x1760
[  862.945264] [    T169]  ? __pfx_process_one_work+0x10/0x10
[  862.945902] [    T169]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  862.946883] [    T169]  worker_thread+0x601/0xff0
[  862.947501] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  862.948411] [    T169]  ? __kthread_parkme+0xbd/0x210
[  862.949411] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  862.950258] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  862.950981] [    T169]  kthread+0x361/0x460
[  862.951742] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.952475] [    T169]  ret_from_fork+0x560/0x860
[  862.953085] [    T169]  ? __pfx_ret_from_fork+0x10/0x10
[  862.953768] [    T169]  ? __switch_to+0x473/0xd50
[  862.954462] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.955329] [    T169]  ret_from_fork_asm+0x1a/0x30
[  862.956135] [    T169]  </TASK>
[  862.956743] [    T169] INFO: task kworker/10:1:182 <writer> blocked on an rw-semaphore likely owned by task kworker/14:8:2880 <writer>
[  862.958496] [    T169] INFO: task kworker/4:1:192 blocked for more than 123 seconds.
[  862.959780] [    T169]       Tainted: G        W           7.3.0-rc2-kts-xfs+ #3
[  862.960649] [    T169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  862.961646] [    T169] task:kworker/4:1     state:D stack:0     pid:192   tgid:192   ppid:2      task_flags:0x4248060 flags:0x00080000
[  862.962802] [    T169] Workqueue: dio/sdh iomap_dio_complete_work
[  862.963656] [    T169] Call Trace:
[  862.964239] [    T169]  <TASK>
[  862.964876] [    T169]  __schedule+0xc86/0x1b10
[  862.965650] [    T169]  ? __pfx___schedule+0x10/0x10
[  862.966357] [    T169]  ? rwsem_optimistic_spin+0x1f0/0x480
[  862.967116] [    T169]  ? wq_worker_sleeping+0x65/0x280
[  862.967818] [    T169]  ? lock_acquire+0x11a/0x140
[  862.968455] [    T169]  schedule+0xe5/0x2e0
[  862.969236] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  862.969956] [    T169]  schedule_preempt_disabled+0x16/0x30
[  862.970745] [    T169]  rwsem_down_write_slowpath+0x4b4/0x1460
[  862.971466] [    T169]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  862.972318] [    T169]  ? percpu_counter_add_batch+0x80/0x220
[  862.973018] [    T169]  ? lock_acquire+0x11a/0x140
[  862.973929] [    T169]  down_write_nested+0x1c0/0x1f0
[  862.974668] [    T169]  ? __pfx_down_write_nested+0x10/0x10
[  862.975517] [    T169]  ? xfs_ilock+0x1e7/0x310 [xfs]
[  862.977132] [    T169]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
[  862.978753] [    T169]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
[  862.980434] [    T169]  ? lock_acquire+0x11a/0x140
[  862.981088] [    T169]  ? update_cfs_rq_load_avg+0x4b/0x660
[  862.981891] [    T169]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
[  862.983313] [    T169]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
[  862.984866] [    T169]  iomap_dio_complete+0x140/0xb20
[  862.985470] [    T169]  ? __pfx_aio_complete_rw+0x10/0x10
[  862.986145] [    T169]  iomap_dio_complete_work+0x58/0x90
[  862.987165] [    T169]  process_one_work+0x947/0x1760
[  862.987782] [    T169]  ? __pfx_process_one_work+0x10/0x10
[  862.988614] [    T169]  ? __try_to_del_timer_sync+0xd3/0x130
[  862.989478] [    T169]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  862.990329] [    T169]  worker_thread+0x601/0xff0
[  862.991073] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  862.991879] [    T169]  kthread+0x361/0x460
[  862.992366] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.992943] [    T169]  ret_from_fork+0x560/0x860
[  862.993616] [    T169]  ? __pfx_ret_from_fork+0x10/0x10
[  862.994429] [    T169]  ? __switch_to+0x473/0xd50
[  862.995061] [    T169]  ? __pfx_kthread+0x10/0x10
[  862.995764] [    T169]  ret_from_fork_asm+0x1a/0x30
[  862.996514] [    T169]  </TASK>
[  862.997177] [    T169] INFO: task kworker/4:1:192 <writer> blocked on an rw-semaphore likely owned by task kworker/14:8:2880 <writer>
[  862.998650] [    T169] INFO: task kworker/13:1:203 blocked for more than 123 seconds.
[  862.999569] [    T169]       Tainted: G        W           7.3.0-rc2-kts-xfs+ #3
[  863.000412] [    T169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  863.001516] [    T169] task:kworker/13:1    state:D stack:0     pid:203   tgid:203   ppid:2      task_flags:0x4248060 flags:0x00080000
[  863.002727] [    T169] Workqueue: dio/sdh iomap_dio_complete_work
[  863.003433] [    T169] Call Trace:
[  863.003999] [    T169]  <TASK>
[  863.004720] [    T169]  __schedule+0xc86/0x1b10
[  863.005341] [    T169]  ? trace_hardirqs_on+0x18/0x1a0
[  863.005926] [    T169]  ? __pfx___schedule+0x10/0x10
[  863.006767] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  863.007384] [    T169]  ? wq_worker_sleeping+0x213/0x280
[  863.008172] [    T169]  ? rcu_is_watching+0x69/0x90
[  863.008798] [    T169]  ? lock_acquire+0x11a/0x140
[  863.009533] [    T169]  schedule+0xe5/0x2e0
[  863.010175] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  863.010753] [    T169]  schedule_preempt_disabled+0x16/0x30
[  863.011389] [    T169]  rwsem_down_write_slowpath+0x4b4/0x1460
[  863.012000] [    T169]  ? __kasan_slab_alloc+0x7f/0x90
[  863.012699] [    T169]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  863.013432] [    T169]  ? percpu_counter_add_batch+0x80/0x220
[  863.014201] [    T169]  ? lock_acquire+0x11a/0x140
[  863.014754] [    T169]  down_write_nested+0x1c0/0x1f0
[  863.015577] [    T169]  ? __pfx_down_write_nested+0x10/0x10
[  863.016221] [    T169]  ? xfs_ilock+0x1e7/0x310 [xfs]
[  863.017869] [    T169]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
[  863.019128] [    T169]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
[  863.020502] [    T169]  ? update_load_avg+0xb65/0x2c70
[  863.021124] [    T169]  ? update_cfs_rq_load_avg+0x4b/0x660
[  863.021694] [    T169]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
[  863.022983] [    T169]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
[  863.024392] [    T169]  iomap_dio_complete+0x140/0xb20
[  863.024936] [    T169]  ? __pfx_aio_complete_rw+0x10/0x10
[  863.025750] [    T169]  iomap_dio_complete_work+0x58/0x90
[  863.026539] [    T169]  process_one_work+0x947/0x1760
[  863.027125] [    T169]  ? __pfx_process_one_work+0x10/0x10
[  863.027748] [    T169]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  863.028469] [    T169]  worker_thread+0x601/0xff0
[  863.029048] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  863.029602] [    T169]  ? __kthread_parkme+0xbd/0x210
[  863.030330] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  863.031083] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  863.031679] [    T169]  kthread+0x361/0x460
[  863.032432] [    T169]  ? __pfx_kthread+0x10/0x10
[  863.033138] [    T169]  ret_from_fork+0x560/0x860
[  863.033773] [    T169]  ? __pfx_ret_from_fork+0x10/0x10
[  863.034384] [    T169]  ? __switch_to+0x473/0xd50
[  863.034950] [    T169]  ? __pfx_kthread+0x10/0x10
[  863.046680] [    T169]  ret_from_fork_asm+0x1a/0x30
[  863.047257] [    T169]  </TASK>
[  863.047797] [    T169] INFO: task kworker/13:1:203 <writer> blocked on an rw-semaphore likely owned by task kworker/14:8:2880 <writer>
[  863.048786] [    T169] INFO: task kworker/7:1:267 blocked for more than 123 seconds.
[  863.049651] [    T169]       Tainted: G        W           7.3.0-rc2-kts-xfs+ #3
[  863.050339] [    T169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  863.051394] [    T169] task:kworker/7:1     state:D stack:0     pid:267   tgid:267   ppid:2      task_flags:0x4248060 flags:0x00080000
[  863.052474] [    T169] Workqueue: dio/sdh iomap_dio_complete_work
[  863.053233] [    T169] Call Trace:
[  863.053879] [    T169]  <TASK>
[  863.054380] [    T169]  __schedule+0xc86/0x1b10
[  863.055017] [    T169]  ? trace_hardirqs_on+0x18/0x1a0
[  863.055705] [    T169]  ? __pfx___schedule+0x10/0x10
[  863.056191] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  863.056776] [    T169]  ? wq_worker_sleeping+0x213/0x280
[  863.057382] [    T169]  ? rcu_is_watching+0x69/0x90
[  863.057888] [    T169]  ? lock_acquire+0x11a/0x140
[  863.058510] [    T169]  schedule+0xe5/0x2e0
[  863.059152] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  863.059634] [    T169]  schedule_preempt_disabled+0x16/0x30
[  863.060191] [    T169]  rwsem_down_write_slowpath+0x4b4/0x1460
[  863.060660] [    T169]  ? __kasan_slab_alloc+0x7f/0x90
[  863.061305] [    T169]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  863.061975] [    T169]  ? percpu_counter_add_batch+0x80/0x220
[  863.062852] [    T169]  ? lock_acquire+0x11a/0x140
[  863.063494] [    T169]  down_write_nested+0x1c0/0x1f0
[  863.063987] [    T169]  ? __pfx_down_write_nested+0x10/0x10
[  863.064651] [    T169]  ? xfs_ilock+0x1e7/0x310 [xfs]
[  863.065744] [    T169]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
[  863.066867] [    T169]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
[  863.068171] [    T169]  ? lock_acquire+0x11a/0x140
[  863.068608] [    T169]  ? update_cfs_rq_load_avg+0x4b/0x660
[  863.069209] [    T169]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
[  863.070280] [    T169]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
[  863.071520] [    T169]  iomap_dio_complete+0x140/0xb20
[  863.072007] [    T169]  ? __pfx_aio_complete_rw+0x10/0x10
[  863.072614] [    T169]  iomap_dio_complete_work+0x58/0x90
[  863.073410] [    T169]  process_one_work+0x947/0x1760
[  863.073943] [    T169]  ? __pfx_process_one_work+0x10/0x10
[  863.074647] [    T169]  ? __try_to_del_timer_sync+0xd3/0x130
[  863.075263] [    T169]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  863.075717] [    T169]  worker_thread+0x601/0xff0
[  863.076457] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  863.076864] [    T169]  kthread+0x361/0x460
[  863.077206] [    T169]  ? __pfx_kthread+0x10/0x10
[  863.077635] [    T169]  ret_from_fork+0x560/0x860
[  863.077979] [    T169]  ? __pfx_ret_from_fork+0x10/0x10
[  863.078467] [    T169]  ? __switch_to+0x473/0xd50
[  863.079013] [    T169]  ? __pfx_kthread+0x10/0x10
[  863.079724] [    T169]  ret_from_fork_asm+0x1a/0x30
[  863.080357] [    T169]  </TASK>
[  863.080782] [    T169] INFO: task kworker/7:1:267 <writer> blocked on an rw-semaphore likely owned by task kworker/14:8:2880 <writer>
[  863.081659] [    T169] INFO: task kworker/18:1:273 blocked for more than 123 seconds.
[  863.082544] [    T169]       Tainted: G        W           7.3.0-rc2-kts-xfs+ #3
[  863.083261] [    T169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  863.084177] [    T169] task:kworker/18:1    state:D stack:0     pid:273   tgid:273   ppid:2      task_flags:0x4248060 flags:0x00080000
[  863.085081] [    T169] Workqueue: dio/sdh iomap_dio_complete_work
[  863.085709] [    T169] Call Trace:
[  863.086190] [    T169]  <TASK>
[  863.086664] [    T169]  __schedule+0xc86/0x1b10
[  863.087350] [    T169]  ? __pfx___schedule+0x10/0x10
[  863.088018] [    T169]  ? rwsem_optimistic_spin+0x1f0/0x480
[  863.088839] [    T169]  ? wq_worker_sleeping+0x65/0x280
[  863.089320] [    T169]  ? lock_acquire+0x11a/0x140
[  863.089716] [    T169]  schedule+0xe5/0x2e0
[  863.090107] [    T169]  ? _raw_spin_unlock_irq+0x28/0x50
[  863.090475] [    T169]  schedule_preempt_disabled+0x16/0x30
[  863.090998] [    T169]  rwsem_down_write_slowpath+0x4b4/0x1460
[  863.091593] [    T169]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  863.092182] [    T169]  ? percpu_counter_add_batch+0x80/0x220
[  863.092592] [    T169]  ? lock_acquire+0x11a/0x140
[  863.092928] [    T169]  down_write_nested+0x1c0/0x1f0
[  863.093339] [    T169]  ? __pfx_down_write_nested+0x10/0x10
[  863.093878] [    T169]  ? xfs_ilock+0x1e7/0x310 [xfs]
[  863.094891] [    T169]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
[  863.095987] [    T169]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
[  863.097206] [    T169]  ? lock_acquire+0x11a/0x140
[  863.097778] [    T169]  ? update_cfs_rq_load_avg+0x4b/0x660
[  863.098326] [    T169]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
[  863.099445] [    T169]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
[  863.100619] [    T169]  iomap_dio_complete+0x140/0xb20
[  863.101449] [    T169]  ? __pfx_aio_complete_rw+0x10/0x10
[  863.102004] [    T169]  iomap_dio_complete_work+0x58/0x90
[  863.102595] [    T169]  process_one_work+0x947/0x1760
[  863.103268] [    T169]  ? __pfx_process_one_work+0x10/0x10
[  863.103864] [    T169]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  863.104356] [    T169]  worker_thread+0x601/0xff0
[  863.104893] [    T169]  ? __pfx_worker_thread+0x10/0x10
[  863.105480] [    T169]  kthread+0x361/0x460
[  863.105995] [    T169]  ? __pfx_kthread+0x10/0x10
[  863.106607] [    T169]  ret_from_fork+0x560/0x860
[  863.107270] [    T169]  ? __pfx_ret_from_fork+0x10/0x10
[  863.107794] [    T169]  ? __switch_to+0x473/0xd50
[  863.108317] [    T169]  ? __pfx_kthread+0x10/0x10
[  863.108847] [    T169]  ret_from_fork_asm+0x1a/0x30
[  863.109354] [    T169]  </TASK>
[  863.109815] [    T169] INFO: task kworker/18:1:273 <writer> blocked on an rw-semaphore likely owned by task kworker/14:8:2880 <writer>
[  863.110690] [    T169] Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
[  863.111555] [    T169] INFO: lockdep is turned off.
