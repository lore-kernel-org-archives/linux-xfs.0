Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 040FC7F4E
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 15:41:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D5D648F8035
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 13:41:17 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0FeAP5NFsAxclmBS for <xfs@oss.sgi.com>;
	Mon, 06 Oct 2014 13:41:15 -0700 (PDT)
Date: Tue, 7 Oct 2014 07:41:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/16] xfs: xfs_fs_geometry returns a number of bytes to
	copy
Message-ID: <20141006204114.GD2301@dastard>
References: <20141003214758.GY1865@sgi.com>
 <20141003220508.GO1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003220508.GO1865@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

On Fri, Oct 03, 2014 at 05:05:09PM -0500, Ben Myers wrote:
> From: Ben Myers <bpm@sgi.com>
> 
> The versioned xfs_fsop_geom_t will be of variable size.  Make
> xfs_fs_geometry return the number of bytes to copy out to userspace for
> a given version of the structure.

xfs_fs_geometry() should be a void right now - it doesn't return any
error value at all.

Further, the size of the structure that is filled in is determined
by the version of the ioctl being called, not the xfs_fs_geometry()
function. Hence the caller already knows the size of the structure
being used, and hence does not need xfs_fs_geometry() to tell it
that information.

So I don't think this change is necessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
