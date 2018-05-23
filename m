Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43948 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753147AbeEWCUB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 May 2018 22:20:01 -0400
Subject: Re: Deleting a project from XFS quotas
References: <d30e573b-9c2a-cf97-7608-ad10a7b1b21c@gn.apc.org>
 <20180523002552.GY23861@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0862c878-38bb-8af3-be83-d5e6c7dac282@sandeen.net>
Date: Tue, 22 May 2018 21:19:59 -0500
MIME-Version: 1.0
In-Reply-To: <20180523002552.GY23861@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Ian Macdonald <imac@gn.apc.org>
Cc: linux-xfs@vger.kernel.org

On 5/22/18 7:25 PM, Dave Chinner wrote:
> On Tue, May 22, 2018 at 10:46:28AM +0200, Ian Macdonald wrote:

...

  
> I don't know if reporting these empty quota IDs is intentional or
> what you need to do to avoid having them reported - someone involved
> in changing the dquot iteration mechanism will have to chime in on
> that....

<someone chimes in>

If a quota exists on disk with a limit, it should be shown
even if it doesn't happen to be in the projects file; in fact the
projects(5) man page says the file itself is optional.

And Ian's quotas weren't exactly empty, they were actual quotas with
limits set, even if there was no current usage under that ID.
So I think it makes sense to show them  (we would have if they were
in /etc/projects, right?)

Anyway, if you have a quota showing up for an ID that's not in
the projects file:

# xfs_quota -x -c 'limit -p bhard=1g 42' /mnt/test
# xfs_quota -x -c report /mnt/test
Project quota on /mnt/test (/dev/pmem0p1)
                                Blocks
Project ID       Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
#0                  0          0          0     00 [--------]
#42                 0          0    1048576     00 [--------]

You can make it disappear by setting its limits to zero:

# xfs_quota -x -c 'limit -p bhard=0 42' /mnt/test
# xfs_quota -x -c report /mnt/test
Project quota on /mnt/test (/dev/pmem0p1)
                                Blocks
Project ID       Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
#0                  0          0          0     00 [--------]

-Eric
