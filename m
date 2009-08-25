Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7PJDDCT219281 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 14:13:23 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3448E30408B
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 12:14:06 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 0/7] inode allocation cleanups
Date: Tue, 25 Aug 2009 14:12:50 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABD0@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090825185644.GA21563@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
Cc: xfs@oss.sgi.com

> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Tuesday, August 25, 2009 1:57 PM
> To: Alex Elder
> Cc: Christoph Hellwig; xfs@oss.sgi.com
> Subject: Re: [PATCH 0/7] inode allocation cleanups
> 
> 
> On Tue, Aug 25, 2009 at 12:57:16PM -0500, Alex Elder wrote:
> > # [PATCH 5/7] xfs: untangle xfs_dialloc   Christoph Hellwig
> >     No cursor cleanup on WANT_CORRUPTED_RETURN() just after 
> "if (pagno == agno)".
> >     (Maybe I'm misreading the patch.)  I realize this is 
> still better than the
> >     ASSERT() in place currently, but maybe it should be 
> WANT_CORRUPTED_GOTO(error0)
> >     instead.
> 
> Good catch, the two in xfs_dialloc should indeed be 
> WANT_CORRUPTED_GOTOs.
> For the one in xfs_ialloc_next_rec.
> 
> 
> Below is the updated version of the patch, still needs to run through
> XFSQA again:
. . .

I did not review this one as carefully, but I see that you changed
those two spots to WANT_CORRUPTED_GOTO() calls and I assume that's
all that's really changed.

Looks good.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
