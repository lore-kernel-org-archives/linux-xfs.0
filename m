Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BA80E29DF8
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:07:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9228D30408B
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 14:07:30 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	26P8J3g3WSArWhD4 for <xfs@oss.sgi.com>;
	Wed, 15 Jan 2014 14:07:25 -0800 (PST)
Date: Thu, 16 Jan 2014 09:07:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
	environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Message-ID: <20140115220721.GY3469@dastard>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
	<20140106201032.GA13491@quack.suse.cz>
	<20140107155830.GA28395@infradead.org>
	<CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
	<20140108140307.GA588@infradead.org>
	<CA+QCeVRuvNtZ8+9D-NtMOD=B9UEA5HMvKaGdXOQCjO-KTnZdbw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+QCeVRuvNtZ8+9D-NtMOD=B9UEA5HMvKaGdXOQCjO-KTnZdbw@mail.gmail.com>
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
To: Sergey Meirovich <rathamahata@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>, Gluk <git.user@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

On Tue, Jan 14, 2014 at 03:30:11PM +0200, Sergey Meirovich wrote:
> Hi Cristoph,
> 
> On 8 January 2014 16:03, Christoph Hellwig <hch@infradead.org> wrote:
> > On Tue, Jan 07, 2014 at 08:37:23PM +0200, Sergey Meirovich wrote:
> >> Actually my initial report (14.67Mb/sec  3755.41 Requests/sec) was about ext4
> >> However I have tried XFS as well. It was a bit slower than ext4 on all
> >> occasions.
> >
> > I wasn't trying to say XFS fixes your problem, but that we could
> > implement appending AIO writes in XFS fairly easily.
> >
> > To verify Jan's theory, can you try to preallocate the file to the full
> > size and then run the benchmark by doing a:
> >
> > # fallocate -l <size> <filename>
> >
> > and then run it?  If that's indeed the issue I'd be happy to implement
> > the "real aio" append support for you as well.
> >
> 
> I've resorted to write simple wrapper around io_submit() and ran it
> against preallocated file (exactly to avoid append AIO scenario).
> Random data was used to avoid XtremIO online deduplication but results
> were still wonderfull for 4k sequential AIO write:
> 
> 744.77 MB/s   190660.17 Req/sec
> 
> Clearly Linux lacks "rial aio" append to be available for any FS.
> Seems that you are thinking that it would be relatively easy to
> implement it for XFS on Linux? If so - I will really appreciate your
> afford.

Yes, I think it can be done relatively simply. We'd have to change
the code in xfs_file_aio_write_checks() to check whether EOF zeroing
was required rather than always taking an exclusive lock (for block
aligned IO at EOF sub-block zeroing isn't required), and then we'd
have to modify the direct IO code to set the is_async flag
appropriately. We'd probably need a new flag to say tell the DIO
code that AIO beyond EOF is OK, but that isn't hard to do....

And for those that are wondering about the stale data exposure problem
documented in the aio code:

        /*
         * For file extending writes updating i_size before data
         * writeouts complete can expose uninitialized blocks. So
         * even for AIO, we need to wait for i/o to complete before
         * returning in this case.
         */

This is fixed in XFS by removing a single if() check in
xfs_iomap_write_direct(). We already use unwritten extents for DIO
within EOF to avoid races that could expose uninitialised blocks, so
we just need to make that unconditional behaviour.  Hence racing IO
on concurrent appending i_size updates will only ever see a hole
(zeros), an unwritten region (zeros) or the written data.

Christoph, are you going to get any time to look at doing this in
the next few days?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
