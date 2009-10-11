Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9BCvdrH223332 for <xfs@oss.sgi.com>; Sun, 11 Oct 2009 07:57:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 964B3BFEE32
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2009 05:59:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nSfvZS0V6oZ68ssg for
	<xfs@oss.sgi.com>; Sun, 11 Oct 2009 05:59:07 -0700 (PDT)
Date: Sun, 11 Oct 2009 08:59:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.32-rc3 kernel BUG when unmounting quota offed xfs
Message-ID: <20091011125907.GA11627@infradead.org>
References: <4ACD8C9B.5090701@wm.jp.nec.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ACD8C9B.5090701@wm.jp.nec.com>
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
To: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Cc: xfs <xfs@oss.sgi.com>

On Thu, Oct 08, 2009 at 03:54:19PM +0900, Utako Kusaka wrote:
> Hi,
> 
> XFS file system segfaults in 2.6.32-rc3 and 2.6.31.2.
> This problem does not occur with 2.6.30-rc5.
> xfsprogs version is 3.0.3.
> 
> Testcase is:
> # mount -t xfs -o uquota /dev/sda7 mpnt2
> # xfs_quota -x -c off
> # umount /dev/sda7
> Segmentation fault

Thanks a lot Utako-san, I can reproduce the above testcase on latest
mainline.  I'll come back to you with a patch soon.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
