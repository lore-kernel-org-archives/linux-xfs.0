Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F332D7CB9
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 13:36:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B3B208F804C
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 11:36:20 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id QMYVbQNUW09p4HQu (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Aug 2016 11:36:18 -0700 (PDT)
Date: Fri, 5 Aug 2016 11:36:14 -0700
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH v7 00/47] xfs: add reverse mapping support
Message-ID: <20160805183614.GL5316@wotan.suse.de>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<20160803194536.GJ5316@wotan.suse.de>
	<20160803205520.GQ8590@birch.djwong.org>
	<20160804005843.GJ8593@birch.djwong.org>
	<20160804021852.GK5316@wotan.suse.de>
	<20160804154845.GV8590@birch.djwong.org>
	<20160804235015.GC16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160804235015.GC16044@dastard>
Reply-To: Mark Fasheh <mfasheh@suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

Hi Dave!

On Fri, Aug 05, 2016 at 09:50:15AM +1000, Dave Chinner wrote:
> On Thu, Aug 04, 2016 at 08:48:45AM -0700, Darrick J. Wong wrote:
> > On Wed, Aug 03, 2016 at 07:18:52PM -0700, Mark Fasheh wrote:
> > > On Wed, Aug 03, 2016 at 05:58:43PM -0700, Darrick J. Wong wrote:
> > > > On Wed, Aug 03, 2016 at 01:55:20PM -0700, Darrick J. Wong wrote:
> > > > > On Wed, Aug 03, 2016 at 12:45:36PM -0700, Mark Fasheh wrote:
> > > > > > Where can I the patches to enable dedupe_range on xfs? I tested your
> > > > > > previous devel branch based on Linux v4.7-rc3 with duperemove
> > > > > > (https://github.com/markfasheh/duperemove) and it worked extremely well -
> > > > > > even handling some cases that btrfs still has issues with. I actually
> > > > > > committed the code to enable xfs support in duperemove so anyone can test on
> > > > > > xfs with the dedupe_range patches.
> > > > > > 
> > > > > > I'd gladly test your latest patches by doing my usual 'large' duperemove
> > > > > > tests once I can get ahold of the dedupe_range work :)
> > > > > 
> > > > > Your best bets are probably the -experimental trees:
> > > > > https://github.com/djwong/linux/commits/djwong-experimental
> > > > > https://github.com/djwong/xfsprogs/commits/djwong-experimental
> > > > > 
> > > > > I haven't updated them in a while because I've been busy trying
> > > > > to get reverse-mapping (the start of those patchbombs) into 4.8.
> > > > > 
> > > > > Just as a warning, don't put anything critical on those XFS filesystems
> > > > > because there's going to be a disk format update between now and the
> > > > > next time I post the patches because Dave and I decided to cache the
> > > > > block counts for the new btrees in order to speed up mounting.  I don't
> > > > > anticipate having time to clean up my dev tree and push to github until
> > > > > a week or two after the merge window closes.
> > > > 
> > > > That said, all the craziness from the last two weeks (xfs_scrub sprint
> > > > and the rmapbt review fixes) are now in the -wtf tree, which /should/
> > > > behave.  I've dumped everything there in completely not cleaned up
> > > > format, but this does have the AGF btree block counter stuff I talked
> > > > about above.
> > > > 
> > > > https://github.com/djwong/linux/commits/djwong-wtf
> > > > https://github.com/djwong/xfsprogs/commits/djwong-wtf
> > > 
> > > Fantastic. Don't worry about corrupting data, I've been doing this long
> > > enough to know to use this only on scratch partitions for now  :) I'm in the
> > > middle of a couple other tests but once I'm done there I'll grab those
> > > branches and give them another spin. Typically I'm running through 800G-1TB
> > > on these (with varying duplicated data percentages).
> > > 
> > > Silly question which I could just answer by looking at the patches - are you
> > > reporting FIEMAP_EXTENT_SHARED yet for extents with more than one owner? We
> > > use that flag (by comparing SHARED bytes before and after dedupe) to give
> > > people an estimate of how much space was saved. I presume figuring the
> > > shared state of an extent would be as easy as querying the rmap btree,
> > > correct?
> > 
> > Yes, it should report FIEMAP_EXTENT_SHARED.  In the past it would
> > report exactly which parts of an extent were shared.  If a file mapped
> > blocks 30-40 and block 35 was shared, it would report 30-34, 35
> > (shared), and 36-40.  However, btrfs only reports a single extent
> > "30-40 (shared)" so I stopped doing that.
> 
> I'd much prefer that fiemap gives exact information about shared
> extents. FIEMAP is a diagnostic tool and as such we need it to
> accurately reflect the exact extent map of the inode being queried
> so we aren't mislead about the layout of the file during trouble
> shooting.

I disagree about fiemap being a diagnostic tool. I mean it's perfectly
suitable for that task, but it has many uses outside of that.

In duperemove at least it's used to do things like look for holes and detect
already deduped extents (via physical offset). We also use EXTENT_SHARED to
get a rough estimate of space savings though that can be done in better
ways. It's a performance sensitive area too - there's currently bugs in
btrfs regarding fiemap taking too long (and one is actually blocking a
duperemove feature). Figuring EXTENT_SHARED for btrfs in particular is a
very cpu intensive process.

None of this is using fiemap to get physical access to an extent btw, which
is what I think you're most concerned with?

I totally agree about reporting EXTENT_SHARED as you want it to be. It would
actually make some parts of duperemove more accurate.

Thanks,
	--Mark

--
Mark Fasheh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
