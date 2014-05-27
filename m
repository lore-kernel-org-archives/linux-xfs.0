Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B0397F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 16:27:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA88B304043
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 14:27:04 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ILwOZ9ByYbMmg6zo for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 14:26:59 -0700 (PDT)
Date: Wed, 28 May 2014 07:26:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/3] xfs: add scan owner field to xfs_eofblocks
Message-ID: <20140527212653.GC6677@dastard>
References: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
	<1400845950-41435-2-git-send-email-bfoster@redhat.com>
	<20140527104428.GC1440@infradead.org>
	<20140527121810.GB63281@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140527121810.GB63281@bfoster.bfoster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, May 27, 2014 at 08:18:11AM -0400, Brian Foster wrote:
> On Tue, May 27, 2014 at 03:44:28AM -0700, Christoph Hellwig wrote:
> > On Fri, May 23, 2014 at 07:52:28AM -0400, Brian Foster wrote:
> > > The scan owner field represents an optional inode number that is
> > > responsible for the current scan. The purpose is to identify that an
> > > inode is under iolock and as such, the iolock shouldn't be attempted
> > > when trimming eofblocks. This is an internal only field.
> > 
> > xfs_free_eofblocks already does a trylock, and without that calling it
> > from one iolock holding process to another would be a deadlock waiting
> > to happen.
> > 
> > I have to say I'm still not very easy with iolock nesting, even if it's
> > a trylock.
> > 
> 
> Right... maybe I'm not parsing your point. The purpose here is to avoid
> the trylock entirely. E.g., Indicate that we have already acquired the
> lock and can proceed with xfs_free_eofblocks(), rather than fail a
> trylock and skip (which appears to be a potential infinite loop scenario
> here due to how the AG walking code handles EAGAIN).

I think Christoph's concern here is that we are calling a function
that can take the iolock while we already hold the iolock. i.e. the
reason we have to add the anti-deadlock code in the first place.  To
address that, can we restructure xfs_file_buffered_aio_write() such
that the ENOSPC/EDQUOT flush is done outside the iolock?

>From a quick check, I don't think there is any problem with dropping
the iolock, doing the flushes and then going all the way back to the
start of the function again, but closer examination and testing is
warranted...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
