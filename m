Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF709C001E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 15:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbjGKPic (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 11:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbjGKPiF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 11:38:05 -0400
X-Greylist: delayed 370 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Jul 2023 08:37:29 PDT
Received: from railglorg.net (unknown [31.131.27.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198182695
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 08:37:28 -0700 (PDT)
Received: from [192.168.100.14] (unknown [193.165.96.69])
        by railglorg.net (Postfix) with ESMTPSA id 50F951A816
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 18:31:16 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=railglorg.net;
        s=server4; t=1689089476;
        bh=n3b6lSKgkFyI+rG0OspAIhGymWFN6R5dNOtObDC6laA=;
        h=Date:To:From:Subject:From;
        b=h4z5cMLxSAuMpDai7+Vyo0khVO73ZQ75GosF8s0Wv3U2rU7cNQFfuufpUQy5cmM8O
         hBYgRlBZPpACNvi2iuJntt797O3bTNsuIq9pBZEziaJ1LYyrudA47jlGYC7r/Jqd1F
         aI+TlyNBNlmhzIov92YPFyHCOh9f4CMeXSOisTzdz7c7ReaYG1orr4Nj+fcyJOyN4H
         7pUZO4c9h5vjXcL4QvYLyMs0L9NXjvqDLK5z4/J9x3mTnWbCOqi3BfMX8VfSq3ZcjJ
         dmcZtyjpdG1O7vu5ZLxQP8HZuZH0KeMj9gpgdn2hIpxmmqtMA5ehHvKeninN9WenL9
         rHibHlbeBXGJQ==
Message-ID: <583703ce-1515-a436-1f34-3386150a03c2@railglorg.net>
Date:   Tue, 11 Jul 2023 17:31:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To:     linux-xfs@vger.kernel.org
Content-Language: en-US, ru-RU
From:   "Eugene K." <eugene@railglorg.net>
Subject: XFS writing issue
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: railglorg.net;
        auth=pass smtp.auth=ek@railglorg.net smtp.mailfrom=eugene@railglorg.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

During investigation of flapping performance problem, it was detected 
that once a process writes big amount of data in a row, the filesystem 
focus on this writing and no other process can perform any IO on this 
filesystem.

We have noticed huge %iowait on software raid1 (mdraid) that runs on 2 
SSD drives - on every attempt to write more than 1GB.

The issue happens on any server running 6.4.2, 6.4.0, 6.3.3, 6.2.12 
kernel. Upon investigating and testing it appeared that server IO 
performance can be completely killed with a single command:

#cat /dev/zero > ./removeme

assuming the ~/removeme file resides on rootfs and rootfs is XFS.

While running this, the server becomes so unresponsive that after ~15 
seconds it's not even possible to login via ssh!

We did reproduce this on every machine with XFS as rootfs running 
mentioned kernels. However, when we converted rootfs from XFS to 
EXT4(and btrfs), the problem disappeared - with the same OS, same kernel 
binary, same hardware, just using ext4 or btrfs instead of xfs.

Note. During the hang and being unresponsive, SSD drives are writing 
data at expected performance. Just all the processes except the writing 
one hang.


