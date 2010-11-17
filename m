Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH9LnJS217558 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 03:21:50 -0600
Date: Wed, 17 Nov 2010 04:23:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/9] xfsrestore: change nrh_t from 32 to 64 bits
Message-ID: <20101117092322.GE17317@infradead.org>
References: <20101116150502.179825893@sgi.com>
	<20101116150703.992326844@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101116150703.992326844@sgi.com>
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Tue, Nov 16, 2010 at 09:05:04AM -0600, wkendall@sgi.com wrote:
> An nrh_t refers to a byte offset in a file containing all the pathname
> components from a dump. At an average filename length of 20
> characters, an nrh_t would overflow on a dump containing ~214 million
> directory entries. Removing this limitation allows xfsrestore to
> handle 4 billion directory entries.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
