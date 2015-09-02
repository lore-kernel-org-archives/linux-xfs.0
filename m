Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB21C7F5F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 08:34:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74915AC013
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 06:34:54 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id B35FN6Eyyeblg0Tf for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2015 06:34:52 -0700 (PDT)
Subject: Re: linux-next: manual merge of the block tree with the xfs tree
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <20150902230342.125e23ce@canb.auug.org.au>
References: <20150902121649.7a686b6c@canb.auug.org.au>
	<C57DF728-E46C-433C-AA9D-209557D795E2@filmlight.ltd.uk>
	<20150902230342.125e23ce@canb.auug.org.au>
Date: Wed, 02 Sep 2015 14:34:51 +0100
Message-Id: <1441200891.17400.1277.camel@localhost.localdomain>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-next@vger.kernel.org, Christoph Hellwig <hch@lst.de>


On Wed, 2015-09-02 at 23:03 +1000, Stephen Rothwell wrote:
> Hi Roger,
> 
> On Wed, 2 Sep 2015 10:45:29 +0100 Roger Willcocks <roger@filmlight.ltd.uk> wrote:
> >
> > On 2 Sep 2015, at 03:16, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 

> > > ++	if (!ioend->io_error)
> > > ++		ioend->io_error = bio->bi_error;

> > 
> > This is incorrect; it can clear an earlier error status. It should probably read:
> > 
> >  	if (!ioend->io_error && bio->bi_error)
> >  		ioend->io_error = bio->bi_error;
> 
> Thanks, I will use that from tomorrow.
> 

Huh, now I've had my coffee, that extra check doesn't add anything.
(There's no harm done in assigning zero to io_error if it's already
zero.) Apologies for the noise.

-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
