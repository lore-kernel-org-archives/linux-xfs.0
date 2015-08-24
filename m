Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A84D57F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 07:19:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B64F8F8035
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 05:19:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dDrShubayfS1F1Gv for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 05:19:47 -0700 (PDT)
Date: Mon, 24 Aug 2015 22:19:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix file type directory corruption for btree
	directories
Message-ID: <20150824121945.GC714@dastard>
References: <1440179722-6029-1-git-send-email-jack@suse.com>
	<20150821231154.GR3902@dastard>
	<20150824092637.GB2936@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824092637.GB2936@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com, Jan Kara <jack@suse.com>

On Mon, Aug 24, 2015 at 11:26:37AM +0200, Jan Kara wrote:
> On Sat 22-08-15 09:11:54, Dave Chinner wrote:
> > On Fri, Aug 21, 2015 at 07:55:22PM +0200, Jan Kara wrote:
> > > Users have occasionally reported that file type for some directory
> > > entries is wrong. This mostly happened after updating libraries some
> > > libraries. After some debugging the problem was traced down to
> > > xfs_dir2_node_replace(). The function uses args->filetype as a file type
> > > to store in the replaced directory entry however it also calls
> > > xfs_da3_node_lookup_int() which will store file type of the current
> > > directory entry in args->filetype. Thus we fail to change file type of a
> > > directory entry to a proper type.
> > > 
> > > Fix the problem by storing new file type in a local variable before
> > > calling xfs_da3_node_lookup_int().
> > > 
> > > Reported-by: Giacomo Comes <comes@naic.edu>
> > > Signed-off-by: Jan Kara <jack@suse.com>
> > 
> > So this is being triggered by a rename() operation on a large
> > directory? node format is the optimised form form for large dirs, so
> > I suspect that's why only few people see this. Can you see if you
> > can write a reproducer for it baseed on a large single directory and
> > renaming two files of different types (e.g. BLKDEV over REG) to see
> > if the cause is that simple?
> 
> Yes, I've tried and for a large enough directory renaming symlink over a
> regular file is all that is needed to corrupt the file type in the
> directory. Should I write a dedicated test for this or is there something
> that already excercises directory code? I know about fsstress runs but
> those would be hard to tweak to trigger this I guess.

I don't think there's anything specific that tests ftype after
rename. It might be worth writing a specific test for it that steps
through different directory formats and checks that ftype swaps with
rename corectly as we move through shortform, block, leaf and node
formats (i.e. as the directory gets larger).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
