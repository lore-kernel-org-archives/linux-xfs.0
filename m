Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7246F7F83
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 18:55:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 595108F8050
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 16:55:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6AsMC415mEwOXZBO for <xfs@oss.sgi.com>;
	Mon, 23 Dec 2013 16:55:09 -0800 (PST)
Date: Tue, 24 Dec 2013 11:55:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/3] xfs: add O_TMPFILE support
Message-ID: <20131224005506.GL3220@dastard>
References: <1387326161-24530-1-git-send-email-zwu.kernel@gmail.com>
	<1387326161-24530-3-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1387326161-24530-3-git-send-email-zwu.kernel@gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On Wed, Dec 18, 2013 at 08:22:40AM +0800, Zhi Yong Wu wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Add two functions xfs_create_tmpfile() and xfs_vn_tmpfile()
> to support O_TMPFILE file creation.
> 
> In contrast to xfs_create(), xfs_create_tmpfile() has a different
> log reservation to the regular file creation because there is no
> directory modification, and doesn't check if an entry can be added
> to the directory, but the reservation quotas is required appropriately,
> and finally its inode is added to the unlinked list.
> 
> xfs_vn_tmpfile() add one O_TMPFILE method to VFS interface and directly
> invoke xfs_create_tmpfile().

There's minor stuff I could ask you to change, but I think this is
good enough for initial support of O_TMPFILE.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
