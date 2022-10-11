Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1811C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Oct 2022 01:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiJKB0S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Oct 2022 21:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiJKB0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2022 21:26:01 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC82011A3A
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 18:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665451526; x=1696987526;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=82vXAebubZt2T4A6d2nhR6aarfp6VBawdhGHO06eK24=;
  b=h9tLuSbnEmszbBEpp0pxike0r/Pm88J6/1xiPmjAbsKMLUXnMFDFBF1S
   7WKIKNXTyuuiM0yq+j/Xt72pDbfiquCD6AF2qYFYVLdtUL5zM7ueEbl33
   Cfl3Z1pefxPp3Y2G/w7qIVjgILQ45iXz5So3iZ0lUDiOlZZ9t6pnlWO79
   CPLs4iiA4DU+hcnmheMp0xqDX93axscCwh4NOwguXrrbxREKG3vdDxDA6
   4ffkKtJ9KWQ9S6rxYhUEOb84kwXdWRhnwsRjmobNueE3YxCw2Wa7dl0ux
   uInl7ldKAuy5w2ACoe5XQH/FZcxpLlOfWExzRux3kJjMUKcEyBKavZFI7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="303117518"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="303117518"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 18:25:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="751557363"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="751557363"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 10 Oct 2022 18:25:26 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 10 Oct 2022 18:25:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 10 Oct 2022 18:25:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 10 Oct 2022 18:25:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYEwm8jGs/8ki4D+Y6v05FzpzIQffIEXWCKUnWlLZ1iUVNcg1vrJJI4l1yNa5tEqekf7JeAN4T9QSO7thMnOB6Cq1o6ZjUyh0gSeD2iaNCKLEw0P58k6BfwfKiwtPfccLIm3qi2nmBGemp/ufBTXwyM5YXdeK6DZNcTgGy4bFziqfJHbJhKrOvlvLrTMoc5rhmmU1LCANePTuXiVf8v93TrYpZiRFcFsZ/EKMeNnF2BJmUy5z/1GYFZtcz82hIdqgdKzwjPkt7Ee1EtZSCJMmXHpUwyYJJmvIP6iE8Gq7Bk51FTwZYfX2CRls4aZRTNWtZlbaltzvVrg2s0J6noxSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mb4MRMti+81gB++2kClNO3zrX+gsDQYKed2yZJoAhBQ=;
 b=n8yoiRiuwOlAFQwBi+xSchIRNEqGVcwf2AckPVtBYPcy2rEj0lEMZx5hukFHr0RnP29bkuLdxMPck04AsnBZzTa5rxm2reIyyxLnA66jq2jobzdXA+g5Zq6QjZHxJ9Wv8679VNNhfEWC9EYZ3kpd6g4SrvraXODITFGt8uJPTFw1dOU2vqcyAuLHMb35gZNXPS6i26eGRtlDNpjUU462kT0nlF0VBsKNuXGi/gbNfJy18ucJedZbz86vh/du+QxOw54/6My5ZYF9i2qUJRBzm3AhCAuXFNMyaBEwjH5UQwr07yzzc/nfadR2AJDQE9xEI7iUFgcAjB0tTBm4+alhpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
 by MN2PR11MB4728.namprd11.prod.outlook.com (2603:10b6:208:261::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Tue, 11 Oct
 2022 01:25:18 +0000
Received: from BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::e0d7:3a8:4fd8:b7f4]) by BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::e0d7:3a8:4fd8:b7f4%7]) with mapi id 15.20.5709.015; Tue, 11 Oct 2022
 01:25:18 +0000
Date:   Tue, 11 Oct 2022 09:25:08 +0800
From:   Philip Li <philip.li@intel.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     Oliver Sang <oliver.sang@intel.com>,
        Guo Xuenan <guoxuenan@huawei.com>, <lkp@lists.01.org>,
        <lkp@intel.com>, Hou Tao <houtao1@huawei.com>,
        <linux-xfs@vger.kernel.org>
Subject: Re: [LKP] Re: [xfs]  a1df10d42b: xfstests.generic.31*.fail
Message-ID: <Y0TF9DlJMFSESfrO@rli9-MOBL1.ccr.corp.intel.com>
References: <202210052153.fedff8e6-oliver.sang@intel.com>
 <20221005213543.GP3600936@dread.disaster.area>
 <Y0J1oxBFwW53udvJ@xsang-OptiPlex-9020>
 <20221010000740.GU3600936@dread.disaster.area>
 <Y0NoKUei4Xfn/afb@rli9-MOBL1.ccr.corp.intel.com>
 <20221010205440.GV3600936@dread.disaster.area>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221010205440.GV3600936@dread.disaster.area>
