Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A89C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Oct 2022 00:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiJJAvn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 20:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiJJAv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 20:51:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E951C8BB80
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 17:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665362069; x=1696898069;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yMrjK8P8J/3x9/U0OuDdLZfqGde2vCe+RWiGGhcRV7g=;
  b=jPypnFlWGI4pU/lpjVGs13iLDojNGMh8gPnKXxSOpJxnyb4h//DZ3xw/
   g7v8uSqtT63idKyMPMfP5487heXxDU6MCsmbDmCzcSNYB6f0QFZ3/TDRs
   2Wk58oV9/upFVFpPGaFBB5ErpqCs+88/zC8B5qcD/NzOOm45jGKC86e63
   tgwjn/+jYRA9yhGDwprML4dwyhju2Mpx6GGDjoSDduynuxMLMOAFg62jz
   dJ0TZEXryRkvEIW4r2r1BEeC1mqGJaI4DrZJgumdW9WJrfELrv7ywkKcM
   U4Doqsx5pBX1ZVD9HM54B7Ry1a+NNJOHCg3mPGoKfEJftOybIYuGZ+OWC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="366075880"
X-IronPort-AV: E=Sophos;i="5.95,172,1661842800"; 
   d="scan'208";a="366075880"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2022 17:32:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="688602295"
X-IronPort-AV: E=Sophos;i="5.95,172,1661842800"; 
   d="scan'208";a="688602295"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 09 Oct 2022 17:32:57 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 9 Oct 2022 17:32:56 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 9 Oct 2022 17:32:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 9 Oct 2022 17:32:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 9 Oct 2022 17:32:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsYEFzxNYDnCzBIg7kmfxEUIenIk8dlXKigQ0IAN48iW70VTgBnhufFVbde0Rzexi2aukxOxFgdYB0tLdmWgPm+yoh1l2J3sqIFMlwWDcKHAN/EkYadTL+iN9IJ9fKSEIMu3IJxtbNAdWbE/8W8y+MZD4oT/il1I4i3GItE616t52JFyzCHIynLrofwRkD1KuhVp/HWZbWp0c+sKxOQ9CY7pQfBycJ/aFIjA6i9cmwudxZM70uT29DEZXru8ERqwTJ4+dtFPi1lYyqV401qWco3gmON8+U17HRyhGneawr67mCwJnp00p6e0ZYlS9hHskgvisMIch7DSBIltin4RFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6J8Z0QCyGOGo576Df4nnG6J6Qe5Gvb1UxfF9NTWa8Y=;
 b=jcSdvM5PXvfNpgPS4owPaG7JWD+YB0G5Yg+mWMTUuSc+pwuI+oB9sDoHrQPwGVvfv/SuV/cO3XgIAgSESGQzfPVi85Q5Hxr1l9LF55FrapwOwuP81kpKBOBmqa/Gje8EwOiMGSq1cOUfvtrzVnxCWH4FTXws3R7wPWYGBDxTrVgqUkq79BUKxz21nudb+CvBDQ9v1JEq640+3urjHBjdaJc/3/LprGt32hkgYjl6HywprTU10zdReTrBI7FLknhYj6zzKTmug8d74ZIXqbZcFJkHDIROD6znCSF/inTnY834ziROHOTtilFWp7fo/lpSXEmqx79+yYpUcmUpHCJuNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
 by SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Mon, 10 Oct
 2022 00:32:52 +0000
Received: from BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::e0d7:3a8:4fd8:b7f4]) by BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::e0d7:3a8:4fd8:b7f4%7]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 00:32:52 +0000
Date:   Mon, 10 Oct 2022 08:32:41 +0800
From:   Philip Li <philip.li@intel.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     Oliver Sang <oliver.sang@intel.com>,
        Guo Xuenan <guoxuenan@huawei.com>, <lkp@lists.01.org>,
        <lkp@intel.com>, Hou Tao <houtao1@huawei.com>,
        <linux-xfs@vger.kernel.org>
