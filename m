Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55414 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752084AbeBBXgl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Feb 2018 18:36:41 -0500
Subject: Re: XFS over device mapper dm-thin device
References: <147a1764-1988-4efd-4f02-e942a1001b4e@redhat.com>
 <20180202223541.i27bfjij7itt3q5r@destitution>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9c3ec8ff-3595-c889-3abe-7f069292be0d@sandeen.net>
Date: Fri, 2 Feb 2018 17:36:40 -0600
MIME-Version: 1.0
In-Reply-To: <20180202223541.i27bfjij7itt3q5r@destitution>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Todd Gill <tgill@redhat.com>
Cc: linux-xfs@vger.kernel.org



On 2/2/18 4:35 PM, Dave Chinner wrote:
> On Fri, Feb 02, 2018 at 04:45:33PM -0500, Todd Gill wrote:
>>
>> Hi,
>>
>> I'd like to be able to take a snapshot of an XFS filesystem on top of
>> dm-thin.
>>
>> The goal for the snapshot is:
>>
>>     - fast to complete (couple seconds or better)
>>     - independent of origin (UUID updated?)
>>     - read/write
>>
>> To satisfy the independent goal, I'm updating the UUID on the snapshot.
>> Currently "xfs_admin -U xxx" takes in the ballpark of 14 seconds on my
>> test system.
> 
> There's a very good chance that this is caused by dm-thinp doing
> COW for the storage underlying the superblocks modified by the UUID
> change.

It's actually because we rewrite the whole log, because it has the
user-facing superblock stamped in it.

I looked at this a bit, and didn't immediately see an easy way around
xfs_db's need to rewrite the whole log.

uuid_f()
                /* clear the log (setting uuid) if it's not dirty */
                if (!sb_logzero(&uu))
                        return 0;

so I think that's taking the bulk of the time.  I haven't looked closely
enough at all the mount-time log parsing to see if we could maybe write
less of it and still be valid.

> Best to start by measuring how much IO is going on when you change
> the UUID.  e.g. `iostat -x -d -m 1`. An strace showing how long the
> xfs_db read() and write() calls to the dm-thinp device would lso be
> instructive.
> 
>> Is there a better approach to achieve the goals?
> 
> No, you are doing the right thing.
> 
>> Or can the UUID update
>> be changed to be faster?
> 
> Not sure - there's a fixed amount of modification we need to make
> to change the UUID so I'm not sure there is any optimisations we
> can make here.

In retrospect I think we (I) should have left the "metadata" uuid as
the one to match the log, not the user-facing one.

I'm not sure there's a nice backwards-compatible way to un-ring
that bell, though.

-eric
