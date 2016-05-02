Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 311B87CB6
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 13:25:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA923304032
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 11:25:26 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id h0AE9HtJoy73egrb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 May 2016 11:25:25 -0700 (PDT)
Date: Mon, 2 May 2016 20:25:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/8] xfs: implement iomap based buffered write path
Message-ID: <20160502182523.GB7077@lst.de>
References: <1460494382-14547-1-git-send-email-hch@lst.de>
	<1460494382-14547-6-git-send-email-hch@lst.de>
	<20160414125814.GE20696@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160414125814.GE20696@bfoster.bfoster>
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
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Apr 14, 2016 at 08:58:14AM -0400, Brian Foster wrote:
> > +static int
> > +xfs_file_iomap_end_delalloc(
> > +	struct xfs_inode	*ip,
> > +	loff_t			offset,
> > +	loff_t			length,
> > +	ssize_t			written)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	xfs_fileoff_t		start_fsb;
> > +	xfs_fileoff_t		end_fsb;
> > +	int			error = 0;
> > +
> > +	start_fsb = XFS_B_TO_FSB(mp, offset + written);
> > +	end_fsb = XFS_B_TO_FSB(mp, offset + length - written);
> > +
> 
> Just skimming over this series... but shouldn't this be offset + length?
> Why walk back from the end of the allocated range?

Because the interface from the core iomap code need to pass the
length of the actually mapped range, and the amount of bytes successfully
written into it to the filesystem, as other filesystems will require
this for their locking.  We need to convert it back at some point,
and it seems more logical here than in the caller.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
