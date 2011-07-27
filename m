Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6R6a20q165459 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 01:36:03 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3270F0B34D
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 23:36:10 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id 4UMS3DZsvCHxafjy for
	<xfs@oss.sgi.com>; Tue, 26 Jul 2011 23:36:10 -0700 (PDT)
Date: Wed, 27 Jul 2011 08:35:59 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: xfs compile error with the latest -git
Message-ID: <20110727063559.GB1641@x4.trippels.de>
References: <20110726233246.GA8168@fujiko>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110726233246.GA8168@fujiko>
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
To: Francesco Allertsen <fallertsen@gmail.com>
Cc: Alex Elder <aelder@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>

On 2011.07.27 at 01:32 +0200, Francesco Allertsen wrote:
> Hi all,
>  I have tried to compile the latest -git today and I got the following
> error while compiling the xfs filesystem.
> 
>   CC      fs/xfs/linux-2.6/xfs_iops.o
>   fs/xfs/linux-2.6/xfs_iops.c:1025:14: error: 'xfs_get_acl' undeclared here (not in a function)
> 
> I have bisected the problem and the first bad commit is this one
> 
>   commit 4e34e719e457f2e031297175410fc0bd4016a085
>   Author: Christoph Hellwig <hch@lst.de>
>   Date:   Sat Jul 23 17:37:31 2011 +0200
> 
>   fs: take the ACL checks to common code
> 
>   Replace the ->check_acl method with a ->get_acl method that simply reads an
>   ACL from disk after having a cache miss.  This means we can replace the ACL
>   checking boilerplate code with a single implementation in namei.c.
> 
>   Signed-off-by: Christoph Hellwig <hch@lst.de>
>   Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Could you please solve this problem?  I have attached also the .config
> file if you need it.

It's already solved:  http://lkml.org/lkml/2011/7/26/94
But somehow Linus didn't notice this patch yet.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
