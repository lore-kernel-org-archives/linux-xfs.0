Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0M8Zvtd061381 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 02:35:57 -0600
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 950F1183FA02
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 00:35:10 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id 57lH3wi7oyyNNWoU for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2009 00:35:10 -0800 (PST)
Date: Thu, 22 Jan 2009 09:35:06 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090122083506.GA5870@alice>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice>
	<20090121035703.GH10158@disturbed>
	<200901211503.07308.nickpiggin@yahoo.com.au>
	<20090122043747.GU10158@disturbed>
	<20090122061158.GA31104@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090122061158.GA31104@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Pavel Machek <pavel@suse.cz>, npiggin@yahoo.com.au, Chris Mason <chris.mason@oracle.com>

* Christoph Hellwig (hch@infradead.org) wrote:
> On Thu, Jan 22, 2009 at 03:37:47PM +1100, Dave Chinner wrote:
> >  xfs_buf_t *
> >  xlog_get_bp(
> >  	xlog_t		*log,
> > -	int		num_bblks)
> > +	int		nbblks)
> 
> Any reason for reanming this variable?  That causes quite a bit of
> churn.
> 
> >  {
> > -	ASSERT(num_bblks > 0);
> > +	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
> > +		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
> 
> And doesn't prevent this line from needing a linebreak to stay under 80
> characters :)
> 
> Except for these nitpicks it looks fine to me.

Just want to report that it fixes the issue for me. Thanks,
i will continue xfs testing.

Greetings, Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
