Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:50510 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727195AbeLEQvw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 11:51:52 -0500
Date: Wed, 5 Dec 2018 11:51:51 -0500
Subject: Re: [PATCH 01/11] vfs: copy_file_range source range over EOF should
 fail
Message-ID: <20181205165151.GB5182@fieldses.org>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-2-david@fromorbit.com>
 <CAOQ4uxhOQY8M5rbgHKREN5qpeDGHv0-xK3r37Lj6XfqFoE4qjg@mail.gmail.com>
 <20181204151332.GA32245@infradead.org>
 <20181204212948.GO6311@dastard>
 <CAN-5tyGU=y5JO5UNcmn3rX1gRyK_UxjQvQ+kCsP34_NT2-mQ_A@mail.gmail.com>
 <20181204223102.GR6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204223102.GR6311@dastard>
From: bfields@fieldses.org (J. Bruce Fields)
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Olga Kornievskaia <olga.kornievskaia@gmail.com>, Christoph Hellwig <hch@infradead.org>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs <linux-nfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Wed, Dec 05, 2018 at 09:31:02AM +1100, Dave Chinner wrote:
> That's what the code does right now and *exactly what I'm trying to
> fix* because it EINVAL is ambiguous and not an indicator that we've
> reached the end of the source file. EINVAL can indicate several
> different errors, so it really has to be treated as a "copy failed"
> error by applications.
> 
> Have a look at read/pread() - they return 0 in this case to indicate
> a short read, and the value of zero is explicitly defined as meaning
> "read position is beyond EOF".  Applications know straight away that
> there is no more data to be read and there was no error, so can
> terminate on a successful short read.
> 
> We need to allow applications to terminate copy loops on a
> successful short copy.

I'm a little confused by your definition of "short copy" and "short
read".  Are you using that to mean a copy/read that returns zero?  I
usually see it used to mean any successful call that returned less than
the requested amount.  I'd expect a zero return to terminate a copy
loop, but not any positive return.

--b.


> IOWs, applications need to either:
> 
> 	- get an immediate error saying the range is invalid rather
> 	  than doing a short copy (as per the man page); or
> 	- have an explicit marker to say "no more data to be copied"
> 
> Applications need the "no more data to copy" case to be explicit and
> unambiguous so they can make sane decisions about whether a short
> copy was successful because the file was shorter than expected or
> whether a short copy was a result of a real error being encountered.
> The current behaviour is largely unusable for applications because
> they have to guess at the reason for EINVAL part way through a
> copy....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
