Return-Path: <SRS0=OPd9=7K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31000C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 08:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 174E22088E
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 08:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgE1Iv7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 May 2020 04:51:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:4779 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbgE1Iv6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 May 2020 04:51:58 -0400
IronPort-SDR: W7K+mbNfT0VGiqnkrUtyaDjh6fvJJlgluSgFalbZq417VYuO5TgXiJaO0lsXVIxq657OkuL5Xk
 9/sth6IW2pbg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 01:51:58 -0700
IronPort-SDR: I71bXhPhg6bELK+m9aih2Vb8xUW5OFrn+GNkge/RZCpckNpNLVA/5AWlP+k9Jo3p4P907sA334
 31mdXSbmmo1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,444,1583222400"; 
   d="scan'208";a="291927400"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.3]) ([10.239.13.3])
  by fmsmga004.fm.intel.com with ESMTP; 28 May 2020 01:51:57 -0700
Subject: Re: [kbuild-all] Re: [dgc-xfs:xfs-async-inode-reclaim 28/30]
 fs/xfs/xfs_inode.c:3432:1: warning: no previous prototype for 'xfs_iflush'
To:     Dave Chinner <david@fromorbit.com>,
        kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-xfs@vger.kernel.org
References: <202005261941.GNNi105g%lkp@intel.com>
 <20200526221643.GZ2040@dread.disaster.area>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <a044ccc9-d83b-8a96-81b5-9aaad952387f@intel.com>
Date:   Thu, 28 May 2020 16:51:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20200526221643.GZ2040@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/27/20 6:16 AM, Dave Chinner wrote:
> On Tue, May 26, 2020 at 07:46:45PM +0800, kbuild test robot wrote:
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-async-inode-reclaim
> Hiya kbuild robot!
>
> Can you drop all the list cc's from build failures for this repo?
> Nobody but me really needs to see all the breakage in this tree...

Hi Dave,

Thanks for the feedback, we have marked the repo as private: 
https://github.com/intel/lkp-tests/blob/master/repo/linux/dgc-xfs

>
>> :::::: The code at line 3432 was first introduced by commit
>> :::::: 30ebf34422da6206608b0c6fba84b424f174b8c5 xfs: rename xfs_iflush_int()
>>
>> :::::: TO: Dave Chinner <dchinner@redhat.com>
>> :::::: CC: Dave Chinner <david@fromorbit.com>
> Also, I don't think this is doing what you expect, either, because
> this build error was only sent to david@fromorbit.com and was not
> CC'd to the author of the commit which is dchinner@redhat.com....

We have fixed it to avoid force changing "Dave Chinner" to "Dave Chinner 
<david@fromorbit.com>".

Best Regards,
Rong Chen

>
> Cheers,
>
> Dave.

