Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5079D7F53
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 10:42:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CDFD2AC00A
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 08:42:32 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 4FRMPPjDfqatt0s9 for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 08:42:31 -0700 (PDT)
Date: Tue, 19 Mar 2013 16:42:29 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfs: Fix WARN_ON(delalloc) in xfs_vm_releasepage()
Message-ID: <20130319154229.GB5222@quack.suse.cz>
References: <1363267854-25602-1-git-send-email-jack@suse.cz>
	<20130315205214.GB22182@sgi.com>
	<20130318160552.GC28508@quack.suse.cz>
	<20130319034759.GZ6369@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130319034759.GZ6369@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue 19-03-13 14:47:59, Dave Chinner wrote:
> On Mon, Mar 18, 2013 at 05:05:52PM +0100, Jan Kara wrote:
> > On Fri 15-03-13 15:52:14, Ben Myers wrote:
> > > Hi Jan,
> > > 
> > > On Thu, Mar 14, 2013 at 02:30:54PM +0100, Jan Kara wrote:
> > > > When a dirty page is truncated from a file but reclaim gets to it before
> > > > truncate_inode_pages(), we hit WARN_ON(delalloc) in
> > > > xfs_vm_releasepage(). This is because reclaim tries to write the page,
> > > > xfs_vm_writepage() just bails out (leaving page clean) and thus reclaim
> > > > thinks it can continue and calls xfs_vm_releasepage() on page with dirty
> > > > buffers.
> > > > 
> > > > Fix the issue by redirtying the page in xfs_vm_writepage(). This makes
> > > > reclaim stop reclaiming the page and also logically it keeps page in a
> > > > more consistent state where page with dirty buffers has PageDirty set.
> > > 
> > > Was there an easy way to reproduce this?  I'm testing and reviewing this now
> > > and it might help.
> >   I used scripts/run-bash-shared-mapping.sh from the attached tarball - it
> > fires up several processes beating a file with mmap accesses while
> > truncating the file and memory stressing the machine. I presume fsx with
> > some memhog could trigger the issue as well.
> 
> I have seen fsx trip this occasionally. The problem is that it was
> never reliable because of the fact that other memory pressure had to
> be generated at the same time....
> 
> Is the above script something you could turn into an xfstest (I
> haven't looked at the script yet)?
  Yes, that should be doable. I'll try combining fsx and usemem whether
that will be enough to trigger the race.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
