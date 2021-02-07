Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A08C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 22:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 033ED64E37
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 22:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhBGWyQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Feb 2021 17:54:16 -0500
Received: from sandeen.net ([63.231.237.45]:47376 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBGWyQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Feb 2021 17:54:16 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 503C533502A;
        Sun,  7 Feb 2021 16:51:21 -0600 (CST)
To:     Dave Chinner <david@fromorbit.com>,
        bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org, Pavel Reichl <preichl@redhat.com>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
 <20210207221505.GW4662@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [Bug 211605] New: Re-mount XFS causes "noattr2 mount option is
 deprecated" warning
Message-ID: <e83dce44-6120-e688-fec2-b0109cc6f617@sandeen.net>
Date:   Sun, 7 Feb 2021 16:53:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210207221505.GW4662@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/7/21 4:15 PM, Dave Chinner wrote:
> On Sun, Feb 07, 2021 at 05:06:36AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=211605
>>
>>             Bug ID: 211605
>>            Summary: Re-mount XFS causes "noattr2 mount option is
>>                     deprecated" warning
>>            Product: File System
>>            Version: 2.5
>>     Kernel Version: 5.10.13
>>           Hardware: All
>>                 OS: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: low
>>           Priority: P1
>>          Component: XFS
>>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>>           Reporter: cuihao.leo@gmail.com
>>         Regression: No
>>
...

> The kernel is warning about a mount option being specified that
> isn't even in the set emitted in /proc/mounts. Nor is it on your
> command line. Yet the kernel is warning about it, and that implies
> that mount has passed it to the kernel incorrectly.

I am confused about how "noattr2" showed up.

But we do still emit "attr2" in /proc/mounts, and a remount will complain
about /that/, so we do need to stop emitting deprecated options in /proc/mounts.

# mount /dev/pmem0p1 /mnt/test
# grep pmem /proc/mounts 
/dev/pmem0p1 /mnt/test xfs rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
# mount -o remount,ro /mnt/test
# dmesg | tail -n 1
[346311.064017] XFS: attr2 mount option is deprecated.

Pavel, can you fix this up, since your patch did the deprecations? I guess we
missed this on review.

Ideally the xfs(5) man page in xfsprogs should be updated as well to reflect the
deprecated items.


-Eric
