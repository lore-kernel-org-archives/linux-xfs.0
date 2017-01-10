Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32993 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760041AbdAJIot (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 03:44:49 -0500
Date: Tue, 10 Jan 2017 16:44:47 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v4 00/47] xfs: online scrub/repair support
Message-ID: <20170110084447.GN1859@eguan.usersys.redhat.com>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
 <CAOQ4uxhhOqhsZwrncsfUmra9nLGKpF2mFGp35BuiPyucWkN1yw@mail.gmail.com>
 <20170109211540.GB14038@birch.djwong.org>
 <20170110075444.GL1859@eguan.usersys.redhat.com>
 <CAOQ4uxis3RwHSaTVqxmH0dNFLU4fVc0CtL2bCcsDgyMyaAfTRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxis3RwHSaTVqxmH0dNFLU4fVc0CtL2bCcsDgyMyaAfTRA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Jan 10, 2017 at 10:13:06AM +0200, Amir Goldstein wrote:
> On Tue, Jan 10, 2017 at 9:54 AM, Eryu Guan <eguan@redhat.com> wrote:
> > On Mon, Jan 09, 2017 at 01:15:40PM -0800, Darrick J. Wong wrote:
> >> On Mon, Jan 09, 2017 at 02:40:56PM +0200, Amir Goldstein wrote:
> >> > On Sat, Jan 7, 2017 at 2:35 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >> > > Hi all,
> >> > >
> >> > ...
> >> > > If you're going to start using this mess, you probably ought to just
> >> > > pull from my github trees.  The kernel patches[1] should apply against
> >> > > 4.10-rc2.  xfsprogs[2] and xfstests[3] can be found in their usual
> >> > > places.
> >> > >
> 
> Darick,
> 
> Not sure if this is interesting, but I had to 'make realclean' to xfsprogs,
> for make to build xfs_scrub (make clean was not enough).
> Is this the standard practice for building xfsprogs after checking out
> a new branch?
> 
> >> > > The patches have survived all auto group xfstests both with scrub-only
> >> > > mode and also a special debugging mode to xfs_scrub that forces it to
> >> > > rebuild the metadata structures even if they're not damaged.  Since the
> >> > > last patch release, I have now had time to run the new tests in [3] that
> >> > > try to fuzz every field in every data structure on disk.
> >> > >
> >> >
> >> > Darrick,
> >> >
> >> > I started running the dangerous_scrub group yersterday and it's killing my
> >> > test machine. The test machine is x86_64 (i5-3470) 16GB RAM
> >> > and test partitions are 100GB volume on spinning disk.
> >> >
> >> > xfs_db swaps my system to death and most of the tests it eventually
> >> > gets shot down by oom killer.
> >> >
> >> > Is that surprising to you?
> >>
> >> Yes.
> >
> > I hit OOM too in xfs/1301. (I ran xfs/13??, xfs/1300 passed and 1301
> > oom'ed the host, I haven't run other tests yet.)
> >
> 
> xfs/1300 passed for me as well. Note that it passed both with
> kernel scrubbing disabled and eanbled (XFS_DEBUG=y), but with kernel
> scrubbing it ran 7 seconds on my machine, while without kernel scrubbing
> it ran 70 seconds.
> 
> Eryu, you mentioned that you do not use XFS_DEBUG=y on a previous
> thread. Did you turn it on for the scrubbing tests? Although I think tests
> should be run with and without kernel scrubbing support. right?

You're right, I didn't turn on XFS_DEBUG, and I agreed that I should run
tests with and without online scurb support. I just haven't gone that
far yet. Thanks for the reminder!

Eryu
