Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91143358AF;
	Thu, 26 Mar 2026 07:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774510968; cv=fail; b=UyCrCgUz9DqRYoOtVJynLMjGseipwQEbM597R3KZuH4UNEV0AHe2SxZwJt9nWehWvEJ3YLKRlIzjxpIRwXh1J9Y+fmCcmaz3jrig30h7uDK1bKaUU6BqolxGS57rMWWGuB/2f5lcAYAYWsn783BtQd7oDzBKqB3V77L4pq1q7C0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774510968; c=relaxed/simple;
	bh=uxsksZRPcjOTuU4e9tZKwGZzRxvHBIe0We0LtaWGpsY=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=sMzJ4GjRYRy1X+gOvY9GopByO8icerVBdRaGkWrUWjRHEk9HBXDjkuH0AF7KXANHXl5ZRx0M+Qma9fV8jxnqciZA1MXfqg2x3CUxU1TfWeE4iLAqfjHexmjmWVzfbuEupQzmgdxE5GyLUkVJ9flFc9L87ZB5bd25JRVv4QDl9VY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E12VeHLt; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E12VeHLt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774510966; x=1806046966;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=uxsksZRPcjOTuU4e9tZKwGZzRxvHBIe0We0LtaWGpsY=;
  b=E12VeHLtbVZcaVEjpXc/FXVR9UmcQoRoYDE/hr1iAkHCj+E34nFVsTke
   rq51QQqR08VZIG9xrIzyzyMGGqYmlm/Z2eYevUUw/lDZnY/suy+Db7t04
   60Qi5lD5ujb5G6C23PVXaG+a04rVuba5j3+lzYVozFb6oXja+9IG5ZfVL
   QZ+YBr5pEE98/+sOGB0qacb3cjIhjDhprOymK44S0aZnmi1vXe7vUNPGa
   aLN2eISWGxYzA/saUHk7jAScOJ4bKmpw4zgXdhg2+OvLM8Qxt1ScGHiV7
   mMf9PS7vEEuWvLvY3NG+7oXMPOed7iLrAwHOCNWERtdiOH0VfdgpSEx8M
   w==;
