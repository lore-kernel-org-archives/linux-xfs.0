Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24591 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbeLDWbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 17:31:24 -0500
Date: Wed, 5 Dec 2018 09:31:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/11] vfs: copy_file_range source range over EOF should
 fail
Message-ID: <20181204223102.GR6311@dastard>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-2-david@fromorbit.com>
 <CAOQ4uxhOQY8M5rbgHKREN5qpeDGHv0-xK3r37Lj6XfqFoE4qjg@mail.gmail.com>
 <20181204151332.GA32245@infradead.org>
 <20181204212948.GO6311@dastard>
 <CAN-5tyGU=y5JO5UNcmn3rX1gRyK_UxjQvQ+kCsP34_NT2-mQ_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN-5tyGU=y5JO5UNcmn3rX1gRyK_UxjQvQ+kCsP34_NT2-mQ_A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs <linux-nfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Tue, Dec 04, 2018 at 04:47:18PM -0500, Olga Kornievskaia wrote:
> On Tue, Dec 4, 2018 at 4:35 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Tue, Dec 04, 2018 at 07:13:32AM -0800, Christoph Hellwig wrote:
> > > On Mon, Dec 03, 2018 at 02:46:20PM +0200, Amir Goldstein wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > >
> > > > > The man page says:
> > > > >
> > > > > EINVAL Requested range extends beyond the end of the source file
> > > > >
> > > > > But the current behaviour is that copy_file_range does a short
> > > > > copy up to the source file EOF. Fix the kernel behaviour to match
> > > > > the behaviour described in the man page.
> > >
> > > I think the behavior implemented is a lot more useful than the one
> > > documented..
> >
> > The current behaviour is really nasty. Because copy_file_range() can
> > return short copies, the caller has to implement a loop to ensure
> > the range hey want get copied.  When the source range you are
> > trying to copy overlaps source EOF, this loop:
> >
> >         while (len > 0) {
> >                 ret = copy_file_range(... len ...)
> >                 ...
> >                 off_in += ret;
> >                 off_out += ret;
> >                 len -= ret;
> >         }
> >
> > Currently the fallback code copies up to the end of the source file
> > on the first copy and then fails the second copy with EINVAL because
> > the source range is now completely beyond EOF.
> >
> > So, from an application perspective, did the copy succeed or did it
> > fail?
> >
> > Existing tools that exercise copy_file_range (like xfs_io) consider
> > this a failure, because the second copy_file_range() call returns
> > EINVAL and not some "there is no more to copy" marker like read()
> > returning 0 bytes when attempting to read beyond EOF.
> >
> > IOWs, we cannot tell the difference between a real error and a short
> > copy because the input range spans EOF and it was silently
> > shortened. That's the API problem we need to fix here - the existing
> > behaviour is really crappy for applications. Erroring out
> > immmediately is one solution, and it's what the man page says should
> > happen so that is what I implemented.
> >
> > Realistically, though, I think an attempt to read beyond EOF for the
> > copy should result in behaviour like read() (i.e. return 0 bytes),
> > not EINVAL. The existing behaviour needs to change, though.
> 
> There are two checks to consider
> 1. pos_in >= EOF should return EINVAL
> 2. however what's perhaps should be relaxed is pos_in+len >= EOF
> should return a short copy.
> 
> Having check#1 enforced allows to us to differentiate between a real
> error and a short copy.

That's what the code does right now and *exactly what I'm trying to
fix* because it EINVAL is ambiguous and not an indicator that we've
reached the end of the source file. EINVAL can indicate several
different errors, so it really has to be treated as a "copy failed"
error by applications.

Have a look at read/pread() - they return 0 in this case to indicate
a short read, and the value of zero is explicitly defined as meaning
"read position is beyond EOF".  Applications know straight away that
there is no more data to be read and there was no error, so can
terminate on a successful short read.

We need to allow applications to terminate copy loops on a
successful short copy. IOWs, applications need to either:

	- get an immediate error saying the range is invalid rather
	  than doing a short copy (as per the man page); or
	- have an explicit marker to say "no more data to be copied"

Applications need the "no more data to copy" case to be explicit and
unambiguous so they can make sane decisions about whether a short
copy was successful because the file was shorter than expected or
whether a short copy was a result of a real error being encountered.
The current behaviour is largely unusable for applications because
they have to guess at the reason for EINVAL part way through a
copy....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
