Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o09EXRW4163518 for <xfs@oss.sgi.com>; Sat, 9 Jan 2010 08:33:30 -0600
Date: Sat, 9 Jan 2010 09:34:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfstests: 050: ignore duplicates reported by repquota
Message-ID: <20100109143419.GA9688@infradead.org>
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6933@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6933@cf--amer001e--3.americas.sgi.com>
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

On Fri, Jan 08, 2010 at 12:14:41PM -0600, Alex Elder wrote:
> Arrange to ignore duplicate entries reported by the "repquota"
> xfs_quota command.  This can happen if an id is used more than once
> (such as when two user names are assigned the same uid).
> 
> Since we are already sorting the output we can accomplish this by
> adding the "-u" (unique) option to the sort command.  Shorten some
> long lines while we're at it.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>


Btw, where is patch 2 of the series?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
