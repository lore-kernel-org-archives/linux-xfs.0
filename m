Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBBA43DED2
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 06:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789627937; cv=fail; b=qsIRjZkd59cF+hhpCF6wnU8EMsLN6PosUwCbbGbglpUDOS0VyI5/V1Jad96pRacP2/+aQYwOUCx1etTpEUehPldOPg930XjTW5QrXJ74N0hp5sLZk0ozyR+WLkU/6cY0CQ5BqU2lkQp3vLMHRS3+1AEtpbcNYXsMEFqpuX/aKUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789627937; c=relaxed/simple;
	bh=9vKpfvU8ilfKS84eDWhw54T702El0xd789cne/ZHSlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hBN+9WXFqOZCPThaN+g9NlfxUXKADXRWFfput0iO3KIVnvSa53pKWgTSQ1f/ZNVtHJkXRMncAGeLe37LKQaoLoqZPCoDpD5I0p2Z95WIf5RFLP74l0+LpgFdyuzzKiKW3IIcWiCqAAyY0IDinbg67WwlRXLwlXA4N2jchK3i1Po=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dU6ATlXB; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RCYiQJQO; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dU6ATlXB";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RCYiQJQO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789627935; x=1821163935;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9vKpfvU8ilfKS84eDWhw54T702El0xd789cne/ZHSlA=;
  b=dU6ATlXBcKnFBueLJfvLLn+PNgYgwc8/ChnpzRahJsJLWX/rVWfA3zit
   xkUdhEbDxesHZW+HQId1jGg6JuMVvlN6+SvW3py5YviUC0h5FEUnL2WuB
   nJi6y3m96Ee6kcOsk/xbami8JnPvrTS/HElhvR/rKSWU6CZ6Pn7fgy6dQ
   Sk4y8L9YO7L0h3HwjrYU7aLr4l4PDGLNWvQtb42gkYTGzk9rD5tk+/Z0w
   qyWTy5/LxduP3nCF9SAY5Pm5GE4s1pHZ/d2dpy1vHGtj88WXJ5kjHmyHL
   34G//qI72oks0/IXmee3wtMtLlGe09qELNgMz9abjnjGFrgX49MATyXQp
   A==;
X-CSE-ConnectionGUID: wCM2PZLlRnWrNPdmpOZNEQ==
X-CSE-MsgGUID: GdHqAvqcQyuEOBA22GqJLg==
X-IronPort-AV: E=Sophos;i="6.27,103,1786982400"; 
   d="scan'208";a="151668506"
