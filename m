Return-Path: <SRS0=cq6/=WO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DBDC3A589
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 07:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 732DE2086C
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 07:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfHRHLc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Aug 2019 03:11:32 -0400
Received: from verein.lst.de ([213.95.11.211]:38619 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbfHRHLc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 18 Aug 2019 03:11:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 919B1227A81; Sun, 18 Aug 2019 09:11:28 +0200 (CEST)
Date:   Sun, 18 Aug 2019 09:11:28 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "hch@lst.de" <hch@lst.de>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190818071128.GA17286@lst.de>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 08:59:44PM +0000, Verma, Vishal L wrote:
> Hi all,
> 
> When running the 'ndctl' unit tests against 5.3-rc kernels, I noticed a
> frequent failure of the 'mmap.sh' test [1][2].
> 
> [1]: https://github.com/pmem/ndctl/blob/master/test/mmap.sh
> [2]: https://github.com/pmem/ndctl/blob/master/test/mmap.c
> 
> But in trying to pare down the test further, I found that I can simply
> reproduce the problem by:
> 
>   mkfs.xfs -f /dev/pmem0
>   mount /dev/pmem0 /mnt/mem
> 
> Where 'pmem0' is a legacy pmem namespace from reserved memory using the
> memmap= command line option. (Specifically, I have this:
> memmap=3G!6G,3G!9G )
> 
> The above mkfs/mount steps don't reproduce the problem a 100% of the
> time, but it does happen on my qemu based setup over 75% of the times.
> 
> The kernel log shows the following when the mount fails:

Is it always that same message?  I'll see if I can reproduce it,
but I won't have that much memory to spare to create fake pmem,
hope this also works with a single device and/or less memory..
