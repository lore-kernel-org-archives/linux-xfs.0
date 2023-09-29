Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D94E71D3D
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 14:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjI2OWR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 10:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbjI2OWN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 10:22:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E193B1AC
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 07:22:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1357DC433C7;
        Fri, 29 Sep 2023 14:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695997331;
        bh=ALDhPabcaxYCJi2SBSN5TBBz4A8vX5TsDjVKMZrqKHI=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=sYi/614TzvOztdvAvktP7VMP18Z9yVg9t2v1ar+a+L/ojDo/EmMa8/afbzOW1GnQ1
         6rHJD3L+3OR+t1tMGHxkeitFucJo3/dlqOdnFh1L4ybd+72LSazIzd8Lmh6LRqeRSW
         y6SQf+O4L2fOtbSW14tyR1BL7FYikmqKbkms4aHLUJZRw3w/IF60OqU8OpracUioJt
         Wf31/E3m3cPQ2d/CytWs2y9yilukGSvHgp1jK1XCiauMb5kaD8KGOcs8KoF3Bf5pVc
         7valCMjebEKhgWvK1znV+gZDYYWj0WM9rk24lOGn4OWHw+4CTybZBGnK8yqxcPSh9L
         KwLbuDCib8ibA==
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
 <20230926145519.GE11439@frogsfrogsfrogs>
 <ZROC8hEabAGS7orb@dread.disaster.area>
 <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        nvdimm@lists.linux.dev, dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Date:   Fri, 29 Sep 2023 19:47:07 +0530
In-reply-to: <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
Message-ID: <87msx5f4a8.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 28, 2023 at 09:20:52 AM -0700, Andrew Morton wrote:
> On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
>> But please pick the following patch[1] as well, which fixes failures of 
>> xfs55[0-2] cases.
>> 
>> [1] 
>> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com
>
> I guess I can take that xfs patch, as it fixes a DAX patch.  I hope the xfs team
> are watching.
>
> But
>
> a) I'm not subscribed to linux-xfs and
>
> b) the changelog fails to describe the userspace-visible effects of
>    the bug, so I (and others) are unable to determine which kernel
>    versions should be patched.
>
> Please update that changelog and resend?

I will apply "xfs: correct calculation for agend and blockcount" patch to
xfs-linux Git tree and include it for the next v6.6 pull request to Linus.

At the outset, It looks like I can pick "mm, pmem, xfs: Introduce
MF_MEM_PRE_REMOVE for unbind"
(i.e. https://lore.kernel.org/linux-xfs/20230928103227.250550-1-ruansy.fnst@fujitsu.com/T/#u)
patch for v6.7 as well. But that will require your Ack. Please let me know
your opinion.

Also, I will pick "xfs: drop experimental warning for FSDAX" patch for v6.7.

-- 
Chandan
