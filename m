Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31234 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939984AbdAJSUP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 13:20:15 -0500
Date: Tue, 10 Jan 2017 10:20:06 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4 00/47] xfs: online scrub/repair support
Message-ID: <20170110182006.GJ14038@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
 <CAOQ4uxhhOqhsZwrncsfUmra9nLGKpF2mFGp35BuiPyucWkN1yw@mail.gmail.com>
 <20170109211540.GB14038@birch.djwong.org>
 <20170110075444.GL1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170110075444.GL1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Tue, Jan 10, 2017 at 03:54:44PM +0800, Eryu Guan wrote:
> On Mon, Jan 09, 2017 at 01:15:40PM -0800, Darrick J. Wong wrote:
> > On Mon, Jan 09, 2017 at 02:40:56PM +0200, Amir Goldstein wrote:
> > > On Sat, Jan 7, 2017 at 2:35 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > > Hi all,
> > > >
> > > ...
> > > > If you're going to start using this mess, you probably ought to just
> > > > pull from my github trees.  The kernel patches[1] should apply against
> > > > 4.10-rc2.  xfsprogs[2] and xfstests[3] can be found in their usual
> > > > places.
> > > >
> > > > The patches have survived all auto group xfstests both with scrub-only
> > > > mode and also a special debugging mode to xfs_scrub that forces it to
> > > > rebuild the metadata structures even if they're not damaged.  Since the
> > > > last patch release, I have now had time to run the new tests in [3] that
> > > > try to fuzz every field in every data structure on disk.
> > > >
> > > 
> > > Darrick,
> > > 
> > > I started running the dangerous_scrub group yersterday and it's killing my
> > > test machine. The test machine is x86_64 (i5-3470) 16GB RAM
> > > and test partitions are 100GB volume on spinning disk.
> > > 
> > > xfs_db swaps my system to death and most of the tests it eventually
> > > gets shot down by oom killer.
> > > 
> > > Is that surprising to you?
> > 
> > Yes.
> 
> I hit OOM too in xfs/1301. (I ran xfs/13??, xfs/1300 passed and 1301
> oom'ed the host, I haven't run other tests yet.)
> 
> > 
> > > How much RAM does you test systems have?
> > 
> > 2GB in a VM so the host system won't go down.  Usually the test disks 
> > are 8GB disks to keep the fuzzer runtimes down, but I've also run them
> > against 100GB volumes without OOMing...
> > 
> > > Can you figure out a minimal RAM requirement to run these fuzzers
> > > and maybe check required RAM before running the test?
> > 
> > I wouldn't have thought xfs_check would OOM... it would help to know
> > exactly what the xfs_db invocation thought it was doing.
> 
> My test host has 64G memory, it's running on a 15G SCRATCH_DEV.

Aha, I /have/ been hitting OOM, but it got lost in the noise.

> > > Alternatively, can you figure out how to reduce the amount of RAM
> > > used by the fuzzer?
> > > 
> > > I was using mkfs options "-m rmapbt=1,reflink=1"
> > > and I tried running with and then without TEST_XFS_SCRUB=1.
> > > I don't see a reason to send the logs at this point, they are just a complete
> > > mass of destruction.
> > 
> > All the tests?  The full dmesg output would be useful to narrow it down to
> > a specific xfstest number, field name, and fuzz verb.  I'm running them
> 
> In my case, the xfs_db command is doing
> 
> /usr/sbin/xfs_db -x -c sb 0 -c fuzz /dev/mapper/systemvg-testlv2
> 
> I attached console log and xfs-1301.full I have so far.

Aha, thank you.

> Thanks,
> Eryu
>
> Fields we propose to fuzz under: sb 0
> xfs_db>
> blocksize
> dblocks
<snip>
> Field agblocks already set to , skipping test.
> + Fuzz agcount = zeroes
> ========================
> xfs_db> xfs_db> Allowing fuzz of corrupted data with good CRC
> agcount = 0
> xfs_db> 
> 
> Field agcount already set to , skipping test.
> + Fuzz agcount = ones
> ========================
> xfs_db> xfs_db> Allowing fuzz of corrupted data with good CRC
> agcount = null
> xfs_db> 
> 
> Field agcount already set to , skipping test.
> + Fuzz agcount = firstbit
> ========================
> xfs_db> xfs_db> Allowing fuzz of corrupted data with good CRC
> agcount = 2147483664
> xfs_db> 
> 
> Field agcount already set to , skipping test.
> + Fuzz agcount = middlebit
> ========================
> xfs_db> xfs_db> Allowing fuzz of corrupted data with good CRC
> agcount = 32784
> xfs_db> 
> 
> Field agcount already set to , skipping test.
> + Fuzz agcount = lastbit
> ========================
> xfs_db> xfs_db> Allowing fuzz of corrupted data with good CRC
> agcount = 17
> xfs_db> 
> 
> Field agcount already set to , skipping test.
> + Fuzz agcount = add
> ========================
> xfs_db> xfs_db> Allowing fuzz of corrupted data with good CRC
> agcount = 2033
> xfs_db> 
> 
> Field agcount already set to , skipping test.
> + Fuzz agcount = sub
> ========================
> xfs_db> xfs_db> Allowing fuzz of corrupted data with good CRC
> agcount = 4294965295
> xfs_db> 
> 
> Field agcount already set to , skipping test.
> + Fuzz agcount = random
> ========================
> xfs_db> xfs_db> Allowing fuzz of corrupted data with good CRC
> agcount = 1858079377
> xfs_db> 
> 
> Field agcount already set to , skipping test.

Now I see what the problem is.  We set an insane number of AGs.  The
next thing we try to do is read the fuzzed value back from the sb, which
fires up another xfs_db instance.  That instance thinks we have
1,858,079,377 AGs and tries to allocate per-ag data for all of them and
OOMs the system, causing xfs_db to fail.

Fortunately the kernel and xfs_repair notice the broken geometry and
handle it nicely, but that leaves xfs_db unable to deal with it.  We
could clamp agcount to a "reasonable" value, though it isn't clear what
that means if agblocks is also insane.

OTOH xfs_db AFAIK doesn't use the in-core perag stuff anyway so maybe
setting agcount to 0 is reasonable enough(???)  Will experiment with
this and report back.

--D
