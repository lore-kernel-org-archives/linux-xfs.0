Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723CFC6FD1C
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Mar 2023 03:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjCVDfc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Mar 2023 23:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjCVDfZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Mar 2023 23:35:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0C15A1B1
        for <linux-xfs@vger.kernel.org>; Tue, 21 Mar 2023 20:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679456121; x=1710992121;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=coi981DGNSm/EYoJtc8hTq4gaiUaeM1DLyrIXqzPeHQ=;
  b=QoeEnliIBW9LGukNN0yNJpWQusIEhCbNADnikaDD+X/hYqTYkwAzUEVS
   WB2xEXA08g+sd0L83F/bOG4J8Q91hsnZLWzCNvDgtqn0Ymy33pz1LVswQ
   JpUDzNM67SVilkIMwJDP/XKCQagUfcsHKjrlihTb4q11bpPNyBh98+Hsw
   pMigN7PTdtBfmFbablLBhVtXjFf+dPWnYlUf56jat6v7hnbqyx8yzLFJ+
   h+wAdDj98eUa0izBJ2m4pihicOiiDNpwcUS2SNdeMdoNraqTOdbcI1HAP
   5Aivu74edXC13OqdE/rzbX8ru9LiQI+42b92NAd0e75TNxyvaU57jmwUY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="340654329"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="340654329"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 20:35:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="825225707"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="825225707"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 21 Mar 2023 20:35:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 20:35:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 20:35:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 20:35:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 20:35:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3nY0sCcSvJTmPqbuOcEJ9IhAXThOodgYc/l8z9TS/U8E9mVTZR5gEekcZPB+6XOWOdReMlbNbMIYahTv4DBD2+oq3WPY3mKK/aXtVppYoxL5oPUN4FWUvePeMcjlwGb2Wilbc5z/YLSImL4/AGRm7vxKfL55smqQi3OBYMyhv8GNPUHB8th8hFuvlMe+NrwffJyy34zEeeOKGWvGPWdNdsopgsVVAe9cG+itzrOp2r+Hek+H/JCF0DQ81OBZmK8xRLe5oAF9HVfwJziNUYOSMusmqIlPQxkBBGF2jh+T+WBWhSs9Z0EIqVBlhlwosKESl0UBCHAkW9Czu2qj9etfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nAWZf/GF62srRAWhLweNeLrYPeV9KShHqhtT1y3/uIg=;
 b=QFTz86be4NFkh5baZMcoBKR/BTf2GRNUMsgm1jifQs0M9f1pVyhwU0iPAAQPP7EEc885/lz+NsDn1DIfS+Iv7tjAv9OR6EHxqhs3FX7356p66+ROcSR0ncSNVoF6pnxBzwZfZs1GfiXg5peLqmuJ+RY1EVgpmzfIp4aVima9dYivuHmkIEu2ieNmIAPvsCfVQzBck+mArfo0xgaIlYEWVqKGoy0/+I3BBmUW7G+SAYcF6qLxt6Gx7XEIHjN990kkTC/UviK445Q7/p0UIEnTyH4Nvs5/3ippYSYVN9cSwljI/3Ss8Gov5ApXI65NgJFAjHv1T0xWwCu+Q8gbqlYTfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
 by CH3PR11MB8315.namprd11.prod.outlook.com (2603:10b6:610:17e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 03:35:16 +0000
Received: from PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239]) by PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239%8]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 03:35:16 +0000
Date:   Wed, 22 Mar 2023 11:36:40 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     <djwong@kernel.org>
CC:     <chandan.babu@oracle.com>, <dchinner@redhat.com>,
        <heng.su@intel.com>, <linux-xfs@vger.kernel.org>, <lkp@intel.com>
Subject: Re: [Syzkaller & bisect] There is "xfs_btree_lookup_get_block"
 general protection BUG in v6.3-rc3 kernel
