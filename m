Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17915 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754246AbcJTHu6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2016 03:50:58 -0400
Subject: Re: About reflink len = 0 behavior
References: <bedcb76a-4deb-bc0e-7a50-350a8a8db86f@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <94d643cc-fa49-4b20-b265-55d50af15e47@cn.fujitsu.com>
Date: Thu, 20 Oct 2016 15:50:46 +0800
MIME-Version: 1.0
In-Reply-To: <bedcb76a-4deb-bc0e-7a50-350a8a8db86f@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>, linux-xfs@vger.kernel.org

Add cc to new xfs mail list.


At 10/20/2016 03:46 PM, Qu Wenruo wrote:
> Hi Darrick, xfs guys and btrfs guys.
>
> Although such question is quite late as reflink generic tests are in
> fstests for a long time, I'm still not sure what's the correct behavior
> for reflink len = 0.
>
> Test case generic/182 is causing different output between btrfs and xfs.
>
> For btrfs, dedupe will just return 0 and check nothing, while for xfs
> len == 0 means to check the whole file length.
>
> Both makes sense for me, for btrfs len = 0 behavior, it just follows
> read/write functions.
> And I assume xfs follows reflink behavior, when len is not specified,
> then reflink the length of src file.
>
> But since it's a generic test, we need to unify the behavior.
>
> So, which one is the standard and which document should we follow for
> such behavior definition?
>
> Thanks,
> Qu
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


