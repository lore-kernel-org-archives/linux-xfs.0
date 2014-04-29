Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E73029DF8
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 05:25:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C94ABAC002
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 03:24:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DkSRGhqEhh0GJO9C for
	<xfs@oss.sgi.com>; Tue, 29 Apr 2014 03:24:53 -0700 (PDT)
Subject: Re: [PATCH] xfs: test for shut down fs in xfs_dir_fsync()
From: Boris Ranto <branto@redhat.com>
In-Reply-To: <535E94A4.2060701@sgi.com>
References: <535E8344.2070209@redhat.com>
	<20140428164754.GA17472@infradead.org>	<535E8D67.3010504@redhat.com>
	<535E8E47.2040701@sgi.com> <535E8F4C.8000003@sandeen.net>
	<535E94A4.2060701@sgi.com>
Date: Tue, 29 Apr 2014 12:24:27 +0200
Message-ID: <1398767067.15380.26.camel@dhcp-31-223.brq.redhat.com>
Mime-Version: 1.0
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Mon, 2014-04-28 at 12:49 -0500, Mark Tinguely wrote:
> On 04/28/14 12:26, Eric Sandeen wrote:
> > On 4/28/14, 12:22 PM, Mark Tinguely wrote:
> >> On 04/28/14 12:18, Eric Sandeen wrote:
> >>> On 4/28/14, 11:47 AM, Christoph Hellwig wrote:
> >>>> On Mon, Apr 28, 2014 at 11:35:16AM -0500, Eric Sandeen wrote:
> >>>>> Similar to xfs_file_fsync(), I think xfs_dir_fsync() needs
> >>>>> to test for a shut down fs,
> >>>>
> >>>> It probably should.
> >>>>
> >>>>> lest we go down paths we'll
> >>>>> never be able to complete; Boris reported that during some
> >>>>> stress tests he had threads stuck in xlog_cil_force_lsn
> >>>>> via xfs_dir_fsync().
> >>>>
> >>>> But this could still happen if we get a shutdown coming in after that
> >>>> test.
> >>>
> >>> True... that looked a bit hairier to sort out.  :(
> >>>
> >>> -Eric
> >>>
> >>
> >>
> >> Are the sync lsn look okay? Was there an error writing the iclog buffer?
> >>
> >> xfs_do_force_shutdown() will also do a xlog_cil_force_lsn() via the
> >> xfs_log_force_umount if the log buffer write was not in error. That
> >> should be the same or later than this lsn.
> >
> > I don't have full details, unfortunately, just the sysrq backtraces.
> >
> > -Eric
> >
> >> --Mark.
> 
> anything in the log as to what caused the hang? You mention a forced 
> shutdown; what caused the forced shutdown?

Hi,

I used src/godown utility from xfstests to simulate a power failure and
cause the forced shutdown. The kernel does not report much. All I get is
this kernel message (it repeats every few seconds):

[498704.267273] XFS (dm-3): xfs_log_force: error 5 returned.

Nothing else is reported by the kernel albeit ls /mnt/point already
returns EIO.

The whole test is fairly simple to describe: It runs several threads
that ~randomly create/delete/truncate/mmap/fdatasync files in several
iterations, then (after ~2 minutes) the src/godown utility is run and
when the program gets the message from all the threads that they got
some I/O errors, it will remount the fs and tell all the threads to
continue with verification of fsynced data.

The trouble is that the program will never get the message from all the
threads because some of them are stuck in D state on fsync/fdatasync
syscall after the src/godown utility is run


> Is this the latest bits (3.15)?
> 

As Eric mentioned earlier, it is 3.10 with a lot of backports from later
kernels.

Boris

> --Mark.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
