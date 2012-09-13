Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8DK9QU0211672 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 15:09:27 -0500
Date: Thu, 13 Sep 2012 15:10:29 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: userspace trees
Message-ID: <20120913201029.GZ25175@sgi.com>
References: <20120913075026.GA27256@infradead.org>
	<5052142B.3010601@sandeen.net> <20120913175316.GR3274@sgi.com>
	<50521DCE.7020203@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50521DCE.7020203@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hey Eric & Christoph,

On Thu, Sep 13, 2012 at 12:54:22PM -0500, Eric Sandeen wrote:
> On 9/13/12 12:53 PM, Ben Myers wrote:
> > Hi Eric,
> > 
> > On Thu, Sep 13, 2012 at 12:13:15PM -0500, Eric Sandeen wrote:
> >> On 9/13/12 2:50 AM, Christoph Hellwig wrote:
> >>> It seems with the kernel.org account purge last year and me being way to
> >>> busy it seems like the -dev trees of the XFS userspace get very little
> >>> attention.  What do people think about retiring them and using the oss
> >>> trees exclusively again for now?  Right now the trees are getting a bit
> >>> out of sync which isn't a good thing.
> >>
> >> ISTR it was done in response to a .... fear of SGI being less responsive after
> >> a different type of account purge.  ;)  
> >>
> >> If SGI wants to be responsible for merging all userspace patches as they
> >> come in on the list, I'm fine with going back to one tree on oss.
> > 
> > I discussed this with management.  SGI is willing to take on the responsibility
> > of merging all userspace patches.
> > 
> > I think retiring the -dev trees will resolve the out-of-sync issues we've been
> > having, and be less confusing for all involved.
> 
> Sounds like a plan.  Will you make sure everything gets re-synced from kernel.org
> so nothing is lost?

~/dmapi$ git pull korg master
>From git://git.kernel.org/pub/scm/fs/xfs/dmapi-dev
 * branch            master     -> FETCH_HEAD
 Already up-to-date.

~/xfsdump$ git pull korg master
>From git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev
 * branch            master     -> FETCH_HEAD
 Already up-to-date.

~/xfsprogs$ git pull kernel.org master
>From git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev
 * branch            master     -> FETCH_HEAD
Updating a8decaf..7db1e7b
Fast-forward
 db/bmap.c       |    4 ++--
 db/btblock.c    |   11 -----------
 mkfs/xfs_mkfs.c |   15 +++++++++------
 repair/bmap.c   |   28 ++++++++++++++++++++++++----
 repair/dir2.c   |    6 +++++-
 5 files changed, 40 insertions(+), 24 deletions(-)

I've brought xfsprogs master branch uptodate here
git://oss.sgi.com/xfs/cmds/xfsprogs.git

~/xfstests # git pull korg master
>From git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev
 * branch            master     -> FETCH_HEAD
Auto-merging group
CONFLICT (content): Merge conflict in group
Auto-merging 285.out
CONFLICT (add/add): Merge conflict in 285.out
Auto-merging 285
CONFLICT (add/add): Merge conflict in 285
Automatic merge failed; fix conflicts and then commit the result.

I've merged and brought xfstests master branch uptodate here
git://oss.sgi.com/xfs/cmds/xfstests.git

Did I miss anything?  Any other branches to copy over?

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
