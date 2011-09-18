Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IK31Xr198465 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:03:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E3531C2345C
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:03:01 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	PMnTqWSfEz3hMZz7 for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:03:01 -0700 (PDT)
Date: Sun, 18 Sep 2011 16:03:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstest: fsstress add EXT2_IOC_{SET,GET}FLAGS
	operations
Message-ID: <20110918200300.GB14899@infradead.org>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
	<1316357699-22692-2-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316357699-22692-2-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Sun, Sep 18, 2011 at 06:54:59PM +0400, Dmitry Monakhov wrote:
> Add two new operations:
> - getattr: ioctl(fd, EXT2_IOC_GETFLAGS, &fl)
> - setattr: ioctl(fd, EXT2_IOC_SETFLAGS, &random_flags)
> By default IOC_SET_SETFLAGS has zero probability because
> it may produce inodes with APPEND or IMMUTABLE flags which
> are not deletable by default. Let's assumes that one who
> enable it knows how to delete such inodes.
> For example like follows:
> find $TEST_PATH -exec chattr -i -a {} \;
> rm -rf $TEST_PATH

In general I like this, but:

 - please provide a testcase actually using this new feature, and
 - please don't require e2fsprogs just for the ioctl subcommands,
   and use the FS_IOC_GET/SETFLAGS names provided by recent kernels
   in fs.h instead.  You might still need an ifdef for old kernels,
   like src/t_immutable.c does.  In fact it might be a good idea
   to just provide the values for them if they aren't present in
   a header shared by fsstress and t_immutable.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
