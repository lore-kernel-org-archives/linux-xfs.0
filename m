Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E32C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 15:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D112560F4C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 15:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242911AbhHZPFt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 11:05:49 -0400
Received: from sandeen.net ([63.231.237.45]:49334 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231793AbhHZPFs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Aug 2021 11:05:48 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 91E0779F9;
        Thu, 26 Aug 2021 10:04:39 -0500 (CDT)
To:     Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org
References: <20210826020637.GA2402680@onthe.net.au>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS fallocate implementation incorrectly reports ENOSPC
Message-ID: <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
Date:   Thu, 26 Aug 2021 10:05:00 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826020637.GA2402680@onthe.net.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/25/21 9:06 PM, Chris Dunlop wrote:
> Hi,
> 
> As reported by Charles Hathaway here (with no resolution):
> 
> XFS fallocate implementation incorrectly reports ENOSPC
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1791323
> 
> Given this sequence:
> 
> fallocate -l 1GB image.img
> mkfs.xfs -f image.img
> mkdir mnt
> mount -o loop ./image.img mnt
> fallocate -o 0 -l 700mb mnt/image.img
> fallocate -o 0 -l 700mb mnt/image.img
> 
> Why does the second fallocate fail with ENOSPC, and is that considered an XFS bug?

Interesting.  Off the top of my head, I assume that xfs is not looking at
current file space usage when deciding how much is needed to satisfy the
fallocate request.  While filesystems can return ENOSPC at any time for
any reason, this does seem a bit suboptimal.
  
> Ext4 is happy to do the second fallocate without error.
> 
> Tested on linux-5.10.60
> 
> Background: I'm chasing a mysterious ENOSPC error on an XFS filesystem with way more space than the app should be asking for. There are no quotas on the fs. Unfortunately it's a third party app and I can't tell what sequence is producing the error, but this fallocate issue is a possibility.

Presumably you've tried stracing it and looking for ENOSPC returns from
syscalls?

-Eric
