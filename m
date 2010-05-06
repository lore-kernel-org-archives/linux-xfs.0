Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o46KYr3x130246 for <xfs@oss.sgi.com>; Thu, 6 May 2010 15:34:53 -0500
Date: Thu, 6 May 2010 16:37:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: honor comments in the test group file
Message-ID: <20100506203702.GB6854@infradead.org>
References: <201005061726.o46HQ78v018283@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201005061726.o46HQ78v018283@stout.americas.sgi.com>
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
Cc: xfs@oss.sgi.com

On Thu, May 06, 2010 at 12:26:07PM -0500, Alex Elder wrote:
> (Re-posting unchanged in hopes it will get reviewed this time.)
> 
> There are some spots in the "group" file where test numbers have
> groups listed after a '#' character, clearly intending for those
> groups to be commented out.  But the way the group list gets
> generated that commenting doesn't work, and in fact these tests
> explicitly *are* included in such commented-out groups.
> 
> This patch fixes that, stripping out all comments (which start
> with a '#' character and end with a newline) from the file before
> building the set of test numbers for a group.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
