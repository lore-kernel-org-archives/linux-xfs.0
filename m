Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C0D287CA0
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 15:59:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79A2930404E
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 13:59:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FoGp5S9SJa8u5jVU (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2016 13:59:27 -0700 (PDT)
Date: Wed, 20 Apr 2016 13:59:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Message-ID: <20160420205923.GA24797@infradead.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49twj26edj.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-block@vger.kernel.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Fri, Apr 15, 2016 at 12:11:36PM -0400, Jeff Moyer wrote:
> > +	if (IS_DAX(inode)) {
> > +		ret = dax_do_io(iocb, inode, iter, offset, blkdev_get_block,
> >  				NULL, DIO_SKIP_DIO_COUNT);
> > +		if (ret == -EIO && (iov_iter_rw(iter) == WRITE))
> > +			ret_saved = ret;
> > +		else
> > +			return ret;
> > +	}
> > +
> > +	ret = __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter, offset,
> >  				    blkdev_get_block, NULL, NULL,
> >  				    DIO_SKIP_DIO_COUNT);
> > +	if (ret < 0 && ret_saved)
> > +		return ret_saved;
> > +
> 
> Hmm, did you just break async DIO?  I think you did!  :)
> __blockdev_direct_IO can return -EIOCBQUEUED, and you've now turned that
> into -EIO.  Really, I don't see a reason to save that first -EIO.  The
> same applies to all instances in this patch.

Yes, there is no point in saving the earlier error - just return the
second error all the time.

E.g.

	ret = dax_io();
	if (dax_need_dio_retry(ret))
		ret = direct_IO();

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
