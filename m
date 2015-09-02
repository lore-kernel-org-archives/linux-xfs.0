Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 05AF07F5F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 08:03:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8494FAC012
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 06:03:47 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id BnHN56XZstNV34So (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Sep 2015 06:03:45 -0700 (PDT)
Date: Wed, 2 Sep 2015 23:03:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the block tree with the xfs tree
Message-ID: <20150902230342.125e23ce@canb.auug.org.au>
In-Reply-To: <C57DF728-E46C-433C-AA9D-209557D795E2@filmlight.ltd.uk>
References: <20150902121649.7a686b6c@canb.auug.org.au>
	<C57DF728-E46C-433C-AA9D-209557D795E2@filmlight.ltd.uk>
MIME-Version: 1.0
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Jens Axboe <axboe@kernel.dk>, David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-next@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Hi Roger,

On Wed, 2 Sep 2015 10:45:29 +0100 Roger Willcocks <roger@filmlight.ltd.uk> wrote:
>
> On 2 Sep 2015, at 03:16, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Today's linux-next merge of the block tree got a conflict in:
> > 
> >  fs/xfs/xfs_aops.c
> > 
> > between commit:
> > 
> >  c9eb256eda44 ("xfs: return errors from partial I/O failures to files")
> > 
> > from the xfs tree and commit:
> > 
> >  4246a0b63bd8 ("block: add a bi_error field to struct bio")
> > 
> > from the block tree.
> > 
> > I fixed it up (I think - see below) and can carry the fix as necessary
> > (no action is required).
> > 
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> > diff --cc fs/xfs/xfs_aops.c
> > index c8637073ef25,c77499bcbd7a..000000000000
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@@ -354,8 -355,7 +353,8 @@@ xfs_end_bio
> >  {
> >  	xfs_ioend_t		*ioend = bio->bi_private;
> > 
> > - 	if (!ioend->io_error && !test_bit(BIO_UPTODATE, &bio->bi_flags))
> > - 		ioend->io_error = error;
> > -	ioend->io_error = bio->bi_error;
> > ++	if (!ioend->io_error)
> > ++		ioend->io_error = bio->bi_error;
> > 
> >  	/* Toss bio and pass work off to an xfsdatad thread */
> >  	bio->bi_private = NULL;
> > 
> > 
> 
> This is incorrect; it can clear an earlier error status. It should probably read:
> 
>  	if (!ioend->io_error && bio->bi_error)
>  		ioend->io_error = bio->bi_error;

Thanks, I will use that from tomorrow.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
