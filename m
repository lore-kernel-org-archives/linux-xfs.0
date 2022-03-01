Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4307BC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 19:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiCATcM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 14:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235936AbiCATcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 14:32:11 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 811504F9EA
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 11:31:29 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1105922CF;
        Tue,  1 Mar 2022 13:30:28 -0600 (CST)
Message-ID: <01d6be65-f65c-790e-73fb-9529a94673eb@sandeen.net>
Date:   Tue, 1 Mar 2022 13:31:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Content-Language: en-US
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
 <159477799812.3263162.13957383827318048593.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Quota warning woes (was: [PATCH 25/26] xfs: actually bump warning
 counts when we send warnings)
In-Reply-To: <159477799812.3263162.13957383827318048593.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/14/20 8:53 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, xfs quotas have the ability to send netlink warnings when a
> user exceeds the limits.  They also have all the support code necessary
> to convert softlimit warnings into failures if the number of warnings
> exceeds a limit set by the administrator.  Unfortunately, we never
> actually increase the warning counter, so this never actually happens.
> Make it so we actually do something useful with the warning counts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Sooo I got a bug report that this essentially breaks the timer for
soft quota, because we now (and quite rapidly) hit the default
5-warning limit well before we hit any reasonable timer that may
have been set, and disallow more space usage.

And those warnings rack up in somewhat unexpected (to me, anyway)
ways. With a default max warning count of 5, I go over soft quota
exactly once, touch/create 2 more empty inodes, and I'm done:

# rm -f /mnt/xfs/*
# xfs_quota -x -c 'report -h' /mnt/xfs
User quota on /mnt/xfs (/dev/loop1)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  05 [0 days]
quota_test      0     1M   550M  00 [------]

# sudo -u quota_test dd bs=1100k count=1 if=/dev/zero of=/mnt/xfs/test
1126400 bytes (1.1 MB) copied, 0.00136115 s, 828 MB/s

# xfs_quota -x -c 'report -h' /mnt/xfs
User quota on /mnt/xfs (/dev/loop1)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  05 [0 days]
quota_test   1.1M     1M   550M  01 [------]

# sudo -u quota_test touch /mnt/xfs/a
# xfs_quota -x -c 'report -h' /mnt/xfs
User quota on /mnt/xfs (/dev/loop1)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  05 [0 days]
quota_test   1.1M     1M   550M  03 [6 days]

# sudo -u quota_test touch /mnt/xfs/b
# xfs_quota -x -c 'report -h' /mnt/xfs
User quota on /mnt/xfs (/dev/loop1)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  05 [0 days]
quota_test   1.1M     1M   550M  05 [6 days]

# sudo -u quota_test touch /mnt/xfs/c
touch: cannot touch ‘/mnt/xfs/c’: Disk quota exceeded

And the xfs_quota manpage doesn't even say that this is supposed
to be a transition to a hard limit, although the code does seem
to think so ...

"Allows the quota warnings limit (i.e. the number of times a warning
will be send to someone over quota) to be viewed and modified."

There are other oddities too, like a (default) 0 day timer means
"no timer" but a 0 warning count means "you get no warnings.
you're done when you hit the soft quota."

And the xfs_quota interface for setting the warnings is unexpectedly
different from the interface for timers, as well.

So ... thoughts? 

TBH I'd almost suggest reverting the increment until this is sorted,
but I presume you changed this for a reason. :) (And it's been there
a pretty long time, now.)

Thanks,
-Erifc
