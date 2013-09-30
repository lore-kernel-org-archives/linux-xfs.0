Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 48BB57F52
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 17:02:40 -0500 (CDT)
Date: Mon, 30 Sep 2013 17:02:36 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/4] xfs: dirent dtype presence is dependent on
	directory magic numbers
Message-ID: <20130930220236.GO1935@sgi.com>
References: <1380497826-13474-1-git-send-email-david@fromorbit.com>
	<1380497826-13474-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1380497826-13474-3-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Mon, Sep 30, 2013 at 09:37:04AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The determination of whether a directory entry contains a dtype
> field originally was dependent on the filesystem having CRCs
> enabled. This meant that the format for dtype beign enabled could be
> determined by checking the directory block magic number rather than
> doing a feature bit check. This was useful in that it meant that we
> didn't need to pass a struct xfs_mount around to functions that
> were already supplied with a directory block header.
> 
> Unfortunately, the introduction of dtype fields into the v4
> structure via a feature bit meant this "use the directory block
> magic number" method of discriminating the dirent entry sizes is
> broken. Hence we need to convert the places that use magic number
> checks to use feature bit checks so that they work correctly and not
> by chance.
> 
> The current code works on v4 filesystems only because the dirent
> size roundup covers the extra byte needed by the dtype field in the
> places where this problem occurs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks fine to me.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
