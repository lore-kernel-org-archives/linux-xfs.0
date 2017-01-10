Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36491 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933016AbdAJINV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 03:13:21 -0500
Received: by mail-oi0-f66.google.com with SMTP id u143so20112486oif.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 00:13:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170110075444.GL1859@eguan.usersys.redhat.com>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
 <CAOQ4uxhhOqhsZwrncsfUmra9nLGKpF2mFGp35BuiPyucWkN1yw@mail.gmail.com>
 <20170109211540.GB14038@birch.djwong.org> <20170110075444.GL1859@eguan.usersys.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Jan 2017 10:13:06 +0200
Message-ID: <CAOQ4uxis3RwHSaTVqxmH0dNFLU4fVc0CtL2bCcsDgyMyaAfTRA@mail.gmail.com>
Subject: Re: [PATCH v4 00/47] xfs: online scrub/repair support
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Jan 10, 2017 at 9:54 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Mon, Jan 09, 2017 at 01:15:40PM -0800, Darrick J. Wong wrote:
>> On Mon, Jan 09, 2017 at 02:40:56PM +0200, Amir Goldstein wrote:
>> > On Sat, Jan 7, 2017 at 2:35 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>> > > Hi all,
>> > >
>> > ...
>> > > If you're going to start using this mess, you probably ought to just
>> > > pull from my github trees.  The kernel patches[1] should apply against
>> > > 4.10-rc2.  xfsprogs[2] and xfstests[3] can be found in their usual
>> > > places.
>> > >

Darick,

Not sure if this is interesting, but I had to 'make realclean' to xfsprogs,
for make to build xfs_scrub (make clean was not enough).
Is this the standard practice for building xfsprogs after checking out
a new branch?

>> > > The patches have survived all auto group xfstests both with scrub-only
>> > > mode and also a special debugging mode to xfs_scrub that forces it to
>> > > rebuild the metadata structures even if they're not damaged.  Since the
>> > > last patch release, I have now had time to run the new tests in [3] that
>> > > try to fuzz every field in every data structure on disk.
>> > >
>> >
>> > Darrick,
>> >
>> > I started running the dangerous_scrub group yersterday and it's killing my
>> > test machine. The test machine is x86_64 (i5-3470) 16GB RAM
>> > and test partitions are 100GB volume on spinning disk.
>> >
>> > xfs_db swaps my system to death and most of the tests it eventually
>> > gets shot down by oom killer.
>> >
>> > Is that surprising to you?
>>
>> Yes.
>
> I hit OOM too in xfs/1301. (I ran xfs/13??, xfs/1300 passed and 1301
> oom'ed the host, I haven't run other tests yet.)
>

xfs/1300 passed for me as well. Note that it passed both with
kernel scrubbing disabled and eanbled (XFS_DEBUG=y), but with kernel
scrubbing it ran 7 seconds on my machine, while without kernel scrubbing
it ran 70 seconds.

Eryu, you mentioned that you do not use XFS_DEBUG=y on a previous
thread. Did you turn it on for the scrubbing tests? Although I think tests
should be run with and without kernel scrubbing support. right?

>>
>> > How much RAM does you test systems have?
>>
>> 2GB in a VM so the host system won't go down.  Usually the test disks
>> are 8GB disks to keep the fuzzer runtimes down, but I've also run them
>> against 100GB volumes without OOMing...
>>
>> > Can you figure out a minimal RAM requirement to run these fuzzers
>> > and maybe check required RAM before running the test?
>>
>> I wouldn't have thought xfs_check would OOM... it would help to know
>> exactly what the xfs_db invocation thought it was doing.
>
> My test host has 64G memory, it's running on a 15G SCRATCH_DEV.
>
>>
>> > Alternatively, can you figure out how to reduce the amount of RAM
>> > used by the fuzzer?
>> >
>> > I was using mkfs options "-m rmapbt=1,reflink=1"
>> > and I tried running with and then without TEST_XFS_SCRUB=1.
>> > I don't see a reason to send the logs at this point, they are just a complete
>> > mass of destruction.
>>
>> All the tests?  The full dmesg output would be useful to narrow it down to
>> a specific xfstest number, field name, and fuzz verb.  I'm running them
>

In my case, yes, most of the test (51 out of 65) failed due to
some sort of crash, but the entire system is so unstable due to all the OOM
killing that the entire dmesg output is a big mess.

I'll rerun only 1301 to send my logs.


> In my case, the xfs_db command is doing
>
> /usr/sbin/xfs_db -x -c sb 0 -c fuzz /dev/mapper/systemvg-testlv2
>
> I attached console log and xfs-1301.full I have so far.
>
> Thanks,
> Eryu
