Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 455337F56
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 18:11:33 -0500 (CDT)
Date: Mon, 21 Oct 2013 18:11:29 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 05/19] xfs: unify directory/attribute format definitions
Message-ID: <20131021231129.GM1935@sgi.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381789085-21923-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Oct 15, 2013 at 09:17:51AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The on-disk format definitions for the directory and attribute
> structures are spread across 3 header files right now, only one of
> which is dedicated to defining on-disk structures and their
> manipulation (xfs_dir2_format.h). Pull all the format definitions
> into a single header file - xfs_da_format.h - and switch all the
> code over to point at that.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

IIRC Christoph had some concerns with this one, but it wasn't very clear
exactly what they were.  This looks ok to me.  Christoph did you have anything
more to add?

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
