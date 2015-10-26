Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B7C8E7F37
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 15:54:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D76AAC001
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 13:54:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sDCl0DD2RuCRzuFs for <xfs@oss.sgi.com>;
	Mon, 26 Oct 2015 13:54:06 -0700 (PDT)
Date: Tue, 27 Oct 2015 07:54:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: optimise away log forces on timestamp updates for
	fdatasync
Message-ID: <20151026205404.GH8773@dastard>
References: <1445396343-4361-1-git-send-email-david@fromorbit.com>
	<20151022173618.GC13661@bfoster.bfoster>
	<20151026050720.GG8773@dastard>
	<20151026114929.GA59738@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151026114929.GA59738@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: sage@redhat.com, xfs@oss.sgi.com

On Mon, Oct 26, 2015 at 07:49:29AM -0400, Brian Foster wrote:
> On Mon, Oct 26, 2015 at 04:07:20PM +1100, Dave Chinner wrote:
> > > Also, is it me or are we sending an unconditional flush in the hunk
> > > following the log force call in xfs_file_fsync() (even if we've skipped
> > > the log force)?
> > 
> > The flush is needed - fdatasync needs to guarantee the data is
> > on stable storage even if no metadata needs to be written to the
> > journal.
> > 
> 
> Ok. Well it's too bad we don't get any feedback about what was written
> from the filemap_write_and_wait_range() call. As it is, we send a flush
> even if there's nothing to write back.

Direct IO still needs cache flushes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
