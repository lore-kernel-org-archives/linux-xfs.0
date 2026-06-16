Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD442A1B2;
	Tue, 16 Jun 2026 00:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781568087; cv=fail; b=qMvlatjZ/sQjVcbT4w7Xt+da4+dfCGKbIf13NV/6d4KgLUPbiOfQMDynAZXMj0OFXaQj1WliLtrhSIq5DaZH7H3xBQUMMXShuqUSUflTTH+iTBMFnZHmWx9GeW46ox15W0JN27TFYWshDnSWzEQ45aCV/IhETbbl1gr8VH8hgrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781568087; c=relaxed/simple;
	bh=2Bk2Fwqca5BnauFoFINWv+fxKZtUOYFiEA/SNYUYH4k=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pMs7jXuFNZMF4iWjAHQ9xCan1fyKCeyTzG6DqaRzYvPXnHZGvXuVzp5KrhwSOB1bmBpLNr78I0BAWp/4eNiQvfTPlakRXb2FlYfeY4NeY2i5M2/u/gmIfc4B8hQxZTP7XAMJkM2xzS7FOrVfwJyBXL6EmtdSb0L+0nTP7d/fKlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PxK0RzNy; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=TlQ6N6bE; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PxK0RzNy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TlQ6N6bE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781568087; x=1813104087;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=2Bk2Fwqca5BnauFoFINWv+fxKZtUOYFiEA/SNYUYH4k=;
  b=PxK0RzNy86IJCHOX1Nh7KEkye2nwkA1skpM3ZKr6c3QlmCHiy02/FvnL
   Xu2APlrXNsiDwVGPjfRvCxJNjZIFVsvVdE2oKqfdjCtnnSGygz5JRNLOn
   cJl9pl8kfyvHvwK8+CuqfmVWjMcRCpoUL37KtLXXFnR0GBZ4bTf7sjOEX
   JLh7028nhDyULy2xewDO3uZf3sJ4N5AHMQZIB0S7lZ3oTRHKmtoKRIK+f
   /o6IYp9CAfkx+wdYrdcMduvAO5uqDlXeeGoyUnt+HemUasaaGGKdMdMu3
   TVINrGkw8PE27+pLn6acKgmC6E6Vvc8SSRN+i1dqA2Afjw9LZSf0F+Hj2
   w==;
X-CSE-ConnectionGUID: VbY7xS4TQoSl4ptWUVBvtA==
X-CSE-MsgGUID: BT5DUWSCRgCfNm2+EqI7mA==
X-IronPort-AV: E=Sophos;i="6.24,207,1774281600"; 
   d="scan'208";a="145067984"
Received: from mail-westus2azon11012006.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.6])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jun 2026 08:01:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tvNKSA5HTcpvHz8uLzmfNGSwYYXz3Jax0mThI0Gpdj2EJVKBg/KMvyUBfNNFEoZw1aT9TGxmxu8iUNUSCEACGlxOqfCAynal+jJ3lxLJ95NWAtoJVWloccV/fonMt+fNhgyYnoKBa6hLj9/Ov/mrFIjc6Iu5puS8p+eoTbfqpXG8qRUEMEWsUoH6l/xhflHM6H575W3jDQzyFkZ7gsVEqC7wshNeCgjvQPo7nhUW3DK5m1poexcCcJrS0tO31NNtF2lzhZGyh6luW977czazebgAAdbpYXUKp2zsYUBtx9KBgkT0yFMoNvx2PLp9/elSayaVnvBkO76RomL2y39/MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1uKc3Qtd+exo/X0ZJttnwzy9g0THz4owXzFdHRHC0EM=;
 b=mCIZKaiY2ZgSNGNT+SQBpWbFwWmg4YJzQoppz6PUC0uEqRHD1aDeIPFsMccIZIRc0bwb9YvqmHSz+Fq3BrKTqS82E7LMz5sXU+L7DJHzNVaYapHMgulWlsXdT74Ml2+C+PoyFDZKF++k8PaBP/69WhPXpuCfQPf6GynmC8W3+834edOGKKoY3iMGHg/r6gS9KCqHOVSbkbu9fau5WmUkyM1hkh/oAeKRezX2eqzxbXrromjoUDJEj/btDy2/K28hyCVgQXqHYwyjowoXSJ3qoq1JL/WkFt83n2zWm0ne0DjciQwBWSPp1FS30xK6rB5eA5xAri2hlrTgvQ/lm0y8zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uKc3Qtd+exo/X0ZJttnwzy9g0THz4owXzFdHRHC0EM=;
 b=TlQ6N6bELxRRYMTZ/qNmS+qRKKi7bJG62pb5dacLUziTUpWM11qtspc017fAj0E2952V0dDyxbaUS1DgBAFvVhwguMrGNKDTfk66DcxUiEJZtV2UGoMmIJ0VgJlUNcjgYqzeMKqcfx46p2B3EURafOghibIBmh1zWi0Pxn54Ufs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by PH0PR04MB7755.namprd04.prod.outlook.com
 (2603:10b6:510:d7::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 00:01:23 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%6]) with mapi id 15.21.0113.014; Tue, 16 Jun 2026
 00:01:23 +0000
