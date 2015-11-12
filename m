Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 178767F37
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 18:42:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 13A118F8049
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 16:42:02 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JeR0pBiFIXqNJklF for <xfs@oss.sgi.com>;
	Wed, 11 Nov 2015 16:41:41 -0800 (PST)
Date: Thu, 12 Nov 2015 11:41:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFCv3 00/12] xfstests: test the btrfs/xfs reflink/dedupe ioctls
Message-ID: <20151112004114.GO19199@dastard>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
	<20151109075926.GB17974@infradead.org>
	<20151109184913.GB3255@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151109184913.GB3255@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Mon, Nov 09, 2015 at 10:49:13AM -0800, Darrick J. Wong wrote:
> On Sun, Nov 08, 2015 at 11:59:26PM -0800, Christoph Hellwig wrote:
> > On Tue, Oct 06, 2015 at 10:12:57PM -0700, Darrick J. Wong wrote:
> > >  * I don't have any interesting NFS/CIFS setups for test. :(
> > 
> > I have a banrch with client and server support for NFSv4.2 CLONE
> > support:
> > 
> > http://git.infradead.org/users/hch/pnfs.git/shortlog/refs/heads/reflink+clone
> > 
> > For now you want to use btrfs on the server, as using reflinks on XFS
> > seems to be a little unstable over NFS.
> 
> I found a few more bugs in the kernel-side implementation, which might explain
> that.  I'm about to start working on making CoW less crappy, but I'll push all
> the patches out to github.  (I wasn't planning on patchbombing again until
> December.)
> 
> > > If you're going to start using this mess, you probably ought to just
> > > pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
> > > They should just work with the btrfs that's in 4.3.
> > > 
> > > Comments and questions are, as always, welcome.
> > 
> > Any reason the groups are called clone?  I don't really have an opinion
> > on clone vs reflink but given that the xfs_io command is reflink I'd
> > rather be consistent.
> 
> The existing btrfs reflink tests were tagged in the 'clone' group prior to my
> patchset.
> 
> > Otherwise I'd say get it merged ASAP, we can still fix up various
> > details later.
> 
> I'll merge your patch and repost the whole pile of tests.  I'm almost ready to
> send a pile of updates for the XFS on-disk structure document which add stuff
> about the v5 format, rmapbt, and reflink.

Darrick, can you renumber the xfstests against what is currently at
the head of the repo? If both you an Christoph need them working,
you may as well both patch against the main xfstests repo...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
