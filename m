Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ns3.fnarfbargle.com ([43.245.164.105]:56578 "EHLO
        ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754962AbeAMMvR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jan 2018 07:51:17 -0500
Subject: Re: Growing RAID10 with active XFS filesystem
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
 <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
 <20180111030723.GU16421@dastard> <5A58B901.7080609@youngman.org.uk>
 <20180112152538.2c4d8cd4@harpe.intellique.com>
 <5A58F5FB.7000101@youngman.org.uk>
 <20180112193710.1369f4ad@harpe.intellique.com>
 <8a8f7b91-80b5-3600-a82b-b55691d0ac6b@youngman.org.uk>
From: Brad Campbell <lists2009@fnarfbargle.com>
Message-ID: <268a13e5-5075-7fb9-caae-8ab281737ff2@fnarfbargle.com>
Date: Sat, 13 Jan 2018 20:30:01 +0800
MIME-Version: 1.0
In-Reply-To: <8a8f7b91-80b5-3600-a82b-b55691d0ac6b@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wol's lists <antlists@youngman.org.uk>, Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On 13/01/18 03:35, Wol's lists wrote:

> I'll get round to writing all this up soon, so the wiki will try and 
> persuade people that resizing arrays is not actually the brightest of 
> ideas.

Now hang on. Don't go tarring every use case with the same brush.

There are many use cases for a bucket of disks and high performance is 
but one of them.

Leaving aside XFS, let's look at EXT3/4 as they seem to be generally the 
most common filesystems in use for your average "install it and run it" 
user (ie *ME*).

If you read the mke2fs man page and check out stripe and stride (which 
you *used* to have to specify manually), both of them imply they are 
important for letting the filesystem know the construction of your RAID 
for *performance* reasons.

Nowhere does *anything* make any mention of changing geometry, and if 
you gave a 10 second thought to those parameters and their explanations 
you'd have to think "This filesystem was optimised for the RAID geometry 
it was built with. If I change that, then I won't have the same 
performance I did have at the time of creation". Or maybe that was only 
obvious to me.

Anyway, I happily grew several large arrays over the years *knowing* 
that there would be a performance impact, because for my use case I 
didn't actually care.

"Enterprise" don't grow arrays. They build a storage solution that is 
often extremely finely tuned for exactly their workload and they use it. 
If they need more storage they either replicate or build another (with 
the consequential months of tests/tuning) storage configuration. I see 
Stan Hoeppner replied. If you want a good read, get him going on 
workload specific XFS tuning.

It's only hacks like me that tack disks onto built arrays, but I did it 
*knowing* it wasn't going to affect my workload as all I wanted was a 
huge bucket of storage with quick reads. Writes don't happen often 
enough to matter.

Exposing the geometry to the filesystem is there to give the filesystem 
a chance of performing operations in a manner least likely to create a 
performance hotspot (as pointed out by Dave Chinner). They are hints. 
Change the geometry after the fact and all bets are off.

On another note, personally I've used XFS in a couple of performance 
sensitive roles over the years (when it *really* mattered), but as I 
don't often wade into that end of the pool I tend to stick with the ext 
series.

e2fsck has gotten me out of some really tight spots and I can rely on it 
making the best of a really bad mess. With XFS I've never had the 
pleasure of running it on anything other than top of the line hardware, 
so it never had to clean up after me. It does go like a stung cat though 
when it's tuned up.

If I were to suggest an addition to the RAID wiki, it'd be to elaborate 
on the *creation* time tuning a filesystem create tool does with the 
RAID geometry, and to point out that once you grow the RAID, all 
performance bets are off. I've never met a filesystem that would break 
however.

I've grown RAID 1, 5 & 6. Growing RAID10 with anything other than a near 
configuration and adding another set of disks just feels like a disaster 
waiting to happen. Even I'm not that game.

I do have a staging machine now with a few spare disks, so I might have 
a crack at it, but I won't be using a kernel and userspace as old as the 
thread initiator.

Regards,
Brad