Received: from mail-westus3azon11010043.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.43])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Sep 2026 14:52:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lCrx12YstdEgcEtmZsxqwBmuQS6/bzxoBXKa9LJlC6B8HhW4ONpONGbjWYf1QKZSNFhMOhhEJpPF3Vt+9mGR5Ax+vggPwKKVbCP3QVAu/bEu1PHBQcDEPEssxSpnImulqYyd6+dcRql5Zqkanf0xNhUPAUZP/IoAbDdc/HpjunDLGSfaQV+w++orWlOLKVyJpO9yyn73qcTFpHz8yl2MeezhwmyB+ODjmcWm86l2YkC4fL1gq5foAQWtr09xuQpO6DNuvYj5DpCpR9+1NfRWtfwCDn+dXyChSadXPE73mGxeuqhy+WRmGQtmbvXyxuz4/QXS3FJUnDUWSeg0t8+fpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlTS7MC4V/cYCYbCTkFNQwWSLchtcTYZ0vMS4AAZiME=;
 b=h/inS1dHior2HYRow6lv1pkA5lP1i/LuEMgwiy+/bIkdiPZcDcU6ndmuwuMJogUXj13bCiHQQc3Db9+cgHT2/l5Gn7Dzvf+sPNv4hyjNk+p6iCBniDwuz++N35q1Q+xA/QbACS8dESLBpz7BGRX6dMW0/+HssKtGHgLmOlg+XjLb/Bv4EgSByheK+kQJHj22y6psa6RiVkdAyfPbeFq9gNiotau/8Uc/MEizFt4lw8ktYjpqsZd4i0caKz6sgfC6lq0ysJji/BgMUuA+120CdYjsecQiogLSgCmNEv5Ah1H6i2pHwZTwvdeZdzlVAEttxG6jdCc+I7zIp3vxdk+2XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlTS7MC4V/cYCYbCTkFNQwWSLchtcTYZ0vMS4AAZiME=;
 b=RCYiQJQOWf47fmzrD+e6R/ff5V7fEzaQYCO+hfqor4BJh3I3FSXKmsG6m/1oSxdjRex3RPYxbf9CVVjmUJVq0pV0sezkN2hilLJEPdq5+B52cqMTMA1JAXKEGADLT0wRMstrsnX0PB8ro7Qnqk084aoHmgUin6eRfo6O/0U9CNQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from DS3PR04MB10053.namprd04.prod.outlook.com (2603:10b6:8:38f::5)
 by MN2PR04MB6381.namprd04.prod.outlook.com (2603:10b6:208:1a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 06:52:07 +0000
Received: from DS3PR04MB10053.namprd04.prod.outlook.com
 ([fe80::faeb:7524:f842:9f3a]) by DS3PR04MB10053.namprd04.prod.outlook.com
 ([fe80::faeb:7524:f842:9f3a%4]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 06:52:07 +0000
Date: Thu, 17 Sep 2026 15:52:01 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Dave Chinner <dgc@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, John Garry <john.garry@linux.dev>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <aquJIL3Ztk3KBdHV@shinmob>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <aqsN4GOXthkF8rOI@dread>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqsN4GOXthkF8rOI@dread>
X-ClientProxiedBy: TY4P286CA0085.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:369::7) To DS3PR04MB10053.namprd04.prod.outlook.com
 (2603:10b6:8:38f::5)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR04MB10053:EE_|MN2PR04MB6381:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e4cc4e4-2b23-438e-4114-08df148830b2
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|366016|1800799024|6133799003|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RfdSddKzj1g0mYi2VVBF3HW4osd+YrMym8Dh+QfzVO/LCDs2JYMp9cRbVNHo5YV+gOByystBkDsN/dv6RIqxaYCuizis8B/zKpABvhnmirkQpTs7AlR710bGd3BfBtj7quwJQ3UIPe3IDhzHF+11CAe6ipsdcEKsak21yG3QdRVqI95fAJ8uAefXWVe75Z3u6/4hA+nuxRHcBR/RJyB/FYq7sJMhvkiRV3PVyf29gAIyWDMtRyemqwvWVJY4xyH1CNgz5QHwiw0DfGD7aR65uJ0yH2Gre+0VqKxK7ztTdofVGK8U6NmX8JiN6NW5CZhh28QL0Qw/ppMNSdfrq2kW30+ELgslOwMCXLOhqCdhOyx884rL4iZ1aMQl22HD3nwF51IwKgj6OompcKWPCkZmnTJaOEnCSOJvE+kvG/HewSTIa2f+uWuU+FjSmc6TaHGZzPb/UXrG8WO/QDfgOOTnJZ9OIem4Z03mqDRpyoGrOBhYzeDXehLWNI5bQcxlOgtvReJULJiAvJbdopS6K7aJgQXnKXtep4E4bcZY2SxPCYgrlGgzLPnUSppvAHP0BdDu99QktbtfypqsIN7+K8q6Ce4O5h0oMlWAXh5catamYjYvSDEAJJEgTkJalzgLsp0HaiMKqcizNWSONQxY8yJOAGAE/ARo/u5iV3iIKvl+wMo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR04MB10053.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(366016)(1800799024)(6133799003)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sn0lJADC3VVPK3cclUGDBa892b6AMnlcm2Jx+6w9dbIhjot3lTW3xFJZXTiw?=
 =?us-ascii?Q?BmXmNMI4ag7HvUo8/XsLlsa+C0TamRWpnQdu+jJ6b/47bxi7SliBArJ8JTZG?=
 =?us-ascii?Q?a8sFoVLd3l8DLGUJDGuci9keGVd+BexL/QT9HQuClEVfmbv0zBYkmHJbLtCb?=
 =?us-ascii?Q?N9xJyudyqZBjPAD1N9vR2tqrIGcaRWVA5qmj4wIOBwgY0RwC2v81/MkuY7u3?=
 =?us-ascii?Q?g9rc+IGeuNE+DTYG6uehFi6bM+56SsqeWQDDKk1+FRAfiKsEJ/KNqrxIkq6r?=
 =?us-ascii?Q?TuMrqtf1uHPVTmMBpjRrezOiEG0XtsnfrSg6TGbhCzHXZJDcymf3alS/z+RA?=
 =?us-ascii?Q?r0MdatsC4Fo4UMpXJ+rTAX4ILdGLlvDS6NGUyJ9Tb0KweY/J6YuqEJSGDWdQ?=
 =?us-ascii?Q?h/g0Sbq0ZxQUJiNkVpwOje/MNLsB8G+PQbIQT9SAKELTZmnAqMb66ym6Y/7v?=
 =?us-ascii?Q?lIm8oHlxB/UrusWp0NICKtHykdE2JwVwYQDgVoUVEFJ5MalSLTQyVAXSKvqh?=
 =?us-ascii?Q?QO8xNGQlDcfiJPgUrLsvzm+WmQhrljhCdTSAE2E9LVpMviB86Oqh86GWgxRu?=
 =?us-ascii?Q?A8bc+yTUkw6S5IrMI54Or4ZubKiUVcYusJREupupBUCfRNeMO7F78RLhNmjL?=
 =?us-ascii?Q?IADmH9GIYuzSRD/eijkzZXN+asaN/FErkX1fbm5A1a3Nqx+8w0l6ZWLVFSbh?=
 =?us-ascii?Q?PWRCw+5TUVouodOINzMCCVoEDxCrtM77flN9E1JDj+e2Jj0CuUoGHBPY/lU2?=
 =?us-ascii?Q?XCuMxM6C/66adUSA3+qLCnpG9BrR+dnesFUPu+wNPCWeizRswydP/st0ZDqT?=
 =?us-ascii?Q?ijOqLMxfXaPX0xCrJmrZ/Y75Cu1elzkJH3FF4tU/bPdOUr+Er3zCX1JKwa9h?=
 =?us-ascii?Q?n5YxwLzEvm0BaYv/Zt13Uhx52MUZ//ad7yX8NRZV9Tq6RKu0loIc/pJAhrQ9?=
 =?us-ascii?Q?eRCVAVyaRaXz5T5PJCgyEEjL5Ob+kUpBQ4+V8dIGMUS3cqM9mDPOhLoM/x9i?=
 =?us-ascii?Q?EaZqJeK38FA9rBpRjysNQNaKuWjrYsrZ5KnxmJtfQaPawk+F+7MaPnWM3v+s?=
 =?us-ascii?Q?ATb/nGj/Sp1MjNWl/jsvSfhiZw2IPaD0m9MO3m5FkY2ULlDMsUOpbSOc7lyP?=
 =?us-ascii?Q?iqSI4N7wad1cTyZXSbYY+H6CDiDZ7OXBkCNicxkSSbeARLC1CAdDSrOlenVf?=
 =?us-ascii?Q?75lIYiiDzSDIUUplOGpHUkZWOqRFscPyYO56BCfRbOE326X4lgx9Gzn9FdXR?=
 =?us-ascii?Q?mdA4nMglXmXLYAUAELATJjneBnbMRUVpbVmMpg5VHAHDLuTKev1cGuxhpCXO?=
 =?us-ascii?Q?CNmnN8mwWoUbj5UY4n3V99K3CILnnsrtIcpVhZ8Fw8C+aRdTH/S4+hKGXTO2?=
 =?us-ascii?Q?yhSmKAWETjOy7XqyowbE0IHgRjPW5/uwtNluXDvll+M3drWeiVBO9PRCLgz3?=
 =?us-ascii?Q?lXjfoTUhkMyilyxfKWYoPvEeeo8O28En+9dSdRmxt7/kAhuuuSjw8mOScXSC?=
 =?us-ascii?Q?VETPaRcKBLdnXmaSJMdqMdSCC4lDTi2VWV5/G9kL9CMO+n4nVsqpZwmivSYs?=
 =?us-ascii?Q?SLz3bfYj41V1Qmy79CNCENN23YNvqx41oile0GGTuHW3RGfY1qxFHqNO5pbQ?=
 =?us-ascii?Q?dcS9G9edKYby7Ttebb2yCu3UD8fGPIbmIMoP0FjtvYVUbY9qW5ZS79TV47Mm?=
 =?us-ascii?Q?ZB8pHT6rGfOUQDPgTK18E0IJ3nP6suvjd9DpVg4292XjHun3Qm2h6QbVfSjW?=
 =?us-ascii?Q?9F/4SnLA9ppe152U/mFYEKTQAsk70HQ=3D?=
X-Exchange-RoutingPolicyChecked:
	1dP0uPtPN0FKtosOfQ/W2Em+U81j3FSWdGPWk3uLvcbyM5IMs1w4tfjHmYVwx9+kn0ROaomEKkzcBlK/b+lakn7KHPq5hg5nL5o9+C3IXdtFPh4JWcQ3w5zYkNls/YwpdZepbRqX/ltiQv1WlDSA5vkYe+XwvnB0Vf6bKQkXrEzATR28jCEvaZLbhGjComHOhZZaorNOzyHXPHcPEtbRQfaNfjtlq0j9DDx8fKT3Vw7AtIVgiZ6nFR/9Tg8D2hLFOncT09b0Y91G59Il0g5IM6nbhVKJIyLbplWGGTd29cUVpCpFzo06ap3nr0rti5Ewa82y03yRB/T0KJTroR7SBA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A4wLLjsoJKVc3EWp+1KKjKIAfcNfCBhr1Vn0eo9GnHUbWdltw3ikkD7qQi4AoBnYmdZ90EafKza91365WnK/ORbElPNXy1NogFQJoeRVkfvmp7jOzB4Kj0JM3Xf2YlmNlcRxtdeGcLhC8azvIJZmIcZloxEKPCpOPDgoQABebNtBJ6n/8KldlCehESydQnJqO+FtVB7JfIe4z33it48Tumgee/PAOH80zYaC1DArZbyTzTsUBVOYyE9t+9/1Jx69flfMYTbNHk7WGCpS5+NL2Nz3yPIGvgooitZpW4cDGOak6HZkaG8i8xuSDCqodtXvwgMMLFoNJYSw9GEYHlSelL+p6FXwZNvRZTgUTS1igkP8QRY0gnM91BXP34cRsGMZK/kbuGEmQJmavZGCIO0NvxKRQCQfjt4mbj2ICH8Ceyh/E0Iduqgxv8NgLaFpScW5Jcty1LG42ZAhk11dfoEWOPEJviaVwfsiTQR4C38KgauwjyXEbg8H75YIVBinavl97MJNIxDN34QYUbPyhe/RUOylbcfFL2MyWBt1X9KqG3idfSdFweqpqxfM5J5aylZ4PDQYV2BCS/BJ73D4awB/mcI/U5zhn1jEmQd9XLX0pqEWBU6T+1Yp9u7gF/71US2h
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4cc4e4-2b23-438e-4114-08df148830b2
X-MS-Exchange-CrossTenant-AuthSource: DS3PR04MB10053.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 06:52:07.7189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eCRJ1vJQGw5TH5Lm4HO29lWlcuByoy+GkAUitzVmX6iTpTHbC7/VZ13+ZQ9YycBvKWUdhklxHAu/1kuNy5odVeKRcaOeCSaU+PMAO89x75Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6381

On Sep 17, 2026 / 07:45, Dave Chinner wrote:
[...]
> 
> IOWs, smells of the journal being run out of reservation space, and
> no new space being able to be freed because all the dirty inodes
> in the journal that need to be written back to free up space are
> locked waiting for journal space to come free....
> 
> How big is the journal in the filesystem being tested? If you
> increase the size of the journal, does it go away? Can you get a
> dump of the transaction reservation sizes for the filesystem in
> question (the xfs_db logres command can do this, IIRC) and then run
> the math on the reservations held from the dump of all the blocked
> tasks holding locks to see if this matches the size of the journal
> in the fs?

Dave, thanks for the comments. I recreated the hang, and gathered relevant
numbers [3]. Here, /dev/sdh is the SCRATCH_DEV. My interpretations are
as follows (If I misunderstand anything correction will be appreciated):

 - The log section size is 4096 * 16384 = 64MiB.
 - The type 26 logres has 327552 size and logcount 5, then each blocking task
   consumes about 1.6MiB
 - My test node has 24 nproc, and the test case creases 2 * nproc * LOAD_FACTOR
   threads. LOAD_FACTOR is 1, then it creates 48 fio threads.

Assuming all fio threads are blocked, and each thread consumes 16MiB in the
log section, 1.6MiB * 48 = 76.8Mib will be consumed. This is beyond the log
section size 64MiB. The sysfs attributes reserve_grant_head_bytes has the
number close to 64MiB, and I guess it implies the log section is almost full.
Based on these, Dave's guess look correct.

As suggested, now I'm trying to increase the journal/log section size.
I added the mkfs options below:

  MKFS_OPTIONS="-l size=128m"

With this, I repeated the test case 30 times, and did not observe the hang.
It looks like the log section size increase avoids the hang. I will keep it on
running to see if the hang is observed after 100 times run.



[3]

$ sudo xfs_info /dev/sdh
meta-data=/dev/sdh               isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0
$ sudo xfs_db -c logres -r /dev/sdh
type 0 logres 193528 logcount 5 flags 0x4
type 1 logres 327552 logcount 5 flags 0x4
type 2 logres 428160 logcount 5 flags 0x4
type 3 logres 247204 logcount 5 flags 0x4
type 4 logres 230820 logcount 5 flags 0x4
type 5 logres 312612 logcount 6 flags 0x4
type 6 logres 311460 logcount 5 flags 0x4
type 7 logres 285696 logcount 2 flags 0x4
type 8 logres 311460 logcount 6 flags 0x4
type 9 logres 303992 logcount 2 flags 0x4
type 10 logres 2168 logcount 0 flags 0x0
type 11 logres 82176 logcount 2 flags 0x4
type 12 logres 116856 logcount 2 flags 0x4
type 13 logres 760 logcount 0 flags 0x0
type 14 logres 326784 logcount 1 flags 0x4
type 15 logres 23288 logcount 3 flags 0x4
type 16 logres 21760 logcount 0 flags 0x0
type 17 logres 164480 logcount 3 flags 0x4
type 18 logres 640 logcount 0 flags 0x0
type 19 logres 111864 logcount 2 flags 0x4
type 20 logres 4224 logcount 0 flags 0x0
type 21 logres 6512 logcount 0 flags 0x0
type 22 logres 232 logcount 1 flags 0x0
type 23 logres 197751 logcount 5 flags 0x4
type 24 logres 640 logcount 1 flags 0x0
type 25 logres 760 logcount 0 flags 0x0
type 26 logres 327552 logcount 5 flags 0x4
minlogsize logres 428160 logcount 5
$ grep . /sys/fs/xfs/sdh/log/*
/sys/fs/xfs/sdh/log/log_head_lsn:1:103190
/sys/fs/xfs/sdh/log/log_tail_lsn:1:101012
/sys/fs/xfs/sdh/log/reserve_grant_head_bytes:66053588
/sys/fs/xfs/sdh/log/write_grant_head_bytes:65718696
