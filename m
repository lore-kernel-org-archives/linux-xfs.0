Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D96B67F5A
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 00:34:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 672D5AC002
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 22:34:24 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	y62RcinXGpb1P2wH for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 22:34:22 -0800 (PST)
Date: Thu, 3 Dec 2015 17:34:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/11] xfsprogs: xfs_repair: fix possible null pointer
	dereference in mark_standalone_inodes
Message-ID: <20151203063408.GA26718@dastard>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-12-git-send-email-t.vivek@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1449055167-19936-12-git-send-email-t.vivek@samsung.com>
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
To: Vivek Trivedi <t.vivek@samsung.com>
Cc: a.sahrawat@samsung.com, pankaj.m@samsung.com, xfs@oss.sgi.com

On Wed, Dec 02, 2015 at 04:49:27PM +0530, Vivek Trivedi wrote:
> Fix possible null pointer dereference in mark_standalone_inodes by
> rearranging and adding ASSERT for null irec.
> Reported by coverity.

Makes no difference if we assert fail or segv, it's the same result.
Hence I don't see any point in adding asserts like this - we don't
do it for the kernel code because it's just noise and it's
essentially the same here...

Just tell coverity to ignore this warnings...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
