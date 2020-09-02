Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8234FC433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D87B2083B
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgIBRia (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:38:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:25581 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726800AbgIBRia (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Sep 2020 13:38:30 -0400
IronPort-SDR: uzfQy2WVDhXYGeK/GHw+H70g5gIgtBS6ql7BEYhPy83B1R6OdiSfDq4k3JlOZ39jmZTvLHoVp6
 pDmvDZWPKqbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="137495742"
X-IronPort-AV: E=Sophos;i="5.76,383,1592895600"; 
   d="scan'208";a="137495742"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 10:38:29 -0700
IronPort-SDR: mN86lgl0yN1Br5AOAvCvXtJiqzUdPbBjcrPmnemB+BO1pecJnaXonduwFe1UP/nAR89fWgSgFE
 rR8+OmXeLudg==
X-IronPort-AV: E=Sophos;i="5.76,383,1592895600"; 
   d="scan'208";a="446602144"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 10:38:29 -0700
Date:   Wed, 2 Sep 2020 10:38:28 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Xiao Yang <yangx.jy@cn.fujitsu.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Add check for unsupported xflags
Message-ID: <20200902173828.GR878166@iweiny-DESK2.sc.intel.com>
References: <20200831133745.33276-1-yangx.jy@cn.fujitsu.com>
 <20200831172250.GT6107@magnolia>
 <5F4DE4C1.6010403@cn.fujitsu.com>
 <20200901163551.GW6107@magnolia>
 <5F4F0647.5060305@cn.fujitsu.com>
 <20200902030946.GL6096@magnolia>
 <5F4F12E2.3080200@cn.fujitsu.com>
 <20200902041039.GM6096@magnolia>
 <5F4F2964.8050809@cn.fujitsu.com>
 <20200902170326.GP6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902170326.GP6096@magnolia>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 10:03:26AM -0700, Darrick J. Wong wrote:
> On Wed, Sep 02, 2020 at 01:11:00PM +0800, Xiao Yang wrote:
> > Hi Darrick,
> > 
> > It is reasonable for your concern to add a check in VFS, but checking all
> > defined xflags is too rough in VFS if one filesystem only supports few
> > xflags. :-)
> 
> I was advocating for two levels of flags checks: one in the VFS for
> undefined flags, and a second check in each filesystem for whichever
> flag it wants to recognize.  I was not implying that the VFS checks
> would be sufficient on their own.
> 

I've not really followed this thread completely but wouldn't this proposed
check in the VFS layer be redundant because the set of flags the filesystem
accepts should always be a strict subset of the VFS flags?

Ira
