Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n55AfeEf040084 for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 05:41:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53C961BCBCEF
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 03:41:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WMRJLYiqOjbVEe9T for
	<xfs@oss.sgi.com>; Fri, 05 Jun 2009 03:41:59 -0700 (PDT)
Date: Fri, 5 Jun 2009 06:41:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: fix xfs_quiesce_data
Message-ID: <20090605104157.GA25032@infradead.org>
References: <20090426140305.113371000@bombadil.infradead.org>
	<20090426140708.279368000@bombadil.infradead.org>
	<4A071F06.8040106@sandeen.net>
	<20090511201511.GB14195@infradead.org>
	<20090604094512.GU16929@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090604094512.GU16929@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Jun 04, 2009 at 07:45:12PM +1000, Dave Chinner wrote:
> On Mon, May 11, 2009 at 04:15:11PM -0400, Christoph Hellwig wrote:
> > On Sun, May 10, 2009 at 01:37:58PM -0500, Eric Sandeen wrote:
> > > I guess I too would like a reason for the filestream_flush move
> > > somewhere in the changelog...
> > 
> > Hehe, maybe Dave can chime in.  Or I can test if it actually affects
> > anything and maybe move it out to another patch.  The lack of
> > reliability of the filesystreams tests doesn't make this any easier to
> > test.
> 
> (Just catching up on my mail backlog)
> 
> I think that the filestream_flush() call should actually be after
> the data flush. filestream_flush() is used to clear the filestream
> association cache which holds references to the inodes.
> 
> Where the flush is currently placed is destroying the association
> that defines the AG the data should be written to before the data is
> written. As a result it may not end up in the AG carefully
> associated with the inode during the write() syscall.
> 
> This may be one of the reasons for the filestreams tests failing
> frequently....

Makes sense.  I stil get reliable failures on 171 and 172, but the
others seem to pass with these changes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
