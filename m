Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2SFAnsO113741 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 10:10:54 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XzcTzTAp5EF1GtAL (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 08:10:46 -0700 (PDT)
Date: Wed, 28 Mar 2012 11:10:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/10] remove xfsbufd
Message-ID: <20120328151040.GA2487@infradead.org>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120328005337.GH3592@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120328005337.GH3592@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Mar 28, 2012 at 11:53:37AM +1100, Dave Chinner wrote:
> in IO patterns and performance under heavy load here with this
> patch set. it doesn't however, reduce the buffer cache lookups all
> that much on such workloads - about 10% at most - as most of the
> lookups are common from the directory and inode buffer
> modifications. Here's a sample profile:

10% might not be extremly huge, but it's pretty significant.

> This shows that 50% of the lookups from the directory code, 25% from
> the inode btree lookups, 12% from mapping inodes, and 10% from
> reading the AGI buffer during inode allocation. 
> 
> You know, I suspect that we could avoid almost all those AGI buffer
> lookups by moving to a similar in-core log and flush technique that
> the inodes use. We've already got all the information in the struct
> xfs_perag - rearranging it to have a "in-core on disk" structures
> for the AGI, AGF and AGFL would make a lot of the "select an AG"
> code much simpler than having to read and modify the AG buffers
> directly. It might even be possible to do such a change without
> needing to change the on-disk journal format for them...
> 
> I think I'll put that on my list of stuff to do - right next to
> in-core unlinked inode lists....

Sounds fine.  A simple short-term fix might be to simply pin a reference
to the AGI buffers and add a pointer from struct xfs_perag to them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
