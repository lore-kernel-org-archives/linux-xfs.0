Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51226 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727470AbeJAA26 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 30 Sep 2018 20:28:58 -0400
Subject: Re: [PATCH 2/2 V3] xfs: verify size-vs-format for symlinks & dirs
References: <ba65356c-2b57-75fb-0436-804913285809@redhat.com>
 <1e55b111-eae4-b0cf-0221-c96eb3f17b77@redhat.com>
 <20180930032553.GJ31060@dastard>
 <71034ef7-836b-a462-a4f9-53d9004339bc@sandeen.net>
 <20180930060520.GK31060@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <88c786c9-fb81-86d8-cd99-2e656619a2c1@sandeen.net>
Date: Sun, 30 Sep 2018 12:54:57 -0500
MIME-Version: 1.0
In-Reply-To: <20180930060520.GK31060@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, "Xu, Wen" <wen.xu@gatech.edu>

On 9/30/18 1:05 AM, Dave Chinner wrote:
> On Sun, Sep 30, 2018 at 12:06:44AM -0500, Eric Sandeen wrote:
>> On 9/29/18 10:25 PM, Dave Chinner wrote:
>>> On Mon, Sep 24, 2018 at 10:00:39PM -0500, Eric Sandeen wrote:
...

>>> So, yeah, I think that this check needs to be different because I
>>> think we could have symlinks as short at 56 bytes in extent format,
>>> even when the inode has no attribute fork...
>>
>> Hrmph.  And yet, xfs_repair:
>>
>> static int
>> process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
>> {
>>         xfs_fileoff_t           expected_offset;
>>         xfs_bmbt_rec_t          *rp;
>>         xfs_bmbt_irec_t         irec;
>>         int                     numrecs;
>>         int                     i;
>>         int                     max_blocks;
>>
>>         if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp)) {
>>                 if (dino->di_format == XFS_DINODE_FMT_LOCAL)
>>                         return 0;
>>                 do_warn(
>> _("mismatch between format (%d) and size (%" PRId64 ") in symlink ino %" PRIu64 "\n"),
>>                         dino->di_format,
>>                         (int64_t)be64_to_cpu(dino->di_size), lino);
>>                 return 1;
>>         }
>>
>> seems to clearly call "non-local symlink with size < XFS_DFORK_DSIZE" corruption.
>> What gives?
> 
> Seems to me like another cases that the verifiers have uncovered
> another situation that even repair doesn't handle correctly. (Which
> is why I like to look at these things from first principles, rather
> than just from the "what does reapir do" POV?). It's like to be rare
> because who removes all the attributes on a file apart from when
> unlinking the inode?

Sure, I get it that repair is not the canonical truth for format, I was
just surprised that you hit it fairly quickly with the kernel verifier,
but apparently didn't see it prior to this patch in a post-test repair run.
In fact I don't think I've ever seen this check fail in repair.  So it
just seemed odd.  It might be interesting to see if we can provoke it in
xfs_repair? 

> xfs_attr_fork_remove() has set the di_forkoff back to zero
> when the last attribute is removed from the inode for a long time
> (I stopped looking when I got to ~2008...), so this isn't a new
> situation. i.e. trying to define what are valid values has
> demonstrated that there are more cases we need to take into account
> than anyone has realised.

Yeah, I have a vague recollection of other bugs related to the fork
offset that led to the sense of nearly nondeterministic behavior for
when things move in and out of local.

-Eric
