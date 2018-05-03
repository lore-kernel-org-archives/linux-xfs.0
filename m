Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50516 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751111AbeECMvY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 May 2018 08:51:24 -0400
Date: Thu, 3 May 2018 14:51:22 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] iomap: iomap_dio_rw() handles all sync writes
Message-ID: <20180503125122.7tss5tn7hvnre6ps@quack2.suse.cz>
References: <20180418040828.18165-1-david@fromorbit.com>
 <20180418040828.18165-3-david@fromorbit.com>
 <20180421130309.efivmjo5ald2jchv@quack2.suse.cz>
 <20180502024540.GA23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502024540.GA23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

On Wed 02-05-18 12:45:40, Dave Chinner wrote:
> On Sat, Apr 21, 2018 at 03:03:09PM +0200, Jan Kara wrote:
> > On Wed 18-04-18 14:08:26, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Currently iomap_dio_rw() only handles (data)sync write completions
> > > for AIO. This means we can't optimised non-AIO IO to minimise device
> > > flushes as we can't tell the caller whether a flush is required or
> > > not.
> > > 
> > > To solve this problem and enable further optimisations, make
> > > iomap_dio_rw responsible for data sync behaviour for all IO, not
> > > just AIO.
> > > 
> > > In doing so, the sync operation is now accounted as part of the DIO
> > > IO by inode_dio_end(), hence post-IO data stability updates will no
> > > long race against operations that serialise via inode_dio_wait()
> > > such as truncate or hole punch.
> > > 
> > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Looks good to me. You can add:
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> It looks good, but it's broken in a subtle, nasty way. :/
> 
> > > @@ -768,14 +776,8 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
> > >  static void iomap_dio_complete_work(struct work_struct *work)
> > >  {
> > >  	struct iomap_dio *dio = container_of(work, struct iomap_dio, aio.work);
> > > -	struct kiocb *iocb = dio->iocb;
> > > -	bool is_write = (dio->flags & IOMAP_DIO_WRITE);
> > > -	ssize_t ret;
> > >  
> > > -	ret = iomap_dio_complete(dio);
> > > -	if (is_write && ret > 0)
> > > -		ret = generic_write_sync(iocb, ret);
> > > -	iocb->ki_complete(iocb, ret, 0);
> > > +	dio->iocb->ki_complete(dio->iocb, iomap_dio_complete(dio), 0);
> 
> This generates a use after free from KASAN from generic/016. it
> appears the compiler orders the code so that it dereferences
> dio->iocb after iomap_dio_complete() has freed the dio structure
> (yay!).

Yeah, very subtle but the compiler is indeed free to do this (in C the
sequence point is only the function call but the order of evaluation of
function arguments is unspecified). Thanks for catching this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