X-CSE-ConnectionGUID: aYrpXe9/QyW12ihq2U4WpA==
X-CSE-MsgGUID: 8z7O2/HgS8e4YM4V1MdvoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="92938318"
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="92938318"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 00:42:45 -0700
X-CSE-ConnectionGUID: waEFD26bQRiHOCLJvbWgbQ==
X-CSE-MsgGUID: Nmc49R2wT/mN4y+4p25Vpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="247964213"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 00:41:51 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 00:41:50 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 26 Mar 2026 00:41:50 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.37) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 00:41:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QWiYbKPrxjj33VWTLQRtRp/PISUB7fTh44h8eKI5Ntm+G/vZy5a6xYm3hYpA5jdRF3eJDJ7U+OUaUXWUrvqrBgFI/Ahco5YHGmGHr6Znu5Gwb6MiAHoxfoOHsMFVJFM/+0sZhWyg8z0J7cflPy8d4bKQEHn5Q5+opzPhzSQ+dtZW1cZSpKYZd3Y+DuFrqLwLtWOG04JjqFfqOep0jTslmwgndGp/J0+GLgFk8yR5CvuQ34nXaLwIrONHn77xG6qicDv+ykgfLGZw4eKWa8eRtyIA6x4ssztFlHWP3B2atziu4HZwI0+QPEWY6QIeDXxI9EFkUmMMbJN6MfWepmm67A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iz6IDzEDUA3qHkcqb5xljim9j9ejgzgDU4mjRm2Dwx0=;
 b=dR9RD+uLCWNAi3CR3nldy/1/C7VcsxWKhdzUy241/0zNuXJkZoaGyAmLkbuDKZbRX5hm4PJjp3Z+h56O012CgpfAP2fv73YW5njJ/GVqRNk93Lp+An5mQUjfkPqCF+6BVrihbmsrNoBjYRzueLn3gA6cyFdP3f+gOYtuiYO/8IliPvD6G+UHSGHDclIZ/uwNA5rfQbKRzf4KLHUOcNY3jyHoa+kBsGgMSNPN0Z+HR/uF56ayA5x1c0A0ggUZtzyaf5/RqjM1a+RWvkqKd4GJrQl3bGj3+/VGblEg7AJ+F7Su3OBo5PhLI6G58N1QRovsTLfa3VfnWGbo0up9QUuIfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by LV2PR11MB5999.namprd11.prod.outlook.com (2603:10b6:408:17d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Thu, 26 Mar
 2026 07:41:47 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9745.019; Thu, 26 Mar 2026
 07:41:47 +0000
Date: Thu, 26 Mar 2026 15:41:39 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>, <linux-xfs@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [xfs]  0ff51a1fd7:
 WARNING:at_arch/x86/mm/fault.c:#do_user_addr_fault
Message-ID: <202603261509.7544794b-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|LV2PR11MB5999:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d3bf58a-1865-4a19-30ed-08de8b0b22a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: 4bQNdsVmonTkV/5B7a1NZ1SjdZsMCUBX2z36T2OK/PlOhV4gfMF45xOUFwBOfupZYqNc7cwFRfmJ4NE5Nf91uRU5afyJWPY4YluSF8AiicIKqSrM5c3tmO/X4BJ/ePp8XgJBK4QIUUD4B/YQiPBjVpUrl6ujDShezWihPPPDWWgmlnBEXPxO9C9OyqYgMEIVH/XVM5LhlcIG4aBohTHAIH3F6/Vi9Ntg9ZyFTHChT8CEdHpewqoczHNj9mKBbN1a2TLD5tw8H/usU0h5vbRdTfCBKOLXHhHwJU8MYzEYPdVGE30w/ko+J2eQzTeZDsIx1joCZjoLK6EZ11SIEogQrw6EtEMyB3QfLaxTkl+yfOSD3BC57wbUEIyPaXRen6shcjXC6jptWIx0h+965IdfoPICd1DWTpC/r1pKdIdQeqVUtfPU9YWUIWDGQtFKjXumuiWwE547vmaZ2JZILaspddgTBWu9exnmwjY8O4cusF40ALfA0T8/1TC2hZmk5WyNrqJ/l8k0Y0G2QsRtPdDhXPZjulsSnQKs2v7eBSPzKVRb+iRg/5liWdvC/tUUrfnZR4Llf4KDiZ13OvzXcMtPNEi9kxh/BJvHSA2SGTDdLL9t9A1Vg/SCEswsWDxi7yswcVSVZx0zveizmQa9VzlfoTlSlV4h/kEEJqjMXdfPtTj7ujaVwpmqAy7VJQvgPCnJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K1fsj9hBw+nX6A9jXKqBJ0TVoe0HO6qWuekhO7hJZbPE5sFXNq3md0CrWA5N?=
 =?us-ascii?Q?26O8e5ilqL1Xx8g+LZJvj5nor/KTKyyznQpUBUeJqhFKwcdcV3Do/Mg62Lyz?=
 =?us-ascii?Q?ivy0MVwAQg95kYAgWolpp/jbOWMylzWbu2AaVV+MSl6dN2Nx/Ctr/Q1fm/Z/?=
 =?us-ascii?Q?fCpm7Dyp42xfly+xd5TmgoLXVu6x3qomMhIZVff0oGQpUK+3sXx6R9nbNKt6?=
 =?us-ascii?Q?pa0ufbM/p3z6q1jJ3gG+eM0fbr9vIjtqzh9QZ0N0SNjq5yvRk+yYki6TAPYE?=
 =?us-ascii?Q?bybhrptIaffBliNO0Cx7RdMQQcUn45tfGfi5tfd6svZzi4jYZmFhcVWB194O?=
 =?us-ascii?Q?WHwZb9JpykBcdyzYtG8i1M24FCjJM7aIvB805DDnMDPrbzlYFcsBdnXLRaHN?=
 =?us-ascii?Q?zQRDhXVNM3SaIzAuvQH0KTULTXmsC9bB3GuHOFL1/u1cUQoz/UitjEWgAXSz?=
 =?us-ascii?Q?+Mh6XHP0SbnOCtRT1mhIxmXNDRfWpff1QakD3j35YzZxdBV7Ywr5TbnWJv7b?=
 =?us-ascii?Q?2FJ7YeyL8ChdxD26ZeOIPb1JLNW0j9QHCXiuUD4hQz5gG4zw8g3Vwv3HnNdW?=
 =?us-ascii?Q?8PgS7Ih55uweyatk+w9YgI+EXfAFoLx++DDoeg1E2+3oMEnxhTeEBtnqrKnF?=
 =?us-ascii?Q?FKP37ddx3hg2OnFbq6qyDPHjDlGBYmSUAOW80eDNFHtbNaAx5QEFnvCpikch?=
 =?us-ascii?Q?606sybmK0w/TJhHsZ/qAk5zgO1ludvBlZww6sn3RCbpIEpqxl8vs2rqRIQRQ?=
 =?us-ascii?Q?iSrQBIi6+ANRnfqe3OulZAd9SF/sqZLKb2aop0S4pr8TP9jaCEATEOnzpONe?=
 =?us-ascii?Q?KmArsGP6KhuhM/I7PsbR0NjaPzn1Rxg2yrjwPmlH3ePI1m4ykiipuizF1U6r?=
 =?us-ascii?Q?8kwi7C4Ib9giFjj17VNaeiKq3bRmurmWZX7DbVZAuLGA8+OURSjcQxdKvDnU?=
 =?us-ascii?Q?eqyvTz8V63AEMEmd9MxAYsYzcCeVMDstqOvgxXzuXekQqQbJroR0O7WZIe/N?=
 =?us-ascii?Q?/vQXsa3JUvWvnJimMhip94WXIA8s9bHX3zklWfTtdIyI63c4tyl8tQ9lyr44?=
 =?us-ascii?Q?pc+9hgUCr7LIhYaGPnxG0OKsHKvQFWDO29g5pINpcU+Mri2Mye6wgo40rmdV?=
 =?us-ascii?Q?xnodC9aSGAym/mEKuQEUsv0fXabm5EBja5/ATx+WboPzshpU+EMfXJtulgYV?=
 =?us-ascii?Q?zqTA1i910zZK3Y0NiGaNlg/PayouRwx2wI767A8MCDVQnmZroAGtkZhKUDrL?=
 =?us-ascii?Q?LWi+vffYZeI4qxQ3SQ9IxNEXjn8k5w4YsHHUeWMWbdKoyAnu6Zce39BwthMQ?=
 =?us-ascii?Q?t7idt6oWfNOfYcjc29zThBRZhXRwch466hm4YyvQljv5/CBgHx2YHGEau5eP?=
 =?us-ascii?Q?OABQSmXP8JDpXr6+3mP6Sb60jZCyJan4UxdYM/I7Lhz9+ps72eXmwRjNlGxZ?=
 =?us-ascii?Q?y5r5beUe78M4CPeWGLyUMgYmlvu7shlBz9dHv3F6cWV6Mwm87SrqOilB7s3g?=
 =?us-ascii?Q?/xhnZO/FH9WT5LSV+nJBUGrsGK5EhS1Nc8vVUqb3Ba16ax5BMHmp5umJ2rpG?=
 =?us-ascii?Q?Niknnds0+Hrnt+mLZMZbJgbEyldAzO1PmdqlX+XEs+okjzp5R2M15BKBoV39?=
 =?us-ascii?Q?awF0iIWKzUobA0T99apaYxXBnQjYoIiMRyaRavi+107xHaIg2Mk9BS/GJDam?=
 =?us-ascii?Q?NfYuCXqkdidH7nH5EnKW0TxnUJlwLGhAHgMyRwX0Cy/Cfude/YK9PASAazor?=
 =?us-ascii?Q?CAhAbQ1vfQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: nGys12/FFB5GoKKZdhckdV6AYxPi9+yLmh1uXzG/8VkU2CxLKG2RD1Vizsxdg6GC8GjAf9lmy1OzCDOKc6nfWmvOr2/HO+iT9pHhzbtrEe1+5CiFICMqDhStaC1SXVy8H29VvKowTehwRS+m2VwGI/Y8boetYrocZ+EihN10XnF6ByPFtqgwW/mkpGbbvvMTtjbxxIR0FHwQqR8BzMQlQqWvQNLPuoU9nHeYPGfDg39nt6GVDY325GX914MSJXC+ttNiQAKBpxp5HCxJhg0DsUbdBqn6jHOhGegmX3qalM6IPCbvOOAhOiodS5zK+xAv/hONX1xwLeK+YjXjAsWj+Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3bf58a-1865-4a19-30ed-08de8b0b22a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 07:41:47.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrLbYTSIyZ0PmMhZaUJOUhurP2TxkaDMkmVAgXIofWbaHza6U5uw4wj6jfZLkdzoAWXRz6+VL6WlOXa722LzmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5999
X-OriginatorOrg: intel.com



Hello,


Since this change is targeted for the 2025 LTS kernel, and we don't have
sufficient knowledge to evaluate whether the randconfig we used creates overly
corner-case tests or can reveal genuine issues, we are providing this report
for your information only.

The randconfig doesn't set CONFIG_JUMP_LABEL, but this config will be selected
by the following configuration:

--- /pkg/linux/i386-randconfig-011-20260324/clang-20/21d59d00221e4ecbcb597eec0021c667477d3335/.config   2026-03-25 22:14:50.695300028 +0800
+++ /pkg/linux/i386-randconfig-011-20260324/clang-20/0ff51a1fd786f47ba435ede6209046959bad54a8/.config   2026-03-25 22:14:53.775551568 +0800
@@ -666,7 +666,8 @@ CONFIG_GENERIC_IRQ_ENTRY=y
 CONFIG_GENERIC_SYSCALL=y
 CONFIG_GENERIC_ENTRY=y
 CONFIG_KPROBES=y
-# CONFIG_JUMP_LABEL is not set
+CONFIG_JUMP_LABEL=y
+# CONFIG_STATIC_KEYS_SELFTEST is not set
 # CONFIG_STATIC_CALL_SELFTEST is not set
 CONFIG_OPTPROBES=y
 CONFIG_UPROBES=y
@@ -5125,7 +5126,13 @@ CONFIG_XFS_SUPPORT_ASCII_CI=y
 CONFIG_XFS_QUOTA=y
 # CONFIG_XFS_POSIX_ACL is not set
 # CONFIG_XFS_RT is not set
-# CONFIG_XFS_ONLINE_SCRUB is not set
+CONFIG_XFS_DRAIN_INTENTS=y
+CONFIG_XFS_LIVE_HOOKS=y
+CONFIG_XFS_MEMORY_BUFS=y
+CONFIG_XFS_BTREE_IN_MEM=y
+CONFIG_XFS_ONLINE_SCRUB=y
+CONFIG_XFS_ONLINE_SCRUB_STATS=y
+CONFIG_XFS_ONLINE_REPAIR=y
 CONFIG_XFS_DEBUG=y
 # CONFIG_XFS_DEBUG_EXPENSIVE is not set
 # CONFIG_XFS_ASSERT_FATAL is not set


During boot tests, we discovered the following issue that does not appear in the
parent commit.

=========================================================================================
tbox_group/testcase/rootfs/kconfig/compiler/sleep:
  vm-snb-i386/boot/quantal-i386-core-20190426.cgz/i386-randconfig-011-20260324/clang-20/1

21d59d00221e4ecb 0ff51a1fd786f47ba435ede6209
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :50          42%          21:50    dmesg.BUG:kernel_NULL_pointer_dereference,address
           :50          58%          29:50    dmesg.BUG:unable_to_handle_page_fault_for_address
           :50         100%          50:50    dmesg.EIP:do_int80_syscall_32
           :50         100%          50:50    dmesg.EIP:do_user_addr_fault
           :50         100%          50:50    dmesg.Kernel_panic-not_syncing:Fatal_exception
           :50         100%          50:50    dmesg.Oops
           :50         100%          50:50    dmesg.WARNING:at_arch/x86/mm/fault.c:#do_user_addr_fault
           :50         100%          50:50    dmesg.boot_failures


below is the full report.


kernel test robot noticed "WARNING:at_arch/x86/mm/fault.c:#do_user_addr_fault" on:

commit: 0ff51a1fd786f47ba435ede6209046959bad54a8 ("xfs: enable online fsck by default in Kconfig")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linux-next/master 09c0f7f1bcdbc3c37a5a760cbec76bf18f278406]

