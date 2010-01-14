Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EFetZj012426 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 09:40:55 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 3/3] xfs: clean up inconsistent variable naming
	inxfs_swap_extent
Date: Thu, 14 Jan 2010 09:41:48 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A696B@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1263432836-13368-4-git-send-email-david@fromorbit.com>
From: "Alex Elder" <aelder@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> The swap extent ioctl passes in a target inode and a temporary
> inode which are clearly named in the ioctl structure. The code
> then assigns temp to target and vice versa, making it extremely
> difficult to work out which inode is which later in the code.
> Make this consistent throughout the code.
> 
> Also make xfs_swap_extent static as there are no external users
> of the function.

All three patches in this series look good.

> Signed-off-by: Dave Chinner <david@fromorbit.com>

Reviewed-by: Alex Elder <aelder@sgi.com>

...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