X-ClientProxiedBy: SG2PR04CA0158.apcprd04.prod.outlook.com (2603:1096:4::20)
 To BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB2995:EE_|MN2PR11MB4728:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b12ed41-8fc1-4c3d-6918-08daab27750b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vrNikJh6aEJMS73vO7CYBhKJxU+e+1aWrHN9ud5kDd1YJ5InpOdbgSYL1o4WFO/KEz7oP5kKfGQpsaNxGGmQOh+Vb6O8DbXKber1KXDROuU5Ehrhzqve5Vhss/ydgb71d2biqbvKsfum+QI3iqwClQTsedL3oENJuP6eOQibd2RTdCtICnB4FK917l+y6Q43p1lR0dqtHI7hMpZeYmXU9WmXb98VGrmkjKo56JtoQ+zn0dEiu1tMwML+9BAISjj/+AzYoOqpoMw2nYMkeIfnM4Qzc+IRV414Ig/tCNAetDYfrbnhUkU/iuEsPVBjZQldFtw0PRKOJrtj5nWLas3t3NG7wpQ7EuY4BfmNzdCieVP/80I0gZsQfqJOBXO8tfnXsFYEE15zBxtMgCSqNHQf8byerJJadGtuv29dWgF6/dEHp6cKUvbLGT524Np+phEBtT6+VGPUzSSu+juJTJQtlbbqiH+deX6ScZxpdpf1jJrpZUUXicxwPxpDM7vMaum8g8qnyWZWK5pJddKoEMYlmm0G5xkdgSMoFezxOveoK8Q5Yeei50DEphl250FVBtqEvag4MZewci3O3QhAboCakmbRPn7E98jqy7/GxIQOR/tI82yLSJWHOER4hX5YZ5Tf05xbXmA/lTXmZqkFdVAUZH8loVcYC1Yd8tq+skO0iC1kBGfcJoyr4cpNyDqRrinnR+xQ0Li97xD52elmiRXAiNE3u5qTcYd9fH3SRmUAaTWX5gKFa//IciXq76Jk+l0k30Wh7WunKf/jsKaY4QKwhTV5o9P7cqYIL+EBQMH1X+xxglEmz53NFKtAtTgtIrKAiS5Euinv8wF01+LkCTvoAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199015)(26005)(6506007)(6512007)(6486002)(966005)(186003)(83380400001)(82960400001)(38100700002)(86362001)(6666004)(478600001)(4326008)(66476007)(8676002)(6916009)(66556008)(54906003)(41300700001)(316002)(8936002)(5660300002)(44832011)(2906002)(66946007)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8pRS6pAS59cFNZkZWry6vU2pwchj/yLxHwIyVzHW8SfowvQoz8jpDXaAwGm/?=
 =?us-ascii?Q?345ybXxdf4mzewLuHpdbG0lIVWw6Mx53JpN4aJDRH7j8weByg3EQvXJEfFuB?=
 =?us-ascii?Q?yhdDKNs6w3MZGr+NvZi/J0bzTJrT8oComF5v/FakvFTxQclnZrfGpi8NkJyX?=
 =?us-ascii?Q?+VYpKv2+27hrEQP5xXMDn/kyh/rQR4wdc2OBjq/IN7FfPPi/k7tTEC9AeFPD?=
 =?us-ascii?Q?6iLL7WatCEDvZ1gjZqQS4hOFpf0VA/YfQU8HdjiP7+VQSp95jThE1hLqUsU2?=
 =?us-ascii?Q?UQYdyLnDJBuqkJra4IB76lO3ZtTnx6qsFqgSaaKQ3nsd18wYh5ooBi4fhGXE?=
 =?us-ascii?Q?WGytFUE0feE6NAGaS+qLnatS34FLhQ+eTIVkTdMsLqnKC/57wvt71MY4k7bu?=
 =?us-ascii?Q?tfFlp4RHtTWqj0dUu2q8YtjJ7+vqFqlxrBJjVHfu5aMFE0b23U/pjEyFAr5R?=
 =?us-ascii?Q?4m28y8sDjmdAHAKmY7ukaYOcpyWJsPyCF90UITldARQq8upJ2dXOR33fZZ4S?=
 =?us-ascii?Q?Mn5OkqQQUxtueNo3PuL9tpdQgFYNl5JP69IHzSSPufpkiHa9RgrkBC+WdPjl?=
 =?us-ascii?Q?cEpW7fQEfrGPnupd4ra+JSpsPBdz4z525mn0OxcdCc2UenyxF18TaFBMZQYW?=
 =?us-ascii?Q?yyn9cchHSy3oCZANvTdiRPkNuesaWgaQTD4n69yXfgaQQu8T1qLRlhSwHtH4?=
 =?us-ascii?Q?0dYq2H1uwMMC8OVdG1d8hGtXZedWtszHJeMqJgKhKnRtaUpEVcxN0XmgYdq/?=
 =?us-ascii?Q?yMYRyncvb4n0oztjJ6qUiXnoM6yr6orLO5g/qx14JsN7QimLc+9cq0s4iYLd?=
 =?us-ascii?Q?uCSS/FhpwE5bdydWB0OBHPlwl/+u+pDXcSKw1tAIdf3p78Do6vHshZ0zjn2e?=
 =?us-ascii?Q?DNM5xC3L/ZScOXqeq7ZBuYJMP/Rz1MKFF7sBxbI2j+CKvv7HTszlRr2QGx2f?=
 =?us-ascii?Q?wq10PXsdT6DwvCqcEVWjhKLkS4tP7PifGUi9WlP1aScK/jbmoQWvN4+dfc8G?=
 =?us-ascii?Q?fAnBDBhahdb9vaCA9ZVjb/4CPnDKphVO7duuXcAfmMNRJSO/Fzcnf9fwVeBO?=
 =?us-ascii?Q?iDSNpnckM8s3lyhKhi+dKzGZjbS0sCTsh4twSgcwSr55cugqAgrR7G2eGD+t?=
 =?us-ascii?Q?1LPec95gNjccTYXUlD1E+Lrt1xu67ID6oTHtzL8zyCbJY8C4Doiiw3+EBHhK?=
 =?us-ascii?Q?PtRZBLPYXgsEfapin3+0FAwnnkeXzF6gXQoeKdQYIGplxwq1RE+wEoQufEmn?=
 =?us-ascii?Q?pK/BoYcOCV6jnKpCS2oOlBbGhhNuxa3WUIPvgDdj9FLfr0zc4A3SOmwHmVxr?=
 =?us-ascii?Q?EYfYV5TxpYbCEdwREGpYeeWMvULoybZZvxjY3WZk0GMwtT3DkiTtA5vF2iRi?=
 =?us-ascii?Q?ud8MEsw/Nc69T3J45tk3YbDnZv+mOhzOuo3tTd2oAwgF3lTtYKS1iwmjkh+9?=
 =?us-ascii?Q?uHRmKYhIjcaGJBMCKHPadeAme9pcqSIxQdxSVRh4P3QCPCULhCxIlrCe4Lxz?=
 =?us-ascii?Q?nKw302ZMSHgu5xnP6FrdMuMeATA01vFK5bgsXH7WWQ5WViqK0J2vVuy0mE9K?=
 =?us-ascii?Q?6SprMLW4q4XGHuyI7VmV157AnLfJAiP1os7BzG2QsVdfTUAZY7rASLQNoznw?=
 =?us-ascii?Q?hw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b12ed41-8fc1-4c3d-6918-08daab27750b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 01:25:18.5852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRAoeRqk6sqderK02oPZbxWG3U0oEALQIPddrm9CZ+i/2A/2Z46xlV8Fji1ayjx+q1/3L72Kd83puKDqyR9GFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4728
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 11, 2022 at 07:54:40AM +1100, Dave Chinner wrote:
> On Mon, Oct 10, 2022 at 08:32:41AM +0800, Philip Li wrote:
> > On Mon, Oct 10, 2022 at 11:07:40AM +1100, Dave Chinner wrote:
> > > On Sun, Oct 09, 2022 at 03:17:55PM +0800, Oliver Sang wrote:
> > > > Hi Dave,
> > > > 
> > > > On Thu, Oct 06, 2022 at 08:35:43AM +1100, Dave Chinner wrote:
> > > > > On Wed, Oct 05, 2022 at 09:45:12PM +0800, kernel test robot wrote:
> > > > > > 
> > > > > > Greeting,
> > > > > > 
> > > > > > FYI, we noticed the following commit (built with gcc-11):
> > > > > > 
> > > > > > commit: a1df10d42ba99c946f6a574d4d31951bc0a57e33 ("xfs: fix exception caused by unexpected illegal bestcount in leaf dir")
> > > > > > url: https://github.com/intel-lab-lkp/linux/commits/UPDATE-20220929-162751/Guo-Xuenan/xfs-fix-uaf-when-leaf-dir-bestcount-not-match-with-dir-data-blocks/20220831-195920
> > > > > > 
> [....]
> 
> > > commit a1df10d42ba99c946f6a574d4d31951bc0a57e33 *does not exist in
> > > the upstream xfs-dev tree*. The URL provided pointing to the commit
> > > above resolves to a "404 page not found" error, so I have not idea
> > > what code was even being tested here.
> > > 
> > > AFAICT, the patch being tested is this one (based on the github url
> > > matching the patch title:
> > > 
> > > https://lore.kernel.org/linux-xfs/20220831121639.3060527-1-guoxuenan@huawei.com/
> > > 
> > > Which I NACKed almost a whole month ago! The latest revision of the
> > > patch was posted 2 days ago here:
> > > 
> > > https://lore.kernel.org/linux-xfs/20221008033624.1237390-1-guoxuenan@huawei.com/
> > > 
> > > Intel kernel robot maintainers: I've just wasted the best part of 2
> > > hours trying to reproduce and track down a corruption bug that this
> > > report lead me to beleive was in the upstream XFS tree.
> > 
> > hi Dave, we are very sorry to waste your time on this report. It's our fault to not
> > make it clear that this is testing a review patch in mailing list. And we also
> > miss the NACKed information in your review, and send out this meaningless report.
> 
> The biggest issue was how it was presented.
> 
> Normally I see reports from the kernel robot for specific
> uncommitted patches like this as a threaded reply to the specific

We did a review for this case, this was our fault that the generated report
didn't reply with the right in-reply-to message id, thus it was not connected
to original patch. We need be careful to double check the report when sending out.

Thread overview: 9+ messages / expand[flat|nested]  mbox.gz  Atom feed  top
2022-08-31 12:16 [PATCH v2] xfs: fix uaf when leaf dir bestcount not match with dir data blocks Guo Xuenan
2022-09-12  1:31 ` Dave Chinner [this message]
2022-09-14 16:30   ` Darrick J. Wong
2022-09-28 10:06   ` [PATCH v3] xfs: fix expection caused by unexpected illegal bestcount in leaf dir Guo Xuenan
2022-09-29  8:51   ` [PATCH v4] xfs: fix exception " Guo Xuenan
2022-09-29 20:50     ` Darrick J. Wong
2022-10-07 11:33       ` Guo Xuenan
2022-10-07 16:30         ` Darrick J. Wong
2022-10-08  3:36           ` [PATCH v5] " Guo Xuenan

> patch that was identified as having a problem.  And normally this
> sort of standalone test failure report comes from a failure bisected
> to a commit already in an upstream tree. 
> 
> So my confusion here is largely because a bug in an uncommitted
> patch was reported in the same manner as an upstream regression
> would be reported - as a standalone bug report...

We also did a discussion internally, this is confusing with the same style
of report subject "$commit id: $issue", which is hard to distinguish. We
should update the subject to mention it is from mailing list, and add lore
link as you suggested below.

> 
> 
> > > You need to make it very clear that your bug report is for a commit
> > > that *hasn't been merged into an upstream tree*. The CI robot
> > > noticed a bug in an *old* NACKed patch, not a bug in a new upstream
> > > commit. Please make it *VERY CLEAR* where the code the CI robot is
> > > testing has come from.
> > 
> > We will correct our process ASAP to 
> > 
> > 1) make it clear, what is tested from, a review patch or a patch on upstream tree
> 
> Yes, commit ID by itself is not sufficient to identify the issue,
> nor is a pointer to the CI tree the robot built. For a patch pulled
> from a list, it should not be reported as a "commit that failed".
> It should be reported as "uncommitted patch that failed", with:
> 
> - a lore link to the patch that was identified as having an issue;
> - a pointer to the base tree the patch(es) were applied to (e.g.
>   linus-v5.19-rc7, linux-next-2022-25-09, etc)
> - a pointer to the CI integration tree (that doesn't) the patch was
>   applied to and tested.

thanks a lot for the detail instructions, we will follow up all these to update
the report information to make it clear for a review patch.

> 
> For an upstream commit that failed, reporting "<commit id> failed"
> is a good start, but it really needs to include the tree as the
> robot might be testing dev trees or linux-next rather than Linus's
> tree. i.e. report as "<tree, commit id> failed <test>".

Got it, we will do this, and to align the runtime report like our kbuild
report to add tree information.

> 
> > 2) do not send such report, if the patch has already been NACKed
> 
> That's not so much a problem. The real problem that needs solving is
> ensuring that the recipients of the bug report are able to quickly
> and obviously identify what was being tested when the issue was hit.

Got it, thanks for the advice, we will make above changes asap.

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
