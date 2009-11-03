Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA3Ejepw166899 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 08:45:42 -0600
Date: Tue, 3 Nov 2009 09:45:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: I/O completion handlers must use NOFS allocations
Message-ID: <20091103144545.GA32542@infradead.org>
References: <20091019040003.GA21115@infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83AE5B@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE5B@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Thomas Neumann <tneumann@users.sourceforge.net>, xfs@oss.sgi.com

On Mon, Nov 02, 2009 at 02:34:01PM -0600, Alex Elder wrote:
> This looks good.  It's kind of too bad the GFP_ flag
> argument had to be added, but I can't think of a cleaner
> way than the way you did it.

The slightly better way would be to set the PF_FSTRANS flag for the
workqueue threads, but the workqueue interfaces that allows setting
these flags were removed a while ago.

> I have one minor suggestion on wording used in a comment,
> but the code looks correct to me.  I verified that--as you
> say--the only place we're doing an allocation in an I/O
> completion handler (i.e., a function called via
> io_end->io_work->func) is in xfs_iomap_write_unwritten(),
> so this fix should cover the only case.

> > +		 * Note that we opencoding the transaction allocation here
> > +		 * to pass KM_NOFS - we can't risk to recurse back into
> 
> 
> How about, "we can't risk recursing back into"

Fine with me.  Do you want me to resend or are you going to fix it up on
fly before applying the patch?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
