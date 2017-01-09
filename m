Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37541 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933659AbdAIVPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 16:15:44 -0500
Date: Mon, 9 Jan 2017 13:15:40 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4 00/47] xfs: online scrub/repair support
Message-ID: <20170109211540.GB14038@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
 <CAOQ4uxhhOqhsZwrncsfUmra9nLGKpF2mFGp35BuiPyucWkN1yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhhOqhsZwrncsfUmra9nLGKpF2mFGp35BuiPyucWkN1yw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 09, 2017 at 02:40:56PM +0200, Amir Goldstein wrote:
> On Sat, Jan 7, 2017 at 2:35 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > Hi all,
> >
> ...
> > If you're going to start using this mess, you probably ought to just
> > pull from my github trees.  The kernel patches[1] should apply against
> > 4.10-rc2.  xfsprogs[2] and xfstests[3] can be found in their usual
> > places.
> >
> > The patches have survived all auto group xfstests both with scrub-only
> > mode and also a special debugging mode to xfs_scrub that forces it to
> > rebuild the metadata structures even if they're not damaged.  Since the
> > last patch release, I have now had time to run the new tests in [3] that
> > try to fuzz every field in every data structure on disk.
> >
> 
> Darrick,
> 
> I started running the dangerous_scrub group yersterday and it's killing my
> test machine. The test machine is x86_64 (i5-3470) 16GB RAM
> and test partitions are 100GB volume on spinning disk.
> 
> xfs_db swaps my system to death and most of the tests it eventually
> gets shot down by oom killer.
> 
> Is that surprising to you?

Yes.

> How much RAM does you test systems have?

2GB in a VM so the host system won't go down.  Usually the test disks 
are 8GB disks to keep the fuzzer runtimes down, but I've also run them
against 100GB volumes without OOMing...

> Can you figure out a minimal RAM requirement to run these fuzzers
> and maybe check required RAM before running the test?

I wouldn't have thought xfs_check would OOM... it would help to know
exactly what the xfs_db invocation thought it was doing.

> Alternatively, can you figure out how to reduce the amount of RAM
> used by the fuzzer?
> 
> I was using mkfs options "-m rmapbt=1,reflink=1"
> and I tried running with and then without TEST_XFS_SCRUB=1.
> I don't see a reason to send the logs at this point, they are just a complete
> mass of destruction.

All the tests?  The full dmesg output would be useful to narrow it down to
a specific xfstest number, field name, and fuzz verb.  I'm running them

--D

> Let me know if you need more inputs from me.
> 
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