in testcase: boot

config: i386-randconfig-011-20260324
compiler: clang-20
test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603261509.7544794b-lkp@intel.com



[    6.797604][   T68] ------------[ cut here ]------------
[    6.799213][   T68] WARNING: CPU: 1 PID: 68 at arch/x86/mm/fault.c:1276 do_user_addr_fault (ld-temp.o:?)
[    6.799922][   T68] Modules linked in:
[    6.800237][   T68] CPU: 1 UID: 0 PID: 68 Comm: rc.local Not tainted 6.17.0-rc4-00013-g0ff51a1fd786 #1 PREEMPTLAZY
[    6.801014][   T68] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    6.801760][   T68] EIP: do_user_addr_fault (ld-temp.o:?)
[    6.802134][   T68] Code: 15 fe ff ff 89 f9 ff 75 f0 e8 87 05 00 00 83 c4 04 e9 03 fe ff ff 89 f9 89 da ff 75 f0 e8 b3 01 00 00 83 c4 04 e9 ef fd ff ff <0f> 0b 89 f9 89 da ff 75 f0 e8 9d 04 00 00 83 c4 04 e9 d9 fd ff ff
All code
========
   0:	15 fe ff ff 89       	adc    $0x89fffffe,%eax
   5:	f9                   	stc
   6:	ff 75 f0             	push   -0x10(%rbp)
   9:	e8 87 05 00 00       	call   0x595
   e:	83 c4 04             	add    $0x4,%esp
  11:	e9 03 fe ff ff       	jmp    0xfffffffffffffe19
  16:	89 f9                	mov    %edi,%ecx
  18:	89 da                	mov    %ebx,%edx
  1a:	ff 75 f0             	push   -0x10(%rbp)
  1d:	e8 b3 01 00 00       	call   0x1d5
  22:	83 c4 04             	add    $0x4,%esp
  25:	e9 ef fd ff ff       	jmp    0xfffffffffffffe19
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	89 f9                	mov    %edi,%ecx
  2e:	89 da                	mov    %ebx,%edx
  30:	ff 75 f0             	push   -0x10(%rbp)
  33:	e8 9d 04 00 00       	call   0x4d5
  38:	83 c4 04             	add    $0x4,%esp
  3b:	e9 d9 fd ff ff       	jmp    0xfffffffffffffe19

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	89 f9                	mov    %edi,%ecx
   4:	89 da                	mov    %ebx,%edx
   6:	ff 75 f0             	push   -0x10(%rbp)
   9:	e8 9d 04 00 00       	call   0x4ab
   e:	83 c4 04             	add    $0x4,%esp
  11:	e9 d9 fd ff ff       	jmp    0xfffffffffffffdef
