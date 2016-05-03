Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 012927CA1
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 13:16:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74A53AC002
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 11:16:02 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id GpZ404KHjRtyjMW0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 May 2016 11:15:58 -0700 (PDT)
Date: Tue, 3 May 2016 20:15:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/8] xfs: implement iomap based buffered write path
Message-ID: <20160503181557.GA22321@lst.de>
References: <1460494382-14547-1-git-send-email-hch@lst.de>
	<1460494382-14547-6-git-send-email-hch@lst.de>
	<20160414125814.GE20696@bfoster.bfoster>
	<20160502182523.GB7077@lst.de>
	<20160503150217.GA8014@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160503150217.GA8014@bfoster.bfoster>
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

On Tue, May 03, 2016 at 11:02:19AM -0400, Brian Foster wrote:
> > Because the interface from the core iomap code need to pass the
> > length of the actually mapped range, and the amount of bytes successfully
> > written into it to the filesystem, as other filesystems will require
> > this for their locking.  We need to convert it back at some point,
> > and it seems more logical here than in the caller.
> > 
> 
> I'm not asking about the interface... or at least I'm not following your
> point. I'm just suggesting that the calculation of end_fsb is wrong.
> E.g., if the intent is to punch out the range that was allocated but not
> written to, shouldn't the range to punch be [offset + written, offset +
> length]?

Oh, yes.  It probably should - let me fix it and re-run xfstests..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
