Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44158 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752973AbdGSWAL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Jul 2017 18:00:11 -0400
Subject: Re: Collecting aged XFS profiles
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
 <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com>
 <20170717234814.GK17762@dastard>
 <CAAxjCEzP=bf5S12J8rTn7EyJK_MeM=t1JSa7pBzZyXK=9TrjQQ@mail.gmail.com>
 <bcb651de-75bf-97a6-7ed8-c083d2a440e5@sandeen.net>
 <CAAxjCEzZ2Q0wL=nhGVHVtK3M5Ws3MQdrUNKm3jJKO+1y-wxTkw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cb16e0b4-2ef2-cdef-e0e3-cf04abd3d4c6@sandeen.net>
Date: Wed, 19 Jul 2017 17:00:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAAxjCEzZ2Q0wL=nhGVHVtK3M5Ws3MQdrUNKm3jJKO+1y-wxTkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org

On 07/19/2017 04:08 PM, Stefan Ring wrote:
> On Wed, Jul 19, 2017 at 5:20 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 07/19/2017 02:59 AM, Stefan Ring wrote:
>>> I have created a metadump that is 1GB in size, xz-compressed. However,
>>> by running strings on it I find that there are many identifiable
>>> remains inside, and I cannot legally pass this on.
>>
>> newer metadump should correct that problem, and is a read-only tool,
>> so should be (tm) perfectly safe (tm).  You could run it out of a built
>> git repo, via the xfs_db commands.
>>
>>> The question is: can I import this metadata image in a VM and recreate
>>> the metadata image from there, using modern xfsprogs? Will this
>>> preserve most of the relevant information?
>>
>> yes, that would work too. (mdrestore followed by or piped through metadump)
>> If you find significant strings in that result please let me know :)
> 
> There is still quite a lot of stuff that should not be there (pasted
> selectively while scrolling over it via less):


> File names:
> 10-stdio
> 6-log-shell_2-stdio.bz2
> 8-log-shell_4-stdio
> :(%40-log-MasterShellCommand_1-stdio.bz2

<snip way too many strings>

> 
> I used the current git version like this:
> ./db/xfs_db -f -i -p xfs_metadump -c "metadump -e -g -w -"
> xfs-meta.rawimg | strings

ok, that shoulda worked... I wonder how to debug this, if you can't
legally share the problematic image with me to investigate...

I put a lot of effort into selectively zeroing out unused portions
of metablocks a couple years back, I am surprised that this much remains.

I wonder if something regressed ...

-Eric

> commit e116c5c4511bbc2d98579817232258d57a1f1777
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Fri May 5 13:25:49 2017 -0500