Date: Tue, 16 Jun 2026 09:01:17 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fstests@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, 
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs/013: fix ENOSPC handling
Message-ID: <ajCQCbIRcrtx9-ZL@shinmob>
References: <20260615121257.512060-1-shinichiro.kawasaki@wdc.com>
 <ajBeyp604Dou6FTh@zlang-mailbox>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajBeyp604Dou6FTh@zlang-mailbox>
X-ClientProxiedBy: TY4P286CA0099.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:380::12) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|PH0PR04MB7755:EE_
X-MS-Office365-Filtering-Correlation-Id: 80f2d58b-7a94-47ac-d870-08decb3a66c8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|366016|376014|23010399003|18002099003|22082099003|6133799003|11063799006|3023799007|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Zuhjaw9KJRmh92KyMY84nEaayl4NOI/bWc5rJ+ElXdTs7Go/TnSlD7S/OHGRkErksUXP8hsSLkghNbsNc3VO9iIKnD0aO78ih4YJXKkRa2mpehnU22U49O1CZqorLeXQj3nzXCYYYj8MTbB7BxfvkakJM6JmUBmDDrsv/vqv95oYVf2MgnA8lO1DuF8U3Y8wo5RKskMi0wBo4wZT9RkY4unhZd9k4DFHIQHOf9cELGuwu4M9se16i3Y1wJITiKISkSomS1I6Au9I7R4CRWkiyRvcI8WRDWiHtH2sDTlv5ExZCwmwlnSGgbuk10g97Jgw/DXOMOijFAqMhzSK5skPi+tlghMT/ftnkdN+LKVh6qWov6ltknvpXNfbLaA/yHliYrsnk0gh+g7oVCY0mZJu17wkzXAJe8Np9OsLVp7Or0yJfyYCXG5ShJmQyUJyl6YczGBOQAKOIaR6f4yulH6jdDPL8p6/YND1DNlBbR3JqLoGcpSrUvvlGHoUvC3/f3t7rsxu9Xtan1/IHQCeTWZMNcx3KJyE1y3YOVxggYOqGVcUWvu3RFx6FrtZh1iNadQtp3JwYICJ8djv2A1ed2hu8J/P7K0rYgTKipF6BI2ucAn6vawewooa3F4JFGjNRuQdwd0fmSlf6XjinDqexH9VfQnym/XbgsfAYNsIcwEcGubVGuqywvKr0LQatpgKhmlA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(6133799003)(11063799006)(3023799007)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cJxPVN6ggKDB51Yd7BtgTLWUhD28oFcQqCfGWPCZaSkF4/jC6xIVnVrqMsLI?=
 =?us-ascii?Q?0zwbor2ojLNkwnXl50EHoquNyE6J0p4AaoZBBZQIDUTwig5J5S8MFCHy7SeW?=
 =?us-ascii?Q?A8CT0fxL8oArr2rr2onXsowuypALaX4cKsr7AMHH17S94n01fhWQjxPbpEU8?=
 =?us-ascii?Q?4FAuIY4WgPw63Yiob2eH1MldXjoQhxgM3mix4L450Zzx2nxyzeQ+oS7vpyJA?=
 =?us-ascii?Q?/Hx/jucoUnOIQZJBDDaesgIYR+IrjetacUjfIdsGgMLH783p+nUKHm77y8HB?=
 =?us-ascii?Q?8009DQJWxa4i8IuJX/61Q34yjTnCFQbqJvMvRRuKfW+K/CFJtFKHIYXEJ0yj?=
 =?us-ascii?Q?DHy45I1QpaHDQ84LvLuPV7kZfNjSg/KqITBr2KmWIrfUYVXW/9584GS71L9S?=
 =?us-ascii?Q?0UpmVvyVoMTCBBLONrf6tJdME/ynRVYHcQ3dyUdKuHd0YCM2amFuJjB/PPPr?=
 =?us-ascii?Q?cfAI08zRYN7W9Im1FjoanMcheizWOlzxWwIsWUgXShs70mQoi10FiQfxLSHg?=
 =?us-ascii?Q?9oad8Yi4elcI/+RG10tiA7PRRiWqV64osT4e+Z3Y3KFntOYpL7zrr6Afecz8?=
 =?us-ascii?Q?SeE72x6LxZdnif4b1+1Fx5bmKLDsE+XJwRVRK+1Kz9LZoFhjLHACzPyAkEvS?=
 =?us-ascii?Q?5LhcNKxyZC70RN4935/D9Mcoukz7OWUVDu87j48nUDYJf3xXHSvONMCtKzpR?=
 =?us-ascii?Q?aXVi8rOFRiS0rjsxNj5YQ6F6PneR9JQEQFJYtNvJer+UYiYZsv2vrdydPMDw?=
 =?us-ascii?Q?pQ0EXK+rOJ3ZdSDwP6xWUvgbCAHq6ov2TfVQLTrWbg681jB1ENYlxsC67E3h?=
 =?us-ascii?Q?xZPNMsfze61X9d35poJh/Ajo1BlhdO09X80a1PwEKrE4OKuRX329lZinnpWE?=
 =?us-ascii?Q?Wul78MyuZ+HnOAFfIoZ4KncPxOJ4KLnCRGW+H30Bc1pfJKQIT4MzjBx3bsce?=
 =?us-ascii?Q?+PZwRj+RrdMcMIJtGCLhT6Of2YjAzCZn/hdSJwSLmVJRk2LQNIPVtBTaNpmQ?=
 =?us-ascii?Q?KP2WrAHqCIuHM9KFsqcE/mjGf+0+acFT3Fjm1bFj0J1EtQHUlYgUOqwo52fS?=
 =?us-ascii?Q?59TBKDu6/msJYmT70WLxnshBHuPtpxRCFjxu2mIcI5K9q9hWKUrmCyCJh1Gj?=
 =?us-ascii?Q?Vc4Px1vTwZgyLclljF0/65kvwX3uJBFXGcmSxG+mT93SJDMfpL4o1hKlIEe2?=
 =?us-ascii?Q?M6tfrtldk8svETWq5TMkq89p+hIBL6qpiWe43J00kREDfNiscccFMNmP7Bgz?=
 =?us-ascii?Q?FyQ2L5T/aQcRTKOKvyo6CKQ7fqi6iFXp+RCFPbXoBIXbDkSjQ4v2g5v/VCRe?=
 =?us-ascii?Q?juQIWZhX2zoA2tEto+mvjVQopbu+9SSsgB0uzN3pzi+CUPS0r6G4bFcPkct7?=
 =?us-ascii?Q?bwJM5iCBhKQ3pOvDPpUCpL8f/T8wG9o40893yxzY3VYFVMqCHMDnnW2V24tD?=
 =?us-ascii?Q?2M1yeYD5v5bAElWgsMdUqOHiCZdU4e7wu01NvSF6mXp9qt7n/L+P+EeUGJUg?=
 =?us-ascii?Q?1SRA8S+dm3gwDp8Cm9cex7kUkHHWEXPZWWmk9+SqghXXa6G18O0RUNmQczpP?=
 =?us-ascii?Q?pSlx1rqgCC08nc/iocXsyR5PgnZS4mVCJN1J7bI/ZQb4gPFnOxVkXoZ9usEF?=
 =?us-ascii?Q?nXjWWxZLartJ0d8FmHlE3oPrWVo0NwclopelENODu+cZHT1QiqfXPOBGA6Bn?=
 =?us-ascii?Q?LNI58bvHblp0U1yV+t0hrXhCkII4+V8FKm+wk/PUmzz11kogyAlotV0Kku3n?=
 =?us-ascii?Q?TY99czyUciYOd5AQSJkhP+0sCuYHjzg=3D?=
