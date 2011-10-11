Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9B2BaiF220399 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 21:11:36 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBBA01B7BF2
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 19:11:34 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	lsGGFH1AWjNqgsER for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 19:11:34 -0700 (PDT)
Date: Tue, 11 Oct 2011 13:11:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfstests: allow 091 for non-xfs filesystems
Message-ID: <20111011021132.GA3159@dastard>
References: <20111010182156.GA1323@infradead.org>
	<20111010182216.GA1335@infradead.org>
	<20111010182233.GB1335@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010182233.GB1335@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 10, 2011 at 02:22:33PM -0400, Christoph Hellwig wrote:
> The tests in 091 are entirely generic and pass e.g. on ext4 and jfs.
> btrfs fails it, but that looks a like a btrfs-specific issue to me.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfstests-dev/091
> ===================================================================
> --- xfstests-dev.orig/091	2011-10-10 18:09:20.000000000 +0000
> +++ xfstests-dev/091	2011-10-10 18:09:41.000000000 +0000
> @@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
>  . ./common.filter
>  
>  # real QA test starts here
> -_supported_fs xfs
> +_supported_fs generic
>  _supported_os Linux IRIX
>  
>  [ $HOSTOS == IRIX ] && _notrun "Not working on IRIX yet"

Given that the test is not run on irix, I'd change the _supported_os
line to just Linux as well, and kill the separate check for Irix
while you are there.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
