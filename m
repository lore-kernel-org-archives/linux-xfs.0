Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED405C6FD1D
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Mar 2023 06:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjCTGs6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Mar 2023 02:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCTGst (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Mar 2023 02:48:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BE512BF1
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2023 23:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679294926; x=1710830926;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=u4FdzzUPDm3nQSKpQcCnxc5NlDS9mez2vQGfrZe+DZA=;
  b=Gdxxrza6oY3ollFLpGWqqBIffXoUNszWh/L0HvG9GUu81DwoWIWxoeK5
   Iu3ATVyQYauWHZmxlKYGzmKtqixze/TP8hW5Nk1cOJOFhrkDKy15i4p9i
   IGjxVXUDowet0475IZZbIXvy897tqNFU0a5HDnxIy/pJU7EdTRpjTba0o
   g1/rDnqIq2KnN5HYcR4pGGBV4Wn9krPjJCr373apzeDtUB0B15NmC4Tjf
   TWfBdLxb5iRDdXjmSDDkxtNxx07BZkR57BO5CsD5/6d9t435Aiv0LA4YL
   d9OnCazPTJQbP95ibCLXtBYYiN68YXNo+aLVP8Vso82ZiUwMFQqFlXVaW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="338613229"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="338613229"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 23:48:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="745248062"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="745248062"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 19 Mar 2023 23:48:46 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 19 Mar 2023 23:48:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 19 Mar 2023 23:48:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 19 Mar 2023 23:48:45 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 19 Mar 2023 23:48:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtSomt1LTherzLRuyD8J+k6hh6mOu1JRImZsr39lTDAKL7yKp2n51owkOjAmXskCMqRZ6jU5QwZAhfVUUyUXsBLzszOPStuW7jnQMn74g8vzLU+plPEsXf1Y7W7QrCnkVslhYS1g8G59LmyrriRokGXuY1GyGZz5TSCkb57IBX232+LeOz5GLqmWTS7AzqQuCV6QJjLAtQF0jn6Is6SwX3WaqKf+08jVkE184AaUWl5UtIM3Jvbo3MrKtxKYB5rw3pdrn1pgztnaH94qaN8aGLreONlUIQtL5sCipRPG9WCziygLeRklvhRI6dkKGfO2HBoOBdZlMIJmgTSJcuNJnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NaxKLoo2oNRfz+qPcr2FajA8uyzdr3WVbp6VXO3B1PY=;
 b=mRZQMU7a0RSxZ5fixbMxUOpINPsUdsv59lLmrgpCwjIW9azc5TMHGxxduQnR9fJU4q+I6viRh85GkE8avztL4fwO3ELiR5d7MtMcHvoDHcmHnRoAmysvjO5dDLcKC/EsnTYtSVU5jMIQD82K5l0WxBKHiu87bz5GP7ouihGIi6JBtECHzlFs6nBLzkoQWmeGzXNXF3JcQYexczbwo7gd209ITP1JhLh10yFxGZ9jOoSGMkafiXIzhh0cwXkuNfWXYd3z+TVabTBhbiZnTCQJsnZEI3F27Knr3NYBUbtREFJ9FhXR5snbyzFUT9nRU8c8y9gxDHFeKGfcy9EQRJHUDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
 by SA2PR11MB5017.namprd11.prod.outlook.com (2603:10b6:806:11e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 06:48:42 +0000
Received: from PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239]) by PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239%8]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 06:48:42 +0000
Date:   Mon, 20 Mar 2023 14:50:07 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     <dchinner@redhat.com>
CC:     <bfoster@redhat.com>, <djwong@kernel.org>, <heng.su@intel.com>,
        <linux-xfs@vger.kernel.org>, <lkp@intel.com>
Subject: [Syzkaller & bisect] There is BUG: unable to handle kernel NULL
 pointer dereference in xfs_filestream_select_ag in v6.3-rc3