X-Exchange-RoutingPolicyChecked:
	CYG3Bexo4F3hpww80XluFsbcSocluFG4NOWc4ScZa/puvMw3qFTdj1PFm8C4l1M+OIGBm8xc4ehsmYZZZeOoTtEoohwN8Xiqnhv9qd4UxH6kYS8hga/67OvYgi9dK4PSn2AteC1yHzWZ4UTzMafZYqDlBR2VGjZwEYWrssL3l4vwr13P5f3Xv5p/vQKnVlo0LFnkroOTyLdp+zSdPZqMIUX5vw+RdV5TIa34afML3ad+ljZpHDlLquhQhYUxkf43A4Mn10rEDZj4HbJvvEdqOnlbdnUghAf2F3xRDinMUq9WryXKpS74Hsp11rnxXCu+3AVhbtTxl9V338SP4wyMcA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZepQl/WCwCvmkVC4FHW131al4fYqBGl7gaFnFdZjuTf21aJ5CkGJsk+cUdv5IhJGv1uf6V7uUFoQASzGF3rUIx7IIG8JT5uEQqueI5k1Nf9DDoIxnVIKifkb8IKVd8QHVpYjyDX+6Sj+0IBL0w0oJxWsaY6wwlXFkq2NC67QiOrGpmWeBljiPs4H90sYWsvtV0mY976bldE8amNx3zgd2HzzyNm2H8B5dt75GoNZb/gyzMHuU1CAtFDkFZW+Qt6SLsgFmbjOEEhowmV7XgVPXHFt4B95vIJLTHps2lGMf+dK/YVUjGO6sWMRIRqwcoj6G3MyZuFu8tSGYYIdXxRhb4j8hPO1kFm3yd6zvurO3mGdH4rRjMkVIiRI8t6lLcA8nEbc8xV66oI8xQGLTQIX4GVpTqoW1rHcuXBSa5QcbWv0KTckbH8IgI97vNE+m2PO46EFKR9Fm4oxd02/b1bRn2nZPpA+TTU89RGL8nOryz4uaEF8YwIFNkbI9qVsE1aRyk3BfIRVdIx5J5qii/RFHovc2RWpajwPFyQZjrCdswIQAf+49M6qQBvRSZ+VD/sW8vRKyo6F6fWSOBFMu2Z6jPK2H17k6INJN5QPnbo2Nq+ntlPHlbnf9zds/FnW9IjM
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f2d58b-7a94-47ac-d870-08decb3a66c8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 00:01:22.9620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I12H7erfq5KbsqAnPrbsN8GG7rsUK/ZFLfM9S2Yp3uj6PsyHQZdTQ+GmSvpsrTTGsTo5tPixrN8XHtO0Z2E6eiHl7l2IGlSaydFwd6jmYU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7755

