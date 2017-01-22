Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34680 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdAVGKT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Jan 2017 01:10:19 -0500
MIME-Version: 1.0
In-Reply-To: <20170122050118.GL12985@birch.djwong.org>
References: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
 <CAOQ4uxgDPEQiC72-o7yt0P6o2xdVTb6kQNxoePOzYWRbCCXxKw@mail.gmail.com> <20170122050118.GL12985@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 22 Jan 2017 08:10:05 +0200
Message-ID: <CAOQ4uxggTXzQ0eFQkSOYeWD+TGDyDP6-AgUpd5zy9Bw0nWYiOA@mail.gmail.com>
Subject: Re: [PATCH v5 0/9] xfstests: online scrub/repair support
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Sun, Jan 22, 2017 at 7:01 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Sat, Jan 21, 2017 at 09:38:23PM +0200, Amir Goldstein wrote:
>> On Sat, Jan 21, 2017 at 10:10 AM, Darrick J. Wong
>> <darrick.wong@oracle.com> wrote:
>> > Hi all,
>> >
>> > This is the fifth revision of a patchset that adds to XFS userland tools
>> > support for online metadata scrubbing and repair.
>> >
>> > The new patches in this series do three things: first, they expand the
>> > filesystem populate commands inside xfstests to be able to create all
>> > types of XFS metadata.  Second, they create a bunch of xfs_db wrapper
>> > functions to iterate all fields present in a given metadata object and
>> > fuzz them in various ways.  Finally, for each metadata object type there
>> > is a separate test that iteratively fuzzes all fields of that object and
>> > runs it through the mount/scrub/repair loop to see what happens.
>> >
>> > If you're going to start using this mess, you probably ought to just
>> > pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
>> > The kernel patches in the git trees should apply to 4.10-rc4; xfsprogs
>> > patches to for-next; and xfstest to master.
>> >
>> > The patches have survived all auto group xfstests both with scrub-only
>> > mode and also a special debugging mode to xfs_scrub that forces it to
>> > rebuild the metadata structures even if they're not damaged.
>> >
>>
>> Darrick,
>>
>> xfs/1301 hogs every time at the same point in the test
>> after Fuzz dirblklog = middlebit, those are the last words in dmesg:
>> Log size 12800 blocks too small, minimum size is 23646 blocks
>> XFS (dm-2): AAIEEE! Log failed size checks. Abort!
>> XFS (dm-2): log mount failed
>
> Yeah.... there's some oddball problems in xfs_repair where directory
> related corruption causes it to misread directory free space so when it
> goes to add "unlinked" inodes to lost+found the process goes totally
> nuts and/or deadlocks on buffers.  I haven't had a chance to figure out
> what's causing /this/ particular problem, though..... :(
>

So I guess you are able to reproduce this.

Is there maybe a mode to run the tests where scrub will fix /this/ problem
before running xfs_repair, so xfs_repair won't go off the rails?
I had the impressions that this is what the scrub tests are supposed to do?
