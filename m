Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433F8C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 09:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239736AbiFOJEu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 05:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347073AbiFOJEr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 05:04:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFF738DA8;
        Wed, 15 Jun 2022 02:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655283882; x=1686819882;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EC3lUDRYn/Bd7ujF8/UEUVR5Y3CabbrPrKBzudjmSHA=;
  b=dbUrw9yjBqpfOxQphGo5RicicGzgfAJemuCbvQV/Y0muBlB6TeyldELE
   AifohF8olN9amVqA25HCpohDrdzQzwRpsHIcIfFdHY4n0lNqtiJmqShxG
   2LfFt0cAO4ftWjpjPyJwWVZMTXj8XyxS0lGZX404QnoiiajqKxzPFRXkb
   Guwgdvr/cMITsHARn6+q9YVOQ8mk5g42hjaoN65ivWO4ZCB4e8OSAIeEH
   gxNwpUGDxoS1mqfxesqEyQoPZwFPZ7hzg8k68XVWj77tgiPU7zY7cqDGb
   uIsgfvMbPpHPL01VsL3lGzf7NGlwAfW0+3vmKgmP3b7yyRxeEYIH3tX6z
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="365240700"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="365240700"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 02:04:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="640885920"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 02:04:39 -0700
Date:   Wed, 15 Jun 2022 17:04:36 +0800
From:   Oliver Sang <oliver.sang@intel.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com
Subject: Re: [xfs]  5349b2afc1: xfstests.xfs.299.fail
Message-ID: <20220615090436.GH36441@xsang-OptiPlex-9020>
References: <20220602085053.GC27190@xsang-OptiPlex-9020>
 <20220602214037.GE1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602214037.GE1098723@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave Chinner,

On Fri, Jun 03, 2022 at 07:40:37AM +1000, Dave Chinner wrote:
> > 
> > xfs/299	- output mismatch (see /lkp/benchmarks/xfstests/results//xfs/299.out.bad)
> >     --- tests/xfs/299.out	2022-05-16 16:42:32.000000000 +0000
> >     +++ /lkp/benchmarks/xfstests/results//xfs/299.out.bad	2022-05-17 15:57:43.078827071 +0000
> >     @@ -6,6 +6,7 @@
> >      log      =LDEV bsize=XXX blocks=XXX
> >      realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> >      *** user, group, and project
> >     +xfs_quota: cannot set warnings: Invalid argument
> 
> Not a kernel issue - this is fixed in the latest fstests release.

got it! we upgraded our test package and now the test can pass on this commit
now. Thanks a lot!

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
