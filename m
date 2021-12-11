Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1B0C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Dec 2021 05:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhLKFzh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Dec 2021 00:55:37 -0500
Received: from sandeen.net ([63.231.237.45]:52466 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229502AbhLKFzh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Dec 2021 00:55:37 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 27F7215B3D;
        Fri, 10 Dec 2021 23:55:23 -0600 (CST)
Message-ID: <bbd87708-f36b-2782-0fea-eee0fd2cb0cf@sandeen.net>
Date:   Fri, 10 Dec 2021 23:55:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: XFS journal log resetting
Content-Language: en-US
To:     Chanchal Mathew <chanch13@gmail.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20211210213649.GQ449541@dread.disaster.area>
 <24D44CB5-F383-4F2A-B9C3-87770DFD7CDB@gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <24D44CB5-F383-4F2A-B9C3-87770DFD7CDB@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/10/21 6:09 PM, Chanchal Mathew wrote:
> Thank you for the explanation!
> 
> Wouldn’t we expect zero pending modification or no unwritten data when a device is cleanly unmounted? Or do you mean, a successful ‘umount’ run on the device doesn’t guarantee there are no pending changes?
> 
> The devices I’m testing on are image files with same amount of data. One with lower log number is quicker to mount.
> 
> $ sudo xfs_logprint -t /dev/mapper/loop0p1
> …
>      log tail: 451 head: 451 state: <CLEAN>
> 
> 
> Whereas, the one with higher log number, such as the one below, is about 4-5 times slower running xlog_find_tail().
> 
> $ sudo xfs_logprint -t /dev/mapper/loop0p1
> …
>      log tail: 17658 head: 17658 state: <CLEAN>
> 

What is the geometry of these filesystems (xfs_info) and how much delay are we talking
about here, in wall clock time?

-Eric

> The images are of same size, and have same amount of data as well (as verified by df and df -i once mounted)
> 
> The only way I can work around this delay for an instance started from an image file with higher log number is, to reset it to 0 with xfs_repair.
> 
> 
> 
> Chanchal
> 
