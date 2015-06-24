Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 350597F63
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 16:26:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 15173304043
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 14:26:48 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	yWOyl6fZLTpvgTiX for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2015 14:26:46 -0700 (PDT)
Date: Thu, 25 Jun 2015 07:26:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remote attribute headers contain an invalid LSN
Message-ID: <20150624212643.GJ22807@dastard>
References: <1434948369-13931-1-git-send-email-david@fromorbit.com>
	<20150624131228.GC1888@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150624131228.GC1888@bfoster.bfoster>
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
Cc: xfs@oss.sgi.com

On Wed, Jun 24, 2015 at 09:12:28AM -0400, Brian Foster wrote:
> On Mon, Jun 22, 2015 at 02:46:09PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > In recent testing, a system that crashed failed log recovery on
> > restart with a bad symlink buffer magic number:
> > 
> > XFS (vda): Starting recovery (logdev: internal)
> > XFS (vda): Bad symlink block magic!
> > XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 2060
> > 
> > On examination of the log via xfs_logprint, none of the symlink
> > buffers in the log had a bad magic number, nor were any other types
> > of buffer log format headers mis-identified as symlink buffers.
> > Tracing was used to find the buffer the kernel was tripping over,
> > and xfs_db identified it's contents as:
> > 
> > 000: 5841524d 00000000 00000346 64d82b48 8983e692 d71e4680 a5f49e2c b317576e
> > 020: 00000000 00602038 00000000 006034ce d0020000 00000000 4d4d4d4d 4d4d4d4d
> > 040: 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d
> > 060: 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d
> > .....
> > 
> > This is a remote attribute buffer, which are notable in that they
> > are not logged but are instead written synchronously by the remote
> > attribute code so that they exist on disk before the attribute
> > transactions are committed to the journal.
....
> > @@ -221,6 +226,19 @@ xfs_attr3_rmt_hdr_set(
> >  	rmt->rm_owner = cpu_to_be64(ino);
> >  	rmt->rm_blkno = cpu_to_be64(bno);
> >  
> > +	/*
> > +	 * Remote attribute blocks are written synchronously, so we don't
> > +	 * have an LSN that we can stamp in them that makes any sense to log
> > +	 * recovery. To ensure that log recovery handles overwrites of these
> > +	 * blocks sanely (i.e. once they've been freed and reallocated as some
> > +	 * other type of metadata) we need to ensure that the LSN has a value
> > +	 * that tells log recovery to ignore the LSN and overwrite the buffer
> > +	 * with whatever is in it's log. To do this, we use the magic
> > +	 * NULLCOMMITLSN to indicate that the LSN is invalid.
> > +	 * of -1.
> 
> Looks like a stale last line in the comment above.

Ah, yes, so it is. I wrote "-1" first, then remembered there was a
define for it. ;)

> The rest of the code
> all looks fine to me, but a question to help me grok the bigger picture:
>
> We allocate these attr blocks in xfs_attr_rmtval_set(). If the writes
> are synchronous, shouldn't those allocation transactions be synchronous
> as well? IOW, what prevents our synchronous writes going to freed blocks
> or blocks allocated to something else (if a block were freed,
> reallocated as an attr block and sync. written without making it to the
> ail) due to a crash immediately following the sync. write?

Well, the historical reason this is safe is that we don't reallocate
freed blocks until the the transaction that frees them is committed.
That's what the extent busy list prevents, and things like the calls
to xfs_extent_busy_trim() in extent allocation do to avoid
reallocating freed-but-not-committed extents.

That said, i think there may be a problem here with the sync write -
we can reallocate metadata blocks while they are busy because we log
the new contents rather than write them in place.  The problem here
is the remote attr block is allocated as a metadata block and so
can use busy extents but we don't log th new contents.

Hence I think that we probably also need to remove the
XFS_BMAPI_METADATA flag from xfs_attr_rmtval_set() so that it
doesn't allocate busy blocks. i.e. treat the remote attribute blocks
like user datai blocks, as that already handles the case of being
written to before we commit the allocation transaction....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
