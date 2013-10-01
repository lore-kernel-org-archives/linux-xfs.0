Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F17957F56
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 06:12:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC5328F8040
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 04:12:41 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iu3HcpRdnOoZDfMS for <xfs@oss.sgi.com>;
	Tue, 01 Oct 2013 04:12:40 -0700 (PDT)
Date: Tue, 1 Oct 2013 21:12:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: open code inc_inode_iversion when logging an
	inode
Message-ID: <20131001111236.GQ12541@dastard>
References: <1380497826-13474-1-git-send-email-david@fromorbit.com>
	<1380497826-13474-5-git-send-email-david@fromorbit.com>
	<5249FA36.1070609@sandeen.net> <20130930223946.GQ1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130930223946.GQ1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Jean Noel Cordenner <jean-noel.cordenner@bull.net>, xfs@oss.sgi.com

On Mon, Sep 30, 2013 at 05:39:46PM -0500, Ben Myers wrote:
> On Mon, Sep 30, 2013 at 05:24:54PM -0500, Eric Sandeen wrote:
> > On 9/29/13 6:37 PM, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Michael L Semon reported that generic/069 runtime increased on v5
> > > superblocks by 100% compared to v4 superblocks. his perf-based
> > > analysis pointed directly at the timestamp updates being done by the
> > > write path in this workload. The append writers are doing 4-byte
> > > writes, so there are lots of timestamp updates occurring.
...
> > > diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> > > index 53dfe46..e6601c1 100644
> > > --- a/fs/xfs/xfs_trans_inode.c
> > > +++ b/fs/xfs/xfs_trans_inode.c
> > > @@ -118,8 +118,7 @@ xfs_trans_log_inode(
> > >  	 */
> > >  	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
> > >  	    IS_I_VERSION(VFS_I(ip))) {
> > > -		inode_inc_iversion(VFS_I(ip));
> > > -		ip->i_d.di_changecount = VFS_I(ip)->i_version;
> > 
> > comment about the reason for the open-code might be good, too?

Sure, I can add that.

> > otherwise some semantic patcher might "fix" it for you again later...
> > 
> > -Eric
> > 
> > > +		ip->i_d.di_changecount = ++VFS_I(ip)->i_version;
> > >  		flags |= XFS_ILOG_CORE;
> > >  	}
> > >  
> > > 
> 
> Adding a comment strikes me as a good idea too... But isn't that lock there for
> a reason?  I suspect that will break i_version like i_size on 32 bit systems.
> Jean added this function, hopefully he can shed some light.

I can't see how there's a 32 bit issue here - i_version is always
read unlocked, and so if you're worried about a 32 bit system doing
2 32 bit reads to read the 64 bit value and seeing values on
different sides of the increment, then we've already got that
problem *everywhere*. i.e. the only place that i_version is
protected by i_lock is in inode_inc_iversion() - nowhere else is
that lock used at all when reading or writing i_version.

A quick grep points out that ext2/3/4 directory code all update and
read i_version without using the i_lock - they are all serialised by
the directory locks that are held. Ceph, exofs, ocfs2, ecryptfs,
affs, fat, etc all do similar things with inode->i_version. 

So if the intention is to make i_version safe on 32 bit systems,
then it's failed. The only thing it does in inode_inc_iversion is
serialise other updates that aren't done under some exclusive inode
locks, and all the XFS updates are done either under the i_mutex
and/or the i_ilock, so I don't think there is any problem with
racing occurring here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
