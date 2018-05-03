Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59645 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbeECNe4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 May 2018 09:34:56 -0400
Date: Thu, 3 May 2018 15:34:52 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] iomap: iomap_dio_rw() handles all sync writes
Message-ID: <20180503133452.uarb3zggeuqmjw5k@quack2.suse.cz>
References: <20180418040828.18165-1-david@fromorbit.com>
 <20180418040828.18165-3-david@fromorbit.com>
 <20180421130309.efivmjo5ald2jchv@quack2.suse.cz>
 <20180502024540.GA23861@dastard>
 <BN6PR21MB07409BC39716894D592EB0C0B8800@BN6PR21MB0740.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR21MB07409BC39716894D592EB0C0B8800@BN6PR21MB0740.namprd21.prod.outlook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Robert Dorr <rdorr@microsoft.com>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, Slava Oks <slavao@microsoft.com>, Jasraj Dange <jasrajd@microsoft.com>, Michael Nelson <micn@microsoft.com>, Amit Banerjee <amit.banerjee@microsoft.com>, Travis Wright <twright@microsoft.com>, Bob Ward <bobward@microsoft.com>, Scott Konersmann <scottkon@microsoft.com>

On Wed 02-05-18 14:27:37, Robert Dorr wrote:
> In the current implementation the first write to the location updates the
> metadata and must issue the flush.   In Windows SQL Server can avoid this
> behavior.   SQL Server can issue DeviceIoControl with SET_FILE_VALID_DATA
> and then SetEndOfFile.  The SetEndOfFile acquires space and saves
> metadata without requiring the actual write.   This allows us to quickly
> create a large file and the writes do not need the added flush.
> 
> Is this something that fallocate could accommodate to avoid having to
> write once (triggers flush for metadata) and then secondary writes can
> use FUA and avoid the flush?

Well, the question then is what do you see in the file if you read those
blocks before writing them or if the system crashes before writing the
data. As you describe the feature, you'd see there just the old block
contents which is a security issue (you could see for example old
/etc/passwd contents there). That's why we've refused such feature in the
past [1].

								Honza

[1] https://www.spinics.net/lists/linux-ext4/msg31637.html

> -----Original Message-----
> From: Dave Chinner <david@fromorbit.com> 
> Sent: Tuesday, May 1, 2018 9:46 PM
> To: Jan Kara <jack@suse.cz>
> Cc: linux-xfs@vger.kernel.org; linux-fsdevel@vger.kernel.org; linux-block@vger.kernel.org; hch@lst.de; Robert Dorr <rdorr@microsoft.com>
> Subject: Re: [PATCH 2/4] iomap: iomap_dio_rw() handles all sync writes
> 
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
> > > @@ -768,14 +776,8 @@ static ssize_t iomap_dio_complete(struct 
> > > iomap_dio *dio)  static void iomap_dio_complete_work(struct 
> > > work_struct *work)  {
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
> This generates a use after free from KASAN from generic/016. it appears the compiler orders the code so that it dereferences
> dio->iocb after iomap_dio_complete() has freed the dio structure
> (yay!).
> 
> I'll post a new version of the patchset now that I've got changes to
> 2 of the 3 remaining patches in it....
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
