Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6H7I5dD055838 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 02:18:05 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BqO2uYwrhpCOSV1z (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Jul 2012 00:18:04 -0700 (PDT)
Date: Tue, 17 Jul 2012 03:18:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfs: probe data buffer from page cache for unwritten
	extents
Message-ID: <20120717071802.GA15473@infradead.org>
References: <4FF29C2C.2000407@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FF29C2C.2000407@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 03, 2012 at 03:15:56PM +0800, Jeff Liu wrote:
> Hello,
> 
> This is v3 of the patch.
> 
> We can trigger BUG() in xfs_seek_data() if met two unwritten without data or hole extents at last version.
> So making the extents map reading in loop could solve it.
> 
> Sorry, Am not yet try the repeated holes scenario according to Dave's comments as lack of X64 test env, still
> waiting for it ready.  But this patch is already too long delayed, I have worked it out one weeks ago.
> So I'd like to post it because of it could handle repeated hole/unwritten extents well in a loop, and I also improved
> xfstests:286 with those cases for the verification, will post it soon.
> 
> v2->v3:
> Tested by Mark, hit BUG() for continuous unwritten extents without data wrote.
> * xfs_seek_data(), remove BUG() and having extents map search in loop.

The patch looks good.  But as question by Mark I wonder if it's a good
idea to just improve xfs_seek_data, but not xfs_seek_hole.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
