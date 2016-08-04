Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 86E207CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 21:19:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B1D1304032
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 19:18:59 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id UJ3eewtmwxH9Rhkf (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 19:18:56 -0700 (PDT)
Date: Wed, 3 Aug 2016 19:18:52 -0700
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH v7 00/47] xfs: add reverse mapping support
Message-ID: <20160804021852.GK5316@wotan.suse.de>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<20160803194536.GJ5316@wotan.suse.de>
	<20160803205520.GQ8590@birch.djwong.org>
	<20160804005843.GJ8593@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160804005843.GJ8593@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 05:58:43PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 03, 2016 at 01:55:20PM -0700, Darrick J. Wong wrote:
> > On Wed, Aug 03, 2016 at 12:45:36PM -0700, Mark Fasheh wrote:
> > > Where can I the patches to enable dedupe_range on xfs? I tested your
> > > previous devel branch based on Linux v4.7-rc3 with duperemove
> > > (https://github.com/markfasheh/duperemove) and it worked extremely well -
> > > even handling some cases that btrfs still has issues with. I actually
> > > committed the code to enable xfs support in duperemove so anyone can test on
> > > xfs with the dedupe_range patches.
> > > 
> > > I'd gladly test your latest patches by doing my usual 'large' duperemove
> > > tests once I can get ahold of the dedupe_range work :)
> > 
> > Your best bets are probably the -experimental trees:
> > https://github.com/djwong/linux/commits/djwong-experimental
> > https://github.com/djwong/xfsprogs/commits/djwong-experimental
> > 
> > I haven't updated them in a while because I've been busy trying
> > to get reverse-mapping (the start of those patchbombs) into 4.8.
> > 
> > Just as a warning, don't put anything critical on those XFS filesystems
> > because there's going to be a disk format update between now and the
> > next time I post the patches because Dave and I decided to cache the
> > block counts for the new btrees in order to speed up mounting.  I don't
> > anticipate having time to clean up my dev tree and push to github until
> > a week or two after the merge window closes.
> 
> That said, all the craziness from the last two weeks (xfs_scrub sprint
> and the rmapbt review fixes) are now in the -wtf tree, which /should/
> behave.  I've dumped everything there in completely not cleaned up
> format, but this does have the AGF btree block counter stuff I talked
> about above.
> 
> https://github.com/djwong/linux/commits/djwong-wtf
> https://github.com/djwong/xfsprogs/commits/djwong-wtf

Fantastic. Don't worry about corrupting data, I've been doing this long
enough to know to use this only on scratch partitions for now  :) I'm in the
middle of a couple other tests but once I'm done there I'll grab those
branches and give them another spin. Typically I'm running through 800G-1TB
on these (with varying duplicated data percentages).

Silly question which I could just answer by looking at the patches - are you
reporting FIEMAP_EXTENT_SHARED yet for extents with more than one owner? We
use that flag (by comparing SHARED bytes before and after dedupe) to give
people an estimate of how much space was saved. I presume figuring the
shared state of an extent would be as easy as querying the rmap btree,
correct?
	--Mark

--
Mark Fasheh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
