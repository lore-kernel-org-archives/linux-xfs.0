Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9M8vBed075618 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 03:57:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 194292AFD9
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 01:58:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Qi06MOEvV5GqLREA for
	<xfs@oss.sgi.com>; Thu, 22 Oct 2009 01:58:46 -0700 (PDT)
Date: Thu, 22 Oct 2009 04:58:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix xfs_quota remove error
Message-ID: <20091022085845.GA1423@infradead.org>
References: <20091022160627r-yamauchi@mail.jp.nec.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091022160627r-yamauchi@mail.jp.nec.com>
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
To: r-yamauchi@vf.jp.nec.com
Cc: xfs@oss.sgi.com

On Thu, Oct 22, 2009 at 04:06:27PM +0900, r-yamauchi@vf.jp.nec.com wrote:
> Hi,
> 
> The xfs_quota returns ENOSYS when remove command is executed.
> My kernel version is 2.6.31 and xfsprogs version is 3.0.3.
> You can reproduce this issue with following steps.
> 
>     # mount -t xfs -o uquota /dev/sda7 /mnt/mp1
>     # xfs_quota -x -c off -c remove
>     XFS_QUOTARM: Function not implemented.
> 
> The remove command is allowed during quotaoff,
> but xfs_xstate() checks whether quota is running, 
> so it leads to ENOSYS.
> 
> To solve this problem, add conditional statement 
> that op is not X_QUOTARM with running check.

Thanks you, the patch looks correct.  I will write an xfstests testcase
based on your above report to make sure we can check for this regression
in the future.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
