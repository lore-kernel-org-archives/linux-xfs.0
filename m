Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0384F7F52
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 05:55:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E39B6304039
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 03:54:56 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id befizTI7AWhUO4sV for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 03:54:55 -0700 (PDT)
Date: Wed, 4 Sep 2013 12:54:50 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2 v2] Fix O_SYNC AIO DIO
Message-ID: <20130904105450.GB3996@quack.suse.cz>
References: <1376471456-11966-1-git-send-email-jack@suse.cz>
	<20130830155301.GB13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130830155301.GB13318@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri 30-08-13 16:53:01, Al Viro wrote:
> On Wed, Aug 14, 2013 at 11:10:54AM +0200, Jan Kara wrote:
> >   Hello,
> > 
> >   this is second iteration of patches to fix handling of O_SYNC AIO DIO.
> > Since previous version I've addressed Dave's comments:
> >  - slightly expanded changelog of the first patch
> >  - workqueue is now created with parameters allowing paralelism
> >  - workqueue name contains sb->s_id
> >  - workqueue is created on demand (I decided to do this to reduce the overhead
> >    in unnecessary cases)
> > 
> > The patchset survives xfstests run for ext4 & xfs so it should be sane. Since
> > this touches several filesystems (although only ext4 & xfs are non-trivial),
> > the question is who should carry these patches. Maybe Al? But since xfs and
> > ext4 changes are non-trivial, I'd like to have a review from their
> > developers...
> 
> Looks sane, except that I'd probably put destroying the queue after
> evict_inodes(), next to ->put_super() call.
  OK, I've changed that. I'll send v3 in a moment.

> Said that, there's another interesting problem in the code affected by that
> sucker: generic_file_aio_write() might very well sync the wrong range.
> Consider O_APPEND case; __generic_file_aio_write() will call
> generic_write_checks(), which will update its copy of pos, and proceed to
> write starting from there.  All right and proper, but then we return into
> generic_file_aio_write() and sync the range of the right length, starting
> at the *original* value of pos...
  Yes, that looks like a bug. I was looking into how we could fix that and
the easiest seems to be to move generic_segment_checks() and
generic_write_checks() from __generic_file_aio_write() to
generic_file_aio_write(). There are only three callers of
__generic_file_aio_write(). cifs_writev() which can and should use
generic_file_aio_write() anyway, ext4_file_dio_write() which could use
generic_file_aio_write() if we cleaned up the code and moved it around a
bit, and blkdev_aio_write() which really needs to call
__generic_file_aio_write() (it doesn't want to grab i_mutex). So that last
caller would need to do the moved checks manually.

But this all seems a bit complex so I'd prefer to do it as a separate
series.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
