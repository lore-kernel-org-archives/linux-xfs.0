Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38263 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbeCBW0m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Mar 2018 17:26:42 -0500
Date: Fri, 2 Mar 2018 23:26:41 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180302222641.GA30953@lst.de>
References: <20180301014144.28892-1-david@fromorbit.com> <20180302222031.GA30818@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302222031.GA30818@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-fsdevel@vger.kernel.org

On Fri, Mar 02, 2018 at 11:20:31PM +0100, Christoph Hellwig wrote:
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -732,6 +732,11 @@ xfs_file_write_iter(
> >  		ret = xfs_file_dio_aio_write(iocb, from);
> >  		if (ret == -EREMCHG)
> >  			goto buffered;
> > +		/*
> > +		 * Direct IO handles sync type writes internally on I/O
> > +		 * completion.
> > +		 */
> > +		return ret;
> >  	} else {
> >  buffered:
> >  		ret = xfs_file_buffered_aio_write(iocb, from);
> 
> The else is not needed and you can now have a much more sensible
> code flow here:
> 
> 		ret = xfs_file_dio_aio_write(iocb, from);
> 		if (ret != -EREMCHG))
> 			return ret;
> 	}
> 
> 	ret = xfs_file_buffered_aio_write(iocb, from);

Actually a little more complicated due to the DAX case, and the fact
that both your original and this new version miss the XFS_STATS_ADD
call.  But you get the idea.  While we're at it we should probably
also skil the generic_write_sync call for DAX pure overwrites while
we're at it.
