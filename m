Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:45483 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753627AbeE3Tlj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 15:41:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
References: <000000000000457b2d056cbb0044@google.com>
        <20180522123107.GC3751@bfoster.bfoster>
        <20180522222620.GW23861@dastard>
        <20180522225208.GB658@sol.localdomain>
        <20180523074425.GM14384@magnolia>
        <20180523162015.GA3684@sol.localdomain>
        <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
        <20180523234114.GA3434@thunk.org> <20180524004931.GB23861@dastard>
        <20180524005906.GC3434@thunk.org>
Date: Wed, 30 May 2018 14:41:32 -0500
In-Reply-To: <20180524005906.GC3434@thunk.org> (Theodore Y. Ts'o's message of
        "Wed, 23 May 2018 20:59:06 -0400")
Message-ID: <87k1rlgccz.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: Bugs involving maliciously crafted file system
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> On Thu, May 24, 2018 at 10:49:31AM +1000, Dave Chinner wrote:
>> User automounting of removable storage should be done via a
>> privilege separation mechanism and hence avoid this whole class of
>> security problems. We can get this separation by using FUSE in these
>> situations, right?
>
> FUSE is a pretty terrible security boundary.  And not all file systems
> have FUSE support.  As I had suggested earlier, probably better to use
> 9P, and mount the file system in a VM.

I just have to ask.  Why do you find FUSE to be a pretty terrible
security boundary?

My experience with kernel's 9P implemenation is that it is scarier to
deal with, and that 9P is starting to suffer the maladies of an
unmaintained filesystem (which it is).

FUSE was always written with the assumption that it would be attacked by
malicious users and generally appears robust against that kind of thing.

The whole internet accessibleness of 9P while making it usable in VM's
generally looks like down-side as it adds a the whole issue of
malicious packets from a 3rd party that is neither client nor server to
deal with.

Eric




