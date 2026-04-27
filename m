Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D61F35E93C;
	Mon, 27 Apr 2026 06:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777270620; cv=fail; b=fyXmsdVoKQLhbx/y8ggY26Wvadt9PRP2VRmb3EVnImKNU7i72aTqnqzMeZzFzhFaSZjcbNcErMiNE9PwsQy6fbshVrNK4bLzNpkUBVIXA+jaiga96fx/iJsqjAetwfihU+gbxQa8/UmzUS45nyhgk7EUbgqhKQ7GQTXkblE9vCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777270620; c=relaxed/simple;
	bh=xlhg08dUGOEdY0JboGT5UR5ZKHiu9xUA0W6NIh2YgEk=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=MlexKN3RVG0GiH4DJmvw3vHScYqokMKTQobhBCTiXbOwhUGOSpAZK4H6rcpNnEQJkGjHGbTQPOtX8V624zVQiimgMH/DZrK1DTIpck68MIWEC0YYMwrVZpg2yxDEXU2QNsa3OFF78InHHudVpp3OGfoUa0NVAmNVT9vm0u0ZrO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eB6+94BX; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ePQd2szq; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eB6+94BX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ePQd2szq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1777270617; x=1808806617;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=xlhg08dUGOEdY0JboGT5UR5ZKHiu9xUA0W6NIh2YgEk=;
  b=eB6+94BX9WUUVkkikgMKAPneQ5FotBfsG94CddjT6DbVoA5Ti+ggy49T
   TpBr/Od4zmguETwsRUnXqjKLsQdUqxXQpSUpGIgc+hLcUHOsObT0bjcLd
   mQgtbU2GVlErxlJquswvdePb87SiiHtj3XNVj18T0dG6t9/zPCFI1pKSG
   6rvTxHhq6vBOmKL6YgiFlFgchB+8K0EJRZBY5Tlp6hpbBsanRvF8fwIOY
   My8x1+Bv/T1RN+C1TAds0O8OCyRt1gv+7KJF13Cg8/DBcZY2tvuETGlXL
   Nk+Ht8hSd5nFauA+BDLXz6F9ebCLZaG45VVU7qCmssiQidx/KIc13RLXV
   Q==;
X-CSE-ConnectionGUID: zlH62HXvQe6Qur16kHlsqg==
X-CSE-MsgGUID: Nn/GgVp0SqWa9TXe8nIZlQ==
X-IronPort-AV: E=Sophos;i="6.23,201,1770566400"; 
   d="scan'208";a="145755694"
