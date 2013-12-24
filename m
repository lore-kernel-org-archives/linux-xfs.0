Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 728B47F8A
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 18:55:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 649728F804C
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 16:55:40 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WM9FcITVdJMc1Cd2 for <xfs@oss.sgi.com>;
	Mon, 23 Dec 2013 16:55:38 -0800 (PST)
Date: Tue, 24 Dec 2013 11:55:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/3] xfs: allow linkat() on O_TMPFILE files
Message-ID: <20131224005536.GM3220@dastard>
References: <1387326161-24530-1-git-send-email-zwu.kernel@gmail.com>
	<1387326161-24530-4-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1387326161-24530-4-git-send-email-zwu.kernel@gmail.com>
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

On Wed, Dec 18, 2013 at 08:22:41AM +0800, Zhi Yong Wu wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> The VFS allows an anonymous temporary file to be named at a later
> time via a linkat() syscall. The inodes for O_TMPFILE files are
> are marked with a special flag I_LINKABLE and have a zero link count.
> 
> To support this in XFS, xfs_link() detects if this flag I_LINKABLE
> is set and behaves appropriately when detected. So in this case,
> its transaciton reservation takes into account the additional
> overhead of removing the inode from the unlinked list. Then the
> inode is removed from the unlinked list and the directory entry
> is added. Finally its link count is bumped accordingly.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