Subject: Re: [LKP] Re: [xfs]  a1df10d42b: xfstests.generic.31*.fail
Message-ID: <Y0NoKUei4Xfn/afb@rli9-MOBL1.ccr.corp.intel.com>
References: <202210052153.fedff8e6-oliver.sang@intel.com>
 <20221005213543.GP3600936@dread.disaster.area>
 <Y0J1oxBFwW53udvJ@xsang-OptiPlex-9020>
 <20221010000740.GU3600936@dread.disaster.area>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221010000740.GU3600936@dread.disaster.area>
X-ClientProxiedBy: SG2PR04CA0170.apcprd04.prod.outlook.com (2603:1096:4::32)
 To BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB2995:EE_|SJ1PR11MB6180:EE_
X-MS-Office365-Filtering-Correlation-Id: beb65d10-d4e0-4b72-86a8-08daaa56f73c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ireIW2xdXzlMamEWWHzdJNEys1I2HOGJyfKqI4nayi3HJJXYPEvBSKgUWjjgGuIvbDLUzeqDKWELrGix9x6hIAMeTahy4dzPkx+X2oGGSEhoiaX5P/HUO3g4dHTAVE5lhEr2GFwFTN5pYrj0x4fnk7xvPs7WxOWePqJo1neONWpGNXdbIwvR5o40NVzOcnjr1Kr1cY7vmb/WVrOrP/I1x7tmkR8LH5vxrgY6EMrxNBLRWHOPa2zj6vfEYiQbq3Det/ueNvfTaSlbyoZhr1LirktXk6EfZPSoHFv3VIDHJ20jPkF8qi4dJE6b6BnMCkFuFOsYtrt6slgSWvfFlad5QTCGw6ngEqlrndPQkOMywTOOJMi3+C2iatZcEN9jvbp/8hn3Qv4o2l0jjzambxxXqe2t6OHf6H2d0WJesahTeEIl4orLW/4VriwDqGvwW+T0uYkk0dckuQHh4/tgyhlAuEo1RacriNgEt/ECvoyYtLJboF+DrdJqI3naW2aUSTD+fkIttIhgOY4/Cz31nvIgqyJp9WlkTLVIweF1aH1Pr79j/5nx0s/2CcXiMaELxJo22SE35PxtXuUXqJYp/tkKV0ibAJAmUenB/oEqaqf6ffiLpefTWm4F1rMwb6kVIWEEQ61BW9d8SK/OgH/lHfWtEmroe2JopHOgJbRAqWLdRj6oK2agtsWBlaKW/zwyJkuW2jvzHIxJhfEaIOJsMimyRGlte1GdUkhO4nYxCYnjLLd7gCaX9PBzOJgnbytdbI0kOjDwddX0N5G7w/AqFUCh+hb0jn+R86FtNg4qSrPHG+dJzT3ql+4OrjNaO0xKS83FPFyAUHbj1KnhIC0Nhzmh9I6IWJaKwEFz/RzKdEp5ptg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(316002)(6916009)(86362001)(54906003)(8676002)(66556008)(4326008)(44832011)(8936002)(41300700001)(2906002)(66476007)(5660300002)(66946007)(82960400001)(38100700002)(66899015)(26005)(6666004)(6506007)(83380400001)(6486002)(6512007)(186003)(966005)(478600001)(41533002)(505234007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GZxupFxE7ha4pMdBemw5V83cdXkhFiGREz40YtnZ9lnERzDkY3zRzrMk8LMx?=
 =?us-ascii?Q?Q46qBAWX/t/TTKKi/0YENydE5KhVfDhzjZ9CZ1lvaWNjWxDehzd/CnYTD1XD?=
 =?us-ascii?Q?9NcPDkycZIqfBxocTOkfD50VGrRBehYGmay/fmdQeKZoqUnX4VA0njame7tb?=
 =?us-ascii?Q?qzY/wM047Q82I0NcOfOZXtwRT20mXrd7sCu5mOxdbggefFHdNqijGdmZdYTB?=
 =?us-ascii?Q?EF/LkEbXHraWy8mJILgrOuC2DE67A8sJ+A57xnJG29MmtEbNZ4A/QZZvH63y?=
 =?us-ascii?Q?uQO1fNfP5yiTGUDE21OXK6OwbTGBMad2VUXM+EtWXIvWZnJWEZ5VW0AFYyZK?=
 =?us-ascii?Q?w80n+9J/snnHq5I4cLXAx2DIvYi6WFpoWKJyE1YgS55cyvrQQME9Qgk4/Wy4?=
 =?us-ascii?Q?nmsa5amJT+g0IMhssm65Q/IDDtnsYaCCoqeqwcbb0EO52Zr6tIHBc4EtJXFE?=
 =?us-ascii?Q?YIlpI/+y0EWYHYoj0JAfP/qHb8qpMZixXD+VxSFTdVuqjdN6CUxjq8Dkl+6p?=
 =?us-ascii?Q?QynI/l1IJG7EMEohvl/fzOnKc6V57w6I9WUnrtu/8Do69khAXvdOJnvbcPiC?=
 =?us-ascii?Q?95Rgv9coIJG3EtZZZbfGFHmAU+8bOiiO74xEDSJlilqa4kfT1uJVnkbd7iZy?=
 =?us-ascii?Q?bNsTNUYL6j8ExTLvcaZJvx3cmvc2HUfSZqeBuiGFfdT1n8Euo89RRPwF1hFY?=
 =?us-ascii?Q?z0ojRWC8iHqh4+zMzVlzdYv8MdZOVrRIs/eeRCWxpNHR/eTXS6FiyM8RBO/P?=
 =?us-ascii?Q?yKOPviW3+R0qBLCaXxTTWtmTVCm7MPYKo6bc3sPl++seIlb1PF7bR2NT1FN1?=
 =?us-ascii?Q?f4ja+2Gc05Mgd5kB82NxozUXz79BhRs1SSiNRxhStZgyL60kn1eQJ8hwu200?=
 =?us-ascii?Q?k/KU5E9NmWGeB7p/thHqwvlNgTWaJfY9B/DzYw/c/4BQCALBHEN6nE+x3XTE?=
 =?us-ascii?Q?sJtKAJ0GqzWCCd0ywx+XuLYU7mISFDi7bDturyC3OFj9QpMKDDf0dEpqMa1F?=
 =?us-ascii?Q?23W/zBfqGkI6viOT7NWnwLNY9xar1pS3odDVDz5mWE2cWlB4CjhdPLUNhMEV?=
 =?us-ascii?Q?e4YyKooovYV3YMwWYrWkvWefGwC1MngnykBpnRqI9OkT3HmEUJfve5N7eJgd?=
 =?us-ascii?Q?LXYj5GNRObJCoh2sCvIkcqBdnQ4TkX2CN8lVtLihivtemG0AD5AlG/lMsHJ6?=
 =?us-ascii?Q?nahcSqjfnHRL20aEKLYuOk9yuR0AhfQGTovRdXgQNtej7pxkiH0FSjZzuP4T?=
 =?us-ascii?Q?EBXlUawnJvvFXOzNmIoQzkm+Tg++Q9aGb2R4ZfyEts9xLx3VBMra+qxNVIYv?=
 =?us-ascii?Q?nV7sqPXNA3zyZ4goiqydO4iO+7SSmrRpai/93bSKo+Mzc69VpuWTlweHm596?=
 =?us-ascii?Q?FitaOcikCxS3IdCzdjC7JZhftW78omiOh2fZczZhbD4S4Fgwv/ardhCcmOql?=
 =?us-ascii?Q?cwOeHhiC5YEpyaJk+zhkClcIna4rAqhsGuR96A9vC7I9CrKasHZXKK4WDX+Q?=
 =?us-ascii?Q?Nl2mFcmJmsIovruOGb0iXdQ9v6Ir/lWranZ4voMEf1gwiZsFytTFZOJQcNzu?=
 =?us-ascii?Q?hOCLAGiLw7xjpomHe4peMCIoTCyzUPUNm/K+f81H?=
X-MS-Exchange-CrossTenant-Network-Message-Id: beb65d10-d4e0-4b72-86a8-08daaa56f73c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 00:32:52.1319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lkjqZK29CB5kVNhfKpV6emmGD7EhCff8Bpxp3Obp+1G1kNUg0qX556tTAHZ4b9Khbo8UBMzBZiPwSXMWTqscoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6180
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 10, 2022 at 11:07:40AM +1100, Dave Chinner wrote:
> On Sun, Oct 09, 2022 at 03:17:55PM +0800, Oliver Sang wrote:
> > Hi Dave,
> > 
> > On Thu, Oct 06, 2022 at 08:35:43AM +1100, Dave Chinner wrote:
> > > On Wed, Oct 05, 2022 at 09:45:12PM +0800, kernel test robot wrote:
> > > > 
> > > > Greeting,
> > > > 
> > > > FYI, we noticed the following commit (built with gcc-11):
> > > > 
> > > > commit: a1df10d42ba99c946f6a574d4d31951bc0a57e33 ("xfs: fix exception caused by unexpected illegal bestcount in leaf dir")
> > > > url: https://github.com/intel-lab-lkp/linux/commits/UPDATE-20220929-162751/Guo-Xuenan/xfs-fix-uaf-when-leaf-dir-bestcount-not-match-with-dir-data-blocks/20220831-195920
> > > > 
> > > > in testcase: xfstests
> > > > version: xfstests-x86_64-5a5e419-1_20220927
> > > > with following parameters:
> > > > 
> > > > 	disk: 4HDD
> > > > 	fs: xfs
> > > > 	test: generic-group-15
> > > > 
> > > > test-description: xfstests is a regression test suite for xfs and other files ystems.
> > > > test-url: git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> > > > 
> > > > 
> > > > on test machine: 4 threads 1 sockets Intel(R) Core(TM) i3-3220 CPU @ 3.30GHz (Ivy Bridge) with 8G memory
> > > > 
> > > > caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> > > 
> > > THe attached dmesg ends at:
> > > 
> > > [...]
> > > [  102.727610][  T315] generic/309       IPMI BMC is not supported on this machine, skip bmc-watchdog setup!
> > > [  102.727630][  T315] 
> > > [  103.884498][ T7407] XFS (sda1): EXPERIMENTAL online scrub feature in use. Use at your own risk!
> > > [  103.993962][ T7431] XFS (sda1): Unmounting Filesystem
> > > [  104.193659][ T7580] XFS (sda1): Mounting V5 Filesystem
> > > [  104.221178][ T7580] XFS (sda1): Ending clean mount
> > > [  104.223821][ T7580] xfs filesystem being mounted at /fs/sda1 supports timestamps until 2038 (0x7fffffff)
> > > [  104.285615][  T315]  2s
> > > [  104.285629][  T315] 
> > > [  104.339232][ T1469] run fstests generic/310 at 2022-10-01 13:36:36
> > > (END)
> > > 
> > > The start of the failed test. Do you have the logs from generic/310
> > > so we might have some idea what corruption/shutdown event occurred
> > > during that test run?
> > 
> > sorry for that. I attached dmesg for another run.
> 
> [  109.424124][ T1474] run fstests generic/310 at 2022-10-01 10:14:01
> [  169.865043][ T7563] XFS (sda1): Metadata corruption detected at xfs_dir3_leaf_check_int+0x381/0x600 [xfs], xfs_dir3_leafn block 0x4000088 
> [  169.865406][ T7563] XFS (sda1): Unmount and run xfs_repair
> [  169.865510][ T7563] XFS (sda1): First 128 bytes of corrupted metadata buffer:
> [  169.865639][ T7563] 00000000: 00 80 00 01 00 00 00 00 3d ff 00 00 00 00 00 00  ........=.......
> [  169.865793][ T7563] 00000010: 00 00 00 00 04 00 00 88 00 00 00 00 00 00 00 00  ................
> [  169.865945][ T7563] 00000020: 27 64 dd b1 81 61 45 2b 86 66 64 67 56 f2 40 58  'd...aE+.fdgV.@X
> [  169.866122][ T7563] 00000030: 00 00 00 00 00 00 00 87 00 fc 00 00 00 00 00 00  ................
> [  169.866293][ T7563] 00000040: 00 00 00 2e 00 00 00 08 00 00 00 31 00 00 00 0c  ...........1....
> [  169.866467][ T7563] 00000050: 00 00 00 32 00 00 00 0e 00 00 00 33 00 00 00 10  ...2.......3....
> [  169.866640][ T7563] 00000060: 00 00 00 34 00 00 00 12 00 00 00 35 00 00 00 14  ...4.......5....
> [  169.866816][ T7563] 00000070: 00 00 00 36 00 00 00 16 00 00 00 37 00 00 00 18  ...6.......7....
> [  169.867002][ T7563] XFS (sda1): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply+0x508/0x600 [xfs] (fs/xfs/xfs_buf.c:1552).  Shutting down filesystem.
> 
> I don't see any corruption in the leafn header or the first few hash
> entries there. It does say it has 0xfc entries in the block, which
> is correct for a full leaf of hash pointers. It has no stale
> entries, which is correct according to the what the test does (it
> does not remove directory entries at all. It has a forward pointer
> but no backwards pointer, which is expected as the hash values tell
> me this should be the left-most leaf block in the tree.
> 
> The error has been detected at write time, which means the problem
> was detected before it got written to disk. But I don't see what
> code in xfs_dir3_leaf_check_int() is even triggering a warning on a
> leafn block here - what line of code does
> xfs_dir3_leaf_check_int+0x381/0x600 actually resolve to?
> 
> .....
> 
> <nnngggghhh>
> 
> No wonder I can't reproduce this locally.
> 
> commit a1df10d42ba99c946f6a574d4d31951bc0a57e33 *does not exist in
> the upstream xfs-dev tree*. The URL provided pointing to the commit
> above resolves to a "404 page not found" error, so I have not idea
> what code was even being tested here.
> 
> AFAICT, the patch being tested is this one (based on the github url
> matching the patch title:
> 
> https://lore.kernel.org/linux-xfs/20220831121639.3060527-1-guoxuenan@huawei.com/
> 
> Which I NACKed almost a whole month ago! The latest revision of the
> patch was posted 2 days ago here:
> 
> https://lore.kernel.org/linux-xfs/20221008033624.1237390-1-guoxuenan@huawei.com/
> 
> Intel kernel robot maintainers: I've just wasted the best part of 2
> hours trying to reproduce and track down a corruption bug that this
> report lead me to beleive was in the upstream XFS tree.

hi Dave, we are very sorry to waste your time on this report. It's our fault to not
make it clear that this is testing a review patch in mailing list. And we also
miss the NACKed information in your review, and send out this meaningless report.

> 
> You need to make it very clear that your bug report is for a commit
> that *hasn't been merged into an upstream tree*. The CI robot
> noticed a bug in an *old* NACKed patch, not a bug in a new upstream
> commit. Please make it *VERY CLEAR* where the code the CI robot is
> testing has come from.

We will correct our process ASAP to 

1) make it clear, what is tested from, a review patch or a patch on upstream tree

2) do not send such report, if the patch has already been NACKed

Apologize again for wasting your time with a bad report!

> 
> Not happy.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> _______________________________________________
> LKP mailing list -- lkp@lists.01.org
> To unsubscribe send an email to lkp-leave@lists.01.org
