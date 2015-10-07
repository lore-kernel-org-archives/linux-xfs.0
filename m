Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE8DB7F51
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 10:08:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB8C9304039
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 08:08:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lRvAqxPkga6B4xLe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 08:08:36 -0700 (PDT)
Date: Wed, 7 Oct 2015 11:08:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Question about non asynchronous aio calls.
Message-ID: <20151007150833.GB30191@bfoster.bfoster>
References: <20151007141833.GB11716@scylladb.com>
	<56152B0F.2040809@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56152B0F.2040809@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Oct 07, 2015 at 09:24:15AM -0500, Eric Sandeen wrote:
> 
> 
> On 10/7/15 9:18 AM, Gleb Natapov wrote:
> > Hello XFS developers,
> > 
> > We are working on scylladb[1] database which is written using seastar[2]
> > - highly asynchronous C++ framework. The code uses aio heavily: no
> > synchronous operation is allowed at all by the framework otherwise
> > performance drops drastically. We noticed that the only mainstream FS
> > in Linux that takes aio seriously is XFS. So let me start by thanking
> > you guys for the great work! But unfortunately we also noticed that
> > sometimes io_submit() is executed synchronously even on XFS.
> > 
> > Looking at the code I see two cases when this is happening: unaligned
> > IO and write past EOF. It looks like we hit both. For the first one we
> > make special afford to never issue unaligned IO and we use XFS_IOC_DIOINFO
> > to figure out what alignment should be, but it does not help. Looking at the
> > code though xfs_file_dio_aio_write() checks alignment against m_blockmask which
> > is set to be sbp->sb_blocksize - 1, so aio expects buffer to be aligned to
> > filesystem block size not values that DIOINFO returns. Is it intentional? How
> > should our code know what it should align buffers to?
> 
>         /* "unaligned" here means not aligned to a filesystem block */
>         if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
>                 unaligned_io = 1;
> 
> It should be aligned to the filesystem block size.
> 

I'm not sure exactly what kinds of races are opened if the above locking
were absent, but I'd guess it's related to the buffer/block state
management, block zeroing and whatnot that is buried in the depths of
the generic dio code.

I suspect the dioinfo information describes the capabilities of the
filesystem (e.g., what kinds of DIO are allowable) as opposed to any
kind of optimal I/O related values. Something like statfs() can be used
to determine the filesystem block size. I suppose you could also
intentionally format the filesystem with a smaller block size if
concurrent, smaller dio's are a requirement.

> > Second one is harder. We do need to write past the end of a file, actually
> > most of our writes are like that, so it would have been great for XFS to
> > handle this case asynchronously.
> 
> You didn't say what kernel you're on, but these:
> 
> 9862f62 xfs: allow appending aio writes
> 7b7a866 direct-io: Implement generic deferred AIO completions
> 
> hit kernel v3.15.
> 
> However, we had a bug report about this, and Brian has sent a fix
> which has not yet been merged, see:
> 
> [PATCH 1/2] xfs: always drain dio before extending aio write submission
> 
> on this list last week.
> 
> With those 3 patches, things should just work for you I think.
> 

These fix some problems in that code, but the "beyond EOF" submission is
still synchronous in nature by virtue of cycling the IOLOCK and draining
pending dio. This is required to check for EOF zeroing, and we can't do
that safely without a stable i_size.

Note that according to the commit Eric referenced above, ordering your
I/O to always append (rather than start at some point beyond the current
EOF) might be another option to avoid the synchronization here. Whether
that is an option is specific to your application, of course.

> -Eric
> 
> > Currently we are working to work around
> > this by issuing truncate() (or fallocate()) on another thread and doing
> > aio on a main thread only after truncate() is complete. It seams to be
> > working, but is it guarantied that a thread issuing aio will never sleep
> > in this case (may be new file size value needs to hit the disk and it is
> > not guarantied that it will happen after truncate() returns, but before
> > aio call)?
> > 

There are no such pitfalls as far as I'm aware. The entire AIO
submission synchronization sequence triggers off an in-memory i_size
check in xfs_file_aio_write_checks(). The in-memory i_size is updated in
the truncate path (xfs_setattr_size()) via truncate_setsize(), so at
that point the new size should be visible to subsequent AIO writers.

Note that the truncate itself does appear to wait here on pending DIO.
Also note that the existence of pagecache pages is another avenue to
synchronous DIO submission due to the need to possibly flush and
invalidate the cache, so you probably want to avoid any kind of mixed
buffered/direct I/O to a single file as well.

Brian

> > [2] http://www.scylladb.com/
> > [1] http://www.seastar-project.org/
> > 
> > Thanks,
> > 
> > --
> > 			Gleb.
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
