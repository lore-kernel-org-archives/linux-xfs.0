Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923E3C6FD1C
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Mar 2023 03:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjCVDTk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Mar 2023 23:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjCVDTi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Mar 2023 23:19:38 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B56497FD
        for <linux-xfs@vger.kernel.org>; Tue, 21 Mar 2023 20:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679455176; x=1710991176;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=t1kxlpeahnxVCHbaihymR3NBmEgd+ufsleY9P/Vb4RQ=;
  b=OliSLnsWw+1PFld1fKEFAnhGFpbBRwd4kWqaj1bO2wK5HQhyOGjfAwCh
   I/BgQn26/UjdPhoyKsyBIszwt8LvCVoKPMN6IbArO2nS+IJgEnrVxbqZ8
   Fp09rhD51BJ3ub7kLxo7Ok53LVrGf+IqocaEZaGvS9wbRu2ACygCJduj5
   N3bRPxGna7k0QDVcZ3DZJk1m36iEaGtKUT6dyYOKuXuD7zPmNAdkj5UVn
   IITb/0aDG9IiOrHc4AHGU+9z+wZ3wybIli5ZT1IlwzBVfhS9kgfAVPvc3
   tptDOr61+47jyZg2wJxMYQ+J1pOhV2RaorYaiuQRM0VoGNLmHUQZC7dgS
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="339157368"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="339157368"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 20:19:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="855967929"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="855967929"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 21 Mar 2023 20:19:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 20:19:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 20:19:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 20:19:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 20:19:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSdCLGuPr+hsgSrHd2B2O6SLL0C3AyOcj+Fw1/ZQCkQpXNXBX78LDqWtArVnDL7LEl934ShzD0F3lBgTZpeWK9drkwK08/W89ZlDcC8H4r4a3KCdabwd3XZel6o18nRL6oQC7bhBZ+B+TVJVVkW9PO88S+0bl30xNMLHIEr1hxL4f4f27w7+5jirgrwQYyWK+gXB8yoBEhm/oodCMFGHtLwfU5+L4DJE5mRwAT52iLY867VrlGddIpN5SsWzxpYCIe0xZ4hGApTJjGfviODWwo9ntCD+7X+4FZR/CmYc1qjz3+yO8yElCxzRk2v/EOqoGE6SdmWyt7Kq51P+vbSnMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IvTT6FDVBER4GCfBw5yg/NZICfCo3EWq0WB7ypmW2Xw=;
 b=EaT4ONEbKPzM3KzOgasqgJ/teiVGp0tOsTx+xATO5Ai0Rd7xjSDqHdVDXlxIU7rRYpU/4/HZrMTK4jYYAuemiNHe9bquYl0hplyC4xzfozL22PNzFFP81r+u3EFkuuXVX1ai/srzMqBa5fa+TGat1QXNWqjMgIjRC9VK1znC1j0tqTK5FbI/3PUeYlPxLRY400tQ5wwnaSWbW0UG9CEH3/DmMrcK+lktAXYMHqznWrB0BTuPJDkBp6BjtdEMVzLiip1b+DeSlLLMPQqrsRTPWPztm+v807nryYIek3TWjSkNkaKA304GgqvMYrC519DZ5bfhU/s0KAHvdMArCAwJfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
 by PH7PR11MB8252.namprd11.prod.outlook.com (2603:10b6:510:1aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 03:19:32 +0000
Received: from PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239]) by PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239%8]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 03:19:32 +0000
Date:   Wed, 22 Mar 2023 11:20:55 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     <dchinner@redhat.com>, <bfoster@redhat.com>, <heng.su@intel.com>,
        <linux-xfs@vger.kernel.org>, <lkp@intel.com>
Subject: Re: [Syzkaller & bisect] There is BUG: unable to handle kernel NULL
 pointer dereference in xfs_filestream_select_ag in v6.3-rc3
Message-ID: <ZBp0F5pPwI9IbgUl@xpf.sh.intel.com>
References: <ZBgCH/8EguhJkwPI@xpf.sh.intel.com>
 <20230321204638.GB11376@frogsfrogsfrogs>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230321204638.GB11376@frogsfrogsfrogs>
