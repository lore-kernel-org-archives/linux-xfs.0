Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B2C837F3F
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 16:37:26 -0600 (CST)
Date: Thu, 5 Dec 2013 16:37:25 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] fs: fix iversion handling
Message-ID: <20131205223725.GO1935@sgi.com>
References: <20131119151707.GA13412@infradead.org>
	<20131204212504.GX1935@sgi.com> <20131204220144.1501.13481@ret>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131204220144.1501.13481@ret>
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
To: Chris Mason <clm@fb.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Dec 04, 2013 at 05:01:44PM -0500, Chris Mason wrote:
> Quoting Ben Myers (2013-12-04 16:25:04)
> > Hey Christoph,
> > 
> > On Tue, Nov 19, 2013 at 07:17:07AM -0800, Christoph Hellwig wrote:
> > > Currently notify_change directly updates i_version for size updates,
> > > which not only is counter to how all other fields are updated through
> > > struct iattr, but also breaks XFS, which need inode updates to happen
> > > under its own lock, and synchronized to the structure that gets written
> > > to the log.
> > > 
> > > Remove the update in the common code, and it to btrfs and ext4,
> > > XFS already does a proper updaste internally and currently gets a
> > > double update with the existing code.
> > > 
> > > IMHO this is 3.13 and -stable material and should go in through the XFS
> > > tree.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Does this still need a btrfs ack, or is it ready to go?
> 
> The btrfs parts look good to me.
> 
> Signed-off-by: Chris Mason <clm@fb.com>

Great.  Applied to the xfs tree as per Christoph's suggestion.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