On Jun 16, 2026 / 04:23, Zorro Lang wrote:
> On Mon, Jun 15, 2026 at 09:12:57PM +0900, Shin'ichiro Kawasaki wrote:
> > Commit 000813899afb ("fstests: scale some tests for high CPU count
> > sanity") replaced "touch" with "echo -n >" to speed up file creation by
> > using a shell builtin redirection instead of forking and execing an
> > external binary. However, this broke the ENOSPC filtering the test
> > relies on.
> > 
> > When the scratch filesystem fills up, the shell redirection "> $dir/$i"
> > fails instead of the "touch" command. The shell applies redirections
> > left-to-right, so "> $dir/$i" is attempted before "2>&1". Because
> > opening the file fails immediately with ENOSPC, the command never runs
> > and the shell writes the error message "No space left on device" to the
> > stderr instead of the pipe. Then the error message is not passed to
> > "filter_enospc" and leaks into the test output, causing the test case
> > failure. The failure is recreated by running the test case with rather
> > small size of block devices, such as 128MiB null_blk:
> > 
> > xfs/013            - output mismatch (see /home/test/xfstests/results//xfs/013.out.bad)
> >     --- tests/xfs/013.out	2026-05-28 16:52:16.881159200 +0900
> >     +++ /home/test/xfstests/results//xfs/013.out.bad	2026-06-11 17:20:36.269003467 +0900
> >     @@ -5,3 +5,12305 @@
> >      naming   =VERN bsize=XXX
> >      log      =LDEV bsize=XXX blocks=XXX
> >      realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> >     +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/19013: No space left on device
> >     +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/6452: No space left on device
> >     +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/14964: No space left on device
> >     +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/10051: No space left on device
> >     ...
> >     (Run 'diff -u /home/test/xfstests/tests/xfs/013.out /home/test/xfstests/results//xfs/013.out.bad'  to see the entire diff)
> > 
> > To fix the ENOSPC handling, wrap the redirection in a brace group so
> > that "2>&1" is applied to the group before the inner redirection is
> > attempted. The redirection failure is then written to the group's
> > stderr, which is piped into "filter_enospc". This keeps the faster
> > builtin file creation than the "touch" command as the trigger commit
> > intended.
> > 
> > Fixes: 000813899afb ("fstests: scale some tests for high CPU count sanity")
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  tests/xfs/013 | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tests/xfs/013 b/tests/xfs/013
> > index fd011445..2e9b9850 100755
> > --- a/tests/xfs/013
> > +++ b/tests/xfs/013
> > @@ -28,7 +28,7 @@ _create()
> >  	mkdir -p $dir
> >  	for i in $(seq 0 $count)
> >  	do
> > -		echo -n > $dir/$i 2>&1 | filter_enospc
> > +		{ echo -n > $dir/$i ; } 2>&1 | filter_enospc
> >  	done
> >  }
> >  
> > @@ -42,7 +42,7 @@ _rand_replace()
> >  	do
> >  		file=$((RANDOM % count))
> >  		rm -f $dir/$file
> > -		echo -n > $dir/$file 2>&1 | filter_enospc
> > +		{ echo -n > $dir/$file ; } 2>&1 | filter_enospc
> 
> Although I always use `(echo -n > $dir/$file) 2>&1` to deal with this kind of
> problem, this *Command Grouping* way is good to me too :)

Usually, I don't care much about the choice between parentheses or curly braces
for command grouping, but I chose curly braces here to avoid the cost of
creating sub-shells. It should be less overhead than parentheses that create
sub-shells. I guess the trigger commit wanted to reduce the overhead of the
process fork by "touch" commands, then I think curly braces are more consistent
here to keep the overhead smaller.

> 
> Reviewed-by: Zorro Lang <zlang@kernel.org>

Thanks!