X-ClientProxiedBy: SG2PR03CA0106.apcprd03.prod.outlook.com
 (2603:1096:4:7c::34) To PH0PR11MB4839.namprd11.prod.outlook.com
 (2603:10b6:510:42::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4839:EE_|PH7PR11MB8252:EE_
X-MS-Office365-Filtering-Correlation-Id: c08e0c62-74f0-4cd7-e610-08db2a84412e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L+j8TFSuYc1ReXS39nJeFl9Gb31unoRaq1zS4Szbtedu0vVvGCJ15Hmj6C1Ei6ybYi+UtLvqH1DZ6W/qzItf1zlJvpPJjTylIWvSA/Gg4IVIHtuPsppsIVVLcPSyyFa2oD+7dJhmLyKgojxz1qNP92UyjcA/3mySoFCoZiFanvywWHkBjKz0qc8EqrY5n4Ttn0ENrBF5yc/ySByQSWt3JIGX1nlOWdmqO7TnCFvxHF1YZsbjJcTq+qK1rAcBEuEjzmzrO4uOkuWDYbda8cH6UjtQh01k058QAqVkK+AoNlmuN79sXhq5XNOa0uW00L6O2b+3Y0zO1ZPjAZixvP7AWvWqL9ftvker7qXvQtBHkKROg6CPml8H1yPQuJXS0tKrsMubO+qlHW+bEkcCcTS5LiHv1cXd0Cg25wH558DFE7+WfFQ59CsmlHIdyjYzsPiaXUIwzJDzcrZNzGRrOf0zWNCRC5iU6uCAjddLekXNz5j0yPPGR+MBr1VXPJw4wt5ANKFPOOCVRZo5KxWboy/XjveDqJxo8hoLIP5joulNaH0jxFpt+SAZEPZr26mSd9WmI9OgM9S26tHp+Hw4SqZ3sp2aD+4rqTgCeyQLzCy4Y4bPmI7lOa3CRq/J7gXhspa/cslf7uLGKWUMm/Vald4SZ6rbzMeOgWhkB8NsJD1rSRSXsxJngLilbQYjybWb93lEdp8AdNpZn45tMPJ3kK1XdOKq/BR8UbUHnSvEi9Pd0DU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4839.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(316002)(83380400001)(2906002)(66946007)(66476007)(66556008)(8676002)(5660300002)(6916009)(4326008)(8936002)(44832011)(30864003)(41300700001)(6666004)(6506007)(6512007)(186003)(53546011)(26005)(107886003)(86362001)(45080400002)(82960400001)(6486002)(966005)(38100700002)(478600001)(505234007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fcYVX/aUdPqHOK0ctB5J/wdHVTJQzAHu3cZqgK0n2yXSFOMSUBww0TRT+Fgy?=
 =?us-ascii?Q?KkbAb4J+mH2XU3WR7BdH/b4bmofuM9MC7vyaxtHtDog5Di5RFKnRVY5wpJdR?=
 =?us-ascii?Q?mOPmzUFeKGpLw8+6U5/V7djFabkd2qdeIrQj7HhQAqa6zaYuGYaZzj1U87Ff?=
 =?us-ascii?Q?9ZQObwIVJDD4xEiM36PB7+km/4EUbFAolimfDSw4NpxnNm/UK62cVB5ntDxb?=
 =?us-ascii?Q?bI80kuLLGsrYU+H1x/qC3LEtpl379wJS7yOiwUNDrNdG8a7iJaXT6m2IUSUQ?=
 =?us-ascii?Q?o+wBi4itt1zs6tTrbh00ixHsOiIfFHWMxfGnUm3t7M1v6XzuSThX4Fy9m5Xw?=
 =?us-ascii?Q?GwQI/4lCCStuiiGxQwO2yU265LAtpiwHndirjuTAsyelZy1wD/vRplT6hwjj?=
 =?us-ascii?Q?Wkxr2Yls2DSHN8Ii7huPSq2XwNnOYIGdzk2Lg7eaN7/2lef035GKbu2lyRK3?=
 =?us-ascii?Q?eB1eShf6M1+bAFqi0bS+QDRSRuJuBtmFET5H6Zwbp8oqNrDIHYLV9SdddY5N?=
 =?us-ascii?Q?yAgOdE/+AqzHtguzK3td8rj4qT1MhYdNVCX2mJGN8GOBYHzHz1a9CA5tpa+w?=
 =?us-ascii?Q?jR6Z4r3iW5M7BBX67z3Xk62pyNENAufgnkuKkKgYERnRzHBCgA1ql3wW6HdQ?=
 =?us-ascii?Q?aBasSoTy8BrStylVWns1aySqOOfQn2mjSiSwpuM9wEWQMs3heprRtIPk7wxH?=
 =?us-ascii?Q?9l4KYp3x03eJA6BZhdf8gue7c0CR+CnihpJKNFIFRuBVEcDecVXMpbthpKXZ?=
 =?us-ascii?Q?9IywkoLl5th/VWGzzlCjRdX/wvduTw4+PKBuQ1DEpLnrz7fFhNtIhPUVuSLP?=
 =?us-ascii?Q?2h1nyUP+KiGUniWTcFiTIVwuy6pBSnUVsf3sOIvTOrIg+/iHlkrMJJhzDVlG?=
 =?us-ascii?Q?fEWMSlr79FNPyO2dyz+lPn+/NNEZ3N1pB2+Xdi+q0dk3W7U0MyP94Y+nBIkG?=
 =?us-ascii?Q?voO2zoDwH+UqFbbtgoqHEGxIkF1oSmBJnomOuPy4eS2mvc21ofmCoKXmySOJ?=
 =?us-ascii?Q?omSgoMmRPdITkGmnlJ+C5dS+XDL6ARMV3+TxbavYfPbWStR2VFT4dHADidit?=
 =?us-ascii?Q?h060Vgq2WwacoELTQpD+CnNaDkCeoSmRB6KpL41YyFYkh4z00WnH9+A9Kv4S?=
 =?us-ascii?Q?yiZmwbi2GHSMfQdgDJY4i0ebTuiO+waOStllcvKgoJDJ7MknZJcpVLzcbCB9?=
 =?us-ascii?Q?+iHlYtY+Ui9//dCoXy7cObYrARE2/CW0CxKRu8bfdZ734NzLkrkwLRlTG52g?=
 =?us-ascii?Q?poXVZYOwYNp04LGjr529dvkppOvuhXbpvom37Voht9S+Dl+W4CpN1O+D3Urj?=
 =?us-ascii?Q?KRYU0/0bW4Ia1CkmLb0RT7C0CRZKv01XumQN1E/HjlJQyiCBNSKqL8sseDKx?=
 =?us-ascii?Q?zJI8MlFHDHuNJ706iYxN23iMDxrBb2P/gDOOIYjGXDY5q0FY+3ouy50Pl87w?=
 =?us-ascii?Q?fFwgk6SXeDQZgYy7BpK9/gf5b+7vqlKfm0IHnPaAIwfact+1FdgwHkvFsGkt?=
 =?us-ascii?Q?urkWVxdfXWWzf4QFT/iUX9I6WlkoOsNufy8W3RXU6JhEpPUynWu+WQFBCrkq?=
 =?us-ascii?Q?BS16Nq/Aac1dXe7UFX1XW+mv91izQ2C4PJ9N4CMAHIXqhrVMfEYl8kZJq4xo?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c08e0c62-74f0-4cd7-e610-08db2a84412e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4839.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 03:19:32.2729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +i5mE8r0MdB8KxG2OwaUhslZc57uXx2Gy+jNlxEwjXD2tD+NdCgiaZq+FmLa+owc+ZNsubrznIJrNQgeplyXAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8252
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick J. Wong,

On 2023-03-21 at 13:46:38 -0700, Darrick J. Wong wrote:
> On Mon, Mar 20, 2023 at 02:50:07PM +0800, Pengfei Xu wrote:
> > Hi Dave Chinner and xfs experts,
> > 
> > Greeting!
> > 
> > There is BUG: unable to handle kernel NULL pointer dereference in
> > xfs_filestream_select_ag in v6.3-rc3:
> > 
> > All detailed info: https://github.com/xupengfe/syzkaller_logs/tree/main/230319_210525_xfs_filestream_select_ag
> > Reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/repro.c
> 
> How the hell am I supposed to extract the fuzzed disk image for
> analysis?
> 
> Current Google syzbot provides a lot more information for analysis.  Why
> don't you go triage some of their reports instead of spraying more crap
> at the XFS list?
> 
Ah, thanks a lot for your suggestion!
Next time I should add more analysis as follow from syzkaller to all problem
reports.

Updated more info as follow,
More detailed analysis from syzkaller report0: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/report0
repor.stats: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/repro.stats
vm machine info: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/machineInfo0

I newly added repro.report: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/repro.report
"
00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
XFS (loop0): metadata I/O error in "xfs_read_agf+0xd0/0x2c0" at daddr 0x8001 len 1 error 74
XFS (loop0): page discard on page 00000000b8174cbd, inode 0x46, pos 0.
BUG: kernel NULL pointer dereference, address: 0000000000000010
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 0 P4D 0 
Oops: 0002 [#1] PREEMPT SMP NOPTI
CPU: 1 PID: 34 Comm: kworker/u4:2 Not tainted 6.3.0-rc2-intel-next-38f821ff82e9+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Workqueue: writeback wb_workfn (flush-7:0)
RIP: 0010:arch_atomic_inc arch/x86/include/asm/atomic.h:95 [inline]
RIP: 0010:atomic_inc include/linux/atomic/atomic-instrumented.h:191 [inline]
RIP: 0010:xfs_filestream_create_association fs/xfs/xfs_filestream.c:321 [inline]
RIP: 0010:xfs_filestream_select_ag+0x5d5/0xce0 fs/xfs/xfs_filestream.c:372
Code: 80 ff 49 89 5d 18 be 08 00 00 00 bf 20 00 00 00 e8 80 f9 03 00 48 89 c3 48 85 c0 0f 84 3a 05 00 00 e8 9f 8a 80 ff 49 8b 45 18 <f0> ff 40 10 49 8b 45 18 48 8b 75 b8 48 89 da 48 89 43 18 48 8b 45
RSP: 0018:ffffc900001274c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88800dbeae40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88800791a340 RDI: 0000000000000002
RBP: ffffc90000127548 R08: ffffc90000127400 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc90000127588 R14: 0000000000000001 R15: ffffc90000127708
FS:  0000000000000000(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 000000000b85c002 CR4: 0000000000f70ee0
PKRU: 55555554
Call Trace:
 <TASK>
 xfs_bmap_btalloc_filestreams fs/xfs/libxfs/xfs_bmap.c:3558 [inline]
 xfs_bmap_btalloc+0x706/0xb90 fs/xfs/libxfs/xfs_bmap.c:3672
 xfs_bmap_alloc_userdata fs/xfs/libxfs/xfs_bmap.c:4046 [inline]
 xfs_bmapi_allocate+0x25b/0x5e0 fs/xfs/libxfs/xfs_bmap.c:4089
 xfs_bmapi_convert_delalloc+0x335/0x6c0 fs/xfs/libxfs/xfs_bmap.c:4554
 xfs_convert_blocks fs/xfs/xfs_aops.c:266 [inline]
 xfs_map_blocks+0x2ff/0x8a0 fs/xfs/xfs_aops.c:389
 iomap_writepage_map fs/iomap/buffered-io.c:1641 [inline]
 iomap_do_writepage+0x43f/0x1070 fs/iomap/buffered-io.c:1803
 write_cache_pages+0x2b8/0x8a0 mm/page-writeback.c:2473
 iomap_writepages+0x3e/0x80 fs/iomap/buffered-io.c:1820
 xfs_vm_writepages+0x97/0xe0 fs/xfs/xfs_aops.c:513
 do_writepages+0x10f/0x240 mm/page-writeback.c:2551
 __writeback_single_inode+0x9f/0xb20 fs/fs-writeback.c:1600
 writeback_sb_inodes+0x301/0x8b0 fs/fs-writeback.c:1891
 wb_writeback+0x18b/0x7c0 fs/fs-writeback.c:2065
 wb_do_writeback fs/fs-writeback.c:2208 [inline]
 wb_workfn+0xc0/0xad0 fs/fs-writeback.c:2248
 process_one_work+0x3b1/0x9e0 kernel/workqueue.c:2390
 worker_thread+0x52/0x660 kernel/workqueue.c:2537
 kthread+0x161/0x1a0 kernel/kthread.c:376
 ret_from_fork+0x29/0x50 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
CR2: 0000000000000010
---[ end trace 0000000000000000 ]---
RIP: 0010:arch_atomic_inc arch/x86/include/asm/atomic.h:95 [inline]
RIP: 0010:atomic_inc include/linux/atomic/atomic-instrumented.h:191 [inline]
RIP: 0010:xfs_filestream_create_association fs/xfs/xfs_filestream.c:321 [inline]
RIP: 0010:xfs_filestream_select_ag+0x5d5/0xce0 fs/xfs/xfs_filestream.c:372
Code: 80 ff 49 89 5d 18 be 08 00 00 00 bf 20 00 00 00 e8 80 f9 03 00 48 89 c3 48 85 c0 0f 84 3a 05 00 00 e8 9f 8a 80 ff 49 8b 45 18 <f0> ff 40 10 49 8b 45 18 48 8b 75 b8 48 89 da 48 89 43 18 48 8b 45
RSP: 0018:ffffc900001274c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88800dbeae40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88800791a340 RDI: 0000000000000002
RBP: ffffc90000127548 R08: ffffc90000127400 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc90000127588 R14: 0000000000000001 R15: ffffc90000127708
FS:  0000000000000000(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 000000000b85c002 CR4: 0000000000f70ee0
PKRU: 55555554
note: kworker/u4:2[34] exited with irqs disabled
------------[ cut here ]------------
WARNING: CPU: 1 PID: 34 at kernel/exit.c:814 do_exit+0xf68/0x1360 kernel/exit.c:814
Modules linked in:
CPU: 1 PID: 34 Comm: kworker/u4:2 Tainted: G      D            6.3.0-rc2-intel-next-38f821ff82e9+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Workqueue: writeback wb_workfn (flush-7:0)
RIP: 0010:do_exit+0xf68/0x1360 kernel/exit.c:814
Code: ff ff e8 2b 7e 1b 00 4c 89 ee bf 05 06 00 00 e8 7e c1 01 00 e9 a7 f2 ff ff e8 14 7e 1b 00 0f 0b e9 f8 f0 ff ff e8 08 7e 1b 00 <0f> 0b e9 60 f1 ff ff e8 fc 7d 1b 00 48 89 df e8 54 ff 1a 00 e9 ec
RSP: 0018:ffffc90000127eb0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88800791a340 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88800791a340 RDI: 0000000000000002
RBP: ffffc90000127f18 R08: 0000000000000000 R09: 0000000000000000
R10: 34752f72656b726f R11: 776b203a65746f6e R12: 0000000000000000
R13: 0000000000000009 R14: ffff8880079292c0 R15: ffff888007924600
FS:  0000000000000000(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 000000000b85c002 CR4: 0000000000f70ee0
PKRU: 55555554
Call Trace:
 <TASK>
 make_task_dead+0x100/0x290 kernel/exit.c:981
 rewind_stack_and_make_dead+0x17/0x20 arch/x86/entry/entry_64.S:1541
 </TASK>
irq event stamp: 46556
hardirqs last  enabled at (46555): [<ffffffff8218402d>] get_random_u32+0x1dd/0x360 drivers/char/random.c:532
hardirqs last disabled at (46556): [<ffffffff8300582e>] exc_page_fault+0x4e/0x500 arch/x86/mm/fault.c:1551
softirqs last  enabled at (37844): [<ffffffff83029bdc>] softirq_handle_end kernel/softirq.c:414 [inline]
softirqs last  enabled at (37844): [<ffffffff83029bdc>] __do_softirq+0x31c/0x49c kernel/softirq.c:600
softirqs last disabled at (37835): [<ffffffff8112e774>] invoke_softirq kernel/softirq.c:445 [inline]
softirqs last disabled at (37835): [<ffffffff8112e774>] __irq_exit_rcu kernel/softirq.c:650 [inline]
softirqs last disabled at (37835): [<ffffffff8112e774>] irq_exit_rcu+0xc4/0x100 kernel/softirq.c:662
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:   80 ff 49                cmp    $0x49,%bh
   3:   89 5d 18                mov    %ebx,0x18(%rbp)
   6:   be 08 00 00 00          mov    $0x8,%esi
   b:   bf 20 00 00 00          mov    $0x20,%edi
  10:   e8 80 f9 03 00          call   0x3f995
  15:   48 89 c3                mov    %rax,%rbx
  18:   48 85 c0                test   %rax,%rax
  1b:   0f 84 3a 05 00 00       je     0x55b
  21:   e8 9f 8a 80 ff          call   0xff808ac5
  26:   49 8b 45 18             mov    0x18(%r13),%rax
* 2a:   f0 ff 40 10             lock incl 0x10(%rax) <-- trapping instruction
  2e:   49 8b 45 18             mov    0x18(%r13),%rax
  32:   48 8b 75 b8             mov    -0x48(%rbp),%rsi
  36:   48 89 da                mov    %rbx,%rdx
  39:   48 89 43 18             mov    %rax,0x18(%rbx)
  3d:   48                      rex.W
  3e:   8b                      .byte 0x8b
  3f:   45                      rex.RB
"

> > Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/kconfig_origin
> > v6.3-rc3 issue dmesg: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/v6.3-rc3_issue_dmesg.log
> > Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_filestream_select_ag/bisect_info.log
> > 
> > Bisected between v6.3-rc2 and v5.11 and found the bad commit:
> > "
> > 8ac5b996bf5199f15b7687ceae989f8b2a410dda
> > xfs: fix off-by-one-block in xfs_discard_folio()
> 
> How does *fixing* an off by one error in the page cache produce a crash
> in the filestreams allocator?
> 
  I'm also surprised there is such a problem, I'm not sure the reason as
  I'm not a little about xfs.

> > Reverted the commit on top of v6.3-rc2 kernel, at least the BUG dmesg was gone.
> > 
> > And this issue could be reproduced in v6.3-rc3 kernel also.
> > Is it possible that the above commit involves a new issue?
> > 
> > "
> > [   62.318653] loop0: detected capacity change from 0 to 65536
> > [   62.320459] XFS (loop0): Mounting V5 Filesystem d6f69dbd-8c5d-46be-b88e-92c0ae88ceb2
> > [   62.325152] XFS (loop0): Ending clean mount
> > [   62.326049] XFS (loop0): Quotacheck needed: Please wait.
> > [   62.328884] XFS (loop0): Quotacheck: Done.
> > [   62.363656] XFS (loop0): Metadata CRC error detected at xfs_agf_read_verify+0x10e/0x140, xfs_agf block 0x8001 
> > [   62.364489] XFS (loop0): Unmount and run xfs_repair
> > [   62.364881] XFS (loop0): First 128 bytes of corrupted metadata buffer:
> > [   62.365398] 00000000: 58 41 47 46 00 00 00 01 00 00 00 01 00 00 40 00  XAGF..........@.
> > [   62.366026] 00000010: 00 00 00 02 00 00 00 03 00 00 00 00 00 00 00 01  ................
> > [   62.366657] 00000020: 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00 04  ................
> > [   62.367285] 00000030: 00 00 00 04 00 00 3b 5f 00 00 3b 5c 00 00 00 00  ......;_..;\....
> > [   62.367927] 00000040: d6 f6 9d bd 8c 5d 46 be b8 8e 92 c0 ae 88 ce b2  .....]F.........
> > [   62.368554] 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [   62.369180] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [   62.369806] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [   62.370471] XFS (loop0): metadata I/O error in "xfs_read_agf+0xd0/0x200" at daddr 0x8001 len 1 error 74
> > [   62.371312] XFS (loop0): page discard on page 00000000a6a1237b, inode 0x46, pos 0.
> > [   62.385968] BUG: kernel NULL pointer dereference, address: 0000000000000010
> > [   62.386541] #PF: supervisor write access in kernel mode
> > [   62.386960] #PF: error_code(0x0002) - not-present page
> > [   62.387370] PGD 0 P4D 0 
> > [   62.387588] Oops: 0002 [#1] PREEMPT SMP NOPTI
> > [   62.387945] CPU: 1 PID: 74 Comm: kworker/u4:3 Not tainted 6.3.0-rc3-kvm-e8d018dd #1
> > [   62.388545] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> > [   62.389426] Workqueue: writeback wb_workfn (flush-7:0)
> > [   62.389845] RIP: 0010:xfs_filestream_select_ag+0x5d5/0xac0
> 
> What source line and/or instruction does %rip point to?
> Considering that this is a null pointer deference, you ought to be able
> to identify which pointer access did this.
> 
> If you are going to run some scripted tool to randomly corrupt the
> filesystem to find failures, then you have an ethical and moral
> responsibility to do some of the work to narrow down and identify the
> cause of the failure, not just throw them at someone to do all the work.
> 
 You are right, sorry, I should provide RIP and all other detailed info I have
next time.
 Below info is from above repro.report:
"
BUG: kernel NULL pointer dereference, address: 0000000000000010
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 0 P4D 0 
Oops: 0002 [#1] PREEMPT SMP NOPTI
CPU: 1 PID: 34 Comm: kworker/u4:2 Not tainted 6.3.0-rc2-intel-next-38f821ff82e9+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Workqueue: writeback wb_workfn (flush-7:0)
RIP: 0010:arch_atomic_inc arch/x86/include/asm/atomic.h:95 [inline]
RIP: 0010:atomic_inc include/linux/atomic/atomic-instrumented.h:191 [inline]
RIP: 0010:xfs_filestream_create_association fs/xfs/xfs_filestream.c:321 [inline]
RIP: 0010:xfs_filestream_select_ag+0x5d5/0xce0 fs/xfs/xfs_filestream.c:372
"

Thanks!
BR.
-Pengfei
> --D
> 
