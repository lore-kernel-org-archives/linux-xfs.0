Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7CE7029DF7
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 08:17:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64DD98F8052
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 06:17:27 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id qUuiRpiiAJSfWJo5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Mar 2014 06:17:05 -0700 (PDT)
Date: Tue, 25 Mar 2014 06:17:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix buffer use after free on IO error
Message-ID: <20140325131705.GB25392@infradead.org>
References: <532CFA12.4040104@redhat.com>
	<20140325125754.GA18691@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140325125754.GA18691@bfoster.bfoster>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

> On Fri, Mar 21, 2014 at 09:48:50PM -0500, Eric Sandeen wrote:
> > +	/*
> > +	 * If _xfs_buf_ioapply failed, we'll get back here with
> > +	 * only the reference we took above.  _xfs_buf_ioend will
> > +	 * drop it to zero, so we'd better not queue it for later,
> > +	 * or we'll free it before it's done.
> > +	 */
> > +	_xfs_buf_ioend(bp, bp->b_error ? 0 : 1);
> >  
> 
> Out of curiosity, is there any major reason we don't use 0 here
> unconditionally? Are we worried about I/O completing before we have a
> chance to decrement the reference?

I think this should unconditionally avoid the schedule, and while we're
at it we should kill _xfs_buf_ioend and opencode it here and at the
other callsite.

Also atomic_dec_and_test really just returns true/false - there should
ne no need for the explicit == 1 in the conditional.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