Message-ID: <ZBgCH/8EguhJkwPI@xpf.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR01CA0112.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::16) To PH0PR11MB4839.namprd11.prod.outlook.com
 (2603:10b6:510:42::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4839:EE_|SA2PR11MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: 47fe7038-9c6f-4f92-4aaa-08db290f24de
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fl1pmZekjUQOCdEmH0OTT4k4c2Nr6JJ1p8celzn9jW+AxOzOWIb3FsulxZeBa8wDqG2h6/qy05jpb586YvOag/+/95DuKsKBldOfYZL7UK5uWVNBEPh/zGTmoyjOp7HTpQF7IcJ1g7//Eb+G2QSUEEBtfM83bohnFspZ98DdAxbWmEfPyUkPQaDcUj8jRqblnzmfoQpsqWT5nOs7EeCTM7oq47Cr0DP8ESsJJhMiLgQB/DmQCfz289jXyrn5/co7CzbsmXkgDW1AYXFlBhqPQzo9Wt+57e2fIHnPdnBPKxmVcKwSn2wdQVK6otKBOk3GGIk/+L1gxcKQxibqZjSW3mhkx5cVLCNZ82qfTIqS+L0DnNe9Pxw/hndzAzbMrx3oZaUrj29OLbuf5UfS4r3O7qAvzK4lm5TKobOzmrnAVUVAqbJWQoMX+tjG0K1h6uxRQF62vNSQMDGnoFdGWOvoc0tU3nneTrUBtsKSif97XsUR1wnioIlxSZ+4pBb1rCkejrQifMf0GY4wD7MOe4QcqKbdLkvIOQgDTxa6SJBOnPLqvyleMdlVOAwmidxnJojaYglKB7PjpqSuPatoYGl7tRgjqz/8rkQxygxY5838ftuwHuunSEUk84uz+kw6gAYhTHkVYNXZ4EQPUnbLfNG5RjlHJpfstsbfl/UlmFORdhgNcrP3ztFaLgDmkLRTWIxtVjgYo0IiJLIApWMChcn5G5hWSXzgkgUeerLzlYRNxZCXVQ2oy5p40mdTmywdW35d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4839.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(39860400002)(346002)(366004)(451199018)(44832011)(30864003)(8936002)(5660300002)(41300700001)(4326008)(86362001)(38100700002)(82960400001)(2906002)(6916009)(966005)(6486002)(107886003)(83380400001)(45080400002)(478600001)(6666004)(186003)(26005)(6506007)(6512007)(316002)(8676002)(66476007)(66556008)(66946007)(21314003)(505234007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c1R95u8jBmLSsYkFiqTynYo/KWUe0hzsCkYp3uRAlEqSOEArllVZoLV2cOTz?=
 =?us-ascii?Q?0YZ13tWCc6CQBzWp1QANc4Fx9bfi4mlrMwLQRPCW1QEqPftgdNrPilj2GZqB?=
 =?us-ascii?Q?42USW1NS3O/alI++Js08sAHrudRgC1CXgeb4B8lIkqSq5wjnJX9DI/RKfPEo?=
 =?us-ascii?Q?fcvkodf3TPp3H/mp93INUrArvrBC5tDd28D9GyAp7Foz4cVCaeZ5CadCh2si?=
 =?us-ascii?Q?DrOImY7N7Ixyf+PVkg8MsXaa51lmIQ+WAdKlA3K9JC1TTMXlnktEldEeWeJq?=
 =?us-ascii?Q?/5c7qxRltmPzALVzYFzl0grgw2BkZg30pcRyCl1RVktgMDAm54lhemPu/G0+?=
 =?us-ascii?Q?XBDs9jK445ggNeAs/dNKjTOyymEv0li31ofUV3LM5ldb/D+kZx02b3qS5+tN?=
 =?us-ascii?Q?wa13WFfov35DdubGQA34NoAaOhf5DwAxIRykxFjuh9PX0LwUR1wut6Pw5h5Z?=
 =?us-ascii?Q?6jYIlfk6wjYkmatlcDMLsR0jOX5R9sUIUUl0To4pN30pFx/y7RxVHGqznP7Q?=
 =?us-ascii?Q?pkeR5c9tPGUVv7E1hJBeyxOo/dIckwNcT0gOsmmQdQoWrn4Kt8pzxvyrTDiE?=
 =?us-ascii?Q?eoziWVsd3TldnmIRp/3SRToJInuSNz7m3IsthpvDsEd6ld5MsTedrP3004iQ?=
 =?us-ascii?Q?cZw/FXmZVCbSlbDBBsP89LiNwGtfd1o9LKUBQ0bpcjbKtpk8G8hQNooYqCCc?=
 =?us-ascii?Q?P7aIzUjHqNqedT9SJqW8yELEhx9bpQBbvuoq+hUpi8BdDp1YwqP6frE1AML9?=
 =?us-ascii?Q?lA/FA1eNvzptsCr8JMUwFZKnT2cVAvKRD0blVge7WU0AxpUrNJeQjqDZR3nn?=
 =?us-ascii?Q?oOy/ASIyG4BATWtN1+FTWYWb4Nuz7PCpd//CmZFf7nT0sXZ+nVj/hmkuDZjr?=
 =?us-ascii?Q?8ZNc0VvQRF0vfVWi+d9avzwF4cSoZCZfXyVN5XIi8+mIj4axwvMkIlVND8Nb?=
 =?us-ascii?Q?gsUCvME3jSkHcU9fN8SKkKmF7sOMNBgggVE+MitRZKwn5JhYXyPiY7HXAasT?=
 =?us-ascii?Q?BW/Eqe5SId354g05a8YTLg79b4jEXeVV6ndGBNeStlsJxQwV1ReX/18AEwM8?=
 =?us-ascii?Q?WYIGvBIuccG+jRus4PQ8iEUkiCANhiOYm2lGD1ECA7nn+OZ1p7zigsccr8P4?=
 =?us-ascii?Q?I32mnx66EAB/e0cykF9O64dvg8Hbp272Vcmya/s4FD9+v/uCQQzgm9ADQtm/?=
 =?us-ascii?Q?rGeZkzUHiQ7C2hStzMo+KmxS/hBtgJ/jhxqiUYWtSlN+bwudwj1ibT1LyVC7?=
 =?us-ascii?Q?9DQ3ahMGAISIrrLf6QWeQMIuaiBRByNej2aqT3jmUJOoicGHnattgyRVbNsA?=
 =?us-ascii?Q?+KGIblMWP2qicVnXVjC1p52P33BODH4o4wjdJ2e9zRryIkix/HQDUsnQxhQ1?=
 =?us-ascii?Q?yW67bybSsktx5QqcrrrzhEFv5U8ZW/KQOA97LZ3WzqR0FkhB26ocnfz/ve28?=
 =?us-ascii?Q?/lFWBB2veeHlV3sKtOTHBFEE4KPBjiVeaOs1PfLEhE5/8qRtEHA59Y9xL5QY?=
 =?us-ascii?Q?5QNc/RPmsn+Jhdl8Gvd3q0QEeYI3EieNdhtfyB1U7eAsFZn0fPAHhNYprqGe?=
 =?us-ascii?Q?jESpkQ4geSKVSmqjktIe14gt9XXGGA5vBLNKoNrnbWZ1/21I3PmRKyqwPIQQ?=
 =?us-ascii?Q?mA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47fe7038-9c6f-4f92-4aaa-08db290f24de
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4839.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 06:48:42.4727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Rkz86TIyuISoZ6K0yh1i3KSgHO6yru8F4cDJ9W5uNNe599YWRA0zJ9uRpZZRqWko39SmpNabZAWqpPd7cJwhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5017
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave Chinner and xfs experts,

Greeting!

There is BUG: unable to handle kernel NULL pointer dereference in
xfs_filestream_select_ag in v6.3-rc3:

All detailed info: https://github.com/xupengfe/syzkaller_logs/tree/main/230319_210525_xfs_filestream_select_ag
Reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/repro.c
Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/kconfig_origin
v6.3-rc3 issue dmesg: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/v6.3-rc3_issue_dmesg.log
Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/bisect_info.log

Bisected between v6.3-rc2 and v5.11 and found the bad commit:
"
8ac5b996bf5199f15b7687ceae989f8b2a410dda
xfs: fix off-by-one-block in xfs_discard_folio()
"
Reverted the commit on top of v6.3-rc2 kernel, at least the BUG dmesg was gone.

And this issue could be reproduced in v6.3-rc3 kernel also.
Is it possible that the above commit involves a new issue?

"
[   62.318653] loop0: detected capacity change from 0 to 65536
[   62.320459] XFS (loop0): Mounting V5 Filesystem d6f69dbd-8c5d-46be-b88e-92c0ae88ceb2
[   62.325152] XFS (loop0): Ending clean mount
[   62.326049] XFS (loop0): Quotacheck needed: Please wait.
[   62.328884] XFS (loop0): Quotacheck: Done.
[   62.363656] XFS (loop0): Metadata CRC error detected at xfs_agf_read_verify+0x10e/0x140, xfs_agf block 0x8001 
[   62.364489] XFS (loop0): Unmount and run xfs_repair
[   62.364881] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[   62.365398] 00000000: 58 41 47 46 00 00 00 01 00 00 00 01 00 00 40 00  XAGF..........@.
[   62.366026] 00000010: 00 00 00 02 00 00 00 03 00 00 00 00 00 00 00 01  ................
[   62.366657] 00000020: 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00 04  ................
[   62.367285] 00000030: 00 00 00 04 00 00 3b 5f 00 00 3b 5c 00 00 00 00  ......;_..;\....
[   62.367927] 00000040: d6 f6 9d bd 8c 5d 46 be b8 8e 92 c0 ae 88 ce b2  .....]F.........
[   62.368554] 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   62.369180] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   62.369806] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   62.370471] XFS (loop0): metadata I/O error in "xfs_read_agf+0xd0/0x200" at daddr 0x8001 len 1 error 74
[   62.371312] XFS (loop0): page discard on page 00000000a6a1237b, inode 0x46, pos 0.
[   62.385968] BUG: kernel NULL pointer dereference, address: 0000000000000010
[   62.386541] #PF: supervisor write access in kernel mode
[   62.386960] #PF: error_code(0x0002) - not-present page
[   62.387370] PGD 0 P4D 0 
[   62.387588] Oops: 0002 [#1] PREEMPT SMP NOPTI
[   62.387945] CPU: 1 PID: 74 Comm: kworker/u4:3 Not tainted 6.3.0-rc3-kvm-e8d018dd #1
[   62.388545] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   62.389426] Workqueue: writeback wb_workfn (flush-7:0)
[   62.389845] RIP: 0010:xfs_filestream_select_ag+0x5d5/0xac0
[   62.390285] Code: 83 ff 49 89 5d 18 be 08 00 00 00 bf 20 00 00 00 e8 20 94 03 00 48 89 c3 48 85 c0 0f 84 57 04 00 00 e8 2f 30 83 ff 49 8b 45 18 <f0> ff 40 10 49 8b 45 18 48 8b 75 b8 48 89 da 48 89 43 18 48 8b 45
[   62.391712] RSP: 0018:ffffc9000092f4c0 EFLAGS: 00010246
[   62.392128] RAX: 0000000000000000 RBX: ffff88800b858940 RCX: 0000000000006cc0
[   62.392688] RDX: 0000000000000000 RSI: ffff88800a02a340 RDI: 0000000000000002
[   62.393246] RBP: ffffc9000092f548 R08: ffffc9000092f400 R09: 0000000000000000
[   62.393805] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[   62.394363] R13: ffffc9000092f588 R14: 0000000000000001 R15: ffffc9000092f708
[   62.394924] FS:  0000000000000000(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
[   62.395553] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.396008] CR2: 0000000000000010 CR3: 000000000ad7c003 CR4: 0000000000770ee0
[   62.396569] PKRU: 55555554
[   62.396793] Call Trace:
[   62.396996]  <TASK>
[   62.397179]  xfs_bmap_btalloc+0x706/0xb90
[   62.397512]  xfs_bmapi_allocate+0x25b/0x5e0
[   62.397850]  ? __sanitizer_cov_trace_pc+0x25/0x60
[   62.398239]  xfs_bmapi_convert_delalloc+0x335/0x6c0
[   62.398649]  xfs_map_blocks+0x2ff/0x740
[   62.398971]  ? __sanitizer_cov_trace_pc+0x25/0x60
[   62.399362]  iomap_do_writepage+0x43f/0xf10
[   62.399709]  write_cache_pages+0x2b8/0x7e0
[   62.400047]  ? __pfx_iomap_do_writepage+0x10/0x10
[   62.400438]  iomap_writepages+0x3e/0x80
[   62.400757]  xfs_vm_writepages+0x97/0xe0
[   62.401088]  ? __pfx_xfs_vm_writepages+0x10/0x10
[   62.401470]  do_writepages+0x10f/0x240
[   62.401783]  ? write_comp_data+0x2f/0x90
[   62.402112]  __writeback_single_inode+0x9f/0x780
[   62.402492]  ? write_comp_data+0x2f/0x90
[   62.402823]  writeback_sb_inodes+0x301/0x800
[   62.403184]  wb_writeback+0x18b/0x580
[   62.403495]  wb_workfn+0xca/0x880
[   62.403778]  ? __this_cpu_preempt_check+0x20/0x30
[   62.404171]  ? lock_acquire+0xe6/0x2b0
[   62.404484]  ? __this_cpu_preempt_check+0x20/0x30
[   62.404872]  ? write_comp_data+0x2f/0x90
[   62.405202]  process_one_work+0x3b1/0x860
[   62.405538]  worker_thread+0x52/0x660
[   62.405846]  ? __pfx_worker_thread+0x10/0x10
[   62.406202]  kthread+0x161/0x1a0
[   62.406475]  ? __pfx_kthread+0x10/0x10
[   62.406787]  ret_from_fork+0x29/0x50
[   62.407094]  </TASK>
[   62.407281] Modules linked in:
[   62.407535] CR2: 0000000000000010
[   62.407808] ---[ end trace 0000000000000000 ]---
[   62.408178] RIP: 0010:xfs_filestream_select_ag+0x5d5/0xac0
[   62.408619] Code: 83 ff 49 89 5d 18 be 08 00 00 00 bf 20 00 00 00 e8 20 94 03 00 48 89 c3 48 85 c0 0f 84 57 04 00 00 e8 2f 30 83 ff 49 8b 45 18 <f0> ff 40 10 49 8b 45 18 48 8b 75 b8 48 89 da 48 89 43 18 48 8b 45
[   62.410052] RSP: 0018:ffffc9000092f4c0 EFLAGS: 00010246
[   62.410469] RAX: 0000000000000000 RBX: ffff88800b858940 RCX: 0000000000006cc0
[   62.411032] RDX: 0000000000000000 RSI: ffff88800a02a340 RDI: 0000000000000002
[   62.411594] RBP: ffffc9000092f548 R08: ffffc9000092f400 R09: 0000000000000000
[   62.412155] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[   62.412716] R13: ffffc9000092f588 R14: 0000000000000001 R15: ffffc9000092f708
[   62.413278] FS:  0000000000000000(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
[   62.413909] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.414368] CR2: 0000000000000010 CR3: 000000000ad7c003 CR4: 0000000000770ee0
[   62.414934] PKRU: 55555554
[   62.415159] note: kworker/u4:3[74] exited with irqs disabled
[   62.415642] ------------[ cut here ]------------
[   62.416012] WARNING: CPU: 1 PID: 74 at kernel/exit.c:814 do_exit+0xe8a/0x12b0
[   62.416580] Modules linked in:
[   62.416833] CPU: 1 PID: 74 Comm: kworker/u4:3 Tainted: G      D            6.3.0-rc3-kvm-e8d018dd #1
[   62.417546] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   62.418432] Workqueue: writeback wb_workfn (flush-7:0)
[   62.418861] RIP: 0010:do_exit+0xe8a/0x12b0
[   62.419197] Code: 00 65 01 05 b4 ba f0 7e e9 f4 fd ff ff e8 be 1e 1b 00 48 8b bb 98 09 00 00 31 f6 e8 30 b0 ff ff e9 74 fb ff ff e8 a6 1e 1b 00 <0f> 0b e9 3e f2 ff ff e8 9a 1e 1b 00 4c 89 ee bf 05 06 00 00 e8 bd
[   62.420652] RSP: 0018:ffffc9000092feb0 EFLAGS: 00010246
[   62.421072] RAX: 0000000000000000 RBX: ffff88800a02a340 RCX: 0000000000000001
[   62.421635] RDX: 0000000000000000 RSI: ffff88800a02a340 RDI: 0000000000000002
[   62.422195] RBP: ffffc9000092ff18 R08: 0000000000000000 R09: 0000000000000000
[   62.422758] R10: 34752f72656b726f R11: 776b203a65746f6e R12: 0000000000000000
[   62.423323] R13: 0000000000000009 R14: ffff88800a009900 R15: ffff8880093a1180
[   62.423902] FS:  0000000000000000(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
[   62.424539] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.425000] CR2: 0000000000000010 CR3: 000000000ad7c003 CR4: 0000000000770ee0
[   62.425568] PKRU: 55555554
[   62.425794] Call Trace:
[   62.426000]  <TASK>
[   62.426183]  ? write_comp_data+0x2f/0x90
[   62.426513]  make_task_dead+0x100/0x290
[   62.426832]  rewind_stack_and_make_dead+0x17/0x20
[   62.427227]  </TASK>
[   62.427414] irq event stamp: 122544
[   62.427715] hardirqs last  enabled at (122543): [<ffffffff821395dd>] get_random_u32+0x1dd/0x360
[   62.428409] hardirqs last disabled at (122544): [<ffffffff82f8d76e>] exc_page_fault+0x4e/0x3b0
[   62.429094] softirqs last  enabled at (114870): [<ffffffff82fb01a9>] __do_softirq+0x2d9/0x3c3
[   62.429771] softirqs last disabled at (114849): [<ffffffff81126724>] irq_exit_rcu+0xc4/0x100
[   62.430443] ---[ end trace 0000000000000000 ]---
"