Message-ID: <ZBp3yHJcwvxngxaq@xpf.sh.intel.com>
References: <ZBlLvZlKauGmNUOW@xpf.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZBlLvZlKauGmNUOW@xpf.sh.intel.com>
X-ClientProxiedBy: SG2PR06CA0230.apcprd06.prod.outlook.com
 (2603:1096:4:ac::14) To PH0PR11MB4839.namprd11.prod.outlook.com
 (2603:10b6:510:42::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4839:EE_|CH3PR11MB8315:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e709771-10d3-4359-6693-08db2a8673aa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HTIUh/rdHVSmiT0i9rtNMxj0hnbsJ8oRXCHc8aiMGFw1j8RWsYCZsqV4DqnXpHxRddpWDGmW2T3TGs4x+vOtc5aeIN+8j42rxFE59joW+KPCrFE3/VLQlWJlo27VSrA28I30w9QUq//p9vZy6CYfLfdz04Zc30pSzSkBM/kbQnbbMVECaimkGOdutJ93Y9Li/Ufi3dI/mlkWbuHjznwl4AwKgwvpSRmHCoYo2nbnfdxbfl9UxEwTcqeDX3MxaEQxP/lIEcexxAiNzF/KjJYigAxm8vhnpChweskLnFY3EH1q0HTUvcTcoLX3DYQIFUzLrS+1GLrb1qGGovDl6bX5SRUIAohed8ZDWsNjy9NbZo09/m52qhxauoD7Sa6az5vZq89OMnVnfpWeMPgqW6mWylqdNRTWoLn9swx2iiwWOaZMKsY911P6VZE2Bl8p9W+W59c8fXyTN44QFAZE3aSs8BkIGS7+fuvrk0gpVw7i/1uiBQ9fQ+HGCXhO9VCcRk4g+7MSku2A7M5gjTo5iAHanP0LMjrNfZpTJt3rOeTVMPMUycp2w5MP2eRawlxWL2oIla7LjXNljip1xq0xF/2derXMohCLX7wXYWoMpY+bIGlWBBfs+e2rLOV3E5zOnNTaIhpePwS2GGHm7a9lhtBMaohRdaXtefYr9PueSVwR1Ps2pQkajCL1BNvTkpg671p3ZiYOLT94zLzIBSY6xxPgEFnv8TPTlO6tWQgnWl/WCTTNCpB9enz1u6FlENBowdCJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4839.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199018)(86362001)(478600001)(83380400001)(45080400002)(41300700001)(6512007)(26005)(66946007)(66476007)(4326008)(6916009)(66556008)(316002)(6666004)(8676002)(107886003)(6486002)(186003)(53546011)(966005)(6506007)(8936002)(44832011)(2906002)(82960400001)(5660300002)(38100700002)(30864003)(99710200001)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BO8bsbdUKT+0kf4Y51Vi1QwyPFTi8vVx0T3jSOJCe+Fe7Kv4WmjF3DzMgNpY?=
 =?us-ascii?Q?nDJhWIXZ3oxUY4Ignl3yzsM4xcAbBsdj7iDr7/y/YU/mVCe8X2o+lI0Cok7N?=
 =?us-ascii?Q?di4G7dIDFQJKKAV8tslGaQyGbhohd6MN9bceLkGLW1Px5MyIS4LD4MrJ8yoU?=
 =?us-ascii?Q?n1hnh4ttNCkiZzKrNgKMwyMMruzUAbqGJzemtG0qZZKBGKBhtBdoiKZ8fZj8?=
 =?us-ascii?Q?hxUvZ6qqn4xiGdePSsFnwIGaL1c2f71StRPkleGr6WSftTdJ9VoY5tBVQ+e2?=
 =?us-ascii?Q?l39zUTT/+YQJanMhG7LnSPkoMt85280aTgS0yKvTbuD/rJ7pYaBaRS5QediC?=
 =?us-ascii?Q?L1v9fqeieHbf8APGJJBwNW2qIz5hiEhZ1I2wiB2lHvzjTf9Z55XJw4fz8zD7?=
 =?us-ascii?Q?duDGEr+/bmzn9UgNG0JBPp+C0MX8vzHE2IgUc5I9uqF0G2yVIGuCRz3WndXx?=
 =?us-ascii?Q?HEU8nM2++dvJiOKlxMlXpY/cR2VOWN/TFv/Fc/WCi0Sggksvc8EGEnqizQAo?=
 =?us-ascii?Q?A4GBrI464rliSrZVtlCM3s4a1ybMFyoVAJQi2CKJLGMP3c//c8eqviQDDOL8?=
 =?us-ascii?Q?I3WDyaUYi7A1ohFbSUIA8bxofjUa3YK7//fvJHiptImNUDuppYo1AGzUGg1r?=
 =?us-ascii?Q?s8I8N/tlG5ZwrAFkpeCJEjkUPmWwapFPFglXZpYHxgOsbu2kATtpGebm/ZdC?=
 =?us-ascii?Q?NZu26mj1e+tDouVsq6vIdDb8YIp9YW/jno4u3GZhpkV7iVGwCMcRUkJUZ16+?=
 =?us-ascii?Q?6Opj2LANtN9IYX2NAQu3fkLL9oWg54fdte+ompEF5jxK81GzzT/eVkz2u+Fy?=
 =?us-ascii?Q?cyuAcLSQ59Qg1cQZgdps0hTdoUh9FRhqpFzjp/3H+w/foiQmzTPs61JvT2dS?=
 =?us-ascii?Q?yhsVFmSuovXnIxsqxQvDYNYE7hKF0iVA81y1NF37gaDTrHC+jyk9FWdX/s/u?=
 =?us-ascii?Q?CtabBq2HfHeavhkTR9ZGxiYhPaajwxnr5Ad/xSAZCRxqq0js+0J5Oja3HaDI?=
 =?us-ascii?Q?XFnI5a7+gTceRwJNTq8eFcLA5MYnn67qMiNlJrQ9w5eWbcJirujlqDxK7BKu?=
 =?us-ascii?Q?0Jp2zvjN76yw2Ln6LoMXS28U9iRb//Dc+vpoFQlceQFM6KuT/FoE2n2jh6Yr?=
 =?us-ascii?Q?kvNLbvwKbevtWx9DpckaL+yRcc5cmBXEST4kIzwdoJ1USz504LAQBZjGEKeo?=
 =?us-ascii?Q?xZgex5nWqd6EUSspGzLuTRQi9bNrQ4nu28pYdsfXGVfvDK1HYIUs3Tptyn7Z?=
 =?us-ascii?Q?JXy773UjEC4eDpsUgJrgzwxbimvVZfx8SP1O6cumGOhxPBr16P6IYxD06YQn?=
 =?us-ascii?Q?0TEfwVqdOC8T2FqBnCjnGhMOdQUHEhNFE3NJYM2bb0WtHGLnB+71F60wBGNn?=
 =?us-ascii?Q?9P1jP4gw7xPGFJGcXPi7dhmBjXtmigKCLmcsptCXfwINRSpzjixpqrMUS0N9?=
 =?us-ascii?Q?woiQ39HRRbs5Yrl/7PJ3RIzonmTX0qrQoDFuobv4fXgi2zHX+4xzgUjVBV8d?=
 =?us-ascii?Q?9zn10vGvVE1qfR1ykpIUBNGp5sEG9oDlAVJbC8mbW7s2riHSOj1wdhA7v2wk?=
 =?us-ascii?Q?4eC0snZtoIKQBYnEfZqBAIG8kum2HB9NeASTuWhd9kCudGiHh799PwVb381I?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e709771-10d3-4359-6693-08db2a8673aa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4839.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 03:35:15.9476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TF1TQpu+0MfC5Bv6BXtOXLmn61GdvnmTnt9kdaD8iXcr/YYP/LrktoK93IFJMUWQ0QpEhBoAXfDDzHF/HxyMiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8315
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Updated more info as follow:
vm machine info: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/machineInfo0
More RIP and best guess info in report0 from syzkaller: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/report0
repro.report: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/repro.report
repro.stas: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/repro.stats

Thanks for any suggestion if I missed something info.

Thanks!

On 2023-03-21 at 14:16:29 +0800, Pengfei Xu wrote:
> Hi Darrick J. Wong and xfs experts,
> 
> Greeting!
> 
> Platform: x86 platforms
> There is "xfs_btree_lookup_get_block" general protection BUG in v6.3-rc3 kernel.
> 
> All detailed info: https://github.com/xupengfe/syzkaller_logs/tree/main/230321_082343_xfs_btree_lookup_get_block
> Reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/repro.c
> Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/kconfig_origin
> v6.3-rc3 issue log: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/e8d018dd0257f744ca50a729e3d042cf2ec9da65_dmesg.log
> Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/bisect_info.log
> 
> Bisected and found the bad commit:
> "
> 7993f1a431bc5271369d359941485a9340658ac3
> xfs: only run COW extent recovery when there are no live extents
> "
> It's just suspected commit, because reverted the above commit on top of
> v6.3-rc3 and made kernel failed, could not double confirm for this issue's
> verification with reverted kernel.
> 
> "
> [   29.020016] XFS (loop3): Error -5 reserving per-AG metadata reserve pool.
> [   29.022919] BUG: kernel NULL pointer dereference, address: 000000000000022b
> [   29.023777] #PF: supervisor read access in kernel mode
> [   29.024413] #PF: error_code(0x0000) - not-present page
> [   29.025081] PGD 12947067 P4D 12947067 PUD 12976067 PMD 0
> [   29.025825] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [   29.026465] CPU: 0 PID: 544 Comm: repro Not tainted 6.3.0-rc3-e8d018dd0257+ #1
> [   29.026826] XFS (loop5): Starting recovery (logdev: internal)
> [   29.027468] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> [   29.029009] XFS (loop5): Metadata corruption detected at xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
> [   29.029843] RIP: 0010:xfs_btree_lookup_get_block+0xc4/0x300
> [   29.031365] XFS (loop5): Unmount and run xfs_repair
> [   29.032089] Code: ff ff 31 ff 41 89 c7 89 c6 e8 48 3d 8a ff 45 85 ff 0f 85 1d 01 00 00 e8 5a 3b 8a ff 4c 8b 75 c0 4d 85 f6 74 37 e8 4c 3b 8a ff <49> 8b 96 28 02 00 00 48 8b 4d c8 48 8b 12 48 89 cf 48 89 4d b0 48
> [   29.032779] XFS (loop5): Failed to recover leftover CoW staging extents, err -117.
> [   29.035256] RSP: 0018:ffffc9000108b910 EFLAGS: 00010246
> [   29.035267] RAX: 0000000000000000 RBX: ffff888013f10000 RCX: ffffffff81a32768
> [   29.036298] XFS (loop5): Filesystem has been shut down due to log error (0x2).
> [   29.037030] RDX: 0000000000000000 RSI: ffff888013eba340 RDI: 0000000000000002
> [   29.037994] XFS (loop5): Please unmount the filesystem and rectify the problem(s).
> [   29.038973] RBP: ffffc9000108b968 R08: ffffc9000108bb88 R09: ffff888013f10000
> [   29.038982] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000007
> [   29.038989] R13: ffffc9000108b9a8 R14: 0000000000000003 R15: 0000000000000000
> [   29.038997] FS:  00007f44ba73a740(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> [   29.041082] XFS (loop7): Starting recovery (logdev: internal)
> [   29.041985] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   29.043907] XFS (loop7): Metadata corruption detected at xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
> [   29.043955] CR2: 000000000000022b CR3: 000000000e56e003 CR4: 0000000000770ef0
> [   29.045085] XFS (loop7): Unmount and run xfs_repair
> [   29.045870] PKRU: 55555554
> [   29.046689] XFS (loop7): Failed to recover leftover CoW staging extents, err -117.
> [   29.048110] Call Trace:
> [   29.049079] XFS (loop7): Filesystem has been shut down due to log error (0x2).
> [   29.049753]  <TASK>
> [   29.050160] XFS (loop7): Please unmount the filesystem and rectify the problem(s).
> [   29.051195]  xfs_btree_lookup+0xfe/0x800
> [   29.053556] XFS (loop1): Metadata corruption detected at xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
> [   29.053882]  ? __this_cpu_preempt_check+0x20/0x30
> [   29.054487] XFS (loop1): Unmount and run xfs_repair
> [   29.055921]  ? __pfx_xfs_refcount_recover_extent+0x10/0x10
> [   29.056575] XFS (loop1): Failed to recover leftover CoW staging extents, err -117.
> [   29.057249]  ? __pfx_xfs_refcount_recover_extent+0x10/0x10
> [   29.057993] XFS (loop1): Filesystem has been shut down due to log error (0x2).
> [   29.059020]  xfs_btree_simple_query_range+0x54/0x280
> [   29.059038]  ? write_comp_data+0x2f/0x90
> [   29.059784] XFS (loop1): Please unmount the filesystem and rectify the problem(s).
> [   29.060778]  ? __pfx_xfs_refcount_recover_extent+0x10/0x10
> [   29.062080] XFS (loop4): Metadata corruption detected at xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
> [   29.063021]  xfs_btree_query_range+0x18a/0x1a0
> [   29.063773] XFS (loop4): Unmount and run xfs_repair
> [   29.065266]  ? xfs_refcountbt_init_common+0x3b/0x90
> [   29.065891] XFS (loop4): Failed to recover leftover CoW staging extents, err -117.
> [   29.066560]  xfs_refcount_recover_cow_leftovers+0x18c/0x4a0
> [   29.066583]  ? xfs_perag_grab+0x143/0x340
> [   29.067266] XFS (loop4): Filesystem has been shut down due to log error (0x2).
> [   29.068299]  xfs_reflink_recover_cow+0x79/0xf0
> [   29.069063] XFS (loop4): Please unmount the filesystem and rectify the problem(s).
> [   29.069623]  xlog_recover_finish+0x136/0x420
> [   29.071179] XFS (loop7): Ending recovery (logdev: internal)
> [   29.071227]  ? queue_delayed_work_on+0x9f/0xf0
> [   29.072328] XFS (loop7): Error -5 reserving per-AG metadata reserve pool.
> [   29.072876]  xfs_log_mount_finish+0x187/0x1d0
> [   29.073692] XFS (loop1): Ending recovery (logdev: internal)
> [   29.074252]  xfs_mountfs+0x76e/0xce0
> [   29.074271]  xfs_fs_fill_super+0x7aa/0xdc0
> [   29.075574] XFS (loop1): Error -5 reserving per-AG metadata reserve pool.
> [   29.075809]  get_tree_bdev+0x24b/0x350
> [   29.076634] XFS (loop5): Ending recovery (logdev: internal)
> [   29.077084]  ? __pfx_xfs_fs_fill_super+0x10/0x10
> [   29.077676] XFS (loop5): Error -5 reserving per-AG metadata reserve pool.
> [   29.078560]  xfs_fs_get_tree+0x25/0x30
> [   29.078581]  vfs_get_tree+0x3b/0x140
> [   29.079464] XFS (loop4): Ending recovery (logdev: internal)
> [   29.079871]  path_mount+0x769/0x10f0
> [   29.080533] XFS (loop4): Error -5 reserving per-AG metadata reserve pool.
> [   29.081442]  ? write_comp_data+0x2f/0x90
> [   29.085330]  do_mount+0xaf/0xd0
> [   29.085811] XFS (loop2): Starting recovery (logdev: internal)
> [   29.085825]  __x64_sys_mount+0x14b/0x160
> [   29.087213]  do_syscall_64+0x3b/0x90
> [   29.087534] XFS (loop2): Metadata corruption detected at xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
> [   29.087758]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [   29.089249] XFS (loop2): Unmount and run xfs_repair
> [   29.089936] RIP: 0033:0x7f44ba8673ae
> [   29.090639] XFS (loop2): Failed to recover leftover CoW staging extents, err -117.
> [   29.091112] Code: 48 8b 0d f5 8a 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c2 8a 0c 00 f7 d8 64 89 01 48
> [   29.092123] XFS (loop2): Filesystem has been shut down due to log error (0x2).
> [   29.094617] RSP: 002b:00007fffeaff1b78 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> [   29.094632] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f44ba8673ae
> [   29.094640] RDX: 0000000020009580 RSI: 00000000200095c0 RDI: 00007fffeaff1cb0
> [   29.095630] XFS (loop2): Please unmount the filesystem and rectify the problem(s).
> [   29.096664] RBP: 00007fffeaff1d40 R08: 00007fffeaff1bb0 R09: 0000000000000000
> [   29.099193] XFS (loop2): Ending recovery (logdev: internal)
> [   29.099660] R10: 0000000000000800 R11: 0000000000000206 R12: 0000000000401260
> [   29.100702] XFS (loop2): Error -5 reserving per-AG metadata reserve pool.
> [   29.101426] R13: 00007fffeaff1e80 R14: 0000000000000000 R15: 0000000000000000
> [   29.104290]  </TASK>
> [   29.104623] Modules linked in:
> [   29.105081] CR2: 000000000000022b
> [   29.105560] ---[ end trace 0000000000000000 ]---
> [   29.106207] RIP: 0010:xfs_btree_lookup_get_block+0xc4/0x300
> [   29.106985] Code: ff ff 31 ff 41 89 c7 89 c6 e8 48 3d 8a ff 45 85 ff 0f 85 1d 01 00 00 e8 5a 3b 8a ff 4c 8b 75 c0 4d 85 f6 74 37 e8 4c 3b 8a ff <49> 8b 96 28 02 00 00 48 8b 4d c8 48 8b 12 48 89 cf 48 89 4d b0 48
> [   29.109472] RSP: 0018:ffffc9000108b910 EFLAGS: 00010246
> [   29.110190] RAX: 0000000000000000 RBX: ffff888013f10000 RCX: ffffffff81a32768
> [   29.111153] RDX: 0000000000000000 RSI: ffff888013eba340 RDI: 0000000000000002
> [   29.112114] RBP: ffffc9000108b968 R08: ffffc9000108bb88 R09: ffff888013f10000
> [   29.113072] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000007
> [   29.114030] R13: ffffc9000108b9a8 R14: 0000000000000003 R15: 0000000000000000
> [   29.114989] FS:  00007f44ba73a740(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> [   29.116069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   29.116860] CR2: 000000000000022b CR3: 000000000e56e003 CR4: 0000000000770ef0
> [   29.117831] PKRU: 55555554
> [   29.118220] note: repro[544] exited with irqs disabled
> [   29.452491] loop0: detected capacity change from 0 to 32768
> "
> 
> I see this similar issue in syzbot link:
> https://syzkaller.appspot.com/bug?id=e2907149c69cbccae0842eb502b8af4f6fac52a0
> But it didn't provide the bisect commit info due to bisect failure.
> 
> I hope above info is helpful.
> 
> Thanks!
> 
> ---
> 
> If you don't need the following environment to reproduce the problem or if you
> already have one, please ignore the following information.
> 
> How to reproduce:
> git clone https://gitlab.com/xupengfe/repro_vm_env.git
> cd repro_vm_env
> tar -xvf repro_vm_env.tar.gz
> cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v7.1.0
>    // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65 v6.2-rc5 kernel
>    // You could change the bzImage_xxx as you want
> You could use below command to log in, there is no password for root.
> ssh -p 10023 root@localhost
> 
> After login vm(virtual machine) successfully, you could transfer reproduced
> binary to the vm by below way, and reproduce the problem in vm:
> gcc -pthread -o repro repro.c
> scp -P 10023 repro root@localhost:/root/
> 
> Get the bzImage for target kernel:
> Please use target kconfig and copy it to kernel_src/.config
> make olddefconfig
> make -jx bzImage           //x should equal or less than cpu num your pc has
> 
> Fill the bzImage file into above start3.sh to load the target kernel in vm.
> 
> 
> Tips:
> If you already have qemu-system-x86_64, please ignore below info.
> If you want to install qemu v7.1.0 version:
> git clone https://github.com/qemu/qemu.git
> cd qemu
> git checkout -f v7.1.0
> mkdir build
> cd build
> yum install -y ninja-build.x86_64
> ../configure --target-list=x86_64-softmmu --enable-kvm --enable-vnc --enable-gtk --enable-sdl
> make
> make install
> 
> Thanks!
> BR.
