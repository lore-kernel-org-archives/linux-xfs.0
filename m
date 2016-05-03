Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 508397CA0
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 10:02:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D0E88F8039
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 08:02:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2xSINs6TQqDucO5k (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 May 2016 08:02:21 -0700 (PDT)
Date: Tue, 3 May 2016 11:02:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/8] xfs: implement iomap based buffered write path
Message-ID: <20160503150217.GA8014@bfoster.bfoster>
References: <1460494382-14547-1-git-send-email-hch@lst.de>
	<1460494382-14547-6-git-send-email-hch@lst.de>
	<20160414125814.GE20696@bfoster.bfoster>
	<20160502182523.GB7077@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160502182523.GB7077@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, May 02, 2016 at 08:25:23PM +0200, Christoph Hellwig wrote:
> On Thu, Apr 14, 2016 at 08:58:14AM -0400, Brian Foster wrote:
> > > +static int
> > > +xfs_file_iomap_end_delalloc(
> > > +	struct xfs_inode	*ip,
> > > +	loff_t			offset,
> > > +	loff_t			length,
> > > +	ssize_t			written)
> > > +{
> > > +	struct xfs_mount	*mp = ip->i_mount;
> > > +	xfs_fileoff_t		start_fsb;
> > > +	xfs_fileoff_t		end_fsb;
> > > +	int			error = 0;
> > > +
> > > +	start_fsb = XFS_B_TO_FSB(mp, offset + written);
> > > +	end_fsb = XFS_B_TO_FSB(mp, offset + length - written);
> > > +
> > 
> > Just skimming over this series... but shouldn't this be offset + length?
> > Why walk back from the end of the allocated range?
> 
> Because the interface from the core iomap code need to pass the
> length of the actually mapped range, and the amount of bytes successfully
> written into it to the filesystem, as other filesystems will require
> this for their locking.  We need to convert it back at some point,
> and it seems more logical here than in the caller.
> 

I'm not asking about the interface... or at least I'm not following your
point. I'm just suggesting that the calculation of end_fsb is wrong.
E.g., if the intent is to punch out the range that was allocated but not
written to, shouldn't the range to punch be [offset + written, offset +
length]?

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
