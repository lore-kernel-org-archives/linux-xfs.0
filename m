Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CAB5C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 20:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DC0061038
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 20:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhHZU50 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 16:57:26 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:42278 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhHZU50 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Aug 2021 16:57:26 -0400
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 77C8661C59;
        Fri, 27 Aug 2021 06:56:36 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id EcyGEPEuEhXP; Fri, 27 Aug 2021 06:56:36 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id A12CB61C58;
        Fri, 27 Aug 2021 06:56:35 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 8630A680468; Fri, 27 Aug 2021 06:56:35 +1000 (AEST)
Date:   Fri, 27 Aug 2021 06:56:35 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS fallocate implementation incorrectly reports ENOSPC
Message-ID: <20210826205635.GA2453892@onthe.net.au>
References: <20210826020637.GA2402680@onthe.net.au>
 <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 26, 2021 at 10:05:00AM -0500, Eric Sandeen wrote:
> On 8/25/21 9:06 PM, Chris Dunlop wrote:
>>
>> fallocate -l 1GB image.img
>> mkfs.xfs -f image.img
>> mkdir mnt
>> mount -o loop ./image.img mnt
>> fallocate -o 0 -l 700mb mnt/image.img
>> fallocate -o 0 -l 700mb mnt/image.img
>>
>> Why does the second fallocate fail with ENOSPC, and is that considered an XFS bug?
>
> Interesting.  Off the top of my head, I assume that xfs is not looking at
> current file space usage when deciding how much is needed to satisfy the
> fallocate request.  While filesystems can return ENOSPC at any time for
> any reason, this does seem a bit suboptimal.

Yes, I would have thought the second fallocate should be a noop.

>> Background: I'm chasing a mysterious ENOSPC error on an XFS filesystem 
>> with way more space than the app should be asking for. There are no 
>> quotas on the fs. Unfortunately it's a third party app and I can't tell 
>> what sequence is producing the error, but this fallocate issue is a 
>> possibility.
>
> Presumably you've tried stracing it and looking for ENOSPC returns from
> syscalls?

That would be an obvious approach. Unfortunately it's not that easy. The 
problem is associated with one specific client which is out of my control 
so I can't experiment in a controlled environment. The app runs for 
several hours in multiple phases, each with multiple threads, and the 
problem typically occurs in the early hours of the morning after several 
hours of running, so attaching to the correct instance is fraught, and the 
strace output will be voluminous.

Cheers,

Chris