[    6.807700][   T68] EAX: 80000000 EBX: 00000000 ECX: 00000000 EDX: 4448bf00
[    6.808245][   T68] ESI: 434eff2c EDI: 434eff2c EBP: 434eff08 ESP: 434efedc
[    6.808774][   T68] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010046
[    6.809317][   T68] CR0: 80050033 CR2: 3fb783bc CR3: 10d4a000 CR4: 000406b0
[    6.809855][   T68] Call Trace:
[    6.810103][   T68]  ? do_execveat_common (ld-temp.o:?)
[    6.810486][   T68]  ? exc_page_fault (ld-temp.o:?)
[    6.810930][   T68]  ? pvclock_clocksource_read_nowd (ld-temp.o:?)
[    6.811381][   T68]  ? entry_INT80_32 (arch/x86/entry/entry_32.S:945)
[    6.811784][   T68]  ? handle_exception (arch/x86/entry/entry_32.S:1048)
[    6.812169][   T68]  ? entry_INT80_32 (arch/x86/entry/entry_32.S:945)
[    6.812538][   T68]  ? entry_INT80_32 (arch/x86/entry/entry_32.S:945)
[    6.812897][   T68]  ? pvclock_clocksource_read_nowd (ld-temp.o:?)
[    6.813339][   T68]  ? do_int80_syscall_32 (ld-temp.o:?)
[    6.813756][   T68]  ? pvclock_clocksource_read_nowd (ld-temp.o:?)
[    6.814194][   T68]  ? do_int80_syscall_32 (ld-temp.o:?)
[    6.814581][   T68]  ? irqentry_exit (ld-temp.o:?)
[    6.814941][   T68]  ? entry_INT80_32 (arch/x86/entry/entry_32.S:945)
[    6.815276][   T68]  ? entry_INT80_32 (arch/x86/entry/entry_32.S:945)
[    6.815646][   T68] irq event stamp: 3394
[    6.815980][   T68] hardirqs last  enabled at (3393): bprm_execve (ld-temp.o:?)
[    6.816583][   T68] hardirqs last disabled at (3394): do_int80_syscall_32 (ld-temp.o:?)
[    6.817250][   T68] softirqs last  enabled at (3354): __do_softirq (ld-temp.o:?)
[    6.817842][   T68] softirqs last disabled at (3339): __do_softirq (ld-temp.o:?)
[    6.818418][   T68] ---[ end trace 0000000000000000 ]---


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260326/202603261509.7544794b-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

