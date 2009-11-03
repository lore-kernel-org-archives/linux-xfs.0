Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA3Epcl0167256 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 08:51:39 -0600
Date: Tue, 3 Nov 2009 09:51:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix mmap_sem vs iolock lock order inversion
	inxfs_free_eofblocks
Message-ID: <20091103145152.GB32542@infradead.org>
References: <20091019040346.GB21115@infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83AE5C@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE5C@cf--amer001e--3.americas.sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Nov 02, 2009 at 03:10:33PM -0600, Alex Elder wrote:
> I have a minor suggestion below, but it looks correct to me.
> I tried to get a better idea of what the conditions were
> where mmap_sem would be held by VM when ->release gets
> called, but didn't get to the bottom of that.  If it is
> easily characterized you could mention it in comments.

It's the VMA merging code.  But IMHO that's too much of an
implementation detail to put into the comment here.  Commit message
might be fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
