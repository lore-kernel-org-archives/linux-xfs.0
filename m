Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 10B837CA0
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 08:55:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA14D304032
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 06:55:14 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id fCjLAEQGXroYF2cQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2016 06:55:12 -0800 (PST)
Date: Fri, 11 Mar 2016 15:55:09 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] xfs: optimize bio handling in the buffer writeback
	path
Message-ID: <20160311145509.GB2551@lst.de>
References: <1456302011-18915-1-git-send-email-hch@lst.de>
	<1456302011-18915-4-git-send-email-hch@lst.de>
	<20160303151730.GC57990@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160303151730.GC57990@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Mar 03, 2016 at 10:17:30AM -0500, Brian Foster wrote:
> > +
> > +		/*
> > +		 * For the last bio, bi_private points to the ioend, so we
> > +		 * need to explicitly end the iteration here.
> > +		 */
> 
> Do you mean the last bio is pointed to by the ioend?

No, bio->bi_private of the last bio points to the ioend.

> > @@ -541,10 +457,8 @@ xfs_submit_ioend(
> >  	 * at this point in time.
> >  	 */
> >  error_finish:
> > -	if (ioend->io_bio)
> > -		bio_put(ioend->io_bio);
> > -	ioend->io_error = status;
> > -	xfs_finish_ioend(ioend);
> > +	ioend->io_bio->bi_error = status;
> > +	bio_endio(ioend->io_bio);
> >  	return status;
> 
> bi_end_io is not set here, so what happens to the buffers added to the
> ioend in this case?

We're not calling the end_io function we should be, good catch and fixed.

> Trailing whitespace on the above line.

Ok, fixed.

> And FWIW, I'm not a huge fan of
> open coding both the bio and ioend allocations. It makes it easier to
> distinguish the higher level algorithm from all of the structure
> initialization noise. It looks to me that alloc_ioend() could remain
> mostly as is, using the new bioset allocation, and alloc_ioend_bio()
> could be inlined and renamed to something like init_bio_from_bh() or
> some such.

Hmm, not a huge fan of these single use function in general, but
I'll see if I can do something sensible.

> I'm trying to make sure I grok how this works without knowing much about
> the block layer. So we chain the current bio to the new one, the latter
> becoming the parent, and submit the old one. It looks to me that this
> could result in bio_endio() on the parent, which seems fishy... what am
> I missing? IOW, is it safe to submit bios like this before the entire
> chain is created?

Ignoring this for now and jumping to the next reply..

> > + out_free_ioend_bioset:
> > + 	bioset_free(xfs_ioend_bioset);
> 
> Space before tab ^.

Fixed.

> > + 	bioset_free(xfs_ioend_bioset);
> 
> Space before tab ^.

Fixed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