Received: from mail-westusazon11010004.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.4])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Apr 2026 14:16:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FUXk8viUkn5Ns6YaM2MZFMCG9OnJprOLBDlHm8SL1PCYCaUgq6F2InuJjUCcGLJB/IXfQdx/+n5aevO531iP5yPhGWcyuwnWbk8fLxtigYXPu8HorhN/iSq+8QAfrxNZ+UO2LTPXCaVnOjJ6XkLyjjlt/bOyW0mci6NZq95B7n8/CVeZtBKf9pv6zxk0t0eQClk+T/gbnfASM4KjmMnG5qzgxXyNAKHuMb1HHYx1Xjy4lGpbep3GS4qnDczPhw9JnuWtIlfBbacXnvEfEK7IXs5SrYaccHscyD7rmw5ELKjR04KU98FCIyLamxNCTcgxI0VByYYDDsVMbNZm2VOqeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXosSPu5i5X21/sY83GFhaOQcINLMdZ9hUBHTxO3Zo0=;
 b=aJdG2gVELLawcAy7iwILhgNVIadlYrWDRuRDYShtxGrBJMTKduBrxiJLTz8vxWIn55ejYFcwEUx9YULpg4R/TrSn5r3eicyVb1YuytJw+of0dAUSqdSuHNx/bcB+aZryCrqE0DeZHriGj+6yRRg9tYnHmS9xysJrPGBfGiWuuUkMed4E11WIKN767GdQa5pBSAyZ/4QL8FIR+426q/Jlu96ziV2do5cQuxRltl8Fl+GcJDDLS+DFK0qUTbPhWBSuVH+xMBHzf8yGfGSVcStZEcMyyOGSnaTIGexP3hTHF6VdtkJZK0ubY/6JLXW/Xd6kAiqWIqqLBChIqPP1FBpD+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXosSPu5i5X21/sY83GFhaOQcINLMdZ9hUBHTxO3Zo0=;
 b=ePQd2szqyNtWvB9D6lVoeV8v4etLRnmzso+EhAFDFaqtwzzdsgvDejwJIqfjJE9iKQJdBggLLqa0o3IdvF2/P7A6vcEQ9+6uyG5xvQBdWPGf4JRgGxC2WsTbDDKTivkfak0z6CTCXl6FfCijo6UiazZKR2zrJsZNVSfns2+OyPs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by BY5PR04MB7121.namprd04.prod.outlook.com (2603:10b6:a03:223::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 06:16:50 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 06:16:50 +0000
Date: Mon, 27 Apr 2026 15:16:44 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org
Cc: hch@lst.de
Subject: [bug report] xfs/806 sporadic failure
Message-ID: <ae7-c9s0KVBRsSy3@shinmob>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: TYCP301CA0059.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:384::19) To SN7PR04MB8532.namprd04.prod.outlook.com
 (2603:10b6:806:350::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR04MB8532:EE_|BY5PR04MB7121:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ca2c48f-e64b-459f-bad5-08dea424916d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CDFzDSSoySo/pN7FKiP7tChTx5v4i4hoaIPlHtrx8mTu6tzx2dz9Y/xzTsry/fdtNe/XrwT95kBtor7+S/3fcw+cyy5dDZCyc2SNe7o0kfbiIGQMYH3Bt0rntiBpfgso4b78AI8hp09o/Th8LhXcOJBSH07hMZEmxVTjsXweNiZ8leV0DUcvWih372vgXW34eXNWIrLfc4SnEeInhlh47BAOlWm96tKHaGebxGPhlst46SxSeOJIh//HJ43CahkyDVsnh0/tEfSkIpYCR5fiq4/33yyJgOHQnDZMOTKRM2CZJGgW8r0bP8wH1synyzdwqzeQBwtDb1HI7NtB7t4+tn68p4Ztk6k827RuKuY8YIKlabDhIOJuZxJv6jM75D5Y9Y8+X46z+g0RGz2QJDTNV7gYe8mhMK0OaUuDXmkbJp5ixaH6UADIEI2e8QnGHB/fhOLi6jL91k5tn8PtB9zuisDyFh1stiY1RLWTQzod0aVthfDreQk79Nfv7k1BCttQdMN+eDYWM/MmaAJmpf3Bnujmv+ERsAcKcfhKybedCQdEq8OeiJ9fkXtxCxcSHJDGE89lPvs8t6VZK+Xhjd2Wi8F1JjxHtnaJoCFxyhCAli3zyUiiBRGJK+v7lWttOEWRjdJpxwCwefX5f3BrI5nr3Y67Hzvm9UAdRh3qWsW8sHJpFzDZAI9/DLnP9LW+OcjNsdsALykl1YrZEcEGWI8LExVlb40wyfcrUDWG4VeWtgI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7IapC468x8x8YsE+zTh47M/dLA/ZOplqWSYC5/cEhl5ywIBgfhhlEpDWlqy6?=
 =?us-ascii?Q?kvfWbHVUDuY/z5As/GkGaT9cbAzeR6kiJVRx0I5Z4bPjsm/vhp+qrt5IsPfH?=
 =?us-ascii?Q?wnVl6Ub6fYufuuL1oELJjI8idEzKi9QHbdZ/pFSn80nyG0zzwmvHkwzzqi4X?=
 =?us-ascii?Q?SnqC21yPOFR/mtho9lVXwOpu2JLsIKaivdUoKsaQfRNo5f7uw77PrHIlaBud?=
 =?us-ascii?Q?TL5Kgr7zKJ66KoH/RkyFTpNSJlrdHuREmN0GIZyuqkkpj/U0oXpY+msYsfi8?=
 =?us-ascii?Q?LYdnTRPfWlvb27uieazxlcBt6wa/7HXqQRA+F8PjRSiF/cEx40/05Hcojle+?=
 =?us-ascii?Q?yNL50zyAV1LYHCV8xLHjnmmbuYC3avmVkBBawx8aFyrw02uEJ+tv8DJtMwSb?=
 =?us-ascii?Q?8zmSulb/LrA0/BIGpu6amOeV1+E+Ah+aURiDEJ532zRtEaIq8YwIMOkV6UYX?=
 =?us-ascii?Q?gNPsmNo56sfAEQ5H/1QuWZ2Z/dwAuCpIVqPqNmHvPFuYK5BNwLmbr/hrw1Zj?=
 =?us-ascii?Q?tuZlQEMq5/ZucIeAdN74CHXRRqe+IZiPbPoYcgp8cMEZ+UWzTwAR54NO1+le?=
 =?us-ascii?Q?A78OB2iNxes897ZfDt5WzQuTK6O/8RBZbD9T7onFBgOBaUrqftkgyqqFM61B?=
 =?us-ascii?Q?8/G2rhbyeecei0vQdiUin+tVaR6TnW7SGuZXaZYz2gMEgGOPOoh7sPHFbEq8?=
 =?us-ascii?Q?4EMBN52/bxHwhzfPIPzm/ejkMcFqALr+Uwcn9TxUGzMHRPbZdAP+oNDkN1tz?=
 =?us-ascii?Q?O7lUst4h0bplhJtIdcXmgw6nMYCO4bkH7zPMqR3KEvlu7h8pfgY9zCaQ/rrZ?=
 =?us-ascii?Q?cSk80XsR9XBeLFUfe1uZbLtY7B0mJJMH3lR6RemqDClyXp7cICrbSEYa62iC?=
 =?us-ascii?Q?LrbUe+83sts537z/jIuWxu26YfneZsWqAumZwWG4D7VcUKPL7amyh3sCSEwS?=
 =?us-ascii?Q?F/AdZ4S6wwGk/zAZdSeAZqJqccr9JnIkdJSxlfJTXuN/nrFd25ylRon/Mnsa?=
 =?us-ascii?Q?2D9Y4UMcRdHwtvfWnY3j61TBprZLys4CLJ6mTnuSsq//+pBrmcyM+AJPVoOI?=
 =?us-ascii?Q?o5OI4bJVf+Wbh/S93SJpmIXIxa3//X96CEt0oJ8ar2u6YXy46vDKDbYdzO1S?=
 =?us-ascii?Q?KuXMOkaPcvhCDedPy4NUYcVDJvfon8kRDk1wE5mlIFOhaWT3K+CRzH/65j4A?=
 =?us-ascii?Q?COyGJ1krjpII8+Qq/ZznrjMTxYuOx0an3iChV5i09tmVEcMUwdeBREKNEZrk?=
 =?us-ascii?Q?4Let9rP3+TOnXsRjQVa4VCmHfTpDAuEMuGH/jM8v60VUcxBTjou0iltLv1aw?=
 =?us-ascii?Q?YFNB5r9MxqvvdRNlzRq2Juk5UxqBfmqiKxcAE29K0xV/nXZRIFZntYHv8iba?=
 =?us-ascii?Q?AUn0ZT3hLMv8g8k9Onwmh1EM5rDZ+NjGT6CUUQntayVunKVHSnbErM6wGVJM?=
 =?us-ascii?Q?1DTpLUY7eIOkTKUE7Y38OWiOExQHA2xJmCGVKZMIz3aemb4VaOdEUGpZRwP3?=
 =?us-ascii?Q?ZIDrsyrcOEqQDZuQa8MAbeGbcD/tKLNKGgzzqZgF8P45DcCO1n84SXeqWuYR?=
 =?us-ascii?Q?enk+qIk/9SGnQL/kzARw+R8t8Pukl6mAwuy/3CjUnfq88mrxK+6m64ndmC29?=
 =?us-ascii?Q?duruGv5OmLlNZArwcoc6xXwRAUR/X8PKuHBBRCpu/uxdbJioSdWL8odhGpCE?=
 =?us-ascii?Q?g3R09kz2LW2ihyWHXFN7JeP63GoO6Pig2Mgb/fE9UK7d2816ZZ3jhCv5e/p2?=
 =?us-ascii?Q?vfaDwBbxG/NCHsgveCxwTXG2bjzN3z8=3D?=
X-Exchange-RoutingPolicyChecked:
	YT7e+QGleyN8gehnFaadQvG9bcf1tmtpcvaoeN6AsQfl1LoNf+gl+OfqfA9nHiSaG4OYZeBAW6iGPIOTpHug0qdX8hW62WvI9cQe1/UiVGSy0zKCWo4PRJPVuopR6J9HjHa85c8sNJnx+BA4+jOQ0smX3NdHKQTYgIkQ5CxcdD9ahAfW5MQDbB6pe7HFHtpTOrOPqAiWjIbk2yOitpaFX/Gh8wC0QDeUzmTzlKfY3woV8eeFVcHJXfs4/Qd+xs5P+z1xWR/01we9ONUUqYb0y4bOsoyRGJ2VWE7JrwyBu8UL+QsBeQxjXdw6HPnsrXyJOxYc6uusZZXSMSov4LRG7A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pXqhjF0qukcwzG0hmhP73Tj+u/JabmM4opQ3xXQ+cjhsOTCmSZ/D11ukgifnmRHNDHXWs2xjUxUeDWCgr7TXEFUjni/ZWlsR7EYX3ZItLm2o4e0ruAt6jPWQyhKxK4QMibI8Fd73YYfGId//Y2QJsB5scXOX4S/HBxt8nEOtb27FlMHXOVVr7FIDeblQSV+qy9V1IVIp6E2qpcEY6jV4nYCAPZfEQjcOZ2jHGH9zOEYyWaeqdL7WMWdV5UdABJAQWyepjfeM0fdRP6j4TQeJVPp1TZlGKMwtm72Uchn8A7Dbu5GLacxcBtZtX6MuAPzl1a38sA+VBApDDeGMSwCokxS5EM20esTC5WDyO0KS300Qd2fnYp9Wnr8UwcPjdN0dnBZyYYE3N7KJHWn6yJoyRC9EAd/gZ/tQsK/Q1mzUbOIfjKTPDNI8zGLmv/nuMw/nkVP2rEsf9if9mjbQASq679Ol+k497hK7qErS9yN68fAYbvAedbV3YAj4vYNZJS8OYe9KfpEVn8eVA9PP5qsLJehhZnqHp5hNWrVbxis59XvJJ2UPwcvj0jUGPaX01OuykHrKjDBsghJMkWijKUUZHX+JvMtz7C7Un84iDwLR4ELz4Vq8K2GxRxB6renkq/4M
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca2c48f-e64b-459f-bad5-08dea424916d
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 06:16:50.2300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LvatkuFhiNn69nx+Ul8WLIo7kQD6iZ3os7J6ZGiwZnK8wgpJoK3Kzuc0OzSYecfgxKtXGR5hbgN8/GxD/2axhkpt+KXDnWq/EL58lahlzfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7121

Hello Darrick and all,

Recently, I observed a sporadic failure of xfs/806. If does not fail always,
but fails in steady manner in the last a few months. I would like to ask if
anyone has any insights about the failure.

I started observing that failure in February. It was observed with various test
target devices, zoned/non-zoned, null_blk/tcmu/HDD. The failure was not
recreated easiliy. Recently, I found that I can recreate the failure in stable
manner using dm-crypt on my SMR HDDs and by repeating the test cases from
xfs/803 to xfs/806.

   The failure can be recrated by running xfs/806 many times (> 200 times), but
   it looks recreated sooner by repeating xfs/803 to xfs/806.

The failure is observed with recent xfs/for-next branch.

On falure, the fstests console looks like this:
------------------------------------------------------------------------------
xfs/803      12s ...  12s
xfs/804      12s ...  12s
xfs/805      9s ...  9s
xfs/806      13s ... - output mismatch (see /home/kts/kernel-test-suite/src/xfstests/results//xfs/806.out.bad)
    --- tests/xfs/806.out       2026-03-26 22:40:32.089917897 +0900
    +++ /home/kts/kernel-test-suite/src/xfstests/results//xfs/806.out.bad       2026-04-27 09:21:27.164750487 +0900
    @@ -1,6 +1,7 @@
     QA output created by 806
     Info: TEST_DIR/806.mount: Checking and repairing per autofsck directive.
    -Info: TEST_DIR/806.mount: Disabling scrub per autofsck directive.
    +mount: /var/kts/test/806.mount: /var/kts/test/806.somefile is already mounted.
    +Info: TEST_DIR/806.mount: Checking and repairing per autofsck directive.
     Info: TEST_DIR/806.mount: Checking per autofsck directive.
     Info: TEST_DIR/806.mount: Optimizing per autofsck directive.
    ...
    (Run 'diff -u /home/kts/kernel-test-suite/src/xfstests/tests/xfs/806.out /home/kts/kernel-test-suite/src/xfstests/results//xfs/806.out.bad'  to see the entire diff)
Ran: xfs/803 xfs/804 xfs/805 xfs/806
Failures: xfs/806
------------------------------------------------------------------------------

As you can see, the mount command fails with the "/var/kts/test/806.somefile is
already mounted." message. The test case does mount multiple times. The step of
mount failure is not always same, but the failure message is same always.

Dmesg does not leave anything looks suspecious to me [1].

FYI, here I share the steps I use to recreate the failure. I use a QEMU test
node with Fedora 43. SMR HDDs are exposed to the QEMU VM via PCI passthrough.

  # Set up dm-crypt on two SMR HDDs, /dev/sdc and /dev/sdd. Offset and size are
  # chosen to have 16 conventional zones and 144 sequential write required zones.
  $ sudo dd if=/dev/random of=/tmp/keyfile bs=1 count=256
  $ sudo cryptsetup open --batch-mode --type plain --cipher aes-cbc-essiv:sha256 --key-size 256 --key-file /tmp/keyfile --offset 382730240 --size 83886080 /dev/sdc test1  
  $ sudo cryptsetup open --batch-mode --type plain --cipher aes-cbc-essiv:sha256 --key-size 256 --key-file /tmp/keyfile --offset 382730240 --size 83886080 /dev/sdd test2

  # prepare local.config
  $ cat ./local.config
  export TEST_DIR=/var/kts/test
  export TEST_DEV="/dev/mapper/test1"
  export KEEP_DMESG=yes
  export FSTYP=xfs
  export MKFS_OPTIONS=""
  export SCRATCH_MNT=/var/kts/scratch
  export SCRATCH_DEV="/dev/mapper/test2"
  export FSX_AVOID=-a

  # format TEST_DEV
  $ sudo mkfs.xfs /dev/mapper/test1

  # repeat test cases from xfs/803 to xfs/806 200 times.
  $ for ((i=0;i<200;i++)); do echo $i; if ! sudo ./check xfs/803 xfs/804 xfs/805 xfs/806; then break; fi; done

With the steps, the failures is recreated at 20th repeat at earliest, or 120th
repeat when it takes longer.

Using this environment, I did quick printk debug, and found that do_umount()
in fs/namespace.c returns -EBUSY on failure case. But I'm not sure why it
happens.

Quote from fs/namespace.c:
------------------------------------------------------------------------------
        event++;
        if (flags & MNT_DETACH) {
                umount_tree(mnt, UMOUNT_PROPAGATE);
                retval = 0;
        } else {
                smp_mb(); // paired with __legitimize_mnt()
                shrink_submounts(mnt);
                retval = -EBUSY;   <===================================== here
                if (!propagate_mount_busy(mnt, 2)) {
                        umount_tree(mnt, UMOUNT_PROPAGATE|UMOUNT_SYNC);
                        retval = 0;
                }
        }
------------------------------------------------------------------------------

Any advice will be welcomed. If I can do anything in my test environment,
please let me know.

  System maintenance is planned for my test machines in the first week of May.
  So, my action on my test environment may take some time.


[1] dmesg

[ 1966.727914] [ T137522] run fstests xfs/803 at 2026-04-27 13:47:54
[ 1972.747786] [ T138553] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 1973.406021] [ T138576] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
[ 1973.419142] [ T138576] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 1973.568485] [ T138576] XFS (dm-0): Ending clean mount
[ 1973.570947] [ T138576] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
[ 1973.577722] [ T138576] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
[ 1973.937017] [ T138621] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 1975.775968] [ T137522] run fstests xfs/804 at 2026-04-27 13:48:03
[ 1977.795592] [ T139088] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
[ 1977.807396] [ T139088] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 1977.922463] [ T139088] XFS (dm-0): Ending clean mount
[ 1977.925319] [ T139088] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
[ 1977.932679] [ T139088] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
[ 1978.971340] [ T139191] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 1980.413770] [ T139283] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
[ 1980.426461] [ T139283] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 1980.550420] [ T139283] XFS (dm-0): Ending clean mount
[ 1980.552682] [ T139283] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
[ 1980.558805] [ T139283] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
[ 1983.784203] [ T139478] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 1984.571368] [ T139670] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
[ 1984.582316] [ T139670] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 1984.698207] [ T139670] XFS (dm-0): Ending clean mount
[ 1984.700759] [ T139670] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
[ 1984.708996] [ T139670] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
[ 1985.237069] [ T137522] run fstests xfs/805 at 2026-04-27 13:48:13
[ 1991.545779] [ T140080] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 1992.390589] [ T140272] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
[ 1992.400273] [ T140272] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 1992.510456] [ T140272] XFS (dm-0): Ending clean mount
[ 1992.513019] [ T140272] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
[ 1992.519907] [ T140272] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
[ 1993.060516] [ T137522] run fstests xfs/806 at 2026-04-27 13:48:21
[ 1996.241717] [ T140594] loop0: detected capacity change from 0 to 20971520
[ 1996.286338] [ T140594] XFS (loop0): Mounting V5 Filesystem cdb36045-8330-48c7-b1a4-82c5d7ed21e1
[ 1996.308568] [ T140594] XFS (loop0): Ending clean mount
[ 1996.388493] [ T140613] XFS (loop0): Unmounting Filesystem cdb36045-8330-48c7-b1a4-82c5d7ed21e1
[ 1996.599702] [ T140615] loop0: detected capacity change from 0 to 20971520
[ 1996.638831] [ T140615] XFS (loop0): Mounting V5 Filesystem 3218c7d6-c4a4-4f5a-b9bc-c1ba7ada7e6d
[ 1996.661288] [ T140615] XFS (loop0): Ending clean mount
[ 1996.727650] [ T140630] XFS (loop0): Unmounting Filesystem 3218c7d6-c4a4-4f5a-b9bc-c1ba7ada7e6d
[ 1996.927360] [ T140632] loop0: detected capacity change from 0 to 20971520
[ 1996.965520] [ T140632] XFS (loop0): Mounting V5 Filesystem 15db07f7-722e-401e-8f22-856ceeedeed6
[ 1996.983714] [ T140632] XFS (loop0): Ending clean mount
[ 1997.058905] [ T140651] XFS (loop0): Unmounting Filesystem 15db07f7-722e-401e-8f22-856ceeedeed6
[ 1997.256820] [ T140653] loop0: detected capacity change from 0 to 20971520
[ 1997.294703] [ T140653] XFS (loop0): Mounting V5 Filesystem 98713c32-802b-4179-8ec6-fcc89968b76e
[ 1997.312428] [ T140653] XFS (loop0): Ending clean mount
[ 1997.385745] [ T140672] XFS (loop0): Unmounting Filesystem 98713c32-802b-4179-8ec6-fcc89968b76e
[ 1997.574544] [ T140674] loop0: detected capacity change from 0 to 20971520
[ 1997.616104] [ T140674] XFS (loop0): Mounting V5 Filesystem 45368b30-8413-48b4-becc-4e787f833e42
[ 1997.638100] [ T140674] XFS (loop0): Ending clean mount
[ 1997.916462] [ T140706] XFS (loop0): Unmounting Filesystem 45368b30-8413-48b4-becc-4e787f833e42
[ 1998.076829] [ T140708] loop0: detected capacity change from 0 to 20971520
[ 1998.113814] [ T140708] XFS (loop0): Mounting V5 Filesystem 2f115ed5-8d6d-4a03-97fb-4b2215947ec6
[ 1998.132609] [ T140708] XFS (loop0): Ending clean mount
[ 1998.225237] [ T140727] XFS (loop0): Unmounting Filesystem 2f115ed5-8d6d-4a03-97fb-4b2215947ec6
[ 2000.147618] [ T140793] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 2001.085155] [ T140984] XFS (dm-0): EXPERIMENTAL zoned RT device feature enabled.  Use at your own risk!
[ 2001.094211] [ T140984] XFS (dm-0): Mounting V5 Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
[ 2001.212889] [ T140984] XFS (dm-0): Ending clean mount
[ 2001.215370] [ T140984] XFS (dm-0): limiting open zones to 36 due to total zone count (144)
[ 2001.221959] [ T140984] XFS (dm-0): 144 zones of 65536 blocks (36 max open zones)
[ 2001.680831] [ T141027] XFS (dm-0): Unmounting Filesystem 4586471c-c0d6-4e61-b808-4ba3976a8732