I hope it's helpful.

Thanks!

---

If you don't need the following environment to reproduce the problem or if you
already have one, please ignore the following information.

How to reproduce:
git clone https://gitlab.com/xupengfe/repro_vm_env.git
cd repro_vm_env
tar -xvf repro_vm_env.tar.gz
cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v7.1.0
   // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65 v6.2-rc5 kernel
   // You could change the bzImage_xxx as you want
You could use below command to log in, there is no password for root.
ssh -p 10023 root@localhost

After login vm(virtual machine) successfully, you could transfer reproduced
binary to the vm by below way, and reproduce the problem in vm:
gcc -pthread -o repro repro.c
scp -P 10023 repro root@localhost:/root/

Get the bzImage for target kernel:
Please use target kconfig and copy it to kernel_src/.config
make olddefconfig
make -jx bzImage           //x should equal or less than cpu num your pc has

Fill the bzImage file into above start3.sh to load the target kernel in vm.


Tips:
If you already have qemu-system-x86_64, please ignore below info.
If you want to install qemu v7.1.0 version:
git clone https://github.com/qemu/qemu.git
cd qemu
git checkout -f v7.1.0
mkdir build
cd build
yum install -y ninja-build.x86_64
../configure --target-list=x86_64-softmmu --enable-kvm --enable-vnc --enable-gtk --enable-sdl
make
make install

Thanks!
BR.
