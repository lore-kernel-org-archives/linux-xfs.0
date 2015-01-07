Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 629D07F8D
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 04:31:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E7A5CAC001
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 02:31:54 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 7eCRAH3ZEwDy5iSU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 02:31:53 -0800 (PST)
Date: Wed, 7 Jan 2015 11:31:52 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 18/18] xfs: recall pNFS layouts on conflicting access
Message-ID: <20150107103152.GC28783@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-19-git-send-email-hch@lst.de>
	<20150106231846.GE31508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150106231846.GE31508@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Jan 07, 2015 at 10:18:46AM +1100, Dave Chinner wrote:
> On Tue, Jan 06, 2015 at 05:28:41PM +0100, Christoph Hellwig wrote:
> > Recall all outstanding pNFS layouts and truncates, writes and similar extent
> > list modifying operations.
> 
> This is not sufficient to isolate extent manipulations. mmap writes
> can trigger allocation through ->page_mkwrite, and can also trigger
> extent conversion at IO completion without first needing allocation.
> 
> Maybe I'm missing something - this patchset needs some comments
> documenting the locking used in XFS to co-ordinate layout coherency
> at the client side with IO that is in progress for clients with
> overlapping block maps, as well as against server side application
> IO.

Ys, the description was a little to dense.  We only care about extent list
manipulations that remove or change existing block mappings.  Newly
allocated blocks don't concern the pNFS operation.

I'll take care of better documentation.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
